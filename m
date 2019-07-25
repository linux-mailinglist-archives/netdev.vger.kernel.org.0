Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEEEF757F5
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 21:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbfGYTeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 15:34:25 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:51732 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726126AbfGYTeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 15:34:24 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x6PJUhrr016187;
        Thu, 25 Jul 2019 12:34:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=Jl7Vw+c6OBzSaMyh9DPEycByMUoYZccx0vChLLZ76bY=;
 b=i8NLhbGKt/NvsbCtq0KkjkZbOlG4MJelenGFYQWP/HtsHZiuZqTKTeT8JLe0cTxGu118
 0xARzqNdtsxx4g9ue+HYfIJvNK2og8wUFZuw8mZD75CRy9NwCpRC88y6Uw4ATbjp/pnN
 1vRPzqRvK1ygMRWqXnO3VzPVh4IwXFz8Eu1rN8tficDoxpORYhv0wlrYYpfQDEb9nPX2
 3x3RIa6KlsfRKbgjSRmet0w5Lj6v3P0wpcEXyPL/auNrWNKcJQBieevxHy6IRytwIzpy
 gggr0HuMDTw3z7sc+b7XhK7YNJ1v7SCu5TxS1RJuoHySMDaBH67eqew6EjfWMKGMW/7s Ug== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2tx61rk86x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 25 Jul 2019 12:34:19 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 25 Jul
 2019 12:34:18 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (104.47.42.54) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 25 Jul 2019 12:34:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mD/qMyVEnt6n4kuUAmxtJg1u0VTHC1910YENmzbujw50pB/NPHLnf4tMwhzmtT/lPli0YMoBNhSgVhVYLxCyc9UOOyEBLG/S2oxtluCerCd39SWfJbC4CCTTkpVxGri4yeo6xETFed0trwu+RGgWXQhiBymrC8DBrTBtDVcKtlQ2PPkDCpF8Az+7TW+HH4SWfehMiMOLcSaDeQVxf1Xp6g0POIXsctPQ3j1jDWpP9ZpLe5tBDfQWMEdbtejWtVbMyOD4lvwqOLDMWVT8/6Z9lled72+LEVZxx+QeSuwCjnQKSIr8zj4evu+BX8LKr9gGHS8u8CE0O2yFfr2gAVVc5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jl7Vw+c6OBzSaMyh9DPEycByMUoYZccx0vChLLZ76bY=;
 b=MxORIwV36mAoBu12Fk1XFi6Wi84z70MYqRdeco3GYSikeHnNI4oOBnCApHdrdT+5Z4oR4XOgtJY+sp1EJElv/66dJX0Ed/t4FS9JQ6UdFQDHC9J6t0oBKhNiqj2gJbAxUVf6QEQK/LGbeO3Ib34G5hpnyKRBlEtPI3v/whFr1Uz5XA4TSzMoADo9LDyQAPvD1sUD2WZ1JaJdP+hAEAOX24SCbDGlFRzp0x+iiQkcL7JguWV99uvPlNezjUwOLl6f/k08joyaKTnVyni9t3WQUGOzgBqNCImmM3zZsyRWAPA3MV/melQyXlyJl/Gi9Ilgu385VSC7YEIBVDsAkJHx2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=marvell.com;dmarc=pass action=none
 header.from=marvell.com;dkim=pass header.d=marvell.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jl7Vw+c6OBzSaMyh9DPEycByMUoYZccx0vChLLZ76bY=;
 b=ZAxCKJbzDcouuYSx3dfjtkXtn0n4YSE6JDmnVni2I2E/dRm7fYq4SOeFBQ4eR99fkE7Yl7aPacRBnng8pJl9Hc7TE1Lg2FD/IVhkX8Pqsc7XCY0s/c2fP5jtUJKCSGu01PdnvtSlNGnRCerPuy1eEUVFrdRqh1wQk4pC84dXIsw=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB3344.namprd18.prod.outlook.com (10.255.238.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Thu, 25 Jul 2019 19:34:15 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::8cb3:f7d7:8bb2:c36e]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::8cb3:f7d7:8bb2:c36e%6]) with mapi id 15.20.2115.005; Thu, 25 Jul 2019
 19:34:15 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Kamal Heib <kamalheib1@gmail.com>
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
Thread-Index: AQHVNmFHCA5NoSkqKU2zcNxJe13QUKbbt5QAgAAZ4wA=
Date:   Thu, 25 Jul 2019 19:34:15 +0000
Message-ID: <MN2PR18MB3182469DB08CD20B56C9697FA1C10@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20190709141735.19193-1-michal.kalderon@marvell.com>
 <20190709141735.19193-2-michal.kalderon@marvell.com>
 <20190725175540.GA18757@ziepe.ca>
