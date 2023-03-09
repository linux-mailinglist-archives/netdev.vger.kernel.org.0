Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55666B2B17
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 17:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbjCIQpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 11:45:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjCIQpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 11:45:23 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE9351F9A;
        Thu,  9 Mar 2023 08:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678379651; x=1709915651;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+xDJjqhfJn1/xbN4oInffvgB35pC9lYzmncwR0hVIrw=;
  b=XARSAWE8/x5DzzYDf1U5lD4wLm2eqPm1/q9q709K0NJ9aMwoGYS1rO5T
   FpqJSglCUB+aRnhY5Ca3EC3SSt/YDovzVH1YyqbSYe7Wv0Bqpq5xbBqge
   7YjrEvBBVfSPJIh3bFkfKtZG0olblu+AyF+5KqgsosqI1ZqPp6y0yxI88
   xX72Uqlqfn0SGs+7PeIdchXwOU5I+gFOb7wuy+iiaybgPI+Emm/hw9Qub
   TJkt6JuiVmZZ9rDUMoLPAAM+mEWIvSmO4sFj/qrNEqOYV2sB1IbrbpK6L
   9xyZgSC9vurBEiL8sDedpAyRVK9+qahbrPLMfCeht+mgsqIa/WZIRKEvb
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="422762413"
X-IronPort-AV: E=Sophos;i="5.98,246,1673942400"; 
   d="scan'208";a="422762413"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 08:34:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="709902609"
X-IronPort-AV: E=Sophos;i="5.98,246,1673942400"; 
   d="scan'208";a="709902609"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 09 Mar 2023 08:34:10 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 08:34:10 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 9 Mar 2023 08:34:10 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 9 Mar 2023 08:34:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GmgH+4H/iFtEANoVHHHIF4EZfvERUa/wz/yIkViXzO3SivghXHC2Ug+TipMpEEypFJ3in+Q6KIVPGyZaepU9NTzIEWfsclPaNwKN5OE4Ndxe81gsU3o0Gl4wokjG1aXvkXJHywKw8uzhdHRJvzEM6btpUaTHL0Ps7ZcfJWM5dN4AAJeEfu3VArf7LaHNmmDHVJy+fgiFH90UYxF21LCSLs58OO+tg6TIK60f/0IkJ2BfvVodAhYR5IxPdjYNxhxOihso/zs9QPTDPlnUuIgK1yv7Og6ARZvqSbngYE/BpQvJYCZV+aqkt2ExBoBL0zNpIeoShAOx5llMLdRKNN4EGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jcsZ4KRf+8AdvwDYbRFt6s89Cnk7gnwW47jCAtAKEzE=;
 b=S1qPnFdGPNST82+1P6lINLhbicg4FUdwWIu/c64mn7v4oh4YGoo3zOh9VkKKRYE+Ehxpl04m0Rk2fyhoqjSpfGj7fZ8aogDx/89WwU0AKvHEawLa7hoFuzAcSGIFN7WHfZupFu9tNzz+FYtrDdnKk8dhmyybz4+K1XzCDtkX6IUV83y4Jn0jPDlVhUH4bi0pwzTzao8fdSxzT3Jf5VditeUCK5PxRAxjVwCMdb6hF/jZG8nbmCjLO3KscZLVCOhZZtmQ9vCcBN9OPju5sTy8/n2TRzDH6Mt2X4FM0r6GKQaSjoQZ8hXnCSb+pSeFRFu4G3iisfUo5FWPu9TUroPUKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH8PR11MB6853.namprd11.prod.outlook.com (2603:10b6:510:22e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 16:34:07 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.017; Thu, 9 Mar 2023
 16:34:07 +0000
Message-ID: <e9996b21-c33c-d5af-32c1-abf6dc89b04b@intel.com>
Date:   Thu, 9 Mar 2023 17:33:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH RESEND net-next v4 0/4] net/mlx5e: Add GBP VxLAN HW
 offload support
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
CC:     Gavin Li <gavinl@nvidia.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <roopa@nvidia.com>, <eng.alaamohamedsoliman.am@gmail.com>,
        <bigeasy@linutronix.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gavi@nvidia.com>,
        <roid@nvidia.com>, <maord@nvidia.com>, <saeedm@nvidia.com>
References: <20230306030302.224414-1-gavinl@nvidia.com>
 <d086da44-5027-4b43-bd04-29e030e7eac7@intel.com>
 <1abaf06a-83fb-8865-4a6e-c6a806cce421@nvidia.com>
 <7612377e-1dd0-1350-feb3-3a737710c261@intel.com>
 <3ed82f97-3f92-8f61-d297-8162aaf823c6@nvidia.com>
 <531bac44-23ba-d4f3-f350-8146b6fb063a@intel.com>
 <ZAjsa538mpnEQ/QI@corigine.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <ZAjsa538mpnEQ/QI@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0096.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::19) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH8PR11MB6853:EE_
