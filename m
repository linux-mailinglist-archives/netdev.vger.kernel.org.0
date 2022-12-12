Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E06F64A76F
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 19:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbiLLSqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 13:46:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233224AbiLLSq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 13:46:26 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79519F3B
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 10:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670870774; x=1702406774;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=M9xQy87buGhxgjpgZNR/hIJWetwo6VCu/2uo9GwPriY=;
  b=WuH52WIFl5W5R5HW2DRZkKm3Q2gx1lGY5whH9sD8mgVxC90ruS5NenjT
   zXB8bZT+rVJGhhOt4CuPTixu7QlT5JrEMap1mrpPcQbSO8xrc1qbC0BHA
   BeSYn5aegbqzMqkR9vx4bnoiqUh2FNtSLeJAF8Nvs1CJrzIY+56TlCqVt
   h4bmsGYjKWUCXwyEAnRf18RJUCr89v204o6ehCbocSaDP3b9IB5QtgHIH
   PoRFvc17hQtpFLbIvT9A8dT64R4hP1cKoJOQ7Xz26Yu2bpjyYgNQs3MhL
   wG5abNOfPAqloDvp+atHJUQW9KVF86+hux+39SP8wceaYs1kP8PMPEItn
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="316632377"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="316632377"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2022 10:46:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="790601565"
X-IronPort-AV: E=Sophos;i="5.96,239,1665471600"; 
   d="scan'208";a="790601565"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 12 Dec 2022 10:46:14 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 12 Dec 2022 10:46:13 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 12 Dec 2022 10:46:13 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 12 Dec 2022 10:46:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mBEaOx3wvyn4qrrQ5DoTmXM3vB3UjkfQAX21Ei2GmY09WFD7T8R2NeFDYBS3ow2qLbprCDd84K4q0UAr7uDRZ/pZmb3tYYZTKH7AKYDbuu/w3+xUkE6RyOBemPMlG4IlcX6S0+sGRFjSGACE1EpnMcvhAlaVpchzuqdoez0e1vUvo2SyvwXkMAPX8fxMXzWmxKTolM0RtAuft6c+9OSAggQdplQKZxxooJDDujNMIOL41Mh1AKg4Yky26EJ6ddeZyF4T5Gu4rWl9nD5MI1lWGemG8bLZ3uxuf/nd+ZepihRlXh/3mUe0T+xHcEbs/YSu1lz8XSfHenvH/0VPJGyhig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/hXDeWH/iMXgc7FoPj4J6iRkOh9FcFl5zUZ8o+zoJI8=;
 b=mFcW1vdCh5YVtC/0hZBeMp1K2iLBMuAyMt+HbJR1srR9XpP6S6sTvi1T7ECAGDCfJ6dVSZMgdiG0QlWMBTOfIb7+fQVT6KvlqpjR++LZ6+mSIy7E6QO1WKFo5FDaEn0eo8Jfjcio2LyD44tvYX5jSeV7vuqJZFyLzgkpxxEHqRBRh1ptJQ+NP0QYZE2RCLMkO5fcLK4D3VqJAODpS9vEpfPmhwrNhw2OheaGevPbCzy7yV5KY0xRUtuwOkwRkYnybXcbz+heGkxXlr7+Rn9w27XqW+7hCzvf7shpOCoC/FCyz8vRxKVNDo7iHePgnVkGgvJ0euYRO39Jdjb15MIUCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB7784.namprd11.prod.outlook.com (2603:10b6:8:e1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 18:46:12 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%5]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 18:46:12 +0000
Message-ID: <f0078f0a-acbc-a9bd-effd-6d04507e71e2@intel.com>
Date:   Mon, 12 Dec 2022 10:46:09 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net-next v1 00/10] implement devlink reload in ice
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <alexandr.lobakin@intel.com>,
        <sridhar.samudrala@intel.com>, <wojciech.drewek@intel.com>,
        <lukasz.czapnik@intel.com>, <shiraz.saleem@intel.com>,
        <jesse.brandeburg@intel.com>, <mustafa.ismail@intel.com>,
        <przemyslaw.kitszel@intel.com>, <piotr.raczynski@intel.com>,
        <david.m.ertman@intel.com>, <leszek.kaliszczuk@intel.com>,
        <benjamin.mikailenko@intel.com>, <paul.m.stillwell.jr@intel.com>,
        <netdev@vger.kernel.org>, <leon@kernel.org>
References: <20221212111645.1198680-1-michal.swiatkowski@linux.intel.com>
 <20221212101505.403a4084@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221212101505.403a4084@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0084.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::29) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS7PR11MB7784:EE_
