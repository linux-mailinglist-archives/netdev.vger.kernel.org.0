Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE4B9632B7D
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 18:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiKURw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 12:52:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbiKURwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 12:52:24 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B625D2F62
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 09:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669053143; x=1700589143;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UVi2Pfi2w5Tlou39w9jQVHrfrrru00tV2nSKjHOxBOQ=;
  b=AbXd9XpkOVYxfLku2EBR2y/kFQNZ1gOoGUou6jvMMMfvVkw3y7YoFhZk
   tbz6LTiqFd87QYCxE+1V+8NhaeWrZn4Y9nGcD4SlblPyu8vh5dk6i3z5U
   ociKcDsZLedtJe1e6W3QmS8PvcWrcThGSSifZyPfNODwz9ywEkE46vdmt
   MxehyPT8ZhVs2HNUi9GK/Nt3tPdD4TlHG2H7N1RwCIWDpodyPs+pwHWih
   URYbh5OrBbWYWzP8j0MU1Cp6h5D/D0RhqBsUOTkOMWVtWJJFLzcCFS9SW
   8FiFJNksg/oKZR5zzfE+VKHMXUBP/7yiwj7gj+nz4FPKFi9etxg/Zt2Ld
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="294010449"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="294010449"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 09:51:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="643406379"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="643406379"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 21 Nov 2022 09:51:51 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 09:51:50 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 09:51:50 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 09:51:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ACDY3Ol5QtWwLiEynSWJJQsoOmV/HJ6FrHc0P9DD2O3zTGO8StDsH5lglle4CaEXjqEAJnMvM9wZNeFhvdIsBrjXainrMvf3AgPpOVQSYyN1t7wM24r0NtRB5gla4jV9nUltwU9lbRESw5PSK0PK1iVfnNnQ24uIGiV16+LeDb7R3X0uG2Mp+kdfaxDpv6NhOA6ff8yMv2L4ft6J4SZxerFUg9/aC20WKzpL7MxsQNvkFL752KsDd9rc/DN97S3Tq47cl6N4PN0ohStePndX8xulGV8bYyuMOD0sLjj/IxkOmfELk08z0pCVyNoTDiO6tdgtUdKegPpzkSqxBDor1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Am2YRX88ylcjwAkCUS4PLt4hXdNHlGM3ecw0AXZ4GtA=;
 b=D08Acl8MCuzMSok0I8Tmkj+Cng7wJ7EvrJwdLVkd/deFqyUAwzNB4wt5jy+w4xplf4/+6yqkM14W84IvCSpxrfOdS4H9CdfPzuU+xZDPmlxNoaRMWxq8Tmv1h0Pj2x2dOWJ+Wxk18un6uFW8mmzP4uX3r58lowYN0TQb6KerGRH6q+UrJ3gyunhxorinQKvF/aaJUiiaZkNTPSDxdM0uHaWrQA09O97pMVIWo6miT4dpWqXZaBuQtrN5qA28BuDi8Eh1DfxdgJBw7plrQdzK615UWMQkratmEqY+RP5L4SxMN3xIBn3RHJBz2gb2af0ll5tK+XDNCJ32Ae1aNOw6ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA1PR11MB7063.namprd11.prod.outlook.com (2603:10b6:806:2b5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 17:51:48 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5813.017; Mon, 21 Nov 2022
 17:51:48 +0000
Message-ID: <753941bf-a1da-f658-f49b-7ae36f9406f8@intel.com>
Date:   Mon, 21 Nov 2022 09:51:46 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH net-next 2/8] devlink: use min_t to calculate data_size
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, Jiri Pirko <jiri@nvidia.com>
References: <20221117220803.2773887-1-jacob.e.keller@intel.com>
 <20221117220803.2773887-3-jacob.e.keller@intel.com>
 <20221118173628.2a9d6e7b@kernel.org>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221118173628.2a9d6e7b@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:a03:254::29) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA1PR11MB7063:EE_
