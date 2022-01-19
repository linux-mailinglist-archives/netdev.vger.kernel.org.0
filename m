Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A852B4934A5
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 06:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351587AbiASFti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 00:49:38 -0500
Received: from mail-dm6nam11on2068.outbound.protection.outlook.com ([40.107.223.68]:36737
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234835AbiASFti (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 00:49:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kKLjCPDb+r3a8s4TAKU6T03o1FNceToHB9S+4CyZRuhqeB3i0PcWaBOMNdD7yK7g8bQTCMDhDwn7EUDRl/+8esESPGg6wKBx1cLHUsFgqL7mVQzOk+vW4Fb8F4+mWIK+yjOjELhkNC8Tr1VC2odPeGwS8EQtjksavZ9qaVl/b9Qzf1QiHp+SFRkXluQqEXB4bp0ju4NmRjqCJEcHX4NF18q1GGgr+4q1RuERBzT745CpiEJndEDnETOQ9zGycTor8Z/TY0FeWnz3p0MhKE2/E1LKvDPjwemoaF8+V/XETEWBMl2KGQP8OLuzY/wQkCY3zSukUYN8t5vsU4kWakbavw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6LIjXQPDyPcpEJjigRYg5wuPgqu10xQkD26IDonAOlw=;
 b=aXGYYiiESvgS4iwtg8nhkOyPSnrnmvpDuyCUV/wLNdYHcbEGK+OJsunATCgTDmuh6O0DPvUJizOHnid2w9t/rWqdJOWdwMsuTQWTqqzz67NqosD9gmjaRgQJ3AsHwk3EVR+2bncmBT6lHR7tFIJnuY0zTw6LCksQwcs9bhB4uLNCpEQtSWx+duiUP9cPtvHqS9TPqMrHh7324zuvfFOt+8yYrADDwEOpbad0/18RwzZt+2KDVCcTq09A0yHSTtzJ/sh4aVocc8/AgPsKnfi7qUbC0MZAu+PaOHSNY0SNMbddFLwCuW9ttYK36drxYq3d+UPqhx406G4Lk59WtpY15w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6LIjXQPDyPcpEJjigRYg5wuPgqu10xQkD26IDonAOlw=;
 b=SwxGFBIZKq3cFV24F4ppiApvHMlwVhIslZq6UN6dwHhgNQyLKbgziOMopxsB4xdg3OvFVGyv+bdF3AAsTKychCwcjQmOSYwewaMOp+r7W5NIJfIqfwBZ7JYpLN7s592T4ILjJcclEEjWvg9h7ORREEemzTSj9s0VOpdfJ+VSRX4hdb11IjVeitgs3yE9L4RRO/klb4lnzXOtxlJegkijNG0njO18/yi/D6VwUQ05u1e7AIdFRoqgiiw/tJ2fa5/MbItvpWmslk1Ev3/bHK/L2gDFrkMTn42Lborc7CXgebJnoC955a3xTlxzjYHctVe8VYlJcdL8NiRy4+qSmQ+jGQ==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by DM6PR12MB2604.namprd12.prod.outlook.com (2603:10b6:5:4d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Wed, 19 Jan
 2022 05:49:36 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1112:648e:f77b:9bd5]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::1112:648e:f77b:9bd5%3]) with mapi id 15.20.4888.014; Wed, 19 Jan 2022
 05:49:36 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
CC:     Saeed Mahameed <saeed@kernel.org>,
        Sunil Sudhakar Rani <sunrani@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Bodong Wang <bodong@nvidia.com>
Subject: RE: [PATCH net-next 1/2] devlink: Add support to set port function as
 trusted
Thread-Topic: [PATCH net-next 1/2] devlink: Add support to set port function
 as trusted
