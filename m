Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4C82D426C
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 13:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731869AbgLIMsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 07:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730929AbgLIMsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 07:48:31 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFAD5C06179C
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 04:47:50 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id e25so1543573wme.0
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 04:47:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=f4uyodH6Wctfq6D2oaw2r57qzrUM8e3H6DvrLrJdT44=;
        b=bYWottTroUD9/UnkZKLdPnri8zJqTDpGxiXS6H5y2SO/jI07m94mBJlUCjv3Z0xvVX
         DjyAOMb6+OI5LPDDVtR+k9AoXGRPX00c4TAqYLY7ZLt2MOEM+62H9jrNGFKE1mpUYA9x
         b4nvVI/u2ua/aVkxFsJKgYcj/dY1Eciz1UKsexLl6Sbm5rGcu97rg+Jwt0xdkH0PNGU5
         rEWjVsgBbmJO0t6XARt4ss5sKqeqjoqNpCOZJF6vdQtWB6j8KTZWu48hUphGZV8itYoW
         D+MFm3hE7506wgYUoBlZ8JoTbdVYKuMJGu0ffN29d/HHs6/u4lGpIkqKs41eB72/hT5C
         QaWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=f4uyodH6Wctfq6D2oaw2r57qzrUM8e3H6DvrLrJdT44=;
        b=lek201C8jungBE2Vsvt0s4wNCgWSF76vS2gopTBk6ZqZnLoDzhmp1vT/OaoWOaSGPT
         zOFzdMsR87Cn3XhSX2dwlVaGi7qFq4NG/szISduOP46A3SuOHhXGg6yoxBWEBmYlIiZ4
         l0kYXFI4yVfP5p8hue/8+kVS/Zqto8MGBCB4QVq2EQtIq5kVDvgRZuzBDIUgpKSm6U0W
         fHtF9ptm1Efp4PyG+UxEAbdzXMGgx+k+SY3ql/jwb9LdnHubzDCMlzJ1tkAWF4ZdFoy2
         40iDyuIfbwOmcKm5QiJrkDlOMH9uxJ1W70xwCazoMqCeoCqy6Zb8FlF0cVXyv3wkblSk
         SIJA==
X-Gm-Message-State: AOAM532imRy+hBPNAqv814W9qksdcOfZKTlEPi5fioJkFHCdp2x5hnaz
        /dDJojlcFlzaAWIKK9B0sOsLOqY/sTrSXw==
X-Google-Smtp-Source: ABdhPJw5EnSqdBfJYu+SP/sld9ZL/tAgcSL3khUfj80ob2TZm+ALooyI+oQiM6AhxBE4S2clF1u9FQ==
X-Received: by 2002:a1c:2182:: with SMTP id h124mr2629741wmh.25.1607518069326;
        Wed, 09 Dec 2020 04:47:49 -0800 (PST)
Received: from elver.google.com ([2a00:79e0:15:13:f693:9fff:fef4:2449])
        by smtp.gmail.com with ESMTPSA id r20sm3278166wrg.66.2020.12.09.04.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 04:47:47 -0800 (PST)
Date:   Wed, 9 Dec 2020 13:47:39 +0100
From:   Marco Elver <elver@google.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Jann Horn <jannh@google.com>, Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com>
Subject: Re: WARNING in sk_stream_kill_queues (5)
Message-ID: <X9DHa2OG6lewtfPQ@elver.google.com>
References: <000000000000b4862805b54ef573@google.com>
 <X8kLG5D+j4rT6L7A@elver.google.com>
 <CANn89iJWD5oXPLgtY47umTgo3gCGBaoy+XJfXnw1ecES_EXkCw@mail.gmail.com>
 <CANpmjNOaWbGJQ5Y=qC3cA31-R-Jy4Fbe+p=OBG5O2Amz8dLtLA@mail.gmail.com>
 <CANn89iKWf1EVZUuAHup+5ndhxvOqGopq53=vZ9yeok=DnRjggg@mail.gmail.com>
 <X8kjPIrLJUd8uQIX@elver.google.com>
 <af884a0e-5d4d-f71b-4821-b430ac196240@gmail.com>
 <CANpmjNNDKm_ObRnO_b3gH6wDYjb6_ex-KhZA5q5BRzEMgo+0xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="mA8bvRhUzsuhM5td"
