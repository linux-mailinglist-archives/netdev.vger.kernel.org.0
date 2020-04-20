Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD181B1A0C
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 01:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgDTXQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 19:16:45 -0400
Received: from mga18.intel.com ([134.134.136.126]:2703 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbgDTXQo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 19:16:44 -0400
IronPort-SDR: KQXLp8+Fs6MUran7rnFL2+MU0Z1laJ0FlPwmvwLkvso/iuVa3lRFF6ZGfyJPPq84+A1QvBYphs
 WC28jl7AmKLg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 16:16:43 -0700
IronPort-SDR: r+sRAd6BecBkamdBE8ruh3DdSZgpp8PQhzRJtoVFzRQ3+VKHldTEbtmkx7Dt5vRT3/uR/xhsLw
 XV/3E4kdlfuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,408,1580803200"; 
   d="scan'208";a="455868715"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga005.fm.intel.com with ESMTP; 20 Apr 2020 16:16:43 -0700
Received: from fmsmsx117.amr.corp.intel.com (10.18.116.17) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Apr 2020 16:16:43 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx117.amr.corp.intel.com (10.18.116.17) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Apr 2020 16:16:42 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.58) by
 edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 20 Apr 2020 16:16:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dc5Rbw7DW/xHpBbyRmzeU8sio0agc1cHGO/tbyDKWBYVUWenGi68ZntP/D7rzyAOSAtUBzaHPf9s9QfZ9ZbeKp5QWXcbU/V8RXXkSWcEMbh9tMgcAdVG6Yag5E/vsM+fwZNBZlKymvvz3WKYtOsBuD7W7o9JArUNoMkb1UwP1oQz82cstuU3Rd4rAMEEgzHy5PZw1HK+V0JQ+UYgc/ZvcxCaMy7yoZ+IQ6CS/nHS+s622L5zJxZOsw062ME38ePVQzgRNfx6X5RoC6VlSkTbiz3Ryariv5KnLBXkBhbivpQi9+jYpQX6wPqj/K6wA+4vyiA16tW4MFC28axYfQo1RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W5nZNu5AWo40ibQd7IE9R/uMsDUd0mHr3cQqLCQUtzY=;
 b=YeRXNt+aYGQQ5jo4LDxxxTVcoOY79UiFQQnaoL+Nl+MerkcUYHKVVANU3PaSTRFeX6Eu5NAJFVWkMsquWqbL+oKkIFEcZ9s5HxsbkryHsfctY3YERoMJBBhHF7w1Sd6adgEml4uRd8WHgiBWtlstuIi3HfZOn5hOCvwdakDvSA9KDFIuEX5ZtLlOl0NIw6/dLNVxuM/A6DPmtUH9N9j9G72vhhtYr32nY+RHDE3RwBvf2aqJiFp8QIvhzCQwUPNPMWh0NJiTSDRohr37dqA81I3e3UZAdYilDYsR+2bg3UNlyFu8H4piFZnWRLTAkVUxReC24LHIsq1OZ363UWzbQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W5nZNu5AWo40ibQd7IE9R/uMsDUd0mHr3cQqLCQUtzY=;
 b=zmMvwM8KyagYftIZ/qKyM32di4bAB75SG02fGpmQ8ldDWKu3/Vdto8Cfki2vy6pbyINwl4Y5jR2VrdiEa/GjjKNQ/OK6/EBGMUupbtwOdFH6bqXx1B0vtJutWZgNsEqF4qZ3oDr0HR46wRjpPX9BYgqBeFmL53V+5ghshyt1tJk=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) by
 DM6PR11MB3932.namprd11.prod.outlook.com (2603:10b6:5:194::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.25; Mon, 20 Apr 2020 23:16:38 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::7069:6745:3ad1:bcde]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::7069:6745:3ad1:bcde%6]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 23:16:38 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "galpress@amazon.com" <galpress@amazon.com>,
        "selvin.xavier@broadcom.com" <selvin.xavier@broadcom.com>,
        "sriharsha.basavapatna@broadcom.com" 
        <sriharsha.basavapatna@broadcom.com>,
        "benve@cisco.com" <benve@cisco.com>,
        "bharat@chelsio.com" <bharat@chelsio.com>,
        "xavier.huwei@huawei.com" <xavier.huwei@huawei.com>,
        "yishaih@mellanox.com" <yishaih@mellanox.com>,
        "leonro@mellanox.com" <leonro@mellanox.com>,
        "mkalderon@marvell.com" <mkalderon@marvell.com>,
        "aditr@vmware.com" <aditr@vmware.com>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: RE: [net-next 1/9] Implementation of Virtual Bus
