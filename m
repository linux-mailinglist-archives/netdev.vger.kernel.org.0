Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55A6C6471E4
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 15:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiLHOiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 09:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiLHOit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 09:38:49 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EED827B17
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 06:38:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yd0YSLw1rCzSc3j1nlWLrYBymy18QDiY6LYxgvNBN6sWFX5K4SqMov9RlY2QvvvC2Keralz9HrZWLdHFGNvaqK9tALFnzfMN5tmDODXChhq4AgaM0a5TCHk/NsSZxrD+xqkrBXxwBGbKUcoFzzgB1GVJNjmUNszxniS3Kn7WTcFOLSwH62Ih5/f4F2ooNthJLRQstidBZWKjoNVtij3rDiLY6CwQaldibLJHvrt4lqKUB+7k67rhzRsOLDFSQgVIsUgSPqdgrM1xrRFotAv/2CyGrxN9FWU/rvACVgaDcfjxjDHNndtuzYTaJOEeiLqJ4VpR1wN8VJfq/xEYxRYusQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+dvxQeRdcbgvXX0VdNWYQO/9Lwj2sQORP9KCUhhf2dI=;
 b=aHCd0tqiiJNJSA/4/VwOID+vU+zsPQo/rPlVrG675cco8JwAjCALfWzBpiuAhrlMCQcaJrtG6y6fg1ChkCN1JM6V54EBbXpAe4oh0FpUxvOIewOxdJDaVfSXOLhjC1lV8W5MMA8n9E7oVUafetqG3UEt20wmtRi3Wh0014kDXCgUytQmuYTfzgEi3qlZByILRxULzW8xBIaNIAVZJohYMqWw2jugNahNUSXLVEJHqP/GZtreuZZo9ETFnXDpJ3iSjYCPq3opB9v0Ib8M7ubH1fzYGy6wRncY/wpDZ36eX56x0IJneXMLVcniQR1InWxMhJmO2gVmEpDrrqTldvItLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+dvxQeRdcbgvXX0VdNWYQO/9Lwj2sQORP9KCUhhf2dI=;
 b=if1Ib5j5+jsP5SG7ySUfeWiNFXnfYIGgd8IDvQ1lTS6AeAHPW7fYlpIwh5AzzGXpupf0JJ5w7qN1/nT9uYIOlZ5bzRObfL3RmVDD56y3heiaeDJiSaVl+6zf60ROlHnWfSM0x35kXhE0MLnmh7GufvBH6AwfFYHj1vSIJCbcBJ+U4uM+ivgFnTjC2/Hfp7qwo3w2IyVgUWAmJL4UOXhgcxM6FpzFSconTkF/upfoM6pR+UybhAFFnJk+yfVxvIzX8/Y4tPpVv66X+QfINrggEP1vwKYkh7Aza4HH2x57Zw9S9XSYlesyu+oFqpuLneY8ASuupb0/ICNAcKbArZa+3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CH3PR12MB8282.namprd12.prod.outlook.com (2603:10b6:610:124::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Thu, 8 Dec
 2022 14:38:47 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 14:38:46 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next] libnetlink: Fix wrong netlink header placement
