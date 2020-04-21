Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D031B330B
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 01:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgDUX1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 19:27:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:48166 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726012AbgDUX1V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 19:27:21 -0400
IronPort-SDR: B+XjlnGLpfwTQmuHvqMQTSDMs934LX/ggeW8GVpxahOci7tMZD2ZdWvG0jkckA5pGghkTp3ZP7
 YlkO/Isqi+Jw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 16:27:20 -0700
IronPort-SDR: 2Tmmue/6pLvDgtrUKeAcaDdx7XngG3o2xrP+A/uJPESAOuFwx5uC8NX9BnrmWfzck++9zsIcAL
 LmDUfGwY8img==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="365504592"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by fmsmga001.fm.intel.com with ESMTP; 21 Apr 2020 16:27:20 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Apr 2020 16:27:19 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 21 Apr 2020 16:27:19 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 21 Apr 2020 16:27:19 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 21 Apr 2020 16:27:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jePVUv8ZPa69xUqFu54jAsHmfzgV4cTZrO0Z4ObY2kpH+6C8ANySzrMIgniqrufH1DpCHIO8G1jHhEqqQMo3+96YAl0AXf0A2bb4LYO/oAMCehHqP7HQZGFuB8/fWfqoAS2e8inTg2WYf0Dknez8HOnXM8XJwgxiCVyzw1bF0mfEyKeMZKWSMEad11KlQtlK5DBvTl59YWFyyyb4XngWSRIKh+h+1DAc1Vw+7VRtm6f+keiEfv+dH7WUwZoelY9dR8KIyIJU3JLzmNSWHSshxiQPwZWbFz2nAq+mHnys6xKSK+EV7OEeSJU5HFrN4r+HrR5oiVS99BeXllTHWrgmdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXN7IL80zKaHsVM1vVEyoRScs/wbMgYx/GVLoc4DpcY=;
 b=mrLfsoJ+DJrNsNM3qnX/Us26+gyFLyqIzf02EnjteZkGE5IGf2KLF8kvzEyZG+I41SGAM+L90AO3dpQlIBFLmWwaf19qPvc8AzczoUeyDsFYYLPX9XeyEpdsZ9NjeHxLwdPWwWAfEkrVDmF0eUuHYck6+maJG7FjEbBWx/sgt6noFSA6VOM9Eq2bPGtnCMBJtQyB6Y/aK1NqpvvqaqGtc4Oswe66CFh2phTkmTcai12+qwuRix5EsaGGdXkNcAvNEpJlQFKt14fG3T8ekDE/UypxtgVqBCbj4BXFP+vOi0/UjbKgki6v0i+3hKpPvvK+c5X6RI8gRpVpP68m5F7n3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXN7IL80zKaHsVM1vVEyoRScs/wbMgYx/GVLoc4DpcY=;
 b=ldQ9va5KMdu2kqfSidsi0c56SsE0WtMnEe5DYmTYeK0uz+VsLkfVM+HicM+uwhvMhN0r0X7FV/aeKHw8BnXZ4ig57KnhZQYCLbwEJC1AFQnEoTujsSKOvgnKvLIjTzfAWyj4xTIzcY+IIrCcUB4ELoKVJp99+KD5u2UQAU1qie0=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) by
 DM6PR11MB4594.namprd11.prod.outlook.com (2603:10b6:5:2a0::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.29; Tue, 21 Apr 2020 23:27:11 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::7069:6745:3ad1:bcde]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::7069:6745:3ad1:bcde%6]) with mapi id 15.20.2921.030; Tue, 21 Apr 2020
 23:27:11 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
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
        "leonro@mellanox.com" <leonro@mellanox.com>,
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
Thread-Index: AQHWF7NVLB1tcCGx3U+1R3mqkL/BoqiDQN2AgAADooCAAAsOgIAAq8kw
Date:   Tue, 21 Apr 2020 23:27:11 +0000
Message-ID: <DM6PR11MB2841365E673D65D3A0E88359DDD50@DM6PR11MB2841.namprd11.prod.outlook.com>
References: <20200421080235.6515-1-jeffrey.t.kirsher@intel.com>
 <20200421080235.6515-2-jeffrey.t.kirsher@intel.com>
 <20200421083747.GC716720@kroah.com>
 <61CC2BC414934749BD9F5BF3D5D940449866D956@ORSMSX112.amr.corp.intel.com>
 <20200421093021.GA725219@kroah.com>
