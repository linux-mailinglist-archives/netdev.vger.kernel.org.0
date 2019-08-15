Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 007ED8F436
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732864AbfHOTKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:10:48 -0400
Received: from mail-eopbgr00085.outbound.protection.outlook.com ([40.107.0.85]:9262
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732858AbfHOTKq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 15:10:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NkkPTJmu/tRhawNJ7DyBOfymgFOH08l3mKb/9vIlFQnwzEn/EXtRQJqroZ8BomwRAcxqD+ZR+wL0zUNUyPQBXzakNg289F356hh4DfTCeZRjREpmofQFbJzph502pc5IP9+ejA97hOA0q8nVc1kR5l5dKKGGmr61JO44iMURbrdbjrSbX+vMY7uqE9QC3ic6Ij/jT7+fOfH0p4anuYUgS3IpDRmIeTd5MHPdvxoAZsvcdUcQwZ5dJubHTG8yQ2pVLilt/N58aUHPFO4UCx1i1wjP7WjAUqwO30EGzyB8IcOs5lz9wxtaR8xuerJm0i09gwNnr9yZLJWibNXSeGQEpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M1SxxzmraeN689u3BxAUOSz2PSJ2ZVW1S/OXZ4N0vY0=;
 b=kTcY7GMxRr81DMnKMPoDk6negHsKsokPof1AG7EJiVtKFKSNynsHeaJsL70ejI1lANINohS/j2AJXo/MvHoURAZ6kYs7D8OiEqa2BJw/DWNB5EHBHmPaW7Fm6rfP/OGt6EPTlvwFO0tnFA+zI1+vK43R69O78H5sGGW8X2nsHQdQ/9kATIPmWLqOHJ4yQXLpdiGR6bkBLl3hzHaZfOO8/8HpceGgZ9DpLbXCmN4tiTKkX4SH2poMdZXGsHSx6UN3gLWjX+rdwMV55/2xldF6roht+sh7FbucV59I7TjRKk0zR6JyvhIpxdf3JUFG3jONgdbuto7je1eU8wEoJeONZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M1SxxzmraeN689u3BxAUOSz2PSJ2ZVW1S/OXZ4N0vY0=;
 b=TXBAEYT1h+NeTa7KMTXXTxSJ6YEeFyPYnJZ4zGAOwiwRZEAlELX3oMZwC4NMolX3UkjkvMNiXy7zDRlOg1h/7BBPGldGce1w+7eYZbRNUMRS3CvQeny/NSOWV8D9GR55Aho7DcHtgh+DSwYw2xv81aEuteNwWN73mYFJ3vjEFiI=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2440.eurprd05.prod.outlook.com (10.168.71.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 15 Aug 2019 19:10:17 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 19:10:17 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Gavi Teitz <gavi@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 16/16] net/mlx5: Fix the order of fc_stats cleanup
Thread-Topic: [net-next 16/16] net/mlx5: Fix the order of fc_stats cleanup
Thread-Index: AQHVU50TW2lbg1YVNUqfZDaSXPnfjQ==
Date:   Thu, 15 Aug 2019 19:10:17 +0000
Message-ID: <20190815190911.12050-17-saeedm@mellanox.com>
References: <20190815190911.12050-1-saeedm@mellanox.com>
In-Reply-To: <20190815190911.12050-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::27) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a281b0b4-fc3c-48b1-30dc-08d721b43583
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2440;
x-ms-traffictypediagnostic: DB6PR0501MB2440:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2440F6F3C6EF2055D234ED57BEAC0@DB6PR0501MB2440.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(199004)(189003)(6916009)(2616005)(36756003)(446003)(76176011)(186003)(11346002)(52116002)(305945005)(386003)(7736002)(478600001)(476003)(102836004)(6506007)(99286004)(486006)(14454004)(3846002)(6116002)(14444005)(8676002)(8936002)(5660300002)(81156014)(81166006)(66066001)(26005)(256004)(50226002)(6486002)(6436002)(107886003)(71200400001)(6512007)(54906003)(71190400001)(316002)(1076003)(2906002)(66446008)(53936002)(66946007)(66556008)(66476007)(64756008)(25786009)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2440;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eUY6HID9Ed5U+Ta/IkIy1dyZKrFOiPwXIfYj84NR7ruqolXdqktM3XGTB1+DwcnyXMBLB72jcF8K8vXKQgipE4Bim6jNvKdEQl/9D8mJXplWPiOzGO0/q/WqSqO5N4aL1+oSszd4LqgYU9uTz4InwAqyVPjelg2pgIDWi0KqsWXjOYm2m6VatxrbNTXMj+MwpmZLEnij7o3Jo6efIgcXACEF1++ds8BOaWACQRXfvNkbR163Z67M1IoqqPkZAdg8MXn4YyuIzjAmGqp26TXsOp4d/Nt967lhLWe/oCKdfXlr8euBX81sz2eMQBamHKEieJ+OZ+F3HS5gH+AVn7qynvpoKYsKiftfe33f3UBIG/tRKiILxJxPhGKaPEHSSwgGFW1mZtAjMX/sfD5kk8dnCnjNXjlCUjL+Ok8vrWj/C+I=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a281b0b4-fc3c-48b1-30dc-08d721b43583
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 19:10:17.2944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zc/0o22T9INEYP1vDYRH6f4CplqBuVb9nM0H61JQLJosD5M2vrgxwnUZS3AUKhX/McCgykCuqNq7xHFnKVXeWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2440
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gavi Teitz <gavi@mellanox.com>

Previously, mlx5_cleanup_fc_stats() would cleanup the flow counter
pool beofre releasing all the counters to it, which would result in
flow counter bulks not getting freed. Resolve this by changing the
order in which elements of fc_stats are cleaned up, so that the flow
counter pool is cleaned up after all the counters are released.

Also move cleanup actions for freeing the bulk query memory and
destroying the idr to the end of mlx5_cleanup_fc_stats().

Signed-off-by: Gavi Teitz <gavi@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/driver=
s/net/ethernet/mellanox/mlx5/core/fs_counters.c
index 1804cf3c3814..ab69effb056d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -402,21 +402,20 @@ void mlx5_cleanup_fc_stats(struct mlx5_core_dev *dev)
 	struct mlx5_fc *counter;
 	struct mlx5_fc *tmp;
=20
-	mlx5_fc_pool_cleanup(&fc_stats->fc_pool);
 	cancel_delayed_work_sync(&dev->priv.fc_stats.work);
 	destroy_workqueue(dev->priv.fc_stats.wq);
 	dev->priv.fc_stats.wq =3D NULL;
=20
-	kfree(fc_stats->bulk_query_out);
-
-	idr_destroy(&fc_stats->counters_idr);
-
 	tmplist =3D llist_del_all(&fc_stats->addlist);
 	llist_for_each_entry_safe(counter, tmp, tmplist, addlist)
 		mlx5_fc_release(dev, counter);
=20
 	list_for_each_entry_safe(counter, tmp, &fc_stats->counters, list)
 		mlx5_fc_release(dev, counter);
+
+	mlx5_fc_pool_cleanup(&fc_stats->fc_pool);
+	idr_destroy(&fc_stats->counters_idr);
+	kfree(fc_stats->bulk_query_out);
 }
=20
 int mlx5_fc_query(struct mlx5_core_dev *dev, struct mlx5_fc *counter,
--=20
2.21.0

