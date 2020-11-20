Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2CF2B9F49
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 01:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgKTA0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 19:26:47 -0500
Received: from outbound-ip23b.ess.barracuda.com ([209.222.82.220]:54790 "EHLO
        outbound-ip23b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726192AbgKTA0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 19:26:46 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176]) by mx5.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 20 Nov 2020 00:26:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TP75nK/xz2WBjMs4mGTf+5nHr0+68EVZTXgb82zLnbMckKYpJKr+qwDYtcmfMSAfp+CVVrgRlZ3aylRbTxosJ9oLxc/pkI2fQ2j5YSMTXDjOqAhBabCg7T1ku9V+W5oP1dlkhUZ/6dgQUxqmRHsKlpHqroip05TF6Tie2mYM34gjpFn0JuAbJ/Rp3utVsoGYOjQMdu70mFbJfUrtjps8DphFe1ekW01sn+CZouG0WArC1qXDWAtoynFkEjAH6FZslcJPUj7r0g6CF1s99hNbSBzWKQC1kmqMZsxA+8Us6gMAaTbz08Cx/YQGM1g/Sw+B2P1x4nsjVWuO4nh2JyuFOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WI8ma3aeR6JhCXnuT9FkcLM1t1v5D6W2G+KNh9ZQn5M=;
 b=I8bP64XmFFUzup5Q0be+/ugcvbyCs5lyjFnH+h71BJUcPIrrhlUpsdaV0/s7p4VpGwMdofjOvkM90etQxxYzYJDCJ4ThkrElJe5Ht+bI4mrJv2LiZ9SEGzPg4i/vcw5DHdCwiPo3tQrSAs31BzHtmpfG6T/f/SBYJgf+58oZZhUuM77oJjVqrIOx+/O/mBY1saxU0k3NpTFYmjt8ruvKyi1Uhj/oTjKQg+2efGyOcNrr84/w5NViHumjgMAdKWIKvvORth7U4mdGlIkEGL31hMOnk7BTurF5U9xcQabCB69TrctFLxw8Tkdo76SgPuAMyRIa9+ZavxNvFErQxbsqsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WI8ma3aeR6JhCXnuT9FkcLM1t1v5D6W2G+KNh9ZQn5M=;
 b=dmoHa3dQSu6NIS/RZKlmcnbw2l/qKbE6LQ3iGJEzPfElazGCy0do1jIbBy0vET9eBWzKttqiWItp0jW22pJMe/zE4R525OGo4P+NccjjNc39u4SO0luOENBcbqUzTJZgfK2/0XlcFk6IUzZOq39ArmmbpCgvLgUHJa4vD/yMHpU=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by BL0PR10MB3443.namprd10.prod.outlook.com (2603:10b6:208:74::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Fri, 20 Nov
 2020 00:26:28 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%9]) with mapi id 15.20.3564.028; Fri, 20 Nov 2020
 00:26:28 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     lkp@intel.com
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com,
        clang-built-linux@googlegroups.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        kbuild-all@lists.01.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, marek.behun@nic.cz,
        netdev@vger.kernel.org, pavana.sharma@digi.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, vivien.didelot@gmail.com
