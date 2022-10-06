Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C0A5F711F
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 00:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbiJFW26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 18:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiJFW24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 18:28:56 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC167CAE63
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 15:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665095335; x=1696631335;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/04RLjiWalmPiqaSdC246F9RloDn1qz38u67MqUconI=;
  b=BFhS2lm7SCM7fMDGpc2sceeMpMT00oE4iitZ3Y20MEVx0ktYf2h6VVBF
   VZzqkfMJdw7f6VniIF9sW1LVz1MulMTIE4z+PnXw2wm/TvucLpKTxE4j1
   C3H0AarJhkBl6dAD63Kjp0NTKsnQ2mrk1Bfnz2Ua1lY8zx9IXnIyVczvJ
   fpoLdGVwy0YJkVyJTJFhp5lafqv9RJcTmWH7QPZe9J+6aiqs558h/Xj6L
   ivnuskFjoBQyuQePM8bgBGVik/+V9uUQx1+oh6xHZ45N5zTC6JQ19fJ+C
   ihr06vdPNJ6TGo5flFXSKz/JF9BlJwTNQFUX7X0sLKMRRAkG+K15ib5Vk
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="367716940"
X-IronPort-AV: E=Sophos;i="5.95,164,1661842800"; 
   d="scan'208";a="367716940"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2022 15:28:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10492"; a="602630404"
X-IronPort-AV: E=Sophos;i="5.95,164,1661842800"; 
   d="scan'208";a="602630404"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP; 06 Oct 2022 15:28:55 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 6 Oct 2022 15:28:55 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 6 Oct 2022 15:28:54 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 6 Oct 2022 15:28:54 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 6 Oct 2022 15:28:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eLiNb1ilwLUFHsOikYFCyE3eD8wghCsbCK0HnUhq2IZi9DVe90MyE28FuTAM6zuzmZY12BetjHEJi60tfJ+k1ssA+54Gvg2O9DWbSyNPCmfzIK7lm8cxr6vAWmI77hD267jSiTyHNDjiy0HDAeDrcw90qg0zS8Hc2BSsAHzHQE4pORO+AVtFziArSYeI7icCtrkQoJlw9YYEFnzkr+rdfyo7ondabEjENNUyOgpKr6TXnVeJb/y1vL5Mma5KCHfxPyBtIGXIunEc4tGDun0FjzJjyYWwCjPT28EolLQC9TuvC7M6Yulmj6wrTh7tzWd/dYydp5z8imJDoHPN9qsUSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rq2C5oRFnIzR6QcbV2pdaNkLO6YQulDY6spqWIXnn9w=;
 b=mTj5nOibe/uIRl9pGAnTYkdri4HBOzRYYL/sb9zPvZNVtcRd/Gbm5Z32zB8BADZHbGNb9I+C0CFaUrAxMUZsNYVLdHYB/xtnrazL7pi7s15p9E7O9HZzQwyjHI5ygyLJisC2Kn+neE5armOOd+rhfroOTPkbMckDDVFNRl/GOEMjeb0QmS72s3cz8gBxtpZfvRbWzAC1t2dhrpYl2ffG07TNQSvW9KpJPuUTjjgRmzX3pCDrS6YUTbngTO/N0dKaXdlLrnq/KOIVaQj02b9TC1wRpTm1PTy6Riz6/Hw96cFxvqehPz0TFgZiaVNLDK2xnPVjxeehz6BHFJQYD3Bc8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by IA1PR11MB7319.namprd11.prod.outlook.com (2603:10b6:208:425::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Thu, 6 Oct
 2022 22:28:51 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::2b69:8b23:1fdb:b4ad]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::2b69:8b23:1fdb:b4ad%2]) with mapi id 15.20.5676.036; Thu, 6 Oct 2022
 22:28:51 +0000
Message-ID: <ddf02cb6-0ad4-0396-79f7-bd12a5c8d552@intel.com>
Date:   Thu, 6 Oct 2022 15:28:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH net 2/3] i40e: Fix not setting xps_cpus after reset
To:     "Jaron, MichalX" <michalx.jaron@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Maziarz, Kamil" <kamil.maziarz@intel.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>,
        "Dziedziuch, SylwesterX" <sylwesterx.dziedziuch@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
