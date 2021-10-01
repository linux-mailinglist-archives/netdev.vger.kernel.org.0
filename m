Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C4D41EC00
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 13:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353954AbhJALfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 07:35:02 -0400
Received: from mail-bn8nam12on2115.outbound.protection.outlook.com ([40.107.237.115]:36537
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353956AbhJALe7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 07:34:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m58Y7KcX756PMjtn9d09y9dpMVfAnU/OSZ/3vB33q/fon49kahXVdRBhWefEnSPHkFrkUGJf6HHM2MauQQsmbcteqV6vx0flt0wc99OporhA5MG2SJFkcRihiaw4RJf6RiJc1gUlDiWo682DGuxZwDsVpRaSR/b9No3PRIrbin9QkvTkqzWnSX8RQV+gm6xEOakiBCDF2qOKTQtexC81lJ3tmQndVMQlEANNt/qAghwuSE863Zf5H5ZnnErnCg4W2f1Yq9W35hEsPd4kGrCQD/B2ohzjPiNQzwGTNHhmrvnuohkI1VVuSqzXWz8yCfGrda6NY3zk1FOqX70fcej40A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=odT68ZVOn25LuOYH6SHXTUkH39ibfmGwnXPDjedQclo=;
 b=CTjwDnMhZ/YaUMKiWkh06T4wM89trDk/b/S929/5GwtfG7WPX9XRcJgi3UtFbdeA7gQ1bxP4NQdrS2REDJcjnupW0Rn+gwSTAXtkg91kDyPcb6jCgsOZ4ATlsUwaMe9PYpeoRj5XxSYxo9E38CP4EYt/2dLfxpccJWY+fN8/IEcRF4RBkHPDDmgBPFYThmdRjRti3NK/ea7KTUjcfdl1EOYuQ2aiZ7hm72FMh6762iRzjj8erXiIZWK2OddV9NEnRk0Ff1gMFteoIc8jvEc9VhUHQbxt0qtGykAFvZrNSzxbT/xyZyi2hmfB171d9PjJMEhu410mhk0W7cyX/uyP9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=odT68ZVOn25LuOYH6SHXTUkH39ibfmGwnXPDjedQclo=;
 b=kPzer2B/rrJKf/uYh9q3NBHhueCSkcUZMHaIaTBvrA+ER00odl0frP3MuYJ3SlY1Oritp79ds1iTpnmcCLYZGrcqWWtdi6oQiAIgU5ZC4JDl8Uc7GzqWK1yA2u9RAQGveOlJ3xkPTX0ScgMQCi4Dko3fVHJ2AUedNIb3OfySujU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=corigine.com;
Received: from BY3PR13MB4834.namprd13.prod.outlook.com (2603:10b6:a03:36b::10)
 by BY3PR13MB4804.namprd13.prod.outlook.com (2603:10b6:a03:355::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.7; Fri, 1 Oct
 2021 11:33:08 +0000
Received: from BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::4e4:4194:c369:de5e]) by BY3PR13MB4834.namprd13.prod.outlook.com
 ([fe80::4e4:4194:c369:de5e%8]) with mapi id 15.20.4587.007; Fri, 1 Oct 2021
 11:33:08 +0000
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
Subject: [RFC/PATCH net-next v2 2/5] flow_offload: allow user to offload tc action to net device
Date:   Fri,  1 Oct 2021 13:32:34 +0200
Message-Id: <20211001113237.14449-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211001113237.14449-1-simon.horman@corigine.com>
References: <20211001113237.14449-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P191CA0023.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:21a::28) To BY3PR13MB4834.namprd13.prod.outlook.com
 (2603:10b6:a03:36b::10)
