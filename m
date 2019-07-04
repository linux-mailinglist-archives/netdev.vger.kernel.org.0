Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCA685F881
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 14:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfGDMsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 08:48:35 -0400
Received: from mail-eopbgr150077.outbound.protection.outlook.com ([40.107.15.77]:36321
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725860AbfGDMse (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 08:48:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wKVsSh/ioKCEKfVbGj0GA+njNMkiIhdnH52ttaD0lfc=;
 b=Dw+uuMkeLzTGWEJdBmA8zeUuYTQdpMK0auTgWrhCSviqagZm2NdTMorAbb4SgyKk47TNbyQhv/hPPCGb/yhNq3XreEuldbcA+9/RCuIkxJJ27OgildFKx+BFQgvtx8iE7f1gqmdEbQNevnnBtENKkSBAoRwwNZquiMQ9EiSWAvY=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB4334.eurprd05.prod.outlook.com (52.133.12.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Thu, 4 Jul 2019 12:48:30 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::f5d8:df9:731:682e%5]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 12:48:30 +0000
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
Thread-Index: AQHVMg3rTq5orI7nM0W8xdFRWAzlRqa6YIUAgAADtwCAAAIkgIAAAXuAgAABkQA=
Date:   Thu, 4 Jul 2019 12:48:29 +0000
Message-ID: <20190704124824.GK3401@mellanox.com>
References: <20190704021252.15534-1-jeffrey.t.kirsher@intel.com>
 <20190704021252.15534-2-jeffrey.t.kirsher@intel.com>
 <20190704121632.GB3401@mellanox.com> <20190704122950.GA6007@kroah.com>
 <20190704123729.GF3401@mellanox.com> <20190704124247.GA6807@kroah.com>
In-Reply-To: <20190704124247.GA6807@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: YTXPR0101CA0023.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00::36) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.55.100]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0b8f71f9-bf79-4ea9-2597-08d7007dea1c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB4334;
x-ms-traffictypediagnostic: VI1PR05MB4334:
x-microsoft-antispam-prvs: <VI1PR05MB43340F2BE2C7B77CFA8ABDD1CFFA0@VI1PR05MB4334.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(39860400002)(376002)(136003)(366004)(189003)(199004)(229853002)(8936002)(25786009)(4326008)(81166006)(86362001)(102836004)(8676002)(7416002)(71200400001)(71190400001)(6916009)(14444005)(5024004)(68736007)(256004)(186003)(81156014)(3846002)(6116002)(26005)(53936002)(386003)(6506007)(486006)(6512007)(305945005)(76176011)(1076003)(52116002)(99286004)(33656002)(2906002)(5660300002)(6246003)(316002)(478600001)(6486002)(73956011)(66946007)(66476007)(66066001)(66556008)(6436002)(64756008)(66446008)(36756003)(54906003)(11346002)(476003)(446003)(7736002)(2616005)(14454004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4334;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EabCW9iJnWD6yhKRMzrWtYnMwFhwsf9d9NJCbj7oguGZ4hPPFFT8gf6+JD+om2IwEHN9MPBVWeFhUwLVVXm+mpe2aFEgrJ2YgL8HK00H2siZbEX0Mh2EwOC+SV6JWFRHPCPWHBpfww5pWENcKMVuTyfiSLmxGd7U6fc2qREJg+RujylZZTlDRr2rA3ZU0em1c1eRW0QI9mVamZh71wxO4DR8cfOiNL84bic0cnx2+OZhyQBiXpV/eFAEtQxlsZwnKc4H4+XDc5/Zxe+6uZFxsTCGMzrShWInpFoMP/Qk86hJnOzidEuELKriEO7z9ZsqQosUakruWQbsDGRt9tpSL5dyVVtxM/8q4ewQnpcX4yr4vTEzFw00IG/tpKCvHtnEp1hUtBlXm+u1Gtn790j24CdXueKhRDw44JU9mBzwIPM=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15DEAA8CD749CB4FA34379B58B0EC986@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b8f71f9-bf79-4ea9-2597-08d7007dea1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 12:48:30.0856
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jgg@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4334
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 02:42:47PM +0200, Greg KH wrote:
> On Thu, Jul 04, 2019 at 12:37:33PM +0000, Jason Gunthorpe wrote:
> > On Thu, Jul 04, 2019 at 02:29:50PM +0200, Greg KH wrote:
> > > On Thu, Jul 04, 2019 at 12:16:41PM +0000, Jason Gunthorpe wrote:
> > > > On Wed, Jul 03, 2019 at 07:12:50PM -0700, Jeff Kirsher wrote:
> > > > > From: Tony Nguyen <anthony.l.nguyen@intel.com>
> > > > >=20
> > > > > The RDMA block does not advertise on the PCI bus or any other bus=
.
> > > > > Thus the ice driver needs to provide access to the RDMA hardware =
block
> > > > > via a virtual bus; utilize the platform bus to provide this acces=
s.
> > > > >=20
> > > > > This patch initializes the driver to support RDMA as well as crea=
tes
> > > > > and registers a platform device for the RDMA driver to register t=
o. At
> > > > > this point the driver is fully initialized to register a platform
> > > > > driver, however, can not yet register as the ops have not been
> > > > > implemented.
> > > >=20
> > > > I think you need Greg's ack on all this driver stuff - particularly
> > > > that a platform_device is OK.
> > >=20
> > > A platform_device is almost NEVER ok.
> > >=20
> > > Don't abuse it, make a real device on a real bus.  If you don't have =
a
> > > real bus and just need to create a device to hang other things off of=
,
> > > then use the virtual one, that's what it is there for.
> >=20
> > Ideally I'd like to see all the RDMA drivers that connect to ethernet
> > drivers use some similar scheme.
>=20
> Why?  They should be attached to a "real" device, why make any up?

? A "real" device, like struct pci_device, can only bind to one
driver. How can we bind it concurrently to net, rdma, scsi, etc?

> > This is for a PCI device that plugs into multiple subsystems in the
> > kernel, ie it has net driver functionality, rdma functionality, some
> > even have SCSI functionality
>=20
> Sounds like a MFD device, why aren't you using that functionality
> instead?

This was also my advice, but in another email Jeff says:

  MFD architecture was also considered, and we selected the simpler
  platform model. Supporting a MFD architecture would require an
  additional MFD core driver, individual platform netdev, RDMA function
  drivers, and stripping a large portion of the netdev drivers into
  MFD core. The sub-devices registered by MFD core for function
  drivers are indeed platform devices. =20

Thanks,
Jason
