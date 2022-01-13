Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB74B48DD38
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 18:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237288AbiAMRxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 12:53:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:20193 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237280AbiAMRxl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 12:53:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642096421; x=1673632421;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/e92IrYx65gXKxr/iIfwO0Ll4mHtYoAIO+fKqpcRxI0=;
  b=Uys87TV7IIytiwlC6HsVvhugqFGymboPwgprIgh/k+C1MrkoLv47U5gz
   Z6nSFEKoOZtcsTi1/GuKC1G+h6eKTH4qCRVx3jWQ7OIPeALE09Pe9w2bL
   LHR3v1fH8nwbNpXjHb8LVUKONvv4IOc9NcwHSM8NzCzYUzU3lVOzJTYl7
   pOC0Y1EqEWvX4ZJ8rJXekmAjtEfJH4B7sRPZs0eM8YTBfTSabCTKirGaE
   7Ll/lmoaAKsxf8N7I8nreusiA2tP1lNz7jPD3hTEhMQbcA6+FI9ZbLwqs
   07muWyyx1rbuN++w2N/zo1tUttQW+azuZ3zweg7rCMKrks8mvDnapGdRe
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="268429950"
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="268429950"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 09:53:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="691887768"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga005.jf.intel.com with ESMTP; 13 Jan 2022 09:53:40 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 09:53:40 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 13 Jan 2022 09:53:40 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 13 Jan 2022 09:53:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B/0AH6FzQh5I6R+KXVychgTVql7gjePbWclLKBqLjfdGQhHsMy52h8OWyDNn2O3CfGhjsu5VkdCLd+CPKYintzvHJHtb9v2VSG7MACz69w7YqxLRng8cqocX5jnG1PyphEyDI6YDwzmj4pWIuBp7rIQM/nxAJ0yaH/8vtuAXsvOe3eHsMx2bc0ecikvCeUd0w0O10g724DMl6Fts9xdSoU3gNjuVR+y0QnknSJh2fdzTqLkuh8tWC5rMDaLlixCo7DlX57rcKg608aFSw78pQczGX01f8VHr6mssCgLqm1zr1pRklTJdYQ3qVZyKZo3j6r0Blu3jrzp2FD/JVYIhWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cgO8NTtIs29v6288t09CA+R8AOhKXU7eA8xmlk6NpJs=;
 b=ZJb7ar8kfj2UCtljpGr4/N4AfQIPfrTUrhvqC2auya56xYyxUw1JWaNZ+d1n+jEwuTkrjS25RAJ561OBaQbChWVU6MFnqpTgHtUFh1d58sebVMVtYfSUn/okCveCsQOLvAVaLPzBgRjQtx5z9j0QAzyEAbe+QvVdChAb3C5ejvtGIfWeAdk5/001BQT+0lF/DbbgkgC4Dfm9zIkE5Gr23GHbIVpQ0FLtEgN96OuF26m2DGblb7J8xiMcsD/rufpuOPO+Wwb6WBeYmFahxk7IpxULDqlA3eP7qwl4s3JvqhkQHqMw8QH5PoNP72h2AAPw+04uZjxOc5te0vM3UJnMIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by DM6PR11MB3242.namprd11.prod.outlook.com (2603:10b6:5:5b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 13 Jan
 2022 17:53:38 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b%4]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 17:53:38 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] igb: Remove useless DMA-32 fallback
 configuration
Thread-Topic: [Intel-wired-lan] [PATCH] igb: Remove useless DMA-32 fallback
 configuration
