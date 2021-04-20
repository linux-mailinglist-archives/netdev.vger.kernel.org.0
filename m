Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D44365FD7
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 20:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbhDTSys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 14:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbhDTSxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 14:53:54 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF885C06138B
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 11:53:22 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id h4so29727791wrt.12
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 11:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=DVT34xbFXaPnvoieTtOcIt1rnQTubqA9Yct1KcT48x0=;
        b=LCQfsI6PWn0hgRr15bLrPeT19Fc5hiiVZVt5vullnMc9sG5w2UGuH5gH0LtbVpGCMM
         wBOwL2m/nlIJpqhQ2UzzLqLbCVZYKd3/Yq9lXPZc1vUU9tVz6IfSIpDgTuwFV9Zprwhw
         jqLorircGub6EfNRU3oBAa7CNoDm6OfttOEJOVA9QC02FEg6EFtHtVqanPvJPMPpEmu3
         hQl4BGccv4+ITYYxeZnnYQXrri37Ssta5+CUM2CvWf7TYhijVmZdJ6J/OoOBpll73Ccn
         QCos0zlsm4GF7nCzVJwwcFMDd/T5xzNlM/TuT+4K4lxCIScqE7cKa5LhJXhstguyi+eh
         lwng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=DVT34xbFXaPnvoieTtOcIt1rnQTubqA9Yct1KcT48x0=;
        b=GDPfv1N4g4ZZx1sut19QtHt7vb+wBKuyXbdnqmE2h8+lPvGOi+p7aaPmKieQFkwYs1
         OWgSu6BIN4ebJ6B3iFp7piE2OJDGcA0LKrbEFEtREQxwPhv/FSjsjHM3XHRB8pEBUTqa
         hFXp54gUf7lzWHUnuvfNlH8jcFx2GjHHMOlxqHXShjpEGCoo0d8eLMRBC5UuRnr3OXyq
         IJdjcpv8iTnaTlvgRTB5y+C5S1Mz4ABtehEvl35sAVnteyp4Hj/jcsxyV6LS9Zx5ymEY
         Lp7J85/3TvobVQi0sZJGhMj5gzDw6K+bxcBljmge5K1IIplPtsqS0sOpa3SJFaRUFjY2
         UXBA==
X-Gm-Message-State: AOAM532uBpa220+RcrixryFMbH7jDWgUDNi4nqRPco7CAAN+mxXBr8t0
        L2gZM9NAEBwwPhFsclVFpfaRlQ==
X-Google-Smtp-Source: ABdhPJwE9u3NSuU3yRSsp7ew38owm+hiBgMeWScRDQEXonN4MYDRXJztXbv4E+d4qPkYxylwUXjVfg==
X-Received: by 2002:a5d:5914:: with SMTP id v20mr22118858wrd.402.1618944801628;
        Tue, 20 Apr 2021 11:53:21 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id f7sm25897402wrp.48.2021.04.20.11.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 11:53:21 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v3 net-next 1/5] net: dsa: mv88e6xxx: Mark chips with undocumented EDSA tag support
Date:   Tue, 20 Apr 2021 20:53:07 +0200
Message-Id: <20210420185311.899183-2-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210420185311.899183-1-tobias@waldekranz.com>
References: <20210420185311.899183-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All devices are capable of using regular DSA tags. Support for
Ethertyped DSA tags sort into three categories:

1. No support. Older chips fall into this category.

2. Full support. Datasheet explicitly supports configuring the CPU
   port to receive FORWARDs with a DSA tag.

3. Undocumented support. Datasheet lists the configuration from
   category 2 as "reserved for future use", but does empirically
   behave like a category 2 device.

So, instead of listing the one true protocol that should be used by a
particular chip, specify the level of support for EDSA (support for
regular DSA is implicit on all chips). As before, we use EDSA for all
chips that fully supports it.

In upcoming changes, we will use this information to support
dynamically changing the tag protocol.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 60 ++++++++++++++------------------
 drivers/net/dsa/mv88e6xxx/chip.h | 21 ++++++++++-
 2 files changed, 46 insertions(+), 35 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 860dca41cf4b..3e8b914aaf37 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2531,10 +2531,10 @@ static int mv88e6xxx_setup_port_mode(struct mv88e6xxx_chip *chip, int port)
 		return mv88e6xxx_set_port_mode_normal(chip, port);
 
 	/* Setup CPU port mode depending on its supported tag format */
