Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFAB33FE017
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 18:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245469AbhIAQjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 12:39:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:58989 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232317AbhIAQjy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 12:39:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10094"; a="241075131"
X-IronPort-AV: E=Sophos;i="5.84,369,1620716400"; 
   d="scan'208";a="241075131"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2021 09:38:57 -0700
X-IronPort-AV: E=Sophos;i="5.84,369,1620716400"; 
   d="scan'208";a="510487177"
Received: from seware-mobl.amr.corp.intel.com (HELO vcostago-mobl2.amr.corp.intel.com) ([10.209.104.177])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2021 09:38:57 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Colin King <colin.king@canonical.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] igc: remove redundant continue statement
In-Reply-To: <20210829165150.531678-1-colin.king@canonical.com>
References: <20210829165150.531678-1-colin.king@canonical.com>
Date:   Wed, 01 Sep 2021 09:38:57 -0700
Message-ID: <878s0g2qu6.fsf@vcostago-mobl2.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> writes:

> From: Colin Ian King <colin.king@canonical.com>
>
> The continue statement at the end of a for-loop has no effect,
> remove it.
>
> Addresses-Coverity: ("Continue has no effect")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/intel/igc/igc_ptp.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
> index 0f021909b430..b615a980f563 100644
> --- a/drivers/net/ethernet/intel/igc/igc_ptp.c
> +++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
> @@ -860,7 +860,6 @@ static int igc_phc_get_syncdevicetime(ktime_t *device,
>  			 * so write the previous error status to clear it.
>  			 */
>  			wr32(IGC_PTM_STAT, stat);
> -			continue;

Just a bit of background.

I added the "continue" here more as documentation: we handled an error,
and we want to try again, I felt that the continue helps making that
clearer.

But I am not completely opposed about removing it.

>  		}
>  	} while (--count);
>  
> -- 
> 2.32.0
>

Cheers,
-- 
Vinicius
