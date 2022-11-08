Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADCB3621299
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 14:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbiKHNlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 08:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233936AbiKHNkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 08:40:43 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326E14FFBE
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 05:40:43 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id x5-20020a6bda05000000b006db3112c1deso3605418iob.0
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 05:40:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lIRjWRyR/WNWUuHmfvOw0G6aB24s/R1ym1OkCgoq76Y=;
        b=ePtCSX0DCggJ0O5aSR7/i23teqb2Zn1S7O0pNHm/htcgaGH8Hg8+ij1xH7ZDcEd4JY
         DLfj/reD1l3/EP9/vMyXUBDBhGa+ZPYQgGmcqXijH5kV3G5BLM66sj63/u2OWxk273yX
         Z8+JfVQcJ1oGnMDF5XXaXLxnkhMCyMhcT3dXj93hpcEjQ2gisukuSDUQIwG3m9wl9R7U
         2/FcSE2KUEcNYl2tHpcaFxWZj2ZZ2Vt9rX26DBaY7IViDoX5TeYfxwrHLbsweGMjf/Jj
         4icS5wWyg/9NRt6yeTsVjgPuWDw7ErC9ZuqAJ7eTOBpLEQ75Vh2shoOZLItmDTjhW68V
         x55w==
X-Gm-Message-State: ACrzQf0EzohLU663OL2exGM1ahEEDQ0dLoTanPgIb2YI1+iMrOy/Ebnp
        FA/noqaSBpr3TXM23bHKwYXAEdHluCS1M3M33IxSZWDceVqM
X-Google-Smtp-Source: AMsMyM6BkDF321uwHJ2d16e816qvxotb/2TSNQsHEBIupCfepvK/BiplQNE6Ub0Mey7VoPu8e5Von7i8j48KDE0L2q6hgihB7pM9
MIME-Version: 1.0
X-Received: by 2002:a92:6a12:0:b0:2f6:3bd1:fbdf with SMTP id
 f18-20020a926a12000000b002f63bd1fbdfmr30767624ilc.205.1667914842558; Tue, 08
 Nov 2022 05:40:42 -0800 (PST)
Date:   Tue, 08 Nov 2022 05:40:42 -0800
In-Reply-To: <0000000000003687bd05c2b2401d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b4dae405ecf5af7f@google.com>
Subject: Re: [syzbot] BUG: MAX_LOCKDEP_KEYS too low! (2)
From:   syzbot <syzbot+a70a6358abd2c3f9550f@syzkaller.appspotmail.com>
To:     Jason@zx2c4.com, davem@davemloft.net, dvyukov@google.com,
        edumazet@google.com, jiri@resnulli.us, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, penguin-kernel@i-love.sakura.ne.jp,
        peterz@infradead.org, rdunlap@infradead.org,
        syzkaller-bugs@googlegroups.com, tonymarislogistics@yandex.com,
        wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    3577a7611842 Merge branches 'for-next/acpi', 'for-next/kbu..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=15ea3e61880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=606e57fd25c5c6cc
dashboard link: https://syzkaller.appspot.com/bug?extid=a70a6358abd2c3f9550f
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=168c4c99880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=145d6376880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/054b1f56af52/disk-3577a761.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c616835b2a22/vmlinux-3577a761.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9825c28b2090/Image-3577a761.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a70a6358abd2c3f9550f@syzkaller.appspotmail.com

netlink: 4 bytes leftover after parsing attributes in process `syz-executor357'.
device team6635 entered promiscuous mode
8021q: adding VLAN 0 to HW filter on device team6635
BUG: MAX_LOCKDEP_KEYS too low!
turning off the locking correctness validator.
CPU: 0 PID: 9692 Comm: syz-executor357 Not tainted 6.1.0-rc4-syzkaller-31844-g3577a7611842 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/30/2022
Call trace:
 dump_backtrace+0x1c4/0x1f0 arch/arm64/kernel/stacktrace.c:156
 show_stack+0x2c/0x54 arch/arm64/kernel/stacktrace.c:163
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x104/0x16c lib/dump_stack.c:106
 dump_stack+0x1c/0x58 lib/dump_stack.c:113
 register_lock_class+0x2e4/0x2f8 kernel/locking/lockdep.c:1326
 __lock_acquire+0xa8/0x3084 kernel/locking/lockdep.c:4934
 lock_acquire+0x100/0x1f8 kernel/locking/lockdep.c:5668
 __mutex_lock_common+0xd4/0xca8 kernel/locking/mutex.c:603
 __mutex_lock kernel/locking/mutex.c:747 [inline]
 mutex_lock_nested+0x38/0x44 kernel/locking/mutex.c:799
 team_vlan_rx_add_vid+0x38/0xd8 drivers/net/team/team.c:1904
 vlan_add_rx_filter_info net/8021q/vlan_core.c:211 [inline]
 __vlan_vid_add net/8021q/vlan_core.c:306 [inline]
 vlan_vid_add+0x328/0x38c net/8021q/vlan_core.c:336
 vlan_device_event+0x200/0xc4c net/8021q/vlan.c:385
 notifier_call_chain kernel/notifier.c:87 [inline]
 raw_notifier_call_chain+0x7c/0x108 kernel/notifier.c:455
 __dev_notify_flags+0x170/0x2e8
 rtnl_newlink_create+0x460/0x6bc net/core/rtnetlink.c:3372
 __rtnl_newlink net/core/rtnetlink.c:3581 [inline]
 rtnl_newlink+0x728/0xa04 net/core/rtnetlink.c:3594
 rtnetlink_rcv_msg+0x484/0x82c net/core/rtnetlink.c:6091
 netlink_rcv_skb+0xe8/0x1d4 net/netlink/af_netlink.c:2540
 rtnetlink_rcv+0x28/0x38 net/core/rtnetlink.c:6109
 netlink_unicast_kernel+0xfc/0x1dc net/netlink/af_netlink.c:1319
 netlink_unicast+0x164/0x248 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x484/0x584 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0x2f8/0x440 net/socket.c:2482
 ___sys_sendmsg net/socket.c:2536 [inline]
 __sys_sendmsg+0x1ac/0x228 net/socket.c:2565
 __do_sys_sendmsg net/socket.c:2574 [inline]
 __se_sys_sendmsg net/socket.c:2572 [inline]
 __arm64_sys_sendmsg+0x2c/0x3c net/socket.c:2572
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall arch/arm64/kernel/syscall.c:52 [inline]
 el0_svc_common+0x138/0x220 arch/arm64/kernel/syscall.c:142
 do_el0_svc+0x48/0x164 arch/arm64/kernel/syscall.c:206
 el0_svc+0x58/0x150 arch/arm64/kernel/entry-common.c:637
 el0t_64_sync_handler+0x84/0xf0 arch/arm64/kernel/entry-common.c:655
 el0t_64_sync+0x18c/0x190 arch/arm64/kernel/entry.S:581

