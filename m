Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5764A68B016
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 14:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbjBENz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 08:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjBENzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 08:55:53 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDFB91E5D1
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 05:55:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k4Z3zrKw9S25DEiAyBAgb0jYZUS7tshS2V9VWeMn4BFdelxknIizYXgGhnVdUPORkWvPuxQQY+9UTPAKBZJ1xV2tqpGZF8Ehus5whyKFok9hVEYnV4oHWRbfZC9Fh42SK25piZP3g27V1EoBFn8whXPyFVXp9I8vSaRtvq8gQ0SdQi072PvHnyblXtXcFGjNPKDTDWmLsOzYie0HXAFHfvs4Ww4xGuSP3R1BHpKv83mXZs32MMyTn9GTVgIA3g9DN4rdir2dEncI5GG/Hyc5WSI/xyJs0dGKiwzBw1wY2r0jCOR+RDmrZmba9iDCjDEdDAAeEkrSfX3e7NvGNzZWRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x+7YDjkoSoU+0wJnvoF8VMfGYxl7O4Sl4bRE4vm0nK8=;
 b=D6tFJ+401TkYoqhTAhvGFsbmjSSUCC8crdkaBVdWIe9/Ou/MK+mAFaO+nZ06wrEKfiQPG8ArfiAwvZ+PzJZ/wiFyLpSdTvEdhn+QmaCTkay3u8+RKiljiOpFkfqCbAu8msllMc6GZiFxx+MuNgnAPaViCDm+fUb2rogT8ynPqMTPFz8j+PInaV+UC53uk1XM3xfVB4C8+dpeMbxJAJeOIlVMqy8X1Hwk/FJDeYfwTFX8L6toDHUcYHHuMQ52/mug/gTB/PVpGeuVpLLIrp7iBMqH0fbZS/RznhQEl30+PYNopahObQfotI2kskSpiIvdrZmJqjZhRrg6OcO3iJL3BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+7YDjkoSoU+0wJnvoF8VMfGYxl7O4Sl4bRE4vm0nK8=;
 b=P1nEjYMePPS1/2QTbB2bIAxxNSFvhzvmHhPievt2cfMnVc8mFTaUR1dNlTJTCigKYl5co14s6eBxWlH3MOTMvBEeR5jT6nqHOH4hIxX9ApV2U7TD0IU99IEXE4zZ5+XMLKitQXVMnC+Kfzvt+DIfGYQ40ABTD2cFwM3vkBdMrx6qWMpRmRGlbPdCM9qCcLFy6byatbJIEeO8pUFlFr5OrbSCpLp8DHDtLylcxPng7WE9b7cT1/2KucOl2jGayH5IQRdHAe93czsSfpD0JZS35/82aoBF8qT7DT9C+y7JMVy604NfBJswv/AJhoJEFgQUIjlkyVckTFTPJOz0NfZeVg==
