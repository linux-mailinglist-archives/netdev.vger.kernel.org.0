Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CDC6970D1
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 23:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjBNWj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 17:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBNWj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 17:39:26 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C2E303F4
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 14:39:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676414365; x=1707950365;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jfrnbD5CNUjkoPQIGU2JEZIsabl9DX158nmDg0OkPoM=;
  b=LY7hJbli+7Fu4Hq33XTiNaKs1yW05KTyvLFL/gQDYpBAGbu6pkTVRAHd
   G6eQNrrl0uSM43mo+Tw6HWQI3vHPCww06HSu3sm+heSoHDU2EmnVbErK6
   ZBCuLdbz9mk2kVM4m7IbfTcv3AB9zvO+VcoGBdj6ALt6tCZ/91F8GZpAE
   5Nx/6dFWgT04sUZFVMrIRgMLqjJXLZqlqcmu9d7CaHDOLn2YmVrBPxWNA
   Jc0OZ58bn41s8VcamnwOLKYX3zhGnw1dYZ93CvKiS2jU1UWh35apXRUtb
   dlN2C5vMnweB7IAc7f4Exhh9Mlq7lcQE5tD4MCZWORrU4YLyBe4RIxBMj
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="417510205"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="417510205"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 14:39:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="812208122"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="812208122"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 14 Feb 2023 14:39:25 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 14:39:24 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 14:39:24 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 14:39:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KXrimzmsyMQ7DlVKCjoEmZpa4bXA6RqNcLuSjC/LSG51AbjVOjnBUrE/bCnAJVHLyWB8IaVZVLKLTZK7bhYHRKqEH+b7ZW1WT6aBUfms9ojfjbDJ+E3XF85ZaV9B8Sy7ucz1ZkAPD5h0Y6SZ3VbOjZfm25luUjNG55/d3vNgnhQZaFuQyWywx+lOdztgTJ8i9jTkFAkNRJX9Z/xWtNG5XSRrlX80huYYg+oON7znWeRKNDgpjJCjOsdnWAcCQel3h3gXIuqKrqcMHHJhAtQ045+OoKRDQLVe9OUw5TDgEIewMdGssEdCM+13g+cuLKUjVxuVjM2AEubl2fGns827xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kTeB77mpQD3J5XqMr0o+v71ck/DgJRR1qkpSgEVleZ4=;
 b=bGtwWsv/xTqNdQvNHYL+muOm4/3dkLdrztQosfnJPxVZJsq0hOwP+SFm/UJzkKNTXbge5f5Dj1Ue3FlEsjdYtNZKPikwDPUMnAE+x3Aga5K38qJbkuHUcth4Hx0eTHDNIN5426IA+pojKSAmpIDyVY50GcSa4aVCgqYOUyRrQfAuqG0wufQGRJhMlbWebpjHJghfPpZ39YYMRHzypK+oISmJ1+C/3K8Pnf6l3K4/Vuf1+qJyj6EnIRZQIL8Li74/fVp3GiiysTsj0Y7VHLj/2g0b+fVtFu9dEJ/ZolF17Rs7DDhgqgQx4AO398u2v+HxVcGrObRBREorCPfjCd774w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA0PR11MB4557.namprd11.prod.outlook.com (2603:10b6:806:96::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 22:39:21 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%6]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 22:39:21 +0000
Message-ID: <6198f4e4-51ac-a71a-ba20-b452e42a7b42@intel.com>
Date:   Tue, 14 Feb 2023 14:39:18 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 0/5][pull request] add v2 FW logging for ice
 driver
Content-Language: en-US
To:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <jiri@nvidia.com>, <idosch@idosch.org>
References: <20230209190702.3638688-1-anthony.l.nguyen@intel.com>
 <20230210202358.6a2e890b@kernel.org>
 <319b4a93-bdaf-e619-b7ae-2293b2df0cca@intel.com>
 <20230213164034.406c921d@kernel.org>
 <bb0d1ef5-3045-919b-adb9-017c86c862ec@intel.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <bb0d1ef5-3045-919b-adb9-017c86c862ec@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::10) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA0PR11MB4557:EE_
