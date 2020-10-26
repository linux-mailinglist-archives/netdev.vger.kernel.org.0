Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106702986AF
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 07:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1770142AbgJZF7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 01:59:22 -0400
Received: from outbound-ip23a.ess.barracuda.com ([209.222.82.205]:57014 "EHLO
        outbound-ip23a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1770134AbgJZF7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 01:59:22 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104]) by mx1.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 26 Oct 2020 05:59:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EeE+XPZ2fWx4C15TtrcyhRa+hmen8L/4GMUiUawdj3IIm6X8PxFaNlY/nC8vwqz5wukjDfaLjkrRrnxJU0/NYCuFQkn4+8wVJ+IA+wv/rfC6T7J2gYRbr+hZPx0afFqA9C8jnqCPLOPHIxxCHm2eyRpCT6j1d+9sq9f0fIkateleMAPhWCbDV50c8uJHfuktWsOatsfLZKIS8EpNLJvHf/e+eeTQxbLBut3l8j8nGdrv5ET7HajXMHA/Khw0siZJc+7mOvW0qkR52DMXRY9LMUwxnR3fcos4ruvOKBR5S/Aq7VtCbg+Zt/MpglOG9/0mrtUDqtOESDAuzIy3MSnMtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=274uNB7ARaeihZRMrTxubwEFHKxbZ1n+P9CoUYO53kc=;
 b=TZcMGJhOa3Jow3OA8g4e+ED2cL5R+03B37cp++tJZDEE7WrTx68V89xAj9EAJJTXpv3phSxijVhznL3ugsI6YIHihJLFZF6B3Oy+9x5mjzBKfPCDeGBT9By0FBV5Z1yAY4p7Fq/+jx/PK4w87aaNT14xLCTI3P8PH+LFrYEZ+bmb3l3FMo8DikIgWyOOdL5IEbbkjJmNSZOmUHyvyUEUeBFxaTCntjUkfaVeoYmLBCnLih4q5h4RzTrJ82kZ0skgTJXUwmF4I4nIszLUuxigOyU0U9h4EubsRch8v2zR7BVfumqO8ZTizGDqfsEKLMAMG+aKCPbkkezCgPtUf+qJNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=274uNB7ARaeihZRMrTxubwEFHKxbZ1n+P9CoUYO53kc=;
 b=YGvKCDR2at4b3SKPGSw4QkCmCO/INYVpjx7GTUHZc0LGiiJRYeZiq6EcFk5+BJ4Bh16wCjQywVEezYnuXQp1zpBBI++MQhF1lP/WtSTszQnMNhI5Xb5X0wZuyrpiISL96F/7dWUU8ziT4Z1Pv/imrVdcyGmEXF8Wo8Wj22OEwno=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by MN2PR10MB4253.namprd10.prod.outlook.com (2603:10b6:208:1d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Mon, 26 Oct
 2020 05:59:12 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%8]) with mapi id 15.20.3477.028; Mon, 26 Oct 2020
 05:59:12 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     andrew@lunn.ch
