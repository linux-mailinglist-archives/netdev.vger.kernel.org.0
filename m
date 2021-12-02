Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF7E466739
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 16:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347604AbhLBPy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 10:54:59 -0500
Received: from mail-eopbgr80135.outbound.protection.outlook.com ([40.107.8.135]:16078
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1347568AbhLBPy7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 10:54:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVVyhWknnUCmvWXrEwG3bwFtetosG5Bj/UdvvyzQcDUgp96aaxM76bInIh71YRcZi1fZlYryDOlrSTZX9mMXKG62gnIYK6dlwQ36nVMW7Xr1inwggWA7Fur6ZCVAPr/EN1CdiPpygVXvr36hsoRodgyVqGyHu5wty6EkIakDL4TbvObu4RRMbA3ORL1RxQztMKCHxlBkNtVJzzyrsd8qDhuzjEtF+OE2j7KICYkLYzdRo5X5uLBs8/v3WDBlP+/DPnQleArO+VrORe69GPf3rjKQkQp+ZRph3SDH7bQoeuWRyyYqdoXVZlev1PLVPj2l+oU42oDRRXsD/mYRX47cuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ahvq9lMzOmz2nOKmIUT3vnR0ZbrJ4dpi9pC6/pQEopg=;
 b=Sd+vTFqi6BSyEjh8qY1BUygE9rlqlEaDMsyWR5PspeMdVXJ2tW5hyfz8dKLnk+zmbL0uIlw9oRqaFH4S66Ll+xJTRV7Ol6VgNi2AqJbms+GHGNXJVBBHoTdQ6f7VK0UIieQQYLlPOB1as46S0kiB3krpqduQ4SX56TIvyRcHrUC/vP1OxLa7jK3eOpE2taBmwosUukgvGvcI0xEnNDQILjRUDkQImgI6XKyQ1eQ8qbnpd6Jqn3lr484J4uvnr4UFR7yCLQ2HIqNNkbw5uX0JdkDoBh+wekwuPvo4Kae/fzlQraUe3xvMtjDYyBzGkUuspbaS3/mVn5wyXoN4NyWkAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ahvq9lMzOmz2nOKmIUT3vnR0ZbrJ4dpi9pC6/pQEopg=;
 b=j5Sq8sODl+nOp9OiMXQh1Lmo71l1nUtHGDTr9zmSWP8ul24kgjKXO/zRiFImBI3PdePNT3YYnGOI14B86rmBdgwJgi8Tz+AcOwmvwuHB7kj3cfalrfZbDLiJBbEKRwkvpE2nZOkN4SMGnnpngzkF8gb+e+a3eM/6n/z3BZ7jjOw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0527.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:2e::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Thu, 2 Dec
 2021 15:51:33 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136%4]) with mapi id 15.20.4755.016; Thu, 2 Dec 2021
 15:51:33 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: prestera: flower template support
