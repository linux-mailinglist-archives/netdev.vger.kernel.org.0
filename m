Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA5D2FCB20
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 07:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbhATGj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 01:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729013AbhATGbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 01:31:44 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84933C061575;
        Tue, 19 Jan 2021 22:31:01 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id m13so24708549ljo.11;
        Tue, 19 Jan 2021 22:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5xyhkMLv7lsuxUA/qMUHS/r8sCgAc6g5ImcxTeO7P6g=;
        b=GEdP9KjKNA6p8Gp1rSGwFkuhxiQVOlIqWcfjr/dhHk76qQZ6Shiwo25J073DNdWYYT
         ZAuxUwFwgUA+bBFZvaijyK9FuIcxc+L7YzPhgv7TXkVHUOtR4HDC01NV3CX9+6foAFwq
         XXEDCtnRgwNrZZrESaKSuFUI/jvivRIjt7oEEZxefPmMy5mgSkMZJElI2ipwnhOgoY9X
         DjeNIdqF3YpRmtdItEuVDfv/hIxgPUR++jvmcc/VuJSqqhLDLM2f3HryoXY1k6uwJNp6
         FHKhcBAWbuNuk6dcjXD3QEUgzWKEU8feyu2cVJKst1SZiKCmJ6ajL/CGJLSiJDiYLj7g
         SPww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5xyhkMLv7lsuxUA/qMUHS/r8sCgAc6g5ImcxTeO7P6g=;
        b=rDEI94sJ1+wgWJh/dRQMCAjJFhn6HJ/uufBouG1RTZeWvoQBYydCu5YRmBM6vtYi8z
         ydapqjCwJxnS9t8Wyb37pujA3+kB8SEAmBWbaqXqmruRaY8KtPTR6TOpW8EY3Tm/Gp/V
         pVPv7c1begeg4CZswvUpg6WhOi/18Bk6W2cQvqQkZ9JHjObVGXCA1UZHL6hYf/aDDQT9
         PfR7EjDByY2ryrzJ4ISuQPQWzDtynFUseXNym/rGPeWsjdF/X2IOcwfyOIoMoXvJRF0Z
         2EN3sg27VSiZxsBZ7vFdqCNffzAAlzlyfVaX1ZgY+jd5iMubIcwxX/G1Q3NNzNSyMtg/
         aMAA==
X-Gm-Message-State: AOAM531tbhLvJEHzdxSZkKSHV0Mhcg1wQFNTxdr92961kRu3EYCAF1Go
        eFO+IlBRCsJirhishcRglYmkzNdO6K9+Jg==
X-Google-Smtp-Source: ABdhPJxFgZ454pqzOlMbnZ6uDB7UarLAB6hG+phtZE/EzIDdIatT/6fBjpJ0Gd0+15Uu+O7iFIkvag==
X-Received: by 2002:a2e:9847:: with SMTP id e7mr3625692ljj.388.1611124259585;
        Tue, 19 Jan 2021 22:30:59 -0800 (PST)
Received: from localhost.localdomain ([185.188.71.122])
        by smtp.gmail.com with ESMTPSA id l3sm109371lfd.119.2021.01.19.22.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 22:30:58 -0800 (PST)
From:   Pawel Dembicki <paweldembicki@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Linus Wallej <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] dsa: vsc73xx: add support for vlan filtering
Date:   Wed, 20 Jan 2021 07:30:18 +0100
Message-Id: <20210120063019.1989081-1-paweldembicki@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for vlan filtering in vsc73xx driver.

After vlan filtering enable, CPU_PORT is configured as trunk, without
non-tagged frames. This allows to avoid problems with transmit untagged
frames because vsc73xx is DSA_TAG_PROTO_NONE.

Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
---
 drivers/net/dsa/vitesse-vsc73xx-core.c | 311 ++++++++++++++++++++++++-
 1 file changed, 310 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
index 19ce4aa0973b..bf805eb9d3a6 100644
--- a/drivers/net/dsa/vitesse-vsc73xx-core.c
+++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
@@ -39,6 +39,7 @@
 #define VSC73XX_BLOCK_SYSTEM	0x7 /* Only subblock 0 */
 
 #define CPU_PORT	6 /* CPU port */
+#define VLAN_TABLE_ATTEMPTS	10
 
 /* MAC Block registers */
 #define VSC73XX_MAC_CFG		0x00
@@ -62,6 +63,8 @@
 #define VSC73XX_CAT_DROP	0x6e
 #define VSC73XX_CAT_PR_MISC_L2	0x6f
 #define VSC73XX_CAT_PR_USR_PRIO	0x75
