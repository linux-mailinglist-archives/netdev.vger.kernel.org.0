Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B506772A1
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 22:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjAVVXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 16:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjAVVXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 16:23:01 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B52E13514
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 13:22:58 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30MLM39W2545323
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Sun, 22 Jan 2023 21:22:05 GMT
Received: from canardo.dyn.mork.no (ip6-localhost [IPv6:0:0:0:0:0:0:0:1])
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPS id 30MLLwfg295459
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Sun, 22 Jan 2023 22:21:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1674422518; bh=adlukpB7EYJbg2n7rrBCyiZlY2WCgp8cmcuC+hNlNIU=;
        h=From:To:Cc:Subject:Date:Message-Id:References:From;
        b=Qfo2Wt5g4KUObjxVh8940IUEFtwvjWfLKXFFlsu3KBsORq8IdV8dLVkAHPtNOxUED
         sPy2vwGR9TAz2eC2VmE3YSPJz7yMxJ5cTKCo+Hci4GoXAvLjH+GxJYySwkhus3QaTm
         qeeXMfjRKz679yTTe3PJOB0z5w7oHU0i5N2LJeWg=
Received: (from bjorn@localhost)
        by canardo.dyn.mork.no (8.15.2/8.15.2/Submit) id 30MLLwrF295454;
        Sun, 22 Jan 2023 22:21:58 +0100
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH v3 net 2/3] net: mediatek: sgmii: fix duplex configuration
Date:   Sun, 22 Jan 2023 22:21:52 +0100
Message-Id: <20230122212153.295387-3-bjorn@mork.no>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230122212153.295387-1-bjorn@mork.no>
References: <20230122212153.295387-1-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This bit is cleared for full duplex and set for half duplex.
Rename the macro to avoid confusion.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 2 +-
 drivers/net/ethernet/mediatek/mtk_sgmii.c   | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index 70e729468a95..bab3699dcdca 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
@@ -533,7 +533,7 @@
 #define SGMII_SPEED_10			FIELD_PREP(SGMII_SPEED_MASK, 0)
 #define SGMII_SPEED_100			FIELD_PREP(SGMII_SPEED_MASK, 1)
 #define SGMII_SPEED_1000		FIELD_PREP(SGMII_SPEED_MASK, 2)
-#define SGMII_DUPLEX_FULL		BIT(4)
+#define SGMII_DUPLEX_HALF		BIT(4)
 #define SGMII_IF_MODE_BIT5		BIT(5)
 #define SGMII_REMOTE_FAULT_DIS		BIT(8)
 #define SGMII_CODE_SYNC_SET_VAL		BIT(9)
diff --git a/drivers/net/ethernet/mediatek/mtk_sgmii.c b/drivers/net/ethernet/mediatek/mtk_sgmii.c
index 0a06995099cf..c4261069b521 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -154,11 +154,11 @@ static void mtk_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
 		else
 			sgm_mode = SGMII_SPEED_1000;
 
-		if (duplex == DUPLEX_FULL)
-			sgm_mode |= SGMII_DUPLEX_FULL;
+		if (duplex != DUPLEX_FULL)
+			sgm_mode |= SGMII_DUPLEX_HALF;
 
 		regmap_update_bits(mpcs->regmap, SGMSYS_SGMII_MODE,
-				   SGMII_DUPLEX_FULL | SGMII_SPEED_MASK,
+				   SGMII_DUPLEX_HALF | SGMII_SPEED_MASK,
 				   sgm_mode);
 	}
 }
-- 
2.30.2

