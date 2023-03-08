Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0776D6B0978
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 14:38:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjCHNid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 08:38:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbjCHNiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 08:38:03 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33EEA4A1D2;
        Wed,  8 Mar 2023 05:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678282580; x=1709818580;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mGPhLu/JL7rK0IxqdvNuHDu0xBrabG+hQpH9Rd6HMzY=;
  b=kZ0i77jydwUiJpBqJC8t6XfZRNaDxonS0BBPdwFM6G7+gmRlpcZzQgT9
   372Pj2rdihX++co8E30H6NU/NgDgV+DX6nrYB+WexS7tkApdmXCZPZrA+
   bE76H+dmDqJBKghf9VA/BLYp/+SfSkVU1jDr0SqJaYGmRF9hKG39bfV7t
   Ko54LVVS2B6hdy6m0iZGnunbIJzmF2CP08IeW8chQpRoDdpTwzh+JyPta
   o0Vyf1UiqwN5afCVQHSpu4xraJYTYK8ao4USdzqWB3SI7wWVUMTCRBlRA
   5d7rUVsQnlfbTpvD6E5cLMICXjQIWCZXPZe/ZbCn8tS3qt/S5ZM5VW2WP
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="422420642"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="422420642"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 05:35:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="709425796"
X-IronPort-AV: E=Sophos;i="5.98,244,1673942400"; 
   d="scan'208";a="709425796"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 08 Mar 2023 05:35:33 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 8 Mar 2023 05:35:33 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 8 Mar 2023 05:35:33 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 8 Mar 2023 05:35:33 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 8 Mar 2023 05:35:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kRubHg5tYmQa2V6x515knjJYhkRIAUx0tEgJW4S2uFuesE3jK0hgISnGoMohw1h+Q6xBZ/LYGcz92EQzXzgmdEHFcVn6Bf8x5ZHwTV52A9zR4rjUBU1YKbheI5nJ5B70DpmbP39F8WdmjOOjWufN1QPxR+15Oc2gS6JkLhV+ep6d4nUGPdqvbYkSh3/rbnciSN2F5hLGO05Rap7kdPMMrwf49muVnc8fXWhL0x1GzcUJyOVBP8i3lVi6ia5MX12fLFVihTkSJ0v24dqw1DyJ4J/V0gh0Y16+BMyd/4WnV0DP0UIK14LQw9+CHGM1NxQ0Afj1q16H9CkbBqe6P2YkyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZpideUtdrqwf0YkwYZHT9ArigLGvmW/u21pkpj1IQlc=;
 b=MX2joocRe1Nvcg6gMlTKxwMWHGMOs4txNme6CtOYmtRVYaMg6JyTZaDQROw6HcTa1auUFNgAxsZIB2tXIPfzMsYE7inykhagkYIiG4fT8R7zPg0qFRebYgbQVLYc3g6Z6fLgZFBU7XS+e+lCZoqpqr2q7uRzmpSEFJC+EiueHT1WA3R4q8zckoaRFP7/ZwfcoQry4/LHh5WkGQLA2xlUtmXoT8pm7KJIvaRn5IdIO7Unmzz9eZdVZVUgInYpdKqqZWaDCHQrQEJNtz/lhzw1ktnR07NYX+ajUjG9CwsWvJlLBTqVyeSxcM0+d+LsBJgC98apR1/VP4lxPVEBBD1kpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH7PR11MB7097.namprd11.prod.outlook.com (2603:10b6:510:20c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 13:35:25 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::7911:de29:ded:224%5]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 13:35:25 +0000
Message-ID: <531bac44-23ba-d4f3-f350-8146b6fb063a@intel.com>
Date:   Wed, 8 Mar 2023 14:34:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH RESEND net-next v4 0/4] net/mlx5e: Add GBP VxLAN HW
 offload support
