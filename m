Return-Path: <netdev+bounces-10000-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA1D472B9A4
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:03:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED7101C20A9F
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:03:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77F7A156D8;
	Mon, 12 Jun 2023 08:00:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C76C168A6
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:00:40 +0000 (UTC)
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F16610D4;
	Mon, 12 Jun 2023 01:00:18 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4f642a24568so4571281e87.2;
        Mon, 12 Jun 2023 01:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686556816; x=1689148816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lvRcwdwKF23WlBw1GQDVWmiphaH9UUywqfX3Q4qWYTI=;
        b=h90xNNQDima1Afxzqwau5EjgZTBuL3HNXA9h4zI5Y+ZrBm5i6QfGtXw62sLjz0xZRU
         JP+H2R8aGaPyGedxjkqA0aE7MzWQOsIsn3WvdRIQwRWiydYho5gJ1HOTWhBL1LxmvANc
         VVxGEVLJMnEvPSquEsDb1heE8dwgWoIZx7GMkbCGBE/0o7TPJvV95xjug8xELKSzAJDa
         e0VPBX9XyuCMtmDIuNUwXo0E44eco7YfZIeQQGRJi137DB1r7MUXpaNrnXp05l1unjnI
         Yah5246xGZjakb1MU/vbeixuOENQ0JhTL9YyJ7j/jX3ME/wk2+eAGo0iRT2YOgjl/aSV
         k98w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686556816; x=1689148816;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lvRcwdwKF23WlBw1GQDVWmiphaH9UUywqfX3Q4qWYTI=;
        b=VZe6dRz/IKitzt3T16qcYNZjutswME7iIe9ewpGuQFLsYBbPXOO86mstqECEXmm2os
         wjDzkuZJc/EV1WnXhYFiZCuHdAuKZNSFp6wRMS53nZw/ttJS7oHd9h0DMFD6Ipgyekii
         Hb8b7h8ToQxas5WvH6QNmZUIzL55nJPt5JUL4C1vPS6WiJfdOBw6oatzEJcrv50V8ZCq
         G5VCNI/k0hySWMAhUQdSLMW5s2u3yoNgF2dlIQ+gS3YCQHU0h6bvX8oRPUwXkSUWTO/M
         Ti53/8/MHKyf8ll9o31ZGc5mwXUU8vF7M0/hTcOxIJ3n7KeltqvHfBWSmHGA4PagmiF2
         QL8A==
X-Gm-Message-State: AC+VfDyRUAYZUiRebeJCfNDuZ1qO/ay88EAeD6jFcCxYc3aEXH7vKVZb
	TY09zblNUmyWGKGvpCv0C3b7aUhrPas=
X-Google-Smtp-Source: ACHHUZ4ClpVZM0YENkqEyxPU2Tp9GT8Dlmin9l43fMlLsl9n8UMu2bRKCaQVTKrU/akFqfOSH3+Wgw==
X-Received: by 2002:a19:e306:0:b0:4f6:2b21:ece1 with SMTP id a6-20020a19e306000000b004f62b21ece1mr3640826lfh.43.1686556816145;
        Mon, 12 Jun 2023 01:00:16 -0700 (PDT)
Received: from arinc9-Xeront.lan (178-147-169-233.haap.dm.cosmote.net. [178.147.169.233])
        by smtp.gmail.com with ESMTPSA id y22-20020a7bcd96000000b003f7f2a1484csm10552195wmj.5.2023.06.12.01.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 01:00:15 -0700 (PDT)
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
Subject: [PATCH net v4 6/7] net: dsa: introduce preferred_default_local_cpu_port and use on MT7530
Date: Mon, 12 Jun 2023 10:59:44 +0300
Message-Id: <20230612075945.16330-7-arinc.unal@arinc9.com>
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

From: Vladimir Oltean <olteanv@gmail.com>

Since the introduction of the OF bindings, DSA has always had a policy that
in case multiple CPU ports are present in the device tree, the numerically
smallest one is always chosen.

The MT7530 switch family, except the switch on the MT7988 SoC, has 2 CPU
ports, 5 and 6, where port 6 is preferable on the MT7531BE switch because
it has higher bandwidth.

The MT7530 driver developers had 3 options:
- to modify DSA when the MT7531 switch support was introduced, such as to
  prefer the better port
- to declare both CPU ports in device trees as CPU ports, and live with the
  sub-optimal performance resulting from not preferring the better port
- to declare just port 6 in the device tree as a CPU port

Of course they chose the path of least resistance (3rd option), kicking the
can down the road. The hardware description in the device tree is supposed
to be stable - developers are not supposed to adopt the strategy of
piecemeal hardware description, where the device tree is updated in
lockstep with the features that the kernel currently supports.

Now, as a result of the fact that they did that, any attempts to modify the
device tree and describe both CPU ports as CPU ports would make DSA change
its default selection from port 6 to 5, effectively resulting in a
performance degradation visible to users with the MT7531BE switch as can be
seen below.

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

As such, this change proposes that we retroactively modify stable kernels
to keep the mt7530 driver preferring port 6 even with device trees where
the hardware is more fully described.

Fixes: c288575f7810 ("net: dsa: mt7530: Add the support of MT7531 switch")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
---
 drivers/net/dsa/mt7530.c | 15 +++++++++++++++
 include/net/dsa.h        |  8 ++++++++
 net/dsa/dsa.c            | 24 +++++++++++++++++++++++-
 3 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 8388b058fbe4..4c44fc664419 100644
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
 static int
 mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
@@ -3122,6 +3136,7 @@ static int mt7988_setup(struct dsa_switch *ds)
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


