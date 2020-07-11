Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B028021C2E4
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 08:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgGKG4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 02:56:37 -0400
Received: from mail-vi1eur05on2070.outbound.protection.outlook.com ([40.107.21.70]:33732
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728034AbgGKG4h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jul 2020 02:56:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I69L43SKxqSUhK8TmfXcFPdpsG+/yVzwK6Vn6AVKedVgZTkzGLPpR7HlRAJcHSJiTOTEotLwVbh8fujkMKqlpwVu9/YvHFq2VoeNs/6UZmVJzlMKKLvTJ71qzsvDkk9sNxu0baxwTwbnSYAzeaz7I7zOkPZ/l8kNIwJC6lgaeEVAZ2A8Mz2qO8UnpyQvpTzTJgfWUh/HLgPf7XN+Rm/5gBc8MqiFMBBVx0aNy9JCObwfHRN42oWYr5jTXBysObi3nqKyRiHYZ/xXjLHIDpINq8YjJwLNqwMo4/9okubV45NupAwYJO4ZVSgBP8ZIYw44SVtxg56Kbj75zVFuRvsL9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fWe0OW3zi7RdNY5E5qGDFgWmQv1EvPToA/XxTTl8xd0=;
 b=OxjG1T3Uzk8ilQn/+FIZx7iPCKKrwQuiMhDXxeI4p0NwJz/NVffzSCZ2HTnwih/p1SryHcw5ksQfbdk9qAH3woFFHG6h8pOL4vXc3jBN4XMUOD4azy13BvQCCK7WGQlDJELzKfap8UFChfqaDYQFSYcxUNCDmpmyOPUajOLyLslU2VqWPLtiHrd5ETF+OYWV6ANs9AoNNHVFpVaLvnPzjH7qgT2ne3kcpyNmn9dj6pMckVIlpEgFBaitFpLCU20NLiTUuzo0EXVYAFCTNkQ0FSN/4zSBKA+6SJ/uu5bu7Tg0TylFdmEXralH+LVOwCbWv+tdV0nbqV6snJ38SkQseg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fWe0OW3zi7RdNY5E5qGDFgWmQv1EvPToA/XxTTl8xd0=;
 b=BkaZ+YvOg4bJP+dBbDzLy2GMp6IfzGILhxxlKEsDRZrwd03uCX198n1ysnWjwXxkE4PmF6A6y+NBmNMBY+coOWTkuMa1msarW59ahyQxKB0mEk/RiJc1DzCSv26Df54YYUsWM4771vy4x2qDvmt197rk1bgOl8ThgcOOFgymZbk=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6961.eurprd04.prod.outlook.com (2603:10a6:208:180::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Sat, 11 Jul
 2020 06:56:32 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.023; Sat, 11 Jul 2020
 06:56:32 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v6 0/6]  ACPI support for dpaa2 MAC driver.
Date:   Sat, 11 Jul 2020 12:25:54 +0530
Message-Id: <20200711065600.9448-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0132.apcprd06.prod.outlook.com
 (2603:1096:1:1d::34) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0132.apcprd06.prod.outlook.com (2603:1096:1:1d::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Sat, 11 Jul 2020 06:56:28 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 93cfe10e-d796-4a6c-1547-08d825678b03
X-MS-TrafficTypeDiagnostic: AM0PR04MB6961:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6961464A079F5ECCC98B8D3ED2620@AM0PR04MB6961.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GCLN3+aL69t7NyzWg6XDYnp5KvIyQb4ABTNnAI5LiJkDxg6T0yHEdZL1ry2P+P9a/poeB/aAyW0AyHVcg1k3LIG4KqET/alL248zpwworU2iUitK3E6YBdYNil76VpLCe6uOZOUKkUmepVBDkmSMPrJH8124+1VulQSjqTTo+u0BGktSnaURlpSdpHyFflaG3lG1CzQCPU7VJJpQ6T7MKIv+UHnSxhzwBu8TnMiQwPySinV1D9LLoAKU9HQQRSY+WzvgJodMfjGPwL4Ek+8/jhiNbjVrNOOgQxiENLq1ZG0bGVIFHci/CVCOOdM0LavyRvD3yTmZXeytRgH7h/MKULn4MEfHiDjprl+ESCovsVTEfEQnE0BqjNEoOvklauVFmT0KBZTcjKXsz16Pj5NLsEHAqB4gzIedCWmDBR0aX8OcwUFEiCuOsJmNi1IARN1YNI6btj+d0PYB7nrdwsYM/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(376002)(366004)(136003)(346002)(26005)(6636002)(16526019)(186003)(110136005)(55236004)(66476007)(44832011)(6666004)(66946007)(66556008)(5660300002)(2616005)(8676002)(52116002)(1006002)(966005)(6512007)(316002)(6486002)(6506007)(956004)(1076003)(4326008)(2906002)(83380400001)(478600001)(8936002)(86362001)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gXhGokRbJylsIsv+x4ZdKRlqcZN0sw8Z4wAbI72zTWh1a/fqR1zHHsPml/6QNZMjMx8y3xYOhPzxEejPyesBp6uxnD2sGzH+bi81x/NQy4Cqyy2nBREh4h20D1w7zQI56a+bOyO1MXw036jg6YFVp/kpyHPR6Hxbd+pALhGr+YaiIG8bqUzFiiqt5j84NZJY0gO710f3kEqqQXhnwXAbWYKwjTW2qe7/MJnh1/4+F7vMYOGgZ34VJyJy/BcsZFicVaG9G6Lu19HW9hHTxx1rmX7+fqtm7sYZF25Aj9D6nzPMKJJE+zGnE4023XWI4W7WcdmiNSFhlGzDLFnIX72s7ba+vNKtBU4er0o6PqW48Skvd5H1LRnTS8Ef3Ta/hYQAy+BUmSNvf7PBf4pz8ls3RdGeq/4oBh1SiL9bpPF7XZGjlk0P3Y4GZ+FaqJ+LSoxo8yVcOkc8gxOTOBnFPl9rbQ7vprxPRNkljbG46Zj7aYKNG+//rn/I90GP6JRJIFO7
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93cfe10e-d796-4a6c-1547-08d825678b03
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2020 06:56:32.0187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9GNIh5JQlERCKCSsjNcvOB7PMvq+BfjzeJVvqDOg9mnvZ/FeDdbaur1Jgb12syg5//30pDShKkoB203810EN/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6961
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 This patch series provides ACPI support for dpaa2 MAC driver.
 This also introduces ACPI mechanism to get PHYs registered on a
 MDIO bus and provide them to be connected to MAC.

 This patchset is dependent on the review patches available on:
https://git.kernel.org/pub/scm/linux/kernel/git/lpieralisi/linux.git/log/?h=for-review/acpi-iort-id-rework

 Device Tree can be tested with the below change which is also available in
the above referenced review patches:

--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -931,6 +931,7 @@ static int fsl_mc_bus_probe(struct platform_device *pdev)
        if (error < 0)
                goto error_cleanup_mc_io;

+       mc_bus_dev->dev.fwnode = pdev->dev.fwnode;
        mc->root_mc_bus_dev = mc_bus_dev;
        return 0;


Changes in v6:
- change device_mdiobus_register() parameter position
- improve documentation
- change device_mdiobus_register() parameter position
- clean up phylink_fwnode_phy_connect()

Changes in v5:
- add description
- clean up if else
- rename phy_find_by_fwnode() to phy_find_by_mdio_handle()
- add docment for phy_find_by_mdio_handle()
- error out DT in phy_find_by_mdio_handle()
- clean up err return
- return -EINVAL for invalid fwnode

Changes in v4:
- release fwnode_mdio after use
- return ERR_PTR instead of NULL
- introduce device_mdiobus_register()

Changes in v3:
- cleanup based on v2 comments
- Added description for more properties
- Added MDIO node DSDT entry
- introduce fwnode_mdio_find_bus()
- renamed and improved phy_find_by_fwnode()
- cleanup based on v2 comments
- move code into phylink_fwnode_phy_connect()

Changes in v2:
- clean up dpaa2_mac_get_node()
- introduce find_phy_device()
- use acpi_find_child_device()

Calvin Johnson (6):
  Documentation: ACPI: DSD: Document MDIO PHY
  net: phy: introduce device_mdiobus_register()
  net/fsl: use device_mdiobus_register()
  net: phy: introduce phy_find_by_mdio_handle()
  phylink: introduce phylink_fwnode_phy_connect()
  net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver

 Documentation/firmware-guide/acpi/dsd/phy.rst | 90 +++++++++++++++++++
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 70 ++++++++-------
 drivers/net/ethernet/freescale/xgmac_mdio.c   |  3 +-
 drivers/net/phy/mdio_bus.c                    | 51 +++++++++++
 drivers/net/phy/phy_device.c                  | 40 +++++++++
 drivers/net/phy/phylink.c                     | 31 +++++++
 include/linux/mdio.h                          |  1 +
 include/linux/phy.h                           |  2 +
 include/linux/phylink.h                       |  3 +
 9 files changed, 259 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst

-- 
2.17.1

