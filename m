Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4DB457836
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 22:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235668AbhKSVmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 16:42:37 -0500
Received: from mail-sn1anam02on2114.outbound.protection.outlook.com ([40.107.96.114]:1767
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235650AbhKSVme (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 16:42:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lgXs/DCxM2QY+Y7PWT3Pgkc1Av1L+7zDA6YSXzuDfXqQT/7FHXf0+NDr8Ks717hJR5BVm8aUs5COai7pMQK1CE4VIhOPnClm3JNiuxeo35mZ8NfXrwj8GtN/ODdU1vhtme+CgGTOhFyrXVhlq24wlBzV8WPpeuZL6lVkWDerri/0QfOfP38VdSDopwslK8NdxdO6T4yXQiuK11sNqUTGv14aOQLI6ki7LgJF6zavUs73z68SnZamXfQkc14pfQy8Yidbop/GhpBAAOca3gUfTnxyzk1a6MkpYngdPjOKqRnbenH6ieZgCNE4Mgd92mZYVxnb3Jhso5sDJ3C9ndB75A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=teWH3hIwMFBYnGApZq4W5Op1sj66sQ6tWyuyTDdfIM4=;
 b=lGvy60gUz8GrqtcqebFIzXubKLmEo6TKhY5aG8t/Daih0vGLKtTksv38DElzTqTqKuN5lY9Pcs5aXeLaJBh3roorFTudnh6lj4KzfcNvB6NeFW87JgV0D70XDIdNVow/fs98/KZ/cfcl1KVbJ/QE4MNwsom53Jiq8Xkanl9blDl97iji7Xwkz86O2mlabRDfYeT6vKMK0nBII5QgOECHzCEyp2nP3Gu9TvKrLfAEy+Qug3UWkDHJlXiVRsLayyjMrIhQBSARxWyWKEYpD1zBphTBD1KO1Q0HwyugDsZHnFBjGTldYavff2IwJvFlRGQx+yOp7y6SaVqhioWRjmr94A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=teWH3hIwMFBYnGApZq4W5Op1sj66sQ6tWyuyTDdfIM4=;
 b=n+NZEK/6Gd6bO7+bTyxZJxNVXASCvP2JoS4Nfhvn+bjdVzppdpeBC/BELa7aKJ9PbylBQcCv1QQiKyoEnmhDgz3iUVAUqH5VvP+Id/FcU6dAwWY346Zkows+UW5Q/rJoluJepB/lkm5naxZYODa3J7RWkAdBsUDQdiUybJQNyUg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MWHPR1001MB2304.namprd10.prod.outlook.com
 (2603:10b6:301:2e::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Fri, 19 Nov
 2021 21:39:29 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4713.019; Fri, 19 Nov 2021
 21:39:29 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v1 net-next 2/3] net: dsa: ocelot: seville: utilize of_mdiobus_register
Date:   Fri, 19 Nov 2021 13:39:17 -0800
Message-Id: <20211119213918.2707530-3-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211119213918.2707530-1-colin.foster@in-advantage.com>
References: <20211119213918.2707530-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0376.namprd04.prod.outlook.com
 (2603:10b6:303:81::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MW4PR04CA0376.namprd04.prod.outlook.com (2603:10b6:303:81::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Fri, 19 Nov 2021 21:39:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4287fc28-1c16-4125-b7c1-08d9aba51107
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2304:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2304F3CEC615D0D73E75CA88A49C9@MWHPR1001MB2304.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E6Qkmb1N8+LyFWyF9F9mA13u228yzaT8JzIPu3i36r8AQxlnU3Sm5Hqdu4q9Ew/cPpdeKFPhoj/wPWcO8VF8pyeZqZk2CHbZfNvRIuyq19ByXwu/iejB6uNFA1sOr3XNG4wxwMZWWwM1qakrw+htwERrT4rukPxyjzIPAH5V2Kl1bqUt4lIhz4PagnKu4eVVvs8yhc1vVi1I/WWuBn+wD6EqXyylOPZ32zCTBaFfSKfko9Uplu3iyKB1ZOIYHo9fH+5xHBnPCuRYiQK4nMwcl2U1IV6pm6gP6oAg89+fDfolg1t56v7fD/LqKaEfThzVD8J+bfxwcFzIgFKHSATwxZ3O9iuxRd+LVsAOC3vrGtqgNSKjadMBIWDLv2nOVFRS3iBCMXWwLYIjdd+VVzEQZIU85hbsIXWjGpFnoerQdM1L9AwaycdFO/aZI3T70DiZGxjgQDYCqrXjDIbM2653nXHO5/PLZGR1GI9gfChvM5hFbNTmk8vd8SjuJZlunUy0a86JIAAV0sR5j6VP0Xi98wnwWUIH0do7YWLPsiTVQDFe3e+QM3zzHvTGesEQxLFRYSwYLeAx4BARScM0we8LKauHvEpxR6l3oqR2mygb2Z3XE/5cHuHDODVEiwwc2w4eBaDT/xG2i8jPCLgTctw8TzEfuYqptqPPW25EtbJ7UrwRXpXKWD+holvdJa9eTWuJLsvdAYRneqcW1ZDBno0uAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(396003)(366004)(346002)(136003)(376002)(6486002)(186003)(2616005)(956004)(26005)(38100700002)(7416002)(8676002)(6512007)(83380400001)(38350700002)(8936002)(54906003)(4326008)(6666004)(1076003)(6506007)(66946007)(66556008)(66476007)(5660300002)(2906002)(36756003)(316002)(508600001)(86362001)(52116002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cIzyyy7aPNsbzh46dAztIQM3mq7l1+FfKb/alXy/FxG528J/15QduXzXJyDe?=
 =?us-ascii?Q?8Apgp8bG9fsi51UfMnRRt/LdcdcOhXTTqbt8v+DybA4Vj/qC3OAy2wWWRhPv?=
 =?us-ascii?Q?FKpiqxM+xOn12n4Qllxy4bkeg5KDmMtkBSQinmRNKfhdzCYDjF6ymLa8jFJ8?=
 =?us-ascii?Q?7Fi7uDnElWHoOg3j6kGnf1PHxQxLP0ji9uUDtgCaxh81CGNfqKk3/9kWJfZW?=
 =?us-ascii?Q?L39d3CsWbfA0FFEAZXbh8EmjIoRguOOrEYkg+m3I46V5UQxcmCyAycKgjUZ1?=
 =?us-ascii?Q?aCKxaXkcxKIGSqQvbmzrWjiYbDnoxVIu5CzKsJvrdKJWP/aV79kAWutLtx5H?=
 =?us-ascii?Q?e7g5udHr8okEw/bKURJ05ZTlZZhtwMyqEPs1jsd2q21TZB7VnbEtL0FKjVhU?=
 =?us-ascii?Q?NeXjUMBjkVeARNCb47O+Imm57Roa066YitlUAwrEXkWqHWdevbsuWIMIA4mg?=
 =?us-ascii?Q?J8+rJ+x+dqhgweO8zXUvGGSA/ICbwmAJMJjme0OQeBAkMuOKsVMFG9Vsdh57?=
 =?us-ascii?Q?hC791zclSSPCb+yY+6VRrIPWpOXbJSISHPkX0OLdYI7/Vj3V6r3bwzvVaWHZ?=
 =?us-ascii?Q?xCiMCzX9EuGFtUEWHTQcWM1k6OuGC24UarJddBu8oT4Cw0t7DPeorszo5mGl?=
 =?us-ascii?Q?BIU83US/oSfxTv6MOWtSEIymRbTmJ7FcIMpCguvJACUs+I28Jk9k9cXiQLno?=
 =?us-ascii?Q?FAPNuVTEweC7ZB9SffjRN3eVCoRnXRUdcXDl31VYHiCnTIPaX0Prk0MTPGBJ?=
 =?us-ascii?Q?0isgaig9pJF+eMOg+qYYZeyR8Sqrs72Z6FePMhJtzUfAKGYUPzfrPH+mp8Jf?=
 =?us-ascii?Q?M1KyikDi+iOCCQD+Gg61irI/hEhlpw4yYsMaYJfIUIeH4SEWa0yis9PgaVSv?=
 =?us-ascii?Q?jNNBFXLIvU8CBTm8TzQuiLgVelF3xLiOf5eXN67TEqnAzydBwarWcU4R4oEk?=
 =?us-ascii?Q?TMWIHVuWyPzpYE7oJOaNbfTjOg1MgX4jTO7iKePEKZCKbW7stcaA4U3RZV0Y?=
 =?us-ascii?Q?uFIzeb7eYdIBfIoDyjy8/gWuds9r+cW7R+qiMUoMxRsUKmYbMZ3USJ6Vh7pO?=
 =?us-ascii?Q?L96myoV/+nmG0yETPxnwrRJ/sPWBM5GzdOTkHwMr1R3AC3Zw4MZ7Y79hcK7J?=
 =?us-ascii?Q?jp547uOw+KLvSe1vzFXE8VF8G8JLH2bljwOL752xV4KIOQMAEIfYXJil6MGn?=
 =?us-ascii?Q?YbR+dx/ufk5pJoHhmPnbK1XT47GvilTGyknSlgdhjQI8/mYyHWdY6QbeiX36?=
 =?us-ascii?Q?L4I4G6alHDlLwJ40FXf5qIqAvFnZDU58Z80KJxhdZyW9kXdEJSKouThb9wLm?=
 =?us-ascii?Q?Z+rlhuml6tT+nntaslgqBCIn3XLdiZ5GdAN4fnQS4vCzbxmKTX4+/zcy4Wtl?=
 =?us-ascii?Q?AU+Y5PKtzQuGrlUCm8gJWIVJ+gusP4mxRyg4ht4k0vnpM34u2sWbJH+6bwVh?=
 =?us-ascii?Q?8jf2dpz3GmT6GDyMEz0vufuzPqWNbKOrcdsxCwrAZiuz0XBcRU+WjVLmq1Oj?=
 =?us-ascii?Q?wAB7+s71MjMbWevchNA1ytw2WvGHHQIZpKguHJ6IGCXA+QzkdtqgsdMVu4Zp?=
 =?us-ascii?Q?x4qTCO5QMoHOjBsFWew2U+CcQzyuIOmnazwQJ/6ba07pooRUgcIQXbXPFDAZ?=
 =?us-ascii?Q?iBO7wMKILFvvq6Hb8THAoK/QeyMWTmX/mD/nCU3e+/agBsjqN7dfwhxar42G?=
 =?us-ascii?Q?Cb5Mnw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4287fc28-1c16-4125-b7c1-08d9aba51107
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 21:39:29.4786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: atwotOl+AoE5NmgwAeyZLocZa++k2ujQ6XEybT2i9NYbSRmnk3fjqcH5phltBh4Z2t0AvBnDqyNsnIJdPhMcgyZRD6Ww53gVxciTgUMacns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2304
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch seville to use of_mdiobus_register(bus, NULL) instead of just
mdiobus_register. This code is about to be pulled into a separate module
that can optionally define ports by the device_node.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 899b98193b4a..db124922c374 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -10,6 +10,7 @@
 #include <linux/pcs-lynx.h>
 #include <linux/dsa/ocelot.h>
 #include <linux/iopoll.h>
+#include <linux/of_mdio.h>
 #include "felix.h"
 
 #define MSCC_MIIM_CMD_OPR_WRITE			BIT(1)
@@ -1112,7 +1113,7 @@ static int vsc9953_mdio_bus_alloc(struct ocelot *ocelot)
 	snprintf(bus->id, MII_BUS_ID_SIZE, "%s-imdio", dev_name(dev));
 
 	/* Needed in order to initialize the bus mutex lock */
-	rc = mdiobus_register(bus);
+	rc = of_mdiobus_register(bus, NULL);
 	if (rc < 0) {
 		dev_err(dev, "failed to register MDIO bus\n");
 		return rc;
-- 
2.25.1

