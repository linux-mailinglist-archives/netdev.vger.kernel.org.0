Return-Path: <netdev+bounces-11268-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 554F473256F
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 04:53:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D8672815F7
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 02:53:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47F22368;
	Fri, 16 Jun 2023 02:53:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360D3650
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 02:53:37 +0000 (UTC)
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB3A2953;
	Thu, 15 Jun 2023 19:53:35 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 38308e7fff4ca-2b448cf5d83so1787481fa.1;
        Thu, 15 Jun 2023 19:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686884013; x=1689476013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5teyYXVySChYV/2XSD9vMPokSMgSc3gjTsNzsa7EAFM=;
        b=GNGMlYrDetZ6ICqbhwc+puCCyE0c6rBFCkQ8b2eeddMC1qIzcXriAtlIDfPp1ocvIQ
         Y85D0wSVo17OGLjrALMWSfJ7CC84T3mXIEpEOqin4Ce6pvn+sj9Eh6aXApRESdK5nO1T
         M0Uzch3MQyKSoV0y+PuLiq1vvpZlmwV3RInYVeJX7xu0kHE6bJkcBm4EIAGUfLE4fcl+
         Azz9yUjzTf4HOjqUJoF+0yCu17FhRfHghSHqbLXk+htf8e022ymnlP+PCDnDwI5kiqow
         uHsr0hCZ56YmvWc1UwNKGktZcBsdqep4u3a1dzgu4FndnRaYK6Vql5XOwRj5p1j2G+62
         AURw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686884013; x=1689476013;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5teyYXVySChYV/2XSD9vMPokSMgSc3gjTsNzsa7EAFM=;
        b=Bjn7/jt/sue6spbkYfBj24PrJXhPjv5tb1UXeNn9SBLvzkmexwVybop/2ZEhsEzIih
         yf9Rk53ya4yDADstexC8XjJFsToarBGeieFnPa0mWmCIiYBkILCm0GHyJmR+zkC7zdPz
         oGoMV1kO0W9SP5Jw3WJC9m+1W/OBTnDPyAj7IHZI+Bc2JmVm7usyU3MgLCd0GBxZy1lE
         HEFWUaiI3ts+VAUqcPjylduzu7y6uCJv5dqFaufaafilTrQhKTWazUQ4V4N3/dX8Bb+x
         73i9sKQzRNfYlGsaNT4/Kw4hbiC30nKLZvch3tn6BoX9IHQ00i2gcuM0CLTygKqN+6n6
         6Wcw==
X-Gm-Message-State: AC+VfDzOYiI7urAXztARuQv1bU3FfW86IoOQHPpAaLeM4J7KswYt9+IN
	vH5Kgf8kiVM1HLbSM4xMg4U=
X-Google-Smtp-Source: ACHHUZ7w7yvq7i3gLLPqn0YvdI3QsxCnRzgWFtRNSlech3ZCz7VcklyDsOE1xOmGCpIss6027QOEnQ==
X-Received: by 2002:a2e:98d6:0:b0:2af:3141:a52b with SMTP id s22-20020a2e98d6000000b002af3141a52bmr710339ljj.22.1686884013304;
        Thu, 15 Jun 2023 19:53:33 -0700 (PDT)
Received: from arinc9-Xeront.. (athedsl-404045.home.otenet.gr. [79.131.130.75])
        by smtp.gmail.com with ESMTPSA id v15-20020a1cf70f000000b003f8d770e935sm890328wmh.0.2023.06.15.19.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 19:53:32 -0700 (PDT)
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
Subject: [PATCH net v5 1/6] net: dsa: mt7530: set all CPU ports in MT7531_CPU_PMAP
Date: Fri, 16 Jun 2023 05:53:22 +0300
Message-Id: <20230616025327.12652-2-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230616025327.12652-1-arinc.unal@arinc9.com>
References: <20230616025327.12652-1-arinc.unal@arinc9.com>
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

MT7531_CPU_PMAP represents the destination port mask for trapped-to-CPU
frames (further restricted by PCR_MATRIX).

Currently the driver sets the first CPU port as the single port in this bit
mask, which works fine regardless of whether the device tree defines port
5, 6 or 5+6 as CPU ports. This is because the logic coincides with DSA's
logic of picking the first CPU port as the CPU port that all user ports are
affine to, by default.

An upcoming change would like to influence DSA's selection of the default
CPU port to no longer be the first one, and in that case, this logic needs
adaptation.

Since there is no observed leakage or duplication of frames if all CPU
ports are defined in this bit mask, simply include them all.

Suggested-by: Russell King (Oracle) <linux@armlinux.org.uk>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 15 ++++++++-------
 drivers/net/dsa/mt7530.h |  1 +
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 9bc54e1348cb..0a5237793209 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -1010,6 +1010,13 @@ mt753x_cpu_port_enable(struct dsa_switch *ds, int port)
 	if (priv->id == ID_MT7621)
 		mt7530_rmw(priv, MT7530_MFC, CPU_MASK, CPU_EN | CPU_PORT(port));
 
+	/* Add the CPU port to the CPU port bitmap for MT7531 and the switch on
+	 * the MT7988 SoC. Trapped frames will be trapped to the CPU port that
+	 * is affine to the inbound user port.
+	 */
+	if (priv->id == ID_MT7531 || priv->id == ID_MT7988)
+		mt7530_set(priv, MT7531_CFC, MT7531_CPU_PMAP(BIT(port)));
+
 	/* CPU port gets connected to all user ports of
 	 * the switch.
 	 */
@@ -2352,15 +2359,9 @@ static int
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


