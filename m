Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B26CF2161
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 23:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732711AbfKFWFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 17:05:50 -0500
Received: from mail-eopbgr70071.outbound.protection.outlook.com ([40.107.7.71]:20628
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732615AbfKFWFu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 17:05:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MFVroMCJAMtVERNqq7MuGpW7rZMhnvnLebZLDBFXpVzUTpLMifta6CU5zz5u7NTiBpjZvdC94HPiny+nF3k3RNdxUbV1gmJTmDiiJUFE8kErrLsqq39XrdrexBEcmmMtDsZlIycR7Qxhq/X4jpYCIlnWDd0OCztTMTIM9nWuhfFcxN7HgnsRJ4GJwJAwdhzBuqQbBVdAZnopPxseBvmbVJg+yZ+fosxEpnk5fdZBOagii4bmtUqtPHkWrqpq8qb3YpIix8SaJG1KMtOfSznH76OLVoXUBR6b17BBdK5h5ddya+x8+0ohysJ/DmkbtOcfnKCO6xUQLjl/lPnKTvyf/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQGF7XX0AVb8d8tvMrwIzEfQNUe46KszdIdewS6f0S4=;
 b=dItnmIqwof3zT5DEZBAC9exK5nNq8RWYouhqf1xFP6DhgfKSzG/BP91PaCv8RBvldOazDp9vsLDhhG0r+TaF5pXvEb1GBUaQWA5bERxvIA3ZWE0wUb4JRVRbwllZExDXRzHU65ZCfeRG3dKAh+vzU0fXvc8JRgpOBhYUF6J/DYq976uwA/17spNiJsS46orOSR/s2sQd5hFoUtbZWM/Lna3m0JKz9fHzRzMayL9MPl01HLI+g9VBu5AKDRh2mLt6XU9FNtU5UVDqChmqy1SlNfXFKYThYSmCtsUkNemmkQRGBXtIy64nTFR3CuOnyRUg++jbpjZq+H8u72VE+rxLQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bQGF7XX0AVb8d8tvMrwIzEfQNUe46KszdIdewS6f0S4=;
 b=SAJiIg+DXbkhOoUrARCrjO8B8o1mYml77MmQGrP4OBFM3WJmz+IVy/K3KWJHPy9+Cdsjc/MdSBfMnQS53mH1gPCgOTEHOQhYVSX1RkcmCC8h6hXihsYbWFUOmkbF0GMew08BRZaCW/w/s64a/39XcPmyMzyak77v8pJSzD8J8Gg=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5309.eurprd05.prod.outlook.com (20.178.12.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Wed, 6 Nov 2019 22:05:45 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Wed, 6 Nov 2019
 22:05:45 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmytro Linkin <dmitrolin@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 4/4] net/mlx5e: Use correct enum to determine uplink port
Thread-Topic: [net 4/4] net/mlx5e: Use correct enum to determine uplink port
Thread-Index: AQHVlO5WPeDRkQB53EOJMG1vSI+n2g==
Date:   Wed, 6 Nov 2019 22:05:45 +0000
Message-ID: <20191106220523.18855-5-saeedm@mellanox.com>
References: <20191106220523.18855-1-saeedm@mellanox.com>
In-Reply-To: <20191106220523.18855-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0041.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0dd0bc42-6ed0-4b28-98dc-08d763057933
x-ms-traffictypediagnostic: VI1PR05MB5309:|VI1PR05MB5309:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5309F3E10FBAA193D11C7D34BE790@VI1PR05MB5309.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(189003)(199004)(478600001)(102836004)(25786009)(7736002)(8936002)(14454004)(64756008)(476003)(66946007)(71190400001)(52116002)(2616005)(86362001)(66446008)(14444005)(3846002)(6116002)(256004)(2906002)(6486002)(5660300002)(6506007)(305945005)(71200400001)(76176011)(386003)(8676002)(1076003)(6512007)(6916009)(66476007)(6436002)(26005)(186003)(107886003)(54906003)(66556008)(66066001)(4326008)(446003)(99286004)(81156014)(81166006)(486006)(50226002)(36756003)(316002)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5309;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q8qk/j1kZVU0WTO6+rgzXg2oLdltJcadjpLbTJKIq2ljkz4p/UJ3+uKMi7xUf0Ma3Ab9s5+/XINJIePYXAqJJKZgMqsQgk0sydeVURrZuJs0mlxl+R2Y9EfzIsma9i2oW/xhiTtJc9W5VX2sfEicq8yBtshjIc0A9OczgNOLl/K3L6nVZJpyeDMPcrGMSWBZQ0VN875JjSa698GQfmZKf6+t25NX8Gvdfen0c+SJUbZJk1OiI7RxPrZjc1VPRur/MSfJ29E5FN+prQVxbazcuQMQcAsn6ntAtkfVnV23eee5WFW69eKKuLU32vIwcKZvaERt1vlGvI+HAtm0k6B4QcHOZg9/WPEvj2LBRGvGyFP//tFqMgl18c6gnLEch9XehfXqwjZ6SRFQKNIDtcwCCdeZIkh/F8DRqZ7oKEw9cN127fGt79qUSoktMwsYfniV
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dd0bc42-6ed0-4b28-98dc-08d763057933
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 22:05:45.7554
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SeZhNgbrbsVACw6QVXgQUAQ/zYuniS8OTSH1XebLn0sGW3+ZR9I8Bd3ITPl1UxOvBUUzJbAQ3vS0q+76Zsofmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5309
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

For vlan push action, if eswitch flow source capability is enabled, flow
source value compared with MLX5_VPORT_UPLINK enum, to determine uplink
port. This lead to syndrome in dmesg if try to add vlan push action.
For example:
 $ tc filter add dev vxlan0 ingress protocol ip prio 1 flower \
       enc_dst_port 4789 \
       action tunnel_key unset pipe \
       action vlan push id 20 pipe \
       action mirred egress redirect dev ens1f0_0
 $ dmesg
 ...
 [ 2456.883693] mlx5_core 0000:82:00.0: mlx5_cmd_check:756:(pid 5273): SET_=
FLOW_TABLE_ENTRY(0x936) op_mod(0x0) failed, status bad parameter(0x3), synd=
rome (0xa9c090)
Use the correct enum value MLX5_FLOW_CONTEXT_FLOW_SOURCE_UPLINK.

Fixes: bb204dcf39fe ("net/mlx5e: Determine source port properly for vlan pu=
sh action")
Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termt=
bl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index 7879e1746297..366bda1bb1c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -183,7 +183,8 @@ static bool mlx5_eswitch_offload_is_uplink_port(const s=
truct mlx5_eswitch *esw,
 	u32 port_mask, port_value;
=20
 	if (MLX5_CAP_ESW_FLOWTABLE(esw->dev, flow_source))
-		return spec->flow_context.flow_source =3D=3D MLX5_VPORT_UPLINK;
+		return spec->flow_context.flow_source =3D=3D
+					MLX5_FLOW_CONTEXT_FLOW_SOURCE_UPLINK;
=20
 	port_mask =3D MLX5_GET(fte_match_param, spec->match_criteria,
 			     misc_parameters.source_port);
--=20
2.21.0