Date:   Thu,  8 Dec 2022 16:38:16 +0200
Message-Id: <20221208143816.936498-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P193CA0020.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:800:bd::30) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CH3PR12MB8282:EE_
X-MS-Office365-Filtering-Correlation-Id: 72a31d74-c0a9-4617-21be-08dad929e9db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KWR8Y1aQKq+oH4gkvQiyLaPQVyLUsFDkn1Z6T3K24TqGvvhMg3nPC6HJNx6JJd3jNxjFlyKfDyuWI/oZjhS+7aWY3JXHOHyZM1PYSfS8GT+S6xqLZDqLO/yWmFXg48rrmgJ54YdEt+USZOsXUEoTRlXxiBSfPCT4TK5HASpYoVr3+UXVI5obP4PbHmSWrfXrKVCjCAvErL5s9f3wd+szsCueID7WUBNbO2vvMI45ESXyL+dxE/3JXowGtGIdWVCwi6AyVWaPUx6gvnuhL/17lvEN0qHDFbWPLCyJ3+5+ynvyx64bvQDvSbNuO2nv8z50L/TpCsQnasyACWY+1v+zwkErke2v7mDaeieJnWLoG+DLDSyofZ6rRG1ERFM5KLXSCatGdfl72OLX/EZV4BgPy6qpG09CxMo82gtFOfvOQbX+G3pn08o3+bA1j/fPbMxUBFb/DnQe3+u0qD5p9j4Xs68APjtD91XP+6eo0pK2sNYr8GsHI4aFUJxb23a81vOyRwkRPVQlEAznaI2326lw7XkBBGSe06zQDj0yOkXyxz81NJYC+Dcz7/kNVd0WOekwoY0KSJ+Q5RPz01FIaBbNGwhT/XRN73uO9AAtoyPIE2Skp7xPIXN4mfiWhi9n4a7LKJsYw4lrdp6uHgZkLcbBgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(39860400002)(366004)(136003)(451199015)(5660300002)(6506007)(316002)(8936002)(8676002)(66476007)(4326008)(66556008)(2616005)(38100700002)(6916009)(66946007)(6512007)(26005)(186003)(86362001)(36756003)(1076003)(41300700001)(107886003)(83380400001)(6666004)(2906002)(478600001)(4744005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1pOlk0JOj1aQxrqk9U/GLixAGII07H25dy1tp7UhYsV+yD1FbmXEKW6GsfI2?=
 =?us-ascii?Q?zOgReVyJ3Sr5EL61Qcww7R4cvoPxgdxbmGJzyR0uWK+dUPtF7U2OpVeWpwtu?=
 =?us-ascii?Q?VCxVAWDI3gWilv+5Axh+4l8/v22sf85EYkeFkbjYdgOMpktXIv/swjXpM4ld?=
 =?us-ascii?Q?20Ej5bTNCIx+lCJOwSNYC700gbiS/s/KLspBffR/zVPcdPFnYTy3k9a23jSh?=
 =?us-ascii?Q?IxVtE9gARP6sY2GrbPsOVmCrVjZWcZQp2ObbmYdLNKhwhYaMez4Kcg+4yLbl?=
 =?us-ascii?Q?thQq43fg2WksKggSIT/NcsnPsT7StpKitWvjPyOcbBBhLNb91mKjve/MUU6x?=
 =?us-ascii?Q?MIgz4qCB4L0qhn0w9wdBJN66npDu8+yqfhShbWR9H9L7wAoO3gwsmJ9oY5IC?=
 =?us-ascii?Q?yqIOymdbI0z4UTYv2xtU0pnK/LeuoimoMcdpoahPizIWCOOQzz+pj27x8rPi?=
 =?us-ascii?Q?sbg3zqfA12afcEgs0itos6jCvoJjwdpUY6CbBDLrq51ivb6aHX2l+MNhFYIf?=
 =?us-ascii?Q?kIbiMbSGcqKLl8hi0yjB4v2qFfTB+l1xotRVVvZDYHrj/58Hll2hS5uO9yeQ?=
 =?us-ascii?Q?EcjAXO4mBgQS7QLWoc6vH73DSOKeFcUFI1WSZmVeKgIQ5kWwJ4BO1AzOYdj0?=
 =?us-ascii?Q?AVODfRxiicLGNPilBYR0jWVpVdYBf/uW3LVx3gh3LMcqf1J60FOBoQtuBWV8?=
 =?us-ascii?Q?7qAPVLo5hFBMIZl6SriXKt8nDpo3Re2/eEZy2EMP7FOIzZkVocbZimi2IbTm?=
 =?us-ascii?Q?hWuZU56QJa/6EhoqNaTRY1silGvQpvtEJA6wb9YbNcJPOpXOtIwfJrBAO3Gr?=
 =?us-ascii?Q?sHIHhZWb/eIMrIZ0Ux5uQvsIrs38BcUPwBLXRNUmsT+EXufAIxQlmTk/r++Y?=
 =?us-ascii?Q?PVd2OooHsdjgCa17CtakIyHNjoTZLy9F1ci2JKYIhBkew2Gx5i19N8lwua5N?=
 =?us-ascii?Q?EzMU8XoHfnQ3ARokRGYVAiT/Zu8GYlcy4h69fapG5ITsw3pt+9eWGXeNzWsM?=
 =?us-ascii?Q?tuGYiajwujcoawQcZ76nqLrjDefHaUezPxljXDtlzSHMgEP9CJlYq4uQAJ1+?=
 =?us-ascii?Q?HJFihzYMt6oPNT41JzHzRcAwF0I7MzD+1vz6ViQTBZCxr7Sr/cIqZKM28gM8?=
 =?us-ascii?Q?wakUn2pVqZ4Ev9xHxKrSIUgL8HgljkubWEyh1mmvGmSjBBMBL+PUG8IhQ3uB?=
 =?us-ascii?Q?375mdQu9xp+MM8qX84agNARrfxTcNK9gUC+K+Zm5lSy3iRjzmN22aE9R2jju?=
 =?us-ascii?Q?1HMYvf7lnVglx78QI5hbHz+dziwio+tC4KgnK3oCsKibPJU+6HEQxPZWEcA9?=
 =?us-ascii?Q?wS1hU/h8rKvES+PZkdbroyVCCwN77Lk9QYXB+pB3BQUzPNX8snSn0vbjhGj1?=
 =?us-ascii?Q?L6p31o4/tEJHAevyhAe/X6KvHvC2bWBT9pzxtIfNYhkKhFIDFllKFzw4BqYV?=
 =?us-ascii?Q?rYkUF5VIkk8ScAFGRS/6qyXyvAEMLa6es3BuAYLu8KxvS5QnM3CQMjaKVwd5?=
 =?us-ascii?Q?Z79920m9FXrYNfvoft/kw7/d5KcfSSJM7XojuOHg2oYCgWb2M9c+wD+DyrYc?=
 =?us-ascii?Q?XrYs8BzRoAb4jJHcTjHpdMzClW1Z+4f9ZfXVLkM/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72a31d74-c0a9-4617-21be-08dad929e9db
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 14:38:46.8416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QSlLKxDBtEFszfoiBlPyC4xz7Ef7144+88kVG0EY8paGsAGdr++wfBQu3s+c9kru+vL7jBpdKgd8y/ry6dF+5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8282
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The netlink header must be first in the netlink message, so move it
there.

Fixes: fee4a56f0191 ("Update kernel headers")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/libnetlink.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/libnetlink.h b/include/libnetlink.h
index 4d9696efa253..c91a22314548 100644
--- a/include/libnetlink.h
+++ b/include/libnetlink.h
@@ -38,9 +38,9 @@ struct nlmsg_chain {
 };
 
 struct ipstats_req {
+	struct nlmsghdr nlh;
 	struct if_stats_msg ifsm;
 	char buf[128];
-	struct nlmsghdr nlh;
 };
 
 extern int rcvbuf;
-- 
2.37.3

