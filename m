Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA27F2ADEE7
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 19:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731666AbgKJS5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 13:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731359AbgKJS5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 13:57:36 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F071C0613D1
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 10:57:34 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id f11so12820500lfs.3
        for <netdev@vger.kernel.org>; Tue, 10 Nov 2020 10:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:organization;
        bh=TGF9txgy89pqpk6DBaTNB4wz29x2NYzWYa4wqaoOxQc=;
        b=BYzFazVzTNqij7tTKxCNY32Us5bbaadbo3PXgeMX8OFUTcMkF41J8VjjTY0xUYxZcp
         wHC2wfrvpBhNgNAXOB9K/TeJ7cCHvPrn/BNI/ct2EnuUAKmQQsghw0dFb+nG4MTHLLqW
         9/COd/ZdWIdANb/MMGA3k+uGcGD6RY7iyUnFN/w/sfdkBoN3sAjVFts7ProHhrgvAsaY
         KjsoF2xfDTFEbi8S3GcXTa52QFu49NUHdEzo2iHKuxWNp3MQ42LWIz2uObDB6O5vTwB+
         Yf00nmUQ6BVgMkbfpS3zDUzIdGorrEAKGNzXii/inGHiGcaQ86F1mJYHw5nRxd/TKc3M
         eZgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:organization;
        bh=TGF9txgy89pqpk6DBaTNB4wz29x2NYzWYa4wqaoOxQc=;
        b=nBzJ9UD23ZVCmR1xX6xnmnKtcfWfAn6yoMW7b5AtiKDFCXXgMAIP2KWO8mgdYYbFtT
         ZJ/qvbK/yrGe+jk2/8ddZ+RGs+mbzTD6euAJtzxBtwCjoKzrvY98OyDQ3rhHkbU/T0oB
         8kkj5aF6ceOEYWCG2xKdpZ6pzOjodzX5ayEEY9BErIa9TBr4JWDRxozX6V7EfVCMGBYL
         kYfiWGkkfRQiZU8t0+uuXa99n6cNc+legzb+C5ZZoG5GUVZGbm04or2EQh2AB25fOJU7
         8+ER2WmBk0IzMB7BaQITRZit7VZUOYSV0qAQXiFm8ZYLfmbUXx4fgNrUgvJQJqwCuHev
         dh9g==
X-Gm-Message-State: AOAM530Cg8PeE/vccN1+FPVP+NrTN4lwC474HIhUV+MAdahf8AZNha6Z
        l1yMaz8s84OMrw5BO7s117WWDg==
X-Google-Smtp-Source: ABdhPJzs+X3CtUTO6dB5fXh+o0PtnljE7arJLQExMKAzIzYVY0ANhT+SwFEPp14sqklil7BI5N6Pcw==
X-Received: by 2002:ac2:58e8:: with SMTP id v8mr7529244lfo.553.1605034652813;
        Tue, 10 Nov 2020 10:57:32 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id w6sm107595lfn.64.2020.11.10.10.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 10:57:32 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: mv88e6xxx: Add helper to get a chip's max_vid
Date:   Tue, 10 Nov 2020 19:57:20 +0100
Message-Id: <20201110185720.18228-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.17.1
Organization: Westermo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of the other chip info constants have helpers to get at them; add
one for max_vid to keep things consistent.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c    | 18 +++++++++---------
 drivers/net/dsa/mv88e6xxx/chip.h    |  5 +++++
 drivers/net/dsa/mv88e6xxx/devlink.c |  8 ++++----
 3 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 72340c17f099..ea466f8913d3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1442,7 +1442,7 @@ static void mv88e6xxx_port_fast_age(struct dsa_switch *ds, int port)
 
 static int mv88e6xxx_vtu_setup(struct mv88e6xxx_chip *chip)
 {
-	if (!chip->info->max_vid)
+	if (!mv88e6xxx_max_vid(chip))
 		return 0;
 
 	return mv88e6xxx_g1_vtu_flush(chip);
@@ -1484,7 +1484,7 @@ int mv88e6xxx_fid_map(struct mv88e6xxx_chip *chip, unsigned long *fid_bitmap)
 	}
 
 	/* Set every FID bit used by the VLAN entries */
-	vlan.vid = chip->info->max_vid;
+	vlan.vid = mv88e6xxx_max_vid(chip);
 	vlan.valid = false;
 
 	do {
@@ -1496,7 +1496,7 @@ int mv88e6xxx_fid_map(struct mv88e6xxx_chip *chip, unsigned long *fid_bitmap)
 			break;
 
 		set_bit(vlan.fid, fid_bitmap);
-	} while (vlan.vid < chip->info->max_vid);
+	} while (vlan.vid < mv88e6xxx_max_vid(chip));
 
 	return 0;
 }
