Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFCB13584E6
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 15:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbhDHNkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 09:40:13 -0400
Received: from mail-mw2nam10on2066.outbound.protection.outlook.com ([40.107.94.66]:21857
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231724AbhDHNkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 09:40:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fHQIQOlEV2d7KqeVs4tZzHmBn4fwB7Pxa//M24AVTKy00Nqs894suPZVZ0BHH/A1D3h7gnFSkgU0JMAzJldv9cZndf3unKxH0wCBXyGLQpk5NTyxqsu9Pjh7ZmnDwjcNjWPjPluJKVHhSU+m3k8jrsO9uKKLPKnk4ueFnXEnzlth12Yd9zzRJiojVi8zft0DC8iLJQos+VzNS/rOQromwi6xUTcSk7QoAHEwO36FXLb4aZ1Du8A9B+Jf1BXKLsI901I4C1O8oddGmUaPGV7op1870WJaehVFRZ74qmpV9rVvQNrq9mPcNctGsMTmT3m88cc9nK4ZYZr5VOjbQy/edw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=la2R0eoUoRXLwKeFSIx6tOfIZefdkQrcWANFgkxO3J8=;
 b=PsPKcFHmWKptZ/TYUOgLdjMQQApg6JKKPy3s9FAb9mXY1YWS7499yjN7rjpJKk+ZG34Ov/eXWNZXmQK67eQCpTrDX9I1Iq4BKexvDNty8wqZ1pTRnetC9LtVKy6Ox1YCBjMpo0M98x/q1Yk50OCXdCydgLU5tpCI5Lz2+zQL4DMAQhp7/S8ikUYCCuPf2vSmNtebJV3A+y1ldj5IBW0jQN7isxCR4qrO1CmLYfIIY5P9vHVXBXu5anIZ6AxDn3bYgECT/ZwGENcwvPHrOjdhcRYyle6xakrhvmE3BqyJrEjm5mOr1chP/tADeDl+DmLde7XsUP7dG3NKegOyCVFzyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=la2R0eoUoRXLwKeFSIx6tOfIZefdkQrcWANFgkxO3J8=;
 b=ZyTcZt4CPEBb5ns7PH75lUOm57Yss0NFqGnqTX84a1A1Ps9p9aZs+iBkPxvdksh9lI7DQY9yQ0dIWFzYVca+uByIAwHLQ10hDUDkVDi/VLXzyB7nt5F/9qjs+GawXIEAvfd73jLSf+RsPGGgcEAJEWswx2o6jgpg5lPP9ApxILnpIsBXF1Xk+fdJlE76aexiGeucf7cDjaDIHK+TTX3SJscFtodeAHiJppPw5AxuuOo1OVHAH79wXh0p/7KKv6pe2Dx8P8AXrb9S9m1t7PhpQyEkbZkDaq4QlO/BRx65NNiNCaWH4Qrr2sPyB44nft2DapMRZBzoH91aNh72AMjsLQ==
Received: from BN9PR03CA0472.namprd03.prod.outlook.com (2603:10b6:408:139::27)
 by BN8PR12MB3426.namprd12.prod.outlook.com (2603:10b6:408:4a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Thu, 8 Apr
 2021 13:39:56 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:139:cafe::33) by BN9PR03CA0472.outlook.office365.com
 (2603:10b6:408:139::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend
 Transport; Thu, 8 Apr 2021 13:39:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 13:39:56 +0000
Received: from localhost.localdomain (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 8 Apr
 2021 13:39:53 +0000
From:   Petr Machata <petrm@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net-next 1/7] net: sched: Add a trap-and-forward action
Date:   Thu, 8 Apr 2021 15:38:23 +0200
Message-ID: <20210408133829.2135103-2-petrm@nvidia.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210408133829.2135103-1-petrm@nvidia.com>
References: <20210408133829.2135103-1-petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c6ec263-6845-4bab-2b92-08d8fa93cc54
X-MS-TrafficTypeDiagnostic: BN8PR12MB3426:
X-Microsoft-Antispam-PRVS: <BN8PR12MB3426EEB2BF9FAB3EEF34CAEDD6749@BN8PR12MB3426.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bUmv0ilR2QoxytMwjejxzl5WVgWIh2aFyV24R/kGtBBbWulF2qHlWsBDE3HZvDQ5ypMT1kW4Gk4UdR214WhDFAjMo9s1VJwBsw9eQq+z7pJk6i2ykRIIUGcnHJNBtgypj1YXiOmDz2Q56eW+Xc/6e5xKQ3b7xwVuxvf5VyC7hhw5c4h7HNnW4O8CT+liZ0GuY8bGr3DbDsCoRJNb+tYg7PlnutiGPGHZKx5WE92AFVHjDynzMpK+wZNu2GTZT1t3JGR29WN/G0ESTejEn+jEKw0D9qFmELW+sSGK4LzwOFUXH/8I3ChXJJ90QehPopsi2klXW5t19IQMR53CRrrUxA35qac5cvykM9QQv5Aj4OWxKWAxitUESF+VLkePcSmQHHqevEGXKqySeYJjgissQPgkP5vrHdq+Uflwmd9Z0HN2hXcOtRtycSNlQ08Mwxwa4yYJSDRaFX03zzeEl3mSIfMxej3Wi6DgZfT2aEsGUc9jDgkypyN0leR7P7wV9RJ0illxixfPDYeMm1unBhE4HOc2TbvVn1XNQRSnxkcRaPlSmuXpiv/pWgjn+v3gsf8Wh2V1SkF6SkSFij7u0RnberUZOLnvUZXQF2w7aojcCqKTnhVvPgfk2v+wtGq9T6VsugTnj4hDF8neymr1yYjqycdRzWgawMYRiqx+HxX9UiU=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(396003)(136003)(36840700001)(46966006)(2616005)(6916009)(4326008)(478600001)(36860700001)(16526019)(2906002)(186003)(26005)(8936002)(8676002)(336012)(426003)(5660300002)(82740400003)(86362001)(70206006)(1076003)(70586007)(83380400001)(356005)(36756003)(7636003)(82310400003)(6666004)(47076005)(36906005)(54906003)(316002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 13:39:56.6380
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c6ec263-6845-4bab-2b92-08d8fa93cc54
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3426
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TC action "trap" is used to instruct the HW datapath to drop the
matched packet and transfer it for processing in the SW pipeline. If
instead it is desirable to forward the packet and transferring a _copy_ to
the SW pipeline, there is no practical way to achieve that.

To that end add a new generic action, trap_fwd. In the software pipeline,
it is equivalent to an OK. When offloading, it should forward the packet to
the host, but unlike trap it should not drop the packet.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 include/uapi/linux/pkt_cls.h       |  6 +++++-
 net/core/dev.c                     |  2 ++
 net/sched/act_bpf.c                | 13 +++++++++++--
 net/sched/cls_bpf.c                |  1 +
 net/sched/sch_dsmark.c             |  1 +
 tools/include/uapi/linux/pkt_cls.h |  6 +++++-
 6 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 025c40fef93d..a1bbccb88e67 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -72,7 +72,11 @@ enum {
 				   * the skb and act like everything
 				   * is alright.
 				   */
-#define TC_ACT_VALUE_MAX	TC_ACT_TRAP
+#define TC_ACT_TRAP_FWD		9 /* For hw path, this means "send a copy
+				   * of the packet to the cpu". For sw
+				   * datapath, this is like TC_ACT_OK.
+				   */
+#define TC_ACT_VALUE_MAX	TC_ACT_TRAP_FWD
 
 /* There is a special kind of actions called "extended actions",
  * which need a value parameter. These have a local opcode located in
diff --git a/net/core/dev.c b/net/core/dev.c
index 9d1a8fac793f..f0b8c16dbf12 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3975,6 +3975,7 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 	switch (tcf_classify(skb, miniq->filter_list, &cl_res, false)) {
 	case TC_ACT_OK:
 	case TC_ACT_RECLASSIFY:
+	case TC_ACT_TRAP_FWD:
 		skb->tc_index = TC_H_MIN(cl_res.classid);
 		break;
 	case TC_ACT_SHOT:
@@ -5083,6 +5084,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 				     &cl_res, false)) {
 	case TC_ACT_OK:
 	case TC_ACT_RECLASSIFY:
+	case TC_ACT_TRAP_FWD:
 		skb->tc_index = TC_H_MIN(cl_res.classid);
 		break;
 	case TC_ACT_SHOT:
diff --git a/net/sched/act_bpf.c b/net/sched/act_bpf.c
index e48e980c3b93..be2a51c6f84e 100644
--- a/net/sched/act_bpf.c
+++ b/net/sched/act_bpf.c
@@ -54,8 +54,16 @@ static int tcf_bpf_act(struct sk_buff *skb, const struct tc_action *act,
 		bpf_compute_data_pointers(skb);
 		filter_res = BPF_PROG_RUN(filter, skb);
 	}
-	if (skb_sk_is_prefetched(skb) && filter_res != TC_ACT_OK)
-		skb_orphan(skb);
+	if (skb_sk_is_prefetched(skb)) {
+		switch (filter_res) {
+		case TC_ACT_OK:
+		case TC_ACT_TRAP_FWD:
+			break;
+		default:
+			skb_orphan(skb);
+			break;
+		}
+	}
 	rcu_read_unlock();
 
 	/* A BPF program may overwrite the default action opcode.
@@ -72,6 +80,7 @@ static int tcf_bpf_act(struct sk_buff *skb, const struct tc_action *act,
 	case TC_ACT_PIPE:
 	case TC_ACT_RECLASSIFY:
 	case TC_ACT_OK:
+	case TC_ACT_TRAP_FWD:
 	case TC_ACT_REDIRECT:
 		action = filter_res;
 		break;
diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index 6e3e63db0e01..5fd96cf2dca7 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -69,6 +69,7 @@ static int cls_bpf_exec_opcode(int code)
 	case TC_ACT_SHOT:
 	case TC_ACT_STOLEN:
 	case TC_ACT_TRAP:
+	case TC_ACT_TRAP_FWD:
 	case TC_ACT_REDIRECT:
 	case TC_ACT_UNSPEC:
 		return code;
diff --git a/net/sched/sch_dsmark.c b/net/sched/sch_dsmark.c
index cd2748e2d4a2..054a06bd9dc8 100644
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -258,6 +258,7 @@ static int dsmark_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			goto drop;
 #endif
 		case TC_ACT_OK:
+		case TC_ACT_TRAP_FWD:
 			skb->tc_index = TC_H_MIN(res.classid);
 			break;
 
diff --git a/tools/include/uapi/linux/pkt_cls.h b/tools/include/uapi/linux/pkt_cls.h
index 12153771396a..ccfa424dfeaf 100644
--- a/tools/include/uapi/linux/pkt_cls.h
+++ b/tools/include/uapi/linux/pkt_cls.h
@@ -45,7 +45,11 @@ enum {
 				   * the skb and act like everything
 				   * is alright.
 				   */
-#define TC_ACT_VALUE_MAX	TC_ACT_TRAP
+#define TC_ACT_TRAP_FWD		9 /* For hw path, this means "send a copy
+				   * of the packet to the cpu". For sw
+				   * datapath, this is like TC_ACT_OK.
+				   */
+#define TC_ACT_VALUE_MAX	TC_ACT_TRAP_FWD
 
 /* There is a special kind of actions called "extended actions",
  * which need a value parameter. These have a local opcode located in
-- 
2.26.2

