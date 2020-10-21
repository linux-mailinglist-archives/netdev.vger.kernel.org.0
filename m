Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DBB2948CD
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 09:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440892AbgJUHU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 03:20:27 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:1614 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440881AbgJUHU1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 03:20:27 -0400
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f8fe1390001>; Wed, 21 Oct 2020 15:20:25 +0800
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 21 Oct
 2020 07:20:25 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.56) by
 HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 21 Oct 2020 07:20:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DC72FMZxu4X4nQVFD78e5HpsEgxa+tmUS6sS7sNLL67QHC3ez9SGSZlfmretXXdbvXy0Mn7YqJR7nq+frw0Tmbd5sRqen5Ww4t+Q3RgcOe0Vn/6N9p8s24VwSygXWyYGH4/Isg28MmfMVNn4Fan9OwOkDbx3qY9p5XNRs5lbnjFZSkV/E2S3dH0bAW3rbF9WWX8QYJqvurGLF2aGv0OCKP3ruj+JFWDUELvKjsUAcnMG/P6e7aB4tfk7Z7h9QngTLsh0/QFTnR1Uv6SLhl2pDt6WPllAyzLS53id5611SFOgmiQv9K+LxYepMYpJcomjFycahu0EQeo9G3IEzsB+2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AI4PAWvPr0AyRk1V5SPzJf+t7S2uIm5EI/Ql7LMyJIk=;
 b=W2FIy/MhUjKlsBUfOHGpTGEwe20mSmm/ND1ev+EdTWFGm1fjC1gxiqPzmZFYluP6TCpIbDN2B8H76Vn1JPgxEB66tAKv+oSWpxW2+YxDbPMGhjWnYwoFatLXxQKMiBsTaFnyjVchEFvCofSkySvvnlTr9lF5E0Xqzn87HyEMOuLugQMTdsAc5dT+UNrbuN+sazuI0TtDF0GNcmUZydxpY/cZbmwMZjLqmBnTKP2wXSw/R9qwLhFOnuX21dOEgSe/TZ27Kd0wK8C+Ea86AbcKM728Mv5Oo8O/RCLdmRQP3ReuOvNVh09Dj2BWVXMtmIG1TpknhoQYQYhNH0gKGOmfjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (2603:10b6:5:1c4::14)
 by DM6PR12MB3369.namprd12.prod.outlook.com (2603:10b6:5:117::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Wed, 21 Oct
 2020 07:20:22 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::e4a1:5c3f:8b16:5e88]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::e4a1:5c3f:8b16:5e88%7]) with mapi id 15.20.3477.028; Wed, 21 Oct 2020
 07:20:22 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Michal Kubecek <mkubecek@suse.cz>
CC:     Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        mlxsw <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: RE: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Thread-Topic: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Thread-Index: AQHWnxvjfEscixWoTUGw9NLDRcgaq6mTAB+AgAEV0YCAAAzGgIABa6aQgAVHPoCAAh/yQIAB224AgAAXAoCAABA4AIABMK7AgAGKzwCAAAKJEA==
Date:   Wed, 21 Oct 2020 07:20:22 +0000
Message-ID: <DM6PR12MB38651062E363459E66140B23D81C0@DM6PR12MB3865.namprd12.prod.outlook.com>
References: <20201011153759.1bcb6738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM6PR12MB3865B2FBA17BABBC747190D8D8070@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201012085803.61e256e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM6PR12MB3865E4CB3854ECF70F5864D7D8040@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201016221553.GN139700@lunn.ch>
 <DM6PR12MB3865B000BE04105A4373FD08D81E0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201019110422.gj3ebxttwtfssvem@lion.mk-sys.cz>
 <20201019122643.GC11282@nanopsycho.orion>
 <20201019132446.tgtelkzmfjdonhfx@lion.mk-sys.cz>
 <DM6PR12MB386532E855FD89F87072D0D7D81F0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201021070820.oszrgnsqxddi2m43@lion.mk-sys.cz>
