Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A10622A539
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 04:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733289AbgGWC0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 22:26:05 -0400
Received: from mail-dm6nam10on2133.outbound.protection.outlook.com ([40.107.93.133]:13281
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728914AbgGWC0F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 22:26:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mk463RSstXzeCL76F4tPa7SXdpVsXXW6edmkOs6W1Q2WI/vMREWqo4M+dYTUs6SaQTDCoxyrTgNT7ZzKsPSgubUdYrTqSIpG2DDHNbuE4afiiPxiE17uw9JTCZTl3oURPp5MBvrkjiCiSXkNdz3KdqjP2fiAmQbCc7vKFCZgEuH4c7zWaDqn3fw2qdtuTDNNiiEIvf6uASxV5Ph8gpIlUAU7uqXLChpINj2h6a0qScWkDLa872TG03vllTubPppjy1cuyTHXzvkE3QSjROgmtB/Cn04KnYsLYYDTt8ryyamPlZqqESd9hK7+7qlKOGrG1d+9Y/dPc55LKoBT6FQRMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbGnwm6nigEVLD5O04pKymGg1ItEWvrWBLaJuQND2fw=;
 b=Ex5LcQ81oMUFweP4ikeOiLe5cnL196G52Ryc67nzIsYyCnFervg+0TtRdGVP0qDSmvxGv2gO1/+tMWkQ5eQ9VZS1aWUqU3+wCbDiSg9HPtJ0SFegD21j6vyyJ0azjbnd/bwDvS/ihxyEAdUWj0PWaPGa5KUd66YWSKSMuH87dY6Wt41Wni7l3mE7xdu0zP3nrchv4OWCNB1qDJMxVmYOGJVIcrreCKk/87iTsyobUphQTep51v/ZGWPZsG0eF8el2qkW0IumqbD1SJsQsQ7h1YkfARIzngXpngwhRlfokX6+l1mCqKIRvO2bh/tHkJ0u7aPyexE40auGglFUUWnnQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbGnwm6nigEVLD5O04pKymGg1ItEWvrWBLaJuQND2fw=;
 b=Jmg3847LaUuPjNhKXjhqyVIttpER/IhRPUHdium7hEztGas/HTpZ2ojnW0KZgHnD5vzf/8+jKzJwZzoP1VENernTy5T2sQ9qu4g2LvOT8v/5xiyVOCl1RZudwmizbQw2d8Rzs8rwP9BIoM/9Flh0Rwifr+g4nuzR1v8LDoUGZxM=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MWHPR21MB0752.namprd21.prod.outlook.com (2603:10b6:300:76::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.14; Thu, 23 Jul
 2020 02:26:00 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::fc14:3ca6:8a8:7407]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::fc14:3ca6:8a8:7407%8]) with mapi id 15.20.3239.005; Thu, 23 Jul 2020
 02:26:00 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     "boqun.feng@gmail.com" <boqun.feng@gmail.com>
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
Subject: RE: [RFC 11/11] scsi: storvsc: Support PAGE_SIZE larger than 4K
Thread-Topic: [RFC 11/11] scsi: storvsc: Support PAGE_SIZE larger than 4K
Thread-Index: AQHWXwAq7r8b2cLtUkWcYsdrWYe9TqkUScaQgAAf4oCAAAWJcA==
Date:   Thu, 23 Jul 2020 02:26:00 +0000
Message-ID: <MW2PR2101MB1052D1FD22F1A91082843EC0D7760@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20200721014135.84140-1-boqun.feng@gmail.com>
 <20200721014135.84140-12-boqun.feng@gmail.com>
 <MW2PR2101MB1052B072CA85F82B74BE799FD7760@MW2PR2101MB1052.namprd21.prod.outlook.com>
 <20200723015149.GE35358@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