Content-Disposition: inline
In-Reply-To: <CANpmjNNDKm_ObRnO_b3gH6wDYjb6_ex-KhZA5q5BRzEMgo+0xg@mail.gmail.com>
User-Agent: Mutt/2.0.2 (2020-11-20)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--mA8bvRhUzsuhM5td
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 08, 2020 at 08:06PM +0100, Marco Elver wrote:
> On Thu, 3 Dec 2020 at 19:01, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > On 12/3/20 6:41 PM, Marco Elver wrote:
> >
> > > One more experiment -- simply adding
> > >
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -207,7 +207,21 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
> > >        */
> > >       size = SKB_DATA_ALIGN(size);
> > >       size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> > > +     size = 1 << kmalloc_index(size); /* HACK */
> > >       data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
> > >
> > >
> > > also got rid of the warnings. Something must be off with some value that
> > > is computed in terms of ksize(). If not, I don't have any explanation
> > > for why the above hides the problem.
> >
> > Maybe the implementations of various macros (SKB_DATA_ALIGN and friends)
> > hae some kind of assumptions, I will double check this.
> 
> If I force kfence to return 4K sized allocations for everything, the
> warnings remain. That might suggest that it's not due to a missed
> ALIGN.
> 
> Is it possible that copies or moves are a problem? E.g. we copy
> something from kfence -> non-kfence object (or vice-versa), and
> ksize() no longer matches, then things go wrong?

I was able to narrow it down to allocations of size 640. I also narrowed
it down to 5 allocations that go through kfence that start triggering
the issue. I have attached the list of those 5 allocations with
allocation + free stacks. I'll try to go through them, maybe I get
lucky eventually. :-)

Thanks,
-- Marco

--mA8bvRhUzsuhM5td
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="suspect-allocations.log"

kfence-#0 [0xffff888436814000-0xffff88843681427f, size=640, cache=kmalloc-1k] allocated by task 5298:
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0xb8/0x3f0 net/core/skbuff.c:210
 alloc_skb_fclone include/linux/skbuff.h:1144 [inline]
 sk_stream_alloc_skb+0xd3/0x650 net/ipv4/tcp.c:888
 tcp_fragment+0x124/0xac0 net/ipv4/tcp_output.c:1569
 __tcp_retransmit_skb+0x5e3/0x1770 net/ipv4/tcp_output.c:3183
 tcp_retransmit_skb+0x2a/0x200 net/ipv4/tcp_output.c:3257
 tcp_retransmit_timer+0x958/0x1a60 net/ipv4/tcp_timer.c:527
 tcp_write_timer_handler+0x4a6/0x5d0 net/ipv4/tcp_timer.c:610
 tcp_write_timer+0x86/0x270 net/ipv4/tcp_timer.c:630
 call_timer_fn+0x145/0x510 kernel/time/timer.c:1417
 expire_timers kernel/time/timer.c:1462 [inline]
 __run_timers.part.0+0x519/0x680 kernel/time/timer.c:1731
 __run_timers kernel/time/timer.c:1712 [inline]
 run_timer_softirq+0x6f/0x110 kernel/time/timer.c:1744
 __do_softirq+0x132/0x40b kernel/softirq.c:298
 asm_call_irq_on_stack+0xf/0x20
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0x58/0x70 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0xcd/0x110 kernel/softirq.c:435
 sysvec_apic_timer_interrupt+0x38/0xd0 arch/x86/kernel/apic/apic.c:1096
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:628
 native_restore_fl arch/x86/include/asm/irqflags.h:41 [inline]
 arch_local_irq_restore arch/x86/include/asm/irqflags.h:84 [inline]
 __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:160 [inline]
 _raw_spin_unlock_irqrestore+0x20/0x40 kernel/locking/spinlock.c:191
 spin_unlock_irqrestore include/linux/spinlock.h:409 [inline]
 free_debug_processing+0x1fc/0x2e0 mm/slub.c:1255
 __slab_free+0x130/0x5b0 mm/slub.c:2991
 do_slab_free mm/slub.c:3145 [inline]
 slab_free mm/slub.c:3158 [inline]
 kfree+0x532/0x580 mm/slub.c:4156
 tomoyo_realpath_from_path+0x12b/0x3d0 security/tomoyo/realpath.c:291
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_number_perm+0x11d/0x420 security/tomoyo/file.c:723
 tomoyo_path_chmod+0x21/0x30 security/tomoyo/tomoyo.c:342
 security_path_chmod+0x87/0xc0 security/security.c:1152
 chmod_common+0xbd/0x280 fs/open.c:578
 vfs_fchmod fs/open.c:598 [inline]
 __do_sys_fchmod fs/open.c:607 [inline]
 __se_sys_fchmod fs/open.c:601 [inline]
 __x64_sys_fchmod+0xaa/0x100 fs/open.c:601
 do_syscall_64+0x34/0x80 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

