Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6564BEA42E
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 20:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfJ3TZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 15:25:30 -0400
Received: from mail-eopbgr140050.outbound.protection.outlook.com ([40.107.14.50]:40260
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726699AbfJ3TZa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 15:25:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Syzt1/NYwHcWGRuhyTK6+NIqRyGR5WbQItxTcysS4sgBiaDpjEWZ7JEUrmU1C+LoyQen1MwENn3N9DWR6iA1CkbyRYB+VodKYXm2toaQvnczAjAzEAJyG6xQVuF2I2ERi9cYXPGrZCqiLMAW0CTvbXDtVKPSx/rV3QdZ44Zip6hKV1fAjaSUTl/6RvrsQRSv+RsIbfsuhrDaYmoIqdgbuuKwo5PrNsJXWqcveTIJnnlpmsb0cXW+Y+fpvIvsuS+gr4CY6OQjcrzp2FTNQWpxDAa+7Yh3R3wmRlAKDFLQx1nBYH7nu16XfBjyiRMLMxzWuh4ABjk4AZPb+ENFTBArXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M7u+pi27Hbjo2tXK4QXUvw9wJNG1qqdnzZeB5rHyBp8=;
 b=UfBpji8lNx0mZY9IotHXurVNKE9kC/XKEGprOogBDd8AHJxhQut7PZrnJFAXpp6hHgfNivX5uAaVln48x8ivAW7oG4CJQF4RFixkn1mIegenPLIaVCLy7AaNBEEiqmDeIkTsS04yVfD22tw/MvZ9bsIiacQLNXSO3njEqDErg3FWvYja3JRLAfzQx/t9VHePQdnrVoLaeIKIX1svqNc/6z4h2h6B8+MspgmEAdnyH8Ni7Uk/pGxuF96BNfyDInuir9L+5QWugEfkJ13nPQeps+WiqjjHUdobswD3EkRF5ahiWPfxN2+d26RGZptco97ZpRF1GjnHQ7R8T0Rcow8jZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M7u+pi27Hbjo2tXK4QXUvw9wJNG1qqdnzZeB5rHyBp8=;
 b=o6eVHMd/dYHCIFoPwbcoy+2CpvFEFclsmJyzrB6LFE7jE8M+AgJru8++QqB9KnHRQxS9vPPinwkVnKwGTR491xqg5XZjMOqjsT6vlTUZ5b8SaVVVsdsVFTc5FQru75wE6PkZ8nuv5/yqCk7d7ddM7QVuUhyZmzvTFlrZO2qomRE=
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com (10.171.189.29) by
 AM4PR05MB3186.eurprd05.prod.outlook.com (10.171.191.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Wed, 30 Oct 2019 19:25:22 +0000
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc]) by AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc%4]) with mapi id 15.20.2408.016; Wed, 30 Oct 2019
 19:25:22 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH v2 2/3] net: Add SRIOV VGT+ support