In-Reply-To: <20200723015149.GE35358@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-23T02:25:57Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=9c484212-fa3e-4409-8180-5e199ea96f1b;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e49563da-fb26-4f14-d46f-08d82eafbd45
x-ms-traffictypediagnostic: MWHPR21MB0752:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR21MB07526B71E1AC30B6BD7764A6D7760@MWHPR21MB0752.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oTXgBicIZ94R/iTjDxO1O7Kj2ljkhr986YoI8g3n7fTEIYH+harRf6F6pzsVb2L2jpLTZ8CwiT3MQcvVBYGgYE78DA0BvRN23m2BmdnyZhcXcf11aEQJCI4jwTd74Ps14UF92uchWLq7uFN0XNzcq38xyaU2+y7m/Fi9dDmNuPaTA0nIWJbqngUylzjCMVcY233Ahux8NpxNEU7P6d8qxmf3ouzuUiZGYUHuaR2YVCgOtJObrXWRf1zLZm5xBhsXJjqCts9EptIZTvtl94l3jZ2tCkqEzSnlst+OqMdnesGQ8mzMAfLv+mt6VAeKL71RvFkHnbl7D8hGsji3DdutAA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(52536014)(55016002)(4326008)(8990500004)(6916009)(26005)(7696005)(316002)(8676002)(82960400001)(82950400001)(33656002)(71200400001)(2906002)(5660300002)(54906003)(83380400001)(66476007)(7416002)(66946007)(86362001)(66446008)(478600001)(76116006)(64756008)(10290500003)(66556008)(8936002)(6506007)(186003)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: VsR8cyTe97jrbHHRXn5g0yM6/cHwgllD+e8BoPZR9uONdIaiZ4f1GhFYLXdXtfTaWQGkKjVVm3Q2bgIGDS6MbAqAFfOvC2ck3TTZyoyD++3ZDVqnS2s8wFVrtCLxTDU3tLj5F1TL3aTG+4/iAC5GIzzwafm3M3FQh2wc3qOZDqoraPI31nPiO6LLMaHlw6Yl5ibIoKawI86K7M+T9rjqJuqPjZclOhRcYZrQjQWt9EA8vthDDpLoG60v2Ch/UkQM7QaAZAAWa4QM5B3xmSL7rDOq2puGDWU0tcyfj1zmzUCA0QpMWiSOGnwhPwdqdOhoY7VlHAhCAQNMY/vaer0tA4XqStU2gxnnv+sp3lrVQXQSABmC1uUtuW0KcomtlEdoE4lgWKEulJXO4EqiOZGX+vW+Zbq0kGOi8bzkU7JQjBzd9pRmZQW0Sk70KPDgNPrT3/1Rnaegy7qpnTMA5HUHfWqjDfCNy9AJ1/xr+FsqchI1k2cTfvj9SxndyPEoUI74
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e49563da-fb26-4f14-d46f-08d82eafbd45
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 02:26:00.1670
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vpo05cCp30sqa5uUAM3aj9Z21OCEoo6IbxIQPSnl03N8vhPOKJ3TS9Jnts1G7UqSYISpwDJQ0T1H/bChHxbvLPm8AcE/Om7VPtCeCCbvZb8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0752
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: boqun.feng@gmail.com <boqun.feng@gmail.com> Sent: Wednesday, July 22,=
 2020 6:52 PM
