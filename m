Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1B5A57B1A5
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 09:22:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238833AbiGTHWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 03:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238630AbiGTHW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 03:22:28 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5C86716A
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:22:26 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id bh13so15643202pgb.4
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8LDGOp671iQ0kfgrJagAlGpEfO7TbRzNx83iNI9lX8Q=;
        b=TAp4dK0jGm5BzWOx8TdCptoVBPC+i+jNVASncewXbcId5n2hdVN3RugCH6xgWDxS1A
         KpBIfbAFshN5hoEzUPnV1718LyjoGJ7dZOcsl00V/u0rmIgOPl2ghHv0dQTl/wcK9uJI
         ALcHO9o6XQ1aEZz6JhDepSf4w+COAaEqexkgL535OpO75SPJRwsbBjQill7Vg26E1c0d
         vVJdB6WlDvA7s2Ff+MyF4RVrZTXG/0Kd3qzEygp2tbRjxOuHkIUKqiujfR5tPOdarlcC
         KpyeP14wgI3P541cZMr96rAmk6ScpoeRqfL/t75zB6nknIt/MLcKph+CSs+G1knLgXWB
         hL6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8LDGOp671iQ0kfgrJagAlGpEfO7TbRzNx83iNI9lX8Q=;
        b=zdHwLw2d5K+cpEbMo6kf7BNLuTlibhIIXu0gZUs9Ye3szSCg+CcqTSkDhyxBDLiQm9
         fRqHAO5A/NAUM72I2JdaT5Df4tcqlZWfSLqttdz8NI8e5Ri3d4Pq8f3KUyGIxQynZzaE
         sDv/yy8RIPcXMsgITjnE5XNT3M1o6p6wWuUyu56uR+bASeCRgyaX5/ROxIodboMnk6Tc
         N+Y8AEV3yrtgT3W65vQRUDBHKo/xxvM3cGm0QOmEbF1iIPXLt4FMx7N+eMrNH6vw/rnf
         OmFCvan3hWpW3r8jhc/WuZH//ttZSESvVuLtWtVwJ02/ZthtnkJE0Md0E8UN1mhjZYDR
         4ZYw==
X-Gm-Message-State: AJIora/l7RW40V72cn2WWmpliI2RQhO7ugzXzLXtoB47uRlzBgmd7B/K
        OGGM2lzWW8SvUKg4I1jMNAAnlsEcmmmfRm6N4Uj5oBRcSGKaaA==
X-Google-Smtp-Source: AGRyM1um3jCH/OSq5HDvA/mPrbnYoMtLqtwsOTexbx+5W2WFQufbJpsWKr/Pg0kr+/tw7IfQ+MeNvfZQWNVUSvmTUGM=
X-Received: by 2002:a05:6a00:2282:b0:52a:e79b:16e4 with SMTP id
 f2-20020a056a00228200b0052ae79b16e4mr37483137pfe.79.1658301745505; Wed, 20
 Jul 2022 00:22:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220719143302.2071223-1-bryan.odonoghue@linaro.org> <20220719143302.2071223-4-bryan.odonoghue@linaro.org>
In-Reply-To: <20220719143302.2071223-4-bryan.odonoghue@linaro.org>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 20 Jul 2022 09:21:49 +0200
Message-ID: <CAMZdPi9VQ5-EhVyTH=zKzbji4vDD8wQuBcGyb5xPynqDysYBeQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] wcn36xx: Move capability bitmap to string
 translation function to firmware.c
To:     "Bryan O'Donoghue" <bryan.odonoghue@linaro.org>
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jul 2022 at 16:33, Bryan O'Donoghue
<bryan.odonoghue@linaro.org> wrote:
>
> Move wcn36xx_get_cap_name() function in main.c into firmware.c as
> wcn36xx_firmware_get_cap_name().
>
> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

