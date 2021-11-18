Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 901EB455C54
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 14:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhKRNLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 08:11:47 -0500
Received: from mail-dm6nam12on2130.outbound.protection.outlook.com ([40.107.243.130]:54048
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229674AbhKRNLm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 08:11:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WoeQ65B8fTevsoPkQXk+wcGfntVpbuvZCmY0vIA1MNOH2fIsaguCkh2lreZA/ADhqyWsQzHBL0NCMYVNCuzzs6KCrzPza2gF+pH5n2wL2gwLW1UkEC/4MuWmCMq9Hsl4MHINyYH4xsB7ZIbWK+Ew2UZEmww08uc7uXLbzbh+IHo4cwVz7kfOK6B3sjK5epCyMaNQydG2zkGt+n3KrpCxszzWkcFuqAJ4tcE57VyFFEEO3UTA0F3iVruPwxLCNtaO8kE0sLm/xSDrp/znouiO0ZqRfPDuIL5qMGzyRYMZ+3wcZH0gtBq4s7PWml4NfOSFHiHOB7jr/gfHYvVlPrJKcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nYPAPMMD3ajgyir6wXyZE77OfTZq+n63W8BjxoM6ylo=;
 b=W+kIBaQITq5cxi9Rs279Al1ot+KXfmAZTHQPie7ezJXNqK9Jd8LOSDaKu3f7/HdS4i6e/cOCUdxfnj2DMNK0M164Jx5oPPeI6M9+TiZrJmgDjW/MrH1xCEjz2bdkuSDQ0QoGRSucvQmSwTkZIS29mlFEMb94d+c4KaLd1ESE2c/EWX6LZy5LhpO4AzBLRFs13lJ3N+uKPvWhmzxabtzAsKpkgfGzh7jpCnJLOooEbWWCZzGN8yde4koYQmMKeQuVi8HqkjJ+fxGFf6ScKfM3TUBBtsuBVZNcFBl25cyMNpyaOUepvypE1rJb79slwj4kSgm5ROQd9TtNSLrkF8+idg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nYPAPMMD3ajgyir6wXyZE77OfTZq+n63W8BjxoM6ylo=;
 b=Lt1ObXwXubG3i8TOS6oHH51RGnDubQXPzFkZP6az6gQqTOkfKrUyCHoflnQCaTG3nX9DWJ8kWenna6RHMqCK3kSi1mFxHQe6ZTe+yY9K652qVzZFFtQ/usWh3yJN+fq5AfXqWiXvEDEULgLl5D8qwwsL3/9F999VEgM05r1VnHM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5422.namprd13.prod.outlook.com (2603:10b6:510:128::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.10; Thu, 18 Nov
 2021 13:08:31 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::3152:9426:f3b1:6fd7%7]) with mapi id 15.20.4713.016; Thu, 18 Nov 2021
 13:08:31 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com
