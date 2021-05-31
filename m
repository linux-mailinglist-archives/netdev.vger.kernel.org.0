Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8F23957C7
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 11:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbhEaJE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 05:04:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34423 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbhEaJE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 05:04:56 -0400
Received: from 111-240-143-199.dynamic-ip.hinet.net ([111.240.143.199] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <chris.chiu@canonical.com>)
        id 1lndpI-0004qd-Hx; Mon, 31 May 2021 09:03:13 +0000
From:   chris.chiu@canonical.com
To:     Jes.Sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     code@reto-schneider.ch, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Chiu <chris.chiu@canonical.com>
Subject: [PATCH 1/2] rtl8xxxu: unset the hw capability HAS_RATE_CONTROL
Date:   Mon, 31 May 2021 17:02:53 +0800
Message-Id: <20210531090254.86830-2-chris.chiu@canonical.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210531090254.86830-1-chris.chiu@canonical.com>
References: <20210531090254.86830-1-chris.chiu@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Chiu <chris.chiu@canonical.com>

The HAS_RATE_CONTROL hw capability needs to be unset for the rate
control of mac80211 to work. Since the ieee80211_start_tx_ba_session
is started by the method .get_rate of rate_control_ops. We need to
unset it so the ampdu can be handled by mac80211.

Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 9ff09cf7eb62..4cf13d2f86b1 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -6678,7 +6678,6 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 	/*
 	 * The firmware handles rate control
 	 */
-	ieee80211_hw_set(hw, HAS_RATE_CONTROL);
 	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
 
 	wiphy_ext_feature_set(hw->wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
-- 
2.20.1