Thread-Topic: [PATCH v2 2/3] net: Add SRIOV VGT+ support
Thread-Index: AQHVj1fG2QUcFbR/bUyGKFpXaLSl4w==
Date:   Wed, 30 Oct 2019 19:25:22 +0000
Message-ID: <1572463515-26961-3-git-send-email-lariel@mellanox.com>
References: <1572463515-26961-1-git-send-email-lariel@mellanox.com>
In-Reply-To: <1572463515-26961-1-git-send-email-lariel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.188.199.18]
x-mailer: git-send-email 1.8.3.1
x-clientproxiedby: AM0PR05CA0093.eurprd05.prod.outlook.com
 (2603:10a6:208:136::33) To AM4PR05MB3313.eurprd05.prod.outlook.com
 (2603:10a6:205:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2bb1bef3-f201-41c7-a941-08d75d6ee880
x-ms-traffictypediagnostic: AM4PR05MB3186:|AM4PR05MB3186:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB31862210DA16083F9DC6D067BA600@AM4PR05MB3186.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(189003)(199004)(30864003)(305945005)(7736002)(64756008)(66446008)(14444005)(25786009)(316002)(66556008)(256004)(6506007)(386003)(54906003)(71200400001)(4326008)(71190400001)(486006)(2351001)(2906002)(6486002)(6512007)(2616005)(6436002)(446003)(11346002)(86362001)(6916009)(5640700003)(107886003)(52116002)(476003)(50226002)(14454004)(8936002)(8676002)(1730700003)(81156014)(81166006)(99286004)(76176011)(186003)(66476007)(5660300002)(66946007)(2501003)(3846002)(478600001)(102836004)(4720700003)(66066001)(36756003)(6116002)(26005)(309714004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3186;H:AM4PR05MB3313.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fKs4R2N9lwd1DBlJ0jP2dJWWFHlf82Dk4/sfIz21jNn6r9qxp7Dqtwiez5L8ovwMYsupVI0nYY/LaKXpgHUaZWxihtgOtDSWsWkw/4nAl0YSMRPXG8rfRIdIa71ZZ8dNGnbwdQR4JtLmtSkojVK7fJgjq7Pe0sQoeS4xaducuYQIjedg9nYvrO0OSh7dx+zkh1zftsJh8LaFbhqERC2EP1Y2xKKQfYcZqLBW0k1cenrMmHV5rIpEhEKZeUYDa0PYJ+dp46OuH94xhAuXm3Hbnjw7KaVfD3gh+zm18OBpxVbe/qlb4v4skbuOFUCjdx5AeFoXFWX7OiZa6/NgAJ8UW5YNYBCMlzCXHHVDwAhYonhFAWzFimSeG2+8sJ+oLiCcGfIeSDqOS50n2nUCpNQ2JS0VGpK8bpfMuaw+bCsYZTL3A9Quc+gjwACZAhoAjXTK
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bb1bef3-f201-41c7-a941-08d75d6ee880
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 19:25:22.6035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dMc2zb2oAowFIiwNYe8REAQ9HYoDT2jgywW3A8zwsRgdUC3gMrLmLPArJyoVYJ0761W7YsS8sb7hhVA5yF/Vmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3186
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGT+ is a security feature that gives the administrator the ability of
controlling the allowed vlan-ids list that can be transmitted/received
from/to the VF.
The allowed vlan-ids list is called "trunk".
Admin can add/remove a range of allowed vlan-ids via iptool.
Example:
After this series of configuration :
1) ip link set eth3 vf 0 trunk add 10 100 (allow vlan-id 10-100, default tp=
id 0x8100)
2) ip link set eth3 vf 0 trunk add 105 proto 802.1q (allow vlan-id 105 tpid=
 0x8100)
3) ip link set eth3 vf 0 trunk add 105 proto 802.1ad (allow vlan-id 105 tpi=
d 0x88a8)
4) ip link set eth3 vf 0 trunk rem 90 (block vlan-id 90)
5) ip link set eth3 vf 0 trunk rem 50 60 (block vlan-ids 50-60)

The VF 0 can only communicate on vlan-ids: 10-49,61-89,91-100,105 with
tpid 0x8100 and vlan-id 105 with tpid 0x88a8.

For this purpose we added the following netlink sr-iov commands:

1) IFLA_VF_VLAN_RANGE: used to add/remove allowed vlan-ids range.
We added the ifla_vf_vlan_range struct to specify the range we want to
add/remove from the userspace.
We added ndo_add_vf_vlan_trunk_range and ndo_del_vf_vlan_trunk_range
netdev ops to add/remove allowed vlan-ids range in the netdev.

2) IFLA_VF_VLAN_TRUNK: used to query the allowed vlan-ids trunk.
We added trunk bitmap to the ifla_vf_info struct to get the current
allowed vlan-ids trunk from the netdev.
We added ifla_vf_vlan_trunk struct for sending the allowed vlan-ids
trunk to the userspace.
Since the trunk bitmap needs to contain a bit per possible enabled
vlan id, the size addition to ifla_vf_info is significant which may
create attribute length overrun when querying all the VFs.

Therefore, the return of the full bitmap is limited to the case
where the admin queries a specific VF only and for the VF list
query we introduce a new vf_info attribute called ifla_vf_vlan_mode
that will present the current VF tagging mode - VGT, VST or VGT+(trunk).

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
---
 include/linux/if_link.h      |   3 ++
 include/linux/netdevice.h    |  12 +++++
 include/uapi/linux/if_link.h |  34 ++++++++++++
 net/core/rtnetlink.c         | 122 ++++++++++++++++++++++++++++++++-------=
----
 4 files changed, 140 insertions(+), 31 deletions(-)

