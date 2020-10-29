Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9218529E629
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 09:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbgJ2IQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 04:16:14 -0400
Received: from outbound-ip24b.ess.barracuda.com ([209.222.82.221]:46006 "EHLO
        outbound-ip24b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726949AbgJ2IQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 04:16:08 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2044.outbound.protection.outlook.com [104.47.73.44]) by mx4.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 29 Oct 2020 08:16:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TYfNT20cxRIVQQM7ODJyrJoqxxQ/NrPSCVgcsDvWVAUKJ5rf2sEdLLmGaLLxS969b/V7cMXDPYMUyyhCIFJV8XXy10OnjO6V4e/g0JndcJbgSVHW7Xq1OuAWW+t2OXO7bTykA3cMGBzEaMgBzLhkvFKZAGe+ttdksxS4dJVRpmm+Kk8B1F9krRwOSxsqIl2wsqFik66qydHIuDSQpSNyTyXqf+SsqNs8YRw1S4BQV13wkfZ/FvhvPnOXIaVBOGcL6vYBa3rEaPlXRi7EFrxjfkgVlw7fwQuG3jTUCzqAVZWtmx2aLSL8EjWX5dMBHX3OgtZxVFESwC4g0uwPktviRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G5WlOjsxbpnwhM3q+wLtht0xW/G8WLu9WhzBC/etqdw=;
 b=Xtklyp5qR/k8XueW/8UCXQW0zwQbPnzUnbqYqw4BaB9LKrbISH78Qnvccc6WX/d6VIitR0ysw4BZSggqhYGWY5RYqzuUsiu/Ab9B1Pvm40tBlUDjtFdBGSljTDS7fDUrwJzJJjk61Ou0TFVBTD72jurg42jJGygWPPHd9i9GT8zNgEfos6TF8U//0/ZVNj8DfVlrTshKePV2WGl0xcZd/FR0ov4qA3tBFMXUsWby9LUxS9iYQldk9n4PBzYMVsSOYgU0zXyON5Za9T4mt0TcjRyeRVTHZj8zzqwfP2+eQG1ZmLOaqfkixpEni7X+xa3IfgM3l2uuelsphu4KFtxIHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G5WlOjsxbpnwhM3q+wLtht0xW/G8WLu9WhzBC/etqdw=;
 b=d5Nbgtq3hXZx3UMOzxczTPShxY5m74cq/Hs/N2vL+ElY4waywDICz0r/EzwBeBwHBJVcZPJaPrTM2JkcSkhVKUN0xD3g7Fh2u4moPYI21pwr63jgXFOE3CwSc3ZMnhyKx2tl5wdd8SC6GSHxGQtHDc9g+y9y8WOiGCRAZNMp3aw=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by MN2PR10MB4189.namprd10.prod.outlook.com (2603:10b6:208:1de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 29 Oct
 2020 05:43:22 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%8]) with mapi id 15.20.3477.028; Thu, 29 Oct 2020
 05:43:22 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     andrew@lunn.ch
Cc:     davem@davemloft.net, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pavana.sharma@digi.com, vivien.didelot@gmail.com,
        marek.behun@nic.cz, ashkan.boldaji@digi.com
