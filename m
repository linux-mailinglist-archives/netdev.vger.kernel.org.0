Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBBC203A42
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 17:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729201AbgFVPGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 11:06:09 -0400
Received: from mail-am6eur05on2081.outbound.protection.outlook.com ([40.107.22.81]:44209
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729091AbgFVPGI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 11:06:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NZqvDRdi1ZCuRIAZazsCpzGfTqowX33ptjtb/Sv1zoCrZau+J8+I1sA9acltH7ZT2mI7TD7R9vhynVWq1OmANMRvJ1piE7F4snA6EIw8RRGy0XHV4HnQ3G89wgOvn4JMjLNQcvWMG8LCRELhgOMxvKuaIh57yGHNExZeh2drmFH5HIxqUXxxY4tWG5BS0bcj61CH8FV6qPFf6xmAQR1E59XGDoSikM6tgLPiXF4xr0wSC39/Cf7n/f5ho4kgXgWTYPwvh6fyJT2zOiyCeWe7MVma2Sj1rZUtxSA2pehDY2PmuLqX2sBqYu1N4VsXHqJ+fcLAhlp5jQty/BHmnxzAlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nb70tly/y2JcIl9Yrh2d47IRTX4crsiEZ9rrgpb0wPo=;
 b=Xk/MAkTf5Ygsdd2GDIhPUiQ25E9wRP4xGNm5TtSoK5RXP6QjUpthW3gxG0lgQRMxAHdQpRYAkOIE6x2eC8OAG4RozaeP1LXrhOnPXVv1P8qyhBIT8SNMn1R72jC4VOyCt6papZEs8g56GrU9qv45bx1f8YCNccU4wcbswQ4CWzmhgiBWoY1joJ36Lrf/TA/Z6qFpjy7x62X1+hxe2z5rcaFmk33NyEmtTtem3s2G7KHvSQqh6kZjpxCj3CQ7gOqx2PvxvMyQBXHDN6n1mWngbVrLnrHXe8EA7AyHxjJfRa5JLpmGsGzxUfeb1c+B/fC5oS1cYRNokoexD9OaVb7pqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nb70tly/y2JcIl9Yrh2d47IRTX4crsiEZ9rrgpb0wPo=;
 b=I9NBKfAA3DcLdeQcFthrt75i/qo3yJpXIy1LvtRZpuWbsKWGZ6PqY1LHk5v6Ilk7HusSjchhWPZTnqKzg9XINguxNwoDLtRi9CwhljVxTukBlAEsN9qOI7j6KeEw/USKWvqRvy4KnbqQrGwpDgXKZUTNvcXumYbMMjdnmNHP0qM=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB4289.eurprd04.prod.outlook.com (2603:10a6:208:62::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 15:06:05 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 15:06:05 +0000
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
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v3 0/3] ACPI support for xgmac_mdio drivers.
Date:   Mon, 22 Jun 2020 20:35:31 +0530
Message-Id: <20200622150534.27482-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0115.apcprd03.prod.outlook.com
 (2603:1096:4:91::19) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR03CA0115.apcprd03.prod.outlook.com (2603:1096:4:91::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.10 via Frontend Transport; Mon, 22 Jun 2020 15:06:01 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 921dbc4f-f90f-4855-81f9-08d816bdc8d0
X-MS-TrafficTypeDiagnostic: AM0PR04MB4289:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB4289553816C86A46BA31C8F3D2970@AM0PR04MB4289.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nGdRY3pI9UvVK2+VVGiaYKmkvIeYJiIGOXz+bpIvZ3CrlzN/NImHYlbbL9EQB5aWSmckEapJfeKm2rCtVcDw5WsEo3kxx/k4RbKOzpXLBUy5DRV8x74GiU5oXEY+fHVQwuMQUdaBH9dsNyjQRyYrXh92wJQcj2tRNJl6t/a3W370yZ+A7ZQcmBrNouB5L9hc81YCzKOQZoMaY/VLFmoRnBf2pC8QPQSQXjzYGkP7TGKMjtH6Zf3LM3A+aq807ZBdPVxMtjLMR7QZs+3zYeRVP9cmFgOl2mDAUSRhR01oth/FD5x27fBbh9fDYefiFyDIUR17duBULG6NWtao5osFAOL0xkIK4sVTEJpCPB+kmZRHNEQkdfsE/JSs1h8O2lCI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(366004)(136003)(39860400002)(346002)(4744005)(6506007)(478600001)(26005)(16526019)(52116002)(186003)(55236004)(316002)(8936002)(2616005)(1076003)(5660300002)(110136005)(66476007)(44832011)(66556008)(6636002)(6512007)(2906002)(66946007)(6666004)(6486002)(86362001)(4326008)(83380400001)(956004)(8676002)(1006002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: CWleCHxPh7zitAjlG/89e1MoCq7FqHAaIPh/DbGQpIMLDLZEG/zp2m+WcmANEjDu8RiVdM+Jgnci6c9i1/vq7t5+Z6kZqXE7bjqhFZuUy/osB4xJ0MJWBAApn1see1LTDqrJp5D1kYnumc0glcySw4cBMLVeFbFJbkVElE/WaayZQzcuDJ04ObOWBqyqInS9LCcA504mjWX3ksn06Qj7qoFtirDG66b7yyiFCUBPhIvV9/h4JKcaa6mwrigp9SLRxs1zctjQTB4shmWZhKApnkN3L4JwkI/mksJX7ecUxwF15MH3ImbNFSTYlEWn/hzyZLk+wK9gOjpG12x5M/EUztr7ytuOvyPDoSn67+ykITrC/fdlNic1MhVwJRg68KMAxhUQmuqjhH2by9YKGg6Q/uXr2k3prxlq3durNSLfhfZex6xaQhfPFoNYeS60l5jCpGHokfEKCw7z3hD3S9Z1jpcqvpGQazi7d419kSYB+pHLIeNMVTggLGb68vo8RYgQ
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 921dbc4f-f90f-4855-81f9-08d816bdc8d0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 15:06:05.0710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XoqCrSo7f5JApG6hHZQL3qOee3GIqgMlsowaWCqIXSQitrya5fKsdoGtlWb2e0mZiJGUc8Ut6nK8s1e4xgz+DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4289
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series provides ACPI support for xgmac_mdio driver.


Changes in v3:
- handle case MDIOBUS_NO_CAP

Changes in v2:
- Reserve "0" to mean that no mdiobus capabilities have been declared.
- bus->id: change to appropriate printk format specifier
- clean up xgmac_acpi_match
- clariy platform_get_resource() usage with comments

Calvin Johnson (1):
  net/fsl: acpize xgmac_mdio

Jeremy Linton (2):
  net: phy: Allow mdio buses to auto-probe c45 devices
  net/fsl: enable extended scanning in xgmac_mdio

 drivers/net/ethernet/freescale/xgmac_mdio.c | 33 ++++++++++++++-------
 drivers/net/phy/mdio_bus.c                  | 18 +++++++++--
 include/linux/phy.h                         |  8 +++++
 3 files changed, 47 insertions(+), 12 deletions(-)

-- 
2.17.1

