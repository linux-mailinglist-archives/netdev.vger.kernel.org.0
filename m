Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE0A40A8CB
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 10:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbhINIH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 04:07:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57655 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230027AbhINIDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 04:03:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631606535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RCW3shkd8lW9L0JeWL8nsxjNmCWFji7UqRY7myVEPkY=;
        b=Z0O1lZsJyewYI2xV48IIGavuB+hvsIiWEb4WRDkNX+4vcyTtJKQ+uq+aY2wa3IyLdXeztG
        XOVIIJInYO01vQTIlBDSyEqI8Q0U04PB0wXj4g0KjeHMlL9hSI2ROToQzrGzyXsJWAjzz5
        YnlTaXKlzw+koTDGLhnggtWrcBotmGY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-FJqYI6s9MV6sO6dY1pHdnA-1; Tue, 14 Sep 2021 04:02:13 -0400
X-MC-Unique: FJqYI6s9MV6sO6dY1pHdnA-1
Received: by mail-wm1-f71.google.com with SMTP id j21-20020a05600c1c1500b00300f1679e4dso398175wms.4
        for <netdev@vger.kernel.org>; Tue, 14 Sep 2021 01:02:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RCW3shkd8lW9L0JeWL8nsxjNmCWFji7UqRY7myVEPkY=;
        b=hcFexWS0u+ow8J5C9GerovH7H2DY0SFz9r4BqD+KEZNqorN/zVthYDoDea4ISktpgE
         fYv2OtSGgm73l8qq+LkWoJ7F6288ofj95d2C2+PgoPdbJ5D50SP+W7lVhPF4MhgkyZ3i
         Mc5G/mrsPH5At320PdygVWiU/G/F18n6SZkAUvZW5lDXNmDZuiVMg+8QZm8VcFFywhgO
         XNry1wgfu58O2HLYTyA3Sbey+SCwI8NuMaBZO4VGWnA+jjAs7c4Rasg+Xk2fPzTo+eoV
         wQd1qeHbJeK3xbSIOyD0U+rOA+sDATRiTL25ap0rXvaNzGlTqEq4pX4WLPhguTjzGNMS
         IfXg==
X-Gm-Message-State: AOAM533WV2w/5hjWyXOH5nmpCioY5hOpmkzgsTFTrkmlDVb0yPH+F/ca
        MDU1CJGFlFDffTt9vrsuyQy+UFOIqHlY9Od//Q/Zr6QFPSvvwkRyBWmA3OsZHMaOpfGt7YOzIFi
        jiYup4b9qzeJGDK6e
X-Received: by 2002:a1c:23cb:: with SMTP id j194mr667917wmj.1.1631606532353;
        Tue, 14 Sep 2021 01:02:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyTNvOQdqVrix3ihVaPsJf5FnzJHbntYLrKPjv0dTVExHYaSlBuPrXfnTuO0RPqhzoL6+iPdA==
X-Received: by 2002:a1c:23cb:: with SMTP id j194mr667890wmj.1.1631606532089;
        Tue, 14 Sep 2021 01:02:12 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id b16sm9795635wrp.82.2021.09.14.01.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 01:02:08 -0700 (PDT)
Date:   Tue, 14 Sep 2021 10:02:06 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Urgent  Bug report: PPPoE ioctl(PPPIOCCONNECT): Transport
 endpoint is not connected
Message-ID: <20210914080206.GA20454@pc-4.home>
References: <08EC1CDD-21C4-41AB-B6A8-1CC2D40F5C05@gmail.com>
 <20210808152318.6nbbaj3bp6tpznel@pali>
 <8BDDA0B3-0BEE-4E80-9686-7F66CF58B069@gmail.com>
 <20210809151529.ymbq53f633253loz@pali>
 <FFD368DF-4C89-494B-8E7B-35C2A139E277@gmail.com>
 <20210811164835.GB15488@pc-32.home>
 <81FD1346-8CE6-4080-84C9-705E2E5E69C0@gmail.com>
 <6A3B4C11-EF48-4CE9-9EC7-5882E330D7EA@gmail.com>
 <A16DCD3E-43AA-4D50-97FC-EBB776481840@gmail.com>
 <E95FDB1D-488B-4780-96A1-A2D5C9616A7A@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E95FDB1D-488B-4780-96A1-A2D5C9616A7A@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 09:16:55AM +0300, Martin Zaharinov wrote:
> Hi Nault
> 
> See this stats :
> 
> Linux 5.14.2 (testb)   09/14/21        _x86_64_        (12 CPU)
> 
> 11:33:44     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
> 11:33:45     all    1.75    0.00   18.85    0.00    0.00    5.00    0.00    0.00    0.00   74.40
> 11:33:46     all    1.74    0.00   17.88    0.00    0.00    4.72    0.00    0.00    0.00   75.66
> 11:33:47     all    2.23    0.00   17.62    0.00    0.00    5.05    0.00    0.00    0.00   75.10
> 11:33:48     all    1.82    0.00   13.64    0.00    0.00    5.70    0.00    0.00    0.00   78.84
> 11:33:49     all    1.50    0.00   13.46    0.00    0.00    5.15    0.00    0.00    0.00   79.90
> 11:33:50     all    3.06    0.00   13.96    0.00    0.00    4.79    0.00    0.00    0.00   78.20
> 11:33:51     all    1.40    0.00   16.53    0.00    0.00    5.21    0.00    0.00    0.00   76.86
> 11:33:52     all    4.43    0.00   19.44    0.00    0.00    6.56    0.00    0.00    0.00   69.57
> 11:33:53     all    1.51    0.00   16.40    0.00    0.00    4.77    0.00    0.00    0.00   77.32
> 11:33:54     all    1.51    0.00   16.55    0.00    0.00    4.71    0.00    0.00    0.00   77.23
> 11:33:55     all    1.00    0.00   13.21    0.00    0.00    5.90    0.00    0.00    0.00   79.90
> Average:     all    2.00    0.00   16.14    0.00    0.00    5.23    0.00    0.00    0.00   76.63
> 
> 
>   PerfTop:   28046 irqs/sec  kernel:96.3%  exact: 100.0% lost: 0/0 drop: 0/0 [4000Hz cycles],  (all, 12 CPUs)
> ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
> 
>     23.37%  [nf_conntrack]           [k] nf_ct_iterate_cleanup
>     17.76%  [kernel]                 [k] mutex_spin_on_owner
>      9.47%  [pppoe]                  [k] pppoe_rcv
>      7.71%  [kernel]                 [k] osq_lock
>      2.77%  [nf_nat]                 [k] inet_cmp
>      2.59%  [nf_nat]                 [k] device_cmp
>      2.55%  [kernel]                 [k] __local_bh_enable_ip
>      2.04%  [kernel]                 [k] _raw_spin_lock
>      1.23%  [kernel]                 [k] __cond_resched
>      1.16%  [kernel]                 [k] rcu_all_qs
>      1.13%  libfrr.so.0.0.0          [.] 0x00000000000ce970
>      0.79%  [nf_conntrack]           [k] nf_conntrack_lock
>      0.75%  libfrr.so.0.0.0          [.] 0x00000000000ce94e
>      0.53%  [kernel]                 [k] __netif_receive_skb_core.constprop.0
>      0.46%  [kernel]                 [k] fib_table_lookup
>      0.46%  [ip_tables]              [k] ipt_do_table
>      0.45%  [ixgbe]                  [k] ixgbe_clean_rx_irq
>      0.37%  [kernel]                 [k] __dev_queue_xmit
>      0.34%  [nf_conntrack]           [k] __nf_conntrack_find_get.isra.0
>      0.33%  [ixgbe]                  [k] ixgbe_clean_tx_irq
>      0.30%  [kernel]                 [k] menu_select
>      0.25%  [kernel]                 [k] vlan_do_receive
>      0.21%  [kernel]                 [k] ip_finish_output2
>      0.21%  [ixgbe]                  [k] ixgbe_poll
>      0.20%  [kernel]                 [k] _raw_spin_lock_irqsave
>      0.19%  [kernel]                 [k] get_rps_cpu
>      0.19%  libc.so.6                [.] 0x0000000000186afa
>      0.19%  [kernel]                 [k] queued_read_lock_slowpath
>      0.19%  [kernel]                 [k] do_poll.constprop.0
>      0.19%  [kernel]                 [k] cpuidle_enter_state
>      0.18%  [kernel]                 [k] dev_hard_start_xmit
>      0.18%  [kernel]                 [k] ___slab_alloc.constprop.0
>      0.17%  zebra                    [.] 0x00000000000b9271
>      0.16%  [kernel]                 [k] csum_partial_copy_generic
>      0.16%  zebra                    [.] 0x00000000000b91f1
>      0.16%  [kernel]                 [k] page_frag_free
>      0.16%  [kernel]                 [k] kmem_cache_alloc
>      0.15%  [kernel]                 [k] __skb_flow_dissect
>      0.15%  [kernel]                 [k] sched_clock
>      0.15%  libc.so.6                [.] 0x00000000000965a2
>      0.15%  [kernel]                 [k] kmem_cache_free_bulk.part.0
>      0.15%  [pppoe]                  [k] pppoe_flush_dev
>      0.15%  [ixgbe]                  [k] ixgbe_tx_map
>      0.14%  [kernel]                 [k] _raw_spin_lock_bh
>      0.14%  [kernel]                 [k] fib_table_flush
>      0.14%  [kernel]                 [k] native_irq_return_iret
>      0.14%  [kernel]                 [k] __dev_xmit_skb
>      0.13%  [kernel]                 [k] nf_hook_slow
>      0.13%  [kernel]                 [k] fib_lookup_good_nhc
>      0.12%  [kernel]                 [k] __fget_files
>      0.12%  [kernel]                 [k] process_backlog
>      0.12%  [xt_dtvqos]              [k] 0x00000000000008d1
>      0.12%  [kernel]                 [k] __list_del_entry_valid
>      0.12%  [kernel]                 [k] skb_release_data
>      0.12%  [kernel]                 [k] ip_route_input_slow
>      0.11%  [kernel]                 [k] netif_skb_features
>      0.11%  [kernel]                 [k] sock_poll
>      0.11%  [kernel]                 [k] __schedule
>      0.11%  [kernel]                 [k] __softirqentry_text_start
> 
> 
> And on time of problem when try to write : ip a 
> to list interface wait 15-20 sec i finaly have options to simulate but users is angry when down internet.