X-MS-Office365-Filtering-Correlation-Id: 66545b7a-8ff6-4c79-58fa-08dacbe9102c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jQXM53NVykIUEKe1f9uLFsFjQS8/VhfMy/NW3f2S+K0zaziklaul+v+as3IkXd7+nazZxsgXwgePkwTr/ihHqfw7VdDzfisLEvxOhZbXFOzOZ9q+/vna57A6fA6QxAPzM7yRjwC1p98c86CN6uh6h2YgftYsL6fKV8gYwX/GpfLRrnbn7wwSx7kW4JgkYjL3KnHzISulfznETHgyN2XQeMrn9zZ2773sUMtuhhF2+GhJZXVus7/AA6D3uLCz9k8AloVQZktLW4lz3mN6eiVlf0LcllPxK95zDgNxRL3VklK1T7nMvoWJV3WHJ4GlkSQQulu2NBq2jwn5c5owQUMaQC/I07EHxVnUVVwqdxijCHmE0OCLBwtsVYrXGKcfqyhoyfWlJ5WJNG2yci7ojZmHXRIpw5Tb+id2W2wJXhZCoTjn1/NAyeWunzv3aT9MyhEoSBxUw3WxaINRj9JLGUJXEgKcNlkCWfs1LSzYtQys9RxzCPAI17U4oOhww+N3pKK8aoV55klLzgewaGRcayh/gQUIleO9le4d0NQ615s1mZmLHTlvpN6UCOjEhUh3VkvxSfUMRq0TSR77v487Bowzg5t7gngFmrYcPeHgCeuCD3coJJRLYK7yAfXECeFm7ehrWCmIhQ4exlpsKJ8apo9/fjuzLgqMPzLjp5Mc3r8ZRZGjNGwVWc/bakA//oISzuSc3mFBzg7lhK5NUj8MpGaF9usC9xn1ThT2aUJbkLAwlEw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(396003)(346002)(39860400002)(136003)(451199015)(6486002)(26005)(2906002)(36756003)(6506007)(86362001)(82960400001)(31696002)(478600001)(83380400001)(6512007)(38100700002)(53546011)(2616005)(186003)(8936002)(41300700001)(31686004)(66556008)(4326008)(66476007)(5660300002)(8676002)(66946007)(6916009)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0ppNTdkSnAxT3p5Q0VONzc4S0sxYkpVckFGbEVJanJ6RnI4dFY1TFpHWjJx?=
 =?utf-8?B?VEExR2NxTEg4ZHZXbzNsajVwNVNWVHl2RUcrTmtvblFsamY5RVpXekRLMnlI?=
 =?utf-8?B?cGtndnh3d1BCUFdIc3htdlZpWmRka3NDZ2JRZ0dLVTBBTmlyNEY2WWRUdzJz?=
 =?utf-8?B?UDh1T3FQbWQ0MklEVURiL3dERzJoTlhpa1B0bmtmS0dyWS9WS2JqeDlWQ0Ry?=
 =?utf-8?B?N01JeDBmL0xYR1FFai9TYmdVbi9nbE8xT2ZtWlJqTVk3VnM4R1htcTNGcDBJ?=
 =?utf-8?B?UFBIaTlFcHBiUHZYb2ZRNzVnRS93emxIaFJTazBXdXFWMTdVQmtJekxpVXpn?=
 =?utf-8?B?M2xpOEd4VEI2SnV3R1c3bU01VEFoc0RYTE0zNGxGbG8wY2NGL045WkZPTE5T?=
 =?utf-8?B?L1p2TG4rZmd1UThmaDJRd0hCL1RzK1VYR29YVjc3TEtVSUJlV3VnQzNHVFVn?=
 =?utf-8?B?Uk9QaW5oL0dlZUExNFJmbzA0VkZnWStCRExJSk0xUC9MbEZLSERLeDU3Qk8x?=
 =?utf-8?B?ckNIZmJLWWF6TmVxRWpSaTg5YmFBNVlKSUZVY3J6SzVRbUVVbkNabWVhZE96?=
 =?utf-8?B?OUw3Nml0UzNoZXBidU00elQ0WmpVNnZUMnVnSDhrYkxQbi9UNjltWjFJbldj?=
 =?utf-8?B?SU00cWhiMUtwU3dRNHN1bHNTenIzbUdxZ0NMcXQ5T2dxUTFaeFV3QWdJYS90?=
 =?utf-8?B?MmcwV1ZpTE1kUzRnSXVlME1RWHNwVUFTdjJlSHFzTmVnT3ZCT1kvWHN4WnV0?=
 =?utf-8?B?eFNhZlE4V1Z0cjJzUFplQzJyRTBVbDNHcGNJdWI2YkFIRlBJMldZUWcrSFQv?=
 =?utf-8?B?SHpqVXdpM05sR1lQREpnNFhNSGNCN3lNWU9PdDAxbFIwSVFyL0ptdEM4SEQv?=
 =?utf-8?B?SGxsbHRFZkoyeFNtMC9GVUNRY3FiZm9jTW1DL2g3S2lEeUlZdGNCaTlwbXQv?=
 =?utf-8?B?U09JeWdmRzdRV1NJK095WVB3bm1Wc1cvVm12OXNWU252RUw1OGs4L0kvM3ZV?=
 =?utf-8?B?WTVkSGp4OTNDOThvQU1lcnFHd0hUdGFCaG1mVUVVZ1doMFFmSzFKUFZqVCs2?=
 =?utf-8?B?S2lJZU03ajY0THhJdFk4REJ0TDdnSTRESXMzUGhWa1Mwdi9YbVdSc1ZuQUJK?=
 =?utf-8?B?Q0NXbTY2OXNLQndHN1ZPN1gzdU03RnZ2dHVJOS8rclcxTDlLbGlBTTh5dlBI?=
 =?utf-8?B?dDZibmpKeFczNVNuZ0MwcVJIMVJwb0F0SzVrelJVWWdndnNqcSs4MzBIdEV0?=
 =?utf-8?B?TDg4TnZEanNqU3Z0czdmYWxLZXIwK043K2NoUXdibTJOU0Vad3JOOXpIMjhI?=
 =?utf-8?B?S2M3Snc1VjduWGxYSTQwOG1oSXJ3eU1MSFNQaVVKNWkzYmlBZjVCdzhzeXlI?=
 =?utf-8?B?cFg5L2toVzVyY3M1ZFJTaUs5ZzhRVCt6T25LVEVMQVJXamc1bmxzdExWbGF2?=
 =?utf-8?B?d2dETjlUUWpTazVEODN5cFgxYWNvcnBhekE0SEZITWxtYkdYdCt6R1NRRDFY?=
 =?utf-8?B?SDF2YmNVbWQrdDNBdklCdWVjUk8zbzIzWHkxYnAyUnlZd1JqRVZtRVpwL1Y2?=
 =?utf-8?B?ZVBOYWlHMGVWS09zSnZqSHU1TXFUS0NBUGF1ZGF3a2pkTHhqQkwxcFFCaEhp?=
 =?utf-8?B?dXZ2Z1lCY0NhRGdKdnZPeENRMGdwR1Jyd01JK0lHeWZwV3F3bjU2azVJM3kv?=
 =?utf-8?B?NzlmbmRzSXlhQzJBY0phdG9NTVVFOTJ2b3hVQ3dRTExxQUk1UFMwVFBBT2Ux?=
 =?utf-8?B?aUlDUkVnSEdCbjlSR3Ywbnc0NXkxMnZJUm9IZ1ZFZnNzKy9xUHVtOXlwZEdR?=
 =?utf-8?B?TzY1eXZFVi9VZnR0WmhGNCtlT3lMT2ZncStBMW15Y3BjTWpKSkwweUFsWGQy?=
 =?utf-8?B?eWVONW5icXBCUktaWWM5djNKTlpmRjE2MmZOT0hybXAxZjN6TWY4SnpKV1hu?=
 =?utf-8?B?Z2JVMXgwbUFZZ0NLeFpGbG5nOXpwY3J0a25LNzF3dTY2NmhZb3lYMk9CdlYr?=
 =?utf-8?B?cGt0MUw2aTI2aEQ1enlnb2lSSmlWamQweUNlUE52Ujhack9TVzBwaGdwTHZy?=
 =?utf-8?B?WGE2RkcrRS9QTXhvRitpYlVWd2pFamlQMEtubUMzeGR1SkRkRlZZL2owWnlC?=
 =?utf-8?B?M1doS09pdVUxR0VrNCtWN2NFZjdmNGJGdys2cnhpS1E0d0R4VFRncW9Oc3R5?=
 =?utf-8?B?NVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 66545b7a-8ff6-4c79-58fa-08dacbe9102c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 17:51:48.6756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ahbr9XVWPsPMgqrrOqLptDFbc9RUQ9JoXwttW3WFbicNPuz7tKfbVcikWxlhnbAdT4Df6ZWeRLUQEaNLmNAkHwhEQPvX/D8RAg30pnjRELs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7063
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



