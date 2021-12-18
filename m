Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586A047999E
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 09:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232355AbhLRIPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 03:15:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbhLRIPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 03:15:22 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561CEC06173E
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 00:15:22 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id a1so5000131qtx.11
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 00:15:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8u36XgVtNkMyNvk6j+feFMRyT8fFi9VF9B1e8z02rko=;
        b=hKWN23N7xS2ECkNqe5VJvVEFwqfE4K4EKaYVrz8+kezhfNVyTkS5/QuaeRf08cgeC/
         JvQR6vzeDssAYj/zMv3UErlY++IZ40SjXe52JRhifg0p8SH0ooqyaM4wi1TS5cb26zj2
         82gWopu7ZmgeYg2nW3v/lIhCdP+GUW6lPo61dLzYCQx2AiEae0DeGMspjS2QnZtVoq4D
         isC0ATAUXBmm0xnw53xG1tU402kWgQ2yZJfLYNldfHx4YBnqDpqe7bT4AXoBaaP3dqiR
         PZoJl8uA4jiTHmQwtkFYFWwNfhet1qCNDpgjf+XNzSI4O300isbNasNTZh4z1xCh4dCm
         OjBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8u36XgVtNkMyNvk6j+feFMRyT8fFi9VF9B1e8z02rko=;
        b=ptShCwnlYU9bLf0sblpVeldAgaxa112GU1e87hIcX5n/PjK+savFzUQpoh8Nv/kLuS
         jjQFp3dgUuXweEhekvkGqlAupP5kAKwAwb2PQUJSyqajBETWcGru4IbVGXXzCC1DRBpz
         7bYMupu8o/7eKUgXk47Ud39fubMIQipyZkrzscfA1062BIXDrbXUyf8ugFLHIGu2fX8d
         LbwnWRsajVPkyDWc2S89CsJPdcV+U4+GtE/Fw+1i4NrcMzoXrX+Iv8WmciWZ5rnWKd9s
         SF1c0RNhX8pB0hVzdm1hHOVwVHrEZanreSW+ZVfuVgACRPwyJz0TdjMHj6tTxXYtj0l7
         wqCQ==
X-Gm-Message-State: AOAM5303JWX9lKOTVnrM9XGQvisMI6VQQ5/YlF5QhwjBlBjHa7+7XzG6
        +8WOEm+TosNQvBxSuuVdh+smZG/5OQe57A==
X-Google-Smtp-Source: ABdhPJziUvtEtkfz9H1R2fgw/wR3hS4CTheXNw1oH37RscVgyZeO3dLnG3u6U8IgfggUciXybITPag==
X-Received: by 2002:a05:622a:185:: with SMTP id s5mr5453027qtw.299.1639815321067;
        Sat, 18 Dec 2021 00:15:21 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id f11sm6423357qko.84.2021.12.18.00.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Dec 2021 00:15:20 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>
Subject: [PATCH net-next v2 09/13] net: dsa: realtek: rtl8365mb: rename extport to extint, add "realtek,ext-int"
Date:   Sat, 18 Dec 2021 05:14:21 -0300
Message-Id: <20211218081425.18722-10-luizluca@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211218081425.18722-1-luizluca@gmail.com>
References: <20211216201342.25587-1-luizluca@gmail.com>
 <20211218081425.18722-1-luizluca@gmail.com>
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

"extint" was hardcoded to 1. Now it can be defined with a device-tree
port property "realtek,ext-int";

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
---
 .../bindings/net/dsa/realtek-smi.txt          |   4 +
 drivers/net/dsa/realtek/rtl8365mb.c           | 106 ++++++++++++------
 2 files changed, 74 insertions(+), 36 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt b/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
index ec96b4035ed5..310076be14b2 100644
--- a/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
+++ b/Documentation/devicetree/bindings/net/dsa/realtek-smi.txt
@@ -62,6 +62,10 @@ See net/mdio.txt for additional MDIO bus properties.
 See net/dsa/dsa.txt for a list of additional required and optional properties
 and subnodes of DSA switches.
 
