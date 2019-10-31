Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77E66EB81D
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 20:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbfJaTrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 15:47:41 -0400
Received: from mail-eopbgr150081.outbound.protection.outlook.com ([40.107.15.81]:36324
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727441AbfJaTrl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 15:47:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXiCMGYppebEk6FS6yrVlcoZeO+SE6DUf86uZK7YfYTloQYrtOWmPTMEoJQzDQB3ShoOuLbhQFvbA4ciBBSOPGO0KpsixMnUNXiyY1owcn8CbW54g/FGIz+hKewYnQpZMBKBb6nzmaaibWRcTNXZEO1hqd2NAwaGERO94JkyXME2CJZIzugPNVhRP8D3a+Fjnbz1Lv8zTx70sg2Q+6HAa/g6n1iggodUAxLZstnX21TnmsFkvBFIQuDb7ftRe1OZTXU9yUd0St80rumHFMQBtQn4JP08EM8wYoKRpcm4EuospV0S72AXx9u4pDA7rIOHPz8z8J0NfLYXvNVdNjcZBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tc1oUunfBILeKg9vVGB5En/HmvzzTdy4Z4WppELRt+Q=;
 b=CyxO567hZimID2D3Z57N62oT9+hjUZCZr/khidUHXhY/Zd06b8eMVCitGWsa9WBrLsDHPW8pHKF005PZwJ83fr6PLLWTb2ERZhK5K9qqNwgm8Q0azYjKej8FjySl33IdWYlqTHkzLO6s/Yq9uEHQSoCj9kUwXRxZPyMsxqMVrPBTIvI3Gk444gTSPnsEn8VndZzuiEglqYPuJL7qNMVHgnvIVzZTvTBq02lvrX27RRhQoEXcnsXsUuYxXFp0UvqdcBFlUQklla4mBjEzhVw0bN3IwZirAHmSOMfPo9NK84ty+kcxJUt6gfCbkaH4BxV/wUP9NynIV5WcJifuTbq+lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tc1oUunfBILeKg9vVGB5En/HmvzzTdy4Z4WppELRt+Q=;
 b=cTF3FzAhcFiycrrU5rUpProdAMsTq2G6EDRndkAwUy3KW7L40BigQodSexIMxitAm/o/v2jR6esODP6Xj9Y+bLYHf/BzwXK0nc48gLn+dcCXtYc80jzCpKMydEbg/jC8di3cmrezilGpOrdeTVDJ+ZbupRMg8nPLkOb/be0t16o=
Received: from HE1PR05MB3323.eurprd05.prod.outlook.com (10.170.245.27) by
 HE1PR05MB3324.eurprd05.prod.outlook.com (10.170.242.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Thu, 31 Oct 2019 19:47:34 +0000
Received: from HE1PR05MB3323.eurprd05.prod.outlook.com
 ([fe80::e56e:f134:8521:8385]) by HE1PR05MB3323.eurprd05.prod.outlook.com
 ([fe80::e56e:f134:8521:8385%6]) with mapi id 15.20.2387.027; Thu, 31 Oct 2019
 19:47:34 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "sbrivio@redhat.com" <sbrivio@redhat.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH net-next v2 1/3] net: Support querying specific VF properties
Thread-Topic: [PATCH net-next v2 1/3] net: Support querying specific VF
 properties
Thread-Index: AQHVkCQK1oaAmmlBKUuTTBT8ntwMZg==
Date:   Thu, 31 Oct 2019 19:47:34 +0000
Message-ID: <1572551213-9022-2-git-send-email-lariel@mellanox.com>
References: <1572551213-9022-1-git-send-email-lariel@mellanox.com>
In-Reply-To: <1572551213-9022-1-git-send-email-lariel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.188.199.18]
x-mailer: git-send-email 1.8.3.1
x-clientproxiedby: AM3PR04CA0148.eurprd04.prod.outlook.com (2603:10a6:207::32)
 To HE1PR05MB3323.eurprd05.prod.outlook.com (2603:10a6:7:31::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e0212ae7-4e1c-4452-55cc-08d75e3b2cb2
x-ms-traffictypediagnostic: HE1PR05MB3324:|HE1PR05MB3324:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR05MB3324CC487BF0560A3058B3DFBA630@HE1PR05MB3324.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02070414A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(189003)(199004)(486006)(11346002)(107886003)(8936002)(5660300002)(6506007)(86362001)(99286004)(2501003)(386003)(6916009)(25786009)(102836004)(50226002)(4326008)(478600001)(1730700003)(36756003)(446003)(2351001)(81166006)(81156014)(476003)(8676002)(2616005)(3846002)(14454004)(52116002)(66946007)(6116002)(6486002)(186003)(76176011)(305945005)(71190400001)(66446008)(66556008)(66476007)(7736002)(6512007)(256004)(6436002)(14444005)(66066001)(64756008)(4720700003)(316002)(26005)(2906002)(54906003)(71200400001)(5640700003);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3324;H:HE1PR05MB3323.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w3lZZMEXQ4UMtgp9YOnoHJhLSHkmoMaw7wLCvoK7HMy8s+rKA3Mshuo9VEO+N5ssrdeJ2B59Cs2PtkYtjkb3f74wqRn+ZwhP1qcq6oNT6hCA0uEhSu8mhzzslklKmvWPjMy4RJpII7rfrHuNJ6X0r326BUOs1yzifcG4hxEb9fixWyE6mhgVW1kD4O6tl14s91s7cGvUTW1m7sHn3dU9SqLn6OqoPhdkQscjiZDtWpO2gYjdPq3JRCxQLJCOEUH3MC65l1bOugVKRGrg50r2zBCgQrAdLWWiwgSB8cAyAr29b3BxqpUL6sWUv68B1Ii+LjO6aa4VXdMkkhYLerVjQYAxZreHuOBxTDRTmaWXdqfnml1DZptn/8KAcNbsA/GD9b6r2etKZDsz/diggSl2aFDBLHVpEBUqsu5cxuf2z2XzatIYqIOGx8EYttUdzbZH
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0212ae7-4e1c-4452-55cc-08d75e3b2cb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2019 19:47:34.5918
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QpxomLxSnsLFcbfH37vcO+g0Ua+rkUlPyXfxGtQwNqLcD89mQ0VVbqB6grHcbmgKZ1byDHN3HlMbchTRn8/69g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3324
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Querying the link with its VFs information involves putting a
vfinfo struct per VF in the netlink message under the
IFLA_VFINFO_LIST attribute.

Since the attribute's length is limited by it's definition to u16,
this introduces a problem when we want to add new fields to the
vfinfo attribute.
With increasing the vfinfo attribute and running in an environment
with a large number of VFs, we may overflow the IFLA_VFINFO_LIST
attribute length.

To avoid that, this patch introduces a single VF query.
With single VF query, the kernel may include extended VF information
and fields, such that take up a significant amount of memory, in the
vfinfo attribute.
This information may not be included with VF list
query and prevent attribute length overflow.

The admin will be able to query the link and get extended VF info
using iptool and following command:
ip link show dev <ifname> vf <vf_num>

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
---
 include/uapi/linux/if_link.h   |  1 +
 include/uapi/linux/rtnetlink.h |  3 ++-
 net/core/rtnetlink.c           | 53 +++++++++++++++++++++++++++++++++-----=
----
 3 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 8aec876..797e214 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -169,6 +169,7 @@ enum {
 	IFLA_MAX_MTU,
 	IFLA_PROP_LIST,
 	IFLA_ALT_IFNAME, /* Alternative ifname */
+	IFLA_VF_NUM, /* Get extended information for specific VF */
 	__IFLA_MAX
 };
=20
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.=
h
index 1418a83..8825ede 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -759,7 +759,8 @@ enum {
 #define RTEXT_FILTER_VF		(1 << 0)
 #define RTEXT_FILTER_BRVLAN	(1 << 1)
 #define RTEXT_FILTER_BRVLAN_COMPRESSED	(1 << 2)
-#define	RTEXT_FILTER_SKIP_STATS	(1 << 3)
+#define RTEXT_FILTER_SKIP_STATS	(1 << 3)
+#define RTEXT_FILTER_VF_EXT	(1 << 4)
=20
 /* End of information exported to user level */
=20
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 49fa910..4dd5939 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -906,9 +906,14 @@ static void copy_rtnl_link_stats(struct rtnl_link_stat=
s *a,
 static inline int rtnl_vfinfo_size(const struct net_device *dev,
 				   u32 ext_filter_mask)
 {
-	if (dev->dev.parent && (ext_filter_mask & RTEXT_FILTER_VF)) {
+	if (dev->dev.parent &&
+	    (ext_filter_mask & (RTEXT_FILTER_VF | RTEXT_FILTER_VF_EXT))) {
 		int num_vfs =3D dev_num_vf(dev->dev.parent);
 		size_t size =3D nla_total_size(0);
+
+		if (num_vfs && (ext_filter_mask & RTEXT_FILTER_VF_EXT))
+			num_vfs =3D 1;
+
 		size +=3D num_vfs *
 			(nla_total_size(0) +
 			 nla_total_size(sizeof(struct ifla_vf_mac)) +
@@ -1022,7 +1027,8 @@ static noinline size_t if_nlmsg_size(const struct net=
_device *dev,
 	       + nla_total_size(4) /* IFLA_LINK_NETNSID */
 	       + nla_total_size(4) /* IFLA_GROUP */
 	       + nla_total_size(ext_filter_mask
-			        & RTEXT_FILTER_VF ? 4 : 0) /* IFLA_NUM_VF */
+				& (RTEXT_FILTER_VF | RTEXT_FILTER_VF_EXT) ?
+				4 : 0) /* IFLA_NUM_VF */
 	       + rtnl_vfinfo_size(dev, ext_filter_mask) /* IFLA_VFINFO_LIST */
 	       + rtnl_port_size(dev, ext_filter_mask) /* IFLA_VF_PORTS + IFLA_POR=
T_SELF */
 	       + rtnl_link_get_size(dev) /* IFLA_LINKINFO */
@@ -1203,7 +1209,8 @@ static noinline_for_stack int rtnl_fill_stats(struct =
sk_buff *skb,
 static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 					       struct net_device *dev,
 					       int vfs_num,
-					       struct nlattr *vfinfo)
+					       struct nlattr *vfinfo,
+					       bool vf_ext)
 {
 	struct ifla_vf_rss_query_en vf_rss_query_en;
 	struct nlattr *vf, *vfstats, *vfvlanlist;
@@ -1332,15 +1339,25 @@ static noinline_for_stack int rtnl_fill_vfinfo(stru=
ct sk_buff *skb,
=20
 static noinline_for_stack int rtnl_fill_vf(struct sk_buff *skb,
 					   struct net_device *dev,
-					   u32 ext_filter_mask)
+					   u32 ext_filter_mask,
+					   int vf)
 {
+	bool vf_ext =3D (ext_filter_mask & RTEXT_FILTER_VF_EXT) && (vf >=3D 0);
 	struct nlattr *vfinfo;
 	int i, num_vfs;
=20
-	if (!dev->dev.parent || ((ext_filter_mask & RTEXT_FILTER_VF) =3D=3D 0))
+	if (!dev->dev.parent ||
+	    ((ext_filter_mask & (RTEXT_FILTER_VF | RTEXT_FILTER_VF_EXT)) =3D=3D 0=
))
 		return 0;
=20
 	num_vfs =3D dev_num_vf(dev->dev.parent);
+	if (vf_ext && num_vfs) {
+		if (vf > num_vfs)
+			return 0;
+
+		num_vfs =3D 1;
+	}
+
 	if (nla_put_u32(skb, IFLA_NUM_VF, num_vfs))
 		return -EMSGSIZE;
=20
@@ -1352,7 +1369,7 @@ static noinline_for_stack int rtnl_fill_vf(struct sk_=
buff *skb,
 		return -EMSGSIZE;
=20
 	for (i =3D 0; i < num_vfs; i++) {
-		if (rtnl_fill_vfinfo(skb, dev, i, vfinfo))
+		if (rtnl_fill_vfinfo(skb, dev, vf_ext ? vf : i, vfinfo, vf_ext))
 			return -EMSGSIZE;
 	}
=20
@@ -1639,7 +1656,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 			    int type, u32 pid, u32 seq, u32 change,
 			    unsigned int flags, u32 ext_filter_mask,
 			    u32 event, int *new_nsid, int new_ifindex,
-			    int tgt_netnsid)
+			    int tgt_netnsid, int vf)
 {
 	struct ifinfomsg *ifm;
 	struct nlmsghdr *nlh;
@@ -1717,7 +1734,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	if (rtnl_fill_stats(skb, dev))
 		goto nla_put_failure;
=20
-	if (rtnl_fill_vf(skb, dev, ext_filter_mask))
+	if (rtnl_fill_vf(skb, dev, ext_filter_mask, vf))
 		goto nla_put_failure;
=20
 	if (rtnl_port_fill(skb, dev, ext_filter_mask))
@@ -1806,6 +1823,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	[IFLA_PROP_LIST]	=3D { .type =3D NLA_NESTED },
 	[IFLA_ALT_IFNAME]	=3D { .type =3D NLA_STRING,
 				    .len =3D ALTIFNAMSIZ - 1 },
+	[IFLA_VF_NUM]		=3D { .type =3D NLA_U32 },
 };
=20
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] =3D {
@@ -2057,7 +2075,7 @@ static int rtnl_dump_ifinfo(struct sk_buff *skb, stru=
ct netlink_callback *cb)
 					       NETLINK_CB(cb->skb).portid,
 					       nlh->nlmsg_seq, 0, flags,
 					       ext_filter_mask, 0, NULL, 0,
-					       netnsid);
+					       netnsid, -1);
=20
 			if (err < 0) {
 				if (likely(skb->len))
@@ -3365,6 +3383,7 @@ static int rtnl_valid_getlink_req(struct sk_buff *skb=
,
 		case IFLA_ALT_IFNAME:
 		case IFLA_EXT_MASK:
 		case IFLA_TARGET_NETNSID:
+		case IFLA_VF_NUM:
 			break;
 		default:
 			NL_SET_ERR_MSG(extack, "Unsupported attribute in get link request");
@@ -3385,6 +3404,7 @@ static int rtnl_getlink(struct sk_buff *skb, struct n=
lmsghdr *nlh,
 	struct net_device *dev =3D NULL;
 	struct sk_buff *nskb;
 	int netnsid =3D -1;
+	int vf =3D -1;
 	int err;
 	u32 ext_filter_mask =3D 0;
=20
@@ -3407,6 +3427,17 @@ static int rtnl_getlink(struct sk_buff *skb, struct =
nlmsghdr *nlh,
 		ext_filter_mask =3D nla_get_u32(tb[IFLA_EXT_MASK]);
=20
 	err =3D -EINVAL;
+	if ((ext_filter_mask & RTEXT_FILTER_VF) &&
+	    (ext_filter_mask & RTEXT_FILTER_VF_EXT))
+		goto out;
+
+	if (ext_filter_mask & RTEXT_FILTER_VF_EXT) {
+		if (tb[IFLA_VF_NUM])
+			vf =3D nla_get_u32(tb[IFLA_VF_NUM]);
+		else
+			goto out;
+	}
+
 	ifm =3D nlmsg_data(nlh);
 	if (ifm->ifi_index > 0)
 		dev =3D __dev_get_by_index(tgt_net, ifm->ifi_index);
@@ -3428,7 +3459,7 @@ static int rtnl_getlink(struct sk_buff *skb, struct n=
lmsghdr *nlh,
 	err =3D rtnl_fill_ifinfo(nskb, dev, net,
 			       RTM_NEWLINK, NETLINK_CB(skb).portid,
 			       nlh->nlmsg_seq, 0, 0, ext_filter_mask,
-			       0, NULL, 0, netnsid);
+			       0, NULL, 0, netnsid, vf);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in if_nlmsg_size */
 		WARN_ON(err =3D=3D -EMSGSIZE);
@@ -3634,7 +3665,7 @@ struct sk_buff *rtmsg_ifinfo_build_skb(int type, stru=
ct net_device *dev,
=20
 	err =3D rtnl_fill_ifinfo(skb, dev, dev_net(dev),
 			       type, 0, 0, change, 0, 0, event,
-			       new_nsid, new_ifindex, -1);
+			       new_nsid, new_ifindex, -1, -1);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in if_nlmsg_size() */
 		WARN_ON(err =3D=3D -EMSGSIZE);
--=20
1.8.3.1

