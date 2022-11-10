Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA8D2624840
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 18:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbiKJRV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 12:21:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbiKJRVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 12:21:45 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB255FCD1
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 09:21:35 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id bp12so1323186ilb.9
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 09:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0vCRXEeKtm+HYHEkQh5QRQSS3DO6leYWxm9Zkz0sbjA=;
        b=GXECeB59VZdb8rEs4HZ+3czl2ISx4ZRgLr5orhGJV4eMXeMKZg+7up+GZqOyTDpKpN
         0cIlyGSJ/8wjIqf/f8Md2q1fnSr/wxv/xbbwyY11giEPv7UlTXmyZONJHYsAgpRUsklP
         K7XOrTtqvMrwB5JhjKv6bqsv4ej9BUO/+xMsF7zoVH+4H6qLvWnson+nO3vsES2ImGR0
         /4QlpY7kn3JIP5qqz/oYHRgFPCVXT8Pbb3RN5+7w4UGAqwOqdAjSHi9Dyegek+ibNwEC
         oz67ZUEshfaK1DmTFCT+UO9wFnHLOFqVR6L8j36gWIe9GvqHoXN2AHT3OQNwzgFOmTKv
         SlJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0vCRXEeKtm+HYHEkQh5QRQSS3DO6leYWxm9Zkz0sbjA=;
        b=zRV+f7ga8YhrriBjOQuqByMbZ2hyzml7eVE3mibUXekwnpjJNKi2xUxAaTcowPXSKY
         uC2chG1iux4kxxoEuPGMW/ZRHjCFIGaR/QS+J6Ilqa/ZkVdgWON8t+EVO7qxrvb7ROiI
         6jjkar1qCyEjuhTV1Rq2Zt2aQGI6SKuAqw4da3SXrRNU5FY6xWdiTNivMg6vZ05e/6QT
         nnigfjDFNTL+iYGzlQRoPXA4yHlGI9LdEGOrt74D3p7UHkgy/ED0zfykDo0VZa6sB9bo
         HdJNJCtBQAE02SvXS+afXBHzGTzzic4m0DdTvzsBOUI42Sh1tWjxYYSnumMRNnBdZP5q
         +7Tg==
X-Gm-Message-State: ACrzQf0cmtP8qM4ZiJcXUEmVVbR8F0BE0fO63Os6HDJWfiSzPI3NuD0c
        cb2Vv30tPf53mrPpQrYST++2L5pKty8Jb3w5J+jHqQ==
X-Google-Smtp-Source: AMsMyM4bzUgYtpgNDPL5baJyzhn3EDpwdHrKEeLhV8JqvSYJN/VMW1NfeoP5xvfN4/+lgsTjPBoVtoR3t/UIc9dgTi8=
X-Received: by 2002:a92:3649:0:b0:2fa:d5f4:e9d6 with SMTP id
 d9-20020a923649000000b002fad5f4e9d6mr3220809ilf.254.1668100894565; Thu, 10
 Nov 2022 09:21:34 -0800 (PST)
MIME-Version: 1.0
References: <20221108132208.938676-1-jiri@resnulli.us> <20221108132208.938676-4-jiri@resnulli.us>
 <Y2uT1AZHtL4XJ20E@shredder> <CANn89iJgTLe0EJ61xYji6W-VzQAGtoXpZJAxgKe-nE9ESw=p7w@mail.gmail.com>
 <20221109134536.447890fb@kernel.org> <Y2yuK8kccunmEiYd@nanopsycho>
In-Reply-To: <Y2yuK8kccunmEiYd@nanopsycho>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 10 Nov 2022 09:21:23 -0800
Message-ID: <CANn89iLhbTB8kZwE7BhK76ZsLmm5aKv78q+1QYcbs7gDFCU6iA@mail.gmail.com>
Subject: Re: [patch net-next v2 3/3] net: devlink: add WARN_ON to check return
 value of unregister_netdevice_notifier_net() call
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        bigeasy@linutronix.de, imagedong@tencent.com, kuniyu@amazon.com,
        petrm@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 9, 2022 at 11:54 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Wed, Nov 09, 2022 at 10:45:36PM CET, kuba@kernel.org wrote:
> >On Wed, 9 Nov 2022 08:26:10 -0800 Eric Dumazet wrote:
> >> > On Tue, Nov 08, 2022 at 02:22:08PM +0100, Jiri Pirko wrote:
> >> > > From: Jiri Pirko <jiri@nvidia.com>
> >> > >
> >> > > As the return value is not 0 only in case there is no such notifier
> >> > > block registered, add a WARN_ON() to yell about it.
> >> > >
> >> > > Suggested-by: Ido Schimmel <idosch@idosch.org>
> >> > > Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> >> >
> >> > Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> >>
> >> Please consider WARN_ON_ONCE(), or DEBUG_NET_WARN_ON_ONCE()
> >
> >Do you have any general guidance on when to pick WARN() vs WARN_ONCE()?
> >Or should we always prefer _ONCE() going forward?
>
> Good question. If so, it should be documented or spotted by checkpatch.
>
> >
> >Let me take the first 2 in, to lower the syzbot volume.

Well, I am not sure what you call 'lower syzbot volume'

netdevsim netdevsim0 netdevsim3 (unregistering): unset [1, 0] type 2
family 0 port 6081 - 0
------------[ cut here ]------------
WARNING: CPU: 1 PID: 41 at net/core/devlink.c:10001
devl_port_unregister+0x2f6/0x390 net/core/devlink.c:10001
Modules linked in:
CPU: 0 PID: 41 Comm: kworker/u4:2 Not tainted
6.1.0-rc3-syzkaller-00887-g0c9ef08a4d0f #0
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 10/26/2022
Workqueue: netns cleanup_net
RIP: 0010:devl_port_unregister+0x2f6/0x390 net/core/devlink.c:10001
Code: e8 3f 37 0b fa 85 ed 0f 85 7a fd ff ff e8 62 3a 0b fa 0f 0b e9
6e fd ff ff e8 56 3a 0b fa 0f 0b e9 53 ff ff ff e8 4a 3a 0b fa <0f> 0b
e9 94 fd ff ff e8 ae ac 57 fa e9 78 ff ff ff e8 74 ac 57 fa
RSP: 0018:ffffc90000b27a08 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88806ee3f810 RCX: 0000000000000000
RDX: ffff8880175e1d40 RSI: ffffffff877177d6 RDI: 0000000000000005
RBP: 0000000000000002 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000000 R12: ffff88806ee3f810
R13: ffff88806ee3f808 R14: ffff88806ee3e800 R15: ffff88806ee3f800
FS: 0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c00023dee0 CR3: 0000000074faf000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
__nsim_dev_port_del+0x1bb/0x240 drivers/net/netdevsim/dev.c:1433
nsim_dev_port_del_all drivers/net/netdevsim/dev.c:1443 [inline]
nsim_dev_reload_destroy+0x171/0x510 drivers/net/netdevsim/dev.c:1660
nsim_dev_reload_down+0x6b/0xd0 drivers/net/netdevsim/dev.c:968
devlink_reload+0x1c4/0x6e0 net/core/devlink.c:4501
devlink_pernet_pre_exit+0x104/0x1c0 net/core/devlink.c:12615
ops_pre_exit_list net/core/net_namespace.c:159 [inline]
cleanup_net+0x451/0xb10 net/core/net_namespace.c:594
process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
worker_thread+0x665/0x1080 kernel/workqueue.c:2436
kthread+0x2e4/0x3a0 kernel/kthread.c:376
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
</TASK>
