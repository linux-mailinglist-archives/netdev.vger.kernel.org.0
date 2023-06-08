Return-Path: <netdev+bounces-9139-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06365727705
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 08:03:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48EE3281683
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 06:03:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29A2D63B3;
	Thu,  8 Jun 2023 06:03:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1718B4C84
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 06:03:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291E126BF
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 23:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686204208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LUP1t8+/wdVLK6VBS33/A2HY/mNmkYzUjFS3Usth32g=;
	b=Cr+wH+FlVAbB7jDUv6dWMgfPH3XZ5S7zpT0pzfc+bLJp3XgP1A7ddvHONvoa0SO/i80Bo0
	VzvhnX3iqhAPimNzPWa/x8nKvCsNVQgZxzwHSKnRQcW6IUwo9AY3gMzKXINaXzBPKYkSke
	pgXINU8PiPIm5gbo4w+Duig3EIlveIc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-542-uBb884FGM1-ygnTbHp5j7g-1; Thu, 08 Jun 2023 02:03:25 -0400
X-MC-Unique: uBb884FGM1-ygnTbHp5j7g-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f72720c592so1040585e9.2
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 23:03:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686204204; x=1688796204;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LUP1t8+/wdVLK6VBS33/A2HY/mNmkYzUjFS3Usth32g=;
        b=U4wUzJnRFQordSQtlnrVEOhjKuWJnK/1wH+YaA8EHjXeocKUNvmio+IqsNcHiT1jx7
         kiJq+QHLIlhrA7XAlRD6YLOR/zb8c9RuTXgmVAcpAjT+IZeMplTt9nijZhOhedWhhsnh
         QLIwwLK7Lg9yknMa7JlMET4YvcJYs0cC7jO9IMcHzdvRsiUhrrUdw+HCDW+Htdx4M1jJ
         Fi5WmwI5QfLdEztCK7jQNRsmQ7CRqZSfn4FA+l7rue6djwP5RITRxfSLl6ipEjC6WKc5
         arJezswhg/g3QZpOZGS1P9+UX5P4XbT+7uHXHFwf5drIMU3QtHztWmwUB3ovS7ZY6Uoi
         m/DA==
X-Gm-Message-State: AC+VfDzZEtdQIujNkdQB08gsC/rTSM8nWuCq+s67BOM1eOWHarG3LrjS
	1L7Q/9SBQU2WHZjCMYrtS6yBIzGmqL4EajqEkb4ox4RojRHpcTI13QB44dk26K6VlgVthzrdDxT
	0eiZzmLG+b15So5ew
X-Received: by 2002:a05:6000:1048:b0:30e:56d9:d7ac with SMTP id c8-20020a056000104800b0030e56d9d7acmr3159051wrx.35.1686204204553;
        Wed, 07 Jun 2023 23:03:24 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6XOPN6+czxWNphCYhbqVa6CfYIa1tItvfka0vY5H/n/q6uIYGPbcpI3V2k64M16atx9nylQw==
X-Received: by 2002:a05:6000:1048:b0:30e:56d9:d7ac with SMTP id c8-20020a056000104800b0030e56d9d7acmr3159029wrx.35.1686204204156;
        Wed, 07 Jun 2023 23:03:24 -0700 (PDT)
Received: from redhat.com ([2.55.41.2])
        by smtp.gmail.com with ESMTPSA id h4-20020adffa84000000b0030647d1f34bsm470894wrr.1.2023.06.07.23.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 23:03:23 -0700 (PDT)
