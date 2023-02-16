Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16D586993DD
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 13:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjBPMGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 07:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjBPMGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 07:06:13 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B3C459C7
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 04:06:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676549170; x=1708085170;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wSzPf+P4QSQg0ImwVbu+s38z2doKjnicXEiZtwegg9k=;
  b=l3tEWJTm1gtkxzMTKsm1Yp7RZYwDiQVl3MAoQ4iTGqL+YvBs/+HR+5vn
   SD7hR+mwvcHRRnxv3QDhwsYpYDcOFxKV71GdRTVowebUH70S8Yh7eQlNn
   cxTd+1GucUUSUqPX52bN5bDlV5fJF623jdUbwITKfe+zQSiqLjmzT8Mp9
   ZjHgIQ/W8BFKEPzkVgIxfcpYo0arO9RtLhglO4TJ3rWZusj8zPX8nSsQs
   CaGPsxAFdpNK9xiNmm2g7S22mrqeDNEzaBEt9POlff5pmM1QWBll+8rq0
   ZfbBgZe7yAV/jyEsxpRiYefZDMK5CnizBQ0DP/+JmkS/KsiupsDCVBybr
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="333869025"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="333869025"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 04:06:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="738802930"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="738802930"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 16 Feb 2023 04:06:06 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 04:06:05 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 04:06:05 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 04:06:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RVLoRaonjbh05vwg8lH+7OdWAx8YG2JUgXmVjBqZ0MhZvYaqNlEY2e8NZf/0hNiCtuutk/FQscJB4NwUFxt+BsBqvIYrEChi+KN+ztakAecig+K8gjP6uP7DYCZIHp88YAh/xDqVsk8aBUW4hdo0JJYCV3uk38oQQeRVJNDwevBd/vCrlpV1uaOYIBhTQUQeL0h+XGOeCz5Fk/QpoiXRLQ+0Y7fwGsho3N4s0JJbCIBq9cS0iQ+eMSzzBTlhw/7OEHdldziRW5KRZPa/+UNzVngLL051ki8CHFe7BkDMGEux+QNlrdbMXpco9BcMeadGdlogTylZ5lrNY+uIupgIDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oIdE1Dh4peFoE65IwcMjyyxMxhHOWbNEN4NuxuWuMfY=;
 b=VS50d2PnzFx0uCyhSM3UlzugPxqM7FOhZPmej/bb5ZfAhsxj9Qm8iYoDxQRD1ykAlNVNDQ1rUrDwliEBotpZ4dfCq03ij6aoRmsLRrKYJyUfiRNg9/zq065qxHgNCxRDumINRzNDYFRYxKvguf3AUTUTp/jXUpw/HVyIE7sSbMSXCIhvEg3hPsentkZsmmmpPix28imcqnh+yu56267I0s0+UFGiYUE3zmDTd9pFCpFZMj336S73oZoYqVltvh59dlovoIJ+5/y174Pvp5JHTjdnXZdWkiAa6CS2HpeR9KluNJfmgYu8J3Ss8DNEwxXKF4iAaMvHrbjQorr4WEPuXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH7PR11MB6908.namprd11.prod.outlook.com (2603:10b6:510:204::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 12:06:04 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 12:06:04 +0000
Message-ID: <1de97f3a-ae56-8cdf-4677-ceb36bdc336d@intel.com>
Date:   Thu, 16 Feb 2023 13:04:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 2/3] net: skbuff: cache one skb_ext for use by
 GRO
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Edward Cree <ecree.xilinx@gmail.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <willemb@google.com>, <fw@strlen.de>
References: <20230215034355.481925-1-kuba@kernel.org>
 <20230215034355.481925-3-kuba@kernel.org>
 <21e4b97a-430f-832d-cf49-5f938d1a8b77@gmail.com>
 <f2a30934-a0fe-ae1e-0897-2bb7dc572270@intel.com>
 <20230215095200.0d2e3b7e@kernel.org>
 <4aa71029-8a4a-0c6d-438d-71cebb11ccea@intel.com>
 <20230215102015.70d81a20@kernel.org>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230215102015.70d81a20@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0036.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::18) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH7PR11MB6908:EE_
