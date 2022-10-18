Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68DDC602B3C
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiJRMH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbiJRMHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:07:01 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7930EDEB3
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:06:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gONk1VvCYf16AZ/v3kwZoQYjTpG5KHdNaEFp6aINGqtqUpD3vlSXFIV3ffmd7mo6zmxTjqYZsd5utM8oRpML0lncMjvVZG2318n2IFiOPjOLhOfOPqsZL4Zcv+IUnJhw9EyrrJ0ZwLNDidPH8OMla+If3trl9h0j7NK2B0NLQ5kExMYvr02RWmR2vE0XHNFaTDYCQQS4v+qstPQCl1J7pZsNt67tRgBb73MiPVeiPWLI819QuugHF+OiwGP6FAu5567pA1TtW5ehGGmVEM0gfo4dhwbgDA/XUJX87d2dnTqGnwkmvg763DtCGwL4jZ9kLCTBJi+BL3ycBxKfm+1l3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4GfMsVv6H7/hWq1qWkAPKSCxsToaIVqZEZ1kBwsImrQ=;
 b=a8zSNLStrTcy8u7bLkHchRCpM6Xz2e+RimtFpsX/WVFEL08QcMFu+Re7reUcZ3CXomMEXI3rGNh/ZBsXfQtoahI1hQTTkai6/+8lWXnL61XDr2Bas6/ncdoQjyc9XJc7z8QZ5XtVNpXbUp4CCf81LBIGcm4hZxEZi+f30EU24vfUhVwgmAR1bebimGxJ9ar1lJKG5mBwiEl+L8BIHfDdU6qoy1TaFY58N5dnab0zMceCXGtuSmu7fUfLylbbdA6bZ0LCawelvww3P51wWtkl5xuoYWp8+tP7MBQXzvk+1IXkxiUo7LVG3Kw6z+8Fv34r/CV4R5p1dLPYe+Rfja/8EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4GfMsVv6H7/hWq1qWkAPKSCxsToaIVqZEZ1kBwsImrQ=;
 b=bL8/YBbr/7pTUbKCWlHEFjpGCinHLYqUj8kP27JYSPUT9wtPN+5yB2b+elokI82uLMMu0Xf38UdsmjlG4aAiZAIxxVNkNUuwhwNgYHRmkjxNk7I7KdgbS2FmfDy7yqEDAiXqJnqnn1ml+nkaVtAp7pCspvzCpZtheOj2aPKJGSoA7g2iGk9Y761wC8dV+W3ypLut6LKC7PMzOATT+EG38Xx0qYT6x0vj1HbAq/bMMZiYp6FvgZm4qUjgvs3SoxXJWDBoQjSceOvmmX3pUp5xQTpV4MlBTXImWOVa7w70QBRsrrQzIvharyNJSbU/QHNZf6qjbcRmj/cCQUCUcpNfEg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY5PR12MB6406.namprd12.prod.outlook.com (2603:10b6:930:3d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Tue, 18 Oct
 2022 12:05:55 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 12:05:55 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 07/19] bridge: mcast: Move checks out of critical section
Date:   Tue, 18 Oct 2022 15:04:08 +0300
Message-Id: <20221018120420.561846-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018120420.561846-1-idosch@nvidia.com>
References: <20221018120420.561846-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0602CA0009.eurprd06.prod.outlook.com
 (2603:10a6:800:bc::19) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CY5PR12MB6406:EE_
