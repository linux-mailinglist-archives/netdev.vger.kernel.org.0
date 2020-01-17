Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88E5E140BE2
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 15:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbgAQOAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 09:00:23 -0500
Received: from mail-eopbgr80043.outbound.protection.outlook.com ([40.107.8.43]:14329
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726587AbgAQOAW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jan 2020 09:00:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cCV49vZIQeUzvkw01KuQveV5Ro3hg2d7aEtsq2SSVSxoD2rnlRs2wbBnzDB+YA3BynKFa5TpglkQo4WcOug7XucrSxer7g+qA61SKDya3eLxF9Ycu3JeK9NiU03COYh1M+7BytSzEgyqPwTh1qPDnnQGHiZ4NcZDQ0nsV5a0ucT/qIzBAEtjIdUhzTVmG7NUML4kPie3GaVfDc6kGhmvsTLEAHEmBNHkqRU+g1QW1TBLerLK2H++XciwkOMYhei2Qm/0jg88rpJETyRdpN2rURlly3ntFQoanY+pxHxGE8FAgLPdchzS1S0SY+HC1OC49jRM8QKF5ezXnlY1Hl2+Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZSilPPlz4u0vifgt+gZ6QV7wBo+QnCeGfn5/tlwvNA=;
 b=AkY9Kj9ty7lojT/pILIEGlbmrPqvJ6+bocr0EiV04DhizeN/alLdDpKomcXUURkMG9LBkMabq1Lm7ByWsbpB8THBxJiUEb0q97MptNox/L/clNlNeb4gCDttRGikvNPPcxCBnzCvo4iuiP8E3FE+oXaGUYaruTABolJsHz5eL93jqsOoP0mgv1ocBRXIlsy+3UO3Q29q8Gp/yHlPCL/KHE4Q2cMTBZZzfVbjtVcG2VRLoLmKcFXK4L69n+b+HP70VwTrkYjKnLtgfEBux3KSx03ciN2I9DE65sKiYFLHLjHDMqEKKd3Mwq+Pir+FF168EUgGDAorlXLPVEwhDQiPWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZSilPPlz4u0vifgt+gZ6QV7wBo+QnCeGfn5/tlwvNA=;
 b=dwuWIHaBCmGxSegjy3j01z7k+r1E7fVtzR/bXbMKWez87jS3vF5zaWOBMUHshy1ORwGXVUMACk1XA7y+yDwbLIKnvXHvujbD1iWGM/PaT2ZktSpv81eThS5X32qxVLvBx7LYVrE2qkTYNRtm/OLR3gCtDas4lDxQzYMot1g/Gnc=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (52.133.14.15) by
 VI1PR05MB4880.eurprd05.prod.outlook.com (20.177.52.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Fri, 17 Jan 2020 14:00:18 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::1c00:7925:d5c6:d60d%7]) with mapi id 15.20.2644.015; Fri, 17 Jan 2020
 14:00:18 +0000
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR15CA0004.namprd15.prod.outlook.com (2603:10b6:208:1b4::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Fri, 17 Jan 2020 14:00:17 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1isSAX-00087e-PC; Fri, 17 Jan 2020 10:00:13 -0400
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
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>
Subject: Re: [PATCH 4/5] virtio: introduce a vDPA based transport
Thread-Topic: [PATCH 4/5] virtio: introduce a vDPA based transport
Thread-Index: AQHVzGqemfN6NNb0GkCQ+wp4u+LCL6ftbRCAgAEsNICAAErHgA==
Date:   Fri, 17 Jan 2020 14:00:18 +0000
Message-ID: <20200117140013.GV20978@mellanox.com>
References: <20200116124231.20253-1-jasowang@redhat.com>
 <20200116124231.20253-5-jasowang@redhat.com>
 <20200116153807.GI20978@mellanox.com>
 <8e8aa4b7-4948-5719-9618-e28daffba1a5@redhat.com>
In-Reply-To: <8e8aa4b7-4948-5719-9618-e28daffba1a5@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR15CA0004.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::17) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [142.68.57.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4e426507-b713-4384-ef80-08d79b55958e
x-ms-traffictypediagnostic: VI1PR05MB4880:|VI1PR05MB4880:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB48803FC4E0AE88417DD939B0CF310@VI1PR05MB4880.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:751;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39850400004)(346002)(396003)(376002)(366004)(189003)(199004)(316002)(2906002)(86362001)(81166006)(54906003)(8936002)(66446008)(64756008)(66556008)(8676002)(26005)(66946007)(9746002)(9786002)(66476007)(7416002)(36756003)(71200400001)(5660300002)(186003)(52116002)(478600001)(6916009)(1076003)(81156014)(4326008)(2616005)(33656002)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4880;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XYxy6lUitAeauesRFqqq+i5VWoWLaeXglBME+Uk1V5zzHIjoEYby0VLM2q1hcxGcnwH8qKJcdnTG/8Iq/Mw/v/LWMqT7WxdZM7z18zPhp7M+osdTHyc4VuTC8zcIYABTaWqny8dgNmChgVWqRRpMCES0w47M1uCh7PSBkuEvYBycmghMUYNQ/Q7zo2Gb0qaC5caQnB0mguiHpcS0WXOdeH50bZLLEAQkZmpC/h4+nLRb7KREyVjb6Jk84vf+LiX8PQgI9GAWOFYBy9jqvx/+AqzAZw0iPqJTo/fxsvA94Qcc06Nz0Uq5PWMuH0L6KC+DoDBPDb2TyTpJMnjvxphpuK9ZHRVFgBWS05mwTU47j0FTHDlRxhp9jMNoKeP/cJ6WO/Itt9z3YSKR2YF+20IOzmAWBD9jDGBOoZSlM8CfNvt7uOy/x0QA0DZMa6Yhm0K24jSvDw3hViM+HCIPRUPTbiGsSO4qpTg3fER6rjBnsYofwCf6L3O4PDymd901MslE
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BCEE5E4AAADEB445898F0BB179338629@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e426507-b713-4384-ef80-08d79b55958e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 14:00:18.2531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VBD+njxxgmIS3oufK/DbI2z2+axTI4dh954NrJB+bp7rLqwVUo/xJYdY+8gQv0TZunEnQxGdAgxuXw0N1VA/Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4880
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 17, 2020 at 05:32:35PM +0800, Jason Wang wrote:
> >=20
> > > +	const struct vdpa_config_ops *ops =3D vdpa->config;
> > > +	struct virtio_vdpa_device *vd_dev;
> > > +	int rc;
> > > +
> > > +	vd_dev =3D devm_kzalloc(dev, sizeof(*vd_dev), GFP_KERNEL);
> > > +	if (!vd_dev)
> > > +		return -ENOMEM;
> > This is not right, the struct device lifetime is controled by a kref,
> > not via devm. If you want to use a devm unwind then the unwind is
> > put_device, not devm_kfree.
>=20
> I'm not sure I get the point here. The lifetime is bound to underlying vD=
PA
> device and devres allow to be freed before the vpda device is released. B=
ut
> I agree using devres of underlying vdpa device looks wired.