Subject: [PATCH v6 4/4] net: dsa: mv88e6xxx: Change serdes lane parameter  from u8 to int
Date:   Thu, 29 Oct 2020 15:43:01 +1000
Message-Id: <668b21d1e9f9d91ae3c560eb49986f0625dfb616.1603944740.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1603944740.git.pavana.sharma@digi.com>
References: <cover.1603944740.git.pavana.sharma@digi.com>
Content-Type: text/plain
X-Originating-IP: [58.84.104.89]
X-ClientProxiedBy: SY2PR01CA0043.ausprd01.prod.outlook.com
 (2603:10c6:1:15::31) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (58.84.104.89) by SY2PR01CA0043.ausprd01.prod.outlook.com (2603:10c6:1:15::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Thu, 29 Oct 2020 05:43:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b52670e3-fe55-4205-7fac-08d87bcd8bf5
X-MS-TrafficTypeDiagnostic: MN2PR10MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB4189613C62140BBE7F6E3FA395140@MN2PR10MB4189.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r+/yeFgVGiwsxDdahDIXpEd89Hb2t3m0fxdl6wMxQPrJKeQrGYK8g9qngNrqqKKl3lSRT1sHEthfDU9/150I0E5yWCt7t8HwRZ/J4v+j+HVsxbEMxHYq3D/WcBt2LoR5/qih8EUpTMFppoVA4fS3QgmEsQax/+ZQ1H3Nixub2VTKfRPR1jOBBzC0Fij0+se9uDpetN/Uz95Q3u66fiJcoV2ynwS5KhE2cm4pO/nVDtLl3Xd8P0UK+JGS0Pv5kGYETMRVgX3uA5S8GTHTc2N0Zkm0SU4l10zFF3B3QccGUjbPTp3erEjHHag8ktjPn1CTa5KPVG36KTOMBKinMierrfKdkXq8y1Fm1zKg5RF9niEOWzXpCY58KVUa17m6EbAC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(136003)(376002)(366004)(396003)(2616005)(956004)(69590400008)(8936002)(66476007)(6666004)(16526019)(66946007)(316002)(186003)(2906002)(44832011)(30864003)(8676002)(6916009)(107886003)(6486002)(36756003)(26005)(66556008)(5660300002)(86362001)(6506007)(4326008)(6512007)(52116002)(83380400001)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 3oCYyLNaW143VAihtgXSmgqQMDqcswQFtUmOkX9edvrp4NIIwe08YuMWq/A/2JWJRuIYKLTHbJcDBkJhkfG9iB/vWVFkUejNCatYmuLIqsA+Fqb9RSAg2z8htC+FT+suX8NGzP8h+SpjMc3DIU1EJakcsvwySWfLo4q0k7qf1EghvYPQ1t0Gp6TvLkcqHnIKC2O/KL10RCJ122MAudSyFmFZ84QNsnIIzrTVa8NzunglaIWr04QHOdW6pkNvYZYusBY3qR8CCRfb3l9aigZ/l4o1p6P18deH7Bw6PH6gm9K0taXYyBMlVsb+NQf/uBcx0alOGM6rMAYkXVp5jG+HykCaK8AffdruCe64XIZdIqRkOtRIVkSZZM6VMJpADgmQqUeCr4O/s3HPWpIQI79tZDO7OeHnSAo3esNDt5JflCfElxmCiCDPuFSAZvivjnVVrdMt0qmiSc2eScyRIX45sFQ0nf47+9InxzD+NYDVAdg7MeoDgmjeI4Dx2WgDjYskx/Nyu0R1eM+TG9H0TfsIrL6TA9vyNl5/v93fFk1cEMT0GCmPhwEbxxcVapc6qR6SQ8i+S+WkhmZDmkA2KQsUOxVDiROQLsotRNsGHP3bSmv9apAyJ5FZXxgloC2sbmBRgSjsS1hpzxPI26+6hx00mA==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b52670e3-fe55-4205-7fac-08d87bcd8bf5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2020 05:43:22.5204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F87xBj09NWCjeJwkA37g3vYz8M2rJ014AEAx00O6tmWwSKfkvIXyZZdmIUV47/oNCiIWIo/EqGSDfJOUH7vF9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4189
X-BESS-ID: 1603959362-893007-17954-248255-1
X-BESS-VER: 2019.1_20201026.1928
X-BESS-Apparent-Source-IP: 104.47.73.44
X-BESS-Outbound-Spam-Score: 0.50
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.227845 [from 
        cloudscan20-221.us-east-2b.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 MSGID_FROM_MTA_HEADER  META: Message-Id was added by a relay 
        0.50 BSF_RULE7568M          META: Custom Rule 7568M 
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.50 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=MSGID_FROM_MTA_HEADER, BSF_RULE7568M, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Returning 0 is no more an error case with MV88E6393 family
which has serdes lane numbers 0, 9 or 10.
So with this change .serdes_get_lane will return lane number
or error (-ENODEV).

Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c   | 28 +++++-----
 drivers/net/dsa/mv88e6xxx/chip.h   | 16 +++---
 drivers/net/dsa/mv88e6xxx/port.c   |  6 +--
 drivers/net/dsa/mv88e6xxx/serdes.c | 86 +++++++++++++++---------------
 drivers/net/dsa/mv88e6xxx/serdes.h | 58 ++++++++++----------
 5 files changed, 96 insertions(+), 98 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index de96fd08e77a..6e76c1c37700 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -484,12 +484,12 @@ static int mv88e6xxx_serdes_pcs_get_state(struct dsa_switch *ds, int port,
 					  struct phylink_link_state *state)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
-	u8 lane;
+	int lane;
 	int err;
 
 	mv88e6xxx_reg_lock(chip);
 	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (lane && chip->info->ops->serdes_pcs_get_state)
+	if ((lane != -ENODEV) && chip->info->ops->serdes_pcs_get_state)
 		err = chip->info->ops->serdes_pcs_get_state(chip, port, lane,
 							    state);
 	else
@@ -505,11 +505,11 @@ static int mv88e6xxx_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 				       const unsigned long *advertise)
 {
 	const struct mv88e6xxx_ops *ops = chip->info->ops;
-	u8 lane;
+	int lane;
 
 	if (ops->serdes_pcs_config) {
 		lane = mv88e6xxx_serdes_get_lane(chip, port);
-		if (lane)
+		if (lane != -ENODEV)
 			return ops->serdes_pcs_config(chip, port, lane, mode,
 						      interface, advertise);
 	}
@@ -522,14 +522,14 @@ static void mv88e6xxx_serdes_pcs_an_restart(struct dsa_switch *ds, int port)
 	struct mv88e6xxx_chip *chip = ds->priv;
 	const struct mv88e6xxx_ops *ops;
 	int err = 0;
-	u8 lane;
+	int lane;
 
 	ops = chip->info->ops;
 
 	if (ops->serdes_pcs_an_restart) {
 		mv88e6xxx_reg_lock(chip);
 		lane = mv88e6xxx_serdes_get_lane(chip, port);
-		if (lane)
+		if (lane != -ENODEV)
 			err = ops->serdes_pcs_an_restart(chip, port, lane);
 		mv88e6xxx_reg_unlock(chip);
 
@@ -543,11 +543,11 @@ static int mv88e6xxx_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
 					int speed, int duplex)
 {
 	const struct mv88e6xxx_ops *ops = chip->info->ops;
-	u8 lane;
+	int lane;
 
 	if (!phylink_autoneg_inband(mode) && ops->serdes_pcs_link_up) {
 		lane = mv88e6xxx_serdes_get_lane(chip, port);
-		if (lane)
+		if (lane != -ENODEV)
 			return ops->serdes_pcs_link_up(chip, port, lane,
 						       speed, duplex);
 	}
@@ -2442,11 +2442,11 @@ static irqreturn_t mv88e6xxx_serdes_irq_thread_fn(int irq, void *dev_id)
 	struct mv88e6xxx_chip *chip = mvp->chip;
 	irqreturn_t ret = IRQ_NONE;
 	int port = mvp->port;
-	u8 lane;
+	int lane;
 
 	mv88e6xxx_reg_lock(chip);
 	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (lane)
+	if (lane != -ENODEV)
 		ret = mv88e6xxx_serdes_irq_status(chip, port, lane);
 	mv88e6xxx_reg_unlock(chip);
 
@@ -2454,7 +2454,7 @@ static irqreturn_t mv88e6xxx_serdes_irq_thread_fn(int irq, void *dev_id)
 }
 
 static int mv88e6xxx_serdes_irq_request(struct mv88e6xxx_chip *chip, int port,
-					u8 lane)
+					int lane)
 {
 	struct mv88e6xxx_port *dev_id = &chip->ports[port];
 	unsigned int irq;
@@ -2483,7 +2483,7 @@ static int mv88e6xxx_serdes_irq_request(struct mv88e6xxx_chip *chip, int port,
 }
 
 static int mv88e6xxx_serdes_irq_free(struct mv88e6xxx_chip *chip, int port,
-				     u8 lane)
+				     int lane)
 {
 	struct mv88e6xxx_port *dev_id = &chip->ports[port];
 	unsigned int irq = dev_id->serdes_irq;
@@ -2508,11 +2508,11 @@ static int mv88e6xxx_serdes_irq_free(struct mv88e6xxx_chip *chip, int port,
 static int mv88e6xxx_serdes_power(struct mv88e6xxx_chip *chip, int port,
 				  bool on)
 {
-	u8 lane;
+	int lane;
 	int err;
 
 	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (!lane)
+	if (lane == -ENODEV)
 		return 0;
 
 	if (on) {
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index b7864a24a840..03c0466ab4ae 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -494,30 +494,30 @@ struct mv88e6xxx_ops {
 	int (*mgmt_rsvd2cpu)(struct mv88e6xxx_chip *chip);
 
 	/* Power on/off a SERDES interface */
-	int (*serdes_power)(struct mv88e6xxx_chip *chip, int port, u8 lane,
+	int (*serdes_power)(struct mv88e6xxx_chip *chip, int port, int lane,
 			    bool up);
 
 	/* SERDES lane mapping */
-	u8 (*serdes_get_lane)(struct mv88e6xxx_chip *chip, int port);
+	int (*serdes_get_lane)(struct mv88e6xxx_chip *chip, int port);
 
 	int (*serdes_pcs_get_state)(struct mv88e6xxx_chip *chip, int port,
-				    u8 lane, struct phylink_link_state *state);
+				    int lane, struct phylink_link_state *state);
 	int (*serdes_pcs_config)(struct mv88e6xxx_chip *chip, int port,
-				 u8 lane, unsigned int mode,
+				 int lane, unsigned int mode,
 				 phy_interface_t interface,
 				 const unsigned long *advertise);
 	int (*serdes_pcs_an_restart)(struct mv88e6xxx_chip *chip, int port,
-				     u8 lane);
+				     int lane);
 	int (*serdes_pcs_link_up)(struct mv88e6xxx_chip *chip, int port,
-				  u8 lane, int speed, int duplex);
+				  int lane, int speed, int duplex);
 
 	/* SERDES interrupt handling */
 	unsigned int (*serdes_irq_mapping)(struct mv88e6xxx_chip *chip,
 					   int port);
-	int (*serdes_irq_enable)(struct mv88e6xxx_chip *chip, int port, u8 lane,
+	int (*serdes_irq_enable)(struct mv88e6xxx_chip *chip, int port, int lane,
 				 bool enable);
 	irqreturn_t (*serdes_irq_status)(struct mv88e6xxx_chip *chip, int port,
-					 u8 lane);
+					 int lane);
 
 	/* Statistics from the SERDES interface */
 	int (*serdes_get_sset_count)(struct mv88e6xxx_chip *chip, int port);
diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
index 8e36a69d8cad..814c44a586b7 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -483,7 +483,7 @@ int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 				    phy_interface_t mode, bool force)
 {
-	u8 lane;
+	int lane;
 	u16 cmode;
 	u16 reg;
 	int err;
@@ -530,7 +530,7 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		return 0;
 
 	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (lane) {
+	if (lane != -ENODEV) {
 		if (chip->ports[port].serdes_irq) {
 			err = mv88e6xxx_serdes_irq_disable(chip, port, lane);
 			if (err)
@@ -559,7 +559,7 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		chip->ports[port].cmode = cmode;
 
 		lane = mv88e6xxx_serdes_get_lane(chip, port);
-		if (!lane)
+		if (lane == -ENODEV)
 			return -ENODEV;
 
 		err = mv88e6xxx_serdes_power_up(chip, port, lane);
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 9148dd0f4555..3fbd6af7548e 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -95,7 +95,7 @@ static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
 	return 0;
 }
 
-int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
+int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 			   bool up)
 {
 	u16 val, new_val;
@@ -117,7 +117,7 @@ int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
 }
 
 int mv88e6352_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
-				u8 lane, unsigned int mode,
+				int lane, unsigned int mode,
 				phy_interface_t interface,
 				const unsigned long *advertise)
 {
@@ -166,7 +166,7 @@ int mv88e6352_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 }
 
 int mv88e6352_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
-				   u8 lane, struct phylink_link_state *state)
+				   int lane, struct phylink_link_state *state)
 {
 	u16 lpa, status;
 	int err;
@@ -187,7 +187,7 @@ int mv88e6352_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 }
 
 int mv88e6352_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
-				    u8 lane)
+				    int lane)
 {
 	u16 bmcr;
 	int err;
@@ -200,7 +200,7 @@ int mv88e6352_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
 }
 
 int mv88e6352_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
