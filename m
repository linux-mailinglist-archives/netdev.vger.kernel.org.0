Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A360622298
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 04:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbiKIDaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 22:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbiKID34 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 22:29:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B3B23BD6
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 19:28:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667964535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vD224Hogxka5wNQa91Zymh6Ygmv+WpD4Z+GDd/Nec64=;
        b=V3juxFVuGEJHf/bS3/DHOMDIyh1qnJYhQ28drjtFqQKq07137+nMovEBFR79A9OvKyGZTg
        F6pOxv5sJnesbPpOQ8OnK7cMzEvHsUCaw9M1SRQ6QCmOPOlmO+X7lI7p/NXsQxSUNsOt4J
        S9BBKpoJSUFKKGsLTDJsSIgn35fVNjk=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-664-JaTyjI9CM3iWi9np2jLmog-1; Tue, 08 Nov 2022 22:28:54 -0500
X-MC-Unique: JaTyjI9CM3iWi9np2jLmog-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-13ca47a9815so8017619fac.17
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 19:28:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vD224Hogxka5wNQa91Zymh6Ygmv+WpD4Z+GDd/Nec64=;
        b=v+SRANrabRDDDjkvow0PPn6UEVyNMXRbIUfJerxdX4vnApaSG4wNkOdrch/s5xfG4W
         bnzvOYFu1ViKt3Gx9Jbep3acjlXZ5ky7r9RPGOG/0c4EfGm/Qtx600l4uW+NfHwnrZE6
         1Yv+sQetEp10cC0FipcTXgIGX5FKX3+WocKOy/aPXUAYIrJ7tQrvZgRrbwMdEPwUy3PL
         oQvrR5FCX0cffO+B8e7Fi5d7DcrlPSB2wBfRHwhIdguZNjBVBCdSJhhQIQHp+fCfQ4AO
         2fMWn1KjNIty3NOC44+dKcIhjVDP5ntnwZs55IdF5ZTn4Ew7Yv3+kByHuMB/8CWarary
         xK6w==
X-Gm-Message-State: ACrzQf3Ci+jtRpzMEQf/tCp8F8rJp/Q4TD6AOGiD5I9ftxK2JvvSA5r7
        6ghgf9GP2D+hwzWBzzwQCf2n8wqu7/+5HtSExTfuk8NeaXtiAyLhGGBHOS4Ed7BM+E0dYw4spHj
        TaNVlA+SoAL36BcVhUFOJiMM4wt5abR6b
X-Received: by 2002:a4a:2ccf:0:b0:49e:b502:3a2b with SMTP id o198-20020a4a2ccf000000b0049eb5023a2bmr9793072ooo.57.1667964533309;
        Tue, 08 Nov 2022 19:28:53 -0800 (PST)
X-Google-Smtp-Source: AMsMyM7F+ESUW02GevhFXeHeZiWN+C8qmGvnQrxAgchRgTHWuxrTWr/5I2RPYR7pW6CVQHNQHYEXuWSbcbl1kJXQxyk=
X-Received: by 2002:a4a:2ccf:0:b0:49e:b502:3a2b with SMTP id
 o198-20020a4a2ccf000000b0049eb5023a2bmr9793067ooo.57.1667964533083; Tue, 08
 Nov 2022 19:28:53 -0800 (PST)
MIME-Version: 1.0
References: <20221108103437.105327-1-sgarzare@redhat.com> <20221108103437.105327-3-sgarzare@redhat.com>
In-Reply-To: <20221108103437.105327-3-sgarzare@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 9 Nov 2022 11:28:41 +0800
Message-ID: <CACGkMEuRnqxESo=V2COnfUjP5jGLTXzNRt3=Tp2x-9jsS-RNGQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] vhost: fix range used in translate_desc()
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org
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

On Tue, Nov 8, 2022 at 6:34 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> vhost_iotlb_itree_first() requires `start` and `last` parameters
> to search for a mapping that overlaps the range.
>
> In translate_desc() we cyclically call vhost_iotlb_itree_first(),
> incrementing `addr` by the amount already translated, so rightly
> we move the `start` parameter passed to vhost_iotlb_itree_first(),
> but we should hold the `last` parameter constant.
>
> Let's fix it by saving the `last` parameter value before incrementing
> `addr` in the loop.
>
> Fixes: 0bbe30668d89 ("vhost: factor out IOTLB")
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>
> I'm not sure about the fixes tag. On the one I used this patch should
> apply cleanly, but looking at the latest stable (4.9), maybe we should
> use
>
> Fixes: a9709d6874d5 ("vhost: convert pre sorted vhost memory array to interval tree")

I think this should be the right commit to fix.

Other than this

Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

>
> Suggestions?
> ---
>  drivers/vhost/vhost.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 40097826cff0..3c2359570df9 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2053,7 +2053,7 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
>         struct vhost_dev *dev = vq->dev;
>         struct vhost_iotlb *umem = dev->iotlb ? dev->iotlb : dev->umem;
>         struct iovec *_iov;
> -       u64 s = 0;
> +       u64 s = 0, last = addr + len - 1;
>         int ret = 0;
>
>         while ((u64)len > s) {
> @@ -2063,7 +2063,7 @@ static int translate_desc(struct vhost_virtqueue *vq, u64 addr, u32 len,
>                         break;
>                 }
>
> -               map = vhost_iotlb_itree_first(umem, addr, addr + len - 1);
> +               map = vhost_iotlb_itree_first(umem, addr, last);
>                 if (map == NULL || map->start > addr) {
>                         if (umem != dev->iotlb) {
>                                 ret = -EFAULT;
> --
> 2.38.1
>

