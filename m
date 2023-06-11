Return-Path: <netdev+bounces-9890-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F5CC72B0D8
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 10:40:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8965A1C20B05
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 08:39:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96D585399;
	Sun, 11 Jun 2023 08:39:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0E67468
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 08:39:28 +0000 (UTC)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0F92136;
	Sun, 11 Jun 2023 01:39:26 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f7f6341b99so23920955e9.2;
        Sun, 11 Jun 2023 01:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686472765; x=1689064765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aGjSubHB5nyBi9j8FAFQdMcIlI87DT0LBIyRr04BO1s=;
        b=PNU5zVDx2CelSpV0Ev7A+zsdWWBzu9WqPi5au1pRJoFaqgzwAzPFOKRmki5m2JAfta
         EurquF9ue3YFhSmqmHgNHjg9OVWfuBvn80zg5K97MDCKqLeE2PtE1ElTwUOIGdKslVWm
         sDXA+9Gzcik7aY/s6X1Yx9eiMYq3XA36u728Kr/ZVIn0kLYpQMWMhspQqjYzfImdulyd
         MLGXR/IiGJgf1OuN7PPZo8X0dZ7LKGBwVOd2A2SJjiqYnRfuLXFXi/LIltVo7Fv84pNx
         iX5IspBCFXQakEeonH3w5dcDMJjzZ54GItWx14PGMiZVjdJO1u8+70c/D9OHsdMR1rc1
         cHJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686472765; x=1689064765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aGjSubHB5nyBi9j8FAFQdMcIlI87DT0LBIyRr04BO1s=;
        b=SetRpR8ggUW2C4GmOfdEVFcsUR4h7KCJjT/523+oO2Qz/H8fWwn/Ba+eJr4LSme4/G
         qN6hvh6BXYr+nBNXZa5E71GlplfuihHRcCMRnzNGYfbuRjG5AdHk/WNisnb94dVAgECK
         RAOOzliyH1fAx2g7gBfjEJE9SGcwDXDP1wCaWH4l7uHLlnmIJ+l5KBqj5Cx04j74B7Jo
         ZEjwGldPfjgxD7iYc16aFADHwEXhZBWvoKgDuPSqfnpZosHuTQsFF5Fh2d1yPbiQ/cRQ
         ONiot0+fsk+phu3wNIJ35UNGIcsZ1x7aHAZa76Z6oTl4sl6PV5D90xbFDLWOti79XChU
         h0Qw==
X-Gm-Message-State: AC+VfDw/WcGydMK+oC761GQqzqMbM5dl9G4Mx3jRbkp3/UulSMKaiR6U
	MN1EibFfyqKpsoY2tkA7Kw8=
X-Google-Smtp-Source: ACHHUZ47Yo4aCctQJTM6/sgph7/C53Vo6Ns/4gbAaKuHVHeqrz74CbHq7XcgsterxVaPmL3Oq1SFMw==
X-Received: by 2002:a05:600c:2291:b0:3f6:1a3:4cee with SMTP id 17-20020a05600c229100b003f601a34ceemr4653033wmf.14.1686472765218;
        Sun, 11 Jun 2023 01:39:25 -0700 (PDT)
Received: from arinc9-Xeront.lan (178-147-169-233.haap.dm.cosmote.net. [178.147.169.233])
        by smtp.gmail.com with ESMTPSA id 17-20020a05600c22d100b003f8044b3436sm7394629wmg.23.2023.06.11.01.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 01:39:24 -0700 (PDT)
From: arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
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
Subject: [PATCH net v3 2/7] net: dsa: mt7530: fix trapping frames with multiple CPU ports on MT7530
Date: Sun, 11 Jun 2023 11:39:09 +0300
Message-Id: <20230611083914.28603-3-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230611083914.28603-1-arinc.unal@arinc9.com>
References: <20230611083914.28603-1-arinc.unal@arinc9.com>
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

From: Arınç ÜNAL <arinc.unal@arinc9.com>

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


