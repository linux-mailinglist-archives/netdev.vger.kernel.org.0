Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC5E6737CA
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 13:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjASMBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 07:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbjASMA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 07:00:59 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560214B76A;
        Thu, 19 Jan 2023 04:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674129653; x=1705665653;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=a0VAKNGfVX7Xb0tncsnGiNJiQB7rZGtxb86sJ68DmJ0=;
  b=eMBmSPsEDMKrHL99mV9lC4DRORcUPu9bVTFjOEtupFxiWvzdgWQNHTbN
   /3bEBEfSk7hN2e+1yCxjgnvFK06PbsBGWwzUGBEuzZo+NWwWNaZrYc9qX
   y5Pod1jLOrz+TojLlBGy+nbc5mZ+upy0M0t4b9zjRMhn0peExivLGmPpd
   v0JZsiBGnLWViB8UM138SPLlwdUg+mMbQiEBb50549RZY/9hi0w7Fgg4i
   80W/FIXl2soo6mK6VV582uC/b2G4nLyW4P3C2MCBmD7TTmEnM2wIXFE3y
   S/ZVdcdKaY1XVXBKohlhyy8vi+x/ROmH+XuSYlFX8Mc5F98XOYn2+oKYN
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="305638202"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="305638202"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 04:00:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="692393552"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="692393552"
Received: from blu2-mobl.ccr.corp.intel.com (HELO [10.252.185.248]) ([10.252.185.248])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 04:00:46 -0800
Message-ID: <4f93e58d-2406-6b29-d546-02f90c4815b8@linux.intel.com>
Date:   Thu, 19 Jan 2023 20:00:44 +0800
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
Subject: Re: [PATCH v2 08/10] iommu/intel: Use GFP_KERNEL in sleepable
 contexts
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>
References: <8-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <8-v2-ce66f632bd0d+484-iommu_map_gfp_jgg@nvidia.com>
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
> These contexts are sleepable, so use the proper annotation. The GFP_ATOMIC
> was added mechanically in the prior patches.
> 
> Signed-off-by: Jason Gunthorpe<jgg@nvidia.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Best regards,
baolu
