Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50AB65A1BD0
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 00:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240331AbiHYV75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243483AbiHYV7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:59:53 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9073F63F8
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 14:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661464792; x=1693000792;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZBEGMwhmXJTIWGquZF2/6p6xSQCG6SmhnUkhzC2alrI=;
  b=C7jcaSaDJ3nXGYA8to66yM1K5j9ibpqFhnP37dFcQmbQyN3u0s15a/YZ
   /wm20TspazMxP7UE5M8Y58YehzWTMyxzYaJojcFpK+IaZcFFMRmGNoor8
   TBjItRmFjvFrHjXzClV8HJ3mrm2j0RwRhGbZEwDYmT4HWeGco8wOrW4Cu
   Y/ejSahVdS2QSue3aMgL/iD0Rc1cFsNHJ7mc8d3AFbAgt2m9CgWRxc+Xy
   IIOp1uTeUQQA12aXD5/9QEAZegjirCmEhCkhi+ruOt9b6/8ev4CUOUG1N
   ivwQQgcUZZNj+Nznayf+GXtFskobIFvllH2vwW8o4ksgP03gGenhlli+U
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="274759027"
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="274759027"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 14:59:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="938506610"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 25 Aug 2022 14:59:51 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 25 Aug 2022 14:59:50 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 25 Aug 2022 14:59:50 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 25 Aug 2022 14:59:50 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 25 Aug 2022 14:59:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UZ5/VFs4CRfLEchC6mESMkKfR/dm++B8Io3LYwcmvGIJxoFuAelIPaU39JQXjreLebG0ekHqNHqd1gcAz8Q+WtGM/mIOZaCYGKMH6wURdDtB+KmSp4+H8w8okNmzkDdHQza2NQF0d9l/MJMain2hM2gAqujmLbaGQojckRiP1Bq9l1yZqpJsbpyLjyBVsy6tLk/4bp6g+G0UwCRa5NJZGXrEfxn1rozC360koErs7UqrL8kqtZQMkUmcZEViW3n3fxFk/yuTc2nyHviEO8/Ynel6qVHnbIR382hD6o8lQ08jUFcXmQEkSAnP+jf3uuq4oluR2S5xOCSDNck95duFMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZBEGMwhmXJTIWGquZF2/6p6xSQCG6SmhnUkhzC2alrI=;
 b=WeudzFy/oxKnvJawUk125OA/+2jx1I8EnvQQvsv5exoG5d/AjiZZxOlbv/FOv/7UeZI4uMDI+Cc4CxcaJ1D8IBaRqpwDOSjViDHrUxchRJnyN1KvsXENMfklZZGvTvOQbBWgte0etQxiKg7MOjYNAbRYeL5hMDprWzsFPRg9c1bEJ32Su5IGiVE2rELUkCkuQVJavrVIsBdyvD7Va3hPSCf+ujAL4JMl31k3dqY7u2lgQLXAZwv8BFQtl9UvheVx1pTkkq0ESoxotGcb6Ki7qB8RLEfbgLZy9G2ndAqZfvbvgHLpu7lxNeAQncd/J8n+r1jQJ/TZzss1x7n/Z2SJcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM6PR11MB4755.namprd11.prod.outlook.com (2603:10b6:5:2ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Thu, 25 Aug
 2022 21:59:47 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5566.014; Thu, 25 Aug 2022
 21:59:47 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Gal Pressman <gal@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "Cui, Dexuan" <decui@microsoft.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Siva Reddy Kallam" <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Bryan Whitehead" <bryan.whitehead@microchip.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "Alexandre Torgue" <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Thampi, Vivek" <vithampi@vmware.com>,
        "VMware PV-Drivers Reviewers" <pv-drivers@vmware.com>,
        Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "Eran Ben Elisha" <eranbe@nvidia.com>, Aya Levin <ayal@nvidia.com>,
        Cai Huoqing <cai.huoqing@linux.dev>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Lv Ruyi <lv.ruyi@zte.com.cn>, Arnd Bergmann <arnd@arndb.de>
Subject: RE: [net-next 09/14] ptp: mlx5: convert to .adjfine and
 adjust_by_scaled_ppm
Thread-Topic: [net-next 09/14] ptp: mlx5: convert to .adjfine and
 adjust_by_scaled_ppm
Thread-Index: AQHYs1HIz6nZDedOVUaNGQ7fPY6HPK28o/WAgAORUNA=
Date:   Thu, 25 Aug 2022 21:59:47 +0000
Message-ID: <CO1PR11MB5089A097B2A8EA3AF8BDFD45D6729@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220818222742.1070935-1-jacob.e.keller@intel.com>
 <20220818222742.1070935-10-jacob.e.keller@intel.com>
 <ae6132bc-7b7c-8f31-7854-8e451f57cdc7@nvidia.com>
In-Reply-To: <ae6132bc-7b7c-8f31-7854-8e451f57cdc7@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 558286da-ebb7-47e0-4972-08da86e5205a
x-ms-traffictypediagnostic: DM6PR11MB4755:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KOXpS9z2BH+hqZPISPysjBUjjxv6gr2yi0GNNMx3s0+dRF9b18LvGbnwVEFLSvSAz3g+TlG6VvhqvRjwLf6SZ+MTVYj+STCqeV7N8XF6NeETR1V5qAXJ9EiQlmqL5jG2Flk6g/OKvWLTuwNHAJZiDpGaKe9kjHsVmFCUfZwUSGtyPxPOQYORNvjjVckHSWZTby+g3jC+q9kUcr52+3pk1STbb1QRQ/LBlGS3fZ7nrpJY1cq3MtBu4n0Rvd3Pad8XH/cX4EaEPoX3uQgkLtEPRpxENJb3JtRqZ9y9vzv7RxwYHdSowHUitzLI/p57k5g++u8Ofl4xtir+haTlZ64+CepvZGch0SZH0JLA//2e6Mp/FsYU4/NEZlxFkit+jA4vTlQN3XKuDlkes89Wt6F0Kocb1jc+FiBisSdKOiXMu9nQD0onNOxRROC1XZZkf24SRJY6DCqJQFmpLCrHQTLST5P+8r8kxPQ8Rg02rCY8/aPudJ/0E7JlkgvAa2XTeVB1XBDzCs7pUIArit+UHfrps3g4EEOlsr4mi7+Dz559APc6kSpQn0JvpO5qGEG73QOm7uRNpRRLIkO95hKHgVv1LzvUv8hhxWw+uW0VE/3eaIXMFDpCKFtrni6qFOwAPpvSfJou7QrBHllMhpk7IEzpq81l0uX5Qo1ACJX9lxl8u7u4E6dQG1uFfqohCVdBQ5T4GiFGigj0/FQzbDeQpA+3gQ/ZK2xKvYZqD3K/I3iptETMNeVpEcONf5Cg+wENt6v/DNKjhMY2Yht3xCdrHmFfsXtG3m5qB7youlBWWGT/yeo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(39860400002)(136003)(376002)(346002)(38070700005)(122000001)(82960400001)(38100700002)(64756008)(66946007)(83380400001)(8936002)(186003)(66446008)(66476007)(5660300002)(66556008)(52536014)(4326008)(76116006)(8676002)(55016003)(7406005)(316002)(2906002)(7696005)(53546011)(6506007)(41300700001)(7416002)(9686003)(26005)(54906003)(110136005)(86362001)(71200400001)(33656002)(478600001)(142923001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZXZsclRsdWdqSno3bjNYbnhtSm1kZ3NuNjJkZmVlQnBGSnJZVDgxNDRQNE1B?=
 =?utf-8?B?amI3Tk1ocjlPQkhjNHNwL0VhNzFjNmZCWFVxbmFEaHpBbnBXZUpSazlWUW1Q?=
 =?utf-8?B?bVg4Wm1laFRaOU1XUUZVMTlrYTJZTk1mL1NiWlVoRXd1UjhlOWNYbnEwMGpL?=
 =?utf-8?B?VWxlK0Q4YTFEVVVmTXVGSHhOSktaeXQ4S0d5VENodDVQZnprcFZULzhvSnd6?=
 =?utf-8?B?T1Q3eWdYTjQ0VHRPVWJkRWZZS2hKRDBmMEtmWHRKNFk1NExIWVNic3FBRHJ0?=
 =?utf-8?B?MWY1aHpsb3lBMFRpZmJGZk5DVHAzTnBSN1huUlpJbzU2TzludjlFbVFETXk2?=
 =?utf-8?B?OEN0VzU0V2ZVWW0zU3BVVGtjSGVEMldnazlLcTNVRXJIcW5zOTdGLzFmTnNX?=
 =?utf-8?B?RktpelcyOS9xcmZmU1BmTUFzbGI5UzlyYkZmbVU2bXAwYXFIODEvRVNIdkYz?=
 =?utf-8?B?TzRBVmpJUnViYzdFbmZvaXRuV3JZVGlMVXNITVNkSDMwREZpc1BpRDVBMGZk?=
 =?utf-8?B?Y3Qya2xnMnNYVk9iYTlZbUlpNnBscmRQY1RpVENRT0VweGhlZ3FDMU5YcU51?=
 =?utf-8?B?amY0dXh2ckt6RzJFQ0loeGFPeFdMQ09rRE54ajd0c0FrOXIzdEs1UlE2N2c0?=
 =?utf-8?B?aFd2aDlBbTRhNVpGV21JMFRiaVg0cFk4MStDY01jVjJNQXltL0pMUUxDVkNZ?=
 =?utf-8?B?MVZIWEJXU2libHBHbjgwVW9Cai9qUGxiTG56bmc4SUxGaEc0b01UMm1KWlFF?=
 =?utf-8?B?azZMcWxscVFBT0txVWFJN05tSDJDRWFQUk91dHFrOHhhZ3huRTZ4cjlIYllp?=
 =?utf-8?B?ckxJeDlBUzBITENXQWkrR1hvOUFpZ296TFFtM0tiQlFmcmhJcXF5NllhZWhx?=
 =?utf-8?B?cGtRU3RoNkNRcjhraWFETHM2cXd2Ym5SSnRoaG5PYUoyV1piYXlqckh4ZmtG?=
 =?utf-8?B?aG5OVHFHUEtyUVlrVFpxNitLR1hBOHl0NVh2Uk9mdEdjcWQvK3pyWmU0UjFN?=
 =?utf-8?B?bDFlVkMvd2x1ZXJVbVVZVTEybS9JcjBSRVYyRm9zMU1ham1zUDJZaDBSM2lw?=
 =?utf-8?B?UFVTQXlXNnREMC95QlJrZFlqVkpHak9EV3kyTjV2anM4NStaTFVIZ0Y0M0kx?=
 =?utf-8?B?UE8rbTgyV0Y5RWc4ejBmWDBNTlFoQWFVdUdVR0ZidS9CKzJ4ejBSeVhUOHlP?=
 =?utf-8?B?cFg3eWlsZU1CUTY3ZVJZMmxiNkU2Y1p3ZEJWaS9vUmJ0U1ZkWm5uWDZHMTV4?=
 =?utf-8?B?b3VlVmY5YWRNZTZ6d2sxekkxdk0xSDVhMmM3bDhxVWxSSWJHSnZOa3JYR0hu?=
 =?utf-8?B?OWhCZ01LVGVvcm0yRGFyT0c0TlRmQmZsb1ZjaExtYmdSdVh1dHVqT0JiT3Vl?=
 =?utf-8?B?SnJOaDMxUTdMVXI4L29xdzNjbkdjVEd5c1JRbDFsTURxNlZIUTNsS1EwM2Vh?=
 =?utf-8?B?blFVOW9rTXVDeENhT20yMkNWWmlLL2drRWJXSTh2dFBjbXlxM0E0U1dlWDFK?=
 =?utf-8?B?ZlIydHNCRi9ieTJPc2gwWnhmS1B1MFdxRkIwNnJRby9qdkg3SjNGa3B2dEUz?=
 =?utf-8?B?eXlwY0VyYmRZTWZ6bXNzOWI3cmcyWU0vSXRqbmVPR2RqMTU2dk8xYVdoOE9t?=
 =?utf-8?B?Rjg3WjlFdDR1TEk2YU1acm12NGxSOXIyd29XTjl6KzF2aHB2SVVJdEVYR0pq?=
 =?utf-8?B?Z2JLNDFZTWRCYVhxTW5raWJyd0pISUZYR3pDSm5Ec2lsZWF6Q3p2Ry90dEor?=
 =?utf-8?B?bHdHNzFHK005VmFCK3JHZXdIUFQzRTU2cE45OFd4dTFMenZZM1ZYdHpSUkNW?=
 =?utf-8?B?My9jQXR6dVE0WFl4ZERqRXFCNW1YRmdid1BkK0ZqWHlncERGWDV3WjkvbjZx?=
 =?utf-8?B?MlFxUW44d0dTWGdrM0thcEYxdm5RVm9tcjArbkdWRU4yVi94cmg1Z1FUbFNi?=
 =?utf-8?B?QUk4Z3hWV0pPc0hpaFA3aFRXUFE5Lzk5TE1waUJtY2NKVHY5MFB5RGtwNXFK?=
 =?utf-8?B?UzB2YXJTMkZrZFh3cWdLR3A4YkpMUTVybmQ2U1lvYXpYeDcyQ053MXNPeGVl?=
 =?utf-8?B?cjN3eDlHdU1QazNpU3c3VVh4WTlxQm9kaHVIcWVaei92UUZnaVg4SisrWHAr?=
 =?utf-8?Q?0i2HHNGvONiVciQY+dgan2C9Y?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 558286da-ebb7-47e0-4972-08da86e5205a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2022 21:59:47.4454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TLrGx3joaK8w2cxtdsHcJ96RuNMckapJX5OaoP2txlkXVuZEVdHJyIPGFWB/rSS1cRkBO8Og2EhjTYlcRx2clzcCtg7yiRVHhr1PSvlQIIg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4755
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogR2FsIFByZXNzbWFuIDxn
YWxAbnZpZGlhLmNvbT4NCj4gU2VudDogVHVlc2RheSwgQXVndXN0IDIzLCAyMDIyIDg6MzEgQU0N
Cj4gVG86IEtlbGxlciwgSmFjb2IgRSA8amFjb2IuZS5rZWxsZXJAaW50ZWwuY29tPjsgbmV0ZGV2
QHZnZXIua2VybmVsLm9yZw0KPiBDYzogSy4gWS4gU3Jpbml2YXNhbiA8a3lzQG1pY3Jvc29mdC5j
b20+OyBIYWl5YW5nIFpoYW5nDQo+IDxoYWl5YW5nekBtaWNyb3NvZnQuY29tPjsgU3RlcGhlbiBI
ZW1taW5nZXIgPHN0aGVtbWluQG1pY3Jvc29mdC5jb20+Ow0KPiBXZWkgTGl1IDx3ZWkubGl1QGtl
cm5lbC5vcmc+OyBDdWksIERleHVhbiA8ZGVjdWlAbWljcm9zb2Z0LmNvbT47IFRvbQ0KPiBMZW5k
YWNreSA8dGhvbWFzLmxlbmRhY2t5QGFtZC5jb20+OyBTaHlhbSBTdW5kYXIgUyBLIDxTaHlhbS1z
dW5kYXIuUy0NCj4ga0BhbWQuY29tPjsgRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQu
bmV0PjsgRXJpYyBEdW1hemV0DQo+IDxlZHVtYXpldEBnb29nbGUuY29tPjsgSmFrdWIgS2ljaW5z
a2kgPGt1YmFAa2VybmVsLm9yZz47IFBhb2xvIEFiZW5pDQo+IDxwYWJlbmlAcmVkaGF0LmNvbT47
IFNpdmEgUmVkZHkgS2FsbGFtIDxzaXZhLmthbGxhbUBicm9hZGNvbS5jb20+Ow0KPiBQcmFzaGFu
dCBTcmVlZGhhcmFuIDxwcmFzaGFudEBicm9hZGNvbS5jb20+OyBNaWNoYWVsIENoYW4NCj4gPG1j
aGFuQGJyb2FkY29tLmNvbT47IFlpc2VuIFpodWFuZyA8eWlzZW4uemh1YW5nQGh1YXdlaS5jb20+
OyBTYWxpbA0KPiBNZWh0YSA8c2FsaWwubWVodGFAaHVhd2VpLmNvbT47IEJyYW5kZWJ1cmcsIEpl
c3NlDQo+IDxqZXNzZS5icmFuZGVidXJnQGludGVsLmNvbT47IE5ndXllbiwgQW50aG9ueSBMDQo+
IDxhbnRob255Lmwubmd1eWVuQGludGVsLmNvbT47IFRhcmlxIFRvdWthbiA8dGFyaXF0QG52aWRp
YS5jb20+OyBTYWVlZA0KPiBNYWhhbWVlZCA8c2FlZWRtQG52aWRpYS5jb20+OyBMZW9uIFJvbWFu
b3Zza3kgPGxlb25Aa2VybmVsLm9yZz47DQo+IEJyeWFuIFdoaXRlaGVhZCA8YnJ5YW4ud2hpdGVo
ZWFkQG1pY3JvY2hpcC5jb20+OyBTZXJnZXkgU2h0eWx5b3YNCj4gPHMuc2h0eWx5b3ZAb21wLnJ1
PjsgR2l1c2VwcGUgQ2F2YWxsYXJvIDxwZXBwZS5jYXZhbGxhcm9Ac3QuY29tPjsNCj4gQWxleGFu
ZHJlIFRvcmd1ZSA8YWxleGFuZHJlLnRvcmd1ZUBmb3NzLnN0LmNvbT47IEpvc2UgQWJyZXUNCj4g
PGpvYWJyZXVAc3lub3BzeXMuY29tPjsgTWF4aW1lIENvcXVlbGluIDxtY29xdWVsaW4uc3RtMzJA
Z21haWwuY29tPjsNCj4gUmljaGFyZCBDb2NocmFuIDxyaWNoYXJkY29jaHJhbkBnbWFpbC5jb20+
OyBUaGFtcGksIFZpdmVrDQo+IDx2aXRoYW1waUB2bXdhcmUuY29tPjsgVk13YXJlIFBWLURyaXZl
cnMgUmV2aWV3ZXJzIDxwdi0NCj4gZHJpdmVyc0B2bXdhcmUuY29tPjsgSmllIFdhbmcgPHdhbmdq
aWUxMjVAaHVhd2VpLmNvbT47IEd1YW5nYmluIEh1YW5nDQo+IDxodWFuZ2d1YW5nYmluMkBodWF3
ZWkuY29tPjsgRXJhbiBCZW4gRWxpc2hhIDxlcmFuYmVAbnZpZGlhLmNvbT47IEF5YQ0KPiBMZXZp
biA8YXlhbEBudmlkaWEuY29tPjsgQ2FpIEh1b3FpbmcgPGNhaS5odW9xaW5nQGxpbnV4LmRldj47
IEJpanUgRGFzDQo+IDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT47IExhZCBQcmFiaGFrYXIg
PHByYWJoYWthci5tYWhhZGV2LQ0KPiBsYWQucmpAYnAucmVuZXNhcy5jb20+OyBQaGlsIEVkd29y
dGh5IDxwaGlsLmVkd29ydGh5QHJlbmVzYXMuY29tPjsgSmlhc2hlbmcNCj4gSmlhbmcgPGppYXNo
ZW5nQGlzY2FzLmFjLmNuPjsgR3VzdGF2byBBLiBSLiBTaWx2YSA8Z3VzdGF2b2Fyc0BrZXJuZWwu
b3JnPjsgTGludXMNCj4gV2FsbGVpaiA8bGludXMud2FsbGVpakBsaW5hcm8ub3JnPjsgV2FuIEpp
YWJpbmcgPHdhbmppYWJpbmdAdml2by5jb20+OyBMdiBSdXlpDQo+IDxsdi5ydXlpQHp0ZS5jb20u
Y24+OyBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KPiBTdWJqZWN0OiBSZTogW25ldC1u
ZXh0IDA5LzE0XSBwdHA6IG1seDU6IGNvbnZlcnQgdG8gLmFkamZpbmUgYW5kDQo+IGFkanVzdF9i
eV9zY2FsZWRfcHBtDQo+IA0KPiBPbiAxOS8wOC8yMDIyIDAxOjI3LCBKYWNvYiBLZWxsZXIgd3Jv
dGU6DQo+ID4gVGhlIG1seDUgaW1wbGVtZW50YXRpb24gb2YgLmFkamZyZXEgaXMgaW1wbGVtZW50
ZWQgaW4gdGVybXMgb2YgYQ0KPiA+IHN0cmFpZ2h0IGZvcndhcmQgImJhc2UgKiBwcGIgLyAxIGJp
bGxpb24iIGNhbGN1bGF0aW9uLg0KPiA+DQo+ID4gQ29udmVydCB0aGlzIHRvIHRoZSAuYWRqZmlu
ZSBpbnRlcmZhY2UgYW5kIHVzZSBhZGp1c3RfYnlfc2NhbGVkX3BwbSBmb3IgdGhlDQo+ID4gY2Fs
Y3VsYXRpb24gIG9mIHRoZSBuZXcgbXVsdCB2YWx1ZS4NCj4gPg0KPiA+IE5vdGUgdGhhdCB0aGUg
bWx4NV9wdHBfYWRqZnJlcV9yZWFsX3RpbWUgZnVuY3Rpb24gZXhwZWN0cyBpbnB1dCBpbiB0ZXJt
cyBvZg0KPiA+IHBwYiwgc28gdXNlIHRoZSBzY2FsZWRfcHBtX3RvX3BwYiB0byBjb252ZXJ0IGJl
Zm9yZSBwYXNzaW5nIHRvIHRoaXMNCj4gPiBmdW5jdGlvbi4NCj4gPg0KPiA+IFNpZ25lZC1vZmYt
Ynk6IEphY29iIEtlbGxlciA8amFjb2IuZS5rZWxsZXJAaW50ZWwuY29tPg0KPiA+IENjOiBTYWVl
ZCBNYWhhbWVlZCA8c2FlZWRtQG52aWRpYS5jb20+DQo+ID4gQ2M6IExlb24gUm9tYW5vdnNreSA8
bGVvbkBrZXJuZWwub3JnPg0KPiA+IENjOiBBeWEgTGV2aW4gPGF5YWxAbnZpZGlhLmNvbT4NCj4g
PiAtLS0NCj4gPg0KPiA+IEkgZG8gbm90IGhhdmUgdGhpcyBoYXJkd2FyZSwgYW5kIGhhdmUgb25s
eSBjb21waWxlIHRlc3RlZCB0aGUgY2hhbmdlLg0KPiA+DQo+ID4gIC4uLi9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvbGliL2Nsb2NrLmMgICB8IDIyICsrKysrLS0tLS0tLS0tLS0tLS0NCj4g
PiAgMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMTYgZGVsZXRpb25zKC0pDQo+ID4N
Cj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2xpYi9jbG9jay5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2xpYi9jbG9jay5jDQo+ID4gaW5kZXggOTFlODA2YzFhYTIxLi4zNDg3MWFiNjU5ZDkgMTAwNjQ0
DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2xpYi9j
bG9jay5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2xpYi9jbG9jay5jDQo+ID4gQEAgLTMzMCwzNSArMzMwLDI1IEBAIHN0YXRpYyBpbnQgbWx4NV9w
dHBfYWRqZnJlcV9yZWFsX3RpbWUoc3RydWN0DQo+IG1seDVfY29yZV9kZXYgKm1kZXYsIHMzMiBm
cmVxKQ0KPiA+ICAJcmV0dXJuIG1seDVfc2V0X210dXRjKG1kZXYsIGluLCBzaXplb2YoaW4pKTsN
Cj4gPiAgfQ0KPiA+DQo+ID4gLXN0YXRpYyBpbnQgbWx4NV9wdHBfYWRqZnJlcShzdHJ1Y3QgcHRw
X2Nsb2NrX2luZm8gKnB0cCwgczMyIGRlbHRhKQ0KPiA+ICtzdGF0aWMgaW50IG1seDVfcHRwX2Fk
amZpbmUoc3RydWN0IHB0cF9jbG9ja19pbmZvICpwdHAsIGxvbmcgZGVsdGEpDQo+IA0KPiBTbWFs
bCBuaXQsIHBsZWFzZSByZW5hbWUgZGVsdGEgdG8gc2NhbGVkX3BwbS4NCj4gSSdsbCB0cnkgdG8g
Z2V0IHRoaXMgdGVzdGVkIGluIG91ciByZWdyZXNzaW9uIHNvb24uDQoNCldpbGwgZml4IHRoYXQg
aW4gdjIuIFRoYW5rcyBmb3IgdGVzdGluZyENCg==
