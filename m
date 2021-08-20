Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B984C3F2454
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 03:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234577AbhHTBXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 21:23:44 -0400
Received: from mga17.intel.com ([192.55.52.151]:46172 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232564AbhHTBXn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 21:23:43 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10081"; a="196947284"
X-IronPort-AV: E=Sophos;i="5.84,336,1620716400"; 
   d="scan'208";a="196947284"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2021 18:22:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,336,1620716400"; 
   d="scan'208";a="573783023"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 19 Aug 2021 18:22:58 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 19 Aug 2021 18:22:57 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 19 Aug 2021 18:22:57 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 19 Aug 2021 18:22:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GWHzJbMYbFWOsnsnk9kQ6VqH9fNDxrrCDFiMiymg1RfSdiaSQF5muWJ57d8zWG3Vb7qPF1/1cPiYb9zUIVjqvm2pSDNfgHQ2QDmVvv3nf40NDK4+VJ8W5StLnR61htOnGL+s+EH4V7vnFtbnOa1LoLYGd3A+dqbZz8EVARhLUWGJtreZztayjRLmC2hrwhiX4iHYhaydS9+tD2q05lnaK01ttzMOWyyosj82r2AMzwVAWTkSFG5FbyDlruOn9a+0QypMOXJYz951DeAJkOfeki6KdTz+vsHDlp8xLXGI0weEiOKcpA7fF/HkNUqYsGKSeNQ4VuWXViBLy/264YRV+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vWauQEVQ70hvDdqo4KOjJO3AicvhqYduvl2+XtqMUzA=;
 b=CO60NsT1V1dcybAD1zkh0PdkK0whbYcOBPGtahgPnxmZkMWxCuUIwqHuCtV1Qkqh1MJO3cPFnS0HeHUd7Obu5WU/bbIO8rQdXdJpyWEl53R/x9xZg/YmCgRNhHvyccHIZwGenU1ACRfk7e24JvjEO2WGMPef/3f9lmHsnd5XOgiwbVcBhY+gOYr4pFKB6A317bYWBgX8jENNfHotz1q1kxNkEVzexdye9sbtN6p9CDrUra/xtzk695CCaVO37MujjhAEr4sDmEuSO9vVbh0YobWbzEL6ajHbeKRpqZBQaljHtsvhutUUGgxwvQxQNhMMUTV95S4Lx76N74soV/o5Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vWauQEVQ70hvDdqo4KOjJO3AicvhqYduvl2+XtqMUzA=;
 b=qy3YAfpANHVMp+GR5LxoDdirdDKt0b3T08VKTVUSIUmpXosWJY8VaW6C18vFAm/ovHt00J0HOXyeGCJ0cecI9PqQGl8VaQ8MAgoTwVvnT9ugbYXjNDn9hBcJrY5tgSuRVGWN2CXmSitW/AzwqpsCItTXfK4ymP5AW2fh/czdm0Q=
Received: from PH0PR11MB4950.namprd11.prod.outlook.com (2603:10b6:510:33::20)
 by PH0PR11MB5078.namprd11.prod.outlook.com (2603:10b6:510:3e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Fri, 20 Aug
 2021 01:22:50 +0000
Received: from PH0PR11MB4950.namprd11.prod.outlook.com
 ([fe80::784e:e2d4:5303:3e0a]) by PH0PR11MB4950.namprd11.prod.outlook.com
 ([fe80::784e:e2d4:5303:3e0a%9]) with mapi id 15.20.4308.026; Fri, 20 Aug 2021
 01:22:50 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 1/1] net: phy: marvell10g: Add WAKE_PHY support
 to WOL event
Thread-Topic: [PATCH net-next 1/1] net: phy: marvell10g: Add WAKE_PHY support
 to WOL event
Thread-Index: AQHXkCCVH1orffAF2Euk1FyXsMmop6tzQucAgAAKnYCAAB0pgIACCFZwgAAXTQCAABQhQIAAHfaAgAAGzYCAAAsMAIAAATnQgAAZtYCAAFGJUIAAC2WAgAVZPWA=
Date:   Fri, 20 Aug 2021 01:22:50 +0000
Message-ID: <PH0PR11MB4950AF75A507FDB0885174DAD8C19@PH0PR11MB4950.namprd11.prod.outlook.com>
References: <20210814194916.GB22278@shell.armlinux.org.uk>
 <PH0PR11MB4950652B4D07C189508767F1D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
 <YRnmRp92j7Qpir7N@lunn.ch>
 <PH0PR11MB4950F854C789F610ECD88E6ED8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
 <20210816071419.GF22278@shell.armlinux.org.uk>
 <PH0PR11MB495065FCAFD90520684810F7D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
 <20210816081812.GH22278@shell.armlinux.org.uk>
 <PH0PR11MB49509E7A82947DCB6BB48203D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
 <20210816115435.664d921b@dellmb>
 <PH0PR11MB49507764E1924DAB8B588D59D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
 <YRqDz9QZwqjadNdL@lunn.ch>
In-Reply-To: <YRqDz9QZwqjadNdL@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a104190-6b54-4f96-9fc2-08d9637906f6
x-ms-traffictypediagnostic: PH0PR11MB5078:
x-microsoft-antispam-prvs: <PH0PR11MB507815B8DC14DF864433FBA4D8C19@PH0PR11MB5078.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pgC9qLKH/ngCBc3eky8KPHf+BzbWy7y1000vIy+xjqtLKiVL3Vk72yWeq2IdAmM5ep7SRnPeIxH9QHNke06f5rOy7gwhjnFFPoB4niO9Vku5SJ2/engw7ZCkekzcnZ4E7goZ0lXUZHCB9zsPzMt/ms6OnCXcmmqeNafGRpoyGvA6tLJqRmWLv0Ug/HlkAwGDXx8p7YRXXSAZBfWls5Arj0GmWI3EWx1VEJSmW+5DkKxSIOn+fFY/7QPtww8nMeWGgFA2EHTktOFdYmcKa3H0b5Cijp9yctVpzwkOmm2fehocGiipre/llnT2Z1j+WsfmLigonfpgNa3gniTof8rHjRzujjUYRMFExi1RHDKDZnNDOHBbuA4ajC7LMz4xEi3hK3vysQ6++QlgJhZMx/piH89Y25E49jGg4m/qdjZPWQwiz1HkXYce+wxckEV8tfRCWud7cbtoc8lM1kIV5jCddIHohisnV3yutaV16I54hekRaaKbV7hV1aQpC6MTVWNLZ27yK8LshaBUYJ/oEzfU9k0qCBb7WhVp8fl2Bm9FNYMYPK8YDGs01oOBuJ6gvHapRH+mVsdSLEm7QNkDyU1I6/AUR3YXWHhomxGm+UBWiglCOi5ExM9NhMUWicnF277BduTpMMJfUcX+3KQ9UvmrHozs7eF2cR7su1SrjWQJrKu6tYPV8yqOMSioERHXmjilrOBKAgrRYzM380+YTE1ecA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4950.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(376002)(346002)(39860400002)(2906002)(38070700005)(8676002)(8936002)(4326008)(71200400001)(33656002)(86362001)(66476007)(38100700002)(186003)(9686003)(76116006)(26005)(66946007)(66446008)(64756008)(54906003)(55236004)(316002)(122000001)(6506007)(7696005)(5660300002)(52536014)(6916009)(478600001)(66556008)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?XO8Zhyy9AGcGUAKO5uwGOpjvrIUCC/S9a2X9M4urycC84oQaUctfoJ2KgQ?=
 =?iso-8859-1?Q?n0GOCrR24CQ3vA2lN6ju+9q2YitFUN24sKsSmjPhcVxp9qZnvXYpdwRIr8?=
 =?iso-8859-1?Q?N12ozbP7Ql/L94sAVdagpIUNini/YC8TAM33WUM8Zc6tRgu/KkMEafJUmY?=
 =?iso-8859-1?Q?kSlUgX7HV/WARwTBQ+uD64Bh41oJoJDv+o+4AJNG6qPV54iQnH3FEv29iM?=
 =?iso-8859-1?Q?xEWWU0q1aCO/AjVlhxjOIdcdel21p3WFQvGBsEoFJ/cN5Q32+g4Pf3cWeh?=
 =?iso-8859-1?Q?g/PASbY/ghc45JlSv3ZBoIPFQGigYU1DnrkAEPWYuFFa/Jf37Vvc3H2I1m?=
 =?iso-8859-1?Q?O8y85rvwArP7dYhDa5Pasl3fj7Tu62E0nYhM9pRpe6WbowGTweF/7kpIwp?=
 =?iso-8859-1?Q?fhvSJ9qC6JKgaK4Y23JAHj54YnZCEHAS+i2H4sOtqaUSvyewN6iTnX4yKF?=
 =?iso-8859-1?Q?gM+iwf1ZbI8yqS5VyPPdPXX1pSdyxXExTDcGFOvK9xLJjZXZoWuEPpNW7e?=
 =?iso-8859-1?Q?rbTadZYlNzmSS5ws/SMkuNP9JQPKpeKkMcWpgj11w3WqT2zObUvRmaPFfx?=
 =?iso-8859-1?Q?QEAdMK8v0iECQKyfAU4oG2vRiIPb4edc6RPc+Kb/M1TW0BN+CYaY3SkrbR?=
 =?iso-8859-1?Q?e4HWprEWFmxndiowEHx9XAaqriS//rRHyoluNDcp1iBFmMaK3MYMaJsSWF?=
 =?iso-8859-1?Q?Smv6T/z24141BqEor4OU1J3ZWxoidZbAslSCIVvrkqqar3H8l+SBzT7JFS?=
 =?iso-8859-1?Q?F65KFEhJ82wH7VPjnUPn6Ht9k78JPzAr9o1X0sbUjcyLlyAS4VHjx10VVQ?=
 =?iso-8859-1?Q?5BFj+vF4mupASejEiNGkU/4kvfg8NY1WnoxWRMHEw+y08S3eQIbskU7BdM?=
 =?iso-8859-1?Q?b8TLq6TyUyBj6ItdO/0Yec40TaIeDer16TSuwgYLIygLC2NMF4DLttd1KG?=
 =?iso-8859-1?Q?nAJW53tjZzqUMKDWauIJbWBwOw9eQVkNqfpHGRdj+osLitbF74W/sVVAjA?=
 =?iso-8859-1?Q?3MELRaN87uFWZynlUlsLKfHp9Sm/TOTGWQ6ZiPFjnm68QtMIn1ofWyY1t1?=
 =?iso-8859-1?Q?KGZtVYGtLrA6Jpwd0spXo/pdDfvr+Of54ZevWKoyLxbUlr6wsuWTmfHVEF?=
 =?iso-8859-1?Q?4YU05pM/c8+g8RVERfbJLAvGZR8bKq1gjVr/JLgLKLvnHqSaopDXtoTF5L?=
 =?iso-8859-1?Q?xV/rYG7uXXojTbfzVfScLcnjTUbJTvnlaepzaDR9x5jC1KrWrTz4oPNGMd?=
 =?iso-8859-1?Q?2FcuTZVissLplWN4vwgMa8GQ0UJBtpwsRJMqMcDtuArTR5psitRBqQ/RGR?=
 =?iso-8859-1?Q?hRkgHJaPpgro2GhPPEhG4VHwhT9MGQueYIUgxKIXC1xbIbAW22OrP9thmu?=
 =?iso-8859-1?Q?bXih7sxgaN?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4950.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a104190-6b54-4f96-9fc2-08d9637906f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2021 01:22:50.7051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7Wvu2wBInLm+/qv8tsZ5DDTqveEpGevr3ebs65IFG5mZf7gLiMCXm+SvOf8BOFJGXk4WSlGPCWhKtjY4EsqJtfF3rsRAEmVwPFmwPHpfZDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5078
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > > Yes, you are right. I missed the effect of get_wol.
> > > > Is it needed in future to implement link change interrupt in phy
> > > > driver? Cause I dint see much phy driver implement link change
> > > > interrupt.
> > >
> > > If there is a board that has interrupt pin wired correctly from the
> > > PHY and the interrupt controller is safe to use (i.e. it is not a
> > > PCA953x which cannot handle interrupt storms correctly), then I
> > > think the PHY driver should use the interrupt, instead of polling.
> > >
> > > Marek
> >
> > Any suggestion to avoid the conflict of "WoL on link change" mentioned =
by
> Russell?
> > Is it make sense to create a new member called wolopts under struct
> > phy_device to track the WoL status and return the correct status in get=
_wol
> callback?
>=20
> I really think you need to look at your PMC and see if you can make it an
> interrupt controller. You only need level interrupts, not edge. So the
> microcontroller in the PMC could just poll the GPIO. There appears to be =
a
> simple IPC between the host and PMC, so just extend it with a couple of
> registers, interrupt state, interrupt mask, and make use of the existing
> interrupt between the host and PMC.
>=20
>     Andrew

Thanks for your suggestion. Currently, PMC is designed for platform-wide
power management and not meant to control any device specific registers.
Seem like it is not possible to make PMC an interrupt controller, but I wil=
l
continue to discuss more with my team.

Regards
Siang
