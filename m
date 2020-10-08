Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B28287E77
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 00:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgJHWDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 18:03:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:54580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbgJHWDm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 18:03:42 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 666E022241;
        Thu,  8 Oct 2020 22:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602194622;
        bh=AeT6tduvvnK32DuXyUelUNi0j2jvtQ1WF3gbVAximcE=;
        h=Date:From:To:Cc:Subject:From;
        b=dvud6lF9LsqMei3QC5ri01tEoAWoj0IANTB2ZNNDLbbikORBHnrb1ro086cGhFRmR
         FZ+GbB3AaArn/pcPgSUaC/p3YSnzxz9uM81CxIa4lAmycsRdGoCDY7CcnYR1yBdDXJ
         SR9/2ZCmk0KYnasJuNw9lK2onWz/93pdE3rGcrg0=
Date:   Thu, 8 Oct 2020 17:09:05 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] wlcore: Use fallthrough pseudo-keyword
Message-ID: <20201008220905.GA8040@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to enable -Wimplicit-fallthrough for Clang[1], replace the
existing /* fall-through */ comments with the new pseudo-keyword
macro fallthrough[2].

[1] https://git.kernel.org/linus/e2079e93f562c7f7a030eb7642017ee5eabaaa10
[2] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/ti/wlcore/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 6863fd552d5e..122c7a4b374f 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2227,7 +2227,7 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 	switch (ieee80211_vif_type_p2p(vif)) {
 	case NL80211_IFTYPE_P2P_CLIENT:
 		wlvif->p2p = 1;
-		/* fall-through */
+		fallthrough;
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_DEVICE:
 		wlvif->bss_type = BSS_TYPE_STA_BSS;
@@ -2237,7 +2237,7 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 		break;
 	case NL80211_IFTYPE_P2P_GO:
 		wlvif->p2p = 1;
-		/* fall-through */
+		fallthrough;
 	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_MESH_POINT:
 		wlvif->bss_type = BSS_TYPE_AP_BSS;
-- 
2.27.0

