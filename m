Return-Path: <netdev+bounces-8488-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 09C9D72443F
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:22:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA470280E99
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 031FB1991A;
	Tue,  6 Jun 2023 13:22:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E5B37B84
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:22:25 +0000 (UTC)
Received: from HK2P15301CU002.outbound.protection.outlook.com (mail-eastasiaazon11020023.outbound.protection.outlook.com [52.101.128.23])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8371F10F4;
	Tue,  6 Jun 2023 06:22:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+RnA4kYSOIKdzt7o9R+cj7O5NtVBulMVZUJApvteXxREsvlBvD5kK9UcEXR4luD4kHwD2+qjztVsZANJoDfRw6F/THwyecn2MCeYNWl4NKd1XP7pZ9rK6OYhqXc9K8uv5LVSJss1AuYfeG3UvQa/Tc9AYYzgJCzxWDTp81MbQyvJXLOjGRUXBpBXrP9SygY0vz82CarWQ9dAwON5JqDZHtBqxm6qebB+pRIZod3CIRj/5GXgzUyxPIxwRATSRHG60STskDUBFJV/JxneyUOWsZRVv+5JUzhqEB/k4IEITcWh75s/JThwwbZSXaaFBIeeM9drqe0rgCHI/5bmLjoKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=askEd4tPnhNKwYzIxKC584lutm6JjYMztNJopJpCYjg=;
 b=DLosKR29Hwdmoo/jAF4UQeAvntcjcBb+MOwn2gYxWKOTMHBn8XB4edSOy1bu+nX95Nls0l38vSBS2SE+kkSYzuWuZvxqvmJ+VreU0t1E/Afqv0hPLiC9/xns4RiYyep1Ba55IgNSUiMobNfQWoqloIPIsPP/uV9ErLlYGLKVD5zG36fJ34BW7i3MTY0AZnxZ5FMzjfGpQlx7jNyF+j1U2ThiIFDFhV3TQQzbZmaz7UvAz4E47yjDe8Lwmp4lVb1eiWFrYO02hHJwCaUYQbIfDeBeYA7AGQ3i/qMIWSdTd32zIQR/d1ozRWrVaDWgRB0FBvErYFhWF5kIcbATHcLgWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=askEd4tPnhNKwYzIxKC584lutm6JjYMztNJopJpCYjg=;
 b=bi2iKAfD/Nly0YiGh43ZU/Cf0yLss2LnUbPm3+Y/IRCx9H4kxxsCDmew+MIyjiehn+ws/r12OYl1pVcbpkluFGHtMx5EVvQ4offNUAbs0mSjK+4mIZiy83tfAxqhyD3A4MYmuD5+jKWaH5O7pgzW4S+ue3G8uJIt7cFhLE1/zTE=
