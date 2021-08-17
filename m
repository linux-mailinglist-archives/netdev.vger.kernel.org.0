Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866CA3EE12C
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 02:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbhHQAhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 20:37:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236434AbhHQAgl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 20:36:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F68A61052;
        Tue, 17 Aug 2021 00:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629160566;
        bh=bshTLC1uJlE+pTmdql1NoWvc/HC9abF6H6tLLErjrck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GpblZsd3rhsdjdxV3LSo7k6UOPgWqBNFCwmkg99IORilaYL5muAyH4XNLidboPO9n
         bJuI0MPJzKG5jePO+EnA8jRspn00gKfR/QzNJUbJAbjv1a20OX0XJeZRsfxtm2dfR8
         5rdJ11k6XmgU5e7ti0RCMgGDL/ohdI5h57k3xwtA15or9Za2bG/iG2DrzG2AhG2FhX
         KJEQ4Y9eGs2bV1rmUfq9ALqLDHnWO70W55UEI5KIA01LZZHDjs5cx9zUCUPueKse33
         WJmohy/UbIDtWzTVr80sYNs6h4LE9fjxmqEcTw6KyFW6gZOXzui9f/cGrXLARa5vVN
         cHWgpgwDlg30Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Brown <broonie@kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 9/9] net: mscc: Fix non-GPL export of regmap APIs
Date:   Mon, 16 Aug 2021 20:35:54 -0400
Message-Id: <20210817003554.83213-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817003554.83213-1-sashal@kernel.org>
References: <20210817003554.83213-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 48c812e0327744b4965296f65c23fe2405692afc ]

The ocelot driver makes use of regmap, wrapping it with driver specific
operations that are thin wrappers around the core regmap APIs. These are
exported with EXPORT_SYMBOL, dropping the _GPL from the core regmap
exports which is frowned upon. Add _GPL suffixes to at least the APIs that
are doing register I/O.

Signed-off-by: Mark Brown <broonie@kernel.org>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_io.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_io.c b/drivers/net/ethernet/mscc/ocelot_io.c
index ea4e83410fe4..7390fa3980ec 100644
--- a/drivers/net/ethernet/mscc/ocelot_io.c
+++ b/drivers/net/ethernet/mscc/ocelot_io.c
@@ -21,7 +21,7 @@ u32 __ocelot_read_ix(struct ocelot *ocelot, u32 reg, u32 offset)
 		    ocelot->map[target][reg & REG_MASK] + offset, &val);
 	return val;
 }
-EXPORT_SYMBOL(__ocelot_read_ix);
+EXPORT_SYMBOL_GPL(__ocelot_read_ix);
 
 void __ocelot_write_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 offset)
 {
@@ -32,7 +32,7 @@ void __ocelot_write_ix(struct ocelot *ocelot, u32 val, u32 reg, u32 offset)
 	regmap_write(ocelot->targets[target],
 		     ocelot->map[target][reg & REG_MASK] + offset, val);
 }
-EXPORT_SYMBOL(__ocelot_write_ix);
+EXPORT_SYMBOL_GPL(__ocelot_write_ix);
 
 void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
 		     u32 offset)
@@ -45,7 +45,7 @@ void __ocelot_rmw_ix(struct ocelot *ocelot, u32 val, u32 mask, u32 reg,
 			   ocelot->map[target][reg & REG_MASK] + offset,
 			   mask, val);
 }
-EXPORT_SYMBOL(__ocelot_rmw_ix);
+EXPORT_SYMBOL_GPL(__ocelot_rmw_ix);
 
 u32 ocelot_port_readl(struct ocelot_port *port, u32 reg)
 {
@@ -58,7 +58,7 @@ u32 ocelot_port_readl(struct ocelot_port *port, u32 reg)
 	regmap_read(port->target, ocelot->map[target][reg & REG_MASK], &val);
 	return val;
 }
-EXPORT_SYMBOL(ocelot_port_readl);
+EXPORT_SYMBOL_GPL(ocelot_port_readl);
 
 void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg)
 {
@@ -69,7 +69,7 @@ void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg)
 
 	regmap_write(port->target, ocelot->map[target][reg & REG_MASK], val);
 }
-EXPORT_SYMBOL(ocelot_port_writel);
+EXPORT_SYMBOL_GPL(ocelot_port_writel);
 
 void ocelot_port_rmwl(struct ocelot_port *port, u32 val, u32 mask, u32 reg)
 {
@@ -77,7 +77,7 @@ void ocelot_port_rmwl(struct ocelot_port *port, u32 val, u32 mask, u32 reg)
 
 	ocelot_port_writel(port, (cur & (~mask)) | val, reg);
 }
-EXPORT_SYMBOL(ocelot_port_rmwl);
+EXPORT_SYMBOL_GPL(ocelot_port_rmwl);
 
 u32 __ocelot_target_read_ix(struct ocelot *ocelot, enum ocelot_target target,
 			    u32 reg, u32 offset)
@@ -128,7 +128,7 @@ int ocelot_regfields_init(struct ocelot *ocelot,
 
 	return 0;
 }
-EXPORT_SYMBOL(ocelot_regfields_init);
+EXPORT_SYMBOL_GPL(ocelot_regfields_init);
 
 static struct regmap_config ocelot_regmap_config = {
 	.reg_bits	= 32,
@@ -148,4 +148,4 @@ struct regmap *ocelot_regmap_init(struct ocelot *ocelot, struct resource *res)
 
 	return devm_regmap_init_mmio(ocelot->dev, regs, &ocelot_regmap_config);
 }
-EXPORT_SYMBOL(ocelot_regmap_init);
+EXPORT_SYMBOL_GPL(ocelot_regmap_init);
-- 
2.30.2

