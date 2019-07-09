Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 479BB63451
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 12:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfGIK3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 06:29:55 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:33580 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726018AbfGIK3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 06:29:54 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x69AP8N7007581;
        Tue, 9 Jul 2019 03:29:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=aD9fLTkcwkUN9Y75nDn29t0SMeomnSIT7Qz5+AtlZIs=;
 b=obHPimjg2KCLrqmtNse/wFhWWRbTPlNV5puEB+YDCtJm5VvTpGTXhs6YaTYxV2EnawJT
 VhGsitO2jL+biWqbq75UfIp4cH8Ih6SQlFD0Jjb3OsBpMDW4AxlIGtuy2W6sVX6Zxq9S
 O+ngXpdOYkyZhQvFyKV9MMMKNK/qrls7jVcZ6APLw5QZ+Bx3jpkqJv2UULPKSUoIqUuh
 LIQf8LVxFQETn1DktohFtSjjJgKnsJjBU9JP2VpA2RfAra/POLxmtXfHQUA8/vlXQE9H
 7WsZwNXKqFFwGC0wkkHVaZAo44OOiB5B9cX08yoyZ99MsHphnhbXwpEdDeBL0mIf26+x zQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2tmnmy8spm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 09 Jul 2019 03:29:42 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 9 Jul
 2019 03:29:41 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.56) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 9 Jul 2019 03:29:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aD9fLTkcwkUN9Y75nDn29t0SMeomnSIT7Qz5+AtlZIs=;
 b=tARidzVK6O/aGLDOdNjNstYKYgznPiptfIRZXKMu5szqjeSPE1w0a7c4SahdF0TpW7xympMt4Q67khSslbGcGU6L9NTJhokR2Ak146S36yOi8DLUKRXNa+KauSUNbq7H5OBqxRaRhQZMzKWPUq7ufVgDR8CyhzaP6k9sWzfsor8=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB2815.namprd18.prod.outlook.com (20.179.21.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Tue, 9 Jul 2019 10:29:36 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::8cb3:f7d7:8bb2:c36e]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::8cb3:f7d7:8bb2:c36e%6]) with mapi id 15.20.2052.020; Tue, 9 Jul 2019
 10:29:36 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Ariel Elior <aelior@marvell.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "galpress@amazon.com" <galpress@amazon.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v5 rdma-next 1/6] RDMA/core: Create mmap database and
 cookie helper functions
Thread-Topic: [PATCH v5 rdma-next 1/6] RDMA/core: Create mmap database and
 cookie helper functions
Thread-Index: AQHVNW3i/26cQYUn40uIF93L69NO9qbB3cEAgAA42pA=
Date:   Tue, 9 Jul 2019 10:29:36 +0000
Message-ID: <MN2PR18MB31825FB2CCC56C47763C9D0DA1F10@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20190708091503.14723-1-michal.kalderon@marvell.com>
 <20190708091503.14723-2-michal.kalderon@marvell.com>
 <20190709070244.GH7034@mtr-leonro.mtl.com>