Content-Language: en-US
To:     Gavin Li <gavinl@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>
References: <20230306030302.224414-1-gavinl@nvidia.com>
 <d086da44-5027-4b43-bd04-29e030e7eac7@intel.com>
 <1abaf06a-83fb-8865-4a6e-c6a806cce421@nvidia.com>
 <7612377e-1dd0-1350-feb3-3a737710c261@intel.com>
 <3ed82f97-3f92-8f61-d297-8162aaf823c6@nvidia.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <3ed82f97-3f92-8f61-d297-8162aaf823c6@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DB7PR02CA0006.eurprd02.prod.outlook.com
 (2603:10a6:10:52::19) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH7PR11MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c808cfa-975f-4c87-c155-08db1fd9f962
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rtKlC7BPNImjMn1zAt3W5r6QYLYfaCvAG1S3X8yS2XrjPW876xIGJFlh9BP/2rlDKq7hpj7BWhdqS2kCGnwVF6U5PzradcmAeXYliSs/HlIwYJR65xSKjEAWr+mwYLLEpuCyhBE062KqPjiD4oOqPsDhklmJPmA1paZ/o8VjANwLzYNbMFMjW33XqzqAHatsse4ylO8ViSr2f7KYUhrytOGRPLK3Gdg+NdIBY4FEJvC3oaqSPn4wtBus2jf6z5p4Sbr6/DsbvsCA5hFLlwu5bZTZ8reeQ+G0zwq0HaHLLcdYyhLkJ8O+yN0wu65HwPYgdljiNJB6P1AxmmkUgQlllhMXIuxMDSCS80g7hdrAfbPB3R/etsLdUEbW4BJCQczf/qsJR9ZErbUomsvqRBFWhIH1aCDFJFXKKoR8XumWPOgsRK7S/IgC06luz8JwTwWztgPzTpOXXbdk2pknJFkBxSstam5MtS2dDNoo24S5VuODokDU/CWvRvw6LJfBJpg0mvVZBpy42CsbCLE7DzAuzw07kCGDuSj/5DZ9VfsEHJoSPkmKfO7zvqvPHJKA4vzxY8Acj3GyyOPtt0kuwGZ8tWA5LmxJCjX84ED/Rm/1zuTr0qlKxQgorfcQD6Gu91xzQOJgJtSl3v0vtRFvfe3GJ+TvUDNTL0jERog2pdJ4XX9DgK3R0Dj37QgkI3p68ZTiZqNLyN7bLBsNAPCOMGUwnaaM4l2YphA1sRmkNbTC7/GoswFOdP3E1i1mFGJ02o//PRjyxO4aamD+NFZCzfGUsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(366004)(396003)(136003)(39860400002)(451199018)(36756003)(6486002)(38100700002)(82960400001)(26005)(2616005)(53546011)(966005)(6506007)(83380400001)(186003)(41300700001)(66556008)(8676002)(4326008)(66476007)(2906002)(66946007)(8936002)(5660300002)(7416002)(316002)(110136005)(478600001)(86362001)(31696002)(6512007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHhYNTRMcG1adTFWcXJudU91eGMvYkJtU01LV0FnV1hFdWMwKzBOWlpLaDJz?=
 =?utf-8?B?eXJYdjBEc3BqTzd6TFhLb3pSdGlGcHFydklTZFBDc3VzS3VVVU55YWx6Z0wz?=
 =?utf-8?B?V1FuL0JZUzVmYkpMOEloZjJ5WXYwTTNwdEcyZk1xV0dwRUxUaVdIdm9CYysr?=
 =?utf-8?B?R2plUFJuSVR4YXRuZU93Q2RFNUZhVDUzckNmbE9ISjZ2cHpZN056OVUyUUNJ?=
 =?utf-8?B?ZytDMStTM0swU05sKzA0NCtFQ1B1ZFEydkZiNEcwQkdJZ2tqanVPZE9mcHdB?=
 =?utf-8?B?cnJQY0F6LzEzT1V0V2k2TlVzTC82Qys4dTF5RHhhaVBjaXNzU2NoRUJydG84?=
 =?utf-8?B?YURyVzlSeDZMWklQS3NLdzgxQW44K0FOclhIbGtTMDd0Wkk5SHYzd0JxMUhR?=
 =?utf-8?B?UFJkVWFPT3J3dHRUenhOZmhQOVZRZ214NSsxRGpHVFVYeCtxd2R0UTNKeVFx?=
 =?utf-8?B?RVhQL0t6dUZibVJEQ05RZHEyS3NER3NUQzk2bUZyejdrT0FaZStFeklnMWlu?=
 =?utf-8?B?bFgyejg5cE9iZWEyYlJHa0JLRzZvN0RUU1pDSUNQS2IrK0g1d01QeU5hcXN1?=
 =?utf-8?B?WTkvdDkxNS9hUm53YnUzaWFBbG9RcEJoRnNnY29IenRjV3grM2VtOUZodklq?=
 =?utf-8?B?eGx1c1JuOWNESlI0MStCc1d4am9MY2Q0STRRbWgrQW1Gd0JGRHhWaHZjQS9M?=
 =?utf-8?B?ekZEZGtLSzFMMzFSUnk1U28wSnB6UTJWOWFxd2U3MFM4M2JVN1IweXowRzVa?=
 =?utf-8?B?VUYxQkNJZDV2YUMzM2VhMURhclo5bFVqREYzUzVkQko1K2ZETTVtZmVLM2JO?=
 =?utf-8?B?YmZDYXR6VkZSZlJxdTRyTWZXTm95cGFDS0ZadWRTVEtUT3hDd2JLdnFKSG41?=
 =?utf-8?B?bHo1L3IvSGd6MlY1UU9XK2RXMnZuQTY5MlZzVGg1VEUzbHBEOVM5ZTFjNzNI?=
 =?utf-8?B?Q1A3SDJSekxPR3lnYTFNRjlaeTRuYk1pRGlnUGl2VVIvb1BBait4UHZTMmFB?=
 =?utf-8?B?OTFsRGd6d1RZK1o5ZklnRzlKYW9ZZGh1R0FaV0xZWGRSUTdFZ05vdWIrakxP?=
 =?utf-8?B?T1UrTHhpOFREN2FyNlNOWnpIbFNoUmZ1OUxxOWcxUnFEbnlJQVE5NkFXcHFC?=
 =?utf-8?B?cXM5WDh0Q09DaHo4WkdPM0FOSnVScEx5cTlsS2RXbC9reHRqY3RsL210T3FR?=
 =?utf-8?B?MjA3TythM2EwaTNHbkRraVltOW5uSngxY25YQXZ3RUgwS1lCNFNpSmFrZXp6?=
 =?utf-8?B?NzB6RmUrRnh2YjdndnhSZDA5Wm4zQ0JPTUVWb1RXTmtTQkp0L3BEcG1WdnRY?=
 =?utf-8?B?dlR2QTE0NnZHaGJReVpSd2xWNlNZZnVjMkN5Ykl3WkY3dFFLS0QyV0JyK2gv?=
 =?utf-8?B?L25rajdWYWUzVENVdnJLUDdiQkNWMlJjWFRESTA4N1FVMEZkTHRaZXVhaSs3?=
 =?utf-8?B?NzZOd2dLS0s3M2pLSlpERWxSV3YvT2NaVnRXME5vM0tGVUsydFYvSUZ2NS9r?=
 =?utf-8?B?WHJsN3pMMmVkeDVKM2FreWYvcUk5WHV1dVNHeEgzeTJCOVNWQUNtbHJyV0Iw?=
 =?utf-8?B?Tk5lTVMwQlJZcExoRmgra25mN090YjFodkQ4NmxEWHRiYnhocEFQcUZGMEZa?=
 =?utf-8?B?SnIwd2p1SFVVVzFsemppVllycXlMTUlOTXdKaFlMb2swTDNHZ2ZVcjhEYUpO?=
 =?utf-8?B?VWRib0xGb2poZ3VabFNrUlV0Z0NDWGtXSTlPakRnSmsvVzNvV2hWWVBQclhG?=
 =?utf-8?B?dFlmVTcwNFZueHcrU05wNXJEVnJuSWxLL0RsTXpRQ1ozdGE1TkJCdEszaThY?=
 =?utf-8?B?MDhLM0x5MEcxY08zSENMOXEwU0xQaXF0TU5GY3pSRjRxemtIY2k2MUhIR3Jw?=
 =?utf-8?B?QTB5U0d0TStaODg1L3JaeDVRWWRnVXB5S0M1d3AzTWJCMnNycjNFMGdZL0M1?=
 =?utf-8?B?NCtNaXB3ZXF3bmhDbStNYkhWZHc5d2UvUXVCNGhWaVMwLzdiUWFDc2ViRkFC?=
 =?utf-8?B?MVMwQXlBZXA3akczenE1dnd4VCtjVWh3Lzc1MlJGem56eXNtT0dNb0N5TUwr?=
 =?utf-8?B?b01mRHFXTXNJeUJLZnNGa3pWV0RkUzRLZXdVRkFxeGt4TmdTb1pUWkR0MUFi?=
 =?utf-8?B?akZFTmdwV1I2T1prSVF1b3Q2bEdZdUJPRWZ1TFMwMGNPSkZ5VWkyRGRpd3dO?=
 =?utf-8?Q?Jnw/1pka2NgJN9/xuRwP7vk=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c808cfa-975f-4c87-c155-08db1fd9f962
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 13:35:25.6982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FYOGHzjpEU783XnW3fABSjerka93+mEOdzh2pmao3/ZV2PBlk+h+4J3xGus8xKt95RkY/KF/zkOxLyPvefUUr+nGNZk3ykN6Zr/vTS6c6T4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7097
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gavin Li <gavinl@nvidia.com>
Date: Wed, 8 Mar 2023 10:22:36 +0800