Once device_initialize is called the only way to free a struct device
is via put_device, while here you have a devm trigger that will
unconditionally do kfree on a struct device without respecting the
reference count.

reference counted memory must never be allocated with devm.

> > > +	vd_dev->vdev.dev.release =3D virtio_vdpa_release_dev;
> > > +	vd_dev->vdev.config =3D &virtio_vdpa_config_ops;
> > > +	vd_dev->vdpa =3D vdpa;
> > > +	INIT_LIST_HEAD(&vd_dev->virtqueues);
> > > +	spin_lock_init(&vd_dev->lock);
> > > +
> > > +	vd_dev->vdev.id.device =3D ops->get_device_id(vdpa);
> > > +	if (vd_dev->vdev.id.device =3D=3D 0)
> > > +		return -ENODEV;
> > > +
> > > +	vd_dev->vdev.id.vendor =3D ops->get_vendor_id(vdpa);
> > > +	rc =3D register_virtio_device(&vd_dev->vdev);
> > > +	if (rc)
> > > +		put_device(dev);
> > And a ugly unwind like this is why you want to have device_initialize()
> > exposed to the driver,
>=20
> In this context, which "driver" did you mean here? (Note, virtio-vdpa is =
the
> driver for vDPA bus here).

'driver' is the thing using the 'core' library calls to implement a
device, so here the 'vd_dev' is the driver and
'register_virtio_device' is the core

> >=20
> > Where is the various THIS_MODULE's I expect to see in a scheme like
> > this?
> >=20
> > All function pointers must be protected by a held module reference
> > count, ie the above probe/remove and all the pointers in ops.
>=20
> Will double check, since I don't see this in other virtio transport drive=
rs
> (PCI or MMIO).

pci_register_driver is a macro that provides a THIS_MODULE, and the
pci core code sets driver.owner, then the rest of the stuff related to
driver ops is supposed to work against that to protect the driver ops.

For the device module refcounting you either need to ensure that
'unregister' is a strong fence and guanentees that no device ops are
called past unregister (noting that this is impossible for release),
or you need to hold the module lock until release.

It is common to see non-core subsystems get this stuff wrong.

Jason
