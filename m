Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9171B5A53CB
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 20:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbiH2SK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 14:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiH2SKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 14:10:54 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B807E82A
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 11:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661796652; x=1693332652;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ygPzk02oWXSQKgl62stXN5Y206Rygmk/76GjxY3+K78=;
  b=YnkR7RFqsRpoDrAEwnr8u6VR1IrWIKIRUBsLJwG5ncC4mHtGoWo4imny
   cIJAKeajEYyVRNiMorGdN800LMumlFn7RkRWFx7peEAy109WAS8e/QvFl
   LhZJQ7M7LRczhpCf5LYHo8wW6xcPXYqAopc7NXEm+/wHcIzQOR2pZm3Sv
   /CZb3YhcU+OWAAlG52or7J4NGARHBojXxucqb36BBtoE8/ODcCepELfs5
   xy26r8/qiclUuMZs0/1BIOf6zDwn2P2Hm3J327eWTtWARHhekf9+KSpLC
   MpYuQW5EVK5rV7k/u20aDcc6ilAQqf9nJUv3SJ5FLEvJGA1mjtDYBNH5e
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="296241608"
X-IronPort-AV: E=Sophos;i="5.93,273,1654585200"; 
   d="scan'208";a="296241608"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 11:10:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,273,1654585200"; 
   d="scan'208";a="614305958"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 29 Aug 2022 11:10:51 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 29 Aug 2022 11:10:51 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 29 Aug 2022 11:10:50 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 29 Aug 2022 11:10:50 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 29 Aug 2022 11:10:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ImRDfIKp4BJlz46gjCYqClvTjBHGisqSsSBanWZLJwbxjNaiuQddqfHUL1LVX1VCtmHShEXyNcobq4vo5Os2D+QhCseoGgAAJJtlPpiVGRR7uQMqxxkQ8rozbazU/tVe8auU00tfbZ+xCQb453vBSHraSftpIDvzJmZi95ac1LFJGBFYjxAtN/RmbiO/PsHpgBDF8YNdX3Yc1xbo2O2E/Zig5tlrUeXCtA9jNtvuNWpuPSMKEhQm3N5MgURo+PczKRePem2ACeEIPcV8yg4ZNBbs1fb8yFz7XUGeIeEtzuspgLnQL15aTZktBjthJC5KspbHDyKjQJ+z4ienLH5UNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hjcfiYu8+FdtU2iOK2bQ/dZdcxrwX9VdbQCGaM6fIhk=;
 b=B6dVuYvqLfrP/vNxiyvvBo8QUGjt6B8HtWVOlMCdSs00+zaFOCgcpi0Ul8u4l/s+1sprpRYmF2hL2ceGej+xYDrAdk/G2ItlFQ2PG7fdqdDwSpxq7teif+mEq8OEcydEMUY9hhC/oNmqSul+m3sSRItJZuFyCm/fNpuwanbpkHADb/8p8dT2AzvF3rrF2HE7RINcLYewXOiDvNyx9HXbXs33uTubkYmLx3TC9U/tv4bsVGGLYJ/j4qHztceOOnHFHpjlFN59dDfcehfytYNm2B2Jy5N9HX7H7XRmjkVDW2U0wahkjIc/xFLicRKyOGYC4zRR6p1RxiR64VeSaJB1fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11)
 by BL0PR11MB3283.namprd11.prod.outlook.com (2603:10b6:208:69::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Mon, 29 Aug
 2022 18:10:46 +0000
Received: from SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::b4ce:dcac:20c5:66c8]) by SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::b4ce:dcac:20c5:66c8%8]) with mapi id 15.20.5566.021; Mon, 29 Aug 2022
 18:10:46 +0000
