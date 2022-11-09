Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA40D6222A0
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 04:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiKIDeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 22:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiKIDeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 22:34:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE042AD7
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 19:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667964779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ivtonRD5aoz1CKIuTlgMyAr3i3s0X8AlSd+W+AfcZ24=;
        b=OJt+9Oy/j/wxzYrHEndw2bk46xNKKgaANj6mDdM2u1oN3PFssfu1Cvrv+K9BXZHWr2GLMB
        v02ePlnRPzqNZV39kZswizeQBT1yD6bQDtIgzmyJ+MD9L7yWKzQz9WZTLhgfICor3Cu56r
        CoL3WWGGic6Y9jNfi+AMRo0YaFx9tkU=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-259-epFPL4TMO9yikuwuYvtWMw-1; Tue, 08 Nov 2022 22:32:58 -0500
X-MC-Unique: epFPL4TMO9yikuwuYvtWMw-1
Received: by mail-oo1-f72.google.com with SMTP id h7-20020a4a6f07000000b0049f2024e47dso96817ooc.17
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 19:32:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ivtonRD5aoz1CKIuTlgMyAr3i3s0X8AlSd+W+AfcZ24=;
        b=14Jqj6XK96sfC18KlPrz9xP7EkZ/6BOjrag6Hy/caXQbZSFyHeLVfUnPyc2+wG/FPO
         Il8/C9C8KZR23wuoHC8owxNpwJb96iAmxvT9e4csvisJtDXDk6vehiLXOjvkjj35L3oB
         iovPDUKYeAvhpHqL+apG+KoMpsLCnUZnECrX7dcWV5V0CioPJy5vvjCQ9aIlt+CIBhvE
         CB6Wcy8Tf4Id6Mnwx874vq9t39xRnDcCVv70hoPWETc6o4OBpHSs6vv/w63DpryPwkjU
         zG3koqBlcxpl+skR0UV3RIYPXgxEQNVJ7/98DGKUCNHinN0/PB7uS5Nm27IG0wx8Ur2T
         tBsg==
X-Gm-Message-State: ACrzQf26o98UoFGF3VIjkg4KAo+u711jNGVbdAu/tZpl17JISvruwkqu
        plS0VP7h2ozaUq9wu64LCU9989h/P6blCiBbiMBtvYkiOF2Cf6LFTsAqiGCI/mE6zMwuqWVYv4X
        epk/X4v48+bMVR6wiW4VA8+qigda7oyaU
X-Received: by 2002:a05:6870:9595:b0:132:7b3:29ac with SMTP id k21-20020a056870959500b0013207b329acmr761469oao.35.1667964777581;
        Tue, 08 Nov 2022 19:32:57 -0800 (PST)
X-Google-Smtp-Source: AMsMyM5M8878AGpCqTVOaVFaPL3HZWvPRD0v5I0xFnMjQ8KJ1iwAp/N5riXwSLa+mgg2JddtpNM0glIl1LS7stO0moc=
X-Received: by 2002:a05:6870:9595:b0:132:7b3:29ac with SMTP id
 k21-20020a056870959500b0013207b329acmr761468oao.35.1667964777388; Tue, 08 Nov
 2022 19:32:57 -0800 (PST)
MIME-Version: 1.0
References: <20221108101705.45981-1-yuancan@huawei.com>
In-Reply-To: <20221108101705.45981-1-yuancan@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 9 Nov 2022 11:32:45 +0800
Message-ID: <CACGkMEsce-TUjC+2H-jaky8=8A+r0sgF2Ti27Hr2YDmKeDpUHw@mail.gmail.com>
Subject: Re: [PATCH v2] vhost/vsock: Fix error handling in vhost_vsock_init()
To:     Yuan Can <yuancan@huawei.com>
Cc:     stefanha@redhat.com, sgarzare@redhat.com, mst@redhat.com,
        davem@davemloft.net, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 8, 2022 at 6:19 PM Yuan Can <yuancan@huawei.com> wrote:
>
> A problem about modprobe vhost_vsock failed is triggered with the
> following log given:
>
> modprobe: ERROR: could not insert 'vhost_vsock': Device or resource busy
>
> The reason is that vhost_vsock_init() returns misc_register() directly
> without checking its return value, if misc_register() failed, it returns
> without calling vsock_core_unregister() on vhost_transport, resulting the
> vhost_vsock can never be installed later.
> A simple call graph is shown as below:
>
>  vhost_vsock_init()
>    vsock_core_register() # register vhost_transport
>    misc_register()
>      device_create_with_groups()
>        device_create_groups_vargs()
>          dev = kzalloc(...) # OOM happened
>    # return without unregister vhost_transport
>
> Fix by calling vsock_core_unregister() when misc_register() returns error.
>
> Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
> Signed-off-by: Yuan Can <yuancan@huawei.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
> Changes in v2:
> - change to the correct Fixes: tag
>
>  drivers/vhost/vsock.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index 5703775af129..10a7d23731fe 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -959,7 +959,14 @@ static int __init vhost_vsock_init(void)
>                                   VSOCK_TRANSPORT_F_H2G);
>         if (ret < 0)
>                 return ret;
> -       return misc_register(&vhost_vsock_misc);
> +
> +       ret = misc_register(&vhost_vsock_misc);
> +       if (ret) {
> +               vsock_core_unregister(&vhost_transport.transport);
> +               return ret;
> +       }
> +
> +       return 0;
>  };
>
>  static void __exit vhost_vsock_exit(void)
> --
> 2.17.1
>

