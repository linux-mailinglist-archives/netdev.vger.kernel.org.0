Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A078845CE06
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 21:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbhKXU31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 15:29:27 -0500
Received: from mail-eopbgr80081.outbound.protection.outlook.com ([40.107.8.81]:51333
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234622AbhKXU30 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 15:29:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XfNCJoGOZg+XDvI2fHVZ0cLCgZ+8MCgzL0gdCMe7SeBgWHjQtlmp63MdmPMVeY4urdfEBtZMHNQ+bm30o8bftsfEMcOEpmjOjmi2YDWpLZUPfjma1bJjhXSrjWPuxFTy11TFJCaXVXjpa+6DvSomjDYXiuh3TW2wi0O3q6+iX3+JQcApv1InfANWMK8TUlzk+hPw1JJmDpqb6fjED4vTmYbtd0Cmy6KimmVtRl0c0v1v+75wDJ6TX4CBoh4o1BKDUs41ZyMaZnFcUKMh5RxAy1Rs9aNr8QigIHs0f1+l6lvpz9R7kPQyyuGR05eOHQB+1KEWdBQIlNMtleVBuSr44A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wbHOZMBXYvjHnLwMsKh7BgDIwbjIkOl/N6fYnvfLjSk=;
 b=haLAieBLLUxi7MMlmuOafBkZjeGxkt81g1vMaxPwqZ5e1F4eUHEMRQ7lZHFtyu1cveMB/tvWiKBBRbmujmwyOYP8fjAV2AEsma4pOvXeTWU9buCSFpxrXWKH1rIOyNRRV+ED5YIyExWxjFVGZZHJBWe/cpfvF8Eu8Dr4LU/FGSTu5GQ34/6l7Hg1VhXzQ0jDsIUsQQarr/0mlfiBLlPlqZ3dWRF+evqSCpHjqUo5TjuKfPwAVzSlew/kgMg7JfGn0mnXdm7culF6KfYN9XmSuTEosPnyrJ8Z7eDB1do86I9IDCVTTOTIM0CUr+U0TY66IW/CCaEDKe4sccrtVW5RWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wbHOZMBXYvjHnLwMsKh7BgDIwbjIkOl/N6fYnvfLjSk=;
 b=WNm50nKjmoLvNu5WJ+IgyDniZ6GBuE3se4qwt7BxeKZdI2lbqSmtdkyWbvGAV/1XFvHGu44J1QTbMqjxqtEuJ2NzV6omR7gNd00zcLVURqBJN7TZjAbUg54uoJnwbYc9H4tEg3zyN+16dJyLLNZv6AmeBds2J0fTMyqiq0Q4QCY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22; Wed, 24 Nov
 2021 20:26:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.021; Wed, 24 Nov 2021
 20:26:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH RFC net-next 03/12] net: dsa: replace
 phylink_get_interfaces() with phylink_get_caps()
Thread-Topic: [PATCH RFC net-next 03/12] net: dsa: replace
 phylink_get_interfaces() with phylink_get_caps()
Thread-Index: AQHX4VwWzy+SKKYDLUOcXyfX9IFpdawS+7OAgAADQwCAAAxNgIAAFRAA
Date:   Wed, 24 Nov 2021 20:26:13 +0000
Message-ID: <20211124202612.iyrq3dx7nefr5zzi@skbuf>
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <E1mpwRi-00D8L8-F1@rmk-PC.armlinux.org.uk>
 <20211124181507.cqlvv3bp46grpunz@skbuf>
 <YZ6D6GESyqbduFgz@shell.armlinux.org.uk>
 <YZ6OORjbKuz8eXD5@shell.armlinux.org.uk>
