Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93C823486BC
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbhCYB5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:57:15 -0400
Received: from mail-db8eur05on2095.outbound.protection.outlook.com ([40.107.20.95]:20446
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231288AbhCYB5I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 21:57:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJ+9fbcERqvTeMI6XPon4WnXqumwWK5BhQcCzbGs44BWBDsoGhRY5Qtp3gxZcOcFejE/k+dHrxIxIrPkRPa3k2+nkY5YvLm+2Gtrs9kRtOl/YH+bkSFRVbhJB/eZ58MHuQRERbCUCd2GN5i5Yf4xT/9G3GPJJIhajmfFZf4SI6SzkUdn6DIIfzYRgPaDQ0UsfIj4uk3LG765gSNKkfuNDEBVymmAlW7xeQWbzZYBLG6/W9KnG8t4BAxO0/hDB2a1AUjXJuoTa54Ib3ayzjsHD73KwZuiz/FyFIDCQ36zWwKi131HKPFUSzLKbnHOVBmsz4t2C7G89uh3zB78wVnPYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfWX0U9qBokI4dmD5xab0cV9MKzM2Mp7olZzFZcUfiM=;
 b=Q3xVXXM56ih0QLNXfNgPDDgWp6yQG0mkQVvdAbrdtOulVSfxoxej4v7BXLswYrL2IrLfrCC8SqhLc2Lv+Vx4gHq5vZpm6IVtQ7acDfWEeH6PxVvf4YXFTJCMq4humCcHfjLBgLYz0qBBOAt6DUotplrvR3ztVUFv6dLV+n99Wobfa8T/kRRL3dtf2n5wxLQwod6utZW2TCbcDxTZV22htEi8eG+FC6NLcqB+6zP6Org66mkEd53xcmUArtnz/r1XA5fAG+wNbDkqT/EORHowMM6tvhysLWxMedWw533sx/3/Ovp++B+9guIELvAV529XXnJRntACv/3qnwTDwxXPzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfWX0U9qBokI4dmD5xab0cV9MKzM2Mp7olZzFZcUfiM=;
 b=MDbqKFJcVFJ1Yq1o/DnPy9ANqfHievfeBFLOJ5TvDA+qY8/EwzepqLfqNaNXp13VN2Xc3x2YtezWyHQCGRyMIqzW8vnoFhhnd41RsMp5Rz8o9qm+tYK71WfxDR/J65YyEb6uXMeRg502voz8T6djXahaHvdB2zVpiY8PwMBzYyM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=dektech.com.au;
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
 by VI1PR05MB6719.eurprd05.prod.outlook.com (2603:10a6:800:133::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Thu, 25 Mar
 2021 01:57:06 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::5573:2fb4:56e0:1cc3]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::5573:2fb4:56e0:1cc3%6]) with mapi id 15.20.3955.024; Thu, 25 Mar 2021
 01:57:05 +0000
