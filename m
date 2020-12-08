Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C81E2D276D
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgLHJXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:23:44 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:63696 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727096AbgLHJXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:23:43 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B8959TM020981;
        Tue, 8 Dec 2020 01:22:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=d1s5WfUhQJQfNxG66EI5Lb94VEWFpxytOWakeq6+NWQ=;
 b=B7oeDBr3VQBfKsaGyIphKCQ1VI23K3uUkVDIqOaurOfK1watMVRyNOS8U71mIZeXjopQ
 hZh1qhPdW+AtHF+WfGewe2HS/V/+OdD5xyml1f/lDX6Kd3tAWZiP4cQlmkC+WmAaExvv
 n+AYnUvAPjaNSznnM2keSx1seAueT9+KU8rItNyA4CjxST55PALVbCAKKE7lHySZaAMm
 npQ+H/gtyArsFGB33tRWL+4li08ATo45nfYMofiRxq6kOSWRaE38fdnrYHZEXXQOtQXB
 6LO0x8Ik8a2lr0NATyDbUONMdFTAKgmyhiZlL8CgyvrS624/aNNXT9YA24uUXgqenAGD Dg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 358akr770v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 08 Dec 2020 01:22:56 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Dec
 2020 01:22:55 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 8 Dec 2020 01:22:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZkxKz1ox+ypsCLeOVn/vlgE+t9Qk8ddRiZmvkglnwKog+TO9t5X3TJ4HPBtAmEwOPOAVqaa3WtZbJsIAhyO0vQOZqeSQnx9IQpa3NIK345FvxAhx+h3wTwlstXfg9YG2RpNdYReGTCsQ3pOoW+h9WOdmHw5AJfUAjKNtv0Xrc7LFqmeKoS3EPwFz0uatG93K62z9SxXBTpf6KPlr4c34vqRZiVpFaD7VfB2ItWkTIrXtuJ+YZzq0gVmIRoaMSXfzJDDsD5gT8RtyvGSCiMVuODMeeHMLi+Gw0n3bMitRDTey6iQ/mP1WQG6lxWKzHioE5G4yHLFFhf/byF8pm5ximw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1s5WfUhQJQfNxG66EI5Lb94VEWFpxytOWakeq6+NWQ=;
 b=b0LJo6utceB0DwWL5/9OsjPfGWXjugx+30AUTEEytJkBhItLiFyROMdzcp1zU7hg3scShHV6bji1u/t9UXFGjRiW8w6vqvLy+0jrQuQIxpjRDJtv+7eU2BixT1k5CAke2XJ1sGwS+Q3j2y1TrsmBQ6rGT5ym8/WoUuI+GUxoZ/2Od9imvs7DInHKcfP8q9whWS7NkOee36yzDz1Zk4e3VOtq68bzsLuchT49CSuK7vaJjCGGhYRm+K3djkfaoeBNnZdIXvIVJoYIL19CC2tmeo/2ugLDQOJJvAESg0dRYSsXii+gnauzdETGxCzulC89IrWLjfTi/9P+yztNCWvRLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d1s5WfUhQJQfNxG66EI5Lb94VEWFpxytOWakeq6+NWQ=;
 b=llivclLgX0zW7aOEaX3Ox5dRrJe8szquQs5LyahZtssfTlKxFr65DnZXW4ho5tKHfeb1S3N6PvCMD/6DW2C3vJl+vO72Me13K80IJqrwWxCDM3KizMIfYDRFZrvLyJjjO1WeVJxKG65ftYjT3/YKeshtxiu3cf8T0hNzB9/j24k=
