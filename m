Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBE179D0C
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 01:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729931AbfG2Xuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 19:50:39 -0400
Received: from mail-eopbgr130078.outbound.protection.outlook.com ([40.107.13.78]:57824
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729895AbfG2Xug (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 19:50:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bUc9XrMStviFvRpFfP5hcmUQMF+SlVMa/oD3uaOUcIXguEDk9e2cjEUQxGi3XUdZWFPYuGRV2aa+CH7dk2Cg07JVhYLTMEZB/hd/6JdkbPjY7dAHnLhP09hPNvNHJAhHeCY1pdKfc1+BgmaghsH3Gg5CCnvoHkWVYB4L8xBso/fnSfL/heTc6HmlBEWDAjwGKt40kEH2nDKsV8BpJF7OEr1ApUIJWiHcslh7efSWi6l2UPoMA/OLLfBM9iY+x3cLtSaX9GJoWFIIlsqxMGdnDSrn8S7d8ISwWcttHem+BxneV8GG0/Cc0Qxz1unsJEMG7gCZHOYzF6y7FXcaf9B6ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWoot6sFLKKUmz9z8FjYvAw4huhVeZKEIsAYc6JIgEE=;
 b=JbSCMSjJ/Utm6LNECxrofzMTx+ahrV4W6UQH1bjXomMTKRAfbj7CoGIXgzrfy3Q9igxGOkfYnlGzbfd/TNA5A0vZeO1BWnhgGf3XqMUB64F5h2+x/Eu1ALnGc2IO0zzInPla04f8WCpAaKU69de7B53KCAeo3QfethG4lChHuGeEObOGCCoa8ArECrHeVtyq5jtDPJ9QmEW4nYbnQIjrhKJ9kyfF6fVLGfYyvovcCnFdEo54HBk1/xQgsLETfmEtOpnI2xj/Z9uDE//OfsRElpIN+CjhlmWuSPHwHUo5lqo7DeGeCun+teIDcz+dgNHyYPZx9NbR7Hc1OmdFXBKFnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWoot6sFLKKUmz9z8FjYvAw4huhVeZKEIsAYc6JIgEE=;
 b=Q4sTdzDLynzwhpePB8gi22JfEOx++Hyzsl21GJYhuislIy7i4H8+zuH3e33I4kb+LNJDIRbKLIVwQJ7esgYcmdFpAJa4GXnm+AQQe5SbmvO02xR39pVrHoZ5+i1LuDhMXTyywVrUBHMx2ux5qVqfIPiWyQfDoihfKM1FzfcxaTU=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2343.eurprd05.prod.outlook.com (10.168.56.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 23:50:23 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 23:50:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Britstein <elibr@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/13] net/mlx5e: Simplify get_route_and_out_devs helper
 function
Thread-Topic: [net-next 05/13] net/mlx5e: Simplify get_route_and_out_devs
 helper function
Thread-Index: AQHVRmhiREpTpVE4OUO0mXB4KcrWNw==
Date:   Mon, 29 Jul 2019 23:50:22 +0000
Message-ID: <20190729234934.23595-6-saeedm@mellanox.com>
References: <20190729234934.23595-1-saeedm@mellanox.com>
In-Reply-To: <20190729234934.23595-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::28) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d3ff833-ca4e-4360-69e1-08d7147f854f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2343;
x-ms-traffictypediagnostic: DB6PR0501MB2343:
x-microsoft-antispam-prvs: <DB6PR0501MB234317503E2EFFD9A8B0A541BEDD0@DB6PR0501MB2343.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(199004)(189003)(14454004)(25786009)(71190400001)(71200400001)(386003)(6506007)(6512007)(81166006)(81156014)(76176011)(8936002)(6436002)(8676002)(6486002)(316002)(102836004)(54906003)(6916009)(7736002)(478600001)(52116002)(186003)(26005)(99286004)(256004)(476003)(5660300002)(1076003)(66446008)(66066001)(66556008)(66476007)(64756008)(36756003)(53936002)(486006)(86362001)(305945005)(107886003)(66946007)(68736007)(446003)(2616005)(11346002)(50226002)(6116002)(3846002)(4326008)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2343;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UWBlNYNF+HVUWsDNARct1S7hI4WNIAtadMknpMyHLxHhtbE96mNioE3sq7krOPX3MsDIXPzgVQQXNWK+UHTMhhFoix2oVHIahXGyBmRBwIAQXjXqEb9VpSJRYo2pkDrWfdAr6KK2bHzVvrXQDrSBjKcuZy5lPCR2Ha0dEwJTVM16j/UWyOftUopwXfOevkpyXrUqA/CDmf8uOTZedZQtR7XoeN7uvmC8qpFSxpBDGZRmMVRZpkeLFtIOpj7n/6BENSlc/4sRQuBxG1tzKPCCUFh4akEQRxxW3nNG1ydZtvR4G81WzplKzH7+TFIpf7DN9MG55lUTyi6Qy7kMTs4H6BgNPM0AwVufvs8fGcyajFcakK4YIlwcWwIgZdpQSnARF+sD/T34M6fJ7b1Kd1zlNtJubeYJFTcRcGIxewWs9SU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d3ff833-ca4e-4360-69e1-08d7147f854f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 23:50:22.8049
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2343
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Britstein <elibr@mellanox.com>

The helper function has "if" branches that do the same. Merge them to
simplify the code.

Signed-off-by: Eli Britstein <elibr@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index a6a52806be45..ae439d95f5a3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -40,20 +40,15 @@ static int get_route_and_out_devs(struct mlx5e_priv *pr=
iv,
 	/* if the egress device isn't on the same HW e-switch or
 	 * it's a LAG device, use the uplink
 	 */
+	*route_dev =3D dev;
 	if (!netdev_port_same_parent_id(priv->netdev, real_dev) ||
-	    dst_is_lag_dev) {
-		*route_dev =3D dev;
+	    dst_is_lag_dev || is_vlan_dev(*route_dev))
 		*out_dev =3D uplink_dev;
-	} else {
-		*route_dev =3D dev;
-		if (is_vlan_dev(*route_dev))
-			*out_dev =3D uplink_dev;
-		else if (mlx5e_eswitch_rep(dev) &&
-			 mlx5e_is_valid_eswitch_fwd_dev(priv, dev))
-			*out_dev =3D *route_dev;
-		else
-			return -EOPNOTSUPP;
-	}
+	else if (mlx5e_eswitch_rep(dev) &&
+		 mlx5e_is_valid_eswitch_fwd_dev(priv, dev))
+		*out_dev =3D *route_dev;
+	else
+		return -EOPNOTSUPP;
=20
 	if (!(mlx5e_eswitch_rep(*out_dev) &&
 	      mlx5e_is_uplink_rep(netdev_priv(*out_dev))))
--=20
2.21.0

