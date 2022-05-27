Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C40E53686D
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 23:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344656AbiE0V1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 17:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbiE0V1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 17:27:05 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAEB2B1A5
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 14:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653686823; x=1685222823;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xtjNVKZfmqFTBJeg5urEmEmRnMr7+4gM2iRyLIWkBAM=;
  b=X60dFjR24stJaaksrKdyLOh02JiKL9VppzdPk2gmgEsmgH3W7kjukROG
   iwBoe4oycDc9JyV3w5VlVTap5bRUfm7hLZHQU57jCH8/TbtzdicNIMnCA
   BhuG9SIcrNXz8qPO2KfYR7KY8gC7dYCfZsJ7fXgJ0A24Aa07T3lLRi9m9
   gwcOwLIH+9BT0aE+FUQoE3AJ+7SOHCmj+ERPIwa8T+7Xbqc3nX2tBexCI
   q9VDi42ts0mOqWeJjFQ8pfSHwEqPjFiaMR+f5kQvObhDwluaKq6XQ1B+Q
   5NoTlL+SzJBsEDhVk7qqhdNakCHz6iG6UcGoVWGVxvIJTFahOFL0sXyfi
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10360"; a="335233882"
X-IronPort-AV: E=Sophos;i="5.91,256,1647327600"; 
   d="scan'208";a="335233882"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2022 14:27:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,256,1647327600"; 
   d="scan'208";a="821929752"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga006.fm.intel.com with ESMTP; 27 May 2022 14:27:02 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 27 May 2022 14:27:01 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 27 May 2022 14:27:01 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 27 May 2022 14:27:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXdrmBaSJEYiyg2nnvGLuc6EKGGH4pmcsxsXhsPgAshlD6uqynGP5PK667zeAc0ztyCjjIl8polx9TIqmYSFWQWIzO3t3DSXKO2LyyIrtuQjY+fDaXCOmj7lu0i4Z0liSefPJewwBhGFooCrML45pyc4N0OBhsOcdzupiHfgcFwTYzAoqm2iV2Kr3ap7aCq87s69lI6Lm4CYcr5A3QoQAXuv8UaSCDDqHgr8rvl4X6EiIUX8cA0EPeHg/As5lRMA4svgJzG5UEYi0entuKzRgVTulZ+YlpjoP2gXO4QbNvxZgTRMwa8LSrzUmvfpjgcEIRodQPvtny+58tpdNPUGAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x0+2PnrKFU9+yfLT2pvwH5oU8z7nCpgwUVNOcX+JiVA=;
 b=I63vELfsi6vBtB22gYRovLhPbM7MggI5GG7E89agIKri+dKsVyRLIdnPgFlJew9AuNwRIzXkhiGDHI7FWttWH2dOhg3U1F20QDFEOmdqq7OhCvTeoCmc+Mku6TeJx+mHYOvvBpMx6+Cm91bL7CvBSrbz8zrQPVD4QyrPqZQP8HZMMD1pnoXXiyuef1gBRR3I9GTIkHpSaWBVgD7bZqB9i/z58Iv1qvjHdQ4qF7igcNYdSWO1YJ0WRaODXG6jGc81RyqtIK48Rq3oGK8VcqS8yLMGicXJC5WJyKPegM4lTrhMiSROMi9EofHeGkF2mKbaL4cWsUUw+BZaMv3J8KexCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by MWHPR11MB0015.namprd11.prod.outlook.com (2603:10b6:301:66::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.19; Fri, 27 May
 2022 21:27:00 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::2d92:b42:12d4:bd51]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::2d92:b42:12d4:bd51%6]) with mapi id 15.20.5293.016; Fri, 27 May 2022
 21:26:59 +0000
Message-ID: <a94b23d2-57a8-954f-9fae-246cf900be92@intel.com>
Date:   Fri, 27 May 2022 14:26:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: Bonding problem on Intel X710 hardware
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Sven Anders <sven.anders@anduras.de>
CC:     netdev <netdev@vger.kernel.org>,
        <intel-wired-lan@lists.osuosl.org>,
        "Tony Nguyen" <anthony.l.nguyen@intel.com>
