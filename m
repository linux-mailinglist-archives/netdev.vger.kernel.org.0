Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65C54B4DF1
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 12:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350233AbiBNLPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 06:15:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350376AbiBNLPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 06:15:09 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45982EFF95
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 02:44:23 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id f9-20020a92cb49000000b002be1f9405a3so11021230ilq.16
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 02:44:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=xC1uTcb/V1rcUObJ9bOyaCJyjuXg0QqdqV18HqOOmGQ=;
        b=cOnDLGPrY8UnBpQzUZudm6Gc0yHPCidCgglKme38eYiy3elhVL3XVWJCf02YSr3zob
         dqaH1Obz36/aDKgHLqapZOEmKDhpznhwyb4iPtBPbmSGgc4cVlFnK6WTKVDr86YDBSDO
         O7+FUOfa0hcP7/NxIu48hEg7vyPUjWDf3KTLRtMrgiAHtvJS4N3cYUnpEicr+sjvzHyJ
         unTN8cyLuHPMY0fc4zhsDEn/CUlTMKNB1rT8HjR69aL2Iou8FCOFi7ir6/pXHUJDk55T
         b93me0Qzg37EEDqk4Pkt1TAiysEsPd+ZjJ/IZTVku6vIyTRI0ilHlgxESn8Gm+3Wx+Yx
         ROkA==
X-Gm-Message-State: AOAM530xeccbYuFJ8iNa95SIrI5QUTuzB8yp5sLSroSW/RyChkKzRnat
        aieOA7WyQB9bZsYb1b2Jw4sgA2/VRP1isEIloIpIjKYEupMY
X-Google-Smtp-Source: ABdhPJw81TMExX0viITBtqp8o30BhyzKVumMZymcE0yUWohMbqRd+dN1v2QslMGCc4id8ptgtmUD8uA0OsMB3Pb4KIxTIodVpwxF
MIME-Version: 1.0
X-Received: by 2002:a92:b50e:: with SMTP id f14mr7727969ile.208.1644835462594;
 Mon, 14 Feb 2022 02:44:22 -0800 (PST)
Date:   Mon, 14 Feb 2022 02:44:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007646bd05d7f81943@google.com>
Subject: [syzbot] kernel BUG in __text_poke
From:   syzbot <syzbot+87f65c75f4a72db05445@syzkaller.appspotmail.com>
To:     bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        jgross@suse.com, jpoimboe@redhat.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, netdev@vger.kernel.org, peterz@infradead.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de, x86@kernel.org
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

HEAD commit:    f95f768f0af4 bpf, x86_64: Fail gracefully on bpf_jit_binar..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13fb08c2700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c40b67275bfe2a58
dashboard link: https://syzkaller.appspot.com/bug?extid=87f65c75f4a72db05445
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+87f65c75f4a72db05445@syzkaller.appspotmail.com

------------[ cut here ]------------
kernel BUG at arch/x86/kernel/alternative.c:989!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 12993 Comm: syz-executor.1 Not tainted 5.16.0-syzkaller-11632-gf95f768f0af4 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__text_poke+0x343/0x8c0 arch/x86/kernel/alternative.c:989
Code: c3 0f 86 2c fe ff ff 49 8d bc 24 00 10 00 00 e8 43 be 88 00 48 89 44 24 28 48 85 db 74 0c 48 83 7c 24 28 00 0f 85 1b fe ff ff <0f> 0b 48 b8 00 f0 ff ff ff ff 0f 00 49 21 c0 48 85 db 0f 85 c6 02
RSP: 0018:ffffc90005e6f7a8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88807d1c8000 RSI: ffffffff81b3c443 RDI: 0000000000000003
RBP: 0000000000000080 R08: 0000000000000000 R09: ffffc90005e6f7bf
R10: ffffffff81b3c3e1 R11: 0000000000000001 R12: ffffffffa0010e00
R13: 0000000000000080 R14: 0000000000000e80 R15: 0000000000002000
FS:  00007fd60b1d8700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9329383090 CR3: 000000007c3bb000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Call Trace:
 <TASK>
 text_poke_copy+0x66/0xa0 arch/x86/kernel/alternative.c:1132
 bpf_arch_text_copy+0x21/0x40 arch/x86/net/bpf_jit_comp.c:2426
 bpf_jit_binary_pack_finalize+0x43/0x170 kernel/bpf/core.c:1094
 bpf_int_jit_compile+0x9d5/0x12f0 arch/x86/net/bpf_jit_comp.c:2383
 bpf_prog_select_runtime+0x4d4/0x8a0 kernel/bpf/core.c:2159
 bpf_prog_load+0xfe6/0x2250 kernel/bpf/syscall.c:2349
 __sys_bpf+0x68a/0x59a0 kernel/bpf/syscall.c:4640
 __do_sys_bpf kernel/bpf/syscall.c:4744 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4742 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4742
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fd60c863059
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd60b1d8168 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007fd60c975f60 RCX: 00007fd60c863059
RDX: 0000000000000048 RSI: 0000000020000200 RDI: 0000000000000005
RBP: 00007fd60c8bd08d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffec77d82ef R14: 00007fd60b1d8300 R15: 0000000000022000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__text_poke+0x343/0x8c0 arch/x86/kernel/alternative.c:989
Code: c3 0f 86 2c fe ff ff 49 8d bc 24 00 10 00 00 e8 43 be 88 00 48 89 44 24 28 48 85 db 74 0c 48 83 7c 24 28 00 0f 85 1b fe ff ff <0f> 0b 48 b8 00 f0 ff ff ff ff 0f 00 49 21 c0 48 85 db 0f 85 c6 02
RSP: 0018:ffffc90005e6f7a8 EFLAGS: 00010246

RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88807d1c8000 RSI: ffffffff81b3c443 RDI: 0000000000000003
RBP: 0000000000000080 R08: 0000000000000000 R09: ffffc90005e6f7bf
R10: ffffffff81b3c3e1 R11: 0000000000000001 R12: ffffffffa0010e00


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
