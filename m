Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D7A67B600
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 16:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235383AbjAYPdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 10:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235777AbjAYPc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 10:32:56 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2080.outbound.protection.outlook.com [40.107.243.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7EC8552A1
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 07:32:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZGCqjtuHGYCF83ca6sPlnR2OTDBB9bYwoEcHnNC6NuoSht7fzOF9GgbPG/+46XNppdok/SwbdZK3qU31kcNL41RdAGCUeLAjTa+kjEQxxdqyPGdJqLJDyv0K/frkAp8CPo8N+s26byOoWUZZdHPnaPZxQP55kfJaO8Ko4voTr93fidm7hyrZ+ST7LAWIekRB/n/uO/tQ9X5MvVetWsLfDypUMAAPSdamFHY+z5nr3/1ePWX0qS6QBOi4FPr9DHz+ZYZv7U0HlsQZckoB7bSwjS68nq3TU5tKOhPHHK3nWP3TMJddCxSpakeDGZ6XGOR9v8byOmCl0E5rjp0vPBgL+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AHeXaxLY1ixcPkNYbDwuhF+Bw4U1jULm6SuLjh81sR8=;
 b=GvKOgOIbuyyFIEgExqwateCrWDqBWCG9swgYiDtBAZcPS6vvKO6oy5Y5gB2g8Nhdx2M/pCbPTw6Xo1RWUR0sP1a1UFnx1sgLG75cQ9KWXTPh3ZnXCMafzUcSBJipS8BXvaaYy+dPfX7aO1N0gmblybW1LI4SNajJazW7hMxOIh0DfiWtWp+yhNFrDsFUd5GBjBz0SGO70LN9hQV0agLslw0OaT8cd5hYBtsuHmMsqqq6AGdeEjL451Ns5z7XYYlYexuNPH6uqaFQkhBdYjXCVTaDpv1RsK6orLoGzEkH5NNHjzy6yjQ67IIsugRdq/7Y/uEib2ucm52PHF+MaaINJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AHeXaxLY1ixcPkNYbDwuhF+Bw4U1jULm6SuLjh81sR8=;
 b=scOiitoN2Yu3KI0B2UpXOxTbxeQi+LvRECuOyBeNGY4nof5C+oT+pZUANP26qI64T4XgybSftWjZPdC9/YjKR+CXEv/JGLj3UjtFEwUX2MvXazv/Y2yixRv9+S0pynCFiMfq0rPRKUm2LdGwIQBdusGs801uJnhG3VyfYP5LCEXyYJu5AEjEA91EGgBiOFPpmL9Kb/eXl4Hsn8JFH35lsy59aGUItksFkjajfXMd6ozZDLenjxaBKRMaLJMcpDVo+RAtDXrhbEnP3XFnqQVwVevulSrb7UZFy321emwnjltAa8h1KrWtk0URJ/oCem5fOJnkh/wPmMQwwDbcw9NcZQ==
Received: from BN8PR07CA0019.namprd07.prod.outlook.com (2603:10b6:408:ac::32)
 by SN7PR12MB7909.namprd12.prod.outlook.com (2603:10b6:806:340::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 15:32:52 +0000
Received: from BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ac:cafe::aa) by BN8PR07CA0019.outlook.office365.com
 (2603:10b6:408:ac::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.21 via Frontend
 Transport; Wed, 25 Jan 2023 15:32:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT056.mail.protection.outlook.com (10.13.177.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.21 via Frontend Transport; Wed, 25 Jan 2023 15:32:51 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 25 Jan
 2023 07:32:38 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 25 Jan
 2023 07:32:37 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Wed, 25 Jan 2023 07:32:34 -0800
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
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v5 3/6] net/sched: flower: Support hardware miss to tc action
Date:   Wed, 25 Jan 2023 17:32:15 +0200
Message-ID: <20230125153218.7230-4-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230125153218.7230-1-paulb@nvidia.com>
References: <20230125153218.7230-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT056:EE_|SN7PR12MB7909:EE_
X-MS-Office365-Filtering-Correlation-Id: f3297c72-049e-4224-cb05-08dafee96bcb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F/wc18Sy8+YVMYPgkKO8+V6y12O5vcrMV8qXZ2S7aYeOUigCpSB/oj3lLktC6bGFKfWRqTinFkmI5VFwZYoFtLqucQA9pxs8cJZZCHt5M1mnOM9XbzDL67AxyCpdP07jt1Y2rJsvVqGbYKE/cuerxOpcuZA5IcV11szT8e7kxLH3quV6vtKyOCk/oAhRS1qWEg7qM/FQRlGqnIKsJlRa8ii4KGNWzWRmR9BgRcIAWqlnS498Yxsm/oJhza0J1l2UlSWxaTFEcalqCl8boUmDOOOOKdzaRIOxWiKXT7idq8D/XrhUDv20vgdqCvyi1bcUn/48UsEZzZYJ4YIpfi/3UayFYC7UQwwBcIZ6alxXZHbgI8kawMU+EjiKps9lqACr1/7NR0UCvEDs1OvSTlJNRP2FlhXCLpTOg8axzwLW5dDcXOt24kDk2VCdYLI8vJuN0o7I9NCAJ644dWOvrLGfyKol9xEArg2FSc4uW+7f4DT88UGhtkl5m6wZtKeX5J7Srws9MKVma5wpCCI/3nkbdkruJ+1Fn96AMDOLsWAddcCwlw2BvndzjRnMoKgO3W9s4M5af7kIRw4iMzDtSM41vOzK2lpRT9IQBvY8FXU4+nP4yPUXtbqsgIg78fEpGFTglQPrpgrXPJDp3EKKpM3Z52UJehdjYsnE3QnBAgn1wpwS8iKSBXaDvxhDySOt27pJD6FKL87dCAEjpKgkBTk9qA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(346002)(376002)(451199018)(36840700001)(46966006)(40470700004)(70586007)(7636003)(40480700001)(36756003)(40460700003)(82740400003)(110136005)(478600001)(8676002)(316002)(336012)(2906002)(70206006)(4326008)(2616005)(426003)(47076005)(356005)(54906003)(41300700001)(86362001)(8936002)(1076003)(82310400005)(36860700001)(83380400001)(186003)(6666004)(5660300002)(107886003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 15:32:51.3668
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3297c72-049e-4224-cb05-08dafee96bcb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7909
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

