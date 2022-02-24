Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B60934C39B9
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 00:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234538AbiBXXfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 18:35:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbiBXXfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 18:35:40 -0500
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C352727B98B;
        Thu, 24 Feb 2022 15:35:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1645745709; x=1677281709;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=67rbodiKbgZ1//Kb5zBbPl0kKVD9b/6y8PboHryj2xk=;
  b=W9Fv6vAvxzzL5DkO0mPHv62ArSyYBSZllouNAfVLykVcbDAOnplUSP6+
   /vPvBVHmSJxO1r+lpBjT9mLEcIMTdwIM/s6X+pueCz5RHaipq+IKPFdYF
   P0/uzTYS3Spj3OPoT0kLohC9mt9AmYtmUbTQzeF+Ebm08WuB5fA8/KeC/
   o=;
Received: from ironmsg-lv-alpha.qualcomm.com ([10.47.202.13])
  by alexa-out.qualcomm.com with ESMTP; 24 Feb 2022 15:35:09 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg-lv-alpha.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2022 15:35:08 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.15; Thu, 24 Feb 2022 15:35:08 -0800
Received: from [10.111.182.129] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.15; Thu, 24 Feb
 2022 15:35:08 -0800
Message-ID: <b6cd3d69-12a4-693a-e48f-d769c79fc455@quicinc.com>
Date:   Thu, 24 Feb 2022 15:35:07 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 2/6][next] ath6kl: wmi: Replace one-element array with
 flexible-array member in struct wmi_start_scan_cmd
Content-Language: en-US
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-hardening@vger.kernel.org>
References: <cover.1645736204.git.gustavoars@kernel.org>
 <8b33c6d86a6bd40b5688cf118b4b35850db8d8c7.1645736204.git.gustavoars@kernel.org>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <8b33c6d86a6bd40b5688cf118b4b35850db8d8c7.1645736204.git.gustavoars@kernel.org>
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

On 2/24/2022 1:16 PM, Gustavo A. R. Silva wrote:
> Replace one-element array with flexible-array member in struct
> wmi_start_scan_cmd. Also, make use of the struct_size() helper.
> 
> This issue was found with the help of Coccinelle and audited and fixed,
> manually.
> 
> Link: https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
> Link: https://github.com/KSPP/linux/issues/79
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
> Changes in v2:
>   - None.
> 
>   drivers/net/wireless/ath/ath6kl/wmi.c | 8 +-------
>   drivers/net/wireless/ath/ath6kl/wmi.h | 2 +-
>   2 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
> index e1c950014f3e..bdfc057c5a82 100644
> --- a/drivers/net/wireless/ath/ath6kl/wmi.c
> +++ b/drivers/net/wireless/ath/ath6kl/wmi.c
> @@ -1959,21 +1959,15 @@ static int ath6kl_wmi_startscan_cmd(struct wmi *wmi, u8 if_idx,
>   {
>   	struct sk_buff *skb;
>   	struct wmi_start_scan_cmd *sc;
> -	s8 size;
>   	int i, ret;
>   
> -	size = sizeof(struct wmi_start_scan_cmd);
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
> index 322539ed9c12..9e168752bec2 100644
> --- a/drivers/net/wireless/ath/ath6kl/wmi.h
> +++ b/drivers/net/wireless/ath/ath6kl/wmi.h
> @@ -889,7 +889,7 @@ struct wmi_start_scan_cmd {
>   	u8 num_ch;
>   
>   	/* channels in Mhz */
> -	__le16 ch_list[1];
> +	__le16 ch_list[];
>   } __packed;
>   
>   /*

my e-mail client hung while reviewing v1, so now giving

Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
