Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9684A56B0FD
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 05:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236738AbiGHDOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 23:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236998AbiGHDO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 23:14:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 557DC74798
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 20:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657250067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6pWJ9vidmXiESXTHRmiFlc+OMg3mXWEt42MkWbaRXFo=;
        b=Jm3zIBnoc6Kh3fSpf9GBnJab6AdKruWc9l8tHqQ9H3EswhpAEx0KkZM6LsO+x7kEJ0EgLw
        RV00vflmtOvoG/k/XkL3D00UsUA7j3Ss4+4dmMV1q3CIjqbuB0fw7PKyI+TkAYJOt4Ji+o
        PXSqhW2JshH6JY1D5eycE3JLsENemKg=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-yE4uFPHlPM-UfPb0kjLxCQ-1; Thu, 07 Jul 2022 23:14:26 -0400
X-MC-Unique: yE4uFPHlPM-UfPb0kjLxCQ-1
Received: by mail-lf1-f69.google.com with SMTP id cf10-20020a056512280a00b0047f5a295656so7192356lfb.15
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 20:14:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6pWJ9vidmXiESXTHRmiFlc+OMg3mXWEt42MkWbaRXFo=;
        b=8PdYZemKR6Ck1nLB1pXm+EzFqPeZT6J3Rb+Kvpio6KLPPUV+zS2OuRRNsnM+On+FT1
         CIE44jZRGjINHR0CQk791Yo9pvyfebi2/eV1/t7KIPhzsWSkQKSp1Gdt001HCuZS5sGZ
         1AEhNduz0mgX8//dpwztbcmrtH6qxruyJh6oHyo5D38J/On8FSLlSCOwRIWv2YXsr7iG
         UOqwtSxklm9SOG3zWZEhd5AStxlgFUxTpw9TVEK7syB9mXEpRbBs5z/Od1dyBzUryrLd
         E25bd/n3Mm0YHfoVClMVcALIV2fk/B9kGPFVW3mzI41jmGLk+BH4rNk6+f8rR29BC26B
         kzVw==
X-Gm-Message-State: AJIora8jDquXa6ZisY+RBjYA4zNHGX5aUvFYc1lC1O9YxUWJi13Nj77e
        sZZCeHhQX43iUVatghDJG5loRfGMX3h96gJuAn2LTWg3KaUcJi6eXFA2l3/pAPfalmMUEYhtCjC
        cfMF2ulGP4MuaVWGyOPNE17fwnEdMl5xm
X-Received: by 2002:a05:6512:b0d:b0:481:5cb4:cf1e with SMTP id w13-20020a0565120b0d00b004815cb4cf1emr864062lfu.442.1657250064634;
        Thu, 07 Jul 2022 20:14:24 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sL5nNaKVUjLfzqmHqBuyERNjefQaJM/fNkZA4syaavKMsdSCdlbxtRU8opv07Qp1KDTOFhmmsBKmEyTtATiQ0=
X-Received: by 2002:a05:6512:b0d:b0:481:5cb4:cf1e with SMTP id
 w13-20020a0565120b0d00b004815cb4cf1emr864054lfu.442.1657250064363; Thu, 07
 Jul 2022 20:14:24 -0700 (PDT)
MIME-Version: 1.0
References: <548e316fa282ce513fabb991a4c4d92258062eb5.1654688822.git.robin.murphy@arm.com>
In-Reply-To: <548e316fa282ce513fabb991a4c4d92258062eb5.1654688822.git.robin.murphy@arm.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 8 Jul 2022 11:14:13 +0800
Message-ID: <CACGkMEvkHKqOkTCEaTUHK4Ve=naeU5p09BpnvPW-y1cGqOTo_w@mail.gmail.com>
Subject: Re: [PATCH] vdpa: Use device_iommu_capable()
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     mst <mst@redhat.com>, kvm <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 8, 2022 at 7:53 PM Robin Murphy <robin.murphy@arm.com> wrote:
>
> Use the new interface to check the capability for our device
> specifically.
>
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/vhost/vdpa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 935a1d0ddb97..4cfebcc24a03 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1074,7 +1074,7 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
>         if (!bus)
>                 return -EFAULT;
>
> -       if (!iommu_capable(bus, IOMMU_CAP_CACHE_COHERENCY))
> +       if (!device_iommu_capable(dma_dev, IOMMU_CAP_CACHE_COHERENCY))
>                 return -ENOTSUPP;
>
>         v->domain = iommu_domain_alloc(bus);
> --
> 2.36.1.dirty
>