+#define VSC73XX_CAT_VLAN_MISC	0x79
+#define VSC73XX_CAT_PORT_VLAN	0x7a
 #define VSC73XX_Q_MISC_CONF	0xdf
 
 /* MAC_CFG register bits */
@@ -122,6 +125,17 @@
 #define VSC73XX_ADVPORTM_IO_LOOPBACK	BIT(1)
 #define VSC73XX_ADVPORTM_HOST_LOOPBACK	BIT(0)
 
+/* TXUPDCFG transmit modify setup bits */
+#define VSC73XX_TXUPDCFG_DSCP_REWR_MODE		GENMASK(20, 19)
+#define VSC73XX_TXUPDCFG_DSCP_REWR_ENA		BIT(18)
+#define VSC73XX_TXUPDCFG_TX_INT_TO_USRPRIO_ENA	BIT(17)
+#define VSC73XX_TXUPDCFG_TX_UNTAGGED_VID	GENMASK(15, 4)
+#define VSC73XX_TXUPDCFG_TX_UNTAGGED_VID_ENA	BIT(3)
+#define VSC73XX_TXUPDCFG_TX_UPDATE_CRC_CPU_ENA	BIT(1)
+#define VSC73XX_TXUPDCFG_TX_INSERT_TAG		BIT(0)
+
+#define VSC73XX_TXUPDCFG_TX_UNTAGGED_VID_SHIFT	4
+
 /* CAT_DROP categorizer frame dropping register bits */
 #define VSC73XX_CAT_DROP_DROP_MC_SMAC_ENA	BIT(6)
 #define VSC73XX_CAT_DROP_FWD_CTRL_ENA		BIT(4)
@@ -135,6 +149,15 @@
 #define VSC73XX_Q_MISC_CONF_EARLY_TX_512	(1 << 1)
 #define VSC73XX_Q_MISC_CONF_MAC_PAUSE_MODE	BIT(0)
 
+/* CAT_VLAN_MISC categorizer VLAN miscellaneous bits*/
+#define VSC73XX_CAT_VLAN_MISC_VLAN_TCI_IGNORE_ENA	BIT(8)
+#define VSC73XX_CAT_VLAN_MISC_VLAN_KEEP_TAG_ENA		BIT(7)
+
+/* CAT_PORT_VLAN categorizer port VLAN*/
+#define VSC73XX_CAT_PORT_VLAN_VLAN_CFI		BIT(15)
+#define VSC73XX_CAT_PORT_VLAN_VLAN_USR_PRIO	GENMASK(14, 12)
+#define VSC73XX_CAT_PORT_VLAN_VLAN_VID		GENMASK(11, 0)
+
 /* Frame analyzer block 2 registers */
 #define VSC73XX_STORMLIMIT	0x02
 #define VSC73XX_ADVLEARN	0x03
@@ -185,7 +208,8 @@
 #define VSC73XX_VLANACCESS_VLAN_MIRROR		BIT(29)
 #define VSC73XX_VLANACCESS_VLAN_SRC_CHECK	BIT(28)
 #define VSC73XX_VLANACCESS_VLAN_PORT_MASK	GENMASK(9, 2)
-#define VSC73XX_VLANACCESS_VLAN_TBL_CMD_MASK	GENMASK(2, 0)
+#define VSC73XX_VLANACCESS_VLAN_PORT_MASK_SHIFT	2
+#define VSC73XX_VLANACCESS_VLAN_TBL_CMD_MASK	GENMASK(1, 0)
 #define VSC73XX_VLANACCESS_VLAN_TBL_CMD_IDLE	0
 #define VSC73XX_VLANACCESS_VLAN_TBL_CMD_READ_ENTRY	1
 #define VSC73XX_VLANACCESS_VLAN_TBL_CMD_WRITE_ENTRY	2
@@ -557,6 +581,287 @@ static enum dsa_tag_protocol vsc73xx_get_tag_protocol(struct dsa_switch *ds,
 	return DSA_TAG_PROTO_NONE;
 }
 
