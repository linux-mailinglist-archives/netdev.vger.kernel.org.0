Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD5A4F8B9E
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 02:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbiDGWkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 18:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbiDGWjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 18:39:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED8B912F14B
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 15:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649371063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NOIZSnS98gQ3xydj16FHLPEIjDJjA+ZwlFfjRBiVUDY=;
        b=Vk4Z+reM9UdPsG+8dZ1C3F/AjQTFreZkPTuV6839sN4FXsLPsA9fW2h/IMln7jazNvZ4AM
        lgCWKwkPQX3WoxaTV71WS29cLgCYbnQ/W43o2Adhy7v7Qow+tcKvTBfrhh+OEonmBVKKe/
        SCj/WtKJk/MVseHX/M2ZWmf16lrJPDc=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-uUFtLVyrM4uXpPn4G7Goyg-1; Thu, 07 Apr 2022 18:37:41 -0400
X-MC-Unique: uUFtLVyrM4uXpPn4G7Goyg-1
Received: by mail-ot1-f69.google.com with SMTP id w20-20020a9d70d4000000b005e685c5b4b6so3462078otj.2
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 15:37:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=NOIZSnS98gQ3xydj16FHLPEIjDJjA+ZwlFfjRBiVUDY=;
        b=XMhf47yYsPCRyg2kDpXHlbir5QrKqL19NXxRRFBIg/5LxnLXMYvYVGDf4xdn90a/uF
         c6mj50gkHjrAmYJmf3QVaO0zRQNypS0f6qMGmf00gCwOlK4LexjdJ3lgLD+nANJCdvLA
         G7GVLkkQLmzBdM/aE4yxgiUbohY09cKyf6OCprwTp4mWupByqbCqqXA6+pBrkiItREcL
         Y+hUDiCcQaw/751Z/cKlGJI1NutD9VJf8DEHq6aD35xdjQm59PTwiXCyfcHEt/hB+rnD
         NCjRXls/fES0QE5VAF/Jla/D94oc8RCBGnjuTyzB7CM03vvDhmpdbzgFW/FsxOrFC78/
         Mwhg==
X-Gm-Message-State: AOAM532aIqx5lBdhl7fRC7mJeCVeCP134S/coRap2yTz8BR+mhrTqsid
        p6KF6xiLSCVIs4dohWN7EbIjoavOkkZqRZHsl44Wju1QRBX/SOgqT1HMDxSGhZBfc7XFWQ9BJIk
        fZAME2Za+SDP1vHrA
X-Received: by 2002:a9d:ee7:0:b0:5cd:feb9:66b5 with SMTP id 94-20020a9d0ee7000000b005cdfeb966b5mr5515093otj.216.1649371061195;
        Thu, 07 Apr 2022 15:37:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxcVZwyerJlnB50z195byTw9JBG/9w1iOCvt6QyoKpKsIz/rFvJndsMgHRlm6GD1Fo6Sk8OMg==
X-Received: by 2002:a9d:ee7:0:b0:5cd:feb9:66b5 with SMTP id 94-20020a9d0ee7000000b005cdfeb966b5mr5515064otj.216.1649371060962;
        Thu, 07 Apr 2022 15:37:40 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id c8-20020a4ad788000000b0031ce69b1640sm7642523oou.10.2022.04.07.15.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 15:37:40 -0700 (PDT)
Date:   Thu, 7 Apr 2022 16:37:37 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Benvenuti <benve@cisco.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nelson Escobar <neescoba@cisco.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Rob Clark <robdclark@gmail.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 1/5] iommu: Replace uses of IOMMU_CAP_CACHE_COHERENCY
 with dev_is_dma_coherent()
Message-ID: <20220407163737.2a7ccd7a.alex.williamson@redhat.com>
In-Reply-To: <20220407152331.GN2120790@nvidia.com>
References: <db5a6daa-bfe9-744f-7fc5-d5167858bc3e@arm.com>
        <20220406142432.GF2120790@nvidia.com>
        <20220406151823.GG2120790@nvidia.com>
        <20220406155056.GA30433@lst.de>
        <20220406160623.GI2120790@nvidia.com>
        <20220406161031.GA31790@lst.de>
        <20220406171729.GJ2120790@nvidia.com>
        <BN9PR11MB5276F9CEA2B01B3E75094B6D8CE69@BN9PR11MB5276.namprd11.prod.outlook.com>
        <20220407135946.GM2120790@nvidia.com>
        <fb55a025-348e-800c-e368-48be075d8e9c@arm.com>
        <20220407152331.GN2120790@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Apr 2022 12:23:31 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Apr 07, 2022 at 04:17:11PM +0100, Robin Murphy wrote:
> 
> > For the specific case of overriding PCIe No Snoop (which is more problematic
> > from an Arm SMMU PoV) when assigning to a VM, would that not be easier
> > solved by just having vfio-pci clear the "Enable No Snoop" control bit in
> > the endpoint's PCIe capability?  
> 
> Ideally.
> 
> That was rediscussed recently, apparently there are non-compliant
> devices and drivers that just ignore the bit. 
> 
> Presumably this is why x86 had to move to an IOMMU enforced feature..

I considered this option when implementing the current solution, but
ultimately I didn't have confidence in being able to prevent drivers
from using device specific means to effect the change anyway.  GPUs
especially have various back channels to config space.  Thanks,

Alex

