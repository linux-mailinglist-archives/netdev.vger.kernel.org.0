Return-Path: <netdev+bounces-9197-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB061727E96
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 13:17:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 923712815DE
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 11:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8298B10969;
	Thu,  8 Jun 2023 11:17:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D90963CF
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 11:17:47 +0000 (UTC)
Received: from HK2P15301CU002.outbound.protection.outlook.com (mail-eastasiaazon11020026.outbound.protection.outlook.com [52.101.128.26])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC2D269E;
	Thu,  8 Jun 2023 04:17:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IdwgGXtex9WjqGMEoCaIcnOlGuCtdT8tnW/nxqkqCrmsJ3lmy3ZZS8wKZMeDGUN1EzB+jgYjf8FPgtFMDdNWmpfoYS6+1TmXa19Md6ApHgZnQseYy5Q10sxrAjp8/0oS9JLeaS3Us46i3CSEAbf45Vo/Iw+EXmFIk4eIdfClPNdWVmFFLnxImltkYqW+HYEp2JxeKSjgyimryDFse8YZdj1UP/+y5q9SfGswoGCnAGyhN8O25eV2XGKZvrRQN+IGuyarMZEx7Gms/GKcnNp5ESP3ofbR9BgYxgUIyvewi4FZhyl5yl5J4buLPyZz0Bx0NLZaFrqfUNjQzlkDA5wk3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Zm1s6F7eo47iEv+x7F/yOtuW/oF/LoZd2EKtmZhXO4=;
 b=Xoc/tITRqF5eHjhEiOiU9i4etEcwws9VFTVvksPR49kjmJxAWM30aicVveEGkcjz28uI5Hs+0pLsTjV6jnGWqonHqjl4qb8BhCTTgnQ96kkMQmmMSlAU19/imWHwAzVApvKjhaSVFN+Ti+p1B9X/d97YwXmsxHKG1tHO7+wGZcJNMKqCDtdseRYEb5S5YejfaFAnCqfNZVJjdZ9geZrhXZW3oIDtCt0yx7iBb2gfPbv7fwYwqIEpO4Zca4pvtkrXpMB0+SE1uiqGI60fJnAoHv8rLfKmLHEwtSZEHT9zq71/MqmmuxC4PLR9l/VaioDSPoXpuZ8JWXszBstR2uv9ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Zm1s6F7eo47iEv+x7F/yOtuW/oF/LoZd2EKtmZhXO4=;
 b=Mg58uQCIfd2nxkRYkADIJAF9f9H1Oe40Hj7o9YqhBj7EoWwCLFLenO2BoY9XmcVo4FS7yesBGDWcgtlcSCRaKsGK0RbobMwzDVmgq0dtukR2iHkLkjXcQhGQ0DVO2o8cR5YCtlYOb1As6kwwIwthtNFXzLFzxnmzm/qsAzz4/wg=
