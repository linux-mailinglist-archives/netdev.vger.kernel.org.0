Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147DC4ED104
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 02:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351584AbiCaAuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 20:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352131AbiCaAuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 20:50:09 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB03063FF
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 17:48:21 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id i1-20020a056e021d0100b002c9e4da67easo2190068ila.1
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 17:48:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=gi3ojXdxy2ba1RP724OiUC9jw2tdOrjJ64eJr4rNY58=;
        b=ESgYDMEsI3jKYxw+mlJLpYfkHvQuqM96Dx2eYacam47XuU+bT4rswM6CffHHCMuQUm
         mXNarfL+TDbde5eNNeDp73XvQbDKIXlATYKBRfx2kjchVE+JJAM3/GsxIdTuLTuzuyv/
         z0/xwUqJohCscyzDE3aIupStZ1d/v5y984h2ceLnulRQmSl/VCBmqFmZxY66VwpuzCbE
         Y0Gh6DSFbmBG/n6IyPeWeSWopiAEcvqM6yXa1+9D7zeS/lizzc7oStve6ZlLITvebKgq
         88MfDTUgRRdDHvTpu1WLUJSwQzcA/Cv0iKIfIhOGddAfhji0295/GJHEh6g6Yk7fVv94
         nzCw==
X-Gm-Message-State: AOAM530rXALm7nxvASEXwhKX4Zj29GUJ7oTJi/PBw1u1h8VF9VT22OI1
        IA9il8P+W4Hzqpxw+IFGQ5PudZvKyUNoXDTAfur/bYmEQcE6
X-Google-Smtp-Source: ABdhPJyo1z9QbmFpOh7c/nNAP8fN1yh2OSdjrJoue3CcLv++9vlmUpsd+XtHEfnFbeUl2CzR0YHEDbpsju6LPpjpiW9tH1z73NHr
MIME-Version: 1.0
X-Received: by 2002:a5d:8486:0:b0:64c:6c6b:4660 with SMTP id
 t6-20020a5d8486000000b0064c6c6b4660mr10712482iom.21.1648687701162; Wed, 30
 Mar 2022 17:48:21 -0700 (PDT)
Date:   Wed, 30 Mar 2022 17:48:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c6056605db790400@google.com>
Subject: [syzbot] general protection fault in smc_pnet_add (2)
From:   syzbot <syzbot+03e3e228510223dabd34@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kgraul@linux.ibm.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
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

HEAD commit:    d82a6c5ef9dc net: prestera: acl: make read-only array clie..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13862081700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cce8a73d5200f3c0
dashboard link: https://syzkaller.appspot.com/bug?extid=03e3e228510223dabd34
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=167da879700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12bb0fe1700000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11116ca1700000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=13116ca1700000
console output: https://syzkaller.appspot.com/x/log.txt?x=15116ca1700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+03e3e228510223dabd34@syzkaller.appspotmail.com

