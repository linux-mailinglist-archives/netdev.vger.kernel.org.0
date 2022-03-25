Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B744E6CF3
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 04:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356246AbiCYD7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 23:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355687AbiCYD7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 23:59:34 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D35C55AC
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 20:58:00 -0700 (PDT)
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id AFF0F3F6CB
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 03:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1648180678;
        bh=HfhFiSazR5AEpCcSLsKBFtyKGjNGuMH/2Hmmg2fcF54=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=K6eNxOXWTVIg1lw+cpr92g//f2Q779mTD5JEEsvwY9SUVR8JHb05bpnCmE+ILJrnI
         sPMuMKorrqqliTp0zwNtHOFFYJ67ZZzKYCAXXcwk0Na3o6XhPykht34HCzDG5YWtC8
         2GjE29fTSveDao3/kNt3UfzLLwt9WduNCnXy6DQw26jpb5fmJVbbVvF/OI1OPodRlD
         udCEyqJf72/ZcL0JewGk7Ppy0gqHg/oGbmE6lbrYRQEpJjP42/2PW59l2E0c8KuLFN
         lA1sf9GFLSbzEYLPUX/YdtDgH8AuT9E9aTQhG3oGMujt2lqhZV5kizecxqElCJejwO
         C752XSwPyN45w==
Received: by mail-pf1-f197.google.com with SMTP id y4-20020a623204000000b004fad845e9bdso3516392pfy.23
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 20:57:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HfhFiSazR5AEpCcSLsKBFtyKGjNGuMH/2Hmmg2fcF54=;
        b=DukBXdzT7YzYWt4tCvIWpt0uxdbV4gNS/7tX7EeGszrw/Ppj6ZgDPtkS2Fre5FML+g
         cDyt+2bosRAJws5j6RfwKLCoxRp71TWCBSmjWDnQM1FMT5X8oejoTSVeyar2Lura5MmJ
         OPUqkktDauWqnD6Ekgj0nSn3QSePk1bk7qqMcJ+kNZSi64abpV0C5CPqi49X+Z5FNM/Q
         hWCEL3D15cELk/rytCdNuH2dY7xu+bF/bdJewEo9wQnvXeU+4nNuJ9YZnhsXPydtrhVn
         dhmr8kJ8W1H41Ea16KXGZwcZtiZI/RDD/s0eji46kZyuDDmc1tOK9MdzjpiuHrt4kkXH
         irXg==
X-Gm-Message-State: AOAM533OL9ckAXTDFSCShGRjcwD132JMX50azgL87UbAFORgJGqemWhC
        mmc6NwDHeWv1GjzdZAq0fOMNOc8Pwzt5+G3sXxCqQHT/wiTDJE7WlHQyZdeLEOgszZd2N3Ogqve
        rg8N/QoibLtHE1h8Udii6ZqBlYAr2CfEQ5w==
X-Received: by 2002:a63:1e4b:0:b0:381:c48:928b with SMTP id p11-20020a631e4b000000b003810c48928bmr6225530pgm.139.1648180677211;
        Thu, 24 Mar 2022 20:57:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzFFS803gF+q2mgNAsgGNpiwAvXpqSXWcGhWvjVXchMZL//AWHsQKx3HdQP/D0kn2Ktzy9xXg==
X-Received: by 2002:a63:1e4b:0:b0:381:c48:928b with SMTP id p11-20020a631e4b000000b003810c48928bmr6225515pgm.139.1648180676853;
        Thu, 24 Mar 2022 20:57:56 -0700 (PDT)
Received: from localhost.localdomain (2001-b400-e286-bae1-8fdb-11c6-cf63-1f23.emome-ip6.hinet.net. [2001:b400:e286:bae1:8fdb:11c6:cf63:1f23])
        by smtp.gmail.com with ESMTPSA id 21-20020a630115000000b00382a0895661sm3825801pgb.11.2022.03.24.20.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 20:57:56 -0700 (PDT)
From:   Chris Chiu <chris.chiu@canonical.com>
To:     kvalo@kernel.org, Jes.Sorensen@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     code@reto-schneider.ch, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Chiu <chris.chiu@canonical.com>
Subject: [PATCH v3 2/2] rtl8xxxu: fill up txrate info for gen1 chips
Date:   Fri, 25 Mar 2022 11:57:35 +0800
Message-Id: <20220325035735.4745-3-chris.chiu@canonical.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220325035735.4745-1-chris.chiu@canonical.com>
References: <20220325035735.4745-1-chris.chiu@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RTL8188CUS/RTL8192CU(gen1) don't support rate adatptive report hence
no real txrate info can be retrieved. The vendor driver reports the
highest rate in HT capabilities from the IEs to avoid empty txrate.
This commit initiates the txrate information with the highest supported
rate negotiated with AP. The gen2 chip keeps update the txrate from
the rate adaptive reports, and gen1 chips at least have non-NULL txrate
after associated.

Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
---

Changelog:
  v3:
   - Move the rtl8xxxu_legacy_ratetable[] and rtl8xxxu_desc_to_mcsrate()
     to the proper place instead of adding them
     
  v2:
   - Use the 'static const' for rtl8xxxu_legacy_ratetable[]


 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 88 +++++++++++++------
 1 file changed, 59 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index d225a1257530..6d9b5cf01b11 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4473,6 +4473,35 @@ void rtl8xxxu_gen1_init_aggregation(struct rtl8xxxu_priv *priv)
 	priv->rx_buf_aggregation = 1;
 }
 
