Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E09A5298E6
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 06:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbiEQEvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 00:51:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiEQEvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 00:51:11 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E46D767A;
        Mon, 16 May 2022 21:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652763070; x=1684299070;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qg8DqPwvXzHwv6YFGt7PUXssVRix+XcQhF8KEg9IAbg=;
  b=apSmbixx7jGpXhDNVNX32rxOeov8UpCVZYvbyKP06Qj5rr1wS+G4Hne4
   gcrg0wB/nZJWZAEShpDl/2wVXMYBD2sT8B9y9BkuHfNrfuZpkX9Q2rP5o
   kguzfPf96Jg5sb7JUWNuOcopR5IW6vq431OQHPXKRjRPLYdVsxobWifSH
   HtPYmddi8apj8QprhnLt63WjPP92jitxC7OvdPui5TYnP49pA02QNLSis
   UARbHVJaRplxrLyaEj+sANa5c5SYFUVDboheDUb66LyTGMTimtGny26k4
   DKGSg8xM6++/a77tXEowWG61mXqJzcbrdeQBWroH8TwrD9snThzld1d8K
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10349"; a="270749783"
X-IronPort-AV: E=Sophos;i="5.91,231,1647327600"; 
   d="scan'208";a="270749783"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2022 21:51:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,231,1647327600"; 
   d="scan'208";a="816720755"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 16 May 2022 21:51:09 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 16 May 2022 21:51:09 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 16 May 2022 21:51:09 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 16 May 2022 21:51:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6fTQ3L9K0R2YVS0yS/00sLI/IBWxST28ORwm6vFq4eepk+KoeVfRQoZGTGvLnR745buSo19DL+DSptiMwQ1rf5v4GApOHHmQM3j8ZAyhvsbWbXpe6NT6GQ0h4xf27uQIIFTqzeOyhS8g53v2NMmJlNz7lK8wB7X0I45KQn8M5D2gn5tRHJ76wNuL/1OugCTKkfugBqWAvgjIobBkYQC+15AaxosifK1OXXCORlT9nXxdQDiy+bycuBSsZzfHht7ZC82gOBOqKG0LyZNGYtDr6K/Hqwvzuu9Qjh2/qqFqp3qghJB2fRRFYP3ZVtnCYijhgslvMgflpYO65/47WOc2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cf/6GqQakmk2M56CJX6PEdCOU6FMsC00efeeAZ6+UN0=;
 b=QkjYDgVbDPwr3PtF9luOILV7AkEwqiLXz2G4yiS3hipjZ3eAPFaEw3PNmtJ8DpuLBQW4nfl06ZCorXIW4yN9RMW4lNbmoYp30WbynTACEtzAjdNwOQGpYb1KP7a9bPBy+3+DbWEKqyCraqX6HnHi2S15057PyBa+E4gSY9Z3YtkEWCfxzYkbhIJAdQ5FUeQQWelaGRtzZR2LjpqREDfqDUYiGqW8f7Nf1iATGXQFv34N62lnWn3lmK9rkooVTPm0WuEb6NZVfb4cOQblIqcZ/Bgw+QcJJY0k7G7X8V1t55c/iDeUXvpH6Ug18KzFHh+r2MhPDLTfq7p0isE+uVs6UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by BN6PR11MB1252.namprd11.prod.outlook.com (2603:10b6:404:47::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Tue, 17 May
 2022 04:51:07 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::829:3da:fb91:c8e7]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::829:3da:fb91:c8e7%6]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 04:51:06 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Kevin Mitchell <kevmitch@arista.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Takuma Ueba <t.ueba11@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH] igb: skip phy status check where
 unavailable
Thread-Topic: [Intel-wired-lan] [PATCH] igb: skip phy status check where
 unavailable
