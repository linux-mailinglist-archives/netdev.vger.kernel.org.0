Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8554755D5
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 11:08:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241515AbhLOKIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 05:08:10 -0500
Received: from mail-eopbgr80128.outbound.protection.outlook.com ([40.107.8.128]:55481
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231666AbhLOKIJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 05:08:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ysi2CbgHUlL/xXgBFzgUXvoZyNKly0jwb/h3VZlR3kaSwef8SUHBYdUro4cGweCKvqeGjC33EE8oC0LgLkrQN86X5TvXr3UU2VMORJI0GblcPFhCc0jkRS2wNbvgHcj6lKbPsBsfJg02aAWHRuqsGEvuF+Vh1yTTj2ajp4RfV55LRU56eyEwyiwvSfGBeqWE+nQrRdIj/2mnWLnvQi1nbOTurCOE4ny39RhAxDaJexXCyHngEWg/eWnQAMkXgT+Ftg0DgMQiQbc2ztRNaoGf6Pis0g581YLpoP++FPmA0y/DveqUStV1g/gK5ms/XocA37PJ9HRV9gDgjhvrZGkbow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B+9tutJNJ1Kb2yU72X8MuOryJeVZN16N/FnEy6y3+jI=;
 b=eYaTTL9pVjPp+6S9oqyyzF0xQARsoToiWtfckqwm1ge5yShXatyxHhq59iieQWLWyCwrjYJdA2ttbWWkGpePQRr2f+DYYFffWzBZfI2pOchPGKSy7q60p+OPgCn4ylP6ltUgjMz7EWKv8yfeS/UX7JI3K6PactA0KjQQSKxgfnQ+gvai7OBvs8S0po7z6BvwFTiVL7LeUjv2zYbBie3H/Q0g5PT/yws2/XcRwUq6ED9ZNl1hjZ3L6bOOhhVdUqs9wAnBHFGc+WjCiMYrOGS0zpWfyqfxdWbVi9vusxXVdFzqz/HVmUbKEWrjFwnGO5vOktmqo7Rvh3rWF1E+XFC5/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+9tutJNJ1Kb2yU72X8MuOryJeVZN16N/FnEy6y3+jI=;
 b=aMRlmt+OLVO58plpE/ScdDxtAZ56PdmXDMPvs9dhQwdV9UP0wfj3fmbNUJwsga6243SDNn6SZGNIQA/+LFV6lRIFnk6N58RKRPd7o4dloZD3Hic80SmCgWnlKkr0FUGjEt+nCTl0ettLNhiDyyKl/NTd9BldgLyZ7aVfFEDxKUQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::23)
 by VI1P190MB0608.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:11d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.18; Wed, 15 Dec
 2021 10:08:01 +0000
Received: from VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136]) by VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 ([fe80::e15a:32ff:b93c:d136%4]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 10:08:01 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     netdev@vger.kernel.org, jhs@mojatatu.com
Cc:     mickeyr@marvell.com, serhiy.pshyk@plvision.eu,
        taras.chornyi@plvision.eu, Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] net: prestera: flower template support
