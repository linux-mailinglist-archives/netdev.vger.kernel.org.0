Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECE9300AF7
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 19:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729313AbhAVSSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 13:18:24 -0500
Received: from mail-db8eur05on2065.outbound.protection.outlook.com ([40.107.20.65]:39968
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728946AbhAVPoi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 10:44:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OnbbCgGIIPuo3Obw8bWwcsW6a71gM8VYVazDYGUCtUCokXbpBoro3/hKjqLh9EtQGqNGXu4XPToCuP2/ggkDfiyWfaxdZfBbrl1zFk0Xhh+nrZnNwVdeNx4pY4/O9JgUuOD4dl4y9JbRV168tUekmCC8JgZVMD4ZwmSAk5Qov3HshJf8uUMLGBE6+1JRnqXDaRNRR4L4qBJ8oJqoHlPRxcNjyb147BYLewcvoBW2FriJZsyEPfIBGQCxgbSLD4hg4LYd18Rb44aJYDvQfAb59U8q3Ol1KkfjGG3DpA7oxDxXk6fBFzH0X3guSdvpvnuk88Iga9DX2Ky5NDfavSQE3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IjJn7uPAaHINPXdnrgdmO3r3z9D8XcyXdkx0HcMc+qU=;
 b=T0FWSEbUqozHtvtDLNcRmmRUG1GfZXsLhjv3SLnIu3nLd8eSrqSBZTHcNrrILoT7L1ICvsszKgPUKDhwY3XMmyUj/9YZoVGHD9pujjliXsuVFCzaGHt1SXB8vlKVsWJbLPgKvgU90u8pBrrLKq8kbF6X+tf6rcCVVf7yeyvz3U7NJE0wOS8q0y8+l/880cA5PmABD5WK2L54kKp7LGTtaEBetEOuEYJbhbnqUFCHuBp25u3lnLlV6J9T+I3ZrVZE1k1Am4qTTsclrPCYY38JClCCrRAJPqYzrxcc0WD4RfoxoSrRtcxyQcnDcEWJUlSehcZSIsBLJB3oJBLZpLpJuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IjJn7uPAaHINPXdnrgdmO3r3z9D8XcyXdkx0HcMc+qU=;
 b=hl5agb26fmWMq/Z3KHeDza9jGvnW2MqaxHrsEO6VGfVjwD7+9keDXe5ZwgmyNAV1CK3s06wpuypoVFwtB+waQXK6VQIz36qej72Gft4Tm3JYY4zs9DhXeWXBkNamaW4CNFHT0KqmfX/vWo4PgKUHj+4rY/VftsoCripS0vd1F00=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR0402MB3764.eurprd04.prod.outlook.com (2603:10a6:208:9::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Fri, 22 Jan
 2021 15:43:40 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::e90e:b1d6:18a2:2d42%5]) with mapi id 15.20.3784.015; Fri, 22 Jan 2021
 15:43:40 +0000
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
Cc:     linux.cj@gmail.com, Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frank Rowand <frowand.list@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamie Iles <jamie@nuviainc.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [net-next PATCH v4 00/15] ACPI support for dpaa2 driver
Date:   Fri, 22 Jan 2021 21:12:45 +0530
Message-Id: <20210122154300.7628-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [14.142.151.118]
X-ClientProxiedBy: SG2PR06CA0117.apcprd06.prod.outlook.com
 (2603:1096:1:1d::19) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0117.apcprd06.prod.outlook.com (2603:1096:1:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Fri, 22 Jan 2021 15:43:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f3c486aa-45e0-4e49-4c64-08d8beec7d73
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3764:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0402MB376438A3B7580B432939D9BDD2A00@AM0PR0402MB3764.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eOtF0R08mWkJg8PwhQfOeQLSsGxLVveLMjHmXFBQLrX/bngJ6AUXdWE48YPQl04QKLgxr3FwJUpFLYy7w+etalA+xN0Y4cI+eExiYhRfPv/rxKQk3L4lxeZS+gLZ73GIeq3J56tajlGm0KI4WzUckqi/Fn0hYU7bcgJ+pAacHISlnIMA3rrY/8NbLbuCRhvr8PjSWAYesNQ/lbztKowLrv4bcCeBmltH/NjYUTLjD/p9aE7QS8VMLcjMiH3Q4Q0oJI3rjlrb2gybGekaI72v4sIsvdG62QaHd1VDoyf25cSsVe7Kc5V7jcntnZcKkfCFuzVfXn3KWqEi4VI12uePvkWSPiNaELTknnNyAK7Wp4sBcB/0CNugnzHO1y53YoentzWVaRSqBmTleMNK5+sMDbki9pdAN4pAz+nQQk60NJclW9mzDgcKnXJkQyMrQVdeVn/OQXn4iy8uHC+aB+P/oveyswzfyBwDz0bMZ6KWHmsNcAK4nTMJ2LRB5vskk+92sY+DUEgTRAFFn9tLcbbh4CA0Jxl8Ndxk4hvfK03XDCvYkvtJRorRjZdKySKVbSe91I1nEj57uUL55htPCbj7AEsTvK8ZWeTAvSu9v1UCGmc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(39850400004)(346002)(376002)(54906003)(956004)(66946007)(66556008)(1076003)(6486002)(83380400001)(66476007)(8936002)(8676002)(7406005)(4326008)(55236004)(7416002)(26005)(110136005)(2616005)(86362001)(44832011)(1006002)(478600001)(16526019)(6512007)(316002)(921005)(6506007)(6666004)(2906002)(52116002)(186003)(5660300002)(110426009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Eqmc7U9Hg9Eu1aztjTxRpxGLeSrVbLpDS4NSZmuWMb36KnbgTH9hbQumC3fu?=
 =?us-ascii?Q?df5r2oDXClErZiFaBz/iKMdmV15T+GrLC+PCvG4CuQVDZBqAQFn4c38S8LJ1?=
 =?us-ascii?Q?9QT9OVAA+anZRL3IkrXRw4IsMJOZzGv3YDF7/7xFjHE9CpFZDotBZ4wEBTIT?=
 =?us-ascii?Q?lhPHffTrgFgAa1l2gfPR1NvCK/r7RsZBw2sD7Njdrt4llQtVFC7KN35SZHkP?=
 =?us-ascii?Q?4BpFAGDWCHlOVbE5si8xm29NGTvO2AH1ewoZbRMyHBcV/Xk5K68eT8GDDQhE?=
 =?us-ascii?Q?eyYO0IY985INFxqDM+922x+3kEo3VB+08A/k4213/y1laoBqFjM1cSTl04Co?=
 =?us-ascii?Q?w/3ytq63mjDNy3YyrrtT0/tiRJebO04XU0sQwMJtY9HizdBeUJoW7XU48tYc?=
 =?us-ascii?Q?14Zsaa/CbCfvwoFpqPw58KmnvakKbWOBkQBC9tgcp2fBLW6+V0jMZP15lZ+u?=
 =?us-ascii?Q?emUtycKhAAkYmHze9wJYAtlBG5f2jSFV5JOuJSrWT+BWZuHl/H01cBqxxw1/?=
 =?us-ascii?Q?qHWZgEmiwroVwzCzYuXwwxd6RYGoG26XH+EgIt9RezQnnjqsfUYK6+PRyaRV?=
 =?us-ascii?Q?kxORj1WXr0T/dEEkhAs8vrP3WLj4B1ZyvCyCFDPl5J1cscQvOK0rYeg6hU1G?=
 =?us-ascii?Q?sObvrtUDq+pjjiLNF0ucf/lcR45ly1L4S5Ltqqc9UQBwWsc2Se5SyxAVOBYM?=
 =?us-ascii?Q?QRkiQ2xmM+ZgpBz4DPBFWZiVUv8KUjSLVogAFAGulVvH+G0hw+vzyvixNT3N?=
 =?us-ascii?Q?bzvmeFvP1UMwq48yPmCscD9J1axd7o82iD2NRbet5DX0uZTNNhpb3ZmeikpP?=
 =?us-ascii?Q?Dz3WFyhmR+Xpy4Dd1mAWNsUrNlT2y/utnwpKQImG6/gE4WKBc6urigkSPxBV?=
 =?us-ascii?Q?BGX98lIL2D21jzdRSTWWOGYL2HnJOIn65BjUoFQTAJZh9cmsemOTdqfGy+eI?=
 =?us-ascii?Q?pc+9zFuwRVI3/6QyZew1/o4+ZAJ5bdLfzr2n72WZ0+HuGZA+ncZlGUJo0W6h?=
 =?us-ascii?Q?BM/B9+dDE9glFOo6rX9TLDLyLJOJDl0YUjKdEW4jY8/1ahocEOanp0T3o1IB?=
 =?us-ascii?Q?jCytCsy8?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3c486aa-45e0-4e49-4c64-08d8beec7d73
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2021 15:43:40.2900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P+MfpR+YrrB0zQkAkocl1Je0+QSpIdRFQijlz0vI7Yxp66EKtrzLUc4cIBzjmaa9UyygFZAFKy06MkNlvag35Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3764
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
      fwnode_get_id()

    First one helps in connecting phy to phylink instance.
    Next three helps in getting phy_id and registering phy to mdiobus
    Next two help in finding a phy on a mdiobus.
    Next one helps in getting phy_node from a fwnode.
    Last one is used to get fwnode ID.

    Corresponding OF functions are refactored.

Tested-on: LS2088ARDB and LX2160ARDB


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
  device property: Introduce fwnode_get_id()
  net: mdio: Add ACPI support code for mdio
  net: mdiobus: Introduce fwnode_mdiobus_register()
  net/fsl: Use fwnode_mdiobus_register()
  phylink: introduce phylink_fwnode_phy_connect()
  net: phylink: Refactor phylink_of_phy_connect()
  net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver

 Documentation/firmware-guide/acpi/dsd/phy.rst | 129 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 drivers/base/property.c                       |  34 +++++
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  87 +++++++-----
 drivers/net/ethernet/freescale/xgmac_mdio.c   |  11 +-
 drivers/net/mdio/Kconfig                      |   7 +
 drivers/net/mdio/Makefile                     |   1 +
 drivers/net/mdio/acpi_mdio.c                  |  49 +++++++
 drivers/net/mdio/of_mdio.c                    |  79 +----------
 drivers/net/phy/mdio_bus.c                    |  88 ++++++++++++
 drivers/net/phy/phy_device.c                  | 106 ++++++++++++++
 drivers/net/phy/phylink.c                     |  53 ++++---
 include/linux/acpi_mdio.h                     |  27 ++++
 include/linux/mdio.h                          |   2 +
 include/linux/of_mdio.h                       |   6 +-
 include/linux/phy.h                           |  32 +++++
 include/linux/phylink.h                       |   3 +
 include/linux/property.h                      |   1 +
 18 files changed, 584 insertions(+), 132 deletions(-)
 create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst
 create mode 100644 drivers/net/mdio/acpi_mdio.c
 create mode 100644 include/linux/acpi_mdio.h

-- 
2.17.1

