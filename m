Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CE73F2FAE
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 17:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241210AbhHTPlD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 11:41:03 -0400
Received: from mail-oln040093008011.outbound.protection.outlook.com ([40.93.8.11]:7348
        "EHLO outbound.mail.eo.outlook.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241059AbhHTPk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 11:40:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Twk6JxRCCorgtqG9tUHN26l3kqiniajhANolR2SN+vuVrmuzLs8jxbMOGkiZlb7wdhrGPY+WSWynp23O6LkKw/6ja+ZOcbNaCABlVD2INdsVGWxzYhRMqyP73xikDY6a3t4I5YlZ4JEnQbFLHj4ov1a+9IY7KxfzMvz2L4A8T7CwG5QHsmVZVz7E/cNqIhsBKG/7Wqts5Enwjczk9ViyxZqhg/ehfaPcFgIzvXj96B7GNlk+j8wyYRrqZuzHYGesBEyVbrYbs7KOzbqWR8/cHFhWemqQzi3frQkk189dgW5UrOWSgNZA/WfbEyDf7GBZCOhcLOeRxxIdSGzL1Gt7Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=+/NK5CpwxxqKlpEdtVzC/K4J3I9XlbMl3qZJvfxbzUY=;
 b=L1hyilwLzh3NcgO4SY21fD8vP3NRvSpHhNinbWLIqXm/dKmwcXh8JZl0ZWBDXO2JrsrHZZE054WmXqGo87S45d46ZP088vi4vF7/34qWqz0XCw8HelKGBF4tmtEWGMkaSJwLqZ5gd5h7zsomiuFNL9BPqG/vdTE/1IjAe3GzNrId+TqY2g0U3LPiZDclw5izVFiaUPhIPqPb1hpxUGbSdGHUN+kY1+AhnX+HLGKMfUgvYv0TTTh53PGso89Onl7sehtIOF9YBySltQn2pvHgihiQ2puMQiRH3e347LMx749xK/rzSvVn8zH6z8zZGqOlgHeu4C51Wk9gaw8GHa2Cqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+/NK5CpwxxqKlpEdtVzC/K4J3I9XlbMl3qZJvfxbzUY=;
 b=fZ5t9YbHJEzPzxj8FyR4Voc2uHmyUHv/Pl1dDNBZkcZ65uWfQ+8iQIMOkE80qt7zjxcJ0gs+WQwQBz7m8lqKXCOjfYRiEoekQiVz3vxyCYuyVuVkzb5kVeKCXjWK7073QwgL7f1SNH0cn0Zod+EAGyfhBnSoUY/VurH/0YwQcq0=
Received: from CY4PR21MB1586.namprd21.prod.outlook.com (2603:10b6:910:90::10)
 by CY4PR21MB0181.namprd21.prod.outlook.com (2603:10b6:903:ba::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.0; Fri, 20 Aug
 2021 15:40:09 +0000
Received: from CY4PR21MB1586.namprd21.prod.outlook.com
 ([fe80::686d:43d8:a7e8:1aa6]) by CY4PR21MB1586.namprd21.prod.outlook.com
 ([fe80::686d:43d8:a7e8:1aa6%8]) with mapi id 15.20.4457.007; Fri, 20 Aug 2021
 15:40:09 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     "hch@lst.de" <hch@lst.de>
CC:     Tianyu Lan <ltykernel@gmail.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "ardb@kernel.org" <ardb@kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "pgonda@google.com" <pgonda@google.com>,
        "martin.b.radev@gmail.com" <martin.b.radev@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "saravanand@fb.com" <saravanand@fb.com>,
        "krish.sadhukhan@oracle.com" <krish.sadhukhan@oracle.com>,
        "aneesh.kumar@linux.ibm.com" <aneesh.kumar@linux.ibm.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
Subject: RE: [PATCH V3 13/13] HV/Storvsc: Add Isolation VM support for storvsc
 driver
Thread-Topic: [PATCH V3 13/13] HV/Storvsc: Add Isolation VM support for
 storvsc driver
Thread-Index: AQHXjUf4MnryDC/QY0a+heAsfHsxAqt3v7VggAQeiYCAAK+YMA==
Date:   Fri, 20 Aug 2021 15:40:08 +0000
Message-ID: <CY4PR21MB1586FEB6F6ADD592C04E541BD7C19@CY4PR21MB1586.namprd21.prod.outlook.com>
References: <20210809175620.720923-1-ltykernel@gmail.com>
 <20210809175620.720923-14-ltykernel@gmail.com>
 <MWHPR21MB1593EEF30FFD5C60ED744985D7C09@MWHPR21MB1593.namprd21.prod.outlook.com>
 <20210820043237.GC26450@lst.de>
In-Reply-To: <20210820043237.GC26450@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ec22af1e-6e43-4509-a7bc-50a42915e01c;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-08-20T15:01:05Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8952dda2-15ee-4aa7-8c78-08d963f0ca7e
x-ms-traffictypediagnostic: CY4PR21MB0181:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <CY4PR21MB01815EA2D7C317824F336A33D7C19@CY4PR21MB0181.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: utuOfdMYn/AtqiQgHWCFiKU4B80qQ20mGq5jBTuPSsuIzsYe+QXsiYsmvOC/WafqgrJ+jNi6bJFq2fOsM4ukkgAm5ALdlaaFCB0Ncti87Pzo5WBUJKZR24dc9Wijc/C3hycrPeXMVHfShgqp6R6Tat8MffLYm7JMHHsiwaRPJGEECL/1OnatYNHbzW5j/i1Qls5XVeKCzPf4lPtBkdVyAju90yoVowViwGvmF3bmPggsMaypkt+3eHOGfu/xab7ypZBHZVrk8jMIyOZrD8Qnzs7kfVEVJuavPtlz1eiPtU7s9sEdrX3DINmCw4ETB11jUBSTklMyU/KNMFTOCJWNJ4L/6nN7eVgjy3gBEczRjZgoc6Z5TtpYcOakPRu4rQriObCmPRT0jinj8HbvG8ERNNjgwIKRKBbg7egv6Nn4LTTeMZgc1XFwZK2QE0UeTAEkR2pg2pFUsMciMD2Z8uqhjekUPmIaSzub3pyQqVRoI/1ya04Brp0iG4TxTUa+5gjo43okEPUosaCirx78JXNaPWW3U8KZwUsd6yBivYlCmIQS3bv0woPbQo8GeJ1yl4g/wGpxlgrfpusfol8BcaNOgAzrYdtp2jq9cFquUsWWYf5WqtlqCPhnLE0mEJ0h8ZZ8vAklg1f441htVwnWVlSS4GYrPAtp9OnOlZFEYPXQNOdTKyFYlhg1RVhp45KWUghoPpVPDMOk3GuRCFje7ebX0g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR21MB1586.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(71200400001)(9686003)(66946007)(76116006)(55016002)(10290500003)(66446008)(64756008)(66556008)(66476007)(508600001)(316002)(54906003)(8990500004)(38070700005)(82950400001)(122000001)(38100700002)(4326008)(6916009)(5660300002)(52536014)(82960400001)(8676002)(8936002)(83380400001)(7696005)(26005)(33656002)(6506007)(7416002)(7406005)(2906002)(86362001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DdPGWdWTMNl4lEHpzE77mNPNkz+09aUEvJ3ft5KAcfi5nzungltFQKlS/SV/?=
 =?us-ascii?Q?+t7dGaDBMBzor1zYbzTP4p8X8HDjPJ+Sbpqn/ebkZRrZCVRQURfaCdc/P45d?=
 =?us-ascii?Q?emIovBXST4P2LUNGB//RZyhRUM/qFUw+s0AwnSwlGG168wSWQgLtJ85RIqfP?=
 =?us-ascii?Q?p/3Pl2cZXd+3io1kPBWLmLEvz4uA7oFeyfLn7y4IdEphLU1ck4lReId4ajI8?=
 =?us-ascii?Q?YyVH6V/sGzr0Ea+DqwMEh4QxpMAAZ5QIQh228anLexENCMgiCkh8LzQA2gt2?=
 =?us-ascii?Q?5BgEwv/nd5ojYowxhrDNiE0StlTsSYcXu8sHPVOxeI2zMD8oSGqVQ0iJq1T2?=
 =?us-ascii?Q?BNF8oY72mzptYHfaf8G84C7+OzBTjkeAXEXaFqFNpY9WIYs056s7GJIMAH12?=
 =?us-ascii?Q?dMvqZe5syqsMV5SEiwOG+fRsAF3Mg3ugpb9trS82+CoVG4CYxtBPAyHnYEdj?=
 =?us-ascii?Q?OZ8ynmm4JO6Hn12y2fyRCMM5IvoTQfG9Oh+0hSCngRalMUgGMP3WtQO6ig1y?=
 =?us-ascii?Q?NHbg+yDIa0VSd0EEQIccZxOVleWHygqpvnnTZI07POZDZvZIOwQ+1dRuBtYW?=
 =?us-ascii?Q?NX3BCjqUVGK8W9gqTZlSptPD+RIbJ41gRF9b+FVpO1Ow8gr7z6UNBAglVTld?=
 =?us-ascii?Q?ujXUAHySptja20WVgrL8ohmNRdXMkV6lsgpuK8D4733s9lqSF8oYqFCGeaTC?=
 =?us-ascii?Q?sq27uz7ZKcT3H5uj8KO5V73d43nZ7jXp1VrEcC9c8dxQqGHEukazfXJMO9iW?=
 =?us-ascii?Q?x5WH5NOxLx/fBofAdE2uG7BYxJWOIdPAVTfXly6Tb88eKDZm6TWFEDGDVgfT?=
 =?us-ascii?Q?7FIomxBTzy2PhHY2MScUoUf+FEkgg8S8VLmEBQnB9DI+LhmRvyp9z3rV5igp?=
 =?us-ascii?Q?2oesTUpmli2Jhj+bGbDpMzmpe1BssxvZxrw4i8wMSfId3NBuwaYQdDoQjMTW?=
 =?us-ascii?Q?bRbTN3HLt5YcD9Dmx4EVpXCsL1+BJpE5EBhUw/A3U//b3vkHGpY1thCv5V4u?=
 =?us-ascii?Q?tROntR1OcJ8sG09z41yMzTQEkBvmvXU6Vp3TgVtEym2PRUUswvNzVpVQ7Pcs?=
 =?us-ascii?Q?t2aHdDkDjWK0mwZsjS7twATIA1+Lf9SrBFZXSO5RSZS8LjvqEMet5Xf/A/dd?=
 =?us-ascii?Q?2oNohxhCyHKPGbz2Q5F3UWOwqRlVs4xZAunsjumPefURTlQU4R3k3dqG4+KH?=
 =?us-ascii?Q?FH+KbHuwjPmyXdhwSVq+nfmujOfS/ypld7ZY2u7Oybba8Lm0iZx14lT7NdWB?=
 =?us-ascii?Q?N3gQDRsxLgoWhY/Fc8lhTU50am/49xypCfnS64GG8o5ZULuLygpiAUJNN326?=
 =?us-ascii?Q?Qn0Mb87rCp8wrXwk5ODhfwi0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR21MB1586.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8952dda2-15ee-4aa7-8c78-08d963f0ca7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2021 15:40:08.7649
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 99cyBQnHfXNgKPnTN0avtns84U9PaVoHFQe1/qYdj/dpMDUiFeqzyMsnwm4c+SfG3QgfgpQzH3V8+03B8A1OaY00KS2xJekq+mqk1jvd4fg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR21MB0181
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: hch@lst.de <hch@lst.de> Sent: Thursday, August 19, 2021 9:33 PM
>=20
> On Thu, Aug 19, 2021 at 06:17:40PM +0000, Michael Kelley wrote:
> > >
> > > @@ -1824,6 +1848,13 @@ static int storvsc_queuecommand(struct Scsi_Ho=
st *host, struct scsi_cmnd *scmnd)
> > >  		payload->range.len =3D length;
> > >  		payload->range.offset =3D offset_in_hvpg;
> > >
> > > +		cmd_request->dma_range =3D kcalloc(hvpg_count,
> > > +				 sizeof(*cmd_request->dma_range),
> > > +				 GFP_ATOMIC);
> >
> > With this patch, it appears that storvsc_queuecommand() is always
> > doing bounce buffering, even when running in a non-isolated VM.
> > The dma_range is always allocated, and the inner loop below does
> > the dma mapping for every I/O page.  The corresponding code in
> > storvsc_on_channel_callback() that does the dma unmap allows for
> > the dma_range to be NULL, but that never happens.
>=20
> Maybe I'm missing something in the hyperv code, but I don't think
> dma_map_page would bounce buffer for the non-isolated case.  It
> will just return the physical address.

OK, right.  In the isolated VM case, the swiotlb is in force mode
and will do bounce buffering.  In the non-isolated case,
dma_map_page_attrs() -> dma_direct_map_page() does a lot of
checking but eventually just returns the physical address.  As this
patch is currently coded, it adds a fair amount of overhead
here in storvsc_queuecommand(), plus the overhead of the dma
mapping function deciding to use the identity mapping.  But if
dma_map_sg() is used and the code is simplified a bit, the overhead
will be less in general and will be per sgl entry instead of per page.

>=20
> > > +				if (offset_in_hvpg) {
> > > +					payload->range.offset =3D dma & ~HV_HYP_PAGE_MASK;
> > > +					offset_in_hvpg =3D 0;
> > > +				}
> >
> > I'm not clear on why payload->range.offset needs to be set again.
> > Even after the dma mapping is done, doesn't the offset in the first
> > page have to be the same?  If it wasn't the same, Hyper-V wouldn't
> > be able to process the PFN list correctly.  In fact, couldn't the above
> > code just always set offset_in_hvpg =3D 0?
>=20
> Careful.  DMA mapping is supposed to keep the offset in the page, but
> for that the DMA mapping code needs to know what the device considers a
> "page".  For that the driver needs to set the min_align_mask field in
> struct device_dma_parameters.
>=20

I see that the swiotlb code gets and uses the min_align_mask field.  But
the NVME driver is the only driver that ever sets it, so the value is zero
in all other cases.  Does swiotlb just use PAGE_SIZE in that that case?  I
couldn't tell from a quick glance at the swiotlb code.

> >
> > The whole approach here is to do dma remapping on each individual page
> > of the I/O buffer.  But wouldn't it be possible to use dma_map_sg() to =
map
> > each scatterlist entry as a unit?  Each scatterlist entry describes a r=
ange of
> > physically contiguous memory.  After dma_map_sg(), the resulting dma
> > address must also refer to a physically contiguous range in the swiotlb
> > bounce buffer memory.   So at the top of the "for" loop over the scatte=
rlist
> > entries, do dma_map_sg() if we're in an isolated VM.  Then compute the
> > hvpfn value based on the dma address instead of sg_page().  But everyth=
ing
> > else is the same, and the inner loop for populating the pfn_arry is unm=
odified.
> > Furthermore, the dma_range array that you've added is not needed, since
> > scatterlist entries already have a dma_address field for saving the map=
ped
> > address, and dma_unmap_sg() uses that field.
>=20
> Yes, I think dma_map_sg is the right thing to use here, probably even
> for the non-isolated case so that we can get the hv drivers out of their
> little corner and into being more like a normal kernel driver.  That
> is, use the scsi_dma_map/scsi_dma_unmap helpers, and then iterate over
> the dma addresses one page at a time using for_each_sg_dma_page.
>=20

Doing some broader revisions to the Hyper-V storvsc driver is up next on
my to-do list.  Rather than significantly modifying the non-isolated case i=
n
this patch set, I'd suggest factoring it into my broader revisions.

Michael
