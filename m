Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEADE308A97
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 17:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhA2Qrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 11:47:45 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:6406 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbhA2Qqq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 11:46:46 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60143bcc0000>; Fri, 29 Jan 2021 08:46:04 -0800
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 29 Jan
 2021 16:46:02 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 29 Jan 2021 16:46:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hUIPHmmyJA3y1gSEYyDndMzJSDzgw2/k5UutuQAHbpL1TfgP+GLRlcCs+l4shPEySS+WOdOeQY0biFAD/eQR/05+d/u55X+1xJwXTskwcnFyHfwuRhTk1LYHSsxiwvhfRYtIKwTMhvltL6Jy2RQ9BgoFiXuBVCHGXJNY2XNkX0D29z81Uk9zC4uEhOcPg7EM+jwL0tGQkSUXB9CsJcxwlTVQZl7uIRZX4aI6wrjEDU+3Zq3wUmwlwp0O7Lzb/DV49YT2dauzy7zMHF+fuZpZdrPBkfprOBVDTbQUn/4XtnpRusHFguf66KwQ79lRuc7Pn09A4RtVxfHk4lzql6uUWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=djeF+Fc4WMsNXcREduhEPvJAPawTHivgT0qk4CVruck=;
 b=a2vOx33XuoYAoy3xOVXSMyxGstf542YQfolIjD1FeuczTsq8Xg0OJpUZczknzdgLNAQzIkH9Aqtr6TTAbau+JmLpl4ewAM9rb9uYKfqDKt9Qhl0kZNQrLG9G41H5a650ZNcJ4W7iPn1A8z7esN5FOw/NvGco+pupBMcl0sqjfZI6xNLp1eG1WNdYemJnF/z4MGPdtE1N+eSrPwToAPcICbFinYhqwKTq3Gom/VqtpPXwQKhaDS+mhButwQnX7qzdOM0+zLa7bqYTv1qDjVHUfZUc/CMvbrAACoNQEX4vLwNer6Ge7jxfmst7cA4Z3OCmxUV6i7M4YMem1BrpJ0khoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3898.namprd12.prod.outlook.com (2603:10b6:5:1c6::18)
 by DM6PR12MB3562.namprd12.prod.outlook.com (2603:10b6:5:3c::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Fri, 29 Jan
 2021 16:46:00 +0000
Received: from DM6PR12MB3898.namprd12.prod.outlook.com
 ([fe80::7c6c:69b0:b754:6963]) by DM6PR12MB3898.namprd12.prod.outlook.com
 ([fe80::7c6c:69b0:b754:6963%6]) with mapi id 15.20.3805.019; Fri, 29 Jan 2021
 16:46:00 +0000
From:   Vadim Pasternak <vadimp@nvidia.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>
CC:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        Roopa Prabhu <roopa@nvidia.com>, mlxsw <mlxsw@nvidia.com>
Subject: RE: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Thread-Topic: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Thread-Index: AQHW89cbBm2CVziWp0eDzOc4A9t606o57k8AgAEuPYCAAGk/AIABLb8AgABlU4CAAR3VgIAAjksAgAAOlIA=
Date:   Fri, 29 Jan 2021 16:45:59 +0000
Message-ID: <DM6PR12MB389878422F910221DB296DC2AFB99@DM6PR12MB3898.namprd12.prod.outlook.com>
References: <971e9eff-0b71-8ff9-d72c-aebe73cab599@gmail.com>
 <20210122072814.GG3565223@nanopsycho.orion> <YArdeNwXb9v55o/Z@lunn.ch>
 <20210126113326.GO3565223@nanopsycho.orion> <YBAfeESYudCENZ2e@lunn.ch>
 <20210127075753.GP3565223@nanopsycho.orion> <YBF1SmecdzLOgSIl@lunn.ch>
 <20210128081434.GV3565223@nanopsycho.orion> <YBLHaagSmqqUVap+@lunn.ch>
 <20210129072015.GA4652@nanopsycho.orion> <YBQujIdnFtEhWqTF@lunn.ch>
In-Reply-To: <YBQujIdnFtEhWqTF@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [46.116.167.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 26bd1c40-3b2d-4b75-6c55-08d8c4755bb1
x-ms-traffictypediagnostic: DM6PR12MB3562:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB35622B3BA36B5B58436CCD28AFB99@DM6PR12MB3562.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qYZ+VkxtyR8PiLPPpg81X7OYe5ajoqDlkZXK9vKZEDOEsWh4fmV1aIfLsyS0tP/F3yCXKTvhEo7TfxfEtDPV7ahGXF/NN/Zi5l5d3sVeq7mWwfe77u5EpKhQ7lQJEZikYTSinzB5sPTW5DfwVcQ+ToUz9BtACGMtVI1mLgoi5nx318dNE/jdblnh2tyA0jR6L3mUy7YIoge6BIYKqJjJCWXbktatddhFEe93HSG+QZ8laztT5jhURBZkuS//slpU7k7jdbOBSZFSVsAnqOqdtj/93EftPI6g8CcpKDrHwH18th3np9+Nb9Yt0ClirXwf04IRRsF07YHtZn8EhPhOE+AnZL46sn2wysWDcO+n46Xjvmq/8VcXvEs+ImUFv1u5By3YrmazD7Qqa+gzl9xbBARzxNv08McUPZS8tFc+Hw3piJE62F3C/tl2EDArX4oWL2+Tw8medSHPGD6gy4gF+ob/ywJGsUG488cElNmoNggKQ3zsfbNFrE0lDCN0qx7x3m1Ajj/dXIHhPUL3j1T/8Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3898.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(366004)(346002)(39860400002)(54906003)(8936002)(9686003)(478600001)(76116006)(316002)(26005)(8676002)(6506007)(186003)(66476007)(107886003)(110136005)(66574015)(83380400001)(66446008)(64756008)(86362001)(66556008)(66946007)(2906002)(4326008)(52536014)(33656002)(53546011)(7696005)(55016002)(71200400001)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?kSR6Hhf7LMNhem538F0XJazcBjxcz1V6q3EBVM2gkov1SNKamsX1j2y07gFC?=
 =?us-ascii?Q?5n0uU1BMSNfZaFZzvXm8noaHnhvmlY0Dk+YR/q0A32Fe4EF85CF/Ihf2+q2s?=
 =?us-ascii?Q?NsOcqjrC5YnOimSJkPBl0snWxyhAWHjQgZHBpInNPhoRVWq4MHXbCY0XnDRr?=
 =?us-ascii?Q?lleCTE4rDOOQCd8NY3MClnkKJEZj2T/CtPt4Yx868UHgZpd9app7n7lyygo4?=
 =?us-ascii?Q?1ogdsTLwDjNdPoknvRU1kkt1bwpko56O3JwQ02rUe6k11NCcAZVeJqe/zlFa?=
 =?us-ascii?Q?QK1N0x8XVgpWVYg9L4kRLVTgw2Y0ub3cXxyg7is7DIOTWuqWEisALzJTt9QV?=
 =?us-ascii?Q?kK1HZUnYPJhg/K6qDD5eAZ2H2Ct3vRfsw3kkcTl1AdT4Sh01j3p3uLkGklIm?=
 =?us-ascii?Q?kkhazfAmGBnC5jonvQKwCSO+g9FhhWo8bxNkLsKxzSQ9Mo+LOj1exkEWGQxq?=
 =?us-ascii?Q?day4243Dqlhk5ulwgg5RAWynYU3n0lwxSf87DNnaoBgNVebPCMwtLs+xjq7D?=
 =?us-ascii?Q?D3hQheu5oKWdHI7ocH4VtedTnGUDoQf+p+UbKZk27j162VS8RjM9yztAuw6O?=
 =?us-ascii?Q?41HRxp7FmnXYYs0GtlMMrgrr70VYA3Wm+xrK9ZqWhKZCYaeIgnyIPt3dsILR?=
 =?us-ascii?Q?6xDu6repE+Bwkp/s8ZLeymtHoL83iEkgw3zjvEShuAEQ3BM1LDCGzYfbblHG?=
 =?us-ascii?Q?sX/hHXymRmHHqlIytfM8BB1PoFFdVHK5Dpimj1V9uq/jf+T1eQf3zR8D0D0A?=
 =?us-ascii?Q?ZDTCIORcxlZhkUFkFMK+UyF3TKuiDgFg7aFuKavzTDdTtAgQKD0Ey7kBne8z?=
 =?us-ascii?Q?a6aBDZFQtir8PDKLMYVHKcMyux0I4UnQCUAL6ifjwALqvtYpxoWo/jUD/wfS?=
 =?us-ascii?Q?9yq0HwaLbCXibyfdQKHOCpZHSvJiKCaNAAPp3vr+R6c692Kedbj7AZTIVuLg?=
 =?us-ascii?Q?5fISV9Uyekmk8N7i0Q+hCWBs7xpUtfWUam1rk33qXnJcvad9F6KksW8LHVVm?=
 =?us-ascii?Q?a73oj8Pd3xjlBRiH1273JTm7s0IeC4+oZ62BJRJTVmV1vCpIn14DijV1/hdb?=
 =?us-ascii?Q?Yxq+6/Sj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3898.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26bd1c40-3b2d-4b75-6c55-08d8c4755bb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2021 16:45:59.9998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: piGOWB738VGVSmJ7Id1EVtigR3WSlUUv0eXgJAG82+88Mac/OOjbv1HfUm1kNVRmr1KfWq3t8IViok0BwMMCtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3562
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611938764; bh=djeF+Fc4WMsNXcREduhEPvJAPawTHivgT0qk4CVruck=;
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
        b=AjekHm4vkdIqDZBCL42+zQ2U5YYzbWettbWbhvMFz28zc7o99NlpBOAyOTQ2ytVJm
         TZYcKCIGOIWKE5fD4aACpyRnQl/UPzUW6AqapMZghaU8h6AUABKGj2nxOuCq/74B5n
         dFb0zF8sgym17Kr3PhTLDQqAgnduNTHzAW2j3xVaJcOM2WDR+BejcY6R1XeahONFn7
         tHKh5T46BKkRKl9NyFXKlS6O4pbjhjCmlhl20sd2oEvTM3/kmsej+4Sz2MSHtA89cH
         d0fRW6xn1Fjn1PbEneNK/Bnep2TEB4mom+IkWJnbojQRy3xjwSEIgnxEc35LazS68E
         /A2r0kTTfEbNA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Friday, January 29, 2021 5:50 PM
> To: Jiri Pirko <jiri@resnulli.us>
> Cc: David Ahern <dsahern@gmail.com>; Jakub Kicinski <kuba@kernel.org>;
> netdev@vger.kernel.org; davem@davemloft.net; jacob.e.keller@intel.com;
> Roopa Prabhu <roopa@nvidia.com>; mlxsw <mlxsw@nvidia.com>; Vadim
> Pasternak <vadimp@nvidia.com>
> Subject: Re: [patch net-next RFC 00/10] introduce line card support for
> modular switch
>=20
> On Fri, Jan 29, 2021 at 08:20:15AM +0100, Jiri Pirko wrote:
> > Thu, Jan 28, 2021 at 03:17:13PM CET, andrew@lunn.ch wrote:
> > >On Thu, Jan 28, 2021 at 09:14:34AM +0100, Jiri Pirko wrote:
> > >> Wed, Jan 27, 2021 at 03:14:34PM CET, andrew@lunn.ch wrote:
> > >> >> >There are Linux standard APIs for controlling the power to
> > >> >> >devices, the regulator API. So i assume mlxreg-pm will make use
> > >> >> >of that. There are also standard APIs for thermal management,
> > >> >> >which again, mlxreg-pm should be using. The regulator API
> > >> >> >allows you to find regulators by name. So just define a
> > >> >> >sensible naming convention, and the switch driver can lookup the
> regulator, and turn it on/off as needed.
> > >> >>
> > >> >>
> > >> >> I don't think it would apply. The thing is, i2c driver has a
> > >> >> channel to the linecard eeprom, from where it can read info
> > >> >> about the linecard. The i2c driver also knows when the linecard i=
s
> plugged in, unlike mlxsw.
> > >> >> It acts as a standalone driver. Mlxsw has no way to directly
> > >> >> find if the card was plugged in (unpowered) and which type it is.
> > >> >>
> > >> >> Not sure how to "embed" it. I don't think any existing API could =
help.
> > >> >> Basicall mlxsw would have to register a callback to the i2c
> > >> >> driver called every time card is inserted to do auto-provision.
> > >> >> Now consider a case when there are multiple instances of the
> > >> >> ASIC on the system. How to assemble a relationship between mlxsw
> > >> >> instance and i2c driver instance?
> > >> >
> > >> >You have that knowledge already, otherwise you cannot solve this
> > >>
> > >> No I don't have it. I'm not sure why do you say so. The mlxsw and
> > >> i2c driver act independently.
> > >
> > >Ah, so you just export some information in /sys from the i2c driver?
> > >And you expect the poor user to look at the values, and copy paste
> > >them to the correct mlxsw instance? 50/50 guess if you have two
> > >switches, and hope they don't make a typO?
> >
> > Which values are you talking about here exactly?
>=20
> The i2c driver tells you what line card is actually inserted.
> Hopefully it interprets the EEPROM and gives the user a nice string. You =
then
> need to use this string to provision the switch, so it knows what line ca=
rd has
> been inserted. Or the user can pre-prevision, make a guess as to what car=
d will
> actually be inserted sometime in the future, tell the switch, and hope th=
at
> actually happens.

Hi Andrew,

mlxsw I2C driver is BMC side driver. Its purpose to provide hwmon,
thermal, QSFP info for the chassis management at BMC side.
It works on top of PRM interface and it is associated with the chip I2C
slave device.
It doesn't aware of system topology, it knows nothing about system I2C
tree, what is EEPROM, where it located and so on. This is not a scope of
this driver.

Platform line card driver is aware of line card I2C topology, its
responsibility is to detect line card basic hardware type, create I2C
topology (mux), connect all the necessary I2C devices, like hotswap
devices, voltage and power regulators devices, iio/a2d devices and line
card EEPROMs, creates LED instances for LED located on a line card, exposes
line card related attributes, like CPLD and FPGA versions, reset causes,
required powered through line card hwmon interface.

>=20
> > >> >I still don't actually get this use case. Why would i want to
> > >> >manually provision?
> > >>
> > >> Because user might want to see the system with all netdevices,
> > >> configure them, change the linecard if they got broken and all
> > >> config, like bridge, tc, etc will stay on the netdevices. Again,
> > >> this is the same we do for split port. This is important
> > >> requirement, user don't want to see netdevices come and go when he
> > >> is plugging/unplugging cables. Linecards are the same in this
> > >> matter. Basically is is a "splitter module", replacing the "splitter=
 cable"
> > >
> > >So, what is the real use case here? Why might the user want to do
> > >this?
> > >
> > >Is it: The magic smoke has escaped. The user takes a spare switch,
> > >and wants to put it on her desk to configure it where she has a comfy
> > >chair and piece and quiet, unlike in the data centre, which is very
> > >noise, only has hard plastic chair, no coffee allowed. She makes her
> > >best guess at the configuration, up/downs the interfaces, reboots, to
> > >make sure it is permanent, and only then moves to the data centre to
> > >swap the dead router for the new one, and fix up whatever
> > >configuration errors there are, while sat on the hard chair?
> > >
> > >So this feature is about comfy chair vs hard chair?
> >
> > I don't really get the question, but configuring switch w/o any
> > linecard and plug the linecards in later on is definitelly a usecase.
>=20
> It is a requirement, not a use case.
>=20
> A use case is the big picture, what is the user doing, at the big picture=
 level. In
> the somewhat absurd example given above, the user case is, the router cha=
ssis
> has died, but they think the line cards are O.K. They want to do as much
> configuration and testing as possible before going into the data center t=
o
> actually replace the chassis.  By reusing the existing line cards, they r=
educe the
> risk of getting the cables plugged into the wrong port.
>=20
> From the use case, you can derive the requirements. In order to test that=
 ifup --
> all puts the IP addresses in the right places, it needs to have the netde=
vs with
> the correct names. Either they need line cards in the router, or they nee=
d to be
> able to fake line cards. There is also a requirement that the line cards =
are easy
> to exchange. They do not need to be fully hot-plugable, since one router =
is
> dead, the other can be powered off. But ideally you want simple thumb
> screws, not a Philips screwdriver or an allan key. There is also a requir=
ement
> that this provision is persistent, since the user is likely to reboot the=
 system in
> order to test the configurations files actually work at boot time. Either=
 the
> switch driver needs to write the information to FLASH, or user space need=
s to
> tell it on every boot, a systemd service file or similar.
>=20
> But since you have not been able to answer my question, i wonder if
> everything is backwards around here. Your architecture is broken, you can=
not
> easily determine what line card is inserted, so you need a workaround,
> provisioning. But provision might actually be a useful feature, so lets t=
ry to sell
> the feature, and gloss over that the architecture is broken.
>=20
> So, i would like to see the architecture fixed first. The switch driver s=
omehow
> talks to the i2c driver to find out what card is in the slot, and configu=
res itself.
> My guess is, every other switch does this, this is what the user expects =
as a
> base feature, it is what we want Linux to do by default.
>=20
> You can later add provisioning, where if the slot is empty, you can fake =
a line
> card, to fulfil the use cases. And when the slot is actually filled, you =
can verify
> what is plugged in matches what was expected, and be very noise if not.
>=20
> 	  Andrew
