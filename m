Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70205AACC5
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 22:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388059AbfIEUIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 16:08:09 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:46122 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733128AbfIEUIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 16:08:09 -0400
Received: by mail-io1-f69.google.com with SMTP id o3so4648441iom.13
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 13:08:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Abbd0TSs66/zCB2hcq/kRDumBVAAFLe4IOeLRBtvGas=;
        b=b9edP0NpbZ24wXcLCGvm6SNlVEzHUSv1NGWZRKFET5HXTZ8iYxGSfHX1eQzSBFNZLY
         c2iF9QutMVsVhypg+cCLR1XCrdCc1e/7CSUBFdNRgTHSR88KprwtxVW/OR71QfEQw8UE
         PpaYZTFNLQtLjtVbA2A6Ud/yeoBBdPHLnm2Ae33q5XpkAkHpu24rDhjj1Ri1Z3a6u9FN
         +wJSWvFzFP7mXbdsf+W7ANtf72uxYOIfnk1ts3h+SLuDZihzGczCiKOZ8zUtdNxHFSwV
         2nACQ7QdGDD+1gLoILQPU4wwjNxGtBQA74jRbZrBMi0agHD4W/vU4gHAW4+oabIHdpBh
         reDA==
X-Gm-Message-State: APjAAAUh1OHXqbgwBFTNK/wS2AazqxNUTxNhdin73MBxsrSK49SjolG8
        HW0jnbWzE4npcCVDAJcfCL+GXR4lQgbRdHpr8jgQVEK32QDh
X-Google-Smtp-Source: APXvYqwemc/4NDS04xk5eP5U95GqM6jnkkJWflKsban4wQWb879YYrAVRiYPmeVbK5uR5ZL4Kr7i98jSqkgtPCBagdaJpO0QD/58
MIME-Version: 1.0
X-Received: by 2002:a5d:9591:: with SMTP id a17mr6266918ioo.303.1567714087830;
 Thu, 05 Sep 2019 13:08:07 -0700 (PDT)
Date:   Thu, 05 Sep 2019 13:08:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005091a70591d3e1d9@google.com>
Subject: general protection fault in dev_map_hash_update_elem
From:   syzbot <syzbot+4e7a85b1432052e8d6f8@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    6d028043 Add linux-next specific files for 20190830
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=135c1a92600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=82a6bec43ab0cb69
dashboard link: https://syzkaller.appspot.com/bug?extid=4e7a85b1432052e8d6f8
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=109124e1600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+4e7a85b1432052e8d6f8@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 10235 Comm: syz-executor.0 Not tainted 5.3.0-rc6-next-20190830  
#75
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__write_once_size include/linux/compiler.h:203 [inline]
RIP: 0010:__hlist_del include/linux/list.h:795 [inline]
RIP: 0010:hlist_del_rcu include/linux/rculist.h:475 [inline]
RIP: 0010:__dev_map_hash_update_elem kernel/bpf/devmap.c:668 [inline]
RIP: 0010:dev_map_hash_update_elem+0x3c8/0x6e0 kernel/bpf/devmap.c:691
Code: 48 89 f1 48 89 75 c8 48 c1 e9 03 80 3c 11 00 0f 85 d3 02 00 00 48 b9  
00 00 00 00 00 fc ff df 48 8b 53 10 48 89 d6 48 c1 ee 03 <80> 3c 0e 00 0f  
85 97 02 00 00 48 85 c0 48 89 02 74 38 48 89 55 b8
RSP: 0018:ffff88808d607c30 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff8880a7f14580 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880a7f14588
RBP: ffff88808d607c78 R08: 0000000000000004 R09: ffffed1011ac0f73
R10: ffffed1011ac0f72 R11: 0000000000000003 R12: ffff88809f4e9400
R13: ffff88809b06ba00 R14: 0000000000000000 R15: ffff88809f4e9528
FS:  00007f3a3d50c700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007feb3fcd0000 CR3: 00000000986b9000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  map_update_elem+0xc82/0x10b0 kernel/bpf/syscall.c:966
  __do_sys_bpf+0x8b5/0x3350 kernel/bpf/syscall.c:2854
  __se_sys_bpf kernel/bpf/syscall.c:2825 [inline]
  __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:2825
  do_syscall_64+0xfa/0x760 arch/x86/entry/common.c:290
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x459879
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f3a3d50bc78 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000459879
RDX: 0000000000000020 RSI: 0000000020000040 RDI: 0000000000000002
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f3a3d50c6d4
R13: 00000000004bfc86 R14: 00000000004d1960 R15: 00000000ffffffff
Modules linked in:
---[ end trace 083223e21dbd0ae5 ]---
RIP: 0010:__write_once_size include/linux/compiler.h:203 [inline]
RIP: 0010:__hlist_del include/linux/list.h:795 [inline]
RIP: 0010:hlist_del_rcu include/linux/rculist.h:475 [inline]
RIP: 0010:__dev_map_hash_update_elem kernel/bpf/devmap.c:668 [inline]
RIP: 0010:dev_map_hash_update_elem+0x3c8/0x6e0 kernel/bpf/devmap.c:691
Code: 48 89 f1 48 89 75 c8 48 c1 e9 03 80 3c 11 00 0f 85 d3 02 00 00 48 b9  
00 00 00 00 00 fc ff df 48 8b 53 10 48 89 d6 48 c1 ee 03 <80> 3c 0e 00 0f  
85 97 02 00 00 48 85 c0 48 89 02 74 38 48 89 55 b8
RSP: 0018:ffff88808d607c30 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff8880a7f14580 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880a7f14588
RBP: ffff88808d607c78 R08: 0000000000000004 R09: ffffed1011ac0f73
R10: ffffed1011ac0f72 R11: 0000000000000003 R12: ffff88809f4e9400
R13: ffff88809b06ba00 R14: 0000000000000000 R15: ffff88809f4e9528
FS:  00007f3a3d50c700(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007feb3fcd0000 CR3: 00000000986b9000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
