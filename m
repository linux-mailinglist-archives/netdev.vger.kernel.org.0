Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2F6E131C74
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 00:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727332AbgAFXgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 18:36:35 -0500
Received: from mail-eopbgr20053.outbound.protection.outlook.com ([40.107.2.53]:32391
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726735AbgAFXge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 18:36:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H6pUYsbrF+AinWniSkBoX6fpvni3gmIJvvg7UnYFJnTVCV2sVT92QVg1QRC7LlvnonUr3Mxahub2z36BGjOjJYqrKJYb9ROLWEyt3UeXFUk40pW8t2rOgTibtVswBr8zN7gM+IDUJ3ocEsZPp20BuPuIrgLRr0NNwP8BYS1bFWWVoynP5alYehwhLjuWyet+3Cbc/DwPGWgvCjDp2Iik6V63ZVIiJJ24d0gSO5jpiLEsPf2oB/jI/FdQDbdo/Kb5y7s8NanmhsssZwLdIWs3mUeVTVNepnaX+jnHwzBG7bMyZH67VFuJihbR7rVeKLR0FOgFJ8N8gSt9r9yDy81VdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HB70M0dRWFpQ7A2yTFpp868CS2mYjHVx87+/7U3MDiA=;
 b=bdeYyBBzVu+McyT/J2cyTzweGu5dwh62ONrnQzm+rfkMEVCH0JJyAOlJxNrNEK4sNCdcxIKls4KpHHjbh+6mNw0bJontSy8DdKXlQU8wKtlXo/sJ8uncoZZ7yxhDGgeF7Gh2kYpQZD0UAUVetPjZYx5BFpAiZYJWxPeMVCOqSHOGrKwe8T2qphLEF5NbhrdSHy77VOs1F425YXYoYhIbTfqAbkZLE7fEgqn/hU+QriZ25e3nte0s4mzPQZmxtB33G4Pmx95PxFxU7BfFzI9Ze79HgkL9zzSvMIgOBTCi1RenGwQbl0yfGcQd4/4J/WvOo6Nl5R1qwzJRbgCYsMuIzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HB70M0dRWFpQ7A2yTFpp868CS2mYjHVx87+/7U3MDiA=;
 b=XHYEtpTWLC/yl6aIRUwzlloC17vdrEPNG8LK+4PA4aH80QM/cLA1GNhWoCAYyYfpwvbmHrYS4pY/uWGhAt3VK3YwEAJM1CHHxPASct6+W8ccUUPasAJ5X5xZMeasNme+dE+oWWOEBWwFXc1tLeK77LWVW63MKrGdGdcAJvNQlzM=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6397.eurprd05.prod.outlook.com (20.179.25.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.15; Mon, 6 Jan 2020 23:36:27 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2602.015; Mon, 6 Jan 2020
 23:36:27 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR05CA0090.namprd05.prod.outlook.com (2603:10b6:a03:e0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2623.3 via Frontend Transport; Mon, 6 Jan 2020 23:36:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 3/7] net/mlx5: Move devlink registration before interfaces load
Thread-Topic: [net 3/7] net/mlx5: Move devlink registration before interfaces
 load
Thread-Index: AQHVxOodMbCEOOnP80ewNovGzZ+Akw==
Date:   Mon, 6 Jan 2020 23:36:27 +0000
Message-ID: <20200106233248.58700-4-saeedm@mellanox.com>
References: <20200106233248.58700-1-saeedm@mellanox.com>
In-Reply-To: <20200106233248.58700-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0090.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: aa70a7bd-6758-4165-635a-08d793013fd5
x-ms-traffictypediagnostic: VI1PR05MB6397:|VI1PR05MB6397:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB639796D811AC0DAD5976B207BE3C0@VI1PR05MB6397.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:257;
x-forefront-prvs: 0274272F87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(189003)(199004)(4326008)(5660300002)(2616005)(956004)(6916009)(54906003)(8936002)(478600001)(6512007)(26005)(107886003)(81166006)(8676002)(71200400001)(81156014)(64756008)(66946007)(66446008)(66476007)(66556008)(52116002)(6486002)(6506007)(1076003)(86362001)(316002)(36756003)(16526019)(2906002)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6397;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7NWFOs1YPg6b76AO3tHgZcLFil9IssqWZskfLGnJmYG1ebmvliqVWc23cKYgwZaFJwkm/Fv+MsZG84L+WxBRdAQttYZcyTGuHturDwIyoQ8JeFKX+CEocqMAttFhTw/YzRRd5QBsqLJkrt23Sk2J4/FK2KmmWBrU4GwoStjvwIuzNjzj559oOF+gykx3UGh8Iy6G2bzg/owg/CQaphq4LkdzhnpV+ewodIV9GDG4K9WAPbFSWqb7Bi04n/KyxR7OJdyWx4nK2mHXSG6oY3RIgBAMviQSw85wEJMi946eypqFLcHjEW/oejggXfNM2ndX9PXzjDVMWBs/8eaFwDcpkDxoYU55N5WYIKuzmQrWr/Kq3AmCJz1M0hTmd/igpltJTuIKBmLTA/zBb7VbiHIq5SQm0um9b2xX1jjhMv5KNLFJJqsJt5lWhHUg9bHz6R2fu0vwaGqvY0E3Uw0/CjMayLZxz0cgAoazxMO8N1rP1bVbuRxuaILfzpt67u047JtA/KW44LNEXzjxdWw8z8J63jriDPTYyh1SBP14b8S0EKQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa70a7bd-6758-4165-635a-08d793013fd5
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jan 2020 23:36:27.4762
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zwBF0c3ZIDGnxm3YyLf0eAjhAge0LaLdWUvi4Pj0ViFa8AD5+HDJR1e7gJ83MaH+TVw+Y8xFwjdJdGwp8dWjxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6397
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

Register devlink before interfaces are added.
This will allow interfaces to use devlink while initalizing. For example,
call mlx5_is_roce_enabled.

Fixes: aba25279c100 ("net/mlx5e: Add TX reporter support")
Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/e=
thernet/mellanox/mlx5/core/main.c
index 173e2c12e1c7..cf7b8da0f010 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1193,6 +1193,12 @@ int mlx5_load_one(struct mlx5_core_dev *dev, bool bo=
ot)
 	if (err)
 		goto err_load;
=20
+	if (boot) {
+		err =3D mlx5_devlink_register(priv_to_devlink(dev), dev->device);
+		if (err)
+			goto err_devlink_reg;
+	}
+
 	if (mlx5_device_registered(dev)) {
 		mlx5_attach_device(dev);
 	} else {
@@ -1210,6 +1216,9 @@ int mlx5_load_one(struct mlx5_core_dev *dev, bool boo=
t)
 	return err;
=20
 err_reg_dev:
+	if (boot)
+		mlx5_devlink_unregister(priv_to_devlink(dev));
+err_devlink_reg:
 	mlx5_unload(dev);
 err_load:
 	if (boot)
@@ -1347,10 +1356,6 @@ static int init_one(struct pci_dev *pdev, const stru=
ct pci_device_id *id)
=20
 	request_module_nowait(MLX5_IB_MOD);
=20
-	err =3D mlx5_devlink_register(devlink, &pdev->dev);
-	if (err)
-		goto clean_load;
-
 	err =3D mlx5_crdump_enable(dev);
 	if (err)
 		dev_err(&pdev->dev, "mlx5_crdump_enable failed with error code %d\n", er=
r);
@@ -1358,9 +1363,6 @@ static int init_one(struct pci_dev *pdev, const struc=
t pci_device_id *id)
 	pci_save_state(pdev);
 	return 0;
=20
-clean_load:
-	mlx5_unload_one(dev, true);
-
 err_load_one:
 	mlx5_pci_close(dev);
 pci_init_err:
--=20
2.24.1

