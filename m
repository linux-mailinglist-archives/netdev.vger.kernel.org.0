Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A283988585
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729704AbfHIWEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:04:54 -0400
Received: from mail-eopbgr10055.outbound.protection.outlook.com ([40.107.1.55]:23013
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729331AbfHIWEw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 18:04:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RnMaBJodzHAfHnN5Y8i2McrrA285CDrJ4Tv/2LqLTaw8aXIex5McZ2Cd9clRoJ8/Fv/vjbxVwSYEDfEv2+dPsBGuXICf36s3OU7OgmUj8KW9HU4aPECY5V0M3zFB3Lls+eAlXFkJXvGANhHRkwv/4QfbpVvzw6P7XpRZiKadBFckUkrS0fBn8ezCN6P34loeWf9tcpJ5pu+hFieH5Qdj41UgPwMtEIeYoOVqq1gJUVsNMwleq0jIDJa+DC6sWbsKmNuTe52zB+2XT2jFlyUZm2kGUm97uQ+VOto7k5IK7/8jOgcpTFCAKw/lmhzyrlI4yrhBArwcscDCTwfV8yTtQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BdOyWMDRjfatkZx6jqwxlrv5P18357tH1g+odUxJVvQ=;
 b=WHeOO3wX0l2t7cfLu7mk3yVOO4CdLSW/bldKyTcoN1lsGj1/6cXmL8ElTXBG+Az1QS+cb/RX8FL+Vq7LUCAgGkHonctn/7D6YTPRteTAy2M+Tcd7BwTOHEkYCos+s0rK5GKsHhp38f1s6Du8O5O5AB1QEx+BnqpEWNRyi4TvqiEb9+J9AyPhla5hy/bHfKZjfZwD6GVjnXgb4eRCgxWfY8LB3+2tBw37y+GAMOh9vO0Di6E7rkRq6d1ijrkZPOmwZJFjmAVNm2jxlCDJW/nRhbaIHhjWjDcJJuse1PKCzMTDejT8LXxFdvaC63GiL5VP6YLhFgAQQgGfK/9sHfAviA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BdOyWMDRjfatkZx6jqwxlrv5P18357tH1g+odUxJVvQ=;
 b=ogQE3uB8WTTmXxCd2x7uKMD5OL6rOw5/zCEoJUhe13aepYKpX56lAReigCXKWXE3wYVV9SMECr2uHsPogz0wPARvxjm0QfbZentFgFvktgraXQ+E953Mk3wj0RcryI1zz4MA6z8EFNDQ3lRc5roFo9BXc0MseEuRxPDwGrLx++c=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2405.eurprd05.prod.outlook.com (10.168.71.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.12; Fri, 9 Aug 2019 22:04:44 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 22:04:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chuhong Yuan <hslester96@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 15/15] net/mlx5e: Use refcount_t for refcount
Thread-Topic: [net-next 15/15] net/mlx5e: Use refcount_t for refcount
Thread-Index: AQHVTv5zu+/JdnNDhUOmeBC6PF9Bug==
Date:   Fri, 9 Aug 2019 22:04:44 +0000
Message-ID: <20190809220359.11516-16-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 6283c97f-d8cc-413d-45e1-08d71d1595d7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2405;
x-ms-traffictypediagnostic: DB6PR0501MB2405:
x-microsoft-antispam-prvs: <DB6PR0501MB240529BB0476428FBA1BDB10BED60@DB6PR0501MB2405.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(366004)(376002)(396003)(39860400002)(189003)(199004)(446003)(66556008)(36756003)(6512007)(6436002)(99286004)(66476007)(26005)(102836004)(53936002)(478600001)(5660300002)(316002)(8936002)(4326008)(486006)(71190400001)(11346002)(2616005)(386003)(66446008)(66946007)(6506007)(186003)(64756008)(6916009)(3846002)(6116002)(256004)(52116002)(305945005)(1076003)(476003)(81156014)(14444005)(8676002)(107886003)(81166006)(86362001)(7736002)(14454004)(50226002)(71200400001)(66066001)(54906003)(2906002)(25786009)(6486002)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2405;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /tsPqDZ6cvs6v8vAy9aR80dNw+3gZDHwPN8Xb0/GFfTmVzcPui9iRCqRf6Syo6tYGdrmQLS+erBOiOzEgd3v4zu6uG7CGo0EHjkZCotoL8Kg922LnwVqnpbvVgc8JNQuVYtKmRF8RNAaWkN/OKf0y0/1gO1rbCnXNwlWToXL0YrG/WE+1RoGolocXWKvfH5UDWp6XyTay6lMQwM5F+SxZuYuzclHCvHxjkQV7gVYjYDjq3rkQ/UowVsday+6OVKyIw+EG3ofjexy5uzMB63+sd5KC9A77GGdszy9M/0ev7KXm/TXzr7q8QJQ11xqzPo6SqP619ZMmUzWFkX1mG7hnTWAO4GeyoHOqT5JcrCTb0GvUtFYShrVwtIB8ESc6P+zXpA0PVwX/yHQlHiAhDrzPAIQrgvPMNke18tn34gsuyM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6283c97f-d8cc-413d-45e1-08d71d1595d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 22:04:44.3375
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3unRc4AwkPXIIJ6RB5suwMQsSB6uvtuWr7nyoM+b7qZoplBfkFEf/hOMskb06GSS5R7YRAe18BTUrJpZw0Z+MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2405
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

refcount_t is better for reference counters since its
implementation can prevent overflows.
So convert atomic_t ref counters to refcount_t.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c b/drivers/=
net/ethernet/mellanox/mlx5/core/lib/vxlan.c
index b9d4f4e19ff9..148b55c3db7a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/vxlan.c
@@ -32,6 +32,7 @@
=20
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/refcount.h>
 #include <linux/mlx5/driver.h>
 #include <net/vxlan.h>
 #include "mlx5_core.h"
@@ -48,7 +49,7 @@ struct mlx5_vxlan {
=20
 struct mlx5_vxlan_port {
 	struct hlist_node hlist;
-	atomic_t refcount;
+	refcount_t refcount;
 	u16 udp_port;
 };
=20
@@ -113,7 +114,7 @@ int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 p=
ort)
=20
 	vxlanp =3D mlx5_vxlan_lookup_port(vxlan, port);
 	if (vxlanp) {
-		atomic_inc(&vxlanp->refcount);
+		refcount_inc(&vxlanp->refcount);
 		return 0;
 	}
=20
@@ -137,7 +138,7 @@ int mlx5_vxlan_add_port(struct mlx5_vxlan *vxlan, u16 p=
ort)
 	}
=20
 	vxlanp->udp_port =3D port;
-	atomic_set(&vxlanp->refcount, 1);
+	refcount_set(&vxlanp->refcount, 1);
=20
 	spin_lock_bh(&vxlan->lock);
 	hash_add(vxlan->htable, &vxlanp->hlist, port);
@@ -170,7 +171,7 @@ int mlx5_vxlan_del_port(struct mlx5_vxlan *vxlan, u16 p=
ort)
 		goto out_unlock;
 	}
=20
-	if (atomic_dec_and_test(&vxlanp->refcount)) {
+	if (refcount_dec_and_test(&vxlanp->refcount)) {
 		hash_del(&vxlanp->hlist);
 		remove =3D true;
 	}
--=20
2.21.0

