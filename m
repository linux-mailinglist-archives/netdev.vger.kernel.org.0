Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49C2368BF27
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 15:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjBFOBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 09:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbjBFOBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 09:01:09 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D427F28211
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 06:00:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U5L5IrvXtDs2rjPir7zVpRvFsrb/Yk/kmqZhhjfeHjOyupUdQGhfJhP9RWAiK0OAMrsgBjscveJzxm3bGw4HcUqHmMeT6ZNU4mPZ1FILr8nSwXkOWdESArr4eMlZCFW6PQ4y7+HA5QdGDOZxyaslGA8lkrgjmNIp2XorNldSWeRR94rFBlTBa8wZNtCN9DCdND3ptqCCNonDBQKfP9Hc4kY+f69MP/tZD5RUVqSLgv7hwmoFsUC/6CswxQVkZ6iV80ChtJMFtSJ5Jalh0M2n3e1/q2egP3ZF5IQLytCkcyR4b/pALU8qGS32lVHQemeMJAWtq8al7jq3DHhhWfRM0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bMfHc5isviPAq4o9ckZeUYS1gFA00N0SeOsvV31q0tU=;
 b=k2KDoMxWhUDpuvPX4iH6mZRs/qvqbFowUKsve6h6VR/DuWsaKH+xn9OxOXHAJIxE2zP7yu7W+mbdM89sRq8mOIDS6rbKrbKxZNyae/9hgDpQMkElB6pNNhqZieUllzmzrW0U9tQURAPMkca9xA5Of3pD2sKPw3dZdeZqJDsec3hdI8JVRiF73UIDa7Q/AwQcnjrrmBxy/0TuSYA52dA4upJYkjQecUTBlqiEmDXpsBri1Dqp7WuKTpPMTrNczGj3d3/aMzUJmhwelkkaqBZH1lvltzCa8YbbQkrcTKM1l1zD5RX4N3eyAihTSRzjGUfFa049j0/4IyhrH8SB+OedUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMfHc5isviPAq4o9ckZeUYS1gFA00N0SeOsvV31q0tU=;
 b=nzF6mloggv/yJLrwyYjW7G+3fx0P6auXfAYjWjUML+ypVD/SFNd3eJ6CxIe5l/OYnhWoo43hBD2fG22MvKe0XL4FDBPnHTkSmz2JR0UMU2bWBx2uaYBMKw9djjT9BVM5AJDKnN5MjODee5AnkxsBRJoMRb8iwSaAqRp3jeaZygU+EU1pQ+jM+Th60nuVssDvHx6EEInbOHZhsw6+xj2MBlLPy57QgB7NINqemNHO9AT+O6I/NglGevC7oRwYQRTX/oieLz8yDlnpl/t30+HXD1vbOZBzWi3Hbj7TJwoGFPaKzWasC5/ylQoV+nDP7kCYzcR2RYNAFgzEpXrQXVncPQ==
Received: from DM6PR01CA0008.prod.exchangelabs.com (2603:10b6:5:296::13) by
 DM6PR12MB4925.namprd12.prod.outlook.com (2603:10b6:5:1b7::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34; Mon, 6 Feb 2023 14:00:36 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::a3) by DM6PR01CA0008.outlook.office365.com
 (2603:10b6:5:296::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Mon, 6 Feb 2023 14:00:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34 via Frontend Transport; Mon, 6 Feb 2023 14:00:35 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 06:00:22 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 6 Feb 2023 06:00:22 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Mon, 6 Feb 2023 06:00:20 -0800
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
Subject: [PATCH  net-next v3 6/9] net/mlx5e: TC, add hw counter to branching actions
Date:   Mon, 6 Feb 2023 15:54:39 +0200
Message-ID: <20230206135442.15671-7-ozsh@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230206135442.15671-1-ozsh@nvidia.com>
References: <20230206135442.15671-1-ozsh@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT049:EE_|DM6PR12MB4925:EE_
X-MS-Office365-Filtering-Correlation-Id: 563b10e7-5b6a-42b9-9c54-08db084a854f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TwRUkB9ftQI7NNH5SJR54JcrqZxfoWaVz5mpUlU/pAHc/aBWD3+BNg+HU6ulro66T3+A8+qIWOjzyaxrGG2CFNyczwM8Li8wakvCy8c1jEeVg6GJHq6cnPDOqIxzb48KPU6ovuO8VXZ6tybyEWLDTiM3MRhj3nYJRtbs/tB9d+igduGi/KSHgsRZJPvHFjyc3NEztumoSoefxyJG1/5iA6KntFUDYvC/FmzgXnfK0tR3/Pl5u1FVJweAVzKGz5uxTExSxkHE3l0EsOq7wW27Kmy5CZnqt8PVwyVfP3pX3KykY/TzVoW10PuXqDuVllvxdPOdRJYbouSM6Y5cJmERnOSV4lAOPkc2twm6p4aR6JaE/ETk2Xi2MV0JMFvWd54oHYgaiE6UGdHq5KWPHCve6/i81LlHkXAFxa/InMv45yRW48LOLeiZoRtZPBAjDMDdgmX8i1eWRia3o0lP9Ti2Iqp4gfOm0B7gDvvxtAtVvVvZW1OKg0ZhaPfuuUHTkJRrMXw5efaW6/HYHI20iwqmNiIRCyQCCazLHC/wZbIFCl+6Wp5kvp9XtEuJ3JA/AqfrU5TJ6pAG3R8/H8/ButXxOTAyaVKAilAlPomnYszcM4ZIyzNSsLIUTwzyzoroNFwDFaqBJxsFbki0fPCPJwJIi16ipIWTo13yXOnSxfMPq8IX9cm6HSYL+j3eqsItibOwoq2VwVyRvjgsB2AKVL04VQ==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(376002)(136003)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(336012)(70206006)(47076005)(40460700003)(426003)(82740400003)(7636003)(40480700001)(356005)(8936002)(41300700001)(36860700001)(6916009)(70586007)(4326008)(8676002)(2906002)(2616005)(1076003)(26005)(186003)(82310400005)(107886003)(316002)(54906003)(478600001)(6666004)(36756003)(86362001)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 14:00:35.8996
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 563b10e7-5b6a-42b9-9c54-08db084a854f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4925
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently a hw count action is appended to the last action of the action
list. However, a branching action may terminate the action list before
reaching the last action.

Append a count action to a branching action.
In the next patches, filters with branching actions will read this counter
when reporting stats per action.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 4e6f5caf8ab6..39f75f7d5c8b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3796,6 +3796,7 @@ bool mlx5e_same_hw_devs(struct mlx5e_priv *priv, struct mlx5e_priv *peer_priv)
 	INIT_LIST_HEAD(&attr2->list);
 	parse_attr->filter_dev = attr->parse_attr->filter_dev;
 	attr2->action = 0;
+	attr2->counter = NULL;
 	attr2->flags = 0;
 	attr2->parse_attr = parse_attr;
 	attr2->dest_chain = 0;
@@ -4095,6 +4096,10 @@ struct mlx5_flow_attr *
 		jump_state->jumping_attr = attr->branch_false;
 
 	jump_state->jump_count = jump_count;
+
+	/* branching action requires its own counter */
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_COUNT;
+
 	return 0;
 
 err_branch_false:
-- 
1.8.3.1

