Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB77E1666B0
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 19:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbgBTSze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 13:55:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:13322 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728315AbgBTSzd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 13:55:33 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 10:55:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,465,1574150400"; 
   d="scan'208";a="259370585"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by fmsmga004.fm.intel.com with ESMTP; 20 Feb 2020 10:55:31 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 20 Feb 2020 10:55:32 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 20 Feb 2020 10:55:31 -0800
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 20 Feb 2020 10:55:31 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 20 Feb 2020 10:55:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M4h/XO1qLdcXmKFRFLRbuTkhl1nHLIm8T+SHI/CO1yMQ4em9P7hOURaNyCZZj4M9UAjoXHuhm8fS5EIEj84Z3ZH5+66gB9HeSR3YGC1XKY72MqKr+5H0scL722t8SEsWKQvUM04oxQkBaEHkNvFiB9/48I3y4HvtbaLtj7EdmpYpgV2TJ+4pIYg99NCUkC8BodTk8/HaK5uutQvzQrYOnIkv5M5a+pg8hK8QnfVxrPhhLCoNqM9PjgHYKdFv8RHaYxdVJydINCHYAdN59YOFeAl/sx8lGVzklt63xZPSYqxLr936GI7igjfierLPTe+30A+mkTKujAoA/Rwht1o1Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TgfqOz52FM+Vn2K4a+57HTjuQuSBWTAUOovC4F4rdT8=;
 b=UW9VFXeS79vPAQBaZYVIqzezeEbXC55s1AfWuCAyXsSzYMPfTa0NB6OhnvCiMY3uH9iqnc784Dr3v/5fvtze+vkAfzt0AqWP+R+M5GES6o1FERN8fhpNsII1HWRaPBk9bxqh9rMqY6AjMw/Db/gQaEHFiTu1Ur+/fzJhk98uiMyBxq2UMoEI/xC5O6AJgU3PO0pldzI7OFoT/+Uel3PXFRoC6W8tVTa22iClxuZ5hzB10cb3JUcU8MQHhgGnc0tU01hQVcN68jvdLBkhhMQd0xCw1KEAoX/ECVROks9TtLskinToEwcQqShxDXafLXBV7kwOn8pAV4zzQ576E/LAMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TgfqOz52FM+Vn2K4a+57HTjuQuSBWTAUOovC4F4rdT8=;
 b=jR8xJ9/PW19ciiEvL/VX4qJaq55JORBLkrn0ClAy4/BS0H/eHmCROkSfs27mGggy005dgJCTw0IZwC+rM0Zlr5rBgBWbuMKiePS0cqKP7oUS8ulXrtc9UHbTIQZ5bdjxndeBNJ2UJM+4HE13oBTENw+D57E8d4Cm2y8I7aTftnQ=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (20.176.100.32) by
 DM6PR11MB3033.namprd11.prod.outlook.com (20.177.218.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.23; Thu, 20 Feb 2020 18:55:28 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::f01a:b54b:1bc2:5a80]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::f01a:b54b:1bc2:5a80%2]) with mapi id 15.20.2750.016; Thu, 20 Feb 2020
 18:55:28 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgg@ziepe.ca>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
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
        "Patil, Kiran" <kiran.patil@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: RE: [RFC PATCH v4 01/25] virtual-bus: Implementation of Virtual Bus
Thread-Topic: [RFC PATCH v4 01/25] virtual-bus: Implementation of Virtual Bus
Thread-Index: AQHV4di3ExrbLjUlh0qs0H324/35rqga7W8AgAA7ToCAAALRAIAJTjgg
Date:   Thu, 20 Feb 2020 18:55:28 +0000
Message-ID: <DM6PR11MB2841DDF7EEA187B368FFDE53DD130@DM6PR11MB2841.namprd11.prod.outlook.com>
References: <20200212191424.1715577-1-jeffrey.t.kirsher@intel.com>
 <20200212191424.1715577-2-jeffrey.t.kirsher@intel.com>
 <20200214170240.GA4034785@kroah.com> <20200214203455.GX31668@ziepe.ca>
 <20200214204500.GC4086224@kroah.com>
