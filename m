Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADF41B2F95
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 20:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgDUSwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 14:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725870AbgDUSwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 14:52:05 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1F8C0610D5
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 11:52:05 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id b17so7689504ybq.13
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 11:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ojSG6SZB+aaV0XNDscAKucTJpNfMEa84CUZE5edEVdQ=;
        b=GZ5/bn2FRwg+/7Cavm7YF/LVfGtD5C7A84ImqVwOmA4Z9CsVfMHO3qs/vxX7G3VTiR
         0JqeRZIwgL5qMFdLEpGWwImntDKxnxuvWb1JP4g5VuPUErDUENiImv4Zx6CxM/g5ut8m
         e253DMxZ5kOsQ59A56FqLSfqP5XckwWQOwel5E8lLrL2P38dw+n04hFsUjDaRnfEBNL6
         0OmGrTCPxcTn+qp/mITeWvsEVVDvcwT7kwop1TMtyB2DNB2YzfTS6pnTxLzsvegDJYKf
         Bq4LgADhIMeN9YRz4wI7XjYElNBd6KD9NYTxBL3/Ts5VtjdPyNKwko5UZ7Jv9o/AT7cg
         EUrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ojSG6SZB+aaV0XNDscAKucTJpNfMEa84CUZE5edEVdQ=;
        b=jG6gIj7ja/P2/8KGKnMLQuT1L8w4XQmtMqhpIiEh0ikpYEDM4pSD8OzyS/RcB5aeLY
         u1Xf1tElAMnRcph++/gtER+CNLzsFZAhRc994bRgdUozjxN+FocMx7MNswxEqVywtNVy
         p56r9nHHUvim0Rf3uaQHA2Y4yhgJOSZi/ZgC7hjqbhxnZXtmVVWfmlQKP58eFKrdmvvZ
         maT5Uu4KFxsOQ2vYp/D1Jw5FeUgafk6IESa/mDkGA6mMdBMDj/ffLasmMQ/mMGEJ5Isr
         /YwMXrypVwAqVi+jBV/62Mj8kTw/JUBLnORRV4kgWxlXpaZ6SaM1UUzxIYuUAqd/17wP
         giCQ==
X-Gm-Message-State: AGi0PubwSQLVbH6eFSsK9sV9yjq3gMYJ/I6lfF0M/VQi3EkvI14axZ+J
        Ax4C/uF8K+q3N6JOs2TgKyN8bZZ708uboiS4uRsSDA==
X-Google-Smtp-Source: APiQypIyDfYI5nYD3zhhKv4bN3i1hyqtctxkiA7vFr4zv1z9dzcMpVdaEwWf+8PSyYOzUdIeWlT6RzCIVVD+IbhMUec=
X-Received: by 2002:a25:6f86:: with SMTP id k128mr27804111ybc.520.1587495124302;
 Tue, 21 Apr 2020 11:52:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200421170028.153025-1-edumazet@google.com> <877dy84ra2.fsf@intel.com>
