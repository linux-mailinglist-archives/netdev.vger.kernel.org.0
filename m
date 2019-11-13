Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1619EFBBC6
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 23:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfKMWlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 17:41:42 -0500
Received: from mail-eopbgr150048.outbound.protection.outlook.com ([40.107.15.48]:22577
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726251AbfKMWll (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 17:41:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IkLbjymsix77tyJpzNUl00WCp99mercSNks9UztbSdJ+suAVNJo48FtD0TwIl4r4RL2JZnxZzWmq9wL/sb1tpBqE8bSvzOfnFVmIlI9omivOuOxWy9sWamhz3XcjQJ6KQaTIi47zjVdyUONB1Mv8gGho74wJ1Jri2qgO8fMZzT++a5m3OZPKMo4eawok2mNEwDhKwmS0n77YivwHLElWOcSGQHD0p8NgFODi79mAkPw8z8fteoxRg54vr2c59CbJKmIgnbPcbHB7SSAAZvslOYr0LFE85akZUPPMEn0aRiUskRUu91oqpytuDgC9W+8NsxxuE742RhErdgNBBb3/3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxpWWJqx8SGzPA72QSju271vqByq6OPFcGGbA+i1laM=;
 b=f0apt3EtiRtEtVBc5ILRKBpOQ8OamL+lIz0/gOj2PNQHwowda1ugFzsf9Ln31gm9ROdq/flkvQ6fHIHTdmQLIwTf2luutNGHDDdqRllY07jhed6CeyR1ZsnIDYQ29MJmm+XEWxsQL+tkBD8pt1jnKMfHL2zLUIY+p3XHYSGkpdk/LyrbsKvUxMoTMafHTAveUuVaoHjmwzxI6+hwK+PrpMrJaC7Xkq228/v/nD2OwXjsWn/bE+t64k9FJMhb68aiBndPRfQXes04Osu2Kj7hOmKsAUm3PQZ33a49cCXjQbASYPnbEnSQr5HWHN4lzcI9goNdMbVlrSw/rvJgclk0NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxpWWJqx8SGzPA72QSju271vqByq6OPFcGGbA+i1laM=;
 b=bC/GOygYCc9Xlp/eYDIQn1/S9ZoW+M/9PVp033JgDKkNKT6lm9VhWCFS4v8Zq9xF61ycI2fDSx5LKR/+FTooL/8nFlIjW7vizjk6DF9PUocelTfBeR751Kmw2tcRUUjwqsIpul95BAi0Aj+Ra7+pigpxJJOuVTW7LaldzZZD9w8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5135.eurprd05.prod.outlook.com (20.178.11.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 13 Nov 2019 22:41:36 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.028; Wed, 13 Nov 2019
 22:41:36 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Eli Cohen <eli@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 3/7] net/mlx5: Remove redundant NULL initializations
Thread-Topic: [net-next V2 3/7] net/mlx5: Remove redundant NULL
 initializations
Thread-Index: AQHVmnOBnzTbuBKIakqqxCEZerIuPg==
Date:   Wed, 13 Nov 2019 22:41:36 +0000
Message-ID: <20191113224059.19051-4-saeedm@mellanox.com>
References: <20191113224059.19051-1-saeedm@mellanox.com>
In-Reply-To: <20191113224059.19051-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e7a3e4ae-3d13-408c-731a-08d7688aa3d2
x-ms-traffictypediagnostic: VI1PR05MB5135:|VI1PR05MB5135:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5135B7A26C30DD84E5538D5CBE760@VI1PR05MB5135.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:580;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(189003)(199004)(26005)(3846002)(6116002)(54906003)(66946007)(64756008)(66556008)(66476007)(2906002)(66446008)(36756003)(316002)(99286004)(81166006)(81156014)(8936002)(8676002)(50226002)(5660300002)(1076003)(102836004)(186003)(6512007)(6486002)(6436002)(386003)(478600001)(52116002)(25786009)(76176011)(7736002)(6506007)(14454004)(305945005)(86362001)(486006)(107886003)(256004)(4326008)(66066001)(2616005)(6916009)(11346002)(71200400001)(71190400001)(446003)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5135;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5ORqLH04C1ede2nbtRnEhRq2zDw+hbQDqTscxDl/M583Wz0/JytrDqBid3/vO+nTwdzWYF/aocT46zizhJ/acXJUvoSLTbCLi910sqexpuUh1ld8ke/rC2x5YHrvchlyvxYzYSmOfuG21Uv+xfHcztxy8JkSQCRm7H1TA/gJplwEQ0H8QXcqUkgPFYBf0F7hvdHaZyCRKSPH+yua4r+5+Ast+B73EA88v/ZeJnEB3Wb8j6vL7CIDcLZ1Ww3NRf+wHwv/lTYTEfslQAYp6af10DIZ7UBO2/FE48U8USJIcwG5BdT6xTxS/al0NdV0c9OVl9LCJ3dcs4Im89M5JGGFqFNeyTkX0RegabgfxUtz58fqLJUkrDG6rbaXhnC/Oqx/SN8xIotJserD397J0Mi4xdLE6N+ktaRfUmjUb6aSIOS172IZfATbF3xjh7A1I3Z3
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7a3e4ae-3d13-408c-731a-08d7688aa3d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 22:41:36.1387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YzNYGrj6t5NdJ6LiaW+srInLWcGZK3kt9VCAEGRzwZ2DIw8CpuiEoyndW1EBDTFkOufhxmIamYMbt0kFlXhWJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Neighbour initializations to NULL are not necessary as the pointers are
not used if an error is returned, and if success returned, pointers are
initialized.

Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 13af72556987..4f78efeb6ee8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -77,8 +77,8 @@ static int mlx5e_route_lookup_ipv4(struct mlx5e_priv *pri=
v,
 				   struct neighbour **out_n,
 				   u8 *out_ttl)
 {
+	struct neighbour *n;
 	struct rtable *rt;
-	struct neighbour *n =3D NULL;
=20
 #if IS_ENABLED(CONFIG_INET)
 	struct mlx5_core_dev *mdev =3D priv->mdev;
@@ -138,8 +138,8 @@ static int mlx5e_route_lookup_ipv6(struct mlx5e_priv *p=
riv,
 				   struct neighbour **out_n,
 				   u8 *out_ttl)
 {
-	struct neighbour *n =3D NULL;
 	struct dst_entry *dst;
+	struct neighbour *n;
=20
 #if IS_ENABLED(CONFIG_INET) && IS_ENABLED(CONFIG_IPV6)
 	int ret;
@@ -212,8 +212,8 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *=
priv,
 	int max_encap_size =3D MLX5_CAP_ESW(priv->mdev, max_encap_header_size);
 	const struct ip_tunnel_key *tun_key =3D &e->tun_info->key;
 	struct net_device *out_dev, *route_dev;
-	struct neighbour *n =3D NULL;
 	struct flowi4 fl4 =3D {};
+	struct neighbour *n;
 	int ipv4_encap_size;
 	char *encap_header;
 	u8 nud_state, ttl;
@@ -328,9 +328,9 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *=
priv,
 	int max_encap_size =3D MLX5_CAP_ESW(priv->mdev, max_encap_header_size);
 	const struct ip_tunnel_key *tun_key =3D &e->tun_info->key;
 	struct net_device *out_dev, *route_dev;
-	struct neighbour *n =3D NULL;
 	struct flowi6 fl6 =3D {};
 	struct ipv6hdr *ip6h;
+	struct neighbour *n;
 	int ipv6_encap_size;
 	char *encap_header;
 	u8 nud_state, ttl;
--=20
2.21.0

