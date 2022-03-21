Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9364E259A
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 12:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346874AbiCULxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 07:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346860AbiCULwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 07:52:44 -0400
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FF16542A
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 04:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=k1; bh=3/MweonOnAZzh0
        9fhx+1gPXXRGWjBJLCioPiGXAo618=; b=nFKi4GC/C+rUCjAYG4bFTffa8e/2Ix
        htMeS+n4hfsDkaQI4dtnpKID6i1jFjEAKBXG5a3MIZeiwb5TAwSvAzniHqXBlOqJ
        Ck0vMIXpZmgSbZMz2bB9Kb9TXQT5uLka9BJOJvRl/4grj6U5xYMipTffCIkjaKZd
        tpgZRSId7PGDY=
Received: (qmail 860337 invoked from network); 21 Mar 2022 12:51:08 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 21 Mar 2022 12:51:08 +0100
X-UD-Smtp-Session: l3s3148p1@NoWpHLnaCKcgAQnoAFxnAN8BywfgXJ9V
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     linux-mmc@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC PATCH 04/10] mwifiex: sdio: update to new MMC API for resetting cards
Date:   Mon, 21 Mar 2022 12:50:50 +0100
Message-Id: <20220321115059.21803-5-wsa+renesas@sang-engineering.com>
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

 drivers/net/wireless/marvell/mwifiex/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index bde9e4bbfffe..8c3730c7d93e 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -2639,7 +2639,7 @@ static void mwifiex_sdio_card_reset_work(struct mwifiex_adapter *adapter)
 
 	/* Run a HW reset of the SDIO interface. */
 	sdio_claim_host(func);
-	ret = mmc_hw_reset(func->card->host);
+	ret = mmc_card_hw_reset(func->card);
 	sdio_release_host(func);
 
 	switch (ret) {
-- 
2.30.2