In-Reply-To: <20190709070244.GH7034@mtr-leonro.mtl.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [212.199.69.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67216a3d-c986-410c-02b8-08d70458577a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2815;
x-ms-traffictypediagnostic: MN2PR18MB2815:
x-microsoft-antispam-prvs: <MN2PR18MB2815F44F830E9A09DA911765A1F10@MN2PR18MB2815.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(39860400002)(396003)(136003)(366004)(199004)(189003)(71190400001)(14444005)(446003)(71200400001)(11346002)(486006)(8676002)(81166006)(81156014)(52536014)(5660300002)(102836004)(6916009)(7696005)(476003)(316002)(26005)(186003)(6506007)(99286004)(76116006)(86362001)(305945005)(73956011)(14454004)(74316002)(8936002)(66556008)(256004)(76176011)(66476007)(7736002)(66446008)(64756008)(2906002)(229853002)(4326008)(33656002)(478600001)(6436002)(9686003)(55016002)(53936002)(6116002)(3846002)(6246003)(54906003)(66946007)(66066001)(68736007)(25786009)(130980200001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2815;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9iZEPodkYmy8M9i4v71vJJW4CwoSSa0za+QtLpATvcSRN1NY82iVtWPX/But0yYH54BbWPA/Ssr6a+PtqmdK6uw4hgm3RCmqnBf3v8756gTDkPizRsmD8guSievOmw3rvYN+b40WdF1XAKalO4t5SEAoUXIb+Z9ShIgzS3Sb59gKn5v8xd83N1zupVZO7vhe0Qlhs/OpmG8casrSeAYLsCYYP4MniW8v8Euqzic+vTxIaQBzMTEdx66dyLN66CQwr9GTTxsCOmu7Y7SesVlkYdwZEuiziEtOwiXINqqnfZSUJfgumAXdD7D7a/0zvm2z76Y4E870vqm+UBelSXGkxApW+jm3KCX7/kxU2I6Fwu5VvUK57T/2ms9YsKF2IH4TZmgPVbpnoB6HsEq/xn9fSbxEUYAhG+uqd43jLTPTTmM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 67216a3d-c986-410c-02b8-08d70458577a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 10:29:36.5672
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mkalderon@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2815
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-09_04:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> owner@vger.kernel.org> On Behalf Of Leon Romanovsky
>=20
> On Mon, Jul 08, 2019 at 12:14:58PM +0300, Michal Kalderon wrote:
> > Create some common API's for adding entries to a xa_mmap.
> > Searching for an entry and freeing one.
> >
> > The code was copied from the efa driver almost as is, just renamed
> > function to be generic and not efa specific.
> >
> > Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
> > ---
> >  drivers/infiniband/core/device.c      |   1 +
> >  drivers/infiniband/core/rdma_core.c   |   1 +
> >  drivers/infiniband/core/uverbs_cmd.c  |   1 +
> >  drivers/infiniband/core/uverbs_main.c | 105
> ++++++++++++++++++++++++++++++++++
> >  include/rdma/ib_verbs.h               |  32 +++++++++++
> >  5 files changed, 140 insertions(+)
> >
> > diff --git a/drivers/infiniband/core/device.c
> > b/drivers/infiniband/core/device.c
> > index 8a6ccb936dfe..a830c2c5d691 100644
> > --- a/drivers/infiniband/core/device.c
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
> > index ccf4d069c25c..7166741834c8 100644
> > --- a/drivers/infiniband/core/rdma_core.c
> > +++ b/drivers/infiniband/core/rdma_core.c
> > @@ -817,6 +817,7 @@ static void ufile_destroy_ucontext(struct
> ib_uverbs_file *ufile,
> >  	rdma_restrack_del(&ucontext->res);
> >
> >  	ib_dev->ops.dealloc_ucontext(ucontext);
> > +	rdma_user_mmap_entries_remove_free(ucontext);
> >  	kfree(ucontext);
> >
> >  	ufile->ucontext =3D NULL;
> > diff --git a/drivers/infiniband/core/uverbs_cmd.c
> > b/drivers/infiniband/core/uverbs_cmd.c
> > index 7ddd0e5bc6b3..44c0600245e4 100644
> > --- a/drivers/infiniband/core/uverbs_cmd.c
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
> > index 11c13c1381cf..37507cc27e8c 100644
> > --- a/drivers/infiniband/core/uverbs_main.c
> > +++ b/drivers/infiniband/core/uverbs_main.c
> > @@ -965,6 +965,111 @@ int rdma_user_mmap_io(struct ib_ucontext
> > *ucontext, struct vm_area_struct *vma,  }
> > EXPORT_SYMBOL(rdma_user_mmap_io);
> >
> > +static inline u64
> > +rdma_user_mmap_get_key(const struct rdma_user_mmap_entry
> *entry) {
> > +	return (u64)entry->mmap_page << PAGE_SHIFT; }
> > +
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
> > +	if (!entry || rdma_user_mmap_get_key(entry) !=3D key ||
> > +	    entry->length !=3D len)
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
> Please add function description in kernel doc format for all newly
> EXPORT_SYMBOL() functions you introduced in RDMA/core.
Ok. Could you give me a reference to an example? Where should the=20
Documentation be added to?=20


>=20
> > +
> > +/*
> > + * Note this locking scheme cannot support removal of entries, except
> > +during
> > + * ucontext destruction when the core code guarentees no concurrency.
> > + */
> > +u64 rdma_user_mmap_entry_insert(struct ib_ucontext *ucontext, void
> *obj,
> > +				u64 address, u64 length, u8 mmap_flag) {
> > +	struct rdma_user_mmap_entry *entry;
> > +	u32 next_mmap_page;
> > +	int err;
> > +
> > +	entry =3D kmalloc(sizeof(*entry), GFP_KERNEL);
>=20
> It is worth to use kzalloc and not kmalloc.
>=20
> Thanks
