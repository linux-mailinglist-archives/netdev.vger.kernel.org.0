Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09AF62935ED
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728791AbgJTHjQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:39:16 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:19356 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728263AbgJTHjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 03:39:15 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f8e93c60000>; Tue, 20 Oct 2020 00:37:42 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 20 Oct
 2020 07:39:15 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 20 Oct 2020 07:39:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F9OaNooAKYyy+O1Wc5RaRoRd6LMGSM2C+ivukkZbWgYN3w38qo1ou5xmeW9lFLmHP5IiRC/wOMX0myAX/ynFoRGrJYkWBRnweTzFmXY046mKJGU1fAf7zMIRzeObc+76WfqK2C+GI24MUplLgmqcfHak3hBhQPHKKoSKUOdyDOebjs4uJe2PYgoZ5m+O/YSGYmHQ5OcScb7W97hFa5UnX5KCbwxuCqWVlrQPm/d9aDq34WPlLZIkx0uPb82qHrYhk8LV5/CkuChhClFalYEBYIyHVOajl0Z/662vHXkgSFtM+abqs+AovcPREnXOWHC5JXkx0M92C57q59X+KllwWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AmNQP4oPz7FijQ1ELmvO3Vf4lD/ARMaL8EfO48+UzPQ=;
 b=HV9IcxFFMUbS1f9rZNmHIUr3+elOM3EvxgJNAlrWOiO8FBncion8t3xSErDz+GgDiOFlbxj5dlFpUc59sR0fIEmOhPqxXfq2oFLiWdFrl+yKo3r5GiCGNd72iDvwAFgCZDvPMZqhx3nioFpLMkkB1yPT/5iQ9141cONoC4EV1McRjOkFjDShFLgMf2Tqlz3ghSTOA3LMRgPewL/o+y8lO7jGiGM8UnLwF3S2JQ4oVWcSpdUoAttQPOTtef7gwJHNeV6NoJ/Q6+nYoMvgKVktEeaLhoG8p4id4tX2as2d+yS0yWr1S3WgGq/tLHPnVN/IxAxw5WLAV1o72Up9CHEDLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (2603:10b6:5:1c4::14)
 by DM6PR12MB4987.namprd12.prod.outlook.com (2603:10b6:5:163::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Tue, 20 Oct
 2020 07:39:14 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::e4a1:5c3f:8b16:5e88]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::e4a1:5c3f:8b16:5e88%7]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 07:39:14 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Michal Kubecek <mkubecek@suse.cz>, Jiri Pirko <jiri@resnulli.us>
CC:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        "Ido Schimmel" <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Jiri Pirko" <jiri@nvidia.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        mlxsw <mlxsw@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: RE: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Thread-Topic: [PATCH net-next 1/6] ethtool: Extend link modes settings uAPI
 with lanes
Thread-Index: AQHWnxvjfEscixWoTUGw9NLDRcgaq6mTAB+AgAEV0YCAAAzGgIABa6aQgAVHPoCAAh/yQIAB224AgAAXAoCAABA4AIABMK7A
Date:   Tue, 20 Oct 2020 07:39:13 +0000
Message-ID: <DM6PR12MB386532E855FD89F87072D0D7D81F0@DM6PR12MB3865.namprd12.prod.outlook.com>
References: <20201010154119.3537085-1-idosch@idosch.org>
 <20201010154119.3537085-2-idosch@idosch.org>
 <20201011153759.1bcb6738@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM6PR12MB3865B2FBA17BABBC747190D8D8070@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201012085803.61e256e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM6PR12MB3865E4CB3854ECF70F5864D7D8040@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201016221553.GN139700@lunn.ch>
 <DM6PR12MB3865B000BE04105A4373FD08D81E0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201019110422.gj3ebxttwtfssvem@lion.mk-sys.cz>
 <20201019122643.GC11282@nanopsycho.orion>
 <20201019132446.tgtelkzmfjdonhfx@lion.mk-sys.cz>
