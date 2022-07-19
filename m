Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C37E8579E4E
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 15:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242535AbiGSNBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 09:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242708AbiGSM72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 08:59:28 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4324F4F681
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 05:24:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MUWstZ2eTOzIVaphspauXNxUCnDyRMqyhpxnpFY8XjRVuct3Sni+N8FU7CR5xWGuyCtgz/QfYrMF3V01yoYYegHD3OYCVo7eGHOkf+tOcB7/pd2MqwAvAoEcUSd5LrGh01dKplMd8zaqWjSpVfKElvoA62TUCgxbV1X+m7E/78Z8rk4kwWSG9XG0YZj2SsDFx8xdxDqKzV+mKlprp+UFRtMrOB2O8tFRSbXrnykDsS/v5nvVsADJk7wDhQcL7jAb4nuDRbVErXcJGQ1RAAH3tdoYeQgcZWNssNjVieISujFIMU7g5NLL2h9WruWbNCfJwIKKFNQGTmLdSHP8v42VdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PUYvMvtGu6plptuG/I14jGegxUKZZU8tBZnrB5X7/cw=;
 b=bbWV4uddccuv4arA+8qlK2U/baWedtHqhRlCJa1oC65HO0UXn0ruLRU93BvmarZhwoe/9OXcY1k6KFEHCyFbJuczMlWIzXmn4fomoXBTopJHrUV0u8VDQPRULv8BgCx8V/aEmfk3HF8lRfhGi3EgfEdWPkB9D1mklcMdEQ2SDHHc93GNmRj2RGowgSKOKtzdjHIns9dofX5uRCP7CTlhNZWZxJGbY4taBPyMIkr3rzy8xjSd+s4YcXFNO8tKaM95lPvuzisHOmZ7q61xXwF3BVgVZYpgoawKRmWtSq4VjOfTCsramgYoEX/c0MFnrqPCeQue+5DxxpQ6LfvPBZRtjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PUYvMvtGu6plptuG/I14jGegxUKZZU8tBZnrB5X7/cw=;
 b=SEYUzOpHTXdSXLK80GukRP3bTOfFKz+BHxBGpaJLIuuaUGKnprOACVZl1SydWZU/8Nri1/lN9g3wxQIrUb8w1Vbvc4UBuc8G2YkcfmvoMbAkvk5y95NXcoTmXSUCsSkA9ALE0+5aFrxgSXfZ+kdnZrhhBYiKQCd84Wt4S9FCOeoVyUyIRagEU8mdF37vHwtV1Dsb5iec4Q1gcyY/d0QY32tytmT4YWdrBqSqKrYbudtElmnPWtcrjyHTCEPWjlogdX5BPwwPssDHIKb54QMWT7MC4MZ/NgWGsqbC2ACdz7NCXmRxTcbcoO/7b3rhNmlIhjnexm/HXnOWbG/9aoG7GQ==
