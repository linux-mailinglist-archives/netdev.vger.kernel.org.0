Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9C31F5016
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 16:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfKHPpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 10:45:12 -0500
Received: from mail-eopbgr10054.outbound.protection.outlook.com ([40.107.1.54]:4433
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726101AbfKHPpL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 10:45:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZFt5cTYI3lhk96gjKEweTefH2jvPsdtqUY3RNhjNzGh0Il3eC5199KBXq+oI6lMWeyyTj0fs7xwLr7KV8O4Q3AZ/YT0PVT5mfV+TCGP9qkClJvGeBvjuZUy28AhYBj0y1eVTA22IntEvhziU/PmJw1jYvOXlrvht8BZFOIFPsiyUJj3AUsJs8XAyO6WJguICVhQXZinfjntJiInfIZ2G0eQZzU8wvzjwGtIlk41cKhJJ7wtyjsqWlGKLkrcgwwO5vJ0/sXkkq5/xQdiNdHcIkdGToPBzgjtquQtjNnEXuD9br7dcFSCCWZv2KmjNAR6tC9z13SGsiPucRidSZBl4sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5sKHKJ8ThcjoXqF83hGxt31KEyRFP4BfIPsODUgJXI=;
 b=NbYpX29ZdK0sL+km46bo26jug9gLIfcBm6MB1lX5P0QYEkNyKQmrXf/zn7osshuLMTSX2SAMRBuBcsDN4wXqGsPyCE8VQ3ouX5g10tccSiB1cKqDWaP7HHaew95XUHYDxD3qrhItxoKdMoDg1n75LXJiGa0hOS4sUp4CcXw/exRrZNLQwiVldiqC/nis3UUhjqDkgYuDP2QWha+wJieX2pVaG4uGPCLFUbkzKKuUqBIaS/pw5ECNcln1xwLY4oCP0PJ37Mi9oz5cRX+P/J2HPDio4XCWIK+X8y911F62BN+jsRf55nA6PC5OnrG4gytpJbQ0vFmmshdJFPjFw3pNhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5sKHKJ8ThcjoXqF83hGxt31KEyRFP4BfIPsODUgJXI=;
 b=qeKu8WyKbgbGkZAlEVsvmPCspaNOVHBG+DroWaQG88lUgh/vPt250Bx18ZTpHI9tyhPYOV/6IIN79HCkETTOwvzyyOmBZBtz8LU6HfrXcKDE7EoQ3NL//HQBenm857/n8x6rqc22tQB8QP0AdMz2MmZOSOyZnMQrmIoMsJjKIyA=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6577.eurprd05.prod.outlook.com (20.179.33.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Fri, 8 Nov 2019 15:45:06 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 15:45:06 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
Thread-Topic: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
Thread-Index: AQHVlYW+5ckj7/tyDUu1ocZ3bBFvo6eAK5wAgAAEe2CAAEmKAIAAA1+ggAAOHACAAAFAIIAAe3YAgABjcxA=
Date:   Fri, 8 Nov 2019 15:45:06 +0000
Message-ID: <AM0PR05MB4866969D18877C7AAD19D236D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107160448.20962-1-parav@mellanox.com>
 <20191107160834.21087-1-parav@mellanox.com>
 <20191107160834.21087-12-parav@mellanox.com>
 <20191107153836.29c09400@cakuba.netronome.com>
 <AM0PR05MB4866963BE7BA1EE0831C9624D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191107201750.6ac54aed@cakuba>
 <AM0PR05MB4866BEC2A2B586AA72BAA9ABD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191107212024.61926e11@cakuba>
 <AM0PR05MB4866C0798EA5746EE23F2D2BD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108094646.GB6990@nanopsycho>
In-Reply-To: <20191108094646.GB6990@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:9dfd:71f9:eb37:f669]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8e74c738-0e78-4f36-d591-08d76462a0e3
x-ms-traffictypediagnostic: AM0PR05MB6577:|AM0PR05MB6577:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB6577F0A8C2101E8518E2250BD17B0@AM0PR05MB6577.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(13464003)(199004)(189003)(4326008)(74316002)(9686003)(7696005)(46003)(7736002)(55016002)(71190400001)(71200400001)(76176011)(14454004)(99286004)(486006)(6436002)(6116002)(11346002)(476003)(7416002)(446003)(6246003)(256004)(305945005)(186003)(54906003)(5024004)(53546011)(8676002)(33656002)(102836004)(6506007)(86362001)(64756008)(66446008)(478600001)(25786009)(229853002)(52536014)(81166006)(66946007)(8936002)(81156014)(76116006)(316002)(66476007)(66556008)(5660300002)(2906002)(6916009);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6577;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7+mEHPOLNfqHqVHJGXpPmU/nDyQnSMHqjrQt4ka2zRGddLFXFsacaHSSlspz3QSVpRgK/Ffd73s3r/UNb70bWcvVWOXc7u9osizpQ/tahZTCq99YdKId9WcAoV1zmUg7dATQfaF4aQgXgn+/Jl8dDfLeL8ULN+2dXrTx8kWOxJG+jA9oCoUMwE49aeVb0j1fzjheZP/HElVa7UNslFLJydC3DZ1oD0iIzNXgLYKv2QIV+/AwsYizbaYGSyHGYAOfCSAD58+8FS56ljr2k9FrGG4tTVK0CyMGRX8IJvUkeeZlneSgCgJucSIQg15KHsNHV+ZjNpYiBP/w3NiuaEOFwuNtJuSN/WtBkvLIEdGQt7WSLm4HfmtF3+O6H4DsAN7gcCA0P9YTkECkhlJWwyuq4M3SywXm8y2WdYcbADVDpAtOn5nqNpBvlzgeM6m7YJsV
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e74c738-0e78-4f36-d591-08d76462a0e3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 15:45:06.4443
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mCTGuc7qBKXL1W2+qrFC/0HrDcwVM5UlI85GzAA6gRhWbTPhNbxNtoyJLmFQefz8+PxfiuwrhN+SymRfbqyWhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6577
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Friday, November 8, 2019 3:47 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>;
> alex.williamson@redhat.com; davem@davemloft.net; kvm@vger.kernel.org;
> netdev@vger.kernel.org; Saeed Mahameed <saeedm@mellanox.com>;
> kwankhede@nvidia.com; leon@kernel.org; cohuck@redhat.com; Jiri Pirko
> <jiri@mellanox.com>; linux-rdma@vger.kernel.org
> Subject: Re: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
>=20
> Fri, Nov 08, 2019 at 03:31:02AM CET, parav@mellanox.com wrote:
> >
> >
> >> -----Original Message-----
> >> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> >> Sent: Thursday, November 7, 2019 8:20 PM
> >> To: Parav Pandit <parav@mellanox.com>
> >> Cc: alex.williamson@redhat.com; davem@davemloft.net;
> >> kvm@vger.kernel.org; netdev@vger.kernel.org; Saeed Mahameed
> >> <saeedm@mellanox.com>; kwankhede@nvidia.com; leon@kernel.org;
> >> cohuck@redhat.com; Jiri Pirko <jiri@mellanox.com>; linux-
> >> rdma@vger.kernel.org
> >> Subject: Re: [PATCH net-next 12/19] devlink: Introduce mdev port
> >> flavour
> >>
> >> On Fri, 8 Nov 2019 01:44:53 +0000, Parav Pandit wrote:
> >> > > I'm talking about netlink attributes. I'm not suggesting to
> >> > > sprintf it all into the phys_port_name.
> >> > >
> >> > I didn't follow your comment. For devlink port show command output
> >> > you said,
> >> >
> >> > "Surely those devices are anchored in on of the PF (or possibly
> >> > VFs) that should be exposed here from the start."
> >> > So I was trying to explain why we don't expose PF/VF detail in the
> >> > port attributes which contains
> >> > (a) flavour
> >> > (b) netdev representor (name derived from phys_port_name)
> >> > (c) mdev alias
> >> >
> >> > Can you please describe which netlink attribute I missed?
> >>
> >> Identification of the PCI device. The PCI devices are not linked to
> >> devlink ports, so the sysfs hierarchy (a) is irrelevant, (b) may not
> >> be visible in multi- host (or SmartNIC).
> >>
> >
> >It's the unique mdev device alias. It is not right to attach to the PCI =
device.
> >Mdev is bus in itself where devices are identified uniquely. So an alias
> suffice that identity.
>=20
> Wait a sec. For mdev, what you say is correct. But here we talk about
> devlink_port which is representing this mdev. And this devlink_port is ve=
ry
> similar to VF devlink_port. It is bound to specific PF (in case of mdev i=
t could
> be PF-VF).
>
But mdev port has unique phys_port_name in system, it incorrect to use PF/V=
F prefix.
What in hypothetical case, mdev is not on top of PCI...
