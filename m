Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9816B620AF2
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 09:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232958AbiKHIJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 03:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232243AbiKHIJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 03:09:01 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903FE1EAEA
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 00:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667894940; x=1699430940;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fBn84NZYMWAMDbkZdaQ3DJ/CuNsUHRLajWUM0eI20b8=;
  b=D5onXDM9PVoS78K/3MZNgXQR78C/iZl73lUQbsGuQOLm/XbVMdi5un0k
   AU76KvbtGbvgszACIzMvTU9WdIrBTSU2jKqvpODX42C7ZdI5ZuPAG+7vA
   cY8qgkcj+MDj3xPhALYh7B3WSVvbtBZ9g4Dby0L0D8A0LPxVJpVN6eafQ
   T5bFlh/qoTWJTWeQREYILpuPFbeFXgJ+/FV4wygbzmfP2nFN8y7vdFxIq
   0qx1/+CqJTn4jTCCh/ijwgbwxGTWEd27npGUcGIPaeXg6ZWK97OlXnBJH
   8gjcbGQ9tqbbtw5nfVifFMdvJpEOgd1k/w/mETIse1+RImu7NBrJMrZbI
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="374908061"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="374908061"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 00:09:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="669467341"
X-IronPort-AV: E=Sophos;i="5.96,147,1665471600"; 
   d="scan'208";a="669467341"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 08 Nov 2022 00:09:00 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 00:08:59 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 00:08:59 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 8 Nov 2022 00:08:59 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 8 Nov 2022 00:08:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jUiy+MAOSfBO9LrE5GF0i6+3yNptjBEXVw8HprdH1Q1mXfW0vckkoajiPVtUgMzFQ5pbXDprDABxHTMr2hchmzxtDjWVqTOsC2VALEFthiLq8Y/EEgwvgaqmXAGnOPt+6rW3mipxFOCRCow4DWN/24z5xIB4YYcKxlheYth56w28ver9XxHTCYxvsYq2Mhx/v49zvaT8KtnQo/OsqmIE2fbxXaM2PBv5P11CncXNg9Sa2R9GDYvWs5RjOqwJtqGcVRCyHX9LFPsReq6J1LTFFxQjf3aXpFF+xlHPlC4Fl3XMZuWM/AS+e97v+77VIwOxiD54xunmLNJGV/Lz7DK5lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fBn84NZYMWAMDbkZdaQ3DJ/CuNsUHRLajWUM0eI20b8=;
 b=ZDsFuSVq/6Evkumz+9JT+inhZiyuvC3yNChR3V7qBAaHCHDjJZ+DBqt99NL0EOjWbkCZGlpfB1x1n12fNyRHCZsnWLrEHvAJlabsUYgzl210DuB3EJiJV0qCRaHgzXC6qSES6OmPW8Xb6EWdwpjVNLfyysvBtrFTQ/xcmb+eQszUH9L0oisYY1jA4hrzLGD0Xt4uw3apZY6Y7pTd/mhvzosJ7TjMwhpU4CkuBL7Qo3JiGyvLPFNjViuHSJ8oont/+zh/Rg/mTlTmvf63kK6zD9eBaQ+2CNCBWbAocf2IXf4d/jK/eLxnw9kCy6IIGgaOewGYqU2MCIS80tLAljmDGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by SJ0PR11MB5647.namprd11.prod.outlook.com (2603:10b6:a03:3af::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Tue, 8 Nov
 2022 08:08:52 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634%8]) with mapi id 15.20.5791.027; Tue, 8 Nov 2022
 08:08:52 +0000
Message-ID: <f0075083-8a11-a2f4-a927-7cd5f255bde4@intel.com>
Date:   Tue, 8 Nov 2022 09:08:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v9 0/9] Implement devlink-rate API and extend it
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>,
        <jacob.e.keller@intel.com>, <jesse.brandeburg@intel.com>,
        <przemyslaw.kitszel@intel.com>, <anthony.l.nguyen@intel.com>,
        <ecree.xilinx@gmail.com>, <jiri@resnulli.us>
References: <20221104143102.1120076-1-michal.wilczynski@intel.com>
 <20221104190533.266e2926@kernel.org>
 <561f25bc-40dc-78c7-0a2c-e7e0fe74ebde@intel.com>
 <20221107103145.585558e2@kernel.org>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <20221107103145.585558e2@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR0202CA0016.eurprd02.prod.outlook.com
 (2603:10a6:200:89::26) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|SJ0PR11MB5647:EE_
