Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B85D673FDA
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 18:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjASRZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 12:25:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbjASRZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 12:25:49 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24A9B764
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 09:25:47 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30JHDCn82320862
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 17:13:13 GMT
Received: from canardo.dyn.mork.no (ip6-localhost [IPv6:0:0:0:0:0:0:0:1])
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPS id 30JHD6KN3882130
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 18:13:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1674148386; bh=vYYdunohl/3ayv5JPKDtZFfq1EL3d/tM4lgvAtZgazs=;
        h=From:To:Cc:Subject:Date:Message-Id:References:From;
        b=jPE9CWqg+eJSA+Bf4+1oX5aYHWju6bzffAs0HcrpAfsdtXWabmxuGC7Gp3b96UC8b
         BcTKTQbtpjkW6HWD1yy99qCD+dTwfvJq6wAWFzYjxqWsrm806Mi4K3J7Tyj/1sRf8b
         1gUvV2wy5dWmeSlW0UqEj1SpeVLMH1+a78QKly7c=
Received: (from bjorn@localhost)
        by canardo.dyn.mork.no (8.15.2/8.15.2/Submit) id 30JHD60i3882124;
        Thu, 19 Jan 2023 18:13:06 +0100
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH net 3/3] net: mediatek: sgmii: fix duplex configuration
Date:   Thu, 19 Jan 2023 18:12:48 +0100
Message-Id: <20230119171248.3882021-4-bjorn@mork.no>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230119171248.3882021-1-bjorn@mork.no>
References: <20230119171248.3882021-1-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This bit is cleared for full duplex and set for half duplex.
Rename the macro to avoid confusion.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h | 2 +-
 drivers/net/ethernet/mediatek/mtk_sgmii.c   | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
index dff0e3ad2de6..f602a0b5238d 100644
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
index d1f2bcb21242..c976e99e37dc 100644
--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -145,11 +145,11 @@ static void mtk_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
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

