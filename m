Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C9D62DA22
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 13:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239897AbiKQMDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 07:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239885AbiKQMDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 07:03:34 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4AD1CB2D
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:03:32 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id x5-20020a6bda05000000b006db3112c1deso787334iob.0
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:03:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=juTJp/R7jG3Dr/MF/K7NwS0ryQI9fpomBjZtVXayJyY=;
        b=Jzk5JGojB/zrVPydiXtUl2jPPuSaA/LnM0sivlNO6N6yp1v98KSEMsJQeiB23r3BKP
         Ldk+ejFERf58H8hxU3ng2WDPvpOG1IFNoZtKyxrlE5n0e/ICFK4Jzxrzfk9rAaAMPOrh
         6iH7F02Kr3HEG7roDI39LRuTfnXd/BGLuZ7ZE02ENdZZj0pOakz3sFw80T34btF1r4ZZ
         8Bwhx0UknSzHHCXW5qPoCy5m4ahzHQ4/e1ZkBwh1eizbT40inD8by06lB6oZVbA1tE3g
         BU2dOegZ4s3LzCRBJB5D53+kzu5n+T9Q5RIM1KjNmA+N5i/ZAkxzP1Qfp4ORZa/oXKav
         vJGg==
X-Gm-Message-State: ANoB5pnanMbW7Ge3pBZ561p94GoZnHJB3iXSyXsHGs5TgNy0CRVnj3tn
        BovxyC+oPdjz5SPa9NBzDJ3KicjA0DniNsBAHP5kVI7fNGkN
X-Google-Smtp-Source: AA0mqf5nueY+wTiUbi0BE6eyOzMUeRG4cblCP7Ed5eeh/1mkvjHkPirp9i6w5flT9KueHHtZxzxMoF+vDJpSEQpUSUt8S2as6mZz
MIME-Version: 1.0
X-Received: by 2002:a92:cf02:0:b0:302:3db8:6d47 with SMTP id
 c2-20020a92cf02000000b003023db86d47mr974029ilo.301.1668686611930; Thu, 17 Nov
 2022 04:03:31 -0800 (PST)
Date:   Thu, 17 Nov 2022 04:03:31 -0800
In-Reply-To: <0000000000004e78ec05eda79749@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bef99e05eda9604a@google.com>
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in static_key_slow_inc
From:   syzbot <syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com>
To:     Jason@zx2c4.com, davem@davemloft.net, edumazet@google.com,
        frederic@kernel.org, jacob.e.keller@intel.com, jiri@nvidia.com,
        juri.lelli@redhat.com, kirill.shutemov@linux.intel.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, netdev@vger.kernel.org,
        nicolas.dichtel@6wind.com, pabeni@redhat.com, paul@paul-moore.com,
        peterz@infradead.org, razor@blackwall.org,
        sathyanarayanan.kuppuswamy@linux.intel.com, steven.price@arm.com,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
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

HEAD commit:    064bc7312bd0 netdevsim: Fix memory leak of nsim_dev->fa_co..
git tree:       net
console+strace: https://syzkaller.appspot.com/x/log.txt?x=16b2b231880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a33ac7bbc22a8c35
dashboard link: https://syzkaller.appspot.com/bug?extid=703d9e154b3b58277261
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13cd2f79880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=109e1695880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0634e1c0e4cb/disk-064bc731.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fe1039d2de22/vmlinux-064bc731.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5a0d673875fa/bzImage-064bc731.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at include/linux/percpu-rwsem.h:49
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 3634, name: syz-executor167
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
3 locks held by syz-executor167/3634:
 #0: ffffffff8df6b530 (cb_lock){++++}-{3:3}, at: genl_rcv+0x19/0x40 net/netlink/genetlink.c:860
 #1: ffffffff8df6b5e8 (genl_mutex){+.+.}-{3:3}, at: genl_lock net/netlink/genetlink.c:33 [inline]
 #1: ffffffff8df6b5e8 (genl_mutex){+.+.}-{3:3}, at: genl_rcv_msg+0x50d/0x780 net/netlink/genetlink.c:848
 #2: ffff8880182fa0b8 (k-clock-AF_INET){+++.}-{2:2}, at: l2tp_tunnel_register+0x126/0x1210 net/l2tp/l2tp_core.c:1477
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 PID: 3634 Comm: syz-executor167 Not tainted 6.1.0-rc4-syzkaller-00212-g064bc7312bd0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 __might_resched.cold+0x222/0x26b kernel/sched/core.c:9890
 percpu_down_read include/linux/percpu-rwsem.h:49 [inline]
 cpus_read_lock+0x1b/0x140 kernel/cpu.c:310
 static_key_slow_inc+0x12/0x20 kernel/jump_label.c:158
 udp_tunnel_encap_enable include/net/udp_tunnel.h:189 [inline]
 setup_udp_tunnel_sock+0x3e1/0x550 net/ipv4/udp_tunnel_core.c:81
 l2tp_tunnel_register+0xc51/0x1210 net/l2tp/l2tp_core.c:1509
 l2tp_nl_cmd_tunnel_create+0x3d6/0x8b0 net/l2tp/l2tp_netlink.c:245
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:756
 genl_family_rcv_msg net/netlink/genetlink.c:833 [inline]
 genl_rcv_msg+0x445/0x780 net/netlink/genetlink.c:850
 netlink_rcv_skb+0x157/0x430 net/netlink/af_netlink.c:2540
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:861
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xd3/0x120 net/socket.c:734
 sock_no_sendpage+0x10c/0x160 net/core/sock.c:3219
 kernel_sendpage.part.0+0x1d5/0x700 net/socket.c:3561
 kernel_sendpage net/socket.c:3558 [inline]
 sock_sendpage+0xe3/0x140 net/socket.c:1054
 pipe_to_sendpage+0x2b1/0x380 fs/splice.c:361
 splice_from_pipe_feed fs/splice.c:415 [inline]
 __splice_from_pipe+0x449/0x8a0 fs/splice.c:559
 splice_from_pipe fs/splice.c:594 [inline]
 generic_splice_sendpage+0xd8/0x140 fs/splice.c:743
 do_splice_from fs/splice.c:764 [inline]
 direct_splice_actor+0x114/0x180 fs/splice.c:931
 splice_direct_to_actor+0x335/0x8a0 fs/splice.c:886
 do_splice_direct+0x1ab/0x280 fs/splice.c:974
 do_sendfile+0xb19/0x1270 fs/read_write.c:1255
 __do_sys_sendfile64 fs/read_write.c:1323 [inline]
 __se_sys_sendfile64 fs/read_write.c:1309 [inline]
 __x64_sys_sendfile64+0x1d0/0x210 fs/read_write.c:1309
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f93d1567cb9
Code: 28 c3 e8 5a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdd8ae4a88 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f93d1567cb9
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000005
RBP: 00007f93d152b680 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000100000000 R11: 0000000000000246 R12: 00007f93d152b710
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>

