Return-Path: <netdev+bounces-8743-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44E187257FC
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:39:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECC92280FBE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 08:39:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A2786AB9;
	Wed,  7 Jun 2023 08:39:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB82653
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 08:39:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875A7E7E
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 01:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686127161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ljArIlCjiAk4raJisPzBpvdPPgGsnUJvYTJw2BtF6ok=;
	b=WP1pwqJYwPirW7RDZ3w3/2E0amoqEJkoN7Z7oWlan+A3hN0EkUj1RD7J1ovk7iCpZRnN/3
	bWgdu6xPgKw8sskYL/m8X7hEr9Ez9jP9rldggyGcsJyKj+Tkko5zb0T1JwcLwde1yxeNYk
	3D2thL0DqpUvlDaW7nPqz70wOgGSOnM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-9qLBs7taOXSpA9flLErDew-1; Wed, 07 Jun 2023 04:39:20 -0400
X-MC-Unique: 9qLBs7taOXSpA9flLErDew-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-97463348446so518731966b.2
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 01:39:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686127159; x=1688719159;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ljArIlCjiAk4raJisPzBpvdPPgGsnUJvYTJw2BtF6ok=;
        b=AuJTraY9DoK+TzoTK7ZMkDy4CPCs8CKAGPBhTm7vmB+Hl+PzDpaLODLqMH3vpfsca9
         MBMn3vX8eG1SVtgqyksITzrZmP2MHH7t2U9Hw3A9rIpfb3qkqwYTFPMaSrhhBLCOLq/V
         rbhoO1v4Xp9/Phh+dOZJsA5zFmA3tmpSR6UFfCNMLDdqmn6ccrFO/Z1c3iOX48A2ENdE
         VyuYwl8mMpxEVO9hze2+czo3Gh559CvZyQJ/ymr4TFhF+8FvzBRB4sotKyeCk0KT1Tpb
         19Lw+dFC5A1WaMEEaPa9jIij6f6PieetTeWyV6YEhzarzQFTvmmi9dxsZTkRgstcTzCm
         ZxTg==
X-Gm-Message-State: AC+VfDzeOL5nX14uLkjJguCoLnqH3equ5lcBI95oDjSIuQU+gf+CWTNu
	/xTIxttPY7vzsLt8eNjLhU5ntcj/9FwLD9JTZ5iyfCMwGlwbOuM7vtWmA7F5msyb9gmHAKoXEBq
	FrOonh2wP1yCmF3gr
X-Received: by 2002:a17:907:2d91:b0:8b1:7de3:cfaa with SMTP id gt17-20020a1709072d9100b008b17de3cfaamr5662273ejc.3.1686127159116;
        Wed, 07 Jun 2023 01:39:19 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7btGdgIzKw5k5WmwW3L/Sj3hNi5PvtUs3V2LlGUM++yAslee+IT231SvTSKQcWeSSHb5giPg==
X-Received: by 2002:a17:907:2d91:b0:8b1:7de3:cfaa with SMTP id gt17-20020a1709072d9100b008b17de3cfaamr5662257ejc.3.1686127158820;
        Wed, 07 Jun 2023 01:39:18 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-16.business.telecomitalia.it. [87.12.25.16])
        by smtp.gmail.com with ESMTPSA id t15-20020a1709066bcf00b0096f7500502csm6655804ejs.199.2023.06.07.01.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 01:39:17 -0700 (PDT)
Date: Wed, 7 Jun 2023 10:39:15 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, 
	Shannon Nelson <shannon.nelson@amd.com>, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <CAGxU2F7fkgL-HpZdj=5ZEGNWcESCHQpgRAYQA3W2sPZaoEpNyQ@mail.gmail.com>
References: <20230605110644.151211-1-sgarzare@redhat.com>
 <20230605084104-mutt-send-email-mst@kernel.org>
 <24fjdwp44hovz3d3qkzftmvjie45er3g3boac7aezpvzbwvuol@lmo47ydvnqau>
 <20230605085840-mutt-send-email-mst@kernel.org>
 <gi2hngx3ndsgz5d2rpqjywdmou5vxhd7xgi5z2lbachr7yoos4@kpifz37oz2et>
 <20230605095404-mutt-send-email-mst@kernel.org>
 <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
 <CACGkMEu3PqQ99UoKF5NHgVADD3q=BF6jhLiyumeT4S1QCqN1tw@mail.gmail.com>
 <20230606085643-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230606085643-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 6, 2023 at 2:58 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Tue, Jun 06, 2023 at 09:29:22AM +0800, Jason Wang wrote:
> > On Mon, Jun 5, 2023 at 10:58 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> > >
> > > On Mon, Jun 05, 2023 at 09:54:57AM -0400, Michael S. Tsirkin wrote:
> > > >On Mon, Jun 05, 2023 at 03:30:35PM +0200, Stefano Garzarella wrote:
> > > >> On Mon, Jun 05, 2023 at 09:00:25AM -0400, Michael S. Tsirkin wrote:
> > > >> > On Mon, Jun 05, 2023 at 02:54:20PM +0200, Stefano Garzarella wrote:
> > > >> > > On Mon, Jun 05, 2023 at 08:41:54AM -0400, Michael S. Tsirkin wrote:
> > > >> > > > On Mon, Jun 05, 2023 at 01:06:44PM +0200, Stefano Garzarella wrote:
> > > >> > > > > vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE)
> > > >> > > > > don't support packed virtqueue well yet, so let's filter the
> > > >> > > > > VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get_features().
> > > >> > > > >
> > > >> > > > > This way, even if the device supports it, we don't risk it being
> > > >> > > > > negotiated, then the VMM is unable to set the vring state properly.
> > > >> > > > >
> > > >> > > > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> > > >> > > > > Cc: stable@vger.kernel.org
> > > >> > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > >> > > > > ---
> > > >> > > > >
> > > >> > > > > Notes:
> > > >> > > > >     This patch should be applied before the "[PATCH v2 0/3] vhost_vdpa:
> > > >> > > > >     better PACKED support" series [1] and backported in stable branches.
> > > >> > > > >
> > > >> > > > >     We can revert it when we are sure that everything is working with
> > > >> > > > >     packed virtqueues.
> > > >> > > > >
> > > >> > > > >     Thanks,
> > > >> > > > >     Stefano
> > > >> > > > >
> > > >> > > > >     [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
> > > >> > > >
> > > >> > > > I'm a bit lost here. So why am I merging "better PACKED support" then?
> > > >> > >
> > > >> > > To really support packed virtqueue with vhost-vdpa, at that point we would
> > > >> > > also have to revert this patch.
> > > >> > >
> > > >> > > I wasn't sure if you wanted to queue the series for this merge window.
> > > >> > > In that case do you think it is better to send this patch only for stable
> > > >> > > branches?
> > > >> > > > Does this patch make them a NOP?
> > > >> > >
> > > >> > > Yep, after applying the "better PACKED support" series and being
> > > >> > > sure that
> > > >> > > the IOCTLs of vhost-vdpa support packed virtqueue, we should revert this
> > > >> > > patch.
> > > >> > >
> > > >> > > Let me know if you prefer a different approach.
> > > >> > >
> > > >> > > I'm concerned that QEMU uses vhost-vdpa IOCTLs thinking that the kernel
> > > >> > > interprets them the right way, when it does not.
> > > >> > >
> > > >> > > Thanks,
> > > >> > > Stefano
> > > >> > >
> > > >> >
> > > >> > If this fixes a bug can you add Fixes tags to each of them? Then it's ok
> > > >> > to merge in this window. Probably easier than the elaborate
> > > >> > mask/unmask dance.
> > > >>
> > > >> CCing Shannon (the original author of the "better PACKED support"
> > > >> series).
> > > >>
> > > >> IIUC Shannon is going to send a v3 of that series to fix the
> > > >> documentation, so Shannon can you also add the Fixes tags?
> > > >>
> > > >> Thanks,
> > > >> Stefano
> > > >
> > > >Well this is in my tree already. Just reply with
> > > >Fixes: <>
> > > >to each and I will add these tags.
> > >
> > > I tried, but it is not easy since we added the support for packed
> > > virtqueue in vdpa and vhost incrementally.
> > >
> > > Initially I was thinking of adding the same tag used here:
> > >
> > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> > >
> > > Then I discovered that vq_state wasn't there, so I was thinking of
> > >
> > > Fixes: 530a5678bc00 ("vdpa: support packed virtqueue for set/get_vq_state()")
> > >
> > > So we would have to backport quite a few patches into the stable branches.
> > > I don't know if it's worth it...
> > >
> > > I still think it is better to disable packed in the stable branches,
> > > otherwise I have to make a list of all the patches we need.
> > >
> > > Any other ideas?
> >
> > AFAIK, except for vp_vdpa, pds seems to be the first parent that
> > supports packed virtqueue. Users should not notice anything wrong if
> > they don't use packed virtqueue. And the problem of vp_vdpa + packed
> > virtqueue came since the day0 of vp_vdpa. It seems fine to do nothing
> > I guess.
> >
> > Thanks
>
>
> I have a question though, what if down the road there
> is a new feature that needs more changes? It will be
> broken too just like PACKED no?
> Shouldn't vdpa have an allowlist of features it knows how
> to support?

It looks like we had it, but we took it out (by the way, we were
enabling packed even though we didn't support it):
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6234f80574d7569444d8718355fa2838e92b158b

The only problem I see is that for each new feature we have to modify 
the kernel.
Could we have new features that don't require handling by vhost-vdpa?

Thanks,
Stefano


