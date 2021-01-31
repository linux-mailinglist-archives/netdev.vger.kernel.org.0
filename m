Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC9C309D99
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 16:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhAaPfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 10:35:21 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:8068 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbhAaPdz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 10:33:55 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6016cdba0002>; Sun, 31 Jan 2021 07:33:14 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 31 Jan
 2021 15:33:12 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sun, 31 Jan 2021 15:33:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ndr+W60V+F1BmfQHSajkv+GeG2nwMn779l5rI22Y/0mk3+XPbTS910VHWnFwVxynYXUO7bgNFv2lalF3lo1kqvwPDTeIOBNs/RgzlSB9bKoRq7joRslxZtkfgiokt2UIWNXdNDjAPI2dNQLGGsR557ABY0yB2puspIyomTX8i2QvqYuo2W+PDubMPB9R8KFtXApVSpwqahyrp1Xz/hku8jFe+ZgpwvUACrP1RUbkwg/HjdoveRQtc7V2/jHhw/oYkcWXTJRiucZUIv4Weig8OOHEhrxxZF3WkJzdYeF3yaQDYQPEXpZsejPIlGpU53SL4x0wW9ZrWaXo863WQjXb3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mA1pxX93GCmW1QAp/IhWtc9kVraKh9XzBZaJuigtYXg=;
 b=ft/qTZdDYFIfeRMW8I55bpsFjYoSyjtmHShBq7JsJwJA0J+jTmFflOLl3kgql46npZpO165ZbX1Erykk9BMkScgw9sVqzFOCVBIMcFG/oTk2tHco2LbY2tFrcJ0FJXZyzm9GVA17dzotWWJfNdNhxutsjeGKPB5QYfvDKAFVGBhXhteaKQtWLibFWNV3Ih3pP50kTjSh3ojXQ7PcU4h1wLwkv+KfdgJYKzyt5QKNazVGCuWcis3ve22+txfMV2D43KcBcF3Qz6+jCzV/pOT8LHdKCd3IKsnw1XpHkXQwWmqE2ScspUikHPUgYMf2movvABhLpqqtZhOHXR3i787myQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20)
 by DM6PR12MB3579.namprd12.prod.outlook.com (2603:10b6:5:11f::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Sun, 31 Jan
 2021 15:33:11 +0000
Received: from DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::4103:b38b:a27c:c7e8]) by DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::4103:b38b:a27c:c7e8%7]) with mapi id 15.20.3805.024; Sun, 31 Jan 2021
 15:33:11 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Michal Kubecek <mkubecek@suse.cz>,
        Edwin Peer <edwin.peer@broadcom.com>
CC:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        mlxsw <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>
Subject: RE: [PATCH net-next v3 2/7] ethtool: Get link mode in use instead of
 speed and duplex parameters
Thread-Topic: [PATCH net-next v3 2/7] ethtool: Get link mode in use instead of
 speed and duplex parameters
Thread-Index: AQHW7w/mnu6I7KMocku/Ks1pUflayqoxLNcAgAVHQjCAAjatgIABgM1wgAADnoCAAT7X8IACG5MAgAPpn6A=
Date:   Sun, 31 Jan 2021 15:33:10 +0000
Message-ID: <DM6PR12MB4516868A5BD4C2EED7EF818BD8B79@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20210120093713.4000363-1-danieller@nvidia.com>
 <20210120093713.4000363-3-danieller@nvidia.com>
 <CAKOOJTzSSqGFzyL0jndK_y_S64C_imxORhACqp6RePDvtno6kA@mail.gmail.com>
 <DM6PR12MB4516E98950B9F79812CAB522D8BE9@DM6PR12MB4516.namprd12.prod.outlook.com>
 <CAKOOJTx_JHcaL9Wh2ROkpXVSF3jZVsnGHTSndB42xp61PzP9Vg@mail.gmail.com>
 <DM6PR12MB4516DD64A5C46B80848D3645D8BC9@DM6PR12MB4516.namprd12.prod.outlook.com>
 <CAKOOJTyRyz+KTZvQ8XAZ+kehjbTtqeA3qv+r9DJmS-f9eC6qWg@mail.gmail.com>
 <DM6PR12MB45161FF65D43867C9ED96B6ED8BB9@DM6PR12MB4516.namprd12.prod.outlook.com>
 <20210128202632.iqixlvdfey6sh7fe@lion.mk-sys.cz>
