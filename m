Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 140AF4F2244
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 06:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiDEExB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 00:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiDEEwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 00:52:51 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B5C2B186;
        Mon,  4 Apr 2022 21:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649134205; x=1680670205;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RfGmxm5HP4tF1xlJc2OfUjPs4S1LcQPDCL6SF803rPY=;
  b=nEKZKiz2YmRyZwQw9jS+VzJMoe4p5+G2IGD32TLY8i3GmXvRs9icqFP8
   KYLJ93AlCxilzFQE4WpTYxHuxc6NP9N6Heuaz+gB3zvbqvdjRffRtuKrh
   xGfavFymqUSuNuenPasVyKNskmTkMe8yLMiJxpPq2OvIhOMCJR8uDh/lt
   azjrwlUV/4YuHTROXX3hmrdzYqsbT/iiS2OMJANMSFaIYPKYNDTHjr839
   jpjvVZIe1pEM7WFD1rz1qbTUHqMBJzOkAftBk5VZ2N4vJYueg3UfW2bgK
   tkpRwapmqlTJxNIsNNpr/3VaUBC1nIe7mRTondLFoedbspHwH4b9Vm5Rf
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10307"; a="323838100"
X-IronPort-AV: E=Sophos;i="5.90,235,1643702400"; 
   d="scan'208";a="323838100"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2022 21:50:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,235,1643702400"; 
   d="scan'208";a="696800445"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 04 Apr 2022 21:50:03 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 4 Apr 2022 21:50:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 4 Apr 2022 21:50:02 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 4 Apr 2022 21:50:02 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 4 Apr 2022 21:50:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fb1I/GbD1AjR5+38YqQmkNEY3Dg0vOH0MPBFapAjnzUsnjfZoNMu4YUmCxpY5aRhu4aBL/UONajT3y2RpDkxmFj94Xld/6UVKpIuXn7isalFlf+1mxb22I36hxAcW1J7S7WyvP80R8DVltoW8OLdCzTDADLOZSE0/D5EJn9ea8XHL53NvXhebKeRs/61Ga6gojaqxuBaHrnCDkWO4RsEZDZAJEB8jPjw82WCkck+Fd6lnbQhJmrsrBvHg+MPoHpxmZeJaE8VHNirGjbPMBaPKZ9LbXAOJkw0zmaCYXaV8du9vWmRBlvId3rxbo28/VtiK0b7mENFNFngncLAVg/K6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=34xPorxj7snZZ33H2H91MYntvsNd1JZQpPezBp3oWpY=;
 b=ONKtmAr6hYrlQhQvb3tOJyAbCVW4C6jHqMLxziDZHznDzbYlPO9I+0b3mQdF+cB+kUgO84gRrQYeRFHtk/F+4QdquhmZBYiqjbBcwo1ILP7EthuX30ihiPRohzvo+QekLmdvRjHsJRfnn1+Zwt8dMpVCJ57/2kZCHyPBjOb3zmS5u52Mqn2aacsih1tfy9fVga+G+4rRXVDrLznYCrJuXQiDRr4BFPO9vt3NqAiymlCtQBn4E6Bteq2FcYr4SfESBd0QeuDjXGYRv4JUCHXm0+I0QnMbjuzd2Q2OL8zGsBnynf1VdBzAIRg+aa70s72aIGIGI2yUk+MblfzQsDPeTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by MWHPR1101MB2270.namprd11.prod.outlook.com (2603:10b6:301:54::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 04:50:01 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::b9ca:a49f:aea1:7d13]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::b9ca:a49f:aea1:7d13%7]) with mapi id 15.20.5123.030; Tue, 5 Apr 2022
 04:50:01 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Wan Jiabing <wanjiabing@vivo.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>
