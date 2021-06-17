Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 721863AB950
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 18:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhFQQRL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 12:17:11 -0400
Received: from mail-eopbgr70114.outbound.protection.outlook.com ([40.107.7.114]:29326
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229599AbhFQQRI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 12:17:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nrlcfchH2jSBJFifC3/FI4oSfI1CRFgM+Gw2RYdVhN3B7OX0NQLTTaphDpoE6ZLCJnx3C7tw5+90QH0v6SYkJCPqddjFLPikPsR0p8XlChlgZ2rrse7rnwxOH9qgKA0jNoMpcmJWNCWahMC0RFrQH+YbtYpz3L9q1OVPmHxIMT4NGqmnzZpW9VVlJ74oCprb5uFgUuBdlS6e2a1Q0EPDavgkz9aRFkMDf5UC8GJehRN4z5FIiQkgIRI49HI0ma25l0Nbj/6p1gGHr8WtGhCFpDa2y7avFIhiKs3h8m4u6qQO8U6Ky1Vy5ULq+0Xz7zrpZIbrgGgcdgVtTR87XDDOsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YbmGNlyEwrzEGuB92BBBc5WpdBbYTc04oenm+VmtGWc=;
 b=f+o4BfrBGE3Dg7mcuSE0YXqcLY5K2b9OBxr2pg9/S2rTc3Gf6yRU4opJhQX17nqMDMTuGt5Z5wKDui6k364Av92NSw9aI09ItuFIteICML+Rhn9X8FIYGNa0SIGOWZM5BK+exBxOauAS+3hmMd5Z75hvr1ttSbcPk5jXleaG5P/LQ8FGHFWOUkI+dUnZdVPGaQsKuBqvFyaR1GA912DoxrUwyXg0e87djgdyXxcUN7fKLMFvjo4ERS9UE7rvHoD4jGRmV4OnxhNXHmW6u5gP1CiHE7qZH8fnGuyuO3SfgmVEMJZSs06Ba8/GJ8npKSD80tvVxnimNDkwgC8WZvdwXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YbmGNlyEwrzEGuB92BBBc5WpdBbYTc04oenm+VmtGWc=;
 b=SGRFyrE2rQBsVjwMoNPHPU/D3Rf11U7RyUER4w+T23tbm6vhflpjsvIlgMo6eXWZRFHbpdsq6KNDQ9LHjcOOwFqAXFieEYjkxbQRdv+Ipq9L5dyMhp2QC9HarfINBnw7EAjypLDFT0GAy43AachUX3L6b7B9No8MxVQEBc9NxNs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0508.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5c::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4242.18; Thu, 17 Jun 2021 16:14:57 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a%6]) with mapi id 15.20.4219.025; Thu, 17 Jun 2021
 16:14:57 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Boris Sukholitko <boris.sukholitko@broadcom.com>
