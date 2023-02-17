Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B19D69A525
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 06:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjBQFhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 00:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjBQFhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 00:37:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDE25B771
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 21:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676612172;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q8y4UETkQqs5POhMp8MHo+VmSRaMVJi1lvssc8jHWBA=;
        b=LtZih23huMqAw4NgIYsOc/MYAYSkNOODoUd+S+N9x5tZhXOs5yc21cxzi5JjICDfwZ1hKm
        ajk1f2PskoVT+M0hBcomvC2zgi1YsWpjvahQfvM4ol21Gjxsw13cRKuvqoA8hiVD2kIGSc
        L5cgYRktmQkHzCOJGDddGiwnxN50nBM=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-489-K9-yylpLN8a727bmStnIxQ-1; Fri, 17 Feb 2023 00:36:11 -0500
X-MC-Unique: K9-yylpLN8a727bmStnIxQ-1
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-17077e71a51so139743fac.18
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 21:36:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q8y4UETkQqs5POhMp8MHo+VmSRaMVJi1lvssc8jHWBA=;
        b=2Q8bnt6pWMzZtP8i6ZN+nBBnonlK2UMBM+AECWyHmLKK16vgAUYfihPTiReKpAv/7+
         LOn2N8jCJfnfPJ4300P/Camx/cVj1RrQNFTIf86wBQrqstOKtfE3Pskg13Cif2/OspvU
         uzVgDl2+I0Mdqx4YYId7mDg40KRKKwCO0iR7R5NNsxd6XjFmmKYwG2mA/90d2cz9PpVq
         sACQBtDyH4tP9ctAM0vKJ9sac3eO0qXoaPJL1eHv68G3h2Pg/zZuZKLRnqJGkLtxHC6I
         CfAP4pefcUK4WKJNd2lMKz3iB/rBDvrjrliyB6XogwjMmpk2qfZsYQh2/8iMYcbNVRkp
         ++Fg==
X-Gm-Message-State: AO0yUKV2R7ByAq5/vvLtnCK2b4NixJkZ3ZZV2HsvCZwTc3qm8zfz2gYy
        fd8ljFd9HOu+R5+ZrQKJbnJJYEntKZGxupxgqg++g9dayN1K1dRLvIxJv3Of7CIW+u9XLtLY+4S
        ybG1KHpIygCh9WBpm/Katalax3yEYUebA
X-Received: by 2002:a05:6808:3186:b0:37d:5d77:e444 with SMTP id cd6-20020a056808318600b0037d5d77e444mr296394oib.35.1676612170494;
        Thu, 16 Feb 2023 21:36:10 -0800 (PST)
X-Google-Smtp-Source: AK7set+hY95HRDtXDD+GXnz1YrR2uwZRZowpsAyCm1bMt4U0npjM2XW+YfzeYKDUlmV5UD794AQCKMHVcQs7RZ9kgLs=
X-Received: by 2002:a05:6808:3186:b0:37d:5d77:e444 with SMTP id
 cd6-20020a056808318600b0037d5d77e444mr296388oib.35.1676612170318; Thu, 16 Feb
 2023 21:36:10 -0800 (PST)
MIME-Version: 1.0
References: <20230207120843.1580403-1-sunnanyong@huawei.com> <Y+7G+tiBCjKYnxcZ@nvidia.com>
In-Reply-To: <Y+7G+tiBCjKYnxcZ@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 17 Feb 2023 13:35:59 +0800
Message-ID: <CACGkMEtehykvqNUnfCi0VmHR1xpmhj4sSWdYW1-0oATY=0YhXw@mail.gmail.com>
Subject: Re: [PATCH v2] vhost/vdpa: Add MSI translation tables to iommu for
 software-managed MSI
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Nanyong Sun <sunnanyong@huawei.com>, joro@8bytes.org,
        will@kernel.org, robin.murphy@arm.com, mst@redhat.com,
        iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, wangrong68@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 8:15 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Tue, Feb 07, 2023 at 08:08:43PM +0800, Nanyong Sun wrote:
> > From: Rong Wang <wangrong68@huawei.com>
> >
> > Once enable iommu domain for one device, the MSI
> > translation tables have to be there for software-managed MSI.
> > Otherwise, platform with software-managed MSI without an
> > irq bypass function, can not get a correct memory write event
> > from pcie, will not get irqs.
> > The solution is to obtain the MSI phy base address from
> > iommu reserved region, and set it to iommu MSI cookie,
> > then translation tables will be created while request irq.
>
> Probably not what anyone wants to hear, but I would prefer we not add
> more uses of this stuff. It looks like we have to get rid of
> iommu_get_msi_cookie() :\
>
> I'd like it if vdpa could move to iommufd not keep copying stuff from
> it..

Yes, but we probably need a patch for -stable.

>
> Also the iommu_group_has_isolated_msi() check is missing on the vdpa
> path, and it is missing the iommu ownership mechanism.

Ok.

>
> Also which in-tree VDPA driver that uses the iommu runs on ARM? Please

ifcvf and vp_vpda are two drivers that use platform IOMMU.

Thanks

> don't propose core changes for unmerged drivers. :(
>
> Jason
>

