Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C5024CE0F
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgHUGdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:33:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbgHUGds (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 02:33:48 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D47120732;
        Fri, 21 Aug 2020 06:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597991627;
        bh=ZD+mARjckiaOLmEqpc3pkeddGNiVUiqWbUzQlmXxLCA=;
        h=Date:From:To:Cc:Subject:From;
        b=gvw3Zr2z6rjPA/azLcwbRJHjKcQUMRkSQ3pAP/XwJWUrQ7t63UojZ3qZ9Jiyp0lr1
         KtQDkuf9lxnNDjjisrEg9O1xw3DPAro1fyQL1a5Zrw/82QrIafkYGWDPJSTxNM/uaw
         73FAvDjrpZDVQgEqTIGLya6Yy/9h/1OPmGR67Ajg=
Date:   Fri, 21 Aug 2020 01:39:34 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] iwlegacy: Use fallthrough pseudo-keyword
Message-ID: <20200821063934.GA17838@embeddedor>
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
 drivers/net/wireless/intel/iwlegacy/3945-mac.c | 2 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c | 4 ++--
 drivers/net/wireless/intel/iwlegacy/common.c   | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index 9167c3d2711d..e3f79d6b978d 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -365,7 +365,7 @@ il3945_build_tx_cmd_hwcrypto(struct il_priv *il, struct ieee80211_tx_info *info,
 
 	case WLAN_CIPHER_SUITE_WEP104:
 		tx_cmd->sec_ctl |= TX_CMD_SEC_KEY128;
-		/* fall through */
+		fallthrough;
 	case WLAN_CIPHER_SUITE_WEP40:
 		tx_cmd->sec_ctl |=
 		    TX_CMD_SEC_WEP | (info->control.hw_key->
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index e73c223a7d28..9295344cd0d7 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -544,7 +544,7 @@ il4965_translate_rx_status(struct il_priv *il, u32 decrypt_in)
 			decrypt_out |= RX_RES_STATUS_BAD_KEY_TTAK;
 			break;
 		}
-		/* fall through - if TTAK OK */
+		fallthrough;	/* if TTAK OK */
 	default:
 		if (!(decrypt_in & RX_MPDU_RES_STATUS_ICV_OK))
 			decrypt_out |= RX_RES_STATUS_BAD_ICV_MIC;
@@ -1617,7 +1617,7 @@ il4965_tx_cmd_build_hwcrypto(struct il_priv *il, struct ieee80211_tx_info *info,
 
 	case WLAN_CIPHER_SUITE_WEP104:
 		tx_cmd->sec_ctl |= TX_CMD_SEC_KEY128;
-		/* fall through */
+		fallthrough;
 	case WLAN_CIPHER_SUITE_WEP40:
 		tx_cmd->sec_ctl |=
 		    (TX_CMD_SEC_WEP | (keyconf->keyidx & TX_CMD_SEC_MSK) <<
diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index f78e062df572..6ede3b2a0b52 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -2677,7 +2677,7 @@ il_set_decrypted_flag(struct il_priv *il, struct ieee80211_hdr *hdr,
 		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
 		    RX_RES_STATUS_BAD_KEY_TTAK)
 			break;
-		/* fall through */
+		fallthrough;
 
 	case RX_RES_STATUS_SEC_TYPE_WEP:
 		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
@@ -2687,7 +2687,7 @@ il_set_decrypted_flag(struct il_priv *il, struct ieee80211_hdr *hdr,
 			D_RX("Packet destroyed\n");
 			return -1;
 		}
-		/* fall through */
+		fallthrough;
 	case RX_RES_STATUS_SEC_TYPE_CCMP:
 		if ((decrypt_res & RX_RES_STATUS_DECRYPT_TYPE_MSK) ==
 		    RX_RES_STATUS_DECRYPT_OK) {
-- 
2.27.0

