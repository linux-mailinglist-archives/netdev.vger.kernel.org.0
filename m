Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D1E22D814
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 16:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgGYOYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 10:24:52 -0400
Received: from mail-eopbgr30045.outbound.protection.outlook.com ([40.107.3.45]:6534
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726944AbgGYOYw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 25 Jul 2020 10:24:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JigzsKC4RbN+FuBloodpb0A85sZbIewx5KfvLk+mMnEEbrC+/m7nD3zXR3adlj00GCA4er8Aql1+MmMbEeVvCgm7sV/9b+bCGTTGVvzFgU/u4UvadWuPo1Gl2pUw+8IqnAyEt8ReltUkIoHp4vcV0kWLN4QQD9dweO2Nl9T6MUicb2439nNAPYdCV3qOpqUG1n/uZOoY0gUVlbHapncYSOEYcpaHsPlSyg+GfUW52JiqoxFRYmEHL6gwcKAfBEbVCcbHox7ROsvEEgU1x1EoC6JROrcFzcCxMWsUoj8Or1c0PmSjIqhVE+vRLIJ/4R2NRj3VeWr86xeyjDB7BMkdAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XmmbJQp0vTEO3NaNO0vOrrCFuL+QnARjXIg3LMD4DTE=;
 b=PTSu+N3FVVBP2qHj5D7E/UOSvFIT9lsvuqHLTbHwLS6a1hU/TJDJxwPeWU96PPrMi3RQADU1fc0CHl9BtcxOIHncgCxz5+BYTB1bEAqWW3RtD4xLnB9zmGDzJnckfqw7A0q1VIATVJvUPErSU8RE2+z/57xGtawfHCmSZ8TcgDOlg7xE01FZrBGQ/FCnjUKzwIKjcVlvWYhMmV+Bz+6IcHgHWUjHzSQMW0eORLzMKKgPhb+TbAoXmkgi6pNWMocSZ381o/VvE5fMk47yFTaVYx/aTXcoZfOyJPj1i5GI8x+nzQGXGjBM20LNVqvJzTJugNmDr0ywTSxdpkp8O0I6sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XmmbJQp0vTEO3NaNO0vOrrCFuL+QnARjXIg3LMD4DTE=;
 b=lniZCXZYTLAVy66g+O9NDd91guNQiYmExqre6LeaaQjdxSDdapYWMllYPIwHBszSx/zcFu4+foyZZrckb7F6Dmlp4tuqcEYFh/gErzQKXDA0pll4GEhKIv1VD4HcmC71WKPaQN73sNE/WZGGDQG+P6NAdGIs+EDsyA8RfPkZLgc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4931.eurprd04.prod.outlook.com (2603:10a6:208:c1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.22; Sat, 25 Jul
 2020 14:24:47 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::b1ae:d2cd:6170:bf76]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::b1ae:d2cd:6170:bf76%7]) with mapi id 15.20.3216.027; Sat, 25 Jul 2020
 14:24:47 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Al Stone <ahs3@redhat.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        linux.cj@gmail.com, Paul Yang <Paul.Yang@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v7 0/6]  ACPI support for dpaa2 MAC driver.
