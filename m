Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBA2463112
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 11:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbhK3KhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 05:37:24 -0500
Received: from mail-eopbgr80130.outbound.protection.outlook.com ([40.107.8.130]:48615
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233088AbhK3KhY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 05:37:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xbz1Xiqi5w7HnFBMzDkTe/fzli7jiEf1LopKvSuD3zkLnL95gdsTcyhDGwLDbEomZHKgISPXeXv4A9VdN1OebRyRw8dWIZE3ChvfvqqVEA1STbzFGjcU/a7zVg1gPKUCx/0No69PAUwO5+1NiImOleznlV5wjWlLy4ron37gzGssISIKCF6+dIMY17NlJSJQJk+kLU6YDy4Hg5dD8YLoXCyJCjTzM/0myh3yp94PNc89Daf/P0O1+RWmyPm8hvk6FjxjdVN2gp7DAW6PP/v0ZnO6WMRnV0XoCpkju4eRFgNegvgcywTnhv1+O3CmAtfiMG4jtqGHcDvrZFjxTUx0Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=es6PbYNlCFYZdV8e4641Iske1OnVyWCIQeZwI96/Kic=;
 b=YEf8B/BS9z+TJiq1A1mN6AJv7kPMrXg9jpKt+M9KdopNV0kBEGx0x4tkSdhcG8CiPeUPGuHqivIPUy0FXv8A3meMHNf4ZGMmqbQNriDz+u3GdB1mN99NyQeOQAIBro5asre7HkbnVEujarmDuMSmkVKFmETtDopku6CkpD4zpgtrnAKnNsUKn3PJvO/GiPdNyFGly1k7kzcL2SM0mwMwtjoCzkFGja11iVfZy8bDf9lO+/LVZXAWY4jpavOjRdKarqM0ju0I99jgMXQXbtNRwtH4coUNheM3LWaVkz8O73m4mAEpy0VsW0amf2PSwnpgHlV+DyoKsnOP94q0NKppDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=es6PbYNlCFYZdV8e4641Iske1OnVyWCIQeZwI96/Kic=;
 b=HCq8dt0MjrtdyBZ9BbOS+WUpXaayMCfpPg4AMBg7AjJ3jYx0BckptVpaq49M5wXlKtmpq6oTizUXVG75biBtNGm/5yKyBmO0LiswsRsDtgUvfmjO8qKJCNxHI675SofJh/oU7OHttWP1eCQVRfW2VLJ6gKftDZIYtMo7ihGXHLs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0064.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:a1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Tue, 30 Nov
 2021 10:34:03 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136%4]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 10:34:03 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Cc:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/3] net: prestera: acl: migrate to new vTcam/counter api
