Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F2551DBF1
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 17:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442843AbiEFPca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 11:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442841AbiEFPc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 11:32:28 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35F26D1AC
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 08:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651850924; x=1683386924;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/KivfB/+KuJX4h/OpZJeiHIk2K572GTIIHiJVuJNNYw=;
  b=XtYKJHWcUbbFtAU8bUJcpgdNqu7xGQI3hce85cWMJlG6rOaJ9MN2hRQT
   /aJ3wIh0CdU9JzCOlrUmZ3c5prMItLUpvpGPpGyspdrMRAj0BlZ7bn44e
   XT8UDGAkySndpHiGLhRR5YefCV9n49kluDgVOmdqwClLaFiRpU8PHksFM
   8JHxeR3Ryyt1peqULHCqO3U8SIwaLWjJfJXrpouMmbs7FN9P7BhggJbUP
   W6fYzFB8t+H9p/3gQJhy16A53iLDykGfYnAtj45Qp6skGNo0ijG7mxUB1
   WZYLJSy1X19qJ+BXa70LPsyOQx2vjK+rkgLdqP08S9Q83jEmSX5PgtPwh
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10339"; a="267334377"
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="267334377"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2022 08:28:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,203,1647327600"; 
   d="scan'208";a="518079489"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga003.jf.intel.com with ESMTP; 06 May 2022 08:28:43 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 6 May 2022 08:28:42 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 6 May 2022 08:28:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 6 May 2022 08:28:42 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 6 May 2022 08:28:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SDUc+JZJHA4ZKzNfAzPyPU2s0nBj4gpPoImazC6PB9FPpO9xLLuyjv1WemGRH3XlsOp6G/di1SbpIG22KRI0YbjiweUyvp2SqzrgstBx1U14u7L89hP7sj2wA+UDhuaOb0L7iQ1Z3UvWfQDIJFAE4XnnJYrcqHAuGEkP8RvLXNEayi5Sb9ZabRb5nfj7o82UPDxwqmT4EXASNCJWiA6iS3RAdHD7eN8Xn009JdY8FgbU9nSbZ7D3hjyWCFTzgosea4zPDJFYIzQTL1o14uVa7iXLQf/S02NoakmCf/ArlJuBXTxv9a4kPmuhtVT0/jqa/BI2xWAxJeDnzMSl9bNFbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IaLjo/E1n+ltS6w24JMrVOsuJsyFIBpOGDHw5oJHDjQ=;
 b=TtbrqRhIUx9I0CideD59ORjjqS//J2vu5xrJaLueYUf7wm3Uu7bcoBazkU/jMVxZgHHwDACjhLoOB3w0WQbqL2R/nVYZFRqD0qqhg81auDPGY927c1zWpGdAC+VpjDgdqNHiVTEPR9g6O5Oa7rvd+N2qpWaT9/59IhAwZBv2QL7+CJEGucFu8gc3QDX3quHlvZtQwMs+2wpZt3N8rNXH5hBSKFb7i2lUoTz4m0khc2FJWShItr30IecKNdipL3hHAAVs7uyy77ZJPe1gxas2hGEhYa1sS7Pwe991bAHnKgSixftfZYaN1on+VnwuDJ8GN4iE1/oVRIqUmkFmfDc0tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by DM6PR11MB4740.namprd11.prod.outlook.com (2603:10b6:5:2ad::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Fri, 6 May
 2022 15:28:41 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::2d92:b42:12d4:bd51]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::2d92:b42:12d4:bd51%6]) with mapi id 15.20.5227.020; Fri, 6 May 2022
 15:28:41 +0000
Message-ID: <16988d95-bee6-f4da-fb1b-21c8a498dcd7@intel.com>
Date:   Fri, 6 May 2022 08:28:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net v1] dim: initialize all struct fields
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>
References: <20220504185832.1855538-1-jesse.brandeburg@intel.com>
 <20220505184033.65d7a6e5@kernel.org>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20220505184033.65d7a6e5@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::16) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c7f97412-6b5c-4650-81c7-08da2f751941
