Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C42F391B3F
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 17:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbhEZPMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 11:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbhEZPMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 11:12:15 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0179C061574;
        Wed, 26 May 2021 08:10:42 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id j6so3032848lfr.11;
        Wed, 26 May 2021 08:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=lyvtZRX/XH/VvNRLufsU8achkkoOI2TntlwCm/I7DlU=;
        b=ts2dYT7gAKw6LUpGBBVRcfzqw1F4NYLD58aU2HeHeIudGx6OsTn6zJ0wUlAWxE5STy
         a0WdjZ6J5lE6AXQpyBKqBmzzFcCXQQF0d8rTEWeleSfX8ydHEKPBIQ+iVHjpxnOOQriK
         SSa/AhGMJWzsJkbqvgtLd9plHh8stc9k/NREL37nzZ5aOgddf9DdWHAtbO4SxulRerb7
         CBQEWU7om0f9ArPQ7FqT13ybjgNEkgj0ih6VueNISKFDdZZwHbl08I5e/rmRcj7woR8s
         vBqIAe4d3uhJRWZD25trnlHcPOsHlqLMWwZSPTMV0wla9cdgJMMzvnaQDcfDqo/FUbMj
         NNog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=lyvtZRX/XH/VvNRLufsU8achkkoOI2TntlwCm/I7DlU=;
        b=FX1+Mtw91dztHFec+6ZN3TP1C9GWpbe1Eqco7CySF+Q7pZM56Orgfx4oXiSiPfvULh
         WV6OBFN0YZI/VxU/vE26WIklVLZ/4t/Sf6Btpil7XqNINCRT5Wo3uje0atQcW6vUE6fN
         rDuVaRENOlE0K4vNJFxWe0DFlKt+Ujo61varxUTlGTn+7LITmGyHVpu+FUEyBi0sV/Ph
         9DidTUhPh01rKDUS98P/XJdqnswVqmEyvNuR6ENwPDKsPoOsq2bSdMMhSqP3vCP/3Z/v
         j0/110FHKzXkzH5Ldhh4j1BPK6Pvb5lqTjN3df4lMxvHvmD+ATLIPt9GLaQu4nk6uzQ3
         8Sbw==
X-Gm-Message-State: AOAM533upiZSD9Kb1GbOpmPO0UdeAF3lFpxsoTW70hIRYi/w0227hgps
        jrGD1ST3+y7NGrzQh3f8UZcEzvyehyg=
X-Google-Smtp-Source: ABdhPJyAbpjgMcLwNWOLw3BeKvxyFeMCEDA0aPfyuGQJHbFgjtUC/XBfjVJTLxfq7/lgl2P93cOEMw==
X-Received: by 2002:ac2:5330:: with SMTP id f16mr2532523lfh.592.1622041840572;
        Wed, 26 May 2021 08:10:40 -0700 (PDT)
Received: from [192.168.2.145] (46-138-180-236.dynamic.spd-mgts.ru. [46.138.180.236])
        by smtp.googlemail.com with ESMTPSA id p1sm1751313lfc.131.2021.05.26.08.10.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 08:10:39 -0700 (PDT)
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "brcm80211-dev-list@cypress.com" <brcm80211-dev-list@cypress.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
From:   Dmitry Osipenko <digetx@gmail.com>
Subject: [BUG] brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout (WiFi dies)
Message-ID: <fcf95129-cba7-817d-4bfd-8efaf92f957f@gmail.com>
Date:   Wed, 26 May 2021 18:10:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

After updating to Ubuntu 21.04 I found two problems related to the BRCMF_C_GET_ASSOCLIST using an older BCM4329 SDIO WiFi.

1. The kernel is spammed with:

 ieee80211 phy0: brcmf_cfg80211_dump_station: BRCMF_C_GET_ASSOCLIST unsupported, err=-52
 ieee80211 phy0: brcmf_cfg80211_dump_station: BRCMF_C_GET_ASSOCLIST unsupported, err=-52
 ieee80211 phy0: brcmf_cfg80211_dump_station: BRCMF_C_GET_ASSOCLIST unsupported, err=-52

Which happens apparently due to a newer NetworkManager version that pokes dump_station() periodically. I sent [1] that fixes this noise.

[1] https://patchwork.kernel.org/project/linux-wireless/list/?series=480715

2. The other much worse problem is that WiFi eventually dies now with these errors:

...
 ieee80211 phy0: brcmf_cfg80211_dump_station: BRCMF_C_GET_ASSOCLIST unsupported, err=-52
 brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
 ieee80211 phy0: brcmf_cfg80211_dump_station: BRCMF_C_GET_ASSOCLIST unsupported, err=-110
 ieee80211 phy0: brcmf_proto_bcdc_query_dcmd: brcmf_proto_bcdc_msg failed w/status -110

From this point all firmware calls start to fail with err=-110 and WiFi doesn't work anymore. This problem is reproducible with 5.13-rc and current -next, I haven't checked older kernel versions. Somehow it's worse using a recent -next, WiFi dies quicker.

What's interesting is that I see that there is always a pending signal in brcmf_sdio_dcmd_resp_wait() when timeout happens. It looks like the timeout happens when there is access to a swap partition, which stalls system for a second or two, but this is not 100%. Increasing DCMD_RESP_TIMEOUT doesn't help.

Please let me know if you have any ideas of how to fix this trouble properly or if you need need any more info.

Removing BRCMF_C_GET_ASSOCLIST firmware call entirely from the driver fixes the problem.

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index f4405d7861b6..6327cb38d6ec 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -2886,22 +2886,6 @@ brcmf_cfg80211_dump_station(struct wiphy *wiphy, struct net_device *ndev,
 
 	brcmf_dbg(TRACE, "Enter, idx %d\n", idx);
 
-	if (idx == 0) {
-		cfg->assoclist.count = cpu_to_le32(BRCMF_MAX_ASSOCLIST);
-		err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_ASSOCLIST,
-					     &cfg->assoclist,
-					     sizeof(cfg->assoclist));
-		if (err) {
-			bphy_err(drvr, "BRCMF_C_GET_ASSOCLIST unsupported, err=%d\n",
-				 err);
-			cfg->assoclist.count = 0;
-			return -EOPNOTSUPP;
-		}
-	}
-	if (idx < le32_to_cpu(cfg->assoclist.count)) {
-		memcpy(mac, cfg->assoclist.mac[idx], ETH_ALEN);
-		return brcmf_cfg80211_get_station(wiphy, ndev, mac, sinfo);
-	}
 	return -ENOENT;
 }
 



