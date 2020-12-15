Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB81F2DA8B6
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 08:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgLOHnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 02:43:06 -0500
Received: from mail-eopbgr40069.outbound.protection.outlook.com ([40.107.4.69]:40665
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726581AbgLOHmw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 02:42:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LOu4QnGTTLgPyxMXdtSl85a6u7pvUFNvJ2BVjcuy5gyhZGV0uXj9yQmkeJnSm7cvBotXMTA1wuGwWb/gA/BnWfiwLbMU12Cc0P00Zmy4Pi506o4h5oACuGfMvaBzCsXJq3P+OAYCgzc7p7Pei9R2e40+jizj0LXH/tVnnHN9g4MCcCHSLZuPz994vFKHDFjv3DpXAIhsOvu+VM5T+2f66Sgc6QtudcPAphLQhWtZ53vSh5YhRN81Sdv3y6gkC5nbAF3bFzuTygq25bHb9NMRjdryHM3k/WsBMPdVP4UYPzmlnC9eW+zXl/Cer+w11H1i1zBtc9yOnzv3jpA1xuyxPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=173gKLr3zf454Yz2EC1UvG/PxFJEQCtCIMO9EO6Murs=;
 b=HPGwHIGA5PU6NHbmYa7vnzLTfHuV3fmQnxORodCi56xdOk+WLwNLwLzJ9byQih7JXfOxoDFTHgh5VqQixwBlE2rmFBwjMng8QJg4VI4DzfBv1qHo+4bLOksSYsmVzuIEtQ5telIx8mQJsB0U8+M6Iyuzc+5IpphFnWeh/HHpg/Px4loX/2UafZQFrB5pW48C3qntgGHGa1dzFETTYkSfiODT7IqmMrvn9SXPGi2Cm2zUb/OZH2NcToPclFW4eAw4eDJ3Y/7DqbQGySDdoqUoSnx2Pfk4YpFasDS8gYJN/ulIRKXHssct+Xvh+Tmv3rlIsaDLRVgB9Fnu6KuNCpDkxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=173gKLr3zf454Yz2EC1UvG/PxFJEQCtCIMO9EO6Murs=;
 b=irqgzxvWoFNQW/IyNts742K66t/70t0y6kBvm3RldeP+KYAbjTKIxjZ5bjSgwBrsV3FB4QCI3CRgaCWQlnuO1W09pfM2MPEOE2OpXqalPYwC+a6Jm8KC+VX4/qoNpm0zpWIfLjjd7+zJ/9J6wmNxhIjQ3WG3fUkW/4LhmnLMPIc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5982.eurprd05.prod.outlook.com (2603:10a6:803:e4::28)
 by VI1PR0501MB2335.eurprd05.prod.outlook.com (2603:10a6:800:2e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Tue, 15 Dec
 2020 07:42:01 +0000
Received: from VI1PR05MB5982.eurprd05.prod.outlook.com
 ([fe80::ddc9:9ef:5ece:9fd2]) by VI1PR05MB5982.eurprd05.prod.outlook.com
 ([fe80::ddc9:9ef:5ece:9fd2%5]) with mapi id 15.20.3654.015; Tue, 15 Dec 2020
 07:42:01 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, David Ahern <dsahern@gmail.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH iproute2-next] tc/htb: Hierarchical QoS hardware offload
Date:   Tue, 15 Dec 2020 09:42:08 +0200
Message-Id: <20201215074213.32652-1-maximmi@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [94.188.199.18]
X-ClientProxiedBy: AM4PR05CA0025.eurprd05.prod.outlook.com (2603:10a6:205::38)
 To VI1PR05MB5982.eurprd05.prod.outlook.com (2603:10a6:803:e4::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by AM4PR05CA0025.eurprd05.prod.outlook.com (2603:10a6:205::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Tue, 15 Dec 2020 07:41:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bb57a224-3193-45a2-67a4-08d8a0cce8e0
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2335:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0501MB233593471FA8A76659D84597D1C60@VI1PR0501MB2335.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MD55oXGLSEf+FaAt1ZoTu7kyYZXqBvCO/zfA8aZRnN7TP4lCe9+SsArLyVD7Jkog3U3tTFyEnLj3+HjYL4l8g52FOdp7FNIDjNd4xdNfto4A6zdLgWnzzysrLDk3Xdsf+Gd7AVexUJBGVSljFC7DAh9ZJhjQuAMzR19bvXLIU/XZDE+7znlq8wCtpGvGsP3jpsw4np3apm4hxJDaXNJySU6sMzz0u7fCCffs2BEoiCAM5JCm+Jwv6EFEe6bba8+eAxupFIMYVSqmQCXSGO7WpiI7q0kfQoY3FhANaOJzMJE8wKD5g4sMlSREGqnQRizrpM9fOhU27pTfmD06DsruiY7huyNcr19zHP7T/FTN6GbbEzWey80T5ycN8exDHVT/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5982.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(346002)(366004)(136003)(8676002)(52116002)(186003)(6486002)(16526019)(2906002)(66476007)(7416002)(66946007)(110136005)(6506007)(316002)(36756003)(5660300002)(66556008)(8936002)(6666004)(54906003)(83380400001)(26005)(107886003)(1076003)(2616005)(86362001)(478600001)(6512007)(4326008)(956004)(309714004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pCo6nubTWwfmV7SJbPqb4l4yvnJ8chdNPtyi95KNuIQsVUZZ448/764WZH4M?=
 =?us-ascii?Q?lSvbc9rMLSEu44xabdKnayxOngjdhqjjLHKiKPUnqzirqxMo2lAjmmzn2BVP?=
 =?us-ascii?Q?NPzNk7bUy5fvvMx3VH4nW0yQq7BqHTV1NGLU6kE5+g3f7s3jz1WdWS5BuVgk?=
 =?us-ascii?Q?8YqdFh5uEQ5IRVvCvQPDcj3ln8iKcsK5QO52ajmtwmh+mzBEN0Z0T/YByymZ?=
 =?us-ascii?Q?P2yzVo4ciQsaxXv+xVwDZY6csjL+dYVFx91/p3T4HqLJzzsV1BStS/mESp2s?=
 =?us-ascii?Q?xP7OIidlqvIvoq/CjBGlKRYoPHyFaZLlZaThekgGKVnT8ULI+XQ2uyVCSEid?=
 =?us-ascii?Q?1NLSG4rOatXceXOUNP0XDx2cke3Srurl0O4x5IfFQJBa5uHLHacEHY7EzXiy?=
 =?us-ascii?Q?g6QzYmJBAZeqjQNkt9ISXYN7b8HrjJ4KUCZcOCOyYrm7x3bHjz6Eb6n1dexp?=
 =?us-ascii?Q?nXuH9J4oIBjiWjtVVX/MfN5BwfKHzsi/x8QBV/f93+7bkmU0oLYD4nszDYsK?=
 =?us-ascii?Q?rjHHH5t2bdKM8b8hqldA9Lqk9BHgeZY1SkvEaK7jANs6LPLRc/lu3eDnig2I?=
 =?us-ascii?Q?L3BG7Xx70TJusySbYhab8wyuf/7ze3WyZL/bghyDKqjHdydhcBuEvQ7cKhfP?=
 =?us-ascii?Q?q6tk2qfxZMn3H4/1cYLKhSVtS4lvtwkIq8US1xja9BiZG2XRaDyAOcnv49pp?=
 =?us-ascii?Q?sd4rne8105NgNl15Usxfoq71Z0IH1S0Qnp2M7ZJl8W1WptnYjF6zSraaWNgf?=
 =?us-ascii?Q?LFr1XYBczmj0hjBaxLg62xLLOQYAAbRN8tKkDR0rsxPu2ljgslAfre8/GIZP?=
 =?us-ascii?Q?gbJBgpQXzt7YOhdHAtAoZjLxe28T7c4f+wG3DaAQVeckic6s0cUYdbaLrFqD?=
 =?us-ascii?Q?s16GX6n11Fstf9mhqi6cCtI0UR6/GpO9PoRnMffZYljZWWxXMif4B5h1KdNO?=
 =?us-ascii?Q?JfUgmq7vQZIwJrB14DL9QiEjAoJJ8PkApPlp+QY8cchr67GUCFjVHF7Yks9y?=
 =?us-ascii?Q?wbRL?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5982.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2020 07:42:01.2928
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: bb57a224-3193-45a2-67a4-08d8a0cce8e0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v5tn9Mgh3zhMMpOymh9HOwhFQeHY9XboeQmHBm1hhnL+WFLkKZrtCE4JmemX/JqFTgSKKRzdXGmWtdcBT1arYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2335
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds support for configuring HTB in offload mode. HTB
offload eliminates the single qdisc lock in the datapath and offloads
the algorithm to the NIC. The new 'offload' parameter is added to
enable this mode:

    # tc qdisc replace dev eth0 root handle 1: htb offload

Classes are created as usual, but filters should be moved to clsact for
lock-free classification (filters attached to HTB itself are not
supported in the offload mode):

    # tc filter add dev eth0 egress protocol ip flower dst_port 80
    action skbedit priority 1:10

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
---
 include/uapi/linux/pkt_sched.h | 1 +
 tc/q_htb.c                     | 9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 9e7c2c60..79a699f1 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -434,6 +434,7 @@ enum {
 	TCA_HTB_RATE64,
 	TCA_HTB_CEIL64,
 	TCA_HTB_PAD,
+	TCA_HTB_OFFLOAD,
 	__TCA_HTB_MAX,
 };
 
diff --git a/tc/q_htb.c b/tc/q_htb.c
index c609e974..fd11dad6 100644
--- a/tc/q_htb.c
+++ b/tc/q_htb.c
@@ -30,11 +30,12 @@
 static void explain(void)
 {
 	fprintf(stderr, "Usage: ... qdisc add ... htb [default N] [r2q N]\n"
-		"                      [direct_qlen P]\n"
+		"                      [direct_qlen P] [offload]\n"
 		" default  minor id of class to which unclassified packets are sent {0}\n"
 		" r2q      DRR quantums are computed as rate in Bps/r2q {10}\n"
 		" debug    string of 16 numbers each 0-3 {0}\n\n"
 		" direct_qlen  Limit of the direct queue {in packets}\n"
+		" offload  hardware offload\n"
 		"... class add ... htb rate R1 [burst B1] [mpu B] [overhead O]\n"
 		"                      [prio P] [slot S] [pslot PS]\n"
 		"                      [ceil R2] [cburst B2] [mtu MTU] [quantum Q]\n"
@@ -68,6 +69,7 @@ static int htb_parse_opt(struct qdisc_util *qu, int argc,
 	};
 	struct rtattr *tail;
 	unsigned int i; char *p;
+	bool offload = false;
 
 	while (argc > 0) {
 		if (matches(*argv, "r2q") == 0) {
@@ -91,6 +93,8 @@ static int htb_parse_opt(struct qdisc_util *qu, int argc,
 			if (get_u32(&direct_qlen, *argv, 10)) {
 				explain1("direct_qlen"); return -1;
 			}
+		} else if (matches(*argv, "offload") == 0) {
+			offload = true;
 		} else {
 			fprintf(stderr, "What is \"%s\"?\n", *argv);
 			explain();
@@ -103,6 +107,8 @@ static int htb_parse_opt(struct qdisc_util *qu, int argc,
 	if (direct_qlen != ~0U)
 		addattr_l(n, 2024, TCA_HTB_DIRECT_QLEN,
 			  &direct_qlen, sizeof(direct_qlen));
+	if (offload)
+		addattr(n, 2024, TCA_HTB_OFFLOAD);
 	addattr_nest_end(n, tail);
 	return 0;
 }
@@ -344,6 +350,7 @@ static int htb_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 		print_uint(PRINT_ANY, "direct_qlen", " direct_qlen %u",
 			   direct_qlen);
 	}
+	print_uint(PRINT_ANY, "offload", " offload %d", !!tb[TCA_HTB_OFFLOAD]);
 	return 0;
 }
 
-- 
2.20.1

