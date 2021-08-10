Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B20C3E858D
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 23:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234904AbhHJVi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 17:38:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:50025 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234814AbhHJVi1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 17:38:27 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="202182288"
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="202182288"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 14:38:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="638947209"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP; 10 Aug 2021 14:38:03 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 10 Aug 2021 14:38:03 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 10 Aug 2021 14:38:03 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 10 Aug 2021 14:38:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NMv2hJW3+Tp3sZgWEYH3uMgRFcrwbAaD8hQw71pQKl61biZ7QOVDahJuvvQwHnHZe8Iu8Dm/qkDZpnwxPfTa+y6j7zdEBW8YW5kbbO5RWNwhGB71v5/NbFGUmGk9mimNd6fn+m2r6FD2MRrfox14kt4CmeqsCtDCevjn5JI3w3IFL9Dv689bQeouV+Ob/KyhJC6da820n1vF6kDHeixdLNMXDtIxrDF+jYhI60ENmq8rIhKMFajjGtAa97WYcqeJAHoRTsDlJVdhioy7SGS4UBx0tDbUNRfNs/BFsPoNZ9XbRJCuYFnSrtJ3QWBmugP27f8WcGMkR7yfG8lpRsQJ2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8f7FRwG2igz+5OPnaPMwoGguO7UkFvJnnXKnW6PPxk=;
 b=av0JM0p9l3SkNsbZgCFKreU8wRoHVF8dzppPou6rF/g2NZwf0B+hMbGQFrRqoimtD8Ebo6GQvQ9anblkeoyHdrdDu82fLBqoOJuCzEHBUGcQ5f0LCUt2Y8QMGx9Cl4bO0mThHS1P0MEgDMjmFWFx7mfB6Y3EjFdwVesK/pVtM91KR/PmT1scLIucduALcZZeU085BLIiQd7EMih2lI17p43zeAaoa2HgjmluiU+C3RWih8Bk8YeFCeUgzMrLa0M1LH/t9aqbxK4pKKGL/6rQeOGBPC9HF/N+MYxEhuw1/PPvNelDQvr7DuSW3c24ReomorflbFEISGvqpUBKQueuqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W8f7FRwG2igz+5OPnaPMwoGguO7UkFvJnnXKnW6PPxk=;
 b=MZSYK+C+tiFvmKXmbPbHbsaCoCpmFd92xKF+4fP4+iRzL1hoakPsRypoRScgqktAG/0cu7OdzwR+6wq1bm6RJ2a8oSItp1h9OcGH7ZGEV+kbVgII2Iu1N0Si7HULC4IX4N0AJxHHkwYLz9/Y48cuoWeJhlO3UPvPJP5CcdzilC4=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR11MB1696.namprd11.prod.outlook.com (2603:10b6:300:23::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 10 Aug
 2021 21:38:02 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960%3]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 21:38:02 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
CC:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "pali@kernel.org" <pali@kernel.org>,
        "vadimp@nvidia.com" <vadimp@nvidia.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: RE: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Thread-Topic: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Thread-Index: AQHXjQh2iw3UgViIbkGUQrHAheSIDKtrO5cAgAEcgYCAAGu3AIAAAh0AgAB/zPA=
Date:   Tue, 10 Aug 2021 21:38:02 +0000
Message-ID: <CO1PR11MB508982C614F01E97DA595BA4D6F79@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20210809102152.719961-1-idosch@idosch.org>
        <20210809102152.719961-2-idosch@idosch.org>     <YRE7kNndxlGQr+Hw@lunn.ch>
        <YRIqOZrrjS0HOppg@shredder>     <YRKElHYChti9EeHo@lunn.ch>
 <20210810065954.68036568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210810065954.68036568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08ce6a5e-a291-4c87-9ac6-08d95c472171
