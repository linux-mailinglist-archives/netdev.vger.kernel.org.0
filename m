Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82C7621B84
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 19:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbiKHSLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 13:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234819AbiKHSLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 13:11:21 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86BC5E3D9
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 10:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667931075; x=1699467075;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S+pj/qskFrMda8h/uoGB47IWpaKYb2ldShf5xAKf1vE=;
  b=fWQJ18Q8lrHEKRaF3cZFOSQEnxRzJ/DtHS10vXNCcgeUsmjspkb3oEEJ
   jtdl5jDczg+eRxSoOaNofSQszDik8Vf4038wf1BGg3FxzP4FU/War3JUa
   u/wi2PEuZMBNfTKwDSUhqRWs4+7P2zpo9J+ZTgPoFr6AxeVS93rz9SqKc
   mQ0kFqUpv7xv0Bzu+SGacJwCLfoB1VCn6op3FzLjeQLyhxzbUWiJ6Y2wj
   QyFq17F0+tA0GES50AGqOEKFfuPrSWRqrGOY+dvam9l4x9ZwiBhN03nhU
   kOkto3yTzMz9MsfZ11jBY26vSfN19edtF8tgNML/qtGdbAPM3Gylycvvf
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="309475833"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="309475833"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 10:11:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="667685551"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="667685551"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 08 Nov 2022 10:11:03 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 10:11:03 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 8 Nov 2022 10:11:02 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 8 Nov 2022 10:11:02 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 8 Nov 2022 10:11:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J//O2nwF1JzjiueOYk5XDc6DdJBZFAn9lVAHw9QugWWNeEWcUgFYRp9gKgd8gVIyI5ad0Xgko+6040Mhj4J0xh/27l2Eqdz5PjUvliPprdKU2ndb39a8MRV+kSyID7RjnwTsPDVDxE/OdO1YpxUxvOmn4i2ci7KEdjCc8OC9LtCg8PQqpifGA5QvuLQVBNPkl6iPof6zRwcm40fKKAlx8TgrkNlnfQp8augURAFuM2l6BGf35kwE1qNG7WgO7ccv2vyVsuCj/f4Be196cSY5GL+wXrmaS+lcOkhd8JnIENPUbel+awTXbdRAR0BlwxD7c3hBmuNLpYgxuR3WXsibsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EFECBAuMpBJT3aiePsTjiv81tl6JExnTjgqBxK7HDTk=;
 b=RHmGOfg6ObjgHy7JeZC8m1iR/NS84774vWhQ2ixfbfWl9ck4USR+pTXv7jnNQqmUga6IluZlJpO4qyPdjEWdubwkS+GTjdY1bN4rQeVmNtddhhP3amqm8jVj3xaWF81uELRRv4dbSq73EmaTbfD9N4h2FFiHDqjS4KsND9hMjJoQ3RSBteigOp+Patp7ZV29nCTSPXcbQkx8Mw9CJtwD3Y5NiFS2/U994VSwkGtwmpG2ByzEY9mnwpgFhvmsHiZosfI8pq8vcIycqKm8hf2E/gUskjEHpvFlSkEW+tTZeQqc7CfiUSTic+uCzeEl8dq+eZ8mn06DDCnks6u548dYXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by MW4PR11MB5912.namprd11.prod.outlook.com (2603:10b6:303:18a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Tue, 8 Nov
 2022 18:11:01 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::712e:208e:f167:1634%8]) with mapi id 15.20.5791.027; Tue, 8 Nov 2022
 18:11:01 +0000
Message-ID: <0fae56f9-ae5d-1c27-3a91-8d62289c337e@intel.com>
Date:   Tue, 8 Nov 2022 19:10:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v9 0/9] Implement devlink-rate API and extend it
Content-Language: en-US
To:     Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <alexandr.lobakin@intel.com>,
        <jesse.brandeburg@intel.com>, <przemyslaw.kitszel@intel.com>,
        <anthony.l.nguyen@intel.com>, <ecree.xilinx@gmail.com>,
        <jiri@resnulli.us>
