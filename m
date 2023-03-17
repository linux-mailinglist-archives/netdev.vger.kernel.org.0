Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C306BE2EB
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 09:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjCQITi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 04:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjCQITh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 04:19:37 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D266623664;
        Fri, 17 Mar 2023 01:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679041144; x=1710577144;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/omHGfZ5dOYrjoSumS2lKvLRuYatBfJZeL4MVZdQvsM=;
  b=ar5vgMHcIDoTV7R5bM7psD3sH0G2OJjZRHRjktk8t2fJOUQwj4Op2boQ
   K6j4ZsC9OHVZdfwCDytjAHzF1zAVhjNzqnCPJPGrzeUlSJbeFEaJZGja/
   PTEKZevJDwnzFtbIhzbBeW01bV8lgUeCLBrmyyD/+ujNSDi7zy+PV9YSZ
   gbkk+U0QxWzRmuvXyMFEmTuxiUV7UlPiiJ859yQ19Vp0kNasx69DjuBKQ
   sZYhmWhz97pCQpUVcwzWJ0ntwCf88PWCdoIIQOlNETH/10NynAOx3kboe
   t1fWjD25YveXwpjA/8lTinZwbEkg0q1D4UrbpBHd4dhuT1lvpAXiwjgPv
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="322058149"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="322058149"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 01:18:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="804031943"
X-IronPort-AV: E=Sophos;i="5.98,268,1673942400"; 
   d="scan'208";a="804031943"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 01:18:15 -0700
Date:   Fri, 17 Mar 2023 09:18:06 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     kuba@kernel.org, sgoutham@marvell.com, gakula@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] octeontx2-vf: Add missing free for alloc_percpu
Message-ID: <ZBQiPmhuH7aNJo5p@localhost.localdomain>
References: <20230317064337.18198-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317064337.18198-1-jiasheng@iscas.ac.cn>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 02:43:37PM +0800, Jiasheng Jiang wrote:
> Add the free_percpu for the allocated "vf->hw.lmt_info" in order to avoid
> memory leak, same as the "pf->hw.lmt_info" in
> `drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c`.
> 
> Fixes: 5c0512072f65 ("octeontx2-pf: cn10k: Use runtime allocated LMTLINE region")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Acked-by: Geethasowjanya Akula <gakula@marvell.com>
> ---
> Changelog:
> 
> v1 -> v2:
> 
> 1. Remove the if () checks.
Hi,

Did You change that because of my comments? I am not sure it is correct.
I meant moving these two ifs to new function, because they are called
two times. It will be easier to do changes in the future.

void cn10k_lmtst_deinit(struct otx2_nic *pfvf)
{
	if (vf->hw.lmt_info)
		free_percpu(vf->hw.lmt_info);
	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
		qmem_free(vf->dev, vf->dync_lmt);
}

Thanks,
Michal

> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> index 7f8ffbf79cf7..ab126f8706c7 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
> @@ -709,6 +709,7 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  err_ptp_destroy:
>  	otx2_ptp_destroy(vf);
>  err_detach_rsrc:
> +	free_percpu(vf->hw.lmt_info);
>  	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
>  		qmem_free(vf->dev, vf->dync_lmt);
>  	otx2_detach_resources(&vf->mbox);
> @@ -762,6 +763,7 @@ static void otx2vf_remove(struct pci_dev *pdev)
>  	otx2_shutdown_tc(vf);
>  	otx2vf_disable_mbox_intr(vf);
>  	otx2_detach_resources(&vf->mbox);
> +	free_percpu(vf->hw.lmt_info);
>  	if (test_bit(CN10K_LMTST, &vf->hw.cap_flag))
>  		qmem_free(vf->dev, vf->dync_lmt);
>  	otx2vf_vfaf_mbox_destroy(vf);
> -- 
> 2.25.1
> 