Received: from MW4PR04CA0158.namprd04.prod.outlook.com (2603:10b6:303:85::13)
 by SJ0PR12MB6712.namprd12.prod.outlook.com (2603:10b6:a03:44e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Tue, 19 Jul
 2022 12:24:37 +0000
Received: from CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:85:cafe::ea) by MW4PR04CA0158.outlook.office365.com
 (2603:10b6:303:85::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21 via Frontend
 Transport; Tue, 19 Jul 2022 12:24:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT041.mail.protection.outlook.com (10.13.174.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Tue, 19 Jul 2022 12:24:36 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 19 Jul
 2022 12:24:36 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 19 Jul
 2022 05:24:35 -0700
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.26 via
 Frontend Transport; Tue, 19 Jul 2022 05:24:32 -0700
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Oz Shlomo" <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [PATCH net v2] net/sched: cls_api: Fix flow action initialization
Date:   Tue, 19 Jul 2022 15:24:09 +0300
Message-ID: <20220719122409.18703-1-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36abe4ac-9da4-493e-5e0c-08da6981a51d
X-MS-TrafficTypeDiagnostic: SJ0PR12MB6712:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 59L6VvREffHSRjpa0fsF+AiMFcNWtwtR7sHcvp/W2yMOQlHH+KAVCIrTKc6WfF4yTirMXcVnI+OrCsy6rLW1+H6kf1xR8yMLp3g+cYnlYua2Tu0FpAPnVQoOrTuAWJrtd5JP7ch5nUKJavLUxZR+pReX3ZG9UVnghqf2gw0edN2cKjUnBLo7FvDPL8FxFUmg7BCp9oWIb4bp+hpDsTFxDAXFXXBlaKsf01vgSsR5rIY86oYZfzWsuhTWxojRhTcXKAzVgEVs7PuYJdTheZkXOTQRx5zala2kYXoGRNwkNhDLW8PEg+TwxBkrgg8tyV4cGjm5avD8iImCzmijnij6jl/cVnxkuir1XfDDRBjQpw9z1sT2O9DEqqPrrCzsHNreRe5IWQhph/2HzaXEwIYQ0vUafin2YogrQ65dU2ek0JmFWzP0NvjKBp496bIZfh5GzmV7cpYZHhpuKXsUamUPPrnk1cfE6rXi2OqjCqNWaas9Dg61bezAisVyOe5MH1HzWmkwnIWcOSW1H5IhXS3QRzbUTv/UHntHw68oYt8YAV1YD8cOjOzoMLBdNQWuRSuYf4w+bzyC1DQV4Xp94wtIDcTc7o1hZxhyERqi2P3mrJAaebOyPSuY17/fxTbA8KupVO8DN3oeekiSb7J0SHtI+dXV5pNaWUoJPOH8U+LqCsauzC6Ku9EbrMZ/AysNV+zvXccbXwVq3SN9oSSMnBOdtV4TdNTazpu1gNvEPM+svxdHVIkHO28JAqsBVdMtC4y9sstRuBtPmWtFGYOmqQZ8fXPtKuoMpGXOv08bICqYbt+Tq6e8TrDXAdFni+pl1EmwBn2dXjDvTbKL1XsJAS+a/g==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(346002)(376002)(39860400002)(36840700001)(40470700004)(46966006)(6666004)(41300700001)(47076005)(107886003)(478600001)(86362001)(2616005)(426003)(36860700001)(83380400001)(336012)(1076003)(186003)(26005)(82740400003)(40480700001)(82310400005)(36756003)(2906002)(70206006)(70586007)(81166007)(8936002)(4326008)(40460700003)(6916009)(54906003)(8676002)(316002)(5660300002)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 12:24:36.7115
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36abe4ac-9da4-493e-5e0c-08da6981a51d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT041.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6712
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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

----
v1 -> v2:
 - coalese the generic flow action fields initialization to a single loop
---
 net/sched/cls_api.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index c7a240232b8d..790d6809be81 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3534,7 +3534,7 @@ int tc_setup_action(struct flow_action *flow_action,
 		    struct tc_action *actions[],
 		    struct netlink_ext_ack *extack)
 {
-	int i, j, index, err = 0;
+	int i, j, k, index, err = 0;
 	struct tc_action *act;
 
 	BUILD_BUG_ON(TCA_ACT_HW_STATS_ANY != FLOW_ACTION_HW_STATS_ANY);
@@ -3554,14 +3554,18 @@ int tc_setup_action(struct flow_action *flow_action,
 		if (err)
 			goto err_out_locked;
 
-		entry->hw_stats = tc_act_hw_stats(act->hw_stats);
-		entry->hw_index = act->tcfa_index;
 		index = 0;
 		err = tc_setup_offload_act(act, entry, &index, extack);
-		if (!err)
-			j += index;
-		else
+		if (err)
 			goto err_out_locked;
+
+		for (k = 0; k < index ; k++) {
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

