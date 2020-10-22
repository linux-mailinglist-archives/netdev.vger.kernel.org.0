Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4602295840
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 08:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503401AbgJVGPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 02:15:53 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:39094 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503372AbgJVGPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 02:15:53 -0400
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f9123970001>; Thu, 22 Oct 2020 14:15:51 +0800
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 22 Oct
 2020 06:15:51 +0000
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 22 Oct 2020 06:15:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bXgnVh4rr3IanEf+JjVMN/WSVdu0DY0LKa7YSSIoHEbudhUqw2cxy2yNRkCe2xyCiXANRZnKHA15CIcVqtNEtLkVwcjLaASefillsFY/BSKDV3+vqoz8alZqFMJDN4kU0WrXmYIkQLUDmXSRDRHP6jmqNYxXKcNCJoYubLPN0J57dIUuSeZHJFPCXzJgryakRAmDCWioCnK31S4UzPMiS/5mA+l3vdZGXgCMmtHQSaAm2zNzqtjTllw/8Ex8VQJlDzLQocrZhaxebEr87PrTIC01cTR/gFpvI4d9vUpBBvjUxFHTqKK9qxxPQ/kSiTVclDaB6XnXHCB4+QljAUH0KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JfeOEycpQLcM7WD2yII9gl9lf32IMY2f8Zx9KialNjE=;
 b=Og1oVZmDSyMh95c5OYV0c+NkHIZxs86ZKmnVAZR/syi+9tDQFxTlnvHbiPBJTkFemCJ0ZnGmGbTd41Wg97imk9A4usp6dR1da481IVL9eNWez1g3GEOjxs/5RzSGtMJ+XDRSE+SnW15LQaA/RYcMi2QW9FOjyu9H89zCbKpP0GgKw7pOdBB7EMTn8Gz8dJHRKYQlPOmhckCAHq/1g7t5M2g4rB3IOXlZGOSPS3opmct1sukTge6iEAu6Jat44vJb1N3gxvdg33OOe9hJHg8xFqggx3iK/J/Uy3BGYfEKaaXTltNQWWVBooI+PU/FNvucGCzvSDObP+7aF5qz3Yo/PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3865.namprd12.prod.outlook.com (2603:10b6:5:1c4::14)
 by DM6PR12MB3370.namprd12.prod.outlook.com (2603:10b6:5:38::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 22 Oct
 2020 06:15:48 +0000
Received: from DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::e4a1:5c3f:8b16:5e88]) by DM6PR12MB3865.namprd12.prod.outlook.com
 ([fe80::e4a1:5c3f:8b16:5e88%7]) with mapi id 15.20.3477.028; Thu, 22 Oct 2020
 06:15:48 +0000
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
Thread-Index: AQHWnxvjfEscixWoTUGw9NLDRcgaq6mTAB+AgAEV0YCAAAzGgIABa6aQgAVHPoCAAh/yQIAB224AgAAXAoCAABA4AIABMK7AgAGKzwCAAAKJEIAAGTCAgAFm0UA=
Date:   Thu, 22 Oct 2020 06:15:48 +0000
Message-ID: <DM6PR12MB3865D0B8F8F1BD32532D1DDFD81D0@DM6PR12MB3865.namprd12.prod.outlook.com>
References: <20201012085803.61e256e6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DM6PR12MB3865E4CB3854ECF70F5864D7D8040@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201016221553.GN139700@lunn.ch>
 <DM6PR12MB3865B000BE04105A4373FD08D81E0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201019110422.gj3ebxttwtfssvem@lion.mk-sys.cz>
 <20201019122643.GC11282@nanopsycho.orion>
 <20201019132446.tgtelkzmfjdonhfx@lion.mk-sys.cz>
 <DM6PR12MB386532E855FD89F87072D0D7D81F0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201021070820.oszrgnsqxddi2m43@lion.mk-sys.cz>
 <DM6PR12MB38651062E363459E66140B23D81C0@DM6PR12MB3865.namprd12.prod.outlook.com>
 <20201021084733.sb4rpzwyzxgczvrg@lion.mk-sys.cz>
