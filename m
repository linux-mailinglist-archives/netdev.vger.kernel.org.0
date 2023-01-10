Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73646641EE
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 14:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238569AbjAJNcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 08:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238476AbjAJNbk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 08:31:40 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2079.outbound.protection.outlook.com [40.107.102.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2403C389;
        Tue, 10 Jan 2023 05:31:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OM4I6CuBuBtZYnwdt1tJ6flb2JJ4WyfsBvq5KyraWiMY3ecTUd9LP1ZTQr87cNQvbKryXpPqfVoGzKxnZxwt0Fn+ZEtneiR4IQGd7GI8ombAK4T9LFFwTvXEzNLqyPSRvRwJGkclWfx0DDenEltRM5woykax3c/StK2N32I+QLeOtPNofa1+vod7DNdMa7BebdAM3khzfnwERRGe9cpRFE5/cjzjniIyfcvmq3qqW+8jSzR6SeGI0bWs/KFUmN994Vzvu0Xma3RDTqdiVhRt3uNcL5L1AR/CxuRJK2TauJH/+/gRJ88Ey/8LAomGDxQuBwo9bQ9aZ+BBwFBiRab95g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l5RYK0xo9itxoG503Cnp98JnmWqNNzPa/9Mi27YLsp0=;
 b=B6fFhzM57H7vj0XaaInInZUbuRnhXuiTplLunjbU5VLI59LIaZ5+R0Iml5P+5V+WO/AQJjPqauE78WRnC6blKpe7vvK+DPzop9cJKRI+zgl2lk2BRbYuNLdP6gd/W3aKNatQWXqG3B1qp7Alfar4TCgH92Jm4kp+VmP0m51k7LDl8Urw8fdflefQ7U5ejD9pM0KxkguJOg3J5tzuA8f0Vwt4f42mApPoh4+ihhcloYeBDUJPKkr+3oUJCML/kOcPcZe2vA2yrMDEcYCs/nvANNi+dti4+7jbWiuNy39ydo1SZ5Ew8jmcLUgtfw+jajpisVKZsGb8eCpX79C5pFAKKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l5RYK0xo9itxoG503Cnp98JnmWqNNzPa/9Mi27YLsp0=;
 b=TVxJqCH63A9zCYhh9oUcveSK2ZD40Bik3ShG+EYLoy6j7EddLD6AhXvDja271lwYhtWoND/yYRzJXgF7Xs1T8m1G+VkxoSRfLyjz/zgn6j/TyhrK8dRVkQyI9QYK2esUnMCF+lpkw34W10NZHthc0bKOrGuTKWXsf6mvkY4a+aQ7CkYylfSPdMDH1WHYNHL6LkWN2lSg+eP69c3U1pP1x5t/Qy8sM5VBptfyXFr4hEt7v3W434X4BoTyzIlG7s3r3NqtzUZK58QRJkMTT/5K3O/4QhPn/0V6xc8buekjWwAe/+IHurBMFOQTCWExx5VBs4HZSkfjV5O2R3LbWyNZRQ==
Received: from DM6PR12CA0026.namprd12.prod.outlook.com (2603:10b6:5:1c0::39)
 by CH2PR12MB4056.namprd12.prod.outlook.com (2603:10b6:610:a5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 13:31:35 +0000
Received: from DM6NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::68) by DM6PR12CA0026.outlook.office365.com
 (2603:10b6:5:1c0::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Tue, 10 Jan 2023 13:31:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT078.mail.protection.outlook.com (10.13.173.183) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5966.17 via Frontend Transport; Tue, 10 Jan 2023 13:31:34 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 10 Jan
 2023 05:31:17 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 10 Jan
 2023 05:31:16 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Tue, 10 Jan
 2023 05:31:13 -0800
From:   Vlad Buslov <vladbu@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <pablo@netfilter.org>
CC:     <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <ozsh@nvidia.com>, <marcelo.leitner@gmail.com>,
        <simon.horman@corigine.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v1 5/7] net/sched: act_ct: set ctinfo in meta action depending on ct state
Date:   Tue, 10 Jan 2023 14:30:21 +0100
Message-ID: <20230110133023.2366381-6-vladbu@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230110133023.2366381-1-vladbu@nvidia.com>
References: <20230110133023.2366381-1-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT078:EE_|CH2PR12MB4056:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bab28d9-4680-4f36-8e41-08daf30efe73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XQF5tM9zuhRo2LUoUaG6Z4Ew1ZL5ZLmuwb70C2Igom/scc6xZYd4e0Y8e/SuUfjrQKOmWbyEvpC4Fhv9iNKlBr/7EDYEpDOWtF4rCJU+i3Wqri4NhuaWa4s+fpYVKx1S3F6wSKxQpWZ6Ii+f/FyT8AslEOk5jU/y3JDvdCdSKO/zyv/6oy2J0oojjf/Y4fOXX0y9VE6Q0LxVTyTlXYxfO2PdO3L3WSKEGiWJHXHJ24pgZdkhuUosOC/ufgHZXpc/SJcpFeHWF9dalk9fxDaWemnxroGquoNbjvXeMGrArl3uxQ0irHtwe8RjNkxP5wjy6+FUJbJvR8x9f2JPpDJy426zx9R4gRNIv7G0XjYmqrVTS+Y8MhD+6ypawgdvplCMEnXuPXaLt6Vtg25HzVPTkm8I1t6uYRKbkTs8MAUE5irksPja/fTYQaFNzTvrA8i09pfHP90AQ6/zE3lyu/9vHqeotvhcTW3Aq+wOWPglyfwUaLs/AU3TXWGklgSYaLn9me4i2mVhJZ/i8a7ZEmHcWfwDEIGrlEsWw3o3OQ/cp+OXpnng8N0/y5NLuOeDBYtqE/Gq+5OP4f6h6US6XJZkpy66kKafqJBZcGY3frjFFP/Y82Hnad5G3Z8RxRnzSMTmnS6VUNEwMu+V4PizsMw7iBFKtHKM+daJS2dBGw8pQEb1K3P4uiQGS8SNeGQysAklxou082PbZW5oSs/b//FFfNIiCYcGsWTkE8H3bnI7rwE=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(376002)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(1076003)(5660300002)(316002)(7416002)(7696005)(186003)(26005)(478600001)(40480700001)(2616005)(70586007)(40460700003)(426003)(47076005)(41300700001)(4326008)(54906003)(336012)(110136005)(70206006)(8676002)(82310400005)(8936002)(36756003)(86362001)(83380400001)(107886003)(6666004)(36860700001)(82740400003)(2906002)(356005)(7636003)(2101003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 13:31:34.8861
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bab28d9-4680-4f36-8e41-08daf30efe73
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4056
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently tcf_ct_flow_table_add_action_meta() function assumes that only
established connections can be offloaded and always sets ctinfo to either
IP_CT_ESTABLISHED or IP_CT_ESTABLISHED_REPLY strictly based on direction
without checking actual connection state. To enable UDP NEW connection
offload set the ctinfo and metadata cookie based on ct->status value.

Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
---
 net/sched/act_ct.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 515577f913a3..bfddb462d2bc 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -182,8 +182,11 @@ static void tcf_ct_flow_table_add_action_meta(struct nf_conn *ct,
 #if IS_ENABLED(CONFIG_NF_CONNTRACK_MARK)
 	entry->ct_metadata.mark = READ_ONCE(ct->mark);
 #endif
-	ctinfo = dir == IP_CT_DIR_ORIGINAL ? IP_CT_ESTABLISHED :
-					     IP_CT_ESTABLISHED_REPLY;
+	if (dir == IP_CT_DIR_ORIGINAL)
+		ctinfo = test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
+			IP_CT_ESTABLISHED : IP_CT_NEW;
+	else
+		ctinfo = IP_CT_ESTABLISHED_REPLY;
 	/* aligns with the CT reference on the SKB nf_ct_set */
 	entry->ct_metadata.cookie = (unsigned long)ct | ctinfo;
 	entry->ct_metadata.orig_dir = dir == IP_CT_DIR_ORIGINAL;
-- 
2.38.1

