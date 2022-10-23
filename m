Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62C7E60959F
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 20:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiJWSce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 14:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbiJWScc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 14:32:32 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F098974347
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 11:32:30 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id j17-20020a5d93d1000000b006bcdc6b49cbso5357245ioo.22
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 11:32:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WApHQttljQxk0bCKPluvIjLV9y2zh4UDkWLc/0cRfdU=;
        b=n8B8nO46yCbRrQO7QpEIZAHM7VRmwNl8mUJbDMlOaDsf4MPF9nKdLe2vwiCY/1VJQ8
         WNywucTg1XR3ohSEgZ0XqjdfLQMrhcbi95E/rW/ZPgbg01wFpyJQEUwQuZ8jLMrA5iS8
         sm7gL2CAdSoTV67hlWuzIz260RsaELrg+ewQCbN9s8rf6TWD//znOAb3NZmTybw195KC
         gTBH6+21Pt6ZoKr1pmGdPE2a80yZqLfE7B6MzRkpgjML9XoAS4ISQapaj0lu4Yo9wbM+
         jsvU+i6F5y51/DYT8cNHN04MM1KbDi+MifrY1UDcYXP+ViLUf7Cs8Qie7o7WoEe3XR8A
         nuSA==
X-Gm-Message-State: ACrzQf3VXU59HZMbwDe/9lDjybi5KP56kf2f8FWAQN/ix/LAp/rSr9p4
        Z7zDxF0UA0Rj/IidrWH6RJN4hgNMopS1SPUq+Jsvr4/ns9ks
X-Google-Smtp-Source: AMsMyM43asT9SJH35Zsduhx5OvlUhqxqP6B6I8QDYaxj8iIZrgAbuE/Bly9uxzQ2s0YOXE4PtGXgr+Y8cUwBf46aLZmBpsDTPtdA
MIME-Version: 1.0
X-Received: by 2002:a92:c548:0:b0:2f9:fe3f:f4c2 with SMTP id
 a8-20020a92c548000000b002f9fe3ff4c2mr18773539ilj.180.1666549950258; Sun, 23
 Oct 2022 11:32:30 -0700 (PDT)
Date:   Sun, 23 Oct 2022 11:32:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c926f905ebb7e50a@google.com>
Subject: [syzbot] general protection fault in ieee80211_subif_start_xmit (2)
From:   syzbot <syzbot+c6e8fca81c294fd5620a@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
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

HEAD commit:    4d48f589d294 Add linux-next specific files for 20221021
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=11d36de2880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2c4b7d600a5739a6
dashboard link: https://syzkaller.appspot.com/bug?extid=c6e8fca81c294fd5620a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12a9544a880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1662d48c880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0c86bd0b39a0/disk-4d48f589.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/074059d37f1f/vmlinux-4d48f589.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c6e8fca81c294fd5620a@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc000000002f: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000178-0x000000000000017f]
CPU: 1 PID: 147 Comm: kworker/1:2 Not tainted 6.1.0-rc1-next-20221021-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/11/2022
Workqueue: mld mld_ifc_work
RIP: 0010:ieee80211_multicast_to_unicast net/mac80211/tx.c:4281 [inline]
RIP: 0010:ieee80211_subif_start_xmit+0x25b/0x1310 net/mac80211/tx.c:4409
Code: 80 3c 02 00 0f 85 94 10 00 00 49 8b 8c 24 28 19 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d b9 7c 01 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 68 10 00 00
RSP: 0000:ffffc90002d3f628 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: 000000000000002f RSI: ffffffff88dc6bf8 RDI: 000000000000017c
RBP: ffff88807b8cf140 R08: 0000000000000005 R09: 0000000000000004
R10: 0000000000000003 R11: 000000000008c001 R12: ffff8880200b4000
R13: ffff88807b8cf218 R14: ffff888020ea4042 R15: 1ffff920005a7ecf
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055b3e4199708 CR3: 000000007b8d0000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __netdev_start_xmit include/linux/netdevice.h:4840 [inline]
 netdev_start_xmit include/linux/netdevice.h:4854 [inline]
 xmit_one net/core/dev.c:3590 [inline]
 dev_hard_start_xmit+0x1be/0x990 net/core/dev.c:3606
 __dev_queue_xmit+0x2c9a/0x3b60 net/core/dev.c:4256
 dev_queue_xmit include/linux/netdevice.h:3008 [inline]
 neigh_resolve_output net/core/neighbour.c:1552 [inline]
 neigh_resolve_output+0x517/0x840 net/core/neighbour.c:1532
 neigh_output include/net/neighbour.h:546 [inline]
 ip6_finish_output2+0x564/0x1520 net/ipv6/ip6_output.c:134
 __ip6_finish_output net/ipv6/ip6_output.c:195 [inline]
 ip6_finish_output+0x690/0x1160 net/ipv6/ip6_output.c:206
 NF_HOOK_COND include/linux/netfilter.h:291 [inline]
 ip6_output+0x1ed/0x540 net/ipv6/ip6_output.c:227
 dst_output include/net/dst.h:445 [inline]
 NF_HOOK include/linux/netfilter.h:302 [inline]
 NF_HOOK include/linux/netfilter.h:296 [inline]
 mld_sendpack+0xa09/0xe70 net/ipv6/mcast.c:1820
 mld_send_cr net/ipv6/mcast.c:2121 [inline]
 mld_ifc_work+0x71c/0xdb0 net/ipv6/mcast.c:2653
 process_one_work+0x9bf/0x1710 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e4/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ieee80211_multicast_to_unicast net/mac80211/tx.c:4281 [inline]
RIP: 0010:ieee80211_subif_start_xmit+0x25b/0x1310 net/mac80211/tx.c:4409
Code: 80 3c 02 00 0f 85 94 10 00 00 49 8b 8c 24 28 19 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d b9 7c 01 00 00 48 89 fa 48 c1 ea 03 <0f> b6 04 02 48 89 fa 83 e2 07 38 d0 7f 08 84 c0 0f 85 68 10 00 00
RSP: 0000:ffffc90002d3f628 EFLAGS: 00010203
RAX: dffffc0000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: 000000000000002f RSI: ffffffff88dc6bf8 RDI: 000000000000017c
RBP: ffff88807b8cf140 R08: 0000000000000005 R09: 0000000000000004
R10: 0000000000000003 R11: 000000000008c001 R12: ffff8880200b4000
R13: ffff88807b8cf218 R14: ffff888020ea4042 R15: 1ffff920005a7ecf
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055b3e4199708 CR3: 000000000ba8e000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   4:	0f 85 94 10 00 00    	jne    0x109e
   a:	49 8b 8c 24 28 19 00 	mov    0x1928(%r12),%rcx
  11:	00
  12:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
  19:	fc ff df
  1c:	48 8d b9 7c 01 00 00 	lea    0x17c(%rcx),%rdi
  23:	48 89 fa             	mov    %rdi,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	0f b6 04 02          	movzbl (%rdx,%rax,1),%eax <-- trapping instruction
  2e:	48 89 fa             	mov    %rdi,%rdx
  31:	83 e2 07             	and    $0x7,%edx
  34:	38 d0                	cmp    %dl,%al
  36:	7f 08                	jg     0x40
  38:	84 c0                	test   %al,%al
  3a:	0f 85 68 10 00 00    	jne    0x10a8


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
