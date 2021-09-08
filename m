Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B5740402F
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 22:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239190AbhIHU32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 16:29:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:19495 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229677AbhIHU31 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 16:29:27 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10101"; a="207823222"
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="207823222"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 13:28:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="503736480"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 08 Sep 2021 13:28:17 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 8 Sep 2021 13:28:16 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 8 Sep 2021 13:28:16 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 8 Sep 2021 13:27:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BCVa5nKQpvGC3XFoCn3ObKcKdBm1VseOTowvE85NblKKATP/rktYKrCm9ek1GlSe5ebNBXHjzlS7SqpLTZlD8iH7DCdycp/Kre7RxqD5LkIzMqWfWOtp9Fcl3B3bf1fwABR/wvsIxkhwvE3+ZHv38BpcyurRjJrg9hU21YXDjxp+blskjsII7PB9H8XUrYvEtDyifdpXWm7xOt67scTG/QKDPvWMaD8FvZVRnlkVpH0gQYt0Il9u5EANhveoCqx6KyWBzjGljJlumILmFIkO4c8KicNEGgc5Kj8NfMpVxNk5MJyBmIqq14zaxREknSA9luSQ8Ihuv4Q8wfrFf0eG9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=a4hmmqYbFKIwxxu2WUo3UylL5Avmt1jG8+IEgiQySLQ=;
 b=Xf+LCDoh9zdpyYes7EcACoQzHTYBEw0HB4tStejlXSdt/brWGMwZK/TXxJ+8eqFO8nONKqo3+X1YWE/g6AIESeevaY/6jP5s3CZdy/I/goPtaqaYTH7xIW3cwLc8/spa2v81E9R75Cxc76TetZ2RJdMYWGfyHokFR4eb/GpC8FTdXVRoAgjOIT5JNMGVZM7lmeTIG2e87wt+AVg/ptWsac4nv3VjWIPc6hm4eEtTmMNreNdxIpQ61q00QdUSEl8kDSN15DyCav3i6pRlj1Kv/DvnXW9Li6CqbPevZw3R4BM4MYbYPpScLNqqzpdOQUtn8yvpeAd0j9PSLZn/7S9Leg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4hmmqYbFKIwxxu2WUo3UylL5Avmt1jG8+IEgiQySLQ=;
 b=trvXbzHNlXfHRgtJG39xKDkOCUjJPSE8tuYB3w7glbsd2u0eawZL0N5ouoTXzGf0Ytx6GCpvoESU9MZHdiOVzxRhutRsjLlh/NxYHQ9RD9MOSOs5pADT9L80qB0ONvC5cF+YIRnRHcaQm2X2BwyFeQEwrd2PzXMyxR43xWwxfe4=
Received: from PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5)
 by PH0PR11MB5144.namprd11.prod.outlook.com (2603:10b6:510:3e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Wed, 8 Sep
 2021 20:27:44 +0000
Received: from PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221]) by PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221%7]) with mapi id 15.20.4415.029; Wed, 8 Sep 2021
 20:27:44 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        "Saeed Mahameed" <saeed@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: RE: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Thread-Topic: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Thread-Index: AQHXoNimVzUXkjuVtUCdGyBU/1Tj8auS4GqAgARwniCAAApOgIAAAHuggABqPwCAAH2kEIAAa06AgAADpCCAAE4LAIAAxVmQgACTXICAAAjlIIAALSGAgAAA0JA=
Date:   Wed, 8 Sep 2021 20:27:43 +0000
Message-ID: <PH0PR11MB4951B5756090C5A2F5A8DC84EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <20210906113925.1ce63ac7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB49511F2017F48BBAAB2A065CEAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210906180124.33ff49ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB495152B03F32A5A17EDB2F6CEAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210907075509.0b3cb353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB49512C265E090FC8741D8510EAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210907124730.33852895@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB495169997552152891A69B57EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210908092115.191fdc28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <PH0PR11MB4951AA3C65DD8E7612F5F396EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
 <YTkQTQM6Is4Hqmxh@lunn.ch>
