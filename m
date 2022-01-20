Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4AA0495323
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 18:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbiATR2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 12:28:12 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:41779 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236065AbiATR0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 12:26:21 -0500
Received: by mail-io1-f72.google.com with SMTP id e19-20020a6bf113000000b006090f93a288so4417978iog.8
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 09:26:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=2uyROQkwAubxAhtrVkpi0xhwbRArP4G5FL5KEzxUI9M=;
        b=ocUuGOS7XMOCiqhJs0DJX8Pu+ZTy9lT83Z4l6bKtfpZtyMalrnMx36BTZEC3+6XFbB
         Qovjtd2b0ULb0dCH8MGHjiKV2IJsJ21cyKUAKnayHIenBlCMOHYSVn1dFSlf6eOHOI6j
         aKFvLNj1LhTwt3a+DDvbpjcT4RaOt8VA+Fxv2VQBq4Cmt+RtUJCp1R6WXFjmGsx59NJz
         ltZNwt1hko7LgCm9t9bJ6+BTz2ZIh/TEZdAVsrA0rvB697iBWv6f/MtrZOV8OpXGiZxg
         RVEEfNkYXGudC6oMJR+Nw6XhgmpVxNuTvlNcvbPAAAftnm3TV3pahOia7cTDoT3NSxds
         Bh2g==
X-Gm-Message-State: AOAM5335WN6JADaiWWMJWd/plJLQw3Bed8YGzE3p2JAQq3BWpfka08jU
        UmY0V5cZ7o4F+YNW+0skKVOdZYMtF/+D4aclUvZyhSk5pxkQ
X-Google-Smtp-Source: ABdhPJzn7lnstB1hmXA3lDtjeXtCpQEY7xs8KvPUbYnitaFERg04FffKPh05hSmrGJX9vU3ghvzbwqufncCskrbtcd8pME37RjTz
MIME-Version: 1.0
X-Received: by 2002:a02:cc83:: with SMTP id s3mr15734606jap.153.1642699580697;
 Thu, 20 Jan 2022 09:26:20 -0800 (PST)
Date:   Thu, 20 Jan 2022 09:26:20 -0800
In-Reply-To: <0000000000000ca79b05d24e85fd@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fafeca05d606cc4a@google.com>
Subject: Re: [syzbot] WARNING: ODEBUG bug in cancel_delayed_work (2)
From:   syzbot <syzbot+4b140c35e652626b77ba@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    fa2e1ba3e9e3 Merge tag 'net-5.17-rc1' of git://git.kernel...
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=103cf9ffb00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fed7021824b74f81
dashboard link: https://syzkaller.appspot.com/bug?extid=4b140c35e652626b77ba
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1615b23fb00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13718b50700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4b140c35e652626b77ba@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: assert_init not available (active state 0) object type: timer_list hint: 0x0
WARNING: CPU: 0 PID: 3603 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Modules linked in:
CPU: 0 PID: 3603 Comm: syz-executor756 Not tainted 5.16.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd 80 f2 05 8a 4c 89 ee 48 c7 c7 80 e6 05 8a e8 24 a3 26 05 <0f> 0b 83 05 85 4f b3 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc90001d2f928 EFLAGS: 00010082
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000000000
RDX: ffff888023568000 RSI: ffffffff815f9d98 RDI: fffff520003a5f17
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815f3afe R11: 0000000000000000 R12: ffffffff89ae27e0
R13: ffffffff8a05ed00 R14: ffffffff8166b6b0 R15: 1ffff920003a5f30
FS:  0000555556897300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe13002485e CR3: 0000000072763000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 debug_object_assert_init lib/debugobjects.c:895 [inline]
 debug_object_assert_init+0x1f4/0x2e0 lib/debugobjects.c:866
 debug_timer_assert_init kernel/time/timer.c:739 [inline]
 debug_assert_init kernel/time/timer.c:784 [inline]
 del_timer+0x6d/0x110 kernel/time/timer.c:1204
 try_to_grab_pending+0x6d/0xd0 kernel/workqueue.c:1285
 __cancel_work kernel/workqueue.c:3268 [inline]
 cancel_delayed_work+0x79/0x340 kernel/workqueue.c:3297
 l2cap_clear_timer include/net/bluetooth/l2cap.h:883 [inline]
 l2cap_chan_del+0x517/0xa80 net/bluetooth/l2cap_core.c:665
 l2cap_chan_close+0x1b9/0xaf0 net/bluetooth/l2cap_core.c:825
 l2cap_sock_shutdown+0x3d2/0x1070 net/bluetooth/l2cap_sock.c:1377
 l2cap_sock_release+0x72/0x200 net/bluetooth/l2cap_sock.c:1420
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x18/0x20 net/socket.c:1318
 __fput+0x286/0x9f0 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:175 [inline]
 exit_to_user_mode_prepare+0x27e/0x290 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:300
 do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f24557e606b
Code: 0f 05 48 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8 63 fc ff ff 8b 7c 24 0c 41 89 c0 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 89 44 24 0c e8 a1 fc ff ff 8b 44
RSP: 002b:00007ffe2a68a750 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 00007f24557e606b
RDX: ffffffffffffffb8 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 0000000000000003 R08: 0000000000000000 R09: 000000ff00000001
R10: 000000ff00000001 R11: 0000000000000293 R12: 00005555568972b8
R13: 0000000000000072 R14: 00007ffe2a68a7c0 R15: 0000000000000003
 </TASK>