@@ -1587,7 +1587,7 @@ static int mv88e6xxx_port_vlan_filtering(struct dsa_switch *ds, int port,
 	int err;
 
 	if (switchdev_trans_ph_prepare(trans))
-		return chip->info->max_vid ? 0 : -EOPNOTSUPP;
+		return mv88e6xxx_max_vid(chip) ? 0 : -EOPNOTSUPP;
 
 	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_port_set_8021q_mode(chip, port, mode);
@@ -1603,7 +1603,7 @@ mv88e6xxx_port_vlan_prepare(struct dsa_switch *ds, int port,
 	struct mv88e6xxx_chip *chip = ds->priv;
 	int err;
 
-	if (!chip->info->max_vid)
+	if (!mv88e6xxx_max_vid(chip))
 		return -EOPNOTSUPP;
 
 	/* If the requested port doesn't belong to the same bridge as the VLAN
@@ -1973,7 +1973,7 @@ static void mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
 	u8 member;
 	u16 vid;
 
-	if (!chip->info->max_vid)
+	if (!mv88e6xxx_max_vid(chip))
 		return;
 
 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
@@ -2051,7 +2051,7 @@ static int mv88e6xxx_port_vlan_del(struct dsa_switch *ds, int port,
 	u16 pvid, vid;
 	int err = 0;
 
-	if (!chip->info->max_vid)
+	if (!mv88e6xxx_max_vid(chip))
 		return -EOPNOTSUPP;
 
 	mv88e6xxx_reg_lock(chip);
@@ -2157,7 +2157,7 @@ static int mv88e6xxx_port_db_dump(struct mv88e6xxx_chip *chip, int port,
 		return err;
 
 	/* Dump VLANs' Filtering Information Databases */
-	vlan.vid = chip->info->max_vid;
+	vlan.vid = mv88e6xxx_max_vid(chip);
 	vlan.valid = false;
 
 	do {
@@ -2172,7 +2172,7 @@ static int mv88e6xxx_port_db_dump(struct mv88e6xxx_chip *chip, int port,
 						 cb, data);
 		if (err)
 			return err;
-	} while (vlan.vid < chip->info->max_vid);
+	} while (vlan.vid < mv88e6xxx_max_vid(chip));
 
 	return err;
 }
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index fb5b262285ff..7faa61b7f8f8 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -673,6 +673,11 @@ static inline unsigned int mv88e6xxx_num_ports(struct mv88e6xxx_chip *chip)
 	return chip->info->num_ports;
 }
 
+static inline unsigned int mv88e6xxx_max_vid(struct mv88e6xxx_chip *chip)
+{
+	return chip->info->max_vid;
+}
+
 static inline u16 mv88e6xxx_port_mask(struct mv88e6xxx_chip *chip)
 {
 	return GENMASK((s32)mv88e6xxx_num_ports(chip) - 1, 0);
diff --git a/drivers/net/dsa/mv88e6xxx/devlink.c b/drivers/net/dsa/mv88e6xxx/devlink.c
index 0fba160a4d36..74effe2a7d7b 100644
--- a/drivers/net/dsa/mv88e6xxx/devlink.c
+++ b/drivers/net/dsa/mv88e6xxx/devlink.c
@@ -450,14 +450,14 @@ static int mv88e6xxx_region_vtu_snapshot(struct devlink *dl,
 	struct mv88e6xxx_vtu_entry vlan;
 	int err;
 
-	table = kcalloc(chip->info->max_vid + 1,
+	table = kcalloc(mv88e6xxx_max_vid(chip) + 1,
 			sizeof(struct mv88e6xxx_devlink_vtu_entry),
 			GFP_KERNEL);
 	if (!table)
 		return -ENOMEM;
 
 	entry = table;
-	vlan.vid = chip->info->max_vid;
+	vlan.vid = mv88e6xxx_max_vid(chip);
 	vlan.valid = false;
 
 	mv88e6xxx_reg_lock(chip);
@@ -488,7 +488,7 @@ static int mv88e6xxx_region_vtu_snapshot(struct devlink *dl,
 			break;
 
 		entry++;
-	} while (vlan.vid < chip->info->max_vid);
+	} while (vlan.vid < mv88e6xxx_max_vid(chip));
 
 	mv88e6xxx_reg_unlock(chip);
 
@@ -676,7 +676,7 @@ static int mv88e6xxx_setup_devlink_regions_global(struct dsa_switch *ds,
 				sizeof(struct mv88e6xxx_devlink_atu_entry);
 			break;
 		case MV88E6XXX_REGION_VTU:
-			size = chip->info->max_vid *
+			size = mv88e6xxx_max_vid(chip) *
 				sizeof(struct mv88e6xxx_devlink_vtu_entry);
 			break;
 		}
-- 
2.17.1