From:   Hoang Le <hoang.h.le@dektech.com.au>
To:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        tuan.a.vo@dektech.com.au, tung.q.nguyen@dektech.com.au
Subject: [net-next] tipc: add extack messages for bearer/media failure
Date:   Thu, 25 Mar 2021 08:56:41 +0700
Message-Id: <20210325015641.7063-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [113.20.114.51]
X-ClientProxiedBy: SGBP274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::19)
 To VI1PR05MB4605.eurprd05.prod.outlook.com (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (113.20.114.51) by SGBP274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Thu, 25 Mar 2021 01:57:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd850151-31c0-4f4d-b5aa-08d8ef314a51
X-MS-TrafficTypeDiagnostic: VI1PR05MB6719:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6719FC68CB9C32EA73212E8DF1629@VI1PR05MB6719.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6sSJ99e7dZls9sMQivVU2qAAqo2SdOaxec1Np2LtLEQo+EVgaVBEG8lvD3VaGQawqhKK2TsbkJ9U1y6kg9+0IpLirnahsAnVdKi2f5/c8z21hvHetxMCObTNXYDyo9NgDD6w9cKNrQMe01GDM5LWiMzfNpe6uLd+G+S7Qe3OC4QFWKw4u+lPBKJzZjdppxCi7jdl+8+wrWz23hsJcij6qBxpz7AAQvLuVXAOD3lVCmv+VPKJL7hPCZ/WlS+uzOF2XQ63i6HhdgVnxRdVb00c8Zigg4XUPa/MVpmLfe7PrtYw9vGgYxiIzkh93SUNooH3CIbmXSR5ouA4/Klshfm11EFsIj4qCk/WdN7pFtW/7jcG0/IRr+xbtEkOJHkf72saXACN/BHdNLL8xniuBmt8BGtj3VYcltJHfB0o10DRXaz2YxxTeYDbFfByBIyNR2dNJqMVhw3CDofUO2IUqNl33f+etiaEd6NQfAhtCrCKkk7UFQXjuInUBqJo6F3CkXn5jSAJD8sdXVxUt6kJ18FuW9MfFiDZCrptKLccqF05ztQG5Hf+BkFxzZmML5n9aVSrLWcfvlKfDfcfYcdjEqN9Pp0tQYXlHVdiUDJAX0bx6Ec6M6sj4OrUKrr1yX6L94qhCRpPk5IqovfmXLsHit1isA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4605.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(39840400004)(376002)(346002)(2906002)(103116003)(55016002)(66556008)(66476007)(66946007)(83380400001)(15650500001)(86362001)(8676002)(8936002)(316002)(38100700001)(36756003)(186003)(16526019)(478600001)(52116002)(26005)(6636002)(7696005)(956004)(1076003)(2616005)(6666004)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?a3nqxJ8ppTetltUYrFzVR88cWUQRTN21LZx0BFOYAI+8H3fU4eLQ/B0LFWq2?=
 =?us-ascii?Q?rnKx7OziRwdGY17mDUwhiMyAN4pw0TJgFAhCw95d2VGpEqtYG8OoS19JKZkt?=
 =?us-ascii?Q?HqW+nkfqNqhI2M0hQ09J6uXOio/6po4AqxJAf7jh/cDdGKvFXHC6Pq2CsLxk?=
 =?us-ascii?Q?WsWJr1OIACWH6tB1rAd+meohiyExAyuPUuuzDiYrFdAVQoqhsr7G85zeO1wC?=
 =?us-ascii?Q?fk1w1I0y46pTwEPb2lmtgWO4IV8cpHKgS8sPdfAtOEDCsnScApOP5CYmlu8w?=
 =?us-ascii?Q?Ea27PEaZxgBcYIelc0NJnRiKI70CILw5B4RilQusvS61/fMektKeYOIzgGJ9?=
 =?us-ascii?Q?bD3c/n5E0hbFZNalnIFN6Td0x93Nw2naT8snBNdqStn1MD5Q24Bw1/tTSieQ?=
 =?us-ascii?Q?ctX/3zFNCClV6L3e++hOoEEoqu72L0ihkDTPTGaWWoqb3fuVVFskeEaEtOzr?=
 =?us-ascii?Q?+66nR3HoddsmeQDaNsbXYNPHOhto5z7vLjfVFgCqHDORARVfKUaCdtu6Z7Kn?=
 =?us-ascii?Q?o6L4HXy1hFH1XqsGuMoPD1/ywZcKpB5xz+9OuCbvHkfOGpAcUPDw0FjUjjCr?=
 =?us-ascii?Q?A1DnLkBG4/8QZ1l0OMBPjsq6EM8Eiskqya5Fq9kgsv3d7+6wpAh57MW7sVNw?=
 =?us-ascii?Q?bS9b0p6YfwHZCJHVs7sozla5LO2CrXUzNANVeVJXUmgLlYJBKTMdhw6lEYTb?=
 =?us-ascii?Q?O/kMQkzVNTiCjHRw+fpu/G9IdCf3ea+sezeEtYp4R7ffQowNpeufyW3sEEP+?=
 =?us-ascii?Q?wXSnJiOjCpawKteld34cDt41lB0SdAr1i4Rdqin3sv9CoekVwOYG2hZAp/MG?=
 =?us-ascii?Q?fFwXhDM4aNiwGJCn5z1GAyXYhvKUBcDeI3v8FLh7Ze19CLLi5rr1BqS+taBT?=
 =?us-ascii?Q?XJlckqaXB6SIYc12SvtQXxM4SLKt0QdldQO1zunG1I/87L42kyoNTF30kZAO?=
 =?us-ascii?Q?UuGqlC9BVnV5tQTg8nW+UctzaC3ETmrqLXlRGdRdbjP4MSkM9XUzOc27z6On?=
 =?us-ascii?Q?8TWiAb4uX+2p9sJDWngAvRTYPqZARNVvwO1FzFce75CxXjScOPfZTIAWCp9F?=
 =?us-ascii?Q?sh/gjkj2CaOPn0zhV1T00F17tBiuFEV3Uy6MOoif5jcvqmUUG0OpYZD0SWgW?=
 =?us-ascii?Q?47OnJwcMYrV8A78jTUBKblplHbk4iTtxGh6nZk71OPuprO9pVcGxnCNIjzsp?=
 =?us-ascii?Q?1GJ5QNcRAVU+FThxMbCwJ64rhb/5xFOsmiuduSHBdZihT8oJNlPkz+C7TyD8?=
 =?us-ascii?Q?cXr0CGZEoW0IQMM5gWbnl4PoXNWJbG0EKu+NsyhYgVXoxnGiph5S7G4TDUgL?=
 =?us-ascii?Q?PG9MWPNGl5tyLRAtAU0Jn7P8?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: dd850151-31c0-4f4d-b5aa-08d8ef314a51
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4605.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 01:57:05.5428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QE6COZ9UQAIAX00myBbVuEZXeC2PUExkjkscOfQZ/I+wDjcugbg7TYLAWKwpfFDWa837ST7IaMT+DORiCzt+KH0ua/ReZKdRS3sTJ6g3AEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6719
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add extack error messages for -EINVAL errors when enabling bearer,
getting/setting properties for a media/bearer

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
---
 net/tipc/bearer.c | 50 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 40 insertions(+), 10 deletions(-)

diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index a4389ef08a98..1090f21fcfac 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -243,7 +243,8 @@ void tipc_bearer_remove_dest(struct net *net, u32 bearer_id, u32 dest)
  */
 static int tipc_enable_bearer(struct net *net, const char *name,
 			      u32 disc_domain, u32 prio,
-			      struct nlattr *attr[])
+			      struct nlattr *attr[],
+			      struct netlink_ext_ack *extack)
 {
 	struct tipc_net *tn = tipc_net(net);
 	struct tipc_bearer_names b_names;
@@ -257,17 +258,20 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 
 	if (!bearer_name_validate(name, &b_names)) {
 		errstr = "illegal name";
+		NL_SET_ERR_MSG(extack, "Illegal name");
 		goto rejected;
 	}
 
 	if (prio > TIPC_MAX_LINK_PRI && prio != TIPC_MEDIA_LINK_PRI) {
 		errstr = "illegal priority";
+		NL_SET_ERR_MSG(extack, "Illegal priority");
 		goto rejected;
 	}
 
 	m = tipc_media_find(b_names.media_name);
 	if (!m) {
 		errstr = "media not registered";
+		NL_SET_ERR_MSG(extack, "Media not registered");
 		goto rejected;
 	}
 
@@ -281,6 +285,7 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 			break;
 		if (!strcmp(name, b->name)) {
 			errstr = "already enabled";
+			NL_SET_ERR_MSG(extack, "Already enabled");
 			goto rejected;
 		}
 		bearer_id++;
@@ -292,6 +297,7 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 			name, prio);
 		if (prio == TIPC_MIN_LINK_PRI) {
 			errstr = "cannot adjust to lower";
+			NL_SET_ERR_MSG(extack, "Cannot adjust to lower");
 			goto rejected;
 		}
 		pr_warn("Bearer <%s>: trying with adjusted priority\n", name);