X-MS-Office365-Filtering-Correlation-Id: bfbc8931-ec0f-46e0-0fbe-08db0edc50aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dSt1bcwXmvZW5+rUIB7cm8xmAF1wWVSx/w/sY3lhJEzeaIhFp3qBqo6BUYp0REvvV+9rlyPJKijlRHDVWRMqBcrKvpaCQ0Pmdx7UpM/IwjnXhxEpO2Xv03gArIhRw296a3abhYCiZaZ9X6jayOKwchEAg2u3u72qoA2LdAIBNjArwpG35ljAfF4uBvbXg7QgtcM6w/uzYxCZD6xsBORAqKBvngROPvbzCRdnPNHmMgjJmY3yBZGB+qLzVHVNHhTkV47YwNFqCLVYerWbW3766pqKd22+gRjVsp0Lktwh21/3ilh7KGzmFTbBV+i7dqdNTozOk6DFFpGeGXNQPLTo9cXSTxkiTabt/zqqilvC10wvZBa9L2efOOydSOLzBlln8/e5c6s0Jvz30TLZG5iRDF0cSe/lLHROXlHot6fZn9PbY/b/Nhw70dAIpcqQgu4Za2WWq16kQYSCvEUIKjBT6SIRMIZIyGinDfL7e7z0UClNlQvG0CZKPTRm5bxiu/C5gGUwV8bb3cRzBix9hujS0ZB6MK7VKsFrZcmzcrQa4+GMUUNJ5ydWuZWmAFGd/Chf1G4Ss5TJbFFIqWjewRtJidZBnl1xH/RIzXguiaPB+zK+O76L8ICc05RMxN7satOUkr8+I/Cy3oUF1NCYzuJFeCgf990i5iLf+nsnRJHWplRF6e4kNo+O5rNlc4RoAsJLTwHYR+dvQ07mEBlCPJ3F5f/9DfOKhFi63Y/BlQPGjxU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199018)(66899018)(31686004)(5660300002)(83380400001)(26005)(6486002)(186003)(31696002)(2906002)(36756003)(6512007)(86362001)(110136005)(478600001)(41300700001)(6666004)(6506007)(53546011)(66476007)(8936002)(2616005)(316002)(66946007)(66556008)(4326008)(38100700002)(8676002)(82960400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OEljSVB6aktyajJaNG5iWmlnN2h2OG9raTJaQSt1MVRrNEhTSzl3SHoyM1hV?=
 =?utf-8?B?amhIUk04aEpEakozUXFNbjYrM0w5S0xjUGNnbytpS08vVDNzUFVvemZ0TWE3?=
 =?utf-8?B?NWkzM2dDTlkrdnVVUFVqOEhVbEhjOXl6aVd0TDM0N3gvRWk4SHBkeGZXU1Vh?=
 =?utf-8?B?a1IxUWx3RzRFOU8ydXdpQUJ2S3N3eEJhTVkxY3J0MUVKZWlZWU9ZVGNtYWpI?=
 =?utf-8?B?aWRPTksvMnZNMlJLNEV3MUQzS1NZTzR3dDNXbGJ2K2hzQ2pZcHplTkNmWVln?=
 =?utf-8?B?QS9maXdrdlM4YXMxVEpsUHBqVnJ1TFJlanhESnVKZlZlL1hyeUR2djNjcXJ6?=
 =?utf-8?B?OHJoZmNrb2pxTVgva3hBakRySWtldldtS1hjRHJvNTlEbnhBUGtWa3BROW0z?=
 =?utf-8?B?cjBETC9qYnM4TWl1REtFdkRHQVBSOU5hOU5kV1N1VjcwVVJTUEhNM2JjME0z?=
 =?utf-8?B?VlNjYWJJa3QyMysrOHpjbHlUdmphRHBZM0JmNVJSVFZLclZBNUlwNEZQUW43?=
 =?utf-8?B?dzFLQlJPSlhaS1U0RjNPOUhqSEJmajNIUmRaTThDL3BWazR1Tkp3aWN0SlhR?=
 =?utf-8?B?V3JFVHpubW4vZGxtcGZjQjhHeTBTUHNUMGFOL1VicXVMYnJPajVQSmYxT0wx?=
 =?utf-8?B?VVg4b0JTdDNOV0hZQWlUajh6U29rUUROeFkvQnRRMXFiZkkvVVBlMmM4R3gx?=
 =?utf-8?B?V0lDZ0pMSDV1M3N5STdQZ3o5cGM0cFUzODNhTWZnZXErTk5VZDN2YnJjLzdG?=
 =?utf-8?B?UVZORW9GWDdjbk5tMnc1ZHFmUWRXWXd1TXh1UDNYcHNaTUpvTGVzZFh6aEFk?=
 =?utf-8?B?SUZST2ZpeXNHa0JTUGJPL1RqeHpuWWNWMjl4b3ZDNDQwZTYySk1oSUlmVERL?=
 =?utf-8?B?cU9RYXFoOHFLTlhMV2ZlTEFEY1FMbHpWQ090RkJWdVB2SXJYdUtTam41ZmRM?=
 =?utf-8?B?cUZ1UTlhZUFnSFpoeSt4cXpKMTBXdFZCTVZCNlQxNTlvYXJremVkUll1UVdi?=
 =?utf-8?B?NWoxeWtVajR6Zi9uQ1JqOElrMlJway9zTkNWSGhqTFpXYmZIRjFXSkNSdDhV?=
 =?utf-8?B?TEo5VVRDcFl2Wm9Xc0NsQjl3aTJpUWIxOFZWN0FTUFY1RjZhdmFqVnBzeFFz?=
 =?utf-8?B?KzlxbW9nMDNhQmMzWUxsYlVtK0Ewb09zaTJHRi9iQTVKQzcwU3VVVGNjencx?=
 =?utf-8?B?RkNwYTJXNUM4Ui9lVTNEbG9XSzU3c3RhYWV1Ly9iRzFHSnBhWmJCeXRra3RR?=
 =?utf-8?B?N1I0b1lmWjhVNStyR3VJbkhIaWZCckluYlZ4QjA2TXFQQnlLT2o2amQ2eTV5?=
 =?utf-8?B?RkVxSGYzdUU5ZkVmTTNwNWVVOGxacTlraEU2UEV2Qys1eXViMDR0bFk0NTIv?=
 =?utf-8?B?NkU3M3hkU3A0ZTNqZjJUU2F0RzYxMVYzaXZyMGJMdUdONmJVU2JpVEd2L2hq?=
 =?utf-8?B?VUpCOUhSS3d1Ti9MRE1RT3Vnbm1xd3RSMFhzMmVWQ1pCdWpsU0srbUZwK240?=
 =?utf-8?B?eVlyUlZzMlZyQXYvZEZrRFNWUThhZGNVM1JCWURTellSVWNhODlYcW5qb2tO?=
 =?utf-8?B?Y1M2aEpMUTIxckRFclRpZXhmNXpla0N1M01ISnJ3djNGbWJha0ZYZmh1MzBx?=
 =?utf-8?B?TWNyc2tEUUs2alhqSFptQXp2ZUJzbHFlbWNPekdzVWgyL1A4c3ozckpaajJv?=
 =?utf-8?B?aEhCdkJXSHNPaldsYTBhUllUNFlOeGhQYWw2dU9KczRJVU92bEZXRXRaUmZo?=
 =?utf-8?B?SEoyb21PcENhb0IrdFVpODFQcmtMZkRwYUNDSVZqZXRZL2VKbDlHeXcxdlBS?=
 =?utf-8?B?Myt5ZlhnNUhGS1ZFTnNXK2tVemRBTXJ4OXNuN3pTVzFWVnVsTmlDUktkR0lI?=
 =?utf-8?B?WjA3dE0xb05Fci8rSE82YkIxZVFkbTlOQkRQeE0vNmNSeGZrWmFiVmwwOStF?=
 =?utf-8?B?WHJRS3owWnlXWnFNRDlQU01IYmttVVJpZ3FPQzVEeE5KL1BZL2xKcVMwNVN5?=
 =?utf-8?B?SnNxQ0xwZzlaUkNHeUxQSFBKWjIrak5UVG9oVDdHR2JEYSsyRUxTV3RPOEht?=
 =?utf-8?B?U3NGaVd3WHFwTTRpM29rdHZOWkhiRGxtYzZpNmJQSy9vYUtyZ25nc2pvWWxw?=
 =?utf-8?B?bXlSeE5KOUNWZndMbVNmUFRwR0tTY2JmejhtVk5NK0VsOHNjVzNSQ2FRTnQw?=
 =?utf-8?B?bkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bfbc8931-ec0f-46e0-0fbe-08db0edc50aa
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 22:39:21.4954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kocL4NZZb9U+9mRL7U47y/+T3EjUYJssVJ/oSuv1hhvoxbpvZ8PW9M4nR3NMo6dSETG8YoHYv77aUI5z6vJmPAdIvMjoy/vQoHxx3WUFpaI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4557
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/14/2023 8:14 AM, Paul M Stillwell Jr wrote:
> On 2/13/2023 4:40 PM, Jakub Kicinski wrote:
>> On Mon, 13 Feb 2023 15:46:53 -0800 Paul M Stillwell Jr wrote:
>>> On 2/10/2023 8:23 PM, Jakub Kicinski wrote:
>>>> Can you describe how this is used a little bit?
>>>> The FW log is captured at some level always (e.g. warns)
>>>> or unless user enables _nothing_ will come out?
>>>
>>> My understanding is that the FW is constantly logging data into internal
>>> buffers. When the user indicates what data they want and what level they
>>> want then the data is filtered and output via either the UART or the
>>> Admin queues. These patches retrieve the FW logs via the admin queue
>>> commands.
>>
>> What's the trigger to perform the collection?
>>
>> If it's some error condition / assert in FW then maybe it's worth
>> wrapping it up (or at least some portion of the functionality) into
>> devlink health?
> 
> The trigger is the user asking to collect the FW logs. There isn't 
> anything within the FW that triggers the logging; generally there is 
> some issue on the user side and we think there may be some issue in the 
> FW or that FW can provide more info on what is going on so we request FW 
> logs. As an example, sometimes users report issues with link flap and we 
> request FW logs to see what the FW link management code thinks is 
> happening. In this example there is no "error" per se, but the user is 
> seeing some undesired behavior and we are looking for more information 
> on what could be going on.
> 
>>
>> AFAIU the purpose of devlink health is exactly to bubble up to the host
>> asserts / errors / crashes in the FW, with associated "dump".
>>
> 
> Maybe it is, but when I look at devlink health it doesn't seem like it 
> is designed for something like this. It looks like (based on my reading 
> of the documentation) that it responds to errors from the device; that's 
> not really what is happening in our case. The user is seeing some 
> behavior that they don't like and we are asking the FW to shed some 
> light on what the FW thinks is happening.
> 
> Link flap is an excellent example of this. The FW is doing what it 
> believes to be the correct thing, but due to some change on the link 
> partner that the FW doesn't handle correctly then there is some issue. 
> This is a classic bug, the code thinks it's doing the correct thing and 
> in reality it is not.
> 
> In the above example nothing on the device is reporting an error so I 
> don't see how the health reporter would get triggered.
> 
> Also, devlink health seems like it is geared towards a model of the 
> device has an error, the error gets reported to the driver, the driver 
> gets some info to report to the user, and the driver moves on. The FW 
> logging is different from that in that we want to see data across a long 
> period of time generally because we can't always pinpoint the time that 
> the thing we want to see happened.
> 
>>> The output from the FW is a binary blob that a user would send back to
>>> Intel to be decoded. This is only used for troubleshooting issues where
>>> a user is working with someone from Intel on a specific problem.
>>
>> I believe that's in line with devlink health. The devlink health log
>> is "formatted" but I really doubt that any user can get far in debugging
>> without vendor support.
>>
> 
> I agree, I just don't see what the trigger is in our case for FW logging.
> 

Here's the thoughts I had for devlink health:

1) support health reporters storing more than a single event. Currently
all health reporters respond to a single event and then do not allow
storing new captures until the current one is processed. This breaks for
our firmware logging because we get separate events from firmware for
each buffer of messages. We could make this configurable such that we
limit the total maximum to prevent kernel memory overrun. (and some
policy for how to discard events when the buffer is full?)

2a) add some knobs to enable/disable a health reporter

2b) add some firmware logging specific knobs as a "build on top of
health reporters" or by creating a separate firmware logging bit that
ties into a reporter. These knows would be how to set level, etc.

3) for ice, once the health reporter is enabled we request the firmware
to send us logging, then we get our admin queue message and simply copy
this into the health reporter as a new event

4) user space is in charge of monitoring health reports and can decide
how to copy events out to disk and when to delete the health reports
from the kernel.

Basically: extend health reporters to allow multiple captures and add a
related module to configure firmware logging via a health reporter,
where the "event" is just "I have a new blob to store".

How does this sound?

For the specifics of 2b) I think we can probably agree that levels is
fairly generic (i.e. the specifics of what each level are is vendor
specific but the fact that there are numbers and that higher or lower
numbers means more severe is fairly standard)

I know the ice firmware has many such modules we can enable or disable
and we would ideally be able to set which modules are active or not.
However all messages come through in the same blobs so we can't separate
them and report them to individual health reporter events. I think we
could have modules as a separate option for toggling which ones are on
or off. I would expect other vendors to have something similar or have
no modules at all and just an on/off switch?
