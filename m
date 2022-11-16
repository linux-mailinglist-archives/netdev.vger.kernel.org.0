Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC7062BAED
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 12:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbiKPLHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 06:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238791AbiKPLGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 06:06:16 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 867C04D5E5
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 02:52:38 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id o15-20020a6bf80f000000b006de313e5cfeso3002846ioh.6
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 02:52:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=r5Mo3se87QXpAJqaeTXSh10+7HEJMNv3CBA6OYfMFVY=;
        b=Qen42XF2ejOBDxxfBoK0aYKFfLHcG3l2sJR/J2Yf0uKn5qqLJKjyNgsqpA5lRqirsZ
         vfXRhwNogUcC4AEOeVMleQZfP/oAv9rr2GEZteMHrrJpv/kG8ZaB9tZ1ZrQN0nggVYsq
         QOgS3VvwyBxjAavh5JYwmyMgdT+mKiVMpUI1JuKU9/EETdSE4qGKybDFmw4i39fPGHs1
         QhEq6Mi91P8NoDdfmR3oCGaFHSBWpOjRPffwbTqX/mdmUmatXyMP/wkHnOFRccryareD
         0wkyy0fBVIQYLNa1wUE3EF7wx8VcClA6P66BZ3td8PGQGCneZyDmAELToQaLEG8auLSM
         3yzg==
X-Gm-Message-State: ANoB5plaAYx5OSkdYqXsELDoFpMpz1XNRH52nS0rvVaJxu5KMFdH302b
        QkxY4GlORS8purDJioSqarxZtPWPkIB/LRE0WfD0+9sl9C1f
X-Google-Smtp-Source: AA0mqf7z1TewLjFF2jnBF2kRP1TKMrKIze+hpDOzyqrUgOVL75Oeqpa4SvTQWLKWQDW7jm2BybG7n8Ct3FBeWArnNssoARIPI76J
MIME-Version: 1.0
X-Received: by 2002:a02:aa1b:0:b0:375:61b2:825a with SMTP id
 r27-20020a02aa1b000000b0037561b2825amr10377889jam.147.1668595957928; Wed, 16
 Nov 2022 02:52:37 -0800 (PST)
Date:   Wed, 16 Nov 2022 02:52:37 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000058983805ed944512@google.com>
Subject: [syzbot] BUG: unable to handle kernel NULL pointer dereference in nci_send_cmd
From:   syzbot <syzbot+4adf5ff0f6e6876c6a81@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org, linma@zju.edu.cn,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
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

Hello,

syzbot found the following issue on:

HEAD commit:    81e7cfa3a9eb Merge tag 'erofs-for-6.1-rc6-fixes' of git://..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=13b7800d880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a2318f9a4fc31ad
dashboard link: https://syzkaller.appspot.com/bug?extid=4adf5ff0f6e6876c6a81
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f435be880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1134d295880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/54f7533927a5/disk-81e7cfa3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f3861072b476/vmlinux-81e7cfa3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c36747ab66fe/bzImage-81e7cfa3.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4adf5ff0f6e6876c6a81@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 PID: 3636 Comm: syz-executor551 Not tainted 6.1.0-rc5-syzkaller-00015-g81e7cfa3a9eb #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:__queue_work+0x1f6/0x13b0 kernel/workqueue.c:1459
Code: ff ff 48 89 c3 e8 2a 6b 2e 00 4c 89 e7 e8 f2 59 ff ff 48 85 c0 49 89 c5 0f 84 57 01 00 00 e8 11 6b 2e 00 48 89 d8 48 c1 e8 03 <80> 3c 28 00 0f 85 4a 10 00 00 4c 39 2b 0f 84 51 01 00 00 e8 f2 6a
RSP: 0018:ffffc90003dff388 EFLAGS: 00010056
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888020e2ba80 RSI: ffffffff8151ae6f RDI: 0000000000000001
RBP: dffffc0000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff888020a890f8
R13: ffff888012069800 R14: ffff888021d5d800 R15: ffff888021d5d800
FS:  00007f11539a4700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1153a55390 CR3: 0000000077b28000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 queue_work_on+0xf2/0x110 kernel/workqueue.c:1545
 queue_work include/linux/workqueue.h:503 [inline]
 nci_send_cmd+0x247/0x340 net/nfc/nci/core.c:1376
 nci_reset_req+0x76/0xa0 net/nfc/nci/core.c:166
 __nci_request+0x87/0x280 net/nfc/nci/core.c:107
 nci_open_device net/nfc/nci/core.c:502 [inline]
 nci_dev_up+0x2af/0x670 net/nfc/nci/core.c:631
 nfc_dev_up+0x1aa/0x3b0 net/nfc/core.c:118
 nfc_genl_dev_up+0xa6/0xf0 net/nfc/netlink.c:770
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
 ____sys_sendmsg+0x712/0x8c0 net/socket.c:2482
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2565
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f1153a142f9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 d1 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f11539a4318 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f1153a9d438 RCX: 00007f1153a142f9
RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000004
RBP: 00007f1153a9d430 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000246 R12: 00007f1153a6a134
R13: 00007ffc4c3309cf R14: 00007f11539a4400 R15: 0000000000022000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__queue_work+0x1f6/0x13b0 kernel/workqueue.c:1459
Code: ff ff 48 89 c3 e8 2a 6b 2e 00 4c 89 e7 e8 f2 59 ff ff 48 85 c0 49 89 c5 0f 84 57 01 00 00 e8 11 6b 2e 00 48 89 d8 48 c1 e8 03 <80> 3c 28 00 0f 85 4a 10 00 00 4c 39 2b 0f 84 51 01 00 00 e8 f2 6a
RSP: 0018:ffffc90003dff388 EFLAGS: 00010056
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888020e2ba80 RSI: ffffffff8151ae6f RDI: 0000000000000001
RBP: dffffc0000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff888020a890f8
R13: ffff888012069800 R14: ffff888021d5d800 R15: ffff888021d5d800
FS:  00007f11539a4700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1153a55390 CR3: 0000000077b28000 CR4: 0000000000350ef0
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	ff 48 89             	decl   -0x77(%rax)
   3:	c3                   	retq
   4:	e8 2a 6b 2e 00       	callq  0x2e6b33
   9:	4c 89 e7             	mov    %r12,%rdi
   c:	e8 f2 59 ff ff       	callq  0xffff5a03
  11:	48 85 c0             	test   %rax,%rax
  14:	49 89 c5             	mov    %rax,%r13
  17:	0f 84 57 01 00 00    	je     0x174
  1d:	e8 11 6b 2e 00       	callq  0x2e6b33
  22:	48 89 d8             	mov    %rbx,%rax
  25:	48 c1 e8 03          	shr    $0x3,%rax
* 29:	80 3c 28 00          	cmpb   $0x0,(%rax,%rbp,1) <-- trapping instruction
  2d:	0f 85 4a 10 00 00    	jne    0x107d
  33:	4c 39 2b             	cmp    %r13,(%rbx)
  36:	0f 84 51 01 00 00    	je     0x18d
  3c:	e8                   	.byte 0xe8
  3d:	f2                   	repnz
  3e:	6a                   	.byte 0x6a


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
