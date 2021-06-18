Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254A43AD3B1
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 22:36:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233828AbhFRUiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 16:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233702AbhFRUiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 16:38:24 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C06C06175F;
        Fri, 18 Jun 2021 13:36:14 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 131so15696709ljj.3;
        Fri, 18 Jun 2021 13:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=3HTz9I8D+4N2bV9p3EcdNQ0xs4XLEY9cd73dl9RCW88=;
        b=HCz+lQdSM4QIoO3BnGk9Y8f/RrX5xiv5npcGdeZtcK6VKTy0bKGVWn8+abUPN+B9S4
         I1jWU/0KYekEtFbhOk87rL5PHaNQ8tbdSdPX778Ba7kPRVpmxL+YAYWMrsUdiCwbDbAK
         o4duwp1MkAyRdA1+bU4dBHEzR8ezHZRHmUDnkFnI2FMA/cw+i1iseNr1KwEprSHBFRJW
         DRy6HMbNZqfEWCfZflu5NDjFqsbWGfL11A+UaPWA5tHMI7jiT7LeljONQzVC9fTL3AR4
         Q68BB/z+WQAIprKMFijHYkJzc9hZGqf5/MQuILUtzrnZyBREoVv2MVfz31Zn6PGGjA3F
         axDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=3HTz9I8D+4N2bV9p3EcdNQ0xs4XLEY9cd73dl9RCW88=;
        b=pJSG9Vhd/h1oWopyzvd+U1CN9b3LnTa7Sugaod3Zt8k+GhJnI4H4h765UuVquvXVzs
         Kyxl7bj6LRb5olubZKkaJBV3IArxv00alfKAVxcHCy1Y6bInMVt04bK/t4aSzi0LGnfX
         DACmxnHpSCJWB0SeRQb+l8A0AI2MnQHEML6Hq6N1bpA/LO68EwxiQ99WvYx1bEKVyRBO
         +kpHSbst203RZDmO64iyo+nBLLvUfY1bbnYk8GM1fQlkPb4VQCIPrnw5MnLq1iQPDujG
         2JGwXCknMQTb/x4e98Uw0hUmd6YtYMCdGqZttdfhRwu9Fc9Zrlrzvk5Lwlhp+tE9L55B
         E0xg==
X-Gm-Message-State: AOAM530dAwjbBJUA2eo4lYzXOPPGzOf31PqdKKfcFxDrviFa20w6hFPi
        xo6BVml9VUJzxaL5rMNFNP5Yd5eIaIo=
X-Google-Smtp-Source: ABdhPJywh+CbFNaUvchQtHi/+J6K5vOEJjGumLQ2mp3r+jzSl6C/FA8oUj9kqvp3jahsIv7AyFwWmQ==
X-Received: by 2002:a2e:3209:: with SMTP id y9mr10842654ljy.254.1624048572954;
        Fri, 18 Jun 2021 13:36:12 -0700 (PDT)
Received: from [192.168.2.145] (94-29-29-31.dynamic.spd-mgts.ru. [94.29.29.31])
        by smtp.googlemail.com with ESMTPSA id w22sm1179618ljg.115.2021.06.18.13.36.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 13:36:12 -0700 (PDT)
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
Subject: [BUG] brcmfmac locks up on resume from suspend
Message-ID: <b853d145-0edf-db0a-ff42-065011f7a149@gmail.com>
Date:   Fri, 18 Jun 2021 23:36:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm getting a hang on resume from suspend using today's next-20210618.
It's tested on Tegra20 Acer A500 that has older BCM4329, but seems the
problem is generic.

There is this line in pstore log:

  ieee80211 phy0: brcmf_netdev_start_xmit: xmit rejected state=0

Steps to reproduce:

1. Boot system
2. Connect WiFi
3. Run "rtcwake -s10 -mmem"

What's interesting is that turning WiFi off/on before suspending makes
resume to work and there are no suspicious messages in KMSG, all further
resumes work too.

This change fixes the hang:

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index db5f8535fdb5..06d16f7776c7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -301,7 +301,6 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct
sk_buff *skb,
 	/* Can the device send data? */
 	if (drvr->bus_if->state != BRCMF_BUS_UP) {
 		bphy_err(drvr, "xmit rejected state=%d\n", drvr->bus_if->state);
-		netif_stop_queue(ndev);
 		dev_kfree_skb(skb);
 		ret = -ENODEV;
 		goto done;
8<---

Comments? Suggestions? Thanks in advance.
