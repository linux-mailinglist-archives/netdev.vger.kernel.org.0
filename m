Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 293CE6441BF
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 12:00:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbiLFLAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 06:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234547AbiLFK7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 05:59:53 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E31A22B2D
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 02:59:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DqW3vd374m+2k3r3OMwwdPtaQDu6duMxfmcRDrkIXZ3pP5xpWccEGHU7wKaB1Ya2qbdTXVaRom9BSQeBGYNSnIqDDHVYxwYSP6KgskgRP/j28uo2GkOFfIDrzOENCOINeO5lRwx2/8v9NOrtbN7MIJcT4BwikwZOpNlqr0y+IV1NFSLYCs8YS0vK1vyZetMDcY+JWpWJQDYEM/4FlBFOtys83qsRvxrMFvHVdXD5MD09L4FehP4GS/u3jV1LEdD4+tnoLiu2/y5AwUX/W/40yiNJLpJHK9rcayFU4/BdHJnXrbCdWm2IyE+dLpO+0NPHOZkyJlURL/sBYOuCcKyhvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EdvVN5xzfy+1ZPDNmvOwrIBR5OfKCZgYHP84JMw8sEo=;
 b=Stbz0kjKPRuVi18dEhADHAoOoHZz/0EddrgSE6Cphu+8SfFQo46h6dCqfHyAOfJiz5I16V9BVwUPzNsxEaEnGhX46Hs335HE8rOlMY8dfF5PczLX+Q8XbDOmIZ6H7miwp+noI69aRYa+hHKziJqvLxb9HBWdEyNZK7eqpdOecfrEEvmUedyJ3SRxgRW/HJ11VdEihpiQzkrGK65XXQRUAYDq5n8u6yewI3G70JUyZHkqj6T6lsVj0vqkN9CtBgdVq6aHb5gZGToO1qqqbeGZH4E+ocmD8Zi54DABFL/IwWt9cs8B0cLqXAef/cJgykHIpstEaxjMtbDcaYWgHiwSww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EdvVN5xzfy+1ZPDNmvOwrIBR5OfKCZgYHP84JMw8sEo=;
 b=fQNjHsRNrDkB4h5eyglESFSMBriw7V/dW40j/j2ezb1PKMgr1Z4P/wAWRbgXSGOSmwdyY0jqgwCVUe0+YCEQ9LE+bn80D5LpZKXT43azhg2gla+v2cVkk8pWFcxOeO4pD4w9rABE2ED6I3Ch/wbW2LLrukHo013tT++dAeDVZZ/TYmGmyLYnFyvpVLDrxbM5NqMSfIrR3DldUKMrUCBjqaWiiEm8Q5mURv1pZjCuU1gM97d3M9Uht2NQwdHAJC2SIfZrvEOlaXNvxlOtO9ZnJTsbPRJ43LBWHuChRrFrJaKF1GuDpYEiLEOEv1p426zTIakAXp5PcGDiQp2M57cglg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN9PR12MB5131.namprd12.prod.outlook.com (2603:10b6:408:118::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 10:59:24 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 10:59:24 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 7/9] bridge: mcast: Move checks out of critical section
Date:   Tue,  6 Dec 2022 12:58:07 +0200
Message-Id: <20221206105809.363767-8-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221206105809.363767-1-idosch@nvidia.com>
References: <20221206105809.363767-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0401CA0001.eurprd04.prod.outlook.com
 (2603:10a6:800:4a::11) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BN9PR12MB5131:EE_