x-ms-traffictypediagnostic: MWHPR11MB1696:
x-microsoft-antispam-prvs: <MWHPR11MB16960A694A0F4E829E525886D6F79@MWHPR11MB1696.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2GuGZX6OJXrEc3pTJG9h+GIEGkFnnnmXScgJ5SNmGOD09JiCivVFOzaYs0S3P6+xuXwDOT5Mqz+wSjz5AP+w6Jngli8WWr/Iy8PvPehOGZn8Cm9R8wdTHlyWDOg79t2JH6mXn7Q7YywCuvk8rVeoPSAI+52cC3UnD8jNivHhatmybJlXvlH2OYDSxBQNhlMLapmC3lkpKtHjJjzkIeFNJNILSDfSi7Ad8MVVpLsQNaSck/OM+GL0d5Nn4rAdXcY1/58590zPveT34sQZORN/3P6wwwQttMgli+VW4mOO6LyPQIuchyMhV2rBo7S9s0R6M/lkf5fqHBy93MVmYL8T3d5Q7boNB4L2rZqJsfu2GtROiSYhKKxhvqh1be3GiC7rX3djLoC68iHUGfrrPv9yx2+GBGz1creVEDko26TV5WPEcglry0MSs+UnpnuN36uzK6kseNirEAIntjLICj9pGIbaX0/R7kTNtCdw2MyquhZCPr9LSePO21fzchIQVW2k+rVrMPT0pbLgTTKDvcqvkegkYOITR8+PZtaamsjLM1FQM3h8g7dXL6aAlnBGMRWkB88XQsM3F0HgvDS3MCYn57mwcVkm+Uu1QTEcdm3g1eqIxwT7ysWVe2qVIE6ZcXmUD2budPmLIS3v121Do34ud3BMDyullrUemgAo/FUypfthmgq3bz9KiqXxjojyMYLDQLrCc/ofkj2QUqF1ORUaxg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(376002)(366004)(136003)(478600001)(4326008)(122000001)(38100700002)(8676002)(71200400001)(55016002)(33656002)(86362001)(8936002)(7416002)(9686003)(66476007)(64756008)(66946007)(66556008)(66446008)(52536014)(76116006)(83380400001)(5660300002)(186003)(7696005)(6506007)(53546011)(38070700005)(110136005)(316002)(26005)(2906002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xtWhyjv1FWKaoGByKmWqNy3iUCbEA5T9r1RJD+7Hc3SRmSaKG0rUBo7to8/u?=
 =?us-ascii?Q?X24cuG+HBiKBxSbt/5aRTkfAykyAmFcb97f0joJ7gKZpRs2s2c5yuPkexlAy?=
 =?us-ascii?Q?3rcVh5kYnPvecLV5tg6iYJEqcIDSqkoJMI290TfheJnDLuUfE1F6/56L3Cl9?=
 =?us-ascii?Q?3vIW2+lZZL1jk6gBQzsrUn6qI6mWKuzFkuBv59xiL0cVU+tXFYu1amQlNXtn?=
 =?us-ascii?Q?l21boTBrLgmduI0H4Ogp4+myjdKTN92jc3nI4KXMNFE/7qixNDYBLOJOzKSa?=
 =?us-ascii?Q?GXMeb6RonPrdqYn6syFw+nTUq+1bV1+ky96NiMcepZEXobaphjeUyYnaob+8?=
 =?us-ascii?Q?gA5VycIzrhj59CTyT+IhhiykT3jMT/S/HrNcIgMMdot6/BRP0slM+Eg4H/TP?=
 =?us-ascii?Q?xBzRFeBmfroIGGU+/aOhjAiuzszAFWygmewl07BRaP7bSkpRz3L0NeV53V2e?=
 =?us-ascii?Q?O4ub89xETV4UDzK9k0PsoXHgqNFGCEFMf+EBC6XeMGNvJOdgJOvU7pvcfwvG?=
 =?us-ascii?Q?G3OEqPhOsMkz4Wh0EFJy0pf6dpk4p7Wb3P7UTU6AHQ1wufEPnRMOiVN8xpCK?=
 =?us-ascii?Q?CiiYzSZQigVOg7xoRHUix7aRmDyMuuLVXEDQgrDd7FLGSRGyLIJxbpeVsR9Z?=
 =?us-ascii?Q?URxt/rarhgAYHcK9nLAEwWoRLIevEbR+VqolougPW3PAqBmUI+YPMUGZ9WVo?=
 =?us-ascii?Q?rRGIB4Gli5qHEn3cZ2NqJMpwVL6D/qVVEho8wD2TTMRwoV3lNjJ4Xo8Fhex6?=
 =?us-ascii?Q?b4KQ9clYRs857RzEvu/4gitv68MVTOpeZRcqc8cFnT0cSdF9tDGjOHjQrxTL?=
 =?us-ascii?Q?DyycVemRxTCCKDMUiTbHI5tVJu7ysSKwmDmof5r8ZxrItDB+7atknEp3r0tt?=
 =?us-ascii?Q?ppW0Tp1U0Di+e8Ljy5ci7dsVjWkPHmXl+1XjeQY6MjnH/OOORklDuxpTkCOJ?=
 =?us-ascii?Q?PL2jlyTLZA44p3ix4rCaTt4ajewTuYEvbBsUPv6Zx2gWsdQEpAgtBA7+jOJb?=
 =?us-ascii?Q?PLtImWcihyrf9yIyIu7+fEUKckhvVleyOF9DF/lvM/Xwwz4MQvw78cGtBz6H?=
 =?us-ascii?Q?NzJZrhxoLbvvTWNUw/SF47vDF6ccCLN8cIwpVZPhOEJPJw4IfhGtnFRryS/p?=
 =?us-ascii?Q?xwGafhuIic1m4uUTH727SvvaCIXw7Rxz0ptCISSwpOKTztQfwex7Jm9v9P/+?=
 =?us-ascii?Q?NIi/Doz8pN34PMeXATvGdJKSrlGoDNKedlMSjsNRdGdZXr5nvU51mgSYCPiA?=
 =?us-ascii?Q?DM7OlV+d5TR2yQyoe/ADk/t5SI4gdgmoo17LA109qoyHero4soOyDvN6rq6i?=
 =?us-ascii?Q?Jmk=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08ce6a5e-a291-4c87-9ac6-08d95c472171
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Aug 2021 21:38:02.1977
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bytiH9VV9MFyBeLnxe14ryXg8jYoPlvq7Cr58QuiUi9UNuULLzhiFzeCt10taEX9ddN8y3nLJQwEHBrzg5Q85XyBh2c3MUcqbOIfbqHkIh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1696
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, August 10, 2021 7:00 AM
> To: Andrew Lunn <andrew@lunn.ch>; Keller, Jacob E <jacob.e.keller@intel.c=
om>
> Cc: Ido Schimmel <idosch@idosch.org>; netdev@vger.kernel.org;
> davem@davemloft.net; mkubecek@suse.cz; pali@kernel.org;
> vadimp@nvidia.com; mlxsw@nvidia.com; Ido Schimmel <idosch@nvidia.com>
> Subject: Re: [RFC PATCH net-next 1/8] ethtool: Add ability to control tra=
nsceiver
> modules' low power mode
>=20
> On Tue, 10 Aug 2021 15:52:20 +0200 Andrew Lunn wrote:
> > > The transition from low power to high power can take a few seconds wi=
th
> > > QSFP/QSFP-DD and it's likely to only get longer with future / more
> > > complex modules. Therefore, to reduce link-up time, the firmware
> > > automatically transitions modules to high power mode.
> > >
> > > There is obviously a trade-off here between power consumption and
> > > link-up time. My understanding is that Mellanox is not the only vendo=
r
> > > favoring shorter link-up times as users have the ability to control t=
he
> > > low power mode of the modules in other implementations.
> > >
> > > Regarding "why do we need user space involved?", by default, it does =
not
> > > need to be involved (the system works without this API), but if it wa=
nts
> > > to reduce the power consumption by setting unused modules to low powe=
r
> > > mode, then it will need to use this API.
> >
> > O.K. Thanks for the better explanation. Some of this should go into
> > the commit message.
> >
> > I suggest it gets a different name and semantics, to avoid
> > confusion. I think we should consider this the default power mode for
> > when the link is administratively down, rather than direct control
> > over the modules power mode. The driver should transition the module
> > to this setting on link down, be it high power or low power. That
> > saves a lot of complexity, since i assume you currently need a udev
> > script or something which sets it to low power mode on link down,
> > where as you can avoid this be configuring the default and let the
> > driver do it.
>=20
> Good point. And actually NICs have similar knobs, exposed via ethtool
> priv flags today. Intel NICs for example. Maybe we should create a
> "really power the port down policy" API?
>=20
> Jake do you know what the use cases for Intel are? Are they SFP, MAC,
> or NC-SI related?


Offhand I don't know. I think we have some requirements documents I can loo=
k up. I'll try to get back to you soon if I can find any further informatio=
n. (Yes, I wish the commit messages gave stronger motivation too...)

Thanks,
Jake

>=20
> > I also wonder if a hierarchy is needed? You can set the default for
> > the switch, and then override is per module? I _guess_ most users will
> > decide at a switch level they want to save power and pay the penalty
> > over longer link up times. But then we have the question, is it an
> > ethtool option, or a devlink parameter?
