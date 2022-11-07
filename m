Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C3B61FD25
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232354AbiKGSRG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232657AbiKGSQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:16:32 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB6611A2C
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 10:15:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667844920; x=1699380920;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lo2dktIYQJlxu7l2PZYR2lTEz7zmF94O0ZJbB0mQleM=;
  b=H2JCNWRICvZiCAM0ahi3Mo8dWdQAijmdv0cGMfqHllB7FejBLZ0ZXHlu
   8xTXMqy0e+TXmeLC2e7hm5eF9KI6pivvJtnM5FfBtObsK4CsaoZNViVcx
   69Dm2VzaYO8AK4dvExAyCUlmOO+/9TSm+fia2wM0Ern+Hc/AVEJ58525L
   f+2tmsoxADJxUEG3TfPPvLt67s3DtjPDzhNU2CGsiqH3HX2g1PZdGT33s
   cJiR9n0Z1QEksjU352MmRCFbwfveRJ8hcs67WVnbMiNlOxT9zCOwXqm78
   wwlOZboMn2I4TbY7upVtlEuxfmB/v39jz9q4qhq/Hf+ekpcpK5C2b/IGM
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="374755908"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="374755908"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 10:15:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="965263585"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="965263585"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 07 Nov 2022 10:15:19 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 10:15:19 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 10:15:18 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 7 Nov 2022 10:15:18 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 7 Nov 2022 10:15:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PjrlTNjuQMF5mSBQ8pD0NSK/josRh7nKLw/3Oe9dRvrlYPCoyJxcWyAlQQDecfgU6PysZTkDLCV9PA/aoNgnDvkolBYnaTxAZtkUMuNtyCama8vOHfv3kfXumwlbmDTbmQlRP5a8CsbzSS7wBhmSDcLcSRMXJe4hIZJbt6hwlOdTKfZJbZN7o3xCCBpumLx2SxJeYlGd5eEhuDuthEa9wbZ3wun9bbq+h0I4YqYzGIaqDJMsRo8o07ZnCJF7uVHZ5u2d/O33euHUO8ZdYpSYJK9/yqxXWWVI5v48v7j3yedgnF5OrU+PKToscMnbeiEF0u4Z2f/I0ZSrZvPPzFSByA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lv/GRx7KnHcAoJslmjnzhTLy7wHDlLHRGROeyNL7Tck=;
 b=FmlT6BdvtBZysEyhj8ISu6hkU7rfyIB8odh4mwO/+OM0C7f8rYc5Uw2CF5TIBAIyP9/EzOZwFvpr1U7p5sXfdda4zHTnI7/1GVC1Mt8a0uWYoZeZa7Sc1AdneiVjBRa7Hnc7c+fxKECXGauys0afsabSREDh6ua0PFq0X/0hlQrIp7rwhLlgejj1vSYxloYZ5EDSRTSNcvikQti4bEusfSn5sPB8wXIBzPf03K/P2iAn5wN1bei26tfWbTag8HZvEy6a4pvAqpQLO+G2XSNE02us4FBn1oK3dUJ8sFs/QhXo4pRQBjWZSKeS/VMNTkwZL4jq5NdKGgm6m0vSJNhTsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by IA1PR11MB6324.namprd11.prod.outlook.com (2603:10b6:208:388::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.24; Mon, 7 Nov
 2022 18:15:16 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634%8]) with mapi id 15.20.5791.027; Mon, 7 Nov 2022
 18:15:16 +0000
Message-ID: <2fe5335e-dd0f-f15c-ca02-f5f39b09b3eb@intel.com>
Date:   Mon, 7 Nov 2022 19:15:09 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v9 1/9] devlink: Introduce new attribute
 'tx_priority' to devlink-rate
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>,
        <jacob.e.keller@intel.com>, <jesse.brandeburg@intel.com>,
        <przemyslaw.kitszel@intel.com>, <anthony.l.nguyen@intel.com>,
        <ecree.xilinx@gmail.com>, <jiri@resnulli.us>
References: <20221104143102.1120076-1-michal.wilczynski@intel.com>
 <20221104143102.1120076-2-michal.wilczynski@intel.com>
 <20221104190724.59e614dd@kernel.org>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <20221104190724.59e614dd@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P194CA0073.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::14) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|IA1PR11MB6324:EE_
