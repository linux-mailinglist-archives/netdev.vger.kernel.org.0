Return-Path: <netdev+bounces-2825-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BADA470438A
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 04:45:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC1B11C20CEE
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 02:45:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE1C6621;
	Tue, 16 May 2023 02:45:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF45C23C1
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 02:45:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83087E79
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 19:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684205099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XOtiAl8xEr+yF4q9V8Mv37+Ez0ZSu8GNo6YwcqTW6us=;
	b=StAe0AYuQxd+BqvTQdlkvBnbw5NlMYR0v/O3d4kXZC08tXgnsHdb1ezYR+ET3yqW6ebdEW
	cjLW9Are44cvA5PxgcKpHlQoqRvrM5jHQ0ypgm0BshxPBMDjqLsTT5YPmbEZQuys8tn50W
	/Z2o9HXTOoVii2Obahce12yrJmk6BIo=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-144-LKKZhbwyNxCXMCuauAQ_rQ-1; Mon, 15 May 2023 22:44:58 -0400
X-MC-Unique: LKKZhbwyNxCXMCuauAQ_rQ-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-4f002e0e56dso7714583e87.3
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 19:44:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684205097; x=1686797097;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XOtiAl8xEr+yF4q9V8Mv37+Ez0ZSu8GNo6YwcqTW6us=;
        b=AS8c7ZnijXFHhHhyvpDnKfzbvsshaQ+dngVTcmSpAf9I/xZfpA2n+jKEhvsSiGuUKb
         QeJa9PdUIX1YQVBLj2kXxKFDn2/ojAemZQCb0wA+JccURq6LA2X3+awS6krBNgXmxwnL
         GEjGK6WLP6w1FA9vyz/bu6YXNO+Z/6xXSV7D+0nH6DSS0RcHDqmJHY6xxP7q4DDPngPG
         s6JGUukwtfyofvhFVm2iYhVI3kc3yu0IQb6+gzwfQTq4i07ZcEmlXgeoIzzB5nh3AkZL
         q64pBOP87hZMcCUY0HhVp9/af3gISPXzg5HSgCFhdJGV72EZPAym+5GJqyuReNoPf+KB
         uJhg==
X-Gm-Message-State: AC+VfDz79K8r4HPDJZ9antXUqk6NLD4uH1713TPDKYZ893gNdpxcbmlS
	ZBzm2cp0eo5rXK97zBOIqWHBmIxzACxTCIkkrqx+JlT6luEMVOjlJBe1ob7kt4hW5raNgOloZym
	duel2+iYDXxJ13z6WcKrY7X/+VNCngG/r
X-Received: by 2002:a05:6512:4ce:b0:4f1:4d8c:1d21 with SMTP id w14-20020a05651204ce00b004f14d8c1d21mr7882544lfq.61.1684205096829;
        Mon, 15 May 2023 19:44:56 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6SX3NNInS5JM11CnSdd/RQUe4EjlvNV3aF41mBtFpvesjIsE4L2Uy2YEav+fOPTOaHB91hUPwXs99PQU4gbws=
X-Received: by 2002:a05:6512:4ce:b0:4f1:4d8c:1d21 with SMTP id
 w14-20020a05651204ce00b004f14d8c1d21mr7882521lfq.61.1684205096498; Mon, 15
 May 2023 19:44:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230413064027.13267-1-jasowang@redhat.com> <20230413064027.13267-2-jasowang@redhat.com>
 <20230413121525-mutt-send-email-mst@kernel.org> <CACGkMEunn1Z3n8yjVaWLqdV502yjaCBSAb_LO4KsB0nuxXmV8A@mail.gmail.com>
 <20230414031947-mutt-send-email-mst@kernel.org> <CACGkMEtutGn0CoJhoPHbzPuqoCLb4OCT6a_vB_WPV=MhwY0DXg@mail.gmail.com>
 <20230510012951-mutt-send-email-mst@kernel.org> <CACGkMEszPydzw_MOUOVJKBBW_8iYn66i_9OFvLDoZMH34hMx=w@mail.gmail.com>
 <20230515004422-mutt-send-email-mst@kernel.org> <CACGkMEv+Q2UoBarNOzKSrc3O=Wb2_73O2j9cZXFdAiLBm1qY-Q@mail.gmail.com>
 <20230515061455-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230515061455-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 16 May 2023 10:44:45 +0800
Message-ID: <CACGkMEt8QkK1PnTrRUjDbyJheBurdibr4--Es8P0Y9NZM659pQ@mail.gmail.com>
Subject: Re: [PATCH net-next V2 1/2] virtio-net: convert rx mode setting to
 use workqueue
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, virtualization@lists.linux-foundation.org, 
	linux-kernel@vger.kernel.org, maxime.coquelin@redhat.com, 
	alvaro.karsz@solid-run.com, eperezma@redhat.com, xuanzhuo@linux.alibaba.com, 
	david.marchand@redhat.com, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 6:17=E2=80=AFPM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Mon, May 15, 2023 at 01:13:33PM +0800, Jason Wang wrote:
