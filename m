Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0B14326F1
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 20:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbhJRS6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 14:58:37 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:44717 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232841AbhJRS6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 14:58:36 -0400
Received: by mail-il1-f197.google.com with SMTP id i11-20020a92540b000000b0025456903645so8607661ilb.11
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 11:56:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=qrfb55jZpNwVAqJrVbLH1XCEOAgnpcHdVrtGXnqAP20=;
        b=W5u2ZpLrTFvZemGZJHLb57D0rk6a1BVeqWCtGEVhymYOEJH9ewXN1tqzwZ+0LN65FH
         cYl0HTn6dztWNfSJLQYNs0lhGHnzGpjt0PZ9gQ9mTkfM0IfFpuKZ79RTHWoacgYs8FSe
         E6TWtqPcIBkGoU/e7iKEdoF+XAuinujUlEdQoi8vxHro4yLWHZyaoFqCyZZMJpt0H10i
         8oCrJQgDgBm4bertU6eQPsn9SaFbi+KK5IywiIs/PSn5JwAQuXczecuBz84OW6K7Bsos
         nKCSVT0Zz8jWLo6uTSNn7FcPivVwpsjGZP668tyDqH51a7vYF0dPziabW4NBB/kS+1j4
         e81Q==
X-Gm-Message-State: AOAM533hLXSp9LKwGnszvwc5J+XK5/sgcVqvmmgz845FTNx7yGtvufdr
        xy4QrCHc8mfOGDTtYp5XtW7OfdaJ+1D1iLIJ1mCp0HrqSOkf
X-Google-Smtp-Source: ABdhPJz72nBghGjLut9waCZkNKD4/yd8i4XkP3TKRiLBsPdj890qMfwAgKdV6HQx4TqEH+t1LRkeYI5J7411P66ZLngomq4cbb9l
MIME-Version: 1.0
X-Received: by 2002:a05:6638:ac6:: with SMTP id m6mr1115607jab.28.1634583383840;
 Mon, 18 Oct 2021 11:56:23 -0700 (PDT)
Date:   Mon, 18 Oct 2021 11:56:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f3259005cea5199e@google.com>
Subject: [syzbot] divide error in mac80211_hwsim_bss_info_changed (2)
From:   syzbot <syzbot+5f110beab9fb01e48be5@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fac3cb82a54a net: bridge: mcast: use multicast_membership_..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=144efe78b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bab9d35f204746a7
dashboard link: https://syzkaller.appspot.com/bug?extid=5f110beab9fb01e48be5
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5f110beab9fb01e48be5@syzkaller.appspotmail.com

divide error: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 1140 Comm: kworker/u4:4 Not tainted 5.15.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy9 ieee80211_roc_work
RIP: 0010:mac80211_hwsim_bss_info_changed+0xd37/0xf10 drivers/net/wireless/mac80211_hwsim.c:2033
Code: 48 ba 00 00 00 00 00 fc ff df 48 c1 e9 03 80 3c 11 00 0f 85 96 01 00 00 49 8b b6 a0 3c 00 00 49 8d be 40 3d 00 00 31 d2 89 f1 <48> f7 f1 29 d6 b9 05 00 00 00 31 d2 48 69 f6 e8 03 00 00 e8 d1 1f
RSP: 0018:ffffc9000550fb70 EFLAGS: 00010246
RAX: 0005ce87f3fb02a5 RBX: 0000000000000200 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88807783efe0
RBP: ffff88801af8e088 R08: 000000000000f8c6 R09: ffffffff8fcffa47
R10: ffffffff8167242f R11: 0000000000000000 R12: ffff888077838d60
R13: ffff88807783ef40 R14: ffff88807783b2a0 R15: ffff88807783b2a0
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffee3e2afcc CR3: 000000004efc2000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 drv_bss_info_changed+0x2c6/0x5f0 net/mac80211/driver-ops.h:177
 ieee80211_bss_info_change_notify+0x9a/0xc0 net/mac80211/main.c:210
 ieee80211_offchannel_return+0x330/0x4a0 net/mac80211/offchannel.c:158
 __ieee80211_roc_work+0x35a/0x3d0 net/mac80211/offchannel.c:444
 ieee80211_roc_work+0x2b/0x40 net/mac80211/offchannel.c:458
 process_one_work+0x9bf/0x16b0 kernel/workqueue.c:2297
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2444
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
Modules linked in:
---[ end trace ff9a982d4a81be98 ]---
RIP: 0010:mac80211_hwsim_bss_info_changed+0xd37/0xf10 drivers/net/wireless/mac80211_hwsim.c:2033
Code: 48 ba 00 00 00 00 00 fc ff df 48 c1 e9 03 80 3c 11 00 0f 85 96 01 00 00 49 8b b6 a0 3c 00 00 49 8d be 40 3d 00 00 31 d2 89 f1 <48> f7 f1 29 d6 b9 05 00 00 00 31 d2 48 69 f6 e8 03 00 00 e8 d1 1f
RSP: 0018:ffffc9000550fb70 EFLAGS: 00010246
RAX: 0005ce87f3fb02a5 RBX: 0000000000000200 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88807783efe0
RBP: ffff88801af8e088 R08: 000000000000f8c6 R09: ffffffff8fcffa47
R10: ffffffff8167242f R11: 0000000000000000 R12: ffff888077838d60
R13: ffff88807783ef40 R14: ffff88807783b2a0 R15: ffff88807783b2a0
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1b6573a218 CR3: 00000000271f2000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	48 ba 00 00 00 00 00 	movabs $0xdffffc0000000000,%rdx
   7:	fc ff df
   a:	48 c1 e9 03          	shr    $0x3,%rcx
   e:	80 3c 11 00          	cmpb   $0x0,(%rcx,%rdx,1)
  12:	0f 85 96 01 00 00    	jne    0x1ae
  18:	49 8b b6 a0 3c 00 00 	mov    0x3ca0(%r14),%rsi
  1f:	49 8d be 40 3d 00 00 	lea    0x3d40(%r14),%rdi
  26:	31 d2                	xor    %edx,%edx
  28:	89 f1                	mov    %esi,%ecx
* 2a:	48 f7 f1             	div    %rcx <-- trapping instruction
  2d:	29 d6                	sub    %edx,%esi
  2f:	b9 05 00 00 00       	mov    $0x5,%ecx
  34:	31 d2                	xor    %edx,%edx
  36:	48 69 f6 e8 03 00 00 	imul   $0x3e8,%rsi,%rsi
  3d:	e8                   	.byte 0xe8
  3e:	d1 1f                	rcrl   (%rdi)


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
