Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5A7565E9D
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 22:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbiGDUpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 16:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbiGDUpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 16:45:44 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2065.outbound.protection.outlook.com [40.107.220.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3399B2630
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 13:45:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixOdQmAp73/ujWpTKmwLtswkojT5jT+I0ToUwEmqZk8Fv79HbGshwHHNw5AX+TgL31QF3ePZzbkYYN/bcC05xrXlbKfH0bHnpVaB+U/wk4tAXmXZAIVuq7PbheJRMaLJdleOnLKyzDetFix4z+mQudEGS8c97TztZCdJeurbs2hQRKpC34rPCH3ulo47eSVO/4exhrGVEiAJ6lM90NosU2N3lY2HfJXDT/SNJrkAcZtWzLK8UKEtorBoLyOfxANyis98RuKvlkPbnn4AMJjXxfY+DAbNqh3jyKq6ArspxH/GCX72EB8WR4F79eYYwLExdwNUkyCGc4GT5FWI78BD8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=29Y/mdOUer6RehseOtWrvi+EtRNA+M8mGwcrpK2WeY4=;
 b=K+fhtks0Su3+iKNicxIRPR7kAO6Pw2iJXkB2aogWPsq3+yhQYb8+xaWWOOPaxOILz4yufkG4JqnJKwuAQmYv6BUYizvEmglofq4Fpp5N/Ldc4pwLChd8RSwyPfErHeDr4XvHWgJOUXJIIKSTwYwlAnx0tf2lphZlIc1oLGCWV6xRJd7ORTv1Q5PtcpT1nd4+UtdEhp+xjqIVwVFUZ4SfesuhDTM8ubod28M5+z44CBTFREbOFprRrG7V6qRck/1VB6KUsOS3UcniHoH/bE8VykCgIud8TFs/r4no6hEUYZgfUKEA+FuzFIPIuY3+28Ful4Ac5CRTX2DYPYNcX1c88Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=29Y/mdOUer6RehseOtWrvi+EtRNA+M8mGwcrpK2WeY4=;
 b=NQexOPUnPnvNwy1s3t7tmWTEAPTRkuy49a+7GHCK0VSeDd10a1I4tKVsBJGcaZp6IKn0Om+LCmRvRHTGbSylOqaPF5uehNRwZIpgGEyaQAx00wo5g45uD1KTpEMOcOWYD2xutIVsAezZFTGfr+DHPApo1x1SzgUjTHKW98vfkDsijLqBKuEwNQ3+0uQapXVHOFjTVBBOjVLMBgvHmP62GkEKbzkJShfTkEiS4ye0pCIZF8SXerhMKDrMrwB7qklaZOkf84vKYtPG+fxygbWr1xLmUT1ly7WMu7Kvyvk5cR2Fblia6Ti3L0VgfbThkHzBCqsLZEcWvq7hKzfKQY2uMw==
Received: from MW4PR03CA0130.namprd03.prod.outlook.com (2603:10b6:303:8c::15)
 by DM6PR12MB4420.namprd12.prod.outlook.com (2603:10b6:5:2a7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Mon, 4 Jul
 2022 20:45:41 +0000
Received: from CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::f4) by MW4PR03CA0130.outlook.office365.com
 (2603:10b6:303:8c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Mon, 4 Jul 2022 20:45:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT012.mail.protection.outlook.com (10.13.175.192) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Mon, 4 Jul 2022 20:45:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Mon, 4 Jul
 2022 20:45:40 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Mon, 4 Jul 2022
 13:45:40 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Mon, 4 Jul
 2022 13:45:37 -0700
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <saeedm@nvidia.com>
CC:     <jianbol@nvidia.com>, <idosch@nvidia.com>,
        <xiyou.wangcong@gmail.com>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <netdev@vger.kernel.org>, <maord@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net 1/2] net/sched: act_police: allow 'continue' action offload
Date:   Mon, 4 Jul 2022 22:44:04 +0200
Message-ID: <20220704204405.2563457-2-vladbu@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220704204405.2563457-1-vladbu@nvidia.com>
References: <20220704204405.2563457-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52784aa3-d11f-45db-7820-08da5dfe28c3
X-MS-TrafficTypeDiagnostic: DM6PR12MB4420:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DU9wB9+nWhV4xRD1ZSot4iezUd34KYFH/sUppEHIG6Qa0cTgOuatdPL8oSeBZQf4Bg9lLHUHKMW38BwvUpqw76zQGGJ0ZEhw/PXozJNEEnxqZIQuRorKdvEH8RyobdUf68Gu5GLZWLqSuJMQpnVw2piAeqwEwaVE0NT2hj8f/CkhoDyNqt7RdXvN5pHJpwd3V86yTDyi6VZ7mxO9kh2xn1YW81VMFVFZu6G9V9li2AcO2dfal1Zj0elgz5X+2lkYQ1/8i0I4CUJ0IpRGJJgt2GtCFghp364aVB/ZvY2Ae5VKDFgawxiqfyNOjgYGlwwUGjYGWSuXkte7TjySCG+NUtExpHkljnF2qJ6DPlgyldI5EDxS886zD/PtIGUsNNnecBogmghqP+L1DgB2Xm8dvtvAZ4XnOkCBmPE+m0TpzOxeZJ62eqICit3WQVk6fnh+Yc+pzDcW76mrl3svNSE9fMt1fql25il7+7Du3y7AhlABftBffRQafW9iL1XLKmXXkpclpgD0y31to4tQObVrYnWcBNCw3JW8rYNOW4EoeO6bC4VdCVQvOgKsCiZi5cIii0qPFI/L9FeRxMiHMhixEZ1XsHqSLfMIegnquTvVj4rivdoEi/gaHrnM9mCdUJHhZJJ0D1cXr/HTK28uOUhuIJBBJmbZ9Qn+oVIR9qitiVCZ7cw3beW28iCUZFlEBuzSamd10fhMY8nruxPSCSpuzPKV17SmkrqiYPzSwRRIub+/OOsVSBvBiAidALAQegT2vJX5VprHouRPRYCGntdcBL0LLnuuGEsDYsOCN+BXNvmpwHJiWO6qC0Xd7SVjb7RUcIiQnJU9q13lLacL4M6UoHGNRFRLaeWbp6+lpraPe88=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(136003)(346002)(39860400002)(40470700004)(36840700001)(46966006)(5660300002)(36860700001)(86362001)(81166007)(107886003)(336012)(426003)(186003)(47076005)(83380400001)(356005)(36756003)(2616005)(1076003)(82740400003)(8936002)(478600001)(26005)(7696005)(110136005)(54906003)(6636002)(41300700001)(316002)(70586007)(70206006)(2906002)(40480700001)(8676002)(6666004)(4326008)(40460700003)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 20:45:41.2071
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52784aa3-d11f-45db-7820-08da5dfe28c3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4420
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Offloading police with action TC_ACT_UNSPEC was erroneously disabled even
though it was supported by mlx5 matchall offload implementation, which
didn't verify the action type but instead assumed that any single police
action attached to matchall classifier is a 'continue' action. Lack of
action type check made it non-obvious what mlx5 matchall implementation
actually supports and caused implementers and reviewers of referenced
commits to disallow it as a part of improved validation code.

Fixes: b8cd5831c61c ("net: flow_offload: add tc police action parameters")
Fixes: b50e462bc22d ("net/sched: act_police: Add extack messages for offload failure")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
---
 include/net/flow_offload.h | 1 +
 net/sched/act_police.c     | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 6484095a8c01..7ac313858037 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -152,6 +152,7 @@ enum flow_action_id {
 	FLOW_ACTION_PIPE,
 	FLOW_ACTION_VLAN_PUSH_ETH,
 	FLOW_ACTION_VLAN_POP_ETH,
+	FLOW_ACTION_CONTINUE,
 	NUM_FLOW_ACTIONS,
 };
 
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 79c8901f66ab..b759628a47c2 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -442,7 +442,7 @@ static int tcf_police_act_to_flow_act(int tc_act, u32 *extval,
 		act_id = FLOW_ACTION_JUMP;
 		*extval = tc_act & TC_ACT_EXT_VAL_MASK;
 	} else if (tc_act == TC_ACT_UNSPEC) {
-		NL_SET_ERR_MSG_MOD(extack, "Offload not supported when conform/exceed action is \"continue\"");
+		act_id = FLOW_ACTION_CONTINUE;
 	} else {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported conform/exceed action offload");
 	}
-- 
2.36.1

