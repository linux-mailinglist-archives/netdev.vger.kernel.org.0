Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4383801E7
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 04:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhENCZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 22:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbhENCZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 22:25:53 -0400
Received: from mxout012.mail.hostpoint.ch (mxout012.mail.hostpoint.ch [IPv6:2a00:d70:0:e::312])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE322C061574;
        Thu, 13 May 2021 19:24:42 -0700 (PDT)
Received: from [10.0.2.45] (helo=asmtp012.mail.hostpoint.ch)
        by mxout012.mail.hostpoint.ch with esmtp (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1lhNCJ-000H3v-W5; Fri, 14 May 2021 04:05:04 +0200
Received: from [2a02:168:6182:1:4ea5:a8cc:a141:509c] (helo=ryzen2700.home.reto-schneider.ch)
        by asmtp012.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2 (FreeBSD))
        (envelope-from <code@reto-schneider.ch>)
        id 1lhNCJ-000L6T-R5; Fri, 14 May 2021 04:05:03 +0200
X-Authenticated-Sender-Id: reto-schneider@reto-schneider.ch
From:   Reto Schneider <code@reto-schneider.ch>
To:     Jes.Sorensen@gmail.com, linux-wireless@vger.kernel.org,
        pkshih@realtek.com
Cc:     yhchuang@realtek.com, Larry.Finger@lwfinger.net,
        tehuang@realtek.com, reto.schneider@husqvarnagroup.com,
        ccchiu77@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, Chris Chiu <chiu@endlessos.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 3/7] rtl8xxxu: Enable RX STBC by default
Date:   Fri, 14 May 2021 04:04:38 +0200
Message-Id: <20210514020442.946-4-code@reto-schneider.ch>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210514020442.946-1-code@reto-schneider.ch>
References: <a31d9500-73a3-f890-bebd-d0a4014f87da@reto-schneider.ch>
 <20210514020442.946-1-code@reto-schneider.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Chiu <chiu@endlessos.org>

(cherry picked from commit f740aef70abe336c63b9a20c5603402dc90cdfee)
Signed-off-by: Reto Schneider <reto.schneider@husqvarnagroup.com>
---

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 585018383712..d5c53d6dec33 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -6821,6 +6821,8 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 		sband->ht_cap.mcs.rx_mask[1] = 0xff;
 		sband->ht_cap.cap |= IEEE80211_HT_CAP_SGI_40;
 	}
+	/* only one spatial-stream STBC RX supported */
+	sband->ht_cap.cap |= (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
 	sband->ht_cap.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
 	/*
 	 * Some APs will negotiate HT20_40 in a noisy environment leading
-- 
2.29.2