X-MS-Office365-Filtering-Correlation-Id: a93665f5-dc01-46ed-6d74-08dadc7123f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WNrh3vgbp9niQ3m/uqc8EOCDgTDph4Wy33S3qh4lqzDKWSyKOzAnroZVyIyYaBNFcWkQDO+Ib3zlgIJCAyRnZy0RWPBaG6+Ax4XodW+tsikZ966jrRBCuda+238aqNKGN1M4hNxl5fKg7/ZcFv/hOg17MrReaOYXbH0aHfxv3+zzixQOIykreeT7CrmvSVzWbrnA1ndIvIiO3/bnqjGoy6eePBOSTwzQhfZfYuK5uacAyS9pDEXm0zQeD2UVPRwt9kBw2EOluhjtLotaskOSSoMuHZHysgvaiQPTzbPd/XH4aSnCRkl3ar/CyM1XduoBi6+urA0ggrtZScrHkJ90EA6w+G1TomOQhZlcioqyWypRASXctk1x5qKYawYR45qkaXTObGUbJW9GM1FmB4WfxpCtrcG9h4hUH1MiI0YL14o+DfD4kZi5BTiak6jtmTm27yonBM40Od871DDWN2nnhTGLv6v4HJfxOsHx5TVpmHpWU0TVotTFcWz7GtJq28/2DYwulAD/hZp0rhKzZdQRIrk+5mkIxoTrdaFhi4J4Y5vK3EtScIc67oeie5uhnf1w22WXi70kaxcAumapJLoOKXLTItp0u2zJu8Lzr8x4UbmbbX0jAeRIXWgwuNTm9aXwtmTYufxk4L6OplSlXHMyKv7glLMy1iMUla/legJYG8ed6r7gIfWsvcxjbx38UtDIDxw0DET7Ugav9Ahw6WMkzd0o8UBC5hHoqnEe+paVd04=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(396003)(366004)(346002)(39860400002)(451199015)(31686004)(5660300002)(8936002)(4326008)(8676002)(41300700001)(2906002)(53546011)(36756003)(316002)(2616005)(66946007)(66476007)(66556008)(110136005)(82960400001)(26005)(6512007)(186003)(6506007)(6486002)(83380400001)(86362001)(6666004)(478600001)(31696002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SGRKTno3bkdVQzIvUnZjOUxiUUtHTHNDUWovbVVqZ29hY0grVDk1OGVCeFVU?=
 =?utf-8?B?QlF5bjhVNFBIMlJKbWlmNm9CcENLNlVxaGRsVStTSmZjcEM5eXF5SSs1WHRw?=
 =?utf-8?B?Y054U293Q2RFU0trL1VZWXpNYVNmNmhLbXZPRXFDVzhZUUd5a09HT09UWHJq?=
 =?utf-8?B?T1I3VnNSdTdGNlNwMk9pbmVhVEVVOTNYYytVNFl2TEwxWDcvV1FsODRYUksy?=
 =?utf-8?B?cEpneE00NUlEa1RzUy9oTmxTbEZyanJRWTdzUFhVK3JuTTkweUt0aEtlQldI?=
 =?utf-8?B?Y0pGZHBwcFc3MmlaeUVaWXphdmkwbkdtZ1duUHpJdiswSS9UTXNwWmtONzZv?=
 =?utf-8?B?d3BCdTFiSXhHeWxIQ3ZPd3I1OFN1TXFUOHU5YTJsdnVtR1ZFWDYyK01vZzNW?=
 =?utf-8?B?RGFNeDZIbFMwVktaVEJqM1JnOEQzbm02VHJySTRRK2tvQXJzV2Ivd1RFL1Fm?=
 =?utf-8?B?OUErS1RUYUtGWXNUR3l3NTMzYTczUjBSTTZ1RnF3K0pHZjJ6azNZU1d4NmNz?=
 =?utf-8?B?Z3JyNHFQNmdmMzh1TVF1dzJWamtrcVRXMFNiUHp2RjdnK1QwOEg2NDl0Qjg2?=
 =?utf-8?B?RVpBcmNLYmpJNzU2S0dJTE1CTEhBbHBEa3FMbHRaQS9XWkJKL1RaQ3AydU84?=
 =?utf-8?B?dnpZcGFDenovaVU3RFc3aEpERDhWZVpiNVhTYWgreHFGUy8vL05ZYWV3TzZG?=
 =?utf-8?B?cXRiVlF1YUkycWRsSVJWYmF6TWNSRkUyRXByRkEveDVnc2lnUFdoS3JVbVBl?=
 =?utf-8?B?aURPQWdHZk1kemtiZEpkYkU1b1VtK21jZE9Zek8zVUNXNXlhVFk4TEU0MDVC?=
 =?utf-8?B?SFhJanc4RnFJTFlLZENiRjBZRVdJSCthcFZuUjQ4ZVBUS2U3bWpZd1RoSElz?=
 =?utf-8?B?a0pDNVpKNlBBdDYvK2FUMFVUSTNGWklOTkdGOW43WWEzTlNJMEdCMXB5VlRr?=
 =?utf-8?B?ejZOeFpSOEp6d2hxWlRQOUg3YUQ2eFlxeHR3K3g4cFd4YUMvNmNnTVFQUmdG?=
 =?utf-8?B?UzVlU09yaEF2MHhWSlJpTG5XNFVoWTlYWXNxVSsvbDc1SGcyWVRaZnZlNmpB?=
 =?utf-8?B?enB2K1NlWXZuZG9OUUxwSzIyaURhMmh2QXdTcWNHcyt3NEI2TnA0WG53Ym5Q?=
 =?utf-8?B?MFRJOWYyaXFoYUJXLzBnejl5SU1BbHhUT0lJeFZyTWJwdWVoOTVxZEtPMCtX?=
 =?utf-8?B?WE9yWlVIdm42bElYMERkUE5CMHp0dk00RWMyajlJbDNFTEtIdHlhSUdBL1k1?=
 =?utf-8?B?K2FMYVdpUGhzOGx5a25qQXRiTXQwZC91US9iZG5qeGYxQTd3VHZmTWwvVGxF?=
 =?utf-8?B?d1JlOENCdndtT0I1Uzg4OUo4STRreHpSUkt5LzlGbWFJMDlLV0V3SDcvSlQy?=
 =?utf-8?B?WS9aNC9Nd1FuSC9XR0QxVTR4NkZyQXBmMVJKSTNiNnJKYnNxRy9NTDNPbUJS?=
 =?utf-8?B?UEJyNnhzWTlmYmNqL0xWQUEvNURVUUlaSWQzcUNmNk1DbElqNEVXdWJFTzFS?=
 =?utf-8?B?aUxhTm9HSGJEMFFlbEpNUlFKbGR5UnFhY2o1Rk1IQytkTGpNWTVHd3JBVVRV?=
 =?utf-8?B?OUhiN0NHcnphR3JxUU5KNTBPSUdIN2lFZWFXMHJKNTRUVzZtL3FSbTNxT1Rl?=
 =?utf-8?B?ZWpialNxYWlTUnVhdFMzMHhvVnlKb0VLQlVLYzRqcjZXbkM2ZVR1SzU5dWFO?=
 =?utf-8?B?T2JCS2ZQeGRJd1ZGZjkzb0FXSzZyM0hzYlhSSzdVK1RQMTh1VVdKSHhUZHZC?=
 =?utf-8?B?Qi82MUpMSjhEOVJRd3JMUmNFOWVBZDFiODcvZXE3Rzc1UW9GUXdMRkR1TEFy?=
 =?utf-8?B?NmJVVmtwMFRZVTUveTRXSldaTUo1TGdZNWI2L0hMaG9ZdVFoSE1tT3pKY1Bw?=
 =?utf-8?B?bjViRkE2aXN5WWVhY1ZmMXFjTjd6QjNoeFkyUnlWRjROVFMwanRFd0M3Mkho?=
 =?utf-8?B?TE5Fd0prY1FhL1JOckU1OFBEWkRvZEJISHJOY2R1SUk2aHY2WmhhWis2R1Jo?=
 =?utf-8?B?bHZ2YVZPZnB5alpVa1JOTG5UT00wU01JTWFXa0xXbUJFWXlyc3UrcWNDQlU4?=
 =?utf-8?B?NHdmbkFYK3IwMVQvZmdOdGhwOFAwajNFc3RtMjA2Mm1iYkRzMC9YQ21PU3Bv?=
 =?utf-8?B?cXppdTVRN1NqSXA4ak13bzA1aTF3NTlDbXdEdFh5SXFTNXRXSEk1RlRSZWha?=
 =?utf-8?B?cmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a93665f5-dc01-46ed-6d74-08dadc7123f3
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 18:46:12.0479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mqpnLPY4TD4/WnrwcihxcaUS405B67FibvtIx9E1L2XolS3So21dAw3MNRP0m5jZBLwNNnqx4XfJnzbmxV2LEip0sjoQzO7QPjtHjRXp/yM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7784
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



On 12/12/2022 10:15 AM, Jakub Kicinski wrote:
> On Mon, 12 Dec 2022 12:16:35 +0100 Michal Swiatkowski wrote:
>> This is a part of changes done in patchset [0]. Resource management is
>> kind of controversial part, so I split it into two patchsets.
>>
>> It is the first one, covering refactor and implement reload API call.
>> The refactor will unblock some of the patches needed by SIOV or
>> subfunction.
>>
>> Most of this patchset is about implementing driver reload mechanism.
>> Part of code from probe and rebuild is used to not duplicate code.
>> To allow this reuse probe and rebuild path are split into smaller
>> functions.
>>
>> Patch "ice: split ice_vsi_setup into smaller functions" changes
>> boolean variable in function call to integer and adds define
>> for it. Instead of having the function called with true/false now it
>> can be called with readable defines ICE_VSI_FLAG_INIT or
>> ICE_VSI_FLAG_NO_INIT. It was suggested by Jacob Keller and probably this
>> mechanism will be implemented across ice driver in follow up patchset.
> 
> Does not apply, unfortunately, which makes it easier for me to answer
> to the question "should I try to squeeze this into 6.2"..
> Hopefully we can get some reviews, but the changes seem uncontroversial.

Yea it seems a bit late to make it into 6.2, as much as that would be nice.

We can always hold and test it on iwl until net-next re-opens.

Thanks,
Jake
