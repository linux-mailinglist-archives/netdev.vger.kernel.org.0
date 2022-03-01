Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A394C88E0
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 11:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbiCAKEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 05:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234161AbiCAKEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 05:04:41 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95308CDA6
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 02:03:57 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id 29so21102234ljv.10
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 02:03:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=9aG6JPCK/sc9cnjNg+7v1niwfwPA6zUyJ/dRYHoXrdI=;
        b=dMz97POLoB/rvgv4lh3Wm2uwAH6bOuL/AqYXcbD2KQGkhEWLvjBuTaVWfmPtCPZIrn
         tuf2WnuNnTz6LMiG8wxHT8C+8NzZ8CffzayeLoadPQIigk63Xle1QI1d51negUkxNvpF
         GiC542zbVtC12eSovgrmut/nb2aEwT09ofq0YWKDIA0QNkyIQ+A4wMJ/RciE0j/oMKxb
         ySlxhUxrdGjzG7afLCqthqGD5QEsZBKUWGCXuBEPpjiEsQ0hlDn1vg9duW8kce1k4KiG
         SwtoUXC5H5WiXLLrY+ffBMSJYL26fDgR3Qu+QgQVib1DKCQbOzww7OmZKKs4RDIOhQks
         JR0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=9aG6JPCK/sc9cnjNg+7v1niwfwPA6zUyJ/dRYHoXrdI=;
        b=IWXdCdsA/d/C2/Gtq1xnNIhrLCs5kw9FvZYmpFR9Kpz5qZxb7Mulb2YGzDCPjSlHuA
         4VmG8KNFj6HgOTuJkamlPEsUq3Jm8CHYKJZUgkHhFslrlTDSBx/SDT67+D8Y6rhbvqQ5
         CUdc/Fvg/Lmq7wKfhJkJt009awvaCOKTlaBwPG6alJXsuXfaHyK7EbOmFm66bkJ8D8Si
         Ej5AIzGX+wLXt0yxGKozRuOl04gAVeUP2ctViz1ncaXEfl6YlfXegfPNBxA7FYzjLSwy
         jT/5i/7bOPDYGx/0JfaYDr1p2e3z9HNB9EJpPDTtVAMrtUEKixGNRArvlbarhw/suxIK
         JtYA==
X-Gm-Message-State: AOAM5328oESZsVLF78KAcSMxaWMShIByVukYaqdPiYICC4mLCVU4tAxN
        gaU99SXASeSqNHY2bDIAFit0kQ==
X-Google-Smtp-Source: ABdhPJzlxUGPympF9oBT7T14ljrqe3/UKL6S64m2KsGlenzwBcr0vutEaCND8YDUhFDHuDJ7MUuduw==
X-Received: by 2002:a2e:a4dc:0:b0:246:4205:98e7 with SMTP id p28-20020a2ea4dc000000b00246420598e7mr16357247ljm.55.1646129036124;
        Tue, 01 Mar 2022 02:03:56 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id s27-20020a05651c049b00b002460fd4252asm1826822ljc.100.2022.03.01.02.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 02:03:55 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: [PATCH v2 net-next 09/10] net: dsa: mv88e6xxx: Export STU as devlink region
