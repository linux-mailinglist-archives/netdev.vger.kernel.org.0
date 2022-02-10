Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAD94B1538
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 19:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245700AbiBJS1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 13:27:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245696AbiBJS1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 13:27:20 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A384010EA
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 10:27:20 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id f9-20020a92cb49000000b002be1f9405a3so4503698ilq.16
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 10:27:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=XJrp8XRHtUqEZ5uIwF5BOMEX8ZNENnfFid/3F15vxro=;
        b=KK7125ut5ebPDKQgolVCizuUHJb5nEo2MFxIC8fc1l2Tv0s17aXv87q2sYCpCMNrwN
         tPBtlSjpXXQQIwiHluGnAwmTDhcCdoqsyQnQKSaAFLOa7kec8UYeYpiUn0CITQe11ow1
         oK2hh+sGana5tsyCti5r2Tz7YhV55etcFhcHCIYAgqEukkC5RVikVwe7EGmGFadNxCPN
         ywIK32dv0hhu5OqEL68adqGUApFLLl56nlJrExji4Oj0tECjbjeEd2wuhq/+P22kPBqA
         aQ6F2lNvKtMQF6DcCvsazAZPHYNA8xrK8hrfRn0KIzJ9D9hpbOrQGbc+kC7GWGm3Bivn
         /7Ew==
X-Gm-Message-State: AOAM533xxJG6ejSfBYQ5r0aDHfVS+ZiaivhJU+Ys1P91k7VWWpPc5tUC
        B91OpysczXqxkDSqU5I9feG+DMwJJrK+OHM07bhvtn4XaMg7
X-Google-Smtp-Source: ABdhPJz60QjhyuKytDQrbQzBtVy8FKUW8z1jUyET0H0lC19NsHegEaHgwbYDEwyFICmP2UDOogFHmqp63cZsrPwyfIxfKCV7hRo+
MIME-Version: 1.0
X-Received: by 2002:a05:6602:340a:: with SMTP id n10mr4426748ioz.76.1644517639875;
 Thu, 10 Feb 2022 10:27:19 -0800 (PST)
Date:   Thu, 10 Feb 2022 10:27:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c09b2a05d7ae19b8@google.com>
Subject: [syzbot] general protection fault in l2cap_chan_timeout (3)
From:   syzbot <syzbot+f0908ddc8b64b86e81f2@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    f4bc5bbb5fef Merge tag 'nfsd-5.17-2' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=172ce872700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=88e0a6a3dbf057cf
dashboard link: https://syzkaller.appspot.com/bug?extid=f0908ddc8b64b86e81f2
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1392aa3c700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16d514a4700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f0908ddc8b64b86e81f2@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc000000005a: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x00000000000002d0-0x00000000000002d7]
CPU: 1 PID: 5789 Comm: kworker/1:2 Not tainted 5.17.0-rc3-syzkaller-00043-gf4bc5bbb5fef #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events l2cap_chan_timeout
RIP: 0010:__mutex_lock_common+0x110/0x2490 kernel/locking/mutex.c:579
Code: 38 84 c0 0f 85 26 1c 00 00 83 3d 3a c6 aa 06 00 48 8b 5c 24 08 4c 8d ac 24 c0 00 00 00 75 21 48 8d 7b 60 48 89 f8 48 c1 e8 03 <42> 80 3c 38 00 74 05 e8 34 7e bc f7 48 39 5b 60 0f 85 b1 17 00 00
RSP: 0018:ffffc9000a4efaa0 EFLAGS: 00010206
RAX: 000000000000005a RBX: 0000000000000270 RCX: ffffffff90bf9803
RDX: dffffc0000000000 RSI: ffff888077be5700 RDI: 00000000000002d0
RBP: ffffc9000a4efc08 R08: dffffc0000000000 R09: ffffc9000a4efb60
R10: fffff5200149df71 R11: 0000000000000000 R12: 0000000000000000
R13: ffffc9000a4efb60 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000140 CR3: 0000000018ada000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __mutex_lock kernel/locking/mutex.c:733 [inline]
 mutex_lock_nested+0x1a/0x20 kernel/locking/mutex.c:785
 l2cap_chan_timeout+0x53/0x280 net/bluetooth/l2cap_core.c:422
 process_one_work+0x850/0x1130 kernel/workqueue.c:2307
 worker_thread+0xab1/0x1300 kernel/workqueue.c:2454
 kthread+0x2a3/0x2d0 kernel/kthread.c:377
 ret_from_fork+0x1f/0x30
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__mutex_lock_common+0x110/0x2490 kernel/locking/mutex.c:579
Code: 38 84 c0 0f 85 26 1c 00 00 83 3d 3a c6 aa 06 00 48 8b 5c 24 08 4c 8d ac 24 c0 00 00 00 75 21 48 8d 7b 60 48 89 f8 48 c1 e8 03 <42> 80 3c 38 00 74 05 e8 34 7e bc f7 48 39 5b 60 0f 85 b1 17 00 00
RSP: 0018:ffffc9000a4efaa0 EFLAGS: 00010206
RAX: 000000000000005a RBX: 0000000000000270 RCX: ffffffff90bf9803
RDX: dffffc0000000000 RSI: ffff888077be5700 RDI: 00000000000002d0
RBP: ffffc9000a4efc08 R08: dffffc0000000000 R09: ffffc9000a4efb60
R10: fffff5200149df71 R11: 0000000000000000 R12: 0000000000000000
R13: ffffc9000a4efb60 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fcd341ae06d CR3: 0000000018ada000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	38 84 c0 0f 85 26 1c 	cmp    %al,0x1c26850f(%rax,%rax,8)
   7:	00 00                	add    %al,(%rax)
   9:	83 3d 3a c6 aa 06 00 	cmpl   $0x0,0x6aac63a(%rip)        # 0x6aac64a
  10:	48 8b 5c 24 08       	mov    0x8(%rsp),%rbx
  15:	4c 8d ac 24 c0 00 00 	lea    0xc0(%rsp),%r13
  1c:	00
  1d:	75 21                	jne    0x40
  1f:	48 8d 7b 60          	lea    0x60(%rbx),%rdi
  23:	48 89 f8             	mov    %rdi,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1) <-- trapping instruction
  2f:	74 05                	je     0x36
  31:	e8 34 7e bc f7       	callq  0xf7bc7e6a
  36:	48 39 5b 60          	cmp    %rbx,0x60(%rbx)
  3a:	0f 85 b1 17 00 00    	jne    0x17f1


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
