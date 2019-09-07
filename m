Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABD3AAC920
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 22:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436707AbfIGUBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 16:01:20 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42638 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391561AbfIGUBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Sep 2019 16:01:19 -0400
Received: by mail-qk1-f194.google.com with SMTP id f13so9022847qkm.9
        for <netdev@vger.kernel.org>; Sat, 07 Sep 2019 13:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/PPjxGRpiOIQugawypKqsKgIYNrPOYxRDyrQvDn5bro=;
        b=O9BDBaNYp6kdoekjEIb+PPBp9Bdwk2Afcm+ZdQu06L5eOl81gsrD4hczvwCIi54jt6
         ie6Shrg/L4kxkVjAx09nCH05i8poQcNzj9t4c6usEB9ehw8xNymrHnaVRreuRli4SlIk
         /bRqj2RukWrPJzZXY46ooibsmNvy6SQ4LoUgVYJaRF+n5KUhCqlwSnSAzDD5t4ZTwQex
         NYocmYt3J5D2vzBd/6vtLbg1sf2qRCYeYBSEp/di+l/v2mCUYtS0VCuM5u1nXigCSZwq
         lppx0V8PfXBQmGWycFdcKjjZQRZUfdvr0rPEuYN3rwDIjuG5BHjNwLu7E16IrI/pOGZN
         /KAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/PPjxGRpiOIQugawypKqsKgIYNrPOYxRDyrQvDn5bro=;
        b=Uc2UPyZVWeeVRm+zDetMF2yQhM1YqWsfv00iaHKFU+Ako27T+kfLzlOE4vTVDF8dsO
         Hq9w4rY4FPBQHGcyQhJk6ZY6eViFxs7Vfw6TJuX01v09T3C2jKhGnhlAq7fUxT0YlXs+
         PIsDFdVZeRMMTYQGXfi928i5qh5acT1z97TaOcr2UyXrIHx44BNHvxQIezS1YPcgzdWh
         xHbNKW9FKYzsSXYVxp86TI3Z4z7JYWzwOHUo8uWNR29KOSzy/QBWquq4yO3sI9O7iECG
         NvoyFQjSGFUQSMPkvxqp0hcYcM1DmubbgKMWI6SUfmRbSMtjn6YILiqs6JZsXzHexzU2
         bFbg==
X-Gm-Message-State: APjAAAXLsjbF27zBWTvFO2zK0dQcQG5lbJtnBh1enJkG8qflxONAYmop
        IJLhu1PF5G2DPKigDVIo2UX8zjw+
X-Google-Smtp-Source: APXvYqzDQGrIQIuBPdF/YCkxqla0PKFmLAtJMaG7P7IKGHjzwzvBo9y0Tnp/PKdTnvanReorzt9kFg==
X-Received: by 2002:a37:de10:: with SMTP id h16mr15622430qkj.338.1567886477776;
        Sat, 07 Sep 2019 13:01:17 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id 1sm4431772qko.73.2019.09.07.13.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Sep 2019 13:01:17 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 1/3] net: dsa: mv88e6xxx: complete ATU state definitions
Date:   Sat,  7 Sep 2019 16:00:47 -0400
Message-Id: <20190907200049.25273-2-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190907200049.25273-1-vivien.didelot@gmail.com>
References: <20190907200049.25273-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marvell has different values for the state of a MAC address,
depending on its multicast bit. This patch completes the definitions
for these states.

At the same time, use 0 which is intuitive enough and simplifies the
code a bit, instead of the UC or MC unused value.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c        | 19 +++++------
 drivers/net/dsa/mv88e6xxx/global1.h     | 43 +++++++++++++++++--------
 drivers/net/dsa/mv88e6xxx/global1_atu.c |  6 ++--
 3 files changed, 41 insertions(+), 27 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 30365a54c31b..0d54a69f3622 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1497,7 +1497,7 @@ static int mv88e6xxx_port_db_load_purge(struct mv88e6xxx_chip *chip, int port,
 		fid = vlan.fid;
 	}
 
-	entry.state = MV88E6XXX_G1_ATU_DATA_STATE_UNUSED;
+	entry.state = 0;
 	ether_addr_copy(entry.mac, addr);
 	eth_addr_dec(entry.mac);
 
