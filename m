Return-Path: <netdev+bounces-909-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D66C26FB588
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 18:52:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 197EA280FF5
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:51:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2259853A1;
	Mon,  8 May 2023 16:51:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150702100
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 16:51:57 +0000 (UTC)
Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7057349DC
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 09:51:55 -0700 (PDT)
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-331828cdc2dso31811625ab.3
        for <netdev@vger.kernel.org>; Mon, 08 May 2023 09:51:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683564714; x=1686156714;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vKAJIhZErfGgup3nkmbHVmmde/aJfUx7FrW75v72/Oo=;
        b=LFMaO6044GGDxXUJg04TxYmB8O73k/Ytqcdl/gks+VWrVBumbcEJOg3nnsaW3VfD50
         McHY0JSgwUg/uyq7P/rvyEE107TEVABhyP9XT1g2+wmnkbPWnrKRRKvTpkNi2nar96HW
         HgNyTd51QBE2oXiPEQShPXncIB9hUkbBZCg1cK6e/SdV1AZ/EmV4RYlsuQbNPxcqWlY/
         k1I+N+ybnFllBhyahKK5TYdQNOWQNHbxSRTJCTB1bSk0Aww/zTd+ELDb6A41xPUtmcqc
         xtcWsZTmjtV8z8fEb2ybHDR0qvBJy0Z8jSk2y6S4J58VUEyAvcVGO2snICmyeLHt96my
         RPVg==
X-Gm-Message-State: AC+VfDy4ZE/lkRatrahhI3XKm4xgFOrSh5euHiONmu4yV3MPGJPTuAVW
	aJxs7N76eEwekbGM9e2GYdiwCBz5VS7dPk7SMh/0AR5wtYnr
X-Google-Smtp-Source: ACHHUZ5JJOubbmBPxJ5XWWGE2MpiMMVz5hn+mm+ERj/WNuPOsCoXJb04UrJqpPDqksAfiumYkuEN1C1KdqsHp6WWDEdPaEZw2B8r
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:d4ce:0:b0:32a:9e86:242f with SMTP id
 o14-20020a92d4ce000000b0032a9e86242fmr5968170ilm.6.1683564714802; Mon, 08 May
 2023 09:51:54 -0700 (PDT)
Date: Mon, 08 May 2023 09:51:54 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c84b4705fb31741e@google.com>
Subject: [syzbot] [bpf?] [net?] WARNING: zero-size vmalloc in print_tainted
From: syzbot <syzbot+fae676d3cf469331fc89@syzkaller.appspotmail.com>
To: andrii@kernel.org, ast@kernel.org, bjorn@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, davem@davemloft.net, edumazet@google.com, 
	hawk@kernel.org, john.fastabend@gmail.com, jonathan.lemon@gmail.com, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, maciej.fijalkowski@intel.com, 
	magnus.karlsson@intel.com, netdev@vger.kernel.org, pabeni@redhat.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot found the following issue on:

HEAD commit:    457391b03803 Linux 6.3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1697e9d4280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=385e197a58ca4afe
dashboard link: https://syzkaller.appspot.com/bug?extid=fae676d3cf469331fc89
compiler:       arm-linux-gnueabi-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
userspace arch: arm
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15916904280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10910f18280000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/c35b5b2731d2/non_bootable_disk-457391b0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2a1bf3bafeb6/vmlinux-457391b0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/21f1e3b4a5a9/zImage-457391b0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fae676d3cf469331fc89@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 2949 at mm/vmalloc.c:3132 __vmalloc_node_range+0x44c/0x584 mm/vmalloc.c:3132
Modules linked in:
Kernel panic - not syncing: kernel: panic_on_warn set ...
CPU: 1 PID: 2949 Comm: syz-executor398 Not tainted 6.3.0-syzkaller #0
Hardware name: ARM-Versatile Express
Backtrace: 
[<817b2528>] (dump_backtrace) from [<817b261c>] (show_stack+0x18/0x1c arch/arm/kernel/traps.c:256)
 r7:81d81ac0 r6:82422c04 r5:60000093 r4:81d901cc
[<817b2604>] (show_stack) from [<817cec84>] (__dump_stack lib/dump_stack.c:88 [inline])
[<817b2604>] (show_stack) from [<817cec84>] (dump_stack_lvl+0x48/0x54 lib/dump_stack.c:106)
[<817cec3c>] (dump_stack_lvl) from [<817ceca8>] (dump_stack+0x18/0x1c lib/dump_stack.c:113)
 r5:00000000 r4:8264dd14
[<817cec90>] (dump_stack) from [<817b3110>] (panic+0x11c/0x36c kernel/panic.c:340)
[<817b2ff4>] (panic) from [<802422ec>] (print_tainted+0x0/0xa0 kernel/panic.c:236)
 r3:8240c488 r2:00000001 r1:81d79fcc r0:81d81ac0
 r7:80469ba0
[<80242268>] (check_panic_on_warn) from [<802424e0>] (__warn+0x7c/0x180 kernel/panic.c:673)
[<80242464>] (__warn) from [<802426bc>] (warn_slowpath_fmt+0xd8/0x1d8 kernel/panic.c:697)
 r8:00000009 r7:00000c3c r6:81da5110 r5:8240c954 r4:822ab6bc
[<802425e8>] (warn_slowpath_fmt) from [<80469ba0>] (__vmalloc_node_range+0x44c/0x584 mm/vmalloc.c:3132)
 r10:00000dc0 r9:8410d080 r8:83d04e80 r7:df800000 r6:00004000 r5:00000000
 r4:00000000
[<80469754>] (__vmalloc_node_range) from [<80469db0>] (vmalloc_user+0x6c/0x74 mm/vmalloc.c:3359)
 r10:00000126 r9:8410d080 r8:83d04e80 r7:00000000 r6:00000000 r5:842aa940
 r4:00000000
[<80469d44>] (vmalloc_user) from [<81767778>] (xskq_create+0x74/0xc4 net/xdp/xsk_queue.c:39)
[<81767704>] (xskq_create) from [<81766c64>] (xsk_init_queue net/xdp/xsk.c:756 [inline])
[<81767704>] (xskq_create) from [<81766c64>] (xsk_setsockopt+0x1c0/0x2bc net/xdp/xsk.c:1080)
 r7:83d04eac r6:83d04c00 r5:00000000 r4:00000003
[<81766aa8>] (xsk_setsockopt) from [<812f6720>] (__sys_setsockopt+0xd4/0x1c8 net/socket.c:2271)
 r8:80200288 r7:00000126 r6:000118b0 r5:81766aa4 r4:844eb900
[<812f664c>] (__sys_setsockopt) from [<812f6830>] (__do_sys_setsockopt net/socket.c:2282 [inline])
[<812f664c>] (__sys_setsockopt) from [<812f6830>] (sys_setsockopt+0x1c/0x24 net/socket.c:2279)
 r5:00000000 r4:00000020
[<812f6814>] (sys_setsockopt) from [<80200060>] (ret_fast_syscall+0x0/0x1c arch/arm/mm/proc-v7.S:66)
Exception stack(0xdf981fa8 to 0xdf981ff0)
1fa0:                   00000020 00000000 00000003 0000011b 00000003 20000040
1fc0: 00000020 00000000 000118b0 00000126 000f4240 00000000 00000000 00003a97
1fe0: 7e9b4c90 7e9b4c80 00010624 0002a900
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to change bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

