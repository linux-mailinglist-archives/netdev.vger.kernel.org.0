Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 254F84AD135
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 06:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbiBHFnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 00:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233615AbiBHFnZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 00:43:25 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D17C0401EE
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 21:43:24 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id p5so46637611ybd.13
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 21:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gwMc0yp9bA0jtJal0Nu7PGGkwb3zW2Z6AFPOp4vTdLs=;
        b=aILYyBZGuABOWxmV5QrhNjUjIGsK7DF29ZLNuQbnMA/0rQm3s2SquTiLqGQsoau4A2
         lvOGJ3wVtYePAwFoNSapml0XTY5zrfr6d0pHL3gxhG/V++zJe3cvNQ4KkFvvky1iIkSO
         abgikha1j7G4bOx6Yr29KaCu/6IMwZH9j7NHT3K6X+9zVOojI+TtA0Q5ciDBkRJLBVXH
         +I7mgHSx8RGm5u+yBofAMSEaNrdd5qLKSkjneAbXpOiil0484cReNG33MlzV9/nLLr7h
         Ynsm6RrqN9u7MUS05+wHD7OtWeS8zffTiE91+iE0z0qKyuwx/8x4wsF99Zf4lxTjjrmW
         1Qbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gwMc0yp9bA0jtJal0Nu7PGGkwb3zW2Z6AFPOp4vTdLs=;
        b=HbHpIGtZaMXdo7+V6EIforLjIcG3a9mgqThr4Aqmy1dWxUw85IG7/ajT4Qh/XRrnWi
         ZASOoGmmpigkgCFY4dO0oJDW8t/8EAThAt7w4ydGaGA2eNxzdGK4leUX6m7dPOiq/DWJ
         BFpK6sGQPlqtm51zISojlZz0sPXvyDPWOPzBCYIKcPN/q7ivV1HujtNh9QGP3c8WzBuW
         qr16dQXJSFQfMoIMdbSwnlVwhmrHsHXhQw/2JjvJ9PjZizk9gzJ46cRKnEQI2ZSj0Ppk
         xd+4L5T1m7NC2HpFtcf29r0pYs9WmbMDY0oH2Wug+2Q27YcYNSdH4BZrsh7nWwN/Rn/L
         6R8A==
X-Gm-Message-State: AOAM533iccBEly2/sUoVuk6gMOcLGpXXG55HILIL4HSPyHhFpaitjeVa
        yd33tRvu2BW77TVFN4Ci+5Yp99qs6NjeiyY6FLsy5dmdQnqaWTt/2TI=
X-Google-Smtp-Source: ABdhPJyHwl4cHZENZaOsF8BFVXCTs3Pwj+q0rAMVdMisZHIQFRbFTfKU6zd2XLQ99wT50ICuKArrZoc1vW1cFQL3Qxs=
X-Received: by 2002:a25:b70a:: with SMTP id t10mr3212611ybj.637.1644299003731;
 Mon, 07 Feb 2022 21:43:23 -0800 (PST)
MIME-Version: 1.0
References: <20220205154038.2345-1-claudiajkang@gmail.com> <164414580941.29882.3204574468884683223.git-patchwork-notify@kernel.org>
 <3e5d1f9d-838d-bb82-44e7-7ea85b1ec91c@gmail.com>
In-Reply-To: <3e5d1f9d-838d-bb82-44e7-7ea85b1ec91c@gmail.com>
From:   Juhee Kang <claudiajkang@gmail.com>
Date:   Tue, 8 Feb 2022 14:42:47 +0900
Message-ID: <CAK+SQuRbFMLQjQ8O5s2OQzXK7-HC+1v0XeQ4HbDGeRQTUAo9UQ@mail.gmail.com>
Subject: Re: [PATCH v4 net-next] net: hsr: use hlist_head instead of list_head
 for mac addresses
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>, ennoerlangen@gmail.com,
        george.mccollister@gmail.com, olteanv@gmail.com,
        marco.wenzel@a-eberle.de, xiong.zhenwu@zte.com.cn
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

On Tue, Feb 8, 2022 at 2:23 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
> On 2/6/22 03:10, patchwork-bot+netdevbpf@kernel.org wrote:
> > Hello:
> >
> > This patch was applied to netdev/net-next.git (master)
> > by David S. Miller <davem@davemloft.net>:
> >
> > On Sat,  5 Feb 2022 15:40:38 +0000 you wrote:
> >> Currently, HSR manages mac addresses of known HSR nodes by using list_head.
> >> It takes a lot of time when there are a lot of registered nodes due to
> >> finding specific mac address nodes by using linear search. We can be
> >> reducing the time by using hlist. Thus, this patch moves list_head to
> >> hlist_head for mac addresses and this allows for further improvement of
> >> network performance.
> >>
> >> [...]
> > Here is the summary with links:
> >    - [v4,net-next] net: hsr: use hlist_head instead of list_head for mac addresses
> >      https://git.kernel.org/netdev/net-next/c/4acc45db7115
> >
> > You are awesome, thank you!
>
>
> I think this patch has not been tested with CONFIG_PROVE_RCU=y
>
>
> WARNING: suspicious RCU usage
> 5.17.0-rc3-next-20220207-syzkaller #0 Not tainted
> -----------------------------
> net/hsr/hsr_framereg.c:34 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active = 2, debug_locks = 1
> 2 locks held by syz-executor.0/3603:
>   #0: ffffffff8d3353a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock
> net/core/rtnetlink.c:72 [inline]
>   #0: ffffffff8d3353a8 (rtnl_mutex){+.+.}-{3:3}, at:
> rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5591
>   #1: ffff88806e13d5f0 (&hsr->list_lock){+...}-{2:2}, at: spin_lock_bh
> include/linux/spinlock.h:359 [inline]
>   #1: ffff88806e13d5f0 (&hsr->list_lock){+...}-{2:2}, at:
> hsr_create_self_node+0x225/0x650 net/hsr/hsr_framereg.c:108
>
> stack backtrace:
> CPU: 0 PID: 3603 Comm: syz-executor.0 Not tainted
> 5.17.0-rc3-next-20220207-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>   <TASK>
>   __dump_stack lib/dump_stack.c:88 [inline]
>   dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>   hsr_node_get_first+0x9b/0xb0 net/hsr/hsr_framereg.c:34
>   hsr_create_self_node+0x22d/0x650 net/hsr/hsr_framereg.c:109
>   hsr_dev_finalize+0x2c1/0x7d0 net/hsr/hsr_device.c:514
>   hsr_newlink+0x315/0x730 net/hsr/hsr_netlink.c:102
>   __rtnl_newlink+0x107c/0x1760 net/core/rtnetlink.c:3481
>   rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3529
>   rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5594
>   netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
>   netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
>   netlink_unicast+0x539/0x7e0 net/netlink/af_netlink.c:1343
>   netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1919
>   sock_sendmsg_nosec net/socket.c:705 [inline]
>   sock_sendmsg+0xcf/0x120 net/socket.c:725
>   __sys_sendto+0x21c/0x320 net/socket.c:2040
>   __do_sys_sendto net/socket.c:2052 [inline]
>   __se_sys_sendto net/socket.c:2048 [inline]
>   __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2048
>   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>   do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>
>


-- 

Hi Eric,
Thank you so much for catching it.

I will send a new patch after fixing this problem and some tests.

Best regards,
Juhee Kang