@@ -1506,17 +1506,16 @@ static int mv88e6xxx_port_db_load_purge(struct mv88e6xxx_chip *chip, int port,
 		return err;
 
 	/* Initialize a fresh ATU entry if it isn't found */
-	if (entry.state == MV88E6XXX_G1_ATU_DATA_STATE_UNUSED ||
-	    !ether_addr_equal(entry.mac, addr)) {
+	if (!entry.state || !ether_addr_equal(entry.mac, addr)) {
 		memset(&entry, 0, sizeof(entry));
 		ether_addr_copy(entry.mac, addr);
 	}
 
 	/* Purge the ATU entry only if no port is using it anymore */
-	if (state == MV88E6XXX_G1_ATU_DATA_STATE_UNUSED) {
+	if (!state) {
 		entry.portvec &= ~BIT(port);
 		if (!entry.portvec)
-			entry.state = MV88E6XXX_G1_ATU_DATA_STATE_UNUSED;
+			entry.state = 0;
 	} else {
 		entry.portvec |= BIT(port);
 		entry.state = state;
@@ -1732,8 +1731,7 @@ static int mv88e6xxx_port_fdb_del(struct dsa_switch *ds, int port,
 	int err;
 
 	mv88e6xxx_reg_lock(chip);
-	err = mv88e6xxx_port_db_load_purge(chip, port, addr, vid,
-					   MV88E6XXX_G1_ATU_DATA_STATE_UNUSED);
+	err = mv88e6xxx_port_db_load_purge(chip, port, addr, vid, 0);
 	mv88e6xxx_reg_unlock(chip);
 
 	return err;
@@ -1747,7 +1745,7 @@ static int mv88e6xxx_port_db_dump_fid(struct mv88e6xxx_chip *chip,
 	bool is_static;
 	int err;
 
-	addr.state = MV88E6XXX_G1_ATU_DATA_STATE_UNUSED;
+	addr.state = 0;
 	eth_broadcast_addr(addr.mac);
 
 	do {
@@ -1755,7 +1753,7 @@ static int mv88e6xxx_port_db_dump_fid(struct mv88e6xxx_chip *chip,
 		if (err)
 			return err;
 
-		if (addr.state == MV88E6XXX_G1_ATU_DATA_STATE_UNUSED)
+		if (!addr.state)
 			break;
 
 		if (addr.trunk || (addr.portvec & BIT(port)) == 0)
@@ -4690,8 +4688,7 @@ static int mv88e6xxx_port_mdb_del(struct dsa_switch *ds, int port,
 	int err;
 
 	mv88e6xxx_reg_lock(chip);
-	err = mv88e6xxx_port_db_load_purge(chip, port, mdb->addr, mdb->vid,
-					   MV88E6XXX_G1_ATU_DATA_STATE_UNUSED);
+	err = mv88e6xxx_port_db_load_purge(chip, port, mdb->addr, mdb->vid, 0);
 	mv88e6xxx_reg_unlock(chip);
 
 	return err;
diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
index 78b9ae22d18c..0870fcc8bfc8 100644
--- a/drivers/net/dsa/mv88e6xxx/global1.h
+++ b/drivers/net/dsa/mv88e6xxx/global1.h
@@ -128,19 +128,36 @@
 #define MV88E6XXX_G1_ATU_OP_FULL_VIOLATION		BIT(4)
 
 /* Offset 0x0C: ATU Data Register */
-#define MV88E6XXX_G1_ATU_DATA				0x0c
-#define MV88E6XXX_G1_ATU_DATA_TRUNK			0x8000
-#define MV88E6XXX_G1_ATU_DATA_TRUNK_ID_MASK		0x00f0
-#define MV88E6XXX_G1_ATU_DATA_PORT_VECTOR_MASK		0x3ff0
-#define MV88E6XXX_G1_ATU_DATA_STATE_MASK		0x000f
-#define MV88E6XXX_G1_ATU_DATA_STATE_UNUSED		0x0000
-#define MV88E6XXX_G1_ATU_DATA_STATE_UC_MGMT		0x000d
-#define MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC		0x000e
-#define MV88E6XXX_G1_ATU_DATA_STATE_UC_PRIO_OVER	0x000f
-#define MV88E6XXX_G1_ATU_DATA_STATE_MC_NONE_RATE	0x0005
-#define MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC		0x0007
-#define MV88E6XXX_G1_ATU_DATA_STATE_MC_MGMT		0x000e
-#define MV88E6XXX_G1_ATU_DATA_STATE_MC_PRIO_OVER	0x000f
+#define MV88E6XXX_G1_ATU_DATA					0x0c
+#define MV88E6XXX_G1_ATU_DATA_TRUNK				0x8000
+#define MV88E6XXX_G1_ATU_DATA_TRUNK_ID_MASK			0x00f0
+#define MV88E6XXX_G1_ATU_DATA_PORT_VECTOR_MASK			0x3ff0
+#define MV88E6XXX_G1_ATU_DATA_STATE_MASK			0x000f
+#define MV88E6XXX_G1_ATU_DATA_STATE_UC_UNUSED			0x0000
+#define MV88E6XXX_G1_ATU_DATA_STATE_UC_AGE_1_OLDEST		0x0001
+#define MV88E6XXX_G1_ATU_DATA_STATE_UC_AGE_2			0x0002
+#define MV88E6XXX_G1_ATU_DATA_STATE_UC_AGE_3			0x0003
+#define MV88E6XXX_G1_ATU_DATA_STATE_UC_AGE_4			0x0004
+#define MV88E6XXX_G1_ATU_DATA_STATE_UC_AGE_5			0x0005
+#define MV88E6XXX_G1_ATU_DATA_STATE_UC_AGE_6			0x0006
+#define MV88E6XXX_G1_ATU_DATA_STATE_UC_AGE_7_NEWEST		0x0007
+#define MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC_POLICY		0x0008
+#define MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC_POLICY_PO		0x0009
+#define MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC_AVB_NRL		0x000a
+#define MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC_AVB_NRL_PO	0x000b
+#define MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC_DA_MGMT		0x000c
+#define MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC_DA_MGMT_PO	0x000d
+#define MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC			0x000e
+#define MV88E6XXX_G1_ATU_DATA_STATE_UC_STATIC_PO		0x000f
+#define MV88E6XXX_G1_ATU_DATA_STATE_MC_UNUSED			0x0000
+#define MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC_POLICY		0x0004
+#define MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC_AVB_NRL		0x0005
+#define MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC_DA_MGMT		0x0006
+#define MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC			0x0007
+#define MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC_POLICY_PO		0x000c
+#define MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC_AVB_NRL_PO	0x000d
+#define MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC_DA_MGMT_PO	0x000e
+#define MV88E6XXX_G1_ATU_DATA_STATE_MC_STATIC_PO		0x000f
 
 /* Offset 0x0D: ATU MAC Address Register Bytes 0 & 1
  * Offset 0x0E: ATU MAC Address Register Bytes 2 & 3
diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
index 18b86515b6bc..792a96ef418f 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -135,7 +135,7 @@ static int mv88e6xxx_g1_atu_data_read(struct mv88e6xxx_chip *chip,
 		return err;
 
 	entry->state = val & 0xf;
-	if (entry->state != MV88E6XXX_G1_ATU_DATA_STATE_UNUSED) {
+	if (entry->state) {
 		entry->trunk = !!(val & MV88E6XXX_G1_ATU_DATA_TRUNK);
 		entry->portvec = (val >> 4) & mv88e6xxx_port_mask(chip);
 	}
@@ -148,7 +148,7 @@ static int mv88e6xxx_g1_atu_data_write(struct mv88e6xxx_chip *chip,
 {
 	u16 data = entry->state & 0xf;
 
-	if (entry->state != MV88E6XXX_G1_ATU_DATA_STATE_UNUSED) {
+	if (entry->state) {
 		if (entry->trunk)
 			data |= MV88E6XXX_G1_ATU_DATA_TRUNK;
 
@@ -209,7 +209,7 @@ int mv88e6xxx_g1_atu_getnext(struct mv88e6xxx_chip *chip, u16 fid,
 		return err;
 
 	/* Write the MAC address to iterate from only once */
-	if (entry->state == MV88E6XXX_G1_ATU_DATA_STATE_UNUSED) {
+	if (!entry->state) {
 		err = mv88e6xxx_g1_atu_mac_write(chip, entry);
 		if (err)
 			return err;
-- 
2.23.0