X-MS-Office365-Filtering-Correlation-Id: 4df5d3c2-104c-4313-da38-08dac0ec053d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hx872j3qLX4RorLHjSxXPwlS/LpDme+TPxLFMlJ+juhT7X+ypbEVYIxHAUqFmXCj0VkhoLmaCFQzJ9vJt3MjfIqjy7A/lY8HQBMhcuFQPh/QGEY2Ry8Raspgsoah8jUI6JbL5luqDCfzHN71XfuAKW8wKOuF+AZxyPpdQTlS/yuXyNlMJc1mh4NBdcffJurMWL2fLqAAf3OPgL7DQiYbAfDbO7YOJzvKruUHmr8ZwwO3/nuts4PINY6Rgl0WBTXzsPVX292lX48bcxkHnKHhsYRTrJ5yaGiHlHcxWTDr/jyzOjhKnfVwBgvN1KNQdLHae9pNfdJ9B2Hsw43pR7nfJlulGkeLLBINSzR3bTvxB3l8w6r3LqrxMY0K1h6IDHbyWrRbyYiitq+6MQG2dziNnAXywcCzldWEu1+/sTb64xCIbHUH2kzKaxhaeAP7SMOIqbDO9KfZ/+/SXPVKnt/fIdxnWYoNHyG7yQgSdJEL0MmGZJWwBB0CJ0OzTTHfkGpt5DOzCheOWGN8JExvLZcogAa2DjsT3FQQkKkcO7X7Rr43+HVO6TPAaMNGObgQFwnkuVQfs4FXNw49oDpdJp6zghLcnQKB8BaL+ppyOgv9eDBEpsaKPc3O4hrpfhS1PIo6ry3rBVdNOPBgrsZTaBtA+5USGP4rzP7xtQbjnSA5V7GtG1OKyju4F4EBEHge9+yH0ePzMQq8D6UjsVlolrxUiVcIvTax+Et839lEGZ+J2EyyqcbmMbSK4xBumgd30bO12fYhbIJSDBXQwe0VbU0e+qb325dfzQFXodSOKyNWfkk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(376002)(136003)(396003)(39860400002)(451199015)(36756003)(8676002)(4326008)(66946007)(66476007)(6916009)(316002)(66556008)(5660300002)(8936002)(41300700001)(6486002)(478600001)(2906002)(4744005)(2616005)(53546011)(26005)(6512007)(186003)(31686004)(82960400001)(6506007)(31696002)(86362001)(6666004)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDZmdTl2MVpVVlpkNGFzUElKYXljSXVoL3Rac09LWjZvS3VjRjErTGIxSEQ1?=
 =?utf-8?B?ZlVoV2JadXB6THhoLzh0OHpLWXJMZnJKVnRIMFcrbU5RbnlQdW1RRHdOVkM0?=
 =?utf-8?B?bFVDRDQ1TVlCWXM3RFVjaDFTRUhOQW1ocnM3YlFCbTM5dzVPckxYTHBkTGhE?=
 =?utf-8?B?eENDQUoxRXhaYzh3R2dONkhMRXptc3NGOFFscENIbkFtTFhKZStnMGxHN1BK?=
 =?utf-8?B?WXJPTGdYNzFVbHNsWE1QUW1odWdIUHY1SFVSRlg2dkpuejhBanAwNUFyVXhh?=
 =?utf-8?B?cW81dnhRcjRMZUEyKzFaTVZGRnNsaEFScmFWeHFub2xjYXNYNGpOVG9QUjl5?=
 =?utf-8?B?WFpoTWtvQUhTQklRVFM3aEhWSWlXb2hRWlBtNVBaUThGTzgzVVpOK3dyUFBO?=
 =?utf-8?B?OERpVjZvNUpZYmtjQWo5ZFZjRFc3bnJxMXRHYktkVVRDVDFLZzRCQUZRSmNT?=
 =?utf-8?B?ZGs4aTVLTlcwSGNNYXJDa3V3bjcxSWFTNzhmRngrcTNMeFlHYWl6L0M3bTVZ?=
 =?utf-8?B?dzNmOWZiMU1IdjlJcDhtWmNjZ1QwSUtqY0tXb1BPNFQzSzJYN1p4NnZGWC9V?=
 =?utf-8?B?ZlN2Rno1NHVJYXNEdEJtcEhFMVQ2R1JqY21EMkROKzFVTlAwRG9tZWlXMVBz?=
 =?utf-8?B?dkYzc2pXeW9BMDdnWmhqZkhUQ0tmZHorcVo1YlVZblJtWnYwa1RNKzZ0M3JK?=
 =?utf-8?B?cG44UEhtQXRHUm52anFTbm1wMm9oQTRJRlRIK0hvNnBYbkd5Q1BIRHhRQjJB?=
 =?utf-8?B?WXlGMjdrUmd1ZHlCaHF6S0c5Rk9wb05Lbi8xaWdEVWVoaCtNZytiVmI5K0VD?=
 =?utf-8?B?QXlRMmI0MkxSN2pCaEFxazJSaXNqUjFxM1YyaW5CdEZMY3QxQlVrQU10Wmt4?=
 =?utf-8?B?SDVEdkV0R0MwN205M2VRbHdaQ2JEY1ZXd2Q4TlQ5V05PckwxL1RqbHAvcWE4?=
 =?utf-8?B?UXo1dUJkVUZkRzVleThRanVWekI5dWdtanpmbUp1cUJSbGxVNWFub0FQNGU4?=
 =?utf-8?B?NzdrYWVFKzhrb1gwNklteTZDK2g0WXB2cTkrRVBqZHgvQzYwZllGZUdMS3lk?=
 =?utf-8?B?c2VwVm5BemtFVVZTbkVKOERuNzBoZnBxemUxUSthSFdMM0RWbTJ4UHV4eERx?=
 =?utf-8?B?Q1dDMUpaTjRmcVBYRHhVNlE1RENMRC9YSHdRSFdlT2VOSUYra0ozOU9Sb0J1?=
 =?utf-8?B?UGJSdnNiYVVaOHc1TXNvSFVYc3FHSjUwZjBKRVVuU1BHWkJmdVBPYXhzTEhw?=
 =?utf-8?B?Q1dsS0dLcC93WlJuQnJqQW5jVWdrL2F6dmh6bnU1WlpqdmZzSDZkK2xUZk9t?=
 =?utf-8?B?T1BZRFUzVnJucDZUaE95SXJYeDYvbXhoaDgwVCtFa1cvOTM0VXErdWsyK0h4?=
 =?utf-8?B?bzlYUEdKVktpaGcra1ZUL1g4WkpiSEJvOVdIWFhoMWRLZmE3OVQreTR6dXZa?=
 =?utf-8?B?NHRvV2pHM0dBWk9sczdUVFlGVG8xc1ZuNzhVRi9FSUlPL2YzZGk0dkQ3UFVw?=
 =?utf-8?B?U3Q2YS83WFlqdXVIN2tBZ0hpM3lJVzNLWkFCUk8zSHFvYTRIdlZPQjhFUVU4?=
 =?utf-8?B?V2IyMXRtWmpzTFN6WXpSUGhlU2lMdjhIVFF1UzIvVmcrV3NraDJObFZKbUha?=
 =?utf-8?B?a2JQL0lFZmgxMGFXR2t1TzhibmJyOVRRUHA1NWxLU0tYM1VGVjR0b2N2Z3F3?=
 =?utf-8?B?SEoyNDdENjZrV29XZHgzRUVBdnlzQno5MkloWmZDaW5kbjk2NTdXT2NIU2lW?=
 =?utf-8?B?MGdZdWUyTWZpNngwNFZWOW1uTjNDdkRzWXhaZjR0SndyTHRBYitCdkNKUnBl?=
 =?utf-8?B?SURvQXB6V2I4OEwrZ1QvWkZZa3A0Qm5SQWRFSUluMXZNL3I1YkNTMkZkdmRB?=
 =?utf-8?B?RVRhT1N6UG8xUkVzdUFwVmZpSFNuWkdTaFAzQTBuT2xPcVdjVjhQL0dNNFVj?=
 =?utf-8?B?dEpZUlZWY24wL2VpVnd2djk2UFJ6WDY4aFJoaGx2dzBLT00vcXZTT2lZcE9M?=
 =?utf-8?B?cTNiVGtuYjUrazJUQTcyOVQvM2lCTURWSGJxaklBdmkrbloxNUpXZDRQUXBk?=
 =?utf-8?B?LzFyNFFadVlsZnVTN2ROenRUTDFvVlVlUUhFNExQZjJ2OGdDbU5YMjJWV1VX?=
 =?utf-8?B?aExGRU9MZE01bkoweDVxUmQ1aktiWjNxWERQd3NQUGRwQmQvbHgyTElDWVZm?=
 =?utf-8?B?UHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4df5d3c2-104c-4313-da38-08dac0ec053d
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 18:15:16.1600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e8KIjW7gSuRZf2r4HaJqGOET96An1aCZwQgtdYRzMYAPAXNWU8JSY+ztMQiPpUfeiqbX9o6CcGgJBok8fUk/sbr9n0sdW8ZEUVtAVehLGSM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6324
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



On 11/5/2022 3:07 AM, Jakub Kicinski wrote:
> On Fri,  4 Nov 2022 15:30:54 +0100 Michal Wilczynski wrote:
>> +	DEVLINK_ATTR_RATE_TX_PRIORITY,		/* u16 */
> All netlink attributes are padded out to 4 bytes, please make this u32,
> you shouldn't use smaller values at netlink level unless it's carrying
> protocol fields with fixed width.

Sure changed that in v10

>
>> +	int (*rate_leaf_tx_priority_set)(struct devlink_rate *devlink_rate, void *priv,
>> +					 u64 tx_priority, struct netlink_ext_ack *extack);
> And why make the driver API u64?

Thanks for pointing this out, this is an oversight, fixed this in v10.