infiniband syz: set active
infiniband syz: added veth0_vlan
RDS/IB: syz: added
smc: adding ib device syz with port count 1
smc:    ib device syz port 1 has pnetid 
general protection fault, probably for non-canonical address 0xdffffc000000000a: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000050-0x0000000000000057]
CPU: 1 PID: 3592 Comm: syz-executor235 Not tainted 5.17.0-rc6-syzkaller-01979-gd82a6c5ef9dc #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:dev_name include/linux/device.h:636 [inline]
RIP: 0010:smc_pnet_find_ib net/smc/smc_pnet.c:314 [inline]
RIP: 0010:smc_pnet_add_ib net/smc/smc_pnet.c:416 [inline]
RIP: 0010:smc_pnet_enter net/smc/smc_pnet.c:515 [inline]
RIP: 0010:smc_pnet_add+0xc4b/0x17a0 net/smc/smc_pnet.c:558
Code: 8d be 58 07 00 00 48 89 f8 48 c1 e8 03 80 3c 28 00 0f 85 40 09 00 00 4d 8b a6 58 07 00 00 49 8d 7c 24 50 48 89 f8 48 c1 e8 03 <80> 3c 28 00 0f 85 19 09 00 00 4d 8b 74 24 50 4d 85 f6 0f 85 21 ff
RSP: 0018:ffffc9000399f540 EFLAGS: 00010206
RAX: 000000000000000a RBX: ffff888076902800 RCX: 0000000000000000
RDX: ffff8880226f0000 RSI: ffffffff88cadba0 RDI: 0000000000000050
RBP: dffffc0000000000 R08: 0000000000000000 R09: ffffc9000399f47f
R10: ffffffff88cadb92 R11: 1ffffffff1eb5307 R12: 0000000000000000
R13: ffff88807066cc18 R14: ffff88801abc4000 R15: ffff888076902810
FS:  0000555555e61300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056492c9e2ff8 CR3: 0000000018900000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:731
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2494
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1317 [inline]
 netlink_unicast+0x539/0x7e0 net/netlink/af_netlink.c:1343
 netlink_sendmsg+0x904/0xe00 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:705 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:725
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2413
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2467
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2496
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f02fa3ae5d9
Code: 28 c3 e8 7a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd0d649788 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007f02fa3ae5d9
RDX: 0000000000000000 RSI: 0000000020000280 RDI: 0000000000000005
RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000555555e612c0
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:dev_name include/linux/device.h:636 [inline]
RIP: 0010:smc_pnet_find_ib net/smc/smc_pnet.c:314 [inline]
RIP: 0010:smc_pnet_add_ib net/smc/smc_pnet.c:416 [inline]
RIP: 0010:smc_pnet_enter net/smc/smc_pnet.c:515 [inline]
RIP: 0010:smc_pnet_add+0xc4b/0x17a0 net/smc/smc_pnet.c:558
Code: 8d be 58 07 00 00 48 89 f8 48 c1 e8 03 80 3c 28 00 0f 85 40 09 00 00 4d 8b a6 58 07 00 00 49 8d 7c 24 50 48 89 f8 48 c1 e8 03 <80> 3c 28 00 0f 85 19 09 00 00 4d 8b 74 24 50 4d 85 f6 0f 85 21 ff
RSP: 0018:ffffc9000399f540 EFLAGS: 00010206
RAX: 000000000000000a RBX: ffff888076902800 RCX: 0000000000000000
RDX: ffff8880226f0000 RSI: ffffffff88cadba0 RDI: 0000000000000050
RBP: dffffc0000000000 R08: 0000000000000000 R09: ffffc9000399f47f
R10: ffffffff88cadb92 R11: 1ffffffff1eb5307 R12: 0000000000000000
R13: ffff88807066cc18 R14: ffff88801abc4000 R15: ffff888076902810
FS:  0000555555e61300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056492c9f13a8 CR3: 0000000018900000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	8d be 58 07 00 00    	lea    0x758(%rsi),%edi
   6:	48 89 f8             	mov    %rdi,%rax
   9:	48 c1 e8 03          	shr    $0x3,%rax
   d:	80 3c 28 00          	cmpb   $0x0,(%rax,%rbp,1)
  11:	0f 85 40 09 00 00    	jne    0x957
  17:	4d 8b a6 58 07 00 00 	mov    0x758(%r14),%r12
  1e:	49 8d 7c 24 50       	lea    0x50(%r12),%rdi
  23:	48 89 f8             	mov    %rdi,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	80 3c 28 00          	cmpb   $0x0,(%rax,%rbp,1) <-- trapping instruction
  2e:	0f 85 19 09 00 00    	jne    0x94d
  34:	4d 8b 74 24 50       	mov    0x50(%r12),%r14
  39:	4d 85 f6             	test   %r14,%r14
  3c:	0f                   	.byte 0xf
  3d:	85 21                	test   %esp,(%rcx)
  3f:	ff                   	.byte 0xff


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