Subject: [PATCH v10 3/4] net: dsa: mv88e6xxx: Change serdes lane parameter from  u8 type to int
Date:   Fri, 20 Nov 2020 10:26:04 +1000
Message-Id: <eff598a6313c0d2ad2a58227063adf86d0c10e90.1605830552.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605830552.git.pavana.sharma@digi.com>
References: <cover.1605830552.git.pavana.sharma@digi.com>
Content-Type: text/plain
X-Originating-IP: [14.200.39.236]
X-ClientProxiedBy: SY4P282CA0014.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:a0::24) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (14.200.39.236) by SY4P282CA0014.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:a0::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Fri, 20 Nov 2020 00:26:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 022cd705-3130-493a-0f7e-08d88ceaeb7f
X-MS-TrafficTypeDiagnostic: BL0PR10MB3443:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR10MB344310BC54DCBECFC99CBB0095FF0@BL0PR10MB3443.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FaruZ5TAJAq0a31r0pxZQw0zz8CaEKhVxpbOYXgyCPsEFxlYv7BZEHmhtk94u3Nyyh+pr4eUFayzytI285IQ8jR3Fiza+d6x0rlxm9D4+hv6LAQR7uRAaucKy4gG6Dxm3DDfoTaP8BuVlO6lSbRAy7vugGFqywqD0Thv/dEushZwgZwwUuJA/jB1H5NO0H/KmR5JZRwcEpsJ+hquQTOTnhICcXSrxT1afJZ5sL8UliaB07mL7elwOfrMysONoZ6dhj378Vv5VjODiQ1Lk6csTU+KoJ2Bds1AwyFOjzLD7SnE5tSGz4CYR0gzLWiJKaksnG6ks+HWMKCl9hzNV4nd1IVD2jlZmSPo85C+F1lBXlMZMqvfYAfsJCXi+aUFxcyU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39850400004)(366004)(396003)(136003)(36756003)(6512007)(7416002)(5660300002)(6666004)(6916009)(30864003)(6486002)(4326008)(66556008)(66476007)(478600001)(66946007)(8676002)(8936002)(86362001)(316002)(2616005)(956004)(44832011)(2906002)(6506007)(69590400008)(16526019)(186003)(52116002)(83380400001)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: SIza/CEpdBsoi5ViVvSV/DM824sXlQlyn9CorOCG35B2DkjgLngyMO1JrdSsIfSsqMphKh6BMAV7GdqZ/jIKhMcotzj+QvWUDxIPcLfXN31fcLfELfaC4eSrq+HlALst2694qGkkBICKoy+fGi3/8vjPy7Et6Hq+KH0aDK9xyLqMpwfu1HmPgLyBpPeCmOkqvKC4CvBVZa23XBoDEKMX6S6Vpd8f6ErHlqKgknUSBGjtWajtOd0nFMP9VPcwj9IhNzhhgtxwAqREWdHfomJYZySwahyCzIoRyxnIJ7ftWudjMD23zQbqp9k7M74RiFT5b78XWbBeC67QsG5jRJjaZhdiRtC2KTPRL61pnnfiX3/I4JoFz+faDXH4h3E9+/byAb3I7lzIWSPDDXkeNSibEuwvfmstaSv/xx4T2Ch7pXfnv6k+8q6kMGqI0Ejt9qwt0RKT+6kJkbGu39raPNxxplb2D0hJNYdQvKXlYex73flmk1w0MyjIoJz/buTGc09NWUVA64r8SN5BCKFZzK5tlkNtlZcBPm61b9BjcNLK/XwbosjiMyZd6C2KRporjCj//z+V91BmIF+1mApCP8huxoZLsdV+UaL54d3oURnWjDNqHWjCas57JwuFxCvSGxp4ZjnX5rgLBkUXKKX1ozIr1oAOHjN9tDtq0e0SJ6swGW4svfpU5JHvNoLpuC8jb47VOXHPb6Aaayhy3uZYY1Tg2RrZNx31tzRxlisgkgiBNlyBkO9aAbsk6UdhdSz73pU6GpUvBYyH99MtJZovA9TL540VWmv+uGUo0Tc8hVonyTGmyv6rjvW7aXZc3cUGFwXS5+I9qGhiVvd9wimmH5r7Cz66fVN0MpUNza65nfDERDvSz4uhFrj4wQNoiS7iY3kG1jrLHH3LD/O8pBA1SWPP/Q==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 022cd705-3130-493a-0f7e-08d88ceaeb7f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2020 00:26:27.9669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VcAGfiDC3/jUmz9b5apNqUT2QxC36vKyOvpF9dIjSJhUh6aqN7T6Af81fIwJdbEEtCfNGWCOrhphA/0XyZd4tg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3443
X-BESS-ID: 1605831989-893009-4587-767-1
X-BESS-VER: 2019.1_20201120.0004
X-BESS-Apparent-Source-IP: 104.47.59.176
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228307 [from 
        cloudscan13-142.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 MSGID_FROM_MTA_HEADER  META: Message-Id was added by a relay 
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=MSGID_FROM_MTA_HEADER, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Returning 0 is no more an error case with MV88E6393 family
which has serdes lane numbers 0, 9 or 10.
So with this change .serdes_get_lane will return lane number
or -errno (-ENODEV or -EOPNOTSUPP).

Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c   | 28 ++++++------
 drivers/net/dsa/mv88e6xxx/chip.h   | 16 +++----
 drivers/net/dsa/mv88e6xxx/port.c   |  6 +--
 drivers/net/dsa/mv88e6xxx/serdes.c | 72 +++++++++++++++---------------
 drivers/net/dsa/mv88e6xxx/serdes.h | 54 +++++++++++-----------
 5 files changed, 88 insertions(+), 88 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index bd297ae7cf9e..57b6ce785629 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -485,12 +485,12 @@ static int mv88e6xxx_serdes_pcs_get_state(struct dsa_switch *ds, int port,
 					  struct phylink_link_state *state)
 {
 	struct mv88e6xxx_chip *chip = ds->priv;
-	u8 lane;
+	int lane;
 	int err;
 
 	mv88e6xxx_reg_lock(chip);
 	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (lane && chip->info->ops->serdes_pcs_get_state)
+	if (lane >= 0 && chip->info->ops->serdes_pcs_get_state)
 		err = chip->info->ops->serdes_pcs_get_state(chip, port, lane,
 							    state);
 	else
@@ -506,11 +506,11 @@ static int mv88e6xxx_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 				       const unsigned long *advertise)
 {
 	const struct mv88e6xxx_ops *ops = chip->info->ops;
-	u8 lane;
+	int lane;
 
 	if (ops->serdes_pcs_config) {
 		lane = mv88e6xxx_serdes_get_lane(chip, port);
-		if (lane)
+		if (lane >= 0)
 			return ops->serdes_pcs_config(chip, port, lane, mode,
 						      interface, advertise);
 	}
@@ -523,14 +523,14 @@ static void mv88e6xxx_serdes_pcs_an_restart(struct dsa_switch *ds, int port)
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
+		if (lane >= 0)
 			err = ops->serdes_pcs_an_restart(chip, port, lane);
 		mv88e6xxx_reg_unlock(chip);
 
@@ -544,11 +544,11 @@ static int mv88e6xxx_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
 					int speed, int duplex)
 {
 	const struct mv88e6xxx_ops *ops = chip->info->ops;
-	u8 lane;
+	int lane;
 
 	if (!phylink_autoneg_inband(mode) && ops->serdes_pcs_link_up) {
 		lane = mv88e6xxx_serdes_get_lane(chip, port);
-		if (lane)
+		if (lane >= 0)
 			return ops->serdes_pcs_link_up(chip, port, lane,
 						       speed, duplex);
 	}
@@ -2422,11 +2422,11 @@ static irqreturn_t mv88e6xxx_serdes_irq_thread_fn(int irq, void *dev_id)
 	struct mv88e6xxx_chip *chip = mvp->chip;
 	irqreturn_t ret = IRQ_NONE;
 	int port = mvp->port;
-	u8 lane;
+	int lane;
 
 	mv88e6xxx_reg_lock(chip);
 	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (lane)
+	if (lane >= 0)
 		ret = mv88e6xxx_serdes_irq_status(chip, port, lane);
 	mv88e6xxx_reg_unlock(chip);
 
@@ -2434,7 +2434,7 @@ static irqreturn_t mv88e6xxx_serdes_irq_thread_fn(int irq, void *dev_id)
 }
 
 static int mv88e6xxx_serdes_irq_request(struct mv88e6xxx_chip *chip, int port,
-					u8 lane)
+					int lane)
 {
 	struct mv88e6xxx_port *dev_id = &chip->ports[port];
 	unsigned int irq;
@@ -2463,7 +2463,7 @@ static int mv88e6xxx_serdes_irq_request(struct mv88e6xxx_chip *chip, int port,
 }
 
 static int mv88e6xxx_serdes_irq_free(struct mv88e6xxx_chip *chip, int port,
-				     u8 lane)
+				     int lane)
 {
 	struct mv88e6xxx_port *dev_id = &chip->ports[port];
 	unsigned int irq = dev_id->serdes_irq;
@@ -2488,11 +2488,11 @@ static int mv88e6xxx_serdes_irq_free(struct mv88e6xxx_chip *chip, int port,
 static int mv88e6xxx_serdes_power(struct mv88e6xxx_chip *chip, int port,
 				  bool on)
 {
-	u8 lane;
+	int lane;
 	int err;
 
 	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (!lane)
+	if (lane < 0)
 		return 0;
 
 	if (on) {
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 81c244fc0419..d81f586d67e8 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -506,30 +506,30 @@ struct mv88e6xxx_ops {
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
index 8128dc607cf4..89d4c16fbbb5 100644
--- a/drivers/net/dsa/mv88e6xxx/port.c
+++ b/drivers/net/dsa/mv88e6xxx/port.c
@@ -393,8 +393,8 @@ phy_interface_t mv88e6390x_port_max_speed_mode(int port)
 static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 				    phy_interface_t mode, bool force)
 {
-	u8 lane;
 	u16 cmode;
+	int lane;
 	u16 reg;
 	int err;
 
@@ -430,7 +430,7 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		return 0;
 
 	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (lane) {
+	if (lane >= 0) {
 		if (chip->ports[port].serdes_irq) {
 			err = mv88e6xxx_serdes_irq_disable(chip, port, lane);
 			if (err)
@@ -459,7 +459,7 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
 		chip->ports[port].cmode = cmode;
 
 		lane = mv88e6xxx_serdes_get_lane(chip, port);
-		if (!lane)
+		if (lane < 0)
 			return -ENODEV;
 
 		err = mv88e6xxx_serdes_power_up(chip, port, lane);
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 9c07b4f3d345..058cce01c01e 100644
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
+	if (mv88e6xxx_serdes_get_lane(chip, port) >= 0)
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
@@ -527,7 +527,7 @@ u8 mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port)
 }
 
 /* Set power up/down for 10GBASE-R and 10GBASE-X4/X2 */
-static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, u8 lane,
+static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, int lane,
 				      bool up)
 {
 	u16 val, new_val;
@@ -554,7 +554,7 @@ static int mv88e6390_serdes_power_10g(struct mv88e6xxx_chip *chip, u8 lane,
 }
 
 /* Set power up/down for SGMII and 1000Base-X */
-static int mv88e6390_serdes_power_sgmii(struct mv88e6xxx_chip *chip, u8 lane,
+static int mv88e6390_serdes_power_sgmii(struct mv88e6xxx_chip *chip, int lane,
 					bool up)
 {
 	u16 val, new_val;
@@ -590,7 +590,7 @@ static struct mv88e6390_serdes_hw_stat mv88e6390_serdes_hw_stats[] = {
 
 int mv88e6390_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port)
 {
-	if (mv88e6390_serdes_get_lane(chip, port) == 0)
+	if (mv88e6390_serdes_get_lane(chip, port) < 0)
 		return 0;
 
 	return ARRAY_SIZE(mv88e6390_serdes_hw_stats);
@@ -602,7 +602,7 @@ int mv88e6390_serdes_get_strings(struct mv88e6xxx_chip *chip,
 	struct mv88e6390_serdes_hw_stat *stat;
 	int i;
 
-	if (mv88e6390_serdes_get_lane(chip, port) == 0)
+	if (mv88e6390_serdes_get_lane(chip, port) < 0)
 		return 0;
 
 	for (i = 0; i < ARRAY_SIZE(mv88e6390_serdes_hw_stats); i++) {
@@ -639,7 +639,7 @@ int mv88e6390_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
 	int i;
 
 	lane = mv88e6390_serdes_get_lane(chip, port);
-	if (lane == 0)
+	if (lane < 0)
 		return 0;
 
 	for (i = 0; i < ARRAY_SIZE(mv88e6390_serdes_hw_stats); i++) {
@@ -650,7 +650,7 @@ int mv88e6390_serdes_get_stats(struct mv88e6xxx_chip *chip, int port,
 	return ARRAY_SIZE(mv88e6390_serdes_hw_stats);
 }
 
-static int mv88e6390_serdes_enable_checker(struct mv88e6xxx_chip *chip, u8 lane)
+static int mv88e6390_serdes_enable_checker(struct mv88e6xxx_chip *chip, int lane)
 {
 	u16 reg;
 	int err;
@@ -665,7 +665,7 @@ static int mv88e6390_serdes_enable_checker(struct mv88e6xxx_chip *chip, u8 lane)
 				      MV88E6390_PG_CONTROL, reg);
 }
 
-int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
+int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
 			   bool up)
 {
 	u8 cmode = chip->ports[port].cmode;
@@ -690,7 +690,7 @@ int mv88e6390_serdes_power(struct mv88e6xxx_chip *chip, int port, u8 lane,
 }
 
 int mv88e6390_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
-				u8 lane, unsigned int mode,
+				int lane, unsigned int mode,
 				phy_interface_t interface,
 				const unsigned long *advertise)
 {
@@ -749,7 +749,7 @@ int mv88e6390_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 }
 
 static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *chip,
-	int port, u8 lane, struct phylink_link_state *state)
+	int port, int lane, struct phylink_link_state *state)
 {
 	u16 lpa, status;
 	int err;
@@ -772,7 +772,7 @@ static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *chip,
 }
 
 static int mv88e6390_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
-	int port, u8 lane, struct phylink_link_state *state)
+	int port, int lane, struct phylink_link_state *state)
 {
 	u16 status;
 	int err;
@@ -792,7 +792,7 @@ static int mv88e6390_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
 }
 
 int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
-				   u8 lane, struct phylink_link_state *state)
+				   int lane, struct phylink_link_state *state)
 {
 	switch (state->interface) {
 	case PHY_INTERFACE_MODE_SGMII:
@@ -811,7 +811,7 @@ int mv88e6390_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 }
 
 int mv88e6390_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
-				    u8 lane)
+				    int lane)
 {
 	u16 bmcr;
 	int err;
@@ -827,7 +827,7 @@ int mv88e6390_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
 }
 
 int mv88e6390_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
-				 u8 lane, int speed, int duplex)
+				 int lane, int speed, int duplex)
 {
 	u16 val, bmcr;
 	int err;
@@ -861,7 +861,7 @@ int mv88e6390_serdes_pcs_link_up(struct mv88e6xxx_chip *chip, int port,
 }
 
 static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
-					    int port, u8 lane)
+					    int port, int lane)
 {
 	u16 bmsr;
 	int err;
@@ -878,7 +878,7 @@ static void mv88e6390_serdes_irq_link_sgmii(struct mv88e6xxx_chip *chip,
 }
 
 static int mv88e6390_serdes_irq_enable_sgmii(struct mv88e6xxx_chip *chip,
-					     u8 lane, bool enable)
+					     int lane, bool enable)
 {
 	u16 val = 0;
 
@@ -890,7 +890,7 @@ static int mv88e6390_serdes_irq_enable_sgmii(struct mv88e6xxx_chip *chip,
 				      MV88E6390_SGMII_INT_ENABLE, val);
 }
 
