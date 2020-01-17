Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16B2D14008D
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 01:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388409AbgAQAH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 19:07:29 -0500
Received: from mail-eopbgr80075.outbound.protection.outlook.com ([40.107.8.75]:16082
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388119AbgAQAHX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 19:07:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CdePvpCuA9Ri04TDMx1tkDz5Jr2JBCPypZ85VUF3PKrWNGqzEaGV2wttwk2YhvzWRuZ66ZXwZH1lNntDjUfv3C8IqkLl2sGZxzAWYOdNQKewbI69xUAARGpL9K3OjOMosRnY4bV70XL5JxQTEJ4tcQpHLyC0XDJUR3V+mUoFHCZ+RHzsEHuFmq5eyP2tS+SmsePhvNmpQE+ouvwssWrtJyhy2Qog1+3XGVdFKD+wSbQQRLQutIMthGerBCJ+m8SC5uhKiGQyh7JXCpz031WjJEfMq1LQCfMRkRk+O9Xh7NahDaikFydzXLT2Jgi9G3YpVPeN7dTtcPkcjQhcojlDig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERWzJpqceJi9jVD1OI74TidgfgAxTcx78QOFiE9hv3A=;
 b=gKk29jQ9RE6gpPQ0RopWemmX7BVoGms+DlNoeCpwQxlcAk2Y8f+cLtUAWYqMmYNg47am0aLB+Y070sbqg/2pq73SoipnYp4Ca2rcB6F4bjJI+zUR2oLIeXPm+Ze63IDKSKeWwHWWywnyyj9aI5Z0SbVNU/2KvGCjUgOxHJ0tznaJNiXUxLIm5+hXo4tbCZK0jEv/KKmWbPy67Yh2VFM6eW0gNiXYC3Uh6TrnYj+rwLzgPDRZ1NY3clqQ+HbiQEQ42GuShO+zh4K+MRfDxIe5KngG8ftRY1JWD6Oaharu4bf+1OyQVhz0L7CDvqumEFHVy3M0Qw1YFiiiYnGSE3QIcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ERWzJpqceJi9jVD1OI74TidgfgAxTcx78QOFiE9hv3A=;
 b=Pk+nAXp+oNqXLdDBgmtr1kTAK1NGMBSm9jPU1Cwashq3StBgrVqXwSUObIvlOnMTIAwu3lHVtRuhHQl8Vgnz7uUx2PXONmyqBxfp3q3irkTF3IKc22QMkujXioZfi2ZgHKrhB2i7snZju/BMLq3c/JuXmi80M4V32mRiARQHnwk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6080.eurprd05.prod.outlook.com (20.178.125.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.12; Fri, 17 Jan 2020 00:07:21 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.015; Fri, 17 Jan 2020
 00:07:20 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR03CA0003.namprd03.prod.outlook.com (2603:10b6:a02:a8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Fri, 17 Jan 2020 00:07:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 13/16] net/mlx5: ft: Use getter function to get ft chain
Thread-Topic: [net-next 13/16] net/mlx5: ft: Use getter function to get ft
 chain
Thread-Index: AQHVzMoWo9rjmi+E4UuV3h2CgAad7w==
Date:   Fri, 17 Jan 2020 00:07:20 +0000
Message-ID: <20200117000619.696775-14-saeedm@mellanox.com>
References: <20200117000619.696775-1-saeedm@mellanox.com>
In-Reply-To: <20200117000619.696775-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::16) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ce3fffbb-f003-49ab-c7dd-08d79ae138a0
x-ms-traffictypediagnostic: VI1PR05MB6080:|VI1PR05MB6080:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB60808B8B1904E8EA6F2BD69ABE310@VI1PR05MB6080.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(366004)(39860400002)(136003)(189003)(199004)(186003)(26005)(66556008)(1076003)(16526019)(66476007)(8936002)(107886003)(6506007)(2616005)(956004)(66946007)(52116002)(66446008)(6486002)(64756008)(508600001)(36756003)(71200400001)(6666004)(86362001)(4326008)(5660300002)(110136005)(8676002)(81156014)(316002)(2906002)(54906003)(6512007)(81166006)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6080;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e2l9IZrQ7hHUyXuXy5C936hm2K4+Y+CbX93nzqTcUdxfP3C+4QpplrGzz5FIXRmaEedc6kZ3HbhoOv4LRIcKYFfqCFtnRO7DZ+hr4+kJY8vJp2KX1OVG6qO2FTK9La1Yu/VGrMEMCQSrrhIwQ/SmaAczFoeYt1uRjvRir8i2u8nf5wRaQp6bFk40ytYntXk1HkQonZ4whH9MAzb+qPiObvKMFRqH2dnfAdJnc+z8Se6s/P5NYmIWb3LOIkho2bemwzJMcqj0Pt12ZV7gdjdpuxq8yWJgvdrbTFzsTt6EH5NlaVa3qnXX8Qqkac/eu1GeieSQjK7Y4oOqjKLblrr59FvYa+RiTQNfhCzbHIPX6NT7FeLyltkEKcTwPBRtPPNYOW5dC/eSKQVRM96WfXCBgooWDZVEdBdVAeJXBmPOBgbQs/YT3GCrvyJv7Db6LMsAwCaqpJWHJbL8pr0mJMGtQJNtZ37k0M+Vu5SP61Uc8bGh/qf0UJ1G7R9xu5m4CJe5QMpS5vJXSOWULCmX2041Mp5kALBq4cI4VIwxl9ir3xc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce3fffbb-f003-49ab-c7dd-08d79ae138a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 00:07:20.8582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LR3NuhxuoMdhujWMAGq4dQpOpHwatdK5Ik8xORpp4lyXvoIM3dV+d+8Mw5jhHsGiRhYB4ClXbTKiJhGybcYCdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6080
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

FT chain is defined as the next chain after tc.

To prepare for next patches that will increase the number of tc
chains available at runtime, use a getter function to get this
value.

The define is still used in static fs_core allocation,
to calculate the number of chains. This static allocation
will be used if the relevant capabilities won't be available
to support dynamic chains.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c           | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h          | 3 +++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 5 +++++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index f175cb24bb67..d85b56452ee1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1268,7 +1268,7 @@ static int mlx5e_rep_setup_ft_cb(enum tc_setup_type t=
ype, void *type_data,
 		 * reserved ft chain.
 		 */
 		memcpy(&cls_flower, f, sizeof(*f));
-		cls_flower.common.chain_index =3D FDB_FT_CHAIN;
+		cls_flower.common.chain_index =3D mlx5_eswitch_get_ft_chain(esw);
 		err =3D mlx5e_rep_setup_tc_cls_flower(priv, &cls_flower, flags);
 		memcpy(&f->stats, &cls_flower.stats, sizeof(f->stats));
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.h
index ffcff3ba3701..69ff3031d1c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -364,6 +364,9 @@ mlx5_eswitch_get_prio_range(struct mlx5_eswitch *esw);
 u32
 mlx5_eswitch_get_chain_range(struct mlx5_eswitch *esw);
=20
+unsigned int
+mlx5_eswitch_get_ft_chain(struct mlx5_eswitch *esw);
+
 struct mlx5_flow_handle *
 mlx5_eswitch_create_vport_rx_rule(struct mlx5_eswitch *esw, u16 vport,
 				  struct mlx5_flow_destination *dest);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 4b0d992263b1..81bafd4b44bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -80,6 +80,11 @@ u32 mlx5_eswitch_get_chain_range(struct mlx5_eswitch *es=
w)
 	return 0;
 }
=20
+u32 mlx5_eswitch_get_ft_chain(struct mlx5_eswitch *esw)
+{
+	return mlx5_eswitch_get_chain_range(esw) + 1;
+}
+
 u16 mlx5_eswitch_get_prio_range(struct mlx5_eswitch *esw)
 {
 	if (esw->fdb_table.flags & ESW_FDB_CHAINS_AND_PRIOS_SUPPORTED)
--=20
2.24.1

