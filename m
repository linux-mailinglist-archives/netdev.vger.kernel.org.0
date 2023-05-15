Return-Path: <netdev+bounces-2599-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BA36702A5D
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:18:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B1E01C20A5B
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 10:18:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F474C2DF;
	Mon, 15 May 2023 10:18:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB5FAD59
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 10:18:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3AD1FC2
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 03:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684145844;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2F2MmPR6uvyF/S479nyiadAjTsmEszXcVeYTAPUBtGg=;
	b=FdCFokLSQ1dDUF4N25utK8JZfk6NQDOYwp+uH2jrHl9GLEkTtTiLFXQoDEGzP428Z/iba4
	AJ56nEpwfRUnaROQ1MQCvJdOY1vt4F5LILVaGszdx6kx8eVKjO/PJa5BwYRsfiQt+FbWkJ
	3B37ke2f/EbL6VETvyJaigUm4SJbWQM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-HK-Mxq88MP6-WjCvo8R_QQ-1; Mon, 15 May 2023 06:17:23 -0400
X-MC-Unique: HK-Mxq88MP6-WjCvo8R_QQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f509037a45so18865915e9.1
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 03:17:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684145842; x=1686737842;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2F2MmPR6uvyF/S479nyiadAjTsmEszXcVeYTAPUBtGg=;
        b=DOVSMF8dYXxg7jjozuxa2mD3YcfJ62TBvPpssJSZGUcL+8b4jJk7AJklfwLsrGAlS+
         56LqE/BQMaubJKlx/jDKnL9IySSwc2d0AdylbJX3Uk0K4V+Hej3j/7SG6LMp4EYXGSn2
         UiipaEivJDO/ASezmBES8yISkLp5pduHITsRIi6tQEM7IR3mMPc4CYrEc6W7190qZXt9
         viySe6DrZHAJlLdpMfRZ+hnpRVmgzdBqfP6+DKl41NzxDtC21gTUcEv/rMxuRvlVpp1s
         7lzvdW9ik1ycFryHsrSLN6n2VFVuUILTSfZdLps5UaL0vEHQnQbHTJ9WBgV91R+ApI7M
         H3Lw==
X-Gm-Message-State: AC+VfDzrD0MMuxxTQByP0xQwFdCO2IQ5I4ENBJ/aqhH6Z5XG22+m21hJ
	RVW1TKDhfc5R1leiIykJK4lnOcv2QIfZ0I0P5F5e6ejvYOEFShD+j5flne7IN22PJUlFUrPzn5W
	o98FU2m15lFEqnvfH
X-Received: by 2002:a7b:cd8c:0:b0:3f4:2775:b45c with SMTP id y12-20020a7bcd8c000000b003f42775b45cmr16135072wmj.3.1684145842253;
        Mon, 15 May 2023 03:17:22 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5cjHf8wpirqMKODDcwtxNOIU7NCNEa+K+k2xQTKz5Pl8QX6uaHXd7dJ3fMMgRsMfUs2i6A+g==
X-Received: by 2002:a7b:cd8c:0:b0:3f4:2775:b45c with SMTP id y12-20020a7bcd8c000000b003f42775b45cmr16135056wmj.3.1684145841868;
        Mon, 15 May 2023 03:17:21 -0700 (PDT)
Received: from redhat.com ([2.52.26.5])
        by smtp.gmail.com with ESMTPSA id a6-20020a1cf006000000b003f0aefcc457sm36542703wmb.45.2023.05.15.03.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 03:17:21 -0700 (PDT)
Date: Mon, 15 May 2023 06:17:17 -0400
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
Message-ID: <20230515061455-mutt-send-email-mst@kernel.org>
References: <20230413064027.13267-1-jasowang@redhat.com>
 <20230413064027.13267-2-jasowang@redhat.com>
 <20230413121525-mutt-send-email-mst@kernel.org>
 <CACGkMEunn1Z3n8yjVaWLqdV502yjaCBSAb_LO4KsB0nuxXmV8A@mail.gmail.com>
 <20230414031947-mutt-send-email-mst@kernel.org>
 <CACGkMEtutGn0CoJhoPHbzPuqoCLb4OCT6a_vB_WPV=MhwY0DXg@mail.gmail.com>
 <20230510012951-mutt-send-email-mst@kernel.org>
 <CACGkMEszPydzw_MOUOVJKBBW_8iYn66i_9OFvLDoZMH34hMx=w@mail.gmail.com>
 <20230515004422-mutt-send-email-mst@kernel.org>
 <CACGkMEv+Q2UoBarNOzKSrc3O=Wb2_73O2j9cZXFdAiLBm1qY-Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEv+Q2UoBarNOzKSrc3O=Wb2_73O2j9cZXFdAiLBm1qY-Q@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 01:13:33PM +0800, Jason Wang wrote:
