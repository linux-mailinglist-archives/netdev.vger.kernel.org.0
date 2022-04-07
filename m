Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCCDF4F77C4
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 09:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241954AbiDGHkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 03:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241952AbiDGHj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 03:39:58 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21FB3EF24
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 00:37:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QEXmdsC55rizrIaFkFruE5ldqVYpyOdTCfcbl6q3FYwvss03sPhQFdP4Hw1+PuND//J/6cX9EyRHkU107tf0rTtMDRZ1znQkyAhFUNDM2t6Xg5frBpKGLsdECYj53VZDVUtxx0i23RP3XXurqCUzajIKxMWq6+ZIFwiZnbonzgZ/q91UgUFMqXe2uqUa+sEzMv4AElYH6z0ErYW8pMc4SBtU7avPUMYWlGqcfH+Lk0QsH9B7WEB30BK29J8KyXBUKqFMiLBEZgtF4j8FdJ4gYj6WwOvUYPRdZEpllP+5Ck4l4YoDeES2j1yiTwDwikALqxH6Cbm21Tvu45EMahmA3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lXZ1Ezroy5uPL38/RX9gI3SseevwHbxB3nhfJq8RfFM=;
 b=Xxejq9OcqHwm6yvrcmdSrWmrIYeXmAHarPT+fhWK3DUg3brOrnEOEplpojxePrTnYGFakW3Kp4amEwk6Qw3OtN99EZgv26Ojr/YKA664Ct0xd0+DubUIGeOd+AZQl0cbWDpYMHNR+Y4FBSdrCfvAeE2ixT9Olxf7+1guvuoaYpp2LmnJWl3AB1wFB4E2OGJxrcInh9808ioMmVSDAlgYCiWl5NTkLOEWIa7lw0Oi4/ZTiTY1S9vtSEcLEtf1+1ufxQrE1pVgcLXV/wuFblWXGczvWcAeyn1BJtZh4QiqZQs+p7O/us3ByIa7niKFW1AIAB27XQ8DjcIGUE6v1SoBCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lXZ1Ezroy5uPL38/RX9gI3SseevwHbxB3nhfJq8RfFM=;
 b=seJ/ZrXVg6SuxHkmdL20Wm7LjOpPW/2UDETrxFgX/5zE3i0i6NDOGcJihjcpLODCRE/TwAPLyuAM1624jYhARznTMAhARvfhDb2fAZxxyDjQq9U1ehITcc4Hipnoy1536wj8zpt8dzxXDlP5+L5qzn58P9oB9oqCb2QnMRpxo7EB4DiMWR/qxyn04JSreXFZV8BrGx4AizfmS+bCuoi5OegHFm561BIX9rL8Lt4BtWfUKYg/GUeiBI8WFFyNaa5iMGbjqKBv/d9VNlZnP4J859hnvQlgBybP/JLK9C73lywoN2Iv1UTzz4dc5Qna8AYHceas66rFR+wzyvZiePBckg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM5PR1201MB0188.namprd12.prod.outlook.com (2603:10b6:4:56::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Thu, 7 Apr
 2022 07:37:57 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::4c9:9b43:f068:7ee2%2]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 07:37:57 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        petrm@nvidia.com, jianbol@nvidia.com, roid@nvidia.com,
        vladbu@nvidia.com, olteanv@gmail.com, simon.horman@corigine.com,
        baowen.zheng@corigine.com, marcelo.leitner@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/14] net/sched: act_api: Add extack to offload_act_setup() callback
