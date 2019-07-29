Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C978878F29
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 17:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388017AbfG2P1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 11:27:01 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:23094 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387854AbfG2P07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 11:26:59 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x6TF5El1006937;
        Mon, 29 Jul 2019 08:26:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=KLO7F70h+dcCBeNMCoa30edavn9G5yX/s2b8IQbjbq0=;
 b=Z/zyZxiq9Z3jRTi8NDmxGr1t2UdUNLyhIatRaf+rx24BONIYnORtlgGGAj3bqeJ2DSuj
 UtPPeDZzQ0yB2/zNVhAib3c31FtNIJK3tvfNWU1cn+qyLxl9gMxHbeHaRQUAd0DFHuhp
 eAnqXlGw6H4rDEVqG7Uwtv4fOAkQwjgnc6/qVyEwijOulwbQaJHjEs+fE9RwyiOU62/Y
 ZDkS42rxHF7AtjdoA8RaBiL6/rA0detLUt7BPAkRFX1pGJRabUtDNHDPsq3MiymRiJnn
 ZFlqJs1PqEnUXurtdzt5aGYXuzoYj8A7krT/6hLwnais0W7mAAoSsQtqM2mL2fT+vBXy vw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2u0p4kyr16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Jul 2019 08:26:53 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 29 Jul
 2019 08:26:51 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.55) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 29 Jul 2019 08:26:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a3BNah5OcWQio62kRsiLLSU16F71REDH/S9m7mB3YDQMb7d4LeVxYIcVCEDB+yM5ygf1y+ILg0jpfFwl6bg6hhGhHm0nxh2pFm8n/WwEsdgMbZ+TiDVGTfPXchSVIEWNgP7z4qxfReP6I0QMSDlD4SOw8da8wAOynz/iyNghnpKIdqnzKsJJzGzasFwOo5RaWCPuN9wAbjzviDfssOtRahX3DaQRp7jgAX6juveJNwgDVTyCxyOJS9RsXi1lG69WayFv1DVSpVxYP6ctZUBk3cpAM7T7bwB8C+bmrMX79KsRQp4fPD53aVBBRQfZoRfkkLwDf/kQ1JPhiiTCmCDwoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KLO7F70h+dcCBeNMCoa30edavn9G5yX/s2b8IQbjbq0=;
 b=iH8L7LPVy+awIrCjI3sZryS1VYids2dHisvYMAK9xIPDaudMQeBtEDnFkXtTVrn4Q/4ETRdrhs7CvyVmdmpj6l/iHRbDCfe8avuV1Dom43Ud7+vSRrN97LfUFuyTFGV+FC6F0LZ9HnpaffU7nw5mbYfeTrsnZ5wrh2KFWGeCt+azBQj88WwjQtlCyohFCJG2b+wY8qWsIMZPKWaN3omHlHTwJyucRdpduMD34FrhzsjqF+6+FT8nDGMJaNd79/o/mXMHa8KPI8nuZg54N4YpLpqaA0+lPruSO4cPGlTPH8z3rShOBAiLQANym/jLAn8Nhjz9ArbGx2FNgoMg/J1viQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=marvell.com;dmarc=pass action=none
 header.from=marvell.com;dkim=pass header.d=marvell.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KLO7F70h+dcCBeNMCoa30edavn9G5yX/s2b8IQbjbq0=;
 b=iujCwskjzUgFScpgYS+zdT7kEPakm+S0+FWyNL4JgflV0A9LIQmLkz2GlDzS2HAU90e+O99gVMu0756Rv1RwxrV5ml61gAc8nv+YoOU8cVJ/pJVuxlYuqzzmLVrk98AR402BhWEQ2RX6zrvJmgtkSRMz17LhbI/v/zxGi4XqHto=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB3344.namprd18.prod.outlook.com (10.255.238.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Mon, 29 Jul 2019 15:26:49 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::8cb3:f7d7:8bb2:c36e]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::8cb3:f7d7:8bb2:c36e%6]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 15:26:49 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Gal Pressman <galpress@amazon.com>
CC:     Ariel Elior <aelior@marvell.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH v6 rdma-next 1/6] RDMA/core: Create mmap
 database and cookie helper functions
Thread-Topic: [EXT] Re: [PATCH v6 rdma-next 1/6] RDMA/core: Create mmap
 database and cookie helper functions
Thread-Index: AQHVNmFHCA5NoSkqKU2zcNxJe13QUKbbt5QAgAX1jTCAABAnAIAAAxoAgAAWujA=
Date:   Mon, 29 Jul 2019 15:26:49 +0000
Message-ID: <MN2PR18MB31829FDCF4FB29CCA3059930A1DD0@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20190709141735.19193-1-michal.kalderon@marvell.com>
 <20190709141735.19193-2-michal.kalderon@marvell.com>
 <20190725175540.GA18757@ziepe.ca>
 <MN2PR18MB3182F4557BC042EE37A3C565A1DD0@MN2PR18MB3182.namprd18.prod.outlook.com>
 <d632598e-0896-fa10-9148-73794a9a49d7@amazon.com>
 <20190729140444.GB17990@ziepe.ca>