In-Reply-To: <20210128202632.iqixlvdfey6sh7fe@lion.mk-sys.cz>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [93.173.23.32]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f7ecfde-fac6-4f0c-c67c-08d8c5fd845f
x-ms-traffictypediagnostic: DM6PR12MB3579:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3579178292DC7205C384ABBDD8B79@DM6PR12MB3579.namprd12.prod.outlook.com>
x-header: ProcessedBy-CMR-outbound
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hrt1l4oaI/boYShgMMm+stEKPqj0oEZ9aV0j6FnXvoYBnPFLI1fwdSbAM7ePb30T4WD8ikjyXU7h5EKFL51xrjXjzIKmlamneKbYEqR5SH/LkhHhrZ+SFMn/8d41lFYGtWjUsqCylFK+yW5WJgLEyCK6PK0e4W2BzduBnIMc022r09S7In6eQE2mMPOSQyDEwC/M5wed1CXCn8Dn286Hs4RDmiABSIkjfNoNzULy8JEq4mSXrvFUPU7txsbhHQL0LZny4u0s+2jXH94rGnCNKKL+tAn/cQz4GFTPzl8T1ox2E0jcxMAAL1YQ0LZsjcVVwCNLusB7CFIv66rAZnUZfrgZ4O9uAzj7F/+YSVyT8gKVHQNrJ1Tl7dxnEpPClHBPOh3fFOCSkipZ2hPHb0z0FwOwTQFHrORSfNXBp1tVOAaWw16sY+Mz1Z9em038RNCpbecwAgtX8gHjqnpDxr8c+OnFGrQwUoj1HCPfWzYCUqmEJTbXVAsMxgK7eg5hPUNTWYn9AKjeTXG3Cb+eKYmmJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4516.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(366004)(346002)(396003)(136003)(376002)(7696005)(26005)(76116006)(4326008)(5660300002)(107886003)(2906002)(66556008)(186003)(8936002)(9686003)(71200400001)(316002)(33656002)(54906003)(478600001)(83380400001)(52536014)(53546011)(66946007)(55016002)(66476007)(66446008)(86362001)(8676002)(64756008)(6506007)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?m7c/Iv5AxpMVR1Afj175QApbzLGrwQVBJIUjyyFJT1TFNv0CKgihsp+sVol2?=
 =?us-ascii?Q?eGBZ7D95thsoiPVbn2Oyq1HWvsmydoKgUS0CRv40FYHNmOsmc9MN7/8NoBFD?=
 =?us-ascii?Q?UIlsey4Ppq3FR4ik/XeYg9nivTkozc89dJsfr586jQmDA9EstAlamHDUSSBY?=
 =?us-ascii?Q?IKjsXxJtacVx6976yxAZP6cqSpJnpAa+wkCnKOHi0bZNvZySHjIsBe9hCEEk?=
 =?us-ascii?Q?SiMOMWqXWSqWLiN0SRtWxSNlZI4P1owt4FxrmWCsfVxoSh2JbldrGJkttMuz?=
 =?us-ascii?Q?GeMugEFbE9ZvwLZkQ60E2MSZU0I8XeENVa5e/coYZQhvIKyGAMLp0618JOkV?=
 =?us-ascii?Q?i3MeDR8BZ+gx92R1XdpWNnM/MuNJ71O0lQYfzOoyVNO2n7D1Y8dgIT6Mvaa3?=
 =?us-ascii?Q?8uPBFDNX3awiUmpHbX0trQc+TxXnwDCJgwPOfaVbqXAAi2cHaUnXV8t5jelu?=
 =?us-ascii?Q?OmfkGxbRWB15Rk2yWMpiJeHevawW0tx21CG7Ji7XVXeZD+0MP0ADNuH41hYi?=
 =?us-ascii?Q?7WvQVE6KS50M+tJQ8SkUCAkSI69V0qrebZj8Dk7d41MGwpqCvkD7DgEyb5yl?=
 =?us-ascii?Q?nL3Y5gfVi/cvxDPXzzp7zfT9jKktNstZ/mpLcnssKuNfIJJQjd5W9vg5O9rA?=
 =?us-ascii?Q?ywm9iRONfWCmdFsNaA07NyVn1n7UWH5bck5UJUBLy7mMuIE5Qk/esE6uxJoC?=
 =?us-ascii?Q?3NBXFsVQ5hPgZJDvbqVqj3fnUz9I4wf03nm4VSTzh6hcvHDU2+heA3zCUUrL?=
 =?us-ascii?Q?X2Ae0piJ2aWE1i2/ea/sCHH4BBOPJJ29kmsJ627ZnYhjdzMNEaMDJTBMzrV7?=
 =?us-ascii?Q?XvLrkSZxekd/8+0ELkmN2JGt8r3RfKXmqQ1pIf84n5W6YLiz7GGPU84EehEH?=
 =?us-ascii?Q?+jZM2O2jYBaJp9DFDka9R9jRFP9IxvuJgJ6Yi4C8UPqmxcIyVrJlpTjIzQR9?=
 =?us-ascii?Q?up4HcCAKN1TjITSXVe9Fbu/P+DycYFK0ERRtIVzclI7119e5kAKb+HbeNV24?=
 =?us-ascii?Q?7MftLLDEqyy5OLW65mYk2a2uAqtt1zXwqXAKbj9q+Ge/ZnxFGnyxHtpz3tAt?=
 =?us-ascii?Q?uNRj9N14?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4516.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f7ecfde-fac6-4f0c-c67c-08d8c5fd845f
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2021 15:33:10.9668
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VzNzi152M3CZok66j50PmIOUTpFFoRva5YTnRQahRgnLN4nXH4micJeJlEndlAS8w91mMTVMvPGO+OZg7doQCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3579
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612107194; bh=mA1pxX93GCmW1QAp/IhWtc9kVraKh9XzBZaJuigtYXg=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-header:x-ms-oob-tlc-oobclassifiers:
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
        b=lO1nACZjfhyL5sFLifafHyP0H1CfKkmTVZFr9y/dyUrNpX8HO/v/L/wD2XoCQX+wC
         Pb/hvCpCHIViph5YeYZ1kK4+SFbT0pemYNzZIYN4OHIXlAqS2x1MmxBq+KMlPDLrfT
         7roJ2SalX8VSIqfHlkM6wlxBu2StCHJFVhuNJRNKkEFibE+rwENLkDIrTg5XC8LpXu
         voEYQk1ih3QZNf+RBTBi6hYivhe3DF3PE1MOe9ytEHQpvDlYPzt2c2qSPz3MsgB+5j
         LaMUhoxTqkwUNPZpElpy6EevEqy2SbMmDQr/cuvf4f11vRxURbgqeDgVK/oY4zYNuX
         bfe8KIOJDrvKQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Michal Kubecek <mkubecek@suse.cz>
