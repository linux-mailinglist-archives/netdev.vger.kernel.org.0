Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1376D47E9DA
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 01:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241103AbhLXAXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 19:23:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:63842 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229995AbhLXAXw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Dec 2021 19:23:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640305432; x=1671841432;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fCxL4009SnHJ3cXfZ2Wcwy93pTUcle1gGZkvLZyUGQc=;
  b=mFQ0MZKXEjCOgY7ctobYm2dvhzA3vsmI9y01FivnM4HjIvGqbJkDDUr/
   K+RUaG4QTT/yiJjJqkwz3Rj2QrrbyoMY3ngyEF84Eaf2yKC7nYA7k0qzC
   PQY+G5eML1bLVvKdzjS1VBnnWlB8gm4W+mQ0lI0yt0bZVdSxjXvUX3uqL
   Rb2o4Im+YiWSzUhAJ+nsfaYALcuoaLIJv0bu0X6QEECCfZT1rLD42kTcb
   fGl3DltU+cOHSRulYb5394PrBT5HAXW5AIALol7sBm7DzQ96SEQ+jrFXz
   5bZgh+YpTUqGhsxe//arEC5DLZbb19WSOkkk6UNVtyFUJt9BYxHMUOwqJ
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10207"; a="238439944"
X-IronPort-AV: E=Sophos;i="5.88,231,1635231600"; 
   d="scan'208";a="238439944"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Dec 2021 16:23:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,231,1635231600"; 
   d="scan'208";a="468698409"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 23 Dec 2021 16:23:51 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 23 Dec 2021 16:23:51 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 23 Dec 2021 16:23:51 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 23 Dec 2021 16:23:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ELQGs9M5kbvpAxhvVnCAXLv6H28o6QHhCFgXQsx8jAFowaCEkrosDigstfbSDQvoz0eRHX3c6pquA8yr3aCGMOo0zSCdw3RZSeZZj1AVAQC1b5ednYuOchEmrKcoFtrTLnE6zoY13a0ETf8cWv/euHWMGE6rpPmZJiiJFzCLrSeGiM9xjNAdVDT+dnW1D3DW9wCgu5fhYfRsHvEnPfqE8R27hiv4X7Qx6RYlVSs/q7rYcRPAkBOGRRTs5hSop5rCHkgVXuBVNNUAtfFOHd3t4fp3iy5BLtNw4plHC0mMbXXssl+B+0Ec6ztsKbt7eAhwrxhoNO/zic6HNKflLJ/QrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zTDBU1D38Iyt3LQ7eNzbuhE4edbPsN8fjSjUXG1DJcg=;
 b=jnCu6Ey+51R74LwEB/j00d90ocebQXx7YgAOBfzyKrthri2cPvXxH25ovkyT9H4GHpyZ/lOrktXvPR9cY+qoADY9ImGKneebN+0PZvUFs+OMVxz7dxutBbfhUjQXbsQE2iSv0U1E2nZmOYFnBumj5+7VlVYR9eJdo1RX7Y7PxiacX2Lq8nW64hIXXrAFbZR/Jp5xc82vQr0bIlAOfBwTTVISqdDDVrMP/XfcfKKI2KZmRLxP1DIPkn6ngvNQTxBxKdJ+U9W6hnvPlbmW3U7ZVXM/f9masahGKpnEvh3uoF6uBPVTenA2qz8ByKQsFz4onjePWzEXJi9r9Xzbs+ByTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4218.namprd11.prod.outlook.com (2603:10b6:5:201::15)
 by DM4PR11MB5278.namprd11.prod.outlook.com (2603:10b6:5:389::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Fri, 24 Dec
 2021 00:23:50 +0000
Received: from DM6PR11MB4218.namprd11.prod.outlook.com
 ([fe80::1df3:d03:1e1b:5d6b]) by DM6PR11MB4218.namprd11.prod.outlook.com
 ([fe80::1df3:d03:1e1b:5d6b%7]) with mapi id 15.20.4823.021; Fri, 24 Dec 2021
 00:23:49 +0000
From:   "Brelinski, Tony" <tony.brelinski@intel.com>
To:     Cyril Novikov <cnovikov@lynx.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH v2 net] ixgbe: set X550 MDIO speed
 before talking to PHY
Thread-Topic: [Intel-wired-lan] [PATCH v2 net] ixgbe: set X550 MDIO speed
 before talking to PHY
