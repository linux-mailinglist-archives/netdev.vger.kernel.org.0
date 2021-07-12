Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5A43C6077
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 18:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbhGLQ3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 12:29:19 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:45878 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233409AbhGLQ3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 12:29:18 -0400
Received: by mail-il1-f197.google.com with SMTP id s18-20020a92cbd20000b02901bb78581beaso12395482ilq.12
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 09:26:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=4WmLl9sar0KG32KTwYBrvHvudDAjKtCa0YXSnCWoUEs=;
        b=ZBc06nR853fQ1XnnAiFpv0uJfCnu0lhtWRowLJUNsZD3WGa4CF7RqyOEXOK8Z9edaQ
         mRjrCucKgFCtFuzCp7t/01WAmhxD/gqGazC4LE+n3FtJmhjPLAPSAUxQ7leox2y7wYQN
         ekX3REbpF2mXJOKHi+Of09J3jON7U5/YH4gjmW1/Gun0AbDxjBQGEBD0MyFlwQT8k5Cl
         llftkA9bwnD0CYp1I0QBKagrCUcP3pfMlT7K4oUTHgX38oxdZXADLwA3lS4KtUp6WflN
         wTUvMIRS3GLvBqmdAW6R6qgnJmU6aj9PR+kBCwe4qJ3fJWcm2wH9OvlUe2NuPhgL1EdV
         CN8A==
X-Gm-Message-State: AOAM532JTaQjWQ3ZmMMqOPvENwWEyYgyMjARLy6CmaPJNj9zUbkRAUJw
        b+AM+/oz5xUwvropAr+SXDQSA1r0wKUoINBAcNYgk0SIOAdF
X-Google-Smtp-Source: ABdhPJz2oWohMp9ubXhpP3+Y6V4BHQVDp8755cx8hJGgi9jtaRUyQwlAQpRkC5/qYUOeZeShvMshMC+OQLvfQc8trb6EV53NUax7
MIME-Version: 1.0
X-Received: by 2002:a92:bf0b:: with SMTP id z11mr40068923ilh.60.1626107189971;
 Mon, 12 Jul 2021 09:26:29 -0700 (PDT)
Date:   Mon, 12 Jul 2021 09:26:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006cd48405c6ef954b@google.com>
Subject: [syzbot] general protection fault in bpf_lru_pop_free
From:   syzbot <syzbot+529a4d631f26ba0e43b5@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, john.fastabend@gmail.com, kafai@fb.com,
        kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a080cdcc Merge branch 'bpf: support input xdp_md context i..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13ba01e2300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4cb84363d46e9fc3
dashboard link: https://syzkaller.appspot.com/bug?extid=529a4d631f26ba0e43b5

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+529a4d631f26ba0e43b5@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 PID: 3913 Comm: syz-executor.1 Tainted: G        W         5.13.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__list_add_valid+0x22/0xa0 lib/list_debug.c:23
Code: cd cc cc cc cc cc cc cc 48 b8 00 00 00 00 00 fc ff df 41 54 49 89 d4 55 48 89 fd 48 8d 7a 08 48 83 ec 08 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 50 49 8b 54 24 08 48 39 f2 0f 85 ae 1c 16 05 48 b8
RSP: 0018:ffffc90001cdfa50 EFLAGS: 00010002
RAX: dffffc0000000000 RBX: ffff88802bd14cd8 RCX: ffffc9001831b000
RDX: 0000000000000001 RSI: ffffe8ffffc69280 RDI: 0000000000000008
RBP: ffff88802bd14cc0 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff818adf47 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff88802951381c R15: ffff88802bd14cc0
FS:  00007f52cf552700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000308de000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Call Trace:
 __list_add include/linux/list.h:67 [inline]
 list_add include/linux/list.h:86 [inline]
 __local_list_add_pending kernel/bpf/bpf_lru_list.c:357 [inline]
 bpf_common_lru_pop_free kernel/bpf/bpf_lru_list.c:452 [inline]
 bpf_lru_pop_free+0x588/0x16d0 kernel/bpf/bpf_lru_list.c:499
 prealloc_lru_pop+0x26/0x90 kernel/bpf/hashtab.c:264
 htab_lru_map_update_elem+0x157/0x7b0 kernel/bpf/hashtab.c:1102
 bpf_map_update_value.isra.0+0x6df/0x8d0 kernel/bpf/syscall.c:206
 generic_map_update_batch+0x3cf/0x560 kernel/bpf/syscall.c:1371
 bpf_map_do_batch+0x3d5/0x510 kernel/bpf/syscall.c:4076
 __sys_bpf+0x1da7/0x5390 kernel/bpf/syscall.c:4533
 __do_sys_bpf kernel/bpf/syscall.c:4573 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4571 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4571
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4665d9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f52cf552188 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 000000000056c038 RCX: 00000000004665d9
RDX: 0000000000000038 RSI: 0000000020000200 RDI: 000000000000001a
RBP: 00000000004bfcb9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056c038
R13: 00007ffe08b5b5ef R14: 00007f52cf552300 R15: 0000000000022000
Modules linked in:
---[ end trace c58f4ed9330ab605 ]---
RIP: 0010:__list_add_valid+0x22/0xa0 lib/list_debug.c:23
Code: cd cc cc cc cc cc cc cc 48 b8 00 00 00 00 00 fc ff df 41 54 49 89 d4 55 48 89 fd 48 8d 7a 08 48 83 ec 08 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 50 49 8b 54 24 08 48 39 f2 0f 85 ae 1c 16 05 48 b8
RSP: 0018:ffffc90001cdfa50 EFLAGS: 00010002
RAX: dffffc0000000000 RBX: ffff88802bd14cd8 RCX: ffffc9001831b000
RDX: 0000000000000001 RSI: ffffe8ffffc69280 RDI: 0000000000000008
RBP: ffff88802bd14cc0 R08: 0000000000000001 R09: 0000000000000001
R10: ffffffff818adf47 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: ffff88802951381c R15: ffff88802bd14cc0
FS:  00007f52cf552700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000308de000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
