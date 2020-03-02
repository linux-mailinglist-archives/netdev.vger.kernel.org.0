Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECB881752FC
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 06:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgCBFLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 00:11:13 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:48478 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgCBFLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 00:11:13 -0500
Received: by mail-il1-f199.google.com with SMTP id c1so1612327ilj.15
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 21:11:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=rVXWG6I2Docu/l6TEelQQ6kA2g+m3kqyIZlYlybmkwo=;
        b=bPZGIFVNuP5DMHT1KII+/ovepCnmswwqZisJt9nMTsDF/+7NcaRihyxs6ciyJYPYZt
         U80ASuIV5e++791PKX1sYxuE4MyRIpgJsxWHMYV7KY1INoc00cDrL4Q3qADmEELa0lRA
         c4pT8qOXNIQJJHBR3sFrroMbR+leihvB7kMvJzJPjRHLT/NbTB+HXtvs0PK4oNNvhzOf
         K2+mQIs8iv9TGYH7FKJbfUYtUJq0HT+nvRA+876hHX6rgVh5jm0rjUS+RtT8/sOnK3Rt
         h3kNvuVps91jFDwEQGyL0Mra+XlLLugvfvIwQXLOl21CDqN5sYzDBIRb37y1N7SXbsE8
         hByw==
X-Gm-Message-State: APjAAAXg+lJSBU4AMKsoYVQ8j0QXX9LYHAhkM8MpcX+3AutsGivZ2DId
        S3irkPLnxLu2nVmKGgnBzGKwp/h4EdKuoYs90dvRIJlY1c6a
X-Google-Smtp-Source: APXvYqzSc8GFjXA/MA2ZmJf4WdSfc+oPzmo1obgWuI1E/TAeLQhVwX4Lovym2prkbzqMESaqM5uZyT9kuTbPIiV1PcLWyrdKBa6F
MIME-Version: 1.0
X-Received: by 2002:a92:798d:: with SMTP id u135mr15743801ilc.49.1583125872396;
 Sun, 01 Mar 2020 21:11:12 -0800 (PST)
Date:   Sun, 01 Mar 2020 21:11:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004251e4059fd83720@google.com>
Subject: WARNING: ODEBUG bug in smc_ib_remove_dev
From:   syzbot <syzbot+b297c6825752e7a07272@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kgraul@linux.ibm.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        ubraun@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    63623fd4 Merge tag 'for-linus' of git://git.kernel.org/pub..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12873645e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9833e26bab355358
dashboard link: https://syzkaller.appspot.com/bug?extid=b297c6825752e7a07272
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b297c6825752e7a07272@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: free active (active state 0) object type: work_struct hint: smc_ib_port_event_work+0x0/0x350 net/smc/smc_ib.c:312
WARNING: CPU: 0 PID: 14236 at lib/debugobjects.c:485 debug_print_object+0x168/0x250 lib/debugobjects.c:485
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 14236 Comm: kworker/u4:10 Not tainted 5.6.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_unbound ib_unregister_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x197/0x210 lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:221
 __warn.cold+0x2f/0x3e kernel/panic.c:582
 report_bug+0x289/0x300 lib/bug.c:195
 fixup_bug arch/x86/kernel/traps.c:174 [inline]
 fixup_bug arch/x86/kernel/traps.c:169 [inline]
 do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:267
 do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:286
 invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1027
RIP: 0010:debug_print_object+0x168/0x250 lib/debugobjects.c:485
Code: dd 00 e7 91 88 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 b5 00 00 00 48 8b 14 dd 00 e7 91 88 48 c7 c7 60 dc 91 88 e8 07 6e 9f fd <0f> 0b 83 05 03 6c ff 06 01 48 83 c4 20 5b 41 5c 41 5d 41 5e 5d c3
RSP: 0018:ffffc90001807ae0 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815ebe46 RDI: fffff52000300f4e
RBP: ffffc90001807b20 R08: ffff8880485a61c0 R09: ffffed1015d045c9
R10: ffffed1015d045c8 R11: ffff8880ae822e43 R12: 0000000000000001
R13: ffffffff89b7a220 R14: ffffffff814c8610 R15: ffff88806058e348
 __debug_check_no_obj_freed lib/debugobjects.c:967 [inline]
 debug_check_no_obj_freed+0x2d6/0x441 lib/debugobjects.c:998
 kfree+0xf8/0x2c0 mm/slab.c:3756
 smc_ib_remove_dev+0x1a9/0x2e0 net/smc/smc_ib.c:583
 remove_client_context+0xc7/0x120 drivers/infiniband/core/device.c:724
 disable_device+0x14c/0x230 drivers/infiniband/core/device.c:1268
 __ib_unregister_device+0x9c/0x190 drivers/infiniband/core/device.c:1435
 ib_unregister_work+0x19/0x30 drivers/infiniband/core/device.c:1545
 process_one_work+0xa05/0x17a0 kernel/workqueue.c:2264
 worker_thread+0x98/0xe40 kernel/workqueue.c:2410
 kthread+0x361/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
