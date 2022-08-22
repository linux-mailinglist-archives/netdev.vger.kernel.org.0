Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F82259CA8C
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 23:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237728AbiHVVMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 17:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237048AbiHVVMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 17:12:03 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B1B2FFC9
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 14:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661202721; x=1692738721;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SCJrvSjpSl9Wi9K/tvGZ0NM1p9JqlMlqAHriOiGSAtQ=;
  b=jkE1YH6pMdSNZ2/5Go//O+ZqCnw22eJPeHJh54x6pCmSZONvSOL6ZyGj
   8SHOR37BBDgwy3J5vENQJ0xJXd0O9DLdRAcEUN7yaGGzlhVAVVV1MZtF+
   cFIvQAUnwTD1nMFWPo2ph7eiXYjryCPq6ZIwVZ5rQ/puqx5h1C82nRE25
   LTAbOHuJ+l4Qr8Ui+4yEjIJQUSzKL//YtC3CFK1wtP1OBtjCODA5aIi4A
   AbPEJJ0KdsIUqcku5npzzQSydMggRJAYaXf6bDVSoBgnG4Or0ND+GBv8D
   Nh+nQJVa8PjbK2djoDWo8TUo6s1w49gBjDAd0+EFP3TX/8ay21JJaUqBM
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="355251694"
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="355251694"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 14:12:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="785000780"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 22 Aug 2022 14:12:01 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 22 Aug 2022 14:12:00 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 22 Aug 2022 14:12:00 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 22 Aug 2022 14:12:00 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 22 Aug 2022 14:12:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J6nmVrUGsQdhXJ8e9VXJMGKANqG+jMuXLt1flKCdhybAeqIgFCaAPUn/E4p4VG4ZKPnVCJRs9wdAoeUGpMWI7Xm3J8fX1XgdSPUASHLsdKAPz2Oi/87AfPOcHb/DGSG/AborRjKgLpYbb/De2JrpL54xH54/iTnvqTnHQGtXiPxl8CLXuUeAvjHbiaaO3B5P0uhoMkjp4Jhb02e7He4yiR1xoG55trny5kE2/guXExS7LB5jvoxEJ8F2xh2u7pe26Fju0fe0GH1JMEVPv60o2nNo5Z+YXcOGH6bT2hZ9C2RmFmgjYhjrNvwBZNvf0z57TfqV2NILICZgWsKibrtCpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SCJrvSjpSl9Wi9K/tvGZ0NM1p9JqlMlqAHriOiGSAtQ=;
 b=UdYbi9tEd8jH/6u4HCmCoXgZftTKQAw8B97vtdd0UeJJVmMOg9DZZl2BzAJTkoIXBMPkb7J6zcpaRKTAu4GERWIEJoyrak1Vvt5Pix7dVMSqFFEc0o9zEtbi9AaYzrrU5V2qaOl5cyeXil6S3LlzoFl/aDuHQBuZnNcZke/QYRFDAvEds6WIYl8BX73DvFf2rqY6eqORwbvy4UQGTPC7JzT+xwhaON37ag/Su1fuHYx2urqDHzJYgqoNDduuqDtMXZICcHJc7PWhGJea+5Xs6wHyBfsrU4VKGkl3XJKJird+hknOmk7FavkyE4AMHUXuE5LTv8jVWj0NuTRxBz5SDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BN6PR11MB1523.namprd11.prod.outlook.com (2603:10b6:405:10::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Mon, 22 Aug
 2022 21:11:57 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5546.023; Mon, 22 Aug 2022
 21:11:57 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "Cui, Dexuan" <decui@microsoft.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        "Prashant Sreedharan" <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "Yisen Zhuang" <yisen.zhuang@huawei.com>,
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
Subject: RE: [net-next 14/14] ptp: xgbe: convert to .adjfine and
 adjust_by_scaled_ppm
Thread-Topic: [net-next 14/14] ptp: xgbe: convert to .adjfine and
 adjust_by_scaled_ppm
Thread-Index: AQHYs1HOeQaM9U14QEafBLHzwebIaK22ZFiAgABSk6CABLNYAIAABo2g
Date:   Mon, 22 Aug 2022 21:11:57 +0000
Message-ID: <CO1PR11MB50896C5C236B09D53557AD8BD6719@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220818222742.1070935-1-jacob.e.keller@intel.com>
 <20220818222742.1070935-15-jacob.e.keller@intel.com>
 <334dc732-5a94-678f-56e8-df2fa9ee1035@amd.com>
 <CO1PR11MB5089E76BE2538C85827C0386D66C9@CO1PR11MB5089.namprd11.prod.outlook.com>
 <bef7f3e7-3383-8ef0-73b4-156e1bc57d94@amd.com>
In-Reply-To: <bef7f3e7-3383-8ef0-73b4-156e1bc57d94@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e4c87ba-6579-4555-dcf5-08da8482f273
x-ms-traffictypediagnostic: BN6PR11MB1523:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mF8yFN9tEjVHQcSkCuQjLJgE9p1ARsjsaHQ+QNeZONyxj4TeHFS0LNZxL5XdWsRGW6PB/YP/mR2Ho5PShXnJAd1BiJaVSw+fcIWVzP+pxHUMVS9/KS35RmHpl93yB548ygfSQYI6JyUIpm1gqx7i8DYFqTQkVP2E303nHFMA8PfOHcaCc+Eutft9fqG+j4lYpJzy25E2pDkc3Dz0PZREg5N3BAhliiIpDr1tfOeOUo/3ej1U8WyTxEtGkr1l7KJE5rbZKjf1Pd6AVSYv1hKzopFbetJMqn5tYxkznakOV5fp6kHGtxmZ1KZHHUc1Ubm7TGI01i92eTSoT8RtJKe66hqZeo3E9BbfUxOxxZ5OR9N+HJTKYUm2HpmV6vK9URax3g1rnDhGFwHKLEzSGRqQFz7iDswowlmKbLy4n/Bu9OHmiN8lj/d2dCwVxJ/ActNYJDaZbPisaAfVYfAHpgmcTvWThYxudIrjYEuLg5NuSiBU34H6R30HTIKI18FhBHyXb7nNPfO8qGILoVkSgclxJzx3S/kv8Gbf2HOaYAAj344ORoit7CpGNELFBOjVlobm2u/2hSxCy/xEO9G0fSd1j78haLEh2GFb65mq1Bu0fvADo4dWA9mHlTk8pAHWa0Gb6AVWtn5lHKggjL/Dqij1u/2tAg7jWnkApcypNbuFpYWV3fgo/2YsfhkPPO2tBIjsLrN6Ir72LnrJEG8d6v9F0KuFeiqMEH7ycjbYLa7fPVS3utmSz7kospP0sgIB0CIgxfq1DbwAY4dW1CcondLV4r2E8ArGnB1rlxXBawgiuGA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(396003)(136003)(346002)(366004)(8676002)(64756008)(66476007)(66556008)(66446008)(66946007)(76116006)(4326008)(122000001)(38070700005)(38100700002)(86362001)(82960400001)(5660300002)(52536014)(8936002)(2906002)(7406005)(7416002)(7696005)(53546011)(6506007)(41300700001)(9686003)(26005)(55016003)(478600001)(71200400001)(316002)(83380400001)(186003)(110136005)(54906003)(33656002)(142923001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SXlFaTRKNEdyTEJxblhLQUpSZWlNaWRHb0R0WmM5SzdBZkRXYWptSmhHUmQx?=
 =?utf-8?B?alZ0eEMxR2NNQnhXNGxzWlkxYVd0YmdBZittWXRNcHlyVXVuTDZSWXVKeHRB?=
 =?utf-8?B?SGxiUTdpRFpiZjR5RFVPcVdDck1LVWFMSjduZXNGRDV4bFRsTmhOdHVLeGlH?=
 =?utf-8?B?b2x2V29lVHhUNmFaZDhBRFd2bE9wdlNtdTl0L0FEVzJtRzJ6b3p3eVFGdklF?=
 =?utf-8?B?S3VyNWxYS1pZTkpjejllYWU5bG9vMVF1V25RbitQbEpaSFNkYmZWSE1nSUN2?=
 =?utf-8?B?OXRHc2Rzbk03N3d1Y2Fhd1VCWHFYb2svOGkrUDZWU3NZSytiUFIxRVphTkNj?=
 =?utf-8?B?bm9ZUzNTSHdwbHI2eThBK2ZCYU40bkhIc0srOE1xLzgyWVJKUDd2bENpRURK?=
 =?utf-8?B?bUZOajBRWW1IWGE3cUxsVk45U05ManBmdXpkQTc3SG5YYXJNcFZtOWxNdVZw?=
 =?utf-8?B?cnNnMGt0SDBQZXY0ZXpYT29SMG1rd2RuR3l1U2xQdUFVNGZtVDFoU3ZORHdT?=
 =?utf-8?B?RUVGUmR0Zno1WFE5VzZ5dGNEUXRGQUNSVnRya1NOWDZvMkhKMERibGU3WU5k?=
 =?utf-8?B?NjlxUnJUYk9rUDN2dzZtZWZETUg3Yy9kcU9Bem9IU2xQaXNKekVzZmhhSHRm?=
 =?utf-8?B?L1NjbUFUa3gzcW1XMllFWDlmOUdOcVFhcWF1L1VvOUViV0lGL3hzSWdXdGVZ?=
 =?utf-8?B?bkVySkhyakhBcGtGUHFRVVlFOUFXZm1xcE9GNXFEUTcyeUJCY3NqdlNpK21B?=
 =?utf-8?B?aWRkZ2pVSWxrVG5qYWkxWERBT0NFc3p4SlROWXUwSEt1aTNwak1TU1VTcTM5?=
 =?utf-8?B?VEp4cm9HdXNwUkNWbjdDMitxQi94MlplVFUvSHhoMkNKSnMyUUdmc3dGeFc0?=
 =?utf-8?B?WFRXRk5USWVmUXhTMjdxVUdMN1JTaE9wYTUyL2ZjaUEwblVSTDhkSjNCM010?=
 =?utf-8?B?ajZ5bVhQMk8rV3l1Qy9MM2YxRUNUYmU0ZDh2Z3VleEYwTU1Jd3BqVXA5M3Bl?=
 =?utf-8?B?K0JDYlNWKzB0SWsrY0MraGNXRlZCWHZJYTJRSi8zTm5wdmp6M252ZFk4eDc1?=
 =?utf-8?B?dXIzRUJqQ2NVV0xqb21FS0JzYnNpUmp1S214YStSYU1TYmVLUXZXME9jWUFQ?=
 =?utf-8?B?bVE2QUM0MVd0Yytad285clE3N0pmWVp5eXJSZzhzQ095Q2RYNWdNb3prUHRa?=
 =?utf-8?B?TkdVR0NFb0RQd2grcUNNQkY5V3d5a2NPYkF6UzlSVy9NTWFEUVZWYWx1YjZU?=
 =?utf-8?B?UVA1RFRsTTRmTTVNV2JYWDBPbXZMYytkRkxHNDZ4NWU0Yy9KN3h0YnczUXNi?=
 =?utf-8?B?akc1dEZCRGpKMFV0ODBuV05EVDJoQnFsOGhwS2tqR0J1YkFtc1NMQ3F3UFN5?=
 =?utf-8?B?VVZXRFd1MVlyc1lCbjFqYVNiVFROTFZyVXo0YTk2TEZnbzNqcWRia1pIcHhI?=
 =?utf-8?B?cktrM0N3NjJ3SlpkWUV1U2RNR0NaRGJMSWQwRVhna1p5MnlwRDJMaE5KUzBw?=
 =?utf-8?B?U0hudCtsRytFdXcxdDF0aWJYM0c4MVdyUVpRc2pCOWpRUFQvWWl4V21FNUJr?=
 =?utf-8?B?aFBGejdNa2pucDRKUmV0RGUxei8vbE9WbDZ0YzFwdDZVT3JkNlhXUkR2ejJH?=
 =?utf-8?B?bk55YllOSFd4YWIzbjJYR2JKNllsbjFSSVM2M0VtWDFWZ25hYkVUTFlQdHZk?=
 =?utf-8?B?TzBCTDJIOHoxRE56TW15MlQ3QWt0TlhKeTFPazd0aU5NKzIyTnhRTGc4K3I4?=
 =?utf-8?B?cXJSMFc3SlRka3VTMGRjdDE2OHF1cE11OGJjTFRmek1vTGg4WUZ5blNzUjdo?=
 =?utf-8?B?Rlp4K3UzU3BZZmFSRThwS2Ewb1FQYXJpQXU4UGtiMmNQNXFCckRjaHIwcW5w?=
 =?utf-8?B?NVZuT0g0U25XSFBhdmZqTUdEQnlTSEszakpKWDFObXc5YnU0M3U4OFNCMTdo?=
 =?utf-8?B?N0lMazRLNlVGWjhESWNER2l0b09YRDkrcjlBWmtBUjBVMmFMd3ZhK0hxUVZr?=
 =?utf-8?B?UzMyK2VqZ3o0QkRNVmViUG9GQ0grbTRoSTNnTEMrRGthaGFvcG9NbmUrQ3BN?=
 =?utf-8?B?UXd3aXFCcmhkRWFuZS93VkJ0STY0NFJNQTZKWWdKL2VXdEpDSEF4WUcvT1p2?=
 =?utf-8?Q?BuBpnn/ZxOkzom79UAI8D+654?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e4c87ba-6579-4555-dcf5-08da8482f273
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2022 21:11:57.4328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YNJ5wZUQGYcO3kZp5GLPZIFeB5R8u8h0CoaITrLPUjilacVzXfmmCTy4Y8sQ06pDq1MovIAJmhAIc3BjCj6Z6Rm9xLjMNSjfpG/b3dsBws4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1523
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVG9tIExlbmRhY2t5IDx0
aG9tYXMubGVuZGFja3lAYW1kLmNvbT4NCj4gU2VudDogTW9uZGF5LCBBdWd1c3QgMjIsIDIwMjIg
MTo0OCBQTQ0KPiBUbzogS2VsbGVyLCBKYWNvYiBFIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5jb20+
OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBLLiBZLiBTcmluaXZhc2FuIDxreXNAbWlj
cm9zb2Z0LmNvbT47IEhhaXlhbmcgWmhhbmcNCj4gPGhhaXlhbmd6QG1pY3Jvc29mdC5jb20+OyBT
dGVwaGVuIEhlbW1pbmdlciA8c3RoZW1taW5AbWljcm9zb2Z0LmNvbT47DQo+IFdlaSBMaXUgPHdl
aS5saXVAa2VybmVsLm9yZz47IEN1aSwgRGV4dWFuIDxkZWN1aUBtaWNyb3NvZnQuY29tPjsgU2h5
YW0NCj4gU3VuZGFyIFMgSyA8U2h5YW0tc3VuZGFyLlMta0BhbWQuY29tPjsgRGF2aWQgUy4gTWls
bGVyDQo+IDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgRXJpYyBEdW1hemV0IDxlZHVtYXpldEBnb29n
bGUuY29tPjsgSmFrdWIgS2ljaW5za2kNCj4gPGt1YmFAa2VybmVsLm9yZz47IFBhb2xvIEFiZW5p
IDxwYWJlbmlAcmVkaGF0LmNvbT47IFNpdmEgUmVkZHkgS2FsbGFtDQo+IDxzaXZhLmthbGxhbUBi
cm9hZGNvbS5jb20+OyBQcmFzaGFudCBTcmVlZGhhcmFuDQo+IDxwcmFzaGFudEBicm9hZGNvbS5j
b20+OyBNaWNoYWVsIENoYW4gPG1jaGFuQGJyb2FkY29tLmNvbT47IFlpc2VuDQo+IFpodWFuZyA8
eWlzZW4uemh1YW5nQGh1YXdlaS5jb20+OyBTYWxpbCBNZWh0YSA8c2FsaWwubWVodGFAaHVhd2Vp
LmNvbT47DQo+IEJyYW5kZWJ1cmcsIEplc3NlIDxqZXNzZS5icmFuZGVidXJnQGludGVsLmNvbT47
IE5ndXllbiwgQW50aG9ueSBMDQo+IDxhbnRob255Lmwubmd1eWVuQGludGVsLmNvbT47IFRhcmlx
IFRvdWthbiA8dGFyaXF0QG52aWRpYS5jb20+OyBTYWVlZA0KPiBNYWhhbWVlZCA8c2FlZWRtQG52
aWRpYS5jb20+OyBMZW9uIFJvbWFub3Zza3kgPGxlb25Aa2VybmVsLm9yZz47DQo+IEJyeWFuIFdo
aXRlaGVhZCA8YnJ5YW4ud2hpdGVoZWFkQG1pY3JvY2hpcC5jb20+OyBTZXJnZXkgU2h0eWx5b3YN
Cj4gPHMuc2h0eWx5b3ZAb21wLnJ1PjsgR2l1c2VwcGUgQ2F2YWxsYXJvIDxwZXBwZS5jYXZhbGxh
cm9Ac3QuY29tPjsNCj4gQWxleGFuZHJlIFRvcmd1ZSA8YWxleGFuZHJlLnRvcmd1ZUBmb3NzLnN0
LmNvbT47IEpvc2UgQWJyZXUNCj4gPGpvYWJyZXVAc3lub3BzeXMuY29tPjsgTWF4aW1lIENvcXVl
bGluIDxtY29xdWVsaW4uc3RtMzJAZ21haWwuY29tPjsNCj4gUmljaGFyZCBDb2NocmFuIDxyaWNo
YXJkY29jaHJhbkBnbWFpbC5jb20+OyBUaGFtcGksIFZpdmVrDQo+IDx2aXRoYW1waUB2bXdhcmUu
Y29tPjsgVk13YXJlIFBWLURyaXZlcnMgUmV2aWV3ZXJzIDxwdi0NCj4gZHJpdmVyc0B2bXdhcmUu
Y29tPjsgSmllIFdhbmcgPHdhbmdqaWUxMjVAaHVhd2VpLmNvbT47IEd1YW5nYmluIEh1YW5nDQo+
IDxodWFuZ2d1YW5nYmluMkBodWF3ZWkuY29tPjsgRXJhbiBCZW4gRWxpc2hhIDxlcmFuYmVAbnZp
ZGlhLmNvbT47IEF5YQ0KPiBMZXZpbiA8YXlhbEBudmlkaWEuY29tPjsgQ2FpIEh1b3FpbmcgPGNh
aS5odW9xaW5nQGxpbnV4LmRldj47IEJpanUgRGFzDQo+IDxiaWp1LmRhcy5qekBicC5yZW5lc2Fz
LmNvbT47IExhZCBQcmFiaGFrYXIgPHByYWJoYWthci5tYWhhZGV2LQ0KPiBsYWQucmpAYnAucmVu
ZXNhcy5jb20+OyBQaGlsIEVkd29ydGh5IDxwaGlsLmVkd29ydGh5QHJlbmVzYXMuY29tPjsgSmlh
c2hlbmcNCj4gSmlhbmcgPGppYXNoZW5nQGlzY2FzLmFjLmNuPjsgR3VzdGF2byBBLiBSLiBTaWx2
YSA8Z3VzdGF2b2Fyc0BrZXJuZWwub3JnPjsgTGludXMNCj4gV2FsbGVpaiA8bGludXMud2FsbGVp
akBsaW5hcm8ub3JnPjsgV2FuIEppYWJpbmcgPHdhbmppYWJpbmdAdml2by5jb20+OyBMdiBSdXlp
DQo+IDxsdi5ydXlpQHp0ZS5jb20uY24+OyBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0K
PiBTdWJqZWN0OiBSZTogW25ldC1uZXh0IDE0LzE0XSBwdHA6IHhnYmU6IGNvbnZlcnQgdG8gLmFk
amZpbmUgYW5kDQo+IGFkanVzdF9ieV9zY2FsZWRfcHBtDQo+IA0KPiBPbiA4LzE5LzIyIDE2OjA0
LCBLZWxsZXIsIEphY29iIEUgd3JvdGU6DQo+ID4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0t
DQo+ID4+IEZyb206IFRvbSBMZW5kYWNreSA8dGhvbWFzLmxlbmRhY2t5QGFtZC5jb20+DQo+ID4+
IFNlbnQ6IEZyaWRheSwgQXVndXN0IDE5LCAyMDIyIDk6MDUgQU0NCj4gPj4gVG86IEtlbGxlciwg
SmFjb2IgRSA8amFjb2IuZS5rZWxsZXJAaW50ZWwuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9y
Zw0KPiA+PiBDYzogSy4gWS4gU3Jpbml2YXNhbiA8a3lzQG1pY3Jvc29mdC5jb20+OyBIYWl5YW5n
IFpoYW5nDQo+ID4+IDxoYWl5YW5nekBtaWNyb3NvZnQuY29tPjsgU3RlcGhlbiBIZW1taW5nZXIN
Cj4gPHN0aGVtbWluQG1pY3Jvc29mdC5jb20+Ow0KPiA+PiBXZWkgTGl1IDx3ZWkubGl1QGtlcm5l
bC5vcmc+OyBDdWksIERleHVhbiA8ZGVjdWlAbWljcm9zb2Z0LmNvbT47IFNoeWFtDQo+ID4+IFN1
bmRhciBTIEsgPFNoeWFtLXN1bmRhci5TLWtAYW1kLmNvbT47IERhdmlkIFMuIE1pbGxlcg0KPiA+
PiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNv
bT47IEpha3ViDQo+IEtpY2luc2tpDQo+ID4+IDxrdWJhQGtlcm5lbC5vcmc+OyBQYW9sbyBBYmVu
aSA8cGFiZW5pQHJlZGhhdC5jb20+OyBTaXZhIFJlZGR5IEthbGxhbQ0KPiA+PiA8c2l2YS5rYWxs
YW1AYnJvYWRjb20uY29tPjsgUHJhc2hhbnQgU3JlZWRoYXJhbg0KPiA+PiA8cHJhc2hhbnRAYnJv
YWRjb20uY29tPjsgTWljaGFlbCBDaGFuIDxtY2hhbkBicm9hZGNvbS5jb20+OyBZaXNlbg0KPiA+
PiBaaHVhbmcgPHlpc2VuLnpodWFuZ0BodWF3ZWkuY29tPjsgU2FsaWwgTWVodGENCj4gPHNhbGls
Lm1laHRhQGh1YXdlaS5jb20+Ow0KPiA+PiBCcmFuZGVidXJnLCBKZXNzZSA8amVzc2UuYnJhbmRl
YnVyZ0BpbnRlbC5jb20+OyBOZ3V5ZW4sIEFudGhvbnkgTA0KPiA+PiA8YW50aG9ueS5sLm5ndXll
bkBpbnRlbC5jb20+OyBUYXJpcSBUb3VrYW4gPHRhcmlxdEBudmlkaWEuY29tPjsgU2FlZWQNCj4g
Pj4gTWFoYW1lZWQgPHNhZWVkbUBudmlkaWEuY29tPjsgTGVvbiBSb21hbm92c2t5IDxsZW9uQGtl
cm5lbC5vcmc+Ow0KPiA+PiBCcnlhbiBXaGl0ZWhlYWQgPGJyeWFuLndoaXRlaGVhZEBtaWNyb2No
aXAuY29tPjsgU2VyZ2V5IFNodHlseW92DQo+ID4+IDxzLnNodHlseW92QG9tcC5ydT47IEdpdXNl
cHBlIENhdmFsbGFybyA8cGVwcGUuY2F2YWxsYXJvQHN0LmNvbT47DQo+ID4+IEFsZXhhbmRyZSBU
b3JndWUgPGFsZXhhbmRyZS50b3JndWVAZm9zcy5zdC5jb20+OyBKb3NlIEFicmV1DQo+ID4+IDxq
b2FicmV1QHN5bm9wc3lzLmNvbT47IE1heGltZSBDb3F1ZWxpbg0KPiA8bWNvcXVlbGluLnN0bTMy
QGdtYWlsLmNvbT47DQo+ID4+IFJpY2hhcmQgQ29jaHJhbiA8cmljaGFyZGNvY2hyYW5AZ21haWwu
Y29tPjsgVGhhbXBpLCBWaXZlaw0KPiA+PiA8dml0aGFtcGlAdm13YXJlLmNvbT47IFZNd2FyZSBQ
Vi1Ecml2ZXJzIFJldmlld2VycyA8cHYtDQo+ID4+IGRyaXZlcnNAdm13YXJlLmNvbT47IEppZSBX
YW5nIDx3YW5namllMTI1QGh1YXdlaS5jb20+OyBHdWFuZ2Jpbg0KPiBIdWFuZw0KPiA+PiA8aHVh
bmdndWFuZ2JpbjJAaHVhd2VpLmNvbT47IEVyYW4gQmVuIEVsaXNoYSA8ZXJhbmJlQG52aWRpYS5j
b20+OyBBeWENCj4gPj4gTGV2aW4gPGF5YWxAbnZpZGlhLmNvbT47IENhaSBIdW9xaW5nIDxjYWku
aHVvcWluZ0BsaW51eC5kZXY+OyBCaWp1IERhcw0KPiA+PiA8YmlqdS5kYXMuanpAYnAucmVuZXNh
cy5jb20+OyBMYWQgUHJhYmhha2FyIDxwcmFiaGFrYXIubWFoYWRldi0NCj4gPj4gbGFkLnJqQGJw
LnJlbmVzYXMuY29tPjsgUGhpbCBFZHdvcnRoeSA8cGhpbC5lZHdvcnRoeUByZW5lc2FzLmNvbT47
DQo+IEppYXNoZW5nDQo+ID4+IEppYW5nIDxqaWFzaGVuZ0Bpc2Nhcy5hYy5jbj47IEd1c3Rhdm8g
QS4gUi4gU2lsdmEgPGd1c3Rhdm9hcnNAa2VybmVsLm9yZz47DQo+IExpbnVzDQo+ID4+IFdhbGxl
aWogPGxpbnVzLndhbGxlaWpAbGluYXJvLm9yZz47IFdhbiBKaWFiaW5nIDx3YW5qaWFiaW5nQHZp
dm8uY29tPjsgTHYNCj4gUnV5aQ0KPiA+PiA8bHYucnV5aUB6dGUuY29tLmNuPjsgQXJuZCBCZXJn
bWFubiA8YXJuZEBhcm5kYi5kZT4NCj4gPj4gU3ViamVjdDogUmU6IFtuZXQtbmV4dCAxNC8xNF0g
cHRwOiB4Z2JlOiBjb252ZXJ0IHRvIC5hZGpmaW5lIGFuZA0KPiA+PiBhZGp1c3RfYnlfc2NhbGVk
X3BwbQ0KPiA+Pg0KPiA+PiBPbiA4LzE4LzIyIDE3OjI3LCBKYWNvYiBLZWxsZXIgd3JvdGU6DQo+
ID4+PiBUaGUgeGdiZSBpbXBsZW1lbnRhdGlvbiBvZiAuYWRqZnJlcSBpcyBpbXBsZW1lbnRlZCBp
biB0ZXJtcyBvZiBhDQo+ID4+PiBzdHJhaWdodCBmb3J3YXJkICJiYXNlICogcHBiIC8gMSBiaWxs
aW9uIiBjYWxjdWxhdGlvbi4NCj4gPj4+DQo+ID4+PiBDb252ZXJ0IHRoaXMgZHJpdmVyIHRvIC5h
ZGpmaW5lIGFuZCB1c2UgYWRqdXN0X2J5X3NjYWxlZF9wcG0gdG8gY2FsY3VsYXRlDQo+ID4+PiB0
aGUgbmV3IGFkZGVuZCB2YWx1ZS4NCj4gPj4+DQo+ID4+PiBTaWduZWQtb2ZmLWJ5OiBKYWNvYiBL
ZWxsZXIgPGphY29iLmUua2VsbGVyQGludGVsLmNvbT4NCj4gPj4+IENjOiBUb20gTGVuZGFja3kg
PHRob21hcy5sZW5kYWNreUBhbWQuY29tPg0KPiA+Pj4gQ2M6IFNoeWFtIFN1bmRhciBTIEsgPFNo
eWFtLXN1bmRhci5TLWtAYW1kLmNvbT4NCj4gPj4+IC0tLQ0KPiA+Pj4NCj4gPj4+IEkgZG8gbm90
IGhhdmUgdGhpcyBoYXJkd2FyZSwgYW5kIGhhdmUgb25seSBjb21waWxlIHRlc3RlZCB0aGUgY2hh
bmdlLg0KPiA+Pj4NCj4gPj4+ICAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L2FtZC94Z2JlL3hnYmUt
cHRwLmMgfCAyMCArKysrLS0tLS0tLS0tLS0tLS0tLQ0KPiA+Pj4gICAgMSBmaWxlIGNoYW5nZWQs
IDQgaW5zZXJ0aW9ucygrKSwgMTYgZGVsZXRpb25zKC0pDQo+ID4+Pg0KPiA+Pj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FtZC94Z2JlL3hnYmUtcHRwLmMNCj4gPj4gYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9hbWQveGdiZS94Z2JlLXB0cC5jDQo+ID4+PiBpbmRleCBkMDZkMjYw
Y2YxZTIuLjcwNTFiZDdjZjZkYyAxMDA2NDQNCj4gPj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2FtZC94Z2JlL3hnYmUtcHRwLmMNCj4gPj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2FtZC94Z2JlL3hnYmUtcHRwLmMNCj4gPj4+IEBAIC0xMzQsMjcgKzEzNCwxNSBAQCBzdGF0aWMg
dTY0IHhnYmVfY2NfcmVhZChjb25zdCBzdHJ1Y3QgY3ljbGVjb3VudGVyDQo+ID4+ICpjYykNCj4g
Pj4+ICAgIAlyZXR1cm4gbnNlYzsNCj4gPj4+ICAgIH0NCj4gPj4+DQo+ID4+PiAtc3RhdGljIGlu
dCB4Z2JlX2FkamZyZXEoc3RydWN0IHB0cF9jbG9ja19pbmZvICppbmZvLCBzMzIgZGVsdGEpDQo+
ID4+PiArc3RhdGljIGludCB4Z2JlX2FkamZpbmUoc3RydWN0IHB0cF9jbG9ja19pbmZvICppbmZv
LCBsb25nIHNjYWxlZF9wcG0pDQo+ID4+PiAgICB7DQo+ID4+PiAgICAJc3RydWN0IHhnYmVfcHJ2
X2RhdGEgKnBkYXRhID0gY29udGFpbmVyX29mKGluZm8sDQo+ID4+PiAgICAJCQkJCQkgICBzdHJ1
Y3QgeGdiZV9wcnZfZGF0YSwNCj4gPj4+ICAgIAkJCQkJCSAgIHB0cF9jbG9ja19pbmZvKTsNCj4g
Pj4+ICAgIAl1bnNpZ25lZCBsb25nIGZsYWdzOw0KPiA+Pj4gLQl1NjQgYWRqdXN0Ow0KPiA+Pj4g
LQl1MzIgYWRkZW5kLCBkaWZmOw0KPiA+Pj4gLQl1bnNpZ25lZCBpbnQgbmVnX2FkanVzdCA9IDA7
DQo+ID4+PiArCXU2NCBhZGRlbmQ7DQo+ID4+Pg0KPiA+Pj4gLQlpZiAoZGVsdGEgPCAwKSB7DQo+
ID4+PiAtCQluZWdfYWRqdXN0ID0gMTsNCj4gPj4+IC0JCWRlbHRhID0gLWRlbHRhOw0KPiA+Pj4g
LQl9DQo+ID4+PiAtDQo+ID4+PiAtCWFkanVzdCA9IHBkYXRhLT50c3RhbXBfYWRkZW5kOw0KPiA+
Pj4gLQlhZGp1c3QgKj0gZGVsdGE7DQo+ID4+PiAtCWRpZmYgPSBkaXZfdTY0KGFkanVzdCwgMTAw
MDAwMDAwMFVMKTsNCj4gPj4+IC0NCj4gPj4+IC0JYWRkZW5kID0gKG5lZ19hZGp1c3QpID8gcGRh
dGEtPnRzdGFtcF9hZGRlbmQgLSBkaWZmIDoNCj4gPj4+IC0JCQkJcGRhdGEtPnRzdGFtcF9hZGRl
bmQgKyBkaWZmOw0KPiA+Pj4gKwlhZGRlbmQgPSBhZGp1c3RfYnlfc2NhbGVkX3BwbShwZGF0YS0+
dHN0YW1wX2FkZGVuZCwgc2NhbGVkX3BwbSk7DQo+ID4+DQo+ID4+IFNpbmNlIGFkZGVuZCBpcyBu
b3cgYSB1NjQsIGJ1dCB0aGUgY2FsbGVkIGZ1bmN0aW9uIGp1c3QgYWZ0ZXJ3YXJkcywNCj4gPj4g
eGdiZV91cGRhdGVfdHN0YW1wX2FkZGVuZCgpLCBleHBlY3RzIGFuIHVuc2lnbmVkIGludCwgd29u
J3QgdGhpcyBnZW5lcmF0ZQ0KPiA+PiBhIGNvbXBpbGVyIHdhcm5pbmcgZGVwZW5kaW5nIG9uIHRo
ZSBmbGFncyB1c2VkPw0KPiA+Pg0KPiA+DQo+ID4gSXQgZG9lc24ndCBzZWVtIHRvIGdlbmVyYXRl
IGFueXRoaW5nIHdpdGggVz0xIG9yIFc9MiBvbiBteSBzeXN0ZW0uIEl0cw0KPiBwb3NzaWJsZSB0
aGF0IHRoZSBjb21waWxlciBjYW4gZGVkdWNlIHRoYXQgdGhpcyB3b24ndCBvdmVyZmxvdyBhIHUz
Mj8NCj4gPg0KPiA+IFdlIGNvdWxkIGFkZCBhIGNoZWNrIHRvIGVuc3VyZSBpdCBkb2Vzbid0IG92
ZXJmbG93IHRoZSB1MzIgc2l6ZT8NCj4gDQo+IEFzIGxvbmcgYXMgd2UgZG9uJ3Qgc2VlIGEgd2Fy
bmluZywgSSdtIG9rIHdpdGggaXQuDQo+IA0KPiBBY2tlZC1ieTogVG9tIExlbmRhY2t5IDx0aG9t
YXMubGVuZGFja3lAYW1kLmNvbT4NCj4gDQo+IFRoYW5rcywNCj4gVG9tDQo+IA0KDQpUaGFua3Mu
IFNpbmNlIEknbGwgbmVlZCB0byBzZW5kIGEgdjIgdG8gZml4IHNvbWUgb3RoZXIgZHJpdmVycywg
SSB3aWxsIGRvdWJsZSBjaGVjayB0aGlzIGRvZXNuJ3QgcHJvZHVjZSBhIHdhcm5pbmcgY2FyZWZ1
bGx5IHdoZW4gSSBzZW5kIHRoZSB2Mi4NCg0KVGhhbmtzLA0KSmFrZQ0KDQo+ID4NCj4gPj4gVGhh
bmtzLA0KPiA+PiBUb20NCj4gPj4NCj4gPj4+DQo+ID4+PiAgICAJc3Bpbl9sb2NrX2lycXNhdmUo
JnBkYXRhLT50c3RhbXBfbG9jaywgZmxhZ3MpOw0KPiA+Pj4NCj4gPj4+IEBAIC0yMzUsNyArMjIz
LDcgQEAgdm9pZCB4Z2JlX3B0cF9yZWdpc3RlcihzdHJ1Y3QgeGdiZV9wcnZfZGF0YSAqcGRhdGEp
DQo+ID4+PiAgICAJCSBuZXRkZXZfbmFtZShwZGF0YS0+bmV0ZGV2KSk7DQo+ID4+PiAgICAJaW5m
by0+b3duZXIgPSBUSElTX01PRFVMRTsNCj4gPj4+ICAgIAlpbmZvLT5tYXhfYWRqID0gcGRhdGEt
PnB0cGNsa19yYXRlOw0KPiA+Pj4gLQlpbmZvLT5hZGpmcmVxID0geGdiZV9hZGpmcmVxOw0KPiA+
Pj4gKwlpbmZvLT5hZGpmaW5lID0geGdiZV9hZGpmaW5lOw0KPiA+Pj4gICAgCWluZm8tPmFkanRp
bWUgPSB4Z2JlX2FkanRpbWU7DQo+ID4+PiAgICAJaW5mby0+Z2V0dGltZTY0ID0geGdiZV9nZXR0
aW1lOw0KPiA+Pj4gICAgCWluZm8tPnNldHRpbWU2NCA9IHhnYmVfc2V0dGltZTsNCg==
