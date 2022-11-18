Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF4562FCBF
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 19:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242804AbiKRS3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 13:29:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242218AbiKRS3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 13:29:18 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC5174A80
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 10:28:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668796082; x=1700332082;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vuId2G1+u7ol3eO3qRkpuZhRxPj+twkPBolwo095v50=;
  b=K5rxbab5KJvcYr7fnJedHjo0PN3QOFu9al7yQcurrKkdg/XL2t7u7lgz
   G/9qQbgMZMUto2b+U2QIfZnN6W3xvKMR5IvFIopobxk8tXh4HNNnLDser
   RJOmcfw2JkQ1zD2XtZcEBEBSEvoV+wK2cP9mMLRt0yCUxmslY0pGegdj4
   LvlcjQfpOZJ4wpQNI6QSRWR3iClvAf0AaYpAB/YIFAwgP1gklEIMfvdgg
   mrtVefF/lwkIxtgNZTWhcLoOA7cabXAUzqtFZcNcssOB0e0Gstk07VDGA
   M46+LQoin8dsdF8mQz3vMRHYeugMs3bV08hJxeSx87v/+nCUS72j7Ses7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="315022136"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="315022136"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 10:28:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="729318720"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="729318720"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Nov 2022 10:28:01 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 10:28:01 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 10:28:00 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 18 Nov 2022 10:28:00 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 18 Nov 2022 10:28:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hy3PksEumYzayT/1PW3TdghEFOE5f28lMgBaiR4up4a21Zz/MDktpd37oT8DiduX0AoizCMME0O3SRmzl9qbEyqWvQH8Xi4IRqOvu4xgzNmwISwxPiP94XMOafr5mMEatsvRwyns3o3gQBBfi16Or/C4wFy0MjbLVUs4HhgCpVI1q9iTuHaVY1aqY2ofveDh85evmT/fr9ceg+MYOd7OUTydXZcRzUYyEGkK6/OY25wQkVjI87KvI6MnIa4AupCPuuCX05rzkMeoJ/KtrUcZwsaJZaS2PGAg7wXLENNXVYsHdxkaPKOjR8RF9gubIeoxKh9frm6fLT5frpEF+8W/oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6IZMVqVFOe96ncFAhCpVuiF1oA5ufKQJFIufN7DdDE8=;
 b=X1P27S7VCzBBDLBZ9XUr9DXDOnkNmC8ccnjrer2OC3DnnGBQFgKPzBcpfPWqoslWWXP3YZ8RSaUXw019qx8SwIG7OOxGaYcrlm9gyg5SR0FO9/cB4VBFdIjvB/0PDx4Am9n+sVCbS4JQigqssPCxwFo4Dl9lYrSUeubbIrNT16WjZf4F43Mqo2AhJygv5CRZAolS0BYkG9fcexojpOpzqcF8rYrRivZuIRg6XCgpYhuSyz3Hq1uNBuU/ETsLiHly/rL09dhNFMNQVVy5ErhF7U6qv9uHbOSDalZy2OnbKj1R5yvAXrNCEYV7HohHtLhNTgVIgJa9i1bSdDPAnzcNLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16)
 by IA0PR11MB7354.namprd11.prod.outlook.com (2603:10b6:208:434::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20; Fri, 18 Nov
 2022 18:27:58 +0000
Received: from MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::a123:7731:5185:ade9]) by MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::a123:7731:5185:ade9%8]) with mapi id 15.20.5834.009; Fri, 18 Nov 2022
 18:27:58 +0000
Message-ID: <4bcad8cf-2525-bd7c-9d58-ae43a7720191@intel.com>
Date:   Fri, 18 Nov 2022 10:27:56 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH net-next 1/5] ch_ktls: Use kmap_local_page() instead of
 kmap_atomic()
Content-Language: en-US
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        <netdev@vger.kernel.org>
CC:     Ira Weiny <ira.weiny@intel.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com>
 <20221117222557.2196195-2-anirudh.venkataramanan@intel.com>
 <2310788.ElGaqSPkdT@suse>
