Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A3A30BE39
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 13:33:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhBBMcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 07:32:46 -0500
Received: from mail-db8eur05on2052.outbound.protection.outlook.com ([40.107.20.52]:2912
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229894AbhBBMcn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 07:32:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ef4+ST9Bzy+3RBGq39IX/oVwah/HcKkTj9B1FwkNuIqLGaV/YL01FV0KWjOEN7cCSQ0W5s8ahXBXWZbw8rpKi3KmagNuvAQYMGgrQDwsDgdNdBvvui+29UsddsmWAqs7Si6SfYA0H3MqFpUUi1Q2BAMo1Ihy7DEjS3wFJ3qJOLLpf6OugrP531DakkrqtG0LkXAKlF/hG2XI2WMucALyHkS0Gp359g15BDyEI3K6Cxe6nTYg4eIgO//bOx+Fw3TdeMtjxF1DXSxTy/MS5JzyXrT8EyEM0+Ogwq9tmRsJUTjEHMmNWK/uqAbAkyOeALNVE+H49F8LOyRJT87YTPbyJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfJ1YpuVD5pmkPR6PxSbM9s3EcTgtYJTjRwyQnopxV4=;
 b=gRpy28GOITqT23uodss14fnjEnqtVcBiEd2NzW4eH+4EEkU1Lga79QugTC0iLNUBKqi0eTvTQtyu8TvI6sD1IGo+9HGZhZOjs4stnYFp3f+hCyjInjAzCTrugYqAwwGKhrI602yELCNvpeD9DFaPUn4VPz/UK3ET9EttgROud1U/8fp4hw5+Oz/qzO4gjXtMYJ3k8DvtE1xtc39YKMLUl2dm4IBj5pfKVpfJL8oJEU9NER00YH0PURqBMWuVAFkn8FpZQg9S661y3G4GteStk6ZqWg4AWMBjpkyTVzQOhFig82TVgTYOCV5btl3d96kAbobfr3MZTYn6BX9/R7Xtzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfJ1YpuVD5pmkPR6PxSbM9s3EcTgtYJTjRwyQnopxV4=;
 b=l0Z5jHlBs6C7V3QrtMLcks+YhecHgBCPcHF9a6c0/La0u/OGlOL6MMViuflGuo/U04tTJnbPE1MFMNRcpLLPYsfJxAdOIcawuxDx26pvUKaopQL7iVzbf4nKk3llRmL8cjm84B8xyN3+Hu0ZQIWtc5IpZ8ScbIOXV9jXQ1iaegA=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VE1PR04MB6446.eurprd04.prod.outlook.com
 (2603:10a6:803:11f::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Tue, 2 Feb
 2021 12:31:54 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::b0d0:3a81:c999:e88]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::b0d0:3a81:c999:e88%3]) with mapi id 15.20.3805.028; Tue, 2 Feb 2021
 12:31:54 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Vlastimil Babka <vbabka@suse.cz>
CC:     Kevin Hao <haokexin@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next v2 1/4] mm: page_frag: Introduce
 page_frag_alloc_align()
Thread-Topic: [PATCH net-next v2 1/4] mm: page_frag: Introduce
 page_frag_alloc_align()
Thread-Index: AQHW96aigj98D9qGVUCzC1fhplt6KapEv/AAgAADZwCAAAwhgA==
Date:   Tue, 2 Feb 2021 12:31:54 +0000
Message-ID: <20210202123153.tt7c6icrysrbpluc@skbuf>
References: <20210131074426.44154-1-haokexin@gmail.com>
 <20210131074426.44154-2-haokexin@gmail.com>
 <20210202113618.s4tz2q7ysbnecgsl@skbuf>
 <2d406568-5b1d-d941-5503-68ba2ed49f34@suse.cz>