@@ -302,6 +308,7 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 
 	if (bearer_id >= MAX_BEARERS) {
 		errstr = "max 3 bearers permitted";
+		NL_SET_ERR_MSG(extack, "Max 3 bearers permitted");
 		goto rejected;
 	}
 
@@ -315,6 +322,7 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 	if (res) {
 		kfree(b);
 		errstr = "failed to enable media";
+		NL_SET_ERR_MSG(extack, "Failed to enable media");
 		goto rejected;
 	}
 
@@ -331,6 +339,7 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 	if (res) {
 		bearer_disable(net, b);
 		errstr = "failed to create discoverer";
+		NL_SET_ERR_MSG(extack, "Failed to create discoverer");
 		goto rejected;
 	}
 
@@ -909,6 +918,7 @@ int tipc_nl_bearer_get(struct sk_buff *skb, struct genl_info *info)
 	bearer = tipc_bearer_find(net, name);
 	if (!bearer) {
 		err = -EINVAL;
+		NL_SET_ERR_MSG(info->extack, "Bearer not found");
 		goto err_out;
 	}
 
@@ -948,8 +958,10 @@ int __tipc_nl_bearer_disable(struct sk_buff *skb, struct genl_info *info)
 	name = nla_data(attrs[TIPC_NLA_BEARER_NAME]);
 
 	bearer = tipc_bearer_find(net, name);
-	if (!bearer)
+	if (!bearer) {
+		NL_SET_ERR_MSG(info->extack, "Bearer not found");
 		return -EINVAL;
+	}
 
 	bearer_disable(net, bearer);
 
@@ -1007,7 +1019,8 @@ int __tipc_nl_bearer_enable(struct sk_buff *skb, struct genl_info *info)
 			prio = nla_get_u32(props[TIPC_NLA_PROP_PRIO]);
 	}
 
