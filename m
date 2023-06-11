Return-Path: <netdev+bounces-9882-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B8E072B0B9
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 10:16:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9F76281415
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 08:16:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9F5C523D;
	Sun, 11 Jun 2023 08:16:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDE85233
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 08:16:12 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD9F2D70;
	Sun, 11 Jun 2023 01:16:10 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f7ebb2b82cso34024475e9.2;
        Sun, 11 Jun 2023 01:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686471369; x=1689063369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E8mfk1HF6L4tH///RyhbQqTPyEo53vj44BbOEOR1clM=;
        b=GiCWLUvNxgWvmtsJRAWk33c7K1+9tTJBbZRCmi7oDh91nORFu4xQP0gRIxMqx7jGO9
         t44TlMeeI/yuFIKmJL4btdULtiwSrNfDRoefXhn3LzuS3SgABnM+ItiecX7+5Cjy86lS
         vuKVjvBmrz8fg49oOo9CS4FCKyAIFELUmCtZkDdqnmo9TOmxXg4HhMMrPWCiR8NvxRQC
         xNeH4noFGOyg04WpLsI4o3tJDRwIfg7q/Z8KNp7VRU9ZzeAMepcF5WmccX0tetBOoaUP
         DZhtNQDjUkTo6YCZIJZuBDtudhriI0mesH5XgeKUjTR1HUc4k99oSIdWoeN3Iq+O5hhg
         hQug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686471369; x=1689063369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E8mfk1HF6L4tH///RyhbQqTPyEo53vj44BbOEOR1clM=;
        b=HNGDQkvZk7TZK9u82ONlqu6VxwxQv9xwswlS0Ry3KWrXC1Ts7R/nCZeDXRYHk+lx7N
         Y8qTFU+UBW7SkjclvGlMM6mMb7zaj0XauyIWXsaVxIfox/xxEpUxZPFRS4OcDguaz6g5
         jUxOYwAzUABE7oNywAl4cHSYMTdKvrJazc88CXRkUEtQU5dX3oizATQBes4cgZZ0sUEr
         FSU+XlXiOW0S/z/7KAzFTMiV7oLjiZj6UeYjSEOTaP5a8Dk+BKm/iNXKF8Ym/eFFYNLl
         FpcOl2+8YXShKFIuduZL5esjS0ukq8qU5EvKwTYLV7C2kjck4e9FY9dZvvOJjfpVhORb
         wWNQ==
X-Gm-Message-State: AC+VfDwfUH3a9Wn5lRPpVsUvXluGLvhXE/Y3Y1dobCmNBgDUpxITAZkK
	UsdzGXRs4dKs3+YfapwJap4=
X-Google-Smtp-Source: ACHHUZ4nRShIhhavWUBNk/+Xe/dCRHhjdwx/3BaHka8pZfCOtN6J41mzD79JBpzFH1puk74mbIDPqA==
X-Received: by 2002:a05:600c:2310:b0:3f5:f83:4d84 with SMTP id 16-20020a05600c231000b003f50f834d84mr4490072wmo.31.1686471369274;
        Sun, 11 Jun 2023 01:16:09 -0700 (PDT)
Received: from arinc9-Xeront.lan (178-147-169-233.haap.dm.cosmote.net. [178.147.169.233])
        by smtp.gmail.com with ESMTPSA id s5-20020a7bc385000000b003f6132f95e6sm7748979wmj.35.2023.06.11.01.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 01:16:09 -0700 (PDT)
From: "=?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?=" <arinc9.unal@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
To: =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Russell King <linux@armlinux.org.uk>
Cc: Landen Chao <landen.chao@mediatek.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com,
	erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH net v2 2/7] net: dsa: mt7530: fix trapping frames with multiple CPU ports on MT7530
Date: Sun, 11 Jun 2023 11:15:42 +0300
Message-Id: <20230611081547.26747-2-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230611081547.26747-1-arinc.unal@arinc9.com>
References: <20230611081547.26747-1-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The CPU_PORT bits represent the CPU port to trap frames to for the MT7530
switch. This switch traps frames to the CPU port set on the CPU_PORT bits,
regardless of the affinity of the user port which the frames are received
from.

When multiple CPU ports are being used, the trapped frames won't be
received when the DSA conduit interface, which the frames are supposed to
be trapped to, is down because it's not affine to any user port. This
requires the DSA conduit interface to be manually set up for the trapped
frames to be received.

