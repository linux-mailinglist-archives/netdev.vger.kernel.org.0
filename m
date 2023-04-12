Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413DB6DFC0D
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 18:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjDLQ72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 12:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbjDLQ7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 12:59:22 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BA39012
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 09:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681318738; x=1712854738;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aMExAfNvVdOkOIRp2BycFiyf6Vjwk0P8hwVsEYdvbBY=;
  b=VpqACX1j30/mv7BAtPlGNRNz3Vb0+uSByuYec6qf3SZBmFRqhAh1IwT6
   4FmkoKlkm+ZQ9HLsRzrmYAKc5jkbIxmUj4+d80EUxjy41FIERf/FrQYam
   0hfySfC0pYbVRBVHjuOxl5pFbrQh3IGaZfj9VLDEWWL84MbePM7BOimpb
   D7YsjbkNnx4VGqBaowHSrhr2OCpLK7y2vgOylzyn8yQjRh6TCYElK+hVo
   Y0sDqO9k2Df3+QYXxZPi9s535W/BfdAodTfSB8PnS2OhU/v6l2POR1kW4
   SlKZC2Jn9CUpgyaiY629Mi9YsCeyzQqSc8wMw1igZaKd30Z6ZmOqTFn14
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="430246614"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="430246614"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 09:58:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="682540105"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="682540105"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 12 Apr 2023 09:58:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 09:58:54 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 09:58:54 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 09:58:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MofDebheh9Qq9Ntw5I1IR2b57dSUUmyfN4CEEvxD4VY66FftjwjSJxjUCKyi9JrDJygY5T3RQY6hSxVE6LkISlDsoKt5FwU/8Y1bgZoHOLujx53U2MYg5IoazYftvK/6kQk6Sz+7HgktHicW05vFtaOa+uS9KLWqBGPTThotgn5IX068IjAWEbTgZvE+u9Kn5BRTUktYxLT+XS/BD4WYbCv1aIG/1bl4U/NX8jufgw+29boshTKHfyasnVDHZzcVHy/BCbzkudwHL6nASrCiTy3iHcI1m6QKKvG887h2+SR5gXWRYT5kUV+efFYK8XrmbfORMOFtFNflTmw36UKtlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fZM6B2FUMT6oUWdL7zdt1bDCSWPcb26ksb+Nh0kD49U=;
 b=DwE0jnIQDsR88MivkQ0A9inglN7qgTYzxn+hWwAvV4GHg729iyctFpvofarCv/rAeDDtuTao4bgZnyltM9Cy1CKroTpxbhmoYn6tn9IupvyJ1msAjUrzzSW1PPFtR9yEciwzuPPsiee804FaXTy2/MYxknM6dcoUzEUwEw/uRIManldYGg2a91Z/KQRoX5u2iv073abbHRsnoM4/EqZARpi55y3A17T4axOKcrhvJ6mFrObPpJP/A9PrPxYtL2Se11W9NdcQe8NUoEqIHlFZRdjAb76mULVYZgMDnvdsl0TG+jMapkGUxCGx10R6QxqDWwmjywl2Ttfd/NbDAN6CBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4538.namprd11.prod.outlook.com (2603:10b6:303:57::12)
 by SA2PR11MB5116.namprd11.prod.outlook.com (2603:10b6:806:fa::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.36; Wed, 12 Apr
 2023 16:58:52 +0000
Received: from MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::8733:7fd2:45d1:e0d6]) by MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::8733:7fd2:45d1:e0d6%6]) with mapi id 15.20.6277.038; Wed, 12 Apr 2023
 16:58:52 +0000
Message-ID: <ffd66203-4349-0986-2130-f8b156f1923a@intel.com>
Date:   Wed, 12 Apr 2023 09:58:49 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [Intel-wired-lan] [PATCH net-next 01/15] virtchnl: add virtchnl
 version 2 ops
Content-Language: en-US
To:     Shannon Nelson <shannon.nelson@amd.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        <intel-wired-lan@lists.osuosl.org>
CC:     <netdev@vger.kernel.org>, <shiraz.saleem@intel.com>,
        <willemb@google.com>, <decot@google.com>, <joshua.a.hay@intel.com>,
        <sridhar.samudrala@intel.com>, Alan Brady <alan.brady@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Phani Burra <phani.r.burra@intel.com>
References: <20230329140404.1647925-1-pavan.kumar.linga@intel.com>
 <20230329140404.1647925-2-pavan.kumar.linga@intel.com>
 <49947b6b-a59d-1db1-f405-0ab4e6e3356e@amd.com>
 <a5b7f1e4-8f14-d5fb-8f88-458d7070825d@intel.com>
 <f7c7c691-d173-73ab-c24a-79c22e6ef3b0@amd.com>
