Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 813C8D2F9D
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 19:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfJJRbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 13:31:14 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:44586 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfJJRbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 13:31:14 -0400
Received: by mail-qt1-f193.google.com with SMTP id u40so9805364qth.11;
        Thu, 10 Oct 2019 10:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=dOt1vRqdwBYbPI0xl2LwMnQ4qRjMI3wDIKPkiQR4+I4=;
        b=e9Ib4LGiYHwjzCkV+v0J1jcnTquitiq/dmXxW98ZG+ry5DvCSZWlkxr2Gs3BlWePge
         lZAa/w0UueKEdUfXDbi7paBVzu+pxiNGrlrRFj0WAqY3e0pdm92/EE/IzYT9QuRtOYTf
         72HYKnn6e3PYFa/ayrs+zqnYsW1SFXY+3182O7B1CyPK8bZzK3scf+nRvR3gZZEGBWdo
         DKTzHhODrQpgcBIOXaLi5SqyeDznbpvMeFoCqh7x0MRxWEChCkCXSuNTS6NurftJ9Y7i
         aeBZI5jhACwgj4mnDHkNcgGh1W9bZ6V3KePya0bo3WF9sZ+9mTjlDFJ7EYINNuLTf65L
         YvmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=dOt1vRqdwBYbPI0xl2LwMnQ4qRjMI3wDIKPkiQR4+I4=;
        b=jx67v6HSvTP1f6f176kMg6hi6MV+XUl8XPvTgsozsjTVpAAKUK+vOixh9ZzCVBtlgA
         i47WgdDgmCRbuO4t6hu//ZyqscqMpl5SOUhXDH0MG3KyoKTYTWg1UWI66OsVqx27U7ov
         cs1+xyqx3Px28rIYTuVchDUWWZ3sVNxTFPG8+7Wty1IHpdjP3OE3n8JtcMLzQipCpjkM
         oNNPgQXOFAQzBD0NGuDgnbHCm9ZIky+a6Tv2tmwCJFzYOoEN1J9VYzIFXVWaxjWkK/A5
         WTB7mGonpZnM2WvWOs7vJB81ctX9CUHb0Nt+ez9ORTU5FVhMpuwiIyZnxgsa9Wc+PsAh
         QMdA==
X-Gm-Message-State: APjAAAUsGduI67pHQcT0gIEwzJN4JtGXc3yIs+Ds/S+HYfz2U8Y9vzPp
        QKzBFkQQEHK2G00GeiHYgEDmrVWblzo=
X-Google-Smtp-Source: APXvYqz7yOBitRelW2amEc7FwgLAa20BiKph/V7SX1ePdB8fRFoEu9FH78anrkK+8/scaIpVypkJXg==
X-Received: by 2002:aed:2ce7:: with SMTP id g94mr12037265qtd.133.1570728672379;
        Thu, 10 Oct 2019 10:31:12 -0700 (PDT)
Received: from alpha-Inspiron-5480.lan ([170.84.225.105])
        by smtp.gmail.com with ESMTPSA id v23sm3148066qto.89.2019.10.10.10.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 10:31:11 -0700 (PDT)
From:   Ramon Fontes <ramonreisfontes@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, kvalo@codeaurora.org,
        davem@davemloft.net, Ramon Fontes <ramonreisfontes@gmail.com>
Subject: [PATCH] mac80211_hwsim: add support for OCB and more 5Ghz Channels Signed-off-by: Ramon Fontes <ramonreisfontes@gmail.com>
Date:   Thu, 10 Oct 2019 14:30:29 -0300
Message-Id: <20191010173029.8435-1-ramonreisfontes@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---
 drivers/net/wireless/mac80211_hwsim.c | 34 +++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 45c73a6f0..ae41b05e7 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -148,23 +148,25 @@ static const char *hwsim_alpha2s[] = {
 };
 
 static const struct ieee80211_regdomain hwsim_world_regdom_custom_01 = {
-	.n_reg_rules = 4,
+	.n_reg_rules = 5,
 	.alpha2 =  "99",
 	.reg_rules = {
 		REG_RULE(2412-10, 2462+10, 40, 0, 20, 0),
 		REG_RULE(2484-10, 2484+10, 40, 0, 20, 0),
 		REG_RULE(5150-10, 5240+10, 40, 0, 30, 0),
 		REG_RULE(5745-10, 5825+10, 40, 0, 30, 0),
+		REG_RULE(5855-10, 5925+10, 40, 0, 33, 0),
 	}
 };
 
 static const struct ieee80211_regdomain hwsim_world_regdom_custom_02 = {
-	.n_reg_rules = 2,
+	.n_reg_rules = 3,
 	.alpha2 =  "99",
 	.reg_rules = {
 		REG_RULE(2412-10, 2462+10, 40, 0, 20, 0),
 		REG_RULE(5725-10, 5850+10, 40, 0, 30,
 			 NL80211_RRF_NO_IR),
+		REG_RULE(5855-10, 5925+10, 40, 0, 33, 0),
 	}
 };
 
