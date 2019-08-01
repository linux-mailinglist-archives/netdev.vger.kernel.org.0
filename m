Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF8E7E3A9
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388892AbfHAT5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 15:57:33 -0400
Received: from mail-eopbgr130057.outbound.protection.outlook.com ([40.107.13.57]:25762
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388881AbfHAT5c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 15:57:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EDxpMhz52QHmnezEu9Cy/+8BpUWX0VTIva2bx3kuN7ZAXjxDrW3k3Iqb1vny3VunEypZEChHZEqxqkHXFd7Nr+6KEt4WpB7dWecG6O/w6TbDxfKdwHtTNGvtPI6VubMAfz+JvJ+dgrVMBkxEQsTs/NAt54GN3MqVe8S6wth3JuUt+2IWbNRNdWFn+QNsksdYNuVnOgPHUjhSkqIUPAgyrV5++JJcSyKnhAn6PwZkHSK2InUKznr4o+CGe+58GQ2PL4hofd/lOKX+GqnBZ3RlDKBACwcmBL5bYCejXXL+jDDNBVm47A/nT7g+fb1eaS/2Up/VaDLoMgI3z+YavPirtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uKpcxYUsuumlbVUCWA5kknauRx0CRdtyaDgsRNtFkKw=;
 b=kfITqnQQUdFPjy3IGvNb+8crnzsaU41sZquYmuaTvCvpbVaMFRmetOlO6hU1ehuOoF8iD1GSomgQsAaKcW+uowOCxqsZiDzIx3aEiSky1kWYp6gWg5ft4s6Xwl0nP7x7VgXdj49jfthqCVrKIl/O8fFit+sm9K0FtBI8bXE1C81lcfZa5KWHyxxuW4iW/FgCbjGCk7jFI0p5kMaNA37NtdOHcviX2J1Oq034l9KPMu2hrGeo/6GCV+GwFdHM1aRyQEYcEDHwMZuaxzeLDBM18AmnGbPaXZSTladjRqqzrbf7eJ0pxlBrCKRb4EX5icQcZfqeHv20gz0AvnUf6fReZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uKpcxYUsuumlbVUCWA5kknauRx0CRdtyaDgsRNtFkKw=;
 b=j0Dyl2CXI/tl5lY5lbflhQYTWdtw8eide2pWn1xCNNY/PP3UBV0ItI8F677bEMAtAcab/GIUVk+iJ9SCtIPZMGzwIY3Sv1NHn8P80GOeFoAwgSTQMdaJBLo9CFHsX4GPIXjZRP4Xa1TXMxd225857Lx38U+5jHw7G8e6w6NxkRg=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Thu, 1 Aug 2019 19:57:10 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Thu, 1 Aug 2019
 19:57:10 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/12] net/mlx5e: TX reporter cleanup
Thread-Topic: [net-next 11/12] net/mlx5e: TX reporter cleanup
Thread-Index: AQHVSKNN2rtCj/hS80GkBvsYCDI4DA==
Date:   Thu, 1 Aug 2019 19:57:10 +0000
Message-ID: <20190801195620.26180-12-saeedm@mellanox.com>
References: <20190801195620.26180-1-saeedm@mellanox.com>
In-Reply-To: <20190801195620.26180-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: MWHPR22CA0034.namprd22.prod.outlook.com
 (2603:10b6:300:69::20) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c4ddc00-addc-4707-8c0a-08d716ba704f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2759;
x-ms-traffictypediagnostic: DB6PR0501MB2759:
x-microsoft-antispam-prvs: <DB6PR0501MB2759EE1EA9777A574AA12AA7BEDE0@DB6PR0501MB2759.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:296;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(71200400001)(71190400001)(5660300002)(6916009)(4326008)(107886003)(1076003)(6116002)(3846002)(476003)(486006)(256004)(66066001)(86362001)(11346002)(446003)(25786009)(2616005)(66446008)(64756008)(66556008)(66476007)(66946007)(478600001)(14454004)(53936002)(316002)(7736002)(6486002)(76176011)(52116002)(99286004)(54906003)(36756003)(50226002)(386003)(6506007)(102836004)(305945005)(2906002)(81166006)(81156014)(186003)(8676002)(8936002)(6512007)(68736007)(6436002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2759;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ppHPq9w53u6gRQ31nRGEpEVfV7Bkin7xYZykNlSTXo3ld1af99USsI2o9K2BJhr5jchwgFN7sRGwYrqY83mjCaUzy0AKRJWoI3HQNq86ML903VxW16hIXYGzLETQHPTvBKPgd2oxr9e/fu0kLQFwHNmbHtqI4ETiRgog3zms9orSY28z6/i21giV3I11KDNxl6mnHGzAq4+I5pKRj2DkYf2CRfKv9qSxx9NQs3G6UTdQLtB2jaflaPT/GIUGTTqHrxQWIxTGwTFZwrOi3jSzFfK6AVw3CZRcKeSzWpFy1YYLWQlZlMnxh4JiPSv0LPSECSQsEorIswUMk+Xz6/GixnWCmgwrOZVQoCKMTh2kBHATMovjP8INGlyR12TiM41H4Ley2d6iXPItJywkZwexAzpzNd9qRhpuFKKRtvWRt90=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c4ddc00-addc-4707-8c0a-08d716ba704f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 19:57:10.1573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2759
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Remove redundant include files.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter.h    | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter.h b/driver=
s/net/ethernet/mellanox/mlx5/core/en/reporter.h
index e78e92753d73..ed7a3881d2c5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter.h
@@ -4,7 +4,6 @@
 #ifndef __MLX5E_EN_REPORTER_H
 #define __MLX5E_EN_REPORTER_H
=20
-#include <linux/mlx5/driver.h>
 #include "en.h"
=20
 int mlx5e_tx_reporter_create(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index f1c652f75718..6e54fefea410 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -1,7 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (c) 2019 Mellanox Technologies. */
=20
-#include <net/devlink.h>
 #include "reporter.h"
 #include "lib/eq.h"
=20
--=20
2.21.0

