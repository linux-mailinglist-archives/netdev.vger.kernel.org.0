Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F63AEB829
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 20:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729691AbfJaTzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 15:55:43 -0400
Received: from mail-eopbgr150071.outbound.protection.outlook.com ([40.107.15.71]:24827
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727648AbfJaTzm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 15:55:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LviNtNe835O+S3BMY5iDXTk/hUrBFuE9ZMJXIosM9qjuTCUHZfc5M0zjYrq4vIMx03XgoaUp0rlowmNMYjErB57BmdZuVnzxa44D8diLRwsZXm0Vrrl7vj7XdwBowuto3KB5p0o08g3/DAgTrOdSkcdUvIvosw4R5e4liDgzvpBY614KfwGVIzZ9sOHEgl+DaS0cm4CQxm/zvJ5lLlBVXvB3Q3IGwuUP2NwTjmIRv/+mWHe7Za4CgHx1dIpZcv8q04FYP6WDfVixQeBCb5lGAJtUDiR0mbY4aJcZRfA2YQ8COohngetkPExvE91pipbTge/GG4M8XU5e5Z+fxWP/vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DTv5csp7BN+h2D2sixAsucw+79YHxnVT2JxZ5FDIGd0=;
 b=lgJl1cUCbtYfQrLvFbvtk3CW/tmbh41dgvo8LH28ifVsayqtc/RMAFu36kq9Oxr0wHJ75w+evnATR56nV1UM/BlU5zEVonjrOCxJEa1xSO/pPwJgc/uKXKQ36rsqmSlK9XfflQWC1Dd0iv/BYWw7m9/jZ6Tw1lPqaC+qz/MlkvSRjAxyF1ID05bPbH16jtdPEWJX9t6f48GE+7PIo6W2DBs6rJHMlAKQsHauS+UYy0NbWQT/OzPocwZ2hNQ8KWwDzrENvXseqZj9dnUmUlGf+/3i7adYhZSepC1qqNnkJKiB+COVkMvDu0KXExobCC1dYAAvITL7bbKt8L6phVSTpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DTv5csp7BN+h2D2sixAsucw+79YHxnVT2JxZ5FDIGd0=;
 b=PoJPyU3f4NPQUbTv/KLj8xsSq0J1Zong8kfZ/FknopFjmFDCKPEXJ/wRdrfFaPcPHfyIDHk01ojKpguHQKPefCUhBGRFhDUsLyzidTjvMB7FauCLuB/CnWul2+s5ypg92eT2Qak6vi8FRQc+KYXwp5C7aDo43Ek4zXKvYBlH8jI=
Received: from HE1PR05MB3323.eurprd05.prod.outlook.com (10.170.245.27) by
 HE1PR05MB3324.eurprd05.prod.outlook.com (10.170.242.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Thu, 31 Oct 2019 19:55:34 +0000
Received: from HE1PR05MB3323.eurprd05.prod.outlook.com
 ([fe80::e56e:f134:8521:8385]) by HE1PR05MB3323.eurprd05.prod.outlook.com
 ([fe80::e56e:f134:8521:8385%6]) with mapi id 15.20.2387.027; Thu, 31 Oct 2019
 19:55:34 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH iproute2-next v2 3/3] ip: Add SR-IOV VF VGT+ support
Thread-Topic: [PATCH iproute2-next v2 3/3] ip: Add SR-IOV VF VGT+ support
Thread-Index: AQHVkCUoFNZJbMkTYUeixW/E1kk+mg==
Date:   Thu, 31 Oct 2019 19:55:34 +0000
Message-ID: <1572551722-9520-4-git-send-email-lariel@mellanox.com>
References: <1572551722-9520-1-git-send-email-lariel@mellanox.com>
In-Reply-To: <1572551722-9520-1-git-send-email-lariel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.188.199.18]
x-mailer: git-send-email 1.8.3.1
x-clientproxiedby: AM3PR04CA0137.eurprd04.prod.outlook.com (2603:10a6:207::21)
 To HE1PR05MB3323.eurprd05.prod.outlook.com (2603:10a6:7:31::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 03d77c35-bed8-4c35-3177-08d75e3c4ade
x-ms-traffictypediagnostic: HE1PR05MB3324:|HE1PR05MB3324:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR05MB3324599FD71568AA14838FC3BA630@HE1PR05MB3324.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:597;
x-forefront-prvs: 02070414A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(189003)(199004)(76176011)(71190400001)(305945005)(186003)(66556008)(6512007)(7736002)(66476007)(66446008)(66946007)(3846002)(52116002)(14454004)(6486002)(6116002)(64756008)(316002)(4720700003)(26005)(5640700003)(71200400001)(2906002)(54906003)(256004)(14444005)(66066001)(6436002)(6506007)(86362001)(2501003)(99286004)(11346002)(486006)(5660300002)(8936002)(107886003)(386003)(446003)(1730700003)(36756003)(476003)(8676002)(2616005)(2351001)(81156014)(81166006)(478600001)(50226002)(6916009)(102836004)(25786009)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3324;H:HE1PR05MB3323.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GNh6rVH71ovUt0f9RKfW1MNvsb1iTfIhoL7zoKAK5cedahfdxk3eRGR31D8v09OleYX8H/2wMgr6+6NtfZxBS4jhytjKIBrdJmpd2D2iqdROmWKcFiyMCYHVgnnMtK1QYBJOTvz2+1Ds4jAYoXyQjVEuPvPyybM3g24TBtHe/j8qGJ72nrUM5E/64YHFb503mxbbGPEnUNi0qUMOQWgsktdcC2wxUKRsZolYITrywnrcBhJG/QfA5df41TiRdWUYhDM7cmLZprlfOt7GPnZwWyejqthnfQQlMW/bk11itAnldyWMC3FQEzwaHUpCF+ZZW87oLlTPg0iidtfa0fE0VZegPQiTOX/PP0LpNgVkxUSpP9XuuL+4/YxkckTSxJ5DIm4kD6dJ54u04hH7BgABVJP0rCtbhTaSRusi8DuxkOns/qJfJFx67fKrA1BfQeWg
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03d77c35-bed8-4c35-3177-08d75e3c4ade
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2019 19:55:34.5967
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eyX3oNBf538KCoA9ffrjEZxGexvuSTILAx85rtFKByKcNGjV0AX9TtHmcRAAXmul9b4q/SREnoCppPpEx2001A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3324
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new API that can add/remove allowed vlan-ids per VF to
support the VGT+ feature.
Also intoroduce a new API to query the current allowed vlan-ids per VF.

VGT+ is a security feature that gives the administrator the ability of
controlling the allowed vlan-ids list that can be transmitted/received
from/to the VF.
The allowed vlan-ids list is called "trunk".
Admin can add/delete a range of allowed vlan-ids via iptool.

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
The VF 0 can only communicate on vlan-ids: 10-49,61-89,91-100,105 with tpid=
 0x8100
and vlan-id 105 with tpid 0x88a8.

For this purpose we added the following netlink sr-iov commands:
1) IFLA_VF_VLAN_RANGE: used to add/remove allowed vlan-ids range.
we added the ifla_vf_vlan_range struct to specify the range we want to
add/remove from the userspace.
2) IFLA_VF_VLAN_TRUNK: used to query the allowed vlan-ids trunk.
we added ifla_vf_vlan_trunk struct for sending the allowed vlan-ids
trunk to the userspace.
The allowed vlan-ids will be presented only when the query is for
a specific vf.

