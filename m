Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 936085951C3
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 07:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbiHPFPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 01:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiHPFO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 01:14:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 09051F14EB
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 14:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660599134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C5E1PnMcfUBlqR4DgvXh0RULdXNDlbBNqvxltGmBpAA=;
        b=Gtnln9nt/OM9QnZNFV/bYdho60PB040Yn39qwfAfqJZbTvZBg3c7gIZdOfHxdzWM7+mnC5
        2mC5NoW34+7PLDvzQWXQqq5XDJPJ7Y5v7Pz0uO/6s9ipvb/tDdIZ7et7tMENYxJ92V6oa0
        7uRxsJ/AUjlFI+PNInkn+7QEG26yCJA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-44-btWZSPidNP-RCaGWVz83Yg-1; Mon, 15 Aug 2022 17:32:13 -0400
X-MC-Unique: btWZSPidNP-RCaGWVz83Yg-1
Received: by mail-wm1-f71.google.com with SMTP id r4-20020a1c4404000000b003a5fa79008bso280250wma.5
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 14:32:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=C5E1PnMcfUBlqR4DgvXh0RULdXNDlbBNqvxltGmBpAA=;
        b=Nm2ysX4rsnUHqE6lul2rq8yyKOiR46GqSrLU6ombdjT46MKmPL29T8ZM6KJrV8R7/T
         A+Gm0CwmOUKsunbA4OD7v25HHKP1B3hEGrQw+7/LOtJ1eeahPCrOkN5qrHcT874Ylm9e
         BNiOj2+RqaauIP9v1IlLyHKRYNmoDzRxXkwQzidkktAWX6yw63aIsExAVOUaBn0IW+1f
         1OZ5dUP7iv5WRkzXo2Ys2Iw8z4v/BtiUVzdEIkR0OqLCtSyvLFw7BT22NwiMQXVo5Okx
         EVMsnuj0pZsh5Pe0WjXHtl7UvBgEVg09muqW1Ej4REIlod1SoR8tyDxEXQtJ2OI8Vp5a
         OUdg==
X-Gm-Message-State: ACgBeo3XABtnjPUHjT1nNggPuDPrM0yXtSEeCJyYDo/btevr991lZuBq
        66LU3vWQq8AnP6ko6Y7rHWpAiztH2oak5COd7Hy4i+OiiSyDtNS08oLvXYb67a90usCmxP1MtDy
        uLL9s8KEl3q4l/2sH
X-Received: by 2002:a7b:cb0e:0:b0:3a5:afff:d520 with SMTP id u14-20020a7bcb0e000000b003a5afffd520mr16640116wmj.3.1660599131761;
        Mon, 15 Aug 2022 14:32:11 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5my+YWP5JS5ii6nnYx6L/bxpBqCs3VguhrRqaU9wVo6Wtqyap4pIk+XVs3eMaM58GGNIiRvA==
X-Received: by 2002:a7b:cb0e:0:b0:3a5:afff:d520 with SMTP id u14-20020a7bcb0e000000b003a5afffd520mr16640100wmj.3.1660599131522;
        Mon, 15 Aug 2022 14:32:11 -0700 (PDT)
Received: from redhat.com ([2.55.4.37])
        by smtp.gmail.com with ESMTPSA id q13-20020a056000136d00b00224f5bfa890sm7444926wrz.97.2022.08.15.14.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 14:32:10 -0700 (PDT)
Date:   Mon, 15 Aug 2022 17:32:06 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Andres Freund <andres@anarazel.de>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        c@redhat.com
Subject: Re: upstream kernel crashes
Message-ID: <20220815170444-mutt-send-email-mst@kernel.org>
References: <20220815034532-mutt-send-email-mst@kernel.org>
 <20220815081527.soikyi365azh5qpu@awork3.anarazel.de>
 <20220815042623-mutt-send-email-mst@kernel.org>
 <FCDC5DDE-3CDD-4B8A-916F-CA7D87B547CE@anarazel.de>
 <20220815113729-mutt-send-email-mst@kernel.org>
 <20220815164503.jsoezxcm6q4u2b6j@awork3.anarazel.de>
 <20220815124748-mutt-send-email-mst@kernel.org>
 <20220815174617.z4chnftzcbv6frqr@awork3.anarazel.de>
 <20220815161423-mutt-send-email-mst@kernel.org>
 <20220815205330.m54g7vcs77r6owd6@awork3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815205330.m54g7vcs77r6owd6@awork3.anarazel.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 01:53:30PM -0700, Andres Freund wrote:
