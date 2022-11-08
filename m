Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83A4D620D37
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbiKHKZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233905AbiKHKZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:25:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7E651B1EC
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 02:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667903065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=V0f6miHyfdXlJNB+m5URvLSjup5N3IeFlLnjD/c/Qow=;
        b=CjaDmi4y38HkQGWPIVIl9Q4tITaVICvfuKjBgoXm2JCrULlWnMzrI3U9DcFPx9xXkMZOJI
        6xeFPEJDYCyMNG05514nSikcDtYEyL54c4LT9a/oEXQaHoU22iVvw1xqQ49bYWj2qfQNMh
        kAMM+OYoWJX02qUzOKn3XnDtFlb3mWs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-496-Vpg8VQdrOQWKcJP8EYOG1w-1; Tue, 08 Nov 2022 05:24:24 -0500
X-MC-Unique: Vpg8VQdrOQWKcJP8EYOG1w-1
Received: by mail-wm1-f71.google.com with SMTP id p14-20020a05600c204e00b003cf4cce4da5so3695643wmg.0
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 02:24:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V0f6miHyfdXlJNB+m5URvLSjup5N3IeFlLnjD/c/Qow=;
        b=TlnrRYJMEtf6Y8fenSREDADy69cAwdikOsGSZhdg7M+K8wPdgahPv4I5guNke8jXsk
         MkuJsqRtb3g58n19SanslzLppcG/Y1hv8iwoLhIimKz4woMqXAkOBaR9MBbZ9u/7LoC5
         QSQ4u8J3uHIA2YeqWTUzXFmWKrl9gefSJZYD9ZVsDk6y6Zkfbz9TfHsTjSF562+7sIgL
         7Mm/QE/vjeMGBtY+60CW0hW7dgHaL2ykzGtqiKI71RqXvy1P4BWxiqmrft9hJpXRZrpk
         DMu/Ll+oK9g1Hpvvbk1TfQOtwXzyZ+dNAiSNHbCVNZ3pTRhPdlgkvX+UnzFIMdR4dsNX
         gdHg==
X-Gm-Message-State: ACrzQf0JeXEWeIVCwBHK+JvUBG9iwCymCs9v73smXr06cmswaGzEAaIj
        9BJgKi4FGBl9ZhybBE2NqNX7vYNsf4wOdcr5s7lG3dboSith2LcP47eUXDS/r37O5i3aY1mgZhl
        P5jZymS9IQ7sGbsVU
X-Received: by 2002:a05:600c:2242:b0:3cf:4ccc:7418 with SMTP id a2-20020a05600c224200b003cf4ccc7418mr45909507wmm.191.1667903063322;
        Tue, 08 Nov 2022 02:24:23 -0800 (PST)
X-Google-Smtp-Source: AMsMyM63jNoqd/VARfO8cpeBbtfv5zYnABJ0tzkSvzQF3g0iN4WYdzewkQNJ5FZQKIEXIt6HCSt8Lw==
X-Received: by 2002:a05:600c:2242:b0:3cf:4ccc:7418 with SMTP id a2-20020a05600c224200b003cf4ccc7418mr45909493wmm.191.1667903063122;
        Tue, 08 Nov 2022 02:24:23 -0800 (PST)
Received: from sgarzare-redhat (host-82-53-134-234.retail.telecomitalia.it. [82.53.134.234])
        by smtp.gmail.com with ESMTPSA id f10-20020a05600c154a00b003a2f2bb72d5sm19230518wmg.45.2022.11.08.02.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 02:24:22 -0800 (PST)
Date:   Tue, 8 Nov 2022 11:24:19 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Yuan Can <yuancan@huawei.com>
Cc:     stefanha@redhat.com, mst@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] vhost/vsock: Fix error handling in vhost_vsock_init()
Message-ID: <20221108102419.tq4veo3h4xj3jr46@sgarzare-redhat>
References: <20221108101705.45981-1-yuancan@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221108101705.45981-1-yuancan@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 10:17:05AM +0000, Yuan Can wrote:
>A problem about modprobe vhost_vsock failed is triggered with the
>following log given:
>
>modprobe: ERROR: could not insert 'vhost_vsock': Device or resource busy
>
>The reason is that vhost_vsock_init() returns misc_register() directly
>without checking its return value, if misc_register() failed, it returns
>without calling vsock_core_unregister() on vhost_transport, resulting the
>vhost_vsock can never be installed later.
>A simple call graph is shown as below:
>
> vhost_vsock_init()
>   vsock_core_register() # register vhost_transport
>   misc_register()
>     device_create_with_groups()
>       device_create_groups_vargs()
>         dev = kzalloc(...) # OOM happened
>   # return without unregister vhost_transport
>
>Fix by calling vsock_core_unregister() when misc_register() returns error.
>
>Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
>Signed-off-by: Yuan Can <yuancan@huawei.com>
>---
>Changes in v2:
>- change to the correct Fixes: tag

I forgot to mention that anyway the patch was okay for me :-) and so:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

Thanks,
Stefano

>
> drivers/vhost/vsock.c | 9 ++++++++-
> 1 file changed, 8 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index 5703775af129..10a7d23731fe 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -959,7 +959,14 @@ static int __init vhost_vsock_init(void)
> 				  VSOCK_TRANSPORT_F_H2G);
> 	if (ret < 0)
> 		return ret;
>-	return misc_register(&vhost_vsock_misc);
>+
>+	ret = misc_register(&vhost_vsock_misc);
>+	if (ret) {
>+		vsock_core_unregister(&vhost_transport.transport);
>+		return ret;
>+	}
>+
>+	return 0;
> };
>
> static void __exit vhost_vsock_exit(void)
>-- 
>2.17.1
>

