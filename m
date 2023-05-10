Return-Path: <netdev+bounces-1330-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD0D46FD638
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 07:33:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C5D928135C
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 05:33:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BFCA4422;
	Wed, 10 May 2023 05:33:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278E565A
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 05:33:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221142685
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 22:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683696782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CfR3pdTnrmVcxjx1/XCpuBAbDSlJT7L6QiQpFvOxED0=;
	b=BSx6gP9MiDLr9IJcrQvxP7BF3YI4CsJveJSJpa2ybBHspYUUCXUmD7kDjg0nr7U8G48NRN
	EVxdZAmcEIZBeuCSq9pXlYXuGtdDTuxj8E8A56v/C6nWpyivQXQ0wPiQxB3x594zZnoAcl
	8p3GAyE6+4zIYMusqy0nkefkpwfRLRI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-GR5Jcm5YMmSp6vpueyyl5w-1; Wed, 10 May 2023 01:33:01 -0400
X-MC-Unique: GR5Jcm5YMmSp6vpueyyl5w-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-50bc6c6b9dbso10736380a12.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 22:33:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683696780; x=1686288780;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CfR3pdTnrmVcxjx1/XCpuBAbDSlJT7L6QiQpFvOxED0=;
        b=fSWaAjRW3vKRKBP9NPV5GX6wH9SDqGDDLsmIMejjs6hzHFMOCz7CPWdmAj9wRJxYGn
         RHI3J8cp1BYR8bWNvIjC/IkSTmnl6Y37TxKzuG2ctDci20OjKP7oXlhjL/TSR4N74uG4
         MT0awynRf8kvfy4JibOzY7amACVXHdEux9D1e0eMAfN+6isuv7YRgrUHeT46HjS5RN1y
         nEnfDUeoWVl/pujgmNBlUkdRHAmQlfv9Gb9Ee9Bke/Jx+mi5pngRtjKYDMn81q4z5qFj
         5Nu4VIYXfQsSFUjkb8wfTA3Cls05PtkmNsCFpesVby1IxoMobRmnLANruoJHwe1XnIEh
         0Ilw==
X-Gm-Message-State: AC+VfDysOytp+G/kE4djnP6jHnnPJcCBDZq5wpzicmXdP/iNddmZR9o4
	UXTn0fj+LPtHjj4HDRSkUd2w6F6gjX//HoeAXyW+8aH7ARcki+y3+vNV1PEodrQdBGp5krWUlJG
	qBzqlc0iOtiGOLNoB
X-Received: by 2002:a05:6402:3587:b0:50c:1603:654 with SMTP id y7-20020a056402358700b0050c16030654mr14748678edc.16.1683696779949;
        Tue, 09 May 2023 22:32:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6V4Bg09XaNc7Uq/10va+cr/YvgkAVnRjG5KK8NmISXyPQ+XKlfBDvcGuJ6+QR7dyAWLxXywg==
X-Received: by 2002:a05:6402:3587:b0:50c:1603:654 with SMTP id y7-20020a056402358700b0050c16030654mr14748657edc.16.1683696779652;
        Tue, 09 May 2023 22:32:59 -0700 (PDT)
Received: from redhat.com ([176.119.195.36])
        by smtp.gmail.com with ESMTPSA id sa40-20020a1709076d2800b00965d4b2bd4csm2230865ejc.141.2023.05.09.22.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 22:32:58 -0700 (PDT)
Date: Wed, 10 May 2023 01:32:53 -0400
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
Message-ID: <20230510012951-mutt-send-email-mst@kernel.org>
References: <20230413064027.13267-1-jasowang@redhat.com>
 <20230413064027.13267-2-jasowang@redhat.com>
 <20230413121525-mutt-send-email-mst@kernel.org>
 <CACGkMEunn1Z3n8yjVaWLqdV502yjaCBSAb_LO4KsB0nuxXmV8A@mail.gmail.com>
 <20230414031947-mutt-send-email-mst@kernel.org>
 <CACGkMEtutGn0CoJhoPHbzPuqoCLb4OCT6a_vB_WPV=MhwY0DXg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEtutGn0CoJhoPHbzPuqoCLb4OCT6a_vB_WPV=MhwY0DXg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Apr 17, 2023 at 11:40:58AM +0800, Jason Wang wrote:
> On Fri, Apr 14, 2023 at 3:21 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Fri, Apr 14, 2023 at 01:04:15PM +0800, Jason Wang wrote:
> > > Forget to cc netdev, adding.
> > >
> > > On Fri, Apr 14, 2023 at 12:25 AM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Thu, Apr 13, 2023 at 02:40:26PM +0800, Jason Wang wrote:
> > > > > This patch convert rx mode setting to be done in a workqueue, this is
> > > > > a must for allow to sleep when waiting for the cvq command to
> > > > > response since current code is executed under addr spin lock.
> > > > >
> > > > > Signed-off-by: Jason Wang <jasowang@redhat.com>
> > > >
> > > > I don't like this frankly. This means that setting RX mode which would
> > > > previously be reliable, now becomes unreliable.
> > >
> > > It is "unreliable" by design:
> > >
> > >       void                    (*ndo_set_rx_mode)(struct net_device *dev);
> > >
> > > > - first of all configuration is no longer immediate
> > >
> > > Is immediate a hard requirement? I can see a workqueue is used at least:
> > >
> > > mlx5e, ipoib, efx, ...
> > >
> > > >   and there is no way for driver to find out when
> > > >   it actually took effect
> > >
> > > But we know rx mode is best effort e.g it doesn't support vhost and we
> > > survive from this for years.
> > >
> > > > - second, if device fails command, this is also not
> > > >   propagated to driver, again no way for driver to find out
> > > >
> > > > VDUSE needs to be fixed to do tricks to fix this
> > > > without breaking normal drivers.
> > >
> > > It's not specific to VDUSE. For example, when using virtio-net in the
> > > UP environment with any software cvq (like mlx5 via vDPA or cma
> > > transport).
> > >
> > > Thanks
> >
> > Hmm. Can we differentiate between these use-cases?
> 
> It doesn't look easy since we are drivers for virtio bus. Underlayer
> details were hidden from virtio-net.
> 
> Or do you have any ideas on this?
> 
> Thanks

I don't know, pass some kind of flag in struct virtqueue?
	"bool slow; /* This vq can be very slow sometimes. Don't wait for it! */"

?

-- 
MST


