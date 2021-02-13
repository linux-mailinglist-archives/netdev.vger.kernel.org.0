Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540A731ADAF
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 20:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhBMTMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 14:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhBMTMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 14:12:33 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA064C061574;
        Sat, 13 Feb 2021 11:11:52 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id m20so2244166ilj.13;
        Sat, 13 Feb 2021 11:11:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=ZtNVJ92bg/l02P07gRD/ZGUZuQll+Yi5ETrb0GaIN5M=;
        b=GlBv9LWCMZZunZ2tqLjqnkgsNeHGtOV6Bk6VtlmSxV9BzMNbrwvcXmIIaVduParJOs
         JU057YsFS1yK+MusDOzneSD4oTLYAmNd50O3IWaMYD43N3VTlOT8ICOiah4Kx0F4O6Qg
         1KIJSALhhc6PENV4hM85mfqzRI7ROTwGENf3h4qrWuQ0bmp5vH7ZGkzVYqzmBkyRMgO7
         kIOOqMn535YNVPb3x/vDpRDyazA48GxhFBkeGIj3UgZJhMTYdVNL/ScpB3zvUpr4UYjU
         qBgj99MMWbx/wgXDnycdz9NKQNyXNA0Wg/eMjXIHRhdr1g6sqF1qOfoUvpIm4D6g23Vr
         AFmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=ZtNVJ92bg/l02P07gRD/ZGUZuQll+Yi5ETrb0GaIN5M=;
        b=BPQChgShKbmAqtpSLVfs/LXwQH5Q6S6/+34Idek8mDMDmBepFYsdw1alZqtFzmjchZ
         jIgrSli1iZ58jtL1ZUVN8dug7e4YGSq2ZVZgFRaoNd5EDL2Ywa6SFobK0c3yM3fy2oMl
         Y+lYNkPEPGNVLilTeNd7q1pVXidbp7ee60VanEM8YTyFiAZ53JkBfTQon0UoPkNHBluT
         ozj71ozjhGgjfj4nGP5GbkGDiFlzpXpNubsr2F1F/jZ2z01VwGQFCNsXexTHmbq9D3g1
         mf/DeldAn7g8qfyGpA1zbOH09awet8D0tG2tkZRTJW6PJfZ4k6TZJMoS1DVezI0cfj7z
         50dg==
X-Gm-Message-State: AOAM530SAm4zeK++TTVR91gtev6YEXU41oX/v+KQTaCZmLQFoHeG0ljq
        /eU8/5vHmh9yJ+xiuUp5674Nute+9EVlkU6EqUw=
X-Google-Smtp-Source: ABdhPJxUaQ1rKAs5RzPoP92UNCvVa5+qzPm25mHbU3Xz+KRd+W/QUEPFfAuLRsVhVy0NnOwl2pPvNc/f5sV/yOPe1dU=
X-Received: by 2002:a92:ce46:: with SMTP id a6mr7423373ilr.10.1613243511774;
 Sat, 13 Feb 2021 11:11:51 -0800 (PST)
MIME-Version: 1.0
References: <20210213164648.1322182-1-jolsa@kernel.org>
In-Reply-To: <20210213164648.1322182-1-jolsa@kernel.org>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Sat, 13 Feb 2021 20:11:40 +0100
Message-ID: <CA+icZUWbiN-mibc9MLUOUkAfEuzeSLM+9xiJFqNVd8f+LRVacg@mail.gmail.com>
Subject: Re: [PATCHv2] btf_encoder: Match ftrace addresses within elf functions
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, dwarves@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 13, 2021 at 5:46 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Currently when processing DWARF function, we check its entrypoint
> against ftrace addresses, assuming that the ftrace address matches
> with function's entrypoint.
>
> This is not the case on some architectures as reported by Nathan
> when building kernel on arm [1].
>
> Fixing the check to take into account the whole function not
> just the entrypoint.
>
> Most of the is_ftrace_func code was contributed by Andrii.
>
> [1] https://lore.kernel.org/bpf/20210209034416.GA1669105@ubuntu-m3-large-x86/
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

Tested this v2 together with "btf_encoder: sanitize non-regular int
base type" v2 on top of pahole v1.20

Tested-by: Sedat Dilek <sedat.dilek@gmail.com> # Linux v5.11-rc7+ and
LLVM/Clang v12.0.0-rc1 on x86 (64bit)

- Sedat -

> ---
> v2 changes:
>   - update functions addr directly [Andrii]
>
>  btf_encoder.c | 40 ++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 38 insertions(+), 2 deletions(-)
>
> diff --git a/btf_encoder.c b/btf_encoder.c
> index b124ec20a689..80e896961d4e 100644
> --- a/btf_encoder.c
> +++ b/btf_encoder.c
> @@ -36,6 +36,7 @@ struct funcs_layout {
>  struct elf_function {
>         const char      *name;
>         unsigned long    addr;
> +       unsigned long    size;
>         unsigned long    sh_addr;
>         bool             generated;
>  };
> @@ -98,6 +99,7 @@ static int collect_function(struct btf_elf *btfe, GElf_Sym *sym,
>
>         functions[functions_cnt].name = name;
>         functions[functions_cnt].addr = elf_sym__value(sym);
> +       functions[functions_cnt].size = elf_sym__size(sym);
>         functions[functions_cnt].sh_addr = sh.sh_addr;
>         functions[functions_cnt].generated = false;
>         functions_cnt++;
> @@ -236,6 +238,39 @@ get_kmod_addrs(struct btf_elf *btfe, __u64 **paddrs, __u64 *pcount)
>         return 0;
>  }
>
> +static int is_ftrace_func(struct elf_function *func, __u64 *addrs, __u64 count)
> +{
> +       __u64 start = func->addr;
> +       __u64 addr, end = func->addr + func->size;
> +
> +       /*
> +        * The invariant here is addr[r] that is the smallest address
> +        * that is >= than function start addr. Except the corner case
> +        * where there is no such r, but for that we have a final check
> +        * in the return.
> +        */
> +       size_t l = 0, r = count - 1, m;
> +
> +       /* make sure we don't use invalid r */
> +       if (count == 0)
> +               return false;
> +
> +       while (l < r) {
> +               m = l + (r - l) / 2;
> +               addr = addrs[m];
> +
> +               if (addr >= start) {
> +                       /* we satisfy invariant, so tighten r */
> +                       r = m;
> +               } else {
> +                       /* m is not good enough as l, maybe m + 1 will be */
> +                       l = m + 1;
> +               }
> +       }
> +
> +       return start <= addrs[r] && addrs[r] < end;
> +}
> +
>  static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
>  {
>         __u64 *addrs, count, i;
> @@ -283,10 +318,11 @@ static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
>                  * functions[x]::addr is relative address within section
>                  * and needs to be relocated by adding sh_addr.
>                  */
> -               __u64 addr = kmod ? func->addr + func->sh_addr : func->addr;
> +               if (kmod)
> +                       func->addr += func->sh_addr;
>
>                 /* Make sure function is within ftrace addresses. */
> -               if (bsearch(&addr, addrs, count, sizeof(addrs[0]), addrs_cmp)) {
> +               if (is_ftrace_func(func, addrs, count)) {
>                         /*
>                          * We iterate over sorted array, so we can easily skip
>                          * not valid item and move following valid field into
> --
> 2.29.2
>
