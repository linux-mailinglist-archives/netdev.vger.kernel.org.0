Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA2F69816D
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 17:57:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjBOQ5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 11:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjBOQ5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 11:57:52 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A40F6182;
        Wed, 15 Feb 2023 08:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676480270; x=1708016270;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yr1asUZzrUFS7lz+GBwLoWZqnhFhBPHltPeo2/iTTKg=;
  b=DIGtJeJidB7roBjF1M4VzOT3cDK30IHmC899VATaDTh9rKEdj5BTMJJw
   Q8XlZadE6YO10Mnbiv7vucKIebsUfULlMCsAySfsWui3Y7cnAm42/JVpW
   HvUhkNNoX1LPtS3BjcxNpNoYC9Jy/UVKVF38vg7IqlRaBL/4xjZRrwuMY
   nkXFzW1lDEtvWV22u2W3a482abalSOaJi17VPUMLKKp8LWXj0oVwyZK5G
   2JM/sXX5U+lrEKSppAajaNMERRZGFIGgRogUPmIgzQ44zd43RLBe5i1dw
   VrMYQ5CPv9PyAgvzx2SS37gN0P31C6A2tdjBI0/B/I72MmkCi9dn34BR1
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="331477391"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="331477391"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 08:57:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="671719261"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="671719261"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga007.fm.intel.com with ESMTP; 15 Feb 2023 08:57:30 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 08:57:30 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 08:57:30 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 08:57:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nFHHrYE9Id558Pken3je5jMtSS1Gq2TMl2ClwKey4+1IHJtxV0/mVAuA081m6dsuV7SEEGM60tafvDopoux33rguDS5Gn1ZZ2MmIjQof1kx+Tq7ezqMxN1f1QFbHmru8aoQ5lMXWmol9bDDEpWXgmhf/1FfpiBD9OTJyc5gST77ZQxXJNAOZ7YUxAc+bgNWBX6YHGqwkqLYMHyXipohwkMsfqLIwrxJmrYxn6Aerfr1hFoFzw1rnvJb6S6T36tI37mhzMUsrmh1V1AfmAjWOPgeI7ry6KJJ1ulUXzGE3gHIWfZn9uXxTtPy9O8SSgZDFzwtoJVr6npU+h5eKYE5siw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=thmi5sJcpYovdQN9lBhbD7FAJWJosnojE+4sxy11qOQ=;
 b=PA2Ul2MszyJEMzM17wmTwUgLI0kGVhlQ5YT5TqA/l3+nhSoix8sris8M9YcqVYoa0CmY1GWXGEnXPzoC3AtZW1s0RZsoprz9GsLQXIuygkgxoTPrwojjPQqvFeCII2TijI2+Rz7YQFJIjsgbyAxpgvWDE8+69LxXAZSAD94FHMarqa2Y8l3NnXAKdOieDTbUqaOuD2Cc8USastZAaNVCcjzo+HueGPHviIrsYIFfmC8FQHWWtMo9YLPbZ7gLFGfySemO8tfu+PCdc5ynK27p4HYezFn2pGQ2ZW7BRc/4fNR7vHruQgZqf/Zre84L2KpjZeul0q6NUPYa7wZmeT3Vhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DS0PR11MB7213.namprd11.prod.outlook.com (2603:10b6:8:132::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Wed, 15 Feb
 2023 16:57:29 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 16:57:29 +0000
Message-ID: <85172e19-5344-bc30-e6a4-aa39dba3b50b@intel.com>
Date:   Wed, 15 Feb 2023 17:56:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v1 2/3] net/mlx5e: Add helper for
 encap_info_equal for tunnels with options
Content-Language: en-US
To:     Gavin Li <gavinl@nvidia.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20230214134137.225999-1-gavinl@nvidia.com>
 <20230214134137.225999-3-gavinl@nvidia.com>
 <611a9a70-0f6e-cba5-dcb3-3412e6e9956f@intel.com>
 <40a616a5-f350-2ac1-eda1-7e4c777ed487@nvidia.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <40a616a5-f350-2ac1-eda1-7e4c777ed487@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DB6PR1001CA0005.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:4:b7::15) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DS0PR11MB7213:EE_
