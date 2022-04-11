Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E03E04FC771
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 00:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350390AbiDKWSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 18:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350418AbiDKWR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 18:17:57 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE9B26112;
        Mon, 11 Apr 2022 15:15:35 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id k25so20346908iok.8;
        Mon, 11 Apr 2022 15:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kL8nw+kkxRkF6850uohgHzWtw+kuxUaqTysptdnGkC8=;
        b=JIbrFBlm2+YqWyPQ9JmNckPFktJHytR/kSF7WkbgqY3lYq8prTVFwQOQkYwPem0DNe
         TkHoLBgTnD83MUICH5xJpN8xUxC6G/mSbHNAdxlv/SWx1lkfRxuYDjxsMj8TYLv9vVu3
         CRb72ycRk2Tu0yW29dW5TqOj4zEe2s5J1dcuwIPoUpVW3PjDE3p6XG2kLogwyh2zN5vT
         hZWI7+bCcgTGJ3bnJ3jdrhn1VIIG0UL603yeVOijESZmny6QGIrR9IvtFS8qMP1+648C
         lHNuRNpUPpDPPNYcfv/ModIIiFq72dhnUSuTJyVs+oMVQgqQHXch9ZX1Oe6f/4ZgfYi4
         1oiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kL8nw+kkxRkF6850uohgHzWtw+kuxUaqTysptdnGkC8=;
        b=iVLVvysR3aLMs7zYEYfzmirT4LjwMCvZ0S1k7HYMHE2Ky48QUrBsuFfAkz0WkRgUMY
         OoBu7BAmEEgDkmBJMDgZ9ePhlbM3WVyS6YGdJw3eFc68w36Lsd0EOE3ax3dT05YaVuBA
         +Ac32B8WTI533Bxea0qqw+V83S4G7yLdP1X1vKbtnTT089I9y6Ed02fNhJMQt5ak4COL
         G6Qbnd0kOEGg4ZSLz3ENXOfVgcNYipWnyeffKH+L3wPnoE86FbiGCxCVeDka3s5Cmnwe
         i7g618T8E+1oHnXLYbgY8q1X7WRVs8KhFZwi5pGg/SbSkXow++dUvwv2UdRK5njKrCxW
         7PTA==
X-Gm-Message-State: AOAM530CbQ5Ffn+ASf2k1n5HjAFhiiSlpDpkdf5A8lG3V+zeO4SbBvbt
        XsYZMLQHJOkKN2ZZDbHov+Ss4wvPl3Sw/vtaCUE=
X-Google-Smtp-Source: ABdhPJyf/1hHwHPkmGlwPJdP5IAugKSUeFN0fJQaM6DsPOny+KiO2QsNJyxP21v/6Eqcs4XOYUdkWa3zFA5I7PbPH20=
X-Received: by 2002:a05:6638:2104:b0:326:1e94:efa6 with SMTP id
 n4-20020a056638210400b003261e94efa6mr5719614jaj.234.1649715333863; Mon, 11
 Apr 2022 15:15:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220407125224.310255-1-jolsa@kernel.org> <20220407125224.310255-2-jolsa@kernel.org>
In-Reply-To: <20220407125224.310255-2-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Apr 2022 15:15:23 -0700
Message-ID: <CAEf4BzYffXGFigxywjP391s4G=6VpykxaqD5OYuOR5mBRa1Tmw@mail.gmail.com>
Subject: Re: [RFC bpf-next 1/4] kallsyms: Add kallsyms_lookup_names function
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
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

On Thu, Apr 7, 2022 at 5:52 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding kallsyms_lookup_names function that resolves array of symbols
> with single pass over kallsyms.
>
> The user provides array of string pointers with count and pointer to
> allocated array for resolved values.
>
>   int kallsyms_lookup_names(const char **syms, u32 cnt,
>                             unsigned long *addrs)
>
> Before we iterate kallsyms we sort user provided symbols by name and
> then use that in kalsyms iteration to find each kallsyms symbol in
> user provided symbols.
>
> We also check each symbol to pass ftrace_location, because this API
> will be used for fprobe symbols resolving. This can be optional in
> future if there's a need.
>
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/kallsyms.h |  6 +++++
>  kernel/kallsyms.c        | 48 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 54 insertions(+)
>
> diff --git a/include/linux/kallsyms.h b/include/linux/kallsyms.h
> index ce1bd2fbf23e..5320a5e77f61 100644
> --- a/include/linux/kallsyms.h
> +++ b/include/linux/kallsyms.h
> @@ -72,6 +72,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
>  #ifdef CONFIG_KALLSYMS
>  /* Lookup the address for a symbol. Returns 0 if not found. */
>  unsigned long kallsyms_lookup_name(const char *name);
> +int kallsyms_lookup_names(const char **syms, u32 cnt, unsigned long *addrs);
>
>  extern int kallsyms_lookup_size_offset(unsigned long addr,
>                                   unsigned long *symbolsize,
> @@ -103,6 +104,11 @@ static inline unsigned long kallsyms_lookup_name(const char *name)
>         return 0;
>  }
>
> +int kallsyms_lookup_names(const char **syms, u32 cnt, unsigned long *addrs)
> +{
> +       return -ERANGE;
> +}
> +
>  static inline int kallsyms_lookup_size_offset(unsigned long addr,
>                                               unsigned long *symbolsize,
>                                               unsigned long *offset)
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 79f2eb617a62..a3738ddf9e87 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -29,6 +29,8 @@
>  #include <linux/compiler.h>
>  #include <linux/module.h>
>  #include <linux/kernel.h>
> +#include <linux/bsearch.h>
> +#include <linux/sort.h>
>
>  /*
>   * These will be re-linked against their real values
> @@ -572,6 +574,52 @@ int sprint_backtrace_build_id(char *buffer, unsigned long address)
>         return __sprint_symbol(buffer, address, -1, 1, 1);
>  }
>
> +static int symbols_cmp(const void *a, const void *b)

isn't this literally strcmp? Or compiler will actually complain about
const void * vs const char *?

> +{
> +       const char **str_a = (const char **) a;
> +       const char **str_b = (const char **) b;
> +
> +       return strcmp(*str_a, *str_b);
> +}
> +
> +struct kallsyms_data {
> +       unsigned long *addrs;
> +       const char **syms;
> +       u32 cnt;
> +       u32 found;
> +};
> +
> +static int kallsyms_callback(void *data, const char *name,
> +                            struct module *mod, unsigned long addr)
> +{
> +       struct kallsyms_data *args = data;
> +
> +       if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp))
> +               return 0;
> +
> +       addr = ftrace_location(addr);
> +       if (!addr)
> +               return 0;
> +
> +       args->addrs[args->found++] = addr;
> +       return args->found == args->cnt ? 1 : 0;
> +}
> +
> +int kallsyms_lookup_names(const char **syms, u32 cnt, unsigned long *addrs)
> +{
> +       struct kallsyms_data args;
> +
> +       sort(syms, cnt, sizeof(*syms), symbols_cmp, NULL);
> +
> +       args.addrs = addrs;
> +       args.syms = syms;
> +       args.cnt = cnt;
> +       args.found = 0;
> +       kallsyms_on_each_symbol(kallsyms_callback, &args);
> +
> +       return args.found == args.cnt ? 0 : -EINVAL;

ESRCH or ENOENT makes a bit more sense as an error?


> +}
> +
>  /* To avoid using get_symbol_offset for every symbol, we carry prefix along. */
>  struct kallsym_iter {
>         loff_t pos;
> --
> 2.35.1
>