Subject: [PATCH net-next] net/sched: cls_flower: fix resetting of ether proto mask
Date:   Thu, 17 Jun 2021 19:14:35 +0300
Message-Id: <20210617161435.8853-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: BE0P281CA0020.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::7) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by BE0P281CA0020.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:14::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.9 via Frontend Transport; Thu, 17 Jun 2021 16:14:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53fd1780-dafa-4f66-e801-08d931ab0c84
X-MS-TrafficTypeDiagnostic: HE1P190MB0508:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB05086B1BC55E2823EAC55424950E9@HE1P190MB0508.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zxoooxpWWLZ4GIVAVwerLsZ3Hgm4U3DCBz0XMVK6tcduiafdm+fQsqR7GoUWgJASpWrmCe57Yrd6A93Bv8nOS9U6AKYfQs2A9erlpbq3fRX9JsDNRW3HmL9zZb9HetCXzdxfua6PyILoj90Mz4XZhVI/JIBo4nY7EvHTdIdjFRyO+e3XXJt+b7sFy4UHG7BvujhO9ebstSMGqh+QydEmu5/j1HEQ/LjjTyTEduxQI+SeK1vYfe3nqgm2N5YFgIujurqQFGoZg1wLoUPeSYtBWUuTqjdXR1K5RNKnrfk4rBVUSaTUuIaSqNTL+4ZlTflWTj/Yk4a9C63yTrLsXqtEmm/m1RwttYlejSWrTAqRe9fm7jYh5g6lypeXFiIUwSGnjDS3dEp5HEeWROgJPspNBaSKHVe1h3B737MSPb683DN9qlDXtEgGIvOptGvHHrvGXIyEgLPq05dLWGCSJiWXZqjFmJOzdugLm9Aw+Qrlv3rjd4apkRYRhE6zMecuLVYmDbQwmmpIE/3tO0SgmXby84kTYTeHvCMMAXFzJ6kqoB6VfCyaWBlyFSdYFGbkBXFi6P8fBUHNKHAn9vLNycBvI5Xu5Q0DdNPbraX+5CN9Juo07XhmVlsVs8SARA0sFJvHzaLZ+gtmmth06Mx+miPNxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(376002)(39830400003)(396003)(316002)(26005)(2906002)(6512007)(478600001)(4326008)(86362001)(44832011)(8936002)(186003)(6636002)(36756003)(6486002)(1076003)(38100700002)(2616005)(16526019)(66476007)(66946007)(66556008)(6506007)(54906003)(38350700002)(110136005)(956004)(8676002)(6666004)(52116002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NePyKSk+E4uLdGrqJUX+acD2wI/Zzxw3y9Wimj2qL0vTB0eh35mKMPY7KSfM?=
 =?us-ascii?Q?HpVNGUQsaI6xhRXnbOPE9+JAUxX1H1dM3hFflrg6HUunVswif0o3D7B+phOj?=
 =?us-ascii?Q?9IpBseANUFOoKGjtTaOQ8akTW1gNQyZrjyiZQG820VWdco2SPHntBOQ7UhHF?=
 =?us-ascii?Q?TK7Z2XD+/nj5F+PsAgmq7PWw2ogLobALWFaG/yWpw1hqk/qlYAoYOH6YR/f0?=
 =?us-ascii?Q?5ct0j6TfatnTRyjqaB8WpsvGevU0+MSqtDUd4kts7pj3Y3OVtkwLp4KHZrdo?=
 =?us-ascii?Q?uQQs0K7mQeomHS3tfjMzR5QkY3inOD2e+uKByNQPHCG0mKmP9prlyQnuMqPs?=
 =?us-ascii?Q?wUniTgf6DbeIloMnuwFPoX6AEnDHfqdvBqzcekvPjKu11l2Sl4mZ64Kf+leB?=
 =?us-ascii?Q?wim2w57EeTvL4RnrmhXrukNcJQd0WzBGQMheTd6xMJp8lCmBk7n+w33lU+y7?=
 =?us-ascii?Q?5c4BxagC0DV3f33wW/XFvffoStoxa+YUWXfL2RW/fcqRG+QUXvL6chmjkb8x?=
 =?us-ascii?Q?rj/NZYNay3nvra2ggeE7pXcBl9SgEF68ypTdfsktcW9FX5cjTkfbbf5f1Irj?=
 =?us-ascii?Q?8D/EhdVmpXaIM+bfpkPdE8MXVENQZkRI4XqSHi7l0MrtnMvUrJs+QVl21bAX?=
 =?us-ascii?Q?CkOfia/k86WLF9EsEuzDn9+IWYGM5HAGlz8c6XDiWiPh/2yb52OKxbNDp3pz?=
 =?us-ascii?Q?PRyq+y+x58w0zv7ekrHr3o6eHAkCLSAPcnMKejUWNv2GeA7niZW9lJRleb2Z?=
 =?us-ascii?Q?tTjT20JgfycFeqpEiAzkkBpQUVWVhNn/kf48z9DjMFU2Q5ZFpRvopdhURtaY?=
 =?us-ascii?Q?QHg41rDU6q3LirNBci0Tf2ypgGs/ELtnJBrY/2MQwjOuDDViWEBd6J37ohw2?=
 =?us-ascii?Q?tpYhjkzgnspExn5BAVjiTRHfZJt5Gz3u3m/jMOE6M0SSguzCYzdV2s8oZPT6?=
 =?us-ascii?Q?vHvs0sCIwEnw7TA+eu8Se/YEH/Zn2sLGnzTZ5ayjDW4ffmrtOIquwlGoimpN?=
 =?us-ascii?Q?S28yBfh+BsbrF04qAdMfMOsRtSPq6haBKuhFslakhsg380gbLlQzTBsuChDh?=
 =?us-ascii?Q?d3cxNzxrC/K8zxLxcWHiQLRfTOtuG+Q/sQAfUW2E8oGiLT2PY6CQ8xlLEC0l?=
 =?us-ascii?Q?WCvZv1Ytau5wttHH/vaywtAhyOvkh0LVV8aVqLxKJ2dFy/jH6dLLwGTwjbiA?=
 =?us-ascii?Q?4CKhmrNpR5EFwXEIn8hfWNwp4LkH9BNtWBM3JRqYnFEdWyBYIGWvKeSfQ2Eu?=
 =?us-ascii?Q?pIeRqG9HB/GKmv8QqPrQ8dF4j+f4odmugVePO8kB1Io6qXQZQjibqWpYWcZ8?=
 =?us-ascii?Q?7cjhyR1Q+z0as2it5GCYa2en?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 53fd1780-dafa-4f66-e801-08d931ab0c84
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 16:14:57.0460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3aiDs91syV/5FGXKv2ziQsNUbXdBpfKPWOpQfQiD9tLjuZik6MNYJgdtS9kb5uC/+w3kW/V31tLLk+F6aS5foYIG9sFZwQSeEgerpizKJx0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0508
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of matching 'protocol' the rule does not work:

    tc filter add dev $DEV ingress prio 1 protocol $PROTO flower skip_sw action drop

so clear the ether proto mask only for CVLAN case.

The issue was observed by testing on Marvell Prestera Switchdev driver
with recent 'flower' offloading feature.

Fixes: 0dca2c7404a9 ("net/sched: cls_flower: Remove match on n_proto")
CC: Boris Sukholitko <boris.sukholitko@broadcom.com>
Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
RFC -> PATCH:
    Removed extra empty line.
    
 net/sched/cls_flower.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 2e704c7a105a..3e1b0012bce4 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1534,10 +1534,12 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 					mask->basic.n_proto = cpu_to_be16(0);
 				} else {
 					key->basic.n_proto = ethertype;
+					mask->basic.n_proto = cpu_to_be16(~0);
 				}
 			}
 		} else {
 			key->basic.n_proto = ethertype;
+			mask->basic.n_proto = cpu_to_be16(~0);
 		}
 	}
 
-- 
2.17.1