Message-ID: <3f72e038-016d-8b1c-a215-243199bac033@intel.com>
Date:   Mon, 29 Aug 2022 11:10:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.0
Subject: Re: [PATCH net-next 0/2] ice: support FEC automatic disable
Content-Language: en-US
To:     Gal Pressman <gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Andy Gospodarek <andy@greyhouse.net>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
 <e8251cef-585b-8992-f3b2-5d662071cab3@nvidia.com>
 <CO1PR11MB50895C42C04A408CF6151023D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
 <5d9c6b31-cdf2-1285-6d4b-2368bae8b6f4@nvidia.com>
 <20220825092957.26171986@kernel.org>
 <CO1PR11MB50893710E9CA4C720815384ED6729@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220825103027.53fed750@kernel.org>
 <CO1PR11MB50891983ACE664FB101F2BAAD6729@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220825133425.7bfb34e9@kernel.org>
 <bcdfe60a-0eb7-b1cf-15c8-5be7740716a1@intel.com>
 <20220825180107.38915c09@kernel.org>
 <9d962e38-1aa9-d0ed-261e-eb77c82b186b@intel.com>
 <20220826165711.015e7827@kernel.org>
 <b1c03626-1df1-e4e5-815e-f35c6346cbed@nvidia.com>
 <SA2PR11MB51005070A0E456D7DD169A1FD6769@SA2PR11MB5100.namprd11.prod.outlook.com>
 <b20f0964-42b7-53af-fe24-540d6cd011de@nvidia.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <b20f0964-42b7-53af-fe24-540d6cd011de@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0240.namprd04.prod.outlook.com
 (2603:10b6:303:87::35) To SA2PR11MB5100.namprd11.prod.outlook.com
 (2603:10b6:806:119::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 334fc03c-3e6d-41b3-f58d-08da89e9cbdc
X-MS-TrafficTypeDiagnostic: BL0PR11MB3283:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IuuH5eFlcPivCq6nKdkYYkFGvTPXEFApM8LnitHL22uqR4+mmIWVb3qwwsFluO3nAnC6XuPlnQ2rlmQseC5ru2KLHceGcG210ZKuwLliQZQwHXCajtjuPNU80SrMRKO53fMUy8LcZsbuJ9vmEyVsa/2rH3590C/ZcuRdHhxgj9Lags6rPCM2xXovrNaeACASDt0ztmyrQRYl6+kFezyOi9vgm5zpsFvVlnoG3m8dDTBIKmSzSe4ychVqCcMvZripIdvuDPE7g9lf0lfK6Yr25Sn5RdeIA5gIC3RuCmcNKuQcWzZXC1k1TWbfUKVSiE4tubNCMTf+4slUgynmmbAw+KwKJEHSgi5pVlAy7+b/JZVitAAi+U1jqRlJW/PTjANs2DLqyct5wKqwRR4se6BRa+7bOwlyS7UGUYrR0RAYrwzsSVpG3Wun2s0uDRytnLWe+q45SgHgjqIl6J5Hq9AoNuQeHBYf2HyjarEPkZpV4UKHkixT6f44IPdS/PjyFun1JkrZn06vdp7DpK481WV0t90uuoOVapM9WC+p5dIY/y5yybivXA0zO5t1soclqP7RKxmxV0lYplmkRQvTM9icd5buSGRGy5MT6TZ9twU/7LPa6a6EzLOfsUuG2TTIQ7QmmPBuy2LJMVt/x1J2kVtMf2fF+j2tjpRE3SovXjkdH5pIWN871nT9u7NT72BWeImS0a7T1D72GxjOFPrmN1/EeccozM06xHJEoxYx50RctYSnhRlNrJExqM03KIYyVnRnLbtatbSf1YPi4AK0TNzxTWJulHJNWDgL0K/lB4s7n6w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5100.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(346002)(396003)(376002)(136003)(6506007)(38100700002)(2906002)(53546011)(6666004)(2616005)(186003)(6512007)(83380400001)(26005)(66946007)(8676002)(6486002)(86362001)(4326008)(66476007)(31686004)(66556008)(31696002)(316002)(54906003)(110136005)(36756003)(82960400001)(5660300002)(41300700001)(8936002)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QUZsZHRnSzF0RUE2NCtkRDBPaVlyOCsyUlh3eG01Zm1NdHRBNTFKb2FTaERY?=
 =?utf-8?B?cHhSV2c0MFp3Rkd5a2R0OEhCbFJFbytCd0w1L1FoRE9OS0k1b2FYK09ZOHZu?=
 =?utf-8?B?Y2RxSmJWbHhYd2RYNkRrOU1LaXN6NVN5dmVxSWgrUU9tdXVTYzJoVjFrQjlQ?=
 =?utf-8?B?RlFOOEwzZVhBdTd0RkJCZHhOVzNMTERnOWIyVHVyekNoSDRsbUFiU1VTUTI5?=
 =?utf-8?B?MzdvSVJBSngzK3AzU21zUWpsT2d5aUtzRlhXRUlhTjRmSUgyN2F0Uk5UYkRm?=
 =?utf-8?B?MkN1cmRnK0hoUG10WmFCL3VnN042V2ZGUDlFMXFMbXBBZHFsQzBxcU1KakdZ?=
 =?utf-8?B?dnU5WVVNQXFQU1Jyc0dLN2phLy9rRC9zSFFjT20zOHZidUxnN2xsd3pLMzVR?=
 =?utf-8?B?NjdkMTRSRXQrWnE2K1BJeFZtTjZZajB2OEVBaVJubjJJZXV1NzdWYlFZV2Vn?=
 =?utf-8?B?c09GaGdCbHFKWnJVaGRtY2JVZ2RFZEYrZjJ0SnExV0FmKzVVNmlpNmUrNjFZ?=
 =?utf-8?B?MjhVTUlZNEhXVDRRcWg0Njg5MnM1Sy9YUjZHUXJ4dGNPV1VaTXI0OUYrcTNN?=
 =?utf-8?B?aWc2bXU1Q3U3cGpGSTdmM3lyVjFqMzQ1d2lLOXJMSGRReThyWEx1ZTNtc3dm?=
 =?utf-8?B?U2gwYjJyRW5KZXYzOEVIS2hWS3Mvek4za1hKc1pqdXkrQ1BjWllheDFjc1Mx?=
 =?utf-8?B?TFAvMmQyVUN4bE53VzBVR1c4djIySGRhdnVXbmh3N3FlTkZRUlpObGlRS0dv?=
 =?utf-8?B?NjhWaEswSnZqY3lrUEhtTCtrQTRvbWJjZ2N6Vm1pajAyd0VBa2c3OStYaWdl?=
 =?utf-8?B?eFY2UmNTTFpheG1rUTVDY1NKNXh1Z0pjR1BnK2dlellkOFdhWjlGQ2FvOERq?=
 =?utf-8?B?Qng1N2RBODBjTW8yLzVDVWM1dGxZY3ZGUkp2MUR6NlhGYjZmd2Vod2xjcEJx?=
 =?utf-8?B?QTBEdDkxM09yeW5iRDMxSVBUS1BtMUtKekt2Nnd2ZXBZd1RORHcvamtEcGVi?=
 =?utf-8?B?QWJ3NWhOL3VzNkF6OUFnemZZcWFJMXJhWHFsU1J4OFZ3bVR3WGdTZFpqOGdy?=
 =?utf-8?B?cUxIRXdGeDFFVDNtWU03YncxT2xyYTg0blljcXpkYmd3cStoOUNBV04wbDNB?=
 =?utf-8?B?ZmpLa2srN2FTa3JzYVIyODhiNkc0YjVrcGdZY3BEeE5jUGczNnppZjZDMUZ1?=
 =?utf-8?B?NGZoY2x5L1BDaEU3NHJpL25OdzFtTmQzZS9ZRElSWURYOHB4bUpaNXRCMURN?=
 =?utf-8?B?SE1nc0w5Z1Bzcm9ESGtHaEJ5M28yelJleVN2NlhtOWkyc0RpTEJKV092ZkdU?=
 =?utf-8?B?eVc4YUhzZFluNUxHQlhORlpsbWx0amVtV2tQbXBGUkErWWJrRGdyL2FpWVVs?=
 =?utf-8?B?dm91MHN5bWRRY3ZSczVJcSs4N3lqZVRTZlg5UWdtck80ajNEU2VsVVovNUpE?=
 =?utf-8?B?TDBoZEc5TnZrWmxqY1pDbHY2cXlqa0U5SmFhaUl0NDNVMjJDaUVYTmdwS05y?=
 =?utf-8?B?dkZ3V3NwMVRCYjVzbncycG1qb3dSMktNV2pETTB3VW9veDdvY1kzY2Q0QUdz?=
 =?utf-8?B?dWVoazhpTmtFZlF3TlRqVkdjS2ZwTHA1d1JHUTFKbCtBUzFMREhaVVU3UGZ1?=
 =?utf-8?B?eFhiaVRsNjh2aWErSldyTXRBTXRmZVQyU0VBazhYa0piU0NUZm9aVTdLeWlh?=
 =?utf-8?B?Yyt6c0VDUEJ1Q2hlbENScEZmZWpJWUhocTNxQXVBVVNPVnYwaG9tN0J2Y1RP?=
 =?utf-8?B?SEZkWEQ3cExHNzdvamcxNEZyQkhEdGlKOWtobVhJdGJ2QUZCK2Jmd2cxR3pT?=
 =?utf-8?B?T3JpR1N0NmRPWXcxTWN5amZ1QmdqRkZFVndkUGlVTlY4L1crYWFGdDl3dHVI?=
 =?utf-8?B?ajVYbncwQnFNU1QyYnorSXR3WndLZi8rb21lV0t4ZzlzYTIvQlZqUVVHeEdm?=
 =?utf-8?B?NTg4dThQYVh0eFFnREJkR25PcmNOWUNKbDM3L3d3RVhSUkxOVmJqZnZWWFU2?=
 =?utf-8?B?TzZBcG9CWVNnVGdmMk4xcDZFQ3JVcGh6WDlQOGlsMm5zOXBNYWVjamY3RnBx?=
 =?utf-8?B?aUV5dEJTU3dXdmZDVVNlRmc3SzNzQ1BPK3lvNFBabFlZWDZEeWZlL1pHTDVt?=
 =?utf-8?B?bXc2V0VVTG4yY25pL2p3QXZOZXVMSnhscTM3dTdRNG1zU2dhei95VGxuU3J5?=
 =?utf-8?B?bkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 334fc03c-3e6d-41b3-f58d-08da89e9cbdc
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5100.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Aug 2022 18:10:46.8393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gXmvhS/QYc0TA22go3n/WUidBiBu3AKJ9jTmC7Q77DpJ+Ut+dvFXyM97Oa+zyw/mWga/8miGZRBsGw4mubZ+kmYF2sV6p69GZhPt9n98+SA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3283
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/29/2022 4:21 AM, Gal Pressman wrote:
> On 29/08/2022 10:11, Keller, Jacob E wrote:
>>> Regardless, changing our interface because of one device' firmware
>>> bug/behavior change doesn't make any sense. This interface affects all
>>> consumers, and is going to stick with us forever. Firmware will
>>> eventually get updated and it only affects one driver.
>> Well, the current ice behavior for every FEC mode *except* No FEC, we try modes which may be supportable even though they're outside the spec. As far as I understand, the reason we attempt these is because it allows linking in more scenarios, presumably because some combination of things is not fully spec compliant? I don't really know for sure.
>>
>> For future firmware, this would include No FEC as well. Thus, even with future firmware we'd still be trying some modes outside of the spec. I can try to get some more answers tomorrow about the reasoning and justification for this behavior.
>>
> 
> Yea, understood, but respectfully, I don't understand why we should go
> along with your requirement to support this non-spec behavior.

My understanding is that this is requested by customers for a few reasons:

1) interopability with legacy switches

