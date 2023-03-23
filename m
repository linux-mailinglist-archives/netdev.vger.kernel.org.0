Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E596C5B70
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 01:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjCWAkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 20:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjCWAj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 20:39:58 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3836B1E290
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 17:39:55 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id n9-20020a056e02100900b00325c9240af7so1417601ilj.10
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 17:39:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679531994;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cRmAnTw5x2//9xw8ssGmcUbF4NEnjW4TaY2uygOKll4=;
        b=Q5JtYdoF+/6X3z0/0h8cHKTpguYkc8754bLFAwZHBmIRE0k/qjPjDNTzEDFbmwxGF7
         FbzbzcRypF7WKwrBq9lFhVsz4SFkqZKE4p/coTFpt15QopJvEpJtuXe2SJoWgo+XlNZO
         z0LbBJpV1v5MUuMnLRF4veywiUqgTQ9FWXBEWnNa20twUNAj9Y11qY2DtXfW9ZORZtZh
         ZOk2GQnLW9MrCMz8eR8JxliMzFjedRae9YfXPsBd1z7Hy6ZzvRjzkPJRxaJh0mgg3igH
         Q+9raGaVf/xhnh9tTmfiZlSmVuM2G7UlE9otxyJ1k/wl0KfqVUgmG3IqckYDryinjUpv
         wI5A==
X-Gm-Message-State: AO0yUKUZYaGq8Z1Mni1ueoZTZT1TA2LbuGd2+BkRc6rEoNORs1Cmoblm
        oW0EUBvZG4LsjO8WGYUZgFQdLM+Iatyhc8rHj5PWW+OWPK9I
X-Google-Smtp-Source: AK7set+lg35o6E3vNTGqfBkhJh4iHmqWe/pBv0lYcq/fhuijMdnHb973Am1aOOD/gFF2NnmeIci09LMorlH0GDh/RAPQAPXKckwK
MIME-Version: 1.0
X-Received: by 2002:a02:84e6:0:b0:3c5:1971:1b7f with SMTP id
 f93-20020a0284e6000000b003c519711b7fmr3728669jai.6.1679531994236; Wed, 22 Mar
 2023 17:39:54 -0700 (PDT)
Date:   Wed, 22 Mar 2023 17:39:54 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e7f27b05f78683fb@google.com>
Subject: [syzbot] [arm-msm?] [net?] WARNING: refcount bug in qrtr_node_lookup (2)
From:   syzbot <syzbot+e8a22d28d4527d9d6148@syzkaller.appspotmail.com>
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

HEAD commit:    fe15c26ee26e Linux 6.3-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=111b3ca4c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7573cbcd881a88c9
dashboard link: https://syzkaller.appspot.com/bug?extid=e8a22d28d4527d9d6148
compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=160ec3dcc80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=103d9d42c80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/89d41abd07bd/disk-fe15c26e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fa75f5030ade/vmlinux-fe15c26e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/590d0f5903ee/Image-fe15c26e.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e8a22d28d4527d9d6148@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 1 PID: 9 at lib/refcount.c:25 refcount_warn_saturate+0x1a8/0x20c lib/refcount.c:25
Modules linked in:
CPU: 1 PID: 9 Comm: kworker/u4:0 Not tainted 6.3.0-rc1-syzkaller-gfe15c26ee26e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023
Workqueue: qrtr_ns_handler qrtr_ns_worker
pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : refcount_warn_saturate+0x1a8/0x20c lib/refcount.c:25
lr : refcount_warn_saturate+0x1a8/0x20c lib/refcount.c:25
sp : ffff80001a3a6da0
x29: ffff80001a3a6da0 x28: dfff800000000000 x27: ffff700003474dc8
x26: ffff80001a3a6e60 x25: 0000000000000000 x24: 00000000003a6056
x23: ffff0000d22173f0 x22: 0000000000000000 x21: 0000000000000002
x20: ffff0000d751c098 x19: ffff8000186ee000 x18: ffff80001a3a62a0
x17: 0000000000000000 x16: ffff80001246250c x15: 0000000000000000
x14: 0000000000000000 x13: 0000000000000001 x12: 0000000000000001
x11: ff808000081bd230 x10: 0000000000000000 x9 : 04bb8433d1680a00
x8 : 04bb8433d1680a00 x7 : 0000000000000001 x6 : 0000000000000001
x5 : ffff80001a3a6698 x4 : ffff800015dc52c0 x3 : ffff80000859c514
x2 : 0000000000000001 x1 : 0000000100000001 x0 : 0000000000000000
Call trace:
 refcount_warn_saturate+0x1a8/0x20c lib/refcount.c:25
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 kref_get include/linux/kref.h:45 [inline]
 qrtr_node_acquire net/qrtr/af_qrtr.c:202 [inline]
 qrtr_node_lookup+0xdc/0x100 net/qrtr/af_qrtr.c:398
 qrtr_send_resume_tx net/qrtr/af_qrtr.c:1003 [inline]
 qrtr_recvmsg+0x3dc/0x954 net/qrtr/af_qrtr.c:1070
 sock_recvmsg_nosec net/socket.c:1015 [inline]
 sock_recvmsg net/socket.c:1036 [inline]
 kernel_recvmsg+0x124/0x18c net/socket.c:1061
 qrtr_ns_worker+0x294/0x513c net/qrtr/ns.c:688
 process_one_work+0x868/0x16f4 kernel/workqueue.c:2390
 worker_thread+0x8e0/0xfe8 kernel/workqueue.c:2537
 kthread+0x24c/0x2d4 kernel/kthread.c:376
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:870
irq event stamp: 766220
hardirqs last  enabled at (766219): [<ffff800012543b48>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:151 [inline]
hardirqs last  enabled at (766219): [<ffff800012543b48>] _raw_spin_unlock_irqrestore+0x44/0xa4 kernel/locking/spinlock.c:194
hardirqs last disabled at (766220): [<ffff80001254393c>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:108 [inline]
hardirqs last disabled at (766220): [<ffff80001254393c>] _raw_spin_lock_irqsave+0x2c/0x88 kernel/locking/spinlock.c:162
softirqs last  enabled at (766216): [<ffff80001066ca80>] spin_unlock_bh include/linux/spinlock.h:395 [inline]
softirqs last  enabled at (766216): [<ffff80001066ca80>] lock_sock_nested+0xe8/0x138 net/core/sock.c:3480
softirqs last disabled at (766214): [<ffff80001066ca28>] spin_lock_bh include/linux/spinlock.h:355 [inline]
softirqs last disabled at (766214): [<ffff80001066ca28>] lock_sock_nested+0x90/0x138 net/core/sock.c:3476
---[ end trace 0000000000000000 ]---


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