To fix this, implement ds->ops->master_state_change() on this subdriver and
set the CPU_PORT bits to the CPU port which the DSA conduit interface its
affine to is up. Introduce the active_cpu_ports field to store the
information of the active CPU ports. Correct the macros, CPU_PORT is bits 4
through 6 of the register.

Add comments to explain frame trapping for this switch.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 32 ++++++++++++++++++++++++++++----
 drivers/net/dsa/mt7530.h |  6 ++++--
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 8ab4718abb06..da75f9b312bc 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1006,10 +1006,6 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 	mt7530_set(priv, MT7530_MFC, BC_FFP(BIT(port)) | UNM_FFP(BIT(port)) |
 		   UNU_FFP(BIT(port)));
 
-	/* Set CPU port number */
-	if (priv->id == ID_MT7621)
-		mt7530_rmw(priv, MT7530_MFC, CPU_MASK, CPU_EN | CPU_PORT(port));
-
 	/* Add the CPU port to the CPU port bitmap for MT7531 and the switch on
 	 * the MT7988 SoC. Any frames set for trapping to CPU port will be
 	 * trapped to the CPU port the user port, which the frames are received
@@ -3063,6 +3059,33 @@ static int mt753x_set_mac_eee(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static void
+mt753x_master_state_change(struct dsa_switch *ds,
+			   const struct net_device *master,
+			   bool operational)
+{
+	struct mt7530_priv *priv = ds->priv;
+	struct dsa_port *cpu_dp = master->dsa_ptr;
+
+	/* Set the CPU port to trap frames to for MT7530. There can be only one
+	 * CPU port due to CPU_PORT having only 3 bits. Any frames received from
+	 * a user port which are set for trapping to CPU port will be trapped to
+	 * the numerically smallest CPU port which is affine to the DSA conduit
+	 * interface that is up.
+	 */
+	if (priv->id != ID_MT7621)
+		return;
+
+	if (operational)
+		priv->active_cpu_ports |= BIT(cpu_dp->index);
+	else
+		priv->active_cpu_ports &= ~BIT(cpu_dp->index);
+
+	if (priv->active_cpu_ports)
+		mt7530_rmw(priv, MT7530_MFC, CPU_EN | CPU_PORT_MASK, CPU_EN |
+			   CPU_PORT(__ffs(priv->active_cpu_ports)));
+}
+
 static int mt7988_pad_setup(struct dsa_switch *ds, phy_interface_t interface)
 {
 	return 0;
@@ -3117,6 +3140,7 @@ const struct dsa_switch_ops mt7530_switch_ops = {
 	.phylink_mac_link_up	= mt753x_phylink_mac_link_up,
 	.get_mac_eee		= mt753x_get_mac_eee,
 	.set_mac_eee		= mt753x_set_mac_eee,
+	.master_state_change	= mt753x_master_state_change,
 };
 EXPORT_SYMBOL_GPL(mt7530_switch_ops);
 
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index e590cf43f3ae..28dbd131a535 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -41,8 +41,8 @@ enum mt753x_id {
 #define  UNU_FFP(x)			(((x) & 0xff) << 8)
 #define  UNU_FFP_MASK			UNU_FFP(~0)
 #define  CPU_EN				BIT(7)
-#define  CPU_PORT(x)			((x) << 4)
-#define  CPU_MASK			(0xf << 4)
+#define  CPU_PORT_MASK			GENMASK(6, 4)
+#define  CPU_PORT(x)			FIELD_PREP(CPU_PORT_MASK, x)
 #define  MIRROR_EN			BIT(3)
 #define  MIRROR_PORT(x)			((x) & 0x7)
 #define  MIRROR_MASK			0x7
@@ -753,6 +753,7 @@ struct mt753x_info {
  * @irq_domain:		IRQ domain of the switch irq_chip
  * @irq_enable:		IRQ enable bits, synced to SYS_INT_EN
  * @create_sgmii:	Pointer to function creating SGMII PCS instance(s)
+ * @active_cpu_ports:	Holding the active CPU ports
  */
 struct mt7530_priv {
 	struct device		*dev;
@@ -779,6 +780,7 @@ struct mt7530_priv {
 	struct irq_domain *irq_domain;
 	u32 irq_enable;
 	int (*create_sgmii)(struct mt7530_priv *priv, bool dual_sgmii);
+	unsigned long active_cpu_ports;
 };
 
 struct mt7530_hw_vlan_entry {
-- 
2.39.2