Date:   Thu,  7 Apr 2022 10:35:22 +0300
Message-Id: <20220407073533.2422896-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220407073533.2422896-1-idosch@nvidia.com>
References: <20220407073533.2422896-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0059.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::48) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91ee9266-2a63-4b85-19d8-08da18698897
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0188:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0188FC3D71A3E9631A2E51CDB2E69@DM5PR1201MB0188.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uINeOSIBiQTCQ+SIqFSFWVf/aYexTB+m/Ti1R6zeAToZzQMLvp8LL/pXkboPxyEbJJEwFTFxj0NlgiTKn8sdcJHfTdeLIdFigU/64bYkmW+t4LCi923aAR+KsH85DUK8Pd2TSotbwSaOcjNyCQY8nFJatxAyB5/2znG176dFHWPet7Sc8XX/jH3N4pg2kh4T/9WEEA6MjlsplG9P9P42dG8KqzChbEcYInm/vMsJ3Sk0yhmtwP8kqCPObILYCp+o0bAr1yeUISeANvD+NvUkf+Jh5uTHJPzxUPAUZLLiR80CznqbkqXWPLyyCW75Jcd73ldMNeVKtIE5ARs4CGtiJGW/tnlTgmjGvifilXqFUhaEn9AImwFkU8zJ3KMYcYDN5mWYpnmDgAR0KDc3eehZQRzRHOUweqMHPXDhIU1rfXvo2ZPsDLcyo2emvokqm5hJax23voPl46HlR4Y/9uPqbU/V3wzme456XGlDQBAl39pa++UHTBscoqLl8vKL8oRBnP9gUZTsvbclzzSR2rzpRHG8IKxXTrFhBzjzR+bFC1TdAcFH1XUGyk2NaCLsCQBGj6cIWEWqZSyXVWFPdwk1YLWJNKPkX1VOMVp3jVo7FDuHArv/cWCg7j+tu2emqX+svtdsWGNKYypiMBNgCQDNwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(6666004)(38100700002)(186003)(26005)(2906002)(6512007)(83380400001)(30864003)(6506007)(1076003)(36756003)(316002)(6916009)(508600001)(6486002)(4326008)(66946007)(7416002)(66476007)(86362001)(8936002)(8676002)(2616005)(5660300002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?onngeOf+yWwGTaOYHRBFS6IbWtK/IxuN5htDuBX1llY6RI1JJyagAmLXrsbK?=
 =?us-ascii?Q?q9MfWFYk4j9TVQBnDBiTwx1yxVwTPhdIY669oJAVPt04nxppFe7y04XxB2RJ?=
 =?us-ascii?Q?CY6Nfl19mSOYYduyk2jKOtrt7d5sKRO6+FMWvnXp9/tFizTZaLVPSTyIoc/a?=
 =?us-ascii?Q?56i+e2FQA2SMo8/5rk635tX1hR+bVZOIEIHpJgWXw1xI8IJqeUjIfua8mGZo?=
 =?us-ascii?Q?IY98i7LgfhSexFDg3HBeAj7BWsG2bjHOFxMEWQio/9ag9CBONWkOd1Tad7+q?=
 =?us-ascii?Q?mfynredukwe6pQ0sH2MaIRYE5oz8Mh2sQEQgyIYI/lIdvXjvUXQvdGdQ3TTp?=
 =?us-ascii?Q?z9y9yPYwiOahlrgfcvPJssz1jKiEaSqfR3ztA8jGZq7s41GzmrqiIXG+S+l2?=
 =?us-ascii?Q?PEZx5zyFFThIRZ+hsNLk2RRnVdZ3qjtjrYTtuTmhwp4k3VmUxpJsXN0cCDM7?=
 =?us-ascii?Q?WpW1o4uAPT+XgmWWEgqF8sX19CpExCoQ0+5JdSdw/7QFy7AYHT0pSqYXPtqY?=
 =?us-ascii?Q?6+Kd3+cjIDbEKXU63OPaeOP895JBsjOMhvI2QYlDzzbiMsjK2DZETmUwzGlw?=
 =?us-ascii?Q?xyWLjTOEMTRuFCejtj7M7Y9ujB6FToKoxqUJ6IYDJuChoZqs0TAzA5lP85fd?=
 =?us-ascii?Q?7hUQ5EWAmuV7KdVemGjgncL7aQjjx44TFjBq7dW0aCq6sG7kKjRc7wgWNiCv?=
 =?us-ascii?Q?xI5wFcxKpGuVOjTpkGTnPyOFAsVFp6JN0QP+lEww49Rey7MyOPPD8D7S+Gfe?=
 =?us-ascii?Q?x2AXATZFiGiPNj7w4sUFDacE9+DMdo/x/9XYBZjuihsT9vYPg7djQCYG9/sI?=
 =?us-ascii?Q?V8Sobz0ftgwiSfISiULSqGF3XYalErPB8vItPerLkYwuZS8XtYThwTHp2f3c?=
 =?us-ascii?Q?IlKtkjfgHR4ZSZ2ypeO/IB5a+tWFzB17OoyXG24x34PfttLrT33zR/lyi3kS?=
 =?us-ascii?Q?kztYm20oH5mGr2cJC6OWmPi4Gf8PLpmzvFDziRgwVkiOT3/cyJeph3HDibs0?=
 =?us-ascii?Q?cGkjAVtjw1uWoO13WMLhe/WGIBEq+62obSXoOofCu09zCMKCUh34LaYzj8Ho?=
 =?us-ascii?Q?XV4Y8hd+oJoGRPAgSmXucDcos6zCoP8Q4o5qSSkEmuGoG2c9YGuWkpEPgGWb?=
 =?us-ascii?Q?cK5MUJwPmsbUelp6c4znqLaGhRsyL3T6lWale1z8mkcC4gNgi/2Lf8P7t3x7?=
 =?us-ascii?Q?lyHh3zrgMvJ4F8hY3vGs7EfUD9Gg76ScpZ+XMKiGHwhpm+nN3xjpmcVBOR6d?=
 =?us-ascii?Q?Lm/Sc866Z5N8aQ1UY02Im0CmxyPawZUYHDKQrTD1mhFvIR+gAzIic0ol/bHO?=
 =?us-ascii?Q?IvIoSF82jvByptEEBI4puawh0lzTydYEntX19+6lk/Z2oWrHAv10z9sPp0bI?=
 =?us-ascii?Q?NOq6dUKUre5F2wWY9nlSp8G+VU84dwAyRLFL6a1NOyU5TWicHeLl1Ak/E/zt?=
 =?us-ascii?Q?EJlNVxMu9i60U+EJwsJ/G7AJDnwzP+3IjtvPY1d6A84l9rOAj4BMFj4zjhj4?=
 =?us-ascii?Q?YL6bekU2MlUgPcp9zRZYgHnFcKmJPNeGoYCulOJx0TN6gqKjFLbrvyAxENzQ?=
 =?us-ascii?Q?4A8QgYCTJKCYZy7Lw3OXn2OpTxQIQCLQ19i4zfB688IMeD+Kh5ZSwsuHJnqK?=
 =?us-ascii?Q?5wxxlwp3mpGRffaD7xSHv5omhg5FyTuR0FUaUQ4eiLEEDcC/0IKPY3wQpJ/f?=
 =?us-ascii?Q?PNKr3l/4f4eScWDl88Y9/z3Lm5//Gm5TmY4OjLSiQ4isKw4n0Cwm7ZcTt3xh?=
 =?us-ascii?Q?SQbzFSUouw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91ee9266-2a63-4b85-19d8-08da18698897
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:37:57.0312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VI0Ks9vuE/dzVMEYo7UZI47ZZDeEN/Qek9ZOvNOyTs7Tbh5blV+IbOcrFUpTXwYSroCtWlv51z4U9GqMDOrh+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0188
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The callback is used by various actions to populate the flow action
structure prior to offload. Pass extack to this callback so that the
various actions will be able to report accurate error messages to user
space.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 include/net/act_api.h      |  3 ++-
 include/net/pkt_cls.h      |  6 ++++--
 net/sched/act_api.c        |  4 ++--
 net/sched/act_csum.c       |  3 ++-
 net/sched/act_ct.c         |  3 ++-
 net/sched/act_gact.c       |  3 ++-
 net/sched/act_gate.c       |  3 ++-
 net/sched/act_mirred.c     |  3 ++-
 net/sched/act_mpls.c       |  3 ++-
 net/sched/act_pedit.c      |  3 ++-
 net/sched/act_police.c     |  3 ++-
 net/sched/act_sample.c     |  3 ++-
 net/sched/act_skbedit.c    |  3 ++-
 net/sched/act_tunnel_key.c |  3 ++-
 net/sched/act_vlan.c       |  3 ++-
 net/sched/cls_api.c        | 16 ++++++++++------
 net/sched/cls_flower.c     |  6 ++++--
 net/sched/cls_matchall.c   |  6 ++++--
 18 files changed, 50 insertions(+), 27 deletions(-)

diff --git a/include/net/act_api.h b/include/net/act_api.h
index 3049cb69c025..9cf6870b526e 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -134,7 +134,8 @@ struct tc_action_ops {
 	(*get_psample_group)(const struct tc_action *a,
 			     tc_action_priv_destructor *destructor);
 	int     (*offload_act_setup)(struct tc_action *act, void *entry_data,
-				     u32 *index_inc, bool bind);
+				     u32 *index_inc, bool bind,
+				     struct netlink_ext_ack *extack);
 };
 
 struct tc_action_net {
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index a3b57a93228a..8cf001aed858 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -547,10 +547,12 @@ tcf_match_indev(struct sk_buff *skb, int ifindex)
 }
 
 int tc_setup_offload_action(struct flow_action *flow_action,
-			    const struct tcf_exts *exts);
+			    const struct tcf_exts *exts,
+			    struct netlink_ext_ack *extack);
 void tc_cleanup_offload_action(struct flow_action *flow_action);
 int tc_setup_action(struct flow_action *flow_action,
-		    struct tc_action *actions[]);
+		    struct tc_action *actions[],
+		    struct netlink_ext_ack *extack);
 
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
 		     void *type_data, bool err_stop, bool rtnl_held);
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 4f51094da9da..da9733da9868 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -195,7 +195,7 @@ static int offload_action_init(struct flow_offload_action *fl_action,
 	if (act->ops->offload_act_setup) {
 		spin_lock_bh(&act->tcfa_lock);
 		err = act->ops->offload_act_setup(act, fl_action, NULL,
-						  false);
+						  false, extack);
 		spin_unlock_bh(&act->tcfa_lock);
 		return err;
 	}
