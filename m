Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE7A64E5AE9
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 22:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345027AbiCWV4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 17:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241195AbiCWV4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 17:56:53 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB1A8C7E1
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 14:55:22 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id j13so2861683plj.8
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 14:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=squareup.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7VUIv+cvVEj+1EStzu/2W/14lXYR/tbe3LkkDVL5xtM=;
        b=HbV5zSsrm4eCZQ2vLye4VeInQFVOBHpADQefgUnHMvjPxjdECWIep38dj4fMCMpn1w
         1dzrUJiXP6Ga3aNy6IjqbuTIuqQ6zBKPTa/F168pkXvIB+UXa+ACirJZCnM/SymwniKh
         VzBpMNi4aA/bGjNCbanMbru9/ScptPqGY2DSA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7VUIv+cvVEj+1EStzu/2W/14lXYR/tbe3LkkDVL5xtM=;
        b=ECSnQWKzX+4MowPGn0KVyocEJObYAElay+jGViaHLjPTZesSBNF7qZNsRlyv/Qo7z/
         sKn8D3ECWpL3syZIxmzT4RZWcZV+qdC6Y7YZRTzoYbE7YuwHL0kT5AmSaj/POz3ljsXc
         ua/gT2YFmqnbv9aGZBuKVCADU7ZdIZJiFUzdJSBH4HWSqaf8l7Vc/1QhqEIZxm+fgDDU
         oEtYSgLCntTKjTeYNh4P08/8LFtf5j4QbG89vZrdzSsabXHdPnt/BlDpYls/eQBgrNzk
         nCvjSJCfV26LdV0lu9WSRJNGNirlxiZM6CK1QEcWHMe1jp4HKiwvXCTNQDdOgiYyH9q9
         tsDQ==
X-Gm-Message-State: AOAM531Fwml497LjTVGxuM6NbmPpeNXcYbPFllb0ad9iP/cvG9zjRdEi
        rAPa35nXcLmjBpikU5lTfYYPjg==
X-Google-Smtp-Source: ABdhPJx8+bhLdCL9qhzkfR7qb0ptpjWBctNSok1FFUEhMrOnLgitMwygkzGfx3qw0nqYXXbPVYGJzA==
X-Received: by 2002:a17:90b:390c:b0:1c7:9a94:1797 with SMTP id ob12-20020a17090b390c00b001c79a941797mr4798410pjb.221.1648072521312;
        Wed, 23 Mar 2022 14:55:21 -0700 (PDT)
Received: from [172.28.8.20] ([135.84.132.250])
        by smtp.gmail.com with ESMTPSA id d5-20020a056a0024c500b004fae56b2921sm791501pfv.167.2022.03.23.14.55.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 14:55:20 -0700 (PDT)
Message-ID: <49641286-078a-736e-3c75-9e03f38bf4f7@squareup.com>
Date:   Wed, 23 Mar 2022 14:55:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v3] wcn36xx: Implement tx_rate reporting
Content-Language: en-US
To:     Edmond Gagnon <egagnon@squareup.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220318195804.4169686-3-egagnon@squareup.com>
 <20220323214533.1951791-1-egagnon@squareup.com>
From:   Benjamin Li <benl@squareup.com>
In-Reply-To: <20220323214533.1951791-1-egagnon@squareup.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tested on DB410c (WCN3620, 802.11n/2.4GHz only) running firmware
CNSS-PR-2-0-1-2-c1-74-130449-3, also with 5.17.

root@linaro-developer:~# speedtest
Retrieving speedtest.net configuration...
Testing from Square (135.84.132.205)...
Retrieving speedtest.net server list...
Selecting best server based on ping...
Hosted by Open5G Inc. (Atherton, CA) [40.28 km]: 11.828 ms
Testing download speed................................................................................
Download: 3.00 Mbit/s
Testing upload speed......................................................................................................
Upload: 23.69 Mbit/s
root@linaro-developer:~#
root@linaro-developer:~# iw wlan0 link
Connected to 6c:f3:7f:eb:98:21 (on wlan0)
	SSID: SQ-DEVICETEST
	freq: 2412
	RX: 34119054 bytes (37804 packets)
	TX: 32924504 bytes (35073 packets)
	signal: -59 dBm
	rx bitrate: 57.8 MBit/s MCS 5 short GI
	tx bitrate: 58.5 MBit/s MCS 6

	bss flags:	short-preamble short-slot-time
	dtim period:	1
	beacon int:	100

