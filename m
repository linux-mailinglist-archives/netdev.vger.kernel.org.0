Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37684DA959
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 05:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245281AbiCPEfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 00:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353544AbiCPEen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 00:34:43 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BD45EBC3;
        Tue, 15 Mar 2022 21:33:28 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id w7so1108944ioj.5;
        Tue, 15 Mar 2022 21:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mr7cK667Gx9nSik3KZBfQ187184JFIrSu1FHUDDOnnI=;
        b=X+IgSWnPq2LZK72PGGh3AVaM6NsShvbo2dtYsO8gYRxZCJb4jQbNb9NPMjzAgqBYaC
         mG1thJNftiPsUKIRR8MvaUkWxbUAfmcnupHE167XP+Z5VInaUz1BoTQS3a92W1Q6ioR+
         OSX4azNNGSsie5PCn7JIpN4SLuGWhyf8esgXsoS7Qkj/IxT9RMsTBZDl9R5/puoK589v
         LjBdNRquQWdrw0UJNLC3WC/OchVJzYNsE37QDrF7g7PjyH34sP2m4teMhyoONb9iZlBP
         DVG9KwHhTw2bnOW7NgB1fOQm3bUKDOPHEszgnD7rHOPtTmwRu6J+q3oJhYSE1dnA93Dl
         Cepg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mr7cK667Gx9nSik3KZBfQ187184JFIrSu1FHUDDOnnI=;
        b=pEyWfAyGj0go9fxWjPCNbcESwY40BlmNbn8W14uzzrC+jd1xMg+L11XMEI6AJXZg8w
         9KLsj0XU3C3WNeJk4JU4STm9/AFXvtLpnfAUXUaw7XK7C47bvtFZMiHmNdoZ5W0nQTZg
         ectFI7BIWm1UNLLo/r5KaqPNxyQIuJh+suBpn9wi1qCTw22YYVAzjqs+Cqmy63a7v55x
         Xsdf4xPWdjxlW++QiasMWSmfgzQNNrXqTjvd+V1Qyo9CNUa3VhjHHi5mcJ9qvPLjCgxb
         NSImC2PG63OhcLwfhEF6ab8m3wOW2jYmxxAWparmDoe8elx0U87+y4IshX6dSSIGeYX3
         DcJg==
X-Gm-Message-State: AOAM533NHiQMEO2rzOqREbBVW2TzkBLrLZ/LBUbz7cxssugb0r5PZM4a
        KVmqgmqkfm3p0NjUVx8GYixRuYqBJTo9fH34B1D3J5t+Fxc=
X-Google-Smtp-Source: ABdhPJwOmbMVbZhbYVgpApE+Agff91hcTe/F1pxzTIsJPsxNjjgp3CIr4qdNAFgSwjXZyd97o2Db04Q9B8T6o0N2oT4=
X-Received: by 2002:a05:6602:185a:b0:645:d914:35e9 with SMTP id
 d26-20020a056602185a00b00645d91435e9mr23362643ioi.154.1647405207317; Tue, 15
 Mar 2022 21:33:27 -0700 (PDT)
MIME-Version: 1.0
References: <1647000658-16149-1-git-send-email-alan.maguire@oracle.com> <1647000658-16149-3-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1647000658-16149-3-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 15 Mar 2022 21:33:16 -0700
Message-ID: <CAEf4BzaS0jTMLA5JnA3dJK2R8eGLGK5HGsVL_4VOdxjDyC_Hqg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 2/5] libbpf: support function name-based
 attach uprobes
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 4:11 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> kprobe attach is name-based, using lookups of kallsyms to translate
> a function name to an address.  Currently uprobe attach is done
> via an offset value as described in [1].  Extend uprobe opts
> for attach to include a function name which can then be converted
> into a uprobe-friendly offset.  The calcualation is done in
> several steps:
>
> 1. First, determine the symbol address using libelf; this gives us
>    the offset as reported by objdump
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

See some nits below, overall looks great. I have a temptation to move
all the uprobe-specific code (including bpf_program__attach_uprobe()
API) into a dedicated uprobe.c. Or maybe even all the tracing stuff
(tracepoints, perf_event, kprobe, uprobe) into tracing.c. We don't
have to do it right now, but I think we'll inevitably end up doing
this, as libbpf.c is huge and does a lot of different things already,
so adding more to it for uprobe code seems wrong.

