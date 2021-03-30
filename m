Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B04734F2C9
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 23:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbhC3VJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 17:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbhC3VJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 17:09:34 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1EEC061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 14:09:33 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id x189so18859904ybg.5
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 14:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jsfc1l9CRSt2B4r43OH2iL+osQGjIBeGGz0LSSA/qT0=;
        b=em8WfTN1YraQjM7AMcrGIiuZJq1BUMhlY1SL3kFz79P7Io1N4rzxw0UWLNMw1ltopN
         oIBKfLDr+Wvp6QjjjGhP2UagnQC5TaxEYntVg1nk67OmwCk6gnnPvEdURYzvZ+XSQd0q
         UpgjrkAX51FEH1I6F2StqMoGAqC8MyFXMAWhWQrK5RdQd1VDCrD/t6FiFRdsnIRwR/ZU
         kA6DhdcMXUZ7P1SVCLfY7D9VVyTBaCPTbn5H9GhurHHNeioswzkQq+mRbh8OZGdQ36cv
         lY26wpU8FqB9g2fAPp66bqgFieShvNrWWtBOXtJ5IQoXQC77dyk/6aIu9JAg0O8ZJ0M8
         bgPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jsfc1l9CRSt2B4r43OH2iL+osQGjIBeGGz0LSSA/qT0=;
        b=oH4+k5CwFhuW0o5mobMnkUJgQUjF+sc0GkPRTaXFX6rabz8ZkVXzOG4rYSz5FS64zd
         zeoDZSM7kUmtChGAh/RYNlPxUJ3sbIOv9xMwMnPl094wDPFbB0ZsLDd6bQIKL/WKV2IA
         XloKACkB0T7Tf8I1ESR5DP7+l1rG9WfY/C7w9vzyKJ3fI19m9vWz1dCn9zLJOMQP84nu
         aA1gi3c5nkEovmkM2o7gn2yimMW3V1YzeV0zo45VUeT+eqfh45CNtxiCxxjH6rqTAuRK
         RNtEWcNQwjb+xiLYFpmUEYw6zJ2VVcFx4a/rpSNcNO0qSgMZ0xq0a95QjfAaNisQ3inV
         3aeQ==
X-Gm-Message-State: AOAM533SRaNpMWS7n8ozgp07qLETrYrVAQTf/zTIclS8ncPWAbZNRw2K
        9pE85a0MYs/UK2vCZ3Hc0eRIw9yvk29Eq2rSTCzspNTLmjvbyg==
X-Google-Smtp-Source: ABdhPJxY7mV7vGE7cvxCQnFqYMJH0t+vpJB+YWJP/NhQ4k41JoxOmm0GhKrQ2/ibA7ucQv2/gOW81H6xDqw7rsmZLe8=
X-Received: by 2002:a25:ab81:: with SMTP id v1mr174554ybi.303.1617138572366;
 Tue, 30 Mar 2021 14:09:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210330210613.2765853-1-eric.dumazet@gmail.com>
In-Reply-To: <20210330210613.2765853-1-eric.dumazet@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 30 Mar 2021 23:09:21 +0200
Message-ID: <CANn89iL=LDk4c1YX2MzmauvsRo_XYsO72wRwjX_swDS0N7c7pg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: fix icmp_echo_enable_probe sysctl
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 11:06 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> sysctl_icmp_echo_enable_probe is an u8.
>
> ipv4_net_table entry should use
>  .maxlen       = sizeof(u8).
>  .proc_handler = proc_dou8vec_minmax,
>
I should have added the following tag :

Fixes: f1b8fa9fa586 ("net: add sysctl for enabling RFC 8335 PROBE messages")

> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> ---
>  net/ipv4/sysctl_net_ipv4.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index e3cb2d96b55e99f4322a99abb6a6da866dffcf4d..9199f507a005efc3f57ca0225d3898bfa5d01c53 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -601,9 +601,9 @@ static struct ctl_table ipv4_net_table[] = {
>         {
>                 .procname       = "icmp_echo_enable_probe",
>                 .data           = &init_net.ipv4.sysctl_icmp_echo_enable_probe,
> -               .maxlen         = sizeof(int),
> +               .maxlen         = sizeof(u8),
>                 .mode           = 0644,
> -               .proc_handler   = proc_dointvec_minmax,
> +               .proc_handler   = proc_dou8vec_minmax,
>                 .extra1         = SYSCTL_ZERO,
>                 .extra2         = SYSCTL_ONE
>         },
> --
> 2.31.0.291.g576ba9dcdaf-goog
>