Example:
Running the following command will set the vlan trunk to include 10-100:
1)ip link set eth3 vf 0 trunk add 10 100

Then running:
2)ip link show dev eth3 vf 0
Will show:
vf 0     link/ether 00:00:00:00:00:00 brd 00:00:00:00:00:f3, spoof checking=
 off, link-state auto, trust off, query_rss off
    Allowed 802.1Q VLANs: 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 2=
2, 23, 24, 25, 26, 27, 28,
    29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46,=
 47, 48, 49, 50, 51, 52,
    53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70,=
 71, 72, 73, 74, 75, 76,
    77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94,=
 95, 96, 97, 98, 99, 100.

Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
---
 include/uapi/linux/if_link.h | 19 ++++++++++++++++
 ip/ipaddress.c               | 52 ++++++++++++++++++++++++++++++++++++++++=
++++
 ip/iplink.c                  | 46 +++++++++++++++++++++++++++++++++++++++
 man/man8/ip-link.8.in        | 17 ++++++++++++++-
 4 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 6304add..ff29803 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -698,6 +698,8 @@ enum {
 	IFLA_VF_VLAN_LIST,	/* nested list of vlans, option for QinQ */
 	IFLA_VF_BROADCAST,	/* VF broadcast */
 	IFLA_VF_VLAN_MODE,	/* vlan tagging mode */
+	IFLA_VF_VLAN_RANGE,	/* VF add/remove vlan-ids range */
+	IFLA_VF_VLAN_TRUNK,	/* VF allowed vlan-ids trunk */
 	__IFLA_VF_MAX,
 };
=20
@@ -747,6 +749,23 @@ struct ifla_vf_vlan_info {
 	__be16 vlan_proto; /* VLAN protocol either 802.1Q or 802.1ad */
 };
