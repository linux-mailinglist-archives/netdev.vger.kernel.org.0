Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9CC7758ED
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 22:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbfGYUgk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 16:36:40 -0400
Received: from mail-eopbgr20081.outbound.protection.outlook.com ([40.107.2.81]:36366
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726642AbfGYUgj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 16:36:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OzTt55s+UVC+HOL2ws/PCl/rGFvnGlfzG2GHqiijryRFwEJzfh+XCls+6hVH1IwP9Qc4GJXptxl74leOYi1nZWpHpiLZxis3C+tPjxbY6EUkQmJ8zYNe0PN4ynUkpoAGWnhdroH7fTgcNfy8pp4+F78kyGv+xgbVm/76YkOfjcHcEHdPv87fALunDJZsEw08lw9BAUth6FVcJzewefZ1Qg8JcgRhRr/CmsUuUDFrsIsqdi+lFVaPEVckltqQEYcjL4SdqDETjJxmT7lI6tnW6qdrjnWqd9mMAWz7fjG1lmqQUr1N+eBSZFhBLGVl1nO0lFiutTm2ZKcFwyJ+xp8sRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/oAgA9ld2aVt8iMYDBW3h4cgyB2XcGllulMVdxaQ1dc=;
 b=ZvAwSlkrUEkTrfd3+UMfnFQTqTQg4e582ld6TKUG30HHd0QV7O6lQQa+TTxOsoDaGYYfNELjcNZmmPYFzvCCjxDQiIh7NEZrNnmnVmWtpB1wYQfInVXkZEiCgtWaKEzjYwL5J/ukozj17sQF6cXe2ZpCNdcjoTwWeTAt8H/oQ5O6sFIpmPbMvm4i57wl67UtVq9lwaiXYLTm/gsdSOVXttplyatNj8SPV9etHQiv0t/b/u/5UhHZ857mbsAnPG8u5wyFUlsxpGP+Wzu2HJdTY5KIwUC6+bvcKRps2Do4cZrzgudyGieFbmcvZpZs4XjbeiiXlujLwEEMjIRbnvtJKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/oAgA9ld2aVt8iMYDBW3h4cgyB2XcGllulMVdxaQ1dc=;
 b=qRYah/CGUj79kwe0Q3HW1QbACPpASgGDUcup+mgQDDWDaM2ub9n/Ds3Q5GbFKvjXdVJfujhlnKFeuiCb7Y0nnpxFbKNAT3j/YaRDf78DapJ8tzR8d3VFL9LQseZhLTAQSAtq7rPRMqraGDN1JGJUUtPYjTTVaXd02J6SKz8HrIg=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2504.eurprd05.prod.outlook.com (10.168.76.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Thu, 25 Jul 2019 20:36:35 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Thu, 25 Jul 2019
 20:36:35 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Mark Zhang <markz@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 1/9] net/mlx5: Use reversed order when unregister devices
Thread-Topic: [net 1/9] net/mlx5: Use reversed order when unregister devices
Thread-Index: AQHVQyimzhQ1a9PtTUmSfzIPX5PXrw==
Date:   Thu, 25 Jul 2019 20:36:35 +0000
Message-ID: <20190725203618.11011-2-saeedm@mellanox.com>
References: <20190725203618.11011-1-saeedm@mellanox.com>
In-Reply-To: <20190725203618.11011-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0042.namprd02.prod.outlook.com
 (2603:10b6:a03:54::19) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b365c815-abb7-4c56-e876-08d7113fc911
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2504;
x-ms-traffictypediagnostic: DB6PR0501MB2504:
x-microsoft-antispam-prvs: <DB6PR0501MB2504E5EDCD5FA7B51D755D1DBEC10@DB6PR0501MB2504.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(189003)(199004)(2906002)(6512007)(25786009)(305945005)(81166006)(7736002)(8936002)(53936002)(71190400001)(107886003)(476003)(6436002)(2616005)(50226002)(186003)(52116002)(1076003)(71200400001)(386003)(99286004)(6506007)(6116002)(36756003)(14444005)(256004)(81156014)(478600001)(316002)(446003)(11346002)(64756008)(86362001)(66446008)(14454004)(6916009)(8676002)(66946007)(66476007)(4326008)(54906003)(68736007)(66556008)(26005)(76176011)(6486002)(66066001)(486006)(5660300002)(102836004)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2504;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6U00fNpuu+qFDoeGDOcQc/tFKi8SXILDfxdLYXSf5gRmxkDc3KuRSqSx9o1J5IMvGUF+6iW83sSQV+ItidBa9STY+4GUTZUP64YQ2gzuT7GgOJoagjTDNuMO9QPdKZhFKZFhBOgXhxwQbSmd0+5+/rCw0U/0283UwyNBWpw8ToaVAiSE1wPAH2bPNIJzqwu5PGzHdKLUqHmGNJHlHiHQZEChY4+PfbQgvEf+jQ0QNWy+DV5GjDk/nedmWegs8y7pkrH6MbSdEkuOPlWSaoAB5EGNPSfuykPPRYq99l7CDDU11xhmwCNyY4o7WPGmex0Nuy7YG1gOC1VPr0Z/7MOJ07eIue8fQLUKPAf0vxXze3s1o13CEeqDRI40eNBheO8MCrg7vU7+U0MNOkZx/IP2PT6YszAWK/j37jfg3bx7UXU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b365c815-abb7-4c56-e876-08d7113fc911
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 20:36:35.4918
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2504
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

When lag is active, which is controlled by the bonded mlx5e netdev, mlx5
interface unregestering must happen in the reverse order where rdma is
unregistered (unloaded) first, to guarantee all references to the lag
context in hardware is removed, then remove mlx5e netdev interface which
will cleanup the lag context from hardware.

Without this fix during destroy of LAG interface, we observed following
errors:
 * mlx5_cmd_check:752:(pid 12556): DESTROY_LAG(0x843) op_mod(0x0) failed,
   status bad parameter(0x3), syndrome (0xe4ac33)
 * mlx5_cmd_check:752:(pid 12556): DESTROY_LAG(0x843) op_mod(0x0) failed,
   status bad parameter(0x3), syndrome (0xa5aee8).

Fixes: a31208b1e11d ("net/mlx5_core: New init and exit flow for mlx5_core")
Reviewed-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/et=
hernet/mellanox/mlx5/core/dev.c
index 5bb6a26ea267..50862275544e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -213,7 +213,7 @@ void mlx5_unregister_device(struct mlx5_core_dev *dev)
 	struct mlx5_interface *intf;
=20
 	mutex_lock(&mlx5_intf_mutex);
-	list_for_each_entry(intf, &intf_list, list)
+	list_for_each_entry_reverse(intf, &intf_list, list)
 		mlx5_remove_device(intf, priv);
 	list_del(&priv->dev_list);
 	mutex_unlock(&mlx5_intf_mutex);
--=20
2.21.0

