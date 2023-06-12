Return-Path: <netdev+bounces-9995-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D9EC72B98E
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:01:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA30A28114C
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:01:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80308101C3;
	Mon, 12 Jun 2023 08:00:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7484E101C2
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:00:24 +0000 (UTC)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCB31FEF;
	Mon, 12 Jun 2023 01:00:00 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f7a8089709so41901475e9.1;
        Mon, 12 Jun 2023 01:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686556797; x=1689148797;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p5WPBTyLepUz7+oEMbEueUmk9ne/lct1vXkFknHF+X0=;
        b=lySVczJLIzMWApBHBTLPrIPM4QOutgP34UIl2bbmIcelFHbY7oqA6e5VhPlAvElIKG
         N5kXA5JLliWWHsthHGVV0WtW3+RF3a4kmv+dkpqqObGg8L0cY/AC0MUm0+K1k1kR+pd6
         G230V9eOLel6WJBvkxKodiYhRt6lWMzAzI05YbIuhA7kPtyc5CeLREX7ClGDHe8/CDzH
         aIXpkimPD+10/HK8pDfCPBk3qvSAZVWsyfuUWQZrtuf8a97KgoS5Fv/CPw4Pd/kmAfL3
         TphW84q/TIapGtIs6a7IV2vakhSO1VsXBMJPppMY+DOQ1449DPVtxpK20RYQwZPZAIsE
         tN2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686556797; x=1689148797;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p5WPBTyLepUz7+oEMbEueUmk9ne/lct1vXkFknHF+X0=;
        b=ZZvPdPfhpd3YreyToeK4FDxjfNvnYMtABkbGiUpZuryXEwHRdjclcXxjijDUXVEfA+
         kfDT+a4UNnKBkQCvy9zY0J3NU+1ZHjQB+dNUTzZqAy+zhy0+IP2f+IGLYJAiGVfTEZa1
         NgT86IRvz5m/zEn9TJAG6Xwk0RRKvWbZ+WoL1+TWk3Ty0y4pyvKo4GYwqVMt8Q5fH2cW
         bgrnw7e5zedAc1s0OvsUPslJgEWSI7IUqPjyNGNlyYPBsU3pQ1rCYdu3YadGgsyOUnIJ
         ycvl9Iq+sx1sxbHeqFhxYKumgadMFgOdxyus5ZS8i7naKH8BF35JjvCK9PdIUGB4o+re
         A4fA==
X-Gm-Message-State: AC+VfDwFmY+iq71sdJpQnobmVTS3oU0qsiEDC/Y6ZLrnchQolZ7Iv4Qz
	HNM3IrIVX4NkbWWWQY5G6E4=
X-Google-Smtp-Source: ACHHUZ409F2WE0X8QUHm8Av7SgY1zOEK4exXo08gky3AVdpTQT36IDHyO0EKFS+sNMzVS/ch98Ns6g==
X-Received: by 2002:a1c:7c0e:0:b0:3f6:3bd:77dc with SMTP id x14-20020a1c7c0e000000b003f603bd77dcmr6215344wmc.23.1686556796734;
        Mon, 12 Jun 2023 00:59:56 -0700 (PDT)
Received: from arinc9-Xeront.lan (178-147-169-233.haap.dm.cosmote.net. [178.147.169.233])
        by smtp.gmail.com with ESMTPSA id y22-20020a7bcd96000000b003f7f2a1484csm10552195wmj.5.2023.06.12.00.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 00:59:56 -0700 (PDT)
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
Subject: [PATCH net v4 1/7] net: dsa: mt7530: fix trapping frames with multiple CPU ports on MT7531
Date: Mon, 12 Jun 2023 10:59:39 +0300
Message-Id: <20230612075945.16330-2-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230612075945.16330-1-arinc.unal@arinc9.com>
References: <20230612075945.16330-1-arinc.unal@arinc9.com>
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

Every bit of the CPU port bitmap for MT7531 and the switch on the MT7988
SoC represents a CPU port to trap frames to. These switches trap frames
received from a user port to the CPU port that is affine to the user port
from which the frames are received.

Currently, only the bit that corresponds to the first found CPU port is set
on the bitmap. When multiple CPU ports are being used, the trapped frames
from the user ports not affine to the first CPU port will be dropped as the
other CPU port is not set on the bitmap. The switch on the MT7988 SoC is
not affected as there's only one port to be used as a CPU port.

To fix this, introduce the MT7531_CPU_PMAP macro to individually set the
bits of the CPU port bitmap. Set the CPU port bitmap for MT7531 and the
switch on the MT7988 SoC on mt753x_cpu_port_enable() which runs on a loop
for each CPU port.

Add a comment to explain frame trapping for these switches.

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
index 9bc54e1348cb..b1657679e69d 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1010,6 +1010,14 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 	if (priv->id == ID_MT7621)
 		mt7530_rmw(priv, MT7530_MFC, CPU_MASK, CPU_EN | CPU_PORT(port));
 
+	/* Add the CPU port to the CPU port bitmap for MT7531 and the switch on
+	 * the MT7988 SoC. Frames received from a user port which are set for
+	 * trapping to CPU port will be trapped to the CPU port that is affine
+	 * to the user port from which the frames are received.
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