From:   "Tantilov, Emil S" <emil.s.tantilov@intel.com>
In-Reply-To: <f7c7c691-d173-73ab-c24a-79c22e6ef3b0@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR06CA0005.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::18) To MW3PR11MB4538.namprd11.prod.outlook.com
 (2603:10b6:303:57::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4538:EE_|SA2PR11MB5116:EE_
X-MS-Office365-Filtering-Correlation-Id: cdf15c28-fb7e-40bb-8bb2-08db3b773161
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RWYfeDmFdJOM1RYYpmhxeQKUTPaVYCAWabN6iiAIbiVVlL5BS+GNOsByYlsgjmw5saqS0V32tOl3YAQgSh/b/Dg/huEiXRj4wwHiIKid8xlFCBsAuuw6GsoTVkeSmS4gZBZFeEhimeGIG40hFJrKmlHdKEiHPxAdCBtoslM3Rx7qR295QQDbvdJKdwUvtJFxMpngmHsF4D2VbImiHAjVjCvO/qLRNi67fUGiAeJSYROiOL+FqTGG7VyMRr0jlH72+6jmaII7UBaHjiiuw2SU4O5dgBuTtZ/o2KBRz6NVZHGRilo/YYoWJKUvLAzUmS8n3IYxgThmYm0sS6qDjJm/9Hhzk8yIzl6YOfWjyBa5xTh+NBNABQPsJLZPkMEZ8uv4NO1fr8kvxbjNy1FpLOLVxFXl9XveWHjEhZQE610EnFlkq1O5PBbDv9+tjVM1pS6H3gEh5OZEL5GwBZghk9rbpkNTut16lsPbulaCycFEsO6Azs1zbKN9mvwFZh8Cv6sFy+/m5SSp6b00LMRcnwZGH3VKsThr9+yTYKYeaojIcwrYLIA+o0LUeH0Goi+lPeL2qjv+4i4l4ai0D1IavCYcZfoi3zTmtGNS17Rn3DdIGeXCnBhC3a0UCksevdw+prwkPrRPilc2a482mrDENXHrwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4538.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(136003)(39860400002)(346002)(376002)(451199021)(478600001)(53546011)(6512007)(66476007)(26005)(186003)(316002)(6506007)(110136005)(2906002)(4326008)(66946007)(54906003)(6666004)(41300700001)(6486002)(8936002)(66556008)(5660300002)(8676002)(107886003)(82960400001)(38100700002)(31696002)(86362001)(83380400001)(36756003)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?elJHNE5PMVJmekZPVzZTY3FNT1RGM0VYSWFRcDlma1MvSjQwSWFINWJaRWNU?=
 =?utf-8?B?dE5rYy8wUGk2VXZJeWYyT05TMTA5V08yZGhXZDBqNGdFTFdlNG5ReUVCTndZ?=
 =?utf-8?B?QWh2bWZTYmNLZ2NTNi9zczFNZURxa3BsaWphdmNvNzhDSkhYdHZoSjNEV2hH?=
 =?utf-8?B?QXQrWmcxTDFpdVV1d3M5Um9XQ1NBZWxBNDJvbDc4SmVvOTBjbVJaV01DbGpM?=
 =?utf-8?B?eTByaE9QVjV5OE9rT1pheUlocllQbGE4S2ZxQ05hV0E1YXhVaVB6ZjhSQnhl?=
 =?utf-8?B?dlFpeUtiMm9TQTBlWnhsWFpmV2U1SUdwMWV6WlFzcmhaVFluZ0QwUW1yd3o2?=
 =?utf-8?B?b3VpSkhBN1hvRWFvSkRJR0NvaUpXMzRNT1FDTXdxaHMwdUQ3L3FEckVoSk9x?=
 =?utf-8?B?cjNEYUNmU0Y0VkIxOGdiS0lkNnZYQXBZQ2w3NHdxM0xHRG9RUktlTTJSZXVO?=
 =?utf-8?B?Yktzd1gyVk1nL0l0ZGMzTXloU1c1clFzeGhWbnRQS3dNRm03UktlZ1Q4aWow?=
 =?utf-8?B?eThzb0hrT3NkYkhuQUI0SkR1cENQOVUrRXRGbnFLS0psZ3NucGlBSTdhT0N1?=
 =?utf-8?B?ZFhHQmdOK0xGM25Gbm1Pamw0Q1RWWm5CWWhJWWNpdCsrVEFhb1YzM3BVTm04?=
 =?utf-8?B?QWhqWStkeUV5b01UMS9CdWpITy80RTZnbXREM0pOMmJXcGJCV2VEdittd0o1?=
 =?utf-8?B?MXdLdmI0am9jSDFnQjFsSDVCY1dVU3RPWHpUVkhKdDEvQmorcnRzd3BKUXZw?=
 =?utf-8?B?cEU4N0tkNkpTSE1LTVQzbG9aMlkwOXU5YUJKNXRsMDhDVjA0WVR6QVBkdUFr?=
 =?utf-8?B?Umt4OG9Dc3cxWERxNzhkVHlrWmpuZi9VKzIxQW9hQlRyaUJ1KzN0T2pYeWFq?=
 =?utf-8?B?c2tpMXFhQ2Q0SG11L04xVFVsWHdWYlBMOEZnVXNyK1YvZzRxTE9QVUtuWFB5?=
 =?utf-8?B?OHRxTnc0QU9RTCtRaGpqb3c3T3pvSjhFZURMSndZN1hxbGI4c0dkL0RpeFBh?=
 =?utf-8?B?aXVMZm9BVDYvNzBvSW5kUnhZTys1TVNPWUFLOUdTbU5rU0hPWkROMDVBUGc1?=
 =?utf-8?B?NjBjVGtkaHFybTFPK3dNU01DVTZGL3VzT1JPOGhYZ3Ewd0FHTkdydDdESTFy?=
 =?utf-8?B?YkhrYi95bHQ1c0xMNDJTV1UxNW5RdlFOaTQwYzB3N2N6eE5UdWFiL3BDYmtw?=
 =?utf-8?B?Q3h3VGk0N0JQRkFMK0FsNjRjbVdlQmcxeFJzcFptVWJRcWxVV01YSlBRVzg4?=
 =?utf-8?B?UDlmUGt5TzNFeHJLQXBXR1BOaG1TRkpiRDJjbndTRU5peXd0M3JVQ21LSE9L?=
 =?utf-8?B?YmtZZnQ1TGRaRlREZGVnVWtHdDhiNDBLZ0dOa3owU2lqYlVQT2l1M0JNVlpW?=
 =?utf-8?B?QTVwYWRzejUvSEtSNkZYRi96MVBBbGpZZGtjNFB2Z21PWERxNS9PNGFPd1VF?=
 =?utf-8?B?RFZ4NVQ2L1g0SWdRMnIrVXBaSzVUU1h3R2NDdkJ2Z1lFOW1pdTkwZGRWMk9m?=
 =?utf-8?B?bkgzYmJOak5XS0RteWdsS0lRbVZpYXZLZER1eDNFTHYyQVRxV1ZTaUx1a2Fw?=
 =?utf-8?B?NU9Sd2JLdkUxSVMza0VMYVFQWjVIYVhSRkVNTXN5OWZQVjJvYWMxNW8zQTMr?=
 =?utf-8?B?UTdUdXlYbC9GQlhqYS8wL25ic3hKT251TnVmYUxmL3dGYS9xamRKOUZZOUtt?=
 =?utf-8?B?MkNvZGxwSFdjdjczU0xmNG0zVWk4eU5JNVRDUVNzYW54K24xYk9jRGlPRGZB?=
 =?utf-8?B?V2YySnZ6ZGRKU1h4ZnNGQS9PK3dyVVJuY2hpV3VhaEp2YXQ2WUZ3VjZpcmp0?=
 =?utf-8?B?M3VMZEJaOHpZKzhFdlJHcWlPcTNqYkMyTE13OWdLbWYzRmZJN3pXTVFVcGVy?=
 =?utf-8?B?TFVrWTc1Nnp1RFRPSFZ2TElCcW1qVTcvblg2Rk9xVi85WituZ09iakw4WWt3?=
 =?utf-8?B?SEQyTmxQYlVTSHprTTBONnNaTWhvcmVNVTh6LzZaYkNGR2d4SXVHQjVBemZz?=
 =?utf-8?B?amN5Z1Nud2FHSUlXUnZEWllSNXpyNzBidStEd2x2bFhKcXJJamxkZ2RPN3VT?=
 =?utf-8?B?M2NyYjBCY29EVXgzRjk0bzhoZkN3aFNva1I0N09BRWhYanArUkQ4QXowc3Qz?=
 =?utf-8?B?a3AyWFZMOEZjUjg0MzRkZmpyZEswVW1NOEdlTkx0ZG9mejFXWk8yNzNLZHJm?=
 =?utf-8?B?aWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cdf15c28-fb7e-40bb-8bb2-08db3b773161
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4538.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 16:58:52.1142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P1dFQAlwwHEkvyOD7kzYhlnEqFjDh5AXN4FWxbXVix0iNX8Sgdv4Cx3cfNVQfctfJyBjEX4kTpsshOLiFzb3bygoVR9jxJ0RpeaCXGBIa8U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5116
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/10/2023 3:12 PM, Shannon Nelson wrote:
> On 4/10/23 1:27 PM, Linga, Pavan Kumar wrote:
>>
>> On 4/4/2023 3:31 AM, Shannon Nelson wrote:
>>> On 3/29/23 7:03 AM, Pavan Kumar Linga wrote:
>>>>
>>>> Virtchnl version 1 is an interface used by the current generation of
>>>> foundational NICs to negotiate the capabilities and configure the
>>>> HW resources such as queues, vectors, RSS LUT, etc between the PF
>>>> and VF drivers. It is not extensible to enable new features supported
>>>> in the next generation of NICs/IPUs and to negotiate descriptor types,
>>>> packet types and register offsets.
>>>>
> 
> [...]
> 
>>>> +
>>>> +#include "virtchnl2_lan_desc.h"
>>>> +
>>>> +/* VIRTCHNL2_ERROR_CODES */
>>>> +/* Success */
>>>> +#define VIRTCHNL2_STATUS_SUCCESS       0
>>>
>>> Shouldn't these be enum and not #define?
>>>
>>
>> This header file is describing communication protocol with opcodes,
>> error codes, capabilities etc. that are exchanged between IDPF and
>> device Control Plane. Compiler chooses the size of the enum based on the
>> enumeration constants that are present which is not a constant size. But
>> for virtchnl protocol, we want to have fixed size no matter what. To
>> avoid such cases, we are using defines whereever necessary.
> 
> The field size limitations in an API are one thing, and that can be 
> managed by using a u8/u16/u32 or whatever as necessary.  But that 
> doesn't mean that you can't define values to be assigned in those fields 
> as enums, which are preferred when defining several related constants.
> 
We can certainly look into it, but for the purpose of this series it 
doesn't seem like a meaningful change if it only helps with the grouping 
since the define names already follow a certain pattern to indicate that 
they are related.

> 
> [...]
> 
>>
>>>> +
>>>> +/* VIRTCHNL2_OP_GET_EDT_CAPS
>>>> + * Get EDT granularity and time horizon
>>>> + */
>>>> +struct virtchnl2_edt_caps {
>>>> +       /* Timestamp granularity in nanoseconds */
>>>> +       __le64 tstamp_granularity_ns;
>>>> +       /* Total time window in nanoseconds */
>>>> +       __le64 time_horizon_ns;
>>>> +};
>>>> +
>>>> +VIRTCHNL2_CHECK_STRUCT_LEN(16, virtchnl2_edt_caps);
>>>
>>> Don't put a space between the struct and the check.
>>>
>>
>> Checkpatch reports a warning (actually a 'Check') when the newline is
>> removed. Following is the checkpatch output when the newline is removed:
>>
>> "CHECK: Please use a blank line after function/struct/union/enum
>> declarations"
> 
> Since it has to do directly with the finished definition, one would 
> think it could follow the same rule as EXPORT... does.  It might not be 
> a bad idea at some point for static_assert() to be added to that allowed 
> list.  For now, though, since it is only a CHECK and not WARN or ERROR, 
> you might be able to ignore it.  It might be easier to ignore if you 
> just used the existing static_assert() rather than definigin your own 
> synonym.

OK, we'll remove it.

> 
> 
> [...]
> 
>>>> +/* Queue to vector mapping */
>>>> +struct virtchnl2_queue_vector {
>>>> +       __le32 queue_id;
>>>> +       __le16 vector_id;
>>>> +       u8 pad[2];
>>>> +
>>>> +       /* See VIRTCHNL2_ITR_IDX definitions */
>>>> +       __le32 itr_idx;
>>>> +
>>>> +       /* See VIRTCHNL2_QUEUE_TYPE definitions */
>>>> +       __le32 queue_type;
>>>> +       u8 pad1[8];
>>>> +};
>>>
>>> Why the end padding?  What's wrong with the 16-byte size?
>>>
>>
>> The end padding is added for any possible future additions of the fields
>> to this structure. Didn't get the ask for 16-byte size, can you please
>> elaborate?
> 
> Without the pad1[8], this struct is an even 16 bytes, seems like a 
> logical place to stop.  24 bytes seems odd, if you're going to pad for 
> the future it makes some sense to do it to an even 32 bytes 
> (power-of-2).  And please add a comment for this future thinking.

We can change the name to reserved to make it clearer, but the size 
cannot be changed because it's an ABI already.

Thanks,
Emil

> 
> sln