=20
+struct ifla_vf_vlan_range {
+	__u32 vf;
+	__u32 start_vid;   /* 0 - 4095, 0 - for untagged and priority tagged */
+	__u32 end_vid;     /* 0 - 4095, 0 - for untagged and priority tagged */
+	__u32 setting;     /* 0 : Add range , 1 : Remove range */
+	__be16 vlan_proto; /* VLAN protocol either 802.1Q or 802.1ad */
+};
+
+#define BITS_PER_BYTE		8
+#define VLAN_N_VID		4096
+#define VF_VLAN_BITMAP		__KERNEL_DIV_ROUND_UP(VLAN_N_VID, sizeof(__u64) * =
BITS_PER_BYTE)
+struct ifla_vf_vlan_trunk {
+	__u32 vf;
+	__u64 trunk_vid_8021q_bitmap[VF_VLAN_BITMAP];
+	__u64 trunk_vid_8021ad_bitmap[VF_VLAN_BITMAP];
+};
+
 struct ifla_vf_tx_rate {
 	__u32 vf;
 	__u32 rate; /* Max TX bandwidth in Mbps, 0 disables throttling */
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 9c04cee..961d2dc 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -350,6 +350,7 @@ static void print_af_spec(FILE *fp, struct rtattr *af_s=
pec_attr)
 }
=20
 static void print_vf_stats64(FILE *fp, struct rtattr *vfstats);
+static void print_vf_vlan_trunk(FILE *fp, __u64 *bitmap, const char *proto=
);
=20
 static const char *vlan_modes[] =3D {
 	[IFLA_VF_VLAN_MODE_UNSPEC] =3D "n/a",
@@ -545,6 +546,18 @@ static void print_vfinfo(FILE *fp, struct ifinfomsg *i=
fi, struct rtattr *vfinfo)
=20
 	if (vf[IFLA_VF_STATS] && show_stats)
 		print_vf_stats64(fp, vf[IFLA_VF_STATS]);
+
+	/*
+	 * VF trunk query should always be the last if-condition because it adds
+	 * new lines to the end of the vf info output.
+	 */
+	if (vf[IFLA_VF_VLAN_TRUNK]) {
+		struct ifla_vf_vlan_trunk *vf_trunk =3D
+				RTA_DATA(vf[IFLA_VF_VLAN_TRUNK]);
+
+		print_vf_vlan_trunk(fp, vf_trunk->trunk_vid_8021q_bitmap, "802.1Q");
+		print_vf_vlan_trunk(fp, vf_trunk->trunk_vid_8021ad_bitmap, "802.1ad");
+	}
 }
=20
 void print_num(FILE *fp, unsigned int width, uint64_t count)
@@ -587,6 +600,45 @@ void print_num(FILE *fp, unsigned int width, uint64_t =
count)
 	fprintf(fp, "%-*s ", width, buf);
 }
=20
+static void print_vf_vlan_trunk(FILE *fp, __u64 *bitmap, const char *proto=
)
+{
+#define VF_VLAN_TRUNK_LINE_SZ	100
+	int vids_per_dword =3D sizeof(bitmap[0]) * 8;
+	char trunk_line[2 * VF_VLAN_TRUNK_LINE_SZ] =3D {0};
+	bool printed_title =3D false;
+	bool need_newline =3D false;
+	int vid;
+
+	for (vid =3D 0; vid < VLAN_N_VID ; vid++) {
+		if ((bitmap[vid / vids_per_dword] >> (vid % vids_per_dword)) & 0x1) {
+			if (strlen(trunk_line) >=3D VF_VLAN_TRUNK_LINE_SZ)
+				need_newline =3D true;
+
+			if (!printed_title) {
+				sprintf(trunk_line,
+					"\n    Allowed %s VLANs: ", proto);
+				printed_title =3D true;
+			}
+
+			if (need_newline) {
+				fprintf(fp, "%s", trunk_line);
+				trunk_line[0] =3D '\0';
+			}
+
+			sprintf(trunk_line, "%s%s%d, ", trunk_line,
+				(need_newline ? "\n    " : ""), vid);
+
+			need_newline =3D false;
+		}
+	}
+
+	if (strlen(trunk_line)) {
+		trunk_line[strlen(trunk_line) - 2] =3D '.';
+		trunk_line[strlen(trunk_line) - 1] =3D '\0';
+		fprintf(fp, "%s", trunk_line);
+	}
+}
+
 static void print_vf_stats64(FILE *fp, struct rtattr *vfstats)
 {
 	struct rtattr *vf[IFLA_VF_STATS_MAX + 1];
diff --git a/ip/iplink.c b/ip/iplink.c
index ef33232..31076fc 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -89,6 +89,7 @@ void iplink_usage(void)
 		"			[ alias NAME ]\n"
 		"			[ vf NUM [ mac LLADDR ]\n"
 		"				 [ vlan VLANID [ qos VLAN-QOS ] [ proto VLAN-PROTO ] ]\n"
+		"				 [ trunk { add | rem } START-VLANID [ END-VLANID ] [ proto VLAN-PRO=
TO ] ]\n"
 		"				 [ rate TXRATE ]\n"
 		"				 [ max_tx_rate TXRATE ]\n"
 		"				 [ min_tx_rate TXRATE ]\n"