MIME-Version: 1.0
Received: from momiji.horms.nl (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM8P191CA0023.EURP191.PROD.OUTLOOK.COM (2603:10a6:20b:21a::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Fri, 1 Oct 2021 11:33:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 472f882e-dd07-45ec-e55f-08d984cf3dda
X-MS-TrafficTypeDiagnostic: BY3PR13MB4804:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY3PR13MB48048FD70790A3C65E848A65E8AB9@BY3PR13MB4804.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1775;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fWDbBPDg+gjYQ0NaTYCokb1Qf45O9aA5Zwoe9RiVDrW7BVuPtQwgUKv62GOG+GpiTGKRFCwwEDrZaZKUvi2zxCebHdLYRAhsp+xtmwY6ZElwh/AnTNu/QoxtEZAgk+o2wVhK7x4K2w/OUyHGNtQ/bH2K6Yl6JYqirSehFHFfMNmL43Y+fvjmBdcIroF6QDrj+Zqz5t8h5XoDLLLyKIef1fs3fDp0IhAql/TNbfNO8ShjOPFlH5Pd080A5b6AO1FHiCXpSPv8oTV5me5RkY+k4oGDFcYd7hCNiXMpY7hfOGMF5jZLOxKHahlNcXwuRKRycho2uuWOBZ5oAzK6Nq7fd7vw5btulo7QeIreoAczFIPWhAVcSPsXDHgz9w+iwMo2JD+1gm9M+pefYVx2nt/CmvgleFESJf7DXR5J/9sFJPdmgOw0mfI6ecTWY780ycuSms2JE1wRAclfB7e33M/i214u+dqnhO67nnsvt3V8CV4AnIVUrrNqbAzXey8puacL9871ew1qwdP4X6HG1AnpS2h89YBbqLDJrVikyeJdHfzpmRKSNK/UtvT2kjaKFdLCC1WlOkR5m4NfXr14vHLDQJ9PTeUPW/tzs6553f6L4LmQ45TC5lkGZX+eUnT6bWnisIjUDxK3HdWj2w5cOJWHAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR13MB4834.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(376002)(366004)(39830400003)(2616005)(66946007)(86362001)(36756003)(8676002)(508600001)(8936002)(6486002)(30864003)(54906003)(1076003)(316002)(66476007)(2906002)(107886003)(66556008)(186003)(52116002)(6666004)(4326008)(6916009)(44832011)(5660300002)(6506007)(6512007)(38100700002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qXze8abLgslKHDeG9tgDMw1vNx2Md9ptfajpefO15ahD1tihC4NfRFSBvnUx?=
 =?us-ascii?Q?RXYIUuvcUF4sBVzm4KZ9vgy6EERKMuOMuSdG+jjioIJZ+wh6c219UItsV39C?=
 =?us-ascii?Q?Wy+VPAyp8KBUNPVCQCJskrnMkXDq2NNPWU95n/cTsl001d4zk6Jo1hESUL0d?=
 =?us-ascii?Q?WzM2as+nOlQ2mCrUJq90OZ2htftvn28ClFLvJ4C7x7y3g1GLmVkW2rdaXoZO?=
 =?us-ascii?Q?5NH/evE5Z+y1zMtHcmSAA10o/oHzXBfN8u4YSg/do7BMYrQ8Eb8PBa4Mau/h?=
 =?us-ascii?Q?rrQl0ygxv22Uo9r6V9xkfgFMEPa5IAWsZM5geQniI4ezrLdCyaIvaQsC9+++?=
 =?us-ascii?Q?fvWFmsCyuNTeLvBUqx9BiwNQfl4hwdzUvUo/99oIbpuN2E0scBCm26zjFgmB?=
 =?us-ascii?Q?cjtWr0o+drrJht1hLVMvimOExz5akv60jKg3MCnM85FNmkiwtn4VssBcY30Q?=
 =?us-ascii?Q?9LnoDTgoLR4dKjw1+gBwSsQmD1ntEXF9NaqKk+TIpkUtXVQzLKHh+UqSAbGh?=
 =?us-ascii?Q?1pVaEicEOm/fhLC7NhfEpz5CcBzmDriipu0PTFRd64UGijth9TDpLmvmbyGK?=
 =?us-ascii?Q?dpU33kCEpMsYm/Pwns+vyIPlTmsQyYithL0b8GhMhpkVEUuUBD7US1ZeSb1p?=
 =?us-ascii?Q?1OtQzAZR8eWYQlvw9UXvG6VB/WoNrbCTOvYE0flO2IgxVk/wcdu5c/kpvKNS?=
 =?us-ascii?Q?OKcAqU6bHrtYcltc4XphUP27SsPOi+FIURJzdEOhaO1Ezc2JSBbmFlK5npbw?=
 =?us-ascii?Q?IVaFnTpvq77TY8xu40iJ9YZ0bSnvn5N8BZVbF1+dl4idQEXCoLsBoTIdovjy?=
 =?us-ascii?Q?bGcGX24EsOKmYWdIJo6InXpnClJlIcFDEjH8gC9Juu2ou/SE5YEylpjpLc/n?=
 =?us-ascii?Q?bId9JaOIfEXfUQWUDYZKEdaGZowQ6kOYv0AMz8mXdFx7EpTZAjGUZ/vSho3s?=
 =?us-ascii?Q?SjQybTUmm5slhcd+QFJ/w5PiBg15I9e6h0AKepNFBbtPg0RsShBFygjjJQrm?=
 =?us-ascii?Q?PF2aPeAiaCXxaIhAuVvWseKAkaRJBeKYGm+1i+5+v98hmSxj9stcXodkSQyx?=
 =?us-ascii?Q?ksCrG0VV+Fkmgij6LnPQKTSF30E/i0CCvIkibs5/5PsH3khVs7lZYfgFWnqR?=
 =?us-ascii?Q?2PVcmJMsMHdUNRxLGpa7POT4N044lzTplhan1kCdFIZHKWnVMWV4cf3pmxU3?=
 =?us-ascii?Q?13pfTnEgbYRZPTKKE+tSQTTR7rgMLMa80lZOeHWQn7dCbceGbxpwqA0btVI3?=
 =?us-ascii?Q?xFDbA9Lrdhp7EhgomaAj+ggfY4fyL4p0wSDUDKwbNzaCMlf12A+jAJeWPALQ?=
 =?us-ascii?Q?KHwr1ABcG/8aoycVcbI9P2XJ7eSJz9BYlJQ5zcCQG6RIKOLcd9/b5lTkrsQJ?=
 =?us-ascii?Q?syJuiDN2MNCRxHU4S3ACxel9EfWH?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 472f882e-dd07-45ec-e55f-08d984cf3dda
X-MS-Exchange-CrossTenant-AuthSource: BY3PR13MB4834.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2021 11:33:08.2539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XI22XStwU6ErCi3Q6QvSMeANmLOulotcT8nRxjdxIOkb0bTLl+r2J6bpbAFnohY75YfgH3VAgWmss9ZQEPTy/zfTqd/l5sxxhCBLa3dQYZs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4804
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

Use flow_indr_dev_register/flow_indr_dev_setup_offload to
offload tc action.

We add skip_hw and skip_sw for user to control if offload the action
to hardware.

Make some basic changes for different vendors to return EOPNOTSUPP.

We need to call tc_cleanup_flow_action to clean up tc action entry since
in tc_setup_action, some actions may hold dev refcnt, especially the mirror
action.

drivers should update the hw_counter in flow action to indicate it
accepts to offload the action.

Add a basic process to delete offloaded actions from net device.

As per review from the RFC, the kernel test robot will fail to run, so
we add CONFIG_NET_CLS_ACT control for the action offload.

Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c  |   2 +-
 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   |   3 +
 .../ethernet/netronome/nfp/flower/offload.c   |   3 +
 include/linux/netdevice.h                     |   1 +
 include/net/act_api.h                         |   3 +-
 include/net/flow_offload.h                    |  27 ++
 include/net/pkt_cls.h                         |  40 +++
 include/uapi/linux/pkt_cls.h                  |  12 +-
 net/core/flow_offload.c                       |  43 ++-
 net/sched/act_api.c                           | 251 +++++++++++++++++-
 net/sched/cls_api.c                           |  29 +-
 11 files changed, 395 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
index e6a4a768b10b..8c9bab932478 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_tc.c
@@ -1962,7 +1962,7 @@ static int bnxt_tc_setup_indr_cb(struct net_device *netdev, struct Qdisc *sch, v
 				 void *data,
 				 void (*cleanup)(struct flow_block_cb *block_cb))
 {
-	if (!bnxt_is_netdev_indr_offload(netdev))
+	if (!netdev || !bnxt_is_netdev_indr_offload(netdev))
 		return -EOPNOTSUPP;
 
 	switch (type) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 398c6761eeb3..5e69357df295 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -497,6 +497,9 @@ int mlx5e_rep_indr_setup_cb(struct net_device *netdev, struct Qdisc *sch, void *
 			    void *data,
 			    void (*cleanup)(struct flow_block_cb *block_cb))
 {
+	if (!netdev)
+		return -EOPNOTSUPP;
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
 		return mlx5e_rep_indr_setup_block(netdev, sch, cb_priv, type_data,
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 64c0ef57ad42..17190fe17a82 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1867,6 +1867,9 @@ nfp_flower_indr_setup_tc_cb(struct net_device *netdev, struct Qdisc *sch, void *
 			    void *data,
 			    void (*cleanup)(struct flow_block_cb *block_cb))
 {
+	if (!netdev)
+		return -EOPNOTSUPP;
+
 	if (!nfp_fl_is_netdev_to_offload(netdev))
 		return -EOPNOTSUPP;
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d79163208dfd..a5fa6fa91772 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -916,6 +916,7 @@ enum tc_setup_type {
 	TC_SETUP_QDISC_TBF,
 	TC_SETUP_QDISC_FIFO,
 	TC_SETUP_QDISC_HTB,
+	TC_SETUP_ACT,
 };
 
 /* These structures hold the attributes of bpf state that are being passed
diff --git a/include/net/act_api.h b/include/net/act_api.h
index f19f7f4a463c..656a74002a98 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -44,6 +44,7 @@ struct tc_action {
 	u8			hw_stats;
 	u8			used_hw_stats;
 	bool			used_hw_stats_valid;
+	u32 in_hw_count;
 };
 #define tcf_index	common.tcfa_index
 #define tcf_refcnt	common.tcfa_refcnt
@@ -239,7 +240,7 @@ static inline void tcf_action_inc_overlimit_qstats(struct tc_action *a)
 void tcf_action_update_stats(struct tc_action *a, u64 bytes, u64 packets,
 			     u64 drops, bool hw);
 int tcf_action_copy_stats(struct sk_buff *, struct tc_action *, int);
-
+int tcf_action_offload_del(struct tc_action *action);
 int tcf_action_check_ctrlact(int action, struct tcf_proto *tp,
 			     struct tcf_chain **handle,
 			     struct netlink_ext_ack *newchain);
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 3961461d9c8b..bf76baca579d 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -148,6 +148,10 @@ enum flow_action_id {
 	FLOW_ACTION_MPLS_MANGLE,
 	FLOW_ACTION_GATE,
 	FLOW_ACTION_PPPOE_PUSH,
+	FLOW_ACTION_PEDIT, /* generic action type of pedit action for action
+			    * offload, it will be different type when adding
+			    * tc actions
+			    */
 	NUM_FLOW_ACTIONS,
 };
 
@@ -552,6 +556,29 @@ struct flow_cls_offload {
 	u32 classid;
 };
 
+enum flow_act_command {
+	FLOW_ACT_REPLACE,
+	FLOW_ACT_DESTROY,
+	FLOW_ACT_STATS,
+};
+
+enum flow_act_hw_oper {
+	FLOW_ACT_HW_ADD,
+	FLOW_ACT_HW_UPDATE,
+	FLOW_ACT_HW_DEL,
+};
+
+struct flow_offload_action {
+	struct netlink_ext_ack *extack; /* NULL in FLOW_ACT_STATS process*/
+	enum flow_act_command command;
+	enum flow_action_id id;
+	u32 index;
+	struct flow_stats stats;
+	struct flow_action action;
+};
+
+struct flow_offload_action *flow_action_alloc(unsigned int num_actions);
+
 static inline struct flow_rule *
 flow_cls_offload_flow_rule(struct flow_cls_offload *flow_cmd)
 {
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 83a6d0792180..3bb4e6f45038 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -258,6 +258,34 @@ static inline void tcf_exts_put_net(struct tcf_exts *exts)
 	for (; 0; (void)(i), (void)(a), (void)(exts))
 #endif
 
+#define tcf_act_for_each_action(i, a, actions) \
+	for (i = 0; i < TCA_ACT_MAX_PRIO && ((a) = actions[i]); i++)
+
+static inline bool tc_act_skip_hw(u32 flags)
+{
+	return (flags & TCA_ACT_FLAGS_SKIP_HW) ? true : false;
+}
+
+static inline bool tc_act_skip_sw(u32 flags)
+{
+	return (flags & TCA_ACT_FLAGS_SKIP_SW) ? true : false;
+}
+
+static inline bool tc_act_in_hw(u32 flags)
+{
+	return (flags & TCA_ACT_FLAGS_IN_HW) ? true : false;
+}
+
+/* SKIP_HW and SKIP_SW are mutually exclusive flags. */
+static inline bool tc_act_flags_valid(u32 flags)
+{
+	flags &= TCA_ACT_FLAGS_SKIP_HW | TCA_ACT_FLAGS_SKIP_SW;
+	if (!(flags ^ (TCA_ACT_FLAGS_SKIP_HW | TCA_ACT_FLAGS_SKIP_SW)))
+		return false;
+
+	return true;
+}
+
 static inline void
 tcf_exts_stats_update(const struct tcf_exts *exts,
 		      u64 bytes, u64 packets, u64 drops, u64 lastuse,
@@ -532,8 +560,19 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
 	return ifindex == skb->skb_iif;
 }
 
+#ifdef CONFIG_NET_CLS_ACT
 int tc_setup_flow_action(struct flow_action *flow_action,
 			 const struct tcf_exts *exts);
+#else
+static inline int tc_setup_flow_action(struct flow_action *flow_action,
+				       const struct tcf_exts *exts)
+{
+	return 0;
+}
+#endif
+
+int tc_setup_action(struct flow_action *flow_action,
+		    struct tc_action *actions[]);
 void tc_cleanup_flow_action(struct flow_action *flow_action);
 
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
@@ -554,6 +593,7 @@ int tc_setup_cb_reoffload(struct tcf_block *block, struct tcf_proto *tp,
 			  enum tc_setup_type type, void *type_data,
 			  void *cb_priv, u32 *flags, unsigned int *in_hw_count);
 unsigned int tcf_exts_num_actions(struct tcf_exts *exts);
+unsigned int tcf_act_num_actions_single(struct tc_action *act);
 
 #ifdef CONFIG_NET_CLS_ACT
 int tcf_qevent_init(struct tcf_qevent *qe, struct Qdisc *sch,
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 6836ccb9c45d..616e78cde822 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -19,13 +19,19 @@ enum {
 	TCA_ACT_FLAGS,
 	TCA_ACT_HW_STATS,
 	TCA_ACT_USED_HW_STATS,
+	TCA_ACT_IN_HW_COUNT,
 	__TCA_ACT_MAX
 };
 
 /* See other TCA_ACT_FLAGS_ * flags in include/net/act_api.h. */
-#define TCA_ACT_FLAGS_NO_PERCPU_STATS 1 /* Don't use percpu allocator for
-					 * actions stats.
-					 */
+#define TCA_ACT_FLAGS_NO_PERCPU_STATS (1 << 0) /* Don't use percpu allocator for
+						* actions stats.
+						*/
+#define TCA_ACT_FLAGS_SKIP_HW	(1 << 1) /* don't offload action to HW */
+#define TCA_ACT_FLAGS_SKIP_SW	(1 << 2) /* don't use action in SW */
+#define TCA_ACT_FLAGS_IN_HW	(1 << 3) /* action is offloaded to HW */
+#define TCA_ACT_FLAGS_NOT_IN_HW	(1 << 4) /* action isn't offloaded to HW */
+#define TCA_ACT_FLAGS_VERBOSE	(1 << 5) /* verbose logging */
 
 /* tca HW stats type
  * When user does not pass the attribute, he does not care.
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 6beaea13564a..6676431733ef 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -27,6 +27,27 @@ struct flow_rule *flow_rule_alloc(unsigned int num_actions)
 }
 EXPORT_SYMBOL(flow_rule_alloc);
 
+struct flow_offload_action *flow_action_alloc(unsigned int num_actions)
+{
+	struct flow_offload_action *fl_action;
+	int i;
+
+	fl_action = kzalloc(struct_size(fl_action, action.entries, num_actions),
+			    GFP_KERNEL);
+	if (!fl_action)
+		return NULL;
+
+	fl_action->action.num_entries = num_actions;
+	/* Pre-fill each action hw_stats with DONT_CARE.
+	 * Caller can override this if it wants stats for a given action.
+	 */
+	for (i = 0; i < num_actions; i++)
+		fl_action->action.entries[i].hw_stats = FLOW_ACTION_HW_STATS_DONT_CARE;
+
+	return fl_action;
+}
+EXPORT_SYMBOL(flow_action_alloc);
+
 #define FLOW_DISSECTOR_MATCH(__rule, __type, __out)				\
 	const struct flow_match *__m = &(__rule)->match;			\
 	struct flow_dissector *__d = (__m)->dissector;				\
@@ -549,19 +570,25 @@ int flow_indr_dev_setup_offload(struct net_device *dev,	struct Qdisc *sch,
 				void (*cleanup)(struct flow_block_cb *block_cb))
 {
 	struct flow_indr_dev *this;
+	u32 count = 0;
+	int err;
 
 	mutex_lock(&flow_indr_block_lock);
+	if (bo) {
+		if (bo->command == FLOW_BLOCK_BIND)
+			indir_dev_add(data, dev, sch, type, cleanup, bo);
+		else if (bo->command == FLOW_BLOCK_UNBIND)
+			indir_dev_remove(data);
+	}
 
-	if (bo->command == FLOW_BLOCK_BIND)
-		indir_dev_add(data, dev, sch, type, cleanup, bo);
-	else if (bo->command == FLOW_BLOCK_UNBIND)
-		indir_dev_remove(data);
-
-	list_for_each_entry(this, &flow_block_indr_dev_list, list)
-		this->cb(dev, sch, this->cb_priv, type, bo, data, cleanup);
+	list_for_each_entry(this, &flow_block_indr_dev_list, list) {
+		err = this->cb(dev, sch, this->cb_priv, type, bo, data, cleanup);
+		if (!err)
+			count++;
+	}
 
 	mutex_unlock(&flow_indr_block_lock);
 
-	return list_empty(&bo->cb_list) ? -EOPNOTSUPP : 0;
+	return (bo && list_empty(&bo->cb_list)) ? -EOPNOTSUPP : count;
 }
 EXPORT_SYMBOL(flow_indr_dev_setup_offload);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 7dd3a2dc5fa4..3e18f3456afa 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -21,6 +21,19 @@
 #include <net/pkt_cls.h>
 #include <net/act_api.h>
 #include <net/netlink.h>
+#include <net/tc_act/tc_pedit.h>
+#include <net/tc_act/tc_mirred.h>
+#include <net/tc_act/tc_vlan.h>
+#include <net/tc_act/tc_tunnel_key.h>
+#include <net/tc_act/tc_csum.h>
+#include <net/tc_act/tc_gact.h>
+#include <net/tc_act/tc_police.h>
+#include <net/tc_act/tc_sample.h>
+#include <net/tc_act/tc_skbedit.h>
+#include <net/tc_act/tc_ct.h>
+#include <net/tc_act/tc_mpls.h>
+#include <net/tc_act/tc_gate.h>
+#include <net/flow_offload.h>
 
 #ifdef CONFIG_INET
 DEFINE_STATIC_KEY_FALSE(tcf_frag_xmit_count);
@@ -145,6 +158,7 @@ static int __tcf_action_put(struct tc_action *p, bool bind)
 	if (refcount_dec_and_mutex_lock(&p->tcfa_refcnt, &idrinfo->lock)) {
 		if (bind)
 			atomic_dec(&p->tcfa_bindcnt);
+		tcf_action_offload_del(p);
 		idr_remove(&idrinfo->action_idr, p->tcfa_index);
 		mutex_unlock(&idrinfo->lock);
 
@@ -341,6 +355,7 @@ static int tcf_idr_release_unsafe(struct tc_action *p)
 		return -EPERM;
 
 	if (refcount_dec_and_test(&p->tcfa_refcnt)) {
+		tcf_action_offload_del(p);
 		idr_remove(&p->idrinfo->action_idr, p->tcfa_index);
 		tcf_action_cleanup(p);
 		return ACT_P_DELETED;
@@ -448,6 +463,7 @@ static int tcf_idr_delete_index(struct tcf_idrinfo *idrinfo, u32 index)
 		if (refcount_dec_and_test(&p->tcfa_refcnt)) {
 			struct module *owner = p->ops->owner;
 
+			tcf_action_offload_del(p);
 			WARN_ON(p != idr_remove(&idrinfo->action_idr,
 						p->tcfa_index));
 			mutex_unlock(&idrinfo->lock);
@@ -733,6 +749,9 @@ int tcf_action_exec(struct sk_buff *skb, struct tc_action **actions,
 			jmp_prgcnt -= 1;
 			continue;
 		}
+
+		if (tc_act_skip_sw(a->tcfa_flags))
+			continue;
 repeat:
 		ret = a->ops->act(skb, a, res);
 		if (ret == TC_ACT_REPEAT)
@@ -838,6 +857,9 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
 			       a->tcfa_flags, a->tcfa_flags))
 		goto nla_put_failure;
 
+	if (nla_put_u32(skb, TCA_ACT_IN_HW_COUNT, a->in_hw_count))
+		goto nla_put_failure;
+
 	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
 	if (nest == NULL)
 		goto nla_put_failure;
@@ -917,7 +939,9 @@ static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
 	[TCA_ACT_COOKIE]	= { .type = NLA_BINARY,
 				    .len = TC_COOKIE_MAX_SIZE },
 	[TCA_ACT_OPTIONS]	= { .type = NLA_NESTED },
-	[TCA_ACT_FLAGS]		= NLA_POLICY_BITFIELD32(TCA_ACT_FLAGS_NO_PERCPU_STATS),
+	[TCA_ACT_FLAGS]		= NLA_POLICY_BITFIELD32(TCA_ACT_FLAGS_NO_PERCPU_STATS |
+							TCA_ACT_FLAGS_SKIP_HW |
+							TCA_ACT_FLAGS_SKIP_SW),
 	[TCA_ACT_HW_STATS]	= NLA_POLICY_BITFIELD32(TCA_ACT_HW_STATS_ANY),
 };
 
@@ -1030,8 +1054,13 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 			}
 		}
 		hw_stats = tcf_action_hw_stats_get(tb[TCA_ACT_HW_STATS]);
-		if (tb[TCA_ACT_FLAGS])
+		if (tb[TCA_ACT_FLAGS]) {
 			userflags = nla_get_bitfield32(tb[TCA_ACT_FLAGS]);
+			if (!tc_act_flags_valid(userflags.value)) {
+				err = -EINVAL;
+				goto err_out;
+			}
+		}
 
 		err = a_o->init(net, tb[TCA_ACT_OPTIONS], est, &a, tp,
 				userflags.value | flags, extack);
@@ -1059,6 +1088,219 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	return ERR_PTR(err);
 }
 
+static int flow_action_init(struct flow_offload_action *fl_action,
+			    struct tc_action *act,
+			    enum flow_act_command cmd,
+			    struct netlink_ext_ack *extack)
+{
+	int err;
+
+	if (!fl_action)
+		return -EINVAL;
+
+	fl_action->extack = extack;
+	fl_action->command = cmd;
+	fl_action->index = act->tcfa_index;
+
+	if (is_tcf_gact_ok(act)) {
+		fl_action->id = FLOW_ACTION_ACCEPT;
+	} else if (is_tcf_gact_shot(act)) {
+		fl_action->id = FLOW_ACTION_DROP;
+	} else if (is_tcf_gact_trap(act)) {
+		fl_action->id = FLOW_ACTION_TRAP;
+	} else if (is_tcf_gact_goto_chain(act)) {
+		fl_action->id = FLOW_ACTION_GOTO;
+	} else if (is_tcf_mirred_egress_redirect(act)) {
+		fl_action->id = FLOW_ACTION_REDIRECT;
+	} else if (is_tcf_mirred_egress_mirror(act)) {
+		fl_action->id = FLOW_ACTION_MIRRED;
+	} else if (is_tcf_mirred_ingress_redirect(act)) {
+		fl_action->id = FLOW_ACTION_REDIRECT_INGRESS;
+	} else if (is_tcf_mirred_ingress_mirror(act)) {
+		fl_action->id = FLOW_ACTION_MIRRED_INGRESS;
+	} else if (is_tcf_vlan(act)) {
+		switch (tcf_vlan_action(act)) {
+		case TCA_VLAN_ACT_PUSH:
+			fl_action->id = FLOW_ACTION_VLAN_PUSH;
+			break;
+		case TCA_VLAN_ACT_POP:
+			fl_action->id = FLOW_ACTION_VLAN_POP;
+			break;
+		case TCA_VLAN_ACT_MODIFY:
+			fl_action->id = FLOW_ACTION_VLAN_MANGLE;
+			break;
+		default:
+			err = -EOPNOTSUPP;
+			goto err_out;
+		}
+	} else if (is_tcf_tunnel_set(act)) {
+		fl_action->id = FLOW_ACTION_TUNNEL_ENCAP;
+	} else if (is_tcf_tunnel_release(act)) {
+		fl_action->id = FLOW_ACTION_TUNNEL_DECAP;
+	} else if (is_tcf_pedit(act)) {
+		fl_action->id = FLOW_ACTION_PEDIT;
+	} else if (is_tcf_csum(act)) {
+		fl_action->id = FLOW_ACTION_CSUM;
+	} else if (is_tcf_skbedit_mark(act)) {
+		fl_action->id = FLOW_ACTION_MARK;
+	} else if (is_tcf_sample(act)) {
+		fl_action->id = FLOW_ACTION_SAMPLE;
+	} else if (is_tcf_police(act)) {
+		fl_action->id = FLOW_ACTION_POLICE;
+	} else if (is_tcf_ct(act)) {
+		fl_action->id = FLOW_ACTION_CT;
+	} else if (is_tcf_mpls(act)) {
+		switch (tcf_mpls_action(act)) {
+		case TCA_MPLS_ACT_PUSH:
+			fl_action->id = FLOW_ACTION_MPLS_PUSH;
+			break;
+		case TCA_MPLS_ACT_POP:
+			fl_action->id = FLOW_ACTION_MPLS_POP;
+			break;
+		case TCA_MPLS_ACT_MODIFY:
+			fl_action->id = FLOW_ACTION_MPLS_MANGLE;
+			break;
+		default:
+			err = -EOPNOTSUPP;
+			goto err_out;
+		}
+	} else if (is_tcf_skbedit_ptype(act)) {
+		fl_action->id = FLOW_ACTION_PTYPE;
+	} else if (is_tcf_skbedit_priority(act)) {
+		fl_action->id = FLOW_ACTION_PRIORITY;
+	} else if (is_tcf_gate(act)) {
+		fl_action->id = FLOW_ACTION_GATE;
+	} else {
+		goto err_out;
+	}
+	return 0;
+
+err_out:
+	return err;
+}
+
+static void flow_action_update_hw(struct tc_action *act,
+				  u32 hw_count,
+				  enum flow_act_hw_oper cmd)
+{
+	if (!act)
+		return;
+
+	switch (cmd) {
+	case FLOW_ACT_HW_ADD:
+		act->in_hw_count = hw_count;
+		break;
+	case FLOW_ACT_HW_UPDATE:
+		act->in_hw_count += hw_count;
+		break;
+	case FLOW_ACT_HW_DEL:
+		act->in_hw_count = act->in_hw_count > hw_count ?
+				   act->in_hw_count - hw_count : 0;
+		break;
+	default:
+		return;
+	}
+
+	if (act->in_hw_count) {
+		act->tcfa_flags &= ~TCA_ACT_FLAGS_NOT_IN_HW;
+		act->tcfa_flags |= TCA_ACT_FLAGS_IN_HW;
+	} else {
+		act->tcfa_flags &= ~TCA_ACT_FLAGS_IN_HW;
+		act->tcfa_flags |= TCA_ACT_FLAGS_NOT_IN_HW;
+	}
+}
+
+static int tcf_action_offload_cmd(struct flow_offload_action *fl_act,
+				  u32 *hw_count,
+				  struct netlink_ext_ack *extack)
+{
+	int err;
+
+	if (IS_ERR(fl_act))
+		return PTR_ERR(fl_act);
+
+	err = flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT, fl_act, NULL, NULL);
+
+	if (err < 0)
+		return err;
+
+	if (hw_count)
+		*hw_count = err;
+
+	return 0;
+}
+
+/* offload the tc command after inserted */
+static int tcf_action_offload_add(struct tc_action *action,
+				  struct netlink_ext_ack *extack)
+{
+	bool skip_sw = tc_act_skip_sw(action->tcfa_flags);
+	struct tc_action *actions[TCA_ACT_MAX_PRIO] = {
+		[0] = action,
+	};
+	struct flow_offload_action *fl_action;
+	u32 in_hw_count = 0;
+	int err = 0;
+
+	if (tc_act_skip_hw(action->tcfa_flags))
+		return 0;
+
+	fl_action = flow_action_alloc(tcf_act_num_actions_single(action));
+	if (!fl_action)
+		return -EINVAL;
+
+	err = flow_action_init(fl_action, action, FLOW_ACT_REPLACE, extack);
+	if (err)
+		goto fl_err;
+
+	err = tc_setup_action(&fl_action->action, actions);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed to setup tc actions for offload\n");
+		goto fl_err;
+	}
+
+	err = tcf_action_offload_cmd(fl_action, &in_hw_count, extack);
+	if (!err)
+		flow_action_update_hw(action, in_hw_count, FLOW_ACT_HW_ADD);
+
+	if (skip_sw && !tc_act_in_hw(action->tcfa_flags))
+		err = -EINVAL;
+
+	tc_cleanup_flow_action(&fl_action->action);
+
+fl_err:
+	kfree(fl_action);
+
+	return err;
+}
+
+int tcf_action_offload_del(struct tc_action *action)
+{
+	struct flow_offload_action fl_act;
+	u32 in_hw_count = 0;
+	int err = 0;
+
+	if (!action)
+		return -EINVAL;
+
+	if (!tc_act_in_hw(action->tcfa_flags))
+		return 0;
+
+	err = flow_action_init(&fl_act, action, FLOW_ACT_DESTROY, NULL);
+	if (err)
+		return err;
+
+	err = tcf_action_offload_cmd(&fl_act, &in_hw_count, NULL);
+	if (err)
+		return err;
+
+	if (action->in_hw_count != in_hw_count)
+		return -EINVAL;
+
+	return 0;
+}
+
 /* Returns numbers of initialized actions or negative error. */
 
 int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
@@ -1101,6 +1343,11 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 		sz += tcf_action_fill_size(act);
 		/* Start from index 0 */
 		actions[i - 1] = act;
+		if (!(flags & TCA_ACT_FLAGS_BIND)) {
+			err = tcf_action_offload_add(act, extack);
+			if (tc_act_skip_sw(act->tcfa_flags) && err)
+				goto err;
+		}
 	}
 
 	/* We have to commit them all together, because if any error happened in
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2ef8f5a6205a..351d93988b8b 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3544,8 +3544,8 @@ static enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
 	return hw_stats;
 }
 
-int tc_setup_flow_action(struct flow_action *flow_action,
-			 const struct tcf_exts *exts)
+int tc_setup_action(struct flow_action *flow_action,
+		    struct tc_action *actions[])
 {
 	struct tc_action *act;
 	int i, j, k, err = 0;
@@ -3554,11 +3554,11 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 	BUILD_BUG_ON(TCA_ACT_HW_STATS_IMMEDIATE != FLOW_ACTION_HW_STATS_IMMEDIATE);
 	BUILD_BUG_ON(TCA_ACT_HW_STATS_DELAYED != FLOW_ACTION_HW_STATS_DELAYED);
 
-	if (!exts)
+	if (!actions)
 		return 0;
 
 	j = 0;
-	tcf_exts_for_each_action(i, act, exts) {
+	tcf_act_for_each_action(i, act, actions) {
 		struct flow_action_entry *entry;
 
 		entry = &flow_action->entries[j];
@@ -3725,7 +3725,19 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 	spin_unlock_bh(&act->tcfa_lock);
 	goto err_out;
 }
+EXPORT_SYMBOL(tc_setup_action);
+
+#ifdef CONFIG_NET_CLS_ACT
+int tc_setup_flow_action(struct flow_action *flow_action,
+			 const struct tcf_exts *exts)
+{
+	if (!exts)
+		return 0;
+
+	return tc_setup_action(flow_action, exts->actions);
+}
 EXPORT_SYMBOL(tc_setup_flow_action);
+#endif
 
 unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
 {
@@ -3743,6 +3755,15 @@ unsigned int tcf_exts_num_actions(struct tcf_exts *exts)
 }
 EXPORT_SYMBOL(tcf_exts_num_actions);
 
+unsigned int tcf_act_num_actions_single(struct tc_action *act)
+{
+	if (is_tcf_pedit(act))
+		return tcf_pedit_nkeys(act);
+	else
+		return 1;
+}
+EXPORT_SYMBOL(tcf_act_num_actions_single);
+
 #ifdef CONFIG_NET_CLS_ACT
 static int tcf_qevent_parse_block_index(struct nlattr *block_index_attr,
 					u32 *p_block_index,
-- 
2.20.1

