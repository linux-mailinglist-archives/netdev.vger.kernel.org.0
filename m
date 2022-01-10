Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01B9489AC0
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 14:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234564AbiAJNuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 08:50:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47204 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234380AbiAJNuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 08:50:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641822615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nM4W5742079GwSmsTVW9tzOQqEKVJffYutWnxAvkb6c=;
        b=Oc8QKyopqnyQKjiYrz7TXVFfJpo4i3f6xEF6Pc/pJFW12sGfgxSeerRJ+wKTud4taagPGs
        pQjAdz3mS9QHbh0LPkLljz4aeCHzFcL3+lp7nPmUCZg4HYsbJ55J/ZEoZ+JkzYWNzlfDCS
        JxS/BqReHLOeWOT6HUYYGLVqS5K5amM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-xeepSfAcMZ6UK1JtS26fxw-1; Mon, 10 Jan 2022 08:50:14 -0500
X-MC-Unique: xeepSfAcMZ6UK1JtS26fxw-1
Received: by mail-wm1-f69.google.com with SMTP id m19-20020a05600c4f5300b00345cb6e8dd4so2187642wmq.3
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 05:50:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nM4W5742079GwSmsTVW9tzOQqEKVJffYutWnxAvkb6c=;
        b=Hsn9zDNS0bm3s2w+DnDA0EKwDF0aCYBsgi5wsGrcFdzxEYNr+G7qW0xsNk+jxyprKe
         gpOzzbS8PwMBs5hwuMlb7OW1M4Yn+Q9smZCLayKNXMIfiOg6T8TLahCAEJ70nDAMU5OE
         ijcJ7G10PQiO979crN/Aqa/LTGpOeyEgmweHfEqqXWfc0YqupEzQuS9bFMdftXj51jsY
         fuPhr+RkPbo0js+qQzlMT9mYAlCiQTSZn9OnFImWrU1+viTlf38DpVUBPW1WnVedD7Wv
         XSJjvpitopnSBTeHGaMemNLOacOnLZyVCTVjaEzXSwVvEDS/RK7gs/TWJp3ydzcgQuDn
         SViw==
X-Gm-Message-State: AOAM533/Eraowibz6MtkmanztccNU32x+C9mPSLcwoyqsMnZmMayDw8P
        M+2G6HC6l6VgbeATryf0e25vnEe9fTTTBfxGbJ64uzng7jdAgd01pwXFt4A8iX5oxA1QppDD3lI
        lpmgNthYOQOv0iCDA
X-Received: by 2002:a05:600c:298:: with SMTP id 24mr4440800wmk.75.1641822612542;
        Mon, 10 Jan 2022 05:50:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzDZrwf8gxn4CRtPv8dEC4rvt772IpQ5Vzt7WD+T7EHwb5/d7rvGJopurL47V72dfeARvQ9jA==
X-Received: by 2002:a05:600c:298:: with SMTP id 24mr4440781wmk.75.1641822612292;
        Mon, 10 Jan 2022 05:50:12 -0800 (PST)
Received: from redhat.com ([2.55.13.160])
        by smtp.gmail.com with ESMTPSA id b1sm7261162wrd.92.2022.01.10.05.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 05:50:11 -0800 (PST)
Date:   Mon, 10 Jan 2022 08:50:08 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v3 0/3] virtio support cache indirect desc
Message-ID: <20220110084054-mutt-send-email-mst@kernel.org>
References: <20220106072615-mutt-send-email-mst@kernel.org>
 <1641473339.4832802-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1641473339.4832802-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 06, 2022 at 08:48:59PM +0800, Xuan Zhuo wrote:
