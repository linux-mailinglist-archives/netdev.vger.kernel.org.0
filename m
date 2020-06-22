Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 070E72031EF
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 10:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbgFVITx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 04:19:53 -0400
Received: from mail-eopbgr60058.outbound.protection.outlook.com ([40.107.6.58]:46978
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726080AbgFVITw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 04:19:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H0c4fN1SfNxdsKENprMe/C3Dh0UAYdnHW5dqjUfDqP81eoLbsd8MP5IwBgkCfe+XTcrK0PGcS78xjqGSD7SWMh3XX5eHIKdlxSQK8RiGXyMInd0dtAuZmdVKSFqf/6iyfFOXVHtu4YhypFKgPrSYo5Xe9BGxhilD9N2fGBvq9GQW/XxbIWWFyBASxsDVtiPvtX2fYFQyeoaYVzXMYpVZ4yMfOvIvaIdZnTASAUiVJYV2ugGzTjr8KPYelgk3tzYSwO12sre7Wq2sbL3uiv7j8PX+fAW61vA/K/Kqc4797/Hj2UxsEXuKPyFX0flA7cl/2CixvNQK9DEKtsDvZVl8Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xs7Qmt/w/5Nh2dMOwags3SG2wQfX7OSdIblaHvCwgcg=;
 b=fJ5spAchFtGK8zM+aRqrYDThbR1pE/3ooSmgna/JPK2ZKN1Ou8sMHfp/tTMvNdeNnlLwxMO06eZ8LmK2MBSj134b2FcDbVCcOJcoDN0Sjh8zK0CJuZHMkQSRCA2qK+yXyg4BFBUyShrXJ/PpCr3TpzKu2PBtIaAlN8awKosOHP/0gIMlownCrI6wGjzWQTa7jqQcHNnA+MjNpaQ7+ZsowPwOLzN3zz67BUTNCiglFWg3xTGWFOpAPa/iVNgIcGcvsRkY3kFLYb3vcCVdiokkPXtelq6D2RXnANW+ZWMSeRD/xsd2F1sqr11EMmRLSJ/LXEYCRZVrrCK/6pCnA53Nyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xs7Qmt/w/5Nh2dMOwags3SG2wQfX7OSdIblaHvCwgcg=;
 b=Y9ifs2lovoXCennsggryS7oVMqhEIjmn96BALG7XxNWX9NIhizmxUfkE8LvswrTlBuwIjKk+2TBY7h2a24uRPaB7qC132S5GduAgt4N/3HNp6z47XrtrvY0aYA9CRNzvLg+gAoEoGNY3QIdYRu484DEbZznZae0aC3Wclb04ZJI=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB7010.eurprd04.prod.outlook.com (2603:10a6:208:199::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 08:19:49 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 08:19:48 +0000
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
Cc:     linux.cj@gmail.com, netdev@vger.kernel.org,
        Calvin Johnson <calvin.johnson@oss.nxp.com>
Subject: [net-next PATCH v2 0/3] ACPI support for xgmac_mdio drivers.
Date:   Mon, 22 Jun 2020 13:49:11 +0530
Message-Id: <20200622081914.2807-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0220.apcprd06.prod.outlook.com
 (2603:1096:4:68::28) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR06CA0220.apcprd06.prod.outlook.com (2603:1096:4:68::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23 via Frontend Transport; Mon, 22 Jun 2020 08:19:45 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d5ccb6e4-0414-4ffd-5886-08d816850770
X-MS-TrafficTypeDiagnostic: AM0PR04MB7010:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB7010127633C64F2AFD4D0947D2970@AM0PR04MB7010.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uENiDbZKx6/E/iOpwT68mGjlz4rbJZOPsmqSqmvknsoj/AhASxZSAKEb3m58kSPqD0q1ZFticdAhGK9R83nPRtLeGGz+xUJUJCCb7uBQ6rfvzyrstgFGlVIhpxw5wOmHFO14B8MIab1sQv+8nH1Q+oKbjP1BeEWpiCk3Pcz4IvX+mlTxoICpSoI8Ov4iwQQcQLFv3x+tWEVvFOXmcoIVqeW+RpiSyJN+manKxHLQ7sAJOab6ecPD00WsnLl5vF+qDQOMJpi7whkOr4HsNuYmQRSerLReNVz779N4WTB6O+GNtfiN5i6DXxXKwnGA4+F+YmM3hvJzwbhFGiRqbh6HC78zz1s5FVOCkd4OgQ6jP0HcwBb0yW42ghHUhsaxkKPb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(86362001)(44832011)(4744005)(5660300002)(956004)(2616005)(66556008)(66946007)(66476007)(6486002)(6636002)(316002)(4326008)(6512007)(478600001)(6666004)(1006002)(110136005)(6506007)(1076003)(55236004)(83380400001)(26005)(186003)(8676002)(8936002)(16526019)(2906002)(52116002)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: yB/S2LVNG7UMJ3G0E97+dHg+wRO3/bXEtmYZH8OCIdl/hzy3egqbXKm91tooKDkCTeENsIySaT9huLeNPyOEbtd/85J8xSto07IuGLePBtSIXm+tcUBk03/mdUO3uv+c3xXgV85mMaFUsKIXuN0diqsIgTnhmhU8zCalDcj71goZTuta9nDmtFknOGBYyd6OwCVsdfGbz/mTrRth2FtcWU1iboL6cJXs7Zteh9VX3QeCHI1MNR0F3k33UEgM2bIIwWZ9ztWT1GExMQ/o8KSi7GBtYNnNe/SiNZR8PXlMlm/LrNAgkPMqpQQfg9ZRiCxP12Yded6Myk+wnTFQdOT7V9tGlqF6sD2xs+6j7n2HCQEFAidUgpiSeDEb9uDrHO3LVOLhuoxIoAVL/wjWO6ap7i005STMn2D7B9/S2qEsS3fWxkz5qVA8UVGVXYh9a76ch9F5cHqoT7W5hLO/Sw408iPX628Pv3ZYpjd4ITKB5dQ=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5ccb6e4-0414-4ffd-5886-08d816850770
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 08:19:48.8537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JnCSOVk3uZxKbZo9gJ0223r7ujec00Z7Mi0U7VGTiY+tBQuAVO/7cr2MGJ8bXKMKS8JXm5yfQn6iQVfo13awvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7010
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series provides ACPI support for xgmac_mdio driver.


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
 drivers/net/phy/mdio_bus.c                  | 17 +++++++++--
 include/linux/phy.h                         |  8 +++++
 3 files changed, 46 insertions(+), 12 deletions(-)

-- 
2.17.1

