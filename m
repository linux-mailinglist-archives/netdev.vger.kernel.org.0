Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66270197DC6
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 16:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgC3OBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 10:01:41 -0400
Received: from mx1.tq-group.com ([62.157.118.193]:24401 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgC3OBk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 10:01:40 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Mar 2020 10:01:37 EDT
IronPort-SDR: Y5EghjizNobDW5xbSwhBzX+5CWOcME1/s2KpTsQsDoGFcPB5YT/0ZqnwZqQTErkCztD8JYB5xy
 fRizms3uxT+wsADNAj+g9iw0zL8+raRRrot6e7xq00M29VI39Vm4LV2BQNOeQCBLYwBqXf/Cth
 E74Au7rwLZx24CyT1Pr1CJGu+5DpDcOyLhhPe/OcHYCkksj3tZRo4QZ7sgdVTOPxEaXBJmG8aX
 03+Ml90lX81k9kuGiKKxK67vWSEdolIVoG/p5j/ZVCV8OHt3QtdzxHzXl41lU1GpKRofb4QAI6
 YCA=
X-IronPort-AV: E=Sophos;i="5.72,324,1580770800"; 
   d="scan'208";a="11606922"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 30 Mar 2020 15:54:28 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Mon, 30 Mar 2020 15:54:28 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Mon, 30 Mar 2020 15:54:28 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1585576468; x=1617112468;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=90m37/5zJs3kt2iYIY/hmc7I7JDo4kDC1Cx3Gz+g2qY=;
  b=G1UesuzYvaukYDLSe5vcnWHkPKQtMgjzXjA4wcAki5bVWSdVInn8b4fV
   VTJp/0+l3483sekMQh8WaJZFCmFmFRs+jOBSNQ9sRy/CNUB+uCH+tSV2B
   OfJsy+jGBiL088u0UmREHEHvbrrId+xp5yd0ksqtv/r3gVCLYtJWz/UDp
   yG1KaG7n3XCgDx/vxqDouIUUMpU6Si+GmvG1Lmdcm4zeUdB14hhUrl/9T
   hZhZKs5w0letlh/czyM96I87tLub4wTcCRR8+BxzHiC+ucVui5uPNAEqI
   WrYjlgPsbmopzT+RmhSfD9QPk81ngtdO/xN6aknVzTh/sj/fYvoujIsnX
   A==;
IronPort-SDR: jucPNaituKfnfV9Mm6EffvDpCbzsHg/c+1FXcvBGAbz9dcCWxKT9KJOs1k1H3FOaonrAQ6jB0P
 Rv0KbZw9B+NWsA1LxHrw9Tbse7ke9w3jINJ6p1ZXMhewChBEEFHGdLeA9embpCuq7VzZYBKKDn
 Jsut9Dcjmtk9kCbkO8xWgdLj3HlhJSHxoHaBLAptnW/GfBczm4Hs7jaeKBD31+8htRjU1pQNsB
 2NiYx2rLSCqpgKx4AdI/2H5D/Au34F1M0nmjOsdj8DITPmM9HapnY0DZD93h+nRXUDq2WF0OK9
 92I=
X-IronPort-AV: E=Sophos;i="5.72,324,1580770800"; 
   d="scan'208";a="11606921"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 30 Mar 2020 15:54:28 +0200
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.117.49.26])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 44169280070;
        Mon, 30 Mar 2020 15:54:33 +0200 (CEST)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [PATCH net-next 4/4] net: dsa: mv88e6xxx: add support for MV88E6020 switch
Date:   Mon, 30 Mar 2020 15:53:45 +0200
Message-Id: <20200330135345.4361-4-matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330135345.4361-1-matthias.schiffer@ew.tq-group.com>
References: <20200330135345.4361-1-matthias.schiffer@ew.tq-group.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A 6250 family switch with 5 internal PHYs and no PTP support.

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 21 +++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  1 +
 drivers/net/dsa/mv88e6xxx/port.h |  1 +
 3 files changed, 23 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 228c1b085b66..a72b81c9d417 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4647,6 +4647,27 @@ static const struct mv88e6xxx_ops mv88e6390x_ops = {
 };
 
 static const struct mv88e6xxx_info mv88e6xxx_table[] = {
+	[MV88E6020] = {
+		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6020,
+		.family = MV88E6XXX_FAMILY_6250,
+		.name = "Marvell 88E6020",
+		.num_databases = 64,
+		.num_ports = 7,
+		.num_internal_phys = 5,
+		.max_vid = 4095,
+		.port_base_addr = 0x8,
+		.phy_base_addr = 0x0,
+		.global1_addr = 0xf,
+		.global2_addr = 0x7,
+		.age_time_coeff = 15000,
+		.g1_irqs = 9,
+		.g2_irqs = 5,
+		.atu_move_port_mask = 0xf,
+		.dual_chip = true,
+		.tag_protocol = DSA_TAG_PROTO_DSA,
+		.ops = &mv88e6250_ops,
+	},
+
 	[MV88E6085] = {
 		.prod_num = MV88E6XXX_PORT_SWITCH_ID_PROD_6085,
 		.family = MV88E6XXX_FAMILY_6097,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 88c148a62366..f75d48427c26 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -47,6 +47,7 @@ enum mv88e6xxx_frame_mode {
 
 /* List of supported models */
 enum mv88e6xxx_model {
+	MV88E6020,
 	MV88E6085,
 	MV88E6095,
 	MV88E6097,
diff --git a/drivers/net/dsa/mv88e6xxx/port.h b/drivers/net/dsa/mv88e6xxx/port.h
index 44d76ac973f6..190d7d5568e9 100644
--- a/drivers/net/dsa/mv88e6xxx/port.h
+++ b/drivers/net/dsa/mv88e6xxx/port.h
@@ -101,6 +101,7 @@
 /* Offset 0x03: Switch Identifier Register */
 #define MV88E6XXX_PORT_SWITCH_ID		0x03
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_MASK	0xfff0
+#define MV88E6XXX_PORT_SWITCH_ID_PROD_6020	0x0200
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6085	0x04a0
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6095	0x0950
 #define MV88E6XXX_PORT_SWITCH_ID_PROD_6097	0x0990
-- 
2.17.1

