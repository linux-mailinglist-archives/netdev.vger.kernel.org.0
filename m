Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65011313700
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbhBHPSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:18:30 -0500
Received: from mail-eopbgr70057.outbound.protection.outlook.com ([40.107.7.57]:12679
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233539AbhBHPPX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 10:15:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EGR8i2qnpYBYsBpwlhgEqiM8BMdNJG9Odlil5YYq8JqQaZIGVj8sE+O8dcTMfCyZ3dRKTtvSzY6FQBL4mmKZDL0uGcwC1R2UDT6qNyweoDSPGStxQ2oo3ZcJFfOpjyEl0M4JCm7K4RL9+ggZsqJNROx9gnFsaZYCgQmr7pBQGDuchR+xUUxTn5DNIa0ONgEid8i+KgZIPHYHQNeUhassyFbo6fQjbPtxNz1fCBS7kBqYaFcQJRgv3mzMTwsmKmkIDTv3nJUbZsOslw2UcCu4LW/1LR//2DcReCGh2mYpN4SQlx7psrwqsC+EyskuJnuSUhduhCjGcMl22V3ISwhyGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mr0qwQO9Qn/2Fvqmt6x3cOBdgVvKHvDjHxHWCZw6rXU=;
 b=TBXa2L2xrmQeas0LZf0mEJndKbEQjVl6jQwT0iRbrUUwVl2DvkbY7LqEhF7KmE4JHRghhTWR233crIjsNQwYo6eMG2fQUR/qY2x/FlhM9ceYBsSVoheLcfnfu+h2URKxkEGvBldbZ1DsFoRTabL16m1h9IWrb3EY2E211Ea+0PyZUDdUf3Pr5kGMzEAvKd95Q0ueHVxaeESFGsPlxlWiQ/patELNIPV4Pyq5znVBd2o/ddSgGTrlMGX15jp3NTFxCrhCmIPh0gLgpOCAXNW9CTvXPu11xGBysS0WArp2fAtrqIFY4aXgORHML6CoX3fnqRjGClR/EncfHhzKNFFMZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mr0qwQO9Qn/2Fvqmt6x3cOBdgVvKHvDjHxHWCZw6rXU=;
 b=JPk0fqbXla8HdzjnuLOQW2NmSmHIRWqnhmYnAMw87VYX86YKSBVreoJwE5usCzP5PFDXwQDHR3M30DO9cX90AvUXSgXlb8m620DeZn+f/JrBj5W+esTKM31q02KCwtEnLrdddMD/a1pplTzHRyMnJXLonsmjD2ws2Xa3bmSnzoo=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4772.eurprd04.prod.outlook.com (2603:10a6:208:c2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Mon, 8 Feb
 2021 15:13:59 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 15:13:59 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Grant Likely <grant.likely@arm.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Pieter Jansen Van Vuuren <pieter.jansenvv@bamboosystems.io>,
        Jon <jon@solid-run.com>, Saravana Kannan <saravanak@google.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-kernel@vger.kernel.org, linux.cj@gmail.com,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-acpi@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v5 06/15] of: mdio: Refactor of_get_phy_id()
Date:   Mon,  8 Feb 2021 20:42:35 +0530
Message-Id: <20210208151244.16338-7-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
References: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR04CA0176.apcprd04.prod.outlook.com
 (2603:1096:4:14::14) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0176.apcprd04.prod.outlook.com (2603:1096:4:14::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Mon, 8 Feb 2021 15:13:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9a041cb5-baf2-4ab5-3cc1-08d8cc4428f6
X-MS-TrafficTypeDiagnostic: AM0PR04MB4772:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB47724E1309125F056B3079F4D28F9@AM0PR04MB4772.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yWx8N6o0QkVFm6ajY5+ycsOzNjT9gSgXGv0hVdJ50wr6AwmrmESlnUYc9XCT0kf0WWtdQnMABs1eFAlunZ/W/wlklleRtFOCB2wOV1esJDPi5XRZ4PVhbWrFy6EJYJ2e/KuDjcZcz7xlEZ1ClqD39V6a0ouYM3GkN5xnwa4Ho65NlLKYuttgVgQo653weazZ9s7NegtV4uULk0xg3wQ1Wpi96BTwrjrrLV1hB9UkSBB9oQF7v3pzSCm9aTUexcxP+Qfx9u8R+RuHFPq2BlwHwwyDm1FkcKDnJBnaO9iJ1Ys8XLRg+a6cNP1Ey+VEVI5jy8bYcmvvruWrbshHcPUSJ7biqmb60KfrH42lipr885TU74q8orDD0n3HRStZqimyB0NNvaBmHbWjAH3qEy+SXS5XCWqiW+ihKwjXnX4099RcteLiirhw2CjJ1yJthG9jiti0wYzJMg6ulXHNeGAUdM5UBwSljQs3eNvwIN4nPL+EBaw8NNQGpLAJZYBdnxOyqz8tBbrzvoEzELsbF/m+DxdWhHz0M65/NoPozxOnb+sD6sfzMv19E2Pfmt+ST5JECqTN83fHLftuRUzyWXQjpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(86362001)(8936002)(6486002)(7416002)(16526019)(83380400001)(2906002)(6506007)(478600001)(8676002)(26005)(52116002)(44832011)(2616005)(55236004)(66556008)(66476007)(5660300002)(66946007)(1006002)(316002)(110136005)(6666004)(1076003)(921005)(956004)(6512007)(4326008)(186003)(54906003)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?yFtUSHz9l/T9Z4LJRVl/umaKO9XsRqcM20ivkQTUsIFWoxAUR7SMnCDoH10W?=
 =?us-ascii?Q?+1QiPQncofV3T088oJYJVr3I/7roHzt/yHW+S4i5C8ppQipMfZsVTwY/YmaL?=
 =?us-ascii?Q?+zi3vHgnMTzep257oDjvL3lrX+vXgpFZEQpio6rg1DpIfydkwYUfMCG2Fh8/?=
 =?us-ascii?Q?V3zPbczZzAmNvzbiJHy8sbQz/ReB+fBPXei8M4LibbSNAiy0Izji2McpvIty?=
 =?us-ascii?Q?qdQuroYDLLMcha+bKek6MQhRBqPYR8YtuH8JdyzIG4h20+oEPmUSiqIN0E+a?=
 =?us-ascii?Q?35QjwncYQE/2EfHaoSFCPI/srhStqwx+Y1hQFgUPnVMoX7jyd0iEIGnOrotd?=
 =?us-ascii?Q?Q4fUvYqSDRRYpEzm0Ldbw7J3lwUcj9Umn6AbTRC1ltTGiqPH/eRYQfuKtD5h?=
 =?us-ascii?Q?1coef4EqrnD4Ye+AqUzZJHR08aNWXuYOmaR6n0UwKZWA+VH1C9p4YWyXULHP?=
 =?us-ascii?Q?9ACq67UssZaMiKiDWqo3PHdRTdnlDOfHVX1zg3m6NfGfRDoPntrd1yPLLLEW?=
 =?us-ascii?Q?G09uRCQ0easa6DQ5WwxEuyoI2z3Ni+XfhNeW4MJf+dcBJuJgoFkR4484ClUR?=
 =?us-ascii?Q?+Q23cx5wmvHv1Pm8c3OGwD6syRYHy4/kfjXp18nXnKFnzozHk5YSLyQVJJBq?=
 =?us-ascii?Q?+5YYCHBH9NEQUDnij557AWObWMv473BPwvOicMggeg4Xq8Vki55bkzBR2NJp?=
 =?us-ascii?Q?jJGUXkh2WufXrkk+RD9ks7A1VIKPZsmWTGiQDZ5ziFAu25wdNaJBtKgEMbFR?=
 =?us-ascii?Q?6xkL1+U8obz2UilooZrzWGKU11+osCE+R5P9pQB942k/T3fzycBtpKlSjJyr?=
 =?us-ascii?Q?wq0rbW1S4j5WMkeYa97vxNREcXHRz7jJ8Km/i2wHRxB1tBwhTMFKK62iJ9h9?=
 =?us-ascii?Q?9j1SeI0SM1QtYe9eBzzoO839kGelIFSvMYSy6AvrHzlmZjiowXfAYUa2ujf7?=
 =?us-ascii?Q?BtW4ov2zA/o++aANohG7gCQaSNyskIaCB110OvIhXdEYd4aajC9g+t9xzcqE?=
 =?us-ascii?Q?nbi5eT3fmNKubD1RunR6z5lo1Mu/WcvOn7KRM4BJ8SFbMUlIQ7YSuctWqV5P?=
 =?us-ascii?Q?kcAMxRqiSTgssfUG6bsajrMjVDQTVysq5nxNAPRUVDknc56OgwxoWd7L2pl6?=
 =?us-ascii?Q?kB1uSIfNGVJTUZCLcB+66LWPHxGw45v3qElkSGO2fS96W6BJT0JBV64NB89u?=
 =?us-ascii?Q?io4yE6yth/2IRNyaxcjx++hM/w63YCDnhZXV2V6fNoRYbDTmJqxqWwbuePFa?=
 =?us-ascii?Q?R4waj4CX+DqqYWBlX12bOlJtuhyJlHauVazYPzoZIf0A7KVAAX3+pwEYKWl+?=
 =?us-ascii?Q?4zVRDRweUrtNuTGycBY5p7vt?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a041cb5-baf2-4ab5-3cc1-08d8cc4428f6
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 15:13:59.3761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xRckg273teGyb1yPMg0oUxHekXv2hFjwoB8HVwhzTxifhlUGGL6S4VgDX6h2Nm9YPHBBzovcTr8HzDBjkQTTMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4772
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the introduction of fwnode_get_phy_id(), refactor of_get_phy_id()
to use fwnode equivalent.

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index 94ec421dd91b..d4cc293358f7 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -29,17 +29,7 @@ MODULE_LICENSE("GPL");
  * ethernet-phy-idAAAA.BBBB */
 static int of_get_phy_id(struct device_node *device, u32 *phy_id)
 {
-	struct property *prop;
-	const char *cp;
-	unsigned int upper, lower;
-
-	of_property_for_each_string(device, "compatible", prop, cp) {
-		if (sscanf(cp, "ethernet-phy-id%4x.%4x", &upper, &lower) == 2) {
-			*phy_id = ((upper & 0xFFFF) << 16) | (lower & 0xFFFF);
-			return 0;
-		}
-	}
-	return -EINVAL;
+	return fwnode_get_phy_id(of_fwnode_handle(device), phy_id);
 }
 
 static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
-- 
2.17.1