@@ -354,6 +356,24 @@ static const struct ieee80211_channel hwsim_channels_5ghz[] = {
 	CHAN5G(5805), /* Channel 161 */
 	CHAN5G(5825), /* Channel 165 */
 	CHAN5G(5845), /* Channel 169 */
+
+	CHAN5G(5855), /* Channel 171 */
+	CHAN5G(5860), /* Channel 172 */
+	CHAN5G(5865), /* Channel 173 */
+	CHAN5G(5870), /* Channel 174 */
+
+	CHAN5G(5875), /* Channel 175 */
+	CHAN5G(5880), /* Channel 176 */
+	CHAN5G(5885), /* Channel 177 */
+	CHAN5G(5890), /* Channel 178 */
+	CHAN5G(5895), /* Channel 179 */
+	CHAN5G(5900), /* Channel 180 */
+	CHAN5G(5905), /* Channel 181 */
+
+	CHAN5G(5910), /* Channel 182 */
+	CHAN5G(5915), /* Channel 183 */
+	CHAN5G(5920), /* Channel 184 */
+	CHAN5G(5925), /* Channel 185 */
 };
 
 static const struct ieee80211_rate hwsim_rates[] = {
@@ -1550,7 +1570,8 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 
 	if (vif->type != NL80211_IFTYPE_AP &&
 	    vif->type != NL80211_IFTYPE_MESH_POINT &&
-	    vif->type != NL80211_IFTYPE_ADHOC)
+	    vif->type != NL80211_IFTYPE_ADHOC &&
+	    vif->type != NL80211_IFTYPE_OCB)
 		return;
 
 	skb = ieee80211_beacon_get(hw, vif);
@@ -1604,6 +1625,8 @@ mac80211_hwsim_beacon(struct hrtimer *timer)
 }
 
 static const char * const hwsim_chanwidths[] = {
+	[NL80211_CHAN_WIDTH_5] = "ht5",
+	[NL80211_CHAN_WIDTH_10] = "ht10",
 	[NL80211_CHAN_WIDTH_20_NOHT] = "noht",
 	[NL80211_CHAN_WIDTH_20] = "ht20",
 	[NL80211_CHAN_WIDTH_40] = "ht40",
@@ -2723,7 +2746,8 @@ static void mac80211_hwsim_he_capab(struct ieee80211_supported_band *sband)
 	 BIT(NL80211_IFTYPE_P2P_CLIENT) | \
 	 BIT(NL80211_IFTYPE_P2P_GO) | \
 	 BIT(NL80211_IFTYPE_ADHOC) | \
-	 BIT(NL80211_IFTYPE_MESH_POINT))
+	 BIT(NL80211_IFTYPE_MESH_POINT) | \
+	 BIT(NL80211_IFTYPE_OCB))
 
 static int mac80211_hwsim_new_radio(struct genl_info *info,
 				    struct hwsim_new_radio_params *param)
@@ -2847,6 +2871,8 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	} else {
 		data->if_combination.num_different_channels = 1;
 		data->if_combination.radar_detect_widths =
+					BIT(NL80211_CHAN_WIDTH_5) |
+					BIT(NL80211_CHAN_WIDTH_10) |
 					BIT(NL80211_CHAN_WIDTH_20_NOHT) |
 					BIT(NL80211_CHAN_WIDTH_20) |
 					BIT(NL80211_CHAN_WIDTH_40) |
-- 
2.17.1

