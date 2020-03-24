Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F16AA19070C
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 09:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgCXIIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 04:08:13 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:45837 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgCXIIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 04:08:12 -0400
Received: by mail-il1-f200.google.com with SMTP id p15so11293543ils.12
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 01:08:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=hHXlzX2YhutrAXAO/2d9zPrQ+gr2qIaq8tPdZuhbzNc=;
        b=q2jLcnOAGn/+0wmyjlS87OT3FqZ0iUin2JYGUcb5/+ybTM5fmcXkvrKZ+aRzEZ7nyz
         puAgbtHBln5gsI28gAae+S3ik9wA1wSo83UgKIRLfRyPrr3VFjzwijL4dylWQkJHAaLX
         N+OLUwwxS59jI0pyAQX5oBI/7bCw+h7ikseD+miYCkyoQZBSq6nGMOWRdzrW1DlGc9An
         GpvXAFQSKfsiIY8yVo/AKG84RrP352TirNHsvw/4aAoQRIdkum/WHE17+tSyDC9Mph2V
         UUsNuTRd+nDbD+GWVNAP3mXFZl0p2goQqm4sb13izgoK8qFAzUo9AgVa7ZXHmF0kbQZK
         qN8w==
X-Gm-Message-State: ANhLgQ2RLEihnc5yX556ZRnk+slJ8PGBc1ek9LyAUQjQTAGT9huuj2Mt
        7IcSD/XtaKxszWih2r2mEz8R5ZojtuPNFTo+1psVrvx+F7EA
X-Google-Smtp-Source: ADFU+vveVCtjZFe00P8L3XaLLQqnYWVVmmBwqGMbFCFoBQ1tSt95B7Zv+mSEhz6cOYO8MKdGXim2hF2cI87+uh34wivVtdtgOkSM
MIME-Version: 1.0
X-Received: by 2002:a02:3808:: with SMTP id b8mr24506069jaa.136.1585037291793;
 Tue, 24 Mar 2020 01:08:11 -0700 (PDT)
Date:   Tue, 24 Mar 2020 01:08:11 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bbb17d05a19540cd@google.com>
Subject: KCSAN: data-race in decode_data.part.0 / sixpack_receive_buf
From:   syzbot <syzbot+673c2668e8c71c021637@syzkaller.appspotmail.com>
To:     ajk@comnets.uni-bremen.de, davem@davemloft.net, elver@google.com,
        linux-hams@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    245a4300 Merge branch 'rcu/kcsan' into tip/locking/kcsan
git tree:       https://github.com/google/ktsan.git kcsan
console output: https://syzkaller.appspot.com/x/log.txt?x=16543101e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a4b9db179318d21f
dashboard link: https://syzkaller.appspot.com/bug?extid=673c2668e8c71c021637
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+673c2668e8c71c021637@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in decode_data.part.0 / sixpack_receive_buf

read to 0xffff8880a68aa8f6 of 1 bytes by task 8699 on cpu 1:
 decode_data.part.0+0x8d/0x120 drivers/net/hamradio/6pack.c:846
 decode_data drivers/net/hamradio/6pack.c:965 [inline]
 sixpack_decode drivers/net/hamradio/6pack.c:968 [inline]
 sixpack_receive_buf+0x901/0xb90 drivers/net/hamradio/6pack.c:458
 tiocsti drivers/tty/tty_io.c:2200 [inline]
 tty_ioctl+0xb75/0xe10 drivers/tty/tty_io.c:2576
 vfs_ioctl fs/ioctl.c:47 [inline]
 file_ioctl fs/ioctl.c:545 [inline]
 do_vfs_ioctl+0x84f/0xcf0 fs/ioctl.c:732
 ksys_ioctl+0xbd/0xe0 fs/ioctl.c:749
 __do_sys_ioctl fs/ioctl.c:756 [inline]
 __se_sys_ioctl fs/ioctl.c:754 [inline]
 __x64_sys_ioctl+0x4c/0x60 fs/ioctl.c:754
 do_syscall_64+0xcc/0x3a0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

write to 0xffff8880a68aa8f6 of 1 bytes by task 8154 on cpu 0:
 decode_data drivers/net/hamradio/6pack.c:837 [inline]
 sixpack_decode drivers/net/hamradio/6pack.c:968 [inline]
 sixpack_receive_buf+0x40e/0xb90 drivers/net/hamradio/6pack.c:458
 tty_ldisc_receive_buf+0xeb/0xf0 drivers/tty/tty_buffer.c:465
 tty_port_default_receive_buf+0x87/0xd0 drivers/tty/tty_port.c:38
 receive_buf drivers/tty/tty_buffer.c:481 [inline]
 flush_to_ldisc+0x1d5/0x260 drivers/tty/tty_buffer.c:533
 process_one_work+0x3d4/0x890 kernel/workqueue.c:2264
 worker_thread+0xa0/0x800 kernel/workqueue.c:2410
 kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 8154 Comm: kworker/u4:5 Not tainted 5.5.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_unbound flush_to_ldisc
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
