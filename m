Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD0866303A
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 20:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbjAITYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 14:24:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbjAITYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 14:24:45 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE22C6CFE3
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 11:24:43 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id g11-20020a056e021a2b00b0030da3e7916fso3149059ile.18
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 11:24:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4G+nn586MoMOEdXui/K9NuTcQCpvCpCfnjgOACJsTcE=;
        b=nL9saLXWl5ThmbNGE6Dy/OL7WEA2WlMT9Ahwsb7SD8cQYNhALxkJzEtCqcven+s10I
         zIIFEfzkgDGUg8gH7rjL4bgBGFfoR67RYC6sL0fcbEgZZgWiTRCpmCBjtQi7h8hOwjBu
         w5ryt1Vtsd0OfYh4RkYH7WCTp7N02ArEvxUpzYO2VMX1qFqjX38QJaB4FcjXUpaQZeU7
         PlgVy5SmoZRzy3iJIRShpYcOJafsHdC7v3ij7D5PUUu0PSDOnSDub9W+abhKclJt9h2u
         4mSYws0zimWTttmyTDNbhDKoBZmBc09mTcvt4oyiTSAnYJQ5hLP4IW8LYaYVk3ZyJx0X
         WRNw==
X-Gm-Message-State: AFqh2kpAzSRHTFai1NwQQZfWyALBZVJ+AOuDS9Fre46Y2HS0AS7u1tAf
        zcUo9l+3xorPZgqD5BqEygu5zckaSK3Q8n+jZcgxk9wlMtcP
X-Google-Smtp-Source: AMrXdXvgIJAgqDKdneS9KofPg1uBFo3yxVFySdycwir++YgWUuPGfGIlIT21gY09Mn+fYQPzP2a0w7Y0I7c/rxMyjNqTiJesdJX1
MIME-Version: 1.0
X-Received: by 2002:a92:b70e:0:b0:303:7637:ff67 with SMTP id
 k14-20020a92b70e000000b003037637ff67mr8299849ili.298.1673292283169; Mon, 09
 Jan 2023 11:24:43 -0800 (PST)
Date:   Mon, 09 Jan 2023 11:24:43 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000024d6fc05f1d9b858@google.com>
Subject: [syzbot] kernel BUG in rxrpc_put_call
From:   syzbot <syzbot+4bb6356bb29d6299360e@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dhowells@redhat.com, edumazet@google.com,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org, marc.dionne@auristor.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
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

HEAD commit:    60ea6f00c57d net: ipa: correct IPA v4.7 IMEM offset
git tree:       net
console+strace: https://syzkaller.appspot.com/x/log.txt?x=160bb222480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=46221e8203c7aca6
dashboard link: https://syzkaller.appspot.com/bug?extid=4bb6356bb29d6299360e
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=141826f6480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15a8642c480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/2b709f657c2d/disk-60ea6f00.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c5daf24c2f8f/vmlinux-60ea6f00.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0af656112648/bzImage-60ea6f00.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4bb6356bb29d6299360e@syzkaller.appspotmail.com

rxrpc: Assertion failed - 1(0x1) == 11(0xb) is false
------------[ cut here ]------------
kernel BUG at net/rxrpc/call_object.c:645!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 5073 Comm: syz-executor233 Not tainted 6.2.0-rc2-syzkaller-00227-g60ea6f00c57d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:rxrpc_put_call.cold+0x3c/0x3e net/rxrpc/call_object.c:645
Code: 0b e8 82 51 7e f7 89 de 41 b9 0b 00 00 00 41 b8 0b 00 00 00 48 c7 c1 20 45 76 8b 48 89 f2 48 c7 c7 60 45 76 8b e8 35 06 bd ff <0f> 0b e8 57 51 7e f7 48 c7 c7 80 4f 76 8b e8 22 06 bd ff 0f 0b e8
RSP: 0018:ffffc90003c4f9e8 EFLAGS: 00010282
RAX: 0000000000000034 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff8880209657c0 RSI: ffffffff8166721c RDI: fffff52000789f2f
RBP: ffff8880760576c0 R08: 0000000000000034 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: 0000000000000012
R13: 0000000000000026 R14: ffff888076057a10 R15: ffff888027b18000
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2cf9db1840 CR3: 000000002b803000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 rxrpc_release_calls_on_socket+0x217/0x2f0 net/rxrpc/call_object.c:624
 rxrpc_release_sock net/rxrpc/af_rxrpc.c:886 [inline]
 rxrpc_release+0x1ca/0x560 net/rxrpc/af_rxrpc.c:917
 __sock_release+0xcd/0x280 net/socket.c:650
 sock_close+0x1c/0x20 net/socket.c:1365
 __fput+0x27c/0xa90 fs/file_table.c:320
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xaa8/0x2950 kernel/exit.c:867
 do_group_exit+0xd4/0x2a0 kernel/exit.c:1012
 get_signal+0x21c3/0x2450 kernel/signal.c:2859
 arch_do_signal_or_restart+0x79/0x5c0 arch/x86/kernel/signal.c:306
 exit_to_user_mode_loop kernel/entry/common.c:168 [inline]
 exit_to_user_mode_prepare+0x15f/0x250 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f2cf9d57149
Code: Unable to access opcode bytes at 0x7f2cf9d5711f.
RSP: 002b:00007ffc2b195818 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: fffffffffffffe00 RBX: 0000000000000002 RCX: 00007f2cf9d57149
RDX: 0000000000000000 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 00007ffc2b195830 R08: 0000000000000002 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000004
R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:rxrpc_put_call.cold+0x3c/0x3e net/rxrpc/call_object.c:645
Code: 0b e8 82 51 7e f7 89 de 41 b9 0b 00 00 00 41 b8 0b 00 00 00 48 c7 c1 20 45 76 8b 48 89 f2 48 c7 c7 60 45 76 8b e8 35 06 bd ff <0f> 0b e8 57 51 7e f7 48 c7 c7 80 4f 76 8b e8 22 06 bd ff 0f 0b e8
RSP: 0018:ffffc90003c4f9e8 EFLAGS: 00010282
RAX: 0000000000000034 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff8880209657c0 RSI: ffffffff8166721c RDI: fffff52000789f2f
RBP: ffff8880760576c0 R08: 0000000000000034 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: 0000000000000012
R13: 0000000000000026 R14: ffff888076057a10 R15: ffff888027b18000
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2cf9db1840 CR3: 000000002b803000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