-	return tipc_enable_bearer(net, bearer, domain, prio, attrs);
+	return tipc_enable_bearer(net, bearer, domain, prio, attrs,
+				  info->extack);
 }
 
 int tipc_nl_bearer_enable(struct sk_buff *skb, struct genl_info *info)
@@ -1046,6 +1059,7 @@ int tipc_nl_bearer_add(struct sk_buff *skb, struct genl_info *info)
 	b = tipc_bearer_find(net, name);
 	if (!b) {
 		rtnl_unlock();
+		NL_SET_ERR_MSG(info->extack, "Bearer not found");
 		return -EINVAL;
 	}
 
@@ -1086,8 +1100,10 @@ int __tipc_nl_bearer_set(struct sk_buff *skb, struct genl_info *info)
 	name = nla_data(attrs[TIPC_NLA_BEARER_NAME]);
 
 	b = tipc_bearer_find(net, name);
-	if (!b)
+	if (!b) {
+		NL_SET_ERR_MSG(info->extack, "Bearer not found");
 		return -EINVAL;
+	}
 
 	if (attrs[TIPC_NLA_BEARER_PROP]) {
 		struct nlattr *props[TIPC_NLA_PROP_MAX + 1];
@@ -1106,12 +1122,18 @@ int __tipc_nl_bearer_set(struct sk_buff *skb, struct genl_info *info)
 		if (props[TIPC_NLA_PROP_WIN])
 			b->max_win = nla_get_u32(props[TIPC_NLA_PROP_WIN]);
 		if (props[TIPC_NLA_PROP_MTU]) {
-			if (b->media->type_id != TIPC_MEDIA_TYPE_UDP)
+			if (b->media->type_id != TIPC_MEDIA_TYPE_UDP) {
+				NL_SET_ERR_MSG(info->extack,
+					       "MTU property is unsupported");
 				return -EINVAL;
+			}
 #ifdef CONFIG_TIPC_MEDIA_UDP
 			if (tipc_udp_mtu_bad(nla_get_u32
-					     (props[TIPC_NLA_PROP_MTU])))
+					     (props[TIPC_NLA_PROP_MTU]))) {
+				NL_SET_ERR_MSG(info->extack,
+					       "MTU value is out-of-range");
 				return -EINVAL;
+			}
 			b->mtu = nla_get_u32(props[TIPC_NLA_PROP_MTU]);
 			tipc_node_apply_property(net, b, TIPC_NLA_PROP_MTU);
 #endif
@@ -1239,6 +1261,7 @@ int tipc_nl_media_get(struct sk_buff *skb, struct genl_info *info)
 	rtnl_lock();
 	media = tipc_media_find(name);
 	if (!media) {
+		NL_SET_ERR_MSG(info->extack, "Media not found");
 		err = -EINVAL;
 		goto err_out;
 	}
@@ -1275,9 +1298,10 @@ int __tipc_nl_media_set(struct sk_buff *skb, struct genl_info *info)
 	name = nla_data(attrs[TIPC_NLA_MEDIA_NAME]);
 
 	m = tipc_media_find(name);
-	if (!m)
+	if (!m) {
+		NL_SET_ERR_MSG(info->extack, "Media not found");
 		return -EINVAL;
-
+	}
 	if (attrs[TIPC_NLA_MEDIA_PROP]) {
 		struct nlattr *props[TIPC_NLA_PROP_MAX + 1];
 
@@ -1293,12 +1317,18 @@ int __tipc_nl_media_set(struct sk_buff *skb, struct genl_info *info)
 		if (props[TIPC_NLA_PROP_WIN])
 			m->max_win = nla_get_u32(props[TIPC_NLA_PROP_WIN]);
 		if (props[TIPC_NLA_PROP_MTU]) {
-			if (m->type_id != TIPC_MEDIA_TYPE_UDP)
+			if (m->type_id != TIPC_MEDIA_TYPE_UDP) {
+				NL_SET_ERR_MSG(info->extack,
+					       "MTU property is unsupported");
 				return -EINVAL;
+			}
 #ifdef CONFIG_TIPC_MEDIA_UDP
 			if (tipc_udp_mtu_bad(nla_get_u32
-					     (props[TIPC_NLA_PROP_MTU])))
+					     (props[TIPC_NLA_PROP_MTU]))) {
+				NL_SET_ERR_MSG(info->extack,
+					       "MTU value is out-of-range");
 				return -EINVAL;
+			}
 			m->mtu = nla_get_u32(props[TIPC_NLA_PROP_MTU]);
 #endif
 		}
-- 
2.25.1