@@ -429,6 +430,51 @@ static int iplink_parse_vf(int vf, int *argcp, char **=
*argvp,
 				}
 				addattr_nest_end(&req->n, vfvlanlist);
 			}
+		} else if (matches(*argv, "trunk") =3D=3D 0) {
+			struct ifla_vf_vlan_range ivvr;
+
+			ivvr.vf =3D vf;
+			ivvr.vlan_proto =3D htons(ETH_P_8021Q);
+			NEXT_ARG();
+			if (matches(*argv, "add") && matches(*argv, "rem"))
+				invarg("Invalid \"trunk\" operation\n", *argv);
+			ivvr.setting =3D !matches(*argv, "add");
+			NEXT_ARG();
+			if (get_unsigned(&ivvr.start_vid, *argv, 0))
+				invarg("Invalid \"trunk\" start value\n", *argv);
+			ivvr.end_vid =3D ivvr.start_vid;
+			if (NEXT_ARG_OK()) {
+				NEXT_ARG();
+				if (get_unsigned(&ivvr.end_vid, *argv, 0))
+					PREV_ARG();
+			}
+			if (NEXT_ARG_OK()) {
+				NEXT_ARG();
+				if (matches(*argv, "proto") =3D=3D 0) {
+					NEXT_ARG();
+					if (ll_proto_a2n(&ivvr.vlan_proto, *argv))
+						invarg("protocol is invalid\n", *argv);
+					if (ivvr.vlan_proto !=3D htons(ETH_P_8021AD) &&
+					    ivvr.vlan_proto !=3D htons(ETH_P_8021Q)) {
+						SPRINT_BUF(b1);
+						SPRINT_BUF(b2);
+						char msg[64 + sizeof(b1) + sizeof(b2)];
+
+						sprintf(msg,
+							"Invalid \"vlan protocol\" value - supported %s, %s\n",
+							ll_proto_n2a(htons(ETH_P_8021Q),
+								     b1, sizeof(b1)),
+							ll_proto_n2a(htons(ETH_P_8021AD),
+								     b2, sizeof(b2)));
+						invarg(msg, *argv);
+					}
+				} else {
+					/* rewind arg */
+					PREV_ARG();
+				}
+			}
+			addattr_l(&req->n, sizeof(*req),
+				  IFLA_VF_VLAN_RANGE, &ivvr, sizeof(ivvr));
 		} else if (matches(*argv, "rate") =3D=3D 0) {
 			struct ifla_vf_tx_rate ivt;
=20
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 29744d4..23f6235 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -128,7 +128,12 @@ ip-link \- network device configuration
 .br
 .RB "[ " node_guid " eui64 ]"
 .br
-.RB "[ " port_guid " eui64 ] ]"
+.RB "[ " port_guid " eui64 ]"
+.br
+.RB "[ " trunk " { " add " | " rem " } "
+.IR START-VLAN-ID " [ " END-VLAN-ID " ] "
+.RB "[ " proto
+.IR VLAN-PROTO " ] ] ] "
 .br
 .in -9
 .RB "[ { " xdp " | " xdpgeneric  " | " xdpdrv " | " xdpoffload " } { " off=
 " | "
@@ -2043,6 +2048,16 @@ performance. (e.g. VF multicast promiscuous mode)
 .sp
 .BI port_guid " eui64"
 - configure port GUID for Infiniband VFs.
+.sp
+.BI trunk " add|rem START-VLANID [END-VLANID] [proto VLAN-PROTO] "
+- add or remove allowed vlan-ids range that can be used by the VF. Range 0=
-4095
+while 0 is used for untagged and priority tagged traffic.
+.B vf
+parameter must be specified.
+.B END-VLANID
+parameter is optional. If omitted, assumes range of one vlan-id.
+.B proto
+parameter is optional, either 802.1Q or 802.1ad. If omitted, assumes 802.1=
Q.
 .in -8
=20
 .TP
--=20
1.8.3.1

