Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2DF25B23DD
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 18:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbiIHQtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 12:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiIHQtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 12:49:00 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10041.outbound.protection.outlook.com [40.107.1.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717761228C2;
        Thu,  8 Sep 2022 09:48:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KxKVcsT23gteEQ9HK10Xow6B6QwHAmGpd5wGjNJSXPIPA2VdmTUs7tfoDNzQpYYZPTukuAVF4XZi3A/6A/+0i2OtkVt4oefPz3lR5RctbMszK+p5DA0fatHBenN4YxEfNlhQBWxcWKcnNKdnP7UI9UOYP2Fz0zYNUlTKL0FUyQ+M6r2k8OjIRWLUpxmtX7Hweo0nG+5Dkguq4TxOMLe+WanxboxmBx2CpqyhsKFzxllzh0lvV2/WVa/viFAGKfMzXFh5vbxLk5+gGEif0HmzlPj7VYMFQLijYCknYjiyYxOyFlTsLc4wcraStKKJBHnq40kLCgoPE1XojxNSy1Ndaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mAiffZNoFypRNZQiiwDKuiuWoLk+o4WU7vrbWEc6DPQ=;
 b=nwpKKp8HDiOAKTbbrwTwUWA6ysAjKrvBcaO892Uq53iKttRYs9rwkuoUK1mSUPV1u7y60d2cjcnhBXh/Vxldno1SNWU1DpkdsNLrjXqiepueNdL7mYw661SUwMCO8b0ooTBY0XX0E1gESzeFTsM73jySuNmSMSR6N8Ni16vKT9pV9KFJ0JByQ49ONwpPKFalWkYGgMv1siPtfxsPAGhIXr3nUAcRq+tJUxsZPVv1oWG4uw97I0DHVHnXfn1z3oqx5TLdEaYcpPVkGVBYAsH3k/AWJnUYcwa9IO6gX86m+jR6WV2a3WBXPeUfA+Lr41PTD8TjjcwLofcxA1XDPh5zfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mAiffZNoFypRNZQiiwDKuiuWoLk+o4WU7vrbWEc6DPQ=;
 b=MRQXl3HeBlL4MXijqdankbe2nA+K2w2jzqQbR8IP6LlWZARNk/U9rdyHEhJTMC6leEAHjAB8xzu3fqHh6n/vz2HMKXQISduBj/Y3tNwZz4VABZdXa+qgESww7I04DxIkcR4M6Be5/kGeQfq6Zd1fEeHYjhpbkVoEQCq0RsNxrwc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5052.eurprd04.prod.outlook.com (2603:10a6:10:1b::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Thu, 8 Sep
 2022 16:48:46 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.017; Thu, 8 Sep 2022
 16:48:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 05/14] net: mscc: ocelot: sort Makefile files alphabetically
Date:   Thu,  8 Sep 2022 19:48:07 +0300
Message-Id: <20220908164816.3576795-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
References: <20220908164816.3576795-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::19)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0a5f23e-f74a-4b3e-0b7d-08da91b9f74b
X-MS-TrafficTypeDiagnostic: DB7PR04MB5052:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C1VnaK5HkfiiCydOd+uTfBnHETgebyp2IePgBZ5DZiTXP32eYhJcGhtzSkYS5XeG3MTihQH4SLsmtAfskOx65KAOypk94W4V3M0dKtDFusFySuzLcFej7JYLGMt8EP0wJ0/AZ0aBTTsQgsdSZ7wAz2Otxr0Mc6PdlsfOkrYC7hqPsFCgux7g9VQr4WfCETIfIuDzHrk6aFN6Uhk2XumE2Q6O3lpOcrjI95UbM3GIJvXEqSsKgJTBEFadxU0b9a9M3eM2Al98D8yQzfV3z95PJ5TGxQ2ivL8SppIbM//w429Gpmlu6zwPrQBW9EAfHHZrIFrujm2evdVgLxrKUxuEF6Bg1Zt0Cm0yzGPWaSAby8Lym81hvDb8hO/yR6whCY8id6mkbQmHaOuzC6054xgUsZLtP31fu7/RJwOV8MYL7oW7ODsx0zjmGjXmJQeYgygdQcIW92rxfzliVyZYKPdRilO864DfMqQcIZM5l4Q/lY+QCfpUczckGGoITS8lGwMnFOXoS1k2zNg7VvlBCa0XJeDjLJ+sb1E/lJDtp6JBx+V+6aoTGZGaaYyYZXGUTgS3GUsCVXa0uAgOL5ToLDO5E3J4KCoxwsGZ6N3UjJvjU2PFQ2u8vSTDopZFPoF/V7kXLsc8m50ycd3YAnFj/RK2K4+bz7Xkaj3rtjl87r8eIDDq41sbVHKrSzTQeF8224rYyIdRtu0uerOLmIOFXVFpCmCYtTDMaNwXgqYeZ84zhGR6MQDKZ5M1RWba5TXNHj7UF89jKn0NpHPs7Exzymg/EQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(346002)(366004)(376002)(38350700002)(8676002)(66476007)(66946007)(2616005)(6486002)(186003)(66556008)(38100700002)(36756003)(1076003)(4326008)(478600001)(83380400001)(8936002)(2906002)(5660300002)(44832011)(7416002)(4744005)(52116002)(41300700001)(6666004)(6506007)(6916009)(26005)(54906003)(6512007)(86362001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VaCLgWda9wSNVEtf7qGQ3UuvG0BHt5bEE1JtnL4rx7lu/vFoC73b4hFBrojd?=
 =?us-ascii?Q?1/lnn+Rz0gF1HwOGsIFcdE63JRk0x/OrlDfwmdIuuI2lPJdbfJXiuDAss19c?=
 =?us-ascii?Q?KfAnPQJ2dRh1bFUAQcnxvSykH2WIO5zyhm4zJUFHupYOHasvOipiJaQGigwc?=
 =?us-ascii?Q?e1ym/EADj00yqBxjKkFrM5tACbcVt07HHLIiGN7n5OVGVjGomm3fDG8RXbH9?=
 =?us-ascii?Q?T5DZwQxon+wyUV1xwHuZE/zhlR0V171vRWUkpTUnoYIPXk/bruepeTCPIG0X?=
 =?us-ascii?Q?t2+JPE6x0aRaOo7Z6m5xroXYQzheeR0pCsflli95EcgHoiGM3ttlqLFu7GWC?=
 =?us-ascii?Q?Tc69wN75x6V4A/5Ac0jT+1JZ6R6G2wpeNpSqQi7ekFC4FbPqpZOYKGlS342N?=
 =?us-ascii?Q?e7WX117RbttAzERk9zK0zt7hhllBvH0pk+W6U3Wq2bzc/RNv8NqabeNLfUTZ?=
 =?us-ascii?Q?mlb15o4l+kylTIciRivrIQqMeLqHTrBJDzJPaURHHl3CD1DI2xjPpbDGkXD8?=
 =?us-ascii?Q?klpuuPltGBbeIXBUocfZhe0JxKOF0Pzgywx6VhWTAMOPQBNWTnjBJfqq0l0l?=
 =?us-ascii?Q?mDJV5cpEibyYqI2/uPsTqQVuhTwssSalzANDLXs+gzcCKdWvIk7pACTl7W9q?=
 =?us-ascii?Q?OTg1mYAWEjJIOzvDVGKzRyBB3mDbYxjSOgAL5Ss5XbLjBiNuHkoOF7BRUOnu?=
 =?us-ascii?Q?NZdYIJBXAXeoIBcFQrXsydjcS0aHUG1m/hvMaXb9HEkCCjuXa1Ja2ode71p9?=
 =?us-ascii?Q?6xvLEL61gE58CEU5gGlMswvh4CAqCH2QjcM0xb1lzeyLpBLgH5kMCvk4M8+K?=
 =?us-ascii?Q?uHR/Z9KK8thrmqE/rfwsv+diPhuYJkfZyEQkiUgeugmrWh7pWgj9jup5GjJm?=
 =?us-ascii?Q?t6exIS/mwxMfl3HKSYrQe7Tyua1ZGHI5gyyDPEbyw2hclMnCcwBzJh8P5JNi?=
 =?us-ascii?Q?B/2rFCI22WUS7Rnx51l5KoKSGrJoTxcfImW7r7CXtNqH7y3iLw9wtkZyjzb/?=
 =?us-ascii?Q?yXQtTa12leLXRxqz1XFqKvbj4HKWwAq6+PqSq4XANhdHrGWwlmAMK0EBdvNU?=
 =?us-ascii?Q?Lqgp0o6RzIIcthbLoh2a3qRQDvOowVEo/y3O+/kJUtKwAwMUCCQUFxopmMJd?=
 =?us-ascii?Q?a1aDzp0duLWDtpbOv7vt0do0qNkLMb3wX4hDL/LY61+PNbCr1ORkTwB7qU6h?=
 =?us-ascii?Q?e69mIM4RcV/VfgFBu0ue0tbpSL+5rgltV1n2WUcZvoZkjI48N1UbvumnKFeu?=
 =?us-ascii?Q?hejhKj5cDoxb/ODC05EeXOXiy79obk6GDmn4xlnySGKB1SdGqkmvU/CSP9pk?=
 =?us-ascii?Q?NoBX8aUyYeZ/TCMHRtj/7T0UX3Mhu/2IsRQ144w59n7NBM+4LKSZeFPua44O?=
 =?us-ascii?Q?gmZhZldMnlg17DB/K/6YsNexhSfvC0LzKqHM499idVFPddO0AEUQHW8VkFyt?=
 =?us-ascii?Q?h3zXGnKtBRFsk338Trpsa1VryWagUEislPSpnm27iE2wBqwQ2yDm8HpL9NBt?=
 =?us-ascii?Q?25oLEE1imhEqsO3o6V0LVPVnktktmH2YSkisi8mJ8hgttmr3QmvFf6FL8HEq?=
 =?us-ascii?Q?OUOdqWUeL0ygwra7OlanxfvPTEzRN9nFFY4jbDC0tjU8ZN/BTlW3woPLTRQQ?=
 =?us-ascii?Q?Pw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0a5f23e-f74a-4b3e-0b7d-08da91b9f74b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 16:48:33.2089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w1VHRJluCEcJ/vIFPpvjfgACKHLwOSbpCtqwfyR8XIV5/NP3T9fdtnqC4p3kivgfcLveSnXtO73LSTr57U3dOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5052
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a clear ordering of the files used to compile the switch lib and
the switchdev driver.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/Makefile | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
index 41b34a509308..e8427d3b41e4 100644
--- a/drivers/net/ethernet/mscc/Makefile
+++ b/drivers/net/ethernet/mscc/Makefile
@@ -2,16 +2,16 @@
 obj-$(CONFIG_MSCC_OCELOT_SWITCH_LIB) += mscc_ocelot_switch_lib.o
 mscc_ocelot_switch_lib-y := \
 	ocelot.o \
+	ocelot_devlink.o \
+	ocelot_flower.o \
 	ocelot_io.o \
 	ocelot_police.o \
-	ocelot_vcap.o \
-	ocelot_flower.o \
 	ocelot_ptp.o \
-	ocelot_devlink.o \
+	ocelot_vcap.o \
 	vsc7514_regs.o
 mscc_ocelot_switch_lib-$(CONFIG_BRIDGE_MRP) += ocelot_mrp.o
 obj-$(CONFIG_MSCC_OCELOT_SWITCH) += mscc_ocelot.o
 mscc_ocelot-y := \
 	ocelot_fdma.o \
-	ocelot_vsc7514.o \
-	ocelot_net.o
+	ocelot_net.o \
+	ocelot_vsc7514.o
-- 
2.34.1

