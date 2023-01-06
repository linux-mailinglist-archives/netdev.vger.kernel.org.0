Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA9A66052A
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234506AbjAFQ6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:58:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbjAFQ5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:57:49 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1793C78A7C
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 08:57:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673024269; x=1704560269;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0CxCHufS54/p2xR4qzylRpCJykRBKEIaL6tBRldZedA=;
  b=VmxLDY8JUkjWyfj9Xz0n+wWQgFTPC5PN+vesJx7Dp3A20cOL9Mi+yDNV
   hqJAkfhbGOMsnmM0w7WvWAT9VD6+6KmfHaiOakt47lCBpYl1QvNrSbbg9
   a2EVEVbzkR9iSiWi8CZR1NMVMKgYL0Dne+3urTEIj/LsMs621IEgJLFXG
   QJAoU/Kharg6LCH333T22AympHNomxKTsd5fqAGWydnX/yia9LzNLsiie
   SpWAjMBLTfWx1nifVPrnEB5gjrwH5RrS73+B8MOuqEGSmW1I4FTF/kmuu
   Rzso5VCsgr6yBkE8t2CRQz8cDW52m1alrdaqnRv4mEVFUtVTKTgmE8ed5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="323762353"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="323762353"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 08:57:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="744688237"
X-IronPort-AV: E=Sophos;i="5.96,305,1665471600"; 
   d="scan'208";a="744688237"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Jan 2023 08:57:47 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 08:57:47 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 08:57:46 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 6 Jan 2023 08:57:46 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 6 Jan 2023 08:57:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S5LoiqK1ijXe5TDwiH8qIpUk7AMdrmoL1T3MmZnrt6pJNVK0cay+M1Shp0Sr5JffXQcXgNhSKeARpV/A7ZYoidXqaz0R14cBk1/8LTTiRTUpOg/iiYG4FjJfiQzmTjK4XB6TWO8OuP58C5f5JECVq1qmkwkR1GCIcjW9KltR8Lq42aCXcF2umdAQvE2jpWQxtwAI+rcILSG0Z/iCG1BvvjNY6m8BnS0m0hmntHM1HENloodsaM+QwQpySVh3Y+mSqMBJAZ/qmaoVq39PZN/WfYehnrYl8HHRyS8FB0rCVdadI0nKLuhBIup+1ZpUBORGesQ5j/Y9bDc7U+J4wwGsuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qcaPgfgAaS0yIcKG/23J3IW4Sicipk90nwDNgusWdJw=;
 b=njjiGKbJx3naJUz/RBcJU0V18wXvXRIVNyRzw5qwNCBUSdTe61++cwG2t6sqyXU5VMZxWuxVi85jFsJil0TVcfWL2uRowbahlD2HvXqYBCEBhdx621EBa5QR5rhCwEW5utwTbBD+lrPuPoq50csSllat0bsbtxKYYhmakyHPiPKthjvh6PSyl8tS9Slu70Wzr8El4zI0eoapwT/XiALBo6U2kdxTYAd6Sk5EoDm1n9/w9AW+Dr5E2F+65zCED981gNLZmTAtGb9ap+GtTlYGNQZg0iFGReqCRypaAfExffwRdCnp5LCQdG3DD43IYZUqNc0bAbLQuY5NciTfvhQjnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM6PR11MB4579.namprd11.prod.outlook.com (2603:10b6:5:2ab::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 16:57:44 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::cfba:c3c6:5b80:cd9]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::cfba:c3c6:5b80:cd9%7]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 16:57:44 +0000
