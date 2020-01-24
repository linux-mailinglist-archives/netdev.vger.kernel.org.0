Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B04B148F3D
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 21:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392209AbgAXUU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 15:20:58 -0500
Received: from mail-eopbgr40044.outbound.protection.outlook.com ([40.107.4.44]:63396
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387568AbgAXUU5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 15:20:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Si+2LkvFc9gmMsU6ss0jJAhUvsMsD8T216qj10X+jSo6/GNCpRrEDZiSpt08jZzJ7VR1kdg9fKW+A/eclapBZ8kWVH+o0nY6tQ77rjLOpzczx95/LAJ4U5Hh5SKCuAzNpql5kB4h4NnwvOpm6SxaCfq6xu11MaWXU2JcDC/K+dUnIhbaK5J74O9wVXi+rmkAVjB+NjA0Dz6gsqEvf7/TJ8ZVjkxCix0EBc3xJUVVH/0ACHg6hvqegW6HVUoWbpGYMu90wjTF9gMONRbbclQ4pNgeaJ5fyrf0XWuo5gyO2Np70rFChVAaCMcDSGPSUZP3aKJCuHxI5OIX1zKgPqD6nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4XcIitJCRKeJK9nMmVLnAwwy8YnVqm1pd+/IeHoNpJM=;
 b=WMKt707p0aw0fFoqy782qe0zsmytuN0LMeR8cqQAhGJoKfYJ60h+gHkcvSTJIZU80ccdbjdh6Lu6kN34tg983b3iwksibLBytq9tcNizSUJwXyF5BLxW2tKc6I9Yw5Y/iXcqE5LL0xQn0EB1PnB+uOn0ElI52nU68pKvQgAQA8tLV6RCyrkjHuuy2wQ1VDD2D7Aw0qSRY53H205tdVtKU8ZFo4H4j3Y+hN81PD75PSzVDkjDISxDEQgsYv52ETSmcEnFDS41RA0pqkHokkSxD53Y53YwmCFV8T553IEob3Uk+EgvGXLn3Jfd6titrVbB22hOwnORuQ35oxUC+MxGpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4XcIitJCRKeJK9nMmVLnAwwy8YnVqm1pd+/IeHoNpJM=;
 b=cw/60Sw92Lo+R9L3gthlwdOPANym2JLaHoyFjPSHzUn+0hba3sDfxvGB0xPZqOqEEkye1zTk/yIcleIvFfDjLduVvNh8xl4fStHhNsVeUNnwNgCeZ5z/JFz+tPc9B9wJIzzO6MQPXlKaR3yDMhZbjCTcNLxAGVWeOUZllfHe/fA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5552.eurprd05.prod.outlook.com (20.177.202.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.20; Fri, 24 Jan 2020 20:20:52 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Fri, 24 Jan 2020
 20:20:52 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR01CA0071.prod.exchangelabs.com (2603:10b6:a03:94::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.21 via Frontend Transport; Fri, 24 Jan 2020 20:20:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 1/9] net/mlx5: Fix lowest FDB pool size
Thread-Topic: [net 1/9] net/mlx5: Fix lowest FDB pool size
Thread-Index: AQHV0vPGV9T6v1GX3EKdmc8wk55NYQ==
Date:   Fri, 24 Jan 2020 20:20:52 +0000
Message-ID: <20200124202033.13421-2-saeedm@mellanox.com>
References: <20200124202033.13421-1-saeedm@mellanox.com>
In-Reply-To: <20200124202033.13421-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0071.prod.exchangelabs.com (2603:10b6:a03:94::48)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f8889467-085a-4341-aa30-08d7a10ae881
x-ms-traffictypediagnostic: VI1PR05MB5552:|VI1PR05MB5552:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5552AE39B5B411DC83631076BE0E0@VI1PR05MB5552.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39850400004)(199004)(189003)(64756008)(66446008)(66946007)(4326008)(66476007)(107886003)(66556008)(316002)(1076003)(6512007)(6916009)(71200400001)(54906003)(16526019)(186003)(52116002)(26005)(6486002)(6506007)(956004)(2616005)(2906002)(478600001)(5660300002)(86362001)(36756003)(81156014)(81166006)(8936002)(8676002)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5552;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BncOa+XlEs7tPJT2xp3qGnQBZCZ40xT5BnqgK2Lwl+wDfOWzCIE1dJe9U6YhO9WAFkMv0TsaTTusyW6RPco7UwX+TgSNTqHxPsMWBKk419ghzn0QQ/FbDt6VHnKo6+BU8VLwV031Jswg0tjqmnwGGRh8tMKOCOd/mhmeGMNz3ieydnvjf4ceQdZ3YJDcZ7FdCguff7yEJohn3e0w1D3xI2imEd9nWVkyze538VJpBPKeDyeQ8yP+p9wxG0AEZPA8SV+nLzmwI1xnCpS+kGf/hvIO+mcUg2xCEryNmspq8KKreMOvC/P1dwSJ/+PZU6DeObKRkRS+N4rbfZnbexmkoqve4LOiVbj3yPtxs99bPuRQ0lQGmUhXsbHBWfFa/CH8DkZ7UPiIGBU5wMDQ1FVvMeawiDRoWrOiXk4zDNffViEZtoW4Vh5Y7rSNAG2UHlT4NUYDQaCukqLSV0tRrM8VyeTmhkvo8kbB7u/VzVF2jRmkwvu0p8xlpl4hCDzYnz+TPb/xv1Kb+7qB9IowcWShv6ylkx2aUx8oC0T9oNqIb2M=
x-ms-exchange-antispam-messagedata: dxlpJQ8JzYT2JknTlthhKNhEBtBeVrdEXWBqaF5373bKSAPgxsvxgyD6+Y3iSV1qrkSPoAn3d4Q0EzZcGR+Z96WbnhlHmWnfWXZ6HXgV4UkHHRr7VdVbksayJ6pP+H4mQWjh+0TYr8b9j9zFW0OQug==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8889467-085a-4341-aa30-08d7a10ae881
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 20:20:52.1059
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BOZkoftb70KRLoUo/q0GKdPixQ5VcPLNXpY2pjUOTWF9YaMhz8815CiuqHJeorPcMScYeH39i7bN7jUmajRA+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5552
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

The pool sizes represent the pool sizes in the fw. when we request
a pool size from fw, it will return the next possible group.
We track how many pools the fw has left and start requesting groups
from the big to the small.
When we start request 4k group, which doesn't exists in fw, fw
wants to allocate the next possible size, 64k, but will fail since
its exhausted. The correct smallest pool size in fw is 128 and not 4k.

Fixes: e52c28024008 ("net/mlx5: E-Switch, Add chains and priorities")
Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 243a5440867e..b8fe44ea44c3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -866,7 +866,7 @@ static int esw_add_fdb_miss_rule(struct mlx5_eswitch *e=
sw)
  */
 #define ESW_SIZE (16 * 1024 * 1024)
 const unsigned int ESW_POOLS[4] =3D { 4 * 1024 * 1024, 1 * 1024 * 1024,
-				    64 * 1024, 4 * 1024 };
+				    64 * 1024, 128 };
=20
 static int
 get_sz_from_pool(struct mlx5_eswitch *esw)
--=20
2.24.1