>  tools/lib/bpf/libbpf.c | 310 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h |  10 +-
>  2 files changed, 319 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index b577577..2b50b01 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -10320,6 +10320,302 @@ static int perf_event_uprobe_open_legacy(const char *probe_name, bool retprobe,
>         return pfd;
>  }
>
> +/* uprobes deal in relative offsets; subtract the base address associated with
> + * the mapped binary.  See Documentation/trace/uprobetracer.rst for more
> + * details.
> + */
> +static long elf_find_relative_offset(Elf *elf, long addr)
> +{
> +       size_t n;
> +       int i;
> +
> +       if (elf_getphdrnum(elf, &n)) {
> +               pr_warn("elf: failed to find program headers: %s\n",
> +                       elf_errmsg(-1));

nit: fits single line, prefer single lines when possible (up to 100
characters is totally ok)

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

same about single line

> +                       return -ENOENT;
> +               }
> +               if (phdr.p_type != PT_LOAD || !(phdr.p_flags & PF_X))
> +                       continue;
> +
> +               seg_start = phdr.p_vaddr;
> +               seg_end = seg_start + phdr.p_memsz;
> +               seg_offset = phdr.p_offset;
> +               if (addr >= seg_start && addr < seg_end)
> +                       return addr - seg_start + seg_offset;
> +       }
> +       pr_warn("elf: failed to find prog header containing 0x%lx\n", addr);

all these warnings in this function would benefit from specifying in
which particular binary we failed to find something, maybe let's pass
`const char *filename` and use that for errors?

