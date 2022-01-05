Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232BD484CC9
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 04:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237212AbiAEDQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 22:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235819AbiAEDQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 22:16:07 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8F8C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 19:16:07 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id e25so31253397qkl.12
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 19:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NjjYxIWZ3/SYEO84Ek6ILDsNAoDCYNe5Zcpftmwl8Wo=;
        b=DL1f6E5nsE5cC/bN5Obbx2SRN0QKwSs06PT+YHCOtOkg3kuRnIohMyPGtMYySCnnZV
         YhYwUDS59cpgSy7FKjkc256lfSA3BF4EYmy8zRewB6dfFgNU9XXzvjRUh4IN/KeEr63n
         6p/pLA0+Mff3J4Bgy7ik2WT8v8VSweBqkC30sEGvZVdjLEEjb4rwfU6DrQXYQu72Uktq
         pTyu3tK4gmMbp4RuHClupSJqx3HmUvdhjIUOQHaYgtwGPPW7cRCgJlFsKBEaw07RvPAQ
         6F0TvEhVpPlDDk6Bad4xN90zkGpOs+4jFY3aZnkbV0R+i27jlm5WAoUv28c7rfsjJj8e
         guPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NjjYxIWZ3/SYEO84Ek6ILDsNAoDCYNe5Zcpftmwl8Wo=;
        b=BGQ0aGgCQG6loHZ5famxnpxNzAuh2th2IaRdtv6BY/t8cbAfRYnI48idh7/QvYOE/9
         U2of/oNJPcHSlGeAxmCENu4B4kYEJs9nUg9NKSzSHyFgQgK98Pllpg3O868omn0M19R8
         fp9VhnzDTMDChBkykOVbHSnGLGQqprnoGOxHjuIyxgC1Kaol4bVtf+3ff6nxPqktcfJI
         H9YNYRk/hjykMmgUbinwYfZob4W/nsnVHoox4cSyIhYCy1tPXgeqgbGu6TeEwc/oGi/7
         gX8BM94v52NdG4O56SpVBF81IZU7CJL0k7VWhA7Kwypa3I4Tv/9hh/ORkSw3z0jh52/j
         8mMg==
X-Gm-Message-State: AOAM533/RrFdesv+PFVC4Z0yYlJyBKgusdMZCxrp7li2Jbs+f7qqiBV8
        A9bm1HZ9r/Nol6VKRTwiLm5V8gbhvBOSNg7E
X-Google-Smtp-Source: ABdhPJynkzSPLQbG0VngYIbxhvjN3ZzQRBMBhAHRJ3WGXKoib6GQrzO0foiht1MCM03z0RNl7iOisA==
X-Received: by 2002:a05:620a:1a9e:: with SMTP id bl30mr37613982qkb.130.1641352566468;
        Tue, 04 Jan 2022 19:16:06 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br ([187.94.103.218])
        by smtp.gmail.com with ESMTPSA id t11sm32607629qkp.56.2022.01.04.19.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 19:16:05 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com, frank-w@public-files.de,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v4 07/11] net: dsa: realtek: rtl8365mb: rename extport to extint, add "realtek,ext-int"
Date:   Wed,  5 Jan 2022 00:15:11 -0300
Message-Id: <20220105031515.29276-8-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20220105031515.29276-1-luizluca@gmail.com>
References: <20220105031515.29276-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"extport" 0, 1, 2 was used to reference external ports (ext0,
ext1, ext2). Meanwhile, port 0..9 is used as switch ports,
including external ports. "extport" was renamed to extint to
make it clear it does not mean the port number but the external
interface number.

The macros that map extint numbers to registers addresses now
use inline ifs instead of binary arithmetic.

"extint" was hardcoded to 1. However, some chips have multiple
external interfaces. It's not right to assume the CPU port uses
extint 1 nor that all extint are CPU ports. Now the association
between the port and the external interface can be defined with
a device-tree port property "realtek,ext-int".

