Return-Path: <netdev+bounces-8783-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 270F3725B9D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 12:29:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 567C228127A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 10:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AEAF35B37;
	Wed,  7 Jun 2023 10:29:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6641D34D9D
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 10:29:49 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2E819AE
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 03:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686133787; x=1717669787;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XiPOAgPDP5Ml+HXLf0/sFmAjYLwaazGZpgHj+4uVjm0=;
  b=mjEu+SAJQ5Q/MDvzn6LrbadyKniiSREBluQFBC2KEqmxYT2vdDEta1k9
   g4kRbZC26PrMxNiILSA9hMX7zexR5miUxgNFS7HLGuXJEB+w/1cWViyI2
   ao8r/wyT43KPAm7+P9EuaSzlWdWR6Yfgw4cEKZsmY5imigF1UhQI6aUjM
   HyF0ZGbfjl+1QGevO/B9D/j7tLxSOM0LN9uIpABj3Bcnw53stvCbty5Va
   2v/gPbF8gPidq97XFSM0WI8YvRsh72c2/lktI9lk1susD05ImtQJjbJbV
   9fkh93fkJL36/Zh8MHhPPAYg6Byf39rsEqCaLZygt1tpXLckDYgvF8oxH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="385267384"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="385267384"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 03:29:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="822066400"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="822066400"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jun 2023 03:29:47 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 03:29:46 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 03:29:45 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 03:29:45 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 03:29:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H7tI97ABtGlae0sMIxBOd64wlN3Cmms04gN/x0PBrefAxfBoTPyYFCXedCtV+OJbVfeG7OLQJRaNthaws03JzfrJI6Z5EcJ+qAqbfq6ZSRtcIJmDUttiVN24wFSI/1VXnLMrAAVFn7Q5s3L7BMMZ5fG9NpqW7bhaJbWU2SsngO9bDOv3EDdS9dEnT9S/0KT244p/xLJqnpD9tIEz7CDbc17IfQ4Og5oP1Tomt9EkM/efZ+9BdmRzuXq2Qh0IE1QsfBl1vWvg6XQ7lsJAgEzQ/DaJUedpieLlp/Ux20JbfA3tYCDp39JBVxvXf0nuaOzfIrNkblEEa6pzZ4Uu1yufIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pifVH0sFLF48ytZRHQoQBS23t09Z2X5bFLSQGUc4rW4=;
 b=kuLbmOtkDR27hmPmEZQgju/Z5H/F1uQRjCUtU4T+MAdm+5EQVn4rwq/87d8T1HeiVg7Ry4NoAqs6pFvinCSqTls6Ht2TDC4L4eyGA02WwGPVQyaA7J/KJfAe7eWdGNCzuMovHo4x2O2ILlXjp5ZxhP4vhtrU0t4WUg2f/q75yUyWGS+Sx6OY3aNtki459nldCrPVg46DG1a2hKpe8382auDXNjKvXvF7NV9l509LLEx8XpabTKNrpKbGMrWNXjiMmN2XGO/jKeEht98FZ9vgL1uK1g5BG/vGc9YDAswWBs4UC6SCT0ToSTG1iS84r1pp8uKehhda+rlnPOQwGZBIVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY5PR11MB4451.namprd11.prod.outlook.com (2603:10b6:a03:1cb::30)
 by BY1PR11MB8006.namprd11.prod.outlook.com (2603:10b6:a03:52d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Wed, 7 Jun
 2023 10:29:44 +0000
Received: from BY5PR11MB4451.namprd11.prod.outlook.com
 ([fe80::c5b8:6699:99fa:fbeb]) by BY5PR11MB4451.namprd11.prod.outlook.com
 ([fe80::c5b8:6699:99fa:fbeb%5]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 10:29:43 +0000
Message-ID: <b7b63c6b-7bfb-6bd7-e361-298da38011a4@intel.com>
Date: Wed, 7 Jun 2023 12:29:36 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH net-next 1/3] iavf: add check for current MAC address in
 set_mac callback
To: Jakub Kicinski <kuba@kernel.org>, Maciej Fijalkowski
	<maciej.fijalkowski@intel.com>
CC: Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
	<pabeni@redhat.com>, <edumazet@google.com>, <netdev@vger.kernel.org>, "Michal
 Swiatkowski" <michal.swiatkowski@linux.intel.com>, Rafal Romanowski
	<rafal.romanowski@intel.com>, <aleksander.lobakin@intel.com>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
 <20230602171302.745492-2-anthony.l.nguyen@intel.com> <ZH4xXCGWI31FB/pD@boxer>
 <e7f7d9f7-315d-91a8-0dc3-55beb76fab1c@intel.com> <ZH8Ik3XyOzd28ao2@boxer>
 <20230606102430.294dee2f@kernel.org>
Content-Language: en-US
From: Piotr Gardocki <piotrx.gardocki@intel.com>
In-Reply-To: <20230606102430.294dee2f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0049.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::22) To BY5PR11MB4451.namprd11.prod.outlook.com
 (2603:10b6:a03:1cb::30)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR11MB4451:EE_|BY1PR11MB8006:EE_