In-Reply-To: <20190725175540.GA18757@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [79.183.34.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 29b27f78-0244-419e-6f93-08d711371452
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB3344;
x-ms-traffictypediagnostic: MN2PR18MB3344:
x-microsoft-antispam-prvs: <MN2PR18MB334497F27EFD44D6A543A657A1C10@MN2PR18MB3344.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(199004)(189003)(478600001)(6116002)(76176011)(54906003)(8676002)(110136005)(486006)(99286004)(3846002)(6436002)(86362001)(7696005)(2906002)(33656002)(25786009)(9686003)(74316002)(4326008)(316002)(14454004)(68736007)(66066001)(5660300002)(55016002)(229853002)(102836004)(52536014)(26005)(53936002)(64756008)(14444005)(256004)(305945005)(476003)(66476007)(66446008)(76116006)(446003)(6506007)(81156014)(6246003)(11346002)(8936002)(66946007)(7736002)(71190400001)(81166006)(71200400001)(186003)(66556008)(130980200001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3344;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zclUIyhONuwN8TvKex6gtHa2uT1Iwp3eMrCzxNRgxafgXTIZpPnmyPNr3r6I4078YiRrMpsZz2DKDAAGS8N2USCDHGzvsBTxXCGj2xedp+DLUlEQaOLZN7F1Q2HeVWzAt5IORHs+UXQlnp3MvBPFJi/BDZPjrnARVrkiRd7FPHZdtBQm//T5tV0nML2m8dDbwbskWjcDfV9lGmvEHmWtfhw+ady4E+zBGfjqoU4XOfIESyjI9uf+2SgOeQQ4dCKDUPw/08MA7dwo12tEcIMzLAEeDVy/RNVvh43CSJxqWFfVwQPOf1HVFyRORERkFoTSsiOh2FSO5NPc3P/ToGIvLHtFmycwrH59+RjVhNvPZNArZGEQChDhMmuZDIqi3OcqSfFucA53O0sC7a/gvlIrZlrbtV6yeJx9e7nPHPBnLrQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 29b27f78-0244-419e-6f93-08d711371452
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 19:34:15.6095
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mkalderon@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3344
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-07-25_07:2019-07-25,2019-07-25 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> owner@vger.kernel.org> On Behalf Of Jason Gunthorpe
>=20
> On Tue, Jul 09, 2019 at 05:17:30PM +0300, Michal Kalderon wrote:
> > Create some common API's for adding entries to a xa_mmap.
> > Searching for an entry and freeing one.
> >
> > The code was copied from the efa driver almost as is, just renamed
> > function to be generic and not efa specific.
> >
> > Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
> > Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
> >  drivers/infiniband/core/device.c      |   1 +
> >  drivers/infiniband/core/rdma_core.c   |   1 +
> >  drivers/infiniband/core/uverbs_cmd.c  |   1 +
> >  drivers/infiniband/core/uverbs_main.c | 135
> ++++++++++++++++++++++++++++++++++
> >  include/rdma/ib_verbs.h               |  46 ++++++++++++
> >  5 files changed, 184 insertions(+)
> >
> > diff --git a/drivers/infiniband/core/device.c
> > b/drivers/infiniband/core/device.c
> > index 8a6ccb936dfe..a830c2c5d691 100644
> > +++ b/drivers/infiniband/core/device.c
> > @@ -2521,6 +2521,7 @@ void ib_set_device_ops(struct ib_device *dev,
> const struct ib_device_ops *ops)
> >  	SET_DEVICE_OP(dev_ops, map_mr_sg_pi);
> >  	SET_DEVICE_OP(dev_ops, map_phys_fmr);
> >  	SET_DEVICE_OP(dev_ops, mmap);
> > +	SET_DEVICE_OP(dev_ops, mmap_free);
> >  	SET_DEVICE_OP(dev_ops, modify_ah);
> >  	SET_DEVICE_OP(dev_ops, modify_cq);
> >  	SET_DEVICE_OP(dev_ops, modify_device); diff --git
> > a/drivers/infiniband/core/rdma_core.c
> > b/drivers/infiniband/core/rdma_core.c
> > index ccf4d069c25c..1ed01b02401f 100644
> > +++ b/drivers/infiniband/core/rdma_core.c
> > @@ -816,6 +816,7 @@ static void ufile_destroy_ucontext(struct
> > ib_uverbs_file *ufile,
> >
> >  	rdma_restrack_del(&ucontext->res);
> >
> > +	rdma_user_mmap_entries_remove_free(ucontext);
> >  	ib_dev->ops.dealloc_ucontext(ucontext);
> >  	kfree(ucontext);
> >
> > diff --git a/drivers/infiniband/core/uverbs_cmd.c
> > b/drivers/infiniband/core/uverbs_cmd.c
> > index 7ddd0e5bc6b3..44c0600245e4 100644
> > +++ b/drivers/infiniband/core/uverbs_cmd.c
> > @@ -254,6 +254,7 @@ static int ib_uverbs_get_context(struct
> > uverbs_attr_bundle *attrs)
> >
> >  	mutex_init(&ucontext->per_mm_list_lock);
> >  	INIT_LIST_HEAD(&ucontext->per_mm_list);
> > +	xa_init(&ucontext->mmap_xa);
> >
> >  	ret =3D get_unused_fd_flags(O_CLOEXEC);
> >  	if (ret < 0)
> > diff --git a/drivers/infiniband/core/uverbs_main.c
> > b/drivers/infiniband/core/uverbs_main.c
> > index 11c13c1381cf..4b909d7b97de 100644
> > +++ b/drivers/infiniband/core/uverbs_main.c
> > @@ -965,6 +965,141 @@ int rdma_user_mmap_io(struct ib_ucontext
> > *ucontext, struct vm_area_struct *vma,  }
> > EXPORT_SYMBOL(rdma_user_mmap_io);
> >
> > +static inline u64
> > +rdma_user_mmap_get_key(const struct rdma_user_mmap_entry
> *entry) {
> > +	return (u64)entry->mmap_page << PAGE_SHIFT; }
> > +
> > +/**
> > + * rdma_user_mmap_entry_get() - Get an entry from the mmap_xa.
> > + *
> > + * @ucontext: associated user context.
> > + * @key: The key received from rdma_user_mmap_entry_insert which
> > + *     is provided by user as the address to map.
> > + * @len: The length the user wants to map
> > + *
> > + * This function is called when a user tries to mmap a key it
> > + * initially received from the driver. They key was created by
> > + * the function rdma_user_mmap_entry_insert.
> > + *
> > + * Return an entry if exists or NULL if there is no match.
> > + */
> > +struct rdma_user_mmap_entry *
> > +rdma_user_mmap_entry_get(struct ib_ucontext *ucontext, u64 key, u64
> > +len) {
> > +	struct rdma_user_mmap_entry *entry;
> > +	u64 mmap_page;
> > +
> > +	mmap_page =3D key >> PAGE_SHIFT;
> > +	if (mmap_page > U32_MAX)
> > +		return NULL;
> > +
> > +	entry =3D xa_load(&ucontext->mmap_xa, mmap_page);
> > +	if (!entry || entry->length !=3D len)
> > +		return NULL;
> > +
> > +	ibdev_dbg(ucontext->device,
> > +		  "mmap: obj[0x%p] key[%#llx] addr[%#llx] len[%#llx]
> removed\n",
> > +		  entry->obj, key, entry->address, entry->length);
> > +
> > +	return entry;
> > +}
> > +EXPORT_SYMBOL(rdma_user_mmap_entry_get);
>=20
> It is a mistake we keep making, and maybe the war is hopelessly lost now,
> but functions called from a driver should not be part of the ib_uverbs mo=
dule
> - ideally uverbs is an optional module. They should be in ib_core.
>=20
> Maybe put this in ib_core_uverbs.c ?
But if there isn't ib_uverbs user apps can't be run right ? and then these =
functions
Won't get called anyway ?=20


>=20
> Kamal, you've been tackling various cleanups, maybe making ib_uverbs
> unloadable again is something you'd be keen on?
>=20
> > +/**
> > + * rdma_user_mmap_entry_insert() - Allocate and insert an entry to the
> mmap_xa.
> > + *
> > + * @ucontext: associated user context.
> > + * @obj: opaque driver object that will be stored in the entry.
> > + * @address: The address that will be mmapped to the user
> > + * @length: Length of the address that will be mmapped
> > + * @mmap_flag: opaque driver flags related to the address (For
> > + *           example could be used for cachability)
> > + *
> > + * This function should be called by drivers that use the
> > +rdma_user_mmap
> > + * interface for handling user mmapped addresses. The database is
> > +handled in
> > + * the core and helper functions are provided to insert entries into
> > +the
> > + * database and extract entries when the user call mmap with the given
> key.
> > + * The function returns a unique key that should be provided to user,
> > +the user
> > + * will use the key to map the given address.
> > + *
> > + * Note this locking scheme cannot support removal of entries,
> > + * except during ucontext destruction when the core code
> > + * guarentees no concurrency.
> > + *
> > + * Return: unique key or RDMA_USER_MMAP_INVALID if entry was not
> added.
> > + */
> > +u64 rdma_user_mmap_entry_insert(struct ib_ucontext *ucontext, void
> *obj,
> > +				u64 address, u64 length, u8 mmap_flag) {
> > +	struct rdma_user_mmap_entry *entry;
> > +	u32 next_mmap_page;
> > +	int err;
> > +
> > +	entry =3D kzalloc(sizeof(*entry), GFP_KERNEL);
> > +	if (!entry)
> > +		return RDMA_USER_MMAP_INVALID;
> > +
> > +	entry->obj =3D obj;
> > +	entry->address =3D address;
> > +	entry->length =3D length;
> > +	entry->mmap_flag =3D mmap_flag;
> > +
> > +	xa_lock(&ucontext->mmap_xa);
> > +	if (check_add_overflow(ucontext->mmap_xa_page,
> > +			       (u32)(length >> PAGE_SHIFT),
>=20
> Should this be divide round up ?
For cases that length is not rounded to PAGE_SHIFT?=20

>=20
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
But we don't free entires from the xa_array ( only when ucontext is destroy=
ed) so how will=20
There be an empty element after we wrap ? =20

>=20
> > @@ -2199,6 +2201,17 @@ struct iw_cm_conn_param;
> >
> >  #define DECLARE_RDMA_OBJ_SIZE(ib_struct) size_t size_##ib_struct
> >
> > +#define RDMA_USER_MMAP_FLAG_SHIFT 56
> > +#define RDMA_USER_MMAP_PAGE_MASK
> GENMASK(EFA_MMAP_FLAG_SHIFT - 1, 0)
> > +#define RDMA_USER_MMAP_INVALID U64_MAX struct
> rdma_user_mmap_entry {
> > +	void *obj;
> > +	u64 address;
> > +	u64 length;
> > +	u32 mmap_page;
> > +	u8 mmap_flag;
> > +};
> > +
> >  /**
> >   * struct ib_device_ops - InfiniBand device operations
> >   * This structure defines all the InfiniBand device operations,
> > providers will @@ -2311,6 +2324,19 @@ struct ib_device_ops {
> >  			      struct ib_udata *udata);
> >  	void (*dealloc_ucontext)(struct ib_ucontext *context);
> >  	int (*mmap)(struct ib_ucontext *context, struct vm_area_struct
> > *vma);
> > +	/**
> > +	 * Memory that is mapped to the user can only be freed once the
> > +	 * ucontext of the application is destroyed. This is for
> > +	 * security reasons where we don't want an application to have a
> > +	 * mapping to phyiscal memory that is freed and allocated to
> > +	 * another application. For this reason, all the entries are
> > +	 * stored in ucontext and once ucontext is freed mmap_free is
> > +	 * called on each of the entries. They type of the memory that
>=20
> They -> the
ok
>=20
> > +	 * was mapped may differ between entries and is opaque to the
> > +	 * rdma_user_mmap interface. Therefore needs to be implemented
> > +	 * by the driver in mmap_free.
> > +	 */
> > +	void (*mmap_free)(struct rdma_user_mmap_entry *entry);
> >  	void (*disassociate_ucontext)(struct ib_ucontext *ibcontext);
> >  	int (*alloc_pd)(struct ib_pd *pd, struct ib_udata *udata);
> >  	void (*dealloc_pd)(struct ib_pd *pd, struct ib_udata *udata); @@
> > -2709,6 +2735,11 @@ void ib_set_device_ops(struct ib_device *device,
> > #if IS_ENABLED(CONFIG_INFINIBAND_USER_ACCESS)
> >  int rdma_user_mmap_io(struct ib_ucontext *ucontext, struct
> vm_area_struct *vma,
> >  		      unsigned long pfn, unsigned long size, pgprot_t prot);
> > +u64 rdma_user_mmap_entry_insert(struct ib_ucontext *ucontext, void
> *obj,
> > +				u64 address, u64 length, u8 mmap_flag);
> struct
> > +rdma_user_mmap_entry * rdma_user_mmap_entry_get(struct
> ib_ucontext
> > +*ucontext, u64 key, u64 len); void
> > +rdma_user_mmap_entries_remove_free(struct ib_ucontext
> > *ucontext);
>=20
> Should remove_free should be in the core-priv header?
Yes, thanks.
>=20
> Jason