Date:   Tue, 30 Nov 2021 12:32:57 +0200
Message-Id: <1638268383-8498-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: AS8P251CA0008.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:2f2::26) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
Received: from vmytnykub.x.ow.s (217.20.186.93) by AS8P251CA0008.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:2f2::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4734.21 via Frontend Transport; Tue, 30 Nov 2021 10:34:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 088ad805-e774-4e64-a525-08d9b3ecedb4
X-MS-TrafficTypeDiagnostic: VI1P190MB0064:
X-Microsoft-Antispam-PRVS: <VI1P190MB00642E81982CDA1FCB8BE6A38F679@VI1P190MB0064.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vwt0S0iMHa4jSaJiuFifbu8Rcl1T7IBxSlfwomObm38kVL9ww8u2Qmt1aZmHpXpgACRpg2xX0gaq9eiWi1tk0ugTnrAaKivCoCqEuZ6mesySLq1eIVADG8cz4ME4AsWknuFSDCF/avnvjPrs0ZXQk7wYZZxP7ZBaqPNXpXVBRCVT97o/CajTWwPkz1EnArf/FN36U77HPonCfZzcX523Riwwo8G51ihX+CuLS7q9oAQDzCxQogGCuSy74klun2PZghPBXw420S93oVCO4vQZ8QKtsy3C+eIbZtJs/aDIh2bqzLT7yAowD8gE67p0xE90EB4bAF4yNuUo/xPQIa0qZm2bt194kbTAc/HGRJJooD6FsGcl5tKCbVQTmzhMNKAi2ydUe4/jQQogcyl/llx70FPGdbMAunhZW/MkEYsiGOwKO52x7STsW0Zr8L1kMtHn31I28IDhqmRE1JtLsn6xipomjdja3+RyEcZeMObvu8WiVor3065A4vwBf/90GQTj+HxSVYYjyz8NrUYPZ3BzgUBNoRuSWwifq9uvVPftr4gVKO4yEmW5/AoLid1Apw5JQOfxU/z2/lXsMYoDI17PN7Vook7JNJADcrNwvB33zxfr8JrNytV3aFDYjmruQqe4cN/dq/IDMEJx0eyws1M4i2bbZHx3t1CH2GWCNpT+Lkxqh2MaBXXOPq+Mkgzz+Sqb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(396003)(366004)(39830400003)(186003)(83380400001)(36756003)(38100700002)(6666004)(8936002)(38350700002)(26005)(2906002)(52116002)(316002)(86362001)(44832011)(6916009)(66946007)(6486002)(508600001)(6512007)(8676002)(5660300002)(66476007)(2616005)(4326008)(6506007)(956004)(54906003)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wQS02AY8Fy+TaGGjyyqoRzojlpF8WI10lPTxOWFwlje5fM1kRc5KZ0rUadjZ?=
 =?us-ascii?Q?zri7mE4INEoZ14dormijkrZJGiFMi6LJC2gvIv4tvmW14hsgL594bh7Pzix0?=
 =?us-ascii?Q?dvPMMC94rtxQy72GBHEPKy18dhY4/fSM9/ZnTbwfgmoaBwT2sKgzSUgWx62x?=
 =?us-ascii?Q?Lqz3M3Ga26hdXuYxZ8IzAF7oYsjB6zj24QjD/tQqpdmlh5chm+zyokVAQ4hD?=
 =?us-ascii?Q?77/GLjMazesrBtVzelSTflA99E94y/i0H1MlaQhyPIZaBVyc1xXyIpTv4pbR?=
 =?us-ascii?Q?wtVe9YXxDUi5aI0XrGFLwFZyCWPKYiXwDpXnli2t5uM580EHxwMTP8hc/tpq?=
 =?us-ascii?Q?p44w3C6tBpKjg+BgEHrad6NMHAYZGWzPj0PSgPnq4khj7MBjPMGyuRkaCje3?=
 =?us-ascii?Q?Rj3wVdC9g2NXiLHGfhOsm8NbTcmZCtPMInBl7qI2K733ct5XPduOsxkgnQm7?=
 =?us-ascii?Q?GzHD+N+7xH+bC5jD1bs+KD31YK2TZ8XIE4waXsZL+AHlF2mWbkeaMk8A7SK+?=
 =?us-ascii?Q?8fhGKZz885ciyXyW2nJedyNRd/8vZQJXZtF0PEz+J70v1H8eaIiCJ5d7YWdy?=
 =?us-ascii?Q?WWS3k0AqD8Wh3d2Tc/IBrmobTwc9pJS8hx8VZvfgLjG2rsJpi4ALvaaVIKRW?=
 =?us-ascii?Q?c6yLEMAJMk7RvEtDAvM1AX/JhVVSFAIY8apeblY3JCoFkKT9tTCmtzuKw7qy?=
 =?us-ascii?Q?5aD+brmTIaHZlUZs2+rtAWZC4wEigoOzV6VRprF98i2tSQLEKUz1uR+vD8xS?=
 =?us-ascii?Q?X9UUz7w9biJmlpVYQAkz+BYR3fuGxpBYPUiW+tPHCTQE3eZCWF7ELNT2kZ0g?=
 =?us-ascii?Q?pK9ygG8kBvs0yM8s15V6IfLpZRIiLp1WKARtbPJpc/YPv7q+lPdYLlRWDzMU?=
 =?us-ascii?Q?R9vQrwtjme7fR8u7ddm9x0VC84JhKK0QE+/4xV22pxZqHEs+ZAMTSTq5jBRN?=
 =?us-ascii?Q?PjcBZ8IVEBAJAztzIzGHtw48e09zA6+NS674mzOCPeA0ovP2ZKM6UXqzWsJg?=
 =?us-ascii?Q?YTwKcqU56+8kNReYCvzt1CLJ+hjdUDmFlXpOWMMtStJHkFPTaMPNWenufrlO?=
 =?us-ascii?Q?h1JlanLvTM7BdkXSPbXX9XHAxTyPUggaWjM0RAwBwO+trpNRapXgnAU/Ime0?=
 =?us-ascii?Q?gJ7sAi0VZZs28vs5ZnUK/Oq2VPHrU7Nb5SQn4OucHQwHYlUfSB+akkD/olc1?=
 =?us-ascii?Q?VFHNjZqgupgui+ikkljTPpRlrrbJg36Ctpy/BGtMjJvQHKpNOoqU8MekTfQE?=
 =?us-ascii?Q?WAi/vB1zSlPYxqRj2uybz9Ky7nFecwYGj2PJKTfZkCAMdVwIuSxLT2MJ5eb2?=
 =?us-ascii?Q?gJUJd4HUZobyeK1AZw3r4bVpn6YnJbHKB/vTsLB8wepfthx6bmeir5tp5WCq?=
 =?us-ascii?Q?C9WiLLdMec8ax5KuMW2LydswcBZ4+cmOyM0jtu2jFcou/sgIAmw75LhaZz6n?=
 =?us-ascii?Q?AgbZPgXQE8TsFody9/O2q/LDmywPG6mPsgh6c68HzFbMT03NqGrwzITmGDrS?=
 =?us-ascii?Q?rGzibafS3g1OodyV/vHdLkbuO0Xg6SIrfw/6NfhMIJ+EZpC13SgKt9KSW/og?=
 =?us-ascii?Q?XzhKjAU03BDrjc9lBcSaFL5y17aHRW+jAtkcEsEnBqvW2E1l3GdHux1YVGHy?=
 =?us-ascii?Q?47/0A9EOKmT6tNWqbGb5PX7rQbBtQ0hvLSzu/Sss/XT5IafCgsJ2IWww/gpU?=
 =?us-ascii?Q?8dEXqA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 088ad805-e774-4e64-a525-08d9b3ecedb4
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 10:34:03.3329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kTQD1iX4laMzWhV7YaueaaBQ7ONbPmKdRA0U4/cl+gU7IfJHnAY319tG1mvRLlyx2G7NQumeZz0qhQ5bQP49B0eibezzWTYhCNXIdggKyxA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0064
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
 .../net/ethernet/marvell/prestera/prestera_acl.c   | 678 +++++++++++++++------
 .../net/ethernet/marvell/prestera/prestera_acl.h   | 213 ++++---
 .../ethernet/marvell/prestera/prestera_counter.c   | 475 +++++++++++++++
 .../ethernet/marvell/prestera/prestera_counter.h   |  30 +
 .../net/ethernet/marvell/prestera/prestera_flow.c  | 101 ++-
 .../net/ethernet/marvell/prestera/prestera_flow.h  |  16 +
 .../ethernet/marvell/prestera/prestera_flower.c    | 283 ++++-----
 .../ethernet/marvell/prestera/prestera_flower.h    |   3 +-
 .../net/ethernet/marvell/prestera/prestera_hw.c    | 491 ++++++++-------
 .../net/ethernet/marvell/prestera/prestera_hw.h    |  62 +-
 .../net/ethernet/marvell/prestera/prestera_main.c  |   8 +
 .../net/ethernet/marvell/prestera/prestera_span.c  |   1 +
 14 files changed, 1706 insertions(+), 658 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_counter.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_counter.h

-- 
2.7.4