Thread-Index: AQHYBYiVAqerqoRTIUKQOjcOK+SwoKxhQc4A
Date:   Thu, 13 Jan 2022 17:53:38 +0000
Message-ID: <BYAPR11MB33676ED44BB4F86B6FF4A366FC539@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <abb2371cc7fabfa26d96abc1ff1b80ac038448b1.1641753678.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <abb2371cc7fabfa26d96abc1ff1b80ac038448b1.1641753678.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 597489a5-d8a6-42b6-df95-08d9d6bda0f8
x-ms-traffictypediagnostic: DM6PR11MB3242:EE_
x-microsoft-antispam-prvs: <DM6PR11MB32424F5161A6CC03A8DF3316FC539@DM6PR11MB3242.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UXF18yEl/bZlp5gtgTUhP1OK8UQx4NYzhw8QjTeW3k7f7HHtYghyLKBK7JEuW/IBPNrYWO1h7uHoIOMx+qaFR0f/4TKYDrjURqzYhfGM8gnaVZy9FTOYsai8lNzvqYNiusGU2t7lzlqrfT0YLpzKV0mJje/fdNCEml8Ev5gjfXhC9LxqLSSNHzIKeVlGKlStMUHJqHmTIzfUeF1dTz9ytLHO3PB1/rOWDgatC3KT/Z+AXFn/9z/X+K2RUEiqL2wYU4qFrjSOIflQWBKAYU8ncnL0ciZaynkUrQaCBaHBBADw6TJiRKTKQ4Sl239+Kb/eh3XCaHg0FsgnOnrl6Zyz7QFO/bAWpZei8Qld9YbJs58/rn7cGhTmFK8IUXzEN+sOU6KjWaNRiZQc74hXwd+ZPPy4MUlLR0aoc4ahamRkLt9V37ogV7c/yOsdmel7cvErlcjwmtQbixf+kbXgWdZKAk5Y8u8i+SicQ5kK2dQdjWfT5opdGCuNYCA/duv7b7VPGNmEoyXfsjQLsGKnxz9As/rflszMR/NfNmQmG6XtQm8w3h3jlp7z9ZuT5/tTtAglEvSZt8DZSNMc4u4ZiU9spvuxArAEpkNC/JGej7QvHVGQXGtqzkN+ykhG2Kb37xBqUT7SuWdEE76qtrlX6tlhaeZhhB9OJT9OGIwle1kr8tVTFHdmXs8spXY8b2eX9k9JY83mww1GuiOxdVzYyKHHFLXFv/pUYDglNYd7jfAfvXpuSoEwioCm7h3aACYOeJIxR010Jq1enQ8OD07vwGBLA+ySA5p/1RzZNBHSK7+dVJQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(6506007)(26005)(8676002)(64756008)(8936002)(7696005)(186003)(86362001)(9686003)(66556008)(38070700005)(71200400001)(66476007)(55016003)(66446008)(33656002)(38100700002)(83380400001)(122000001)(4326008)(5660300002)(52536014)(2906002)(508600001)(66946007)(966005)(76116006)(316002)(82960400001)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8D1L4m4R15AnJr/INjL5GAI/s1A3840lhGVsBpdRBYoU/V/iEp5/lHLyxRex?=
 =?us-ascii?Q?Rh+IcnsbaT5H33XbywALN7bHisbOw5J+QCMP9Wo4DirsT8apUbt8w9ocCwKH?=
 =?us-ascii?Q?CKy9F1aIPqWygQdUwqx8V4lFKUdQstIo1KkHmev55JrZV+DNKeNn/ySdAorQ?=
 =?us-ascii?Q?jpyK+EN5Xp+WMPBB4KHYeNvHqbsB+fvUUo2kOE8EhPjUbcNhb4VSPXsdekWs?=
 =?us-ascii?Q?c1JTL/paK/VNzUHvcrCqh6RvGXZKjxFFhatEX18tsFhKbG46NWiqpwUI01O3?=
 =?us-ascii?Q?1LxJGIhODhM3XPqLhe6n4wgR83EnC6l7nZCOp/qvf6r9xfdXoEO1L8R5tBZY?=
 =?us-ascii?Q?UC2EwD+iGO2N6VRqXaqAqAKCCswKjl02K1zkk1Su62NXhAGpzsLPQlT3HIHO?=
 =?us-ascii?Q?orQ0Evqracr8WppQiA/cdnGg3ok8ei9u0QM//gsL/qKCHeEF83QFllc5B+PK?=
 =?us-ascii?Q?0dq88IpeHH5g8LcfuarAR+44zuuAs/hlnMbX+JIeMvWZq6jrTql1XG3tA5Fg?=
 =?us-ascii?Q?gCGfacLT1E1t8X7pSDJ6l8KRCKw9sYdZEWQ86hcfatKd7QjKPA+Oa6NYpWiu?=
 =?us-ascii?Q?F7TQeyb4yF7tzNS9JokfoUnBbSixWaq7DilFEwgXxSWrn6ZjR+7JqhHq1Yph?=
 =?us-ascii?Q?yIzh6SCZknZkih7RZuwlGWXxo9jFBWWbm1GCli1Pii0ljkc0VJk/cZTWrLrt?=
 =?us-ascii?Q?iSUOPz2BDX/iF13PieTsNjfM/GRfeie7b4RLeHKYz6JOt1cH75wx78qb03AR?=
 =?us-ascii?Q?7SgKH+YJgler30mFtvp9MRtebnRPsoHEAquuCuNYqpRdurDG7kODIExCF179?=
 =?us-ascii?Q?D1Aj8FmuFQ4bUnWsvhDljDPjeknRb616dIX+Vuwz4fu4FVteSuosXNx0cLMk?=
 =?us-ascii?Q?fibk/4IkoRFCLVNsYPOOnBZ5/XqBvzoKIxUSI29vZahHxs0klp56JuMGWvDj?=
 =?us-ascii?Q?Xf1D7g7mMM5/qEEOnmqUHDlyn69FfziD79xFNlESfver0zj69hbXDZtO+d4o?=
 =?us-ascii?Q?LfjBTSU784XdpCYfK6WyNNdK7SMOs/PtBQcRhvf84XTt3b5rJ5li4OF7MacE?=
 =?us-ascii?Q?cIpn3w+zlC3NdTDwraTaPyrf2cSI6DIfzC5EEqcmmZDfHN8Eym0sRXRCpuNd?=
 =?us-ascii?Q?EZc/tCBsoa7CDP/t1ksStyXET9Ff1SV3aUXRFnlQAS+YxOH1XU2FbvbeTe+A?=
 =?us-ascii?Q?UDNQibvPEqahLuGnl/dLG1sfMRtn4Cp7y7i2ez1MKxLxtabeqK24eCrz/4ch?=
 =?us-ascii?Q?ucLK8zqyEzITGiuqjgr2DSpr5PmT5NerjzuH0/FVCZU13HAlmk1t+hO2GMQ4?=
 =?us-ascii?Q?wxNARNpgIN1MdpaWJlKppf8u6ARLGRGvT4xCjnpOs0NiCk7rZUBAvpK9e/9d?=
 =?us-ascii?Q?3bckr+PHOg0PP/bU1iM4l/LPggETFYPNspkRJGuijnDuj+qbi0lE1Az4G8Nh?=
 =?us-ascii?Q?C+m7y19XmtfdgRpBP718d9DEtyb6K4u3adFxyonYFxV/zdIxHzSvIOoaMGJU?=
 =?us-ascii?Q?8U/CT8OOirBP0jsAYQprjaiMPBhbPIG9cCfVx7ArFJ7RbP3tmUqr2zp+NtWg?=
 =?us-ascii?Q?fCJfznDdex8zRNQqid6IntHcSxLtgPIPquBlBwwbM6UQcjIszLP4IeAB2dYC?=
 =?us-ascii?Q?PA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 597489a5-d8a6-42b6-df95-08d9d6bda0f8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 17:53:38.6369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XWrbT+pFM4ffumuNPvPn2Cb2TAqxT26a++Cs/O6vaJ0H/bOJadFnWaJpLaIq6t9t360OZ5WjF6iuD7uqlZsw8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3242
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Christophe JAILLET
> Sent: Monday, January 10, 2022 12:12 AM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>
> Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>; intel-wired-
> lan@lists.osuosl.org; kernel-janitors@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH] igb: Remove useless DMA-32 fallback
> configuration
>=20
> As stated in [1], dma_set_mask() with a 64-bit mask never fails if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
>=20
> So, if dma_set_mask_and_coherent() succeeds, 'pci_using_dac' is known to
> be 1.
>=20
> Simplify code and remove some dead code accordingly.
>=20
> [1]: https://lkml.org/lkml/2021/6/7/398
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> This patch was not part of the 1st serie I've sent. So there is no Review=
ed-by
> tag.
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 19 ++++++-------------
>  1 file changed, 6 insertions(+), 13 deletions(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
