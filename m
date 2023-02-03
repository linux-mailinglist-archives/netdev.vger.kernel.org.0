Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF6B6893A0
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbjBCJ1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232394AbjBCJ06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:26:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0315838B4D
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 01:26:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675416371;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GY11W4kq1z3XwzsY3uYGiiZMC3zxhJgHhoAeNgrDuTs=;
        b=b6OJKu7bbB/jqRjoQuS5Oq0Ts1cac9Bnn4ls+BXZyNfhhuB6kTF12SU0Zcj+TpkNOKLcae
        gzHT8pTvAq9k0naaxqsEl3gAlPca0C854DgOVtvdt3J0X1GqljgJ/GIaaP9RQRb15cig5C
        cW0sPTGxIX78FPkXI+R3EdOXYcwCOYg=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-21-tkCI0xaWP9u7nB9GJBhT1A-1; Fri, 03 Feb 2023 04:26:09 -0500
X-MC-Unique: tkCI0xaWP9u7nB9GJBhT1A-1
Received: by mail-ed1-f72.google.com with SMTP id en20-20020a056402529400b004a26ef05c34so3187063edb.16
        for <netdev@vger.kernel.org>; Fri, 03 Feb 2023 01:26:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GY11W4kq1z3XwzsY3uYGiiZMC3zxhJgHhoAeNgrDuTs=;
        b=C8sK7r0XhDNa0pqvM2vJsyf58eqApEkUBt36iqPLZvTSdFIb9AdU/28sDOrikrz8JZ
         l73xCY2xz9yRrzCoeJGy0sZHdpha/xQPJ85QM/4GdcGqyi0RTCdWc83fEO/DDmTGmn7u
         y8cW4t6vZ09/kk9Q6uTC/WzC0jbf8gnsI54eyynCLws0xc9HvRxJtCEilHJ6dted5Inw
         9RTButQDQ5A8ZbZe+E/5Dg0rG8X361ny9G7YqCb4zzaaQlyyMM+wZXaQuIaY/q+jsP17
         Yc1onEmehTSRLtgcD+dA6x/u0eHzIAD3eOzW7JtK6ld6YLetuEGlbkAQzyOqQQ0L8Ij4
         L0VQ==
X-Gm-Message-State: AO0yUKUcm6euxJ5P3WiTQBLaZbYMvAJaRdG2fuRxCUyNs511VKDWErv+
        L5B4P3cvsO7AQ4abGcZP+P4HQDlzlRCDayt+6p0t3LVqcYej6vMxJOyyiQcWCeyEZ8YzJFA6ZHa
        yY7d8MnMFzEIeiwXD
X-Received: by 2002:a17:906:8559:b0:88c:a43d:81ba with SMTP id h25-20020a170906855900b0088ca43d81bamr10279420ejy.11.1675416368572;
        Fri, 03 Feb 2023 01:26:08 -0800 (PST)
X-Google-Smtp-Source: AK7set+paJbQEOthrxtU67RVn8NU5zOOFLFdRvx9vb7eW6uWwKcFD5CduGGucGjMNV2kSo9JVcqyXQ==
X-Received: by 2002:a17:906:8559:b0:88c:a43d:81ba with SMTP id h25-20020a170906855900b0088ca43d81bamr10279393ejy.11.1675416368249;
        Fri, 03 Feb 2023 01:26:08 -0800 (PST)
Received: from redhat.com ([2.52.156.122])
        by smtp.gmail.com with ESMTPSA id j5-20020a1709062a0500b0087be1055f83sm1069895eje.206.2023.02.03.01.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 01:26:07 -0800 (PST)
Date:   Fri, 3 Feb 2023 04:26:03 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH 15/33] virtio_net: move to virtio_net.h
Message-ID: <20230203042527-mutt-send-email-mst@kernel.org>
References: <20230202110058.130695-1-xuanzhuo@linux.alibaba.com>
 <20230202110058.130695-16-xuanzhuo@linux.alibaba.com>
 <20230203035028-mutt-send-email-mst@kernel.org>
 <1675415082.88957-7-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1675415082.88957-7-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 05:04:42PM +0800, Xuan Zhuo wrote:
> On Fri, 3 Feb 2023 03:53:12 -0500, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > On Thu, Feb 02, 2023 at 07:00:40PM +0800, Xuan Zhuo wrote:
> > > Move some structure definitions and inline functions into the
> > > virtio_net.h file.
> > >
> > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > ---
> > >  drivers/net/virtio/main.c       | 247 +----------------------------
> > >  drivers/net/virtio/virtio_net.h | 265 ++++++++++++++++++++++++++++++++
> > >  2 files changed, 267 insertions(+), 245 deletions(-)
> > >  create mode 100644 drivers/net/virtio/virtio_net.h
> > >
> > > diff --git a/drivers/net/virtio/main.c b/drivers/net/virtio/main.c
> > > index eb7f00194b5c..5683cb576474 100644
> > > --- a/drivers/net/virtio/main.c
> > > +++ b/drivers/net/virtio/main.c
> > > @@ -4,24 +4,8 @@
> > >   * Copyright 2007 Rusty Russell <rusty@rustcorp.com.au> IBM Corporation
> > >   */
> > >  //#define DEBUG
> > > -#include <linux/netdevice.h>
> > > -#include <linux/etherdevice.h>
> > > -#include <linux/ethtool.h>
> > > -#include <linux/module.h>
> > > -#include <linux/virtio.h>
> > > -#include <linux/virtio_net.h>
> > > -#include <linux/bpf.h>
> > > -#include <linux/bpf_trace.h>
> > > -#include <linux/scatterlist.h>
> > > -#include <linux/if_vlan.h>
> > > -#include <linux/slab.h>
> > > -#include <linux/cpu.h>
> > > -#include <linux/average.h>
> > > -#include <linux/filter.h>
> > > -#include <linux/kernel.h>
> > > -#include <net/route.h>
> > > -#include <net/xdp.h>
> > > -#include <net/net_failover.h>
> > > +
> > > +#include "virtio_net.h"
> > >
> > >  static int napi_weight = NAPI_POLL_WEIGHT;
> > >  module_param(napi_weight, int, 0444);
> >
> >
> > You should only move the headers that are actually needed not
> > everything.
> 
> You mean the "include".
> 
> I think it is a simple way to concentrate "Include" into a header file, and
> other .c files reference this header file.
> 
> Do you agree?
> 
> Thanks.

Not really, one ends up including unnecessary stuff in both C files
making build times longer.

