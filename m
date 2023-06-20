Return-Path: <netdev+bounces-12195-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 78C547369E4
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 12:50:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA8171C20BD5
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:50:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CBDF101DF;
	Tue, 20 Jun 2023 10:50:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6BC8489
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 10:50:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AEE31A5
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 03:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687258243;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p0IoXa4XAHoFAruqN5daSBHWjUsBZS6Ij0Vlly8LLK8=;
	b=OmfpwX1AkT+lx+C0CZwjlbtv+GqKRMnbidqoy7aAkG3bsecum6fgpVx8YFJNpiNYnCF8mP
	FCDGpXjp30MMLrmOT1yFI41itxCnsEe7yt78G1LuPSKT+CcEmCiBaxfRSha80XBqP/MeWc
	5qc1qvl4rDYC2SWoem6CHGgO/328zZw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-58cTf3XNMUyAwXRz1u1XoA-1; Tue, 20 Jun 2023 06:50:40 -0400
X-MC-Unique: 58cTf3XNMUyAwXRz1u1XoA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-30e3ee8a42eso1957288f8f.1
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 03:50:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687258239; x=1689850239;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p0IoXa4XAHoFAruqN5daSBHWjUsBZS6Ij0Vlly8LLK8=;
        b=K1PODg6CNQAnq3dV5igGhSdVF9eHNDK1D5LoC6cRMqfv/+OPoLOgJ1dJ4GcDxL+P+h
         E6nC+5b90rv3Rl/GsBdiqrzZ5kTHE3zUH4Tghx85vbOA6BuLFjpZ/0Aqaxycle9i4Qsc
         9JC7Vf0ExgvvIbvBneUGnxrFRxSiRsZOoe0r7nPp1XseEiRwE3UuM9JNSN5B7oKcsu2n
         P+gop+RJ/T1iwgkZ6wBosiAq0ndDj6EtK0PxeUjc9z5xXC4l1yOe7A96AIKI0Ee5lw4j
         Lb4c+JToh4l8RhcllYDFHHcCrYf2fzuCC4P5YjxnV54Xrk2rhLSiM4Tog29McQuFSOCC
         qr2A==
X-Gm-Message-State: AC+VfDzrs2LnYsLyeEBaBpVEES6QwKxJ8zrA4N5WkwgDgTcp+IdWShBW
	rR2UekfBUOQJG4QifJ6ASxsU5FvdHkyHQNOHBDoQCJB3ICw5Y7OXZly471A0TYHh4U/7FHvsp7e
	wUHaoB82SGxkFwCa0
X-Received: by 2002:a05:600c:218b:b0:3f8:f3fd:ccb9 with SMTP id e11-20020a05600c218b00b003f8f3fdccb9mr9444917wme.18.1687258238703;
        Tue, 20 Jun 2023 03:50:38 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7uBag3jmtb4HCqJRb/JnPfFAGDwhaBtlqIvqBfMAjYKXMc7iAhzA1MOqJpE8Irt7vp5R3c6A==
X-Received: by 2002:a05:600c:218b:b0:3f8:f3fd:ccb9 with SMTP id e11-20020a05600c218b00b003f8f3fdccb9mr9444900wme.18.1687258238400;
        Tue, 20 Jun 2023 03:50:38 -0700 (PDT)
Received: from redhat.com ([2.52.15.156])
        by smtp.gmail.com with ESMTPSA id c16-20020a7bc010000000b003f7f60203ffsm13170808wmb.25.2023.06.20.03.50.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 03:50:37 -0700 (PDT)
Date: Tue, 20 Jun 2023 06:50:34 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Heng Qi <hengqi@linux.alibaba.com>
Cc: netdev@vger.kernel.org, bpf@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH net-next 3/4] virtio-net: support coexistence of XDP and
 _F_GUEST_CSUM
Message-ID: <20230620064711-mutt-send-email-mst@kernel.org>
References: <20230619105738.117733-1-hengqi@linux.alibaba.com>
 <20230619105738.117733-4-hengqi@linux.alibaba.com>
 <20230619072320-mutt-send-email-mst@kernel.org>
 <20230620032430.GE74977@h68b04307.sqa.eu95>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230620032430.GE74977@h68b04307.sqa.eu95>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 20, 2023 at 11:24:30AM +0800, Heng Qi wrote:
> On Mon, Jun 19, 2023 at 07:26:44AM -0400, Michael S. Tsirkin wrote:
> > On Mon, Jun 19, 2023 at 06:57:37PM +0800, Heng Qi wrote:
> > > We are now re-probing the csum related fields and  trying
> > > to have XDP and RX hw checksum capabilities coexist on the
> > > XDP path. For the benefit of:
> > > 1. RX hw checksum capability can be used if XDP is loaded.
> > > 2. Avoid packet loss when loading XDP in the vm-vm scenario.
> > > 
> > > Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> > > Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > ---
> > >  drivers/net/virtio_net.c | 36 ++++++++++++++++++++++++------------
> > >  1 file changed, 24 insertions(+), 12 deletions(-)
> > > 
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index 07b4801d689c..25b486ab74db 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -1709,6 +1709,7 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
> > >  	struct net_device *dev = vi->dev;
> > >  	struct sk_buff *skb;
> > >  	struct virtio_net_hdr_mrg_rxbuf *hdr;
> > > +	__u8 flags;
> > >  
> > >  	if (unlikely(len < vi->hdr_len + ETH_HLEN)) {
> > >  		pr_debug("%s: short packet %i\n", dev->name, len);
> > > @@ -1717,6 +1718,8 @@ static void receive_buf(struct virtnet_info *vi, struct receive_queue *rq,
> > >  		return;
> > >  	}
> > >  
> > > +	flags = ((struct virtio_net_hdr_mrg_rxbuf *)buf)->hdr.flags;
> > > +
> > >  	if (vi->mergeable_rx_bufs)
> > >  		skb = receive_mergeable(dev, vi, rq, buf, ctx, len, xdp_xmit,
> > >  					stats);
> > 
> > what's going on here?
> 
> Hi, Michael.
> 
> Is your question about the function of this code?
> 1. If yes,
> this sentence saves the flags value in virtio-net-hdr in advance
> before entering the XDP processing logic, so that it can be used to
> judge further logic after XDP processing.
> 
> If _NEEDS_CSUM is included in flags before XDP processing, then after
> XDP processing we need to re-probe the csum fields and calculate the
> pseudo-header checksum.

Yes but we previously used this:
-       hdr = skb_vnet_hdr(skb);
which pokes at the copy in skb cb.

Is anything wrong with this?

It seems preferable not to poke at the header an extra time.

-- 
MST


