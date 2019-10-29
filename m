Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86964E93E1
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfJ2XqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:46:21 -0400
Received: from mail-eopbgr40044.outbound.protection.outlook.com ([40.107.4.44]:4154
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725974AbfJ2XqU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 19:46:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WV99RWT6t/se2bdYYKHfBK7ENmimsGnKhs6ltz2/kavzMWY/y6mx6NiPmkAeFcNNsB007DTAZRl1MCd829dPvCMYRgwT0sAZD4sor925ZcFaSb/Z6o95J2h8yw9scV51BI4rg94Q3Z/KxHF1A8AuzFdOD6GPmVm7Vu3Aphm4TxjiNkD4CanME+lMGl+2v20wKERHVf6TU1cebNacwJ29RqQMqO8tsASt3qpVfWAwAc8eHaXbz2+nhdYFvZes4UU7Tb7pKRFqbr2JKIhpS9Ev4/YGPUl5/cqtnRcpigc4PgE8AUlwDC3pWejtiQgQTaQsv16bMVgh6/F4Pgk/jhOztA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gx9JggxGQ/grkc30vUml1DrHpgIfT/GVo/gZ3P5eUOs=;
 b=PpavezhSR1JZdV1TjR0gPRRFCD8BFvrnzBPbI199pV3SdaI5KuDfMEH2jNr+bFxi8By8zZsP3y1Cuae3m1bgF9Pjm5wt+t9cEFreBR+1dn55C4nmtKwtVMpBCf+LHaisvo/p+9AYSDqHPaLw5VM7C89MBJMayJGohiUu3i/ru4bG3Du9MNtDEDUXXp+GD+XOCMvjiAdJb9JFr3/NRapR9up+I3/1C87vdI3UXlg3ZevbZF3VmxnhbnB3IbVqcXdgrjwoLmyYKoIBbEoygUZf6S7tAw7JAhVeDTBQiIW6A4y1zAyCBbFgk36ua5b/1Gj+N2bAmi4QVmSyij4tdHquQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gx9JggxGQ/grkc30vUml1DrHpgIfT/GVo/gZ3P5eUOs=;
 b=VAx/uuCvJJJh6zKe1+dQNgRLBjspQMOmo2s83M9Mx9a9x0QayFsmCIK4+5/Dn0ujf4hWQAJIOmer3+nR/Xo86RxlWTTCYFhKPDjDxo3dPSRUZlJsoQucKOZ2hCjwSLwVt8hl10clp5m/R4lqirzYz7T1k8zK0UrG9CWo2wmHeVk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6157.eurprd05.prod.outlook.com (20.178.123.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Tue, 29 Oct 2019 23:46:14 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Tue, 29 Oct 2019
 23:46:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 11/11] net/mlx5e: Initialize on stack link modes bitmap
Thread-Topic: [net V2 11/11] net/mlx5e: Initialize on stack link modes bitmap
Thread-Index: AQHVjrMM3qwiZNMFMEWJa7PMbfL1fw==
Date:   Tue, 29 Oct 2019 23:46:14 +0000
Message-ID: <20191029234526.3145-12-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 3d276423-afa4-4473-6e2f-08d75cca2f3e
x-ms-traffictypediagnostic: VI1PR05MB6157:|VI1PR05MB6157:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6157596F4FFB0FE989E0D570BE610@VI1PR05MB6157.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(199004)(189003)(6486002)(486006)(4326008)(2616005)(476003)(6512007)(66556008)(71200400001)(66446008)(66066001)(11346002)(6116002)(8676002)(54906003)(2906002)(7736002)(316002)(6916009)(81166006)(81156014)(478600001)(107886003)(8936002)(50226002)(6436002)(1076003)(446003)(25786009)(36756003)(3846002)(14454004)(71190400001)(86362001)(305945005)(19627235002)(14444005)(99286004)(256004)(26005)(6506007)(386003)(66476007)(76176011)(52116002)(66946007)(102836004)(186003)(64756008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6157;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2WU22FpcjisQrcQlyyhgOQWXb2EzDJTQmoDq6HOKtyjlVoS53AXnNZm3USbiLRzGS0zgEt+hfH1PFL3bRPC8RkVocckSz4Jc8w5Pq3M+eGuxu2UayZc/8d+ZFsLw7mpnVX1qrDwe33x962D17GuZpzuwex9rdhMkM8yoLCukCam3DeYDzHKOD/ALmQVCGc4pm+OdaUI7shuAelqnyQmkgrTrf8pn7R0exKMJvPmFe+z1ZF8m8K6gbNAmJwdSoQSyUwL4Nmkw62JQFrlskweqsvtgma8QO/SrTUVL43n1o+B3uuTevdADZuPRV7bVZu3lDn8YWAPOnL50fOgVBD4qiCcYW+vi+h1dQRLrxz5WpCHTKYgTFQ7l6i9cq8/an7CyWh8gfz3VAL2Zcu543RrLYphXeeKgFpRsmowWO9NPzj/T1CSvRUNYeQR2xqQK2mSO
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d276423-afa4-4473-6e2f-08d75cca2f3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 23:46:14.5891
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xOBZFCgPr6eTZOx9KAuon+7nlgS+VVxdUthuhZaT10d1ufE5N6bINycc1TmrpXT7rQUzNuOaIpOKY3pNE5JAxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Initialize link modes bitmap on stack before using it, otherwise the
outcome of ethtool set link ksettings might have unexpected values.

Fixes: 4b95840a6ced ("net/mlx5e: Fix matching of speed to PRM link modes")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index c5a9c20d7f00..327c93a7bd55 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1021,7 +1021,7 @@ static bool ext_link_mode_requested(const unsigned lo=
ng *adver)
 {
 #define MLX5E_MIN_PTYS_EXT_LINK_MODE_BIT ETHTOOL_LINK_MODE_50000baseKR_Ful=
l_BIT
 	int size =3D __ETHTOOL_LINK_MODE_MASK_NBITS - MLX5E_MIN_PTYS_EXT_LINK_MOD=
E_BIT;
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(modes);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(modes) =3D {0,};
=20
 	bitmap_set(modes, MLX5E_MIN_PTYS_EXT_LINK_MODE_BIT, size);
 	return bitmap_intersects(modes, adver, __ETHTOOL_LINK_MODE_MASK_NBITS);
--=20
2.21.0

