Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 075B361E1E9
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 12:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiKFLk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 06:40:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiKFLky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 06:40:54 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2046.outbound.protection.outlook.com [40.107.237.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF692E035
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 03:40:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lspBDW+QJrfQtUvqQ5sL3TwxolGwCkIxk5FuTDvIW0Z4Ikp40XOQehgSkg3KBZWes7Q6PwNS8hOdSdmHxv/ThMCqfxpVMYZCt15FsiaKOFyZQrwcBrLZ3rcLE12mywB00/dE/sHhLPoDNKnuKvUrnzSVXNS/u5quEwZ48CN2aM7Lg1KShvE6HlA+ZFTDHDF4L1lsURmupWPOPHtzq56iJ16gqJu658TQiS4WVcO4YkvYSDJKG/tJ8ElK3l2CesNECnJtQ04Mwo5cn7Odma8HG/9UvpuwEsvv5PEuc/XPkzngUJCAGSyMrIT8puKwZ1ysxvXCeEBGoGAupR00lS1YWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K970Om6LpAMc2T0K5opJ87H1tbXv1FPM9OaUyHyCGnE=;
 b=jf/UXhMx1FIRHgECUjW5stHNh+idVf8MZRwXdoRMjM2F+avc5hLb6Y3JLYCWm9c5eagM9ok4btX+MSGi2yKKPMsY0rDV7ASm1N/lCgO/GdPrZPEjUlGPX2DnQay9/I3NTevzuf1iT9BWxdXPFg5EdLPMAdZ83l5QzwMBsyTOcF+ni+P9BdyCt6V4j8jOjSQleHwh4858YJdSnTkCo6KtPpPc6MFFa6tOLTDo5TKUr1Y//dpP/YbiJfCN9HPRJNYk70TmzAPlSnep7nNYvIEFmmjlbcrbt5vb8EMDuymjBjL9rOD1OIdPPnmScwKH5LnXR9tyDS5BOhlCZD9QiUbxMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K970Om6LpAMc2T0K5opJ87H1tbXv1FPM9OaUyHyCGnE=;
 b=mq1nIno44Agd9gizqNdbVC9+7CzOuoom99G7WqaiZzoylRaU4bo9GfTc2Bu/I92h2Gz4f9QJFqXj1x2EROogxRYsZ8WMujA8iqQbBM5ZymobbuuBmtD5nTReYx9eQYtX+irvn8WRfGamcAbK/ZZdKboZM/QCCAM8HoyKEauL4Cca6KT3fDZPzbrkicvIDluZBYsZ6PjpbMtW2zyxoHeFUKKJthQjBLDBgHDM+B5P6TD4rgrChlpuSPjSCqZ9mIvrvyqQE73wPjFkhmx4d4+77437RXIJ+431NW2F1ntSgh/sVXnlrDtH8cN6nu4iLcpexNaTH0FE0QOMmU2/lVfQAw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB5867.namprd12.prod.outlook.com (2603:10b6:8:66::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Sun, 6 Nov
 2022 11:40:51 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e%4]) with mapi id 15.20.5791.025; Sun, 6 Nov 2022
 11:40:51 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 4/4] man: bridge: Reword description of "locked" bridge port option
Date:   Sun,  6 Nov 2022 13:39:57 +0200
Message-Id: <20221106113957.2725173-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221106113957.2725173-1-idosch@nvidia.com>
References: <20221106113957.2725173-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0029.eurprd03.prod.outlook.com
 (2603:10a6:803:118::18) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM4PR12MB5867:EE_
