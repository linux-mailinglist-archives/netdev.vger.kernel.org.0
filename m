Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAA065D511
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 15:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239468AbjADOIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 09:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239642AbjADOHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 09:07:08 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C1C1B1FA;
        Wed,  4 Jan 2023 06:06:41 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id u28so43873318edd.10;
        Wed, 04 Jan 2023 06:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lXdQJuCgdcK3bFq0qc/kkXKb90RrNwHuu1s1i0Cf6y0=;
        b=psJ8AxptRw31w4GdcnYONq3OUi1MENvGQ8He58RKcBGDcUmZKH3qEhtJ3ieQc4Ntut
         C3bspixifUYBv+FwiBtSDSqJIEAO9j2SMDxzdkivNPGBd0vHCG4k6Sn3sHqdDf97tPqw
         NeJfPTpKIgl3gGSllMOYnu7CqA30nN9Re2+R+2Vclth4M5v/tvs73P+T4nGhgB0nqKj0
         +NMkt7L2whPK6Wc/31gaypVMYA6zf+EcnRGRWQ7jMJr4JLS0zcGaH+6oepxUImZL0D8b
         KyQQ8tVTmtygDpackOZxOcRtaaHvh3RVYMTWzTE2GC+Oza6mZTUpX4dfFDS+0Nkl17tJ
         Kbwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lXdQJuCgdcK3bFq0qc/kkXKb90RrNwHuu1s1i0Cf6y0=;
        b=2oNom2BY0IV78H+fn2N5B0O2B85GSQTsIks8crWqytYkE0WwUdMsu/24Abl/HXfirD
         Prm9gePeMd6CKeTa7seLetbLTjrYUGs3P6tYjhquUDCHuGao/bEcfce56iNBNgsyJkiX
         Pdrcl9vOMbhAGV9gvXeduQ2V5yusS8JcyqkfsNBzSQsdtB+X9X44uSeNg4alOR1tPt5B
         kACxVKIZglULD6v4buna6vG7/tZCd5ib4EuM3Tz9toQDRO8bSEgWw20eJduHbf8Uz994
         +vBdqaLcYaZGwpQPMhXOZoWfs73hybvaLruPP/TS4H2e3B3r2Wb+wmKpGM6xjij9Db5U
         BmOg==
X-Gm-Message-State: AFqh2kq2eA/GU9OilwYs/l1Zf8trvA4P2imE2OyDhUhwIVnTccI3BWvI
        vRItPvQzP46lEzgM3UhxJaI=
X-Google-Smtp-Source: AMrXdXv7We9q7+0VB9e1fAfeoE60Dza8pdvwdov4Az3101usssHfifsf+z3inqbrNdD4VFQZLrTz1w==
X-Received: by 2002:a05:6402:5296:b0:461:dd11:c688 with SMTP id en22-20020a056402529600b00461dd11c688mr44661435edb.9.1672841200321;
        Wed, 04 Jan 2023 06:06:40 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id l26-20020a056402125a00b0046b471596e6sm14992196edw.57.2023.01.04.06.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jan 2023 06:06:39 -0800 (PST)
Date:   Wed, 4 Jan 2023 15:06:48 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH net-next 4/5] drivers/net/phy: add helpers to get/set PLCA
 configuration
Message-ID: <b6c4d454df9dbe03891c260c7c5446933d69f8e8.1672840326.git.piergiorgio.beruto@gmail.com>
References: <cover.1672840325.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1672840325.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support in phylib to read/write PLCA configuration for
Ethernet PHYs that support the OPEN Alliance "10BASE-T1S PLCA
Management Registers" specifications. These can be found at
https://www.opensig.org/about/specifications/

Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
---
 MAINTAINERS                          |   1 +
 drivers/net/phy/mdio-open-alliance.h |  46 +++++++
 drivers/net/phy/phy-c45.c            | 183 +++++++++++++++++++++++++++
 include/linux/phy.h                  |   6 +
 4 files changed, 236 insertions(+)
 create mode 100644 drivers/net/phy/mdio-open-alliance.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 8faa15c360e3..4356382ad57c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16617,6 +16617,7 @@ PLCA RECONCILIATION SUBLAYER (IEEE802.3 Clause 148)
 M:	Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/phy/mdio-open-alliance.h
 F:	net/ethtool/plca.c
 
 PLDMFW LIBRARY
