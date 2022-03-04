Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F99D4CE0A5
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 00:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiCDXMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 18:12:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiCDXME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 18:12:04 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09A827B8E0;
        Fri,  4 Mar 2022 15:11:16 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id c18so11194094ioc.6;
        Fri, 04 Mar 2022 15:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VAvKzeYnxXBW8o7T9AcJhCsgopHLVla6a/Nzr9AT0sQ=;
        b=DSU8iX5xO0fY1YHgI4wc5SlCNf2hoeUUW3Rrjp2nw4clDE7sahe9htPmcgIlbeEyjW
         OrTIYnfCLrJMGiNx75G0QF6f5cHxx//Xp6oS5TP6PgwFhdyv20P4u5XmQ+iHtGYH0B5w
         Pj/rGw10j22x9BYvyBazT7x7sr3Go3xWDJ+6gwxCafYnz58sZALTrme2Yb6Ff+Q/MxxN
         /hRyoPFpgBH1bNdvgYzYF1QDEi/x5Nu7n744jOtIFa0ItYpFXKiPHFG8DqJWdYmDSQ5l
         qMHjGda6cy/MQIlfwyTuLeqMKxiVph91yt9frf6xjR/AQuR+AvvVsB75FJPfaPQp3XP9
         t/Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VAvKzeYnxXBW8o7T9AcJhCsgopHLVla6a/Nzr9AT0sQ=;
        b=oJ5tzpWHqURF6XY1LNv6T/iogDycf/VDed7OzNPGFRd0UAGRETSDMzUKHPRov9iPra
         gT1HfXoq6jYtaYuEXWMNRmS2GnoshV3Xn7lAz8TQZM+yrpPoC5WMCVOKKKmmvFSrvJbD
         GPlIvoPZsSlmFUHXy6W+yadbxzShGbUcgbNFg/M00gjb1cn08Q5o1wEAgPI3X/dh7Jpk
         tp3855SpuosJKA960sw/82vHt2COtpzlS5Jn2Yge0QANjFoe1Er3uMF8c5Lbba6Qytjo
         X7MuOeIsLl7p28utyiyYu+tcNXbdTz+6cBi0HVbFsJSL88DquEkvzvfHDQwZe6diBw0W
         6j8Q==
X-Gm-Message-State: AOAM531ZsU4P5Z+ASilEyPXfgv09lzH9d2crkDn59HMRYsfukF2OAiFY
        1GfbckIDCKUP3gDn7UpHvnrDGWI/i4PxF04xfJRDYIA0h48=
X-Google-Smtp-Source: ABdhPJwBFTUuylL//uQpTgz8todkLrHV9Z6T7uG34p2cmt9HfR4cK6CCuFsjp5lBwRyqA5Ge51TLO2XjyR+83hFnTck=
X-Received: by 2002:a05:6638:382:b0:30e:3e2e:3227 with SMTP id
 y2-20020a056638038200b0030e3e2e3227mr764583jap.234.1646435476096; Fri, 04 Mar
 2022 15:11:16 -0800 (PST)
MIME-Version: 1.0
References: <20220222170600.611515-1-jolsa@kernel.org> <20220222170600.611515-4-jolsa@kernel.org>
In-Reply-To: <20220222170600.611515-4-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Mar 2022 15:11:05 -0800
Message-ID: <CAEf4BzaKbMd=fFeqD3MhewtD3eXw81-_FfdfKUOUH5wJsF6D_Q@mail.gmail.com>
Subject: Re: [PATCH 03/10] bpf: Add bpf_get_func_ip kprobe helper for multi
 kprobe link
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 9:06 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding support to call bpf_get_func_ip helper from kprobe
> programs attached by multi kprobe link.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andrii@kernel.org>


>  kernel/trace/bpf_trace.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index df3771bfd6e5..64891b7b0885 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1037,6 +1037,18 @@ static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
>         .arg1_type      = ARG_PTR_TO_CTX,
>  };
>
> +BPF_CALL_1(bpf_get_func_ip_kprobe_multi, struct pt_regs *, regs)
> +{
> +       return instruction_pointer(regs);
> +}
> +
> +static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe_multi = {
> +       .func           = bpf_get_func_ip_kprobe_multi,
> +       .gpl_only       = false,
> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_CTX,
> +};
> +
>  BPF_CALL_1(bpf_get_attach_cookie_trace, void *, ctx)
>  {
>         struct bpf_trace_run_ctx *run_ctx;
> @@ -1280,7 +1292,9 @@ kprobe_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return &bpf_override_return_proto;
>  #endif
>         case BPF_FUNC_get_func_ip:
> -               return &bpf_get_func_ip_proto_kprobe;
> +               return prog->expected_attach_type == BPF_TRACE_KPROBE_MULTI ?
> +                       &bpf_get_func_ip_proto_kprobe_multi :
> +                       &bpf_get_func_ip_proto_kprobe;
>         case BPF_FUNC_get_attach_cookie:
>                 return &bpf_get_attach_cookie_proto_trace;
>         default:
> --
> 2.35.1
>
