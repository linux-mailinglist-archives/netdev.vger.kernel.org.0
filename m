Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABE8E577513
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 10:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiGQI2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 04:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGQI2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 04:28:48 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0264BE10
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 01:28:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IGhwsIFZGBY5ldWhiXQ8d4hv3qu1d4hUpYvZ603jP6xYW+4/V/3mzC2FQWzXaiH0SEVOe25UpomMBxDPaJf1gXErWfeskqLDw4cXRX3IHkVR7vAg7UKKPIHCC6Kzsr11CY3E+3TTSvoanla45BiXbY99KTTsIRfS55ieFMTtz9dvyi8KWByS928FdeMLQ9KJtuRw53BCch9nOajRtSTNGDoxz+U6tWTE65L8t9QNgC1wSQuADoHRgn+T8fI7nZIOJHuHhI4cL05+ZPC/8CX7BfPiFcxrgDpTqVSKQCp+/AeAF+TSSpdmPEYom2BIYaRxQn+BnaKrbVlKn35MZGFJKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ZqVnPkoPXnzwCk9lvTiXv88fItMaVlASMlDa38xhN8=;
 b=JmxpCFXkXpqec4BzX6kJ/oZMDynBf8DbBRZishisags6rakVl7BYz8yHqYbzQfBE/3NABKBGKxHkHX9xOdcda/6E0pYgPUP5H4K6AHglPklftNEDusYxEpH53Uqme4N0Nq6LYIU4Sv0MJ72MXm1Vw3mYLpO0HGY/6Hb+JQvQUPx5Vj3rSon1a7UsXbLLid0M6cbFfHozQBSGTa03UeX74ip3BqNlh2cjAQCRXUBCah4i/JmJQWxVMrm0VUbboIb/d3+I+r28yM7v1LGHzvAvsWjNOrXiRPQcCuCY/dQioFHye7YyChIfrAkQV9f7dSti8hNjRhT7wqHol8h07iqYaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ZqVnPkoPXnzwCk9lvTiXv88fItMaVlASMlDa38xhN8=;
 b=mDOZYzx9Ci40vxH4Hy1ChSuDX6lQ1EPLNQKSyzrNu2e6DligzaA4c1mJRtPCN2GxxVZ+ZpEmSlI1eKlg2RaZSycGgPW0/WDQKzU3u1nAzhnU9GT+Rvp6c1wWzGdTPuesVsHOOY2tilY64GL9OEhrTsKNcsONklmrEL3Ytze0HmXheHZt7hnIGflD1xfOBZO1PqC9VwlHOt5MArgTWt5YJw7kRtUsAGMngTwjePuD8ODoV4xPLzO1CA3866tr99tLKuO/Qbm+gdhr+2rDzu5mHVeCULeHz3SrqvrAOmfead9NwhCsXS5U4GGou2Zdd+EbRxnPE+BWxhHZIenSspaFxQ==