+static const struct ieee80211_rate rtl8xxxu_legacy_ratetable[] = {
+	{.bitrate = 10, .hw_value = 0x00,},
+	{.bitrate = 20, .hw_value = 0x01,},
+	{.bitrate = 55, .hw_value = 0x02,},
+	{.bitrate = 110, .hw_value = 0x03,},
+	{.bitrate = 60, .hw_value = 0x04,},
+	{.bitrate = 90, .hw_value = 0x05,},
+	{.bitrate = 120, .hw_value = 0x06,},
+	{.bitrate = 180, .hw_value = 0x07,},
+	{.bitrate = 240, .hw_value = 0x08,},
+	{.bitrate = 360, .hw_value = 0x09,},
+	{.bitrate = 480, .hw_value = 0x0a,},
+	{.bitrate = 540, .hw_value = 0x0b,},
+};
+
+static void rtl8xxxu_desc_to_mcsrate(u16 rate, u8 *mcs, u8 *nss)
+{
+	if (rate <= DESC_RATE_54M)
+		return;
+
+	if (rate >= DESC_RATE_MCS0 && rate <= DESC_RATE_MCS15) {
+		if (rate < DESC_RATE_MCS8)
+			*nss = 1;
+		else
+			*nss = 2;
+		*mcs = rate - DESC_RATE_MCS0;
+	}
+}
+
 static void rtl8xxxu_set_basic_rates(struct rtl8xxxu_priv *priv, u32 rate_cfg)
 {
 	struct ieee80211_hw *hw = priv->hw;
@@ -4534,9 +4563,12 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct device *dev = &priv->udev->dev;
 	struct ieee80211_sta *sta;
+	struct rtl8xxxu_ra_report *rarpt;
 	u32 val32;
 	u8 val8;
 
+	rarpt = &priv->ra_report;
+
 	if (changed & BSS_CHANGED_ASSOC) {
 		dev_dbg(dev, "Changed ASSOC: %i!\n", bss_conf->assoc);
 
@@ -4545,6 +4577,10 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		if (bss_conf->assoc) {
 			u32 ramask;
 			int sgi = 0;
+			u8 highest_rate;
+			u8 mcs = 0, nss = 0;
+			u32 bit_rate;
+
 
 			rcu_read_lock();
 			sta = ieee80211_find_sta(vif, bss_conf->bssid);
@@ -4569,6 +4605,29 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 				sgi = 1;
 			rcu_read_unlock();
 
+			highest_rate = fls(ramask) - 1;
+			if (highest_rate < DESC_RATE_MCS0) {
+				rarpt->txrate.legacy =
+				rtl8xxxu_legacy_ratetable[highest_rate].bitrate;
+			} else {
+				rtl8xxxu_desc_to_mcsrate(highest_rate,
+							 &mcs, &nss);
+				rarpt->txrate.flags |= RATE_INFO_FLAGS_MCS;
+
+				rarpt->txrate.mcs = mcs;
+				rarpt->txrate.nss = nss;
+
+				if (sgi) {
+					rarpt->txrate.flags |=
+						RATE_INFO_FLAGS_SHORT_GI;
+				}
+
+				rarpt->txrate.bw |= RATE_INFO_BW_20;
+			}
+			bit_rate = cfg80211_calculate_bitrate(&rarpt->txrate);
+			rarpt->bit_rate = bit_rate;
+			rarpt->desc_rate = highest_rate;
+
 			priv->vif = vif;
 			priv->rssi_level = RTL8XXXU_RATR_STA_INIT;
 
@@ -5419,35 +5478,6 @@ void rtl8723bu_handle_bt_info(struct rtl8xxxu_priv *priv)
 	}
 }
 
-static struct ieee80211_rate rtl8xxxu_legacy_ratetable[] = {
-	{.bitrate = 10, .hw_value = 0x00,},
-	{.bitrate = 20, .hw_value = 0x01,},
-	{.bitrate = 55, .hw_value = 0x02,},
-	{.bitrate = 110, .hw_value = 0x03,},
-	{.bitrate = 60, .hw_value = 0x04,},
-	{.bitrate = 90, .hw_value = 0x05,},
-	{.bitrate = 120, .hw_value = 0x06,},
-	{.bitrate = 180, .hw_value = 0x07,},
-	{.bitrate = 240, .hw_value = 0x08,},
-	{.bitrate = 360, .hw_value = 0x09,},
-	{.bitrate = 480, .hw_value = 0x0a,},
-	{.bitrate = 540, .hw_value = 0x0b,},
-};
-
-static void rtl8xxxu_desc_to_mcsrate(u16 rate, u8 *mcs, u8 *nss)
-{
-	if (rate <= DESC_RATE_54M)
-		return;
-
-	if (rate >= DESC_RATE_MCS0 && rate <= DESC_RATE_MCS15) {
-		if (rate < DESC_RATE_MCS8)
-			*nss = 1;
-		else
-			*nss = 2;
-		*mcs = rate - DESC_RATE_MCS0;
-	}
-}
-
 static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
 {
 	struct rtl8xxxu_priv *priv;
-- 
2.25.1