> ---
>  drivers/net/wireless/ath/wcn36xx/firmware.c | 75 +++++++++++++++++++
>  drivers/net/wireless/ath/wcn36xx/firmware.h |  2 +
>  drivers/net/wireless/ath/wcn36xx/main.c     | 81 +--------------------
>  3 files changed, 81 insertions(+), 77 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/firmware.c b/drivers/net/wireless/ath/wcn36xx/firmware.c
> index 03b93d2bdcf9..4b7f439e4db5 100644
> --- a/drivers/net/wireless/ath/wcn36xx/firmware.c
> +++ b/drivers/net/wireless/ath/wcn36xx/firmware.c
> @@ -3,6 +3,81 @@
>  #include "wcn36xx.h"
>  #include "firmware.h"
>
> +#define DEFINE(s)[s] = #s
> +
> +static const char * const wcn36xx_firmware_caps_names[] = {
> +       DEFINE(MCC),
> +       DEFINE(P2P),
> +       DEFINE(DOT11AC),
> +       DEFINE(SLM_SESSIONIZATION),
> +       DEFINE(DOT11AC_OPMODE),
> +       DEFINE(SAP32STA),
> +       DEFINE(TDLS),
> +       DEFINE(P2P_GO_NOA_DECOUPLE_INIT_SCAN),
> +       DEFINE(WLANACTIVE_OFFLOAD),
> +       DEFINE(BEACON_OFFLOAD),
> +       DEFINE(SCAN_OFFLOAD),
> +       DEFINE(ROAM_OFFLOAD),
> +       DEFINE(BCN_MISS_OFFLOAD),
> +       DEFINE(STA_POWERSAVE),
> +       DEFINE(STA_ADVANCED_PWRSAVE),
> +       DEFINE(AP_UAPSD),
> +       DEFINE(AP_DFS),
> +       DEFINE(BLOCKACK),
> +       DEFINE(PHY_ERR),
> +       DEFINE(BCN_FILTER),
> +       DEFINE(RTT),
> +       DEFINE(RATECTRL),
> +       DEFINE(WOW),
> +       DEFINE(WLAN_ROAM_SCAN_OFFLOAD),
> +       DEFINE(SPECULATIVE_PS_POLL),
> +       DEFINE(SCAN_SCH),
> +       DEFINE(IBSS_HEARTBEAT_OFFLOAD),
> +       DEFINE(WLAN_SCAN_OFFLOAD),
> +       DEFINE(WLAN_PERIODIC_TX_PTRN),
> +       DEFINE(ADVANCE_TDLS),
> +       DEFINE(BATCH_SCAN),
> +       DEFINE(FW_IN_TX_PATH),
> +       DEFINE(EXTENDED_NSOFFLOAD_SLOT),
> +       DEFINE(CH_SWITCH_V1),
> +       DEFINE(HT40_OBSS_SCAN),
> +       DEFINE(UPDATE_CHANNEL_LIST),
> +       DEFINE(WLAN_MCADDR_FLT),
> +       DEFINE(WLAN_CH144),
> +       DEFINE(NAN),
> +       DEFINE(TDLS_SCAN_COEXISTENCE),
> +       DEFINE(LINK_LAYER_STATS_MEAS),
> +       DEFINE(MU_MIMO),
> +       DEFINE(EXTENDED_SCAN),
> +       DEFINE(DYNAMIC_WMM_PS),
> +       DEFINE(MAC_SPOOFED_SCAN),
> +       DEFINE(BMU_ERROR_GENERIC_RECOVERY),
> +       DEFINE(DISA),
> +       DEFINE(FW_STATS),
> +       DEFINE(WPS_PRBRSP_TMPL),
> +       DEFINE(BCN_IE_FLT_DELTA),
> +       DEFINE(TDLS_OFF_CHANNEL),
> +       DEFINE(RTT3),
> +       DEFINE(MGMT_FRAME_LOGGING),
> +       DEFINE(ENHANCED_TXBD_COMPLETION),
> +       DEFINE(LOGGING_ENHANCEMENT),
> +       DEFINE(EXT_SCAN_ENHANCED),
> +       DEFINE(MEMORY_DUMP_SUPPORTED),
> +       DEFINE(PER_PKT_STATS_SUPPORTED),
> +       DEFINE(EXT_LL_STAT),
> +       DEFINE(WIFI_CONFIG),
> +       DEFINE(ANTENNA_DIVERSITY_SELECTION),
> +};
> +
> +#undef DEFINE
> +
> +const char *wcn36xx_firmware_get_cap_name(enum wcn36xx_firmware_feat_caps x)
> +{
> +       if (x >= ARRAY_SIZE(wcn36xx_firmware_caps_names))
> +               return "UNKNOWN";
> +       return wcn36xx_firmware_caps_names[x];
> +}
> +
>  void wcn36xx_firmware_set_feat_caps(u32 *bitmap,
>                                     enum wcn36xx_firmware_feat_caps cap)
>  {
> diff --git a/drivers/net/wireless/ath/wcn36xx/firmware.h b/drivers/net/wireless/ath/wcn36xx/firmware.h
> index 552c0e9325e1..f991cf959f82 100644
> --- a/drivers/net/wireless/ath/wcn36xx/firmware.h
> +++ b/drivers/net/wireless/ath/wcn36xx/firmware.h
> @@ -78,5 +78,7 @@ int wcn36xx_firmware_get_feat_caps(u32 *bitmap,
>  void wcn36xx_firmware_clear_feat_caps(u32 *bitmap,
>                                       enum wcn36xx_firmware_feat_caps cap);
>
> +const char *wcn36xx_firmware_get_cap_name(enum wcn36xx_firmware_feat_caps x);
> +
>  #endif /* _FIRMWARE_H_ */
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
> index af62911a4659..fec85e89a02f 100644
> --- a/drivers/net/wireless/ath/wcn36xx/main.c
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -193,88 +193,15 @@ static inline u8 get_sta_index(struct ieee80211_vif *vif,
>                sta_priv->sta_index;
>  }
>
> -#define DEFINE(s) [s] = #s
> -
> -static const char * const wcn36xx_caps_names[] = {
> -       DEFINE(MCC),
> -       DEFINE(P2P),
> -       DEFINE(DOT11AC),
> -       DEFINE(SLM_SESSIONIZATION),
> -       DEFINE(DOT11AC_OPMODE),
> -       DEFINE(SAP32STA),
> -       DEFINE(TDLS),
> -       DEFINE(P2P_GO_NOA_DECOUPLE_INIT_SCAN),
> -       DEFINE(WLANACTIVE_OFFLOAD),
> -       DEFINE(BEACON_OFFLOAD),
> -       DEFINE(SCAN_OFFLOAD),
> -       DEFINE(ROAM_OFFLOAD),
> -       DEFINE(BCN_MISS_OFFLOAD),
> -       DEFINE(STA_POWERSAVE),
> -       DEFINE(STA_ADVANCED_PWRSAVE),
> -       DEFINE(AP_UAPSD),
> -       DEFINE(AP_DFS),
> -       DEFINE(BLOCKACK),
> -       DEFINE(PHY_ERR),
> -       DEFINE(BCN_FILTER),
> -       DEFINE(RTT),
> -       DEFINE(RATECTRL),
> -       DEFINE(WOW),
> -       DEFINE(WLAN_ROAM_SCAN_OFFLOAD),
> -       DEFINE(SPECULATIVE_PS_POLL),
> -       DEFINE(SCAN_SCH),
> -       DEFINE(IBSS_HEARTBEAT_OFFLOAD),
> -       DEFINE(WLAN_SCAN_OFFLOAD),
> -       DEFINE(WLAN_PERIODIC_TX_PTRN),
> -       DEFINE(ADVANCE_TDLS),
> -       DEFINE(BATCH_SCAN),
> -       DEFINE(FW_IN_TX_PATH),
> -       DEFINE(EXTENDED_NSOFFLOAD_SLOT),
> -       DEFINE(CH_SWITCH_V1),
> -       DEFINE(HT40_OBSS_SCAN),
> -       DEFINE(UPDATE_CHANNEL_LIST),
> -       DEFINE(WLAN_MCADDR_FLT),
> -       DEFINE(WLAN_CH144),
> -       DEFINE(NAN),
> -       DEFINE(TDLS_SCAN_COEXISTENCE),
> -       DEFINE(LINK_LAYER_STATS_MEAS),
> -       DEFINE(MU_MIMO),
> -       DEFINE(EXTENDED_SCAN),
> -       DEFINE(DYNAMIC_WMM_PS),
> -       DEFINE(MAC_SPOOFED_SCAN),
> -       DEFINE(BMU_ERROR_GENERIC_RECOVERY),
> -       DEFINE(DISA),
> -       DEFINE(FW_STATS),
> -       DEFINE(WPS_PRBRSP_TMPL),
> -       DEFINE(BCN_IE_FLT_DELTA),
> -       DEFINE(TDLS_OFF_CHANNEL),
> -       DEFINE(RTT3),
> -       DEFINE(MGMT_FRAME_LOGGING),
> -       DEFINE(ENHANCED_TXBD_COMPLETION),
> -       DEFINE(LOGGING_ENHANCEMENT),
> -       DEFINE(EXT_SCAN_ENHANCED),
> -       DEFINE(MEMORY_DUMP_SUPPORTED),
> -       DEFINE(PER_PKT_STATS_SUPPORTED),
> -       DEFINE(EXT_LL_STAT),
> -       DEFINE(WIFI_CONFIG),
> -       DEFINE(ANTENNA_DIVERSITY_SELECTION),
> -};
> -
> -#undef DEFINE
> -
> -static const char *wcn36xx_get_cap_name(enum wcn36xx_firmware_feat_caps x)
> -{
> -       if (x >= ARRAY_SIZE(wcn36xx_caps_names))
> -               return "UNKNOWN";
> -       return wcn36xx_caps_names[x];
> -}
> -
>  static void wcn36xx_feat_caps_info(struct wcn36xx *wcn)
>  {
>         int i;
>
>         for (i = 0; i < MAX_FEATURE_SUPPORTED; i++) {
> -               if (wcn36xx_firmware_get_feat_caps(wcn->fw_feat_caps, i))
> -                       wcn36xx_dbg(WCN36XX_DBG_MAC, "FW Cap %s\n", wcn36xx_get_cap_name(i));
> +               if (wcn36xx_firmware_get_feat_caps(wcn->fw_feat_caps, i)) {
> +                       wcn36xx_dbg(WCN36XX_DBG_MAC, "FW Cap %s\n",
> +                                   wcn36xx_firmware_get_cap_name(i));
> +               }
>         }
>  }
>
> --
> 2.36.1
>
