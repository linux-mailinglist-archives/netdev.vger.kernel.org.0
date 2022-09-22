Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF195E59ED
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 06:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiIVEDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 00:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbiIVECp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 00:02:45 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2106.outbound.protection.outlook.com [40.107.223.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90532ABD77;
        Wed, 21 Sep 2022 21:01:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CBYzmxA2tDnVmpjl+n/bIzH0kWzLc4dOy0Ewlfp9FeZK/7qyKRf+4BdTHjH6H8ntlPSsSpEw2Qs4JxgNv2SgSwASDS2XgEORZY2cseIwP0qIHBAxrUcVo2ONNFY7FrfQyRXvebHdT3ghxUDxMmTtJVAkOLyDSxmzUL3g/185giNChyhxfe2Q8EBXzlGpNWX62Motqi13oWDVWHjtzPYdGAEf9gFF/C9eMZ3hFQ/+CuLRqCG+/bg55aBUvPzrROEUqQ1FMHh1KMQCuM0PsbcWefopeoP3mNNWwurUJYzbTf5Ro+xqxDDm2eMArBdV/FxdUJA45Uyn/3T6TAxNJSZLhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gbcnFXvawu7TBipigyeUhP3Q1xoSGhvv26KUsCIXP9w=;
 b=eP/TsOzG6NcDcrfPm6fl+lAY9pEArA1pIyJgOps2m0WR8o96IPRrZWNpYWjvgeCoYAYvGsVvpQmNGe0kflV9BJUc9uCyn3p7Ul7yPIp/lFJi4dehRx6WayOsQtVm9H8m5PEyzBgxDwl37F+0l3ZAbDcNrOvY08RmnKzSohQIWxuGX6Adc1XGudjHO37Ns0PWcMBEj3+bWiaJTNKFLiT6BBNUlzv+0IqJu7IcWAKZdQeDXcwux+RTE25zcoQOYV6CuXiBKxmGdGBBLNmPV955WVzvGUHyHEGCqYoOZqxGZZBWxKRj/o81BPXNOdZd73wzVHCCk8osjpMT0sYYnyPJmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gbcnFXvawu7TBipigyeUhP3Q1xoSGhvv26KUsCIXP9w=;
 b=NjvUsp+TcbjMiV/MBjmS5VSStMgQYXet+vHmuy/OIMWZ90meFYcQChkPQjEiRCsG37QqZ1Vvv8BJw94BlzR1OgQGwsQnU3clM7zkbVLjkwmcmsq1xePqLkgUUQcZe4u7P0cmem1Fe5td4rkO9LWjpPja3t7k/1rxmBTffoW9Q4I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com (2603:10b6:4:2d::31)
 by SA2PR10MB4412.namprd10.prod.outlook.com (2603:10b6:806:117::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.16; Thu, 22 Sep
 2022 04:01:36 +0000
Received: from DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e]) by DM5PR1001MB2345.namprd10.prod.outlook.com
 ([fe80::b594:405e:50f0:468e%5]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 04:01:36 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 net-next 11/14] mfd: ocelot: add regmaps for ocelot_ext
