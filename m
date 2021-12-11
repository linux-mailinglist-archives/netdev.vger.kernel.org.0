Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA51447172C
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 23:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231378AbhLKWdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 17:33:18 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:40679 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbhLKWdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 17:33:18 -0500
Received: by mail-il1-f199.google.com with SMTP id u8-20020a056e021a4800b002a1ec0f08afso12825658ilv.7
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 14:33:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=1Y2mdUWLC7BX/1OzqkatbGsOQY8seTWIiVj4q5bZv2s=;
        b=fuZfzfGnL3hFGd77vEsev4X2wIUTP0kwtUC3jyHUDkvmo+A6fKSEMtJS1p94JNMP+a
         BvcALOYcVgnfhm41FaTJzU8uHEmIIesEqkgR5zST7ZbjYw8QvWC5xS3KpRL65BrvfCC0
         ULMXRChzl1Nc9EgsPxU14IEhrtIXvjSC0AnLXWGPXz2hrkinOzdjI5E+O1XFCGy690If
         qaCezMnHwAo+8/TuPxkdD74Cm9pZGwEA0/0GMbNwKk87QcbkNxZ/GMfjC66qAj2cPAm2
         b1lciRa3QgOK22WADivQP2GFAUnt/nemI4qvk2vNPWqjJx/pH+JTInop1cj61D47ULxR
         gygA==
X-Gm-Message-State: AOAM531z42AQZ4QMfuA5aUKlFs8mNxZt0loek1CI1/ioPYeyGJ+iUDBh
        3aioMPW2WhW9qnf6XYu/g6mZZndkmR8gIz0xUTphzByqVoaR
X-Google-Smtp-Source: ABdhPJytlN2yijxQnqThJ6tPiIOHzU50KmbNoIF9phwGZiRKjuq9DSj3JofbfeYAWBT5vj4g8JjMIrcn68IMP2b+HYHp6h1bI++u
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:160d:: with SMTP id t13mr24759872ilu.306.1639261997768;
 Sat, 11 Dec 2021 14:33:17 -0800 (PST)
Date:   Sat, 11 Dec 2021 14:33:17 -0800
In-Reply-To: <00000000000033acbf05d1a969aa@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000012251105d2e66d4b@google.com>
Subject: Re: [syzbot] WARNING: kmalloc bug in bpf
From:   syzbot <syzbot+cecf5b7071a0dfb76530@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    229fae38d0fc libbpf: Add "bool skipped" to struct bpf_map
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1519ce4db00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a262045c4c15a9e0
dashboard link: https://syzkaller.appspot.com/bug?extid=cecf5b7071a0dfb76530
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=119b6f3ab00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=176cf805b00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cecf5b7071a0dfb76530@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 3597 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
Modules linked in:
CPU: 1 PID: 3597 Comm: syz-executor773 Not tainted 5.15.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
Code: 01 00 00 00 4c 89 e7 e8 7d f7 0c 00 49 89 c5 e9 69 ff ff ff e8 a0 7e d0 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 8f 7e d0 ff <0f> 0b e9 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 76
RSP: 0018:ffffc900020ffc58 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 1ffff9200041ff97 RCX: 0000000000000000
RDX: ffff8880766a1d00 RSI: ffffffff81a747e1 RDI: 0000000000000003
RBP: 0000000000102cc0 R08: 000000007fffffff R09: 00000000ffffffff
R10: ffffffff81a7479e R11: 0000000000000000 R12: 00000000fffffffe
R13: 0000000000000000 R14: 00000000ffffffff R15: 0000000000000000
FS:  0000555556e04300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000140 CR3: 000000001db54000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 kvmalloc include/linux/slab.h:741 [inline]
 map_lookup_elem kernel/bpf/syscall.c:1090 [inline]
 __sys_bpf+0x3a6b/0x5f10 kernel/bpf/syscall.c:4603
 __do_sys_bpf kernel/bpf/syscall.c:4722 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4720 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4720
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f6bde27f079
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc0cb30c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f6bde27f079
RDX: 0000000000000020 RSI: 0000000020000100 RDI: 0000000000000001
RBP: 00007f6bde243060 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f6bde2430f0
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>

