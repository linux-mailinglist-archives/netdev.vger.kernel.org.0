Return-Path: <netdev+bounces-9407-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A282B728CF0
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 03:15:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E45F41C2106A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 01:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91E00A4C;
	Fri,  9 Jun 2023 01:15:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E189A44
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 01:15:16 +0000 (UTC)
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2096.outbound.protection.outlook.com [40.107.255.96])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEBEB184;
	Thu,  8 Jun 2023 18:15:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Evtmu9STm27LN5CgdHJokZCjc7DlINtxhAfiwiHeyN8gMsEBSdnn0QaTPp8+swPqPYTE9why+ccJ2/85eJxayyA6QJGT/BCr8ANuxROLpIhh008HQJEcU11oKse+AwdJLtC1Dj4yBOz5bRotvwKF3e+5eg+zp+CXEW5/XReLbtjtxvgE/mEiaIeF4vixTbRCKYmkvgl0PFqkmBVKVETrT2rZvFe8KoFBPKX02VxE0xSkM9Z2vLOZ3QycBZx4GhDQvyOQS7lbGfe5Lfk7LI7u+0NVSNtFzTdgADTTQDU3tLqnQ/5T6SGueSERyGDZv0UP/hdeJdff0YexrO0JaHDDFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Z7QdwHyte/oTmgA/M4V7iV/JcKvsRwc8mKw1FWY+oU=;
 b=AJ3UOrE5VkFFhXGb6jxUhdnrpMaH+dOtQtYpoLrlrq9uhLz9VDJhKvf1fsSHly7QNd2YZpsDGO9hf2+etGQq7xfogj0zc+TGXvljLLkMy9HFAbxbiOd2Ek13526JsJ7dltWNYzFmlTcHlHpf50tHSJqCsJriVO3L5Rmxd6hUXqrwnJH+RaeRr3c1Fx6/V4IVUP/b8EiXpFpVI0KvYGgMgkwLitAL5t2aI7NM22arf52xCnlmPOjt45GYXnbkHCzwVS9JG0TdmV2fv/sWUIX3gMIfoWxIHwCYVnQclCLBc+c55PU/8EL/KkeC/cBiCUBuaFoUuwChvQaQSh9JbPKBtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Z7QdwHyte/oTmgA/M4V7iV/JcKvsRwc8mKw1FWY+oU=;
 b=ZhYfMp6yjUiDWOQ6BsPZ44JAZjTWq1AMi/0b4YLuV9OrKBrNerxYIexilZjZux9LeREgVwGvPFjYQvm1fILoo24jHAGCRCK7QsO7Z36GuNRM49+Td0kRWVP7ULR2uehCVLmC0xgvAYGnKfZAyOuXUQaSRkRpNKLcG5AJhI1EHuY=
