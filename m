Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0336737A9
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 12:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjASL7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 06:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbjASL6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 06:58:25 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4206F30A;
        Thu, 19 Jan 2023 03:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674129457; x=1705665457;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OOSuI8Ptgbyop0bHqYWl6Cev1ihhKUlYoWWsszEriiM=;
  b=Ld6BNIAxy62CgK+XmkZEcn8u2OyXgy38RzLrI62u+91zbhwkJHL7M/DM
   6qLa4Jgtz/ZYP+Kq6YpEvUjCPAccKhRPgDkNEMUtuQ1rTpPjMPUpqZSOl
   DNt12/diIZKjyxD2dc4yRIaL1QpRBiLaX6hnu8SbQNIBFjH1rrwdRn1LD
   MBlcd8hdxlG7g/3OKpiWe3ldRGFLu2P5tdd8q6LxwkUyHbuSrDm9N9P7v
   K2d2G6jP0ZFCd1vgXbBnlCTViTLds66WXqvfckl8b+CmSxRHpP9OXVuZ2
   SAZrKRw+7liKWUHn+GGoVMvS2zZBpLlUpRTF7HhIWG2vCq7bMVBEgnUdw
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="305637388"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="305637388"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 03:57:29 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="692393155"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="692393155"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.252.185.248]) ([10.252.185.248])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 03:57:23 -0800
Message-ID: <e44077a7-e275-4e34-b7ad-3e1382ea974d@linux.intel.com>
Date:   Thu, 19 Jan 2023 19:57:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Cc:     baolu.lu@linux.intel.com,
        Alex Williamson <alex.williamson@redhat.com>,
        ath10k@lists.infradead.org, ath11k@lists.infradead.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-media@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-tegra@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, nouveau@lists.freedesktop.org,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 07/10] iommu/intel: Support the gfp argument to the
 map_pages op
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>
References: <7-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <7-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/1/19 2:00, Jason Gunthorpe wrote:
> Flow it down to alloc_pgtable_page() via pfn_to_dma_pte() and
> __domain_mapping().
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Irrelevant to this patch, GFP_ATOMIC could be changed to GFP_KERNEL in
some places. I will follow up further to clean it up.

For this patch,

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Best regards,
baolu