In-Reply-To: <20190729140444.GB17990@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [212.199.69.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3de41c21-b71b-492d-f586-08d714392d25
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB3344;
x-ms-traffictypediagnostic: MN2PR18MB3344:
x-microsoft-antispam-prvs: <MN2PR18MB33446329583AB6094939FEC3A1DD0@MN2PR18MB3344.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39850400004)(396003)(136003)(366004)(376002)(51914003)(199004)(189003)(316002)(478600001)(68736007)(9686003)(186003)(486006)(81166006)(71190400001)(71200400001)(256004)(26005)(110136005)(76116006)(53936002)(6506007)(53546011)(66066001)(6246003)(305945005)(102836004)(66946007)(54906003)(64756008)(66556008)(66476007)(66446008)(8936002)(99286004)(52536014)(76176011)(4326008)(3846002)(86362001)(2906002)(74316002)(14454004)(6116002)(14444005)(11346002)(476003)(5660300002)(7696005)(33656002)(7736002)(446003)(81156014)(8676002)(55016002)(229853002)(25786009)(6436002)(130980200001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3344;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ncv7jgBfSYjFPlKo5y6tZIKL8FR4KSuDYQR3EGrx9Qp1v/QLtA3UHP6XjYJY17SqsXnyAGeuVDduBkkuG8oeY219t3XmMqSEoy7TQaJju37iIanXuDttS9eH3CT5CWLlzOTcQF7cGD5P/mRS8HMiROgKjhVTmzVFH60JMHUfG+zW1AiJl2vWMi6D7OFcT43u7BVr6eKM+Ta0jPUgasTnBwyRu2k32PnmcnV6xBPIWTqsVVNVXdTN/xbvKv8IDlwNd0FRNea51kz8kGiuxQEcBQvO8OHW+SS9FwPsNfVjXyCR1ZVC5c+dEelIj/2YEG++Y5FQhDFQQdeBg8GquaWvXA17XEMzvQ+9JudmlhEVREqZKaKK3CGQmvWVPT/ATKuXU+QTkbT436QKa2d24yGb3Sr0gsvErSenjSSTFfvP7oI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3de41c21-b71b-492d-f586-08d714392d25
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 15:26:49.8398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mkalderon@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3344
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-07-29_07:2019-07-29,2019-07-29 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Monday, July 29, 2019 5:05 PM
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Mon, Jul 29, 2019 at 04:53:38PM +0300, Gal Pressman wrote:
> > On 29/07/2019 15:58, Michal Kalderon wrote:
> > >> From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> > >> owner@vger.kernel.org> On Behalf Of Jason Gunthorpe
> > >>
> > >>> +	xa_lock(&ucontext->mmap_xa);
> > >>> +	if (check_add_overflow(ucontext->mmap_xa_page,
> > >>> +			       (u32)(length >> PAGE_SHIFT),
> > >>> +			       &next_mmap_page))
> > >>> +		goto err_unlock;
> > >>
> > >> I still don't like that this algorithm latches into a permanent
> > >> failure when the xa_page wraps.
> > >>
> > >> It seems worth spending a bit more time here to tidy this.. Keep
> > >> using the mmap_xa_page scheme, but instead do something like
> > >>
> > >> alloc_cyclic_range():
> > >>
> > >> while () {
> > >>    // Find first empty element in a cyclic way
> > >>    xa_page_first =3D mmap_xa_page;
> > >>    xa_find(xa, &xa_page_first, U32_MAX, XA_FREE_MARK)
> > >>
> > >>    // Is there a enough room to have the range?
> > >>    if (check_add_overflow(xa_page_first, npages, &xa_page_end)) {
> > >>       mmap_xa_page =3D 0;
> > >>       continue;
> > >>    }
> > >>
> > >>    // See if the element before intersects
> > >>    elm =3D xa_find(xa, &zero, xa_page_end, 0);
> > >>    if (elm && intersects(xa_page_first, xa_page_last, elm->first, el=
m-
> >last)) {
> > >>       mmap_xa_page =3D elm->last + 1;
> > >>       continue
> > >>    }
> > >>
> > >>    // xa_page_first -> xa_page_end should now be free
> > >>    xa_insert(xa, xa_page_start, entry);
> > >>    mmap_xa_page =3D xa_page_end + 1;
> > >>    return xa_page_start;
> > >> }
> > >>
> > >> Approximately, please check it.
> > > Gal & Jason,
> > >
> > > Coming back to the mmap_xa_page algorithm. I couldn't find some
> background on this.
> > > Why do you need the length to be represented in the mmap_xa_page ?
> > > Why not simply use xa_alloc_cyclic ( like in siw )
>=20
> I think siw is dealing with only PAGE_SIZE objects, efa had variable size=
d
> ones.
>=20
> > > This is simply a key to a mmap object...
> >
> > The intention was that the entry would "occupy" number of xarray
> > elements according to its size (in pages). It wasn't initially like
> > this, but IIRC this was preferred by Jason.
>=20
> It is not so critical, maybe we could drop it if it is really simplifiyin=
g. But it
> doesn't look so hard to make an xa algorithm that will be OK.
>=20
> The offset/length is shown in things like lsof and what not, and from a
> debugging perspective it makes a lot more sense if the offset/length are
> sensible, ie they should not overlap.
>=20
Thanks for the clarification=20

> Jason
