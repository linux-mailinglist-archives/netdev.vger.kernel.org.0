Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F448679307
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 09:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232851AbjAXIZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 03:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjAXIZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 03:25:50 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321C06A4F
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 00:25:49 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id l13-20020a056e0212ed00b00304c6338d79so10042407iln.21
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 00:25:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6J8u+gk/dtYkB1YVU5kUpmNbgsJn5EMlBtfPcXh26Uw=;
        b=0ksDN8EpieG0Vdt1+J2u+5gSSkY4kv4a+IVVO47C18Pi8ggOR/Sjk5N2mCA1HsbNtT
         AmVCzVXTQXG/NS9aW1UCWrF61gD8gYk+/tQRvvi3BJ8dBNOZ6vFwqysUyMVulmesD986
         evejqvwkfWzBhZGAEMKYFM/UL0noYEiDMxn7PumG6ByIAdgU3B66I5HRNsbETG/0SxCv
         r/Iz8TKpO2uOtqrRUg+N+TEXFzaFXWp3YtJ67b0txSxbnOHIytGRaXnjDNwgopS7XWc0
         qk6ejXJMA2yPcYmKwKT9f4kLfAm+pCrSdVNad/nhj+0QfjxY/cd600KCzWjqv1S2EdWL
         XLXg==
X-Gm-Message-State: AFqh2kq+dhHoPT554hrqM7KytnneCKJTbjD1ctZiEd0nSMr0nMJiPFDD
        iPWPBHd4uYeClvKfMV5EJVgCRvk9P+dXOCwtl2j/exX0vYZs
X-Google-Smtp-Source: AMrXdXvw5gIDj6ynm8DBepEvt3jlwgfR+XKQQx6WaZAt+ZGipiOcKFC91fu0au4K5s+JvwlGNoocJcNz6mjjCDvEd/EP5YdBLEML
MIME-Version: 1.0
X-Received: by 2002:a05:6638:4090:b0:3a4:7dd6:2350 with SMTP id
 m16-20020a056638409000b003a47dd62350mr2591078jam.315.1674548748490; Tue, 24
 Jan 2023 00:25:48 -0800 (PST)
Date:   Tue, 24 Jan 2023 00:25:48 -0800
In-Reply-To: <00000000000062150b05f2fd210c@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000501e4505f2fe4344@google.com>
Subject: Re: [syzbot] general protection fault in pause_prepare_data
From:   syzbot <syzbot+9d44aae2720fc40b8474@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        vladimir.oltean@nxp.com
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

HEAD commit:    32e54254bab8 net: mdio: mux-meson-g12a: use devm_clk_get_e..
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=1553d205480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=21d2a04ab2961430
dashboard link: https://syzkaller.appspot.com/bug?extid=9d44aae2720fc40b8474
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15081f7a480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12458db6480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b82896cd05c2/disk-32e54254.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/77935ce88c7c/vmlinux-32e54254.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d3ebfede7cbd/bzImage-32e54254.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9d44aae2720fc40b8474@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000008: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000040-0x0000000000000047]
CPU: 0 PID: 5071 Comm: syz-executor396 Not tainted 6.2.0-rc4-syzkaller-00687-g32e54254bab8 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/12/2023
RIP: 0010:pause_prepare_data+0x60/0x400 net/ethtool/pause.c:59
Code: 0f b6 04 02 84 c0 74 08 3c 03 0f 8e 02 03 00 00 48 8d 7d 40 45 8b 6c 24 18 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 14 03 00 00 48 8b 45 40 48 89 da 48 c1 ea 03 48
RSP: 0018:ffffc90003c0f270 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888021b55c00 RCX: 0000000000000000
RDX: 0000000000000008 RSI: ffffffff880744d0 RDI: 0000000000000040
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff8e7326d7
R10: fffffbfff1ce64da R11: 0000000000000000 R12: ffff8880218e7d00
R13: 0000000000000000 R14: ffff88807de6c598 R15: ffffffff880744b0
FS:  000055555715c300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000006691e0 CR3: 000000007b781000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ethnl_default_dump_one net/ethtool/netlink.c:446 [inline]
 ethnl_default_dumpit+0x4a8/0xe80 net/ethtool/netlink.c:498
 netlink_dump+0x570/0xc50 net/netlink/af_netlink.c:2286
 __netlink_dump_start+0x64b/0x910 net/netlink/af_netlink.c:2391
 genl_family_rcv_msg_dumpit+0x2be/0x310 net/netlink/genetlink.c:929
 genl_family_rcv_msg net/netlink/genetlink.c:1045 [inline]
 genl_rcv_msg+0x419/0x7e0 net/netlink/genetlink.c:1065
 netlink_rcv_skb+0x165/0x440 net/netlink/af_netlink.c:2564
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1076
 netlink_unicast_kernel net/netlink/af_netlink.c:1330 [inline]
 netlink_unicast+0x547/0x7f0 net/netlink/af_netlink.c:1356
 netlink_sendmsg+0x91b/0xe10 net/netlink/af_netlink.c:1932
 sock_sendmsg_nosec net/socket.c:722 [inline]
 sock_sendmsg+0xde/0x190 net/socket.c:745
 ____sys_sendmsg+0x71c/0x900 net/socket.c:2501
 ___sys_sendmsg+0x110/0x1b0 net/socket.c:2555
 __sys_sendmsg+0xf7/0x1c0 net/socket.c:2584
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f620fd6c589
Code: 28 c3 e8 4a 15 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdab95a158 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ffdab95a168 RCX: 00007f620fd6c589
RDX: 0000000000000000 RSI: 0000000020000540 RDI: 0000000000000003
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffdab95a170
R13: 00007ffdab95a190 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:pause_prepare_data+0x60/0x400 net/ethtool/pause.c:59
Code: 0f b6 04 02 84 c0 74 08 3c 03 0f 8e 02 03 00 00 48 8d 7d 40 45 8b 6c 24 18 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f 85 14 03 00 00 48 8b 45 40 48 89 da 48 c1 ea 03 48
RSP: 0018:ffffc90003c0f270 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff888021b55c00 RCX: 0000000000000000
RDX: 0000000000000008 RSI: ffffffff880744d0 RDI: 0000000000000040
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffff8e7326d7
R10: fffffbfff1ce64da R11: 0000000000000000 R12: ffff8880218e7d00
R13: 0000000000000000 R14: ffff88807de6c598 R15: ffffffff880744b0
FS:  000055555715c300(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055e77403a658 CR3: 000000007b781000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax
   4:	84 c0                	test   %al,%al
   6:	74 08                	je     0x10
   8:	3c 03                	cmp    $0x3,%al
   a:	0f 8e 02 03 00 00    	jle    0x312
  10:	48 8d 7d 40          	lea    0x40(%rbp),%rdi
  14:	45 8b 6c 24 18       	mov    0x18(%r12),%r13d
  19:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  20:	fc ff df
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	0f 85 14 03 00 00    	jne    0x348
  34:	48 8b 45 40          	mov    0x40(%rbp),%rax
  38:	48 89 da             	mov    %rbx,%rdx
  3b:	48 c1 ea 03          	shr    $0x3,%rdx
  3f:	48                   	rex.W

