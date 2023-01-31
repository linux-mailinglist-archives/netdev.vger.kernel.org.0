Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08937682287
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbjAaDHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbjAaDHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:07:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD54C298F9
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 19:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675134391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KdMSX2PGXe45qBgqP8RMLgntuCYyndOvWlGnSWr1I1w=;
        b=Gvb+bXLJpCbjV+7vrajRYyqQI+LUlHoVzGSYZdK/Z7UBCXfDIymGOXMinwR5GImF9G1sbc
        u5KfT8Yz6VN0Fw0LM9M7LZdBdHxm6E+1fOgac5AZ5nFc9K1PUELqWruiGl5bFIlpCFguVT
        AZaqsVL86uVzzNMMjvduBOccd2V6jnQ=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-70-zTbD292_Oc-VWxjlIXTl5w-1; Mon, 30 Jan 2023 22:06:29 -0500
X-MC-Unique: zTbD292_Oc-VWxjlIXTl5w-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-1633a09c1c2so4985035fac.17
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 19:06:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KdMSX2PGXe45qBgqP8RMLgntuCYyndOvWlGnSWr1I1w=;
        b=1FPMqirq5dXobz6ZgOm18KGbnpKGOM5AUD2Ka1xKgnuDFOjdbPL3Ouv7xg9XvZJ2la
         zO34Hx35wbzXBvF/KEwuWFf19JxleQ1uIxf1sFGY/01zfjFi669KQpR5c2GHnr/WVB/a
         4neFar386Tmij+Eo+pPP3838Z4HbnB4le19UsaM/jPhk8YOGzrWrtVtgg1XH4J1hyJvS
         cylB0Ut7MUSvR7TMWEnn8Ma7VWB2VG2EyFwn4Gqjh9aP7hDCBrV5u0vT/DL56+RYJRDN
         53oJCv0wXQzXe8poZ9JVYeUjTha4PwK8F3Fpbn9wWPbz+hYaAPEeiqnUgerClt0V2ywV
         47Fw==
X-Gm-Message-State: AO0yUKVAxHYxlR3eEwO+UBTsQF7SKQswlAtm2gzLa4pQwrtMZSkP4fTw
        iOz53yB1qj9Y9gTp8GDC578hYfzt0u4WWeJ692rck4y/xh5kBxPNlzduz3ygdqPNbnV7SrMA505
        2jh0hYlT5uBRbmZtN5puSI1gUka3Fqm8M
X-Received: by 2002:a05:6870:959e:b0:163:9cea:eea7 with SMTP id k30-20020a056870959e00b001639ceaeea7mr565249oao.35.1675134389118;
        Mon, 30 Jan 2023 19:06:29 -0800 (PST)
X-Google-Smtp-Source: AK7set/gy6zeCHS7dDqTzLgm0l0HH281Gpnu1QcOaLODISHVTb7n1+4QzN8Fzmkkj1rEtYbW+m8iASC8yFpzqnKRkFM=
X-Received: by 2002:a05:6870:959e:b0:163:9cea:eea7 with SMTP id
 k30-20020a056870959e00b001639ceaeea7mr565247oao.35.1675134388839; Mon, 30 Jan
 2023 19:06:28 -0800 (PST)
MIME-Version: 1.0
References: <20230128031740.166743-1-sunnanyong@huawei.com>
 <CACGkMEtMAFMbhPnaaTwGRFofPM-p8ceKzAUbD2AFBz=fbR6hYQ@mail.gmail.com> <ffe21085-13cf-e2e9-e5cc-8755e9e3250b@huawei.com>
In-Reply-To: <ffe21085-13cf-e2e9-e5cc-8755e9e3250b@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 31 Jan 2023 11:06:17 +0800
Message-ID: <CACGkMEsuYLen=pXd0e3hFNcUj-GQzj8ggh_8NDgWR2HbsD2S1A@mail.gmail.com>
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