In-Reply-To: <20201019132446.tgtelkzmfjdonhfx@lion.mk-sys.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [147.236.146.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9175f541-1a33-41c5-1157-08d874cb3e04
x-ms-traffictypediagnostic: DM6PR12MB4987:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB498745ACE3A004AE30EE763AD81F0@DM6PR12MB4987.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V0Ee7SHKESEjCZ/OtM9SiR5cfYB765yr8R1V1gMmUrKa0GLjFEfsdoMP5Ztr4JqPeNa0ejNQHxVeerOjVg+piRes0zZ2LfZg7dOl1hvzMttRX30+jN2FtaSO0Jeii8v401vsP4DFLVikmCp6KdFFghxiENuXfe9EQ27t1QHett+jr+alghhKkjcztSCM79o43Gz7DQqreKRDP5AWsEf+akWYnTYKXRcjtsc8goaOmHzPLy32hG5o1Fp8+wZwabDpqfZ71TBdtGFAHUb7o5k6B2XluF7fLdopj5hHSiVyaTh8x0rKHeiMgzR5Yovogh3MMu87DRaRkyAmZ4E9Y0rdDQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3865.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(376002)(136003)(366004)(7696005)(83380400001)(53546011)(8676002)(71200400001)(54906003)(8936002)(316002)(110136005)(6506007)(64756008)(66556008)(5660300002)(76116006)(66446008)(52536014)(66946007)(26005)(86362001)(186003)(9686003)(2906002)(33656002)(66476007)(55016002)(478600001)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: DFr8lMSlIn3fn9fRe06pAebFKlK/xhbHvLd0RjEo8NTsXl5SveurdLmPaxJyoLxIw/cYPZhvwy+EHffBmw/iNZFZO2SL6g9m2RrjMPuCVREoYjYAs807x2cqkgGqS96qqI5alMWzs5NThXVxNreXskFVewffCUsm9v8N+bTqCpeVqQV9E1cJD6v2Ah2joST4x22V37UO+pXucM5Afs1pWlOlCwiO5cr+j6f87XVXmB8PsAeoV9iQ8TlIXOIB1PdgAnt4/M2VhZlf28jJAWxNFumPJ2nNeU2B7rqZAmB9RfZitPwpCXamzaA7F17WoDdUmsczYU25pGixfR9FUFN9no5BCMVbb/UwgfXlbQY/CB81NOiKlnJGgaLIFMyMS/M7tSXUXy8R71CONmjQjfR6LHFAfYZUKl+gzErF3N12dlWiEHg5vxJIE36LYMeshm5Ve24b1Wn0voFS3T+jEb6K55KkHr/cb3Kky4gleStKoVD6liIWtk4BlxwPbOanuEETdQhtu9m2yt+RMnjFc1tdeLT/Y1e9gNeDVYjQUCpebFY2DDxYJAdJFKDvV5pF7vss04APVFuEPPbbA2HvlAH/ScFzbnwk7pYacJv8LbC6jcq2Ei5uD14hG9ACBjtoq7Q7V9pmQwH5WzaWSf/GPhPGNA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3865.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9175f541-1a33-41c5-1157-08d874cb3e04
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 07:39:13.8993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yxa24ZdLhMpd2CPrI4H70mEJDxV3BL1G7A7TuJfCByEwdyslBao86+blQ2qB3oge+Qlxf3RaKro5hikHbHvvvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4987
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603179462; bh=AmNQP4oPz7FijQ1ELmvO3Vf4lD/ARMaL8EfO48+UzPQ=;
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
        b=EgKw1xNsUxiM2LNl4AxZsPeMA0f1+IjSFx7+QhO8puwC1a/0YOAg1h3YijMlJl9dR
         Sp8ck19C7eusk6fCi62J451IJuFG1uJT6MTlSLolvgKK93PgvPV+Md4QKOWTxUZCpY
         kv+yx8AA2Rm3uZQmn44oQ93PLo7GTfCqOE33bQ016HdndhQi0HxYCL/uRB1jI+98oY
         wjgSd8bS9177Cf43JsEWr6GQv/Kid/rYY6/M6H/mF8z9ILLACXJIiWR1xLawx6SqgW
         c3CPR+s9YrfcVQjeiWmrJePlayF2sc+bU8OpGFxmN6581LAr4/NZ7avTj+//Z7+oxN
         dbW2I76L7GtZw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Michal Kubecek <mkubecek@suse.cz>
> Sent: Monday, October 19, 2020 4:25 PM
> To: Jiri Pirko <jiri@resnulli.us>
> Cc: Danielle Ratson <danieller@nvidia.com>; Andrew Lunn
> <andrew@lunn.ch>; Jakub Kicinski <kuba@kernel.org>; Ido Schimmel
> <idosch@idosch.org>; netdev@vger.kernel.org; davem@davemloft.net; Jiri
> Pirko <jiri@nvidia.com>; f.fainelli@gmail.com; mlxsw <mlxsw@nvidia.com>;
> Ido Schimmel <idosch@nvidia.com>; johannes@sipsolutions.net
> Subject: Re: [PATCH net-next 1/6] ethtool: Extend link modes settings uAP=
I
> with lanes
>=20
> On Mon, Oct 19, 2020 at 02:26:43PM +0200, Jiri Pirko wrote:
> > Mon, Oct 19, 2020 at 01:04:22PM CEST, mkubecek@suse.cz wrote:
> > >
> > >It would be quite easy to extend the ethtool command line parser to
> > >allow also
> > >
> > >  ethtool -s <dev> advertise <mode> ...
> > >
> > >in addition to already supported
> > >
> > >  ethtool -s <dev> advertise <mask>
> > >  ethtool -s <dev> advertise <mask>/<mask>  ethtool -s { <mode> { on
> > > | off } } ...
>=20
> This should have been
>=20
>   ethtool -s <dev> advertise { <mode> { on | off } } ...
>=20
> > >Parser converting simple list of values into a maskless bitset is
> > >already there so it would be only matter of checking if there are at
> > >least two arguments and second is "on" or "off" and using
> > >corresponding parser. I think it would be useful independently of this
> series.
> >
> > Understood. So basically you will pass some selectors on cmdline and
> > the uapi would stay intact.
> > How do you imagine the specific lane number selection should look like
> > on the cmdline?
>=20
> As I said, I meant the extension suggested in my mail as independent of w=
hat
> this series is about. For lanes count selector, I find proposed
>=20
>   ethtool -s <dev> ... lanes <lanes_num> ...
>=20
> the most natural.
>=20
> From purely syntactic/semantic point of view, there are three types of
> requests:
>=20
>   (1) enable specific set of modes, disable the rest
>   (2) enable/disable specific modes, leave the rest as they are
>   (3) enable modes matching a condition (and disable the rest)
>=20
> What I proposed was to allow the use symbolic names instead of masks
> (which are getting more and more awful with each new mode) also for (1),
> like they can already be used for (2).
>=20
> The lanes selector is an extension of (3) which I would prefer not to mix=
 with
> (1) or (2) within one command line, i.e. either "advertise" or "speed / d=
uplex
> / lanes".
>=20
> IIUC Jakub's and Andrew's comments were not so much about the syntax
> and semantic (which is quite clear) but rather about the question if the
> requests like "advertise exactly the modes with (100Gb/s speed and) two
> lanes" would really address a real life need and wouldn't be more often u=
sed
> as shortcuts for "advertise 100000baseKR2/Full". (On the other hand, I
> suspect existing speed and duplex selectors are often used the same way.)
>=20
> Michal

So, do you want to change the current approach somehow or we are good to go=
 with this one, keeping in mind the future extension you have suggested?=20

Thanks.

