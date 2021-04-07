Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A244356F08
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 16:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353076AbhDGOmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 10:42:08 -0400
Received: from mail-co1nam11on2137.outbound.protection.outlook.com ([40.107.220.137]:54368
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348600AbhDGOl5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 10:41:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VM48wwExqKkZbPcS0nibziqXtV0P4c4+fjQWPyFUKRzbrLY7BS7FucUAUSmbXMs00RLuWV1yp8L5YZd9NW/v38tVzd7/FjcMEfIs5ucUFrJol3q5g1WzlKagKB0pc0qDu0SpnDJsVi6lNCQc+vknhhANTCh2oGclXx9MU06n53tq1xyCVII2iBnIea1AsRK2VKtyoS/EYyl5iLUoumaYFwFn1dMe3Bw81id6P6SIqBbVRnmmAvIk2P3iOOBEg1yiYspxEN5O+JTFgDrqU1mRXcYQTkeRkXs9wOOVZQx9mY15cYDqUWswL0Slg6GGvqe48O3snVOUvBLOJGxmnHiWvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ES9KC6SLNx3VUcSpQx7oLEMs8tqONUyZM7/qNbqd7WE=;
 b=TBdFTz4hclUk33KUeTTFC7mXhFWM4Qi/imCxafBxNPyqmMnbNMXvN08fRO4latNKmQb31L0WHWfkUk8fVxBODpOCYGjvlf5mr09MOVvyWL2dRSXUQouHsNobiG/8DjM+IyMweNELjUZxHst2aSaVSR3lZKDB9fW9s+P7byoBFaJLHYCrTodD4/HvkZBBa72eNA9ox/Og45yQu0ThGTSgvqWz1koVCfEa9HvRKcCOjCXLnfczo1vQDFvUzNcZXdlR1QjabwG30eb0R4XtQyCNKcMsQRwdpMeE6k9QO5dbfCdoHZ62nYVmcjeR3dIF2XzvLTfcDcuRCJ1bwhQsvwXNHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ES9KC6SLNx3VUcSpQx7oLEMs8tqONUyZM7/qNbqd7WE=;
 b=A4YixuEQ4nX9GDpFyoMAZ0ZsarRoAMyIycC02yzZ0k57E7h84CQmaQwhvGi/8iTaISnrjGjAmkVDWGwOxExtTGSd0Cch3ivh36e5x6Xpmtdrx3aM1lUefQVu24E3jOzqPNKMhyWf8EdMXLB/A64sAYF8kfuDrn17ZGfYdeCRzqo=
Received: from DM5PR2101MB0934.namprd21.prod.outlook.com (2603:10b6:4:a5::36)
 by DM5PR2101MB0870.namprd21.prod.outlook.com (2603:10b6:4:80::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.4; Wed, 7 Apr
 2021 14:41:46 +0000
Received: from DM5PR2101MB0934.namprd21.prod.outlook.com
 ([fe80::3180:1d96:7f57:333d]) by DM5PR2101MB0934.namprd21.prod.outlook.com
 ([fe80::3180:1d96:7f57:333d%9]) with mapi id 15.20.4042.004; Wed, 7 Apr 2021
 14:41:46 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Leon Romanovsky <leon@kernel.org>, Dexuan Cui <decui@microsoft.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXKzvmwFT+jLn9hE+ope3TVVs2GqqotGEAgAAIZ4CAAEYnAIAAHRmw
Date:   Wed, 7 Apr 2021 14:41:45 +0000
Message-ID: <DM5PR2101MB09342B74ECD56BE4781431EACA759@DM5PR2101MB0934.namprd21.prod.outlook.com>
References: <20210406232321.12104-1-decui@microsoft.com>
 <YG1o4LXVllXfkUYO@unreal>
 <MW2PR2101MB08923D4417E44C5750BFB964BF759@MW2PR2101MB0892.namprd21.prod.outlook.com>
 <YG2qxjPJ4ruas1dI@unreal>
In-Reply-To: <YG2qxjPJ4ruas1dI@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=095f2db8-f2c4-446b-9d81-7025a7557ef6;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-07T14:35:26Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad1cfaa5-ed99-40f7-f533-08d8f9d344dc
x-ms-traffictypediagnostic: DM5PR2101MB0870:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR2101MB0870FFD23D8F1288862F5497CA759@DM5PR2101MB0870.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ww0R2V6uklSJ0zJM0frcQxDHFtHFTmfWCKdN6OXHPEehTDp7JCFKheHC9dttYlMiRmpsv47AlCQoHrSVDjMPehRtEtcApLuzBxLh9l8Ve/i/YvSSri8F/RXimYghc6uJVcuDf7A07wGDtN7rWaZWYzcWSrJ4QyCHb3+9ZVNBhOvoONhNIDv2EXE1Q1lo4PojDUdnvafKtyXhXVTM9G0ltsGMGizvUmbUUc0LigMgDBR/nMw/sSv0voKbftY/e0JGH1nwv9O1xVa+Mnmj1yfCt/fFAeMvhIEhWZbnIwwderwFdDvRRuplpJ45lhARfu417Fcc/beK6ZG8AIftz+ETA61jtPDjG0GgPubYO11zQfGgr9FLEBdH3/hOO9lowIB1KKl/yRGmJ6+W3wAxUBiECp7dsusPqO5VsKac6m2z0Dkp9xrVdjHXwfuYmNFr/KEZvT8A+2tibgAya+IBUpqe/k6MbV9XtRHV9Nx/amCtOwzhPno9fCq8RvHEAcvw7ntl4aYy52ctVyjtHoxfKxbxvnN4fh/1YWelL69hqKKYmD+6U2DDBKPgVbj6eLiL5hrwyoKnAshHS4W9kGJ/1QFbB+iZ/WwzbqqxNDlCXhbHBVkIoAR9gASCedtegKisCB1h8u9kGo9zLNcrM4O/lQI8KQtvZxMcR1EkusSw+KhnCNg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR2101MB0934.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(396003)(366004)(47530400004)(4326008)(186003)(8676002)(66946007)(76116006)(33656002)(38100700001)(66446008)(7696005)(66556008)(8936002)(478600001)(5660300002)(71200400001)(110136005)(53546011)(6506007)(6636002)(316002)(54906003)(2906002)(55016002)(9686003)(8990500004)(82950400001)(82960400001)(26005)(83380400001)(10290500003)(64756008)(66476007)(86362001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?JkVuPdPaWoSi6oynN8qufx9CNHfsubs/gxkJ/5hPW73211wQ2CZjbJQzLnPF?=
 =?us-ascii?Q?5A+Wr9IDkG4UPSIaVvBJESAVJ0b/jAovthhfMVEcQtHQpVE2A95W8Llurj6l?=
 =?us-ascii?Q?Uoo/dOg1bEairS/za4rUdPCxSz2BFxZ3RJCIrtz+HFJffPaQ5EVlAEuUOheX?=
 =?us-ascii?Q?K5pf1ETpH8SXu2vEGKPV6xo/WBF3iOQXiv9FjTDUUgebD29YCzZZQXNYfiqA?=
 =?us-ascii?Q?5Tl1ZA3BfSedpbZAjQuMbCfiyUV6rd/N8hsr1QtYfhZum8BSiphhAW4xDABU?=
 =?us-ascii?Q?TlxLju0kwdChPjarOb0ZCQ25YCra0hH1V92CnPF3ZgscdwBn9hy2TLHIMeKU?=
 =?us-ascii?Q?Mvlw+Vf/B+0dstYQEkR78pneRYTe6DnmE+OhCnEQ9kNBu9yPr6TWccah0Ouk?=
 =?us-ascii?Q?R0GrCSn1Gy9Cul138PGZTebfPOlXLNNu8GifgUlAEs5mq9PdTFRfUp23QzKF?=
 =?us-ascii?Q?r/w4kyVDCEkRocRiq6nFrv5SSObWbyTDBY3DKHInETnRSnRy6ffsHvQxtosf?=
 =?us-ascii?Q?XEP4DsPL/lqOz8Qev70tmY5VtSBP3NU595XPblmh+Qk5pZ6/uU+UECwBNHyF?=
 =?us-ascii?Q?84DlUrUBpe2iPbFFWQqIr27gO+msLZlIqAIwZnz+vti18ggQXoxoiCoiZ4eb?=
 =?us-ascii?Q?KQpJIccP1iEXUmmORBbY25zxw5ZhfoG5Nu/K6zHHcxd+Nwe+f3mlEqieHRSv?=
 =?us-ascii?Q?/ableA8oylxT61cW1bQQZvbodasiabKoKniLCl7/ekhViTrilE7HraDmRM6B?=
 =?us-ascii?Q?RNklZex8Dc927LFM4Nz9ifyOGokIvU3rCf83uu3M9f5tjKuV3Fija3hiWL6R?=
 =?us-ascii?Q?wBvU6boIGH2AI5ZfN4cXvcd0VPl+ypjWreOnAZ9mo2ZCkxpG76etRDuKv+dt?=
 =?us-ascii?Q?hKh08lLEmvS1tehDarDljdpUGPeL2ZI0HBJmmzZoBRnYwl1Em0rcoz0vRhkr?=
 =?us-ascii?Q?6qp6j0+6acMzKzDVEEt9iW4irr3+uvnnx0GDIVpZNCe5S5M5SfdU9XtBtkvw?=
 =?us-ascii?Q?NtU+lTr3Sg70jT8FZ8edsNWOEkfZnFTu26ml27GrDwPtyiegop+k5pYEnMHI?=
 =?us-ascii?Q?WIsjIYE1mqmrmNWTCDbhPWN4/DYXV70eJjzkBtKoocS/0oQhFL4mmQUQcJsd?=
 =?us-ascii?Q?Sb9TTMJw9Ga7Ot7mD/FiHfME3+nvELiF1YK8MBI0jk3/u5hXnpoZT07uYQ27?=
 =?us-ascii?Q?fROHLa4xeB4JOgCTaSn1REca6OET7PGpJrZmb7T9J4w45+CKacpZO/1tACtk?=
 =?us-ascii?Q?sE95fw96Jx6eWfNUcpavpa2ZyZ3yptfK4+ajdWg8IFs+GwQps3jBOAFtjWHt?=
 =?us-ascii?Q?OhHPv4gQ71ncmGwGstrong7z?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR2101MB0934.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad1cfaa5-ed99-40f7-f533-08d8f9d344dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2021 14:41:45.8693
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z/rVMpAk1w3Qf9s1phlS9gy7RIKQxK3/rUZXsrzqB9uY8T6NeDznrX5cntTFDaSQ5V5ie+FEZd7Phrl4regdpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0870
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Wednesday, April 7, 2021 8:51 AM
> To: Dexuan Cui <decui@microsoft.com>
> Cc: davem@davemloft.net; kuba@kernel.org; KY Srinivasan
> <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; wei.liu@kernel.org; Wei Liu
> <liuwe@microsoft.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-hyperv@vger.kernel.org
> Subject: Re: [PATCH net-next] net: mana: Add a driver for Microsoft Azure
> Network Adapter (MANA)
>=20
> On Wed, Apr 07, 2021 at 08:40:13AM +0000, Dexuan Cui wrote:
> > > From: Leon Romanovsky <leon@kernel.org>
> > > Sent: Wednesday, April 7, 2021 1:10 AM
> > >
> > > <...>
> > >
> > > > +int gdma_verify_vf_version(struct pci_dev *pdev)
> > > > +{
> > > > +	struct gdma_context *gc =3D pci_get_drvdata(pdev);
> > > > +	struct gdma_verify_ver_req req =3D { 0 };
> > > > +	struct gdma_verify_ver_resp resp =3D { 0 };
> > > > +	int err;
> > > > +
> > > > +	gdma_init_req_hdr(&req.hdr, GDMA_VERIFY_VF_DRIVER_VERSION,
> > > > +			  sizeof(req), sizeof(resp));
> > > > +
> > > > +	req.protocol_ver_min =3D GDMA_PROTOCOL_FIRST;
> > > > +	req.protocol_ver_max =3D GDMA_PROTOCOL_LAST;
> > > > +
> > > > +	err =3D gdma_send_request(gc, sizeof(req), &req, sizeof(resp), &r=
esp);
> > > > +	if (err || resp.hdr.status) {
> > > > +		pr_err("VfVerifyVersionOutput: %d, status=3D0x%x\n", err,
> > > > +		       resp.hdr.status);
> > > > +		return -EPROTO;
> > > > +	}
> > > > +
> > > > +	return 0;
> > > > +}
> > >
> > > <...>
> > > > +	err =3D gdma_verify_vf_version(pdev);
> > > > +	if (err)
> > > > +		goto remove_irq;
> > >
> > > Will this VF driver be used in the guest VM? What will prevent from u=
sers
> to
> > > change it?
> > > I think that such version negotiation scheme is not allowed.
> >
> > Yes, the VF driver is expected to run in a Linux VM that runs on Azure.
> >
> > Currently gdma_verify_vf_version() just tells the PF driver that the VF
> driver
> > is only able to support GDMA_PROTOCOL_V1, and want to use
> > GDMA_PROTOCOL_V1's message formats to talk to the PF driver later.
> >
> > enum {
> >         GDMA_PROTOCOL_UNDEFINED =3D 0,
> >         GDMA_PROTOCOL_V1 =3D 1,
> >         GDMA_PROTOCOL_FIRST =3D GDMA_PROTOCOL_V1,
> >         GDMA_PROTOCOL_LAST =3D GDMA_PROTOCOL_V1,
> >         GDMA_PROTOCOL_VALUE_MAX
> > };
> >
> > The PF driver is supposed to always support GDMA_PROTOCOL_V1, so I
> expect
> > here gdma_verify_vf_version() should succeed. If a user changes the Lin=
ux
> VF
> > driver and try to use a protocol version not supported by the PF driver=
,
> then
> > gdma_verify_vf_version() will fail; later, if the VF driver tries to ta=
lk to the
> PF
> > driver using an unsupported message format, the PF driver will return a
> failure.
>=20
> The worry is not for the current code, but for the future one when you wi=
ll
> support v2, v3 e.t.c. First, your code will look like a spaghetti and
> second, users will try and mix vX with "unsupported" commands just for th=
e
> fun.

In the future, if the protocol version updated on the host side, guests nee=
d=20
to support different host versions because not all hosts are updated=20
(simultaneously). So this negotiation is necessary to know the supported=20
version, and decide the proper command version to use.=20

If any user try "unsupported commands just for the fun", the host will deny=
=20
and return an error.

Thanks,
- Haiyang