-				 u8 lane, int speed, int duplex)
+				 int lane, int speed, int duplex)
 {
 	u16 val, bmcr;
 	int err;
@@ -230,10 +230,10 @@ int mv88e6352_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
 	return mv88e6352_serdes_write(chip, MII_BMCR, bmcr);
 }
 
-u8 mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
+int mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 {
 	u8 cmode = chip->ports[port].cmode;
-	u8 lane = 0;
+	int lane = -ENODEV;
 
 	if ((cmode == MV88E6XXX_PORT_STS_CMODE_100BASEX) ||
 	    (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX) ||
@@ -245,7 +245,7 @@ u8 mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 
 static bool mv88e6352_port_has_serdes(struct mv88e6xxx_chip *chip, int port)
 {
-	if (mv88e6xxx_serdes_get_lane(chip, port))
+	if (mv88e6xxx_serdes_get_lane(chip, port) != -ENODEV)
 		return true;
 
 	return false;
@@ -354,7 +354,7 @@ static void mv88e6352_serdes_irq_link(struct mv88e6xxx_chip *chip, int port)
 }
 
 irqreturn_t mv88e6352_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
-					u8 lane)
+					int lane)
 {
 	irqreturn_t ret = IRQ_NONE;
 	u16 status;
@@ -372,7 +372,7 @@ irqreturn_t mv88e6352_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 	return ret;
 }
 
