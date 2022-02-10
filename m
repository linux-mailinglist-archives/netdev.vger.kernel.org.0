Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8F214B0798
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 08:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236720AbiBJHzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 02:55:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236713AbiBJHzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 02:55:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6CF9C1088
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 23:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644479712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zugcEe/L5enDuPfVWQBevSE+n4Uvb3Sduii90i7kkvA=;
        b=ENlDcj1EPfJBgx0jvUQZkTi++sKv0VfdHdSLQ2h6128MEY1CkwvQCY0zxstgQgFe4W63xS
        FLdFf4RHKa6Ds+wc1hW6WT57Y4z7o6/ch9T7XG4AP1VqD0YJKFfcL9S2Vthoibfv5inO6n
        iL7y/9tQwrBFQ0pZCjCoZd+3ufnEVVo=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-3-M6hVKDwrPXaX_KcDqs9lgA-1; Thu, 10 Feb 2022 02:55:11 -0500
X-MC-Unique: M6hVKDwrPXaX_KcDqs9lgA-1
Received: by mail-lj1-f199.google.com with SMTP id a13-20020a2e88cd000000b002386c61ffe2so2228482ljk.7
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 23:55:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zugcEe/L5enDuPfVWQBevSE+n4Uvb3Sduii90i7kkvA=;
        b=SUCeJXOUswZV2o1iShRjl40LsIoF5Md4G5H4svgTxnsUtd2zbY7Kgd653xHh7yMdX3
         HQY8JlwY49HbJnul6m/mgXjqboq+n39UbM01LWxIT4uq8wS+uOJmKsSydcIG5Vwl+mPU
         usYUvY9wHgcvxfuROBemoG09GUMs5wJfGFg8LcQcdkAF90OtRTek7GOaeDxZY10K+Osx
         w4U8X+IWCStTV7huyBsY1sYOY6F4mzariX+umHKdkr5QT76vkUKjW2y9M/GkiRq8ZhBw
         xXhFTS1nzJbTiex4+p9t9yJrNWb58ZEasSCkbRhX/yy0tWbLhY4sR7cPIjF+Qfb+kDrR
         lbyA==
X-Gm-Message-State: AOAM532IGpVs39GHwroN5Xx+txrtpuqQqwlAZeNJHLPnQJQKBExIymdX
        K4HHzUN0NaZB4zw0GMKAJz8BLmoOAioo4GxM48pUjkC0zXgSbkKmf/PNqvb/hXJNzjuUmc3akko
        ifyg+xTZGIUMZIAFkEBRlTQeo8CPz/NsC
X-Received: by 2002:a05:6512:3d8d:: with SMTP id k13mr4524801lfv.481.1644479709499;
        Wed, 09 Feb 2022 23:55:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxfzG9noIJ3W+HO08sPWSR9y3AumHSkuOCXNuuKLYFywy6e2ErMQWW7OSi6mhZBvwh5JhVEWvR0u4mVgRialxA=
X-Received: by 2002:a05:6512:3d8d:: with SMTP id k13mr4524795lfv.481.1644479709315;
 Wed, 09 Feb 2022 23:55:09 -0800 (PST)
MIME-Version: 1.0
References: <20220207125537.174619-1-elic@nvidia.com> <20220207125537.174619-3-elic@nvidia.com>
In-Reply-To: <20220207125537.174619-3-elic@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 10 Feb 2022 15:54:57 +0800
Message-ID: <CACGkMEvF7opCo35QLz4p3u7=T1+H-p=isFm4+yh4uNzKiAxr1A@mail.gmail.com>
Subject: Re: [PATCH 2/3] virtio: Define bit numbers for device independent features
To:     Eli Cohen <elic@nvidia.com>
Cc:     "Hemminger, Stephen" <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Jianbo Liu <jianbol@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 7, 2022 at 8:56 PM Eli Cohen <elic@nvidia.com> wrote:
>
> Define bit fields for device independent feature bits. We need them in a
> follow up patch.
>
> Also, define macros for start and end of these feature bits.
>
> Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---
>  include/uapi/linux/virtio_config.h | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
> index 3bf6c8bf8477..6d92cc31a8d3 100644
> --- a/include/uapi/linux/virtio_config.h
> +++ b/include/uapi/linux/virtio_config.h
> @@ -45,14 +45,14 @@
>  /* We've given up on this device. */
>  #define VIRTIO_CONFIG_S_FAILED         0x80
>
> -/*
> - * Virtio feature bits VIRTIO_TRANSPORT_F_START through
> - * VIRTIO_TRANSPORT_F_END are reserved for the transport
> - * being used (e.g. virtio_ring, virtio_pci etc.), the
> - * rest are per-device feature bits.
> - */
> -#define VIRTIO_TRANSPORT_F_START       28
> -#define VIRTIO_TRANSPORT_F_END         38
> +/* Device independent features per virtio spec 1.1 range from 28 to 38 */
> +#define VIRTIO_DEV_INDEPENDENT_F_START 28
> +#define VIRTIO_DEV_INDEPENDENT_F_END   38

Haven't gone through patch 3 but I think it's probably better not
touch uapi stuff. Or we can define those macros in other place?

> +
> +#define VIRTIO_F_RING_INDIRECT_DESC 28
> +#define VIRTIO_F_RING_EVENT_IDX 29
> +#define VIRTIO_F_IN_ORDER 35
> +#define VIRTIO_F_NOTIFICATION_DATA 38

This part belongs to the virtio_ring.h any reason not pull that file
instead of squashing those into virtio_config.h?

Thanks

>
>  #ifndef VIRTIO_CONFIG_NO_LEGACY
>  /* Do we get callbacks when the ring is completely used, even if we've
> --
> 2.34.1
>

