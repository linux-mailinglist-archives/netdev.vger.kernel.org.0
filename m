Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDBE5DB5C
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 04:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfGCCIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 22:08:43 -0400
Received: from mail-eopbgr30059.outbound.protection.outlook.com ([40.107.3.59]:59970
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726329AbfGCCIn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 22:08:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SHOnnTjiz6hIzee8sPfl+qU8r7UuAKvecbN9esSqZHg=;
 b=Qo84JkXcFwZoMbnri7KM0Bxdb/AHR0u9vJ3SBgv4ZDAVhlnGaE42atSjPSP1NyRirIV7gvn7Z5YGdLv9Ec9W+lYUi1isgHZaGByKbTEQk9wrQEpc469/Ql6KFKAG3PWzEmiBaXvhJQF9ntsxhG7Vz09DzK2SXhK8ZcPO6ypTsSM=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6385.eurprd05.prod.outlook.com (20.179.33.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Wed, 3 Jul 2019 02:08:39 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279%5]) with mapi id 15.20.2032.019; Wed, 3 Jul 2019
 02:08:39 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: RE: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
 port attribute
Thread-Topic: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
 port attribute
Thread-Index: AQHVMAhn8T46v1pXDUi3XMXT/4YtI6a2aNkAgABHFVCAAOxagIAAD8wAgABTlQCAACfsUA==
Date:   Wed, 3 Jul 2019 02:08:39 +0000
Message-ID: <AM0PR05MB4866F1AF0CF5914B372F0BCCD1FB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190701122734.18770-1-parav@mellanox.com>
        <20190701122734.18770-2-parav@mellanox.com>
        <20190701162650.17854185@cakuba.netronome.com>
        <AM0PR05MB4866085BC8B082EFD5B59DD2D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190702104711.77618f6a@cakuba.netronome.com>
        <AM0PR05MB4866C19C9E6ED767A44C3064D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702164252.6d4fe5e3@cakuba.netronome.com>
In-Reply-To: <20190702164252.6d4fe5e3@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dddefc92-5ef8-4edd-d94b-08d6ff5b5d76
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6385;
x-ms-traffictypediagnostic: AM0PR05MB6385:
x-microsoft-antispam-prvs: <AM0PR05MB63859F1DA23C85710FB00021D1FB0@AM0PR05MB6385.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 00872B689F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(39860400002)(376002)(136003)(396003)(13464003)(189003)(199004)(7736002)(74316002)(107886003)(78486014)(33656002)(86362001)(6246003)(64756008)(66446008)(478600001)(446003)(8676002)(305945005)(6916009)(256004)(66066001)(229853002)(71200400001)(6436002)(73956011)(81156014)(81166006)(66946007)(9686003)(53936002)(55016002)(66556008)(71190400001)(486006)(476003)(14454004)(5660300002)(186003)(9456002)(11346002)(2906002)(66476007)(26005)(52536014)(6506007)(55236004)(102836004)(8936002)(76176011)(25786009)(53546011)(54906003)(316002)(4326008)(68736007)(3846002)(7696005)(6116002)(99286004)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6385;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XcXWMnTjJn3R66n91tLzVA9y02Tn9aHIFHY14lO1pjfzWjRY1vq3zUqUuv/dehfqANld9fXhoabVyXgUZv7fsaSUWjgjnlig2eopfxS4p1jBHZHivNAe1Yr2xIA3F+5g6Nir10eK0f2DD2pbtTZZxzFd/SMJSgMKqSxkLLK+sxdW/aLGffn7nrEE0ftzSFiPiIey3ax+0y6TBG3HUX5fYqDNYlnBvz000zScPRf5kdgaz3ccgxbJSRPHi5JH6MoPmeb8UHlFlDOsv2tEihW160rzcEhcrJcL5YIOhTkqGU+yQfDReO83QMB1thwk98qKNka3lTwUvu6hGgZDllIpr8ky5k1sAXmy6a+366JTuaYgNQwOzBHRq4FU/nQcWi6hNU+WgO/1QKFNxamc4y3bEZzDae42iDHu6lTMmAf1PKw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dddefc92-5ef8-4edd-d94b-08d6ff5b5d76
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2019 02:08:39.3111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6385
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Wednesday, July 3, 2019 5:13 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Jiri Pirko <jiri@mellanox.com>; netdev@vger.kernel.org; Saeed
> Mahameed <saeedm@mellanox.com>
> Subject: Re: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour =
and
> port attribute
>=20
> On Tue, 2 Jul 2019 18:50:31 +0000, Parav Pandit wrote:
> > > > I didn't see any immediate need to report, at the same time didn't
> > > > find any reason to treat such port flavours differently than
> > > > existing one. It just gives a clear view of the device's eswitch.
> > > > Might find it useful during debugging while inspecting device inter=
nal
> tables..
> > >
> > > PFs and VFs ports are not tied to network ports in switchdev mode.
> > > You have only one network port under a devlink instance AFAIR, anyway=
.
> > >
> > I am not sure what do you mean by network port.
>=20
> DEVLINK_PORT_FLAVOUR_PHYSICAL
>=20
> > Do you intent to see a physical port that connects to physical network?
> >
> > As I described in the comment of the PF and VF flavour, it is an eswitc=
h
> port.
> > I have shown the diagram also of the eswitch in the cover letter.
> > Port_number doesn't have to a physical port. Flavour describe what
> > port type is and number says what is the eswitch port number.
> > Hope it clarifies.
>=20
> I understand what you're doing. =20
o.k.

> If you want to expose some device specific
> eswitch port ID please add a new attribute for that.
> The fact that that ID may match port_number for your device today is
> coincidental.  port_number, and split attributes should not be exposed fo=
r
> PCI ports.
So your concern is non mellanox hw has eswitch but there may not be a uniqu=
e handle to identify a eswitch port?
Or that handle may be wider than 32-bit?
And instead of treating port_number as handle, there should be different at=
tribute, is that the ask?
