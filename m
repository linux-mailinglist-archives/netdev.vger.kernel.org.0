Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F379DACB42
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 09:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbfIHHFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 03:05:07 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:33327 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726671AbfIHHFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Sep 2019 03:05:07 -0400
Received: by mail-io1-f72.google.com with SMTP id 5so13727804ion.0
        for <netdev@vger.kernel.org>; Sun, 08 Sep 2019 00:05:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=jaCTVZqhcxOhL8EQAQv7QLQqBDC29UKgHGYH8sbUJB0=;
        b=P5vZ1k53gLubA99lyB+1UNKcYpbPRguLAy2Xr9KlVZy8Yj155/6ErX+cyzF3BfjM1S
         PUi3eSZ0PmFjNpvK56ZT8PPkZ79jD85/n5dL22FtmNmR2yBAvoPZiqQf8jfrgnTtRDA9
         1guJ7j7fuvm1KIsRPKf6jcjyRL4pnZmjaYK+6SwbUVVh8fO0law5641FZiRr3Kt42fdk
         lzp0md/lVEzA4QAdra5SR8m0IvcPCa+drBcZSbq1AJiOVljFC9Lx47rGanVFE7J7fXa1
         3B9EVLS3WkwGdNe+eAD+w6pVWcP+wkgp3YQC93N2wIgIpysoLGZEhRFhqA4L4AN7xvGX
         yv+Q==
X-Gm-Message-State: APjAAAV2HgIaKYZGojFVZSegGSkO6GbweQLnfoLiLroGB+lKP1fHm62N
        imUfPuwd1lH5qU80B8X9JFUW1phv4cX+zLA31nmNfn8bCrk3
X-Google-Smtp-Source: APXvYqzRiAdciIlrYjayOWMlQbNhQMm/wx8vDavldZRMoQayHxxSMSjP0ev272rOzHI6rZDxfWNVJ3fpvhpNDyEoqPgkhhlPNWj3
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3e8:: with SMTP id s8mr18593856jaq.68.1567926306453;
 Sun, 08 Sep 2019 00:05:06 -0700 (PDT)
Date:   Sun, 08 Sep 2019 00:05:06 -0700
In-Reply-To: <00000000000092839d0581fd74ad@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000087c1ad0592054ac0@google.com>
Subject: Re: WARNING in __vunmap
From:   syzbot <syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    b3a9964c Merge tag 'char-misc-5.3-rc8' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16c9f70a600000
kernel config:  https://syzkaller.appspot.com/x/.config?x=144488c6c6c6d2b6
dashboard link: https://syzkaller.appspot.com/bug?extid=5ec9bb042ddfe9644773
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11a30371600000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+5ec9bb042ddfe9644773@syzkaller.appspotmail.com

------------[ cut here ]------------
Trying to vfree() nonexistent vm area (00000000dddfa71b)
WARNING: CPU: 0 PID: 10463 at mm/vmalloc.c:2235 __vunmap+0x148/0xa20  
mm/vmalloc.c:2234
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 10463 Comm: syz-executor.0 Not tainted 5.3.0-rc7+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
  panic+0x25c/0x799 kernel/panic.c:219
  __warn+0x22f/0x230 kernel/panic.c:576
  report_bug+0x190/0x290 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  do_error_trap+0xd7/0x440 arch/x86/kernel/traps.c:272
  do_invalid_op+0x36/0x40 arch/x86/kernel/traps.c:291
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1028
RIP: 0010:__vunmap+0x148/0xa20 mm/vmalloc.c:2234
Code: 0c e8 8c 36 d0 ff eb 24 e8 85 36 d0 ff 48 c7 c7 a8 f5 8f 88 e8 69 9b  
d8 05 48 c7 c7 e5 5c 3e 88 4c 89 f6 31 c0 e8 68 18 a3 ff <0f> 0b 48 83 c4  
60 5b 41 5c 41 5d 41 5e 41 5f 5d c3 48 c7 c7 a8 f5
RSP: 0018:ffff8880a81d75b8 EFLAGS: 00010246
RAX: 4324ba28a2c9f400 RBX: 0000000000000000 RCX: ffff8880a48ce080
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffff8880a81d7640 R08: ffffffff815cfa54 R09: ffffed1015d46088
R10: ffffed1015d46088 R11: 0000000000000000 R12: ffff88808a93f708
R13: dffffc0000000000 R14: ffffc900080f7000 R15: ffffc90008108000
  __vfree mm/vmalloc.c:2299 [inline]
  vfree+0x85/0x130 mm/vmalloc.c:2329
  ipcomp_free_scratches net/xfrm/xfrm_ipcomp.c:212 [inline]
  ipcomp_free_data+0x12a/0x1d0 net/xfrm/xfrm_ipcomp.c:321
  ipcomp_init_state+0x7bf/0x8b0 net/xfrm/xfrm_ipcomp.c:373
  ipcomp6_init_state+0xb7/0x630 net/ipv6/ipcomp6.c:153
  __xfrm_init_state+0x7d0/0xbf0 net/xfrm/xfrm_state.c:2493
  xfrm_state_construct net/xfrm/xfrm_user.c:626 [inline]
  xfrm_add_sa+0x223f/0x38e0 net/xfrm/xfrm_user.c:683
  xfrm_user_rcv_msg+0x3e6/0x650 net/xfrm/xfrm_user.c:2676
  netlink_rcv_skb+0x19e/0x3d0 net/netlink/af_netlink.c:2477
  xfrm_netlink_rcv+0x74/0x90 net/xfrm/xfrm_user.c:2684
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x787/0x900 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x993/0xc50 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:637 [inline]
  sock_sendmsg net/socket.c:657 [inline]
  ___sys_sendmsg+0x60d/0x910 net/socket.c:2311
  __sys_sendmsg net/socket.c:2356 [inline]
  __do_sys_sendmsg net/socket.c:2365 [inline]
  __se_sys_sendmsg net/socket.c:2363 [inline]
  __x64_sys_sendmsg+0x17c/0x200 net/socket.c:2363
  do_syscall_64+0xfe/0x140 arch/x86/entry/common.c:296
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x4598e9
Code: fd b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f4880699c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004598e9
RDX: 0000000000000000 RSI: 0000000020000840 RDI: 0000000000000003
RBP: 000000000075bfc8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f488069a6d4
R13: 00000000004c7812 R14: 00000000004dd0b0 R15: 00000000ffffffff
Kernel Offset: disabled
Rebooting in 86400 seconds..