X-MS-Office365-Filtering-Correlation-Id: fa8673fe-a65d-4bfe-4ff3-08dabfebc179
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m3gf5gy1Xppl5u4que7NNiX3w+zxMaUhUAaH2fblJJysnOi/fj82iKkj4qS3kd8R5ASvt8PNfRovDS2QI8bI3q1UaSxgOjq3vdoIiZ+ZkiatUBM+7DKjZNi6EtJegwkDYY0R2vgDIxgVV5lZMKuoZ6j2Fwz28FQji52bp/wmJZ7sCLtvYJbQorvqBuStqc+x/DEaKwMz1LxX7PqVIZ2ssVbIDewAa3VSKXi1nK/4Sy51BmOPuMWt8vGqfKJ5sh3R8UC/UlfN751PRFufgNmK59Hyia2DW7nR2OIKQDNkdljC7eJIZM3P0bLhPLdbEcFj8GiOg1k7IKb6ylOt2WbewzNYdqdQB6ZZh2/2KhD2ZNz0CYB/jMnYiitQ4tcd6Act5u3pGX+EltsO6JxVUPHEecT4O1pb9SmVqBAqe0loVflZoiQ2j8FwiCOUYfPxq9H0aL3m72wez91ZW81KDp/9D1Ah949phXjfqg5AdENOGkj/h0SHumYdiCRIkWS8ruZ0oYSQjPe2k4anl7LoKp7RrQniJiMP390NAF5oFkk9Qlzp2J99QynaecCd8lwYxGfeoJaUdMcbYAUCb78CDLA4qY8HEuaGbPeic9P5+PKfDlS3i1k/sycOtSoqWCeEJhwACLXqo3Mw9OpIMVK4t8f1V3RN4qMkNEziUqAtbu9dD3yIaQ0NR3oBf1Z3PBidiqil40FvR2la/KaSqskmfMShOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199015)(26005)(41300700001)(6512007)(6916009)(2616005)(38100700002)(107886003)(36756003)(6506007)(4326008)(8676002)(86362001)(66476007)(2906002)(66946007)(66556008)(83380400001)(316002)(186003)(1076003)(6486002)(8936002)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gki/uPf75EkIo8XjA69PJznMPuYvfBCyPlvhusE7f4t9HekDDUh+71OXa8xk?=
 =?us-ascii?Q?VqjeDuik8vIGZccC0hc6nqacdYO66KkSqcEWCHsbXwgebVkYLmc5Ud1KWijM?=
 =?us-ascii?Q?77xhze2ybJU8jUkfbZiQi81paN4XUAAZOv7ONDxnnDgPrtCeRwxHSt4hBZMS?=
 =?us-ascii?Q?s/Rr4JEOhWTih/3NEjE19ULg8eC1lUAgfM0IZFrswdzCvVYfs1mrWls+MdWY?=
 =?us-ascii?Q?cvoRw4MTX5eDqfhCib3ur49w4G2oGiIQ3Nq/luMhl4bU5V/oP+BGICW5UrNz?=
 =?us-ascii?Q?Rtd9UzQu7AVdD7yxk/5sSaaCHBh0Z3/T2USk40XrpL8rNV5gx86debMxMUoc?=
 =?us-ascii?Q?0XEDL8ewPDijkBBscud4QfvuOgIAo1o+3LgkKvAMTMj1BcHlrPSLYH/e1o9k?=
 =?us-ascii?Q?os8VChb9VXSjrVWIc/XcSy90Kiz54iLpNcWGsGg1CCe2+bx3jmnEsyKqTWeZ?=
 =?us-ascii?Q?JK6ikbsZ0BevtIv6mu8sScQnK0/0RPVcsLanPdlWTqNPWG9Y4XxtnjOTRaXg?=
 =?us-ascii?Q?e679WtigAvc5p8DXVKYxG7Va2aiLNT/ffB4AQnfFh6w8fOr6zytW2jQcjrSb?=
 =?us-ascii?Q?em7Wk9oYC/H9SjkBwzCUZIxBO0tRDkWKjdlcffYIYQ36WLGCijOxGvprWN7P?=
 =?us-ascii?Q?IGdJZEhB+TjSh2TDyWMZzBlyXKqMIQFX6UOH/ERX+vWeMyEorRrxnvhE/uKW?=
 =?us-ascii?Q?K7+MzoOXjCzasIVq0ttIRawvVWhVhlsvFO5o/KpPBPnukL4YBBzIjVahAw3O?=
 =?us-ascii?Q?3pNOyaTHflk2R9w+pbzsq0JiHt8GngH+49LmxXVHDPuAchBdWfhYVXaxSvBg?=
 =?us-ascii?Q?oqnXhGAPv7VTSqFKfoWJsF6VOcWybwxGUh3ubNIu1wSRkS60eIJr10P7WP2o?=
 =?us-ascii?Q?aZEZGY+NbUwgCqLMtrv2JZ/2NtkQJnlObglv8Kmpfk7TO4gchtN1BcbP6WNa?=
 =?us-ascii?Q?5Ojr+uBDlpHjhwf5gWlHcZzLHI49NyE9rZFlLlzvQk3u7nwIsEA/A/RjOVvv?=
 =?us-ascii?Q?zj4rLjAn9UVLdgGQ1AfMQFKF5FtbhiXlYJrRU0859bMjxQkCGDBRl/yKzgdS?=
 =?us-ascii?Q?WFvTfwEe49znm2hYetunylrx6rWzsVwQzgRscknZlCR6t1pk9L2eDF8J3NQ3?=
 =?us-ascii?Q?ao5202PyZxc4U8Y/rkkG5jl8R0ndGnb4+DfpzUwvDxVxQ5K3pCIz793QvHhV?=
 =?us-ascii?Q?FCQ/sLPKQDw6MRd60mPxl9ExfigL5T5ZJbh3hw21qnkm1b+5ATrr/XLHl5MT?=
 =?us-ascii?Q?BQz7qdJWOzkzI9DtUHGn5B8IfbHkIRlQqHMgnxWORxG97HeODbKuTfo26n4O?=
 =?us-ascii?Q?1SHSac3QXvLxaqgxnn3JHC7xf0wWtGBKYXasyOmFLL9lZDNl+D7cFqPZeHv+?=
 =?us-ascii?Q?AdtdjK2oGDSoiEOPzT72HpgkWOLnt05KFuAROiZtsshKrLwY3Pd4A+vHhFR1?=
 =?us-ascii?Q?lkUICVG95MR0sw1NCJuT7e1cR6WNlDQ5xhB0feQTMB4To99CNgfi9MCHv14W?=
 =?us-ascii?Q?ApTOTcWTGK/Tqh/PsSsxd0ov8D511kPro85gRcMNpANn/4Yr1dBH16YpURx9?=
 =?us-ascii?Q?Tcli/YP9f1TTBdxz0jg1obGf/FyS+8oV21zMlH8r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa8673fe-a65d-4bfe-4ff3-08dabfebc179
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 11:40:51.1769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fQ66D1QnGR6fjjuu7QxpK48lPI9g4AbI72nbsekiw7duOj6xF4S4QnSv2vL6KuaFIttFJ1GtJs6OlhNDU5GqSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5867
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adjust the description to mention the "no_linklocal_learn" bridge option
and make sure it is consistent between both the bridge(8) and ip-link(8)
man pages.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 man/man8/bridge.8     | 16 ++++++++++------
 man/man8/ip-link.8.in | 13 ++++++++++---
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index 1888f707b6d2..e72826d750ca 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -574,12 +574,16 @@ flag is off.
 
 .TP
 .BR "locked on " or " locked off "
