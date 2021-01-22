Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176AD3005C5
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 15:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728600AbhAVOnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 09:43:49 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:33525 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728727AbhAVOnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 09:43:07 -0500
Received: by mail-io1-f72.google.com with SMTP id m3so9066951ioy.0
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 06:42:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=fE5kJzZFX6LHuXma+wdOzaWCPrGgoY6ccmowLSXJbw8=;
        b=B84KnJ1CrSqmjhHHiuhZJNDIDaU6wGH67bGgoIKXkEZe7nvT2OLeeljkqkIXZ65ppf
         rLuj2r+CTgs037JDdZU1RDhCdoI6tlNdZv9b4WHARXwV1x8EOFsTxWeqfLuBarSauY+h
         gft2m26T9Gl7N3R1MR3OwGAgy3mngQZXvsyo+H7mrde4E3YmBkDJmVkWs0tgsuIq7ikB
         5pTEyfSIcXPpwWY1L/hwo0+fo0/MbstYhvs5jsdo9k/MN5Lk+fgFGrqeTA4lTRhmbwOC
         sFbIyNpu4WSTMUg44bAZWXt7vhD955+KHprj7J8usOiIOM6nwnwObLkvBZJhzzk5rK0a
         yxHA==
X-Gm-Message-State: AOAM530JGf6+fkgI2xDXyt+E0M5fvbJC1pLdS5R770RgCXOrE6uDx0iE
        uQLorgoMRTC5MF+/+yA+qhmFJm2zljFnC+B8TfTPmgPYWEuH
X-Google-Smtp-Source: ABdhPJy7sTfsf/GJiCetI3voox1xPReGN1JRyYVuh7bfA3ZkebO6Ez0+j85tSElA8UsaBeIl2Xmle4DRPKaQBnwwcqRpdfQTkxhZ
MIME-Version: 1.0
X-Received: by 2002:a5d:944a:: with SMTP id x10mr3644441ior.30.1611326546207;
 Fri, 22 Jan 2021 06:42:26 -0800 (PST)
Date:   Fri, 22 Jan 2021 06:42:26 -0800
In-Reply-To: <000000000000f054d005b8f87274@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000676bd105b97e329a@google.com>
Subject: Re: WARNING in io_disable_sqo_submit
From:   syzbot <syzbot+2f5d1785dc624932da78@syzkaller.appspotmail.com>
To:     asml.silence@gmail.com, axboe@kernel.dk, davem@davemloft.net,
        hdanton@sina.com, io-uring@vger.kernel.org,
        johannes.berg@intel.com, johannes@sipsolutions.net,
        kuba@kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    9f29bd8b Merge tag 'fs_for_v5.11-rc5' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=169f4e9f500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=39701af622f054a9
dashboard link: https://syzkaller.appspot.com/bug?extid=2f5d1785dc624932da78
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1156bd20d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15ce819f500000

The issue was bisected to:

commit dcd479e10a0510522a5d88b29b8f79ea3467d501
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Oct 9 12:17:11 2020 +0000

    mac80211: always wind down STA state

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=13b8b83b500000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1078b83b500000
console output: https://syzkaller.appspot.com/x/log.txt?x=17b8b83b500000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2f5d1785dc624932da78@syzkaller.appspotmail.com
Fixes: dcd479e10a05 ("mac80211: always wind down STA state")

------------[ cut here ]------------
WARNING: CPU: 0 PID: 8572 at fs/io_uring.c:8917 io_disable_sqo_submit+0x13d/0x180 fs/io_uring.c:8917
Modules linked in:
CPU: 1 PID: 8572 Comm: syz-executor518 Not tainted 5.11.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:io_disable_sqo_submit+0x13d/0x180 fs/io_uring.c:8917
Code: e0 07 83 c0 03 38 d0 7c 04 84 d2 75 2e 83 8b 14 01 00 00 01 4c 89 e7 e8 d1 6d 25 07 5b 5d 41 5c e9 48 22 9b ff e8 43 22 9b ff <0f> 0b e9 00 ff ff ff e8 87 a1 dd ff e9 37 ff ff ff e8 4d a1 dd ff
RSP: 0018:ffffc90001c17df0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88801c409000 RCX: 0000000000000000
RDX: ffff8880287e8040 RSI: ffffffff81d7aa8d RDI: ffff88801c4090d0
RBP: ffff8880198a1780 R08: 0000000000000000 R09: 0000000012c8a801
R10: ffffffff81d7ad45 R11: 0000000000000001 R12: ffff88801c409000
R13: ffff888012c8a801 R14: ffff88801c409040 R15: ffff88801c4090d0
FS:  00007f60e950b700(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f60e950adb8 CR3: 0000000015b41000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 io_uring_flush+0x28b/0x3a0 fs/io_uring.c:9134
 filp_close+0xb4/0x170 fs/open.c:1280
 do_dup2+0x294/0x520 fs/file.c:1024
 ksys_dup3+0x22f/0x360 fs/file.c:1136
 __do_sys_dup2 fs/file.c:1162 [inline]
 __se_sys_dup2 fs/file.c:1150 [inline]
 __x64_sys_dup2+0x71/0x3a0 fs/file.c:1150
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x447019
Code: e8 0c e8 ff ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db 06 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f60e950ace8 EFLAGS: 00000246 ORIG_RAX: 0000000000000021
RAX: ffffffffffffffda RBX: 00000000006dbc38 RCX: 0000000000447019
RDX: 0000000000447019 RSI: 0000000000000003 RDI: 0000000000000005
RBP: 00000000006dbc30 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000006dbc3c
R13: 00007ffc5b18d21f R14: 00007f60e950b9c0 R15: 00000000006dbc30