-int mv88e6352_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
+int mv88e6352_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, int lane,
 				bool enable)
 {
 	u16 val = 0;
@@ -411,10 +411,10 @@ void mv88e6352_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p)
 	}
 }
 
-u8 mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
+int mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 {
 	u8 cmode = chip->ports[port].cmode;
-	u8 lane = 0;
+	int lane = -ENODEV;
 
 	switch (port) {
 	case 5:
@@ -428,10 +428,10 @@ u8 mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 	return lane;
 }
 
-u8 mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
+int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 {
 	u8 cmode = chip->ports[port].cmode;
-	u8 lane = 0;
+	int lane = -ENODEV;
 
 	switch (port) {
 	case 9:
@@ -451,12 +451,12 @@ u8 mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 	return lane;
 }
 
-u8 mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
+int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 {
 	u8 cmode_port = chip->ports[port].cmode;
 	u8 cmode_port10 = chip->ports[10].cmode;
 	u8 cmode_port9 = chip->ports[9].cmode;
-	u8 lane = 0;
+	int lane = -ENODEV;
 
 	switch (port) {
 	case 2:
@@ -529,10 +529,10 @@ u8 mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 /* Only Ports 0, 9 and 10 have SERDES lanes. Return the SERDES lane address
  * a port is using else Returns -ENODEV.
  */
-u8 mv88e6393x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
+int mv88e6393x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 {
 	u8 cmode = chip->ports[port].cmode;
-	u8 lane = 0;
+	int lane = -ENODEV;
 
 	if (port == 0 || port == 9 || port == 10) {
 		if (cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
@@ -547,7 +547,7 @@ u8 mv88e6393x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 }
 
 /* Set power up/down for 10GBASE-R and 10GBASE-X4/X2 */
-static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, u8 lane,
+static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, int lane,
 				      bool up)
 {
 	u16 val, new_val;
@@ -574,7 +574,7 @@ static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, u8 lane,
 }
 
 /* Set power up/down for SGMII and 1000Base-X */
-static int mv88e6390_serdes_power_sgmii(struct mv88e6xxx_chip *chip, u8 lane,
+static int mv88e6390_serdes_power_sgmii(struct mv88e6xxx_chip *chip, int lane,
 					bool up)
 {
 	u16 val, new_val;
@@ -610,7 +610,7 @@ static struct mv88e6390_serdes_hw_stat mv88e6390_serdes_hw_stats[] = {
 
 int mv88e6390_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port)
 {
-	if (mv88e6390_serdes_get_lane(chip, port) == 0)
+	if (mv88e6390_serdes_get_lane(chip, port) == -ENODEV)
 		return 0;
 
 	return ARRAY_SIZE(mv88e6390_serdes_hw_stats);
@@ -622,7 +622,7 @@ int mv88e6390_serdes_get_strings(struct mv88e6xxx_chip *chip,
 	struct mv88e6390_serdes_hw_stat *stat;
 	int i;
 
-	if (mv88e6390_serdes_get_lane(chip, port) == 0)
+	if (mv88e6390_serdes_get_lane(chip, port) == -ENODEV)
 		return 0;
 
 	for (i = 0; i < ARRAY_SIZE(mv88e6390_serdes_hw_stats); i++) {
@@ -659,7 +659,7 @@ int mv88e6390_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
 	int i;
 
 	lane = mv88e6390_serdes_get_lane(chip, port);
-	if (lane == 0)
+	if (lane == -ENODEV)
 		return 0;
 
 	for (i = 0; i < ARRAY_SIZE(mv88e6390_serdes_hw_stats); i++) {
@@ -670,7 +670,7 @@ int mv88e6390_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
 	return ARRAY_SIZE(mv88e6390_serdes_hw_stats);
 }
 
-static int mv88e6390_serdes_enable_checker(struct mv88e6xxx_chip *chip, u8 lane)
+static int mv88e6390_serdes_enable_checker(struct mv88e6xxx_chip *chip, int lane)
 {
 	u16 reg;
 	int err;
@@ -685,7 +685,7 @@ static int mv88e6390_serdes_enable_checker(struct mv88e6xxx_chip *chip, u8 lane)
 				      MV88E6390_PG_CONTROL, reg);
 }
 
-int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
+int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 			   bool up)
 {
 	u8 cmode = chip->ports[port].cmode;
@@ -710,7 +710,7 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
 }
 
 int mv88e6390_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
-				u8 lane, unsigned int mode,
+				int lane, unsigned int mode,
 				phy_interface_t interface,
 				const unsigned long *advertise)
 {
@@ -769,7 +769,7 @@ int mv88e6390_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 }
 
 static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *chip,
-	int port, u8 lane, struct phylink_link_state *state)
+	int port, int lane, struct phylink_link_state *state)
 {
 	u16 lpa, status;
 	int err;
@@ -792,7 +792,7 @@ static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *chip,
 }
 
 static int mv88e6390_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
-	int port, u8 lane, struct phylink_link_state *state)
+	int port, int lane, struct phylink_link_state *state)
 {
 	u16 status;
 	int err;
@@ -812,7 +812,7 @@ static int mv88e6390_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
 }
 
 int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
-				   u8 lane, struct phylink_link_state *state)
+				   int lane, struct phylink_link_state *state)
 {
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_SGMII:
@@ -831,7 +831,7 @@ int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 }
 
 int mv88e6390_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
-				    u8 lane)
+				    int lane)
 {
 	u16 bmcr;
 	int err;
@@ -847,7 +847,7 @@ int mv88e6390_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
 }
 
 int mv88e6390_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
