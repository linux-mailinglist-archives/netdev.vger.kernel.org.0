Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158C74DE16E
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 19:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240266AbiCRS6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 14:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237875AbiCRS6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 14:58:09 -0400
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3330C2274CB;
        Fri, 18 Mar 2022 11:56:50 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 89E92C0002;
        Fri, 18 Mar 2022 18:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1647629808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kj+PvFp1ksz07D636STHaz1vWj2YLBhvGeYDeYxJsEk=;
        b=U+IXNMsyb+ALvwBc78TmPCQWyw+wlHiEpU+asY8zoZVNo7zLqLyC5AVgNSFRPwMJ66mmhN
        Lxv7/ny/mm1BhI4eApJq2Ko5qJdb4dlK0bceBID9KhVXrX3KOHtEzdemM2DdVhBcA4krzw
        pWA9ES7/qtw+WYbt2UWl3WyqFMZF/nE0L5Fm9vAlCko3VVYaDQLONq2g58usdzKN6vBko1
        wBuyT5MqY9W24lquIlKF/MYPQl+By3NsBoBc745xYrcJkd7yvHXfIhw/hxD4BbXe29vgOb
        FAdVkQRdNxBaEzw+mXm5j5crT7I2Ezv0fGyUYm3vqub7Ev1jMjUEoZKwGYgH1g==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v4 01/11] net: ieee802154: Enhance/fix the names of the MLME return codes
Date:   Fri, 18 Mar 2022 19:56:34 +0100
Message-Id: <20220318185644.517164-2-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220318185644.517164-1-miquel.raynal@bootlin.com>
References: <20220318185644.517164-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's keep these definitions as close to the specification as possible
while they are not yet in use. The names get slightly longer, but we
gain the minor cost of being able to search the spec more easily.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/linux/ieee802154.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/ieee802154.h b/include/linux/ieee802154.h
index 95c831162212..01d945c8b2e1 100644
--- a/include/linux/ieee802154.h
+++ b/include/linux/ieee802154.h
@@ -136,16 +136,16 @@ enum {
 	IEEE802154_SUCCESS = 0x0,
 
 	/* The beacon was lost following a synchronization request. */
-	IEEE802154_BEACON_LOSS = 0xe0,
+	IEEE802154_BEACON_LOST = 0xe0,
 	/*
 	 * A transmission could not take place due to activity on the
 	 * channel, i.e., the CSMA-CA mechanism has failed.
 	 */
-	IEEE802154_CHNL_ACCESS_FAIL = 0xe1,
+	IEEE802154_CHANNEL_ACCESS_FAILURE = 0xe1,
 	/* The GTS request has been denied by the PAN coordinator. */
-	IEEE802154_DENINED = 0xe2,
+	IEEE802154_DENIED = 0xe2,
 	/* The attempt to disable the transceiver has failed. */
-	IEEE802154_DISABLE_TRX_FAIL = 0xe3,
+	IEEE802154_DISABLE_TRX_FAILURE = 0xe3,
 	/*
 	 * The received frame induces a failed security check according to
 	 * the security suite.
@@ -185,9 +185,9 @@ enum {
 	 * A PAN identifier conflict has been detected and communicated to the
 	 * PAN coordinator.
 	 */
-	IEEE802154_PANID_CONFLICT = 0xee,
+	IEEE802154_PAN_ID_CONFLICT = 0xee,
 	/* A coordinator realignment command has been received. */
-	IEEE802154_REALIGMENT = 0xef,
+	IEEE802154_REALIGNMENT = 0xef,
 	/* The transaction has expired and its information discarded. */
 	IEEE802154_TRANSACTION_EXPIRED = 0xf0,
 	/* There is no capacity to store the transaction. */
@@ -203,7 +203,7 @@ enum {
 	 * A SET/GET request was issued with the identifier of a PIB attribute
 	 * that is not supported.
 	 */
-	IEEE802154_UNSUPPORTED_ATTR = 0xf4,
+	IEEE802154_UNSUPPORTED_ATTRIBUTE = 0xf4,
 	/*
 	 * A request to perform a scan operation failed because the MLME was
 	 * in the process of performing a previously initiated scan operation.
-- 
2.27.0