X-MS-Office365-Filtering-Correlation-Id: e7113abd-debd-4723-5ba7-08dab1011bda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 86sp+Gkx6ImmY+jp72B8lvzfPufhu5HIGk59bRsZIB7+fFQ8kjmHdDpzWHKiz1kmQdWIXAoNlRYA84WjW11D3QrEU3izgCGxkLq7+alt+qLjNr3XwJoyXwlZt0t2JMnR0NVIDagPFXiO4EhhloWLm+xvTTOx+bmkY4PZXcUHyuUAxpXnDoTly34yBEBsl3nzu5/LJd8DiGAkG3lKS23GMDj5dzTXytWWndpfFuXxNVbV9tTHBMt/2nORyhMWF8iAKCQBmR8hbdcKKUbjGA4JetpFdd9XsHzOtaMDXJAsqF1nX9difBMkp57tv9chkzcS0bK7SSYhpYQElyuS2fmChT3HmbehLcHOQ1iUiDHKP3NZxEJ3DHmCyh6oU8ZwA+BMmJdua8ttgSIr3FWfYateNdNNy5/0my5Oax9mcfDGopap9KIWqUJGQo8sL78NnUGpCEAOardmA5U8tocy88FYagK0SaSPM0ruBf3uJPjugGFCF08r7I2Wo+1/Zgr9fU1stYj+CvUz+rbNd1U7kTKub1jFzeq/3v7gsZIOKms++X0O94z5GMVcEysi+rWn0rIGo67Olg/wnMB02PNhcEtt/RNj/kZHfr4VJBrjPYx2+iZ4uTfCYwMng5fRJpzxu9Zsrf/rMgwrffWfYk9dc3HA4Nc3Vd67QY7NHOjNZt772A2IK7bW8libk4sku+hGQrCRfTtTcK+HAXqJHBKcaHzf6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199015)(36756003)(86362001)(38100700002)(1076003)(186003)(5660300002)(107886003)(2616005)(6506007)(6666004)(26005)(6512007)(478600001)(83380400001)(2906002)(6486002)(316002)(66946007)(66556008)(8676002)(66476007)(41300700001)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KpC7QM6SsncjUZuIszBh0c9E22qq8rOgfsMPEWftNWhH2jONc4lhyMdTVnjV?=
 =?us-ascii?Q?bPSCPgZ9EXGDZeTBT5orFz24D5idLKp19/T7fKN3vS7SXRDSRa0uBcaLj6BK?=
 =?us-ascii?Q?0v9051zcZ4QCd+Sw+N4Nrp5D7hq9EFjwYPWplW9ZWjTzAdshlTNAHbqk34WS?=
 =?us-ascii?Q?Yn/II4PNChQic3ramrgMu2Pf0tGUQcUZhdKTnLXwk6qA4NXfQWJp1xCA+4wb?=
 =?us-ascii?Q?1LhHl1az1zxRU75XInVFxEjFDJBPTfoEs9mGkcD5zl7Kl63WfnhiEIIH5nNy?=
 =?us-ascii?Q?maaEQU90I2wWL7vLxssDizb+HN14gtM3agDMsQVplSKpqko8MT6hhu14cacS?=
 =?us-ascii?Q?OuDJwgnDOSmVi4kuiNdMthtSXfxbTLEFDq8AH4q1LMQLO4tQVzRBXRDOh0Jd?=
 =?us-ascii?Q?wVwf8tu3wJutixusbc5MM37SjBXoQFN15BZzCrMo2flRzkiNSlIVBS7z8YW7?=
 =?us-ascii?Q?I0UyqD7ry6s9CxvSZh3tEtqnlryJvTQsrpw0KPY6VCR+R8i2K5UQENdXeOEs?=
 =?us-ascii?Q?4E5/uZexWHzrHPmcec95EwX7PXAFCzp56D5E2Xb1bw4V+ekZw/eHTUd64rcY?=
 =?us-ascii?Q?ekzlo9R30X0aUuDiroQ0AbuSFKjywApQuu4Xt2D1ygzVvC1zQTHz9Na5GvFh?=
 =?us-ascii?Q?9wWIwQ1YvPjQpEiOtMIlUsb2zAsok5cQ447lvBQ3MFDCx+ayR2p6gaKA5obH?=
 =?us-ascii?Q?EJY+i13rdI8JjAZFjPAdtKW/hACByfYIcSH/P7KUudCxG4rgC6873WTO2n89?=
 =?us-ascii?Q?W098fjUK5+TmXACBR5MfJ50EfEVmZvT+0ONmGbAOeCjZOvQpQQb3AcNnQBIl?=
 =?us-ascii?Q?aZgu+EIRSoDRehseJIq0G5H5bawk490SN8AcMXP8zFzWQ/Wa/AUjI3ODWb9c?=
 =?us-ascii?Q?YCOoAudQSlhufFFREt/68gjkViU8uQD5cXC1g4NsoUhKrucJaRIJtUBf8Qi2?=
 =?us-ascii?Q?fEov1S4WGrRFIxtc+RDN59TZAE3+3AbNvmqMs06uq/EiB+02c8Hi9qFcZx88?=
 =?us-ascii?Q?a0KdS7UGIFx2BA5snLSWTlCHfLOjipmDdwCbOirXVfaRyDT/MevAftUdgpDq?=
 =?us-ascii?Q?K+oDFF7UVck2kna8Bo7Kg5VfdNSMdDM7+SMa92ASsAIr19BblB+NgEadSHSy?=
 =?us-ascii?Q?S2Lr7dsQr+h/eYAEE/ZEQNcDM3C8dSaRXdwOLeXbjxxhYS3+/Ih58pNNYoJ/?=
 =?us-ascii?Q?yVjL4EHsCzIymLXdkPph2lM/6dKC/aOfl9Ex0VmPCnkKgh23n8UWwCVVgil3?=
 =?us-ascii?Q?73HY3a+nHcEU7uqcDnjwE2wGNYtrF+fH1/fYJhHUhgjw2Pbi7rT+/ipiZYyj?=
 =?us-ascii?Q?ZZqdZ/0G+90yIETIvjuCIZxOhEFDp49+zxvIzUxQH5t65ZoVAhriCGTuH/H5?=
 =?us-ascii?Q?mlR1eNQdYVqdcAWXaAYrZ+UMaVhRR8ZGDsxkDbk18bhOd9nOwJgt4xUsprzm?=
 =?us-ascii?Q?HiQKVtwjDKGaj4PDaKSZFTghNOFj2607w7Q03gnQCTvWZDMcWDnJ2y73EloS?=
 =?us-ascii?Q?8tygE119A8s/rIemYui68nR8JI90VngJoFo0zKmSbTNylQLCmmXMVJQ6+jXx?=
 =?us-ascii?Q?oYSlun3v3nyoVqhkAs0vGfQqUKIJpcB3/5cJkOsU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7113abd-debd-4723-5ba7-08dab1011bda
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 12:05:55.0018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bck5GTaL0bl9aQbPKEkbt8/SQrtAwkqOaIkxsM75dZsY41qNE2P5JVV8cGGoCW1TFHyMAeYVKMSHTRHubDm0Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6406
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The checks only require information parsed from the RTM_NEWMDB netlink
message and do not rely on any state stored in the bridge driver.
Therefore, there is no need to perform the checks in the critical
section under the multicast lock.

