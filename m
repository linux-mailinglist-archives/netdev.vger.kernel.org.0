Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7764A7081
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 13:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245663AbiBBML3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 07:11:29 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:52750 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbiBBML0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 07:11:26 -0500
Received: by mail-il1-f197.google.com with SMTP id m3-20020a056e02158300b002b6e3d1f97cso13884616ilu.19
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 04:11:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=r1mdQGyWTemvOjpoJlyypcNoWRaGad2twbriXxSKjAE=;
        b=GBr73qOUpyX5U8YCfyrneDGwuu+cPzatnGLB/mhURp7+JrgBNo57nHdQghhsw8BFt9
         rEudABU9qdVsv/JgRBRiN/ivemMSVfuA8xD3U/a4SiX7vBVR8KWZu9Lhukbjlv4UxJcp
         ZdNGnDfV8A+OjF/8S65qJKwmyFjVd1E9pXqhD9Pg+fBFBFy1UTU2l8VFYucx7c2Z9G7Y
         93sO9Rnyct9j18PmJQCUpsvv/jR6eUbpISzna7m0juVtKw+5GyPHzsKWCCdN8ODfe/yx
         Jpgrsg1K02QXk/SMT4kby9v8KHboyW0jIdB7kCAE8J1Ra7vaaaWkKs1pcSWGoVa1KT0L
         bdrA==
X-Gm-Message-State: AOAM531Zhxtb1Mi9Va9q/Cwx42kILNkwm+1wO3b5ovNTNQ9f/8ZvtUsR
        1fpI1FiZ5afjhvMoFB5jCSpV3fgBTT6iUblk9Z0/MBM/ji2Q
X-Google-Smtp-Source: ABdhPJzuZ/5x/JPXp+PKC/4oY8hh4XkKP40OR0bMQlLRUBQ9Je4Pqg44TDuDGTEGAFTxyiu99NUMsXIikRTy6Vi2eEHJUqrwyM/z
MIME-Version: 1.0
X-Received: by 2002:a02:94e9:: with SMTP id x96mr15751317jah.80.1643803886048;
 Wed, 02 Feb 2022 04:11:26 -0800 (PST)
Date:   Wed, 02 Feb 2022 04:11:26 -0800
In-Reply-To: <0000000000000a9b7d05d6ee565f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b559f905d707ea15@google.com>
Subject: Re: [syzbot] KASAN: vmalloc-out-of-bounds Write in ringbuf_map_alloc
From:   syzbot <syzbot+5ad567a418794b9b5983@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hotforest@gmail.com,
        houtao1@huawei.com, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    6abab1b81b65 Add linux-next specific files for 20220202
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13f4b900700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b8d8750556896349
dashboard link: https://syzkaller.appspot.com/bug?extid=5ad567a418794b9b5983
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1450d9f0700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=130ef35bb00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5ad567a418794b9b5983@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: vmalloc-out-of-bounds in bpf_ringbuf_area_alloc kernel/bpf/ringbuf.c:110 [inline]
BUG: KASAN: vmalloc-out-of-bounds in bpf_ringbuf_alloc kernel/bpf/ringbuf.c:133 [inline]
BUG: KASAN: vmalloc-out-of-bounds in ringbuf_map_alloc kernel/bpf/ringbuf.c:172 [inline]
BUG: KASAN: vmalloc-out-of-bounds in ringbuf_map_alloc+0x725/0x7b0 kernel/bpf/ringbuf.c:148
Write of size 8 at addr ffffc9000c7a9078 by task syz-executor070/3595

CPU: 0 PID: 3595 Comm: syz-executor070 Not tainted 5.17.0-rc2-next-20220202-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xf/0x3e0 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 bpf_ringbuf_area_alloc kernel/bpf/ringbuf.c:110 [inline]
 bpf_ringbuf_alloc kernel/bpf/ringbuf.c:133 [inline]
 ringbuf_map_alloc kernel/bpf/ringbuf.c:172 [inline]
 ringbuf_map_alloc+0x725/0x7b0 kernel/bpf/ringbuf.c:148
 find_and_alloc_map kernel/bpf/syscall.c:128 [inline]
 map_create kernel/bpf/syscall.c:863 [inline]
 __sys_bpf+0xc0f/0x5f10 kernel/bpf/syscall.c:4622
 __do_sys_bpf kernel/bpf/syscall.c:4744 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4742 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4742
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f26ddd0a029
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff911fde88 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f26ddd0a029
RDX: 0000000000000048 RSI: 0000000020000280 RDI: 0000000000000000
RBP: 00007f26ddcce010 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007f26ddcce0a0
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>


Memory state around the buggy address:
 ffffc9000c7a8f00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
 ffffc9000c7a8f80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
>ffffc9000c7a9000: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
                                                                ^
 ffffc9000c7a9080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
 ffffc9000c7a9100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
==================================================================

