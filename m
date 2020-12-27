Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BABA42E2FB9
	for <lists+netdev@lfdr.de>; Sun, 27 Dec 2020 04:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbgL0DMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Dec 2020 22:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbgL0DMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Dec 2020 22:12:53 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D716C0613ED;
        Sat, 26 Dec 2020 19:12:13 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id a13so3658259qvv.0;
        Sat, 26 Dec 2020 19:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PRGhsysYP/LX6p1ks5M2vNgZZsBW+FKqozk0YtIMlDk=;
        b=PyEk7AZXwHbwMFQmFvVKt4UantoLOR/FcyydpFeZe18eNtbB2u9zEvwqRhEsz9sD/L
         MOdQAzKtiNUn+r4Dd6fJkfN1JDYRdZV+lcZgk3Qq+I4yNhGo8HoKxLHvI7uviuTJTk41
         DZyOblWpCzps5dno3/zpfGn3MtmDhYwXxIsUCb5NyzvuagNSlnNEdquhLh1nIidmro3e
         +WT0OoIHbW2PsGTkf0jzz1d38F9cQvYNMcZbTyGHx16VGSHqy1Oow3UufNTRfD7KeXC1
         n6NFgKA/DLaCYppfcYD433QhJgmqfzUIyK6AhGObJYml+9/psrxbWSKUV2UduptWHGeH
         WqXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PRGhsysYP/LX6p1ks5M2vNgZZsBW+FKqozk0YtIMlDk=;
        b=BVaDyw8QAFMnKbMdvdZfJvy7G9tb/lcpHp9YrPlN2Pcw4hlgMPDQ6MsiK5MdWDBheI
         BxcpqVkjc9TdFJz8WUCWt6Qr+NCM+1h133Rg5pc8qBlf4CewV0WJ3EzFipv97QlC3tVm
         w/hNZkBhl8kio5dn7fTi6AeKUb3BlW2dj8of1S3s/GsqSwNKY/g3928u2bXm+Jb4eaD1
         qcwFQ0ETQ7oz/igGY0c4Bn+J2oXaXtt5V/WMfeDYPkKrU7XJvWF7ZFffrEoYNOkiUELh
         7W4kc3ZaF1vf6Ytl/ymY2oYMJzoaavXLUbm6gU7M+2bt0r/M5aI/kqBDAMLt+3ojIGSV
         kGGg==
X-Gm-Message-State: AOAM532bxZNPEMVL8O4w0qaGswCQ20oEm+aBV1HIP0YVl27kJKsRRrxU
        vucEN33hPnPSpkdNROn+xedoXqVCLo6D3A==
X-Google-Smtp-Source: ABdhPJyAaQ4G9wCx964tyzHQgSDZB2d/ZHEd95wvoUF4w8E8NlfjPBKYV1koVHhrzms7BjgvbYP5Lg==
X-Received: by 2002:a0c:e84c:: with SMTP id l12mr42185666qvo.0.1609038731615;
        Sat, 26 Dec 2020 19:12:11 -0800 (PST)
Received: from alpha-Inspiron-5480.192.168.10.1 ([170.84.225.75])
        by smtp.gmail.com with ESMTPSA id p58sm21414461qte.38.2020.12.26.19.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Dec 2020 19:12:10 -0800 (PST)
From:   Ramon Fontes <ramonreisfontes@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, kvalo@codeaurora.org,
        davem@davemloft.net, Ramon Fontes <ramonreisfontes@gmail.com>
Subject: [PATCH] mac80211_hwsim: indicate support for 6GHz (11ax) Advertise 6GHz Capabilities and channels to mac80211.
Date:   Sun, 27 Dec 2020 00:11:55 -0300
Message-Id: <20201227031155.81161-1-ramonreisfontes@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Requires a few fixups to account for missing capabilities to actually
enable 6GHz channels

Signed-off-by: Ramon Fontes <ramonreisfontes@gmail.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 74 ++++++++++++++++++++++++++-
 1 file changed, 73 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 3b3fc7c9c..fa7d4c20d 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -311,6 +311,12 @@ static struct net_device *hwsim_mon; /* global monitor netdev */
 	.hw_value = (_freq), \
 }
 
