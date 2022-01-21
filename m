Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D35549658E
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 20:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbiAUTYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 14:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbiAUTYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 14:24:38 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF02C06173B;
        Fri, 21 Jan 2022 11:24:38 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id r16so8456346ile.8;
        Fri, 21 Jan 2022 11:24:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X33f8QprhihDTeYBQjNSjiR+taM+rMSDjr/FTfh/9Lg=;
        b=NWbrfWgVmEUfzT0Ra176EfL9kEq0xla2A4jLhHShRP8L5KBAB2t4J5Zy/ECoyIu9/B
         K0fnzFciqv6sgMlTKs/kOl+W5tXXXf/LhKn0UUmb+Hdj0S3Quuf6R+NxDApVKb9Ppxwk
         pCPg3BSYQbod3dszfXCfKWyvlG+kt0YCH9YVm0VRr+r/PAbA4Y/K+xorGpEFuSVKWYVR
         dBhY4qcFxH2fHO2/fjoPiseFCxwHlGWa1TVh9m5vGzQPJErAja0wKTkZNEoHJ5PbqitW
         vtoYhqilms0qvzlNazjrwNJF8bWwBU0m1RSVrURLECpLzU1wS5Df5SQ+bJDyJwBHF7I+
         iDYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X33f8QprhihDTeYBQjNSjiR+taM+rMSDjr/FTfh/9Lg=;
        b=ZVlsCV1PKfxCRVbHcpGYIWVv6u2/9oMZDmlGb69eGTcrK4Cy6iqp6WHI4ot8vK4F14
         ZlDvc2TVtbFn8t1/p8SIOhSnTBsvw7RYePjHLqU4RUSHJLQBfYtjMs7TBkyPrQXOBQnQ
         b/L6cks2iDUW2uyibifscIPh+zihvI6Sa/jHJOww52bYzO7lrPxyAeKGL7hkhA1pALH7
         7K+hsHNxeHGSKFCCGesz/+pKZcxH3XZIRtOqSHNOUk0RQzhSg8dsrX9nD5UEHibu6Gcj
         j6oKdIoez7OK0ETOpcFsldlGfTiQDX5v0Jl76XLXOZVOgQ7elS27z4UQN99aocwVRX4T
         xMlw==
X-Gm-Message-State: AOAM531E8r8Fs4JEhWpgWd//C54RdimX9BaMkgCOVgKIT1eQ+eKuUVOq
        iMR800B8Eo/ezvpKoJlF5JrN95a2wJCqOEx7Axk=
X-Google-Smtp-Source: ABdhPJz237yRsNrl2ZRMMh7Mv0QhBTWDSUpDJPltkk7fs8XWzR5M4SeWqUbhWybRiJ0RNTmsoQHk0/bQwaahaSi4geY=
X-Received: by 2002:a05:6e02:1748:: with SMTP id y8mr3024862ill.305.1642793077515;
 Fri, 21 Jan 2022 11:24:37 -0800 (PST)