Subject: RE: [PATCH v2] ice: use min_t() to make code cleaner in ice_gnss
Thread-Topic: [PATCH v2] ice: use min_t() to make code cleaner in ice_gnss
Thread-Index: AQHYSKibsY3kSH6d6kCH3hCu9AUBbw==
Date:   Tue, 5 Apr 2022 04:50:01 +0000
Message-ID: <BYAPR11MB33676930AB96198D69C234B0FCE49@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20220321135947.378250-1-wanjiabing@vivo.com>
In-Reply-To: <20220321135947.378250-1-wanjiabing@vivo.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f343f158-c7fd-44a8-cbf9-08da16bfbe57
x-ms-traffictypediagnostic: MWHPR1101MB2270:EE_
x-microsoft-antispam-prvs: <MWHPR1101MB2270E400B2FEFAAFBEA9B321FCE49@MWHPR1101MB2270.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Elvs8ujW460TGsdU/JeFQk8VwNw3bipr39lv3KFQ8Wi/ULvqoVqHGXoMvpPmLuSwdfmvXCw7Q6z9x2/VEH7h6B6zFwf2urAogjZ6lJbGl6yiI+MEj20Ah/eYO4gNBQDR8aF4vK21uqesKyrRYFpEQJbugi/kI/qvXd2UsIbZRyvuU2Yr7JPejIiHcz0+6woc8eAyg5AC/h5Zi/s6ffeiLLnx2boVvHPfrqmRJB3RzX+c7f/eElNvlqqZ0WUtHLtho5xFd9nNeXHNARdPSXiH020XHLJE5se5ogVTiY9R3dy2dMmPX2o3ga5WYv6zAMLIyW90QtvmIc56uiPJuTitYnkSeSMzH12KfG8R/BqAdPnPYqztXr+jkCWHkuFykuDvEuvnx5OA40dTKbBeXS0FdizTp7VsOXQK91G+DgMTX1bwdHkpOsGiA0wIOcyadtwE655bb4ycCJ4AfcfbRq8kgOQd+Lr5Y/uE5XMZZSa/Q4xPE7Hi6Z8WsA/PRlk6K7oZTFE58gi/sGldJVykO+i0yOymVudkg1WNSCoVejkAgRuYM+5C8w/fk6mK4H1tjY2xVKj/mGOJUj1Nog+WekldMgCIxcF61jvemacdDFxJZ7Tt5+FhwonDRHfwOY/IPlVRHcPkjeOJvl6/WpXLGqUrU2gvuVVCTkC9XX1h/S/hRF58Zu8ieT+YllQO5jFY923rrRX/x42VP/TF9DRNyYwsWrTtB6CCovMUNLV4JtFP+S0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(71200400001)(76116006)(921005)(7696005)(26005)(66556008)(186003)(107886003)(33656002)(9686003)(122000001)(4744005)(55016003)(53546011)(6506007)(5660300002)(8936002)(316002)(508600001)(110136005)(38070700005)(83380400001)(38100700002)(64756008)(66446008)(2906002)(52536014)(66476007)(82960400001)(8676002)(4326008)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HJEP1zzeEbgt8ennAG1b8ZJyp6DEbEMIouPRDw6gwGDKhQFRz5V9ac4I2BpQ?=
 =?us-ascii?Q?4eJlb3yNtpdFXRVw0PPrgHo/dCcwyZC5AlB4d47xfzXaXIlxivhiJDc+JbqS?=
 =?us-ascii?Q?r+OSuC36iaKBbB2aJFf0CvozH915/JGLWjZyjy4gknuvAjOBUpJWmo/BgWBU?=
 =?us-ascii?Q?IjklC4Ld0cch7rxNCk5qbVhgmS7GysF/ibtYCi3ZB4DmK+B3CwoLiif1P0lH?=
 =?us-ascii?Q?4zSxMCGtx47dUWjS8CAq9qtXkYhjYVsJTI6nhQ2KxgXoNZykE1BSz0yBs0A1?=
 =?us-ascii?Q?oGzuSO8bLutJm8miU9Pn+dpWS5cVxcgEMTDfNenFA6LwEc//91IqLbQrynxl?=
 =?us-ascii?Q?rumn2j29TAlXQfzLesLUIk8u7xRxCF6ovzwFLIy8mowBKOqkOkgmJt285R3A?=
 =?us-ascii?Q?kGasYQ67QTO5gLAXwAIWZ2LssE/0KfotmD0DbDdpAU7PXHViNd0ZqzJr635q?=
 =?us-ascii?Q?6OK7mea6ZrpnxjRzmpb+U7Y+AMKg1aBY4oVEDjj3HZtCWQheEuM0ve1hkukE?=
 =?us-ascii?Q?LZ4A+hgETtSjyN5UtJ2QoomuXYidzl6BMgIfQ/viaq8WOUEgKJtT2g7cKG4I?=
 =?us-ascii?Q?AKz4mfcr9ftp8jNq65GAWmLOwRYAOCatT5G7BAX6y/Wzc4Hzvcq5GgfymzrL?=
 =?us-ascii?Q?AbqUMaA2aTnjIHN8mHaOH099q6fdu1C4pDEeXizSL4xA2RMWRJWlZSsn1Qxf?=
 =?us-ascii?Q?vJ9xA0WStloCvtYWwcPF4hQxJ3iUGb3nYdzgqBaXMoZx1skhiQvmIC/OgUND?=
 =?us-ascii?Q?kJohT+W8Ar2UYk0NK9TFIUrE4Q3s5Pcy2iiMm/HTJ/sHCQe34wKFaCMheS+Y?=
 =?us-ascii?Q?7h5sRX5rvXmYKWuJrVHSyxgfRFOpK6HQYYfUdttayqaduY5U7pmvY0323xz2?=
 =?us-ascii?Q?Vkibj9LBk7WkWPb6ija1ZqVhgyWEkLIqT4iiiWJHuHJaQ41l3hSWBV4PLxm1?=
 =?us-ascii?Q?zqE32YpuOgFldp0jmTDm+ROv+ncZFhkdXrHNqTogl2X+a/NXOb1hlZMsygve?=
 =?us-ascii?Q?RzaLKAR1x7lDffU4B72Pa3iLECVn0RJ2Cw/GhzdhFpjhyESYYuzSHrqRKsOy?=
 =?us-ascii?Q?8HyYs67HjyP5NIVp80Vtz+O4vzqB0/LmXNXBAaTDLUlc22pMdKSlkslusmIM?=
 =?us-ascii?Q?wGHow8YXpWO3RnF0p5b1bUtV/RAvLxE1JGwtJeGncAgpb3OxT0ZZRKl2aV5e?=
 =?us-ascii?Q?1+Vp+FWpqIxGeCZv/BTtQxmtV8zTqaguBuPJd4w2yOS1qbm7Rl6OJP+uIEO+?=
 =?us-ascii?Q?Ez1SsoVMQmVXeLopaleFbwv7+HLJbVMx+1IsuV0Zo9OLBcPb5elMebz7HTa7?=
 =?us-ascii?Q?QY9BuZMD1sSTa08lN4lND/cNVXzH4wYB51oV7k/FdqBSeElcgLgM07Wwvf6F?=
 =?us-ascii?Q?TgAbVDJr9P0dpym2+P9kPq6vY/4wJQ/wpvwsML/D7M+0GHbLvsz3mWZPWI6e?=
 =?us-ascii?Q?Gz5NOk2L+6iEQqJs6PlX3Xh514SUc8O5FluE9P+FNkeyNUrbGuU/rx//SaM3?=
 =?us-ascii?Q?wFBKyNyo8HDljCG15S9ctsaDtg0d9MVIio6n+ekPMNfp27Z6ZMKdFqVSV8S/?=
 =?us-ascii?Q?86udIwRFG+w+ipOYhc723/evnNId5Zk742lWcJI+15KWkkf2vU/C1S3sNK59?=
 =?us-ascii?Q?zD1U9zvkdVipOu12yQ5GmuduJlpZTltnv/M+DahCL1HIstSa/1L4CUEDSaRb?=
 =?us-ascii?Q?yczcqyGdr+NTzUFcyi6KD7dTw5XLdUDMzeLeG1yCpcWpgnL2Npbq5UyOUunR?=
 =?us-ascii?Q?G05dQekWnQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f343f158-c7fd-44a8-cbf9-08da16bfbe57
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2022 04:50:01.3086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0ruZCznWn0NL7FnGJIftlT37B0kL808IYkEhyBh9eF2+eBwFBzbsfVSxH2Lwim0p8l8mgO6rCKVbtCP9vjssyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2270
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Wan Jiabing <wanjiabing@vivo.com>
> Sent: Monday, March 21, 2022 7:30 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: Lobakin, Alexandr <alexandr.lobakin@intel.com>; Wan Jiabing
> <wanjiabing@vivo.com>
> Subject: [PATCH v2] ice: use min_t() to make code cleaner in ice_gnss
>=20
> Fix the following coccicheck warning:
> ./drivers/net/ethernet/intel/ice/ice_gnss.c:79:26-27: WARNING opportunity
> for min()
>=20
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
> Changelog:
> v2:
> - Use typeof(bytes_left) instead of u8.
> ---
>  drivers/net/ethernet/intel/ice/ice_gnss.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20

Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Int=
el)
