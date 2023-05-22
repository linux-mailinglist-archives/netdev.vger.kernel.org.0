Return-Path: <netdev+bounces-4276-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 88CD870BDC6
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:25:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43DEC2809AC
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:25:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3D0016416;
	Mon, 22 May 2023 12:17:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AC11640D
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:17:17 +0000 (UTC)
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1E9CD;
	Mon, 22 May 2023 05:17:01 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-96f588bc322so587709766b.1;
        Mon, 22 May 2023 05:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684757821; x=1687349821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V9tpdUvQNrY+vXu1QgfXUo403K9j/yDPqK1JzzKX9TY=;
        b=q/+t+61YH1yRLDRJJOPmPwfYDM0nR2iAwN298kG0G6zmP9vpFPXhIHdNDzkdUd48l/
         cwN6osMyujFwj9quQ6Mtsi8e0J6fK2EcekhZ5NI2Fy4o6LfpS7sxMvHuKPS/CA6TUtxl
         873vrc68tsP58h5nIdlh1ZB2RXtaTmOT/4BmyCexQmjYNvwKx/pPFFHp4fkwE0R6HtaR
         gv+qXYYj6ax+RsWDq2Qjx8GFM9k/kVueB83PuKVI1LuAkEMwSR6Wr3WbXVoTl/Nh6E7J
         BYO8AW4KFY0NNwhPTu97qaEn0/4VLOCxrfhqk953FaUHq74O91UbEYPHlE/lOPeoQTRu
         tugA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684757821; x=1687349821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V9tpdUvQNrY+vXu1QgfXUo403K9j/yDPqK1JzzKX9TY=;
        b=XcjNgUnJul6siSgd8dbv0gsKndzRp3lhDUXfQPF2lu8fjf6wjpHEtdjkp4PsadaEk1
         hQHfLM1Orv1omGvyb+NSD4d98dXJc8RmW+UkwWttUqvGPk9GS1cB1cXX3eiFWg7Lv0X1
         UZxaenViQvIz4iYAPu46MNAgPwLst7yDErotwP9S1aOZnKg9xlo03glDltsqoVweh37D
         RgsB7F8SoIUvn5yE+JbdOayJz3EA/fMId2+7WISpzzuZxhwE7t9RaYZoO/h7Ky8iAALc
         TB8IohO7Doyx+84RQa5HnJ5BfG+7Wn6D2JZY9JoFrse0osv8sOT6jKNSyxUb5SrZVbP6
         I1zw==
X-Gm-Message-State: AC+VfDxQfhkorqVSQog2h04ezekDGFgbVN29vZxW7QeWy5/MSyzKnoLB
	7fEIis9VUznzMfMYyG4Fmcs=
X-Google-Smtp-Source: ACHHUZ7AzgOwwMT64Nky0TTC6ZmE3dmOJIVkxkaYdVOAOo9F1zIfL1k1AU/yDAPVy4izH3/6gBiQ8A==
X-Received: by 2002:a17:907:7246:b0:96a:ee54:9f20 with SMTP id ds6-20020a170907724600b0096aee549f20mr10610920ejc.37.1684757821114;
        Mon, 22 May 2023 05:17:01 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id y26-20020a17090614da00b009659fed3612sm2999950ejc.24.2023.05.22.05.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 05:17:00 -0700 (PDT)
From: arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To: Sean Wang <sean.wang@mediatek.com>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>,
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
Cc: =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	erkin.bozoglu@xeront.com,
	mithat.guner@xeront.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH net-next 25/30] net: dsa: mt7530: properly set MT7531_CPU_PMAP
Date: Mon, 22 May 2023 15:15:27 +0300
Message-Id: <20230522121532.86610-26-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230522121532.86610-1-arinc.unal@arinc9.com>
References: <20230522121532.86610-1-arinc.unal@arinc9.com>
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
SoC represents a CPU port to trap frames to. Currently only the bit that
corresponds to the first found CPU port is set on the bitmap. Introduce the
MT7531_CPU_PMAP macro to individually set the bits of the CPU port bitmap.
Set the CPU port bitmap for MT7531 and the switch on the MT7988 SoC on
mt753x_cpu_port_enable() which runs on a loop for each CPU port. Add
comments to explain this.

According to the document MT7531 Reference Manual for Development Board
v1.0, the MT7531_CPU_PMAP bits are unset after reset so no need to clear it
beforehand. Since there's currently no public document for the switch on
the MT7988 SoC, I assume this is also the case for this switch.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 15 ++++++++-------
 drivers/net/dsa/mt7530.h |  3 ++-
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 58d8738d94d3..0b513e3628fe 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -963,6 +963,13 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 		mt7530_rmw(priv, MT753X_MFC, MT7530_CPU_MASK, MT7530_CPU_EN |
 			   MT7530_CPU_PORT(port));
 
+	/* Add the CPU port to the CPU port bitmap for MT7531 and the switch on
+	 * the MT7988 SoC. Any frames set for trapping to CPU port will be
+	 * trapped to the CPU port the user port is affine to.
+	 */
+	if (priv->id == ID_MT7531 || priv->id == ID_MT7988)
+		mt7530_set(priv, MT7531_CFC, MT7531_CPU_PMAP(BIT(port)));
+
 	/* CPU port gets connected to all user ports of
 	 * the switch.
 	 */
@@ -2315,15 +2322,9 @@ static int
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
index 5ebb942b07ef..fd2a2f726b8a 100644
--- a/drivers/net/dsa/mt7530.h
+++ b/drivers/net/dsa/mt7530.h
@@ -53,7 +53,8 @@ enum mt753x_id {
 #define  MT7531_MIRROR_MASK		(0x7 << 16)
 #define  MT7531_MIRROR_PORT_GET(x)	(((x) >> 16) & 0x7)
 #define  MT7531_MIRROR_PORT_SET(x)	(((x) & 0x7) << 16)
-#define  MT7531_CPU_PMAP_MASK		GENMASK(7, 0)
+#define  MT7531_CPU_PMAP(x)		((x) & 0xff)
+#define  MT7531_CPU_PMAP_MASK		MT7531_CPU_PMAP(~0)
 
 #define MT753X_MIRROR_REG(id)		((((id) == ID_MT7531) || ((id) == ID_MT7988)) ?	\
 					 MT7531_CFC : MT753X_MFC)
-- 
2.39.2