+#define CHAN6G(_freq) { \
+	.band = NL80211_BAND_6GHZ, \
+	.center_freq = (_freq), \
+	.hw_value = (_freq), \
+}
+
 static const struct ieee80211_channel hwsim_channels_2ghz[] = {
 	CHAN2G(2412), /* Channel 1 */
 	CHAN2G(2417), /* Channel 2 */
@@ -377,6 +383,68 @@ static const struct ieee80211_channel hwsim_channels_5ghz[] = {
 	CHAN5G(5925), /* Channel 185 */
 };
 
+static const struct ieee80211_channel hwsim_channels_6ghz[] = {
+	CHAN6G(5955), /* Channel 1 */
+	CHAN6G(5975), /* Channel 5 */
+	CHAN6G(5995), /* Channel 9 */
+	CHAN6G(6015), /* Channel 13 */
+	CHAN6G(6035), /* Channel 17 */
+	CHAN6G(6055), /* Channel 21 */
+	CHAN6G(6075), /* Channel 25 */
+	CHAN6G(6095), /* Channel 29 */
+	CHAN6G(6115), /* Channel 33 */
+	CHAN6G(6135), /* Channel 37 */
+	CHAN6G(6155), /* Channel 41 */
+	CHAN6G(6175), /* Channel 45 */
+	CHAN6G(6195), /* Channel 49 */
+	CHAN6G(6215), /* Channel 53 */
+	CHAN6G(6235), /* Channel 57 */
+	CHAN6G(6255), /* Channel 61 */
+	CHAN6G(6275), /* Channel 65 */
+	CHAN6G(6295), /* Channel 69 */
+	CHAN6G(6315), /* Channel 73 */
+	CHAN6G(6335), /* Channel 77 */
+	CHAN6G(6355), /* Channel 81 */
+	CHAN6G(6375), /* Channel 85 */
+	CHAN6G(6395), /* Channel 89 */
+	CHAN6G(6415), /* Channel 93 */
+	CHAN6G(6435), /* Channel 97 */
+	CHAN6G(6455), /* Channel 181 */
+	CHAN6G(6475), /* Channel 105 */
+	CHAN6G(6495), /* Channel 109 */
+	CHAN6G(6515), /* Channel 113 */
+	CHAN6G(6535), /* Channel 117 */
+	CHAN6G(6555), /* Channel 121 */
+	CHAN6G(6575), /* Channel 125 */
+	CHAN6G(6595), /* Channel 129 */
+	CHAN6G(6615), /* Channel 133 */
+	CHAN6G(6635), /* Channel 137 */
+	CHAN6G(6655), /* Channel 141 */
+	CHAN6G(6675), /* Channel 145 */
+	CHAN6G(6695), /* Channel 149 */
+	CHAN6G(6715), /* Channel 153 */
+	CHAN6G(6735), /* Channel 157 */
+	CHAN6G(6755), /* Channel 161 */
+	CHAN6G(6775), /* Channel 165 */
+	CHAN6G(6795), /* Channel 169 */
+	CHAN6G(6815), /* Channel 173 */
+	CHAN6G(6835), /* Channel 177 */
+	CHAN6G(6855), /* Channel 181 */
+	CHAN6G(6875), /* Channel 185 */
+	CHAN6G(6895), /* Channel 189 */
+	CHAN6G(6915), /* Channel 193 */
+	CHAN6G(6935), /* Channel 197 */
+	CHAN6G(6955), /* Channel 201 */
+	CHAN6G(6975), /* Channel 205 */
+	CHAN6G(6995), /* Channel 209 */
+	CHAN6G(7015), /* Channel 213 */
+	CHAN6G(7035), /* Channel 217 */
+	CHAN6G(7055), /* Channel 221 */
+	CHAN6G(7075), /* Channel 225 */
+	CHAN6G(7095), /* Channel 229 */
+	CHAN6G(7115), /* Channel 233 */
+};
+
 #define NUM_S1G_CHANS_US 51
 static struct ieee80211_channel hwsim_channels_s1g[NUM_S1G_CHANS_US];
 
@@ -548,6 +616,7 @@ struct mac80211_hwsim_data {
 	struct ieee80211_supported_band bands[NUM_NL80211_BANDS];
 	struct ieee80211_channel channels_2ghz[ARRAY_SIZE(hwsim_channels_2ghz)];
 	struct ieee80211_channel channels_5ghz[ARRAY_SIZE(hwsim_channels_5ghz)];
+	struct ieee80211_channel channels_6ghz[ARRAY_SIZE(hwsim_channels_6ghz)];
 	struct ieee80211_channel channels_s1g[ARRAY_SIZE(hwsim_channels_s1g)];
 	struct ieee80211_rate rates[ARRAY_SIZE(hwsim_rates)];
 	struct ieee80211_iface_combination if_combination;
@@ -578,7 +647,8 @@ struct mac80211_hwsim_data {
 		struct ieee80211_channel *channel;
 		unsigned long next_start, start, end;
 	} survey_data[ARRAY_SIZE(hwsim_channels_2ghz) +
-		      ARRAY_SIZE(hwsim_channels_5ghz)];
+		      ARRAY_SIZE(hwsim_channels_5ghz) +
+		      ARRAY_SIZE(hwsim_channels_6ghz)];
 
 	struct ieee80211_channel *channel;
 	u64 beacon_int	/* beacon interval in us */;
@@ -3149,6 +3219,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 		sizeof(hwsim_channels_2ghz));
 	memcpy(data->channels_5ghz, hwsim_channels_5ghz,
 		sizeof(hwsim_channels_5ghz));
+	memcpy(data->channels_6ghz, hwsim_channels_6ghz,
+		sizeof(hwsim_channels_6ghz));
 	memcpy(data->channels_s1g, hwsim_channels_s1g,
 	       sizeof(hwsim_channels_s1g));
 	memcpy(data->rates, hwsim_rates, sizeof(hwsim_rates));
-- 
2.25.1

