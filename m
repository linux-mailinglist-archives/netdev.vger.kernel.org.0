Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B4E1BBDA4
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 14:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgD1MbG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 08:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726678AbgD1MbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 08:31:05 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD91C03C1AB
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 05:31:05 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id v38so10227343qvf.6
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 05:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JNtmXAkpuSJsbdYHW7jxcW7slmKbuQwacD8ALgza5Fg=;
        b=JHeAtbbWWoXFkezF21fSmjuV2DT/vPVXvrPbe/BJAGiYmbCIqKRO+X++I/75aTW9BW
         TaR/NOB/Xoe9l9nh9KSyGTv8aiu7sZ+KURuXinWUOOtW/ubOveIdxLAl0OtaREMXK63c
         /DD5wwy7CW/9qEXS4HvKWC4ZfSDN2Jt/StPtwzbyrfukHoop2oL0O2Asp3vDPHWhZvQy
         /Q1cdnbxGjXnNNpKlZhB1h49be5ZYyQP0BjuvZzv+HbNiVrHSqLRP4ZUJN1f+MU54P/I
         daVVLKMwdqzmvpxVwcz3ppkFPzODPAiHshW9bDQSZOIT+tidA7ctF/9TiG/Yjaca9Nmy
         u87w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JNtmXAkpuSJsbdYHW7jxcW7slmKbuQwacD8ALgza5Fg=;
        b=W1Vq2I6Z2dvFGRfathW+5iBMVZtp5rdbR+uJi7oLzE9AJiPkaoKkMNRzcOpbH+naCi
         UvifCWy6QUAxWgCu9WSKpBIeu7Rg76I+0EewHBIBAusHYr5NpGcASMKpbJr+hFnNJfPV
         7y1pBpKUmWX70D/HkId5PC3MhXQB3ynPGEVFArKIIQV3A4JtaQJkOl35FiNVKtRUShKf
         uuzs8uSB4x+OLSzTbY0rZdsbEfcYYbJUMLLrCggt74Hdx135aNtBjSlUfmxAEK81iLWZ
         8ESXMhAT0iRqAPamvq2vUE8AP0US4YK7eKJz40v48IslFjmbjpeG9rGkHH5nSVAmUcX7
         ftPg==
X-Gm-Message-State: AGi0Pubop6Vf0Prj+xItQdatiQh+jmKg+jTeLX5drLpQZHD48pZs7+I2
        yHuFhrLvWeYmsFJ1tLpCtBHm6g==
X-Google-Smtp-Source: APiQypLQhm7d2totk9wsM8SSMtucKY1pACGHs2G/1VdgdMk6N4/Up2wlUNMM9EBdxyr+wsxgAWa54Q==
X-Received: by 2002:a05:6214:15d1:: with SMTP id p17mr28280413qvz.45.1588077064456;
        Tue, 28 Apr 2020 05:31:04 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id c124sm13716160qke.13.2020.04.28.05.31.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Apr 2020 05:31:03 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jTPOA-0007KY-KW; Tue, 28 Apr 2020 09:31:02 -0300
Date:   Tue, 28 Apr 2020 09:31:02 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+4088ed905e4ae2b0e13b@syzkaller.appspotmail.com>,
        dledford@redhat.com, kamalheib1@gmail.com, leon@kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, parav@mellanox.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: WARNING in ib_unregister_device_queued
Message-ID: <20200428123102.GR26002@ziepe.ca>
References: <000000000000aa012505a431c7d9@google.com>
 <20200428041956.5704-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428041956.5704-1-hdanton@sina.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 12:19:55PM +0800, Hillf Danton wrote:
> 
> Sun, 26 Apr 2020 06:43:13 -0700
> > syzbot found the following crash on:
> > 
> > HEAD commit:    b9663b7c net: stmmac: Enable SERDES power up/down sequence
> > git tree:       net
> > console output: https://syzkaller.appspot.com/x/log.txt?x=166bf717e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=5d351a1019ed81a2
> > dashboard link: https://syzkaller.appspot.com/bug?extid=4088ed905e4ae2b0e13b
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > 
> > Unfortunately, I don't have any reproducer for this crash yet.
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+4088ed905e4ae2b0e13b@syzkaller.appspotmail.com
> > 
> > rdma_rxe: ignoring netdev event = 10 for netdevsim0
> > infiniband  yz2: set down
> > WARNING: CPU: 0 PID: 22753 at drivers/infiniband/core/device.c:1565 ib_unregister_device_queued+0x122/0x160 drivers/infiniband/core/device.c:1565
> > Kernel panic - not syncing: panic_on_warn set ...
> > CPU: 0 PID: 22753 Comm: syz-executor.5 Not tainted 5.7.0-rc1-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:77 [inline]
> >  dump_stack+0x188/0x20d lib/dump_stack.c:118
> >  panic+0x2e3/0x75c kernel/panic.c:221
> >  __warn.cold+0x2f/0x35 kernel/panic.c:582
> >  report_bug+0x27b/0x2f0 lib/bug.c:195
> >  fixup_bug arch/x86/kernel/traps.c:175 [inline]
> >  fixup_bug arch/x86/kernel/traps.c:170 [inline]
> >  do_error_trap+0x12b/0x220 arch/x86/kernel/traps.c:267
> >  do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:286
> >  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
> > RIP: 0010:ib_unregister_device_queued+0x122/0x160 drivers/infiniband/core/device.c:1565
> > Code: fb e8 72 e2 d4 fb 48 89 ef e8 2a c3 c1 fe 48 83 c4 08 5b 5d e9 5f e2 d4 fb e8 5a e2 d4 fb 0f 0b e9 46 ff ff ff e8 4e e2 d4 fb <0f> 0b e9 6f ff ff ff 48 89 ef e8 2f a9 12 fc e9 16 ff ff ff 48 c7
> > RSP: 0018:ffffc900072ef290 EFLAGS: 00010246
> > RAX: 0000000000040000 RBX: ffff8880a6a24000 RCX: ffffc90013201000
> > RDX: 0000000000040000 RSI: ffffffff859e51b2 RDI: ffff8880a6a24310
> > RBP: 0000000000000019 R08: ffff88808d21c280 R09: ffffed1014d449bb
> > R10: ffff8880a6a24dd3 R11: ffffed1014d449ba R12: 0000000000000006
> > R13: ffff88805988c000 R14: 0000000000000000 R15: ffffffff8a44f8c0
> >  rxe_notify+0x77/0xd0 drivers/infiniband/sw/rxe/rxe_net.c:605
> >  notifier_call_chain+0xc0/0x230 kernel/notifier.c:83
> >  call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
> >  call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1933
> >  call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
> >  call_netdevice_notifiers net/core/dev.c:1974 [inline]
> >  rollback_registered_many+0x75c/0xe70 net/core/dev.c:8828
> >  rollback_registered+0xf2/0x1c0 net/core/dev.c:8873
> >  unregister_netdevice_queue net/core/dev.c:9969 [inline]
> >  unregister_netdevice_queue+0x1d7/0x2b0 net/core/dev.c:9962
> >  unregister_netdevice include/linux/netdevice.h:2725 [inline]
> >  nsim_destroy+0x35/0x60 drivers/net/netdevsim/netdev.c:330
> >  __nsim_dev_port_del+0x144/0x1e0 drivers/net/netdevsim/dev.c:934
> >  nsim_dev_port_del_all+0x86/0xe0 drivers/net/netdevsim/dev.c:947
> >  nsim_dev_reload_destroy+0x77/0x110 drivers/net/netdevsim/dev.c:1123
> >  nsim_dev_reload_down+0x6e/0xd0 drivers/net/netdevsim/dev.c:703
> >  devlink_reload+0xbd/0x3b0 net/core/devlink.c:2797
> >  devlink_nl_cmd_reload+0x2f7/0x7c0 net/core/devlink.c:2832
> >  genl_family_rcv_msg_doit net/netlink/genetlink.c:673 [inline]
> >  genl_family_rcv_msg net/netlink/genetlink.c:718 [inline]
> >  genl_rcv_msg+0x627/0xdf0 net/netlink/genetlink.c:735
> >  netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
> >  genl_rcv+0x24/0x40 net/netlink/genetlink.c:746
> >  netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
> >  netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
> >  netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
> >  sock_sendmsg_nosec net/socket.c:652 [inline]
> >  sock_sendmsg+0xcf/0x120 net/socket.c:672
> >  ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
> >  ___sys_sendmsg+0x100/0x170 net/socket.c:2416
> >  __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
> >  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
> >  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> 
> 
> Quiesce the warning by adding a dummy destruct function and using it in
> the error path that is supposedly related to triggering the warning.

Yeah, something like that might work if this is the source of the bug

Thanks,
Jason
