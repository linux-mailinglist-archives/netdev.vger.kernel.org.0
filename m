Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0537A6982E4
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjBOSEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:04:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjBOSEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:04:31 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B2A25BB3
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676484270; x=1708020270;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qpVAkmqFZlON98IqgJtpm+rRW+WEDVIfRGW2nhIwEKE=;
  b=anYLu1RkN/VArbeX0rRThsR2PW07Sq9LzkMtUQpH42VD2KKu7K55AeMi
   ZRNFmQ3UMqno7bil+HeJ8yyQsGdGv2fE5uyRYN6cpJaD/mQzF0K5GJUzr
   uncuIMAPdfEaqwED7nO9WfMG+T2bwKaE06JX8a8gWqUkcfE5PJhfOtWwK
   h4kOVABK8pe0IO24V3WfvIAQK1em8UeRuDJ7Tvw0J8z6Xi8Y9/YAScZyc
   JmUSrL8ihUIs7ZQ854WOZ90IuIu2mG8zNEBVaTNomHkHe0vBFDdeJAtoE
   3AiKnpCrlo+yGE0Nb21eoyxuk7EufRcd2/W/LecPxTqYl/2X1/138Ak2k
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="358922655"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="358922655"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 10:02:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="647299461"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="647299461"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 15 Feb 2023 10:02:42 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 10:02:42 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 10:02:41 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 10:02:41 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 10:02:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nCj6YZBnKYv40Ui3YwAAC32LovZICO4XADoomEyYkopcNJXgOSW7JNDx9k7Y1DbXUiwInoe8fasKdXuGnQ+fE0K4IPoW/pmFq6OntaA84EC9/rGq4Vf2ulb+6exFhseY54KUb781vRYcJjpTOyj2rkbGfjS/dijkMeCgYFWLT71R+37H1A6R8u4Zbp4hwvbn6wiwRU3M42KWfQRILQnCrWL/Zo9M3VoPIIiTpBC7jlCViReBInu2qMs5qxDUeQvOTid/5yUKf4a1kZwrZPdF/mNMHCCoomfn2XBcfhf5GWnE8AaonApcd0e3GqCfIXOjJ6vJS5af3h8+puIenoZ7mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SoZhp/sWA/bKddSU4HY6Z2GqChw3X154cs6eMFdSxwk=;
 b=KWg3B743HCmH2Mf86vAP+4MoNRcG7JlBV7yYh1iJr0zIC5//or42OxjTQQ0qWnTq5EmVj79HxtzZ2QQfTv+WEUuYMa7Yqxr+oSiUIM/c9gRbyueupu7izC7exZw46rMYq3LeJmcH3VtSoENr9rv8L/YV8Don1gGVLOOvnCTga/XIIwdDU878Orxc1RcWWRI9PYeDeYRQseOPQ8Rhuo+GGi5HptJU9T5g51TWS3GqOuc3WZV8DaiBJ7hZ0cisxq37w9zZCnPnJYMqGUNv1RsFicEA/LtwSS8Lr87HxIag5/LFLTLKRE6kkiBtNu1345qeb7WrTBwf5Tybndbrg/jkeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SJ1PR11MB6106.namprd11.prod.outlook.com (2603:10b6:a03:48b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Wed, 15 Feb
 2023 18:02:40 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 18:02:40 +0000