Received: from DM6PR08CA0015.namprd08.prod.outlook.com (2603:10b6:5:80::28) by
 DM4PR12MB6662.namprd12.prod.outlook.com (2603:10b6:8:bb::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.29; Sun, 5 Feb 2023 13:55:48 +0000
Received: from DM6NAM11FT104.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:80:cafe::99) by DM6PR08CA0015.outlook.office365.com
 (2603:10b6:5:80::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Sun, 5 Feb 2023 13:55:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT104.mail.protection.outlook.com (10.13.173.232) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34 via Frontend Transport; Sun, 5 Feb 2023 13:55:48 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 05:55:44 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 05:55:43 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Sun, 5 Feb 2023 05:55:41 -0800
From:   Oz Shlomo <ozsh@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        "Jiri Pirko" <jiri@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        "Simon Horman" <simon.horman@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "Oz Shlomo" <ozsh@nvidia.com>
Subject: [PATCH  net-next v2 4/9] net/sched: introduce flow_offload action cookie
Date:   Sun, 5 Feb 2023 15:55:20 +0200
Message-ID: <20230205135525.27760-5-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230205135525.27760-1-ozsh@nvidia.com>
References: <20230205135525.27760-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT104:EE_|DM4PR12MB6662:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d55e264-6cd8-4dde-c194-08db0780af57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WSnV5YBMkVixLzOOmnxzFObpfA2iaQ/FiJsoFfYpSm/HjUY3GQAf/j4ma5o58HV11DCSpxJbfgb2MfgX4rnq8zbYCMaknjdliO6eNucd6iPVCBee1ANj77A98L4ITqm7eT7zg0hJ78B+diobVjnMbOjxWEHtjMd6mHbm+WbdttKvkaNBrK2BMN2FVmGxIj2XhZZ6U86ApFnEb1DHdt13Od+BYZMgWJ5YOilET6eFoUIpLgLidEIoejDu4XLTOf2mSblkUP6HOMEUIPVLeHsXHRFGNiq8NLQla767J+0utdy20BHKjiuzPMFNblxgi+/ksn2M/T75MAHeYDQRamqEFijHgy5UR4PHSxr1noIp//z4cDxYTkrLb+Dj5NTKhmK91OnGsiapbI8xvtCyjXUqP50WprNW0dBCXxWxD4qsIwuwCl2eBolneyDq1wh78780xTa4T3ICSmIPeMUNvBt1x8i9rawy3f9ln9WqXRxQm1K6uAAEhxK2Rjtxz/DpqIWdjQfeKBTMQWTpktdDFTU+pZaV2d8x2PSx5jJBvzZC0QMTIWWkD9c1cHrKJkyFOHynYT5LM/NiI+IOpIxI9U38oc7oGeX5QvDbIUx3+B+QaL/jmxBmtOSIIst6s+03bVc/hEo7JTw5zN1/vcDF2MdsC5f2bt3TFHiZvousfzZ4c3xoq8wXmfabSZAtogsX8MzF+lStbBrQ+XYFIZ8D8DmAuw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(39860400002)(376002)(346002)(451199018)(46966006)(40470700004)(36840700001)(70206006)(70586007)(186003)(26005)(426003)(47076005)(336012)(6916009)(4326008)(8676002)(1076003)(8936002)(40460700003)(5660300002)(40480700001)(83380400001)(41300700001)(36756003)(6666004)(107886003)(2616005)(2906002)(82310400005)(7636003)(86362001)(82740400003)(356005)(478600001)(54906003)(316002)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 13:55:48.0467
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d55e264-6cd8-4dde-c194-08db0780af57
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT104.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6662
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently a hardware action is uniquely identified by the <id, hw_index>
tuple. However, the id is set by the flow_act_setup callback and tc core
cannot enforce this, and it is possible that a future change could break
this. In addition, <id, hw_index> are not unique across network namespaces.

Uniquely identify the action by setting an action cookie by the tc core.
Use the unique action cookie to query the action's hardware stats.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/flow_offload.h | 2 ++
 net/sched/act_api.c        | 1 +
 net/sched/cls_api.c        | 1 +
 3 files changed, 4 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 0400a0ac8a29..d177bf5f0e1a 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -228,6 +228,7 @@ struct flow_action_cookie *flow_action_cookie_create(void *data,
 struct flow_action_entry {
 	enum flow_action_id		id;
 	u32				hw_index;
+	unsigned long			act_cookie;
 	enum flow_action_hw_stats	hw_stats;
 	action_destr			destructor;
 	void				*destructor_priv;
@@ -610,6 +611,7 @@ struct flow_offload_action {
 	enum offload_act_command  command;
 	enum flow_action_id id;
 	u32 index;
+	unsigned long cookie;
 	struct flow_stats stats;
 	struct flow_action action;
 };
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index f4fa6d7340f8..917827199102 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -192,6 +192,7 @@ static int offload_action_init(struct flow_offload_action *fl_action,
 	fl_action->extack = extack;
 	fl_action->command = cmd;
 	fl_action->index = act->tcfa_index;
+	fl_action->cookie = (unsigned long)act;
 
 	if (act->ops->offload_act_setup) {
 		spin_lock_bh(&act->tcfa_lock);
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 5b4a95e8a1ee..bfabc9c95fa9 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3577,6 +3577,7 @@ int tc_setup_action(struct flow_action *flow_action,
 		for (k = 0; k < index ; k++) {
 			entry[k].hw_stats = tc_act_hw_stats(act->hw_stats);
 			entry[k].hw_index = act->tcfa_index;
+			entry[k].act_cookie = (unsigned long)act;
 		}
 
 		j += index;
-- 
1.8.3.1

