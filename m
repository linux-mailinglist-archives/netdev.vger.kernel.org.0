Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAC822F959
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 21:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbgG0TpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 15:45:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgG0TpS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 15:45:18 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A189C20672;
        Mon, 27 Jul 2020 19:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595879118;
        bh=8p/mpBOD8QPWQP7hYQ4q+7NKUEkDaVHRM+uqJ5CVEtY=;
        h=Date:From:To:Cc:Subject:From;
        b=vwB3CVZJLOdBJmWAb7lI6QKfZB364JXIg1GW9NEBSecO7u5S8lNvkT0Rw0QR9go4o
         1NrYuVy4c8N654v52Dh8djZmLqHI9rizTV7EvC8p7zBxjDnKNeWXNkV3sr88qZu/Ni
         6HyX18T+LESDoPUr6ng+QbwgAAR/Txz2Z+ubhG5E=
Date:   Mon, 27 Jul 2020 14:51:11 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] ath6kl: Use fallthrough pseudo-keyword
Message-ID: <20200727195111.GA1603@embeddedor>
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
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 6 +++---
 drivers/net/wireless/ath/ath6kl/main.c     | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 67f8f2aa7a53..9c83e9a4299b 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3897,19 +3897,19 @@ int ath6kl_cfg80211_init(struct ath6kl *ar)
 	switch (ar->hw.cap) {
 	case WMI_11AN_CAP:
 		ht = true;
-		/* fall through */
+		fallthrough;
 	case WMI_11A_CAP:
 		band_5gig = true;
 		break;
 	case WMI_11GN_CAP:
 		ht = true;
-		/* fall through */
+		fallthrough;
 	case WMI_11G_CAP:
 		band_2gig = true;
 		break;
 	case WMI_11AGN_CAP:
 		ht = true;
-		/* fall through */
+		fallthrough;
 	case WMI_11AG_CAP:
 		band_2gig = true;
 		band_5gig = true;
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 5e7ea838a921..210218298e13 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -389,7 +389,7 @@ void ath6kl_connect_ap_mode_bss(struct ath6kl_vif *vif, u16 channel)
 		if (!ik->valid || ik->key_type != WAPI_CRYPT)
 			break;
 		/* for WAPI, we need to set the delayed group key, continue: */
-		/* fall through */
+		fallthrough;
 	case WPA_PSK_AUTH:
 	case WPA2_PSK_AUTH:
 	case (WPA_PSK_AUTH | WPA2_PSK_AUTH):
-- 
2.27.0

