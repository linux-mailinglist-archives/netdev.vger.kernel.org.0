Return-Path: <netdev+bounces-12059-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A4E80735D80
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 20:36:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3EAB1C20B67
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 18:36:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E5C3D53B;
	Mon, 19 Jun 2023 18:36:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86705EA8
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 18:36:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AA413D
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 11:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1687199780;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6tXqvFRbqVeegIFkRm+Yup+Juz0OkTsWuPIXeSIwfwM=;
	b=HxYNrFdDG8PBRgQHl7UAnj04BrQBWRzQiXSRNPeHv4hbuOsWwd3vFxijGMS9hHxXMeaikA
	JEzkPcZwnxeQfTLDF8Wlr3FEXVbqnSl8A1Ww+hlf9IqSQN82PmhxevoxhN44f0Hw9//Q/H
	NMzimlT0VTDYlE0Bc1Uuc0XrCF5AR9I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-SILFhyiBOxa7NzqcinmOUA-1; Mon, 19 Jun 2023 14:36:19 -0400
X-MC-Unique: SILFhyiBOxa7NzqcinmOUA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f5fa06debcso22676235e9.0
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 11:36:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687199778; x=1689791778;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6tXqvFRbqVeegIFkRm+Yup+Juz0OkTsWuPIXeSIwfwM=;
        b=dmqfRCSy/3xftmcgjIUNnsxzqDwxIzciOmOYDFeRrLGswQEAbp331zcRGoyNkiy/jD
         vmRfrkfCYe+1yWTYfrY68pFnPS1/U+pfhMxF+xZMKF2iG4uGWbJzOwjziGXqkPS+ghSh
         XLEr07XMU5O0Dnc1qXxkxqM407bTZmaBGMTI7hXFjwjQCOEzBHlqiqKmmTa6byp1RFUR
         C+ZG9IhrSaz6w7ZLojgnuDDCgloFFu4m/3G8EsHeJJqTFnK7tXRqQROwVFYBMaE7K1bj
         diEfiBeJKxYxAFZgLW9d5vN7EUxo+v3TWPoDuszHuov8/Ig4pNZc772IOjnyasQzfvRk
         fNuA==
X-Gm-Message-State: AC+VfDzU6olsj8W8Tk9VI3B1ITkAXGbnT+vQbDIQRdcdm3B0nzveQrLi
	cBsFq4kUJrvKjpvrwnc+FDhydOAl9CVqggFW39lU04j+i4qwktGW/fwgT+AM+aRHU0DYhfxM9q/
	Km4fjYLpIL8nubEH6
X-Received: by 2002:a05:600c:2041:b0:3f9:871:c2da with SMTP id p1-20020a05600c204100b003f90871c2damr5525020wmg.40.1687199778265;
        Mon, 19 Jun 2023 11:36:18 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ55bLbAxXw958nhB3hm9JoNG6FmsfGyuT2z4TvhLue76HhSuEIZNL/wIebjUPGWw82KQR35dA==
X-Received: by 2002:a05:600c:2041:b0:3f9:871:c2da with SMTP id p1-20020a05600c204100b003f90871c2damr5525009wmg.40.1687199777903;
        Mon, 19 Jun 2023 11:36:17 -0700 (PDT)
Received: from redhat.com ([2.52.15.156])
        by smtp.gmail.com with ESMTPSA id n8-20020a05600c294800b003f90a604885sm405763wmd.34.2023.06.19.11.36.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 11:36:17 -0700 (PDT)
Date: Mon, 19 Jun 2023 14:36:13 -0400
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
Subject: Re: [PATCH net-next 4/4] virtio-net: remove F_GUEST_CSUM check for
 XDP loading
Message-ID: <20230619143536-mutt-send-email-mst@kernel.org>
References: <20230619105738.117733-1-hengqi@linux.alibaba.com>
 <20230619105738.117733-5-hengqi@linux.alibaba.com>
 <20230619071347-mutt-send-email-mst@kernel.org>
 <20230619124154.GC74977@h68b04307.sqa.eu95>
 <20230619103208-mutt-send-email-mst@kernel.org>
 <20230619154329.GD74977@h68b04307.sqa.eu95>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230619154329.GD74977@h68b04307.sqa.eu95>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 19, 2023 at 11:43:29PM +0800, Heng Qi wrote:
> On Mon, Jun 19, 2023 at 10:33:44AM -0400, Michael S. Tsirkin wrote:
> > On Mon, Jun 19, 2023 at 08:41:54PM +0800, Heng Qi wrote:
> > > On Mon, Jun 19, 2023 at 07:16:20AM -0400, Michael S. Tsirkin wrote:
> > > > On Mon, Jun 19, 2023 at 06:57:38PM +0800, Heng Qi wrote:
> > > > > Lay the foundation for the subsequent patch
> > > > 
> > > > which subsequent patch? this is the last one in series.
> > > > 
> > > > > to complete the coexistence
> > > > > of XDP and virtio-net guest csum.
> > > > > 
> > > > > Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
> > > > > Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > > > ---
> > > > >  drivers/net/virtio_net.c | 4 +---
> > > > >  1 file changed, 1 insertion(+), 3 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > > > index 25b486ab74db..79471de64b56 100644
> > > > > --- a/drivers/net/virtio_net.c
> > > > > +++ b/drivers/net/virtio_net.c
> > > > > @@ -60,7 +60,6 @@ static const unsigned long guest_offloads[] = {
> > > > >  	VIRTIO_NET_F_GUEST_TSO6,
> > > > >  	VIRTIO_NET_F_GUEST_ECN,
> > > > >  	VIRTIO_NET_F_GUEST_UFO,
> > > > > -	VIRTIO_NET_F_GUEST_CSUM,
> > > > >  	VIRTIO_NET_F_GUEST_USO4,
> > > > >  	VIRTIO_NET_F_GUEST_USO6,
> > > > >  	VIRTIO_NET_F_GUEST_HDRLEN
> > > > 
> > > > What is this doing? Drop support for VIRTIO_NET_F_GUEST_CSUM? Why?
> > > 
> > > guest_offloads[] is used by the VIRTIO_NET_CTRL_GUEST_OFFLOADS_SET
> > > command to switch features when XDP is loaded/unloaded.
> > > 
> > > If the VIRTIO_NET_F_CTRL_GUEST_OFFLOADS feature is negotiated:
> > > 1. When XDP is loaded, virtnet_xdp_set() uses virtnet_clear_guest_offloads()
> > > to automatically turn off the features in guest_offloads[].
> > > 
> > > 2. when XDP is unloaded, virtnet_xdp_set() uses virtnet_restore_guest_offloads()
> > > to automatically restore the features in guest_offloads[].
> > > 
> > > Now, this work no longer makes XDP and _F_GUEST_CSUM mutually
> > > exclusive, so this patch removed the _F_GUEST_CSUM from guest_offloads[].
> > > 
> > > > This will disable all of guest offloads I think ..
> > > 
> > > No. This doesn't change the dependencies of other features on
> > > _F_GUEST_CSUM. Removing _F_GUEST_CSUM here does not mean that other
> > > features that depend on it will be turned off at the same time, such as
> > > _F_GUEST_TSO{4,6}, F_GUEST_USO{4,6}, etc.
> > > 
> > > Thanks.
> > 
> > Hmm I don't get it.
> > 
> > static int virtnet_restore_guest_offloads(struct virtnet_info *vi)
> > {               
> >         u64 offloads = vi->guest_offloads;
> >                         
> >         if (!vi->guest_offloads)
> >                 return 0;
> >         
> >         return virtnet_set_guest_offloads(vi, offloads); 
> > }               
> >                         
> > is the bit _F_GUEST_CSUM set in vi->guest_offloads?
> 
> No, but first we doesn't clear _F_GUEST_CSUM in virtnet_clear_guest_offloads().
> 
> If VIRTIO_NET_F_CTRL_GUEST_OFFLOADS is negotiated, features that can
> be dynamically controlled by the VIRTIO_NET_CTRL_GUEST_OFFLOADS_SET
> command must also be negotiated. Therefore, if GRO_HW_MASK features such
> as _F_GUEST_TSO exist, then _F_GUEST_CSUM must exist (according to the
> dependencies defined by the spec).
> 
> Now, we only dynamically turn off/on the features contained in
> guest_offloads[] through XDP loading/unloading (with this patch,
> _F_GUEST_CSUM will not be controlled), and _F_GUEST_CSUM is always on.
> 
> Another point is that the virtio-net NETIF_F_RXCSUM corresponding to
> _F_GUEST_CSUM is only included in dev->features, not in dev->hw_features,
> which means that users cannot manually control the switch of
> _F_GUEST_CSUM.

I think I get it now.

> > 
> > Because if it isn't then we'll try to set _F_GUEST_TSO
> > without setting _F_GUEST_CSUM and that's a spec
> > violation I think.
> 
> As explained above, we did not cause a specification violation.
> 
> Thanks.

Right.

> > 
> > 
> > > > 
> > > > 
> > > > > @@ -3522,10 +3521,9 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
> > > > >  	        virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
> > > > >  	        virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
> > > > >  		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO) ||
> > > > > -		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM) ||
> > > > >  		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_USO4) ||
> > > > >  		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_USO6))) {
> > > > > -		NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing GRO_HW/CSUM, disable GRO_HW/CSUM first");
> > > > > +		NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing GRO_HW, disable GRO_HW first");
> > > > >  		return -EOPNOTSUPP;
> > > > >  	}
> > > > >  
> > > > > -- 
> > > > > 2.19.1.6.gb485710b