On Tue, Jan 31, 2023 at 9:32 AM Nanyong Sun <sunnanyong@huawei.com> wrote:
>
> On 2023/1/29 14:02, Jason Wang wrote:
> > On Sat, Jan 28, 2023 at 10:25 AM Nanyong Sun <sunnanyong@huawei.com> wrote:
> >> From: Rong Wang <wangrong68@huawei.com>
> >>
> >> Once enable iommu domain for one device, the MSI
> >> translation tables have to be there for software-managed MSI.
> >> Otherwise, platform with software-managed MSI without an
> >> irq bypass function, can not get a correct memory write event
> >> from pcie, will not get irqs.
> >> The solution is to obtain the MSI phy base address from
> >> iommu reserved region, and set it to iommu MSI cookie,
> >> then translation tables will be created while request irq.
> >>
> >> Signed-off-by: Rong Wang <wangrong68@huawei.com>
> >> Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
> >> ---
> >>   drivers/iommu/iommu.c |  1 +
> >>   drivers/vhost/vdpa.c  | 53 ++++++++++++++++++++++++++++++++++++++++---
> >>   2 files changed, 51 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> >> index de91dd88705b..f6c65d5d8e2b 100644
> >> --- a/drivers/iommu/iommu.c
> >> +++ b/drivers/iommu/iommu.c
> >> @@ -2623,6 +2623,7 @@ void iommu_get_resv_regions(struct device *dev, struct list_head *list)
> >>          if (ops->get_resv_regions)
> >>                  ops->get_resv_regions(dev, list);
> >>   }
> >> +EXPORT_SYMBOL_GPL(iommu_get_resv_regions);
> >>
> >>   /**
> >>    * iommu_put_resv_regions - release resered regions
> >> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> >> index ec32f785dfde..31d3e9ed4cfa 100644
> >> --- a/drivers/vhost/vdpa.c
> >> +++ b/drivers/vhost/vdpa.c
> >> @@ -1103,6 +1103,48 @@ static ssize_t vhost_vdpa_chr_write_iter(struct kiocb *iocb,
> >>          return vhost_chr_write_iter(dev, from);
> >>   }
> >>
> >> +static bool vhost_vdpa_check_sw_msi(struct list_head *dev_resv_regions, phys_addr_t *base)
> >> +{
> >> +       struct iommu_resv_region *region;
> >> +       bool ret = false;
> >> +
> >> +       list_for_each_entry(region, dev_resv_regions, list) {
> >> +               /*
> >> +                * The presence of any 'real' MSI regions should take
> >> +                * precedence over the software-managed one if the
> >> +                * IOMMU driver happens to advertise both types.
> >> +                */
> >> +               if (region->type == IOMMU_RESV_MSI) {
> >> +                       ret = false;
> >> +                       break;
> >> +               }
> >> +
> >> +               if (region->type == IOMMU_RESV_SW_MSI) {
> >> +                       *base = region->start;
> >> +                       ret = true;
> >> +               }
> >> +       }
> >> +
> >> +       return ret;
> >> +}
> > Can we unify this with what VFIO had?
> Yes, these two functions are just the same.
> Do you think move this function to iommu.c, and export from iommu is a
> good choice?

Probably, we can try and see.

> >
> >> +
> >> +static int vhost_vdpa_get_msi_cookie(struct iommu_domain *domain, struct device *dma_dev)
> >> +{
> >> +       struct list_head dev_resv_regions;
> >> +       phys_addr_t resv_msi_base = 0;
> >> +       int ret = 0;
> >> +
> >> +       INIT_LIST_HEAD(&dev_resv_regions);
> >> +       iommu_get_resv_regions(dma_dev, &dev_resv_regions);
> >> +
> >> +       if (vhost_vdpa_check_sw_msi(&dev_resv_regions, &resv_msi_base))
> >> +               ret = iommu_get_msi_cookie(domain, resv_msi_base);
> >> +
> >> +       iommu_put_resv_regions(dma_dev, &dev_resv_regions);
> >> +
> >> +       return ret;
> >> +}
> >> +
> >>   static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
> >>   {
> >>          struct vdpa_device *vdpa = v->vdpa;
> >> @@ -1128,11 +1170,16 @@ static int vhost_vdpa_alloc_domain(struct vhost_vdpa *v)
> >>
> >>          ret = iommu_attach_device(v->domain, dma_dev);
> >>          if (ret)
> >> -               goto err_attach;
> >> +               goto err_alloc_domain;
> >>
> >> -       return 0;
> >> +       ret = vhost_vdpa_get_msi_cookie(v->domain, dma_dev);
> > Do we need to check the overlap mapping and record it in the interval
> > tree (as what VFIO did)?
> >
> > Thanks
> Yes, we need to care about this part, I will handle this recently.
> Thanks a lot.

I think for parents that requires vendor specific mapping logic we
probably also need this.

But this could be added on top (via a new config ops probably).

Thanks

> >> +       if (ret)
> >> +               goto err_attach_device;
> >>
> >> -err_attach:
> >> +       return 0;
> >> +err_attach_device:
> >> +       iommu_detach_device(v->domain, dma_dev);
> >> +err_alloc_domain:
> >>          iommu_domain_free(v->domain);
> >>          return ret;
> >>   }
> >> --
> >> 2.25.1
> >>
> > .
>

