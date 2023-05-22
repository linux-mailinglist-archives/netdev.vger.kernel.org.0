Return-Path: <netdev+bounces-4269-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D22570BDBD
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:22:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18547280CCB
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:22:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD66814AAE;
	Mon, 22 May 2023 12:17:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5B214280
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:17:07 +0000 (UTC)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A8A1BFB;
	Mon, 22 May 2023 05:16:49 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-96652cb7673so945803366b.0;
        Mon, 22 May 2023 05:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684757800; x=1687349800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7tJgSrsfJjBPduQ55oOsMul7hMtXzANzGQOA9D+BS4Q=;
        b=ZIVjXqZm2HxwrcjR1rFQj37pSDw/EAe2pmr8IgX7/oRVAdO9D5Mbtu3SPqksLMkREh
         T9xTkPJ2DH2L0Bm2ImuoBgnY8/k0+e8W9VyG5EHAm1KPXNqJyHAHBcCbCjcRC279kXWE
         Hwv1G68hkvXY2wx0dvWAg9806gcUAxWQFqrn0WKD4bJ14M8AwDRSaNdVCfY7B+psbCDh
         T775ROUERYrZTumv4F3HNyvUOp58lEMr0ZMUb2d7H9XQlGDCKoszmThhYdkotT184POj
         UV8UG5Y/cD/bzTDgSRiUpaY3kc8tSagfqHUSERWDR9NYGfNkbJPw4aDw7Pxr1ncazO4A
         95vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684757800; x=1687349800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7tJgSrsfJjBPduQ55oOsMul7hMtXzANzGQOA9D+BS4Q=;
        b=XnrvT0+R7C+WnHdD7yuH2mudO81I4jXJiPvuPIEHMbGBfR2KrpthNteJhpHKXHal0v
         GDlig7/yFmil9d8Z7JQAgXZUbeeAVxj6GuhxjybZWZ6o4jJCAuN8IOn4fWEr88vtXbKS
         xHZfb56H31snT2Qoc0zD04kIhAngw3K7vWCG8q3eJ5rPNcmAS6dAbLHY7wO/5W/3aK/P
         6b0Lzm1VluhBz857/tP7BGGDlF4mWQlJiiu2wJMNbUI/KguSRIUp1yVbS4ZF+vFkxBwD
         oNXdtuSi2tVJPz19eXdiahNS6n2nUuWBMKLQDJQ2gp3DxN/FRHKyZcLV2sG/uuTAnQ/D
         UJLA==
X-Gm-Message-State: AC+VfDwzPCkY4usZdh1pqj7Z5AaD/ncJHzuU3fVGrzy9DnVC8guC/uuE
	GRnXCHv9wl0eMMhE2J8i4SI=
X-Google-Smtp-Source: ACHHUZ72VmGhmmYTe0AopjokPSVMzaGVY/fJu0fyOgd/aAvX2GqtNUrGr+ViNueHkprxGWrI+408+w==
X-Received: by 2002:a17:907:7f8c:b0:96a:5e38:ba49 with SMTP id qk12-20020a1709077f8c00b0096a5e38ba49mr10976896ejc.2.1684757799838;
        Mon, 22 May 2023 05:16:39 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id y26-20020a17090614da00b009659fed3612sm2999950ejc.24.2023.05.22.05.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 05:16:39 -0700 (PDT)
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
Subject: [PATCH net-next 18/30] net: dsa: mt7530: remove .mac_port_config for MT7988 and make it optional
Date: Mon, 22 May 2023 15:15:20 +0300
Message-Id: <20230522121532.86610-19-arinc.unal@arinc9.com>
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

For the switch on the MT7988 SoC, the code in mac_port_config for MT7988 is
not needed as the interface of the CPU port is already handled on
mt7988_mac_port_get_caps().

Make .mac_port_config optional. Before calling
priv->info->mac_port_config(), if there's no mac_port_config member in the
priv->info table, exit mt753x_mac_config() successfully.

Remove mac_port_config from the sanity check as the sanity check requires a
pointer to a mac_port_config function to be non-NULL. This will fail for
MT7988 as mac_port_config won't be a member of its info table.

Co-developed-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index f017cc028183..99f5da8b27be 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2614,17 +2614,6 @@ static bool mt753x_is_mac_port(u32 port)
 	return (port == 5 || port == 6);
 }
 
-static int
-mt7988_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
-		  phy_interface_t interface)
-{
-	if (dsa_is_cpu_port(ds, port) &&
-	    interface == PHY_INTERFACE_MODE_INTERNAL)
-		return 0;
-
-	return -EINVAL;
-}
-
 static int
 mt7531_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		  phy_interface_t interface)
@@ -2665,6 +2654,9 @@ mt753x_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 {
 	struct mt7530_priv *priv = ds->priv;
 
+	if (!priv->info->mac_port_config)
+		return 0;
+
 	return priv->info->mac_port_config(ds, port, mode, state->interface);
 }
 
@@ -3108,7 +3100,6 @@ const struct mt753x_info mt753x_table[] = {
 		.phy_write_c45 = mt7531_ind_c45_phy_write,
 		.cpu_port_config = mt7988_cpu_port_config,
 		.mac_port_get_caps = mt7988_mac_port_get_caps,
-		.mac_port_config = mt7988_mac_config,
 	},
 };
 EXPORT_SYMBOL_GPL(mt753x_table);
@@ -3136,8 +3127,7 @@ mt7530_probe_common(struct mt7530_priv *priv)
 	 * properly.
 	 */
 	if (!priv->info->sw_setup || !priv->info->phy_read_c22 ||
-	    !priv->info->phy_write_c22 || !priv->info->mac_port_get_caps ||
-	    !priv->info->mac_port_config)
+	    !priv->info->phy_write_c22 || !priv->info->mac_port_get_caps)
 		return -EINVAL;
 
 	priv->id = priv->info->id;
-- 
2.39.2


