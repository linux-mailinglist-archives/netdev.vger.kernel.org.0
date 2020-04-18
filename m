Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2D11AEBF6
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 12:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbgDRKz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 06:55:28 -0400
Received: from mail-eopbgr50048.outbound.protection.outlook.com ([40.107.5.48]:23175
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726006AbgDRKz1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 06:55:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F8R+BnJoEUBUQpUFGbZSSf+2/vi8NKa11KOc+AVxCjVGpoXTP1Mp0zvqsq33YKxSZf5n8TIoVQEwv6v+XA/DuFPQHo49Cxb3tTSNHxPZA65nOjNmkejFGlhETlvzK+CgnApMtlX5WO6U8SvYXyLM++PEybuGU+WevtNs6F0KJiNVXTdCDqrb6EW1mmfq29Oz9LA0/Qef9tOTRNWSb0Q7auvovkrLeIViyBtekU9ydKEmdeSsnM/OQ2/k6OXUzzIXY4gnBlU5kfd06IA0A82EKJqVKzMhFbl+YjvyZhwVoosnndV1tgTAzJwzzu+5csAZ1WJMpNg4JdnywhCq+ZboIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u3pQ5qbh6fZKhTz+r3wfdBfyccKt2U9UYOERnNSZgSc=;
 b=Qz+4XwtgNPZoHj2vWXR+q9Gdv3/wtDYA1AjMsEbrLNyXt3nyQacYbs4xWf8U9yoZniV+B7u3+BxUXfEmhVrJUCZmyqTLcJdRJi/K1MYZkMeIPCjwsF6gDyDGULvwKzocT1HhkTJp1GuGgb3G2m4WQUHjTm3TBc6y58NOhO/Es5jGBCJaXNv9/8UQCW5ZBA15dWWBKKot1jgwDz2dUE8f98eUJF9kNEExgcfyBhclM0pAubl0+4vB9Q/FQJFR/3Qv9Tp3sh/ca/TX5yLiQmL3ELQXF0Qe0YyAgGI18thbMkyozSQK8s5FsWfzNwkVp2MUiO+4/yuXhCAqrWs12lVzJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u3pQ5qbh6fZKhTz+r3wfdBfyccKt2U9UYOERnNSZgSc=;
 b=IYzPk/ZsWaMtMXQ7PN9id7lUyXN8DsYdTr0PbW6TkTSlN93N242zJEPl7vFNz1SdRIesH43kPKqWyGbesAzsGvSUFPc5vukdjHsc5R8AHGij25/6uo8xYwhKc4PXz6A4+6ioxrYFFNY4BJaNI9xnl4YTjYdfpiBVRSo5KhUYJxo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=calvin.johnson@oss.nxp.com; 
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6899.eurprd04.prod.outlook.com (2603:10a6:208:183::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Sat, 18 Apr
 2020 10:55:22 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::c4fe:d4a4:f0e1:a75b%4]) with mapi id 15.20.2921.027; Sat, 18 Apr 2020
 10:55:22 +0000
From:   Calvin Johnson <calvin.johnson@oss.nxp.com>
To:     linux.cj@gmail.com, Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     netdev@vger.kernel.org, Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        linux-kernel@vger.kernel.org, Varun Sethi <V.Sethi@nxp.com>,
        Marcin Wojtas <mw@semihalf.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Subject: [RFC net-next PATCH v2 0/2] ACPI support for xgmac_mdio and dpaa2-mac drivers