X-MS-Office365-Filtering-Correlation-Id: bdfed791-db1b-4bd7-d3ca-08db0f75b8ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vhx3gX3AUIaS62yzoTmQ578yqli8Fi+AIgeIAZJthmFOV8J2Im13i+1aHCGKUP6uw8Bh+kXi1J2cnnii1ojf7xeVatrcwk8yySitAYoyNSMbEdCjY7PiJMlzhGPBGwqqzbW4ZVB2wxUgB7NlhzssS4MeS1ciuIFFtsQYOvU4M+S04NNusmZYhvGQxUyjs2xhAB+yx/pEYB5mlH3/c+4HpK6zs87PoYqpxq9fYHH7Sohgip9R3o8pk/ud+gO5lsGk3exW8f7+7gcVCO931bRkXNZUfJJ6TVw+lj7P7lgogeRwr5w1XwMs157hrzqQ98VwRHVPDacxqydzYaKkd+PRgvaFOck8blE3SX+bv13GKrAWedISsUmjGRlIgNhnJuxrLNoq62rBf9XOL0nQV6EK/kVW1VVqPRA2Mm+9yevRRN5ako86jDpUJws+AwzCLMEHcvgxn/retasWUOykqMRfBdtIWbRhg/AM9LBoalJDmYOrocPfaP4+j5Fc7CvRYxf7371RzYlQT4FiEia0kXxKWtQHpP+FX2RRTmw/Qhr0/lIWVMyjnteFfYy+IS3aUKO4ur33diboC63dKUT5oB+gRxXNGjX8yeyPFca4lTOqQRioCQy3AyM3fegsYCoDPFlNgXjmegCn2/UoHxucgXsJqr3Y4FoMKBljRv/ka57xr5vccS35qA3Il/hQIurnXyS0c4u0WFm7sJi9MSN2i0G2rgvYJ5kgQsy8jyTM3VDtR+c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(39860400002)(346002)(136003)(396003)(451199018)(82960400001)(38100700002)(86362001)(31696002)(36756003)(6916009)(4326008)(66476007)(66946007)(66556008)(8676002)(41300700001)(54906003)(316002)(5660300002)(7416002)(8936002)(2906002)(2616005)(478600001)(6486002)(53546011)(26005)(186003)(6512007)(6506007)(6666004)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RHR0SStsZ3RQQ29mWnIzbW5qS1V4V0ZaQUdLdVdwNkR1ZHNKZGFkOCtHZWdo?=
 =?utf-8?B?RWJBUHRFcjMxd1BBaUxnblVMZGNEcGZPU3ljbm9pNHlDS3dXM2ozVnh6cHNN?=
 =?utf-8?B?WnFDajlCU3JHQUgwdUVpQUlzRGlmcnc5V1RTNmt5SEJiUVkwUHh3MmVLd2ht?=
 =?utf-8?B?RUM3M0t5YXFpZndQb2lEL3BnTlNsNVgzOVplR2wvam94QnZpdXJob0hveUFH?=
 =?utf-8?B?Sy9vbTNwTHZaRVNmS1V0VTI3Tk5kMkVQQlpkZWY0ZDBYK3JyQWVFMkIyMDNH?=
 =?utf-8?B?ZUVQTXRIM0N5azcrSStOcE50VjNnMFY4OW5IZ0E4bjNqbHpKRDZ5Ty9iVFRQ?=
 =?utf-8?B?R0pocmNHcTRMSUFkOEZCbGhqc0J4THlXeVRCZkZLa01XMTZUWmpmZTdaZEhD?=
 =?utf-8?B?TWlHRjUyRmhwUk5aYyt0MW53SDl0UjEvR2ZVcm52N1IwdWs3YkxGd3M3MWo2?=
 =?utf-8?B?VEhjQUF3a0toOVVIbW1FWCtXNHNjUXFweXdHeGJkaStKYlMveUpYVmJIUXBn?=
 =?utf-8?B?TnBjTjNBa3FyTy9vWm1RdEd0SnFVV0lmWHp6a2pFVHAzbWppNEtLTWFldmZV?=
 =?utf-8?B?QTIwL2xqeldTdFFITHBXK2V1Yzg3YkFxRzM5WU5oWkxDTDVnQ2pDV3QwWXUz?=
 =?utf-8?B?OEs2WjlMelJkQnpSMFlOVllRMldVbjNMckhGc0hHaDNnUzJDVitoSTh4ZHk4?=
 =?utf-8?B?MTBTV20xM0tZd2hLV1p1TjVuaVY0UTA5ay8zdUppdi92L012UHcydUF3eFBB?=
 =?utf-8?B?Qmlqem8vWnlXY2FuMVZKNndvY1NLV0s2WmV2RlQ5WmFTaExzNW1PQlRpVnRv?=
 =?utf-8?B?QzBvQms1dFdseGtuSzlKRHBZUm5KRllpSXBKdWVxUVBWb08zbVN4NkdEVnZT?=
 =?utf-8?B?M1hVOEVhMW0xYkwrU1FnSTdVVkJQb3ZFdFRZeWJYZThrQlpSZ0lHb1RkNE13?=
 =?utf-8?B?YXJwSWlrYXJmdDRVYzNTUWFlNUFyTC9ERHJMTFZJS00wRW5PL3dwZFRsbExQ?=
 =?utf-8?B?ZmcwRmx5WjVhamVCZWhoK1pncjlwZUdPNWxkUjNEQlA0U2hQTkJNK2NBenhP?=
 =?utf-8?B?Z0RhWlo1U2NKd2hZSFZicThMeVA4QkQrNXFYUk9Bd0dTMXJ3NXNnV1NZbjNi?=
 =?utf-8?B?dnlMMUVGV0NoekVhdE1uZ1l0OTYraStrSnhiTWdYUHR5VTIzais3OVlLb09s?=
 =?utf-8?B?QnVmcnBTdFU3OVVhUnp0SE0vYm5xTElFcC9kcEswT2ErSWhLbFZuQURjUmdx?=
 =?utf-8?B?NWc3OGQ1dU8zQyt2dWxCd2xwWkZuZE53bitsT0Q0RzFGYTgwREt0M1BZU1Mr?=
 =?utf-8?B?RjFoVmpkZGxGK2t5ZXk2RFZ1QW91dHM0bk1RaUhKWVd5NzJCaTBpWHJXanFO?=
 =?utf-8?B?Rk5JcDVlcDNZZTdhTFd5WVFtNXVWd2lNV2RRRzRRbDJvVkpCd2dneXd5YTFO?=
 =?utf-8?B?OEo3ZHZvV2g3R0VDU3ZJVXpSY05oQkZJQzhsYzVEUktaRklFR2tZcHMxQ2h4?=
 =?utf-8?B?c01IclJaYzVlbW9TUU1tSjczYytLNUlKMW5rNUhWNVhpbE10eXo2WU5ZYUht?=
 =?utf-8?B?dHVnN2Y4NFJwQkQyTXBqQ0kremRVSEJ2c2Rjb21YRXI1Z0xRYVFBTUJKNk12?=
 =?utf-8?B?bjlBQ0dDK0tzbVphOWJBeVJiWDlYVjNXQlBPYitJNnl2Y2JEVGdmU1UxQU9j?=
 =?utf-8?B?Y1p1QWMwcTVTRFNQZkxadGVOY0NudUowRWs2ZEt3Um5jYVBvQ0JxZnovM0dX?=
 =?utf-8?B?b2lJLytVdmluR0lPd041TllqcFd4MlUwNnpDcWVpcEwxVGhqQ0p6R3c4N0FV?=
 =?utf-8?B?TjlDQUErTFZFMlhUNElyWEZDdnk4aGNtZ29ZMHFoTUdUWlhYbzhlSnM2NVha?=
 =?utf-8?B?WlZvN0syQmdaN0hCOFZwVzd4TjgyalJnZEF5OE1qRkxhUjIvN04wbE5aalpB?=
 =?utf-8?B?M2phV2hUcWNxYkk2WUVLVjlHZkRnM21Gc3NxYXdDNFBvZVZjS0hsSjNOVlY5?=
 =?utf-8?B?cW5nM1JtMFFRbGtsbmZyMGdma1lKMVZ3TVZEMFhDVFB1b1g5QlNTMHZUZ1pi?=
 =?utf-8?B?OStjUGNBWXQwYnQ3RDBXN0thZVAyaXk5dUw2U3d1UUdkMDdPcDlPTEpycVR4?=
 =?utf-8?B?VXNJMXM3bVNlSFhZTG9TTEhVbFdyOS85UlJzQXNhUVNoaFVON05yeHkrSkFQ?=
 =?utf-8?Q?MEUEDlJh/37i/LI72P7AVJA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bdfed791-db1b-4bd7-d3ca-08db0f75b8ad
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 16:57:28.9546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DLRVQRvkC/ou/v56p9nWZ9Hd3If1h7graLmPMLhnePkLqi6r/RkDPny7PtZIBJ+7OtKWQbO/5tRR9oSXax9uIwSFi61f0zlXK7RbrnezHD4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7213
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

