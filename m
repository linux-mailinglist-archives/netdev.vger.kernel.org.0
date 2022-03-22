Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6874E403B
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 15:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235254AbiCVOKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 10:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234896AbiCVOKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 10:10:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A848B5E162
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 07:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647958153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XjrS+i8ux47oEqISC/xAzvVvrtglGui4NIu7mtB3Zfk=;
        b=AqPi9CNZBv5kRuv9CF1IpiawuTSnqh9klHuGpjNDZgnQDshLusi/oqtDHfTW9YQ9p6IbWT
        VR0BNfenS67ObCPmXH+JgoOXdxaUtL5xWGxlgbREjWI9qxvLpEa9buOfxEoBOqbf4b5t3L
        Kw7rzTcRu4VMayBR9UjnBkxrF/3J8UQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-tndAKuHbP2CGAuSru0TRuA-1; Tue, 22 Mar 2022 10:09:12 -0400
X-MC-Unique: tndAKuHbP2CGAuSru0TRuA-1
Received: by mail-wm1-f69.google.com with SMTP id i6-20020a05600c354600b0038be262d9d9so1352779wmq.8
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 07:09:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XjrS+i8ux47oEqISC/xAzvVvrtglGui4NIu7mtB3Zfk=;
        b=z/1zgvvPGdRW0z6osuShe5YGnX2W0TzTjAh0hW5qy5+kDc/4gIROQVXpXj1aOoO/Hm
         p4iwL4F4e/7acL3xsSqCtQAzqqlDIX+UxbIsF1by/zX3WVs/ufId8lnkAFcb1F/azifE
         R/mL+cxz8NkpWqlUnCvlP+wp/QM/SDFT6wkue57uLEuSkjnGM8S376YEZzcvh/fK+V9i
         I9laMVeJ5cszFwLPKvfTq2h/rIdi3b1egy7it2d+fUV7SEmbABemfaxnl0y8l9Q06Fu2
         DJDALn+6gvTud+uvIBqaRvMGY1KrN6DUggk73c1n8ZljB2Y6I3O3hXmhHe+tMoTyKvxs
         XYyA==
X-Gm-Message-State: AOAM532xeZcsCS+6OBp7v3H7u0SZIylbk2mcUxE/Prh3Z5fyzJpjsq7C
        y0En64m9sjYPuehVgnP1+JS3n5RxR4s7Ir8zKb+/IVuZNvCdRwZuA6sc560EdyrdPBjmpsmpI34
        rgdi1w1ACW/F3EYrD
X-Received: by 2002:a05:6000:1ace:b0:203:d45b:fbce with SMTP id i14-20020a0560001ace00b00203d45bfbcemr21853205wry.673.1647958151070;
        Tue, 22 Mar 2022 07:09:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwthJ2YR6qum+rIdVwv5c7F+YfWcOGMnm3G5bxJSaXDIMo7k9XlQ8+7FNG7SNMTkGwYmHNl7g==
X-Received: by 2002:a05:6000:1ace:b0:203:d45b:fbce with SMTP id i14-20020a0560001ace00b00203d45bfbcemr21853185wry.673.1647958150834;
        Tue, 22 Mar 2022 07:09:10 -0700 (PDT)
Received: from redhat.com ([2.55.132.0])
        by smtp.gmail.com with ESMTPSA id 6-20020a05600c020600b0038cbb21fb00sm1106899wmi.39.2022.03.22.07.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 07:09:10 -0700 (PDT)
Date:   Tue, 22 Mar 2022 10:09:06 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] vsock/virtio: enable VQs early on probe
Message-ID: <20220322100835-mutt-send-email-mst@kernel.org>
References: <20220322103823.83411-1-sgarzare@redhat.com>
 <20220322092723-mutt-send-email-mst@kernel.org>
 <20220322140500.bn5yrqj5ljckhcdb@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322140500.bn5yrqj5ljckhcdb@sgarzare-redhat>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 03:05:00PM +0100, Stefano Garzarella wrote:
> On Tue, Mar 22, 2022 at 09:36:14AM -0400, Michael S. Tsirkin wrote:
> > On Tue, Mar 22, 2022 at 11:38:23AM +0100, Stefano Garzarella wrote:
> > > virtio spec requires drivers to set DRIVER_OK before using VQs.
> > > This is set automatically after probe returns, but virtio-vsock
> > > driver uses VQs in the probe function to fill rx and event VQs
> > > with new buffers.
> > 
> > 
> > So this is a spec violation. absolutely.
> > 
> > > Let's fix this, calling virtio_device_ready() before using VQs
> > > in the probe function.
> > > 
> > > Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > ---
> > >  net/vmw_vsock/virtio_transport.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> > > index 5afc194a58bb..b1962f8cd502 100644
> > > --- a/net/vmw_vsock/virtio_transport.c
> > > +++ b/net/vmw_vsock/virtio_transport.c
> > > @@ -622,6 +622,8 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> > >  	INIT_WORK(&vsock->event_work, virtio_transport_event_work);
> > >  	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
> > > 
> > > +	virtio_device_ready(vdev);
> > > +
> > >  	mutex_lock(&vsock->tx_lock);
> > >  	vsock->tx_run = true;
> > >  	mutex_unlock(&vsock->tx_lock);
> > 
> > Here's the whole code snippet:
> > 
> > 
> >        mutex_lock(&vsock->tx_lock);
> >        vsock->tx_run = true;
> >        mutex_unlock(&vsock->tx_lock);
> > 
> >        mutex_lock(&vsock->rx_lock);
> >        virtio_vsock_rx_fill(vsock);
> >        vsock->rx_run = true;
> >        mutex_unlock(&vsock->rx_lock);
> > 
> >        mutex_lock(&vsock->event_lock);
> >        virtio_vsock_event_fill(vsock);
> >        vsock->event_run = true;
> >        mutex_unlock(&vsock->event_lock);
> > 
> >        if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
> >                vsock->seqpacket_allow = true;
> > 
> >        vdev->priv = vsock;
> >        rcu_assign_pointer(the_virtio_vsock, vsock);
> > 
> >        mutex_unlock(&the_virtio_vsock_mutex);
> > 
> > 
> > I worry that this is not the only problem here:
> > seqpacket_allow and setting of vdev->priv at least after
> > device is active look suspicious.
> 
> Right, so if you agree I'll move these before virtio_device_ready().
> 
> > E.g.:
> > 
> > static void virtio_vsock_event_done(struct virtqueue *vq)
> > {
> >        struct virtio_vsock *vsock = vq->vdev->priv;
> > 
> >        if (!vsock)
> >                return;
> >        queue_work(virtio_vsock_workqueue, &vsock->event_work);
> > }
> > 
> > looks like it will miss events now they will be reported earlier.
> > One might say that since vq has been kicked it might send
> > interrupts earlier too so not a new problem, but
> > there's a chance device actually waits until DRIVER_OK
> > to start operating.
> 
> Yes I see, should I break into 2 patches (one where I move the code already
> present and this one)?
> 
> Maybe a single patch is fine since it's the complete solution.
> 
> Thank you for the detailed explanation,
> Stefano

Two I think since movement can be backported to before the hardening
effort.

-- 
MST

