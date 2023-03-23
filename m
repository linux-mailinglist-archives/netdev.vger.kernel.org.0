Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC1E76C5B6D
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 01:40:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjCWAj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 20:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjCWAj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 20:39:57 -0400
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C028AE385
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 17:39:54 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id 9-20020a5ea509000000b0074ca36737d2so10598889iog.7
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 17:39:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679531994;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IaRX0pgESu9HWGk8g/PO1osl2nS+cMN0WgqbIcZnRUU=;
        b=gXjglVD/PrgxUuBwoXWLDhXY2VU5ZwIRnCzgMBVGr8aZB3dBhOXeHyKwr1wsk0kUat
         cgDN+8VpJwzyCkyfqf+qKV4FcgMOvYxq58nM+l2eYRTSdVLZDnDt6IfihN22oBx4Og9Q
         RyfvETPO67tW5UREP12MMsEmo8ciTCEckhAfThThrwvCaftIS2ft1vKyiUd9hjOXX+4g
         rb6YACmnjSwzeKbT9lNJqhkHjkIqGB9PO6636LNQnKWMDyNdKXqXbHYHfI57AFv0owxz
         B1egtEGlq4RUUxouxFgzqdMf/rX6GSfZDZGdKkvnIRkTHAUQ4K4liONzPydER260sBwp
         GVLA==
X-Gm-Message-State: AO0yUKXeG7uOX/yTPyAGR9cra/CnkifxXhfrcdIl08AkVW+kD34gNe1t
        qT7HkZlyeq0cc541DlMqA8ZQe5P4kkENqme8eb9k8ff8ca/G
X-Google-Smtp-Source: AK7set9HPan20YrTNHcdhFU26NpdqcY7CRhCZusJLZlh+ieMFlCVxTiMxE5CWXWLkPRjrw7nsMX1mK1hpBg7OzmToF6iUW44uFB2
MIME-Version: 1.0
X-Received: by 2002:a02:9485:0:b0:3be:81d3:5af3 with SMTP id
 x5-20020a029485000000b003be81d35af3mr3967436jah.3.1679531993978; Wed, 22 Mar
 2023 17:39:53 -0700 (PDT)
Date:   Wed, 22 Mar 2023 17:39:53 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e3e09c05f78683a6@google.com>
Subject: [syzbot] [arm-msm?] [net?] WARNING: refcount bug in qrtr_recvmsg (2)
From:   syzbot <syzbot+a7492efaa5d61b51db23@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mani@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9c1bec9c0b08 Merge tag 'linux-kselftest-fixes-6.3-rc3' of ..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17285724c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6c84f77790aba2eb
dashboard link: https://syzkaller.appspot.com/bug?extid=a7492efaa5d61b51db23
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13c9f8a4c80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10e8fe2cc80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/eee5724f97b4/disk-9c1bec9c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/00ee10c4bc28/vmlinux-9c1bec9c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/42cf9c3e67cd/bzImage-9c1bec9c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a7492efaa5d61b51db23@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 0 PID: 46 at lib/refcount.c:25 refcount_warn_saturate+0x17c/0x1f0 lib/refcount.c:25
Modules linked in:
CPU: 0 PID: 46 Comm: kworker/u4:3 Not tainted 6.3.0-rc2-syzkaller-00050-g9c1bec9c0b08 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
Workqueue: qrtr_ns_handler qrtr_ns_worker
RIP: 0010:refcount_warn_saturate+0x17c/0x1f0 lib/refcount.c:25
Code: 0a 31 ff 89 de e8 64 17 73 fd 84 db 0f 85 2e ff ff ff e8 47 1b 73 fd 48 c7 c7 e0 6a a6 8a c6 05 5d 73 52 0a 01 e8 e4 94 3b fd <0f> 0b e9 0f ff ff ff e8 28 1b 73 fd 0f b6 1d 47 73 52 0a 31 ff 89
RSP: 0018:ffffc90000b779d8 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888017d61d40 RSI: ffffffff814b6037 RDI: 0000000000000001
RBP: ffff88802717ec98 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: ffff888145178000
R13: ffff88802717ec00 R14: ffff8880280b1030 R15: ffff8880280b1034
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffdb2009388 CR3: 0000000029dad000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __refcount_add include/linux/refcount.h:199 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 kref_get include/linux/kref.h:45 [inline]
 qrtr_node_acquire net/qrtr/af_qrtr.c:202 [inline]
 qrtr_node_lookup net/qrtr/af_qrtr.c:398 [inline]
 qrtr_send_resume_tx net/qrtr/af_qrtr.c:1003 [inline]
 qrtr_recvmsg+0x85f/0x990 net/qrtr/af_qrtr.c:1070
 sock_recvmsg_nosec net/socket.c:1017 [inline]
 sock_recvmsg+0xe2/0x160 net/socket.c:1038
 qrtr_ns_worker+0x170/0x1700 net/qrtr/ns.c:688
 process_one_work+0x991/0x15c0 kernel/workqueue.c:2390
 worker_thread+0x669/0x1090 kernel/workqueue.c:2537
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
