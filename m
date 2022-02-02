Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6A04A7B8C
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 00:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbiBBXMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 18:12:21 -0500
Received: from mail-il1-f200.google.com ([209.85.166.200]:35834 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbiBBXMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 18:12:21 -0500
Received: by mail-il1-f200.google.com with SMTP id h8-20020a056e021b8800b002ba614f7c5dso556110ili.2
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 15:12:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=htmVlWGuHKKb3tjIfvhIeE41rcc33nqlNcOJ/WR1NFg=;
        b=BDp9jk3IeGKeYj2uQtVIP8t9lS/s2AJV7s+sqIhLinL/LF4DOZTsa25xdP3KPR0VTt
         DEGxFG/CBYlWMy3bo2mSAXdPg9uyZfFX1ZnqiF0/0F3j3SrLRlD2k4BVOpOddWjP7C3D
         8+viHSsThL8BxHlvXxyk7e18hICkM+eND8rkWNUs0YjVu0AOOwr9p2claZ2zS7NGT0V2
         E4SWZiSRN9BdI08jirJ3QERzIuXos033xdtoMJgmSzL7qk3hpqVw4Va8W+JYB6+/4UqR
         UASyzUzMP9IeCvmb3+5dlAczZ/PeTxHekIr3uK1NZeOMkEWmfZd40DlurfqmT7aJkZeF
         1Chg==
X-Gm-Message-State: AOAM531uZ8kOHlmUG8kx9/+doXLFUN79djTAKqUZz1CrxIQn0bgNtOec
        tp6TcRPdnm5MU2AGDUQWG7jaUGpPvqiRoQS4WSETqmyMUjYG
X-Google-Smtp-Source: ABdhPJwfLeBxifdPwKYe9fuxoJzEo+ppyRuD/M/W85+SkRlpjuuPSlnJBOjJ4+VpsKr+HEvsxw1SN6i8HmPmbinpLwQ5GEtxpIJv
MIME-Version: 1.0
X-Received: by 2002:a02:70c3:: with SMTP id f186mr17553128jac.155.1643843539556;
 Wed, 02 Feb 2022 15:12:19 -0800 (PST)
Date:   Wed, 02 Feb 2022 15:12:19 -0800
In-Reply-To: <00000000000061d7eb05d7057144@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003de3e105d7112674@google.com>
Subject: Re: [syzbot] WARNING in bpf_prog_test_run_xdp
From:   syzbot <syzbot+79fd1ab62b382be6f337@syzkaller.appspotmail.com>
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

HEAD commit:    dd5152ab338c Merge branch 'bpf-btf-dwarf5'
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=138d300c700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b210f94c3ec14b22
dashboard link: https://syzkaller.appspot.com/bug?extid=79fd1ab62b382be6f337
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17d37f00700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14745624700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+79fd1ab62b382be6f337@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 3596 at include/linux/thread_info.h:230 check_copy_size include/linux/thread_info.h:230 [inline]
WARNING: CPU: 1 PID: 3596 at include/linux/thread_info.h:230 copy_from_user include/linux/uaccess.h:191 [inline]
WARNING: CPU: 1 PID: 3596 at include/linux/thread_info.h:230 bpf_prog_test_run_xdp+0xec7/0x1150 net/bpf/test_run.c:978
Modules linked in:
CPU: 1 PID: 3596 Comm: syz-executor589 Not tainted 5.16.0-syzkaller-11587-gdd5152ab338c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:check_copy_size include/linux/thread_info.h:230 [inline]
RIP: 0010:copy_from_user include/linux/uaccess.h:191 [inline]
RIP: 0010:bpf_prog_test_run_xdp+0xec7/0x1150 net/bpf/test_run.c:978
Code: fd 06 48 c1 e5 0c 48 01 c5 e8 b5 71 0d fa 49 81 fe ff ff ff 7f 0f 86 08 fe ff ff 4c 8b 74 24 60 4c 8b 7c 24 68 e8 09 6f 0d fa <0f> 0b 41 bc f2 ff ff ff e9 02 fb ff ff 4c 8b 74 24 60 4c 8b 7c 24
RSP: 0018:ffffc90002acfb40 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 00000000fffff0de RCX: 0000000000000000
RDX: ffff88801ad5ba00 RSI: ffffffff876ae697 RDI: 0000000000000003
RBP: ffff88801e32b000 R08: 000000007fffffff R09: ffffffff8d9399d7
R10: ffffffff876ae67b R11: 000000000000001f R12: 0000000000000dc0
R13: ffff888019342000 R14: 0000000000000000 R15: ffffc90000d6e000
FS:  00005555560c8300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000280 CR3: 000000001df60000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bpf_prog_test_run kernel/bpf/syscall.c:3356 [inline]
 __sys_bpf+0x1858/0x59a0 kernel/bpf/syscall.c:4658
 __do_sys_bpf kernel/bpf/syscall.c:4744 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4742 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4742
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fd2338db1d9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd14e00248 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd2338db1d9
RDX: 0000000000000048 RSI: 00000000200013c0 RDI: 000000000000000a
RBP: 00007fd23389f1c0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fd23389f250
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>

