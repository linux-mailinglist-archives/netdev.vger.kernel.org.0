Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB4C527BE9
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 04:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239385AbiEPC2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 22:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234618AbiEPC2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 22:28:37 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F07CF5BF
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 19:28:36 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-2f863469afbso138898387b3.0
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 19:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P0VlbRSaE0WU5Fi6MOgFTzFK1auof3HIk/L3qV4ilWg=;
        b=r5uasdm+4EKZLPjchMJ+b1yp89dk95ZE2ZGuralD70lt8ylcO35S6qz/TAn6Hpcju7
         1GkcdBLb3KHhk/GwjspTybEAMIWWLaYRquqctMnYbjTA8ayF3yEz2Asry/5Leub5sJg+
         129A0R1Lqy1+UhphGYCYZq14h75lFr3kuyBhXOi13yT95BJCRsjMYtVDyGInKhSSvyXz
         KQaE1OSaITOHPjOBOXWF+3kqSmpWhdhwGCmlVbvgvBLEYv2de9NVGKqa16tfxi/K4fjJ
         wMmaMIEJOD1ofqpYYKLhOb25haEVhmQH5j9q/4K8Base8G6Cin/b/JOHtTACCWAvcu8Z
         fU5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P0VlbRSaE0WU5Fi6MOgFTzFK1auof3HIk/L3qV4ilWg=;
        b=zJDphIn5MnmqFC/YqGXCWiDJX/hHf/l3La2CLPaeQxnWHpNVeIYpofWZPOQSRKJxtq
         jmB/cjOLI1K0RZc4b8RS0lqSIrJ1PmQtR6qrDe5O3Q9tXEBkdgI9XndUmnhi2QXTeX6K
         8gAkpobXeHiMRy9l/7NevVaA4Eow6jdNzMZE4/RyPsDl1PUKs8CqHL3xR3obilRggPiz
         B589D2bQqv5EE/JMP1tF9DQCDOUHKD/hJKTQRXN0EHIJH8nG0UJ73T82Us45qMqHHILq
         nBOkKD4yDLtnkijINq1yKvrI4Ra/K4rcXnW9efWWes+JcijNBAXU3lWW2oEsl7/LPkI9
         OPBg==
X-Gm-Message-State: AOAM531hG1r5KLMRHEn/owJysZ8tQleuYuBW4+XovhgLMICnRvM8YMRQ
        OvbvvjrhcS9KzHG7ZfNLKfnrDdm/G/FDd2iffeEZTCRSaiZ0EA==
X-Google-Smtp-Source: ABdhPJyGDkm9V5PRJv/i/jQyn1I6tfgUcfnWEYugw7YG7rfRNuTM6OrObSes5dkLzCvUDLmJaUezBcC2JX2r8WkHcN0=
X-Received: by 2002:a81:5603:0:b0:2f8:3187:f37a with SMTP id
 k3-20020a815603000000b002f83187f37amr16880717ywb.255.1652668115471; Sun, 15
 May 2022 19:28:35 -0700 (PDT)
MIME-Version: 1.0
References: <68cf685582fe02e86d5320c9048faeb3d2b5a833.1652665051.git.lucien.xin@gmail.com>
In-Reply-To: <68cf685582fe02e86d5320c9048faeb3d2b5a833.1652665051.git.lucien.xin@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 15 May 2022 19:28:24 -0700
Message-ID: <CANn89iL_w6s65HAV8+YPv4NhDfmKEeWzdkpQE_-FZRfb3w-EHg@mail.gmail.com>
Subject: Re: [PATCH net] dn_route: set rt neigh to blackhole_netdev instead of
 loopback_dev in ifdown
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 15, 2022 at 6:37 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> Like other places in ipv4/6 dst ifdown, change to use blackhole_netdev
> instead of pernet loopback_dev in dn dst ifdown.
>
> Since commit faab39f63c1f ("net: allow out-of-order netdev
> unregistration"), in .ifdown it's been no longer safe to use loopback_dev
> that may be freed before other netdev.
>
> Fixes: faab39f63c1f ("net: allow out-of-order netdev unregistration")

This patch does not need a Fixes tag I think, because decnet has never supported
other netns than init_net.

This probably can be routed to net-next.

Not a big deal, just trying to avoid extra backports.

Thanks.

> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/decnet/dn_route.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
> index 7e85f2a1ae25..99cc52e672b3 100644
> --- a/net/decnet/dn_route.c
> +++ b/net/decnet/dn_route.c
> @@ -159,7 +159,7 @@ static void dn_dst_ifdown(struct dst_entry *dst, struct net_device *dev, int how
>                 struct neighbour *n = rt->n;
>
>                 if (n && n->dev == dev) {
> -                       n->dev = dev_net(dev)->loopback_dev;
> +                       n->dev = blackhole_netdev;
>                         dev_hold(n->dev);
>                         dev_put(dev);
>                 }
> --
> 2.31.1
>
