Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA2157B1AB
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 09:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239026AbiGTHYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 03:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235321AbiGTHYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 03:24:39 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68724675B4
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:24:38 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id s21so16918006pjq.4
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BVWr2Ne6VTTH9qr+tYFWCXZ5JgjelGtMY0FnCgju6Oc=;
        b=I6t4zG33DZ+QufTZxRgN8Vy1T1czojOYfyv3UAY/xHWyCX/rNNZss/ieO5y4HCoC1S
         FrQwF3cxa/Cv3BNTRkl770ijAAB1+zyubneK5DjAgCj7DibkFsRbNyrnlLtj2Xz09Y3z
         tgIO/8GvX7k9rYbetyoY3dwIYf/ggK4EXXzgcI2rj46genWb8BOnEU7wvipQbjICUUJv
         lDoE89bwBpx3TASR0CkxUZHT5wn3T2iMze6LR1BF8viqM2n+eX150kb7SxCvLI49IsNq
         1NyUMNmPhlw9bVJkes+aTbnyQlXbCrvtM5QDRRY3q3FYbCItdNXmasBj69VeguKXcreA
         n1ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BVWr2Ne6VTTH9qr+tYFWCXZ5JgjelGtMY0FnCgju6Oc=;
        b=NOEHnlImY5EMxQQWUm7L0iMG1QHdwCl/t1ErHqjk5KuIrDAtWO8/UPi5SXQ5whVUq4
         2VbhDfwtwkS+jsO5su47JS3kxBwKD6bCxrwIj4S5u0zKhgDbTvz/B966YexE49mpA/sq
         krmNZ4kPvd4VHi4NR+wfZ04E6xOJ+5qJCyaeZvZWMX8Bh7kYEmPIpDXRy8t9H7IguHM2
         V/se47950ns2anRIK30QCwYblr4Y8c1otNGAzabxzy5+PJ2+0YCwAxSOftR0T5LTa8qG
         ymrnvPl8zURJVOwosX7ZkYLii/Rn9UkcOHWm4ZiHT3ZhanP9UBti959C9qy9AnQhkU2W
         KU/w==
X-Gm-Message-State: AJIora/NlZ1AFbM7jd6Wb3y89VIAYNQFADipT86IepayfmiP7EfhXdD+
        GE73EnPtsXkpUTMI/bhB9GKLNFGgR8VVzFLXV1m99w==
X-Google-Smtp-Source: AGRyM1v0wWUwzGy7Ehrr/48UJiVCBIDIpEoOoo6wkrT3wkGBoI7YRIhSmqedXfpZnR7KfupRTFLGDXhTkLbEwN8ZCGY=
X-Received: by 2002:a17:90b:681:b0:1f2:147a:5e55 with SMTP id
 m1-20020a17090b068100b001f2147a5e55mr3751729pjz.159.1658301877841; Wed, 20
 Jul 2022 00:24:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220719143302.2071223-1-bryan.odonoghue@linaro.org> <20220719143302.2071223-5-bryan.odonoghue@linaro.org>
In-Reply-To: <20220719143302.2071223-5-bryan.odonoghue@linaro.org>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Wed, 20 Jul 2022 09:24:01 +0200
Message-ID: <CAMZdPi9MBZQxiybohQT-cK9X6VEgqX1UOiGbba4APaL-dDBO8Q@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] wcn36xx: Add debugfs entry to read firmware
 feature strings
To:     "Bryan O'Donoghue" <bryan.odonoghue@linaro.org>
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jul 2022 at 16:33, Bryan O'Donoghue
<bryan.odonoghue@linaro.org> wrote:
>
> Add in the ability to easily find the firmware feature bits reported in the
> get feature exchange without having to compile-in debug prints.
>
> root@linaro-alip:~# cat /sys/kernel/debug/ieee80211/phy0/wcn36xx/firmware_feat_caps
> MCC
> P2P
> DOT11AC
> SLM_SESSIONIZATION
> DOT11AC_OPMODE
> SAP32STA
> TDLS
> P2P_GO_NOA_DECOUPLE_INIT_SCAN
> WLANACTIVE_OFFLOAD
> BEACON_OFFLOAD
> SCAN_OFFLOAD
> BCN_MISS_OFFLOAD
> STA_POWERSAVE
> STA_ADVANCED_PWRSAVE
> BCN_FILTER
> RTT
> RATECTRL
> WOW
> WLAN_ROAM_SCAN_OFFLOAD
> SPECULATIVE_PS_POLL
> IBSS_HEARTBEAT_OFFLOAD
> WLAN_SCAN_OFFLOAD
> WLAN_PERIODIC_TX_PTRN
> ADVANCE_TDLS
> BATCH_SCAN
> FW_IN_TX_PATH
> EXTENDED_NSOFFLOAD_SLOT
> CH_SWITCH_V1
> HT40_OBSS_SCAN
> UPDATE_CHANNEL_LIST
> WLAN_MCADDR_FLT
> WLAN_CH144
> TDLS_SCAN_COEXISTENCE
> LINK_LAYER_STATS_MEAS
> MU_MIMO
> EXTENDED_SCAN
> DYNAMIC_WMM_PS
> MAC_SPOOFED_SCAN
> FW_STATS
> WPS_PRBRSP_TMPL
> BCN_IE_FLT_DELTA
>
> Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>


