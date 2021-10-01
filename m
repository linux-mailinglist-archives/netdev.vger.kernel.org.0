Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C158F41EC04
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353962AbhJALfR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 07:35:17 -0400
Received: from mail-bn8nam12on2115.outbound.protection.outlook.com ([40.107.237.115]:36537
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353956AbhJALfD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 07:35:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVeXZIlZKlg5dmSfRkprDgVMcZQCXst3J214uhNWVObFAjzH/SbRp1ATX/7HaRRepYuL18t+yCJrDkUt/pZRyyDyGsu8KLJEf+Y4R4omNhwwgcK4I1RI9lJj17zC7ZAUKYKW/Iq8QyuP3KAxYdeM8unddbHCuMKWyfGBSKCcFjakczkC0l+cAOq+u4l4cV9B2RU24Ye3JfRCRliPYvjQIOTg5Mil/PBLfgbwZ9EDTbTklb2oq7MwWmrTFZ2U8ka0IQmP658+ESW0+Hd4tOnzKajfGD3hd9bmU5M0IKNe2X6PnAVhyzYxXMo4eDDEKtLrfF11vilJm6WqKrbwHO/9Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1hwuk0xBOSEMvCcmZHl1HGWgoMXialxwh8/Pc1WQ8I=;
 b=Gz1KB1FE3R2m1W0bkiLLrjTilM//LrhePIqPxetYqS+La39nSD9i+svVr272oqf2ml4ju+BMCu4DPBGvLcQ/oZORKKJiqhWl4b3RJeoZalRPqGUKjuS02zxiX0lL/uqp+HEJutQnjhnKIItH72TAJUj20JTedOmxT4p9ndTYRLYXSoLUzul8mDUB/8gbIXyqSYCryov81F+pO+W8ciPPSWIdz3k1KDgByX/E4DFb+qu/aYUZ8MhL68CKLajrJjsYhOcRHZPyeQLUkuVRVupTnwVDb7aW/gp1t2oTKoe29OJYUDwDBzcfcyTK04ciebL7qD4ib1h/zQQBmtJD2Gb0uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1hwuk0xBOSEMvCcmZHl1HGWgoMXialxwh8/Pc1WQ8I=;
 b=COgfQOQMbtFZSiploXNQr1j2ZZVEstQuVoSZphLmGEbSunDLjzTak0Xr/7mx54aJ/L51pfa82TkQp3RGWsG5pI8xQf69Rd3WnDT6eJ4Svc7eT9/RX9uY3iF3GL7GTXHFxWYG0X7rAlL+bsVnfddx0xPImlm5oUlAeYobxJlu4EY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by BY3PR13MB4804.namprd13.prod.outlook.com (2603:10b6:a03:355::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.7; Fri, 1 Oct
 2021 11:33:10 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::4e4:4194:c369:de5e]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::4e4:4194:c369:de5e%8]) with mapi id 15.20.4587.007; Fri, 1 Oct 2021
 11:33:10 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Baowen Zheng <notifications@github.com>,
        Louis Peens <louis.peens@corigine.com>,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [RFC/PATCH net-next v2 3/5] flow_offload: add process to update action stats from hardware
