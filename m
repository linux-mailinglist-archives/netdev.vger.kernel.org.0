Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9C578C1B
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 14:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfG2M6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 08:58:36 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17556 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727336AbfG2M6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 08:58:36 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x6TCt8xP001188;
        Mon, 29 Jul 2019 05:58:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=upNtt0dM0HI99yVcA3STqBoGScm2lkVjLWXzIxhah9Y=;
 b=FafP39XeKb+aHE4/Q6jENNcrOPbkc1P6zEQe125bNKFs0I5qUkE1PD4q2fOyYn6BvAOE
 VBSFn3zrsQPsGKs405qfoCZDQdgtDFz3lAv7V7MghjYHe9kUOPV8TgsEu0jysMKyrXj6
 sphHZOfopyin9fzCoucsGP+PP9SfiuWc97IHKBGaWyuog1nRaOxlzi2TmypWacGmFdk7
 1euPqM7tUx1vl5DotBiv/+2wNTlIXIS1m3gE+w1F6o0b8tXJCTW+PDfaef5VyajK5YfC
 b99f2K93q29TL8CKSQu1+O0twRMjLegIRCWDvYsUG/hgCGv+hc3JkEfHiy2fNTArm+5D mQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2u0kyq05v2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 29 Jul 2019 05:58:31 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 29 Jul
 2019 05:58:31 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (104.47.42.55) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 29 Jul 2019 05:58:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QYxn/R7JUHj0yYZnCwrl6zOr7Iuj4WeOVXHKC6ZgKqORZ70dwHHknT4Sfu81kRiDUQnnhRgVlOWkigG5RReIXQN0JB9XV2D06j25+j8vzXbEJ3tErjcoskYNuXt3dffweO0jv0fayRSX6OYA/pnzsf9oKbb9dT/FGYY+TqzZkhGvw/YnsQBiQi8sy4jysTzbY8oOCtcD006Brs3il2pUgMe6pxOb2lpEzFupNMyhZV+zAo/Xos8PaGZMgvsFjXjRxTPJOw4ol8+dmy8dwkuzVv48mZ2isxoy3FXaXJhqi3GlzWRdGn7xfL+5OOskIHzqOEi8OVhSdXLNscq2MsrM+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upNtt0dM0HI99yVcA3STqBoGScm2lkVjLWXzIxhah9Y=;
 b=h2O4orzlEyZMDVQYm1sWHDW1pc1dZrLT+P5st4eFp5UAjyzOCSejpfhGeiTaTDEn3BjIwCJiUGTKJsHnBUAP3CpJkOjXMF+PayOZGmr99z6oneX2d3kT269bu9LuPyFzPcvKNDh57uOdGiQURJxszT60gDvJhHEkn94DiLmTMsDEXxIaf5SFj4zahH8FeZfZg5vZ9kiphKsn0EfM9gtt2LQ61h9WuuWwfELvJ3VG/mtuRJ4rhvS9vhoHz3xXilaVJ60rdZI4J7nX25gUKZbsbKRnNNq3fCI6+RmtaDj1YfdONoFdCe99MYwWRF1aCy0Y/qL8H0rNbR/dIw9OeK6t0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=marvell.com;dmarc=pass action=none
 header.from=marvell.com;dkim=pass header.d=marvell.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upNtt0dM0HI99yVcA3STqBoGScm2lkVjLWXzIxhah9Y=;
 b=ISy2k12KpBKEv1fRgxk1tGJmgxTbRa1vMslaHXqxJhBzgRcvycSnMQT6otIApVJFas5FgGP8Q5GGbbvlq7CITXO3UtdMq+5O+uoZyrUvUqZJ2NcMMTIyCOyv4O7ywxY+tpXswwmTxyi3OnbvetLZnYFmDsL5gy2fYdQz/Z4jTCM=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB3055.namprd18.prod.outlook.com (20.178.255.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 12:58:29 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::8cb3:f7d7:8bb2:c36e]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::8cb3:f7d7:8bb2:c36e%6]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 12:58:29 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "galpress@amazon.com" <galpress@amazon.com>
CC:     Ariel Elior <aelior@marvell.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "galpress@amazon.com" <galpress@amazon.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v6 rdma-next 1/6] RDMA/core: Create mmap database and
 cookie helper functions
Thread-Topic: [PATCH v6 rdma-next 1/6] RDMA/core: Create mmap database and
 cookie helper functions
