Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1F84E6CF4
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 04:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353649AbiCYD7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 23:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344660AbiCYD7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 23:59:31 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFF7C55AF
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 20:57:57 -0700 (PDT)
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 9674C3F6C5
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 03:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1648180674;
        bh=sBm+dzND20zvV48a+5lKby5znKuzcId45M5VCBIr4Hk=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=VLLmtYt6o+k0PKfzkW9SWONeLDZryqh0/ZHvob5p4q3G/7Zlg2VhtbUTgj5ZrBCvx
         QMTRCpAn7gvSR9xAjfjcD6CX37jy1VvYB7FdekeE+un2fMt7a1OGMBzphlkR1vTdO0
         +t12SrhkFYvG56U7SZBTTALaLA+Bm6MgbJhVdMRXHXqiEfRpzFkwNgJXo93AANByWa
         b+YQbrcLJRh2B1bu7eijSV96xvkgeJ2Sd9I1hY1pPM7FBB92gXzbMU94lOwmvqZd32
         700iN5j1whoankADdwqbujsmAQ6oCRkgAvbk5hI8JjxySDLeMReGoVci5oeS7brSmg
         as4cTMEqpQF4w==
Received: by mail-pj1-f71.google.com with SMTP id t10-20020a17090a5d8a00b001bed9556134so7822690pji.5
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 20:57:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sBm+dzND20zvV48a+5lKby5znKuzcId45M5VCBIr4Hk=;
        b=L5PjDdIcPObRp2oMmPJVxp+MNJU9PCxVqHwW5gzXId+XsHFsT1jzwjv50PUIrCJk0d
         wd0KOatwkylngTFQX5wJsR0Ahda9riQ5cgLUTkA9oDd7QwzCxE5AHB6UM5x18rQ4Lrxt
         x/B/qP1cihM4whwRjnDEs8iX1vQigf8OrwFYxat4+IG7095dZDNtL4YmdGFg7znui3s3
         ySsb7Vfu1iIGyuLuSzx3EM69wopPDUtFa/KDJDLDpEkv+S3AtZKvn/gCwm/0a2Dr3e+I
         x4liqkHCHdiocbdyHcTxBPnUZSqtIMSbdeO0ZZgxeKMAuJuiLnACLC1GgB7SOcYhiSDQ
         FCWw==
X-Gm-Message-State: AOAM531+c1xcEVMe592R4ehqRbpkxtNRpflItjtx5GOJHmp1tGPoIcbq
        8rZ9Vuv4kZ7CFlxbTYdFweuM7X1TQ+39p+TtqpucKboB/SXnL7efCpLq6xAR+MvHMr2lqTHb2gp
        e8NhYQjTZrJiiqaS9g7ZUYqFczsCLFAd5vA==
X-Received: by 2002:a05:6a00:234f:b0:4fa:f52b:46a1 with SMTP id j15-20020a056a00234f00b004faf52b46a1mr5114521pfj.32.1648180672964;
        Thu, 24 Mar 2022 20:57:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx/IuahQpQ0LUgvUGC1C+LbOiyBqHg4NscrDf4ccSD492uSz6kUcrRNBVv3Md3kTWuzNsvIGw==
X-Received: by 2002:a05:6a00:234f:b0:4fa:f52b:46a1 with SMTP id j15-20020a056a00234f00b004faf52b46a1mr5114500pfj.32.1648180672642;
        Thu, 24 Mar 2022 20:57:52 -0700 (PDT)
Received: from localhost.localdomain (2001-b400-e286-bae1-8fdb-11c6-cf63-1f23.emome-ip6.hinet.net. [2001:b400:e286:bae1:8fdb:11c6:cf63:1f23])
        by smtp.gmail.com with ESMTPSA id 21-20020a630115000000b00382a0895661sm3825801pgb.11.2022.03.24.20.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 20:57:52 -0700 (PDT)
From:   Chris Chiu <chris.chiu@canonical.com>
To:     kvalo@kernel.org, Jes.Sorensen@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     code@reto-schneider.ch, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Chiu <chris.chiu@canonical.com>
Subject: [PATCH v3 1/2] rtl8xxxu: feed antenna information for cfg80211
Date:   Fri, 25 Mar 2022 11:57:34 +0800
Message-Id: <20220325035735.4745-2-chris.chiu@canonical.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220325035735.4745-1-chris.chiu@canonical.com>
References: <20220325035735.4745-1-chris.chiu@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fill up the available TX/RX antenna so the iw commands can show
correct antenna information for different chips.

Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
---
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c    | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 06d59ffb7444..d225a1257530 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -1607,6 +1607,7 @@ static void rtl8xxxu_print_chipinfo(struct rtl8xxxu_priv *priv)
 static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 {
 	struct device *dev = &priv->udev->dev;
+	struct ieee80211_hw *hw = priv->hw;
 	u32 val32, bonding;
 	u16 val16;
 
@@ -1684,6 +1685,9 @@ static int rtl8xxxu_identify_chip(struct rtl8xxxu_priv *priv)
 		priv->has_wifi = 1;
 	}
 
+	hw->wiphy->available_antennas_tx = BIT(priv->tx_paths) - 1;
+	hw->wiphy->available_antennas_rx = BIT(priv->rx_paths) - 1;
+
 	switch (priv->rtl_chip) {
 	case RTL8188E:
 	case RTL8192E:
@@ -4282,6 +4286,17 @@ static void rtl8xxxu_cam_write(struct rtl8xxxu_priv *priv,
 	rtl8xxxu_debug = tmp_debug;
 }
 
+static
+int rtl8xxxu_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant)
+{
+	struct rtl8xxxu_priv *priv = hw->priv;
+
+	*tx_ant = BIT(priv->tx_paths) - 1;
+	*rx_ant = BIT(priv->rx_paths) - 1;
+
+	return 0;
+}
+
 static void rtl8xxxu_sw_scan_start(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif, const u8 *mac)
 {
@@ -6472,6 +6487,7 @@ static const struct ieee80211_ops rtl8xxxu_ops = {
 	.set_key = rtl8xxxu_set_key,
 	.ampdu_action = rtl8xxxu_ampdu_action,
 	.sta_statistics = rtl8xxxu_sta_statistics,
+	.get_antenna = rtl8xxxu_get_antenna,
 };
 
 static int rtl8xxxu_parse_usb(struct rtl8xxxu_priv *priv,
-- 
2.25.1

