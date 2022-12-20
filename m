Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8B4651AAE
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 07:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbiLTG3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 01:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233041AbiLTG3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 01:29:37 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71F413E91
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 22:29:35 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id n15-20020a056e021baf00b0030387c2e1d3so7847069ili.5
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 22:29:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o3D3DVXMHPRZMw4JnqlJzmNdsdslprlXsngCLe/eDrQ=;
        b=yD3xK5Xt8DWNXdQoyiHM2hEaj1B+IO++epiUjy2+eaCFGQmCy6WtAA/WpxUmW9gJ/a
         fQVyV1o6FgHX8C31xGD9sa+ndT4AbZ1PJpwDgRqx/eko+zNXk7gFEF4E8CRgEXNbNdiF
         grsufG7aQGwwxPGhzI1Kv6ZWJqI0FPISgs7ZrwVSS6qpEee/3P0PEhgV32GCHGuYwVLU
         D1HGvK7MWXX9prMoKUUlYskCscqtnLVSBOwiuOgXC8Bj4m/+z+rhwoxFPFtIqzXbJW1K
         Gv4I1tWgaVrOo/GoVcbCS2k8p/TmMCsj9D6BqefsOKTh5IPqf3Jua5WOKLXSNQo09QWL
         VOfA==
X-Gm-Message-State: ANoB5pkEiNTWsu6vrWtc9zEXhmnQ8YFDVFEK2gIPfsELqPCsQzFGMB8c
        wOQ2ZgQW7QVA3w0y3ef+qxIJF5+0zTNsWVl3Pyqid1z90POW
X-Google-Smtp-Source: AA0mqf4gJfZqTzq0sMbhF2tqDJwhr9gZUhXc/ZFtLREFC1hmReBYf7sJnzIGqOIpg2hD8p/iT2X6qpElt2N8kkUBnJxgEmo8VR/Y
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d84:b0:302:ce48:40ee with SMTP id
 h4-20020a056e021d8400b00302ce4840eemr35190973ila.157.1671517775125; Mon, 19
 Dec 2022 22:29:35 -0800 (PST)
Date:   Mon, 19 Dec 2022 22:29:35 -0800
In-Reply-To: <0000000000009cd81e05f0317886@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000038e58605f03c8fad@google.com>
Subject: Re: [syzbot] WARNING in put_pmu_ctx
From:   syzbot <syzbot+697196bc0265049822bd@syzkaller.appspotmail.com>
To:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        bpf@vger.kernel.org, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        mark.rutland@arm.com, mingo@redhat.com, namhyung@kernel.org,
        netdev@vger.kernel.org, peterz@infradead.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    e2bb9e01d589 bpf: Remove trace_printk_lock
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=124cf480480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b0e91ad4b5f69c47
dashboard link: https://syzkaller.appspot.com/bug?extid=697196bc0265049822bd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=163fde6f880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17319890480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/cee993a7fed1/disk-e2bb9e01.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/109057856bce/vmlinux-e2bb9e01.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7da529d16ff7/bzImage-e2bb9e01.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+697196bc0265049822bd@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 5367 at kernel/events/core.c:4920 put_pmu_ctx kernel/events/core.c:4920 [inline]
WARNING: CPU: 0 PID: 5367 at kernel/events/core.c:4920 put_pmu_ctx+0x2a5/0x390 kernel/events/core.c:4893
Modules linked in:
CPU: 0 PID: 5367 Comm: syz-executor374 Not tainted 6.1.0-syzkaller-09637-ge2bb9e01d589 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:put_pmu_ctx kernel/events/core.c:4920 [inline]
RIP: 0010:put_pmu_ctx+0x2a5/0x390 kernel/events/core.c:4893
Code: dd ff e8 2e 0d dd ff 48 8d 7b 50 48 c7 c6 a0 fa a2 81 e8 3e c6 c7 ff eb d6 e8 17 0d dd ff 0f 0b e9 64 ff ff ff e8 0b 0d dd ff <0f> 0b eb 88 e8 c2 bc 2a 00 eb a5 e8 fb 0c dd ff 0f 0b e9 e4 fd ff
RSP: 0018:ffffc90003e2fc68 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff8880b9842328 RCX: 0000000000000000
RDX: ffff88802ad5ba80 RSI: ffffffff81a3a605 RDI: 0000000000000001
RBP: ffff8880b9842358 R08: 0000000000000001 R09: 0000000000000001
R10: ffffed1017306cf8 R11: 0000000000000000 R12: ffff8880b9836890
R13: ffff8880b98367c0 R14: 0000000000000293 R15: ffff8880b9842330
FS:  0000555557481300(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f31c999e758 CR3: 0000000020f5e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 _free_event+0x3c5/0x13d0 kernel/events/core.c:5196
 put_event kernel/events/core.c:5283 [inline]
 perf_event_release_kernel+0x6ad/0x8f0 kernel/events/core.c:5395
 perf_release+0x37/0x50 kernel/events/core.c:5405
 __fput+0x27c/0xa90 fs/file_table.c:320
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f31c9963019
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 a1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff1d0f25c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 00000000000f4240 RCX: 00007f31c9963019
RDX: 00007f31c9963019 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000000000000140 R09: 0000000000000140
R10: 0000000000000008 R11: 0000000000000246 R12: 00007fff1d0f25e0
R13: 00007fff1d0f2600 R14: 0000000000025861 R15: 00007fff1d0f25dc
 </TASK>