> +       return -ENOENT;
> +}
> +
> +/* Return next ELF section of sh_type after scn, or first of that type
> + * if scn is NULL, and if name is non-NULL, both name and type must match.
> + */
> +static Elf_Scn *elf_find_next_scn_by_type_name(Elf *elf, int sh_type, const char *name,
> +                                              Elf_Scn *scn)
> +{
> +       size_t shstrndx;
> +
> +       if (name && elf_getshdrstrndx(elf, &shstrndx)) {
> +               pr_debug("elf: failed to get section names section index: %s\n",
> +                        elf_errmsg(-1));
> +               return NULL;
> +       }
> +
> +       while ((scn = elf_nextscn(elf, scn)) != NULL) {
> +               const char *sname;
> +               GElf_Shdr sh;
> +
> +               if (!gelf_getshdr(scn, &sh))
> +                       continue;
> +               if (sh.sh_type != sh_type)
> +                       continue;
> +
> +               if (!name)
> +                       return scn;
> +
> +               sname = elf_strptr(elf, shstrndx, sh.sh_name);
> +               if (sname && strcmp(sname, name) == 0)
> +                       return scn;
> +       }
> +       return NULL;
> +}
> +
> +/* For Position-Independent Code-based libraries, a table of trampolines (Procedure Linking Table)
> + * is used to support resolution of symbol names at linking time.  The goal here is to find the
> + * offset associated with the jump to the actual library function, since consumers of the
> + * library function within the binary will jump to the plt table entry (malloc@plt) first.
> + * If we can instrument that .plt entry locally in the specific binary (rather than instrumenting
> + * glibc say), overheads are greatly reduced.
> + *
> + * However, we need to find the index into the .plt table.  There are two parts to this.
> + *
> + * First, we have to find the index that the .plt entry (malloc@plt) lives at.  To do that,
> + * we use the .rela.plt table, which consists of entries in the same order as the .plt,
> + * but crucially each entry contains the symbol index from the symbol table.  This allows
> + * us to match the index of the .plt entry to the desired library function.
> + *
> + * Second, we need to find the address associated with that indexed .plt entry.
> + * The .plt section provides section information about the overall section size and the
> + * size of each .plt entry.  However prior to the entries themselves, there is code
> + * that carries out the dynamic linking, and this code may not be the same size as the
> + * .plt entry size (it happens to be on x86_64, but not on aarch64).  So we have to
> + * determine that initial code size so we can index into the .plt entries that follow it.
> + * To do this, we simply subtract the .plt table size (nr_plt_entries * entry_size)
> + * from the overall section size, and then use that offset as the base into the array
> + * of .plt entries.
> + */
> +static ssize_t elf_find_plt_offset(Elf *elf, size_t sym_idx)
> +{
> +       long plt_entry_sz, plt_sz, plt_base;
> +       Elf_Scn *rela_plt_scn, *plt_scn;
> +       size_t plt_idx, nr_plt_entries;
> +       Elf_Data *rela_data;
> +       GElf_Shdr sh;
> +
> +       /* First get .plt index and table size via .rela.plt */
> +       rela_plt_scn = elf_find_next_scn_by_type_name(elf, SHT_RELA, ".rela.plt", NULL);
> +       if (!rela_plt_scn) {
> +               pr_debug("elf: failed to find .rela.plt section\n");

see above, knowing which file we failed to find it in would be useful
(especially with full path resolution where user might not know for
sure which specific binary libbpf decided to process). So same as for
other functions, let's pass `const char *filename` and use it in error
messages?

> +               return -LIBBPF_ERRNO__FORMAT;
> +       }
> +       if (!gelf_getshdr(rela_plt_scn, &sh)) {
> +               pr_debug("elf: failed to get shdr for .rela.plt section\n");
> +               return -LIBBPF_ERRNO__FORMAT;
> +       }
> +       rela_data = elf_getdata(rela_plt_scn, 0);
> +       if (!rela_data) {
> +               pr_debug("elf: failed to get data for .rela.plt section\n");
> +               return -LIBBPF_ERRNO__FORMAT;
> +       }
> +       nr_plt_entries = sh.sh_size / sh.sh_entsize;
> +       for (plt_idx = 0; plt_idx < nr_plt_entries; plt_idx++) {
> +               GElf_Rela rela;
> +
> +               if (!gelf_getrela(rela_data, plt_idx, &rela))
> +                       continue;
> +               if (GELF_R_SYM(rela.r_info) == sym_idx)
> +                       break;
> +       }
> +       if (plt_idx == nr_plt_entries) {
> +               pr_debug("elf: could not find sym index %ld in .rela.plt section\n",

size_t => %zu

> +                        sym_idx);
> +               return -LIBBPF_ERRNO__FORMAT;
> +       }
> +
> +       /* Now determine base of .plt table and calculate where entry for function is */
> +       plt_scn = elf_find_next_scn_by_type_name(elf, SHT_PROGBITS, ".plt", NULL);
> +       if (!plt_scn || !gelf_getshdr(plt_scn, &sh)) {
> +               pr_debug("elf: failed to find .plt section\n");
> +               return -LIBBPF_ERRNO__FORMAT;
> +       }
> +       plt_base = sh.sh_addr;
> +       plt_entry_sz = sh.sh_entsize;
> +       plt_sz = sh.sh_size;
> +       if (nr_plt_entries * plt_entry_sz >= plt_sz) {

if (plt_entry_sz == 0 || nr_plt_entries >= plt_sz / plt_entry_sz)

would be equivalent, but doesn't suffer from overflow and invalid sh_entsize

> +               pr_debug("elf: failed to calculate base .plt entry size with %ld plt entries\n",
> +                        nr_plt_entries);

%zu, this is a guaranteed compilation warning and a hassle for me to
fix this up during next Github sync, please pay attention to things
like this (and please double check all other case in case I missed
some)

> +               return -LIBBPF_ERRNO__FORMAT;
> +       }
> +       plt_base += plt_sz - (nr_plt_entries * plt_entry_sz);
> +
> +       return plt_base + (plt_idx * plt_entry_sz);
> +}

nit: unnecessary () in above two expressions