diff --git a/drivers/net/phy/mdio-open-alliance.h b/drivers/net/phy/mdio-open-alliance.h
new file mode 100644
index 000000000000..931e14660d75
--- /dev/null
+++ b/drivers/net/phy/mdio-open-alliance.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * mdio-open-alliance.h - definition of OPEN Alliance SIG standard registers
+ */
+
+#ifndef __MDIO_OPEN_ALLIANCE__
+#define __MDIO_OPEN_ALLIANCE__
+
+#include <linux/mdio.h>
+
+/* NOTE: all OATC14 registers are located in MDIO_MMD_VEND2 */
+
+/* Open Alliance TC14 (10BASE-T1S) registers */
+#define MDIO_OATC14_PLCA_IDVER	0xca00  /* PLCA ID and version */
+#define MDIO_OATC14_PLCA_CTRL0	0xca01	/* PLCA Control register 0 */
+#define MDIO_OATC14_PLCA_CTRL1	0xca02	/* PLCA Control register 1 */
+#define MDIO_OATC14_PLCA_STATUS	0xca03	/* PLCA Status register */
+#define MDIO_OATC14_PLCA_TOTMR	0xca04	/* PLCA TO Timer register */
+#define MDIO_OATC14_PLCA_BURST	0xca05	/* PLCA BURST mode register */
+
+/* Open Alliance TC14 PLCA IDVER register */
+#define MDIO_OATC14_PLCA_IDM	0xff00	/* PLCA MAP ID */
+#define MDIO_OATC14_PLCA_VER	0x00ff	/* PLCA MAP version */
+
+/* Open Alliance TC14 PLCA CTRL0 register */
+#define MDIO_OATC14_PLCA_EN	BIT(15) /* PLCA enable */
+#define MDIO_OATC14_PLCA_RST	BIT(14) /* PLCA reset */
+
+/* Open Alliance TC14 PLCA CTRL1 register */
+#define MDIO_OATC14_PLCA_NCNT	0xff00	/* PLCA node count */
+#define MDIO_OATC14_PLCA_ID	0x00ff	/* PLCA local node ID */
+
+/* Open Alliance TC14 PLCA STATUS register */
+#define MDIO_OATC14_PLCA_PST	BIT(15)	/* PLCA status indication */
+
+/* Open Alliance TC14 PLCA TOTMR register */
+#define MDIO_OATC14_PLCA_TOT	0x00ff
+
+/* Open Alliance TC14 PLCA BURST register */
+#define MDIO_OATC14_PLCA_MAXBC	0xff00
+#define MDIO_OATC14_PLCA_BTMR	0x00ff
+
+/* Version Identifiers */
+#define OATC14_IDM		0x0a00
+
+#endif /* __MDIO_OPEN_ALLIANCE__ */
diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index a87a4b3ffce4..508edd1f17d7 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -8,6 +8,8 @@
 #include <linux/mii.h>
 #include <linux/phy.h>
 
