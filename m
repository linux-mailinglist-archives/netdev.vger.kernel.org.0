Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEA931E5A3
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhBRFcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:32:33 -0500
Received: from mail-am6eur05on2078.outbound.protection.outlook.com ([40.107.22.78]:27712
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230389AbhBRFaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 00:30:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RgiNi1TEn//AwStoinNWKxES6ItgJ/qpJl8keZJTPPZ1mbCjE2J0Jb0b9yR++V8ea+972Unz7szujBwKcyUJpq006GvqiQBVC383Q9co/SQGWv0iopifaZFhDDtAozrpZ4vQJvwlPe91cY+YPLbq82/i/PJvH/lwLS7tns+JvncMmEIGjjEzfafc5KiAmtZqk5qoKkWGCrGoAPmXZIhWw53f1eYZ/dYtG1s56Hy/8NJQg4trbLz7pi6u7FxsD6EgQVO/ay3Op/XM56kpg0QM/Zp/p/AIwaiuUSrr5YupA4Z1ueAysIUGUwaoSeMyQxLNwh69ans6Vu9+BYnAFn571g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FB10n7oLpBWfXMHJ4Nhx1CrW3M+j/hH7J5WQQidIr2E=;
 b=hh00wJ5LmBX8Yx5cQfTCU+ElXzObFmYy1uAuUaG0g5Q9BWpZKKDIbjNxL0JTQFM0fj1D97+XFZH8RAQFEJLp7qNpIlnwUXfv1YUBXK/6yFsE7Ghy5K8R38L8mCa8yud/NBSVQMMAhMk1RGlQ84njXww9jgiPBxCDajvZOrOt6n5pL8jxtTw6nZz14PveGHNWU7MoWE+b2p5XqZZ4BA1zdMz3hqsGUm45QIFN5exIJpMeyFromfsJPDMDADp3R22FcJbvY0bZPQ1pqH5DgtAKT2UsUb9du/ZTzZb3ChUaJy06AJpHknCF86ZLWSa7XkyW4I4tk/Qz+E3oMzyrnMX4sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FB10n7oLpBWfXMHJ4Nhx1CrW3M+j/hH7J5WQQidIr2E=;
 b=DYWAqA/2cuDqzQsnhKPpZSqTo1fq7ENTsLnq57ClPPBlf6ySpImHu1t/rMgjb4iHocl0pCzAMlYHF2tVtHOFEEkCRJRV8u6CxwtxXir/6yK4/gSlrj85F/DVn/ER6VFcezvpPqpm0jJxK3wYwToLoF1b0mu3gI+2HxG8AYAcRWw=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3442.eurprd04.prod.outlook.com (2603:10a6:208:21::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.42; Thu, 18 Feb
 2021 05:27:53 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 05:27:53 +0000
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
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux.cj@gmail.com,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [net-next PATCH v6 04/15] of: mdio: Refactor of_phy_find_device()
Date:   Thu, 18 Feb 2021 10:56:43 +0530
Message-Id: <20210218052654.28995-5-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
References: <20210218052654.28995-1-calvin.johnson@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:54::15) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR02CA0051.apcprd02.prod.outlook.com (2603:1096:4:54::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 05:27:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1f5ddced-5849-4f40-9c36-08d8d3cdf0a1
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3442:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB34426E098F40F0FA4CCF5EB7D2859@AM0PR0402MB3442.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4mry8Y8p8oE0SqQgntNkt+kb1QDPYRBr/De010ik7pYf8ILPyPLIRCYDh1nM6wJGE3gcsUjDbyjtnxGbYMt+PSRN1oe6TtrjjuQA4ryZ3CIU3VVYAOt8MOZnDXRjUV2tc88MHIoUlf17GMErOg9wsW+nubMATyepCa0GkGm7IIh0n4F9RBuLyfqjAHc5E0xAdegsZUPopuF1V+Vif3C6g5TYR4m3vaTNC3R/gJqJ1zrlAwESx1/DBCiQNItJyLZXA+RUjzAnnVJ70xNRpweZ2XSP0+ReKTD3625+ydI8pgOqJxPgakylzFztW3QF9du6W+LuZ+O8JSNN9BCSA3w5/lnIkpBsOjRzzVM9hB0J8n8LsDdPgj1sqNb219gvEoWo1w8ECk0HWDNBI550zjEDXaNOwaG+3iS7R0s2mJp+7gQGGJHBMJK/eKXfy6fmZRCBjrT+VLF8OXqJC0JuMqeGdRnuV6mirfcd8kq5IQhOfsxOhUWwuK21n3yFaiFQzNRhELsa24vv7yJgr2BtnTBI4zt010T8evx/DVAsdbEujCGhdwFBeem1Hsn/rb1gC9+SHwg7NBi6t6KnDwV8eT4Tmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(39860400002)(376002)(396003)(44832011)(6486002)(26005)(7416002)(16526019)(4744005)(110136005)(956004)(2616005)(186003)(55236004)(83380400001)(1076003)(6666004)(4326008)(316002)(1006002)(54906003)(8936002)(5660300002)(921005)(2906002)(52116002)(478600001)(86362001)(8676002)(6512007)(66946007)(6506007)(66476007)(66556008)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qbQ45Dfhvx06+bdcgk2Nom2k4XdFr2EzcIwFOR8GBeRuMgmv8yNu6z6g6IPm?=
 =?us-ascii?Q?1MugHqIYSv33STX/AlHIiYOlXgXUIUixSvLsI1CbkFwkY826QZaXGh56TJRb?=
 =?us-ascii?Q?CWhqpVnR38GHqB83xEGMeQprPr5J0uS5s4CtBhNJr4D1WQ+CxRpfkmrBf63c?=
 =?us-ascii?Q?w2BouSKUyaUgl3p0k2rZttFBCDI2SmnvfyxOzRUqnxhQgFqPr8XPQ5qv0/wo?=
 =?us-ascii?Q?5wBPf/OeHeTKZ10rrMnUJWKcY2VB9XzlW9xt6/uYvDNeLUmUTwUt6V82ThTc?=
 =?us-ascii?Q?/AhzyXd5+Pq7cbQrAPrbH7A/ZUJAeGI0bqUB2d3a5XRArMnADIx1t3Yu205D?=
 =?us-ascii?Q?MtauJoFvYluEjenivKrI6sMIHrnmr2F2vhfG2RcOzMfM8I95WG+9zQAGsaD7?=
 =?us-ascii?Q?q9hbd5ASLo9vkr7jwKh37jdsaqCkzQovtdNjSJpzyQHmf+6e6EvAbONssVnw?=
 =?us-ascii?Q?JEf9TXtM70MB28JnYFBYB2SwDgR6M2wYjV6xEl7B4XK3cmziZGpvTiWt85RX?=
 =?us-ascii?Q?iqMMjc+NRBJO1qSmgncFWpuNFDZZTIu18LQ+jwN0AOam0O0wGjQAUE1wJZZD?=
 =?us-ascii?Q?z2Ruk79ndtc5qI/QJaaap5+DKTW1H+gGSujU9sndzfClBgGdJq/cBECiIBE8?=
 =?us-ascii?Q?1+n1EBsO8yVjhRTV9JrE4VF8DiltyKkDckzQclYOXyVpt/HrZM7JM42l0ye/?=
 =?us-ascii?Q?UDrLYBleLv2J56R9c9Kha3qmTYDGVAlDAS6PhkR0nCN7GP1uK6kHrNrGr0p7?=
 =?us-ascii?Q?yc5szp0YMwWjvvdcW4y8xzhD4yI+I65CwfVQ+YQeQa7s2t4iX87XnYPWjd4Q?=
 =?us-ascii?Q?bNrkgqKOIaLKruVQXVxWGfyv+bcU94eosqcCusRcUcFg+LZyNvyVwxWSnlTg?=
 =?us-ascii?Q?q5gYpDjbdTXIvfhBRZiisWmksfYoOQrUi3XURloh0Mjf9TgqgLOQ0DiBhA0/?=
 =?us-ascii?Q?qzh5q+m2DDDQhB4THok0UeRN1rCyIxYW/ox6WsEAbWyuJMqRCnUUvMulOazT?=
 =?us-ascii?Q?cqddnRLbv0h30/ke8RUbNQxCxNlxUBs6z1FVDTHHJ5quCeodWRi5kuxT4zsQ?=
 =?us-ascii?Q?pkYdf/5tNHY8w9ttzSDZMxyMWzpqqxiTjOwhAiv4jlJgrMv1+CI6WueH+WoF?=
 =?us-ascii?Q?8+eLzOkI3/G/j4u7RBYqAI7FrXgqj7Wp/Uf0pQMf7bQuyaeZh4v+kPSi0znI?=
 =?us-ascii?Q?X3BdeEEvT5WlyVk6URKLlFPbQXYXln1+7n7CfpD0Xz4WtTpijT4uumqkfqDa?=
 =?us-ascii?Q?MdPT6pwNS0tMmRoVn/D4RfwBrWmmZQH9Y8YmiByPfuPzL4pYC9UU89dffnyk?=
 =?us-ascii?Q?IV5lszMljAdQlutMnc/yYfG0?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f5ddced-5849-4f40-9c36-08d8d3cdf0a1
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 05:27:53.8171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bBJAGxXYL/dFT32D2zIhf1lwMydnKmbWDi7MgXAyG0kXVcM2urIkYbfH4QFSplCunQXYvmZFQMv+CBUUxocFTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3442
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor of_phy_find_device() to use fwnode_phy_find_device().

Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
---

Changes in v6: None
Changes in v5: None
Changes in v4: None
Changes in v3: None
Changes in v2: None

 drivers/net/mdio/of_mdio.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/mdio/of_mdio.c b/drivers/net/mdio/of_mdio.c
index d5e0970b2561..b5e0b5b22f1a 100644
--- a/drivers/net/mdio/of_mdio.c
+++ b/drivers/net/mdio/of_mdio.c
@@ -360,18 +360,7 @@ EXPORT_SYMBOL(of_mdio_find_device);
  */
 struct phy_device *of_phy_find_device(struct device_node *phy_np)
 {
-	struct mdio_device *mdiodev;
-
-	mdiodev = of_mdio_find_device(phy_np);
-	if (!mdiodev)
-		return NULL;
-
-	if (mdiodev->flags & MDIO_DEVICE_FLAG_PHY)
-		return to_phy_device(&mdiodev->dev);
-
-	put_device(&mdiodev->dev);
-
-	return NULL;
+	return fwnode_phy_find_device(of_fwnode_handle(phy_np));
 }
 EXPORT_SYMBOL(of_phy_find_device);
 
-- 
2.17.1

