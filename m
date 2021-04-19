Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70BE364808
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 18:16:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbhDSQRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 12:17:18 -0400
Received: from mail-eopbgr70040.outbound.protection.outlook.com ([40.107.7.40]:40420
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238515AbhDSQRF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 12:17:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UR7J6SMJMyNeVmBuDR5RR+9yyhNQEmLJvI6vvz9yxTpDR051QDwNrX7t7btexibhtQc/xkYlfp/P49OPbF2sF8FMqiggRyZHSzgGgBzb2j63ZyFIWzoSJ8y9IVkvgNURvy/RmP8fPvHFZUDJVwJNpxNLDFHEfmZsvwdu8LmeXv2Ta/XQRvPniqGIzDJo9HBfRwRVgiOHdg46ztX86Lk4ICiO4d/cG3pQmIIcDPhYGNA6QvGjEjs/SleG2tZ+FBYBSmDkFuTXqPrsStiFTg6FIUgvo3u8kqC0XPLifExGiygabH01jh1CDvg+E3+QHR99FXdohc9VZ978eYd74YnuqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yX+bTlbeimP6xQwqiz46ROMbd5/5Xt7ULXP/kGsekxY=;
 b=j5LKeETStRMqPROSI8Q1+TMsdFKFAG0MtaxVnyzPkqWlEsu8yVVOlUHBD/W1NpacfELz97S0m7l6whSlhzmv79BjB8DJyAQkRgOrWqbyVL4+qdFFEjHdTo5TShhxF1vTt8jZ9/yw2XpHzXQbau61KBSMoocvEUxaYfRAohcEZgdOxCgzQX0GLCB6cP9YlYwOKt3uRwLnKER+u4ZsrLW94qUYrT0P5AjqeUNZsCIgG7MYFf6wiGcnWtZC5NrlSS32oBdmXNMXjq3TTAL6SgycJZyxzPyzZhBHp2azwD4/2DGN6exsVYqXNiYe0Jt3NeASNAzQ2wrinklpXQYf2gRwig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yX+bTlbeimP6xQwqiz46ROMbd5/5Xt7ULXP/kGsekxY=;
 b=dW/7geamICUXSsXk6v0NbVQCiIeik//gzLFvhEZn889iZQZx7wtrCEtTDam63w/PARh3tD54sZQJTE1q5YlMmoWHnimfQ62wqtTZQaIrBRtsyMEiw5gORDubS10tbuZjbSYykNe4+RZbjSBeeFkQ/F1yJJIWoeKUW1TzuU56TSs=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com (2603:10a6:803:5f::31)
 by VI1PR04MB7102.eurprd04.prod.outlook.com (2603:10a6:800:124::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.21; Mon, 19 Apr
 2021 16:16:32 +0000
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945]) by VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945%6]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 16:16:31 +0000
From:   "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
Subject: [PATCH v3 0/2] TJA1103 driver
Date:   Mon, 19 Apr 2021 19:13:58 +0300
Message-Id: <20210419161400.260703-1-radu-nicolae.pirea@oss.nxp.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [89.45.21.213]
X-ClientProxiedBy: VI1PR08CA0198.eurprd08.prod.outlook.com
 (2603:10a6:800:d2::28) To VI1PR04MB5101.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (89.45.21.213) by VI1PR08CA0198.eurprd08.prod.outlook.com (2603:10a6:800:d2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Mon, 19 Apr 2021 16:16:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b81796b-3f6e-4894-ef8c-08d9034e7e89
X-MS-TrafficTypeDiagnostic: VI1PR04MB7102:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB7102FC333DA0F1AD51DA05D89F499@VI1PR04MB7102.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yevCKOH9cG2K7MogZoixfG7dTVs3PqAVAEieRp3hEu4xvYvnazG1tRuXI7jRGalazNvNUZVTeUF230TCIq/liAADl3HztXSL5LMGjDOBv9NuQSL1jbTaV+EhWcPxtidEQj7SVuq7bqhny2r+1gi8Fc5NqC2zDjBxC+ai7sD7lwF6ea8C5lsDTuYPbUinIr0BEz0y7GsCJalfaaVPI6YzRrfAfxp3vb85wQjs/TFp3hSJXEPkj2tMXzOyoLtakId3EPNy2XdQZtNAPvTx+gq3eQlXzt1iRNZTFBcATh5eUiQrQnVf4wc9B4Ck/MFjRqZ+zBH1InB9y/ZgyimCBXR6pTnOadjt7zi3u8MpJ7wnOv6hBiP3L1XSPE8Rc5nYjIPomoeaBfCXB+80/tYP6O5dj5M+w5Cndn3m1AQnSTGq+yYd9DJaPnWCgpcPKxwCp+Sz3HbsQuHeEB98wmhFpIOSg9TbJzsgBlPLEiRi1MXwvVkQJBhbgrHl4eqFBx7ZcISKfwjQyfWwQhM8ne18BJPJktGC+98K067Ba8tDwYSCpsTkasFYFy22KVkTEKMxdzA2poplQofdPt3ZCHtTh/WXgJwJ+ySbVUNCrkxyrj7piKdCmp/o+GiAJsY5fzxeRLl+8uBLwUb70IBYv3FyBCDu9UldCCUDBl7E8UNXZ2QF0vOZQuut0q7y3QRV1CIG0bPJzgmpFW4Toy6FjVQkwcQ7VA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5101.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(366004)(39850400004)(396003)(956004)(38100700002)(5660300002)(6506007)(8936002)(4326008)(1076003)(83380400001)(6666004)(66946007)(38350700002)(2906002)(6486002)(66476007)(186003)(8676002)(6512007)(316002)(2616005)(52116002)(86362001)(16526019)(26005)(66556008)(478600001)(69590400013)(41350200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Mc8ekttF4CJxYYKWd0LNO2L3nGVd92VGCgvGTj9bf6JyN7GfDWysaQZtz/TR?=
 =?us-ascii?Q?SzJeOry2BdpwlQvFmGmHisGTtyF/60638Cyns25gQB5wfMvUnPj2uvQLVvU1?=
 =?us-ascii?Q?FOfPAAe4MOWfwlJIpJBMQ8y9JGxrv3XcwnuRicdH1WbZIwYVPRG4SlUwtd+I?=
 =?us-ascii?Q?bShjBt1XaA3VbWefhM6lDyt4OYBs/IHwIxZpgbebP+ZVycz5lvyl6afWe/7t?=
 =?us-ascii?Q?thC1+c9Koir1NTKHhFZpulZXzfJyX1py2VVFVlDRy/MAx+ZAYAPvo0P0xDgS?=
 =?us-ascii?Q?khKlR2cQZgtCukwcAeKPOcqpmw82zA9mErYPCtOPYMjPMzEZbnqSbJ5SCpU4?=
 =?us-ascii?Q?Qkc1TQ6Kiw28tnqVzG6VEnK31ZLVa2fsGm0BKWgA+IGKUhNrBQcKmriq1Rv7?=
 =?us-ascii?Q?Wfr8oe+3313McPWFLf3sOL97zgwQ+FnkpkYYXbAs+/H/H+Rmb33mivABj4a9?=
 =?us-ascii?Q?TUiu6mJdRuSHFLjOPtXvITbe+NEDvPw20cwpT1UMLOahbWxvoO2C9OmENZjg?=
 =?us-ascii?Q?GyRlYIrdnetWx8s+nvqe/UY+QbNkNr9/4jE0ggpA7pN8jmJ/m+9+QDIojIt6?=
 =?us-ascii?Q?cznbbDRH8qjuvjXIbQAF6kiv0xVp/zGf8V8lL2yCG+alz59YKjhg4Qeaaws/?=
 =?us-ascii?Q?6Plbq6wXAiWlJM7vqFHbOce/MnTcvXOBvkWMbVLZDZHOj5pAMLi6Oc1OX2Tk?=
 =?us-ascii?Q?k65ad0IJuIV9MGgfd3P88AYhpEQwKfS82a42bhnRXknCqyZTtLOKLqJI3TYZ?=
 =?us-ascii?Q?EMgNk0u3gy+aBcpXDOZ2QBlr/nU0zVKsnbkrg/v9VSZT6grRmRXZchOuPyJ2?=
 =?us-ascii?Q?hUdg6CvNqmFspF0RHqRU2ppwiobH4J5txcMvc4vevYENjLHFhMmzfYC5RIrA?=
 =?us-ascii?Q?cHv7Xl3Fi8sUD3C0mCz7x912pBztHKCb0HrqPGN87hrg7+k2CIP2nQtgevtT?=
 =?us-ascii?Q?roQ5Mq2mspdA+lsRCXTjyNnyppyUjGE3PMi+9a88iEIfC+djRBGUpEzxr16K?=
 =?us-ascii?Q?inSpNJYgCx+bnK9T+x2q0IVe5Fz1Hgq/llMWBBr/GM8qqLLFzRwiHDUqaWFy?=
 =?us-ascii?Q?qoXA3epHCfl1EaCwA4XNwXaxEdyq/c0D0wXWGLvqz4GaarEMnx+ae516jbmN?=
 =?us-ascii?Q?ngDrezUBdPtZ4ZtqQuNf7Xc3jdGYHKTZuAqUCQtcvxjKYSeKhZMPYgI56ub3?=
 =?us-ascii?Q?lQ5jLP8mlNnvs9VIjKcq0yok9c44NXATuTXeWYFAzV8O7CyrMNFBMDPVCAOi?=
 =?us-ascii?Q?ZuwKJYLNY+BLYA/SkZoRYbOQlACt75kXFSVW5SSb9UnVJjzO9KIK8OC6Zl+V?=
 =?us-ascii?Q?f1MK2eBbE14ombZkjbg2I5pJ?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b81796b-3f6e-4894-ef8c-08d9034e7e89
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5101.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2021 16:16:31.7425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /YgWBA7IxogOvHdAR/y89UPEn2wGSz0TeWPrd6MP6lLWp5PlGDAdEuPB0VLXhRcaVUJhaENSRbUGLUDb62wVAluffcUosT6wnL1KFw9sy3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This small series adds the TJA1103 PHY driver.

Changes in v3:
 - use phy_read_mmd_poll_timeout instead of spin_until_cond
 - changed the phy name from a generic one to something specific
 - minor indentation change

Changes in v2:
 - implemented genphy_c45_pma_suspend/genphy_c45_pma_suspend
 - set default internal delays set to 2ns(90 degrees)
 - added "VEND1_" prefix to the register definitions
 - disable rxid in case of txid
 - disable txid in case of rxid
 - disable internal delays in rgmii mode
 - reduced max line length to 80 characters
 - rebased on top of net-next/master
 - use genphy_c45_loopback as .set_loopback callback
 - renamed the driver from nxp-c45 to nxp-c45-tja11xx
 - used phy phy_set_bits_mmd/phy_clear_bits_mmd instead on phy_write_mmd where
 I had to set/clear one bit.

Radu Pirea (NXP OSS) (2):
  net: phy: add genphy_c45_pma_suspend/resume
  phy: nxp-c45: add driver for tja1103

 MAINTAINERS                       |   6 +
 drivers/net/phy/Kconfig           |   6 +
 drivers/net/phy/Makefile          |   1 +
 drivers/net/phy/nxp-c45-tja11xx.c | 588 ++++++++++++++++++++++++++++++
 drivers/net/phy/phy-c45.c         |  43 +++
 include/linux/phy.h               |   2 +
 6 files changed, 646 insertions(+)
 create mode 100644 drivers/net/phy/nxp-c45-tja11xx.c


base-commit: 5b489fea977c2b23e26e2f630478da0f4bfdc879
-- 
2.31.1

