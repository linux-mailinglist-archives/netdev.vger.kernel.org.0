Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E15D1B19DA
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 00:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgDTW7V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 18:59:21 -0400
Received: from mga07.intel.com ([134.134.136.100]:54192 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbgDTW7V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 18:59:21 -0400
IronPort-SDR: ggxPzyaOXpFqe/KGeQ1lWUh0tdA3aHLnkWn2RsjNu5ssz+XXdfxnP5zEs0bQ0kyYiZL5356N0N
 smW9kPmhkn6g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 15:59:16 -0700
IronPort-SDR: tg/D3HZ9ZJVY2cUM1T7GAFTeIEgLqTF1OxABb4KvVbN5BwP30ZE/dCyOdz8DM/LlUD8y4xh/Jb
 rodIsHBrmN9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,408,1580803200"; 
   d="scan'208";a="365156650"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga001.fm.intel.com with ESMTP; 20 Apr 2020 15:59:16 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 20 Apr 2020 15:59:15 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 20 Apr 2020 15:59:15 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 20 Apr 2020 15:59:15 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 20 Apr 2020 15:59:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2MxifQUbxB1XZzJ9WxxSndx4h8TWWwZSTO+Nkp/7T5cB6zCSkwYxU+8ObRuLZUjzXRD6i7GaE6H8TsUVxf1WSmTOgS4lWvU2AmkbQLswJRI8dI6mbHUZYnZKQEomsROMHrCEfjWsmlruprt7EGG2DdLP9YiGI8bcUU4d6/OTB+unrKubz/emU4KJ4Jdx3flvQk7dj0p4NvdGjQ92UqE4YcepAp4Fx99l72QbYsiwLSMbH4V1g46vfEjccuzlvlBuhHb5cd6M13zwUELe1XI7ZVBCYUaCBajjMBJtoOMD9gdw1gdiQj7zIyMPgwQrHoWbFAU47u9iB29Slrlqnoj7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+50+J+0iRPOezNEBpRDYjz8dRY/HbKwUSFswbrB+29U=;
 b=B9zoLoTqwFdToNWoz8BjCuzvVhX2+ACApM+Pqfn3TtQBpWiXQR1OvYNhQZauAKtNLkn3dXEKdA33cCJ7TOqhFTQgd9Byj3/O1sPPyjlYmltu8tfYJ3/U7Sg2Ow4IqLhi1reZL8aYs2N6Jxs8X4PRnx4HZpJa+euofYbvqHxqYgbW9dNnNeUUbQoPZ+JnXZgc9h2S0x+wPbJSs5vOZ9HGfwy6y/jMC60dYZWgt764WJYMatkJ6e2AoezLV2WMArkPajUDegeXap7s+KPMOBg+JrotHNbR5ZuzQI3sCUgsJl67rxyPnbYoDdNbxDVzD8HzSoBI61oTaH/QCt0nPVcBXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+50+J+0iRPOezNEBpRDYjz8dRY/HbKwUSFswbrB+29U=;
 b=MTVFWBwOgp8OQ4ccVUghoz9AHMlHAW7NerylmdH7iQvpVUCHEqn8dMSYqrK/2H7chWogdedygAs+LNrKvSaqjVh5WPFzg7LAVOIDGOgW6FjFVmUkJlt1Sdf4K+mbF85Ei3lO8986b03/8aLbNyUymYFktK+XZMx5pfT7Ss0c5v4=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) by
 DM6PR11MB4380.namprd11.prod.outlook.com (2603:10b6:5:14e::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2921.29; Mon, 20 Apr 2020 22:59:12 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::7069:6745:3ad1:bcde]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::7069:6745:3ad1:bcde%6]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 22:59:12 +0000
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
Subject: RE: [net-next 1/9] Implementation of Virtual Bus
Thread-Topic: [net-next 1/9] Implementation of Virtual Bus
Thread-Index: AQHWFNtEAfnineIPqEqJBqKNZCsJ6ah+1kSAgAOAGyA=
Date:   Mon, 20 Apr 2020 22:59:12 +0000
Message-ID: <DM6PR11MB28418BEB2385E7E2929C2FF6DDD40@DM6PR11MB2841.namprd11.prod.outlook.com>
References: <20200417171034.1533253-1-jeffrey.t.kirsher@intel.com>
 <20200417171034.1533253-2-jeffrey.t.kirsher@intel.com>
 <20200418125051.GA3473692@kroah.com>
