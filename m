Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA491B90D0
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 16:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgDZOJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 10:09:15 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:51044 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgDZOJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 10:09:15 -0400
Received: by mail-io1-f72.google.com with SMTP id a12so17454613ioe.17
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 07:09:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=pgeHEmJ3Yp5PttG/VcLln/3EKq6Mf1M6+5x9rIZGbsw=;
        b=am8H/PcdDWUoJ442sk7aoyVNHjdbaeHGFkt7BK870yNsmySW4o41DCkzKnLoaxOcYg
         4a3Bgvuh4vJc+STfWGK/wHFawvCMV4ohetGo4Rd7SMs9oZ6qaeJ8u1pvGKfhpz78NFQc
         ceWMKZplKtv03tLEROUTsLs85dH2BNGsZBMHiFrwZynPecEmxxCTDhr7O7zzQW2MQYFx
         hpfVxFZ7Cd0EN0AtYffSEDhr2uWzgQEkZtrGN9durcaUTSjo9iE0OxzsLVkGbv4YpZ3n
         rFM0aFT1ZxM36OzhGij0r+/5CetDuxmsoF+k4gm5Myq+ReO5JbEK7yrUbLinioyezjnn
         9QPg==
X-Gm-Message-State: AGi0PubVKHjf9bgn/UZqxR7FJfk//dPRZor41i+b3liqOogJFHBa0pWe
        b1dGunDPRHhgEjsZ01M3nVwcO8bPj5V+ifMOycncYcj6FURi
X-Google-Smtp-Source: APiQypL+PzGPwqLflshfjZEe5EdryYwoMXXQIi2SWV2/7YPKn/nYZKzHseEjYIbC6fFFALLP7S/TGK8emecnu/FlaGlICw6/MSoX
MIME-Version: 1.0
X-Received: by 2002:a5e:8e44:: with SMTP id r4mr16796312ioo.47.1587910152288;
 Sun, 26 Apr 2020 07:09:12 -0700 (PDT)
Date:   Sun, 26 Apr 2020 07:09:12 -0700
In-Reply-To: <000000000000f1377e05a3630d32@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009000aa05a4322411@google.com>
Subject: Re: KMSAN: uninit-value in sctp_ootb_pkt_new
From:   syzbot <syzbot+6751381fe5a26df5b74d@syzkaller.appspotmail.com>
To:     davem@davemloft.net, glider@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, syzkaller-bugs@googlegroups.com,
        vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    bfa90a4a kmsan: remove __GFP_NO_KMSAN_SHADOW
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=13ab7fbfe00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a5915107b3106aaa
dashboard link: https://syzkaller.appspot.com/bug?extid=6751381fe5a26df5b74d
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=138df47fe00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=158a182fe00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+6751381fe5a26df5b74d@syzkaller.appspotmail.com