X-MS-Office365-Filtering-Correlation-Id: 50ed7a4e-7731-43de-32e3-08db10162d08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Gy/XzK8t0G+wzrPMPdcojK14uJxd+VV6T3kO/idNPVcx2ImP7YcPe39yvjyLIBdz0V8bsaaW1C5JABEXuWautCX3p1HVHKkoq0SDOub6b7oIa2NvmE4CnwjfM1LhNGHIg1/9soOa4M7Jt7ku4HB0U6gGw4pREwUSSAw3Kk85FqnHz7Mwjpt3fFklo3nFCD0qyddrUOplFU0tPMJm6KcjFOVdBYAOd4Z1RyRihOMGyBg2W3plIZA0QJvQmVLrpL+Ogerq44iZ7LEKFm+ukCJ2toTJ2uhqHJw6D5FznwcWUReQ0Yv6B2opQBCFqpuMOitbKEOfkyPLc0qOuAQIh5l7oQRVsX+mSpDNa3WP7hL2m3iJfMkD8/YLZSVmKLPkTcZUR+9aFj/d25dP9orgQjog165uKckRVHMyqHsiWqPHC0FQnAcjLkRepKXYwUqbS2D/KbpltrCA3r586vKlRsvi/X8Z02KHIzTY68GkP+wKzv3eLb5Uo0QoLcH7oEBf9ZIUqo2eUJsw7tLsIKc5QQT4l/y3Wlc3Fp0Gov2/q8uWEJsFu9BMsFRxO4uHK/lwejG0xQICHH4dQ0P6FjPRA0ZBJ2RZT/xyCv4FxdlczdFYSVGSTPt1+qB+5Bf50LlMyJJklPjKk2riBH6sHgczYvurkRmCkPn8afp/rK4o2Fi+2GiQhw7LgIV8dj4aG5QzYez8vkQMALJDmTljefxeJ7bHms5muq18NIEtMJx2LDPErE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(39860400002)(376002)(366004)(136003)(451199018)(31686004)(2906002)(83380400001)(316002)(2616005)(86362001)(41300700001)(6512007)(26005)(5660300002)(186003)(31696002)(6506007)(8936002)(36756003)(82960400001)(38100700002)(6666004)(4326008)(6916009)(66946007)(478600001)(6486002)(66476007)(8676002)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dmdWSGRzbFZYM2U2Ry9YS1g0aStuNWlNbU1LWDdFeGVDVnN3T3g3b1NwT2No?=
 =?utf-8?B?bi9ybWZSa3l4WnRWR1ArVmh5Y1NqZFVuK3NabTFyKzFTMjN6RkJTQVBxSVlx?=
 =?utf-8?B?NmZ2WHQ3Zk5URzZxbDVFRHRDOUJxQStxSXhodkx1SHozREVCbWQwaU1YeHh1?=
 =?utf-8?B?QVBxc3loNHNlYXE4RlQvUnp2Rlc5cEdqZVZYenMrb1piUnBnZG54K1F4Nytq?=
 =?utf-8?B?b2ZhT280OVBlV0ppWFdnbjhzQTA4UHdTOFJtdWtUUnpUSWd3dVAray9BZjMw?=
 =?utf-8?B?TjgralRKODFSRUhuelJwNGNiOTNZOTZGd0pqMkZTdWM1dDdNUEhrWjlic3ox?=
 =?utf-8?B?VnBMZ3M3ZlZzWVZ2enpTZU5Oc3NwYlh1RFhOVllqbVZ1aEFCTmRCQW1panhP?=
 =?utf-8?B?aHhCSGRGdWhZQ3ppRHZLYW4wbTNvMWhRbkM0ODZoWnh5eHVaWWRRQVFVMG1v?=
 =?utf-8?B?OFcyZnptU1ZYejhmcm5ZTHVOcUhvWUNCeFlEYmZQNXRmTUl6eVA3ek56VHVY?=
 =?utf-8?B?ZGVVUTZMc09aVytLTEpqMVVGS1JqL0hhdG0yVkQ1OVNDRmNkcHFsbFU5UEhK?=
 =?utf-8?B?TmF3SEcrRldwbzVKdElkSzJMeENvdk5ZZkw2dEtRa2t1Z25YcjlmMENOYVRJ?=
 =?utf-8?B?YVNWcENzeGlEVFo5dHo4eG5JWmVKVWlsSFRMZmg4SytOSEpXU3R6MEF6YjBD?=
 =?utf-8?B?akovbUNTTFZsejQ4ZHJNSG9IM0l3YTlzMnV4clo3aURyQkhTaG9SbnV6N1FK?=
 =?utf-8?B?NTJoMDhUM3hSYlljZFdMaWluWVhKU3hBYUR2Y2pMVVBVbU11a2NjUkNwRm13?=
 =?utf-8?B?cHZEZWlrampOeUd2d2xxWWNRNkJBQnBkT0dLUnFpUThLSTRwcGNrekV3aUc0?=
 =?utf-8?B?RGJRUnp4TkNnR09oaTZnR2kzK3MyRWQvTVU4S1l1cktITTcyaHlRSzNQcmJM?=
 =?utf-8?B?TlN0U0Y4SS9taWVieUlDQllLQVlvV2VmNWRhQ3BJbFNNa3ZhcnhVUWdOV1M3?=
 =?utf-8?B?SFJnWlM1NHQ1SUl2cTFLQURWTFpsbG1ielp0NjZKelIxa1ZGWWJaSHRmY0xv?=
 =?utf-8?B?dk1jMERLR2xPb1RSWHZmRExMbVZmbGNPbytYaVlPMk1yalRaaEprdVpMeCtj?=
 =?utf-8?B?UUZQVFB5cG1DeTRGQkYyT1lJVkxRVS9RT2NESGV4N0pFTmc2TWdNQklPVko0?=
 =?utf-8?B?TFUrRzNMZlBMbDJVS3JSNVFZMXhoT0dhVEcyNnpEN0NBL0R1aEpFZGlyZWR1?=
 =?utf-8?B?cEt0OHR0OHpLVC9Xb3lXaUhwcjFvUGZlN0lTN0NBc3ZTaXdqSnU5TWZIdlRJ?=
 =?utf-8?B?MEc2S0JvbEgvYUFSWlRYa3ZTbjdyUWxWOHRwdzJCYi9BczZFZXpBRGdFRlh1?=
 =?utf-8?B?QVVkclhSUE53UHJBRmYzc3oyWjVPSHhGb2R6WkRrMVdibU9nT3BiWWZjbEhU?=
 =?utf-8?B?WkZRRXc3UFRZNmFOTW5KV09PbmRiOXhIbStSaHROZkRobmtvaUE3K21XMVpQ?=
 =?utf-8?B?MEU4Y0Z4V0ZETjhlMnJtVExLMlU3ZlNqZjduNE00eUtpOURwVmVzVUZXWkx4?=
 =?utf-8?B?U3VHSC9pRmNmQTdUUGZXekFIaDBWdXJmTkVwU1NFKzhiZTVSRnhuYUwwc3Qv?=
 =?utf-8?B?dGxETk5pNlNweFlCQm9UNnpYekJjbkNNUzMwNnVwMnVrME5RTnE1UlRNVzh1?=
 =?utf-8?B?STFoZzlvMnlOYlVRTE1FMUFSTUE5bkpRTXd4T0YyRzVvL1NGNDcwQU15SWJJ?=
 =?utf-8?B?R1QvanpyU3oyUnVtSVNZQm1PRm1qbTB2NGlLeFV2aEFJVkQyTFlpTWJkRnFW?=
 =?utf-8?B?T0dpTTA2ZThBSGl1SHJyay9WVjB4ZDFCd0J4QkI0SXJFcmdWS0NOSkcvR254?=
 =?utf-8?B?U095WmxDcUszRHlIYXlTR1h3UlhFSGNyVTJtbnIva05PTXlIbmxEN0Vsd2lI?=
 =?utf-8?B?WTkyVFJ6c2RFbG8xMzhleGlUZlpkVGN5SFZZMWx4VzBJamlMVU1lMndrSnJ0?=
 =?utf-8?B?NnQwWEdpb3RWWGdEQVVSYi9mMnBzNzhOcVZMckV1Q1JUV084UjRHcElCSDN0?=
 =?utf-8?B?TjFxTjBqM05Fdlo5R0Y3WmFFeTY0QTFQcXBCMWdzc2Z0dWV4Q3pFMUZxK3d4?=
 =?utf-8?B?cDljQXpjZHZISGRCQi9aWTRES1djZHYzakxRVCtRNXBWaW9tam5YdzArMlpi?=
 =?utf-8?Q?Kt/2bT81FwPMy7wJVbbYAwU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 50ed7a4e-7731-43de-32e3-08db10162d08
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 12:06:03.6237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /a4JHSJMcSlEjx58BsDjAsGZ3mKGeMB6BQGuvdV3G1ysxYBudBpshSBMo8oeZv0xcjnxjgOGYJqoFK4aHHdd7B5PHcu4QsdKCwB4mxTyDho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6908
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 15 Feb 2023 10:20:15 -0800

