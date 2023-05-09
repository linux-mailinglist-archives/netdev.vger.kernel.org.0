Return-Path: <netdev+bounces-1114-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 923926FC3D4
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:25:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F5D41C20B16
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:25:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 074FDDDD6;
	Tue,  9 May 2023 10:25:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE2A8BE8
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 10:25:27 +0000 (UTC)
Received: from mail.nfschina.com (unknown [42.101.60.195])
	by lindbergh.monkeyblade.net (Postfix) with SMTP id 2B8F3D87E;
	Tue,  9 May 2023 03:25:24 -0700 (PDT)
Received: from localhost.localdomain (unknown [180.167.10.98])
	by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPA id BA7E2180140432;
	Tue,  9 May 2023 18:25:02 +0800 (CST)
X-MD-Sfrom: yunchuan@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: wuych <yunchuan@nfschina.com>
To: davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com
Cc: andrew@lunn.ch,
	michael@walle.cc,
	zhaoxiao@uniontech.com,
	andrew@aj.id.au,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	wuych <yunchuan@nfschina.com>
Subject: [PATCH net-next] freescale:Remove unnecessary (void*) conversions
Date: Tue,  9 May 2023 18:25:01 +0800
Message-Id: <20230509102501.41685-1-yunchuan@nfschina.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Pointer variables of void * type do not require type cast.

Signed-off-by: wuych <yunchuan@nfschina.com>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index a13b4ba4d6e1..167a7fe04853 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -131,7 +131,7 @@ static int xgmac_wait_until_done(struct device *dev,
 static int xgmac_mdio_write_c22(struct mii_bus *bus, int phy_id, int regnum,
 				u16 value)
 {
-	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
+	struct mdio_fsl_priv *priv = bus->priv;
 	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
 	bool endian = priv->is_little_endian;
 	u16 dev_addr = regnum & 0x1f;
@@ -163,7 +163,7 @@ static int xgmac_mdio_write_c22(struct mii_bus *bus, int phy_id, int regnum,
 static int xgmac_mdio_write_c45(struct mii_bus *bus, int phy_id, int dev_addr,
 				int regnum, u16 value)
 {
-	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
+	struct mdio_fsl_priv *priv = bus->priv;
 	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
 	bool endian = priv->is_little_endian;
 	u32 mdio_ctl, mdio_stat;
@@ -205,7 +205,7 @@ static int xgmac_mdio_write_c45(struct mii_bus *bus, int phy_id, int dev_addr,
  */
 static int xgmac_mdio_read_c22(struct mii_bus *bus, int phy_id, int regnum)
 {
-	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
+	struct mdio_fsl_priv *priv = bus->priv;
 	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
 	bool endian = priv->is_little_endian;
 	u16 dev_addr = regnum & 0x1f;
@@ -265,7 +265,7 @@ static int xgmac_mdio_read_c22(struct mii_bus *bus, int phy_id, int regnum)
 static int xgmac_mdio_read_c45(struct mii_bus *bus, int phy_id, int dev_addr,
 			       int regnum)
 {
-	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
+	struct mdio_fsl_priv *priv = bus->priv;
 	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
 	bool endian = priv->is_little_endian;
 	u32 mdio_stat, mdio_ctl;
@@ -326,7 +326,7 @@ static int xgmac_mdio_read_c45(struct mii_bus *bus, int phy_id, int dev_addr,
 
 static int xgmac_mdio_set_mdc_freq(struct mii_bus *bus)
 {
-	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
+	struct mdio_fsl_priv *priv = bus->priv;
 	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
 	struct device *dev = bus->parent;
 	u32 mdio_stat, div;
@@ -355,7 +355,7 @@ static int xgmac_mdio_set_mdc_freq(struct mii_bus *bus)
 
 static void xgmac_mdio_set_suppress_preamble(struct mii_bus *bus)
 {
-	struct mdio_fsl_priv *priv = (struct mdio_fsl_priv *)bus->priv;
+	struct mdio_fsl_priv *priv = bus->priv;
 	struct tgec_mdio_controller __iomem *regs = priv->mdio_base;
 	struct device *dev = bus->parent;
 	u32 mdio_stat;
-- 
2.30.2


