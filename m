Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97EDB66D85C
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 09:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbjAQIhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 03:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236220AbjAQIgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 03:36:14 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C13C27488;
        Tue, 17 Jan 2023 00:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673944567; x=1705480567;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+/sep6cg202vL4sr/HrqlldWJYwNCPz0Civ/zJRrPiM=;
  b=kC944rsttNMM+kTKzgf2E/C+rzjwxmZRrkJVXgzZ3EiDmtz6Rw40MWbC
   5UEHD4aWdxRx1XjE2T0TxTgPNmZW4mgstfaKJ1TiE2tqdQoXQV/I1Vruw
   OmJougsFpSQY1CGfNOek7e8WxJ/dko6ceEu1BDK7Sr1lJ94Ero8exXZ4i
   N1kZQ9oiW6Svwt2hLBk7ruV4FdOWgbeMKQLoEKaP0XZbWofYBFkIQhD6i
   ls74gTBUo3uw+C9XyVghHutEPDYX2MkNJnMtn5xg2bq+lUwBJruN2OwX7
   FmOWdhSb7y5Mt/72NB/NfMjejUuvzSKs3mZKm7E6h1hTW2HRqvRsygxyo
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="324696291"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="324696291"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 00:36:06 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="783168240"
X-IronPort-AV: E=Sophos;i="5.97,222,1669104000"; 
   d="scan'208";a="783168240"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.252.187.178]) ([10.252.187.178])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2023 00:35:59 -0800
Message-ID: <c742969d-d692-1580-d22c-0f8f3d897201@linux.intel.com>
Date:   Tue, 17 Jan 2023 16:35:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Cc:     baolu.lu@linux.intel.com,
        Alex Williamson <alex.williamson@redhat.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "ath11k@lists.infradead.org" <ath11k@lists.infradead.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 7/8] iommu/intel: Support the gfp argument to the
 map_pages op
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>
References: <0-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
 <7-v1-6e8b3997c46d+89e-iommu_map_gfp_jgg@nvidia.com>
 <BN9PR11MB52765EE38CA21BA27EEA06548CC69@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <BN9PR11MB52765EE38CA21BA27EEA06548CC69@BN9PR11MB5276.namprd11.prod.outlook.com>
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

On 2023/1/17 11:38, Tian, Kevin wrote:
>> From: Jason Gunthorpe<jgg@nvidia.com>
>> Sent: Saturday, January 7, 2023 12:43 AM
>>
>> @@ -2368,7 +2372,7 @@ static int iommu_domain_identity_map(struct
>> dmar_domain *domain,
>>
>>   	return __domain_mapping(domain, first_vpfn,
>>   				first_vpfn, last_vpfn - first_vpfn + 1,
>> -				DMA_PTE_READ|DMA_PTE_WRITE);
>> +				DMA_PTE_READ|DMA_PTE_WRITE,
>> GFP_KERNEL);
>>   }
> Baolu, can you help confirm whether switching from GFP_ATOMIC to
> GFP_KERNEL is OK in this path? it looks fine to me in a quick glance
> but want to be conservative here.

This is also good for me. The memory notifier callback runs in a process
context and allowed to block.

Best regards,
baolu
