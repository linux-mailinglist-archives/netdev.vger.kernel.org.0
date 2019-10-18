Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16021DCF6A
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 21:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506000AbfJRTjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 15:39:19 -0400
Received: from mail-eopbgr80087.outbound.protection.outlook.com ([40.107.8.87]:26853
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2505992AbfJRTjS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 15:39:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bEJRaSqN8lCeic/n8yGzleAh0Uyn+uxRIHSMP4g3fZ/Kr3JpXpfiAH2itenejavZpj8kI3ChJ6lmGaOlf3x+D0WkQAukEt0Q/qm88YliVk0yqGR9fDQ/bAdHSniGC/0zQ2qrPAylUqBoLNPltVKrP1jBtL0ipqI4yrLRuomCa9M1aNbQY66qvG8YXEIhzZBnUdg85bJFCoKrW8A9WFj4NqrFAWGs2EVqRhtKibo95hQNGl/7hLjyum9sP+C9siDVRMotb94OroeZanuPAbuVIsmlZNDcfGznmEXNmYIx2yCoMThqiwxyZSQi0v0rB+xEhsjPYbcge5IGCFG3dMFvaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I+28Sx47sHsRtr08V4L7ks2zYWtoL5c2K6gncul0TS8=;
 b=luvG1mtYnGq+EfBBFNUgU2Muft4radgP9ruvhUp/7nkHlb4u7EXjrSeoDL9w+t8R3AxCPWMgZyULeaGNqIcBABwHItPqpwT3g4/F5Yiz7Lj7lmXhT4qCR7oMG7t01jqOEdsMDl5etjacjJ6euT0mKyaD4x3xkU8x8gsEgLvY3EtvDDeqwBGW4RAJv5sPNDEHiApLRl60LRC1rAkXt6aQtmfJveCOrKyTOvjKAP0+IptZSIGTOHSaRkU9sMis5+tIYrmrGW0Srf2daXW6rqSUXFtO1E3t/pNkbZzKgjruTKdDHiq0nwf+64SJYT+Gq/3fD1HFa2DzKftEYMvsHwi2rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I+28Sx47sHsRtr08V4L7ks2zYWtoL5c2K6gncul0TS8=;
 b=cJFuxOpR/4QpF4nZEwsupGXyjFSCUpq2kttJD60gtsWIDnHAZdUpXkLxGsv53WcAyqKTS5nzqQDiI6LuZmO4r9hYpSjihkfJQd+A8zpABNW5FOhO3CAMz93W0n0HtStG0hARRhPlRuUvIbpZ8+rNbZJWJdbqP6Pwiu58etfcSi8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0392.eurprd05.prod.outlook.com (52.133.247.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Fri, 18 Oct 2019 19:38:30 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 19:38:30 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 15/15] net/mlx5: fix memory leak in mlx5_fw_fatal_reporter_dump
Thread-Topic: [net 15/15] net/mlx5: fix memory leak in
 mlx5_fw_fatal_reporter_dump
Thread-Index: AQHVheueXRbg6SufGEKfxc8n60dXMw==
Date:   Fri, 18 Oct 2019 19:38:29 +0000
Message-ID: <20191018193737.13959-16-saeedm@mellanox.com>
References: <20191018193737.13959-1-saeedm@mellanox.com>
In-Reply-To: <20191018193737.13959-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR07CA0079.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::20) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0eb99a6-6854-404f-e494-08d75402c0ae
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1SPR01MB0392:|VI1SPR01MB0392:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB03928C8C50023CC280FD5039BE6C0@VI1SPR01MB0392.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:517;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(199004)(189003)(86362001)(5660300002)(186003)(6436002)(102836004)(446003)(486006)(6506007)(71200400001)(71190400001)(14454004)(2616005)(11346002)(2906002)(26005)(476003)(6512007)(8936002)(81166006)(81156014)(6916009)(1076003)(50226002)(107886003)(8676002)(36756003)(6486002)(256004)(14444005)(478600001)(386003)(66066001)(64756008)(66946007)(66556008)(66476007)(99286004)(66446008)(4326008)(316002)(54906003)(3846002)(6116002)(25786009)(52116002)(305945005)(76176011)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0392;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ByF+pmYNtAC4ooYrKILGMzd6g2mVjMhnjK1g0Qx1ZS1HJm5bGzCKJIoAf+INN9Potjmd++KVHUfddAz9oQq8w07OfX60LiYGs4mVZR7HpCPYl/kX4xRgiL5bjBVpnlVFC/kCvw/+7vbcKIxsL4jf5MAI5erS4OtdA+WReKCyBHJeUeTnKZ4zPWGMlN/I9C0eWRYXrPxydl9phe6qv4lv8JizfauT34iLZy4i1cpdtmL5WRShzBK5w3VUFsnjpByOT0vaVaUikY0IqDwmeftCRo/JohLlReSa1K1m/ELjz2GjpF4YDvfdPYHyGiJoael+8s0oxyxM1kplV6cgPgmGIPCKnKjMU4WGQNhqxmxeBqC+MkrfgjN0udKtd3MqwQEHbBj8tCfg7ybOOjtT/0FknJrIfnjCA5UusmaCfBjMgaCVIn8WPDFH0uXCY8YeWXrT
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0eb99a6-6854-404f-e494-08d75402c0ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 19:38:29.9487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ypgPKWlKCFirDJjIbE3++J5CnCMcsy6h6g/qbBAG64VgOdy9Kcxe9DtDNm1AbrTjCk7JZ1HkExAFqyDeR/fZrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0392
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

In mlx5_fw_fatal_reporter_dump if mlx5_crdump_collect fails the
allocated memory for cr_data must be released otherwise there will be
memory leak. To fix this, this commit changes the return instruction
into goto error handling.

Fixes: 9b1f29823605 ("net/mlx5: Add support for FW fatal reporter dump")
Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net=
/ethernet/mellanox/mlx5/core/health.c
index d685122d9ff7..c07f3154437c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -572,7 +572,7 @@ mlx5_fw_fatal_reporter_dump(struct devlink_health_repor=
ter *reporter,
 		return -ENOMEM;
 	err =3D mlx5_crdump_collect(dev, cr_data);
 	if (err)
-		return err;
+		goto free_data;
=20
 	if (priv_ctx) {
 		struct mlx5_fw_reporter_ctx *fw_reporter_ctx =3D priv_ctx;
--=20
2.21.0

