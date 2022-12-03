Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7A864149C
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 08:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbiLCHBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 02:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiLCHBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 02:01:11 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8141E67235
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 23:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670050869; x=1701586869;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W7EUT7gMLelGFXNrrOyoUMb3bWvMX+80hNe66on0fF0=;
  b=T4sfHro1gdhiRJLSTB8y5fxSKkzFEUo7hrzfR0YkAQaOw9HqOczeLmvM
   DTRY+C8iDGfpUP8V3CV8e5TFSdlyV/vKixtXK9KBC7P+T0ULA/V1s+7SI
   Xf8sHKutWJ21ZQLvRJJCUa9ObMSoOCTqL0cojqLOadOrLpa+gLo6fhL1w
   J25g3xqmvAt0cF90socqSsnkY9if84Yt68SIcluVev3Tq98V9LoQpzkoc
   7LgvRkjI9u+2h9wx84KWDv3NS8QafcnENnVeFGcU193kNTXsNOmvaUrUj
   XuGxL1/t36tHLUyBkPAlv8HNxwh91aSeBwsp1S0oR7+ih6f+qcv9fx40V
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="378253199"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="378253199"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 23:01:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10549"; a="638974241"
X-IronPort-AV: E=Sophos;i="5.96,214,1665471600"; 
   d="scan'208";a="638974241"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 02 Dec 2022 23:01:08 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 23:01:08 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 23:01:07 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 23:01:07 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 23:01:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HkefqiN+BKtGU51c3v+q7i9hocsETx0pklzMSgiOsJnMUwOxCDFW1k5bRGyCLr5U1iaNu+Ad1zSeu6Q/D8IpbcorjTcFmtT56dpCE1DB6zFHxTt+SKZhCvV3NyTyD2FIAs6JHt6TU3Ccm48PYTbraesbjWkl9dWppIqB3PRkmb6td0nQuTRCpAufkMJRCsyDTerxhxGQ9fNglN4ForeawoN8guwV1j2ANmFCOkk+Anza+SWnIJg4Jj4QY+q5crHyCVD3CXc2P7dyfLfGd75vUyOgDQizrhfPGD45mNA+XN8KnVof98r2cvCDtmLXdoybRvLKV14ATMu45F9XDYvVqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W7EUT7gMLelGFXNrrOyoUMb3bWvMX+80hNe66on0fF0=;
 b=a+s6aCC7loXtjUBEGC8zxq/Vde9TVKFQ5VkhCdoOfarZaVvybbI7VhhOnJCQJuXbUOLCoptxCnX/n3XG5ABfYE6ddZFekKkhE7isXQKKM6fxsjJ5WmqcHstlv3s4PVu97Mgk11viIyXOf5xio3f3s/d024WK7Uvlfia50/d+pMtjQ8DpV8jhc6W5YnelWw1CUKdt5Tdv87rfxOBFuuQWw8j/hQEZH8MIIlNecCkGA1/e1vHDxz3Glq5nJxw4u0606uGYvaG1TSwxF1WlZzmbnJZR6Y1lB1dNxZf4gNCTCx5fN7p5i1/QfjRwyngNNuZrfSl/l/DtSUzB4s4oGIhe7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17)
 by CY5PR11MB6463.namprd11.prod.outlook.com (2603:10b6:930:31::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Sat, 3 Dec
 2022 07:00:57 +0000
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::83b2:49ef:94a0:cda2]) by SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::83b2:49ef:94a0:cda2%7]) with mapi id 15.20.5880.011; Sat, 3 Dec 2022
 07:00:56 +0000
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linuxwwan <linuxwwan@intel.com>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "weiyongjun1@huawei.com" <weiyongjun1@huawei.com>,
        "yuehaibing@huawei.com" <yuehaibing@huawei.com>