-				 u8 lane, int speed, int duplex)
+				 int lane, int speed, int duplex)
 {
 	u16 val, bmcr;
 	int err;
@@ -881,7 +881,7 @@ int mv88e6390_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
 }
 
 static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
-					    int port, u8 lane)
+					    int port, int lane)
 {
 	u16 bmsr;
 	int err;
@@ -898,7 +898,7 @@ static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
 }
 
 static int mv88e6390_serdes_irq_enable_sgmii(struct mv88e6xxx_chip *chip,
-					     u8 lane, bool enable)
+					     int lane, bool enable)
 {
 	u16 val = 0;
 
@@ -910,7 +910,7 @@ static int mv88e6390_serdes_irq_enable_sgmii(struct mv88e6xxx_chip *chip,
 				      MV88E6390_SGMII_INT_ENABLE, val);
 }
 
-int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
+int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, int lane,
 				bool enable)
 {
 	u8 cmode = chip->ports[port].cmode;
@@ -926,7 +926,7 @@ int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
 }
 
 static int mv88e6390_serdes_irq_status_sgmii(struct mv88e6xxx_chip *chip,
-					     u8 lane, u16 *status)
+					     int lane, u16 *status)
 {
 	int err;
 
@@ -937,7 +937,7 @@ static int mv88e6390_serdes_irq_status_sgmii(struct mv88e6xxx_chip *chip,
 }
 
 int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
-	    u8 lane, bool enable)
+	    int lane, bool enable)
 {
 	u8 cmode = chip->ports[port].cmode;
 	int err = 0;
@@ -955,7 +955,7 @@ int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
 }
 
 irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