freed by task 12099:
 skb_free_head net/core/skbuff.c:595 [inline]
 skb_release_data+0x499/0x4e0 net/core/skbuff.c:615
 skb_release_all net/core/skbuff.c:669 [inline]
 __kfree_skb+0x34/0x50 net/core/skbuff.c:683
 sk_wmem_free_skb include/net/sock.h:1546 [inline]
 tcp_rtx_queue_unlink_and_free include/net/tcp.h:1856 [inline]
 tcp_clean_rtx_queue net/ipv4/tcp_input.c:3251 [inline]
 tcp_ack+0x124a/0x3450 net/ipv4/tcp_input.c:3795
 tcp_rcv_established+0x367/0x10b0 net/ipv4/tcp_input.c:5858
 tcp_v4_do_rcv+0x361/0x4c0 net/ipv4/tcp_ipv4.c:1668
 sk_backlog_rcv include/net/sock.h:1010 [inline]
 __release_sock+0xd7/0x260 net/core/sock.c:2523
 release_sock+0x40/0x120 net/core/sock.c:3053
 sk_wait_data+0x127/0x2b0 net/core/sock.c:2565
 tcp_recvmsg+0x1106/0x1b60 net/ipv4/tcp.c:2181
 inet_recvmsg+0xb1/0x270 net/ipv4/af_inet.c:848
 sock_recvmsg_nosec net/socket.c:885 [inline]
 sock_recvmsg net/socket.c:903 [inline]
 sock_recvmsg net/socket.c:899 [inline]
 ____sys_recvmsg+0x2fd/0x3a0 net/socket.c:2563
 ___sys_recvmsg+0xd9/0x1b0 net/socket.c:2605
 __sys_recvmsg+0x8b/0x130 net/socket.c:2641
 __do_sys_recvmsg net/socket.c:2651 [inline]
 __se_sys_recvmsg net/socket.c:2648 [inline]
 __x64_sys_recvmsg+0x43/0x50 net/socket.c:2648
 do_syscall_64+0x34/0x80 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