Date:   Tue,  1 Mar 2022 11:03:20 +0100
Message-Id: <20220301100321.951175-10-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301100321.951175-1-tobias@waldekranz.com>
References: <20220301100321.951175-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export the raw STU data in a devlink region so that it can be
inspected from userspace and compared to the current bridge
configuration.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.h    |  1 +
 drivers/net/dsa/mv88e6xxx/devlink.c | 94 +++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index be654be69982..6d4daa24d3e5 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -287,6 +287,7 @@ enum mv88e6xxx_region_id {
 	MV88E6XXX_REGION_GLOBAL2,
 	MV88E6XXX_REGION_ATU,
 	MV88E6XXX_REGION_VTU,
+	MV88E6XXX_REGION_STU,
 	MV88E6XXX_REGION_PVT,
 
 	_MV88E6XXX_REGION_MAX,
diff --git a/drivers/net/dsa/mv88e6xxx/devlink.c b/drivers/net/dsa/mv88e6xxx/devlink.c
index 381068395c63..1266eabee086 100644
--- a/drivers/net/dsa/mv88e6xxx/devlink.c
+++ b/drivers/net/dsa/mv88e6xxx/devlink.c
@@ -503,6 +503,85 @@ static int mv88e6xxx_region_vtu_snapshot(struct devlink *dl,
 	return 0;
 }
 
+/**
+ * struct mv88e6xxx_devlink_stu_entry - Devlink STU entry
+ * @sid:   Global1/3:   SID, unknown filters and learning.
+ * @vid:   Global1/6:   Valid bit.
+ * @data:  Global1/7-9: Membership data and priority override.
+ * @resvd: Reserved. In case we forgot something.
+ *
+ * The STU entry format varies between chipset generations. Peridot
+ * and Amethyst packs the STU data into Global1/7-8. Older silicon
+ * spreads the information across all three VTU data registers -
+ * inheriting the layout of even older hardware that had no STU at
+ * all. Since this is a low-level debug interface, copy all data
+ * verbatim and defer parsing to the consumer.
+ */
+struct mv88e6xxx_devlink_stu_entry {
+	u16 sid;
+	u16 vid;
+	u16 data[3];
+	u16 resvd;
+};
+
+static int mv88e6xxx_region_stu_snapshot(struct devlink *dl,
+					 const struct devlink_region_ops *ops,
+					 struct netlink_ext_ack *extack,
+					 u8 **data)
+{
+	struct mv88e6xxx_devlink_stu_entry *table, *entry;
+	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
+	struct mv88e6xxx_chip *chip = ds->priv;
+	struct mv88e6xxx_stu_entry stu;
+	int err;
+
+	table = kcalloc(mv88e6xxx_max_sid(chip) + 1,
+			sizeof(struct mv88e6xxx_devlink_stu_entry),
+			GFP_KERNEL);
+	if (!table)
+		return -ENOMEM;
+
+	entry = table;
+	stu.sid = mv88e6xxx_max_sid(chip);
+	stu.valid = false;
+
+	mv88e6xxx_reg_lock(chip);
+
+	do {
+		err = mv88e6xxx_g1_stu_getnext(chip, &stu);
+		if (err)
+			break;
+
+		if (!stu.valid)
+			break;
+
+		err = err ? : mv88e6xxx_g1_read(chip, MV88E6352_G1_VTU_SID,
+						&entry->sid);
+		err = err ? : mv88e6xxx_g1_read(chip, MV88E6XXX_G1_VTU_VID,
+						&entry->vid);
+		err = err ? : mv88e6xxx_g1_read(chip, MV88E6XXX_G1_VTU_DATA1,
+						&entry->data[0]);
+		err = err ? : mv88e6xxx_g1_read(chip, MV88E6XXX_G1_VTU_DATA2,
+						&entry->data[1]);
+		err = err ? : mv88e6xxx_g1_read(chip, MV88E6XXX_G1_VTU_DATA3,
+						&entry->data[2]);
+		if (err)
+			break;
+
+		entry++;
+	} while (stu.sid < mv88e6xxx_max_sid(chip));
+
+	mv88e6xxx_reg_unlock(chip);
+
+	if (err) {
+		kfree(table);
+		return err;
+	}
+
+	*data = (u8 *)table;
+	return 0;
+}
+
 static int mv88e6xxx_region_pvt_snapshot(struct devlink *dl,
 					 const struct devlink_region_ops *ops,
 					 struct netlink_ext_ack *extack,
@@ -605,6 +684,12 @@ static struct devlink_region_ops mv88e6xxx_region_vtu_ops = {
 	.destructor = kfree,
 };
 
+static struct devlink_region_ops mv88e6xxx_region_stu_ops = {
+	.name = "stu",
+	.snapshot = mv88e6xxx_region_stu_snapshot,
+	.destructor = kfree,
+};
+
 static struct devlink_region_ops mv88e6xxx_region_pvt_ops = {
 	.name = "pvt",
 	.snapshot = mv88e6xxx_region_pvt_snapshot,
@@ -640,6 +725,11 @@ static struct mv88e6xxx_region mv88e6xxx_regions[] = {
 		.ops = &mv88e6xxx_region_vtu_ops
 	  /* calculated at runtime */
 	},
+	[MV88E6XXX_REGION_STU] = {
+		.ops = &mv88e6xxx_region_stu_ops,
+		.cond = mv88e6xxx_has_stu,
+	  /* calculated at runtime */
+	},
 	[MV88E6XXX_REGION_PVT] = {
 		.ops = &mv88e6xxx_region_pvt_ops,
 		.size = MV88E6XXX_MAX_PVT_ENTRIES * sizeof(u16),
@@ -706,6 +796,10 @@ int mv88e6xxx_setup_devlink_regions_global(struct dsa_switch *ds)
 			size = (mv88e6xxx_max_vid(chip) + 1) *
 				sizeof(struct mv88e6xxx_devlink_vtu_entry);
 			break;
+		case MV88E6XXX_REGION_STU:
+			size = (mv88e6xxx_max_sid(chip) + 1) *
+				sizeof(struct mv88e6xxx_devlink_stu_entry);
+			break;
 		}
 
 		region = dsa_devlink_region_create(ds, ops, 1, size);
-- 
2.25.1