X-MS-Office365-Filtering-Correlation-Id: 83cccec7-bc26-45ad-481a-08db20bc1a80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qgIPURwuX81bYHnQLSeGwYQBFS5jILzY5fgLCnAKwJ1rpRbSpJoCgUAl4UKyg/PQSeDnJ7Xbm8RsYwMtcxTIynr2JoUUT/FaCPsnn0V6ZStiZJQwa40hX4JKrZKPPHmVr9O9Y5HxqNRZ8yhNHjSzOW+NEXsPBpMa2SOetPT3z8MePJc8JpA0YaSn3p+7xhjrmtJt34UbhNf0mCV6pzy33/+IfTTgBeA0VPohilfT/zEmSWQndPrSwJiZNFWWUQ7yBYiiPkC1YkWFv5u/+d3llUHS7hxPbX0kYydgmMAwGiGhykM0XxZIKb15iRWGVnWEU5ljrFRlcISmiUBx3hIBuAFkBFMAt9YVRoskl0Hn5pHWUVEu+xZIiF0qDgZ36u0DTvvO8TRwhJwrLQTySNBJrFnq57JG6Uwad/xZu9BBCLDgRsNjuBxYG/nsEMyalFMq4D1DJeoTiMy40TeinPpbahtynP7T/PcI0OtfO0BC1hVWcS2bLRKIcmZyTMxvX2C6QGVD9ZLO5EU3hulE1YuwZPHts9+BxFJeo4M6Bg/zD+qfP7HZ3aZL5HBMbD5DQZyEv1VY42jDvDpMkrVw2JK8VLX9qMKwe6K3p+ihZbyAlTR4/kFwDcolVwcKgCB4c424bSYIA6EmP1+2mwEKCY1CrIaCxQTtGNZHPcvB27rNBsU1qm61vkdKvXPJMiEv7iayzoUSiFi9BJJpJl0Tw8VCw99YQUGp7H7VD+O9mHPrfpk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(136003)(346002)(396003)(376002)(451199018)(478600001)(2616005)(5660300002)(7416002)(6486002)(36756003)(2906002)(6666004)(186003)(6512007)(26005)(6506007)(41300700001)(316002)(86362001)(31686004)(38100700002)(31696002)(8936002)(6916009)(66946007)(4326008)(8676002)(82960400001)(66556008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?alNOYXJBSmhiaWc4b1NZaWtOZ284dDZoQmYvSEFaR3VZbTh0S2RkSGZteGdp?=
 =?utf-8?B?cWNvL0ZZd2lNbE1iRnJzTStPTmJZM0RzNWk3dTR5RlBFR1ZGOVBOZ2EvNE1V?=
 =?utf-8?B?UWZqSGxsenJIbVdwRm9lRXp2bms2UlVUOW1TVDZ2T0NwTk5uYUhpMGhtUnhh?=
 =?utf-8?B?Y0xQMEl0VVhXVXJKU0JEeFlNcGFocmdaekR1K0pzbHVFSGpJWS9NTTBmTkNF?=
 =?utf-8?B?UmJrK0x0MEJFSUxSZmdVbWNtTG82Q0tGZkxRYnE1MnIyeUY5WGN6c3NLZ2hE?=
 =?utf-8?B?STYvQjEwekx5SWpwYTQwOGtqWmJsNjQ4UjZuV0svWEtqNDdZV2E4TWZXcUVq?=
 =?utf-8?B?VkV1UTk5a1czc1EwK2RDYklLbjFkNDNzYWh2blQyTXlmbTJvU09MRy9IM25Y?=
 =?utf-8?B?aS8wMy8rajA4cStJOVlSK09ZdHo0SFBlNWVWODlRU3lzdnRsdDdYNjF1dklm?=
 =?utf-8?B?ZHp3bVBHRG5KL0Y1d0dFa1NxTjE0dkdBNkEyMURDeTdES1VJbmNkWWlHa09X?=
 =?utf-8?B?LzNtem1jUjhacmQ1ZWRtLzZTVEdmc0Vkd0Z5UHlwcEdRTU5qUTB5cHFsbkZK?=
 =?utf-8?B?ZEVMNldDc1A1RWkrUHFkQnYwZENiTDNNR0xwbHhNR2ZkNTB1eFFFUVN3VmRU?=
 =?utf-8?B?ZU93VGZVbDJDbXFHQm5FWmFBQzFscWo2WVFFWUdFMkRrdXhpSytyTEU1WXln?=
 =?utf-8?B?MTE2Zy9ZVit2bkpsUmRwZG92L0dCVHFJUGYyL2llMlM1UmNvaURLN21yNXNT?=
 =?utf-8?B?MmJrZE5wTnRCbG5XT0N2SDZIaUNVQkh0NW1Hek4xanRKek84ZEpmaU5SV0VR?=
 =?utf-8?B?L2FOTVJyZzlLQTdRYzU0dXZqWTN2QXIrd09na1dMVm1sUyt5V2FLNmkvdk9v?=
 =?utf-8?B?czJ6cnlLSy9ycGZxRk1vTm0vWnVrT1g2NTJwaHh6c1VFZmtoOTcwblpJTlNJ?=
 =?utf-8?B?RVh6ZWp0ZGVVb1padHJhTTJVRzQ2emRMV2hvUWlKOXRKWUFJQjQzRVoybTBI?=
 =?utf-8?B?emVZYXJCREh0RzVRV2s2VUszUkdUYkdPUUNKNWZkbWoweVh1bkFFNGYyMEpY?=
 =?utf-8?B?c1JRWnZTTGRwSTF6cFQ5QTBWbEh4c2ovNGd0czhPWTVla0huWEtEejgwUXVh?=
 =?utf-8?B?anh2dHNHWVBTV2xOMXNTWmUrTVk0Uyt5MCtpZWlNUjdKSFlLTWdBMy9UTzV6?=
 =?utf-8?B?dE13YlBkZFpBcU9aUnlCeWJGWjAxMW1uM3l6ZG9uQUxUUDQzUHhLVUpMZ1BN?=
 =?utf-8?B?WkRHYW5aOHJ1dnpMcGZXU1pBZSt1VHZrWGZqNlRkR2VXc3ZqaFNEUi9OQmZG?=
 =?utf-8?B?bzZyL3JGTXFTUGFnaVJjRGNZak9kWGFBelZHTzh4ZmtHclNidWUvU29IRUVX?=
 =?utf-8?B?VHh2M3hqNy9iZGllbG9TWHI2YTBobnFsVVQxZDUvZWpwaFhYeGc5TzVpMzVj?=
 =?utf-8?B?d0JGMXNnWEMvZ0FZYzkraWlZaDg5ODR2ZktkNUxRTmRreTZwMkwwQWJ1bkU2?=
 =?utf-8?B?SDNWMWhBUXM3QXA4dUVWcHRRMlNBT1lVUUJVL3BJTTRNK0granZ2MVFsa3U3?=
 =?utf-8?B?YU9tR0pSb1ZmWkVFNlAzTW5lVlVpUndGWlY5V0RWNVN6bklsZHBuVW1wU1ZY?=
 =?utf-8?B?UTZUL2lTdVF1cHduaSt5SXBLKzZUczJTMnB0MTU0akY5a05zdmMwSVhGK0xt?=
 =?utf-8?B?T1NPcWRwUjcxd2JoejgwK1RzVUFTbnFXWUJOdmJLaU5WL3NmT0dETDFPKzda?=
 =?utf-8?B?YWUvZ0pSQzJUMStGejFJOFpEOUovQ2JVYmgwNHdGeWdrd2tFSDdwZjNTZ0FI?=
 =?utf-8?B?UWlzYmVUTFJuVW5xS0IrdWVRd09yTmNxbGlvQy8ydXlkSHBGN0ZYNGFiWHAr?=
 =?utf-8?B?eVRGeXpDcDc4RWlYK3V4UnB6YUxHMkRuQ3k5SmR5STBHOEc3SkVzbWg0aytF?=
 =?utf-8?B?VTNCMkZHMldLVVBWSFdHaDl3dWt5dFE5b0xFa1J2dWovSEkrdXY4Q2xFM0Yw?=
 =?utf-8?B?SU5ET082THlLTkdrUithaks3andxaGtIVWk0K0FsSXBpZElCU2VueG5hamVn?=
 =?utf-8?B?SnpQRjJjRitxMWdBWUo4TWNoejFRTXduM09XMXVQMUxCQ3NLaDkxeG5iRGhK?=
 =?utf-8?B?ZlJNSWt0SHlUTUVDUGFnb2RxWTlsSk1pSXFUdUFZOGc1emlkTWJmWkhsM3pE?=
 =?utf-8?Q?kgheo2Jc1DUMDzdEe57TsXw=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 83cccec7-bc26-45ad-481a-08db20bc1a80
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 16:34:07.6580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6FWjFGOV3DaLttRDCygETt1YgbADvYvTBODZXJshhMy1/oj4ntYgohuoD5gpu+RV3r0z3mkcn84BSfYg44ZotipTeU0M8KZYJeu/QPqreBw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6853
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

From: Simon.horman@corigine.com <simon.horman@corigine.com>
Date: Wed, 8 Mar 2023 21:13:31 +0100

> On Wed, Mar 08, 2023 at 02:34:28PM +0100, Alexander Lobakin wrote:
>> From: Gavin Li <gavinl@nvidia.com>
>> Date: Wed, 8 Mar 2023 10:22:36 +0800

[...]

>>> Any comments, Simon?
>>>
>>> If both or you are OK with option #1, I'll follow.
> 
> I'd like suggest moving on from the who said what aspect of this conversation.
> Clearly there has been some misunderstanding. Let's move on.
> 
> Regarding the more technical topic of constness.
> Unless I am mistaken function in question looks like this:
> 
> static inline void *ip_tunnel_info_opts(const struct ip_tunnel_info *info)
> {
>      return info + 1;
> }
> 
> My view is that if the input is const, the output should be const;
> conversely, if the output is non-const then the input should be non-const.
> 
> It does seem to me that container_of_const has this property.
> And from that perspective may be the basis of a good solution.
> 
> This is my opinion. I do understand that others may have different opinions.

Mine is basically the very same :)

Thanks,
Olek
