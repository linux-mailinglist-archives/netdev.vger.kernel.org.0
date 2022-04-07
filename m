Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98DAF4F7A77
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 10:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243309AbiDGIzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 04:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243294AbiDGIzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 04:55:41 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99AF174EA6;
        Thu,  7 Apr 2022 01:53:41 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2377o8qo019769;
        Thu, 7 Apr 2022 08:53:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=uyNsE8Ex9YI8S1tXwshKVJTLTCexafBD49QkhLU1s24=;
 b=FIAHZtfeTCueKaFXrFSiIT9mlRhR2N7A9UyZB5RgrAXC+maFHN1717MdP1JqhFOaDibp
 4+Y2xKI7/hfsiKKVoGCGX6uJC0t0T162ThJkE0Y9zefCIQyEg7zHTZHyDhCUiaIfz6XF
 jCMe41zf57d5Y0xYQsBj7BdgvDfx0SBGvssJQCVNrtt19y5F+9TRk9aCSSRSeNf7M56r
 W3E725XQn1PWg6S8lhDPKeXyziP5whMW23+ig4CAqErOnAgqvf+huPCCiTW0vZaRWTOw
 f0W3EiowdEZxHY8Yffo+8eRLunyL7OiDNkVA3X+HjbtfvUGXWoeOEL0XClWot27ZsroZ 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f9uwts6ch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:53:11 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2378ZRZ7031643;
        Thu, 7 Apr 2022 08:53:11 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f9uwts6br-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:53:11 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2378njqQ008880;
        Thu, 7 Apr 2022 08:53:09 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma05fra.de.ibm.com with ESMTP id 3f6e48qsa8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 08:53:08 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2378r5OY48496960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Apr 2022 08:53:05 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A230AE051;
        Thu,  7 Apr 2022 08:53:05 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52950AE045;
        Thu,  7 Apr 2022 08:53:04 +0000 (GMT)
Received: from sig-9-145-36-59.uk.ibm.com (unknown [9.145.36.59])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Apr 2022 08:53:04 +0000 (GMT)
Message-ID: <49d40d562dbccdac58597b863c357b32f0798284.camel@linux.ibm.com>
Subject: Re: [PATCH 1/5] iommu: Replace uses of IOMMU_CAP_CACHE_COHERENCY
 with dev_is_dma_coherent()
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, Christoph Hellwig <hch@lst.de>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Benvenuti <benve@cisco.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nelson Escobar <neescoba@cisco.com>, netdev@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        virtualization@lists.linux-foundation.org,
        Will Deacon <will@kernel.org>,
        "Tian, Kevin" <kevin.tian@intel.com>
Date:   Thu, 07 Apr 2022 10:53:03 +0200
In-Reply-To: <20220406171729.GJ2120790@nvidia.com>
References: <1-v1-ef02c60ddb76+12ca2-intel_no_snoop_jgg@nvidia.com>
         <db5a6daa-bfe9-744f-7fc5-d5167858bc3e@arm.com>
         <20220406142432.GF2120790@nvidia.com> <20220406151823.GG2120790@nvidia.com>
         <20220406155056.GA30433@lst.de> <20220406160623.GI2120790@nvidia.com>
         <20220406161031.GA31790@lst.de> <20220406171729.GJ2120790@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -eI2_i-ijsMVu9WpUqTiTy_ZXGgnAkK_
X-Proofpoint-GUID: d3-YNui-0WOxSLMzaNCj1z5uxlf9oVYW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_13,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 suspectscore=0 clxscore=1011 adultscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070043
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-04-06 at 14:17 -0300, Jason Gunthorpe wrote:
> On Wed, Apr 06, 2022 at 06:10:31PM +0200, Christoph Hellwig wrote:
> > On Wed, Apr 06, 2022 at 01:06:23PM -0300, Jason Gunthorpe wrote:
> > > On Wed, Apr 06, 2022 at 05:50:56PM +0200, Christoph Hellwig wrote:
> > > > On Wed, Apr 06, 2022 at 12:18:23PM -0300, Jason Gunthorpe wrote:
> > > > > > Oh, I didn't know about device_get_dma_attr()..
> > > > 
> > > > Which is completely broken for any non-OF, non-ACPI plaform.
> > > 
> > > I saw that, but I spent some time searching and could not find an
> > > iommu driver that would load independently of OF or ACPI. ie no IOMMU
> > > platform drivers are created by board files. Things like Intel/AMD
> > > discover only from ACPI, etc.
> > 
> > s390?
> 
> Ah, I missed looking in s390, hyperv and virtio.. 
> 
> hyperv is not creating iommu_domains, just IRQ remapping
> 
> virtio is using OF
> 
> And s390 indeed doesn't obviously have OF or ACPI parts..
> 
> This seems like it would be consistent with other things:
> 
> enum dev_dma_attr device_get_dma_attr(struct device *dev)
> {
> 	const struct fwnode_handle *fwnode = dev_fwnode(dev);
> 	struct acpi_device *adev = to_acpi_device_node(fwnode);
> 
> 	if (is_of_node(fwnode)) {
> 		if (of_dma_is_coherent(to_of_node(fwnode)))
> 			return DEV_DMA_COHERENT;
> 		return DEV_DMA_NON_COHERENT;
> 	} else if (adev) {
> 		return acpi_get_dma_attr(adev);
> 	}
> 
> 	/* Platform is always DMA coherent */
> 	if (!IS_ENABLED(CONFIG_ARCH_HAS_SYNC_DMA_FOR_DEVICE) &&
> 	    !IS_ENABLED(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU) &&
> 	    !IS_ENABLED(CONFIG_ARCH_HAS_SYNC_DMA_FOR_CPU_ALL) &&
> 	    device_iommu_mapped(dev))
> 		return DEV_DMA_COHERENT;
> 	return DEV_DMA_NOT_SUPPORTED;
> }
> EXPORT_SYMBOL_GPL(device_get_dma_attr);
> 
> ie s390 has no of or acpi but the entire platform is known DMA
> coherent at config time so allow it. Not sure we need the
> device_iommu_mapped() or not.

I only took a short look but I think the device_iommu_mapped() call in
there is wrong. On s390 PCI always goes through IOMMU hardware both
when using the IOMMU API and when using the DMA API and this hardware
is always coherent. This is even true for s390 guests in QEMU/KVM and
under the z/VM hypervisor. As far as I can see device_iommu_mapped()'s
check for dev->iommu_group would only work while the device is under
IOMMU API control not DMA API, no?

Also, while it is true that s390 *hardware* devices are always cache
coherent there is also the case that SWIOTLB is used for protected
virtualization and then cache flushing APIs must be used.