In-Reply-To: <20201021084733.sb4rpzwyzxgczvrg@lion.mk-sys.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [147.236.144.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4eabf5c6-fc0a-407d-4927-08d87651eb8b
x-ms-traffictypediagnostic: DM6PR12MB3370:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB337021958DA8AFD547481976D81D0@DM6PR12MB3370.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YydAoXXlFaDYvCH+CF2a6QACoAzQVsHvZlR25a97QFe24p5OxC3eFK952BoxY25daENfR+XPHWNfZ5DwQrvtz/tW0Fz6DetzHyR24FIfz+7igbPZ7yrQUDW1kuAwMlCOqqtxJl4gtusgnK6OKZSgYeUqFb3M5CpymxiNSxB08nTwIi7+qyDG1olEV7PyRzVhX32Y9GGWvoyiiHWviHv5VN4pY5KtJRhoh90pHzLtcRpOmH4gVF3vIeIwoqFv/hvITVDkEQuqCGfH63KqBhWnVpl/vkvFZ/ZvxcYFPeTUWivTamTio3xaZ10pz8GmA9GrpgqAbX6lRUJYuoXUDX48Ew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3865.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(39860400002)(136003)(376002)(316002)(8936002)(55016002)(53546011)(7696005)(478600001)(26005)(8676002)(6916009)(86362001)(33656002)(6506007)(186003)(2906002)(71200400001)(5660300002)(54906003)(66446008)(64756008)(66476007)(66946007)(66556008)(76116006)(9686003)(83380400001)(52536014)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: xWOI9Rg6ZqthVA+F113vfkJMQtDpzs+hhklFIBRFuSv6FkR2aewo5wqh0F84f6ZboZR8ovv4mHgICljCxE6kHAZSxM6h/BtoPoXLk4KJ5vmxPPf1mpUd2JBCb/CrGbKYMy2IsrmzV2D1YggvIMKdSWvE6sJw9+tJX44g/fKTZybqy/vQ06GhpQo9+KFLc3fc4B6aFLZ0SQnIOfwm1g8kvF6Q7zNAg973K2TLVsrFXZ6LMxPY4bVpsjLdc1//FbWZxjtgKnpj4ZC2zDltDyZ9Sg3LMYKu4k29iTpR5vi4Ax99xte5e5hlH4MVdmTTvCS9VeuT/hASXIphM7ATv8tL2IyHRjzBxsf202RGTijF7rlUTFWxKcBA5sV92KOo3VekCl/8dsjBA7KTDyHLZZjId3jh2DNQcSMsurOwJYl/bzvcBOzvN+46Z/E6WtiOcvFwZeP3jmhbrkCbDZRFr4sAbuWg6e75742TTi0uWmGJeBEjoMaWiUwu1nIOMUK8Lm9b5O1UEr4/7cMzhMFeFkL2wsSxdo9OpX5Iiy3m8h/Z4RpdmUJm2GqZpa6hix0pUckX6JplKhqdjjU6ECRxlWxq3yfu00+eTUWdijm5whm62bgC0Zyvt59+Y2z1IXXZsefApF7Ih+Kl5dZ5l4mf7tOdTw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3865.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4eabf5c6-fc0a-407d-4927-08d87651eb8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2020 06:15:48.8538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yk5UGShGS6SXfIcW/kbbnpjkyVD7EVhWqgQwK2QjV7NnHwRRMnvdF3WfZUIWcfjQrW6lpxGbaIqcz1l44SzFKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3370
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603347351; bh=JfeOEycpQLcM7WD2yII9gl9lf32IMY2f8Zx9KialNjE=;
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
        b=JzCxWpEJ1cV9ZyGjqf49zDkirbSSwmCXfE7Pea3UJYtrWuip8wv80XnALRuaXjo8c
         mityeUjtOujKuMKucprys7R+AhaZV9eWiQTmXcsoQSf/DhJLx2X+wLn4mgUTVQthNB
         HlXl9BVMXHGNfDRbLgEsJ6lHBl3SzweOddEGTRNRafMBManUGYr5AWBofYHEMD8EX9
         acMQU97jrnDrsaqSmfc6o6TNof0YMU18OBzKV8WDuueL0ZscrJhY9vciE8v74TGyJW
         wTfxfpXC0qgH9hSIdmWdXre6utPn7jCp36d16RHgeXCkxFDFAIhgN3b752VpYhjYBx
         XVKdt8vmIkrmQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Michal Kubecek <mkubecek@suse.cz>
> Sent: Wednesday, October 21, 2020 11:48 AM
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
> On Wed, Oct 21, 2020 at 07:20:22AM +0000, Danielle Ratson wrote:
> > > -----Original Message-----
> > > From: Michal Kubecek <mkubecek@suse.cz>
> > > Sent: Wednesday, October 21, 2020 10:08 AM
> > >
> > > On Tue, Oct 20, 2020 at 07:39:13AM +0000, Danielle Ratson wrote:
> > > > > -----Original Message-----
> > > > > From: Michal Kubecek <mkubecek@suse.cz>
> > > > > Sent: Monday, October 19, 2020 4:25 PM
> > > > >
> > > > > As I said, I meant the extension suggested in my mail as
> > > > > independent of what this series is about. For lanes count
> > > > > selector, I find proposed
> > > > >
> > > > >   ethtool -s <dev> ... lanes <lanes_num> ...
> > > > >
> > > > > the most natural.
> > > > >
> > > > > From purely syntactic/semantic point of view, there are three
> > > > > types of
> > > > > requests:
> > > > >
> > > > >   (1) enable specific set of modes, disable the rest
> > > > >   (2) enable/disable specific modes, leave the rest as they are
> > > > >   (3) enable modes matching a condition (and disable the rest)
> > > > >
> > > > > What I proposed was to allow the use symbolic names instead of
> > > > > masks (which are getting more and more awful with each new mode)
> > > > > also for (1), like they can already be used for (2).
> > > > >
> > > > > The lanes selector is an extension of (3) which I would prefer
> > > > > not to mix with
> > > > > (1) or (2) within one command line, i.e. either "advertise" or
> > > > > "speed / duplex / lanes".
> > > > >
> > > > > IIUC Jakub's and Andrew's comments were not so much about the
> > > > > syntax and semantic (which is quite clear) but rather about the
> > > > > question if the requests like "advertise exactly the modes with
> > > > > (100Gb/s speed
> > > > > and) two lanes" would really address a real life need and
> > > > > wouldn't be more often used as shortcuts for "advertise
> 100000baseKR2/Full".
> > > > > (On the other hand, I suspect existing speed and duplex
> > > > > selectors are often used the same way.)
> > > > >
> > > > > Michal
> > > >
> > > > So, do you want to change the current approach somehow or we are
> > > > good to go with this one, keeping in mind the future extension you
> > > > have suggested?
> > >
> > > As far as I'm concerned, it makes sense as it is. The only thing I'm
> > > not happy about is ETHTOOL_A_LINKMODES_LANES being a "write only"
> > > attribute (unlike _SPEED and _DUPLEX) but being able to query this
> > > information would require extensive changes far beyond the scope of
> this series.
> >
> > If I understood you correctly, patch #5 does that query, isn't it?
> > "mlxsw: ethtool: Expose the number of lanes in use"
>=20
> Ah, right, it does. But as you extend struct ethtool_link_ksettings and d=
rivers
> will need to be updated to provide this information, wouldn't it be more
> useful to let the driver provide link mode in use instead (and derive num=
ber
> of lanes from it)?
>=20
> Michal

This is the way it is done with the speed parameter, so I have aligned it t=
o it. Why the lanes should be done differently comparing to the speed?