Date:   Wed, 21 Sep 2022 21:00:59 -0700
Message-Id: <20220922040102.1554459-12-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922040102.1554459-1-colin.foster@in-advantage.com>
References: <20220922040102.1554459-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To DM5PR1001MB2345.namprd10.prod.outlook.com
 (2603:10b6:4:2d::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2345:EE_|SA2PR10MB4412:EE_
X-MS-Office365-Filtering-Correlation-Id: e2ee67d6-5b1a-4509-3587-08da9c4f24e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FVGXIeXMZJn63RY3+tHPZtOhkb3RbrJFdyBXzApeI4Bb3cxOsLgdXf8n/uvHuEkPJVKo3P4XHw6MqP1fWs7mRyl6O7h7/FtaBjpdwMnto39mUNqxv+ZOHXq2BumAzN+Jo00J7l/S2nIXT6ABPUMihij14fJZzWt3HczVQKYiKHvMAFOmiXGyhENP209cmJiKk52oedzUsDAwquIwknQnZxTHUxqZ2kxubFr/eed4d14JU+ee5781YLe2f7hVv+oIZ9HfY3VWoQ0FKS9Qu7py7Rxca6jrOVVDU++aeZqZ4EtUGOwkBp1O+QpdS/EZpBH8RoHmCgmFO8X3haf+52XgHJED2wasxRtiNfRCbvd9juX7xQNlFt9KBgbc2brTlSw+GF/lEAoxvLBLpoL26wIgrnY0Ehwm0vbJX1CHHbSM1bHyUO2BSboYxJPH9ZFhIWlrAYIf3M85KUD2E+n4vSjL5s+Muq8t8bDWkGd2lKGMLQg4yPpmXgHZipB0cKrAKemhAIoocAZzxt8qG94JoPAT7W7b6Ein8QusWeuY/iCKnK/YSDJbJskdsgAVp3o9EoqiU9uCF41LoaDKh3SGV9SiDoJHuMpf3qGBpchiVl13j9YXjyXFaePivN9zXZMEdInK1RxCsGNugsNCby+fL3B1Fg7QLFBM0giYu0T+aqNH4VVubviWHz//UYDf7v1/B3Z1ZRI30uj0xPCiVm8Z9yW14iyjrJY/yXOIdNjlvwSRKXLAzw+PtQCEfrtz9Cl9RUsphMYnYbD7QkRQuCWYstVZFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1001MB2345.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(396003)(346002)(136003)(39830400003)(451199015)(36756003)(6506007)(6666004)(52116002)(6512007)(26005)(86362001)(66476007)(66556008)(54906003)(4326008)(66946007)(41300700001)(8676002)(6486002)(38350700002)(38100700002)(2616005)(186003)(478600001)(1076003)(2906002)(316002)(5660300002)(7416002)(44832011)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U68AKxuW1oqG2eIg5wMKEAWLTCBU8vfXwq/PODQb763m1hpK9qYtjgVMY2u2?=
 =?us-ascii?Q?uzpDZSbN4DOgcB4S2hOsOouOmUeBVLHYf7MI1DV6wwXk0edLFPkhoOpS8nGW?=
 =?us-ascii?Q?uq7Kn7NmOMUVlTejk88VZy7/Ju+frY4g9H3dbbEGhvaTJZxh89lyF9d3OoO3?=
 =?us-ascii?Q?er/LxHMCpsIndyYIXcEavpvnxfWmBcQzfpsRIp5w7NxQatvoooVz8dA6P1N/?=
 =?us-ascii?Q?214eFAiwKjSjP16ONNTB/MH2NVA+BvuvirZ6FWmwtYxUEoCZFkNyGv5wPUWZ?=
 =?us-ascii?Q?a2marCFGFnvrHJA4IyNmbhiWPSha31n2qDBXgSXgkJXYSTnnGv0L/8c6OUNH?=
 =?us-ascii?Q?x7q2Yd3mesC+I7XoBlDjw8ZeoEHfmU8KOlSSZ2+xcDCuZqR3fMgvbDnx0T5Y?=
 =?us-ascii?Q?3aImicNckiEPtb5Z11QSjXrA9YTTuEnGCvgACc5jX7xUAVSd/eCuj3kwLk2+?=
 =?us-ascii?Q?hP+6beofu3+NK/qQmay1s9TuK/UQ9/4DalESCEfpOBP5MiTNmW0C/zd+cKxd?=
 =?us-ascii?Q?wi1rQuOzuDX1T/mOV9KhhMfPw/tvErvfTw1yYAYGwBTQVcxrEaFjAcCcFwEH?=
 =?us-ascii?Q?AsznnaT+a20we5PuXA6JogbzdG1FEqnn+DjOSUPARU9kH2QqAt8giPYkitXG?=
 =?us-ascii?Q?RWhWjpsdxezH2mBqTWYaXwOKynEQcahyd4ilEexZwkN4iI+fb4UwcmRq+oQh?=
 =?us-ascii?Q?M8euOlOJVib4wEoXhsMJbTX+8yu53LnztIUX60fldTpBZ4kt2dYt+jTZqZyn?=
 =?us-ascii?Q?+hikEIvTHtN/rvGO43ZoSttRSbT+3+AumNODqDVO8lhIEVP7jvVbPB251kjl?=
 =?us-ascii?Q?TnwocwjLd79mNefovuzQq48Qfu/F7ZeOy1hcCggPj3uxius6Wb9kUURYrOqU?=
 =?us-ascii?Q?1PWMuNzgpvWZ6hZ8IgdQsHKiJ4UO7sdW7wfszmG1r5zXbbGee+8/BTt/ibg2?=
 =?us-ascii?Q?dJxkFr4ozw9ckky5sGDZwwX0197fKWf9DL2aAHdAER7DVjCBaiCTPr0Ld+p/?=
 =?us-ascii?Q?LCobrx4KcBElp1l/AwXlxFSgxh1U/iIon2oyMwZ+Lcur8I707vQRiRVmH9l+?=
 =?us-ascii?Q?C1NPzAXffC1n1HCB5lISBJec/FoAfyYIrcZeNGIiJZtKM2EK5T4vmsjn0WUP?=
 =?us-ascii?Q?BkH9ZZvEy5pWq4S7yzdkubbUYEmUiYruk1f5aI2rgbz919MDZgA7exgISPXU?=
 =?us-ascii?Q?oRXT8zGuklYzebB+J6wGR/8/5lzqVWcn3lPB1wJapQvvA1Z2eB765ogPdEND?=
 =?us-ascii?Q?Y/HIIHv/aWV1ZWa7QEPXJQVVReFGO3d+5DkNgcuhkRVAJk+7KoHQyC0qYJ9t?=
 =?us-ascii?Q?0xcaD68aehN6Mwuz1OJ4+HhJKP3zITMKk2BYp6fjo/qUQKnvcnyBAa25BEIz?=
 =?us-ascii?Q?wKlHMpneVyMpSbmyQVUk55SfxsCmz9/IWztw9EuHbW9+eEU+lj2mGmmqNGhi?=
 =?us-ascii?Q?vDESjh26M9WILYNTgUvIjouvlRcpPPfzaH85PNs/wmOlwxiEg98ebIfDPmlo?=
 =?us-ascii?Q?ZnYIm/UGGrk0I2rnKtADuQUAzM6ecnfE/AtEOcuYuybA3/h3NLDymgtFRVrS?=
 =?us-ascii?Q?ihFukskW7ODWnLBhHI4iAMwJFNAp1hAGCddne4J3VZGVJqf9dJyW8oMyquC4?=
 =?us-ascii?Q?VL1tqpuAXEkWjJsg+OzJ84g=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2ee67d6-5b1a-4509-3587-08da9c4f24e0
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1001MB2345.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 04:01:36.2619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C/komwOJpYQYXnxlFjHWxSBVh7LZnGR93nvwUtSeBarN2IA6F1ppq+jAU1dvnPLFj1ytvQCsvrTTiUE/WWZ9vQhDuohniTxzYlcMjYba3wk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4412
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Ocelot switch core driver relies heavily on a fixed array of resources
for both ports and peripherals. This is in contrast to existing peripherals
- pinctrl for example - which have a one-to-one mapping of driver <>
resource. As such, these regmaps must be created differently so that
enumeration-based offsets are preserved.

Register the regmaps to the core MFD device unconditionally so they can be
referenced by the Ocelot switch / Felix DSA systems.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v2
    * Alignment of variables broken out to a separate patch
    * Structs now correctly use EXPORT_SYMBOL*
    * Logic moved and comments added to clear up conditionals around
      vsc7512_target_io_res[i].start

v1 from previous RFC:
    * New patch

---
 drivers/mfd/ocelot-core.c  | 87 ++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/ocelot.h |  5 +++
 2 files changed, 92 insertions(+)

diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
index 013e83173062..702555fbdcc5 100644
--- a/drivers/mfd/ocelot-core.c
+++ b/drivers/mfd/ocelot-core.c
@@ -45,6 +45,45 @@
 #define VSC7512_SIO_CTRL_RES_START	0x710700f8
 #define VSC7512_SIO_CTRL_RES_SIZE	0x00000100
 
+#define VSC7512_HSIO_RES_START		0x710d0000
+#define VSC7512_HSIO_RES_SIZE		0x00000128
+
+#define VSC7512_ANA_RES_START		0x71880000
+#define VSC7512_ANA_RES_SIZE		0x00010000
+
+#define VSC7512_QS_RES_START		0x71080000
+#define VSC7512_QS_RES_SIZE		0x00000100
+
+#define VSC7512_QSYS_RES_START		0x71800000
+#define VSC7512_QSYS_RES_SIZE		0x00200000
+
+#define VSC7512_REW_RES_START		0x71030000
+#define VSC7512_REW_RES_SIZE		0x00010000
+
+#define VSC7512_SYS_RES_START		0x71010000
+#define VSC7512_SYS_RES_SIZE		0x00010000
+
+#define VSC7512_S0_RES_START		0x71040000
+#define VSC7512_S1_RES_START		0x71050000
+#define VSC7512_S2_RES_START		0x71060000
+#define VSC7512_S_RES_SIZE		0x00000400
+
+#define VSC7512_GCB_RES_START		0x71070000
+#define VSC7512_GCB_RES_SIZE		0x0000022c
+
+#define VSC7512_PORT_0_RES_START	0x711e0000
+#define VSC7512_PORT_1_RES_START	0x711f0000
+#define VSC7512_PORT_2_RES_START	0x71200000
+#define VSC7512_PORT_3_RES_START	0x71210000
+#define VSC7512_PORT_4_RES_START	0x71220000
+#define VSC7512_PORT_5_RES_START	0x71230000
+#define VSC7512_PORT_6_RES_START	0x71240000
+#define VSC7512_PORT_7_RES_START	0x71250000
+#define VSC7512_PORT_8_RES_START	0x71260000
+#define VSC7512_PORT_9_RES_START	0x71270000
+#define VSC7512_PORT_10_RES_START	0x71280000
+#define VSC7512_PORT_RES_SIZE		0x00010000
+
 #define VSC7512_GCB_RST_SLEEP_US	100
 #define VSC7512_GCB_RST_TIMEOUT_US	100000
 
@@ -96,6 +135,36 @@ static const struct resource vsc7512_sgpio_resources[] = {
 	DEFINE_RES_REG_NAMED(VSC7512_SIO_CTRL_RES_START, VSC7512_SIO_CTRL_RES_SIZE, "gcb_sio"),
 };
 
+const struct resource vsc7512_target_io_res[TARGET_MAX] = {
+	[ANA] = DEFINE_RES_REG_NAMED(VSC7512_ANA_RES_START, VSC7512_ANA_RES_SIZE, "ana"),
+	[QS] = DEFINE_RES_REG_NAMED(VSC7512_QS_RES_START, VSC7512_QS_RES_SIZE, "qs"),
+	[QSYS] = DEFINE_RES_REG_NAMED(VSC7512_QSYS_RES_START, VSC7512_QSYS_RES_SIZE, "qsys"),
+	[REW] = DEFINE_RES_REG_NAMED(VSC7512_REW_RES_START, VSC7512_REW_RES_SIZE, "rew"),
+	[SYS] = DEFINE_RES_REG_NAMED(VSC7512_SYS_RES_START, VSC7512_SYS_RES_SIZE, "sys"),
+	[S0] = DEFINE_RES_REG_NAMED(VSC7512_S0_RES_START, VSC7512_S_RES_SIZE, "s0"),
+	[S1] = DEFINE_RES_REG_NAMED(VSC7512_S1_RES_START, VSC7512_S_RES_SIZE, "s1"),
+	[S2] = DEFINE_RES_REG_NAMED(VSC7512_S2_RES_START, VSC7512_S_RES_SIZE, "s2"),
+	[GCB] = DEFINE_RES_REG_NAMED(VSC7512_GCB_RES_START, VSC7512_GCB_RES_SIZE, "devcpu_gcb"),
+	[HSIO] = DEFINE_RES_REG_NAMED(VSC7512_HSIO_RES_START, VSC7512_HSIO_RES_SIZE, "hsio"),
+};
+EXPORT_SYMBOL_NS(vsc7512_target_io_res, MFD_OCELOT);
+
+const struct resource vsc7512_port_io_res[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_0_RES_START, VSC7512_PORT_RES_SIZE, "port0"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_1_RES_START, VSC7512_PORT_RES_SIZE, "port1"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_2_RES_START, VSC7512_PORT_RES_SIZE, "port2"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_3_RES_START, VSC7512_PORT_RES_SIZE, "port3"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_4_RES_START, VSC7512_PORT_RES_SIZE, "port4"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_5_RES_START, VSC7512_PORT_RES_SIZE, "port5"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_6_RES_START, VSC7512_PORT_RES_SIZE, "port6"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_7_RES_START, VSC7512_PORT_RES_SIZE, "port7"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_8_RES_START, VSC7512_PORT_RES_SIZE, "port8"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_9_RES_START, VSC7512_PORT_RES_SIZE, "port9"),
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_10_RES_START, VSC7512_PORT_RES_SIZE, "port10"),
+	{}
+};
+EXPORT_SYMBOL_NS(vsc7512_port_io_res, MFD_OCELOT);
+
 static const struct mfd_cell vsc7512_devs[] = {
 	{
 		.name = "ocelot-pinctrl",
@@ -144,6 +213,7 @@ static void ocelot_core_try_add_regmaps(struct device *dev,
 
 int ocelot_core_init(struct device *dev)
 {
+	const struct resource *port_res;
 	int i, ndevs;
 
 	ndevs = ARRAY_SIZE(vsc7512_devs);
@@ -151,6 +221,23 @@ int ocelot_core_init(struct device *dev)
 	for (i = 0; i < ndevs; i++)
 		ocelot_core_try_add_regmaps(dev, &vsc7512_devs[i]);
 
+	/*
+	 * Both the target_io_res and the port_io_res structs need to be referenced directly by
+	 * the ocelot_ext driver, so they can't be attached to the dev directly and referenced by
+	 * offset like the rest of the drivers. Instead, create these regmaps always and allow any
+	 * children look these up by name.
+	 */
+	for (i = 0; i < TARGET_MAX; i++)
+		/*
+		 * The target_io_res array is sparsely populated. Use .start as an indication that
+		 * the entry isn't defined
+		 */
+		if (vsc7512_target_io_res[i].start)
+			ocelot_core_try_add_regmap(dev, &vsc7512_target_io_res[i]);
+
+	for (port_res = vsc7512_port_io_res; port_res->start; port_res++)
+		ocelot_core_try_add_regmap(dev, port_res);
+
 	return devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO, vsc7512_devs, ndevs, NULL, 0, NULL);
 }
 EXPORT_SYMBOL_NS(ocelot_core_init, MFD_OCELOT);
diff --git a/include/linux/mfd/ocelot.h b/include/linux/mfd/ocelot.h
index dd72073d2d4f..439ff5256cf0 100644
--- a/include/linux/mfd/ocelot.h
+++ b/include/linux/mfd/ocelot.h
@@ -11,8 +11,13 @@
 #include <linux/regmap.h>
 #include <linux/types.h>
 
+#include <soc/mscc/ocelot.h>
+
 struct resource;
 
+extern const struct resource vsc7512_target_io_res[TARGET_MAX];
+extern const struct resource vsc7512_port_io_res[];
+
 static inline struct regmap *
 ocelot_regmap_from_resource_optional(struct platform_device *pdev,
 				     unsigned int index,
-- 
2.25.1

