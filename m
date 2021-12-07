Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13D946BC51
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 14:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbhLGNWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 08:22:52 -0500
Received: from mga14.intel.com ([192.55.52.115]:58268 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230480AbhLGNWv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 08:22:51 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="237799431"
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="237799431"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2021 05:19:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="679438913"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 07 Dec 2021 05:19:14 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 7 Dec 2021 05:19:13 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 7 Dec 2021 05:19:13 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 7 Dec 2021 05:19:13 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 7 Dec 2021 05:19:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a6jkhY7ebuKSG8CKTB9TF3KynO9OI8UuE7JgezXVVvF2/NSP7TKAw81z5qGq5mfedY/1nU6Zpsp4C2aXaMo6gpdT7jCXZC24omcrdfL+oaF8tMD98bAUpliPsq/QA92uov2xXdjyKPuWYkA9eCpGGn3ccRrSDsXD3X3mBuqSdmkmBXfaB4xZQaKqPwI6Hwo2cC4zmlkeJOz2nALaGhZEMPCrBDPnto0ljwTu7ndQLztvzheqk7uHk1d5CL98xQI0iVQACSMD7XiB8FoZS8QffuyFfqdsKoCTvJ3XPR9DOW9/D6R32ZxneBlpSxH/+bcdKFIDcwqlqMjSskQSGBcBVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QGJLy4WVH3u2OAYhXl9/PD/MwhlpVQypLM+e6JKvr7w=;
 b=XpQ7Y/fK+HuwycWgihm4mbpojsZEKqce6rbKI6Y6QbZ56rDdkB2kFCZOFoKkNmgDIqefp+jeWXPqmPrOi2NiL3U9+uL3l0NLmPCq9m4/x1Do5RjduaVIEkv4mXVOxGeIaw8sAPrFaZZM62yBP4gDylpDS0v7FDmcV3NKbQsUK80ERi/8NnUQL8ZQaJaAJzlmyiHIxtobRMei1X3gfOxCxkwLLcUwBYszvQKxZFK+k+W67rQadyQyqyFinbOpoLWTpVe8FOpvMMKRQfScDie49AGsv6KBe2yycuNJFJ/NgLe2cj8W1za+5KJddwI6mHeWPsh6+Hzk8GtEQinJl4hUww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QGJLy4WVH3u2OAYhXl9/PD/MwhlpVQypLM+e6JKvr7w=;
 b=nVyF1DDkU+Lk+CnqVrQCGEd1z7jrNbC2zo+D8tzr52vZcSnYK8uVrsfi4HV6PNTSGeH5GfU08AibvfFoQuGHBmXY6cb6V5fxAjUtdI1eqbK+yQk6cF48qcjhg39qcctlOhwha6xTvO5/4jJVxIy0kT8RuakYWHKhCqROgmdd0OI=
Received: from SA1PR11MB5825.namprd11.prod.outlook.com (2603:10b6:806:234::5)
 by SA0PR11MB4622.namprd11.prod.outlook.com (2603:10b6:806:9c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.11; Tue, 7 Dec
 2021 13:19:10 +0000
Received: from SA1PR11MB5825.namprd11.prod.outlook.com
 ([fe80::787a:2f03:efff:c273]) by SA1PR11MB5825.namprd11.prod.outlook.com
 ([fe80::e814:a13b:4bbf:ef2%9]) with mapi id 15.20.4669.016; Tue, 7 Dec 2021
 13:19:10 +0000
From:   "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
CC:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Beker, Ayala" <ayala.beker@intel.com>,
        "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] iwlwifi: work around reverse dependency on MEI
Thread-Topic: [PATCH] iwlwifi: work around reverse dependency on MEI
Thread-Index: AQHX62mfEMe3r8UUhk6V5oeuPkgV/KwnAe8g
Date:   Tue, 7 Dec 2021 13:19:10 +0000
Message-ID: <SA1PR11MB58258D60F7C1334471E2F434F26E9@SA1PR11MB5825.namprd11.prod.outlook.com>
References: <20211207125430.2423871-1-arnd@kernel.org>
In-Reply-To: <20211207125430.2423871-1-arnd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1c7ffbc-dfe6-4bb9-6fb2-08d9b98427fd
x-ms-traffictypediagnostic: SA0PR11MB4622:EE_
x-microsoft-antispam-prvs: <SA0PR11MB46224B92B19D99A976FD5B7AF26E9@SA0PR11MB4622.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zxNgEoC7QBI6oyBvlFGFeDjJuN1ujpMS9RNSfGIAgF448DGD33cg+RnoGw4sT8U0w/OJMF/+ai1k2GA9DmDHW6y1LoAGjaMcCbJtA/u0PQohstSc7Fj7LwYVhdRi/9Zp3GVU0CNwtCwp+rM73W0AtCIhg/14Nz0UDqdMei0dBL/HGb86vIT0ryAKjaktlwProaWQuh7wC9heCO4FNPbOmn+QZSyDomG26BUKWgbJQBbyNz+Lc0/AwaP9xdWCFlUEReFpHp353/EBiDu1ExkRXzjiPqikWUSYgsnXkiDFp+rYzWgXK7Y8eH1IVs6gJYVplmvhx7pNfAtwe7HWYsOluz62gXtMuqMSzcD0G2jyVs/JsCSpDgCstqmzgeAgZVLGOi2kZGAugGRkrHMQS9doPwrfr2+0JycESBhtRooAGDJn+VWdnp6X9fmI1S5fQ0JiPj6D8jx1QunzOabSHjG1U0fMNqHZJN/vL9z+Tc5MeS6+QIBJ+Xmbp1lV6CbcYQZ6VvCwvFUTR8WbG6UlChjEOXFxwOICV+dGaLOEYRVKO7pfEjj0obLKxZhUqFTCrd4klFj8ZBpqmIZICVUDy9Fva+41TiU5pNpj/HadwrqnPzfZU1G04+o6yjGCaTxBZ4VRpxF2jahNwGFKGVAB7W2h7ucG070U8hFhz1OcEy36WoONDbtd00zZqo4O9hZHKY2cHhEEv6mJ+BrDUTYksPv0CQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB5825.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52536014)(2906002)(82960400001)(8936002)(4326008)(186003)(122000001)(38100700002)(8676002)(316002)(71200400001)(54906003)(5660300002)(110136005)(86362001)(83380400001)(7696005)(55016003)(26005)(66556008)(64756008)(66476007)(66446008)(33656002)(508600001)(6506007)(38070700005)(76116006)(66946007)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OUgTbiITm6K4UNE1L1LnN44cltbRTzj4ATCdGM11T6k/DNRvQiYVp4iy1na0?=
 =?us-ascii?Q?sHSnwgf8f0ABzNhdQlNmeNainI5BfDNF3LY8ep54xuHbGi6DAVNbV90jpWTJ?=
 =?us-ascii?Q?cNm0YLxSgZ428xR3UXV3mDs/v6cEwkxKhU78ni6PtfL2P4NVgdm8LI+0RfIv?=
 =?us-ascii?Q?Rz62MIrtIeNcI73C0oE16PfHINIGCa3Bx9wWlXgKJgl9puEXiQIdejAzA3yZ?=
 =?us-ascii?Q?2+RirtA0r9sOqPiBUQIK/r4M9kg5X7WHFKDH+0Cgr8enJSGoMJBTgTY7q8tZ?=
 =?us-ascii?Q?qNlUXfWMCn5IyQlyFmc34L9CiOuRRtaaJS1CTfAA4yU6gpR5QEPRs4t4aVyv?=
 =?us-ascii?Q?kb0z1CjWo8CsrIw+NSFTOFDli+M35au1bClELFA2hum+IqjjehEX/cBmyBkQ?=
 =?us-ascii?Q?REtq0+nbU1dEdxuRZgnoQgejKv8h+V382P06gZxiD7eGo/7utCifnGket9Ij?=
 =?us-ascii?Q?/vbXscJF9DKBhm3xRFK4fPEtR6nbEI9CBJIwcQ1Uhr+6CuN6ztkMVn9p5eZC?=
 =?us-ascii?Q?TvwnIK6h4Cxw4xuZd6tmMuoPbV7Y3W+RqEPLAhn7RXwb/pzTSoolUTEY69Cq?=
 =?us-ascii?Q?tWHz5hRzmjYy2xoNWFbh2xWdh9bZ8HSHKLPdzwIEq/r6to00f6DeLkrHq06I?=
 =?us-ascii?Q?RlPVF+NLoTt5QQVevDd8loAY0daynD3BdrHvqJVOu0PAkv1/OtMI8HZ+/duR?=
 =?us-ascii?Q?zwhCqBy6EZ/kmy4GWl7Ddi42hb11/yG6vGFOPng4UTZHh2xBuYPLaBI9PteJ?=
 =?us-ascii?Q?c7hZoqSRGm8iGVa93c9CvuJpc7no83Wderupih9NV2bKDRtlGDlRL1wF8DHO?=
 =?us-ascii?Q?orCZpZvBwwZ5IimGUeuJw8mYZiEeBFV4THS8ljGchVy8ieB+hVH2hBGsRa5q?=
 =?us-ascii?Q?rNXYuf+0LVgXtE9AHTrxqSuOaKIXDk8stO7OyvWE/Zq2cy7xYm3BRkyUgc02?=
 =?us-ascii?Q?845x13js32cgjDXBoscJ7q9QL384OOY3kRphdmQpUWDDrumEwKIoqToz4EN7?=
 =?us-ascii?Q?lswHYmwal9gDxNcGtxu3PaeuHt425DRH2Jiv7fJPp6EkkfzzKVLCzmo2pIRY?=
 =?us-ascii?Q?9wZPITtl7mf9gXBLe3CLintrlM5srBap/HEtcap8dxPwnSR5gWc5RK6cSzEY?=
 =?us-ascii?Q?jC00QwJG0WVCv4N2hOfQiw0s1YkgkflE74gQUJLnyveGFiniGra0gKpoOkuk?=
 =?us-ascii?Q?4uZKoN8cXh2Rhdo6B1VIhUzvPeRHiFrjsme61D/lJSKLkzsUguGYwK9pBeXp?=
 =?us-ascii?Q?2aqAyGeW7GIix1GMSlWikbJEOM3Lj6FGOqSNDIn1vihry7tSMmiLcCHrFFD4?=
 =?us-ascii?Q?GJ2twaWFAZQ5gDRZXFVvT/7TSPH640G+s/gzagF/0alp94kHIBE1NWnLDEbZ?=
 =?us-ascii?Q?2yQ343PKXjedznOS8+2WnQGPi2+A/0jja9UXZqevKulw20RwpSxuYGGeHRbh?=
 =?us-ascii?Q?I2/eBKBuRxjvL+UF4aQol5E14fmGd+gtnARI3zAkTBOB5xKPIDRgJKY7Ol9e?=
 =?us-ascii?Q?Ny8dCuDzyDtCqKiMDCaCt6PNg/oz9OAPsmihzzv8q7Bx6/r0hZ1L+YIyHzRV?=
 =?us-ascii?Q?CA6d/RAb1lkcJXbtW1hTNFrwv6oR/zr9HPy/iDuZcdDw0Wh9t7BhaJMlXXxP?=
 =?us-ascii?Q?lL2SF0ekeGP6c905J/aa5vT9Rs2/xeYUiG2SwbZxR3vUOq9BNAj2RADCVrxw?=
 =?us-ascii?Q?y3i3Gg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB5825.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1c7ffbc-dfe6-4bb9-6fb2-08d9b98427fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2021 13:19:10.6661
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lofuNcdDcnXd/dpeiZhtBbYtJJq5HNOmXv4xf/deHt0Jlswlht+aPXhTNVp5qiTDy7xQ4TNjVKhUrMI7DE5JTTUhCcjjYiMHQdf2bUkU3f4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4622
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arend,

> Subject: [PATCH] iwlwifi: work around reverse dependency on MEI
>=20
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> If the iwlmei code is a loadable module, the main iwlwifi driver cannot b=
e
> built-in:
>=20
> x86_64-linux-ld: drivers/net/wireless/intel/iwlwifi/pcie/trans.o: in func=
tion
> `iwl_pcie_prepare_card_hw':
> trans.c:(.text+0x4158): undefined reference to `iwl_mei_is_connected'
>=20
> Unfortunately, Kconfig enforces the opposite, forcing the MEI driver to n=
ot
> be built-in if iwlwifi is a module.
>=20
> There is no easy way to express the correct dependency in Kconfig, this i=
s the
> best workaround I could come up with, turning CONFIG_IWLMEI into a 'bool'
> symbol, and spelling out the exact conditions under which it may be enabl=
ed,
> and then using Makefile logic to ensure it is built-in when iwlwifi is.
>=20
> A better option would be change iwl_mei_is_connected() so it could be
> called from iwlwifi regardless of whether the mei driver is reachable, bu=
t that
> requires a larger rework in the driver.

I can try to do that but I don't really see how..
I can't really make a function that would behave differently based on wheth=
er the symbol is available or not.

>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/wireless/intel/iwlwifi/Kconfig      | 6 +++---
>  drivers/net/wireless/intel/iwlwifi/Makefile     | 3 +--
>  drivers/net/wireless/intel/iwlwifi/mei/Makefile | 4 +++-
>  3 files changed, 7 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig
> b/drivers/net/wireless/intel/iwlwifi/Kconfig
> index cf1125d84929..474afc6f82a8 100644
> --- a/drivers/net/wireless/intel/iwlwifi/Kconfig
> +++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
> @@ -93,10 +93,10 @@ config IWLWIFI_BCAST_FILTERING
>  	  expect incoming broadcasts for their normal operations.
>=20
>  config IWLMEI
> -	tristate "Intel Management Engine communication over WLAN"
> -	depends on INTEL_MEI
> +	bool "Intel Management Engine communication over WLAN"
> +	depends on INTEL_MEI=3Dy || INTEL_MEI=3DIWLMVM
> +	depends on IWLMVM=3Dy || IWLWIFI=3Dm
>  	depends on PM
> -	depends on IWLMVM
>  	help
>  	  Enables the iwlmei kernel module.

Johannes suggested to make IWLMVM depend on IWLMEI || !IWLMEI
That worked as well, I just had issues with this in our internal backport b=
ased tree.
I need to spend a bit more time on this, but I admit my total ignorance in =
Kconfig's dialect.


>=20
> diff --git a/drivers/net/wireless/intel/iwlwifi/Makefile
> b/drivers/net/wireless/intel/iwlwifi/Makefile
> index 75a703eb1bdf..c117e105fe5c 100644
> --- a/drivers/net/wireless/intel/iwlwifi/Makefile
> +++ b/drivers/net/wireless/intel/iwlwifi/Makefile
> @@ -29,7 +29,6 @@ iwlwifi-$(CONFIG_IWLWIFI_DEVICE_TRACING) +=3D iwl-
> devtrace.o  ccflags-y +=3D -I$(src)
>=20
>  obj-$(CONFIG_IWLDVM)	+=3D dvm/
> -obj-$(CONFIG_IWLMVM)	+=3D mvm/
> -obj-$(CONFIG_IWLMEI)	+=3D mei/
> +obj-$(CONFIG_IWLMVM)	+=3D mvm/ mei/
>=20
>  CFLAGS_iwl-devtrace.o :=3D -I$(src)
> diff --git a/drivers/net/wireless/intel/iwlwifi/mei/Makefile
> b/drivers/net/wireless/intel/iwlwifi/mei/Makefile
> index 8e3ef0347db7..98b561c3820f 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mei/Makefile
> +++ b/drivers/net/wireless/intel/iwlwifi/mei/Makefile
> @@ -1,5 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -obj-$(CONFIG_IWLMEI)	+=3D iwlmei.o
> +ifdef CONFIG_IWLMEI
> +obj-$(CONFIG_IWLWIFI)	+=3D iwlmei.o
> +endif
>  iwlmei-y +=3D main.o
>  iwlmei-y +=3D net.o
>  iwlmei-$(CONFIG_IWLWIFI_DEVICE_TRACING) +=3D trace.o
> --
> 2.29.2