Received: from SI2P153MB0441.APCP153.PROD.OUTLOOK.COM (2603:1096:4:fc::7) by
 TYZP153MB0691.APCP153.PROD.OUTLOOK.COM (2603:1096:400:25f::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.14; Thu, 8 Jun 2023 11:17:40 +0000
Received: from SI2P153MB0441.APCP153.PROD.OUTLOOK.COM
 ([fe80::643:ed9:497b:3cac]) by SI2P153MB0441.APCP153.PROD.OUTLOOK.COM
 ([fe80::643:ed9:497b:3cac%4]) with mapi id 15.20.6500.010; Thu, 8 Jun 2023
 11:17:40 +0000
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
Thread-Index: AQHZmIoyK0/pJvWPX0+gdBo6594smK9/1dWAgADsBLA=
Date: Thu, 8 Jun 2023 11:17:40 +0000
Message-ID:
 <SI2P153MB0441EC655394CEA3E8E727E7BB50A@SI2P153MB0441.APCP153.PROD.OUTLOOK.COM>
References: <20230606151747.1649305-1-weh@microsoft.com>
 <PH7PR21MB32634CB06AFF8BFFDBC003B3CE53A@PH7PR21MB3263.namprd21.prod.outlook.com>
In-Reply-To:
 <PH7PR21MB32634CB06AFF8BFFDBC003B3CE53A@PH7PR21MB3263.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6ddf424f-7835-43f4-b969-27a83fd42970;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-06-07T20:49:00Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2P153MB0441:EE_|TYZP153MB0691:EE_
x-ms-office365-filtering-correlation-id: 9e2a79df-1dff-4aa9-63f3-08db6811f8dc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 IgzL+J9ylANc2jJsl7M0+GoA9Q90thA+t5saRF8hfdV5hpL4S0w2Ckri2EFZ0FdX2Qp7PjuOqWUDZv3wxlYaF9vZuDTyuXYjM3nx1he6C5BQk6SMTqDtE+KxCjrJJ1c226bxiT9EBdnsOCdzNfCwyRELxRsJiTl4/h5dyyJSfC3TAyKVsuiMPujA2MVz5lklIq0imFgvp6+fjK340yvbQVUsCwT0/ZfUX4wFjdDaPv2Fp8fdESJEk9/Yk93dy4IwNRlJhTaRBRaxS5kl6Vea+1KAg0/5iXBp7NGfR17cpbxE+PG48bQv6dh3zmt7CpYmtyl82+jcB0Clo7XRukoDZbVPPGQq0VYXGWGUpfesLVBGglgGsNT3BWtEFN1U6afFHHo+S4lsVvvT9XF6Kl2zSblCXwEKGoCG5GKZYgMcKmFK1IecpHt1QwzojpMkIbUO6kt9hh0frlB/ymZDey8COnMlBqn9fohI2FkFZrlcgDluAX3uXUEAiwH3TI76AhcMGmGrbrvFT6th34ILDTSM6eQNj1Ex53CIL+rxgMbX8V/bhFiCQDMLvwUcYdubulyM9Bkwj9ePrpFIyCPhjnKMXHzjgxmSNaS6SpJKB6G30F+xq9AX7CwLmhsdKLMGz7xRJOp2EaIHpg6F7Y+RZNHOPRWiirrGk72p4wWE9YkJVVH+yHCEo4sm7QTt1DOzci9J
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2P153MB0441.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(376002)(396003)(346002)(136003)(451199021)(83380400001)(7416002)(82950400001)(110136005)(82960400001)(55016003)(10290500003)(478600001)(33656002)(8676002)(8936002)(41300700001)(38070700005)(316002)(76116006)(66946007)(66476007)(66556008)(52536014)(66446008)(921005)(122000001)(64756008)(5660300002)(38100700002)(86362001)(7696005)(71200400001)(2906002)(186003)(6506007)(9686003)(66899021)(8990500004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?lWnyk7aoiCqohg05Nk3wLejBt9dOhlLzEHfR2fZhBI6M0M8HzLwa7xBTHx1R?=
 =?us-ascii?Q?Gw6t5fjEopXFa4bhh58jF3XPgj2NBb493a+GXry1Xw5JzkUngIC/rmRJWH2v?=
 =?us-ascii?Q?kQ6rm6K9MGv2/QNNc1q+4elnP5yikWNoZAjDWRAI4U0rRrJKgt51J1M8yn09?=
 =?us-ascii?Q?aLZif3bjZ1/eoWNNrzYj25BbZ7dE4DKC38VVfs/YXP7bq/XimCp+UmoSkMS7?=
 =?us-ascii?Q?l87Q9Iou7drteiuFPCKHgWMABrQY5Ckf3MCpPp5DPuJVgaAjy3h39K0WQ3NE?=
 =?us-ascii?Q?mvuvvWYC1LzhBiN9oWXhO7CYAUyZTcqtiXQN5QVgM5F58gI1pZfn6nj9iro0?=
 =?us-ascii?Q?lrTs+dM97kvNYAPnVAXenTnGjc4tW7LOIdyVLTc0h59UNE9F5Jyftgt1HvGI?=
 =?us-ascii?Q?8rOgsi3z9YIa6bAU7sOYpNhi94P0mGA/wH8e/gkPMNljgzKaEtEpqYkGcJe+?=
 =?us-ascii?Q?S6cCxYindqvQrf/w+lr5Zow5SCGxaAZUlwBpCaXp83GlBFhq1MK5UYZ83B8q?=
 =?us-ascii?Q?K9vrXRQjhOJBEbAoSdw9meSaF4zVytlXzv8ly7ZAGJLKr4YS2LBfXt6/2Ldj?=
 =?us-ascii?Q?Lp4MO8M52YaKw/Scjz9dn+DeBfKTMGFV2VHoQAqBoOadfFLfY++Xu99ae1aI?=
 =?us-ascii?Q?cx5gjLaJPYZN1bKv/WEGzFxmVljF8WDveptDGWgJBxS1uoNBbCFxybCV0DXV?=
 =?us-ascii?Q?kw53LG5bIk4jyAQvpzW2KKkiVPBqeEwwccUiRNB//JVNOPdh/kyfemAzqHbH?=
 =?us-ascii?Q?Id8sVfecllphW1yoc7fydBLzTbrhZQZQ6omfUYQm0jNiGg/YVxI+6SJrOnGP?=
 =?us-ascii?Q?oYhnVKNJt1o6o7aUaDu2cJOrGNhWrcPi/VT1+dJlY1Dfsedls4uYvYCC81z9?=
 =?us-ascii?Q?FSWlA4X75nptEincYRIh6sPvOZBoJfmoA+7lVMKDnhKVVq+eADPWkMsOFfrA?=
 =?us-ascii?Q?RuAza69eEVKrdndxbUwr9BF1x4h9e/RadQOXSepXS2+wBHnWHTKW79HvVgSY?=
 =?us-ascii?Q?QqbxbW7vKkD4ubqyLA7TFhjFGXJ7AX3fcGl0LCFGdqxM4JmKG5WJp5Z5XoeD?=
 =?us-ascii?Q?YXTyo/oP8yrPLKrwHWes2Z05uV4jALjpxvjmBleY9SU2waFt+FJeXiMp4d6i?=
 =?us-ascii?Q?QFfz7RnlDDblmzEEL9OjDY0Qh0ul1pQr1Qf45GYUcT/vYSCNwuFx1YY8Qs7s?=
 =?us-ascii?Q?PxDRCHVIweh4CXLWAsTU2f96ji1nI4AUx/uP9CTT+dUUGGV7oOkEti3tW5l9?=
 =?us-ascii?Q?xsnOr2hh2QYkv0qM7Fm+TafF5Wc6onomvVQyyCOkFR0GolUbi5YaEphukgMl?=
 =?us-ascii?Q?5vFSwXshRbpP/XPhchwDn3fE0rSaI22RfHpMSvjfDdAi1fmNJqWkPe/zYbLI?=
 =?us-ascii?Q?k1jhBvqjDWvxsxWRbldJVIRe17UcCZuc/4V2AJmGLKryabZ4vdpaLva7aeWb?=
 =?us-ascii?Q?dCbOff7mS0q5oev/ipBnpXQLaNrGPSiogQYTk5eVtUTpGS3OshVPEeJ77nVo?=
 =?us-ascii?Q?cmXMBSUE4nJ/zn36CHJm7xmZK121F27ZxRe2FigrsjSfKx6PhtI3xCVLQCvL?=
 =?us-ascii?Q?+Rq+kpTxNuaDDVb6e0ZjTU3ppTF+K8DJZ7+nEqIpuYqgVo6nsq5aOV1yMWjo?=
 =?us-ascii?Q?Sg=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e2a79df-1dff-4aa9-63f3-08db6811f8dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 11:17:40.1870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CPBfkeQriP5nDxuvq8xX/4tp7EoeHDnxSBNvO/MLPeu2ay/eXHoASHhteKFel/LKkRT7cgkE647Oq9lOOZPM5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZP153MB0691
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> Subject: RE: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to
> mana ib driver.
>=20
> > Subject: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to mana
> > ib driver.
> >
> > Add EQ interrupt support for mana ib driver. Allocate EQs per ucontext
> > to receive interrupt. Attach EQ when CQ is created. Call CQ interrupt
> > handler when completion interrupt happens. EQs are destroyed when
> ucontext is deallocated.
> >
> > The change calls some public APIs in mana ethernet driver to allocate
> > EQs and other resources. Ehe EQ process routine is also shared by mana
> > ethernet and mana ib drivers.
> >
> > Co-developed-by: Ajay Sharma <sharmaajay@microsoft.com>
> > Signed-off-by: Ajay Sharma <sharmaajay@microsoft.com>
> > Signed-off-by: Wei Hu <weh@microsoft.com>
> > ---
> >
> > v2: Use ibdev_dbg to print error messages and return -ENOMEN
> >     when kzalloc fails.
> >
> >  drivers/infiniband/hw/mana/cq.c               |  32 ++++-
> >  drivers/infiniband/hw/mana/main.c             |  87 ++++++++++++
> >  drivers/infiniband/hw/mana/mana_ib.h          |   4 +
> >  drivers/infiniband/hw/mana/qp.c               |  90 +++++++++++-
> >  .../net/ethernet/microsoft/mana/gdma_main.c   | 131 ++++++++++--------
> >  drivers/net/ethernet/microsoft/mana/mana_en.c |   1 +
> >  include/net/mana/gdma.h                       |   9 +-
> >  7 files changed, 290 insertions(+), 64 deletions(-)
> >
> > diff --git a/drivers/infiniband/hw/mana/cq.c
> > b/drivers/infiniband/hw/mana/cq.c index d141cab8a1e6..3cd680e0e753
> > 100644
> > --- a/drivers/infiniband/hw/mana/cq.c
> > +++ b/drivers/infiniband/hw/mana/cq.c
> > @@ -12,13 +12,20 @@ int mana_ib_create_cq(struct ib_cq *ibcq, const
> > struct ib_cq_init_attr *attr,
> >  	struct ib_device *ibdev =3D ibcq->device;
> >  	struct mana_ib_create_cq ucmd =3D {};
> >  	struct mana_ib_dev *mdev;
> > +	struct gdma_context *gc;
> > +	struct gdma_dev *gd;
> >  	int err;
> >
> >  	mdev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
> > +	gd =3D mdev->gdma_dev;
> > +	gc =3D gd->gdma_context;
> >
> >  	if (udata->inlen < sizeof(ucmd))
> >  		return -EINVAL;
> >
> > +	cq->comp_vector =3D attr->comp_vector > gc->max_num_queues ?
> > +				0 : attr->comp_vector;
> > +
> >  	err =3D ib_copy_from_udata(&ucmd, udata, min(sizeof(ucmd), udata-
> > >inlen));
> >  	if (err) {
> >  		ibdev_dbg(ibdev,
> > @@ -69,11 +76,32 @@ int mana_ib_destroy_cq(struct ib_cq *ibcq, struct
> > ib_udata *udata)
> >  	struct mana_ib_cq *cq =3D container_of(ibcq, struct mana_ib_cq, ibcq)=
;
> >  	struct ib_device *ibdev =3D ibcq->device;
> >  	struct mana_ib_dev *mdev;
> > +	struct gdma_context *gc;
> > +	struct gdma_dev *gd;
> > +
> >
> >  	mdev =3D container_of(ibdev, struct mana_ib_dev, ib_dev);
> > +	gd =3D mdev->gdma_dev;
> > +	gc =3D gd->gdma_context;
> >
> > -	mana_ib_gd_destroy_dma_region(mdev, cq->gdma_region);
> > -	ib_umem_release(cq->umem);
> > +
> > +
> > +	if (atomic_read(&ibcq->usecnt) =3D=3D 0) {
> > +		mana_ib_gd_destroy_dma_region(mdev, cq->gdma_region);
>=20
> Need to check if this function fails. The following code will call kfree(=
gc-
> >cq_table[cq->id]), it's possible that IRQ is happening at the same time =
if CQ
> is not destroyed.
>=20

Sure. Will update.

> > +		ibdev_dbg(ibdev, "freeing gdma cq %p\n", gc->cq_table[cq-
> >id]);
> > +		kfree(gc->cq_table[cq->id]);
> > +		gc->cq_table[cq->id] =3D NULL;
> > +		ib_umem_release(cq->umem);
> > +	}
> >
> >  	return 0;
> >  }
> > +
> > +void mana_ib_cq_handler(void *ctx, struct gdma_queue *gdma_cq) {
> > +	struct mana_ib_cq *cq =3D ctx;
> > +	struct ib_device *ibdev =3D cq->ibcq.device;
> > +
> > +	ibdev_dbg(ibdev, "Enter %s %d\n", __func__, __LINE__);
>=20
> This debug message seems overkill?
>=20
> > +	cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context); }
> > diff --git a/drivers/infiniband/hw/mana/main.c
> > b/drivers/infiniband/hw/mana/main.c
> > index 7be4c3adb4e2..e4efbcaed10e 100644
> > --- a/drivers/infiniband/hw/mana/main.c
> > +++ b/drivers/infiniband/hw/mana/main.c
> > @@ -143,6 +143,81 @@ int mana_ib_dealloc_pd(struct ib_pd *ibpd, struct
> > ib_udata *udata)
> >  	return err;
> >  }
> >
> > +static void mana_ib_destroy_eq(struct mana_ib_ucontext *ucontext,
> > +			       struct mana_ib_dev *mdev)
> > +{
> > +	struct gdma_context *gc =3D mdev->gdma_dev->gdma_context;
> > +	struct ib_device *ibdev =3D ucontext->ibucontext.device;
> > +	struct gdma_queue *eq;
> > +	int i;
> > +
> > +	if (!ucontext->eqs)
> > +		return;
> > +
> > +	for (i =3D 0; i < gc->max_num_queues; i++) {
> > +		eq =3D ucontext->eqs[i].eq;
> > +		if (!eq)
> > +			continue;
> > +
> > +		mana_gd_destroy_queue(gc, eq);
> > +	}
> > +
> > +	kfree(ucontext->eqs);
> > +	ucontext->eqs =3D NULL;
> > +
> > +	ibdev_dbg(ibdev, "destroyed eq's count %d\n", gc-
> >max_num_queues); }
>=20
> Will gc->max_num_queues change after destroying a EQ?
>=20

I think it will not change. Also the compiler might optimize
the code to just read the value once and store it in a register.

Thanks,
Wei

