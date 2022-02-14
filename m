Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E924B5A2E
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 19:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbiBNSrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 13:47:06 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiBNSrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 13:47:03 -0500
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83A86FA39
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 10:46:47 -0800 (PST)
Received: by mail-il1-f197.google.com with SMTP id q15-20020a92ca4f000000b002be3e7707ffso11934529ilo.4
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 10:46:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=kBrX8LpAo7r4bs5uM8RRIDxr43yr4Z+/JxydaN+fYS4=;
        b=rdv1Og2J6kYtXM4EdTFjPfTYb+70X6cQuBBtCOgxPG9Oa/htddXIXhqBH96jpMXUnK
         Ep9GmBG7XwYOrEOOtqo3NbMXNyVgCeeqZQwOhxRRPT+/4NgaDGqVDj1ohqajdV17ElNQ
         h7W6454JMskYpuNeOnKmFW1r92XEL825MUDA5NZLRr77pmaqWYBvKkeF95+q+aOG6Rxc
         I4XmbEKYmDIH6ey9pCp3TPcHZs4oSJe3lj3Iti/KUNs2cPzRfrxokA3u+usNwtMzggyv
         yiptQnBjgkas5qgzZX3192aZuz+ZFAWcquosYWeq6bVAIlxhag1SKl+O2DFndkNlW5YA
         czvg==
X-Gm-Message-State: AOAM530cSAexOvQxory068DaXrSv9m60sBbJR7WJmNyDrdcmtNmmYWV7
        WxRzRHDy4q9IW9Q+oEDqY63s8VHd8quFvEJ/o8U/IlFEHpbQ
X-Google-Smtp-Source: ABdhPJz1Rl3MLan548W+pOsB3r3vRveNAIcFPhANhRh3K02sEhlo88uyJ0f+f2IA5/Hlys2behM36a7IAcVAlgzYcwPcrKUyYRGu
MIME-Version: 1.0
X-Received: by 2002:a05:6638:258d:: with SMTP id s13mr161476jat.221.1644864319434;
 Mon, 14 Feb 2022 10:45:19 -0800 (PST)
Date:   Mon, 14 Feb 2022 10:45:19 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000076b4bf05d7fed1f1@google.com>
Subject: [syzbot] KASAN: vmalloc-out-of-bounds Read in __text_poke
From:   syzbot <syzbot+ecb1e7e51c52f68f7481@syzkaller.appspotmail.com>
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

HEAD commit:    e5313968c41b Merge branch 'Split bpf_sk_lookup remote_port..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=173474ac700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c40b67275bfe2a58
dashboard link: https://syzkaller.appspot.com/bug?extid=ecb1e7e51c52f68f7481
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ecb1e7e51c52f68f7481@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: vmalloc-out-of-bounds in memcmp+0x16f/0x1c0 lib/string.c:770
Read of size 8 at addr ffffffffa0013400 by task syz-executor.3/26377

CPU: 1 PID: 26377 Comm: syz-executor.3 Not tainted 5.16.0-syzkaller-11655-ge5313968c41b #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xf/0x336 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 memcmp+0x16f/0x1c0 lib/string.c:770
 memcmp include/linux/fortify-string.h:269 [inline]
 __text_poke+0x5a2/0x8c0 arch/x86/kernel/alternative.c:1056
 text_poke_copy+0x66/0xa0 arch/x86/kernel/alternative.c:1132
 bpf_arch_text_copy+0x21/0x40 arch/x86/net/bpf_jit_comp.c:2426
 bpf_jit_binary_pack_finalize+0x43/0x170 kernel/bpf/core.c:1098
 bpf_int_jit_compile+0x9d5/0x12f0 arch/x86/net/bpf_jit_comp.c:2383
 bpf_prog_select_runtime+0x4d4/0x8a0 kernel/bpf/core.c:2163
 bpf_prog_load+0xfe6/0x2250 kernel/bpf/syscall.c:2349
 __sys_bpf+0x68a/0x59a0 kernel/bpf/syscall.c:4640
 __do_sys_bpf kernel/bpf/syscall.c:4744 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4742 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4742
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f8a1c276059
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8a1abca168 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f8a1c389030 RCX: 00007f8a1c276059
RDX: 0000000000000064 RSI: 00000000202a0fb8 RDI: 0000000000000005
RBP: 00007f8a1c2d008d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe9ad17dff R14: 00007f8a1abca300 R15: 0000000000022000
 </TASK>


Memory state around the buggy address:
 ffffffffa0013300: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
 ffffffffa0013380: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>ffffffffa0013400: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
                   ^
 ffffffffa0013480: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
 ffffffffa0013500: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