References: <700118d5-2007-3c13-af2d-3a2a6c7775bd@anduras.de>
 <ad3e244d-2f87-c74b-1d40-c21e286a721c@anduras.de>
 <20220517134550.7c451a83@kernel.org>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20220517134550.7c451a83@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR1601CA0003.namprd16.prod.outlook.com
 (2603:10b6:300:da::13) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90c9c6cf-fea8-4239-886b-08da4027a24c
X-MS-TrafficTypeDiagnostic: MWHPR11MB0015:EE_
X-Microsoft-Antispam-PRVS: <MWHPR11MB0015B63B11F5738A8955049C97D89@MWHPR11MB0015.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YYmsLrHJBDA6Z5RoPtSx9w22gic1BnCp4+A+z3JNHOGpD0CJ6FS+aQh7T/OG2jlel0pDak/cZ0RFFAroeva8JA213NEtFEiL/zAvzAWOi2z/rXaQP7Hv26ASAekhoUOMBtX/++RvlPXr5bYXsoFGKZRRhSnm2c3IqAAx9Q9FKYDcAEILXNrFQK6gH11T/YegYQmv5zb3fnheKBvHPc/frcWhhATzEg45NLez8VKtKaAzbOZoKSF5YPWQFny64U3PqbkHwZZFLQDvzsqBzaMvLG4+iHEt/bxbwI1wfihQvmR8EHgYH+BAVWOp0r4YMIKoFpR2msI2kPYJELDBnwKRUGlTr3MIgI2D3exds6fUqIUJ3PSh8uGJ4GiP3/tbxmU3W/ze5R1rE6LgqaXYaNp8vwHeeZO8vPRn0kViNCdLTrbjxwa/GrTgmeRR8pWmbMpZr2KATdgKgFkrf6NLWNWZoVtYW5xhEG/18LtN1DYJ346RAksMJwrafNekJEDuSd+3nXqpAnZ2k0VTYMBoopCb85smg3wvaVCHGdeo9MmTFfYPV015Oxa9g5debCv2mjYTdFMO6JbwVLrtbFAjYWvP0dcolrSJx1mQXiZZ12Q/c4ItzmIpMB9dFLzcLrSOWzjsYZuOAZYoNYIZIbax5oOP5RC5YoGmbsdWlxMiJeuvMD0xD+ZqP99StLLb93eSaaT0yMOVYd8wTz66oNC9iohp2YaaWT51Sy3hIwMhO0GNDG4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(44832011)(5660300002)(2906002)(82960400001)(38100700002)(66556008)(66946007)(66476007)(316002)(31686004)(2616005)(8676002)(107886003)(4326008)(36756003)(54906003)(110136005)(186003)(26005)(86362001)(6506007)(53546011)(31696002)(6512007)(8936002)(6486002)(508600001)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2JrM1NKRXUrdWpRTll1LzF3RnVHazkwaCszcUVZRnorb3phbjJVUDYxRHJU?=
 =?utf-8?B?bFhvZWREODE1dm9TOVZpTG9RcFI2SjA4SU9oR1ZmYU9wRitEbVhpSERUeTVn?=
 =?utf-8?B?bTdwZ0VRQXB5bkFMVm43R3FuOUgrOVcvY1pKdGcvV3JyNjZXT0tTbmxXMmhU?=
 =?utf-8?B?Z0IraXFTRVpYNWREV0Q3Nm5XcTRFdkFTU1M0RDlFckNVUGlWY0RBSndHdFB0?=
 =?utf-8?B?T1BRanRTUEs3ekdjck9VRHpoUEdSczU0Qk5XVnJHMEVHYk5udDZ4OHNmYVJD?=
 =?utf-8?B?U056U1VCbW5pclhiSGhyR2FSZHZQdnA4eEVBSStTb1BkWWc4Z0hRVXMxdGxp?=
 =?utf-8?B?aHJLV3lTQlh1a2tQd04rUGRkTDIwNWJOQlgxZTk1THgvcVBYMnkyc09rbFBr?=
 =?utf-8?B?MWZLOVdVdkxWRjg1YUtoUlZ2WHRsZUsxeXg4cXVRYmd2Wml2NlMwWWs4bVRz?=
 =?utf-8?B?SUsvbVQ5VmVxOEJqME16N1N4eTRQZ210R1lXOUNucE42UjNoR3JDM1J5WWNq?=
 =?utf-8?B?Q0pEV21tcnErSjdRcjY4cXMxU2owZmN2QlpxSmU5ak1ibHVtVnhrY3hEWnZw?=
 =?utf-8?B?Tno1dzJ2bGp5R3IzUnFRQjA3VHlZSFVTWmhhdzNyYlhlYThTV2s3ckl2VW1h?=
 =?utf-8?B?NTRYLzRkMjZMYUF5dnVXKzY0bFZrSzdPUVJPNHRNZ1hEN3p6RGtLcDU3SlNC?=
 =?utf-8?B?N2lIRlFYaVFkb09ESVRvdnh1N3ZNRDl0RStJcDJ4dWE2NHA3cmt5TU9pZGgv?=
 =?utf-8?B?cUp0TjNTa1ZrOWFDTVpYMzJ6TXdQTlRvUjdqZGRycjYySnRHMGM2dCsvWDBa?=
 =?utf-8?B?cy9SdWFOSkZ0UXJjZWFYRlZwSDRsWXlqSCtQZlg1eDl3NEhPNzBpSG5WZnlu?=
 =?utf-8?B?cVcybGE1L0tTYVhNWTgzbmcxRTNVcTVmTkV5RXk5QzVkZFpjMFFNS3pOcis5?=
 =?utf-8?B?M3FhSTkrc3JsY0xwSkFmR3ljZUI4ZGdoZ2FuV1BhREZBYXY2aWNKSmVYSkdT?=
 =?utf-8?B?cGRnNXNkcG9VWDI3TTN4VnM4TGNhMHF4bE1XQ2hETE5CZW52ejFqeEU3dTVL?=
 =?utf-8?B?Tm9tUFhiVVRyYkRka0JNZ1BDV28vVjBnMDduYWNBVGswUkx5MTlWY1J0NWJh?=
 =?utf-8?B?UzJ2NlJ3a0VhREJqY0xRaS83Z3pyRHhjV2FyN0RqWUt1ZVJGN1lHMWc0dlN0?=
 =?utf-8?B?ei9ORGFhNlNLMGp5MEV3RVJmajhZWExxVEdra1JPc2t0OHV0RE1ZVUV5bnBq?=
 =?utf-8?B?R2prM3dITzhrN1l1azZwU3k2K1BxTnVRSldMZ1Zvc0NGdGRLdXZycUVLa3pv?=
 =?utf-8?B?dy9CT2dwVnBBK1lka2ZmU0VNSTJxaGtScGorNjJZVHZSZm16VW0rZGs4NzFN?=
 =?utf-8?B?aW9QWkVqZmNhanNFL3RDMG4wUTNxRVE1Q1RCUDVHY1dGaWRVaEZTWjhxTlhr?=
 =?utf-8?B?clpmeEp5RzE0SFlzRmIrYUJKYUxTeFBEZ2ZkVVNmZTZqVTR1ZFFjd0JhZ2JP?=
 =?utf-8?B?bHN5Z1BRTVg3SFdHVGt6N3grNDUwaWJ6dHV4cEVPQnZGNFNDNFlBbFFudHlj?=
 =?utf-8?B?QnpnU2xBZHhFam9JcU1NSTZ6RUtDeUFQMTJwdG5TdGplWVBNQXRqaE1NV0gw?=
 =?utf-8?B?eDhYSG5LY3VQWDg4akNIc1V4bVpHRGZDd1FEMnYxVnZPeGNIYURQaktkRmxp?=
 =?utf-8?B?MjR3N2tpalRQdTlieXBwR2xCSGF3M1Zmb1U2NXJnNzh4NTRNbkpFVXVNcVlT?=
 =?utf-8?B?VTRRY0FlcTBQR2pDTDJmSFZFOXpYdUtWNXBKaW9OdzRnNVUrTlBjYVNZY3lL?=
 =?utf-8?B?N3ZOcXNzc0c1UVczUHZubVl6bSt6b1JrUW1WWE8wNHQ3dXFDbHlSOG9IZnpk?=
 =?utf-8?B?SFNRS3JFWWpqNm5NTGlHQ1p3d1k0cUVNSWlNZ2dMZllHRmhMT1VkVVphUGZu?=
 =?utf-8?B?VGpqZ0VWam51amVHOGpPc09uSjVkTy9Fbk55bWtRaFNTT0VmVzE1UG53UGRi?=
 =?utf-8?B?MkE4ZUxlZjk0dEFzdEtGZlF5aWR6c0xjZVk1dTFaa2FLRG9keCtOTTFxMDl2?=
 =?utf-8?B?QnB1NnpFeFM1TkN1bWlVR0JWYWZUWklzKzUvcUNlOTF5NFdHRkM5QmJVbG11?=
 =?utf-8?B?TVB1b04yN0w1NzNNUFR1SG9aaDNaWHA5cXQvSVJQYVRBbFpXaTZMRWVISVho?=
 =?utf-8?B?TFBxMEgrK0FqS2dMazhYTzRpUVpJalRHLzVsV1N3VFIxK2VXQzhCVjJYNEZU?=
 =?utf-8?B?MzNuN2dJRk1hSGF0emdmMmtGZGUySkU1cHVqNmdwNmdQU0FQQzdEV1V2NitI?=
 =?utf-8?B?NWtoZnN4Mml4QzBVbCsxMTRPZVpDcmpyN2pxcFNXMW1iQ0E2ZW80QS80TUdn?=
 =?utf-8?Q?e3eCNQP9JFep1t2g=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 90c9c6cf-fea8-4239-886b-08da4027a24c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2022 21:26:59.8579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n540g4A4BkwC7sFFWDx2XjyE8PiOw7kFPfqN8hTbVxe6ajUTxxf5UaWeRC5OjnDSBwQDMDv6vuMNuHZHe7H2GYQpXyizJaKHvHp5ZzwjFI0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0015
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/2022 1:45 PM, Jakub Kicinski wrote:
> CC: intel