> Hi,
> 
> On 2022-08-15 16:21:51 -0400, Michael S. Tsirkin wrote:
> > On Mon, Aug 15, 2022 at 10:46:17AM -0700, Andres Freund wrote:
> > > Hi,
> > >
> > > On 2022-08-15 12:50:52 -0400, Michael S. Tsirkin wrote:
> > > > On Mon, Aug 15, 2022 at 09:45:03AM -0700, Andres Freund wrote:
> > > > > Hi,
> > > > >
> > > > > On 2022-08-15 11:40:59 -0400, Michael S. Tsirkin wrote:
> > > > > > OK so this gives us a quick revert as a solution for now.
> > > > > > Next, I would appreciate it if you just try this simple hack.
> > > > > > If it crashes we either have a long standing problem in virtio
> > > > > > code or more likely a gcp bug where it can't handle smaller
> > > > > > rings than what device requestes.
> > > > > > Thanks!
> > > > >
> > > > > I applied the below and the problem persists.
> > > > >
> > > > > [...]
> > > >
> > > > Okay!
> > >
> > > Just checking - I applied and tested this atop 6.0-rc1, correct? Or did you
> > > want me to test it with the 762faee5a267 reverted? I guess what you're trying
> > > to test if a smaller queue than what's requested you'd want to do so without
> > > the problematic patch applied...
> > >
> > >
> > > Either way, I did this, and there are no issues that I could observe. No
> > > oopses, no broken networking. But:
> > >
> > > To make sure it does something I added a debugging printk - which doesn't show
> > > up. I assume this is at a point at least earlyprintk should work (which I see
> > > getting enabled via serial)?
> > >
> 
> > Sorry if I was unclear.  I wanted to know whether the change somehow
> > exposes a driver bug or a GCP bug. So what I wanted to do is to test
> > this patch on top of *5.19*, not on top of the revert.
> 
> Right, the 5.19 part was clear, just the earlier test:
> 
> > > > > On 2022-08-15 11:40:59 -0400, Michael S. Tsirkin wrote:
> > > > > > OK so this gives us a quick revert as a solution for now.
> > > > > > Next, I would appreciate it if you just try this simple hack.
> > > > > > If it crashes we either have a long standing problem in virtio
> > > > > > code or more likely a gcp bug where it can't handle smaller
> > > > > > Thanks!
> 
> I wasn't sure about.
> 
> After I didn't see any effect on 5.19 + your patch, I grew a bit suspicious
> and added the printks.
> 
> 
> > Yes I think printk should work here.
> 
> The reason the debug patch didn't change anything, and that my debug printk
> didn't show, is that gcp uses the legacy paths...

Wait a second. Eureka I think!

So I think GCP is not broken.
I think what's broken is this patch:

commit cdb44806fca2d0ad29ca644cbf1505433902ee0c
Author: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Date:   Mon Aug 1 14:38:54 2022 +0800

    virtio_pci: support the arg sizes of find_vqs()


Specifically:

diff --git a/drivers/virtio/virtio_pci_legacy.c b/drivers/virtio/virtio_pci_legacy.c
index 2257f1b3d8ae..d75e5c4e637f 100644
--- a/drivers/virtio/virtio_pci_legacy.c
+++ b/drivers/virtio/virtio_pci_legacy.c
@@ -112,6 +112,7 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
                                  unsigned int index,
                                  void (*callback)(struct virtqueue *vq),
                                  const char *name,
+                                 u32 size,
                                  bool ctx,
                                  u16 msix_vec)
 {
@@ -125,10 +126,13 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
        if (!num || vp_legacy_get_queue_enable(&vp_dev->ldev, index))
                return ERR_PTR(-ENOENT);
 
+       if (!size || size > num)
+               size = num;
+
        info->msix_vector = msix_vec;
 
        /* create the vring */
-       vq = vring_create_virtqueue(index, num,
+       vq = vring_create_virtqueue(index, size,
                                    VIRTIO_PCI_VRING_ALIGN, &vp_dev->vdev,
                                    true, false, ctx,
                                    vp_notify, callback, name);

   

So if you pass the size parameter for a legacy device it will
try to make the ring smaller and that is not legal with
legacy at all. But the driver treats legacy and modern
the same, it allocates a smaller queue anyway.


Lo and behold, I pass disable-modern=on to qemu and it happily
corrupts memory exactly the same as GCP does.


So the new find_vqs API is actually completely broken, it can not work for
legacy at all and for added fun there's no way to find out
that it's legacy. Maybe we should interpret the patch

So I think I will also revert

04ca0b0b16f11faf74fa92468dab51b8372586cd..fe3dc04e31aa51f91dc7f741a5f76cc4817eb5b4







> If there were a bug in the legacy path, it'd explain why the problem only
> shows on gcp, and not in other situations.
> 
> I'll queue testing the legacy path with the equivalent change.
> 
> - Andres
> 
> 
> Greetings,
> 
> Andres Freund

