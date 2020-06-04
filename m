Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 582971EEB18
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 21:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgFDT0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 15:26:21 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:47687 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729016AbgFDT0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 15:26:21 -0400
Received: by mail-il1-f197.google.com with SMTP id w65so4683734ilk.14
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 12:26:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=t1+7wYGhVtlGze+DWmzhSEjAeIv+k2jUWQ19PjIfolI=;
        b=qCOlozSI58rll3bXgVl8XKikZDtzWnJ3AYFDF063234t8Re5Ba6lDZLPvsWXM0cYFX
         h5auiAwdZgts/GSpTXVjCNGyVVRqiUe6Yd8xoqtbui2Q9iehAe21YRSj+/0J2FY9Zxqv
         4jUYYqc9Yjis073ZwJ7torefnLPU/jU+eJpm0qwEBCWBGu4lPHabN/qvzz+q3wJR3RfQ
         d8LOvKE5xMKXa7VPXeSo9Srjd/uL+tpSyGpZhDEDh8MIL8oO6s8JzG7veDarhSRfQk2t
         14PsCH6G56FiCTku0ZCnt+f+GsGY0tJ1Y98Tg81WKSWvPAZsluvICE8NjLRJHRWnGOPs
         opsA==
X-Gm-Message-State: AOAM5302A3LBYhfTUN+KyVbNZRd7ymgmCPeeYA9jIbHcw3VeSmWG7N28
        1hxJDfTRdHRkjHCxGyZm7HORPIMzDt9rPEmztr/qpQqoNYLq
X-Google-Smtp-Source: ABdhPJzupru41smJ4VCvGSmAN+p0C9vn5yD8KxCjjHG7IJ0Aqrfg091MJ3L61WReLf86qRJkrUCFTTmktkDGuqRinI2vDYLiVRCl
MIME-Version: 1.0
X-Received: by 2002:a6b:e215:: with SMTP id z21mr5416220ioc.115.1591298776548;
 Thu, 04 Jun 2020 12:26:16 -0700 (PDT)
Date:   Thu, 04 Jun 2020 12:26:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004eca9e05a7471e01@google.com>
Subject: PANIC: double fault in mark_lock
From:   syzbot <syzbot+4fceeb0d2fc702d5d41e@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, jakub@cloudflare.com,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@chromium.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, lmb@cloudflare.com,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    39884604 mptcp: fix NULL ptr dereference in MP_JOIN error ..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=125d5d16100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=55b0bb710b7fdf44
dashboard link: https://syzkaller.appspot.com/bug?extid=4fceeb0d2fc702d5d41e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4fceeb0d2fc702d5d41e@syzkaller.appspotmail.com