On 11/18/2022 5:36 PM, Jakub Kicinski wrote:
> On Thu, 17 Nov 2022 14:07:57 -0800 Jacob Keller wrote:
>> The calculation for the data_size in the devlink_nl_read_snapshot_fill
>> function uses an if statement that is better expressed using the min_t
>> macro.
>>
>> Noticed-by: Jakub Kicinski <kuba@kernel.org>
> 
> I'm afraid that's not a real tag. You can just drop it,
> I get sufficient credits.
> 

Sure. I pulled this forward from some time ago, not sure why I had added 
it back then. A grep through the log shows its been used a handful of 
times, but it likely just slipped in without review in the past. Will 
remove.

>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 96afc7013959..932476956d7e 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -6410,14 +6410,10 @@ static int devlink_nl_region_read_snapshot_fill(struct sk_buff *skb,
>>   	*new_offset = start_offset;
>>   
>>   	while (curr_offset < end_offset) {
>> -		u32 data_size;
>> +		u32 data_size = min_t(u32, end_offset - curr_offset,
>> +				      DEVLINK_REGION_READ_CHUNK_SIZE);
> 
> nit: don't put multi-line statements on the declaration line if it's
> not the only variable.
> 

Sure, that makes sense.

>>   		u8 *data;
>>   
>> -		if (end_offset - curr_offset < DEVLINK_REGION_READ_CHUNK_SIZE)
>> -			data_size = end_offset - curr_offset;
>> -		else
>> -			data_size = DEVLINK_REGION_READ_CHUNK_SIZE;