From: Gavin Li <gavinl@nvidia.com>
Date: Wed, 15 Feb 2023 10:54:12 +0800

> 
> On 2/14/2023 11:01 PM, Alexander Lobakin wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> From: Gavin Li <gavinl@nvidia.com>
>> Date: Tue, 14 Feb 2023 15:41:36 +0200

[...]

>>> +     if (a_has_opts != b_has_opts)
>>> +             return false;
>>> +
>>> +     /* options stored in memory next to ip_tunnel_info struct */
>>> +     a_info = container_of(a->ip_tun_key, struct ip_tunnel_info, key);
>>> +     b_info = container_of(b->ip_tun_key, struct ip_tunnel_info, key);
>>> +
>>> +     return a_info->options_len == b_info->options_len &&
>>> +             memcmp(a_info + 1, b_info + 1, a_info->options_len) == 0;
>> 1. memcmp() is not aligned to the first expr (off-by-one to the right).
> Options start from "info + 1", see ip_tunnel_info_opts and will use it
> here to replace the "info+1".

Nah, I mean the following. Your code:

	return a_info->options_len == b_info->options_len &&
		memcmp(a_info + 1, b_info + 1, ...

should be:

	return a_info->options_len == b_info->options_len &&
	       memcmp(a_info + 1, b_info + 1, ...

7 spaces instead of a tab to have it aligned to the prev line.

>> 2. `!expr` is preferred over `expr == 0`.
> ACK
>>
>>> +}
>>> +
>>>   static int cmp_decap_info(struct mlx5e_decap_key *a,
>>>                          struct mlx5e_decap_key *b)
>>>   {
>> [...]
>>
>> Thanks,
>> Olek
Thanks,
Olek
