Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD7C148F40
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 21:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404305AbgAXUVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 15:21:07 -0500
Received: from mail-eopbgr40044.outbound.protection.outlook.com ([40.107.4.44]:63396
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387421AbgAXUVF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 15:21:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OV8yeO04ekFG8QT6gHUl49cfBJ3SfVfLti5nFdzABQ2LKVr/4uhz8+L0XJ2Yj+il5ZjvXgVY87xrbyOxr4mXROEI4R5nDbATdOtn8p8+uqhLfUmhZ528H9sq3TfixWO2IzN45123aTjXgf+9PSz//iGt24wEwS+Q+dTWh0LK26+lDtyCt45sWHJoLoWUod/lr6LZthAETLLU/MHNQQxuqigsJ1A8YMfoxJgnGrJeWh4dXTcpPC2CxC6bMtd1Z9L5BAnD4iqp4efa16YLBQnQB2fGSEOcBl+Zqov9IldoZB1gCJHR6fq/3MUzzMCcYa0BpXCXsA9zwMuRedOV8DqSng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9JJiwKhL49DD2H+4EMQxrC7Mz4Mtd4sf+iAy0jWVvtU=;
 b=gNS/ekbSWdXwI5GB+tS/UddT4tT7k/uXj1M8EQug4RYL5W7YLapUvwbcAMAWiUnUKaAAcrarWbaQuvknn2qSUUQhEwbYqSwhtQ6kekKXFK7W0lnuD5sQuw62QL+DOlmQqsstJzhzHZsIW1c7VxFveYZsTQWOmhSoPwNXzB938ge5QyLQyfiLyfA7X+05B1Ma89OfYPJxSIX7jGCrvU1VNaHGTIoo598VshKMSZNlrbD1+9hQDvPs4q+jdrnmyz0xRA8bCMq2IK3fVvRPpyYPSsFefOqkh9ju8zsvD3RDTpxJ3T1jdg99+1KttMVIkP/ZpVVbtizDxVoFDahxOi03gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9JJiwKhL49DD2H+4EMQxrC7Mz4Mtd4sf+iAy0jWVvtU=;
 b=bI2ttFrODdjae/cGBkA86YUlp+4E4DDZu6VRdYPVrLGHkgA0c9w4sVhQBnIGvBYrIBhAhxhg0PV7L+JcwJ3vtLYnQ2P7ZbsF3sf0yLgscdogTXHnk6MM7fELe8MQBODkaeaqNRbpuRLxxvyK9sHbtYuJcEoC8snUhKXTXREL0zo=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5552.eurprd05.prod.outlook.com (20.177.202.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Fri, 24 Jan 2020 20:20:57 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 20:20:57 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR01CA0071.prod.exchangelabs.com (2603:10b6:a03:94::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend Transport; Fri, 24 Jan 2020 20:20:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Cohen <eli@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 4/9] net/mlx5: E-Switch, Prevent ingress rate configuration of
 uplink rep
Thread-Topic: [net 4/9] net/mlx5: E-Switch, Prevent ingress rate configuration
 of uplink rep
Thread-Index: AQHV0vPJz55mfIpcxUyA+xrOFlkQZQ==
Date:   Fri, 24 Jan 2020 20:20:57 +0000
Message-ID: <20200124202033.13421-5-saeedm@mellanox.com>
References: <20200124202033.13421-1-saeedm@mellanox.com>
In-Reply-To: <20200124202033.13421-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0071.prod.exchangelabs.com (2603:10b6:a03:94::48)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 72896465-9c5f-4ed3-9422-08d7a10aeb97
x-ms-traffictypediagnostic: VI1PR05MB5552:|VI1PR05MB5552:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5552BD6A74ECA1B713B3B929BE0E0@VI1PR05MB5552.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39850400004)(199004)(189003)(64756008)(66446008)(66946007)(4326008)(66476007)(107886003)(66556008)(316002)(1076003)(6512007)(6916009)(71200400001)(54906003)(16526019)(186003)(52116002)(26005)(6486002)(6506007)(956004)(2616005)(2906002)(478600001)(5660300002)(86362001)(36756003)(81156014)(81166006)(8936002)(8676002)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5552;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8W+HowsAhWwsQmpCEtumM8O3TwghhzbS2FqtjwKdMJB5dzQo/cTSV5XAMTZ5EYEauPZ3x6IJ1MOWIZG9GiWRSSX0PoN4W+K935MnIa7n3P/9xvAPRnsDs8ac0BQcXnnKyqg0XksYFNHJLhgJOLJeqTpCdgcW5zcQDyeB4YfQf+PJzm8Bzt/5kLC95dF9717b12s9tB5axx26rJv0HPCvJNkebWbcFHGSW6OvqOcnf05q8GR+tMWrkNdqpoFLVqY5dzcb9BWpL+cdbOJimDXSqLa7zU9wUEJH2c3Zjr5SKKgaPfGD5yA29oPut1vZQ8iqWmsO2XfrSXOBrXOI3z+cuAvDG/44/eTqIp9LbHUkzYedJxMQ33RhET1pt4xJnDGW7r1yfWdH+OqRZd+6MOJ8q2/0vnGHjGyUbiVwrSPdrRPtJC5+bc31fVDrTJxeVGmsefRYBCHWwIDKlWzi1RNhgczMNbQrElbiPCPRd4pcKgw9IP+cfRIPTICP6uWkA/rH6+u/eBYw9ywEK/ylO6wORP3Q9+3Ci4UkXVLD4gPs7Xk=
x-ms-exchange-antispam-messagedata: qPk9xblJeZgoctJTl/qZvWDL9w+GhGhAiNyrXTWQAsZtu0/KsRO7dhm8CWjyewcgibeP+AOvDU4QyKs5AphS9qtcONktF+qY7mc4GTH9mAARLtRNNmaq954xrB82Zuov4R5gY/j0xD0y/UN61kK04Q==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72896465-9c5f-4ed3-9422-08d7a10aeb97
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 20:20:57.2597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h6UYc+fdJfGoFska2xWeCu4cmId5ABOCfAVJ8P81wDlTi7LIJYbakWucXHuafmvDZwXoAxiM3BoXmxBL++WiyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5552
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Since the implementation relies on limiting the VF transmit rate to
simulate ingress rate limiting, and since either uplink representor or
ecpf are not associated with a VF, we limit the rate limit configuration
for those ports.

Fixes: fcb64c0f5640 ("net/mlx5: E-Switch, add ingress rate support")
Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 024e1cddfd0e..7e32b9e3667c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4036,6 +4036,13 @@ static int apply_police_params(struct mlx5e_priv *pr=
iv, u32 rate,
 	u32 rate_mbps;
 	int err;
=20
+	vport_num =3D rpriv->rep->vport;
+	if (vport_num >=3D MLX5_VPORT_ECPF) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Ingress rate limit is supported only for Eswitch ports connected t=
o VFs");
+		return -EOPNOTSUPP;
+	}
+
 	esw =3D priv->mdev->priv.eswitch;
 	/* rate is given in bytes/sec.
 	 * First convert to bits/sec and then round to the nearest mbit/secs.
@@ -4044,8 +4051,6 @@ static int apply_police_params(struct mlx5e_priv *pri=
v, u32 rate,
 	 * 1 mbit/sec.
 	 */
 	rate_mbps =3D rate ? max_t(u32, (rate * 8 + 500000) / 1000000, 1) : 0;
-	vport_num =3D rpriv->rep->vport;
-
 	err =3D mlx5_esw_modify_vport_rate(esw, vport_num, rate_mbps);
 	if (err)
 		NL_SET_ERR_MSG_MOD(extack, "failed applying action to hardware");
--=20
2.24.1

