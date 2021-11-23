Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284DF45A96D
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 17:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbhKWRCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 12:02:19 -0500
Received: from mail-am6eur05on2103.outbound.protection.outlook.com ([40.107.22.103]:57056
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231629AbhKWRCS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 12:02:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CX/jrN2ckSS9MvOlrz+kTf1I2ExMte54sFBEvpHAk06oTY/jy+jfM4V5KOMMb+B+bNA9TR73rXFMMMRgrO1TlFs0Q3O59fIAqok2mtjrpIeCZqe6ajrCJ91LZP/e5JZmXTmjyYCesCCex88ucILG2XZ2bmKrMkiy5aJGnHnaUD6qcvzw/lH5GR33Aj1txoXNrYjLxNdiEaiPqjZFZkoGVvg7cyI+W1HbmFn05BYG4HJUrW/9bMRUdqsb75EOHb/zGV70qzE3Tdtb5a2b/OUGR5qY0gAFR3f8UwMgMkfwZA0OH40fP1XkB2RX6b2rQwFa9BjqDeQnWitVrtbdXdMV1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=53SdHpn8LadV5ZpltuMyNi8ahZUVHZ6UTsxCQcloeik=;
 b=fwnqiQ9Dbn1QpjVXQjmNzwWnE5YatHEa735ASve7uuTKA3cLFmWrq3+7lgaDCFhqOL0ren9VPYdVS4mP/4PtjJpQetACwlsEQyr6usQrynhNaeOKozz9Fpkh4qc1iFiuaapglBeD1k0k8lrZh9UXeJrrapz2psj1a0LBHP7vwKfg+1CIeG4jJXvCYpZ942VqW86+VlTfd3ZZ9tl/Xz5yDZolqyDC0wGPTN+jGAeUMR0xHNT7fxbhxpiHQCuFZwnnNodR1Dev4g0DFov+L0ifftyrjEoFeyCIakzynOg9jCO4J83vmijd7eBYGU1+35FY6hHdCaKjNfPFh/BEZvmGkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=53SdHpn8LadV5ZpltuMyNi8ahZUVHZ6UTsxCQcloeik=;
 b=GP/fRh1wBOH+f+BspOv5HHKSt7TB+i9vDizsiBrqQ/41HAKLmGlY5x8QWVDKgzpfD4dlwvzob4N0az+k65RVjnVpxrdQKewayEq6EAdHUd+LeRmUUbsI0vBfhMd02MCp966DDyfP5rV/YufndFtLkO7GYJ3+DsBvKimkkeXWNss=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0590.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Tue, 23 Nov
 2021 16:59:07 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136%4]) with mapi id 15.20.4713.026; Tue, 23 Nov 2021
 16:59:07 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/3] net: prestera: acl: migrate to new vTcam/counter api
Date:   Tue, 23 Nov 2021 18:57:59 +0200
Message-Id: <1637686684-2492-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: AS8PR04CA0203.eurprd04.prod.outlook.com
 (2603:10a6:20b:2f3::28) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