> On Thu, 6 Jan 2022 07:28:31 -0500, Michael S. Tsirkin <mst@redhat.com> wrote:
> > On Fri, Oct 29, 2021 at 02:28:11PM +0800, Xuan Zhuo wrote:
> > > If the VIRTIO_RING_F_INDIRECT_DESC negotiation succeeds, and the number
> > > of sgs used for sending packets is greater than 1. We must constantly
> > > call __kmalloc/kfree to allocate/release desc.
> >
> >
> > So where is this going? I really like the performance boost. My concern
> > is that if guest spans NUMA nodes and when handler switches from
> > node to another this will keep reusing the cache from
> > the old node. A bunch of ways were suggested to address this, but
> > even just making the cache per numa node would help.
> >
> 
> In fact, this is the problem I encountered in implementing virtio-net to support
> xdp socket. With virtqueue reset[0] has been merged into virtio spec. I
> am completing this series of work. My plan is:
> 
> 1. virtio support advance dma
> 2. linux kernel/qemu support virtqueue reset
> 3. virtio-net support AF_XDP
> 4. virtio support cache indirect desc
> 
> [0]: https://github.com/oasis-tcs/virtio-spec/issues/124
> 
> Thanks.

OK it's up to you how to prioritize your work.
An idea though: isn't there a way to reduce the use of indirect?
Even with all the caching, it is surely not free.
We made it work better in the past with:

commit e7428e95a06fb516fac1308bd0e176e27c0b9287
    ("virtio-net: put virtio-net header inline with data"). 
and
commit 6ebbc1a6383fe78be3c0961d1475043ac6cc2542
    virtio-net: Set needed_headroom for virtio-net when VIRTIO_F_ANY_LAYOUT is true

can't something similar be done for XDP?



Another idea is to skip indirect even with s/g as number of outstanding
entries is small. The difficulty with this approach is that it has
to be tested across a large number of configurations, including
storage to make sure we don't cause regressions, unless we
are very conservative and only make a small % of entries direct.
Will doing that still help? It looks attractive on paper:
if guest starts outpacing host and ring begins to fill
up to more than say 10% then we switch to allocating indirect
entries which slows guest down.



> >
> > > In the case of extremely fast package delivery, the overhead cannot be
> > > ignored:
> > >
> > >   27.46%  [kernel]  [k] virtqueue_add
> > >   16.66%  [kernel]  [k] detach_buf_split
> > >   16.51%  [kernel]  [k] virtnet_xsk_xmit
> > >   14.04%  [kernel]  [k] virtqueue_add_outbuf
> > >    5.18%  [kernel]  [k] __kmalloc
> > >    4.08%  [kernel]  [k] kfree
> > >    2.80%  [kernel]  [k] virtqueue_get_buf_ctx
> > >    2.22%  [kernel]  [k] xsk_tx_peek_desc
> > >    2.08%  [kernel]  [k] memset_erms
> > >    0.83%  [kernel]  [k] virtqueue_kick_prepare
> > >    0.76%  [kernel]  [k] virtnet_xsk_run
> > >    0.62%  [kernel]  [k] __free_old_xmit_ptr
> > >    0.60%  [kernel]  [k] vring_map_one_sg
> > >    0.53%  [kernel]  [k] native_apic_mem_write
> > >    0.46%  [kernel]  [k] sg_next
> > >    0.43%  [kernel]  [k] sg_init_table
> > >    0.41%  [kernel]  [k] kmalloc_slab
> > >
> > > This patch adds a cache function to virtio to cache these allocated indirect
> > > desc instead of constantly allocating and releasing desc.
> > >
> > > v3:
> > >   pre-allocate per buffer indirect descriptors array
> > >
> > > v2:
> > >   use struct list_head to cache the desc
> > >
> > > *** BLURB HERE ***
> > >
> > > Xuan Zhuo (3):
> > >   virtio: cache indirect desc for split
> > >   virtio: cache indirect desc for packed
> > >   virtio-net: enable virtio desc cache
> > >
> > >  drivers/net/virtio_net.c     |  11 +++
> > >  drivers/virtio/virtio.c      |   6 ++
> > >  drivers/virtio/virtio_ring.c | 131 ++++++++++++++++++++++++++++++-----
> > >  include/linux/virtio.h       |  14 ++++
> > >  4 files changed, 145 insertions(+), 17 deletions(-)
> > >
> > > --
> > > 2.31.0
> >