X-MS-Office365-Filtering-Correlation-Id: e487cfde-1db3-4b0c-cbeb-08dac160794d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GnnCezV0+fI48PQNC5ddC3K5R/oVySFqA6z/ThuBB+0wpB1K8239L0eFHZh/vOUxSmBHE7MG9PBbp+dwuX8K0ceOyOJoznKOriIYd7JUqxXT4dH3QUeS2LOEVZN4KVSOCs38g0ziuqBNNuTMhEODtY+QQIDN81BMTVLLI3vepj6IXsQv3xO0slqik7iDfMVd/nzUAWZsX2nHvpGEfsXwB4bRrYa0sM8S6DViuLvuzgDy2bMHzpisCj4yALKCtqORWw7klTbAz+6ulmPuQVf+ZRtrDFjcmM8+33kcxNF7qh4v/9TiFhWbOggG8Hs72ADKaO4D0/naa3hFYDTLSkZjWFs1BE36o0rZq/cfUVMkVS2yQkTwTJ5O1naLfwdxbRk3MaSRuJ+GvAyPF/utOE42mAM1MITQQeqpR6BSr+tmsRlMmS5l8bYZD2u6mPczxjwViMjd81KZKdhIUneY87l8ij1EDG/EHiX6Lt/EDrT0Pyktlqu9F9fvkrTdpnKDmyrSymQbJ6wnn3Zb4eelqm8C/JqI85To/HjygzCaIujcB81TSFsrNJv62JeWx8X4KfT7yMxV8Y82uPVQsv1pFm6Z31T8w2/I/oa+PeeRd5hEt7gf00isBEvHOB9Om1cUsYUraBKEgiOclRwmkaHYI/wSj1+tkBkOh+edr+iOVebqoXMvG0qtC1q0KciNSsob/sx5oQwjQCb1zyfklWThqt9/zWk4y23OhVjenN6rbU2s60T8PpoyV35i56GDMeIf4bPICj+2MqXUIo5DiUKEbs2FNi2D79LyRvUS7bPSQxTF8kc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(396003)(376002)(39860400002)(136003)(451199015)(478600001)(6486002)(31686004)(38100700002)(86362001)(6666004)(82960400001)(6916009)(31696002)(36756003)(8936002)(53546011)(316002)(83380400001)(6506007)(26005)(41300700001)(6512007)(66946007)(66556008)(8676002)(4326008)(66476007)(186003)(2616005)(5660300002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVEyL3B3WTRKdjNjaGxQamZmZTRlWmxiN0pubTErdVkybG9HYk41NHZWcnlT?=
 =?utf-8?B?eTN1ZFhGamtZS29wajdSOEVOSDVvSkxvVVRBbCtkNnRLTjNwaVBmUXRodndU?=
 =?utf-8?B?bXowUGk5K1pRa0NpNFI0TjVKK291VWpPUkJPNTRmRVp0UkJ1NThVTGZSRnRy?=
 =?utf-8?B?aDM3MmYzcUJQL2F3OGlCR2FkQkRqSU5meDAreUxTR0xqRHVzWWcwcTJQeHE0?=
 =?utf-8?B?aW52U0l0OGthaDRFT2R6UUFqc0I0dzhDaTNIM0Fka0QxZnlMT1BZTGxqcWJ6?=
 =?utf-8?B?Q3R6MFJZc1dEYWZJc3pJT1dlWjZrZDNYMDJmbGZiNlFFSnB3MHdqeXBHR3A1?=
 =?utf-8?B?UE94QU9yK3hJUk5zWnIzaDRaVGpBbTI1VmtTUy9wcURaRW5iVFY0dHhmVzI1?=
 =?utf-8?B?QlRIdFE2MFZ1K2R6YmlaK0xrcUNhRzNvZDhnS29QTnFNaGI2dllvR0p2cTFE?=
 =?utf-8?B?aHdYTkcwQ2hKM3ZNQXJMT2srNXd1YUJRYlFHV1AvVklrSE1xYzVRRXpCdjNU?=
 =?utf-8?B?Uk9FdC9IMUR1MWdDRG5NRWRsRERleWJIeitoSVNQVDBldHN1bzRSd05CVzZI?=
 =?utf-8?B?MTROcWZhT09ieU9JVFp3UzZ6bVRCQTFBTng2dGtJenRUb0xjSXpiQUJwUTdY?=
 =?utf-8?B?QUNSN3htUVhpWkNDSFg0KytySlp6M3Q1aXp1ejU0WFpPeVdNbVJEMU0zaU8w?=
 =?utf-8?B?OXd1eGMvQXU4QVpiMDlkeENZaU1BLzBaQ1JyQ09XQUdHcjdKTVJrd3dDYW5t?=
 =?utf-8?B?clN2TUhJS3Jxc251U0ljZ3JJZ1BldjJCM24yYWR6UUdSWkRuUDE3enQ2ajZ4?=
 =?utf-8?B?RkZOVW5BRHFpWnRwYUY4QUxYc29UeWRZcTF3cnhKSnJMUzhpdFgvVE1vUnpn?=
 =?utf-8?B?RXRLdGNqN0hxMkg0L3phc3dGR2hINUNyaEZUemNqbVBJdWt5U1lLUS9rZGov?=
 =?utf-8?B?eFA0QnUzL3lrcVlrVmRFWEZDMVdCOFpGMVl3RGx0UjN2eWZTSFlZNUduK0pT?=
 =?utf-8?B?akRWRk5sMmZDWUgzV3VzQVhvK2F0SUNNTThNQmVKVEFWL0hFTk5DcTl6UGVM?=
 =?utf-8?B?VFBIS3p0ajErUk9pVDN4M29ZT3FIckEvTDhsREROTUxWUndzK2pJWFRXYmo3?=
 =?utf-8?B?TXZOZGpSSUxpSU9lNXdYbkliYmhjQ0Yzby9oWlVud29UTFV4QlF5YmZ2UzBJ?=
 =?utf-8?B?U1VMeWpzWlB2aTNabUxKa1hsMzZNcW9VOTRyNVJkWjZRRENESk1kT0s5Mm9F?=
 =?utf-8?B?djlaaHZaZE1vMHFzSERBY2xIaG5VZWJHZ0JlUTMwZDRpRm1kMGJ5N1VqQmdD?=
 =?utf-8?B?dWZqcWF3ZFp2cmJDbnRMaWJNN3NsR04wQWhrVEdacjVyMEpheHVMYldXRk84?=
 =?utf-8?B?QzZCVnBUa0VJQXBBT0pra2tGOHh3ZmtkUTFIOU1FYXdVdEl2bE81SGVpblUy?=
 =?utf-8?B?MU5ZVmRtVng1NDhhK0NjWkUxUXIwZ1dESDg4aWk1UitaSVA2Y3Nob2ZaMmxP?=
 =?utf-8?B?V2tQVGxZTWxTY3h1cHBydWFnazZBS0U1SFloT2xUQUxIMFlkNmFnS0l3NGdn?=
 =?utf-8?B?YndNMno3SlZXWThycXJKdVFsRHFTc0drcHNGTmdyZy8zRWlCVHN3c3Fubk5K?=
 =?utf-8?B?YTNuWGM1VXR6S2dZTXlLSm9ZWENmVTBXbzcrL29DMWowQ3hnd2VMeHRzQXQ2?=
 =?utf-8?B?amhVcTFoVk9oZ29sckRjTG5YNGk4dFZUYnpWT0JYOEpubEZ1RnVFSFRnMzZM?=
 =?utf-8?B?TXY0QmVvc3BESGpWdHovZ09CR0FJZ3NPMjJpc2ZkeWRxUUZmZkRSUlJsRngr?=
 =?utf-8?B?cVdZQ0J6REZ6UTBuNy8wWnF6OURjOEd3cGoxS2UzUXFiZ2JLYWd1eVFQRU1R?=
 =?utf-8?B?YlUxRHdJVWFDeEpFNlNGNWN1a2daT01tUW50cE05SXR6QjJkSElZNk1tZ29q?=
 =?utf-8?B?eHJVTFBzVVB5MURkTzNJcFZvRlFOWnVsb1lTOEx3dzhXUExJR3FqWGhIUTRX?=
 =?utf-8?B?RVdmOWlwOHJ5YUMvV0cvT0lIaEJ6aFppVG44K3UyWktXWmpLNEc4QmtZdXBK?=
 =?utf-8?B?LzRSd3dPb2NFVlhBd1B4Rk54OHpSTjFYQmdQalBhWWRMQ1gvM2pwQjZlcHNR?=
 =?utf-8?B?R1k3KzB2bSthVTZnVVdFa3BtbGpsaU41MWFibFhTcnFxeVI4bk8zT1NmRnBK?=
 =?utf-8?B?R3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e487cfde-1db3-4b0c-cbeb-08dac160794d
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 08:08:52.5165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N9muiqGWkw4nAHS8xtV+B1yUB8uJRpx/CoobVUxKdo88YT25bU5Nn1gBfUu/CdpTkrSi4XX6pMrVf6R3HRhvhkX4aUrStN7ErqQQUSeh7A8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5647
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



On 11/7/2022 7:31 PM, Jakub Kicinski wrote:
> On Mon, 7 Nov 2022 19:18:10 +0100 Wilczynski, Michal wrote:
>> I provided some documentation in v10 in ice.rst file.
>> Unfortunately there is no devlink-rate.rst as far as I can
>> tell and at some point we even discussed adding this with Edward,
>> but honestly I think this could be added in a separate patch
>> series to not unnecessarily prolong merging this.
> You can't reply to email and then immediately post a new version :/
> How am I supposed to have a conversation with you? Extremely annoying.

I'm sorry if you find this annoying, however I can't see any harm here ?
I fixed some legit issues that you've pointed in v9, wrote some
documentation and basically said, "I wrote some documentation in
the next patchset, is it enough ?". I think it's better to get feedback
for smaller commits faster, this way I send the updated patchset
quickly.

>
> I'm tossing v10 from patchwork, and v11 better come with the docs :/

I will however create a new devlink-rate.rst file if you insist.

BR,
Michał


