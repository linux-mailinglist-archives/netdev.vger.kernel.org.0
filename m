Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B886D9E730
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 13:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbfH0L5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 07:57:13 -0400
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:8558
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726125AbfH0L5M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Aug 2019 07:57:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X226H1EmzwOU2VYf0brqokATnDDz1T/N6yAF0jM4GTCWULlTkBNVJTVUcnuPPUkB5stPuj1vdZG++KMb/rmG0ijRArp2wWhtSZ4BrvDKB3/Bbx2cGHPlvr4ThswtGhyepkXdYGTfq+k6mu4cT0oncl0sPP8KiUQgeLPXnSRT+9WcB5A/322n35soy1wR/xHJWPMT2NpOYzvWU0fiNCz2oJXTmQO7cXOZV3cGfDTD+758ieksql2D/RLrHTuOTsiS6ARmUE+g2weV9cJhho/gTQSkSk+hacj/88G5tK8/9U5HOUXWALdZyMmTpqZ1NKnVRd2+9IqfuJg25g1AYfB4MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Am3eOYEpecD7JgJchfAjklMKq5yWPGC3j+R94KswuX0=;
 b=PEduOyCZAUuCvqTaYgzXYOYPnDeXL5oIMaXdY3RA/kWKkdT+3/MO3Yke41guOThwwX/odEyc6dEoTbgIYlUxTbtPdFZPhwUAqtxT8zgcizoQdWBjUMIXlH5g9kkfxHqCNWawp11bxIjWIorsa0+1Y7xrUhgcwLAKqanCg8sh+ffSzTYo4D4aSZh2bthPazcOcWgahQMe9Xhh4l6LGknnLXY/XJ9zPMl01VTlSSdqbsevp951338oyVNv9TION/94YK1UMHyb+uLUxNtHIo1xM+uMcDo8nqMWP6jd+LW+72CS23wBIAxK6lQ4Mbr6vv+sJpanjeDE504+y4T4qutYMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Am3eOYEpecD7JgJchfAjklMKq5yWPGC3j+R94KswuX0=;
 b=hxvFEJy8EyWVAOY6slR9cLtrdCrpU/mekZKGPqjC7r24ezAmFJlJKESBD7xCyjmWe3qx2uvZlApk3aQPICnkXQNGZtOwMwCwXvIoqFHTQFxAGiys/weIFipqcuyfJgQY9MNc7/BaPu5tOiK+tFayT8CwUI9Ax8SEuXbvKnc9EI4=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5731.eurprd05.prod.outlook.com (20.178.115.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Tue, 27 Aug 2019 11:57:07 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2199.020; Tue, 27 Aug 2019
 11:57:07 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 1/4] mdev: Introduce sha1 based mdev alias
Thread-Topic: [PATCH 1/4] mdev: Introduce sha1 based mdev alias
Thread-Index: AQHVXE6sjQlIhIUUgkClKEYpCVnoRKcOypkAgAAMheCAAAQiAIAAAZ8QgAADLACAAAMw8A==
Date:   Tue, 27 Aug 2019 11:57:07 +0000
Message-ID: <AM0PR05MB4866792BEAAB1958BB5A9C4AD1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190826204119.54386-1-parav@mellanox.com>
        <20190826204119.54386-2-parav@mellanox.com>
        <20190827122428.37442fe1.cohuck@redhat.com>
        <AM0PR05MB4866B68C9E60E42359BE1F4DD1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190827132404.483a74ad.cohuck@redhat.com>
        <AM0PR05MB4866CC932630ADD9BDA51371D1A00@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190827134114.01ddd049.cohuck@redhat.com>
