Return-Path: <netdev+bounces-4267-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E2CA070BD9B
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:22:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9EA6A281011
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7565B14A9B;
	Mon, 22 May 2023 12:17:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679BA14A85
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:17:04 +0000 (UTC)
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7191BEF;
	Mon, 22 May 2023 05:16:43 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-96f99222e80so449236066b.1;
        Mon, 22 May 2023 05:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684757794; x=1687349794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LXWcb5B2+vJzEM1ajF8yrjUWQCkaIrKdZXzgLh1rBzw=;
        b=khhO8hLijzVbaNMGFVCDvnqJ4dImG84zrCI76PV6OxcquPDu4U5AhUaiUPnQN0WOsc
         EngublP0KhkERGpYyon51lVE+fhOh+8of5CCwMxQhUPiMGCUq4VPQxEOSB0rXpk2SzM2
         YnEX5WDiCQEQWLmkTNW0uLJokzkGu2rnCPKWJbRHtGPFf0lJvzlmc4q/AdrtIE74vtgD
         HHTrqENF4j5Gg+OuH/PA/YvVSaxCmU1rMvLBkcOl+qeY+jpYbcfOLTnLwgaBvkaHmWmA
         T95oNv4yY5OaB9kQ4FGFCIvBgZskr9F79dhpUv2RW3iy5DGWrKJlQAB7+9CTSIs2QNak
         Erog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684757794; x=1687349794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LXWcb5B2+vJzEM1ajF8yrjUWQCkaIrKdZXzgLh1rBzw=;
        b=MSfDrmgJTPTwrxy2yoIPfPhUdu/NaxScVSYKR4qN7Ses3jv4Ei+eKyFSzM3d9XEFen
         VpX4XI/RISfYMVeU++tNLcItE/qRlKaoOkwjmQr3auif+GlRnhsovtvIbBGXl70l92H9
         LIZj2Dd4hyTqHHTpKsaXr1nK5CL/L2sR76Npz6J0AoBL7MDpyiU7JKAbRQrtZ/O3rOGX
         90SQf5Ci8LeebZILbYircUOtZu/XJHtdDya2nbcPHvq7DsE/5SttD/Jdx1lxTUO2snXd
         9viyKuXRUSz61Zz6+0hkuO1sVZMXqqDemH5HtgoKYdmQlB/DsJmLGN4hlUyXUffmekg/
         z7mw==
X-Gm-Message-State: AC+VfDygBcY0Nc7P34U+j9FgBjA8tQZnJAw+kx2ZWmnYkCtfD9ikrA39
	7HgWHpUH9XROsn5N+9MXwTI=
X-Google-Smtp-Source: ACHHUZ6QHJYC5GUYqWHlBjRvQ9wBEB0YxRBTmvWBroelqSxpoGapH/6RRzqmpJJv+ptd0XgHV+e2ww==
X-Received: by 2002:a17:907:7ea3:b0:966:399e:a5a5 with SMTP id qb35-20020a1709077ea300b00966399ea5a5mr8891079ejc.35.1684757793930;
        Mon, 22 May 2023 05:16:33 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id y26-20020a17090614da00b009659fed3612sm2999950ejc.24.2023.05.22.05.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 05:16:33 -0700 (PDT)
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
Subject: [PATCH net-next 16/30] net: dsa: mt7530: move lowering port 5 RGMII driving to mt7530_setup()
Date: Mon, 22 May 2023 15:15:18 +0300
Message-Id: <20230522121532.86610-17-arinc.unal@arinc9.com>
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

Move lowering Tx driving of rgmii on port 5 to right before lowering of Tx
driving of trgmii on port 6 on mt7530_setup().

This way, the switch should consume less power regardless of port 5 being
used.

Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index f2c1aa9cf7f7..514e82299537 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -933,10 +933,6 @@ static void mt7530_setup_port5(struct dsa_switch *ds, phy_interface_t interface)
 		/* P5 RGMII TX Clock Control: delay x */
 		mt7530_write(priv, MT7530_P5RGMIITXCR,
 			     CSR_RGMII_TXC_CFG(0x10 + tx_delay));
-
-		/* reduce P5 RGMII Tx driving, 8mA */
-		mt7530_write(priv, MT7530_IO_DRV_CR,
-			     P5_IO_CLK_DRV(1) | P5_IO_DATA_DRV(1));
 	}
 
 	mt7530_write(priv, MT7530_MHWTRAP, val);
@@ -2209,6 +2205,10 @@ mt7530_setup(struct dsa_switch *ds)
 
 	mt7530_pll_setup(priv);
 
+	/* Lower P5 RGMII Tx driving, 8mA */
+	mt7530_write(priv, MT7530_IO_DRV_CR,
+			P5_IO_CLK_DRV(1) | P5_IO_DATA_DRV(1));
+
 	/* Lower Tx driving for TRGMII path */
 	for (i = 0; i < NUM_TRGMII_CTRL; i++)
 		mt7530_write(priv, MT7530_TRGMII_TD_ODT(i),
-- 
2.39.2


