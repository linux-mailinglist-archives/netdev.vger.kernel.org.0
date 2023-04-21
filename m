Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A148D6EAD28
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:38:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbjDUOhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232773AbjDUOhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:37:17 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A42830D3;
        Fri, 21 Apr 2023 07:37:05 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-5068e99960fso2929001a12.1;
        Fri, 21 Apr 2023 07:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682087824; x=1684679824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZzMK7vF3K2CEqwtvJdFcGt8aeUfJvcS1teZcz3caE9E=;
        b=sM3ffQEoXLR2QcBxnhSJwnPaaRFFvBGoWqzc/G98cgBTFfqCP9p3/mdmbO4pPZq4JE
         yO/dR5pNXlkxCZzt3+MNZi98uTlR9PVoLpzGVRF3whPJAJhbrSQbzg4TcqJ0tyVDZ1BK
         vsRxqBHGuHnSNCqHKa/NEP8yA7u5BxEsPENB6JIrjlr7cnnNPRMXieUndMWQHyNIzNMQ
         l0Wkwd/R7Ulgtgrvvp1L5KG+BF8pBJxaRng3/yfp3FSinPfIK0YrVz1rLs032F0IMM76
         lnhhdlCW2ukN1zQ3ugc1RT8mWvq+zBXGF5E1MoOwd6lGunyaqKU0O5vyFfP0ufaEeu0P
         m24w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682087824; x=1684679824;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZzMK7vF3K2CEqwtvJdFcGt8aeUfJvcS1teZcz3caE9E=;
        b=Qww6kcq4xCQSAN338atrebBFtjuabehMNwoKOSLaA1n6plGRW5Pl3tSSjfg6rWdEo1
         4MrtHzN9r6gQIYg9jfgljBFai7+JkQCpf6V9MCkhUoXuHIClrr5zIgvUv8tMXg4ybfDS
         DwenYM+VsspDq4khg11U0L5QHs1mOFgL/xlnhE7t/rf196qJsLef/ZB7SNxzoQLMPTOn
         QoJSbcVH0okRiqJ+vq+GKjAvtIEfiXL7MZtk1C/TXtsat7Z+C9o/5wxH1HRVnzSCAsA+
         0nzxB7TZranhrs+WwBvGJnexm2yaT0LDzZLuNGNM5AA5AVlA8zL75FWIaXZipTDn1e/O
         WiIQ==
X-Gm-Message-State: AAQBX9dpiUxLTsrx/w31HHpL5TUz2XNTh4vX5MdUQZItNAf3JTqvRjY2
        4vdjRaLf5Y5KpnvMKggD414=
X-Google-Smtp-Source: AKy350YGydwy0/ywHqLVQVLP6Ui7/86QStLDq5oJdInniAwp66LsSXx1hsDrDfottCNzePunSDkFbg==
X-Received: by 2002:a17:906:224d:b0:94f:3eca:ab05 with SMTP id 13-20020a170906224d00b0094f3ecaab05mr2736418ejr.59.1682087823763;
        Fri, 21 Apr 2023 07:37:03 -0700 (PDT)
Received: from arinc9-PC.lan ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id q27-20020a170906361b00b0094e1026bc66sm2168244ejb.140.2023.04.21.07.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 07:37:03 -0700 (PDT)
From:   arinc9.unal@gmail.com
X-Google-Original-From: arinc.unal@arinc9.com
To:     Sean Wang <sean.wang@mediatek.com>,
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
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [RFC PATCH net-next 04/22] net: dsa: mt7530: improve comments regarding port 5 and 6
Date:   Fri, 21 Apr 2023 17:36:30 +0300
Message-Id: <20230421143648.87889-5-arinc.unal@arinc9.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230421143648.87889-1-arinc.unal@arinc9.com>
References: <20230421143648.87889-1-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/dsa/mt7530.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index edc34be745b2..e956ffa1eea8 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2504,7 +2504,9 @@ static void mt7530_mac_port_get_caps(struct dsa_switch *ds, int port,
 			  config->supported_interfaces);
 		break;
 
-	case 5: /* 2nd cpu port with phy of port 0 or 4 / external phy */
+	case 5: /* Port 5 which can be used as a CPU port supports rgmii with
+		 * delays, mii, and gmii.
+		 */
 		phy_interface_set_rgmii(config->supported_interfaces);
 		__set_bit(PHY_INTERFACE_MODE_MII,
 			  config->supported_interfaces);
@@ -2512,7 +2514,9 @@ static void mt7530_mac_port_get_caps(struct dsa_switch *ds, int port,
 			  config->supported_interfaces);
 		break;
 
-	case 6: /* 1st cpu port */
+	case 6: /* Port 6 which can be used as a CPU port supports rgmii and
+		 * trgmii.
+		 */
 		__set_bit(PHY_INTERFACE_MODE_RGMII,
 			  config->supported_interfaces);
 		__set_bit(PHY_INTERFACE_MODE_TRGMII,
@@ -2532,14 +2536,17 @@ static void mt7531_mac_port_get_caps(struct dsa_switch *ds, int port,
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
@@ -2731,7 +2738,7 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		    state->interface != PHY_INTERFACE_MODE_INTERNAL)
 			goto unsupported;
 		break;
-	case 5: /* 2nd cpu port with phy of port 0 or 4 / external phy */
+	case 5: /* Port 5, can be used as a CPU port. */
 		if (priv->p5_interface == state->interface)
 			break;
 
@@ -2741,7 +2748,7 @@ mt753x_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		if (priv->p5_intf_sel != P5_DISABLED)
 			priv->p5_interface = state->interface;
 		break;
-	case 6: /* 1st cpu port */
+	case 6: /* Port 6, can be used as a CPU port. */
 		if (priv->p6_interface == state->interface)
 			break;
 
-- 
2.37.2

