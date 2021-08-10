Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7A03E544B
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 09:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbhHJH2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 03:28:21 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.183.29.34]:9850 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230138AbhHJH2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 03:28:20 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01lp2056.outbound.protection.outlook.com [104.47.0.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id C82354C0027;
        Tue, 10 Aug 2021 07:27:56 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZeV6YYUdAuhyUjR8C5vbirjuWapZPJ3ac7KptvSbzEeuBkrn/KH8HYceT0tUXL6NQBwHpcPOlTOqS+jfpjBHovaDZ4pB8eaGD9X/qhEZQoKZNqIuqmWLf+PEL4zlyD2JbGPeHntrsEjp6PpKm8jYd5Lt1mTtc6UO/RstMDq7LDM1LAJ43oSHZAx7ihDNCNiJOLkJVd6ofztc6sANbbVDiDJS9BVDzVcLxQMqDZ4gPgxMBtdIUiHhMgMn70PBitCY3E5VJxL0zSMm9rsSka1RbaaF72Lxnb15SQ0W0HP14A0KkqJ73Ng9BHIM7/LOjuf+MtITwH3Rzb7duNpBoHjzbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eRmzciMu3cv7n2Lh+YIH3G85vWN92ux8rw87zM+OxoU=;
 b=cvio+B9xunzUxgSQfvaieCznOPJXo+247skmlPZyU7AMxM5R3IoVd2FtY9Jbpo3gHAuW2WWHnYkqbad3UunnDH9G/71PYKPyWWt/mSfn7aRGitYKOXIutxKGlyqVC2ErfzuVHR1QpvBg89azSMojYcEkMv+Lu09tX8Tt3S5Q19msIHPBvDz+7TY5/9SGb1iE/dJ4lQKNgW92yyEFFHukDJZlHQqzpttul1kFW5R/ngTqJqRGnI+uQwIgYDFWDYpZ64hHc4jy6H74fQJPdGIlgvY8u7SDlq8muM/dkaK+gn9ZZD8XdEWoEOxQY0ddTwW0nkCVbfj205qz1Kcr88VK/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eRmzciMu3cv7n2Lh+YIH3G85vWN92ux8rw87zM+OxoU=;
 b=E3mrb2GIH+MzdFsAJC7BxK5//HSjzIwAKWRs01aGagf8bREM36mQ7nGxQ5Gk2WdjJXRFpsOPKkZ2a630NPJDyuhSuBM4UDhSWxJJzrRqMGVp4AWNsoTkN/CApy6Rcz9sLQ/5I1bKilrEHhxM8359hV8kvz9M5wshC3J+aRzgWlA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VI1PR08MB4045.eurprd08.prod.outlook.com (2603:10a6:803:dd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13; Tue, 10 Aug
 2021 07:27:53 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 07:27:53 +0000
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: [PATCH net-next v3] net: Support filtering interfaces on no master
Date:   Tue, 10 Aug 2021 07:27:43 +0000
Message-Id: <20210810072743.2778562-1-lschlesinger@drivenets.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0019.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::31) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.166.105.36) by LO2P265CA0019.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:62::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 10 Aug 2021 07:27:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2f070591-a466-448b-971a-08d95bd05dc2
X-MS-TrafficTypeDiagnostic: VI1PR08MB4045:
X-Microsoft-Antispam-PRVS: <VI1PR08MB4045E9A325C20E673A0A5D83CCF79@VI1PR08MB4045.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7B6DZDv1H0Qd2Qt1NFQpzS/1n4zTSq9NuUztuDG2KnabvdwrIWYuQ5ErTA/dKiNwMD/TKk7nXJGiF1lCJswJvsxW0feJDX9ynOeLYiAHBk/uS+Dqj9TPU6ei+0ZzoCw0psHbUC3xrjbb8Ypona43lrQF3Qbse1k+R2mIQ6LHO1KVnLVu25F/2XF6VQiYOZ9lU0AS5Ke/a69JfJcz9E9dqDOFwDU4tlczj1a10YcBvBqBnusVbkeBEtjCXFq3kRineK9SGosFYfRwkzQgWxA2CmdYGtRmGYgrBiRfuQzi5Rvqs7IkE+8Ih7EhNkDsgLJS6o0h3HcNai51SlK3rb77X5DC5cQWsLmcWZjyLt8IMgHtuFWbk1mxu9s8r+QK4/BzAu2c84d31Lgm6OPxg4UvwJbgQXtfp86hhrGVxLhgZp+qGogHxDBYboJeiDZrQSki82kfvpK7aKjJWrppVCfMcJPwqQhqC9ZKzI122Bsll1OkoT8Xkh55Boq9oLcXn2B/JaLpIF3CGmpDsUTJhNQKlmxlRDAZ6DefcTXaWvSp5tjM2xEwq/hmuzJ4RCZU3VkD9ICPMKUElmIKaJe2MswsILvjXDYNTYgYHnkbum9SnVsQiuiHb56f9xafrDortVzBwIbyL8g2cF1P9KL0aFNAEfgFABFIBtAXiGjiyoZiAZp/vsOShVmexVVBatwbCflNGm7CVUDUN2VDKDOBNw6KZ/s2zjcA/F3ff6S2mvHLjQQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(6666004)(86362001)(956004)(2616005)(508600001)(6506007)(36756003)(6486002)(6916009)(8676002)(8936002)(4326008)(1076003)(52116002)(66556008)(66476007)(38100700002)(38350700002)(66946007)(316002)(186003)(26005)(5660300002)(2906002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jyfkGH3JcOdausPMNrOxiO0FiFedQsBZSpbaGlD8z+Dhcl4okPrhJlX6a6Gf?=
 =?us-ascii?Q?q/zyVtdODru+DVBTqjzNTsyc+DNtUSOs+ULhqS+2wxuAGDdi8/+XmPEo17Cz?=
 =?us-ascii?Q?cKq4aWi1zoMRUUlWS4ptc1GffqnpGFxBnOS3eELpkR/PSWJ/h3Y5k6EhOMNu?=
 =?us-ascii?Q?DBThh+SFIx9zlXK6LfsUUQjhC0R/bq80j1pYwXjgtPQhf51VBEy6fWWhYBDc?=
 =?us-ascii?Q?yqEkwlxsQiOmtd/uK1/dnYV5Bj3TKE1ElcQ5JTek3slEqSOnDQRieCHp/CwJ?=
 =?us-ascii?Q?1kXAP6NJ4t3aX+3WwA+bzw5f6kBxU+qNJl8DSmbx1D0HFUuJ2lFp6sRg7QmC?=
 =?us-ascii?Q?m18Z6A9pDNdKGiq4UCbqOSLwIMXuHevu9S9vk8D2PbIF6Xom+1hI+k9dfG8T?=
 =?us-ascii?Q?Cpp/Jl7dlzW1lGbu0NTXieQFYDI/DkpX5cHly3cOJxw4JE7+0DpQkLDpwshY?=
 =?us-ascii?Q?AioicNyeOHcpunoXOYVdVa8MWGaUmh7LXHNEYFCEdb7T0HlpLrC3yedPqKd9?=
 =?us-ascii?Q?dj6WbPhJ4d6nKergsa8nWBz6mamI3/eWh1DFCdQEgppwNmjjAbXwcU1eo/xo?=
 =?us-ascii?Q?IB8T1Ws0PbNeKh23JIa5uW31aoFm77lfL3JoY6ErP14HyKGYnBba6oVLjoVp?=
 =?us-ascii?Q?DWjDpZieLVvNqEj3n1vtR1Re9bMHVUHpb8IZ+L8wcUX7yuBgJiZvLl2X5rPf?=
 =?us-ascii?Q?uTliagYysT9cIXRpAg25HB4AYGgsMd2dwrp/kWmVxKb543dlHlaYu6WijiWm?=
 =?us-ascii?Q?XSRDCTnsyzdUvRA3osz+ypearGKT2ue6M9BDyaq4jPp6l20+EFY94497bM6J?=
 =?us-ascii?Q?0WbyNVuehu8vjyVUur6Y2YxBiMuKg45Stt7e+rEZmgUcgPNpvCAk7eR8njhG?=
 =?us-ascii?Q?yMeZCDL5oNlp2pnIXiZNOVC+3IBGwOHwNx3+CCYcTE6CLOXuPmz9sZzRhDRf?=
 =?us-ascii?Q?TOnd8kCoIGQxMnItlOtE+VH+ecUoJlgoYFHGkA+4UJgq252FQGtMadEnMLe1?=
 =?us-ascii?Q?KaKaVkounPYRcH/Mw4i3jxOyPsHLj8c6+Xo3YQjcFOsxztq8OHhKn7vYbDpI?=
 =?us-ascii?Q?ImKThHqeuao7et45AW0GzcCpCXlueRqKhU3Mk+sTeIXDli8NbjTv5Obj9E9o?=
 =?us-ascii?Q?h7oo7JyZN78IwCdbEXoqGNyXhNCvV4gMoD93AQiEvEqSWd9vQwoqExtT4UTL?=
 =?us-ascii?Q?enY4jPpsGVXY0un5VOgOU3JRomzbdgacwxjW5yHgPOf+DkH9vx+fPPnlW0dn?=
 =?us-ascii?Q?l1t5z+3g14UoC7VwKgxRA6wZoM9AwYBtujQXj94A2ZcyE+6Mb2TNZMLnyRKd?=
 =?us-ascii?Q?tvFVpet/irFyxtNfHXD+b3OK?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f070591-a466-448b-971a-08d95bd05dc2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 07:27:53.5813
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0FDkU6Q446CVhlbuepbb5mwgTltZaJqktSSnDUMgpLEHakUsklHNFuW4Y4yPBVDyakqG7eb9/j2RzVT6Gd+nGcBlxP7vhOaeyD7ALxjSr/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB4045
X-MDID: 1628580477-KSL3Qip_9NP7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently there's support for filtering neighbours/links for interfaces
which have a specific master device (using the IFLA_MASTER/NDA_MASTER
attributes).

This patch adds support for filtering interfaces/neighbours dump for
interfaces that *don't* have a master.

I have a patch for iproute2 ready for adding this support in userspace.

Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
v2 -> v3
 - Change the way 'master' is checked for being non NULL
v1 -> v2
 - Change from filtering just for non VRF slaves to non slaves at all

 net/core/neighbour.c | 7 +++++++
 net/core/rtnetlink.c | 7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index b963d6b02c4f..2d5bc3a75fae 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2528,6 +2528,13 @@ static bool neigh_master_filtered(struct net_device *dev, int master_idx)
 		return false;
 
 	master = dev ? netdev_master_upper_dev_get(dev) : NULL;
+
+	/* 0 is already used to denote NDA_MASTER wasn't passed, therefore need another
+	 * invalid value for ifindex to denote "no master".
+	 */
+	if (master_idx == -1)
+		return !!master;
+
 	if (!master || master->ifindex != master_idx)
 		return true;
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 7c9d32cfe607..2dcf1c084b20 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1959,6 +1959,13 @@ static bool link_master_filtered(struct net_device *dev, int master_idx)
 		return false;
 
 	master = netdev_master_upper_dev_get(dev);
+
+	/* 0 is already used to denote IFLA_MASTER wasn't passed, therefore need
+	 * another invalid value for ifindex to denote "no master".
+	 */
+	if (master_idx == -1)
+		return !!master;
+
 	if (!master || master->ifindex != master_idx)
 		return true;
 
-- 
2.25.1