From:   Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
In-Reply-To: <2310788.ElGaqSPkdT@suse>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::23) To MW3PR11MB4764.namprd11.prod.outlook.com
 (2603:10b6:303:5a::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4764:EE_|IA0PR11MB7354:EE_
X-MS-Office365-Filtering-Correlation-Id: 39c452b2-4a8e-4d94-d005-08dac9929e5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7OBpyhcrPx+T4TctRWSv7MCmOEZT2vOG7yah5yY+aWR0JtrbQjHLPTdRjkBHt6JkjzgJlGgoSjI05EW/9PRLXJskM+ZuDQecQHh25gCNYIURxCA7B97pATdxhPtE73UsH2RyqtIry6bFhMpml5wrF2+cyGCFASQ/PnGfXjK4vxQfg0aludrkE7stAbAH9Izf9B6JeINBEuT2PcobSZlmyFO+2C6tBabL7WbfBSSvOXeBXOX0Ky+6toOiGq5n3P2r/oht1ZyY0DiHxmjdmoQXXm4eDYDsFPzu6guSV6sb3pceYrlZZLOrOxAvcCsXnR+lg28qh4kBnCsNDgAmw237It6rUlTb/Z8Ha3IbalmPvs9tFNbxzptcxEWmRgf5YYYhal/i2tky0nLjL031cqM03oBkXOjjGdHqHa9WH8C5qYuCHChHj16d2YWgdXtxXc9Zf8tloQiAmBBE0Wuy2gg2HQNza6x2RlaRwVlOnwQgucQH08rRyv3i6g9uDh2j4tLvYZpTSSdGfKe39rhy+5xUFzynOVM+VL5fB7r7b5qKmPiMZmlerMmA/VqT9piuzJpCAxaGFbMIia9Jr0ArmN3g2bF3Nz8IQnAiT/vOwiCpxgAIXJYRdSfPMaiFyPHjHKP6CpNOpvBaLruhsb/IJI3iH6KoQGokqoPQShTpYIEaGzdvn0g9OiUHqJVIuYl9XKO28hRBuIR2VzObwssMN694L6qir6063lbyUPZwvG9DSnc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(366004)(396003)(376002)(136003)(451199015)(31696002)(8936002)(86362001)(36756003)(41300700001)(66946007)(2616005)(44832011)(4326008)(8676002)(5660300002)(66556008)(478600001)(6486002)(316002)(186003)(53546011)(54906003)(38100700002)(26005)(6506007)(82960400001)(6512007)(66476007)(2906002)(31686004)(66899015)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NkQ2Zk54dU5PTEJ4bDBraFE1YS9VV2hZTkNMRGdPRkVCdGdtbCsraWNnMFp3?=
 =?utf-8?B?V2dYT0dTcjViN2hNenhSTExJZVBuRVFuZTNxK3F2bDc0SHZTRHU5TngrK2N6?=
 =?utf-8?B?WGFPcEFzYzFvNERva0lvV1MwRDBSQ21SQlk0ZkJCZzdhZmltd214M0h3Ympv?=
 =?utf-8?B?SU9zRjl1ZWdNT1d3Nzdqd0QwTi9FbmVUQ2VGMzlQN1UwOHAyUlhoaGZpT2RY?=
 =?utf-8?B?OC9vUXdUZ0JkSUNHNDN4UkJ1N3NaR1grMUhtVkg2YTVMNW44V2dOY2JwNHdu?=
 =?utf-8?B?R2ZycmEyd2JjTHVEb1NRcVhmeUtiSHBBakcxS25iaHJnTklQa0J3NXRpUTU2?=
 =?utf-8?B?d2hJeFJ3Tmk1TGtIeFZoNThTVTBnaGh5elBSL3F4ZFJORnhVcjBxOE5RcUJ5?=
 =?utf-8?B?RW5NVG5rLzljTlE4N3hmZHBvVG9ERGNjbFRpSDNjazNGbTFrRkkzWEFGODdu?=
 =?utf-8?B?OHZNTVY3bXg1ajl0cEYxaEdmNWhPQ2ZRMDloaVMvd1BhNENxclBXS2hJdE5u?=
 =?utf-8?B?NTF1cjduakFMaFAyTVpOMWNRT3Zzc0cvYnRKb0R3R2ZCajB5dFZHRkFJSW8w?=
 =?utf-8?B?b2RERlp3KzJnbDY4c0R4ODhUWkxISi9yU2hDdk1kSFhTczBnMm5LL2hTYTYy?=
 =?utf-8?B?K3hQWDRHNVNGUkhBaVZXelhPOGk4OCtPdUZBbEFySzFta3lkSzBGV05RamI3?=
 =?utf-8?B?VXJqM1JLMlNSWC9wbFFrR2puRFBnbjRKczlnTUhhOTI2K2gyUTZTbDREdCsv?=
 =?utf-8?B?cHZoSjVHT2tlRHFzbkhseDFRSDY0eFBnTjU2Y216UCt4cWxnUGoyUTNaR1dh?=
 =?utf-8?B?amQ0ZHVWcWNET3FTR0k3TVM0MjVMMWlyVmpDRmpDVXRBL3p0ZjdqaFJOanQw?=
 =?utf-8?B?OWdCdk5MWGlUcmJzUVRGTHErTWJ1YzgxVitMSXEwang0cWxPT0NzTUgzWlFi?=
 =?utf-8?B?VFczSGI4dFE0ajN5OFRESmI2M0ZZR25RbHNSNCszQmdlVFNjNVllbitEL2dD?=
 =?utf-8?B?Ym9sUXc3cEVoTXBQeVdvSGpNeUYyOHd1c2lWdXNtYnNxVFR6TU1JSDkrb05k?=
 =?utf-8?B?ZXFqR0xScnJXTjBYbkt2TUYvRXFpb2hnWjFlOGxVa1E2cmJFUDlyOUNhdjV1?=
 =?utf-8?B?OFBTRlFxeFg1clZHWnFQVklpOTZ6dG1Wb1lYdkQyRkE2ZVFjL1dSMFptQ3pP?=
 =?utf-8?B?Q2xGVVVPd25KdFF0VVNhSVRqS2pPMlI2Nk5kN2toK28ycGkxWVJCcHc1M00y?=
 =?utf-8?B?UEVuVDZtOHRxQk16Z1BRaGVjeDkrdFVXeTh3WHZPeFBQM0tKSzdqNGlNQmVR?=
 =?utf-8?B?bG1adHh4b3pGYTRsZ0NHMjVIS1Y1VFRDM0g2UFp3ekdxL2Z4SU1hZ1JIR3Jv?=
 =?utf-8?B?QTdOS3hpQ014OWNPMnU2ZUlGdGZaMGJ0MTdTUXc1TjhWN1I1R3lZRWdxMTFP?=
 =?utf-8?B?T0VHNlpaM2FmOWFlT3MwSEtoTHMzNDh4OHpKcnY2NWkyeHB4TlFHRmhNeGJO?=
 =?utf-8?B?WW85VmZwSzRsVXhnQThoTU1LRTl5bC9nMHZCUWpST25WWU5BcG94VVkvNUlk?=
 =?utf-8?B?anNrSFErdmVTUDkzeXhqQ1FkTS9lbzhwUWd5cTA0Q2QySGxGUlh2Vm1POEpy?=
 =?utf-8?B?Z2NqNHJ3cWZnWUd5Uk14QVJjWWxzdEMxVC9pSW8vd1QrNHlvZHNQMGpwNnlk?=
 =?utf-8?B?UzBpMDQ0U1Y0QVZFSUl5WUU0WGE0Ymoyc3V1b2M2RW9WbkFFZHBldnFjVlZO?=
 =?utf-8?B?WTdTRlhQL0xicDNyN2xiNXQySkxiT2VUeFZneDZmSC94R2h1RVFkUXJWSk9u?=
 =?utf-8?B?NHVCeDFVdFZja0ZKdGpZYXVpZ1M4RDhuMWdud0dGanNNVWJnTXo0NzVZUW9k?=
 =?utf-8?B?WG1Hc1BXU0syQkhiam54T25mdUZUZzB6SkdXbkM3aWpkdDdoY3FDbzBtbVMv?=
 =?utf-8?B?TjFMMEJ6ZUJaUDcwcWw3ckZIUDZZamRnVkVWYWdqRlRwRW5OSjF5Y21EMnBT?=
 =?utf-8?B?MmpndkdJUXJkYnMrS1FCc1BnM2ZxSEF0QXdNRyt6QlM2OHowWi9xbTZvNWJi?=
 =?utf-8?B?KzkxRWl5SXZlMGxRbXdKZ21WM21kSTRrVmoxK1JodkdIejhrTGpOR0J6WGRP?=
 =?utf-8?B?ZTlnckRoUWN2VFN1UkdnbkFsQStRVzA2ZStQcXBNRXIrVDFQVjhQdFdFcFhj?=
 =?utf-8?Q?9+5qUsHpNV6ctRTC/K2hxTg=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 39c452b2-4a8e-4d94-d005-08dac9929e5e
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 18:27:58.7486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kvxij7HYSebEGeXtas03CWS4xs+svybWejVZaJ6U3p7t0myDB35NPXncyfFONIinwSXWZOkw/fZnuHVGMabCEVsqxPZzWJ2a0sKew9+E9+/UrUNxNFdjOifwLDdh6qTk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7354
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/2022 12:14 AM, Fabio M. De Francesco wrote:
> On giovedì 17 novembre 2022 23:25:53 CET Anirudh Venkataramanan wrote:
>> kmap_atomic() is being deprecated in favor of kmap_local_page().
>> Replace kmap_atomic() and kunmap_atomic() with kmap_local_page()
>> and kunmap_local() respectively.
>>
>> Note that kmap_atomic() disables preemption and page-fault processing,
>> but kmap_local_page() doesn't. Converting the former to the latter is safe
>> only if there isn't an implicit dependency on preemption and page-fault
>> handling being disabled, which does appear to be the case here.
>>
>> Also note that the page being mapped is not allocated by the driver,
>> and so the driver doesn't know if the page is in normal memory. This is the
>> reason kmap_local_page() is used as opposed to page_address().
>>
>> I don't have hardware, so this change has only been compile tested.
>>
>> Cc: Ayush Sawal <ayush.sawal@chelsio.com>
>> Cc: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
>> Cc: Rohit Maheshwari <rohitm@chelsio.com>
>> Cc: Ira Weiny <ira.weiny@intel.com>
>> Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
>> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
>> ---
>>   .../ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 10 +++++-----
>>   1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
>> b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c index
>> da9973b..d95f230 100644
>> --- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
>> +++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
>> @@ -1853,24 +1853,24 @@ static int chcr_short_record_handler(struct
>> chcr_ktls_info *tx_info, i++;
>>   			}
>>   			f = &record->frags[i];
>> -			vaddr = kmap_atomic(skb_frag_page(f));
>> +			vaddr = kmap_local_page(skb_frag_page(f));
>>
>>   			data = vaddr + skb_frag_off(f)  + remaining;
>>   			frag_delta = skb_frag_size(f) - remaining;
>>
>>   			if (frag_delta >= prior_data_len) {
>>   				memcpy(prior_data, data,
> prior_data_len);
>> -				kunmap_atomic(vaddr);
>> +				kunmap_local(vaddr);
>>   			} else {
>>   				memcpy(prior_data, data, frag_delta);
>> -				kunmap_atomic(vaddr);
>> +				kunmap_local(vaddr);
>>   				/* get the next page */
>>   				f = &record->frags[i + 1];
>> -				vaddr = kmap_atomic(skb_frag_page(f));
>> +				vaddr =
> kmap_local_page(skb_frag_page(f));
>>   				data = vaddr + skb_frag_off(f);
>>   				memcpy(prior_data + frag_delta,
>>   				       data, (prior_data_len -
> frag_delta));
>> -				kunmap_atomic(vaddr);
>> +				kunmap_local(vaddr);
>>   			}
>>   			/* reset tcp_seq as per the prior_data_required
> len */
>>   			tcp_seq -= prior_data_len;
>> --
>> 2.37.2
> 
> The last conversion could have been done with memcpy_from_page(). However,
> it's not that a big deal. Therefore...
> 
> Reviewed-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>

Yeah, using memcpy_from_page() is cleaner. I'll update this patch, and 
probably 4/5 too.

Thanks!
Ani