> +
> +/* Find offset of function name in object specified by path.  "name" matches
> + * symbol name or name@@LIB for library functions.
> + */
> +static long elf_find_func_offset(const char *binary_path, const char *name)
> +{

[...]

> +               for (idx = 0; idx < nr_syms; idx++) {
> +                       int curr_bind;
> +                       GElf_Sym sym;
> +
> +                       if (!gelf_getsym(symbols, idx, &sym))
> +                               continue;
> +
> +                       if (GELF_ST_TYPE(sym.st_info) != STT_FUNC)
> +                               continue;
> +
> +                       sname = elf_strptr(elf, strtabidx, sym.st_name);
> +                       if (!sname)
> +                               continue;
> +
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

recalculating strlen() isn't unnecessary. Might not be a big deal, but
you can as well write the same simply as

if (!is_name_qualified && sname[name_len] != '\0' && sname[name_len] != '@')
    continue;

right?

> +                               continue;
> +
> +                       if (ret >= 0) {
> +                               /* handle multiple matches */
> +                               if (last_bind != STB_WEAK && curr_bind != STB_WEAK) {
> +                                       /* Only accept one non-weak bind. */
> +                                       pr_warn("elf: ambiguous match for '%s': %s\n",
> +                                               sname, name);

add binary_path like in all the previous error messages?

> +                                       ret = -LIBBPF_ERRNO__FORMAT;
> +                                       goto out;
> +                               } else if (curr_bind == STB_WEAK) {
> +                                       /* already have a non-weak bind, and
> +                                        * this is a weak bind, so ignore.
> +                                        */
> +                                       continue;
> +                               }
> +                       }
> +                       ret = sym.st_value;
> +                       last_bind = curr_bind;
> +                       sym_idx = idx;
> +               }
> +               /* The index of the entry in SHT_DYNSYM helps find .plt entry */
> +               if (ret == 0 && sh_types[i] == SHT_DYNSYM)
> +                       ret = elf_find_plt_offset(elf, sym_idx);
> +               /* For binaries that are not shared libraries, we need relative offset */
> +               if (ret > 0 && !is_shared_lib)
> +                       ret = elf_find_relative_offset(elf, ret);
> +               if (ret > 0)
> +                       break;
> +       }
> +
> +       if (ret > 0) {
> +               pr_debug("elf: symbol address match for '%s': 0x%lx\n", name, ret);

forgot to log binary_path ;)

> +       } else {
> +               if (ret == 0) {
> +                       pr_warn("elf: '%s' is 0 in symtab for '%s': %s\n", name, binary_path,
> +                               is_shared_lib ? "should not be 0 in a shared library" :
> +                                               "try using shared library path instead");
> +                       ret = -ENOENT;
> +               } else {
> +                       pr_warn("elf: failed to find symbol '%s' in '%s'\n", name, binary_path);
> +               }
> +       }
> +out:
> +       elf_end(elf);
> +       close(fd);
> +       return ret;
> +}
> +
>  /* Get full path to program/shared library. */
>  static int resolve_full_path(const char *file, char *result, size_t result_sz)
>  {
> @@ -10371,6 +10667,7 @@ static int resolve_full_path(const char *file, char *result, size_t result_sz)
>         size_t ref_ctr_off;
>         int pfd, err;
>         bool retprobe, legacy;
> +       const char *func_name;
>
>         if (!OPTS_VALID(opts, bpf_uprobe_opts))
>                 return libbpf_err_ptr(-EINVAL);
> @@ -10387,6 +10684,19 @@ static int resolve_full_path(const char *file, char *result, size_t result_sz)
>                 }
>                 binary_path = full_binary_path;
>         }
> +       func_name = OPTS_GET(opts, func_name, NULL);
> +       if (func_name) {
> +               long sym_off;
> +
> +               if (!binary_path) {
> +                       pr_warn("name-based attach requires binary_path\n");
> +                       return libbpf_err_ptr(-EINVAL);
> +               }
> +               sym_off = elf_find_func_offset(binary_path, func_name);
> +               if (sym_off < 0)
> +                       return libbpf_err_ptr(sym_off);

no need to use libbpf_err_ptr()

> +               func_offset += (size_t)sym_off;

is cast needed?

> +       }
>
>         legacy = determine_uprobe_perf_type() < 0;
>         if (!legacy) {
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index c1b0c2e..85c93e2 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -436,9 +436,17 @@ struct bpf_uprobe_opts {
>         __u64 bpf_cookie;
>         /* uprobe is return probe, invoked at function return time */
>         bool retprobe;
> +       /* name of function name or function@@LIBRARY.  Partial matches

"name of function name" reads poorly. "Function name to attach to.
Could be unqualified ("abc") or library-qualified ("abc@LIBXYZ")
name." A bit more verbose, but should be easier to understand
acceptable inputs?


> +        * work for library functions, such as printf, printf@@GLIBC.
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
