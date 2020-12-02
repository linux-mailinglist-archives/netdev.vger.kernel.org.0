Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A98F2CC8CD
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 22:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729408AbgLBVUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 16:20:14 -0500
Received: from netrider.rowland.org ([192.131.102.5]:39627 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1727001AbgLBVUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 16:20:13 -0500
Received: (qmail 1069741 invoked by uid 1000); 2 Dec 2020 16:19:32 -0500
Date:   Wed, 2 Dec 2020 16:19:32 -0500
From:   Alan Stern <stern@rowland.harvard.edu>
To:     syzbot <syzbot+dbec6695a6565a9c6bc0@syzkaller.appspotmail.com>,
        Thierry Escande <thierry.escande@collabora.com>
Cc:     eli.billauer@gmail.com, gregkh@linuxfoundation.org,
        gustavoars@kernel.org, ingrassia@epigenesys.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tiwai@suse.de
Subject: Re: WARNING in port100_send_frame_async/usb_submit_urb
Message-ID: <20201202211932.GD1062758@rowland.harvard.edu>
References: <000000000000bab70f05b563a6cc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000bab70f05b563a6cc@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 01:21:27AM -0800, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    c84e1efa Merge tag 'asm-generic-fixes-5.10-2' of git://git..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14a98565500000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7be70951fca93701
> dashboard link: https://syzkaller.appspot.com/bug?extid=dbec6695a6565a9c6bc0
> compiler:       clang version 11.0.0 (https://github.com/llvm/llvm-project.git ca2dcbd030eadbf0aa9b660efe864ff08af6e18b)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17c607f1500000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+dbec6695a6565a9c6bc0@syzkaller.appspotmail.com
> 
> usb 1-1: string descriptor 0 read error: -32
> ------------[ cut here ]------------
> URB 000000005c26bc1e submitted while active
> WARNING: CPU: 0 PID: 5 at drivers/usb/core/urb.c:378 usb_submit_urb+0xf57/0x1510 drivers/usb/core/urb.c:378
> Modules linked in:
> CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 5.10.0-rc5-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: usb_hub_wq hub_event
> RIP: 0010:usb_submit_urb+0xf57/0x1510 drivers/usb/core/urb.c:378
> Code: 5c 41 5d 41 5e 41 5f 5d e9 76 5b ff ff e8 f1 e8 04 fc c6 05 25 0e 8b 07 01 48 c7 c7 a0 b7 5b 8a 4c 89 e6 31 c0 e8 89 07 d5 fb <0f> 0b e9 20 f1 ff ff e8 cd e8 04 fc eb 05 e8 c6 e8 04 fc bb a6 ff
> RSP: 0018:ffffc90000ca6ec8 EFLAGS: 00010246
> RAX: cf72e284cb303700 RBX: ffff888021723708 RCX: ffff888011108000
> RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
> RBP: 0000000000000cc0 R08: ffffffff815d29f2 R09: ffffed1017383ffc
> R10: ffffed1017383ffc R11: 0000000000000000 R12: ffff888021723700
> R13: dffffc0000000000 R14: ffff888012cfa458 R15: 1ffff1100259f489
> FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000056157313d160 CR3: 000000001e22c000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  port100_send_frame_async+0x1ea/0x390 drivers/nfc/port100.c:780
>  port100_send_cmd_async+0x6c7/0x950 drivers/nfc/port100.c:876
>  port100_send_cmd_sync drivers/nfc/port100.c:916 [inline]
>  port100_set_command_type drivers/nfc/port100.c:987 [inline]
>  port100_probe+0xd4f/0x1600 drivers/nfc/port100.c:1567

I don't understand this driver very well.  It looks like the problem 
stems from the fact that port100_send_frame_async() submits two URBs, 
but port100_send_cmd_sync() only waits for one of them to complete.  The 
other URB may then still be active when the driver tries to reuse it.

Maybe someone who's more familiar with the port100 driver can fix the 
problem.

Alan Stern