diff --git a/include/linux/if_link.h b/include/linux/if_link.h
index 622658d..7146181 100644
--- a/include/linux/if_link.h
+++ b/include/linux/if_link.h
@@ -28,6 +28,9 @@ struct ifla_vf_info {
 	__u32 max_tx_rate;
 	__u32 rss_query_en;
 	__u32 trusted;
+	__u32 vlan_mode;
+	__u64 trunk_8021q[VF_VLAN_BITMAP];
+	__u64 trunk_8021ad[VF_VLAN_BITMAP];
 	__be16 vlan_proto;
 };
 #endif /* _LINUX_IF_LINK_H */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3207e0b..da79976 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1067,6 +1067,10 @@ struct netdev_name_node {
  *      Hash Key. This is needed since on some devices VF share this infor=
mation
  *      with PF and querying it may introduce a theoretical security risk.
  * int (*ndo_set_vf_rss_query_en)(struct net_device *dev, int vf, bool set=
ting);
+ * int (*ndo_add_vf_vlan_trunk_range)(struct net_device *dev, int vf,
+ *				      u16 start_vid, u16 end_vid, __be16 proto);
+ * int (*ndo_del_vf_vlan_trunk_range)(struct net_device *dev, int vf,
+ *				      u16 start_vid, u16 end_vid, __be16 proto);
  * int (*ndo_get_vf_port)(struct net_device *dev, int vf, struct sk_buff *=
skb);
  * int (*ndo_setup_tc)(struct net_device *dev, enum tc_setup_type type,
  *		       void *type_data);
@@ -1332,6 +1336,14 @@ struct net_device_ops {
 	int			(*ndo_set_vf_rss_query_en)(
 						   struct net_device *dev,
 						   int vf, bool setting);
+	int			(*ndo_add_vf_vlan_trunk_range)(
+						   struct net_device *dev,
+						   int vf, u16 start_vid,
+						   u16 end_vid, __be16 proto);
+	int			(*ndo_del_vf_vlan_trunk_range)(
+						   struct net_device *dev,
+						   int vf, u16 start_vid,
+						   u16 end_vid, __be16 proto);
 	int			(*ndo_setup_tc)(struct net_device *dev,
 						enum tc_setup_type type,
 						void *type_data);
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 797e214..35ab210 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -180,6 +180,8 @@ enum {
 #ifndef __KERNEL__
 #define IFLA_RTA(r)  ((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(s=
truct ifinfomsg))))
 #define IFLA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct ifinfomsg))
+#define BITS_PER_BYTE 8
+#define DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
 #endif
