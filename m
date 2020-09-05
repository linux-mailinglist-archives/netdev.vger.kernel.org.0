Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53C9925E8C5
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 17:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728405AbgIEPiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 11:38:21 -0400
Received: from mail-eopbgr750105.outbound.protection.outlook.com ([40.107.75.105]:13377
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726403AbgIEPhx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 11:37:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gQyfoz6OGTmRJNraLsqnlpqkJgliXqrQ/CHWz3bQSwTVlDOD7r1nHQvwzHl30oGwtbnBsh8AFdDPD90WL9JN1dhLQ1RJ2Vg47CSRsdfZhrBZf+Drt31fWpWhjKByB8dAwotuG2sBKyXNh9LV2KL/981WvSd3s8BRFPfNKrC2jH0azTFy05GYWmB+DNYRZvuavtiSn3UMFY50FRmNOn0n2/tIh/6NvMjKEV4WYG4iKyVlqs3yIfFZMYnIJFLXAk7YEv4sq7pJHlSnzWFI+TwqREZtqcB2gFIdFSnWgzkrq+v7q6s9z2jdTjCAWiNfBdccRYlWVYnn2uMHJwAxbsHoyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5LCZBkAVKb6YfsDli9WBUm1ZF3Dls7qPzsTLoLg5Hg=;
 b=jxeNMBwJmI+8UgGyn5i5m3Uo6hD7y3UF1zcjIG0+27sHT16/K73ChYrVk+NVgibkb0EarKm/L6LojLCDW7n14WTc40V/qtO5h6XpZCkKM2QF3FrhX7iBLfB3C25GlsOIue5DvYqB42QF9dixrx+Q9ycztdsQX9w/ijUuUlajMTRfD0wUye7WoVGWZoUEI+8SC8ZRyhGNjdXoK9CR1wQP2iPDjYsdjOo8kUbvF/SxLuW8DiwLDHoehTJUZOx4Uy6S04al3X7jnsR4s74ugnwvGIo+7dnIYzFBpZuVnSDt3mCQ14EzysHLocuXDdbCrdfw049i+8NIpA9cgSLqe8khMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5LCZBkAVKb6YfsDli9WBUm1ZF3Dls7qPzsTLoLg5Hg=;
 b=ScIOrsBKZfWwXSi27w/eJEPP8hsxjceCaqHfNewNHgGCx8lnVHeP2r57sHIMxmzJPx//rIYujiE5Rf4xItNuXa6gQFE+EbeukHHMrFQzFVpoHkMU5Ubr7XavhnU9I5Pjx609C+praHeP7fbHw3ua9vWcsAUhoNYyzWMR2PeO5zE=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MWHPR21MB0174.namprd21.prod.outlook.com (2603:10b6:300:78::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.0; Sat, 5 Sep
 2020 15:37:47 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::d00b:3909:23b:83f1%5]) with mapi id 15.20.3370.008; Sat, 5 Sep 2020
 15:37:47 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Boqun Feng <boqun.feng@gmail.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: RE: [RFC v2 11/11] scsi: storvsc: Support PAGE_SIZE larger than 4K
Thread-Topic: [RFC v2 11/11] scsi: storvsc: Support PAGE_SIZE larger than 4K
Thread-Index: AQHWgNViudirRNKRX0u5bfq2r+DQyalZVOwQgADHToCAABVvYA==
Date:   Sat, 5 Sep 2020 15:37:47 +0000
Message-ID: <MW2PR2101MB10526293A0A67DA6716BE615D72A0@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200902030107.33380-1-boqun.feng@gmail.com>
 <20200902030107.33380-12-boqun.feng@gmail.com>
 <MW2PR2101MB10523D98F77D5A80468A07CDD72A0@MW2PR2101MB1052.namprd21.prod.outlook.com>
 <20200905141503.GD7503@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
