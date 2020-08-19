Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A348924A259
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 17:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgHSPCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 11:02:25 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:37869 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgHSPCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 11:02:22 -0400
Received: by mail-io1-f69.google.com with SMTP id f6so14388772ioa.4
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 08:02:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=67Gh75A1TSpN6NtiARVGU9hWjZqJ15XNNQGywFVosG0=;
        b=Jyly/yc61+ekpSvGF1cWgA6FjE84UTOvzd72nCByxOgAeUKccQxzSEil94sgKuR/+e
         fHnydfZZoRvuaoZ2WwL7ymOQIWBokr0Cq1UmTGlshC/5tDYRpuK5tzselOSyFTlDlYPv
         bXJGj0i4YNRLvbeAUS3sOkmU1Pzs3ViYIkXnbmPBsRdd8T0bqfFolQk0mBQlqu5NQbDf
         /YkU6PjP8itW3unPJajkoexUx4AZOI5EUzRR2ns0fofzUNVZMyNkXqfnekwKw1LoGjC/
         lk6EqaBNQ6AOH9OUOgrMLciJHKxTatmyIUzlioDwYMFvAVzteuWIBV25AolqjFoq0R4i
         uONQ==
X-Gm-Message-State: AOAM533J0Fiw6wXDxR/OInrViXZqnK7g8FaXmWaumIW0fTAH1lCVNptk
        Ns4+gSKRZi3/GAxAqS/ERir/z4LOXEyKqM6ah7TJNl5L/zkg
X-Google-Smtp-Source: ABdhPJyvN4+7Tvk6NZpG6almeZlIMGgzU5iWuaJVJIQJxIvHiNKvtJVyzgAjNmdVi5jHIVN0cpxmVvEtulJN3SDb4OQLAnh8xQ5A
MIME-Version: 1.0
X-Received: by 2002:a92:d782:: with SMTP id d2mr24126782iln.167.1597849341396;
 Wed, 19 Aug 2020 08:02:21 -0700 (PDT)
Date:   Wed, 19 Aug 2020 08:02:21 -0700
In-Reply-To: <000000000000a7e38a05a997edb2@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000660e9a05ad3c4ace@google.com>
Subject: Re: WARNING in __cfg80211_connect_result
From:   syzbot <syzbot+cc4c0f394e2611edba66@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    e3ec1e8c net: eliminate meaningless memcpy to data in pskb..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1664ac89900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3d400a47d1416652
dashboard link: https://syzkaller.appspot.com/bug?extid=cc4c0f394e2611edba66
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15d9de91900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cc4c0f394e2611edba66@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 234 at net/wireless/sme.c:757 __cfg80211_connect_result+0xf71/0x13a0 net/wireless/sme.c:757
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 234 Comm: kworker/u4:5 Not tainted 5.9.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: cfg80211 cfg80211_event_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:231
 __warn.cold+0x20/0x4a kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:__cfg80211_connect_result+0xf71/0x13a0 net/wireless/sme.c:757
Code: 89 be ac 02 00 00 48 c7 c7 60 0f 18 89 c6 05 ef ba 2b 03 01 e8 f5 4a d9 f9 e9 4f f6 ff ff e8 d6 cc f2 f9 0f 0b e8 cf cc f2 f9 <0f> 0b e9 0c f2 ff ff e8 c3 cc f2 f9 e8 2e bb 71 00 31 ff 89 c3 89
RSP: 0018:ffffc900019c7bb8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88808ae13000 RCX: ffffffff87816922
RDX: ffff8880a8b0a540 RSI: ffffffff878174b1 RDI: 0000000000000005
RBP: ffff88807be34818 R08: 0000000000000001 R09: ffffffff8c5f1a3f
R10: 0000000000000000 R11: 1ffffffff1835405 R12: 0000000000000000
R13: ffff88807be34828 R14: ffff88808ae13200 R15: ffff88807be34820
 cfg80211_process_wdev_events+0x2c6/0x5b0 net/wireless/util.c:893
 cfg80211_process_rdev_events+0x6e/0x100 net/wireless/util.c:934
 cfg80211_event_work+0x1a/0x20 net/wireless/core.c:320
 process_one_work+0x94c/0x1670 kernel/workqueue.c:2269
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Kernel Offset: disabled
Rebooting in 86400 seconds..