Message-ID: <4aa71029-8a4a-0c6d-438d-71cebb11ccea@intel.com>
Date:   Wed, 15 Feb 2023 19:01:19 +0100
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
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230215095200.0d2e3b7e@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0202.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a5::6) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SJ1PR11MB6106:EE_
X-MS-Office365-Filtering-Correlation-Id: ff97a67c-0211-480d-5293-08db0f7ed3e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HjrpAFTin9iEyO8RqW39q5N7ZRgHtMOqSyi6uf+pAe39t+KbGggsVRy8LfR42r1umWREY1QFbFeGe4DElk8ueRoxq0m7b/3ETHOfWTjkobbBcRSRGSCcnLFWzvts0RX/C1BQjPbe0UJXKxcayZp7naaOgHmw4Od/AILxDruuCT1sQbUCSNtfV8QL8kxtTxMz2+HPme+nSSznyIlL6gJppTeTDjYYIl+LBwOEMB2sTcgqLyAxf6wrxNkcbs9BspP1+D2dhe+bpJvqSqosKnkfrLvUXDYJI9+K5c47UgtAKny+4hoZwd09ug59gx8acZsCwMsuVFjLK4azl80cQxktTrEOZTVvmGuG0EElpXVOoenBog6XGS1HGhxMzKhdvXZ0tzWSnYjRDFJ4plmRxQrOggJwo6RYR/LuotjADGzTjz7DpVFtuzfnHGKa2fjxA8ajjBckMlTDWb9fbbETvZb3pUUQOoEVdAqKMz/UWFmOu9XgPAXaOx4Nu7bS8G/SvBBtNxHbFvxCxU6XcOWYoH1NXYHGNIy1P1hgjN9zdLB/BSLaHZS4MFn/Q2MCwIvt4MCthGGY0m6CJcSdN4ZqX+g3Su3GIbwXHPH+S4JfL8+Z0zKPRp/7u0zk1ZOUmoFA5rojBxF0xgCB6YSZEglUtyvQVJZBlJXxUrUGF5lrqBHqTbFMDza36sppR4btGZJhPS1h4HJz8NQd5wE2XlOD8A7ojjmlE2tXxGcFJ2fuZmkqKRs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(346002)(366004)(376002)(396003)(451199018)(4326008)(8676002)(41300700001)(6916009)(5660300002)(8936002)(2906002)(82960400001)(186003)(26005)(316002)(6512007)(66476007)(66556008)(66946007)(38100700002)(31686004)(2616005)(83380400001)(31696002)(53546011)(6506007)(86362001)(6486002)(36756003)(6666004)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U29sK25LYXNFMzVLaVBjVXF1UEVOa3dCaXQwNUJpd2NFRXQzOU9mTHdmTmhW?=
 =?utf-8?B?WXJoZmtWQmY3aUl4cGJidzVuZjJPUENlZU43Z3I4b01xMzczaEdTeHlSWTU0?=
 =?utf-8?B?eDN3bnMxQTAwYWN5dll2Smp6dVM3RmZ2Z0N3dGFYelZlOUpER1VnZmJQRkxX?=
 =?utf-8?B?ZXZQeVNRMnM2a2I0UGw5ZlV6elU3MzlQQTNJMVBLSmZBOGtFKzIyaU9Tcmtx?=
 =?utf-8?B?dE1OOXBYdmJwekJVUTB3VnVHUVBTcHFXQk92Qno5R2pmaktwY3RTLzRZTnhI?=
 =?utf-8?B?bjhXT0xqWU1uN3FCZ0p4QU1JN2s5MkpXNXNYMVh6NlJvRjFXeHdKVVNVQ3hU?=
 =?utf-8?B?MjYzb3JDL3pUTEJwQ0VKcURKNkVrdGUrMDJHU0hyTUEveEdvV2xlUkZzOTlt?=
 =?utf-8?B?QUdtSTFpVmRTTk9udXhocHJlOXdhdkwxK0xUUXdGb3d2Y1hxM2pMWEc3cWpU?=
 =?utf-8?B?UVphbWxzWW05SFRsUVIzeFBycU9ld044U0RNY1p6VXZSTENWWmpCeFF1OE9M?=
 =?utf-8?B?bnpVM0kyRnRYZFJvV3llc2RHcFpuajhoVVA2bHUvWHhCZEZRYlZoblExQnJ3?=
 =?utf-8?B?Y3lrbUthUENPZjd4cXFCaGlHZnh1ZklzWXdicTNZSTlscFRxcWp0b0xoYUtP?=
 =?utf-8?B?MW1CVFZBQWsvUEw0aHdSWm1TeUNyVEtsOHEvNGtHWEV6WUZiRmxNOWZwNDJU?=
 =?utf-8?B?d0I3WjNXZGdBM0plenZpOHdNdXlndTI5R0FXTjkvR3F0dUZNUU52TnVBTzR5?=
 =?utf-8?B?bUlCMUo3NnpPVkMwT0VhMmJSYkd5RUY2QXJqRkg3UjFEMnJKTVhoYkhOK3pa?=
 =?utf-8?B?bVlkTDI2V1NSeUVyU1hRcEVjNi9PUkF3eXRHUUZybWJxT2FVOGpWRnc2ajhz?=
 =?utf-8?B?dWZZZW1oZWN5Y2pWZEFxTG10MG1XQ2VoL05aMmVUUlA0YUtwdWxHWTExZkJO?=
 =?utf-8?B?QUw0b0RYWkluR1YxQThvb1drcHB0UzVBQ1hvVUlaSmtHQmtldnN4R0Q1cWVU?=
 =?utf-8?B?eG9Jc2Y4Uk5PU1VRSUlwWmx1bDlHYklVQXIxNFFHUml3NEhtdjNKenBYODhW?=
 =?utf-8?B?YUNDbTZZNmFVdVp2bjZJWkU3TWFFZVp2Y1ZzS2N3cE5kUEd5bFBTNjZUSnNl?=
 =?utf-8?B?aXJoaVArR0lUdjZHSW84cHJhV05jWVp0VjBPUlkzZlYrZFJ3THhuL015Z2x0?=
 =?utf-8?B?a1l6M3FiRllKa0lLZHNQU2JkRTMyTmd4NHVsNWNwRzVjQWRWY1p1MTMyU01P?=
 =?utf-8?B?dHNEQTNIRnV4cjVmMGFPdWtBbGlxUVFqT3RMZFJIemI4anFpbzNZRVdDbnBX?=
 =?utf-8?B?VEVQYy9BSXQyUGpnRlh3bHMwbUdsK00wUWh4cUt0NWR2eE9KL0tZVUExeHo1?=
 =?utf-8?B?bjVhajlGSXgzSU9DdmR1eGlKMnRHZWJYMythSXVMQ1E0UTFUNlVZdE1xWEpC?=
 =?utf-8?B?dmRMQ0UvaHhVbTNmbVFZUzFHa3hOUFNTR3MwZE9leUhZdXBCekJXZ3hCQjVL?=
 =?utf-8?B?SERrZUlaeWRzT3lyems2SjBkQXdKV1NLclBrTXI0L2lldlVsTDJYdXFpSHgx?=
 =?utf-8?B?bVVSeFNTV3kwRHhqNG9mNG1vR0UzNHhqUEhhQUVpMUVhTjVNaU45WWgzd0xX?=
 =?utf-8?B?ZUw2ZkJWVVh4dllXT2oxZDF6TkJnYlg3MjRLL0YvRzI4RFdCK2ZqVWZkNlA2?=
 =?utf-8?B?VUN1b1lhaHZqeDloYzY4T0VvVno0M3Ewd3RyRGt3Q0luMG5ESlVnNDhPYlBr?=
 =?utf-8?B?UjNkTEwreExVc1BkWmtCNWZ1bElybENFSnQwaTBNNnpRZWE3amcwc0Jabm1W?=
 =?utf-8?B?eWFpbm15MTBWWGZhSmJEVktpVEdycnJHcTFOcFRaSkNmb1V6UkRPakpVNWpi?=
 =?utf-8?B?bVc5UzlSMTR2WkYvNnJkNUNFcFphSEVYWm5rV0k2Tzgxd1ZTM0ZBRTFWZzg4?=
 =?utf-8?B?ekFNS24rNEc2SFFxY3MrRXVLUzVpN0xRWlFtZVMzQ3lySktSTnZZQzBqUi93?=
 =?utf-8?B?bFNEQTdrbU9YL2w0U1ZTVStLQ3VmWEU5WHFISVd4dE5JQ2FRTmYrTHlZZzZk?=
 =?utf-8?B?b3d3ZjJ4dWNEeU9PM0JMcm1adm4vR0pQbzBSS3B1L1NNYkVZOU9TaG4yak9O?=
 =?utf-8?B?RmVkWDVxNmxKVEVyRzczTktUbnlwOU9zR213VG5GZitJTkVnUVVCYUJFeTdi?=
 =?utf-8?Q?ObkSKvZxUopRN7KWuqYaTHM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ff97a67c-0211-480d-5293-08db0f7ed3e9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 18:02:40.1292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dxi7nTN0GeBuiIro3GCnlTnA/kUU3z1MTU8de+h3Sjaw96eU1MpaezFqrBpEnxGcogUWfP8rdeoIyRbRtPLsNfEhrbyEREPvH5QScKpQvuU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6106
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Wed, 15 Feb 2023 09:52:00 -0800