Date:   Fri,  1 Oct 2021 13:32:35 +0200
Message-Id: <20211001113237.14449-4-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211001113237.14449-1-simon.horman@corigine.com>
References: <20211001113237.14449-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P191CA0023.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::28) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
MIME-Version: 1.0
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM8P191CA0023.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 11:33:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5fc926f2-722a-4937-6be3-08d984cf3f6c
X-MS-TrafficTypeDiagnostic: BY3PR13MB4804:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY3PR13MB4804D05AD50385159C221CFEE8AB9@BY3PR13MB4804.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:363;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zP1fPtWb+Jr+dabtCUMoOqnTePC5ud5oFFRi7vKo8QwIAT2GAvXyCviA82M+QArjLoRYwaw+ng9f4zOMzvQyVvgNtK+3F1SbxKFZzsA5QOEtRmg7btqCFKnnVnznrtz+erKCJdHKD7kIJcLFRLBsrySD6hr6scbfpB9qc2RxCsqbiqrcogLgGEW5ygWPhh2m0RQQPeixJF12c2DRZ2wJqXIrrsjCGSqGfHealjt09zxUXKO4kpyoyFAWjSDarfe1NqpYEDBw9BIfJY+uQKZlKNDyZ9O2zfTvtrHSQviNR1YANpqqfJ3xeZ9+NbnYNkjDXo9eZRll2+8guZYwIf10Avq2d3qJDI82GbF5lNQ7YD5ItPBCh9N0S+0blYUW7PJ5Zr0mp839yg1wNkThn+1P3rP+mTdK6FoIR9VXfmEgXxd7vIbq4qhJydHC1Um+0kzB81iQSXgpM8hSXFo9TivvOK5UoBWgjL+Whp2bFVBcyyR14f9QRdd3bVes2xX0H1E1IXXWsPXez/dtb0s4C7auE5a9zM2cHRfugEa4UcRLOu+eEbUkOnctIkxGur2XMUbzMQHUNBM9xudjPqLOcj8Tf2LqcHmNPjIablV5RY45bCJD2/rFDYzWrD3Q2LaEnbCLogimMDToH4MNvfLjvderNw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(376002)(366004)(39830400003)(2616005)(66946007)(86362001)(36756003)(8676002)(508600001)(8936002)(15650500001)(6486002)(54906003)(1076003)(316002)(66476007)(2906002)(107886003)(66556008)(186003)(52116002)(6666004)(4326008)(6916009)(44832011)(5660300002)(6506007)(6512007)(38100700002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hCL5qXpnGZYegrNrs7pUak01EbEXbLUSOxaW6MWiXe4+6MUQbebvbKqdFi5D?=
 =?us-ascii?Q?Otq8SPa0Qn9mfMNokiwIdpBIfVCo8Z2wrGujeQcCQlDR9SIXQ4VnbV+3qYTt?=
 =?us-ascii?Q?WFayceUO8Du6kf1D4xTU5wc1CZNoqLHb1qUmXywzq1tnAz25qU564pYYmjCR?=
 =?us-ascii?Q?ShiWqn6UnI+f94cXlfJHye932GT6vyttlUNtjzhWnPgdgoPY1JAXx6WU2GPu?=
 =?us-ascii?Q?7vKgAIXTpZE2EVii3D4jB3O8optS2dbvHbiMIILl/hI7B3FNHQ78HARoAgU9?=
 =?us-ascii?Q?lok9Joav2hyvPrT8KEpBIxdES4oRizVdgnOAkq82vlEok2wouhP9bcKiNJlY?=
 =?us-ascii?Q?HHSmqKGvHySC3zH5vhp9n4QxHiJO5LGoli4qr3Q7pgwgaQK215CJEN63djx1?=
 =?us-ascii?Q?wEM4yiNnXG5D2xOx7eZtxIdU/YHd6+BiI9KNvsXIudFXOeq2n/oyLS0aSZMP?=
 =?us-ascii?Q?nr9rt1QOlEpwOZbSRNn25MDy9rssm1XfWGiZs2/cdA6SiFSNemmO/vrxrLuY?=
 =?us-ascii?Q?Qt493BP1enxHoQErLiAozjfhwtTXGbb5sviYR6of2dMnnk1GzM4vX7JBPMbY?=
 =?us-ascii?Q?ADs3oMQbQeivogIJMr8B56AEB8Ws3vpOWXO2pP7cNTL7saSYVl1eEUNT3Jhv?=
 =?us-ascii?Q?aJqAK7LQqQOdntL1dCALKvJLpM342ZEZWvDovrws6n4I7RVxlu7aL4dpjrog?=
 =?us-ascii?Q?e9484LyqFDqtvkKL0bNiK0+F9XHVHF6ClzNYelWJ+Y7uBlcRw6/rsJfWQVID?=
 =?us-ascii?Q?7FFmj6N4uEhzVGLig2TiHG3RTayP6ejvAXm99nzIx0FrlIqnZMwdp0h5iiOy?=
 =?us-ascii?Q?y2kRycI86Y367XmRTTs8uSuebnINjHA1DebWpXooQABwPzm2NFR+yh/8E+Tb?=
 =?us-ascii?Q?GCPYMrEWGZfUO0ZxxIzw3ztPBtoNJMf50gdZhUClHDK3+Y8kmkrLQJTV5Hn+?=
 =?us-ascii?Q?20dYJBbEj47UfoZSrdE0pYwif8WFPapPTfycs047dwOW23T/CTomtXvAO88O?=
 =?us-ascii?Q?3xes48xEYn2r0ix7lxtkD3VOyYNTkeMWUQSob712HgU7It2eOP7pZsbbRsjz?=
 =?us-ascii?Q?dbpIjrzCQYqDooS/AXWFeAlnq4DjPOSVjRZzoWDapplVzWnQPEGb+lLpxVux?=
 =?us-ascii?Q?ZlMqRfBqI9wHdTDdaY6ZTJqV7oqamybmmrwzgAdQzOZVRji0hVrvlgDtEP8i?=
 =?us-ascii?Q?vL7Lrp0J+aNdu3qqkT9TwOKCkusdEjla29he/TlP4bwaE5USDDIJWbC7JbXM?=
 =?us-ascii?Q?Ubnm1tXJX+AfMrWhLnFXBE9AnGtsGVidb24WdeCfR1pQnQS+j4KTY+j7zvWq?=
 =?us-ascii?Q?oEHqDuK8IVMpIT18QEqIwryMsX+vvfrmTuOhyy9bx+g0pMebUqPwNVeqWetL?=
 =?us-ascii?Q?BjoOgdVEMuCwJzHwSmhd+cUPj/ov?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fc926f2-722a-4937-6be3-08d984cf3f6c
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 11:33:10.8096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3hzVTwbjAWibbnkvoxFqrohOlV+H2yyNGU3t/INMR+6tf6akpAj03sr6bai1iVjonHzfCKdKLZl56urs9K75iQ69Nw5L8QFYn1cYtqKwETA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4804
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

When collecting stats for actions update them using both
both hardware and software counters.

Stats update process should not in context of preempt_disable.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/act_api.h |  1 +
 include/net/pkt_cls.h | 18 ++++++++++--------
 net/sched/act_api.c   | 37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 656a74002a98..1209444ac369 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -241,6 +241,7 @@ void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
 			     u64 drops, bool hw);
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
 int tcf_action_offload_del(struct tc_action *action);
