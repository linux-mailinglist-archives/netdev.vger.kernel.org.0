Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD122CA984
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 18:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403773AbgLARXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 12:23:31 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:53967 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387840AbgLARXa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 12:23:30 -0500
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc67be90001>; Wed, 02 Dec 2020 01:22:49 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Dec
 2020 17:22:49 +0000
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.49) by
 HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 1 Dec 2020 17:22:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eO2NnFrHGRAA7hy4B5O6kdcvWRYPXJGHxHGT7QSYjK5j7zdPjJpnZlP25okkh0VxKeiqVtiiyTdNBZ8GaMMEb/1ZMQ6jNmxbfOXGjmvR8gL6LZ9C7dPGAvcQsXYF10S4mD0LkoyIeYpetagu+gabgnL/USTH6Q5t7Bx02ryYImG7rmqo40I6s7L2Nxzx1XZFIy7/kHrcp1D6Lgg1c/RfTEXn7JaJrVVQ5/SCjTZSN0JIoyb3VvUa6R2YOx4bZcK8Ro4TZxbkNyu4m1S5375xX+Yd2zBzYTpn12fo3vQ7fH6BnacefwQA8qfEXf72JBXdaIW2XvuUfUXO6+GT+xsZGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vp4VNyO5aUMtshao+u3QjATpohhade8YPhGvxqBdDkk=;
 b=ezTNr9zzKOfO0WsUwtugUhqAooroiiO9qGV7UXGCXBum/bxoxZX4QNuWtDGxy8qsMwHup1F1AsgxTPB7ExXejexQbmBxfa8qjsRkgu9sIksz3hc5IxZCTjZyHduM9iNmLsecRKXpod5ptj87g/3E39qbeRdD+hcdMTWSVN8LDkX2BZN4p3NUelGuGE7rBgrLaw3f6Q1+d+ipNFhvcXH1tAHwd4D23o/2vr4NY4hcafHgk44s0Wl1NrtSe2AKaE6Cw/j2j+d8zxd/7qxHVesNceeQp+eHPkWm0TvXzty7kj37nVLzZm7I4HbwabvZoH0xguv6J3FbaXxKnOe8kbq6Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20)
 by DM6PR12MB3580.namprd12.prod.outlook.com (2603:10b6:5:11e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Tue, 1 Dec
 2020 17:22:44 +0000
Received: from DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::3d2b:e118:ac9b:3017]) by DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::3d2b:e118:ac9b:3017%5]) with mapi id 15.20.3632.017; Tue, 1 Dec 2020
 17:22:44 +0000
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
Thread-Index: AQHWnxvjfEscixWoTUGw9NLDRcgaq6mTAB+AgAEV0YCAAAzGgIABa6aQgAVHPoCAAh/yQIAB224AgAAXAoCAABA4AIABMK7AgAGKzwCAAAKJEIAAGTCAgAFm0UCAAKwSAIAx19swgAJlZ4CAAMul4IACRvcAgAeXtWA=
Date:   Tue, 1 Dec 2020 17:22:44 +0000
Message-ID: <DM6PR12MB4516576B5D5B225540A1C877D8F40@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20201019132446.tgtelkzmfjdonhfx@lion.mk-sys.cz>
 <DM6PR12MB386532E855FD89F87072D0D7D81F0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201021070820.oszrgnsqxddi2m43@lion.mk-sys.cz>
 <DM6PR12MB38651062E363459E66140B23D81C0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201021084733.sb4rpzwyzxgczvrg@lion.mk-sys.cz>
 <DM6PR12MB3865D0B8F8F1BD32532D1DDFD81D0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201022162740.nisrhdzc4keuosgw@lion.mk-sys.cz>
 <DM6PR12MB45163DF0113510194127C0ABD8FC0@DM6PR12MB4516.namprd12.prod.outlook.com>
 <20201124221225.6ae444gcl7npoazh@lion.mk-sys.cz>
 <DM6PR12MB4516B65021D4107188447282D8FA0@DM6PR12MB4516.namprd12.prod.outlook.com>
 <20201126210748.mzbe7ei3wjhvryym@lion.mk-sys.cz>
