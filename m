Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2085F86E6
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 20:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiJHSxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 14:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiJHSwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 14:52:24 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2097.outbound.protection.outlook.com [40.107.96.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713B53FD6D;
        Sat,  8 Oct 2022 11:52:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k+xE2HsnaV/aMZq8RY2TJ2cdkUC5KfC+SEscpel/In8MnMyuRqWwq0OjP2zrKm9v4OZzHRwr1evd+O/MoYAsElCGAQpZdKuDPtRR2tZQe+W3+6aMewf/0h3dZPLGME9bieeWJmLpNia2UK/BVsmb3/cVLWPqlwcRH2nQ00aqXG+7ykIdBeAWdz0mEFKLf+8utBuBQZMfRnh0x4ZatZoCy/WifLD5upEyCqQF8bozaDQ+9pqDrEd5+edfY8vU3LTEL7nyNNqLV08JZAK/U85v7oupDfHjtmldE/c3OaVLtqXOmwN45ZMTEP4tavEXPZyDOKxE2BYbmvgI2YljtCN18Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=td9QZP8dox8JlZXIYio4EV+Ev1mj2gxb8N8BrwL0F3M=;
 b=EoYYIl3vY0lhSrqPCOAKfkVlyKjKFoAGjKZipuvBXEUDWeJIDv7sSkjvkVatn5kMhCayc80AfxNvV7aGMARhxcIEp9yOuUaybFTYAL3IbpeTjYt31wvyijr+K91pPvG23J33PDeNPZLdME3BEyLY2DDfMbgjAD5KSsbRvAF6SjT5PxKlYDw0VMpFs2RcB9i7fqw9oVZF8Bd22NMjHVtvG31e89mHeUHs5IdC9aZuUYeOQy0ukrYdLmAkRhwAvz4+FkIaTUB2vmePYOXOx8UWrr9F17rFvjzS9fF9H4RrBJ0pyboVUEGr9vk5cv4t0HCMbvmEckm83BGeU1Z+xojYqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=td9QZP8dox8JlZXIYio4EV+Ev1mj2gxb8N8BrwL0F3M=;
 b=hTKcN6PonxcNajPogoWJ2lnqpRcIyDMvnOuQI/h4Mk1rTlrCXoi7D9bcIuEFjWX8265AfQK1TclAL/JW2TGvJUKACSX90J5z1/c57XyJA3DR5voMAC1B8oIs24dei5idf0KOE1/3FgE+H15xywSqtrUoYOASOEoRX5MRxrifMoY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6506.namprd10.prod.outlook.com
 (2603:10b6:510:201::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Sat, 8 Oct
 2022 18:52:14 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::ee5e:cbf9:e304:942f%7]) with mapi id 15.20.5676.028; Sat, 8 Oct 2022
 18:52:13 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [RFC v4 net-next 17/17] mfd: ocelot: add external ocelot switch control
