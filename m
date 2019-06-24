Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46B3C51A1D
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbfFXR4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 13:56:19 -0400
Received: from mail-eopbgr30066.outbound.protection.outlook.com ([40.107.3.66]:25986
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726331AbfFXR4S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 13:56:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hiiXtwPb9TzdZO/mN0/vb4KRVnQN8DlbF+pxnPlM2QE=;
 b=d6qbxdQzFVmLIeMGSgyzeiR/ciKET0UgLO8CGhU1NyMAqJIrrtUXQhhuG4oKRZjmj0XtgZwGXR/0Xs0XTEqjOxoSuxrCFGrbLZk8i41UHwNu63sfuGrCEGAA71thhwvDtsX62EanxNtFpp9T5vDlx5j/S+P8rmMY3eVOJC9YLwQ=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB6656.eurprd05.prod.outlook.com (10.141.128.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 17:56:12 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 17:56:12 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Yishai Hadas <yishaih@dev.mellanox.co.il>
CC:     Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v1 10/12] IB/mlx5: Enable subscription for
 device events over DEVX
Thread-Topic: [PATCH rdma-next v1 10/12] IB/mlx5: Enable subscription for
 device events over DEVX
Thread-Index: AQHVJfmLnHTD8lu5y0Ka9qPSVWhC9qaqvAcAgABHeQCAABzBgA==
Date:   Mon, 24 Jun 2019 17:56:12 +0000
Message-ID: <20190624175609.GK7418@mellanox.com>
References: <20190618171540.11729-1-leon@kernel.org>
 <20190618171540.11729-11-leon@kernel.org>
 <20190624115726.GC5479@mellanox.com>
 <33f9402b-ccae-b874-cc72-b6afb1fb8655@dev.mellanox.co.il>
In-Reply-To: <33f9402b-ccae-b874-cc72-b6afb1fb8655@dev.mellanox.co.il>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0029.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::17) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [66.187.232.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5400221c-6202-49f0-b512-08d6f8cd3eba
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB6656;
x-ms-traffictypediagnostic: VI1PR05MB6656:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR05MB6656528F634D87A5BE150382CFE00@VI1PR05MB6656.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(346002)(136003)(376002)(396003)(199004)(189003)(86362001)(52116002)(386003)(76176011)(102836004)(7736002)(6506007)(305945005)(6436002)(2906002)(4326008)(26005)(6486002)(186003)(68736007)(6512007)(8936002)(6246003)(6306002)(6862004)(229853002)(478600001)(966005)(53936002)(14454004)(3846002)(6116002)(81156014)(99286004)(8676002)(81166006)(73956011)(66476007)(71190400001)(5660300002)(71200400001)(25786009)(66066001)(486006)(476003)(446003)(2616005)(54906003)(33656002)(1076003)(66946007)(14444005)(36756003)(316002)(256004)(66556008)(64756008)(66446008)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6656;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: T3JOQWcEHA1jkzoSVRXOHfLajCYeb39mdEnYP/WaDJLB+Ct1XGrl8AV7mB6khIBihuejzKel9tUCu61G+gd7CQJp4ba/UddAZ24h1iP6HtKpdFczyfdbxBjnkTS0htJyK787V9eFeB9OAcQLT1jhblPgJ+D50jmdAIL5t5ubQqYtnBGxLf/BnVsLnpKIy6prXTTGx5go2yS+wrLzmhc6ajkt6XQN++KxD86FiyX6zVnaS6TiUtbUmeQBpEfFwzH9J2OE6uRflKcPSsMYAJlsyHFvrgKAxywSIT5LPa63KDHkYU5MgL7AY2DcBh8lPyZx1BCqO6hJVP8aXpiCHapD98jFgd9HeDBtgnxqOYgSYchZM7Ms8scakH5/QCSoKmEv/evbnKA0WbQAquyccQw0ltCmikhOBc3vXUizVzD8J1o=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E27C16DE2FED5648B7E727DBD1377AB0@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5400221c-6202-49f0-b512-08d6f8cd3eba
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 17:56:12.7449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6656
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 07:13:14PM +0300, Yishai Hadas wrote:
> > > +	u32 xa_key_level1;
> > > +	u32 xa_key_level2;
> > > +	struct rcu_head	rcu;
> > > +	u64 cookie;
> > > +	bool is_obj_related;
> > > +	struct ib_uobject *fd_uobj;
> > > +	void *object;	/* May need direct access upon hot unplug */
> >=20
> > This should be a 'struct file *' and have a better name.
> >=20
>=20
> OK, will change.
>=20
> > And I'm unclear why we need to store both the ib_uobject and the
> > struct file for the same thing?
>=20
> Post hot unplug/unbind the uobj can't be accessed any more to reach the
> object as it will be set to NULL by ib_core layer [1].

struct file users need to get the uobject from the file->private_data
under a fget.

There is only place place that needed fd_uobj, and it was under the
fget section, so it should simply use private_data.

This is why you should only store the struct file and not the uobject.

> This was the comment that I have just put above in the code, I may improv=
e
> it with more details as pointed here.
>=20
> [1]
> https://elixir.bootlin.com/linux/latest/source/drivers/infiniband/core/rd=
ma_core.c#L149

I'm wondering if this is a bug to do this for fds?

> > Since uobj->object =3D=3D flip && filp->private_data =3D=3D uobj, I hav=
e a
> > hard time to understand why we need both things, it seems to me that
> > if we get the fget on the filp then we can rely on the
> > filp->private_data to get back to the devx_async_event_file.
> >=20
>=20
> The idea was to not take an extra ref count on the file (i.e. fget) per
> subscription, this will let the release option to be called once the file
> will be closed by the application.

No extra ref is needed, the fget is already obtained in the only place
that needs fd_uobj.

> > > +	obj_event =3D xa_load(&event->object_ids, key_level2);
> > > +	if (!obj_event) {
> > > +		err =3D xa_reserve(&event->object_ids, key_level2, GFP_KERNEL);
> > > +		if (err)
> > > +			goto err_level1;
> > > +
> > > +		obj_event =3D kzalloc(sizeof(*obj_event), GFP_KERNEL);
> > > +		if (!obj_event) {
> > > +			err =3D -ENOMEM;
> > > +			goto err_level2;
> > > +		}
> > > +
> > > +		INIT_LIST_HEAD(&obj_event->obj_sub_list);
> > > +		*alloc_obj_event =3D obj_event;
> >=20
> > This is goofy, just store the empty obj_event in the xa instead of
> > using xa_reserve, and when you go to do the error unwind just delete
> > any level2' devx_obj_event' that has a list_empty(obj_sub_list), get
> > rid of the wonky alloc_obj_event stuff.
> >=20
>=20
> Please see my answer above about how level2 is managed by this
> alloc_obj_event, is that really worth a change ? I found current logic to=
 be
> clear. I may put some note here if we can stay with that.

I think it is alot cleaner/simpler than using this extra memory

> > The best configuration would be to use devx_cleanup_subscription to
> > undo the partially ready subscription.
>=20
> This partially ready subscription might not match the
> devx_cleanup_subscription(), e.g. it wasn't added to xa_list and can't be
> deleted without any specific flag to ignore ..

Maybe, but I suspect it can work out

> > > +	event_sub_arr =3D uverbs_zalloc(attrs,
> > > +		MAX_NUM_EVENTS * sizeof(struct devx_event_subscription *));
> > > +	event_obj_array_alloc =3D uverbs_zalloc(attrs,
> > > +		MAX_NUM_EVENTS * sizeof(struct devx_obj_event *));
> >=20
> > There are so many list_heads in the devx_event_subscription, why not
> > use just one of them to store the allocated events instead of this
> > temp array? ie event_list looks good for this purpose.
> >=20
>=20
> I'm using the array later on with direct access to the index that should =
be
> de-allocated. I would prefer staying with this array rather than using th=
e
> 'event_list' which has other purpose down the road, it's used per
> subscription and doesn't look match to hold the devx_obj_event which has =
no
> list entry for this purpose..

Replace the event_obj_array_alloc by storing that data directly in
the xarray

Replace the event_sub_arr by building them into a linked list - it
always need to iterate over the whole list anyhow.

> > > +
> > > +	if (!event_sub_arr || !event_obj_array_alloc)
> > > +		return -ENOMEM;
> > > +
> > > +	/* Protect from concurrent subscriptions to same XA entries to allo=
w
> > > +	 * both to succeed
> > > +	 */
> > > +	mutex_lock(&devx_event_table->event_xa_lock);
> > > +	for (i =3D 0; i < num_events; i++) {
> > > +		u32 key_level1;
> > > +
> > > +		if (obj)
> > > +			obj_type =3D get_dec_obj_type(obj,
> > > +						    event_type_num_list[i]);
> > > +		key_level1 =3D event_type_num_list[i] | obj_type << 16;
> > > +
> > > +		err =3D subscribe_event_xa_alloc(devx_event_table,
> > > +					       key_level1,
> > > +					       obj ? true : false,
> > > +					       obj_id,
> > > +					       &event_obj_array_alloc[i]);
> >=20
> > Usless ?:
>=20
> What do you suggest instead ?

Nothing is needed, cast to implicit bool is always forced to
true/false

Jason