In-Reply-To: <YTkQTQM6Is4Hqmxh@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 15c2da6b-6ad1-477b-e88d-08d973071d28
x-ms-traffictypediagnostic: PH0PR11MB5144:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB5144E6983CF7B119C6E222DAEAD49@PH0PR11MB5144.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kdeoBQx2o0usblphJnd2k9UEO2iPq8DQUCOb/z6QhB4poV6NL38T1zoHxmD2hlQ2tYRRZUF3hrsfjNEhRkFJYWkKqW+KuwSrbONwbzrTVOanXbauumtRwYEjajW3qMzZ8T5GtQl0GU8VMbH2ZiUL3feHa4bscmcHhbsCx02ytT7iIhp283i3fAoT14A9+vo6aqo4IHYlyh0QsKmLUPBGd9jKIzRVN9V55mAEMPAnwS8Dw4IQfp8b64ficMsRCP3pCREo1HUZI5WYgCBQCbEMt03s0Fos7KROgU9HVnTF/0zNrbsNdUIrIZn3bpxexKCqIhuI7b9o8u1SC055RmuNkdBdpV9SSyxew5dd67+stSvZhe1YyVK532ZEoQKo7ac7PdwXkKXcLywtP0UMdvZKj3LPozGAv1JeJuC+pUQ6DG1pSy55Qj2jUM//KdufnkDP/oUqyez55BGZnFeRgN5s1wz99kme4PSlNMB2xKvS7TKBrCPMPQB+KG3E+Ws/PGW+g3B77mBkzFluC7yF6erfIs95K4yNtQERVUpaZFNX4A67fE3XvNLv3Us+Rr6G4Yle0PUtSlSGhlVZrsnO4yj3EuClrhkJuK9MlBks2v6a/fL+WmEj0zOGAGgfvBOJO6d9FvTyr24dZPbZeGPgBQM0j2wGMEZBauvvg77SdUIOmoel8QSsh8T2EEvvXBvtYgiPlB/monvIrpIDe6h4O93NEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4951.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(64756008)(66476007)(6916009)(8936002)(53546011)(66946007)(52536014)(66556008)(4326008)(54906003)(66446008)(76116006)(83380400001)(38100700002)(6506007)(122000001)(8676002)(86362001)(316002)(2906002)(7696005)(15650500001)(9686003)(5660300002)(33656002)(71200400001)(55016002)(508600001)(38070700005)(186003)(26005)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rG2Oqdq0lUYp0QyPuWfIDkcqv+nGM19S1zy4Dt9LehDQ9/pBQM1ztwvflk77?=
 =?us-ascii?Q?bqQIBxQJIHF9AtEH70kHoKV5s0A9iYWW9sNheCgogRUkb72cMblYOeSh0/ji?=
 =?us-ascii?Q?4Es/7JfMsV0+6NV/bA/EsRXQDLYvR3JUeGhRI/5LR9XDSbl4nlzGebXEjmqM?=
 =?us-ascii?Q?uaHQ7rQtQ51L+dDNmYidcJSoTIsDMooafAQbeQOuafMN1Kg2MHDEW2YGC3CS?=
 =?us-ascii?Q?COctvcBMWUAw03FtWMRZwIPDghI9zEcXppnAU/1ufXb7ktpCgpLdHFWMCIG0?=
 =?us-ascii?Q?L5Q3GV1ZlCkAPMMH5SrxaW1OFLweAIbSQUo0PiD2LH/Shufi5m38Ei72M6lz?=
 =?us-ascii?Q?Y97ZTBFit2XAC+AF8M7QJwPCY7EJZhPM+MnuHeIY7XZPs7/V3VsqD5QH7P8t?=
 =?us-ascii?Q?awhYpjeaUYGmzWRXClPD5KC+G9vFkyV2EQUxctJgA9vi5GsqghKPbFxA5ErZ?=
 =?us-ascii?Q?JKKYmTzDE3Rh1Xpdcqb9kDc/EqmK1a8nN8L5t6twiipyHAhtc0jCBHbyDE6i?=
 =?us-ascii?Q?+sszI1B3bn0Qjzqft68zFpFOL1AzhxexSFv3FPSWhO6bXxRxfCDORpWkkM59?=
 =?us-ascii?Q?PhrDxCUA6xKB/1vwy4isrAFFst1zM8Kk467DxOSoYE0nxJPZHSgo5Dt3k8Fr?=
 =?us-ascii?Q?WBrLB3G7IqSSeN1wPs6c1Xl2pUdR7RMt8JjPT9k609xbG0sw5u5xVFqrywPL?=
 =?us-ascii?Q?fYTkRNKjfF2UQQGVoNDCQoSpklygIcKQKonIMOzEMm52l/s0nfAGEU/rla/Z?=
 =?us-ascii?Q?VTyPbcH7PyclUOuPLp5c1oPR6r+2u7aKwyL68mrFG7E1VQMx9/NBFD0T0WUl?=
 =?us-ascii?Q?McQcMLhbINYal98fc4Djr7I6yeGK74hWGaN6S4DBSuBalHOgk0ULSpm/z5c2?=
 =?us-ascii?Q?NUAFokfQszU5sDn70HrKEnh3CqyB4dYWQRFx4rIOxwviV8O/peOYDks4bdDt?=
 =?us-ascii?Q?uSXwoT/EFyAKPUwb0NtXXlL28dKklFkrLJj4qX0a9N825atGHdWAJkJV9BMq?=
 =?us-ascii?Q?4mS7xdaCnWfD1V9p990whWQy8CeEDGuANgqPIvU1P8Fu+1GmjPERm8DN+YRE?=
 =?us-ascii?Q?45dMVTBO1lx7vSbbg1yKNoZZ3LQtJmHHsWLA16ogeA4ZyreLpvlYiJM6zpcy?=
 =?us-ascii?Q?sYWmWMVr12M9RN8gxv+y3DhhPQowONPCOe3C83PczCwY/KlIlfVumeM1gP5Y?=
 =?us-ascii?Q?KrylVecGGe8Tj8pXUtyGDiNQE5oUUgA6WabzmXie1hzEXahKlcM55UyOi8OF?=
 =?us-ascii?Q?jWNrT2FgaDEWoRsYqqfqejdE5V816uLztmtt4aX7tW/urmFdj0KggfOjR+Xf?=
 =?us-ascii?Q?/Tk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4951.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c2da6b-6ad1-477b-e88d-08d973071d28
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 20:27:43.9975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6aWmnPeVIi+Tw8WCjHMqD9pAOm1NnvoonF22XVyQSKd3Yng06psk0BXk1WoRs0GWICeN4r6ngR2BWiHD7OmjPL2MfShDO0oUY/2xZH/67vQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5144
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Wednesday, September 8, 2021 9:35 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Subject: Re: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE
> message to get SyncE status
>=20
> > > > The SyncE API considerations starts ~54:00, but basically we need A=
PI
> for:
> > > > - Controlling the lane to pin mapping for clock recovery
> > > > - Check the EEC/DPLL state and see what's the source of reference
> > > frequency
> > > > (in more advanced deployments)
> > > > - control additional input and output pins (GNSS input, external in=
puts,
> > > recovered
> > > >   frequency reference)
>=20
> Now that you have pointed to a datasheet...
>=20
> > - Controlling the lane to pin mapping for clock recovery
>=20
> So this is a PHY property. That could be Linux driving the PHY, via
> phylib, drivers/net/phy, or there could be firmware in the MAC driver
> which hides the PHY and gives you some sort of API to access it.

