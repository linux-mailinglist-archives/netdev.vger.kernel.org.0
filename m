Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2181210453B
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfKTUgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:36:43 -0500
Received: from mail-eopbgr20061.outbound.protection.outlook.com ([40.107.2.61]:41697
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725819AbfKTUgm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 15:36:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N4tVkhJPmgeuJLp4hRxF4rtrnWmmPJ257S320y1PIcBahuoeMi9cgt4Os9vRU73qP+Zn6aaSVf6cMnCV1zsyCpqQcvuWs73q7UEXbmyXGUuYSwElzetlcog1lIDOvlmwFOTHk3QzR44YAaOE6uwpIT+Yg0TZN3pxSnGcxeaAyCiyytiO3T6U4JMy8d98isGgRZc1RrW5kwTO7wDNQlN5wa8TI1+MEcq0ite/lRBSQx3LBC0Fyje17ziiUYDx9Qz2EazQrwvljW8XI8/6aNW7sJ2dgggHZtjce1jq/aU2cPdNjSmKgzflgXJxYVTuYazepq+63C+IRmblLoCdXwvRQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xs0EYBI7dAB4fckXu5EPdgDklK5VS7jvzTfrK/jvTpw=;
 b=bsbtL6A5XUvGdCIO6yP6V2OKb/xi2ZIJpXQiLkyr02GiN/qDQf58UeHuuj3TB3eXpn3rSLzmzBE5jRU16JS4zBCPIldu6IOFUbiH4NUTKZpAJq2EfRPeqQn3zq/j73n115YQzICr5zSa8Xkz0qna9nr9VVEfe33UXeG3UB6E+bChr962lfwFGjIxo7W6xRPwL2V3dvrAI+PhW9whTt7lSiv85RUT2QLuo3URYfiCvFOGMYOzZGA6Z16B1KukPYN369qxka6tqkLNAKkvaBHh+Lc1I7H6P6iGGpGea7hYO4aRsx1oIQMcW6WpWLjMrM7MT95w2wldVJVR4uTVFPVRqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xs0EYBI7dAB4fckXu5EPdgDklK5VS7jvzTfrK/jvTpw=;
 b=fbnwJ0tvnsYT6yt/4eIgwee1yoKlb4NrIhiZtcfVSxrY17SB5mM2bDOQSNm4bXI1/WDR6Gti0hXqk8uOpC+hHPYPtUwMgW+ucdBBForxCEY9Pu3V6Cxb8c617b6brwwRz6sbuz6j7WczUTOVGUCvfFGddW4gnCAw6pn9IiV9pKw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6110.eurprd05.prod.outlook.com (20.178.204.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 20 Nov 2019 20:35:59 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 20:35:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Marina Varshaver <marinav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 09/12] net/mlx5e: Add missing capability bit check for IP-in-IP
Thread-Topic: [net 09/12] net/mlx5e: Add missing capability bit check for
 IP-in-IP
Thread-Index: AQHVn+IdNpMEOcLpfkWrL6KqavYl0g==
Date:   Wed, 20 Nov 2019 20:35:58 +0000
Message-ID: <20191120203519.24094-10-saeedm@mellanox.com>
References: <20191120203519.24094-1-saeedm@mellanox.com>
In-Reply-To: <20191120203519.24094-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0044.namprd02.prod.outlook.com
 (2603:10b6:a03:54::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c28e7c9f-8fdd-4f90-c79f-08d76df94014
x-ms-traffictypediagnostic: VI1PR05MB6110:|VI1PR05MB6110:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6110AC289CD8A8590430CD8ABE4F0@VI1PR05MB6110.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(189003)(199004)(66946007)(6512007)(446003)(11346002)(66476007)(64756008)(2616005)(476003)(52116002)(14444005)(76176011)(107886003)(5660300002)(8936002)(66446008)(66556008)(186003)(26005)(478600001)(25786009)(14454004)(6506007)(6436002)(386003)(8676002)(50226002)(81156014)(102836004)(99286004)(2906002)(81166006)(6486002)(71200400001)(256004)(7736002)(305945005)(36756003)(4326008)(486006)(6916009)(54906003)(316002)(71190400001)(1076003)(66066001)(3846002)(6116002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6110;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: igKd4Uk2P26W0okLLl5rbSoZQscQ3OpjEVQ5FNMOg2+hCle9OhI+0O1jlJnshXgYK7OYVes/IrijKDEmCvImaWhiJiqIuIQaTmyjEs3e+yGBq52H6yBvAglTXcTldCvFQmh+jp7KSjMxfQ1DI1m5AvhfdthjnJ51GfldwvCaoWlKcjpmwY2X4BK99/oZnpRQmdBRaYkBLILd/eH7bHokh5OThYOwSKIajOTQ6a3jjbU4FKCLX4NFBA6/jUQkh0QPc992J+9OD5SFFare+Ue3Ex+8l9l63A6ZyosdBl5CR5SoVd4QPK1MSkR8FIl4dXYZgarlLB45gL7TQgajNDXBbv1KbJ/yekXUDJ+XUAu00EtSKPkpVribTYq6PMzc2y/SBlilLcchg660X83W5zbdrzXQHsIT7lx6TJCtOENtKs3atodO3UWFOcorscuTHm+f
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c28e7c9f-8fdd-4f90-c79f-08d76df94014
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 20:35:58.9270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aSmLjSC/uBtai6RswruaggNd8kooRzdSTqypSkV1wT/RtdVyGJqayTlkNxsmuZekWqAj8NqS0xKyki4NXKhoKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marina Varshaver <marinav@mellanox.com>

Device that doesn't support IP-in-IP offloads has to filter csum and gso
offload support, otherwise kernel will conclude that device is capable of
offloading csum and gso for IP-in-IP tunnels and that might result in
IP-in-IP tunnel not functioning.

Fixes: 25948b87dda2 ("net/mlx5e: Support TSO and TX checksum offloads for I=
P-in-IP")
Signed-off-by: Marina Varshaver <marinav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 772bfdbdeb9c..2a56e66f58d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4252,9 +4252,12 @@ static netdev_features_t mlx5e_tunnel_features_check=
(struct mlx5e_priv *priv,
=20
 	switch (proto) {
 	case IPPROTO_GRE:
+		return features;
 	case IPPROTO_IPIP:
 	case IPPROTO_IPV6:
-		return features;
+		if (mlx5e_tunnel_proto_supported(priv->mdev, IPPROTO_IPIP))
+			return features;
+		break;
 	case IPPROTO_UDP:
 		udph =3D udp_hdr(skb);
 		port =3D be16_to_cpu(udph->dest);
--=20
2.21.0

