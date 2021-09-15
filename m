Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33DCD40C41B
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 13:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237456AbhIOLHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 07:07:13 -0400
Received: from mga12.intel.com ([192.55.52.136]:25383 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232477AbhIOLHL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 07:07:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10107"; a="201790819"
X-IronPort-AV: E=Sophos;i="5.85,295,1624345200"; 
   d="scan'208";a="201790819"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2021 04:05:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,295,1624345200"; 
   d="scan'208";a="470712208"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 15 Sep 2021 04:05:49 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 15 Sep 2021 04:05:49 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 15 Sep 2021 04:05:49 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 15 Sep 2021 04:05:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PvlpGqKi8PYQsyiFNTziMg4b+P6FjVWW6ZegD8a0hl4J+6OchSDiVEjlEVODo0K2nZTHHMKGvy74Dd3ZDXFMl1PPf6U7uy33+l4c8eDQEbjpwlvoVGq6nkYhGLbmlLUJvmy3oQvc8pID3XroYFHA8X3IMpc1/iaAv5e1SSshIdrbCBzENUtsxhjmK4DoyOPJrOCX0jyMJpMpTMWDjb804Z3/4DRFsJRd3Rfb7VhqoLEQfCWNOU/ok4iLBfJjo/0oS1QR6BI/OaPjYsJGl1sSvdo6MHiXRW0BteZ9MQgBKB9DqMzWZU/CGYQGAlCaKamTKGgr2uIlfJZFN7y6Y8o2zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=LAJkHt8ZonGaUd8i2UAFbMOsNLi6lzL7JhYl/n0t8Ec=;
 b=Co+nJ080VHj2TLAolO7P8vn59CcvS+MNwdBbXG5dkrKwZAM4srONo/MekU5C2Y648P21tRaFHzWfxVOaPGfWHkC6PgXTYv1KEMeRgR7AZswXAK8QRDTfhXJWmNE76zr6hoWmviZ/ElkZfw/LoCYoSodcXJc7wQ6ZTz4AFG4DVhTB844+A0n8etax0+uHz3MB1wi9O20gMFu/C2Pv6C9DA521PhFX1T6BMzPWRu7MeIRYF9Lv7IMvB9iHHa3J1wH9XPscqJwv71wEG93juV6GepWBodKvKAofSQWcY0dx9wCQ7LgTDWckTfQNK0cICJfFcghRiWg3Q8o7RC4BhJJHDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LAJkHt8ZonGaUd8i2UAFbMOsNLi6lzL7JhYl/n0t8Ec=;
 b=HMD9RXW3WK+jv81wpxNDTLm2G2f0n/r6JWCA6Yq4RyZUvn39s8548xBqejhU3zLVQHdURjJjqP9SqpIr6v4UjX6M5mcsgGk5BQvNNks3Wli6jLdbTU7/+Fy/k5oO/mP37fO2doVcE4iTwnL24kMS+dsNS8PkIU3WWAj8A6kLU/s=
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17)
 by BYAPR11MB3605.namprd11.prod.outlook.com (2603:10b6:a03:f5::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Wed, 15 Sep
 2021 11:05:42 +0000
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::8cd:e7f8:57d5:fc8a]) by SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::8cd:e7f8:57d5:fc8a%6]) with mapi id 15.20.4523.014; Wed, 15 Sep 2021
 11:05:42 +0000
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     linuxwwan <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH net-next] net: wwan: iosm: fix memory leak in
 ipc_devlink_create_region()
Thread-Topic: [PATCH net-next] net: wwan: iosm: fix memory leak in
 ipc_devlink_create_region()
