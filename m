Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21E81FD33F
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 19:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgFQRQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 13:16:22 -0400
Received: from mail-eopbgr130084.outbound.protection.outlook.com ([40.107.13.84]:5262
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726597AbgFQRQT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 13:16:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8Dfkp8h8dKz+2u10frlxkEEP8TT1c1Zurnf36a7ThfJVDECRyQ0W9LOCyTzoe0ZImlVHZ8Z8XA5BPP3p9+C++NROASJu0azra7NmtqdNU0NC2sSRZtzqSG73N1hdi61v062IbD8r/qdV+OtgU7TRzGgKYDDUuSbgpYzpuulvkTXSSTMYakDBgtL3J5YTcn7EneoBhL4fYSex+KQWKBSFoqa+iUzfA3GR6DCCRswvJWSJzkWYIaRxDLi8uVJBHJKxYQr8FhfgfPqtuwLegVHnERQx+THmzb+nakX9BOc3rLfqRLAcnPIrQj4uzF3kCQebHsxCKETZfX58TDoyZ8FlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yKjeaGqQFH7erVLzKgoqj5m0/PPMVsSH67upaqNRljc=;
 b=k+V52RrOL8bDaCB4JVwrfBol/i0L0UBPR4qjpunvK25kHcylSpSET58SpIIGtlG+bImXKgxt321tqQJEEa5+GMqfVWMxHjEuzp9tpfDohWpYi5NLWqH2ArOlClUcaMWeFlNy5uMO/bXUrBxqq7wwbl1YxZTIz0y2pRYiir2tif2JDL0O6piDLTqN0tSfkULsYyKuAt+e+t3wVwSTK7UMfe9ivfawEfaSeD5jenagtgYm9YtI5FHfgLYWgHbs0blwXpGdfEsxZGh7UU+UA8ZeKIQHRu0CxfRsO/xf1/7vAYoCxGTuptrU4re50rDnYzncILoyA36AV7uP/itxtuLzSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yKjeaGqQFH7erVLzKgoqj5m0/PPMVsSH67upaqNRljc=;
 b=LzQIIGzpgSEq78nJDTV8N3z1965NJYCVWjWElTCkxWulpdPwuaAwO1LGrTgJK3IrJHiKShK8Utx4C+eVtcKQwnS3kY47BWAQmq/JfhLVyqke6jbJzKHMBf4IonWjeHVnuP69LiOV4Z3V/84cOHJMeCfkmHI90oHg5yJHUdlESP4=
Authentication-Results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22)
 by AM0PR04MB6722.eurprd04.prod.outlook.com (2603:10a6:208:169::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 17 Jun
 2020 17:16:12 +0000
Received: from AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45]) by AM0PR04MB5636.eurprd04.prod.outlook.com
 ([fe80::7dda:a30:6b25:4d45%7]) with mapi id 15.20.3088.028; Wed, 17 Jun 2020
 17:16:12 +0000
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
Subject: [PATCH v1 0/3] ACPI support for xgmac_mdio drivers.
Date:   Wed, 17 Jun 2020 22:45:32 +0530
Message-Id: <20200617171536.12014-1-calvin.johnson@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0146.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::26) To AM0PR04MB5636.eurprd04.prod.outlook.com
 (2603:10a6:208:130::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv03152.swis.in-blr01.nxp.com (14.142.151.118) by SG2PR01CA0146.apcprd01.prod.exchangelabs.com (2603:1096:4:8f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Wed, 17 Jun 2020 17:16:08 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.142.151.118]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e9b4c37f-b7e6-43c3-cd90-08d812e22234
X-MS-TrafficTypeDiagnostic: AM0PR04MB6722:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB67220FB67DFFF2C3466C8671D29A0@AM0PR04MB6722.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 04371797A5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qU0jSS7CRvDEyBz4n95RsklWm8S64PD2fHQGOsw2UEek3842qKRvg52n1TXd5qRFyINAGAm9/AQNB/wt0OwaeUXLgsMsci3+/8u8fVd/DgvZZbpJ7/O7YKXjyZtSUT4nxdlgO8JfafLP+jDZqQhBsbAXh6vu8Yg0VxVygN4S9CKdzQPngA72i+HPddCcCuPvyrU/DscXMG8GuQ8Aa3CoctwH/+/NEmP8RiG+jOxoTYK/Esop52zUncDlPFsBNx3rZS9BK6BhByWY7yi6gEGxkMneqt/7h5jkz+8c4t4NnNrCX3FKcma+aMZaxkKrVB2E3XF3QliiPrx9Epaz0FR5zHLHySxwSePx4jc/TF0Xo24ye/WuEs/et9H1/8/TBp7r77h7/WtiP3fz5zHAcGNGCjK4c6/mL090zbNaUvWrl/12x96ijHR72iUq/S4J7TLmf1+N4I+ZTZ0kYpBLrn5m0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5636.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(39860400002)(376002)(396003)(136003)(83380400001)(4744005)(478600001)(6512007)(52116002)(66946007)(5660300002)(1006002)(6666004)(110136005)(6636002)(6506007)(66556008)(86362001)(316002)(55236004)(66476007)(6486002)(186003)(26005)(4326008)(8676002)(2906002)(8936002)(2616005)(44832011)(966005)(1076003)(16526019)(956004)(110426005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: r7+P5x0bBd+FHgj1s0cVxX16MGiddXO0zM7FyDO3sSipzrX6fWXcorJP+1v1TYvgEwjqneYtA/YNl3TEJLTUgiPQCfdXs7bA/I5OXDKZrM3JMBkvLBXl3cKgZ6zAqJL7UQjKdfNKidtmJy66zA2V2Mkj8dOI3ojktuVt4y3FvZ2BH00r+qN3BCa6+wwvWCPypOkIvCaktAiAbgNeV+0jvxdjuco458NeC7VguLtzJlU/sUkQGGKKDC2Ku7Ldi6Qs7Cu50N6GSW+7ToODKchmMnJEWl8fwj8Ah8kT+4fE93TBRBPWkbztLzszNjWiAXPKLfkT7ZL9/j6Rd8BxKr9Zr0b2DehIsSriMg0aFbz47N9kNWmA7NbKNycSuOSUf3UxDZVUkY3hC5GPHKDR6/k8AU+cjkF3q32ZYcXpQy8FQ+GjtsSy4GXifGiJNZKk0mU0EO3uFYrmFeJ16xFNqDCuzQSXSHT6fuMhj3gcwFcaZvTRyBJVtHkpA8AFGbRujvLf
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b4c37f-b7e6-43c3-cd90-08d812e22234
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2020 17:16:12.3817
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +9QO+BmrnEG5cLGGSpXUg51j9vl3Mac1a048bchOHs/DkxMtG2HWWHLI1rkX1zW35/Y9mjkOHbUOVHm8mx2/qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6722
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series provides ACPI support for xgmac_mdio driver.
This patchset depends on the following patchset:
https://www.spinics.net/lists/netdev/msg656492.html



Jeremy Linton (3):
  net: phy: Allow mdio buses to auto-probe c45 devices
  net/fsl: acpize xgmac_mdio
  net/fsl: enable extended scanning in xgmac_mdio

 drivers/net/ethernet/freescale/xgmac_mdio.c | 28 +++++++++++++--------
 drivers/net/phy/mdio_bus.c                  | 17 +++++++++++--
 include/linux/phy.h                         |  7 ++++++
 3 files changed, 40 insertions(+), 12 deletions(-)

-- 
2.17.1

