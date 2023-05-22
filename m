Return-Path: <netdev+bounces-4255-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4436F70BD58
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:18:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18DC81C20A99
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:18:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53353134C2;
	Mon, 22 May 2023 12:16:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FE4134B9
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:16:49 +0000 (UTC)
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCA7E6F;
	Mon, 22 May 2023 05:16:24 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-510db954476so8202998a12.0;
        Mon, 22 May 2023 05:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684757758; x=1687349758;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fw4nj8eHyTVwx2QRs8Eh5H2vmMuQNaVsES2wqOcCl48=;
        b=WdEHI1Rf/UbPCqjY7uh0WGUfXAC+SrgUp+FBZIUy48VR0QWhcodtriyeblzzLJZ1p4
         zyRJPVKWvzQ9I6FZjHbayPN/t+arrt3bvEMC8PF1JAlzvad6uu5sVersWBf1SEwNflBr
         qV8IBEu1ofxejiaxr41JGWQMCvnETG96UdHygoas7AUj4l6w/ssH2WB1GtQlUkBZOUka
         dupSMlQEG5gMlBoFdbg5iWtF6amiBA4qRim5J0tW24p75A7/LHcBwtPyTEcl+rKcf2wB
         jhDpEhdYR9KPlYgofkvoXO1wrh6wG+ckZjAi8CNMIFqVrfq9oerZxJIJJOyG7GU6yYdr
         wLcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684757758; x=1687349758;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fw4nj8eHyTVwx2QRs8Eh5H2vmMuQNaVsES2wqOcCl48=;
        b=ZTtPNKbFRKQCGbc+YDLpurySvmRUZ4zCeFYel5lnG8rGj4O4QlJshPoO9mXDhIgWc6
         tMQJEzH8MmvbnwK6WyOZM88mrP6UVyNUmUq95qC31iL272mqhJWiPq/71m8WF894BwtY
         8fABDn2C2OrM4e2xx1QzmhY3FMeAku5zsyBb/s2PcRNFEMCjOjv6DdAssRTsqVo2zyo8
         G3br/W/bM+zcZprmi8mDrZzs/4c5FrRjO4sjvROU5w50EubBw+9km8JlsSWzxvfG1wPV
         s1b2ygA8KJlKvTJars4kmcyr/lUOCoNtEbDutxgCb/rM9NNkLk1fvPiEShVwCl4IVl5Y
         xhYA==
X-Gm-Message-State: AC+VfDzZAaucsSAAk5askST+RL6BzJz2mD+wS7jRfBiv4jRZWshq4KhP
	DPYUxdN5ghy0FS0nTfWCmC8=
X-Google-Smtp-Source: ACHHUZ7JmPSmZNlAEKCeqqyFbmGpxQowTuUMRyfunz6zfzw7jkWsrJuRiKe5dbckEivbkBLQE9nf+Q==
X-Received: by 2002:a17:907:7209:b0:960:d28d:3368 with SMTP id dr9-20020a170907720900b00960d28d3368mr9418595ejc.60.1684757757700;
        Mon, 22 May 2023 05:15:57 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id y26-20020a17090614da00b009659fed3612sm2999950ejc.24.2023.05.22.05.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 05:15:57 -0700 (PDT)
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
Subject: [PATCH net-next 04/30] net: dsa: mt7530: improve comments regarding port 5 and 6
Date: Mon, 22 May 2023 15:15:06 +0300
Message-Id: <20230522121532.86610-5-arinc.unal@arinc9.com>
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

There's no logic to numerically order the CPU ports. State the port number
and its capability of being used as a CPU port instead.

Remove the irrelevant PHY muxing information from
mt7530_mac_port_get_caps(). Explain the supported MII modes instead.

Remove the out of place PHY muxing information from
mt753x_phylink_mac_config(). The function is for both the MT7530 and MT7531
switches but there's no PHY muxing on MT7531.

These comments were gradually introduced with the commits below.
ca366d6c889b ("net: dsa: mt7530: Convert to PHYLINK API")
38f790a80560 ("net: dsa: mt7530: Add support for port 5")
88bdef8be9f6 ("net: dsa: mt7530: Extend device data ready for adding a new
hardware")
c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")

Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Acked-by: Daniel Golle <daniel@makrotopia.org>
---
 drivers/net/dsa/mt7530.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 024b853f9558..b28d66a7c0b2 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2499,7 +2499,9 @@ static void mt7530_mac_port_get_caps(struct dsa_switch *ds, int port,
 			  config->supported_interfaces);
 		break;
 
-	case 5: /* 2nd cpu port with phy of port 0 or 4 / external phy */
+	case 5: /* Port 5 which can be used as a CPU port supports rgmii with
+		 * delays, mii, and gmii.
+		 */
 		phy_interface_set_rgmii(config->supported_interfaces);
 		__set_bit(PHY_INTERFACE_MODE_MII,
 			  config->supported_interfaces);
@@ -2507,7 +2509,9 @@ static void mt7530_mac_port_get_caps(struct dsa_switch *ds, int port,
 			  config->supported_interfaces);
 		break;
 
-	case 6: /* 1st cpu port */
+	case 6: /* Port 6 which can be used as a CPU port supports rgmii and
+		 * trgmii.
+		 */
 		__set_bit(PHY_INTERFACE_MODE_RGMII,
 			  config->supported_interfaces);
 		__set_bit(PHY_INTERFACE_MODE_TRGMII,
@@ -2527,14 +2531,17 @@ static void mt7531_mac_port_get_caps(struct dsa_switch *ds, int port,
 			  config->supported_interfaces);
 		break;
 
-	case 5: /* 2nd cpu port supports either rgmii or sgmii/8023z */
+	case 5: /* Port 5 which can be used as a CPU port supports rgmii with
+		 * delays on MT7531BE, sgmii/802.3z on MT7531AE.
+		 */
 		if (!priv->p5_sgmii) {
 			phy_interface_set_rgmii(config->supported_interfaces);
 			break;
 		}
 		fallthrough;
 
-	case 6: /* 1st cpu port supports sgmii/8023z only */
+	case 6: /* Port 6 which can be used as a CPU port supports sgmii/802.3z.
+		 */
 		__set_bit(PHY_INTERFACE_MODE_SGMII,
 			  config->supported_interfaces);
 		__set_bit(PHY_INTERFACE_MODE_1000BASEX,
@@ -2726,7 +2733,7 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		    state->interface != PHY_INTERFACE_MODE_INTERNAL)
 			goto unsupported;
 		break;
-	case 5: /* 2nd cpu port with phy of port 0 or 4 / external phy */
+	case 5: /* Port 5, can be used as a CPU port. */
 		if (priv->p5_interface == state->interface)
 			break;
 
@@ -2736,7 +2743,7 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		if (priv->p5_intf_sel != P5_DISABLED)
 			priv->p5_interface = state->interface;
 		break;
-	case 6: /* 1st cpu port */
+	case 6: /* Port 6, can be used as a CPU port. */
 		if (priv->p6_interface == state->interface)
 			break;
 
-- 
2.39.2


