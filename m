Return-Path: <netdev+bounces-9889-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A4E072B0D5
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 10:39:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5216C1C20BAE
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 08:39:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE5CE53A0;
	Sun, 11 Jun 2023 08:39:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32425399
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 08:39:25 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53322136;
	Sun, 11 Jun 2023 01:39:23 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f7a8089709so34164225e9.1;
        Sun, 11 Jun 2023 01:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686472762; x=1689064762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k1e4tGkukcyDrQYJ1Gdd+cU0gHkR8U539GgwMkLQ8qI=;
        b=TO+ptTxLXbQOW/+w9oFbOJT0CtSp9LPu8vr2L/Tb+av0GfbKXiWNVC5EN4rXwgxe/q
         grIL7DOfXO+/rfG9kYzDSPpQYS8m5rIfVFPsIpYg7lc5q2THQHi+3lH/yH91w+le2fcV
         YI4Mk4gllmd2PmtYGJ0HUcQOfeVmdFruzz26CKKaO0zdPr6BVezk85MiJ5Uj/I5sryGY
         E6V/qOzhphoBRtJjejDdqIiu85BADCcuydiDU1Y4kW/nEHZnS3+xOStJGspoduszuCWh
         oC+ne17gLbTCn1hUynqJxDjzgJ+9Tf8Fdkm6CeUK+wFhaOtKYk/qf4+IhAFcow52BWyF
         IwdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686472762; x=1689064762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k1e4tGkukcyDrQYJ1Gdd+cU0gHkR8U539GgwMkLQ8qI=;
        b=QSgv98OLzeqMQvGRP4W6czWDisynO80qJNqQjh9OQv4yyZEzH0DAtdToHPM9inQbIA
         x+du77zt8cA5uF9MUlM6QXr9lR9D+BA2Dz/t6hvkU8PLLqICvqdocV//Hb6Pfirisc1w
         Y/Xb9ZA4nQdcmUE+qiGV6jv3yng1d+6sUKtyzH0WwTwEP9o2Hcp0eUiIqVmtvQ0JPijW
         KgPJ6KYYniNBv5MHv8soVTwDyVpW4VKqPZxNCRSAblB3nmb+fjZ1uTg4B17gPJ6aCHfj
         toCZYgCokhyyiftnn5vFqYAg7EmXes1y8YLGiNhy7vQsTjlxxLgyz2p6vb50gWC8tmkd
         O/lQ==
X-Gm-Message-State: AC+VfDxx0cEB565gYd5+BgKmCy/72nl1t+kCW1L1Gqp/l4y45hpK8NKm
	wYbusDgVDAUTasq0vtkvLp4=
X-Google-Smtp-Source: ACHHUZ5MiGDFC+03ngMSuD3uQW51ZH0YyfheT70boghO5pdwy1i89WB/82bRr4fjwYFuZ26XwABLxA==
X-Received: by 2002:a05:600c:cb:b0:3f7:6bd9:2819 with SMTP id u11-20020a05600c00cb00b003f76bd92819mr4680844wmm.29.1686472762218;
        Sun, 11 Jun 2023 01:39:22 -0700 (PDT)
Received: from arinc9-Xeront.lan (178-147-169-233.haap.dm.cosmote.net. [178.147.169.233])
        by smtp.gmail.com with ESMTPSA id 17-20020a05600c22d100b003f8044b3436sm7394629wmg.23.2023.06.11.01.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 01:39:21 -0700 (PDT)
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
Subject: [PATCH net v3 1/7] net: dsa: mt7530: fix trapping frames with multiple CPU ports on MT7531
Date: Sun, 11 Jun 2023 11:39:08 +0300
Message-Id: <20230611083914.28603-2-arinc.unal@arinc9.com>
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