Thread-Index: AQHX369dAvMd8dQm6EWLk4Akff8tAKwQUeyAgAxe1YCAAFJzgIAAQYWAgAJAsgCAFHu/AIAAEYwAgAAwXQCAAA3JAIABIJ2AgAADBQCAKOGdUIAAGjyAgAAAZ2CAABGKAIAAAMHQgAAIZwCAAHsZAIABZRKAgAAxgHCAAaWsgIAAAHcggAFuTYCAAD3DAIAFfHeAgABLrwCAABzJgIAAWrPA
Date:   Wed, 19 Jan 2022 05:49:35 +0000
Message-ID: <PH0PR12MB5481978B796DC00AF681FAC0DC599@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <PH0PR12MB5481E3E9D38D0F8DE175A915DC519@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220111115704.4312d280@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB5481E33C9A07F2C3DEB77F38DC529@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220112163539.304a534d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB54813B900EF941852216C69BDC539@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220113204203.70ba8b54@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <PH0PR12MB54815445345CF98EAA25E2BCDC549@PH0PR12MB5481.namprd12.prod.outlook.com>
        <20220114183445.463c74f5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220115061548.4o2uldqzqd4rjcz5@sx1>
        <20220118100235.412b557c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20220118223328.tq5kopdrit5frvap@sx1>
 <20220118161629.478a9d06@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220118161629.478a9d06@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ace9fd0b-5e1b-4a58-4710-08d9db0f79a2