=20
 enum {
@@ -699,6 +701,9 @@ enum {
 	IFLA_VF_IB_PORT_GUID,	/* VF Infiniband port GUID */
 	IFLA_VF_VLAN_LIST,	/* nested list of vlans, option for QinQ */
 	IFLA_VF_BROADCAST,	/* VF broadcast */
+	IFLA_VF_VLAN_MODE,	/* vlan tagging mode */
+	IFLA_VF_VLAN_RANGE,	/* add/delete vlan range filtering */
+	IFLA_VF_VLAN_TRUNK,	/* vlan trunk filtering */
 	__IFLA_VF_MAX,
 };
=20
@@ -713,6 +718,19 @@ struct ifla_vf_broadcast {
 	__u8 broadcast[32];
 };
=20
+enum {
+	IFLA_VF_VLAN_MODE_UNSPEC,
+	IFLA_VF_VLAN_MODE_VGT,
+	IFLA_VF_VLAN_MODE_VST,
+	IFLA_VF_VLAN_MODE_TRUNK,
+	__IFLA_VF_VLAN_MODE_MAX,
+};
+
+struct ifla_vf_vlan_mode {
+	__u32 vf;
+	__u32 mode; /* The VLAN tagging mode */
+};
+
 struct ifla_vf_vlan {
 	__u32 vf;
 	__u32 vlan; /* 0 - 4095, 0 disables VLAN filter */
@@ -727,6 +745,7 @@ enum {
=20
 #define IFLA_VF_VLAN_INFO_MAX (__IFLA_VF_VLAN_INFO_MAX - 1)
 #define MAX_VLAN_LIST_LEN 1
+#define VF_VLAN_N_VID 4096
=20
 struct ifla_vf_vlan_info {
 	__u32 vf;
@@ -735,6 +754,21 @@ struct ifla_vf_vlan_info {
 	__be16 vlan_proto; /* VLAN protocol either 802.1Q or 802.1ad */
 };
=20
+struct ifla_vf_vlan_range {
+	__u32 vf;
+	__u32 start_vid;   /* 1 - 4095 */
+	__u32 end_vid;     /* 1 - 4095 */
+	__u32 setting;
+	__be16 vlan_proto; /* VLAN protocol either 802.1Q or 802.1ad */
+};
+
+#define VF_VLAN_BITMAP	DIV_ROUND_UP(VF_VLAN_N_VID, sizeof(__u64) * BITS_PE=
R_BYTE)
+struct ifla_vf_vlan_trunk {
+	__u32 vf;
+	__u64 allowed_vlans_8021q_bm[VF_VLAN_BITMAP];
+	__u64 allowed_vlans_8021ad_bm[VF_VLAN_BITMAP];
+};
+
 struct ifla_vf_tx_rate {
 	__u32 vf;
 	__u32 rate; /* Max TX bandwidth in Mbps, 0 disables throttling */
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 31fa0af..e273abb 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -911,8 +911,10 @@ static inline int rtnl_vfinfo_size(const struct net_de=
vice *dev,
 		int num_vfs =3D dev_num_vf(dev->dev.parent);
 		size_t size =3D nla_total_size(0);
=20
-		if (num_vfs && (ext_filter_mask & RTEXT_FILTER_VF_EXT))
+		if (num_vfs && (ext_filter_mask & RTEXT_FILTER_VF_EXT)) {
 			num_vfs =3D 1;
+			size +=3D nla_total_size(sizeof(struct ifla_vf_vlan_trunk));
+		}
=20
 		size +=3D num_vfs *
 			(nla_total_size(0) +
@@ -927,6 +929,7 @@ static inline int rtnl_vfinfo_size(const struct net_dev=
ice *dev,
 			 nla_total_size(sizeof(struct ifla_vf_rate)) +
 			 nla_total_size(sizeof(struct ifla_vf_link_state)) +
 			 nla_total_size(sizeof(struct ifla_vf_rss_query_en)) +
+			 nla_total_size(sizeof(struct ifla_vf_vlan_mode)) +
 			 nla_total_size(0) + /* nest IFLA_VF_STATS */
 			 /* IFLA_VF_STATS_RX_PACKETS */
 			 nla_total_size_64bit(sizeof(__u64)) +
@@ -1216,7 +1219,9 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct=
 sk_buff *skb,
 	struct nlattr *vf, *vfstats, *vfvlanlist;
 	struct ifla_vf_link_state vf_linkstate;
 	struct ifla_vf_vlan_info vf_vlan_info;
+	struct ifla_vf_vlan_mode vf_vlan_mode;
 	struct ifla_vf_spoofchk vf_spoofchk;
+	struct ifla_vf_vlan_trunk *vf_trunk;
 	struct ifla_vf_tx_rate vf_tx_rate;
 	struct ifla_vf_stats vf_stats;
 	struct ifla_vf_trust vf_trust;
@@ -1224,25 +1229,36 @@ static noinline_for_stack int rtnl_fill_vfinfo(stru=
ct sk_buff *skb,
 	struct ifla_vf_rate vf_rate;
 	struct ifla_vf_mac vf_mac;
 	struct ifla_vf_broadcast vf_broadcast;
-	struct ifla_vf_info ivi;
+	struct ifla_vf_info *ivi;
+
+	ivi =3D kzalloc(sizeof(*ivi), GFP_KERNEL);
+	if (!ivi)
+		return -ENOMEM;
=20
-	memset(&ivi, 0, sizeof(ivi));
+	vf_trunk =3D kzalloc(sizeof(*vf_trunk), GFP_KERNEL);
+	if (!vf_trunk) {
+		kfree(ivi);
+		return -ENOMEM;
+	}
=20
 	/* Not all SR-IOV capable drivers support the
 	 * spoofcheck and "RSS query enable" query.  Preset to
 	 * -1 so the user space tool can detect that the driver
 	 * didn't report anything.
 	 */
-	ivi.spoofchk =3D -1;
-	ivi.rss_query_en =3D -1;
-	ivi.trusted =3D -1;
+	ivi->spoofchk =3D -1;
+	ivi->rss_query_en =3D -1;
+	ivi->trusted =3D -1;
+	memset(ivi->mac, 0, sizeof(ivi->mac));
+	memset(ivi->trunk_8021q, 0, sizeof(ivi->trunk_8021q));
+	memset(ivi->trunk_8021ad, 0, sizeof(ivi->trunk_8021ad));
 	/* The default value for VF link state is "auto"
 	 * IFLA_VF_LINK_STATE_AUTO which equals zero
 	 */
-	ivi.linkstate =3D 0;
+	ivi->linkstate =3D 0;
 	/* VLAN Protocol by default is 802.1Q */
-	ivi.vlan_proto =3D htons(ETH_P_8021Q);
-	if (dev->netdev_ops->ndo_get_vf_config(dev, vfs_num, &ivi))
+	ivi->vlan_proto =3D htons(ETH_P_8021Q);
+	if (dev->netdev_ops->ndo_get_vf_config(dev, vfs_num, ivi))
 		return 0;
=20
 	memset(&vf_vlan_info, 0, sizeof(vf_vlan_info));
@@ -1255,22 +1271,26 @@ static noinline_for_stack int rtnl_fill_vfinfo(stru=
ct sk_buff *skb,
 		vf_spoofchk.vf =3D
 		vf_linkstate.vf =3D
 		vf_rss_query_en.vf =3D
-		vf_trust.vf =3D ivi.vf;
-
-	memcpy(vf_mac.mac, ivi.mac, sizeof(ivi.mac));
-	memcpy(vf_broadcast.broadcast, dev->broadcast, dev->addr_len);
-	vf_vlan.vlan =3D ivi.vlan;
-	vf_vlan.qos =3D ivi.qos;
-	vf_vlan_info.vlan =3D ivi.vlan;
-	vf_vlan_info.qos =3D ivi.qos;
-	vf_vlan_info.vlan_proto =3D ivi.vlan_proto;
-	vf_tx_rate.rate =3D ivi.max_tx_rate;
-	vf_rate.min_tx_rate =3D ivi.min_tx_rate;
-	vf_rate.max_tx_rate =3D ivi.max_tx_rate;
-	vf_spoofchk.setting =3D ivi.spoofchk;
-	vf_linkstate.link_state =3D ivi.linkstate;
-	vf_rss_query_en.setting =3D ivi.rss_query_en;
-	vf_trust.setting =3D ivi.trusted;
+		vf_vlan_mode.vf =3D
+		vf_trunk->vf =3D
+		vf_trust.vf =3D ivi->vf;
+
+	memcpy(vf_mac.mac, ivi->mac, sizeof(ivi->mac));
+	memcpy(vf_trunk->allowed_vlans_8021q_bm, ivi->trunk_8021q, sizeof(ivi->tr=
unk_8021q));
+	memcpy(vf_trunk->allowed_vlans_8021ad_bm, ivi->trunk_8021ad, sizeof(ivi->=
trunk_8021ad));
+	vf_vlan_mode.mode =3D ivi->vlan_mode;
+	vf_vlan.vlan =3D ivi->vlan;
+	vf_vlan.qos =3D ivi->qos;
+	vf_vlan_info.vlan =3D ivi->vlan;
+	vf_vlan_info.qos =3D ivi->qos;
+	vf_vlan_info.vlan_proto =3D ivi->vlan_proto;
+	vf_tx_rate.rate =3D ivi->max_tx_rate;
+	vf_rate.min_tx_rate =3D ivi->min_tx_rate;
+	vf_rate.max_tx_rate =3D ivi->max_tx_rate;
+	vf_spoofchk.setting =3D ivi->spoofchk;
+	vf_linkstate.link_state =3D ivi->linkstate;
+	vf_rss_query_en.setting =3D ivi->rss_query_en;
+	vf_trust.setting =3D ivi->trusted;
 	vf =3D nla_nest_start_noflag(skb, IFLA_VF_INFO);
 	if (!vf)
 		goto nla_put_vfinfo_failure;
@@ -1289,7 +1309,11 @@ static noinline_for_stack int rtnl_fill_vfinfo(struc=
t sk_buff *skb,
 		    sizeof(vf_rss_query_en),
 		    &vf_rss_query_en) ||
 	    nla_put(skb, IFLA_VF_TRUST,
-		    sizeof(vf_trust), &vf_trust))
+		    sizeof(vf_trust), &vf_trust) ||
+	    nla_put(skb, IFLA_VF_VLAN_MODE,
+		    sizeof(vf_vlan_mode), &vf_vlan_mode) ||
+	    (vf_ext && nla_put(skb, IFLA_VF_VLAN_TRUNK,
+			       sizeof(*vf_trunk), vf_trunk)))
 		goto nla_put_vf_failure;
 	vfvlanlist =3D nla_nest_start_noflag(skb, IFLA_VF_VLAN_LIST);
 	if (!vfvlanlist)
@@ -1328,12 +1352,16 @@ static noinline_for_stack int rtnl_fill_vfinfo(stru=
ct sk_buff *skb,
 	}
 	nla_nest_end(skb, vfstats);
 	nla_nest_end(skb, vf);
+	kfree(vf_trunk);
+	kfree(ivi);
 	return 0;
=20
 nla_put_vf_failure:
 	nla_nest_cancel(skb, vf);
 nla_put_vfinfo_failure:
 	nla_nest_cancel(skb, vfinfo);
+	kfree(vf_trunk);
+	kfree(ivi);
 	return -EMSGSIZE;
 }
=20
@@ -1843,6 +1871,9 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	[IFLA_VF_TRUST]		=3D { .len =3D sizeof(struct ifla_vf_trust) },
 	[IFLA_VF_IB_NODE_GUID]	=3D { .len =3D sizeof(struct ifla_vf_guid) },
 	[IFLA_VF_IB_PORT_GUID]	=3D { .len =3D sizeof(struct ifla_vf_guid) },
+	[IFLA_VF_VLAN_MODE]	=3D { .len =3D sizeof(struct ifla_vf_vlan_mode) },
+	[IFLA_VF_VLAN_RANGE]	=3D { .len =3D sizeof(struct ifla_vf_vlan_range) },
+	[IFLA_VF_VLAN_TRUNK]	=3D { .len =3D sizeof(struct ifla_vf_vlan_trunk) },
 };
=20
 static const struct nla_policy ifla_port_policy[IFLA_PORT_MAX+1] =3D {
@@ -2285,6 +2316,26 @@ static int do_setvfinfo(struct net_device *dev, stru=
ct nlattr **tb)
 			return err;
 	}
=20
+	if (tb[IFLA_VF_VLAN_RANGE]) {
+		struct ifla_vf_vlan_range *ivvr =3D
+					nla_data(tb[IFLA_VF_VLAN_RANGE]);
+		bool add =3D !!ivvr->setting;
+
+		err =3D -EOPNOTSUPP;
+		if (add && ops->ndo_add_vf_vlan_trunk_range)
+			err =3D ops->ndo_add_vf_vlan_trunk_range(dev, ivvr->vf,
+							       ivvr->start_vid,
+							       ivvr->end_vid,
+							       ivvr->vlan_proto);
+		else if (!add && ops->ndo_del_vf_vlan_trunk_range)
+			err =3D ops->ndo_del_vf_vlan_trunk_range(dev, ivvr->vf,
+							       ivvr->start_vid,
+							       ivvr->end_vid,
+							       ivvr->vlan_proto);
+		if (err < 0)
+			return err;
+	}
+
 	if (tb[IFLA_VF_VLAN_LIST]) {
 		struct ifla_vf_vlan_info *ivvl[MAX_VLAN_LIST_LEN];
 		struct nlattr *attr;
@@ -2316,21 +2367,30 @@ static int do_setvfinfo(struct net_device *dev, str=
uct nlattr **tb)
=20
 	if (tb[IFLA_VF_TX_RATE]) {
 		struct ifla_vf_tx_rate *ivt =3D nla_data(tb[IFLA_VF_TX_RATE]);
-		struct ifla_vf_info ivf;
+		struct ifla_vf_info *ivf;
+
+		ivf =3D kzalloc(sizeof(*ivf), GFP_KERNEL);
+		if (!ivf)
+			return -ENOMEM;
=20
 		err =3D -EOPNOTSUPP;
 		if (ops->ndo_get_vf_config)
-			err =3D ops->ndo_get_vf_config(dev, ivt->vf, &ivf);
-		if (err < 0)
+			err =3D ops->ndo_get_vf_config(dev, ivt->vf, ivf);
+		if (err < 0) {
+			kfree(ivf);
 			return err;
+		}
=20
 		err =3D -EOPNOTSUPP;
 		if (ops->ndo_set_vf_rate)
 			err =3D ops->ndo_set_vf_rate(dev, ivt->vf,
-						   ivf.min_tx_rate,
+						   ivf->min_tx_rate,
 						   ivt->rate);
-		if (err < 0)
+		if (err < 0) {
+			kfree(ivf);
 			return err;
+		}
+		kfree(ivf);
 	}
=20
 	if (tb[IFLA_VF_RATE]) {
--=20
1.8.3.1

