Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8E245CF3F
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 14:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbfGBMQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 08:16:09 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54838 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726658AbfGBMQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 08:16:09 -0400
X-Greylist: delayed 1301 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jul 2019 08:16:08 EDT
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hiHMY-0004Nr-Tm; Tue, 02 Jul 2019 14:54:19 +0300
Message-ID: <859d0a7dfa39b34919ffd83b4b9b923504a3d737.camel@coelho.fi>
Subject: Re: [PATCH][next] iwlwifi: mvm: fix comparison of u32 variable with
 less than zero
From:   Luca Coelho <luca@coelho.fi>
To:     Colin King <colin.king@canonical.com>,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.or, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 02 Jul 2019 14:54:16 +0300
In-Reply-To: <20190701162657.15174-1-colin.king@canonical.com>
References: <20190701162657.15174-1-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-07-01 at 17:26 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The comparison of the u32 variable wgds_tbl_idx with less than zero is
> always going to be false because it is unsigned.  Fix this by making
> wgds_tbl_idx a plain signed int.
> 
> Addresses-Coverity: ("Unsigned compared against 0")
> Fixes: 4fd445a2c855 ("iwlwifi: mvm: Add log information about SAR status")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/mvm/nvm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
> index 719f793b3487..a9bb43a2f27b 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
> @@ -620,7 +620,7 @@ void iwl_mvm_rx_chub_update_mcc(struct iwl_mvm *mvm,
>  	enum iwl_mcc_source src;
>  	char mcc[3];
>  	struct ieee80211_regdomain *regd;
> -	u32 wgds_tbl_idx;
> +	int wgds_tbl_idx;
>  
>  	lockdep_assert_held(&mvm->mutex);

Thanks, Colin!

I applied this to our internal tree and it will reach the mainline
following our normal upstreaming process.

--
Cheers,
Luca.

