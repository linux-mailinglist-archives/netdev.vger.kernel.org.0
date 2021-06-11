Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F483A49D6
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 22:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhFKUIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 16:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbhFKUID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 16:08:03 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CD1C0613A4
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 13:06:04 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id g8so6278482ejx.1
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 13:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8M2/RG6z50uoGEAbutNKpp3O5Lsinip7wy73szfV7/4=;
        b=UdhYP+zgu8SCmEGnawvk/W2dCMlOrWtvS3AcYzMooSlRWzdcH5HuGCqyQMm63KGCra
         HtakFCBGNZxHmSgRjp8Z6+r9E+mzgbPaV6Ro9c1W/hr5cMzi7BdXDzQDRIrbKmgWFkDm
         eOuUp8FmRxGWRF1nQm2tls8QJgeIT4G8mbcsUNye7+4Yb4SSNiGEDOW+XqUkjh82yynJ
         xT+DMCaiU18EgoWeNtZE01AhyoMpbIZ0bgdl3T/w9ZHgO4pHwTgbRo02o3KNKp+45PcL
         OXzxYIPp9zSdAMOzHSt6orkKEavWH0uBoOubDO8Xyvmykcz6bWidgYHyQC5koZ/z79Go
         juAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8M2/RG6z50uoGEAbutNKpp3O5Lsinip7wy73szfV7/4=;
        b=kesjzC/NJaBLznIQJgY9jDd98ghOCBWqjYKApUOTjop+ih1R2NR2/1I0rkJdrGBYWe
         m/NNbpW5CPkJ10kXM+leEjrV6SoIioiYdrwrj/p/XfVpLeqVD6hdIuObrypX+0wBsVPW
         O6xe3u7jV6hH9HU7w24ec9t3PamywEsi0YjJSWZTY4BI+IekS9sGWngJKvYqyJ7Eoe37
         V+zyVxz0WV0c8S2gU21RZ60ohyt41NbTd0XpzXvjhQvmaoSLWD6Y8rmySdwNhE3qqYLW
         7wnX9o7xUJRATV6xUmLBoaCpuA1UOoGrKamcLOpP4T/C5/uVcbzCnaiP/Vdo9S3rZFa9
         Q/1w==
X-Gm-Message-State: AOAM533tsJIxbRaiIhRaqYQ8B/taBLfQIENA7+xQ4TMlNTm4KSOxmkxp
        OAqZ0/eAS05pQkjf5zkfx7U=
X-Google-Smtp-Source: ABdhPJzss3xS6cHiAMQgMY9qgSZlaYgbX55pLD2zWX6gZiMBcP10zo9CENesUUnL+7A0FbGbNte4kA==
X-Received: by 2002:a17:906:161b:: with SMTP id m27mr5137165ejd.89.1623441962734;
        Fri, 11 Jun 2021 13:06:02 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id w2sm2392084ejn.118.2021.06.11.13.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 13:06:02 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 11/13] net: dsa: sja1105: register the PCS MDIO bus for SJA1110
Date:   Fri, 11 Jun 2021 23:05:29 +0300
Message-Id: <20210611200531.2384819-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611200531.2384819-1-olteanv@gmail.com>
References: <20210611200531.2384819-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

On the SJA1110, the PCS of each SERDES-capable port is accessed through
a different memory window which is 0x100 bytes in size, denoted by
"pcs_base".

In each PCS register access window, the XPCS MMDs are accessed in an
indirect way: in pages/banks of up to 0x100 addresses each. Changing the
page/bank is done by writing to a special register at the end of the
access window.

The MDIO register map accessed indirectly through the indirect banked
method described above is similar to what SJA1105 has: upper 5 bits are
the MMD, lower 16 bits are the MDIO address within that MMD.

