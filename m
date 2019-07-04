Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCF985F966
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 15:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727342AbfGDNxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 09:53:36 -0400
Received: from mail-eopbgr70085.outbound.protection.outlook.com ([40.107.7.85]:41302
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727232AbfGDNxf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 09:53:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ixcefz1xxDQz3FUtsw4JKoTZIzOw57ZF6do0PWrAzOE=;
 b=dDlahK03oZrkHvQSxj/i9F3W1ywsLfpFWN5L/5fHK3Um7g2KneYI3YWnOyzD6msDs6Irg10os9ZVtlSiQJuzfELiHnza+1xisMge2C93Wws3C+OsjjahYiX5ZcQJH0QCDY27qI+PHRKLVGjApSQhgoFBzVer1bqA43bRysf4jYw=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB6126.eurprd05.prod.outlook.com (20.178.205.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.18; Thu, 4 Jul 2019 13:53:30 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 13:53:30 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "poswald@suse.com" <poswald@suse.com>,
        "mustafa.ismail@intel.com" <mustafa.ismail@intel.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 1/3] ice: Initialize and register platform device to
 provide RDMA
Thread-Topic: [net-next 1/3] ice: Initialize and register platform device to
 provide RDMA
Thread-Index: AQHVMg3rTq5orI7nM0W8xdFRWAzlRqa6YIUAgAADtwCAAAIkgIAAAXuAgAABkQCAABAnAIAAAgUA
Date:   Thu, 4 Jul 2019 13:53:30 +0000
Message-ID: <20190704135326.GO3401@mellanox.com>
References: <20190704021252.15534-1-jeffrey.t.kirsher@intel.com>
 <20190704021252.15534-2-jeffrey.t.kirsher@intel.com>
 <20190704121632.GB3401@mellanox.com> <20190704122950.GA6007@kroah.com>
 <20190704123729.GF3401@mellanox.com> <20190704124247.GA6807@kroah.com>
 <20190704124824.GK3401@mellanox.com> <20190704134612.GB10963@kroah.com>
In-Reply-To: <20190704134612.GB10963@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BL0PR0102CA0031.prod.exchangelabs.com
 (2603:10b6:207:18::44) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31ba23d9-8bbe-4333-c372-08d70086ff30
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB6126;
x-ms-traffictypediagnostic: VI1PR05MB6126:
x-microsoft-antispam-prvs: <VI1PR05MB6126A2022E706B4F792C3F3FCFFA0@VI1PR05MB6126.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(346002)(39860400002)(376002)(189003)(199004)(229853002)(25786009)(66066001)(7416002)(8676002)(102836004)(33656002)(71200400001)(71190400001)(81166006)(8936002)(81156014)(14444005)(5024004)(305945005)(6436002)(86362001)(53936002)(256004)(14454004)(6116002)(3846002)(76176011)(7736002)(2906002)(54906003)(68736007)(478600001)(1076003)(316002)(26005)(6246003)(446003)(5660300002)(6512007)(66946007)(476003)(186003)(6486002)(2616005)(73956011)(52116002)(11346002)(66556008)(486006)(66476007)(64756008)(66446008)(36756003)(386003)(4326008)(6916009)(6506007)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6126;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HwzUJy0BnleITRK6bQVlw3pmh4T9XYWE5qTZ4vxqlQHLNhCHyAbwY4BR3Bh6qHqmFAK8OGjiA77NQM2oeLVx1V4DlVd8CfXQ505rakJ4S3QszqwpoASrvGqQLNOB1dZiBi91yObhoURgMjjUlWl3gDR44UacusyJTxwe7UEEWecQpdNGAXRkkebTfh0BLDthNlWhx9/AlYgd9pFDt2sE8yc5gLFUodc1ZOK4TDNhwA7IUGbQkmIEpTasTcA/7R+yW0KaIUT+TPRtMBgYI6/BibR8C1SdlXXUOTEefY79BtHKHZv6nIaomXtXab4kz/GCnvU71d/O2+Y2M0Mj/YSYh6dAYsBVLU6vGUNSPzUc8UJuzObr5+yC6MF+xqZnNIDuNKYYeAk+h1lc5F8MAdV51UWsAU1M7PfRckJON+dewCg=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <09F44F309599384583F51663347E2962@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31ba23d9-8bbe-4333-c372-08d70086ff30
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 13:53:30.8065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 03:46:12PM +0200, Greg KH wrote:
> On Thu, Jul 04, 2019 at 12:48:29PM +0000, Jason Gunthorpe wrote:
> > On Thu, Jul 04, 2019 at 02:42:47PM +0200, Greg KH wrote:
> > > On Thu, Jul 04, 2019 at 12:37:33PM +0000, Jason Gunthorpe wrote:
> > > > On Thu, Jul 04, 2019 at 02:29:50PM +0200, Greg KH wrote:
> > > > > On Thu, Jul 04, 2019 at 12:16:41PM +0000, Jason Gunthorpe wrote:
> > > > > > On Wed, Jul 03, 2019 at 07:12:50PM -0700, Jeff Kirsher wrote:
> > > > > > > From: Tony Nguyen <anthony.l.nguyen@intel.com>
> > > > > > >=20
> > > > > > > The RDMA block does not advertise on the PCI bus or any other=
 bus.
> > > > > > > Thus the ice driver needs to provide access to the RDMA hardw=
are block
> > > > > > > via a virtual bus; utilize the platform bus to provide this a=
ccess.
> > > > > > >=20
> > > > > > > This patch initializes the driver to support RDMA as well as =
creates
> > > > > > > and registers a platform device for the RDMA driver to regist=
er to. At
> > > > > > > this point the driver is fully initialized to register a plat=
form
> > > > > > > driver, however, can not yet register as the ops have not bee=
n
> > > > > > > implemented.
> > > > > >=20
> > > > > > I think you need Greg's ack on all this driver stuff - particul=
arly
> > > > > > that a platform_device is OK.
> > > > >=20
> > > > > A platform_device is almost NEVER ok.
> > > > >=20
> > > > > Don't abuse it, make a real device on a real bus.  If you don't h=
ave a
> > > > > real bus and just need to create a device to hang other things of=
f of,
> > > > > then use the virtual one, that's what it is there for.
> > > >=20
> > > > Ideally I'd like to see all the RDMA drivers that connect to ethern=
et
> > > > drivers use some similar scheme.
> > >=20
> > > Why?  They should be attached to a "real" device, why make any up?
> >=20
> > ? A "real" device, like struct pci_device, can only bind to one
> > driver. How can we bind it concurrently to net, rdma, scsi, etc?
>=20
> MFD was designed for this very problem.
>=20
> > > > This is for a PCI device that plugs into multiple subsystems in the
> > > > kernel, ie it has net driver functionality, rdma functionality, som=
e
> > > > even have SCSI functionality
> > >=20
> > > Sounds like a MFD device, why aren't you using that functionality
> > > instead?
> >=20
> > This was also my advice, but in another email Jeff says:
> >=20
> >   MFD architecture was also considered, and we selected the simpler
> >   platform model. Supporting a MFD architecture would require an
> >   additional MFD core driver, individual platform netdev, RDMA function
> >   drivers, and stripping a large portion of the netdev drivers into
> >   MFD core. The sub-devices registered by MFD core for function
> >   drivers are indeed platform devices. =20
>=20
> So, "mfd is too hard, let's abuse a platform device" is ok?
>=20
> People have been wanting to do MFD drivers for PCI devices for a long
> time, it's about time someone actually did the work for it, I bet it
> will not be all that complex if tiny embedded drivers can do it :)

Okay, sounds like a NAK to me. I'll drop these patches from the RDMA
patchworks and Jeff can work through the MFD stuff first.

Jason