X-MS-Office365-Filtering-Correlation-Id: ff843b07-8dcb-4460-cd71-08dad778ef9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oTgt5cL6XvZznWT1piI3oHZn69F/MSPLvVcytvBMwepnE0OHRl3OXaTmZtcX0PJdMOzU6fe3U7fcIVcA8qzQVgB5O6tipcHpc6mEX3ckKedK6wWVnJLLq9ErZBxf4VkgFhXxWbpFMG9Ck3H60RxHAItJmPt4shkxyXRZ8iAUq/nduCiwlXzqFC4Z8QoMUBUHv4unu3bw1tDUJBsm7lc6LkkzB/v5LXoxLR9Gch/GuIoo5m9kYqoBaxCvwKWS/3N9RdUMfxZ+6PExnwDGxdZ/CnngR5lHs9dJWs5aPa1pppG5Y17TWDZsynzlbVAr9cagoQ2taKmzZcRg08doU6Kv4qq+uNMOGUqVzkCiK/CI0XCX4QjUcSJTVFkW/JdEb11fZxwzpcXfZrxF5QYCzXZ1ak57EOES2uFGxDvhKY4rTmfrw2s3gQDypJgsvSxTLyuAcZrM4eXwYMP3pFiUJ4Ocn5JNVv1m83dYBbKmVuNP7+5wtxG0McRyNVTgWLNEqvvcJ8P9dSz3T58bd73n4Jn7PzidGZIgHBkLXtQjnYnLa3iTFiRAF4wOIQdJd7HhO3dU9yZb7aOuKlGsmq5vh7Wmz9XFLR/52xv47vNHeGw829v5diQ3dwtDqqvPxmhDe/k+2fWPtcc6j2PIymcYnSfAlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199015)(36756003)(86362001)(38100700002)(6486002)(478600001)(6506007)(6512007)(26005)(186003)(107886003)(8676002)(6666004)(5660300002)(4326008)(2906002)(316002)(66556008)(41300700001)(8936002)(66476007)(66946007)(1076003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pWBxizjTb2cUpFQQjJHWiFd6hRi9PF67pVKm+eZUpupngXJ5M3ZdKYRFXau2?=
 =?us-ascii?Q?JXajXUAjM6ANzcpXUJPuJI+MJPQIOaxIJ1/UVdOLN3TWRx6ZtSz05dzjfdbx?=
 =?us-ascii?Q?rUEU9C4IqaIakY/451ck5Bg2utMb37RTexwZ9anDo03R7KXLORkUqjMf2gb8?=
 =?us-ascii?Q?uu1ydkB2lw7C3RhEmRdq6ru4N0/4jM0de4jGJ9E1ZFSlwhVCo8wmi6RakxZl?=
 =?us-ascii?Q?khiMd6GNFsrpVVKtj35OcpVQjr8cW/fIFtShgxZte8AGeD3lQZD+d+FSSXzy?=
 =?us-ascii?Q?DmVT/5f82B+JSg+M9A3GqOLD93Q8Ft18QGVOCYL+cTsHId0Kyk7uk6qpeHvB?=
 =?us-ascii?Q?Ute1eNQeYi2ckoHtyV0XEQoh2jhd9wHdVaFPpV3e4Di2/yKorLD1hcQ16EMb?=
 =?us-ascii?Q?ri7RvYY7M7LHOHd9lZ37NWS28bGNl2HOKUo02jSjUJUamRWtMj46wqYAuFyh?=
 =?us-ascii?Q?GGd7OMEnSV6ldZjTLoYylx/biu+wiuuyxHwb1DMHBaumC2gyz7GLKdKNgNYs?=
 =?us-ascii?Q?Magu1LKOA3Krr7tuCOW/9cfdsI/uW6pKYLY2uN8GbyNOM4h833Yq0m2fd5D3?=
 =?us-ascii?Q?qPpB+jBesmMz+qmt0oen361h3Eb2AtL2O3zSr/BbgqSxjVgc85IY8itn9ncP?=
 =?us-ascii?Q?B8nZzy0r4hm2JkPnj2YqH3L16+3WN1zxHtUtsxB4mLdyUGUDet7Hij7TNlvA?=
 =?us-ascii?Q?fbcq/X/8sFvPI0rgKcQnUewvbmDRTNAxgFIRvGvINwnn5XPgLiVlfoiHiIKv?=
 =?us-ascii?Q?xVQ1u+VpJn/Xt50//ztk8OuYldiMOE+irZJp9XRcII5/uLsjDzJDgNICLR5d?=
 =?us-ascii?Q?I4Vf1mDtfMm1tipSNNOocTVAbBO9i9ddOfN0AqOtFfE3O9Prt9XyqG6VugI7?=
 =?us-ascii?Q?MkrD5ncZj1seCTwcp+zNyl6SoS/7rsXTzyw0c6QS78+qftS4mtszyjBrb5ti?=
 =?us-ascii?Q?bxuB6/gHRQBQ256yTtFdD4NeoenSI/RlvzxLEfmJnppPWHlIbkcQmpfZ/EeV?=
 =?us-ascii?Q?2A1G25eT/xGWs/IN5FFVzXr9EWSeAFnVRcNbhNc2sxTfGnxJUTzTslqOvCzV?=
 =?us-ascii?Q?Xuvi5g3Ixqkl/AnJ8NFjxOnCse4uIYnmI4CrDC49ynUxhKoncDMpJ8XH4njF?=
 =?us-ascii?Q?hm26u8zqwFATGAotZYxI8+GlulBM8CvmwW1W246iJXDEC5W7dcBO/vvZG/tf?=
 =?us-ascii?Q?+IoeJ4Xx3+ry7WjeuH9efvu5Fjba9lLKTIfCKm5LbBvD06VJBoSsj+oX9koY?=
 =?us-ascii?Q?HjRWIdc1ChtHFIq7es8Dq+F/QRj+xl7airrIyZdKShou51RCWHQNFvhorVcQ?=
 =?us-ascii?Q?QEBJO+Qfc5GMEk1IIh7rMTH4gEuAps8pAOUNr6voG9tqvs0FwUAAwJFwM3HH?=
 =?us-ascii?Q?XpgzOXk2L1OBSoS2OcPlXCbuT0D54vcr60KcxMh9hWU54WJLYYKG92dwXn1x?=
 =?us-ascii?Q?RFzJL2WzNOw6pBmX0m3wFS31CP84nHtffPDBR1X8EYt1VmT0eKhjWFsa6VZF?=
 =?us-ascii?Q?x4wnbHzZfa/LrcW0YS+Q9PdZS7PyxMoBD/AngX7EeSi42eQUGgccIVse4fNe?=
 =?us-ascii?Q?MObTpTxaYcoBRbWGpwxgR5mqv+f+dxJSUK+RSsSc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff843b07-8dcb-4460-cd71-08dad778ef9a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 10:59:24.3230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o7f+Ay41etmmNINIPp9WnTph94tvrao1N0tleqli+v/1/iqjkEakFid0uZ5N0SObpeFCXnmFJBy3v8de/MnZ9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5131
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 net/bridge/br_mdb.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index d0e018628f5d..d954d8f7cb0a 100644
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

