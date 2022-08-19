Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3586459A773
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 23:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351890AbiHSVEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 17:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350874AbiHSVEY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 17:04:24 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A03481F4
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 14:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660943063; x=1692479063;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RMPVgTOA/Bjzz/z/xm+BQGN1zlBUnSaZFT6r9+X9elc=;
  b=VBOxUwlAebl6Q1KWQpJ4xr060XzaPDZG/P8lH4SIUzPfDs9x1D576mMw
   Dy4/khhfYKry4emMwmzrsWVTtg60ggPrLWF3E/Uan7OYngKR2nj4VnigH
   Lihy0N39o+GLB6N/5ndDo6wt/EpgRQ2vdSP8/TrvnX1VtEfK7BYeXLWAb
   p4ZbZ37zALutPQgfqOUY+8Bhxb5wDFw56OFYo+zKSkyQsokG+U5OuqzCC
   HZnNl/9xrG2qUfxKpXpOMwG4MRcKutoYlEBpwwTjTeWQgD693d413hEX8
   c1KoGIjvPyjOcpT9TNcoa2Q9rNRpoa3gC74h5U5R1k7auYJ8f4x6PsUH2
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10444"; a="272865648"
X-IronPort-AV: E=Sophos;i="5.93,249,1654585200"; 
   d="scan'208";a="272865648"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 14:04:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,249,1654585200"; 
   d="scan'208";a="936350922"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 19 Aug 2022 14:04:22 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 19 Aug 2022 14:04:21 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 19 Aug 2022 14:04:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 19 Aug 2022 14:04:21 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Fri, 19 Aug 2022 14:04:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hEWRk2R9ICv6SAsFd29gBsf0dbfDsYGmTZOXOTq6VTWYtNhPSUeg2Yv3Fuyj9f4pCA6ZvbO54cnXbbWG2BNtORha5UVHLUf92/bEA7Qimu5y9MOCCrlg4EQCuEhnFkisjwH7CEOlrF9pyr/rvGv6IYempF5cgPLai8jlDt7E8GXq6S9b1Bw3XWkZe2D0z7ZXhKckaQsaNPyiUe41uLlK/50E2VZoTxTAz8q6T3Jx/KhvY7Jlj6cYlsOZ4gn3DRdNRWVRQy+j8cOUzBFQl/PpQ6L3nSrDQGfz6QtJHcrhK1fE0moRzlCKsSkNHche+7z2pUlsc+51FQMBWq03ts7XGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RMPVgTOA/Bjzz/z/xm+BQGN1zlBUnSaZFT6r9+X9elc=;
 b=R6veQrRG2dUKJMNzpCdgbZyw1RqdZslcWGGdAhE+3yqYF98+SCGvzjmjxNrRHCiSQQ6o+oH2LqTSgiyLvKmDObKMODwxfoSrRG8ZUn/8s9/ChvU0mJ9NaaoVzU5GmZd5fwVUn//03UVPbuZaSjtZeKy1zHWfKu4wYDjjdotqHvGr2qmHWhQ9YGrIeKmtkQPQT70/IVgXuR68qF3dAx0quS62wU4pS2d/ncRslMffyj7N6xgIYBQBk7ITct1xW71NLOq1tc7+ESPDCqyjccqOZSzfYxSOnip9DlvUQOIpkik4z4tUzhDEf1ETe7n7rh9ngusEiRv4MDuhr6czEHlbNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BY5PR11MB4024.namprd11.prod.outlook.com (2603:10b6:a03:192::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.17; Fri, 19 Aug
 2022 21:04:18 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5546.018; Fri, 19 Aug 2022
 21:04:18 +0000
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
Thread-Index: AQHYs1HOeQaM9U14QEafBLHzwebIaK22ZFiAgABSk6A=
Date:   Fri, 19 Aug 2022 21:04:18 +0000
Message-ID: <CO1PR11MB5089E76BE2538C85827C0386D66C9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220818222742.1070935-1-jacob.e.keller@intel.com>
 <20220818222742.1070935-15-jacob.e.keller@intel.com>
 <334dc732-5a94-678f-56e8-df2fa9ee1035@amd.com>