2) interopability with modules which don't follow spec

3) low latency applications for which disabling FEC can improve latency
if the module is able to achieve a low enough error rate.

We have a fair number of customer requests to support these
non-compliant modules and modes, including both enabling certain FEC
modes or disabling FEC.

We already have this enabled with existing drivers. Of course, part of
that was caused by confusion due to poor naming scheme and lack of clear
communication to us about what the real behavior was. (Thanks Kuba for
pushing on that...) It probably comes across as a bit disingenuous
because we've implemented and enabled this support without being clear
about the behavior.

I haven't 100% confirmed, but I would be surprised if this only affects
ice. Its likely something that behaves similarly for other Intel products.

The ability to go outside the spec enables some of our customers and
solves real problems. The reality is that we don't always have perfect
hardware, and we want to inter-operate with the existing hardware. Some
switches were designed and built while the standards were still being
developed, and they don't 100% follow the spec because of this.

By extending the interface it becomes clear and obvious that we're going
outside the spec. If this hadn't been brought up this would have more or
less hidden behind a binary firmware blob with almost no way to notice
it, and no way to communicate that is whats happening.

I'm frustrated by the poor communication here because it was not at all
obvious to me until the last week that this is what we were doing.
However, I do see value in supporting the existing hardware available
even when its not quite spec compliant.

Thanks,
Jake
