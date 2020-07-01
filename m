Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04E2A2103AF
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 08:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgGAGNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 02:13:16 -0400
Received: from mail-eopbgr00048.outbound.protection.outlook.com ([40.107.0.48]:57345
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726615AbgGAGNP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 02:13:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fB/1b4M3kq9qQ4SOO4u284XQD/G02oblfgbGOFr/VlMfS7ZLvlx5ERjupC2jxXLj8gQfWwaAn16jhvwKE2he3GALkDQjgvVwZq7szkgpaUDfxVM/5+EqzY34T3rB1EIXMZ0p5lKj9gXgb57rGH66ZpejWR5cYekpqLANAl+2s/k3OIkCKTQ4xihyxoXEc4Xdu6cyAiAXzUKfeGJmLbAu4ySBw2kms3YUaja7QwDCbt6nHjjekf5OUPXQTrrbbhRRqlYEDAjJR6ONkOboLss4sItgMiS9Ej5QXSl7MAPwmEfCyk8yVmwhKCfoyTmOvz680iTqOurRwGGtlSl/2d9bsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KZF/JbCDg8BMwel4EFMjg93OCrlfBHmVOaAzylbuPlQ=;
 b=azsUagLhC/foRnLQIJ9nV28VdAYwdusVYoElXE7lz7b2G2GnALDUsI8b4Y3ojevobtdW0VX0gEld2ckaXnILZVGwb2u9k1PUlgLhljPCAgF1UUHljaq2nM279Z1waj7Y3GmjLSYdK6SFL1k64NULTeeS8D4lgaHX4h1XvMOOTgrnQJmYYrf+fE4VDZJossGjbhvR6Ewfqa8FAyfHY3x8BGDS3mtaJ4OGrG45KZUq+9aJuFIZtdZ42JBc+TIyfkyz7XuzQbt/yj5KfBs3w7ApS+U3ujB1df98r589tgFU5jv5YG+/50KbzCV/FUUApoetq0pmNYNdPYtN8966zjONMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KZF/JbCDg8BMwel4EFMjg93OCrlfBHmVOaAzylbuPlQ=;
 b=D+Dz5su1d10ZlbSukkGr8Mg7NHqRpatFJf8Br/4ASQ+9vGc8yUlnRLmxAra3us0X+gUhTJvfCv2PHDRn7fzxTGYSawh1Hf8zFbhCIbbRYikNWVF+Sx3JHwFDDp3SyLXb9PZdn6XtEH8YBjClOI5maCfPh9+aMsTAbmdNdZlunQk=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4227.eurprd04.prod.outlook.com (2603:10a6:208:5e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.25; Wed, 1 Jul
 2020 06:13:09 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3131.026; Wed, 1 Jul 2020
 06:13:09 +0000
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
Cc:     netdev@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux.cj@gmail.com, Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-kernel@vger.kernel.org
Subject: [net-next PATCH v2 0/3]  ACPI support for dpaa2 MAC driver.
Date:   Wed,  1 Jul 2020 11:42:30 +0530
Message-Id: <20200701061233.31120-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0230.apcprd06.prod.outlook.com
 (2603:1096:4:ac::14) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0230.apcprd06.prod.outlook.com (2603:1096:4:ac::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20 via Frontend Transport; Wed, 1 Jul 2020 06:13:04 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e8836880-89a6-4457-2f74-08d81d85d3c1
X-MS-TrafficTypeDiagnostic: AM0PR04MB4227:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB42277F090D39B7472A57FB5ED26C0@AM0PR04MB4227.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 04519BA941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dsYvtACEDcmDZZOcmelLZy4qpM8iyG81+b+Oq/jXTHeKMvDZau6/p+QedrLu11d3AE+NahnIdrLEuLlSQE7IseBGJPIBsKhJt9cmsXW6/mkN9kt8GK9FUV1LG6WPJGczT3Cxf04GEFPCUGg/01Qq3qBjbSKGpDFgl3vnchBfW2psXqH1ngHFhiJxDdW/7ETRmEwppPcfnbsKbzh8z+Wma0N9uc2VbW7ewTcjnUPemjsYA92ckEvCBZfI3YjUkid/5iMeoPxROOKAYrZOwL+Nf+3Fjwc26U2H0U6qK2Z0WH1Kj2RKYg280/NggYUobhVAWxoTXwLWvQUKtEmPnE4NzuhzPwv2k4f+Nlat5hkAJPBtnfMVgJqL0lVfwY5EAjzZ7i8NVd4QHyK0lK2kgXTEL+zbOOn85IxkcAItkQ7lOcKqFckn+QqsqrhHLWGR5t3f0ujZ1a/vHaWJDQfrL4ch5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(136003)(376002)(39860400002)(396003)(66556008)(66476007)(54906003)(966005)(5660300002)(6512007)(8676002)(2906002)(83380400001)(7416002)(52116002)(110136005)(1006002)(6666004)(1076003)(26005)(6636002)(66946007)(86362001)(6486002)(186003)(16526019)(8936002)(55236004)(478600001)(956004)(316002)(2616005)(44832011)(4326008)(6506007)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: COlFdv6RILD+ymuZkkBT734vfdHL5DS7fA0oUVlIpoHLJjZLzk+Ewv5QWDz1ODBYTHeLTSFvYsr9yVqAr54QBXiGkzd2eTmFVeWKto8KHoQNY1jOqQlKqpyqAegIUETR2fDlvE4NcaiAfMnpg6+AvQv43vnBfmP5/6jxCV0Hay9aGm9o8XZFtowj1IyIS3vIniTPZIf0A+1wB854sCgsJfhNI6y5wpnOwsa4M7Aj1hHOuDo1/YSLsJKOBAp93b7pj9j07wG6nkvjyiMZk9iq02VNodB7ex04/O5Ikrt7vQ3o9BNJ8vsQMal1IMJiuwkmi6FyKF81VjQDRDw/j0v9P9YNJeA93DYS5FDZqXoYyfFr+b35CcTip6/+t6Yo21n2+dF1jAKEwxYxva6HSxt7MweGn+KwGWVSzjtt/pIxzGuw7tI+PyJjk0H1FCxcyNWHdZwRD/ArqGG0vzFK8t2vhwaIZagFPgiM34VZC3dzgX7XIL1v8o2Tv3+1bUEVVbMI
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8836880-89a6-4457-2f74-08d81d85d3c1
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5636.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2020 06:13:09.6732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TKWhH7NAzLLPq23irxNQwqAwv+h9Oc7tSpxs1XLlpLQn6fEY5TvA0dFJxwKs69zTtkiknVQ8FefQ+RKg8sn7+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4227
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


Changes in v2:
    - clean up dpaa2_mac_get_node()
    - introduce find_phy_device()
    - use acpi_find_child_device()

Calvin Johnson (3):
  net: phy: introduce find_phy_device()
  Documentation: ACPI: DSD: Document MDIO PHY
  net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver

 Documentation/firmware-guide/acpi/dsd/phy.rst | 40 ++++++++++
 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 79 ++++++++++++-------
 drivers/net/phy/phy_device.c                  | 25 ++++++
 include/linux/phy.h                           |  1 +
 4 files changed, 116 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/firmware-guide/acpi/dsd/phy.rst

-- 
2.17.1

