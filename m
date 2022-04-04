Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF4F44F0D5F
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 03:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376850AbiDDBRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 21:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376846AbiDDBRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 21:17:01 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AD633368;
        Sun,  3 Apr 2022 18:15:05 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id b16so9586564ioz.3;
        Sun, 03 Apr 2022 18:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0BcvnxIMRjV1P2xmBijE6nS7xl0bsgVGIfXXeLWC2xM=;
        b=K58FZsvgX6+B7ldXoQZLR43DyF+YNukoDfDCyjQw1NVjv1xZxHZAxH4Vjv89xXo/m2
         r0yugUg3pD7c2hlODSLQtFYvB830kBMwg7/qpmvnTC62rKUkZB1D8wpWvgvIQM749x19
         7cdwQyngbqnI6mcys7JghxW9KLsTMnVkcDcXt5I2eMH0p58osYCt0McM3oQ/G066poV2
         HYyFteO/NfsA9f6ah0DN5+ubYNduaoJpGSCaHciBxzblFCzGwYXdA7NwsnSvFw6rOx/K
         b8GSn9+PE0W2Xg+PJyMexOZDs9Rbd5Yv81opQjAt64WXaa5r88I6FimrX/hiJDfpZN1c
         3Ylg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0BcvnxIMRjV1P2xmBijE6nS7xl0bsgVGIfXXeLWC2xM=;
        b=Tismp8TjciRfJpHtyrY1NcIzxYIeJCYKxeJcxkWFa2uIr0DxzmrnBRpUzjaZsyuPCI
         IohaqxgAi12aYZxquS/9vE+2KTMCVeouRh9LmYo2qTnnNoJRe4OoH55/fSd5atGgnkke
         RLYrhDfnrhTgE+tEXYVjXAFFZ3eS9h33Dpx5p8eW9WwtrNZ3A2AMIqF+QsdPGzkVMksS
         cjUwX5p/PUmkkpE3rQcndGuYcWADWkZhjJ9pcp9rrmlFiD2jWGC0l9F8T6tjRnE5BQ2g
         RA8JHSFfqShCbpPA7+rCr352pndQ2kX38PJycvPCJUdNSf/a2OOjkpE8TDX+Eh3qx8lt
         CSkA==
X-Gm-Message-State: AOAM533H309jXmBTZRRApHfVN+pIWvayng3542J7Nvzy5C2gSRfgoF7U
        9S19ZyaTt2cIzLEwqNkNbG8XKNOzXqIf4Dgaprw=
X-Google-Smtp-Source: ABdhPJyCl+SCaVqfToqKOck179mSUnXSAb/tYP9ZjNCNwS5PK4nSDa/g+HZzhHU9qQeSTZIfqWo1kpQstdsDwz/QBGg=
X-Received: by 2002:a05:6638:2105:b0:323:68db:2e4e with SMTP id
 n5-20020a056638210500b0032368db2e4emr11072373jaj.234.1649034904888; Sun, 03
 Apr 2022 18:15:04 -0700 (PDT)
MIME-Version: 1.0
References: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com> <1648654000-21758-3-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1648654000-21758-3-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 3 Apr 2022 18:14:54 -0700
Message-ID: <CAEf4BzaErYfK10Zh0fuMKk7XBdXVFfcORoyNykoKrqAA-_g14g@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 2/5] libbpf: support function name-based
 attach uprobes
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 8:27 AM Alan Maguire <alan.maguire@oracle.com> wrote:
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
> 3. Finally, if the function is local, subtract the base address
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
> 2. to attach to a shared library function in a shared library -
>    function "malloc" in libc.
>
> [1] https://www.kernel.org/doc/html/latest/trace/uprobetracer.html
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/lib/bpf/libbpf.c | 203 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h |  10 ++-
>  2 files changed, 212 insertions(+), 1 deletion(-)
>

[...]

> @@ -10569,6 +10758,7 @@ static int resolve_full_path(const char *file, char *result, size_t result_sz)
>         size_t ref_ctr_off;
>         int pfd, err;
>         bool retprobe, legacy;
> +       const char *func_name;
>
>         if (!OPTS_VALID(opts, bpf_uprobe_opts))
>                 return libbpf_err_ptr(-EINVAL);
> @@ -10586,6 +10776,19 @@ static int resolve_full_path(const char *file, char *result, size_t result_sz)
>                 }
>                 binary_path = full_binary_path;
>         }
> +       func_name = OPTS_GET(opts, func_name, NULL);
> +       if (func_name) {
> +               long sym_off;
> +
> +               if (!binary_path) {
> +                       pr_warn("name-based attach requires binary_path\n");

same about prog '%s': prefix



> +                       return libbpf_err_ptr(-EINVAL);
> +               }
> +               sym_off = elf_find_func_offset(binary_path, func_name);
> +               if (sym_off < 0)
> +                       return libbpf_err_ptr(sym_off);
> +               func_offset += sym_off;
> +       }
>
>         legacy = determine_uprobe_perf_type() < 0;
>         if (!legacy) {
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 05dde85..28cd206 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -459,9 +459,17 @@ struct bpf_uprobe_opts {
>         __u64 bpf_cookie;
>         /* uprobe is return probe, invoked at function return time */
>         bool retprobe;
> +       /* Function name to attach to.  Could be an unqualified ("abc") or library-qualified
> +        * "abc@LIBXYZ" name.  To specify function entry, func_name should be set while
> +        * func_offset argument to bpf_prog__attach_uprobe_opts() should be 0.  To trace an
> +        * offset within a function, specify func_name and use func_offset argument to specify
> +        * offset within the function.  Shared library functions must specify the shared library
> +        * binary_path.
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
