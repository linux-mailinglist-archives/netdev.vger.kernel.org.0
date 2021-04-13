Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B5335D4A4
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 03:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240266AbhDMBGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 21:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239318AbhDMBGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 21:06:43 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1F0C061574;
        Mon, 12 Apr 2021 18:06:25 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id 130so2141595qkm.4;
        Mon, 12 Apr 2021 18:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hVwLckcTsoZ6HK6udwyuD9YVZ7bzQLTeObf78Se6sgk=;
        b=QCzp8x7GFjs4FxDPNwWSJjU6yK4DbyvES3MDI167L9chvXvhp0yLhZQD2fiXsnGKGM
         3i0gsu9rjaEavamxbBBEOlLWQCsnc2xI6rlhSILcsv6asO79PWHNegqkxKzm7He6K1ah
         N+5t9nrIoGNBt5cXvHFyRB0qIgSmiSKeyE9SnVbpzEPa8f6SxUnvnOY3JmWW4Pr3KsiA
         R4EeqpkN+mSkjsmq6DeTpkvjCQ1Mm150tWKaW3zmDyI7yKZ68HIvQO2rbBC/9D0itfhi
         IBX5P1I/5n57m4wKLDLGkOzVZk8zRM4FZk7jKDNigPWhk0DdI88qLFTF5dEG+IrOJb+Y
         r0Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hVwLckcTsoZ6HK6udwyuD9YVZ7bzQLTeObf78Se6sgk=;
        b=m0qyG7vlPMxfHpR36kGdEVBHsbe+dzWT6/osF623pJZ6btpfkv/PsL/p+YATZBgNFt
         KQ+lrHhoql7gc4g6jGUK3bcZLz0FFZUoFVSyXp1ZAV9ED+3e+7Crh0GXtWv0THHklpt9
         kEOVq3U7zzM1zmdKsBZdVMMl8edNm4ylIrZX6jeeQyuaN825/5rLyL7LYX/uuepNbDLV
         u8bqzK8HNpxnusavprHvZvIIb4lcUSOMn72dfDh3WrNOd7pQighmVicJC6Xck88xnaYQ
         jOGL/Q7X3NSgs+xISFcKCm7SvZnDKZmRMdOXvksRTERh+s05nFOeBskOeFCBux3NwjEz
         Fpqw==
X-Gm-Message-State: AOAM533Ilf2fhbhJlrt99R8bYhfZS9J0PRU8eG1QRmZcjDAAPzbUN37S
        oAG0uJ+4KHdjio6FuE7Ljef+bpTR1mF5Yw==
X-Google-Smtp-Source: ABdhPJyuHutyJv2S2u4Q7vlQKIykhN/IxnoF1RdSKx+5d8R0WbEyc3A5hF7OurTjocDwEx8ldFs8PA==
X-Received: by 2002:a05:620a:20db:: with SMTP id f27mr30565654qka.51.1618275983861;
        Mon, 12 Apr 2021 18:06:23 -0700 (PDT)
Received: from localhost.localdomain ([177.89.232.75])
        by smtp.gmail.com with ESMTPSA id q67sm7104459qkb.89.2021.04.12.18.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 18:06:23 -0700 (PDT)
From:   Ramon Fontes <ramonreisfontes@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, kvalo@codeaurora.org,
        davem@davemloft.net, Ramon Fontes <ramonreisfontes@gmail.com>
Subject: [PATCH] mac80211_hwsim: indicate support for 60GHz channels
Date:   Mon, 12 Apr 2021 22:06:13 -0300
Message-Id: <20210413010613.50128-1-ramonreisfontes@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Advertise 60GHz channels to mac80211.
---
 drivers/net/wireless/mac80211_hwsim.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index fa7d4c20d..70d0af475 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -159,6 +159,8 @@ static const struct ieee80211_regdomain hwsim_world_regdom_custom_01 = {
 		REG_RULE(5150-10, 5240+10, 40, 0, 30, 0),
 		REG_RULE(5745-10, 5825+10, 40, 0, 30, 0),
 		REG_RULE(5855-10, 5925+10, 40, 0, 33, 0),
+		/* IEEE 802.11ad (60GHz), channels 1..3 */
+		REG_RULE(56160+2160*1-1080, 56160+2160*3+1080, 2160, 0, 0, 0),
 	}
 };
 
@@ -317,6 +319,12 @@ static struct net_device *hwsim_mon; /* global monitor netdev */
 	.hw_value = (_freq), \
 }
 
+#define CHAN60G(_freq) { \
+        .band = NL80211_BAND_60GHZ, \
+        .center_freq = (_freq), \
+        .hw_value = (_freq), \
+}
+
 static const struct ieee80211_channel hwsim_channels_2ghz[] = {
 	CHAN2G(2412), /* Channel 1 */
 	CHAN2G(2417), /* Channel 2 */
@@ -445,6 +453,13 @@ static const struct ieee80211_channel hwsim_channels_6ghz[] = {
 	CHAN6G(7115), /* Channel 233 */
 };
 
+static const struct ieee80211_channel hwsim_channels_60ghz[] = {
+	CHAN60G(58320), /* Channel 1 */
+	CHAN60G(60480), /* Channel 2 */
+	CHAN60G(62640), /* Channel 3 */
+	CHAN60G(64800), /* Channel 4 */
+};
+
 #define NUM_S1G_CHANS_US 51
 static struct ieee80211_channel hwsim_channels_s1g[NUM_S1G_CHANS_US];
 
@@ -617,6 +632,7 @@ struct mac80211_hwsim_data {
 	struct ieee80211_channel channels_2ghz[ARRAY_SIZE(hwsim_channels_2ghz)];
 	struct ieee80211_channel channels_5ghz[ARRAY_SIZE(hwsim_channels_5ghz)];
 	struct ieee80211_channel channels_6ghz[ARRAY_SIZE(hwsim_channels_6ghz)];
+	struct ieee80211_channel channels_60ghz[ARRAY_SIZE(hwsim_channels_60ghz)];
 	struct ieee80211_channel channels_s1g[ARRAY_SIZE(hwsim_channels_s1g)];
 	struct ieee80211_rate rates[ARRAY_SIZE(hwsim_rates)];
 	struct ieee80211_iface_combination if_combination;
@@ -648,7 +664,8 @@ struct mac80211_hwsim_data {
 		unsigned long next_start, start, end;
 	} survey_data[ARRAY_SIZE(hwsim_channels_2ghz) +
 		      ARRAY_SIZE(hwsim_channels_5ghz) +
-		      ARRAY_SIZE(hwsim_channels_6ghz)];
+		      ARRAY_SIZE(hwsim_channels_6ghz) +
+		      ARRAY_SIZE(hwsim_channels_60ghz)];
 
 	struct ieee80211_channel *channel;
 	u64 beacon_int	/* beacon interval in us */;
@@ -3221,6 +3238,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 		sizeof(hwsim_channels_5ghz));
 	memcpy(data->channels_6ghz, hwsim_channels_6ghz,
 		sizeof(hwsim_channels_6ghz));
+	memcpy(data->channels_60ghz, hwsim_channels_60ghz,
+		sizeof(hwsim_channels_60ghz));
 	memcpy(data->channels_s1g, hwsim_channels_s1g,
 	       sizeof(hwsim_channels_s1g));
 	memcpy(data->rates, hwsim_rates, sizeof(hwsim_rates));
-- 
2.25.1

