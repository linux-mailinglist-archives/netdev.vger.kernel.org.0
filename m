Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074EF3ECFEA
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 10:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbhHPIFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 04:05:45 -0400
Received: from mga11.intel.com ([192.55.52.93]:20372 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234610AbhHPIFg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 04:05:36 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="212696956"
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="212696956"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 01:04:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="461975068"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga007.jf.intel.com with ESMTP; 16 Aug 2021 01:04:02 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Mon, 16 Aug 2021 01:04:02 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 16 Aug 2021 01:04:01 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 16 Aug 2021 01:04:01 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 16 Aug 2021 01:04:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NMvSFmbTa7mjHKEV2LkMwqxghr/DLutHsHPYlx9EJotNMwJ0oQ2vBBMddXIPPXvfJhl5HPfTt86s5OKCOO8vIGmJGmcO0NMf5tNnyCbtBgXY7ZZEr8Btd0U+J0CH44aX/104ACph8+ijXMrOqwXmFz7Gltua6Ro31JN3CQ0H2Xn23anFJGMHjCJ+1qNX9QbOJh8KcpqX5DHUGusRc2Nrh87w0lXH4jwy11u9Cay+QVp7rOAhewP9RWDuomNp1Qlpz4ZhxCCxCUVvDOZ9izucBc9nFC8ykyHQS8Y/JbKYPtweUg4Xv11300WMZ+qe1QxrplWvCimcmvA/aP0lAHxnGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rSYzn+mCf9hj9NgQl9tc1U03zFKAtR6i5/M8IaT24A4=;
 b=jbKGM8q/0FTHYr/hYTtbnqzmHDc+Aobf9CPgz1M4EzQS28MS65NhDym9zrj48/Rhly822fpNFnmojNKzydn7Oh49i/Hjo8wPD2FhJY/KmLmT3NPeFEaoLTCT8pnUaVOXp2uh8SOqP6sY/xtyCCFM3ld6ZzwXa5wGIPkRmbpbhrTXSxWTC44ILbdkA2ad+WBoTXHrHAmtDxyhFD6PEQw0+D1B/wGUKROxpa+2L8bzej6m6dtUAcEdv9ksAEHqAER6VNo8vsDNkvyf+QbQENBgNAAa1ed/dS96+etdgrLlF0Mo7mh3AIUsj0qVwSC7J+balAAAvr9IYBtDTSACiuTtDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rSYzn+mCf9hj9NgQl9tc1U03zFKAtR6i5/M8IaT24A4=;
 b=wjyGM1wrgb9/xSCPFkSygTv6hK5v9It0Y4Pf60BoP1kT9l/xtpzUKg7zMn9OPdQzk6/Ude+V2Of5f3I6/yZfybFWknkMjAeioFOSFDDD523H/Z10bHv3hw6nSJmJ9GWoIGgEm5bo5mVNAGuhLxaMzhqObYOyHH4bJUERvsOKBKQ=
Received: from PH0PR11MB4950.namprd11.prod.outlook.com (2603:10b6:510:33::20)
 by PH0PR11MB5174.namprd11.prod.outlook.com (2603:10b6:510:3b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13; Mon, 16 Aug
 2021 08:03:59 +0000
Received: from PH0PR11MB4950.namprd11.prod.outlook.com
 ([fe80::784e:e2d4:5303:3e0a]) by PH0PR11MB4950.namprd11.prod.outlook.com
 ([fe80::784e:e2d4:5303:3e0a%9]) with mapi id 15.20.4308.026; Mon, 16 Aug 2021
 08:03:59 +0000
From:   "Song, Yoong Siang" <yoong.siang.song@intel.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 1/1] net: phy: marvell10g: Add WAKE_PHY support
 to WOL event
Thread-Topic: [PATCH net-next 1/1] net: phy: marvell10g: Add WAKE_PHY support
 to WOL event
Thread-Index: AQHXkCCVH1orffAF2Euk1FyXsMmop6tzQucAgAAKnYCAAB0pgIACCFZwgAAXTQCAABQhQIAAHfaAgAAGzYA=
Date:   Mon, 16 Aug 2021 08:03:59 +0000
Message-ID: <PH0PR11MB495065FCAFD90520684810F7D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
References: <20210813084536.182381-1-yoong.siang.song@intel.com>
 <20210814172656.GA22278@shell.armlinux.org.uk> <YRgFxzIB3v8wS4tF@lunn.ch>
 <20210814194916.GB22278@shell.armlinux.org.uk>
 <PH0PR11MB4950652B4D07C189508767F1D8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
 <YRnmRp92j7Qpir7N@lunn.ch>
 <PH0PR11MB4950F854C789F610ECD88E6ED8FD9@PH0PR11MB4950.namprd11.prod.outlook.com>
 <20210816071419.GF22278@shell.armlinux.org.uk>
In-Reply-To: <20210816071419.GF22278@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 798349bc-25cd-4e19-d410-08d9608c6726
x-ms-traffictypediagnostic: PH0PR11MB5174:
x-microsoft-antispam-prvs: <PH0PR11MB5174B7D4D2525E517CD95CAAD8FD9@PH0PR11MB5174.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HOdGo/X+wF7jX0zbe5SWrhWbyHy5sqDdZdgerNrgeNSfGxDD+YIvrozZLTOK1C2vOkwQHDiMw5MVxkJ5jqcxIWRtbW/7NyJzNKKJReD9/66pC6F+lfusxGUBUgqZkcbR7nOqHiFeM0qZ8dAiNhZuyN9OLJjKape6tPsz2nkz3y3JMt/c7xKvSx5F5xCL4Zxj9WFcM77pUT//tjOuVidlvWHhUQ59TD4iCwWk9nBgG9GIl+VKmRZvkyobprnav4yfFBj3t20zEONCijx7ia0XIGwVKX2EI7nuzCZiAlkmgZyw3mxoaR08BIicCxgr+fL4ZhtSPJ1iZrVelsTGCHOyCgJFQGMcA932A6gAa9pyhAGjZoS+Xie5QQRAC/2232p3xVDwd/WeIOc3aeeVT/TrO+EHNjOmQlBxLe9rd4yDahhVc1lmGwtw/3hGyw+QBsd6HVFiLyumGb4AWVj2SDELFVn7lg21TzTaBgtd5tmGn8pTru63CVTT091e6ho/fi7SQA5tGdaOAtLboPbbvfm1ZkSTMl/rAi37G1hYoozvgQ0HILCaXp+hgGaKIivx0eVre6Sw5a7+rU0wh69FM14MBO3DtmBuzLi+IHulvRhKWl0GQTPSUtRfE4IsDaTja2thaUq9WEqLATMOvvp2W6NsCEXm5oVb+ns4QV1ye7AF6TYfM2KbpO8/h5qYIg5cZc2qWHtcVB8yc9dsPECUhVl0f+HRO93K82kHHLzFZcEt4ntB23Mr+FSZFuikrIX79sFTjJ8u3dgtMOQAQdfntH8VGHKoxxC7cKG6Y0YMkXABJTw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4950.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(64756008)(66556008)(66446008)(55236004)(66946007)(76116006)(7696005)(8936002)(26005)(2906002)(33656002)(5660300002)(86362001)(4326008)(52536014)(8676002)(186003)(316002)(38100700002)(122000001)(9686003)(966005)(6916009)(83380400001)(6506007)(71200400001)(55016002)(508600001)(38070700005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?1cagBXEW8NXgraExrEh0TV/iyRMfi6+1Rc6Ro4BBEKnLtjlJAn19rBnD0z?=
 =?iso-8859-1?Q?R3hqdCohtcao/g24LxVKaWnpf69tEsLUdrvNuOezJXsp3fFxBSa5JfS1bB?=
 =?iso-8859-1?Q?t5nBqDBHrGq8BMRHaYo+mBlIWEgyyi1tAyo4zaoXQo2hLM+kPKIk1EJ/Ks?=
 =?iso-8859-1?Q?MB1G+A62+IFW5MeLMKmgOHNoBbOQEEgHcyk0GtfoTe4+3WFrUdPz6Cn7e7?=
 =?iso-8859-1?Q?qy6K8koKBnmYvsmLobVQtBqBnW9RPRvfoXWjiurhXEQdciy3E9ME5i4XmN?=
 =?iso-8859-1?Q?99VLr4xDGgVqMGM5GDzHRt+ATNsqDpqMZkwoDt1OXUodyomI46jFtkt06H?=
 =?iso-8859-1?Q?FtdL7wfjaQf8ucell4wBBXjtWX3ppbP9rN9oZ7v+i/H8bVFTkTI1p4P+c6?=
 =?iso-8859-1?Q?rG+NYXp7CcTTY5mqAfO6TEBVSU3C9dyJVN5KkhqRAjwXzfLHjCzJM61yoV?=
 =?iso-8859-1?Q?4PyUXJ1u8bn3wIc5whkFhelqwS192ExoXJppzUNrLAd3jlLKcpnKMPKUuJ?=
 =?iso-8859-1?Q?AE/KimrnKCqGEztNzcufw6lZ2Bo6y+oeGCP1D6hgPAWFrL2Sgixu13IBij?=
 =?iso-8859-1?Q?m4xt5ay9SAR/KwPjtUYEePUvyrpoDfz/PykYIJIHNFHb+wFhH1f6Ydf+S4?=
 =?iso-8859-1?Q?D4Y2uuuqzp1UFNzdonustuyP7IJ++TH9xgqrwDk2kriBZKFoXkqgUFNde6?=
 =?iso-8859-1?Q?C29FM4YeJaTplaxKfAAkprk/Z8Ju5n7hCU8c/T/k4Sb+mb05pMMq3bUBi1?=
 =?iso-8859-1?Q?mkxZXJoUBjqKhjpjKBgXBH3ecFouiuFHKXfc2H7uO/yX6U+Zd9kBiD4hy9?=
 =?iso-8859-1?Q?qhIkUlRcnTk3epdR3TrC/MU0TROLI6+xFfnaEy2oXoXfhGk9aB2ADm6it/?=
 =?iso-8859-1?Q?tmCgJwHMkai6CgSaHapOUhSjr1vHrFIu8yGikJOMVBbywipfrQsrS8Gcyu?=
 =?iso-8859-1?Q?ZHOOzyyiZ+BPAjcqW5agyYJVvwJKK0MJw7dmaFyLmLCw8hgaciwRRjuMsH?=
 =?iso-8859-1?Q?Lx1FVIxNM0s71fJeuDeZ4NfiYdzzvceaJp0c8vBC4F/0oCn7mN6wxbHkli?=
 =?iso-8859-1?Q?AK1yv48o4eQkGjfVGfQCcZFNzk1OsWuOf4gmg0FRHu0wsPOuB3cV3yawz4?=
 =?iso-8859-1?Q?YcRDoDU+qOqmk3Aww2Djd3WBp0QFNuImi4hRSzgsx6rRvoUZxrHYWVkvVx?=
 =?iso-8859-1?Q?45tZfQQCNvPfbFOEb2iUax9GC0Wla0M9K5nOh8Scyia6VL0CgdMxLbRADd?=
 =?iso-8859-1?Q?rq0IXNv2aAKRPlss8MoW6zfuUt/+BflHyoD8bbUdET6FxFaPjcq113juXd?=
 =?iso-8859-1?Q?WXFLH3LJFc7/+wDj3mlYOTc3F/axvS+1QCt3uBjw2dVpf8XamD01Bi6YNc?=
 =?iso-8859-1?Q?5Vve8FCWv/?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4950.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 798349bc-25cd-4e19-d410-08d9608c6726
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 08:03:59.0448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3zCNeuRcC6bwLRAmuVcyeJiJ2iEiagL4F/zqeEBAf8wJ7yai15UorZtWByrtIrUfpWrnFpYSKrhSkuyZu+hwgh6PhLl2hX8tL/9FLGVdK/E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5174
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Mon, Aug 16, 2021 at 05:40:18AM +0000, Song, Yoong Siang wrote:
> > > On Mon, Aug 16, 2021 at 03:52:06AM +0000, Song, Yoong Siang wrote:
> > > > > > Agreed. If the interrupt register is being used, i think we
> > > > > > need this patchset to add proper interrupt support. Can you
> > > > > > recommend a board they can buy off the shelf with the
> > > > > > interrupt wired up? Or maybe Intel can find a hardware
> > > > > > engineer to add a patch wire to link the interrupt output to a =
SoC pin
> that can do interrupts.
> > > > >
> > > > > The only board I'm aware of with the 88x3310 interrupt wired is
> > > > > the Macchiatobin double-shot. :)
> > > > >
> > > > > I forget why I didn't implement interrupt support though - I
> > > > > probably need to revisit that. Sure enough, looking at the code
> > > > > I was tinkering with, adding interrupt support would certainly
> > > > > conflict with
> > > this patch.
> > > >
> > > > Hi Russell,
> > > >
> > > > For EHL board, both WoL interrupt and link change interrupt are
> > > > the same
> > > pin.
> > > > Based on your knowledge, is this common across other platforms?
> > >
> > > Other PHYs? Yes. WoL is just another interrupt, and any interrupt
> > > can wake the system, so longer as the interrupt controller can
> > > actually wake the system.
> > >
> > > > Can we take set wol function as one of the ways to control the
> > > > interrupts?
> > >
> > > WOl does not control the interrupt, it is an interrupt source. And
> > > you need to service it as an interrupt. So long as your PMC is also
> > > an interrupt controller, it should all work.
> > >
> > > 	  Andrew
> >
> > Sorry, I should not use the word "control". Actually what I am trying
> > to said was "can we take set_wol() as one of the ways to enable/disable
> link change interrupt?".
> > PMC is not an interrupt controller. I guess the confusion here is due
> > to I am using polling mode. Let me ask the question differently.
> >
> > What is the conflict that will happen when interrupt support is added?
> > I can help to add config_intr() and handle_interrupt() callback
> > support If they will help to solve the conflict.
>=20
> The conflict is - when interrupt support is added, the link change interr=
upt
> will be enabled all the time the PHY is in use. This will have the effect=
 with
> your patch of making the PHY appear to have WoL enabled, even when it
> hasn't been configured through a set_wol call.
>=20
> Essentially, your proposal for WoL on link-change fundamentally conflicts
> with proper interrupt support.
>=20

Thanks for your explanation. I understand your concern better now.

In the case of WoL hasn't been enabled through a set_wol call, the PHY will
be suspended, so we no need worry the link change interrupt will create
an undesired WoL event.=20

In the case of set_wol is called to disable WAKE_PHY event, we can keep
the link change interrupt enable, so that it won't affect the interrupt
support.

Since any interrupts can wake the system, as long as we handle the
future going-to-implement interrupt support properly, things should work
fine. Any other thoughts?

> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
