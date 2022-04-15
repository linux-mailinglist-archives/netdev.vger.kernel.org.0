Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7633150309F
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 01:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356213AbiDOV5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 17:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356193AbiDOV5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 17:57:52 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1954131DD7
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 14:55:23 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id w28-20020a05660205dc00b00645d3cdb0f7so5419630iox.10
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 14:55:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=O/xeVfd2f1I1IgGwEz7f3eVMwFcu7BEtTzoITl6hbMY=;
        b=5BO/3Df8/ZVGFBDtNtIvbuDzTpDYb3Lwdpu3k9nT9rxrZq8cNHwiLoAImYYhayKiVI
         iWVqtvJMv/PF3ETzsA9ftbp9zB1sewDeC11Z4zHobnTCYiVy9Vx99xH7880ECPvZAy4v
         YV6RPOFtJ8ACs7rGGFSgl0mocu5UuG3xRlHBVg0aQtdG/I1TiaNBU17XZ2S9WIgnaRgc
         fG+aj8jETyz2DkiJ0KpcVnsMP3iHwWe1opQRnWFSHc52uyyC74vivLg3tsynzjNRp6Nk
         lbYMykQc3PsHckrANG3M7TrQAU0Ica3VlhdxbmpaJ0PmwSMefw0ewC0Uh9uCco90F8Y7
         B+Fg==
X-Gm-Message-State: AOAM531gAHsE6Dlxgp2wp+c4Tbwi0B0tA062TB7IXQCqr3I19MSAJlqR
        uBwP91o6vvrnW0BOqazX/jQrfP2bTxgBeui1mOT6ZP/V8aEb
X-Google-Smtp-Source: ABdhPJw4Gl0ghdwhE3obk3Z+DVgDyRqoCs+sALjlpXy1jA5TwjhXCn4TNMa9OgAxEmPkW926JVtTZQ9OsFTdfWjCCPcsVRbQI1H+
MIME-Version: 1.0
X-Received: by 2002:a92:cb4f:0:b0:2cb:fde0:b5c2 with SMTP id
 f15-20020a92cb4f000000b002cbfde0b5c2mr291007ilq.274.1650059722464; Fri, 15
 Apr 2022 14:55:22 -0700 (PDT)
Date:   Fri, 15 Apr 2022 14:55:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009da4c705dcb87735@google.com>
Subject: [syzbot] WARNING in check_map_prog_compatibility
From:   syzbot <syzbot+e3f8d4df1e1981a97abb@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, trix@redhat.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ce522ba9ef7e Linux 5.18-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15c55ab7700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9ac56d6828346c4e
dashboard link: https://syzkaller.appspot.com/bug?extid=e3f8d4df1e1981a97abb
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14960370f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1412ff0f700000

Bisection is inconclusive: the issue happens on the oldest tested release.

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12ef7940f00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11ef7940f00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16ef7940f00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e3f8d4df1e1981a97abb@syzkaller.appspotmail.com

------------[ cut here ]------------
trace type BPF program uses run-time allocation
WARNING: CPU: 0 PID: 3596 at kernel/bpf/verifier.c:11998 check_map_prog_compatibility+0x76b/0x920 kernel/bpf/verifier.c:11998
Modules linked in:
CPU: 0 PID: 3596 Comm: syz-executor252 Not tainted 5.18.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:check_map_prog_compatibility+0x76b/0x920 kernel/bpf/verifier.c:11998
Code: c7 fc ff ff e8 86 4f ee ff 31 db e9 bb fc ff ff e8 7a 4f ee ff c6 05 b2 40 35 0c 01 48 c7 c7 a0 3b 74 8a 31 c0 e8 85 e4 b7 ff <0f> 0b e9 23 fb ff ff 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c c0 f8 ff
RSP: 0018:ffffc90003aaf1e8 EFLAGS: 00010246
RAX: c7d869b5def1f000 RBX: 0000000000000001 RCX: ffff88801d293a00
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffff88801f6ea030 R08: ffffffff816acc92 R09: ffffed1017384f24
R10: ffffed1017384f24 R11: 1ffff11017384f23 R12: ffff88801f6ea000
R13: dffffc0000000000 R14: ffff88807c438000 R15: 0000000000000011
FS:  00005555566d0300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056023649dd90 CR3: 0000000024387000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 resolve_pseudo_ldimm64+0x67f/0x1270 kernel/bpf/verifier.c:12171
 bpf_check+0x2606/0x13ab0 kernel/bpf/verifier.c:14462
 bpf_prog_load+0x1288/0x1b80 kernel/bpf/syscall.c:2351
 __sys_bpf+0x373/0x660 kernel/bpf/syscall.c:4663
 __do_sys_bpf kernel/bpf/syscall.c:4767 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4765 [inline]
 __x64_sys_bpf+0x78/0x90 kernel/bpf/syscall.c:4765
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x2b/0x70 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f86914c6239
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcd0a865f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f86914c6239
RDX: 0000000000000080 RSI: 00000000200004c0 RDI: 0000000000000005
RBP: 00007f869148a220 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000072 R11: 0000000000000246 R12: 00007f869148a2b0
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
