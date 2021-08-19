Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241B03F12A5
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 07:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbhHSFEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 01:04:45 -0400
Received: from mail-mw2nam12on2052.outbound.protection.outlook.com ([40.107.244.52]:8128
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229451AbhHSFEm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 01:04:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QtCbH1ccZ/CKNMqKHYJrv9uZzsvuU7nKlhAv1mK6oSB1MnCpQQsbAvs4ZOaHggRHQ5yKNwG7ch0w+44I4w2nv8jPSfHmhlPE7ZDl3YPOXH+AhqAKeuWlYVG2rEMAlnREbzQ0tHeheL8R5wWZjW5R23k4ZVE1LzZQgQEI9I0BIVbtOYEUc4URafh6zE9StJzmr8bSGuv44DpqztLfrXKbcSOrq4kwG/ie72Hr4P4cRMgvnZdK0iJJAt3l16u+FAMK4Itm+AsnZg1h6kfUVkmh7qFMvOtvpff+fKfJFGm82lsGx7blpl/XLC9RbeKVlU720qK5FnDLlZBIg105oUCFeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pDiT9yeLnvcKQQ8BxhigiFU/5NnyCWVQK2mx67xBOLE=;
 b=Zr0St1QpDELQlvmK4bgWrwDogITjXc5Mlm0t73qUMMEGet16i+RQcQpn0PjiWYlQrzEfsyS/mpNpeHy/UlRh41EzokqXDx7W3QNk/zzqo6KaIgEFDYYCwpuIkLUqwxX547JkjQnNAFLP6nSjbx8HmVZ708yXGnVPBw2/9vTJrrvEbBWbXe02KQWcz4vsFYvXNSjGOinJ+iq9ddP84uatwGeXHoE0EZckrxII+u+SEdOY9/SHCLrRGwy6laFq/YUdpb6HZC6Vfm8o33TtnCY1AAfOv5Uku0AzcEatGqh7RGndt2v5s89T5EFmPpkKdPMcdIVZ8a60bfnk3V4a8x+i5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pDiT9yeLnvcKQQ8BxhigiFU/5NnyCWVQK2mx67xBOLE=;
 b=QqTqY04Bfd7s/kyhSiut4zRmerGUwg7O6mJOPQpZFvPzLKkSeMIbslo8PZGlo51bQOYXvGnXSwdCucRBoZZ6SkHGzWaDhelNP3PcbjfC9ST3ZtQhFp6O2cELqeeM5JOOMMZK6Pu96S0FlnLkr7K0k/Nb3U0HJEK1r4WP9mSgHKg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5349.namprd12.prod.outlook.com (2603:10b6:208:31f::7)
 by BL1PR12MB5286.namprd12.prod.outlook.com (2603:10b6:208:31d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 19 Aug
 2021 05:04:02 +0000
Received: from BL1PR12MB5349.namprd12.prod.outlook.com
 ([fe80::152:9dd3:45a4:eeb6]) by BL1PR12MB5349.namprd12.prod.outlook.com
 ([fe80::152:9dd3:45a4:eeb6%4]) with mapi id 15.20.4415.024; Thu, 19 Aug 2021
 05:04:02 +0000
Subject: Re: [PATCH v2 18/63] drm/amd/pm: Use struct_group() for memcpy()
 region
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Feifei Xu <Feifei.Xu@amd.com>, Likun Gao <Likun.Gao@amd.com>,
        Jiawei Gu <Jiawei.Gu@amd.com>, Evan Quan <evan.quan@amd.com>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Alex Deucher <alexander.deucher@amd.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        linux-hardening@vger.kernel.org
References: <20210818060533.3569517-1-keescook@chromium.org>
 <20210818060533.3569517-19-keescook@chromium.org>
 <753ef2d1-0f7e-c930-c095-ed86e1518395@amd.com>
 <202108181619.B603481527@keescook>
From:   "Lazar, Lijo" <lijo.lazar@amd.com>
Message-ID: <e56aad3c-a06f-da07-f491-a894a570d78f@amd.com>
Date:   Thu, 19 Aug 2021 10:33:43 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <202108181619.B603481527@keescook>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN1PR0101CA0066.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:d::28) To BL1PR12MB5349.namprd12.prod.outlook.com
 (2603:10b6:208:31f::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.31.157.114] (165.204.158.249) by PN1PR0101CA0066.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:d::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 05:03:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5b476c1-efa5-4dd9-bf4d-08d962cec1f3
X-MS-TrafficTypeDiagnostic: BL1PR12MB5286:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5286D7E3C6715DA83DC4D67F97C09@BL1PR12MB5286.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pm7ZNbkG+CM9o3vW7wyT7HKy1AhjeYApML/phV1WagfK3QHHhNSQKYrL/eBrRcbdzwsjYPzFfzJZyltwhnXw86fi+4JY7ka/oPcUCS0B3MiFaTpTuac4GfHBt1udufHHNclaq/OdP8om8rTIO+1jkU4IN/uRwqOFR2Ke9gWo3GWiIB0mqtlhrGLm/d+ER7eEBZCMJ+OLb/2F+7LsJKmVUuD/PUvhXOmQGwbYuMQGS4Mzh0au/vsup5gqUXwl3zeQtDlD91fFDJd+kiMoOUoZ56OReE8GL+HOVIRfuE/+kQWxRhh6JeC92xFlPK8Jp+FJnI4FKX/sMPjv2vpI7uTURKn04DvD8hwF7lwMgvGPCcS2JexJSZBvp88bfpKVJLNIKHRAkY4moElaksyGY8e0Vlih6ju+lmMW0hOSQ5aixpIjULqEp5uarI3/OgYgANUdYtVJcTYwHwkOWpTFdfTs5IHxGJhKpyMMpje5lgGA/B+MVbwwvEtjqro3cAxussU352a/CcIFFxH1CGr6QcAX8F8MdqDqEQF88DLV0LEqaqh9NltcJLQHFoP+8QVtnpnaeHU/IgSxOCPv9DFevMUiCFo4p4jUiHVS7el/DVBQvlZU74MNOpdX8jLCMaMZl2xVQbrhekGP8A/wt+VuaC+OpMQ47ITQESBCuH2LplX8lFeCwupz+WQC8Q69thzT4EbrDEUc+cyGdmBlBxwyPQOfJpOXrjqKt1velgSUkj9FBgbl4jct24aCDraH7JCAlSGNXONQYnWU3GoHlJLZDyjaL4wlZRD69rOm4cejAhNK5f3B6W/t+HHBd3x9IwNGKjii
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5349.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(366004)(39860400002)(136003)(84040400005)(186003)(8676002)(38100700002)(16576012)(6486002)(4326008)(316002)(6666004)(30864003)(7416002)(6916009)(2906002)(36756003)(83380400001)(54906003)(478600001)(66476007)(31696002)(26005)(2616005)(66556008)(45080400002)(53546011)(8936002)(956004)(66946007)(966005)(86362001)(5660300002)(31686004)(66574015)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUs5bG9TL0tTbnkxRWx4aXFjTXVtRWRtNHNXQW0wcHA2bzEzVGhieko0djlH?=
 =?utf-8?B?TlplZTIwa2M1T3hiVTh4NEpFV3RaL3plS3pXajczNGR3T2tjcUlRQUdDSHp6?=
 =?utf-8?B?Z2N1dVFZRXlPVDJ6SHVWalM5RXdmWlNxRDdNUHZmbFlpbE5nRnZpNTdEMTVX?=
 =?utf-8?B?K1RhaG5hcTRjeThEazlPSk8zWXBrY3p6T3FrNXNCSURVTkszemhRZ25WSnha?=
 =?utf-8?B?Lyt2VXNrd0RVTTJpczlLSmgyMkU2empIdTJwaXBxR2ZlN2hrYTc0RDdaOGFy?=
 =?utf-8?B?eGtkMHhUY2VLS2lmR0lUaXRlc2RlZWhZdkwyMjFwVzUxUUpoZ2ZvaGtSbHow?=
 =?utf-8?B?TTRWeEgxK0tOUTA0aktqanc2ZzZ6TThNZG9uLzZpVGVKTm1XcFlqNlY1ZTlY?=
 =?utf-8?B?OHI3VUdHbnVkeEtPbWJOWkR2aFpJZFM1ZktYL1UyQXZZdk1aSjUzMVYyWk1R?=
 =?utf-8?B?cGx0MWR4K0svMm5xZTVXZlo2T21ySXZyaUhjcDcxckVITU1BK3U0YkNUelh5?=
 =?utf-8?B?U0RYL0c4TUl0Y2ZTVWpTMk04VFprRGxXODZxWWtaTWdUS3hjaWVTRy8zOTkx?=
 =?utf-8?B?a3VkM1hMT1BIR1JlbTB4MXkyVVVhek1rd3NoR2pWWGp6aXIwdlJEdzNzaVo4?=
 =?utf-8?B?MTBFaTdYRUxTR1MzR015YVloM2I0cUZHVzE5eHZ3TitUS3g0ay94aWxidDNN?=
 =?utf-8?B?RTU3MGRiWVFwY21lWTFlamc1L2Q0d0UveEczcmx3NXI3UTdRRW1CamRRNnNH?=
 =?utf-8?B?RUhTLytadjZrR2I5bFlsYzBWeS9xc0ptbERJdW4yaGRKK3JaczFzT1BEVXE5?=
 =?utf-8?B?bXB1UTNIdEtmd3I1bU5kMjJiRi92ODYyK2k3b1grd3gxTXZhMXR3TTgrbU5J?=
 =?utf-8?B?SWRGMVBXcE5OVGNPaGQvaEdtNWFMNVUwMEI4YVdiWHA2OUhjK1dzL25Obk81?=
 =?utf-8?B?RldGQ3ZpTVZrOUpNZWVmZHJnU0p4RHFzQTF3SndiZWVXc1pQNG1DQXVpR3o4?=
 =?utf-8?B?K3Bpc29aQWM5K3ByVFRWYTZKb1FmdUNhQWxyeUxsQWFET1JPSzgvdytaTFBt?=
 =?utf-8?B?NXNpS3VEdEJtZjNOR0I2RCtJbWduSDFHYm42L2VPT3BHRnV4VlRLaWdMK0k3?=
 =?utf-8?B?LzlmVXJ3Ym02bGRnN3NUT25pTVhXZXNzRHRYNTZlK0haT3MvbWFtNGlva0l0?=
 =?utf-8?B?MU1tb2JxNGZmWWxqdUV2Mmg5RU9wcWp4TkJEOW9kODdySk8wY0VqUktWNGpa?=
 =?utf-8?B?cmgvTllhMXpVYlBzQnVyTkJ2djYvZktPWUlneVVwajRMc0hoUXpzSVBxektU?=
 =?utf-8?B?UXN6N0ZIOEJMeXYxOERjdUZHN1E4Z0VON2w1TFR0Y0YwQ202bzQxTU13NmJ4?=
 =?utf-8?B?MENlTndQOXNkN1dUWVF0NXF6Qmt4TTJlTEVXOUNvMlRkSzlhNC9BNlZSYWVi?=
 =?utf-8?B?RjF5Z2hZVHdDR2wrei9DNk4vNzVsWU9pMmx4NTZjV2xjNlZLSWtNUVd0NGdp?=
 =?utf-8?B?enRSTTZNaGRlZ2Nvbkl2S1R2WmdoSllMQVVMeFltY0M0OWdDUHk2YmZiSmZp?=
 =?utf-8?B?YWdWZEg5TjRZWlc1M2JBaUFUZFpTN2g2UzdjWWoySGFOelpSWWdqeTZIOGRP?=
 =?utf-8?B?LzVwcWZpbGx2cFRLV3hrbnpmeUFuK21zK3ZGemZ4UkhBSzFoeEVFWXVvTXg0?=
 =?utf-8?B?VWdGU3Fvby9XZi9iOVVHT0pjS25oUHM0NE9Lc01mRFNMZEJRaU1QdmpYZTlF?=
 =?utf-8?Q?dbc/8mys9atC2X2BqCUnNC4hqDH9loYuvgqK/aN?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5b476c1-efa5-4dd9-bf4d-08d962cec1f3
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5349.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 05:04:02.4348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nVgpSAVJkoL+vBWnQxvzbsiaWoDCy82hpM92A5HPZ30M1j7iTZ4uVaQ4o4lUTOkA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5286
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/19/2021 5:29 AM, Kees Cook wrote:
> On Wed, Aug 18, 2021 at 05:12:28PM +0530, Lazar, Lijo wrote:
>>
>> On 8/18/2021 11:34 AM, Kees Cook wrote:
>>> In preparation for FORTIFY_SOURCE performing compile-time and run-time
>>> field bounds checking for memcpy(), memmove(), and memset(), avoid
>>> intentionally writing across neighboring fields.
>>>
>>> Use struct_group() in structs:
>>> 	struct atom_smc_dpm_info_v4_5
>>> 	struct atom_smc_dpm_info_v4_6
>>> 	struct atom_smc_dpm_info_v4_7
>>> 	struct atom_smc_dpm_info_v4_10
>>> 	PPTable_t
>>> so the grouped members can be referenced together. This will allow
>>> memcpy() and sizeof() to more easily reason about sizes, improve
>>> readability, and avoid future warnings about writing beyond the end of
>>> the first member.
>>>
>>> "pahole" shows no size nor member offset changes to any structs.
>>> "objdump -d" shows no object code changes.
>>>
>>> Cc: "Christian König" <christian.koenig@amd.com>
>>> Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
>>> Cc: David Airlie <airlied@linux.ie>
>>> Cc: Daniel Vetter <daniel@ffwll.ch>
>>> Cc: Hawking Zhang <Hawking.Zhang@amd.com>
>>> Cc: Feifei Xu <Feifei.Xu@amd.com>
>>> Cc: Lijo Lazar <lijo.lazar@amd.com>
>>> Cc: Likun Gao <Likun.Gao@amd.com>
>>> Cc: Jiawei Gu <Jiawei.Gu@amd.com>
>>> Cc: Evan Quan <evan.quan@amd.com>
>>> Cc: amd-gfx@lists.freedesktop.org
>>> Cc: dri-devel@lists.freedesktop.org
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>> Acked-by: Alex Deucher <alexander.deucher@amd.com>
>>> Link: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flkml%2FCADnq5_Npb8uYvd%2BR4UHgf-w8-cQj3JoODjviJR_Y9w9wqJ71mQ%40mail.gmail.com&amp;data=04%7C01%7Clijo.lazar%40amd.com%7C3861f20094074bf7328808d962a433f2%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637649279701053991%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=386LcfJJGfQfHsXBuK17LMqxJ2nFtGoj%2FUjoN2ZtJd0%3D&amp;reserved=0
>>> ---
>>>    drivers/gpu/drm/amd/include/atomfirmware.h           |  9 ++++++++-
>>>    .../gpu/drm/amd/pm/inc/smu11_driver_if_arcturus.h    |  3 ++-
>>>    drivers/gpu/drm/amd/pm/inc/smu11_driver_if_navi10.h  |  3 ++-
>>>    .../gpu/drm/amd/pm/inc/smu13_driver_if_aldebaran.h   |  3 ++-
>>
>> Hi Kees,
> 
> Hi! Thanks for looking into this.
> 
>> The headers which define these structs are firmware/VBIOS interfaces and are
>> picked directly from those components. There are difficulties in grouping
>> them to structs at the original source as that involves other component
>> changes.
> 
> So, can you help me understand this a bit more? It sounds like these are
> generated headers, yes? I'd like to understand your constraints and
> weight them against various benefits that could be achieved here.
> 
> The groupings I made do appear to be roughly documented already,
> for example:
> 
>     struct   atom_common_table_header  table_header;
>       // SECTION: BOARD PARAMETERS
> +  struct_group(dpm_info,
> 
> Something emitted the "BOARD PARAMETERS" section heading as a comment,
> so it likely also would know where it ends, yes? The good news here is
> that for the dpm_info groups, they all end at the end of the existing
> structs, see:
> 	struct atom_smc_dpm_info_v4_5
> 	struct atom_smc_dpm_info_v4_6
> 	struct atom_smc_dpm_info_v4_7
> 	struct atom_smc_dpm_info_v4_10
> 
> The matching regions in the PPTable_t structs are similarly marked with a
> "BOARD PARAMETERS" section heading comment:
> 
> --- a/drivers/gpu/drm/amd/pm/inc/smu11_driver_if_arcturus.h
> +++ b/drivers/gpu/drm/amd/pm/inc/smu11_driver_if_arcturus.h
> @@ -643,6 +643,7 @@ typedef struct {
>     // SECTION: BOARD PARAMETERS
>   
>     // SVI2 Board Parameters
> +  struct_group(v4_6,
>     uint16_t     MaxVoltageStepGfx; // In mV(Q2) Max voltage step that SMU will request. Multiple steps are taken if voltage change exceeds this value.
>     uint16_t     MaxVoltageStepSoc; // In mV(Q2) Max voltage step that SMU will request. Multiple steps are taken if voltage change exceeds this value.
>   
> @@ -728,10 +729,10 @@ typedef struct {
>     uint32_t     BoardVoltageCoeffB;    // decode by /1000
>   
>     uint32_t     BoardReserved[7];
> +  );
>   
>     // Padding for MMHUB - do not modify this
>     uint32_t     MmHubPadding[8]; // SMU internal use
> -
>   } PPTable_t;
> 
> Where they end seems known as well (the padding switches from a "Board"
> to "MmHub" prefix at exactly the matching size).
> 
> So, given that these regions are already known by the export tool, how
> about just updating the export tool to emit a struct there? I imagine
> the problem with this would be the identifier churn needed, but that's
> entirely mechanical.
> 
> However, I'm curious about another aspect of these regions: they are,
> by definition, the same. Why isn't there a single struct describing
> them already, given the existing redundancy? For example, look at the
> member names: maxvoltagestepgfx vs MaxVoltageStepGfx. Why aren't these
> the same? And then why aren't they described separately?
> 
> Fixing that would cut down on the redundancy here, and in the renaming,
> you can fix the identifiers as well. It should be straight forward to
> write a Coccinelle script to do this renaming for you after extracting
> the structure.
> 
>> The driver_if_* files updates are frequent and it is error prone to manually
>> group them each time we pick them for any update.
> 
> Why are these structs updated? It looks like they're specifically
> versioned, and aren't expected to change (i.e. v4.5, v4.6, v4.10, etc).
> 
>> Our usage of memcpy in this way is restricted only to a very few places.
> 
> True, there's 1 per PPTable_t duplication. With a proper struct, you
> wouldn't even need a memcpy().
> 
> Instead of the existing:
>                 memcpy(smc_pptable->I2cControllers, smc_dpm_table_v4_7->I2cControllers,
>                         sizeof(*smc_dpm_table_v4_7) - sizeof(smc_dpm_table_v4_7->table_header));
> 
> or my proposed:
>                 memcpy(&smc_pptable->v4, &smc_dpm_table_v4_7->dpm_info,
>                        sizeof(smc_dpm_table_v4_7->dpm_info));
> 
> you could just have:
> 		smc_pptable->v4 = smc_dpm_table_v4_7->dpm_info;
> 
> since they'd be explicitly the same type.
> 
> That looks like a much cleaner solution to this. It greatly improves
> readability, reduces the redundancy in the headers, and should be a
> simple mechanical refactoring.
> 
> Oh my, I just noticed append_vbios_pptable() in
> drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_processpptables.c
> which does an open-coded assignment of the entire PPTable_t, including
> padding, and, apparently, the i2c address twice:
> 
>          ppsmc_pptable->Vr2_I2C_address = smc_dpm_table.Vr2_I2C_address;
> 
>          ppsmc_pptable->Vr2_I2C_address = smc_dpm_table.Vr2_I2C_address;
> 
>> As another option - is it possible to have a helper function/macro like
>> memcpy_fortify() which takes the extra arguments and does the extra compile
>> time checks? We will use the helper whenever we have such kind of usage.
> 
> I'd rather avoid special cases just for this, especially when the code
> here is already doing a couple things we try to avoid in the rest of
> the kernel (i.e. open coded redundant struct contents, etc).
> 
> If something mechanically produced append_vbios_pptable() above, I bet
> we can get rid of the memcpy()s entirely and save a lot of code doing a
> member-to-member assignment.
> 
> What do you think?
> 

Hi Kees,

Will give a background on why there are multiple headers and why it's 
structured this way. That may help to better understand this arrangement.

This code is part of driver for AMD GPUs. These GPUs get to the 
consumers through multiple channels - AMD designs a few boards with 
those, there are add-in-board partners like ASRock, Sapphire etc. who 
take these ASICs and design their own boards, and others like OEM 
vendors who have their own design for boards in their laptops.

As you have noticed, this particular section in the structure carries 
information categorized as 'BOARD PARAMETERS'. Since there are multiple 
vendors designing their own boards, this gives the option to customize 
the parameters based on their board design.

There are a few components in AMD GPUs which are interested in these 
board parameters main ones being - Video BIOS (VBIOS) and power 
management firmware (PMFW). There needs to be a single source where a 
vendor can input the information and that is decided as VBIOS. VBIOS 
carries different data tables which carry other information also (some 
of which are used by driver), so this information is added as a separate 
data table in VBIOS. A board vendor can customize the VBIOS build with 
this information.

The data tables (and some other interfaces with driver) carried by VBIOS 
are published in this header - drivers/gpu/drm/amd/include/atomfirmware.h

There are multiple families of AMD GPUs like Navi10, Arcturus, Aldebaran 
etc. and the board specific details change with different families of 
GPUs. However, VBIOS team publishes a common header file for these GPUs 
and any difference in data tables (between GPU families) is maintained 
through a versioning scheme. Thus there are different tables like 
atom_smc_dpm_info_v4_5, atom_smc_dpm_info_v4_6 etc. which are relevant 
for a particular family of GPUs.

With newer VBIOS versions and new GPU families, there could be changes 
in the structs defined in atomfirmware.h and we pick the header accordingly.
	
As mentioned earlier, one other user of the board specific information 
is power management firmware (PMFW). PMFW design is isolated from the 
actual source of board information. In addition to board specific 
information, PMFW needs some other info as well and driver is the one 
responsible for passing this info to the firmware. PMFW gives an 
interface header to driver providing the different struct formats which 
are used in driver<->PMFW interactions. Unlike VBIOS, these interface 
headers are defined per family of ASICs and those are 
smu11_driver_if_arcturus.h, smu11_driver_if_* etc. (in short driver_if_* 
files). Like VBIOS,  with newer firmware versions, there could be 
changes in the different structs defined in these headers and we pick 
them accordingly.

Driver acts the intermediary between actual source of board information 
(VBIOS) and PMFW. So what is being done here is driver picks the board 
information from VBIOS table, strips the VBIOS table header and passes 
it as part of PPTable_t which defines all the information that is needed 
by PMFW from driver for enabling dynamic power management.

In summary, these headers are not generated and not owned by driver. 
They define the interfaces of two different components with driver, and 
are consumed by those components themselves. A simple change to group 
the information as a separate structure involves changes in multiple 
components like VBIOS, PMFW, software used to build VBIOS, Windows 
driver etc.

In all practical cases, this code is harmless as these structs (in both 
headers) are well defined for a specific family of GPUs. There is always 
a reserve field defined with some extra bytes so that the size is not 
affected if at all new fields need to be added.

The patch now makes us to modify the headers for Linux through 
script/manually whenever we pick them, and TBH that strips off the 
coherency with the original source. The other option is field by field 
copy. Now we use memcpy as a safe bet so that a new field added later 
taking some reserve space is not missed even if we miss a header update.

Thanks,
Lijo