-	if (chip->info->tag_protocol == DSA_TAG_PROTO_DSA)
+	if (chip->tag_protocol == DSA_TAG_PROTO_DSA)
 		return mv88e6xxx_set_port_mode_dsa(chip, port);
 
-	if (chip->info->tag_protocol == DSA_TAG_PROTO_EDSA)
+	if (chip->tag_protocol == DSA_TAG_PROTO_EDSA)
 		return mv88e6xxx_set_port_mode_edsa(chip, port);
 
 	return -EINVAL;
@@ -4785,7 +4785,6 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0xf,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_DSA,
 		.ops = &mv88e6085_ops,
 	},
 
@@ -4806,7 +4805,6 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.g1_irqs = 8,
 		.atu_move_port_mask = 0xf,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_DSA,
 		.ops = &mv88e6095_ops,
 	},
 
@@ -4829,7 +4827,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0xf,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_EDSA,
+		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ops = &mv88e6097_ops,
 	},
 
@@ -4852,7 +4850,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0xf,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_EDSA,
+		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ops = &mv88e6123_ops,
 	},
 
@@ -4873,7 +4871,6 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.g1_irqs = 9,
 		.atu_move_port_mask = 0xf,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_DSA,
 		.ops = &mv88e6131_ops,
 	},
 
@@ -4897,7 +4894,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.g2_irqs = 10,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_EDSA,
+		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ops = &mv88e6141_ops,
 	},
 
@@ -4920,7 +4917,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0xf,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_EDSA,
+		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ptp_support = true,
 		.ops = &mv88e6161_ops,
 	},
@@ -4944,7 +4941,6 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0xf,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_DSA,
 		.ptp_support = true,
 		.ops = &mv88e6165_ops,
 	},
@@ -4968,7 +4964,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0xf,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_EDSA,
+		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ops = &mv88e6171_ops,
 	},
 
@@ -4992,7 +4988,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0xf,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_EDSA,
+		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ops = &mv88e6172_ops,
 	},
 
@@ -5015,7 +5011,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0xf,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_EDSA,
+		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ops = &mv88e6175_ops,
 	},
 
@@ -5039,7 +5035,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0xf,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_EDSA,
+		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ops = &mv88e6176_ops,
 	},
 
@@ -5060,7 +5056,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.g1_irqs = 8,
 		.atu_move_port_mask = 0xf,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_EDSA,
+		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ops = &mv88e6185_ops,
 	},
 
@@ -5078,7 +5074,6 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.phy_base_addr = 0x0,
 		.global1_addr = 0x1b,
 		.global2_addr = 0x1c,
-		.tag_protocol = DSA_TAG_PROTO_DSA,
 		.age_time_coeff = 3750,
 		.g1_irqs = 9,
 		.g2_irqs = 14,
@@ -5108,7 +5103,6 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0x1f,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_DSA,
 		.ops = &mv88e6190x_ops,
 	},
 
@@ -5131,7 +5125,6 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0x1f,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_DSA,
 		.ptp_support = true,
 		.ops = &mv88e6191_ops,
 	},
@@ -5154,7 +5147,6 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0x1f,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_DSA,
 		.ptp_support = true,
 		.ops = &mv88e6393x_ops,
 	},
@@ -5177,7 +5169,6 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0x1f,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_DSA,
 		.ptp_support = true,
 		.ops = &mv88e6393x_ops,
 	},
@@ -5204,7 +5195,6 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.g2_irqs = 10,
 		.atu_move_port_mask = 0xf,
 		.dual_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_DSA,
 		.ptp_support = true,
 		.ops = &mv88e6250_ops,
 	},
@@ -5229,7 +5219,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0xf,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_EDSA,
+		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ptp_support = true,
 		.ops = &mv88e6240_ops,
 	},
@@ -5251,7 +5241,6 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.g2_irqs = 10,
 		.atu_move_port_mask = 0xf,
 		.dual_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_DSA,
 		.ptp_support = true,
 		.ops = &mv88e6250_ops,
 	},
@@ -5275,7 +5264,6 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0x1f,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_DSA,
 		.ptp_support = true,
 		.ops = &mv88e6290_ops,
 	},
@@ -5300,7 +5288,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0xf,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_EDSA,
+		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ptp_support = true,
 		.ops = &mv88e6320_ops,
 	},
@@ -5324,7 +5312,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.g2_irqs = 10,
 		.atu_move_port_mask = 0xf,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_EDSA,