Thanks for the copy.


> 
> On Tue, 17 May 2022 16:23:16 +0200 Sven Anders wrote:
>> Hello!
>>
>> This is a follow up to my question. I did not hear anything so far, but I tried
>> to find some some information meanwhile.
>>
>> I've got a guess from somebody, that the error message "Error I40E_AQ_RC_EINVAL
>> adding RX filters on PF, promiscuous mode forced on" maybe triggered, because
>> I'm hitting a limit here.

Yes, typically this is a response from our firmware that a table is full 
in hardware, and I'm guessing that you might be running into a filter 
limit due to using vlans?

>>
>> Somebody other said, that this seems to be an error in the "bonding driver", but
>> I do not think so. Aside from that, there seem to be no special "bonding" mailing
>> list anymore. So I will have to ask this questions here anyway...

this netdev list is the bonding list since it's part of the networking 
stack in the kernel.

>>
>> I want to understand the problem to classify it.
>>
>> 1) Why is this "error" issued? Do I really hit a limit and what is this current limit?
>> 2) Is it really an error or is it more "a warning"?
>> 3) Why is this error triggered only when changing the "ntuples filter" and not during
>>      the normal adding of VLANs?
>>      Remark: I can trigger the "ntuples fiilter" later on again and it still works.
>>
>> I also tried the latest 5.18-rc kernel with the same problem.
>>
>> Maybe somebody will find time and try to reproduce this?
>> I will answer any questions...

