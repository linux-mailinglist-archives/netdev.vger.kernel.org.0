Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDBB91908
	for <lists+netdev@lfdr.de>; Sun, 18 Aug 2019 20:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfHRSrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Aug 2019 14:47:10 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:49507 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfHRSrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Aug 2019 14:47:07 -0400
Received: by mail-io1-f72.google.com with SMTP id k13so1668764ioh.16
        for <netdev@vger.kernel.org>; Sun, 18 Aug 2019 11:47:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=zDgZNUFDgGstctQhA5e9B3Yy/pHKkUvS8U2iUc3RWJc=;
        b=R1V1VTMsB3bX7xJTqo9ezQrjV4v1x2oXBSDPJXQqOvsmIyAGD+sTKxeIGzHgS1Mn63
         uED8QCv+I4ybXm2fQyzMg4xPMx8xzuqkievhfe5IMWGrJhaRnJgexZm5Lc/sJcxZA4d7
         OYC6LracYC0MaYdtBdoOovbvOWZL2oQ8p61J260TskI7j11tiLQj42vpaNCLoSsC1oTc
         SY0psp/RsEIzq5K7YhnPn7HLhPAhG/Ojef1Fhuqr/tj9i+TvVqVDhAFCHmM0z/C9CxTb
         DsRVdr4vqSomHIq1Kxe52RxenhFCznHK36e9dE+tj9OQ38ZqMOw2gI83021jBVjCgN1P
         IldQ==
X-Gm-Message-State: APjAAAVz+fGoCt+6/tJrbySMruwM68I49SosIONxK/rSfOcAbaEKfHL3
        QSvson6kWuXpXn+Dnwmry2Sce1e6AXXonFxgvFD9BI7eIF8Z
X-Google-Smtp-Source: APXvYqyCe0YYoEWtGbv/2uf8ztOrkSCn1II2bREdkWZ+sft0RqrJ3w9DoWKiuLFFm7detM37UBrYjkFOl1a27HlPGKQpn4X5qwyz
MIME-Version: 1.0
X-Received: by 2002:a6b:cd07:: with SMTP id d7mr20708646iog.150.1566154026241;
 Sun, 18 Aug 2019 11:47:06 -0700 (PDT)
Date:   Sun, 18 Aug 2019 11:47:06 -0700
In-Reply-To: <0000000000004c2416058c594b30@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000065d943059068a632@google.com>
Subject: Re: kernel BUG at net/rxrpc/local_object.c:LINE!
From:   syzbot <syzbot+1e0edc4b8b7494c28450@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, dvyukov@google.com,
        ebiggers@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    0c3d3d64 Add linux-next specific files for 20190816
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=108b58f2600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=dffdf1e146f941f4
dashboard link: https://syzkaller.appspot.com/bug?extid=1e0edc4b8b7494c28450
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13feb73c600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=127088f2600000

The bug was bisected to:

commit 46894a13599a977ac35411b536fb3e0b2feefa95
Author: David Howells <dhowells@redhat.com>
Date:   Thu Oct 4 08:32:28 2018 +0000

     rxrpc: Use IPv4 addresses throught the IPv6

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=152fabe3a00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=172fabe3a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=132fabe3a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+1e0edc4b8b7494c28450@syzkaller.appspotmail.com
Fixes: 46894a13599a ("rxrpc: Use IPv4 addresses throught the IPv6")

rxrpc: Assertion failed
------------[ cut here ]------------
kernel BUG at net/rxrpc/local_object.c:433!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.3.0-rc4-next-20190816 #67
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: krxrpcd rxrpc_local_processor
RIP: 0010:rxrpc_local_destroyer net/rxrpc/local_object.c:433 [inline]
RIP: 0010:rxrpc_local_processor.cold+0x24/0x29 net/rxrpc/local_object.c:466
Code: df a1 bc fa 0f 0b e8 c4 2b d3 fa 48 c7 c7 e0 24 5b 88 e8 cc a1 bc fa  
0f 0b e8 b1 2b d3 fa 48 c7 c7 e0 24 5b 88 e8 b9 a1 bc fa <0f> 0b 90 90 90  
55 48 89 e5 41 57 49 89 ff 41 56 41 55 41 54 53 48
RSP: 0018:ffff8880a98d7ce8 EFLAGS: 00010282
RAX: 0000000000000017 RBX: ffff88808c90a978 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815bb906 RDI: ffffed101531af8f
RBP: ffff8880a98d7d30 R08: 0000000000000017 R09: ffffed1015d060d9
R10: ffffed1015d060d8 R11: ffff8880ae8306c7 R12: ffff88808c90a208
R13: ffff88808dc48648 R14: ffff88808c90a940 R15: ffff8880929faa00
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000049f2b0 CR3: 0000000008e6d000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace c65e44ef4b16c854 ]---
RIP: 0010:rxrpc_local_destroyer net/rxrpc/local_object.c:433 [inline]
RIP: 0010:rxrpc_local_processor.cold+0x24/0x29 net/rxrpc/local_object.c:466
Code: df a1 bc fa 0f 0b e8 c4 2b d3 fa 48 c7 c7 e0 24 5b 88 e8 cc a1 bc fa  
0f 0b e8 b1 2b d3 fa 48 c7 c7 e0 24 5b 88 e8 b9 a1 bc fa <0f> 0b 90 90 90  
55 48 89 e5 41 57 49 89 ff 41 56 41 55 41 54 53 48
RSP: 0018:ffff8880a98d7ce8 EFLAGS: 00010282
RAX: 0000000000000017 RBX: ffff88808c90a978 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815bb906 RDI: ffffed101531af8f
RBP: ffff8880a98d7d30 R08: 0000000000000017 R09: ffffed1015d060d9
R10: ffffed1015d060d8 R11: ffff8880ae8306c7 R12: ffff88808c90a208
R13: ffff88808dc48648 R14: ffff88808c90a940 R15: ffff8880929faa00
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffff600400 CR3: 000000009b982000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400