Thread-Index: AQHVNmFHCA5NoSkqKU2zcNxJe13QUKbbt5QAgAX1jTA=
Date:   Mon, 29 Jul 2019 12:58:29 +0000
Message-ID: <MN2PR18MB3182F4557BC042EE37A3C565A1DD0@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20190709141735.19193-1-michal.kalderon@marvell.com>
 <20190709141735.19193-2-michal.kalderon@marvell.com>
 <20190725175540.GA18757@ziepe.ca>
In-Reply-To: <20190725175540.GA18757@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [212.199.69.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7379f766-5e35-48ac-8932-08d714247410
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB3055;
x-ms-traffictypediagnostic: MN2PR18MB3055:
x-microsoft-antispam-prvs: <MN2PR18MB3055AF5C724769C9CD21D2EBA1DD0@MN2PR18MB3055.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(346002)(39850400004)(376002)(189003)(199004)(6506007)(74316002)(71200400001)(68736007)(71190400001)(86362001)(6436002)(99286004)(66446008)(64756008)(66946007)(76116006)(66476007)(66556008)(316002)(26005)(9686003)(305945005)(256004)(14444005)(7696005)(76176011)(229853002)(486006)(476003)(110136005)(102836004)(54906003)(55016002)(53936002)(52536014)(5660300002)(186003)(11346002)(446003)(4326008)(6246003)(33656002)(81156014)(8676002)(8936002)(81166006)(2906002)(6116002)(3846002)(2501003)(478600001)(14454004)(7736002)(66066001)(25786009)(130980200001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3055;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xACGGbSrvYSZX1JR9RUVU/zOzXFmmnguzJSw6aE3qBM4KoEMM6apM4K7e0JhMzA94YX1P5BLkG2ras7XR5cz6X+t6bvZ8XQXVwmSi3BruakEI80lKryYdSW2853aVxfy7XjByXu9pNxW3F0v/HkN33OX+hu0HYJNOdmOMGEL8jANlvI+PDkUBuR1uefRn0JivWgw1v9GAd/zpPkdqLczIZQwh0ToUHc2+O7C9KhW7b80z3c5x0pcLETfIRoicsV7vMMuO77iUaRENfGPu0zPkeLeCXpLT72rHmb36DOIezAmHLb9kvyBaJB7QmfOdSwDsoWBdkToMdRFtvtxe5xnLT44Ui22nnIEzcJ4lVtNS8nubefT+hLzcxkPVXL2oWvh3kGMsppxvLi1vwbp9rkgwinESAwjEs3TBGpqElshPXY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7379f766-5e35-48ac-8932-08d714247410
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 12:58:29.4233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mkalderon@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3055
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-07-29_06:2019-07-29,2019-07-29 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> owner@vger.kernel.org> On Behalf Of Jason Gunthorpe
>=20
> > +	xa_lock(&ucontext->mmap_xa);
> > +	if (check_add_overflow(ucontext->mmap_xa_page,
> > +			       (u32)(length >> PAGE_SHIFT),
> > +			       &next_mmap_page))
> > +		goto err_unlock;
>=20
> I still don't like that this algorithm latches into a permanent failure w=
hen the
> xa_page wraps.
>=20
> It seems worth spending a bit more time here to tidy this.. Keep using th=
e
> mmap_xa_page scheme, but instead do something like
>=20
> alloc_cyclic_range():
>=20
> while () {
>    // Find first empty element in a cyclic way
>    xa_page_first =3D mmap_xa_page;
>    xa_find(xa, &xa_page_first, U32_MAX, XA_FREE_MARK)
>=20
>    // Is there a enough room to have the range?
>    if (check_add_overflow(xa_page_first, npages, &xa_page_end)) {
>       mmap_xa_page =3D 0;
>       continue;
>    }
>=20
>    // See if the element before intersects
>    elm =3D xa_find(xa, &zero, xa_page_end, 0);
>    if (elm && intersects(xa_page_first, xa_page_last, elm->first, elm->la=
st)) {
>       mmap_xa_page =3D elm->last + 1;
>       continue
>    }
>=20
>    // xa_page_first -> xa_page_end should now be free
>    xa_insert(xa, xa_page_start, entry);
>    mmap_xa_page =3D xa_page_end + 1;
>    return xa_page_start;
> }
>=20
> Approximately, please check it.
Gal & Jason,=20

Coming back to the mmap_xa_page algorithm. I couldn't find some background =
on this.=20
Why do you need the length to be represented in the mmap_xa_page ? =20
Why not simply use xa_alloc_cyclic ( like in siw )=20
This is simply a key to a mmap object...=20

Thanks,
Michal

