Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 725C2EF1B1
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 01:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387427AbfKEANV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 19:13:21 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48880 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387394AbfKEANV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 19:13:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nZRIe4QHmg21f6olGOk5OfBb/+J7exk9eWK65ZpnJCE=; b=JM923OFUd1BUTIMaoh3reyFeJu
        GrYJQ5akgIRM9DT93Wwo5ElvNVFiw/uM6QFtsCCSoq/fgAHF5mWeh3CZkd+yX+cYZ+mUvhUBePmju
        i6EFwUo6k5YIfAijr6USvXGqlcYK01Bs4S/ucPCBX6u5p4pS0kF2M0GeOFcDVldQXOBE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iRmTD-0007Hv-2d; Tue, 05 Nov 2019 01:13:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>, jiri@mellanox.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 2/5] net: dsa: mv88e6xxx: Add number of MACs in the ATU
Date:   Tue,  5 Nov 2019 01:12:58 +0100
Message-Id: <20191105001301.27966-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191105001301.27966-1-andrew@lunn.ch>
References: <20191105001301.27966-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For each supported switch, add an entry to the info structure for the
number of MACs which can be stored in the ATU. This will later be used
to export the ATU as a devlink resource, and indicate its occupancy,
how full the ATU is.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 25 +++++++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/chip.h |  6 ++++++
 2 files changed, 31 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 66de492117ad..3540ca2e3b6f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -4299,6 +4299,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6097,
 		.name = "Marvell 88E6085",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 10,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
@@ -4321,6 +4322,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6095,
 		.name = "Marvell 88E6095/88E6095F",
 		.num_databases = 256,
+		.num_macs = 8192,
 		.num_ports = 11,
 		.num_internal_phys = 0,
 		.max_vid = 4095,
@@ -4341,6 +4343,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6097,
 		.name = "Marvell 88E6097/88E6097F",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 11,
 		.num_internal_phys = 8,
 		.max_vid = 4095,
@@ -4363,6 +4366,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6165,
 		.name = "Marvell 88E6123",
 		.num_databases = 4096,
+		.num_macs = 1024,
 		.num_ports = 3,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
@@ -4385,6 +4389,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6185,
 		.name = "Marvell 88E6131",
 		.num_databases = 256,
+		.num_macs = 8192,
 		.num_ports = 8,
 		.num_internal_phys = 0,
 		.max_vid = 4095,
@@ -4405,6 +4410,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6341,
 		.name = "Marvell 88E6141",
 		.num_databases = 4096,
+		.num_macs = 2048,
 		.num_ports = 6,
 		.num_internal_phys = 5,
 		.num_gpio = 11,
@@ -4428,6 +4434,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6165,
 		.name = "Marvell 88E6161",
 		.num_databases = 4096,
+		.num_macs = 1024,
 		.num_ports = 6,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
@@ -4451,6 +4458,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6165,
 		.name = "Marvell 88E6165",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 6,
 		.num_internal_phys = 0,
 		.max_vid = 4095,
@@ -4474,6 +4482,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6351,
 		.name = "Marvell 88E6171",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
@@ -4496,6 +4505,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6352,
 		.name = "Marvell 88E6172",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.num_gpio = 15,
@@ -4519,6 +4529,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6351,
 		.name = "Marvell 88E6175",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
@@ -4541,6 +4552,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6352,
 		.name = "Marvell 88E6176",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.num_gpio = 15,
@@ -4564,6 +4576,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6185,
 		.name = "Marvell 88E6185",
 		.num_databases = 256,
+		.num_macs = 8192,
 		.num_ports = 10,
 		.num_internal_phys = 0,
 		.max_vid = 4095,
@@ -4584,6 +4597,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6390,
 		.name = "Marvell 88E6190",
 		.num_databases = 4096,
+		.num_macs = 16384,
 		.num_ports = 11,	/* 10 + Z80 */
 		.num_internal_phys = 9,
 		.num_gpio = 16,
@@ -4607,6 +4621,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6390,
 		.name = "Marvell 88E6190X",
 		.num_databases = 4096,
+		.num_macs = 16384,
 		.num_ports = 11,	/* 10 + Z80 */
 		.num_internal_phys = 9,
 		.num_gpio = 16,
@@ -4630,6 +4645,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6390,
 		.name = "Marvell 88E6191",
 		.num_databases = 4096,
+		.num_macs = 16384,
 		.num_ports = 11,	/* 10 + Z80 */
 		.num_internal_phys = 9,
 		.max_vid = 8191,
@@ -4680,6 +4696,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6352,
 		.name = "Marvell 88E6240",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.num_gpio = 15,
@@ -4750,6 +4767,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6320,
 		.name = "Marvell 88E6320",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.num_gpio = 15,
@@ -4774,6 +4792,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6320,
 		.name = "Marvell 88E6321",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.num_gpio = 15,
@@ -4797,6 +4816,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6341,
 		.name = "Marvell 88E6341",
 		.num_databases = 4096,
+		.num_macs = 2048,
 		.num_internal_phys = 5,
 		.num_ports = 6,
 		.num_gpio = 11,
@@ -4821,6 +4841,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6351,
 		.name = "Marvell 88E6350",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
@@ -4843,6 +4864,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6351,
 		.name = "Marvell 88E6351",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.max_vid = 4095,
@@ -4865,6 +4887,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6352,
 		.name = "Marvell 88E6352",
 		.num_databases = 4096,
+		.num_macs = 8192,
 		.num_ports = 7,
 		.num_internal_phys = 5,
 		.num_gpio = 15,
@@ -4888,6 +4911,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6390,
 		.name = "Marvell 88E6390",
 		.num_databases = 4096,
+		.num_macs = 16384,
 		.num_ports = 11,	/* 10 + Z80 */
 		.num_internal_phys = 9,
 		.num_gpio = 16,
@@ -4911,6 +4935,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.family = MV88E6XXX_FAMILY_6390,
 		.name = "Marvell 88E6390X",
 		.num_databases = 4096,
+		.num_macs = 16384,
 		.num_ports = 11,	/* 10 + Z80 */
 		.num_internal_phys = 9,
 		.num_gpio = 16,
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 52f7726cc099..65ce09bdcbcf 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -94,6 +94,7 @@ struct mv88e6xxx_info {
 	u16 prod_num;
 	const char *name;
 	unsigned int num_databases;
+	unsigned int num_macs;
 	unsigned int num_ports;
 	unsigned int num_internal_phys;
 	unsigned int num_gpio;
@@ -613,6 +614,11 @@ static inline unsigned int mv88e6xxx_num_databases(struct mv88e6xxx_chip *chip)
 	return chip->info->num_databases;
 }
 
+static inline unsigned int mv88e6xxx_num_macs(struct  mv88e6xxx_chip *chip)
+{
+	return chip->info->num_macs;
+}
+
 static inline unsigned int mv88e6xxx_num_ports(struct mv88e6xxx_chip *chip)
 {
 	return chip->info->num_ports;
-- 
2.23.0