> Sent: Thursday, January 28, 2021 10:27 PM
> To: Danielle Ratson <danieller@nvidia.com>
> Cc: Edwin Peer <edwin.peer@broadcom.com>; netdev <netdev@vger.kernel.org>=
; David S . Miller <davem@davemloft.net>; Jakub
> Kicinski <kuba@kernel.org>; Jiri Pirko <jiri@nvidia.com>; Andrew Lunn <an=
drew@lunn.ch>; f.fainelli@gmail.com; mlxsw
> <mlxsw@nvidia.com>; Ido Schimmel <idosch@nvidia.com>
> Subject: Re: [PATCH net-next v3 2/7] ethtool: Get link mode in use instea=
d of speed and duplex parameters
>=20
> On Wed, Jan 27, 2021 at 01:22:02PM +0000, Danielle Ratson wrote:
> > > -----Original Message-----
> > > From: Edwin Peer <edwin.peer@broadcom.com>
> > > Sent: Tuesday, January 26, 2021 7:14 PM
> > > To: Danielle Ratson <danieller@nvidia.com>
> > > Cc: netdev <netdev@vger.kernel.org>; David S . Miller
> > > <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Jiri Pirko
> > > <jiri@nvidia.com>; Andrew Lunn <andrew@lunn.ch>;
> > > f.fainelli@gmail.com; Michal Kubecek <mkubecek@suse.cz>; mlxsw
> > > <mlxsw@nvidia.com>; Ido Schimmel <idosch@nvidia.com>
> > > Subject: Re: [PATCH net-next v3 2/7] ethtool: Get link mode in use
> > > instead of speed and duplex parameters
> > >
> > > For one thing, it's cleaner if the driver API is symmetric. The
> > > proposed solution sets attributes in terms of speeds and lanes,
> > > etc., but it gets them in terms of a compound link_info. But, this
> > > asymmetry aside, if link_mode may eventually become R/W at the
> > > driver API, as you suggest, then it is more appropriate to guard it
> > > with a capability bit, as has been done for lanes, rather than use
> > > the -1 special value to indicate that the driver did not set it.
> > >
> > > Regards,
> > > Edwin Peer
> >
> > This patchset adds lanes parameter, not link_mode. The link_mode
> > addition was added as a read-only parameter for the reasons we
> > mentioned, and I am not sure that implementing the symmetric side is
> > relevant for this patchset.
> >
> > Michal, do you think we will use the Write side of the link_mode
> > parameter?
>=20
> It makes sense, IMHO. Unless we also add "media" (or whatever name would =
be most appropriate) parameter, we cannot in general
> fully determine the link mode by speed, duplex and lanes. And using "adve=
rtise" to select a specific mode with disabled
> autonegotiation would be rather confusing, I believe. (At the moment, eth=
tool does not even support syntax like "advertise <mode>"
> but it will be easy to support "advertise <mode>... [--]" and I think we =
should extend the syntax to support it, regardless of what we
> choose.) So if we want to allow user to pick a specific link node by name=
 or bit mask (or rather index?), I would prefer using a separate
> parameter.
>=20
> >            And if so, do you think it is relevant for this specific
> > patchset?
>=20
> I don't see an obvious problem with leaving that part for later so I woul=
d say it's up to you.
>=20
> Michal

Thanks Michal.

Edwin, adding the a new parameter requires a new patchset in my opinion. Im=
plementing the symmetrical side of the link_mode get,
however can be a part of this set. But, the problem with that would be that=
, as Michal said, speed lanes and duplex can't provide us a single
link_mode because of the media. And since link_mode is one bit parameter, p=
assing it to the driver while randomly choosing the media, may
cause either information loss, or even fail to sync on a link mode if the c=
hosen media is specifically not supported in the lower levels.
So, in my opinion it is related to adding the new parameter we discussed, a=
nd should be done in a separate set.

Thanks,
Danielle