References: <20221104143102.1120076-1-michal.wilczynski@intel.com>
 <20221104190533.266e2926@kernel.org>
 <561f25bc-40dc-78c7-0a2c-e7e0fe74ebde@intel.com>
 <20221107103145.585558e2@kernel.org>
 <f0075083-8a11-a2f4-a927-7cd5f255bde4@intel.com>
 <644f926a-17d1-175f-8a40-39f75d1e49a8@intel.com>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <644f926a-17d1-175f-8a40-39f75d1e49a8@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS9PR06CA0688.eurprd06.prod.outlook.com
 (2603:10a6:20b:49c::30) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|MW4PR11MB5912:EE_
X-MS-Office365-Filtering-Correlation-Id: 70eefc31-91da-4957-ef42-08dac1b49786
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cJz3zNIOnyF0pq5AkcLhPm4fAi9TgbSj4ufKcL6qRyHsSwJVec2iyQzirbKIFarM0ivKhNuSyzjvwTcdUdckdvkFoT1ebOhGRnGFWBKumVradUoyLanurFVDG0hQyHXdPej/eMXZT0HH66ydX+LbgYUS7w5tNKeEJgegie/Zp8IagWsDB0q5h5OZzElT+NZnqVXTfWd/wMG+F+bO1i2iNienPctyZKF43aPmCkQr9lyjVZCQVLzZVOYd2Bfx3dTg2YQqltIjgD5KnU39NVfhRbgx1u4Ye/z2mmhZWbLI+jnqKEN14haf5q1lgiPXS3kr74JRJoEyfs2f42OGwrL7AWSMx8CWYf03qqtAmvki5KB0WqoVcUXRggm33qR5jmMCskL5f+9dhIFrekv4TW/BoAk0DkPkBCuKFQVCMIcjCL9epJZRD/G+CLSovhyw7I8jua50PaYk2O2MkGtECVBXxhvWgdipQ74FQT8mVW1zUINj5hJnvce1WVCgU2pGBKqEnxTHrRhS1Zuzm/yvnDxSLyDVXjM+PKF4yuq5DYdfdTR3v8/D30qC/2qYwJq7xHKI5B1E8vzxkj8B8Af/tMnGoszEFEIF5kX1oiq+d5Jf682hWOynC+yAKUf1Ou4rGIroYz8aQENhm+bRkEqdX8MlDZAlw9wxNpFBLhFFvJcpceRgCE+wwdF/sogkIXiw3LN5InJDy2X5sGu2t/bdL7/V+bSHNWb3xmopgZFSvE0bPcLzxj9DN929tVR4dqVf+LojqYVPWt7P1PUjTfpe2MQkZvJzVIL8ZSKGGz6BC6deqTxXJ/GP/2u+tf6Pyl6rrSAl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199015)(31686004)(6486002)(36756003)(53546011)(6666004)(478600001)(2906002)(8676002)(31696002)(38100700002)(82960400001)(86362001)(2616005)(26005)(83380400001)(6512007)(966005)(186003)(66476007)(6506007)(316002)(66946007)(66556008)(110136005)(5660300002)(4326008)(8936002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHFxT3ZGMGwxanQvcE9YTXptN0ZCZUhHdG1CTFlLZHVqQjE3SW12T3RIaVh4?=
 =?utf-8?B?TG9PdjJ1a2s5MnhOTHVjUXUwaXV5VUVQUGhjVDZieCtIeHlmZ1EvZUNPRUwy?=
 =?utf-8?B?Q2tDV3RHY1FRK0FLRjJWaXlUblNjaXhuaVoxcnZRTXRIbGVRQkY0eGRlL3Uy?=
 =?utf-8?B?T2cxWjJLbTFibElHZnM2TTZ1U1JrQkd3RWYzS0dTOUVyVUYxdFIzQnBvdm9M?=
 =?utf-8?B?RWdZZFY5Qlp6NHhFdDNqc0NtamdvVWFJS3g3SDQrU2lUcEovWCt3SnFpYTNy?=
 =?utf-8?B?Z3IvMTRod0xwZDlhUmlhNGZQM0xaekdBaWJUVmg2c0JqRE4rTTVBS1RjUGxq?=
 =?utf-8?B?VWFCNitPd2ZoNXc3NmdJcUNQdWNNb3NhdXA5R0dEZll5Y2NRSFJwL1JIME1O?=
 =?utf-8?B?NDFUREhNcy9ZWDQzUjNXV3BzeVlsNGVFR0d6Z1Fwekc4b3BZUSs1WUNVU2dP?=
 =?utf-8?B?NTVVY2NEalVFd1c2SFZxWGYxdTd4aHpvRHkwMVdmSGlOS094emxQZkUvaFZ0?=
 =?utf-8?B?cnJ5QlNSZXVwZWk5UWw5LzJwbVM4OFFUWWJBU1haUTRCbzYwRHNsaUNEbWU0?=
 =?utf-8?B?MkJjTmJFS2l5bzB3UGdwaXdDN3k4WExoMlJHYnp1QzNXSjFRcU5rdU9Lb2Jj?=
 =?utf-8?B?Z0dmS1ZHRVNOSWQvK1FhK2V2VjROVitJOHBDanpuZi9qbWN2L1lNNlJQVGsx?=
 =?utf-8?B?bU0xMytKSXpXLzVJdTUvQXRXVzBWUE1SVi8zOU10bDREZjRROVgvMGZKVU5M?=
 =?utf-8?B?SGFYS3VYV2VlS3lHNjBrVjU0T1RqdHFzYURKKzdMUlc1eUJYckswbzRnNHZT?=
 =?utf-8?B?Y2tWbm5waVZVTmpwVWxEdHhvbzIwdjZlWm96cjFLdkc2a1hiYjR0RVZxSzl3?=
 =?utf-8?B?VmNIK05oZFRwaU8raWx0SStrK3VzNnVLS24yWWZ3a0pFd2JLSWVLT25ucytG?=
 =?utf-8?B?ZUgzaVRjMGdPbHJXVTlOSW90bi9kZTZvZzFDaEJuK2x3WkVCVFJCYzFkcndW?=
 =?utf-8?B?MFNsSWNrU0VRWTUwUjl0ZEtCekJiL1AzNHZBNkJnUzBnbXBvdmtlanoxYitq?=
 =?utf-8?B?Qy84STlTS3cxZEl5RGtTYlNtYWg3VXR2bE8wTEVDWmljN0tvWEpTMnQ0bXJ5?=
 =?utf-8?B?MERiZzEyd0xYbDFoalM0bG5tRVRCYWVVYXhSR1ZxY3pITnNzdk9RRDlqVWtN?=
 =?utf-8?B?dThZRTQ4dGxXcXVpNkVGOE84RHFHc2ZLSmx5Rld0REFhQnRWQ1ByKzJBYkV0?=
 =?utf-8?B?ZldDMEVKZ1JPUFBJWEpCOXhtOC9TdG9XM2l0QWowNDRmeHRQbmtVRVFtKzc3?=
 =?utf-8?B?TWppcFovVmVkWlFJS2s1bGM2STRzU3FyMFJtNzVtOXV4N0J1THA0Qy9Pck1n?=
 =?utf-8?B?akpwdkkyWmxKREJhVmVhZ2E1cTJVeHRwd2pjeVhBOXFiaGVZYUQ2ZXZZUHVZ?=
 =?utf-8?B?WHpFNDUyWWl2WC9nQWJnN3NTRVVvakFvQnErb01HUnQxM3JDSkVNb1NzbnRD?=
 =?utf-8?B?a0czS2hJMlNwYmwveVNPUkJEOTNNQnh5TmY0RDZHMDVGdlJEd0x6aDNnc2cx?=
 =?utf-8?B?SFJkV3hZRmRUY3pYbEFWbzJXV3JuUWNmY01sdmtwaXhSR3kwM2FZdEM4TkQ1?=
 =?utf-8?B?RE9ZNGJKdlZ2eW0zUnk1bWY2b0JtOUdDbERRVjRoRjBHdFczaWZ4bzBRT2N1?=
 =?utf-8?B?aDlVdVVLOXpkdnUyK0U4eFVieG9PYm5wdmZrTWtYTGVhTTdzL2xrTVpveGdZ?=
 =?utf-8?B?b2hvWm4vNmtyQ2NzcU5GT2dacEVrb2JIS2VhcEhUZUliNDlvQmYvK2hWdGpR?=
 =?utf-8?B?cDgyMGM3QnFST1JwaDlSZHEzVTNLb0JqZ281SUU0eWkwaE9OYjZuSUVaV1Qv?=
 =?utf-8?B?T0pJSDEvdExkeGIrNExDTnZ2VUJBcTZqUHdOOVU2SklqS1VFRGxqcWlybWIr?=
 =?utf-8?B?YkFFcmRYc1NtdUdxdDdZWG1NTWxxcWRJQ2NOMVI0RjhNK1RldDV5OWpUalBR?=
 =?utf-8?B?OHc3VVlYZXRFNDJ5Qzk3MEpGVGF6TmRlT3hWbEN0Q3Jkdlh5UWVCSjRLL0px?=
 =?utf-8?B?US9yeWkrMitnWDFLVU5oTWRLaEw5VW5FL3liVmlpeGl3ZEdBNTk4cXNnWWNI?=
 =?utf-8?B?RjdGTlVTRVh0dEJwQjM4V1E2RTIyNi9aUXNhaGxrUWQwbnI5ODljajlOODJK?=
 =?utf-8?B?d3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 70eefc31-91da-4957-ef42-08dac1b49786
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 18:11:00.9166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5VOPoMX7oOps1EhWnRUU3QiWNpw9eAxCwy/rNaUzS8KenaLmkX0yOd7fYgfaqMuvDyN1QyZqVWxFeB+ZN1dbiyLTR9BCTldKnvkmuGXLWro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5912
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



On 11/8/2022 5:54 PM, Jacob Keller wrote:
>
>
> On 11/8/2022 12:08 AM, Wilczynski, Michal wrote:
>>
>>
>> On 11/7/2022 7:31 PM, Jakub Kicinski wrote:
>>> On Mon, 7 Nov 2022 19:18:10 +0100 Wilczynski, Michal wrote:
>>>> I provided some documentation in v10 in ice.rst file.
>>>> Unfortunately there is no devlink-rate.rst as far as I can
>>>> tell and at some point we even discussed adding this with Edward,
>>>> but honestly I think this could be added in a separate patch
>>>> series to not unnecessarily prolong merging this.
>>> You can't reply to email and then immediately post a new version :/
>>> How am I supposed to have a conversation with you? Extremely annoying.
>>
>> I'm sorry if you find this annoying, however I can't see any harm here ?
>> I fixed some legit issues that you've pointed in v9, wrote some
>> documentation and basically said, "I wrote some documentation in
>> the next patchset, is it enough ?". I think it's better to get feedback
>> for smaller commits faster, this way I send the updated patchset
>> quickly.
>>
>
> From 
> https://docs.kernel.org/process/maintainer-netdev.html?highlight=netdev
>
>> 2. netdev FAQ¶
>> 2.1. tl;dr¶
>> designate your patch to a tree - [PATCH net] or [PATCH net-next]
>>
>> for fixes the Fixes: tag is required, regardless of the tree
>>
>> don’t post large series (> 15 patches), break them up
>>
>> don’t repost your patches within one 24h period
>>
>> reverse xmas tree
>
> Giving everyone at least 24 hours per posting (if not more) helps 
> ensure that limited reviewer time doesn't get overloaded by constantly 
> re-reviewing the same code. It also helps ensure that everyone has a 
> chance to look at the patches.

Again, I'm sorry if my actions were annoying, or seemed overly impatient.
My question would be then, when I am allowed to re-post v11 ?
Technically I didn't re-post my series during 24h period, I just responded
to comments after re-sending a new version :(.
I guess I should wait for Kuba response now, and only after getting a
response re-send a v11  ?

Thanks,
Michał


>
> Thanks,
> Jake