> >
> >
> > > @@ -44,15 +28,6 @@ module_param(napi_tx, bool, 0644);
> > >  #define VIRTIO_XDP_TX		BIT(0)
> > >  #define VIRTIO_XDP_REDIR	BIT(1)
> > >
> > > -#define VIRTIO_XDP_FLAG	BIT(0)
> > > -
> > > -/* RX packet size EWMA. The average packet size is used to determine the packet
> > > - * buffer size when refilling RX rings. As the entire RX ring may be refilled
> > > - * at once, the weight is chosen so that the EWMA will be insensitive to short-
> > > - * term, transient changes in packet size.
> > > - */
> > > -DECLARE_EWMA(pkt_len, 0, 64)
> > > -
> > >  #define VIRTNET_DRIVER_VERSION "1.0.0"
> > >
> > >  static const unsigned long guest_offloads[] = {
> > > @@ -72,36 +47,6 @@ static const unsigned long guest_offloads[] = {
> > >  				(1ULL << VIRTIO_NET_F_GUEST_USO4) | \
> > >  				(1ULL << VIRTIO_NET_F_GUEST_USO6))
> > >
> > > -struct virtnet_stat_desc {
> > > -	char desc[ETH_GSTRING_LEN];
> > > -	size_t offset;
> > > -};
> > > -
> > > -struct virtnet_sq_stats {
> > > -	struct u64_stats_sync syncp;
> > > -	u64 packets;
> > > -	u64 bytes;
> > > -	u64 xdp_tx;
> > > -	u64 xdp_tx_drops;
> > > -	u64 kicks;
> > > -	u64 tx_timeouts;
> > > -};
> > > -
> > > -struct virtnet_rq_stats {
> > > -	struct u64_stats_sync syncp;
> > > -	u64 packets;
> > > -	u64 bytes;
> > > -	u64 drops;
> > > -	u64 xdp_packets;
> > > -	u64 xdp_tx;
> > > -	u64 xdp_redirects;
> > > -	u64 xdp_drops;
> > > -	u64 kicks;
> > > -};
> > > -
> > > -#define VIRTNET_SQ_STAT(m)	offsetof(struct virtnet_sq_stats, m)
> > > -#define VIRTNET_RQ_STAT(m)	offsetof(struct virtnet_rq_stats, m)
> > > -
> > >  static const struct virtnet_stat_desc virtnet_sq_stats_desc[] = {
> > >  	{ "packets",		VIRTNET_SQ_STAT(packets) },
> > >  	{ "bytes",		VIRTNET_SQ_STAT(bytes) },
> > > @@ -125,57 +70,6 @@ static const struct virtnet_stat_desc virtnet_rq_stats_desc[] = {
> > >  #define VIRTNET_SQ_STATS_LEN	ARRAY_SIZE(virtnet_sq_stats_desc)
> > >  #define VIRTNET_RQ_STATS_LEN	ARRAY_SIZE(virtnet_rq_stats_desc)
> > >
> > > -/* Internal representation of a send virtqueue */
> > > -struct send_queue {
> > > -	/* Virtqueue associated with this send _queue */
> > > -	struct virtqueue *vq;
> > > -
> > > -	/* TX: fragments + linear part + virtio header */
> > > -	struct scatterlist sg[MAX_SKB_FRAGS + 2];
> > > -
> > > -	/* Name of the send queue: output.$index */
> > > -	char name[16];
> > > -
> > > -	struct virtnet_sq_stats stats;
> > > -
> > > -	struct napi_struct napi;
> > > -
> > > -	/* Record whether sq is in reset state. */
> > > -	bool reset;
> > > -};
> > > -
> > > -/* Internal representation of a receive virtqueue */
> > > -struct receive_queue {
> > > -	/* Virtqueue associated with this receive_queue */
> > > -	struct virtqueue *vq;
> > > -
> > > -	struct napi_struct napi;
> > > -
> > > -	struct bpf_prog __rcu *xdp_prog;
> > > -
> > > -	struct virtnet_rq_stats stats;
> > > -
> > > -	/* Chain pages by the private ptr. */
> > > -	struct page *pages;
> > > -
> > > -	/* Average packet length for mergeable receive buffers. */
> > > -	struct ewma_pkt_len mrg_avg_pkt_len;
> > > -
> > > -	/* Page frag for packet buffer allocation. */
> > > -	struct page_frag alloc_frag;
> > > -
> > > -	/* RX: fragments + linear part + virtio header */
> > > -	struct scatterlist sg[MAX_SKB_FRAGS + 2];
> > > -
> > > -	/* Min single buffer size for mergeable buffers case. */
> > > -	unsigned int min_buf_len;
> > > -
> > > -	/* Name of this receive queue: input.$index */
> > > -	char name[16];
> > > -
> > > -	struct xdp_rxq_info xdp_rxq;
> > > -};
> > > -
> > >  /* This structure can contain rss message with maximum settings for indirection table and keysize
> > >   * Note, that default structure that describes RSS configuration virtio_net_rss_config
> > >   * contains same info but can't handle table values.
> > > @@ -206,90 +100,6 @@ struct control_buf {
> > >  	struct virtio_net_ctrl_rss rss;
> > >  };
> > >
> > > -struct virtnet_info {
> > > -	struct virtio_device *vdev;
> > > -	struct virtqueue *cvq;
> > > -	struct net_device *dev;
> > > -	struct send_queue *sq;
> > > -	struct receive_queue *rq;
> > > -	unsigned int status;
> > > -
> > > -	/* Max # of queue pairs supported by the device */
> > > -	u16 max_queue_pairs;
> > > -
> > > -	/* # of queue pairs currently used by the driver */
> > > -	u16 curr_queue_pairs;
> > > -
> > > -	/* # of XDP queue pairs currently used by the driver */
> > > -	u16 xdp_queue_pairs;
> > > -
> > > -	/* xdp_queue_pairs may be 0, when xdp is already loaded. So add this. */
> > > -	bool xdp_enabled;
> > > -
> > > -	/* I like... big packets and I cannot lie! */
> > > -	bool big_packets;
> > > -
> > > -	/* number of sg entries allocated for big packets */
> > > -	unsigned int big_packets_num_skbfrags;
> > > -
> > > -	/* Host will merge rx buffers for big packets (shake it! shake it!) */
> > > -	bool mergeable_rx_bufs;
> > > -
> > > -	/* Host supports rss and/or hash report */
> > > -	bool has_rss;
> > > -	bool has_rss_hash_report;
> > > -	u8 rss_key_size;
> > > -	u16 rss_indir_table_size;
> > > -	u32 rss_hash_types_supported;
> > > -	u32 rss_hash_types_saved;
> > > -
> > > -	/* Has control virtqueue */
> > > -	bool has_cvq;
> > > -
> > > -	/* Host can handle any s/g split between our header and packet data */
> > > -	bool any_header_sg;
> > > -
> > > -	/* Packet virtio header size */
> > > -	u8 hdr_len;
> > > -
> > > -	/* Work struct for delayed refilling if we run low on memory. */
> > > -	struct delayed_work refill;
> > > -
> > > -	/* Is delayed refill enabled? */
> > > -	bool refill_enabled;
> > > -
> > > -	/* The lock to synchronize the access to refill_enabled */
> > > -	spinlock_t refill_lock;
> > > -
> > > -	/* Work struct for config space updates */
> > > -	struct work_struct config_work;
> > > -
> > > -	/* Does the affinity hint is set for virtqueues? */
> > > -	bool affinity_hint_set;
> > > -
> > > -	/* CPU hotplug instances for online & dead */
> > > -	struct hlist_node node;
> > > -	struct hlist_node node_dead;
> > > -
> > > -	struct control_buf *ctrl;
> > > -
> > > -	/* Ethtool settings */
> > > -	u8 duplex;
> > > -	u32 speed;
> > > -
> > > -	/* Interrupt coalescing settings */
> > > -	u32 tx_usecs;
> > > -	u32 rx_usecs;
> > > -	u32 tx_max_packets;
> > > -	u32 rx_max_packets;
> > > -
> > > -	unsigned long guest_offloads;
> > > -	unsigned long guest_offloads_capable;
> > > -
> > > -	/* failover when STANDBY feature enabled */
> > > -	struct failover *failover;
> > > -};
> > > -
> > >  struct padded_vnet_hdr {
> > >  	struct virtio_net_hdr_v1_hash hdr;
> > >  	/*
> > > @@ -303,45 +113,11 @@ struct padded_vnet_hdr {
> > >  static void virtnet_rq_free_unused_buf(struct virtqueue *vq, void *buf);
> > >  static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void *buf);
> > >
> > > -static bool is_xdp_frame(void *ptr)
> > > -{
> > > -	return (unsigned long)ptr & VIRTIO_XDP_FLAG;
> > > -}
> > > -
> > >  static void *xdp_to_ptr(struct xdp_frame *ptr)
> > >  {
> > >  	return (void *)((unsigned long)ptr | VIRTIO_XDP_FLAG);
> > >  }
> > >
> > > -static struct xdp_frame *ptr_to_xdp(void *ptr)
> > > -{
> > > -	return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
> > > -}
> > > -
> > > -static void __free_old_xmit(struct send_queue *sq, bool in_napi,
> > > -			    struct virtnet_sq_stats *stats)
> > > -{
> > > -	unsigned int len;
> > > -	void *ptr;
> > > -
> > > -	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
> > > -		if (!is_xdp_frame(ptr)) {
> > > -			struct sk_buff *skb = ptr;
> > > -
> > > -			pr_debug("Sent skb %p\n", skb);
> > > -
> > > -			stats->bytes += skb->len;
> > > -			napi_consume_skb(skb, in_napi);
> > > -		} else {
> > > -			struct xdp_frame *frame = ptr_to_xdp(ptr);
> > > -
> > > -			stats->bytes += xdp_get_frame_len(frame);
> > > -			xdp_return_frame(frame);
> > > -		}
> > > -		stats->packets++;
> > > -	}
> > > -}
> > > -
> > >  /* Converting between virtqueue no. and kernel tx/rx queue no.
> > >   * 0:rx0 1:tx0 2:rx1 3:tx1 ... 2N:rxN 2N+1:txN 2N+2:cvq
> > >   */
> > > @@ -411,15 +187,6 @@ static void disable_delayed_refill(struct virtnet_info *vi)
> > >  	spin_unlock_bh(&vi->refill_lock);
> > >  }
> > >
> > > -static void virtqueue_napi_schedule(struct napi_struct *napi,
> > > -				    struct virtqueue *vq)
> > > -{
> > > -	if (napi_schedule_prep(napi)) {
> > > -		virtqueue_disable_cb(vq);
> > > -		__napi_schedule(napi);
> > > -	}
> > > -}
> > > -
> > >  static void virtqueue_napi_complete(struct napi_struct *napi,
> > >  				    struct virtqueue *vq, int processed)
> > >  {
> > > @@ -1740,16 +1507,6 @@ static void free_old_xmit(struct send_queue *sq, bool in_napi)
> > >  	u64_stats_update_end(&sq->stats.syncp);
> > >  }
> > >
> > > -static bool is_xdp_raw_buffer_queue(struct virtnet_info *vi, int q)
> > > -{
> > > -	if (q < (vi->curr_queue_pairs - vi->xdp_queue_pairs))
> > > -		return false;
> > > -	else if (q < vi->curr_queue_pairs)
> > > -		return true;
> > > -	else
> > > -		return false;
> > > -}
> > > -
> > >  static void virtnet_poll_cleantx(struct receive_queue *rq)
> > >  {
> > >  	struct virtnet_info *vi = rq->vq->vdev->priv;
> > > diff --git a/drivers/net/virtio/virtio_net.h b/drivers/net/virtio/virtio_net.h
> > > new file mode 100644
> > > index 000000000000..8bf31429ae28
> > > --- /dev/null
> > > +++ b/drivers/net/virtio/virtio_net.h
> > > @@ -0,0 +1,265 @@
> > > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> > > +
> > > +#ifndef __VIRTIO_NET_H__
> > > +#define __VIRTIO_NET_H__
> > > +#include <linux/netdevice.h>
> > > +#include <linux/etherdevice.h>
> > > +#include <linux/ethtool.h>
> > > +#include <linux/module.h>
> > > +#include <linux/virtio.h>
> > > +#include <linux/virtio_net.h>
> > > +#include <linux/bpf.h>
> > > +#include <linux/bpf_trace.h>
> > > +#include <linux/scatterlist.h>
> > > +#include <linux/if_vlan.h>
> > > +#include <linux/slab.h>
> > > +#include <linux/cpu.h>
> > > +#include <linux/average.h>
> > > +#include <linux/filter.h>
> > > +#include <linux/kernel.h>
> > > +#include <net/route.h>
> > > +#include <net/xdp.h>
> > > +#include <net/net_failover.h>
> > > +#include <net/xdp_sock_drv.h>
> > > +
> > > +#define VIRTIO_XDP_FLAG	BIT(0)
> > > +
> > > +struct virtnet_info {
> > > +	struct virtio_device *vdev;
> > > +	struct virtqueue *cvq;
> > > +	struct net_device *dev;
> > > +	struct send_queue *sq;
> > > +	struct receive_queue *rq;
> > > +	unsigned int status;
> > > +
> > > +	/* Max # of queue pairs supported by the device */
> > > +	u16 max_queue_pairs;
> > > +
> > > +	/* # of queue pairs currently used by the driver */
> > > +	u16 curr_queue_pairs;
> > > +
> > > +	/* # of XDP queue pairs currently used by the driver */
> > > +	u16 xdp_queue_pairs;
> > > +
> > > +	/* xdp_queue_pairs may be 0, when xdp is already loaded. So add this. */
> > > +	bool xdp_enabled;
> > > +
> > > +	/* I like... big packets and I cannot lie! */
> > > +	bool big_packets;
> > > +
> > > +	/* number of sg entries allocated for big packets */
> > > +	unsigned int big_packets_num_skbfrags;
> > > +
> > > +	/* Host will merge rx buffers for big packets (shake it! shake it!) */
> > > +	bool mergeable_rx_bufs;
> > > +
> > > +	/* Host supports rss and/or hash report */
> > > +	bool has_rss;
> > > +	bool has_rss_hash_report;
> > > +	u8 rss_key_size;
> > > +	u16 rss_indir_table_size;
> > > +	u32 rss_hash_types_supported;
> > > +	u32 rss_hash_types_saved;
> > > +
> > > +	/* Has control virtqueue */
> > > +	bool has_cvq;
> > > +
> > > +	/* Host can handle any s/g split between our header and packet data */
> > > +	bool any_header_sg;
> > > +
> > > +	/* Packet virtio header size */
> > > +	u8 hdr_len;
> > > +
> > > +	/* Work struct for delayed refilling if we run low on memory. */
> > > +	struct delayed_work refill;
> > > +
> > > +	/* Is delayed refill enabled? */
> > > +	bool refill_enabled;
> > > +
> > > +	/* The lock to synchronize the access to refill_enabled */
> > > +	spinlock_t refill_lock;
> > > +
> > > +	/* Work struct for config space updates */
> > > +	struct work_struct config_work;
> > > +
> > > +	/* Does the affinity hint is set for virtqueues? */
> > > +	bool affinity_hint_set;
> > > +
> > > +	/* CPU hotplug instances for online & dead */
> > > +	struct hlist_node node;
> > > +	struct hlist_node node_dead;
> > > +
> > > +	struct control_buf *ctrl;
> > > +
> > > +	/* Ethtool settings */
> > > +	u8 duplex;
> > > +	u32 speed;
> > > +
> > > +	/* Interrupt coalescing settings */
> > > +	u32 tx_usecs;
> > > +	u32 rx_usecs;
> > > +	u32 tx_max_packets;
> > > +	u32 rx_max_packets;
> > > +
> > > +	unsigned long guest_offloads;
> > > +	unsigned long guest_offloads_capable;
> > > +
> > > +	/* failover when STANDBY feature enabled */
> > > +	struct failover *failover;
> > > +};
> > > +
> > > +/* RX packet size EWMA. The average packet size is used to determine the packet
> > > + * buffer size when refilling RX rings. As the entire RX ring may be refilled
> > > + * at once, the weight is chosen so that the EWMA will be insensitive to short-
> > > + * term, transient changes in packet size.
> > > + */
> > > +DECLARE_EWMA(pkt_len, 0, 64)
> > > +
> > > +struct virtnet_stat_desc {
> > > +	char desc[ETH_GSTRING_LEN];
> > > +	size_t offset;
> > > +};
> > > +
> > > +struct virtnet_sq_stats {
> > > +	struct u64_stats_sync syncp;
> > > +	u64 packets;
> > > +	u64 bytes;
> > > +	u64 xdp_tx;
> > > +	u64 xdp_tx_drops;
> > > +	u64 kicks;
> > > +	u64 tx_timeouts;
> > > +};
> > > +
> > > +struct virtnet_rq_stats {
> > > +	struct u64_stats_sync syncp;
> > > +	u64 packets;
> > > +	u64 bytes;
> > > +	u64 drops;
> > > +	u64 xdp_packets;
> > > +	u64 xdp_tx;
> > > +	u64 xdp_redirects;
> > > +	u64 xdp_drops;
> > > +	u64 kicks;
> > > +};
> > > +
> > > +#define VIRTNET_SQ_STAT(m)	offsetof(struct virtnet_sq_stats, m)
> > > +#define VIRTNET_RQ_STAT(m)	offsetof(struct virtnet_rq_stats, m)
> > > +
> > > +/* Internal representation of a send virtqueue */
> > > +struct send_queue {
> > > +	/* Virtqueue associated with this send _queue */
> > > +	struct virtqueue *vq;
> > > +
> > > +	/* TX: fragments + linear part + virtio header */
> > > +	struct scatterlist sg[MAX_SKB_FRAGS + 2];
> > > +
> > > +	/* Name of the send queue: output.$index */
> > > +	char name[16];
> > > +
> > > +	struct virtnet_sq_stats stats;
> > > +
> > > +	struct napi_struct napi;
> > > +
> > > +	/* Record whether sq is in reset state. */
> > > +	bool reset;
> > > +};
> > > +
> > > +/* Internal representation of a receive virtqueue */
> > > +struct receive_queue {
> > > +	/* Virtqueue associated with this receive_queue */
> > > +	struct virtqueue *vq;
> > > +
> > > +	struct napi_struct napi;
> > > +
> > > +	struct bpf_prog __rcu *xdp_prog;
> > > +
> > > +	struct virtnet_rq_stats stats;
> > > +
> > > +	/* Chain pages by the private ptr. */
> > > +	struct page *pages;
> > > +
> > > +	/* Average packet length for mergeable receive buffers. */
> > > +	struct ewma_pkt_len mrg_avg_pkt_len;
> > > +
> > > +	/* Page frag for packet buffer allocation. */
> > > +	struct page_frag alloc_frag;
> > > +
> > > +	/* RX: fragments + linear part + virtio header */
> > > +	struct scatterlist sg[MAX_SKB_FRAGS + 2];
> > > +
> > > +	/* Min single buffer size for mergeable buffers case. */
> > > +	unsigned int min_buf_len;
> > > +
> > > +	/* Name of this receive queue: input.$index */
> > > +	char name[16];
> > > +
> > > +	struct xdp_rxq_info xdp_rxq;
> > > +};
> > > +
> > > +static inline bool is_xdp_raw_buffer_queue(struct virtnet_info *vi, int q)
> > > +{
> > > +	if (q < (vi->curr_queue_pairs - vi->xdp_queue_pairs))
> > > +		return false;
> > > +	else if (q < vi->curr_queue_pairs)
> > > +		return true;
> > > +	else
> > > +		return false;
> > > +}
> > > +
> > > +static inline void virtnet_return_xdp_frame(struct send_queue *sq,
> > > +					    struct xdp_frame *frame)
> > > +{
> > > +	struct virtnet_info *vi = sq->vq->vdev->priv;
> > > +	dma_addr_t *p_addr, addr;
> > > +
> > > +	p_addr = frame->data - sizeof(*p_addr);
> > > +	addr = *p_addr;
> > > +
> > > +	virtio_dma_unmap(&vi->vdev->dev, addr, frame->len, DMA_TO_DEVICE);
> > > +
> > > +	xdp_return_frame(frame);
> > > +}
> > > +
> > > +static inline void virtqueue_napi_schedule(struct napi_struct *napi,
> > > +					   struct virtqueue *vq)
> > > +{
> > > +	if (napi_schedule_prep(napi)) {
> > > +		virtqueue_disable_cb(vq);
> > > +		__napi_schedule(napi);
> > > +	}
> > > +}
> > > +
> > > +static inline bool is_xdp_frame(void *ptr)
> > > +{
> > > +	return (unsigned long)ptr & VIRTIO_XDP_FLAG;
> > > +}
> > > +
> > > +static struct xdp_frame *ptr_to_xdp(void *ptr)
> > > +{
> > > +	return (struct xdp_frame *)((unsigned long)ptr & ~VIRTIO_XDP_FLAG);
> > > +}
> > > +
> > > +static void __free_old_xmit(struct send_queue *sq, bool in_napi,
> > > +			    struct virtnet_sq_stats *stats)
> > > +{
> > > +	unsigned int len;
> > > +	void *ptr;
> > > +
> > > +	while ((ptr = virtqueue_get_buf(sq->vq, &len)) != NULL) {
> > > +		if (!is_xdp_frame(ptr)) {
> > > +			struct sk_buff *skb = ptr;
> > > +
> > > +			pr_debug("Sent skb %p\n", skb);
> > > +
> > > +			stats->bytes += skb->len;
> > > +			napi_consume_skb(skb, in_napi);
> > > +		} else {
> > > +			struct xdp_frame *frame = ptr_to_xdp(ptr);
> > > +
> > > +			stats->bytes += xdp_get_frame_len(frame);
> > > +			xdp_return_frame(frame);
> > > +		}
> > > +		stats->packets++;
> > > +	}
> > > +}
> > > +#endif
> >
> > All these APIs not prefixed with virtnet were ok as internal
> > static functions. No longer ok in a header.
> 
> I agree. Will fix.
> 
> Thanks.
> 
> >
> >
> > > --
> > > 2.32.0.3.g01195cf9f
> >

