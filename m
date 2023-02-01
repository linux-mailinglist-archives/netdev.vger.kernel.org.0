Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B445F686B40
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbjBAQMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:12:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbjBAQMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:12:05 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE0E14497
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 08:12:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IreEPS43oXlQ66KX3s9culOs8GTmG+bMopoT38MwaN1OgSTf5TSXzSLuqOAtyLNHIG0gZz61BuL6e/ljNakl8Gd7jpkl12TDBhjbDrgQBMsU1taLp9ZXR6dq7rrNl/UjLbeVRRjtfX5jOqNAawo99plzw/kY+5Ra6ygYDVCCWpxU1V7JDbXz4IHrFH+eaEb4ZVZYW65W8rqlBPzOXEVQleJrPFbtdKj/AhRN9LznNGbpdDLTo/a3qXWGRgr++kf57ef71yQNikDqkRMQsRq7+S1DeSIJQAn1exT+yxlGe/ATaWVYbslZv0rHQnJbx3qIKH7pVRfa8SId4jbECfepZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nBbcz3M4jLun1422FZgS5K2cfwY7BBYuh7iDUjLyxI4=;
 b=hwLWqGxecxI6O+4l1CoF1qZtjFcX40LhlbDcip/bvBM0nzY89m6gsnBoXBo+sbI4CWZNC5TCX3Y2cxQ2AB3W3koPZoHvCfGTxE554OZ4C3F/iHMdgmGnto8puo9LG4UEeKcC63XEemM1bHJsIX9EKsfkZX3zlLAM8xIJojxlQnqK23pavwolaLkfJLeCO9bJPvRjDJM10uXEYs3vW6FPMrGGffgjGguNMvJQh1QQq/JSZl/NpyZn/JBhrPNr2wZdVIKE2PN8HuFyiABI1HDQAjUvvz/dq9QbVSAuUv6taM++JBgwjUxn6HZzCZ3wAhtI7NSaH1QNEOHcjJTzqzA6mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nBbcz3M4jLun1422FZgS5K2cfwY7BBYuh7iDUjLyxI4=;
 b=mcO2nN2zdotzbEhA0Dm/LcOEMhUeDFlX9sYASnny4muAukMl/YsF9CsDqA1uAV+l72QzP2mjh4nkpQcIeCq7hrC++f3SeG4B2GtWAZ2KmOagtsZY1LRvDvTgwa+q4cx8hZHK9k7cfbLaXnIwDrqUIIHpRTZqQqWZLxyJZoOIVCAvm82C+SWUs21tl4V/YheMMqXRmUV4L/sDSh7eh3yWTxcMq1dcV/BZnd+nh501yN+3xINdeEyfs7xaB4YTdhsRdKT2JDzG5MTW+MxRcw/WTKLHPXja3E0iUG856QiPD3iOVUEWPcVzjcKEdFZI4/iAdEDT7xKpNcupcff9Yd7SMA==
Received: from DM6PR02CA0060.namprd02.prod.outlook.com (2603:10b6:5:177::37)
 by DS7PR12MB5910.namprd12.prod.outlook.com (2603:10b6:8:7b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.25; Wed, 1 Feb 2023 16:12:02 +0000
Received: from DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::a6) by DM6PR02CA0060.outlook.office365.com
 (2603:10b6:5:177::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24 via Frontend
 Transport; Wed, 1 Feb 2023 16:12:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT003.mail.protection.outlook.com (10.13.173.162) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.24 via Frontend Transport; Wed, 1 Feb 2023 16:12:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:11:55 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 1 Feb 2023
 08:11:55 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.6) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Wed, 1 Feb 2023 08:11:52 -0800
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
Subject: [PATCH  net-next 4/9] net/sched: introduce flow_offload action cookie
Date:   Wed, 1 Feb 2023 18:10:33 +0200
Message-ID: <20230201161039.20714-5-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230201161039.20714-1-ozsh@nvidia.com>
References: <20230201161039.20714-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT003:EE_|DS7PR12MB5910:EE_
X-MS-Office365-Filtering-Correlation-Id: e782745b-58f5-4d8f-a865-08db046f0e01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ObWsbx6zjysnK7sopuyTel9fDhcAvZS8dIvu9vKcytKqiva7XxpkP8rx6VDZowwy/n8kRwp93f0+5wci7t7mNvf47rc+MdLL2bzwLZ442mWrnI+AtMfkmndA0LmotUA5A5xbljItKv7rvWGBMpW7YmzThtOc0paDspOyeyRU+O+ZnsYRuhvxCQDMGArt+zkeb0iy+zJz+DAyADO9p3wrw7bqtr9HBo+4Iyt8O5nW0wM1NDjtqXFjY69Msap6+r7ugO3pi+0CrMvR6sxd4nurpkVScw7attVnR9Tx2ELvIwwyEDb9Wex0bu/nvbOKx+HNgSv0NpHY7eSa4ty/ZK64IaDl4hkoBW7zi6X0r1VNoPxMR+iGRdtKSORHHHxxhjCv4LDMckjwWQYv74ldnH9845q8Rtg9/Ke402dceUYOUR6yI95RE6sVIvxPDu8fSc2LjV1JU2mjkyJ0yLhUTfhMnO6g4iEubdJa6D5OwBdfVUZ0/1VFuaVShyXlBVVURGJL/u3MJMIr9EwHsOyHlAZBLWzPIe4x4oirFNy+eQ6nuSFLdRH4OOWpOZbXePyqIMbc/XwxK1XRknuM68DMe9CoDNCI4PjWRAIs7J0x9f68keYXZ23FmlOTp1jNPeOSaFSes/R6CuCwVGtwyAHu3GjYL7PfH8Ekjy1O+NI7SvPux9VUSWqbMaOs2QLOpbVqJ6EXLgPyX7MbUE+eHJwYvepTA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(39860400002)(396003)(451199018)(40470700004)(36840700001)(46966006)(40460700003)(336012)(186003)(8676002)(7636003)(2906002)(54906003)(5660300002)(316002)(356005)(36860700001)(8936002)(82740400003)(70586007)(41300700001)(4326008)(6916009)(70206006)(426003)(83380400001)(36756003)(1076003)(40480700001)(26005)(86362001)(82310400005)(47076005)(6666004)(107886003)(478600001)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 16:12:02.4365
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e782745b-58f5-4d8f-a865-08db046f0e01
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT003.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5910
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

