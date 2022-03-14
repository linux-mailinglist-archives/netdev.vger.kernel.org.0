Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5B94D7F3E
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 10:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238285AbiCNJz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 05:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238276AbiCNJzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 05:55:10 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D28234B9E
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 02:53:16 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 25so20965211ljv.10
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 02:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:organization:content-transfer-encoding;
        bh=9aG6JPCK/sc9cnjNg+7v1niwfwPA6zUyJ/dRYHoXrdI=;
        b=0I5otOva0fgSx49BQflmsCPnGUJrVHjKnU72vcF+1AWbTFvdnA89IqhKncpiV/xfnQ
         kXihmTgg3WCZsfWwO5v58CAIYLmsztDmHAB9VuuU5UZ1N/GI4z8d5g8yBBlx/H06sU1O
         mds4GLBdXcRcIAj9Xz2y17Cac6crwXXtnYnPSiyiPirItTIekL1NzdEyRNaGNvlp9wdM
         9HTucRP+V3VAwSYTQXBH2OFi5yFC+sdVnJot6QznxJwl8WuaHmYJ63ocCqwGoBYPipZV
         ScPP/N+GOMPv6nKkY0F63fvaAa4ZCFQBlzX9h3oRsroty0GY8ZujqnmSSnrSFY52OOsj
         CPLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:organization:content-transfer-encoding;
        bh=9aG6JPCK/sc9cnjNg+7v1niwfwPA6zUyJ/dRYHoXrdI=;
        b=E6c5N0274U/s9oVG/HDHWPbidypAhNpdnPfRfH51Lgr6S0HVx5bZdEB0qoADG7jfu9
         XFVlzxJJqmmjeNYcdHtHezEhug+h0d0QUG/O7yIstthMk2Ijs1yNNjYQ3ak3YjEFyBXv
         QUlrOvkE9Mu3BHZAQptr6WqBiXetUEQQ49oUo0p3IgAvRX/gQi6IzettJyJiqV98GKdc
         jlyulQbQf8Wl0Ir5MdnRyR7gtwd30b9CKlbGMxmZ+f5l7xcJ8Kw81zyhpQbqY1ln9MkH
         +Gy+8jGtrkrQs78W/CmYaTZLF2Az2sJ6PV3al/VjSMaYpoP2X16GuvKwCI6xmy8VOeRz
         +Hdw==
X-Gm-Message-State: AOAM530VWPTjrTgrUlMUDznfO2AkQK7U7BF98IJfme2qAOjHxVREzTHs
        z+vj+d6I4Y0UIr0Ok78yBjg8PA==
X-Google-Smtp-Source: ABdhPJyhAB1AYSWqcXzWFsWoNHm93zY/FGMkEPWDNDQVt+VUG1TbyTV2cwcpxKhQrjxhb2HcJ7VIVQ==
X-Received: by 2002:a2e:9997:0:b0:247:ec9c:8efb with SMTP id w23-20020a2e9997000000b00247ec9c8efbmr13474171lji.297.1647251594668;
        Mon, 14 Mar 2022 02:53:14 -0700 (PDT)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id b3-20020a056512304300b004488e49f2fasm984870lfb.129.2022.03.14.02.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 02:53:14 -0700 (PDT)
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
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Cooper Lees <me@cooperlees.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: [PATCH v3 net-next 13/14] net: dsa: mv88e6xxx: Export STU as devlink region
Date:   Mon, 14 Mar 2022 10:52:30 +0100
Message-Id: <20220314095231.3486931-14-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220314095231.3486931-1-tobias@waldekranz.com>
References: <20220314095231.3486931-1-tobias@waldekranz.com>
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

