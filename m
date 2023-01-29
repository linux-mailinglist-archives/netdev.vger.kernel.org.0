Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0F767FD07
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 07:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbjA2GDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 01:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbjA2GDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 01:03:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F7822DE2
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 22:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674972141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G+y0lNUe2D3FZqvZZMcDdGneE6tCR0dFmD5Cj+Ac+co=;
        b=jGyshBpiuc7o4x6BkaXId/RJsmg5fjNiGBlrzg022tz6bNBIi7z79qil7jRDQL1K2ln7LY
        1Ee2iMaZ6oPQmVHZckJVNeRUcPB30MyPSke4O5lARXGUmmBU7uwv2bAH4rRdguEYKULXjq
        UGLEP9CaZrCexerYSJ/cuLvpl5ikr4I=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-458-avcbEC3BMCqVQZ3ifLYAcA-1; Sun, 29 Jan 2023 01:02:20 -0500
X-MC-Unique: avcbEC3BMCqVQZ3ifLYAcA-1
Received: by mail-oo1-f71.google.com with SMTP id r8-20020a4aa2c8000000b005174e40d6f3so211462ool.17
        for <netdev@vger.kernel.org>; Sat, 28 Jan 2023 22:02:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G+y0lNUe2D3FZqvZZMcDdGneE6tCR0dFmD5Cj+Ac+co=;
        b=k15haAWuZxvVnbU30pt7qRBpQ2kmsg81To3J/o4Uh1FOd3e0FVurWc0cknDgnIp8+B
         a8rxW9qYleueKDHVIqBV6aMJnWvpOtb/O/9lhNKGPxxmACWar/JTesHAAx49ctBkskK2
         X9iJOA5/1sekKLjG3v5/LRyhpsbuhyHqYIqQXcAcwhI4SETOtYCbwKL3xRJd1rwYwhbj
         CbG/7zQ4xGbwsxBNGyvXHmo1euIkIXwzIEoMAvPcBoxI+UdbPx+elgufTCAL0/gBlnzV
         85PXTMFHpGb9YWALu77BhohEa4dDxVSAbfLeN8SNy3zu3bMgcsKd1RW8wZPJ647NYoSn
         0qPQ==
X-Gm-Message-State: AO0yUKUyJPkpbuTjTGmD8L857QItvO9v7X2hbfdoWO0OeNb7kYiDXaxn
        l/ceDjMKH2FtDyWYmAI2YXFscmdx9a6Mj8ekST8OJ3dCXir/bXD4ss/gqUf6K+8LZIkfUa0K8g5
        7CwmZsJsx+YT0EuvtMTWrVqJu2vjLyqSx
X-Received: by 2002:a4a:3457:0:b0:517:7850:6483 with SMTP id n23-20020a4a3457000000b0051778506483mr949oof.3.1674972139687;
        Sat, 28 Jan 2023 22:02:19 -0800 (PST)
X-Google-Smtp-Source: AK7set8mW0JZ/n8lyZTTpcC67kMpT2Kinp8/MANimSerBoRFqCNzWu7WVdXpOca4BzGXE3JkgQMmFmJ+hFInW8+aXt4=
X-Received: by 2002:a4a:3457:0:b0:517:7850:6483 with SMTP id
 n23-20020a4a3457000000b0051778506483mr940oof.3.1674972139474; Sat, 28 Jan
 2023 22:02:19 -0800 (PST)
MIME-Version: 1.0
References: <20230128031740.166743-1-sunnanyong@huawei.com>
In-Reply-To: <20230128031740.166743-1-sunnanyong@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Sun, 29 Jan 2023 14:02:08 +0800
Message-ID: <CACGkMEtMAFMbhPnaaTwGRFofPM-p8ceKzAUbD2AFBz=fbR6hYQ@mail.gmail.com>
Subject: Re: [PATCH] vhost/vdpa: Add MSI translation tables to iommu for
 software-managed MSI
