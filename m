Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7D63517F7
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 19:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbhDARnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234651AbhDARi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:38:58 -0400
Received: from mail-io1-xd46.google.com (mail-io1-xd46.google.com [IPv6:2607:f8b0:4864:20::d46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AF6C08EA74
        for <netdev@vger.kernel.org>; Thu,  1 Apr 2021 06:30:03 -0700 (PDT)
Received: by mail-io1-xd46.google.com with SMTP id w8so3980874iox.13
        for <netdev@vger.kernel.org>; Thu, 01 Apr 2021 06:30:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=V1YPBBmXV6Zf6ofFKc69jLxBo6I+75nDp0+ssUeEtEM=;
        b=W/HJpm5J7TSU66EaAedsHh9vZCUFu57vuOM9zAQ+dHcuDOPueuveEE8Cn6/8v10gtI
         phJA2F0X43NdA5TLZTJCfg3D/1zK/71dOqLZetJL3eY/sFWztTBFgHLOIqwmeIRjoFdd
         /VW5/t3J7mVQWprmN1IYi9nbaLAUrlb7en2q9rOqp+UGLDyEUJea/TLI++NA+SFwUEO5
         7zWnlRwp+s1lKNCG/igWG8Uv0IuvWki1v9UnDYfTa5oHLqheyg2YK3VN/Vp66OEU3UhW
         QZIYCo36e2dGWvPbuxUZlLWl8cCBS9OGY/DOb0vU3sRJcDSkW1Oaaqbyio3SUxsfZt60
         IhTw==
X-Gm-Message-State: AOAM530cmKBX1zHPRcxP/Si+g01LGnZNqn4h8uzLwtgK8qBbKUfBKWwa
        q4VCdBtZhNIA5hE4KXB6UfejAvImFvaOY9d1NuNd2AQOFIuH
X-Google-Smtp-Source: ABdhPJx/5tqNGXQlJ27uFdO6oc1q+y5cAbEhG+gQ0NtMiUPsSxdE1cBf9c1xnuC34oj9gnsTFZUhqBMyOMroa7wQiaswaike9eKr
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20cd:: with SMTP id 13mr6179334ilq.126.1617276559816;
 Thu, 01 Apr 2021 04:29:19 -0700 (PDT)
Date:   Thu, 01 Apr 2021 04:29:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d9fefa05bee78afd@google.com>
Subject: [syzbot] WARNING in bpf_test_run
From:   syzbot <syzbot+774c590240616eaa3423@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org,
        bp@alien8.de, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, hpa@zytor.com,
        jmattson@google.com, john.fastabend@gmail.com, joro@8bytes.org,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, masahiroy@kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, pbonzini@redhat.com, peterz@infradead.org,
        rafael.j.wysocki@intel.com, rostedt@goodmis.org, seanjc@google.com,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, vkuznets@redhat.com, wanpengli@tencent.com,
        will@kernel.org, x86@kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    36e79851 libbpf: Preserve empty DATASEC BTFs during static..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1569bb06d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7eff0f22b8563a5f
dashboard link: https://syzkaller.appspot.com/bug?extid=774c590240616eaa3423
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17556b7cd00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1772be26d00000

The issue was bisected to:

commit 997acaf6b4b59c6a9c259740312a69ea549cc684
Author: Mark Rutland <mark.rutland@arm.com>
Date:   Mon Jan 11 15:37:07 2021 +0000

    lockdep: report broken irq restoration

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10197016d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12197016d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14197016d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+774c590240616eaa3423@syzkaller.appspotmail.com
Fixes: 997acaf6b4b5 ("lockdep: report broken irq restoration")

------------[ cut here ]------------
WARNING: CPU: 0 PID: 8725 at include/linux/bpf-cgroup.h:193 bpf_cgroup_storage_set include/linux/bpf-cgroup.h:193 [inline]
WARNING: CPU: 0 PID: 8725 at include/linux/bpf-cgroup.h:193 bpf_test_run+0x65e/0xaa0 net/bpf/test_run.c:109
Modules linked in:
CPU: 0 PID: 8725 Comm: syz-executor927 Not tainted 5.12.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:bpf_cgroup_storage_set include/linux/bpf-cgroup.h:193 [inline]
RIP: 0010:bpf_test_run+0x65e/0xaa0 net/bpf/test_run.c:109
Code: e9 29 fe ff ff e8 b2 9d 3a fa 41 83 c6 01 bf 08 00 00 00 44 89 f6 e8 51 a5 3a fa 41 83 fe 08 0f 85 74 fc ff ff e8 92 9d 3a fa <0f> 0b bd f0 ff ff ff e9 5c fd ff ff e8 81 9d 3a fa 83 c5 01 bf 08
RSP: 0018:ffffc900017bfaf0 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffc90000f29000 RCX: 0000000000000000
RDX: ffff88801bc68000 RSI: ffffffff8739543e RDI: 0000000000000003
RBP: 0000000000000007 R08: 0000000000000008 R09: 0000000000000001
R10: ffffffff8739542f R11: 0000000000000000 R12: dffffc0000000000
R13: ffff888021dd54c0 R14: 0000000000000008 R15: 0000000000000000
FS:  00007f00157d7700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0015795718 CR3: 00000000157ae000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 bpf_prog_test_run_skb+0xabc/0x1c70 net/bpf/test_run.c:628
 bpf_prog_test_run kernel/bpf/syscall.c:3132 [inline]
 __do_sys_bpf+0x218b/0x4f40 kernel/bpf/syscall.c:4411
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x446199
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f00157d72f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00000000004cb440 RCX: 0000000000446199
RDX: 0000000000000028 RSI: 0000000020000080 RDI: 000000000000000a
RBP: 000000000049b074 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: f9abde7200f522cd
R13: 3952ddf3af240c07 R14: 1631e0d82d3fa99d R15: 00000000004cb448


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
