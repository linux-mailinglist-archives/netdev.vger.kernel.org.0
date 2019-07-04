Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65C235F84B
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727723AbfGDMhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:37:36 -0400
Received: from mail-eopbgr140079.outbound.protection.outlook.com ([40.107.14.79]:24622
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727632AbfGDMhg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 08:37:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mb0G0kYWIjDFLIa52A1USNtVHtoYh7p6DHJE8NesGSk=;
 b=DdauWu4LnWxxDgNXuUmg1BgVlx5iD5PxxBuJgNHgbZJ4xz++dduYZfR5IXIlMOcyQrRbdcOCJ7BFOVGHE446sKxAihFeYq2s0ocrL8h6LERGqZfyfhqNcWgCHKw9D+55HqUbDChEOFL0/9N8t9O1v6e02mL4Ozeigo7AsVb5Tk0=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB4127.eurprd05.prod.outlook.com (10.171.182.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 12:37:33 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 12:37:33 +0000
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
Thread-Index: AQHVMg3rTq5orI7nM0W8xdFRWAzlRqa6YIUAgAADtwCAAAIkgA==
Date:   Thu, 4 Jul 2019 12:37:33 +0000
Message-ID: <20190704123729.GF3401@mellanox.com>
References: <20190704021252.15534-1-jeffrey.t.kirsher@intel.com>
 <20190704021252.15534-2-jeffrey.t.kirsher@intel.com>
 <20190704121632.GB3401@mellanox.com> <20190704122950.GA6007@kroah.com>
In-Reply-To: <20190704122950.GA6007@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MN2PR10CA0011.namprd10.prod.outlook.com
 (2603:10b6:208:120::24) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b3d41838-0718-4b97-cd6d-08d7007c62e8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB4127;
x-ms-traffictypediagnostic: VI1PR05MB4127:
x-microsoft-antispam-prvs: <VI1PR05MB4127F23B478A8C37A3B82410CFFA0@VI1PR05MB4127.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(376002)(396003)(136003)(189003)(199004)(446003)(7736002)(305945005)(478600001)(11346002)(5660300002)(66476007)(66556008)(64756008)(66446008)(86362001)(66946007)(486006)(476003)(8936002)(66066001)(81166006)(81156014)(8676002)(2616005)(52116002)(99286004)(76176011)(6116002)(3846002)(73956011)(54906003)(6246003)(33656002)(6916009)(6486002)(229853002)(1076003)(71200400001)(71190400001)(6512007)(316002)(14454004)(7416002)(4326008)(25786009)(6506007)(2906002)(102836004)(386003)(26005)(36756003)(6436002)(53936002)(68736007)(256004)(14444005)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4127;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jpgutqyNeQHwhXZsfmdvFWa9SngH9MpWsGfQNfYXlsySVph8hbEOav2xZ3L/vrpS1k18jNiKtetfVttyGIbjwmyhwPKwKbJYjGZGM3GWQZqQSWwjxhhqxFI+/80MTopyxrJPVF6kSuzUC9dOSPa86JTrtBowbyPlcodmXGePZFwFq4yEP7Z9XvtwB5+Z7sOk3u8+cBDyz+t+yuZhMPgB/RqLfFe1ah0m57DKvAEz+TJj3eMEjYJPouY/t+3CW4ghBjyTDtcBXABfFpq3c6s3yLemKRNQi9fYG/BDZg6S9aGz33m+kFoWiyI0OpjU3jwIsMCf3GAK06AwEyKiQK7TJTelWcxgzxUcOC4ugjpn3nGc33350xNo8uwEgWs1IUC2JJSjpr4yuoAFjad4WyQW/+53tdz/ADbKZ9tkt4j90gw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <09E1FD57259BC54B92285BA15701C14E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3d41838-0718-4b97-cd6d-08d7007c62e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 12:37:33.4281
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4127
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 02:29:50PM +0200, Greg KH wrote:
> On Thu, Jul 04, 2019 at 12:16:41PM +0000, Jason Gunthorpe wrote:
> > On Wed, Jul 03, 2019 at 07:12:50PM -0700, Jeff Kirsher wrote:
> > > From: Tony Nguyen <anthony.l.nguyen@intel.com>
> > >=20
> > > The RDMA block does not advertise on the PCI bus or any other bus.
> > > Thus the ice driver needs to provide access to the RDMA hardware bloc=
k
> > > via a virtual bus; utilize the platform bus to provide this access.
> > >=20
> > > This patch initializes the driver to support RDMA as well as creates
> > > and registers a platform device for the RDMA driver to register to. A=
t
> > > this point the driver is fully initialized to register a platform
> > > driver, however, can not yet register as the ops have not been
> > > implemented.
> >=20
> > I think you need Greg's ack on all this driver stuff - particularly
> > that a platform_device is OK.
>=20
> A platform_device is almost NEVER ok.
>=20
> Don't abuse it, make a real device on a real bus.  If you don't have a
> real bus and just need to create a device to hang other things off of,
> then use the virtual one, that's what it is there for.

Ideally I'd like to see all the RDMA drivers that connect to ethernet
drivers use some similar scheme.

Should it be some generic virtual bus?

This is for a PCI device that plugs into multiple subsystems in the
kernel, ie it has net driver functionality, rdma functionality, some
even have SCSI functionality

Jason
