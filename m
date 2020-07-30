Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDE9233A6F
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 23:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730634AbgG3VUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 17:20:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:28233 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730551AbgG3VUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 17:20:48 -0400
IronPort-SDR: yEzyA+yi6KARPyEMwmPeBCyQkns9qyIKnCyJikONI6mXf0noVP8Odc+yRxHlC87xNbfpxrL/O/
 TBtDyhodo02Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9698"; a="152909455"
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="152909455"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2020 14:20:48 -0700
IronPort-SDR: baAGnD9+0IOiikhcoSORgfdiavAIvxvUzaQGCVIY06oFaU2oKxHivcY9pkE07mdAzogPn6cPxU
 DhBe7HaczH9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,415,1589266800"; 
   d="scan'208";a="365320160"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.70.156]) ([10.212.70.156])
  by orsmga001.jf.intel.com with ESMTP; 30 Jul 2020 14:20:47 -0700
Subject: Re: [PATCH v1] ice: devlink: use %*phD to print small buffer
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20200730160451.40810-1-andriy.shevchenko@linux.intel.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <77247fbc-152a-517f-2500-ce761b7afa6a@intel.com>
Date:   Thu, 30 Jul 2020 14:20:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <20200730160451.40810-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/30/2020 9:04 AM, Andy Shevchenko wrote:
> Use %*phD format to print small buffer as hex string.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Ah nice. I swear I looked for a printk format to do this and didn't find
one. But it's been there since 2012.. so I guess I just missed it.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

I also tested this on my system to make sure it gives the same output
for the serial value, so I guess also:

Tested-by: Jacob Keller <jacob.e.keller@intel.com>

Thanks!

> ---
>  drivers/net/ethernet/intel/ice/ice_devlink.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
> index dbbd8b6f9d1a..a9105ad5b983 100644
> --- a/drivers/net/ethernet/intel/ice/ice_devlink.c
> +++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
> @@ -13,9 +13,7 @@ static int ice_info_get_dsn(struct ice_pf *pf, char *buf, size_t len)
>  	/* Copy the DSN into an array in Big Endian format */
>  	put_unaligned_be64(pci_get_dsn(pf->pdev), dsn);
>  
> -	snprintf(buf, len, "%02x-%02x-%02x-%02x-%02x-%02x-%02x-%02x",
> -		 dsn[0], dsn[1], dsn[2], dsn[3],
> -		 dsn[4], dsn[5], dsn[6], dsn[7]);
> +	snprintf(buf, len, "%8phD", dsn);
>  
>  	return 0;
>  }
> 
