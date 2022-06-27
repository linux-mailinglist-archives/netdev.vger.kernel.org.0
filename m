Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 311E655D320
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235603AbiF0MIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 08:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240426AbiF0MHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 08:07:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D520D12A
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 05:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656331567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oa0hKhTUeCCnu5O/zbJifpjkPRkzcn5Dvdk3HuT+Faw=;
        b=VlHd09c6wMBCMI/f/fFNRRhJ7ZCtUGx/uqK21XCohzV2xKgTEhD41+GV74ae7Tkap0dTpu
        inawsKoSZnttyWTwbzPi7AC1ipr8LZoUesA9m8a3IFU1Zp+j3jE5vj4pEoh9JuegYdCZH8
        YuwRfkXnP3ET1lA65jGsdW86r3w0wNY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-oN254a0sM36aHz3GtO-voA-1; Mon, 27 Jun 2022 08:06:05 -0400
X-MC-Unique: oN254a0sM36aHz3GtO-voA-1
Received: by mail-wm1-f70.google.com with SMTP id k5-20020a05600c0b4500b003941ca130f9so3499607wmr.0
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 05:06:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oa0hKhTUeCCnu5O/zbJifpjkPRkzcn5Dvdk3HuT+Faw=;
        b=mkipWIqCj/tiJ3aYYx4oTgjT089ox6ZaCuZlfcoO6x2PBNriXNpzTMq8MfFvRJgQd5
         6MKl5kF+lw5xuvi9XcJpLdeEwEC4lVOD/r5jcwIWOFjNkAAHAlJ2uN35utwUqdrA0rg3
         0nUiHfWW3zfhgzyaPkTBW6KbSyq5k+9ryA/XLH6D0T4mB7zDngSYT88NZLzOFYStFjHd
         Cy2k9QEOtEsppz+LX9rec1wfmUUyxv9Vwiid4VbhJGn4W+vGUoaozDLzdiS87UEU7Uxp
         iEHcZAn24YGDQ89M0eE+PhlidqHuo/c/aUFSqVFHltnf8JIj+2JWxusREs80/3kejJKq
         Xodg==
X-Gm-Message-State: AJIora8nf6jwyIvsfQ/tvQcoOK8HAeZGUkCBasv+5JXIcacyP2z3f49P
        kIievlSI4w7z44i70FIPFDt/0T2UcF1EwLEa3d4mYKdAF/Ki4X2h4ISIpZGHzXjBFVt7iGMz0G0
        dMn2g3dJuWSQ9q9S9
X-Received: by 2002:adf:fad2:0:b0:21b:b947:bfa8 with SMTP id a18-20020adffad2000000b0021bb947bfa8mr12316745wrs.73.1656331564548;
        Mon, 27 Jun 2022 05:06:04 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uH4dSe1OM+SF7gXPkS4xVRzc70/2+VEa4uCZyX8h1qerL46FWK8xW87SYP/3wUoSpkIGVe8w==
X-Received: by 2002:adf:fad2:0:b0:21b:b947:bfa8 with SMTP id a18-20020adffad2000000b0021bb947bfa8mr12316730wrs.73.1656331564326;
        Mon, 27 Jun 2022 05:06:04 -0700 (PDT)
Received: from redhat.com ([2.54.45.90])
        by smtp.gmail.com with ESMTPSA id h4-20020a5d4304000000b0021b829d111csm10533390wrq.112.2022.06.27.05.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 05:06:03 -0700 (PDT)
Date:   Mon, 27 Jun 2022 08:05:59 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net V2] virtio-net: fix race between ndo_open() and
 virtio_device_ready()
Message-ID: <20220627080539-mutt-send-email-mst@kernel.org>
References: <20220627083040.53506-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627083040.53506-1-jasowang@redhat.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 04:30:40PM +0800, Jason Wang wrote:
> We currently call virtio_device_ready() after netdev
> registration. Since ndo_open() can be called immediately
> after register_netdev, this means there exists a race between
> ndo_open() and virtio_device_ready(): the driver may start to use the
> device before DRIVER_OK which violates the spec.
> 
> Fix this by switching to use register_netdevice() and protect the
> virtio_device_ready() with rtnl_lock() to make sure ndo_open() can
> only be called after virtio_device_ready().
> 
> Fixes: 4baf1e33d0842 ("virtio_net: enable VQs early")
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

I reworded the caif commit log similarly and put both on my tree.

> ---
>  drivers/net/virtio_net.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index db05b5e930be..8a5810bcb839 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3655,14 +3655,20 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	if (vi->has_rss || vi->has_rss_hash_report)
>  		virtnet_init_default_rss(vi);
>  
> -	err = register_netdev(dev);
> +	/* serialize netdev register + virtio_device_ready() with ndo_open() */
> +	rtnl_lock();
> +
> +	err = register_netdevice(dev);
>  	if (err) {
>  		pr_debug("virtio_net: registering device failed\n");
> +		rtnl_unlock();
>  		goto free_failover;
>  	}
>  
>  	virtio_device_ready(vdev);
>  
> +	rtnl_unlock();
> +
>  	err = virtnet_cpu_notif_add(vi);
>  	if (err) {
>  		pr_debug("virtio_net: registering cpu notifier failed\n");
> -- 
> 2.25.1

