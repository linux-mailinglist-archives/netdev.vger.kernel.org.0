Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7586169871C
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 22:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbjBOVLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 16:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjBOVKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 16:10:55 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7D31730
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 13:10:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvnw0ujlT4OB2FPLJQS74cvjjfX5iHntxJW0zMQkjiP5zbuVzX3+Mynlv3ubMb0wUs9pxmV+I4RVDonWAY0XY/+WZv5wqVEyTAuEPGbQq4kXwwxaOLpugH3uqvL/FEsVfeEk6CAqIfjpHAUHnwRBgV7AnxC4ds604PF/ZgR3oFNgkWjonkOpEsuu2rZfAy7w1TmvZtnf3hnKdVTY7tIivqvWrupTUBwltAId9P/yhPL8O8c55tECHRawvezLA71Ugzu69B2BC9jfTVcZSBVdo2HvNZSHxU7poyf4cP7hfbUX8SZiULaRm6opDWXsKpCFX5syG3Glx64fwUu/zhSkMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jmP2EyeAu1+YUmH1maRZuYA4RaV0Dqpvh4+zpES8ORI=;
 b=JzC/24NatiffAegkzqy9szkJKj6Shlj1Zk/F2t5Kf7e5w/7leTpxemfAYyheiTeUSHn4HNoWBFQbgCmm+eq/lwmFwcI1t+sOg5NWRraRcctYwHrhsDl+u5elHeeVr9Nk5+p5oBtdakh1F3k1rUqKY9uBG9+EeE0w0f7pDpF412fH0SgLyvnRnLdmdQ6jDpOAgo0uk7bKVGcTEGpC+LJI/I2Wpw5LyiB8qMCW43GeMHdZ8sdE4Tz/9xeXZTlNyzQzbddB5cc/qlI8eKbvBZX6QgWC7+Ht//T/F9Sll5WFmfL00XW/nAELWKSC8rweNzc1P97icar6XcEDRNvL6YM/IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jmP2EyeAu1+YUmH1maRZuYA4RaV0Dqpvh4+zpES8ORI=;
 b=gXRLoWyKS2WkDJ6hI0DLgQBbvlnzrG2/ouW79ahRZmVWMnmKEPo6Knt9VxE+6bsuJDEFPE0NuNrO5irkUalEp/pv3CxVOoYpf1eX1rCZmUhQomYJa3TcJmQOdmzalmvARa+DlQsjyxL43EhHxDlawsZtT09L9RSP+ZSNYk/eLCOmUihuhCeU0+qKnoG5GKs6mB/glt8S/DQdtp8lDFyfjF+kasYLwN/NWkP8PpnUsHjxBWqVI1NyGGANimuaau2S5AqC2T61tca8WlgbpAy6fVFnAWvs9PvvOVDuFWo1f3h3l83NcFTG2J8ObHQ7JLHjWo9/Rk9u1+EX9Dtl/WSrZw==
Received: from MW4PR03CA0013.namprd03.prod.outlook.com (2603:10b6:303:8f::18)
 by BY5PR12MB4920.namprd12.prod.outlook.com (2603:10b6:a03:1d3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 21:10:48 +0000
Received: from CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::52) by MW4PR03CA0013.outlook.office365.com
 (2603:10b6:303:8f::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Wed, 15 Feb 2023 21:10:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT059.mail.protection.outlook.com (10.13.174.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.12 via Frontend Transport; Wed, 15 Feb 2023 21:10:48 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 13:10:37 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 13:10:36 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Wed, 15 Feb 2023 13:10:33 -0800
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
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next v12 4/8] net/sched: flower: Support hardware miss to tc action
Date:   Wed, 15 Feb 2023 23:10:10 +0200
Message-ID: <20230215211014.6485-5-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230215211014.6485-1-paulb@nvidia.com>
References: <20230215211014.6485-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT059:EE_|BY5PR12MB4920:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fa917df-3786-4a99-cbe1-08db0f991c94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VCYXWZ5PSGI3liDYcGXuDPRjci1SIpUlS+lxODt/2OlvLUVsacpRPUqbJ8Rt7bYEeDebz2s/t1mIIJN6KJRhjOE9O69d/CJBsQqiDsCkMlag+5PHl4vlmXI1Ya8NPcLiLF+eY201rDNQZLpqSH/Aj3DIfxGsNfssg3pJPpM+srRuTf8dcamXY0GBkAABiDN4Axaz9mwu5edt5xmMgszlb5abLOcXRvGB5zzZndUv//meAZKtK8Zf+llFPqVvspiYP9nVJJchf9Y7fWqpwdRA7YPmCHBtQ41K1T2KRiQBxVMtSaRSMApe/t5T18V5qj80vr0p6Bzu9mxjy8aZfksjwQPNVKcfJF0KQQKtkAblSQlkiC/2Iyus80S8VKbFwapTGz+9cYeTREMJ09OA/WnswQLMHvWqgIqz4nSvMLeN7HnS8UmZA8HykUTle6KQqJj5sSLRfgzmS8VbtUgv7mpU5ZMSuUUDbp7QfgpzNxYN/lJAkF/NQB82u8zDaqpQ1GvBzniMqgQjJ9q0tWDPP6Thtv3b5FkZ/zaJ5klHD/y9vGwoFtSiVatmDiVjMBaGFsyz2sYx/CD8/FrpZfZoxgF3RGK12G86uqM6K3oc+T7m4teaE9+0RrZBIdRpK7Zje8FI7arhVC/re5djQSlQLX1i+rIXBLuh/rulHPDkt3vwidjHH7scVCT3A9eapHo4vny/4s6LOvK1CN64G+lS6hZ5jxhGoEmFIvH/6gQyJxS3vAE=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(376002)(346002)(396003)(451199018)(40470700004)(46966006)(36840700001)(36860700001)(7636003)(2906002)(82310400005)(47076005)(83380400001)(336012)(82740400003)(426003)(2616005)(478600001)(86362001)(36756003)(356005)(5660300002)(186003)(41300700001)(70586007)(6666004)(4326008)(54906003)(110136005)(1076003)(70206006)(40460700003)(316002)(26005)(8936002)(921005)(8676002)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 21:10:48.5889
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fa917df-3786-4a99-cbe1-08db0f991c94
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4920
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

