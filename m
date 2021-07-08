Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187B53C1BC2
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 01:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhGHXOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 19:14:48 -0400
Received: from mga17.intel.com ([192.55.52.151]:34056 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhGHXOq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 19:14:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10039"; a="189992605"
X-IronPort-AV: E=Sophos;i="5.84,225,1620716400"; 
   d="scan'208";a="189992605"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 16:11:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,225,1620716400"; 
   d="scan'208";a="646116667"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga006.fm.intel.com with ESMTP; 08 Jul 2021 16:11:51 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 8 Jul 2021 16:11:51 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Thu, 8 Jul 2021 16:11:50 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Thu, 8 Jul 2021 16:11:50 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Thu, 8 Jul 2021 16:11:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bmz4eSuXvk4opu2J9CXI8lZnLkMtZwH09ufRSES2pKsXrehSpkSFY3mvKuSxr2NwfWfvmN5J1vJRcv8cCBVKH3NTEvj4Hn/Mbdzza1axBt2AwBxZNZ20KE2KMVi1c0sREfq/rDJS5YdJAlyIQE8AdBZowu3RqLrigmZVt2dmDL1DjL0lX16ZKellKP8TpT5M1GaIzAncI7heH1VoTc9Zsfza65JJBRygKNEN4oRtJSw+HBfRkhNhR3ZltafFnY/VdpWKR3xlZxzOFfG7zgnzmwobyzihzSKPldHpzqM4boVqf/MgD6F0PARtK/Lyk10xsixTmw5KocyPjCRS9vZr0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V5fMr0JllsZgiBIIRZ2iXxMzXwOozFcnl8k/yO+JmfQ=;
 b=PIK9G7uCqZD2H7cH0wlyf5IMR3596q4ZLeU6/nnyPoeI3jPfXGlBB65dnvX8tvLxivwE9nTvYk0Qc9DWEZ+A3A2izBYXx+KVY1u+IBO7tVGI4/rNr3IlBuaJ5uUQ87KNmYf4LMFYdpVEUcFHcrIg4TfbF0bZGw469H1rxWOd+VqAPZ4uI644/Al4hA1ZO6MRImocsD+cbs7n3wV/RBnAYN/lSdG+9WRXC5zH29Nr7sdoIxGIQehhPBlR5WoJnHfZYYSz/R5bIdqa/UwQauHSgggiVlXdf6tIsuRRJHG/hNZZfrDjJHlg4M/bpOQnPa8qoArt36JjzGm+k3d6g9sgGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V5fMr0JllsZgiBIIRZ2iXxMzXwOozFcnl8k/yO+JmfQ=;
 b=hGFkTrGaOu93TTx7/ET8XRwWGBtg6oSt+BhCTJou/BorP0yW3dpDVecn4uuO7zRkvFjYk4uR2/1isvz03Eikf/Ng5rqoXzBnMVy2maxwa3SaT1xGX3883BGqj/byMBbQ8lhTQrc/oOp171pGVc6ZVIvHYaevnqn6Xgpetv38jzE=
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (20.182.139.201) by
 CO1PR11MB4883.namprd11.prod.outlook.com (20.182.138.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4308.20; Thu, 8 Jul 2021 23:11:43 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::cd48:e076:4def:2290]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::cd48:e076:4def:2290%5]) with mapi id 15.20.4308.023; Thu, 8 Jul 2021
 23:11:43 +0000
From:   "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] net: phy: reconfigure PHY WOL in resume if WOL option
 still enabled
Thread-Topic: [PATCH net] net: phy: reconfigure PHY WOL in resume if WOL
 option still enabled
Thread-Index: AQHXc5JVSuHoO6yBxk2FsVeJf8muoas4SJuAgACEr2CAAEEHgIAApxjQ
Date:   Thu, 8 Jul 2021 23:11:43 +0000
Message-ID: <CO1PR11MB4771B370A58C83F13C39EED0D5199@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20210708004253.6863-1-mohammad.athari.ismail@intel.com>
 <YOZTmfvVTj9eo+to@lunn.ch>
 <CO1PR11MB4771D3BB3D8722BF3454AD4AD5199@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YOb5cy2giMYO1V5U@lunn.ch>
