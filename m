Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D464E6BF13A
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 19:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjCQS4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 14:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbjCQSzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 14:55:47 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DE1CA7BB;
        Fri, 17 Mar 2023 11:55:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fO5t4aDvwJA3Bf0AQ1LRifhtcJFlTFN/cIU3eGMxMhkQ+S6CHuz+B2z9k8w7c+4+0LR2cYbBiJZDemPDlg+sYhpt6+yBCn+X7kOZ/mouH61ME9gt6dYRO/Xhz3FXScuALlV5EP0Z/p37fB3HKi24lOWNqCa6SNe7FTptrHrGX/jjfbJJ0yolyVHBcyja5UQpY5PGitI8/JGabEwoEbvW7oDNJyPd2WvdPZQKpFRl9mSwNhgdHf0ckTRz3MKxTweDIY5aZtaWn8shjyJk2xTCpiWgnOTuXcFr4RdbJabnymjsuUvlq8+B/xkpJoKjDCL4wrDJ0tzhlE3Ac6giVveDgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F+M2V038LGiL9tMIiom4sHLQO6ssagWlXVlL/2pPH9k=;
 b=XW7PTWfa2DyGECpWlp6R2fNd/PDwrcoZIh7pCKY/igwA4RoEX2UcvebmcSOzazHsQLXwuAuFQTn+v+lFl3yXhSg43ZYUpVKhKdzyVAgQtJmiti5uQaklX0rHCnAmvSf2QwnOHJ2aLz0yNGWfJMscAQWNY828TZPENqrjtHxR6VqLPRO9i+DUAtpGjCA3l7v3ZwiQPuud32bP2rdV67Fgg3qU0x/XehB9iVqbgMEFvarBKCuRKtJMz0vzuh269bRiv9fmfKm//hMW5g/RN9BhILoEU8fGBeP6ti2LR7lMBV8cM+yF99ROGoTA3bNRszDzfY2iTlGhuTa5Wi0z6ePJ8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F+M2V038LGiL9tMIiom4sHLQO6ssagWlXVlL/2pPH9k=;
 b=B0S1Ta2o7d6v2RM4IFOl0SswL1cXaycP2vqgg0/zOBgXczBhKv3Cz/X9kVOQ0n1F7l8dhRJ2/GPxIWuNj99hZNChFe+bM69AO5Q/Ayr3dPSC/RUk+RgmxKJEL5gPrMtOnzjAykt9WPxulGeAnIkXFABuMeA57KSY7aFdhsscr2M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by CH0PR10MB5289.namprd10.prod.outlook.com
 (2603:10b6:610:d8::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.35; Fri, 17 Mar
 2023 18:54:40 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 18:54:40 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: [PATCH v2 net-next 9/9] net: dsa: ocelot: add support for external phys
Date:   Fri, 17 Mar 2023 11:54:15 -0700
Message-Id: <20230317185415.2000564-10-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230317185415.2000564-1-colin.foster@in-advantage.com>
References: <20230317185415.2000564-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0025.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::38) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|CH0PR10MB5289:EE_
X-MS-Office365-Filtering-Correlation-Id: 322f3f0c-c9f7-4d37-1403-08db2719106d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: popmzIip9UHGPZJE7aV5zNB211ILC9egvT4AxDPMHTzhaEz1w5KDhFEzFczid/98G1qo1EvCZP0BBfonCSOGNsrFhmyNz1KpsDnxmC68nTewC2aeksZrMLZuUlc0aSCAnYuRgH3He9XLX/i2Aws44/4FRA9nO7HIeOq+lwejvx60FMIw5Su0/xRAi+dQEQb6s9ddCf8NSNUWln9XVfqO9auTY0z2AW/8/8cRomr078sxjqFcF8vh75TmGeIVbusxe5LmCd3hjVWpZCybwD6lVS2jwCVsM7zh/gehIlV1C6hUMlOKjbkZs/WPQXnGhqJmPkahZQN1nXoQrNnx+BT+FdADREzDs9VDyAne2orLc26NxvbdskKD93d5cWdYsMtICzqv+q/KVmrntWdL1QzFTJFAmQKJHvb2ptfES9OkOVDXmRnJFq3Mqao1AQZtLZqXrrl/D9yX8JlDTZlwg9TNUMgFfjMMb7bIgdhSAHAi1KL61BDTd/a2w0ireo8Z4JbfErT9dHLJDDy7ua5mw3C93sZxw2o5wH/jC+Gx7Qz+un459oesch9ImTi6DsvMYol1eVWUGUmDhZFMBDcGLxU9LH4D5LdogJm5hUmyMF2+d/FkPmMIvWyQsEgTzil4oUNs7Jrt24cnSnnsG4Ibc+Haa39+eA7jrjF8TkA2xPThTptBxxWMvbPwhgA4iyLJ/kWsCH929EZcporFrXZVihDVWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(366004)(376002)(136003)(39840400004)(451199018)(44832011)(41300700001)(8936002)(5660300002)(2906002)(7416002)(86362001)(36756003)(38100700002)(38350700002)(478600001)(52116002)(8676002)(6666004)(66946007)(6486002)(66556008)(66476007)(1076003)(4326008)(83380400001)(54906003)(316002)(6506007)(26005)(2616005)(6512007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lQat/2bnXgHYUWkYE6KZO7xPtZUII3ODLLmjIp8a5Uq0YaGEqadA1gxUqBof?=
 =?us-ascii?Q?nwBhnP35U8iLQfRwKXiBBxqtt6/DI17XaOtt4YBbLLuaxnzSTFb3qgDU7dCZ?=
 =?us-ascii?Q?tR6VHdbcIKtbNCnA0LGEhvdt9E2PF8UANCHf3uGN+H/FKxAuX2bw2wC5Hi/0?=
 =?us-ascii?Q?7THuYmOqZAcVC9L8sI1pAI0lj41vhRG19rHfTpiHeUfAJix8H6XuGUivKYKm?=
 =?us-ascii?Q?+38aT2ushpXokoF5CIDHsBs5AfLbjC9tdtDPxgtq3CakRxgU3M2VPpPD7eMx?=
 =?us-ascii?Q?JoNx92WORTfFTW6q7kuSkhsUzpgrxlyIkefHBw0w4L285xlPKLX+QZbvxfCO?=
 =?us-ascii?Q?WnyDhgPdCloVDwJbkRXA5vF1bzmgU2zdexo4SJEjurar/mh8O8rTAJV/jCjo?=
 =?us-ascii?Q?n7d3vsN1CMZ0GjzURWIJI0GesG75Hjawl3QQvgwWKAXS/agmVRMztCycI2wA?=
 =?us-ascii?Q?gqtAo+DEyGy2SAYzTkv0oXGqRbFTt8oTHLQ7YpGcgsVymh5jLFe0aQtsWlDt?=
 =?us-ascii?Q?eDtlEHzOJ9rhriP21amlF2P7dB7Y6NwJUSG+BbcaMBWvrrna+33kx9UWaxrH?=
 =?us-ascii?Q?3iLSlG/yJiYel8vy4Kq543J+CmxwaAVFRyLHZNQY7aqRewhshVI2GAAxmuvX?=
 =?us-ascii?Q?KOLOS8nFBsTZi7riAfo3QXdk1tE8JJsUnAMKNCcjetQEKRjXlr4wr5r5Od2O?=
 =?us-ascii?Q?zdsu/p4FIFLKFEGy6SvgwWt3HzLG4TGbs+dd9xFpKgABSbBhm/Mb9U5u1k6J?=
 =?us-ascii?Q?qhlmsrNVyJylowvDLZz14vAkx9FHvLu/iyoAXsMlKu0Qp67s+EqH8eYi4zRU?=
 =?us-ascii?Q?0pZ1Y2t0Er46VXXFf9SaBHonHThQnrQgMGFBxMvP7IrTtASAE0DSsVl++T7q?=
 =?us-ascii?Q?wP9uer+3itWRQEv0k8WaNwWZeMqxnMHw50LfuRW0zN6RgC6rOO0CnHFgDdJw?=
 =?us-ascii?Q?5NR9HdiJOKtPcMBGBEsWJ6E3sIDDgldMtJWtQ07FqDtULLUmAQDwIBeEx20I?=
 =?us-ascii?Q?1+L7SnoClzYNev9zgJ7FU1Gagl0vGha6eJgJ9gcndxqNn3Zb+kFZ/SdTzn5Y?=
 =?us-ascii?Q?VeRSiN8AHizRl1N+lzV6vzKqfaOmTMBa0DyQ2lGizDHNvEDr4LUmFhw+JHNr?=
 =?us-ascii?Q?Ds1++S70JhbvRHqcsIok1eQUXnTP4iX4lYvKduUnPSBxfxUSxNMG4JbmiHw4?=
 =?us-ascii?Q?xW6E0FCSq1A6J2Nu3utV+vISVNtIjnssSyJCRlxeSsLM//iwIKnp7QOFh5Z9?=
 =?us-ascii?Q?AMUZKJ7p8nitAx2yb6m/9b3VupZip6RsTuMusxenxHIP8cJOi4kCiPlGdbD2?=
 =?us-ascii?Q?Rh7wakjtJ+wsqu/D5kp7Oc7/fp438Stzr4Oymnpy1bjvLqHa0bYGJeqhqhJV?=
 =?us-ascii?Q?m+rIpTJ2TQPqGRm2mqA6x3+KaVkKm+Pl6clUBOacvw1p4UBoehbGK1HYYUrb?=
 =?us-ascii?Q?8VAGsc8cXybuvrarEDHvx/U/Oz38rgMYoJaNq0vfeL/cuhw7dDegXVDb8Z03?=
 =?us-ascii?Q?IaKf3MPHH7ngCpbUqyhohhktgT/c8fX9B/ocgDXjGXKL2CpJavMGlKIGrUsQ?=
 =?us-ascii?Q?U7Vd6MDFgNJchMtJtD5Ts6D8pAGiTKhiJy77Zb0Zf7IKJaNUl8eWLEWrl1FQ?=
 =?us-ascii?Q?t8OQ4N2LP6YV4zLucZgbODo=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 322f3f0c-c9f7-4d37-1403-08db2719106d
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2023 18:54:40.8181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mMpoDZSqM34l4CabOJMxVD9+kZDJFYvj5kwS4iADXr6ZH6yn3HADLYIQXzPfXbAu30GbMXXpbW00+7u0V7ohbJi2ogrcubyM42RMySuzMvU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5289
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VSC7512 has four ports with internal phys that are already supported.
There are additional ports that can be configured to work with external
phys.

Add support for these additional ethernet ports.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v1 -> v2
    * Basically a new patch. V1 was off base, and the already
      existing ocelot routines add all the needed functionality.

---
 drivers/net/dsa/ocelot/ocelot_ext.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/ocelot/ocelot_ext.c b/drivers/net/dsa/ocelot/ocelot_ext.c
index 228737a32080..c29bee5a5c48 100644
--- a/drivers/net/dsa/ocelot/ocelot_ext.c
+++ b/drivers/net/dsa/ocelot/ocelot_ext.c
@@ -20,13 +20,13 @@ static const u32 vsc7512_port_modes[VSC7514_NUM_PORTS] = {
 	OCELOT_PORT_MODE_INTERNAL,
 	OCELOT_PORT_MODE_INTERNAL,
 	OCELOT_PORT_MODE_INTERNAL,
-	OCELOT_PORT_MODE_NONE,
-	OCELOT_PORT_MODE_NONE,
-	OCELOT_PORT_MODE_NONE,
-	OCELOT_PORT_MODE_NONE,
-	OCELOT_PORT_MODE_NONE,
-	OCELOT_PORT_MODE_NONE,
-	OCELOT_PORT_MODE_NONE,
+	OCELOT_PORT_MODE_SERDES,
+	OCELOT_PORT_MODE_SERDES,
+	OCELOT_PORT_MODE_SERDES,
+	OCELOT_PORT_MODE_SERDES,
+	OCELOT_PORT_MODE_SERDES,
+	OCELOT_PORT_MODE_SGMII,
+	OCELOT_PORT_MODE_SERDES,
 };
 
 static const struct ocelot_ops ocelot_ext_ops = {
@@ -59,6 +59,8 @@ static const struct felix_info vsc7512_info = {
 	.num_ports			= VSC7514_NUM_PORTS,
 	.num_tx_queues			= OCELOT_NUM_TC,
 	.port_modes			= vsc7512_port_modes,
+	.phylink_mac_config		= ocelot_phylink_mac_config,
+	.configure_serdes		= ocelot_port_configure_serdes,
 };
 
 static int ocelot_ext_probe(struct platform_device *pdev)
-- 
2.25.1

