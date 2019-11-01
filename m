Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64522ECA9F
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 22:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727643AbfKAV71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 17:59:27 -0400
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:20086
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727316AbfKAV70 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 17:59:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KMiv9Bpc9PFL8vvEufAqQxCghBqYfraj6Yb3Qf0WgVpaCaxKmWHGEOLbyMWcN97p51wVpmuDZSQjntdxqzBFqocTBoD8BZjNLh+ZqLhstv1gP/iC1xHjbKfkNc8YlgIjSwwJJOYj2wlW0sdZG9ktsEg+PF/7veTJ+LMe6zYwHy9GfWQCpPoticB+gZ+LYsAtswAIydPpDUSsL0Nk1UWOnsivsBqjPQHVbLCrFveZ+HOsz533YZ2SZvi5bOb2edv0LauPWyfuzNonBSj25ILLyXGYKEdGD0I9/lRNzYjCEOtT+JOnYuyWm1H1VTlw88dzKMjrU9P7IiMdIZSQ8TOooA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZSDdDazULcwTk6gxzYCoRbdLBgjnNHqXgYl7afZgOnU=;
 b=XQlnsI/K/9XZL3O9qWsO52SIKBXCxiAvj1ktUfnnQAp0z8c0fQ1bpUiDR/sMA5VABGrtPSkL5WdF6wcyTSd+4pzNFR+7OESwVxEUXFd1JQDdZJ8HzOnUmwx05q60aPHBKUDLje2bIugLCgTGcCWRLtTNs3uwz2u6sguAfIfbLq8GbCoIfmFIItv6R6lRwJ4YGkZmf3u3Mqy+7UQAfSPSopxdTg99/GuyRWOoPv2vaBwHaAheAAaWc8kb2GcpsArTiYWIkSYccWq4fMBSOAkJUD0uhWzfbH/hmiTpXO6xcEXmaN96GZYBCgLzvK1FCD0yKPN6WvA1oV1bRilfn+oZMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZSDdDazULcwTk6gxzYCoRbdLBgjnNHqXgYl7afZgOnU=;
 b=dR5NKkm/bMc1fFtN14AQhNq02EeUTuGVAtnlCCo0m7mBc7Igf1pLHpnc8CWwF40kbqipfFBAUN9G5fWVp7KK8sUTcfCBNm3zBKTy2Flr013LONsekM1hzSx/HlnKBkI4ndxW4hO7MR3P28gd64XWuCadMOPvW9ucCij6TYbFrkE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5679.eurprd05.prod.outlook.com (20.178.121.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 21:59:15 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 21:59:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmytro Linkin <dmitrolin@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/15] net/mlx5e: Bit sized fields rewrite support