Subject: [PATCH v4 06/10] flow_offload: add process to update action stats from hardware
Date:   Thu, 18 Nov 2021 14:08:01 +0100
Message-Id: <20211118130805.23897-7-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211118130805.23897-1-simon.horman@corigine.com>
References: <20211118130805.23897-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0202CA0021.eurprd02.prod.outlook.com
 (2603:10a6:200:89::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from madeliefje.horms.nl (2001:982:7ed1:404:a2a4:c5ff:fe4c:9ce9) by AM4PR0202CA0021.eurprd02.prod.outlook.com (2603:10a6:200:89::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend Transport; Thu, 18 Nov 2021 13:08:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b370b8d3-1416-468a-c6d9-08d9aa9484b6
X-MS-TrafficTypeDiagnostic: PH0PR13MB5422:
X-Microsoft-Antispam-PRVS: <PH0PR13MB5422857384F15DBDAF1B087CE89B9@PH0PR13MB5422.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:363;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /HG+88wsUFBjtsRH88Q+KunaKdWAgTRzuoMkJNngmpRIXKNvxQDI63U303qu4TkkO1vvmov513RoedS40uIPRT9Todh9QL+RYzHzvnAzE/JsD05/UQRi0FfOaBnmqDeFXpoXa4t0Y2E/8mzduJ+BiWncdF1WuJde2m4hjIv9iYi4e7EXcYvBj296fPJyRte12WTMWbRtaPfjk7aKdJNwDfeNRj8uhHz8QVTPecXOeU5mt6HyylveKrMa9RVIquGPgAY8KYww6EYH8W6dlD5M2ynHANUi4o5E2Zf1b1NQUUFAjXO9aTWgWJhZh67FgZ4ziE5MBmsBtSzvCbe20H9S/IZa+oR3S0ny53xx5+ZpQ1ERvQZ4P2ajYbHuLdqi2q2GEcPBo8WLYFzPz1e/xhhdqLGtFqVV3D9yLTIWBnYbMXoUnrjPgGHiD5aJHmqVT1dX0EO8u53jsQbIGN5hni7n8ys+bXT7Msxj6y2gMfGkghVNPeNOl3llQx0ZOHfbw8weUQVxzHE8Y/AxRzNaKfR0Huk8z8kCHrcXdvfScU/xvzbgSGoRRaLdpmB7ZgJU4sREj2q8ozsYxKRWzI7Av+UdQqo+cRhO836kH6cWlmzzmWWkEMvvikSAVfSPIwDbZuhKArJRwnqWp+n+Hz5yZ4NYww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39830400003)(136003)(376002)(346002)(6486002)(2906002)(54906003)(6666004)(316002)(86362001)(52116002)(6506007)(1076003)(38100700002)(186003)(15650500001)(6916009)(107886003)(2616005)(44832011)(5660300002)(4326008)(8676002)(508600001)(66946007)(8936002)(36756003)(83380400001)(6512007)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6S0nMoKsf/NGeXPEBcOnuoCCZT0abPD215k7KmhdzHElUrCrS3v/4nER+2t+?=
 =?us-ascii?Q?Y9hYHPJmc1pQy9OWRdUGLgRwgPoysjnYmmt3Wy7vNZ+iRjc5k3i51202WW+V?=
 =?us-ascii?Q?hIbJQGS3RX6i6W+XdoPx7BX4W9WIFcGCnrzJMHKmQ7ARlmIcVlZbMYe1Nahq?=
 =?us-ascii?Q?jVvx8ZjS1VHsVGOeIbkU95WdbGg3Wd6ldRCEdhwAKYC+ZSlo8AWIsl5/DF9C?=
 =?us-ascii?Q?rdo3S70hB2osBJMYTPST5GwbuNWBQy/m3Uf5SYqcDBCDCtgNJ3jhU03LmmFv?=
 =?us-ascii?Q?tT9nKBzr9uwRRNQgurmchuLE6qR88LyG95lVHevRC4p9Kh4mPx1obHStJr0V?=
 =?us-ascii?Q?4XUnZCt64MiIaZu098uvESQJPy2DaxqhxiPPJWniW+7Ysy/0Ch/1mw4J7WVu?=
 =?us-ascii?Q?XNLXQ+FbwyoNZW9/gkdWy1/sRaFaMw93URA5mukgX/4GFOogeTLBhvIkogx6?=
 =?us-ascii?Q?w5VwvcsVVxsNYJ2dnosdOc537e81XAnov9PZ8naD8Dm8OdHdYc3zS9ntQmdr?=
 =?us-ascii?Q?yEyBk17uYkRcAhv81CvxzCxSuEgop2VjJLrwa7T6h6tW1sXTzS1xDZQ+c5Ni?=
 =?us-ascii?Q?5ROh/hr2fQ15k11J9dYVQ8QJVhnYypUceTENV5wU0dZAoA0mOfW+Hj2BKAZo?=
 =?us-ascii?Q?ugssNlgxIM14xJXnpSYklHSQejg6cSYUbtT4j0Bq1krtcp1G3mJJbtIn5bF8?=
 =?us-ascii?Q?p/s3obs1EDWOvy5wBEs+ec+PoDAjhLbYsr5BCiFAvU1nT7TdrlfVvQTg4O9w?=
 =?us-ascii?Q?XNE9frIOHXt5MX/T6DO+Umfxl4BaYZ/iSM3n1ZR3Fd36IFG/nm7e9v3hk7QZ?=
 =?us-ascii?Q?OO4DgJUcm/ffd7Z4do0Nzz11ewp8NbYna7Zhc/2aRIANy3DQ2VMxT3hNr3Q4?=
 =?us-ascii?Q?XdeGQC1tggc5G55MoI7+A8Q0FgANxuIjj4xmlpDFDvB4DnbTmJs75TmIspXj?=
 =?us-ascii?Q?kcetR1qVgVJ0uipy7U0JHxylrtjh9136NEhiz9gytPnsaJL9cixvUghsBSq6?=
 =?us-ascii?Q?YnqiXKNK9uwMYEUrA2mEIbntvt/fjcL5Ljb2jmb5wONoGYfYG8OQYI8XkCzB?=
 =?us-ascii?Q?i9uT1gDcYe36qeLh12J1yA3uJQDVQN42KCzT8cRIHEe0Ez/Fdjs3yfw/GMa2?=
 =?us-ascii?Q?ja6WRqukwLuVYZZFXVigOcs21waaHNSykuo+YxB1bgThNokMMOR+h7rPp5bb?=
 =?us-ascii?Q?z8XIA/LfSYBdMu/jFBbYEPGrzC/cfeSRuOfFLP/qkFowL/T+qW21GQY7h7VO?=
 =?us-ascii?Q?OJi55q0aWQ0p5pGjfFkka7LZA8KJj7px3Jy4qAqwQ1wo4VJcJTL4P50hKGbx?=
 =?us-ascii?Q?pZI2YiTMMTRQ+ATdXpk1ye0CyaMa8NEp3mPDylQKJAZbuLrs29nnx/bfo3Xd?=
 =?us-ascii?Q?6/35D/DL4bT5hEXZEFrP6X8zcCuS3B1rYQTwgvRXhyEgdwNege5iqyPfiksS?=
 =?us-ascii?Q?eOMntbm8/ISDSK5HPtt2uav+AJCKhUr9dLDjXrDsdaGx8W899K4cxLQSjWMl?=
 =?us-ascii?Q?YHef1lJ5+5fJS3wCY1Hi2/xIOkvQQA0drI/c1JPFB6nr/HUBhhM2ZsSgVHMF?=
 =?us-ascii?Q?AiPL7hAk4rjebYzhtYw3ZOpmLrzm6W4BbzpVqj1rI0sFdk+mQ3R8rSoh6q9+?=
 =?us-ascii?Q?mf4/iSoRs9Suas+fWHOcTCBldbU+z/4bBaOJkpw0n7KMpfgGcX6OstUsIQLN?=
 =?us-ascii?Q?HVoGuVIoFV8dqP7tY0QQSg6u2m+piQZ+KC6r5dU2DZXUTIR1V/nVWcwMvr5u?=
 =?us-ascii?Q?fEHngNFyTbCt8+DsUAizao9TqaHq1sQ=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b370b8d3-1416-468a-c6d9-08d9aa9484b6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 13:08:30.9343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1WLidFLUqGpWV3pIg5ACXU1L4qcjFTtUTlQUV8Ok+dI30C/Y15tiq/W5Vx7jaT8meq20zlDBNtVpzxKwMgDVKGkjtFhJDfzWOtSSwhXeV4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5422
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

When collecting stats for actions update them using both
hardware and software counters.

Stats update process should not run in context of preempt_disable.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/act_api.h |  1 +
 include/net/pkt_cls.h | 18 ++++++++++--------
 net/sched/act_api.c   | 34 ++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 8 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 68d6f245f7e9..7900598d2dd3 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -247,6 +247,7 @@ void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
 			     u64 drops, bool hw);
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
 
