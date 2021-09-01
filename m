Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A463FE5DB
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344467AbhIAWwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 18:52:34 -0400
Received: from mail-eopbgr00087.outbound.protection.outlook.com ([40.107.0.87]:32899
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243383AbhIAWwM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 18:52:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QWKL7dsEvX6Zp0M10hrOz8tMNWtDcZL+Bdgemh+j+X6vSUFVEOnYtuWxs9Y8r40UIU/35qt8w275z52JkeIao0tZyAkqmCX5ClQ8onqdIdPZDE2DM8p2AN1ssVmQ9s0vkaMLiop01VcDiveYoNHQ9Mdha1E94kTvOMhixfsM4280RHokqGSJCFlq3e1eIMqKDostGSzEq1P7ZiAep8QLrtGW3r/RobzOqx7JnrdN6CLLYga/CCnVIrapqFdfwp6MCDvxQM0bH5DZDALENK8/62kJmDNJGUhSQDuJxiM/rXUS/r5UobVulXrmAx+6/eYO0G9qwBQKH14iMku+CyDeIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=rQPJ05F5JebNF2FJ90pWZCThDfbAb9Db0DUCkr+NfEE=;
 b=YjxF78oXhVjot6uo/ApV/SySkrPHDFNvREE2BcyUNYANm8+3Sn3o6k+Np1+aCG9cL6zeg0EnPNICjb038s9HD8ZSmLFiRUWltfg8a04BbEdn/jeI+eoecS6Zp+XwK/OyZuZ1xJJPU9VPjD0p5xpXoPn2H9UwTlbR2flRw0peyfMPm6CjUz8a3TP+HcJotLxEzV9bBIjSIbfXP0prHhK0+xQ7uOpS7tma640+1oHivdRHJ5Dn7j3gAUkPBv4am6pyzJm1j+e6jYPH0gxYMPqJxZXTz775WJRpaZmhnHLjVzm1XDh2xKIOJRf8YEOMq8H2rIcUs6QyPHnYuj/siAYS+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rQPJ05F5JebNF2FJ90pWZCThDfbAb9Db0DUCkr+NfEE=;
 b=MgsGqnQ7fYjWbkc1UMDVUHuUe4zdB6glvhdL5ifXKfF9cptjN5yK87lYLa6IC0rR/Fw0OMl9yBlR1ueWcYPoVBmRqUVYg98wN66pApetREcQJWhw5YVC+ochoSngdvVboy5JgVwkh+cxBNuaoCe6+QxS+Fl2JpzAkYRGOqLEj5U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6015.eurprd04.prod.outlook.com (2603:10a6:803:d8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Wed, 1 Sep
 2021 22:51:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4457.026; Wed, 1 Sep 2021
 22:51:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        kernel-team <kernel-team@android.com>,
        Len Brown <lenb@kernel.org>
Subject: [RFC PATCH net-next 2/3] net: dsa: destroy the phylink instance on any error in dsa_slave_phy_setup
Date:   Thu,  2 Sep 2021 01:50:52 +0300
Message-Id: <20210901225053.1205571-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
References: <20210901225053.1205571-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR04CA0130.eurprd04.prod.outlook.com (2603:10a6:207::14)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by AM3PR04CA0130.eurprd04.prod.outlook.com (2603:10a6:207::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19 via Frontend Transport; Wed, 1 Sep 2021 22:51:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a11dfae5-39f6-409a-532d-08d96d9afcc7
X-MS-TrafficTypeDiagnostic: VI1PR04MB6015:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6015E7A289C29C650D0AA4D3E0CD9@VI1PR04MB6015.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ya59+eQTQFNz35vpDQOiEIf69UH6vtcvoqd+F2xM2wlfsijjpQ+CuTw5iK5LHuFXP6smEwSZgNh7xTquZMdAPKicHfEWCrKuK/voTLfm3Cc0YobNDBmc9tt7FqLTKYmaBSbju9YiqZae2z14qr0mEuLCsykEpsrMk3JOp69MB8QYSrjVbqwu7H69c+jYB+QkN4DWNUE0MmZAOitUErz9eYG2k37j+9VPNChF05tGEqXaWiENVfAHSc3YSuLkU1AhH1dlv7hjpMokJHBLG2N8GEvS9aKvnArF157A2lRopP5Bazss+RzX+GhPGW9rV0SmD2Y932aKMJSExggLo6N5Dt+R9IwLDMwETBhdwATlIMQ22hUNfSIxDYjdKdfqvH0ocbB+0Wm/x90qvi5+8KVW/GGk97KzVK4ytTFMUvLwkuMN5EJcBBceLMKpvbmIs8tatw4C8ha5Sir2EMgtR44o5DvrgrIiIn0u3PuIlGHS2EZImsUb+ERokP9r2/j0JlDj+ugccBirOQYfFjfvJwuuBBp1M9a8BUz/3xcsFWSyqHEEuszBR6k+0Y91wUcYcZJuWitpnuI2uqqsJrrcz8f3gsQ0ftP5VI1R0GRtNdvvwT/YTDxbRplVSCOlqEORiPcINEMvQ47rplhyCcf5X/1inlJ5qN3RRAijuSijrxTqSkorV1rLRP7rsADsmD84huwbHYwnaI5AhS+YtpW6w98jMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(39860400002)(376002)(346002)(66556008)(66476007)(83380400001)(186003)(8936002)(66946007)(26005)(6506007)(52116002)(316002)(36756003)(478600001)(5660300002)(6916009)(2906002)(7416002)(4326008)(6666004)(956004)(86362001)(2616005)(6486002)(6512007)(44832011)(1076003)(38100700002)(54906003)(8676002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jk+3qOdtAEXLgWCrqGPlMhnJb0X1yoxbl0aXqUDOJI2QT4F4CZf4S5Bq9vdQ?=
 =?us-ascii?Q?K7y2Be3XPmkySx1kYAncb6R/dxO74iyEOYVL4U3JCKNw41Sz2p0gQW5Ivoxv?=
 =?us-ascii?Q?kUOqHxRFO90JE6Wy69NV8DtzZmdRPjXjWh4YPrk7xwWAEdPkUyupxEyUiYA+?=
 =?us-ascii?Q?1rTg8Y8WhThCu2deqmc+5k9pjlrI9CYnZVoUf4NTNXO9iLUzMEiGDvaX/fE5?=
 =?us-ascii?Q?x2JENUTo9KQJ7Q7377PZscfe0kzB9P6QY8LYhRfNyMdfT2oWr7+mYXA1kmx4?=
 =?us-ascii?Q?2ZNkMJU7Bi/dvJF77oerxFdz4HpavWeXKgODrMrJZTUpFXfHOkjNLSqonZO4?=
 =?us-ascii?Q?yyUNfRdDeJAhn2LIgBl/mhLpFeWwX3+LuIAHk4wZVMqYK39CFo25jxXKDNty?=
 =?us-ascii?Q?Mqrpa7OXkNvqUdAwgriOghlN+RkNFDd0UK9C1NhIqS+qLcatlc4890lc6NtO?=
 =?us-ascii?Q?nEHR/Ki07sVaT5T4JLSu7V3ZMkuW+ZEn4PJByT2Wlk+GTleUjTuCHZoagPrO?=
 =?us-ascii?Q?POuOH/H2TE2Ydjv1MzoZM+fESHDXuZpPQAlVernloEQ0GixJDqsY30+nYiZP?=
 =?us-ascii?Q?nr0JHkc7mjVjflNx71MK+z43/0/eoGnZqyaJzsg9TmHoaGmzhYC+d2Jxt/cb?=
 =?us-ascii?Q?Qf5Xf13RlT1wHGR2EkSDuZK3HJsrik4Z/xMxYomQWxpIk3ZNo8IZOgEBNV/Z?=
 =?us-ascii?Q?5KUUXkuNsimbB0gZrITtKMZzKwCAYo9BX+sbQWjfLnqRlo1dtXNE1WBsx0f9?=
 =?us-ascii?Q?7m4Y7yduiRl0HSAuGM08CpEDIagOC73XIJlQRmlzg0FoxGTti9oRM526NQfP?=
 =?us-ascii?Q?Kb/XGZhaEd9XlyPfHS5Iy+y0sN04+dUIQ0HFZ/wQq7XtkxFxyzB7CUkZPWpJ?=
 =?us-ascii?Q?yeu5HnIGJClF5rSrq3sEi5SWpVoLJCRbuwV5Dv/Iv3YNIceR5/Yu8PJNR6UN?=
 =?us-ascii?Q?aK9cxhpLgv+5qdZx7I675MwvDXvbNSyVxuIpvNuWeVl2kWNUFSkyx7LrUfFP?=
 =?us-ascii?Q?uIuJHzV3GeLM6is/y/ImtRtnTnQ2yHk0pyZFHc6FLzv3Z/Zu8DUG+ZfW5fJA?=
 =?us-ascii?Q?TFLjtnzDQPJ17oHXkBGyeSqjCsI7tjVwfb0K5fHoy52lcC6xOdU3FPXfUzfN?=
 =?us-ascii?Q?yNSQLsjb2HFA6nVwet0JxxjJE+Qkj+rvGt+k4LYGjcUpLA3KQja3Ew6ldocc?=
 =?us-ascii?Q?AraFXz3Rfty2HTzl9gVkRtCcIilAldUGU2l07OG4bqiIG9ur6HiJFAjYhrPr?=
 =?us-ascii?Q?PLitNu9hlFpqIAw9o/qXBiYXVw6m6/2lOGVcgoLBOveEUPMuKiMwOXniD4fe?=
 =?us-ascii?Q?o6OCOWIdPsgxXznP98DT/hVC?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a11dfae5-39f6-409a-532d-08d96d9afcc7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2021 22:51:08.4637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fx4m0dAXCAAVqG6t/qRr/uQUkCwjU3BpgqBUmIsEchETGsteqQ1yeRFGTZHkdMZ0NDmP2lU4Rbn8wEAk1LeGjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6015
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA supports connecting to a phy-handle, and has a fallback to a non-OF
based method of connecting to an internal PHY on the switch's own MDIO
bus, if no phy-handle and no fixed-link nodes were present.

The -ENODEV error code from the first attempt (phylink_of_phy_connect)
is what triggers the second attempt (phylink_connect_phy).

However, when the first attempt returns a different error code than
-ENODEV, this results in an unbalance of calls to phylink_create and
phylink_destroy by the time we exit the function. The phylink instance
has leaked.

There are many other error codes that can be returned by
phylink_of_phy_connect. For example, phylink_validate returns -EINVAL.
So this is a practical issue too.

Fixes: aab9c4067d23 ("net: dsa: Plug in PHYLINK support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
I know, I will send this bug fix to "net" too, this is provided just for
testing purposes, and for the completeness of the patch set.

 net/dsa/slave.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a7a114b9cb77..8a395290267c 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1856,13 +1856,11 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 		 * use the switch internal MDIO bus instead
 		 */
 		ret = dsa_slave_phy_connect(slave_dev, dp->index, phy_flags);
-		if (ret) {
-			netdev_err(slave_dev,
-				   "failed to connect to port %d: %d\n",
-				   dp->index, ret);
-			phylink_destroy(dp->pl);
-			return ret;
-		}
+	}
+	if (ret) {
+		netdev_err(slave_dev, "failed to connect to PHY: %pe\n",
+			   ERR_PTR(ret));
+		phylink_destroy(dp->pl);
 	}
 
 	return ret;
-- 
2.25.1