Probably some contention on the rtnl lock.

> In case need to know why system is overloaded when deconfig ppp interface.

Does it help if you disable conntrack?

> 
> Best regards,
> Martin
> 
> 
> 
> 
> > On 11 Sep 2021, at 9:26, Martin Zaharinov <micron10@gmail.com> wrote:
> > 
> > Hi Guillaume
> > 
> > Main problem is overload of service because have many finishing ppp (customer) last two day down from 40-50 to 100-200 users and make problem when is happen if try to type : ip a wait 10-20 sec to start list interface .
> > But how to find where is a problem any locking or other.
> > And is there options to make fast remove ppp interface from kernel to reduce this load.
> > 
> > 
> > Martin
> > 
> >> On 7 Sep 2021, at 9:42, Martin Zaharinov <micron10@gmail.com> wrote:
> >> 
> >> Perf top from text
> >> 
> >> 
> >> PerfTop:   28391 irqs/sec  kernel:98.0%  exact: 100.0% lost: 0/0 drop: 0/0 [4000Hz cycles],  (all, 12 CPUs)
> >> ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
> >> 
> >>   17.01%  [nf_conntrack]           [k] nf_ct_iterate_cleanup
> >>    9.73%  [kernel]                 [k] mutex_spin_on_owner
> >>    9.07%  [pppoe]                  [k] pppoe_rcv
> >>    2.77%  [nf_nat]                 [k] device_cmp
> >>    1.66%  [kernel]                 [k] osq_lock
> >>    1.65%  [kernel]                 [k] _raw_spin_lock
> >>    1.61%  [kernel]                 [k] __local_bh_enable_ip
> >>    1.35%  [nf_nat]                 [k] inet_cmp
> >>    1.30%  [kernel]                 [k] __netif_receive_skb_core.constprop.0
> >>    1.16%  [kernel]                 [k] menu_select
> >>    0.99%  [kernel]                 [k] cpuidle_enter_state
> >>    0.96%  [ixgbe]                  [k] ixgbe_clean_rx_irq
> >>    0.86%  [kernel]                 [k] __dev_queue_xmit
> >>    0.70%  [kernel]                 [k] __cond_resched
> >>    0.69%  [sch_cake]               [k] cake_dequeue
> >>    0.67%  [nf_tables]              [k] nft_do_chain
> >>    0.63%  [kernel]                 [k] rcu_all_qs
> >>    0.61%  [kernel]                 [k] fib_table_lookup
> >>    0.57%  [kernel]                 [k] __schedule
> >>    0.57%  [kernel]                 [k] skb_release_data
> >>    0.54%  [kernel]                 [k] sched_clock
> >>    0.54%  [kernel]                 [k] __copy_skb_header
> >>    0.53%  [kernel]                 [k] dev_queue_xmit_nit
> >>    0.53%  [kernel]                 [k] _raw_spin_lock_irqsave
> >>    0.50%  [kernel]                 [k] kmem_cache_free
> >>    0.48%  libfrr.so.0.0.0          [.] 0x00000000000ce970
> >>    0.47%  [ixgbe]                  [k] ixgbe_clean_tx_irq
> >>    0.45%  [kernel]                 [k] timerqueue_add
> >>    0.45%  [kernel]                 [k] lapic_next_deadline
> >>    0.45%  [kernel]                 [k] csum_partial_copy_generic
> >>    0.44%  [nf_flow_table]          [k] nf_flow_offload_ip_hook
> >>    0.44%  [kernel]                 [k] kmem_cache_alloc
> >>    0.44%  [nf_conntrack]           [k] nf_conntrack_lock
> >> 
> >>> On 7 Sep 2021, at 9:16, Martin Zaharinov <micron10@gmail.com> wrote:
> >>> 
> >>> Hi 
> >>> Sorry for delay but not easy to catch moment .
> >>> 
> >>> 
> >>> See this is mpstatl 1 :
> >>> 
> >>> Linux 5.14.1 (demobng) 	09/07/21 	_x86_64_	(12 CPU)
> >>> 
> >>> 11:12:16     CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
> >>> 11:12:17     all    0.17    0.00    6.66    0.00    0.00    4.13    0.00    0.00    0.00   89.05
> >>> 11:12:18     all    0.25    0.00    8.36    0.00    0.00    4.88    0.00    0.00    0.00   86.51
> >>> 11:12:19     all    0.26    0.00    9.62    0.00    0.00    3.91    0.00    0.00    0.00   86.21
> >>> 11:12:20     all    0.85    0.00    6.00    0.00    0.00    4.31    0.00    0.00    0.00   88.84
> >>> 11:12:21     all    0.08    0.00    4.45    0.00    0.00    4.79    0.00    0.00    0.00   90.67
> >>> 11:12:22     all    0.17    0.00    9.50    0.00    0.00    4.58    0.00    0.00    0.00   85.75
> >>> 11:12:23     all    0.00    0.00    6.92    0.00    0.00    2.48    0.00    0.00    0.00   90.61
> >>> 11:12:24     all    0.17    0.00    5.45    0.00    0.00    4.27    0.00    0.00    0.00   90.11
> >>> 11:12:25     all    0.25    0.00    5.38    0.00    0.00    4.79    0.00    0.00    0.00   89.58
> >>> 11:12:26     all    0.60    0.00    1.45    0.00    0.00    2.65    0.00    0.00    0.00   95.30
> >>> 11:12:27     all    0.42    0.00    6.91    0.00    0.00    4.47    0.00    0.00    0.00   88.20
> >>> 11:12:28     all    0.00    0.00    6.75    0.00    0.00    4.18    0.00    0.00    0.00   89.07
> >>> 11:12:29     all    0.17    0.00    3.52    0.00    0.00    5.11    0.00    0.00    0.00   91.20
> >>> 11:12:30     all    1.45    0.00   10.14    0.00    0.00    3.49    0.00    0.00    0.00   84.92
> >>> 11:12:31     all    0.09    0.00    5.11    0.00    0.00    4.77    0.00    0.00    0.00   90.03
> >>> 11:12:32     all    0.25    0.00    3.11    0.00    0.00    4.46    0.00    0.00    0.00   92.17
> >>> Average:     all    0.32    0.00    6.21    0.00    0.00    4.21    0.00    0.00    0.00   89.26
> >>> 
> >>> 
> >>> I attache and one screenshot from perf top (Screenshot is send on preview mail)
> >>> 
> >>> And I see in lsmod 
> >>> 
> >>> pppoe                  20480  8198
> >>> pppox                  16384  1 pppoe
> >>> ppp_generic            45056  16364 pppox,pppoe
> >>> slhc                   16384  1 ppp_generic
> >>> 
> >>> To slow remove pppoe session .
> >>> 
> >>> And from log : 
> >>> 
> >>> [2021-09-07 11:01:11.129] vlan3020: ebdd1c5d8b5900f6: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>> [2021-09-07 11:01:53.621] vlan643: ebdd1c5d8b59014e: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>> [2021-09-07 11:02:00.359] vlan1616: ebdd1c5d8b590195: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>> [2021-09-07 11:02:05.859] vlan3020: ebdd1c5d8b5900d8: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>> [2021-09-07 11:02:08.258] vlan3005: ebdd1c5d8b590190: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>> [2021-09-07 11:02:13.820] vlan643: ebdd1c5d8b590152: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>> [2021-09-07 11:02:15.839] vlan727: ebdd1c5d8b590144: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>> [2021-09-07 11:02:20.139] vlan1693: ebdd1c5d8b59019f: ioctl(PPPIOCCONNECT): Transport endpoint is not connected
> >>> 
> >>>> On 11 Aug 2021, at 19:48, Guillaume Nault <gnault@redhat.com> wrote:
> >>>> 
> >>>> On Wed, Aug 11, 2021 at 02:10:32PM +0300, Martin Zaharinov wrote:
> >>>>> And one more that see.
> >>>>> 
> >>>>> Problem is come when accel start finishing sessions,
> >>>>> Now in server have 2k users and restart on one of vlans 3 Olt with 400 users and affect other vlans ,
> >>>>> And problem is start when start destroying dead sessions from vlan with 3 Olt and this affect all other vlans.
> >>>>> May be kernel destroy old session slow and entrained other users by locking other sessions.
> >>>>> is there a way to speed up the closing of stopped/dead sessions.
> >>>> 
> >>>> What are the CPU stats when that happen? Is it users space or kernel
> >>>> space that keeps it busy?
> >>>> 
> >>>> One easy way to check is to run "mpstat 1" for a few seconds when the
> >>>> problem occurs.
> >>>> 
> >>> 
> >> 
> > 
> 