In-Reply-To: <20200214204500.GC4086224@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiODgwZjY2ZDYtYmE1ZS00ZTNhLWE2YjAtYmNlNDZmMjc5ZDkxIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiZkYrY1hhNUo5Qm9vdUlcLzZVNG85MHdobXlNaHpITEtIRjRtY2ZyYU5jcmdJalZrVFlRbmJmS2N3RzRSc0tVQ3EifQ==
x-ctpclassification: CTP_NT
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=david.m.ertman@intel.com; 
x-originating-ip: [134.134.136.217]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e1616b0-badd-4087-9340-08d7b63673f7
x-ms-traffictypediagnostic: DM6PR11MB3033:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB303315BD7353419A5B24E059DD130@DM6PR11MB3033.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 031996B7EF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(366004)(376002)(39860400002)(136003)(199004)(189003)(8936002)(71200400001)(53546011)(7696005)(6506007)(8676002)(81156014)(81166006)(66476007)(66556008)(66946007)(66446008)(316002)(186003)(64756008)(26005)(2906002)(76116006)(54906003)(86362001)(55016002)(9686003)(110136005)(33656002)(478600001)(107886003)(52536014)(5660300002)(4326008)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR11MB3033;H:DM6PR11MB2841.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UMXbQH4+9QwEyuA3fNJyO6ho5zkeuWpgJEByycCKMZdGQOWMxkexMZ5+Y94uEAYhpKkYAfz3XOmsuiYoOvoRj1URaoofdmFYIB9qcKE/tKIpkGlbNDlq/bCvydJ3fMTXGiAlExTHCXSeZeLwGHLu/dlTNRc/rAZDhXXUHQbAyQFLrseDHXb/FQgUKhn7ELpTdwetCGbBH0BPTKpa4LqIUOclB8OdFi/jAvvDHeGzHD9b1tUGSxI+5qHeytWcJ+qRg1SEornIwwP1HrisL59TbbDWvwoyLpH6GjwQoU1kcfmwxb6kTgcU0bAIZaL8EXPZVwQDfG/fmN5YKedsrC2OWULpxF6dGlfbQ4z5UrcMPeTQIL6+h1Ncx0gPJw5h29LPEGpHM2GmQd9v/1/U1AYq2b6QeO5o3SsaojVnmIIiyHgv0JTJWrb10mHgsTVPZMOt
x-ms-exchange-antispam-messagedata: 8KRoGZwzlr/6fu/Td/N7h4NHPCKAyUTvgAckIXL1qprATTfI6w+Mr9ESgl5bxKvEruXQLkWp6OWZI87sy3w7A4EN+1JOZyP9nz4CRW3oLahDCoP8dP+S8djLFfzYOuZmLiYPKrisfP4dvwl4RbPzFQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e1616b0-badd-4087-9340-08d7b63673f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2020 18:55:28.4519
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Iph3wI+pfMhlKZDYAVrodwup5MExwfEhS+25ttSpABfXK+QQC1hHGgGtoluE6WA0e8NaXN3hFgEbf2H7cUxDY6p2oUB52gn9H6NT7huXtIg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3033
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Friday, February 14, 2020 12:45 PM
> To: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net=
;
> Ertman, David M <david.m.ertman@intel.com>; netdev@vger.kernel.org;
> linux-rdma@vger.kernel.org; nhorman@redhat.com;
> sassmann@redhat.com; parav@mellanox.com; galpress@amazon.com;
> selvin.xavier@broadcom.com; sriharsha.basavapatna@broadcom.com;
> benve@cisco.com; bharat@chelsio.com; xavier.huwei@huawei.com;
> yishaih@mellanox.com; leonro@mellanox.com; mkalderon@marvell.com;
> aditr@vmware.com; Patil, Kiran <kiran.patil@intel.com>; Bowers, AndrewX
> <andrewx.bowers@intel.com>
> Subject: Re: [RFC PATCH v4 01/25] virtual-bus: Implementation of Virtual =
Bus
>=20
> On Fri, Feb 14, 2020 at 04:34:55PM -0400, Jason Gunthorpe wrote:
> > On Fri, Feb 14, 2020 at 09:02:40AM -0800, Greg KH wrote:
> > > > +	put_device(&vdev->dev);
> > > > +	ida_simple_remove(&virtbus_dev_ida, vdev->id);
> > >
> > > You need to do this before put_device().
> >
> > Shouldn't it be in the release function? The ida index should not be
> > re-used until the kref goes to zero..

The IDA should not be reused until the virtbus_device is unregistered.  We
don't want another device with the same name and same IDA to be registered,
so the IDA has to remain unique until the device is unregistered, that is w=
hy
I am moving it to before put_device, but remember, this index is just to
ensure unique naming among the devices registered on the bus.  There could
(and will) be several foo_rdma devices created (one per PF) and we need to =
keep
them all straight.

>=20
> Doesn't really matter, once you have unregistered it, you can reuse it.
> But yes, putting it in release() is the safest thing to do.
>=20
> > > > +struct virtbus_device {
> > > > +	struct device dev;
> > > > +	const char *name;
> > > > +	void (*release)(struct virtbus_device *);
> > > > +	int id;
> > > > +	const struct virtbus_dev_id *matched_element;
> > > > +};
> > >
> > > Any reason you need to make "struct virtbus_device" a public structur=
e
> > > at all?
> >
> > The general point of this scheme is to do this in a public header:
> >
> > +struct iidc_virtbus_object {
> > +	struct virtbus_device vdev;
> > +	struct iidc_peer_dev *peer_dev;
> > +};
> >
> > And then this when the driver binds:
>=20
> Ah, yes, nevermind, I missed that.
>=20
> greg k-h


-DaveE