Date:   Thu,  2 Dec 2021 17:50:58 +0200
Message-Id: <1638460259-12619-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: BE0P281CA0030.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:14::17) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
Received: from vmytnykub.x.ow.s (217.20.186.93) by BE0P281CA0030.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:14::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.4755.9 via Frontend Transport; Thu, 2 Dec 2021 15:51:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d1b3843-ad3e-4196-0549-08d9b5ab9d70
X-MS-TrafficTypeDiagnostic: VI1P190MB0527:
X-Microsoft-Antispam-PRVS: <VI1P190MB05275E97C39732585046E5BC8F699@VI1P190MB0527.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wfKps2glHHOePaETdx0MldLBwN+4FbI+k3TMXUBXCFeglO1MgvBdzdpN3y6tpzArTCW/vAzSejV+tfcK48El5dNJcGvucdUwdTFrvg8QxhIsa1avKELqe6G9hE/mN19AOUtTVyy68f/I8F4QrR587gospptLHjvJvMVhXH2tBUazf31Zdahp/gpLLotDXsu1NZ/N3L25tg++vUctQEzbQzIuW1h3CIwLec7g6xNEB5fCQLpuOiu8dYNSaOk2ays2Gal0KYbGPAaBWKfMG8E6jZBs8vuVI3Ptf2mI8SGBH4XmxYQLtaqBj9wpCkdeD0TOimQXFirSLfqlNCUDIdAFAPZFU6cyqFGBaMqkRWTVWHc6rXfPX1zSKaiGZjNdD0e0HlgWEI5m/picw9Wre4TjjGrUIqy/xXwvnE7xcIrV3EnO8SCFHeZXUYTJnr95VsAq5pphTb186zOaG6FVxIZy/K9Wo61QG2D12JJ31CT74nGsZBgu0FVy9oDcPCQ2e56ockmxzawkTakaw5Wn7RI6XKOI2WoqoN+wARq0TnYzI3eUU5JmWD/3ZRFq9eQpZQaiYf+KXM5niynWTC2JuT3gifc9zkK1ktBQFx9ta+Q2FqvhGccQA9tqd3RzKhECFh9iQPh1D/cnqbnGHeolwYvOGLXO/rJqFQK4PHmVgg3U9RjhZp75jZZmclsGJ4YNjExz4mdppflhTY1mLO/9px3wig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(346002)(39830400003)(396003)(366004)(376002)(2616005)(83380400001)(5660300002)(6512007)(66476007)(6506007)(186003)(36756003)(2906002)(52116002)(38100700002)(38350700002)(8676002)(86362001)(508600001)(54906003)(66556008)(44832011)(6486002)(6916009)(26005)(6666004)(956004)(316002)(8936002)(4326008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KSnRv80NSY+0n3+3KC9h/qapu2nKARYB18uftvisBDf6m2C7jwxI/7EKGe01?=
 =?us-ascii?Q?yYzXE0k/L+oX4KYiUoZ4hWejp6jXsgJG25CTeMA5j1k9OVqREMpZ6P8TO0M8?=
 =?us-ascii?Q?spCogbCWjnxx36ZKmCOPYneQ9rTVLYaco5drzgSct0tKrgd0ubWsE/vAWnFV?=
 =?us-ascii?Q?YsV74U9B4F/n7nS5DMKf/N6d7wyw5RhidvnuSJZVbe1e2rkdDFlpurtlVS39?=
 =?us-ascii?Q?wN90RWG7hZPQpSfyb/7PJ8OZW35Elg7OsvdhSP6RiOWOD0FBgvonjyv7J5k0?=
 =?us-ascii?Q?rLF2uqI2evJoz66R0UOufImqBPrec0cq8sFqOJ/uX2mpRkT/sZc1EnXz1tMb?=
 =?us-ascii?Q?3ulOLBn+IP4cdhiHRxPG1GLYlc3f+iIuhmBL3fYPvfEZg0LIZVBoQZLNJjnm?=
 =?us-ascii?Q?tV8RUSfp4qh00A1YUDT9SQFdBHRx8LHSlQFvpM/5bzmidNJvt6BTt5c6dcdD?=
 =?us-ascii?Q?gJdjDZXl88YkXGSjo7lQDUXeqzRdK7t809j5ehnUdcHz/b+oeP7jgQzZGqTP?=
 =?us-ascii?Q?5lxBo0IYoj8CW+E/q7X+G4IznJK28jV1SR/D1T8r0fJ69BfpNgAEmiLENJjU?=
 =?us-ascii?Q?F7vCJAJKfBwUe4hxDjWgIFT1dJ9y3K9JybgRPMoapXCQQ6M64dDAfXXNN9nc?=
 =?us-ascii?Q?xnsO4Z1Sk+8ptMF4+QxSZfrQHElnVc7wIrjXRLJ0r748PNg/4dl9nnGcXn+I?=
 =?us-ascii?Q?5EXFQNw8UtnkkJBt4cP4N1d7UaBudBlWDfuu/qDyzwL1plFNkkPqgNwkfdCK?=
 =?us-ascii?Q?e5StOlDE4GGCq0YguO9fDxEB4mqTX8T/M8E+IjHoVH4KaxLTOAmukQ163MRE?=
 =?us-ascii?Q?DeUA1kUsiuAFAp449Z5tY8io6ea9H0ylU2HBZbuz1hRa/9Qe+3EpIp8TQ7Rm?=
 =?us-ascii?Q?ceN2CowVAmtiijAkBzcizM202qgkwJoJh6GNK//sz5WhVuip02ZP6P9/fPi7?=
 =?us-ascii?Q?TOTwOiU7kPCFGIyUZnKakWy2j+uzIk2VAxhRcGBR0tnFcWR7dXkAN/Eg7169?=
 =?us-ascii?Q?/nju1cbzcauSu3U6TrEoGG4EHHaqZFFVQWkosVpOatpbZ7BCxyyPIn2zZnRG?=
 =?us-ascii?Q?u8XX6li509iSmFXmzCG5Hb6tuz0ZM49cyT3pd0XvSWQij095KnyNcxr/M52D?=
 =?us-ascii?Q?Yy2I0jJWI87NIEjcHG51Bd3Tpu0qCqu9I2UAov8WL7A3g61trwPwYiqqSU9s?=
 =?us-ascii?Q?H78KWcDy0YbTrtjnF0SQ4UVdjhFGf7g6EltKUj2t5pV1aRQHW9j3In88VeS6?=
 =?us-ascii?Q?DRUwfYe8S2H29K4A34h/0pycIl7aJJ0Kzkh9SyojCzZMj4Oaart7ysbil7Xu?=
 =?us-ascii?Q?pPmBPszoVtfZzmXLwfV0sdrOXUvs4uU2EqDaveo7TfmXtoPDV1RBWjkjdfoj?=
 =?us-ascii?Q?VVoGta5unw2H0lyA33sI0EoEoRj/Co80uWDgTsUE5QLfc95MxadVLX2cTGTe?=
 =?us-ascii?Q?kJWD8+ddUVTuECoVdCWXgQB42iNVmPcmqKhcsQXXrF3ZUS6BADEj31ZM/LWq?=
 =?us-ascii?Q?S4bYwWHk/5eWaoSJ4Lt+Mz4J1sFhVeaDXYRSuDWxjn9y/mqXQEawzPif8WXI?=
 =?us-ascii?Q?/B/M1ETgxw/f4hyhHQUaY4DZ05syHey7LeRdCl0B44a+fEBv8vVDujlvxM56?=
 =?us-ascii?Q?Xb7+Yi3AVtR2FWtpzlLINQDzvVxZqZkLG8eRj18IWuSGugQ9btjdF+R/uZLf?=
 =?us-ascii?Q?NrCVPA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d1b3843-ad3e-4196-0549-08d9b5ab9d70
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2021 15:51:33.8061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GrnUmN9z6uDSIRqT4G0yEBCneNhinJeaqTFLL1iLjFhB+L9ViDXacMvFcPheKLZjiBosWTTn7zh4ZLiICUhosqD3JTcQlNMG2VFbKquYTmc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0527
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

Add user template explicit support. At this moment, max
TCAM rule size is utilized for all rules, doesn't matter
which and how much flower matches are provided by user. It
means that some of TCAM space is wasted, which impacts
the number of filters that can be offloaded.

Introducing the template, allows to have more HW offloaded
filters.

Example:
  tc qd add dev PORT clsact
  tc chain add dev PORT ingress protocol ip \
    flower dst_ip 0.0.0.0/16
  tc filter add dev PORT ingress protocol ip \
    flower skip_sw dst_ip 1.2.3.4/16 action drop

Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
---
 .../net/ethernet/marvell/prestera/prestera_acl.c   | 60 ++++++++++++++++++-
 .../net/ethernet/marvell/prestera/prestera_acl.h   |  2 +
 .../net/ethernet/marvell/prestera/prestera_flow.c  |  7 +++
 .../net/ethernet/marvell/prestera/prestera_flow.h  |  4 +-
 .../ethernet/marvell/prestera/prestera_flower.c    | 70 ++++++++++++++++++++++
 .../ethernet/marvell/prestera/prestera_flower.h    |  5 ++
 6 files changed, 145 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.c b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
index da0b6525ef9a..1371c1ae59a3 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
@@ -88,8 +88,8 @@ prestera_acl_ruleset_create(struct prestera_acl *acl,
 			    struct prestera_flow_block *block)
 {
 	struct prestera_acl_ruleset *ruleset;
+	u32 uid = 0;
 	int err;
-	u32 uid;
 
 	ruleset = kzalloc(sizeof(*ruleset), GFP_KERNEL);
 	if (!ruleset)
@@ -125,6 +125,12 @@ prestera_acl_ruleset_create(struct prestera_acl *acl,
 	return ERR_PTR(err);
 }
 
+void prestera_acl_ruleset_keymask_set(struct prestera_acl_ruleset *ruleset,
+				      void *keymask)
+{
+	ruleset->keymask = kmemdup(keymask, ACL_KEYMASK_SIZE, GFP_KERNEL);
+}
+
 int prestera_acl_ruleset_offload(struct prestera_acl_ruleset *ruleset)
 {
 	u32 vtcam_id;
@@ -559,6 +565,49 @@ prestera_acl_rule_entry_create(struct prestera_acl *acl,
 	return NULL;
 }
 
+static int __prestera_acl_vtcam_id_try_fit(struct prestera_acl *acl, u8 lookup,
+					   void *keymask, u32 *vtcam_id)
+{
+	struct prestera_acl_vtcam *vtcam;
+	int i;
+
+	list_for_each_entry(vtcam, &acl->vtcam_list, list) {
+		if (lookup != vtcam->lookup)
+			continue;
+
+		if (!keymask && !vtcam->is_keymask_set)
+			goto vtcam_found;
+
+		if (!(keymask && vtcam->is_keymask_set))
+			continue;
+
+		/* try to fit with vtcam keymask */
+		for (i = 0; i < __PRESTERA_ACL_RULE_MATCH_TYPE_MAX; i++) {
+			__be32 __keymask = ((__be32 *)keymask)[i];
+
+			if (!__keymask)
+				/* vtcam keymask in not interested */
+				continue;
+
+			if (__keymask & ~vtcam->keymask[i])
+				/* keymask does not fit the vtcam keymask */
+				break;
+		}
+
+		if (i == __PRESTERA_ACL_RULE_MATCH_TYPE_MAX)
+			/* keymask fits vtcam keymask, return it */
+			goto vtcam_found;
+	}
+
+	/* nothing is found */
+	return -ENOENT;
+
+vtcam_found:
+	refcount_inc(&vtcam->refcount);
+	*vtcam_id = vtcam->id;
+	return 0;
+}
+
 int prestera_acl_vtcam_id_get(struct prestera_acl *acl, u8 lookup,
 			      void *keymask, u32 *vtcam_id)
 {
@@ -595,7 +644,14 @@ int prestera_acl_vtcam_id_get(struct prestera_acl *acl, u8 lookup,
 				       PRESTERA_HW_VTCAM_DIR_INGRESS);
 	if (err) {
 		kfree(vtcam);
-		return err;
+
+		/* cannot create new, try to fit into existing vtcam */
+		if (__prestera_acl_vtcam_id_try_fit(acl, lookup,
+						    keymask, &new_vtcam_id))
+			return err;
+
+		*vtcam_id = new_vtcam_id;
+		return 0;
 	}
 
 	vtcam->id = new_vtcam_id;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.h b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
index 4e6006b4531f..40f6c1d961fa 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_acl.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_acl.h
@@ -151,6 +151,8 @@ prestera_acl_ruleset_get(struct prestera_acl *acl,
 struct prestera_acl_ruleset *
 prestera_acl_ruleset_lookup(struct prestera_acl *acl,
 			    struct prestera_flow_block *block);
+void prestera_acl_ruleset_keymask_set(struct prestera_acl_ruleset *ruleset,
+				      void *keymask);
 bool prestera_acl_ruleset_is_offload(struct prestera_acl_ruleset *ruleset);
 int prestera_acl_ruleset_offload(struct prestera_acl_ruleset *ruleset);
 void prestera_acl_ruleset_put(struct prestera_acl_ruleset *ruleset);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flow.c b/drivers/net/ethernet/marvell/prestera/prestera_flow.c
index 94a1feb3d9e1..d849f046ece7 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flow.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flow.c
@@ -40,6 +40,11 @@ static int prestera_flow_block_flower_cb(struct prestera_flow_block *block,
 		return 0;
 	case FLOW_CLS_STATS:
 		return prestera_flower_stats(block, f);
+	case FLOW_CLS_TMPLT_CREATE:
+		return prestera_flower_tmplt_create(block, f);
+	case FLOW_CLS_TMPLT_DESTROY:
+		prestera_flower_tmplt_destroy(block, f);
+		return 0;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -64,6 +69,8 @@ static void prestera_flow_block_destroy(void *cb_priv)
 {
 	struct prestera_flow_block *block = cb_priv;
 
+	prestera_flower_template_cleanup(block);
+
 	WARN_ON(!list_empty(&block->binding_list));
 
 	kfree(block);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flow.h b/drivers/net/ethernet/marvell/prestera/prestera_flow.h
index 5863acf06005..1ea5b745bf72 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flow.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flow.h
@@ -8,6 +8,7 @@
 
 struct prestera_port;
 struct prestera_switch;
+struct prestera_flower_template;
 
 struct prestera_flow_block_binding {
 	struct list_head list;
@@ -18,10 +19,11 @@ struct prestera_flow_block_binding {
 struct prestera_flow_block {
 	struct list_head binding_list;
 	struct prestera_switch *sw;
-	unsigned int rule_count;
 	struct net *net;
 	struct prestera_acl_ruleset *ruleset_zero;
 	struct flow_block_cb *block_cb;
+	struct prestera_flower_template *tmplt;
+	unsigned int rule_count;
 };
 
 int prestera_flow_block_setup(struct prestera_port *port,
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
index c1dc4e49b07f..19c1417fd05f 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
@@ -6,6 +6,21 @@
 #include "prestera_flow.h"
 #include "prestera_flower.h"
 
+struct prestera_flower_template {
+	struct prestera_acl_ruleset *ruleset;
+};
+
+void prestera_flower_template_cleanup(struct prestera_flow_block *block)
+{
+	if (block->tmplt) {
+		/* put the reference to the ruleset kept in create */
+		prestera_acl_ruleset_put(block->tmplt->ruleset);
+		kfree(block->tmplt);
+		block->tmplt = NULL;
+		return;
+	}
+}
+
 static int prestera_flower_parse_actions(struct prestera_flow_block *block,
 					 struct prestera_acl_rule *rule,
 					 struct flow_action *flow_action,
@@ -310,6 +325,61 @@ void prestera_flower_destroy(struct prestera_flow_block *block,
 
 }
 
+int prestera_flower_tmplt_create(struct prestera_flow_block *block,
+				 struct flow_cls_offload *f)
+{
+	struct prestera_flower_template *template;
+	struct prestera_acl_ruleset *ruleset;
+	struct prestera_acl_rule rule;
+	int err;
+
+	memset(&rule, 0, sizeof(rule));
+	err = prestera_flower_parse(block, &rule, f);
+	if (err)
+		return err;
+
+	template = kmalloc(sizeof(*template), GFP_KERNEL);
+	if (!template) {
+		err = -ENOMEM;
+		goto err_malloc;
+	}
+
+	prestera_acl_rule_keymask_pcl_id_set(&rule, 0);
+	ruleset = prestera_acl_ruleset_get(block->sw->acl, block);
+	if (IS_ERR_OR_NULL(ruleset)) {
+		err = -EINVAL;
+		goto err_ruleset_get;
+	}
+
+	/* preserve keymask/template to this ruleset */
+	prestera_acl_ruleset_keymask_set(ruleset, rule.re_key.match.mask);
+
+	/* skip error, as it is not possible to reject template operation,
+	 * so, keep the reference to the ruleset for rules to be added
+	 * to that ruleset later. In case of offload fail, the ruleset
+	 * will be offloaded again during adding a new rule. Also,
+	 * unlikly possble that ruleset is already offloaded at this staage.
+	 */
+	prestera_acl_ruleset_offload(ruleset);
+
+	/* keep the reference to the ruleset */
+	template->ruleset = ruleset;
+	block->tmplt = template;
+	return 0;
+
+err_ruleset_get:
+	kfree(template);
+err_malloc:
+	NL_SET_ERR_MSG_MOD(f->common.extack, "Create chain template failed");
+	return err;
+}
+
+void prestera_flower_tmplt_destroy(struct prestera_flow_block *block,
+				   struct flow_cls_offload *f)
+{
+	prestera_flower_template_cleanup(block);
+}
+
 int prestera_flower_stats(struct prestera_flow_block *block,
 			  struct flow_cls_offload *f)
 {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.h b/drivers/net/ethernet/marvell/prestera/prestera_flower.h
index c6182473efa5..dc3aa4280e9f 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_flower.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.h
@@ -15,5 +15,10 @@ void prestera_flower_destroy(struct prestera_flow_block *block,
 			     struct flow_cls_offload *f);
 int prestera_flower_stats(struct prestera_flow_block *block,
 			  struct flow_cls_offload *f);
+int prestera_flower_tmplt_create(struct prestera_flow_block *block,
+				 struct flow_cls_offload *f);
+void prestera_flower_tmplt_destroy(struct prestera_flow_block *block,
+				   struct flow_cls_offload *f);
+void prestera_flower_template_cleanup(struct prestera_flow_block *block);
 
 #endif /* _PRESTERA_FLOWER_H_ */
-- 
2.7.4