traps: PANIC: double fault, error_code: 0x0
double fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 29146 Comm: syz-executor.1 Not tainted 5.7.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
RIP: 0010:hlock_class kernel/locking/lockdep.c:179 [inline]
RIP: 0010:mark_lock+0x116/0xf10 kernel/locking/lockdep.c:3912
Code: 89 f8 48 c1 e8 03 0f b6 04 10 84 c0 74 08 3c 03 0f 8e e3 0b 00 00 0f b7 55 20 66 81 e2 ff 1f 0f b7 d2 be 08 00 00 00 48 89 d0 <48> 89 14 24 48 c1 f8 06 48 8d 3c c5 a0 a9 30 8c e8 85 42 58 00 48
RSP: 0018:ffffc8fffffffff8 EFLAGS: 00010002
RAX: 000000000000002c RBX: 1ffff92000000005 RCX: ffffffff815935f7
RDX: 000000000000002c RSI: 0000000000000008 RDI: ffff88808fed2080
RBP: ffff88808fed2a10 R08: 0000000000000000 R09: fffffbfff1861559
R10: ffffffff8c30aac7 R11: fffffbfff1861558 R12: 0000000000000008
R13: ffff88808fed2080 R14: 0000000000000005 R15: ffff88808fed2a30
FS:  00000000015ee940(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc8ffffffffe8 CR3: 000000009402e000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <IRQ>
 mark_usage kernel/locking/lockdep.c:3860 [inline]
 __lock_acquire+0x9a4/0x4c50 kernel/locking/lockdep.c:4309
 lock_acquire+0x1f2/0x8f0 kernel/locking/lockdep.c:4934
 rcu_lock_acquire include/linux/rcupdate.h:208 [inline]
 rcu_read_lock include/linux/rcupdate.h:601 [inline]
 sock_map_unhash+0x38/0x380 net/core/sock_map.c:1233
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 sock_map_unhash+0x303/0x380 net/core/sock_map.c:1238
 tcp_set_state+0x579/0x780 net/ipv4/tcp.c:2261
 tcp_done+0xdc/0x380 net/ipv4/tcp.c:4003
 tcp_reset+0x128/0x4e0 net/ipv4/tcp_input.c:4113
 tcp_validate_incoming+0xa51/0x16b0 net/ipv4/tcp_input.c:5514
 tcp_rcv_established+0x69a/0x1d90 net/ipv4/tcp_input.c:5722
 tcp_v6_do_rcv+0x418/0x1290 net/ipv6/tcp_ipv6.c:1449
 tcp_v6_rcv+0x2d07/0x3640 net/ipv6/tcp_ipv6.c:1682
 ip6_protocol_deliver_rcu+0x2e6/0x1660 net/ipv6/ip6_input.c:433
 ip6_input_finish+0x7f/0x160 net/ipv6/ip6_input.c:474
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip6_input+0xcf/0x3d0 net/ipv6/ip6_input.c:483
 dst_input include/net/dst.h:441 [inline]
 ip6_rcv_finish+0x1d9/0x310 net/ipv6/ip6_input.c:76
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ipv6_rcv+0xf8/0x3f0 net/ipv6/ip6_input.c:307
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5268
 __netif_receive_skb+0x27/0x1c0 net/core/dev.c:5382
 process_backlog+0x21e/0x7a0 net/core/dev.c:6214
 napi_poll net/core/dev.c:6659 [inline]
 net_rx_action+0x4c2/0x1070 net/core/dev.c:6727
 __do_softirq+0x26c/0x9f7 kernel/softirq.c:292
 do_softirq_own_stack+0x2a/0x40 arch/x86/entry/entry_64.S:1082
 </IRQ>
 do_softirq.part.0+0x10f/0x160 kernel/softirq.c:337
 do_softirq kernel/softirq.c:329 [inline]
 __local_bh_enable_ip+0x20e/0x270 kernel/softirq.c:189
 local_bh_enable include/linux/bottom_half.h:32 [inline]
 inet_csk_listen_stop+0x2b8/0xb20 net/ipv4/inet_connection_sock.c:1034
 tcp_close+0xe3d/0x1250 net/ipv4/tcp.c:2364
 inet_release+0xe4/0x1f0 net/ipv4/af_inet.c:428
 inet6_release+0x4c/0x70 net/ipv6/af_inet6.c:475
 __sock_release+0xcd/0x280 net/socket.c:605
 sock_close+0x18/0x20 net/socket.c:1278
 __fput+0x33e/0x880 fs/file_table.c:280
 task_work_run+0xf4/0x1b0 kernel/task_work.c:123
 tracehook_notify_resume include/linux/tracehook.h:188 [inline]
 exit_to_usermode_loop+0x2fa/0x360 arch/x86/entry/common.c:165
 prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
 syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
 do_syscall_64+0x6b1/0x7d0 arch/x86/entry/common.c:305
 entry_SYSCALL_64_after_hwframe+0x49/0xb3
RIP: 0033:0x416661
Code: 75 14 b8 03 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 04 1b 00 00 c3 48 83 ec 08 e8 0a fc ff ff 48 89 04 24 b8 03 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 53 fc ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007ffefd7b28b0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000005 RCX: 0000000000416661
RDX: 0000000000000000 RSI: 0000000000000d9f RDI: 0000000000000004
RBP: 0000000000000001 R08: 000000007b7b0d9f R09: 000000007b7b0da3
R10: 00007ffefd7b29a0 R11: 0000000000000293 R12: 000000000078c900
R13: 000000000078c900 R14: ffffffffffffffff R15: 000000000078bf0c
Modules linked in:
---[ end trace 500deeb1423f1fcc ]---
RIP: 0010:test_bit include/asm-generic/bitops/instrumented-non-atomic.h:110 [inline]
RIP: 0010:hlock_class kernel/locking/lockdep.c:179 [inline]
RIP: 0010:mark_lock+0x116/0xf10 kernel/locking/lockdep.c:3912
Code: 89 f8 48 c1 e8 03 0f b6 04 10 84 c0 74 08 3c 03 0f 8e e3 0b 00 00 0f b7 55 20 66 81 e2 ff 1f 0f b7 d2 be 08 00 00 00 48 89 d0 <48> 89 14 24 48 c1 f8 06 48 8d 3c c5 a0 a9 30 8c e8 85 42 58 00 48
RSP: 0018:ffffc8fffffffff8 EFLAGS: 00010002
RAX: 000000000000002c RBX: 1ffff92000000005 RCX: ffffffff815935f7
RDX: 000000000000002c RSI: 0000000000000008 RDI: ffff88808fed2080
RBP: ffff88808fed2a10 R08: 0000000000000000 R09: fffffbfff1861559
R10: ffffffff8c30aac7 R11: fffffbfff1861558 R12: 0000000000000008
R13: ffff88808fed2080 R14: 0000000000000005 R15: ffff88808fed2a30
FS:  00000000015ee940(0000) GS:ffff8880ae600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffc8ffffffffe8 CR3: 000000009402e000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