Date:   Wed, 15 Dec 2021 12:07:30 +0200
Message-Id: <1639562850-24140-1-git-send-email-volodymyr.mytnyk@plvision.eu>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0046.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::12) To VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:123::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bdaf8079-1625-4bc1-fb63-08d9bfb2c6e0
X-MS-TrafficTypeDiagnostic: VI1P190MB0608:EE_
X-Microsoft-Antispam-PRVS: <VI1P190MB0608377C12F1E23BED7DBBF48F769@VI1P190MB0608.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8yQh/Hy4kcrxicVqLQFzztdbM8npj3um2eH8wRDgKvKWC/0AjqI/jCfbvBSPHqj14OF+MVAlF6C3iD3GKUEVkXsIqIi4YKC5VesEUdvJTOVmMFApKYo8b1j+hAFB+e97zsqJP/xBxpaSqXHTlyxGrGovCOwaYeAmnT5VpTifd/OcJzOdI8ZZVcrlscuS9RMi7hO8YVb4vJi5CmHaerOPtiRvJj+HQIHADUTts9oCxgX9IKYL26/W4hxNq5x+yXqTRytIiy1y65T5Xe3s/heFiF75O9F6Cir9ftXk2svRSTnkE+kGRQ7TmbCJqBrWipas/f7dA+0OyxcxlfNT7CVHNKr+wNKbyyHfpNiT5IzZMlenYjJ33uWSH+YDFy1LfWBWA2YKlyMQCm9GxD4DVQO1FpHUBbYzgSdr7UXUJF99oaiFx6yCJG5q5mxemiUIQB3DurVYRM6x4UTp8MZ3x/35dTRbMEkzqCt6EwCmmnPPw9JHiJH+UAmOvihCY+NkN/I+Ekb5IWVFrvrt2iFSyj/XxThsEsw+XnBjH7Nnl0cdGGovMbs+R2YDEEblKcZHADMrRgb+SeFx6WboTONWHeO34PrsGcOTeei3SEHW7Krzk1Rut1B05zIBXgIpMS63uY+fGvfWmijCMP3bnz0KNyjk4DVZiDPBkzmXB+1gf9JyWLzU6qCr1G1fdanB6yUZSYJ0s/yH2D9D/39QRIDFAhf4nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0734.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(376002)(346002)(39830400003)(6666004)(83380400001)(38350700002)(38100700002)(26005)(86362001)(36756003)(8676002)(4326008)(44832011)(5660300002)(52116002)(508600001)(6506007)(2616005)(8936002)(316002)(186003)(6486002)(2906002)(66946007)(66556008)(54906003)(66476007)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B6NxyLdCSndu2kDWkpkD7BYpFNcGpBSbgGK3nXpgzcg05eeixdRzuRsDZ2De?=
 =?us-ascii?Q?oIQq3sMo7CPkXM7dUC8qt5Xvz9LeHglUsiMQHP/kRRIzIFQSTR7GPza3pEYz?=
 =?us-ascii?Q?+GvNOZV0b2OmpWcp3tOT3yW9jaV5pxVSZkaBsx5jYGX6rLc6/MAKeGXBwW+Z?=
 =?us-ascii?Q?GxKgBPKEh1r+humKU2QoNxELFBx0I3LpWOelluu9HvMbbwdNvn6XtRoXjP0m?=
 =?us-ascii?Q?hdpUA1uTI9y0Qu+WSyQr2UMcpPUnvPhhPxHItQ2ivQMLFYdOINtagnb5tLBy?=
 =?us-ascii?Q?mt8ByeoQSEy5yKrfyY+f/Ehh1Z0Ah6EOjaDVA/bN6VoJBDf2aGMcsuQMlGXi?=
 =?us-ascii?Q?8wJ0uzT8bfLzb6n6Yr5SqBbtssrVa5l+49lre9OMbV81Ft7yXA7PP5lE9XXi?=
 =?us-ascii?Q?b/5PutUxJAzyRPAK2wxqzoWcyceLUWg5QntLlT9AeDkG7DiudP+JAP5JRD1Z?=
 =?us-ascii?Q?pP0ZYyKnPCFIzOlc5AvzQ8emJmvwcseQAlO8YGMs3kFeeJ50fOLT9NHh6LBO?=
 =?us-ascii?Q?ihgSBFg6x+d0WD1aS3eatF7y3J2U4kRruS7nTemawa9ALfnZotEPMvpYl4sg?=
 =?us-ascii?Q?ZR8SRzqGimaHuyKW2dFXoCkbg7zlvx4YqU1N5bOPRMlEmAqMeZUb2cbiaRFN?=
 =?us-ascii?Q?5ZIbSiPNuSAatt2yWmGkKblYDMXyrbHMe2QxZp0fMWKzOboIq3tmBobqvVM5?=
 =?us-ascii?Q?eh8KzLvAR+SYt/h1YLO2xxIoQzHjcv3TmD/S9YJkFFhHaK8w82KLMTmPF+Zu?=
 =?us-ascii?Q?4mXSVmDxvstuSNuoAzYct8boMuwoA7KmA86u7xYLP/squc46NDvzgCdAMFVh?=
 =?us-ascii?Q?mUlms7XVg9mgdpkeHcDIk3xXwEiMA3IY6UT5v1ntTLrBXCrIp60P65U0RaCd?=
 =?us-ascii?Q?kxjNIrCtNapXlJuvgKpSQpbZYG8Y3U6Ti9Qs6k9HW/XCScPmgj2y6mMdbQhA?=
 =?us-ascii?Q?lgdCfRk4Z+KpIrpbcfnAZwjIFLW0Vc0Tz2JPaWypExoS41rgzV3E3FwiwvJe?=
 =?us-ascii?Q?XTHevr3rR4Ja8ESWNplcC4fkBT/9mgCZEYTWFSFQnj5a7f1Lt7dHgQhWbMxZ?=
 =?us-ascii?Q?Ven17lCDVF1H12muVgYxv3qfeOOTSAxT7JXTNg+UxAom5El41L8P2tuyW5Iz?=
 =?us-ascii?Q?YbhtfzoqAEMGnbNoOfWaZRdxjFL/1gCcl0F32kZXt+j17d7tl0DZwPt0DFCO?=
 =?us-ascii?Q?3wgooXXHgbR+/DyOVdZl5z3utTNz670Z/InQaGg01Tse+IIf9+uJ5Z8o+J5d?=
 =?us-ascii?Q?2j1lPWWLT39uywfjTD47bbak3uHc5RiBbFgRkUYNwQSGvOzrYf1fN+zqHZRn?=
 =?us-ascii?Q?u5ktAdsKx9QNLeyAP/OE8ZHNM1uy8e4AedFzwUG9pLRx0cTEeHOrGYdbF6e4?=
 =?us-ascii?Q?A4Uv0jEhJaThfPnNsAxgQ5x4miUNpKvf/MM6290T1WKH/VF4OLXMEWDjVsfD?=
 =?us-ascii?Q?bLyPbaqH4TaPDc3gJNjV5XaVlEWUKHT3s0FxUergetnMyHWbbcz5MeKigF1b?=
 =?us-ascii?Q?BgHnDJKcIKKr+URCJCFxj8y5rneSnvVu6Tzt02GA3qQbIjuZ38wr/GxFZ4Wy?=
 =?us-ascii?Q?ib/eI3GYRyYT/1A8yJcsp++1sSVFYsETuiM3hFvg8sTFlWnRCIXKSDGWxEbE?=
 =?us-ascii?Q?aJTelyMizTxF1oPUHLhpv9F9KWsEETYCyyNTQ2WR2YSc81qRlf/aB5lYXB/k?=
 =?us-ascii?Q?83eN8/c2RVoxv5bLX8TCujFZkDE=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: bdaf8079-1625-4bc1-fb63-08d9bfb2c6e0
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0734.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2021 10:08:01.3553
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oaa8r+NaeJveiEJU5iv8M5hzClZkKTdtvHMX/R/qAnhCrBEZYra0yqRqUQRAUE08T6of45N0EqNEwt1pl62BgoQcvoTImyLmzOiKQvDlUGc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0608
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
filters by specifying the template explicitly.

