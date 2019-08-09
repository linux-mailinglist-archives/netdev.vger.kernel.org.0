Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28AEC88584
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729629AbfHIWEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:04:51 -0400
Received: from mail-eopbgr10055.outbound.protection.outlook.com ([40.107.1.55]:23013
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728985AbfHIWEu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 18:04:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZjfZOrW6YSFzxqmwnlKsClfkE5UeaVESURnCcS9Y3O3YKfgCW78komv8xK74K86OMpLgmEg8BbbL+JtLGjfcAjbSLdBVMCKuhFX1Eovz6My73MgbsJw43q6bGfBT4wEBQovS7S8w0b1gI+NNPwjpYv2CzPuVJvFnGFGUKDBZ2U88jFOKfD3Bxhc+q8bJRzosA9KvwP6G1ph7ToZc7W/2glmgw4tHdobC2Y0O+AUzcavQHKhz3TuoqbUN0uupJxKfkAS46KrgnnfI2HaKQmLvMPb9PmjMqEasWiNNF/8WGZui7SNe440VQPdxYjtEq0t1X4IIXl4f/9nRe3G5cRceog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M3F/Xb9TGvfG1bK3/v3S+a4YFAbIP7Go2u2yCRVxKdE=;
 b=b2jQSda7S3RiKj1qJU+kVmBGdN2z3Q+fZNBMS3MtFEjC1ne+73+NXpnnfA/akN92yz4lenBlWC6/EM+l9MAP27hdChsn2u3QAtOK9DdXVz+7RekeNcbF5kQYfewOy1E7XjRCI3AL2NJie+IhAXTcin/tAAL1aLcvKsMMYFvNDxjvi/vwusOu8u3dj7G5UrIgqD4gzhnJCVo7NlV8bIHig3gQBwlEi1QTyiE1o809deoaXOx51caQ9zcyAc7pOSGKC5gGbTVux8kNRjE1B+9cO7lFBeY5xXxSMiGRclJeRMtVav5V2zKHcSoGN7xolIva+Ys4c7OTCpqg6bpwzae3xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M3F/Xb9TGvfG1bK3/v3S+a4YFAbIP7Go2u2yCRVxKdE=;
 b=PG/hDtxtI6DnnREDxa87JI5axlORUhDhqbWcyHpIhl9Sl+ODTGMV/qRPTUlQrnhAsC4g1sFyI1icuK1/X520tAkYxWNztfRrl8vK5z9gcTTXrxTrLs4ec6RXiq+pD7tWiJslYucwDGFXPNm3cRF4wTlogJFNClQffcGgnEcNfHU=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2405.eurprd05.prod.outlook.com (10.168.71.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.12; Fri, 9 Aug 2019 22:04:42 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 22:04:42 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 14/15] net/mlx5e: Use vhca_id in generating representor
 port_index
Thread-Topic: [net-next 14/15] net/mlx5e: Use vhca_id in generating
 representor port_index
Thread-Index: AQHVTv5yTRcZUwBpl0qkOXmbCfJTBw==
Date:   Fri, 9 Aug 2019 22:04:42 +0000
Message-ID: <20190809220359.11516-15-saeedm@mellanox.com>
References: <20190809220359.11516-1-saeedm@mellanox.com>
In-Reply-To: <20190809220359.11516-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::22) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26ddaff1-8c5d-4e0d-45de-08d71d1594e8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2405;
x-ms-traffictypediagnostic: DB6PR0501MB2405:
x-microsoft-antispam-prvs: <DB6PR0501MB2405F5F40743F76408178D55BED60@DB6PR0501MB2405.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(376002)(396003)(39860400002)(189003)(199004)(446003)(66556008)(36756003)(6512007)(6436002)(99286004)(66476007)(26005)(102836004)(53936002)(478600001)(5660300002)(316002)(8936002)(4326008)(486006)(71190400001)(11346002)(2616005)(386003)(66446008)(66946007)(6506007)(186003)(64756008)(6916009)(3846002)(6116002)(256004)(52116002)(305945005)(1076003)(476003)(81156014)(8676002)(107886003)(81166006)(86362001)(7736002)(14454004)(50226002)(71200400001)(66066001)(54906003)(2906002)(25786009)(6486002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2405;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: gvidWca1H31ym9Kza2rrEeOT0Mf3y9q4q4TLqCVABYiJfAFohQncY1+tZUVVIcu3h6Zv1zzALtUzTNUlR8go3Ob8taf6J1IXSLPLPWPIlVyIPWrPsy2/wl++IpspN69N1bzmqCvoOHbIWXgqIkQGNkCYDG4vtMGDSaQsPLmB2aLuMh0iziRDrk6oy2OXHVTS31JDQmqlS8rjj5/2uEKfR/VWZ30okiSXNzr7v2U6rxHdxV8zd/+GAmqf2DE8pBhjSy+VaIdbOXz166IMS4JTc41sWkLAi3OJb3id8zgOH/pAcU9wraIaJ4pV9Jr3+rgTZkGJDikBWPL/SU//D92/Av7d0IqwbiknIlDDzTy6LG89k6o3k8MkES7G63dHQ2BIFEFwReIsWotFlC97G7aPnkejnzsGQWfKdPqiV+rpoL4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26ddaff1-8c5d-4e0d-45de-08d71d1594e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 22:04:42.8082
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dumc7mmIYC9Fx23wAhKpjOl5SYwHxZOjM2COoxRRegwHRmGfbxHAJ/OM87q9U+Jv42HLb+/HPTyr5bvzHFd5fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2405
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

It is desired to use unique port indices when multiple pci devices'
devlink instance have the same switch-id.

Make use of vhca-id to generate such unique devlink port indices.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 20 +++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index 33ae66dc72e2..7ce5cb6e527e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1746,34 +1746,46 @@ is_devlink_port_supported(const struct mlx5_core_de=
v *dev,
 	       mlx5_eswitch_is_vf_vport(dev->priv.eswitch, rpriv->rep->vport);
 }
=20
+static unsigned int
+vport_to_devlink_port_index(const struct mlx5_core_dev *dev, u16 vport_num=
)
+{
+	return (MLX5_CAP_GEN(dev, vhca_id) << 16) | vport_num;
+}
+
 static int register_devlink_port(struct mlx5_core_dev *dev,
 				 struct mlx5e_rep_priv *rpriv)
 {
 	struct devlink *devlink =3D priv_to_devlink(dev);
 	struct mlx5_eswitch_rep *rep =3D rpriv->rep;
 	struct netdev_phys_item_id ppid =3D {};
+	unsigned int dl_port_index =3D 0;
=20
 	if (!is_devlink_port_supported(dev, rpriv))
 		return 0;
=20
 	mlx5e_rep_get_port_parent_id(rpriv->netdev, &ppid);
=20
-	if (rep->vport =3D=3D MLX5_VPORT_UPLINK)
+	if (rep->vport =3D=3D MLX5_VPORT_UPLINK) {
 		devlink_port_attrs_set(&rpriv->dl_port,
 				       DEVLINK_PORT_FLAVOUR_PHYSICAL,
 				       PCI_FUNC(dev->pdev->devfn), false, 0,
 				       &ppid.id[0], ppid.id_len);
-	else if (rep->vport =3D=3D MLX5_VPORT_PF)
+		dl_port_index =3D vport_to_devlink_port_index(dev, rep->vport);
+	} else if (rep->vport =3D=3D MLX5_VPORT_PF) {
 		devlink_port_attrs_pci_pf_set(&rpriv->dl_port,
 					      &ppid.id[0], ppid.id_len,
 					      dev->pdev->devfn);
-	else if (mlx5_eswitch_is_vf_vport(dev->priv.eswitch, rpriv->rep->vport))
+		dl_port_index =3D rep->vport;
+	} else if (mlx5_eswitch_is_vf_vport(dev->priv.eswitch,
+					    rpriv->rep->vport)) {
 		devlink_port_attrs_pci_vf_set(&rpriv->dl_port,
 					      &ppid.id[0], ppid.id_len,
 					      dev->pdev->devfn,
 					      rep->vport - 1);
+		dl_port_index =3D vport_to_devlink_port_index(dev, rep->vport);
+	}
=20
-	return devlink_port_register(devlink, &rpriv->dl_port, rep->vport);
+	return devlink_port_register(devlink, &rpriv->dl_port, dl_port_index);
 }
=20
 static void unregister_devlink_port(struct mlx5_core_dev *dev,
--=20
2.21.0

