Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3964B651113
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 18:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbiLSRP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 12:15:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbiLSRPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 12:15:53 -0500
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81BEDF0
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 09:15:51 -0800 (PST)
Received: by mail-io1-f69.google.com with SMTP id o22-20020a6b5a16000000b006e2d564944aso4293563iob.7
        for <netdev@vger.kernel.org>; Mon, 19 Dec 2022 09:15:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EnRDZ1K+D0vLPUMDxkm5NljbpI20iR4Z282yrTptjjI=;
        b=5YPg7tottWPrS+o7ISJtF7RPTzuHszR2YoTdu4SwzB2/UUNXGDw/8T9v1hn1jEPy4k
         e8u8UzEbbdNMYf3KpD89SEKx0No46SKV1ApmPo8puQu7XrnXd/Un1PAu3ipNNFZtLgNT
         5amM0L4zKlMvnaqnP1SsnCSuEJLUpNsoQVVLCtsqrhkZpa7GgfD7V9GVKo8BuTVZ5lCM
         5dftrKAkiZDdoLe6X+oG9VUFCg0To0yhYSlDrcPHIE50J9FFQfbSYiFjtr2sebjKkFyV
         tXDUjqHR6EvgGWxg4KguuZN8FNM0URtw96/Am7q5PyCKT5HriftTTBGD8cqucaOsh/oV
         OgPg==
X-Gm-Message-State: ANoB5plm78VtPeWgB5WWFP28Fig8IHh3SkCJay1iv/pCGOOmsK6Lt1wq
        Hkf0jaf+Zg1HP6pfPJ8F2NHsb4gY5hbJzlgT4Tedn6zpWMCC
X-Google-Smtp-Source: AA0mqf447X5AHSCQt+3I1CIK3kwJxub5jCXsC0Oj4OzG4atqe+4fwrO3PNvReXHX7ApvbFYDCPIApNZt2KcCKLFlEzRnMf0EJORl
MIME-Version: 1.0
X-Received: by 2002:a92:d38e:0:b0:303:41c2:c798 with SMTP id
 o14-20020a92d38e000000b0030341c2c798mr15687356ilo.248.1671470151159; Mon, 19
 Dec 2022 09:15:51 -0800 (PST)
Date:   Mon, 19 Dec 2022 09:15:51 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009cd81e05f0317886@google.com>
Subject: [syzbot] WARNING in put_pmu_ctx
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

Hello,

syzbot found the following issue on:

HEAD commit:    13e3c7793e2f Merge tag 'for-netdev' of https://git.kernel...
git tree:       bpf
console output: https://syzkaller.appspot.com/x/log.txt?x=12eda6e7880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b0e91ad4b5f69c47
dashboard link: https://syzkaller.appspot.com/bug?extid=697196bc0265049822bd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=114a2127880000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/373a99daa295/disk-13e3c779.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7fa71ed0fe17/vmlinux-13e3c779.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2842ad5c698b/bzImage-13e3c779.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+697196bc0265049822bd@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 22650 at kernel/events/core.c:4920 put_pmu_ctx kernel/events/core.c:4920 [inline]
WARNING: CPU: 1 PID: 22650 at kernel/events/core.c:4920 put_pmu_ctx+0x2a5/0x390 kernel/events/core.c:4893
Modules linked in:
CPU: 1 PID: 22650 Comm: syz-executor.4 Not tainted 6.1.0-syzkaller-09661-g13e3c7793e2f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:put_pmu_ctx kernel/events/core.c:4920 [inline]
RIP: 0010:put_pmu_ctx+0x2a5/0x390 kernel/events/core.c:4893
Code: dd ff e8 2e 0f dd ff 48 8d 7b 50 48 c7 c6 a0 f8 a2 81 e8 3e c8 c7 ff eb d6 e8 17 0f dd ff 0f 0b e9 64 ff ff ff e8 0b 0f dd ff <0f> 0b eb 88 e8 c2 bc 2a 00 eb a5 e8 fb 0e dd ff 0f 0b e9 e4 fd ff
RSP: 0018:ffffc90003f47c68 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff8880b9841978 RCX: 0000000000000000
RDX: ffff88801fc6ba80 RSI: ffffffff81a3a405 RDI: 0000000000000001
RBP: ffff8880b98419a8 R08: 0000000000000001 R09: 0000000000000001
R10: ffffed1017306b78 R11: 0000000000000000 R12: ffff8880b9835c90
R13: ffff8880b9835bc0 R14: 0000000000000293 R15: ffff8880b9841980
FS:  00007f1cdf1fe700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f78cc3157e2 CR3: 000000001ccc0000 CR4: 00000000003506f0
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
RIP: 0033:0x7f1cdfe8c0d9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1cdf1fe168 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 00007f1cdffabf80 RCX: 00007f1cdfe8c0d9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
RBP: 00007f1cdfee7ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd2718bc2f R14: 00007f1cdf1fe300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
