Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA65457B186
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 09:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbiGTHQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 03:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbiGTHQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 03:16:44 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A9F42AF8
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:16:43 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id d7-20020a17090a564700b001f209736b89so1230706pji.0
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nffhZhJquHEIPduKgsXjWozIicuAMHEDsuZ9FFOzKew=;
        b=baUDuOb4dDg1hifYmvjG6OLqWqRwFNO0PcqFN2faENAkYEqz65Y4TIFed70lj7PdOx
         IRICBAlLVlSD8CmMa6+hWOOopyGheJGiAMz0wWdrxzwKmQa8ZzZMD4bCdRPR7bBa9VML
         uw41Tw0kyLDRUls2/MZSz8KHIZbOsAeGYyrCWasM7XJe/umNlu9dOlj5nXwCpFiqbB2Z
         8ifXUxl41NIej9OWMUaw9nFER6YGOH7tqY4klThWHYRNCb1TZvk7rA4GJLg+yQrsb3ut
         gHBc8Y0cpih6Ru8X3PGAgJgLUWLxzCvevV5q17d2aTH2J/EP87n7v3+/B2zgjiGTP5bE
         Au3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nffhZhJquHEIPduKgsXjWozIicuAMHEDsuZ9FFOzKew=;
        b=pQJQmiX/As5j+W7PgAa4XIJ34gaDRx5/drbu/zauzI+3XgWYs32REot8eZid4s/TUo
         uNLzeEDzbEqvON5GXWGzB3nWX5poTbFxH1GA57Qtq0XMXEfVgBs2Et+QMCYW3ir0DPSf
         kewr+Fll5nrVReFjcrbuyN56YFU1hymIUCumzgu/ZF+fsW9XGf2/+GGBkxKwG0OTKjHL
         YdEbLsntGROoQ3/9MBOAyGIUblDCgd+iAqPELtNvRekQys2oHBlDw4iInQTfzEH9opQg
         SGIyTSHEn0ydx8ff7Ayet6R+rZbWacllyNEs6OumAnQr8KoLV/9ZY0Jsowdnl97/MC4b
         8yAQ==
X-Gm-Message-State: AJIora8ZsfQvxHb/1rHuP9QpwI5C7jH5QD/k/l9n39aH5RDKMF8ePK09
        UO5nyG0MsO0q2+MBuuwDAkB5EW+McH8lxFgPFK8dHg==
X-Google-Smtp-Source: AGRyM1ttsz3QdABX+OyMmdkSnmi25WwX9vGRvLUE5TfeF7agwZMN1MV+f/26/WWHEPlt/A137YG1aB31vMuYUniV96E=
X-Received: by 2002:a17:902:c146:b0:16b:db72:a9bb with SMTP id
 6-20020a170902c14600b0016bdb72a9bbmr36674618plj.51.1658301402337; Wed, 20 Jul
 2022 00:16:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220719143302.2071223-1-bryan.odonoghue@linaro.org> <20220719143302.2071223-3-bryan.odonoghue@linaro.org>
In-Reply-To: <20220719143302.2071223-3-bryan.odonoghue@linaro.org>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 20 Jul 2022 09:16:05 +0200
Message-ID: <CAMZdPi8FZmToCFVi88+qg1b12mkjL4z7iEDgnd_RbAFXEs-sCA@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] wcn36xx: Move firmware feature bit storage to
 dedicated firmware.c file
To:     "Bryan O'Donoghue" <bryan.odonoghue@linaro.org>
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jul 2022 at 16:33, Bryan O'Donoghue
<bryan.odonoghue@linaro.org> wrote:
>
> The naming of the get/set/clear firmware feature capability bits doesn't
> really follow the established namespace pattern of
> wcn36xx_logicalblock_do_something();
>
> The feature bits are accessed by smd.c and main.c. It would be nice to
> display the found feature bits in debugfs. To do so though we should tidy
> up the namespace a bit.
>
> Move the firmware feature exchange API to its own file - firmware.c giving
> us the opportunity to functionally decompose other firmware related
> accessors as appropriate in future.
>
> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