+int tcf_action_update_hw_stats(struct tc_action *action);
 int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
 			     struct tcf_chain **handle,
 			     struct netlink_ext_ack *newchain);
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 3bb4e6f45038..5c394f04feb5 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -294,18 +294,20 @@ tcf_exts_stats_update(const struct tcf_exts *exts,
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
index 3e18f3456afa..c98048832c80 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1275,6 +1275,40 @@ static int tcf_action_offload_add(struct tc_action *action,
 	return err;
 }
 
+int tcf_action_update_hw_stats(struct tc_action *action)
+{
+	struct flow_offload_action fl_act = {};
+	int err = 0;
+
+	if (!tc_act_in_hw(action->tcfa_flags))
+		return -EOPNOTSUPP;
+
+	err = flow_action_init(&fl_act, action, FLOW_ACT_STATS, NULL);
+	if (err)
+		goto err_out;
+
+	err = tcf_action_offload_cmd(&fl_act, NULL, NULL);
+
+	if (!err && fl_act.stats.lastused) {
+		preempt_disable();
+		tcf_action_stats_update(action, fl_act.stats.bytes,
+					fl_act.stats.pkts,
+					fl_act.stats.drops,
+					fl_act.stats.lastused,
+					true);
+		preempt_enable();
+		action->used_hw_stats = fl_act.stats.used_hw_stats;
+		action->used_hw_stats_valid = true;
+		err = 0;
+	} else {
+		err = -EOPNOTSUPP;
+	}
+
+err_out:
+	return err;
+}
+EXPORT_SYMBOL(tcf_action_update_hw_stats);
+
 int tcf_action_offload_del(struct tc_action *action)
 {
 	struct flow_offload_action fl_act;
@@ -1399,6 +1433,9 @@ int tcf_action_copy_stats(struct sk_buff *skb, struct tc_action *p,
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

