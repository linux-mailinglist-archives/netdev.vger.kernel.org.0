Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 673CD51277B
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 01:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiD0X1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 19:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiD0X1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 19:27:41 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8642E44;
        Wed, 27 Apr 2022 16:24:28 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id e3so1104610ios.6;
        Wed, 27 Apr 2022 16:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zK0x5V23Ijp3kvL3sTcP9SmR0ORqkAvgSHxRNnAKJXM=;
        b=TJN0iE3IAWEply8eeJAOuWrie9rvmG8P4MVzGFISS0BZhGoXf6iQV4zJ/Nldl0cZWu
         9jAibiHwuGIj+qwizJ1+JVP5/x3ONDUfo+/ga4PkzdMZDjXaiZDnFkXzWBRhhVKG4VV0
         +2Xq/jHT1NgaXdPPrJQxXwlV9UOsR0+H9+Va+yuysrcKPPJbM8JVoefTBFSjDzWD2wUX
         kXMkQS712vws6S+6z/OzwHiQEVTc6KIy9Yn/TsTHHVGQxCIABccLYyjZjK/kfmkI98Zb
         0IAEqxwvgy5AfGJ1U1tXm4EeqSBOfvqihMhMPl8B3MROidPey5tjErXX13NYejG8YUxI
         dDYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zK0x5V23Ijp3kvL3sTcP9SmR0ORqkAvgSHxRNnAKJXM=;
        b=yn9eJ28QY+Pynm2efNyhECSDGBFbsfUgEa3BHWX7vQ09xMpKJGJGoHs1DMLQByW/kU
         l3pblCEaOh7b4KTbBVMcZwjvbbIzBr9l20ldH8Z9z4xNwcnUnQtbSedEnVKgkcoOG0H+
         +hwNuloZ410sKVI2rEyzII0fi1GbLIIEKBhkuvGZPuVPJ6Z3YANcFY78WrGiiQ/E6fx4
         bwNQq/YWmP53ro9aWQuObtxTt7MZzHg0YszhH0y/nw9etwNSbXIo0APPh+T2dZpNgXYo
         2Zx5TX8NV0Px9u+YTYEpAAPViJjIp3XFe02oZ1m0MrxKwUwFLTBAAIIsyqLZLE1+XFXL
         MDAA==
X-Gm-Message-State: AOAM532HVH+YjTXlDEqWNsnvw4LCgcV27OCbO5FezBBVtrW7ofRws3KN
        smrYzqr5WEgyV40GQhMB4Yf3DsTmI8/1DnBRj1o=
X-Google-Smtp-Source: ABdhPJxt7OmfUMEXg94y7Zr0tkCVosehp1etX3JgkGVFS1vKiFq09uXt0oD5JopyJJ8wKvA9mLs+FF/WLQ/PS1aku4U=
X-Received: by 2002:a05:6638:16c9:b0:328:5569:fe94 with SMTP id
 g9-20020a05663816c900b003285569fe94mr13658972jat.145.1651101868173; Wed, 27
 Apr 2022 16:24:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220427210345.455611-1-jolsa@kernel.org> <20220427210345.455611-3-jolsa@kernel.org>
In-Reply-To: <20220427210345.455611-3-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 27 Apr 2022 16:24:17 -0700
Message-ID: <CAEf4BzZBnWFxj44OwbNdHrV_LQz_2HmDUSHhEv69psrzi09egQ@mail.gmail.com>
Subject: Re: [PATCHv3 bpf-next 2/5] ftrace: Add ftrace_lookup_symbols function
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
        KP Singh <kpsingh@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 2:04 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding ftrace_lookup_symbols function that resolves array of symbols
> with single pass over kallsyms.
>
> The user provides array of string pointers with count and pointer to
> allocated array for resolved values.
>
>   int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt,
>                             unsigned long *addrs)
>
> It iterates all kalsyms symbols and tries to loop up each in provided

typo: kallsyms

> symbols array with bsearch. The symbols array needs to be sorted by
> name for this reason.
>
> We also check each symbol to pass ftrace_location, because this API
> will be used for fprobe symbols resolving.
>
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  include/linux/ftrace.h |  6 ++++
>  kernel/kallsyms.c      |  1 +
>  kernel/trace/ftrace.c  | 62 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 69 insertions(+)
>

[...]
