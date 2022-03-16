Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 096D14DB849
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 19:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357833AbiCPS5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 14:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243715AbiCPS47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 14:56:59 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F376E4DB;
        Wed, 16 Mar 2022 11:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647456943; x=1678992943;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LkbJgW5wVS65ojxx16oW8VGhFJ7ZO3bBHJ91KfUxKPE=;
  b=kzEbxqWqYXlTemaP8RQhsTcOHmWfiy3tF9My9SEY6GWt7rP6lpn8BtLE
   /8vzqC8zJWdElCg5O3z4T2KHkt+6ew20dou2J4BumLKoyqFxia+pkKebg
   C93us2nHzdigii8Aq/+Ngy4NZXogzV1oP3mA8FAYYsg0l7cKlv1HBpyoY
   nOx8FzBIDGGiv2/xMIMLcXYLYrAnXo90R8lbvapnXw9dLhYOFl62OXTzv
   x8shfi0/0ch4DCF34ZPztuhqdleBMWdL5XEoUUtm+W6ixXre92mpybrTo
   Ny/UlgQHWD/BzudYr9+0hKJwfSXSlEAGQ5Srq6JpNKZmKftCOyTreCQgx
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="343122775"
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="343122775"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 11:55:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,187,1643702400"; 
   d="scan'208";a="550092727"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga007.fm.intel.com with ESMTP; 16 Mar 2022 11:55:43 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Mar 2022 11:55:42 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Mar 2022 11:55:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Wed, 16 Mar 2022 11:55:42 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Wed, 16 Mar 2022 11:55:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sp5Y2IpDzhuXojCxGrtZN2sAFAgYJuRs6hVctlS0laGmAeXxsJd7AcHdV2rAc6lDt9g+17iqa77SWyUyxnPhDq/TTtY/Gu5aC4hpW36uySLV81wBNv9ChWL9WG6vVGjt9Y+o1YPnsD4cIFmOK+k5SR6Sor91mc0lKE4dkHREbKdK4iyaVAuIK5pbco6ZNQOu4REDP2t1ONEvnfczs8CParDU3Jqs6S58Ma8Imgxi6R5YEyBtQsFEbrVcuFXza1iXnVBrIEStX9ORCyP+4Z4FHU+M1DL+mP3mD+IWhz7vQhWerwQVwubyTbXiOLl/wmSVayWFBJwV/WIMfEsk7Fevng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+gkv9PcBOkj9D8WoGiJVyN+T1ueICJjDGcjnR2hHSWA=;
 b=ghoGy9pX0erYzN+OecGM9FxGa5CBn13f7FJvibEH4bPVrCCbj9NZc6DNiAX2A/lukzl6IIAwqA2LzlU3CDQHtUvSd7tNpf2uVkPF6pjyIWMnZCwZOOm6FOS2O7x9IYWe/lh1Us1mq0GYMdrZfUOuk063LYSteCT2vOdExV4dW7sB13a9RuHRwn/uPAzuuOq3uOhF85hn8Bw65YwTybB7wpmFI8fesSdoFVZ9qN4Vs6Cm/9qVCgLrPndThmkzXLy2wmzr92dxzQEKQkXzgeehshKiN5Z9lV8SxMl/k1g7rChm+OOSRIzqpjxYj8qlQhhh2N44TiHCcqwwjQF2tw7edw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA1PR11MB5825.namprd11.prod.outlook.com (2603:10b6:806:234::5)
 by DM8PR11MB5608.namprd11.prod.outlook.com (2603:10b6:8:35::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5061.22; Wed, 16 Mar 2022 18:55:41 +0000
Received: from SA1PR11MB5825.namprd11.prod.outlook.com
 ([fe80::550b:9f0b:e2fe:b4e3]) by SA1PR11MB5825.namprd11.prod.outlook.com
 ([fe80::550b:9f0b:e2fe:b4e3%4]) with mapi id 15.20.5081.014; Wed, 16 Mar 2022
 18:55:41 +0000
From:   "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To:     Arnd Bergmann <arnd@kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@kernel.org>
CC:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Beker, Ayala" <ayala.beker@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] iwlwifi: mei: fix building iwlmei
Thread-Topic: [PATCH] iwlwifi: mei: fix building iwlmei
Thread-Index: AQHYOWTH4D+qq7WbZEyldbmO8WiFsazCW9lA
Date:   Wed, 16 Mar 2022 18:55:41 +0000
Message-ID: <SA1PR11MB5825D9DDC4F622A9B8FA77B9F2119@SA1PR11MB5825.namprd11.prod.outlook.com>
References: <20220316183617.1470631-1-arnd@kernel.org>
In-Reply-To: <20220316183617.1470631-1-arnd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.401.20
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d8fa56a-b73c-42d6-92d1-08da077e915d
x-ms-traffictypediagnostic: DM8PR11MB5608:EE_
x-microsoft-antispam-prvs: <DM8PR11MB56082172A6E5EFE2D1138B4DF2119@DM8PR11MB5608.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uMuWLgQdbBrNQLWf77v37qP/BXOeKgLBmRbAXTxbN/hCI3V5tGGtaCrUNZuML6ue9p2BuAjpdDSuo/j2KT0T16JxI/O5QsGQh5YJ8S5TH1DyFQEnoWKXTrKbUJOpl1BHCLKlSwHztPYaaCsVBCGRMiNaPFRu0eFnY320VkNQzmkze5tPJ1DvzWYA4MamUcw5a2Tx6lGp+MA02rCQVkDhW9ZTR/BjqVmaDipzYsMKapOt57ep4lax/pA/eDiswY6C0jAvyI6mUDQi0hlxSWdEfiKWuPtJ9SQdofNri8nnBuJL8MeucvIcAWFX4gyXR2NNfmHFPrc77qpKXEmED57fFOhe4Ny6pYpineEl72J4KrJk9HE3nU6C43kQq7eFuuDN1TnxrQshiAUIqKNIYRhWOjn8e7RNizVMPXBqPk2JsgyoTyFMlPb+JA4bHxUvCRsVeL9oUgb96hrkJao+UCpEme0urVuHmKi7HXgniJMMnf1Dog0DXVRUw4k59qNtwDALFHtaX7TtyEFtL4PyRpFYbwe5VK0K/Mzbp2DGHwvsMaeNYiG4xAGlJcJf9mgFCo+SH80ZzoXsritAqB9Dszf64XEWQUp8qj5LeQwRb9OW4gA+6Fy7GXP4ZpUV5OMbYO9wrcEQo8HL1EUBQcXleehvBuUdOG1K6ZwNf4CjV627NoYz5LsGXvuazBuu8vpt4IvhAx5w1lcEQfWmigPTJJclyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB5825.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(33656002)(508600001)(38100700002)(71200400001)(66476007)(64756008)(5660300002)(66946007)(66446008)(66556008)(8676002)(4326008)(76116006)(122000001)(55016003)(82960400001)(83380400001)(52536014)(8936002)(86362001)(9686003)(2906002)(54906003)(110136005)(38070700005)(186003)(26005)(7696005)(6506007)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kRPN67zsbTsYYoZtBos6w3boAm9DLdd5+IKI4bBBkYGUYoYv3kFE70Q1abCT?=
 =?us-ascii?Q?lBIJAU6klnCjSkCumYXYuqyLx43zCL6e1wmfr24nG6ItzA5QBYIGFayqGrXf?=
 =?us-ascii?Q?Ic7Yg5c+4oWNCMc0wB2r8cO1wKkzK2W9i9Im6sZ6FZOycRwQJUFkhRU0OGWF?=
 =?us-ascii?Q?H4LAqXjQ3/mdH0SPvVuqzB2fCchoVL7WYcibk1jJBmhezk8vo+dUNbr5/UNA?=
 =?us-ascii?Q?MAFtK+V4Bb2XGfpOGAhlbcEpwNr0wUuWnvtn+Ue5+82veGVyC3Eutce/d3sW?=
 =?us-ascii?Q?ZC+qe0VYNqXzIl/kd27KAuv5W1Es5XZZ85widEsylZ4FKybumUZHbWnlu5XQ?=
 =?us-ascii?Q?rkTngVpTrhHWA5CyE6WCwcdhHKfE+Vyetb4hSZMQveaTdZ0FOLc4+ly2oLwV?=
 =?us-ascii?Q?+f3cqDtQ0BLtWTmbWsL139ghX/hYoA6wvX9gOZLCoFMuZQ8heFXSYoxNnKo5?=
 =?us-ascii?Q?YzVPpMLsc0jiG6al5jLIEzL0vhgQ5xXFdcpQS7t8JA5m4jupZSJ33nlXYWgL?=
 =?us-ascii?Q?wfvtqsVFWjts4WYDqSFFTlJJrPF0B5cazyECugMfckQ7giSPPIYbCu7nwaHG?=
 =?us-ascii?Q?43EYTWyf3UHmUSi+Gf5rEtPvMboXwXKZlWZd/WZ+TS8g/pvQOGSqudX0sXUB?=
 =?us-ascii?Q?7BEmIrZ3f6wfo/l9EVw7MUZX/XjzyGDIgsxSG4IHLju3uZW21u5lVgEaiu9k?=
 =?us-ascii?Q?LmWiZE4Z/zPpH6HKzsfVcRu/oOYdOONxXqMI8xM+vq6zyPW5mAH5nWQfGdxJ?=
 =?us-ascii?Q?LoC6i+2ehn1q3p4a0L42+LH5fICZ/aKymd4s1Xxo2iXnGHoTyLNRllM2+feR?=
 =?us-ascii?Q?+FTzox65lRc7yOPFdbK6KTYhTrvTzWW35MiNPixBH95i9YgaIc7+2OQqCSL1?=
 =?us-ascii?Q?clyHXB83iDz2rLVZtT8fAur8hR3w0TDOCIVXgumtoQFhjYZAW/gphlEgmltM?=
 =?us-ascii?Q?bQovlUUkCY4Xh1hOTvSqPIrSlaOhjdZ1tZGqRFM7x5GKuD5qVo4zA+7C500R?=
 =?us-ascii?Q?D7er2HDOkp9iVqf/jkjiRuh7MhxBzHB/Lkhq3mDY2IE8IiwWx8yMlnkPx7dw?=
 =?us-ascii?Q?FNbyyor4V2JOx4Kf1fOrf+0a21DvzJkw4DV5TiNJHYDl8xM5iuqRV4runhd5?=
 =?us-ascii?Q?rCuBoJUQLKlMq6FnURfSW9vRO1droa4cH2TltUb1q5M0Gt181zBAEbCWaK3A?=
 =?us-ascii?Q?6go7VgtyN2HaYnU6ZPHSt0FYHaYJVCMAvpiZmh7ipewc8ybYGA8ONryBGDjH?=
 =?us-ascii?Q?2CvS8fdOw5kjHuSusHduEVtk+EDa/bYsFhk19BlMdEfFj3kg4Dc3KAO2XB0O?=
 =?us-ascii?Q?2Ait53dnbujAFvzsVxdTP7uo/01FeYQ+jhCmUjDz0RgOSSX7rVqcbkrIofM1?=
 =?us-ascii?Q?QHmvyWCX/I0neBqiRP1nBNPMevFl5he82KTGt+eQqE920ZZqugI5bRIZmArg?=
 =?us-ascii?Q?tikyUz29noZv9TUkPoqIcqGe6eWTgiGf/zVWCqJM2iVc6F6VoUR4rw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB5825.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d8fa56a-b73c-42d6-92d1-08da077e915d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2022 18:55:41.1355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HYyWRb7nMQua36vVCrLlUbk2wNVnXvQAl5OYfB1Hmque/CXycqPpb5vV8H3aTBjE/g0bJd47XJ/5OTu6Re1NG1XlyFYNqWyW0na+Qh8XvEI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5608
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=20
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> Building iwlmei without CONFIG_CFG80211 causes a link-time warning:
>=20
> ld.lld: error: undefined symbol: ieee80211_hdrlen
> >>> referenced by net.c
> >>>
> >>> net/wireless/intel/iwlwifi/mei/net.o:(iwl_mei_tx_copy_to_csme) in
> >>> archive drivers/built-in.a
>=20
> Add an explicit dependency to avoid this. In theory it should not be need=
ed
> here, but it also seems pointless to allow IWLMEI for configurations with=
out
> CFG80211.
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/wireless/intel/iwlwifi/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>=20
> I see this warning on 5.17-rc8, but did not test it on linux-next, which =
may
> already have a fix.
>=20
> diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig
> b/drivers/net/wireless/intel/iwlwifi/Kconfig
> index 85e704283755..a647a406b87b 100644
> --- a/drivers/net/wireless/intel/iwlwifi/Kconfig
> +++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
> @@ -139,6 +139,7 @@ config IWLMEI
>  	tristate "Intel Management Engine communication over WLAN"
>  	depends on INTEL_MEI
>  	depends on PM
> +	depends on CFG80211
>  	help
>  	  Enables the iwlmei kernel module.
>=20

FWIW: Luca just merged the exact same patch internally. So
Acked-by: Emmanuel Grumbach <Emmanuel.grumbach@intel.com>
