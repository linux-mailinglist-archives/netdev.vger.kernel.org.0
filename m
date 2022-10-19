Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68A36043DB
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 13:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbiJSLvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 07:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbiJSLuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 07:50:54 -0400
Received: from mail-il1-x148.google.com (mail-il1-x148.google.com [IPv6:2607:f8b0:4864:20::148])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C6142E74
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 04:29:17 -0700 (PDT)
Received: by mail-il1-x148.google.com with SMTP id j29-20020a056e02219d00b002f9b13c40c5so16111809ila.21
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 04:29:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rlPxNuuYrpPZWnslaVb+CMvOIVvWoGav/3pchzdetwY=;
        b=c1jtYImW6TeFf2vn2++rix0bi7ylEGHlDN2nTGkDeSYsr0sSJdFNCzwvW7GaO212DM
         LFIk2uAY6epoKyueBMviIFsjCL0iQ23Afyh0qFewrTPzR0hxg9fEkVy7wijQ3osjLKO8
         364kQUnFS0vsG+HuliVmB14iA9Wj1Nh/OxLFWndEW6QrKRJpq/8uSNWZJl+j34t2eb+o
         D3R32yMaNF6wOMNlpM1GuubwGwkCxFE9/EXMBBEg/jDdNaPuPWJLs3WkRD6X503Pvyuw
         Cnk9Y1SuEPv8JsEBy2jHfjFjD+j77Ek29ja1s6COZaAbZfDEShWmMIxJOe/nYrX7OxQE
         4fcw==
X-Gm-Message-State: ACrzQf2iNSL0PkcUcC8G0LftQI1lNwR2L+8MQdwdvhWLkYqkeaHha5Wt
        QJFO3QewLLyY0N2KPMyG/cxGIzpFfyMKYqo51qlL90fmzv3t
X-Google-Smtp-Source: AMsMyM48v5ESSXiOHn4pTAgns/tV8/e2jlh8+xvkSAmEpwbo21H7WT2Ua58BN9mAiJKRim5Z4dIz7RUSGN8GOXGTvldRSr8H0dYh
MIME-Version: 1.0
X-Received: by 2002:a02:7409:0:b0:363:bb5c:2d7 with SMTP id
 o9-20020a027409000000b00363bb5c02d7mr6064260jac.260.1666178795965; Wed, 19
 Oct 2022 04:26:35 -0700 (PDT)
Date:   Wed, 19 Oct 2022 04:26:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000044139d05eb617b1c@google.com>
Subject: [syzbot] general protection fault in pse_prepare_data
From:   syzbot <syzbot+81c4b4bbba6eea2cfcae@syzkaller.appspotmail.com>
To:     andrew@lunn.ch, bagasdotme@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux@rempel-privat.de, lkp@intel.com, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    55be6084c8e0 Merge tag 'timers-core-2022-10-05' of git://g..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=140d5a2c880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=df75278aabf0681a
dashboard link: https://syzkaller.appspot.com/bug?extid=81c4b4bbba6eea2cfcae
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13470244880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=146e88b4880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9d967e5d91fa/disk-55be6084.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9a8cffcbc089/vmlinux-55be6084.xz

Bisection is inconclusive: the first bad commit could be any of:

331834898f2b Merge branch 'add-generic-pse-support'
66741b4e94ca net: pse-pd: add regulator based PSE driver
2a4187f4406e once: rename _SLOW to _SLEEPABLE
f05dfdaf567a dt-bindings: net: pse-dt: add bindings for regulator based PoDL PSE controller
18ff0bcda6d1 ethtool: add interface to interact with Ethernet Power Equipment
e52f7c1ddf3e Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
681bf011b9b5 eth: pse: add missing static inlines

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=11fc42b4880000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+81c4b4bbba6eea2cfcae@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000008: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000040-0x0000000000000047]
CPU: 1 PID: 3609 Comm: syz-executor227 Not tainted 6.0.0-syzkaller-09589-g55be6084c8e0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
RIP: 0010:pse_prepare_data+0x66/0x1e0 net/ethtool/pse-pd.c:67
Code: 89 c6 e8 dd f4 e0 f9 45 85 e4 0f 88 b3 00 00 00 e8 0f f8 e0 f9 48 8d 7d 40 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 36 01 00 00 49 8d bd 98 0b 00 00 4c 8b 65 40 48
RSP: 0018:ffffc90003cff398 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888020324600 RCX: 0000000000000000
RDX: 0000000000000008 RSI: ffffffff879a5231 RDI: 0000000000000040
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8880788f2000 R14: ffff8880712e0598 R15: ffffffff879a51e0
FS:  000055555594f300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000080 CR3: 0000000025df8000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ethnl_default_dump_one net/ethtool/netlink.c:442 [inline]
 ethnl_default_dumpit+0x4a4/0xe80 net/ethtool/netlink.c:494
 netlink_dump+0x541/0xc20 net/netlink/af_netlink.c:2275
 __netlink_dump_start+0x647/0x900 net/netlink/af_netlink.c:2380
 genl_family_rcv_msg_dumpit+0x1c9/0x310 net/netlink/genetlink.c:689
 genl_family_rcv_msg net/netlink/genetlink.c:805 [inline]
 genl_rcv_msg+0x55d/0x780 net/netlink/genetlink.c:825
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2540
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:836
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x543/0x7f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x917/0xe10 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:734
 ____sys_sendmsg+0x712/0x8c0 net/socket.c:2482
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2536
 __sys_sendmsg+0xf3/0x1c0 net/socket.c:2565
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f626f3dd579
Code: 28 c3 e8 4a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffddc5fcbc8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ffddc5fcbd8 RCX: 00007f626f3dd579
RDX: 0000000000000000 RSI: 0000000020000240 RDI: 0000000000000003
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffddc5fcbe0
R13: 00007ffddc5fcc00 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:pse_prepare_data+0x66/0x1e0 net/ethtool/pse-pd.c:67
Code: 89 c6 e8 dd f4 e0 f9 45 85 e4 0f 88 b3 00 00 00 e8 0f f8 e0 f9 48 8d 7d 40 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 36 01 00 00 49 8d bd 98 0b 00 00 4c 8b 65 40 48
RSP: 0018:ffffc90003cff398 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888020324600 RCX: 0000000000000000
RDX: 0000000000000008 RSI: ffffffff879a5231 RDI: 0000000000000040
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8880788f2000 R14: ffff8880712e0598 R15: ffffffff879a51e0
FS:  000055555594f300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000080 CR3: 0000000025df8000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	89 c6                	mov    %eax,%esi
   2:	e8 dd f4 e0 f9       	callq  0xf9e0f4e4
   7:	45 85 e4             	test   %r12d,%r12d
   a:	0f 88 b3 00 00 00    	js     0xc3
  10:	e8 0f f8 e0 f9       	callq  0xf9e0f824
  15:	48 8d 7d 40          	lea    0x40(%rbp),%rdi
  19:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  20:	fc ff df
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	0f 85 36 01 00 00    	jne    0x16a
  34:	49 8d bd 98 0b 00 00 	lea    0xb98(%r13),%rdi
  3b:	4c 8b 65 40          	mov    0x40(%rbp),%r12
  3f:	48                   	rex.W


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