---------------------------------
kfence-#1 [0xffff888436816000-0xffff88843681627f, size=640, cache=kmalloc-1k] allocated by task 29:
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0xb8/0x3f0 net/core/skbuff.c:210
 alloc_skb_fclone include/linux/skbuff.h:1144 [inline]
 sk_stream_alloc_skb+0xd3/0x650 net/ipv4/tcp.c:888
 tcp_fragment+0x124/0xac0 net/ipv4/tcp_output.c:1569
 __tcp_retransmit_skb+0x5e3/0x1770 net/ipv4/tcp_output.c:3183
 tcp_retransmit_skb+0x2a/0x200 net/ipv4/tcp_output.c:3257
 tcp_xmit_retransmit_queue.part.0+0x389/0x6f0 net/ipv4/tcp_output.c:3339
 tcp_xmit_retransmit_queue+0x36/0x40 net/ipv4/tcp_output.c:3293
 tcp_xmit_recovery net/ipv4/tcp_input.c:3652 [inline]
 tcp_xmit_recovery+0x64/0xe0 net/ipv4/tcp_input.c:3638
 tcp_ack+0x1a60/0x3450 net/ipv4/tcp_input.c:3825
 tcp_rcv_established+0x367/0x10b0 net/ipv4/tcp_input.c:5858
 tcp_v4_do_rcv+0x361/0x4c0 net/ipv4/tcp_ipv4.c:1668
 tcp_v4_rcv+0x1e29/0x20c0 net/ipv4/tcp_ipv4.c:2050
 ip_protocol_deliver_rcu+0x31/0x4f0 net/ipv4/ip_input.c:204
 ip_local_deliver_finish+0x111/0x150 net/ipv4/ip_input.c:231
 NF_HOOK include/linux/netfilter.h:301 [inline]
 NF_HOOK include/linux/netfilter.h:295 [inline]
 ip_local_deliver+0x244/0x250 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:447 [inline]
 ip_rcv_finish+0x14a/0x1d0 net/ipv4/ip_input.c:428
 NF_HOOK include/linux/netfilter.h:301 [inline]
 NF_HOOK include/linux/netfilter.h:295 [inline]
 ip_rcv+0x1c4/0x1d0 net/ipv4/ip_input.c:539
 __netif_receive_skb_one_core+0xb3/0xe0 net/core/dev.c:5316
 __netif_receive_skb+0x29/0xe0 net/core/dev.c:5430
 process_backlog+0x169/0x350 net/core/dev.c:6320
 napi_poll net/core/dev.c:6764 [inline]
 net_rx_action+0x326/0xa30 net/core/dev.c:6834
 __do_softirq+0x132/0x40b kernel/softirq.c:298
 run_ksoftirqd kernel/softirq.c:653 [inline]
 run_ksoftirqd+0x21/0x40 kernel/softirq.c:645
 smpboot_thread_fn+0x3e6/0x560 kernel/smpboot.c:165
 kthread+0x24f/0x280 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296

freed by task 13615:
 skb_free_head net/core/skbuff.c:595 [inline]
 skb_release_data+0x499/0x4e0 net/core/skbuff.c:615
 skb_release_all net/core/skbuff.c:669 [inline]
 __kfree_skb+0x34/0x50 net/core/skbuff.c:683
 sk_wmem_free_skb include/net/sock.h:1546 [inline]
 tcp_rtx_queue_unlink_and_free include/net/tcp.h:1856 [inline]
 tcp_clean_rtx_queue net/ipv4/tcp_input.c:3251 [inline]
 tcp_ack+0x124a/0x3450 net/ipv4/tcp_input.c:3795
 tcp_rcv_established+0x367/0x10b0 net/ipv4/tcp_input.c:5858
 tcp_v4_do_rcv+0x361/0x4c0 net/ipv4/tcp_ipv4.c:1668
 sk_backlog_rcv include/net/sock.h:1010 [inline]
 __release_sock+0xd7/0x260 net/core/sock.c:2523
 release_sock+0x40/0x120 net/core/sock.c:3053
 sk_wait_data+0x127/0x2b0 net/core/sock.c:2565
 tcp_recvmsg+0x1106/0x1b60 net/ipv4/tcp.c:2181
 inet_recvmsg+0xb1/0x270 net/ipv4/af_inet.c:848
 sock_recvmsg_nosec net/socket.c:885 [inline]
 sock_recvmsg net/socket.c:903 [inline]
 sock_recvmsg net/socket.c:899 [inline]
 ____sys_recvmsg+0x2fd/0x3a0 net/socket.c:2563
 ___sys_recvmsg+0xd9/0x1b0 net/socket.c:2605
 __sys_recvmsg+0x8b/0x130 net/socket.c:2641
 __do_sys_recvmsg net/socket.c:2651 [inline]
 __se_sys_recvmsg net/socket.c:2648 [inline]
 __x64_sys_recvmsg+0x43/0x50 net/socket.c:2648
 do_syscall_64+0x34/0x80 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
