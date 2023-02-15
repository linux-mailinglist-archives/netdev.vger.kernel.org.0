Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231886980C7
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 17:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjBOQWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 11:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBOQWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 11:22:23 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308943B3E7
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 08:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676478134; x=1708014134;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=h3SjdE9Yemgngf9nI2wgGWixwzuKO5lhA2aUWf31wZE=;
  b=SxlgUBcWKMHvulBQ6jxEgMBTrSIgAZgf0tkkFUaeJRJq4PIbGLtOciN/
   V7T/U32KnW2dVEiyeETZhfu610p/XptJNsMvCrfGUodHEZEnk02JgsHcE
   o2IiPAnGxPj+YJN/9E3X78QG6RJMYXM2DR9Cj53j5jVxRLqOReHpz0FIV
   XBOUXGRgt2jIHFOhZlXRrLGZcHrjKK2fFRKcuUJTFnLjWBVko8FVpdnF5
   NfxrVjMW/7KI5JYQ9HgtMK0styuiIq21VsOlVmvGAFIZzpH7O0PxEH2Qn
   gvfvotlnisgxi6zpUbKBPEC9NoV3gVc464rkPoNvk8DCG7SyBKiwR8UY7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="333610311"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="333610311"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 08:19:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="700033539"
X-IronPort-AV: E=Sophos;i="5.97,300,1669104000"; 
   d="scan'208";a="700033539"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 15 Feb 2023 08:19:16 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 08:19:16 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 08:19:16 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 08:19:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jnNPd4lLYmlbSvaZ9zDQnCdpIxoWbHBmb4SNtu2kHkY04Rg1yDqxtYCj3VywLhOXYvxWEWXHJvV14vmpnMnpaK0ZOsJtt/snBKSztVNo0lve2Lzb3tXvX2fVwI81CxB7B19Eyog9itFV3vlk+oTOSlcoWLTy0oFRrsojI8/wYozgQ20O3yh15pbszGFY8enNRSLxbXLwElWvKuOwIAfxbAGfXcEwYRiExYQ5mluak2YQYKyk0KdoL+u6T21CfwYtNwN6L9y2uu5KWAuRiBymByQGr3d0nZCdAI7VPxWh+iXnnTUn8/3aRjKudkT8TvZpox+oKmd3b5iM2Wxf+dPTOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VlayqIa5KQbOHYp4pOduYwMZD2a1GOv25VEk6ixrx/Y=;
 b=iKZhULcDtH8Y4rIwDVUzmOSowzMY/XL7oKrW/AIV6fk2HprGmvfCjD2CZJRQulG9hhQZirh2JnNJAudM8VL9FAeOHX6gVgeRSbQocpLE59LWDp8iRWHz4Vto838+OCNJgdIlrRhxjAgCbwksMxOc5pFsXdosRiwVAwMdGk6QUlMbAh2TrXVeUoZzYAmnbAdgkfjlHES/XPPkyorKGFIiUeXgYCdBo1EQlfKlW68M7VtmwPgj4BtbTurMtgVij8fotpKr8P45jMekm1n2aM/Y5PhSijbS37DeRKdsLwIDI1yAy4RUUfWgrTdbHb0tC/GmWAIZ+0oALT1ahwDG5KHB8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SJ0PR11MB5134.namprd11.prod.outlook.com (2603:10b6:a03:2de::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 16:19:13 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 16:19:13 +0000
Message-ID: <f2a30934-a0fe-ae1e-0897-2bb7dc572270@intel.com>
Date:   Wed, 15 Feb 2023 17:17:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 2/3] net: skbuff: cache one skb_ext for use by
 GRO
Content-Language: en-US
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <willemb@google.com>,
        <fw@strlen.de>
References: <20230215034355.481925-1-kuba@kernel.org>
 <20230215034355.481925-3-kuba@kernel.org>
 <21e4b97a-430f-832d-cf49-5f938d1a8b77@gmail.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <21e4b97a-430f-832d-cf49-5f938d1a8b77@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0528.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::10) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SJ0PR11MB5134:EE_