> > On Mon, May 15, 2023 at 12:45=E2=80=AFPM Michael S. Tsirkin <mst@redhat=
.com> wrote:
> > >
> > > On Mon, May 15, 2023 at 09:05:54AM +0800, Jason Wang wrote:
> > > > On Wed, May 10, 2023 at 1:33=E2=80=AFPM Michael S. Tsirkin <mst@red=
hat.com> wrote:
> > > > >
> > > > > On Mon, Apr 17, 2023 at 11:40:58AM +0800, Jason Wang wrote:
> > > > > > On Fri, Apr 14, 2023 at 3:21=E2=80=AFPM Michael S. Tsirkin <mst=
@redhat.com> wrote:
> > > > > > >
> > > > > > > On Fri, Apr 14, 2023 at 01:04:15PM +0800, Jason Wang wrote:
> > > > > > > > Forget to cc netdev, adding.
> > > > > > > >
> > > > > > > > On Fri, Apr 14, 2023 at 12:25=E2=80=AFAM Michael S. Tsirkin=
 <mst@redhat.com> wrote:
> > > > > > > > >
> > > > > > > > > On Thu, Apr 13, 2023 at 02:40:26PM +0800, Jason Wang wrot=
e:
> > > > > > > > > > This patch convert rx mode setting to be done in a work=
queue, this is
> > > > > > > > > > a must for allow to sleep when waiting for the cvq comm=
and to
> > > > > > > > > > response since current code is executed under addr spin=
 lock.
> > > > > > > > > >
> > > > > > > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > > > > >
> > > > > > > > > I don't like this frankly. This means that setting RX mod=
e which would
> > > > > > > > > previously be reliable, now becomes unreliable.
> > > > > > > >
> > > > > > > > It is "unreliable" by design:
> > > > > > > >
> > > > > > > >       void                    (*ndo_set_rx_mode)(struct net=
_device *dev);
> > > > > > > >
> > > > > > > > > - first of all configuration is no longer immediate
> > > > > > > >
> > > > > > > > Is immediate a hard requirement? I can see a workqueue is u=
sed at least:
> > > > > > > >
> > > > > > > > mlx5e, ipoib, efx, ...
> > > > > > > >
> > > > > > > > >   and there is no way for driver to find out when
> > > > > > > > >   it actually took effect
> > > > > > > >
> > > > > > > > But we know rx mode is best effort e.g it doesn't support v=
host and we
> > > > > > > > survive from this for years.
> > > > > > > >
> > > > > > > > > - second, if device fails command, this is also not
> > > > > > > > >   propagated to driver, again no way for driver to find o=
ut
> > > > > > > > >
> > > > > > > > > VDUSE needs to be fixed to do tricks to fix this
> > > > > > > > > without breaking normal drivers.
> > > > > > > >
> > > > > > > > It's not specific to VDUSE. For example, when using virtio-=
net in the
> > > > > > > > UP environment with any software cvq (like mlx5 via vDPA or=
 cma
> > > > > > > > transport).
> > > > > > > >
> > > > > > > > Thanks
> > > > > > >
> > > > > > > Hmm. Can we differentiate between these use-cases?
> > > > > >
> > > > > > It doesn't look easy since we are drivers for virtio bus. Under=
layer
> > > > > > details were hidden from virtio-net.
> > > > > >
> > > > > > Or do you have any ideas on this?
> > > > > >
> > > > > > Thanks
> > > > >
> > > > > I don't know, pass some kind of flag in struct virtqueue?
> > > > >         "bool slow; /* This vq can be very slow sometimes. Don't =
wait for it! */"
> > > > >
> > > > > ?
> > > > >
> > > >
> > > > So if it's slow, sleep, otherwise poll?
> > > >
> > > > I feel setting this flag might be tricky, since the driver doesn't
> > > > know whether or not it's really slow. E.g smartNIC vendor may allow
> > > > virtio-net emulation over PCI.
> > > >
> > > > Thanks
> > >
> > > driver will have the choice, depending on whether
> > > vq is deterministic or not.
> >
> > Ok, but the problem is, such booleans are only useful for virtio ring
> > codes. But in this case, virtio-net knows what to do for cvq. So I'm
> > not sure who the user is.
> >
> > Thanks
>
> Circling back, what exactly does the architecture you are trying
> to fix look like? Who is going to introduce unbounded latency?
> The hypervisor?

Hypervisor is one of the possible reason, we have many more:

Hardware device that provides virtio-pci emulation.
Userspace devices like VDUSE.

> If so do we not maybe want a new feature bit
> that documents this? Hypervisor then can detect old guests
> that spin and decide what to do, e.g. prioritise cvq more,
> or fail FEATURES_OK.

We suffer from this for bare metal as well.

But a question is what's wrong with the approach that is used in this
patch? I've answered that set_rx_mode is not reliable, so it should be
fine to use workqueue. Except for this, any other thing that worries
you?

Thanks

>
> > >
> > >
> > > > > --
> > > > > MST
> > > > >
> > >
>