+Optional properties of dsa port:
+
+- realtek,ext-int: defines the external interface number (0, 1, 2). By default, 1.
+
 Examples:
 
 An example for the RTL8366RB:
diff --git a/drivers/net/dsa/realtek/rtl8365mb.c b/drivers/net/dsa/realtek/rtl8365mb.c
index 11a985900c57..e87c60d9c8cb 100644
--- a/drivers/net/dsa/realtek/rtl8365mb.c
+++ b/drivers/net/dsa/realtek/rtl8365mb.c
@@ -208,22 +208,26 @@
 #define RTL8365MB_EXT_PORT_MODE_100FX		13
 
 /* EXT port interface mode configuration registers 0~1 */
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
+#define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG0		0x1305 /*EXT1*/
+#define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG1		0x13C3 /*EXT2*/
+#define RTL8365MB_DIGITAL_INTERFACE_SELECT_REG(_extint) \
+		((_extint) == 1 ? RTL8365MB_DIGITAL_INTERFACE_SELECT_REG0 : \
+		 (_extint) == 2 ? RTL8365MB_DIGITAL_INTERFACE_SELECT_REG1 : \
+		 0x0)
+#define   RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_MASK(_extint) \
+		(0xF << (((_extint) % 2)))
+#define   RTL8365MB_DIGITAL_INTERFACE_SELECT_MODE_OFFSET(_extint) \
+		(((_extint) % 2) * 4)
+
+/* EXT port RGMII TX/RX delay configuration registers 0~2 */
+#define RTL8365MB_EXT_RGMXF_REG0		0x1306 /*EXT0*/
+#define RTL8365MB_EXT_RGMXF_REG1		0x1307 /*EXT1*/
+#define RTL8365MB_EXT_RGMXF_REG2		0x13C5 /*EXT2*/
+#define RTL8365MB_EXT_RGMXF_REG(_extint) \
+		((_extint) == 0 ? RTL8365MB_EXT_RGMXF_REG0 : \
+		 (_extint) == 1 ? RTL8365MB_EXT_RGMXF_REG1 : \
+		 (_extint) == 2 ? RTL8365MB_EXT_RGMXF_REG2 : \
+		 0x0)
 #define   RTL8365MB_EXT_RGMXF_RXDELAY_MASK	0x0007
 #define   RTL8365MB_EXT_RGMXF_TXDELAY_MASK	0x0008
 
@@ -233,13 +237,14 @@
 #define RTL8365MB_PORT_SPEED_1000M	2
 
 /* EXT port force configuration registers 0~2 */
-#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG0			0x1310
-#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG1			0x1311
-#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG2			0x13C4
-#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG(_extport)   \
-		(RTL8365MB_DIGITAL_INTERFACE_FORCE_REG0 + \
-		 ((_extport) & 0x1) +                     \
-		 ((((_extport) >> 1) & 0x1) * (0x13C4 - 0x1310)))
+#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG0		0x1310 /*EXT0*/
+#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG1		0x1311 /*EXT1*/
+#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG2		0x13C4 /*EXT2*/
+#define RTL8365MB_DIGITAL_INTERFACE_FORCE_REG(_extint) \
+		((_extint) == 0 ? RTL8365MB_DIGITAL_INTERFACE_FORCE_REG0 : \
+		 (_extint) == 1 ? RTL8365MB_DIGITAL_INTERFACE_FORCE_REG1 : \
+		 (_extint) == 2 ? RTL8365MB_DIGITAL_INTERFACE_FORCE_REG2 : \
+		 0x0)
 #define   RTL8365MB_DIGITAL_INTERFACE_FORCE_EN_MASK		0x1000
 #define   RTL8365MB_DIGITAL_INTERFACE_FORCE_NWAY_MASK		0x0080
 #define   RTL8365MB_DIGITAL_INTERFACE_FORCE_TXPAUSE_MASK	0x0040