> On Mon, May 15, 2023 at 12:45 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, May 15, 2023 at 09:05:54AM +0800, Jason Wang wrote:
> > > On Wed, May 10, 2023 at 1:33 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Mon, Apr 17, 2023 at 11:40:58AM +0800, Jason Wang wrote:
> > > > > On Fri, Apr 14, 2023 at 3:21 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Fri, Apr 14, 2023 at 01:04:15PM +0800, Jason Wang wrote:
> > > > > > > Forget to cc netdev, adding.
> > > > > > >
> > > > > > > On Fri, Apr 14, 2023 at 12:25 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Thu, Apr 13, 2023 at 02:40:26PM +0800, Jason Wang wrote:
> > > > > > > > > This patch convert rx mode setting to be done in a workqueue, this is
> > > > > > > > > a must for allow to sleep when waiting for the cvq command to
> > > > > > > > > response since current code is executed under addr spin lock.
> > > > > > > > >
> > > > > > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > > > > > >
> > > > > > > > I don't like this frankly. This means that setting RX mode which would
> > > > > > > > previously be reliable, now becomes unreliable.
> > > > > > >
> > > > > > > It is "unreliable" by design:
> > > > > > >
> > > > > > >       void                    (*ndo_set_rx_mode)(struct net_device *dev);
> > > > > > >
> > > > > > > > - first of all configuration is no longer immediate
> > > > > > >
> > > > > > > Is immediate a hard requirement? I can see a workqueue is used at least:
> > > > > > >
> > > > > > > mlx5e, ipoib, efx, ...
> > > > > > >
> > > > > > > >   and there is no way for driver to find out when
> > > > > > > >   it actually took effect
> > > > > > >
> > > > > > > But we know rx mode is best effort e.g it doesn't support vhost and we
> > > > > > > survive from this for years.
> > > > > > >
> > > > > > > > - second, if device fails command, this is also not
> > > > > > > >   propagated to driver, again no way for driver to find out
> > > > > > > >
> > > > > > > > VDUSE needs to be fixed to do tricks to fix this
> > > > > > > > without breaking normal drivers.
> > > > > > >
> > > > > > > It's not specific to VDUSE. For example, when using virtio-net in the
> > > > > > > UP environment with any software cvq (like mlx5 via vDPA or cma
> > > > > > > transport).
> > > > > > >
> > > > > > > Thanks
> > > > > >
> > > > > > Hmm. Can we differentiate between these use-cases?
> > > > >
> > > > > It doesn't look easy since we are drivers for virtio bus. Underlayer
> > > > > details were hidden from virtio-net.
> > > > >
> > > > > Or do you have any ideas on this?
> > > > >
> > > > > Thanks
> > > >
> > > > I don't know, pass some kind of flag in struct virtqueue?
> > > >         "bool slow; /* This vq can be very slow sometimes. Don't wait for it! */"
> > > >
> > > > ?
> > > >
> > >
> > > So if it's slow, sleep, otherwise poll?
> > >
> > > I feel setting this flag might be tricky, since the driver doesn't
> > > know whether or not it's really slow. E.g smartNIC vendor may allow
> > > virtio-net emulation over PCI.
> > >
> > > Thanks
> >
> > driver will have the choice, depending on whether
> > vq is deterministic or not.
> 
> Ok, but the problem is, such booleans are only useful for virtio ring
> codes. But in this case, virtio-net knows what to do for cvq. So I'm
> not sure who the user is.
> 
> Thanks

Circling back, what exactly does the architecture you are trying
to fix look like? Who is going to introduce unbounded latency?
The hypervisor? If so do we not maybe want a new feature bit
that documents this? Hypervisor then can detect old guests
that spin and decide what to do, e.g. prioritise cvq more,
or fail FEATURES_OK.

> >
> >
> > > > --
> > > > MST
> > > >
> >


