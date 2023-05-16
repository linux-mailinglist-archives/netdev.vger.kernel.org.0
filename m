Return-Path: <netdev+bounces-2845-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEDA370443D
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 06:13:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2D701C20CCE
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 04:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94F1A3D8E;
	Tue, 16 May 2023 04:13:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835F12566
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 04:13:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF77EE64
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 21:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684210382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p249AUCyOn+avTIqZrVK1ogk3k6y7lStqJYRaHHwRL8=;
	b=RG4YLCfIXwXM6kVoRmT02kJp/rAPC08Ybbh/jPJUP7xEt0bpS6IRDQOIj0HMc763BTbOsd
	C2BDh1Ud4UBLgpdex2bx/DxaDxDynn9Te4M+kE/gfrNcw7iYUKMU/aX4x7gHh5Y3xId4/g
	Nh9nM29xXBuycNxbwBS4iIW1Cow7hnE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-456-zjNnPIqaPjCmEGjgty1hog-1; Tue, 16 May 2023 00:13:01 -0400
X-MC-Unique: zjNnPIqaPjCmEGjgty1hog-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-306311a2b99so5312103f8f.1
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 21:13:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684210380; x=1686802380;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p249AUCyOn+avTIqZrVK1ogk3k6y7lStqJYRaHHwRL8=;
        b=fVP28RZOdj0fmSWzCcKZUvXJAzGHpI7ygTMcqV/Nb/4CF582ZVXW/mC/wyKDjydpaF
         VAfKOgIx9m/6li9sZ9CpKXQOg6qIKti3JIzBePI84mD8FDZydhi6bEWpCP/vNAw0C+zk
         s68iIAmGFXJLZ1RQz6Jkbq7d0wkE7+bhuXVwXhZTYuAcSgXvD6vNxHLvC1SYn627JxMF
         eSFdu8SpCw+x3XXeq7WzSjPdlgiNALEfnLkIxgkg5djuiqhZSRFWL1Ei/QhLwmaH5Bjy
         rRf5z1SF09FaQ3qz0tgMYXKCgHd7VBM2nFVJS0W60nqAVuCyE1aPuTjutiBV5s1G0huh
         ITPw==
X-Gm-Message-State: AC+VfDwOcUfjwxyHZiO6/KQSGu/Qa2LyMgRtsNtyIY2uoSaACVSPAJAr
	HarNUhOoMiwmO4UbneRMhy/aOeNHEXnz5EXECvKZrP6Tg7qJghsYjmnrbQn5UxsipJtS512oTE3
	ULXKPfnljgK1OVgrR
X-Received: by 2002:a5d:594e:0:b0:307:8691:1ea5 with SMTP id e14-20020a5d594e000000b0030786911ea5mr21650390wri.26.1684210380060;
        Mon, 15 May 2023 21:13:00 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7H1AJI3NBhLEY2iVQia+EcKFbxTad+7L3OHQXq8IrXlYUpjX6KWFyz1nHm1Dqsau8LN35wbw==
X-Received: by 2002:a5d:594e:0:b0:307:8691:1ea5 with SMTP id e14-20020a5d594e000000b0030786911ea5mr21650380wri.26.1684210379747;
        Mon, 15 May 2023 21:12:59 -0700 (PDT)
Received: from redhat.com ([2.52.26.5])
        by smtp.gmail.com with ESMTPSA id i18-20020a5d5592000000b00307acec258esm1075667wrv.3.2023.05.15.21.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 21:12:59 -0700 (PDT)
Date: Tue, 16 May 2023 00:12:55 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org, maxime.coquelin@redhat.com,
	alvaro.karsz@solid-run.com, eperezma@redhat.com,
	xuanzhuo@linux.alibaba.com, david.marchand@redhat.com,
	netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next V2 1/2] virtio-net: convert rx mode setting to
 use workqueue
Message-ID: <20230516000829-mutt-send-email-mst@kernel.org>
References: <20230413121525-mutt-send-email-mst@kernel.org>
 <CACGkMEunn1Z3n8yjVaWLqdV502yjaCBSAb_LO4KsB0nuxXmV8A@mail.gmail.com>
 <20230414031947-mutt-send-email-mst@kernel.org>
 <CACGkMEtutGn0CoJhoPHbzPuqoCLb4OCT6a_vB_WPV=MhwY0DXg@mail.gmail.com>
 <20230510012951-mutt-send-email-mst@kernel.org>
 <CACGkMEszPydzw_MOUOVJKBBW_8iYn66i_9OFvLDoZMH34hMx=w@mail.gmail.com>
 <20230515004422-mutt-send-email-mst@kernel.org>
 <CACGkMEv+Q2UoBarNOzKSrc3O=Wb2_73O2j9cZXFdAiLBm1qY-Q@mail.gmail.com>
 <20230515061455-mutt-send-email-mst@kernel.org>
 <CACGkMEt8QkK1PnTrRUjDbyJheBurdibr4--Es8P0Y9NZM659pQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEt8QkK1PnTrRUjDbyJheBurdibr4--Es8P0Y9NZM659pQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 10:44:45AM +0800, Jason Wang wrote:
> On Mon, May 15, 2023 at 6:17 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, May 15, 2023 at 01:13:33PM +0800, Jason Wang wrote:
> > > On Mon, May 15, 2023 at 12:45 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Mon, May 15, 2023 at 09:05:54AM +0800, Jason Wang wrote:
> > > > > On Wed, May 10, 2023 at 1:33 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Mon, Apr 17, 2023 at 11:40:58AM +0800, Jason Wang wrote:
> > > > > > > On Fri, Apr 14, 2023 at 3:21 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Fri, Apr 14, 2023 at 01:04:15PM +0800, Jason Wang wrote:
> > > > > > > > > Forget to cc netdev, adding.
> > > > > > > > >
> > > > > > > > > On Fri, Apr 14, 2023 at 12:25 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > > > >
> > > > > > > > > > On Thu, Apr 13, 2023 at 02:40:26PM +0800, Jason Wang wrote:
> > > > > > > > > > > This patch convert rx mode setting to be done in a workqueue, this is
> > > > > > > > > > > a must for allow to sleep when waiting for the cvq command to
> > > > > > > > > > > response since current code is executed under addr spin lock.
> > > > > > > > > > >
> > > > > > > > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > > > > > >
> > > > > > > > > > I don't like this frankly. This means that setting RX mode which would
> > > > > > > > > > previously be reliable, now becomes unreliable.
> > > > > > > > >
> > > > > > > > > It is "unreliable" by design:
> > > > > > > > >
> > > > > > > > >       void                    (*ndo_set_rx_mode)(struct net_device *dev);
> > > > > > > > >
> > > > > > > > > > - first of all configuration is no longer immediate
> > > > > > > > >
> > > > > > > > > Is immediate a hard requirement? I can see a workqueue is used at least:
> > > > > > > > >
> > > > > > > > > mlx5e, ipoib, efx, ...
> > > > > > > > >
> > > > > > > > > >   and there is no way for driver to find out when
> > > > > > > > > >   it actually took effect
> > > > > > > > >
> > > > > > > > > But we know rx mode is best effort e.g it doesn't support vhost and we
> > > > > > > > > survive from this for years.
> > > > > > > > >
> > > > > > > > > > - second, if device fails command, this is also not
> > > > > > > > > >   propagated to driver, again no way for driver to find out
> > > > > > > > > >
> > > > > > > > > > VDUSE needs to be fixed to do tricks to fix this
> > > > > > > > > > without breaking normal drivers.
> > > > > > > > >
> > > > > > > > > It's not specific to VDUSE. For example, when using virtio-net in the
> > > > > > > > > UP environment with any software cvq (like mlx5 via vDPA or cma
> > > > > > > > > transport).
> > > > > > > > >
> > > > > > > > > Thanks
> > > > > > > >
> > > > > > > > Hmm. Can we differentiate between these use-cases?
> > > > > > >
> > > > > > > It doesn't look easy since we are drivers for virtio bus. Underlayer
> > > > > > > details were hidden from virtio-net.
> > > > > > >
> > > > > > > Or do you have any ideas on this?
> > > > > > >
> > > > > > > Thanks
> > > > > >
> > > > > > I don't know, pass some kind of flag in struct virtqueue?
> > > > > >         "bool slow; /* This vq can be very slow sometimes. Don't wait for it! */"
> > > > > >
> > > > > > ?
> > > > > >
> > > > >
> > > > > So if it's slow, sleep, otherwise poll?
> > > > >
> > > > > I feel setting this flag might be tricky, since the driver doesn't
> > > > > know whether or not it's really slow. E.g smartNIC vendor may allow
> > > > > virtio-net emulation over PCI.
> > > > >
> > > > > Thanks
> > > >
> > > > driver will have the choice, depending on whether
> > > > vq is deterministic or not.
> > >
> > > Ok, but the problem is, such booleans are only useful for virtio ring
> > > codes. But in this case, virtio-net knows what to do for cvq. So I'm
> > > not sure who the user is.
> > >
> > > Thanks
> >
> > Circling back, what exactly does the architecture you are trying
> > to fix look like? Who is going to introduce unbounded latency?
> > The hypervisor?
> 
> Hypervisor is one of the possible reason, we have many more:
> 
> Hardware device that provides virtio-pci emulation.
> Userspace devices like VDUSE.

So let's start by addressing VDUSE maybe?

> > If so do we not maybe want a new feature bit
> > that documents this? Hypervisor then can detect old guests
> > that spin and decide what to do, e.g. prioritise cvq more,
> > or fail FEATURES_OK.
> 
> We suffer from this for bare metal as well.
> 
> But a question is what's wrong with the approach that is used in this
> patch? I've answered that set_rx_mode is not reliable, so it should be
> fine to use workqueue. Except for this, any other thing that worries
> you?
> 
> Thanks

It's not reliable for other drivers but has been reliable for virtio.
I worry some software relied on this.
You are making good points though ... could we get some
maintainer's feedback on this?

> >
> > > >
> > > >
> > > > > > --
> > > > > > MST
> > > > > >
> > > >
> >