x-ms-traffictypediagnostic: DM6PR12MB2604:EE_
x-microsoft-antispam-prvs: <DM6PR12MB2604C3F14EB069FCC9EF0D26DC599@DM6PR12MB2604.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v6X1bjJekgB835XRnpJgCxpwQTw0JqtO+Uv9RVsykvOnHDhd4RflU+xRq5pDvWj0xFTZ6WHJWZFYy4/xSFzFDfDvPs8W6hUjj3/rhUMy14sfF10VwsSbc8N7XkvWJ0bOFsZdrAoF/dgwIScTm1Fy+ujqS1HFFKSPAhy04lXKWxnpOpG3ukWwW/9oMHD5hrXx3rE8hGrHbQZx9B+HTE0E2VVhzp+MZguIK1WDvJjagrKLrN2H/PJ7ZZFmCG/d/YRkv7a+B6Z2ZZtzuIQ+0ree3lkGELO0NHKSJbKS6hp8MCwNL08BE7nG4MrR/EtG0oqhCa9EYOSZKTqFFk9A+rdydZY2008bKTyDv9BkhWLjtOxQbJnh6shc+zjxlozPZjRiHpnrIuH+1ZEUwGDqTP/7Tt71Ja9Hy4BmvsxatNDUwihycQ2xYx9/zH9i3Z3BGGQJchMTxcWCoezd8zTSGHQrrLPyeJv9QRc4x7P9oXmBohcJIxlUiBDx06qf3yjbiXz5I50cAPMY+62eOw0GOx2YyYKdjUBblxWiktH7tyDBzA17eXk/qouMGTyr2SWEUDg1dlgAX/2m8Eihj9TSXINzRkEoNWByLmnm8Eu4Ubzx6LxX+XBig1d1C175DGa3NeaDFl5gqKTXYBto9g9CUJ3FX7QdD7LV2ttg/0YvlYuZqU5O2yzi8Pz9JucyfFIkKPayNlar5mBHTfS4+EATMhRNog==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6636002)(71200400001)(7696005)(55016003)(2906002)(5660300002)(38070700005)(38100700002)(8676002)(86362001)(122000001)(107886003)(8936002)(55236004)(6506007)(4326008)(316002)(110136005)(83380400001)(52536014)(54906003)(76116006)(33656002)(66946007)(66476007)(66556008)(26005)(508600001)(9686003)(186003)(64756008)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?o7sSvQk1MKvy2AzbouQ+S6Oe7SetPe/F6D3X97C2nwtTf+NzQVosA5IgYMUp?=
 =?us-ascii?Q?B6QglPRJoFSgT4CCQ+IJQIsV9PH08fBRcyB9pPBuRSSYZ3dVaFckmHwEuqS2?=
 =?us-ascii?Q?CWJHToISnOm64dcWuxe5t7QZPDqGQWtDl/px0oACrHKePh7rhYA5UqSz/Xnv?=
 =?us-ascii?Q?22JWp3Km+eLzXkPrDb15qj9u45+rjndaDyVPh2222oj4WrCesa+lPkbPja3W?=
 =?us-ascii?Q?kceOOIPD3jc4BTnltscnZY0HP5jmPrS8+MJRD1e+ALRHbMspdltNCMhImPVL?=
 =?us-ascii?Q?gY4Lrx2eZ2bf9PpgXx1GQoq2+DHJs0pBKKagvYMLGBGNESq8VLIznoewxnUJ?=
 =?us-ascii?Q?QPMIIBjOo9rsfo6lGGv0XXFWumI3MHsalHqQKYo2w8WcljzH9PK0b0mfH4ds?=
 =?us-ascii?Q?8fyT7xTvgOIN1gg8iZyjTITbOz8zz+VLkHn2xFwOpQg8as1bzLjzTBu8NPB8?=
 =?us-ascii?Q?24QbFWgbJXDeIRJUozfMpzgCBO7xBLkDQEOxg46HYHfjmuoOESthlX6bMqCQ?=
 =?us-ascii?Q?vi81LEKeW5cg409afi5KKvpero6oypTDcFaDnz3043bqtwu7XnReHximyWVz?=
 =?us-ascii?Q?mfZvNhqFviXLkANXeO4dtkUMNbpXBBkebbZeAPV1xX4OkAc0Owq/51r3gmyy?=
 =?us-ascii?Q?cvpWMWfaVbs/1wOW9BGn84AjzdDmvhEGCBOOqWvImkhp/vGsvJ55gDz10XBH?=
 =?us-ascii?Q?H005pwuGK7RjSsQjRiP8J7PxCKT10VUocHA+hpofpbjJ7ch5+0dRfTjyRMNv?=
 =?us-ascii?Q?KCaxRTbbrblwq83kmjyqb5llbBlx8hctDuuTNqF4/xSSUAhvxF656/As1xeF?=
 =?us-ascii?Q?/5/CgZ74ia9p0AmtFo8kyDHela1ust+X5hgaWrIAOOaRuV33lVAeRtsUw/4v?=
 =?us-ascii?Q?uknJAEmqoyBtG7prk/kwo540uxOgFjXIoXbVy1Jsi6OcvwKaXcq3SVbmonJZ?=
 =?us-ascii?Q?OARZfp8BG0+bjBJaUy0Zx4OQVarbtD0NNjSNUE/vUgiWdpGZqsR1ZD3Xk6Ma?=
 =?us-ascii?Q?Qzuprhs3GsVqzSO0vm9tTOimKSx1wPLwEsGfrvyeb7/R7tGcv6V2xY/IDD1x?=
 =?us-ascii?Q?mE5cv5OkdiHsj8byqfkUPiYyWafC6d19uVSemcmDcaFq7ju8RMTdfVMTqwqw?=
 =?us-ascii?Q?SVQSxZA9zfHbg4C46jOKy0z6EGGDtYKWYq4+ildckQ11VKYOTkjBUrghOK/c?=
 =?us-ascii?Q?U7/LmP+K3BQuaHPYHxhqeYJFXhTR/eWWhRGTgAVLsCHBf6rXJK2dRoAAwQoq?=
 =?us-ascii?Q?ZVmwNnBQlj+GU+qIEPP/wRGkupTwcR5l0BS/XFSM54gbXCd5qP+xwNFC0VCI?=
 =?us-ascii?Q?o98mJY+RZmYo2O3Wkx7lnm1qpezTnoS326gInN0ccV8T+pTZ00Co/85Z9nkr?=
 =?us-ascii?Q?b/sifH3KkViS2FX8h886zrfFZU+9IlxMYBwkqzOf8NE46z5oO53V2r9o0Gho?=
 =?us-ascii?Q?PLj277eQrJZlCKHAlxoHpyxXvePDlnc7jCUrlcpT4lfLDElGL5x/X+CcGQYn?=
 =?us-ascii?Q?R3gR6T0WxC7xkQnHqEq0Qu4Q9k3gi8TLCWEi9SZLlbgRQhEAyvqaasDniZ2y?=
 =?us-ascii?Q?ILuslcXD9yIsntp0JhImv0/lJSP7YGyE2SDWBKvF1SVajC8YbjMOCg+nvP20?=
 =?us-ascii?Q?/pYfdRXBLfxgEp8yb5DYm8k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ace9fd0b-5e1b-4a58-4710-08d9db0f79a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2022 05:49:36.0056
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 14M1no+iEOJD3TShddevqJhpu7hxnF/UoKsm0jqi7sYCSSS7QCP7IgqOQdxA1Y8Y8a9WJqVY9uwplRyYJScqJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2604
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, January 19, 2022 5:46 AM
>=20
> On Tue, 18 Jan 2022 14:33:28 -0800 Saeed Mahameed wrote:
> > On 18 Jan 10:02, Jakub Kicinski wrote:
> > >On Fri, 14 Jan 2022 22:15:48 -0800 Saeed Mahameed wrote:
> > >> I think the term privilege is misused here, due to the global knob
> > >> proposed initially. Anyway the issue is exactly as I explained
> > >> above, SW steering requires FW pre-allocated resources and
> > >> initializations, for VFs it is disabled since there was no demand fo=
r it and
> FW wanted to save on resources.
> > >>
> > >> Now as SW steering is catching up with FW steering in terms of
> > >> functionality, people want it also on VFs to help with rule
> > >> insertion rate for use cases other than switchdev and TC, e.g TLS,
> > >> connection tracking, etc ..
> > >
> > >Sorry long weekend here, thanks for the explanation!
> > >
> > >Where do we stand? Are you okay with an explicit API for enabling /
> > >disabling VF features? If SMFS really is about conntrack and TLS
> > >maybe
> >
> > I am as skeptical as you are. But what other options do we have ? It's
> > a fact that "Smart" VFs have different use-cases and customization is
> > necessary to allow full scalability and better system resource
> > utilization.
> >
> > As you already said, PTP for instance makes total sense as a VF
> > feature knob
>=20
> To be clear when I was talking about PTP initially I was thinking about r=
eal PTP
> clocks. "Modern" NICs sometimes do shenanigans in the FW to pretend they
> have more clocks that they really have.
> There is a difference between delegating the PHC to the VF and allowing t=
he
> VF to use some SW pretend clock. I'm not sure which camp your PTP falls i=
nto.
>=20
> > for the same reason I would say any standard stateful feature/offloads
> > (e.g Crypto) also deserve own knobs.
> >
> > If we agree on the need for a VF customization API, I would use one
> > API for all features. Having explicit enable/disable API for some then
> > implicit resources re-size API for other features is a bit confusing.
> >
> > e.g.
> >
> > # Enable ptp on specific vf
> > devlink port function <port idx> set feature PTP ON/OFF
> >
> > # disable TLS on specific vf
> > devlink resource set <DEV> TLS size 0
> >
> > And I am pretty sure resource API is not yet available for port
> > functions (e.g before VF instantiation, which is one of the main
> > points of this RFC, so some plumbing is necessary to expose resource AP=
I for
> port functions.
> >
> > TBH, I actually like your resources idea, i would like to explore that
> > more with Parav, see what we can do about it ..
>=20
> Right, that'd be great, although I'd imagine if the resource is very flex=
ible (e.g.
> memory) delegating N bytes to a function does not tell the device how to
> perform the "diet". Obviously that's pure speculation I don't know how th=
ings
> work on your SmartNIC :)
>
Right, we at least need to tell fw that only X bytes are allowed for sw_ste=
ering diet.
And _right_ amount of X bytes specific for sw_steering was not very clear.
Hence the on/off resource knob looked more doable and abtract.

I do agree you and Saeed that instead of port function param, port function=
 resource is more suitable here even though its bool.
=20
> > >it can be implied by the delegation of appropriate bits meaningful to
> > >netdev world?
> >
> > I don't get this point, netdev bits are known only after the VF has
> > been fully initialized.
>=20
> I meant this as a simple starting point to enumerate the features.
> It was an off-cuff suggestion, really. Reusing some approximation of exis=
ting
> bits with clear code-driven semantics is simpler than defining and
> documenting new ones.
>=20
> We can start a new enum.
>=20
> I hope you didn't mean "PTP" to be a string carried all the way to the dr=
iver in
> your example command?
>
Yet to sync with Saeed, but I think it will be a enum + string during resou=
rce registration time.
For generic features, enum and string are defined by devlink core.
For smfs kind of rare knob, enum and string is supplied by driver.