MIME-Version: 1.0
References: <1642678950-19584-1-git-send-email-alan.maguire@oracle.com> <1642678950-19584-2-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1642678950-19584-2-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 21 Jan 2022 11:24:26 -0800
Message-ID: <CAEf4BzZBWW+ZM+vv=hxF4xvvat7Rtevr7QYFpM8tJOTx8Dmx_g@mail.gmail.com>
Subject: Re: [RFC bpf-next 1/3] libbpf: support function name-based attach for uprobes
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 3:43 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> kprobe attach is name-based, using lookups of kallsyms to translate
> a function name to an address.  Currently uprobe attach is done
> via an offset value as described in [1].  Extend uprobe opts
> for attach to include a function name which can then be converted
> into a uprobe-friendly offset.  The calcualation is done in two
> steps:
>
> - first, determine the symbol address using libelf; this gives us
>   the offset as reported by objdump; then, in the case of local
>   functions
> - subtract the base address associated with the object, retrieved
>   from ELF program headers.
>
> The resultant value is then added to the func_offset value passed
> in to specify the uprobe attach address.  So specifying a func_offset
> of 0 along with a function name "printf" will attach to printf entry.
>
> The modes of operation supported are to attach to a local function
> in a binary - function "foo1" in /usr/bin/foo - or to attach to
> a library function in a shared object - function "malloc" in
> /usr/lib64/libc.so.6.  Because the symbol table values of shared
> object functions in a binary will be 0, we cannot attach to a
> shared object function in a binary ("malloc" in /usr/bin/foo).
>
> [1] https://www.kernel.org/doc/html/latest/trace/uprobetracer.html
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/lib/bpf/libbpf.c | 199 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h |  10 ++-
>  2 files changed, 208 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index fdb3536..6479aae 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -10183,6 +10183,191 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
>         return pfd;
>  }
>
> +/* uprobes deal in relative offsets; subtract the base address associated with
> + * the mapped binary.  See Documentation/trace/uprobetracer.rst for more
> + * details.
> + */
> +static ssize_t find_elf_relative_offset(Elf *elf,  ssize_t addr)
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
> +               if (phdr.p_type != PT_LOAD ||  !(phdr.p_flags & PF_X))

double space after ||

> +                       continue;
> +
> +               seg_start = phdr.p_vaddr;
> +               seg_end = seg_start + phdr.p_memsz;
> +               seg_offset = phdr.p_offset;
> +               if (addr >= seg_start && addr < seg_end)
> +                       return (ssize_t)addr -  seg_start + seg_offset;
> +       }
> +       pr_warn("elf: failed to find prog header containing 0x%lx\n", addr);

%lx will be wrong for ssize_t on some arches, leading to compilation
warnings. But also why addr is signed ssize_t? size_t or long for
simplicity, I guess.

> +       return -ENOENT;
> +}
> +
> +/* Return next ELF section of sh_type after scn, or first of that type
> + * if scn is NULL.
> + */
> +static Elf_Scn *find_elfscn(Elf *elf, int sh_type, Elf_Scn *scn)

elf_find_next_scn_by_type() would be less ambiguous name, IMO (and
sort of following naming convention of other elf_ helpers in libbpf.c)