References: <20220926203214.3678419-1-anthony.l.nguyen@intel.com>
 <20220926203214.3678419-3-anthony.l.nguyen@intel.com>
 <20220927182933.30d691d2@kernel.org>
 <CY5SPRMB001206C679A78691032E6E73E3549@CY5SPRMB0012.namprd11.prod.outlook.com>
 <20220928071110.365a2fcd@kernel.org>
 <CY5SPRMB001280F71009BE8356684179E3579@CY5SPRMB0012.namprd11.prod.outlook.com>
Content-Language: en-US
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <CY5SPRMB001280F71009BE8356684179E3579@CY5SPRMB0012.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0162.namprd05.prod.outlook.com
 (2603:10b6:a03:339::17) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|IA1PR11MB7319:EE_
X-MS-Office365-Filtering-Correlation-Id: 84d44982-9806-4f10-84e8-08daa7ea24dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1087+N/WcRv7feUq+0JBIbARSgY5kd6k9QTc/2lonUyRQqmpyGSSmLnTexG0CQbO+toiUxShEtb6mSFx3wZszppixU8DhDq1/O+S113zaO3MLqjkReomVGjQtRV84Ir8CmA73rJgzdeQVock1zrUxXasDegKUsIZWM6lQhfSz37hKwAjZEyCdoEZbPOKd1QRRJmDxU4O8W3kg6me+Gc2mx2SFRLdS6M77fdqsQ7e6kIZcnc7n1u74amcEv8BBhGL5EH8Yx/HkngE7vZ7lCnvJyjpi2pmqJ9kkWK7dV5WGlWbSO28f9jU98qc63lyEXhf0i08efvQ8a6gHSPj1SaYICGK9tNQIFZXE9S3rS9EBGFpiTH6foYTiDE9nS5QlNEPnL+R6T0uQ7B9iT6oZCQeVPVb0nsOxeplNnClci14tJkCUiSLpfjXLNgbkHKv2qBGbll8SBfhQow8aph0lD+swjSjbxBnjLW8ZhGoxduW29Btex3bhxvq5MNBfLcXWjyxqhSxbXcM64maXheoV3AFLK4CUo5u30XP3BM4TZ3yJV739tqsBMWPj5EwGya8Muk78/6XTGDcc5TV8vXK7evR/FWcsMaeQKP6vzgmURLusaop1W8gvMJymSfrReGJmPE7pxg+XP+YDa1otCRo49vKUozAiKGZHEwRL8qBTufugLDP8o/YV3dyRRij6/B/2I4pRjSMD1TCpU8Wu9+SEmNRKeX4Pk6c1ZLjFJ1K2IBQau2DWgTRP95N99tln+z2L4NasKach2nnx0S/qkIVFCAjJgyvO8biPcMbUqTla37ViPiiA+znBE8a+zSytmhoadP7jyynmS8pbW5cnDe/CUikxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(396003)(366004)(136003)(376002)(451199015)(83380400001)(186003)(6512007)(5660300002)(82960400001)(2616005)(38100700002)(2906002)(8936002)(41300700001)(478600001)(6486002)(53546011)(26005)(6506007)(6666004)(107886003)(4326008)(54906003)(66556008)(966005)(8676002)(316002)(66476007)(66946007)(31696002)(110136005)(36756003)(31686004)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bmg5aE5SY1BEaDlWZDZkVnhvR1lVanFVbjNGOGtndkcyd2FrTDZ1WFB4L2or?=
 =?utf-8?B?S2NKdFZmVDBPSENNc3crVTZ0UllDNURGWW4rK2dJQTZoM1JUQU8xZkNHZ2Ew?=
 =?utf-8?B?MmFtZk81VVhGVjlwNGY5R2NaeVBnUGVVQzVnSnFBbzBBcUxHNXFBWkF2Vnlk?=
 =?utf-8?B?dUlGMjlHWGRranRHeEF0SWxhSFVST3J4czBiWVpLdzVvc2VBcm1pRnVONmRa?=
 =?utf-8?B?aXIxWFRRbnVwVTVISnhvUWd1OXBuOHZUVGFuZkc2K202R1FPa1AzcDZhMmEy?=
 =?utf-8?B?dElwS3hVNkhCZjVhYkxUSUdYbmxOWUptZ3Q2MGhBbVBXc055anZsUXpVZUlY?=
 =?utf-8?B?RlRlc0JuTkdybjEzMWhXRWRTaHNMME1jTkxxNGFTYm1XallPNnMvUXN6Z2l1?=
 =?utf-8?B?TS9FcGZjOHFjREZQQ01ueVFYYkJHME0yaUJJMnhKazAyOTBhaWFCYitQYmQ1?=
 =?utf-8?B?YmhKTjBOamFQVmNLVTBvb2drN0VBNVJaNG4zMjZxWVFUSmZUNk1UOFJoSFhk?=
 =?utf-8?B?NFk1RWppWVEvcEFOUm5NY21xYlVXSndaWHY2S0FuQ0NaTkNFdjcyNTFadExx?=
 =?utf-8?B?cUVRUFlqd2Q5M3U2d3RnOXMrUFpra3NWQzhvN0RsQWFsSi9odlJBWTMxZm1k?=
 =?utf-8?B?SW5DbGU4T1FTczFLYXBoK054Szl6UFdyQ3FIR28vOVZCNU91WDlZajMvU21Z?=
 =?utf-8?B?MTJWRmVsbzlMM2VRRTBXRFVISmN4RXdQMy9UTzFydTFtS3V5aXRxVHRtVWlR?=
 =?utf-8?B?VXdOMWFCMVUwbUh1cC9ySWt1eUNjbWd1Y2lOTGZYaUxaaU5ZZUxWSXU1WW91?=
 =?utf-8?B?c1RIc2VYV3Y4YzlCTnZmNmpDTWdLNEpVR0hQd0FMMS9ydVo4eHVoRHV2TjNq?=
 =?utf-8?B?QTFvYlY3YTJ4bUVDdjFrWTdnQXFxdVpNcUhqbWszcVZnTUJHLzhNdGttbjRY?=
 =?utf-8?B?N25ZM3Y4Z1NGSTNiYWUrSUs4MVNBWjBrZi95UnloTnVqUktsMFNSTUY1S0xS?=
 =?utf-8?B?SmlTeEJXNVR6OVhOUVFSRCtkV1IrRFJKVW5wb0JqTzFVbzY5Y3lNQkRmRVlF?=
 =?utf-8?B?QkF6U2x1ZDBsZWhwMEFwc0ZDYkVjaG9ER1dwZVZ1SnFZSlhqeUI5WjI3ZitS?=
 =?utf-8?B?MnhQemo0S1NlaGJtOGUwWlUxS1pCMVJ1SVhNeFBQZ0JKR0ZIVnNtYkJxQ2RS?=
 =?utf-8?B?amMraE0yemJYbzd4cGlpckdnbHh5bTJMZEt6U25Cb3o5TU8yNnBTSFc1aTZX?=
 =?utf-8?B?ekRkMzRtanhxaGZsSE96NkNxRTdZeXVleTRmdFFBdW8zSDhRcEI1UHNtN0pW?=
 =?utf-8?B?UHB2eXp1TSt0RTE3Wm5WdnpwM0hlTFgvQjJuVnd3dURJMHpaRGxjZXVCb3dQ?=
 =?utf-8?B?MWVueEljTHhlZHJORVIrMHNBUG1wMXJlV0dNYzUwL2pMMnR4SEhNRFdkVFIx?=
 =?utf-8?B?RmNRMWFjQ3EzRTRNdEVaWG9jdVM5QUpYUHVuYncxMmgzWlQzSjdsZ2Mvak9j?=
 =?utf-8?B?d2FoVGFBdVAyV1pMR01ZVlM2OFV4WDlHekJLZTB3NjBuUXJkbVh2eE5YNDh4?=
 =?utf-8?B?djRjb01zTmZnWHUrbjJpejUvR0RHL3dFYWNkSUhoeEJ5MllxU0VZbG5CRlE4?=
 =?utf-8?B?c1Q0N3NRbVR6cis0c3o2UHRFRGd5UEcyaEloYnE3MFBVdDZTK01hT2hJa1I2?=
 =?utf-8?B?bnFCbjRXTVdXdUtTWTZhSFMvQ0pzejZTM1lueUZpbWZIQy9GVWY2SFdlbnFi?=
 =?utf-8?B?c0N0MUtPRjJVa0s4WldpY2JvbFErb1ZzMkV5WVRoQXZqazVULzFaYWM0RjdY?=
 =?utf-8?B?ZFBBTUFSU3F5bW00cHN1VS9kNFRTbE5RRTZXbmFDZkRKWVVSOVdTVnVab3kr?=
 =?utf-8?B?V2IyTnNXak13aUhKMmljc2lUOW1MNEVJaCs0akpFWCtuSkZrTHI3VW9uSWxG?=
 =?utf-8?B?b1Z2MW4yekF1MVcycXhMcGN5NVppbkJNVHNMR3ZiMXcyclppamJ1T0MxbEZz?=
 =?utf-8?B?bXhrWGRmWXlmRWhkcHlSSEFmV2pkaUJSNldtVWk4MFNJamJsMWs0WlRaTjhr?=
 =?utf-8?B?bW82SzBlUUFjU3ZndnNwdkRhWG5xQTh5WDVEZWErdE0wOFQ5NUxiSE52ejlL?=
 =?utf-8?B?YkUzVDE1YVRwNXg3WC84MUtlUnA4cXk0STlJdlBCWDVUUlN5QktLSER0MURG?=
 =?utf-8?B?WGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 84d44982-9806-4f10-84e8-08daa7ea24dc
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2022 22:28:51.3026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XWJTJMh3g+IdLZ1bCnNLw1/n2dzc11C0Nh6186wAf/qELDtdeHPEWggdqwS2snz79iguzngpm8kLYYsYXizpKDiUnl+xC0fqygxkkwqnrHY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7319
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/29/2022 4:58 AM, Jaron, MichalX wrote:
>> -----Original Message-----
>> From: Jakub Kicinski <kuba@kernel.org>
>> Sent: Wednesday, September 28, 2022 4:11 PM
>> To: Jaron, MichalX <michalx.jaron@intel.com>
>> Cc: Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
>> davem@davemloft.net; pabeni@redhat.com; edumazet@google.com;
>> netdev@vger.kernel.org; Maziarz, Kamil <kamil.maziarz@intel.com>; G,
>> GurucharanX <gurucharanx.g@intel.com>; Dziedziuch, SylwesterX
>> <sylwesterx.dziedziuch@intel.com>; Brandeburg, Jesse
>> <jesse.brandeburg@intel.com>
>> Subject: Re: [PATCH net 2/3] i40e: Fix not setting xps_cpus after reset
>>
>> On Wed, 28 Sep 2022 13:32:41 +0000 Jaron, MichalX wrote:
>>>> Not sure this is a fix, are there other drivers in the tree which do
>>>> this? In the drivers I work with IRQ mapping and XPS are just
>>>> seemingly randomly reset on reconfiguration changes. User space
>>>> needs to rerun its affinitization script after all changes it makes.
>>>>
>>>> Apart from the fact that I don't think this is a fix, if we were to
>>>> solve it we should shoot for a more generic solution and not
>>>> sprinkle all drivers with #ifdef CONFIG_XPS blocks :S
>>>
>>> XPS to CPUs maps are configured by i40e driver, based on active cpus,
>>> after initialization or after drivers reset with reinit (i.e. when
>>> queues count changes). User may want to leave this mapping or set his
>>> own mapping by writing to xps_cpus file. In case when we do reset on
>>> our network interface without changing number of queues(when reinit is
>>> not true), i.e. by calling ethtool -t <interface>, in
>>> i40e_rebuild() those maps were cleared (set to 0) for every tx by
>>> netdev_set_num_tc(). After reset those maps were still set to 0
>>> despite that it was set by driver or by user and user was not informed
>>> about it.
>>
>> Set to 0 or reset to default (which I would hope is spread across the CPUs in
>> the same fashion as affinity hint)?
>>
> 
> Current driver behavior is that maps are cleared(set to 0) after every reset. Then they are reinitialized to default values when driver rebuild queues during reset i.e. the number of queues changed, number of VFs changed, XDP is turning on/off(we reset and rebuild rings) or fw lldp agent is turning on/off. Reinitialization is done by netif_set_xps_queue() from XPS API. In every other case of reset maps will remain cleared.
> 
> With this fix, when there is a reset without rebuilding queues, maps are restored to the same values as before reset.
> I changed commit message a bit to be more descriptive and changed one goto; as it was not correct. New version should be sent already to review.

Hi Jakub,

The version with updated commit message[1] is on Intel Wired LAN but I'm 
not sure whether your comment still stands or if this is ok after the 
explanation/updated message.

Thanks,
Tony

[1] 
https://lore.kernel.org/intel-wired-lan/20221005132209.3599781-1-kamil.maziarz@intel.com/