Received: from SI2P153MB0441.APCP153.PROD.OUTLOOK.COM (2603:1096:4:fc::7) by
 SI2P153MB0492.APCP153.PROD.OUTLOOK.COM (2603:1096:4:125::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.14; Fri, 9 Jun 2023 01:15:08 +0000
Received: from SI2P153MB0441.APCP153.PROD.OUTLOOK.COM
 ([fe80::643:ed9:497b:3cac]) by SI2P153MB0441.APCP153.PROD.OUTLOOK.COM
 ([fe80::643:ed9:497b:3cac%4]) with mapi id 15.20.6500.010; Fri, 9 Jun 2023
 01:15:07 +0000
From: Wei Hu <weh@microsoft.com>
To: Long Li <longli@microsoft.com>, "netdev@vger.kernel.org"
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
Thread-Index: AQHZmIoyK0/pJvWPX0+gdBo6594smK9/1dWAgADsBLCAAG/JAIAAe1lA
Date: Fri, 9 Jun 2023 01:15:07 +0000
Message-ID:
 <SI2P153MB04416E4B445A988965398AB5BB51A@SI2P153MB0441.APCP153.PROD.OUTLOOK.COM>
References: <20230606151747.1649305-1-weh@microsoft.com>
 <PH7PR21MB32634CB06AFF8BFFDBC003B3CE53A@PH7PR21MB3263.namprd21.prod.outlook.com>
 <SI2P153MB0441EC655394CEA3E8E727E7BB50A@SI2P153MB0441.APCP153.PROD.OUTLOOK.COM>
 <PH7PR21MB3263782C842638253C1FDB0CCE50A@PH7PR21MB3263.namprd21.prod.outlook.com>
In-Reply-To:
 <PH7PR21MB3263782C842638253C1FDB0CCE50A@PH7PR21MB3263.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6ddf424f-7835-43f4-b969-27a83fd42970;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-06-07T20:49:00Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2P153MB0441:EE_|SI2P153MB0492:EE_
x-ms-office365-filtering-correlation-id: 519510b9-cf64-438a-3585-08db6886f68a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 AzXRPeZsGLMLQg3fdszXTOfnISNKFvK1jUGrX2A2dBZFcdI414lU5if9cNUKZ30ijKyY5GuTM04ekeFyj+xWICCO6zUM8KKSFml9PasH/AR8iq01kOO+CRdQ2OZsNM3hN+fbgOY4QczFb7tpzZ2f0X+fBP0RTpNo8aYtil1/x19mnXR6QR2H7nOd0XoS7dkOTd7V0kncOyukVk1iJBw/Z3MwH5eqah8WFUTkulNNZF/NCKHT+VtI5EpKo9UicXijbTIGQZZRp+Ho7xLTW7FeIB13RnkHZhvwtGLpCeWn/M6wqi12A6vEES1cWb3o6CAo9DhK33D/xPFjp8HcjTxBwvNJwF0YcH+cU2SWdyyeJWA11xZD+IMeN6N1w9Uxy5NetcR3UV1LE2lkUBb1vErexnDX+v9sCHyDTZMSVypCFPPeA6lo6R8Y2MXvXx3VYJai1YndpDZ/sjjik8xL+IQkuoUsaQTfKmpNEiWBySOT8QL8p5wIuzbhBelcyPui4sEjHSyuATogZrlcYlK+dePVD96sWD+vgpvSOiAqzi90LY+5ertXa6iATO1zSeWbIs7kKPjdeGg8GDjwW6LnJ74JmAC+orYCNQWM3QHvuT13ZCcrRNA40f8woJ9Omc27DjUm3JS9hhtCMBcWARW2nK0iD6uOCl/ODPi71LzWdRaMysst4rfDx0o7zglAIQjLEIM/
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2P153MB0441.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(136003)(396003)(366004)(376002)(451199021)(8990500004)(2906002)(38070700005)(7416002)(33656002)(5660300002)(52536014)(86362001)(66899021)(55016003)(7696005)(71200400001)(83380400001)(186003)(6506007)(53546011)(26005)(9686003)(122000001)(921005)(478600001)(82950400001)(82960400001)(110136005)(66476007)(66446008)(316002)(66946007)(66556008)(64756008)(38100700002)(76116006)(41300700001)(10290500003)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?wPpNBy+wo09yTedafsff00Vp87HQooLNO11Sx57MEqwhHxKWnW9nPVEU9x13?=
 =?us-ascii?Q?3ZE932YsCTHyB5NoI9hTmb0wJwvR2QOEd67ywJD8oLVew/1u8mNTFXV/r/RC?=
 =?us-ascii?Q?n7qEwIzdmWVYSIbAbR9KbFVIktIih8NmVhw9UqXfBjadBTbC4SI2OIjERvgK?=
 =?us-ascii?Q?Mkx+QBLk6bY2e/CUoZfn7UeAdnoU4cabFkFQI5GJN61FQg+UDVqMzFW7rYjV?=
 =?us-ascii?Q?6sMi7Uti174Mjankj+vLMLr1hml0Wj3c/YAPzyQQVPCLuNHzqp4bs9H4VzpD?=
 =?us-ascii?Q?/G7z0h39s6LP8Hw428t7oMcEdvrj9WVtNEABtesMOEsm4HO/nGazHun5ZT1s?=
 =?us-ascii?Q?N0aA3BIUIMlO8GKZOrHw88XqlCNESfxRDCaqKL1d/sWNMM0IVA3yiHOFryea?=
 =?us-ascii?Q?FBdaevwuq8UfOVzYjRcV22J6Co+dmDIar4z7hXdttscnV/nXqSGx2F0bPQGc?=
 =?us-ascii?Q?GFVdrEmMdi5Nw20Y1NdJOIw4GUjIEsuKlW15GClTbYm+KqNYJF5JHGU+ykAl?=
 =?us-ascii?Q?lYwGyddKClSfU0rFqgqGNOsGTC3HWnoG6mj3wCFFDeHWR35Awh0el4jFuaYy?=
 =?us-ascii?Q?k+jJnfE27Qxb9fotB7fFbwNyqYnXpQZ108HHXAvUKLts1If2alcc6wcTLEV6?=
 =?us-ascii?Q?04jLakpM0kpKy4rSS+YRdzLAJkQi5IpnjxLUZ9mNjQwQq7U536Bps5kQMVF7?=
 =?us-ascii?Q?hFyJ1K8vCoAlsOLUtPqy1XkUXGQVbL8vImagl236FNv0UW3PGG3joAZ1OSLG?=
 =?us-ascii?Q?mGlcSkdqumgzhEkVEO3IuIvZ2DC8Q6c31L4VjeRJiXDGmul/TStH7VT/vynw?=
 =?us-ascii?Q?cLFxjjzigBQHXGg5lu1byeGjoinzuZfwGftC00HjjDyJGvqAF3AmRIiMtDRr?=
 =?us-ascii?Q?Vxr60EXnhOI6K+bmwW8r0ktp2PvIQ5CsATCc9mP18TTbbQcWe5EoVBCaKHu+?=
 =?us-ascii?Q?ExYuX/HNvyO+BEeQdp6VP+Zsr2sN/dslavagc9TrT4gKOL+jpvlUe2ru99mt?=
 =?us-ascii?Q?rpdnMAExEAUPyvfAnTnE1CSoiHyDOiERIkcaSu8BDJdBMIefCI+/HFFBdlmG?=
 =?us-ascii?Q?dgu1ztJpqPQ9A2ZDHeObGO0l6mdPGuMs92u11RV8S2o8oOpG4acWY/9sgyih?=
 =?us-ascii?Q?/PcT+MLU96JP+L9kp72jKvBQJ1EzxGxpf0ud3dt7XeyDxFc3QEtxzGr+nJrq?=
 =?us-ascii?Q?hXlrEXdZasZJLcU33gXhPSHsiGjaH69lm7LujNpf+UyhWir5OlFe0/OZzg/W?=
 =?us-ascii?Q?N0iZTImAL58idmV5wzicg4SzptPEJc2fQlztrG3tqOXcOOQAjLxL8QziaQav?=
 =?us-ascii?Q?3JtsWQpnso1XZ3GIzqvXpqgzfR8bdDW4dfR/ar9mHGxbG+lAZEhAM8n4c9o0?=
 =?us-ascii?Q?eianKMIPb8jjeqevdAX1HNb5r6fvtUly5bcGlTNBFoR2dCjn/lSn7Ov/Vc7y?=
 =?us-ascii?Q?5Eay+GKKrgcpifmc+WRKNDl6k7FJu3uzlJ3kl39h4ezRLX4pv6ugjxx19Hhr?=
 =?us-ascii?Q?Oo9GJy6RKhbMz3wy2zJuUnuBSExJSI1QUE+FcsTzxe33gcXJAVk3ppjhZ8m3?=
 =?us-ascii?Q?0WYhqI61t/e7h2Zppmg=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: SI2P153MB0441.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 519510b9-cf64-438a-3585-08db6886f68a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2023 01:15:07.3731
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I7zopuQ0+LUEo4u1thSSKx9OM3OmRG9Qsdxs8JZsBkopuxGSKHPrMx+ZYFM/9uUAa1vrOlfg/WWYRl+yImgjiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2P153MB0492
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Long Li <longli@microsoft.com>
> Sent: Friday, June 9, 2023 1:48 AM
> To: Wei Hu <weh@microsoft.com>; netdev@vger.kernel.org; linux-
> hyperv@vger.kernel.org; linux-rdma@vger.kernel.org; Ajay Sharma
> <sharmaajay@microsoft.com>; jgg@ziepe.ca; leon@kernel.org; KY
> Srinivasan <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>;
> wei.liu@kernel.org; Dexuan Cui <decui@microsoft.com>;
> davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> pabeni@redhat.com; vkuznets@redhat.com; ssengar@linux.microsoft.com;
> shradhagupta@linux.microsoft.com
> Subject: RE: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to
> mana ib driver.
>=20
> > Subject: RE: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to
> > mana ib driver.
> >
> >
> >
> > > -----Original Message-----
> > > Subject: RE: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support
> > > to mana ib driver.
> > >
> > > > Subject: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to
> > > > mana ib driver.
> > > >
> > > > Add EQ interrupt support for mana ib driver. Allocate EQs per
> > > > ucontext to receive interrupt. Attach EQ when CQ is created. Call
> > > > CQ interrupt handler when completion interrupt happens. EQs are
> > > > destroyed when
> > > ucontext is deallocated.
> > > >
> > > > The change calls some public APIs in mana ethernet driver to
> > > > allocate EQs and other resources. Ehe EQ process routine is also
> > > > shared by mana ethernet and mana ib drivers.
> > > >
> > > > Co-developed-by: Ajay Sharma <sharmaajay@microsoft.com>
> > > > Signed-off-by: Ajay Sharma <sharmaajay@microsoft.com>
> > > > Signed-off-by: Wei Hu <weh@microsoft.com>
> > > > ---
> > > >
> > > > v2: Use ibdev_dbg to print error messages and return -ENOMEN
> > > >     when kzalloc fails.
> > > >
> > > >  drivers/infiniband/hw/mana/cq.c               |  32 ++++-
> > > >  drivers/infiniband/hw/mana/main.c             |  87 ++++++++++++
> > > >  drivers/infiniband/hw/mana/mana_ib.h          |   4 +
> > > >  drivers/infiniband/hw/mana/qp.c               |  90 +++++++++++-
> > > >  .../net/ethernet/microsoft/mana/gdma_main.c   | 131 ++++++++++---
> ----
> > -
> > > >  drivers/net/ethernet/microsoft/mana/mana_en.c |   1 +
> > > >  include/net/mana/gdma.h                       |   9 +-
> > > >  7 files changed, 290 insertions(+), 64 deletions(-)
> > > >
> > > > diff --git a/drivers/infiniband/hw/mana/cq.c
> > > > b/drivers/infiniband/hw/mana/cq.c index
> d141cab8a1e6..3cd680e0e753
> > > > 100644
> > > > --- a/drivers/infiniband/hw/mana/cq.c
> > > > +++ b/drivers/infiniband/hw/mana/cq.c
> > > > @@ -12,13 +12,20 @@ int mana_ib_create_cq(struct ib_cq *ibcq,
> > > > const struct ib_cq_init_attr *attr,
> > > >  	struct ib_device *ibdev =3D ibcq->device;
> > > >  	struct mana_ib_create_cq ucmd =3D {};
> > > >  	struct mana_ib_dev *mdev;
> > > > +	struct gdma_context *gc;
> > > > +	struct gdma_dev *gd;
> > > >  	int err;
> > > >
> > > >  	mdev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
> > > > +	gd =3D mdev->gdma_dev;
> > > > +	gc =3D gd->gdma_context;
> > > >
> > > >  	if (udata->inlen < sizeof(ucmd))
> > > >  		return -EINVAL;
> > > >
> > > > +	cq->comp_vector =3D attr->comp_vector > gc->max_num_queues ?
> > > > +				0 : attr->comp_vector;
> > > > +
> > > >  	err =3D ib_copy_from_udata(&ucmd, udata, min(sizeof(ucmd), udata-
> > > > >inlen));
> > > >  	if (err) {
> > > >  		ibdev_dbg(ibdev,
> > > > @@ -69,11 +76,32 @@ int mana_ib_destroy_cq(struct ib_cq *ibcq,
> > > > struct ib_udata *udata)
> > > >  	struct mana_ib_cq *cq =3D container_of(ibcq, struct mana_ib_cq, i=
bcq);
> > > >  	struct ib_device *ibdev =3D ibcq->device;
> > > >  	struct mana_ib_dev *mdev;
> > > > +	struct gdma_context *gc;
> > > > +	struct gdma_dev *gd;
> > > > +
> > > >
> > > >  	mdev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
> > > > +	gd =3D mdev->gdma_dev;
> > > > +	gc =3D gd->gdma_context;
> > > >
> > > > -	mana_ib_gd_destroy_dma_region(mdev, cq->gdma_region);
> > > > -	ib_umem_release(cq->umem);
> > > > +
> > > > +
> > > > +	if (atomic_read(&ibcq->usecnt) =3D=3D 0) {
> > > > +		mana_ib_gd_destroy_dma_region(mdev, cq->gdma_region);
> > >
> > > Need to check if this function fails. The following code will call
> > > kfree(gc-
> > > >cq_table[cq->id]), it's possible that IRQ is happening at the same
> > > >time if CQ
> > > is not destroyed.
> > >
> >
> > Sure. Will update.
> >
> > > > +		ibdev_dbg(ibdev, "freeing gdma cq %p\n", gc->cq_table[cq-
> > > >id]);
> > > > +		kfree(gc->cq_table[cq->id]);
> > > > +		gc->cq_table[cq->id] =3D NULL;
> > > > +		ib_umem_release(cq->umem);
> > > > +	}
> > > >
> > > >  	return 0;
> > > >  }
> > > > +
> > > > +void mana_ib_cq_handler(void *ctx, struct gdma_queue *gdma_cq) {
> > > > +	struct mana_ib_cq *cq =3D ctx;
> > > > +	struct ib_device *ibdev =3D cq->ibcq.device;
> > > > +
> > > > +	ibdev_dbg(ibdev, "Enter %s %d\n", __func__, __LINE__);
> > >
> > > This debug message seems overkill?
> > >
> > > > +	cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context); }
> > > > diff --git a/drivers/infiniband/hw/mana/main.c
> > > > b/drivers/infiniband/hw/mana/main.c
> > > > index 7be4c3adb4e2..e4efbcaed10e 100644
> > > > --- a/drivers/infiniband/hw/mana/main.c
> > > > +++ b/drivers/infiniband/hw/mana/main.c
> > > > @@ -143,6 +143,81 @@ int mana_ib_dealloc_pd(struct ib_pd *ibpd,
> > > > struct ib_udata *udata)
> > > >  	return err;
> > > >  }
> > > >
> > > > +static void mana_ib_destroy_eq(struct mana_ib_ucontext *ucontext,
> > > > +			       struct mana_ib_dev *mdev) {
> > > > +	struct gdma_context *gc =3D mdev->gdma_dev->gdma_context;
> > > > +	struct ib_device *ibdev =3D ucontext->ibucontext.device;
> > > > +	struct gdma_queue *eq;
> > > > +	int i;
> > > > +
> > > > +	if (!ucontext->eqs)
> > > > +		return;
> > > > +
> > > > +	for (i =3D 0; i < gc->max_num_queues; i++) {
> > > > +		eq =3D ucontext->eqs[i].eq;
> > > > +		if (!eq)
> > > > +			continue;
> > > > +
> > > > +		mana_gd_destroy_queue(gc, eq);
> > > > +	}
> > > > +
> > > > +	kfree(ucontext->eqs);
> > > > +	ucontext->eqs =3D NULL;
> > > > +
> > > > +	ibdev_dbg(ibdev, "destroyed eq's count %d\n", gc-
> > > >max_num_queues); }
> > >
> > > Will gc->max_num_queues change after destroying a EQ?
> > >
> >
> > I think it will not change. Also the compiler might optimize the code
> > to just read the value once and store it in a register.
> >
> > Thanks,
> > Wei
>=20
> This message is confusing. How about changing it to " destroyed eq.
> Maximum count %d", or just remove the count as it's not informational.
>=20
> Long

Sure. I will remove the count from the message.

Thanks,
Wei