In-Reply-To: <20200418125051.GA3473692@kroah.com>
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
x-ms-office365-filtering-correlation-id: a2795c73-5475-423d-9314-08d7e57e715b
x-ms-traffictypediagnostic: DM6PR11MB4380:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB43804D7009B7BDCD8DA69E83DDD40@DM6PR11MB4380.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 03793408BA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2841.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(366004)(39860400002)(136003)(376002)(396003)(346002)(53546011)(6506007)(86362001)(33656002)(71200400001)(7696005)(81156014)(9686003)(55016002)(4326008)(7416002)(8676002)(8936002)(5660300002)(6636002)(316002)(110136005)(52536014)(2906002)(186003)(64756008)(478600001)(54906003)(66476007)(66446008)(76116006)(26005)(66946007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4UV6BBPc9zBRmcMDe8svw+jvzjJNOy6pQV4Ve4JDZ5+jT4yuV42cpb/2F4vooaF81yDamUdu+CkJ0VHzZ8klIcOLoKiYQWX5jEQZmzuuZ6IgI2AC9lXCrDysYMFtV62wNNzAXr4fJkDn2GuRVWd80Obi10NFNb6rUZxKBSJEmjgdRvWH5sZHhOVgBUHAaRwMXWl+DIq45KrCiFSxkFe3QszZ8biz6M1s8Zx8UybCDkBGeeQOvAzTv4oopnO78V26MJqtfTe7F5Yrzt5j+7LJH9KX4lMnj6eC6EnORBJCXt9VKvIN9yxcY/34IO0YYmtFtska6/mhSKh2LWythldojQt7VaPxe6R3HBtC/gAZZcmUY39m/0x0hZDaVlP80yb95803TrVUnhfjHD08svS/t0rkMerLe0aaoWaKF+muHwVB0fNpl/D3CG20xw5r1e2I
x-ms-exchange-antispam-messagedata: 7FBvoIBj+BptNmlpHtWpQNgVPIilDXXw5Y5SVB9vUxP5jzxb4LiHPVn9bDNSfIVwDk2hrM7qRlzFlYIXswDVRSd2y7xW/ft1OK3K+jjzwUOXyxBC9HJcYrKXjjsniO801jUsx9e4S9yqaoQ/O+mMJQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a2795c73-5475-423d-9314-08d7e57e715b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2020 22:59:12.5242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rocl3nxH0NqTWofgSuS+YZKcNgwFmlnqFNNnpy12z5Uz1XXUSO8PyQazOSNm8OLgxOcYg3VOUOmZVgcYHH0IFOZDKUuUdBsSJbQr8bNodps=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4380
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Saturday, April 18, 2020 5:51 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: davem@davemloft.net; Ertman, David M <david.m.ertman@intel.com>;
> netdev@vger.kernel.org; linux-rdma@vger.kernel.org; nhorman@redhat.com;
> sassmann@redhat.com; jgg@ziepe.ca; parav@mellanox.com;
> galpress@amazon.com; selvin.xavier@broadcom.com;
> sriharsha.basavapatna@broadcom.com; benve@cisco.com;
> bharat@chelsio.com; xavier.huwei@huawei.com; yishaih@mellanox.com;
> leonro@mellanox.com; mkalderon@marvell.com; aditr@vmware.com;
> ranjani.sridharan@linux.intel.com; pierre-louis.bossart@linux.intel.com; =
Patil,
> Kiran <kiran.patil@intel.com>; Bowers, AndrewX <andrewx.bowers@intel.com>
> Subject: Re: [net-next 1/9] Implementation of Virtual Bus
>=20
> On Fri, Apr 17, 2020 at 10:10:26AM -0700, Jeff Kirsher wrote:
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
>=20
> struct device already has a name, why do you need another one?

The name in dev is the base name appended with the id to make sure each dev=
ice
has unique name.  The name in vdev is the abbreviated one (without the id) =
which
will be used in the matching function, so that a driver can claim to suppor=
t
<name> and will be matched with all <name>.<id> devices for all id's.

This is similar logic to platform_device's name field.

>=20
> > +	void (*release)(struct virtbus_device *);
>=20
> A bus should have the release function, not the actual device itself.  A
> device should not need function pointers.
>=20

The bus does have a release function, but it is a wrapper to call the relea=
se defined by
the device.  This is where the KO registering the virtbus_device is expecte=
d to clean up
the resources allocated for this device (e.g. free memory, etc).  Having th=
e virtual_bus_release
call a release callback in the virtual_device allows for extra cleanup from=
 the originating KO
if necessary.

The memory model of virtual bus is for the originating KO to manage the lif=
espan of the
memory for the virtual_device.  The virtual_bus expects the KO defining the=
 virtbus_device
have the memory allocated before registering a virtbus_device and to clean =
up that memory
when the release is called.

The platform_device also has function pointers in it, by including a MFD ob=
ject, but the
platform_bus is managing the memory for the platform_bus_object that contai=
ns the
platform_device which it why it using a generic kref_put to free memory.

> > +	int id;
>=20
> Shouldn't that be a specific type, like u64 or something?

Changed to be a u32 to match struct device.id.

>=20
> thanks,
>=20
> greg k-h

-DaveE
