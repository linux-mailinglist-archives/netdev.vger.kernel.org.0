Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1074524CE27
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbgHUGoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:44:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbgHUGoM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 02:44:12 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 636F420732;
        Fri, 21 Aug 2020 06:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597992252;
        bh=4J4qz5B1NZzvGGMmZoiEQ54l//Vbmr1oMNWo4drmq5M=;
        h=Date:From:To:Cc:Subject:From;
        b=rNw/IaiX0g8qJR8b/acDFu/3vybjZMedp75QZKn31toPhPyiIUyGltwhPZ/0AAyts
         GheTV0ujR9JpCE5MjHAaVjo8Noz2eDV3/Ae8QcsKRSSFQfrW4PCLgA3Rf+gUfBKGg6
         mFrUfcTXQ/jjcaxNg0drRi4ke3K0X53oDsj/5saA=
Date:   Fri, 21 Aug 2020 01:49:59 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] rtw88: Use fallthrough pseudo-keyword
Message-ID: <20200821064959.GA23693@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the existing /* fall through */ comments and its variants with
the new pseudo-keyword macro fallthrough[1].

[1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.c | 4 ++--
 drivers/net/wireless/realtek/rtw88/phy.c  | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 54044abf30d7..9d454f0004d2 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -474,10 +474,10 @@ static u8 hw_bw_cap_to_bitamp(u8 bw_cap)
 	case EFUSE_HW_CAP_IGNORE:
 	case EFUSE_HW_CAP_SUPP_BW80:
 		bw |= BIT(RTW_CHANNEL_WIDTH_80);
-		/* fall through */
+		fallthrough;
 	case EFUSE_HW_CAP_SUPP_BW40:
 		bw |= BIT(RTW_CHANNEL_WIDTH_40);
-		/* fall through */
+		fallthrough;
 	default:
 		bw |= BIT(RTW_CHANNEL_WIDTH_20);
 		break;
diff --git a/drivers/net/wireless/realtek/rtw88/phy.c b/drivers/net/wireless/realtek/rtw88/phy.c
index 8d93f3159746..a4a40372b1b0 100644
--- a/drivers/net/wireless/realtek/rtw88/phy.c
+++ b/drivers/net/wireless/realtek/rtw88/phy.c
@@ -1522,7 +1522,7 @@ static u8 rtw_get_channel_group(u8 channel)
 	switch (channel) {
 	default:
 		WARN_ON(1);
-		/* fall through */
+		fallthrough;
 	case 1:
 	case 2:
 	case 36:
@@ -1668,7 +1668,7 @@ static u8 rtw_phy_get_2g_tx_power_index(struct rtw_dev *rtwdev,
 	switch (bandwidth) {
 	default:
 		WARN_ON(1);
-		/* fall through */
+		fallthrough;
 	case RTW_CHANNEL_WIDTH_20:
 		tx_power += pwr_idx_2g->ht_1s_diff.bw20 * factor;
 		if (above_2ss)
@@ -1712,7 +1712,7 @@ static u8 rtw_phy_get_5g_tx_power_index(struct rtw_dev *rtwdev,
 	switch (bandwidth) {
 	default:
 		WARN_ON(1);
-		/* fall through */
+		fallthrough;
 	case RTW_CHANNEL_WIDTH_20:
 		tx_power += pwr_idx_5g->ht_1s_diff.bw20 * factor;
 		if (above_2ss)
-- 
2.27.0