Date:   Sat, 25 Jul 2020 19:53:58 +0530
Message-Id: <20200725142404.30634-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR0302CA0018.apcprd03.prod.outlook.com
 (2603:1096:3:2::28) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR0302CA0018.apcprd03.prod.outlook.com (2603:1096:3:2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Sat, 25 Jul 2020 14:24:42 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bb1c84a3-3c1a-4df7-b137-08d830a67bd7
X-MS-TrafficTypeDiagnostic: AM0PR04MB4931:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB49310E4A95BF9320C6A620B0D2740@AM0PR04MB4931.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eAmvAAWO4bguIjnDzZe+S527WMNeTlBrhBS++N3oU3JHImXOGlfaF3EgvAsp4yZxZJA9FDyscKlWWT3B91jL8mSTzqgmxcUNOsd6GNXHGJm9GZXgGRhr1EwjOg1nJ6K9Zig1tpBH25ecL3cEjhYE77+wTFw5+VLaxl9fzUR5fBfdu1a2/+TdbIRL5569F40wIhzeOq4EzjWzWNM7PHakuqsoKt5or65evfDJnPqq4O+lACtYcSA1JdignHJOEe/lT2AdrGvz/prQhGRMKp0vXDsL63ZQKePCurYqX1MIYZpElp9YMqJ3L8E3GPthpJ8IZfP/uiWJGoVbZ9G3QD+KmNkmwNooykEjScrwdou4AMclF8PslspAwPUBhrex8O7ltZUk6FpdSe1FQJqOF0Z5tIXs/RrzFhKNOU8Tynf8MqHYmA53AcQTRC7hNTRRPeDO4VHo6+l0yYmKz/eOeZUVTOTKMUZCtnGn7vghiPH8sHo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(66946007)(66476007)(5660300002)(6506007)(966005)(6512007)(86362001)(55236004)(52116002)(478600001)(44832011)(110136005)(8676002)(316002)(54906003)(1076003)(66556008)(4326008)(16526019)(956004)(2616005)(26005)(8936002)(6636002)(186003)(83380400001)(2906002)(6486002)(6666004)(1006002)(7416002)(110426005)(921003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: P0QbSvefBaYA5BJEbwp9RK0v15sKzJGCJ3qUcvaL+9VDapzWysZ2N8j+mBENi9C3hFPWez7xO3ULR5HA1igSwEGQ8EN1XxzGkdnq+OxjIVtiZUDm08ufi0h0NeR5SFTqAB1gHNy2Ysuv95I8AYcARpO4AtcBaTWEx565+j9kCcFcH5FFp+DqDUBhyqZXNVbGRoLheGjS4FDbaHLIGOqy5xktZVoDnNiaJWAr+fZquvQUmwsoh+jea9AFKhPabdG/372WqsC5dugeHYLlHIVYNU/nOyj2+dv1qxBUkNyqHbabi8kA9PjYGMsUmcygdSuwH5tHJ6UiWxWpd2gD5Z1bXd0TNqrs+rkJuqyDtyGYIuGsBudsxLSoWrqLBRv+QGf9xEgFgOJn5HR7P7kVtPhz757oSZUqbApcmHrD4eahJJpFf+Od8yxaF7RHst/Zb7ENHX7neF+mFmMmbZlt0ytFgkNahn+0Xzd02xyeZ3aKTcKZU0XRucg7FHhIDJFcnvJ0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb1c84a3-3c1a-4df7-b137-08d830a67bd7
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2020 14:24:47.5381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oRFFxJ2FjvqeByCe7E9aukkPxXEwex+A8brRX+ESqhwE2tHwUnK2NmOaSzyYprpA+4Z1mRKyQI/WoXUX5yz24Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4931
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 This patch series provides ACPI support for dpaa2 MAC driver.
 This also introduces ACPI mechanism to get PHYs registered on a
 MDIO bus and provide them to be connected to MAC.

 Previous discussions on this patchset is available at:
 https://lore.kernel.org/linux-acpi/20200715090400.4733-1-calvin.johnson@oss.nxp.com/T/#t

 Patch "net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver" depends on
 https://git.kernel.org/pub/scm/linux/kernel/git/lpieralisi/linux.git/commit/?h=acpi/for-next&id=c279c4cf5bcd3c55b4fb9709d9036cd1bfe3beb8
 Remaining patches are independent of the above patch and can be applied without
 any issues.

 Device Tree can be tested on LX2160A-RDB with the below change which is also
available in the above referenced patches:

--- a/drivers/bus/fsl-mc/fsl-mc-bus.c
+++ b/drivers/bus/fsl-mc/fsl-mc-bus.c
@@ -931,6 +931,7 @@ static int fsl_mc_bus_probe(struct platform_device *pdev)
        if (error < 0)
                goto error_cleanup_mc_io;

+       mc_bus_dev->dev.fwnode = pdev->dev.fwnode;
        mc->root_mc_bus_dev = mc_bus_dev;
        return 0;


Changes in v7:
- remove unnecessary -ve check for u32 var
- assign flags to phy_dev

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
 drivers/net/phy/phylink.c                     | 32 +++++++
 include/linux/mdio.h                          |  1 +
 include/linux/phy.h                           |  2 +
 include/linux/phylink.h                       |  3 +
 9 files changed, 260 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst

-- 
2.17.1

