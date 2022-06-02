Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9A853C11E
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 00:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239827AbiFBWwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 18:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239825AbiFBWwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 18:52:17 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34A027152;
        Thu,  2 Jun 2022 15:52:16 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id be31so10015246lfb.10;
        Thu, 02 Jun 2022 15:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kgGuhXm5TMT3VyHsGbn93hOqNAblB/6KeAiTNE3WDuE=;
        b=I42OhgIFipOrDBIXciTdNNF1SsRIeHBc8YKNNYECpnRKpgGh3QUERdZc45YsJydZUC
         SkDAQCcMNdWpuZTKYqy0E+tFb5hqojB4vHgR649kSFfaem5l05893sbnVUBJQ7Ksn1sN
         odSrSaarRV/jJi4/hRgMZKTf13v0KM1h53mXyLWT11I4WZt1o4XEufDS7gWu/nY2CRsv
         GPuc64qEb6ERu1jFzDy0U+34XlkwKiVBMACZWm2fqJuifC7oPgk6jqzHsM+/Hhm6GQ+a
         GTU9trcnCTeYrQPBdiWGjJemTs4kKxV5zRyaqYz689aJFwpkYPcwvouib3kstB7SU5u9
         Xw3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kgGuhXm5TMT3VyHsGbn93hOqNAblB/6KeAiTNE3WDuE=;
        b=8Nz1HXpaENXsrJQc4yQoxVFXLRShBglDmQr0aTzZ9EiDWTSh7kMt/RQYYirFCYJfEh
         njP5H/Fb0ED58QFMi2to0IdHn0YS3Y370oVuLEMLJWIITGrkUzJCJneytmmyF5mdFxcf
         3XBq1Xa3HG9GKfLoFuUrsmjO43tPAs2qz96DFwJfvsqwzpKn+tQchrVhbymIDWc9PAtb
         zMEqF++fWcJAXOqpRoCWGYitqcGZOtKpZe0JphC2YXfsVY+SO4TZw9J1cNSLMHZwfUMk
         8uKsm9ApP3FMw/l/h5FeolH60Vu90OBvrzvHQxZPkl5izxj7lUTnxyFFSwbkkO2F96Bf
         7iEg==
X-Gm-Message-State: AOAM532OaWPUQK86DwUMrZfCIUqvKyENeN0hEkyhECoJriIuttc+M9Qz
        XMezipTxxuBa0IijvZDJcPNddB91X3UVw9zI4d/D9Ddn
X-Google-Smtp-Source: ABdhPJxSA2hKH+Y6K5/3Sq3NV/gewZQnhwxCJRmpj5/867ATX2Fngi5QLK94D3d7yBhMYn96WuG943SlJaKWbE8BpWA=
X-Received: by 2002:a05:6512:2286:b0:473:e3bb:db02 with SMTP id
 f6-20020a056512228600b00473e3bbdb02mr4942904lfu.302.1654210334797; Thu, 02
 Jun 2022 15:52:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220527205611.655282-1-jolsa@kernel.org> <20220527205611.655282-3-jolsa@kernel.org>
In-Reply-To: <20220527205611.655282-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 2 Jun 2022 15:52:03 -0700
Message-ID: <CAEf4BzbfbPA-U+GObZy2cEZOn9qAHqRmKtKq-rPOVM=_+DGVww@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] ftrace: Keep address offset in ftrace_lookup_symbols
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
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

On Fri, May 27, 2022 at 1:56 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> We want to store the resolved address on the same index as
> the symbol string, because that's the user (bpf kprobe link)
> code assumption.
>
> Also making sure we don't store duplicates that might be
> present in kallsyms.
>
> Fixes: bed0d9a50dac ("ftrace: Add ftrace_lookup_symbols function")
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/trace/ftrace.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 674add0aafb3..00d0ba6397ed 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -7984,15 +7984,23 @@ static int kallsyms_callback(void *data, const char *name,
>                              struct module *mod, unsigned long addr)
>  {
>         struct kallsyms_data *args = data;
> +       const char **sym;
> +       int idx;
>
> -       if (!bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp))
> +       sym = bsearch(&name, args->syms, args->cnt, sizeof(*args->syms), symbols_cmp);
> +       if (!sym)
> +               return 0;
> +
> +       idx = sym - args->syms;
> +       if (args->addrs[idx])

if we have duplicated symbols we won't increment args->found here,
right? So we won't stop early. But we also don't want to increment
args->found here because we use it to check that we don't have
duplicates (in addition to making sure we resolved all the unique
symbols), right?

So I wonder if in this situation should we return some error code to
signify that we encountered symbol duplicate?


>                 return 0;
>
>         addr = ftrace_location(addr);
>         if (!addr)
>                 return 0;
>
> -       args->addrs[args->found++] = addr;
> +       args->addrs[idx] = addr;
> +       args->found++;
>         return args->found == args->cnt ? 1 : 0;
>  }
>
> @@ -8017,6 +8025,7 @@ int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *a
>         struct kallsyms_data args;
>         int err;
>
> +       memset(addrs, 0x0, sizeof(*addrs) * cnt);
>         args.addrs = addrs;
>         args.syms = sorted_syms;
>         args.cnt = cnt;
> --
> 2.35.3
>