In-Reply-To: <YOb5cy2giMYO1V5U@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d11d3dc1-5f45-451b-55ab-08d94265c052
x-ms-traffictypediagnostic: CO1PR11MB4883:
x-microsoft-antispam-prvs: <CO1PR11MB4883FCD5DA209BFB719D6C9BD5199@CO1PR11MB4883.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZN3sx2oe2lFdD+xMG7T7AXKtHTmHaIB/3d3g/cmPTK7aqqlRWYJ+Bchfzb8jX69urhXtDLCTTjtO46HF2HOL7Ta9Vk/4xVAb0R7fE0D7f5XHiDta5RuykiJqilaorg6Lnl1XGVFWnJn55WVRymb5NBlX/KrPpMdjSijxKhQKW6vrk32oE9GDVGGFLiRHT1c/qUT7q64vxOH5yu90rvY53tQGT3ppUEYAuukhQPG4EMkNYggSV7D2kDDm80UY3RglPfICwZylHpmNPhpWSH8cqsBqKMe9OBARc/J1KtRDG2IINtT1HfV+Xk0zTThFlQkc1Z3aKgUd6pWjPnYiZJlpblqc1WX2muIfwy7kJgf/jwhJx3D7ryiko9naARwpK2bB5YnuiVulS9Nmd8SW8NgOQjIJA6dDEDZ7rDQDJnPBdyra1I1REsr3sKi+r5PmSYjGOuI5rhvVszGRfcGITX0AWi48c1cgnJSJu/9RwFw6qBk/+Tj0YKrul/buM9NIfryszMRKXkGnwoTPRELXjVyd73Ig8PtLMchjuuUKvy7x8j1penOvwtoUJdfYx3fQCaivW4QGcRz4UY8GWnz3u7d5VbMnFd4VjNoddz4KuTYa6rrIlLzfgrExNnBGG8kpQiB4M+RZZEZ0y+lCX3Khhd3gwQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(136003)(39860400002)(376002)(64756008)(2906002)(8936002)(66946007)(186003)(6916009)(26005)(7696005)(478600001)(4326008)(66556008)(66446008)(38100700002)(76116006)(66476007)(122000001)(8676002)(6506007)(53546011)(55236004)(52536014)(54906003)(316002)(9686003)(71200400001)(55016002)(86362001)(83380400001)(5660300002)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?whpCM6A5uVX20RO1Hk4sNYQeRutB8wDZU2YKmaARZjaUeiK+rd4ZIT6Z28?=
 =?iso-8859-1?Q?eyN5qh64zve0vZltS7bm3U3tlCiBHBgbvpp6566HA3KEfCq+Q0utgi8bhy?=
 =?iso-8859-1?Q?BqUeA+ME0v9BrHLFvmaIGP9vpt8/6ylspbe++pKereRv2yLZqyy0XN0R+J?=
 =?iso-8859-1?Q?s9Vk19Vuc5k0fOUdCOs2hJCWSG/czqDACT6/47wxTBBSX9+Uf5r64Mq5gf?=
 =?iso-8859-1?Q?ue9uovqORZqZipErD6XJUBIei3NxfvDdhe/bt1OB0NJWyPcP1WPA7td4ur?=
 =?iso-8859-1?Q?mpiXbYMobKjbPePEHYNhbtCSc7Y60alspqxVneeT/B11wALwZ0tGxwuq9D?=
 =?iso-8859-1?Q?KEKABiOEmWAxlH5suME4RifbE14g0ZQ7yNfv3wzvFhTNmN+zVqzzJTeDb8?=
 =?iso-8859-1?Q?GNrgBvPs1fJhJYNPcKH81kWQxHcUIoZzM0yi4Cpdo63ZzT1QCE7EtoYbJ3?=
 =?iso-8859-1?Q?+UstUTJnHbY+idfGfxmwsDQvTO8bBoGUS6V/W3W79IfExN7OcOgMcvRHJw?=
 =?iso-8859-1?Q?b6uSfN6VsKFX2aaAls8GahUzlwLNb7hi8JFJaUGPWX7BLI/+0u2lWgCyPG?=
 =?iso-8859-1?Q?bC09oxN0BK2ox8hbtCLo0J4OciqS8xJIZEXus81zfHjXE7RPf9u6vc8zzL?=
 =?iso-8859-1?Q?EJ0PY2Y7GxPTLJ9WDT3GfbKu338Ze1+NfHycbm7uQ0JH0Q6p/SWz7myPol?=
 =?iso-8859-1?Q?b3vUhSNReLpVQCuG7dnSeoHHx7qlkPXBpKGKoxfUSDeaT/8VppwIfev2gO?=
 =?iso-8859-1?Q?yVgxMB3mdxKjNpxuwH4/Q+/E9CaV5HbVVaoltV95W82u91Lkn1Jrw0fDoh?=
 =?iso-8859-1?Q?OQfDswiuam54hr5+2PCbOrbwWoswjMtrLD7OPvVMpM+q/hC4Cu8/Jtatfi?=
 =?iso-8859-1?Q?mmogt/5b6shNQhb8r+ZZ6az8zUkbipYAnaIYz8pGkA5gOIPnvJND04e0dj?=
 =?iso-8859-1?Q?qFCsM5Vw7iXhq4ZgB794Mb8oMPy5PYB+7DQKuQtzg20HPNqbgU4e+d4mDR?=
 =?iso-8859-1?Q?+s2BeOcmQzWdRNgnE6r0z2bKukkCtk8Wycy8xEHxFjZr0OOwii8WhpHckr?=
 =?iso-8859-1?Q?0pPgMLTz7S0Vv9/qBFWlkh6BPTTMwOwzDFeNVxQhZF3wPPwIqmDS9DdPuy?=
 =?iso-8859-1?Q?Ffg3Iwh0DHrD4XZOjaa7POZnEPva5PDEAl9/fCr8fwqvuXUwPqSi5N1Nmf?=
 =?iso-8859-1?Q?fDJstZdMpgT07MroK/FN2HuaIHxZe9F3+BpVvmiPwUcNYmz0wSQ+feF9hT?=
 =?iso-8859-1?Q?aTdmt6+MaqbSnSia8hRbtXVGCmGRDgzCO9FoqnE0ffGtfBvkg/39cIjxPC?=
 =?iso-8859-1?Q?mORFTA/nfxdrmwscHZImq21j5q4m6g/u26Inf3zFcZa8ttD46C3FZAS5+d?=
 =?iso-8859-1?Q?QrGLlpHZ2J?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d11d3dc1-5f45-451b-55ab-08d94265c052
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2021 23:11:43.1693
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mtHn7rDtSMXolMXTZgQ0+WSGs+RQ6iVRzoiGcHoQJqnUzssJht8MffBG5bBHvlkdAMisU3EGyTur5cF+CVkaaMrU48wZ0B/rQARgK34U3TvYMyPPa0YjWTYMQa4Qwom5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4883
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Thursday, July 8, 2021 9:11 PM
> To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>; David S . Miller
> <davem@davemloft.net>; Russell King <linux@armlinux.org.uk>; Jakub
> Kicinski <kuba@kernel.org>; Florian Fainelli <f.fainelli@gmail.com>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net] net: phy: reconfigure PHY WOL in resume if WOL
> option still enabled
>=20
> > Hi Andrew,
> >
> > In our platform, the PHY interrupt pin is not connected to Host CPU. So=
, the
> CPU couldn`t service the PHY interrupt.=A0 The PHY interrupt pin is conne=
cted to
> a power management controller (PMC) as a HW wake up signal. The PMC
> itself couldn't act as interrupt controller to service the PHY interrupt.
> >
> > During WOL event, the WOL signal is sent to PMC through the PHY interru=
pt
> pin to wake up the PMC. Then, the PMC will wake up the Host CPU and the
> whole system.
>=20
> How is the PMC connected to the host? LPC? At wake up can you ask it why =
it
> woke you up? What event it was, power restored, power button press, or
> WOL? Can the PMC generate interrupts over the LPC? What PMC is it? Is
> there a datasheet for it?
>=20
> Getting your architecture correct will also solve your S3/S4 problems.

Hi Andrew,

I'll try to get more info from our architecture design team.

-Athari-

>=20
>     Andrew