> ---
>  drivers/net/wireless/ath/wcn36xx/Makefile   |  3 +-
>  drivers/net/wireless/ath/wcn36xx/firmware.c | 50 +++++++++++++
>  drivers/net/wireless/ath/wcn36xx/firmware.h | 82 +++++++++++++++++++++
>  drivers/net/wireless/ath/wcn36xx/hal.h      | 68 -----------------
>  drivers/net/wireless/ath/wcn36xx/main.c     |  7 +-
>  drivers/net/wireless/ath/wcn36xx/smd.c      | 57 ++------------
>  drivers/net/wireless/ath/wcn36xx/smd.h      |  3 -
>  7 files changed, 146 insertions(+), 124 deletions(-)
>  create mode 100644 drivers/net/wireless/ath/wcn36xx/firmware.c
>  create mode 100644 drivers/net/wireless/ath/wcn36xx/firmware.h
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/Makefile b/drivers/net/wireless/ath/wcn36xx/Makefile
> index 27413703ad69..26bec795b372 100644
> --- a/drivers/net/wireless/ath/wcn36xx/Makefile
> +++ b/drivers/net/wireless/ath/wcn36xx/Makefile
> @@ -5,6 +5,7 @@ wcn36xx-y +=   main.o \
>                 txrx.o \
>                 smd.o \
>                 pmc.o \
> -               debug.o
> +               debug.o \
> +               firmware.o
>
>  wcn36xx-$(CONFIG_NL80211_TESTMODE) += testmode.o
> diff --git a/drivers/net/wireless/ath/wcn36xx/firmware.c b/drivers/net/wireless/ath/wcn36xx/firmware.c
> new file mode 100644
> index 000000000000..03b93d2bdcf9
> --- /dev/null
> +++ b/drivers/net/wireless/ath/wcn36xx/firmware.c
> @@ -0,0 +1,50 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include "wcn36xx.h"
> +#include "firmware.h"
> +
> +void wcn36xx_firmware_set_feat_caps(u32 *bitmap,
> +                                   enum wcn36xx_firmware_feat_caps cap)
> +{
> +       int arr_idx, bit_idx;
> +
> +       if (cap < 0 || cap > 127) {
> +               wcn36xx_warn("error cap idx %d\n", cap);
> +               return;
> +       }
> +
> +       arr_idx = cap / 32;
> +       bit_idx = cap % 32;
> +       bitmap[arr_idx] |= (1 << bit_idx);
> +}
> +
> +int wcn36xx_firmware_get_feat_caps(u32 *bitmap,
> +                                  enum wcn36xx_firmware_feat_caps cap)
> +{
> +       int arr_idx, bit_idx;
> +
> +       if (cap < 0 || cap > 127) {
> +               wcn36xx_warn("error cap idx %d\n", cap);
> +               return -EINVAL;
> +       }
> +
> +       arr_idx = cap / 32;
> +       bit_idx = cap % 32;
> +
> +       return (bitmap[arr_idx] & (1 << bit_idx)) ? 1 : 0;
> +}
> +
> +void wcn36xx_firmware_clear_feat_caps(u32 *bitmap,
> +                                     enum wcn36xx_firmware_feat_caps cap)
> +{
> +       int arr_idx, bit_idx;
> +
> +       if (cap < 0 || cap > 127) {
> +               wcn36xx_warn("error cap idx %d\n", cap);
> +               return;
> +       }
> +
> +       arr_idx = cap / 32;
> +       bit_idx = cap % 32;
> +       bitmap[arr_idx] &= ~(1 << bit_idx);
> +}
> diff --git a/drivers/net/wireless/ath/wcn36xx/firmware.h b/drivers/net/wireless/ath/wcn36xx/firmware.h
> new file mode 100644
> index 000000000000..552c0e9325e1
> --- /dev/null
> +++ b/drivers/net/wireless/ath/wcn36xx/firmware.h
> @@ -0,0 +1,82 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +
> +#ifndef _FIRMWARE_H_
> +#define _FIRMWARE_H_
> +
> +/* Capability bitmap exchange definitions and macros starts */
> +
> +enum wcn36xx_firmware_feat_caps {
> +       MCC = 0,
> +       P2P = 1,
> +       DOT11AC = 2,
> +       SLM_SESSIONIZATION = 3,
> +       DOT11AC_OPMODE = 4,
> +       SAP32STA = 5,
> +       TDLS = 6,
> +       P2P_GO_NOA_DECOUPLE_INIT_SCAN = 7,
> +       WLANACTIVE_OFFLOAD = 8,
> +       BEACON_OFFLOAD = 9,
> +       SCAN_OFFLOAD = 10,
> +       ROAM_OFFLOAD = 11,
> +       BCN_MISS_OFFLOAD = 12,
> +       STA_POWERSAVE = 13,
> +       STA_ADVANCED_PWRSAVE = 14,
> +       AP_UAPSD = 15,
> +       AP_DFS = 16,
> +       BLOCKACK = 17,
> +       PHY_ERR = 18,
> +       BCN_FILTER = 19,
> +       RTT = 20,
> +       RATECTRL = 21,
> +       WOW = 22,
> +       WLAN_ROAM_SCAN_OFFLOAD = 23,
> +       SPECULATIVE_PS_POLL = 24,
> +       SCAN_SCH = 25,
> +       IBSS_HEARTBEAT_OFFLOAD = 26,
> +       WLAN_SCAN_OFFLOAD = 27,
> +       WLAN_PERIODIC_TX_PTRN = 28,
> +       ADVANCE_TDLS = 29,
> +       BATCH_SCAN = 30,
> +       FW_IN_TX_PATH = 31,
> +       EXTENDED_NSOFFLOAD_SLOT = 32,
> +       CH_SWITCH_V1 = 33,
> +       HT40_OBSS_SCAN = 34,
> +       UPDATE_CHANNEL_LIST = 35,
> +       WLAN_MCADDR_FLT = 36,
> +       WLAN_CH144 = 37,
> +       NAN = 38,
> +       TDLS_SCAN_COEXISTENCE = 39,
> +       LINK_LAYER_STATS_MEAS = 40,
> +       MU_MIMO = 41,
> +       EXTENDED_SCAN = 42,
> +       DYNAMIC_WMM_PS = 43,
> +       MAC_SPOOFED_SCAN = 44,
> +       BMU_ERROR_GENERIC_RECOVERY = 45,
> +       DISA = 46,
> +       FW_STATS = 47,
> +       WPS_PRBRSP_TMPL = 48,
> +       BCN_IE_FLT_DELTA = 49,
> +       TDLS_OFF_CHANNEL = 51,
> +       RTT3 = 52,
> +       MGMT_FRAME_LOGGING = 53,
> +       ENHANCED_TXBD_COMPLETION = 54,
> +       LOGGING_ENHANCEMENT = 55,
> +       EXT_SCAN_ENHANCED = 56,
> +       MEMORY_DUMP_SUPPORTED = 57,
> +       PER_PKT_STATS_SUPPORTED = 58,
> +       EXT_LL_STAT = 60,
> +       WIFI_CONFIG = 61,
> +       ANTENNA_DIVERSITY_SELECTION = 62,
> +
> +       MAX_FEATURE_SUPPORTED = 128,
> +};
> +
> +void wcn36xx_firmware_set_feat_caps(u32 *bitmap,
> +                                   enum wcn36xx_firmware_feat_caps cap);
> +int wcn36xx_firmware_get_feat_caps(u32 *bitmap,
> +                                  enum wcn36xx_firmware_feat_caps cap);
> +void wcn36xx_firmware_clear_feat_caps(u32 *bitmap,
> +                                     enum wcn36xx_firmware_feat_caps cap);
> +
> +#endif /* _FIRMWARE_H_ */
> +
> diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
> index 5e48c97682c2..5c45b23c7880 100644
> --- a/drivers/net/wireless/ath/wcn36xx/hal.h
> +++ b/drivers/net/wireless/ath/wcn36xx/hal.h
> @@ -4758,74 +4758,6 @@ struct wcn36xx_hal_set_power_params_resp {
>         u32 status;
>  } __packed;
>
> -/* Capability bitmap exchange definitions and macros starts */
> -
> -enum wcn36xx_firmware_feat_caps {
> -       MCC = 0,
> -       P2P = 1,
> -       DOT11AC = 2,
> -       SLM_SESSIONIZATION = 3,
> -       DOT11AC_OPMODE = 4,
> -       SAP32STA = 5,
> -       TDLS = 6,
> -       P2P_GO_NOA_DECOUPLE_INIT_SCAN = 7,
> -       WLANACTIVE_OFFLOAD = 8,
> -       BEACON_OFFLOAD = 9,
> -       SCAN_OFFLOAD = 10,
> -       ROAM_OFFLOAD = 11,
> -       BCN_MISS_OFFLOAD = 12,
> -       STA_POWERSAVE = 13,
> -       STA_ADVANCED_PWRSAVE = 14,
> -       AP_UAPSD = 15,
> -       AP_DFS = 16,
> -       BLOCKACK = 17,
> -       PHY_ERR = 18,
> -       BCN_FILTER = 19,
> -       RTT = 20,
> -       RATECTRL = 21,
> -       WOW = 22,
> -       WLAN_ROAM_SCAN_OFFLOAD = 23,
> -       SPECULATIVE_PS_POLL = 24,
> -       SCAN_SCH = 25,
> -       IBSS_HEARTBEAT_OFFLOAD = 26,
> -       WLAN_SCAN_OFFLOAD = 27,
> -       WLAN_PERIODIC_TX_PTRN = 28,
> -       ADVANCE_TDLS = 29,
> -       BATCH_SCAN = 30,
> -       FW_IN_TX_PATH = 31,
> -       EXTENDED_NSOFFLOAD_SLOT = 32,
> -       CH_SWITCH_V1 = 33,
> -       HT40_OBSS_SCAN = 34,
> -       UPDATE_CHANNEL_LIST = 35,
> -       WLAN_MCADDR_FLT = 36,
> -       WLAN_CH144 = 37,
> -       NAN = 38,
> -       TDLS_SCAN_COEXISTENCE = 39,
> -       LINK_LAYER_STATS_MEAS = 40,
> -       MU_MIMO = 41,
> -       EXTENDED_SCAN = 42,
> -       DYNAMIC_WMM_PS = 43,
> -       MAC_SPOOFED_SCAN = 44,
> -       BMU_ERROR_GENERIC_RECOVERY = 45,
> -       DISA = 46,
> -       FW_STATS = 47,
> -       WPS_PRBRSP_TMPL = 48,
> -       BCN_IE_FLT_DELTA = 49,
> -       TDLS_OFF_CHANNEL = 51,
> -       RTT3 = 52,
> -       MGMT_FRAME_LOGGING = 53,
> -       ENHANCED_TXBD_COMPLETION = 54,
> -       LOGGING_ENHANCEMENT = 55,
> -       EXT_SCAN_ENHANCED = 56,
> -       MEMORY_DUMP_SUPPORTED = 57,
> -       PER_PKT_STATS_SUPPORTED = 58,
> -       EXT_LL_STAT = 60,
> -       WIFI_CONFIG = 61,
> -       ANTENNA_DIVERSITY_SELECTION = 62,
> -
> -       MAX_FEATURE_SUPPORTED = 128,
> -};
> -
>  #define WCN36XX_HAL_CAPS_SIZE 4
>
>  struct wcn36xx_hal_feat_caps_msg {
> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
> index efd776b20e60..af62911a4659 100644
> --- a/drivers/net/wireless/ath/wcn36xx/main.c
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -28,6 +28,7 @@
>  #include <net/ipv6.h>
>  #include "wcn36xx.h"
>  #include "testmode.h"
> +#include "firmware.h"
>
>  unsigned int wcn36xx_dbg_mask;
>  module_param_named(debug_mask, wcn36xx_dbg_mask, uint, 0644);
> @@ -272,7 +273,7 @@ static void wcn36xx_feat_caps_info(struct wcn36xx *wcn)
>         int i;
>
>         for (i = 0; i < MAX_FEATURE_SUPPORTED; i++) {
> -               if (get_feat_caps(wcn->fw_feat_caps, i))
> +               if (wcn36xx_firmware_get_feat_caps(wcn->fw_feat_caps, i))
>                         wcn36xx_dbg(WCN36XX_DBG_MAC, "FW Cap %s\n", wcn36xx_get_cap_name(i));
>         }
>  }
> @@ -705,7 +706,7 @@ static int wcn36xx_hw_scan(struct ieee80211_hw *hw,
>  {
>         struct wcn36xx *wcn = hw->priv;
>
> -       if (!get_feat_caps(wcn->fw_feat_caps, SCAN_OFFLOAD)) {
> +       if (!wcn36xx_firmware_get_feat_caps(wcn->fw_feat_caps, SCAN_OFFLOAD)) {
>                 /* fallback to mac80211 software scan */
>                 return 1;
>         }
> @@ -743,7 +744,7 @@ static void wcn36xx_cancel_hw_scan(struct ieee80211_hw *hw,
>         wcn->scan_aborted = true;
>         mutex_unlock(&wcn->scan_lock);
>
> -       if (get_feat_caps(wcn->fw_feat_caps, SCAN_OFFLOAD)) {
> +       if (wcn36xx_firmware_get_feat_caps(wcn->fw_feat_caps, SCAN_OFFLOAD)) {
>                 /* ieee80211_scan_completed will be called on FW scan
>                  * indication */
>                 wcn36xx_smd_stop_hw_scan(wcn);
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index 88ee92be8562..d2a994fee812 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -22,6 +22,7 @@
>  #include <linux/bitops.h>
>  #include <linux/rpmsg.h>
>  #include "smd.h"
> +#include "firmware.h"
>
>  struct wcn36xx_cfg_val {
>         u32 cfg_id;
> @@ -295,7 +296,7 @@ static void wcn36xx_smd_set_sta_vht_params(struct wcn36xx *wcn,
>                 sta_params->vht_capable = sta->deflink.vht_cap.vht_supported;
>                 sta_params->vht_ldpc_enabled =
>                         is_cap_supported(caps, IEEE80211_VHT_CAP_RXLDPC);
> -               if (get_feat_caps(wcn->fw_feat_caps, MU_MIMO)) {
> +               if (wcn36xx_firmware_get_feat_caps(wcn->fw_feat_caps, MU_MIMO)) {
>                         sta_params->vht_tx_mu_beamformee_capable =
>                                 is_cap_supported(caps, IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE);
>                         if (sta_params->vht_tx_mu_beamformee_capable)
> @@ -2431,49 +2432,6 @@ int wcn36xx_smd_dump_cmd_req(struct wcn36xx *wcn, u32 arg1, u32 arg2,
>         return ret;
>  }
>
> -void set_feat_caps(u32 *bitmap, enum wcn36xx_firmware_feat_caps cap)
> -{
> -       int arr_idx, bit_idx;
> -
> -       if (cap < 0 || cap > 127) {
> -               wcn36xx_warn("error cap idx %d\n", cap);
> -               return;
> -       }
> -
> -       arr_idx = cap / 32;
> -       bit_idx = cap % 32;
> -       bitmap[arr_idx] |= (1 << bit_idx);
> -}
> -
> -int get_feat_caps(u32 *bitmap, enum wcn36xx_firmware_feat_caps cap)
> -{
> -       int arr_idx, bit_idx;
> -
> -       if (cap < 0 || cap > 127) {
> -               wcn36xx_warn("error cap idx %d\n", cap);
> -               return -EINVAL;
> -       }
> -
> -       arr_idx = cap / 32;
> -       bit_idx = cap % 32;
> -
> -       return (bitmap[arr_idx] & (1 << bit_idx)) ? 1 : 0;
> -}
> -
> -void clear_feat_caps(u32 *bitmap, enum wcn36xx_firmware_feat_caps cap)
> -{
> -       int arr_idx, bit_idx;
> -
> -       if (cap < 0 || cap > 127) {
> -               wcn36xx_warn("error cap idx %d\n", cap);
> -               return;
> -       }
> -
> -       arr_idx = cap / 32;
> -       bit_idx = cap % 32;
> -       bitmap[arr_idx] &= ~(1 << bit_idx);
> -}
> -
>  int wcn36xx_smd_feature_caps_exchange(struct wcn36xx *wcn)
>  {
>         struct wcn36xx_hal_feat_caps_msg msg_body, *rsp;
> @@ -2482,11 +2440,12 @@ int wcn36xx_smd_feature_caps_exchange(struct wcn36xx *wcn)
>         mutex_lock(&wcn->hal_mutex);
>         INIT_HAL_MSG(msg_body, WCN36XX_HAL_FEATURE_CAPS_EXCHANGE_REQ);
>
> -       set_feat_caps(msg_body.feat_caps, STA_POWERSAVE);
> +       wcn36xx_firmware_set_feat_caps(msg_body.feat_caps, STA_POWERSAVE);
>         if (wcn->rf_id == RF_IRIS_WCN3680) {
> -               set_feat_caps(msg_body.feat_caps, DOT11AC);
> -               set_feat_caps(msg_body.feat_caps, WLAN_CH144);
> -               set_feat_caps(msg_body.feat_caps, ANTENNA_DIVERSITY_SELECTION);
> +               wcn36xx_firmware_set_feat_caps(msg_body.feat_caps, DOT11AC);
> +               wcn36xx_firmware_set_feat_caps(msg_body.feat_caps, WLAN_CH144);
> +               wcn36xx_firmware_set_feat_caps(msg_body.feat_caps,
> +                                              ANTENNA_DIVERSITY_SELECTION);
>         }
>
>         PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
> @@ -3300,7 +3259,7 @@ int wcn36xx_smd_add_beacon_filter(struct wcn36xx *wcn,
>         size_t payload_size;
>         int ret;
>
> -       if (!get_feat_caps(wcn->fw_feat_caps, BCN_FILTER))
> +       if (!wcn36xx_firmware_get_feat_caps(wcn->fw_feat_caps, BCN_FILTER))
>                 return -EOPNOTSUPP;
>
>         mutex_lock(&wcn->hal_mutex);
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.h b/drivers/net/wireless/ath/wcn36xx/smd.h
> index 186dad4fe80e..cf15cde2a364 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.h
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.h
> @@ -125,9 +125,6 @@ int wcn36xx_smd_keep_alive_req(struct wcn36xx *wcn,
>  int wcn36xx_smd_dump_cmd_req(struct wcn36xx *wcn, u32 arg1, u32 arg2,
>                              u32 arg3, u32 arg4, u32 arg5);
>  int wcn36xx_smd_feature_caps_exchange(struct wcn36xx *wcn);
> -void set_feat_caps(u32 *bitmap, enum wcn36xx_firmware_feat_caps cap);
> -int get_feat_caps(u32 *bitmap, enum wcn36xx_firmware_feat_caps cap);
> -void clear_feat_caps(u32 *bitmap, enum wcn36xx_firmware_feat_caps cap);
>
>  int wcn36xx_smd_add_ba_session(struct wcn36xx *wcn,
>                 struct ieee80211_sta *sta,
> --
> 2.36.1
>