In-Reply-To: <20201126210748.mzbe7ei3wjhvryym@lion.mk-sys.cz>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [89.138.231.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bed55567-0a38-4b31-410e-08d8961db776
x-ms-traffictypediagnostic: DM6PR12MB3580:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3580DF93181CF13FAF82215FD8F40@DM6PR12MB3580.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1jHQMDrjvFMYCjhVh6C3LEnV9ndFj4vRFzEJfDJIvP9UAADKjs6p0ABiuhDwX8jxWgG1+WjZZXyG1kcnPTDGGvALTuAgGUuLi4SDnuExGpQrNOdQVU8u532ny/rWNt+2hwmFvyyChwmZ85Yye/jjWzpdumF7JJAwLN87V7LWFa5CG/WhWaVdEGt4/n11czsxR6PQ78kt8071MOcVnzKmIZD9FWRnocLMSFcVIPq7n9DU2BVxgyr6IttxN9x+75toowi15lrhmlPcij3eKZ5pJ2wLTZA3EHu5oQoet2NF1b1eRSk8i2kCCcEMIfkURlGSnuaVC6NBo47aixskzMRv2w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4516.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(346002)(39860400002)(136003)(8936002)(71200400001)(26005)(8676002)(76116006)(2906002)(7696005)(66946007)(66476007)(186003)(83380400001)(86362001)(64756008)(6506007)(53546011)(66446008)(66556008)(6916009)(54906003)(33656002)(5660300002)(52536014)(9686003)(4326008)(55016002)(316002)(478600001)(19627235002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?H30OkK87u/+KYhBqgp1oaoFAE21KPlg9Be58jkT+57BF0lEPzAuwXs5r5XGh?=
 =?us-ascii?Q?kqCVKjjHSxUPiZ1XZWt5wjVXPYzFmtprkUffscpqpUPMg18O2M11ImMFi0/u?=
 =?us-ascii?Q?EbYa5mDg6n8K80smzpQukQnRIAxPbR2+vfKWzKifKZ9VsjmcdRqwFPysGNuP?=
 =?us-ascii?Q?wFt1Q7hn0xG2Kjm7Id5kRZrQKfGU3AKBjiCZU+w7y5aRkFp5sAledaINBoer?=
 =?us-ascii?Q?sla4XaSvYN68LPPrXDasSuw/JOuCWpcMoHPbY+9Qs6sujA78MgrNvuAhIJCd?=
 =?us-ascii?Q?p/O8o/K6ckUTe9+TFsotvC3XkpcmGw2hoKbRbfdXVgS3Kq1IR7WbXomfRzyY?=
 =?us-ascii?Q?pJKxMW3sLKrwxPJqDmzMlMG7VvBpQDwPSWP4HuwMBwuE3g/sD6SuW/ub/oHU?=
 =?us-ascii?Q?4qvqXRxNniOTy/F6UAphVrgcrmJ6t3N/bVqXO6ux8WNqId7yt47B6eFXJqlw?=
 =?us-ascii?Q?F40s0SDwmfFFKomXKEt4kx4Hd+lqIDpkel/61hl5mfjCTuVRyyTwa/FiYtfe?=
 =?us-ascii?Q?/GDns+/CPqdx6nUN1GG3I3XnCg0teHvoPzrSRewJcPhJ4+K1mCMrb4IgZKNq?=
 =?us-ascii?Q?efENEOQxBarktoYrVppi+8mFhwOEREY1uNEzvNUHsDDQICZwb53ETwaOm7zn?=
 =?us-ascii?Q?1FhvZrbrG9L2pqeagt1dtuXi35Jz1dLLHMKI54TAoYZ6ZFC02+AAoA6rL1Vo?=
 =?us-ascii?Q?MWTKbOfF3VlzijlVg6tYUMoDHUF+nsWYC6ahnjBeOIs0ol174MnEQDDeC2oM?=
 =?us-ascii?Q?81OPtx+5gZo20q8cv0xPDl0ETG3SAZ9GIL2fD6o0bdUJqb+LWCWsXocXORwn?=
 =?us-ascii?Q?RgOZYHEf+T7Uaq6298WYSrcMuVgEzQ6cCy3vVnMVa23H6fxHWT2rHCg0l/LU?=
 =?us-ascii?Q?6wx01WVJurwiI3sKWisnzYpe0thOLfVGP3euKFuZZ1Dk5rOsKjxVd4hF+3VI?=
 =?us-ascii?Q?gy9pKv+hLUlJUucD1JOBabKMIwFnodxO4/G9qlwMLCc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4516.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bed55567-0a38-4b31-410e-08d8961db776
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2020 17:22:44.7988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /EJ20BYGDjpyjLWradQrJ46S4O+Ir8Bh8Bcg2uEPrYguHC1Fn0GJvRGq7/pmn3OziYMXsb8RqfhXBaoPBhRwxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3580
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606843369; bh=Vp4VNyO5aUMtshao+u3QjATpohhade8YPhGvxqBdDkk=;
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
        b=jibOV20Thlc09284eC2Zi6LEAju0bXx7Spssh/LKWXZX2yhX8hLJFSuCHiD+Ub5fo
         jZesXimmESZFXu7OeXkYZm17cgAILu13QnnQ+PeZO1h+QY/wXF+Njoss4RJQcc25JF
         vdHf8JQTaTeVNJA/SAyU9NNld09092pvFX7oFm41ocXLbEh3bOHGe02jUXu3qmiEYK
         Mr2trbXSO3FAinOi5N6v83PUS6EAjwlcgGexA0Mdy1WkSb8x047htoqHbi07fhMDt9
         GNjVqydKnvVWDCRX4Vw9yE2AB6LOtAN9zm/Ch8vGrbduyaUE+td8MYxuKcoWC/KaL1
         PZXnE+kZte2Xg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Michal Kubecek <mkubecek@suse.cz>
> Sent: Thursday, November 26, 2020 11:08 PM
> To: Danielle Ratson <danieller@nvidia.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; Andrew Lunn <andrew@lunn.ch>; Jakub Ki=
cinski <kuba@kernel.org>; Ido Schimmel
> <idosch@idosch.org>; netdev@vger.kernel.org; davem@davemloft.net; Jiri Pi=
rko <jiri@nvidia.com>; f.fainelli@gmail.com; mlxsw
> <mlxsw@nvidia.com>; Ido Schimmel <idosch@nvidia.com>; johannes@sipsolutio=
ns.net
> Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAP=
I with lanes
>=20
> On Wed, Nov 25, 2020 at 10:35:35AM +0000, Danielle Ratson wrote:
> > > > What do you think of passing the link modes you have suggested as
> > > > a bitmask, similar to "supported", that contains only one positive =
bit?
> > > > Something like that:
> >
> > Hi Michal,
> >
> > Thanks for your response.
> >
> > Actually what I said is not very accurate.
> > In ethtool, for speed 100G and 4 lanes for example, there are few link =
modes that fits:
> > ETHTOOL_LINK_MODE_100000baseKR4_Full_BIT
> > ETHTOOL_LINK_MODE_100000baseSR4_Full_BIT
> > ETHTOOL_LINK_MODE_100000baseCR4_Full_BIT
> > ETHTOOL_LINK_MODE_100000baseLR4_ER4_Full_BIT
> >
> > The difference is the media. And in the driver we shrink into one bit.
> > But maybe that makes passing a bitmask more sense, or am I missing some=
thing?
>=20
> But as far as I understand, at any moment, only one of these will be actu=
ally in use so that's what the driver should report. Or is the
> problem that the driver cannot identify the media in use? (To be
> precise: by "cannot identify" I mean "it's not possible for the driver to=
 find out", not "current code does not distinguish".)
>=20
> Michal

After more investigation, those are my conclusions:
We have two types of supported asics in the driver- one of them is able to =
distinguish between the medias and the other one doesn't.
So in the first type I can send one bit as you requested from the driver to=
 ethtool but in the other one I can't.

The suggestions I have are:
1. Add a bit that for unknown media for each link (something like ETHTOOL_L=
INK_MODE_100000unknown_Full_BIT). I am not sure it is even possible or make=
s sense.
2. Pass the link mode as bitmap.

Do you see any other option?

Thanks.