To:     Nanyong Sun <sunnanyong@huawei.com>
Cc:     joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
        mst@redhat.com, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        wangrong68@huawei.com
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

On Sat, Jan 28, 2023 at 10:25 AM Nanyong Sun <sunnanyong@huawei.com> wrote:
>
> From: Rong Wang <wangrong68@huawei.com>
>
> Once enable iommu domain for one device, the MSI
> translation tables have to be there for software-managed MSI.
> Otherwise, platform with software-managed MSI without an
> irq bypass function, can not get a correct memory write event
> from pcie, will not get irqs.
> The solution is to obtain the MSI phy base address from
> iommu reserved region, and set it to iommu MSI cookie,
> then translation tables will be created while request irq.
>
> Signed-off-by: Rong Wang <wangrong68@huawei.com>
> Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
> ---
>  drivers/iommu/iommu.c |  1 +
>  drivers/vhost/vdpa.c  | 53 ++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 51 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index de91dd88705b..f6c65d5d8e2b 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2623,6 +2623,7 @@ void iommu_get_resv_regions(struct device *dev, struct list_head *list)
>         if (ops->get_resv_regions)
>                 ops->get_resv_regions(dev, list);
>  }
> +EXPORT_SYMBOL_GPL(iommu_get_resv_regions);
>
>  /**
>   * iommu_put_resv_regions - release resered regions
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index ec32f785dfde..31d3e9ed4cfa 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1103,6 +1103,48 @@ static ssize_t vhost_vdpa_chr_write_iter(struct kiocb *iocb,
>         return vhost_chr_write_iter(dev, from);
>  }
>
> +static bool vhost_vdpa_check_sw_msi(struct list_head *dev_resv_regions, phys_addr_t *base)
> +{
> +       struct iommu_resv_region *region;
> +       bool ret = false;
> +
> +       list_for_each_entry(region, dev_resv_regions, list) {
> +               /*
> +                * The presence of any 'real' MSI regions should take
> +                * precedence over the software-managed one if the
> +                * IOMMU driver happens to advertise both types.
> +                */
> +               if (region->type == IOMMU_RESV_MSI) {
> +                       ret = false;
> +                       break;
> +               }
> +
> +               if (region->type == IOMMU_RESV_SW_MSI) {
> +                       *base = region->start;
> +                       ret = true;
> +               }
> +       }
> +
> +       return ret;
> +}

Can we unify this with what VFIO had?

> +
> +static int vhost_vdpa_get_msi_cookie(struct iommu_domain *domain, struct device *dma_dev)
> +{
> +       struct list_head dev_resv_regions;
> +       phys_addr_t resv_msi_base = 0;
> +       int ret = 0;
> +
> +       INIT_LIST_HEAD(&dev_resv_regions);
> +       iommu_get_resv_regions(dma_dev, &dev_resv_regions);
> +
> +       if (vhost_vdpa_check_sw_msi(&dev_resv_regions, &resv_msi_base))
> +               ret = iommu_get_msi_cookie(domain, resv_msi_base);
> +
> +       iommu_put_resv_regions(dma_dev, &dev_resv_regions);
> +
> +       return ret;
> +}
> +
>  static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
>  {
>         struct vdpa_device *vdpa = v->vdpa;
> @@ -1128,11 +1170,16 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
>
>         ret = iommu_attach_device(v->domain, dma_dev);
>         if (ret)
> -               goto err_attach;
> +               goto err_alloc_domain;
>
> -       return 0;
> +       ret = vhost_vdpa_get_msi_cookie(v->domain, dma_dev);

Do we need to check the overlap mapping and record it in the interval
tree (as what VFIO did)?

Thanks

> +       if (ret)
> +               goto err_attach_device;
>
> -err_attach:
> +       return 0;
> +err_attach_device:
> +       iommu_detach_device(v->domain, dma_dev);
> +err_alloc_domain:
>         iommu_domain_free(v->domain);
>         return ret;
>  }
> --
> 2.25.1
>

