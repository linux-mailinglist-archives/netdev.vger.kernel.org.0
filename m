Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F97686B62
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 22:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404819AbfHHUWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 16:22:17 -0400
Received: from mail-eopbgr60084.outbound.protection.outlook.com ([40.107.6.84]:35264
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404800AbfHHUWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 16:22:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BwSOXP3whKnUuihPGABdwZ55HgBaCu0PJAv8WHaTIkS/p3Sk8Tv7QWJ3sh9L3YkVr41ueJK6U11NYDgUPeItjD/JJSueoZ0gaDxIiWdgZG43tBTJrUPySfTZ/6g6AWmxqu5afTDlwm4Cr3lyT/QNXTHL+Mm/8B0Fq8ndOExm19JkBw67Q8H6PR2Fh84mhH5R87iwZOM5ackPC5pIrihpDwKYtbdS/0y+0lP962qbeg9z2eOrYjpzGnMZlgaAidmIaYA8AYD+3dYYZUGDbZmlbxiL/iIEULuVLCssBxIIYlmJghRkHERXDNFxOAUkK6+AzRHucQTWqaJsa3RWIJ34RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qaV+giQm8GF43lSZbzkQIGdWAzLWKp+5ydRCqHjLpw=;
 b=QNHBvwlH1PXqV6sWSGkColttSSZgKmqwiPjwQzmErcSfiV2Cow0lrwzUZyjoSo5ijc4VpPLdsftCmT6fIwag2hXT1OlDx9S072j/OqjcTKN5CLIHEkxDaoCClLZwJvXwBvVH515G3GKd2UgtaZUY7aJAjqgrM1gD3RvTeyeweKb2orHrv80/tBbexW1QjyEcwv0DR3vKNw2pL/Zpd+2slKrRewKS0NqXcRJm08B3otXKo6xgguLI0z+J3PhPzSj4n7x0oIdTAP6d+rIiv/S6S4R5bO1hLaUhfFWeIs2RL4ka2aOJbdE1bP66MSnKkzdzPkBxkpVblVLNnKDvfYw++Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qaV+giQm8GF43lSZbzkQIGdWAzLWKp+5ydRCqHjLpw=;
 b=J/4qk5sFhjx0Nsh8dX4LSgPNXTGajdLsrQrJsEFXfVpXEg5tgvNGLQqO43iTE48GPedNQYGGONo9N7ODljEEDYwNM/a/7GxqlR+OPI3rV6j1IyidmbS0JFYiVNYBbV67Eeqg6zi+PsXINGs4E9lumeVH54FwA3L646wNRECazUk=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2257.eurprd05.prod.outlook.com (10.165.45.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Thu, 8 Aug 2019 20:22:08 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 20:22:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 05/12] net/mlx5: crypto, Fix wrong offset in encryption key
 command
Thread-Topic: [net 05/12] net/mlx5: crypto, Fix wrong offset in encryption key
 command
Thread-Index: AQHVTibz6QUwiDjUZkGVR9tj6EIbPQ==
Date:   Thu, 8 Aug 2019 20:22:08 +0000
Message-ID: <20190808202025.11303-6-saeedm@mellanox.com>
References: <20190808202025.11303-1-saeedm@mellanox.com>
In-Reply-To: <20190808202025.11303-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR08CA0067.namprd08.prod.outlook.com
 (2603:10b6:a03:117::44) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c368a2b-38b1-42fd-ee29-08d71c3e15e9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2257;
x-ms-traffictypediagnostic: AM4PR0501MB2257:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2257B7842C65F07D86A09641BED70@AM4PR0501MB2257.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(189003)(199004)(53936002)(66556008)(50226002)(66946007)(64756008)(66446008)(2906002)(107886003)(66476007)(6512007)(6916009)(81166006)(6486002)(4744005)(2616005)(11346002)(1076003)(256004)(476003)(486006)(446003)(71190400001)(71200400001)(6436002)(81156014)(86362001)(305945005)(76176011)(7736002)(52116002)(478600001)(36756003)(102836004)(6506007)(386003)(54906003)(99286004)(3846002)(5660300002)(6116002)(66066001)(4326008)(26005)(316002)(8676002)(25786009)(8936002)(14454004)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2257;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qaSDjvYbjEul0rM0rnpUZU4pIIwYgqTSRvPvS68Z7xO8cwM6bp+Dfd/n6XX2XsGimcSgZ2VZTDJJ6ZuahwaWvguirb8IzLFwm6zgDSGUz3abkDo2rwSU1cnT+BLJDPRB6UkE3vbgZNjd3OVS2bfXbHpeK99vPdL1L34bPwGGmXqS89d5d3/XumdYbcsDGsmFxArypAZc/bTaNmTrs9MkFH9pSNfF9kYVa/UphruEFEyLQ3YSmxDsPD29IrVRi6xnAIkb+YRafykHA9I6Bhm0J5iv+fZjuvmqaxSIIcMpfW0VvOYxvayiTxAX9r65m/O8X9OiWLrZ4TkGy2SfiP8/3PLHSjpWuqAGPFseQEVk3NtSzRfAURCbeA+ImoaAMYt1MGm/7ydM7JOMzIgyFkBX6T9daP6/6+zHNalNDRoFeb4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c368a2b-38b1-42fd-ee29-08d71c3e15e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 20:22:08.1665
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5dxSGiPy4dhon/vXEarRdAapsf56VB04KQv4yFK0C3kVxLT7hO0ncTxYkg4nJRn4fhpMZCEf+BBbrhjdei9osA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2257
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Fix the 128b key offset in key encryption key creation command,
per the HW specification.

Fixes: 45d3b55dc665 ("net/mlx5: Add crypto library to support create/destro=
y encryption key")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c b/drivers=
/net/ethernet/mellanox/mlx5/core/lib/crypto.c
index ea9ee88491e5..ea1d4d26ece0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c
@@ -27,6 +27,7 @@ int mlx5_create_encryption_key(struct mlx5_core_dev *mdev=
,
 	case 128:
 		general_obj_key_size =3D
 			MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_128;
+		key_p +=3D sz_bytes;
 		break;
 	case 256:
 		general_obj_key_size =3D
--=20
2.21.0