Date:   Sat,  8 Oct 2022 11:51:52 -0700
Message-Id: <20221008185152.2411007-18-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221008185152.2411007-1-colin.foster@in-advantage.com>
References: <20221008185152.2411007-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:303:dd::9) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH7PR10MB6506:EE_
X-MS-Office365-Filtering-Correlation-Id: cb37ee54-4735-41c9-04ce-08daa95e3617
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6aXf5tkYEfUxk4GvMt4Ta91qEfUpFLY//1vlQYoTuUtWWAAAzl0RdGj8KUk401b8Bmg5S7QW9grjieKEtF4N9XrT3W2C3PyNXm0mx9uN8TE2MNaYRvL7cfTzBQdlEybZeXYizsM5CSlylHr9rEe5lqBdNOoOAaJvRMh3XhyjrYKfqBexjU518ata2vVEAgoEBfPYVgIrEaCAerxIVJTXciztpEfvy6lSQREgxcO/vi6YyUlLI/6J/BJItgV6uBlzxnFVdXbNPp4VOCwoNYFspQqu/O/HY+TbVC6utKd1MoRk+hWjnhK2mbEJ7wbC0SVw0srtO7YqcH2kzVgEzTij99VBmWioLiB/v/nk7kxJTyfZafKIclSwCxD6Y0/14KddmSvPZGC1VDbWz+7G+q5YM0JAAjjGnfkhl8zurH5PHAAIezk394lCg0h/XOhnW8s3xK3RMaX3l7GeO78fzVDWykCNy+el2BXOTfunpopWYddclHVXXmtGcQsNdHCpKBwWjvOvnbz5yxOomGyyTO6woidxCPEMzE+MjpS8NQnNiJmisGF7KodWC0ZsxQ7nqo0cdLhNToaM82kNSProW0xsZDAq7Gvict/ECXx3MPj0L0J3T5NP/smZ80mMgK00mCyUsnRiva0VImg3er86KTTRKGa8fG9ErLMHwtqzIKupQMQidslKe11dYc33zGiUQzzJTQlJqF0NNT661GoYjUU9QKF9IfyPiDBsBHEe65zI//Fpo3IVaAx9SZvMTyyJvryL7vBURVSM7SmLQcs2cSbERw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39840400004)(346002)(136003)(396003)(376002)(451199015)(26005)(41300700001)(6512007)(86362001)(1076003)(36756003)(2906002)(186003)(66946007)(66476007)(4326008)(66556008)(2616005)(6666004)(8676002)(6486002)(38350700002)(478600001)(54906003)(316002)(6506007)(52116002)(38100700002)(5660300002)(44832011)(7416002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sjr42qKEc+jBc7gZd9D23XgRt5agneV7yJtW5jaD8Pv+8+neY0MXTabykVYF?=
 =?us-ascii?Q?lb3DV0N3MYGshiaub+rItoozs2M6hZerre25eVEQIFOykIqKJgqUPYl/geOk?=
 =?us-ascii?Q?DdwEey+ueRIy+jVGQRrD/cABr7b4QcJofFDQpNiNFUxRs6gwmI2jW5zvXiGM?=
 =?us-ascii?Q?lZ37yz1EWFzfFsr+n/fd1V1FReaQDLX0Kfrjvv/Zs3rQwhTbya1eOZckVXIk?=
 =?us-ascii?Q?TjC0AgNhVHLI7lSaGWqVWDDjkpSK1ThzgdQe+doU/vGPcGLY8yKAAxUhInJT?=
 =?us-ascii?Q?nMv7CBHfMrUBOM7ssOLrM9LS2WFR04prU1mZVRi03MfDpwE+5zKhoBx22lCI?=
 =?us-ascii?Q?KVwP3vwu4JEjNkW0m3TU06k7KI/mQWeinlNjdorPKpJX8opcZsnBn2WZWjTb?=
 =?us-ascii?Q?0lp+krURwWSAx5mMNrBi5uVboLkiR+uBrFPYzzeay+0v/E4D66r0Oa8bTxMM?=
 =?us-ascii?Q?KG3JcJFohrRgOEJFjgZ5eVtqLA5aGXeKwo0VKW/lXEVV8gVf3Wmn1kGJQgML?=
 =?us-ascii?Q?NmCCV1JQoBYzJoe1gCY1nLQjXo4VQJSyotxIGYsMeItGM/PgtV5CV/kC7m8p?=
 =?us-ascii?Q?3fvcLMPprZ0lPxnyBZkSborypuY+tr6XKZN73f8qSiDjoBSQ/a0bEeIf711w?=
 =?us-ascii?Q?Xi1I0u5kLY4G43fkKs8uTaoaTM54ZfyoGjfZvMbVJ4GkkyAoM8mGJpy6m/F6?=
 =?us-ascii?Q?DkVSfWCjShMydrnyiPfqjO0pG/95o+OFXnTWvQeppAxAvdP9m/HJNy5a485T?=
 =?us-ascii?Q?1rAdlLl3jPCKVH6WG9PsGUjGY1DwXS4KncNkScqAgUO6f3K8/PNy1y7oyWFS?=
 =?us-ascii?Q?o8RYSsnA9pFVwajOc2S332ITMSWM9CI69NlE+5VP8mLKTkds/dDVPm5iaSvY?=
 =?us-ascii?Q?DeqXZtWom/yRemxyhDbUZw8MhZ6sAAjm3Y3Sd7Jd2yt9o6Q5kyFFZoWSu+GX?=
 =?us-ascii?Q?HtptnvMeNAm7o/fG3bFih9wb6Oz4MV/vWAiXP6lD3gQpZfM+TT+jz0WGFuED?=
 =?us-ascii?Q?s8Qy5sbDgZ8yBfYNGWuNogKEz+bJ3ks/TsYfV9N3ZnI1WbxVt7STdAKG18y/?=
 =?us-ascii?Q?EnE9ei/jeBOAxvOv2R2jL/bbYjC3uMELkqJpMlr1yGQwnFF+HUh4CmNU37r/?=
 =?us-ascii?Q?ymAadeLIT8P2xxrnQXSGW3yFCQ8fzPKPtBXRVoqJJV5SpeFhyw7/4c2wdeU7?=
 =?us-ascii?Q?GdJwG0Xa1kZ/k0hwUwzdr5psAyTBrzOxJjtGn2mGSy7obwJ4CkQfJuYfX9gX?=
 =?us-ascii?Q?ypY93fkfFhwWMnpC/k1ABMciW+BlbsUgnhguUl4gIEFkbf0AMjah5ceO4OwQ?=
 =?us-ascii?Q?KFpHqg+tBDbtbG4q3XW4n5gLEvsxgBvv1QjcdPcWQhL7M0o7Ufo25KScSDok?=
 =?us-ascii?Q?WtlZuuZktTCk8kYJ19ut2gMuMwwIkJFPWRnvsTILJ1k6s9zaTN/9odLldj6X?=
 =?us-ascii?Q?FD9kRcWKCwKCYRGqRLh1vsYscJgK3yqw/A/roLSrNmOqy1AAJ1J7qBdZDF/Q?=
 =?us-ascii?Q?3GTO3gHD/WduGRV+4r0Tug0uPcB025zvZhE7e+Bdg2hogNQU/H5Nz3/aUTxG?=
 =?us-ascii?Q?s/w57gW4/d1syUeR1mwvy1CIqCi1hqBdxfkmY1zwNNLnPHVQ71jGCcIO/o24?=
 =?us-ascii?Q?YqQ/Qbw6+WhuV83++9ZEtNc=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb37ee54-4735-41c9-04ce-08daa95e3617
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2022 18:52:12.7250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: POAsih8R0JdjLru4JnSQ2NUyADEqmRNMkFqzmGB4LOyGXinWfdbBCSPmcW90dNbjYfkUXMP4NEW1ONMC0l8y6Gk+fT8PcF5gJAKKPHqkPzU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6506
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Utilize the existing ocelot MFD interface to add switch functionality to
the Microsemi VSC7512 chip.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v4
    * Integrate a different patch, so now this one
      - Adds the resources during this patch. Previouisly this
        was done in a separate patch
      - Utilize the standard {,num_}resources initializer