Cc:     davem@davemloft.net, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pavana.sharma@digi.com, vivien.didelot@gmail.com
Subject: [PATCH v4 3/3] Change serdes lane parameter from u8 type to int.
Date:   Mon, 26 Oct 2020 15:58:51 +1000
Message-Id: <922c8f7ea3a25bda8ff46b673ea6af3c1581e4d0.1603690202.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1603690201.git.pavana.sharma@digi.com>
References: <cover.1603690201.git.pavana.sharma@digi.com>
Content-Type: text/plain
X-Originating-IP: [58.84.104.89]
X-ClientProxiedBy: SY4P282CA0014.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:a0::24) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (58.84.104.89) by SY4P282CA0014.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:a0::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Mon, 26 Oct 2020 05:59:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9b4606d-5448-405a-0853-08d8797442b5
X-MS-TrafficTypeDiagnostic: MN2PR10MB4253:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB425316198F73245988C1DE1B95190@MN2PR10MB4253.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pnsGM7GxDHtVNUdSdM0pUYAcYCvSqbD0B51X6BBU11qqX++Hqh/q0jR5rkgtpRuiaf++8hoveOOtoy4d3cLd/DWIMcYcd70/tz6pSNiaHep3tsurlysWhz29rDgdUtRr+NVBL6ZrL0EXUHJtpQdwPr3jZTdNx/UobGT2r4LZszTR2TzfV9uFFfaj3VnWj1Xq55EN8afG3IsVgLg3cV5FcBhJEhf8tVjn4G7zoUyLj/IUde2esUCeNW/rd2FHVPd58SBhGJk0uyyujDL3sFiHHDJZBSa6GftCeH5L+nt0btYmg2k23GTdORIrZTe7/bfoiRYnNAZr3gRxpsnB/LZyHbcweLwgwofJXs5X/KDJ3V9GiYLtS7K+2cUvQ1bIQ037
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39840400004)(396003)(366004)(4326008)(16526019)(66476007)(2616005)(86362001)(26005)(36756003)(956004)(52116002)(316002)(83380400001)(6512007)(69590400008)(2906002)(8936002)(186003)(6506007)(478600001)(44832011)(5660300002)(30864003)(8676002)(66556008)(6916009)(6486002)(66946007)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: C7lfooD7hqO3qiRPjxXPuL6FHCBeGDoviOmxqNnBwt0KbHxBEiRrJRwy6LAPPN6ozdp+OlT7lMPKYWFwR0C5Lu2u2r/Wguy4QIn4WVgk7NDkXPBOD3xRYsS+fSb48tLrVXjJOL1DksQ0JnnzBDjLEf+ycmM+FUQOT8MxNfWMhy1r2Dz0kgRCeMhwV8AgB4ILiLjrUGPsLpskg8ShcfpDOm60LvHXdISs/apGuOeulINVlmUfsaRXJODRRUh7pbBy9/3+56NlLWF/NBXpfkWGK2Et5MWRvoCbNMnQrlAfwmMNMoRa4b4WIexoKyVsJDzsTN+IOHNv5NmqanZUTPyrmoRyOoT54J/kJoiLOPNQt8JW3tDG0R6qbB8AbFyTYNwFQWBPQHaSkFGOLOI6Kn63W6aOmdJ4s1+MbkGHqfckzbewSMqGlfQ5FGrdQRKg3TBVnFFabA48GqE78QFZT9EAbN5UE0j4rrUn1rbWQ/9WcYfiwo27VbdDirPwDHpZJlyuKhqofK8GIpPP2VF2GM34couUAi1trugDHUeBBT/89L2ADoGjdxWZInQl2dnSws+l4WRuSY24tVsi1POhkm97qKBtvu1GuDVTkv63VJLVgOTOsBHRXP4vZp78kf9e+xcrlOu2KGb30mWELGm29gTIRw==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9b4606d-5448-405a-0853-08d8797442b5
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2020 05:59:12.0848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kt5cm2foNZEqmpnTwIzgPbAV5hBR2L/yQvOF8FbAft5USs/nPGK+LO/5qJ/Tpjr9agGzHTkYfoegE0vo0xA24A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4253
X-BESS-ID: 1603691953-893000-31323-329050-1
X-BESS-VER: 2019.3_20201021.2124
X-BESS-Apparent-Source-IP: 104.47.70.104
X-BESS-Outbound-Spam-Score: 1.70
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.227798 [from 
        cloudscan11-144.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 MSGID_FROM_MTA_HEADER  META: Message-Id was added by a relay 
        1.20 SORTED_RECIPS          HEADER: Recipient list is sorted by address 
        0.50 BSF_RULE7568M          META: Custom Rule 7568M 
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=1.70 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=MSGID_FROM_MTA_HEADER, SORTED_RECIPS, BSF_RULE7568M, BSF_BESS_OUTBOUND
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
 drivers/net/dsa/mv88e6xxx/chip.c   | 28 +++++------
 drivers/net/dsa/mv88e6xxx/chip.h   | 16 +++---
 drivers/net/dsa/mv88e6xxx/port.c   |  6 +--
 drivers/net/dsa/mv88e6xxx/serdes.c | 80 +++++++++++++++---------------
 drivers/net/dsa/mv88e6xxx/serdes.h | 58 +++++++++++-----------
 5 files changed, 93 insertions(+), 95 deletions(-)

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
index 4089bfd4e8f4..9a21748bf50f 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -482,7 +482,7 @@ int mv88e6393x_port_set_speed_duplex(struct mv88e6xxx_chip *chip, int port,
 static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 				    phy_interface_t mode, bool force)
 {
-	u8 lane;
+	int lane;
 	u16 cmode;
 	u16 reg;
 	int err;
@@ -529,7 +529,7 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		return 0;
 
 	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (lane) {
+	if (lane != -ENODEV) {
 		if (chip->ports[port].serdes_irq) {
 			err = mv88e6xxx_serdes_irq_disable(chip, port, lane);
 			if (err)
@@ -558,7 +558,7 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		chip->ports[port].cmode = cmode;
 
 		lane = mv88e6xxx_serdes_get_lane(chip, port);
-		if (!lane)
+		if (lane == -ENODEV)
 			return -ENODEV;
 
 		err = mv88e6xxx_serdes_power_up(chip, port, lane);
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index d0bdbd8ae055..3cfc996de8bd 100644
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
@@ -548,7 +548,7 @@ int mv88e6393x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 }
 
 /* Set power up/down for 10GBASE-R and 10GBASE-X4/X2 */
-static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, u8 lane,
+static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, int lane,
 				      bool up)
 {
 	u16 val, new_val;
@@ -575,7 +575,7 @@ static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, u8 lane,
 }
 
 /* Set power up/down for SGMII and 1000Base-X */
-static int mv88e6390_serdes_power_sgmii(struct mv88e6xxx_chip *chip, u8 lane,
+static int mv88e6390_serdes_power_sgmii(struct mv88e6xxx_chip *chip, int lane,
 					bool up)
 {
 	u16 val, new_val;
@@ -611,7 +611,7 @@ static struct mv88e6390_serdes_hw_stat mv88e6390_serdes_hw_stats[] = {
 
 int mv88e6390_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port)
 {
-	if (mv88e6390_serdes_get_lane(chip, port) == 0)
+	if (mv88e6390_serdes_get_lane(chip, port) == -ENODEV)
 		return 0;
 
 	return ARRAY_SIZE(mv88e6390_serdes_hw_stats);
@@ -623,7 +623,7 @@ int mv88e6390_serdes_get_strings(struct mv88e6xxx_chip *chip,
 	struct mv88e6390_serdes_hw_stat *stat;
 	int i;
 
-	if (mv88e6390_serdes_get_lane(chip, port) == 0)
+	if (mv88e6390_serdes_get_lane(chip, port) == -ENODEV)
 		return 0;
 
 	for (i = 0; i < ARRAY_SIZE(mv88e6390_serdes_hw_stats); i++) {
@@ -660,7 +660,7 @@ int mv88e6390_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
 	int i;
 
 	lane = mv88e6390_serdes_get_lane(chip, port);
-	if (lane == 0)
+	if (lane == -ENODEV)
 		return 0;
 
 	for (i = 0; i < ARRAY_SIZE(mv88e6390_serdes_hw_stats); i++) {
@@ -671,7 +671,7 @@ int mv88e6390_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
 	return ARRAY_SIZE(mv88e6390_serdes_hw_stats);
 }
 
-static int mv88e6390_serdes_enable_checker(struct mv88e6xxx_chip *chip, u8 lane)
+static int mv88e6390_serdes_enable_checker(struct mv88e6xxx_chip *chip, int lane)
 {
 	u16 reg;
 	int err;
@@ -686,7 +686,7 @@ static int mv88e6390_serdes_enable_checker(struct mv88e6xxx_chip *chip, u8 lane)
 				      MV88E6390_PG_CONTROL, reg);
 }
 
-int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
+int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 			   bool up)
 {
 	u8 cmode = chip->ports[port].cmode;
@@ -711,7 +711,7 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
 }
 
 int mv88e6390_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
-				u8 lane, unsigned int mode,
+				int lane, unsigned int mode,
 				phy_interface_t interface,
 				const unsigned long *advertise)
 {
@@ -770,7 +770,7 @@ int mv88e6390_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 }
 
 static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *chip,
-	int port, u8 lane, struct phylink_link_state *state)
+	int port, int lane, struct phylink_link_state *state)
 {
 	u16 lpa, status;
 	int err;
@@ -793,7 +793,7 @@ static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *chip,
 }
 
 static int mv88e6390_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
-	int port, u8 lane, struct phylink_link_state *state)
+	int port, int lane, struct phylink_link_state *state)
 {
 	u16 status;
 	int err;
@@ -813,7 +813,7 @@ static int mv88e6390_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
 }
 
 int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
-				   u8 lane, struct phylink_link_state *state)
+				   int lane, struct phylink_link_state *state)
 {
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_SGMII:
@@ -832,7 +832,7 @@ int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 }
 
 int mv88e6390_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
