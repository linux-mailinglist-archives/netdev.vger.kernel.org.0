Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64D7E6B294
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 01:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388722AbfGPX6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 19:58:07 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:44890 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729003AbfGPX6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 19:58:07 -0400
Received: by mail-io1-f70.google.com with SMTP id s9so25146681iob.11
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 16:58:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=04Wvxtoj12TF+6z0qf7a2JYPiNoTFIelyWa5q9OcB9o=;
        b=syQ+Nm6P/yhrBSo+iXohBf6S0pu0jHRIvHEZf7bELuyVXczPzTajP0z/J5aMc19Isq
         wUggufyQdigkA6NFoebQ09/b9KaTxp2mzdOJf/e/tJ/5LKfbv626NXFkd6WI0REDCphK
         OfDHqAqlyYZTeelKRLhBwShPBgGEQUC3c18ADUBdKdy1XuDHe6h9qZ6mX5bbUwj5L9YK
         bMq6WW2uF4+bS+SUVK8Wr+aOojB2FQLkZfRm/RtopABmdRZTKWBFxl+N0zTsT8weKgDF
         NLBJg9gNEEnWCgKAXbrmWDL/0V9ww89w6O/Y+IwJmpldHUDGgjlzOt46nzbjO4BFBvsS
         9ywQ==
X-Gm-Message-State: APjAAAX+ivaUkCjxA28VniYzzZ8KKy4mcmYjN6PFCkx2fJUYv2QVnFM7
        M0ijqu34pY8pqgDD3BsIf4kISzIMTsGJFoOlUviZ4QKn9Amt
X-Google-Smtp-Source: APXvYqw6MgjkP1Q8lzpCier7Y6bbnZmvhg7ZXpdamqk8o0lRzBL5g64lhJuw4rb4lHslSmi5QKmbMocp+2fQuPy7mw0MK4ok9G8w
MIME-Version: 1.0
X-Received: by 2002:a5d:9957:: with SMTP id v23mr32648760ios.117.1563321486085;
 Tue, 16 Jul 2019 16:58:06 -0700 (PDT)
Date:   Tue, 16 Jul 2019 16:58:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d917f4058dd525cf@google.com>
Subject: general protection fault in tls_setsockopt
From:   syzbot <syzbot+23d9570edec63669d890@syzkaller.appspotmail.com>
To:     ast@kernel.org, aviadye@mellanox.com,
        bhole_prashant_q7@lab.ntt.co.jp, borisp@mellanox.com,
        daniel@iogearbox.net, davejwatson@fb.com, davem@davemloft.net,
        john.fastabend@gmail.com, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        shuah@kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    a131c2bf Merge tag 'acpi-5.3-rc1-2' of git://git.kernel.or..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1603e9c0600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8bff73c5ba9e876
dashboard link: https://syzkaller.appspot.com/bug?extid=23d9570edec63669d890
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13560870600000

The bug was bisected to:

commit 7c85c448e7d74c4ddd759440a2141eab663567cf
Author: Prashant Bhole <bhole_prashant_q7@lab.ntt.co.jp>
Date:   Tue Oct 9 01:04:54 2018 +0000

     selftests/bpf: test_verifier, check bpf_map_lookup_elem access in bpf  
prog

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17000114600000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=14800114600000
console output: https://syzkaller.appspot.com/x/log.txt?x=10800114600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+23d9570edec63669d890@syzkaller.appspotmail.com
Fixes: 7c85c448e7d7 ("selftests/bpf: test_verifier, check  
bpf_map_lookup_elem access in bpf prog")

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9098 Comm: syz-executor.2 Not tainted 5.2.0+ #65
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:tls_setsockopt+0x87/0x8c0 net/tls/tls_main.c:592
Code: 80 3c 02 00 0f 85 a5 07 00 00 49 8b 84 24 b0 06 00 00 48 ba 00 00 00  
00 00 fc ff df 48 8d b8 88 00 00 00 48 89 f9 48 c1 e9 03 <80> 3c 11 00 0f  
85 85 07 00 00 41 89 d8 4c 89 f1 44 89 ea 44 89 fe
RSP: 0018:ffff88809b2e7d30 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000000011
RDX: dffffc0000000000 RSI: ffffffff86186a84 RDI: 0000000000000088
RBP: ffff88809b2e7d80 R08: ffff888098896480 R09: ffff888098896d08
R10: ffffed1015d06c83 R11: ffff8880ae83641b R12: ffff888099d86d00
R13: 000000000000001f R14: 0000000020000340 R15: 0000000000000006
FS:  00007f29b1f6b700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffb5492d518 CR3: 00000000a49ea000 CR4: 00000000001406f0
Call Trace:
  sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3130
  __sys_setsockopt+0x253/0x4b0 net/socket.c:2080
  __do_sys_setsockopt net/socket.c:2096 [inline]
  __se_sys_setsockopt net/socket.c:2093 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2093
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459819
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f29b1f6ac78 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 0000000000459819
RDX: 000000000000001f RSI: 0000000000000006 RDI: 0000000000000005
RBP: 000000000075bf20 R08: 0000000000000004 R09: 0000000000000000
R10: 0000000020000340 R11: 0000000000000246 R12: 00007f29b1f6b6d4
R13: 00000000004c7cb9 R14: 00000000004dd878 R15: 00000000ffffffff
Modules linked in:
---[ end trace 1e30f09ab6b57d8c ]---
RIP: 0010:tls_setsockopt+0x87/0x8c0 net/tls/tls_main.c:592
Code: 80 3c 02 00 0f 85 a5 07 00 00 49 8b 84 24 b0 06 00 00 48 ba 00 00 00  
00 00 fc ff df 48 8d b8 88 00 00 00 48 89 f9 48 c1 e9 03 <80> 3c 11 00 0f  
85 85 07 00 00 41 89 d8 4c 89 f1 44 89 ea 44 89 fe
RSP: 0018:ffff88809b2e7d30 EFLAGS: 00010206
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 0000000000000011
RDX: dffffc0000000000 RSI: ffffffff86186a84 RDI: 0000000000000088
RBP: ffff88809b2e7d80 R08: ffff888098896480 R09: ffff888098896d08
R10: ffffed1015d06c83 R11: ffff8880ae83641b R12: ffff888099d86d00
R13: 000000000000001f R14: 0000000020000340 R15: 0000000000000006
FS:  00007f29b1f6b700(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000007126b4 CR3: 00000000a49ea000 CR4: 00000000001406f0


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