In-Reply-To: <20201021070820.oszrgnsqxddi2m43@lion.mk-sys.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [147.236.146.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 716a29d0-f348-438a-3106-08d87591c5f5
x-ms-traffictypediagnostic: DM6PR12MB3369:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3369E8BB97053973F5FDA6DDD81C0@DM6PR12MB3369.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hQAXXPTUJTEoV2tjgMa46iIDXwzPBkQndaSFz4QSIacholXEvyrIzT/lfmupfLC9Q5u/CL/HYCjzkyDs5YjtmP7mox1F3ISGY2osCiyymtZIQRs9vzKFs7VeSXhI1FJER0AqQhmkr7HC1Rp1aTjB8A2DH/dEfKjvNiXM2FTahZ+ZsyfYPlVw83iUCgp/OLjVCSDdx82HWFmW4wLqvSHvptgKoHuldemit3mDIqE7Y3pLIlaaoZ+fZjUfjPtjrgOqvDIrnZaBUgRvxZyx9iuryd7pVA9fTnAekGyFhQXlp10J64lFavxxXIH8gX043L0C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3865.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(396003)(136003)(376002)(66476007)(86362001)(7696005)(52536014)(54906003)(186003)(8676002)(478600001)(316002)(8936002)(4326008)(33656002)(55016002)(5660300002)(66446008)(64756008)(66556008)(66946007)(71200400001)(83380400001)(26005)(6916009)(76116006)(6506007)(9686003)(2906002)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: WTbBEJQnnFLNUi9F8gvpUgQi3DDMtcdkkTo4ostokfsHHLoQr8yYNQr3w5bODvjtnm1LXpmVn2pxuEbhc/3D2mhT7p7Nk3pMrfzVuopcbQ8o5uw74WRhUj8IXwtM+amDbkZLrCIY0TbAQxfMQVxJ+3lC/DLa9YSskAkblr1UCp9m6Ybrhx7NH26Y+mDgw2PhV6O+e30sEjkL/MiT/6EeeGfsyMLn5GtW2DiXhIkDnryQOpuJS03As7i+VOsJm75cW8bzkPL3rUlm985RtbipK/TKNi59LMNqH9yQkQ2ahAtbnl1adZ6AESYGiZZW3Ed71rT281ay9P7wzH0/i1fPh+YqR2YnVTppOtcbgEDsrUYLKK0QxJlDgpIkKuR06IcpAzd/g+abeiR9ypY2QrHwlwKeRVcqpgKnEnVLCWtx9ccuR8Os1bDCyJkWCrRgfPA3PAjzKRd4nE6mIJ+WX4R0X57jKlQDI7EKrCpXa5ty4RzIq5Hi87EVMddkr8j2Arus8lbwUliqCj+uIvwu9S7Gj+YaX6YnmBn2yzwhxUTz0jevV/9EctRppvalX2clTHfnr6tg9aEfCPeZZ6Mb2oF42XLKKDN0UrWEG4P4H221dsbM3Op+AH6O45l0LlPmj+sPjuhVo5yOMQT+BDNH7CfbWQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3865.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 716a29d0-f348-438a-3106-08d87591c5f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2020 07:20:22.4013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xQOBxPFAHei3WgPJJR62gSYTWOX14PHjiKD83LZuAnvW9gm3eBxmbmdRxDn94CAXlRyF9IJgE1A6sz9VN1SiYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3369
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603264825; bh=AI4PAWvPr0AyRk1V5SPzJf+t7S2uIm5EI/Ql7LMyJIk=;
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
        b=S9futPDpGCtmvECAgC9FoMpEAcB4BuMkZwb4aUPx8QvgCaZxBiETvSGQ17lI4sTqJ
         AV/mYNEyajs2duv6PC9NfCVbMznwkcmERH1t43YetiTb0+XzgR8Ws13cs4+ZHkV4Jo
         pakShwwgcGVlKf4/RHeaxPdazuEgwOWBcoSyQ63M3CjLVYj33YGgKfLCHSNNSftduH
         eQj72d3qKvSmVfmv9FVxqouZmT7f+nFaSQwS/eXk9KEvRJRqBJMOGnBksDX8C0FBUW
         MKop/7C0QSu3Pq2Z1ld6vcx7nbB50oCOoCstHK0O+wpbSufYaUz3YLZ82+UTa9/OLx
         HYo78t4B9bQIg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Michal Kubecek <mkubecek@suse.cz>
> Sent: Wednesday, October 21, 2020 10:08 AM
> To: Danielle Ratson <danieller@nvidia.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; Andrew Lunn <andrew@lunn.ch>; Jakub
> Kicinski <kuba@kernel.org>; Ido Schimmel <idosch@idosch.org>;
> netdev@vger.kernel.org; davem@davemloft.net; Jiri Pirko
> <jiri@nvidia.com>; f.fainelli@gmail.com; mlxsw <mlxsw@nvidia.com>; Ido
> Schimmel <idosch@nvidia.com>; johannes@sipsolutions.net
> Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAP=
I
> with lanes
>=20
> On Tue, Oct 20, 2020 at 07:39:13AM +0000, Danielle Ratson wrote:
> > > -----Original Message-----
> > > From: Michal Kubecek <mkubecek@suse.cz>
> > > Sent: Monday, October 19, 2020 4:25 PM
> > >
> > > As I said, I meant the extension suggested in my mail as independent
> > > of what this series is about. For lanes count selector, I find
> > > proposed
> > >
> > >   ethtool -s <dev> ... lanes <lanes_num> ...
> > >
> > > the most natural.
> > >
> > > From purely syntactic/semantic point of view, there are three types
> > > of
> > > requests:
> > >
> > >   (1) enable specific set of modes, disable the rest
> > >   (2) enable/disable specific modes, leave the rest as they are
> > >   (3) enable modes matching a condition (and disable the rest)
> > >
> > > What I proposed was to allow the use symbolic names instead of masks
> > > (which are getting more and more awful with each new mode) also for
> > > (1), like they can already be used for (2).
> > >
> > > The lanes selector is an extension of (3) which I would prefer not
> > > to mix with
> > > (1) or (2) within one command line, i.e. either "advertise" or
> > > "speed / duplex / lanes".
> > >
> > > IIUC Jakub's and Andrew's comments were not so much about the syntax
> > > and semantic (which is quite clear) but rather about the question if
> > > the requests like "advertise exactly the modes with (100Gb/s speed
> > > and) two lanes" would really address a real life need and wouldn't
> > > be more often used as shortcuts for "advertise 100000baseKR2/Full".
> > > (On the other hand, I suspect existing speed and duplex selectors
> > > are often used the same way.)
> > >
> > > Michal
> >
> > So, do you want to change the current approach somehow or we are good
> > to go with this one, keeping in mind the future extension you have
> > suggested?
>=20
> As far as I'm concerned, it makes sense as it is. The only thing I'm not =
happy
> about is ETHTOOL_A_LINKMODES_LANES being a "write only" attribute
> (unlike _SPEED and _DUPLEX) but being able to query this information woul=
d
> require extensive changes far beyond the scope of this series.
>=20
> Michal

If I understood you correctly, patch #5 does that query, isn't it? "mlxsw: =
ethtool: Expose the number of lanes in use"