In-Reply-To: <877dy84ra2.fsf@intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 21 Apr 2020 11:51:52 -0700
Message-ID: <CANn89iK2DXJKGLcRHsskYa+4ACVmUtWnCws8ourPedgqzRHUzQ@mail.gmail.com>
Subject: Re: [PATCH net] sched: etf: do not assume all sockets are full blown
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 21, 2020 at 11:39 AM Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> Hi Eric,
>
> Eric Dumazet <edumazet@google.com> writes:
>
> > skb->sk does not always point to a full blown socket,
> > we need to use sk_fullsock() before accessing fields which
> > only make sense on full socket.
> >
> > BUG: KASAN: use-after-free in report_sock_error+0x286/0x300 net/sched/sch_etf.c:141
> > Read of size 1 at addr ffff88805eb9b245 by task syz-executor.5/9630
> >
> > CPU: 1 PID: 9630 Comm: syz-executor.5 Not tainted 5.7.0-rc2-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> >  <IRQ>
> >  __dump_stack lib/dump_stack.c:77 [inline]
> >  dump_stack+0x188/0x20d lib/dump_stack.c:118
> >  print_address_description.constprop.0.cold+0xd3/0x315 mm/kasan/report.c:382
> >  __kasan_report.cold+0x35/0x4d mm/kasan/report.c:511
> >  kasan_report+0x33/0x50 mm/kasan/common.c:625
> >  report_sock_error+0x286/0x300 net/sched/sch_etf.c:141
> >  etf_enqueue_timesortedlist+0x389/0x740 net/sched/sch_etf.c:170
> >  __dev_xmit_skb net/core/dev.c:3710 [inline]
> >  __dev_queue_xmit+0x154a/0x30a0 net/core/dev.c:4021
> >  neigh_hh_output include/net/neighbour.h:499 [inline]
> >  neigh_output include/net/neighbour.h:508 [inline]
> >  ip6_finish_output2+0xfb5/0x25b0 net/ipv6/ip6_output.c:117
> >  __ip6_finish_output+0x442/0xab0 net/ipv6/ip6_output.c:143
> >  ip6_finish_output+0x34/0x1f0 net/ipv6/ip6_output.c:153
> >  NF_HOOK_COND include/linux/netfilter.h:296 [inline]
> >  ip6_output+0x239/0x810 net/ipv6/ip6_output.c:176
> >  dst_output include/net/dst.h:435 [inline]
> >  NF_HOOK include/linux/netfilter.h:307 [inline]
> >  NF_HOOK include/linux/netfilter.h:301 [inline]
> >  ip6_xmit+0xe1a/0x2090 net/ipv6/ip6_output.c:280
> >  tcp_v6_send_synack+0x4e7/0x960 net/ipv6/tcp_ipv6.c:521
> >  tcp_rtx_synack+0x10d/0x1a0 net/ipv4/tcp_output.c:3916
> >  inet_rtx_syn_ack net/ipv4/inet_connection_sock.c:669 [inline]
> >  reqsk_timer_handler+0x4c2/0xb40 net/ipv4/inet_connection_sock.c:763
> >  call_timer_fn+0x1ac/0x780 kernel/time/timer.c:1405
> >  expire_timers kernel/time/timer.c:1450 [inline]
> >  __run_timers kernel/time/timer.c:1774 [inline]
> >  __run_timers kernel/time/timer.c:1741 [inline]
> >  run_timer_softirq+0x623/0x1600 kernel/time/timer.c:1787
> >  __do_softirq+0x26c/0x9f7 kernel/softirq.c:292
> >  invoke_softirq kernel/softirq.c:373 [inline]
> >  irq_exit+0x192/0x1d0 kernel/softirq.c:413
> >  exiting_irq arch/x86/include/asm/apic.h:546 [inline]
> >  smp_apic_timer_interrupt+0x19e/0x600 arch/x86/kernel/apic/apic.c:1140
> >  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
> >  </IRQ>
> > RIP: 0010:des_encrypt+0x157/0x9c0 lib/crypto/des.c:792
> > Code: 85 22 06 00 00 41 31 dc 41 8b 4d 04 44 89 e2 41 83 e4 3f 4a 8d 3c a5 60 72 72 88 81 e2 3f 3f 3f 3f 48 89 f8 48 c1 e8 03 31 d9 <0f> b6 34 28 48 89 f8 c1 c9 04 83 e0 07 83 c0 03 40 38 f0 7c 09 40
> > RSP: 0018:ffffc90003b5f6c0 EFLAGS: 00000282 ORIG_RAX: ffffffffffffff13
> > RAX: 1ffffffff10e4e55 RBX: 00000000d2f846d0 RCX: 00000000d2f846d0
> > RDX: 0000000012380612 RSI: ffffffff839863ca RDI: ffffffff887272a8
> > RBP: dffffc0000000000 R08: ffff888091d0a380 R09: 0000000000800081
> > R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000012
> > R13: ffff8880a8ae8078 R14: 00000000c545c93e R15: 0000000000000006
> >  cipher_crypt_one crypto/cipher.c:75 [inline]
> >  crypto_cipher_encrypt_one+0x124/0x210 crypto/cipher.c:82
> >  crypto_cbcmac_digest_update+0x1b5/0x250 crypto/ccm.c:830
> >  crypto_shash_update+0xc4/0x120 crypto/shash.c:119
> >  shash_ahash_update+0xa3/0x110 crypto/shash.c:246
> >  crypto_ahash_update include/crypto/hash.h:547 [inline]
> >  hash_sendmsg+0x518/0xad0 crypto/algif_hash.c:102
> >  sock_sendmsg_nosec net/socket.c:652 [inline]
> >  sock_sendmsg+0xcf/0x120 net/socket.c:672
> >  ____sys_sendmsg+0x308/0x7e0 net/socket.c:2362
> >  ___sys_sendmsg+0x100/0x170 net/socket.c:2416
> >  __sys_sendmmsg+0x195/0x480 net/socket.c:2506
> >  __do_sys_sendmmsg net/socket.c:2535 [inline]
> >  __se_sys_sendmmsg net/socket.c:2532 [inline]
> >  __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2532
> >  do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
> >  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> > RIP: 0033:0x45c829
> > Code: 0d b7 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> > RSP: 002b:00007f6d9528ec78 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> > RAX: ffffffffffffffda RBX: 00000000004fc080 RCX: 000000000045c829
> > RDX: 0000000000000001 RSI: 0000000020002640 RDI: 0000000000000004
> > RBP: 000000000078bf00 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
> > R13: 00000000000008d7 R14: 00000000004cb7aa R15: 00007f6d9528f6d4
> >
> > Fixes: 4b15c7075352 ("net/sched: Make etf report drops on error_queue")
> > Fixes: 25db26a91364 ("net/sched: Introduce the ETF Qdisc")
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> > ---
>
> Reviewed-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>
> I am curious about the repro program, do you have it? There might be
> other bugs like this in hiding.

Unfortunately, I don't have any reproducer for this crash yet.

Thanks.
