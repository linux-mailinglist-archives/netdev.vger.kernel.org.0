Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A025625C0
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391480AbfGHQHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:07:08 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:36670 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390097AbfGHQHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:07:07 -0400
Received: by mail-io1-f71.google.com with SMTP id k21so19544160ioj.3
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 09:07:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=TqFO65CoYLM07AC5TqXO+GX7mf0SUZmV5q2ij7PT9gI=;
        b=DVUIc6x9G5QGpSFdxH3faAOw4h2JPmKaqzM3U4lu0IDlIdcSCDUBalVrqSZOjDlXFX
         dkBmpmqJFHZzidwuaS1/GmTGTvgOSZxDRhO51ThZe+Njc7na0nqlWW/ivHsitDFUu4WP
         kblNHHdlcsLPYR8sm638R8UqsDw7vfMesyg7F1hsFlk6w6BEAc2Xd8/03l6jnefvdFYz
         TjZ7coqLl3eYTxL0W2xionOX/E76DfnPEbgW07z+Hj+j12Tl19Gdmv4sYlmDiJ9yC4GR
         X5LDhGS9Tpj2X9myUjbLqgJ7TyDa51RouIDxDtqWWuDa29c5QoeM70gARD0BezCrzp3D
         iTvg==
X-Gm-Message-State: APjAAAU1z5kpoBrplSQ3ok1O9o/+gw2xuUN932ltE4c0J8gzivP9gsY7
        6f81JGrTAlpVDz5zWOXOkQ3o4LWaGz0Q497APOw17QpJWXxr
X-Google-Smtp-Source: APXvYqypjVO3/nyV1s38LzoFPnqLPNAQGQ7ftNO2UBebL5TEyMxaB3ToQ/6UR4tEu4oPYBSPQYTZN6TXG7nCBB9KomBKcJj3Mxnt
MIME-Version: 1.0
X-Received: by 2002:a6b:cd86:: with SMTP id d128mr19903340iog.234.1562602026120;
 Mon, 08 Jul 2019 09:07:06 -0700 (PDT)
Date:   Mon, 08 Jul 2019 09:07:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b13e1d058d2da276@google.com>
Subject: WARNING in mark_chain_precision
From:   syzbot <syzbot+f21251a7468cd46efc60@syzkaller.appspotmail.com>
To:     aaron.f.brown@intel.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        intel-wired-lan@lists.osuosl.org, jakub.kicinski@netronome.com,
        jeffrey.t.kirsher@intel.com, john.fastabend@gmail.com,
        kafai@fb.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        sasha.neftin@intel.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, xdp-newbies@vger.kernel.org,
        yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    a51df9f8 gve: fix -ENOMEM null check on a page allocation
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17e64325a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6bb3e6e7997c14f9
dashboard link: https://syzkaller.appspot.com/bug?extid=f21251a7468cd46efc60
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=114f842da00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1630a5aba00000

The bug was bisected to:

commit 55fdbeaa2db8b271db767240fba24a60bd232528
Author: Sasha Neftin <sasha.neftin@intel.com>
Date:   Mon Jan 7 14:40:17 2019 +0000

     igc: Remove unused code

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15c205b9a00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=17c205b9a00000
console output: https://syzkaller.appspot.com/x/log.txt?x=13c205b9a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+f21251a7468cd46efc60@syzkaller.appspotmail.com
Fixes: 55fdbeaa2db8 ("igc: Remove unused code")

------------[ cut here ]------------
verifier backtracking bug
WARNING: CPU: 0 PID: 8846 at kernel/bpf/verifier.c:1755  
mark_chain_precision+0x15c2/0x18e0 kernel/bpf/verifier.c:1755
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 8846 Comm: syz-executor835 Not tainted 5.2.0-rc6+ #56
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2cb/0x744 kernel/panic.c:219
  __warn.cold+0x20/0x4d kernel/panic.c:576
  report_bug+0x263/0x2b0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:272
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:291
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:986
RIP: 0010:mark_chain_precision+0x15c2/0x18e0 kernel/bpf/verifier.c:1755
Code: e9 55 f2 ff ff 48 89 df e8 4b 0a 2c 00 e9 3a f3 ff ff e8 61 cb f2 ff  
48 c7 c7 e0 43 91 87 c6 05 40 2b 1f 08 01 e8 1c 03 c5 ff <0f> 0b 41 be f2  
ff ff ff e9 eb f7 ff ff e8 3c cb f2 ff 45 31 f6 e9
RSP: 0018:ffff8880a01ef378 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815adb06 RDI: ffffed101403de61
RBP: ffff8880a01ef4d0 R08: ffff88808e26c400 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8880a14e8440 R14: 0000000000000001 R15: dffffc0000000000
  check_cond_jmp_op+0xcce/0x3c20 kernel/bpf/verifier.c:5793
  do_check+0x61cf/0x8930 kernel/bpf/verifier.c:7684
  bpf_check+0x6f99/0x9950 kernel/bpf/verifier.c:9195
  bpf_prog_load+0xec8/0x1670 kernel/bpf/syscall.c:1690
  __do_sys_bpf+0xa20/0x42c0 kernel/bpf/syscall.c:2830
  __se_sys_bpf kernel/bpf/syscall.c:2789 [inline]
  __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:2789
  do_syscall_64+0xfd/0x680 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440369
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffccb952af8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440369
RDX: 0000000000000048 RSI: 0000000020000200 RDI: 0000000000000005
RBP: 00000000006ca018 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000401bf0
R13: 0000000000401c80 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