In-Reply-To: <334dc732-5a94-678f-56e8-df2fa9ee1035@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d905ca49-fdb0-42e8-ed4e-08da822661b7
x-ms-traffictypediagnostic: BY5PR11MB4024:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r77vDfkMaXAFF+eJ3pMW4Gsn3/9k2gCfagFoncOFpZv32ki+mJdJu+HDtOlER1ykTRS4QAo7l413b5APwvr3hqjsD8D+yttrA5S6chzFiFwCMuVXIOAb9Uw5NPItf1H+FpYTGYh2bgboOYh8o0VutgMZbYgbdAP8Nq59vZtGE/0oBv0rG8sZzpCd9wkikdJYlFNP20eBlXhHPuaBxuIVpLGqQE1DKjP/hvKHxIGO698ACTzX/I850OW4IH0cEKv5g5YXNgtir0VWzWqXIFyYj+eUxMp4rndHJ3rdxEbAjax6GsNrA07ez3C6eUz2/g2dkV4W4ypm5WazSey0SU85OD4jV+7L8MbNuYt8iHLvRyl9DJy+kd8cCPTXqe4+E8yllxDy+IKgKiM5p2MULkijlbrQtN8ZGAeCzT9/+wgwGOiDWGULu1I4D3qEOMjIDuCI24vSkfTC9yUu8Uajf8+OHC5dvSgFg75GU0SpyUxB5QEIP5hwnYHTDZrQ69JZxwoJ6tpWJ+mBwX0Pa2DZVwtbkaOz2G9Ltf5v5X5AIfaJqJVa7nLtwjA/tqSvf6Z9Nxl/qajgG8+U8S46mxoNHGpdrngSGX9dq4r3LM4LZz0gQvEF+rm+JmwKymWQwIrdtHpVJIAKA+DliDX3zigebUgUNGgfBXoYaugDCRVlAiDxJWQsueVBocX9JRH3Jgv93NhhJzh8ea+I+bTTnmdPhDJavEKcavLkbXj0MApfVdjqXyxuWu0ZaghDkbxTIlX5ToTSGToBFz+6/5IT/WhmndyBmZ6I3MwmEccBrcEdLHygZNE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(136003)(346002)(376002)(366004)(7696005)(53546011)(6506007)(186003)(83380400001)(7416002)(52536014)(5660300002)(8936002)(7406005)(26005)(9686003)(41300700001)(71200400001)(33656002)(478600001)(86362001)(38070700005)(82960400001)(8676002)(66476007)(316002)(54906003)(110136005)(55016003)(2906002)(122000001)(38100700002)(76116006)(64756008)(66946007)(4326008)(66446008)(66556008)(142923001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bmNXc1FjTERHN3lDRjZZY0tXOXY0VThtdkZ6dWM4bFBSSkh6SDlhOWRUSjEz?=
 =?utf-8?B?RVhKUkM4dlYyVERLK1Z1WHJKb0UvK2tuenFWa0w5dkROak9JSHZPRG1WaFB3?=
 =?utf-8?B?aVA3a0pZTEpGTldYV0RDbDhZU0ZMVDhqYUdRQTd1OEFmS3RoeGJIUWg0RDFp?=
 =?utf-8?B?NFdZUXErTXRjR2tLL2FkMmM1QjQvUGZ3dVovVkxOblRzYVZ1TS9KNWNtUElB?=
 =?utf-8?B?QlEzWDdxYXZ4bmRoZUFrRUVWbmFWRDdPM3htN3hXSFNRdkg1S1I1bFI0Rll3?=
 =?utf-8?B?L3VnNnVJWXQ0blZMNWx3OVQvYWtZWktQZURjMzg4ZW5ZRzIvTGxMMXpJd3Rh?=
 =?utf-8?B?YWRxTWhlOFVpS0oxRTZFWGxuTGhMelJ1ZkxtVzU2NDhsTk1jZ0dTcUExNjF0?=
 =?utf-8?B?eXI5S2VCSG9uREhJQ3kxS2kvYVdvNmlqZ2t3QW5sSXRHT1lwWmpFWElVdjVX?=
 =?utf-8?B?SDBJbG5BUWVUN3NYZFFKazRGclY3a3JReEhzT0xtNDB3Y0xlN3lnQWRmYVJ2?=
 =?utf-8?B?WUM3Kys4ejNuYmk2VTJSdGNzWlNLS0w1eDNPT3pSeU00VzBvZ0VKY3g1VHZC?=
 =?utf-8?B?Zk9DczBiVUJSSWFUM0VBY0xaS2VKNm45UExwcnFmYkdhRE1lcXFJaG0zbDVw?=
 =?utf-8?B?eEFwczlRU0hTMVV4UEdmRnVka2ZZdFkxNThiUld4K1RYSnpGQmNzUmV3NDBY?=
 =?utf-8?B?bWQ5c3RLYVYweGk5dS9MRnFhdzJKV0o4Q1ZSTWFjKzNtMjBnbzZSZndzUHlZ?=
 =?utf-8?B?MjNlcHdrS2Y0UFd6b1k0OUd3K2pQZHJ1ajRLWnFBOXJmNHpLTEJJbVV5eHVw?=
 =?utf-8?B?NmNkay9xV3YrSURvYlluYlFsNzBSODM4RUNPKzJwU1FyK1JNT1RIZCtTbHJx?=
 =?utf-8?B?YlRjc29XL0tud1E3VHNQTlFtWVE0cnJQMXdOeDc5Y3pxNEJqOU1PZFl6ZVpv?=
 =?utf-8?B?ZG5qSDY1MHJDZGVmdEJ0NTNGKzFvbGZEZ1JGVWhnOHhXb3hXVWJqeWVlUVdW?=
 =?utf-8?B?a3lQU09tWHZmcHo1UlFPY1pKaEVHOVZtL1ZNUHk1MGpJNTdWK1Y4cGpDdm12?=
 =?utf-8?B?NGdXTXlWdDlub0NtUlJzWGtkTzRPbUJsM2tNL0Y0enB1M3htZktzKzlEQXAw?=
 =?utf-8?B?RmF0VStXamJQQXNMU0dnMThBaVFqbUpzb0ZNUlBIUFpKblJBTUQyL3FyeHVk?=
 =?utf-8?B?bk5wMlpnQnRRNEphaEhSQ2lETHNlTUhXN010V3BEUHkzK25mSlZzRHBSbytN?=
 =?utf-8?B?S0VZY0UvWHVzcHdrRDh5ZS9SQ2RBang2TzZpc0V5emFGT2RaNURZUmR4ZVFt?=
 =?utf-8?B?eUUrYVV1bjhaSHhOZkFxRDNrdVBnS2RQZXhZVU5xTmFIUURNMzFCcXh4TGtw?=
 =?utf-8?B?ck5oYTJBL0dlRGV4M2hkd2MzT2p6UnB3dzZ0QVRiNlc0K2RZRnZlRDl6d1lF?=
 =?utf-8?B?NGVlVXZ5WFBFaWN2S1hYNWtYcU5zNmlMVkNtMGQ4T0ZPNDhyZkdBWnVYbStS?=
 =?utf-8?B?TjNFMTFjdmlRQTBFYkpQNHNWRzhpZEpJSWJ2NTRrUzY1OHFJMmJ3YnlBbGps?=
 =?utf-8?B?dlNFaWNPbnI2M0RZV0VYYmhYOXFWT2RrOTRiTUdMZlVXeHNqV1BlNmxsMjZx?=
 =?utf-8?B?L2JWVHgxWU9qMm80M2VpSkpBSTdsMXNTN3VHK0doejl1RHU4NW96clB1bW5S?=
 =?utf-8?B?a2JEUWJlbWltU1dKZ3NWdm12UW81VWFBTDhZUlJnQ1ZJZmxVeDJBQ2FudDJI?=
 =?utf-8?B?MDlrMkk0N0YwOXB2ODdxaEdSeFhWYUswVUFHeUtxYllJSUZXbXhpUUVLTStI?=
 =?utf-8?B?M3gwU1hwTUliZzhnZjJGNC9mVDd0Y0ZyTlJTYnlxUlNGS0lZYTE3U2dpZjZE?=
 =?utf-8?B?aFhGZS95a1BmWW8vbmRBeUpwSXZTYVBRVms4OGtrU2ViN1A1N3BjV0diL3N0?=
 =?utf-8?B?RzdjTCtKUWlPelR6SWY1ZXRKMmhlcy9HOHlFR0c2Q3Q4M214SzRrV2RKOUM1?=
 =?utf-8?B?S3FUSGZpM0xtcHlBRHJVUWpjTDFvU0RYZVlwVGR5dktpTWFqVngyb1VtQUZH?=
 =?utf-8?B?RWpsMGdSREl5amFUYUZqMzIwcG44K05BTkJjMkxzSXR4NTBPSEdRd1hZT09x?=
 =?utf-8?Q?Jz0AFevfJrn1nTT8yPJferipv?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d905ca49-fdb0-42e8-ed4e-08da822661b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 21:04:18.5845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ByNRmIjnGPyMyESG4++CiK22j0Ye1x7STAH8XSw0seZ94kODTZgpW7CrqkNaS+7pcHoEMvYV2jjtN4xaFweanw/J9RCe4Hcufun48KfaqR8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4024
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVG9tIExlbmRhY2t5IDx0
aG9tYXMubGVuZGFja3lAYW1kLmNvbT4NCj4gU2VudDogRnJpZGF5LCBBdWd1c3QgMTksIDIwMjIg
OTowNSBBTQ0KPiBUbzogS2VsbGVyLCBKYWNvYiBFIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5jb20+
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
amZpbmUgYW5kDQo+IGFkanVzdF9ieV9zY2FsZWRfcHBtDQo+IA0KPiBPbiA4LzE4LzIyIDE3OjI3
LCBKYWNvYiBLZWxsZXIgd3JvdGU6DQo+ID4gVGhlIHhnYmUgaW1wbGVtZW50YXRpb24gb2YgLmFk
amZyZXEgaXMgaW1wbGVtZW50ZWQgaW4gdGVybXMgb2YgYQ0KPiA+IHN0cmFpZ2h0IGZvcndhcmQg
ImJhc2UgKiBwcGIgLyAxIGJpbGxpb24iIGNhbGN1bGF0aW9uLg0KPiA+DQo+ID4gQ29udmVydCB0
aGlzIGRyaXZlciB0byAuYWRqZmluZSBhbmQgdXNlIGFkanVzdF9ieV9zY2FsZWRfcHBtIHRvIGNh
bGN1bGF0ZQ0KPiA+IHRoZSBuZXcgYWRkZW5kIHZhbHVlLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1i
eTogSmFjb2IgS2VsbGVyIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5jb20+DQo+ID4gQ2M6IFRvbSBM
ZW5kYWNreSA8dGhvbWFzLmxlbmRhY2t5QGFtZC5jb20+DQo+ID4gQ2M6IFNoeWFtIFN1bmRhciBT
IEsgPFNoeWFtLXN1bmRhci5TLWtAYW1kLmNvbT4NCj4gPiAtLS0NCj4gPg0KPiA+IEkgZG8gbm90
IGhhdmUgdGhpcyBoYXJkd2FyZSwgYW5kIGhhdmUgb25seSBjb21waWxlIHRlc3RlZCB0aGUgY2hh
bmdlLg0KPiA+DQo+ID4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9hbWQveGdiZS94Z2JlLXB0cC5j
IHwgMjAgKysrKy0tLS0tLS0tLS0tLS0tLS0NCj4gPiAgIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2Vy
dGlvbnMoKyksIDE2IGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2FtZC94Z2JlL3hnYmUtcHRwLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9hbWQveGdiZS94Z2JlLXB0cC5jDQo+ID4gaW5kZXggZDA2ZDI2MGNmMWUyLi43MDUxYmQ3Y2Y2
ZGMgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1kL3hnYmUveGdiZS1w
dHAuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FtZC94Z2JlL3hnYmUtcHRwLmMN
Cj4gPiBAQCAtMTM0LDI3ICsxMzQsMTUgQEAgc3RhdGljIHU2NCB4Z2JlX2NjX3JlYWQoY29uc3Qg
c3RydWN0IGN5Y2xlY291bnRlcg0KPiAqY2MpDQo+ID4gICAJcmV0dXJuIG5zZWM7DQo+ID4gICB9
DQo+ID4NCj4gPiAtc3RhdGljIGludCB4Z2JlX2FkamZyZXEoc3RydWN0IHB0cF9jbG9ja19pbmZv
ICppbmZvLCBzMzIgZGVsdGEpDQo+ID4gK3N0YXRpYyBpbnQgeGdiZV9hZGpmaW5lKHN0cnVjdCBw
dHBfY2xvY2tfaW5mbyAqaW5mbywgbG9uZyBzY2FsZWRfcHBtKQ0KPiA+ICAgew0KPiA+ICAgCXN0
cnVjdCB4Z2JlX3Bydl9kYXRhICpwZGF0YSA9IGNvbnRhaW5lcl9vZihpbmZvLA0KPiA+ICAgCQkJ
CQkJICAgc3RydWN0IHhnYmVfcHJ2X2RhdGEsDQo+ID4gICAJCQkJCQkgICBwdHBfY2xvY2tfaW5m
byk7DQo+ID4gICAJdW5zaWduZWQgbG9uZyBmbGFnczsNCj4gPiAtCXU2NCBhZGp1c3Q7DQo+ID4g
LQl1MzIgYWRkZW5kLCBkaWZmOw0KPiA+IC0JdW5zaWduZWQgaW50IG5lZ19hZGp1c3QgPSAwOw0K
PiA+ICsJdTY0IGFkZGVuZDsNCj4gPg0KPiA+IC0JaWYgKGRlbHRhIDwgMCkgew0KPiA+IC0JCW5l
Z19hZGp1c3QgPSAxOw0KPiA+IC0JCWRlbHRhID0gLWRlbHRhOw0KPiA+IC0JfQ0KPiA+IC0NCj4g
PiAtCWFkanVzdCA9IHBkYXRhLT50c3RhbXBfYWRkZW5kOw0KPiA+IC0JYWRqdXN0ICo9IGRlbHRh
Ow0KPiA+IC0JZGlmZiA9IGRpdl91NjQoYWRqdXN0LCAxMDAwMDAwMDAwVUwpOw0KPiA+IC0NCj4g
PiAtCWFkZGVuZCA9IChuZWdfYWRqdXN0KSA/IHBkYXRhLT50c3RhbXBfYWRkZW5kIC0gZGlmZiA6
DQo+ID4gLQkJCQlwZGF0YS0+dHN0YW1wX2FkZGVuZCArIGRpZmY7DQo+ID4gKwlhZGRlbmQgPSBh
ZGp1c3RfYnlfc2NhbGVkX3BwbShwZGF0YS0+dHN0YW1wX2FkZGVuZCwgc2NhbGVkX3BwbSk7DQo+
IA0KPiBTaW5jZSBhZGRlbmQgaXMgbm93IGEgdTY0LCBidXQgdGhlIGNhbGxlZCBmdW5jdGlvbiBq
dXN0IGFmdGVyd2FyZHMsDQo+IHhnYmVfdXBkYXRlX3RzdGFtcF9hZGRlbmQoKSwgZXhwZWN0cyBh
biB1bnNpZ25lZCBpbnQsIHdvbid0IHRoaXMgZ2VuZXJhdGUNCj4gYSBjb21waWxlciB3YXJuaW5n
IGRlcGVuZGluZyBvbiB0aGUgZmxhZ3MgdXNlZD8NCj4gDQoNCkl0IGRvZXNuJ3Qgc2VlbSB0byBn
ZW5lcmF0ZSBhbnl0aGluZyB3aXRoIFc9MSBvciBXPTIgb24gbXkgc3lzdGVtLiBJdHMgcG9zc2li
bGUgdGhhdCB0aGUgY29tcGlsZXIgY2FuIGRlZHVjZSB0aGF0IHRoaXMgd29uJ3Qgb3ZlcmZsb3cg
YSB1MzI/DQoNCldlIGNvdWxkIGFkZCBhIGNoZWNrIHRvIGVuc3VyZSBpdCBkb2Vzbid0IG92ZXJm
bG93IHRoZSB1MzIgc2l6ZT8NCg0KPiBUaGFua3MsDQo+IFRvbQ0KPiANCj4gPg0KPiA+ICAgCXNw
aW5fbG9ja19pcnFzYXZlKCZwZGF0YS0+dHN0YW1wX2xvY2ssIGZsYWdzKTsNCj4gPg0KPiA+IEBA
IC0yMzUsNyArMjIzLDcgQEAgdm9pZCB4Z2JlX3B0cF9yZWdpc3RlcihzdHJ1Y3QgeGdiZV9wcnZf
ZGF0YSAqcGRhdGEpDQo+ID4gICAJCSBuZXRkZXZfbmFtZShwZGF0YS0+bmV0ZGV2KSk7DQo+ID4g
ICAJaW5mby0+b3duZXIgPSBUSElTX01PRFVMRTsNCj4gPiAgIAlpbmZvLT5tYXhfYWRqID0gcGRh
dGEtPnB0cGNsa19yYXRlOw0KPiA+IC0JaW5mby0+YWRqZnJlcSA9IHhnYmVfYWRqZnJlcTsNCj4g
PiArCWluZm8tPmFkamZpbmUgPSB4Z2JlX2FkamZpbmU7DQo+ID4gICAJaW5mby0+YWRqdGltZSA9
IHhnYmVfYWRqdGltZTsNCj4gPiAgIAlpbmZvLT5nZXR0aW1lNjQgPSB4Z2JlX2dldHRpbWU7DQo+
ID4gICAJaW5mby0+c2V0dGltZTY0ID0geGdiZV9zZXR0aW1lOw0K
