Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3804B24CE05
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbgHUGcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:32:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:42240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbgHUGcM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 02:32:12 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11D0020732;
        Fri, 21 Aug 2020 06:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597991531;
        bh=qMQ4DO3ojjEcT05k8u0HaeNGZvJba3kCFJEYgbSc5uM=;
        h=Date:From:To:Cc:Subject:From;
        b=LTr4CN13XIBCYEhBtRHJ+fOt5pkHVIXYlUPSzh1BDfau86a9Pil/IUS3yJDu1Knri
         n7FBGRPvMpfWV7nEzcy2pg62H3jTu5PN8oc4U++V49e6BzqUmrfAH/8PoNdkjhI3ox
         Z2/a9wY4NJO5jepNK0gyxbBGtelO5lC2OXtvGRKM=
Date:   Fri, 21 Aug 2020 01:37:58 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] brcmfmac: Use fallthrough pseudo-keyword
Message-ID: <20200821063758.GA17783@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the existing /* fall through */ comments and its variants with
the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
fall-through markings when it is the case.

[1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 2 --
 .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c   | 8 ++++----
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c   | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   | 2 --
 4 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 1a7ab49295aa..0dc4de2fa9f6 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -916,9 +916,7 @@ int brcmf_sdiod_probe(struct brcmf_sdio_dev *sdiodev)
 		f2_blksz = SDIO_4373_FUNC2_BLOCKSIZE;
 		break;
 	case SDIO_DEVICE_ID_BROADCOM_4359:
-		/* fallthrough */
 	case SDIO_DEVICE_ID_BROADCOM_4354:
-		/* fallthrough */
 	case SDIO_DEVICE_ID_BROADCOM_4356:
 		f2_blksz = SDIO_435X_FUNC2_BLOCKSIZE;
 		break;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 444639f09aa4..8b5fda9bb853 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -3477,7 +3477,7 @@ brcmf_get_netinfo_array(struct brcmf_pno_scanresults_le *pfn_v1)
 	switch (pfn_v1->version) {
 	default:
 		WARN_ON(1);
-		/* fall-thru */
+		fallthrough;
 	case cpu_to_le32(1):
 		netinfo = (struct brcmf_pno_net_info_le *)(pfn_v1 + 1);
 		break;
@@ -6473,7 +6473,7 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
 		default:
 			wiphy_warn(wiphy, "Firmware reported unsupported bandwidth %d\n",
 				   ch.bw);
-			/* fall through */
+			fallthrough;
 		case BRCMU_CHAN_BW_20:
 			/* enable the channel and disable other bandwidths
 			 * for now as mentioned order assure they are enabled
@@ -6611,10 +6611,10 @@ static void brcmf_get_bwcap(struct brcmf_if *ifp, u32 bw_cap[])
 	switch (mimo_bwcap) {
 	case WLC_N_BW_40ALL:
 		bw_cap[NL80211_BAND_2GHZ] |= WLC_BW_40MHZ_BIT;
-		/* fall-thru */
+		fallthrough;
 	case WLC_N_BW_20IN2G_40IN5G:
 		bw_cap[NL80211_BAND_5GHZ] |= WLC_BW_40MHZ_BIT;
-		/* fall-thru */
+		fallthrough;
 	case WLC_N_BW_20ALL:
 		bw_cap[NL80211_BAND_2GHZ] |= WLC_BW_20MHZ_BIT;
 		bw_cap[NL80211_BAND_5GHZ] |= WLC_BW_20MHZ_BIT;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
index a3a257089696..5bf11e46fc49 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
@@ -1390,7 +1390,7 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
 	case BRCM_CC_4345_CHIP_ID:
 		/* explicitly check SR engine enable bit */
 		pmu_cc3_mask = BIT(2);
-		/* fall-through */
+		fallthrough;
 	case BRCM_CC_43241_CHIP_ID:
 	case BRCM_CC_4335_CHIP_ID:
 	case BRCM_CC_4339_CHIP_ID:
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 3c07d1bbe1c6..d1b96bad2718 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4305,9 +4305,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 					   CY_43455_MESBUSYCTRL, &err);
 			break;
 		case SDIO_DEVICE_ID_BROADCOM_4359:
-			/* fallthrough */
 		case SDIO_DEVICE_ID_BROADCOM_4354:
-			/* fallthrough */
 		case SDIO_DEVICE_ID_BROADCOM_4356:
 			brcmf_dbg(INFO, "set F2 watermark to 0x%x*4 bytes\n",
 				  CY_435X_F2_WATERMARK);
-- 
2.27.0

