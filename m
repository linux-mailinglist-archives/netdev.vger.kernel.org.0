Return-Path: <netdev+bounces-9611-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ACCA72A03F
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:35:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EF4B2819E3
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63C7619BB2;
	Fri,  9 Jun 2023 16:34:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A5F18C1A
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:34:54 +0000 (UTC)
Received: from sender3-op-o18.zoho.com (sender3-op-o18.zoho.com [136.143.184.18])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043961FDF;
	Fri,  9 Jun 2023 09:34:52 -0700 (PDT)
Delivered-To: arinc.unal@arinc9.com
ARC-Seal: i=1; a=rsa-sha256; t=1686328460; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=hkYiuoaBGNcicBJqMrGa+snCNfic5+pcclNmkiojIZFM3G7OItv+puQxS/mRxyIxdfCHwJHqs4o/e93wKDzBSEOvyQVZl6Z6r2kC08kWe1XTVpZ7Q/gPIaGGADwqHeuQJZUAiNnEiyZz0ErLAmJRtQ8z45tQNNXn+R3yJOf6UVA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1686328460; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
	bh=aMifJN4jd3TEuoV/A1C1hcI6+kLjQwx0MeZB39jRuMI=; 
	b=Y+a1k8yfkLy8hNrO+k/rajLXz0KFDC6nTRVY3W0VLTJ8qgkIYpWKwMYhC53+zUwVlqyno27z2V4T9MzZdjIDdRWZS249M6b/7b1HCLtr3NpZpnsq1uypN/Jz++LFU/G79v+H6CnUh9/4ducMiZqCqV+6sCb6tQ83S4dtldnNZ3E=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=arinc9.com;
	spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
	dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1686328460;
	s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:Content-Transfer-Encoding:Reply-To;
	bh=aMifJN4jd3TEuoV/A1C1hcI6+kLjQwx0MeZB39jRuMI=;
	b=DFyRV3X/taR7GcoW+p/IW6RLDHJCXicDmoS9WmiBXeT56swvQexR8GLmK9HbvCdt
	dTAW/1bkdbTpZi2epobukNpUs+OGWsVShsJjMVr3X5ConHHOLWwCWF4R9SozgrqyN3X
	dAVJzA+JzHsGrQKPXUTC3he8Tr4kbX1PTFv5SKxI=
Received: from arinc9-Xeront.. (62.74.20.25 [62.74.20.25]) by mx.zohomail.com
	with SMTPS id 168632845896422.032713514232114; Fri, 9 Jun 2023 09:34:18 -0700 (PDT)
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
Subject: [PATCH net 3/5] net: dsa: mt7530: fix trapping frames on non-MT7621 SoC MT7530 switch
Date: Fri,  9 Jun 2023 19:33:51 +0300
Message-Id: <20230609163353.78941-3-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230609163353.78941-1-arinc.unal@arinc9.com>
References: <20230609163353.78941-1-arinc.unal@arinc9.com>
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

The check for setting the CPU_PORT bits must include the non-MT7621 SoC
MT7530 switch variants to trap frames. Expand the check to include them.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index da75f9b312bc..df2626f72367 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -3073,7 +3073,7 @@ mt753x_master_state_change(struct dsa_switch *ds,
 	 * the numerically smallest CPU port which is affine to the DSA conduit
 	 * interface that is up.
 	 */
-	if (priv->id != ID_MT7621)
+	if (priv->id != ID_MT7530 && priv->id != ID_MT7621)
 		return;
 
 	if (operational)
-- 
2.39.2


