Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53571F4FBA
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 16:31:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfKHPbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 10:31:43 -0500
Received: from mail-eopbgr80083.outbound.protection.outlook.com ([40.107.8.83]:40097
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726152AbfKHPbm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 10:31:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BmM5BK/Xpl9AMXgo+hTs/LEKtzEDBkgiaExYoDV8Esyk6nDerXKyx76UHPq0EGYBSebYraCSDqokeevllr5G/ljl16nXt+MCjsJYCXQKVKHVqauEZA2HZozzsmSIK57CRw5mmYYAmoC6Jya7fPGUhJ5IcGf8cawPUkMrWax+vHEldUlhpnsU2M49TQFe+BRJ42+c9YsDVbjHrSfAaykLKGX9aI7QcY+54zE4+cRvF5BoN5svBW8zieIRJU244Xxw7nbJ+j6+gOgZzAsyxYNeDxPojQW2gsWtCeVYiyzTMLx7e3pLqLO8pI6EQUy/SwoB70HsjslEd6dIUli7t+CMWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f4gHjSEYN0fSojbVCn1+gHxIN3v189gnNflTrSMdzXw=;
 b=TnVqaT3UjQ/CP5CqyqjGo3G/3BbE3JRn29Lny1Oe9DFOB76KKGV66LsLFCke6i28ydx8iQIT7GbNqpYbLedZkgqpWopPIrXOboIXsVLiWSyJBYXHBHkM6MXmYPse3bTkH0sED+taJfeo83woINROYd0+TlDD4Vjj3Kh4HIJSzpReaFz7Hxv+mCqmgBtFzSAIgM1Wm45wzQVWOG0ryPhUQGERNVynRAZr7DZLi0LIotz1ic5sEpb0F5Egx2htu8bQoDd5dFbhClPGe33ABatCGhH5TCN6U1bVHy0tAAXMjy/woMfZMdqlKMZAOcLMIrUWUm5+/rrp5qlSVqgUoTKtbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f4gHjSEYN0fSojbVCn1+gHxIN3v189gnNflTrSMdzXw=;
 b=q6AfhxY2feRJG6m3i7GG3YZsmYm9u2HkNzHtANCaRCh4NGttVq3Ohd4u8rR2Fq4IujetRIZeFfFfYggEOz5wPMA0F9incUU0ajZFP/nlhYTVRI98Jj6yQ+Q5QuXsldCJ/hLV0UL3h0raMeamZK9I9zdNfiJOwjLqEAu98MqhVcQ=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6132.eurprd05.prod.outlook.com (20.178.203.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Fri, 8 Nov 2019 15:30:59 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 15:30:59 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH net-next 19/19] mtty: Optionally support mtty alias
Thread-Topic: [PATCH net-next 19/19] mtty: Optionally support mtty alias
Thread-Index: AQHVlYXKCkwgRpy5N0GblxIWUl4Rt6eBSruAgAAXETCAAAV+AIAAAGtw
Date:   Fri, 8 Nov 2019 15:30:59 +0000
Message-ID: <AM0PR05MB486622134AD1F1A83714629CD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
        <20191107160834.21087-1-parav@mellanox.com>
        <20191107160834.21087-19-parav@mellanox.com>
        <20191108144615.3646e9bb.cohuck@redhat.com>
        <AM0PR05MB48667622386BBC6D52BE8BE8D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108162828.6e12fc05.cohuck@redhat.com>
In-Reply-To: <20191108162828.6e12fc05.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:9dfd:71f9:eb37:f669]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1a11a60b-da46-453d-8657-08d76460a7d0
x-ms-traffictypediagnostic: AM0PR05MB6132:|AM0PR05MB6132:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6132903FA98F442CC4D127EDD17B0@AM0PR05MB6132.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(366004)(346002)(39860400002)(396003)(199004)(189003)(13464003)(46003)(102836004)(99286004)(6506007)(53546011)(76176011)(55016002)(186003)(9686003)(7696005)(476003)(6246003)(229853002)(52536014)(6916009)(6436002)(81166006)(81156014)(8676002)(4326008)(6116002)(8936002)(446003)(11346002)(256004)(71190400001)(71200400001)(25786009)(66556008)(5660300002)(64756008)(66446008)(66476007)(86362001)(486006)(76116006)(316002)(33656002)(54906003)(2906002)(14454004)(7736002)(305945005)(74316002)(478600001)(66946007)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6132;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PGqITpKKhmFQmiQIGGwxvL4+WH31ZgqPnq85G+UpQaBoQJiIfXBnuDCcFhz0cqJP5XeMoaybn9n3ND4aGwSWV84Ju1wDjJmxJy1p2musdTX1/a1jHyTDeGXRuxIa6K4fBMUDi1VUgdoXqggTg92nuET4R5lv4MRo1hgiz3znxXBDQDv7I5CFFnIXteX8w9bGliuZp6Q8qoXo8UxhC/CW3H9vSlWm+/yM64KhSMsuPMUVAAPAMSDbqO9fbhFPXESbE8TWKGzhgMRBVmM7f8s22/L7Ht7vYUWZElDWyATbdoR7ALjzwbikX6JAyddTPJaPF+Kknq9tEbRSCvi057OawRPztgG7a1G54erTYr50eAV6aSHlHX4MDLgxWrfNTKaP7GddZ39598mrwe5JAGSVHBVuunQK/UZ1O5mit1FiCuvr0s0mQCPszBafbha9GNAP
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a11a60b-da46-453d-8657-08d76460a7d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 15:30:59.0573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jm8ZJZdad+lbyTThkF2eUd8mIbPHL9WmHYyI9BTDkqc1ooly6HgWbuZWYKQZEWcKsxadkdppie/Cvd//wtlKCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6132
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Friday, November 8, 2019 9:28 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: alex.williamson@redhat.com; davem@davemloft.net;
> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org; Jiri
> Pirko <jiri@mellanox.com>; linux-rdma@vger.kernel.org
> Subject: Re: [PATCH net-next 19/19] mtty: Optionally support mtty alias
>=20
> On Fri, 8 Nov 2019 15:10:42 +0000
> Parav Pandit <parav@mellanox.com> wrote:
>=20
> > > -----Original Message-----
> > > From: Cornelia Huck <cohuck@redhat.com>
> > > Sent: Friday, November 8, 2019 7:46 AM
> > > To: Parav Pandit <parav@mellanox.com>
> > > Cc: alex.williamson@redhat.com; davem@davemloft.net;
> > > kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> > > <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org; Jiri
> > > Pirko <jiri@mellanox.com>; linux-rdma@vger.kernel.org
> > > Subject: Re: [PATCH net-next 19/19] mtty: Optionally support mtty
> > > alias
> > >
> > > On Thu,  7 Nov 2019 10:08:34 -0600
> > > Parav Pandit <parav@mellanox.com> wrote:
> > >
> > > > Provide a module parameter to set alias length to optionally
> > > > generate mdev alias.
> > > >
> > > > Example to request mdev alias.
> > > > $ modprobe mtty alias_length=3D12
> > > >
> > > > Make use of mtty_alias() API when alias_length module parameter is
> set.
> > > >
> > > > Signed-off-by: Parav Pandit <parav@mellanox.com>
> > > > ---
> > > >  samples/vfio-mdev/mtty.c | 13 +++++++++++++
> > > >  1 file changed, 13 insertions(+)
> > >
> > > If you already have code using the alias interface, you probably
> > > don't need to add it to the sample driver here. Especially as the
> > > alias looks kind of pointless here.
> >
> > It is pointless.
> > Alex point when we ran through the series in August, was, QA should be
> able to do cover coverage of mdev_core where there is mdev collision and
> mdev_create() can fail.
> > And QA should be able to set alias length to be short to 1 or 2 letters=
 to
> trigger it.
> > Hence this patch was added.
>=20
> If we want this for testing purposes, that should be spelled out explicit=
ly (the
> above had already dropped from my cache). Even better if we had
> something in actual test infrastructure.

What else purpose sample driver has other than getting reference on how to =
use API? :-)