-				 u8 lane)
+				 int lane)
 {
 	u8 cmode = chip->ports[port].cmode;
 	irqreturn_t ret = IRQ_NONE;
@@ -982,7 +982,7 @@ irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 }
 
 irqreturn_t mv88e6390_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
-					u8 lane)
+					int lane)
 {
 	u8 cmode = chip->ports[port].cmode;
 	irqreturn_t ret = IRQ_NONE;
@@ -1041,7 +1041,7 @@ static const u16 mv88e6390_serdes_regs[] = {
 
 int mv88e6390_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port)
 {
-	if (mv88e6xxx_serdes_get_lane(chip, port) == 0)
+	if (mv88e6xxx_serdes_get_lane(chip, port) == -ENODEV)
 		return 0;
 
 	return ARRAY_SIZE(mv88e6390_serdes_regs) * sizeof(u16);
@@ -1055,7 +1055,7 @@ void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p)
 	int i;
 
 	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (lane == 0)
+	if (lane == -ENODEV)
 		return;
 
 	for (i = 0 ; i < ARRAY_SIZE(mv88e6390_serdes_regs); i++) {
@@ -1144,7 +1144,7 @@ int mv88e6393x_setup_errata(struct mv88e6xxx_chip *chip)
 	return err;
 }
 
-static int mv88e6393x_serdes_port_config(struct mv88e6xxx_chip *chip, u8 lane,
+static int mv88e6393x_serdes_port_config(struct mv88e6xxx_chip *chip, int lane,
 					bool on)
 {
 	u8 cmode = chip->ports[lane].cmode;
@@ -1203,11 +1203,9 @@ static int mv88e6393x_serdes_port_config(struct mv88e6xxx_chip *chip, u8 lane,
 	return 0;
 }
 
-int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
+int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 		    bool on)
 {
-	lane = mv88e6393x_serdes_get_lane(chip, port);
-
 	if (port == 0 || port == 9 || port == 10) {
 		u8 cmode = chip->ports[port].cmode;
 
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index c3eaaaac8619..150b2381b779 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -104,54 +104,54 @@
 #define MV88E6393X_ERRATA_1000BASEX_SGMII		0xF074
 #define MV88E6393X_ERRATA_1000BASEX_SGMII_BIT	BIT(14)
 
-u8 mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
-u8 mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
-u8 mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
-u8 mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
-u8 mv88e6393x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
+int mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
+int mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
+int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
+int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
+int mv88e6393x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
 int mv88e6352_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
-				u8 lane, unsigned int mode,
+				int lane, unsigned int mode,
 				phy_interface_t interface,
 				const unsigned long *advertise);
 int mv88e6390_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
-				u8 lane, unsigned int mode,
+				int lane, unsigned int mode,
 				phy_interface_t interface,
 				const unsigned long *advertise);
 int mv88e6352_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
-				   u8 lane, struct phylink_link_state *state);
+				   int lane, struct phylink_link_state *state);
 int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
