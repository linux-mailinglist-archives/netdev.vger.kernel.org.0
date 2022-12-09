Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8A7A648AAF
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 23:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiLIWRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 17:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbiLIWRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 17:17:38 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5BFFCA
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 14:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670624257; x=1702160257;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=i+dQgWBPHhuJp6XWiqqM6L8AYazK0Lpy4T0ymRildQQ=;
  b=kOQTHHmY9r0drSvkNz48GOL+9MiJ3ZAU5mFYMfohtud2yFNyvxf6vbhI
   rGWBsXEeyFhCggJdGtjodSTKew51oP7t1kcgI0RWqjvH4iQUKYxDZtyaX
   uXnX5TJXbq3q3iUA4TW4zDzHalJydVV0+/KiLus4ooGv5RB3A5UDgadZa
   bcQ13nQzXHxHEP1NAUq0fdslS6bZlLVnAxe2N3eyHFk9tqoSncbpB6GY6
   cHvg0E1UGAenZ6i94Ee/OPltL/g9ToEpf5Pd78vffwGaNvnIOfK3Y1KOZ
   f3F+4hvYCd8Sp64r2H5/v8jXm8RTTd916fGr3gN7qmiXs8ZMgOqJZi3JL
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="300980132"
X-IronPort-AV: E=Sophos;i="5.96,232,1665471600"; 
   d="scan'208";a="300980132"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 14:17:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="680063287"
X-IronPort-AV: E=Sophos;i="5.96,232,1665471600"; 
   d="scan'208";a="680063287"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 09 Dec 2022 14:17:36 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 9 Dec 2022 14:17:36 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 9 Dec 2022 14:17:36 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 9 Dec 2022 14:17:36 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 9 Dec 2022 14:17:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AaTelZSDjiyt1GxLXjHPiTzp5SGcii8gSAdqMZWEm4QfI559zhNa9DTJnaADnA7iubdvprsUJ8zf9DIjwzViUmQYx791LwoZaYgzGuYwPRkwWmWYye0D6cNyBra3Yd1utmAMRI1rgF/CoHyrE633cTU37B7eH7Hsuk9kK/V2DLvLX1Em7c+gHvQyPWUgVk4FzeEGmnFiwfNpegA8OeEqPvC8CC3cRhn0cyD+CiPbm4bugqKeIUISFTnjk3i1ngi5zelMRM6sAzhWskWaR5RzV5cnFnqNCgDfddWwfK6WK64d3SNqP0AJKuLY25Zhp5PWxB6hKhKv6YRsW6bMUFjgeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R6yiy6yB78Lz84+XLivny8IZ8xTVJoqATNFPcL3F7MY=;
 b=L4C/jv8yOdAy3NZi//XlaJ4hs/kevKGWzsrL8xgAqh1oYXVoTXy34mEqsWTew3Xps5Qgc/6HsW0lNfUPjjF2IpL3bvedBH2e90mpjpeWLgwj9i2TVAIK9DFBtOf1w5A8GQyPmFpmFG9tHTMZMJ4xsU9JGA6bUWize2NYdEw0G5Rox6iPSDSgEQcxhUBfLe7r8bjOifAKtcDHz/B6tHxCidYgaWaa/OMsdKqufyfOUCOnV3FsPOsUx/fb/oD4SiQTu6Twj9ShqiovH/UY3YaeXMGw8R4CY50kh249XI4EHsWk7HQ4j5wTioU3og0NYNFo2WgJM441Y+Fs3vquAck7FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by CH0PR11MB5562.namprd11.prod.outlook.com (2603:10b6:610:d5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 22:17:33 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc%4]) with mapi id 15.20.5880.016; Fri, 9 Dec 2022
 22:17:33 +0000
Message-ID: <e51d68f9-e7b2-39d7-154e-f508615b50d0@intel.com>
Date:   Fri, 9 Dec 2022 14:17:31 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net-next v1 1/2] ethtool/uapi: use BIT for bit-shifts
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <mkubecek@suse.cz>
References: <20221207231728.2331166-1-jesse.brandeburg@intel.com>
 <20221207231728.2331166-2-jesse.brandeburg@intel.com>
 <20221207184105.74dfdd1c@kernel.org>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20221207184105.74dfdd1c@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:a03:254::21) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|CH0PR11MB5562:EE_
