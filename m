Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEB53E5A3F
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 14:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239161AbhHJMnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 08:43:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240743AbhHJMnc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 08:43:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D39B860F11;
        Tue, 10 Aug 2021 12:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628599390;
        bh=h/pZwe4kS1lvORPnndJtW5PYC2ztaMiHB+g7Oizo944=;
        h=From:To:Cc:Subject:Date:From;
        b=KkjsMW+AgOyz4NhRG9XLXbIA1KTrcM7s4yCZLGD7+bqYgc7DicAldKi8H7kv2C5Ev
         o6rooevZHtmPP+4/dslq6MJ65YnJcuui4oOF6j3V+4dL7/GHrOegBlQF9ryJvRLnuX
         vU+fxXZoD05Vt/CDyl7bCavSCoYEMFQalIHtGIAlT0x/PXJBCjX1zSzRQakCCbzfon
         Mdc9DC+3T4TEmfNr/27KnDtdqAnI2+iojug+MhnhNM3Y/MLp/alnvikDweeFkSjlA/
         Z9rJHB7KovDemJwqdNuzCIqWKBRCGhIkRtPUJYQHcLu04IESX0WYnN0FTH98H87Rm9
         sAuosB8otzYMg==
From:   Mark Brown <broonie@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     UNGLinuxDriver@microchip.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH] net: mscc: Fix non-GPL export of regmap APIs
Date:   Tue, 10 Aug 2021 13:37:48 +0100
Message-Id: <20210810123748.47871-1-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3235; h=from:subject; bh=h/pZwe4kS1lvORPnndJtW5PYC2ztaMiHB+g7Oizo944=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBhEnIQTkOVjrMAfs1YYhX7rKXAqm7nAPKRXinsDr42 a5FYnueJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYRJyEAAKCRAk1otyXVSH0NzRB/ wM6+JIEWPUtf8QhM90PEg4sVamYC4BtHf+7oapFdn+QtyJpdtc+h+O5PtzFu7Wfh+kO/e5gnqQOMjf JgWn+lXjABx+ETF9G3AT3dPCJWk1H0uI59hfrM7LzEVBWsdxWAEeSbynD9A1K9jz0McdIkgGx3aW62 ReZIe+3rjBqpvW6jh3NHMiYW5sfM9ahWexSOJAa5GLCXEKnsrt46BSLuhF8JPxsH8DERjA/bQY3P/l Crw/7YGgR/rbp3O73S8p8Fn9Zqh7FAVrabAgQTtcA0ICWIy7SA0M19GFyoNt60n1XIncgqKyBvh98X As7/jUh+DaXmbYL9jl8ZaSACb/iZaa
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot driver makes use of regmap, wrapping it with driver specific
operations that are thin wrappers around the core regmap APIs. These are
exported with EXPORT_SYMBOL, dropping the _GPL from the core regmap
exports which is frowned upon. Add _GPL suffixes to at least the APIs that
are doing register I/O.

Signed-off-by: Mark Brown <broonie@kernel.org>
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
2.20.1

