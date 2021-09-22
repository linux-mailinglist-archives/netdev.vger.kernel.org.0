Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36898415437
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 01:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238551AbhIVXwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 19:52:09 -0400
Received: from mail-eopbgr70059.outbound.protection.outlook.com ([40.107.7.59]:15103
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238511AbhIVXwI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 19:52:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ag1QDeTDAVTo/yeP9GQWkad9tIlzW3DPs6Sr5P7hkqQKg/1Rt3oyDcZHUSMYCFjscDuNmWSlzKDmN0sA8UZuijno7DEZ3WNfH30NBxPmbLFlHcAOd3Z5RrNtwPRCTRQe7lr96dl6I1MUK9orI6Q8T+KO5Sn/EcxKWoo3Vjo2HK7rinkMURhOnWENw9+es5HlPAyaCct4AOPQl6RxB482VZwmuzU1jbnkKVAGG2d3BVJx0pUqGOgk7xNYX65kWM4sLUNkpj2l+Fzecb2yePJvpUeBoa60eS4RE1+chduYWyaOYDH9sBBxWrxo6IcyMqZfwJbht+soc3S9Gf5QZYfpsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=TisCEq2NBmEhN1kDVrwv9e8QjoZ42eGBsVms67f/Gh8=;
 b=btw/HT+SLnJ+lxi5xtQKjLGxHZYV/b58gwafASzBrMak9ROqZt8trpzEfqpIQJfJ7MIvEmYF8f1kL8x3M4mH+4ZX/Cl8qg6SuGMscB9PmBy1Z9wnPpn2EGUvlTjHlsju9zq9zzatme+wAiGBufhEjDI9kdMq3Ebzw/4FcZ2r1+2pR+NOk2KXJ96d/PfWyEQdezhhhqu+0WEABV9dKDYGtD11d/4s563Q/B7kKVPmp3+t8MMbtBo6Zepoq/HTocI7I/Yg0mw/9hITnCoCrx7sa3nK5mQoEEORfsgIstBvhS395ZGLTJWUM/XJCPgyAXTXx9+8zqJTUk5+7USvnE6G+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TisCEq2NBmEhN1kDVrwv9e8QjoZ42eGBsVms67f/Gh8=;
 b=sdFyeT4fdEUQLmkoNeqIMsy1J8bzbIbIdnM2bmgL+JiiULnXTI2rNT0e6DzkkCr7jOYz8HXrzNo/szN+xX7+6eknYz7cjSQG7G0s6LmtMuurdkizQk4WFROGxbSmP2Lnxz6p/qVLigFyVx5yY7VumqVVH0eiRXcoaDabEV6fxgc=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5855.eurprd04.prod.outlook.com (2603:10a6:803:de::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Wed, 22 Sep
 2021 23:50:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 23:50:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Subject: Re: [RFC PATCH v3 net-next 2/6] net: phylink: introduce a generic
 method for querying PHY in-band autoneg capability
Thread-Topic: [RFC PATCH v3 net-next 2/6] net: phylink: introduce a generic
 method for querying PHY in-band autoneg capability
Thread-Index: AQHXr93LG5LHnXhXOUKrZr2QV4Zp96uwkB2AgAACgACAAATNgIAAFO8AgAANLoA=
Date:   Wed, 22 Sep 2021 23:50:34 +0000
Message-ID: <20210922235033.hoz4rbx2eid6snyc@skbuf>
References: <20210922181446.2677089-1-vladimir.oltean@nxp.com>
 <20210922181446.2677089-3-vladimir.oltean@nxp.com>
 <YUuei7Qnb6okURPE@shell.armlinux.org.uk>
 <20210922213116.7wlvnjfeqjltiecs@skbuf>
 <20210922214827.wczsgk3yw3vjsv5w@skbuf>
 <YUu2OlXElk5GR/3N@shell.armlinux.org.uk>
In-Reply-To: <YUu2OlXElk5GR/3N@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3a3a064d-d132-4eed-0cba-08d97e23c51e
x-ms-traffictypediagnostic: VI1PR04MB5855:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5855C19FFD40B7A37E9DD66AE0A29@VI1PR04MB5855.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:651;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dlPkki1lAW0CgS3vCrHJXkYekSCWgQTlubZ/c7Pe27v5ixTOCKCa7c0yTXhagi/Pbsbi3bg5AmUtg9abZZggsQ6niojfHmCnbl1aCAH0HBvsb19kJvdGR2Yhrn8vmOxPKWGRQWA2HE5jlPAppnyedx035Wl7a2NL4Jpq22iS3ICSh2fKfBSj4SDGzASpAHCcl11ZEkfAmXBxJor6VfptZy/S2R68NUYcL+fM6ecQ7PqlvKyd2Kt1Wo+LELjgJ/tqMvPIhzEtkdG+bTUdWISKay/WJCVMN2ygI5GlOB+pj/sjge9pishGUSHZDS6T6McFpiFcL7+Z6dGu7v+wfhzrttQHrkgEPZ+cVGppa8W0guouJm4GBD1cQvTjTwOpPZHPQ6cdqSsq5gFLO5AcpCCzb2N9NfaErFWMY90UdaKEBCnyHmdyS5iB/kFhs4b5V9Q4sqQIXyAHxZcYvVfZ1pShyfOi7gyG9goGSn5MAQ/FiTv60HQXuWmu4k4UDlSSi5Gs8H2vp4wIsDHJ1PnawW44VpPI7QaUQsibuQGlEgNODmLRoD0+2JmN/7i64WYhsR5aiVw4e58jJXUCpwxf2rS1WmJfTRNdf9EywtkrHEwVBrMBFELXkxpSjMwft0VnQiRNkfQsnmELx9ezY8qBfDvKN3WPNdlwAVQMx18db/i2RmJ+HVCvEh49xJayaYjgegR8MBkkEv7Sf94UXrSPHaPgz9Leenf99qgb92qZIV8GCFw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(91956017)(186003)(1076003)(76116006)(71200400001)(6486002)(2906002)(26005)(6506007)(44832011)(8936002)(8676002)(508600001)(5660300002)(9686003)(86362001)(33716001)(4326008)(6512007)(122000001)(38100700002)(66556008)(316002)(66946007)(7416002)(38070700005)(6916009)(54906003)(66446008)(64756008)(83380400001)(66476007)(41533002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?222evdjHiPWz4qI18XGhVNMyEnpW54bSUxLuew6mJJvBiL47Ems0jrLJgj9Y?=
 =?us-ascii?Q?lEHOWjo+RWayrCYuvgF/7/INMpIUyv1nGJillWVjfcYLVSr5vaQHIRlj89BE?=
 =?us-ascii?Q?rTQBcCPZOGaDISdPt6kPDzmxysWENhaiqDoulCCQ5driQWP73MOZlgG/T57d?=
 =?us-ascii?Q?vCLFPfiWkIR0Q93msfxN4pUE/E774FWyPVPETdBirQQHo7yBzrnECueF9j1s?=
 =?us-ascii?Q?sHrkyg/dcFojIA0X3dunPu3UfRH7mE5GzthGV6RzFIqMQWJscy4TpquxUAKO?=
 =?us-ascii?Q?6ZU2W5fXtWidoFlK40zmkHt47A5UKNidpJQZKW3TWSz6qUeLdsaIulnGPRBr?=
 =?us-ascii?Q?pZhOs0YVt9qTMAZ0YU1av6ohnya2ijZYdbqJvgltOXWdJ+hNQqQ8IbMxxx1/?=
 =?us-ascii?Q?2BYAHDfTNR/NUSKao+Kc0Wp2b71R6gJEMusI/fZz8LuQfPvGMa3cPrYo6U/N?=
 =?us-ascii?Q?9RjyuS8nNaU7jPh9Ejpf1BK2+/G8qmVUTIJCxFExE/Flnd9T8f187QnAD2/W?=
 =?us-ascii?Q?N5DyKvwo/996Mok5Jb28hhTaD2W/PBeaKaZfRrkBgmTXGcrZn5K1UGbuR7tF?=
 =?us-ascii?Q?o+kMnWRPSlyfDct3fieQoMr/boF1+zBkrV+QJh0Bow2SDjzjJj0ngAK9mjqt?=
 =?us-ascii?Q?6aYSi6sWJqzB+yXT0QUtDuxqBchrfqmJ3sV8RMLUAHERudsU8DacV5Ka3a2O?=
 =?us-ascii?Q?qhHhiZTtP8JX4+hkEg9whNOOvPnf1wMJ2ttGSAYOFzihh+hL95eY22VJiTea?=
 =?us-ascii?Q?zZ2H/JRN9ftgXVLtgKRSw4yepFyEl53sABj8X7crcLxKz6e65/ppzDVlqnIv?=
 =?us-ascii?Q?/4Yj9dlGDJhKMlAFpTA/R4lzV2q/YmlIf1OBCRNI3DLoXTbg75airX7iLj5i?=
 =?us-ascii?Q?uUnniZ6ETbPlHqe23BY0FNZx7g2PABubd9R795fSCMT03o0n9jl/tEi23C1V?=
 =?us-ascii?Q?AwYLAlMGDzdPeBGEpuPtwJ13VkxCJMKIuTHj6UlsMXt8uhGF1Z17TiXg02m7?=
 =?us-ascii?Q?tcPeCYS83lxuIaRwL+OQkN6VAPZjRCjBGUuxkmMedSNPirvH7XaJV9dBaQpH?=
 =?us-ascii?Q?p9yC7Cl6Vs60O94t0xnnHRJvR3l15a4W7RlEqdguDsiI4MDU/AzHuHYWsyMK?=
 =?us-ascii?Q?RnVX9mv1FOKdsPC3qj7RiL4tSRZ8Jv9U0XQYMn+6jsVRc7NTmbsGtVrmgbbG?=
 =?us-ascii?Q?X1zhfvtj9yIbygQysAaqkixhLweI4t89VdRsvKq+hPBMVk8Cs4cGrOklLU7Y?=
 =?us-ascii?Q?kEoL7uZEt78jaOSL74lBEEf3r5EArQBs7Zw8kaZUjLJgUJUhvXC/vabGiVkn?=
 =?us-ascii?Q?J3PYZzL8oQZMRGdhK3JVxbMNt11V1tKP4/qGFxgyaXg57Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EB49F8ECF31CA34D8043D3707A273A9F@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a3a064d-d132-4eed-0cba-08d97e23c51e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2021 23:50:34.4472
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JCUJE0CTefz/VzZHCbeLk0b4lvxwog+l7zbPg/bdzFaL7bOuGcF0GPL/U5zlIlk1Rbs0sTQkIxHVkXckennJtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5855
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 23, 2021 at 12:03:22AM +0100, Russell King (Oracle) wrote:
> On Wed, Sep 22, 2021 at 09:48:28PM +0000, Vladimir Oltean wrote:
> > On Thu, Sep 23, 2021 at 12:31:16AM +0300, Vladimir Oltean wrote:
> > > On Wed, Sep 22, 2021 at 10:22:19PM +0100, Russell King (Oracle) wrote=
:
> > > > On Wed, Sep 22, 2021 at 09:14:42PM +0300, Vladimir Oltean wrote:
> > > > > +static unsigned int phylink_fixup_inband_aneg(struct phylink *pl=
,
> > > > > +					      struct phy_device *phy,
> > > > > +					      unsigned int mode)
> > > > > +{
> > > > > +	int ret;
> > > > > +
> > > > > +	ret =3D phy_validate_inband_aneg(phy, pl->link_interface);
> > > > > +	if (ret =3D=3D PHY_INBAND_ANEG_UNKNOWN) {
> > > > > +		phylink_dbg(pl,
> > > > > +			    "PHY driver does not report in-band autoneg capability, a=
ssuming %s\n",
> > > > > +			    phylink_autoneg_inband(mode) ? "true" : "false");
> > > > > +
> > > > > +		return mode;
> > > > > +	}
> > > > > +
> > > > > +	if (phylink_autoneg_inband(mode) && !(ret & PHY_INBAND_ANEG_ON)=
) {
> > > > > +		phylink_err(pl,
> > > > > +			    "Requested in-band autoneg but driver does not support th=
is, disabling it.\n");
> > > >
> > > > If we add support to the BCM84881 driver to work with
> > > > phy_validate_inband_aneg(), then this will always return
> > > > PHY_INBAND_ANEG_OFF and never PHY_INBAND_ANEG_ON. Consequently,
> > > > this will always produce this "error". It is not an error in the
> > > > SFP case, but it is if firmware is misconfigured.
> > > >
> > > > So, this needs better handling - we should not be issuing an error-
> > > > level kernel message for something that is "normal".
> > >
> > > Is this better?
> > >
> > > 		phylink_printk(phy_on_sfp(phy) ? KERN_DEBUG : KERN_ERR, pl,
> > > 			       "Requested in-band autoneg but driver does not support this=
, disabling it.\n");
> >
> > Ah, not sure whether that was a trick question or not, but
> > phylink_fixup_inband_aneg function does not get called for the SFP code
> > path, I even noted this in the commit message but forgot:
>
> No it wasn't a trick question. I thought you were calling
> phylink_fixup_inband_aneg() from phylink_sfp_config(), but I see now
> that you don't. That's what happens when you try and rush to review.

How did I "rush to review" exactly? I waited for 24 days since the v2
for even a single review comment, with even a ping in between, before
resending the series largely unaltered, just with an extra patch appended.

Not complaining that you haven't reviewed this in 24 days, we all have
other things to do, but, "rush"? I have genuinely forgotten the
implementation details of the patches already, and I don't have any medical
issues with the memory that I know of (or I may have forgotten about them t=
oo).

So let's say I want to strike a balance between not rushing reviewers
and being able to usefully respond to questions. What is a good waiting tim=
e?
It is generally accepted on netdev that if there is no reaction within 3
days, then "out of sight" becomes "out of mind".

Also, "that's what happens" =3D> what? Some confusion, which gets clarified
over two email exchanges in a few tens of minutes? Is that so bad?=