X-MS-Office365-Filtering-Correlation-Id: eeeac357-8703-4fb4-c1f7-08db0f706095
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CjrmvYQXd0a7LvxeUispxX8dbFDEGEepsMEx23e7IgfYNub86r0yitYyQXQ2ZsQuRBQqq7bTn9bfXG4utGhpy/H+kUPOAGsstMLSL6pjksRP1OKBSnbux6arjuzwHVkPO5Yk1vrqx1iCMscJsjgZ1+bjcC5kHlC4RJg7l2kZrXwSZhWSA1SF42wvjmfy4PDKSrzeFkjfKqg0Kp2vFeXZpltT/qfojzUE0l6oykmaWAv5iBlX3S/1FpsoHiTLp/IeyffgF+5QSz3P3V+lbzi/hUx49aRatEYl+BUl1a8RtL+MwXhj8GpOwchPh4DWfxWZzWYtIJknLmpYRbmxxSHJ9bwbLUr6oxlyDEZI5r3dLx9nM7yOpxd3W8xVidu8N1suxysaJC2c1jfMxmc95JgCNryzsmihjMR0+h2TA2WynGEPTgLVShZ0/xk4/+1SkzY/3ifVrl/meuMKUeBAxdkWXfXTdb87a/NeKmeDumo/DjbqBNpIMweOG9IHCHWLJkDHJYwSKRdnXvqRxR+Wt/93hBsHdTEvIrXR6KxmkCUin0IboFHHRjyZCzI2mwrpTXv8eCmHMXuoYb4fKhGEifvbaS2HuT32GEMVkb3y0q5Bzrn94pxf8J2KjdQMctDY2uin4aEQEKkeb/SdR+Bfq7xixZpwk5GcnSnq5x2L5S4MUs2lcHBjsOBsMFWRNp/oCHSbEVzx4sd+p4wmLF2gMMopGmjL026TyLXdLWNjLVqFpYg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(39860400002)(396003)(366004)(376002)(451199018)(2906002)(31686004)(110136005)(2616005)(86362001)(8936002)(66946007)(66476007)(4326008)(8676002)(4744005)(36756003)(186003)(26005)(316002)(6512007)(6666004)(6506007)(41300700001)(5660300002)(53546011)(66556008)(478600001)(82960400001)(31696002)(38100700002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MU5zNGFRYjFDNStrWkhwZitYQW1TUk42cEl6L29hbHhIM1J6dXE0SUI3TGt6?=
 =?utf-8?B?d3djQzVrYlV6Z3ZUVzNOOVVPc2JjQzJLaVNrdHNqdzk2KytNMDlobVd3bHh0?=
 =?utf-8?B?TWYydkRCSmtkSXc3TmdPUmlEc0xaYzhjYnZSUms5bWNNSFl4U2tqWkJ2SHR2?=
 =?utf-8?B?UWNDdVlnWnJFWnZ4MnVPeCt0d2pzTERSaDhuMWVBdkdBZThpUXZ2bTBhR25k?=
 =?utf-8?B?MG4wdmZRSVpGVGhkQWhnR3ZYejgxQnI3RitNT2J6S3VKa2x0ZTNSMFFkUTVh?=
 =?utf-8?B?ZEU3bXJFUnVNY2cvRk1BSm54d1pLUjBYZWhkbVBrbWZLYTJMc2JwV2VwS0lD?=
 =?utf-8?B?TTVRQ2hkdlR3UGcyckdwSFBEbm1na3I4MDRQRFJSbk4rdHR1czVIaGRFa2Y3?=
 =?utf-8?B?YzJ6MDRXQnppZWlJZExtMk0vTVVhdWNXMFNmZjU3V1k4TDNXTldwYkt4bzh4?=
 =?utf-8?B?dUFkajcrVEhxR25pVXcrYUVEUjhvTlpMWXdscUxsQ3hKVHIvdURlRnFNaXFr?=
 =?utf-8?B?V2F2RTZ5TWk3MDQxbFdhZzVySGZzbnRiN2c4N1paNjVjc1dpYXdDU2E5Zk41?=
 =?utf-8?B?N1pCdlFGRjFkRmp3ZlNDNTJsWlFXbGVmcndPTGFDOG5pZUQ1akdmQ1Y4ZUQ3?=
 =?utf-8?B?YlYvYng3MzBHanRmNlA3dVBDMDB2dlFOL0xOV0QreG8yWG5UVEx5SnEwUVdw?=
 =?utf-8?B?cHdqSXVySitSZjlWSy9McmNOOGo0WWlOVGUrWnl6WCtyOTNzQjc2NW9JUXpl?=
 =?utf-8?B?NGF4aDBVUTc0eHRvWngzdlFLZUlJRThrRFVlTnNCT0Z5bnYyOUFnc2FRcW9l?=
 =?utf-8?B?WFh5Myt5UTFEOWZUMWw2L3FyU2wrS1ozR3pDOXUzU2pqZkFzbXgyYWpodEtw?=
 =?utf-8?B?V0VqK2VibFBIU1NoNklmWUpTWjVsUmYwSEV5MGFmbkdaVXdQWk1lTGpPRlR5?=
 =?utf-8?B?djU4TDlaN3Q3dkZnN2R2NC9EK3QremlIQ1JJTkRRZVNya2hXd0FNbjVobjhB?=
 =?utf-8?B?OUhsc2Q1U2g5bXA1SXZuR1lmMGo0c1k5ZHM0YTg1ODcwOTJsOGtSb2s0bzY4?=
 =?utf-8?B?bEs0U01pOTV1Z1RTVGdlaUVJK1JJSFdqRGdETUxPMFlVbG9KbnBiNVFLa2Vp?=
 =?utf-8?B?QVNoSWluTXR2UWFxVi9FcXZoT0xPRUlKMVgyc2k4ZnhveURMMkxmbWlWMlZv?=
 =?utf-8?B?dXNUQW5Nck5yekR3RFpUVjNGT255ZHEvdDBDYkdyb1E0ekpQYU1LUkVYeEdz?=
 =?utf-8?B?QVN6NUhqNFZSTmh2cy82WWtWS01YODNaWnpxRE9KM0RvaVNIOEhEcDdoRFBX?=
 =?utf-8?B?YXMwOFBReDh4V2xXS2xxM2JjVjBKODB4ZUNRLytjK1p1d1lFUXJzc1BMaGlh?=
 =?utf-8?B?cFdqdE9UZE9pZlMvRm5PY2xzSGlnZHpLYmc2Z3VWZE5lUVBWR0lDZGJqZWhK?=
 =?utf-8?B?amErbmlpK2IvbFE2TjJsYWdRWE1vVHhrWTBnd2R1MFVPS0x4cmxENlc4cjZS?=
 =?utf-8?B?Z054WkJYNnZjcTN1M011QmpYRTN2STNsRHZxZDA4a1Q4S2xVOVdyT3ZjK1Rn?=
 =?utf-8?B?Q0p5THNaV1FhWVFDQ0o3S2UzK2Y5dWpFQnRueFRzeG5DSzZOYkVHYm9yTytl?=
 =?utf-8?B?a1FkNFp1TU5aNTJ3aS9vMGg3RVZlaUsvQjRqNkdtVUk4NDFHazZQQVUwbWFl?=
 =?utf-8?B?OUIyeWluZUk5a0pSc3d4UG1aQnduZHN3bnIvMUFSWWxCaC9RbTZzQW9HR1Yy?=
 =?utf-8?B?RHV5b080SjIvM0R5QkhuUXdqajRnYUVrZzY4UmhvdVkwdkxQNEQvRmFaa1Vt?=
 =?utf-8?B?TXJIT1BXUTdCN3BrcnVzbTNveVFwNkZlcFd5bHpPL0VDeW1TSm8vSHVGdUxB?=
 =?utf-8?B?MkFjdGJRZDZBb2FRekxEdE1MUDhoN1BSSEZMU0lOdlZ2VExuL2p5UGQ1TUNw?=
 =?utf-8?B?T3RyQk52aXQ3d3ppR0tpNlpCaEN5NjBMcUZDUHJ3ZUN5U1BMTTJWRk92TE80?=
 =?utf-8?B?T1hHR2IzVFZLQ2wzZXpneEgrdEYrMVR0Rmh2dUxSSXQvZE12bkZVZFAyTkho?=
 =?utf-8?B?dDU2M0dvVGJ3YTlrVlBGWlFtSURWa1FGblZEODlsRWswamlqRFRFbmNYL0Rz?=
 =?utf-8?B?Q1hiQzZ3QWtqcnoyWmZZRks1SWE3emppcnpIQ0ZEZTg3UHp6eC8xZXRlV2Rr?=
 =?utf-8?Q?flcCPcbCAvx7uCog/zX0oSU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: eeeac357-8703-4fb4-c1f7-08db0f706095
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 16:19:13.6581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NmTxamCP75fCfz0pK0LmpzkVP6l6egpMGL526PvU0ZaDGh02Kud09ERb2j2o860KHal70sXGclbrxqcJL2eahuBJCeZSPSvqJNym4vEUixc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5134
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

From: Edward Cree <ecree.xilinx@gmail.com>
Date: Wed, 15 Feb 2023 15:37:44 +0000

> On 15/02/2023 03:43, Jakub Kicinski wrote:
>> On the driver -> GRO path we can avoid thrashing the kmemcache
>> by holding onto one skb_ext.
> 
> Hmm, will one be enough if we're doing GRO_NORMAL batching?
> As for e.g. UDP traffic up to 8 skbs (by default) can have
>  overlapping lifetimes.
> 
I thought of an array of %NAPI_SKB_CACHE_SIZE to be honest. From what
I've ever tested, no cache (for any netstack-related object) is enough
if it can't serve one full NAPI poll :D

+ agree with Paolo re napi_reuse_skb(), it's used only in the NAPI
context and recycles a lot o'stuff already, we can speed it up safely here.

Thanks,
Olek