+#include "mdio-open-alliance.h"
+
 /**
  * genphy_c45_baset1_able - checks if the PMA has BASE-T1 extended abilities
  * @phydev: target phy_device struct
@@ -931,6 +933,187 @@ int genphy_c45_fast_retrain(struct phy_device *phydev, bool enable)
 }
 EXPORT_SYMBOL_GPL(genphy_c45_fast_retrain);
 
+/**
+ * genphy_c45_plca_get_cfg - get PLCA configuration from standard registers
+ * @phydev: target phy_device struct
+ * @plca_cfg: output structure to store the PLCA configuration
+ *
+ * Description: if the PHY complies to the Open Alliance TC14 10BASE-T1S PLCA
+ *   Management Registers specifications, this function can be used to retrieve
+ *   the current PLCA configuration from the standard registers in MMD 31.
+ */
+int genphy_c45_plca_get_cfg(struct phy_device *phydev,
+			    struct phy_plca_cfg *plca_cfg)
+{
+	int ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, MDIO_OATC14_PLCA_IDVER);
+	if (ret < 0)
+		return ret;
+
+	if ((ret & MDIO_OATC14_PLCA_IDM) != OATC14_IDM)
+		return -ENODEV;
+
+	plca_cfg->version = ret & ~MDIO_OATC14_PLCA_IDM;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, MDIO_OATC14_PLCA_CTRL0);
+	if (ret < 0)
+		return ret;
+
+	plca_cfg->enabled = !!(ret & MDIO_OATC14_PLCA_EN);
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, MDIO_OATC14_PLCA_CTRL1);
+	if (ret < 0)
+		return ret;
+
+	plca_cfg->node_cnt = (ret & MDIO_OATC14_PLCA_NCNT) >> 8;
+	plca_cfg->node_id = (ret & MDIO_OATC14_PLCA_ID);
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, MDIO_OATC14_PLCA_TOTMR);
+	if (ret < 0)
+		return ret;
+
+	plca_cfg->to_tmr = ret & MDIO_OATC14_PLCA_TOT;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, MDIO_OATC14_PLCA_BURST);
+	if (ret < 0)
+		return ret;
+
+	plca_cfg->burst_cnt = (ret & MDIO_OATC14_PLCA_MAXBC) >> 8;
+	plca_cfg->burst_tmr = (ret & MDIO_OATC14_PLCA_BTMR);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(genphy_c45_plca_get_cfg);
+
+/**
+ * genphy_c45_plca_set_cfg - set PLCA configuration using standard registers
+ * @phydev: target phy_device struct
+ * @plca_cfg: structure containing the PLCA configuration. Fields set to -1 are
+ * not to be changed.
+ *
+ * Description: if the PHY complies to the Open Alliance TC14 10BASE-T1S PLCA
+ *   Management Registers specifications, this function can be used to modify
+ *   the PLCA configuration using the standard registers in MMD 31.
+ */
+int genphy_c45_plca_set_cfg(struct phy_device *phydev,
+			    const struct phy_plca_cfg *plca_cfg)
+{
+	int ret;
+	u16 val;
+
+	// PLCA IDVER is read-only
+	if (plca_cfg->version >= 0)
+		return -EINVAL;
+
+	// first of all, disable PLCA if required
+	if (plca_cfg->enabled == 0) {
+		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2,
+					 MDIO_OATC14_PLCA_CTRL0,
+					 MDIO_OATC14_PLCA_EN);
+
+		if (ret < 0)
+			return ret;
+	}
+
+	if (plca_cfg->node_cnt >= 0 || plca_cfg->node_id >= 0) {
+		if (plca_cfg->node_cnt < 0 || plca_cfg->node_id < 0) {
+			ret = phy_read_mmd(phydev, MDIO_MMD_VEND2,
+					   MDIO_OATC14_PLCA_CTRL1);
+
+			if (ret < 0)
+				return ret;
+
+			val = ret;
+		}
+
+		if (plca_cfg->node_cnt >= 0)
+			val = (val & ~MDIO_OATC14_PLCA_NCNT) |
+			      (plca_cfg->node_cnt << 8);
+
+		if (plca_cfg->node_id >= 0)
+			val = (val & ~MDIO_OATC14_PLCA_ID) |
+			      (plca_cfg->node_id);
+
+		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2,
+				    MDIO_OATC14_PLCA_CTRL1, val);
+
+		if (ret < 0)
+			return ret;
+	}
+
+	if (plca_cfg->to_tmr >= 0) {
+		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2,
+				    MDIO_OATC14_PLCA_TOTMR,
+				    plca_cfg->to_tmr);
+
+		if (ret < 0)
+			return ret;
+	}
+
+	if (plca_cfg->burst_cnt >= 0 || plca_cfg->burst_tmr >= 0) {
+		if (plca_cfg->burst_cnt < 0 || plca_cfg->burst_tmr < 0) {
+			ret = phy_read_mmd(phydev, MDIO_MMD_VEND2,
+					   MDIO_OATC14_PLCA_BURST);
+
+			if (ret < 0)
+				return ret;
+
+			val = ret;
+		}
+
+		if (plca_cfg->burst_cnt >= 0)
+			val = (val & ~MDIO_OATC14_PLCA_MAXBC) |
+			      (plca_cfg->burst_cnt << 8);
+
+		if (plca_cfg->burst_tmr >= 0)
+			val = (val & ~MDIO_OATC14_PLCA_BTMR) |
+			      (plca_cfg->burst_tmr);
+
+		ret = phy_write_mmd(phydev, MDIO_MMD_VEND2,
+				    MDIO_OATC14_PLCA_BURST, val);
+
+		if (ret < 0)
+			return ret;
+	}
+
+	// if we need to enable PLCA, do it at the end
+	if (plca_cfg->enabled > 0) {
+		ret = phy_set_bits_mmd(phydev, MDIO_MMD_VEND2,
+				       MDIO_OATC14_PLCA_CTRL0,
+				       MDIO_OATC14_PLCA_EN);
+
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(genphy_c45_plca_set_cfg);
+
+/**
+ * genphy_c45_plca_get_status - get PLCA status from standard registers
+ * @phydev: target phy_device struct
+ * @plca_st: output structure to store the PLCA status
+ *
+ * Description: if the PHY complies to the Open Alliance TC14 10BASE-T1S PLCA
+ *   Management Registers specifications, this function can be used to retrieve
+ *   the current PLCA status information from the standard registers in MMD 31.
+ */
+int genphy_c45_plca_get_status(struct phy_device *phydev,
+			       struct phy_plca_status *plca_st)
+{
+	int ret;
+
+	ret = phy_read_mmd(phydev, MDIO_MMD_VEND2, MDIO_OATC14_PLCA_STATUS);
+	if (ret < 0)
+		return ret;
+
+	plca_st->pst = !!(ret & MDIO_OATC14_PLCA_PST);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(genphy_c45_plca_get_status);
+
 struct phy_driver genphy_c45_driver = {
 	.phy_id         = 0xffffffff,
 	.phy_id_mask    = 0xffffffff,
diff --git a/include/linux/phy.h b/include/linux/phy.h
index bcaf1dfd0687..23aa23cde940 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1748,6 +1748,12 @@ int genphy_c45_loopback(struct phy_device *phydev, bool enable);
 int genphy_c45_pma_resume(struct phy_device *phydev);
 int genphy_c45_pma_suspend(struct phy_device *phydev);
 int genphy_c45_fast_retrain(struct phy_device *phydev, bool enable);
+int genphy_c45_plca_get_cfg(struct phy_device *phydev,
+			    struct phy_plca_cfg *plca_cfg);
+int genphy_c45_plca_set_cfg(struct phy_device *phydev,
+			    const struct phy_plca_cfg *plca_cfg);
+int genphy_c45_plca_get_status(struct phy_device *phydev,
+			       struct phy_plca_status *plca_st);
 
 /* Generic C45 PHY driver */
 extern struct phy_driver genphy_c45_driver;
-- 
2.37.4

