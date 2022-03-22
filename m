Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC114E4179
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 15:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237887AbiCVOiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 10:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237880AbiCVOiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 10:38:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 19B137E5A7
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 07:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647959800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dOj1GKJWSWVxdAPCqvgvT1u26bVfFeq3QZ8vKHNzDPY=;
        b=JLW51DjHlne2/HpaYrwy/g838nJtgFPimIYHSeN2Mo8eaEQuHtsVQZP+qQMmTiXByqsxt/
        1Y8W47iwqPVDdHxtpQbxTW5cnJ+CJ1nISGQMvKIlDVmdV1mrTQobPfSPp2C6k1xauEBHYL
        8QdBSF/qJ6tpBBfXu33n/oU/DxsEryg=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-339-gsT0fgd_PFWZ1O6uZopKaQ-1; Tue, 22 Mar 2022 10:36:39 -0400
X-MC-Unique: gsT0fgd_PFWZ1O6uZopKaQ-1
Received: by mail-qt1-f199.google.com with SMTP id k1-20020ac85fc1000000b002e1c5930386so11694660qta.3
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 07:36:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dOj1GKJWSWVxdAPCqvgvT1u26bVfFeq3QZ8vKHNzDPY=;
        b=XCLzStaIIntIVfXS9qBa3+w4rkjNAhzNv1yfwoOxbHlpm0e+DJFfoOOw9LaLKtvMKC
         Dfb15+wTcQPjFdn1pn1aJAiW/AwoB1TQzVA/QPvxBrNAhW7lGrN5Oci830wH+TVGnF9Q
         rQrNsvFjsPYm3ws/HADzhfjeIGjgGc+mzfFBH/uotlQ9AWa7PCB0r3zJ6TU6uaizrgUE
         66GiXHF5VdW5BGkqilIXswFFrpzxjF/R4gq5DZy7qQaPXzbGmgMJGLMg0RB/E4VH0jeI
         NaMPJj2oTQu69JKE6X6dXave//tw40HYNZ0sC6My29Pq9qA7GAzGw/AfOFM1MLRt54Wf
         xyqg==
X-Gm-Message-State: AOAM532bhD5R+1MvwNVP3mBXAZ8/0vy+1s6uyvfG/oK4nzx//xK9xdqT
        KXoJX75Ih1ODja7f9lHG2a80CWps7JMkqQHWLqafVPnMltw9NvmwywczGnSDWM+Rj0jlSOy7p4W
        IZkUnRRBRSKoZcc5k
X-Received: by 2002:a05:620a:28d2:b0:67e:c956:7ca8 with SMTP id l18-20020a05620a28d200b0067ec9567ca8mr471782qkp.683.1647959798182;
        Tue, 22 Mar 2022 07:36:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXDv4AGOYhcpwZ3iXOsgSE7vB8MlD/bpaFwtt1h5AIpAisGg+eAfZ6KhHHNlDh4AUml/kF1w==
X-Received: by 2002:a05:620a:28d2:b0:67e:c956:7ca8 with SMTP id l18-20020a05620a28d200b0067ec9567ca8mr471763qkp.683.1647959797928;
        Tue, 22 Mar 2022 07:36:37 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-114.business.telecomitalia.it. [87.12.25.114])
        by smtp.gmail.com with ESMTPSA id h27-20020a05620a13fb00b0067b3615e4acsm8944129qkl.70.2022.03.22.07.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 07:36:37 -0700 (PDT)
Date:   Tue, 22 Mar 2022 15:36:31 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] vsock/virtio: enable VQs early on probe
Message-ID: <20220322143631.gt32cshbwyetq2fh@sgarzare-redhat>
References: <20220322103823.83411-1-sgarzare@redhat.com>
 <20220322092723-mutt-send-email-mst@kernel.org>
 <20220322140500.bn5yrqj5ljckhcdb@sgarzare-redhat>
 <20220322100835-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220322100835-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 10:09:06AM -0400, Michael S. Tsirkin wrote:
>On Tue, Mar 22, 2022 at 03:05:00PM +0100, Stefano Garzarella wrote:
>> On Tue, Mar 22, 2022 at 09:36:14AM -0400, Michael S. Tsirkin wrote:
>> > On Tue, Mar 22, 2022 at 11:38:23AM +0100, Stefano Garzarella wrote:
>> > > virtio spec requires drivers to set DRIVER_OK before using VQs.
>> > > This is set automatically after probe returns, but virtio-vsock
>> > > driver uses VQs in the probe function to fill rx and event VQs
>> > > with new buffers.
>> >
>> >
>> > So this is a spec violation. absolutely.
>> >
>> > > Let's fix this, calling virtio_device_ready() before using VQs
>> > > in the probe function.
>> > >
>> > > Fixes: 0ea9e1d3a9e3 ("VSOCK: Introduce virtio_transport.ko")
>> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> > > ---
>> > >  net/vmw_vsock/virtio_transport.c | 2 ++
>> > >  1 file changed, 2 insertions(+)
>> > >
>> > > diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>> > > index 5afc194a58bb..b1962f8cd502 100644
>> > > --- a/net/vmw_vsock/virtio_transport.c
>> > > +++ b/net/vmw_vsock/virtio_transport.c
>> > > @@ -622,6 +622,8 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>> > >  	INIT_WORK(&vsock->event_work, virtio_transport_event_work);
>> > >  	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
>> > >
>> > > +	virtio_device_ready(vdev);
>> > > +
>> > >  	mutex_lock(&vsock->tx_lock);
>> > >  	vsock->tx_run = true;
>> > >  	mutex_unlock(&vsock->tx_lock);
>> >
>> > Here's the whole code snippet:
>> >
>> >
>> >        mutex_lock(&vsock->tx_lock);
>> >        vsock->tx_run = true;
>> >        mutex_unlock(&vsock->tx_lock);
>> >
>> >        mutex_lock(&vsock->rx_lock);
>> >        virtio_vsock_rx_fill(vsock);
>> >        vsock->rx_run = true;
>> >        mutex_unlock(&vsock->rx_lock);
>> >
>> >        mutex_lock(&vsock->event_lock);
>> >        virtio_vsock_event_fill(vsock);
>> >        vsock->event_run = true;
>> >        mutex_unlock(&vsock->event_lock);
>> >
>> >        if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_SEQPACKET))
>> >                vsock->seqpacket_allow = true;
>> >
>> >        vdev->priv = vsock;
>> >        rcu_assign_pointer(the_virtio_vsock, vsock);
>> >
>> >        mutex_unlock(&the_virtio_vsock_mutex);
>> >
>> >
>> > I worry that this is not the only problem here:
>> > seqpacket_allow and setting of vdev->priv at least after
>> > device is active look suspicious.
>>
>> Right, so if you agree I'll move these before virtio_device_ready().
>>
>> > E.g.:
>> >
>> > static void virtio_vsock_event_done(struct virtqueue *vq)
>> > {
>> >        struct virtio_vsock *vsock = vq->vdev->priv;
>> >
>> >        if (!vsock)
>> >                return;
>> >        queue_work(virtio_vsock_workqueue, &vsock->event_work);
>> > }
>> >
>> > looks like it will miss events now they will be reported earlier.
>> > One might say that since vq has been kicked it might send
>> > interrupts earlier too so not a new problem, but
>> > there's a chance device actually waits until DRIVER_OK
>> > to start operating.
>>
>> Yes I see, should I break into 2 patches (one where I move the code already
>> present and this one)?
>>
>> Maybe a single patch is fine since it's the complete solution.
>>
>> Thank you for the detailed explanation,
>> Stefano
>
>Two I think since movement can be backported to before the hardening
>effort.

Yep, maybe 3 since seqpacket was added later.

Thanks,
Stefano

