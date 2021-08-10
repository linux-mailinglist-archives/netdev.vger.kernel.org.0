Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D627A3E53E0
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 08:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237081AbhHJGuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 02:50:21 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.8]:39270 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233940AbhHJGuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 02:50:20 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05lp2173.outbound.protection.outlook.com [104.47.17.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D3FBE4006C;
        Tue, 10 Aug 2021 06:49:56 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKEovaGspjS2tTmafYpr7C7GwPsIVVirC0yTBoGOMSXwncFyKLEA3BIGPSRuhZJtK9LoVGnK0ayoshCQW4f03kWaeR0onHuemqf9X1GrtI90bDMcI47rcSllx4mukw5eEye+oGlZWTvoSR9HzMRdEf4uYBbnSsp341Hu7Ef7p5zBQpSh1gVyq2WFzbY0ee7iVdjBh/MZ4gqcxJS0oJP8FuVvrHV9qYOtD8Qb1PwFOREZdU8EZqW/31ckKPPg6wL61JJpn1IVteL+RR0CadOA/Cb5yeMjTw8wT8/y8OlSCtIOJwMcdxSRke2vqQEHpxOrnBlqvA6KJNk+ctlbO+gIJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iF6NeJUefZW8fzELa9+3gDALzMOzBYFaoGR7KAArTYc=;
 b=fNB1FwV1mZj28zA2AP/BhRdUoAmrd7RggWkHCjDyXHiNK+Nq5SFpfSEYsVrC7h4WlCBlBJNA/+xXVT5faP568bH70BrAg8KNvCE61UkJG9ZV+Gc0ca8MQTskBHB1t/8A7rnohkcyM7SlMBWlFxtZuVs1nMJXAUg8o1y5HFIPhCF3NZC0dH/h7cB9C+6Ovtb3sctl1I1QQSm5ahlUUrV9H5AqzDxClOT4wqsrPHYgpA6aVaY3xK3T8qLTEKRu0jkXD/zidEkoxwt6TzDmX5qhgRb5jYAR27YG+i35fmrM9WMhg2Gbbu/X9JxD7ZGzQO4NBwE+b4dcmS540/g++5c6lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iF6NeJUefZW8fzELa9+3gDALzMOzBYFaoGR7KAArTYc=;
 b=bcfkBPi8mR6SEgh2Rz5W2vmvEXDiiDTmJzSbmhCcegzXOhpE5k9SWZ89BZ3IP5HhdZp3udfcQKL5Fy6t3ImBSj+N6jiWfp0u73Gj4Y5NIVwYma8IdGuo84a5aTHh9ETbxgTl89ndPcHqeM/eAlZAtzpKOHDlQemBhheJQ/BbJcU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VI1PR0801MB1981.eurprd08.prod.outlook.com (2603:10a6:800:89::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 06:49:55 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 06:49:55 +0000
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: [PATCH net-next v3] net: Support filtering interfaces on no master
Date:   Tue, 10 Aug 2021 06:49:43 +0000
Message-Id: <20210810064943.2778030-1-lschlesinger@drivenets.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0240.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::11) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (199.203.244.232) by LO4P123CA0240.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1a7::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Tue, 10 Aug 2021 06:49:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a59e63fe-5d57-4823-b49d-08d95bcb0f8f
X-MS-TrafficTypeDiagnostic: VI1PR0801MB1981:
X-Microsoft-Antispam-PRVS: <VI1PR0801MB19815DB2060229A2A2E34132CCF79@VI1PR0801MB1981.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Clcvf0PaIfTyw8C6xPntM0M09VBVvEvJKGKiShdLFMpnRQjyyv4RvWqQ6zQ4jhM1zYoKEjyP+zzEm9WAnwAAGmjpLg0LEz5EZYAmZTOU0l55asGKKaCa6l0Vnfy0QiMOgUokuF3XS18reey1eAX+TuU/R70DRrCwfA6bJ0BtgAAc9hrm4a7z1uguK+Bb+UxNyGj8T38lAIW75ejf7BHNeCQ0Mn8J9JBWSMFH5nAExvf1G/WWD+kHN5OOLjcDC9T/GMeeJ7UO7igbammhiSu4an8RxXClw6eSrrM0T9svLVIHnAoR52dhfuznzMgAbBBV26zND1kaZOhiDOs3xrbqBlW2IjSTDA2tg3emqbP7D8gBL4QuZRHqhBuTOcK+hyKKkzvaW2B53EM3xwF3oLY51LXNDEVKOrET41N7h1dbRy4M5O3u9hTfZMlwq9zhok041AZv4daOW/h+kyTn2KCDwTBUdMCHwp4uUbwDXvt6PkI/ZV91r16ZcbSmaciZn7cSnTKdRPxOhcJFH73M30IgcweJJylUchgIQhRQUA178ra2qw1UY4NXb1axYR/O0h1by2a/H/dIjeEoSM8nhLJkiUvdtV6jHJks2HEkH4xhg3Pc14dnGlpi6BqZvfNb2K+TW1xfk5mqJob92HiEA/iKq52j05TI299mPdqqvRTkzagGW6svcDJ0arGpdjdOEtBQFXqPuMpAR+9m7v0vXpECBXkOVGhqiCpljUhRZ0KwqEs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(346002)(366004)(396003)(136003)(376002)(4326008)(316002)(66476007)(6916009)(86362001)(66556008)(8936002)(36756003)(6512007)(6486002)(38100700002)(66946007)(38350700002)(2906002)(8676002)(478600001)(6506007)(6666004)(5660300002)(52116002)(26005)(956004)(186003)(2616005)(1076003)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K/yhE98iwd2Qklf8I9kA11T+d9a3vzfa9zKl36Hf8TdEeUhzg6Ft+7/L81Nc?=
 =?us-ascii?Q?HsQGXqPJDWCVIqN95wi0U60FnczGB+ZSedpHID6yqkXH0uoOEgP5tIeOvTvx?=
 =?us-ascii?Q?LGNpykEf+EsKtH/RuVtWG8Cv9nQbxAbivzzSY2gXWGftmqs0Tn/tbkbFoaiq?=
 =?us-ascii?Q?r65lQeX/Ny9p6lWVApcYZVRVA6LFqbCBpH5fzB9VqRFw579hHYFpfkqLJXgr?=
 =?us-ascii?Q?9BVDfKTrbNbeHE1TjSpKgk4XUJptPJ76z9/BnCp7SDH7GhjAsVWMVIdT+r7j?=
 =?us-ascii?Q?h4J71JE52512AwzyIb5CwVeGEgkvF0aHwjJ2Je8cq5WgVVB23oU+seXj6QtB?=
 =?us-ascii?Q?x8T4P4+MPiP4O8jjAJ7u3p/R1B8Fq5wYxsIGKvUd4qEAFzdLej7U3ZIgXjzL?=
 =?us-ascii?Q?I9Y+AsQgG7H7M65ovi8l353wRMMJoFncGnKcgjlrcmg/FCPyjZT7/aSmq9m/?=
 =?us-ascii?Q?AduG6LGHMrPydeuXJdpGP1IP08SYGA5xfNY0IfbTi2bsXO6aYBUOSy+fy3rO?=
 =?us-ascii?Q?fMv10MleTPsWvnzK7WGYkdF3ZA7LiYbIY0M07FACw1ZQovDUrWIeH4Q7xP1m?=
 =?us-ascii?Q?oHlU5aIIsYCQkzzynDwh+6SYnk3djbucrwIDKGTjMYR9O+d3/PccsVguEQiQ?=
 =?us-ascii?Q?xTAvpRjxHowU223b29KPyAZ2jal0cwnPbE5TSy8l5gJQbGYaoNXdabP+IiDQ?=
 =?us-ascii?Q?j1LlEvrcBsVeUvqyVgzNInQ+xgKP+/dx1KpRc9AVFYjz7Jugz4goQEtKVH5F?=
 =?us-ascii?Q?uNtUlM/e/Tw/Xx3RfWk0+SS2DjT8pnC/zinXWaFH4ZlN9sJ7m2t6ka1FbB1R?=
 =?us-ascii?Q?0bsyq6F6nPHuhRVTQ3qQQtuAUCiCkCyhX4n2jukHBkIR/X/dcyvxlFtUJmlD?=
 =?us-ascii?Q?BQK2u0Sj0NaBZff+FwfHMX+abZQ8GzlpIPVJouAekQBsYXx/Xw5wLO8FKKZe?=
 =?us-ascii?Q?q0wBD9fPOlnOIbcDDvadFqYzgOi6PsTJki0A6uakTFVG1386RgXFTsz/EyLe?=
 =?us-ascii?Q?mTYsFDiOnADoxy/D3KQce33S/r0NOpuVm+qzH03lgjZDtHgPjIxKY/MKduJm?=
 =?us-ascii?Q?KrLdqhq+c6hBA3o2cFdX7vugdyNxiNYCp53JuerbRwBs6TqQx1PQGyMu5YYc?=
 =?us-ascii?Q?KGi+s/M7G/TXIF7Bnhg6F6IkCdI427sauCxRxSIjrMSXAunG/Ix2X4ZVafYK?=
 =?us-ascii?Q?Fuj+hzwvfYftZPZ2yCavkxrWXAhyITrQW+e/xSv3Ir9GMcIYbeGoKuujoAiY?=
 =?us-ascii?Q?gCaU2RLjSx/Yl/qBLDH+jwfA+QoHsSEu8CXarhh8upVRf/z2ndMmpv4kar2q?=
 =?us-ascii?Q?O4jyrKL4D8F5wZqHloEddt6U?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a59e63fe-5d57-4823-b49d-08d95bcb0f8f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 06:49:54.9949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BLKY2897+3blpsKaHUFiA7bxwkp1l7WcsSzwFDCIaMlXypIfXGqQp2ltXCysN/9nNvGFzJjA2TKA8GyOmyV1u0zxCEBgEck0kOwSuVh9vtM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB1981
X-MDID: 1628578197-ZcnSAAl-7f5o
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently there's support for filtering neighbours/links for interfaces
which have a specific master device (using the IFLA_MASTER/NDA_MASTER
attributes).

This patch adds support for filtering interfaces/neighbours dump for
interfaces that *don't* have a master.

I have a patch for iproute2 ready for adding this support in userspace.

v2 -> v3
 - Change the way 'master' is checked for being non NULL
v1 -> v2
 - Change from filtering just for non VRF slaves to non slaves at all

Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
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

