Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD3A69B59A
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 23:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjBQWhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 17:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjBQWg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 17:36:58 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5C71BAE1
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 14:36:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OoJUItxX1koBhadIsl/icaMy1rLpdiuE7s8yGysdAJccqOkxcY3lWnbUIRJ+lnMhrkLAAaZmB1kEPwyvpsliFIidW4pG0swHAZV7GGboZD0tGGp1/h0V4XH7Ik5cTDQV4h4KdAxKPLwGKDNm/kHZT9MUP9g7ZzzmPQNmpga1Gik63SYfZpCSTEQklnr5EimjGVTTaw3CwfBUdrHwj8nCbIbGfY3VKmxBGZXma5tB3ftUEfZtYyKNe4XgQpGNlQigVte3w5qK+llX1gYzCfAkLc7ZKLHY84XmkqGJV+n5aSRXTHSjMg/Wtcct8lVzrbBWE78C+W6AVyrfi6XvF/2/kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/8xM6nluJY/HKot+mX1BuQixv2MHGiXA1cXeyvDMOkk=;
 b=CcjW/pjXZ+zC3eRk9Cz6C3eXsfefHyr5wXUDrQJ7LZZGsp+9TRCaxdG/0g4wPfqQIi33GoA2Id6L4gZuj7AYQ0ay9BIl7wN8btQAgOhmJWg97Oql+PEhiX2LmLJERwaYZhNtuTviAW8gufiVmGremxABpVo0+iDSxgjQ5UXm9LuMO+Ef56n1JToyMBu1NIGs/u5zfK9o3M0ogkjOFq9e2ZvSb8APEz5qOqVQ2EjVfE98YPJsevBz0Vn8gttdzWRmUQaMxintNPrYBjQtU6+774BrCSM+MVFzm/3H8RG+Ev3O3OE43f/JiONIBjaTYWXd+7kKuNtovD/Wq1d1chboYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/8xM6nluJY/HKot+mX1BuQixv2MHGiXA1cXeyvDMOkk=;
 b=IXP/Ck1gWq0HaPMPzjhJTyYPLCND9Fs4lj4+2eJJuuysXRAmlAz9hs6mYXBygajZS7OFunSKzG7Ztsngqyy7NQh/iL3cdGKmObIY/Knt+bfJdbxsel8FgJG3KPr59wUkiE1EEyx1WgZizWGVO68gbqWVhRY9aeludTAB8CGrbTH9Y5QGH+xBj9tDTO3Bp/zJWk0AVj4vLhCRESIoF1n4+CAStzKFMQc8jqWFF9KGNeND6kPIsy/AMofEBsh7Fj3K4fXMVTDXeSFoSqTuGF5NwAxdf4+ZJSnPRrIm6jnkvSDCznfyAC1CN28cJRnj8CqK8aQdo7u5CtzTOJmORF05Og==
Received: from DM6PR02CA0100.namprd02.prod.outlook.com (2603:10b6:5:1f4::41)
 by DM6PR12MB4974.namprd12.prod.outlook.com (2603:10b6:5:1bb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15; Fri, 17 Feb
 2023 22:36:53 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::39) by DM6PR02CA0100.outlook.office365.com
 (2603:10b6:5:1f4::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.15 via Frontend
 Transport; Fri, 17 Feb 2023 22:36:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.17 via Frontend Transport; Fri, 17 Feb 2023 22:36:52 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 17 Feb
 2023 14:36:46 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 17 Feb
 2023 14:36:45 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Fri, 17 Feb 2023 14:36:41 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v13 4/8] net/sched: flower: Support hardware miss to tc action
Date:   Sat, 18 Feb 2023 00:36:16 +0200
Message-ID: <20230217223620.28508-5-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230217223620.28508-1-paulb@nvidia.com>
References: <20230217223620.28508-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT038:EE_|DM6PR12MB4974:EE_
X-MS-Office365-Filtering-Correlation-Id: feedc30c-1956-4269-8581-08db11377786
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vOTugIOBsMCboURehWD3Ed6guPto/ZJtJPzBmk2aQgQ2cMsvLPo/nGRZFkqHQmVmuGAw8M48xZ0uByXnHALu4TsSz7j61PiJ7NUY2B4C+xBLBvEdMkoe2+StF/fjqgipy4dFz/58otDL0jmEfwaHqkrRe/4m91DmJlftgcV7IyPEg0DGsT7Ects3PBLAG/dBCzQzTLBPHTh17g9Pzt3dgji4+k3RcRTQZN/yXhXKHEhBNUS3LQlmKGufdmsO15zbwryO6NmuKz13cg9c379W0Gw4Y+HZMYer0nTkCAIPriodwYxRxJlb3jw74qxBTKYOIl8NAcpJErI16rgrWF8oIIkn9JUrpfdWZn9wQh2cvfbVMniqhjDnkGD3YnHfbskAurENokYZDLK4WPDpE6VnBo+5rRJ9kRLM7JtBrtvOZ8d8vBOwypH6LM3lZv6hEvPgP74n7XmKTuH9+BAR2vEEOyi5pENBLGJT15ayctZlSl3HLoaQiUDtlMWTSQkv5rgY/vLZAlJszIoluN0t7CyP1aRbstq2NIS+pqPlz1Fne8/DZsomtlp/G4jYDiMpxCK8HYTGadZAWxPFjl9nZ4TvbZEMBC1SgNyAtTSVWe6lfVelR2+NYgSTU1ZX1/pV6YPDtBhqmNC9pGd4puvGAL7kwKXfE+mwfuMD2snxp9VI7NmOzXCtln3YOiaUSXQIJ/RoloO/XEuhn9xEZfN+lvUIm3HZNSo4xPDUiZetATyw7zw=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(396003)(376002)(39860400002)(451199018)(36840700001)(46966006)(40470700004)(2906002)(86362001)(82740400003)(36860700001)(7636003)(40460700003)(110136005)(47076005)(426003)(336012)(186003)(54906003)(26005)(478600001)(40480700001)(82310400005)(36756003)(921005)(356005)(8676002)(83380400001)(70206006)(70586007)(316002)(1076003)(6666004)(41300700001)(2616005)(8936002)(4326008)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 22:36:52.7672
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: feedc30c-1956-4269-8581-08db11377786
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4974
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 net/sched/cls_flower.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index be01d39dd7b9..e960a46b0520 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -529,6 +529,15 @@ static struct cls_fl_filter *__fl_get(struct cls_fl_head *head, u32 handle)
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
@@ -2222,7 +2231,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	}
 	fnew->handle = handle;
 
-	err = tcf_exts_init(&fnew->exts, net, TCA_FLOWER_ACT, 0);
+	err = tcf_exts_init_ex(&fnew->exts, net, TCA_FLOWER_ACT, 0, tp, handle,
+			       !tc_skip_hw(fnew->flags));
 	if (err < 0)
 		goto errout_idr;
 
@@ -3444,6 +3454,7 @@ static struct tcf_proto_ops cls_fl_ops __read_mostly = {
 	.tmplt_create	= fl_tmplt_create,
 	.tmplt_destroy	= fl_tmplt_destroy,
 	.tmplt_dump	= fl_tmplt_dump,
+	.get_exts	= fl_get_exts,
 	.owner		= THIS_MODULE,
 	.flags		= TCF_PROTO_OPS_DOIT_UNLOCKED,
 };
-- 
2.30.1

