Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9711660CA
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 16:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgBTPUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 10:20:04 -0500
Received: from mail-eopbgr70082.outbound.protection.outlook.com ([40.107.7.82]:36867
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728079AbgBTPUD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 10:20:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JPkYoPFKnXifOx/hPhJRDVleCyYiHWLcWimSMRBW7dcIVgpdZ+7yE2YzDW77o71GNVffZGspNI6W6yBg4UaY4K6WjHUuW7EMJf1Dx7OIbpFfijJiMmZInQbN+ZTy7GSQIhMbnQc8CFdQfjltmEvoCIyT4BhxukIgNzOncsoZnFG0amugYpo8Ie2OWLPmLKRpQn437lywuSr/cj0urRo0iiy22q0KokgFod3mFj6G3x+N3tFz53lCHdSgPKKN6/3q1IHsCfltkE4Ky7aCQLNhiiW/m0imSma7AS6W1mWglAgos0dIzOtiShUQMiiJLLLb7B+utm9SPiQQf5jTZeqWQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpgYwZTzNlUbboAFsXb/b/tpOxyoDQodk6oynpTqT2Q=;
 b=nKN5wpis7GXpgM9FKofSbljk9ArvOILXjt429x5KSl3boIWFO1y4DZ/JMVunkT1N/DOZEmoFYy+sONUvUqD+jgz7kafOgma+qi8VaNQiUc7qbJCk9nnWaD0SXg6vDq/b6PiS7AB9+JuyXOcqMPJKa5lRqFJYnVSpnRTi3OD+WDeqml1aNJRcSQOA15zd0VzQWsyKiSjoZPKQYnU3Xg7R1CanaWc8i6GAR5ypDHKKZ2kV6knsFMo+KP069lYB0plpIcCUySWLhdxDtlSfBrv6dZaP1d1iRmLL/jUb8Xh2wXrcCbBcIM+tHO6MS3zkrvp3cCrkpo3jEKfNreLb9KhbeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpgYwZTzNlUbboAFsXb/b/tpOxyoDQodk6oynpTqT2Q=;
 b=IjZN1+VfSez/FCpYBM/ahb+ZuhP34uMvsXNJ4gghCUSEkv52ba3dQvThtDx7tGMGeTdYfupuoPn0lw6wpGrmticmRW5r4nWIe4HXnbrODg+uh7yGSTyBVj5Cbztt23W4qgy09d+OPmgnD7ddMCl1G9davX5U3Jb0aRzkeZR993A=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB4736.eurprd05.prod.outlook.com (20.176.4.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Thu, 20 Feb 2020 15:19:19 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2729.033; Thu, 20 Feb 2020
 15:19:19 +0000
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR06CA0002.namprd06.prod.outlook.com (2603:10b6:208:23d::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.17 via Frontend Transport; Thu, 20 Feb 2020 15:19:18 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1j4nbe-00030u-7e; Thu, 20 Feb 2020 11:19:14 -0400
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     "mst@redhat.com" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tiwei.bie@intel.com" <tiwei.bie@intel.com>,
        "maxime.coquelin@redhat.com" <maxime.coquelin@redhat.com>,
        "cunming.liang@intel.com" <cunming.liang@intel.com>,
        "zhihong.wang@intel.com" <zhihong.wang@intel.com>,
        "rob.miller@broadcom.com" <rob.miller@broadcom.com>,
        "xiao.w.wang@intel.com" <xiao.w.wang@intel.com>,
        "haotian.wang@sifive.com" <haotian.wang@sifive.com>,
        "lingshan.zhu@intel.com" <lingshan.zhu@intel.com>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Parav Pandit <parav@mellanox.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "aadam@redhat.com" <aadam@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
Subject: Re: [PATCH V4 4/5] virtio: introduce a vDPA based transport
Thread-Topic: [PATCH V4 4/5] virtio: introduce a vDPA based transport
Thread-Index: AQHV57TY4pPnijWOKk2zaNVux8dIL6gkMs4A
Date:   Thu, 20 Feb 2020 15:19:18 +0000
Message-ID: <20200220151914.GW23930@mellanox.com>
References: <20200220061141.29390-1-jasowang@redhat.com>
 <20200220061141.29390-5-jasowang@redhat.com>
In-Reply-To: <20200220061141.29390-5-jasowang@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR06CA0002.namprd06.prod.outlook.com
 (2603:10b6:208:23d::7) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [142.68.57.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4b2282ec-6a5c-4833-c0d3-08d7b61840fe
x-ms-traffictypediagnostic: VI1PR05MB4736:|VI1PR05MB4736:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4736A964FD422C29FE7DF6A8CF130@VI1PR05MB4736.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 031996B7EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(39850400004)(136003)(376002)(199004)(189003)(54906003)(8936002)(316002)(9746002)(81166006)(66446008)(9786002)(7416002)(8676002)(4326008)(33656002)(71200400001)(5660300002)(1076003)(81156014)(52116002)(186003)(66946007)(478600001)(86362001)(36756003)(64756008)(6916009)(2906002)(66476007)(2616005)(26005)(66556008)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4736;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oiTL7fs5IJIIpdnibn3q4mNdYGkH+ZAVkDVwJNq5LEKmeehX4XWWBSxP04xNxI2fNJJizRBtzH1WtNPNwT7pI95lWX+bOl1PdU3JrDApbvgXLygiTTulqLc0mjm88ROJ1d6fcJJEQCCRbUmUvtcjRHTiybdWK7mMn0HnXrI0PxCEjGiGN51trfY+7WJVe/FPu3SN7YMJct3o+LskQqNJdJnGy9f7AjeGtWD5cfFrl0Cl9G0md2qza3R5clJnQWsG4/yRITvFQubSe8VcO6h4spv9tHX1BlWlZ1eQQ6kNTjv/gqpcsGjQUejtn43XWZuavpPHSEj6AIduPZr5LfsP2WceyPv/UpiYokwGZrx6sQ/Jh2j8iKYoCJTBHLtEnQkDkX72/fXctRCfHYchSoTTU/uvpunM9HzGZa+2vPd9CuuTu7I/roFt/G0g+W3vuxZ4O2zDmsFKx6zOaBNQX/Fdi/IbTGmn0Bcyn+OJTovBnkCdwOFTWEWr9d1oAiSKiuJQ
x-ms-exchange-antispam-messagedata: zW65RzzzcRJ+oQeSGRnwWIU8eBXfNN2UPh39835UWTVZJ+GCSfGThD8a3z2qypcKGlnJEpuuC6z4EszkPNSlFLKhjckr1h52M7jL1fqVgbdmG5o0IZf5/7JKRDZvZNVVOr4AZqIN5Xq+IhdAnWaURA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <580C49A7720E4D419B954616884CC2C0@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b2282ec-6a5c-4833-c0d3-08d7b61840fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2020 15:19:18.8478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Weq96eaWi7b22KBmOzOVtxoJbb+4aCPFy0kNbFOThkhE+au1Gjtj4/dTDSI3zYbblxmbwI2CNBzHJg4xoNq+hA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4736
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 02:11:40PM +0800, Jason Wang wrote:
> +static int virtio_vdpa_probe(struct vdpa_device *vdpa)
> +{
> +	const struct vdpa_config_ops *ops =3D vdpa->config;
> +	struct virtio_vdpa_device *vd_dev;
> +	int ret =3D -EINVAL;
> +
> +	vd_dev =3D kzalloc(sizeof(*vd_dev), GFP_KERNEL);
> +	if (!vd_dev)
> +		return -ENOMEM;
> +
> +	vd_dev->vdev.dev.parent =3D vdpa_get_dma_dev(vdpa);
> +	vd_dev->vdev.dev.release =3D virtio_vdpa_release_dev;
> +	vd_dev->vdev.config =3D &virtio_vdpa_config_ops;
> +	vd_dev->vdpa =3D vdpa;
> +	INIT_LIST_HEAD(&vd_dev->virtqueues);
> +	spin_lock_init(&vd_dev->lock);
> +
> +	vd_dev->vdev.id.device =3D ops->get_device_id(vdpa);
> +	if (vd_dev->vdev.id.device =3D=3D 0)
> +		goto err;
> +
> +	vd_dev->vdev.id.vendor =3D ops->get_vendor_id(vdpa);
> +	ret =3D register_virtio_device(&vd_dev->vdev);
> +	if (ret)
> +		goto err;

This error unwind is wrong. register_virtio_device() does
device_initialize() as it's first action. After that point error
unwind must be done with put_device() - particularly calling
kfree(vd_dev) after doing dev_set_name() leaks memory.

Looks like about half of the register_virtio_device() users did this
right, the others not. Perhaps you should fix them too...

Jason