> On Wed, 15 Feb 2023 17:17:53 +0100 Alexander Lobakin wrote:
>>> On 15/02/2023 03:43, Jakub Kicinski wrote:  
>>>> On the driver -> GRO path we can avoid thrashing the kmemcache
>>>> by holding onto one skb_ext.  
>>>
>>> Hmm, will one be enough if we're doing GRO_NORMAL batching?
>>> As for e.g. UDP traffic up to 8 skbs (by default) can have
>>>  overlapping lifetimes.
>>>   
>> I thought of an array of %NAPI_SKB_CACHE_SIZE to be honest. From what
>> I've ever tested, no cache (for any netstack-related object) is enough
>> if it can't serve one full NAPI poll :D
> 
> I was hoping to leave sizing of the cache until we have some data from
> a production network (or at least representative packet traces).
> 
> NAPI_SKB_CACHE_SIZE kinda assumes we're not doing much GRO, right?

It assumes we GRO a lot :D

Imagine that you have 64 frames during one poll and the GRO layer
decides to coalesce them by batches of 16. Then only 4 skbs will be
used, the rest will go as frags (with "stolen heads") -> 60 of 64 skbs
will return to that skb cache and will then be reused by napi_build_skb().

> And the current patch feeds the cache exclusively from GRO...
> 
>> + agree with Paolo re napi_reuse_skb(), it's used only in the NAPI
>> context and recycles a lot o'stuff already, we can speed it up safely here.
> 
> LMK what's your opinion on touching the other potential spots, too.
> (in Paolo's subthread).
<went to take a look already>

Thanks,
Olek