Example:
  tc qd add dev PORT clsact
  tc chain add dev PORT ingress protocol ip \
    flower dst_ip 0.0.0.0/16
  tc filter add dev PORT ingress protocol ip \
    flower skip_sw dst_ip 1.2.3.4/16 action drop

NOTE: chain 0 is the default chain id for "tc chain" & "tc filter"
      command, so it is omitted in the example above.

This patch adds only template support for default chain 0 suppoerted
by prestera driver at this moment. Chains are not supported yet,
and will be added later.

Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
---

V1->V2: make commit description more clear in relation to chains

 .../net/ethernet/marvell/prestera/prestera_acl.c   | 60 ++++++++++++++++++-
 .../net/ethernet/marvell/prestera/prestera_acl.h   |  2 +
 .../net/ethernet/marvell/prestera/prestera_flow.c  |  7 +++
 .../net/ethernet/marvell/prestera/prestera_flow.h  |  4 +-
 .../ethernet/marvell/prestera/prestera_flower.c    | 70 ++++++++++++++++++++++
 .../ethernet/marvell/prestera/prestera_flower.h    |  5 ++
 6 files changed, 145 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_acl.c b/drivers/net/ethernet/marvell/prestera/prestera_acl.c
index fc7f2fedafd7..f0d9f592173b 100644
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
@@ -556,6 +562,49 @@ prestera_acl_rule_entry_create(struct prestera_acl *acl,
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
@@ -592,7 +641,14 @@ int prestera_acl_vtcam_id_get(struct prestera_acl *acl, u8 lookup,
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