Received: from SI2P153MB0441.APCP153.PROD.OUTLOOK.COM (2603:1096:4:fc::7) by
 PSAP153MB0407.APCP153.PROD.OUTLOOK.COM (2603:1096:301:3f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.6; Tue, 6 Jun 2023 13:22:05 +0000
Received: from SI2P153MB0441.APCP153.PROD.OUTLOOK.COM
 ([fe80::643:ed9:497b:3cac]) by SI2P153MB0441.APCP153.PROD.OUTLOOK.COM
 ([fe80::643:ed9:497b:3cac%4]) with mapi id 15.20.6500.004; Tue, 6 Jun 2023
 13:22:05 +0000
From: Wei Hu <weh@microsoft.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Simon Horman <simon.horman@corigine.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Long Li
	<longli@microsoft.com>, Ajay Sharma <sharmaajay@microsoft.com>,
	"leon@kernel.org" <leon@kernel.org>, KY Srinivasan <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>, "wei.liu@kernel.org"
	<wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "ssengar@linux.microsoft.com"
	<ssengar@linux.microsoft.com>, "shradhagupta@linux.microsoft.com"
	<shradhagupta@linux.microsoft.com>
Subject: RE: [PATCH 1/1] RDMA/mana_ib: Add EQ interrupt support to mana ib
 driver.
Thread-Topic: [PATCH 1/1] RDMA/mana_ib: Add EQ interrupt support to mana ib
 driver.
Thread-Index: AQHZl6MEYQOQI2AZg0S5+bBNRMAAY698MDaAgAAFm4CAAY3uYA==
Date: Tue, 6 Jun 2023 13:22:04 +0000
Message-ID:
 <SI2P153MB0441A313EDAF9B7A70A11ADDBB52A@SI2P153MB0441.APCP153.PROD.OUTLOOK.COM>
References: <20230605114313.1640883-1-weh@microsoft.com>
 <ZH3f2abyRU1l/dq6@corigine.com> <ZH3kjU7a2L7EkEQ2@ziepe.ca>
In-Reply-To: <ZH3kjU7a2L7EkEQ2@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=2587b6bb-83dd-492a-98a5-b87b392e7161;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-06-06T13:19:23Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2P153MB0441:EE_|PSAP153MB0407:EE_
x-ms-office365-filtering-correlation-id: e0bed9a9-89a7-4daa-97ae-08db6691050b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 gvE6RvMEY/jsRkUmMJXlTXLxgrtANS+Yl8Pit7FGucvBtbGNPhaKsLV82j+EwmXtFMYXjtbv8m8/yFog3eq8eK1Ma3c9+CqQ8f9tirnsS5dEE/zWDe2VLAV/jdPfuOwYcD7LMyc7hSqJnjshOi8oXnqYhSoILaoG+Yvdh6L6/z3++II1U7LSIXxRqKxsd+RT2cdd13LGWSJxwmkw1c7JogYwAwFnJrDzI/vtFUJJzEF8v8QBHbAAxqDbwk8Z6BfAMXHl05dAK3hOWhZ7swC3l2IBKu2RIbRkmbknmcO/CL4nWzxpJDnB69NuAclaoHO1X2qfSwLIP+QXeUY4oYZgOcJhoXW8vGruvxo4F2RHqhIwUJ2ie0Gq/RZ0f2ObhRuhkUmzve+UOHWWCfNLVHXwAA51HHbVcMc2ENVAyFCl/tlQpfrRoeQEr/d5hdP6N0vbzOoRntUqIeQ/M3ZMClN8Pg0MDsWuqhbu1aY2j+ZIupFRPqd9uGZJN8W9vr6mXIzGv1XTPGYNLI/PcPnDHIP5c/W6VDLK/mj34CmE2iBia4xD1zM/7KaszyYVdB5na9CAA+J0FoWAQFPcWT39qJbLr3iL68KpJjlXTrny7GREk6dE+xv8QpkSdCj5/wUd2INZ1oDQ0oAVdTy834o0Nyme3J+HrAAzlMJfOJR6iQBytEo=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2P153MB0441.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(136003)(346002)(39860400002)(396003)(451199021)(10290500003)(478600001)(2906002)(7696005)(33656002)(71200400001)(107886003)(8990500004)(82960400001)(38070700005)(83380400001)(6506007)(26005)(86362001)(53546011)(122000001)(82950400001)(9686003)(38100700002)(186003)(5660300002)(316002)(7416002)(8676002)(8936002)(66946007)(76116006)(66556008)(4326008)(66476007)(66446008)(64756008)(52536014)(55016003)(110136005)(66899021)(54906003)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?0RForaTjys/Ny3FxRgaTmm/zF/X9+yElFfEM/0T0MDJoAMxn9nZLsRYq9iIO?=
 =?us-ascii?Q?NvNXYsC3QzfSKHfXy9U8RqkFIVJwLM5MjWJ/yHb9VatffE98p+S7CljiwAGJ?=
 =?us-ascii?Q?kkCMrU7zKwT6elnEIw5yc7UujIrfLxGE4vqvyZZN0Nacp+LfRjVJMGHgVLc6?=
 =?us-ascii?Q?Dg43VYlKvOvKb2WUXnWwqiaCFyOynW9zQ3wFn0h7DX9JL0Fad/+d2ZwsN6Zw?=
 =?us-ascii?Q?pVUBJNqtZzK3pFDIsNf6HNxs/B6/mqx5sbMlkwclfygfxQSbT82FaA7YH9cp?=
 =?us-ascii?Q?m1SbfUszdlw1TenI5fPRn/uktIVMTqzvLL6iWL5/RTzt3JHsBr7Nr+/iK5EZ?=
 =?us-ascii?Q?Yza0IWgn6hE+YDoMwG/f3VCoQAPY2WQ658jiexAkQdlJ/dwryyMH9wN0HGkM?=
 =?us-ascii?Q?GG2bGX7bwRt8Yk/i7769sjWuyOzZNSw5NMSVX4/3ndsaY+AuXnI06JlIL3EK?=
 =?us-ascii?Q?NfVPFV+S2sCIxHBMlxXR+BZ+Ea8AFN4hDSepr+gPaMmgDWOjV4VXMrSxLhSc?=
 =?us-ascii?Q?bbKrsyBgLzZKxFV1A1eIPBWYnbw7AgdZdKbYf0Aon3f6gGl/aFQfY9JLn8Tj?=
 =?us-ascii?Q?wDM3WNGhjEyQtnFyYidf14xp0vnJx76qMLLFjyb7xW+Qpy1dpOw9Neg50xkx?=
 =?us-ascii?Q?2e7s9GQokT6ntL6m2N3iWMPeMxjg1PT9GXsas1kXrcYTKE4yN68jq9+cYEGj?=
 =?us-ascii?Q?+Fqk+YGU5IhDmfsKftafM5qtugYhN+cu7ecN0Cp9nD1zS7/qynWNsgdI4eUz?=
 =?us-ascii?Q?yLwpvfiigaPS96odIOn/nqlRPk4w6GYCp59jtfdXWnq7Z0TVGUvp9AdhJSYh?=
 =?us-ascii?Q?xBV0e9LrPwIiqivhncsm/J5Xiki7A/uxDFDEA0THQ7eQ4ekPbYMfixEdxvlG?=
 =?us-ascii?Q?P36LuwRXViM9Ur4KlnY18juifLElvQuHCLNr4esCucy426pSlrIkin4NwDb8?=
 =?us-ascii?Q?86kExcDZe7ekMNjzJmXc1CI3OWSzJPFqpPQZGWm2AwtofSexGLtNY8EdRiFS?=
 =?us-ascii?Q?HZ/EoHigdmKeGt3IctOZTVJE3CNvJznqYSuRvSSmJiT0Ab3zQxAlDjzfc7gT?=
 =?us-ascii?Q?kmcODZ3gAhgdmnFvpC5Uz9WAXH74jlmyE8xhrtc8e6Fbp610kVu5B+LZ7AAa?=
 =?us-ascii?Q?VOoHG2GOoGb6llvK4fD3TpgoXFG6jHPeCoirEnTxpzpDC3atd0/imKxx1SJP?=
 =?us-ascii?Q?MR08Xvb0fuUPaMORArUqcCFb5QCDM7FyPI/ekAdoh/qBjtS6qiETeZzwg8C3?=
 =?us-ascii?Q?x2acYEHfzaW1CwWiVm66LyIgAyDi2FUViNGXIfm5JI/1aYnQRRJ+rIcut6iy?=
 =?us-ascii?Q?OsQbTN8Nxj26hnntpr+FKJlJ/YJWwDv4ZAydxBniqQLDHag7nk0w0323W4mP?=
 =?us-ascii?Q?XvF+tYOus7fuiR6RT+Z+5t4/CATStmzscU7NpJaQKunxJBibs3+CFqzpbHTY?=
 =?us-ascii?Q?LE20343TbVhezc1RvzGwwQiCXoLNGs2DhuDGMdx0yPIrj/l+qfGzVi+4YkM7?=
 =?us-ascii?Q?eWyLWsKdDpVwGfzAXLRU5oq5ESSr7iCu5u410kFlI90neFdUq82y2HKQ/fxs?=
 =?us-ascii?Q?w4oJuorwrnAtZB6bqaM=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e0bed9a9-89a7-4daa-97ae-08db6691050b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 13:22:04.3937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I53zW1vRmBNL9QhVvwU1YEdaarmrPZ7SnvnkugoXeZVyC0twKU52kZH6yhMi0kU43E31gzEmB7z4TvYu/ornZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAP153MB0407
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Monday, June 5, 2023 9:35 PM
> To: Simon Horman <simon.horman@corigine.com>
> Cc: Wei Hu <weh@microsoft.com>; netdev@vger.kernel.org; linux-
> hyperv@vger.kernel.org; linux-rdma@vger.kernel.org; Long Li
> <longli@microsoft.com>; Ajay Sharma <sharmaajay@microsoft.com>;
> leon@kernel.org; KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; wei.liu@kernel.org; Dexuan Cui
> <decui@microsoft.com>; davem@davemloft.net; edumazet@google.com;
> kuba@kernel.org; pabeni@redhat.com; vkuznets@redhat.com;
> ssengar@linux.microsoft.com; shradhagupta@linux.microsoft.com
> Subject: Re: [PATCH 1/1] RDMA/mana_ib: Add EQ interrupt support to mana
> ib driver.
>=20
> On Mon, Jun 05, 2023 at 03:15:05PM +0200, Simon Horman wrote:
> > On Mon, Jun 05, 2023 at 11:43:13AM +0000, Wei Hu wrote:
> > > Add EQ interrupt support for mana ib driver. Allocate EQs per
> > > ucontext to receive interrupt. Attach EQ when CQ is created. Call CQ
> > > interrupt handler when completion interrupt happens. EQs are
> > > destroyed when ucontext is deallocated.
> > >
> > > The change calls some public APIs in mana ethernet driver to
> > > allocate EQs and other resources. Ehe EQ process routine is also
> > > shared by mana ethernet and mana ib drivers.
> > >
> > > Co-developed-by: Ajay Sharma <sharmaajay@microsoft.com>
> > > Signed-off-by: Ajay Sharma <sharmaajay@microsoft.com>
> > > Signed-off-by: Wei Hu <weh@microsoft.com>
> >
> > ...
> >
> > > @@ -368,6 +420,24 @@ static int mana_ib_create_qp_raw(struct ib_qp
> *ibqp, struct ib_pd *ibpd,
> > >  	qp->sq_id =3D wq_spec.queue_index;
> > >  	send_cq->id =3D cq_spec.queue_index;
> > >
> > > +	if (gd->gdma_context->cq_table[send_cq->id] =3D=3D NULL) {
> > > +
> > > +		gdma_cq =3D kzalloc(sizeof(*gdma_cq), GFP_KERNEL);
> > > +		if (!gdma_cq) {
> > > +			pr_err("failed to allocate gdma_cq\n");
> >
> > Hi wei Hu,
> >
> > I think 'err =3D -ENOMEM' is needed here.
>=20
> And no prints like that in drivers.
>=20
Thanks for your review, Simon and Jason. You are right.=20
I have overlooked these. I will fix it and send a v2 shortly.

Wei


