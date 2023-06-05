Return-Path: <netdev+bounces-8033-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AABD67227EC
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:55:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFE73281173
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:55:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3844E1D2B8;
	Mon,  5 Jun 2023 13:55:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296BB156EB
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:55:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EE6B1
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685973304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jb5+j0WuGaWQLAokH8FJzOfd9IpoIc69UMNApn2Um/Q=;
	b=Dxfh8soU2MojWuonyjetGUN6NDhxhGjPNIx541Csp9cytow+8jMV4M1KsgpNbfIsppxZye
	fomarvyTa2/rJTiYf/5DOGjBv6+fpVUJd0PM9JlatWMcpvOBk99dv7q1JvSZHpss6J16+5
	+lJZtqzBXZUUP47rHKl/e++pVBY8D5A=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-399-psW7qVbaPGaUYwgp90OUog-1; Mon, 05 Jun 2023 09:55:02 -0400
X-MC-Unique: psW7qVbaPGaUYwgp90OUog-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-30479b764f9so2207468f8f.0
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 06:55:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685973302; x=1688565302;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jb5+j0WuGaWQLAokH8FJzOfd9IpoIc69UMNApn2Um/Q=;
        b=WOYg4fLfM96aBEuvrm7J46b2iUzShDUgabL2gGgapBdJXW5XzjQGo1QhBtPVc6JhBG
         kC+Av9RxLm+lozwhP+qB51h5Y9NrhpW5oB+heSZe/5DXOHlZz/Hh+ZBGwyofGfnTjIGu
         jwg519ZHQswmhAjwabpqybR8I1biKMvOdbIKUjAhIt0hV/FwBPJqwxTHxfZVFyJAMB05
         4QriP+ehsQzbX2Dgs7N/nVKYJ3739+Qdza7Tm00ScxtOCZnyZ/6mi82lke3pxJ6YBkWs
         oNqCxvOkeqfr3I/kaXMtki3RzGRyfCPN7pByjIc/JAIWnXLS6D7AgC3Zsmxxxfzl6iud
         MJGQ==
X-Gm-Message-State: AC+VfDxv4b08zbCuR4dd8lyruE2HI3p8uW9hSAARjA6IakNhPirA43c+
	sGlAknZAvVwWmjzsUEvSifpXOt8UA9lkhj3az8TxPYMLJmyb8UIx8Bny5R9Fo9StjXTpdWMP0SQ
	4qMHrz+d69X/5lkdL
X-Received: by 2002:a5d:6203:0:b0:309:a4e:52d3 with SMTP id y3-20020a5d6203000000b003090a4e52d3mr5095732wru.5.1685973301862;
        Mon, 05 Jun 2023 06:55:01 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6ZHD4gDUdlfGTiduMiqY+ojv/UUc0qqNDYq2hzP027LaDqgTMXJjGDzbnCN0fSb2MNMtWn6g==
X-Received: by 2002:a5d:6203:0:b0:309:a4e:52d3 with SMTP id y3-20020a5d6203000000b003090a4e52d3mr5095714wru.5.1685973301499;
        Mon, 05 Jun 2023 06:55:01 -0700 (PDT)
Received: from redhat.com ([2.55.41.2])
        by smtp.gmail.com with ESMTPSA id t18-20020a05600001d200b0030ae09c5efdsm9932198wrx.42.2023.06.05.06.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 06:55:00 -0700 (PDT)
Date: Mon, 5 Jun 2023 09:54:57 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Shannon Nelson <shannon.nelson@amd.com>,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <20230605095404-mutt-send-email-mst@kernel.org>
References: <20230605110644.151211-1-sgarzare@redhat.com>
 <20230605084104-mutt-send-email-mst@kernel.org>
 <24fjdwp44hovz3d3qkzftmvjie45er3g3boac7aezpvzbwvuol@lmo47ydvnqau>
 <20230605085840-mutt-send-email-mst@kernel.org>
 <gi2hngx3ndsgz5d2rpqjywdmou5vxhd7xgi5z2lbachr7yoos4@kpifz37oz2et>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gi2hngx3ndsgz5d2rpqjywdmou5vxhd7xgi5z2lbachr7yoos4@kpifz37oz2et>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 03:30:35PM +0200, Stefano Garzarella wrote:
> On Mon, Jun 05, 2023 at 09:00:25AM -0400, Michael S. Tsirkin wrote:
> > On Mon, Jun 05, 2023 at 02:54:20PM +0200, Stefano Garzarella wrote:
> > > On Mon, Jun 05, 2023 at 08:41:54AM -0400, Michael S. Tsirkin wrote:
> > > > On Mon, Jun 05, 2023 at 01:06:44PM +0200, Stefano Garzarella wrote:
> > > > > vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE)
> > > > > don't support packed virtqueue well yet, so let's filter the
> > > > > VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get_features().
> > > > >
> > > > > This way, even if the device supports it, we don't risk it being
> > > > > negotiated, then the VMM is unable to set the vring state properly.
> > > > >
> > > > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> > > > > Cc: stable@vger.kernel.org
> > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > > > ---
> > > > >
> > > > > Notes:
> > > > >     This patch should be applied before the "[PATCH v2 0/3] vhost_vdpa:
> > > > >     better PACKED support" series [1] and backported in stable branches.
> > > > >
> > > > >     We can revert it when we are sure that everything is working with
> > > > >     packed virtqueues.
> > > > >
> > > > >     Thanks,
> > > > >     Stefano
> > > > >
> > > > >     [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
> > > >
> > > > I'm a bit lost here. So why am I merging "better PACKED support" then?
> > > 
> > > To really support packed virtqueue with vhost-vdpa, at that point we would
> > > also have to revert this patch.
> > > 
> > > I wasn't sure if you wanted to queue the series for this merge window.
> > > In that case do you think it is better to send this patch only for stable
> > > branches?
> > > > Does this patch make them a NOP?
> > > 
> > > Yep, after applying the "better PACKED support" series and being
> > > sure that
> > > the IOCTLs of vhost-vdpa support packed virtqueue, we should revert this
> > > patch.
> > > 
> > > Let me know if you prefer a different approach.
> > > 
> > > I'm concerned that QEMU uses vhost-vdpa IOCTLs thinking that the kernel
> > > interprets them the right way, when it does not.
> > > 
> > > Thanks,
> > > Stefano
> > > 
> > 
> > If this fixes a bug can you add Fixes tags to each of them? Then it's ok
> > to merge in this window. Probably easier than the elaborate
> > mask/unmask dance.
> 
> CCing Shannon (the original author of the "better PACKED support"
> series).
> 
> IIUC Shannon is going to send a v3 of that series to fix the
> documentation, so Shannon can you also add the Fixes tags?
> 
> Thanks,
> Stefano

Well this is in my tree already. Just reply with
Fixes: <>
to each and I will add these tags.

If I start dropping and rebasing this won't make it in this window.

-- 
MST


