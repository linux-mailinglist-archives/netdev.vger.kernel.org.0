Return-Path: <netdev+bounces-9610-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C0DC972A03E
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:35:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D7991C211A8
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41F04182D9;
	Fri,  9 Jun 2023 16:34:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319AF17750
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:34:53 +0000 (UTC)
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861611BCC;
	Fri,  9 Jun 2023 09:34:52 -0700 (PDT)
Delivered-To: arinc.unal@arinc9.com
ARC-Seal: i=1; a=rsa-sha256; t=1686328448; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=OVbpIvwVMV5r8luTIjlSt6DaVqJORIowdDYboJevmHSU1sH0LL9yn97xwmClAXlj9kXfBkwvVijS8p+Bv0SIBjZwX311EeV45xRWia1qAxnv4JiXa9UTPYX40vSZYX3LBtW3b2XeIJr/R+3LLEyQYcAg7yuMBUFXSCI/jBbeW3g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686328448; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
	bh=0kpmv7bgbqSWfxD0zHmu1wp6zMxmyDJTtu6zFlZuJLc=; 
	b=O4GWkxsi8YefZmctmAYfplIhvSpKHGp9zV3wO5QB+LLKRAcf7rbgnoTnECwX4keJ7NAXXGuJcb2SYZcL0PJMkGtO0wn/wRw6oaxdXL7vnKM39zehGrqktJJZtZKDcn8Ig1KFWZI9cXaKDKeJU1fmiiXAc0MryQCYwRwUG0oFFk0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686328448;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
	bh=0kpmv7bgbqSWfxD0zHmu1wp6zMxmyDJTtu6zFlZuJLc=;
	b=jVDqE5JItTE8oAL19JKtQ2lwoe6OeXfWVRMQdyZv3JOf+z4KulRsmY0b0KCgCJN7
	8lkzBg4Vnztv9YqmKk2LD5Bqk5FoB/Lzrx3zqWEec5BBtow2TAa9Kxjp2Iv1H6zPWFs
	mv94Oo2V2sRzixHnOJLCkCnCqSDwR2d0Z6HwH7QU=
Received: from arinc9-Xeront.. (62.74.20.25 [62.74.20.25]) by mx.zohomail.com
	with SMTPS id 168632844644444.67253435735802; Fri, 9 Jun 2023 09:34:06 -0700 (PDT)
From: =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
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
Subject: [PATCH net 1/5] net: dsa: mt7530: fix trapping frames with multiple CPU ports on MT7531
Date: Fri,  9 Jun 2023 19:33:49 +0300
Message-Id: <20230609163353.78941-1-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Every bit of the CPU port bitmap for MT7531 and the switch on the MT7988
SoC represents a CPU port to trap frames to. These switches trap frames to
the CPU port the user port, which the frames are received from, is affine
to.

Currently, only the bit that corresponds to the first found CPU port is set
on the bitmap. When multiple CPU ports are being used, frames from the user
ports affine to the other CPU port which are set to be trapped will be
dropped as the affine CPU port is not set on the bitmap. Only the MT7531
switch is affected as there's only one port to be used as a CPU port on the
switch on the MT7988 SoC.

To fix this, introduce the MT7531_CPU_PMAP macro to individually set the
bits of the CPU port bitmap. Set the CPU port bitmap for MT7531 and the
switch on the MT7988 SoC on mt753x_cpu_port_enable() which runs on a loop
for each CPU port.

Add comments to explain frame trapping for these switches.

According to the document MT7531 Reference Manual for Development Board
v1.0, the MT7531_CPU_PMAP bits are unset after reset so no need to clear it
beforehand. Since there's currently no public document for the switch on
the MT7988 SoC, I assume this is also the case for this switch.

Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 16 +++++++++-------
 drivers/net/dsa/mt7530.h |  1 +
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 9bc54e1348cb..8ab4718abb06 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1010,6 +1010,14 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 	if (priv->id == ID_MT7621)
 		mt7530_rmw(priv, MT7530_MFC, CPU_MASK, CPU_EN | CPU_PORT(port));
 
+	/* Add the CPU port to the CPU port bitmap for MT7531 and the switch on
+	 * the MT7988 SoC. Any frames set for trapping to CPU port will be
+	 * trapped to the CPU port the user port, which the frames are received
+	 * from, is affine to.
+	 */
+	if (priv->id == ID_MT7531 || priv->id == ID_MT7988)
+		mt7530_set(priv, MT7531_CFC, MT7531_CPU_PMAP(BIT(port)));
+
 	/* CPU port gets connected to all user ports of
 	 * the switch.
 	 */
@@ -2352,15 +2360,9 @@ static int
 mt7531_setup_common(struct dsa_switch *ds)
 {
 	struct mt7530_priv *priv = ds->priv;
-	struct dsa_port *cpu_dp;
 	int ret, i;
 
-	/* BPDU to CPU port */
-	dsa_switch_for_each_cpu_port(cpu_dp, ds) {
-		mt7530_rmw(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK,
-			   BIT(cpu_dp->index));
-		break;
-	}
+	/* Trap BPDUs to the CPU port(s) */
 	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
 		   MT753X_BPDU_CPU_ONLY);
 
diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
index 5084f48a8869..e590cf43f3ae 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -54,6 +54,7 @@ enum mt753x_id {
 #define  MT7531_MIRROR_PORT_GET(x)	(((x) >> 16) & MIRROR_MASK)
 #define  MT7531_MIRROR_PORT_SET(x)	(((x) & MIRROR_MASK) << 16)
 #define  MT7531_CPU_PMAP_MASK		GENMASK(7, 0)
+#define  MT7531_CPU_PMAP(x)		FIELD_PREP(MT7531_CPU_PMAP_MASK, x)
 
 #define MT753X_MIRROR_REG(id)		((((id) == ID_MT7531) || ((id) == ID_MT7988)) ?	\
 					 MT7531_CFC : MT7530_MFC)
-- 
2.39.2


