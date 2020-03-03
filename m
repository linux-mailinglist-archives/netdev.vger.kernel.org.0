Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25263177869
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 15:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbgCCOKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 09:10:17 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39599 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729593AbgCCOKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 09:10:08 -0500
Received: by mail-wr1-f65.google.com with SMTP id y17so4509095wrn.6
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 06:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ppjTTRSxDkqsFonnJRiZqlBZgTzyFzr2NmtbUAK1iGY=;
        b=IanPHeJbyBYiJPLkaKtGNuoBeFK0JAgtgDThLsxHwgetDpg7v7s8pzarRylOcFxTmb
         B3AZ3le5Z1ZQ2Z8m5c1mbtsUj1gAGZtyhKNJfwWnys1eSxWAP6Eqs3dkQt33a9N+SYwP
         R6C2t5vObT6dWQbeOjUldoxdVRhHwDVgtK3zwdZ0kQH4Nt1kXM3aGiX3owlMJeguO3pY
         L3P5v3tUwsGryqDmN66zX2vm/eGoVy/6WZpRTEKA56NdIqXtiKUd+Xq/kZ6Ey3sM0ruj
         dAgZwMDTPwz38kwhsM/I3HGJMp+VeeQolNGpnqpJjp7usEPbFHMtzdzeiDU6htp7lvjy
         Ehyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ppjTTRSxDkqsFonnJRiZqlBZgTzyFzr2NmtbUAK1iGY=;
        b=Z7sA319vC5iuMnxLlhw2iJBM+R7koa/DK3LRMqPJq0bPi7MBhs5Tzy4jw0rGnUuTr5
         y7T0wgFPr+NuYGHLxlb7o6rQMj3T+5dHYSE+Jy1soDDM0iqSc+oF3DNNRjGxiyFBfPj8
         8svkOdPejyHJtkwEN395SaBlU2t+7sAS19W2O7TEC4FrF9vYICyexxVdfJf2crGN4GW4
         FJhUPS4pEwl647DlBZwbqgeo+Au8IcJ8GI8wFumwCeQRx8Lw/CqUMKSOPVacpEOwfkPF
         NqSvZiBicixq+MNIu+/AV5pOO7V80iUa68t9Ig4QHf/n38YpIV1vjwYAuQuQWPVIvSeM
         97tQ==
X-Gm-Message-State: ANhLgQ2Vx04QSA/biuxAFkhxZhMJDvnLfZ+MhtQbWmwYgs09OG3BYZHp
        fHut7S+gjj1RR0kmAWbfW/ePJQ==
X-Google-Smtp-Source: ADFU+vuuNH3/Wba0Bee4G2gpwQ/0j++QuGFKFTe2brqTLKFz41qc8r3aEwGHFmdnVARg/E1ccjLMqg==
X-Received: by 2002:adf:e9c2:: with SMTP id l2mr5487794wrn.86.1583244606299;
        Tue, 03 Mar 2020 06:10:06 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id o5sm4452752wmb.8.2020.03.03.06.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 06:10:05 -0800 (PST)
Date:   Tue, 3 Mar 2020 15:10:04 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     syzbot <syzbot+eeca95faae43d590987b@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: possible deadlock in team_port_change_check
Message-ID: <20200303141004.GN2178@nanopsycho>
References: <000000000000f44aca059fe3232d@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000f44aca059fe3232d@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Mar 02, 2020 at 07:13:13PM CET, syzbot+eeca95faae43d590987b@syzkaller.appspotmail.com wrote:
>Hello,
>
>syzbot found the following crash on:
>
>HEAD commit:    3b3e808c Merge tag 'mac80211-next-for-net-next-2020-02-24'..
>git tree:       net-next
>console output: https://syzkaller.appspot.com/x/log.txt?x=146c04f9e00000
>kernel config:  https://syzkaller.appspot.com/x/.config?x=6ec9623400ee72
>dashboard link: https://syzkaller.appspot.com/bug?extid=eeca95faae43d590987b
>compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
>Unfortunately, I don't have any reproducer for this crash yet.
>
>IMPORTANT: if you fix the bug, please add the following tag to the commit:
>Reported-by: syzbot+eeca95faae43d590987b@syzkaller.appspotmail.com
>
>device team_slave_1 left promiscuous mode
>device vlan2 left promiscuous mode
>device team_slave_0 left promiscuous mode
>bridge9: port 1(@) entered disabled state

Interesting. Would be great to know the output of "ip link" here.


