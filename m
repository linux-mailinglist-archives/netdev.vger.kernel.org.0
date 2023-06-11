Return-Path: <netdev+bounces-9894-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B1F272B0E3
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 10:41:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 43FBE1C20AF4
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 08:41:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 974F38BF6;
	Sun, 11 Jun 2023 08:39:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836695384
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 08:39:40 +0000 (UTC)
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069AA270F;
	Sun, 11 Jun 2023 01:39:37 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f7f6341b99so23921475e9.2;
        Sun, 11 Jun 2023 01:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686472777; x=1689064777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MAnAZVSPifd50CdoCXOUbyrbAVvi3EcR5cj3t2QSLWo=;
        b=NAcl+hecbl7ELRNNe0Tm7sD7y7VxCoaTm2Kwc+7EADc9UhIYJjsylcrIo9nklwLGtv
         LvrHD5jaeN5WGZlUeM5Us2afaIBN1mFuWpoYGS2FI1YfTIVT2GUZHeCf9SaI0VYfJc++
         TMjk1v7m4DSAdQ2xMlDMjlwD04EfPRTy+iv7cSPOFBOPldxaYa/id0x01UhH9GtQ3SZK
         8HHiVEm/4UJG6zc+zkmTDC1SsNM1GQX2I8dOn8yv8AYNcu2ZunPqlV8oQBJ6I7zvj8Uv
         5vgnHhBVCXxqZbR9eJpFmSwbfNH8Ys+4OKac8sK1OPLN1Yd6mu0sFYh0wI/GFP30cvfE
         avEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686472777; x=1689064777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MAnAZVSPifd50CdoCXOUbyrbAVvi3EcR5cj3t2QSLWo=;
        b=b8GLm6vq7zSVQem5UfPsRQ9Ovsq16SQyyYEvixccuegppoCrG1nmvG9ew8ggpkCHik
         z+sWUKO3EZ9O2fJUelgqAh45qzJHgyW1OsfnS5gpctkBYkLfdL96MW9ow8ImCc4vrfCK
         oY1QVUh6EZMPWNcvNNQvbr+3oTadJEI4PMEMKIBJho6w7ZxqfmyFTEbQ3Ql1tzVMrJja
         ZRXjegMGC7OXESxoj9yP5MmqPKX/7ja/xiFriMQjouM+2sAJFfxjG30No6Zmvjv0qSpo
         xfySxMhW1eu3e0Dgu5TaeVVxhkLMXNlK8I+afSLH/n13HbOVFt1pxqKzWNonVdt0aOSA
         XdRw==
X-Gm-Message-State: AC+VfDxtK65oLt1h5DfBa9Sjfshpz7Bi79tSwebfKABkkm2Q5jijXUaF
	KaW+8O5sdFCT/C6AzuM/ySw=
X-Google-Smtp-Source: ACHHUZ5PDbzHHpaPuRf/VYBY2pI17Rv3g5jflGHbNwYkw1TG0thMQ1DzrhJJ2EK7x6zW5nw+iVRGHw==
X-Received: by 2002:a7b:cd0d:0:b0:3f7:e497:aa03 with SMTP id f13-20020a7bcd0d000000b003f7e497aa03mr4213388wmj.28.1686472777346;
        Sun, 11 Jun 2023 01:39:37 -0700 (PDT)
Received: from arinc9-Xeront.lan (178-147-169-233.haap.dm.cosmote.net. [178.147.169.233])
        by smtp.gmail.com with ESMTPSA id 17-20020a05600c22d100b003f8044b3436sm7394629wmg.23.2023.06.11.01.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jun 2023 01:39:37 -0700 (PDT)
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
Subject: [PATCH net v3 6/7] net: dsa: introduce preferred_default_local_cpu_port and use on MT7530
Date: Sun, 11 Jun 2023 11:39:13 +0300
Message-Id: <20230611083914.28603-7-arinc.unal@arinc9.com>
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
index 97f389f8d6ea..1ec047e552d2 100644
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