Date:   Sat, 18 Apr 2020 16:24:30 +0530
Message-Id: <20200418105432.11233-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0099.apcprd03.prod.outlook.com
 (2603:1096:4:7c::27) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR03CA0099.apcprd03.prod.outlook.com (2603:1096:4:7c::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.6 via Frontend Transport; Sat, 18 Apr 2020 10:55:16 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5108313c-21c2-484f-288a-08d7e386fdd6
X-MS-TrafficTypeDiagnostic: AM0PR04MB6899:|AM0PR04MB6899:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB6899E7CD1B0E4156B376BD69D2D60@AM0PR04MB6899.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-Forefront-PRVS: 0377802854
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(366004)(136003)(396003)(478600001)(1076003)(86362001)(81156014)(26005)(4326008)(966005)(8676002)(8936002)(1006002)(6666004)(6512007)(316002)(6636002)(7416002)(186003)(16526019)(54906003)(110136005)(44832011)(2616005)(2906002)(956004)(52116002)(66476007)(55236004)(66556008)(6506007)(5660300002)(6486002)(66946007)(110426005)(921003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dSlqQ2auVSP/DMX1X32Ou6Qh7i+eotyFL8obA5aeCX57dmqOSZV0TNEdW/doa8ACni4BLWOT12YKdbhZ9nEqf6VjBVnU/o3zJ3W1sJzYt/r9b0F6asQ4jqBFb4xTTKzNucH+alNVSSYEMSBn/lJFjZZlB7g0O+HwI35tKM0r7902GTaVQdBPVifudoWzvlzNJAuM0Scx7yrD5pICzLS9rOM/QgVsoYdXIWxJ2sUhJFbPlxhji8BMaOPcV6SxhnU5dk+OC8x5ojZu6mBJDnJdb51Jzotg+62PbskGpRYIF7T2nz/gApVPcAaGJsEBBMsjE5IJbjLFaAtoa6JzyGDBYmYeJ8w1HmIj0mA9I39QiB+L8RjAsiF3sKgEvnscVgtYUU5tx30fQKbqX1QMz9fQiElae/H0yKKmziM2JtgOFOXP02lXZJ3XiqMrsgBa7lOGsFfJYNd3MCg1cciLc2CpwU8+i+J/avS/c6I5TB9SQcVvFie3eqBXwwOa5ZTQ1hZa6fOlOH6ke9GR+XCW4Z11odOZsMeLkFuHHw8iQrGehQbuhaO8BCWvlC5JzHHc5ilNbXLzGHypvMPn9s4wayf9DQ==
X-MS-Exchange-AntiSpam-MessageData: 8oCsgWDs0f8ol1dwTAz4ib7erGi2xL+XD1nsMK6FPidAkRJhd5iBARdaUqZHzzrykcdbkB4aVkJQYQxDxtlmzFkUa92ULh9jtryMia/r1VG846kmRl7vQbFzjV2MMLKyezv1XAqaM5jOYkjTvgYxyg==
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5108313c-21c2-484f-288a-08d7e386fdd6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2020 10:55:22.5115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ghnAzu4hc6cTcSkPgkCcQZs5oegK8OqL8S0AfJ6A6vf60JpIOPUrYHJo+SW9LE6xQD8myMbgH2Y31BZGqGLu7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6899
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following other network drivers that supports ACPI,
v2 of this patchset uses non-DT APIs to register mdiobus,
register PHYs, create phylink and connect phy to mac.

This patchset is dependent on fsl-mc-bus patch:
https://lkml.org/lkml/2020/1/28/91

Two helper functions are borrowed from an old patch by Marcin
Wojtas:(mdio_bus: Introduce fwnode MDIO helpers).
https://lkml.org/lkml/2017/12/18/211

Changes in v2:
- Use IS_ERR_OR_NULL for priv->mdio_base instead of plain NULL check
- Add missing terminator of struct acpi_device_id
- Use device_property_read_bool and avoid redundancy
- Add helper functions xgmac_get_phy_id() and xgmac_mdiobus_register_phy()
- Major change following other network drivers supporting ACPI
- dropped v1 patches 1, 2, 4, 5 and 6 as they are no longer valid
- incorporated other v1 review comments

Calvin Johnson (2):
  net/fsl: add ACPI support for mdio bus
  net: dpaa2-mac: Add ACPI support for DPAA2 MAC driver

 .../net/ethernet/freescale/dpaa2/dpaa2-mac.c  | 122 +++++++++++----
 drivers/net/ethernet/freescale/xgmac_mdio.c   | 143 +++++++++++++++---
 2 files changed, 215 insertions(+), 50 deletions(-)

-- 
2.17.1

