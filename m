Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53AAB2DED1E
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 06:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgLSFGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 00:06:55 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:7439 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbgLSFGz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Dec 2020 00:06:55 -0500
Received: from HKMAIL102.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fdd8a450002>; Sat, 19 Dec 2020 13:06:13 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 19 Dec
 2020 05:06:12 +0000
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.53) by
 HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sat, 19 Dec 2020 05:06:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C4mRoHcI9RAp9mAVTXJCPye0viqaqV3fPRU0sxVzO3kYsW5/rhfJoNzxYHUFUuqoEKRXHwgslgORAt2hBhgrkzK7/Yxc1dJWlAmh70bThERZ8Is2zDnC4MiptZM9pundiKnNM7cQnVG17Ut5OEwfRz7jq1p1drEzgSRnpFPMzDG3gjwPkDgLMjgaaF5QEPsN6e6waCDyCSE1E0hGnLr4QsGvrg5N1po4kxzthuHAkE+FZEpChOor8pog1YRI/mT/egfQ6RmnatT4DXURcOVQjC7qgZlN0KiQikBi8KBMR6AFUdv6RBVhAkhlntcfoe4MCiy0bIg0cwa74gp2eHo++A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lw+AhsqUuMyRX5voP78RW71UQ0WzsQzjcF1qTWMhmBI=;
 b=Gl/ZaHcRtQeylMMdynxxl1GYFAEN5LC4pU6qdZpIOtxbFzjaX/3YnLrBwg8rcr1D/cmdcXbtmDG3yl0w0H7yQSpAExOsO65pCjHKqdEp9IZp67bkvDO5EpdGW6FUPGDUTBeP0h6wspcxLcJlZPQcm3581faYqd5q5pJxthC66VxaY+U4y5mRVuIAV0IC4/PML8qvuXQYYTMGrEDX20nDdrqfq5WK1VdRVPVJ1hNMRE+MxCDRW7enuhTS955PT1mzSU40bNUTxFtYTuSrepvAXIGf4UFKWHTLNEqi7X3lTI0Hk3gNFrUllHhqZsoSpHos2BPJyJzHzO9LdzbiKmH9Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB3843.namprd12.prod.outlook.com (2603:10b6:a03:1a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Sat, 19 Dec
 2020 05:06:08 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%6]) with mapi id 15.20.3676.029; Sat, 19 Dec 2020
 05:06:08 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        "Sridhar Samudrala" <sridhar.samudrala@intel.com>,
        "david.m.ertman@intel.com" <david.m.ertman@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [net-next v5 05/15] devlink: Support get and set state of port
 function
Thread-Topic: [net-next v5 05/15] devlink: Support get and set state of port
 function
Thread-Index: AQHW0sFH91yNDr98FE67ntr+TvpO06n44deAgABLWyCAAT7jAIAAV/VggAKEtwCAAJe9oA==
Date:   Sat, 19 Dec 2020 05:06:08 +0000
Message-ID: <BY5PR12MB43229C7664D0DE29FCB68CE6DCC20@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-6-saeed@kernel.org>
        <20201215163747.4091ff61@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43225346806029AA31D63918DCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20201216160850.78223a1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43229F0FB38429E826DE1060DCC40@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201218115110.33701ded@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201218115110.33701ded@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.221.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7d225fc-0469-4912-2b1e-08d8a3dbcbab