Thread-Topic: [net-next 10/15] net/mlx5e: Bit sized fields rewrite support
Thread-Index: AQHVkP+ZVSVq6uISwkSuYvFE4xi0hA==
Date:   Fri, 1 Nov 2019 21:59:15 +0000
Message-ID: <20191101215833.23975-11-saeedm@mellanox.com>
References: <20191101215833.23975-1-saeedm@mellanox.com>
In-Reply-To: <20191101215833.23975-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0076.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e3750006-6fcd-4528-3e2f-08d75f16bc54
x-ms-traffictypediagnostic: VI1PR05MB5679:|VI1PR05MB5679:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5679A01E50D7DC42A9DB2B49BE620@VI1PR05MB5679.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:131;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(189003)(199004)(4326008)(99286004)(316002)(2616005)(2906002)(6116002)(476003)(6512007)(3846002)(1076003)(36756003)(66946007)(14454004)(25786009)(54906003)(66066001)(66556008)(64756008)(486006)(11346002)(446003)(81156014)(6916009)(76176011)(305945005)(7736002)(26005)(66476007)(66446008)(86362001)(5660300002)(102836004)(386003)(6506007)(50226002)(6486002)(6436002)(81166006)(71190400001)(71200400001)(478600001)(8676002)(256004)(8936002)(14444005)(107886003)(52116002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5679;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xl6Y3afsSYwUd/8C5P7SQLfZrdGrosQGu+BCjSNu6YRGj0jBBZSnnwH/LIcHFTsWLbkc4bxiT8Y/pO09WYwzHAeHqSNUbOh6LWdHYspiJ4A7KN8ZgnK8vLn2Qu8LACRbEZg6JEp+PoxyUcgzXdajZV9me02Q6kt5UyDtUn+T4wHc2A4LaePXVsHgSuclOD+5DIAM1EH4nqUmYf45pFPYjrJZO5jlUKStsOfkx22s+Tj5emfhHzxJOlM8fun/lhkeaSuxLJVpvQQmwTm2mlUrIN++ALZLfvBcW27SF+WyT2RbZ1mYu5mRZTz/3hzew49BrTdJ3AIVHmdv6CfalAagYPfvEEJbYZDkLCUnCXDVogF8guagpvaH8/SALCAd0je7KVI6VeB12T6B0kqdd3PykVKa8/tayEejDxfPVFerRTrUQZk0mmxllxwT48XmJj4p
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3750006-6fcd-4528-3e2f-08d75f16bc54
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 21:59:15.2040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nzQPCKzrTt4Ut4QP+r6m0nhJpERdGoo6xf+a93vYDNjKfleS31VeagUV3F6yK73yV6F7P+/VaeOiYUMoMGOvKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5679
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

This patch doesn't change any functionality, but is a pre-step for
adding support for rewriting of bit-sized fields, like DSCP and ECN
in IPv4 header, similar fields in IPv6, etc.

Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 122 +++++++++---------
 1 file changed, 62 insertions(+), 60 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 8c4bce940bfb..67b73a00f8fa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2238,13 +2238,14 @@ static int set_pedit_val(u8 hdr_type, u32 mask, u32=
 val, u32 offset,
=20
 struct mlx5_fields {
 	u8  field;
-	u8  size;
+	u8  field_bsize;
+	u32 field_mask;
 	u32 offset;
 	u32 match_offset;
 };
=20
-#define OFFLOAD(fw_field, size, field, off, match_field) \
-		{MLX5_ACTION_IN_FIELD_OUT_ ## fw_field, size, \
+#define OFFLOAD(fw_field, field_bsize, field_mask, field, off, match_field=
) \
+		{MLX5_ACTION_IN_FIELD_OUT_ ## fw_field, field_bsize, field_mask, \
 		 offsetof(struct pedit_headers, field) + (off), \
 		 MLX5_BYTE_OFF(fte_match_set_lyr_2_4, match_field)}
=20
@@ -2262,18 +2263,18 @@ struct mlx5_fields {
 })
=20
 static bool cmp_val_mask(void *valp, void *maskp, void *matchvalp,
-			 void *matchmaskp, int size)
+			 void *matchmaskp, u8 bsize)
 {
 	bool same =3D false;
=20
-	switch (size) {
-	case sizeof(u8):
+	switch (bsize) {
+	case 8:
 		same =3D SAME_VAL_MASK(u8, valp, maskp, matchvalp, matchmaskp);
 		break;
-	case sizeof(u16):
+	case 16:
 		same =3D SAME_VAL_MASK(u16, valp, maskp, matchvalp, matchmaskp);
 		break;
-	case sizeof(u32):
+	case 32:
 		same =3D SAME_VAL_MASK(u32, valp, maskp, matchvalp, matchmaskp);
 		break;
 	}
@@ -2282,41 +2283,42 @@ static bool cmp_val_mask(void *valp, void *maskp, v=
oid *matchvalp,
 }
=20
 static struct mlx5_fields fields[] =3D {
-	OFFLOAD(DMAC_47_16, 4, eth.h_dest[0], 0, dmac_47_16),
-	OFFLOAD(DMAC_15_0,  2, eth.h_dest[4], 0, dmac_15_0),
-	OFFLOAD(SMAC_47_16, 4, eth.h_source[0], 0, smac_47_16),
-	OFFLOAD(SMAC_15_0,  2, eth.h_source[4], 0, smac_15_0),
-	OFFLOAD(ETHERTYPE,  2, eth.h_proto, 0, ethertype),
-	OFFLOAD(FIRST_VID,  2, vlan.h_vlan_TCI, 0, first_vid),
-
-	OFFLOAD(IP_TTL, 1, ip4.ttl,   0, ttl_hoplimit),
-	OFFLOAD(SIPV4,  4, ip4.saddr, 0, src_ipv4_src_ipv6.ipv4_layout.ipv4),
-	OFFLOAD(DIPV4,  4, ip4.daddr, 0, dst_ipv4_dst_ipv6.ipv4_layout.ipv4),
-
-	OFFLOAD(SIPV6_127_96, 4, ip6.saddr.s6_addr32[0], 0,
+	OFFLOAD(DMAC_47_16, 32, U32_MAX, eth.h_dest[0], 0, dmac_47_16),
+	OFFLOAD(DMAC_15_0,  16, U16_MAX, eth.h_dest[4], 0, dmac_15_0),
+	OFFLOAD(SMAC_47_16, 32, U32_MAX, eth.h_source[0], 0, smac_47_16),
+	OFFLOAD(SMAC_15_0,  16, U16_MAX, eth.h_source[4], 0, smac_15_0),
+	OFFLOAD(ETHERTYPE,  16, U16_MAX, eth.h_proto, 0, ethertype),
+	OFFLOAD(FIRST_VID,  16, U16_MAX, vlan.h_vlan_TCI, 0, first_vid),
+
+	OFFLOAD(IP_TTL,  8,  U8_MAX, ip4.ttl,   0, ttl_hoplimit),
+	OFFLOAD(SIPV4,  32, U32_MAX, ip4.saddr, 0, src_ipv4_src_ipv6.ipv4_layout.=
ipv4),
+	OFFLOAD(DIPV4,  32, U32_MAX, ip4.daddr, 0, dst_ipv4_dst_ipv6.ipv4_layout.=
ipv4),
+
+	OFFLOAD(SIPV6_127_96, 32, U32_MAX, ip6.saddr.s6_addr32[0], 0,
 		src_ipv4_src_ipv6.ipv6_layout.ipv6[0]),
-	OFFLOAD(SIPV6_95_64,  4, ip6.saddr.s6_addr32[1], 0,
+	OFFLOAD(SIPV6_95_64,  32, U32_MAX, ip6.saddr.s6_addr32[1], 0,
 		src_ipv4_src_ipv6.ipv6_layout.ipv6[4]),
-	OFFLOAD(SIPV6_63_32,  4, ip6.saddr.s6_addr32[2], 0,
+	OFFLOAD(SIPV6_63_32,  32, U32_MAX, ip6.saddr.s6_addr32[2], 0,
 		src_ipv4_src_ipv6.ipv6_layout.ipv6[8]),
-	OFFLOAD(SIPV6_31_0,   4, ip6.saddr.s6_addr32[3], 0,
+	OFFLOAD(SIPV6_31_0,   32, U32_MAX, ip6.saddr.s6_addr32[3], 0,
 		src_ipv4_src_ipv6.ipv6_layout.ipv6[12]),
-	OFFLOAD(DIPV6_127_96, 4, ip6.daddr.s6_addr32[0], 0,
+	OFFLOAD(DIPV6_127_96, 32, U32_MAX, ip6.daddr.s6_addr32[0], 0,
 		dst_ipv4_dst_ipv6.ipv6_layout.ipv6[0]),
-	OFFLOAD(DIPV6_95_64,  4, ip6.daddr.s6_addr32[1], 0,
+	OFFLOAD(DIPV6_95_64,  32, U32_MAX, ip6.daddr.s6_addr32[1], 0,
 		dst_ipv4_dst_ipv6.ipv6_layout.ipv6[4]),
-	OFFLOAD(DIPV6_63_32,  4, ip6.daddr.s6_addr32[2], 0,
+	OFFLOAD(DIPV6_63_32,  32, U32_MAX, ip6.daddr.s6_addr32[2], 0,
 		dst_ipv4_dst_ipv6.ipv6_layout.ipv6[8]),
-	OFFLOAD(DIPV6_31_0,   4, ip6.daddr.s6_addr32[3], 0,
+	OFFLOAD(DIPV6_31_0,   32, U32_MAX, ip6.daddr.s6_addr32[3], 0,
 		dst_ipv4_dst_ipv6.ipv6_layout.ipv6[12]),
-	OFFLOAD(IPV6_HOPLIMIT, 1, ip6.hop_limit, 0, ttl_hoplimit),
+	OFFLOAD(IPV6_HOPLIMIT, 8,  U8_MAX, ip6.hop_limit, 0, ttl_hoplimit),
=20
-	OFFLOAD(TCP_SPORT, 2, tcp.source,  0, tcp_sport),
-	OFFLOAD(TCP_DPORT, 2, tcp.dest,    0, tcp_dport),
-	OFFLOAD(TCP_FLAGS, 1, tcp.ack_seq, 5, tcp_flags),
+	OFFLOAD(TCP_SPORT, 16, U16_MAX, tcp.source,  0, tcp_sport),
+	OFFLOAD(TCP_DPORT, 16, U16_MAX, tcp.dest,    0, tcp_dport),
+	/* in linux iphdr tcp_flags is 8 bits long */
+	OFFLOAD(TCP_FLAGS,  8,  U8_MAX, tcp.ack_seq, 5, tcp_flags),
=20
-	OFFLOAD(UDP_SPORT, 2, udp.source, 0, udp_sport),
-	OFFLOAD(UDP_DPORT, 2, udp.dest,   0, udp_dport),
+	OFFLOAD(UDP_SPORT, 16, U16_MAX, udp.source, 0, udp_sport),
+	OFFLOAD(UDP_DPORT, 16, U16_MAX, udp.dest,   0, udp_dport),
 };
=20
 /* On input attr->max_mod_hdr_actions tells how many HW actions can be par=
sed at
@@ -2329,19 +2331,17 @@ static int offload_pedit_fields(struct pedit_header=
s_action *hdrs,
 				struct netlink_ext_ack *extack)
 {
 	struct pedit_headers *set_masks, *add_masks, *set_vals, *add_vals;
-	void *headers_c =3D get_match_headers_criteria(*action_flags,
-						     &parse_attr->spec);
-	void *headers_v =3D get_match_headers_value(*action_flags,
-						  &parse_attr->spec);
 	int i, action_size, nactions, max_actions, first, last, next_z;
-	void *s_masks_p, *a_masks_p, *vals_p;
+	void *headers_c, *headers_v, *action, *vals_p;
+	u32 *s_masks_p, *a_masks_p, s_mask, a_mask;
 	struct mlx5_fields *f;
-	u8 cmd, field_bsize;
-	u32 s_mask, a_mask;
 	unsigned long mask;
 	__be32 mask_be32;
 	__be16 mask_be16;
-	void *action;
+	u8 cmd;
+
+	headers_c =3D get_match_headers_criteria(*action_flags, &parse_attr->spec=
);
+	headers_v =3D get_match_headers_value(*action_flags, &parse_attr->spec);
=20
 	set_masks =3D &hdrs[0].masks;
 	add_masks =3D &hdrs[1].masks;
@@ -2366,8 +2366,8 @@ static int offload_pedit_fields(struct pedit_headers_=
action *hdrs,
 		s_masks_p =3D (void *)set_masks + f->offset;
 		a_masks_p =3D (void *)add_masks + f->offset;
=20
-		memcpy(&s_mask, s_masks_p, f->size);
-		memcpy(&a_mask, a_masks_p, f->size);
+		s_mask =3D *s_masks_p & f->field_mask;
+		a_mask =3D *a_masks_p & f->field_mask;
=20
 		if (!s_mask && !a_mask) /* nothing to offload here */
 			continue;
@@ -2396,38 +2396,34 @@ static int offload_pedit_fields(struct pedit_header=
s_action *hdrs,
 			vals_p =3D (void *)set_vals + f->offset;
 			/* don't rewrite if we have a match on the same value */
 			if (cmp_val_mask(vals_p, s_masks_p, match_val,
-					 match_mask, f->size))
+					 match_mask, f->field_bsize))
 				skip =3D true;
 			/* clear to denote we consumed this field */
-			memset(s_masks_p, 0, f->size);
+			*s_masks_p &=3D ~f->field_mask;
 		} else {
-			u32 zero =3D 0;
-
 			cmd  =3D MLX5_ACTION_TYPE_ADD;
 			mask =3D a_mask;
 			vals_p =3D (void *)add_vals + f->offset;
 			/* add 0 is no change */
-			if (!memcmp(vals_p, &zero, f->size))
+			if ((*(u32 *)vals_p & f->field_mask) =3D=3D 0)
 				skip =3D true;
 			/* clear to denote we consumed this field */
-			memset(a_masks_p, 0, f->size);
+			*a_masks_p &=3D ~f->field_mask;
 		}
 		if (skip)
 			continue;
=20
-		field_bsize =3D f->size * BITS_PER_BYTE;
-
-		if (field_bsize =3D=3D 32) {
+		if (f->field_bsize =3D=3D 32) {
 			mask_be32 =3D *(__be32 *)&mask;
 			mask =3D (__force unsigned long)cpu_to_le32(be32_to_cpu(mask_be32));
-		} else if (field_bsize =3D=3D 16) {
+		} else if (f->field_bsize =3D=3D 16) {
 			mask_be16 =3D *(__be16 *)&mask;
 			mask =3D (__force unsigned long)cpu_to_le16(be16_to_cpu(mask_be16));
 		}
=20
-		first =3D find_first_bit(&mask, field_bsize);
-		next_z =3D find_next_zero_bit(&mask, field_bsize, first);
-		last  =3D find_last_bit(&mask, field_bsize);
+		first =3D find_first_bit(&mask, f->field_bsize);
+		next_z =3D find_next_zero_bit(&mask, f->field_bsize, first);
+		last  =3D find_last_bit(&mask, f->field_bsize);
 		if (first < next_z && next_z < last) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "rewrite of few sub-fields isn't supported");
@@ -2440,16 +2436,22 @@ static int offload_pedit_fields(struct pedit_header=
s_action *hdrs,
 		MLX5_SET(set_action_in, action, field, f->field);
=20
 		if (cmd =3D=3D MLX5_ACTION_TYPE_SET) {
-			MLX5_SET(set_action_in, action, offset, first);
+			int start;
+
+			/* if field is bit sized it can start not from first bit */
+			start =3D find_first_bit((unsigned long *)&f->field_mask,
+					       f->field_bsize);
+
+			MLX5_SET(set_action_in, action, offset, first - start);
 			/* length is num of bits to be written, zero means length of 32 */
 			MLX5_SET(set_action_in, action, length, (last - first + 1));
 		}
=20
-		if (field_bsize =3D=3D 32)
+		if (f->field_bsize =3D=3D 32)
 			MLX5_SET(set_action_in, action, data, ntohl(*(__be32 *)vals_p) >> first=
);
-		else if (field_bsize =3D=3D 16)
+		else if (f->field_bsize =3D=3D 16)
 			MLX5_SET(set_action_in, action, data, ntohs(*(__be16 *)vals_p) >> first=
);
-		else if (field_bsize =3D=3D 8)
+		else if (f->field_bsize =3D=3D 8)
 			MLX5_SET(set_action_in, action, data, *(u8 *)vals_p >> first);
=20
 		action +=3D action_size;
--=20
2.21.0