In-Reply-To: <20200905141503.GD7503@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-09-05T15:37:45Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=2d0857de-608b-4ff8-b0f6-c1fa9b6a8f15;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 328fa7b0-6b69-4067-b07e-08d851b1a3d3
x-ms-traffictypediagnostic: MWHPR21MB0174:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR21MB01745A91281DCE6C4EED3D48D72A0@MWHPR21MB0174.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +37VNzEqtbQuyvm7iqA2dDK/tkdFRCj65nQmhDIS3l7F8bndTbENyRfJ+u/BRw7tmtXhTYfleNjCXbbppFMYsB8EBw8qo3gO/YYLN3orwojzrrQFYKYQZSrTCZ30S+z26Wo0OFtkLX5IJGjpybBHHiSe9WSeczrWso9AUnHoZ2uxuY/IHVFuStZ6Jc0CybIMSY27yAzniWii6TNd//4TY/KLxzOvQ4I1BvWOVmDGr/umG/bMl7pbHk/sJy93UZANaTHeNsdXZ7pLnMpOxmHfmnke5lIim/maaZOyfPwcr9Pk/xuoJqJdC4p0p2CtnVfBV50Lh7F+QXuwl8Klwi8VD9sY020RHokOJg6qlSfXV6DBUd0T1VjP1pKurBFf2KMu
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(346002)(366004)(396003)(33656002)(55016002)(6506007)(5660300002)(54906003)(186003)(66946007)(7416002)(7696005)(76116006)(82960400001)(86362001)(4326008)(8676002)(82950400001)(9686003)(316002)(8990500004)(66446008)(10290500003)(478600001)(71200400001)(2906002)(83380400001)(8936002)(6916009)(66556008)(26005)(52536014)(64756008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: xuB244+qFcbVMFy2Z2JOWfqcziIZmI7oyTi+Wa0iGOOe1Zet31LbZ6+wC9cuYuaV8+JYqSX5ZQp0g1m6tT71ub15Cab/8bFTuasBIW1/lFcs0q/Ldn02dJPzoEDt1KlBB7ktycIQtc3VFqOfsPMc6QhFYqOoK28wIfSpCudVyRaNuslu3AoSMrV49xqqNckL1fEZbNoumlrFjM3llMrc0BN9U/Mqq2l4I6o2w5q1fgoNazVIa/7RdjWQKnB73GlNdg1bvP2wUSEJ0NTCNk3szDoZr8gSWlGTkCPEUza/a/9P/sToDcG1DaBHLyMtQxoG9iCz3g62vLNKFj559Dr64ySbj0ULvaJdgOHdkgR0nxpcLHxGEaBe5betZpMBEGrvwgWN1LjfCQg21OdBwMXbmc5IoWp6DnI3DhaoGoqx0Ee/DwITD8M4wVv4NujqYCa/YUsGbR9mVJAFRb6rT2YraxFqFdqYsGyIPMKMOzxF320UXvrgpoxVNcSeTyvK0J2JfDSmYwTYuEyxp59d5T6e1sHPqfBa6Ql82Iml4rl3a5onSF77a3hRK6AnL7qvd2heJok/iJ04ALRoM1zcj2jOC26IGNigEj7xFeuZ3VA9aYavU2KxCObrGqHXloL2nJEXHGDaCKIQwBVlu7sf4Bc4VA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 328fa7b0-6b69-4067-b07e-08d851b1a3d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2020 15:37:47.1336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ccJipa1LtYe1wT2tGGI2Qt4bqu4rD0AafPrPMCwVGcjv1Sc4MvMgvxZcwTCGOLsHKmzT6dVtrRDI920kam5eahdprgWd51/f3mkZx8Koqmo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0174
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com> Sent: Saturday, September 5, 2020 7=
:15 AM
>=20
> On Sat, Sep 05, 2020 at 02:55:48AM +0000, Michael Kelley wrote:
> > From: Boqun Feng <boqun.feng@gmail.com> Sent: Tuesday, September 1, 202=
0 8:01 PM
> > >
> > > Hyper-V always use 4k page size (HV_HYP_PAGE_SIZE), so when
> > > communicating with Hyper-V, a guest should always use HV_HYP_PAGE_SIZ=
E
> > > as the unit for page related data. For storvsc, the data is
> > > vmbus_packet_mpb_array. And since in scsi_cmnd, sglist of pages (in u=
nit
> > > of PAGE_SIZE) is used, we need convert pages in the sglist of scsi_cm=
nd
> > > into Hyper-V pages in vmbus_packet_mpb_array.
> > >
> > > This patch does the conversion by dividing pages in sglist into Hyper=
-V
> > > pages, offset and indexes in vmbus_packet_mpb_array are recalculated
> > > accordingly.
> > >
> > > Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> > > ---
> > >  drivers/scsi/storvsc_drv.c | 60 ++++++++++++++++++++++++++++++++++--=
--
> > >  1 file changed, 54 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> > > index 8f5f5dc863a4..3f6610717d4e 100644
> > > --- a/drivers/scsi/storvsc_drv.c
> > > +++ b/drivers/scsi/storvsc_drv.c
> > > @@ -1739,23 +1739,71 @@ static int storvsc_queuecommand(struct Scsi_H=
ost *host,
> struct
> > > scsi_cmnd *scmnd)
> > >  	payload_sz =3D sizeof(cmd_request->mpb);
> > >
> > >  	if (sg_count) {
> > > -		if (sg_count > MAX_PAGE_BUFFER_COUNT) {
> > > +		unsigned int hvpg_idx =3D 0;
> > > +		unsigned int j =3D 0;
> > > +		unsigned long hvpg_offset =3D sgl->offset & ~HV_HYP_PAGE_MASK;
> > > +		unsigned int hvpg_count =3D HVPFN_UP(hvpg_offset + length);
> > >
> > > -			payload_sz =3D (sg_count * sizeof(u64) +
> > > +		if (hvpg_count > MAX_PAGE_BUFFER_COUNT) {
> > > +
> > > +			payload_sz =3D (hvpg_count * sizeof(u64) +
> > >  				      sizeof(struct vmbus_packet_mpb_array));
> > >  			payload =3D kzalloc(payload_sz, GFP_ATOMIC);
> > >  			if (!payload)
> > >  				return SCSI_MLQUEUE_DEVICE_BUSY;
> > >  		}
> > >
> > > +		/*
> > > +		 * sgl is a list of PAGEs, and payload->range.pfn_array
> > > +		 * expects the page number in the unit of HV_HYP_PAGE_SIZE (the
> > > +		 * page size that Hyper-V uses, so here we need to divide PAGEs
> > > +		 * into HV_HYP_PAGE in case that PAGE_SIZE > HV_HYP_PAGE_SIZE.
> > > +		 */
> > >  		payload->range.len =3D length;
> > > -		payload->range.offset =3D sgl[0].offset;
> > > +		payload->range.offset =3D sgl[0].offset & ~HV_HYP_PAGE_MASK;
> > > +		hvpg_idx =3D sgl[0].offset >> HV_HYP_PAGE_SHIFT;
> > >
> > >  		cur_sgl =3D sgl;
> > > -		for (i =3D 0; i < sg_count; i++) {
> > > -			payload->range.pfn_array[i] =3D
> > > -				page_to_pfn(sg_page((cur_sgl)));
> > > +		for (i =3D 0, j =3D 0; i < sg_count; i++) {
> > > +			/*
> > > +			 * "PAGE_SIZE / HV_HYP_PAGE_SIZE - hvpg_idx" is the #
> > > +			 * of HV_HYP_PAGEs in the current PAGE.
> > > +			 *
> > > +			 * "hvpg_count - j" is the # of unhandled HV_HYP_PAGEs.
> > > +			 *
> > > +			 * As shown in the following, the minimal of both is
> > > +			 * the # of HV_HYP_PAGEs, we need to handle in this
> > > +			 * PAGE.
> > > +			 *
> > > +			 * |------------------ PAGE ----------------------|
> > > +			 * |   PAGE_SIZE / HV_HYP_PAGE_SIZE in total      |
> > > +			 * |hvpg|hvpg| ...                 |hvpg|... |hvpg|
> > > +			 *           ^                     ^
> > > +			 *         hvpg_idx                |
> > > +			 *           ^                     |
> > > +			 *           +---(hvpg_count - j)--+
> > > +			 *
> > > +			 * or
> > > +			 *
> > > +			 * |------------------ PAGE ----------------------|
> > > +			 * |   PAGE_SIZE / HV_HYP_PAGE_SIZE in total      |
> > > +			 * |hvpg|hvpg| ...                 |hvpg|... |hvpg|
> > > +			 *           ^                                           ^
> > > +			 *         hvpg_idx                                      |
> > > +			 *           ^                                           |
> > > +			 *           +---(hvpg_count - j)------------------------+
> > > +			 */
> > > +			unsigned int nr_hvpg =3D min((unsigned int)(PAGE_SIZE /
> HV_HYP_PAGE_SIZE) - hvpg_idx,
> > > +						   hvpg_count - j);
> > > +			unsigned int k;
> > > +
> > > +			for (k =3D 0; k < nr_hvpg; k++) {
> > > +				payload->range.pfn_array[j] =3D
> > > +					page_to_hvpfn(sg_page((cur_sgl))) + hvpg_idx + k;
> > > +				j++;
> > > +			}
> > >  			cur_sgl =3D sg_next(cur_sgl);
> > > +			hvpg_idx =3D 0;
> > >  		}
> >
> > This code works; I don't see any errors.  But I think it can be made si=
mpler based
> > on doing two things:
> > 1)  Rather than iterating over the sg_count, and having to calculate nr=
_hvpg on
> > each iteration, base the exit decision on having filled up the pfn_arra=
y[].  You've
> > already calculated the exact size of the array that is needed given the=
 data
> > length, so it's easy to exit when the array is full.
> > 2) In the inner loop, iterate from hvpg_idx to PAGE_SIZE/HV_HYP_PAGE_SI=
ZE
> > rather than from 0 to a calculated value.
> >
> > Also, as an optimization, pull page_to_hvpfn(sg_page((cur_sgl)) out of =
the
> > inner loop.
> >
> > I think this code does it (though I haven't tested it):
> >
> >                 for (j =3D 0; ; sgl =3D sg_next(sgl)) {
> >                         unsigned int k;
> >                         unsigned long pfn;
> >
> >                         pfn =3D page_to_hvpfn(sg_page(sgl));
> >                         for (k =3D hvpg_idx; k < (unsigned int)(PAGE_SI=
ZE /HV_HYP_PAGE_SIZE); k++) {
> >                                 payload->range.pfn_array[j] =3D pfn + k=
;
> >                                 if (++j =3D=3D hvpg_count)
> >                                         goto done;
> >                         }
> >                         hvpg_idx =3D 0;
> >                 }
> > done:
> >
> > This approach also makes the limit of the inner loop a constant, and th=
at
> > constant will be 1 when page size is 4K.  So the compiler should be abl=
e to
> > optimize away the loop in that case.
> >
>=20
> Good point! I like your suggestion, and after thinking a bit harder
> based on your approach, I come up with the following:
>=20
> #define HV_HYP_PAGES_IN_PAGE ((unsigned int)(PAGE_SIZE / HV_HYP_PAGE_SIZE=
))
>=20
> 		for (j =3D 0; j < hvpg_count; j++) {
> 			unsigned int k =3D (j + hvpg_idx) % HV_HYP_PAGES_IN_PAGE;
>=20
> 			/*
> 			 * Two cases that we need to fetch a page:
> 			 * a) j =3D=3D 0: the first step or
> 			 * b) k =3D=3D 0: when we reach the boundary of a
> 			 * page.
> 			 *
> 			if (k =3D=3D 0 || j =3D=3D 0) {
> 				pfn =3D page_to_hvpfn(sg_page(cur_sgl));
> 				cur_sgl =3D sg_next(cur_sgl);
> 			}
>=20
> 			payload->range.pfn_arrary[j] =3D pfn + k;
> 		}
>=20
> , given the HV_HYP_PAGES_IN_PAGE is always a power of 2, so I think
> compilers could easily optimize the "%" into bit masking operation. And
> when HV_HYP_PAGES_IN_PAGE is 1, I think compilers can easily figure out
> k is always zero, then the if-statement can be optimized as always
> taken. And that gives us the same code as before ;-)
>=20
> Thoughts? I will try with a test to see if I'm missing something subtle.
>=20
> Thanks for looking into this!
>=20

Your newest version looks right to me -- very clever!  I like it even bette=
r=20
than my version.

Michael