x-ms-traffictypediagnostic: BY5PR12MB3843:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB3843D98EB253DF4F4B4E8ADCDCC20@BY5PR12MB3843.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H5sLneNmg/ywg564gEKx8rgn+9Kr81Jw2JpuvKuAYFmjGxod1XN2U3oY4+9C3hiHmpey6W141yq026nqXoX48URyDkWC/ro249bPIFe0BO9OR9hxh/Jq8ONTARqXhXO5a0qXkm46YnU7hvtx9hsWVofOs3V+OYSjh2HVCqKMpmjrv8jkkPPiRVohlnWLiTw+butN/IS1qfl03AVRlVAmeNQkrx3NvI2S/PKg6MboV5+wonY2bFH0Ty3ItM3QsdT4r9RrKY7B0RJn9JjyXpqYS2WOjj8Ay6DGpYHOenQHxbNh7sdoClkw/r1TWG5VR4cwBt6LSFj+VDpZ9ynRncWrQDevTKj7ioxlkEjaLvt2l+3JBHAC8Y+poSV+o4Gj6Mb6q6QunFtpIfd6fs2l5UyYUQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(86362001)(9686003)(66556008)(76116006)(7696005)(7416002)(66446008)(71200400001)(64756008)(26005)(2906002)(66476007)(55016002)(33656002)(66946007)(186003)(8936002)(54906003)(5660300002)(316002)(6916009)(478600001)(4326008)(107886003)(55236004)(52536014)(83380400001)(6506007)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ebtwr5zrmuS3ixjhJOdcYU/iYEcCUr6yVDvdH1dky7qVbMuL8n+V0V9ViYf2?=
 =?us-ascii?Q?kV+Nlv0bZwAcRSjnuYEAM49cRIZ16SFII8EaW6e6KFJz3H7Xf0PNUYaHsi1B?=
 =?us-ascii?Q?eVPSApaHgaF2eGpLvd7hly4/oRh6KkhcPsIS6pWkdmZolNaEE1plrYA4rGTO?=
 =?us-ascii?Q?DSk+0CnC6SunnJW75wirEEyvkoNzeg95VMWtiwUTdc1oftA9LtMYwuOEvZ2M?=
 =?us-ascii?Q?F/DVIa/j++3irWQFmeKTG6NUcpv6tyrE6Hktmdp7qILYw6p33965GHW3bsY9?=
 =?us-ascii?Q?V45TmBzfKJjuEQjOf3KzhxTWnaqkv7Tvk36gc7kAGCYqWo3uJmTDen2t1CPG?=
 =?us-ascii?Q?izXMSjCKdfkYmJ3Mpzk+F8F+3APnk6dHImYX4MoyINuo63Mnnls7ecn+0dZE?=
 =?us-ascii?Q?U7YY4A5Z2wb0NkQA0I2IrGKKqA+RQtCpYz8grs7k5FyJJBAxt6slCvuObLgV?=
 =?us-ascii?Q?SCEgCf7g8OvKl5TRG4+ucQUtyK+EyotV5bO/yKodZdRYTQngtDC1BDcWfFDi?=
 =?us-ascii?Q?A+NhinWHsd+0t9QAtkCJplfhAFXq98IZwWe5T03qOCPmbTp09OJM7LOFgdEJ?=
 =?us-ascii?Q?AozbVF6Y9W0oWvb+JjvIavtpd0ROzabSkwMub+U639TLsO6D/MgyLcSvg/fL?=
 =?us-ascii?Q?B4uYU333yzY7RgyRS2hfRtl1/248eRiA5oAITD/4WCTeuQB33OOXT8LlGVxi?=
 =?us-ascii?Q?owqbijbmUJhytO2KKBV8wSHIYRF6AQYzGdeaeUDd7mt2z5O5aE/iH2ukOyJi?=
 =?us-ascii?Q?bjSG6BWgmBNOHfgN958okWaD2sAQLOoTBwNklpmMzwnK1N8iHEb0qAQxBeI0?=
 =?us-ascii?Q?bmq7y9Ro9ENl2xMOi97cfVEDIXHFu9GpaB3TezR2bqoVX6cC9pEVYuAoseyf?=
 =?us-ascii?Q?9D7anDv9iuiGNS7t95mW+mUSFAbUf/nAlt/yL1ekwc7nPLAdybAzJBm6p+Ug?=
 =?us-ascii?Q?pa6p2jK+t7511e9SDePOPFsxtDjUnsXx7OtpAwtUDyU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7d225fc-0469-4912-2b1e-08d8a3dbcbab
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2020 05:06:08.1400
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s20qODAzxkjpaWHfKo8jdyAaEyQkMnIuG4MgNJSCRsUM3MfEVeWkVS0P5v/9h4mkBKx6V2RgffFVaYrDXm4VQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3843
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608354373; bh=Lw+AhsqUuMyRX5voP78RW71UQ0WzsQzjcF1qTWMhmBI=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=mOG+oNe/abuCfukvRZIotM1AlsyrnXNgct8oiqE9F6PeoPgGXvCBQ0iggb/RGR7g8
         UrpN4tYsWhojVsbaZqZZbgoSsORj0DSQFW2FJ5qBsuBePCQKw6vDvRrXq7A4P/8hri
         /nrccv+6iATUPv75Xz1YVA9BlBoEM4rkfo/psZMJbdUEiNqJoqSE70ZvPNfJRPN9f9
         XniSIh95kAAmaBFr+OP2uV1Wjxvxx62MHtldP4hdu5bw7Q6gL8guHES2kwCxhrAGgG
         ORV/bT9uX/UoE7eNPpkWMSiJQvJCt/CuI0TPLK69drY5dVWBEhOyTqnJ36rQ0ktVrI
         Zq9aXoMB7j6Bw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Saturday, December 19, 2020 1:21 AM
