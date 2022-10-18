Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE7B602B46
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiJRMIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbiJRMHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:07:34 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2053.outbound.protection.outlook.com [40.107.92.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9DC1BEAF5
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:07:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPUYKR6ZHpLvehJ7dkLpmQQj6DQgPQOU8KWyp49M+CcRRl3SaxvgvJIWo368OWwLFHi3A3xEXYrcHa3brXLE7Lf3zcU7LCkLEswXVPQDGSoEUrPhzAwOtkDD2cyG7fpjZA3iWk1AQGWP0uwc19UfQRL3oxX9x4NfpijXrgOE9eJu7534qapbaZscNaFdtF13rgbYk5zl1rcN2qGDJ+ZW9qf5vBgbLCxo2d9Y8Jbq+L1Ar30Dt0K6v9Etm/HZTGtWQuXiHHGJhxjw9k8kYNdBCqNCz5admMic6eephqEMNUE4j+QoL+36f4ODl60om9luZa74sIcDjIcM/xXGSWX8CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wrUwrnsOuhCUGW6KTHebnTsZpuheVpQu+htC/Bq7XBY=;
 b=mIeaS8yL8F61KQ4vWmUfaxxgH01jszEGXqrfQwod7UT3dbshiXJ/IqgwtL5mE4f3mmSIrGRX264WiJ4yARN8JlLnb2AzBzOU8HXMRhYO1XHnMIIXZQyf432/UvcR1NnUvkUDJHiGbRdqz3zywZuIW9IHdT6/MC32ArMwYdFAnFrMBntdbi6H+AbfiN3VPo5c3zOxqZuC6/528czKt7FYx6U9msLATIAZa8EbtOsEkG+wz38grMj5bYrydeAA3CKzmjEn93vvPGoUcafGGlb2/Un5UoD4U3bxECaHCN1YHzaT9Fyv02nhKfRTpDGmxfTc9W8V3YOZzbgIYRaVyDlLCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wrUwrnsOuhCUGW6KTHebnTsZpuheVpQu+htC/Bq7XBY=;
 b=hVN3LT+Np7U0E0TNwp6uHhTwrMs1jJrevI4CZ5GNrv4F4rVTDmYZx3qivotRNBikuAHsqbY6v4ksDKU79b8PcHE0vUIblbdiESbbz57ngw/dKzQxW7a7/BhcAB+yh0Sp5qi1dKe0TsxZRsarJv3jlU6jIgm4e2MNaGvbzz4WK6ULFp0e9igp7lk66EVvrQ5mJuZ0N/s8LyTKU127LU2REh17DRTIaf8EZmDw5dwG7Y9M45stMV0RPUJyxrcVfMvEvc/i3DuV7xJi6yiLQ8TQ6fNoEJXqVUB0IxwV8cc8o4DbYEZM952YxIYkArfR2z2aG8qfBcYKaA79F9swoMm0iQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY5PR12MB6406.namprd12.prod.outlook.com (2603:10b6:930:3d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Tue, 18 Oct
 2022 12:06:24 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 12:06:24 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 11/19] bridge: mcast: Place netlink policy before validation functions
Date:   Tue, 18 Oct 2022 15:04:12 +0300
Message-Id: <20221018120420.561846-12-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018120420.561846-1-idosch@nvidia.com>
References: <20221018120420.561846-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0401CA0010.eurprd04.prod.outlook.com
 (2603:10a6:800:4a::20) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|CY5PR12MB6406:EE_
X-MS-Office365-Filtering-Correlation-Id: a700dc1a-b8a3-4afd-65bb-08dab1012d3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fzq0VLbWMD8LzuDL2P9O9I4cTu4CclEOsDDi46kALppAUfF5ONsgVOF8jjJpvNDGkpu0E51gKkx2QTOo/skmNhw5G4K6sR5Tbmwc2VLq5LJEMwvcLVOh24jzLA06ZMkgC9wrNg2PyJl5+drhnifQGPKuXx8JjBUXrbLExNPMP8/uF8Sil/V44NuymHNEtjhdlscBrJc1vsldTuUSZwLe+bLvsSDHFGI5maJFKavsOymw0UH8nzqN9ZkwIjOE38+yji2yQ6X1G1cCY37swZ14fY7/3E0lKjaSU9qP+gNVKiHXZNTMzIBVjQ/mPJ7HgsEedi1zjIYdM+BPgjZxTKMm7Uv8PUby7nBak23ticTHNj5E70M0Li8r4saRpkYTD7PqkHP7IbNIb9QtjXLYAFd9j02AtSUZCwTSH30EX4vik9kGarWRdPKY4B34rJ2x6tohytBmAXA0dHKlMD2akj+AC4uWUpAD9qRbEbeA1h1rEruDF5swyWQd7WMIrxjuJ1/Z32WsUe4eAScMaXzOBm9Vs/A4OjoX2zhT3Nev33giOdYferGR187fsH0bXV32qwjjEEEJ18Lyo4AvYwo3fUwG0UF/g6gW/LJi6HF40zNGzdqNy7lZUiGqQMbEhx5+6UnXRZ0Fm+LXCX/bXxpq11ZRip8qqBcOwpyIF5EegY5Ogx7JXwz3ljKsCInPNmj96PtWzdnrmHDK7ikPlfz4VV/c6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(396003)(366004)(136003)(39860400002)(451199015)(36756003)(86362001)(38100700002)(1076003)(186003)(5660300002)(107886003)(2616005)(6506007)(6666004)(26005)(6512007)(478600001)(83380400001)(2906002)(6486002)(316002)(66946007)(66556008)(8676002)(66476007)(41300700001)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RF2fEvIIBiXVR6QynrBq/cbdbMYHI4SFD+irE3keEUnVd6HJfgI1zHMmOpre?=
 =?us-ascii?Q?bpxDmj/3D4iIsJmNIiseWT4Lnl2NVPP8MvRtoaRRtS1HkZP1iWFA0iH2kMuV?=
 =?us-ascii?Q?/qSm2nM9kLothGAhVt8BAnJHlDF5SmNuXUka0zOH4uJb68fDGcE/uplPBiFa?=
 =?us-ascii?Q?3/2+G+pOs2QdEprR1yvCH26qbpFfI2SMnJpbfArVwzhXqyFriE1BBeP36V4M?=
 =?us-ascii?Q?NJ6IWrQYX41gFroCwDqBbkvKfDBKIfYVa2kDf1NXfk3ZAEZMgO+z+lyBzqt2?=
 =?us-ascii?Q?eZWg5JNzckRza4PUTYNcOIqQcDcqpOF7Hdk5xWs6pPkwK4xnHv2VQPmI1SkR?=
 =?us-ascii?Q?iKcpXJTUdEF6z3VoeMH36R65MoZV2piZtPYA9esmLXvRthWPREwkyUCe2YQb?=
 =?us-ascii?Q?f7EM9sDqMmhlLKSx2J4G0BGCHPUE7OS9eSS/zvLYhR5/u5E4Dw8aWtr6Rdmp?=
 =?us-ascii?Q?7UggNy5jXIfxFy6HvwlPTNuhp/X9aEVwsLI/33UqaI6SlnznzLIWjMTvp73P?=
 =?us-ascii?Q?yL7GYN5Vtf1dwvyayjoFwJbFGZJlyfuOH7NE4F3+FuGsGf8tqUT7jgmCn3Ly?=
 =?us-ascii?Q?2ZtU8m0ooeEIWiPX6lrXQiisFDvZwBAW41EFD3GgrRjt6Q7Y7bVCPY8BQ/Eh?=
 =?us-ascii?Q?IRfrBjbEcRPeJlyATelygiko7Sv6j2Y4HtbMF3Po/HBtZ/JHXLvkx1cz2Ev+?=
 =?us-ascii?Q?JsU9g0EHayblr9QGAU+9sib3Uw01B6gvPg1TwdD760r6zwYUrK2rK3rbJvl+?=
 =?us-ascii?Q?NYHQQPAox0ySGsjY8QV2RX0gYsoBpymFpeRZ88wC0PkHNz+t6Mqn4jj5Be1p?=
 =?us-ascii?Q?QPn8QMOWNEqm/8w0ylxpdYpnOj9lv1pvphsyRH8kJMYguHPYFe33cg8BHqLg?=
 =?us-ascii?Q?xAxZTU85TY3zkzFrVKDnZBrSsbKXFmQvKbi+9vDmMviVdcXXnJuAZlne2M42?=
 =?us-ascii?Q?MYYw0JsuAEleXjvOTnzFuq1rQeAcLdgjUUiJEC5BbECkc2EO2Vmg1SSzPDEB?=
 =?us-ascii?Q?yXFKk6mjvsWwFAygfX+LlEYVkBqFF8QNW10sFi+OX1sh83wjiPu7fejOWRVq?=
 =?us-ascii?Q?AWR/9FPaEV8t47Th0U2aQznUAo7vkpCXXSzig0aS224F8iCoVCCKoYSk+iBC?=
 =?us-ascii?Q?4MXFVN2vMqNmNYzlxQSiiZfUwEGbUUJYGDNGKW3ZMoX8ZLm7UF5z+Rk0cp8S?=
 =?us-ascii?Q?i3cTPVFi89Gj6fWZEv3Ius5/CwaJyMekMYKdfi107bpipYJd9CDd8IZneStR?=
 =?us-ascii?Q?vRVt19XDA18xsvRttIEyWvGm641ZbdNmtBXEs2OdgPMxfbIr1RTZuNCAXMMB?=
 =?us-ascii?Q?Nwi9msdBB0i983c3Wksc5Lja74p9m1qW3y/3JqVPApDkhgcmBWZwBL4NgVjB?=
 =?us-ascii?Q?FkotI6U6kn/RZBo0dIs0IQSMtgS14QZh0TRCHRNe5bvm71yNxg8KptHUnV0y?=
 =?us-ascii?Q?CdOs9gcFXfoM5LQOA7JHW3CW4WqTY40htV2kYUWuaTL8SuSTSqcky+B9wg59?=
 =?us-ascii?Q?bqliv8scb5oKThFyvqGybiNoHHnIJOtjNigZEfxp4+/db6/Wzgmk3tRQBobX?=
 =?us-ascii?Q?Q7Nhykn81gn2P2xLBYgZZ0be/yTQ+ComKkRJIZEu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a700dc1a-b8a3-4afd-65bb-08dab1012d3b
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 12:06:23.9078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hKQHNMcVdjriGEoiJ7tKQfTybTPPTBSR5sRr4gDvV3F8f8lhiWamFcw0DJOnhsanrSIn7SCOass+TcxQZ8mL3A==
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

Subsequent patches are going to add additional validation functions and
netlink policies. Some of these functions will need to perform parsing
using nla_parse_nested() and the new policies.

In order to keep all the policies next to each other, move the current
policy to before the validation functions.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_mdb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index a48eef866974..26740df62fd6 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -663,6 +663,12 @@ void br_rtr_notify(struct net_device *dev, struct net_bridge_mcast_port *pmctx,
 	rtnl_set_sk_err(net, RTNLGRP_MDB, err);
 }
 
+static const struct nla_policy br_mdbe_attrs_pol[MDBE_ATTR_MAX + 1] = {
+	[MDBE_ATTR_SOURCE] = NLA_POLICY_RANGE(NLA_BINARY,
+					      sizeof(struct in_addr),
+					      sizeof(struct in6_addr)),
+};
+
 static bool is_valid_mdb_entry(struct br_mdb_entry *entry,
 			       struct netlink_ext_ack *extack)
 {
@@ -748,12 +754,6 @@ static bool is_valid_mdb_source(struct nlattr *attr, __be16 proto,
 	return true;
 }
 
-static const struct nla_policy br_mdbe_attrs_pol[MDBE_ATTR_MAX + 1] = {
-	[MDBE_ATTR_SOURCE] = NLA_POLICY_RANGE(NLA_BINARY,
-					      sizeof(struct in_addr),
-					      sizeof(struct in6_addr)),
-};
-
 static struct net_bridge_mcast *
 __br_mdb_choose_context(struct net_bridge *br,
 			const struct br_mdb_entry *entry,
-- 
2.37.3