Since the PHY ID reported by the XPCS inside SJA1110 is also all zeroes
(like SJA1105), we need to trap those reads and return a fake PHY ID so
that the xpcs driver can apply some specific fixups for our integration.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none
v1->v2: none

 drivers/net/dsa/sja1105/sja1105.h      |  3 +
 drivers/net/dsa/sja1105/sja1105_mdio.c | 95 ++++++++++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_spi.c  | 11 +++
 3 files changed, 109 insertions(+)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 82450921059a..39124726bdd9 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -69,6 +69,7 @@ struct sja1105_regs {
 	u64 stats[__MAX_SJA1105_STATS_AREA][SJA1105_MAX_NUM_PORTS];
 	u64 mdio_100base_tx;
 	u64 mdio_100base_t1;
+	u64 pcs_base[SJA1105_MAX_NUM_PORTS];
 };
 
 struct sja1105_mdio_private {
@@ -303,6 +304,8 @@ int sja1105_mdiobus_register(struct dsa_switch *ds);
 void sja1105_mdiobus_unregister(struct dsa_switch *ds);
 int sja1105_pcs_mdio_read(struct mii_bus *bus, int phy, int reg);
 int sja1105_pcs_mdio_write(struct mii_bus *bus, int phy, int reg, u16 val);
+int sja1110_pcs_mdio_read(struct mii_bus *bus, int phy, int reg);
+int sja1110_pcs_mdio_write(struct mii_bus *bus, int phy, int reg, u16 val);
 
 /* From sja1105_devlink.c */
 int sja1105_devlink_setup(struct dsa_switch *ds);
diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
index 5185471e9b7c..41468e51a38e 100644
--- a/drivers/net/dsa/sja1105/sja1105_mdio.c
+++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
@@ -5,6 +5,8 @@
 #include <linux/of_mdio.h>
 #include "sja1105.h"
 
+#define SJA1110_PCS_BANK_REG		SJA1110_SPI_ADDR(0x3fc)
+
 int sja1105_pcs_mdio_read(struct mii_bus *bus, int phy, int reg)
 {
 	struct sja1105_mdio_private *mdio_priv = bus->priv;
@@ -56,6 +58,99 @@ int sja1105_pcs_mdio_write(struct mii_bus *bus, int phy, int reg, u16 val)
 	return sja1105_xfer_u32(priv, SPI_WRITE, addr, &tmp, NULL);
 }
 
+int sja1110_pcs_mdio_read(struct mii_bus *bus, int phy, int reg)
+{
+	struct sja1105_mdio_private *mdio_priv = bus->priv;
+	struct sja1105_private *priv = mdio_priv->priv;
+	const struct sja1105_regs *regs = priv->info->regs;
+	int offset, bank;
+	u64 addr;
+	u32 tmp;
+	u16 mmd;
+	int rc;
+
+	if (!(reg & MII_ADDR_C45))
+		return -EINVAL;
+
+	if (regs->pcs_base[phy] == SJA1105_RSV_ADDR)
+		return -ENODEV;
+
+	mmd = (reg >> MII_DEVADDR_C45_SHIFT) & 0x1f;
+	addr = (mmd << 16) | (reg & GENMASK(15, 0));
+
+	if (mmd == MDIO_MMD_VEND2 && (reg & GENMASK(15, 0)) == MII_PHYSID1)
+		return NXP_SJA1110_XPCS_ID >> 16;
+	if (mmd == MDIO_MMD_VEND2 && (reg & GENMASK(15, 0)) == MII_PHYSID2)
+		return NXP_SJA1110_XPCS_ID & GENMASK(15, 0);
+
+	bank = addr >> 8;
+	offset = addr & GENMASK(7, 0);
+
+	/* This addressing scheme reserves register 0xff for the bank address
+	 * register, so that can never be addressed.
+	 */
+	if (WARN_ON(offset == 0xff))
+		return -ENODEV;
+
+	tmp = bank;
+
+	rc = sja1105_xfer_u32(priv, SPI_WRITE,
+			      regs->pcs_base[phy] + SJA1110_PCS_BANK_REG,
+			      &tmp, NULL);
+	if (rc < 0)
+		return rc;
+
+	rc = sja1105_xfer_u32(priv, SPI_READ, regs->pcs_base[phy] + offset,
+			      &tmp, NULL);
+	if (rc < 0)
+		return rc;
+
+	return tmp & 0xffff;
+}
+
+int sja1110_pcs_mdio_write(struct mii_bus *bus, int phy, int reg, u16 val)
+{
+	struct sja1105_mdio_private *mdio_priv = bus->priv;
+	struct sja1105_private *priv = mdio_priv->priv;
+	const struct sja1105_regs *regs = priv->info->regs;
+	int offset, bank;
+	u64 addr;
+	u32 tmp;
+	u16 mmd;
+	int rc;
+
+	if (!(reg & MII_ADDR_C45))
+		return -EINVAL;
+
+	if (regs->pcs_base[phy] == SJA1105_RSV_ADDR)
+		return -ENODEV;
+
+	mmd = (reg >> MII_DEVADDR_C45_SHIFT) & 0x1f;
+	addr = (mmd << 16) | (reg & GENMASK(15, 0));
+
+	bank = addr >> 8;
+	offset = addr & GENMASK(7, 0);
+
+	/* This addressing scheme reserves register 0xff for the bank address
+	 * register, so that can never be addressed.
+	 */
+	if (WARN_ON(offset == 0xff))
+		return -ENODEV;
+
+	tmp = bank;
+
+	rc = sja1105_xfer_u32(priv, SPI_WRITE,
+			      regs->pcs_base[phy] + SJA1110_PCS_BANK_REG,
+			      &tmp, NULL);
+	if (rc < 0)
+		return rc;
+
+	tmp = val;
+
+	return sja1105_xfer_u32(priv, SPI_WRITE, regs->pcs_base[phy] + offset,
+				&tmp, NULL);
+}
+
 enum sja1105_mdio_opcode {
 	SJA1105_C45_ADDR = 0,
 	SJA1105_C22 = 1,
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index c1c54b7ff0e4..96768af4c6a8 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -561,6 +561,9 @@ static struct sja1105_regs sja1110_regs = {
 	.ptpsyncts = SJA1110_SPI_ADDR(0x84),
 	.mdio_100base_tx = 0x1c2400,
 	.mdio_100base_t1 = 0x1c1000,
+	.pcs_base = {SJA1105_RSV_ADDR, 0x1c1400, 0x1c1800, 0x1c1c00, 0x1c2000,
+		     SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR,
+		     SJA1105_RSV_ADDR, SJA1105_RSV_ADDR, SJA1105_RSV_ADDR},
 };
 
 const struct sja1105_info sja1105e_info = {
@@ -794,6 +797,8 @@ const struct sja1105_info sja1110a_info = {
 	.rxtstamp		= sja1110_rxtstamp,
 	.txtstamp		= sja1110_txtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
+	.pcs_mdio_read		= sja1110_pcs_mdio_read,
+	.pcs_mdio_write		= sja1110_pcs_mdio_write,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
 		[SJA1105_SPEED_10MBPS] = 4,
@@ -843,6 +848,8 @@ const struct sja1105_info sja1110b_info = {
 	.rxtstamp		= sja1110_rxtstamp,
 	.txtstamp		= sja1110_txtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
+	.pcs_mdio_read		= sja1110_pcs_mdio_read,
+	.pcs_mdio_write		= sja1110_pcs_mdio_write,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
 		[SJA1105_SPEED_10MBPS] = 4,
@@ -892,6 +899,8 @@ const struct sja1105_info sja1110c_info = {
 	.rxtstamp		= sja1110_rxtstamp,
 	.txtstamp		= sja1110_txtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
+	.pcs_mdio_read		= sja1110_pcs_mdio_read,
+	.pcs_mdio_write		= sja1110_pcs_mdio_write,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
 		[SJA1105_SPEED_10MBPS] = 4,
@@ -941,6 +950,8 @@ const struct sja1105_info sja1110d_info = {
 	.rxtstamp		= sja1110_rxtstamp,
 	.txtstamp		= sja1110_txtstamp,
 	.clocking_setup		= sja1110_clocking_setup,
+	.pcs_mdio_read		= sja1110_pcs_mdio_read,
+	.pcs_mdio_write		= sja1110_pcs_mdio_write,
 	.port_speed		= {
 		[SJA1105_SPEED_AUTO] = 0,
 		[SJA1105_SPEED_10MBPS] = 4,
-- 
2.25.1