-Controls whether a port will be locked, meaning that hosts behind the
-port will not be able to communicate through the port unless an FDB
-entry with the units MAC address is in the FDB.
-The common use is that hosts are allowed access through authentication
-with the IEEE 802.1X protocol or based on whitelists or like setups.
-By default this flag is off.
+Controls whether a port is locked or not. When locked, non-link-local frames
+received through the port are dropped unless an FDB entry with the MAC source
+address points to the port. The common use case is IEEE 802.1X where hosts can
+authenticate themselves by exchanging EAPOL frames with an authenticator. After
+authentication is complete, the user space control plane can install a matching
+FDB entry to allow traffic from the host to be forwarded by the bridge. When
+learning is enabled on a locked port, the
+.B no_linklocal_learn
+bridge option needs to be on to prevent the bridge from learning from received
+EAPOL frames. By default this flag is off.
 
 .TP
 .BR "mab on " or " mab off "
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 314c07d0fb1f..235c839a417c 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -2576,9 +2576,16 @@ is enabled on the port. By default this flag is off.
 default this flag is off.
 
 .BR locked " { " on " | " off " }"
-- sets or unsets a port in locked mode, so that when enabled, hosts
-behind the port cannot communicate through the port unless a FDB entry
-representing the host is in the FDB. By default this flag is off.
+- controls whether a port is locked or not. When locked, non-link-local frames
+received through the port are dropped unless an FDB entry with the MAC source
+address points to the port. The common use case is IEEE 802.1X where hosts can
+authenticate themselves by exchanging EAPOL frames with an authenticator. After
+authentication is complete, the user space control plane can install a matching
+FDB entry to allow traffic from the host to be forwarded by the bridge. When
+learning is enabled on a locked port, the
+.B no_linklocal_learn
+bridge option needs to be on to prevent the bridge from learning from received
+EAPOL frames. By default this flag is off.
 
 .BR mab " { " on " | " off " }"
 - controls whether MAC Authentication Bypass (MAB) is enabled on the port or
-- 
2.37.3

