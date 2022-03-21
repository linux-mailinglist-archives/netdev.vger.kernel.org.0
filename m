Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F58E4E258C
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 12:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346898AbiCULwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 07:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346892AbiCULwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 07:52:42 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A7B6542A
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 04:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=k1; bh=2kPVtjZgbfZNm8
        bnLKE/3dfwjc3G5UY5/Mx40qSbFhk=; b=pok2xq+8PHwewlgGiN04y3TnrC8PrW
        mSd8P4A0cl8Pwr9eTaIH5IWX6b1vCPNZpwoogRISMVIxwSK2PGic+DoAA1cV/Hnq
        C74dPFtZN/0/t5sBnNYM8L3TeoIpATMu8mwgbO0ku9trN/kquLTsZX6nUhOwsc4c
        Bubq+Wa/hCWgo=
Received: (qmail 860299 invoked from network); 21 Mar 2022 12:51:07 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 21 Mar 2022 12:51:07 +0100
X-UD-Smtp-Session: l3s3148p1@JQigHLnaBqcgAQnoAFxnAN8BywfgXJ9V
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     linux-mmc@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org
Subject: [RFC PATCH 03/10] brcmfmac: sdio: update to new MMC API for resetting cards
Date:   Mon, 21 Mar 2022 12:50:49 +0100
Message-Id: <20220321115059.21803-4-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321115059.21803-1-wsa+renesas@sang-engineering.com>
References: <20220321115059.21803-1-wsa+renesas@sang-engineering.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No functional change, only the name and the argument type change to
avoid confusion between resetting a card and a host controller.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---

RFC, please do not apply yet.

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 8effeb7a7269..df5b36217a0d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4165,7 +4165,7 @@ static int brcmf_sdio_bus_reset(struct device *dev)
 
 	/* reset the adapter */
 	sdio_claim_host(sdiodev->func1);
-	mmc_hw_reset(sdiodev->func1->card->host);
+	mmc_card_hw_reset(sdiodev->func1->card);
 	sdio_release_host(sdiodev->func1);
 
 	brcmf_bus_change_state(sdiodev->bus_if, BRCMF_BUS_DOWN);
-- 
2.30.2

