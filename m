Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8775A6F111
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 01:55:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfGTXzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jul 2019 19:55:06 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:47568 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfGTXzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jul 2019 19:55:06 -0400
Received: by mail-io1-f71.google.com with SMTP id r27so39059139iob.14
        for <netdev@vger.kernel.org>; Sat, 20 Jul 2019 16:55:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=Ure/FStr9KUleqmNZveqVn/D+OgGh2EUrju16bMvi4g=;
        b=NwDbG9i7Wn3dISENpzRt+Z6yWqgylD3HbF9kY16AvURhAmf+jCMm6N7Xe0aBOZkvzf
         hsuYk3j7rrHLfUa2D/vJOWhR7O1q3MELlrn1xa6ZD96cD2i3/Jlwz7nksMC9Al9Rvrv2
         5xpwZLClgA6i8w/+StjBrZ/ITIfTze/JroKy/XCqAYqaZmXJ1M3iMKmcpeKzjWEspHCk
         gKxx+jYMBc5+BPWUI4OayrHHerb8hiiTvsx973CeR5o5mn7k0aBRYwKlhR5yxXdgludf
         ThQvINOXIH+BmEsHyF+jp8oLHXLwy0bSy0mb8F+tHtkZTBD8P4BfBFUldDyGayfAolqX
         z12g==
X-Gm-Message-State: APjAAAUeGmp9oaZFVj4Nt8CuECACUMKLh/HzTIkvTjb3QSqDt1jJqJ5d
        r6+ytISyn6jSXGdZs6amcjPO29ZBVsF0g1AIDZlX+7HmP/FE
X-Google-Smtp-Source: APXvYqzBvxsEh1KC0825IplS8kwalQB0dVwIANXgHIwht6c7cKhisZidxJxjnkq8+/pCpt3DK4md2jAy37jASF8u1ZWWAIZo/c9V
MIME-Version: 1.0
X-Received: by 2002:a6b:e60b:: with SMTP id g11mr59105414ioh.9.1563666905129;
 Sat, 20 Jul 2019 16:55:05 -0700 (PDT)
Date:   Sat, 20 Jul 2019 16:55:05 -0700
In-Reply-To: <00000000000081994205827ea9a0@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006d6c68058e259203@google.com>
Subject: Re: WARNING in xt_compat_add_offset
From:   syzbot <syzbot+276ddebab3382bbf72db@syzkaller.appspotmail.com>
To:     bridge@lists.linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, kadlec@blackhole.kfki.hu,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        nikolay@cumulusnetworks.com, pablo@netfilter.org,
        roopa@cumulusnetworks.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    abdfd52a Merge tag 'armsoc-defconfig' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=146c4968600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b8e53b1e149c0183
dashboard link: https://syzkaller.appspot.com/bug?extid=276ddebab3382bbf72db
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=159be500600000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=139364f0600000

The bug was bisected to:

commit 2035f3ff8eaa29cfb5c8e2160b0f6e85eeb21a95
Author: Florian Westphal <fw@strlen.de>
Date:   Mon Jan 21 20:54:36 2019 +0000

     netfilter: ebtables: compat: un-break 32bit setsockopt when no rules  
are present

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1462834d200000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1662834d200000
console output: https://syzkaller.appspot.com/x/log.txt?x=1262834d200000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+276ddebab3382bbf72db@syzkaller.appspotmail.com
Fixes: 2035f3ff8eaa ("netfilter: ebtables: compat: un-break 32bit  
setsockopt when no rules are present")

------------[ cut here ]------------
WARNING: CPU: 1 PID: 9012 at net/netfilter/x_tables.c:649  
xt_compat_add_offset.cold+0x11/0x36 /net/netfilter/x_tables.c:649
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 9012 Comm: syz-executor131 Not tainted 5.2.0+ #64
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack /lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 /lib/dump_stack.c:113
  panic+0x2dc/0x755 /kernel/panic.c:219
  __warn.cold+0x20/0x4c /kernel/panic.c:576
  report_bug+0x263/0x2b0 /lib/bug.c:186
  fixup_bug /arch/x86/kernel/traps.c:179 [inline]
  fixup_bug /arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x11b/0x200 /arch/x86/kernel/traps.c:272
  do_invalid_op+0x37/0x50 /arch/x86/kernel/traps.c:291
  invalid_op+0x14/0x20 /arch/x86/entry/entry_64.S:1008
RIP: 0010:xt_compat_add_offset.cold+0x11/0x36 /net/netfilter/x_tables.c:649
Code: 89 ee 48 c7 c7 c0 29 2d 88 e8 0c 76 7b fb 41 bc ea ff ff ff e9 87 88  
ff ff e8 08 d3 91 fb 48 c7 c7 00 2a 2d 88 e8 f0 75 7b fb <0f> 0b 41 bc f4  
ff ff ff e9 01 8b ff ff e8 ea d2 91 fb 48 c7 c7 00
RSP: 0018:ffff8880a382f8d8 EFLAGS: 00010286
RAX: 0000000000000024 RBX: ffff888216b74ad0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff815c3a26 RDI: ffffed1014705f0d
RBP: ffff8880a382f908 R08: 0000000000000024 R09: ffffed1015d260b1
R10: ffffed1015d260b0 R11: ffff8880ae930587 R12: 0000000000000014
R13: 0000000000000060 R14: ffff88808b7b6180 R15: 0000000000000000
  size_entry_mwt /net/bridge/netfilter/ebtables.c:2122 [inline]
  compat_copy_entries+0x10e9/0x1340 /net/bridge/netfilter/ebtables.c:2147
  compat_do_replace+0x3b3/0x680 /net/bridge/netfilter/ebtables.c:2243
  compat_do_ebt_set_ctl+0x22f/0x27e /net/bridge/netfilter/ebtables.c:2325
  compat_nf_sockopt /net/netfilter/nf_sockopt.c:144 [inline]
  compat_nf_setsockopt+0x98/0x140 /net/netfilter/nf_sockopt.c:156
  compat_ip_setsockopt /net/ipv4/ip_sockglue.c:1286 [inline]
  compat_ip_setsockopt+0x106/0x140 /net/ipv4/ip_sockglue.c:1267
  compat_raw_setsockopt+0xe0/0x100 /net/ipv4/raw.c:865
  compat_sock_common_setsockopt+0xb2/0x140 /net/core/sock.c:3141
  __compat_sys_setsockopt+0x185/0x380 /net/compat.c:384
  __do_compat_sys_setsockopt /net/compat.c:397 [inline]
  __se_compat_sys_setsockopt /net/compat.c:394 [inline]
  __ia32_compat_sys_setsockopt+0xbd/0x150 /net/compat.c:394
  do_syscall_32_irqs_on /arch/x86/entry/common.c:332 [inline]
  do_fast_syscall_32+0x27b/0xdb3 /arch/x86/entry/common.c:403
  entry_SYSENTER_compat+0x70/0x7f /arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7f489c9
Code: d3 83 c4 10 5b 5e 5d c3 ba 80 96 98 00 eb a9 8b 04 24 c3 8b 34 24 c3  
8b 3c 24 c3 90 90 90 90 90 90 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90  
90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000ffaa6d8c EFLAGS: 00000292 ORIG_RAX: 000000000000016e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000000000
RDX: 0000000000000080 RSI: 0000000020000000 RDI: 00000000000001fc
RBP: 0000000000000012 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..