Received: from BN6PR18MB1587.namprd18.prod.outlook.com (2603:10b6:404:129::18)
 by BN8PR18MB2435.namprd18.prod.outlook.com (2603:10b6:408:6a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 09:22:52 +0000
Received: from BN6PR18MB1587.namprd18.prod.outlook.com
 ([fe80::7d88:7c97:70dc:ddc9]) by BN6PR18MB1587.namprd18.prod.outlook.com
 ([fe80::7d88:7c97:70dc:ddc9%10]) with mapi id 15.20.3632.023; Tue, 8 Dec 2020
 09:22:52 +0000
From:   Mickey Rachamim <mickeyr@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>
Subject: RE: [EXT] Re: [PATCH v2] MAINTAINERS: Add entry for Marvell Prestera
 Ethernet Switch driver
Thread-Topic: [EXT] Re: [PATCH v2] MAINTAINERS: Add entry for Marvell Prestera
 Ethernet Switch driver
Thread-Index: AQHWyyYV4P4pQ1rY10yROtXpmQsQsqnsWDCAgACYJDA=
Date:   Tue, 8 Dec 2020 09:22:52 +0000
Message-ID: <BN6PR18MB158772742FFF0A17D023F591BACD0@BN6PR18MB1587.namprd18.prod.outlook.com>
References: <20201205164300.28581-1-mickeyr@marvell.com>
 <20201207161533.7f68fd7f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201207161533.7f68fd7f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [109.186.111.41]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c78aafb9-bbbb-4619-757b-08d89b5ad6c6
x-ms-traffictypediagnostic: BN8PR18MB2435:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR18MB2435CC890E307D1CC5D3FEA8BACD0@BN8PR18MB2435.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: waJWsN+4RKAymlmQVlwl+oZ2Pk3SvBG5EzYFTa3uhaOMDjBzouQ8fijMobn54ISsIJB9GUX39HieSv++Zn57PgntMIODGZx24/jv0xjRsSSpi4Zo00Sva1VXfS0QYWmfntbbQlNIaJkD7CEDU48jPLAqSBDFfDU/9NrKkAOiLKA3bJ6XqglI2q3hwLizRBZa2LjYuMMavgxZSvfEAgyCfhtdSxoTOtQzrgF+ONTH/OfhE+eYXAzWnEZsrvoL2IYMFSu7v1fZNgqkDhR2f1knkRhrfSZVtq9gF+/FiV870fXP0YmYSwVfJk/Xfl5ak7RTkKrT4xgiriJ4qK7XBp07JuWBeTeJjX+a54+B9/gOj4GIloEyaQnYJFSJKRDwXPSvi81DW516OshaMxUD4lqQdg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR18MB1587.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(366004)(396003)(376002)(7696005)(4326008)(76116006)(6506007)(52536014)(6916009)(54906003)(55016002)(83380400001)(5660300002)(26005)(9686003)(316002)(8936002)(66556008)(966005)(64756008)(478600001)(33656002)(86362001)(8676002)(71200400001)(66946007)(66446008)(66476007)(107886003)(186003)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?aGvtBB2J3e8rG6AXWewAuZGgwa3vxFzzfoQalime/RdddpGpB00MQek+hMAZ?=
 =?us-ascii?Q?TlJEG5qAkRbSgb0jBwh5ep3Ua9MfQsilt5+PiFrmlXqnUQyQHTlf78NOfnWW?=
 =?us-ascii?Q?IJChr2dQk8xi0JfPrpQVfHxkxzfHCjf9tF0kI4TaTOfxibZnDNgd5jIvgk2t?=
 =?us-ascii?Q?h4KiIHUuNjgKCAEZkSnP5LSrjzTgVkcngGIDP5rnyhXTy/xKurhWMP7AiaKZ?=
 =?us-ascii?Q?asVndDhygz3ISvP77iJOJc1/sbF4hKPsHHMYgAs7x3Kl1E8Bx8v/uv0Djd/s?=
 =?us-ascii?Q?T8ZYliLtBN95wpKKqQW4VhlB14b/r0JVIlDgIrZZl6Ur9cflmBhE/WfJI6To?=
 =?us-ascii?Q?J3d3DqjHvGVBo4nk+94yIMl8zmYg7nYatdJyLNrt0j4RxALFVbX6uE22SgJS?=
 =?us-ascii?Q?/zjf8OgCmSNk0sg9lTWIQSKs8TuMTFV/9QtOVI69YxebpjEeYlFB31ZBfn03?=
 =?us-ascii?Q?D8LepQeFK3FIcLx0hWgnx67QPo7PAtZ7gmLkV9vql2Oz8iva8mgXbvuBz1Nn?=
 =?us-ascii?Q?JkWht/1ktyJd/w+efFmFe6njawJrdj/07oW5KlymlBAEZqwtlWXBT8189+he?=
 =?us-ascii?Q?+mSt8NCPjjJCF459QkZn93y3d91tN0qQxLrQ618RBXTzCAOolkbvSj/d2eCe?=
 =?us-ascii?Q?D1XptiC0w1XNynGmci/jt8xRXv7mShGSX8YnamG6xaocYJ+BciYz19xiqjyb?=
 =?us-ascii?Q?JzbOmp3odZVE+6OcrfDdUwiFG5q/30HWhuUohiRhCW0DViCtP2aiHC5Gdx5c?=
 =?us-ascii?Q?zywr9NFrKLQlW7yAxskWbbxfXJBEAkiFmzOawCw6UgYIo4XxPjpfZSGW6aO8?=
 =?us-ascii?Q?jUyPCuw48VwSx6s4JjKDhveCVi1utKcvGVzfRlI5d1P4mAQb5Xbb0QhEZHg6?=
 =?us-ascii?Q?rZU6aKia78nsZ8ZuQ+2SVQJ1npn+9s1EGTPFV2v6h5WrrABm8nNqxHxmQ5p6?=
 =?us-ascii?Q?rggVOkYow8h/x09s2WiFx20Rn7mAtEXJuGw2zTWnXyk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR18MB1587.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c78aafb9-bbbb-4619-757b-08d89b5ad6c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 09:22:52.4827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jEPXanFxdPrZY//3O9AaWwKBUEqOl6Yw2vQp1mJVGUViIVBZWaQL4W5807tt15A4lBWKBWKjDRpG8gdjODalUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR18MB2435
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-08_03:2020-12-08,2020-12-08 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, thanks for the guidelines.

> On Sat, 5 Dec 2020 18:43:00 +0200 Mickey Rachamim wrote:
> > Add maintainers info for new Marvell Prestera Ethernet switch driver.
> >=20
> > Signed-off-by: Mickey Rachamim <mickeyr@marvell.com>
> > ---
> > v2:
> >  Update the maintainers list according to community recommendation.
> >=20
> >  MAINTAINERS | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >=20
> > diff --git a/MAINTAINERS b/MAINTAINERS index=20
> > 061e64b2423a..c92b44754436 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -10550,6 +10550,14 @@ S:	Supported
> >  F:	Documentation/networking/device_drivers/ethernet/marvell/octeontx2.=
rst
> >  F:	drivers/net/ethernet/marvell/octeontx2/af/
> > =20
> > +MARVELL PRESTERA ETHERNET SWITCH DRIVER
> > +M:	Vadym Kochan <vkochan@marvell.com>
> > +M:	Taras Chornyi <tchornyi@marvell.com>
>=20
> Just a heads up, again, we'll start removing maintainers who aren't parti=
cipating, so Taras needs to be active. We haven't seen a single email from =
him so far AFAICT.
>=20
Fully clear, Taras is an expert on Linux kernel code working on PLVision an=
d under contract with Marvell.
He will became active on contributions and reviews very soon.

> > +L:	netdev@vger.kernel.org
>=20
> nit: I don't think you need to list netdev, it'll get inherited from the =
general entry for networking drivers (you can test running get_maintainer.p=
l on a patch to the driver and see if it reports it).

Right, will remove.

> > +S:	Supported
> > +W:	http://www.marvell.com
>=20
> The website entry is for a project-specific website. If you have a link t=
o a site with open resources about the chips/driver that'd be great, otherw=
ise please drop it. Also https is expected these days ;)

Can I placed here the Github project link?
https://github.com/Marvell-switching/switchdev-prestera