In-Reply-To: <YZ6OORjbKuz8eXD5@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6049cc1-d381-4d97-cb1a-08d9af88a938
x-ms-traffictypediagnostic: VI1PR04MB7104:
x-microsoft-antispam-prvs: <VI1PR04MB7104B0CDC58EDFC8634F9C2AE0619@VI1PR04MB7104.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NniaZI0RNmpKvWFJfeB3KdMq+DutKqmogLXkmZUB3EyqDU4lKpA9KSItEU2L8F4lbSFqzaCigelcAY8x1YfvhEMWGUfh0VTeCPPrc2MGxaXxomAwQ5MYxoYiKg3wDa4vGXc65sTst8vZ+/6c7hGEyRAI8EXzFM12g1IBqSOoDykG3EqrEuA4lbQiwP5WMXzYYxjohYvkGrmDzLiElAFHn7DVcnGK1aDTHCIoFuESvy1eXOaYN4olGD2J0Y3/cOk3FnUi40J3CAcUGqAFvpJ/Pb+bI8Pg2FuJwgurt8ugG7g9/j4fCXbGwaEfUjcUJybR9iDZPqnuX09fK56FeLfsn9nxiMagZD54j1ty/oID6/0HMH/DJkFyneNUPBRicQ4JZ6ESKPV3FMvnQW2f/pRQXDCUXqgnigy2e7KliVCH1UZJ5MquxsR3FkhNaDrR4tQX9IQljVQkVLNZdjKuNfJ4MUHGNiROaYQfLxN4RFdVDoFmDjEJODZ5oWioZn0OlJfmL2b3nrxmqVs5gECZAWf85JtGtheIGw/ICAVP8F0sLLxliEazVsfI4hnznP+DVRpldvxELj5O2KVXCHrvd1qIeP8U4dG3pfpu2zb8WXmQ9cUz79lbSnGkeLE/uAE/sTisMifmP1ZGyexAerHCF0csrBiuyLqN+5bzrVDORTQeEyxA2u+TtQYjmZjaWMkXjpPFDL9DAA9x4Vhuh0MC+1CwV1Lvhi5hWe5A0cR3RvB/Q9w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(44832011)(4326008)(1076003)(83380400001)(6916009)(86362001)(508600001)(54906003)(316002)(66946007)(33716001)(8676002)(2906002)(91956017)(26005)(122000001)(38100700002)(5660300002)(186003)(66556008)(66446008)(6486002)(64756008)(7416002)(66476007)(9686003)(8936002)(6506007)(71200400001)(6512007)(76116006)(38070700005)(21314003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SN3ogN28CRwliKjwEQ7rAhFpirB7B6wrsH2LRhwD+8zlnkmOmYFQFgDXi0Dn?=
 =?us-ascii?Q?s8/RS74KvAefxOJmTisAV14Uqz74a8pE1beggysQf1dIql8tv5EY4/JFn+f8?=
 =?us-ascii?Q?2D+YB7Vt22U6nfcmvERQcGcJMkOY+yzBghXxoIhWvrB8tJBrEwjg3UG6A7jB?=
 =?us-ascii?Q?1Mdep8uFPw72CXQPd52E4BoUt+IO4vqDikcciDk7wmTCDHwzhfnMOw5PMenw?=
 =?us-ascii?Q?thMwZ3MJIc2kZd4ajq0yiA8cAUDqRl1vEzTB5bspfTr0ip2OEOgZydMzR/WM?=
 =?us-ascii?Q?jnYdmonCOxTF6hfPcNjdpnsnn8aSSLPMx976n8U1eTRkhY38lgjFlE4y8Pd3?=
 =?us-ascii?Q?2ftS445hoGq8giUs26tvIxBjbbZtgoC4Ry/7pNUnt2Cco2VbiH8ELEhSFxRi?=
 =?us-ascii?Q?hDxWU++djnDNFwPq47gS4X414XO5/lflofwbgAAU61xvg6ajUnvMNsaCsWO/?=
 =?us-ascii?Q?3nRM1ASzopGMsrNZyHWG598YNK19mYBviunUJVOcrHpPqlqeLczv+kO5NMC5?=
 =?us-ascii?Q?6ja6R9+GSKpllI7k0egb79Fr6fOVqTymUvqEvd10SB1TxVyHKXVa7k7MTzEA?=
 =?us-ascii?Q?oy7XYNFEMp0ka8uP94YVh+btXs4qn1U02YKmRE65m2xIxrYEtyyV3T54578P?=
 =?us-ascii?Q?L1F8f12CxEA6FW/KCznxi6ALda9siTHhsS2h8p0DuX5s1F+oH7UV852wY8Gc?=
 =?us-ascii?Q?WU0d9CmEgB0FmpgbIittohZ9/hLWTAqgv4Z81/QJNt4tF5zS2Mhikmhf2NKX?=
 =?us-ascii?Q?oyVy6/VOao/1oFvKG8Je1PxvpxIsbRWqleGV4G6zzNDgx3K2UUSqgxpHvf7F?=
 =?us-ascii?Q?ScBLp1mI/F7EtynH/OvZZBDphhl8tcHysyN0JtT++tlOxxncD4JYkSXYNBZC?=
 =?us-ascii?Q?QuLLZ5hDuh6Xy2zjgJzyf5A6CG4x/eiTUhBc8FcZE6VH2mnKSiFI3QplVBoL?=
 =?us-ascii?Q?OTluxXDkBaYNMga+VHwEbrkPLlqz1GYd6GfGUs9caaQKHv9sw6HniBMohdFt?=
 =?us-ascii?Q?vUqEQhJt9xZo+hnyk1Y5W7o1+4EgFGAaCMIIfDO2/vQ/V6ddk5AJx8LSc2Z0?=
 =?us-ascii?Q?3sonrAuV/TYVU7iMfEe+ejOCNXgZlE+4UVzV0ByhMxvPy36Fs6Tg4CpzWBbW?=
 =?us-ascii?Q?XIf37WW1V/YzbsqVyYYrk1quR44uY+BTF1r0NDLIenj67r9tDKHDm83YldQX?=
 =?us-ascii?Q?EuZuubj6zu2AOgYb+XJOgvK94gu7RUP6Vami5r+v2E60b8XOMvzAtgG0UDMN?=
 =?us-ascii?Q?pnuj/RySS09gvcmEDux4nophDCdR13vxaMd3LrhyY5kjkSkKC4dCG12QzQNq?=
 =?us-ascii?Q?t51CINSwRCRXQ0FJbG6Z3NjLNXz51p8NaIQEP8evdMuLX6Cog0xPqq2GHN+C?=
 =?us-ascii?Q?Zfsx+xlSYgp+dkSgfHnGQB8KWKLixFZPZx1rk0/mOYHd5PsOfuL6cJqY36YZ?=
 =?us-ascii?Q?8cnHD4D0Gv5rmpp2p6w2WbznITLxoZOOpLJEeSzCjOy2/NEDYGxvWilAQk6Z?=
 =?us-ascii?Q?HkfqChVRh2ZZtAKvogGvw25ONHhiH28XK5LkPUPCitcGJuzEQSSPrnYLTwMD?=
 =?us-ascii?Q?Hn0DkNvqcLIjBDr52RSjmBobR7tZUPdDSFgwLubmLI43ezxg8ERx77lOzQ3c?=
 =?us-ascii?Q?O/FG4CO8N6WVDLceoIlff/i9fj0h3RJhY+MDoBYpdB0j?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C5C440C5A0423146836DF6C965BB3ECE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6049cc1-d381-4d97-cb1a-08d9af88a938
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2021 20:26:13.8140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a24mhH169WJkHZwn5LDFyWKbTDrTRTjeLK4qjaDHtE8rgJple7S5RR4PialonW8W0yMC08F0uhdEzQCaPtqdpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 07:10:49PM +0000, Russell King (Oracle) wrote:
> On Wed, Nov 24, 2021 at 06:26:48PM +0000, Russell King (Oracle) wrote:
> > On Wed, Nov 24, 2021 at 06:15:08PM +0000, Vladimir Oltean wrote:
> > > On Wed, Nov 24, 2021 at 05:52:38PM +0000, Russell King (Oracle) wrote=
:
> > > > Phylink needs slightly more information than phylink_get_interfaces=
()
> > > > allows us to get from the DSA drivers - we need the MAC capabilitie=
s.
> > > > Replace the phylink_get_interfaces() method with phylink_get_caps()=
 to
> > > > allow DSA drivers to fill in the phylink_config MAC capabilities fi=
eld
> > > > as well.
> > > >=20
> > > > Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > > > ---
> > >=20
> > > The effects of submitting new API without any user :)
> >=20
> > It had users at the time, but they were not submitted, and the addition
> > of MAC capabilities was a future development. Had they been submitted a=
t
> > the time, then they would have required updating too.
>=20
> That was a bit rushed... to explain more fully.
>=20
> Prior to the merge window, the development work was centered around
> only eliminating the PHY_INTERFACE_MODE_xxx checks and the complexity
> that the PHY_INTERFACE_MODE_NA technique brought into the many
> validation functions. Users of this had already been merged, and
> included mvneta and mvpp2. See these commits, which are all in
> v5.16-rc1:
>=20
> b63f1117aefc net: mvpp2: clean up mvpp2_phylink_validate()
> 76947a635874 net: mvpp2: drop use of phylink_helper_basex_speed()
> 6c0c4b7ac06f net: mvpp2: remove interface checks in mvpp2_phylink_validat=
e()
> 8498e17ed4c5 net: mvpp2: populate supported_interfaces member
>=20
> 099cbfa286ab net: mvneta: drop use of phylink_helper_basex_speed()
> d9ca72807ecb net: mvneta: remove interface checks in mvneta_validate()
> fdedb695e6a8 net: mvneta: populate supported_interfaces member
>=20
> The original commit adding phylink_get_interfaces() extended this
> into DSA, and the intention was to submit at least mv88e6xxx, but
> it was too close to the merge window to do so.
>=20
> Through making that change and eventually eliminating the basex helper
> from all drivers that were using it, thereby making the validate()
> behaviour much cleaner, it then became clear that it was possible to
> push this cleanup further by also introducing a MAC capabilities field
> to phylink_config.
>=20
> The addition of the supported_interfaces member and the addition of the
> mac_capabilities member are two entirely separate developments, but I
> have now chosen to combine the two after the merge window in order to
> reduce the number of patches. They were separate patches in my tree up
> until relatively recently, and still are for the mt7530 and b53 drivers
> currently.
>=20
> So no, this is not "The effects of submitting new API without any user".
>=20
> Thanks.

Ok, the patch is not the effect of submitting new API without any user.
It is just the effect of more development done to API without any user,
without any causal relationship between the two. My bad.=
