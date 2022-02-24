Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D534C20FC
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 02:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiBXBcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 20:32:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiBXBcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 20:32:47 -0500
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A062B43395;
        Wed, 23 Feb 2022 17:32:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1645666338; x=1677202338;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=t8MPPK30DtlCQHux+g7xPcTxNihra4Q/dwbimkdpxrg=;
  b=rUwKrA9ix9IdpjqmYQBuTpPDneIU7hqxFUn7vqzlvKramSrnBp0Oe12y
   9FiJtftDsJx0mSS1eEMPDpY6cSuxeJz+0RdDok4L+V2fTyM5o5KCQ0Wsu
   O6YbD9N/32hsYqsYPIrrNViutbYjpOHNTFHEeuP1KdnSiMAdsaKGyj0du
   c=;
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 23 Feb 2022 16:48:05 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg03-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2022 16:48:05 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Wed, 23 Feb 2022 16:48:05 -0800
Received: from [10.48.243.226] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15; Wed, 23 Feb
 2022 16:48:04 -0800
Message-ID: <657eecf0-a5d5-a9c0-2954-dbc865f33a7f@quicinc.com>
Date:   Wed, 23 Feb 2022 16:48:04 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 1/6][next] ath6kl: wmi: Replace one-element array with
 flexible-array member in struct wmi_begin_scan_cmd
Content-Language: en-US
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-hardening@vger.kernel.org>
References: <cover.1645583264.git.gustavoars@kernel.org>
 <af3e7cf6101586a6de9710d8f1302763aa7c6396.1645583264.git.gustavoars@kernel.org>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <af3e7cf6101586a6de9710d8f1302763aa7c6396.1645583264.git.gustavoars@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/22/2022 6:38 PM, Gustavo A. R. Silva wrote:
> Replace one-element array with flexible-array member in struct
> wmi_begin_scan_cmd. Also, make use of the struct_size() helper.
> 
> This issue was found with the help of Coccinelle and audited and fixed,
> manually.
> 
> Link: https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
> Link: https://github.com/KSPP/linux/issues/79
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>   drivers/net/wireless/ath/ath6kl/wmi.c | 9 ++-------
>   drivers/net/wireless/ath/ath6kl/wmi.h | 2 +-
>   2 files changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
> index bd1ef6334997..e1c950014f3e 100644
> --- a/drivers/net/wireless/ath/ath6kl/wmi.c
> +++ b/drivers/net/wireless/ath/ath6kl/wmi.c
> @@ -2008,7 +2008,7 @@ int ath6kl_wmi_beginscan_cmd(struct wmi *wmi, u8 if_idx,
>   	struct ieee80211_supported_band *sband;
>   	struct sk_buff *skb;
>   	struct wmi_begin_scan_cmd *sc;
> -	s8 size, *supp_rates;
> +	s8 *supp_rates;
>   	int i, band, ret;
>   	struct ath6kl *ar = wmi->parent_dev;
>   	int num_rates;
> @@ -2023,18 +2023,13 @@ int ath6kl_wmi_beginscan_cmd(struct wmi *wmi, u8 if_idx,
>   						num_chan, ch_list);
>   	}
>   
> -	size = sizeof(struct wmi_begin_scan_cmd);
> -
>   	if ((scan_type != WMI_LONG_SCAN) && (scan_type != WMI_SHORT_SCAN))
>   		return -EINVAL;
>   
>   	if (num_chan > WMI_MAX_CHANNELS)
>   		return -EINVAL;
>   
> -	if (num_chan)
> -		size += sizeof(u16) * (num_chan - 1);
> -
> -	skb = ath6kl_wmi_get_new_buf(size);
> +	skb = ath6kl_wmi_get_new_buf(struct_size(sc, ch_list, num_chan));
>   	if (!skb)
>   		return -ENOMEM;
>   
> diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
> index 784940ba4c90..322539ed9c12 100644
> --- a/drivers/net/wireless/ath/ath6kl/wmi.h
> +++ b/drivers/net/wireless/ath/ath6kl/wmi.h
> @@ -863,7 +863,7 @@ struct wmi_begin_scan_cmd {
>   	u8 num_ch;
>   
>   	/* channels in Mhz */
> -	__le16 ch_list[1];
> +	__le16 ch_list[];
>   } __packed;
>   
>   /* wmi_start_scan_cmd is to be deprecated. Use



Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
