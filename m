Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFDE84A9FDB
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 20:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbiBDTRf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 14:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbiBDTRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 14:17:35 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1A9C061714;
        Fri,  4 Feb 2022 11:17:35 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id i1so5695041ils.5;
        Fri, 04 Feb 2022 11:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JID7H3epxwVjACcBC0fkY+Tg7rQGMYqfzeJAUH8nbmE=;
        b=Arh7PHZ3pa8hZ4XnuekXX9XV3iAdg29yOeSodMMtkYW4PQHuVNWZnDl5euyZlprbtk
         XaPPtp7EndAB03JTXoxPWiGHcUp9NYEtlqU49S4v5oPa09oQp4EpyEuBd4kMhhPypmh9
         /SKEH1MO946oykW3UKicAsPXWC+6Z+URPEfj5jGOcqL0QqLYbCBxNYJkqh9HrOhS+Qvu
         WRJ/JZL09djPp2fvMvAWcV4ygenqeab31JDNrclZvEwk69XuWgHi7CghLTmZrdMt3wTV
         0EEQ2Q05VqktcRowj91Sf7RcIgNsptXiD99aYn08V0C3vtcUJ+W78UBtRHqFag0Wa/mO
         eE/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JID7H3epxwVjACcBC0fkY+Tg7rQGMYqfzeJAUH8nbmE=;
        b=5JAyvLkEkfFAn2s66/sV2s1zoo05y3Ju0csdje0l2L5xIFcG71sZSyfdNEAigScji7
         HB9/1lFiZwLi94nla6BvlEdkisIjZ1Id+UReTns3czMJ9KwCsIgHVkrbHwX7VfqUXJTj
         uBBWTKSHP3gv3YU7FFrGx9fd6XaHt39HYLgjvku10nlkBDWOxEje9TTbCVn25hsniysZ
         nOYFg6FDTDdaTpll5r415j83tTUFStu0zRAwXsenuok2BPqYeh10rwxJBZEzWmSnz0Cx
         utUK2Hsj7nipuMh+KzcXq7W4SqETzPbc0bB5lDhcR0cX0xuvJrR0HyPxau0lopkxFGEu
         hqiw==
X-Gm-Message-State: AOAM533N56lsJEHYqOQqigB8Z4jINs+sfdr7GZvjvGJ3EI8avOs5xyRk
        uQsOCqCYA/WR4MEobjtz62KDLMIXp8lTBXg4k6o=
X-Google-Smtp-Source: ABdhPJx4U38rXewWW3L5fg+YvX+UHz/Ys7C9iL93vyEhLOLkTlvlB8KUCxC+3qWNGVJg9exuAw8rEaBes0hqpgPTIbU=
X-Received: by 2002:a05:6e02:190e:: with SMTP id w14mr317529ilu.71.1644002253340;
 Fri, 04 Feb 2022 11:17:33 -0800 (PST)
MIME-Version: 1.0
References: <1643645554-28723-1-git-send-email-alan.maguire@oracle.com> <1643645554-28723-2-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1643645554-28723-2-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Feb 2022 11:17:22 -0800
Message-ID: <CAEf4BzY-Q1SbrKXg-9GZ=2=Gh9kxocmzksn8Xib+rJYs+WSGiQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/4] libbpf: support function name-based
 attach uprobes
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 8:13 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> kprobe attach is name-based, using lookups of kallsyms to translate
> a function name to an address.  Currently uprobe attach is done
> via an offset value as described in [1].  Extend uprobe opts
> for attach to include a function name which can then be converted
> into a uprobe-friendly offset.  The calcualation is done in
> several steps:
>
> 1. First, determine the symbol address using libelf; this gives us
>    the offset as reported by objdump; then, in the case of local
>    functions
> 2. If the function is a shared library function - and the binary
>    provided is a shared library - no further work is required;
>    the address found is the required address
> 3. If the function is a shared library function in a program
>    (as opposed to a shared library), the Procedure Linking Table
>    (PLT) table address is found (it is indexed via the dynamic
>    symbol table index).  This allows us to instrument a call
>    to a shared library function locally in the calling binary,
>    reducing overhead versus having a breakpoint in global lib.
> 4. Finally, if the function is local, subtract the base address
>    associated with the object, retrieved from ELF program headers.
>
> The resultant value is then added to the func_offset value passed
> in to specify the uprobe attach address.  So specifying a func_offset
> of 0 along with a function name "printf" will attach to printf entry.
>
> The modes of operation supported are then
>
> 1. to attach to a local function in a binary; function "foo1" in
>    "/usr/bin/foo"
> 2. to attach to a shared library function in a binary;
>    function "malloc" in "/usr/bin/foo"
> 3. to attach to a shared library function in a shared library -
>    function "malloc" in libc.
>
> [1] https://www.kernel.org/doc/html/latest/trace/uprobetracer.html
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---