This patch still does not allow multiple CPU ports nor extint
as a non CPU port.

Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/realtek/rtl8365mb.c | 135 ++++++++++++++++++----------
 1 file changed, 88 insertions(+), 47 deletions(-)

diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 11a985900c57..e115129cd5cd 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -191,7 +191,13 @@
 /* The PHY OCP addresses of PHY registers 0~31 start here */
 #define RTL8365MB_PHY_OCP_ADDR_PHYREG_BASE		0xA400
 
-/* EXT port interface mode values - used in DIGITAL_INTERFACE_SELECT */
+/* EXT interface numbers */
+#define RTL8365MB_NOT_EXT			-1
+#define RTL8365MB_EXT0				 0
+#define RTL8365MB_EXT1				 1
+#define RTL8365MB_EXT2				 2
+
+/* EXT interface port mode values - used in DIGITAL_INTERFACE_SELECT */
 #define RTL8365MB_EXT_PORT_MODE_DISABLE		0
 #define RTL8365MB_EXT_PORT_MODE_RGMII		1
 #define RTL8365MB_EXT_PORT_MODE_MII_MAC		2
@@ -207,39 +213,44 @@
 #define RTL8365MB_EXT_PORT_MODE_1000X		12
 #define RTL8365MB_EXT_PORT_MODE_100FX		13
 
-/* EXT port interface mode configuration registers 0~1 */
-#define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG0		0x1305
-#define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG1		0x13C3
-#define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(_extport)   \
-		(RTL8365MB_DIGITAL_INTERFACE_SELECT_REG0 + \
-		 ((_extport) >> 1) * (0x13C3 - 0x1305))
-#define   RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK(_extport) \
-		(0xF << (((_extport) % 2)))
-#define   RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_OFFSET(_extport) \
-		(((_extport) % 2) * 4)
-
-/* EXT port RGMII TX/RX delay configuration registers 1~2 */
-#define RTL8365MB_EXT_RGMXF_REG1		0x1307
-#define RTL8365MB_EXT_RGMXF_REG2		0x13C5
-#define RTL8365MB_EXT_RGMXF_REG(_extport)   \
-		(RTL8365MB_EXT_RGMXF_REG1 + \
-		 (((_extport) >> 1) * (0x13C5 - 0x1307)))
+/* EXT interface mode configuration registers 0~1 */
+#define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG0		0x1305 /* EXT1 */
+#define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG1		0x13C3 /* EXT2 */
+#define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(_extint) \
+		((_extint) == 1 ? RTL8365MB_DIGITAL_INTERFACE_SELECT_REG0 : \
+		 (_extint) == 2 ? RTL8365MB_DIGITAL_INTERFACE_SELECT_REG1 : \
+		 0x0)
+#define   RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK(_extint) \
+		(0xF << (((_extint) % 2)))
+#define   RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_OFFSET(_extint) \
+		(((_extint) % 2) * 4)
+
+/* EXT interface RGMII TX/RX delay configuration registers 0~2 */
+#define RTL8365MB_EXT_RGMXF_REG0		0x1306 /* EXT0 */
+#define RTL8365MB_EXT_RGMXF_REG1		0x1307 /* EXT1 */
+#define RTL8365MB_EXT_RGMXF_REG2		0x13C5 /* EXT2 */
+#define RTL8365MB_EXT_RGMXF_REG(_extint) \
+		((_extint) == 0 ? RTL8365MB_EXT_RGMXF_REG0 : \
+		 (_extint) == 1 ? RTL8365MB_EXT_RGMXF_REG1 : \
+		 (_extint) == 2 ? RTL8365MB_EXT_RGMXF_REG2 : \
+		 0x0)
 #define   RTL8365MB_EXT_RGMXF_RXDELAY_MASK	0x0007
 #define   RTL8365MB_EXT_RGMXF_TXDELAY_MASK	0x0008
 
-/* External port speed values - used in DIGITAL_INTERFACE_FORCE */
+/* External interface port speed values - used in DIGITAL_INTERFACE_FORCE */
 #define RTL8365MB_PORT_SPEED_10M	0
 #define RTL8365MB_PORT_SPEED_100M	1
 #define RTL8365MB_PORT_SPEED_1000M	2
 
