Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 908FF163B12
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgBSDXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:23:25 -0500
Received: from mail-db8eur05on2089.outbound.protection.outlook.com ([40.107.20.89]:22272
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726736AbgBSDXY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:23:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VQWy46ImstHE4tEy1WeEe1onn7adZiYNpljeYgOYiZcWiX2YCAfbQo6zQfhyNJXDDTPxmtZrmXhyqFvxcWXcin4w4iosiAnXSiNDGBELQE/9X3+baKHAFeT+ZscCnLoA2QyNyWBAPLGaU2Jmb9oflTDayKQx+M+cLu5XTLIFYmPPuLY8WI7pJVTfHrCjlfYZv6CuL1OP6jlyfmrG9qGcArhnabklxDAG+Yq14CXKNxQnajB0K2ulaVqTXQ59C2enwv/KNk+fCLsDEAPefmJl0So2TbezqHdRSQ87d69VQjQN0xMbpL19F0wykvLQkbMHjgBCmz+xh29Kopo9tqSKPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nxV+DVW+l5LEMtna4GMdCvJf7TpAohvJV15WiZDUeAs=;
 b=kTOnNEyt2L2m++8YCbk3I5eZY8Wfb9rGuzxzuhOw5pYtZySg6Tpf41BQe5e5NVY878TIYYPjsrQ6tIv6uW3WdjaUjYFO/HR3tUdnM0ntZSHLlKcDzRDqQJeJj5H2JksrYkT803018Jbld+lNfcEPIO0x/b3QsQhJuVbFLAFvWot2H1GJnMtDBh8SuEtgiW7smfizYPD2S4uDSx3cmN5YoSbitMrdqlUzWFEJ2q/8Xc3lKwjRKJSqPAJlPJM+QDO5j+PBc4r9oxqkn5sPPXKSRyY6ZTBVWwuQ1+8K+UpSywV3fFqzKJrpftIXXuWTAw5vm4BGZ4sgcQ4A58n32EFGVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nxV+DVW+l5LEMtna4GMdCvJf7TpAohvJV15WiZDUeAs=;
 b=KJq9pz/JIgUC/D2Soyg9pAKb5VB9o7lamknUpC3XEvgZ8IgAHYY2vhfkn4wICsMGhbMYCylh1iYkNcd0vGLN357Dt9SGjCo9OxoDc6eN9IZdV7HBGKK/aKjPwKKmByElb/W1mOJg16S05uXOh8+k+Xn5AmMul49R5K82/WR0E/c=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4590.eurprd05.prod.outlook.com (20.176.5.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.27; Wed, 19 Feb 2020 03:23:14 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Wed, 19 Feb 2020
 03:23:14 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0001.namprd02.prod.outlook.com (2603:10b6:a02:ee::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Wed, 19 Feb 2020 03:23:12 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V4 07/13] net/mlx5e: Set FEC to auto when configured mode
 is not supported
Thread-Topic: [net-next V4 07/13] net/mlx5e: Set FEC to auto when configured
 mode is not supported
Thread-Index: AQHV5tPrm8JfGW9Zxk2Nz3IgoxuyCQ==
Date:   Wed, 19 Feb 2020 03:23:14 +0000
Message-ID: <20200219032205.15264-8-saeedm@mellanox.com>
References: <20200219032205.15264-1-saeedm@mellanox.com>
In-Reply-To: <20200219032205.15264-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR02CA0001.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 856595f9-681b-40cd-813d-08d7b4eb0e39
x-ms-traffictypediagnostic: VI1PR05MB4590:|VI1PR05MB4590:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB459071A71519D629270D5D8EBE100@VI1PR05MB4590.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(376002)(396003)(136003)(39860400002)(189003)(199004)(2616005)(956004)(16526019)(186003)(478600001)(66446008)(66556008)(71200400001)(26005)(86362001)(66946007)(66476007)(6512007)(36756003)(6486002)(64756008)(107886003)(4326008)(110136005)(8676002)(2906002)(5660300002)(316002)(54906003)(8936002)(52116002)(81156014)(81166006)(6506007)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4590;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0S/F8uNlyUKLBenzRAiIfannRMPIO9ui/KYv9l/AOd7fkLPNq7Mn/H9rpu9l4EwzeGgdl+Rz0fpkTyuqlDDIeRciuPjrHsxkTwdKGk+bkP5XDO78GL+q2Y4gGk1rV4SnKrMegdLFBWe6PieLi9ICgFUuzgupeNjAN48sK/uBbx4pLhXmN5czkR2dUolsOpqg0p/hG64QdGixGdWHMODJsX1/31cnh5oUuZJHV0t3hIfPzUJfdtdwToatOhb3JFKv/PwOnd31eKwqKdD79WQz8hNSio7V8Ni/nNiVSvWVe3oAACHbTtHG0tojUGBsmXACmOGNW3Nbvekl20zrKeBszm+h2aCZ518SL0QlpuLJGoLdnUZ71xsZ3R4VaHVFJ4bkcAeVH++Iv8NCE/AmNoDvBj6nTmItRJlKIltPR92i9AHQ0S4p1lmaZpmsreDsApBQFmBZQM3V7uLUwgt2aqzc5992CnEEq1BD6QIB3BSPwBTRmcNUoGdQMOWkMg4WdmjEoWN2uK9RhX9Au+nz+INctSr2NOV66S8YSMV3glW8TWI=
x-ms-exchange-antispam-messagedata: zLXkdOBS70x+Wjd3sDHx93lxQKTp1Hvn8XHyGzEdL8Wv+9hnseUmkMk4CGx70RArCAD3Ipr1len9UzmHWQp3TS5kPdsjoHRzMg0AZo/P/2X5uAXac8xX3LdJ/CfFOQXbXYRFDqq0hoLjV5KX3fxA4Q==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 856595f9-681b-40cd-813d-08d7b4eb0e39
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 03:23:14.6757
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l4XTos+SilhkbSHPCgmy1L3jOTmjFNYRKxECUDP0UrR2jMeVTSE18mN+PK1OQ1Qlrb0kVZox9NRJbRmScS10Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4590
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

When configuring FEC mode, driver tries to set it for all available
link types. If a link type doesn't support a FEC mode, set this link
type to auto (FW best effort). Prior to this patch, when a link type
didn't support a FEC mode is was set to no FEC.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/port.c | 22 +++++--------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/port.c
index fce6eccdcf8b..f0dc0ca3ddc4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -501,8 +501,6 @@ int mlx5e_get_fec_mode(struct mlx5_core_dev *dev, u32 *=
fec_mode_active,
=20
 int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u8 fec_policy)
 {
-	u8 fec_policy_nofec =3D BIT(MLX5E_FEC_NOFEC);
-	bool fec_mode_not_supp_in_speed =3D false;
 	u32 out[MLX5_ST_SZ_DW(pplm_reg)] =3D {};
 	u32 in[MLX5_ST_SZ_DW(pplm_reg)] =3D {};
 	int sz =3D MLX5_ST_SZ_BYTES(pplm_reg);
@@ -526,23 +524,15 @@ int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u8 =
fec_policy)
=20
 	for (i =3D 0; i < MLX5E_FEC_SUPPORTED_SPEEDS; i++) {
 		mlx5e_get_fec_cap_field(out, &fec_caps, fec_supported_speeds[i]);
-		/* policy supported for link speed, or policy is auto */
-		if (fec_caps & fec_policy || fec_policy =3D=3D fec_policy_auto) {
+		/* policy supported for link speed */
+		if (fec_caps & fec_policy)
 			mlx5e_fec_admin_field(out, &fec_policy, 1,
 					      fec_supported_speeds[i]);
-		} else {
-			/* turn off FEC if supported. Else, leave it the same */
-			if (fec_caps & fec_policy_nofec)
-				mlx5e_fec_admin_field(out, &fec_policy_nofec, 1,
-						      fec_supported_speeds[i]);
-			fec_mode_not_supp_in_speed =3D true;
-		}
+		else
+			/* set FEC to auto*/
+			mlx5e_fec_admin_field(out, &fec_policy_auto, 1,
+					      fec_supported_speeds[i]);
 	}
=20
-	if (fec_mode_not_supp_in_speed)
-		mlx5_core_dbg(dev,
-			      "FEC policy 0x%x is not supported for some speeds",
-			      fec_policy);
-
 	return mlx5_core_access_reg(dev, out, sz, out, sz, MLX5_REG_PPLM, 0, 1);
 }
--=20
2.24.1