> +{
> +       Elf64_Shdr *sh;
> +
> +       while ((scn = elf_nextscn(elf, scn)) != NULL) {
> +               sh = elf64_getshdr(scn);

assumptions about 64-bit environment. 64-bit ELF assumption is correct
for BPF ELF binaries, but not for attaching to host binaries (which
could be 32-bit if libbpf is built for 32-bit arch).

> +               if (sh && sh->sh_type == sh_type)
> +                       break;
> +       }
> +       return scn;
> +}
> +
> +/* Find offset of function name in object specified by path.  "name" matches
> + * symbol name or name@@LIB for library functions.
> + */
> +static ssize_t find_elf_func_offset(const char *binary_path, const char *name)
> +{
> +       size_t si, strtabidx, nr_syms;
> +       bool dynamic, is_shared_lib;
> +       char errmsg[STRERR_BUFSIZE];
> +       Elf_Data *symbols = NULL;
> +       int lastbind = -1, fd;
> +       ssize_t ret = -ENOENT;
> +       Elf_Scn *scn = NULL;
> +       const char *sname;
> +       Elf64_Shdr *sh;
> +       GElf_Ehdr ehdr;
> +       Elf *elf;
> +
> +       if (!binary_path) {

probably better to do this check and exit eary in
bpf_program__attach_uprobe_opts()?

> +               pr_warn("name-based attach requires binary_path\n");
> +               return -EINVAL;
> +       }
> +       if (elf_version(EV_CURRENT) == EV_NONE) {
> +               pr_warn("elf: failed to init libelf for %s\n", binary_path);
> +               return -LIBBPF_ERRNO__LIBELF;
> +       }

we already did this when opening BPF ELF, no need to do it again, we
wouldn't get all the way here otherwise

> +       fd = open(binary_path, O_RDONLY | O_CLOEXEC);
> +       if (fd < 0) {
> +               ret = -errno;
> +               pr_warn("failed to open %s: %s\n", binary_path,
> +                       libbpf_strerror_r(ret, errmsg, sizeof(errmsg)));
> +               return ret;
> +       }
> +       elf = elf_begin(fd, ELF_C_READ_MMAP, NULL);
> +       if (!elf) {
> +               pr_warn("elf: could not read elf from %s: %s\n",
> +                       binary_path, elf_errmsg(-1));
> +               close(fd);
> +               return -LIBBPF_ERRNO__FORMAT;
> +       }
> +       if (!gelf_getehdr(elf, &ehdr)) {
> +               pr_warn("elf: failed to get ehdr from %s: %s\n",
> +                       binary_path, elf_errmsg(-1));

try to keep single lines if they are under 100 characters, unnecessary
line wrapping hurts readability

> +               ret = -LIBBPF_ERRNO__FORMAT;
> +               goto out;
> +       }
> +       is_shared_lib = ehdr.e_type == ET_DYN;
> +       dynamic = is_shared_lib;

why both is_shared_lib and dynamic? same value, same meaning

> +retry:
> +       scn = find_elfscn(elf, dynamic ? SHT_DYNSYM : SHT_SYMTAB, NULL);

If I understand correctly, DYNSYM is a subset of SYMTAB, so if you'd
like to attach to non-exported function in shared lib, you still need
to use SYMTAB. So let's use SYMTAB, if it is available, otherwise fall
back to DYNSYM?

> +       if (!scn) {
> +               pr_warn("elf: failed to find symbol table ELF section in %s\n",
> +                       binary_path);
> +               ret = -ENOENT;
> +               goto out;
> +       }
> +
> +       sh = elf64_getshdr(scn);

again, bitness assumptions, you have to stick to gelf APIs for this :(

> +       strtabidx = sh->sh_link;
> +       symbols = elf_getdata(scn, 0);
> +       if (!symbols) {
> +               pr_warn("elf: failed to get symtab section in %s: %s\n",
> +                       binary_path, elf_errmsg(-1));
> +               ret = -LIBBPF_ERRNO__FORMAT;
> +               goto out;
> +       }
> +
> +       lastbind = -1;

last_bind, cur_bind, match_len please stick to naming conventions used
more or less consistently in libbpf

> +       nr_syms = symbols->d_size / sizeof(Elf64_Sym);
> +       for (si = 0; si < nr_syms; si++) {
> +               Elf64_Sym *sym = (Elf64_Sym *)symbols->d_buf + si;
> +               size_t matchlen;
> +               int currbind;
> +
> +               if (ELF64_ST_TYPE(sym->st_info) != STT_FUNC)
> +                       continue;
> +
> +               sname = elf_strptr(elf, strtabidx, sym->st_name);
> +               if (!sname) {
> +                       pr_warn("elf: failed to get sym name string in %s\n",
> +                               binary_path);
> +                       ret = -EIO;
> +                       goto out;
> +               }
> +               currbind = ELF64_ST_BIND(sym->st_info);
> +
> +               /* If matching on func@@LIB, match on everything prior to
> +                * the '@@'; otherwise match on full string.
> +                */
> +               matchlen = strstr(sname, "@@") ? strstr(sname, "@@") - sname :
> +                                                strlen(sname);

remember strstr() result and reuse

> +
> +               if (strlen(name) == matchlen &&

strlen(name) == matchlen is equivalent to non-NULL result of strstr(),
again, remember and use that one instead of unnecessary string
operations

but also isn't strncmp() alone enough?

> +                   strncmp(sname, name, matchlen) == 0) {

invert if condition and continue, reduce nesting

> +                       if (ret >= 0 && lastbind != -1) {
> +                               /* handle multiple matches */
> +                               if (lastbind != STB_WEAK && currbind != STB_WEAK) {
> +                                       /* Only accept one non-weak bind. */
> +                                       pr_warn("elf: additional match for '%s': %s\n",

additional -> ambiguous?

> +                                               sname, name);
> +                                       ret = -LIBBPF_ERRNO__FORMAT;
> +                                       goto out;
> +                               } else if (currbind == STB_WEAK) {
> +                                       /* already have a non-weak bind, and
> +                                        * this is a weak bind, so ignore.
> +                                        */
> +                                       continue;
> +                               }
> +                       }
> +                       ret = sym->st_value;
> +                       lastbind = currbind;
> +               }
> +       }
> +       if (ret == 0) {
> +               if (!dynamic) {
> +                       dynamic = true;
> +                       goto retry;
> +               }

hm.. trying to understand this piece... I can understand trying DYNSYM
first and falling back to SYMTAB (for performance reasons, probably).
But the other way, not entirely clear. Can you explain and leave a
comment?


> +               pr_warn("elf: '%s' is 0 in symbol table; try using shared library path instead of '%s'\n",
> +                        name, binary_path);
> +               ret = -ENOENT;
> +       }
> +       if (ret > 0) {
> +               pr_debug("elf: symbol table match for '%s': 0x%lx\n",
> +                        name, ret);
> +               if (!is_shared_lib)
> +                       ret = find_elf_relative_offset(elf, ret);
> +       }
> +out:
> +       elf_end(elf);
> +       close(fd);
> +       return ret;
> +}
> +
>  LIBBPF_API struct bpf_link *
>  bpf_program__attach_uprobe_opts(const struct bpf_program *prog, pid_t pid,
>                                 const char *binary_path, size_t func_offset,
> @@ -10194,6 +10379,7 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
>         size_t ref_ctr_off;
>         int pfd, err;
>         bool retprobe, legacy;
> +       const char *func_name;
>
>         if (!OPTS_VALID(opts, bpf_uprobe_opts))
>                 return libbpf_err_ptr(-EINVAL);
> @@ -10202,6 +10388,19 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
>         ref_ctr_off = OPTS_GET(opts, ref_ctr_offset, 0);
>         pe_opts.bpf_cookie = OPTS_GET(opts, bpf_cookie, 0);
>
> +       func_name = OPTS_GET(opts, func_name, NULL);
> +       if (func_name) {
> +               ssize_t sym_off;
> +
> +               sym_off = find_elf_func_offset(binary_path, func_name);
> +               if (sym_off < 0) {
> +                       pr_debug("could not find sym offset for %s in %s\n",
> +                                func_name, binary_path);

pr_warn? maybe also prefix with "elf: " like other similar messages
(we also use "failed to" language most consistently, I think)

> +                       return libbpf_err_ptr(sym_off);
> +               }
> +               func_offset += (size_t)sym_off;
> +       }
> +
>         legacy = determine_uprobe_perf_type() < 0;
>         if (!legacy) {
>                 pfd = perf_event_open_probe(true /* uprobe */, retprobe, binary_path,
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 9728551..4675586 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -431,9 +431,17 @@ struct bpf_uprobe_opts {
>         __u64 bpf_cookie;
>         /* uprobe is return probe, invoked at function return time */
>         bool retprobe;
> +       /* name of function name or function@@LIBRARY.  Partial matches

just to clarify the @@LIB handling. If we were using SYMTAB
everywhere, wouldn't exact match still work for shared library symbol
search?

> +        * work for library name, such as printf, printf@@GLIBC.
> +        * To specify function entry, func_offset argument should be 0 and
> +        * func_name should specify function to trace.  To trace an offset
> +        * within the function, specify func_name and use func_offset
> +        * argument to specify argument _within_ the function.
> +        */
> +       const char *func_name;
>         size_t :0;
>  };
> -#define bpf_uprobe_opts__last_field retprobe
> +#define bpf_uprobe_opts__last_field func_name
>
>  /**
>   * @brief **bpf_program__attach_uprobe()** attaches a BPF program
> --
> 1.8.3.1
>