> 
> On 3/8/2023 12:58 AM, Alexander Lobakin wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> From: Gavin Li <gavinl@nvidia.com>
>> Date: Tue, 7 Mar 2023 17:19:35 +0800
>>
>>> On 3/6/2023 10:47 PM, Alexander Lobakin wrote:
>>>> External email: Use caution opening links or attachments
>>>>
>>>>
>>>> From: Gavin Li <gavinl@nvidia.com>
>>>> Date: Mon, 6 Mar 2023 05:02:58 +0200
>>>>
>>>>> Patch-1: Remove unused argument from functions.
>>>>> Patch-2: Expose helper function vxlan_build_gbp_hdr.
>>>>> Patch-3: Add helper function for encap_info_equal for tunnels with
>>>>> options.
>>>>> Patch-4: Add HW offloading support for TC flows with VxLAN GBP
>>>>> encap/decap
>>>>>           in mlx ethernet driver.
>>>>>
>>>>> Gavin Li (4):
>>>>>     vxlan: Remove unused argument from vxlan_build_gbp_hdr( ) and
>>>>>       vxlan_build_gpe_hdr( )
>>>>> ---
>>>>> changelog:
>>>>> v2->v3
>>>>> - Addressed comments from Paolo Abeni
>>>>> - Add new patch
>>>>> ---
>>>>>     vxlan: Expose helper vxlan_build_gbp_hdr
>>>>> ---
>>>>> changelog:
>>>>> v1->v2
>>>>> - Addressed comments from Alexander Lobakin
>>>>> - Use const to annotate read-only the pointer parameter
>>>>> ---
>>>>>     net/mlx5e: Add helper for encap_info_equal for tunnels with
>>>>> options
>>>>> ---
>>>>> changelog:
>>>>> v3->v4
>>>>> - Addressed comments from Alexander Lobakin
>>>>> - Fix vertical alignment issue
>>>>> v1->v2
>>>>> - Addressed comments from Alexander Lobakin
>>>>> - Replace confusing pointer arithmetic with function call
>>>>> - Use boolean operator NOT to check if the function return value is
>>>>> not zero
>>>>> ---
>>>>>     net/mlx5e: TC, Add support for VxLAN GBP encap/decap flows offload
>>>>> ---
>>>>> changelog:
>>>>> v3->v4
>>>>> - Addressed comments from Simon Horman
>>>>> - Using cast in place instead of changing API
>>>> I don't remember me acking this. The last thing I said is that in order
>>>> to avoid cast-aways you need to use _Generic(). 2 times. IIRC you said
>>>> "Ack" and that was the last message in that thread.
>>>> Now this. Without me in CCs, so I noticed it accidentally.
>>>> ???
>>> Not asked by you but you said you were OK if I used cast-aways. So I did
>>> the
>>>
>>> change in V3 and reverted back to using cast-away in V4.
>> My last reply was[0]:
>>
>> "
>> You wouldn't need to W/A it each time in each driver, just do it once in
>> the inline itself.
>> I did it once in __skb_header_pointer()[0] to be able to pass data
>> pointer as const to optimize code a bit and point out explicitly that
>> the function doesn't modify the packet anyhow, don't see any reason to
>> not do the same here.
>> Or, as I said, you can use macros + __builtin_choose_expr() or _Generic.
>> container_of_const() uses the latter[1]. A __builtin_choose_expr()
>> variant could rely on the __same_type() macro to check whether the
>> pointer passed from the driver const or not.
>>
>> [...]
>>
>> [0]
>> https://elixir.bootlin.com/linux/v6.2-rc8/source/include/linux/skbuff.h#L3992
>> [1]
>> https://elixir.bootlin.com/linux/v6.2-rc8/source/include/linux/container_of.h#L33
>> "
>>
>> Where did I say here I'm fine with W/As in the drivers? I mentioned two
>> options: cast-away in THE GENERIC INLINE, not the driver, or, more
>> preferred, following the way of container_of_const().
>> Then your reply[1]:
>>
>> "ACK"
>>
>> What did you ack then if you picked neither of those 2 options?
> 
> I had fixed it with "cast-away in THE GENERIC INLINE" in V3 and got
> comments and concern
> 
> from Simon Horman. So, it was reverted.
> 
> "But I really do wonder if this patch masks rather than fixes the
> problem."----From Simon.
> 
> I thought you were OK to revert the changes based on the reply.