Thread-Index: AQHXz+tMQTYYbxRzK0CU6ZZR1TIuDqxBGMnA
Date:   Fri, 24 Dec 2021 00:23:49 +0000
Message-ID: <DM6PR11MB421850E88FF264BECCDDC783827F9@DM6PR11MB4218.namprd11.prod.outlook.com>
References: <896681e4-fcd7-3187-8e59-75ce0896ebd3@lynx.com>
In-Reply-To: <896681e4-fcd7-3187-8e59-75ce0896ebd3@lynx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.200.16
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6913f1bc-e8db-40bf-d979-08d9c673a87a
x-ms-traffictypediagnostic: DM4PR11MB5278:EE_
x-microsoft-antispam-prvs: <DM4PR11MB5278B764595A13061520E726827F9@DM4PR11MB5278.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A0TqbrZIQt/VsEkL5Ez6VXkrBugLQ+w0KRA0h0RLjEwVD3ky284bfLzgv7G+qfAiHMKE2KALvegM98/1GpsYW1kMi1BRYURa71QrxM1JCMhdoPQylhRstWyq8yLtc2NVnsd6HLLb9O6O0XPZj8BNgIbM4rRnmcN1tbndjljEsVq26Jh4WPaDxTswIXTuK6yYQ2aVooHFxCzGAHErqb6TZvXaA8fI1Ic3l+kOvuH8xF8cRFvwLtGt1Ivp0EW2as4xq8xtpw+XOoPqDFJKXIBUrXVuk03B3mZyhOs5y0kfALa7fxxSeU9AF2GfvkhU/RKvf/630lEOEQrrO4yNp2Cjo+/1Tbv1vH0K/WC9jTYU2Xj6KZJum+SZB4EbspaO05hkXJMNXS5rPkmM+SXq7bxdmT2LRCHF4OLM578uWA+EI5+lvNH0sbL69E9We7Ya7ZgyQFeeg24daYrC8rhEM5h2FH7TzbojnG2oqeE/ETKDuLGC4vFEYLcIIqAipRlDIo/fmzl2xapSufq4qH0idyCW+D47n/lb90ZTSVgzwBzLLCbXuQTkwo31Aes+owM9SWHdW4duDYpPc7VcTRtGIzV5bjZ7RBHDMH6tq23FRPQ25Zsd8mM0pbG+R8CGRFo8KBE44Gt9i2UPMcdZ11s7aMQJO5pVZjrqcVYnDOTvH+w4aRoaRoMSHKGg7XUm39uhjrLJRIqYoWV7Ui8ZYTKElx32Pw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4218.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(64756008)(26005)(33656002)(186003)(38070700005)(66556008)(5660300002)(8936002)(508600001)(55016003)(6506007)(2906002)(8676002)(86362001)(7696005)(82960400001)(110136005)(316002)(71200400001)(53546011)(83380400001)(122000001)(76116006)(66476007)(66946007)(9686003)(66446008)(38100700002)(4326008)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3cIvoLfWhRbiCMCts5RoDKViCyV87+EajFyQOG2nU97+CUPjgOC1Fa0LldbM?=
 =?us-ascii?Q?yKy50hbU/BtZI6rGYIqQ8CksZL3FwL/iRNy3g6OUNfJHMhML26rGhmHsGLBc?=
 =?us-ascii?Q?M3omwDvEB+ZJzyVW8dxKNUQ+OoaL5ayt4Cgv0s5wElP/6jJllyPXe725AoTb?=
 =?us-ascii?Q?VmQiCp6OE5S3qLiwxuPgYNPHvbBclWXeRYPUsJ2QjnsbCl0btBPEancZew4o?=
 =?us-ascii?Q?8ZJ+BtuH5SWWlLw6vJYfNyJU8ClghZl9E73eMUE/tksHToL1ckNUB8e9r2Er?=
 =?us-ascii?Q?TE/EBID5yMe7TRE019WIcbIMDjibJkY2RHRZtlwfcP1QcAIP2kpsNFJ2SN39?=
 =?us-ascii?Q?0BD2nxQHGvMGaAJfBcU8d3TuqErEG5PkiJIiwiIgOxNpH38ToOilsFbDb/sx?=
 =?us-ascii?Q?4pPgQ2gpkNWA79kXEhTkpCG899g1tPTWOdOXkvchxHPYLyLF4Ivo8fEVad03?=
 =?us-ascii?Q?rlxIrbuz35r/Y3h7HAamh8t3OMsd6irRR5U/lTb0C0P0DogiN3k/TQiVIzAE?=
 =?us-ascii?Q?+gSgR+Tqhv8hrwJY5RWzMjJRBqvzg4DWpI35NyX9ZbjN0k2r0qy6pCU7/jv1?=
 =?us-ascii?Q?I2OWY6cgjRAxMt8JIhzC01FS0ft0H9yO99x5XQdJyNHPPy/RYB3HTFMIGv5m?=
 =?us-ascii?Q?nWJmyKmX879jv3Da9+jKav97M/EEKtVkp6ntiye3+xHG7z9DlkYKGLqi9GpD?=
 =?us-ascii?Q?4mdrp3AmvkMO9jQ9W8cfFwExLdmxaD5MgD9PCIkgreBdksPnPyxN6CxEsS2o?=
 =?us-ascii?Q?cv/ss07AEa5FKo/9eXlmyoLbwALAb4fMHH8V+CpJFN5TvvZirWzpG8zMHIgI?=
 =?us-ascii?Q?TeUgq3/dS1UT5sS78ZEDsh/GqOxllaaX6o5i67zfzkV3UYgK2wzH5ZLgkX8r?=
 =?us-ascii?Q?NPzLbmbBhJn4qc/LHKfEL7cZHBzkzoY2cAllEO1s1pugzyveVFYjSxeZ/CqN?=
 =?us-ascii?Q?ErT0/j1IOIKgFcNzYisCRkURqa6HCMN/wCmIl8yuwXGE4EH+RBZ+whXlREC7?=
 =?us-ascii?Q?5bQWP4QLLZrnTCo9GOQ31TpktEjm4slvq3zXkeuPyy3RhkryNklmaGpjD4pS?=
 =?us-ascii?Q?mwOsOF/t4tEjQ6WZbIXK/fzKwpFSYkLQCpCHReTJ0DorlNy2JKXzlccFhdI1?=
 =?us-ascii?Q?yq7L7CABb11Y+ZxN/qzcP8UunAl5CGBhl8YwrIqxq1rSKP1n1K1y0rPpUJz4?=
 =?us-ascii?Q?imJP2F22e15E5AcySac6Hh5L82JhuGseXTLuhtXaeOC1SwjNX1gi2hCSV+86?=
 =?us-ascii?Q?jh3k7uoHDLa+oRwtAzecEyjH5gLmUFvIELzOHao98bntaEkt94WeVBKZIPfW?=
 =?us-ascii?Q?LpHXVsHdEdbkAwBDI0+FxvcYqnq1SMDXM2Pb9a0wY04ipcS+mOmeN+97U8Ql?=
 =?us-ascii?Q?Yk5xILHeI/66nkU2gVfohmELd0+cDsRfcC7XompPu4TsHxZOPT7YjxaXOswf?=
 =?us-ascii?Q?DUuHVfXIPMgNKL4PuLO492XAC4megsEL/niI7gD3X6nmE2i01HCXhj1HsdMx?=
 =?us-ascii?Q?dci8pLura+qdyvXexNjPC+pJx1uZoGrDeyS4xWXDiYouVwvN89x31ULgEHHk?=
 =?us-ascii?Q?FCsvu++7PObCZH23MMSQqx2u2gkASm/aXyHQ1IOd5kcWoLD+8QPAVVFlGHX3?=
 =?us-ascii?Q?Q4/2syB5zvS6++0Q88XIFYhCFUpRXrgS7eConpelGTJPrtRb0zSSNovwK4c9?=
 =?us-ascii?Q?CZu9Gw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4218.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6913f1bc-e8db-40bf-d979-08d9c673a87a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Dec 2021 00:23:49.7958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jJzcUr4MaCmZ5TI9Jiyq0S94z1j6jLtgi92PAlsmgROLPORMxJSc0C6UGtBOdf52Q2yjnEkQwNKKa5HMaCbJY4IZzlOEpyY8xDoX+Y9LOuw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5278
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Cyril Novikov
> Sent: Monday, November 1, 2021 6:40 PM
> To: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>; intel-wired-lan@lists.osuosl.org;
> netdev@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH v2 net] ixgbe: set X550 MDIO speed befo=
re
> talking to PHY
>=20
> The MDIO bus speed must be initialized before talking to the PHY the firs=
t
> time in order to avoid talking to it using a speed that the PHY doesn't s=
upport.
>=20
> This fixes HW initialization error -17 (IXGBE_ERR_PHY_ADDR_INVALID) on
> Denverton CPUs (a.k.a. the Atom C3000 family) on ports with a 10Gb
> network plugged in. On those devices, HLREG0[MDCSPD] resets to 1, which
> combined with the 10Gb network results in a 24MHz MDIO speed, which is
> apparently too fast for the connected PHY. PHY register reads over MDIO b=
us
> return garbage, leading to initialization failure.
>=20
> Reproduced with Linux kernel 4.19 and 5.15-rc7. Can be reproduced using t=
he
> following setup:
>=20
> * Use an Atom C3000 family system with at least one X552 LAN on the SoC
> * Disable PXE or other BIOS network initialization if possible
>   (the interface must not be initialized before Linux boots)
> * Connect a live 10Gb Ethernet cable to an X550 port
> * Power cycle (not reset, doesn't always work) the system and boot Linux
> * Observe: ixgbe interfaces w/ 10GbE cables plugged in fail with error -1=
7
>=20
> Signed-off-by: Cyril Novikov <cnovikov@lynx.com>
> Fixes: e84db7272798 ("ixgbe: Introduce function to control MDIO speed")
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> Patch v2 addresses review comments: add a Fixed line, move reproduction
> steps to the commit message. No changes to the code.

Tested-by: Tony Brelinski <tony.brelinski@intel.com>