---------------------------------
kfence-#2 [0xffff888436818c00-0xffff888436818e7f, size=640, cache=kmalloc-1k] allocated by task 0:
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0xb8/0x3f0 net/core/skbuff.c:210
 alloc_skb include/linux/skbuff.h:1094 [inline]
 __tcp_send_ack.part.0+0x47/0x3c0 net/ipv4/tcp_output.c:3945
 __tcp_send_ack net/ipv4/tcp_output.c:3977 [inline]
 tcp_send_ack+0x47/0x50 net/ipv4/tcp_output.c:3977
 __tcp_ack_snd_check+0xb2/0x530 net/ipv4/tcp_input.c:5400
 tcp_ack_snd_check net/ipv4/tcp_input.c:5445 [inline]
 tcp_rcv_established+0x5c2/0x10b0 net/ipv4/tcp_input.c:5870
 tcp_v4_do_rcv+0x361/0x4c0 net/ipv4/tcp_ipv4.c:1668
 tcp_v4_rcv+0x1e29/0x20c0 net/ipv4/tcp_ipv4.c:2050
 ip_protocol_deliver_rcu+0x31/0x4f0 net/ipv4/ip_input.c:204
 ip_local_deliver_finish+0x111/0x150 net/ipv4/ip_input.c:231
 NF_HOOK include/linux/netfilter.h:301 [inline]
 NF_HOOK include/linux/netfilter.h:295 [inline]
 ip_local_deliver+0x244/0x250 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:447 [inline]
 ip_rcv_finish+0x14a/0x1d0 net/ipv4/ip_input.c:428
 NF_HOOK include/linux/netfilter.h:301 [inline]
 NF_HOOK include/linux/netfilter.h:295 [inline]
 ip_rcv+0x1c4/0x1d0 net/ipv4/ip_input.c:539
 __netif_receive_skb_one_core+0xb3/0xe0 net/core/dev.c:5316
 __netif_receive_skb+0x29/0xe0 net/core/dev.c:5430
 process_backlog+0x169/0x350 net/core/dev.c:6320
 napi_poll net/core/dev.c:6764 [inline]
 net_rx_action+0x326/0xa30 net/core/dev.c:6834
 __do_softirq+0x132/0x40b kernel/softirq.c:298
 asm_call_irq_on_stack+0xf/0x20
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0x58/0x70 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0xcd/0x110 kernel/softirq.c:435
 sysvec_apic_timer_interrupt+0x38/0xd0 arch/x86/kernel/apic/apic.c:1096
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:628
 native_safe_halt arch/x86/include/asm/irqflags.h:60 [inline]
 arch_safe_halt arch/x86/include/asm/irqflags.h:103 [inline]
 default_idle+0xe/0x10 arch/x86/kernel/process.c:688
 default_idle_call+0x32/0x50 kernel/sched/idle.c:98
 cpuidle_idle_call kernel/sched/idle.c:168 [inline]
 do_idle+0x207/0x270 kernel/sched/idle.c:273
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:370
 secondary_startup_64_no_verify+0xb0/0xbb