No I wasn't.
Yes, it masks, because you need to return either const or non-const
depending on the input pointer qualifier. container_of_const(), telling
this 4th time.

> 
> From my understanding, the function always return a non-const pointer
> regardless the type of the
> 
>  input one, which is slightly different from your examples.

See above.

> 
> Any comments, Simon?
> 
> If both or you are OK with option #1, I'll follow.
> 
>>>>> v2->v3
>>>>> - Addressed comments from Alexander Lobakin
>>>>> - Remove the WA by casting away
>>>>> v1->v2
>>>>> - Addressed comments from Alexander Lobakin
>>>>> - Add a separate pair of braces around bitops
>>>>> - Remove the WA by casting away
>>>>> - Fit all log messages into one line
>>>>> - Use NL_SET_ERR_MSG_FMT_MOD to print the invalid value on error
>>>>> ---
>>>>>
>>>>>    .../ethernet/mellanox/mlx5/core/en/tc_tun.h   |  3 +
>>>>>    .../mellanox/mlx5/core/en/tc_tun_encap.c      | 32 ++++++++
>>>>>    .../mellanox/mlx5/core/en/tc_tun_geneve.c     | 24 +-----
>>>>>    .../mellanox/mlx5/core/en/tc_tun_vxlan.c      | 76
>>>>> ++++++++++++++++++-
>>>>>    drivers/net/vxlan/vxlan_core.c                | 27 +------
>>>>>    include/linux/mlx5/device.h                   |  6 ++
>>>>>    include/linux/mlx5/mlx5_ifc.h                 | 13 +++-
>>>>>    include/net/vxlan.h                           | 19 +++++
>>>>>    8 files changed, 149 insertions(+), 51 deletions(-)
>>>>>
>>>> Thanks,
>>>> Olek
>> [0]
>> https://lore.kernel.org/netdev/aefe00f0-2a15-9a43-2451-6d01e74cc48a@intel.com
>> [1]
>> https://lore.kernel.org/netdev/ca729a48-35a1-ef05-59d3-ef1539003051@nvidia.com
>>
>> Thanks,
>> Olek

Thanks,
Olek
