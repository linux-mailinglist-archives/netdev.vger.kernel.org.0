Return-Path: <netdev+bounces-8467-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EF14724368
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:58:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BB9931C20B96
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59F6F37B98;
	Tue,  6 Jun 2023 12:58:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4664237B61
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 12:58:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAC710F8
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 05:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686056295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dtuylhemCFrocIQz72z/IvBRItNMZNPZwOBB6roSRDM=;
	b=VMQ+Roar/LRQZyjUSGQq/wpJkzdCHsZ2NNzjluy+ipew6O43Gnuiwoud+Mxmsaeyi3pzyx
	agTH1wyUPHIU3HmWNv70mQJHLBekU0brpjSN+UjoRSRR43IaAntHiZLXVwjRhtqs4lNYjD
	lgpgjm6NgZcVfdcfOLGHjkBvEzIOwGs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-II_cFRnMPcqATn6ERzKcbA-1; Tue, 06 Jun 2023 08:58:14 -0400
X-MC-Unique: II_cFRnMPcqATn6ERzKcbA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f7e7a6981cso7910815e9.1
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 05:58:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686056291; x=1688648291;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dtuylhemCFrocIQz72z/IvBRItNMZNPZwOBB6roSRDM=;
        b=czc3mGW4EA3UHkcAfxXJHBJAuecK0uBddtcbjZ9vSSe01v3s9jdAbcYvQ9o+HjlQqy
         GBLxOfKTgryMA3iVSUIQ2a7iAOwNuSxh34+xg82AiWhOb/lb6oI5p/LwT43KqQvRiyMt
         MmsG2uFFDTiuvFzA4SRYE/wBrinRV7EcD6EPiw1Edug2FnVgQhL0j6aKjm1PAmcrg95W
         f353Jul7cIfWoNXB6CU4DLssWCAGXObgrFgf5f3sGXK4n+dvL6nANypz/Dhl4ailKkBZ
         3at0GFN+qPbxJ/oYx5fW+OonlUKoPL2sxJIY/uOaMFhVstyTUPtbt918o3CSe5JOv27w
         LtXA==
X-Gm-Message-State: AC+VfDxSC0fu2ufumJ9pwpUbqj+RI4DwK/5a1PNYlVeDk78GTN5Vk6Hf
	HCLOaPWrBvSmFWH258zJKRbNehLUf2mn2T3YJmAsxplJxBCNzIUSwp82Xr0eAaZOiLQyYGfVHdl
	Eiz/KY2hGfGyGJXIei5+WFFyI
X-Received: by 2002:a05:600c:3797:b0:3f4:2492:a91f with SMTP id o23-20020a05600c379700b003f42492a91fmr1985695wmr.27.1686056291606;
        Tue, 06 Jun 2023 05:58:11 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7iSPeYaUH/YZk+7SBXsnFurRNoLRH/Yr/5f9n7h0h6HrxGNUlFSlQiPwqzijjD8yGHRwJDSg==
X-Received: by 2002:a05:600c:3797:b0:3f4:2492:a91f with SMTP id o23-20020a05600c379700b003f42492a91fmr1985683wmr.27.1686056291295;
        Tue, 06 Jun 2023 05:58:11 -0700 (PDT)
Received: from redhat.com ([2.55.41.2])
        by smtp.gmail.com with ESMTPSA id q25-20020a7bce99000000b003eddc6aa5fasm17487714wmj.39.2023.06.06.05.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 05:58:10 -0700 (PDT)
Date: Tue, 6 Jun 2023 08:58:06 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <20230606085643-mutt-send-email-mst@kernel.org>
References: <20230605110644.151211-1-sgarzare@redhat.com>
 <20230605084104-mutt-send-email-mst@kernel.org>
 <24fjdwp44hovz3d3qkzftmvjie45er3g3boac7aezpvzbwvuol@lmo47ydvnqau>
 <20230605085840-mutt-send-email-mst@kernel.org>
 <gi2hngx3ndsgz5d2rpqjywdmou5vxhd7xgi5z2lbachr7yoos4@kpifz37oz2et>
 <20230605095404-mutt-send-email-mst@kernel.org>
 <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
 <CACGkMEu3PqQ99UoKF5NHgVADD3q=BF6jhLiyumeT4S1QCqN1tw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEu3PqQ99UoKF5NHgVADD3q=BF6jhLiyumeT4S1QCqN1tw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 09:29:22AM +0800, Jason Wang wrote:
> On Mon, Jun 5, 2023 at 10:58 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> >
> > On Mon, Jun 05, 2023 at 09:54:57AM -0400, Michael S. Tsirkin wrote:
> > >On Mon, Jun 05, 2023 at 03:30:35PM +0200, Stefano Garzarella wrote:
> > >> On Mon, Jun 05, 2023 at 09:00:25AM -0400, Michael S. Tsirkin wrote:
> > >> > On Mon, Jun 05, 2023 at 02:54:20PM +0200, Stefano Garzarella wrote:
> > >> > > On Mon, Jun 05, 2023 at 08:41:54AM -0400, Michael S. Tsirkin wrote:
> > >> > > > On Mon, Jun 05, 2023 at 01:06:44PM +0200, Stefano Garzarella wrote:
> > >> > > > > vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE)
> > >> > > > > don't support packed virtqueue well yet, so let's filter the
> > >> > > > > VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get_features().
> > >> > > > >
> > >> > > > > This way, even if the device supports it, we don't risk it being
> > >> > > > > negotiated, then the VMM is unable to set the vring state properly.
> > >> > > > >
> > >> > > > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> > >> > > > > Cc: stable@vger.kernel.org
> > >> > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > >> > > > > ---
> > >> > > > >
> > >> > > > > Notes:
> > >> > > > >     This patch should be applied before the "[PATCH v2 0/3] vhost_vdpa:
> > >> > > > >     better PACKED support" series [1] and backported in stable branches.
> > >> > > > >
> > >> > > > >     We can revert it when we are sure that everything is working with
> > >> > > > >     packed virtqueues.
> > >> > > > >
> > >> > > > >     Thanks,
> > >> > > > >     Stefano
> > >> > > > >
> > >> > > > >     [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
> > >> > > >
> > >> > > > I'm a bit lost here. So why am I merging "better PACKED support" then?
> > >> > >
> > >> > > To really support packed virtqueue with vhost-vdpa, at that point we would
> > >> > > also have to revert this patch.
> > >> > >
> > >> > > I wasn't sure if you wanted to queue the series for this merge window.
> > >> > > In that case do you think it is better to send this patch only for stable
> > >> > > branches?
> > >> > > > Does this patch make them a NOP?
> > >> > >
> > >> > > Yep, after applying the "better PACKED support" series and being
> > >> > > sure that
> > >> > > the IOCTLs of vhost-vdpa support packed virtqueue, we should revert this
> > >> > > patch.
> > >> > >
> > >> > > Let me know if you prefer a different approach.
> > >> > >
> > >> > > I'm concerned that QEMU uses vhost-vdpa IOCTLs thinking that the kernel
> > >> > > interprets them the right way, when it does not.
> > >> > >
> > >> > > Thanks,
> > >> > > Stefano
> > >> > >
> > >> >
> > >> > If this fixes a bug can you add Fixes tags to each of them? Then it's ok
> > >> > to merge in this window. Probably easier than the elaborate
> > >> > mask/unmask dance.
> > >>
> > >> CCing Shannon (the original author of the "better PACKED support"
> > >> series).
> > >>
> > >> IIUC Shannon is going to send a v3 of that series to fix the
> > >> documentation, so Shannon can you also add the Fixes tags?
> > >>
> > >> Thanks,
> > >> Stefano
> > >
> > >Well this is in my tree already. Just reply with
> > >Fixes: <>
> > >to each and I will add these tags.
> >
> > I tried, but it is not easy since we added the support for packed
> > virtqueue in vdpa and vhost incrementally.
> >
> > Initially I was thinking of adding the same tag used here:
> >
> > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> >
> > Then I discovered that vq_state wasn't there, so I was thinking of
> >
> > Fixes: 530a5678bc00 ("vdpa: support packed virtqueue for set/get_vq_state()")
> >
> > So we would have to backport quite a few patches into the stable branches.
> > I don't know if it's worth it...
> >
> > I still think it is better to disable packed in the stable branches,
> > otherwise I have to make a list of all the patches we need.
> >
> > Any other ideas?
> 
> AFAIK, except for vp_vdpa, pds seems to be the first parent that
> supports packed virtqueue. Users should not notice anything wrong if
> they don't use packed virtqueue. And the problem of vp_vdpa + packed
> virtqueue came since the day0 of vp_vdpa. It seems fine to do nothing
> I guess.
> 
> Thanks


I have a question though, what if down the road there
is a new feature that needs more changes? It will be
broken too just like PACKED no?
Shouldn't vdpa have an allowlist of features it knows how
to support?

> >
> > Thanks,
> > Stefano
> >
> >