>=20
> On Thu, Jul 23, 2020 at 12:13:07AM +0000, Michael Kelley wrote:
> > From: Boqun Feng <boqun.feng@gmail.com> Sent: Monday, July 20, 2020 6:4=
2 PM
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
> > >  drivers/scsi/storvsc_drv.c | 27 +++++++++++++++++++++------
> > >  1 file changed, 21 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> > > index fb41636519ee..c54d25f279bc 100644
> > > --- a/drivers/scsi/storvsc_drv.c
> > > +++ b/drivers/scsi/storvsc_drv.c
> > > @@ -1561,7 +1561,7 @@ static int storvsc_queuecommand(struct Scsi_Hos=
t *host,
> struct
> > > scsi_cmnd *scmnd)
> > >  	struct hv_host_device *host_dev =3D shost_priv(host);
> > >  	struct hv_device *dev =3D host_dev->dev;
> > >  	struct storvsc_cmd_request *cmd_request =3D scsi_cmd_priv(scmnd);
> > > -	int i;
> > > +	int i, j, k;
> > >  	struct scatterlist *sgl;
> > >  	unsigned int sg_count =3D 0;
> > >  	struct vmscsi_request *vm_srb;
> > > @@ -1569,6 +1569,8 @@ static int storvsc_queuecommand(struct Scsi_Hos=
t *host,
> struct
> > > scsi_cmnd *scmnd)
> > >  	struct vmbus_packet_mpb_array  *payload;
> > >  	u32 payload_sz;
> > >  	u32 length;
> > > +	int subpage_idx =3D 0;
> > > +	unsigned int hvpg_count =3D 0;
> > >
> > >  	if (vmstor_proto_version <=3D VMSTOR_PROTO_VERSION_WIN8) {
> > >  		/*
> > > @@ -1643,23 +1645,36 @@ static int storvsc_queuecommand(struct Scsi_H=
ost *host,
> struct
> > > scsi_cmnd *scmnd)
> > >  	payload_sz =3D sizeof(cmd_request->mpb);
> > >
> > >  	if (sg_count) {
> > > -		if (sg_count > MAX_PAGE_BUFFER_COUNT) {
> > > +		hvpg_count =3D sg_count * (PAGE_SIZE / HV_HYP_PAGE_SIZE);
> >
> > The above calculation doesn't take into account the offset in the
> > first sglist or the overall length of the transfer, so the value of hvp=
g_count
> > could be quite a bit bigger than it needs to be.  For example, with a 6=
4K
> > page size and an 8 Kbyte transfer size that starts at offset 60K in the
> > first page, hvpg_count will be 32 when it really only needs to be 2.
> >
> > The nested loops below that populate the pfn_array take the
> > offset into account when starting, so that's good.  But it will potenti=
ally
> > leave allocated entries unused.  Furthermore, the nested loops could
> > terminate early when enough Hyper-V size pages are mapped to PFNs
> > based on the length of the transfer, even if all of the last guest size
> > page has not been mapped to PFNs.  Like the offset at the beginning of
> > first guest size page in the sglist, there's potentially an unused port=
ion
> > at the end of the last guest size page in the sglist.
> >
>=20
> Good point. I think we could calculate the exact hvpg_count as follow:
>=20
> 	hvpg_count =3D 0;
> 	cur_sgl =3D sgl;
>=20
> 	for (i =3D 0; i < sg_count; i++) {
> 		hvpg_count +=3D HVPFN_UP(cur_sg->length)
> 		cur_sgl =3D sg_next(cur_sgl);
> 	}
>=20

The downside would be going around that loop a lot of times when
the page size is 4K bytes and the I/O transfer size is something like
256K bytes.  I think this gives the right result in constant time:  the
starting offset within a Hyper-V page, plus the transfer length,
rounded up to a Hyper-V page size, and divided by the Hyper-V
page size.


> > > +		if (hvpg_count > MAX_PAGE_BUFFER_COUNT) {
> > >
> > > -			payload_sz =3D (sg_count * sizeof(u64) +
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
> > > +		subpage_idx =3D sgl[0].offset >> HV_HYP_PAGE_SHIFT;
> > >
> > >  		cur_sgl =3D sgl;
> > > +		k =3D 0;
> > >  		for (i =3D 0; i < sg_count; i++) {
> > > -			payload->range.pfn_array[i] =3D
> > > -				page_to_pfn(sg_page((cur_sgl)));
> > > +			for (j =3D subpage_idx; j < (PAGE_SIZE / HV_HYP_PAGE_SIZE); j++) =
{
> >
> > In the case where PAGE_SIZE =3D=3D HV_HYP_PAGE_SIZE, would it help the =
compiler
> > eliminate the loop if local variable j is declared as unsigned?  In tha=
t case the test in the
> > for statement will always be false.
> >
>=20
> Good point! I did the following test:
>=20
> test.c:
>=20
> 	int func(unsigned int input, int *arr)
> 	{
> 		unsigned int i;
> 		int result =3D 0;
>=20
> 		for (i =3D input; i < 1; i++)
> 			result +=3D arr[i];
>=20
> 		return result;
> 	}
>=20
> if I define i as "int", I got:
>=20
> 	0000000000000000 <func>:
> 	   0:	85 ff                	test   %edi,%edi
> 	   2:	7f 2c                	jg     30 <func+0x30>
> 	   4:	48 63 d7             	movslq %edi,%rdx
> 	   7:	f7 df                	neg    %edi
> 	   9:	45 31 c0             	xor    %r8d,%r8d
> 	   c:	89 ff                	mov    %edi,%edi
> 	   e:	48 8d 04 96          	lea    (%rsi,%rdx,4),%rax
> 	  12:	48 01 d7             	add    %rdx,%rdi
> 	  15:	48 8d 54 be 04       	lea    0x4(%rsi,%rdi,4),%rdx
> 	  1a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
> 	  20:	44 03 00             	add    (%rax),%r8d
> 	  23:	48 83 c0 04          	add    $0x4,%rax
> 	  27:	48 39 d0             	cmp    %rdx,%rax
> 	  2a:	75 f4                	jne    20 <func+0x20>
> 	  2c:	44 89 c0             	mov    %r8d,%eax
> 	  2f:	c3                   	retq
> 	  30:	45 31 c0             	xor    %r8d,%r8d
> 	  33:	44 89 c0             	mov    %r8d,%eax
> 	  36:	c3                   	retq
>=20
> and when I define i as "unsigned int", I got:
>=20
> 	0000000000000000 <func>:
> 	   0:	85 ff                	test   %edi,%edi
> 	   2:	75 03                	jne    7 <func+0x7>
> 	   4:	8b 06                	mov    (%rsi),%eax
> 	   6:	c3                   	retq
> 	   7:	31 c0                	xor    %eax,%eax
> 	   9:	c3                   	retq
>=20
> So clearly it helps, I will change this in the next version.

Wow!  The compiler is good ....

>=20
> Regards,
> Boqun
>=20
> > > +				payload->range.pfn_array[k] =3D
> > > +					page_to_hvpfn(sg_page((cur_sgl))) + j;
> > > +				k++;
> > > +			}
> > >  			cur_sgl =3D sg_next(cur_sgl);
> > > +			subpage_idx =3D 0;
> > >  		}
> > >  	}
> > >
> > > --
> > > 2.27.0
> >
