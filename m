Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8CA5667085
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 12:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbjALLI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 06:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbjALLH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 06:07:56 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2064.outbound.protection.outlook.com [40.107.95.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879A5482A7
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 02:59:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bZW3jyLORh8ZSmAtGEwD1K/DfKzBGucdF1XcmhzVeRK2Z95PE6jW8DkwaiR87Ht+ZCIPG2KWhtE7JZtlTp7jfz863YnMClWm+BBPCcmmCEaeUGHZMrHnKaEBRV7emsFJ6ZZ13d52Wb2guaOzg/Sg8bDD+om5P3VQ9Cf4busEHowjuY/Bm1esJ/5Q0yIIxHhVUjDyHohQVKBZk/sflIKbRT5wWpfhuk08KKg2tv7zUdz1q6BMqkRzBfDUytJ1TSAKIz2Y2KWiuBNgcmTjsJ2TPrWbqZeettwBYX3nwV1EOd3XN0QbJ5HINTIn2C0T30iRPsI1g8J2hC+9T/WIX5ixDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yntnSlDeBZedWEfeAHF0iOvpxo1iH5hurKBUozia2qo=;
 b=n441G6Ymp7RA3VFQFxiBCzmyZhAgl+qDyFXnh3JjcELHlthO9xgX/L4BuBahvImziLoj6mA6FS49xOQirB4Q0D6cFcg78mE/CjW50Fy2wxqM+QCmLmWhkCQQEKLvuhBVcV9AB9aJMdDS74O1rtKG5S0Y1dE0ljZwtkG/cjGWVhCXEHTmj35Xr1kHOng1m+AqgG3/L/afxgtbhGdblZW32ggOCXWL7qaweZ6PJcHLeXi/GVu2cGF5TNSAzb8JkKA+CWbELxcFSbhcNYt6239XZc0AtAi90PBGKb/wvKjEyfCQHk5oljfEM2HYbsP+UGl1NQQ4+zEPUdpWlk6eKXrsPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yntnSlDeBZedWEfeAHF0iOvpxo1iH5hurKBUozia2qo=;
 b=Up345y16vtRPBQfGMsyIeeVId+YQ6vzd5br/RapsyMFk0WznrO91Cq28zdwWiSoz/EzWK5bsvGLTjpQyWVEXaFWTE81Pv5J5Rr8pAQSfJUzrlEVdcC9++G8f0HDwNj7fW6AWzNHpQgg2NRPFJsMMx4hooMspIedwcdrRYo/2RkROVnWq8TUiYC6KhiQnAwkjHr58xT91GgUwAG6VxCNBCCUB1eYENpsFXYUNfq94nKPRdM0yff+d6axzuEMq8OQCfjuvpW8es4Jyix7oANIGIw3OaCVQitpPeaJWs41VjqoaZHaZJ7yGh5Yvhi+bX1/yJmvf52y0hHmLb/eKATKtBQ==
Received: from BN1PR12CA0012.namprd12.prod.outlook.com (2603:10b6:408:e1::17)
 by DM6PR12MB4420.namprd12.prod.outlook.com (2603:10b6:5:2a7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 10:59:41 +0000
Received: from BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e1:cafe::5c) by BN1PR12CA0012.outlook.office365.com
 (2603:10b6:408:e1::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13 via Frontend
 Transport; Thu, 12 Jan 2023 10:59:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT051.mail.protection.outlook.com (10.13.177.66) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Thu, 12 Jan 2023 10:59:40 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 12 Jan
 2023 02:59:25 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 12 Jan
 2023 02:59:25 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Thu, 12 Jan 2023 02:59:21 -0800
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
Subject: [PATCH net-next 3/6] net/sched: flower: Support hardware miss to tc action
Date:   Thu, 12 Jan 2023 12:59:02 +0200
Message-ID: <20230112105905.1738-4-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230112105905.1738-1-paulb@nvidia.com>
References: <20230112105905.1738-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT051:EE_|DM6PR12MB4420:EE_
X-MS-Office365-Filtering-Correlation-Id: 884dde20-9106-461b-e395-08daf48c1a9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MtZV/+PcgR+E+MgW5U+EiDkg6HcIJh/bpq8kdmZZp8bCWsrtdd2mN2H0NKDLSoe20CTPFl0SAGNIIodPhRlC+62Dqzyji7TX9D/S4Wlnol0tMgJxVC8K0nVIy8+poXHv39bbJzu8UuJOvehpPO8D/cN3Yr5pC1Pj+GgwGsQqiQ04XBcvYa0IffDXatfQ50WZ5RtfRwSnG2WzxD6t2F76uXDpS1rWFLBz5zxIB+XwF66b1QhHtZldiIFXKQ7zaT50Xp//CxttJhcPSZvkZWiTndFhCEfnxwnuhVhYy6c4tzvIP5vw6QeO0ElEmF0ohtag+NUIj90hMK1xZrDULWf6FoHsWcponjvAKB/6qjp2i4k5ZF8DTnRGQ0fVSHEBpMyIGpSO+9irFkGAx4ZpltmbfpiJoPNB9r454pXa/Hug5JmUoUBBlU+qYaEUmtD4lBOqNbKcjpENWJdNkq8fnnUk37GVIJWidaBncHbeeRTf0xmzlAkPu3b9bG1yrGN945OkPoaK/mpjq9XJQ2015cSSzrHTQ0uSrdtNlmMln5bceNSExJepNjcR+6m7FrBxY5tNv6kSYrz8EuRT7FRG14tk/T+Qea2ebFE+o0e/OOy8IBn0yQlTNp/mc5N14NnLMQfcdP2+CCaAObOFYWShPLl51+DENxsgWE1xKg211cGZ4atMGdIhqL/OobWOj2eKcfBCkUDIlnhQ7xsHnHuxSu+3Ww==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(136003)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(70206006)(8936002)(5660300002)(70586007)(8676002)(4326008)(110136005)(2906002)(54906003)(316002)(478600001)(41300700001)(6666004)(107886003)(1076003)(186003)(356005)(336012)(426003)(47076005)(26005)(83380400001)(2616005)(82740400003)(40480700001)(40460700003)(86362001)(36756003)(7636003)(82310400005)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 10:59:40.3469
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 884dde20-9106-461b-e395-08daf48c1a9d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4420
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
index 99af1819bf546..c264d9136ed06 100644
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
@@ -2229,7 +2238,8 @@ static int fl_change(struct net *net, struct sk_buff *in_skb,
 	}
 	fnew->handle = handle;
 
-	err = tcf_exts_init(&fnew->exts, net, TCA_FLOWER_ACT, 0);
+	err = tcf_exts_init_ex(&fnew->exts, net, TCA_FLOWER_ACT, 0, tp, handle,
+			       !tc_skip_hw(fnew->flags));
 	if (err < 0)
 		goto errout_idr;
 
@@ -3451,6 +3461,7 @@ static struct tcf_proto_ops cls_fl_ops __read_mostly = {
 	.tmplt_create	= fl_tmplt_create,
 	.tmplt_destroy	= fl_tmplt_destroy,
 	.tmplt_dump	= fl_tmplt_dump,
+	.get_exts	= fl_get_exts,
 	.owner		= THIS_MODULE,
 	.flags		= TCF_PROTO_OPS_DOIT_UNLOCKED,
 };
-- 
2.30.1

