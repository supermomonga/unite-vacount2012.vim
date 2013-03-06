" vacount source for unite.vim
" Version:     0.0.1
" Last Change: 2013/03/07
" Author:      supermomonga (@supermomonga)
" Licence:     The MIT License {{{
"     Permission is hereby granted, free of charge, to any person obtaining a copy
"     of this software and associated documentation files (the "Software"), to deal
"     in the Software without restriction, including without limitation the rights
"     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
"     copies of the Software, and to permit persons to whom the Software is
"     furnished to do so, subject to the following conditions:
"
"     The above copyright notice and this permission notice shall be included in
"     all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
"     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
"     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
"     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
"     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
"     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
"     THE SOFTWARE.
" }}}

" define source
function! unite#sources#vacount2012#define()
  return s:source
endfunction

" source
let s:source = {
      \ 'name'  : 'vacount2012',
      \ 'hooks' : {}
      \ }

function! s:source.hooks.on_init(args, context)
  let s:list = exists('s:list') ? s:list : s:getlist()
endfunction


function! s:compare(d1, d2)
  return a:d2.count - a:d1.count
endfunc


function! s:getlist()
  let list = {}
  let source = []
  let dom = webapi#html#parseURL('http://atnd.org/events/33746')
  for tr in dom.find('table').childNodes('tr')
    unlet! tds
    unlet! name
    let tds = tr.childNodes('td')
    if len(tds) == 4
      let name = tds[2].value()[1:-1]
      if name != ''
        let list[name] = has_key(list, name) ? list[name] + 1 : 1
      endif
    endif
  endfor
  for key in keys(list)
    call add(source, {'kind': 'word', 'word': key, 'abbr': printf('%03d - %s', list[key], key) , 'count': list[key]})
  endfor
  return sort(source, 's:compare')
endfunction


function! s:source.gather_candidates(args, context)
  return s:list
endfunction