+static int
+vsc73xx_port_wait_for_vlan_table_cmd(struct vsc73xx *vsc, int attempts)
+{
+	u32 val;
+	int i;
+
+	for (i = 0; i <= attempts; i++) {
+		vsc73xx_read(vsc, VSC73XX_BLOCK_ANALYZER, 0, VSC73XX_VLANACCESS,
+			     &val);
+		if ((val & VSC73XX_VLANACCESS_VLAN_TBL_CMD_MASK) ==
+		    VSC73XX_VLANACCESS_VLAN_TBL_CMD_IDLE)
+			return 0;
+	}
+	return -EBUSY;
+}
+
+static int
+vsc73xx_port_read_vlan_table_entry(struct dsa_switch *ds, u16 vid, u8 *portmap)
+{
+	struct vsc73xx *vsc = ds->priv;
+	u32 val;
+	int ret;
+
+	if (vid > 4095)
+		return -EPERM;
+	vsc73xx_write(vsc, VSC73XX_BLOCK_ANALYZER, 0, VSC73XX_VLANTIDX, vid);
+	ret = vsc73xx_port_wait_for_vlan_table_cmd(vsc, VLAN_TABLE_ATTEMPTS);
+	if (ret)
+		return ret;
+	vsc73xx_update_bits(vsc, VSC73XX_BLOCK_ANALYZER, 0, VSC73XX_VLANACCESS,
+			    VSC73XX_VLANACCESS_VLAN_TBL_CMD_MASK,
+			    VSC73XX_VLANACCESS_VLAN_TBL_CMD_READ_ENTRY);
+	ret = vsc73xx_port_wait_for_vlan_table_cmd(vsc, VLAN_TABLE_ATTEMPTS);
+	if (ret)
+		return ret;
+	vsc73xx_read(vsc, VSC73XX_BLOCK_ANALYZER, 0, VSC73XX_VLANACCESS, &val);
+	*portmap =
+	    (val & VSC73XX_VLANACCESS_VLAN_PORT_MASK) >>
+	    VSC73XX_VLANACCESS_VLAN_PORT_MASK_SHIFT;
+	return 0;
+}
+
+static int
+vsc73xx_port_write_vlan_table_entry(struct dsa_switch *ds, u16 vid, u8 portmap)
+{
+	struct vsc73xx *vsc = ds->priv;
+	int ret;
+
+	if (vid > 4095)
+		return -EPERM;
+	vsc73xx_write(vsc, VSC73XX_BLOCK_ANALYZER, 0, VSC73XX_VLANTIDX, vid);
+	ret = vsc73xx_port_wait_for_vlan_table_cmd(vsc, VLAN_TABLE_ATTEMPTS);
+	if (ret)
+		return ret;
+	vsc73xx_update_bits(vsc, VSC73XX_BLOCK_ANALYZER, 0, VSC73XX_VLANACCESS,
+			    VSC73XX_VLANACCESS_VLAN_SRC_CHECK |
+			    VSC73XX_VLANACCESS_VLAN_TBL_CMD_MASK |
+			    VSC73XX_VLANACCESS_VLAN_PORT_MASK,
+			    VSC73XX_VLANACCESS_VLAN_SRC_CHECK |
+			    VSC73XX_VLANACCESS_VLAN_TBL_CMD_WRITE_ENTRY |
+			    (portmap <<
+			     VSC73XX_VLANACCESS_VLAN_PORT_MASK_SHIFT));
+	ret = vsc73xx_port_wait_for_vlan_table_cmd(vsc, VLAN_TABLE_ATTEMPTS);
+	if (ret)
+		return ret;
+	return 0;
+}
+
+static int
+vsc73xx_port_update_vlan_table(struct dsa_switch *ds, int port, u16 vid_begin,
+			       u16 vid_end, bool set)
+{
+	u8 portmap;
+	int ret;
+	u16 i;
+
+	if (vid_begin > 4095 || vid_end > 4095 || vid_begin > vid_end)
+		return -EPERM;
+
+	for (i = vid_begin; i <= vid_end; i++) {
+		ret = vsc73xx_port_read_vlan_table_entry(ds, i, &portmap);
+		if (ret)
+			return ret;
+		if (set)
+			portmap |= BIT(port);
+		else
+			portmap &= ~BIT(port);
+
+		ret = vsc73xx_port_write_vlan_table_entry(ds, i, portmap);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static int vsc73xx_port_set_vlan_unaware(struct dsa_switch *ds, int port)
+{
+	struct vsc73xx *vsc = ds->priv;
+	int ret;
+
+	vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_MAC_CFG,
+			    VSC73XX_MAC_CFG_VLAN_AWR,
+			    ~VSC73XX_MAC_CFG_VLAN_AWR);
+	vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_MAC_CFG,
+			    VSC73XX_MAC_CFG_VLAN_DBLAWR,
+			    ~VSC73XX_MAC_CFG_VLAN_DBLAWR);
+	vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_CAT_VLAN_MISC,
+			    VSC73XX_CAT_VLAN_MISC_VLAN_TCI_IGNORE_ENA,
+			    VSC73XX_CAT_VLAN_MISC_VLAN_TCI_IGNORE_ENA);
+	vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_CAT_VLAN_MISC,
+			    VSC73XX_CAT_VLAN_MISC_VLAN_KEEP_TAG_ENA,
+			    VSC73XX_CAT_VLAN_MISC_VLAN_KEEP_TAG_ENA);
+	vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_CAT_DROP,
+			    VSC73XX_CAT_DROP_TAGGED_ENA,
+			    ~VSC73XX_CAT_DROP_TAGGED_ENA);
+	vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_CAT_DROP,
+			    VSC73XX_CAT_DROP_UNTAGGED_ENA,
+			    ~VSC73XX_CAT_DROP_UNTAGGED_ENA);
+
+	ret = vsc73xx_port_update_vlan_table(ds, port, 0, 4095, 0);
+	return ret;
+}
+
+static int vsc73xx_port_set_vlan_aware(struct dsa_switch *ds, int port)
+{
+	struct vsc73xx *vsc = ds->priv;
+	int ret;
+
+	vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_MAC_CFG,
+			    VSC73XX_MAC_CFG_VLAN_AWR, VSC73XX_MAC_CFG_VLAN_AWR);
+	vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_MAC_CFG,
+			    VSC73XX_MAC_CFG_VLAN_DBLAWR,
+			    ~VSC73XX_MAC_CFG_VLAN_DBLAWR);
+	vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_CAT_VLAN_MISC,
+			    VSC73XX_CAT_VLAN_MISC_VLAN_TCI_IGNORE_ENA,
+			    ~VSC73XX_CAT_VLAN_MISC_VLAN_TCI_IGNORE_ENA);
+	vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_CAT_VLAN_MISC,
+			    VSC73XX_CAT_VLAN_MISC_VLAN_KEEP_TAG_ENA,
+			    ~VSC73XX_CAT_VLAN_MISC_VLAN_KEEP_TAG_ENA);
+	vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_CAT_DROP,
+			    VSC73XX_CAT_DROP_TAGGED_ENA,
+			    ~VSC73XX_CAT_DROP_TAGGED_ENA);
+	vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_CAT_DROP,
+			    VSC73XX_CAT_DROP_UNTAGGED_ENA,
+			    VSC73XX_CAT_DROP_UNTAGGED_ENA);
+	vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_TXUPDCFG,
+			    VSC73XX_TXUPDCFG_TX_INSERT_TAG,
+			    VSC73XX_TXUPDCFG_TX_INSERT_TAG);
+	vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port, VSC73XX_TXUPDCFG,
+			    VSC73XX_TXUPDCFG_TX_UNTAGGED_VID_ENA,
+			    ~VSC73XX_TXUPDCFG_TX_UNTAGGED_VID_ENA);
+
+	if (port == CPU_PORT)
+		ret = vsc73xx_port_update_vlan_table(ds, port, 0, 4095, 1);
+	else
+		ret = vsc73xx_port_update_vlan_table(ds, port, 0, 4095, 0);
+	return ret;
+}
+
+static int
+vsc73xx_port_vlan_filtering(struct dsa_switch *ds, int port,
+			    bool vlan_filtering, struct switchdev_trans *trans)
+{
+	int ret;
+
+	if (switchdev_trans_ph_prepare(trans))
+		return 0;
+
+	if (vlan_filtering) {
+		ret = vsc73xx_port_set_vlan_aware(ds, port);
+		if (ret)
+			return ret;
+		ret = vsc73xx_port_set_vlan_aware(ds, CPU_PORT);
+	} else {
+		ret = vsc73xx_port_set_vlan_unaware(ds, port);
+	}
+	return ret;
+}
+
+static int vsc73xx_port_vlan_prepare(struct dsa_switch *ds, int port,
+				     const struct switchdev_obj_port_vlan *vlan)
+{
+	/* nothing needed */
+	return 0;
+}
+
+static void vsc73xx_port_vlan_add(struct dsa_switch *ds, int port,
+				  const struct switchdev_obj_port_vlan *vlan)
+{
+	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
+	struct vsc73xx *vsc = ds->priv;
+	int ret;
+	u32 tmp;
+
+	if (!dsa_port_is_vlan_filtering(dsa_to_port(ds, port)))
+		return;
+
+	ret = vsc73xx_port_update_vlan_table(ds, port, vlan->vid_begin,
+					     vlan->vid_end, 1);
+	if (ret)
+		return;
+
+	if (untagged && port != CPU_PORT) {
+		/* VSC73xx can have only one untagged vid per port. */
+		vsc73xx_read(vsc, VSC73XX_BLOCK_MAC, port,
+			     VSC73XX_TXUPDCFG, &tmp);
+
+		if (tmp & VSC73XX_TXUPDCFG_TX_UNTAGGED_VID_ENA)
+			dev_warn(vsc->dev,
+				 "Chip support only one untagged VID per port. Overwriting...\n");
+
+		vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port,
+				    VSC73XX_TXUPDCFG,
+				    VSC73XX_TXUPDCFG_TX_UNTAGGED_VID,
+				    (vlan->vid_end <<
+				    VSC73XX_TXUPDCFG_TX_UNTAGGED_VID_SHIFT) &
+				    VSC73XX_TXUPDCFG_TX_UNTAGGED_VID);
+		vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port,
+				    VSC73XX_TXUPDCFG,
+				    VSC73XX_TXUPDCFG_TX_UNTAGGED_VID_ENA,
+				    VSC73XX_TXUPDCFG_TX_UNTAGGED_VID_ENA);
+	}
+	if (pvid && port != CPU_PORT) {
+		vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port,
+				    VSC73XX_CAT_DROP,
+				    VSC73XX_CAT_DROP_UNTAGGED_ENA,
+				    ~VSC73XX_CAT_DROP_UNTAGGED_ENA);
+		vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port,
+				    VSC73XX_CAT_PORT_VLAN,
+				    VSC73XX_CAT_PORT_VLAN_VLAN_VID,
+				    vlan->vid_end &
+				    VSC73XX_CAT_PORT_VLAN_VLAN_VID);
+	}
+}
+
+static int vsc73xx_port_vlan_del(struct dsa_switch *ds, int port,
+				 const struct switchdev_obj_port_vlan *vlan)
+{
+	bool untagged = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
+	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
+	struct vsc73xx *vsc = ds->priv;
+	u32 tmp, untagged_vid;
+	int ret;
+
+	if (!dsa_port_is_vlan_filtering(dsa_to_port(ds, port)))
+		return -EINVAL;
+
+	ret =
+	    vsc73xx_port_update_vlan_table(ds, port, vlan->vid_begin,
+					   vlan->vid_end, 0);
+	if (ret)
+		return ret;
+
+	/* VSC73xx can have only one untagged vid per port. Check if match. */
+	vsc73xx_read(vsc, VSC73XX_BLOCK_MAC, port,
+		     VSC73XX_TXUPDCFG, &tmp);
+	untagged_vid = (tmp & VSC73XX_TXUPDCFG_TX_UNTAGGED_VID)
+		      >> VSC73XX_TXUPDCFG_TX_UNTAGGED_VID_SHIFT;
+
+	if (untagged && untagged_vid == vlan->vid_end) {
+		vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port,
+				    VSC73XX_TXUPDCFG,
+				    VSC73XX_TXUPDCFG_TX_UNTAGGED_VID_ENA,
+				    ~VSC73XX_TXUPDCFG_TX_UNTAGGED_VID_ENA);
+		vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port,
+				    VSC73XX_TXUPDCFG,
+				    VSC73XX_TXUPDCFG_TX_UNTAGGED_VID, 0);
+	}
+	if (pvid) {
+		vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port,
+				    VSC73XX_CAT_DROP,
+				    VSC73XX_CAT_DROP_UNTAGGED_ENA,
+				    VSC73XX_CAT_DROP_UNTAGGED_ENA);
+		vsc73xx_update_bits(vsc, VSC73XX_BLOCK_MAC, port,
+				    VSC73XX_CAT_PORT_VLAN,
+				    VSC73XX_CAT_PORT_VLAN_VLAN_VID, 0);
+	}
+	return 0;
+}
+
 static int vsc73xx_setup(struct dsa_switch *ds)
 {
 	struct vsc73xx *vsc = ds->priv;
@@ -1051,6 +1356,10 @@ static const struct dsa_switch_ops vsc73xx_ds_ops = {
 	.port_disable = vsc73xx_port_disable,
 	.port_change_mtu = vsc73xx_change_mtu,
 	.port_max_mtu = vsc73xx_get_max_mtu,
+	.port_vlan_filtering = vsc73xx_port_vlan_filtering,
+	.port_vlan_prepare = vsc73xx_port_vlan_prepare,
+	.port_vlan_add = vsc73xx_port_vlan_add,
+	.port_vlan_del = vsc73xx_port_vlan_del,
 };
 
 static int vsc73xx_gpio_get(struct gpio_chip *chip, unsigned int offset)
-- 
2.25.1