This looks great and very clean. I left a few nits, but otherwise it
looks ready (still need to go through the rest of the patches)

>  tools/lib/bpf/libbpf.c | 250 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h |  10 +-
>  2 files changed, 259 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 4ce94f4..eb95629 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -10203,6 +10203,241 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
>         return pfd;
>  }
>
> +/* uprobes deal in relative offsets; subtract the base address associated with
> + * the mapped binary.  See Documentation/trace/uprobetracer.rst for more
> + * details.
> + */
> +static long elf_find_relative_offset(Elf *elf,  long addr)

nit: too many spaces after comma

> +{
> +       size_t n;
> +       int i;
> +
> +       if (elf_getphdrnum(elf, &n)) {
> +               pr_warn("elf: failed to find program headers: %s\n",
> +                       elf_errmsg(-1));
> +               return -ENOENT;
> +       }
> +
> +       for (i = 0; i < n; i++) {
> +               int seg_start, seg_end, seg_offset;
> +               GElf_Phdr phdr;
> +
> +               if (!gelf_getphdr(elf, i, &phdr)) {
> +                       pr_warn("elf: failed to get program header %d: %s\n",
> +                               i, elf_errmsg(-1));
> +                       return -ENOENT;
> +               }
> +               if (phdr.p_type != PT_LOAD || !(phdr.p_flags & PF_X))
> +                       continue;
> +
> +               seg_start = phdr.p_vaddr;
> +               seg_end = seg_start + phdr.p_memsz;
> +               seg_offset = phdr.p_offset;
> +               if (addr >= seg_start && addr < seg_end)
> +                       return addr -  seg_start + seg_offset;

nit: double space before seg_start

> +       }
> +       pr_warn("elf: failed to find prog header containing 0x%lx\n", addr);
> +       return -ENOENT;
> +}
> +
> +/* Return next ELF section of sh_type after scn, or first of that type
> + * if scn is NULL.
> + */
> +static Elf_Scn *elf_find_next_scn_by_type(Elf *elf, int sh_type, Elf_Scn *scn)
> +{
> +       while ((scn = elf_nextscn(elf, scn)) != NULL) {
> +               GElf_Shdr sh;
> +
> +               if (!gelf_getshdr(scn, &sh))
> +                       continue;
> +               if (sh.sh_type == sh_type)
> +                       break;
> +       }
> +       return scn;
> +}
> +
> +/* For Position-Independent Code-based libraries, a table of trampolines
> + * (Procedure Linking Table) is used to support resolution of symbol
> + * names at linking time.  The goal here is to find the offset associated
> + * with the jump to the actual library function.  If we can instrument that
> + * locally in the specific binary (rather than instrumenting glibc say),
> + * overheads are greatly reduced.
> + *
> + * The method used is to find the .plt section and determine the offset
> + * of the relevant entry (given by the base address plus the index
> + * of the function multiplied by the size of a .plt entry).
> + */
> +static ssize_t elf_find_plt_offset(Elf *elf, size_t ndx)

nit: ndx -> func_idx? libbpf generally uses "idx" naming, "ndx" is
purely libelf's convention (and it is more obvious if it is explicitly
called out that it's index of a function entry)

