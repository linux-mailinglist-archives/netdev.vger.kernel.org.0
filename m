Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A023136DF
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbhBHPRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:17:00 -0500
Received: from mail-db8eur05on2084.outbound.protection.outlook.com ([40.107.20.84]:39337
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233482AbhBHPOK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 10:14:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EhB1hXBmOftDsM/GNmaarXQ6DH7NTt99Wvi0ll9h2xX0vDrkbMRT9BcRhozNuN8bepucLgzGv4V++6EklT/OhrUYzl9fctRqrMi2xqeR5MZ1WKy533fNpzdZZsh/2J9kJ0Kg//Afg33GGi7qIaTaBGOL02pHLp0KNk6YBVbHlX2/S3NtTaSxubo+cfMkQ2Jf3cemp7nf1e1zHVpYbA6buLJBlpnpzgDs6h3VywZz/2JGtY/w60/ZxMerBIQHRzMuRQ2QIBfJr7uJxOFUsYbhNcKojcpj+sW1fYfukasCoNxjQpb80MEvvpHC9p94dX/K4flVq8HrwHEFz4StoJxHxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+5yzSsyfsdcAQVk5iLfJN/F9rJ8Plk/O4oRJKZ96w4=;
 b=ZjX/AmplGcfV/1XbUTJmthnGxszQSIkn8KTszP+IPQ6CaE4+839z/PZ1eNdiQ5NToGksyVELpo8uc2TrvGbA5zwEHyQJbR6ccAUSf82VuqApUg6CSNx3GhbBxBtr/NrjEEy78NALIG012zTBmqwPrDbnD48+a3jMQkLmEmgV3LnNocZCpjolmQSmv/645YKi8cC/ZCFAKAZMtUeA1svIOh4tNh/xLSJ9CBPhpYoYHFBIxkUL+T3VKo+lfHRODpOVlb+I5Zye7bFPKVikIOHHEauXHfbSpUxAoEFkn88Z5h+bFYUukciT+AHzIvfLo3d4kDZ3ijjA2MRBkjfRcQedYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H+5yzSsyfsdcAQVk5iLfJN/F9rJ8Plk/O4oRJKZ96w4=;
 b=kshEmpkQJ4iUg8dFYGssNOuHLdSrmaPHv1j1xy6Wfriqp00EnHwQsjG+at8rGiQC37iG+UTiezKXnlcDB4kjnMgdk6XiVhlw76cEyO31wmpxlTlW48GsYVrwjHTp18JNhiuAm1ZAEaSnSOzUsAEuv45hkX5POUBSluqTlD5fz8Y=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6435.eurprd04.prod.outlook.com (2603:10a6:208:176::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Mon, 8 Feb
 2021 15:13:18 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%6]) with mapi id 15.20.3825.030; Mon, 8 Feb 2021
 15:13:18 +0000
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
        Frank Rowand <frowand.list@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamie Iles <jamie@nuviainc.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [net-next PATCH v5 00/15] ACPI support for dpaa2 driver
