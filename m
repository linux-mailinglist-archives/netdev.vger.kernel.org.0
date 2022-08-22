Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF92759C4B0
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 19:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbiHVRII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 13:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237197AbiHVRHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 13:07:51 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A892A43E67;
        Mon, 22 Aug 2022 10:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661188056; x=1692724056;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cQ3F0MB8vEf6ruKW/4I/5kul3mtNjbgsky5+PcCHmOo=;
  b=DbaXsyUfn/VujkX26uhrT9MrMm/wL2U06GmJKDQy9XUnyooDQPH/1gKS
   PXmZ7VUWDMi28sq9VWDivjtR9dr1vf15EpFLM2PYWQmh67nPuUyzINQTj
   qF+MDC01/+dWw/CCe/d4FNsbb6ZQSC+IdoN2HTrCA7MwPTafO3bbGC4Em
   r//dIuu1dxUsn8S37ufaEz8/wexfdz+2vRu2jRgJofQABYCaxe3aTyd6n
   3EvOuHOHPkFmOYA2fV2yssgnJXsZoF6aHZqk1kKP5pjtjUwoLzl20GEuT
   3e3P5PVmq/sZ+N5925PLtIA07wM3oetaoxxCsRQ0ZU+LuAN8eJmadXJIj
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="357453016"
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="357453016"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Aug 2022 10:07:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,255,1654585200"; 
   d="scan'208";a="585604769"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 22 Aug 2022 10:07:18 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 22 Aug 2022 10:07:17 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 22 Aug 2022 10:07:17 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 22 Aug 2022 10:07:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gojJa+RDjUWOvygI2K736J4X9B79uP6EloKKol0eAZ7dotnrqUbbvOz6BPpm0F1P/kTQY6dedniDdzaFPIolsss7zO413o+qSUmihOVSOWZQT9eufR4qRswaHLWuLrZDA3lBYdaWmueJ+3SFSrTgcvrcU4OEkeEigCkpQOaK5o9U2qZZPNKWpSlxmL7Vbjye3+xQ27g02F0jcaXM2EqGzcRLfRxl/rzoBkM7xrF+SSSjGEcSwkqa3RCTjnvBQQqBKCuSnA1Bj7VwAS7U1Vm1+wcrJQjI4rsB0BcVlhT2GeFrvhN+l+1B1XEKJNRQo9r0oYdzZdluJE4zaDiqsZwTAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cQ3F0MB8vEf6ruKW/4I/5kul3mtNjbgsky5+PcCHmOo=;
 b=gcXNLhmcl4dn8zij4VsjhKN84QXXdAlki0u8v4C7kjXYvxKwyyHZbsPsi6xvNy2JIuNu1VoHPrCr6GLWh8pSV5BeUHuXsT6Rq6hhyr/rA441d/u9I0QlmPDi92XHqNp6dx7618tcW+OQsh4oVck4bHqtuiAF8fg/rgj6igxLArRrPKi29Pnx6Pw8ez+p4qzAjXggMai2MwUUJ6WFxzryTL5B55cvqTtOIgV5lOJP9p5GqEXuZo1ezKgDlPBgPcvTqa2jcKMnN0uw+4Pw/TD8yGV/hOajUlE5NaCrKcjME1QgfNe+l7fpxs+PXZC8ouibiOBUjZ71Wk1dgonbjkj3/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO1PR11MB4817.namprd11.prod.outlook.com (2603:10b6:303:98::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Mon, 22 Aug
 2022 17:07:14 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5546.023; Mon, 22 Aug 2022
 17:07:14 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
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
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Thampi, Vivek" <vithampi@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Jie Wang <wangjie125@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Aya Levin <ayal@nvidia.com>,
        Cai Huoqing <cai.huoqing@linux.dev>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Phil Edworthy <phil.edworthy@renesas.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Lv Ruyi <lv.ruyi@zte.com.cn>, Arnd Bergmann <arnd@arndb.de>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [net-next 11/14] ptp: ravb: convert to .adjfine and
 adjust_by_scaled_ppm
Thread-Topic: [net-next 11/14] ptp: ravb: convert to .adjfine and
 adjust_by_scaled_ppm
Thread-Index: AQHYs1HO9JACR2O5S0mt/knUHD8Rc624MOEAgAL7h8A=
Date:   Mon, 22 Aug 2022 17:07:14 +0000
Message-ID: <CO1PR11MB50897B992B3C14D453ED2D30D6719@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220818222742.1070935-1-jacob.e.keller@intel.com>
 <20220818222742.1070935-12-jacob.e.keller@intel.com>
 <0c7fdf31-3c81-2253-ef45-106ca099cac7@omp.ru>
In-Reply-To: <0c7fdf31-3c81-2253-ef45-106ca099cac7@omp.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01dab05f-2917-4350-1fe8-08da8460c2da
x-ms-traffictypediagnostic: CO1PR11MB4817:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9gwppFzGD0SZlW/8QfST9u/FlxPUkeOMQDc2OA/cZFMeHV+MC4xJKoFq/nMmYykyvhTv2QxHtj1wcJ4LomoXWc1tfFZqKDJ83pYQn/nRF9P65KM/mPFtd0Vy8jvTPC0jutSX12yHeS0Zlt6v7LLzELvr1AytZz4IJYz4EggjbJdxKj1Mti8GwHcsRelgh1V/QB3U17FmyLe0hTIGlx5deSl0O1aUgEODuAD7I0jzd5f8t9rLGQrgfwdpm1RwTiT/ViE57d5PJZQUEEuRoQuVcjBdJ7tM5O90A57PDtyqITQ6UQc0yALacupQs2fBo/wHK5pCgZWS0bLPD6kQBcjx4YkmM3uXG3fqsZBjGwCb4TmRYwNhU6kvUrvvVazFhu8V1Fs/eKKBjSnyPpjuvDFPs/hE6YnhLBQlErPrCcW/F7uaV0m5CiXVrtZMf5/XzJ57DaAOfEep4NN+uBVO2tSmUm2evt1Rw1BDnXWKM55qiCKExDMcbuPj4MLBKj5kICMdSZusorNSUZlSTGx6cjTUrBLEsT21NAl9kKmxc3jYr53o5F9+t23B14gDergKU2OPUnnaHcJIFDAiwuGCYChFBUwt5IKmnnMQRnicUGulxCvgAvu5nY6Oy7CyEmlpKumpzegd5zk9STQprD4GzkrEiiyCIRMmlGjxWRG/IoifczuRahfZD1n3OlkV5r5sC8BrIFU5LSiWfORsni4A7odXZrYLJG+/4MtSPsXXXwV3r5kiUPHd4YB+VmY1MPXWVNkYZt76BNYXo0T4uOcxrNUK0Q900sgXes0MlbczG0lhUtI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(366004)(396003)(346002)(39860400002)(38070700005)(82960400001)(2906002)(55016003)(478600001)(53546011)(122000001)(5660300002)(4326008)(66476007)(66556008)(7406005)(7416002)(33656002)(9686003)(66446008)(64756008)(8676002)(66946007)(26005)(76116006)(316002)(41300700001)(186003)(86362001)(6506007)(7696005)(52536014)(71200400001)(8936002)(83380400001)(38100700002)(110136005)(54906003)(142923001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bTFXTGs3aGFZeGFUbUxMTjNxYVN4QVdMempNb0NPL1I3TmFMb2VUQmEzMDRk?=
 =?utf-8?B?N1hyenZuTmtyWCsyN1pacGhvTjRENnZNN01NNVByZy9YMmJyYm5nQXorOWkw?=
 =?utf-8?B?UG5MOVVpaUVMNnlvRGUySklYeXJqbWJlcjZIZVZCekZONW9ZcTNYSGl2bWw1?=
 =?utf-8?B?c0dwVWtqTlhKbjFSbVlsV0xWRTd0bFBRUmpxOGpOdUVNTWQ0bS9SWGVQL3k1?=
 =?utf-8?B?S0Jsc1JDU25QQ3FlWk0yeTNUeUV3TEc2QXNxRk15amNVZjkzS3B2V0g2cmRo?=
 =?utf-8?B?NmtmQ2xTc2QzcWRHWThERlc2d3hDVmh2b0ViSnpmZzRHOVkzQ0Q1NXRtd1Rt?=
 =?utf-8?B?Q0p1ZVBoQitqVDB1ak41dC9QZm5NRng1TkRuVHB5ZW1yQWxVb2QyZkZWZzdn?=
 =?utf-8?B?Q2VVeTJNQmR4bXJyY2FuMWhTTTl0bTA3ODZrU0pOQVNIdE93eWRhb3BYSjA0?=
 =?utf-8?B?a2dOeXNPSU95M2ZZZFhlTm1DTnN4cjRuclJHR25MVzVjS1FlZU1iaUhseUE5?=
 =?utf-8?B?aFdqNndWWlY0OGQwV0RxVTJRMUtySTVQd0E3dDJhMXA2aXVqMFVubjVOeW43?=
 =?utf-8?B?YWxscEVVNFFLUFc0WVNTdnRsVjJaN0F3ZGNNVEJMc3JqVFB2RHBGaXVlYXVL?=
 =?utf-8?B?YWFxVks0T0tBUUZzakI2SlA1NndwbkFxUzFBNDRiOS9HdWhZQ3BSNjJXWW5H?=
 =?utf-8?B?QVp0dTEwbk1ZY0Q4K2ZtRExqUDhjTVhIM3J1MUxudTB3UUprSlFtdUZuVTJT?=
 =?utf-8?B?RnA5SXFtK0RFc0ZhbFliUkdIQ0s0cGFFRkxBS1RYelJvd2tYa3hmYzBwV2gz?=
 =?utf-8?B?dlBhOXIzakpuS0I5a2hsYjNoTVVNWUNUdHJLTk1uVGxZTlgwTVFzVGdlL0t4?=
 =?utf-8?B?Z3VPdldGeXRPcXFERmdObzk4RkFLR2RNUEduZjRIZGZkVERtZDZOV2M5WFlo?=
 =?utf-8?B?U0dURUljY2NDQ1ZKQnlWN04zbXBUZkxxemZFbDZHcWNqOUY3U2YxNSt2NGNU?=
 =?utf-8?B?RGFhS29wek8zRUQ1RTEyMDg5SFlaYkM5QU84T3o1QmdxR2JVbUVrRmwxeStD?=
 =?utf-8?B?RlR3aTlrQk9LQlZEcFQ5VXpNNW5aRi84dFFCYkxQNUZmSTFhMXpmbkFYZnY2?=
 =?utf-8?B?Uk1oMmF0QklKbEkxQmJOYis4ZFNTWk9HbHN4RXZ2ajJudzg2cWVNUHE2N1Fr?=
 =?utf-8?B?U21FWTFJemF6MXZKQzY5Y3FpVmpzRkRCVVZTdFB1MG5JWWZWY1h1ZFhNZlRy?=
 =?utf-8?B?TitYTmtLSE5rUldGbEtKOGMxekM0Q0VHRUk1WlpxNjRQaDBDaUdHNkl1aGN2?=
 =?utf-8?B?OGgwSWRUVzlWR1E0VXkvYUU0c0VVQVFDck9RSzFIV2ZEVnN3RlJVaFNWRzc2?=
 =?utf-8?B?Qy9HK3FOZFovNEVyMFV0Z2dNNlN3Y0VxVkc1MXlGTW8ycVdGRGV1bE1yeXBt?=
 =?utf-8?B?OFFxeFM1c081YnNZSmZncGJYcjJld05oRlllY3VXTEc5bjF5K0JKVkJocGJy?=
 =?utf-8?B?amxHZDFialUrQkJpelRMdXVCdU5rYkprMWVZZWlRM1FYb012eUFjRElVaXZJ?=
 =?utf-8?B?MmRrNGtvU0FYNXlxYk9wczl4Q29aL2ppMjRqNlFtSytPZzZOZklhcXV4aWRD?=
 =?utf-8?B?VHRqZlVCdDJXUXE5N1EwakNzcE1vajFLV2hFbVU4Uk1WSkYzNGtFREFoSG9X?=
 =?utf-8?B?NVkxUExiTVNucnB3T2k3QnlTZ1VkN1NvM3gxa2F6NDg1OFpNVmxma2VuRFJ1?=
 =?utf-8?B?YW5oRlM0bUVMQ3JHUlVMc0NWQkhpVThvTmFDUEw1Q2J2RWg2Zi9HbUR3ekpr?=
 =?utf-8?B?TjY1Tm5LRnMzTVhNYVJTdktCalBWOVJyOXZNK2N2ZTNWMFVtY2tpa01MWHZi?=
 =?utf-8?B?aGtKaS9DY1ZLZUNJaGYvSGJ6ZStla0J1akM2VHJNajZwM0RMNzU4aEk5U2w5?=
 =?utf-8?B?a0N1bTU5cmtzSlB4cWpVQndWN2Y1cStMUDlaUEo1TFI2UkM5TFF3WnRWb2pa?=
 =?utf-8?B?aWlhZDNhc3ZOaFZHekhqdkd4c2pLUGdhVTF1cnA0NGFTc1dPMUwvK0tRQ3Bz?=
 =?utf-8?B?NDMwZ3JyNGZuTng5M2NxSUw3MTFmejlTejNoTmxjQytFSFdJL3N4NTRPYmlZ?=
 =?utf-8?Q?juMDrIjmgWHO19sksNfRwxtnB?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01dab05f-2917-4350-1fe8-08da8460c2da
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2022 17:07:14.6523
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JEEwKlgBopSaKpDidsVJZN57chAoSA7D0Kw9GDRhIU00YiT5J18AuEb7OuFcs2//RqgjB5Kf8/zP5X0WriDP127wFG8y5BT1Lee6uzoskcc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4817
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2VyZ2V5IFNodHlseW92
IDxzLnNodHlseW92QG9tcC5ydT4NCj4gU2VudDogU2F0dXJkYXksIEF1Z3VzdCAyMCwgMjAyMiAx
MjozNCBQTQ0KPiBUbzogS2VsbGVyLCBKYWNvYiBFIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5jb20+
OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBLLiBZLiBTcmluaXZhc2FuIDxreXNAbWlj
cm9zb2Z0LmNvbT47IEhhaXlhbmcgWmhhbmcNCj4gPGhhaXlhbmd6QG1pY3Jvc29mdC5jb20+OyBT
dGVwaGVuIEhlbW1pbmdlciA8c3RoZW1taW5AbWljcm9zb2Z0LmNvbT47DQo+IFdlaSBMaXUgPHdl
aS5saXVAa2VybmVsLm9yZz47IEN1aSwgRGV4dWFuIDxkZWN1aUBtaWNyb3NvZnQuY29tPjsgVG9t
DQo+IExlbmRhY2t5IDx0aG9tYXMubGVuZGFja3lAYW1kLmNvbT47IFNoeWFtIFN1bmRhciBTIEsg
PFNoeWFtLXN1bmRhci5TLQ0KPiBrQGFtZC5jb20+OyBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRh
dmVtbG9mdC5uZXQ+OyBFcmljIER1bWF6ZXQNCj4gPGVkdW1hemV0QGdvb2dsZS5jb20+OyBKYWt1
YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgUGFvbG8gQWJlbmkNCj4gPHBhYmVuaUByZWRo
YXQuY29tPjsgU2l2YSBSZWRkeSBLYWxsYW0gPHNpdmEua2FsbGFtQGJyb2FkY29tLmNvbT47DQo+
IFByYXNoYW50IFNyZWVkaGFyYW4gPHByYXNoYW50QGJyb2FkY29tLmNvbT47IE1pY2hhZWwgQ2hh
bg0KPiA8bWNoYW5AYnJvYWRjb20uY29tPjsgWWlzZW4gWmh1YW5nIDx5aXNlbi56aHVhbmdAaHVh
d2VpLmNvbT47IFNhbGlsDQo+IE1laHRhIDxzYWxpbC5tZWh0YUBodWF3ZWkuY29tPjsgQnJhbmRl
YnVyZywgSmVzc2UNCj4gPGplc3NlLmJyYW5kZWJ1cmdAaW50ZWwuY29tPjsgTmd1eWVuLCBBbnRo
b255IEwNCj4gPGFudGhvbnkubC5uZ3V5ZW5AaW50ZWwuY29tPjsgVGFyaXEgVG91a2FuIDx0YXJp
cXRAbnZpZGlhLmNvbT47IFNhZWVkDQo+IE1haGFtZWVkIDxzYWVlZG1AbnZpZGlhLmNvbT47IExl
b24gUm9tYW5vdnNreSA8bGVvbkBrZXJuZWwub3JnPjsNCj4gQnJ5YW4gV2hpdGVoZWFkIDxicnlh
bi53aGl0ZWhlYWRAbWljcm9jaGlwLmNvbT47IEdpdXNlcHBlIENhdmFsbGFybw0KPiA8cGVwcGUu
Y2F2YWxsYXJvQHN0LmNvbT47IEFsZXhhbmRyZSBUb3JndWUgPGFsZXhhbmRyZS50b3JndWVAZm9z
cy5zdC5jb20+Ow0KPiBKb3NlIEFicmV1IDxqb2FicmV1QHN5bm9wc3lzLmNvbT47IE1heGltZSBD
b3F1ZWxpbg0KPiA8bWNvcXVlbGluLnN0bTMyQGdtYWlsLmNvbT47IFJpY2hhcmQgQ29jaHJhbiA8
cmljaGFyZGNvY2hyYW5AZ21haWwuY29tPjsNCj4gVGhhbXBpLCBWaXZlayA8dml0aGFtcGlAdm13
YXJlLmNvbT47IFZNd2FyZSBQVi1Ecml2ZXJzIFJldmlld2VycyA8cHYtDQo+IGRyaXZlcnNAdm13
YXJlLmNvbT47IEppZSBXYW5nIDx3YW5namllMTI1QGh1YXdlaS5jb20+OyBHdWFuZ2JpbiBIdWFu
Zw0KPiA8aHVhbmdndWFuZ2JpbjJAaHVhd2VpLmNvbT47IEVyYW4gQmVuIEVsaXNoYSA8ZXJhbmJl
QG52aWRpYS5jb20+OyBBeWENCj4gTGV2aW4gPGF5YWxAbnZpZGlhLmNvbT47IENhaSBIdW9xaW5n
IDxjYWkuaHVvcWluZ0BsaW51eC5kZXY+OyBCaWp1IERhcw0KPiA8YmlqdS5kYXMuanpAYnAucmVu
ZXNhcy5jb20+OyBMYWQgUHJhYmhha2FyIDxwcmFiaGFrYXIubWFoYWRldi0NCj4gbGFkLnJqQGJw
LnJlbmVzYXMuY29tPjsgUGhpbCBFZHdvcnRoeSA8cGhpbC5lZHdvcnRoeUByZW5lc2FzLmNvbT47
IEppYXNoZW5nDQo+IEppYW5nIDxqaWFzaGVuZ0Bpc2Nhcy5hYy5jbj47IEd1c3Rhdm8gQS4gUi4g
U2lsdmEgPGd1c3Rhdm9hcnNAa2VybmVsLm9yZz47IExpbnVzDQo+IFdhbGxlaWogPGxpbnVzLndh
bGxlaWpAbGluYXJvLm9yZz47IFdhbiBKaWFiaW5nIDx3YW5qaWFiaW5nQHZpdm8uY29tPjsgTHYg
UnV5aQ0KPiA8bHYucnV5aUB6dGUuY29tLmNuPjsgQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5k
ZT47IGxpbnV4LXJlbmVzYXMtDQo+IHNvY0B2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6
IFtuZXQtbmV4dCAxMS8xNF0gcHRwOiByYXZiOiBjb252ZXJ0IHRvIC5hZGpmaW5lIGFuZA0KPiBh
ZGp1c3RfYnlfc2NhbGVkX3BwbQ0KPiANCj4gSGVsbG8hDQo+IA0KPiBPbiA4LzE5LzIyIDE6Mjcg
QU0sIEphY29iIEtlbGxlciB3cm90ZToNCj4gDQo+ID4gVGhlIHJhdmIgaW1wbGVtZW50YXRpb24g
b2YgLmFkamZyZXEgaXMgaW1wbGVtZW50ZWQgaW4gdGVybXMgb2YgYQ0KPiA+IHN0cmFpZ2h0IGZv
cndhcmQgImJhc2UgKiBwcGIgLyAxIGJpbGxpb24iIGNhbGN1bGF0aW9uLg0KPiA+DQo+ID4gQ29u
dmVydCB0aGlzIGRyaXZlciB0byAuYWRqZmluZSBhbmQgdXNlIHRoZSBhZGp1c3RfYnlfc2NhbGVk
X3BwbSBoZWxwZXINCj4gPiBmdW5jdGlvbiB0byBjYWxjdWxhdGUgdGhlIG5ldyBhZGRlbmQuDQo+
ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBKYWNvYiBLZWxsZXIgPGphY29iLmUua2VsbGVyQGludGVs
LmNvbT4NCj4gPiBDYzogU2VyZ2V5IFNodHlseW92IDxzLnNodHlseW92QG9tcC5ydT4NCj4gPiBD
YzogQmlqdSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPg0KPiA+IENjOiBQaGlsIEVk
d29ydGh5IDxwaGlsLmVkd29ydGh5QHJlbmVzYXMuY29tPg0KPiA+IENjOiBMYWQgUHJhYmhha2Fy
IDxwcmFiaGFrYXIubWFoYWRldi1sYWQucmpAYnAucmVuZXNhcy5jb20+DQo+ID4gQ2M6IGxpbnV4
LXJlbmVzYXMtc29jQHZnZXIua2VybmVsLm9yZw0KPiA+IC0tLQ0KPiA+DQo+ID4gSSBkbyBub3Qg
aGF2ZSB0aGlzIGhhcmR3YXJlLCBhbmQgaGF2ZSBvbmx5IGNvbXBpbGUgdGVzdGVkIHRoZSBjaGFu
Z2UuDQo+ID4NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvcmVuZXNhcy9yYXZiX3B0cC5jIHwg
MTYgKysrKystLS0tLS0tLS0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCsp
LCAxMSBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9yZW5lc2FzL3JhdmJfcHRwLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2Fz
L3JhdmJfcHRwLmMNCj4gPiBpbmRleCA4N2M0MzA2ZDY2ZWMuLjk0MWFhM2IwZThhMCAxMDA2NDQN
Cj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfcHRwLmMNCj4gPiAr
KysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9yZW5lc2FzL3JhdmJfcHRwLmMNCj4gPiBAQCAtODgs
MjQgKzg4LDE4IEBAIHN0YXRpYyBpbnQgcmF2Yl9wdHBfdXBkYXRlX2NvbXBhcmUoc3RydWN0DQo+
IHJhdmJfcHJpdmF0ZSAqcHJpdiwgdTMyIG5zKQ0KPiA+ICB9DQo+ID4NCj4gPiAgLyogUFRQIGNs
b2NrIG9wZXJhdGlvbnMgKi8NCj4gPiAtc3RhdGljIGludCByYXZiX3B0cF9hZGpmcmVxKHN0cnVj
dCBwdHBfY2xvY2tfaW5mbyAqcHRwLCBzMzIgcHBiKQ0KPiA+ICtzdGF0aWMgaW50IHJhdmJfcHRw
X2FkamZpbmUoc3RydWN0IHB0cF9jbG9ja19pbmZvICpwdHAsIGxvbmcgc2NhbGVkX3BwbSkNCj4g
PiAgew0KPiA+ICAJc3RydWN0IHJhdmJfcHJpdmF0ZSAqcHJpdiA9IGNvbnRhaW5lcl9vZihwdHAs
IHN0cnVjdCByYXZiX3ByaXZhdGUsDQo+ID4gIAkJCQkJCSBwdHAuaW5mbyk7DQo+ID4gIAlzdHJ1
Y3QgbmV0X2RldmljZSAqbmRldiA9IHByaXYtPm5kZXY7DQo+ID4gIAl1bnNpZ25lZCBsb25nIGZs
YWdzOw0KPiA+IC0JdTMyIGRpZmYsIGFkZGVuZDsNCj4gPiAtCWJvb2wgbmVnX2FkaiA9IGZhbHNl
Ow0KPiA+ICsJdTMyIGFkZGVuZDsNCj4gPiAgCXUzMiBnY2NyOw0KPiA+DQo+ID4gLQlpZiAocHBi
IDwgMCkgew0KPiA+IC0JCW5lZ19hZGogPSB0cnVlOw0KPiA+IC0JCXBwYiA9IC1wcGI7DQo+ID4g
LQl9DQo+ID4gIAlhZGRlbmQgPSBwcml2LT5wdHAuZGVmYXVsdF9hZGRlbmQ7DQo+IA0KPiAgICBJ
IGRvbid0IHRoaW5rIHdlIHNob3VsZCBrZWVwIHRoaXMgbGluZSAtLSBpdCBoYXMgbm8gZWZmZWN0
IG5vdy4uLg0KPiANCg0KWWVhIHRoaXMgY2FuIGJlIGRyb3BwZWQuDQoNCj4gPiAtCWRpZmYgPSBk
aXZfdTY0KCh1NjQpYWRkZW5kICogcHBiLCBOU0VDX1BFUl9TRUMpOw0KPiA+IC0NCj4gPiAtCWFk
ZGVuZCA9IG5lZ19hZGogPyBhZGRlbmQgLSBkaWZmIDogYWRkZW5kICsgZGlmZjsNCj4gPiArCWFk
ZGVuZCA9ICh1MzIpYWRqdXN0X2J5X3NjYWxlZF9wcG0ocHJpdi0+cHRwLmRlZmF1bHRfYWRkZW5k
LA0KPiA+ICsJCQkJCSAgIHNjYWxlZF9wcG0pOw0KPiA+DQo+ID4gIAlzcGluX2xvY2tfaXJxc2F2
ZSgmcHJpdi0+bG9jaywgZmxhZ3MpOw0KPiA+DQo+IFsuLi5dDQo+IA0KPiBNQlIsIFNlcmdleQ0K
