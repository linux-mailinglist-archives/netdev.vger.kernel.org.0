Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2931D67FE1C
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 11:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbjA2KQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 05:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234711AbjA2KQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 05:16:35 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2080.outbound.protection.outlook.com [40.107.220.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 031D6233D6
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 02:16:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IEeXtejGJ1/GqKyyvABJ0OTZDuEEH3rKs4Z6n+q1DSVJQCFEtkIdqZazVQpS/C6VPkfKIVFYhDFhB65i8BocidmUEQhQk7MkERSky9NLCKkKxQSW2gtR5n/2pl+VR045rySLAlOkjQ++hCsGsgqa/RVtC6cigLUQHxQ610uGQyJJPXNnDJYXDvip7HC78HpCL9RrtfsyjA5L929mC/BU7JWoPrDRlUFXRrhNVnfgwm6yrdfsrSsNWDIXXIJ5bzL0m/Avr2smPU7cjtp1yg8BB6xoPbWjBj8YCQICJOQN9RKdMDBkfNzg83ukzlHI6iHdvoEB/1FYS+KlYAA6I97MZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M5aVdv9M7mx6xYyOjHlCZSE0rTzZK1jKC5eewkPVy5A=;
 b=XZuqQCw9fNKtIy30fO/tms11TensOkNt6uLaoqZJlZhmmQKEtXnb2FKm7Y/FhTC/xiI7IHj70DCKULyCCkypwWID+bLpym6oNYxfwwn50FmIFYU4d36TCQd5KWDPgGfTdOGh0vy/msoZ1upM0CxZoxE2MC50SdR/2jzAj8E6xHmmsFTfh0SuWDPdxvNzh6iUcfIr21lt/bw+z2EJSX7Yja+Bqqgk+ogp2iFOd5alXPMVhcc+74GJ6B3tv4D8dfmWQPp54rGjIeGrpHaJZHyfA+bQXU/7wUsJutV6v9JgVXAA5F0/TiJEHzUnRk/YXTDz6VAqwVpihwo/HXtVSfxijA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M5aVdv9M7mx6xYyOjHlCZSE0rTzZK1jKC5eewkPVy5A=;
 b=GXtt+l+HPPBzHwhNcSrEdMlxDGe3PcxSclHPOG9IRtH1QB4YYmz+Q4jjrOldmf3DCWGgMz2qKSE8CvVxDRDkPIBYWn24M8vPMLHbRAMSTuM2XAT4Wcfs9Mj8iGqtnkcRwNDxi8TAmvbOFXJDxeiIQlXAPGvXxzZhg8Syd/bjqoFpokkAzUgoRrh/uvh3qgomdMG3IZfvzr+oAxSpSi+O6ucn3QHzCSRh3lVGlwFgAbTOpQ4/ARD05R4LQ47ejFr1fn/UYUvHVH8d+2/PMcfkvlXz5RIljhvY/UhJgQG6ewpdilvWRccRtpDH3wh24vRcJr5EcoEejSeC7LHZy3QFuQ==
Received: from DS7PR07CA0020.namprd07.prod.outlook.com (2603:10b6:5:3af::12)
 by IA1PR12MB7520.namprd12.prod.outlook.com (2603:10b6:208:42f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.30; Sun, 29 Jan
 2023 10:16:31 +0000
Received: from DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3af:cafe::3f) by DS7PR07CA0020.outlook.office365.com
 (2603:10b6:5:3af::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33 via Frontend
 Transport; Sun, 29 Jan 2023 10:16:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT025.mail.protection.outlook.com (10.13.172.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21 via Frontend Transport; Sun, 29 Jan 2023 10:16:30 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 29 Jan
 2023 02:16:29 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 29 Jan 2023 02:16:29 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Sun, 29 Jan 2023 02:16:26 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v6 3/6] net/sched: flower: Support hardware miss to tc action
Date:   Sun, 29 Jan 2023 12:16:10 +0200
Message-ID: <20230129101613.17201-4-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230129101613.17201-1-paulb@nvidia.com>
References: <20230129101613.17201-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT025:EE_|IA1PR12MB7520:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d75b88f-817c-4293-0a88-08db01e1e430
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LZfOoPb5PboAXLl1RIHEv4IbGjOioIi/R1BxeZjJz5nipuT9tLYgf0mPr8SiO5ZP2LD7YiVBzeNSxWzcWkW5GuapqWBJ3VmP4fduPyAAwZQsWLQNKw+IFQe1xhPym9FyINy8v2AhiEj9eVeFJbSoZNZw5RPsJFPRe6FbhJEc8beM2GDHgZ3yaXvwNtAgIorqEbEjUIoECyF3y7GjRwCH/gvtRc7GsPr4i1fTkbaJ++8QlSxBfOtyj2e2o9C0UBAPAh8aloPMbPetmkUmsbi0H0riuMVYtG6GaNujSRokrZqAeOUDG047jrMKpKKU5aFTJe1zjyoS3muefHcLbnpsLcbvsqQd7bM+Ae9mw5KkQaUc6bG0Ho6c3MtLG6eBy9SUdOYT2fR5rN9iw7zSK+OSfHRmyE7D6Nq8vGL14LWCL6LadQ5YZsiKZblUO0A0IcuhfjCFipzKtqxIkTACbSU4Rl9flruauEOt598VGrjf8L/hlASFvllHFuk8JqAqx9UUBwv893Jq1ksCNPrhkmBXqEDy1m3d0GF3UR0xYgUdBAh5Gx9sX4pQrxHoGcB9C5LqTWAg9GGVINe8Tzmh9TbyzCGeSpbWzBOVD0KGMYrwyT/msM0ipUss7BO3r5R9oM4mXOC9aubSuB6fQWXeNXvEJnn6YxT+l2Edt+g1Z6/ezkBo1USB//NChY1syA6INrXWemTr18jkxafQ5LATTe6pog==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(136003)(39860400002)(396003)(451199018)(40470700004)(36840700001)(46966006)(8676002)(6666004)(4326008)(82310400005)(70206006)(70586007)(1076003)(82740400003)(7636003)(47076005)(426003)(478600001)(186003)(26005)(41300700001)(356005)(2616005)(36756003)(40460700003)(40480700001)(36860700001)(8936002)(336012)(5660300002)(316002)(83380400001)(2906002)(110136005)(86362001)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2023 10:16:30.9274
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d75b88f-817c-4293-0a88-08db01e1e430
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7520
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support hardware miss to tc action in actions on the flower
classifier, implement the required getting of filter actions,
and setup filter exts (actions) miss by giving it the filter's
handle and actions.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 net/sched/cls_flower.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 564b862870c7..5da7f6d02e5d 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -534,6 +534,15 @@ static struct cls_fl_filter *__fl_get(struct cls_fl_head *head, u32 handle)
 	return f;
 }
 
+static struct tcf_exts *fl_get_exts(const struct tcf_proto *tp, u32 handle)
+{
+	struct cls_fl_head *head = rcu_dereference_bh(tp->root);
+	struct cls_fl_filter *f;
+
+	f = idr_find(&head->handle_idr, handle);
+	return f ? &f->exts : NULL;
+}
+
 static int __fl_delete(struct tcf_proto *tp, struct cls_fl_filter *f,
 		       bool *last, bool rtnl_held,
 		       struct netlink_ext_ack *extack)
@@ -2227,7 +2236,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	}
 	fnew->handle = handle;
 
-	err = tcf_exts_init(&fnew->exts, net, TCA_FLOWER_ACT, 0);
+	err = tcf_exts_init_ex(&fnew->exts, net, TCA_FLOWER_ACT, 0, tp, handle,
+			       !tc_skip_hw(fnew->flags));
 	if (err < 0)
 		goto errout_idr;
 
@@ -3449,6 +3459,7 @@ static struct tcf_proto_ops cls_fl_ops __read_mostly = {
 	.tmplt_create	= fl_tmplt_create,
 	.tmplt_destroy	= fl_tmplt_destroy,
 	.tmplt_dump	= fl_tmplt_dump,
+	.get_exts	= fl_get_exts,
 	.owner		= THIS_MODULE,
 	.flags		= TCF_PROTO_OPS_DOIT_UNLOCKED,
 };
-- 
2.30.1