Tested-by: Benjamin Li <benl@squareup.com>

Ben

On 3/23/22 2:45 PM, Edmond Gagnon wrote:
> Currently, the driver reports a tx_rate of 6.0 MBit/s no matter the true
> rate:
> 
> root@linaro-developer:~# iw wlan0 link
> Connected to 6c:f3:7f:eb:9b:92 (on wlan0)
>         SSID: SQ-DEVICETEST
>         freq: 5200
>         RX: 4141 bytes (32 packets)
>         TX: 2082 bytes (15 packets)
>         signal: -77 dBm
>         rx bitrate: 135.0 MBit/s MCS 6 40MHz short GI
>         tx bitrate: 6.0 MBit/s
> 
>         bss flags:      short-slot-time
>         dtim period:    1
>         beacon int:     100
> 
> This patch requests HAL_GLOBAL_CLASS_A_STATS_INFO via a hal_get_stats
> firmware message and reports it via ieee80211_ops::sta_statistics.
> 
> root@linaro-developer:~# iw wlan0 link
> Connected to 6c:f3:7f:eb:73:b2 (on wlan0)
>         SSID: SQ-DEVICETEST
>         freq: 5700
>         RX: 26788094 bytes (19859 packets)
>         TX: 1101376 bytes (12119 packets)
>         signal: -75 dBm
>         rx bitrate: 135.0 MBit/s MCS 6 40MHz short GI
>         tx bitrate: 108.0 MBit/s VHT-MCS 5 40MHz VHT-NSS 1
> 
>         bss flags:      short-slot-time
>         dtim period:    1
>         beacon int:     100
> 
> Tested on MSM8939 with WCN3680B running firmware CNSS-PR-2-0-1-2-c1-00083,
> and verified by sniffing frames over the air with Wireshark to ensure the
> MCS indices match.
> 
> Signed-off-by: Edmond Gagnon <egagnon@squareup.com>
> Reviewed-by: Benjamin Li <benl@squareup.com>
> ---
> 
> Changes in v3:
>  - Refactored to report tx_rate via ieee80211_ops::sta_statistics
>  - Dropped get_sta_index patch
>  - Addressed style comments
> Changes in v2:
>  - Refactored to use existing wcn36xx_hal_get_stats_{req,rsp}_msg structs.
>  - Added more notes about testing.
>  - Reduced reporting interval to 3000msec.
>  - Assorted type and memory safety fixes.
>  - Make wcn36xx_smd_get_stats friendlier to future message implementors.
> 
>  drivers/net/wireless/ath/wcn36xx/hal.h  |  7 +++-
>  drivers/net/wireless/ath/wcn36xx/main.c | 16 +++++++
>  drivers/net/wireless/ath/wcn36xx/smd.c  | 56 +++++++++++++++++++++++++
>  drivers/net/wireless/ath/wcn36xx/smd.h  |  2 +
>  drivers/net/wireless/ath/wcn36xx/txrx.c | 29 +++++++++++++
>  drivers/net/wireless/ath/wcn36xx/txrx.h |  1 +
>  6 files changed, 110 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
> index 2a1db9756fd5..46a49f0a51b3 100644
> --- a/drivers/net/wireless/ath/wcn36xx/hal.h
> +++ b/drivers/net/wireless/ath/wcn36xx/hal.h
> @@ -2626,7 +2626,12 @@ enum tx_rate_info {
>  	HAL_TX_RATE_SGI = 0x8,
>  
>  	/* Rate with Long guard interval */
> -	HAL_TX_RATE_LGI = 0x10
> +	HAL_TX_RATE_LGI = 0x10,
> +
> +	/* VHT rates */
> +	HAL_TX_RATE_VHT20  = 0x20,
> +	HAL_TX_RATE_VHT40  = 0x40,
> +	HAL_TX_RATE_VHT80  = 0x80,
>  };
>  
>  struct ani_global_class_a_stats_info {
> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
> index b545d4b2b8c4..fc76b090c39f 100644
> --- a/drivers/net/wireless/ath/wcn36xx/main.c
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -1400,6 +1400,21 @@ static int wcn36xx_get_survey(struct ieee80211_hw *hw, int idx,
>  	return 0;
>  }
>  
> +static void wcn36xx_sta_statistics(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> +				   struct ieee80211_sta *sta, struct station_info *sinfo)
> +{
> +	struct wcn36xx *wcn;
> +	u8 sta_index;
> +	int status = 0;
> +
> +	wcn = hw->priv;
> +	sta_index = get_sta_index(vif, wcn36xx_sta_to_priv(sta));
> +	status = wcn36xx_smd_get_stats(wcn, sta_index, HAL_GLOBAL_CLASS_A_STATS_INFO, sinfo);
> +
> +	if (status)
> +		wcn36xx_err("wcn36xx_smd_get_stats failed\n");
> +}
> +
>  static const struct ieee80211_ops wcn36xx_ops = {
>  	.start			= wcn36xx_start,
>  	.stop			= wcn36xx_stop,
> @@ -1423,6 +1438,7 @@ static const struct ieee80211_ops wcn36xx_ops = {
>  	.set_rts_threshold	= wcn36xx_set_rts_threshold,
>  	.sta_add		= wcn36xx_sta_add,
>  	.sta_remove		= wcn36xx_sta_remove,
> +	.sta_statistics		= wcn36xx_sta_statistics,
>  	.ampdu_action		= wcn36xx_ampdu_action,
>  #if IS_ENABLED(CONFIG_IPV6)
>  	.ipv6_addr_change	= wcn36xx_ipv6_addr_change,
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index caeb68901326..8f9aa892e5ec 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -2627,6 +2627,61 @@ int wcn36xx_smd_del_ba(struct wcn36xx *wcn, u16 tid, u8 direction, u8 sta_index)
>  	return ret;
>  }
>  
> +int wcn36xx_smd_get_stats(struct wcn36xx *wcn, u8 sta_index, u32 stats_mask,
> +			  struct station_info *sinfo)
> +{
> +	struct wcn36xx_hal_stats_req_msg msg_body;
> +	struct wcn36xx_hal_stats_rsp_msg *rsp;
> +	void *rsp_body;
> +	int ret = 0;
> +
> +	if (stats_mask & ~HAL_GLOBAL_CLASS_A_STATS_INFO) {
> +		wcn36xx_err("stats_mask 0x%x contains unimplemented types\n",
> +			    stats_mask);
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&wcn->hal_mutex);
> +	INIT_HAL_MSG(msg_body, WCN36XX_HAL_GET_STATS_REQ);
> +
> +	msg_body.sta_id = sta_index;
> +	msg_body.stats_mask = stats_mask;
> +
> +	PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> +
> +	ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
> +	if (ret) {
> +		wcn36xx_err("sending hal_get_stats failed\n");
> +		goto out;
> +	}
> +
> +	ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
> +	if (ret) {
> +		wcn36xx_err("hal_get_stats response failed err=%d\n", ret);
> +		goto out;
> +	}
> +
> +	rsp = (struct wcn36xx_hal_stats_rsp_msg *)wcn->hal_buf;
> +	rsp_body = (wcn->hal_buf + sizeof(struct wcn36xx_hal_stats_rsp_msg));
> +
> +	if (rsp->stats_mask != stats_mask) {
> +		wcn36xx_err("stats_mask 0x%x differs from requested 0x%x\n",
> +			    rsp->stats_mask, stats_mask);
> +		goto out;
> +	}
> +
> +	if (rsp->stats_mask & HAL_GLOBAL_CLASS_A_STATS_INFO) {
> +		wcn36xx_process_tx_rate((struct ani_global_class_a_stats_info *)rsp_body,
> +					&sinfo->txrate);
> +		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_BITRATE);
> +		rsp_body += sizeof(struct ani_global_class_a_stats_info);
> +	}
> +out:
> +	mutex_unlock(&wcn->hal_mutex);
> +
> +	return ret;
> +}
> +
>  static int wcn36xx_smd_trigger_ba_rsp(void *buf, int len, struct add_ba_info *ba_info)
>  {
>  	struct wcn36xx_hal_trigger_ba_rsp_candidate *candidate;
> @@ -3316,6 +3371,7 @@ int wcn36xx_smd_rsp_process(struct rpmsg_device *rpdev,
>  	case WCN36XX_HAL_ADD_BA_SESSION_RSP:
>  	case WCN36XX_HAL_ADD_BA_RSP:
>  	case WCN36XX_HAL_DEL_BA_RSP:
> +	case WCN36XX_HAL_GET_STATS_RSP:
>  	case WCN36XX_HAL_TRIGGER_BA_RSP:
>  	case WCN36XX_HAL_UPDATE_CFG_RSP:
>  	case WCN36XX_HAL_JOIN_RSP:
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.h b/drivers/net/wireless/ath/wcn36xx/smd.h
> index 957cfa87fbde..3fd598ac2a27 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.h
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.h
> @@ -138,6 +138,8 @@ int wcn36xx_smd_add_ba_session(struct wcn36xx *wcn,
>  int wcn36xx_smd_add_ba(struct wcn36xx *wcn, u8 session_id);
>  int wcn36xx_smd_del_ba(struct wcn36xx *wcn, u16 tid, u8 direction, u8 sta_index);
>  int wcn36xx_smd_trigger_ba(struct wcn36xx *wcn, u8 sta_index, u16 tid, u16 *ssn);
> +int wcn36xx_smd_get_stats(struct wcn36xx *wcn, u8 sta_index, u32 stats_mask,
> +			  struct station_info *sinfo);
>  
>  int wcn36xx_smd_update_cfg(struct wcn36xx *wcn, u32 cfg_id, u32 value);
>  
> diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.c b/drivers/net/wireless/ath/wcn36xx/txrx.c
> index df749b114568..8da3955995b6 100644
> --- a/drivers/net/wireless/ath/wcn36xx/txrx.c
> +++ b/drivers/net/wireless/ath/wcn36xx/txrx.c
> @@ -699,3 +699,32 @@ int wcn36xx_start_tx(struct wcn36xx *wcn,
>  
>  	return ret;
>  }
> +
> +void wcn36xx_process_tx_rate(struct ani_global_class_a_stats_info *stats, struct rate_info *info)
> +{
> +	/* tx_rate is in units of 500kbps; mac80211 wants them in 100kbps */
> +	if (stats->tx_rate_flags & HAL_TX_RATE_LEGACY)
> +		info->legacy = stats->tx_rate * 5;
> +
> +	info->flags = 0;
> +	info->mcs = stats->mcs_index;
> +	info->nss = 1;
> +
> +	if (stats->tx_rate_flags & (HAL_TX_RATE_HT20 | HAL_TX_RATE_HT40))
> +		info->flags |= RATE_INFO_FLAGS_MCS;
> +
> +	if (stats->tx_rate_flags & (HAL_TX_RATE_VHT20 | HAL_TX_RATE_VHT40 | HAL_TX_RATE_VHT80))
> +		info->flags |= RATE_INFO_FLAGS_VHT_MCS;
> +
> +	if (stats->tx_rate_flags & HAL_TX_RATE_SGI)
> +		info->flags |= RATE_INFO_FLAGS_SHORT_GI;
> +
> +	if (stats->tx_rate_flags & (HAL_TX_RATE_HT20 | HAL_TX_RATE_VHT20))
> +		info->bw = RATE_INFO_BW_20;
> +
> +	if (stats->tx_rate_flags & (HAL_TX_RATE_HT40 | HAL_TX_RATE_VHT40))
> +		info->bw = RATE_INFO_BW_40;
> +
> +	if (stats->tx_rate_flags & HAL_TX_RATE_VHT80)
> +		info->bw = RATE_INFO_BW_80;
> +}
> diff --git a/drivers/net/wireless/ath/wcn36xx/txrx.h b/drivers/net/wireless/ath/wcn36xx/txrx.h
> index b54311ffde9c..fb0d6cabd52b 100644
> --- a/drivers/net/wireless/ath/wcn36xx/txrx.h
> +++ b/drivers/net/wireless/ath/wcn36xx/txrx.h
> @@ -164,5 +164,6 @@ int  wcn36xx_rx_skb(struct wcn36xx *wcn, struct sk_buff *skb);
>  int wcn36xx_start_tx(struct wcn36xx *wcn,
>  		     struct wcn36xx_sta *sta_priv,
>  		     struct sk_buff *skb);
> +void wcn36xx_process_tx_rate(struct ani_global_class_a_stats_info *stats, struct rate_info *info);
>  
>  #endif	/* _TXRX_H_ */