> +{
> +       Elf_Scn *scn = NULL;
> +       size_t shstrndx;
> +
> +       if (elf_getshdrstrndx(elf, &shstrndx)) {
> +               pr_debug("elf: failed to get section names section index: %s\n",
> +                        elf_errmsg(-1));
> +               return -LIBBPF_ERRNO__FORMAT;
> +       }
> +       while ((scn = elf_find_next_scn_by_type(elf, SHT_PROGBITS, scn))) {
> +               long plt_entry_sz, plt_base;
> +               const char *name;
> +               GElf_Shdr sh;
> +
> +               if (!gelf_getshdr(scn, &sh))
> +                       continue;
> +               name = elf_strptr(elf, shstrndx, sh.sh_name);
> +               if (!name || strcmp(name, ".plt") != 0)
> +                       continue;

Wouldn't it be simpler to use elf_sec_by_name(elf, ".plt") and then
Shdr and check PROGBITS? Given there will be only one .plt, it makes
more sense than this while loop?

> +               plt_base = sh.sh_addr;
> +               plt_entry_sz = sh.sh_entsize;
> +               return plt_base + (ndx * plt_entry_sz);
> +       }
> +       pr_debug("elf: no .plt section found\n");

Do we really need this, especially without a binary path?

> +       return -LIBBPF_ERRNO__FORMAT;
> +}
> +
> +/* Find offset of function name in object specified by path.  "name" matches
> + * symbol name or name@@LIB for library functions.
> + */
> +static long elf_find_func_offset(const char *binary_path, const char *name)
> +{
> +       int fd, i, sh_types[2] = { SHT_DYNSYM, SHT_SYMTAB };
> +       bool is_shared_lib, is_name_qualified;
> +       size_t name_len, sym_ndx = -1;
> +       char errmsg[STRERR_BUFSIZE];
> +       long ret = -ENOENT;
> +       GElf_Ehdr ehdr;
> +       Elf *elf;
> +
> +       fd = open(binary_path, O_RDONLY | O_CLOEXEC);
> +       if (fd < 0) {
> +               ret = -errno;
> +               pr_warn("failed to open %s: %s\n", binary_path,
> +                       libbpf_strerror_r(ret, errmsg, sizeof(errmsg)));
> +               return ret;
> +       }
> +       elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
> +       if (!elf) {
> +               pr_warn("elf: could not read elf from %s: %s\n", binary_path, elf_errmsg(-1));
> +               close(fd);
> +               return -LIBBPF_ERRNO__FORMAT;
> +       }
> +       if (!gelf_getehdr(elf, &ehdr)) {
> +               pr_warn("elf: failed to get ehdr from %s: %s\n", binary_path, elf_errmsg(-1));
> +               ret = -LIBBPF_ERRNO__FORMAT;
> +               goto out;
> +       }
> +       /* for shared lib case, we do not need to calculate relative offset */
> +       is_shared_lib = ehdr.e_type == ET_DYN;
> +
> +       name_len = strlen(name);
> +       /* Does name specify "@@LIB"? */
> +       is_name_qualified = strstr(name, "@@") != NULL;
> +
> +       /* Search SHT_DYNSYM, SHT_SYMTAB for symbol.  This search order is used because if
> +        * the symbol is found in SHY_DYNSYM, the index in that table tells us which index
> +        * to use in the Procedure Linking Table to instrument calls to the shared library
> +        * function, but locally in the binary rather than in the shared library ifself.

typo: itself

> +        * If a binary is stripped, it may also only have SHT_DYNSYM, and a fully-statically
> +        * linked binary may not have SHT_DYMSYM, so absence of a section should not be
> +        * reported as a warning/error.
> +        */
> +       for (i = 0; i < ARRAY_SIZE(sh_types); i++) {
> +               size_t strtabidx, ndx, nr_syms;
> +               Elf_Data *symbols = NULL;
> +               Elf_Scn *scn = NULL;
> +               int last_bind = -1;
> +               const char *sname;
> +               GElf_Shdr sh;
> +
> +               scn = elf_find_next_scn_by_type(elf, sh_types[i], NULL);
> +               if (!scn) {
> +                       pr_debug("elf: failed to find symbol table ELF sections in %s\n",
> +                                binary_path);

you consistently used '%s' for binary_path, let's do that here as well

> +                       continue;
> +               }
> +               if (!gelf_getshdr(scn, &sh))
> +                       continue;
> +               strtabidx = sh.sh_link;
> +               symbols = elf_getdata(scn, 0);
> +               if (!symbols) {
> +                       pr_warn("elf: failed to get symbols for symtab section in %s: %s\n",
> +                               binary_path, elf_errmsg(-1));

and here

> +                       ret = -LIBBPF_ERRNO__FORMAT;
> +                       goto out;
> +               }
> +               nr_syms = symbols->d_size / sh.sh_entsize;
> +
> +               for (ndx = 0; ndx < nr_syms; ndx++) {
> +                       int curr_bind;
> +                       GElf_Sym sym;
> +
> +                       if (!gelf_getsym(symbols, ndx, &sym))
> +                               continue;
> +                       if (GELF_ST_TYPE(sym.st_info) != STT_FUNC)
> +                               continue;
> +
> +                       sname = elf_strptr(elf, strtabidx, sym.st_name);
> +                       if (!sname)
> +                               continue;
> +                       curr_bind = GELF_ST_BIND(sym.st_info);
> +
> +                       /* User can specify func, func@@LIB or func@@LIB_VERSION. */
> +                       if (strncmp(sname, name, name_len) != 0)
> +                               continue;
> +                       /* ...but we don't want a search for "foo" to match 'foo2" also, so any
> +                        * additional characters in sname should be of the form "@@LIB".
> +                        */
> +                       if (!is_name_qualified && strlen(sname) > name_len &&
> +                           sname[name_len] != '@')
> +                               continue;

if both the symbol name and requested function name have @ in them,
what should be the comparison rule? Shouldn't it be an exact match
including '@@' and part after it?

> +
> +                       if (ret >= 0 && last_bind != -1) {

if ret >= 0, last_bind can't be invalid, so let's drop the last_bind check here

> +                               /* handle multiple matches */
> +                               if (last_bind != STB_WEAK && curr_bind != STB_WEAK) {
> +                                       /* Only accept one non-weak bind. */
> +                                       pr_warn("elf: ambiguous match for '%s': %s\n",
> +                                               sname, name);
> +                                       ret = -LIBBPF_ERRNO__FORMAT;
> +                                       goto out;

[...]
