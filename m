Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D814D4ACB3F
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 22:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235715AbiBGV0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 16:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239234AbiBGV0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 16:26:06 -0500
X-Greylist: delayed 122 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 13:26:05 PST
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD76CC0612A4;
        Mon,  7 Feb 2022 13:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1644269165; x=1675805165;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NELx/Iw2FPlY+9g0WgjmwMdN02QQW6LQoTyTGWg6qA4=;
  b=HXNBrsLfmxWvuJ88vagMCObdwufcUC2uzM/iXuBwiADR7jOZWV+bXpiJ
   RyrlTz+I6unCWoG/rOvLUq9AEcvhwq1iQ5mgrVfuj7ZMYbKhHKRHevmdd
   nZORieBT6jF7v023UNhVEQlc8hw6WgTjlGeaLjie+OGYCTsH75LKojmNr
   0=;
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 07 Feb 2022 13:24:02 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg03-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 13:24:02 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.922.19; Mon, 7 Feb 2022 13:24:02 -0800
Received: from [10.48.246.62] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.19; Mon, 7 Feb 2022
 13:24:01 -0800
Message-ID: <258ac12b-9ca3-9b24-30df-148f9df51582@quicinc.com>
Date:   Mon, 7 Feb 2022 13:24:01 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v3 2/2] ath9k: htc: clean up *STAT_* macros
Content-Language: en-US
To:     Pavel Skripkin <paskripkin@gmail.com>,
        <ath9k-devel@qca.qualcomm.com>, <kvalo@kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <toke@toke.dk>,
        <linville@tuxdriver.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <80962aae265995d1cdb724f5362c556d494c7566.1644265120.git.paskripkin@gmail.com>
 <28c83b99b8fea0115ad7fbda7cc93a86468ec50d.1644265120.git.paskripkin@gmail.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <28c83b99b8fea0115ad7fbda7cc93a86468ec50d.1644265120.git.paskripkin@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.49.16.6]
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/7/2022 12:24 PM, Pavel Skripkin wrote:
> I've changed *STAT_* macros a bit in previous patch and I seems like
> they become really unreadable. Align these macros definitions to make
> code cleaner.
> 
> Also fixed following checkpatch warning
> 
> ERROR: Macros with complex values should be enclosed in parentheses
> 
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
> 
> Changes since v2:
> 	- My send-email script forgot, that mailing lists exist.
> 	  Added back all related lists
> 	- Fixed checkpatch warning
> 
> Changes since v1:
> 	- Added this patch
> 
> ---
>   drivers/net/wireless/ath/ath9k/htc.h | 16 ++++++++--------
>   1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
> index 141642e5e00d..b4755e21a501 100644
> --- a/drivers/net/wireless/ath/ath9k/htc.h
> +++ b/drivers/net/wireless/ath/ath9k/htc.h
> @@ -327,14 +327,14 @@ static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
>   }
>   
>   #ifdef CONFIG_ATH9K_HTC_DEBUGFS
> -#define __STAT_SAVE(expr) (hif_dev->htc_handle->drv_priv ? (expr) : 0)
> -#define TX_STAT_INC(c) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
> -#define TX_STAT_ADD(c, a) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
> -#define RX_STAT_INC(c) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
> -#define RX_STAT_ADD(c, a) __STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
> -#define CAB_STAT_INC   priv->debug.tx_stats.cab_queued++
> -
> -#define TX_QSTAT_INC(q) (priv->debug.tx_stats.queue_stats[q]++)
> +#define __STAT_SAVE(expr)	(hif_dev->htc_handle->drv_priv ? (expr) : 0)
> +#define TX_STAT_INC(c)		__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
> +#define TX_STAT_ADD(c, a)	__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
> +#define RX_STAT_INC(c)		__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
> +#define RX_STAT_ADD(c, a)	__STAT_SAVE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
> +#define CAB_STAT_INC		(priv->debug.tx_stats.cab_queued++)
> +
> +#define TX_QSTAT_INC(q)		(priv->debug.tx_stats.queue_stats[q]++)
>   
>   void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
>   			   struct ath_rx_status *rs);

It seems that these macros (both the original and the new) aren't 
following the guidance from the Coding Style which tells us under 
"Things to avoid when using macros" that we should avoid "macros that 
depend on having a local variable with a magic name". Wouldn't these 
macros be "better" is they included the hif_dev/priv as arguments rather 
than being "magic"?
