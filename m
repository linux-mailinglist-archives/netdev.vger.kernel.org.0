Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E30652DBC
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 09:15:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbiLUIPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 03:15:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234564AbiLUIOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 03:14:44 -0500
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C3C21811
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 00:14:42 -0800 (PST)
Received: by mail-il1-f200.google.com with SMTP id g3-20020a056e021a2300b00305e3da9585so9727668ile.16
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 00:14:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tgg/Ot3Hv4241+BBELpgcMRtBbmB5MmgGdiwIdzA4mo=;
        b=mBgsb524c5Xbfr2r8q+axqR1n2aA0NI3OjWC4e8D7GKgWIH7MqgSSYX106x/emUrG1
         DVMJ3dDQRhdf8pZK1AkXahRaCWYBnQ5qPZvzcUCJndneuJtVlPvNeMuYXRU7kKbdHg0I
         kalMarKgeHXwS5CBol2k4Eq1jnkBQb5SVsQcqt20EJNNwBMvqXsZ/GeUc4zTRZe1nUyL
         rO5wR7LgqwRtYaq40i7L12Ok8MVdJWbhLRY2qngiT3c1L8FaKmtKQjDYLY7v2CLH4KPV
         7nJY0owOIC2DvtF6lcv6cuIr97oo9c/tMkUs2NtWXK2A7B6+oEBkJRdIyyXeQglA8vKP
         qj1Q==
X-Gm-Message-State: AFqh2kqiVizfWFBqjAg8ftEK032NsLptT5aI0lejfBHyBY/HiPQ8DK5r
        U1tKh7G92TSTJ6My36e6X8X75Rz5+VGz56YnCgesyZuhVdmz
X-Google-Smtp-Source: AMrXdXtfaEJX9GUKY3cc3lEmOhh6LJ/8tyrlHh3bvqe1VCrYfOK9+gUr9yrhnJW2fVhB4Zz6kua6Aa357E22gbzpvuHoW2DuuK95
MIME-Version: 1.0
X-Received: by 2002:a05:6638:191d:b0:38a:741a:501b with SMTP id
 p29-20020a056638191d00b0038a741a501bmr54268jal.114.1671610481618; Wed, 21 Dec
 2022 00:14:41 -0800 (PST)
Date:   Wed, 21 Dec 2022 00:14:41 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f5b4ab05f0522438@google.com>
Subject: [syzbot] BUG: corrupted list in nfc_llcp_register_device
From:   syzbot <syzbot+c1d0a03d305972dbbe14@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dvyukov@google.com, edumazet@google.com,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org, linma@zju.edu.cn,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
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

HEAD commit:    6feb57c2fd7c Merge tag 'kbuild-v6.2' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14dd1bbf880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d3fb546de56fbf8d
dashboard link: https://syzkaller.appspot.com/bug?extid=c1d0a03d305972dbbe14
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15fbcbd0480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/81556e491789/disk-6feb57c2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/065c943ec9de/vmlinux-6feb57c2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/66e98c522c1f/bzImage-6feb57c2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c1d0a03d305972dbbe14@syzkaller.appspotmail.com

list_add corruption. next->prev should be prev (ffffffff8e7c1b40), but was 054e024500005c15. (next=ffff8880286ef000).
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:29!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 23580 Comm: syz-executor.3 Not tainted 6.1.0-syzkaller-13822-g6feb57c2fd7c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:__list_add_valid+0xdd/0x100 lib/list_debug.c:27
Code: b9 45 6b 06 0f 0b 48 c7 c7 20 c2 4b 8b 31 c0 e8 a9 45 6b 06 0f 0b 48 c7 c7 80 c2 4b 8b 4c 89 e6 4c 89 f1 31 c0 e8 93 45 6b 06 <0f> 0b 48 c7 c7 00 c3 4b 8b 4c 89 f6 4c 89 e1 31 c0 e8 7d 45 6b 06
RSP: 0018:ffffc9000bb8f560 EFLAGS: 00010246
RAX: 0000000000000075 RBX: ffff8880286ef008 RCX: 7255f226623a9300
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: 1ffff110056b8600 R08: ffffffff816f2c9d R09: fffff52001771e65
R10: fffff52001771e65 R11: 1ffff92001771e64 R12: ffffffff8e7c1b40
R13: dffffc0000000000 R14: ffff8880286ef000 R15: ffff88802b5c3000
FS:  00007fa56cb80700(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9560bfe718 CR3: 0000000078b31000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __list_add include/linux/list.h:69 [inline]
 list_add include/linux/list.h:88 [inline]
 nfc_llcp_register_device+0x6c4/0x800 net/nfc/llcp_core.c:1603
 nfc_register_device+0x68/0x320 net/nfc/core.c:1124
 nci_register_device+0x7b5/0x8f0 net/nfc/nci/core.c:1257
 virtual_ncidev_open+0x138/0x1b0 drivers/nfc/virtual_ncidev.c:148
 misc_open+0x346/0x3c0 drivers/char/misc.c:165
 chrdev_open+0x53b/0x5f0 fs/char_dev.c:414
 do_dentry_open+0x85f/0x11b0 fs/open.c:882
 do_open fs/namei.c:3557 [inline]
 path_openat+0x25ba/0x2dd0 fs/namei.c:3714
 do_filp_open+0x264/0x4f0 fs/namei.c:3741
 do_sys_openat2+0x124/0x4e0 fs/open.c:1310
 do_sys_open fs/open.c:1326 [inline]
 __do_sys_openat fs/open.c:1342 [inline]
 __se_sys_openat fs/open.c:1337 [inline]
 __x64_sys_openat+0x243/0x290 fs/open.c:1337
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fa56be8c0d9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa56cb80168 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007fa56bfabf80 RCX: 00007fa56be8c0d9
RDX: 0000000000000002 RSI: 0000000020000080 RDI: ffffffffffffff9c
RBP: 00007fa56bee7ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd25093fef R14: 00007fa56cb80300 R15: 0000000000022000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__list_add_valid+0xdd/0x100 lib/list_debug.c:27
Code: b9 45 6b 06 0f 0b 48 c7 c7 20 c2 4b 8b 31 c0 e8 a9 45 6b 06 0f 0b 48 c7 c7 80 c2 4b 8b 4c 89 e6 4c 89 f1 31 c0 e8 93 45 6b 06 <0f> 0b 48 c7 c7 00 c3 4b 8b 4c 89 f6 4c 89 e1 31 c0 e8 7d 45 6b 06
RSP: 0018:ffffc9000bb8f560 EFLAGS: 00010246
RAX: 0000000000000075 RBX: ffff8880286ef008 RCX: 7255f226623a9300
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: 1ffff110056b8600 R08: ffffffff816f2c9d R09: fffff52001771e65
R10: fffff52001771e65 R11: 1ffff92001771e64 R12: ffffffff8e7c1b40
R13: dffffc0000000000 R14: ffff8880286ef000 R15: ffff88802b5c3000
FS:  00007fa56cb80700(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9560bfe718 CR3: 0000000078b31000 CR4: 00000000003506e0
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