+		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ptp_support = true,
 		.ops = &mv88e6321_ops,
 	},
@@ -5349,7 +5337,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.g2_irqs = 10,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_EDSA,
+		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ptp_support = true,
 		.ops = &mv88e6341_ops,
 	},
@@ -5373,7 +5361,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0xf,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_EDSA,
+		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ops = &mv88e6350_ops,
 	},
 
@@ -5396,7 +5384,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0xf,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_EDSA,
+		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ops = &mv88e6351_ops,
 	},
 
@@ -5420,7 +5408,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0xf,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_EDSA,
+		.edsa_support = MV88E6XXX_EDSA_SUPPORTED,
 		.ptp_support = true,
 		.ops = &mv88e6352_ops,
 	},
@@ -5444,7 +5432,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0x1f,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_DSA,
+		.edsa_support = MV88E6XXX_EDSA_UNDOCUMENTED,
 		.ptp_support = true,
 		.ops = &mv88e6390_ops,
 	},
@@ -5468,7 +5456,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0x1f,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_DSA,
+		.edsa_support = MV88E6XXX_EDSA_UNDOCUMENTED,
 		.ptp_support = true,
 		.ops = &mv88e6390x_ops,
 	},
@@ -5491,7 +5479,6 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.atu_move_port_mask = 0x1f,
 		.pvt = true,
 		.multi_chip = true,
-		.tag_protocol = DSA_TAG_PROTO_DSA,
 		.ptp_support = true,
 		.ops = &mv88e6393x_ops,
 	},
@@ -5560,7 +5547,7 @@ static enum dsa_tag_protocol mv88e6xxx_get_tag_protocol(struct dsa_switch *ds,
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
 
-	return chip->info->tag_protocol;
+	return chip->tag_protocol;
 }
 
 static int mv88e6xxx_port_mdb_add(struct dsa_switch *ds, int port,
@@ -6205,6 +6192,11 @@ static int mv88e6xxx_probe(struct mdio_device *mdiodev)
 	if (err)
 		goto out;
 
+	if (chip->info->edsa_support == MV88E6XXX_EDSA_SUPPORTED)
+		chip->tag_protocol = DSA_TAG_PROTO_EDSA;
+	else
+		chip->tag_protocol = DSA_TAG_PROTO_DSA;
+
 	mv88e6xxx_phy_init(chip);
 
 	if (chip->info->ops->get_eeprom) {
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index bce6e0dc8535..4f116f73a74b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -96,6 +96,22 @@ enum mv88e6xxx_family {
 	MV88E6XXX_FAMILY_6393,	/* 6191X 6193X 6393X */
 };
 
+/**
+ * enum mv88e6xxx_edsa_support - Ethertype DSA tag support level
+ * @MV88E6XXX_EDSA_UNSUPPORTED:  Device has no support for EDSA tags
+ * @MV88E6XXX_EDSA_UNDOCUMENTED: Documentation indicates that
+ *                               egressing FORWARD frames with an EDSA
+ *                               tag is reserved for future use, but
+ *                               empirical data shows that this mode
+ *                               is supported.
+ * @MV88E6XXX_EDSA_SUPPORTED:    EDSA tags are fully supported.
+ */
+enum mv88e6xxx_edsa_support {
+	MV88E6XXX_EDSA_UNSUPPORTED = 0,
+	MV88E6XXX_EDSA_UNDOCUMENTED,
+	MV88E6XXX_EDSA_SUPPORTED,
+};
+
 struct mv88e6xxx_ops;
 
 struct mv88e6xxx_info {
@@ -133,7 +149,7 @@ struct mv88e6xxx_info {
 	 */
 	bool dual_chip;
 
-	enum dsa_tag_protocol tag_protocol;
+	enum mv88e6xxx_edsa_support edsa_support;
 
 	/* Mask for FromPort and ToPort value of PortVec used in ATU Move
 	 * operation. 0 means that the ATU Move operation is not supported.
@@ -261,6 +277,9 @@ struct mv88e6xxx_region_priv {
 struct mv88e6xxx_chip {
 	const struct mv88e6xxx_info *info;
 
+	/* Currently configured tagging protocol */
+	enum dsa_tag_protocol tag_protocol;
+
 	/* The dsa_switch this private structure is related to */
 	struct dsa_switch *ds;
 
-- 
2.25.1

