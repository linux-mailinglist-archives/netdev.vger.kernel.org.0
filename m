Return-Path: <netdev+bounces-9312-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 957B5728697
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 19:48:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9161A1C21006
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 17:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E7951DCCB;
	Thu,  8 Jun 2023 17:48:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4D31DCBC
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 17:48:00 +0000 (UTC)
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-centralusazon11020019.outbound.protection.outlook.com [52.101.61.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4504CE2;
	Thu,  8 Jun 2023 10:47:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=naoy/Qk/TXrH5V2/xY8GK6D2O/pXx1q2iqY8B1B12R6ndLB9weN1WX6F0sFGHRnyzij5GETqzmG0aSkfnhoNd65XrMdvYK9xErmr9mWIDVRbjyxT/oEfLtIPvDc9ZMih7v85Ma+AEzPra4tSBcZ5tzBtpglqcbYzQ0YVEAe5+3qV2NLmv6k8BtFZv5W/lgD/geFiFGHXjP0Oj7u0wX9maNWFK2tXWasniJDmZ9jEY/6P2lEVV/bH8KSaW8YQ4T65p4/QS5suTzpUU+7fAV7ungVeXqGGQOs3T5awPZFc44yLYoUagnkYhVHuzkM+tBFMpvMvI3YqQnQaP2F7fDkdnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/5scAxNWFt4g5otw+BxCcoVlu7zi2Ep/yZDbdRiaNrI=;
 b=aGfLQjyDPMIO3q9phlKVLP8+ekLjF4dV+UUyaqqv5i7oRSC9JStCAW3svX83nuidJXu9+zF8Yu1b7xhKUwOgAQe+nJ0wnvfSqOB/kclXJxY0GTIac+sRt/NUNfNTjjnIwsWuM/Zxv/nfWhgm3kk9RQkcbrgXDLMYR0oCgGVe8rOY0j0uSgm4gqXbVggZ4AeUr1nX263eoyTEe1ecDm8CnyV73+mCiGCDohXIG/KxqhNLZDGopzr8Dh2f9yyvc0AZ7YFjKmOZNxHmgy7wzYa/zGyrokpxUyfIW4PG8HRHwa8nD7ql+xLkdxDs6t+iB9P8haOznP2py7+h39bvEyxWKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/5scAxNWFt4g5otw+BxCcoVlu7zi2Ep/yZDbdRiaNrI=;
 b=i1pq39GDfgRgSMdx6dPY1Ufi5u76Kztk6b4GGkeYL2Zhe6aM0lotp3rBm4TZWglNqQFoiSkFHXv4uBs6VMfWmojC2HClWkdPJVaemo5IAE8l++sGEQ4Jt/2ygQVELgbk2qg7IqvbYl7Nwj/dVp/LiCm25bLxMwgC9LgCiMjzCNs=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by SJ1PR21MB3456.namprd21.prod.outlook.com (2603:10b6:a03:454::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.12; Thu, 8 Jun
 2023 17:47:56 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::86cc:ee17:391f:9e45]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::86cc:ee17:391f:9e45%4]) with mapi id 15.20.6500.004; Thu, 8 Jun 2023
 17:47:56 +0000
From: Long Li <longli@microsoft.com>
To: Wei Hu <weh@microsoft.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-hyperv@vger.kernel.org"
	<linux-hyperv@vger.kernel.org>, "linux-rdma@vger.kernel.org"
	<linux-rdma@vger.kernel.org>, Ajay Sharma <sharmaajay@microsoft.com>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>, "leon@kernel.org" <leon@kernel.org>, KY
 Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>,
	"wei.liu@kernel.org" <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	"davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "vkuznets@redhat.com"
	<vkuznets@redhat.com>, "ssengar@linux.microsoft.com"
	<ssengar@linux.microsoft.com>, "shradhagupta@linux.microsoft.com"
	<shradhagupta@linux.microsoft.com>
