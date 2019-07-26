Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E6BC76110
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 10:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfGZImQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 04:42:16 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16328 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725928AbfGZImP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 04:42:15 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x6Q8e9m6019516;
        Fri, 26 Jul 2019 01:42:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=4Cb4T0sEalw7p0bwar92+5pIB7sldt8eIhGF7Za1zK8=;
 b=tPs4RL0drpPM/rTX0Y1oqgzw2o5CGiWigt03QFdfEcfCdC0+XIWKqR6uJ5Wv4CiGQ1lS
 jCoahmtElMAfeqwKmZKgCIYyHlLYGH/R/KDiFrQHToTZbsSdrEC1NHo2hoiVleyGwKHJ
 zYM5Dc2czRNf/aL7rv9NAOaJbzYZrlZmYWsQJ+6IeH2CSKqhxni4cyqTEmKRuwjrBY17
 V2EVjM6M6G9ug2kdGtZq3+PsO4ki5ONlN24mGkt2spyiwMVhhlau76/edZ3uxUxfcCDD
 JK7bfhlUoIRcNaN667x/ek5GW56O/HRDz4ZwtG37XJy7cTWFSR+lgo8ZFsPs/23vNtid AA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2tx61rny8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 26 Jul 2019 01:42:10 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 26 Jul
 2019 01:42:09 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (104.47.50.59) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 26 Jul 2019 01:42:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iS3jbYcH7j2Oy74MAJcpUOSvM9JtycAzilGMJydGeDN0gHiy9hNCfb5Wr74opGbFzW9gK38BRK3iYYwP55jwm0436gzCWjjCYHtCXC+5i6aM+cn8oJUxAL/Aak5SSnHYLg5ca8opKv6dya6NQpLKuX8GlqayuJBJ0XII6bytoOnN6L05XP6CKdlWLx8twlFYrI0zerlo/1DO8q9FYptp0vApiJnrtuyOdDk68TUhBiDIQxXqXEjaxrGHlAEIB0WMYEa/kYHWNZGcfMU9tEEx47fon71DZVVq9q/hudzL6irDcOzQDJDCPDqUfiR9Xf3yjXNS/ipcwjDyK0W4SlNmhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Cb4T0sEalw7p0bwar92+5pIB7sldt8eIhGF7Za1zK8=;
 b=an8R8e/9R5yq8FFoh36TimdAykQOIETiGwah+JPmOGX2mVA2mesEj8VZWfo3nXTsxkw1AUWek5vnfSFDOFcBtnLD0Fi/aV3KeXYrvig0MrAWWYZcHwi3gMU4MC/KHTzERaAGyGe+8BcR3780GBuS+eGRoWOj77AoyVZ3Sh7rW2Q5QaZl2kUo63EB1lsH7p/1KiWIstD08ChB8dEORbrigjo9jfYPU2GyJtnNz0pjZumxcPIZNH6xBFHymF29v6QeHmWhbGdjqSZtKocMPMNZKdCospjL1j3mdMmQG7RFS9eInZwn4l3kue2mV/jAlk2vUDCWD3cOcQn0qRuoZUqtNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=marvell.com;dmarc=pass action=none
 header.from=marvell.com;dkim=pass header.d=marvell.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Cb4T0sEalw7p0bwar92+5pIB7sldt8eIhGF7Za1zK8=;
 b=fBEd+A7/LTaPVcJrTMHJ5S0z2of8SuGOrqMDas6/llJXNvnBqSkA7ws2il4IWWR7xSVtUDZUwSNAZ0n2HjyjsDOcih+uY57aJ8VLHBzXDakhCMKtSc77YaSbMUZgBuH6ZMBUlqeRi8lcPiPFrcJfWWHYh7kfreJc9tLlObY67hI=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB2624.namprd18.prod.outlook.com (20.179.83.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Fri, 26 Jul 2019 08:42:07 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::8cb3:f7d7:8bb2:c36e]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::8cb3:f7d7:8bb2:c36e%6]) with mapi id 15.20.2115.005; Fri, 26 Jul 2019
 08:42:07 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     Kamal Heib <kamalheib1@gmail.com>,
        Ariel Elior <aelior@marvell.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "galpress@amazon.com" <galpress@amazon.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v6 rdma-next 1/6] RDMA/core: Create mmap database and
 cookie helper functions
Thread-Topic: [PATCH v6 rdma-next 1/6] RDMA/core: Create mmap database and
 cookie helper functions
Thread-Index: AQHVNmFHCA5NoSkqKU2zcNxJe13QUKbbt5QAgAAZ4wCAAAbJAIAA1Qug
Date:   Fri, 26 Jul 2019 08:42:07 +0000
Message-ID: <MN2PR18MB3182BFFEA83044C0163F9DCBA1C00@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20190709141735.19193-1-michal.kalderon@marvell.com>
 <20190709141735.19193-2-michal.kalderon@marvell.com>
 <20190725175540.GA18757@ziepe.ca>
 <MN2PR18MB3182469DB08CD20B56C9697FA1C10@MN2PR18MB3182.namprd18.prod.outlook.com>
 <20190725195236.GF7467@ziepe.ca>
