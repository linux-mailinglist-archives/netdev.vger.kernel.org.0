Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3743F1C2A8
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 07:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfENF4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 01:56:15 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:54234 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726813AbfENF4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 01:56:14 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1hQQQ2-0007gE-IC; Tue, 14 May 2019 08:56:06 +0300
Message-ID: <7b920ce3237faf87e57160a4c6727b87ec9bb1b0.camel@coelho.fi>
Subject: Re: [PATCH] iwlwifi: trans: fix killer series loadded incorrect
 firmware
From:   Luca Coelho <luca@coelho.fi>
To:     Cyrus Lien <cyruslien@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Lior Cohen <lior2.cohen@intel.com>,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Cyrus Lien <cyrus.lien@canonical.com>
Date:   Tue, 14 May 2019 08:56:05 +0300
In-Reply-To: <20190513133335.14536-1-cyrus.lien@canonical.com>
References: <20190513133335.14536-1-cyrus.lien@canonical.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-05-13 at 21:33 +0800, Cyrus Lien wrote:
> Killer series loadded IWL_22000_HR_B_FW_PRE prefixed firmware instead
> IWL_CC_A_FW_PRE prefixed firmware.
> 
> Add killer series to the check logic as iwl_ax200_cfg_cc.
> 
> Signed-off-by: Cyrus Lien <cyrus.lien@canonical.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> index 79c1dc05f948..576c2186b6bf 100644
> --- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
> @@ -3565,7 +3565,9 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct
> pci_dev *pdev,
>  		}
>  	} else if (CSR_HW_RF_ID_TYPE_CHIP_ID(trans->hw_rf_id) ==
>  		   CSR_HW_RF_ID_TYPE_CHIP_ID(CSR_HW_RF_ID_TYPE_HR) &&
> -		   (trans->cfg != &iwl_ax200_cfg_cc ||
> +		   ((trans->cfg != &iwl_ax200_cfg_cc &&
> +		     trans->cfg != &killer1650x_2ax_cfg &&
> +		     trans->cfg != &killer1650w_2ax_cfg) ||
>  		    trans->hw_rev == CSR_HW_REV_TYPE_QNJ_B0)) {
>  		u32 hw_status;
> 

Thanks for your patch, Cyrus! We already have an identical patch in our
internal tree and it will reach the mainline soon.

--
Cheers,
Luca.