-int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
+int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, int lane,
 				bool enable)
 {
 	u8 cmode = chip->ports[port].cmode;
@@ -906,7 +906,7 @@ int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
 }
 
 static int mv88e6390_serdes_irq_status_sgmii(struct mv88e6xxx_chip *chip,
-					     u8 lane, u16 *status)
+					     int lane, u16 *status)
 {
 	int err;
 
@@ -917,7 +917,7 @@ static int mv88e6390_serdes_irq_status_sgmii(struct mv88e6xxx_chip *chip,
 }
 
 irqreturn_t mv88e6390_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
-					u8 lane)
+					int lane)
 {
 	u8 cmode = chip->ports[port].cmode;
 	irqreturn_t ret = IRQ_NONE;
@@ -976,7 +976,7 @@ static const u16 mv88e6390_serdes_regs[] = {
 
 int mv88e6390_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port)
 {
-	if (mv88e6xxx_serdes_get_lane(chip, port) == 0)
+	if (mv88e6xxx_serdes_get_lane(chip, port) < 0)
 		return 0;
 
 	return ARRAY_SIZE(mv88e6390_serdes_regs) * sizeof(u16);
@@ -990,7 +990,7 @@ void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p)
 	int i;
 
 	lane = mv88e6xxx_serdes_get_lane(chip, port);
-	if (lane == 0)
+	if (lane < 0)
 		return;
 
 	for (i = 0 ; i < ARRAY_SIZE(mv88e6390_serdes_regs); i++) {
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.h b/drivers/net/dsa/mv88e6xxx/serdes.h
index 14315f26228a..ed3181e82da9 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.h
+++ b/drivers/net/dsa/mv88e6xxx/serdes.h
@@ -73,46 +73,46 @@
 #define MV88E6390_PG_CONTROL		0xf010
 #define MV88E6390_PG_CONTROL_ENABLE_PC		BIT(0)
 
-u8 mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
-u8 mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
-u8 mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
-u8 mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
+int mv88e6341_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
+int mv88e6352_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
+int mv88e6390_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
+int mv88e6390x_serdes_get_lane(struct mv88e6xxx_chip *chip, int port);
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
-int mv88e6352_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
+int mv88e6352_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, int lane,
 				bool enable);
-int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, u8 lane,
+int mv88e6390_serdes_irq_enable(struct mv88e6xxx_chip *chip, int port, int lane,
 				bool enable);
 irqreturn_t mv88e6352_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
-					u8 lane);
+					int lane);
 irqreturn_t mv88e6390_serdes_irq_status(struct mv88e6xxx_chip *chip, int port,
-					u8 lane);
+					int lane);
 int mv88e6352_serdes_get_sset_count(struct mv88e6xxx_chip *chip, int port);
 int mv88e6352_serdes_get_strings(struct mv88e6xxx_chip *chip,
 				 int port, uint8_t *data);