X-MS-Office365-Filtering-Correlation-Id: dc290020-f947-4dfc-06b0-08dada332b7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8lAYvQp8IUE3TbXXPjKY+dJlM8xauiFpsDNvgqO6o54MoNEdknL382OdGqRw9lJBgUwgODncjK+v8lE7LWPqyeswxDASgGWx1o0lJOMFIhgbPWqM1aH9NzhJH/Tjk9DxfXQJi3kVeioC0clhMoQ1fjaZHhln33JyuVOC06EGTCaSEz7fl4LUUhklqoZwRS/XGJkmbvoJcY5i5vGA4qti9tb6vJinJvS8qGoR77nd4z62WJbX7iPbE68Guti80pBna/Ai/4+4i43UYOOs2RmpY3haXWoBr4mhUqwK0nlFSdMgQ27szsZhAXzKE8ipAu8CLhhvScY22FOAqmUistCgaJISjDMwebycu5YcAa3m1SqkRq6/f4iZvFdC6cmD94Ud7wDulQH78yk5iQbrr8nufW3rbfP3985wURVlBUor7hGJ1kcBPHh6Q5iOdxEHcuCRReGabV7dn8sA4DDaUn/nqA7iDfuTniEF4sPNSYDZYm7ZcEhnuyu41pcxGnwmLFdkQtCDD3AQH/15e+zPk6hbKbaUuoHoYytN7VFW0x0AGRCi3Yzd9sVgkFUK6lIMxPPaD+Ii4C4qcUK2YRngnZSo76xiAMuV2jqbRCOJhdK3UyIiE+oRqJDxOi7dr+ygvigMk4iC++XvpGidnb3qpsVYUfkhAV3kskF7/9JwTfeIU/rxv5fo5O5nPFo6mxmWoq5Q9U+i7yIuubFFl7gIZsuAEHV4+Mr8vxGB31AceW1K2YU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(376002)(366004)(136003)(346002)(451199015)(31686004)(44832011)(5660300002)(2906002)(41300700001)(478600001)(6512007)(186003)(26005)(66946007)(66476007)(36756003)(8936002)(66556008)(8676002)(4326008)(31696002)(316002)(6916009)(2616005)(82960400001)(6486002)(86362001)(38100700002)(6506007)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bkZHUHU3aWJlaFlDQlNFcmZ2ck5US1JzOXBoOHd5SzNOaUYxbmVkZzJtalZr?=
 =?utf-8?B?dVNzS2E1b0xDcjhOWkRaZmo1eXRTQ2UyMWRzSURSek5uUnJsMVk4U2p0V2lS?=
 =?utf-8?B?Y0V6bXp1ZFdmVzgzQzhxN3B0K0dXRmVCWDlaYTNrc0s2TExNdjQrRTZsdHk3?=
 =?utf-8?B?UWdiSEU1ajUxcDRjL2RnanBpcm0xZktLTE0zNmZpa3cxODllNFptOFFZNFhH?=
 =?utf-8?B?YnZkcG9qS29MMkMrTytXNjNxZ25hMnArcCtFL0dMTEtmU3AzaXg5aUMwc3NQ?=
 =?utf-8?B?RmF3QUxOS0xycVZlRlJEbDFYUUtQdmdIWmRnRE9XdkxvQmE5M3ZIRVJSRGFa?=
 =?utf-8?B?TDRMWG5lQXBqOElkUzJSc0wrdG9PRUxQRnpRQ1JDMTduUitxbm5Yc3VrTlBH?=
 =?utf-8?B?NGlWRFA2S3g5Qk9IYjhaK2VINkorY3ZBbE13UTJ6R3QwTUhFdHRhOWdIeDNx?=
 =?utf-8?B?ZnRrYVd1aWdOUTJGQlNWKyt1MEdsK0ROSWxnNzg0ZXpEL2wyako1cnJ6NGFL?=
 =?utf-8?B?Rjl4aTFXNkRuTG9IdkJVZG4waDFIOTRZdU1UUEZ5T0NKSUJ0RWV2cjZCTFNo?=
 =?utf-8?B?ZERPdzBLYTdpcnhSWWl3ODdRcjM1aEpIcGMrOC9UdmhkT3FiaWZFTGNZVmdp?=
 =?utf-8?B?Q3hSQkFjVlFZbkRKOVZ3eFhXS01PNEZOSjhuSFZYVGRXdVY1T1lQbEQxN1F0?=
 =?utf-8?B?ZGdvalVmTTZYSGVrb293Z3JzcmtxUUgyVVd6emZCdTVBQUJNTUZkb1lUbDRr?=
 =?utf-8?B?U0FINmhxWFBEaGhYVjZaY09ZSmk5TXhuUEJ3NkJQd0ZZMDByeldwNzQ2aTNO?=
 =?utf-8?B?c084NDZBcUZyZ0Jac29WZVlYRWtZZ3U1enQ5Z1ZIN2Y1bW5tTGgrc1JIWjA4?=
 =?utf-8?B?cElJQ1RnVkpqYWVObVE3Z1hDS1RMaTZwMmRGc0F2bTFYTkFBc0RWTHNPdCtl?=
 =?utf-8?B?WjdUOTBjRVFxL0dxa0k4c0cyeE5iRW5paGRPUkJmSGpNT1NmeXhJRkNtYUY2?=
 =?utf-8?B?QkJIckx3dm1Hck1WV240K1hxdVp5QWlUbEFzMnRMaDQ0VjNrcGdjQnhnQ0l2?=
 =?utf-8?B?V1hnOUdHeWJuMHd1MmZxSy9QWkpYU2Vpa3pwdlNqL0pKSFZPYUIycndNU0lw?=
 =?utf-8?B?c3NvSmVBR0FtdTBVQ2JvWjd5TWt4ZGZ1VThoODkwVkx3dzZoRFZ2Y3ZuTisz?=
 =?utf-8?B?VGlNQlFoWXZzYXk3Q0p0TWI5RTJ3MmtTSFhHNkpWTDZrd3FqRVZUODcyc3RL?=
 =?utf-8?B?TG9YWHJKUFBlMlVIaGZkdDBWNWpCenM1STdWTW9VSnIvelJ6bktGMnJNR3Rn?=
 =?utf-8?B?S29ZMTJoY0JvSktVbDJ2KzFZanZ6OXRHSHJTNkJvTXRvV2lpRFptb3J5OVcr?=
 =?utf-8?B?ZVJ5SlVFNnRXSml2NkNReUZDTkFGSVJBYlZQYkhqWDhxczZWYTlIUGdvZWMw?=
 =?utf-8?B?Mm5XQ244Y2UrQmNGRXlKMHdVVi9lTHhGK01CQ1pid2lzVm9GaTNaZzJtYWpx?=
 =?utf-8?B?eU5YMUxicE0vajk1UVd0YXNSQnlUb05MaVJrVDhYaG4ydisyNHptekVtUHR4?=
 =?utf-8?B?SnN1TWlmaWE2dGpkNm01YWs2UTc1RGVvMUtpVWtMbHhoM0sySXk2bVViRHNk?=
 =?utf-8?B?TzJQWm92ZDNZbjdlS0YzcGJWbEZTMHF2allTcGJ5S2dKd1RoaXFHRmlCa0R5?=
 =?utf-8?B?NkkxTEFoV0twb3pDNnRNak9XRTJlYW51UlR6K0FaU2pSQ3dyT0N0eUh4UXFi?=
 =?utf-8?B?SUhva3VrMmRLVGNVQkdDa2xFVUVXRG9aVHhHMnFKT2M4QnVHcDRjQ3U0UjBh?=
 =?utf-8?B?dDVzRmhvT3lJQzJKSGJWN05JTjhhVnhiTlNqK0Y1MVdIS0xPa2JVWXFDeWxR?=
 =?utf-8?B?VkJBUS9jSGV6Q21CZ2NqbC9xTWVZZzEwSnI1dDlHZ3RsYlk5NFNLWFZCVnF2?=
 =?utf-8?B?ZEpiNjFOYjBaSzdTZ2lyRnNhb0xpek5rcjZ5TFQwaFlLRStVZ1BISTRvdDNl?=
 =?utf-8?B?c2pXbjlRTDZxVHZBQVB1eXFtZnd3dkNlYXpmSmRRWElrV25yeHUvWmFwUXRm?=
 =?utf-8?B?YjVra3JmcEZOUitGYzdOYUNPV3FLSlkwdXBOL2ZlZjAwTmo3TE1adTk3clN3?=
 =?utf-8?B?S2h2bGVnY1dkMzQ1RDJuMDE5Z2dLRzhUbnI4MUEraHZPMDFPNVRhUUxoZnBQ?=
 =?utf-8?B?c2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dc290020-f947-4dfc-06b0-08dada332b7f
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 22:17:33.5539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FJ5fNMs3ZOuDixZ/EhmgeMDOAG6uoNIkXq1qaRl3yL5OfkAvg/pj78Zi4T3NTyl8hHIXEMey3JtbCj24mAEbJLALLuOU64Ti0oIYOZRSkpk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5562
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/2022 6:41 PM, Jakub Kicinski wrote:
> On Wed,  7 Dec 2022 15:17:27 -0800 Jesse Brandeburg wrote:
>>   #define ETH_RSS_HASH_TOP	__ETH_RSS_HASH(TOP)
>> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
>> index 58e587ba0450..6ce5da444098 100644
>> --- a/include/uapi/linux/ethtool.h
>> +++ b/include/uapi/linux/ethtool.h
>> @@ -9,6 +9,7 @@
>>    *                                christopher.leech@intel.com,
>>    *                                scott.feldman@intel.com)
>>    * Portions Copyright (C) Sun Microsystems 2008
>> + * Portions Copyright (C) 2022 Intel Corporation
> 
> Is that appropriate?

I added it when I thought I had to make more changes. Since these 
changes are now minimal I'll remove it, thanks!

>> +#define BIT(nr)		(UL(1) << (nr))
>> +/* include/linux/bits.h */
>> +#define BIT_ULL(nr)	(ULL(1) << (nr))
> 
> include/uapi/linux/const.h

Wow, that was really not obvious that file was there, I searched all up 
and down for BIT() and BIT_ULL versions in the include/* and 
Documentation directory and totally missed that. I'll respin with the 
const.h versions! That file should really mention BIT or BIT_ULL in the 
comments so it would be caught by a grep!