@@ -271,7 +271,7 @@ static int tcf_action_offload_add_ex(struct tc_action *action,
 	if (err)
 		goto fl_err;
 
-	err = tc_setup_action(&fl_action->action, actions);
+	err = tc_setup_action(&fl_action->action, actions, extack);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Failed to setup tc actions for offload");
diff --git a/net/sched/act_csum.c b/net/sched/act_csum.c
index e0f515b774ca..22847ee009ef 100644
--- a/net/sched/act_csum.c
+++ b/net/sched/act_csum.c
@@ -696,7 +696,8 @@ static size_t tcf_csum_get_fill_size(const struct tc_action *act)
 }
 
 static int tcf_csum_offload_act_setup(struct tc_action *act, void *entry_data,
-				      u32 *index_inc, bool bind)
+				      u32 *index_inc, bool bind,
+				      struct netlink_ext_ack *extack)
 {
 	if (bind) {
 		struct flow_action_entry *entry = entry_data;
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index b1f502fce595..8af9d6e5ba61 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1584,7 +1584,8 @@ static void tcf_stats_update(struct tc_action *a, u64 bytes, u64 packets,
 }
 
 static int tcf_ct_offload_act_setup(struct tc_action *act, void *entry_data,
-				    u32 *index_inc, bool bind)
+				    u32 *index_inc, bool bind,
+				    struct netlink_ext_ack *extack)
 {
 	if (bind) {
 		struct flow_action_entry *entry = entry_data;
diff --git a/net/sched/act_gact.c b/net/sched/act_gact.c
index bde6a6c01e64..db84a0473cc1 100644
--- a/net/sched/act_gact.c
+++ b/net/sched/act_gact.c
@@ -253,7 +253,8 @@ static size_t tcf_gact_get_fill_size(const struct tc_action *act)
 }
 
 static int tcf_gact_offload_act_setup(struct tc_action *act, void *entry_data,
-				      u32 *index_inc, bool bind)
+				      u32 *index_inc, bool bind,
+				      struct netlink_ext_ack *extack)
 {
 	if (bind) {
 		struct flow_action_entry *entry = entry_data;
diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index d56e73843a4b..fd5155274733 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -619,7 +619,8 @@ static int tcf_gate_get_entries(struct flow_action_entry *entry,
 }
 
 static int tcf_gate_offload_act_setup(struct tc_action *act, void *entry_data,
-				      u32 *index_inc, bool bind)
+				      u32 *index_inc, bool bind,
+				      struct netlink_ext_ack *extack)
 {
 	int err;
 
diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 39acd1d18609..70a6a4447e6b 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -460,7 +460,8 @@ static void tcf_offload_mirred_get_dev(struct flow_action_entry *entry,
 }
 
 static int tcf_mirred_offload_act_setup(struct tc_action *act, void *entry_data,
-					u32 *index_inc, bool bind)
+					u32 *index_inc, bool bind,
+					struct netlink_ext_ack *extack)
 {
 	if (bind) {
 		struct flow_action_entry *entry = entry_data;
diff --git a/net/sched/act_mpls.c b/net/sched/act_mpls.c
index b9ff3459fdab..23fcfa5605df 100644
--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -385,7 +385,8 @@ static int tcf_mpls_search(struct net *net, struct tc_action **a, u32 index)
 }
 
 static int tcf_mpls_offload_act_setup(struct tc_action *act, void *entry_data,
-				      u32 *index_inc, bool bind)
+				      u32 *index_inc, bool bind,
+				      struct netlink_ext_ack *extack)
 {
 	if (bind) {
 		struct flow_action_entry *entry = entry_data;
diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 31fcd279c177..dc12d502c4fe 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -488,7 +488,8 @@ static int tcf_pedit_search(struct net *net, struct tc_action **a, u32 index)
 }
 
 static int tcf_pedit_offload_act_setup(struct tc_action *act, void *entry_data,
-				       u32 *index_inc, bool bind)
+				       u32 *index_inc, bool bind,
+				       struct netlink_ext_ack *extack)
 {
 	if (bind) {
 		struct flow_action_entry *entry = entry_data;
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index f4d917705263..77c17e9b46d1 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -442,7 +442,8 @@ static int tcf_police_act_to_flow_act(int tc_act, u32 *extval)
 }
 
 static int tcf_police_offload_act_setup(struct tc_action *act, void *entry_data,
-					u32 *index_inc, bool bind)
+					u32 *index_inc, bool bind,
+					struct netlink_ext_ack *extack)
 {
 	if (bind) {
 		struct flow_action_entry *entry = entry_data;
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 9a22cdda6bbd..2f7f5e44d28c 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -291,7 +291,8 @@ static void tcf_offload_sample_get_group(struct flow_action_entry *entry,
 }
 
 static int tcf_sample_offload_act_setup(struct tc_action *act, void *entry_data,
-					u32 *index_inc, bool bind)
+					u32 *index_inc, bool bind,
+					struct netlink_ext_ack *extack)
 {
 	if (bind) {
 		struct flow_action_entry *entry = entry_data;
diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
index ceba11b198bb..8cd8e506c9c9 100644
--- a/net/sched/act_skbedit.c
+++ b/net/sched/act_skbedit.c
@@ -328,7 +328,8 @@ static size_t tcf_skbedit_get_fill_size(const struct tc_action *act)
 }
 
 static int tcf_skbedit_offload_act_setup(struct tc_action *act, void *entry_data,
-					 u32 *index_inc, bool bind)
+					 u32 *index_inc, bool bind,
+					 struct netlink_ext_ack *extack)
 {
 	if (bind) {
 		struct flow_action_entry *entry = entry_data;
diff --git a/net/sched/act_tunnel_key.c b/net/sched/act_tunnel_key.c
index 23aba03d26a8..3c6f40478c81 100644
--- a/net/sched/act_tunnel_key.c
+++ b/net/sched/act_tunnel_key.c
@@ -808,7 +808,8 @@ static int tcf_tunnel_encap_get_tunnel(struct flow_action_entry *entry,
 static int tcf_tunnel_key_offload_act_setup(struct tc_action *act,
 					    void *entry_data,
 					    u32 *index_inc,
-					    bool bind)
+					    bool bind,
+					    struct netlink_ext_ack *extack)
 {
 	int err;
 
diff --git a/net/sched/act_vlan.c b/net/sched/act_vlan.c
index 883454c4f921..8c89bce99cbd 100644
--- a/net/sched/act_vlan.c
+++ b/net/sched/act_vlan.c
@@ -369,7 +369,8 @@ static size_t tcf_vlan_get_fill_size(const struct tc_action *act)
 }
 
 static int tcf_vlan_offload_act_setup(struct tc_action *act, void *entry_data,
-				      u32 *index_inc, bool bind)
+				      u32 *index_inc, bool bind,
+				      struct netlink_ext_ack *extack)
 {
 	if (bind) {
 		struct flow_action_entry *entry = entry_data;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 2957f8f5cea7..dd711ae048ff 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3513,11 +3513,13 @@ EXPORT_SYMBOL(tc_cleanup_offload_action);
 
 static int tc_setup_offload_act(struct tc_action *act,
 				struct flow_action_entry *entry,
-				u32 *index_inc)
+				u32 *index_inc,
+				struct netlink_ext_ack *extack)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	if (act->ops->offload_act_setup)
-		return act->ops->offload_act_setup(act, entry, index_inc, true);
+		return act->ops->offload_act_setup(act, entry, index_inc, true,
+						   extack);
 	else
 		return -EOPNOTSUPP;
 #else
@@ -3526,7 +3528,8 @@ static int tc_setup_offload_act(struct tc_action *act,
 }
 
 int tc_setup_action(struct flow_action *flow_action,
-		    struct tc_action *actions[])
+		    struct tc_action *actions[],
+		    struct netlink_ext_ack *extack)
 {
 	int i, j, index, err = 0;
 	struct tc_action *act;
@@ -3551,7 +3554,7 @@ int tc_setup_action(struct flow_action *flow_action,
 		entry->hw_stats = tc_act_hw_stats(act->hw_stats);
 		entry->hw_index = act->tcfa_index;
 		index = 0;
-		err = tc_setup_offload_act(act, entry, &index);
+		err = tc_setup_offload_act(act, entry, &index, extack);
 		if (!err)
 			j += index;
 		else
@@ -3570,13 +3573,14 @@ int tc_setup_action(struct flow_action *flow_action,
 }
 
 int tc_setup_offload_action(struct flow_action *flow_action,
-			    const struct tcf_exts *exts)
+			    const struct tcf_exts *exts,
+			    struct netlink_ext_ack *extack)
 {
 #ifdef CONFIG_NET_CLS_ACT
 	if (!exts)
 		return 0;
 
-	return tc_setup_action(flow_action, exts->actions);
+	return tc_setup_action(flow_action, exts->actions, extack);
 #else
 	return 0;
 #endif
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 70e95ce28ffd..acf827b0e30a 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -464,7 +464,8 @@ static int fl_hw_replace_filter(struct tcf_proto *tp,
 	cls_flower.rule->match.key = &f->mkey;
 	cls_flower.classid = f->res.classid;
 
-	err = tc_setup_offload_action(&cls_flower.rule->action, &f->exts);
+	err = tc_setup_offload_action(&cls_flower.rule->action, &f->exts,
+				      cls_flower.common.extack);
 	if (err) {
 		kfree(cls_flower.rule);
 		NL_SET_ERR_MSG_MOD(cls_flower.common.extack,
@@ -2353,7 +2354,8 @@ static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 		cls_flower.rule->match.mask = &f->mask->key;
 		cls_flower.rule->match.key = &f->mkey;
 
-		err = tc_setup_offload_action(&cls_flower.rule->action, &f->exts);
+		err = tc_setup_offload_action(&cls_flower.rule->action, &f->exts,
+					      cls_flower.common.extack);
 		if (err) {
 			kfree(cls_flower.rule);
 			NL_SET_ERR_MSG_MOD(cls_flower.common.extack,
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 37283b306924..7553443e1ae7 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -97,7 +97,8 @@ static int mall_replace_hw_filter(struct tcf_proto *tp,
 	cls_mall.command = TC_CLSMATCHALL_REPLACE;
 	cls_mall.cookie = cookie;
 
-	err = tc_setup_offload_action(&cls_mall.rule->action, &head->exts);
+	err = tc_setup_offload_action(&cls_mall.rule->action, &head->exts,
+				      cls_mall.common.extack);
 	if (err) {
 		kfree(cls_mall.rule);
 		mall_destroy_hw_filter(tp, head, cookie, NULL);
@@ -300,7 +301,8 @@ static int mall_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 		TC_CLSMATCHALL_REPLACE : TC_CLSMATCHALL_DESTROY;
 	cls_mall.cookie = (unsigned long)head;
 
-	err = tc_setup_offload_action(&cls_mall.rule->action, &head->exts);
+	err = tc_setup_offload_action(&cls_mall.rule->action, &head->exts,
+				      cls_mall.common.extack);
 	if (err) {
 		kfree(cls_mall.rule);
 		NL_SET_ERR_MSG_MOD(cls_mall.common.extack,
-- 
2.33.1

