Return-Path: <netdev+bounces-4280-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AF4E70BDFA
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:26:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9CA6280EF9
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:26:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD81BD52D;
	Mon, 22 May 2023 12:17:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3961640D
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:17:29 +0000 (UTC)
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78332B9;
	Mon, 22 May 2023 05:17:15 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-970028cfb6cso110344366b.1;
        Mon, 22 May 2023 05:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684757833; x=1687349833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mxWWB7HmyaQxi9NwzKK1iFLClbKEyjguXBwGckYC6x8=;
        b=Cwu9QH2AZmQcRhHwA+ZcwadKeOGCxhKOkTs82jLCRDxvAHVHr3jl1RrFR1XERbcQeT
         JX1qZJqtNrTpOVPZlDMwahBWvSeb7N7k53+2mzNX424sSgCU8moWUJXJ62SanLQZlw24
         wCwZRKtLkyqfP+OFfdBKIjAa+6Fb6zYxsoTz/hLgxpPjiTEHvdnudVhYhttdIZiZyNiK
         wiCUpoc0I1z+aYuJ85TamKkpGomqTWQXHP9StMBtA4vqf5ufXO946BTT99mxLHyWpP0s
         1dzhKNT7MyypZvWVUFsXrc+ntPxSUO1PHQtEtgo2UC0tYYp/hyXr1C6bb9PsJpsTNFor
         UKxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684757833; x=1687349833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mxWWB7HmyaQxi9NwzKK1iFLClbKEyjguXBwGckYC6x8=;
        b=MS996cHcYBseoW96/sTZZUdvZ8C2gwJTM+nTJw+ZOdCCiVRsRAQecl9m4u/CXmtIwx
         b7TT4q44qJ/TXO04QJENC1++uq2HD8uDI/+UjZ1ofB06rXxYAG0A4zLiYZBB9J4yuCCK
         PF7YEbo7n65ZuMuN136xqWhnWGqtZy8UKx4a55pLCDTzUjsWZjSbsxFhZluyJrJuI3oy
         DGaskpaUDOTvtSjGpErRPvfH0gIfj4HnLupJqmNXDoTY0BqrP1w3NQv304fLIymsHv2I
         Fc/CMhM8nzxzpSrJHCL0h5xTgcvX4ZYNkF+5S+WANUSVQyQQ4LMLsWmSZ/vTTZbrXwXJ
         XhDg==
X-Gm-Message-State: AC+VfDwq47WsbkeeTdb+KjiDuJA3yZtzz3fcJ+6/dQ9M73yvCc/nN54j
	VJTsIPyS1+nXPnXCVT3OltY=
X-Google-Smtp-Source: ACHHUZ7lHciZxL/m+3gJDMRRhfEEhmZCJvEN4N5PFHo9LfjsW5bEY/4Ew6UVZ9xDQF0lolEeJ4TpcQ==
X-Received: by 2002:a17:906:4785:b0:970:9a7:65e1 with SMTP id cw5-20020a170906478500b0097009a765e1mr1377480ejc.56.1684757833163;
        Mon, 22 May 2023 05:17:13 -0700 (PDT)
Received: from arinc9-PC.. ([149.91.1.15])
        by smtp.gmail.com with ESMTPSA id y26-20020a17090614da00b009659fed3612sm2999950ejc.24.2023.05.22.05.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 05:17:12 -0700 (PDT)
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
Subject: [PATCH net-next 29/30] net: dsa: introduce preferred_default_local_cpu_port and use on MT7530
Date: Mon, 22 May 2023 15:15:31 +0300
Message-Id: <20230522121532.86610-30-arinc.unal@arinc9.com>
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

From: Vladimir Oltean <olteanv@gmail.com>

When multiple CPU ports are being used, the numerically smallest CPU port
becomes the port all user ports become affine to. This may not be the best
choice for all switches as there may be a numerically greater CPU port with
more bandwidth than the numerically smallest one.

Such switches are MT7530 and MT7531BE, which the MT7530 DSA subdriver
controls. Port 5 of these switches has got RGMII whilst port 6 has got
either TRGMII or SGMII.

Therefore, introduce the preferred_default_local_cpu_port operation to the
DSA subsystem and use it on the MT7530 DSA subdriver to prefer port 6 as
the default CPU port.

To prove the benefit of this operation, I (Arınç) have done a bidirectional
speed test between two DSA user ports on the MT7531BE switch using iperf3.
The user ports are 1 Gbps full duplex and on different networks so the SoC
MAC would have to do 2 Gbps TX and 2 Gbps RX to deliver full speed.

Without preferring port 6:

[ ID][Role] Interval           Transfer     Bitrate         Retr
[  5][TX-C]   0.00-20.00  sec   374 MBytes   157 Mbits/sec  734    sender
[  5][TX-C]   0.00-20.00  sec   373 MBytes   156 Mbits/sec    receiver
[  7][RX-C]   0.00-20.00  sec  1.81 GBytes   778 Mbits/sec    0    sender
[  7][RX-C]   0.00-20.00  sec  1.81 GBytes   777 Mbits/sec    receiver