Subject: RE: [PATCH] net: wwan: iosm: fix memory leak in ipc_mux_init()
Thread-Topic: [PATCH] net: wwan: iosm: fix memory leak in ipc_mux_init()
Thread-Index: AQHZBrsPNVTjcyExZkex8pMtXbWFJq5bu/zg
Date:   Sat, 3 Dec 2022 07:00:56 +0000
Message-ID: <SJ0PR11MB5008F5269E98374531186732D7169@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <20221203020903.383235-1-shaozhengchao@huawei.com>
In-Reply-To: <20221203020903.383235-1-shaozhengchao@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5008:EE_|CY5PR11MB6463:EE_
x-ms-office365-filtering-correlation-id: 3518ac3e-3c84-4310-4476-08dad4fc2054
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1pXeW7RI8wKo4hdxp+mhlWAkcCZaTAjP7u4WqgSSZxRkKukSGkxQ85khCLBVGC9t7VguOOseWZ/vEYpu+YU854mvMUAA727MI1jzaBhRj8k3X4Pt1UbCMQfzCKdRcOHGsKqpFDCRnrujQBKlvaWJO3teggXkrWzHkE9boikEVCodLoNKmPEhSXetpBFA9fyePgHJuAwJgPv2RkA7jL8dKrAxqgMxcJkHrBlaGEUhcZeh/b6HKR3PW5IzHYDp2C8ZQn5ZaXfjoROW7+LBe6gAXdPymZHM9w4vk3DpQR3XU67rWkD9blsXGOOCfTZzh45J+WZPy6IkdicZSEo1vDRvocKt9NDeXqhFPkrcd0xybK4K+TAXQASFYnkpG3Y0pTv9PBdR4h/ZKTd0bsguq2d7jmIH7VsiBGTBIzb6MrQEcF3StOCMWNssbHrDohCHn+skcPYjK4UEFhmT+ayKoTFXC8AXvAHVs+6Onm9JogrIcx+2xMno4HVL37rfbmZLaO/8/4ELu5BfaHiGzbBzQzszdBRXzKZvqYFXimmtXWhpP80EwkZOQByp1Rw3KmR4tyQCD5bYqKRIJk+tTPRPAEPnI3DRORGiLwiwIgzYQ+i9oqiD1UHSENAIEonn7jMsaAQStNIcUFsKjwny4VR4vTrVURFOkTrPtWNk4Gr15mdmur4NxfongDRjk+9Z3bJq+aJW9ekuMT+Av7lXBEKmRNVgEA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(376002)(136003)(39860400002)(366004)(451199015)(122000001)(41300700001)(38070700005)(478600001)(2906002)(71200400001)(26005)(52536014)(4744005)(76116006)(86362001)(316002)(8936002)(7416002)(5660300002)(54906003)(83380400001)(66556008)(55016003)(38100700002)(33656002)(64756008)(6506007)(186003)(9686003)(66946007)(53546011)(66476007)(4326008)(8676002)(7696005)(110136005)(66446008)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LuLFHWRB5/MQCh+sWN/DiQgbfD0uCg2AUOmxzfV9S4t6KN9dxuAIYrdQBaJV?=
 =?us-ascii?Q?Yfjn9GxOTj/z+Bp9R8p4usxDGbvt5B+jMopKGT4rBFrjsvWvgVlKkTK8QhnF?=
 =?us-ascii?Q?vemYJvo3O/VWz838fJcJQo82hG51IF68IyIsw9a3E24jvbqvdLbcp86PV3jD?=
 =?us-ascii?Q?qIgtqWNO0cFMOtLVBqwkj2es5QJllF+5rn9WgZxZGWiF/Tmc56UH3Ta2Wc4q?=
 =?us-ascii?Q?Yyiv1e7K5ryRjOdpbQhpOXAs3XyEKyEvZyOK7WSUnbwjCmgYyDmZ0jEelkcR?=
 =?us-ascii?Q?YyrXsDAClxMGno9jmD4tASZWSqP2ylpxTjNY26bWDDXtgvMPE2TWDTFBUyT1?=
 =?us-ascii?Q?/cCYOG3fl3PXj0r8G/0PBC3Sk99sIo64Mq8r3kYxdo8FJYTILTvsuWG+3IAX?=
 =?us-ascii?Q?3I/WZJXydaXX0jAHfK77pAPT4u1eS9i43+qPFV9u5+OzlJI4K+QQ5Z3Qf55t?=
 =?us-ascii?Q?07FDGwSFACbHrHB9LOl7/wE2dcXiAJTUAAdoxAaYSGWHMWW5gsejzH0hFKZq?=
 =?us-ascii?Q?vBH7lgVfIbJR0GLBS2fP3B3qbrGo5vmQqZAC+F2duSNSfDob6xsrlBSh6L+K?=
 =?us-ascii?Q?gq+vzKOX4W2yFrT3Nz3/cAg6wytEzlYhUPxC0Aq+wb2eB1e0WP7QxKK33MRt?=
 =?us-ascii?Q?GPsn1SX7vW+R0qwgka+h8p4bgR60FL4afCNhX1CjTABr6Ns+w9GImsB6sW9w?=
 =?us-ascii?Q?V4oENGw8Gaeb0rRo110gHCYou5gIaClk+iczOnQJCfprKoPkZDFh/J7qMTfW?=
 =?us-ascii?Q?9GN1sazfELU4fORG2bBigwumWFxr5hDipRF2fsIb7h/imsZuB4Ag/hsMh4sJ?=
 =?us-ascii?Q?vYbeyNyq9FUwaL5TTMPSPLJ6ME7ZtsVATZwpjeeZK/sK88kb4J8Tt/+curul?=
 =?us-ascii?Q?lHSvqa9/LB9h6H6xam+sok8oNl2F0mi9KzES10BxpT8aeYskAeJdvGs6WWlB?=
 =?us-ascii?Q?x8aggKxEn/KpGZPUR/NqffWHi45OUNjZrrfQPfK2HZ2zAJUpy/eJPFc4hkyD?=
 =?us-ascii?Q?aMkX6dq5maxyF5dYg8OG5jslxTLsgYF097xIHf7XG4NdMI3XcLP9dz4jVuJo?=
 =?us-ascii?Q?xdTXhzATVuK/afK/U/jNW9v2Ghk6J/6NnCqiPsu8XwxbGUAa9qiZSRbUQJgn?=
 =?us-ascii?Q?u81ddF9mVdSvtc3JUaPgG1mxR/8gOGcMG6WxLgje0V9JrDRv3cmxMl8eoT+I?=
 =?us-ascii?Q?tjYWFufYLHi1p6S+N1UMunWqnH0zySmkdy0XiIj3iQoS189QWvAWyjj00+0O?=
 =?us-ascii?Q?2AjOtxozs5718hTLbkpczEcbqr1ZrQUTD3uCQyxbLm8bJ+2Kh+jYF2ccjX4g?=
 =?us-ascii?Q?gQ8ghmu+gGBd4ms38XQNvb0QPvt2XeDpDRZZxfJ00DZ5xkK9iWstRIbAodmt?=
 =?us-ascii?Q?PCCsjFJOqKCjTOUR0aKZrTdkzxllvgAdAnUav7gGPoaLM8mb4c1ijUpcib1W?=
 =?us-ascii?Q?rz4n/VjrWsXzNZrGTKIO5GVyu8IXSCvNdr9PE0T/KSwE9JK+s/kldE2ILjyS?=
 =?us-ascii?Q?kMuDkVkVCP+e2TOMeqfvXhwwr4woV2Zn7oxOxP2WPr0/MbLDYlO4weRITbj8?=
 =?us-ascii?Q?Uq0iqrhyWwMsh+R//zGocALLS4wpp7qHZxiJFEt/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3518ac3e-3c84-4310-4476-08dad4fc2054
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2022 07:00:56.5118
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LRbnWxfs1Wc4I+w1hg30zycEXRUIorim95sCr0GFMvuXSIVdo2byEbnpxUacgw6d8cCoyoxEIHhVZExtS+0zBv11e+Xt4UYxR61D586nTP4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6463
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Zhengchao Shao <shaozhengchao@huawei.com>
> Sent: Saturday, December 3, 2022 7:39 AM
> To: netdev@vger.kernel.org; Kumar, M Chetan
> <m.chetan.kumar@intel.com>; linuxwwan <linuxwwan@intel.com>;
> loic.poulain@linaro.org; ryazanov.s.a@gmail.com; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com
> Cc: johannes@sipsolutions.net; weiyongjun1@huawei.com;
> yuehaibing@huawei.com; shaozhengchao@huawei.com
> Subject: [PATCH] net: wwan: iosm: fix memory leak in ipc_mux_init()
>=20
> When failed to alloc ipc_mux->ul_adb.pp_qlt in ipc_mux_init(), ipc_mux is
> not released.
>=20
> Fixes: 1f52d7b62285 ("net: wwan: iosm: Enable M.2 7360 WWAN card
> support")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

Reviewed-by: M Chetan Kumar <m.chetan.kumar@intel.com>
