Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C390B59B21A
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 07:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbiHUFeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 01:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiHUFea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 01:34:30 -0400
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7323A13E94
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 22:34:28 -0700 (PDT)
Received: by mail-il1-f199.google.com with SMTP id d4-20020a056e02214400b002df95f624a4so6100411ilv.1
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 22:34:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=SLinpRF80PqnXFMCOcLvqp4Pl9d+bNqtJ3TSPEcxUxE=;
        b=M1cmqBpuiZlMp3uEPBgK2Wio4Ytk27RMv6LkOgTr9RfqiCqanlYgpdlbh4XqT0aOoS
         oF/Gaekq+P7fwC65x1bZxNzMvheftqiPWZ9L/RhhVOJiVHVz2BaanHXPwWsx+g0wcM2S
         rIdmnn8pdE96KTgki2Pprmpc6/lOKX2MyOqsXwKv+5WWFlChvIRJQ6vi66VKI0R3JQL9
         16UsCR/MCZGxEYBSCkEnUaTWDidoTAyOriWAvfppt7UDmkRH4TvoK0mF9mPwWaeOajLs
         fnLzYuOPBzmtj08l9DUgX3yb538G5t12jNbEiqj8Fqn0uh6k0SvVqDHMlizSMLydDkGC
         750w==
X-Gm-Message-State: ACgBeo3eYhCA69ICxKbA7xZDVnB23/Dfp0qEzh+2YzyobVrvq7dB1Vst
        0ljW8g35Gh9h2WDFqCVSa8pVF0uWXqhzmcbCluS7UsiVUDyX
X-Google-Smtp-Source: AA6agR5J93whK1w5u2ICPb5aH+ztLDAichtMjLLgbuc9JCKTBb/iBRYUyO46BgZt4/5duMeXtvn4X1H4UO3dwrrR8wyfs+HMCBF4
MIME-Version: 1.0
X-Received: by 2002:a05:6638:438d:b0:344:cb31:89d3 with SMTP id
 bo13-20020a056638438d00b00344cb3189d3mr6848132jab.6.1661060067845; Sat, 20
 Aug 2022 22:34:27 -0700 (PDT)
Date:   Sat, 20 Aug 2022 22:34:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004b6dfe05e6b9af89@google.com>
Subject: [syzbot] WARNING in vmap_pages_range_noflush (2)
From:   syzbot <syzbot+616ff0452fec30f4dcfd@syzkaller.appspotmail.com>
To:     ast@kernel.org, bjorn@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com,
        hawk@kernel.org, john.fastabend@gmail.com,
        jonathan.lemon@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
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

HEAD commit:    95d10484d66e Add linux-next specific files for 20220817
git tree:       linux-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14bf9423080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2f5fa747986be53a
dashboard link: https://syzkaller.appspot.com/bug?extid=616ff0452fec30f4dcfd
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1409d63d080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=169a9fc3080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+616ff0452fec30f4dcfd@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 3614 at mm/vmalloc.c:476 vmap_pages_pte_range mm/vmalloc.c:476 [inline]
WARNING: CPU: 1 PID: 3614 at mm/vmalloc.c:476 vmap_pages_pmd_range mm/vmalloc.c:500 [inline]
WARNING: CPU: 1 PID: 3614 at mm/vmalloc.c:476 vmap_pages_pud_range mm/vmalloc.c:518 [inline]
WARNING: CPU: 1 PID: 3614 at mm/vmalloc.c:476 vmap_pages_p4d_range mm/vmalloc.c:536 [inline]
WARNING: CPU: 1 PID: 3614 at mm/vmalloc.c:476 vmap_small_pages_range_noflush mm/vmalloc.c:558 [inline]
WARNING: CPU: 1 PID: 3614 at mm/vmalloc.c:476 vmap_pages_range_noflush+0x992/0xb90 mm/vmalloc.c:587
Modules linked in:
CPU: 1 PID: 3614 Comm: syz-executor206 Not tainted 6.0.0-rc1-next-20220817-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/22/2022
RIP: 0010:vmap_pages_pte_range mm/vmalloc.c:476 [inline]
RIP: 0010:vmap_pages_pmd_range mm/vmalloc.c:500 [inline]
RIP: 0010:vmap_pages_pud_range mm/vmalloc.c:518 [inline]
RIP: 0010:vmap_pages_p4d_range mm/vmalloc.c:536 [inline]
RIP: 0010:vmap_small_pages_range_noflush mm/vmalloc.c:558 [inline]
RIP: 0010:vmap_pages_range_noflush+0x992/0xb90 mm/vmalloc.c:587
Code: c7 c7 e0 fa f8 89 c6 05 aa 6c 0d 0c 01 e8 c7 10 7e 07 0f 0b e9 48 fe ff ff e8 ba d7 bf ff 0f 0b e9 1d ff ff ff e8 ae d7 bf ff <0f> 0b e9 11 ff ff ff e8 a2 d7 bf ff 4c 8b 7c 24 20 4c 89 ff e8 45
RSP: 0018:ffffc9000398faa8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88806fbbad48 RCX: 0000000000000000
RDX: ffff88801f1f0000 RSI: ffffffff81bc3da2 RDI: 0000000000000007
RBP: 0000000000000000 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 8000000000000163 R14: dffffc0000000000 R15: ffffc9000d9a9000
FS:  0000555555c6f300(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000040 CR3: 000000002111f000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 vmap_pages_range mm/vmalloc.c:621 [inline]
 vmap+0x1b4/0x330 mm/vmalloc.c:2837
 xdp_umem_addr_map net/xdp/xdp_umem.c:51 [inline]
 xdp_umem_reg net/xdp/xdp_umem.c:223 [inline]
 xdp_umem_create+0xcf7/0x1180 net/xdp/xdp_umem.c:252
 xsk_setsockopt+0x73e/0x9e0 net/xdp/xsk.c:1100
 __sys_setsockopt+0x2d6/0x690 net/socket.c:2252
 __do_sys_setsockopt net/socket.c:2263 [inline]
 __se_sys_setsockopt net/socket.c:2260 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2260
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f848f588b29
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdd237dcc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f848f588b29
RDX: 0000000000000004 RSI: 000000000000011b RDI: 0000000000000003
RBP: 00007f848f54ccd0 R08: 0000000000000020 R09: 0000000000000000
R10: 0000000020000040 R11: 0000000000000246 R12: 00007f848f54cd60
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