@@ -522,6 +527,7 @@ struct rtl8365mb_cpu {
  *         access via rtl8365mb_get_stats64
  * @stats_lock: protect the stats structure during read/update
  * @mib_work: delayed work for polling MIB counters
+ * @ext_int: the external interface related to this port (-1 to none)
  */
 struct rtl8365mb_port {
 	struct realtek_priv *priv;
@@ -529,6 +535,7 @@ struct rtl8365mb_port {
 	struct rtnl_link_stats64 stats;
 	spinlock_t stats_lock;
 	struct delayed_work mib_work;
+	int ext_int;
 };
 
 /**
@@ -742,17 +749,17 @@ rtl8365mb_get_tag_protocol(struct dsa_switch *ds, int port,
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
+	if (port != priv->cpu_port) {
 		dev_err(priv->dev, "only one EXT port is currently supported\n");
 		return -EINVAL;
 	}
@@ -760,6 +767,10 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
 	dp = dsa_to_port(priv->ds, port);
 	dn = dp->dn;
 
+	mb = priv->chip_data;
+	p = &mb->ports[port];
+	ext_int = p->ext_int;
+
 	/* Set the RGMII TX/RX delay
 	 *
 	 * The Realtek vendor driver indicates the following possible
@@ -803,7 +814,7 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
 	}
 
 	ret = regmap_update_bits(
-		priv->map, RTL8365MB_EXT_RGMXF_REG(ext_port),
+		priv->map, RTL8365MB_EXT_RGMXF_REG(ext_int),
 		RTL8365MB_EXT_RGMXF_TXDELAY_MASK |
 			RTL8365MB_EXT_RGMXF_RXDELAY_MASK,
 		FIELD_PREP(RTL8365MB_EXT_RGMXF_TXDELAY_MASK, tx_delay) |
@@ -812,11 +823,11 @@ static int rtl8365mb_ext_config_rgmii(struct realtek_priv *priv, int port,
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
 
@@ -827,22 +838,26 @@ static int rtl8365mb_ext_config_forcemode(struct realtek_priv *priv, int port,
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
+	if (port != priv->cpu_port) {
 		dev_err(priv->dev, "only one EXT port is currently supported\n");
 		return -EINVAL;
 	}
 
+	mb = priv->chip_data;
+	p = &mb->ports[port];
+	ext_int = p->ext_int;
+
 	if (link) {
 		/* Force the link up with the desired configuration */
 		r_link = 1;
@@ -889,7 +904,7 @@ static int rtl8365mb_ext_config_forcemode(struct realtek_priv *priv, int port,
 			 r_duplex) |
 	      FIELD_PREP(RTL8365MB_DIGITAL_INTERFACE_FORCE_SPEED_MASK, r_speed);
 	ret = regmap_write(priv->map,
-			   RTL8365MB_DIGITAL_INTERFACE_FORCE_REG(ext_port),
+			   RTL8365MB_DIGITAL_INTERFACE_FORCE_REG(ext_int),
 			   val);
 	if (ret)
 		return ret;
@@ -1819,6 +1834,8 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 	/* Configure ports */
 	for (i = 0; i < priv->num_ports; i++) {
 		struct rtl8365mb_port *p = &mb->ports[i];
+		struct device_node *dn;
+		u32 val;
 
 		if (dsa_is_unused_port(priv->ds, i))
 			continue;
@@ -1842,6 +1859,23 @@ static int rtl8365mb_setup(struct dsa_switch *ds)
 		 * administratively down by default.
 		 */
 		rtl8365mb_port_stp_state_set(priv->ds, i, BR_STATE_DISABLED);
+
+		dn = dsa_to_port(priv->ds, i)->dn;
+
+		if (!of_property_read_u32(dn, "realtek,ext-int", &val)) {
+			if (val < 0 || val > 2) {
+				dev_err(priv->dev,
+					"realtek,ext-int must be between 0 and 2\n");
+				return -EINVAL;
+			}
+			p->ext_int = val;
+		} else {
+			if (dsa_is_cpu_port(priv->ds, i))
+				/* existing default */
+				p->ext_int = 1;
+			else
+				p->ext_int = -1;
+		}
 	}
 
 	/* Set maximum packet length to 1536 bytes */
-- 
2.34.0