In-Reply-To: <2d406568-5b1d-d941-5503-68ba2ed49f34@suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [5.12.227.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 83cbea54-3903-44c2-59de-08d8c7768653
x-ms-traffictypediagnostic: VE1PR04MB6446:
x-microsoft-antispam-prvs: <VE1PR04MB6446AE8336FCFE3BE602D212E0B59@VE1PR04MB6446.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uKRU8KjYDsBHMO8eKRJ+6sTZAMVOs+f4zRcxYtGv6Y9hgwJLQCOdnpYVNq39wyQM3RgoP0qAm2wOpa2xop0/loplxG/04iV9tEWp2DpXbgHppjdOBe38fB8f/vl8w7hfuI/inCc+tsRHBX1ttFBlmIMbkAo6gHFHnMIDHSK8BTglp9B4N49Yx4J+zCsO3BfjAr3c7wALvd2CtQyYiGqnb32pBkybxpisgJdJLd6pY0k9WLeg+MyxmCcfci46oXhGKTZGWdlYJBoV/iTWPBUkj7yj2r1r/LjOXmFWZJ1jEU197GX1lCnk4Eoj9Deg5n3gcITS8ZJl4iViiTZUOWKYqbE5VjpJ+rq70EjdcvY9Hwj1U2lDWPFUZMpQRllaiY9mTW/jSQw0zGQUcaNkk+XOAGed0rCBsBTh3fxclMswSmeWT3snl4aNUAUtyIOQQfdCNq5hOddebh1Z2TajM9LugL4B7MPVjPV5+bXMdpHlOcp2IdGtV0X6VNGD4kvuYPyUeVUETD6Q3eN7G8rgQt5mkw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(346002)(39860400002)(366004)(136003)(396003)(376002)(478600001)(4326008)(186003)(53546011)(8676002)(9686003)(316002)(26005)(5660300002)(76116006)(66446008)(66946007)(91956017)(54906003)(6506007)(44832011)(1076003)(64756008)(66476007)(66556008)(8936002)(33716001)(71200400001)(6916009)(2906002)(6486002)(86362001)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?qz+1sE7T7HLUUwPBZHUUaaW1p+7EaerV2PiIzAIL6niTO2XhKk5abgxxDTwP?=
 =?us-ascii?Q?NJwFtNH1g8iqF3u6M3/0wO6A0J/Q2vlnh4WCu8t3u+GuXw2XI0t+sGHAjuJG?=
 =?us-ascii?Q?gldwogpzANbnAz9v2o5QxQMqqrzw9JGiU97lmXaoB9rqY8IwtQjAQpNqLYbJ?=
 =?us-ascii?Q?wvsM2iXTQixkwx/R+8N67TMh1V7ilJvrlKMIZNQdUowjtQKxkta0RXgGGzdQ?=
 =?us-ascii?Q?wECuyvG+tP2OGdDBapiiFMYQh5IiYTP5lrMCi1yIaWVitTqM9i2nBakS82lg?=
 =?us-ascii?Q?qUpzBwOvhxU4r8d6YT7MbVqpS5pvttEw1h6uLoz3qv8mfMU0PhQup+HvwpC9?=
 =?us-ascii?Q?2i0WvBegSIXOoyyuFppSb2LedfMjltxMKEfrTGJx1WJ0VE6bO9wQ5sMCLNGh?=
 =?us-ascii?Q?Il+DWE3w47TtmkxGzxnH1oP6tGAkfFzTUEgp+i1gVSy0WrlxIgk2v4/hJF01?=
 =?us-ascii?Q?qY+3t3bBi/5uWVXQLavkXESWq760HP15hRfuzMJO/czMTptile8QIGmM/q5o?=
 =?us-ascii?Q?E1g5FLG8+3gt+HyKZTofZlR7fpwbo+mokRjtV3ITbsg/4a9KJa1yqQ9lg6oD?=
 =?us-ascii?Q?KCn6EeAwqtmFDhKRtwtp4VqOBSpqs0xAdcejCY03i2FCJqprTG6J/OsqNre6?=
 =?us-ascii?Q?Wb96e4qFqhmFvYz3DyW8tOacnLX5ZMZfdAQTAUGbHZMwjS0BZy6geg6tDuJ0?=
 =?us-ascii?Q?qD19tpOMow/2VhtuqFeETwReJnvhk2y9AZySbDnthKJrqg8bl4zFyPpMBPF2?=
 =?us-ascii?Q?O0G9aYNi7Pjcv/0nVGWL4Lc49+sRiSffq4j7ic4K27FvHbOGNGqyAmTJc6bh?=
 =?us-ascii?Q?+vLLKjlGP6ogRbCzyDvFWXUzZ+5nZlf88z2xyKbSbAZRzY5uVfXA4XUTViOt?=
 =?us-ascii?Q?y0nMPCQquSfOCJTI4v22YNU0GP4qQ32erhpEB293JDzt42ZaE0sVQOfH6frm?=
 =?us-ascii?Q?wkBu/f77KMZs+m3jLjGdB7n/DJKHTVvTzHihkIcUQEPM/z1Fry8IOAoWqfHM?=
 =?us-ascii?Q?eyzeh4e0GO0mmPEU8CzlmmY/5ahc5vcrr9svdg9mUVg9sRkHIp132Yxz9Hng?=
 =?us-ascii?Q?O/RGkz0W?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5678FE9487C6314199EA5D0110B8AC43@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83cbea54-3903-44c2-59de-08d8c7768653
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2021 12:31:54.1575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UbrBIKzchWtn5gFfVm2d0aOsfJe4+FqOyrluK+4iRisv3U0vDUTuCcZbfze1CaA02k+9eZBrxdRPJMtaPhsxJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6446
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 12:48:28PM +0100, Vlastimil Babka wrote:
> On 2/2/21 12:36 PM, Ioana Ciornei wrote:
> > On Sun, Jan 31, 2021 at 03:44:23PM +0800, Kevin Hao wrote:
> >> In the current implementation of page_frag_alloc(), it doesn't have
> >> any align guarantee for the returned buffer address. But for some
> >> hardwares they do require the DMA buffer to be aligned correctly,
> >> so we would have to use some workarounds like below if the buffers
> >> allocated by the page_frag_alloc() are used by these hardwares for
> >> DMA.
> >>     buf =3D page_frag_alloc(really_needed_size + align);
> >>     buf =3D PTR_ALIGN(buf, align);
> >>=20
> >> These codes seems ugly and would waste a lot of memories if the buffer=
s
> >> are used in a network driver for the TX/RX.
> >=20
> > Isn't the memory wasted even with this change?
>=20
> Yes, but less of it. Not always full amount of align, but up to it. Perha=
ps even
> zero.

Indeed, the worst case is still there but we gain by not allocating the
full 'size + align' all the time.

Thanks.

>=20
> > I am not familiar with the frag allocator so I might be missing
> > something, but from what I understood each page_frag_cache keeps only
> > the offset inside the current page being allocated, offset which you
> > ALIGN_DOWN() to match the alignment requirement. I don't see how that
> > memory between the non-aligned and aligned offset is going to be used
> > again before the entire page is freed.
>=20
> True, thath's how page_frag is designed. The align amounts would be most =
likely
> too small to be usable anyway.
