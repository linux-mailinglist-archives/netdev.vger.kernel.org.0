Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A15B4AD110
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 06:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbiBHFdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 00:33:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbiBHFXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 00:23:20 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81F2C0401DC
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 21:23:18 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id v13-20020a17090ac90d00b001b87bc106bdso1093561pjt.4
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 21:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QEqJZeQimrrIeAF15lzFETIIZUcOlhSc9LNnGqwFQGA=;
        b=KKJxRxZdpjD5/8e8rgCnSdGJ8WpwJoWCwQW4H2xTfXhyEC0Hp3pRawCkWShFgBAprv
         nU3/oU1E+gJOCBKSWmvgF0WAfIJLnKuZvj5YE1Iqe7gCeMBTPU7gTM0h6hWAfx/SsH9O
         p1spmC9Np65lDDHzilaxq+3C6AT1zoKuLQ3d8cqWwTUBhproT9MzG/anj+WpKF8UzC+h
         FVJ2Y8wt6YLFGE5oFhpKTRfbR5KQTWFNNYWcTibFz265EEg9md2ceAeDqwpCgBNL585q
         myBfLHnMZqpous+GkCLZGO68AkkGqdhX7NtYDrVzQxl11t4R1Z/YxtLH9/OXCtbfat6s
         KdsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QEqJZeQimrrIeAF15lzFETIIZUcOlhSc9LNnGqwFQGA=;
        b=XPFyvLvUsA48agJRWbz0Q++cDImOVH+ljzkpfZcGoq4A4zbEkUYTbMTcb4w00HpXUL
         JpH8jHF9gyXD783n/fePDrD9ETg4RQ8m9Xqel+mC5/7dGsieVqt7FdQpfPv/52qAtULb
         M73eLL7iSm4SC0Q4Qj6fNJt1s0Rw7A7f8HpqmTy4Bf2KaDAcOnPPP7tt7dJ4Fgb6Spz4
         foq1tA+1cYn38Ff4HePuEhiX9tjeVYwQx2gv3CW+AMkJgJE+BGrzRAAHUDrvEI7x+0IR
         tMLNOjGHQdm+6FwPqDUt9aIBz4HRa4oiVt6PUdje+uqxXsfcFfgwEdKYXRJhi6eQfexQ
         uh6A==
X-Gm-Message-State: AOAM531U5jHneYJW+i9nFzWrHz0Ko1uvZ0K+h/2bForuT9NIY3OWXcJ3
        EcomkclRhT/z5xMoQCumRbY=
X-Google-Smtp-Source: ABdhPJx6ox/+QBK2XtGm3DuvBCr7+pvpzKZ/27g6Al8XoDBXtLZwk7+4JTkrdaTZu2TqPm4EIcR4KA==
X-Received: by 2002:a17:90b:4f8f:: with SMTP id qe15mr2595297pjb.94.1644297798332;
        Mon, 07 Feb 2022 21:23:18 -0800 (PST)
Received: from [192.168.86.21] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id i14sm9716674pgh.42.2022.02.07.21.23.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 21:23:17 -0800 (PST)
Message-ID: <3e5d1f9d-838d-bb82-44e7-7ea85b1ec91c@gmail.com>
Date:   Mon, 7 Feb 2022 21:23:15 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 net-next] net: hsr: use hlist_head instead of list_head
 for mac addresses
Content-Language: en-US
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ennoerlangen@gmail.com, george.mccollister@gmail.com,
        olteanv@gmail.com, marco.wenzel@a-eberle.de,
        xiong.zhenwu@zte.com.cn
References: <20220205154038.2345-1-claudiajkang@gmail.com>
 <164414580941.29882.3204574468884683223.git-patchwork-notify@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <164414580941.29882.3204574468884683223.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/6/22 03:10, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
>
> This patch was applied to netdev/net-next.git (master)
> by David S. Miller <davem@davemloft.net>:
>
> On Sat,  5 Feb 2022 15:40:38 +0000 you wrote:
>> Currently, HSR manages mac addresses of known HSR nodes by using list_head.
>> It takes a lot of time when there are a lot of registered nodes due to
>> finding specific mac address nodes by using linear search. We can be
>> reducing the time by using hlist. Thus, this patch moves list_head to
>> hlist_head for mac addresses and this allows for further improvement of
>> network performance.
>>
>> [...]
> Here is the summary with links:
>    - [v4,net-next] net: hsr: use hlist_head instead of list_head for mac addresses
>      https://git.kernel.org/netdev/net-next/c/4acc45db7115
>
> You are awesome, thank you!


I think this patch has not been tested with CONFIG_PROVE_RCU=y


WARNING: suspicious RCU usage
5.17.0-rc3-next-20220207-syzkaller #0 Not tainted
-----------------------------
net/hsr/hsr_framereg.c:34 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
2 locks held by syz-executor.0/3603:
  #0: ffffffff8d3353a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_lock 
net/core/rtnetlink.c:72 [inline]
  #0: ffffffff8d3353a8 (rtnl_mutex){+.+.}-{3:3}, at: 
rtnetlink_rcv_msg+0x3be/0xb80 net/core/rtnetlink.c:5591
  #1: ffff88806e13d5f0 (&hsr->list_lock){+...}-{2:2}, at: spin_lock_bh 
include/linux/spinlock.h:359 [inline]
  #1: ffff88806e13d5f0 (&hsr->list_lock){+...}-{2:2}, at: 
hsr_create_self_node+0x225/0x650 net/hsr/hsr_framereg.c:108

stack backtrace:
CPU: 0 PID: 3603 Comm: syz-executor.0 Not tainted 
5.17.0-rc3-next-20220207-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS 
Google 01/01/2011
Call Trace:
  <TASK>
  __dump_stack lib/dump_stack.c:88 [inline]
  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
  hsr_node_get_first+0x9b/0xb0 net/hsr/hsr_framereg.c:34
  hsr_create_self_node+0x22d/0x650 net/hsr/hsr_framereg.c:109
  hsr_dev_finalize+0x2c1/0x7d0 net/hsr/hsr_device.c:514
  hsr_newlink+0x315/0x730 net/hsr/hsr_netlink.c:102
  __rtnl_newlink+0x107c/0x1760 net/core/rtnetlink.c:3481
  rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3529
  rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5594
  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
  netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
  netlink_unicast+0x539/0x7e0 net/netlink/af_netlink.c:1343
  netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1919
  sock_sendmsg_nosec net/socket.c:705 [inline]
  sock_sendmsg+0xcf/0x120 net/socket.c:725
  __sys_sendto+0x21c/0x320 net/socket.c:2040
  __do_sys_sendto net/socket.c:2052 [inline]
  __se_sys_sendto net/socket.c:2048 [inline]
  __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2048
  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
  entry_SYSCALL_64_after_hwframe+0x44/0xae