Yes, that's deployment dependent - in our case we use MAC driver that
proxies that.
=20
> > Check the EEC/DPLL state and see what's the source of reference
> > frequency
>=20
> Where is the EEC/DPLL implemented? Is it typically also in the PHY? Or
> some other hardware block?

In most cases it will be an external device, but there are implementations=
=20
That have a PLL/DPLL inside the PHY (like a Broadcom example). And
I don't know how switches implements that.
=20
> I just want to make sure we have an API which we can easily delegate
> to different subsystems, some of it in the PHY driver, maybe some of
> it somewhere else.

The reasoning behind putting it in the ndo subsystem is because ultimately
the netdev receives the ESMC message and is the entity that should
know how it is connected to the PHY. That's because it will be very
complex to move the mapping between netdevs and PHY lanes/ports
to the SW running in the userspace. I believe the right way is to let the
netdev driver manage that complexity and forward the request to the
PHY subsystem if needed.
The logic is:
- Receive ESMC message on a netdev
- send the message to enable recovered clock to the netdev that received it
- ask the netdev to give the status of EEC that drives it.

> Also, looking at the Marvell datasheet, it appears these registers are
> in the MDIO_MMD_VEND2 range. Has any of this been specified? Can we
> expect to be able to write a generic implementation sometime in the
> future which PHY drivers can share?

I believe it will be vendor-specific, as there are different implementation=
s
of it. It can be an internal PLL that gets all inputs and syncs to a one of=
 them
or it can be a MUX with divder(s)

> I just looked at a 1G Marvell PHY. It uses RGMII or SGMII towards the
> host. But there is no indication you can take the clock from the SGMII
> SERDES, it is only the recovered clock from the line. And the
> recovered clock always goes out the CLK125 pin, which can either be
> 125MHz or 25MHz.
>=20
> So in this case, you have no need to control the lane to pin mapping,
> it is fixed, but do we want to be able to control the divider?

That's a complex question. Controlling the divider would make sense
when we have control over the DPLL, and it still needs to be optional,
as it's not always available. I assume that in the initial
implementation we can rely on MAC driver to set up the dividers
to output the expected frequency to the DPLL. On faster interfaces
the RCLK speed is also speed-dependent and differs across the link
speeds.

> Do we need a mechanism to actually enumerate what the hardware can do?

For recovered clocks I think we need to start with the number of
PHY outputs that go towards the DPLL. We can add additional attributes
like a frequency and others once we need them. I want to avoid creating
a swiss-knife with too many options here :)

> Since we are talking about clocks and dividers, and multiplexors,
> should all this be using the common clock framework, which already
> supports most of this? Do we actually need something new?

I believe that's a specific enough case that deserves a separate one
Regards
Maciek