Subject: RE: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to mana ib
 driver.
Thread-Topic: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to mana ib
 driver.
Thread-Index: AQHZmIoxGgRZCanZmkK6Z33s8kWpWa9/0eVwgADyswCAAGyLQA==
Date: Thu, 8 Jun 2023 17:47:56 +0000
Message-ID:
 <PH7PR21MB3263782C842638253C1FDB0CCE50A@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <20230606151747.1649305-1-weh@microsoft.com>
 <PH7PR21MB32634CB06AFF8BFFDBC003B3CE53A@PH7PR21MB3263.namprd21.prod.outlook.com>
 <SI2P153MB0441EC655394CEA3E8E727E7BB50A@SI2P153MB0441.APCP153.PROD.OUTLOOK.COM>
In-Reply-To:
 <SI2P153MB0441EC655394CEA3E8E727E7BB50A@SI2P153MB0441.APCP153.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6ddf424f-7835-43f4-b969-27a83fd42970;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-06-07T20:49:00Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3263:EE_|SJ1PR21MB3456:EE_
x-ms-office365-filtering-correlation-id: ed8b3543-c6e9-4795-ba94-08db68487dd1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 OZwyC8qZdWeHEmFI4cKHNeo5BtS4UZAl+/U3Ks86NE0jUTd/wMBOAaUP2M2G2UaMz8OdsYD2jYjjmd7F8epk9wsHtjeou7rG+GXHORKVE654YJMWxVJrihm2pRpuy8s5BmVlOw1Y10WR7P6lBtsUxjy4FkUUafV8hnwYG03WPnL6Qv3qNC6IhQMXirp4NZFQI0sMb8OtoQQtg1O/HfifRYS1cHkozvl2sO7Z10wsGnLwRY/urS/7qAfHLN0AfJjhBWqTTjgXdw1iknKXPYBH/dVUprlOvLdJqGReAYqo5XU7bq7vJkjWhqLCNtlNg9TkbWipVg9pp4aCr82NGd96t953+jfSRcIOFPLnkvYUTXXOyIFJz33lWRBKWJzjZlsJy+3GDKedMWv1Te6UlCaBe6ZLUR/Nsc9zt1jC+pBTRv4/PHaTjd7uWpfnhnf/9lLkt4CoJ7k0yJuO8yeIFOT4ekV4GF+8dHowziSMGIStJa9M03/pxqULAWJ8v2GVqO6sEbcyLQWo34M8y3EOcebJvyj4CHJgn74ujO3R2MykZ0rbMXBQPkuaicb0CtZUoglQqV2oh9OnKvoV+BARJyA6sWmEwxKxaOzAfja8zsOKSwyXX1aT1KIsLFSCKaNHvgYZGH8JSgt0fmz6UeWYbsgotkKxd3ObB+dJvK3exjwLQp/mbxgZuVTAKNbG0qbPZnSt
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(451199021)(7696005)(316002)(41300700001)(55016003)(8990500004)(86362001)(83380400001)(38070700005)(9686003)(186003)(6506007)(7416002)(26005)(33656002)(2906002)(82950400001)(82960400001)(921005)(122000001)(38100700002)(5660300002)(52536014)(8936002)(8676002)(76116006)(66446008)(66556008)(66476007)(66946007)(64756008)(110136005)(478600001)(10290500003)(66899021)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?qMlG62AR7MvrPM6oOd8iNrYh51ZicDCxOipzLdq9EQRj1J2Unm+TSoV6hmK/?=
 =?us-ascii?Q?o3mtITWOuM9LDLfew1CrrcYXDKh/+xXDUSDWFMX4UiKoWciIZ4f+uv2sbUkA?=
 =?us-ascii?Q?/cHrk9/UipTPL1ieZowNtrDW0CrghkZUSSYZYSM4zOkNc/CKSSG8OX+tazwL?=
 =?us-ascii?Q?IfXK4hvL1CXwK7mm3dmv0Sl38Ibb2kE3/Cdb7uQ+qukrYWrclwnkBSDcQDHG?=
 =?us-ascii?Q?5r50iDcSnYPntNmQSyUPhWm7wU/Pj//j94sMnUxOruPZGOOcc71CtHa03INp?=
 =?us-ascii?Q?8NLgY6VsuzFAWDCghYxSjybC0XjJpz2UYjuVLGniZzVaPCkDifI2QFgWBWhH?=
 =?us-ascii?Q?+ZKWmGsz6MMiYK7+L+9jhFUVRdUpmV987xEQwX6D6dUmqr3n+EQWtwdk1rBu?=
 =?us-ascii?Q?F+om248yWHVIL3B8h4ZyFG2hy3y8cH1Q8n+61YaG93XlrTtM1id9pYRZXA91?=
 =?us-ascii?Q?1XZLU9NF8dwAKOs7nxVaP1aV0nmpnBxlY86nODJkaLAlE/RuWvJXuBWE9dHY?=
 =?us-ascii?Q?JyD0wMGrEoZ43ooafPcJmmjLo+WIF8s+DOpj54EqncdyYVcnLLcGl/oQ/JAn?=
 =?us-ascii?Q?2UI6GKSRnU0Wqqk2gAp6syW0Y39LsfP/PIkq1pAFcT8wYGCDG9UkHfsgySME?=
 =?us-ascii?Q?XoJYrCIdWNMGNMVcsHQQk6LQslqXgjuf/a6LynCKoDdddsb0jH8yO7JBBnld?=
 =?us-ascii?Q?ZfUZGH61ITFLqSlWqwF4fKyMpkc9si2TlyRFJKMjXc/uDHRhZx2o03F/0kyW?=
 =?us-ascii?Q?bbCu8IOvH0YFWpbiaRQzXI9ix0OyoanRb/bh/SqJ6esC18RDFSdxleU1hTOU?=
 =?us-ascii?Q?3eLQ7pfC4rNaMi5tYSUeBO5e9SHtwOyQEjyM19l/y2CiqfD+0+SI1f5SyKcc?=
 =?us-ascii?Q?nuoFQg5zUZREsRzLIVVbeaKtRc0J7ut09sJklqCvYxcGiQgpGGCOZlIJJDj4?=
 =?us-ascii?Q?SDU/TorDlgllfi+tJv6Z8y99lX2A2ZopJn2+F6U1cvLATav1ubWqAfsnwK63?=
 =?us-ascii?Q?y3WecfyWhAGv3mj1db2CthsiJrYDeI3iaZX2Af8s4/b2ZASEmAm99UxGKFUJ?=
 =?us-ascii?Q?oISmcONJILoyg+4GQqsWx2pNiuJvdkSaLuOun/CIhTDPnxUNPiQuYWfeA2Kl?=
 =?us-ascii?Q?/tojPGxEZkdgFCv0c9AAnNkJ74UCDRK8lb3PjAFxsCHg0oJHUV8LSzIydMeG?=
 =?us-ascii?Q?2oMiV/BLIcWU3KOQBruailw0kikIOqd2qxaBLnfxkLjA8051QVrdv2zEsqOF?=
 =?us-ascii?Q?pNSquN8+rLJ0yQlp2o1tGFjnDHDvTlhgXVZdX+AZX0n3MK9UUxopK7B7TjhJ?=
 =?us-ascii?Q?D6UlHxLmXQy+pvgLHVxSyX9oBohR21iwnbxKFHUm1DAVtdRxdqbCDE/JFtSA?=
 =?us-ascii?Q?LXwz3MURibJcXWqh4QaPPg30poulUkDClkUGOQHrQsiADJoCMb9vJMHMCiko?=
 =?us-ascii?Q?xkVaqGbhM40AUA1DdlPQgBIu8LKGxCNVwz3J/zKzeQzPrEOkz7zFt4vng4om?=
 =?us-ascii?Q?hBIQP1yb6ABcLsX5yOR33R033bzNtABAIhZmsho8MUZVArLRN2cUHzu/40jY?=
 =?us-ascii?Q?hOTNo/OSgEW7TNMh84VOdzc8IuIXIq6VgL7Mrl+m?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed8b3543-c6e9-4795-ba94-08db68487dd1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 17:47:56.0273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VzQYf19ImwqhhPxymRj/ZhUMQ7n7c8q+b5VhfzgHY7t0IQKcLucPHcMv7QIIxyIOFnTmZcA5mPRd9jcRaK67tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR21MB3456
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> Subject: RE: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to
> mana ib driver.
>=20
>=20
>=20
> > -----Original Message-----
> > Subject: RE: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to
> > mana ib driver.
> >
> > > Subject: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to
> > > mana ib driver.
> > >
> > > Add EQ interrupt support for mana ib driver. Allocate EQs per
> > > ucontext to receive interrupt. Attach EQ when CQ is created. Call CQ
> > > interrupt handler when completion interrupt happens. EQs are
> > > destroyed when
> > ucontext is deallocated.
> > >
> > > The change calls some public APIs in mana ethernet driver to
> > > allocate EQs and other resources. Ehe EQ process routine is also
> > > shared by mana ethernet and mana ib drivers.
> > >
> > > Co-developed-by: Ajay Sharma <sharmaajay@microsoft.com>
> > > Signed-off-by: Ajay Sharma <sharmaajay@microsoft.com>
> > > Signed-off-by: Wei Hu <weh@microsoft.com>
> > > ---
> > >
> > > v2: Use ibdev_dbg to print error messages and return -ENOMEN
> > >     when kzalloc fails.
> > >
> > >  drivers/infiniband/hw/mana/cq.c               |  32 ++++-
> > >  drivers/infiniband/hw/mana/main.c             |  87 ++++++++++++
> > >  drivers/infiniband/hw/mana/mana_ib.h          |   4 +
> > >  drivers/infiniband/hw/mana/qp.c               |  90 +++++++++++-
> > >  .../net/ethernet/microsoft/mana/gdma_main.c   | 131 ++++++++++------=
-
> -
> > >  drivers/net/ethernet/microsoft/mana/mana_en.c |   1 +
> > >  include/net/mana/gdma.h                       |   9 +-
> > >  7 files changed, 290 insertions(+), 64 deletions(-)
> > >
> > > diff --git a/drivers/infiniband/hw/mana/cq.c
> > > b/drivers/infiniband/hw/mana/cq.c index d141cab8a1e6..3cd680e0e753
> > > 100644
> > > --- a/drivers/infiniband/hw/mana/cq.c
> > > +++ b/drivers/infiniband/hw/mana/cq.c
> > > @@ -12,13 +12,20 @@ int mana_ib_create_cq(struct ib_cq *ibcq, const
> > > struct ib_cq_init_attr *attr,
> > >  	struct ib_device *ibdev =3D ibcq->device;
> > >  	struct mana_ib_create_cq ucmd =3D {};
> > >  	struct mana_ib_dev *mdev;
> > > +	struct gdma_context *gc;
> > > +	struct gdma_dev *gd;
> > >  	int err;
> > >
> > >  	mdev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
> > > +	gd =3D mdev->gdma_dev;
> > > +	gc =3D gd->gdma_context;
> > >
> > >  	if (udata->inlen < sizeof(ucmd))
> > >  		return -EINVAL;
> > >
> > > +	cq->comp_vector =3D attr->comp_vector > gc->max_num_queues ?
> > > +				0 : attr->comp_vector;
> > > +
> > >  	err =3D ib_copy_from_udata(&ucmd, udata, min(sizeof(ucmd), udata-
> > > >inlen));
> > >  	if (err) {
> > >  		ibdev_dbg(ibdev,
> > > @@ -69,11 +76,32 @@ int mana_ib_destroy_cq(struct ib_cq *ibcq,
> > > struct ib_udata *udata)
> > >  	struct mana_ib_cq *cq =3D container_of(ibcq, struct mana_ib_cq, ibc=
q);
> > >  	struct ib_device *ibdev =3D ibcq->device;
> > >  	struct mana_ib_dev *mdev;
> > > +	struct gdma_context *gc;
> > > +	struct gdma_dev *gd;
> > > +
> > >
> > >  	mdev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
> > > +	gd =3D mdev->gdma_dev;
> > > +	gc =3D gd->gdma_context;
> > >
> > > -	mana_ib_gd_destroy_dma_region(mdev, cq->gdma_region);
> > > -	ib_umem_release(cq->umem);
> > > +
> > > +
> > > +	if (atomic_read(&ibcq->usecnt) =3D=3D 0) {
> > > +		mana_ib_gd_destroy_dma_region(mdev, cq->gdma_region);
> >
> > Need to check if this function fails. The following code will call
> > kfree(gc-
> > >cq_table[cq->id]), it's possible that IRQ is happening at the same
> > >time if CQ
> > is not destroyed.
> >
>=20
> Sure. Will update.
>=20
> > > +		ibdev_dbg(ibdev, "freeing gdma cq %p\n", gc->cq_table[cq-
> > >id]);
> > > +		kfree(gc->cq_table[cq->id]);
> > > +		gc->cq_table[cq->id] =3D NULL;
> > > +		ib_umem_release(cq->umem);
> > > +	}
> > >
> > >  	return 0;
> > >  }
> > > +
> > > +void mana_ib_cq_handler(void *ctx, struct gdma_queue *gdma_cq) {
> > > +	struct mana_ib_cq *cq =3D ctx;
> > > +	struct ib_device *ibdev =3D cq->ibcq.device;
> > > +
> > > +	ibdev_dbg(ibdev, "Enter %s %d\n", __func__, __LINE__);
> >
> > This debug message seems overkill?
> >
> > > +	cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context); }
> > > diff --git a/drivers/infiniband/hw/mana/main.c
> > > b/drivers/infiniband/hw/mana/main.c
> > > index 7be4c3adb4e2..e4efbcaed10e 100644
> > > --- a/drivers/infiniband/hw/mana/main.c
> > > +++ b/drivers/infiniband/hw/mana/main.c
> > > @@ -143,6 +143,81 @@ int mana_ib_dealloc_pd(struct ib_pd *ibpd,
> > > struct ib_udata *udata)
> > >  	return err;
> > >  }
> > >
> > > +static void mana_ib_destroy_eq(struct mana_ib_ucontext *ucontext,
> > > +			       struct mana_ib_dev *mdev) {
> > > +	struct gdma_context *gc =3D mdev->gdma_dev->gdma_context;
> > > +	struct ib_device *ibdev =3D ucontext->ibucontext.device;
> > > +	struct gdma_queue *eq;
> > > +	int i;
> > > +
> > > +	if (!ucontext->eqs)
> > > +		return;
> > > +
> > > +	for (i =3D 0; i < gc->max_num_queues; i++) {
> > > +		eq =3D ucontext->eqs[i].eq;
> > > +		if (!eq)
> > > +			continue;
> > > +
> > > +		mana_gd_destroy_queue(gc, eq);
> > > +	}
> > > +
> > > +	kfree(ucontext->eqs);
> > > +	ucontext->eqs =3D NULL;
> > > +
> > > +	ibdev_dbg(ibdev, "destroyed eq's count %d\n", gc-
> > >max_num_queues); }
> >
> > Will gc->max_num_queues change after destroying a EQ?
> >
>=20
> I think it will not change. Also the compiler might optimize the code to =
just
> read the value once and store it in a register.
>=20
> Thanks,
> Wei

This message is confusing. How about changing it to " destroyed eq. Maximum=
 count %d", or just remove the count as it's not informational.

Long

