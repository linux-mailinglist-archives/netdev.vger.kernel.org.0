Return-Path: <netdev+bounces-8222-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99CE1723273
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 23:45:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 058D21C20DB3
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:45:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D4827702;
	Mon,  5 Jun 2023 21:45:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76230271E6
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 21:45:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3286E9
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686001498;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WpKIMI7QM/wVRTxo2f7IQpPSM5zVOF2jBBbDgfwLd/0=;
	b=NJAMbUDu0E0eTeX594qykwp0+c1Lbz+cD119QIRTgfpRVroIKRdBYZLk2SmyLpKDA1/XsB
	kB16h5JgkSPGDEM2IdOt+WGDV9tTJ2zWWifLWTiavrf55Ai0T+7w6z3EZvf2+SPBUtOJ8S
	mA8rU0062xR0zAO42ykCuaE1bVvB+n4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364-6Ya3xwi-OcS_q6OE6MppVA-1; Mon, 05 Jun 2023 17:44:57 -0400
X-MC-Unique: 6Ya3xwi-OcS_q6OE6MppVA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f7e8c24a92so1613025e9.0
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 14:44:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686001495; x=1688593495;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WpKIMI7QM/wVRTxo2f7IQpPSM5zVOF2jBBbDgfwLd/0=;
        b=gjfvm5/3c+osJFxy5uRzWQ9aIlFdlCJ6JfMuqEt7lHPtAs+vFkLevuObW4n4g+Lg8k
         V2ALlCeb/1GqHT1HimvGbvcMztkia2X4GRTRqH/6Sm5Bg4wOkBFk/yxW1kkaD+wIuURi
         /MIVYUOI8JD5jc7T2jgFBYXZWRwb9PV7cOTC3pzm8fVGBHXkPW4dhiJniK/19HwB5nLL
         Seugp3XiVxxU3MejY9g9AV2JR1fi/+I+B0d7e+66LbooD7djWn4YreZRqyxr20jxJRS0
         ojO3PS4foqWm5pyh3hmkvxCPv2DVC3kiLlP+ZmPAHbwISEG7C9XrDhtdX8px/mtMYpgR
         qwTA==
X-Gm-Message-State: AC+VfDxpPZkeBnXEnmLT9Ym/Mhpei+HxH2wXk3pnIYI6JmLJnTvsms71
	CLR+WW34bkxxPKr96S3jCfo09izflv8RWeLf2ALNCRCrkFGnj/1DZFMUWt/5yIVaAkjqaFkluwB
	rCzDq1IBQIPD76nZrxDzJPi8k
X-Received: by 2002:a7b:c40f:0:b0:3f7:5e08:7a04 with SMTP id k15-20020a7bc40f000000b003f75e087a04mr324441wmi.25.1686001495373;
        Mon, 05 Jun 2023 14:44:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4u8Ic/y4eCXxAW8Bpwr/2TMDw54kNLZMenywFlEZSHsc+nxVJwRBB1hWlaJzPhaz3ai/scQA==
X-Received: by 2002:a7b:c40f:0:b0:3f7:5e08:7a04 with SMTP id k15-20020a7bc40f000000b003f75e087a04mr324432wmi.25.1686001495049;
        Mon, 05 Jun 2023 14:44:55 -0700 (PDT)
Received: from redhat.com ([2.55.41.2])
        by smtp.gmail.com with ESMTPSA id b14-20020a5d40ce000000b002e5ff05765esm10931997wrq.73.2023.06.05.14.44.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 14:44:54 -0700 (PDT)
Date: Mon, 5 Jun 2023 17:44:50 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Shannon Nelson <shannon.nelson@amd.com>,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <20230605173958-mutt-send-email-mst@kernel.org>
References: <20230605110644.151211-1-sgarzare@redhat.com>
 <20230605084104-mutt-send-email-mst@kernel.org>
 <24fjdwp44hovz3d3qkzftmvjie45er3g3boac7aezpvzbwvuol@lmo47ydvnqau>
 <20230605085840-mutt-send-email-mst@kernel.org>
 <gi2hngx3ndsgz5d2rpqjywdmou5vxhd7xgi5z2lbachr7yoos4@kpifz37oz2et>
 <20230605095404-mutt-send-email-mst@kernel.org>
 <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 04:56:37PM +0200, Stefano Garzarella wrote:
> On Mon, Jun 05, 2023 at 09:54:57AM -0400, Michael S. Tsirkin wrote:
> > On Mon, Jun 05, 2023 at 03:30:35PM +0200, Stefano Garzarella wrote:
> > > On Mon, Jun 05, 2023 at 09:00:25AM -0400, Michael S. Tsirkin wrote:
> > > > On Mon, Jun 05, 2023 at 02:54:20PM +0200, Stefano Garzarella wrote:
> > > > > On Mon, Jun 05, 2023 at 08:41:54AM -0400, Michael S. Tsirkin wrote:
> > > > > > On Mon, Jun 05, 2023 at 01:06:44PM +0200, Stefano Garzarella wrote:
> > > > > > > vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE)
> > > > > > > don't support packed virtqueue well yet, so let's filter the
> > > > > > > VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get_features().
> > > > > > >
> > > > > > > This way, even if the device supports it, we don't risk it being
> > > > > > > negotiated, then the VMM is unable to set the vring state properly.
> > > > > > >
> > > > > > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> > > > > > > Cc: stable@vger.kernel.org
> > > > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > > > > > ---
> > > > > > >
> > > > > > > Notes:
> > > > > > >     This patch should be applied before the "[PATCH v2 0/3] vhost_vdpa:
> > > > > > >     better PACKED support" series [1] and backported in stable branches.
> > > > > > >
> > > > > > >     We can revert it when we are sure that everything is working with
> > > > > > >     packed virtqueues.
> > > > > > >
> > > > > > >     Thanks,
> > > > > > >     Stefano
> > > > > > >
> > > > > > >     [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
> > > > > >
> > > > > > I'm a bit lost here. So why am I merging "better PACKED support" then?
> > > > >
> > > > > To really support packed virtqueue with vhost-vdpa, at that point we would
> > > > > also have to revert this patch.
> > > > >
> > > > > I wasn't sure if you wanted to queue the series for this merge window.
> > > > > In that case do you think it is better to send this patch only for stable
> > > > > branches?
> > > > > > Does this patch make them a NOP?
> > > > >
> > > > > Yep, after applying the "better PACKED support" series and being
> > > > > sure that
> > > > > the IOCTLs of vhost-vdpa support packed virtqueue, we should revert this
> > > > > patch.
> > > > >
> > > > > Let me know if you prefer a different approach.
> > > > >
> > > > > I'm concerned that QEMU uses vhost-vdpa IOCTLs thinking that the kernel
> > > > > interprets them the right way, when it does not.
> > > > >
> > > > > Thanks,
> > > > > Stefano
> > > > >
> > > >
> > > > If this fixes a bug can you add Fixes tags to each of them? Then it's ok
> > > > to merge in this window. Probably easier than the elaborate
> > > > mask/unmask dance.
> > > 
> > > CCing Shannon (the original author of the "better PACKED support"
> > > series).
> > > 
> > > IIUC Shannon is going to send a v3 of that series to fix the
> > > documentation, so Shannon can you also add the Fixes tags?
> > > 
> > > Thanks,
> > > Stefano
> > 
> > Well this is in my tree already. Just reply with
> > Fixes: <>
> > to each and I will add these tags.
> 
> I tried, but it is not easy since we added the support for packed virtqueue
> in vdpa and vhost incrementally.
> 
> Initially I was thinking of adding the same tag used here:
> 
> Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> 
> Then I discovered that vq_state wasn't there, so I was thinking of
> 
> Fixes: 530a5678bc00 ("vdpa: support packed virtqueue for set/get_vq_state()")
> 
> So we would have to backport quite a few patches into the stable branches.
> I don't know if it's worth it...
> 
> I still think it is better to disable packed in the stable branches,
> otherwise I have to make a list of all the patches we need.
> 
> Any other ideas?
> 
> Thanks,
> Stefano

OK so. You want me to apply this one now, and fixes in the next
kernel?

-- 
MST