In-Reply-To: <20190725195236.GF7467@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [79.183.34.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d191582-4d03-4c54-c999-08d711a52476
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2624;
x-ms-traffictypediagnostic: MN2PR18MB2624:
x-microsoft-antispam-prvs: <MN2PR18MB2624763D531DA7258D710FC6A1C00@MN2PR18MB2624.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(39850400004)(136003)(366004)(396003)(199004)(189003)(102836004)(6246003)(66946007)(6506007)(7736002)(74316002)(316002)(64756008)(76116006)(76176011)(26005)(8936002)(5660300002)(14454004)(3846002)(6116002)(9686003)(305945005)(81166006)(6436002)(99286004)(66446008)(25786009)(68736007)(486006)(86362001)(2906002)(66556008)(81156014)(55016002)(54906003)(8676002)(446003)(11346002)(229853002)(33656002)(52536014)(4326008)(66476007)(6916009)(66066001)(7696005)(14444005)(186003)(478600001)(476003)(71190400001)(256004)(71200400001)(53936002)(130980200001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2624;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5bjwRBx44GOkHED5Y2svscdWj0Sbd7LdBkr2zrq2KADjFY7p8J3t1c5SwsgE2GVyD8Hbs0iFRzaW5KbUZjgDhhpb/3DmY6nqa2GgSdJxd0h/ljfQno7UHdzp6PCenoq9QUu9ydLnI6vG8MUOImjQBk6jnNa20KZ3CEPGE714SCF8DcZE4GwZVzLn5saLwy82BOnzk2XJSyeF0xBkHqJDGL8vzL5/h0aYue5EVASciD1GfjiqY3msseN3BSivN0v2TMZmBtMwasLXd4umc7rF3CzAyycdnLDgQPPCRqfDQAWVfbr8OBciTGxmS6E3Ur+g56n0vPni7QOkJjgwyUsdSDnzTQzuB6yfii55UnkXHbo+1+oIkdM6BHojWIWcNJrGP82+xxiIrXc2CTojmNsme5DZf08JjXut8IYN29xhil8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d191582-4d03-4c54-c999-08d711a52476
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 08:42:07.1767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mkalderon@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2624
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-07-26_05:2019-07-26,2019-07-26 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> owner@vger.kernel.org> On Behalf Of Jason Gunthorpe
>=20
> On Thu, Jul 25, 2019 at 07:34:15PM +0000, Michal Kalderon wrote:
> > > > +	ibdev_dbg(ucontext->device,
> > > > +		  "mmap: obj[0x%p] key[%#llx] addr[%#llx] len[%#llx]
> > > removed\n",
> > > > +		  entry->obj, key, entry->address, entry->length);
> > > > +
> > > > +	return entry;
> > > > +}
> > > > +EXPORT_SYMBOL(rdma_user_mmap_entry_get);
> > >
> > > It is a mistake we keep making, and maybe the war is hopelessly lost
> > > now, but functions called from a driver should not be part of the
> > > ib_uverbs module
> > > - ideally uverbs is an optional module. They should be in ib_core.
> > >
> > > Maybe put this in ib_core_uverbs.c ?
>=20
> > But if there isn't ib_uverbs user apps can't be run right ? and then
> > these functions Won't get called anyway ?
>=20
> Right, but, we don't want loading the driver to force creating
> /dev/infiniband/uverbs - so the driver support component of uverbs should
> live in ib_core, and the /dev/ component should be in ib_uverbs
>=20
> > > > +	xa_lock(&ucontext->mmap_xa);
> > > > +	if (check_add_overflow(ucontext->mmap_xa_page,
> > > > +			       (u32)(length >> PAGE_SHIFT),
> > >
> > > Should this be divide round up ?
>=20
> > For cases that length is not rounded to PAGE_SHIFT?
>=20
> It should never happen, but yes
ok
>=20
> > >
> > > > +			       &next_mmap_page))
> > > > +		goto err_unlock;
> > >
> > > I still don't like that this algorithm latches into a permanent
> > > failure when the xa_page wraps.
> > >
> > > It seems worth spending a bit more time here to tidy this.. Keep
> > > using the mmap_xa_page scheme, but instead do something like
> > >
> > > alloc_cyclic_range():
> > >
> > > while () {
> > >    // Find first empty element in a cyclic way
> > >    xa_page_first =3D mmap_xa_page;
> > >    xa_find(xa, &xa_page_first, U32_MAX, XA_FREE_MARK)
> > >
> > >    // Is there a enough room to have the range?
> > >    if (check_add_overflow(xa_page_first, npages, &xa_page_end)) {
> > >       mmap_xa_page =3D 0;
> > >       continue;
> > >    }
> > >
> > >    // See if the element before intersects
> > >    elm =3D xa_find(xa, &zero, xa_page_end, 0);
> > >    if (elm && intersects(xa_page_first, xa_page_last, elm->first, elm=
-
> >last)) {
> > >       mmap_xa_page =3D elm->last + 1;
> > >       continue
> > >    }
> > >
> > >    // xa_page_first -> xa_page_end should now be free
> > >    xa_insert(xa, xa_page_start, entry);
> > >    mmap_xa_page =3D xa_page_end + 1;
> > >    return xa_page_start;
> > > }
> > >
> > > Approximately, please check it.
>=20
> > But we don't free entires from the xa_array ( only when ucontext is
> > destroyed) so how will There be an empty element after we wrap ?
>=20
> Oh!
>=20
> That should be fixed up too, in the general case if a user is
> creating/destroying driver objects in loop we don't want memory usage to
> be unbounded.
>=20
> The rdma_user_mmap stuff has VMA ops that can refcount the xa entry and
> now that this is core code it is easy enough to harmonize the two things =
and
> track the xa side from the struct rdma_umap_priv
>=20
> The question is, does EFA or qedr have a use model for this that allows a
> userspace verb to create/destroy in a loop? ie do we need to fix this rig=
ht
> now?
The mapping occurs for every qp and cq creation. So yes.=20
So do you mean add a ref-cnt to the xarray entry and from umap decrease the=
 refcnt and free?=20

>=20
> Jason