freed by task 0:
 skb_free_head net/core/skbuff.c:595 [inline]
 skb_release_data+0x499/0x4e0 net/core/skbuff.c:615
 skb_release_all net/core/skbuff.c:669 [inline]
 __kfree_skb+0x34/0x50 net/core/skbuff.c:683
 tcp_data_queue+0x1801/0x2560 net/ipv4/tcp_input.c:4927
 tcp_rcv_established+0x52c/0x10b0 net/ipv4/tcp_input.c:5867
 tcp_v4_do_rcv+0x361/0x4c0 net/ipv4/tcp_ipv4.c:1668
 tcp_v4_rcv+0x1e29/0x20c0 net/ipv4/tcp_ipv4.c:2050
 ip_protocol_deliver_rcu+0x31/0x4f0 net/ipv4/ip_input.c:204
 ip_local_deliver_finish+0x111/0x150 net/ipv4/ip_input.c:231
 NF_HOOK include/linux/netfilter.h:301 [inline]
 NF_HOOK include/linux/netfilter.h:295 [inline]
 ip_local_deliver+0x244/0x250 net/ipv4/ip_input.c:252
 dst_input include/net/dst.h:447 [inline]
 ip_rcv_finish+0x14a/0x1d0 net/ipv4/ip_input.c:428
 NF_HOOK include/linux/netfilter.h:301 [inline]
 NF_HOOK include/linux/netfilter.h:295 [inline]
 ip_rcv+0x1c4/0x1d0 net/ipv4/ip_input.c:539
 __netif_receive_skb_one_core+0xb3/0xe0 net/core/dev.c:5316
 __netif_receive_skb+0x29/0xe0 net/core/dev.c:5430
 process_backlog+0x169/0x350 net/core/dev.c:6320
 napi_poll net/core/dev.c:6764 [inline]
 net_rx_action+0x326/0xa30 net/core/dev.c:6834
 __do_softirq+0x132/0x40b kernel/softirq.c:298
 asm_call_irq_on_stack+0xf/0x20
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0x58/0x70 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0xcd/0x110 kernel/softirq.c:435
 sysvec_apic_timer_interrupt+0x38/0xd0 arch/x86/kernel/apic/apic.c:1096
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:628
 native_safe_halt arch/x86/include/asm/irqflags.h:60 [inline]
 arch_safe_halt arch/x86/include/asm/irqflags.h:103 [inline]
 default_idle+0xe/0x10 arch/x86/kernel/process.c:688
 default_idle_call+0x32/0x50 kernel/sched/idle.c:98
 cpuidle_idle_call kernel/sched/idle.c:168 [inline]
 do_idle+0x207/0x270 kernel/sched/idle.c:273
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:370
 secondary_startup_64_no_verify+0xb0/0xbb
---------------------------------
kfence-#3 [0xffff88843681ac00-0xffff88843681ae7f, size=640, cache=kmalloc-1k] allocated by task 17012:
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0xb8/0x3f0 net/core/skbuff.c:210
 alloc_skb_fclone include/linux/skbuff.h:1144 [inline]
 sk_stream_alloc_skb+0xd3/0x650 net/ipv4/tcp.c:888
 tso_fragment net/ipv4/tcp_output.c:2124 [inline]
 tcp_write_xmit+0x1366/0x3510 net/ipv4/tcp_output.c:2674
 __tcp_push_pending_frames+0x68/0x1f0 net/ipv4/tcp_output.c:2866
 tcp_push_pending_frames include/net/tcp.h:1864 [inline]
 tcp_data_snd_check net/ipv4/tcp_input.c:5374 [inline]
 tcp_rcv_established+0x57c/0x10b0 net/ipv4/tcp_input.c:5869
 tcp_v4_do_rcv+0x361/0x4c0 net/ipv4/tcp_ipv4.c:1668
 sk_backlog_rcv include/net/sock.h:1010 [inline]
 __release_sock+0xd7/0x260 net/core/sock.c:2523
 release_sock+0x40/0x120 net/core/sock.c:3053
 sk_wait_data+0x127/0x2b0 net/core/sock.c:2565
 tcp_recvmsg+0x1106/0x1b60 net/ipv4/tcp.c:2181
 inet_recvmsg+0xb1/0x270 net/ipv4/af_inet.c:848
 sock_recvmsg_nosec net/socket.c:885 [inline]
 sock_recvmsg net/socket.c:903 [inline]
 sock_recvmsg net/socket.c:899 [inline]
 ____sys_recvmsg+0x2fd/0x3a0 net/socket.c:2563
 ___sys_recvmsg+0xd9/0x1b0 net/socket.c:2605
 __sys_recvmsg+0x8b/0x130 net/socket.c:2641
 __do_sys_recvmsg net/socket.c:2651 [inline]
 __se_sys_recvmsg net/socket.c:2648 [inline]
 __x64_sys_recvmsg+0x43/0x50 net/socket.c:2648
 do_syscall_64+0x34/0x80 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

