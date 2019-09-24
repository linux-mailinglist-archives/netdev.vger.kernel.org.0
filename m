Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E54EBBC513
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 11:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504358AbfIXJmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 05:42:17 -0400
Received: from mail-eopbgr50054.outbound.protection.outlook.com ([40.107.5.54]:10630
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2504288AbfIXJmP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Sep 2019 05:42:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lX8pv77mg18PWhFYCynnDe628XNwAyZv3PKuNLlzYsfnYH2/JibTCV06cDquWCxz2IjPJzfjdBq9wNGcnQ7nfF/fwn0MA5cR3ednD5aOpXVixArvq3fQRLaosllc7N/yqOZFZ1e31d+Ctv5rhWSi9s3SBbNbxRgkBJBI290UoK09GqdXwsLtQlH27ovyZHaAh0ARavc5gfXpuiTsGYZnhi4ViKSkZGQ2iSpip7NQQCuy4YY9U/hMyWotfXoFeWSXjOlF/7fwXX1YEvzfCgnsfuwaAoH0YI0k1Hho67qVmVFTNdcvJXVMon8WaySxeoOdXm3vHvuDzm43rSd1ouCzkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jZyTeu9X+9Kx4Ztliw2NMvgbjaNG635ARmfMsTJRDA=;
 b=amCuYCJkOqwvILqJ8ywv6mmdxyW8aA1Aq0Ifl7JvuORmxM26hLlzUnDSkjDKw8NPixKpvfJBhANBq5VK31LSMZVaWHhAyZ4fpFhEcDzF4OLghExmV5PpoVPehkr+ody0wH+efw6QCVF1cP4ADUjG0X180ME7lUXB4PCPHxlYn4te4MTEP2x9ar5hh6w0vCfoqdLqVc1gD1Tuab3fAxoqzQPj+9wDffnZvZA5KRsgYfxGedrcPez298NqRzJ1qukYPHuD6zfklnhjZxhqS/wy2kFPXHntImogtHWll6hB73hdcFG/AMnmIRMbmyZ5dEkSnqYynvliqBwaY91PFimLoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jZyTeu9X+9Kx4Ztliw2NMvgbjaNG635ARmfMsTJRDA=;
 b=ZMpnLe89IsEy0u9NycVDVUz97sFlNllvwgF/lVu1hsgy3MJyqOK8izzMJzOsYvN1kQ9cWXZ2N8CGU4Wo7/lTAEduDBZGj69UTGLpeAH7Bh1jJXlgieu+J7al8OGu7zyZ8iHRLoCTa819GIeVombpM9g4098Xk/mtz/nbVxnYIzw=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2671.eurprd05.prod.outlook.com (10.172.14.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.21; Tue, 24 Sep 2019 09:41:46 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2284.023; Tue, 24 Sep 2019
 09:41:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmytro Linkin <dmitrolin@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 7/7] net/mlx5e: Fix matching on tunnel addresses type
Thread-Topic: [net 7/7] net/mlx5e: Fix matching on tunnel addresses type
Thread-Index: AQHVcrxHwZrJ5hWUZ0O5oqCBSJdcKA==
Date:   Tue, 24 Sep 2019 09:41:46 +0000
Message-ID: <20190924094047.15915-8-saeedm@mellanox.com>
References: <20190924094047.15915-1-saeedm@mellanox.com>
In-Reply-To: <20190924094047.15915-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [193.47.165.251]
x-clientproxiedby: BYAPR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::44) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 998663c7-02fb-4605-6a01-08d740d369fb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0501MB2671;
x-ms-traffictypediagnostic: VI1PR0501MB2671:|VI1PR0501MB2671:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB2671BFB8B7D523A421DA774BBE840@VI1PR0501MB2671.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0170DAF08C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(189003)(199004)(386003)(256004)(6512007)(186003)(6116002)(3846002)(50226002)(99286004)(36756003)(25786009)(107886003)(486006)(6436002)(102836004)(52116002)(26005)(76176011)(8676002)(4326008)(316002)(81156014)(81166006)(2616005)(54906003)(476003)(11346002)(6916009)(6506007)(86362001)(1076003)(5660300002)(66476007)(2906002)(66556008)(6486002)(66446008)(64756008)(66946007)(14454004)(478600001)(305945005)(7736002)(66066001)(71190400001)(446003)(71200400001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2671;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +NVObICHOoO3P2UK1XRoDaiC+CYRGKYS3WyYiv/Jg1awy/6crQwIH7xkIoO1hFGocwZtJGy+ebRBBQyvBJZpB6NfcAfIpe/vBmvJw8acxJg2K07UY0CEoRkSIAW6XbgZ8XPGZaLtpCMhbViUsfLshcx13snOxVImZlssRuumGmoGFUcwDi4FPqodE8InNrblNSx7PYtxfol7oHQSrlnTbZJMx+BCAZ51lSLEoRhOMbGBc75TyN0am3EgcCodaQvomYhkiknZffaRiaUGLL/8UWjpxqz/U2rmhP0ruvkZQekJU5i7eQjgefSOdxPJrtWO85f5HzNV5QQ0BbLmRjlnhuRZ/3s3sF7c7r9oKs2bsN073zYlh7xYh1oQI46NWdu07XUFHJP3s8Qrc7f2MucjKMkWsUPNZ/P58FVX+K0YbxQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 998663c7-02fb-4605-6a01-08d740d369fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2019 09:41:46.1243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tjUB/jxIH75Wzk4iTK/8fz8epnmJYxPI9zMJ7GbBmSQzr3ON22j/nOXdz0eBa1Fp9TSN7EZ/D5jTaB6y2iNQzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2671
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

In mlx5 parse_tunnel_attr() function dispatch on encap IP address type
is performed by directly checking flow_rule_match_key() on
FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS, and then on
FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS. However, since those are stored in
union, first check is always true if any type of encap address is set,
which leads to IPv6 tunnel encap address being parsed as IPv4 by mlx5.
Determine correct IP address type by checking control key first and if
it set, take address type from match.key->addr_type.

Fixes: d1bda7eecd88 ("net/mlx5e: Allow matching only enc_key_id/enc_dst_por=
t for decapsulation action")
Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 89 +++++++++++--------
 1 file changed, 53 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index da7555fdb4d5..3e78a727f3e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1664,46 +1664,63 @@ static int parse_tunnel_attr(struct mlx5e_priv *pri=
v,
 		return err;
 	}
=20
-	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV4_ADDRS)) {
-		struct flow_match_ipv4_addrs match;
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_CONTROL)) {
+		struct flow_match_control match;
+		u16 addr_type;
=20
-		flow_rule_match_enc_ipv4_addrs(rule, &match);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c,
-			 src_ipv4_src_ipv6.ipv4_layout.ipv4,
-			 ntohl(match.mask->src));
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v,
-			 src_ipv4_src_ipv6.ipv4_layout.ipv4,
-			 ntohl(match.key->src));
-
-		MLX5_SET(fte_match_set_lyr_2_4, headers_c,
-			 dst_ipv4_dst_ipv6.ipv4_layout.ipv4,
-			 ntohl(match.mask->dst));
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v,
-			 dst_ipv4_dst_ipv6.ipv4_layout.ipv4,
-			 ntohl(match.key->dst));
-
-		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, ethertype);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype, ETH_P_IP);
-	} else if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IPV6_ADDRS)) =
{
-		struct flow_match_ipv6_addrs match;
+		flow_rule_match_enc_control(rule, &match);
+		addr_type =3D match.key->addr_type;
=20
-		flow_rule_match_enc_ipv6_addrs(rule, &match);
-		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
-				    src_ipv4_src_ipv6.ipv6_layout.ipv6),
-		       &match.mask->src, MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6));
-		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
-				    src_ipv4_src_ipv6.ipv6_layout.ipv6),
-		       &match.key->src, MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6));
+		/* For tunnel addr_type used same key id`s as for non-tunnel */
+		if (addr_type =3D=3D FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+			struct flow_match_ipv4_addrs match;
=20
-		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
-				    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
-		       &match.mask->dst, MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6));
-		memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
-				    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
-		       &match.key->dst, MLX5_FLD_SZ_BYTES(ipv6_layout, ipv6));
+			flow_rule_match_enc_ipv4_addrs(rule, &match);
+			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
+				 src_ipv4_src_ipv6.ipv4_layout.ipv4,
+				 ntohl(match.mask->src));
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
+				 src_ipv4_src_ipv6.ipv4_layout.ipv4,
+				 ntohl(match.key->src));
=20
-		MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c, ethertype);
-		MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype, ETH_P_IPV6);
+			MLX5_SET(fte_match_set_lyr_2_4, headers_c,
+				 dst_ipv4_dst_ipv6.ipv4_layout.ipv4,
+				 ntohl(match.mask->dst));
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v,
+				 dst_ipv4_dst_ipv6.ipv4_layout.ipv4,
+				 ntohl(match.key->dst));
+
+			MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c,
+					 ethertype);
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype,
+				 ETH_P_IP);
+		} else if (addr_type =3D=3D FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
+			struct flow_match_ipv6_addrs match;
+
+			flow_rule_match_enc_ipv6_addrs(rule, &match);
+			memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
+					    src_ipv4_src_ipv6.ipv6_layout.ipv6),
+			       &match.mask->src, MLX5_FLD_SZ_BYTES(ipv6_layout,
+								   ipv6));
+			memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
+					    src_ipv4_src_ipv6.ipv6_layout.ipv6),
+			       &match.key->src, MLX5_FLD_SZ_BYTES(ipv6_layout,
+								  ipv6));
+
+			memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_c,
+					    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
+			       &match.mask->dst, MLX5_FLD_SZ_BYTES(ipv6_layout,
+								   ipv6));
+			memcpy(MLX5_ADDR_OF(fte_match_set_lyr_2_4, headers_v,
+					    dst_ipv4_dst_ipv6.ipv6_layout.ipv6),
+			       &match.key->dst, MLX5_FLD_SZ_BYTES(ipv6_layout,
+								  ipv6));
+
+			MLX5_SET_TO_ONES(fte_match_set_lyr_2_4, headers_c,
+					 ethertype);
+			MLX5_SET(fte_match_set_lyr_2_4, headers_v, ethertype,
+				 ETH_P_IPV6);
+		}
 	}
=20
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_ENC_IP)) {
--=20
2.21.0