In-Reply-To: <20200421093021.GA725219@kroah.com>
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
x-ms-office365-filtering-correlation-id: 1d7eb29f-6717-4b28-7899-08d7e64b8454
x-ms-traffictypediagnostic: DM6PR11MB4594:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB45945289C4C97CE4C7619813DDD50@DM6PR11MB4594.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 038002787A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2841.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(366004)(55016002)(9686003)(76116006)(6636002)(64756008)(66946007)(33656002)(498600001)(66476007)(66446008)(52536014)(8936002)(66556008)(5660300002)(2906002)(7416002)(86362001)(7696005)(54906003)(110136005)(8676002)(53546011)(81156014)(71200400001)(6506007)(186003)(4326008)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5h+gUDNCz5j8BkhVO41CShJgkYgIdipjXy0vURWo3zQc8Hw/edPuBduyZPCuFAY0xE46ZBAKuba/QhGI+D7xrsWX2daxLSBtvcPP87d8y0KzUJW5smwBz7VTdXEi2bimuNFqaAgfxF9xM8e7JD/S6vGfCPJm9M7T3OAHzqR5uUBv4w8NNMB2vDTX/TTaGOzG4JUsFxXMA88meu/OZaDAxC0TR8YHSg/YHpev0sRALSbfItUSWtoa+JHR/ZTaGvdMIJq/k4bUgxwdM7w4bEeQ7i7N5O/mmmPMaJg2/8N+QuiN6RclpSuBgUS4TeHeUineQKXm9Eyc0wPC8WlaTC7ZkTVahfTdb4NEYY+McVXg+gVMYiyjRClJmXxTreT5x5fD7WEYHIfXKgbrnJxQYTMzHntoDZksONpiPC7uJhKKFr/bR2p4HzwNxwbVjcZQVGv3
x-ms-exchange-antispam-messagedata: WDR7JwVboTcg7teHBZ+Kl7e7uOOdzn26a8MZtNla1jUQJHTSqzFOFI8Jol/9Sfb+FNz7bGuazrMKvJtixi0A1pl1iwkDVi5aVjQmbbiFYpaD4YWE2oLiHlq9kkprkAEbRPmIK2vbeS4VvHilZHSEjA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d7eb29f-6717-4b28-7899-08d7e64b8454
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2020 23:27:11.2289
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: odwqPMCOM2xUGZbGGHkcxsK90MNZK2nr7WGakKkyqrZ4r5rCxC63C0NUy63Jp0ATuo4YytQq7KlXzuio1kWoYA72yRTz7VSBviRWHFRrKk8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4594
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rewrote the Documentation with more of an idea to helping someone
doing an implementation - please let me know if it is better / worse, needs=
 some
tweaking, or just axe it all together.

Thanks for all of the feedback!!

-DaveE

> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Tuesday, April 21, 2020 2:30 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; Ertman, David M <david.m.ertman@intel.com>;
> netdev@vger.kernel.org; linux-rdma@vger.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com; jgg@ziepe.ca;
> parav@mellanox.com; galpress@amazon.com;
> selvin.xavier@broadcom.com; sriharsha.basavapatna@broadcom.com;
> benve@cisco.com; bharat@chelsio.com; xavier.huwei@huawei.com;
> yishaih@mellanox.com; leonro@mellanox.com; mkalderon@marvell.com;
> aditr@vmware.com; ranjani.sridharan@linux.intel.com; pierre-
> louis.bossart@linux.intel.com; Patil, Kiran <kiran.patil@intel.com>; Bowe=
rs,
> AndrewX <andrewx.bowers@intel.com>
> Subject: Re: [net-next v2 1/9] Implementation of Virtual Bus
>=20
> On Tue, Apr 21, 2020 at 08:50:47AM +0000, Kirsher, Jeffrey T wrote:
> > > -----Original Message-----
> > > From: Greg KH <gregkh@linuxfoundation.org>
> > > Sent: Tuesday, April 21, 2020 01:38
> > > To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> > > Cc: davem@davemloft.net; Ertman, David M
> <david.m.ertman@intel.com>;
> > > netdev@vger.kernel.org; linux-rdma@vger.kernel.org;
> nhorman@redhat.com;
> > > sassmann@redhat.com; jgg@ziepe.ca; parav@mellanox.com;
> > > galpress@amazon.com; selvin.xavier@broadcom.com;
> > > sriharsha.basavapatna@broadcom.com; benve@cisco.com;
> > > bharat@chelsio.com; xavier.huwei@huawei.com;
> yishaih@mellanox.com;
> > > leonro@mellanox.com; mkalderon@marvell.com; aditr@vmware.com;
> > > ranjani.sridharan@linux.intel.com; pierre-louis.bossart@linux.intel.c=
om;
> Patil,
> > > Kiran <kiran.patil@intel.com>; Bowers, AndrewX
> > > <andrewx.bowers@intel.com>
> > > Subject: Re: [net-next v2 1/9] Implementation of Virtual Bus
> > >
> > > On Tue, Apr 21, 2020 at 01:02:27AM -0700, Jeff Kirsher wrote:
> > > > --- /dev/null
> > > > +++ b/Documentation/driver-api/virtual_bus.rst
> > > > @@ -0,0 +1,62 @@
> > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > +Virtual Bus Devices and Drivers
> > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > +
> > > > +See <linux/virtual_bus.h> for the models for virtbus_device and
> > > virtbus_driver.
> > > > +This bus is meant to be a lightweight software based bus to attach
> > > > +generic devices and drivers to so that a chunk of data can be pass=
ed
> > > between them.
> > > > +
> > > > +One use case example is an RDMA driver needing to connect with
> > > > +several different types of PCI LAN devices to be able to request
> > > > +resources from them (queue sets).  Each LAN driver that supports
> RDMA
> > > > +will register a virtbus_device on the virtual bus for each physica=
l
> > > > +function.  The RDMA driver will register as a virtbus_driver on th=
e
> > > > +virtual bus to be matched up with multiple virtbus_devices and
> > > > +receive a pointer to a struct containing the callbacks that the PC=
I
> > > > +LAN drivers support for registering with them.
> > > > +
> > > > +Sections in this document:
> > > > +        Virtbus devices
> > > > +        Virtbus drivers
> > > > +        Device Enumeration
> > > > +        Device naming and driver binding
> > > > +        Virtual Bus API entry points
> > > > +
> > > > +Virtbus devices
> > > > +~~~~~~~~~~~~~~~
> > > > +Virtbus_devices support the minimal device functionality.  Devices
> > > > +will accept a name, and then, when added to the virtual bus, an
> > > > +automatically generated index is concatenated onto it for the
> > > virtbus_device->name.
> > > > +
> > > > +Virtbus drivers
> > > > +~~~~~~~~~~~~~~~
> > > > +Virtbus drivers register with the virtual bus to be matched with
> > > > +virtbus devices.  They expect to be registered with a probe and
> > > > +remove callback, and also support shutdown, suspend, and resume
> > > > +callbacks.  They otherwise follow the standard driver behavior of
> > > > +having discovery and enumeration handled in the bus infrastructure=
.
> > > > +
> > > > +Virtbus drivers register themselves with the API entry point
> > > > +virtbus_register_driver and unregister with virtbus_unregister_dri=
ver.
> > > > +
> > > > +Device Enumeration
> > > > +~~~~~~~~~~~~~~~~~~
> > > > +Enumeration is handled automatically by the bus infrastructure via
> > > > +the ida_simple methods.
> > > > +
> > > > +Device naming and driver binding
> > > > +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > > +The virtbus_device.dev.name is the canonical name for the device. =
It
> > > > +is built from two other parts:
> > > > +
> > > > +        - virtbus_device.name (also used for matching).
> > > > +        - virtbus_device.id (generated automatically from ida_simp=
le
> > > > + calls)
> > > > +
> > > > +Virtbus device IDs are always in "<name>.<instance>" format.
> > > > +Instances are automatically selected through an ida_simple_get so =
are
> > > positive integers.
> > > > +Name is taken from the device name field.
> > > > +
> > > > +Driver IDs are simple <name>.
> > > > +
> > > > +Need to extract the name from the Virtual Device compare to name o=
f
> > > > +the driver.
> > >
> > > Why is this document even needed?
> > >
> > > I understand the goal of documenting how to use this and such, but th=
e
> above
> > > document does none of that.  The last sentance here doesn't even make
> sense
> > > to me.
> > >
> > > How about tieing it into the kerneldoc functions that you have create=
d in
> the .c
> > > file, to create something that actually is useful?  As it is, the abo=
ve text
> doesn't
> > > describe anything to me that I could actually use, did it help someon=
e
> who
> > > wants to use this api that you know of?
> > [Kirsher, Jeffrey T]
> >
> > Thank you for the feedback, I will work with David to fix the documenta=
tion
> so
> > that it is useful to you.
>=20
> Try making it useful to the person having to actually use this (i.e.
> who ever needs to integrate the virtual bus code into their drivers) as
> that is the proper audience for this, right?
>=20
> greg k-h
