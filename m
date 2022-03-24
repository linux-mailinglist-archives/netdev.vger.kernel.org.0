Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2A7B4E657E
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 15:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351128AbiCXOn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 10:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351216AbiCXOnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 10:43:04 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845D2AA029
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 07:41:31 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id b19so6913014wrh.11
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 07:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=Nkf6HJTCG+OAuqULdufe22oqKualm2SIRycYw6CQ/jg=;
        b=rSw/ho8JqMrlsVZkqkd1VvZH49gGpEa3MnrBx3dKKndUub5bbC+zwNf14RXbfe39j0
         Z+9oW8ewPDZGUbsrcTMcaZ5x7U2ftP+jlMTJ68T/b5PU9XCgAlnewPoWP019p6wX1O2B
         LBSR3G7RI5BDdlrI/kyjCVE27Y9cXHazCsrxrQlkGDJjDvuehpdudVc+f4rxlk7jgNKK
         BxhBO2x8643Y0b3gjTQczhHvrrym0SIxMQqq9yUc10hjJ6Yltmv75atixU3dsQ+8+6oo
         s8Y45CE655Yblt0Zr+Ebg9Arhsxf2VMocFWBY0lilwQkjaKn+qkfVELKxszxUOaS3U7f
         ghrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=Nkf6HJTCG+OAuqULdufe22oqKualm2SIRycYw6CQ/jg=;
        b=TG5uDyCmCg2cmJeQING4FVGJpKfKcDjczOd4k6gJ9BV5LEbUOH22FhVDCBDNeVYk2a
         nlW4CuFjxKdQGp9TRU0EjoBg5+7JZG4l6IFMtxAeZPKM5BccoLKn88lacZAQb5rFvxoI
         ifh8OMc1RZ0QhEljXR7Sd8lD6np7+ChEYicg+KvBzZsidz/qQODHDfIxY+cVr499lfqO
         I0YFXMHKhH4opTIL9UoLdV5EWVSZFfT5RZMypcKKrVtata54TiGysGD7b05t9ySpw86c
         jZfJOo752GdvjYpNidCC4jPST8Xu7CW/say4TNNZwpisAWZyVw5b4Ziw7GiuDCbTlJ5D
         BDpA==
X-Gm-Message-State: AOAM531pdjIL97uOL1rKVhSstezDlLxhMxv8EvdG/VMzhdPkBNCzAVQ5
        Sbo8OvNn+D3XtGaU13yKzR0xfKvGkJBLqQ==
X-Google-Smtp-Source: ABdhPJwwzqAXtbAruSTKmAhmyTNCHeMmcClYZAvh3ysqyqRhXGIuacRT4TVScrg9SJMum5mGtsc1oA==
X-Received: by 2002:a05:6000:18a8:b0:203:eb58:9733 with SMTP id b8-20020a05600018a800b00203eb589733mr4936806wri.151.1648132890014;
        Thu, 24 Mar 2022 07:41:30 -0700 (PDT)
Received: from [192.168.0.162] (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id f11-20020a7bcc0b000000b0037e0c362b6dsm2290487wmh.31.2022.03.24.07.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Mar 2022 07:41:29 -0700 (PDT)
Message-ID: <8c1a9f2f-2000-c5be-0720-38fcea0394a3@linaro.org>
Date:   Thu, 24 Mar 2022 14:41:28 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v3] wcn36xx: Implement tx_rate reporting
Content-Language: en-US
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
To:     Edmond Gagnon <egagnon@squareup.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Benjamin Li <benl@squareup.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220318195804.4169686-3-egagnon@squareup.com>
 <20220323214533.1951791-1-egagnon@squareup.com>
 <9c90300e-ac2d-be53-a7c9-7b00a059204e@nexus-software.ie>