-/* EXT port force configuration registers 0~2 */
-#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG0			0x1310
-#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG1			0x1311
-#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG2			0x13C4
-#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG(_extport)   \
-		(RTL8365MB_DIGITAL_INTERFACE_FORCE_REG0 + \
-		 ((_extport) & 0x1) +                     \
-		 ((((_extport) >> 1) & 0x1) * (0x13C4 - 0x1310)))
+/* EXT interface force configuration registers 0~2 */
+#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG0		0x1310 /* EXT0 */
+#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG1		0x1311 /* EXT1 */
+#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG2		0x13C4 /* EXT2 */
+#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG(_extint) \
+		((_extint) == 0 ? RTL8365MB_DIGITAL_INTERFACE_FORCE_REG0 : \
+		 (_extint) == 1 ? RTL8365MB_DIGITAL_INTERFACE_FORCE_REG1 : \
+		 (_extint) == 2 ? RTL8365MB_DIGITAL_INTERFACE_FORCE_REG2 : \
+		 0x0)
 #define   RTL8365MB_DIGITAL_INTERFACE_FORCE_EN_MASK		0x1000
 #define   RTL8365MB_DIGITAL_INTERFACE_FORCE_NWAY_MASK		0x0080
 #define   RTL8365MB_DIGITAL_INTERFACE_FORCE_TXPAUSE_MASK	0x0040