>=20
> On Thu, 17 Dec 2020 05:46:45 +0000 Parav Pandit wrote:
> > > From: Jakub Kicinski <kuba@kernel.org>
> > > Sent: Thursday, December 17, 2020 5:39 AM
> > >
> > > On Wed, 16 Dec 2020 05:15:04 +0000 Parav Pandit wrote:
> > > > > From: Jakub Kicinski <kuba@kernel.org>
> > > > > Sent: Wednesday, December 16, 2020 6:08 AM
> > > > >
> > > > > On Tue, 15 Dec 2020 01:03:48 -0800 Saeed Mahameed wrote:
> > > > > > From: Parav Pandit <parav@nvidia.com>
> > > > > >
> > > > > > devlink port function can be in active or inactive state.
> > > > > > Allow users to get and set port function's state.
> > > > > >
> > > > > > When the port function it activated, its operational state may
> > > > > > change after a while when the device is created and driver bind=
s to
> it.
> > > > > > Similarly on deactivation flow.
> > > > >
> > > > > So what's the flow device should implement?
> > > > >
> > > > > User requests deactivated, the device sends a notification to
> > > > > the driver bound to the device. What if the driver ignores it?
> > > > >
> > > > If driver ignores it, those devices are marked unusable for new
> allocation.
> > > > Device becomes usable only after it has act on the event.
> > >
> > > But the device remains fully operational?
> > >
> > > So if I'm an admin who wants to unplug a misbehaving "entity"[1] the
> > > deactivate is not gonna help me, it's just a graceful hint?
> > Right.
> > > Is there no need for a forceful shutdown?
> > In this patchset, no. I didn't add the knob for it. It is already at 15=
 patches.
> > But yes, forceful shutdown extension can be done by the admin in
> > future patchset as,
> >
> > $ devlink port del pci/0000:06:00.0/<port_index> force true
> >
> > ^^^^^^^^ Above will be the extension in control of the admin.
>=20
> Can we come up with operational states that would encompass that?
>=20
Operational state is read only. Adding more states will likely make user jo=
b harder, unless its absolute necessary.
Currently state and operational state definitions cover all the scenario ne=
eded.
Only exception is user doesn't have the ability of force delete.
$ devlink port shutdown pci/0000:03:00.0/port_index
Above command will attempt graceful port deletion.

$ devlink port del pci/0000:03:00.0/port_index
Above command will do force deletion.

> The "force true" does not look too clean.
>
I think notion of force to user is more intuitive than above two commands, =
as its exist for other parts of the system for example 'reboot'.
So no need for flag as true/false. Just force if user wish to do force remo=
val.

> And let's document meaning of the states. We don't want the next vendor t=
o
> just "assume" the states match their own interpretation.
Oh yes, I did document it in the UAPI header file which will be the first p=
lace for vendors to look on how to implement get/set.
But I will add this to patch_14 in the devlink 'subfunctions' section docum=
entation.
