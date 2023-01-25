Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11C367B70C
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 17:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235304AbjAYQk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 11:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235024AbjAYQkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 11:40:25 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937B7B472
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 08:40:23 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id cm26-20020a056830651a00b00684e5c0108dso11435997otb.9
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 08:40:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UO7C/405J3wiYnj7V3szRnZUuvNRoPgvvaxhawM6GPQ=;
        b=pjZI2ZiXU3i0xZ2JQy/hOiDPa7ta5aXB+E3287yeUu4pSRzN3fvuTh5LQNm47AVCac
         cK7/YBEzqMW/NkujtCH0UQhuomv2vl0vR59zIwTTHjmsg1RJIz+ixn7NovRcKmjpQeWs
         oRqcpSuv4v4WG72QrQYZsYQFolTgNILuaaqLs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UO7C/405J3wiYnj7V3szRnZUuvNRoPgvvaxhawM6GPQ=;
        b=ex7ZlCx0u45I+0SNz5SlAqgW+QnnSFr9rYOJyJXqV9in/C/gkIVVY5CYHwi2xXcOJ2
         IyyPK8bqfuPCKBTaY6Rxr2uiy4PPl05wrzzArHEhd7KXQGl272feXFgkdl+ArnRSjwHg
         5aBRU+yvlkCzEf+APEv1Zc3iN+ke6dEni++kwnSS+b2kRHXkYQ/mVqU0qOn4L+vAp4fi
         ctQgR1cWYb1W3I2CEITH61/ZqMXyayr9PlENdpYirltCpo+yGPs0iWjxmTiSRBEZgsYL
         YjXrlnIl+t7VVmXyO/Mw7pfQfoYWUHoq19I+W5Je8KjrMpBBigFIZOQizuNfY5OuVWdt
         johg==
X-Gm-Message-State: AO0yUKWcMeUt48ll5Q7mZaRmcJd7eR2e9SXnoWS2cPMv33ZS9LzXkG5D
        dW3+avTlQRl6WEGPUNUAzkyb4A==
X-Google-Smtp-Source: AK7set8kjYv4Gd+Yl6uOdaJisFJXJqg6dufCuEQGiEfDpicqvNQh0W/vM9SOhfW2hmdNVWGqA5J4lw==
X-Received: by 2002:a9d:2a4:0:b0:686:6f28:e0d1 with SMTP id 33-20020a9d02a4000000b006866f28e0d1mr1578154otl.17.1674664822776;
        Wed, 25 Jan 2023 08:40:22 -0800 (PST)
Received: from JNXK7M3 ([2a09:bac1:7680:540::f:303])
        by smtp.gmail.com with ESMTPSA id f18-20020a9d5f12000000b00670641eb272sm2354213oti.20.2023.01.25.08.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 08:40:22 -0800 (PST)
Date:   Wed, 25 Jan 2023 10:40:11 -0600
From:   Shawn Bohrer <sbohrer@cloudflare.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        makita.toshiaki@lab.ntt.co.jp, kernel-team@cloudflare.com
Subject: Re: KASAN veth use after free in XDP_REDIRECT
Message-ID: <Y9Fba9sBYwbRJX7i@JNXK7M3>
References: <Y9BfknDG0LXmruDu@JNXK7M3>
 <87357znztf.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87357znztf.fsf@toke.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 02:54:52AM +0100, Toke Høiland-Jørgensen wrote:
> Shawn Bohrer <sbohrer@cloudflare.com> writes:
> 
> > Hello,
> >
> > We've seen the following KASAN report on our systems. When using
> > AF_XDP on a veth.
> >
> > KASAN report:
> >
> > BUG: KASAN: use-after-free in __xsk_rcv+0x18d/0x2c0
> > Read of size 78 at addr ffff888976250154 by task napi/iconduit-g/148640
> >
> > CPU: 5 PID: 148640 Comm: napi/iconduit-g Kdump: loaded Tainted: G           O       6.1.4-cloudflare-kasan-2023.1.2 #1
> > Hardware name: Quanta Computer Inc. QuantaPlex T41S-2U/S2S-MB, BIOS S2S_3B10.03 06/21/2018
> > Call Trace:
> >  <TASK>
> >  dump_stack_lvl+0x34/0x48
> >  print_report+0x170/0x473
> >  ? __xsk_rcv+0x18d/0x2c0
> >  kasan_report+0xad/0x130
> >  ? __xsk_rcv+0x18d/0x2c0
> >  kasan_check_range+0x149/0x1a0
> >  memcpy+0x20/0x60
> >  __xsk_rcv+0x18d/0x2c0
> >  __xsk_map_redirect+0x1f3/0x490
> >  ? veth_xdp_rcv_skb+0x89c/0x1ba0 [veth]
> >  xdp_do_redirect+0x5ca/0xd60
> >  veth_xdp_rcv_skb+0x935/0x1ba0 [veth]
> >  ? __netif_receive_skb_list_core+0x671/0x920
> >  ? veth_xdp+0x670/0x670 [veth]
> >  veth_xdp_rcv+0x304/0xa20 [veth]
> >  ? do_xdp_generic+0x150/0x150
> >  ? veth_xdp_rcv_one+0xde0/0xde0 [veth]
> >  ? _raw_spin_lock_bh+0xe0/0xe0
> >  ? newidle_balance+0x887/0xe30
> >  ? __perf_event_task_sched_in+0xdb/0x800
> >  veth_poll+0x139/0x571 [veth]
> >  ? veth_xdp_rcv+0xa20/0xa20 [veth]
> >  ? _raw_spin_unlock+0x39/0x70
> >  ? finish_task_switch.isra.0+0x17e/0x7d0
> >  ? __switch_to+0x5cf/0x1070
> >  ? __schedule+0x95b/0x2640
> >  ? io_schedule_timeout+0x160/0x160
> >  __napi_poll+0xa1/0x440
> >  napi_threaded_poll+0x3d1/0x460
> >  ? __napi_poll+0x440/0x440
> >  ? __kthread_parkme+0xc6/0x1f0
> >  ? __napi_poll+0x440/0x440
> >  kthread+0x2a2/0x340
> >  ? kthread_complete_and_exit+0x20/0x20
> >  ret_from_fork+0x22/0x30
> >  </TASK>
> >
> > Freed by task 148640:
> >  kasan_save_stack+0x23/0x50
> >  kasan_set_track+0x21/0x30
> >  kasan_save_free_info+0x2a/0x40
> >  ____kasan_slab_free+0x169/0x1d0
> >  slab_free_freelist_hook+0xd2/0x190
> >  __kmem_cache_free+0x1a1/0x2f0
> >  skb_release_data+0x449/0x600
> >  consume_skb+0x9f/0x1c0
> >  veth_xdp_rcv_skb+0x89c/0x1ba0 [veth]
> >  veth_xdp_rcv+0x304/0xa20 [veth]
> >  veth_poll+0x139/0x571 [veth]
> >  __napi_poll+0xa1/0x440
> >  napi_threaded_poll+0x3d1/0x460
> >  kthread+0x2a2/0x340
> >  ret_from_fork+0x22/0x30
> >
> >
> > The buggy address belongs to the object at ffff888976250000
> >  which belongs to the cache kmalloc-2k of size 2048
> > The buggy address is located 340 bytes inside of
> >  2048-byte region [ffff888976250000, ffff888976250800)
> >
> > The buggy address belongs to the physical page:
> > page:00000000ae18262a refcount:2 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x976250
> > head:00000000ae18262a order:3 compound_mapcount:0 compound_pincount:0
> > flags: 0x2ffff800010200(slab|head|node=0|zone=2|lastcpupid=0x1ffff)
> > raw: 002ffff800010200 0000000000000000 dead000000000122 ffff88810004cf00
> > raw: 0000000000000000 0000000080080008 00000002ffffffff 0000000000000000
> > page dumped because: kasan: bad access detected
> >
> > Memory state around the buggy address:
> >  ffff888976250000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >  ffff888976250080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >>ffff888976250100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >                                                  ^
> >  ffff888976250180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >  ffff888976250200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >
> >
> > If I understand the code correctly it looks like a xdp_buf is
> > constructed pointing to the memory backed by a skb but consume_skb()
> > is called while the xdp_buf() is still in use.
> >
> > ```
> > 	case XDP_REDIRECT:
> > 		veth_xdp_get(&xdp);
> > 		consume_skb(skb);
> > 		xdp.rxq->mem = rq->xdp_mem;
> > 		if (xdp_do_redirect(rq->dev, &xdp, xdp_prog)) {
> > 			stats->rx_drops++;
> > 			goto err_xdp;
> > 		}
> > 		stats->xdp_redirect++;
> > 		rcu_read_unlock();
> > 		goto xdp_xmit;
> > ```
> >
> > It is worth noting that I think XDP_TX has the exact same problem.
> >
> > Again assuming I understand the problem one naive solution might be to
> > move the consum_skb() call after xdp_do_redirect().  I think this
> > might work for BPF_MAP_TYPE_XSKMAP, BPF_MAP_TYPE_DEVMAP, and
> > BPF_MAP_TYPE_DEVMAP_HASH since those all seem to copy the xdb_buf to
> > new memory.  The copy happens for XSKMAP in __xsk_rcv() and for the
> > DEVMAP cases happens in dev_map_enqueue_clone().
> >
> > However, it would appear that for BPF_MAP_TYPE_CPUMAP that memory can
> > live much longer, possibly even after xdp_do_flush().  If I'm correct,
> > I'm not really sure where it would be safe to call consume_skb().
> 
> So the idea is that veth_xdp_get() does a
> get_page(virt_to_page(xdp->data)), where xdp->data in this case points
> to skb->head. This should keep the data page alive even if the skb
> surrounding it is freed by the call to consume_skb().
> 
> However, because the skb->head in this case was allocated from a slab
> allocator, taking a page refcount is not enough to prevent it from being
> freed.
> 
> I'm not sure how best to fix this. I guess we could try to detect this
> case in the veth driver and copy the data, like we do for skb_share()
> etc. However, I'm not sure how to actually detect this case...
> 
> Where are the skbs being processed coming from? I.e., what path
> allocated them?

I can't say for sure where this skb came from.  Normally the vast
majority of our packets come from an external physical NIC and are
then routed into a network namespace through a veth pair.  In this
case this machine had a Solarflare card with the sfc driver.  However,
we only run the KASAN kernel on testing colo, and it normally sees
very little of this traffic unless someone is explicitly running
tests, and I have no idea what was happening when this bug triggered.

My only other guesses are that maybe this skb came from a tun device
or from the loopback device.  Some of our traffic arrives
encapsulated, and we decapsulate and forward.  This could then enter
the veth into the namespace.  If it is actually important to know
_where_ the skb was allocated we might be able to come up some more
ideas.

Thanks,
Shawn