> On Wed, 15 Feb 2023 19:01:19 +0100 Alexander Lobakin wrote:
>>> I was hoping to leave sizing of the cache until we have some data from
>>> a production network (or at least representative packet traces).
>>>
>>> NAPI_SKB_CACHE_SIZE kinda assumes we're not doing much GRO, right?  
>>
>> It assumes we GRO a lot :D
>>
>> Imagine that you have 64 frames during one poll and the GRO layer
>> decides to coalesce them by batches of 16. Then only 4 skbs will be
>> used, the rest will go as frags (with "stolen heads") -> 60 of 64 skbs
>> will return to that skb cache and will then be reused by napi_build_skb().
> 
> Let's say 5 - for 4 resulting skbs GRO will need the 4 resulting and
> one extra to shuttle between the driver and GRO (worst case).
> With a cache of 1 I'm guaranteed to save 59 alloc calls, 92%, right?
> 
> That's why I'm saying - the larger cache would help workloads which
> don't GRO as much. Am I missing the point or how GRO works?

Maybe I'm missing something now :D

The driver receives 5 frames, so it allocates 5 skbs. GRO coalesces them
into one big, so the first one remains as an skb, the following 4 get
their data added as frags and then are moved to the NAPI cache
(%NAPI_GRO_FREE_STOLEN_HEAD).
After GRO decides it's enough for this skb, it gets moved to the pending
list to be flushed soon. @gro_normal_batch is usually 8, so it means
there can be up to 8....
Oh wait, Eric changed this to count segments, not skbs :D
...there can be up to 2* such skbs waiting for a flush (the first one
sets the counter to 5, the second adds 5 more => flush happens). So you
anyway would need at least 2* skb extensions cached, otherwise there
will be new allocations.
This is not counting fraglists, when GRO decides to fraglist an skb, it
requires at least 1 skb more. UDP fraglisted GRO (I know almost nobody
uses it, still it does exist) doesn't use frags at all and requires 1
skb per each segment.
You're right that the cache size of %NAPI_POLL_WEIGHT is needed only for
corner cases like big @gro_normal_batch, fraglists, UDP fraglisted GRO
and so on, still think we shouldn't ignore them :) Also this cache can
then be reused later to bulk-free extensions on Tx completion, just like
it's done for skbs.

* or less/more if customized by user, for example I set 16 on MIPS,
x86_64 works better with 8.

Thanks,
Olek
