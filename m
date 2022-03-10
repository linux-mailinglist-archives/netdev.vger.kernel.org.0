Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF4A4D5100
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 18:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238376AbiCJR5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 12:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236272AbiCJR52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 12:57:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2D9481662EC
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 09:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646934986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rkPBo3Z97DCJCmqrebEMdZGQBy/a9FPya5vrhdSYtWI=;
        b=fpiaaizGCgATxgrfiwzR02xmv/zv8XSEpUscH8sCnGSyD50jeuEE6JHv3T5ZMFLHNo47Aa
        pINqnLZI0IcQgtQDQmH8p2oaXnROIW8bFDphDW2TCDrzQjjKhKgONWMCKrJcCNw9sXwufO
        O487KoGToEBWqBkYD9ukU7r/hpOCQPQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-MafyjCXHMkS-ACUap38Cjg-1; Thu, 10 Mar 2022 12:56:23 -0500
X-MC-Unique: MafyjCXHMkS-ACUap38Cjg-1
Received: by mail-qt1-f200.google.com with SMTP id ay12-20020a05622a228c00b002e0659131baso4599185qtb.11
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 09:56:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rkPBo3Z97DCJCmqrebEMdZGQBy/a9FPya5vrhdSYtWI=;
        b=mweqXBUDDua/ZVjEd9YER8ZPM9ktvQyyvG9L4uAPopwZQY4fkDVILXRY2+NLm2ifLN
         4FX+yqzLcrMoZZ40mIbSA66dKdpPYLz8UgMYdDcilzmzRSahFAoGlL2FZGSKXRiKer87
         5v4mJUCUNrx/PhPfVtEaT8GwFh2wRgY5/xju8/TJoZn91be2cbk34/rwKX9M1BSMM1lG
         PykgoOQwaIhZVPCq8Ku4dboez1OiK4gBp6mQgF+OlReWW1BX8yw5QTiar5mXLE1DJ1nx
         AemRnrHKLdq4MK76QovlDqBzIecidmS2tbWucsq0K2Cn5vhaZ4T5y7Fo3qWlEfvluVRq
         BRiA==
X-Gm-Message-State: AOAM530xgTHspmbsTi8X2sNM+cgB19CIYJ2OIjnIEWmZCEyC5PKsS53a
        kieLoz6s0YmvtqLx/kXGu88X2uKYOt4m01LxitcuBPiqrIk18N6xmP/DKy2gyWHGDCwmcpgbRsa
        w0ZjbRuEv1QLfZzhLIsCCAcwMI7jNzSUD
X-Received: by 2002:a05:620a:17a6:b0:67b:cd:72d0 with SMTP id ay38-20020a05620a17a600b0067b00cd72d0mr3931889qkb.406.1646934982804;
        Thu, 10 Mar 2022 09:56:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw6gBoE5AIyUGB0jDDVS5NvaCAYKFicqPjbo6Ono52Y1893x8AibQaTsESSBkY/CW41ZRbNkWXV1gxZ2YZELXA=
X-Received: by 2002:a05:620a:17a6:b0:67b:cd:72d0 with SMTP id
 ay38-20020a05620a17a600b0067b00cd72d0mr3931868qkb.406.1646934982618; Thu, 10
 Mar 2022 09:56:22 -0800 (PST)
MIME-Version: 1.0
References: <20201216064818.48239-1-jasowang@redhat.com> <20220224212314.1326-1-gdawar@xilinx.com>
 <20220224212314.1326-17-gdawar@xilinx.com>
In-Reply-To: <20220224212314.1326-17-gdawar@xilinx.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 10 Mar 2022 18:55:46 +0100
Message-ID: <CAJaqyWekkJEJufrWGx83eaDj2Osi2E_r=K9rY0Qh+iFb1fJ+yA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 16/19] vdpa_sim: advertise VIRTIO_NET_F_MTU
To:     Gautam Dawar <gautam.dawar@xilinx.com>
Cc:     Gautam Dawar <gdawar@xilinx.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Tanuj Murlidhar Kamde <tanujk@xilinx.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Eli Cohen <elic@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 10:28 PM Gautam Dawar <gautam.dawar@xilinx.com> wrote:
>
> We've already reported maximum mtu via config space, so let's
> advertise the feature.
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
> ---
>  drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> index d5324f6fd8c7..ff22cc56f40b 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> @@ -26,7 +26,8 @@
>  #define DRV_LICENSE  "GPL v2"
>
>  #define VDPASIM_NET_FEATURES   (VDPASIM_FEATURES | \
> -                                (1ULL << VIRTIO_NET_F_MAC))
> +                                (1ULL << VIRTIO_NET_F_MAC) | \
> +                                (1ULL << VIRTIO_NET_F_MTU));

Extra semicolon at the end of macro.

Thanks.

>
>  #define VDPASIM_NET_VQ_NUM     2
>
> --
> 2.25.0
>