-				   u8 lane, struct phylink_link_state *state);
+				   int lane, struct phylink_link_state *state);
 int mv88e6352_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
-				    u8 lane);
+				    int lane);
 int mv88e6390_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
-				    u8 lane);
+				    int lane);
 int mv88e6352_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
-				 u8 lane, int speed, int duplex);
+				 int lane, int speed, int duplex);
 int mv88e6390_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
-				 u8 lane, int speed, int duplex);
+				 int lane, int speed, int duplex);
 unsigned int mv88e6352_serdes_irq_mapping(struct mv88e6xxx_chip *chip,
 					  int port);
 unsigned int mv88e6390_serdes_irq_mapping(struct mv88e6xxx_chip *chip,
 					  int port);
-int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
+int mv88e6352_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 			   bool on);
-int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
+int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 			   bool on);
-int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
+int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 		    bool on);
 int mv88e6393x_setup_errata(struct mv88e6xxx_chip *chip);
-int mv88e6352_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
+int mv88e6352_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, int lane,
 				bool enable);
-int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
+int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, int lane,
 				bool enable);
 int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
-	    u8 lane, bool enable);
+	    int lane, bool enable);
 irqreturn_t mv88e6352_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
-					u8 lane);
+					int lane);
 irqreturn_t mv88e6390_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
