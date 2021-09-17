Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16B8540FF02
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 20:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbhIQSIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 14:08:49 -0400
Received: from mail-il1-f198.google.com ([209.85.166.198]:50994 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233801AbhIQSIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 14:08:48 -0400
Received: by mail-il1-f198.google.com with SMTP id x4-20020a92b004000000b0022b3cb3b4deso8570753ilh.17
        for <netdev@vger.kernel.org>; Fri, 17 Sep 2021 11:07:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=TSZSZYxRds2+v+DyZXxz8vq0C1X5lx7/z+SNdhYa2qI=;
        b=kKUgxMkCVzEQEs3OriXPRCy4lSm4iLdihJ1TWOw5My4FUAnVYMNttF8NtgGLH+TXOn
         nc69/MKTP7Mw0pr8BUKykR9zg1Qlxo48dp1CfJLfx/qSxiYBJ9anN6EDRFsmXqggWUhW
         Kc4C8qhpVB/2P2QXic+7zTncbTSLFD1u0Xa1qAOkwFrK8+b3SR38prYuo23XowqcgHSk
         uIsr5ohf53590iwA6HG9QqR8UqJAW/Lk/YOQZ9A58QV/FcgP/tuYs1bgrJhDnHiBvCth
         XDZdAjkjzIMOal47owMqVy5nVJ7XJfrdcltKEjtmZvYkGPB8oVxA37zDVVLM++yv6SfW
         0Egw==
X-Gm-Message-State: AOAM531PZ6BUV9MSYegPHWiySPuIo19IaPL+mYGuZs8qJKIuncH0LCac
        GvUp/nlcd//qgFfDV/jq+ByNhNk5eYKgZReLP97M7Rg+vWiJ
X-Google-Smtp-Source: ABdhPJzq3LakqqA6s4gtmSLjWU6hgTJToKDRLiwWqAif0Ml2YZJorB1DgEPdL3y/z5AKnqvEJSS2buA3w9P5aBfCrQLqrxu1My8g
MIME-Version: 1.0
X-Received: by 2002:a92:cdad:: with SMTP id g13mr97999ild.103.1631902045500;
 Fri, 17 Sep 2021 11:07:25 -0700 (PDT)
Date:   Fri, 17 Sep 2021 11:07:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000baf9fa05cc34cda8@google.com>
Subject: [syzbot] WARNING: refcount bug in sco_sock_timeout
From:   syzbot <syzbot+0d58aed5b04e25a9b5a7@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        luiz.dentz@gmail.com, marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    29ce8f970107 Merge git://git.kernel.org/pub/scm/linux/kern..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12f40133300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2f9d4c9ff8c5ae7
dashboard link: https://syzkaller.appspot.com/bug?extid=0d58aed5b04e25a9b5a7
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0d58aed5b04e25a9b5a7@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 0 PID: 10451 at lib/refcount.c:25 refcount_warn_saturate+0x169/0x1e0 lib/refcount.c:25
Modules linked in:
CPU: 0 PID: 10451 Comm: kworker/0:8 Not tainted 5.14.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events sco_sock_timeout
RIP: 0010:refcount_warn_saturate+0x169/0x1e0 lib/refcount.c:25
Code: 09 31 ff 89 de e8 d7 c9 9e fd 84 db 0f 85 36 ff ff ff e8 8a c3 9e fd 48 c7 c7 20 8f e3 89 c6 05 e8 7f 81 09 01 e8 f0 98 16 05 <0f> 0b e9 17 ff ff ff e8 6b c3 9e fd 0f b6 1d cd 7f 81 09 31 ff 89
RSP: 0018:ffffc9001766fce8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88802cea3880 RSI: ffffffff815d87a5 RDI: fffff52002ecdf8f
RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815d25de R11: 0000000000000000 R12: ffff88806d23ce08
R13: ffff8880712c8080 R14: ffff88802edf4500 R15: ffff8880b9c51240
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f3748c20000 CR3: 0000000017644000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __refcount_add include/linux/refcount.h:199 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 sock_hold include/net/sock.h:702 [inline]
 sco_sock_timeout+0x216/0x290 net/bluetooth/sco.c:88
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
