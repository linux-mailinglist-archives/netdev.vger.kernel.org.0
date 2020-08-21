Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1D424CE2F
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgHUGqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:46:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgHUGqR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 02:46:17 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5EEA20748;
        Fri, 21 Aug 2020 06:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597992376;
        bh=E8/QKt/psBiZD7V2dq3ByXn++GuY707IyEPgBWV+szQ=;
        h=Date:From:To:Cc:Subject:From;
        b=0rFD/WFXI+/TBHiNQU/T93FRcCh0QW22vFPqQvpF/U2pQ+Xquq9m1332tyabfVFLt
         eqD36Hoe0SBJpiiPBusYgi4Z78S9qHAC/VUWiHEyMv6M4KsJTQ22mkh3ZedJp2s789
         bxowu5jFIfR59e/b0A2k9jxvQG7bd+fpb8K6KpmY=
Date:   Fri, 21 Aug 2020 01:52:04 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] carl9170: Use fallthrough pseudo-keyword
Message-ID: <20200821065204.GA24827@embeddedor>
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
 drivers/net/wireless/ath/carl9170/rx.c | 2 +-
 drivers/net/wireless/ath/carl9170/tx.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index 23ab8a80c18c..908c4c8b7f82 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -766,7 +766,7 @@ static void carl9170_rx_untie_data(struct ar9170 *ar, u8 *buf, int len)
 
 			goto drop;
 		}
-		/* fall through */
+		fallthrough;
 
 	case AR9170_RX_STATUS_MPDU_MIDDLE:
 		/*  These are just data + mac status */
diff --git a/drivers/net/wireless/ath/carl9170/tx.c b/drivers/net/wireless/ath/carl9170/tx.c
index 2407931440ed..8f896e1a6ad6 100644
--- a/drivers/net/wireless/ath/carl9170/tx.c
+++ b/drivers/net/wireless/ath/carl9170/tx.c
@@ -830,12 +830,12 @@ static bool carl9170_tx_rts_check(struct ar9170 *ar,
 	case CARL9170_ERP_AUTO:
 		if (ampdu)
 			break;
-		/* fall through */
+		fallthrough;
 
 	case CARL9170_ERP_MAC80211:
 		if (!(rate->flags & IEEE80211_TX_RC_USE_RTS_CTS))
 			break;
-		/* fall through */
+		fallthrough;
 
 	case CARL9170_ERP_RTS:
 		if (likely(!multi))
@@ -856,7 +856,7 @@ static bool carl9170_tx_cts_check(struct ar9170 *ar,
 	case CARL9170_ERP_MAC80211:
 		if (!(rate->flags & IEEE80211_TX_RC_USE_CTS_PROTECT))
 			break;
-		/* fall through */
+		fallthrough;
 
 	case CARL9170_ERP_CTS:
 		return true;
-- 
2.27.0