-					u8 lane);
+					int lane);
 irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
-					u8 lane);
+					int lane);
 int mv88e6352_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port);
 int mv88e6352_serdes_get_strings(struct mv88e6xxx_chip *chip,
 				 int port, uint8_t *data);
@@ -169,17 +169,17 @@ int mv88e6390_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port);
 void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p);
 
 /* Return the (first) SERDES lane address a port is using, 0 otherwise. */
-static inline u8 mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
+static inline int mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
 					   int port)
 {
 	if (!chip->info->ops->serdes_get_lane)
-		return 0;
+		return -EOPNOTSUPP;
 
 	return chip->info->ops->serdes_get_lane(chip, port);
 }
 
 static inline int mv88e6xxx_serdes_power_up(struct mv88e6xxx_chip *chip,
-					    int port, u8 lane)
+					    int port, int lane)
 {
 	if (!chip->info->ops->serdes_power)
 		return -EOPNOTSUPP;
@@ -188,7 +188,7 @@ static inline int mv88e6xxx_serdes_power_up(struct mv88e6xxx_chip *chip,
 }
 
 static inline int mv88e6xxx_serdes_power_down(struct mv88e6xxx_chip *chip,
-					      int port, u8 lane)
+					      int port, int lane)
 {
 	if (!chip->info->ops->serdes_power)
 		return -EOPNOTSUPP;
@@ -206,7 +206,7 @@ mv88e6xxx_serdes_irq_mapping(struct mv88e6xxx_chip *chip, int port)
 }
 
 static inline int mv88e6xxx_serdes_irq_enable(struct mv88e6xxx_chip *chip,
-					      int port, u8 lane)
+					      int port, int lane)
 {
 	if (!chip->info->ops->serdes_irq_enable)
 		return -EOPNOTSUPP;
@@ -215,7 +215,7 @@ static inline int mv88e6xxx_serdes_irq_enable(struct mv88e6xxx_chip *chip,
 }
 
 static inline int mv88e6xxx_serdes_irq_disable(struct mv88e6xxx_chip *chip,
-					       int port, u8 lane)
+					       int port, int lane)
 {
 	if (!chip->info->ops->serdes_irq_enable)
 		return -EOPNOTSUPP;
@@ -224,7 +224,7 @@ static inline int mv88e6xxx_serdes_irq_disable(struct mv88e6xxx_chip *chip,
 }
 
 static inline irqreturn_t
-mv88e6xxx_serdes_irq_status(struct mv88e6xxx_chip *chip, int port, u8 lane)
+mv88e6xxx_serdes_irq_status(struct mv88e6xxx_chip *chip, int port, int lane)
 {
 	if (!chip->info->ops->serdes_irq_status)
 		return IRQ_NONE;
-- 
2.17.1

