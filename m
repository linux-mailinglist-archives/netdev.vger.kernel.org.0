Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9696062F80
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 06:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfGIEZC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 00:25:02 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:55665 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbfGIEZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 00:25:01 -0400
Received: by mail-io1-f70.google.com with SMTP id f22so21601249ioh.22
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 21:25:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=ThTKrBZsQ1JlWFlPRVe4RXWJ3j4uyiYja7ipCGiZOCQ=;
        b=IR7lsHb3oNFuMqHGmuQtNNatAPxhkSNrmBTRUGqA4+r2Kc0ylphT4iAYiQXdvvDF8m
         kM+hr/Suw1o9f8RS0DZwGg9bEECvn85yxOzB7vn+3BBROQtUL75+ftG/Y6Pjx5OX5B50
         wSe1IBKBsDNMZarg1pNOPu0oDrU9DTDYG9UqGer2DBbyDgp8dMiyqmYGqwLVXW6YsLah
         waP7D59vu4pcoTkhkzTqvF9MtcL0NPfI2hOk5WFki5utTBpKA8m44Vu4P1W/X2P0mMcx
         8bY8kaPQE2tjW3twYwXAhZU/UWYvTUSwFcj4SwrQuE9LS7JJ2uMjFNdNiSLqlYCqtbst
         6apQ==
X-Gm-Message-State: APjAAAVSUgQccLrX5D7y5daxohImhgkx1pHOic3SEXE2r5Ihh5WFU7HJ
        OvW5gCTP/14gbJAbJyfMZ7GHfw5ewm3OeQ8vWFy81E6ZMdEL
X-Google-Smtp-Source: APXvYqym5DaYVguOnx/vYC+8fr3X5IKtdXXfy6a1e9Ff48wtiCtsWW98PTt6iX6sFsLg9KiiCV1ve2K7VjNJJcGzMyGUA2cQGoZr
MIME-Version: 1.0
X-Received: by 2002:a6b:641a:: with SMTP id t26mr916082iog.3.1562646300671;
 Mon, 08 Jul 2019 21:25:00 -0700 (PDT)
Date:   Mon, 08 Jul 2019 21:25:00 -0700
In-Reply-To: <CAEf4BzaUEWwGL3k0VeiFYFqyJexQU9cDZWN69jSDpBjP1ZEcpw@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000a94981058d37f1a4@google.com>
Subject: Re: WARNING in mark_chain_precision
From:   syzbot <syzbot+f21251a7468cd46efc60@syzkaller.appspotmail.com>
To:     aaron.f.brown@intel.com, andrii.nakryiko@gmail.com, ast@kernel.org,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, intel-wired-lan@lists.osuosl.org,
        jakub.kicinski@netronome.com, jeffrey.t.kirsher@intel.com,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        sasha.neftin@intel.com, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, xdp-newbies@vger.kernel.org,
        yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot has tested the proposed patch but the reproducer still triggered  
crash:
WARNING in bpf_jit_free

WARNING: CPU: 0 PID: 9077 at kernel/bpf/core.c:851 bpf_jit_free+0x157/0x1b0
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 9077 Comm: kworker/0:3 Not tainted 5.2.0-rc6+ #1
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
00 00 ad de 48 39 43 70 0f 84 05 ff ff ff e8 09 7f f4 ff <0f> 0b e9 f9 fe  
ff ff e8 2d 02 2e 00 e9 d9 fe ff ff 48 89 7d e0 e8
RSP: 0018:ffff888084affcb0 EFLAGS: 00010293
RAX: ffff88808a622100 RBX: ffff88809639d580 RCX: ffffffff817b0b0d
RDX: 0000000000000000 RSI: ffffffff817c4557 RDI: ffff88809639d5f0
RBP: ffff888084affcd0 R08: 1ffffffff150daa8 R09: fffffbfff150daa9
R10: fffffbfff150daa8 R11: ffffffff8a86d547 R12: ffffc90001921000
R13: ffff88809639d5e8 R14: ffff8880a0589800 R15: ffff8880ae834d40
  bpf_prog_free_deferred+0x27a/0x350 kernel/bpf/core.c:1982
  process_one_work+0x989/0x1790 kernel/workqueue.c:2269
  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
  kthread+0x354/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Kernel Offset: disabled
Rebooting in 86400 seconds..


Tested on:

commit:         b9321614 bpf: fix precision bit propagation for BPF_ST ins..
git tree:       https://github.com/anakryiko/linux bpf-fix-precise-bpf_st
console output: https://syzkaller.appspot.com/x/log.txt?x=112f0dfda00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6bb3e6e7997c14f9
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