freed by task 17012:
 skb_free_head net/core/skbuff.c:595 [inline]
 skb_release_data+0x499/0x4e0 net/core/skbuff.c:615
 skb_release_all net/core/skbuff.c:669 [inline]
 __kfree_skb+0x34/0x50 net/core/skbuff.c:683
 tcp_drop net/ipv4/tcp_input.c:4618 [inline]
 tcp_prune_ofo_queue+0x14b/0x3e0 net/ipv4/tcp_input.c:5250
 tcp_prune_queue net/ipv4/tcp_input.c:5307 [inline]
 tcp_try_rmem_schedule+0x9a2/0xbc0 net/ipv4/tcp_input.c:4680
 tcp_data_queue_ofo net/ipv4/tcp_input.c:4701 [inline]
 tcp_data_queue+0x2dd/0x2560 net/ipv4/tcp_input.c:5015
 tcp_rcv_established+0x52c/0x10b0 net/ipv4/tcp_input.c:5867
 tcp_v4_do_rcv+0x361/0x4c0 net/ipv4/tcp_ipv4.c:1668
 sk_backlog_rcv include/net/sock.h:1010 [inline]
 __release_sock+0xd7/0x260 net/core/sock.c:2523
 release_sock+0x40/0x120 net/core/sock.c:3053
 sk_wait_data+0x127/0x2b0 net/core/sock.c:2565
 tcp_recvmsg+0x1106/0x1b60 net/ipv4/tcp.c:2181
 inet_recvmsg+0xb1/0x270 net/ipv4/af_inet.c:848
 sock_recvmsg_nosec net/socket.c:885 [inline]
 sock_recvmsg net/socket.c:903 [inline]
 sock_recvmsg net/socket.c:899 [inline]
 ____sys_recvmsg+0x2fd/0x3a0 net/socket.c:2563
 ___sys_recvmsg+0xd9/0x1b0 net/socket.c:2605
 __sys_recvmsg+0x8b/0x130 net/socket.c:2641
 __do_sys_recvmsg net/socket.c:2651 [inline]
 __se_sys_recvmsg net/socket.c:2648 [inline]
 __x64_sys_recvmsg+0x43/0x50 net/socket.c:2648
 do_syscall_64+0x34/0x80 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
