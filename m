Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0F3AAE0F
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 23:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390977AbfIEVvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 17:51:19 -0400
Received: from mail-eopbgr150045.outbound.protection.outlook.com ([40.107.15.45]:23041
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390949AbfIEVvS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 17:51:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ga4OsUMTfaa7JJsEN6NHly9fWsdOYQWEBXPgFkB2WfTIh8qRKyMphf8B+fUwCqJJfxqc/MDi4SisJ4WJ8AbyCdVJAhnGUgDANHuywW1rkStcDUysy3NbsjjORf7KZDXcPNOpsM7Sq8lGUG+uLFggEMf/YfmoJsWCgKnPEJlWB8YP1ln9xF/X0xS1qbGq8Uqka8VsU9DJoQVxxE2LbSRZ21KkMnn/+DLSTpnb+TxseRAmPSB5UrFXmQ95+rAk8HmITN8Qw4I3G+RFs4MsWUuZPLO3xC9lgcevBdx6KP6CfRZlv//GZr5yQrfc2i0wABUAxR/9OP/pdh4k0jeA5fmSJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h75N/0RLK2qd2eIPV2De1B9mtaH1P0DHfJf1zKpZz2w=;
 b=XJPFYw4KmF1XuhQVFkqYJXS7QHhreXNYN1TipbPnLjJlCDAp/ECdV0tto9mOvt9u5cjXtj3X1rqDVy1u3VGZFLBKuJ6TzVDTcxEfWpKfOaekIfDXRGneG3UnpSVT1HIAx0fkvn++lZ6Ss5O2cPhqAakD7+QRsslNiTMhdnAF22vJU3DyBpU3EGkMIG22u7V31VPnsDNS3KK2dZqoByKLTcrmXWkBIx+pM6qCQiKDpZ34/hyVyWDQaxa4FNBJcwE8jIeK1gCwADpFuljj8FWgulTVC9/QiuLvtai2L9QS3FbcSl4U8/AAVH4lXt1uJmZw1X5YTmcUY+eCQTm8j/5IGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h75N/0RLK2qd2eIPV2De1B9mtaH1P0DHfJf1zKpZz2w=;
 b=FucXGYgcQ+PuIqvc7hVQUSyzr3xH8lYe62/i+aYsxHNrBIFKvUl4AXiUqu7/nh3MpNgWreCEWyVOUMNY6+e2ACbl+u2/RhGLQK4p6FHZVQ1VPj745xTCD+Y3yZSQWp6VlV5J3xBY2zvWADfC06ixHiOEsQbqKkLsClVCvxF0qgo=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2768.eurprd05.prod.outlook.com (10.172.81.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Thu, 5 Sep 2019 21:51:15 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2220.022; Thu, 5 Sep 2019
 21:51:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/14] net/mlx5: DR, Remove useless set memory to zero use
 memset()
Thread-Topic: [net-next 10/14] net/mlx5: DR, Remove useless set memory to zero
 use memset()
Thread-Index: AQHVZDQIJWtAIzGEo0KDeHvnq0ErYw==
Date:   Thu, 5 Sep 2019 21:51:11 +0000
Message-ID: <20190905215034.22713-11-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: fddb4112-9189-434a-5fd8-08d7324b2a6a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0501MB2768;
x-ms-traffictypediagnostic: VI1PR0501MB2768:|VI1PR0501MB2768:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB2768A8F34FF538F341E06286BEBB0@VI1PR0501MB2768.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:541;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(199004)(189003)(478600001)(86362001)(14454004)(446003)(486006)(2616005)(11346002)(7736002)(256004)(6916009)(305945005)(71190400001)(71200400001)(102836004)(476003)(6666004)(6506007)(14444005)(66066001)(6512007)(386003)(2906002)(81156014)(52116002)(66476007)(66446008)(3846002)(36756003)(316002)(6436002)(53936002)(54906003)(107886003)(66946007)(8936002)(4326008)(64756008)(99286004)(81166006)(26005)(8676002)(4744005)(186003)(5660300002)(50226002)(25786009)(6116002)(1076003)(6486002)(66556008)(76176011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2768;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5lFlIeIw/Z+nQfgY9YzTMcCDDLj7pb/n+uAFXgI/1YQBRUdBB8kk3odNqHUnLZxkBejKQOCkuXSAW6Ft2djGinpDYlaH2PnhHsdaTvLfSItELBa5+FEYGZtLeq4ZI+MEoIiix3qepT5JGmqb3fcfj/O6mVDZxGRxos3v7c2DBgXHUq+helLumYZpNg7HdfF91SPcQW2Em049a2r1v4E/cBZgm+2n1/SvwPqhLVMUYZFAn7z344NPwM6/JFSJqTKdDAs5UK0zOscbKbyVUgd1OZhUkE6V26UjzV2uhKjzwu8q6qcm+SiYMrdhqruWihHfVuQCGzusbk9sDVJB83PKOUYJ/qOB9+S/A590WC+TgrAYP6OAyr8Z1GlMOyPdNiNMyKwJ10OY23njP8/We9DZZoQkgxa9Z5RyXFR4olr6l/E=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fddb4112-9189-434a-5fd8-08d7324b2a6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 21:51:11.7057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 074F3G20s4dMiJhXaDVURmzAD79HhH8A9/b9ja5LVPQYzrY4zGvFTQEeLR9mQvR413+C2uVUUI10iFut7nxlXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

The memory return by kzalloc() has already be set to zero, so
remove useless memset(0).

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index ef0dea44f3b3..5df8436b2ae3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -899,7 +899,6 @@ int mlx5dr_send_ring_alloc(struct mlx5dr_domain *dmn)
 		goto clean_qp;
 	}
=20
-	memset(dmn->send_ring->buf, 0, size);
 	dmn->send_ring->buf_size =3D size;
=20
 	dmn->send_ring->mr =3D dr_reg_mr(dmn->mdev,
--=20
2.21.0

