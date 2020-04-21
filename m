Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2651B3309
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 01:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbgDUX1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 19:27:19 -0400
Received: from mga12.intel.com ([192.55.52.136]:35571 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgDUX1T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 19:27:19 -0400
IronPort-SDR: xTi2F5SiGkPN64OMVSZFyxvoECfbzjIHugYTGDLZTEvqkLxzj8Vf1vbvPQLLMj+BjlBubWghjX
 CBhcTCGdQSNw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 16:27:18 -0700
IronPort-SDR: NDfu5AXhDd/v7NCEt01LC1GQXEAwstm43f082P9X5jpiuVbm9WEPC389xRKiyhyfUpFuC1IChl
 ZDRBgmrzp8uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="429699178"
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by orsmga005.jf.intel.com with ESMTP; 21 Apr 2020 16:27:18 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Apr 2020 16:27:17 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 21 Apr 2020 16:27:17 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 21 Apr 2020 16:27:17 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Apr 2020 16:27:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JdmPJrPjAyeM9SxVK+4wXV07yzeVO8CLTHHGIuftVNjs77pydeImijPMzuBVoR8hmjYJk9utDdNtjuAto72cZBpofnhbisat8ljznOm8M94rKqzeXWcky+8KbWes4OMSDHI1/v5/2JBvq0Km7BcawmgHTLJs1ydbkaNvI6fbzXSjfcQ34DHdnFrS1P19qSZedt2TKKHdxOu4u05v6ekHaKnn1hwkW/CTqu/7/5KoatrDs6yH78Xe9lNyaZqEhWkQUWro4m2eIwNNVOH75/tmiAPsn40BNHUAVugLJNt2LP8R6E3XZt0YljxETuoV8B6pJgjav7SpsY3y4JxDDBldfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XTmwRVvbqIH0z/PGHcVitmGc+TOI4TVFjhrMygxejTM=;
 b=OvZSMR1H6BemC7FpNU3eYbi4leJpw6DyK+esyi5SfWWv0By4iWX/DfJHj8wTvX06JgFZueiUUGpDCedvVI9YtRnMG5Jn/W03nNZtJWUTdBeBFyC2CI+xO2Rw5ROewdLD9aU47Sv/zyUF3l7Dg2BDrDIyqJHjqDzceolvhfpvOp5XNvvjKq5W4oTg8Ye4Cw8mwwJyeBNyb1E68685V+OwJ76ofIL8hnuSFB05A0HjXIGnagI0Au5YvwqE98l7+2/QYGbvWkCCckB3RJ/gtGX9RIbyNeOf4WHyfryveVvTsVluzMtfnAjlQZ7RmKIlHjUetK+cWxKLSWLvCgnG6eMU3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XTmwRVvbqIH0z/PGHcVitmGc+TOI4TVFjhrMygxejTM=;
 b=KAMLMsIHcwhgDj7mBrtf3dL8hSrRdM2kg9KSoyaONAFNfUjtMRfBvMyfDbWgZMS7aMdZ+ApXEQmhE614icDmYejbcah1R8hEy4l7hIgoXDDPNShwaQ8zoO1vL5QZa3GFcBW3rhzLDi2GjEjL4xMcte7axxA5z6IP/csk1glizjo=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) by
 DM6PR11MB4594.namprd11.prod.outlook.com (2603:10b6:5:2a0::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.29; Tue, 21 Apr 2020 23:27:09 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::7069:6745:3ad1:bcde]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::7069:6745:3ad1:bcde%6]) with mapi id 15.20.2921.030; Tue, 21 Apr 2020
 23:27:09 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Leon Romanovsky <leonro@mellanox.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "galpress@amazon.com" <galpress@amazon.com>,
        "selvin.xavier@broadcom.com" <selvin.xavier@broadcom.com>,
        "sriharsha.basavapatna@broadcom.com" 
        <sriharsha.basavapatna@broadcom.com>,
        "benve@cisco.com" <benve@cisco.com>,
        "bharat@chelsio.com" <bharat@chelsio.com>,
        "xavier.huwei@huawei.com" <xavier.huwei@huawei.com>,
        "yishaih@mellanox.com" <yishaih@mellanox.com>,
        "mkalderon@marvell.com" <mkalderon@marvell.com>,
        "aditr@vmware.com" <aditr@vmware.com>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: RE: [net-next v2 1/9] Implementation of Virtual Bus
