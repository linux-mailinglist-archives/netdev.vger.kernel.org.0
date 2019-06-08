Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC07C39D24
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 13:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfFHLWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 07:22:07 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:44321 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727085AbfFHLWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 07:22:07 -0400
Received: by mail-io1-f69.google.com with SMTP id i133so3675861ioa.11
        for <netdev@vger.kernel.org>; Sat, 08 Jun 2019 04:22:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=hVoG57mCN8NOasXfbKFhxicqTT/xW4k6vglaIu7Gsr8=;
        b=FnpinDBc68NJ0aDs0xMwqcY86Kzz87gxXbRNCLGPpRyX/zfTJKazllR/sS25QGKT6w
         e6NJSy1kPBngEkXHhZ8jyCeItbAw3dX/Ya9xoH96YvRDTWih5Wu5/+H3oku5WTOaErJI
         M1iBPN8OFOwApdkwJGD52R8SL1YK60uv4aYD8IpIBUnZq1qVaLh4P/HIxiLSDEDw/dBY
         F9td7L0SV0BbvXJ1V4hlabuFM217YJTrQDBFZOWJvsZ8f3JnotCVmgAeUQdD+j9IbZPm
         PNh+FSarR0hXxWF6z7GBvmUmJWhdPS9gZ6wuK46jOTdGcJ03Rtc97zAUN47HuRmblBhf
         tCLw==
X-Gm-Message-State: APjAAAXxXew+y2DOXOwLseE278kDdvU1N+bnwRyfn7SBMTk7r684pOdB
        c7XV2kXYyCOBNGeiXxU38056fdzZ6l3ODYiqBTdaKfVvF35I
X-Google-Smtp-Source: APXvYqxR+yDqE0sbsVS8kE/JcX0C63g/G7rVLFT6sEkllG3CgH0tCwhH0z0uaNRie7Uk/8nBz/cdYlmm5MngD6hxJdcYk5neIjx8
MIME-Version: 1.0
X-Received: by 2002:a02:5489:: with SMTP id t131mr36685651jaa.70.1559992926211;
 Sat, 08 Jun 2019 04:22:06 -0700 (PDT)
Date:   Sat, 08 Jun 2019 04:22:06 -0700
In-Reply-To: <000000000000e92d1805711f5552@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000381684058ace28e5@google.com>
Subject: Re: WARNING in bpf_jit_free
From:   syzbot <syzbot+2ff1e7cb738fd3c41113@syzkaller.appspotmail.com>
To:     airlied@linux.ie, ast@kernel.org, bpf@vger.kernel.org,
        daniel@ffwll.ch, daniel@iogearbox.net, davem@davemloft.net,
        dri-devel@lists.freedesktop.org, hawk@kernel.org,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        kafai@fb.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, maxime.ripard@bootlin.com,
        netdev@vger.kernel.org, paul.kocialkowski@bootlin.com,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        wens@csie.org, xdp-newbies@vger.kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    79c3ba32 Merge tag 'drm-fixes-2019-06-07-1' of git://anong..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1201b971a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=60564cb52ab29d5b
dashboard link: https://syzkaller.appspot.com/bug?extid=2ff1e7cb738fd3c41113
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a3bf51a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=120d19f2a00000

The bug was bisected to:

commit 0fff724a33917ac581b5825375d0b57affedee76
Author: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Date:   Fri Jan 18 14:51:13 2019 +0000

     drm/sun4i: backend: Use explicit fourcc helpers for packed YUV422 check

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1467550f200000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1667550f200000
console output: https://syzkaller.appspot.com/x/log.txt?x=1267550f200000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2ff1e7cb738fd3c41113@syzkaller.appspotmail.com
Fixes: 0fff724a3391 ("drm/sun4i: backend: Use explicit fourcc helpers for  
packed YUV422 check")

WARNING: CPU: 0 PID: 8951 at kernel/bpf/core.c:851 bpf_jit_free+0x157/0x1b0
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 8951 Comm: kworker/0:0 Not tainted 5.2.0-rc3+ #23
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
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
RIP: 0010:bpf_jit_free+0x157/0x1b0
Code: 00 fc ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 75 5d 48 b8 00 02 00 00  
00 00 ad de 48 39 43 70 0f 84 05 ff ff ff e8 f9 b5 f4 ff <0f> 0b e9 f9 fe  
ff ff e8 bd 53 2d 00 e9 d9 fe ff ff 48 89 7d e0 e8
RSP: 0018:ffff88808886fcb0 EFLAGS: 00010293
RAX: ffff88808cb6c480 RBX: ffff88809051d280 RCX: ffffffff817ae68d
RDX: 0000000000000000 RSI: ffffffff817bf0f7 RDI: ffff88809051d2f0
RBP: ffff88808886fcd0 R08: 1ffffffff14ccaa8 R09: fffffbfff14ccaa9
R10: fffffbfff14ccaa8 R11: ffffffff8a665547 R12: ffffc90001925000
R13: ffff88809051d2e8 R14: ffff8880a0e43900 R15: ffff8880ae834840
  bpf_prog_free_deferred+0x27a/0x350 kernel/bpf/core.c:1984
  process_one_work+0x989/0x1790 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x354/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Kernel Offset: disabled
Rebooting in 86400 seconds..

