Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF19A6A12F6
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 23:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbjBWWry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 17:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjBWWrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 17:47:51 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1568919B3
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 14:47:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677192469; x=1708728469;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lFJeDe4AChFZmTJA+P2GW6UDcvhQiDhQoDAZUSZK8IY=;
  b=IR7gPw7dAdQ8xwSAvZAmXXqPgLpQ4W+HOhsxPSOh4OzHfLmrN8vJKoY6
   3MZelu0lRziHzCwmpk7z3qSCW5CzB6YYLZ/cl8E2JZo3jUyUriwD3ymjb
   MTwIsquowMp4SJPelzsiN2LKsKz+qRfPS10wpSMRrmVUDUzHLPlYzj/0w
   3ZjpHrV79AA3EsBDBrDznjWwJrXIr0s+t7s4YF4pa0UiCu/B2c/4uTO4i
   nOmHp9YXJa1rWCsXUWwjZF9gVQdN7DuFmJGQeIwj1UkEdJfHKgu0zUjbK
   5CtpSOWJryFN3oH4b+/fXZ1cfqJJ6yjFUsBeNz56TYrT5b7A3IokUH0EJ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="419577139"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="419577139"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 14:47:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="796517132"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="796517132"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 23 Feb 2023 14:47:41 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 14:47:40 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 23 Feb 2023 14:47:40 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 23 Feb 2023 14:47:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DCi/erAdsq8QcsZoFKNmzdmYV2Z6MCeqkv5mSrk5McmsZevhKufYLJWb4VdAyHSa61+1DdPu/mGO1cPL3V8VsuPtueneX5r2Uq2aysyz70yxsU21MO6t5aMHvi96AR+z/pUUJ6p6/yCCQAWzcrGGV1NihNJAVgi2FXRZa4Lu45mo595lK6rYqMAdeD85m3qTZTn7FJE7AijaGrgRPfDc64Jxnv+PMZKxZZ3Qk+e5wusfx9LW9vVcFdulVHdGekux9EmdV61OakvrnPvAtmG39tp7Iv/9lbhwib/SK4yNlvA4qqsRDH3T2JDlBNngL9CfW7FM66zg1htATLh1NbsmCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M5hwOKvGZwJJkvOagPnTd8DxV/yjuJ9Ye5vB31O6UFw=;
 b=dih7w44J5EG4UBsDFETssZ/AUaH/XkO3kktSX4fzTaXcVlV+XvPb8ukYkSEa6kt+j5kBBjaTirxc3Rgz69R7XRq/n5M5nrRVOS1GM7wpPOdVnh3IBjEisKG6CTLmy3wAuzMR6lm+wIUERbOorGZU638fFPl6Wu3b3MwdHFCqoNt9/d83k1Abai95Ih8CQoJDigZDWAsUqKtt4KutFlMNX3CHRgVA8KvWaG0C8U826OrCMTCQtVpFHnGoiY7a0K3G2e06gUhMn8dLGqeNcQb7ORATv9QJiMV3Umuw72S79XXqCLp0YBk9vWG3Ot8vHm8rYDy0pdT2jE70xPJBuh6Jfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM6PR11MB4691.namprd11.prod.outlook.com (2603:10b6:5:2a6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Thu, 23 Feb
 2023 22:47:38 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%6]) with mapi id 15.20.6134.021; Thu, 23 Feb 2023
 22:47:38 +0000