We assigned someone to look into reproduction of this today, and they'll 
get back to you if we have further questions.


>>
>> Regards
>>    Sven
>>
>> Am 12.05.22 um 16:05 schrieb Sven Anders:
>>> Hello!
>>>
>>> I'm having problems setting up a bond in adaptive load balancing
>>> mode (balance-alb, mode 6) on an intel X710 network adapter using
>>> the i40e driver connected to an Aruba 2530-48G switch.
>>> The network card has 4 on board ports.
>>> I'm using 2 ports for the bond with 36 VLANs on it.
>>>
>>> The setup is correct, because it works without problems, if
>>> I use the same setup with 1GBit Intel hardware (using the
>>> e1000e driver, version 3.2.6-k, firmware 5.10-2).
>>>
>>> Data packets are only received sporadically. If I run the same test
>>> with only one slave port, it works without problems.

And there are no counters going up in ethtool -S when you receive/drop 
packets?

>>>
>>> I debugged it down to the reception of the packets by the
>>> network hardware.
>>>
>>> If I remove the number of VLANs under 8, almost all packets are
>>> received. The fewer VLANs the better the receive rate.
>>>
>>> I suspected the hardware offloading operations to be the cause, so I
>>> tried to disable them. It resulted in the following:
>>>
>>>    If I turn of the "ntuple-filters" with
>>>      ethtool -K eth3 ntuple off
>>>      ethtool -K eth3 ntuple off
>>>    it will work.
>>>
>>>    But if I do this I see the following errors in "dmesg":
>>>     i40e 0000:65:00.1: Error I40E_AQ_RC_EINVAL adding RX filters on PF, promiscuous mode forced on
>>>     i40e 0000:65:00.2: Error I40E_AQ_RC_EINVAL adding RX filters on PF, promiscuous mode forced on
>>>
>>> Disabling any any other offloading operations made no change.
>>>
>>> For me it seems, that the hardware filter is dropping packets because they
>>> have the wrong values (mac-address ?).
>>> Turning the "ntuple-filters" off, forces the network adapter to accept
>>> all packets.
>>>
>>>
>>> My questions:
>>>
>>> 1. Can anybody explain or confirm this?
>>>
>>> 2. Is the a correct method to force the adapter in promiscous mode?
>>>
>>> 3. Are the any special settings needed, if I use ALB bonding, which I missed?
>>>
>>>
>>> Some details:
>>> -------------
>>>
>>> Linux kernel 5.15.35-core2 on x86_64.
>>>
>>>
>>> This is the hardware:
>>> ---------------------
>>> 4 port Ethernet controller:
>>>    Intel Corporation Ethernet Controller X710 for 10GBASE-T (rev 02)
>>>    8086:15ff (rev 02)
>>>
>>> with
>>>
>>>    driver: i40e
>>>    version: 5.15.35-core2
>>>    firmware-version: 8.60 0x8000bd80 1.3140.0
>>>    bus-info: 0000:65:00.2
>>>    supports-statistics: yes
>>>    supports-test: yes
>>>    supports-eeprom-access: yes
>>>    supports-register-dump: yes
>>>    supports-priv-flags: yes
>>>
>>>
>>> This is current bonding configuration:
>>> --------------------------------------
>>> Ethernet Channel Bonding Driver: v5.15.35-core2
>>>
>>> Bonding Mode: adaptive load balancing
>>> Primary Slave: None
>>> Currently Active Slave: eth3
>>> MII Status: up
>>> MII Polling Interval (ms): 100
>>> Up Delay (ms): 200
>>> Down Delay (ms): 200
>>> Peer Notification Delay (ms): 0
>>>
>>> Slave Interface: eth3
>>> MII Status: up
>>> Speed: 1000 Mbps
>>> Duplex: full
>>> Link Failure Count: 0
>>> Permanent HW addr: 68:05:ca:f8:9c:42
>>> Slave queue ID: 0
>>>
>>> Slave Interface: eth4
>>> MII Status: up
>>> Speed: 1000 Mbps
>>> Duplex: full
>>> Link Failure Count: 0
>>> Permanent HW addr: 68:05:ca:f8:9c:41
>>> Slave queue ID: 0
>>>
>>>
>>> Regards
>>>    Sven Anders
>>>    
>>
>>
>> Mit freundlichen Grüßen
>>    Sven Anders
>>
> 