With preferring port 6:

[ ID][Role] Interval           Transfer     Bitrate         Retr
[  5][TX-C]   0.00-20.00  sec  1.99 GBytes   856 Mbits/sec  273    sender
[  5][TX-C]   0.00-20.00  sec  1.99 GBytes   855 Mbits/sec    receiver
[  7][RX-C]   0.00-20.00  sec  1.72 GBytes   737 Mbits/sec   15    sender
[  7][RX-C]   0.00-20.00  sec  1.71 GBytes   736 Mbits/sec    receiver

Using one port for WAN and the other ports for LAN is a very popular use
case which is what this test emulates.

This doesn't affect the remaining switches, MT7531AE and the switch on the
MT7988 SoC. Both CPU ports of the MT7531AE switch have got SGMII and there
is only one CPU port on the switch on the MT7988 SoC.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 15 +++++++++++++++
 include/net/dsa.h        |  8 ++++++++
 net/dsa/dsa.c            | 24 +++++++++++++++++++++++-
 3 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 8f5a8803cb33..8fd23da76169 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -399,6 +399,20 @@ static void mt7530_pll_setup(struct mt7530_priv *priv)
 	core_set(priv, CORE_TRGMII_GSW_CLK_CG, REG_GSWCK_EN);
 }
 
+/* If port 6 is available as a CPU port, always prefer that as the default,
+ * otherwise don't care.
+ */
+static struct dsa_port *
+mt753x_preferred_default_local_cpu_port(struct dsa_switch *ds)
+{
+	struct dsa_port *cpu_dp = dsa_to_port(ds, 6);
+
+	if (dsa_port_is_cpu(cpu_dp))
+		return cpu_dp;
+
+	return NULL;
+}
+
 /* Setup port 6 interface mode and TRGMII TX circuit */
 static void
 mt7530_setup_port6(struct dsa_switch *ds, phy_interface_t interface)
@@ -3000,6 +3014,7 @@ static int mt7988_setup(struct dsa_switch *ds)
 const struct dsa_switch_ops mt7530_switch_ops = {
 	.get_tag_protocol	= mtk_get_tag_protocol,
 	.setup			= mt753x_setup,
+	.preferred_default_local_cpu_port = mt753x_preferred_default_local_cpu_port,
 	.get_strings		= mt7530_get_strings,
 	.get_ethtool_stats	= mt7530_get_ethtool_stats,
 	.get_sset_count		= mt7530_get_sset_count,
diff --git a/include/net/dsa.h b/include/net/dsa.h
index 8903053fa5aa..ab0f0a5b0860 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -958,6 +958,14 @@ struct dsa_switch_ops {
 			       struct phy_device *phy);
 	void	(*port_disable)(struct dsa_switch *ds, int port);
 
+	/*
+	 * Compatibility between device trees defining multiple CPU ports and
+	 * drivers which are not OK to use by default the numerically smallest
+	 * CPU port of a switch for its local ports. This can return NULL,
+	 * meaning "don't know/don't care".
+	 */
+	struct dsa_port *(*preferred_default_local_cpu_port)(struct dsa_switch *ds);
+
 	/*
 	 * Port's MAC EEE settings
 	 */
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index ab1afe67fd18..1afed89e03c0 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -403,6 +403,24 @@ static int dsa_tree_setup_default_cpu(struct dsa_switch_tree *dst)
 	return 0;
 }
 
+static struct dsa_port *
+dsa_switch_preferred_default_local_cpu_port(struct dsa_switch *ds)
+{
+	struct dsa_port *cpu_dp;
+
+	if (!ds->ops->preferred_default_local_cpu_port)
+		return NULL;
+
+	cpu_dp = ds->ops->preferred_default_local_cpu_port(ds);
+	if (!cpu_dp)
+		return NULL;
+
+	if (WARN_ON(!dsa_port_is_cpu(cpu_dp) || cpu_dp->ds != ds))
+		return NULL;
+
+	return cpu_dp;
+}
+
 /* Perform initial assignment of CPU ports to user ports and DSA links in the
  * fabric, giving preference to CPU ports local to each switch. Default to
  * using the first CPU port in the switch tree if the port does not have a CPU
@@ -410,12 +428,16 @@ static int dsa_tree_setup_default_cpu(struct dsa_switch_tree *dst)
  */
 static int dsa_tree_setup_cpu_ports(struct dsa_switch_tree *dst)
 {
-	struct dsa_port *cpu_dp, *dp;
+	struct dsa_port *preferred_cpu_dp, *cpu_dp, *dp;
 
 	list_for_each_entry(cpu_dp, &dst->ports, list) {
 		if (!dsa_port_is_cpu(cpu_dp))
 			continue;
 
+		preferred_cpu_dp = dsa_switch_preferred_default_local_cpu_port(cpu_dp->ds);
+		if (preferred_cpu_dp && preferred_cpu_dp != cpu_dp)
+			continue;
+
 		/* Prefer a local CPU port */
 		dsa_switch_for_each_port(dp, cpu_dp->ds) {
 			/* Prefer the first local CPU port found */
-- 
2.39.2


