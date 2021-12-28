Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 108F848054A
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 01:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbhL1AHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 19:07:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:24356 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229565AbhL1AHa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Dec 2021 19:07:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640650050; x=1672186050;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=95iNR+/xnC7iWeM6dfu75qsCLzH/obbtSOrFZpovUmA=;
  b=X/UWy7L59EFhQZ2DCZZRbWJ66vQ32MYcgIWsRtChIO3yMM2I0XbAkCqB
   CzVTbNSKFq2ct1+c622hyCTSMvQZBXeVzOJV9l+LCkTKKnnnC37zpxFlV
   S/UWP9upJCDULN/9WKcWPyydhNPhOgtwwzU0JAl+fidql+6p6uzHi0qyD
   p9viHkAWLHYkD1Y0Gzaklcpdec2ne7d60jrs2JvGLKY+0pv5NjymEAjcZ
   fNNL2IlZGN4DBNRac50+7FmTW/bHHuaNDviBd7gH5+HJv6OzC+LlX/KZ3
   P8/T+YRSL5jJiIcVAX61u/IzDlBPhant9vgleYuseR4J7Uc4E493auyVN
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10210"; a="241087897"
X-IronPort-AV: E=Sophos;i="5.88,240,1635231600"; 
   d="scan'208";a="241087897"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Dec 2021 16:07:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,240,1635231600"; 
   d="scan'208";a="486151991"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 27 Dec 2021 16:07:29 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 27 Dec 2021 16:07:29 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 27 Dec 2021 16:07:29 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 27 Dec 2021 16:07:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pl0jnxNZ+pjrWcILMObyIVAxIOvxSd6spSboYvyTr4dIqpAgHQIykdMcYkGXdWqe1l/2LcGjO2rouure5ibHcgbGbJPycToWEownoqwR+UST8n/j39OILYfhHb4sYyZRWN9bv19UMt8PvgaMqQh8nnqazZuEsltyUezqr3Fc9pJGHuqaixPY14X8zBawxgYQ55rIXDd/MKedy8+ZkoxhdkG/sf0ybxwP1cv/XTJVmKZ5klspPg5PEF15mrDfCibaMlpq5G2Kz7T9oVeANmkv6+EclO2TOlRDJ+G3n1fVVLBw6mg3eMGU/DK1ZBEriZ9FOMgHSgWF7mgZi0ZBkYxS6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tiHSaxgC1ohMLL4gWiV3gfN/4wkBEH0Gizc/BnNTKIw=;
 b=coQFYlzEA+rlOSPOBfsDnaUHaq0AHrXoUZBGbL1kx9HAwDRG+DsVYR5cplODXOtbpob7O7yBtCpk5kCH52caACoGINPvwQKkcyjZpQXwkiJ7WT3KzkMM/NLK7vqXeMRiQe99ZxP7LOemD6OkA+iypXG86+cCM5iq+TjzC6lFvstZNCMNgKQ2GRH/nEcd4KncKrTDv8PgGtJ2VfsDOas0DCEnY5+FMwzhUFRMiPBVk6IXeFauaBkXYeq7VEnsIIB98v5Tbg7pAuKIZKy6wR1OO5WomgBVApOIgzQYxO3rTTKItzGV6TiS97bydK4GTe5wGM9tvDPT3Wztidwv6sxfGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4218.namprd11.prod.outlook.com (2603:10b6:5:201::15)
 by DM6PR11MB3706.namprd11.prod.outlook.com (2603:10b6:5:13e::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.18; Tue, 28 Dec
 2021 00:07:27 +0000
Received: from DM6PR11MB4218.namprd11.prod.outlook.com
 ([fe80::1df3:d03:1e1b:5d6b]) by DM6PR11MB4218.namprd11.prod.outlook.com
 ([fe80::1df3:d03:1e1b:5d6b%7]) with mapi id 15.20.4823.023; Tue, 28 Dec 2021
 00:07:27 +0000
From:   "Brelinski, Tony" <tony.brelinski@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH net-next 2/9] e1000: switch to
 napi_build_skb()
Thread-Topic: [Intel-wired-lan] [PATCH net-next 2/9] e1000: switch to
 napi_build_skb()
Thread-Index: AQHX4I+SpTgcDfTkF0K2NI8khtNUpKxHPI9g
Date:   Tue, 28 Dec 2021 00:07:27 +0000
Message-ID: <DM6PR11MB4218120DF7ABE8B9054023D982439@DM6PR11MB4218.namprd11.prod.outlook.com>
References: <20211123171840.157471-1-alexandr.lobakin@intel.com>
 <20211123171840.157471-3-alexandr.lobakin@intel.com>