Message-ID: <1cadcc9e-c934-3d25-98c4-296b0ace0877@intel.com>
Date:   Thu, 23 Feb 2023 14:47:35 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net] net: add no-op for napi_busy_loop if
 CONFIG_NET_RX_BUSY_POLL=n
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>
References: <20230223012258.1701175-1-jacob.e.keller@intel.com>
 <20230222205352.74737c2a@kernel.org>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230222205352.74737c2a@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0012.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::17) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM6PR11MB4691:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a2aa97f-89c4-434e-622b-08db15eff696
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 72lo7hqysjgJIIlOFQUxIof63l9k8dqsH1y4uW7mie+FIm2EBp4uGNrOClivlgeFgxiyWmNJ8QMoWYw+juWOq62i9FenDBxyc2xUFJAF/fKVgbwrqxlJEMugVUfPXZ94CtS8IgOW3skzrswjccR+WDSo+HPASD80OeNS1EyuCjD5mRySz3Lja0gJD7tnyfECntDJEqPSmGW+14WBFv/nfO7wG4Ll4VPTaiwGaaE46zgSR3VsDqGU+tdyga+Le7Y7yDTaC1k8ya4lkUiW2lCAhRTsNozYbGZsqq0uLxziPU3tiE3GbQFzShrAyZ5KXy2mKaKuGMwFM1lEHeXPdtSoHaNk5nbFbkGHyfrfTg6DZfl6Ag+ifwJWLgmOfhmfTsE7ktGHfXJjVkWB5J2T1Iql28zI0w1VKuLZ8rdeYbEu6o9bffm3kBdgrJIMlmq/A5JQ9DaPwNv7ePJwJ01Up8Y7gZCmb3WQmaTaXIz68pLuUeyJGYU3DWtCV1MvMr+4KE/EiqVm4DM0Ll1IvpFxF8aF5aOl9UCMMbkjWG38HsF/xeEaa1OY5BK42swhMXYgMfL40XW2vgoEFnTnVCXpe4B716e15ikxi9dq3idApIXbxFiq89Ax6rXSPCf+mRf0f/uBD6+EcnqPyOyw6ri02xqp6/tsNygo92Ke2vlKSa1dy4F2B9YWASx0xXA6nm+KMq5R8mNOfYxFZZAbaZGom61N2xEbeCXX33q7WCpDfyq1RMc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(366004)(376002)(396003)(39860400002)(451199018)(2616005)(41300700001)(83380400001)(5660300002)(31696002)(478600001)(186003)(26005)(8936002)(38100700002)(86362001)(8676002)(4326008)(6916009)(53546011)(66946007)(6512007)(6506007)(82960400001)(316002)(6486002)(66556008)(36756003)(66476007)(31686004)(2906002)(6666004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzArT2xmWTR1L1JPYnh6bUFvU2lEYXZQaHRlMTBXaHgzVzE4dUxWbGRLV2hB?=
 =?utf-8?B?eUpsbWpZaWMxeXhZK3Z3RDVqSFhFVHRmRU1YK014Mk9ZMnRCU2RFWXdNQnhy?=
 =?utf-8?B?TW0reEwwRWJLUHVISmRMQWhsVVFZa3R3eitRaFNGUzdYdFJEdDh0MGd6SGNZ?=
 =?utf-8?B?a2d6RnJodWRFejAxS05yOUk0dmFQUXRzT2NXenloc1NpRTJQUHE4YXpTYnEw?=
 =?utf-8?B?b3ZMTEd2bFljQ0pmaEhpZzlWQVBQNVRualBhQ2w3RUkvMm55Wk1tcWg2L0s4?=
 =?utf-8?B?WmFWNXYrUGs3SVd4bFRTRXlnZ3hvUDIzRmo0QlpLTzB0UFNNOEE4Z0lOY0Qw?=
 =?utf-8?B?VGk1MWZ4U0EwRkxKbEh4K3VyK1J3dmNja3prZEVkQmxmdUdPeG12K1dTYzQ5?=
 =?utf-8?B?SVc5b29Da1YvWmhIVmdQbnI4T1lxTXFOeWFhUUZKdGhFSVRtYjFVQUhDNkxK?=
 =?utf-8?B?NFpRYUdQZE9BZkRJU25ITGV2RWVIUW9ieGpmSmNEb3dCb0czeWZNTEkveWJX?=
 =?utf-8?B?clNhZHB6WVdMQk5XaW1VaUFnZkJ6ODh1ODVYNGVzWlNPY1piMnl6MVpoUU8w?=
 =?utf-8?B?SFZkNUhONTF4MHFaQjFOSytzaEg5UHY0WEhSeDY4SGdzbjcxODhLYkdaQ1Vj?=
 =?utf-8?B?cmgrRnBWZUhiTzJzcG4yQlNOcmh4eGZNdk1sZjJCdFZtaXlIMVE4aGVWMVdK?=
 =?utf-8?B?dm1zSVRoeXU5azAyWXJYT0VXdVhEeFgzMERuSTVwZUliN1RxM2NMb0N0ZGVs?=
 =?utf-8?B?aWtadFRLanF5WUd0UGJhS09RWDJ4a2t4Z2dISXl0ZGZocDd4MkNIMWZmV2pX?=
 =?utf-8?B?Ry8xWTdNZHVWUVk1elNLQjhSMFhMbnNQL0R1WmppVjRCSEwzTFRtNDBRYmsr?=
 =?utf-8?B?YTRNQTlSekFWcTlFWlFQckNWamQ0SnMzOVJzSHJxRkZ3a0ZHWGcyNStBNHQ3?=
 =?utf-8?B?em1ZZkplREVseGFLNXQ2cDdZdGd3K0RobUFWQXhjdEpwTkNwZ1I1MTVBT3cv?=
 =?utf-8?B?VDRRTXlSZUttdjFOdTNSdytxaGxzYVdkN3RBNGZwN2o1bE0yaGxrWVFVSUlU?=
 =?utf-8?B?S2txUlB5YjNXNVphMnJWRXFqWkJvek9WdWQ5N3RoOGwwU2wyRlJBU1FaZ2tX?=
 =?utf-8?B?RUg5bXpKNElybzRrYlFwM1JUM2JCTFNENHVHODJHb01palM5dnNBVEoyQXIz?=
 =?utf-8?B?QkNObGtjQW1tbzlZdGZNMFlLQUxjMTZ2dEVWRFBGN1EwallRZlhqbWRiNi9x?=
 =?utf-8?B?dE9LbWpON3VaakFiNjJoT1k0Y2VhRlNreFcvdUJPQ09PbFVPcm4xdTdwN0hv?=
 =?utf-8?B?cHB6cWVabVgzS1psdE1YY0hGWThqT2FYNHc2OUpmVzJmY0VwUHhtNjNaM0hu?=
 =?utf-8?B?YzFxT2RqN2Fxd243TDZsdzllU1dhYVFxb1h6cExHalpzOFYxZi9SSGx6ME9o?=
 =?utf-8?B?dWhELzBhd2t1WkRBU1R0K2wyN1VVWENyR3VDWFoxUGZUMVduczBPUnR5Qk4w?=
 =?utf-8?B?R1gzNnFIRFBxSGF6TTJvRE5mc3VZMkkreEI2dkI2V1dvVjlNcjFMcDNtTDlT?=
 =?utf-8?B?UXlLR3VZeUZRa1gwYnVEZTlENjExRXJMZlJrSHVMT3pqN3Z1VHJBNVRmRE1Q?=
 =?utf-8?B?K1FmSHhEeTZmcC8vdWJWWFRzeUh1NC92WVk3SSttWFY3bEUvUVpDcmtIc2JN?=
 =?utf-8?B?ZUZIaS9XVTErY214SXpvZ0dKTU1EQTVGYXBRR0xKU09US1ZxVG14cnFUMWVw?=
 =?utf-8?B?em9pWjlWOWxQTHkyaEJoSlplSitRZXZYa09hSXdlQnM0dHRDM2NzVklqeWF3?=
 =?utf-8?B?a2VjYVFZSnpDcFIxaC9iZjJ1bkw0Z0p3d2haK0l4MnQzZU5vMUE2Y1paTU5Q?=
 =?utf-8?B?VFVZUHF1SVhtZkhrVndFRVpoWjBlMDBJendpeG1IQ2V4a1Y5VU5xNUk4aVVX?=
 =?utf-8?B?STVhNHpJZFB3Zmp4R3V5UTRDZmZwdHUrcnkzR05JTHVtb0MxRWlRZFppWWdB?=
 =?utf-8?B?dWwwakxhTmtqQ1VyN2pZTm5nSFJsM0xndWdwK291bDdHOVM5ZE1kd3BhSHN4?=
 =?utf-8?B?YnhwQlpRc3dBZU94SkR6OHRPQmVpczVDTHZoeHN2blJ6a2dERDNMbFcrbys4?=
 =?utf-8?B?WEhnQXlvb2c5aEM1ZTNMT2R4blhTTlBjUU1XSVpKNUttNDA2cUI3ZEozWXY5?=
 =?utf-8?B?RHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a2aa97f-89c4-434e-622b-08db15eff696
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 22:47:38.3797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dncxbx0PDz9S+pSzrPCnjKS3vh0JUaWurbHSrumlWcMQkAGCYaCPDpIb0dIDISM+0zoq4ez8dckYvr1sB3v3jKMJe6JA0TKXV5rPZdcm+f4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4691
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/22/2023 8:53 PM, Jakub Kicinski wrote:
> On Wed, 22 Feb 2023 17:22:58 -0800 Jacob Keller wrote:
>> Commit 7db6b048da3b ("net: Commonize busy polling code to focus on napi_id
>> instead of socket") introduced napi_busy_loop and refactored sk_busy_loop
>> to call this new function. The commit removed the no-op implementation of
>> sk_busy_loop in the #else block for CONFIG_NET_RX_BUSY_POLL, and placed the
>> declaration of napi_busy_poll inside the # block where sk_busy_loop used to
>> be declared.
>>
>> Because of this, if a module tries to use napi_busy_loop it must wrap the
>> use inside a IS_ENABLED(CONFIG_NET_RX_BUSY_POLL) check, as the function is
>> not declared when this is false.
>>
>> The original sk_busy_loop function had both a declaration and a no-op
>> variant when the config flag was set to N. Do the same for napi_busy_loop
>> by adding a no-op implementation in the #else block as expected.
>>
>> Fixes: 7db6b048da3b ("net: Commonize busy polling code to focus on napi_id instead of socket")
> 
> We need a reference to which module needs this or a Kconfig snippet 
> + build failure output.

Hm, fair. I found this while investigating something else with code not
yet submitted that uses this function in the ice driver without checking
CONFIG_NET_RX_BUSY_POLL. I assumed this would be a problem somewhere
else too...

However, I just looked through the current tree and the only user of
napi_busy_loop happens to be under a CONFIG_NET_RX_BUSY_POLL check
already so I don't think this is possible to trigger with any in-tree
code at present.

Thanks,
Jake