@@ -129,18 +129,18 @@ void mv88e6352_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p);
 int mv88e6390_serdes_get_regs_len(struct mv88e6xxx_chip *chip, int port);
 void mv88e6390_serdes_get_regs(struct mv88e6xxx_chip *chip, int port, void *_p);
 
-/* Return the (first) SERDES lane address a port is using, 0 otherwise. */
-static inline u8 mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
-					   int port)
+/* Return the (first) SERDES lane address a port is using, -errno otherwise. */
+static inline int mv88e6xxx_serdes_get_lane(struct mv88e6xxx_chip *chip,
+						int port)
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
@@ -149,7 +149,7 @@ static inline int mv88e6xxx_serdes_power_up(struct mv88e6xxx_chip *chip,
 }
 
 static inline int mv88e6xxx_serdes_power_down(struct mv88e6xxx_chip *chip,
-					      int port, u8 lane)
+					      int port, int lane)
 {
 	if (!chip->info->ops->serdes_power)
 		return -EOPNOTSUPP;
@@ -167,7 +167,7 @@ mv88e6xxx_serdes_irq_mapping(struct mv88e6xxx_chip *chip, int port)
 }
 
 static inline int mv88e6xxx_serdes_irq_enable(struct mv88e6xxx_chip *chip,
-					      int port, u8 lane)
+					      int port, int lane)
 {
 	if (!chip->info->ops->serdes_irq_enable)
 		return -EOPNOTSUPP;
@@ -176,7 +176,7 @@ static inline int mv88e6xxx_serdes_irq_enable(struct mv88e6xxx_chip *chip,
 }
 
 static inline int mv88e6xxx_serdes_irq_disable(struct mv88e6xxx_chip *chip,
-					       int port, u8 lane)
+					       int port, int lane)
 {
 	if (!chip->info->ops->serdes_irq_enable)
 		return -EOPNOTSUPP;
@@ -185,7 +185,7 @@ static inline int mv88e6xxx_serdes_irq_disable(struct mv88e6xxx_chip *chip,
 }
 
 static inline irqreturn_t
-mv88e6xxx_serdes_irq_status(struct mv88e6xxx_chip *chip, int port, u8 lane)
+mv88e6xxx_serdes_irq_status(struct mv88e6xxx_chip *chip, int port, int lane)
 {
 	if (!chip->info->ops->serdes_irq_status)
 		return IRQ_NONE;
-- 
2.17.1