-				    u8 lane)
+				    int lane)
 {
 	u16 bmcr;
 	int err;
@@ -848,7 +848,7 @@ int mv88e6390_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
 }
 
 int mv88e6390_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
-				 u8 lane, int speed, int duplex)
+				 int lane, int speed, int duplex)
 {
 	u16 val, bmcr;
 	int err;
@@ -882,7 +882,7 @@ int mv88e6390_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
 }
 
 static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
-					    int port, u8 lane)
+					    int port, int lane)
 {
 	u16 bmsr;
 	int err;
@@ -899,7 +899,7 @@ static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
 }
 
 static int mv88e6390_serdes_irq_enable_sgmii(struct mv88e6xxx_chip *chip,
-					     u8 lane, bool enable)
+					     int lane, bool enable)
 {
 	u16 val = 0;
 
@@ -911,7 +911,7 @@ static int mv88e6390_serdes_irq_enable_sgmii(struct mv88e6xxx_chip *chip,
 				      MV88E6390_SGMII_INT_ENABLE, val);
 }
 
-int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
+int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, int lane,
 				bool enable)
 {
 	u8 cmode = chip->ports[port].cmode;
@@ -927,7 +927,7 @@ int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
 }
 
 static int mv88e6390_serdes_irq_status_sgmii(struct mv88e6xxx_chip *chip,
-					     u8 lane, u16 *status)
+					     int lane, u16 *status)
 {
 	int err;
 
@@ -938,7 +938,7 @@ static int mv88e6390_serdes_irq_status_sgmii(struct mv88e6xxx_chip *chip,
 }
 
 int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
-	    u8 lane, bool enable)
+	    int lane, bool enable)
 {
 	u8 cmode = chip->ports[port].cmode;
 	int err = 0;
@@ -956,7 +956,7 @@ int mv88e6393x_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port,
 }
 
 irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
