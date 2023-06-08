Return-Path: <netdev+bounces-9230-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF57572819D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 15:43:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66F8228168A
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4631812B84;
	Thu,  8 Jun 2023 13:43:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AC0BA3A
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:43:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D9126AD
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 06:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686231815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FwwjX0DTQ9pDyVotNAjxvKXjO/18HyPagdYutCSy84o=;
	b=ZvprYIZc8zRiK54DTtOzxsIG5AnbhGf9KMzeuyUWAaNxrKJUMv43PdtGvaWrb+3R19lpqx
	XBlHEMcOi2ig+F3Im1mYJbSZ4RPALzByvjcFf28kHBNqb5siHFC6Wjn9CBXqCpmZMMOtof
	nB9NCmyDgymXFAsf8cZ/B1Ys/txcPf0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-396-riiMD46yNoOFgPf4bRSlKg-1; Thu, 08 Jun 2023 09:43:34 -0400
X-MC-Unique: riiMD46yNoOFgPf4bRSlKg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-30932d15a30so412667f8f.1
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 06:43:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686231813; x=1688823813;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FwwjX0DTQ9pDyVotNAjxvKXjO/18HyPagdYutCSy84o=;
        b=HncrOT7lL0/gh1oVKH24nVJOMO9Vs9O91DdJ0WDVfbucrXJUtQfT8+nfPxxttGmo9g
         mTUV1xVQvcGnStaIhJxtXHGAIXb3XGGMFsr7QgTT29jUfsR7gEo5lGzPHbqeZBd+ChM0
         YWEMbBHC+8x2zOyQx9fGUJEdyqcpdUn3azhQfOnv5Po7Qehaq2rB1ckQb3Hcwpur5qhq
         dwciXmuC9Myitxiy7+X9VlOfhBD574QEuQOfA+p8n4zIJLq669jh3cvincASF3Jrt/cc
         ajIzACnYnrv3BX+ju7t4O7DYGVUhTcRrA1rH5l7IFMWe1ej0zKR5+eZ9/Nq98PrJomU+
         IVVA==
X-Gm-Message-State: AC+VfDzyWP4lxSdyw6berbJz/hT7hQOh/JaGhgx5qqMYqMF57znCmOfe
	/i2Ufc5rTu0wfQbyWScXDzqxSpF5ByIZJGMGzK2K842PhpVg+6oWU0PgL4airt9oDT6vfoCX8n3
	j1MniJgN2P4NGdhRD
X-Received: by 2002:adf:f810:0:b0:309:54b6:33b0 with SMTP id s16-20020adff810000000b0030954b633b0mr6902332wrp.44.1686231813106;
        Thu, 08 Jun 2023 06:43:33 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6l2wxPHxygUqAgwJKdM3ILKyed0BQuYFWwdxlh0hmTm1xDo/3dzFUkr6JPg6f2+5qx75i6Ug==
X-Received: by 2002:adf:f810:0:b0:309:54b6:33b0 with SMTP id s16-20020adff810000000b0030954b633b0mr6902313wrp.44.1686231812720;
        Thu, 08 Jun 2023 06:43:32 -0700 (PDT)
Received: from redhat.com ([2.55.41.2])
        by smtp.gmail.com with ESMTPSA id l15-20020a1c790f000000b003f7ec54d900sm2054972wme.9.2023.06.08.06.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 06:43:32 -0700 (PDT)
Date: Thu, 8 Jun 2023 09:43:26 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <20230608094202-mutt-send-email-mst@kernel.org>
References: <gi2hngx3ndsgz5d2rpqjywdmou5vxhd7xgi5z2lbachr7yoos4@kpifz37oz2et>
 <20230605095404-mutt-send-email-mst@kernel.org>
 <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
 <CACGkMEu3PqQ99UoKF5NHgVADD3q=BF6jhLiyumeT4S1QCqN1tw@mail.gmail.com>
 <20230606085643-mutt-send-email-mst@kernel.org>
 <CAGxU2F7fkgL-HpZdj=5ZEGNWcESCHQpgRAYQA3W2sPZaoEpNyQ@mail.gmail.com>
 <20230607054246-mutt-send-email-mst@kernel.org>
 <CACGkMEuUapKvUYiJiLwtsN+x941jafDKS9tuSkiNrvkrrSmQkg@mail.gmail.com>
 <20230608020111-mutt-send-email-mst@kernel.org>
 <CACGkMEt4=3BRVNX38AD+mJU8v3bmqO-CdNj5NkFP-SSvsuy2Hg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEt4=3BRVNX38AD+mJU8v3bmqO-CdNj5NkFP-SSvsuy2Hg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 03:46:00PM +0800, Jason Wang wrote:
> On Thu, Jun 8, 2023 at 2:03 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Thu, Jun 08, 2023 at 08:42:15AM +0800, Jason Wang wrote:
> > > On Wed, Jun 7, 2023 at 5:43 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Wed, Jun 07, 2023 at 10:39:15AM +0200, Stefano Garzarella wrote:
> > > > > On Tue, Jun 6, 2023 at 2:58 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Tue, Jun 06, 2023 at 09:29:22AM +0800, Jason Wang wrote:
> > > > > > > On Mon, Jun 5, 2023 at 10:58 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Mon, Jun 05, 2023 at 09:54:57AM -0400, Michael S. Tsirkin wrote:
> > > > > > > > >On Mon, Jun 05, 2023 at 03:30:35PM +0200, Stefano Garzarella wrote:
> > > > > > > > >> On Mon, Jun 05, 2023 at 09:00:25AM -0400, Michael S. Tsirkin wrote:
> > > > > > > > >> > On Mon, Jun 05, 2023 at 02:54:20PM +0200, Stefano Garzarella wrote:
> > > > > > > > >> > > On Mon, Jun 05, 2023 at 08:41:54AM -0400, Michael S. Tsirkin wrote:
> > > > > > > > >> > > > On Mon, Jun 05, 2023 at 01:06:44PM +0200, Stefano Garzarella wrote:
> > > > > > > > >> > > > > vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE)
> > > > > > > > >> > > > > don't support packed virtqueue well yet, so let's filter the
> > > > > > > > >> > > > > VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get_features().
> > > > > > > > >> > > > >
> > > > > > > > >> > > > > This way, even if the device supports it, we don't risk it being
> > > > > > > > >> > > > > negotiated, then the VMM is unable to set the vring state properly.
> > > > > > > > >> > > > >
> > > > > > > > >> > > > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> > > > > > > > >> > > > > Cc: stable@vger.kernel.org
> > > > > > > > >> > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > > > > > > >> > > > > ---
> > > > > > > > >> > > > >
> > > > > > > > >> > > > > Notes:
> > > > > > > > >> > > > >     This patch should be applied before the "[PATCH v2 0/3] vhost_vdpa:
> > > > > > > > >> > > > >     better PACKED support" series [1] and backported in stable branches.
> > > > > > > > >> > > > >
> > > > > > > > >> > > > >     We can revert it when we are sure that everything is working with
> > > > > > > > >> > > > >     packed virtqueues.
> > > > > > > > >> > > > >
> > > > > > > > >> > > > >     Thanks,
> > > > > > > > >> > > > >     Stefano
> > > > > > > > >> > > > >
> > > > > > > > >> > > > >     [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
> > > > > > > > >> > > >
> > > > > > > > >> > > > I'm a bit lost here. So why am I merging "better PACKED support" then?
> > > > > > > > >> > >
> > > > > > > > >> > > To really support packed virtqueue with vhost-vdpa, at that point we would
> > > > > > > > >> > > also have to revert this patch.
> > > > > > > > >> > >
> > > > > > > > >> > > I wasn't sure if you wanted to queue the series for this merge window.
> > > > > > > > >> > > In that case do you think it is better to send this patch only for stable
> > > > > > > > >> > > branches?
> > > > > > > > >> > > > Does this patch make them a NOP?
> > > > > > > > >> > >
> > > > > > > > >> > > Yep, after applying the "better PACKED support" series and being
> > > > > > > > >> > > sure that
> > > > > > > > >> > > the IOCTLs of vhost-vdpa support packed virtqueue, we should revert this
> > > > > > > > >> > > patch.
> > > > > > > > >> > >
> > > > > > > > >> > > Let me know if you prefer a different approach.
> > > > > > > > >> > >
> > > > > > > > >> > > I'm concerned that QEMU uses vhost-vdpa IOCTLs thinking that the kernel
> > > > > > > > >> > > interprets them the right way, when it does not.
> > > > > > > > >> > >
> > > > > > > > >> > > Thanks,
> > > > > > > > >> > > Stefano
> > > > > > > > >> > >
> > > > > > > > >> >
> > > > > > > > >> > If this fixes a bug can you add Fixes tags to each of them? Then it's ok
> > > > > > > > >> > to merge in this window. Probably easier than the elaborate
> > > > > > > > >> > mask/unmask dance.
> > > > > > > > >>
> > > > > > > > >> CCing Shannon (the original author of the "better PACKED support"
> > > > > > > > >> series).
> > > > > > > > >>
> > > > > > > > >> IIUC Shannon is going to send a v3 of that series to fix the
> > > > > > > > >> documentation, so Shannon can you also add the Fixes tags?
> > > > > > > > >>
> > > > > > > > >> Thanks,
> > > > > > > > >> Stefano
> > > > > > > > >
> > > > > > > > >Well this is in my tree already. Just reply with
> > > > > > > > >Fixes: <>
> > > > > > > > >to each and I will add these tags.
> > > > > > > >
> > > > > > > > I tried, but it is not easy since we added the support for packed
> > > > > > > > virtqueue in vdpa and vhost incrementally.
> > > > > > > >
> > > > > > > > Initially I was thinking of adding the same tag used here:
> > > > > > > >
> > > > > > > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> > > > > > > >
> > > > > > > > Then I discovered that vq_state wasn't there, so I was thinking of
> > > > > > > >
> > > > > > > > Fixes: 530a5678bc00 ("vdpa: support packed virtqueue for set/get_vq_state()")
> > > > > > > >
> > > > > > > > So we would have to backport quite a few patches into the stable branches.
> > > > > > > > I don't know if it's worth it...
> > > > > > > >
> > > > > > > > I still think it is better to disable packed in the stable branches,
> > > > > > > > otherwise I have to make a list of all the patches we need.
> > > > > > > >
> > > > > > > > Any other ideas?
> > > > > > >
> > > > > > > AFAIK, except for vp_vdpa, pds seems to be the first parent that
> > > > > > > supports packed virtqueue. Users should not notice anything wrong if
> > > > > > > they don't use packed virtqueue. And the problem of vp_vdpa + packed
> > > > > > > virtqueue came since the day0 of vp_vdpa. It seems fine to do nothing
> > > > > > > I guess.
> > > > > > >
> > > > > > > Thanks
> > > > > >
> > > > > >
> > > > > > I have a question though, what if down the road there
> > > > > > is a new feature that needs more changes? It will be
> > > > > > broken too just like PACKED no?
> > > > > > Shouldn't vdpa have an allowlist of features it knows how
> > > > > > to support?
> > > > >
> > > > > It looks like we had it, but we took it out (by the way, we were
> > > > > enabling packed even though we didn't support it):
> > > > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6234f80574d7569444d8718355fa2838e92b158b
> > > > >
> > > > > The only problem I see is that for each new feature we have to modify
> > > > > the kernel.
> > > > > Could we have new features that don't require handling by vhost-vdpa?
> > > > >
> > > > > Thanks,
> > > > > Stefano
> > > >
> > > > Jason what do you say to reverting this?
> > >
> > > I may miss something but I don't see any problem with vDPA core.
> > >
> > > It's the duty of the parents to advertise the features it has. For example,
> > >
> > > 1) If some kernel version that is packed is not supported via
> > > set_vq_state, parents should not advertise PACKED features in this
> > > case.
> > > 2) If the kernel has support packed set_vq_state(), but it's emulated
> > > cvq doesn't support, parents should not advertise PACKED as well
> > >
> > > If a parent violates the above 2, it looks like a bug of the parents.
> > >
> > > Thanks
> >
> > Yes but what about vhost_vdpa? Talking about that not the core.
> 
> Not sure it's a good idea to workaround parent bugs via vhost-vDPA.

these are not parent bugs. vhost-vdpa did not pass ioctl data
correctly to parent, right?

> > Should that not have a whitelist of features
> > since it interprets ioctls differently depending on this?
> 
> If there's a bug, it might only matter the following setup:
> 
> SET_VRING_BASE/GET_VRING_BASE + VDUSE.

Why does it not apply to any parent?

> This seems to be broken since VDUSE was introduced. If we really want
> to backport something, it could be a fix to filter out PACKED in
> VDUSE?
> 
> Thanks

what prevents VDUSE from supporting packed?

> >
> > > >
> > > > --
> > > > MST
> > > >
> >