Message-ID: <29f9505c-2a9a-69fa-bae3-d95ee1113646@intel.com>
Date:   Fri, 6 Jan 2023 08:57:42 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v2 14/15] devlink: add by-instance dump infra
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>
References: <20230105040531.353563-1-kuba@kernel.org>
 <20230105040531.353563-15-kuba@kernel.org> <Y7aXXQUraJl6So2V@nanopsycho>
 <e460c958-625e-a7e7-6552-d3ce5334654f@intel.com>
 <Y7fi8tIYTlQp1PWo@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y7fi8tIYTlQp1PWo@nanopsycho>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0275.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::10) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM6PR11MB4579:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a921a6e-fe9b-49ab-c209-08daf0072194
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VqNA61PhYaujHt2BQdEqdv1J9eu/45G6c/+lHkhYF839qdkbwmmK17ZIhr4We0/WlldwDxA79tinShTFeyZlbCXTskiQB9Ej5KycOtS3ddH4gpyEs3qi/XxUaXA7e3F6bEl26tF/mbUZuqEfmq0ctCb90A3l8bu02DWwEkoJjYjjcE0zVJYXnNJHycnB2q+P909+f77inOkNCWhZLAG4K7djd44oFMEtxKG4tAYel7/eeQHFEYKebegZThzGNY2BQffUyJMFfODQtXHUXl+jrPP3m7dYZYtHbp2s/MIwqLgoR5QlEbOgIPxeglvSafjV5wGvZdIYa11EJF+2zEXhz1fv8M2DiZKzPFz4trkWl8KBidXpedkT4qoS7WmWsAfFuxo2BDxWzJqIziywX64cQMsmoUU2E8qcLH6oQL7zsghzX7OxMD7D+4/D7jGqvRskkA2AvFchDCCd7w5PtVvz52b7QBahvOrlMaJaJapxoueZ34UxQRlo+YttKQWNcFWkUXZN5mGdnQ6loFaAB8DShfmZo2FNIbtJIocfa6rQHL3PSGGg7qOwLQIyNttl4EtIRm7uem6RiHd2nzT8RF0dNGfKWtmlQGb94IA9ShfOuMtwwv3Rz9l3cbZ5ojNQCWgZsfoDRLhbLeBMJ0p3naitkujG/RicFbiXZGBnDXFInV11pP2m42AriR6BQeTFJM280tt47Dpq7O6CCN+BkrhqbWir2jlMfCAy+mDL7mj1zY8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199015)(53546011)(6486002)(186003)(6512007)(8936002)(83380400001)(26005)(478600001)(6506007)(31686004)(66556008)(6916009)(316002)(82960400001)(8676002)(36756003)(4326008)(2616005)(66476007)(41300700001)(66946007)(5660300002)(38100700002)(86362001)(31696002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bmVBRkQ4R3NBRGM2d1kyMTRnTzFHVzF0ZDI3MGNaV1k5Q3UwM0R5K3RSNnFo?=
 =?utf-8?B?MVYxN1E3dVJWWjlqbExwQzh5ajBNVjBXSC9zRXZWSTZnZFhrRGNmYmV6ZzZH?=
 =?utf-8?B?RytNQ3JvSFgvektaYitpNjBWS2dodUswbDVLQ25KOEw1ekZ5YmhqSzlqYzdk?=
 =?utf-8?B?REtNUmU0TU5yS2FBWmdCNjhqREowbzFNYnNVNEYxcUZrdmJ5SEtyMnBNTkN1?=
 =?utf-8?B?TlRoM0M5dEJCSytkWDhjeml5c1V1eTFEb2x3MGJhWjh2ZDg3TEYxblllQVB2?=
 =?utf-8?B?L24yTXY1TjRvVkJ3T09VaWZNQnpLc2FHWnBTRUI4dURwdTcyaW9NelF5L3Z1?=
 =?utf-8?B?OERwN2NmZ0tYMFF6eUV2UVR1cVk3dXA4dXBMWkpORG1rbmhyYmJhZkhaODYx?=
 =?utf-8?B?OFRxa3I3bm9xMGRqdE9Ic0E5WSt0OHo3QlZYUUdqVnEwQmlkZEtaSmhRRGFZ?=
 =?utf-8?B?Z1dzVDFEQTI4UlpLUmhIcUZPV2RRRnRIaXJKK1pTZXRua2RoRGpqQ2QxWHE5?=
 =?utf-8?B?MHZZaTJxallsSkZqdWVLb240bjQycDcyaG1jUm9LeWdaTnMrZlBrbXg3RHVs?=
 =?utf-8?B?b2g2SXI3QnB1OHJXV2JIS1RoSDBSYjBRNkdRZUpaTjg3NUVVU1A1Yzk5N21k?=
 =?utf-8?B?L3VFcEtJenFHa1pNUERqdkJBMGpiRlhSZHFEY3NKQURtTjU2czhjSnByd1ls?=
 =?utf-8?B?Q1lWNm8xZWNtWFk2TTdlTFM1WU5scHhxNDRQaGVnTnVuOWRtejlEVmo4a3Ux?=
 =?utf-8?B?UmowcXdZYmEyS0krUGtlRjZWTS9DSzBVbmVhRnlTd2NkMmhKeVlHb3U5ZVFj?=
 =?utf-8?B?NzFWTG9aZHpRTlZGU1hUa09mNzhaRHBGd2MxTGdlKzd6NW9DbXc4RG1VNklx?=
 =?utf-8?B?Wng3cEtVNWR5ekduWWlzbmNOb2ZZN1JMV2xXYjNIdHlkcHNPRnlRQnRLc3E2?=
 =?utf-8?B?VGJWb0ZISFFlQjZGTXNtakZ0S0k5NUVpalphK3pMYURKb1dqeW9sR29NaEhm?=
 =?utf-8?B?NmFNdEFxVmV2ajJwV2w3SnQ0NnRpU28zbTRhTEZqRm0yZzhzTGc4SjFwUGhr?=
 =?utf-8?B?dnRWOXZxVEhnRjNoejNHeDAyQWFaRFFRUERJNTFkOFVNSmY2Wm1CS01GSUJa?=
 =?utf-8?B?RFFNR3ZabUs0RWZTOHplejRqdHY4b0piZnZNMHhuUUQ4QnoyQ20rRjhnRjYx?=
 =?utf-8?B?STltV2Nxb2hQWCtXOUM1UWdtRkhPNGhVS0UvZmVtS2xlU0VZVGliNWMxMFlR?=
 =?utf-8?B?VXE4VFZYTjdqSHpBMysxNHA2R2tzdTc3NnVTOTlOL2xaMDc3bTJlekVLWk9y?=
 =?utf-8?B?MXAwQ0dURmVGVWxya2dXVTd3VlJpT092SmloL1Bzc0FsR0RzOHpFMzVPOWV3?=
 =?utf-8?B?WDQ3R0tFd3hrd24wd3lkdm1DdThpYUgvTHllVVozSEg2dTB4YnAvdEgzQWJL?=
 =?utf-8?B?VW0zQnNiV2l6SWRQYW1iSGNvRUprRW52MmF4aTFSdnlpR1RId2hFS3pSV3VW?=
 =?utf-8?B?bWx1bkEyVVJEdnIrdXZReVdLSVNyN21SbDdPVmh1cDY1R2NhbkROWmRWUkRm?=
 =?utf-8?B?d2Y0Wkp4L0pkaVA4MGtERVVHMCttL3hrSnRnZjJDdHpUend2TzYveTVXc1Iv?=
 =?utf-8?B?VitHOC8rOGtlYlN1cjdLMW1OREZMRC9COFZ4RlBEVDNiZStDaTFRY3ZydkVB?=
 =?utf-8?B?dmxURHpIcHdEZ3BFWitEdHd4QXA1eHg1MWV0a3hlSUhXaUVCRU1MNDhBL3k2?=
 =?utf-8?B?STUwSHdMOWpoNEFkcS90YWFsSnBFcTBMVkNyKzVHc1pYRHdiVUNDc2VGSDRU?=
 =?utf-8?B?RjZObnpDT3B3Q1lRK3cyQm1aU045WG1YdElyYktjLzJKbUNycnNCRE9RZEE1?=
 =?utf-8?B?K1k0MHdpWlVwVUVqZzV2UFhRZ0twYzM3d0R5aEVRdTdPdUpjcDYzb0FkMXcx?=
 =?utf-8?B?bjRlMVBuTG01KzFPK0hYY3JKRm5od09uUmVmK2JQbkdIZHlqakFYdFhMWW5m?=
 =?utf-8?B?T0RyV3VyMU1TTlhkRXc0WnhFd1Z5MkFDUENxL0dmbnhLdGY3NU9SL0Z4bHk3?=
 =?utf-8?B?ZGxuN0RnOW1aVUVzWFZhVnEzZlRaVURERmhBSnFtVTYrOTI0aE15djdobEpM?=
 =?utf-8?B?cDVTNWhrSDk0SjFpVENnMll0WTNBK0U0MExnd0pFOXpTcWlzU2NEeTNXL3F2?=
 =?utf-8?B?TlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a921a6e-fe9b-49ab-c209-08daf0072194
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 16:57:44.6743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8+hnbRab4lYRQouvgYr+Tk3I1bmknN7I+a1Q5GfBUiWk05L7mAAeA4pb5N749jvw3ghufp4jO69dwymR5z1sCT1TI2iOj0wJqIstvUSZRvs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4579
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/6/2023 12:59 AM, Jiri Pirko wrote:
> Fri, Jan 06, 2023 at 01:16:05AM CET, jacob.e.keller@intel.com wrote:
>>
>>
>> On 1/5/2023 1:24 AM, Jiri Pirko wrote:
>>> Thu, Jan 05, 2023 at 05:05:30AM CET, kuba@kernel.org wrote:
>>>> Most dumpit implementations walk the devlink instances.
>>>> This requires careful lock taking and reference dropping.
>>>> Factor the loop out and provide just a callback to handle
>>>> a single instance dump.
>>>>
>>>> Convert one user as an example, other users converted
>>>> in the next change.
>>>>
>>>> Slightly inspired by ethtool netlink code.
>>>>
>>>> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>>>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>>>> ---
>>>> net/devlink/devl_internal.h | 10 +++++++
>>>> net/devlink/leftover.c      | 55 ++++++++++++++++---------------------
>>>> net/devlink/netlink.c       | 34 +++++++++++++++++++++++
>>>> 3 files changed, 68 insertions(+), 31 deletions(-)
>>>>
>>>> diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
>>>> index 15149b0a68af..734553beccde 100644
>>>> --- a/net/devlink/devl_internal.h
>>>> +++ b/net/devlink/devl_internal.h
>>>> @@ -122,6 +122,11 @@ struct devlink_nl_dump_state {
>>>> 	};
>>>> };
>>>>
>>>> +struct devlink_gen_cmd {
>>>
>>> As I wrote in reply to v1, could this be "genl"?
>>>
>>
>> Except Kuba already said this wasn't about "generic netlink" but
>> "generic devlink command" vs "complicated command that can't use the new
> 
> Okay, that confuses me. What is supposed to be "generic devlink
> command"? I don't see anything "generic" about these.
> 


I read it as: "uses this new infrastructure for iteration" vs "does not
use it". I assume (but haven't double checked) that at least one command
still doesn't use this for some reason?

I don't know if there's a simpler name to get that across. I don't think
genl is helpful because devlink is always generic netlink.

maybe "devlink_iter_cmd"? but I dunno.

Thanks,
Jake