In-Reply-To: <20211123171840.157471-3-alexandr.lobakin@intel.com>
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
x-ms-office365-filtering-correlation-id: 045f88cd-3648-4123-72cc-08d9c99608a3
x-ms-traffictypediagnostic: DM6PR11MB3706:EE_
x-microsoft-antispam-prvs: <DM6PR11MB37060B9C3FDAD8D21938A99882439@DM6PR11MB3706.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +1sTHic8agS29IGn+O8/ffK8gr2HGOpTfL959Yoq/T5y+p+1QQcN6/GpDnNA6IXviAflMiy98ZhNXCARr0+cDqanqqwVbWZFFFCFO/VqmeoAu4zbQEek1nAzmqxfj16AeFtV+usNon9VP/qvDzfcmaqHRiM5ytXm0Q/fChbRv2QMCnEz2GpHlvCwnjYHXU5fhsKsNB5YJO1znWtGbjVAyM7re7Wbemaf9loEMOWWlBKe7Y15G6FeCkVI60dlHqhdoB7ayacIwla98JZDrcTkh7+bKUAUtl7KPfl7GhLHVh//1/1CZbdg/6/9iFF6Y2TSDtk+2+nPUFzy/iwPoqhtiHFsLDdsRwN424oVDOVfPRfHB9lVBlOtIngfjz+peBLbtUO2wfubJAswaHE+TCHx16Mye+dRpPLDEJlihZ7gmrMhrVVBGORqtb3hQJQESiTOYmBqSfsFw3P3PXXVpQwVj/a37sJcmVVxPU6ngoLB5hg6UG5O5EowvpbkMe1VAFLwm4MKXVZ2a+pxoLGBMqeI41dXqeVIsVKt31qxOtKU+KD7OJgDKVqB96bMwe1wTHbJm2Vgp2R19/32AIiUXrWbBEfo2CU2Sowf5AQI3Ut+JYUyvh0iX3xygQ7HxnJXt8SW3roY9KJsIWBEUkf0kG49A+1LPeWI374r/ferfHHXn8v+cCBo5QK0whVMl+Meo72NcYWBCt5jUutGUwAS98GW+Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4218.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(53546011)(71200400001)(110136005)(5660300002)(82960400001)(508600001)(76116006)(38070700005)(33656002)(86362001)(8936002)(8676002)(122000001)(6506007)(2906002)(52536014)(54906003)(7696005)(55016003)(9686003)(38100700002)(66556008)(64756008)(66476007)(66446008)(4326008)(26005)(83380400001)(66946007)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+UkFP4EWccIdRAU+a1uMHDlnoY2xNP4TiML3jyDXvPErwasWpGGChY82/gSx?=
 =?us-ascii?Q?cjOT7zi30bcrkYb/YvtfzAhdlJ+KLpGDJDkVZKauiQVxwXccg/cYFp7RQJOH?=
 =?us-ascii?Q?GQ9or4hCSDSXtAZCjEodySSrbSSSxteTWx0gXye1++jY3SasUYEadA4KtRYE?=
 =?us-ascii?Q?BBJEPQusMnKEIyLlm5lT2ko+ohs31L25Zvmy1rsdGBDp7WsS4CBeW6q/T9O8?=
 =?us-ascii?Q?obigQMGau1X3vFLiS29MHMyB51LR2Bg8kJXPYdC3hwLaegLDKrXdFjvC+z+q?=
 =?us-ascii?Q?z80uS1Itwx2/szupXNnLEsXdL76e6gLuhteP7cQlAPhqjDX4oUWUQbMCmMru?=
 =?us-ascii?Q?Cx1kFQyQTl8l/uUllx5BPKNMhguCbD/f2W9p8IESOYZlulA4+JHB9yrF/gnG?=
 =?us-ascii?Q?hLrmZFUjIW+AlODV821qvWDLGkpnfwa1c+J8p3Y2dMFL4NAVFSbXpw9kEhgR?=
 =?us-ascii?Q?I54VUpQnTBGBF7/ED2B/mv06oW9tHiAKBdIAMonWQlOIjmMnp2gUIQG+Ct5Y?=
 =?us-ascii?Q?Q0rfV6Av/yYJftnsCp7CM82QvtWHmOC5FXrQIqej/6TACUKUWKtNWj43IenS?=
 =?us-ascii?Q?TkqVU5MgyvD/hIQl/DosIu3Iub1D6LhcMV+T5I6+YXt3LODNR5r7IbfRLXhu?=
 =?us-ascii?Q?gOp9g2L5B3d17eJw5ovQhzXy+keNocwvulxZxGGXaBVIaV7F5aXov8WY3mtj?=
 =?us-ascii?Q?wC/l4Bx77lb8mbWFriCOsztiMF2TXILJ064is5Oz0hnN/RAuGOWIlksDVLpA?=
 =?us-ascii?Q?URBqZg8mBPLI6Fsfe+sf9ZvsaGr5WzRT4vR4049rACTnKPlc/ug7+quIGSDK?=
 =?us-ascii?Q?52igKOkwrH4NztHnu7si2vBchAb4pVaegRVMP0F+xPuBYTJngA6hlkr/KKTy?=
 =?us-ascii?Q?YHubm7LvrNY4IqFAugiOJQI97M5bu46biQXiof03JM/nm6ebreaOHXUXmqtS?=
 =?us-ascii?Q?KVJTyqZYqL66MG26jbkPCewlmtOCPMnQxbGI5iemGOKofW+KXIKPbNNpuvLC?=
 =?us-ascii?Q?UnozryZ/jIOsHxW2du4RSRQVKq5mlVDL25WjYJuckb+D2O5jcUCBimqZOjig?=
 =?us-ascii?Q?tdtnXo1JnK/ifgKiNVfwNgZno39F5I6F7MwqVr/APJwBhAI2fanRAV/KeQe7?=
 =?us-ascii?Q?Ce2dJCQm5Ob7Vi0/zwFLMc5F54iDrPg5U6771RuzPQlYqBYCsB96hsi/jegd?=
 =?us-ascii?Q?vYYUKUnhvm9oFlSLKFESvf0W7qs1t02NOnxD9mDcgzNJGIlZIezEemr3C6i9?=
 =?us-ascii?Q?XF5ZiMBNMGEGvtNbpd5QkswXmDzWwhTStf0kPRSoPGv4NPJr1EYLT7r6QTwu?=
 =?us-ascii?Q?FC8aV7jZJx2zpAsOF2/E9GyNzzr4CWVc6VjiTR9OYqdo4kr+nl74ywW2Afus?=
 =?us-ascii?Q?QTvHIJx7UviCRk+Q1FHaLXJzYbJKWrLGFchhhiioxcxYVLGKHkwwWtWIhxSm?=
 =?us-ascii?Q?tcfrlSfknzXcSdauKBn5M44RwsdsFPx42HZ0tqV1HQc3e9JSfuArqcK1FXxV?=
 =?us-ascii?Q?tbwAboI4YLIJQlhH4Bt6QkNMDHkBK8mKZIj8eFEbhjeweyXxbEmN2o0X2dwp?=
 =?us-ascii?Q?jFIuUslM8nCj7M/DAwBforoow/0jYZKDftNenMTlkKD3mASsxV2qHHXJfDNB?=
 =?us-ascii?Q?46fkEARXK/L8wEbJQLfxX5EArcljFeS4NdTlnjZgjvMu1lYk5oiMymuQwcVK?=
 =?us-ascii?Q?jZmymQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4218.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 045f88cd-3648-4123-72cc-08d9c99608a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Dec 2021 00:07:27.5853
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kKT7UtgNNirfv+Na7csqX+7+1FqdmnCdMqnxemKCmuCbrdKmamxDaV1d6rEbAw1xNn6xqb6m/mtk3WaerckRSapdQiJHwNqvUlCwmrtWoW0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3706
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Alexander Lobakin
> Sent: Tuesday, November 23, 2021 9:19 AM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Jakub Kicinski
> <kuba@kernel.org>; David S. Miller <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH net-next 2/9] e1000: switch to
> napi_build_skb()
>=20
> napi_build_skb() reuses per-cpu NAPI skbuff_head cache in order to save
> some cycles on freeing/allocating skbuff_heads on every new Rx or
> completed Tx element.
> e1000 driver runs Tx completion polling cycle right before the Rx one. No=
w
> that e1000 uses napi_consume_skb() to put skbuff_heads of completed
> entries into the cache, it will never empty and always warm at that momen=
t.
> Switch to the napi_build_skb() to relax mm pressure on heavy Rx and
> increase throughput.
>=20
> Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> ---
>  drivers/net/ethernet/intel/e1000/e1000_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Tested-by: Tony Brelinski <tony.brelinski@intel.com>