@@ -522,6 +533,7 @@ struct rtl8365mb_cpu {
  *         access via rtl8365mb_get_stats64
  * @stats_lock: protect the stats structure during read/update
  * @mib_work: delayed work for polling MIB counters
+ * @ext_int: the external interface port related to this port, RTL8365MB_NOT_EXT(-1) if none
  */
 struct rtl8365mb_port {
 	struct realtek_priv *priv;
@@ -529,6 +541,7 @@ struct rtl8365mb_port {
 	struct rtnl_link_stats64 stats;
 	spinlock_t stats_lock;
 	struct delayed_work mib_work;
+	int ext_int;
 };
 
 /**
@@ -742,24 +755,28 @@ rtl8365mb_get_tag_protocol(struct dsa_switch *ds, int port,
 static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
 				      phy_interface_t interface)
 {
+	struct rtl8365mb_port *p;
 	struct device_node *dn;
+	struct rtl8365mb *mb;
 	struct dsa_port *dp;
 	int tx_delay = 0;
 	int rx_delay = 0;
-	int ext_port;
+	int ext_int;
 	u32 val;
 	int ret;
 
-	if (port == priv->cpu_port) {
-		ext_port = 1;
-	} else {
-		dev_err(priv->dev, "only one EXT port is currently supported\n");
+	if (port != priv->cpu_port) {
+		dev_err(priv->dev, "only one EXT interface is currently supported\n");
 		return -EINVAL;
 	}
 
 	dp = dsa_to_port(priv->ds, port);
 	dn = dp->dn;
 
+	mb = priv->chip_data;
+	p = &mb->ports[port];
+	ext_int = p->ext_int;
+
 	/* Set the RGMII TX/RX delay
 	 *
 	 * The Realtek vendor driver indicates the following possible
@@ -789,7 +806,7 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
 			tx_delay = val / 2;
 		else
 			dev_warn(priv->dev,
-				 "EXT port TX delay must be 0 or 2 ns\n");
+				 "EXT interface TX delay must be 0 or 2 ns\n");
 	}
 
 	if (!of_property_read_u32(dn, "rx-internal-delay-ps", &val)) {
@@ -799,11 +816,11 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
 			rx_delay = val;
 		else
 			dev_warn(priv->dev,
-				 "EXT port RX delay must be 0 to 2.1 ns\n");
+				 "EXT interface RX delay must be 0 to 2.1 ns\n");
 	}
 
 	ret = regmap_update_bits(
-		priv->map, RTL8365MB_EXT_RGMXF_REG(ext_port),
+		priv->map, RTL8365MB_EXT_RGMXF_REG(ext_int),
 		RTL8365MB_EXT_RGMXF_TXDELAY_MASK |
 			RTL8365MB_EXT_RGMXF_RXDELAY_MASK,
 		FIELD_PREP(RTL8365MB_EXT_RGMXF_TXDELAY_MASK, tx_delay) |
@@ -812,11 +829,11 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
 		return ret;
 
 	ret = regmap_update_bits(
-		priv->map, RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(ext_port),
-		RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK(ext_port),
+		priv->map, RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(ext_int),
+		RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK(ext_int),
 		RTL8365MB_EXT_PORT_MODE_RGMII
 			<< RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_OFFSET(
-				   ext_port));
+				   ext_int));
 	if (ret)
 		return ret;
 
@@ -827,22 +844,26 @@ static int rtl8365mb_ext_config_forcemode(struct realtek_priv *priv, int port,
 					  bool link, int speed, int duplex,
 					  bool tx_pause, bool rx_pause)
 {
+	struct rtl8365mb_port *p;
+	struct rtl8365mb *mb;
 	u32 r_tx_pause;
 	u32 r_rx_pause;
 	u32 r_duplex;
 	u32 r_speed;
 	u32 r_link;
-	int ext_port;
+	int ext_int;
 	int val;
 	int ret;
 
-	if (port == priv->cpu_port) {
-		ext_port = 1;
-	} else {
-		dev_err(priv->dev, "only one EXT port is currently supported\n");
+	if (port != priv->cpu_port) {
+		dev_err(priv->dev, "only one EXT interface is currently supported\n");
 		return -EINVAL;
 	}
 
+	mb = priv->chip_data;
+	p = &mb->ports[port];
+	ext_int = p->ext_int;
+
 	if (link) {
 		/* Force the link up with the desired configuration */
 		r_link = 1;
@@ -889,7 +910,7 @@ static int rtl8365mb_ext_config_forcemode(struct realtek_priv *priv, int port,
 			 r_duplex) |
 	      FIELD_PREP(RTL8365MB_DIGITAL_INTERFACE_FORCE_SPEED_MASK, r_speed);
 	ret = regmap_write(priv->map,
-			   RTL8365MB_DIGITAL_INTERFACE_FORCE_REG(ext_port),
+			   RTL8365MB_DIGITAL_INTERFACE_FORCE_REG(ext_int),
 			   val);
 	if (ret)
 		return ret;
@@ -1819,13 +1840,13 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 	/* Configure ports */
 	for (i = 0; i < priv->num_ports; i++) {
 		struct rtl8365mb_port *p = &mb->ports[i];
+		struct device_node *dn;
+		u32 val;
 
 		if (dsa_is_unused_port(priv->ds, i))
 			continue;
 
-		/* Set up per-port private data */
-		p->priv = priv;
-		p->index = i;
+		dn = dsa_to_port(priv->ds, i)->dn;
 
 		/* Forward only to the CPU */
 		ret = rtl8365mb_port_set_isolation(priv, i, BIT(priv->cpu_port));
@@ -1842,6 +1863,26 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 		 * administratively down by default.
 		 */
 		rtl8365mb_port_stp_state_set(priv->ds, i, BR_STATE_DISABLED);
+
+		/* Set up per-port private data */
+		p->priv = priv;
+		p->index = i;
+
+		if (!of_property_read_u32(dn, "realtek,ext-int", &val)) {
+			if (val < 0 || val > 2) {
+				dev_err(priv->dev,
+					"realtek,ext-int must be between 0 and 2\n");
+				return -EINVAL;
+			}
+
+			p->ext_int = val;
+		} else {
+			if (dsa_is_cpu_port(priv->ds, i))
+				/* Default for compatibility with older device trees */
+				p->ext_int = RTL8365MB_EXT1;
+			else
+				p->ext_int = RTL8365MB_NOT_EXT;
+		}
 	}
 
 	/* Set maximum packet length to 1536 bytes */
-- 
2.34.0