v3
    * No change

v2
    * New patch, broken out from a previous one

---
 drivers/mfd/ocelot-core.c | 60 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/drivers/mfd/ocelot-core.c b/drivers/mfd/ocelot-core.c
index 013e83173062..f35b4b2d4eec 100644
--- a/drivers/mfd/ocelot-core.c
+++ b/drivers/mfd/ocelot-core.c
@@ -45,6 +45,39 @@
 #define VSC7512_SIO_CTRL_RES_START	0x710700f8
 #define VSC7512_SIO_CTRL_RES_SIZE	0x00000100
 
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
+#define VCAP_RES_SIZE			0x00000400
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
 
@@ -96,6 +129,28 @@ static const struct resource vsc7512_sgpio_resources[] = {
 	DEFINE_RES_REG_NAMED(VSC7512_SIO_CTRL_RES_START, VSC7512_SIO_CTRL_RES_SIZE, "gcb_sio"),
 };
 
+static const struct resource vsc7512_switch_resources[] = {
+	DEFINE_RES_REG_NAMED(VSC7512_ANA_RES_START, VSC7512_ANA_RES_SIZE, OCELOT_RES_NAME_ANA),
+	DEFINE_RES_REG_NAMED(VSC7512_QS_RES_START, VSC7512_QS_RES_SIZE, OCELOT_RES_NAME_QS),
+	DEFINE_RES_REG_NAMED(VSC7512_QSYS_RES_START, VSC7512_QSYS_RES_SIZE, OCELOT_RES_NAME_QSYS),
+	DEFINE_RES_REG_NAMED(VSC7512_REW_RES_START, VSC7512_REW_RES_SIZE, OCELOT_RES_NAME_REW),
+	DEFINE_RES_REG_NAMED(VSC7512_SYS_RES_START, VSC7512_SYS_RES_SIZE, OCELOT_RES_NAME_SYS),
+	DEFINE_RES_REG_NAMED(VSC7512_S0_RES_START, VCAP_RES_SIZE, OCELOT_RES_NAME_S0),
+	DEFINE_RES_REG_NAMED(VSC7512_S1_RES_START, VCAP_RES_SIZE, OCELOT_RES_NAME_S1),
+	DEFINE_RES_REG_NAMED(VSC7512_S2_RES_START, VCAP_RES_SIZE, OCELOT_RES_NAME_S2),
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
+	DEFINE_RES_REG_NAMED(VSC7512_PORT_10_RES_START, VSC7512_PORT_RES_SIZE, "port10")
+};
+
 static const struct mfd_cell vsc7512_devs[] = {
 	{
 		.name = "ocelot-pinctrl",
@@ -121,6 +176,11 @@ static const struct mfd_cell vsc7512_devs[] = {
 		.use_of_reg = true,
 		.num_resources = ARRAY_SIZE(vsc7512_miim1_resources),
 		.resources = vsc7512_miim1_resources,
+	}, {
+		.name = "ocelot-switch",
+		.of_compatible = "mscc,vsc7512-switch",
+		.num_resources = ARRAY_SIZE(vsc7512_switch_resources),
+		.resources = vsc7512_switch_resources,
 	},
 };
 
-- 
2.25.1

