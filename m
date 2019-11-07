Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20F65F39D2
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 21:52:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727076AbfKGUwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 15:52:35 -0500
Received: from mail-eopbgr130052.outbound.protection.outlook.com ([40.107.13.52]:60546
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725828AbfKGUwf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 15:52:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dd+4zqFIsJ+6JGges9S9lWsZpSKs/di8/0wdMD/8ETXD0g586uI+d6FPC4rFy56uP3oqWOOQLXJKE1lhlt+vnM76J58/Aqre5CtAH0CWtnUN/uMEZ5rXtVUCuRpwIYIlpXAz+X+6lmDeBKVg16+OCmDZHQEARlS017CdSTklp6RzUvk3YYC6E1uQTzv2O/kHb2szOuFp6dyNduJScwN+G1NEXoEg0moXpMcx+TEzRzzOaSgINUwuHniMyc2xM4ZdWalkvex5QkzbY2yezM6c+sBh+VUwEaEh7Gs4Py85VzowSUaeN42d0sxMw6LyrmnN8qApa0USHz0rjgsuS594Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S2Sr56WRkvdvzwe6gTU9LptHwaa7D7XCjyUcQSRc0Gs=;
 b=g/0y1w/2h5u+ONMj45iRgM/AKsX5vO7UYMNE+s1U2LflKg6Re6I+DDBFuAQEfgxUQhzid4ymwJuc6qbz/ttR63n0Efm0D81k96QhlUKuqAVsLuVI3gJ2+F3Bp7CszsGsqypqpTbFz4P2OPI0C7z0I4Kf4HNb8Fam8bGNYCx9OiR5IZEtulqUtizf/ZCQo7R+aBFDJ2Rrl83JYO13sktK7SrEs9MYAvdqwkMNf/A44UY745EU3oQbNJ/vd5pbntX/uHn7pcZdCu4skDr+f2EuGmXZQ63fcTI1HboKecUkgd48RWbIqsy0ecoRRUDZQi2hLW4AWZ2YJ4U1am6G076ONg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S2Sr56WRkvdvzwe6gTU9LptHwaa7D7XCjyUcQSRc0Gs=;
 b=OmhXCYgVER63Kin7FJV3HU1Uo72oIs/L7H+YDCk5dLPFycJ8xsUXNkwyJ7mIoHhfoFa7nSQekjDwht5LoOGereA+2tjGI2nRrTl3FYoazcBVfkToMtKu3WbTeHco6GNHSQwbt3YTXfX41Zysqgi3qszCbUbrWJbjzojRHbLNMCY=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4625.eurprd05.prod.outlook.com (52.133.59.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Thu, 7 Nov 2019 20:52:29 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 20:52:29 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Or Gerlitz <gerlitz.or@gmail.com>
Subject: RE: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Thread-Topic: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
Thread-Index: AQHVlYUoVUzzBv4k4UmQHUerp08scaeAKe4AgAAC5uA=
Date:   Thu, 7 Nov 2019 20:52:29 +0000
Message-ID: <AM0PR05MB4866A2B92A64DDF345DB14F5D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107153234.0d735c1f@cakuba.netronome.com>
In-Reply-To: <20191107153234.0d735c1f@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8f77a231-010a-4ad7-a30a-08d763c46757
x-ms-traffictypediagnostic: AM0PR05MB4625:|AM0PR05MB4625:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB462531B7A36B69110041812BD1780@AM0PR05MB4625.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(136003)(39850400004)(376002)(189003)(199004)(13464003)(76116006)(86362001)(7696005)(99286004)(76176011)(305945005)(102836004)(71190400001)(55016002)(71200400001)(486006)(74316002)(7736002)(5660300002)(316002)(6506007)(53546011)(2906002)(33656002)(52536014)(66066001)(6116002)(186003)(54906003)(7416002)(229853002)(66556008)(26005)(446003)(4326008)(25786009)(6916009)(3846002)(256004)(6436002)(81166006)(9686003)(8676002)(66946007)(476003)(11346002)(6246003)(66476007)(8936002)(66446008)(64756008)(81156014)(14454004)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4625;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SThPQhkXjMwZKWFn399OtNp3Uj2JLU+pCoXTj4cinXzHQ6IuPln5i2UktyHeU3xHFPaaRVgHHWuTb9GtQ5C+McvgcN77Fikl1pDrx8pDxFEh79XgiUBDfSre9f+Vbl3ir34zlKKVJ7UA+P0cJt8f+UtEel3OJquS+aLMbwUMFoZhmcld6CfwUDmt/jviROEHCdvzYcoLhFgLXQ69m4jPKKJxfnE8xfxhB+B+ujJAa76U+YrJAiItW9VPaYwLMe+KNq+zrTzS4wCkND25peHkrfYbFQBKa6WI2o/+WzdHoFEaGf4JhH7+OuESQvBTqecODoZ9AYGYQ65x48Fig4gPfEeTCDzoZmAkz+ecXWUPB8LE8mRpJ3oFpn996OxMkzvURfUxHSXvZ04j6+IpDtwozeH4uGNPBd5bON+X0e/I0zJojvqWAl35lsn+h6d5ki5d
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f77a231-010a-4ad7-a30a-08d763c46757
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 20:52:29.3841
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: utv8xU2HIf2h/oclo96JzSGgubr7WRftuj77MA+mmWxxzBWtfOimBaGTSDXiIC66mvGh5tDqmGWDMvnjDHdc0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4625
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Thursday, November 7, 2019 2:33 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; davem@davemloft.net;
> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org;
> cohuck@redhat.com; Jiri Pirko <jiri@mellanox.com>; linux-
> rdma@vger.kernel.org; Or Gerlitz <gerlitz.or@gmail.com>
> Subject: Re: [PATCH net-next 00/19] Mellanox, mlx5 sub function support
>=20
> On Thu,  7 Nov 2019 10:04:48 -0600, Parav Pandit wrote:
> > Mellanox sub function capability allows users to create several
> > hundreds of networking and/or rdma devices without depending on PCI SR-
> IOV support.
>=20
> You call the new port type "sub function" but the devlink port flavour is=
 mdev.
>=20
Sub function is the internal driver structure. The abstract entity at user =
and stack level is mdev.
Hence the port flavour is mdev.
=20
> As I'm sure you remember you nacked my patches exposing NFP's PCI sub
> functions which are just regions of the BAR without any mdev capability. =
Am I
> in the clear to repost those now? Jiri?
>=20
For sure I didn't nack it. :-)
What I remember discussing offline/mailing list is=20
(a) exposing mdev/sub fuctions as devlink sub ports is not so good abstract=
ion
(b) user creating/deleting eswitch sub ports would be hard to fit in the wh=
ole usage model

> > Overview:
> > ---------
> > Mellanox ConnectX sub functions are exposed to user as a mediated
> > device (mdev) [2] as discussed in RFC [3] and further during
> > netdevconf0x13 at [4].
> >
> > mlx5 mediated device (mdev) enables users to create multiple
> > netdevices and/or RDMA devices from single PCI function.
> >
> > Each mdev maps to a mlx5 sub function.
> > mlx5 sub function is similar to PCI VF. However it doesn't have its
> > own PCI function and MSI-X vectors.
> >
> > mlx5 mdevs share common PCI resources such as PCI BAR region, MSI-X
> > interrupts.
> >
> > Each mdev has its own window in the PCI BAR region, which is
> > accessible only to that mdev and applications using it.
> >
> > Each mlx5 sub function has its own resource namespace for RDMA resource=
s.
> >
> > mdevs are supported when eswitch mode of the devlink instance is in
> > switchdev mode described in devlink documentation [5].
>=20
> So presumably the mdevs don't spawn their own devlink instance today, but
> once mapped via VIRTIO to a VM they will create one?
>=20
mdev doesn't spawn the devlink instance today when mdev is created by user,=
 like PCI.
When PCI bus driver enumerates and creates PCI device, there isn't a devlin=
k instance for it.

But, mdev's devlink instance is created when mlx5_core driver binds to the =
mdev device.
(again similar to PCI, when mlx5_core driver binds to PCI, its devlink inst=
ance is created ).

I should have put the example in patch-15 which creates/deletes devlink ins=
tance of mdev.
I will revise the commit log of patch-15 to include that.
Good point.

> It could be useful to specify.
>=20
Yes, its certainly useful. I missed to put the example in commit log of pat=
ch-15.

> > Network side:
> > - By default the netdevice and the rdma device of mlx5 mdev cannot
> > send or receive any packets over the network or to any other mlx5 mdev.
>=20
> Does this mean the frames don't fall back to the repr by default?
Probably I wasn't clear.
What I wanted to say is, that frames transmitted by mdev's netdevice and rd=
ma devices don't go to network.
These frames goes to representor device.
User must configure representor to send/receive/steer traffic to mdev.