Thread-Index: AQHYXiyXdlo1dFaWAkKS1NtVi+QR/a0ilveg
Date:   Tue, 17 May 2022 04:51:06 +0000
Message-ID: <BYAPR11MB33671A1C46655513B37A87DBFCCE9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20220429235554.13290-1-kevmitch@arista.com>
In-Reply-To: <20220429235554.13290-1-kevmitch@arista.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e90689e3-ab99-4bef-b82a-08da37c0da93
x-ms-traffictypediagnostic: BN6PR11MB1252:EE_
x-microsoft-antispam-prvs: <BN6PR11MB1252B43F9C0F72C7DDACFC73FCCE9@BN6PR11MB1252.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PIAWbxGvybSWNVz5WIi9eeO/Vj2MDF4UlDsnq/8CHd8WMnAyPeL2uXmw4r9l7AmQC5am23r00g9fPdaU5spiWVgSNPBoHwWlRq7fZDzDzvuqMbGc5RYSkPT95VIBBeLDRK9d9MKPEkviPI2siUyOk+c03yqROJErscKSoCb+o3wzZVQaubAWYdDVEktFQdUA48gm4jvqnOQPrtwVaFNbKRjOfd5rzGD8rch9cY3bG2BUMrydZVifUoR0AJ2HX+TjXUx+Sa10NwKy6WATFfleUw53t+Tuve9+TqexP/bjIrYNs37hMmreDCQU6zoZkUw9Gxu7l/+Sm1VqKA2JE6etq71C9yrU1r41avpOWO0X7zaXR/RUOaW9EmorfFTY4cdlxvq1FwTpzJbahu9HAUHkTs4zqIv0xz/09k/otiqPOw7QhPNiH+EiPTdQI2wyuungGD+5+629PlLUXZ7lmpxZbYtIxkLgVvmVlxtRf7Mg5NBiwnMYFmr2emuMChe4DZcAny9DdCyRLwpZEUgkUesPlfUbYrLnF0fnsPzeCHb6Ofv/yCgnsCQSOjxhLBLL6isV9taa20d1Egv1R6eglkVjfLY+vtYoBprFCLciHvlTqVYt+toIzoUUD2wF32BD+UhHS7Vpl2L2aQmNGVuJr19QI8QI20tkQjESa5WAu5TjRbMxXnRC0ZFmNLMxfE+Vgn0xK7PuB5r41pKDYq/TtSZN+Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(33656002)(2906002)(52536014)(83380400001)(6506007)(186003)(55236004)(7696005)(9686003)(316002)(6916009)(508600001)(71200400001)(8936002)(66946007)(66556008)(66476007)(76116006)(55016003)(54906003)(4326008)(82960400001)(122000001)(38070700005)(8676002)(66446008)(64756008)(38100700002)(26005)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Kaj3i0J1mDPetruQ+hkewT4zzvlN/tDpqii82wd+CoKHlowDUIPzPNheP5HR?=
 =?us-ascii?Q?6uIoSXU/+dQ1mLwKLR0zoBfRBdGWFPwexjRu0Lr/LALCjLAnDyhpp8sjn29d?=
 =?us-ascii?Q?E3Up1Je29NqgRfwYtleKIZVfxQqWJxlvWfaq3zSbkO12xjPvLUrxWtALYw6M?=
 =?us-ascii?Q?TXeMjA89w0ZJhQWgFMFfpI8BGNci/0rkl669zTARFBF2p9DTT3+ROMbZ6GeM?=
 =?us-ascii?Q?IGKLRyIt91WGGxyOnQ8/WhkhgDsIaOr8NAth5aCcOkJcnqVXdBY6RaHDEuIu?=
 =?us-ascii?Q?v9D0mKd/JDCcb5EPl+dTIgSBUf6/zkH6gAP2kfTXHO3dIUFPpCOb/OATuTqJ?=
 =?us-ascii?Q?OSmXIS6cpBF4ieEzUtm2SGgM/RyTgghIZ6A9lH3gAcLBTdmKXVb8fAzXcGAn?=
 =?us-ascii?Q?fRvmUJrPwMsX0YXAN1yJSpfQWzSJ/Nfc2sAJmS+V2f5sGzABi0r10On+I2YX?=
 =?us-ascii?Q?KgmU/7qnF3wstjUKzAQlonAEu/iSgtEvLBz8MrfWKxPj7g+qVYcCpE1uN5YO?=
 =?us-ascii?Q?1GeF5otQdYks63E/JTLc5vabyWLA6q6Y3hcnLj96FguPFdoavDo2a/tnKe93?=
 =?us-ascii?Q?znFnxRnjDvEI9OIIl/Sx2RGoSh3HnG50+lEbj3qKl0Jw48Zz3GNEuvRsSxCI?=
 =?us-ascii?Q?nXFG8xfOnOIgoczIw43rqC/+bcCidnG8eHQhgxy8QZYSeoUdspGN06LKxesi?=
 =?us-ascii?Q?1O7CEBYEVb16nL+bx2MeHonpf37yVQ3QFGW1vkye+CnAkPM2+ox9B4S6f0Xq?=
 =?us-ascii?Q?DRskNvlsl+mWRuLhfE/MIIl3f5e4uyCv53fYfA3kzt4ezZez8Cgmym6L7Yj2?=
 =?us-ascii?Q?OORLDmR17+MSQTZnODotht8aiOeIPeIdO0JZ6F+ydGH8T+bIDlqGfZjLX04I?=
 =?us-ascii?Q?H18J87Ulhn+Fet0yPu2oa22i/HhOY429eVFMNiOjg76Kc00bK4NorwkE8R3K?=
 =?us-ascii?Q?54NuV3X4KJlL847jXBTkYyckrsF00I3hi6JI6EogXDr+gd/PA/JKpY1sDV1T?=
 =?us-ascii?Q?0C2xwR486O1M/JumIPI6NI8Wqtb2gZX4O4VqQbP3T8TXaQkQ0oAWtt3vS2Ch?=
 =?us-ascii?Q?NZ8pIaZFMCEF5JVCgfCZEpZepyqeVqYeKWwlR9SOUY6WQDOWiNK3+4IwtuZ1?=
 =?us-ascii?Q?vz5lVZdYcsei3v6U8RNQXDTcmV2Dr3fiI60IKeJ6XVZJTQsCEpvQlIT6CAKH?=
 =?us-ascii?Q?PIBELPlA6RnJEajZ4HfBmBWn60yObdQbcdqmcI4zajoX0tl+vPLrR8/lP/gu?=
 =?us-ascii?Q?QL9EdBhGMDGATjaGbFs8CVwoKsDsMZ5mS/Ajgg4FVnYbHD7t5Hef3fpqgpFd?=
 =?us-ascii?Q?XfhyCYclAzVzu3YL4aknP2W5YUbljGfd55nEe3aCClH9034bBeq8cl+GrdMm?=
 =?us-ascii?Q?LDIvR1GJ9zkMkio+k3v1fD7hwR1vJZl9Ch3vUTjcCzgc3JYpECs2Ph0x6jLx?=
 =?us-ascii?Q?/dkieeV6ARHRKnApKTGiELNFiFOg4zy6hAZgNUN+i3kOYGtD+YZtw8hm2jQz?=
 =?us-ascii?Q?8ta+tWTKQdUC28pMeY55P2D+6w0H0PkpUxqxgDwrJ2cjyAvZOozdeDIMSzGT?=
 =?us-ascii?Q?+A1+jYrKVZhwMbD2mTJDfUUAE+3+sdU/IAqL51r9cww6p/mXtTvGPJ57pciD?=
 =?us-ascii?Q?zoqC3bc3bKhjc0Kdob2OETxF7GC62s0nLDtnS5+1MuOs/nh+eR5CfnnN2Mvd?=
 =?us-ascii?Q?I9z3ikbS/VMdo8vacKtNpBS5ykL836JlFQumsLUmAMIDMXwNoDQgbpSH6LMp?=
 =?us-ascii?Q?3SZ/dyZrFw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e90689e3-ab99-4bef-b82a-08da37c0da93
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2022 04:51:06.6552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lSWFoQ+Wtu0nFhD03V+P3QV3uORLuGZF9dyhZHPEMKAfeP3HuboWwUVJ2d7m92yvanCLDhhiWnFfvW8MKZ1xHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1252
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Kevin Mitchell
> Sent: Saturday, April 30, 2022 5:26 AM
> Cc: kevmitch@arista.com; intel-wired-lan@lists.osuosl.org; linux-
> kernel@vger.kernel.org; Takuma Ueba <t.ueba11@gmail.com>; Jeff Kirsher
> <jeffrey.t.kirsher@intel.com>; netdev@vger.kernel.org; Jakub Kicinski
> <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; David S. Miller
> <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH] igb: skip phy status check where
> unavailable
>=20
> igb_read_phy_reg() will silently return, leaving phy_data untouched, if
> hw->ops.read_reg isn't set. Depending on the uninitialized value of
> phy_data, this led to the phy status check either succeeding immediately =
or
> looping continuously for 2 seconds before emitting a noisy err-level time=
out.
> This message went out to the console even though there was no actual
> problem.
>=20
> Instead, first check if there is read_reg function pointer. If not, proce=
ed
> without trying to check the phy status register.
>=20
> Fixes: b72f3f72005d ("igb: When GbE link up, wait for Remote receiver sta=
tus
> condition")
> Signed-off-by: Kevin Mitchell <kevmitch@arista.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20

Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Int=
el)
