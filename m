Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6915D5953A6
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 09:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232003AbiHPHYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 03:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbiHPHY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 03:24:29 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10312BE419;
        Mon, 15 Aug 2022 20:29:17 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id gj1so8657859pjb.0;
        Mon, 15 Aug 2022 20:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=jZcr1tOq0vbhHXHGg5bDK0b4NIp4TukEuBKXw3l7dfI=;
        b=ERJ7vJZeTim5sgAxkYZv/avydlfMQG7+oYbOjD1Hz4D+hI9BkkUQAf6gMcERPk1PLt
         pXI8XXUL1dLSbcUupVZ34mKpr3G53N3AH4Li7CkPy26KweLx7w6j0zOkjwQSQ/ooCG4Y
         ZaXo3XEbyYuyrZXV8C98dqsS04a1TIoEkfos7ny5zrenPSG+pCX0l3js3ZIuK5M8ePtG
         NI5+rCDzCkxwv/OUvFGRef/LU3grXwNHbci0anBlzZwScKFwClCHhJBFIHibxGYboel7
         p4Xb1o7Kig9IQ6hQrdh8oWXJ60IJ/R2+4D7stmuN+e3L4UYOMjV+1kT6956sKvOkuE0r
         QQLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=jZcr1tOq0vbhHXHGg5bDK0b4NIp4TukEuBKXw3l7dfI=;
        b=y9fn12wn980QZoGxjbI65KC9cGQdo9W8r5QhzCV/kEsnT5NJ6HUhSderqRy66BqdZw
         c/yluF4Eg1paFCtcqEvDYF76IT+/RGt5b3N1mc+tWHP/YbimofrLrqpeLCNUkaW3QHwg
         oT5hOaRdyfX/NQVK2amtKo2P/GNhtLfzYf076BRopesX1PEcFDthc2w0cnZ4eEBVzRwt
         BPFneROyH5nlzcx8J9xgdzupkcoKk1XK4ld2520zfRsjkYCkS3TOXQ4TATpmaJIQNTUa
         Rj0q0T4306OANsYIqNl6tvZLZaj3YvVV+Bd6i1miPJNw2a6ob0kSlvrnSc9Rzu9NqJ7L
         HCSA==
X-Gm-Message-State: ACgBeo2kKPUKSvCuyp4tSTcUgwqgUbX8yYFQ/Oylr5YfUgKT+pK9s+np
        ECi3hIKTU1M08hEzNWK0FKg=
X-Google-Smtp-Source: AA6agR40lfsWmAPWuJCQp8pcf8t1MyaRAbeI0StBD0MztAVOqdtVvEtKngl93CFdt2d1KdaNYm+k2A==
X-Received: by 2002:a17:90a:e611:b0:1f4:f03b:affd with SMTP id j17-20020a17090ae61100b001f4f03baffdmr20961637pjy.85.1660620556443;
        Mon, 15 Aug 2022 20:29:16 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ci11-20020a17090afc8b00b001fa9e7b0c47sm30110pjb.46.2022.08.15.20.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 20:29:15 -0700 (PDT)
Date:   Tue, 16 Aug 2022 11:29:10 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Quentin Monnet <quentin@isovalent.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCHv2 bpf-next] libbpf: making bpf_prog_load() ignore name if
 kernel doesn't support
Message-ID: <YvsPBk4Wo3Iw7spd@Laptop-X1>
References: <20220813000936.6464-1-liuhangbin@gmail.com>
 <a3c23cfe-061a-1722-8521-26e57b4b2cf4@isovalent.com>
 <CAEf4BzbXehQtWnocp5KnArd0dq-Wg0ddPOyJZCwGPLO_L7wByg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbXehQtWnocp5KnArd0dq-Wg0ddPOyJZCwGPLO_L7wByg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 02:59:50PM -0700, Andrii Nakryiko wrote:
> I did a small adjustment to not fill out entire big bpf_attr union
> completely (and added a bit more meaningful "libbpf_nametest" prog
> name):
> 

Thanks for the adjustment.

Hangbin

> $ git diff --staged
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 4a351897bdcc..f05dd61a8a7f 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -4415,6 +4415,7 @@ static int probe_fd(int fd)
> 
>  static int probe_kern_prog_name(void)
>  {
> +       const size_t attr_sz = offsetofend(union bpf_attr, prog_name);
>         struct bpf_insn insns[] = {
>                 BPF_MOV64_IMM(BPF_REG_0, 0),
>                 BPF_EXIT_INSN(),
> @@ -4422,12 +4423,12 @@ static int probe_kern_prog_name(void)
>         union bpf_attr attr;
>         int ret;
> 
> -       memset(&attr, 0, sizeof(attr));
> +       memset(&attr, 0, attr_sz);
>         attr.prog_type = BPF_PROG_TYPE_SOCKET_FILTER;
>         attr.license = ptr_to_u64("GPL");
>         attr.insns = ptr_to_u64(insns);
>         attr.insn_cnt = (__u32)ARRAY_SIZE(insns);
> -       libbpf_strlcpy(attr.prog_name, "test", sizeof(attr.prog_name));
> +       libbpf_strlcpy(attr.prog_name, "libbpf_nametest",
> sizeof(attr.prog_name));
> 
> Pushed to bpf-next, thanks!