---------------------------------
kfence-#4 [0xffff88843681c000-0xffff88843681c27f, size=640, cache=kmalloc-1k] allocated by task 0:
 __kmalloc_reserve net/core/skbuff.c:142 [inline]
 __alloc_skb+0xb8/0x3f0 net/core/skbuff.c:210
 alloc_skb_fclone include/linux/skbuff.h:1144 [inline]
 sk_stream_alloc_skb+0xd3/0x650 net/ipv4/tcp.c:888
 tso_fragment net/ipv4/tcp_output.c:2124 [inline]
 tcp_write_xmit+0x1366/0x3510 net/ipv4/tcp_output.c:2674
 tcp_send_loss_probe+0x337/0x4c0 net/ipv4/tcp_output.c:2804
 tcp_write_timer_handler+0x4d4/0x5d0 net/ipv4/tcp_timer.c:606
 tcp_write_timer+0x86/0x270 net/ipv4/tcp_timer.c:630
 call_timer_fn+0x145/0x510 kernel/time/timer.c:1417
 expire_timers kernel/time/timer.c:1462 [inline]
 __run_timers.part.0+0x519/0x680 kernel/time/timer.c:1731
 __run_timers kernel/time/timer.c:1712 [inline]
 run_timer_softirq+0x6f/0x110 kernel/time/timer.c:1744
 __do_softirq+0x132/0x40b kernel/softirq.c:298
 asm_call_irq_on_stack+0xf/0x20
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:26 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:77 [inline]
 do_softirq_own_stack+0x58/0x70 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0xcd/0x110 kernel/softirq.c:435
 sysvec_apic_timer_interrupt+0x38/0xd0 arch/x86/kernel/apic/apic.c:1096
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:628
 native_safe_halt arch/x86/include/asm/irqflags.h:60 [inline]
 arch_safe_halt arch/x86/include/asm/irqflags.h:103 [inline]
 default_idle+0xe/0x10 arch/x86/kernel/process.c:688
 default_idle_call+0x32/0x50 kernel/sched/idle.c:98
 cpuidle_idle_call kernel/sched/idle.c:168 [inline]
 do_idle+0x207/0x270 kernel/sched/idle.c:273
 cpu_startup_entry+0x14/0x20 kernel/sched/idle.c:370
 secondary_startup_64_no_verify+0xb0/0xbb

freed by task 17200:
 skb_free_head net/core/skbuff.c:595 [inline]
 skb_release_data+0x499/0x4e0 net/core/skbuff.c:615
 skb_release_all net/core/skbuff.c:669 [inline]
 __kfree_skb+0x34/0x50 net/core/skbuff.c:683
 sk_wmem_free_skb include/net/sock.h:1546 [inline]
 tcp_rtx_queue_unlink_and_free include/net/tcp.h:1856 [inline]
 tcp_shifted_skb+0x4f8/0x960 net/ipv4/tcp_input.c:1464
 tcp_shift_skb_data net/ipv4/tcp_input.c:1607 [inline]
 tcp_sacktag_walk+0x7e0/0xc40 net/ipv4/tcp_input.c:1670
 tcp_sacktag_write_queue+0xd5e/0x1b50 net/ipv4/tcp_input.c:1931
 tcp_ack+0x1fcd/0x3450 net/ipv4/tcp_input.c:3758
 tcp_rcv_established+0x367/0x10b0 net/ipv4/tcp_input.c:5858
 tcp_v4_do_rcv+0x361/0x4c0 net/ipv4/tcp_ipv4.c:1668
 sk_backlog_rcv include/net/sock.h:1010 [inline]
 __release_sock+0xd7/0x260 net/core/sock.c:2523
 release_sock+0x40/0x120 net/core/sock.c:3053
 sk_wait_data+0x127/0x2b0 net/core/sock.c:2565
 tcp_recvmsg+0x1106/0x1b60 net/ipv4/tcp.c:2181
 inet_recvmsg+0xb1/0x270 net/ipv4/af_inet.c:848
 sock_recvmsg_nosec net/socket.c:885 [inline]
 sock_recvmsg net/socket.c:903 [inline]
 sock_recvmsg net/socket.c:899 [inline]
 ____sys_recvmsg+0x2fd/0x3a0 net/socket.c:2563
 ___sys_recvmsg+0xd9/0x1b0 net/socket.c:2605
 __sys_recvmsg+0x8b/0x130 net/socket.c:2641
 __do_sys_recvmsg net/socket.c:2651 [inline]
 __se_sys_recvmsg net/socket.c:2648 [inline]
 __x64_sys_recvmsg+0x43/0x50 net/socket.c:2648
 do_syscall_64+0x34/0x80 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

--mA8bvRhUzsuhM5td--
