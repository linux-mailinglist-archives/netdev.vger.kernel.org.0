Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80A2889B3D
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 12:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbfHLKUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 06:20:07 -0400
Received: from mail-ot1-f71.google.com ([209.85.210.71]:55856 "EHLO
        mail-ot1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727409AbfHLKUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 06:20:07 -0400
Received: by mail-ot1-f71.google.com with SMTP id p7so83510498otk.22
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 03:20:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=F+sCkwDa9f+RxfruDpYk266w8j1SjIK4Xb0PYHWArdY=;
        b=Zn3w+1Gk1BkjPrUIxVXgymCqpi2sldlbugDQVWTorHPvvSuJPLjG5FGlCqgSBLMumh
         i/d4ExqWKUDDxq9p22S4qu9mLF8I2INnUuwpdczimYwy+ulh4JNGzggFfh85NpFpTTFD
         hEdfzjrd8LE1erYByMNbRfUOwWGBCDuRfVSGmyST9u1KHjFMnYmnU14zje5ApEGMP1ee
         B3Uvj3aZmxZXiTWEtUgh6ebGyUA2eVOOkvoszLaPWdK9J5mHY5aFAWDoV6CNad2mzGHz
         iZbyflEAi23izyPE+Zu4rpj4N27G9knYmMWcaCdGhhgHyxXxIB+EoFDKQpXPZFuLklSH
         SWWw==
X-Gm-Message-State: APjAAAX1Ulsb2ZDcCLiAW+eV/zZkjohBeToE9e9RbDeudAokqPUJ7iYN
        EsCrdDpEp4A1lElifmsDHxPmcuUlYdkJZS6/sGPtp3nw4fv8
X-Google-Smtp-Source: APXvYqylZCr71afqbkmSSEoG0bXp+Wqna6q1KYeqMuVdotyvmT64jqS7CvFtW+Sb2KKJRXvbqprM29x92pCgtQB9t92MfbiYnkEv
MIME-Version: 1.0
X-Received: by 2002:a5d:8f8a:: with SMTP id l10mr8658161iol.306.1565605206234;
 Mon, 12 Aug 2019 03:20:06 -0700 (PDT)
Date:   Mon, 12 Aug 2019 03:20:06 -0700
In-Reply-To: <000000000000492086058fad2979@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002d1bcc058fe8deb8@google.com>
Subject: Re: BUG: corrupted list in rxrpc_local_processor
From:   syzbot <syzbot+193e29e9387ea5837f1d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    125b7e09 net: tc35815: Explicitly check NET_IP_ALIGN is no..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=16fb7bc2600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4c9e9f08e9e8960
dashboard link: https://syzkaller.appspot.com/bug?extid=193e29e9387ea5837f1d
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=159d4eba600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16ba194a600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+193e29e9387ea5837f1d@syzkaller.appspotmail.com

IPv6: ADDRCONF(NETDEV_CHANGE): hsr_slave_1: link becomes ready
list_del corruption. prev->next should be ffff8880996e84e0, but was  
ffff8880996e8960
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:51!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 17 Comm: kworker/1:0 Not tainted 5.3.0-rc3+ #159
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: krxrpcd rxrpc_local_processor
RIP: 0010:__list_del_entry_valid.cold+0xf/0x4f lib/list_debug.c:51
Code: e8 e9 03 1e fe 0f 0b 48 89 f1 48 c7 c7 80 25 c6 87 4c 89 e6 e8 d5 03  
1e fe 0f 0b 4c 89 f6 48 c7 c7 20 27 c6 87 e8 c4 03 1e fe <0f> 0b 4c 89 ea  
4c 89 f6 48 c7 c7 60 26 c6 87 e8 b0 03 1e fe 0f 0b
RSP: 0018:ffff8880a9917cc0 EFLAGS: 00010286
RAX: 0000000000000054 RBX: ffff8880996e84f8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815c3b96 RDI: ffffed1015322f8a
RBP: ffff8880a9917cd8 R08: 0000000000000054 R09: ffffed1015d260d1
R10: ffffed1015d260d0 R11: ffff8880ae930687 R12: ffff88808f998638
R13: ffff88808f998638 R14: ffff8880996e84e0 R15: ffff8880aa0a8500
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2648a08db8 CR3: 00000000981a9000 CR4: 00000000001406e0
Call Trace:
  __list_del_entry include/linux/list.h:131 [inline]
  list_del_init include/linux/list.h:190 [inline]
  rxrpc_local_destroyer net/rxrpc/local_object.c:429 [inline]
  rxrpc_local_processor+0x251/0x830 net/rxrpc/local_object.c:465
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace 4d70382ddfcfe2b8 ]---
RIP: 0010:__list_del_entry_valid.cold+0xf/0x4f lib/list_debug.c:51
Code: e8 e9 03 1e fe 0f 0b 48 89 f1 48 c7 c7 80 25 c6 87 4c 89 e6 e8 d5 03  
1e fe 0f 0b 4c 89 f6 48 c7 c7 20 27 c6 87 e8 c4 03 1e fe <0f> 0b 4c 89 ea  
4c 89 f6 48 c7 c7 60 26 c6 87 e8 b0 03 1e fe 0f 0b
RSP: 0018:ffff8880a9917cc0 EFLAGS: 00010286
RAX: 0000000000000054 RBX: ffff8880996e84f8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815c3b96 RDI: ffffed1015322f8a
RBP: ffff8880a9917cd8 R08: 0000000000000054 R09: ffffed1015d260d1
R10: ffffed1015d260d0 R11: ffff8880ae930687 R12: ffff88808f998638
R13: ffff88808f998638 R14: ffff8880996e84e0 R15: ffff8880aa0a8500
FS:  0000000000000000(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2648a08db8 CR3: 00000000981a9000 CR4: 00000000001406e0

