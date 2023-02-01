Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A494C68634E
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 11:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbjBAKEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 05:04:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbjBAKEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 05:04:44 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764624F86D
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 02:04:42 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id d24-20020a5d9bd8000000b006ee2ddf6d77so9932778ion.6
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 02:04:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fdqRayzcVj9GrkW60ip7rWWzNJPEBAcTfyxei4Frw3A=;
        b=w380tf+/P/TUOfnmsZ3ZDuOFXr1tXzg10+Ov/ETayUU1GFAvJ2r+Owf7fF33yg/VTo
         HpK/cuaR2iicgLCwstMF9DzuNH40mK+zlHYZGNve/rmafRbKLIWnFYIPwpvhrzH7TQ9w
         eUGWw61F8GPu2rF5o9+HA6m2lENFy9yqgLJZ0KYcu7FE7Ow/1BzgqiYmcH2oT/EyS7SK
         9s4gagHCinNzOTmNK/b83PXuHzRwa15lkaqWJEiCn+5gJ4DD2AC2rZOAwXIbYytn2y23
         3AbM2MHZ1/0hElxQ6M3yg2EboaaCTgPHb6Emq9pWOTvEF90oVRT4P7D00KP1rLL/hLVl
         yRCQ==
X-Gm-Message-State: AO0yUKUAWEpcoXY2g2ROLpmd2nwmYV3pWjLlLFZzV+c4jvsgpJT+CfAs
        4nKicAbcep5azMeRV5AkDbYWmKW8VTqP0wG/OpPEQFCH87h9
X-Google-Smtp-Source: AK7set+iGZdE8Z66crosqd0dDD/u7PJnBZBxvdE1MOGJlkW2zc1fLH/sSfcsoO1pptIrpje217WpUm6IyflvaDzSuB6som8wiwFm
MIME-Version: 1.0
X-Received: by 2002:a02:cbcc:0:b0:3ad:800c:6c7a with SMTP id
 u12-20020a02cbcc000000b003ad800c6c7amr377776jaq.9.1675245881698; Wed, 01 Feb
 2023 02:04:41 -0800 (PST)
Date:   Wed, 01 Feb 2023 02:04:41 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b0b3c005f3a09383@google.com>
Subject: [syzbot] general protection fault in skb_dequeue (3)
From:   syzbot <syzbot+a440341a59e3b7142895@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        hch@lst.de, jhubbard@nvidia.com, johannes@sipsolutions.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
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

HEAD commit:    80bd9028feca Add linux-next specific files for 20230131
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1468e369480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=904dc2f450eaad4a
dashboard link: https://syzkaller.appspot.com/bug?extid=a440341a59e3b7142895
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12c5d2be480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11259a79480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/924618188238/disk-80bd9028.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7a03cf86e545/vmlinux-80bd9028.xz
kernel image: https://storage.googleapis.com/syzbot-assets/568e80043a41/bzImage-80bd9028.xz

The issue was bisected to:

commit 920756a3306a35f1c08f25207d375885bef98975
Author: David Howells <dhowells@redhat.com>
Date:   Sat Jan 21 12:51:18 2023 +0000

    block: Convert bio_iov_iter_get_pages to use iov_iter_extract_pages

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=170384f9480000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=148384f9480000
console output: https://syzkaller.appspot.com/x/log.txt?x=108384f9480000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a440341a59e3b7142895@syzkaller.appspotmail.com
Fixes: 920756a3306a ("block: Convert bio_iov_iter_get_pages to use iov_iter_extract_pages")

general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 PID: 2838 Comm: kworker/u4:6 Not tainted 6.2.0-rc6-next-20230131-syzkaller-09515-g80bd9028feca #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/12/2023
Workqueue: phy4 ieee80211_iface_work
RIP: 0010:__skb_unlink include/linux/skbuff.h:2321 [inline]
RIP: 0010:__skb_dequeue include/linux/skbuff.h:2337 [inline]
RIP: 0010:skb_dequeue+0xf5/0x180 net/core/skbuff.c:3511
Code: 8d 7e 08 49 8b 5c 24 08 48 b8 00 00 00 00 00 fc ff df 49 c7 44 24 08 00 00 00 00 48 89 fa 49 c7 04 24 00 00 00 00 48 c1 ea 03 <80> 3c 02 00 75 6d 48 89 da 49 89 5e 08 48 b8 00 00 00 00 00 fc ff
RSP: 0018:ffffc9000ca2fc80 EFLAGS: 00010002
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff8808951d RDI: 0000000000000008
RBP: 0000000000000293 R08: 0000000000000001 R09: 0000000000000003
R10: fffff52001945f7e R11: 0000000000000000 R12: ffff88801d8f63c0
R13: ffff888075675880 R14: 0000000000000000 R15: ffff888075675868
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4a51f6d150 CR3: 0000000072a78000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ieee80211_iface_work+0x369/0xd70 net/mac80211/iface.c:1631
 process_one_work+0x9bf/0x1820 kernel/workqueue.c:2390
 worker_thread+0x669/0x1090 kernel/workqueue.c:2537
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__skb_unlink include/linux/skbuff.h:2321 [inline]
RIP: 0010:__skb_dequeue include/linux/skbuff.h:2337 [inline]
RIP: 0010:skb_dequeue+0xf5/0x180 net/core/skbuff.c:3511
Code: 8d 7e 08 49 8b 5c 24 08 48 b8 00 00 00 00 00 fc ff df 49 c7 44 24 08 00 00 00 00 48 89 fa 49 c7 04 24 00 00 00 00 48 c1 ea 03 <80> 3c 02 00 75 6d 48 89 da 49 89 5e 08 48 b8 00 00 00 00 00 fc ff
RSP: 0018:ffffc9000ca2fc80 EFLAGS: 00010002
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff8808951d RDI: 0000000000000008
RBP: 0000000000000293 R08: 0000000000000001 R09: 0000000000000003
R10: fffff52001945f7e R11: 0000000000000000 R12: ffff88801d8f63c0
R13: ffff888075675880 R14: 0000000000000000 R15: ffff888075675868
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4a51f6d150 CR3: 0000000072a78000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	8d 7e 08             	lea    0x8(%rsi),%edi
   3:	49 8b 5c 24 08       	mov    0x8(%r12),%rbx
   8:	48 b8 00 00 00 00 00 	movabs $0xdffffc0000000000,%rax
   f:	fc ff df
  12:	49 c7 44 24 08 00 00 	movq   $0x0,0x8(%r12)
  19:	00 00
  1b:	48 89 fa             	mov    %rdi,%rdx
  1e:	49 c7 04 24 00 00 00 	movq   $0x0,(%r12)
  25:	00
  26:	48 c1 ea 03          	shr    $0x3,%rdx
* 2a:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1) <-- trapping instruction
  2e:	75 6d                	jne    0x9d
  30:	48 89 da             	mov    %rbx,%rdx
  33:	49 89 5e 08          	mov    %rbx,0x8(%r14)
  37:	48                   	rex.W
  38:	b8 00 00 00 00       	mov    $0x0,%eax
  3d:	00 fc                	add    %bh,%ah
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