Date: Thu, 8 Jun 2023 02:03:18 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Tiwei Bie <tiwei.bie@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: filter VIRTIO_F_RING_PACKED feature
Message-ID: <20230608020111-mutt-send-email-mst@kernel.org>
References: <24fjdwp44hovz3d3qkzftmvjie45er3g3boac7aezpvzbwvuol@lmo47ydvnqau>
 <20230605085840-mutt-send-email-mst@kernel.org>
 <gi2hngx3ndsgz5d2rpqjywdmou5vxhd7xgi5z2lbachr7yoos4@kpifz37oz2et>
 <20230605095404-mutt-send-email-mst@kernel.org>
 <32ejjuvhvcicv7wjuetkv34qtlpa657n4zlow4eq3fsi2twozk@iqnd2t5tw2an>
 <CACGkMEu3PqQ99UoKF5NHgVADD3q=BF6jhLiyumeT4S1QCqN1tw@mail.gmail.com>
 <20230606085643-mutt-send-email-mst@kernel.org>
 <CAGxU2F7fkgL-HpZdj=5ZEGNWcESCHQpgRAYQA3W2sPZaoEpNyQ@mail.gmail.com>
 <20230607054246-mutt-send-email-mst@kernel.org>
 <CACGkMEuUapKvUYiJiLwtsN+x941jafDKS9tuSkiNrvkrrSmQkg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEuUapKvUYiJiLwtsN+x941jafDKS9tuSkiNrvkrrSmQkg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 08:42:15AM +0800, Jason Wang wrote:
> On Wed, Jun 7, 2023 at 5:43 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Wed, Jun 07, 2023 at 10:39:15AM +0200, Stefano Garzarella wrote:
> > > On Tue, Jun 6, 2023 at 2:58 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Tue, Jun 06, 2023 at 09:29:22AM +0800, Jason Wang wrote:
> > > > > On Mon, Jun 5, 2023 at 10:58 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> > > > > >
> > > > > > On Mon, Jun 05, 2023 at 09:54:57AM -0400, Michael S. Tsirkin wrote:
> > > > > > >On Mon, Jun 05, 2023 at 03:30:35PM +0200, Stefano Garzarella wrote:
> > > > > > >> On Mon, Jun 05, 2023 at 09:00:25AM -0400, Michael S. Tsirkin wrote:
> > > > > > >> > On Mon, Jun 05, 2023 at 02:54:20PM +0200, Stefano Garzarella wrote:
> > > > > > >> > > On Mon, Jun 05, 2023 at 08:41:54AM -0400, Michael S. Tsirkin wrote:
> > > > > > >> > > > On Mon, Jun 05, 2023 at 01:06:44PM +0200, Stefano Garzarella wrote:
> > > > > > >> > > > > vhost-vdpa IOCTLs (eg. VHOST_GET_VRING_BASE, VHOST_SET_VRING_BASE)
> > > > > > >> > > > > don't support packed virtqueue well yet, so let's filter the
> > > > > > >> > > > > VIRTIO_F_RING_PACKED feature for now in vhost_vdpa_get_features().
> > > > > > >> > > > >
> > > > > > >> > > > > This way, even if the device supports it, we don't risk it being
> > > > > > >> > > > > negotiated, then the VMM is unable to set the vring state properly.
> > > > > > >> > > > >
> > > > > > >> > > > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> > > > > > >> > > > > Cc: stable@vger.kernel.org
> > > > > > >> > > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > > > > >> > > > > ---
> > > > > > >> > > > >
> > > > > > >> > > > > Notes:
> > > > > > >> > > > >     This patch should be applied before the "[PATCH v2 0/3] vhost_vdpa:
> > > > > > >> > > > >     better PACKED support" series [1] and backported in stable branches.
> > > > > > >> > > > >
> > > > > > >> > > > >     We can revert it when we are sure that everything is working with
> > > > > > >> > > > >     packed virtqueues.
> > > > > > >> > > > >
> > > > > > >> > > > >     Thanks,
> > > > > > >> > > > >     Stefano
> > > > > > >> > > > >
> > > > > > >> > > > >     [1] https://lore.kernel.org/virtualization/20230424225031.18947-1-shannon.nelson@amd.com/
> > > > > > >> > > >
> > > > > > >> > > > I'm a bit lost here. So why am I merging "better PACKED support" then?
> > > > > > >> > >
> > > > > > >> > > To really support packed virtqueue with vhost-vdpa, at that point we would
> > > > > > >> > > also have to revert this patch.
> > > > > > >> > >
> > > > > > >> > > I wasn't sure if you wanted to queue the series for this merge window.
> > > > > > >> > > In that case do you think it is better to send this patch only for stable
> > > > > > >> > > branches?
> > > > > > >> > > > Does this patch make them a NOP?
> > > > > > >> > >
> > > > > > >> > > Yep, after applying the "better PACKED support" series and being
> > > > > > >> > > sure that
> > > > > > >> > > the IOCTLs of vhost-vdpa support packed virtqueue, we should revert this
> > > > > > >> > > patch.
> > > > > > >> > >
> > > > > > >> > > Let me know if you prefer a different approach.
> > > > > > >> > >
> > > > > > >> > > I'm concerned that QEMU uses vhost-vdpa IOCTLs thinking that the kernel
> > > > > > >> > > interprets them the right way, when it does not.
> > > > > > >> > >
> > > > > > >> > > Thanks,
> > > > > > >> > > Stefano
> > > > > > >> > >
> > > > > > >> >
> > > > > > >> > If this fixes a bug can you add Fixes tags to each of them? Then it's ok
> > > > > > >> > to merge in this window. Probably easier than the elaborate
> > > > > > >> > mask/unmask dance.
> > > > > > >>
> > > > > > >> CCing Shannon (the original author of the "better PACKED support"
> > > > > > >> series).
> > > > > > >>
> > > > > > >> IIUC Shannon is going to send a v3 of that series to fix the
> > > > > > >> documentation, so Shannon can you also add the Fixes tags?
> > > > > > >>
> > > > > > >> Thanks,
> > > > > > >> Stefano
> > > > > > >
> > > > > > >Well this is in my tree already. Just reply with
> > > > > > >Fixes: <>
> > > > > > >to each and I will add these tags.
> > > > > >
> > > > > > I tried, but it is not easy since we added the support for packed
> > > > > > virtqueue in vdpa and vhost incrementally.
> > > > > >
> > > > > > Initially I was thinking of adding the same tag used here:
> > > > > >
> > > > > > Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
> > > > > >
> > > > > > Then I discovered that vq_state wasn't there, so I was thinking of
> > > > > >
> > > > > > Fixes: 530a5678bc00 ("vdpa: support packed virtqueue for set/get_vq_state()")
> > > > > >
> > > > > > So we would have to backport quite a few patches into the stable branches.
> > > > > > I don't know if it's worth it...
> > > > > >
> > > > > > I still think it is better to disable packed in the stable branches,
> > > > > > otherwise I have to make a list of all the patches we need.
> > > > > >
> > > > > > Any other ideas?
> > > > >
> > > > > AFAIK, except for vp_vdpa, pds seems to be the first parent that
> > > > > supports packed virtqueue. Users should not notice anything wrong if
> > > > > they don't use packed virtqueue. And the problem of vp_vdpa + packed
> > > > > virtqueue came since the day0 of vp_vdpa. It seems fine to do nothing
> > > > > I guess.
> > > > >
> > > > > Thanks
> > > >
> > > >
> > > > I have a question though, what if down the road there
> > > > is a new feature that needs more changes? It will be
> > > > broken too just like PACKED no?
> > > > Shouldn't vdpa have an allowlist of features it knows how
> > > > to support?
> > >
> > > It looks like we had it, but we took it out (by the way, we were
> > > enabling packed even though we didn't support it):
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6234f80574d7569444d8718355fa2838e92b158b
> > >
> > > The only problem I see is that for each new feature we have to modify
> > > the kernel.
> > > Could we have new features that don't require handling by vhost-vdpa?
> > >
> > > Thanks,
> > > Stefano
> >
> > Jason what do you say to reverting this?
> 
> I may miss something but I don't see any problem with vDPA core.
> 
> It's the duty of the parents to advertise the features it has. For example,
> 
> 1) If some kernel version that is packed is not supported via
> set_vq_state, parents should not advertise PACKED features in this
> case.
> 2) If the kernel has support packed set_vq_state(), but it's emulated
> cvq doesn't support, parents should not advertise PACKED as well
> 
> If a parent violates the above 2, it looks like a bug of the parents.
> 
> Thanks

Yes but what about vhost_vdpa? Talking about that not the core.
Should that not have a whitelist of features
since it interprets ioctls differently depending on this?

> >
> > --
> > MST
> >


