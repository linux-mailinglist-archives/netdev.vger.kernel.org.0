Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E75E4E93DE
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbfJ2XqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:46:17 -0400
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:58441
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725974AbfJ2XqL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 19:46:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QcMlTHg3vnRbjLFVXuqFFoFEXBTw4NR9WFusbEoabUiNUXO774VdjdsFG214EucXa0BVNEJHqeNNSZ914gdkdCC+wNDRGOQurlC+S7j0kUyPRHOxFHGwaeFvA3IVgKTAxRi7vBVMfygiSkCLLaLwOzrbQrwucLnOjWhoRaXxipGO7BhFK7Z7sXXtxUB2Dy1EccnF5UQrvwMTEnfV4I8pilzUkY8iwv5Jw/dfjYRYu5EqiMy1lQ21l9FojMEmqDixmdQ0jOt+z2L+VYazXTyAHcp/na5kNalugclIzygLXySvpiUA721/muQ3/nVeurI5GYuuKrN9rT4miAtUFjxDEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NjrJqMqvMaHbPk8qNMMcDsjRoLnSpEQN2DGSNtgKB5E=;
 b=Wzv2g+phZymbkv8WzKHffv/UtHrDptEjc9i7XXEnWv/TwbvpkSyXkUI4nIewB8S8Lr/3szrQHbZUGBN5VrQHSgcShheiAA/Lm/9zZYRdd5NGNbc43rtrx0Rm5P10VSsVng3HbN1ut4ohwPM4/tpFzhXPih+pQqChgCE6qZQHKZ57q0/yKjmuaTR9E76ovXVydim3BPyhWcdS1lWSBSrneGY7pVAo2H0VrTnYkpmtT5a0uFVX7LZyahohFnan/tfpmVkQATzF5WroG5Iw3atgiISFsgPYeq53K3XQqRtggm7NXiLd3SKpU1K8y+A+uzG2WRvN02ivmtvMocZeyE7hSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NjrJqMqvMaHbPk8qNMMcDsjRoLnSpEQN2DGSNtgKB5E=;
 b=E8xqS9MCH3EiU5PIwjqlKuEywp52Vu+KXqfkNyDkTMqczuGpimSdsK3T4ps7THmvUbJ7511xY3QMtera/JVamA0HMYHygt2Gu9hG4Gznut0Xt+UBC1ERk6q7qC497zaoYbaK4ovXSUC5QyxULi5nfifSPTPdEbrz/DcYog+VHg8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6157.eurprd05.prod.outlook.com (20.178.123.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Tue, 29 Oct 2019 23:45:58 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Tue, 29 Oct 2019
 23:45:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmytro Linkin <dmitrolin@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 03/11] net/mlx5e: Remove incorrect match criteria assignment
 line
Thread-Topic: [net V2 03/11] net/mlx5e: Remove incorrect match criteria
 assignment line
Thread-Index: AQHVjrMDVGkkMrLJkU+VAOzt7QeKkg==
Date:   Tue, 29 Oct 2019 23:45:57 +0000
Message-ID: <20191029234526.3145-4-saeedm@mellanox.com>
References: <20191029234526.3145-1-saeedm@mellanox.com>
In-Reply-To: <20191029234526.3145-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR08CA0050.namprd08.prod.outlook.com
 (2603:10b6:a03:117::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ea40e7f0-d3dc-48c9-df0c-08d75cca253b
x-ms-traffictypediagnostic: VI1PR05MB6157:|VI1PR05MB6157:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6157C684FFA061BFFB59C1C0BE610@VI1PR05MB6157.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(199004)(189003)(6486002)(486006)(4326008)(2616005)(476003)(6512007)(66556008)(71200400001)(66446008)(66066001)(11346002)(6116002)(8676002)(54906003)(2906002)(7736002)(316002)(6916009)(81166006)(81156014)(478600001)(107886003)(8936002)(50226002)(6436002)(1076003)(446003)(25786009)(36756003)(3846002)(14454004)(71190400001)(86362001)(305945005)(14444005)(99286004)(256004)(26005)(6506007)(386003)(66476007)(76176011)(52116002)(66946007)(102836004)(186003)(64756008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6157;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HtOPeWiJuJHfKNRxoKCJosiC+o8cIUVntOmd+Hyvth5UvgdNQ1aRQ55KFdtuSKYS6FcawVs1zKVkI6YAnVDAH61mo8O92QCr3W/zLKqDs/TscBS9SZ5L9IL9alNd4zLKYM/rO0aZ1CxLlYBwgzkRQFr/f46Fy38p8WvS1hut+8uuyEWjqVHUxCeHD3F3Zp6Lp8P/3dbd0jiflrRAflcN7ZFnljomIyB81wgg6Uo8/fhRj79gRKP87s6BF310wxBf8aKYBwjanaFLsWSaZS9UWiRzkhOqItE9EHuSLAoqjr2Q8WI3g3oeVrxBeqRB+x8cNjro8myUuLd+WYB53IsWq+wb0MdKkUxx5ELRPsQLe8GQmBss1rpB5jv1iByOYUtmbgd9yhxXWkyjxR8jiiq8Sn6A2Fwuwnpxfbgsq702MvG6GoMXpxFohFEK59vhraDx
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea40e7f0-d3dc-48c9-df0c-08d75cca253b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 23:45:57.8601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LFt/RciKBnQ41hHsrZYPFe+SQPfChsCZ+ZyMhK3pHCU3fKfQtvQo2YUeVIx+TbS7dLWSHN3cO1e3qdgWKL9pwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

Driver have function, which enable match criteria for misc parameters
in dependence of eswitch capabilities.

Fixes: 4f5d1beadc10 ("Merge branch 'mlx5-next' of git://git.kernel.org/pub/=
scm/linux/kernel/git/mellanox/linux")
Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 00d71db15f22..369499e88fe8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -285,7 +285,6 @@ mlx5_eswitch_add_fwd_rule(struct mlx5_eswitch *esw,
=20
 	mlx5_eswitch_set_rule_source_port(esw, spec, attr);
=20
-	spec->match_criteria_enable |=3D MLX5_MATCH_MISC_PARAMETERS;
 	if (attr->outer_match_level !=3D MLX5_MATCH_NONE)
 		spec->match_criteria_enable |=3D MLX5_MATCH_OUTER_HEADERS;
=20
--=20
2.21.0