X-MS-Office365-Filtering-Correlation-Id: d9c82abe-084f-4bff-0565-08db67421b9a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rp4QzvGm58Ulql5N7BGjfUNeWyMyUHMCuuie1zqBZEtg/SftthTVMTrLWCdeZutz0Fr0Y8DywqerS1TQDxZmqIUySnQ9xI9xWfzhjPRugcPuUxg/DTjtnuzZpA72wwhgcOSBmI4K/w+e1dBB5HQLm1Mjz7AqjcMZWbKSqcLKYHQQuAhxGg+jqnIKw3Z2QtY9/cL5vCFqd0LKgu04j9t740acaK3/YwtlDt50KtRydRHrHWxNaS7tvvIuFieVXKR5xDrb5Y7+PXnMRxACd9URl9xr3D1v9hz9NFICtvxPGpWlHIZ+DpyIGjTFp6Bv1dDmiQp7rXJz+1glkAmEenZozURvmKb3zonYO6s11TD7piXXYkJpnhbEk2BXXHJy0Uta+AQRYf21W1Ol56Um5uUV2sStUPTbApgR17mDT87xbIq2s+UQ7g2YEdNzGB4q400NjcAw3Z9R0nJ7OP09xSEYv2VjcQMcWfCoxhXpImmAWsT+u5dIDeXPX64PF6qQcrP1WjZxvgr2UHLP4q7Hg2LTue/h1/vRRvK2t2+emZLWY1V0S7cUpjvkAZCncmWX9ClQAh3lZdI2+hYmA0bROfeLM+ixhAslVYGfcBYpHf8H2VLFGlZHIOMU+cYGz7/recBGktI+PktM0NzG75j/fZ/45g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4451.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(376002)(396003)(366004)(346002)(451199021)(86362001)(2906002)(110136005)(54906003)(41300700001)(38100700002)(8936002)(8676002)(4326008)(5660300002)(82960400001)(36756003)(316002)(6636002)(66476007)(66556008)(66946007)(6486002)(6666004)(478600001)(31696002)(186003)(83380400001)(31686004)(2616005)(53546011)(6506007)(6512007)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NmEwc2tHQ3U0dzJGMWNiaHpva3dRSXlUMVBOM0Q2ZTl3RVlrcGkxWEpLSFR1?=
 =?utf-8?B?V0hkYnYrTFhKRzNad2pHcFhRcHdDbUxyUVNaUnNWenIveVZiWmVBTmpZUy91?=
 =?utf-8?B?aUMvaVgxZWhpYmZMeXNCYnM2NXpsYWNCb250SSsrTGl2bXpOQ2YyTlBFL2tE?=
 =?utf-8?B?SGNoUWQwaGh0RE1GSVFPWENhZXBYeDJrb1JPK09HTTZQZWpKaHZGT0x6cWtM?=
 =?utf-8?B?cXlITVczUTM1bXZWTkhxdmxncE10M3JrK0QwVEVFOTBCRlN2YU42VXVoL0E1?=
 =?utf-8?B?WHNUbHJFcCtueUpGOEp1bHZTeHd3NGNhbFZETU9KUzVmYVYxdWxSUDBaM05G?=
 =?utf-8?B?Mm5XMVBESml0Vlp5dThrdVdsU2VWcyt4TGRxamJDYTRQMHYyd0ZLdS9EV2pM?=
 =?utf-8?B?S0tJRTZNUFNQQWVHSERwM3RJN0p1RWZwWWNqK2g4ZUNpTUJ2dUhNeDhWYURx?=
 =?utf-8?B?QlIzR3BySzdGQlBwZkZ1QjRJZ0N2MFl5dWF2UjRpbXlzUGRvYkNSMHFaN1Fq?=
 =?utf-8?B?NFBzbnNjWWZmUHlpQlBWOG5UN3hpakxBcCszYkJhNWs1K2V5c3dCSGVGbVlp?=
 =?utf-8?B?YnFKclcxK2FTLzBQU1EyMkZxN3ZxRU5OUXk2clBpY292OW80VzByNE93ampB?=
 =?utf-8?B?cnNKcDh2SHVqWjlqellTeTA3Z2lLU2VuVGxCc0FaamEyUzZYNHNHMjF6WVB0?=
 =?utf-8?B?TVozanBTQXhHTWpvVFI1S0JNTWpWUTRNZWh0S21PN1V2MGcyeUZzUmhkdkFW?=
 =?utf-8?B?M3R1TVcySjZsYWpRQ2p6eHFLTTRhVHorQkRGZzBHUURSOXBmbnM5RTZ6V3Vh?=
 =?utf-8?B?YlJpVXNQNCtpdVBadDJnQXFETUxEQjJrcGNoVmgrOVA5ZExtQW9ZYnhjZnBG?=
 =?utf-8?B?K1BlZmpvbUpNYWFUaWdWaU1iY3VOWWRQSkFLKzlIUFlDMng3TDRsVXJyMnZ5?=
 =?utf-8?B?MGtxSGFqdDJQeTE5aDV2cUpQRlEzdk1FczBPYUMzVXdZRksyZThMTHkyakRs?=
 =?utf-8?B?QnhJR3FoTTR4RXBFTVpqdVQ2RWRQb3FzN0wzdFZsUjcrV2d3Z1c3VnQvbkcw?=
 =?utf-8?B?bHZCNzBjbEN3MGdVaHhFTERjY3UybG9tVVltTW9WeUJCV0FjUnRaSldCMHkv?=
 =?utf-8?B?VlNGeTZPUjFuOVBxTGxRUGVPSmtrTTkyR3N0N0hHOW5HZUxyNzlIZnZPakdm?=
 =?utf-8?B?WGoxWFM2MFdjenhKamdlUHZpc3ZhKzdNR3dVSDBiSHZRVVJVTmRrZEFESGdX?=
 =?utf-8?B?MmQ4ZXpJN0dLZTFHWmp0c3JxeGhEMzYxS2daVkVLQVo1cEpHeVlCSmpzRTIx?=
 =?utf-8?B?RFV5WkdQb2JFWGN4Z3pKNUY2ZGhsNk9xYUFWb2ZpODJEMnlTWWpQamhKRDM5?=
 =?utf-8?B?bTBjL29rL1h4Rlg2bXNjd0dIZE1NU3c1VGUwRU0ycHYxUDJNRXZQTGRteHps?=
 =?utf-8?B?YnVVNU5OWGh2RlhXK3RxbjVwRlNMU0lXelQ2UCtGVjRTMWl4UllRclpVcTV6?=
 =?utf-8?B?dHFwTHNJeWRURzMvalpPbGdmekxnRmo0MllaWmpBUnZnLzJXZkFCOUpsdFUw?=
 =?utf-8?B?YlI2cC9tT05UR1JpQ0lReDZVU1o1N21HSWJDazVrSUtmKzFFU0R0S1FFTUNh?=
 =?utf-8?B?WllqWXJYOSt0TE1ZZTU5aUhsSXpudzNSL0NUKzF5VWtlWSs2MEVIRytybGZH?=
 =?utf-8?B?NUhSWTE1MkxMZEthSDlTTFNNUjdSb0h2OExheFhJNXhmQTc1ZXZzT3ZNUndV?=
 =?utf-8?B?S0JVRGt1c01RTTJGWVpNZzFBOEtQMmRzSnFBcVVwRkNKZ1M5UUZtcFlwK2pW?=
 =?utf-8?B?aE5rU3IrcW5McmVLbVE5MTg3U2c3RjMrbmwzdTJFL2dycDVBNVcraEpYOGNu?=
 =?utf-8?B?REVtMnhkdGpremY4WGNOY21rcHkwRGJ0Vmp6ZFZKT1gxc0h0RDFwSzZETW1j?=
 =?utf-8?B?Z2huQ25HK0M3dXVhT3VTS2RnRHljQ0FMZnArSTlJSUpUV3F6N2x6TFIvSmFi?=
 =?utf-8?B?UHlQTmttR1ViYnozSm1UMHFWa0Z4K2JPa0hHb2gxVHJxR3ErL1hEcC80WU5r?=
 =?utf-8?B?ZFhnRS9UdXVjWThnK0Y3VmJweTYrblQrN3U1U0E2c3NaeXFGU280TXZQTXFQ?=
 =?utf-8?B?UU54QkV0M1ZzYThnaThEeGJaSDNNaG04bU5vcnpwYXdCVWhwQVN5eWdnU3kr?=
 =?utf-8?B?M3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d9c82abe-084f-4bff-0565-08db67421b9a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4451.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 10:29:43.4438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7qc06u73+xQsZ01jVLQiXQmRuzCApeaVLjam0//f/al4Y0Ye8KaNMboaJ0uupkYd17IcLZWgcAhCVjai/7jeAV4wKKFcsN/pfPOv04SI3fM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB8006
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 06.06.2023 19:24, Jakub Kicinski wrote:
> On Tue, 6 Jun 2023 12:21:07 +0200 Maciej Fijalkowski wrote:
>>>> couldn't this be checked the layer above then? and pulled out of drivers?
>>>
>>> Probably it could, but I can't tell for all drivers if such request should
>>> always be ignored. I'm not aware of all possible use cases for this callback
>>> to be called and I can imagine designs where such request should be
>>> always handled.  
>>
>> if you can imagine a case where such request should be handled then i'm
>> all ears. it feels like this is in an optimization where everyone could
>> benefit from (no expert in this scope though), but yeah this callback went
>> into the wild and it's implemented all over the place.
> 
> +1, FWIW, this is a net-next change, let's try to put it in the core
> unless we see a clear enough reason not to.

The reason I was not keen to move it to core is that a lot of drivers actually
perform some actions even when the MAC address doesn't change, like writing
to HW registers, performing link down, link up routine, notifying physical
function drivers, etc. I'm not aware if any of them really need this kind of logic,
so I can't stand strongly against new proposal. If the community is fine with it
we can move it to core code.

I need a piece of advice though:
1) Should I fix it in this patch set, or treat it as a separate thread?
2) I suppose the change is required only in dev_set_mac_address function, but
am I right assuming we should do it before call to dev_pre_changeaddr_notify
and return from function early? What about call to add_device_randomness?

