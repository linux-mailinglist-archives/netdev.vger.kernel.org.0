Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28742AAE0D
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 23:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390884AbfIEVvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 17:51:13 -0400
Received: from mail-eopbgr150049.outbound.protection.outlook.com ([40.107.15.49]:1505
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728769AbfIEVvM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 17:51:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l6t0tMmpIOf1tcJHIX3ZIv+CCH9wu+GaIT+thF0eepu9T9wWemsG9aKvMPvTzeG17yZlB0eXrU6ly8VhBd2bNag6LcK4UP7OgsWO9vPWFyNGIZwd6CFheBu8aFYYcksW7trQ8Fy2XCTjA9vb0JAhisLL7UOt5eDPcmnjud47S3pQ961V9KpJrZ5OAGcO5wvKmoeIZ2oXw3xErJpsA/zJnqfL2gblR85E7aP6ihyQH+FJnNtL5yfSsIEGXvbL27j4O0gRI0dyPb7O/ZcTHRPKJKsJWMN7kN8DNCov+OaTj7Om8rj/AYaFu/B9Fy4LuenPQQXuCDXI6QthxVMnLxJKLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1BwmCm/plx2SqlIxY9zcXsKRp4M1Ir0jKNjxQ8hJqY=;
 b=S1ekPpzGpRWchujqin85XD1Tt+k1BsR2qwYIFl5c1awBGAlJE4pvmmkg5IkAKjApt6AMvpiJa3aGACmjJiBRO4cEn20AyrqVDkvIUt9PG8Vb2iUfjHtyjgd20ZEy7jXelXYsaYRhXTCZqzx8lsitqWd2JrpMVDtEs9sQ2uH6MSWjzzvqitLRiruL7j4Uja7keSIDtACuWLnHaB86c1r1hak1nucBXKGRuMQIM0xWczNNrMi1EpC1D5swhEHyK2YvE+usCSoSvMhy4/51zJEeP8pVAupyNbr9hsw6QIm4k6KV9dxrA48iGPAqHuK02bqVtDCy+VjMq4HXxp89m2UWDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1BwmCm/plx2SqlIxY9zcXsKRp4M1Ir0jKNjxQ8hJqY=;
 b=W0RCqsGh0XAW8AmkIBVy44YGTJFrVpMlF2Wr8JwH9K3yLatO4mY0iCJM/SvVltgyKMOUx1v7mnK48DEkW5rn2AdZSEBWgxOLxQqj7FNU4o4WdAsmrU2ArclDNXy64vfQGsKacgp9/DyxfcsqaIZLULHOpuFOE4YE9COhdog5n/U=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2768.eurprd05.prod.outlook.com (10.172.81.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Thu, 5 Sep 2019 21:51:05 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 21:51:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        zhong jiang <zhongjiang@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/14] net/mlx5: Use PTR_ERR_OR_ZERO rather than its
 implementation
Thread-Topic: [net-next 07/14] net/mlx5: Use PTR_ERR_OR_ZERO rather than its
 implementation
Thread-Index: AQHVZDQEpsjAARtBmUWJ+Uqimx33Ug==
Date:   Thu, 5 Sep 2019 21:51:05 +0000
Message-ID: <20190905215034.22713-8-saeedm@mellanox.com>
References: <20190905215034.22713-1-saeedm@mellanox.com>
In-Reply-To: <20190905215034.22713-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0023.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::36) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 00750d6a-4fa5-4f90-7b49-08d7324b2704
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0501MB2768;
x-ms-traffictypediagnostic: VI1PR0501MB2768:|VI1PR0501MB2768:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB2768FD335F282E590EB36D09BEBB0@VI1PR0501MB2768.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:409;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(199004)(189003)(478600001)(86362001)(14454004)(446003)(486006)(2616005)(11346002)(7736002)(256004)(6916009)(305945005)(71190400001)(71200400001)(102836004)(476003)(6506007)(14444005)(66066001)(6512007)(386003)(2906002)(81156014)(52116002)(66476007)(66446008)(3846002)(36756003)(316002)(6436002)(53936002)(54906003)(107886003)(66946007)(8936002)(4326008)(64756008)(99286004)(81166006)(26005)(8676002)(4744005)(186003)(5660300002)(50226002)(25786009)(6116002)(1076003)(6486002)(66556008)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2768;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ceFI8jrajUB3WPmzwJsqd1XF0MBM6fqoRt/g1X7fLVTNlKah0oZy7iEaljqh1Z2lxP3ZTIj1Fq1ONfu0uhyGY1nlIZ1FKkLBTgfvQ4UdBbIfdpsjnRFgFw78SAsI2FBqXghWvwaT8BmFRKl3wphjms+Rt0IglzsZR/dmh7TcjD3iqNdhoU3Kz1vBcWdMiLHFZUmkWMwnhfwhKKj76xaC60eOkpqfLfLeWTJJFUiqk5hGjCTjZ2iWFYWlhCJ6SLKWI7ziwEW8Lcr3Juuy6jHNQ2eiwJkb1cshv8/SVc5+UP0CrTXtJVEwij6vLgBPYLWXNC3kM8CEljvFlNBCKD8+67k0Av7gH/HrRPLfbeY6ytmM7boHwYCx7eg/GnAgfv/kvHPsz1jrHG0J9aQr3yHmTPVDjPS/TZf8sEc3jxdomGY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00750d6a-4fa5-4f90-7b49-08d7324b2704
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 21:51:05.8468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nYY9P4EQzgTjY+dKkXz0ebydHzPsX5fRnD8J/7K8lpPV/PopD2V8l6DGGgvpEeMXZfu2D4z7tCZu1HlHUym/Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhong jiang <zhongjiang@huawei.com>

PTR_ERR_OR_ZERO contains if(IS_ERR(...)) + PTR_ERR. It is better
to use it directly. hence just replace it.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Acked-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 98d1f7a48304..da7555fdb4d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -988,10 +988,7 @@ mlx5e_tc_add_nic_flow(struct mlx5e_priv *priv,
 					    &flow_act, dest, dest_ix);
 	mutex_unlock(&priv->fs.tc.t_lock);
=20
-	if (IS_ERR(flow->rule[0]))
-		return PTR_ERR(flow->rule[0]);
-
-	return 0;
+	return PTR_ERR_OR_ZERO(flow->rule[0]);
 }
=20
 static void mlx5e_tc_del_nic_flow(struct mlx5e_priv *priv,
--=20
2.21.0

