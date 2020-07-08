Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C7D218E4F
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgGHRfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:35:06 -0400
Received: from mail-eopbgr20042.outbound.protection.outlook.com ([40.107.2.42]:43335
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725810AbgGHRfE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 13:35:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mvGUW1Zv1655R1TqlG3p+iy075XqZSXoNugRSto1wqTGQhU17Q6guFYcrMp9vFldz560grgLFjyUsGW53KRy0Bzl6K1oMt1g+2Gm7qyDO0akgssyPlfkqXA1a0w+Ne5Uh2e8y4o0+sf1cQDC0/SVtMfTtRVcC13HIn8fYvOwvF/uSc+ywyIjYMgg/mg3b1e2+PMC0EBvnyltYGUBZwFpXOOFWk0B6RN2sxMsp63Ed586nh2e/wIN/PE9woHYNZkfltaO2CYwcTar/0VV5agLbOeAhSqwgUncjsKh14Doh0FugjB2VQP1PBKovFc/j/qSgewDkmZ94s09luZLfJhQSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRISoZHtUT2lOidikhL2uLD4nI+iGLulmWbYs41wTDw=;
 b=QLnYCWBWfOml411hoenmj0xyOYK4dk10DOuP8PvupG00EsnSmAUF58odHm8IOJOtfXi22DX7fUm6mdtgg766Bc0Q9VRjRhAEloSvDA7wsMapbbBP/sTgBe9Sii6rmJgAcF8XPoVh7CxjZBe9vdTBIOs+++HuQ6eVdePDixLlM0DXYJaPSBuu6Tr5xKtFDI94Gwav6EAQjfNuNvimZE0zH5V6DE56hfQVkxDaGhFREqb5bMZovqUja99JPO3/9PFYxcRYTTRuAsy8BdqUgeN9hII8sRe2S69sOinHlaf2DZebyrA8Zw+fFw7YUG5uCXWn2zoeYBGfPMlTrExjdRZYgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRISoZHtUT2lOidikhL2uLD4nI+iGLulmWbYs41wTDw=;
 b=fJeaup7W4eaDybaV3VWOHj4FGzuRwNKGfkhf2i77F9UW4D+VDzLLOO2Mnae/8MzXAJcWkNz6oEw6UQA38d9CHkDxJyExsaRg+St2vpZyblecEjQcixhvnyx80FM6zEDGCcY3B3JmHsDer2enJz+EPIH/pOVDqso5ZPz8LSKCT54=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB5730.eurprd04.prod.outlook.com (2603:10a6:208:12c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Wed, 8 Jul
 2020 17:35:00 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3174.021; Wed, 8 Jul 2020
 17:35:00 +0000
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
Cc:     linux.cj@gmail.com, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v3 0/5]  ACPI support for dpaa2 MAC driver.
Date:   Wed,  8 Jul 2020 23:04:30 +0530
Message-Id: <20200708173435.16256-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0100.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::26) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0100.apcprd01.prod.exchangelabs.com (2603:1096:3:15::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Wed, 8 Jul 2020 17:34:56 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4851f935-16c7-416e-b3a4-08d823653d26
X-MS-TrafficTypeDiagnostic: AM0PR04MB5730:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB573062A6C2D105A08B1AB33AD2670@AM0PR04MB5730.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 04583CED1A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wztm+xHYj3EtkE9wkRSNPJKM/gvqXWrvdxwONoxaA+D4Ym8T6LGlqE8NzeNCGzq8NlagScHLY5DPSVwTONgDFaKci6z9NaXkW0qF4rOk8vPiPizyBZ6jvikC02GWWifrVykGBmW4qVhXs/hpqq/IP7ynWCsQIAfjlTsr5m2/hqX4yxei3qm5GK9mqd/f6khO+igw+IDQLN10UZ7FA/8tpDSEXjD90hZb40wU+KIxSXiCYK08pZMlaASvxk5g/bbQn+bEUwTMka7lE1xsyfaQj88fu2d3jiE0ydk2NUFCpmGCTm0fe9C59uXGZXrnkkPWOXaBrq2nMjXlRKKA7dV1qT6Lbp8DcJQ9g2wYSpcyJ2XcA2uxiyDAenzYEjHU76Yl1DpYwJUmkM4gLFTeybHWggNEWIt85sJ+sC0U8+u16ffIGU3/tIryquIQV8PgcPCwN5Y63hq5iJZfQWNYCvAkwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(346002)(39860400002)(376002)(2906002)(186003)(16526019)(956004)(2616005)(8676002)(316002)(8936002)(1006002)(6666004)(478600001)(966005)(6512007)(5660300002)(44832011)(55236004)(66556008)(1076003)(66476007)(6636002)(86362001)(6506007)(66946007)(52116002)(26005)(110136005)(4326008)(6486002)(83380400001)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2bTFLciYrI31f6QyAYppLo/PuzRm+khEg9lcYfuANB1pRd9JUol6ul4ygJ+XkdDCmh0iEAz4BJjjr7kl0J4pS8RmYye1yT2NDI4bB0F2RtB02w6//a8P3NaiiLF2vbnRiIPN1vxmPGRgy6gDRbFHiPKn0fEBeoPrjTGAt/o1zaZb5KzCo82c/km4Lo+9ljV0k+fG+zEfkBlDodP61Brokmuz9F7AATn01mOsW6afI0MNfw8VewJa9Q9bkFDh9ccpV45dnZdos+MD+O869romTtZATiNOHif0q2UnLyPK3Rc123f4/2Hudh14XrekRCUE9guODKoNm3+SZqp3dY7JZDSYads82R0EfONyOIfVufwlOayUi31zXhbx1+OOGcn+OO4zyBOAmmhf1dQua92QOWjICx3DX/9s2Z9FoLY3DFqeAliJ8S6odG0J4ZRF4RTAi/lv1R2KxD+CKDttVxUsWzo0XoMiITZj3LQMSsPfiCc=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4851f935-16c7-416e-b3a4-08d823653d26
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2020 17:35:00.1628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sDCXjuja2MgkVyYNkhXaplhV/Q0A9CFu7qC8t4ISa0anyOiVnLlgzNI0LyJAcOlvPNMgbhN5K7kD7L8Y5/Q3YQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5730
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

Calvin Johnson (5):
  Documentation: ACPI: DSD: Document MDIO PHY
  net/fsl: store mdiobus fwnode
  net: phy: introduce phy_find_by_fwnode()
  phylink: introduce phylink_fwnode_phy_connect()
  net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver

 Documentation/firmware-guide/acpi/dsd/phy.rst | 90 +++++++++++++++++++
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 70 ++++++++-------
 drivers/net/ethernet/freescale/xgmac_mdio.c   |  2 +
 drivers/net/phy/mdio_bus.c                    | 25 ++++++
 drivers/net/phy/phy_device.c                  | 21 +++++
 drivers/net/phy/phylink.c                     | 33 +++++++
 include/linux/phy.h                           |  2 +
 include/linux/phylink.h                       |  3 +
 8 files changed, 216 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst

-- 
2.17.1

