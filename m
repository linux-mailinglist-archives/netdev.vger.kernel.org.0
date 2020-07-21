Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877A3227740
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 05:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728151AbgGUDwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 23:52:20 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:49058 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbgGUDwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 23:52:18 -0400
Received: by mail-il1-f199.google.com with SMTP id q9so12569712ilt.15
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 20:52:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=//1p8HfVGvQ63J1J9WEB8MILBk71QonnSsQsub+Ky6o=;
        b=O3pXfMBg6bGS8azHFrb+uic6edKqwoStzbNeSGUZl/vc4rddzq7jTZJ9Y1bzY+3HFX
         MNUlT7hXTfifs78CWIBwdT6aXnAQN2APQsSMvt05HpiMpF9LqbFFJO+Y0m70YgE/4DzP
         aAVhaotrI/oi4KBU5A6z2lTGpnZPqZ7J9GGZPJ6N5cp9GvoG+lqutT5bcnQbWV/ZH+Cg
         9r5V1WbayDX+4DqE2cGXwntQviEIWhu+BPQ8EaJKAO9VgGoaRiLkC799W3NV6Q+C19vh
         r0G/DbG8sQti5yhp/J/56AswazkkRoByC3xanLZIplIwNvtdaFiPHWO6BOEo5EGstF/M
         TzsA==
X-Gm-Message-State: AOAM533bbrM/88Oar8PfjP+KMMsq6c2HUD2DDbRT7BBwVfXLd8plE7Q9
        cMvNHC+9D3NGS2RbTRq5ILBv3gmtxN2HxcKlOPJp4c9RyY7z
X-Google-Smtp-Source: ABdhPJzEFSCdm8+1j/Di/AVwzmfIChYAhmAPtjb9hDFjA/lIcP9uiaDUGNnRkpefNWx8Yo5Nqr8/lINsOolhutBIve9tbsurVL0L
MIME-Version: 1.0
X-Received: by 2002:a92:dac8:: with SMTP id o8mr26062670ilq.152.1595303537574;
 Mon, 20 Jul 2020 20:52:17 -0700 (PDT)
Date:   Mon, 20 Jul 2020 20:52:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000aa87f305aaeb8c8e@google.com>
Subject: KASAN: slab-out-of-bounds Read in xfrm6_tunnel_alloc_spi
From:   syzbot <syzbot+87b2b4484df1d40e7ece@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4c43049f Add linux-next specific files for 20200716
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10e7e9d7100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2c76d72659687242
dashboard link: https://syzkaller.appspot.com/bug?extid=87b2b4484df1d40e7ece
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=117f936f100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1074fc7f100000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+87b2b4484df1d40e7ece@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in __xfrm6_tunnel_alloc_spi net/ipv6/xfrm6_tunnel.c:124 [inline]
BUG: KASAN: slab-out-of-bounds in xfrm6_tunnel_alloc_spi+0x779/0x8a0 net/ipv6/xfrm6_tunnel.c:174
Read of size 4 at addr ffff88809a3fe000 by task syz-executor597/6834
CPU: 1 PID: 6834 Comm: syz-executor597 Not tainted 5.8.0-rc5-next-20200716-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 print_address_description.constprop.0.cold+0xae/0x497 mm/kasan/report.c:383
 __kasan_report mm/kasan/report.c:513 [inline]
 kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
 __xfrm6_tunnel_alloc_spi net/ipv6/xfrm6_tunnel.c:124 [inline]
 xfrm6_tunnel_alloc_spi+0x779/0x8a0 net/ipv6/xfrm6_tunnel.c:174
 ipcomp6_tunnel_create net/ipv6/ipcomp6.c:84 [inline]
 ipcomp6_tunnel_attach net/ipv6/ipcomp6.c:124 [inline]
 ipcomp6_init_state net/ipv6/ipcomp6.c:159 [inline]
 ipcomp6_init_state+0x2af/0x700 net/ipv6/ipcomp6.c:139
 __xfrm_init_state+0x9a6/0x14b0 net/xfrm/xfrm_state.c:2498
 xfrm_init_state+0x1a/0x70 net/xfrm/xfrm_state.c:2525
 pfkey_msg2xfrm_state net/key/af_key.c:1291 [inline]
 pfkey_add+0x1a10/0x2b70 net/key/af_key.c:1508
 pfkey_process+0x66d/0x7a0 net/key/af_key.c:2834
 pfkey_sendmsg+0x42d/0x800 net/key/af_key.c:3673
 sock_sendmsg_nosec net/socket.c:651 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:671
 ____sys_sendmsg+0x331/0x810 net/socket.c:2362
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2416
 __sys_sendmmsg+0x195/0x480 net/socket.c:2506
 __do_sys_sendmmsg net/socket.c:2535 [inline]
 __se_sys_sendmmsg net/socket.c:2532 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2532
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440409
Code: Bad RIP value.
RSP: 002b:00007ffea3e50018 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440409
RDX: 0400000000000282 RSI: 0000000020000180 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000401c10
R13: 0000000000401ca0 R14: 0000000000000000 R15: 0000000000000000
Allocated by task 6731:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:48
 kasan_set_track mm/kasan/common.c:56 [inline]
 __kasan_kmalloc.constprop.0+0xbf/0xd0 mm/kasan/common.c:461
 slab_post_alloc_hook mm/slab.h:535 [inline]
 slab_alloc mm/slab.c:3312 [inline]
 kmem_cache_alloc+0x138/0x3a0 mm/slab.c:3482
 dup_fd+0x89/0xc90 fs/file.c:293
 copy_files kernel/fork.c:1459 [inline]
 copy_process+0x1dd0/0x6b70 kernel/fork.c:2064
 _do_fork+0xe8/0xb10 kernel/fork.c:2434
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2551
 do_syscall_64+0x60/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
The buggy address belongs to the object at ffff88809a3fe0c0
 which belongs to the cache files_cache of size 832
The buggy address is located 192 bytes to the left of
 832-byte region [ffff88809a3fe0c0, ffff88809a3fe400)
The buggy address belongs to the page:
page:000000007671797d refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88809a3fec00 pfn:0x9a3fe
flags: 0xfffe0000000200(slab)
raw: 00fffe0000000200 ffffea00027a5248 ffffea0002a3b648 ffff88821bc47600
raw: ffff88809a3fec00 ffff88809a3fe0c0 0000000100000003 0000000000000000
page dumped because: kasan: bad access detected
Memory state around the buggy address:
 ffff88809a3fdf00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88809a3fdf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88809a3fe000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                   ^
 ffff88809a3fe080: fc fc fc fc fc fc fc fc 00 00 00 00 00 00 00 00
 ffff88809a3fe100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