Received: from BN8PR15CA0037.namprd15.prod.outlook.com (2603:10b6:408:80::14)
 by BY5PR12MB4194.namprd12.prod.outlook.com (2603:10b6:a03:210::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Sun, 17 Jul
 2022 08:28:44 +0000
Received: from BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:80:cafe::ef) by BN8PR15CA0037.outlook.office365.com
 (2603:10b6:408:80::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14 via Frontend
 Transport; Sun, 17 Jul 2022 08:28:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT029.mail.protection.outlook.com (10.13.177.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Sun, 17 Jul 2022 08:28:43 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Sun, 17 Jul 2022 08:28:42 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Sun, 17 Jul 2022 01:28:42 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.26
 via Frontend Transport; Sun, 17 Jul 2022 01:28:40 -0700
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [PATCH net] net/sched: cls_api: Fix flow action initialization
Date:   Sun, 17 Jul 2022 11:25:32 +0300
Message-ID: <20220717082532.25802-1-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e535a10-4f51-4b6c-9d4c-08da67ce5c3d
X-MS-TrafficTypeDiagnostic: BY5PR12MB4194:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M8BMSn5tuNWIxIY75wapIWVK0gRRQ5OaAxKA4VQB79Ln/P39RTEJ9fw5/42bYQUrMFH12Lep5RWJSdcCtGtRkIx5upV/xs3Jb+XMHBCdF6I+5ESPCb08UzCrtPunJcvP0TLo7i6EF1UJ8ftzAC8iIvz6Kn1+59Fn/FnQQ6sspW29bybDDGul8pYu1nS4aSakplVoQB8ganWYJkifofEKKlVtKTG3G1zG2I0zos7OFVJhb5G3JUl87h2h4YYo7Dm7qxrZDwzVX6H7LPZhe0dieptH6EPOIuwHa1bHi+JZMNv7FsJIiCWysaZERYouXNiMTBREROvz89QsfeE1rMh6dllMtQBHQzn33kkeueY0UKGhKmG7l41w7SFtJaQdui1btvVqKBCY8s5cHc/fMC6IVq7l+KYYcOjT1+O9mua+oPgFC7oHYe2Hu0rPkwYkCYD77Y6R5SoiFv6DnzfDcOG46fbGHMxFnT09cMMAMsQO5tULi/YrIIzDlsMP1zl7NBzgKrb7CYFOpkWMEqIf0xsVgH0I4+gpzf2gV0JJUCU4SeRxAARuiCx/kUB9KEDVf6Un6sDgAR3azZCJg1IoGma0eNGRQenwpsDJojqYVm6MB9m5GwZ/EAm8IRgtoi64YVNt1NYmNksMlFhR+ez5JhysbPlfC57/MyzkMAIdsEyhtTxJUmE9TPd840OmssS9Q12030urIW3jjSuAXHCNP1nfxW3g+uOgRMOImrsc2lVFi7ZdhRCoDFXTLqK3vYclbsfhxalD3GkAXJ8FWnwKY6bqDbIKV51F3Zd9KPamfxyRFM84vvubxsrAR6zsHZ7vrWfKM8s3kCqx1QaaO3rkgzhGpb3Lt30vvyv7gMRaSrgwsI8=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(39860400002)(346002)(396003)(136003)(46966006)(36840700001)(40470700004)(81166007)(336012)(47076005)(426003)(356005)(2906002)(40480700001)(36860700001)(86362001)(82740400003)(82310400005)(83380400001)(70586007)(4326008)(8676002)(70206006)(8936002)(478600001)(6916009)(54906003)(26005)(316002)(107886003)(36756003)(1076003)(2616005)(186003)(40460700003)(5660300002)(41300700001)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2022 08:28:43.3093
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e535a10-4f51-4b6c-9d4c-08da67ce5c3d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT029.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4194
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cited commit refactored the flow action initialization sequence to
use an interface method when translating tc action instances to flow
offload objects. The refactored version skips the initialization of the
generic flow action attributes for tc actions, such as pedit, that allocate
more than one offload entry. This can cause potential issues for drivers
mapping flow action ids.

Populate the generic flow action fields for all the flow action entries.

Fixes: c54e1d920f04 ("flow_offload: add ops to tc_action_ops for flow action setup")
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 net/sched/cls_api.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 9bb4d3dcc994..d07c04096560 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3533,7 +3533,7 @@ int tc_setup_action(struct flow_action *flow_action,
 		    struct tc_action *actions[],
 		    struct netlink_ext_ack *extack)
 {
-	int i, j, index, err = 0;
+	int i, j, k, index, err = 0;
 	struct tc_action *act;
 
 	BUILD_BUG_ON(TCA_ACT_HW_STATS_ANY != FLOW_ACTION_HW_STATS_ANY);
@@ -3557,10 +3557,19 @@ int tc_setup_action(struct flow_action *flow_action,
 		entry->hw_index = act->tcfa_index;
 		index = 0;
 		err = tc_setup_offload_act(act, entry, &index, extack);
-		if (!err)
-			j += index;
-		else
+		if (err)
 			goto err_out_locked;
+
+		/* initialize the generic parameters for actions that
+		 * allocate more than one offload entry per tc action
+		 */
+		for (k = 1; k < index ; k++) {
+			entry[k].hw_stats = tc_act_hw_stats(act->hw_stats);
+			entry[k].hw_index = act->tcfa_index;
+		}
+
+		j += index;
+
 		spin_unlock_bh(&act->tcfa_lock);
 	}
 
-- 
1.8.3.1

