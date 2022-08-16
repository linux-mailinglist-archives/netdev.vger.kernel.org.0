Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773D8595703
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 11:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233963AbiHPJtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 05:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233970AbiHPJsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 05:48:54 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2054.outbound.protection.outlook.com [40.107.244.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348B265677
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 02:24:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJSXDT/C1PRG9WZqecu83ekooWWHl1U4P0+l5CnNAzFK9OpeGmhfY00ncFtDSIo7cS6M2b5oSrX4lTs4LcTLmWPAMwIQSNOXGZEcWmtgoe8dTlZkVZBdC3Z9Vux3p4lK944wvGkltvQyFnu6ET3oX/zXWoB7EujU9FW55buaWmXO51XeBOkaLI8xa20reinYJZ5cdCteUWI5QgNsRB1LxYb+t1lE91W3CL3WQkQMSFVEY0BE475zndXEPV9qTnGNEQCgCcwD4P0pzsX/wPXtKlt2dNk9QHDwUv761bkKgFT5NbiFJp4z0LNGmfGceRmWgWzje9dLgKngR5Z2G/hVVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bOX4SV3YGtRZvKECwnbSLPDhITdMdozC0YC5aPXcskg=;
 b=X9RAPs0mYxPScIo0kbfKVOZMSKOr+ovftqT9dhf8QB4i1giqKwWHc6a1DgBFyJ5iyZjRbVZuGhy/fdUXJiPb//hfLIE+1fMHliCtH7UXTMmpQYJgMxtJNh/9wsiz0eg5BJh89LLNdQsLUcNfGfhlr1c/1QABJ8EOg/YAVt/sokdJ5OsEcUW9IuTvTfpXJzvQSj9FVeIXAbn6LUpvYrzkjT6rmbXujCCuSk+u8xrVX/rMhn8Kmrnm8qEnt4znp7sEMwpfc3laDrYPtC6HVsChOD928NGjmNPCktEfcQckrB/aWArxgwqOn/JZCQkRrMCYyquJGF8fCBpqToL+4nvB5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bOX4SV3YGtRZvKECwnbSLPDhITdMdozC0YC5aPXcskg=;
 b=JLC7IR2NzIhVDFL7Q8wvR+qc6lU+GsdIPPIrnjniyZDIrZoccPbmpsG9RQickIcRUGF1XhnFnHmFTSx2jjpME3GipA+JiC4NaImIhmA96lbpLWjt5fCAKIdHYyzPR591/ldLGOl4JNLQMCgnL1WLcgyv3nq432kzBvALDMm7vsBX4pK/xOgcVL3luH4FRjoh9emU0jFg7Gv5sWBEm2rMERh5UBOmqJuwvqmhcmDEe/E25smII/Tj5JkJne+22UQ6Cwni2MzxSsW2KmEXUO2mYp6FSqVm/YjbVEI2q5dhciGbEXXpiJtsYzw/QcIJN0LS78U+r7uQ1i/nHOk/q6Q8EA==
Received: from BN1PR14CA0009.namprd14.prod.outlook.com (2603:10b6:408:e3::14)
 by PH7PR12MB6609.namprd12.prod.outlook.com (2603:10b6:510:213::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.17; Tue, 16 Aug
 2022 09:23:58 +0000
Received: from BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e3:cafe::dd) by BN1PR14CA0009.outlook.office365.com
 (2603:10b6:408:e3::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.16 via Frontend
 Transport; Tue, 16 Aug 2022 09:23:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT056.mail.protection.outlook.com (10.13.177.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5525.11 via Frontend Transport; Tue, 16 Aug 2022 09:23:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Tue, 16 Aug
 2022 09:23:57 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Tue, 16 Aug
 2022 02:23:56 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.29 via
 Frontend Transport; Tue, 16 Aug 2022 02:23:53 -0700
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>, Jamal Hadi Salim <jhs@mojatatu.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>
Subject: [ RFC  net-next 3/3] net/sched: act_api: update hw stats for tc action list
Date:   Tue, 16 Aug 2022 12:23:38 +0300
Message-ID: <20220816092338.12613-4-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20220816092338.12613-1-ozsh@nvidia.com>
References: <20220816092338.12613-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1a54ab1-759d-46b1-3e90-08da7f690c38
X-MS-TrafficTypeDiagnostic: PH7PR12MB6609:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i0nADNsTXNY5ENxgU7AkWe2YY/pfxB535xNqpoErvDsB/J1aOWCEUwVfU+05yb2A4zU0GurS+MeYJF4uMFdSXAQZNWGEPRGnCOYnuRwFefUm/aShGEiICZL0TIkfJqtByGv5bcNWrbouImcFMoC5cYmjhD3TYcJMRY4zGbDgia78p+ygLCVoRDq0JOtWmnNz/FZ8wAGbm4G0ZckfrCIeoUNkDftKyFph/MBIIxzBmBsnGW/HttwyQ5w4TN47ccHHw5sc/tU6cmxGzpcpwWYj5LZM+Lu6A1y+zsYnWWmdQCND8ZjkSHS0YF7iuNOzUwwm0uhRTNtJiQugqws96jP7ogxAu5H4u2QsRJN61V/fV8rOKHzVfJhwadLbJPnKF6PBQ8pCNUPv2JlEp68LAPfnOSyLsorTR5TYu/MAeXAwhQp8ytAaXhZr/bsbH88WDNDIBkrGGCHaEhSzLdKSZ5r1n16j13izsRlc38KslEjExC6238AX+blLPnzwBhLSE2+Qig/WNWCvtNSl9ur11WF53aTKdN3Z1eU2iurl0vmTbxVr5S7l9Jaij0H1tKbwtZSAq/clCzjCvrlPKNLmABapz6D6XS7UUSGksns1MOtZn4i21Nc7QWtb7eucC+K6D/JrgeNBKWHIKiAyu5MxsJR7GoqK9puDmLj7favFG/fJpVa/m/cmpVqvb+7SXvF1IMjP2Wz8XrdCJJx+s3s9dvFuhO/UnX+qM0OuaOtj/kl+gwBMWXvNJNQEx0PEjXvZTPfVwmJI5RX4iOG9N2Mkw3EkOWPwyM01uMC1dWBvVZlDnnjiPWqv50iUeXQkfh99QANMhvp7pgqGRhocqM3lq/57XQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(376002)(396003)(39860400002)(46966006)(40470700004)(36840700001)(336012)(82310400005)(1076003)(47076005)(107886003)(186003)(83380400001)(15650500001)(8676002)(2616005)(8936002)(4326008)(2906002)(426003)(70206006)(70586007)(41300700001)(40480700001)(36756003)(478600001)(6666004)(26005)(40460700003)(86362001)(36860700001)(54906003)(5660300002)(316002)(6916009)(81166007)(82740400003)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 09:23:57.7777
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c1a54ab1-759d-46b1-3e90-08da7f690c38
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6609
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently action hw stats are updated during the tc filter dump sequence.
HW actions are also updated during the tc action dump sequence.
However, tc action dump does not update the hw stats for actions created
during filter instantiation.

Use the existing hw action api to update hw stats during tc action dump.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>

---
 net/sched/act_api.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 817065aa2833..5d7b6e438085 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -301,14 +301,11 @@ static int tcf_action_offload_add(struct tc_action *action,
 	return tcf_action_offload_add_ex(action, extack, NULL, NULL);
 }
 
-int tcf_action_update_hw_stats(struct tc_action *action)
+static int tcf_action_set_hw_stats(struct tc_action *action)
 {
 	struct flow_offload_action fl_act = {};
 	int err;
 
-	if (!tc_act_in_hw(action))
-		return -EOPNOTSUPP;
-
 	err = offload_action_init(&fl_act, action, FLOW_ACT_STATS, NULL);
 	if (err)
 		return err;
@@ -330,6 +327,14 @@ int tcf_action_update_hw_stats(struct tc_action *action)
 
 	return 0;
 }
+
+int tcf_action_update_hw_stats(struct tc_action *action)
+{
+	if (!tc_act_in_hw(action))
+		return -EOPNOTSUPP;
+
+	return tcf_action_set_hw_stats(action);
+}
 EXPORT_SYMBOL(tcf_action_update_hw_stats);
 
 static int tcf_action_offload_del_ex(struct tc_action *action,
@@ -543,6 +548,8 @@ static int tcf_dump_walker(struct tcf_idrinfo *idrinfo, struct sk_buff *skb,
 			index--;
 			goto nla_put_failure;
 		}
+		tcf_action_set_hw_stats(p);
+
 		err = (act_flags & TCA_ACT_FLAG_TERSE_DUMP) ?
 			tcf_action_dump_terse(skb, p, true) :
 			tcf_action_dump_1(skb, p, 0, 0);
-- 
1.8.3.1