-				 u8 lane)
+				 int lane)
 {
 	u8 cmode = chip->ports[port].cmode;
 	irqreturn_t ret = IRQ_NONE;
@@ -983,7 +983,7 @@ irqreturn_t mv88e6393x_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
 }
 
 irqreturn_t mv88e6390_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
-					u8 lane)
+					int lane)
 {
 	u8 cmode = chip->ports[port].cmode;
 	irqreturn_t ret = IRQ_NONE;
@@ -1042,7 +1042,7 @@ static const u16 mv88e6390_serdes_regs[] = {
 
 int mv88e6390_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port)
 {
-	if (mv88e6xxx_serdes_get_lane(chip, port) == 0)
+	if (mv88e6xxx_serdes_get_lane(chip, port) == -ENODEV)
 		return 0;
 
 	return ARRAY_SIZE(mv88e6390_serdes_regs) * sizeof(u16);
@@ -1056,7 +1056,7 @@ void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p)
 	int i;
 
 	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (lane == 0)
+	if (lane == -ENODEV)
 		return;
 
 	for (i = 0 ; i < ARRAY_SIZE(mv88e6390_serdes_regs); i++) {
@@ -1204,11 +1204,9 @@ static int mv88e6393x_serdes_port_config(struct mv88e6xxx_chip *chip, int lane,
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

