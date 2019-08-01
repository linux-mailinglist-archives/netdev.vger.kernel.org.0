Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8AFC7E24E
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732669AbfHAShF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:37:05 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34456 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732411AbfHAShD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 14:37:03 -0400
Received: by mail-qt1-f194.google.com with SMTP id k10so2142996qtq.1;
        Thu, 01 Aug 2019 11:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hIE7BCR1Y9QjYs/Q1fIXG7Lo3ffro8qX6bIfZ3EqFU8=;
        b=Y3g1D4CZIbthEffAmDXBsd9bPiltxmI8cemEHY+3iZcMqRpseH6xldbcpi+nNtjfLc
         tZnYeEA0FHCeGN/KQBDE060K+DiwXWK2q2svpNZ4GHWcAFglmugZ5hgaDUZeDKIe4URs
         tu1edxMfWZZZewAx79sQl+SOezflexZghqAm+xp3e9wmwMKIAEHDrh2+VCIRwZS5Cc/y
         kScJUURdfwxJ/HoClps9MJaeCetqmaUs6Am1thnCpPxUJ3W/8TrfySVVYuwz8HD8k2SI
         tZ5qnREyHi/H4Z6fxhi1YkksO69VYLKVsw0cFLariTjtivI45o7EbJHsqYF+N13M4bgu
         akMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hIE7BCR1Y9QjYs/Q1fIXG7Lo3ffro8qX6bIfZ3EqFU8=;
        b=TFz2MJOQImU4jHJK8n+nKplSMM3H4LIKU4P0PLlBVLhm0S/RBkxgh8NMQ05xO0BaWQ
         uMTZ0Ixz0rRRmuEyLslUhxPX67bzUOdpf1I1nWQ9fLqVMZ672uT+rH4Gg5FAMXEPXdQK
         ZaymtaGuI3ZTaEristNdCuFROkkBzfgquar+e9HaH2AEqPBpDuACJi2ZaXx9aqhvkBGj
         EQa7w2Rs19gNHcShZCzaFZt6u1auEoFqX+AJLkfJDM6vHtIWhQlanSpc8CjU7MAFhA4E
         BSr7l+VxMcj/N5MTDsjraa9izFn3roon6OWoZWAVTeVBN/z2/MTlmgRIVM5hVfHfR+Gl
         OTiQ==
X-Gm-Message-State: APjAAAVuc91PKcEeXtmEB82FrgyD7xgqA1O01cSXc2ZpcbCQw5je92Ye
        5dHVQNTXFZ07AKVClZCmtR2JuIewazU=
X-Google-Smtp-Source: APXvYqxYjfYOX8r2Dx345ceWJgNvZWM9+hi2K+cs0Xiia4hez8GAWKcjCx5PDGeg1odH4Wa2S4B8mw==
X-Received: by 2002:a0c:9163:: with SMTP id q90mr95994952qvq.37.1564684622148;
        Thu, 01 Aug 2019 11:37:02 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id q56sm36693368qtq.64.2019.08.01.11.37.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 11:37:01 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        f.fainelli@gmail.com, andrew@lunn.ch, netdev@vger.kernel.org,
        davem@davemloft.net
Subject: [PATCH net-next 2/5] net: dsa: mv88e6xxx: explicit entry passed to vtu_getnext
Date:   Thu,  1 Aug 2019 14:36:34 -0400
Message-Id: <20190801183637.24841-3-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190801183637.24841-1-vivien.didelot@gmail.com>
References: <20190801183637.24841-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mv88e6xxx_vtu_getnext interprets two members from the input
mv88e6xxx_vtu_entry structure: the (excluded) vid member to start
the iteration from, and the valid argument specifying whether the VID
must be written or not (only required once at the start of a loop).

Explicit the assignation of these two fields right before calling
mv88e6xxx_vtu_getnext, as it is done in the mv88e6xxx_vtu_get wrapper.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 1b2cb46d3b53..c825fa3477fa 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1361,9 +1361,7 @@ static int mv88e6xxx_vtu_loadpurge(struct mv88e6xxx_chip *chip,
 static int mv88e6xxx_atu_new(struct mv88e6xxx_chip *chip, u16 *fid)
 {
 	DECLARE_BITMAP(fid_bitmap, MV88E6XXX_N_FID);
-	struct mv88e6xxx_vtu_entry vlan = {
-		.vid = chip->info->max_vid,
-	};
+	struct mv88e6xxx_vtu_entry vlan;
 	int i, err;
 
 	bitmap_zero(fid_bitmap, MV88E6XXX_N_FID);
@@ -1378,6 +1376,9 @@ static int mv88e6xxx_atu_new(struct mv88e6xxx_chip *chip, u16 *fid)
 	}
 
 	/* Set every FID bit used by the VLAN entries */
+	vlan.vid = chip->info->max_vid;
+	vlan.valid = false;
+
 	do {
 		err = mv88e6xxx_vtu_getnext(chip, &vlan);
 		if (err)
@@ -1441,9 +1442,7 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 					u16 vid_begin, u16 vid_end)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
-	struct mv88e6xxx_vtu_entry vlan = {
-		.vid = vid_begin - 1,
-	};
+	struct mv88e6xxx_vtu_entry vlan;
 	int i, err;
 
 	/* DSA and CPU ports have to be members of multiple vlans */
@@ -1453,6 +1452,9 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
 	if (!vid_begin)
 		return -EOPNOTSUPP;
 
+	vlan.vid = vid_begin - 1;
+	vlan.valid = false;
+
 	do {
 		err = mv88e6xxx_vtu_getnext(chip, &vlan);
 		if (err)
@@ -1789,9 +1791,7 @@ static int mv88e6xxx_port_db_dump_fid(struct mv88e6xxx_chip *chip,
 static int mv88e6xxx_port_db_dump(struct mv88e6xxx_chip *chip, int port,
 				  dsa_fdb_dump_cb_t *cb, void *data)
 {
-	struct mv88e6xxx_vtu_entry vlan = {
-		.vid = chip->info->max_vid,
-	};
+	struct mv88e6xxx_vtu_entry vlan;
 	u16 fid;
 	int err;
 
@@ -1805,6 +1805,9 @@ static int mv88e6xxx_port_db_dump(struct mv88e6xxx_chip *chip, int port,
 		return err;
 
 	/* Dump VLANs' Filtering Information Databases */
+	vlan.vid = chip->info->max_vid;
+	vlan.valid = false;
+
 	do {
 		err = mv88e6xxx_vtu_getnext(chip, &vlan);
 		if (err)
-- 
2.22.0