In-Reply-To: <9c90300e-ac2d-be53-a7c9-7b00a059204e@nexus-software.ie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/03/2022 12:42, Bryan O'Donoghue wrote:
> On 23/03/2022 21:45, Edmond Gagnon wrote:
>> Currently, the driver reports a tx_rate of 6.0 MBit/s no matter the true
>> rate:
>>
>> root@linaro-developer:~# iw wlan0 link
>> Connected to 6c:f3:7f:eb:9b:92 (on wlan0)
>>          SSID: SQ-DEVICETEST
>>          freq: 5200
>>          RX: 4141 bytes (32 packets)
>>          TX: 2082 bytes (15 packets)
>>          signal: -77 dBm
>>          rx bitrate: 135.0 MBit/s MCS 6 40MHz short GI
>>          tx bitrate: 6.0 MBit/s
>>
>>          bss flags:      short-slot-time
>>          dtim period:    1
>>          beacon int:     100
>>
>> This patch requests HAL_GLOBAL_CLASS_A_STATS_INFO via a hal_get_stats
>> firmware message and reports it via ieee80211_ops::sta_statistics.
>>
>> root@linaro-developer:~# iw wlan0 link
>> Connected to 6c:f3:7f:eb:73:b2 (on wlan0)
>>          SSID: SQ-DEVICETEST
>>          freq: 5700
>>          RX: 26788094 bytes (19859 packets)
>>          TX: 1101376 bytes (12119 packets)
>>          signal: -75 dBm
>>          rx bitrate: 135.0 MBit/s MCS 6 40MHz short GI
>>          tx bitrate: 108.0 MBit/s VHT-MCS 5 40MHz VHT-NSS 1
>>
>>          bss flags:      short-slot-time
>>          dtim period:    1
>>          beacon int:     100
>>
>> Tested on MSM8939 with WCN3680B running firmware 
>> CNSS-PR-2-0-1-2-c1-00083,
>> and verified by sniffing frames over the air with Wireshark to ensure the
>> MCS indices match.
>>
>> Signed-off-by: Edmond Gagnon <egagnon@squareup.com>
>> Reviewed-by: Benjamin Li <benl@squareup.com>
>> ---
>>
>> Changes in v3:
>>   - Refactored to report tx_rate via ieee80211_ops::sta_statistics
>>   - Dropped get_sta_index patch
>>   - Addressed style comments
>> Changes in v2:
>>   - Refactored to use existing wcn36xx_hal_get_stats_{req,rsp}_msg 
>> structs.
>>   - Added more notes about testing.
>>   - Reduced reporting interval to 3000msec.
>>   - Assorted type and memory safety fixes.
>>   - Make wcn36xx_smd_get_stats friendlier to future message implementors.
>>
>>   drivers/net/wireless/ath/wcn36xx/hal.h  |  7 +++-
>>   drivers/net/wireless/ath/wcn36xx/main.c | 16 +++++++
>>   drivers/net/wireless/ath/wcn36xx/smd.c  | 56 +++++++++++++++++++++++++
>>   drivers/net/wireless/ath/wcn36xx/smd.h  |  2 +
>>   drivers/net/wireless/ath/wcn36xx/txrx.c | 29 +++++++++++++
>>   drivers/net/wireless/ath/wcn36xx/txrx.h |  1 +
>>   6 files changed, 110 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h 
>> b/drivers/net/wireless/ath/wcn36xx/hal.h
>> index 2a1db9756fd5..46a49f0a51b3 100644
>> --- a/drivers/net/wireless/ath/wcn36xx/hal.h
>> +++ b/drivers/net/wireless/ath/wcn36xx/hal.h
>> @@ -2626,7 +2626,12 @@ enum tx_rate_info {
>>       HAL_TX_RATE_SGI = 0x8,
>>       /* Rate with Long guard interval */
>> -    HAL_TX_RATE_LGI = 0x10
>> +    HAL_TX_RATE_LGI = 0x10,
>> +
>> +    /* VHT rates */
>> +    HAL_TX_RATE_VHT20  = 0x20,
>> +    HAL_TX_RATE_VHT40  = 0x40,
>> +    HAL_TX_RATE_VHT80  = 0x80,
>>   };
>>   struct ani_global_class_a_stats_info {
>> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c 
>> b/drivers/net/wireless/ath/wcn36xx/main.c
>> index b545d4b2b8c4..fc76b090c39f 100644
>> --- a/drivers/net/wireless/ath/wcn36xx/main.c
>> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
>> @@ -1400,6 +1400,21 @@ static int wcn36xx_get_survey(struct 
>> ieee80211_hw *hw, int idx,
>>       return 0;
>>   }
>> +static void wcn36xx_sta_statistics(struct ieee80211_hw *hw, struct 
>> ieee80211_vif *vif,
>> +                   struct ieee80211_sta *sta, struct station_info 
>> *sinfo)
> 
> 
> Consider running this through checkpatch.pl and fixing most of the 
> complaints, use your discretion.
> 
> scripts/checkpatch.pl --strict 
> ~/Development/patches/linux/wifi/v3-wcn36xx-Implement-tx_rate-reporting.patch 
> 
> 
> static void wcn36xx_sta_statistics(struct ieee80211_hw *hw,
>                                     struct ieee80211_vif *vif,
>                                     struct ieee80211_sta *sta,
>                                     struct station_info *sinfo)
> 
>> +{
>> +    struct wcn36xx *wcn;
>> +    u8 sta_index;
>> +    int status = 0;
>> +
>> +    wcn = hw->priv;
>> +    sta_index = get_sta_index(vif, wcn36xx_sta_to_priv(sta));
>> +    status = wcn36xx_smd_get_stats(wcn, sta_index, 
>> HAL_GLOBAL_CLASS_A_STATS_INFO, sinfo);
> 
> status = wcn36xx_smd_get_stats(wcn, sta_index,
>                                 HAL_GLOBAL_CLASS_A_STATS_INFO, sinfo);
> 
> 
>> +
>> +    if (status)
>> +        wcn36xx_err("wcn36xx_smd_get_stats failed\n");
>> +}
>> +
>>   static const struct ieee80211_ops wcn36xx_ops = {
>>       .start            = wcn36xx_start,
>>       .stop            = wcn36xx_stop,
>> @@ -1423,6 +1438,7 @@ static const struct ieee80211_ops wcn36xx_ops = {
>>       .set_rts_threshold    = wcn36xx_set_rts_threshold,
>>       .sta_add        = wcn36xx_sta_add,
>>       .sta_remove        = wcn36xx_sta_remove,
>> +    .sta_statistics        = wcn36xx_sta_statistics,
>>       .ampdu_action        = wcn36xx_ampdu_action,
>>   #if IS_ENABLED(CONFIG_IPV6)
>>       .ipv6_addr_change    = wcn36xx_ipv6_addr_change,
>> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c 
>> b/drivers/net/wireless/ath/wcn36xx/smd.c
>> index caeb68901326..8f9aa892e5ec 100644
>> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
>> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
>> @@ -2627,6 +2627,61 @@ int wcn36xx_smd_del_ba(struct wcn36xx *wcn, u16 
>> tid, u8 direction, u8 sta_index)
>>       return ret;
>>   }
>> +int wcn36xx_smd_get_stats(struct wcn36xx *wcn, u8 sta_index, u32 
>> stats_mask,
>> +              struct station_info *sinfo)
>> +{
>> +    struct wcn36xx_hal_stats_req_msg msg_body;
>> +    struct wcn36xx_hal_stats_rsp_msg *rsp;
>          struct ani_global_class_a_stats_info *stats_info;
>> +    void *rsp_body;
>> +    int ret = 0;
>> +
>> +    if (stats_mask & ~HAL_GLOBAL_CLASS_A_STATS_INFO) {
>> +        wcn36xx_err("stats_mask 0x%x contains unimplemented types\n",
>> +                stats_mask);
>> +        return -EINVAL;
>> +    }
>> +
>> +    mutex_lock(&wcn->hal_mutex);
>> +    INIT_HAL_MSG(msg_body, WCN36XX_HAL_GET_STATS_REQ);
>> +
>> +    msg_body.sta_id = sta_index;
>> +    msg_body.stats_mask = stats_mask;
>> +
>> +    PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
>> +
>> +    ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
>> +    if (ret) {
>> +        wcn36xx_err("sending hal_get_stats failed\n");
>> +        goto out;
>> +    }
>> +
>> +    ret = wcn36xx_smd_rsp_status_check(wcn->hal_buf, wcn->hal_rsp_len);
>> +    if (ret) {
>> +        wcn36xx_err("hal_get_stats response failed err=%d\n", ret);
>> +        goto out;
>> +    }
>> +
>> +    rsp = (struct wcn36xx_hal_stats_rsp_msg *)wcn->hal_buf;
>> +    rsp_body = (wcn->hal_buf + sizeof(struct 
>> wcn36xx_hal_stats_rsp_msg));
>> +
>> +    if (rsp->stats_mask != stats_mask) {
>> +        wcn36xx_err("stats_mask 0x%x differs from requested 0x%x\n",
>> +                rsp->stats_mask, stats_mask);
>> +        goto out;
>> +    }
>> +
> If you take a pointer and cast it, then you won't have this very long 
> line with the cast
> 
>          stats_info = (struct ani_global_class_a_stats_info *)rsp_body;
>> +    if (rsp->stats_mask & HAL_GLOBAL_CLASS_A_STATS_INFO) {
>> +        wcn36xx_process_tx_rate((struct ani_global_class_a_stats_info 
>> *)rsp_body,
>> +                    &sinfo->txrate);
>                  wcn36xx_process_tx_rate(stats_info, &sinfo->txrate);
> 
> 
> Other than that LGTM
> 
> Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
