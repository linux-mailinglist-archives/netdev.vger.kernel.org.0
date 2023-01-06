Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9F4660A71
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 00:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbjAFX4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 18:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbjAFXz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 18:55:59 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADFC3AB31
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 15:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673049357; x=1704585357;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tTEsoTEXxvrp7sXXNBNTdPInLVgvxgBNu8ekBBDh61c=;
  b=H2BvVCWN35BPOTN5ORlAneiX7gUYye/Ij0rDOLjlSu0XQv8wyStEC8WN
   d9GywziDp26MOHQri2ZHdPbPyLnUJ96S8UOaCCNVkPVdl0dCH/CZz3/cr
   HyTGv+jF6lkxi72vvTHsjHX00wHv+ETBfcVUjtkzyYOr0im9sH7JrDJiR
   9dpaSiT6unxQG7sS+8CWi49AYoikG/9N63vdYemL1OjL7dJunYuZ4YFZ6
   7U9DCna0njsa3YT2twa7MJuCuFOfc8YKc53VbbXjs2CErQ+/HJRoDb/mi
   VTcQguchQR3NPeE7X8sUAQQpIDXrlrPTPq8/Mo0MSypOU9voKKLU1Dwus
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="408836857"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="408836857"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 15:55:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="719355826"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="719355826"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jan 2023 15:55:56 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 15:55:56 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 15:55:56 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 6 Jan 2023 15:55:56 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 6 Jan 2023 15:55:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R8G4S+VJPCUTXgxQgEw1ZED2KaauiDEwabDDgCuhHntoQ0s/EwrJD+Tm3MXs7lYdcWVaRVGf+V1x8BxftRZe7NpsKxEffxQxpzMtNSv+OC+p6cd5RcBqDwtYj4vbdcfZEe3F5r3uIv4rbZlkPumVjDdKfsrzZP6QPlrg7Px5CIKS2D3i+LivLtoIfuEo/DSBpueXsnzzUOvTUidUfw4mSSNqGSoU+Z9fbw+rRF6yGEIsKwY1g1z+nmgSXiF5dkX4JCo5TjGpKURW8jz8zyy78FGq+lHOkvSeOVU8k8L+pomveBTevXgBwDZvqcTpZlFCEtIHbtwQ5Dc+dOeZ3hKc6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hsMk4xZs+ySFQXYlvJ3660Xs/+vtxQJ4BmLl8FM//rc=;
 b=OeTjUffRTvnq7aDHg+m7W5OA/BJTBE+jFdNd64ElkPkKX7uXowTaR7NSTqJIwK7yRKvHTgV+1/+MBISk83a/a1xnSn2l0G2bmoFnjnUN7TatQ4bgfg2JNFABeGp+pTODMuZ6W1a8QCHy2pjeyQ2d7L8QolTa5I6fHX+2s+ckcJjUqeoUNUOCA8Vtx1rH9e/vx9FLDlqrC8BkK9W+Bow/xkdt8+xhgBEIF0gT7pi+zrWQVHfZy4vcsjwv+CHkUAAHcNZA7AJ4/AuzN70fJaNoKcWdE6+Q+6tZTMFDwdnp73JoZpOELaKgvHoQ9kwx1c5SqS22wTaiNGoTd9hXVnvkgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ0PR11MB4894.namprd11.prod.outlook.com (2603:10b6:a03:2d4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 23:55:49 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::cfba:c3c6:5b80:cd9]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::cfba:c3c6:5b80:cd9%7]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 23:55:49 +0000
Message-ID: <a02d12e8-b67d-53f6-8a48-8156066946b2@intel.com>
Date:   Fri, 6 Jan 2023 15:55:45 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 02/14] devlink: split out core code
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>
References: <20230104041636.226398-1-kuba@kernel.org>
 <20230104041636.226398-3-kuba@kernel.org> <Y7VL6P0hfCEvBFzV@nanopsycho>
 <20230104181007.65d0eb6e@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230104181007.65d0eb6e@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0028.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::11) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SJ0PR11MB4894:EE_
