Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E893B55DC16
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbiF0ISN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 04:18:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232691AbiF0ISK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 04:18:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 139A9E06
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 01:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656317889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OPtn4J82OzWsDsVXNRibX7f2Ro4efWlqotHQQJeFEvk=;
        b=OfaTW7zqZGJVLiGVvhZmsAA7vdqJF2sdIDe3O3cwM01zjO5nZR/NTA49aniG/Z3rF3k+Zd
        79bisdV/cfKhx/EYFd47r5PDJ14Tsgatriira9cB6FN772PwkJ951Z9MWxhIfIeD44Rxgp
        fSRV4qHKMHR51s2wbKhcjUX99uPYdlo=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-Jg5ecPl6N0KNXJZITQ0NaA-1; Mon, 27 Jun 2022 04:18:08 -0400
X-MC-Unique: Jg5ecPl6N0KNXJZITQ0NaA-1
Received: by mail-lf1-f69.google.com with SMTP id cf10-20020a056512280a00b0047f5a295656so4353352lfb.15
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 01:18:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OPtn4J82OzWsDsVXNRibX7f2Ro4efWlqotHQQJeFEvk=;
        b=WAqf1aKKmeY/f4PzPKg8v9iv+ckclTwALDgXe+rkm7VGr/n8cmDtTDn1DZy16sENOQ
         Rjgk3+rJACpOdVDTqgatTKxuEXM6UsqU+Exjfm3DB+Je3BeTQcfugFvzgy5K7wGb9uxw
         bvCBDowxTYrmeAI+ZR4EXjTa8HxvUHLECvL8ihi+cPSGbG0ofIvLR9G3fXiDRb3hnhGw
         cFOuDyyJSbPHNcRHgmwberEeq/Bm9VGLFHRl/pZB/g0Tl5zud7vozz6seWve0jgcnLgH
         wLRCEvLa2sjAWYZFlEsZlRxuhWoFxu5rGKRi3DhiJYUKkKcIAf5M2mclwE0YHlx8Ppuu
         M08w==
X-Gm-Message-State: AJIora8bKkA5MOCUDfP9N5IkI6xvZaV+9iZ3hfiwcNL/9DQow37kVnU1
        jjEcrc8i6ENA61rsDEmtO0jlm2HHqMbEwA8LC6eZNX6JKQiBYFsdHIHqJ9p2jG8g2E1I2mz7hQo
        0BwuJsdduWQEIGErCpheN5TTZlfFfgA2z
X-Received: by 2002:ac2:51a5:0:b0:47f:79a1:5c02 with SMTP id f5-20020ac251a5000000b0047f79a15c02mr7378510lfk.575.1656317885573;
        Mon, 27 Jun 2022 01:18:05 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ud5rlcp28+Fmhb5gpV7n5UDaClclIIoV1luhzWBK2LZrI8iuHqy4DEqfW17VF71T1X3oIofm19Bk+5PrzQAPI=
X-Received: by 2002:ac2:51a5:0:b0:47f:79a1:5c02 with SMTP id
 f5-20020ac251a5000000b0047f79a15c02mr7378505lfk.575.1656317885391; Mon, 27
 Jun 2022 01:18:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220627063656.52397-1-jasowang@redhat.com> <20220627033422-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220627033422-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 27 Jun 2022 16:17:54 +0800
Message-ID: <CACGkMEvhk1UmcMNhYFb8dceoLnNs5Jr4WmKaQ++ZVgR2sOu1QQ@mail.gmail.com>
Subject: Re: [PATCH net] virtio-net: fix race between ndo_open() and virtio_device_ready()
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 3:44 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Jun 27, 2022 at 02:36:56PM +0800, Jason Wang wrote:
> > We used to call virtio_device_ready() after netdev registration.
>
> s/used to call/currently call/
>
> > This
> > cause
>
> s/This cause/Since ndo_open can be called immediately
> after register_netdev, this means there exists/
>
> > a race between ndo_open() and virtio_device_ready(): if
> > ndo_open() is called before virtio_device_ready(), the driver may
> > start to use the device before DRIVER_OK which violates the spec.
> >
> > Fixing
>
> s/Fixing/Fix/
>
> > this by switching to use register_netdevice() and protect the
> > virtio_device_ready() with rtnl_lock() to make sure ndo_open() can
> > only be called after virtio_device_ready().
> >
> > Fixes: 4baf1e33d0842 ("virtio_net: enable VQs early")
>
> it's an unusual use of Fixes - the patch in question does not
> introduce the problem, it just does not fix it completely.

Yes, but I couldn't find a better commit.

> But OK I guess.
>
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
>
> With commit log changes:

Will post a new version with the above fixed.

Thanks

>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>
> > ---
> >  drivers/net/virtio_net.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > index db05b5e930be..8a5810bcb839 100644
> > --- a/drivers/net/virtio_net.c
> > +++ b/drivers/net/virtio_net.c
> > @@ -3655,14 +3655,20 @@ static int virtnet_probe(struct virtio_device *vdev)
> >       if (vi->has_rss || vi->has_rss_hash_report)
> >               virtnet_init_default_rss(vi);
> >
> > -     err = register_netdev(dev);
> > +     /* serialize netdev register + virtio_device_ready() with ndo_open() */
> > +     rtnl_lock();
> > +
> > +     err = register_netdevice(dev);
> >       if (err) {
> >               pr_debug("virtio_net: registering device failed\n");
> > +             rtnl_unlock();
> >               goto free_failover;
> >       }
> >
> >       virtio_device_ready(vdev);
> >
> > +     rtnl_unlock();
> > +
> >       err = virtnet_cpu_notif_add(vi);
> >       if (err) {
> >               pr_debug("virtio_net: registering cpu notifier failed\n");
> > --
> > 2.25.1
>

