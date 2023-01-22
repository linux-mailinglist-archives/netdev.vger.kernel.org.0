Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE4A676DD2
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 15:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjAVOzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 09:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjAVOzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 09:55:44 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906B51C30A
        for <netdev@vger.kernel.org>; Sun, 22 Jan 2023 06:55:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksU5OU3uoDoLB3Xmk6ksYKo5ffIrLro0460PA3HVDcIeQ9k0OxDIAwjlDXTiH13h5DctfRillqoTzz0YZYPMCZtVR63jDHkWK5bO4rjDCF/aoQEE9zyFRpM8iIDqskHDV+sAjAVmExRgv8VBXfnWfQSa5393uZRPIH0zRCItrvOrCHkI/3ZuvrpAVSlZQmKlXQz+HwVSLFCrCPVQMC6cOwXvNudrAq+IKVasM+DmyTg9XsiLNA96EAr/lmO9rhcbnwxHl5VdVIKtCz1tRSu8zEDvnUJzPTpu2tTRQ/QD/aYpJ1c/onB5eO1B+o7sO38eoXEq5Fd/hh7v4WiudYRo6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6pYP36BjI8tuK/TptL4gjxbDQq9indNGBjpoZwBV1lA=;
 b=oc43ddfsD8+HmZqVYFzhhRN94xbNXVJMpAaGD9I5g7jz3B5wMo81zfVudbvyxuWdjZhbY5DBVZ4WBXimgCdzl3Fq/UOKkadx2k6xB1c7lSaQsx3KUzo9eHWFqvAU3y1djpJdbty7mgGTBLNIgtNqeCHPIauZ7d3T2edzCBEfU315Z95fHPnGGk5M3N9ZPAzBHfBmP1lOCCwwpmrkxK+hlkNhkTo6vHy+GWlaxcj8pRGjTdW5+LT1JdAXTOGijKQVEo99651yoD4Bmycmp5PCt2Ebft3TOT+48Ytx1BRSjOLDeLqh0oRn1GaHnZt8QzBBS3D8sQ9JTR3L0LPjaDOp9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6pYP36BjI8tuK/TptL4gjxbDQq9indNGBjpoZwBV1lA=;
 b=Vr9bT+2bnhPrNbTRpWNYA2iF1LM6t3U9DjeH/pJmcv/6RG0VNT3a+OxgrGY79k6mIwM3mI9xMOYqDG5xsTIUUjk5BbW7ErFIaoYApS5p3ZZmTd9LdyAZMxBBSqii5siqJ04elEVSwrBpMeuoYDrkSYiUJwwyJGe575q9WYdqAO+TQV9f4rmAa3hTiJO0X4db44PxD30G2JZQC//N2FZemf7FzvNh7Vuuh0E8afrt37jKgTsFTg1YcARKQrwiCcBTByDrWpCJ1s2mRRUJAcEChiSzYMoimyYL/P2Nopk9Kgs3nBaXtedKHV0Bc8IR0pE6I+EuYNHCDmnM59pGYQ9Zyg==
Received: from MW4PR03CA0170.namprd03.prod.outlook.com (2603:10b6:303:8d::25)
 by SJ2PR12MB7865.namprd12.prod.outlook.com (2603:10b6:a03:4cc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Sun, 22 Jan
 2023 14:55:40 +0000
Received: from CO1NAM11FT108.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::28) by MW4PR03CA0170.outlook.office365.com
 (2603:10b6:303:8d::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.31 via Frontend
 Transport; Sun, 22 Jan 2023 14:55:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CO1NAM11FT108.mail.protection.outlook.com (10.13.175.226) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Sun, 22 Jan 2023 14:55:40 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 22 Jan
 2023 06:55:37 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 22 Jan 2023 06:55:36 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Sun, 22 Jan 2023 06:55:33 -0800
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
Subject: [PATCH net-next v4 3/6] net/sched: flower: Support hardware miss to tc action
Date:   Sun, 22 Jan 2023 16:55:09 +0200
Message-ID: <20230122145512.8920-4-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230122145512.8920-1-paulb@nvidia.com>
References: <20230122145512.8920-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT108:EE_|SJ2PR12MB7865:EE_
X-MS-Office365-Filtering-Correlation-Id: 4479a7a9-96af-410c-a113-08dafc88baad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ENUJZH/1tpcofhFUhgCpQLFeZR+BGTH9bMGidKVPaPwBRQQwZrzyWQHbpafzW7OO10THmHhNvhKccG+i3++KAhedkSE2UqDWxaoa/MHs9IDLPq+0XiADY3AeKfkNQ3X0m3hoAZNqiC8zH9uwGhU+23uisfMOBuhY28AOhrZcBbAhjso/3IBngfcXBlpbDSR2BjbuB6Pr8+4ql3j0GMpzCD3vaWK5/JyTKjciM5JTpTGUJlKrFgM0NNHunyPcnQN5VYhNMboBB1oAy7vZWwCdVZcPT8ucBrX1ueXnb8vTwwVKFHEpsTLflT0dHaxxb9i644ZqWkauQI3m/1RzuyeVE/PyebSDIydKu6voqGsyxBpmZ+o20/yBhVoxI5yoRbge60bbSjiDYjZ+vJFB3fE8NzI4ePu6sOf8tHhyTi4TPpSSftbK4du7IA+3M78s+EARjwuXGAJ5uRRD+I8ht4Cnb2MxACMA8R2TM5oITQR9bZXaS8OfJMgkrXzzK5mNZOi9npAlc+YZlxOKZei8As4oK7cGng9WEqOBHJtDyS/fxM9HadpJbvBt8zAgTQewy/X/ByjnHFHH00SOPbQIho6WDXfz5mbBSva35mYm4BXsEseVBIaaIHv4dSSeaWkd8f3qRc+PoGJlDQ9U7432H/sMc6hbgSi7/gksQfWRgc4UGIeR+EmRxzxcATjzXRoPMcADMLcrtqaZ8iLsfw25g/5Htw==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199015)(40470700004)(46966006)(36840700001)(7636003)(82740400003)(40460700003)(36756003)(40480700001)(356005)(82310400005)(86362001)(110136005)(478600001)(316002)(336012)(54906003)(8676002)(4326008)(70586007)(70206006)(426003)(47076005)(2616005)(2906002)(1076003)(36860700001)(83380400001)(26005)(107886003)(6666004)(5660300002)(41300700001)(186003)(8936002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2023 14:55:40.3101
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4479a7a9-96af-410c-a113-08dafc88baad
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT108.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7865
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
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
index 564b862870c71..5da7f6d02e5d0 100644
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