>============================================
>WARNING: possible recursive locking detected
>5.6.0-rc2-syzkaller #0 Not tainted
>--------------------------------------------
>syz-executor.5/26255 is trying to acquire lock:
>ffff88805be96bf0 (team->team_lock_key#6){+.+.}, at: team_port_change_check+0x49/0x140 drivers/net/team/team.c:2962
>
>but task is already holding lock:
>ffff88805be96bf0 (team->team_lock_key#6){+.+.}, at: team_uninit+0x37/0x1c0 drivers/net/team/team.c:1665
>
>other info that might help us debug this:
> Possible unsafe locking scenario:
>
>       CPU0
>       ----
>  lock(team->team_lock_key#6);
>  lock(team->team_lock_key#6);
>
> *** DEADLOCK ***
>
> May be due to missing lock nesting notation
>
>2 locks held by syz-executor.5/26255:
> #0: ffffffff8a74d740 (rtnl_mutex){+.+.}, at: rtnl_lock net/core/rtnetlink.c:72 [inline]
> #0: ffffffff8a74d740 (rtnl_mutex){+.+.}, at: rtnetlink_rcv_msg+0x405/0xaf0 net/core/rtnetlink.c:5437
> #1: ffff88805be96bf0 (team->team_lock_key#6){+.+.}, at: team_uninit+0x37/0x1c0 drivers/net/team/team.c:1665
>
>stack backtrace:
>CPU: 0 PID: 26255 Comm: syz-executor.5 Not tainted 5.6.0-rc2-syzkaller #0
>Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>Call Trace:
> __dump_stack lib/dump_stack.c:77 [inline]
> dump_stack+0x197/0x210 lib/dump_stack.c:118
> print_deadlock_bug kernel/locking/lockdep.c:2370 [inline]
> check_deadlock kernel/locking/lockdep.c:2411 [inline]
> validate_chain kernel/locking/lockdep.c:2954 [inline]
> __lock_acquire.cold+0x15d/0x385 kernel/locking/lockdep.c:3954
> lock_acquire+0x190/0x410 kernel/locking/lockdep.c:4484
> __mutex_lock_common kernel/locking/mutex.c:956 [inline]
> __mutex_lock+0x156/0x13c0 kernel/locking/mutex.c:1103
> mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1118
> team_port_change_check+0x49/0x140 drivers/net/team/team.c:2962
> team_device_event+0x16a/0x420 drivers/net/team/team.c:2988
> notifier_call_chain+0xc2/0x230 kernel/notifier.c:83
> __raw_notifier_call_chain kernel/notifier.c:361 [inline]
> raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:368
> call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
> call_netdevice_notifiers_info+0xba/0x130 net/core/dev.c:1933
> call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
> call_netdevice_notifiers net/core/dev.c:1974 [inline]
> dev_close_many+0x32a/0x6c0 net/core/dev.c:1549
> vlan_device_event+0x9a9/0x2370 net/8021q/vlan.c:450
> notifier_call_chain+0xc2/0x230 kernel/notifier.c:83
> __raw_notifier_call_chain kernel/notifier.c:361 [inline]
> raw_notifier_call_chain+0x2e/0x40 kernel/notifier.c:368
> call_netdevice_notifiers_info net/core/dev.c:1948 [inline]
> call_netdevice_notifiers_info+0xba/0x130 net/core/dev.c:1933
> call_netdevice_notifiers_extack net/core/dev.c:1960 [inline]
> call_netdevice_notifiers net/core/dev.c:1974 [inline]
> dev_close_many+0x32a/0x6c0 net/core/dev.c:1549
> dev_close.part.0+0x114/0x1e0 net/core/dev.c:1571
> dev_close+0x63/0x80 net/core/dev.c:1574
> team_port_del+0x35c/0x800 drivers/net/team/team.c:1345
> team_uninit+0xc3/0x1c0 drivers/net/team/team.c:1667
> rollback_registered_many+0xa06/0x1030 net/core/dev.c:8824
> unregister_netdevice_many.part.0+0x1b/0x1f0 net/core/dev.c:9963
> unregister_netdevice_many+0x3b/0x50 net/core/dev.c:9962
> rtnl_delete_link+0xda/0x130 net/core/rtnetlink.c:2933
> rtnl_dellink+0x341/0x9e0 net/core/rtnetlink.c:2985
> rtnetlink_rcv_msg+0x45e/0xaf0 net/core/rtnetlink.c:5440
> netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2478
> rtnetlink_rcv+0x1d/0x30 net/core/rtnetlink.c:5458
> netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
> netlink_unicast+0x59e/0x7e0 net/netlink/af_netlink.c:1329
> netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1918
> sock_sendmsg_nosec net/socket.c:652 [inline]
> sock_sendmsg+0xd7/0x130 net/socket.c:672
> ____sys_sendmsg+0x753/0x880 net/socket.c:2343
> ___sys_sendmsg+0x100/0x170 net/socket.c:2397
> __sys_sendmsg+0x105/0x1d0 net/socket.c:2430
> __do_sys_sendmsg net/socket.c:2439 [inline]
> __se_sys_sendmsg net/socket.c:2437 [inline]
> __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2437
> do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
> entry_SYSCALL_64_after_hwframe+0x49/0xbe
>RIP: 0033:0x45c479
>Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
>RSP: 002b:00007f8bb9fd6c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
>RAX: ffffffffffffffda RBX: 00007f8bb9fd76d4 RCX: 000000000045c479
>RDX: 0000000000000000 RSI: 00000000200002c0 RDI: 000000000000000a
>RBP: 000000000076c060 R08: 0000000000000000 R09: 0000000000000000
>R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
>R13: 00000000000009f9 R14: 00000000004cc71a R15: 000000000076c06c
>
>
>---
>This bug is generated by a bot. It may contain errors.
>See https://goo.gl/tpsmEJ for more information about syzbot.
>syzbot engineers can be reached at syzkaller@googlegroups.com.
>
>syzbot will keep track of this bug report. See:
>https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