+int tcf_action_update_hw_stats(struct tc_action *action);
 int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
 			     struct tcf_chain **handle,
 			     struct netlink_ext_ack *newchain);
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index b00fd421e7c0..c8e1aac82752 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -297,18 +297,20 @@ tcf_exts_stats_update(const struct tcf_exts *exts,
 #ifdef CONFIG_NET_CLS_ACT
 	int i;
 
-	preempt_disable();
-
 	for (i = 0; i < exts->nr_actions; i++) {
 		struct tc_action *a = exts->actions[i];
 
-		tcf_action_stats_update(a, bytes, packets, drops,
-					lastuse, true);
-		a->used_hw_stats = used_hw_stats;
-		a->used_hw_stats_valid = used_hw_stats_valid;
-	}
+		/* if stats from hw, just skip */
+		if (tcf_action_update_hw_stats(a)) {
+			preempt_disable();
+			tcf_action_stats_update(a, bytes, packets, drops,
+						lastuse, true);
+			preempt_enable();
 
-	preempt_enable();
+			a->used_hw_stats = used_hw_stats;
+			a->used_hw_stats_valid = used_hw_stats_valid;
+		}
+	}
 #endif
 }
 
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 29fba4fa1616..01f0bed9c399 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -290,6 +290,37 @@ static int tcf_action_offload_add(struct tc_action *action,
 	return err;
 }
 
+int tcf_action_update_hw_stats(struct tc_action *action)
+{
+	struct flow_offload_action fl_act = {};
+	int err;
+
+	if (!tc_act_in_hw(action))
+		return -EOPNOTSUPP;
+
+	err = flow_action_init(&fl_act, action, FLOW_ACT_STATS, NULL);
+	if (err)
+		return err;
+
+	err = tcf_action_offload_cmd(&fl_act, NULL, NULL);
+	if (!err) {
+		preempt_disable();
+		tcf_action_stats_update(action, fl_act.stats.bytes,
+					fl_act.stats.pkts,
+					fl_act.stats.drops,
+					fl_act.stats.lastused,
+					true);
+		preempt_enable();
+		action->used_hw_stats = fl_act.stats.used_hw_stats;
+		action->used_hw_stats_valid = true;
+	} else {
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(tcf_action_update_hw_stats);
+
 static int tcf_action_offload_del(struct tc_action *action)
 {
 	struct flow_offload_action fl_act;
@@ -1360,6 +1391,9 @@ int tcf_action_copy_stats(struct sk_buff *skb, struct tc_action *p,
 	if (p == NULL)
 		goto errout;
 
+	/* update hw stats for this action */
+	tcf_action_update_hw_stats(p);
+
 	/* compat_mode being true specifies a call that is supposed
 	 * to add additional backward compatibility statistic TLVs.
 	 */
-- 
2.20.1