X-MS-Office365-Filtering-Correlation-Id: 59ed1a56-9a18-4030-ae5a-08daf04188f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d2Jij5htWhPTST74lcLvZKI0NDyCX2IQXfghTUQG9/4FBIrQP6aud+8VmSS6cpWEQ41mfEBpuKeXJQG5bZlQWM6vsSh69ClDh13wjQrkYO5l7W1G6k3eVdgWzP0+wa66sf0MlFV8jVwbSf2hTqlJFKGwrDL0ZvzbYLaqXnpvwYlu8hNuPdZhOVSShtFKfmBvkrqzxHNz7NyQMaRHHLJxXSerOrxSksil+U1/pSg5Qs49JsVrJCurtLjDzG9K1Wi4n59UTqx975OKzyucvLqteFZ3iKwB/rxqxgd6a0IY28Nt6tzenKq+qc4HqW5afU4K8NtLGq4jHlS2LzLIA9vqI+yq4P+37VjNxS7k7V0n0+yMm1QtUZdAlYsy7MKP6BUPU4WABrMVURaZjYgSmVmtv+upIV8zkcYR2T2Bb6o1/17IGXiIV2NHk+uM6JULqLDi/5lydq7pYWLsbTPublsEBJLD1njuD/Z7vUStAICrZ3K5C4p5WK0aQ9LYA7Sw9+/NRIwQcFz5iKHJMdBjBVXlgSwtv/nP+3rQVg/91qy5ygmS3tfk+1UdIH6+qyv3R5c1k9UNRgTZ+unU7AKnaoLT3R9+IfxC0v7jFyajAzfaYc4xur9fCFLfw+hQiBjwpn0zrEjDsG4TnFohiT/VY5cen7MRZyGidtmTBEltpOCXd6aVuR2xzBRd3Xoj1St6xTN/RtZiN037yI2Xk+KJaaQw2GqPrrnRDI3w5SRFUZNfsNc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(376002)(136003)(396003)(366004)(451199015)(26005)(6512007)(6666004)(6506007)(31696002)(86362001)(36756003)(186003)(53546011)(82960400001)(38100700002)(2616005)(316002)(478600001)(4326008)(41300700001)(8676002)(5660300002)(2906002)(8936002)(31686004)(6486002)(66476007)(66556008)(110136005)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MEJTMXlTQ1ZoMmNXYVJiQ0MveWVwRFJ4RjRyaUdFRDBub1hJb1Bza2VKUi9v?=
 =?utf-8?B?K3BaVlVGTG14M0lpUFYxclZqelNRZDUwZVpQZEpjd3UwbmVnUXRDeEtwY3Zm?=
 =?utf-8?B?TjJYSnArRnNpUTBPazJ1Z0tudmhNRm9PMmloRk1VQzd5aWFUcExWY1QrODJK?=
 =?utf-8?B?bTROTWNUYXZZUVpVd0VQcTFVbXJhVnpaZkp5VXVSSmlwd25BalMwOXZpZnFF?=
 =?utf-8?B?VktiM2pLOXhjejkzY1VYV2dwaFArbmZOUGVmbnNIZDFYeVZhUEJFdjkrWklI?=
 =?utf-8?B?a1Q4ZUhKMTVPcUVsbllvSDhTVkRvdjUrd2pTa29HQko5emN3eFl6UXdqSUEx?=
 =?utf-8?B?ZVdqc1RKSmdrQnY0VTZuV2YvRVJVbHZrNm95bFF4M0dvMnFMcDQ5M1MyVE15?=
 =?utf-8?B?WEt3WCtoVitWWUFFaWZqeWg4OVphUjByVTB5VjVWcVF1V1QxQlBSVCthZTkv?=
 =?utf-8?B?WklnRjUyZzhUYWw5RzRseHJUS2J5Um9qNzZnNGdDSUNVaUpXNFJhSlNJYkNx?=
 =?utf-8?B?NDNoZGcwRUVjS0RXWkl3VE84cDBrV0MyQzZFcTVmamtsQkxwWHgyTURKUkVW?=
 =?utf-8?B?V001L2R1UVVCTVo4Zy9BQzdXcllLeHFUeDJLUTBQcmwxb3BSUXo4ZjJOaVBG?=
 =?utf-8?B?ZE1vQUljeWlxWmxjMUtLbkxzT0JkTVNweGVrc28ySS9BQWRnY0MzVWVleHlI?=
 =?utf-8?B?bmZ2TGljOW42UWlxNTNqSVhoSk51QXptTmViMmF0WUsyeTgzcHNBcDF1RjU2?=
 =?utf-8?B?N3Z5QzdFTjJRTXpaRnlXRnA0ak9jaWNpZWF2N1FkdXYzWUx0NXlMSitPd0Y2?=
 =?utf-8?B?OC9tbmI4VFpsTlh4QnZSUXU3THczTnk0R09iWktDdVBKZnVobXkvQlZtZ20x?=
 =?utf-8?B?UHN0dEFabUJWMW5YKzAvakNpTlc1SENhd3NHKzIycENBZHo3b0dKSm51YXNm?=
 =?utf-8?B?dm9yOUkyelB0RDkxR2RIdlBoMk9aMVJZOGE5TE1XdFRFNFJxS3JqNnk3ckF2?=
 =?utf-8?B?NGRIU3RjL0p4MWFSbDQ1QThCcUNNa08vbzAxVGpobHpEcno4QTdOb3Vkd0Fu?=
 =?utf-8?B?NHNQOXBzUEl5SEwxVUpHdUJzQW9jSFhNMzFFVlMvblF6MkRCZE5xRzIrNFF0?=
 =?utf-8?B?bXdyZk93VmlmSnN1RmJMeG1jaTV4Z01sdTBOQ0JtK01CTDBjNlF5bnZheWNH?=
 =?utf-8?B?SDkvYndhS0pQRWtsTHFOSDNQckFOVjZ4bVB2bldvRlE5T25jVjVUL21CYUpB?=
 =?utf-8?B?YjlqZ1M2NjZBVjdwYk5BUHVka3pEaGQ4aTNlSEhDWWxWcE1DWS9QZW5RV3RO?=
 =?utf-8?B?UkJyKy9RNFdIcjRMNmtSQUttK1p0OEdYK2R1QVRDcnIwdFJGMXRwU0pHYU1s?=
 =?utf-8?B?UHQxZUVkbmpIcXpDanJDWVRMeFBXNndHWCtCQ0RkOGl1YzRKWkhlM2F3OEts?=
 =?utf-8?B?Y0dlaDF6V2JWUHRaWFBRTC9idVJjZXpUWDUrZmlJbm84VnA5d1JhdFdJM3VY?=
 =?utf-8?B?SWJJNmVzSGw1cElrZHkvVGVZSjVaaHZTdGphYnAzZ0R4aEdxTGpnaXpZdmkv?=
 =?utf-8?B?ektBTDZKRk9hZ2ViN1Vzb0xHd1F1WHVPeHFHTkZqbGU2WExScGYybFoweCth?=
 =?utf-8?B?L3ZIc3lPZmhKdDR2UnhaQnJNRG41UzVFVFFBK21LdjVCcEUrNmYwOG9DTXVs?=
 =?utf-8?B?ejZUWHNMVjQydnV2T3lRbHF3VXdwa1FJTE1na0R1NlgwZWl5YmM4bE0vTlhm?=
 =?utf-8?B?Vng1UXBFSWZDVWt5TDlCREc4bW8rei81VVFSYnAvQmpqaWxwT1h3bDN4WE1v?=
 =?utf-8?B?Y3NtaEZzRmRjdUJZb0paZHFVMWZSUzU4dmowL3ZVeU5SMFduY0wyemZhRnNR?=
 =?utf-8?B?VFJsUVVtYUI3WkVXWFMrQWVFSFNiWnM1RW9qQ09JeWJDT1QwYWRVS1JJYWlp?=
 =?utf-8?B?WW1aSVZBQUlnUVZMMUNZa2hML0NoSXl3ZngwUUdwMDZ2RXlDSzFHT2dJRnhL?=
 =?utf-8?B?QWd0cTdvWVV3azd3TkRLOExFMjZPam9OeGY0dkltWStXZGsxUXNGc3hCVU4w?=
 =?utf-8?B?VHYyWHM0TzFnbkl4bjZGQi9DdmxlZmNwRHJFYUFyaU9GWWEwd081YzdMN3Ew?=
 =?utf-8?B?cnhOd1ZaQmI1cVRDdDIwUitDempvNzZoQW05aWk1Vmx5czByNzNNbkRPZ2Nj?=
 =?utf-8?B?NVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 59ed1a56-9a18-4030-ae5a-08daf04188f8
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 23:55:48.9916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DvODaO6IPUVt5cHZbUQbYAiQ2S9WN368GYJT5ARG5Crl6oOEVGOHYF6XnBVg0kTCopOcASdwaQVW5RLVpqF6k49DOCooSA/RRuirbbOUkaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4894
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/4/2023 6:10 PM, Jakub Kicinski wrote:
> On Wed, 4 Jan 2023 10:50:32 +0100 Jiri Pirko wrote:
>>> Rename devlink_netdevice_event() to make it clear that it only touches
>>> ports (that's the only change which isn't a pure code move).  
>>
>> Did you do any other changes on the move? 
> 
> Please read the paragraph you're quoting again.
> I specifically addressed this question.
> 
>> I believe that for patches like this that move a lot of code it is
>> beneficial to move the code "as is". The changes could be done in a
>> separate patches, for the ease of review purposes.
> 
> I obviously know that. That's why patch 1 and patch 2 are separate.
> The line between what warrants a separate patch and what doesn't
> is somewhat subjective.
> 
>> Could you please?
> 
> Sure.. :/

I am fine with it as-is, but it would be easier to review without the
change.

I typically review such changes using git diff's --color-moved-lines
option to make it easier to see what changed vs not and ensure it lines
up with what was described.

Thanks,
Jake