Received: from vmytnykub.x.ow.s (217.20.186.93) by AS8PR04CA0203.eurprd04.prod.outlook.com (2603:10a6:20b:2f3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4713.19 via Frontend Transport; Tue, 23 Nov 2021 16:59:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 428066ce-d502-426a-e428-08d9aea28fe6
X-MS-TrafficTypeDiagnostic: VI1P190MB0590:
X-Microsoft-Antispam-PRVS: <VI1P190MB05900165BF51BDBFE41A81BA8F609@VI1P190MB0590.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yTMOwgriovAxumd7sJOFX/IyAtSF1SvfXUF4WP00tTttT5mj9t15WXIJLtkltYuZagTEUh+qWn1sYyVxUnJCo9UHoxS+S+vIrbDmW1sGtCJMiRAugPZ4IeB447jg9Cy1zLl4ki53YSQn2WVpVB5AfLZeXAF2F6PxCSeAZ2Xq3Y8lreJb8N6BbDtTyl/PC9C5xpvZxh6Z/00kfrtmXScT+JAngvzT6hOtH7AMzHJUfZ70lLXO2v25rjAr4N8kXPbevKnW7yLvYEPXFimcQk/nuBHUEk3c8uYot8CXE1wwg9fv5r8TzTrPnKq8B3U+y8eGO+tMk1PWgLra9sDgFrCOztV6lqwDjZ3TTLBYiuRFh26Tkt4QQN2JBuQlSz6kFTRoDg93fW+JB7aGETxg1T5RDRFlY7jddUhawtehFrf0a/L3EYa0UTNflvsB+rXrc2MFsxqcTcxDSER/dHLqHULyQKrGCK8lkScmtWRHwkdjn+m1ENZEK+ge7vrR4ScZq5gv9JQp4Ahdshevw1Hl/WWaOat/canJ+24k3eloqNB3gBGEVcn26uU/X64Dafo/Cq44ayRR17P3LBTKWDi+mBDkMtY6lGFi93fF/qdxrJgnxAAKf89VMeldr/bS9iFzLdz19p0nRnmGedy5y6mDXPNdiNw5Bdc4D/fmBEIX9qpIWgK3kreLwB8p9vOOUs5aEwZ3AE9kBvSx1/34n1NBhEP5Hw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(346002)(396003)(376002)(366004)(136003)(6512007)(86362001)(52116002)(26005)(508600001)(186003)(316002)(6506007)(66556008)(8936002)(83380400001)(44832011)(6486002)(4326008)(38350700002)(38100700002)(66476007)(5660300002)(36756003)(6666004)(6916009)(2906002)(54906003)(8676002)(66946007)(956004)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OVmcKo1dMgrCfWlUMSwNlxoRCngsBtl2xzuWBenb9m/d0TACAbUS7SOYD239?=
 =?us-ascii?Q?GrRGgw8kEWzUlE+gur6XlafCIZUzuPSsNZPtyzSyAyyBESDSvg3tGV1Oaxtb?=
 =?us-ascii?Q?CrB2T/Pu9p8o/6TrPuf10K4+Sy6Rc8M3Qa1AoyhD79FqwT1Z9qXN8iWmZh3Q?=
 =?us-ascii?Q?mZ6KPKuWKDAjIdT4M2gYI2CzU7S5AGbU6S/tKFsoqvvRqatSlNzeMP4dGutE?=
 =?us-ascii?Q?ykjSebs06fx1JUgTXeLhjyUi+LFkwnp5N62oBQENWID+PrH2i1VV/J3Zmm29?=
 =?us-ascii?Q?S+t91xjRLNQkxboJZUvxdCRlTgkazW2sTOmqiH81474wp/DYj8uRkcoDQGl+?=
 =?us-ascii?Q?mJWtbZr4AaURgqn8j9WSi2USsBbMQJh1FlEVbadVDf9Ah3nKFW7NUV+Nremk?=
 =?us-ascii?Q?Xx4TFKbVUILxPwozg/Ah05WzeHHybdjf5//mmCOGmVtTvoXZC5u9Yj5JsBLO?=
 =?us-ascii?Q?Hm3cl9XIHQ5IUu0kfVTR7CjcmkdeBTLgL6Ku2wDo1E2kuv9I58y1U9UycBdi?=
 =?us-ascii?Q?G13HEyksbToCLhe4eP3BGWDYR49jmEVRC0rWQYyP8qaHn6o2Fv6Gp9hdT2DT?=
 =?us-ascii?Q?LXSQmTMvj79MzfilIvJfJeY0m9/5AJ8o9SJUNFeUDljBZ2HNiLRH70ydrfWi?=
 =?us-ascii?Q?72fA8ytjJIJ8Gxhg57FEpuYvTHp9gR+vhghZrircatnsWP2MSjccOmQSA6Nf?=
 =?us-ascii?Q?Ek5PO6BIpgbQeFo2CLr0ewxnoJL0rSKSwrbpbUJrLTTngoGezTWGzeou8hTl?=
 =?us-ascii?Q?4zqU0hNQuwSUdtQ/hTINfqUJ616Xe7539/2BPZ55yquFuEn2+OB/nU1sfQ2K?=
 =?us-ascii?Q?p+h90qZBLm71G7FuF8lyNplRwNWUAIK7DKhhFwSo7akyRiglTE3S/hriVaH8?=
 =?us-ascii?Q?GiNr/+6b/8K7IPT5npOJ04GgeEFKmUvaMWQhuRfQWuZjuh5wpWhZawprpBjV?=
 =?us-ascii?Q?zMirtw4sVvyXWrYLhM3vD9kyWUoaDO15241da47cnwZmesusPH3/y3/lHzh9?=
 =?us-ascii?Q?nsVd7HCna7BY3qwknmnNiy7ysswyh0tkyXD+8A7eDZrMG83wQGlxcI+HgV8l?=
 =?us-ascii?Q?ImwlXPexO4d9V+m03sLZFfhJTJA87gDqlJWkC13y4+G48dk5wXXD+I9MBDJv?=
 =?us-ascii?Q?2xjtqyVlCNQOxs0IvkW/LVGjC9K7aaYHiFSW4WhtJvA4KLjESr5zAvSZtiga?=
 =?us-ascii?Q?H3KmntYnczqheaNhmwX1hwAP9Q3s0WiSo4fjg7JTxoy05X2zwNUl8WejlWOT?=
 =?us-ascii?Q?JlnAxn/9P+SJWnrwYKf6RkObmzW9jgJiQqhqMBhDhzOPKNRhW6ru6galS+Mu?=
 =?us-ascii?Q?zwx1zEfaKRqd6l+OotnJU19No4HTYz5jCtLYTZZqAOfx2fetlE0wGbfBWVP7?=
 =?us-ascii?Q?Cs0H3L/mW2PyeDIdua53C/Cm4f2JOhBZDkK2TIoB5Yu8GYtgeBCUXmGNKZrL?=
 =?us-ascii?Q?i9YkTpc03V0iEaPdRNUAC3ToWTqQaKyWxrVTOaP8f9AZ0ekM0x7IxWtfymFW?=
 =?us-ascii?Q?ddGpRvX8sl/9GRSWJY1shGIndqWSqSwv76aHPk2EehkV4RvtkC/OXpy6P6QT?=
 =?us-ascii?Q?b5dhX0sieeH7AI3AE/kwdQvopQDEvudEFZk9ow+QY8y4AGwoHAZiBeuxE/nC?=
 =?us-ascii?Q?7SJJcF8anqS6I/FEKB3Ttamxz+p0VO046l7TIHzfR2eLUXv8uZc5Nh/xnVaY?=
 =?us-ascii?Q?LCoKgg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 428066ce-d502-426a-e428-08d9aea28fe6
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2021 16:59:07.3168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 32m6w5IwsmIdUixDF282OovmydDfeCGuOPK1eSEHaZzBpC6jgwsjRuhZ5Yl4nZJ6wEOeBS87A5iZdOkBjNvanjSpNWbfRxTYyhygyClJmvY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0590
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

This patch series aims to use new vTcam and Counter API
provided by latest fw version. The advantage of using
this API is the following:

- provides a way to have a rule with desired Tcam size (improves
  Tcam memory utilization).
- batch support for acl counters gathering (improves performance)
- gives more control over HW ACL engine (actions/matches/bindings)
  to be able to support more features in the future driver
  versions

Note: the feature set left the same as was before this patch.

Volodymyr Mytnyk (3):
  net: prestera: acl: migrate to new vTCAM api
  net: prestera: add counter HW API
  net: prestera: acl: add rule stats support

 drivers/net/ethernet/marvell/prestera/Makefile     |   2 +-
 drivers/net/ethernet/marvell/prestera/prestera.h   |   1 +
 .../net/ethernet/marvell/prestera/prestera_acl.c   | 699 +++++++++++++++------
 .../net/ethernet/marvell/prestera/prestera_acl.h   | 215 ++++---
 .../ethernet/marvell/prestera/prestera_counter.c   | 474 ++++++++++++++
 .../ethernet/marvell/prestera/prestera_counter.h   |  30 +
 .../net/ethernet/marvell/prestera/prestera_flow.c  | 109 +++-
 .../net/ethernet/marvell/prestera/prestera_flow.h  |  16 +
 .../ethernet/marvell/prestera/prestera_flower.c    | 288 ++++-----
 .../ethernet/marvell/prestera/prestera_flower.h    |  12 +-
 .../net/ethernet/marvell/prestera/prestera_hw.c    | 491 ++++++++-------
 .../net/ethernet/marvell/prestera/prestera_hw.h    |  62 +-
 .../net/ethernet/marvell/prestera/prestera_main.c  |   8 +
 .../net/ethernet/marvell/prestera/prestera_span.c  |   1 +
 14 files changed, 1744 insertions(+), 664 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_counter.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_counter.h

-- 
2.7.4

