Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 506BF18B933
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 15:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgCSOTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 10:19:54 -0400
Received: from sender11-op-o12.zoho.eu ([31.186.226.226]:17427 "EHLO
        sender11-op-o12.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbgCSOTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 10:19:54 -0400
Received: from [100.109.44.175] (163.114.130.4 [163.114.130.4]) by mx.zoho.eu
        with SMTPS id 1584627571593553.2825854778466; Thu, 19 Mar 2020 15:19:31 +0100 (CET)
Subject: Re: [PATCH] rtl8xxxu: Fix sparse warning: cast from restricted __le16
To:     Chris Chiu <chiu@endlessm.com>, kvalo@codeaurora.org,
        davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        kbuild test robot <lkp@intel.com>
References: <20200319064341.49500-1-chiu@endlessm.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <fb942467-fc43-114f-3fd4-f38db90d505b@trained-monkey.org>
Date:   Thu, 19 Mar 2020 10:19:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200319064341.49500-1-chiu@endlessm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/20 2:43 AM, Chris Chiu wrote:
> Fix the warning reported by sparse as:
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:4819:17: sparse: sparse: cast from restricted __le16
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:4892:17: sparse: sparse: cast from restricted __le16
> 
> Signed-off-by: Chris Chiu <chiu@endlessm.com>
> Reported-by: kbuild test robot <lkp@intel.com>

Acked-by: Jes Sorensen <jes@trained-monkey.org>


> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> index 54a1a4ea107b..daa6ce14c68b 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> @@ -4816,8 +4816,8 @@ rtl8xxxu_fill_txdesc_v1(struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
>  		rate = tx_rate->hw_value;
>  
>  	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_TX)
> -		dev_info(dev, "%s: TX rate: %d, pkt size %d\n",
> -			 __func__, rate, cpu_to_le16(tx_desc->pkt_size));
> +		dev_info(dev, "%s: TX rate: %d, pkt size %u\n",
> +			 __func__, rate, le16_to_cpu(tx_desc->pkt_size));
>  
>  	seq_number = IEEE80211_SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
>  
> @@ -4889,8 +4889,8 @@ rtl8xxxu_fill_txdesc_v2(struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
>  		rate = tx_rate->hw_value;
>  
>  	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_TX)
> -		dev_info(dev, "%s: TX rate: %d, pkt size %d\n",
> -			 __func__, rate, cpu_to_le16(tx_desc40->pkt_size));
> +		dev_info(dev, "%s: TX rate: %d, pkt size %u\n",
> +			 __func__, rate, le16_to_cpu(tx_desc40->pkt_size));
>  
>  	seq_number = IEEE80211_SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
>  
> 