In-Reply-To: <20190827134114.01ddd049.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.18.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52eb64af-9a5a-4814-409e-08d72ae5af58
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5731;
x-ms-traffictypediagnostic: AM0PR05MB5731:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5731D86AA067A4E95A5A86B6D1A00@AM0PR05MB5731.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0142F22657
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(366004)(396003)(346002)(376002)(13464003)(199004)(189003)(316002)(55236004)(11346002)(6246003)(76176011)(52536014)(25786009)(6506007)(4326008)(5660300002)(446003)(99286004)(33656002)(6436002)(6916009)(2906002)(9686003)(476003)(53936002)(14444005)(256004)(7696005)(9456002)(66066001)(478600001)(102836004)(186003)(229853002)(8676002)(81156014)(54906003)(81166006)(486006)(86362001)(71190400001)(76116006)(26005)(66446008)(64756008)(66556008)(66476007)(55016002)(6116002)(14454004)(3846002)(305945005)(7736002)(74316002)(66946007)(8936002)(71200400001)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5731;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: l9BK/E7kzpPiiXNFckhMAO2tTeMr8KxCx/EF+Hr4AGFuTrHZ0TgEAlKKVNj/+uTdBywuLdZBZVXPc7wrZtmnBMCpIqE5Z8EoxBFkDN97Ndm8PqGRi4kKXiRLaZbAZgvaQhPb55LvhmT4M70HTWSz/Z50h1XzrRefRD6cS5oNOTpN/2NyLaKKE+rdpg6qnx0trxOhbWHmlud94QQwRi2dIQ+F6AtLHuf3+bz8yC5Nbvzx9tj+jqfmTHg0d5VJClOwHEjaM9jgYxVEWPZ+so3daaMRh+ZvXrNNhWGx3GrL0HRbqiy96KLOVgaiaZ4suoGk2j63W3q/+PgC0k9+Pqg1sAUmWYGnva7G0OIMd6ctwpilUog4YeXbgvOACAx5Vz2cmrNIi/Mifc7fVzwh1bUANrgXIzkXXX1oAAMyl1wAUtw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52eb64af-9a5a-4814-409e-08d72ae5af58
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Aug 2019 11:57:07.2539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7P8Me26Opr3Gmq9/fPcpXJq9HS0W8EUTwZ6juAxuLXtmzi1lFyIj+NV0nA16dzA+QcDHZs1iPpscPAnqH/kNWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5731
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Tuesday, August 27, 2019 5:11 PM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: Re: [PATCH 1/4] mdev: Introduce sha1 based mdev alias
>=20
> On Tue, 27 Aug 2019 11:33:54 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Cornelia Huck <cohuck@redhat.com>
> > > Sent: Tuesday, August 27, 2019 4:54 PM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > > kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org;
> > > linux- kernel@vger.kernel.org; netdev@vger.kernel.org
> > > Subject: Re: [PATCH 1/4] mdev: Introduce sha1 based mdev alias
> > >
> > > On Tue, 27 Aug 2019 11:12:23 +0000
> > > Parav Pandit <parav@mellanox.com> wrote:
> > >
> > > > > -----Original Message-----
> > > > > From: Cornelia Huck <cohuck@redhat.com>
> > > > > Sent: Tuesday, August 27, 2019 3:54 PM
> > > > > To: Parav Pandit <parav@mellanox.com>
> > > > > Cc: alex.williamson@redhat.com; Jiri Pirko <jiri@mellanox.com>;
> > > > > kwankhede@nvidia.com; davem@davemloft.net; kvm@vger.kernel.org;
> > > > > linux- kernel@vger.kernel.org; netdev@vger.kernel.org
> > > > > Subject: Re: [PATCH 1/4] mdev: Introduce sha1 based mdev alias
> > > > >
>=20
> > > > > What about:
> > > > >
> > > > > * @get_alias_length: optional callback to specify length of the
> > > > > alias to
> > > create
> > > > > *                    Returns unsigned integer: length of the alia=
s to be created,
> > > > > *                                              0 to not create an=
 alias
> > > > >
> > > > Ack.
> > > >
> > > > > I also think it might be beneficial to add a device parameter
> > > > > here now (rather than later); that seems to be something that mak=
es
> sense.
> > > > >
> > > > Without showing the use, it shouldn't be added.
> > >
> > > It just feels like an omission: Why should the vendor driver only be
> > > able to return one value here, without knowing which device it is for=
?
> > > If a driver supports different devices, it may have different
> > > requirements for them.
> > >
> > Sure. Lets first have this requirement to add it.
> > I am against adding this length field itself without an actual vendor u=
se case,
> which is adding some complexity in code today.
> > But it was ok to have length field instead of bool.
> >
> > Lets not further add "no-requirement futuristic knobs" which hasn't sho=
wn its
> need yet.
> > When a vendor driver needs it, there is nothing prevents such addition.
>=20
> Frankly, I do not see how it adds complexity; the other callbacks have de=
vice
> arguments already,
Other ioctls such as create, remove, mmap, likely need to access the parent=
.
Hence it make sense to have parent pointer in there.

I am not against complexity, I am just saying, at present there is no use-c=
ase. Let have use case and we add it.

> and the vendor driver is free to ignore it if it does not have
> a use for it. I'd rather add the argument before a possible future user t=
ries
> weird hacks to allow multiple values, but I'll leave the decision to the
> maintainers.
Why would a possible future user tries a weird hack?
If user needs to access parent device, that driver maintainer should ask fo=
r it.