Reviewed-by: Loic Poulain <loic.poulain@linaro.org>

> ---
>  drivers/net/wireless/ath/wcn36xx/debug.c | 37 ++++++++++++++++++++++++
>  drivers/net/wireless/ath/wcn36xx/debug.h |  1 +
>  2 files changed, 38 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/debug.c b/drivers/net/wireless/ath/wcn36xx/debug.c
> index 6af306ae41ad..220f338045bd 100644
> --- a/drivers/net/wireless/ath/wcn36xx/debug.c
> +++ b/drivers/net/wireless/ath/wcn36xx/debug.c
> @@ -21,6 +21,7 @@
>  #include "wcn36xx.h"
>  #include "debug.h"
>  #include "pmc.h"
> +#include "firmware.h"
>
>  #ifdef CONFIG_WCN36XX_DEBUGFS
>
> @@ -136,6 +137,40 @@ static const struct file_operations fops_wcn36xx_dump = {
>         .write =       write_file_dump,
>  };
>
> +static ssize_t read_file_firmware_feature_caps(struct file *file,
> +                                              char __user *user_buf,
> +                                              size_t count, loff_t *ppos)
> +{
> +       struct wcn36xx *wcn = file->private_data;
> +       unsigned long page = get_zeroed_page(GFP_KERNEL);
> +       char *p = (char *)page;
> +       int i;
> +       int ret;
> +
> +       if (!p)
> +               return -ENOMEM;
> +
> +       mutex_lock(&wcn->hal_mutex);
> +       for (i = 0; i < MAX_FEATURE_SUPPORTED; i++) {
> +               if (wcn36xx_firmware_get_feat_caps(wcn->fw_feat_caps, i)) {
> +                       p += sprintf(p, "%s\n",
> +                                    wcn36xx_firmware_get_cap_name(i));
> +               }
> +       }
> +       mutex_unlock(&wcn->hal_mutex);
> +
> +       ret = simple_read_from_buffer(user_buf, count, ppos, (char *)page,
> +                                     (unsigned long)p - page);
> +
> +       free_page(page);
> +       return ret;
> +}
> +
> +static const struct file_operations fops_wcn36xx_firmware_feat_caps = {
> +       .open = simple_open,
> +       .read = read_file_firmware_feature_caps,
> +};
> +
>  #define ADD_FILE(name, mode, fop, priv_data)           \
>         do {                                                    \
>                 struct dentry *d;                               \
> @@ -163,6 +198,8 @@ void wcn36xx_debugfs_init(struct wcn36xx *wcn)
>
>         ADD_FILE(bmps_switcher, 0600, &fops_wcn36xx_bmps, wcn);
>         ADD_FILE(dump, 0200, &fops_wcn36xx_dump, wcn);
> +       ADD_FILE(firmware_feat_caps, 0200,
> +                &fops_wcn36xx_firmware_feat_caps, wcn);
>  }
>
>  void wcn36xx_debugfs_exit(struct wcn36xx *wcn)
> diff --git a/drivers/net/wireless/ath/wcn36xx/debug.h b/drivers/net/wireless/ath/wcn36xx/debug.h
> index 46307aa562d3..7116d96e0543 100644
> --- a/drivers/net/wireless/ath/wcn36xx/debug.h
> +++ b/drivers/net/wireless/ath/wcn36xx/debug.h
> @@ -31,6 +31,7 @@ struct wcn36xx_dfs_entry {
>         struct dentry *rootdir;
>         struct wcn36xx_dfs_file file_bmps_switcher;
>         struct wcn36xx_dfs_file file_dump;
> +       struct wcn36xx_dfs_file file_firmware_feat_caps;
>  };
>
>  void wcn36xx_debugfs_init(struct wcn36xx *wcn);
> --
> 2.36.1
>