Date:   Mon,  8 Feb 2021 20:42:29 +0530
Message-Id: <20210208151244.16338-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR04CA0176.apcprd04.prod.outlook.com
 (2603:1096:4:14::14) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR04CA0176.apcprd04.prod.outlook.com (2603:1096:4:14::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Mon, 8 Feb 2021 15:13:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7650e3e0-e55a-488d-39d1-08d8cc441085
X-MS-TrafficTypeDiagnostic: AM0PR04MB6435:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB64357C6C4889F61DBABFD9CDD28F9@AM0PR04MB6435.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xl9W5F3xTjYLnVtd+cuflWOYwCOGJprBdax0jLl6ghiVt01kjZVK+LYzNFoEDDzNM26ouCX+lSbI+T3dtku89KWBtXmyU4IhWEdIfqV8tyakhK+tq8zJMRU2yzHbUZmGZo4dMxQkJnKX0wid00DLJwwPq2PzSGlNhPHC78qqmIDeBAqoI1MffYjmMMo4KT9SLZuHFpK8xWtVoNVSaSUKN9ZpG1t6J1vKywywzuSrDGpth3LZZ2m5q1Fl4ZGpTFGG4AOIvWFwyiB1o0oUikhPcJl041yFKSdkvlM5L1SjlNZjNT69iWf8GuSoKu7o0cshdr8UjYMNZYWHIfcq2GzsHDDrMWX6U2g2xwbyGkH74buBg4Q/q5XNk7bjJvU4tgZDeu145TBateLE6BA8NZgiBd2aKhBSGQgpzZV/AAoc4RdoamFV40HmVnk5ojgKqo6MvYIMOJoAu75nYinBwluPx3wV857cOWbymb3nEkWjYurpNvmWqLXzpQaJM1OODIwzC4Sf7l2fh+V3mSR6sUaY+GFI5MmmceR46eWHuGYu3nJwAAvyJPvmGlL5HEo4ummwqF7PlHijHL8d2ZNFPXoUN2oPfMAArQWz2Op8COVcNy8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(8936002)(54906003)(7416002)(52116002)(110136005)(186003)(16526019)(316002)(55236004)(956004)(6486002)(6666004)(1006002)(4326008)(2906002)(478600001)(6512007)(1076003)(6506007)(5660300002)(921005)(44832011)(83380400001)(86362001)(66556008)(26005)(2616005)(66476007)(66946007)(8676002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?I7qRGO/vEocJ/x6sPHsFJVVwYleHgLt7fJE8ZpqYbsxPqHouaDC2GYFwjtxW?=
 =?us-ascii?Q?AncCIasxhOnWWqcuF4NOSuzl81VxEr4k5zY1CRxOMRzGGo7WPCziAH1KdZso?=
 =?us-ascii?Q?rtM6XOkRg+nRw75DbgU82YAiUA7Nt4n+OGMInbq62V2bbhadlhobeJdnAK5C?=
 =?us-ascii?Q?SQDgD/JgRDGzzlZniFwpClBQnay0MSauuPsxjjyiUqlCYU4S+g7MY/tQaf2I?=
 =?us-ascii?Q?wgwt/oZndDIsemctyYN/dBVlGt3VSI+vfBECEonTMnSU/UOeJSn1wP87wUir?=
 =?us-ascii?Q?7okBdDyeuJqJiB8SbesGbXD7WCKvE61qD6kvmv/68pmMJTkGxubDt33Wmq82?=
 =?us-ascii?Q?+I15PRNJBASlfeomWiCToy7GcFCu2sDL/7/GYCvYZ3iz42XkgRhspZMU88G0?=
 =?us-ascii?Q?TbfNDyDfurlP5IcJZLXN8q/dah3MHHEqJeajcpDm56UV0dqaFgmx5rT2Ouln?=
 =?us-ascii?Q?mTq16wiUuXhKCfKyOHPE6Pc/DXj+bnHf6uSE+XBPl64sChF8vGLBKc1dUd9v?=
 =?us-ascii?Q?kAim6ftKrXr55Mq2YKQvMfIgxkd9jdZawOnmTPlot9LI5TEnNvB3ZElQXl/9?=
 =?us-ascii?Q?ISolh/MH79GCQYJQTPuQi6dLHQ3ffgxMPe4GRo/Ek5BVqzPsFu5rOOEcDKtN?=
 =?us-ascii?Q?2rs2WDyAGsX52pIvSa+fX/PhIOnqDHk87U6XS2lHKFlGDmagmFp8J9h+EfAF?=
 =?us-ascii?Q?RdhCDtgE8wKNZhrE/Y3fBwrWRvYD2J/knaCRmrScnhOa70xLOvavRzT1KBVV?=
 =?us-ascii?Q?VPmrjNq+PYgh7ZGcrIlPdg68AuGDZXETis53AANqBr7k8PdCZwbUF5CIu8b/?=
 =?us-ascii?Q?jHBimZB/Js5x6F9Ds9DWo08xjCsCfQOXPTRDzkuopH0W8ti7bIhgwQ3b4MGD?=
 =?us-ascii?Q?XGCeBaixGl6qr4SiXG5BbJrXClWOaoDUsGmUSnmVZxf8XizQjf/9OpgkhgVB?=
 =?us-ascii?Q?7zw1ujInFNf6jHt8q1GEriWP/LGvDZcBEc/9912KWf0LNH86j7wph8F5ydeF?=
 =?us-ascii?Q?deEEtZ7tjANH2RDP+U8Jj/dFhWOLzqhADEf50B0tRE7AzgS6x19r8uQaUcnW?=
 =?us-ascii?Q?Z0dtSHZ993GJkglsnxNFiTCrFKMeBgV6DJCBF97EXTTdmlZx+KzgFbC9HmHg?=
 =?us-ascii?Q?SpKF3UvZkyBkw5Iys/BGRz6WCAi4ffQr+TP45Jw2Ggv1B55UzHVnk3DSy6Yg?=
 =?us-ascii?Q?g/TBcYyE18LYkQBHDSKxokL52sMloVj0gnnymjHZjwV+ds+Bs9mkoLaowoIa?=
 =?us-ascii?Q?Pz98N4O5SbMMKgxmIqCQvzTni2KyCpxoI3Je5tUgxpYHL/kUA4LEQtpsI3/i?=
 =?us-ascii?Q?vrLVkqt3FThVqNkt04uIArEy?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7650e3e0-e55a-488d-39d1-08d8cc441085
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 15:13:18.2062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nDFO8gz6ddv2sRivMe/hm496qW3SeuNPsVPq1DtsiIfZ2fThsVUjFZs+uep/D1NTG9U3A7YDquSSvzZbkLjYiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6435
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This patch set provides ACPI support to DPAA2 network drivers.

It also introduces new fwnode based APIs to support phylink and phy
layers
    Following functions are defined:
      phylink_fwnode_phy_connect()
      fwnode_mdiobus_register_phy()
      fwnode_mdiobus_register()
      fwnode_get_phy_id()
      fwnode_phy_find_device()
      device_phy_find_device()
      fwnode_get_phy_node()
      fwnode_mdio_find_device()
      acpi_get_local_address()

    First one helps in connecting phy to phylink instance.
    Next three helps in getting phy_id and registering phy to mdiobus
    Next two help in finding a phy on a mdiobus.
    Next one helps in getting phy_node from a fwnode.
    Last one is used to get local address from _ADR object.

    Corresponding OF functions are refactored.

Tested-on: T2080RDB, LS1046ARDB, LS2088ARDB and LX2160ARDB


Changes in v5:
- More cleanup
- Replace fwnode_get_id() with acpi_get_local_address()
- add missing MODULE_LICENSE()
- replace fwnode_get_id() with OF and ACPI function calls
- replace fwnode_get_id() with OF and ACPI function calls

Changes in v4:
- More cleanup
- Improve code structure to handle all cases
- Remove redundant else from fwnode_mdiobus_register()
- Cleanup xgmac_mdio_probe()
- call phy_device_free() before returning

Changes in v3:
- Add more info on legacy DT properties "phy" and "phy-device"
- Redefine fwnode_phy_find_device() to follow of_phy_find_device()
- Use traditional comparison pattern
- Use GENMASK
- Modified to retrieve reg property value for ACPI as well
- Resolved compilation issue with CONFIG_ACPI = n
- Added more info into documentation
- Use acpi_mdiobus_register()
- Avoid unnecessary line removal
- Remove unused inclusion of acpi.h

Changes in v2:
- Updated with more description in document
- use reverse christmas tree ordering for local variables
- Refactor OF functions to use fwnode functions

Calvin Johnson (15):
  Documentation: ACPI: DSD: Document MDIO PHY
  net: phy: Introduce fwnode_mdio_find_device()
  net: phy: Introduce phy related fwnode functions
  of: mdio: Refactor of_phy_find_device()
  net: phy: Introduce fwnode_get_phy_id()
  of: mdio: Refactor of_get_phy_id()
  net: mdiobus: Introduce fwnode_mdiobus_register_phy()
  of: mdio: Refactor of_mdiobus_register_phy()
  ACPI: utils: Introduce acpi_get_local_address()
  net: mdio: Add ACPI support code for mdio
  net: mdiobus: Introduce fwnode_mdiobus_register()
  net/fsl: Use fwnode_mdiobus_register()
  phylink: introduce phylink_fwnode_phy_connect()
  net: phylink: Refactor phylink_of_phy_connect()
  net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver

 Documentation/firmware-guide/acpi/dsd/phy.rst | 133 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 drivers/acpi/utils.c                          |  14 ++
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  91 +++++++-----
 drivers/net/ethernet/freescale/xgmac_mdio.c   |  11 +-
 drivers/net/mdio/Kconfig                      |   7 +
 drivers/net/mdio/Makefile                     |   1 +
 drivers/net/mdio/acpi_mdio.c                  |  51 +++++++
 drivers/net/mdio/of_mdio.c                    |  79 +----------
 drivers/net/phy/mdio_bus.c                    |  86 +++++++++++
 drivers/net/phy/phy_device.c                  | 106 ++++++++++++++
 drivers/net/phy/phylink.c                     |  53 ++++---
 include/linux/acpi.h                          |   7 +
 include/linux/acpi_mdio.h                     |  27 ++++
 include/linux/mdio.h                          |   2 +
 include/linux/of_mdio.h                       |   6 +-
 include/linux/phy.h                           |  32 +++++
 include/linux/phylink.h                       |   3 +
 18 files changed, 578 insertions(+), 132 deletions(-)
 create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
 create mode 100644 drivers/net/mdio/acpi_mdio.c
 create mode 100644 include/linux/acpi_mdio.h

-- 
2.17.1

