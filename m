Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EED8D86B63
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 22:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404827AbfHHUWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 16:22:20 -0400
Received: from mail-eopbgr60084.outbound.protection.outlook.com ([40.107.6.84]:35264
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404169AbfHHUWS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 16:22:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XxRXyKJijEVKxEy5KCiBYf+AenSkjHCJbmG0jkDB4H1XZR8FiyQTiD9n+BNrwbaFeqjYMhH+T+peMWpRbfAINBLbOSYSaYN+fqbWPWOt4WaU4vRxhNLIoL4nsso05Y2vJdXvyZoUYBxk2qppPDuuCMToG/LDw8aMcUqU/2zX+DqJTRXx6NiHENf+VkKptBUN6+movUwj60wwsk1UggiQsyuqWVGqwGqBrIr2Tnm4SJy4TdMTv8x2DVkiumvaWegd6y/ba4h8QkWuPJc8v6spLgdRZKnsG7XXb3YWsIPac/sxiUjCWbfjvr///FKQwRo/zxjeIUYzyjd7YXOTJe1V9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9YdiDtOSF0hPR/sH9fzKl2d8hrN9WRrSJ2rH0h+VVk0=;
 b=cYvoVu+ovyJa1wWSX6gks9z7mLLy3EAlMTfXWiJ4D4jKipOUf0Q/RHF+h0+UBW4GNa1Lb0+5U/1QFcW4cObWO9z1TMegqauVkNGMwBAXyadwW/xuHh5zGiyuwm3cN4G/CAN4+BWPRM67hV2MrxRWjFxmQRR89wiGCbSbadUfokbyKEYOwSyBDblqQR/0lBSLGvuCub4cU2zDyiYtaVK/ElN5FJPgXmdC82LrA4VbLVbBI/wU2e70esvYaR5ed0v8sYpy1+70IJEEThdysLXiH8YMYi5VNk/6O8FIxWQYYjAGT3l00sXMGD/tan9THIyIZ2r6M/NyiflyeP5x5qlJ7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9YdiDtOSF0hPR/sH9fzKl2d8hrN9WRrSJ2rH0h+VVk0=;
 b=AYZPRzZ9Gr9cEy+veNvGcQz+lmiG4HZCbUYsUfzKX/Uis+KJdifA1b/LOxcp6mRHRsUM+/s6/9XXI4m+ecYUNtS95TdcQ4lhnmWjlCr4qLEQGcT31cSZ+itJSRfXam9vCbP39bxFsLLzTiuR2DXe8IhP0sndr5YJu7Ld6XNiQAs=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2257.eurprd05.prod.outlook.com (10.165.45.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Thu, 8 Aug 2019 20:22:10 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 20:22:10 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 06/12] net/mlx5: kTLS, Fix wrong TIS opmod constants
Thread-Topic: [net 06/12] net/mlx5: kTLS, Fix wrong TIS opmod constants
Thread-Index: AQHVTib0PLWejh3d30+OMpYFDiip6A==
Date:   Thu, 8 Aug 2019 20:22:09 +0000
Message-ID: <20190808202025.11303-7-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 2867f0bc-0deb-467c-d196-08d71c3e1708
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2257;
x-ms-traffictypediagnostic: AM4PR0501MB2257:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2257A5817532C1F066D1E2CDBED70@AM4PR0501MB2257.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(189003)(199004)(53936002)(66556008)(50226002)(66946007)(64756008)(66446008)(2906002)(107886003)(66476007)(6512007)(6916009)(81166006)(6486002)(4744005)(2616005)(11346002)(1076003)(256004)(476003)(486006)(446003)(71190400001)(71200400001)(6436002)(81156014)(86362001)(305945005)(76176011)(7736002)(52116002)(478600001)(36756003)(102836004)(6506007)(386003)(54906003)(99286004)(3846002)(5660300002)(6116002)(66066001)(4326008)(26005)(316002)(8676002)(25786009)(8936002)(14454004)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2257;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0Zd91q9j+/D7BJuyLkzZxSOt1J5Wjd5xKIBkO/t6kkcxVEOKLz3J8PDEqP/2LzZ6LVyo+7ZCFOvH1JZJQRTIgX1e2euXI93nBvmIxfnu0DU9wF78dQsF2DJ/Acmtd5jDhO3ED7mB3gNGN4QputSrsJR0a94ECkiy9Vgk50lYlfgsaRTPFHZAOmXED8ILoXCrBDShHjkcHajhhy8waKB5hHS767BDBN+3gGZ566wPnmRN+9G6raOazKWaIaiSPyx8LrpTfyOpbNA9lKyBGZvZmxL797rrKBGduaKKrbCb3D3289EvYEFzmogYmsevYXDtbDRYuN2qI3JOGV5cw0OlpLGt+XciE4EK4/nUSccsw2fO6uKtwxTpltdCApW/H5Zt70nGp+URFCrhWu3D9R5xBPEr8doDKGhZds4Os2ATW5c=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2867f0bc-0deb-467c-d196-08d71c3e1708
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 20:22:09.9706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7k5XQ1EW0lFr71iZ13J/AC17z4MBYjQ9w1dI9czCS1R9X7+tkWeftVNJj0plnlqilDC9vm19Vfu//ddRviYSJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2257
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Fix the used constants for TLS TIS opmods, per the HW specification.

Fixes: a12ff35e0fb7 ("net/mlx5: Introduce TLS TX offload hardware bits and =
structures")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/device.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index ce9839c8bc1a..c2f056b5766d 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -446,11 +446,11 @@ enum {
 };
=20
 enum {
-	MLX5_OPC_MOD_TLS_TIS_STATIC_PARAMS =3D 0x20,
+	MLX5_OPC_MOD_TLS_TIS_STATIC_PARAMS =3D 0x1,
 };
=20
 enum {
-	MLX5_OPC_MOD_TLS_TIS_PROGRESS_PARAMS =3D 0x20,
+	MLX5_OPC_MOD_TLS_TIS_PROGRESS_PARAMS =3D 0x1,
 };
=20
 enum {
--=20
2.21.0