Thread-Topic: [net-next 1/9] Implementation of Virtual Bus
Thread-Index: AQHWFNtEAfnineIPqEqJBqKNZCsJ6ah9uYwAgASKCEA=
Date:   Mon, 20 Apr 2020 23:16:38 +0000
Message-ID: <DM6PR11MB284111B69E966E68EBC2C508DDD40@DM6PR11MB2841.namprd11.prod.outlook.com>
References: <20200417171034.1533253-1-jeffrey.t.kirsher@intel.com>
 <20200417171034.1533253-2-jeffrey.t.kirsher@intel.com>
 <20200417195148.GL26002@ziepe.ca>
In-Reply-To: <20200417195148.GL26002@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=david.m.ertman@intel.com; 
x-originating-ip: [192.55.52.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7247c1f0-e41f-4d1a-3840-08d7e580e0fa
x-ms-traffictypediagnostic: DM6PR11MB3932:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB39329233145F61B486A8AA4FDDD40@DM6PR11MB3932.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 03793408BA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2841.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(376002)(136003)(39860400002)(396003)(366004)(346002)(6636002)(6506007)(5660300002)(110136005)(316002)(54906003)(53546011)(478600001)(7696005)(2906002)(26005)(186003)(7416002)(55016002)(9686003)(81156014)(86362001)(76116006)(4326008)(52536014)(66946007)(66556008)(66476007)(8676002)(8936002)(71200400001)(33656002)(64756008)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5ASAZuCB+Rlsch1AqdC/Cz0xwHjl7OSUeJK9LTIzXycbibUcqOpkK48Rcl3IpGjYVU1V3lIOp8DJ4oeOeSj79kFpV8G3G7k0kpLADI11Q0eROilrlIo4RV2KLe4eaC9xz2OOr0NDTu0eRbOTozbX7tlh2GE74t8gOKcNq5RdPWCmhwgfvytEU4QCtAqGMcoZNrIvbbbo/h1gey8K9znCZ4htZ7Jyz0QjP+AAeBSHAYeBCkIoc6r4SaY1X25YLafXOJlXnKxyhrBLbrs951MjV+yWbIwDUua+5T/00Oh1rELW3/hrGS+TxMnqvhy8LCOFBFjwpaCkOzzVqtcQQjEJhVGpG+HH7Ek8uiCGtW3Eap1Es3HGPtUtHS6g82LrMd6ULpOokm76JHukQbHxsKFqEjK0OAW0YoN4OpY8AqqIksRt4LVIuT+CDqdqsTBgVg3U
x-ms-exchange-antispam-messagedata: ZDspkr7nUYzrot95WT2zm2zztRkU2bk4oyQFIwrqF69IaipA2Uo1OtGKND0gmFHjB0tBNeGwY/StGAHX6po03EhnqYal0+ss/1i562x+y+FPCbElUGPTx2eZJv2YtnQPLKJp14GwweKJ8F9LTf2neg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7247c1f0-e41f-4d1a-3840-08d7e580e0fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2020 23:16:38.8014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h2WhC97pXIoLDsY/EhHKFEe8/ejAXFckFgzg6EdFH2yOv+ufVR4keHRjQ6rYkXWsmoP/Xk1+YLmUilOuxZd/7Qi899YvFxfu+sV1+VW8Gws=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3932
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Friday, April 17, 2020 12:52 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; gregkh@linuxfoundation.org; Ertman, David M
> <david.m.ertman@intel.com>; netdev@vger.kernel.org; linux-
> rdma@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> parav@mellanox.com; galpress@amazon.com; selvin.xavier@broadcom.com;
> sriharsha.basavapatna@broadcom.com; benve@cisco.com;
> bharat@chelsio.com; xavier.huwei@huawei.com; yishaih@mellanox.com;
> leonro@mellanox.com; mkalderon@marvell.com; aditr@vmware.com;
> ranjani.sridharan@linux.intel.com; pierre-louis.bossart@linux.intel.com; =
Patil,
> Kiran <kiran.patil@intel.com>; Bowers, AndrewX <andrewx.bowers@intel.com>
> Subject: Re: [net-next 1/9] Implementation of Virtual Bus
>=20
> On Fri, Apr 17, 2020 at 10:10:26AM -0700, Jeff Kirsher wrote:
>=20
> > +/**
> > + * virtbus_release_device - Destroy a virtbus device
> > + * @_dev: device to release
> > + */
> > +static void virtbus_release_device(struct device *_dev)
> > +{
> > +	struct virtbus_device *vdev =3D to_virtbus_dev(_dev);
> > +
> > +	ida_simple_remove(&virtbus_dev_ida, vdev->id);
> > +	vdev->release(vdev);
>=20
> This order should probably be swapped (store vdev->id on the stack)

Done

>=20
> > +/**
> > + * virtbus_register_device - add a virtual bus device
> > + * @vdev: virtual bus device to add
> > + */
> > +int virtbus_register_device(struct virtbus_device *vdev)
> > +{
> > +	int ret;
> > +
> > +	/* Do this first so that all error paths perform a put_device */
> > +	device_initialize(&vdev->dev);
> > +
> > +	if (!vdev->release) {
> > +		ret =3D -EINVAL;
> > +		dev_err(&vdev->dev, "virtbus_device MUST have a .release
> callback that does something.\n");
> > +		goto device_pre_err;
>=20
> This does put_device but the release() hasn't been set yet. Doesn't it
> leak memory?

The KO registering the virtbus_device is responsible for allocating and fre=
eing the memory
for the virtbus_device (which should be done in the release() function).  I=
f there is no release
function defined, then the originating KO needs to handle this.  We are try=
ing to not recreate
the platform_bus, so the design philosophy behind virtual_bus is minimalist=
.

>=20
> > +	}
> > +
> > +	/* All device IDs are automatically allocated */
> > +	ret =3D ida_simple_get(&virtbus_dev_ida, 0, 0, GFP_KERNEL);
> > +	if (ret < 0) {
> > +		dev_err(&vdev->dev, "get IDA idx for virtbus device failed!\n");
> > +		goto device_pre_err;
>=20
> Do this before device_initialize()

The memory for virtbus device is allocated by the KO registering the virtbu=
s_device before it
calls virtbus_register_device().  If this function is exiting on an error, =
then we have to do a
put_device() so that the release is called (if it exists) to clean up the m=
emory.

The ida_simple_get is not used until later in the function when setting the=
 vdev->id.  It doesn't matter
what IDA it is used, as long as it is unique.  So, since we cannot have the=
 error state before the device_initialize,
there is no reason to have the ida_sinple_get  before the device_initializa=
tion.
Also refactoring so that the check for a .release() callback is done before=
 the device_initialize since a put_device()
is useless in this context if a release() doesn't exist.

GregKH was pretty insistent that all error paths out of this function go th=
rough a put_device() when possible.

>=20
> > +	}
> > +
> > +
> > +	vdev->dev.bus =3D &virtual_bus_type;
> > +	vdev->dev.release =3D virtbus_release_device;
>=20
> And this immediately after

Done.

>=20
> > +
> > +	vdev->id =3D ret;
> > +	dev_set_name(&vdev->dev, "%s.%d", vdev->name, vdev->id);
>=20
> Missing check of return code

Done

>=20
> Can't understand why vdev->name is being passed in with the struct,
> why not just a function argument?

This avoids having the calling KO have to manage a separate piece of memory
to hold the name during the call to virtbus_device_regsiter.  It is a clean=
er
memory model to just store it once in the virtbus_device itself.  This name=
 is
the abbreviated name without the ID appended on the end, which will be used
for matching drivers and devices.

>=20
> > +	dev_dbg(&vdev->dev, "Registering virtbus device '%s'\n",
> > +		dev_name(&vdev->dev));
> > +
> > +	ret =3D device_add(&vdev->dev);
> > +	if (ret)
> > +		goto device_add_err;
>=20
> This looks like it does ida_simple_remove twice, once in the goto and
> once from the release function called by put_device.

Nice catch. Done

>=20
> > +/**
> > + * virtbus_unregister_device - remove a virtual bus device
> > + * @vdev: virtual bus device we are removing
> > + */
> > +void virtbus_unregister_device(struct virtbus_device *vdev)
> > +{
> > +	device_del(&vdev->dev);
> > +	put_device(&vdev->dev);
> > +}
> > +EXPORT_SYMBOL_GPL(virtbus_unregister_device);
>=20
> Just inline this as wrapper around device_unregister

I thought that EXPORT_SYMBOL makes inline meaningless?
But, putting device_unregister here is a good catch.

>=20
> > +/**
> > + * __virtbus_register_driver - register a driver for virtual bus devic=
es
> > + * @vdrv: virtbus_driver structure
> > + * @owner: owning module/driver
> > + */
> > +int __virtbus_register_driver(struct virtbus_driver *vdrv, struct modu=
le
> *owner)
> > +{
> > +	if (!vdrv->probe || !vdrv->remove || !vdrv->shutdown || !vdrv-
> >id_table)
> > +		return -EINVAL;
> > +
> > +	vdrv->driver.owner =3D owner;
> > +	vdrv->driver.bus =3D &virtual_bus_type;
> > +	vdrv->driver.probe =3D virtbus_probe_driver;
> > +	vdrv->driver.remove =3D virtbus_remove_driver;
> > +	vdrv->driver.shutdown =3D virtbus_shutdown_driver;
> > +	vdrv->driver.suspend =3D virtbus_suspend_driver;
> > +	vdrv->driver.resume =3D virtbus_resume_driver;
> > +
> > +	return driver_register(&vdrv->driver);
> > +}
> > +EXPORT_SYMBOL_GPL(__virtbus_register_driver);
> > +
> > +/**
> > + * virtbus_unregister_driver - unregister a driver for virtual bus dev=
ices
> > + * @vdrv: virtbus_driver structure
> > + */
> > +void virtbus_unregister_driver(struct virtbus_driver *vdrv)
> > +{
> > +	driver_unregister(&vdrv->driver);
> > +}
> > +EXPORT_SYMBOL_GPL(virtbus_unregister_driver);
>=20
> Also just inline this

Same as above on EXPORT_SYMBOL and inline.

>=20
> > diff --git a/include/linux/virtual_bus.h b/include/linux/virtual_bus.h
> > new file mode 100644
> > index 000000000000..4df06178e72f
> > +++ b/include/linux/virtual_bus.h
> > @@ -0,0 +1,53 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * virtual_bus.h - lightweight software bus
> > + *
> > + * Copyright (c) 2019-20 Intel Corporation
> > + *
> > + * Please see Documentation/driver-api/virtual_bus.rst for more inform=
ation
> > + */
> > +
> > +#ifndef _VIRTUAL_BUS_H_
> > +#define _VIRTUAL_BUS_H_
> > +
> > +#include <linux/device.h>
> > +
> > +struct virtbus_device {
> > +	struct device dev;
> > +	const char *name;
> > +	void (*release)(struct virtbus_device *);
> > +	int id;
>=20
> id can't be negative

Done.  Changed to match the u32 in struct device.

>=20
> > +int virtbus_register_device(struct virtbus_device *vdev);
> > +void virtbus_unregister_device(struct virtbus_device *vdev);
>=20
> I continue to think the alloc/register pattern, eg as demonstrated by
> vdpa_alloc_device() and vdpa_register_device() is easier for drivers
> to implement correctly.
>=20
> > +int
> > +__virtbus_register_driver(struct virtbus_driver *vdrv, struct module *=
owner);
> > +void virtbus_unregister_driver(struct virtbus_driver *vdrv);
> > +
> > +#define virtbus_register_driver(vdrv) \
> > +	__virtbus_register_driver(vdrv, THIS_MODULE)
> > +
>=20
> It is reasonable to also provide a module_driver() macro.
>=20
> Jason

-DaveE