Thread-Topic: [net-next v2 1/9] Implementation of Virtual Bus
Thread-Index: AQHWF7NVLB1tcCGx3U+1R3mqkL/BoqiDSVyAgACbA/A=
Date:   Tue, 21 Apr 2020 23:27:09 +0000
Message-ID: <DM6PR11MB28416D46B4F4AE93EDE421D8DDD50@DM6PR11MB2841.namprd11.prod.outlook.com>
References: <20200421080235.6515-1-jeffrey.t.kirsher@intel.com>
 <20200421080235.6515-2-jeffrey.t.kirsher@intel.com>
 <20200421090811.GK121146@unreal>
In-Reply-To: <20200421090811.GK121146@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=david.m.ertman@intel.com; 
x-originating-ip: [50.38.43.118]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9847b981-c266-4571-1f4b-08d7e64b830e
x-ms-traffictypediagnostic: DM6PR11MB4594:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB4594B49DB9969DD678836B16DDD50@DM6PR11MB4594.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 038002787A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2841.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(366004)(55016002)(9686003)(76116006)(6636002)(64756008)(66946007)(33656002)(498600001)(66476007)(66446008)(52536014)(8936002)(66556008)(5660300002)(2906002)(7416002)(86362001)(7696005)(54906003)(110136005)(8676002)(53546011)(81156014)(71200400001)(6506007)(186003)(4326008)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mq0AV7FuawfDpB5ZRDw4LVpD6KXqwZ2UxPWtUxUpY0fHg33Fww/yEQ4THXKl249Ew9RgLv5+ti7oisBAqpcIL+PufVX1RUsZ6HDyc44s1nBkZ1lFpFlp5yF7xrubHxNeVq5H7VNGY0gVRkhWtvvFF5Zko3FmGk6x+/QIuIU99la4xx/xYAsGttObZjebu1YDgp3KMBjiElkrYHwMve6DhZuvVVTbW/h6mSc4DzhL/7pMcALq5mXLtyzNcfxkF6Z96qvBA6RBeOJcAZ74Hx5lasD3T68u17Qhi//zgSZP1eIzpVzHnOLDrfzXkPmuAc0A+i1bsRFRFo+FuUGARRsR4qIye6hpuapdjaHTr8llCBnZxHh4twteZ8SAXolxeNcWZaBVQYvUbRfCT6AYHiu7eiYIfgEFw0xrZ/HRX0Y07O83daLUx1gVf5z4OyCbrGjA
x-ms-exchange-antispam-messagedata: xO/h2TNhTWRkahi+chW2LlfJMtENF9olX+lxq4yYPHUd5ej/i3h4AnzAheZA0ZqoR6fxPz4GVoX1Ioa7xxGyOg4r/9PiMM+SEd3p8YKr5c7M9RgcKjZ8tK+vnlWVp+zPyoQRVJ6boHhwYD3+Wffovw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9847b981-c266-4571-1f4b-08d7e64b830e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2020 23:27:09.0641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v2ze+Lo5tVwr3I4bj1k3jdtGjTM1TWVpF2sLHEwjpAR3Bdsl9fS0jTTaaM/aH6CNH38siEk1hTW69ew4d9hRv9I2q1VF3sCAdC3VHg8wVKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4594
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Leon Romanovsky <leonro@mellanox.com>
> Sent: Tuesday, April 21, 2020 2:08 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; gregkh@linuxfoundation.org; Ertman, David M
> <david.m.ertman@intel.com>; netdev@vger.kernel.org; linux-
> rdma@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com;
> jgg@ziepe.ca; parav@mellanox.com; galpress@amazon.com;
> selvin.xavier@broadcom.com; sriharsha.basavapatna@broadcom.com;
> benve@cisco.com; bharat@chelsio.com; xavier.huwei@huawei.com;
> yishaih@mellanox.com; mkalderon@marvell.com; aditr@vmware.com;
> ranjani.sridharan@linux.intel.com; pierre-louis.bossart@linux.intel.com;
> Patil, Kiran <kiran.patil@intel.com>; Bowers, AndrewX
> <andrewx.bowers@intel.com>
> Subject: Re: [net-next v2 1/9] Implementation of Virtual Bus
>=20
> On Tue, Apr 21, 2020 at 01:02:27AM -0700, Jeff Kirsher wrote:
> > From: Dave Ertman <david.m.ertman@intel.com>
> >
> > This is the initial implementation of the Virtual Bus,
> > virtbus_device and virtbus_driver.  The virtual bus is
> > a software based bus intended to support registering
> > virtbus_devices and virtbus_drivers and provide matching
> > between them and probing of the registered drivers.
> >
> > The bus will support probe/remove shutdown and
> > suspend/resume callbacks.
> >
> > Kconfig and Makefile alterations are included
> >
> > Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> > Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> > Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com=
>
> > Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > ---
> >  Documentation/driver-api/virtual_bus.rst |  62 +++++
> >  drivers/bus/Kconfig                      |  10 +
> >  drivers/bus/Makefile                     |   2 +
> >  drivers/bus/virtual_bus.c                | 279 +++++++++++++++++++++++
> >  include/linux/mod_devicetable.h          |   8 +
> >  include/linux/virtual_bus.h              |  53 +++++
> >  scripts/mod/devicetable-offsets.c        |   3 +
> >  scripts/mod/file2alias.c                 |   7 +
> >  8 files changed, 424 insertions(+)
> >  create mode 100644 Documentation/driver-api/virtual_bus.rst
> >  create mode 100644 drivers/bus/virtual_bus.c
> >  create mode 100644 include/linux/virtual_bus.h
> >
> > diff --git a/Documentation/driver-api/virtual_bus.rst
> b/Documentation/driver-api/virtual_bus.rst
> > new file mode 100644
> > index 000000000000..a79db0e9231e
> > --- /dev/null
> > +++ b/Documentation/driver-api/virtual_bus.rst
> > @@ -0,0 +1,62 @@
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> > +Virtual Bus Devices and Drivers
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +See <linux/virtual_bus.h> for the models for virtbus_device and
> virtbus_driver.
> > +This bus is meant to be a lightweight software based bus to attach gen=
eric
> > +devices and drivers to so that a chunk of data can be passed between
> them.
> > +
> > +One use case example is an RDMA driver needing to connect with several
> > +different types of PCI LAN devices to be able to request resources fro=
m
> > +them (queue sets).  Each LAN driver that supports RDMA will register a
> > +virtbus_device on the virtual bus for each physical function.  The RDM=
A
> > +driver will register as a virtbus_driver on the virtual bus to be
> > +matched up with multiple virtbus_devices and receive a pointer to a
> > +struct containing the callbacks that the PCI LAN drivers support for
> > +registering with them.
> > +
> > +Sections in this document:
> > +        Virtbus devices
> > +        Virtbus drivers
> > +        Device Enumeration
> > +        Device naming and driver binding
> > +        Virtual Bus API entry points
> > +
> > +Virtbus devices
> > +~~~~~~~~~~~~~~~
> > +Virtbus_devices support the minimal device functionality.  Devices wil=
l
> > +accept a name, and then, when added to the virtual bus, an automatical=
ly
> > +generated index is concatenated onto it for the virtbus_device->name.
> > +
> > +Virtbus drivers
> > +~~~~~~~~~~~~~~~
> > +Virtbus drivers register with the virtual bus to be matched with virtb=
us
> > +devices.  They expect to be registered with a probe and remove callbac=
k,
> > +and also support shutdown, suspend, and resume callbacks.  They
> otherwise
> > +follow the standard driver behavior of having discovery and enumeratio=
n
> > +handled in the bus infrastructure.
> > +
> > +Virtbus drivers register themselves with the API entry point
> > +virtbus_register_driver and unregister with virtbus_unregister_driver.
> > +
> > +Device Enumeration
> > +~~~~~~~~~~~~~~~~~~
> > +Enumeration is handled automatically by the bus infrastructure via the
> > +ida_simple methods.
> > +
> > +Device naming and driver binding
> > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > +The virtbus_device.dev.name is the canonical name for the device. It i=
s
> > +built from two other parts:
> > +
> > +        - virtbus_device.name (also used for matching).
> > +        - virtbus_device.id (generated automatically from ida_simple c=
alls)
> > +
> > +Virtbus device IDs are always in "<name>.<instance>" format.  Instance=
s
> are
> > +automatically selected through an ida_simple_get so are positive integ=
ers.
> > +Name is taken from the device name field.
> > +
> > +Driver IDs are simple <name>.
> > +
> > +Need to extract the name from the Virtual Device compare to name of
> the
> > +driver.
> > diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
> > index 6d4e4497b59b..00553c78510c 100644
> > --- a/drivers/bus/Kconfig
> > +++ b/drivers/bus/Kconfig
> > @@ -203,4 +203,14 @@ config DA8XX_MSTPRI
> >  source "drivers/bus/fsl-mc/Kconfig"
> >  source "drivers/bus/mhi/Kconfig"
> >
> > +config VIRTUAL_BUS
> > +       tristate "Software based Virtual Bus"
> > +       help
> > +         Provides a software bus for virtbus_devices to be added to it
> > +         and virtbus_drivers to be registered on it.  It matches drive=
r
> > +         and device based on id and calls the driver's probe routine.
> > +         One example is the irdma driver needing to connect with vario=
us
> > +         PCI LAN drivers to request resources (queues) to be able to p=
erform
> > +         its function.
> > +
> >  endmenu
> > diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
> > index 05f32cd694a4..d30828a4768c 100644
> > --- a/drivers/bus/Makefile
> > +++ b/drivers/bus/Makefile
> > @@ -37,3 +37,5 @@ obj-$(CONFIG_DA8XX_MSTPRI)	+=3D da8xx-mstpri.o
> >
> >  # MHI
> >  obj-$(CONFIG_MHI_BUS)		+=3D mhi/
> > +
> > +obj-$(CONFIG_VIRTUAL_BUS)	+=3D virtual_bus.o
> > diff --git a/drivers/bus/virtual_bus.c b/drivers/bus/virtual_bus.c
> > new file mode 100644
> > index 000000000000..f5e66d110385
> > --- /dev/null
> > +++ b/drivers/bus/virtual_bus.c
> > @@ -0,0 +1,279 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * virtual_bus.c - lightweight software based bus for virtual devices
> > + *
> > + * Copyright (c) 2019-2020 Intel Corporation
> > + *
> > + * Please see Documentation/driver-api/virtual_bus.rst for
> > + * more information
> > + */
> > +
> > +#include <linux/string.h>
> > +#include <linux/virtual_bus.h>
> > +#include <linux/of_irq.h>
> > +#include <linux/module.h>
> > +#include <linux/init.h>
> > +#include <linux/pm_runtime.h>
> > +#include <linux/pm_domain.h>
> > +#include <linux/acpi.h>
> > +#include <linux/device.h>
> > +
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_DESCRIPTION("Virtual Bus");
> > +MODULE_AUTHOR("David Ertman <david.m.ertman@intel.com>");
> > +MODULE_AUTHOR("Kiran Patil <kiran.patil@intel.com>");
> > +
> > +static DEFINE_IDA(virtbus_dev_ida);
> > +
> > +static const
> > +struct virtbus_dev_id *virtbus_match_id(const struct virtbus_dev_id *i=
d,
> > +					struct virtbus_device *vdev)
> > +{
> > +	while (id->name[0]) {
> > +		if (!strcmp(vdev->name, id->name))
> > +			return id;
> > +		id++;
> > +	}
> > +	return NULL;
> > +}
> > +
> > +static int virtbus_match(struct device *dev, struct device_driver *drv=
)
> > +{
> > +	struct virtbus_driver *vdrv =3D to_virtbus_drv(drv);
> > +	struct virtbus_device *vdev =3D to_virtbus_dev(dev);
> > +
> > +	return virtbus_match_id(vdrv->id_table, vdev) !=3D NULL;
> > +}
> > +
> > +static int virtbus_probe(struct device *dev)
> > +{
> > +	return dev->driver->probe(dev);
> > +}
> > +
> > +static int virtbus_remove(struct device *dev)
> > +{
> > +	return dev->driver->remove(dev);
> > +}
> > +
> > +static void virtbus_shutdown(struct device *dev)
> > +{
> > +	dev->driver->shutdown(dev);
> > +}
> > +
> > +static int virtbus_suspend(struct device *dev, pm_message_t state)
> > +{
> > +	if (dev->driver->suspend)
> > +		return dev->driver->suspend(dev, state);
> > +
> > +	return 0;
> > +}
> > +
> > +static int virtbus_resume(struct device *dev)
> > +{
> > +	if (dev->driver->resume)
> > +		return dev->driver->resume(dev);
> > +
> > +	return 0;
>=20
> The common practice is to write it differently.
> static int virtbus_resume(struct device *dev)
> {
> 	if (!dev->driver->resume)
> 		return 0;
>=20
> 	return dev->driver->resume(dev);
> }
>=20
> and you are not consistent in this patch, sometimes you write
> these functions in your format, sometimes in my format.
>=20
> Thanks

Changed functions to match common practice

-DaveE