Move the checks out of the critical section.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 67b6bc7272d3..aa5faccf09f8 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -805,24 +805,6 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 	if (!brmctx)
 		return -EINVAL;
 
-	/* host join errors which can happen before creating the group */
-	if (!port && !br_group_is_l2(&group)) {
-		/* don't allow any flags for host-joined IP groups */
-		if (entry->state) {
-			NL_SET_ERR_MSG_MOD(extack, "Flags are not allowed for host groups");
-			return -EINVAL;
-		}
-		if (!br_multicast_is_star_g(&group)) {
-			NL_SET_ERR_MSG_MOD(extack, "Groups with sources cannot be manually host joined");
-			return -EINVAL;
-		}
-	}
-
-	if (br_group_is_l2(&group) && entry->state != MDB_PERMANENT) {
-		NL_SET_ERR_MSG_MOD(extack, "Only permanent L2 entries allowed");
-		return -EINVAL;
-	}
-
 	mp = br_multicast_new_group(br, &group);
 	if (IS_ERR(mp))
 		return PTR_ERR(mp);
@@ -1026,6 +1008,24 @@ static int br_mdb_add(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (err)
 		return err;
 
+	/* host join errors which can happen before creating the group */
+	if (!cfg.p && !br_group_is_l2(&cfg.group)) {
+		/* don't allow any flags for host-joined IP groups */
+		if (cfg.entry->state) {
+			NL_SET_ERR_MSG_MOD(extack, "Flags are not allowed for host groups");
+			return -EINVAL;
+		}
+		if (!br_multicast_is_star_g(&cfg.group)) {
+			NL_SET_ERR_MSG_MOD(extack, "Groups with sources cannot be manually host joined");
+			return -EINVAL;
+		}
+	}
+
+	if (br_group_is_l2(&cfg.group) && cfg.entry->state != MDB_PERMANENT) {
+		NL_SET_ERR_MSG_MOD(extack, "Only permanent L2 entries allowed");
+		return -EINVAL;
+	}
+
 	if (cfg.p) {
 		if (cfg.p->state == BR_STATE_DISABLED && cfg.entry->state != MDB_PERMANENT) {
 			NL_SET_ERR_MSG_MOD(extack, "Port is in disabled state and entry is not permanent");
-- 
2.37.3