X-MS-TrafficTypeDiagnostic: DM6PR11MB4740:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB4740545BC59391477AF8A82397C59@DM6PR11MB4740.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KT0Oztr7clQdI4lQ3nUFKMAdDAhxtGSQqPheKzJu0ld0XcHLbMbIKWiy/dOvgwNx2B4neqOQ6ZyCMppVWT7GKYO4vBK2SSikHFaUZdB4bzfkZ3LNpyI7bd4BjaXadGh0KQ8Erq8hltwP3h/3MxN79cldsHdVMltQMo5eZ0317SzuEso71j0g75ltUFb4DIS8NiIxTEA8rmDmMbcUyRuxxj5MsMvGoe5TWTE1VJ5voKGCiGBGQ9Th0o96eMAgP5jdOWWjO2KGCp3wDyV8ToDGRYSIWGkMg0ZN1+zN3C9Xn7ctdMHSIrDj7lXXRE/NS5bNSJmaO0cLUk0MLLcxivIBcMAH9T4vfyV9gnIIV0UXKuiRA0xIUNKXnk50X1ffLhVDBRKR9sO3gJ9JAlombOxo4mjNsYqSpyRXdG/rBUVgKHuoVuMlF+JjMei3VcDdIUF9zgIgFAWWcrsuAK5kh1vRiYMQiJvqXQ6LzZNw8dWc/orWYfguifUSNwcnwvsD4DYhOa9D4SuYYXCXVtfJg0m9JsGgk7h0I06dndeJuZENeuMPQ0hmWK0M78bpoLFXrsyOWGXYzqZlRHaBDXrwNyzhoXvtcW6O3k6PMUXTGluwbkJteUfIY7xXsXTvSsxWjGcQjWxJv6UzbeMdMQicIrxppxWTDaVZR7JWlP4oERCFzQGjPXHxpdxdQi7sc1qcFAwdK2L+J0nSPfr+ISWcIB0l2INAgcHDUHJ7eiXil9PDCIkeR4o3VUSDfvhVgCfJX/1S
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(107886003)(186003)(66476007)(66556008)(31686004)(6916009)(8676002)(36756003)(83380400001)(38100700002)(316002)(66946007)(53546011)(31696002)(4326008)(86362001)(6506007)(26005)(6512007)(44832011)(5660300002)(508600001)(6486002)(82960400001)(2906002)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WDF3dVdLcVArMkZHOHRERW1UUzN5N3ZDU25seFhPN0FETnJYYTAzb0c2MEZl?=
 =?utf-8?B?YUlidTcvNi9lQzEvZVczRStOcVhFNGlDUVV2UEo3YUZURWZWZ1BoQ282V3gr?=
 =?utf-8?B?ZkZWZUpEclpmSmlaVm9EN3dqdHFCalVVMzhORG8vV1hXQmRDWTM5N0lsUzYw?=
 =?utf-8?B?M1VnYVFGT3JZSGtiSlFtakxscEFKS1ZUSG9yMlhSU005WGltUUFRRUp2Z2NR?=
 =?utf-8?B?T1hUZ2QwNm9iaUN4RmdmVzEyYUNCQ0xaTXlBOU1ac0REeE5kYnBiQThPWVl4?=
 =?utf-8?B?ekN2djk3cTFDY3hZRFdxUytIUGRkRWdvUGkraGFhM2liRHc0ZWx0bVBpSFlD?=
 =?utf-8?B?Z1RGUXJ4TW9oeTNCUWF1L3pFZzhMZmlkMzM3ZHRpdkxNQktiaWsyUUZ6Vm9Z?=
 =?utf-8?B?UUJrdVZuNGJFTGxmT01jYlAxbXF3OVVpdnZVMDh2Y3IvMk9yS0tOMTE1b2Nn?=
 =?utf-8?B?Z2dMSTVmb2VUcGVxc2wrSE1KaC9ocDVlSGVNMkJZUWNaRW5mRDdTaFk5YVhE?=
 =?utf-8?B?UzJQVi9LVmlKY2xXRDFCTlZ6eUpBdS9zaTBCQzFvTVhhSWc4T0ppd2k4bUtw?=
 =?utf-8?B?OTJ3SEc3REttOGdKZnpEZERlR1RkeFhPOUlmeDREM0JHYkxuV3dTVkw1ZHV4?=
 =?utf-8?B?T1R0ZHlQOFlpTHNtOW80YUhaMmpLUS81WmJDcE5pL3F1dU1nSDd4NjdiYnRF?=
 =?utf-8?B?V1pCOHJuZlFmdjRvc2pZNWVqQlc1VlZabExWWUhpd3NQdWh4TVl6UEFMc3Uy?=
 =?utf-8?B?VUdibjRkaFo3dEs0US9HUy9ma3hMS0dSc293SWxQcDI2Z043MCtvR3hWcTZr?=
 =?utf-8?B?VkliNW5YSVAwZjNNV1RaQWFFNjBhUFhiUnV1T1VySEZjQjg1U1BvRnhtOVFT?=
 =?utf-8?B?VCtCZXRXdEpTNTFhWXQxbk8wUHFHRUlXcTQzOVdzRFdrU1JTOHpOSHp6WmJx?=
 =?utf-8?B?U0xhSEFWaDM1QlVlZ3JId0Q3Vlh2QVpBQkJjOE1ZWisvdXAxNlNUUnlFYjNi?=
 =?utf-8?B?cmkvN0ZMUS9nMjdSTWc3aVFLWjY3ZHBHZytSYnRXbFEwZTljdXMzUXltSEhs?=
 =?utf-8?B?NmVLMmJnZXhMSXdpSHJrcjZYWE1CSmlCRlhCd1Fvbzl3L25UMlFjaTdXODB5?=
 =?utf-8?B?eHV0alJ6ZjlSTmZwNHFqT09NNG9iL0FzNm1LcXhMTThLaittZCtxL2F6WnVl?=
 =?utf-8?B?RHVkbEN6WGlJYUo0UHRsbHYyZStiTi8xN1lKZ1VjZUx0Z0xPQUlydU9PbTFF?=
 =?utf-8?B?cllwai9weFpxMEtSbmxXTWpJZ2dvdFE0eCtUck9MVUg1Z3VXZWgvSElsc3hK?=
 =?utf-8?B?TE9uVVdhd0dNL1lBT1Fxbmw4NElNcDBXRGZ0S3JDZGVGa2VrMU1zK1BwbDZV?=
 =?utf-8?B?VkJaUGdTNUZUU1h3U0E2Tk1EYTV2WlltUHBxRHRCdEFFV3puNGdXVTdwVUU4?=
 =?utf-8?B?MktlUEhEb3JyUWRUTWlPVG1YeGFvTVJkT3Z3eWw4OE5qTUFuMkxqcW90QzIx?=
 =?utf-8?B?cllpZHRMWjJNL255NCtneUZTazJYSnphYUNucXF5blNyVmRlUERuc2hzS0JK?=
 =?utf-8?B?VDJEVUxLanZNbTdXVStSZU9mRmR5RDljcFpkL1JnaktNSy9qWGZtSmpSOTIv?=
 =?utf-8?B?WGZSblIxNVZTMG9sdFkwVHJiUkFwMlZUT001c0h2ci8waGlxV2gxVG9GMGxO?=
 =?utf-8?B?ODdpTU5DNXF2Y0E0M0JYK1lZOUN3eXN1Y0h5M2xydDhCbWRmNmF1Vmw3YU1H?=
 =?utf-8?B?YmlSZ1N2ZGJ5T1RROGlLU3VaU0tPbWlOckVZL1lVZm9nQTVoVXpwczBBYXZ1?=
 =?utf-8?B?a0NpQmg1VFRVSVdha1IvM29GN2xUTGxWOVFzZjRoNHFBM2Z4RjhIVHN1Q0U4?=
 =?utf-8?B?eVI5MzFBMVNkQVMwQ0ZqNFZWOUgwWHQrUEo2Q3RrMnQvSWsvVWkrSUpVWHJ0?=
 =?utf-8?B?cmZUSXc1L1p5YUdpcWxUR0ErWGpPQkpLS0I5cTFkYzQ4cUVUb1J6N0RCbmIy?=
 =?utf-8?B?Yms2Y2gxQ0dpRjBmK1FZeHd1Y3ByYWhnbmJLc1UyeUVVQkNCK2NBRThvTERP?=
 =?utf-8?B?ZTY3YXBqaVBTSVlvTGhSaGtPOXhqYWRSQy91YUN0Nm1Ycmh2aGJnYkJGUkcy?=
 =?utf-8?B?OFZ0Q3VVbUR3RThhcVFkYWZGZCtJeHdoZlRKZEt5dnBpbkdqVmgwbmdLOVFk?=
 =?utf-8?B?N3JjY09MME5jM0dtaGFxOThVZTBrSzliVm93cExSdFBMOFVkci9oTWwvMTRs?=
 =?utf-8?B?UURTMDdFVnkvWXkwUU41WjBkUFFqclVNUWlrL3RtNzIrRFdtSldONW95QXJ4?=
 =?utf-8?B?SmVkb1dqVjR2R2dXQm9ESFVTRnpJT3JPU0FkRlR1dmxUUVJSdUF5a0t2aGQ0?=
 =?utf-8?Q?TMqmP4Ao+KPIPw9nvwSOc0FDeYvOA5bGHCDOp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c7f97412-6b5c-4650-81c7-08da2f751941
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 15:28:41.0080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lxTciCUMMlXDkf5dViXKcrYjA0TSBVRVpIWYKIjomH1YO/1jnhpMJQAH8lfd3Lb1aX1zCaW3CuCKp1p7WXQ0rrOpZqH9+l2CWWcKcUJiiVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4740
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/5/2022 6:40 PM, Jakub Kicinski wrote:

>>   #define NET_DIM_RX_EQE_PROFILES { \
>> -	{1,   NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
>> -	{8,   NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
>> -	{64,  NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
>> -	{128, NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
>> -	{256, NET_DIM_DEFAULT_RX_CQ_MODERATION_PKTS_FROM_EQE}, \
>> +	DIM_CQ_MODER(1,   NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE, 0, 0), \
>> +	DIM_CQ_MODER(8,   NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE, 0, 0), \
>> +	DIM_CQ_MODER(64,  NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE, 0, 0), \
>> +	DIM_CQ_MODER(128, NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE, 0, 0), \
>> +	DIM_CQ_MODER(256, NET_DIM_DEFAULT_RX_CQ_PKTS_FROM_EQE, 0, 0)  \
>>   }
> 
> That may give people the false impression that we always have
> to initialize all the fields to appease W=2. The most common
> way of fixing this warning is to tell the compiler that we know
> what we're doing and add a comma after the last member:
> 
> -	{2,  256},             \
> +	{2,  256,},             \
> 
> The commit message needs to at least discuss why this direction
> was not taken. My preference would actually be to do it, tho.

Ok, I'll make that change, thanks for the feedback.

> 
> Also please CC maintainers and authors of patches under Fixes:.

Yeah, my mistake and I'll fix that on the v2!

Jesse