Thread-Index: AQHXqh2Im+49aaeTDUaV8l8RfT9LUquk7fxg
Date:   Wed, 15 Sep 2021 11:05:42 +0000
Message-ID: <SJ0PR11MB5008F3D88D66FAC431FC98BDD7DB9@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <20210915103559.GA7060@kili>
In-Reply-To: <20210915103559.GA7060@kili>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6b71f39d-9c95-4509-f74b-08d97838c283
x-ms-traffictypediagnostic: BYAPR11MB3605:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB360500DF48C4832F397A41A6D7DB9@BYAPR11MB3605.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3HD4DREYq9MTMkFJm8LxOxU5lE4FtqyelevMZmN1oA30QV84RglmqpAHDyB5A8cMTdntcuX3NOr6UA/XltDJXdTy+ZySUVRExTyY7/Z992zGRpN9tePpCMrqcEzcxa+OvYRk+4yUoN9zL2MJvddUvaP2qySGzIqmwJC44G47FQR5ksBnj3UTQxrSXSnHmUhyb0WBiXsEuFERynCIMToZ/WTKROp/q7eBfkPg8ovaMs0dDO52oHPS4WarpcKGPXa0mpwnnKdC6X7Fno3bdGz5EvrFV3cMlSEO21/h2bu+1OHQZ4wQDAhqkdo/Rb4oByVGEvE/e5PU9sGGma0G9p9JKZFk3UGBfb6PhzGU6OMqt+HynuMzpyaPtyfWea4RyLJgQthM+CAClavhZve8+0O/8JjenWvtMSpARNBs+sGMSclewMrUZ/rXQbgZiDydBuU+h4Qfv/Ae2FYU7+XPs1bfEwSw11y/30cmT2kILApUXzeFfkbdZZizBirc57HoOfipnZQFs06CoEGv4yk/ElHZfbTZQNfTE1VHByttlrb+2pSlZw/yyq45C0hLaeX15A4kXUVpTbdhA35dMdio5Jlq7P9j8lcBCB5uFGlZ+SbFdz20wRmlLW+6xylFNPHReHSxCITnQnunnOA1rNwG+3M6Ez1zRcc+TPkGtx2DtjW7QCN4UpOu+7sLaF6MJPnzcava+IZZ8VxR52ugMiHeKU5U/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(376002)(396003)(346002)(2906002)(76116006)(4326008)(7696005)(4744005)(6506007)(122000001)(9686003)(54906003)(38070700005)(316002)(478600001)(8936002)(8676002)(64756008)(83380400001)(66476007)(66556008)(52536014)(33656002)(66446008)(5660300002)(186003)(86362001)(26005)(6916009)(66946007)(71200400001)(55016002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zfIKvfzZGiHw1x68eKMwYUiHEfgdYn8WxE10epvRVz37na9RR1n9Nkj9Sdy2?=
 =?us-ascii?Q?7dX32k9UAu894bJwbvI4qC8nrH5GiSbXI3Jf6A0B0NCvB8wm6bm/kh/e7boP?=
 =?us-ascii?Q?08vV2BM9m74q93rtDhsf/VwBwLBm9k7QqmPdvstYNVkN9zOB+Ntd3QXXiEOk?=
 =?us-ascii?Q?BX5jmjaqKkLwLg7ONjh39v0/ngZhcXZMJ0Evpa/5uWNUpwsqwx+4KGVsw2Oq?=
 =?us-ascii?Q?Cht+/ymWUE1zrzrmhaDaV9DPeDuK2lYyK7PRK97r/7RwYjIX6bhP5+elnT8z?=
 =?us-ascii?Q?x3CPCHR2ghoky0+csFogK3V197iQqnceujLVhxT7QZJjRWAS4gawXafpsNA6?=
 =?us-ascii?Q?e2O9kK9fylBP6vWxlSDe9zhaTJXwuEiR0I8xjhW9RZA/adEEv2q7onyALVN0?=
 =?us-ascii?Q?yTJJf5KSo1o9OgB8HxkokDthgP3df2sb49xU5vcNPqvWDyJjxxVUrk7sAeDg?=
 =?us-ascii?Q?z/+uidB6a5JW8+KwagTQkd7jFecmoNWnR1vxCI6gEFfFgsNxZdLcgmC4Tlie?=
 =?us-ascii?Q?lqDA3RhDbRihuJ1utDqkw6v+r09DgNvkcqUeSkgWgwBIjaIqKRCvPr51hqao?=
 =?us-ascii?Q?pxhFF0ezlI66imiMu4noH7nDS60ezTzP/NuZtkMII8DVdKqLuCwyWSmO4b4l?=
 =?us-ascii?Q?Lh9ObX7h/WbBFPBgloVyJObKTTeTYGLJ2Ho1oWEx1PfkyV33H8u7BovpXptQ?=
 =?us-ascii?Q?1wPhIHVluyAps9f+7V+hkmN6NZblm6wdI8pGlPpRhqPY/H8Tf944tTO7s9Em?=
 =?us-ascii?Q?/ls674N7eZJHjSkbDNRPOEUqzU71uX43O96XcABJquXqtxEUuAD0jVLtk/bh?=
 =?us-ascii?Q?f+IMzEWGkf7z96QQDF72+lKFsdIPtnyw+7obUf0ABbKE69A4T+BWatxBo2/j?=
 =?us-ascii?Q?uabIi8+Nkm3TA36cR+53PHs4ab5kuaOatrlBW/FA+El9u7xcj+28f0f6o+9s?=
 =?us-ascii?Q?THQpUcy7u0MqnwIBv68HK0PWU5HmtwB+Rpvl7wfquKN8TTYG5PPP2woYEWeq?=
 =?us-ascii?Q?5ZEP811/O1mH0yzg768Piq/dfEDOoDqZ82Enc5oDwXTVvE7q6vLC2foFBnrn?=
 =?us-ascii?Q?OPob77zt8K0SE4k7Q1q+VawJscs4AnZ7AE/H3mB6cj1NtoX8V7/nGY48lBVu?=
 =?us-ascii?Q?T3KIg9I5czulEzyjnq5i2RjTAfJVvlZwgT3KTv/RiV6XP5W7fDlfHWAFfutb?=
 =?us-ascii?Q?XQ93jOhV6wTeSu6QgY+RDS2dPPyvhWt63Y2dOMRHJZr5bY6OC2G7VKQmBgtc?=
 =?us-ascii?Q?8MsrdmNGk7T0BdqAIGSdZthp48CjZyyzZkbv/Foutu4Mh7H1D7MGtWOUddql?=
 =?us-ascii?Q?SeLuo7uMbZhbxmbWZ4cvyN6R?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b71f39d-9c95-4509-f74b-08d97838c283
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2021 11:05:42.5978
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4h4TbsgbWh7eYmkjeLO8D7pJ9fKg4rS9C1fKun5jBcku9Lt+vVNCKdCOFrmCchfpR4N+cgLQBKAl03SVDqZyywOyfrcTuNArgGbiUC58cSU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3605
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This doesn't free the first region in devlink->cd_regions[0] so it's a me=
mory
> leak.
>=20
> Fixes: 13bb8429ca98 ("net: wwan: iosm: firmware flashing and coredump
> collection")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/wwan/iosm/iosm_ipc_devlink.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: M Chetan Kumar <m.chetan.kumar@intel.com>
