Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA4965A005F
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 19:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240139AbiHXR1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 13:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240127AbiHXR1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 13:27:32 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C596A7CA80
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 10:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661362051; x=1692898051;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=786SiailvwIk5+/U1l1j/RvPEO3s2xPdoLYh4X2vwzI=;
  b=nHmerXaYZSqs3CId0fUaXouE91QcSQHplBOOyR1Y1oQtl5usY4FV30we
   X4kb2YFmzzmwW7XPELwTDQoFMbCrUdZM0P/OJ/l68vMIn5M2Dj51IsFiH
   dJoq+C5gdxScAH5+xSqiwarBRUU1rwtkGrMljGbKJRbMkOrqidKnCwfoP
   15NeC6GT8XFs4s6YQzg60wPa79GfvOITqHCTgM8rFaljHfu6vxebevnE+
   dSE8FQ3jEsUF+O8e2Mv4+f1PB7bkrRrO+xhjKpn5Z6Rk8FSQpPn1jU380
   Ag4LhOlLZZfF64RewElEnPfNXNqBQcm/DV+DVaMd20eU+cBu6KjhTeBJT
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="295308781"
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="295308781"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 10:27:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="609843239"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 24 Aug 2022 10:27:30 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 24 Aug 2022 10:27:29 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 24 Aug 2022 10:27:29 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 24 Aug 2022 10:27:29 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 24 Aug 2022 10:27:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XL2t2ycuWHzisu9keYdIw0+WSvBKiyQf2aJUytLxuNHhW57UPfmedxRBFFyZmPt72t0t0JuhIFf/yV3P5MLKOJWpcKvXsVIcJLZzHdQxEY27vOwGYRUqjqtjvvY7duk99n8ul3/Q2MJxIK27bpoMU2BLez1/6z+LlUx7k76kX9xX3hsYMe8HKT9ZaFuiWVDZiUviE48IL3qHUiXr2A8CKeYvdUpXG6iFGIT0rNSAi6VxAH7wdu8h/GZ8MyS5fGlR60bIgumL7SfQl7rX06lqBdW+MbRbvy83saqXJxjL31Km1OcMpnNC5SiOr4527euS50EPO81c7jwq7BLrG82rAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=786SiailvwIk5+/U1l1j/RvPEO3s2xPdoLYh4X2vwzI=;
 b=ItSl6WA9JR2L8FZDvDER+n9P5jzk0c/GbymhAuzCcQVdllpSrViU41KV+iLeJKfuwI++17tbZw9iibVAWK584Oz0o2+XNwdxlEDgKIF/9K0J0+BhZnSco2gilPyOs/KVELV9BgoA9qwfuaRNHG34GkHbIwddFZ6L5t+tgBtjJipGOeHowm1DJanUJDFWISsTRoFxJ6TjQ7Q4qi+5Lj8YrvG/z5/fxBFxJuu+iH/oQi9AwdWl5B/Zcs1c0O6zAGawXDm6dDapnniVgTIQBo0g2GthMDyLZ/9cwQi9cbq3SZ8nCKC847nPfcTsviht/j603TFqcZa20fouz2zKkhJE8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM5PR11MB1564.namprd11.prod.outlook.com (2603:10b6:4:d::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.22; Wed, 24 Aug 2022 17:27:27 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5566.014; Wed, 24 Aug 2022
 17:27:27 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Dimitris Michailidis <dmichail@fungible.com>,
        "Yisen Zhuang" <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "Geetha sowjanya" <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Simon Horman" <simon.horman@corigine.com>,
        Shannon Nelson <snelson@pensando.io>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "Edward Cree" <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "Fei Qin" <fei.qin@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Yu Xiao <yu.xiao@corigine.com>,
        =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>, Yufeng Mo <moyufeng@huawei.com>,
        "Sixiang Chen" <sixiang.chen@corigine.com>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Sean Anderson <sean.anderson@seco.com>,
        "Erik Ekman" <erik@kryo.se>, Ido Schimmel <idosch@nvidia.com>,
        Jie Wang <wangjie125@huawei.com>,
        Moshe Tal <moshet@nvidia.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Marco Bonelli <marco@mebeim.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: RE: [PATCH net-next 1/2] ethtool: pass netlink extended ACK to
 .set_fecparam
Thread-Topic: [PATCH net-next 1/2] ethtool: pass netlink extended ACK to
 .set_fecparam
Thread-Index: AQHYtwG/7UShKp46CEeJGlUsxLt8NK29DT8AgAFCN1A=
Date:   Wed, 24 Aug 2022 17:27:27 +0000
Message-ID: <CO1PR11MB5089DA5D842420E418BD9EC0D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
        <20220823150438.3613327-2-jacob.e.keller@intel.com>
 <20220823151354.4becbfe7@kernel.org>
In-Reply-To: <20220823151354.4becbfe7@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95cbbf87-d291-469a-1cd2-08da85f5ea79
x-ms-traffictypediagnostic: DM5PR11MB1564:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Kb0M6zYLfXwl7CVjd7XGV9IIYMJbwtx3jNYMr/MbCIQtLiK/4Be8PlF0AH3FpeNmWTDZ6wf6rsnl9Kfb5AN1HRgPqxYgKGObqsANZf5en0XjOXEBM8GjaIZ7IFBP2ZmQRvHIK3DD6UJiis8jhiddza6rTbGvZfvyLx+EgxNNwjSzZ/EeVALhWj3miZmha4ywXOzyk2KfqWWgcEWnC12U/3pNSJGWJNEjbI5XKf6AqlHoHUMTA0cVt0DISSyvqsINz5OT5JJLo7x8lars0N18JHO2jAnftsFt4L878qZxTJx3RCw7Hkf+i/YQGsx+QtUyI+DLSDceYkpAIOaos/VeJaq1z3uxKPi6/G74lUGU3h9JgasklzfmtKDU8gw4/y0knnUOqBabBIdMedKBaT5CBzCR8wOlocCSnfJSxUmJEg7pGfZCAxQKWv+Y6QO5hi9fUrezN1+4g7mtR03IcMm00bT01ssOpFPrKtTBH/5MzeF2e+pdx+RgfRHdxRS3p0bIWnNuWKvhiDBR5YS8hs8Wu2PZAc0OHKJEg2xSDbQzMcrL0kW441zNTjnY6zk2Ik0V0nSZvXtZtL3WzEMsnTptJ/cdqcExR6U5fPs6n0vmddvRZybCBBF+9z4/FW1aaQwwjhU5984jbJo+ge0dngnVjo3NT0lhYz9SWOMYUEL7YcbMtdckxo3agw7vUDGNA3ggsC+7FcnbOX8iygSAEqzBa7+Oi2RrvW08HqWREnlHDT0XrrA2VwDgRLVc6GQTAZ+yP7orXtp2eImNYvPmdCWRYcfPo3Bi2Duj9ZM5J8mprDQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39860400002)(376002)(136003)(366004)(396003)(66556008)(54906003)(6916009)(55016003)(82960400001)(8676002)(66476007)(86362001)(66946007)(76116006)(52536014)(316002)(4326008)(38070700005)(66446008)(186003)(83380400001)(38100700002)(478600001)(71200400001)(9686003)(53546011)(6506007)(7696005)(26005)(33656002)(8936002)(7416002)(5660300002)(64756008)(122000001)(41300700001)(2906002)(7406005)(142923001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?b6HoCFGwnXVRP3IsbE7tcSjQur08qObgvLftCHHGHEDVs0nYilK11bSUVC?=
 =?iso-8859-1?Q?ALMav++QNauKIjN/g8S2JXY0S7S77QRwBlc9QnR/Wq5Z8Sb2iMOOXduN71?=
 =?iso-8859-1?Q?xuUU1qxJ3v9rRaqFhshjXw/ponqV9ZECQvlqSWtkHUR0CnBX8d1P/O6s9M?=
 =?iso-8859-1?Q?s2h2YGnoiEzSu6HDiS9NLup29NrLDGYhi4i9TjuB5Q2bovZubt6SYNr/NZ?=
 =?iso-8859-1?Q?aUe7qygi3T3QisO76MRsSFcmTS+Pni4bWTyAnFddIXml9d4FckUMKDLZoS?=
 =?iso-8859-1?Q?n5miiamojh/qi+1HGAu4mlInUfLZzcVph0ZzB0hr7UKbtZ7Lzw+uFxCb+i?=
 =?iso-8859-1?Q?6OXCPWPXh1Ge4Uik5WN+M85QpdfHx2uZ2M2nZWl4aJl1ybMIIYnbxEgxFM?=
 =?iso-8859-1?Q?3ri+vugn/cVm2YnWyaru/jY0KXRLRbqp4yNj6soqAs5820p9LM4Qjggx8u?=
 =?iso-8859-1?Q?A4q9gBWpQBCjT+IjdCWUiPpMTVgwBBBBmz5Q6z/TAVALUoPoe6vtyNcJqU?=
 =?iso-8859-1?Q?3wAexqCo6bpFYcy9wBiNaf69N1oz8nT5NjeXfdlufYv26+xwSl3tIyERzg?=
 =?iso-8859-1?Q?q6gOKebC95RmbUpQvrVKYOY0/Dy5rwq+reJ0SBDglS/tRBBTDT4r27/pZz?=
 =?iso-8859-1?Q?SS5eeCSTV23rk1k0ihKU5h6eYlyM+3jpyUQHnlTlQzHi3rjvSy7eWPUcCL?=
 =?iso-8859-1?Q?i5wWBlJFh3qIUBB9fZ8Yg+DgvcsAuNu1hPJ0R/D7EwKjccXvUFm5mFBZTF?=
 =?iso-8859-1?Q?GyHYS6ajXtsOUOPHVVT+mzCB+q871a4FoAposmxq94YNUnnPcaH+yYNwdR?=
 =?iso-8859-1?Q?A+WGfupnYQxCyqckbIMa+Ysr7G0tW+QM2/f6Lly8HF0LxUjNN3GXrnhAHt?=
 =?iso-8859-1?Q?R7b+0sS5/ySCaUN2bdKktB82QrxmH3PdmtdH/OgLBimoy188lDpCgLEmW+?=
 =?iso-8859-1?Q?8WiEZr544jYYlpuuJNptYjSX5TwhEy+4WhAjrNVEQbasWW/+KDsNxigZyh?=
 =?iso-8859-1?Q?0aRCeBADwRK4anGG4G/6tRyuaGHD3A1KD5isBYKo1hkd/NTOwzxwgLZzZh?=
 =?iso-8859-1?Q?N+xX1Ac+pibQBkSK24/U3/69LSOoKi2Ni2W9eI5/mfJ9Y6y3p7XivoIch+?=
 =?iso-8859-1?Q?K8MnaMF1L0Gk4n88vcXFCkigayh+azHRrBXOHvi4OongpzQonB2Rwf5Uyt?=
 =?iso-8859-1?Q?hokwE4xHWXLxOlx8MahiulPP04DwTnxEJVm4E0BzuqAlTmXM3T1an2DsNM?=
 =?iso-8859-1?Q?g+BBUuKE+ALuLZa3K9Dpa58tdgkmbOlLDwL1ibd6W3uE+hn+MNaR8NVhey?=
 =?iso-8859-1?Q?3J2FIRsFiOO20Kx0jShqsQHq3qoE019e769lATZ0yXeR4/CHgyapVXtEfV?=
 =?iso-8859-1?Q?I9EYA1njtOcr1EF1GMoLxLkdJOJY73lyyZ4Hnga6AUqg6kyjiEm8mJ44Y9?=
 =?iso-8859-1?Q?7Ns6UZeRJOGjL7z7Jfr/6Znqjs4DqX7Xgz+DCufwCReRbK2ttYbaCUfh5n?=
 =?iso-8859-1?Q?jJiCfOkzsSszl1LYZpkAETsVSdtANwM2KVqiztl0HDe3mNM2SYMaBiuFJ5?=
 =?iso-8859-1?Q?K1BRyzlbMHIHZgK9S6L5TQIwR41TVSeZgGt+weNvKMlrwc+951HiqE+uiC?=
 =?iso-8859-1?Q?OVv/+WL9iNmlQzqiiV5E2B4rBi1nHvA0Bp?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95cbbf87-d291-469a-1cd2-08da85f5ea79
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2022 17:27:27.3321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RJf1sLAwu6m66R8IQHYeP2+xMMFCwvBkxSW9FuFLhy6czARL742H7ljDefHtCsH5fECVZ0hGN7YlHaNsUROwvI/rsxNGknU9usGbGp0oMjk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1564
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, August 23, 2022 3:14 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Michael Chan <michael.chan@broadcom.com>; Eri=
c
> Dumazet <edumazet@google.com>; Paolo Abeni <pabeni@redhat.com>; Derek
> Chickles <dchickles@marvell.com>; Satanand Burla <sburla@marvell.com>; Fe=
lix
> Manlunas <fmanlunas@marvell.com>; Raju Rangoju <rajur@chelsio.com>;
> Dimitris Michailidis <dmichail@fungible.com>; Yisen Zhuang
> <yisen.zhuang@huawei.com>; Salil Mehta <salil.mehta@huawei.com>;
> Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; Sunil Goutham <sgoutham@marvell.com>;
> Geetha sowjanya <gakula@marvell.com>; Subbaraya Sundeep
> <sbhatta@marvell.com>; hariprasad <hkelam@marvell.com>; Taras Chornyi
> <tchornyi@marvell.com>; Saeed Mahameed <saeedm@nvidia.com>; Leon
> Romanovsky <leon@kernel.org>; Simon Horman
> <simon.horman@corigine.com>; Shannon Nelson <snelson@pensando.io>; Ariel
> Elior <aelior@marvell.com>; Manish Chopra <manishc@marvell.com>; Edward
> Cree <ecree.xilinx@gmail.com>; Martin Habets <habetsm.xilinx@gmail.com>; =
Fei
> Qin <fei.qin@corigine.com>; Louis Peens <louis.peens@corigine.com>; Yu Xi=
ao
> <yu.xiao@corigine.com>; Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.d=
e>;
> Yufeng Mo <moyufeng@huawei.com>; Sixiang Chen
> <sixiang.chen@corigine.com>; Yinjun Zhang <yinjun.zhang@corigine.com>; Ha=
o
> Chen <chenhao288@hisilicon.com>; Guangbin Huang
> <huangguangbin2@huawei.com>; Sean Anderson <sean.anderson@seco.com>;
> Erik Ekman <erik@kryo.se>; Ido Schimmel <idosch@nvidia.com>; Jie Wang
> <wangjie125@huawei.com>; Moshe Tal <moshet@nvidia.com>; Tonghao Zhang
> <xiangxia.m.yue@gmail.com>; Marco Bonelli <marco@mebeim.net>; Gustavo A.
> R. Silva <gustavoars@kernel.org>
> Subject: Re: [PATCH net-next 1/2] ethtool: pass netlink extended ACK to
> .set_fecparam
>=20
> On Tue, 23 Aug 2022 08:04:37 -0700 Jacob Keller wrote:
> > Add the netlink extended ACK structure pointer to the interface for
> > .set_fecparam. This allows reporting errors to the user appropriately w=
hen
> > using the netlink ethtool interface.
>=20
> Could you wrap it into a structure perhaps?
>=20
> Would be good if we didn't have to modify the signature of the callback
> next time we need to extend it (especially since struct ethtool_fecparam
> is ioctl uABI so we can't really add fields there).

Yea that makes sense.

Thanks,
Jake