batman_adv: batadv0: Interface activated: batadv_slave_1
=====================================================
BUG: KMSAN: uninit-value in __arch_swab32 arch/x86/include/uapi/asm/swab.h:10 [inline]
BUG: KMSAN: uninit-value in __fswab32 include/uapi/linux/swab.h:60 [inline]
BUG: KMSAN: uninit-value in sctp_ootb_pkt_new+0x202/0x540 net/sctp/sm_statefuns.c:6256
CPU: 0 PID: 8800 Comm: syz-executor949 Not tainted 5.6.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1c9/0x220 lib/dump_stack.c:118
 kmsan_report+0xf7/0x1e0 mm/kmsan/kmsan_report.c:118
 __msan_warning+0x58/0xa0 mm/kmsan/kmsan_instr.c:215
 __arch_swab32 arch/x86/include/uapi/asm/swab.h:10 [inline]
 __fswab32 include/uapi/linux/swab.h:60 [inline]
 sctp_ootb_pkt_new+0x202/0x540 net/sctp/sm_statefuns.c:6256
 sctp_sf_tabort_8_4_8+0xe6/0x7e0 net/sctp/sm_statefuns.c:3372
 sctp_sf_do_5_1B_init+0x6be/0x1b60 net/sctp/sm_statefuns.c:338
 sctp_do_sm+0x2b4/0x9a30 net/sctp/sm_sideeffect.c:1153
 sctp_endpoint_bh_rcv+0xd54/0xfe0 net/sctp/endpointola.c:395
 sctp_inq_push+0x300/0x420 net/sctp/inqueue.c:80
 sctp_rcv+0x48b9/0x5410 net/sctp/input.c:256
 ip_protocol_deliver_rcu+0x700/0xbc0 net/ipv4/ip_input.c:204
 ip_local_deliver_finish net/ipv4/ip_input.c:231 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ip_local_deliver+0x62a/0x7c0 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:442 [inline]
 ip_rcv_finish net/ipv4/ip_input.c:428 [inline]
 NF_HOOK include/linux/netfilter.h:307 [inline]
 ip_rcv+0x6cf/0x750 net/ipv4/ip_input.c:538
 __netif_receive_skb_one_core net/core/dev.c:5187 [inline]
 __netif_receive_skb net/core/dev.c:5301 [inline]
 netif_receive_skb_internal net/core/dev.c:5391 [inline]
 netif_receive_skb+0xbb5/0xf20 net/core/dev.c:5450
 tun_rx_batched include/linux/skbuff.h:4351 [inline]
 tun_get_user+0x6aef/0x6f60 drivers/net/tun.c:1997
 tun_chr_write_iter+0x1f2/0x360 drivers/net/tun.c:2026
 call_write_iter include/linux/fs.h:1902 [inline]
 new_sync_write fs/read_write.c:483 [inline]
 __vfs_write+0xa5a/0xca0 fs/read_write.c:496
 vfs_write+0x44a/0x8f0 fs/read_write.c:558
 ksys_write+0x267/0x450 fs/read_write.c:611
 __do_sys_write fs/read_write.c:623 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:620
 __x64_sys_write+0x4a/0x70 fs/read_write.c:620
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x443659
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b 10 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff60095968 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000000000003172 RCX: 0000000000443659
RDX: 000000000000002e RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 00007fff60095990 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000aa14 R11: 0000000000000246 R12: 656c6c616b7a7973
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Uninit was created at:
 kmsan_save_stack_with_flags mm/kmsan/kmsan.c:144 [inline]
 kmsan_internal_poison_shadow+0x66/0xd0 mm/kmsan/kmsan.c:127
 kmsan_slab_alloc+0x8a/0xe0 mm/kmsan/kmsan_hooks.c:80
 slab_alloc_node mm/slub.c:2801 [inline]
 __kmalloc_node_track_caller+0xb40/0x1200 mm/slub.c:4420
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0x2fd/0xac0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1081 [inline]
 alloc_skb_with_frags+0x18c/0xa70 net/core/skbuff.c:5764
 sock_alloc_send_pskb+0xada/0xc60 net/core/sock.c:2245
 tun_alloc_skb drivers/net/tun.c:1529 [inline]
 tun_get_user+0x10ae/0x6f60 drivers/net/tun.c:1843
 tun_chr_write_iter+0x1f2/0x360 drivers/net/tun.c:2026
 call_write_iter include/linux/fs.h:1902 [inline]
 new_sync_write fs/read_write.c:483 [inline]
 __vfs_write+0xa5a/0xca0 fs/read_write.c:496
 vfs_write+0x44a/0x8f0 fs/read_write.c:558
 ksys_write+0x267/0x450 fs/read_write.c:611
 __do_sys_write fs/read_write.c:623 [inline]
 __se_sys_write+0x92/0xb0 fs/read_write.c:620
 __x64_sys_write+0x4a/0x70 fs/read_write.c:620
 do_syscall_64+0xb8/0x160 arch/x86/entry/common.c:296
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
=====================================================

