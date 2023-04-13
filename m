Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9B86E14A2
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 20:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjDMSyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 14:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbjDMSyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 14:54:49 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954DC1BE6
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 11:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681412088; x=1712948088;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OEl+6PBa7plpBVnhg06Ox+ITTKWpnbZOh9yeeVVMWdY=;
  b=YxrZ8vvKcB3EVnKtgkEVJHa1Iz7yGl/9/xb3YBBktGd3/AuLZ2QM4DPU
   khyMJHvUqyX8Jv7Frhgal5EXeV4qgQ3T4yKLbnMqSBQNxpDgCxbYPhacG
   8lkqAkEdiiSu092TpkV0oT16R6ZnlLRRBK3dnsDb3yROGdE3M5oGVB/eV
   0yqGjfhJj9pR9oOM6UOwVY5fVw0aLm3MXiuefo9CojMMfO9RjH63RS16E
   UEjfrYk/+xvjFa0QKNiDh7Bp/GJHrV/QpurcOC6afRT24N6q5VWCIur7f
   SDYVNpWqmqPJp5AZRtXPuimUjrgh48wKCoxnDe5kWesJbmyRE19VfdHow
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="341773021"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="341773021"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 11:54:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="758804249"
X-IronPort-AV: E=Sophos;i="5.99,194,1677571200"; 
   d="scan'208";a="758804249"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 13 Apr 2023 11:54:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 11:54:47 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 11:54:47 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 11:54:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1xP/2Vg6+8HnaJqkFl2lMX1g/Cu7YAxEqHQtGcYDut+ZOW7PyIsQcscQ+wpCZ53CxL/veyBokCeDAyne0lbFR0mNG3eBnbx8VNWO7WpU1gWo0IOh5O0U/cxp1/2nEeE25L5Dnv8IWSRD4Dkn8o6G9LdozCZ55WINKB7Hlq4A3k3Hbvnyu9uEaquiK8HWCmUxEy951+p28qZVF1jBdMByEz/bm8OmTsvLBfFtmRIxZA0Gx7D7RO1ZuZWc9dwSl4rf+g6RULVrirdm+L+jpr4Fet0eT4gPfWfiZl9bZoFiYK59XyF6uUPf4SAxyAypy5eh1398MqSsOw2k6Oz7ZeN+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wbFb95hoZKBnXqvnri2xCWErr7ZR3eBsR3ubDVpabw8=;
 b=ZA0jkdWL6eN4BGGKjAvX03zuzsolILtFDkPFcWceJ3Ah7ZgU0W6hBCtPdr5KOlO2uYK2A73lHko+3a3VYPWMlvPJeQZoA8hYlubiyoSQfMJ6m7yYBWaHRDbF3vlLooOoB31LzD2S9v0/pSwpnkCuHhrJsDsDUoaM5QQU454Hxd0vTt+6Ni+Xck1D3CMPtAwuBB1MfYd20nsOAGRTJpQE1+AgKinkuniy6RPQxgtiCOpRWy54pUNylg9MJJ7NMSwpvEFR6ERFzFVx1Ek+M1h/7prtfQ39aE+Lhc/9qM5Sp3XkwnPAX5L9rsPv3YquF2bCejEvLVNpZNa1veR6zcuqjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW3PR11MB4538.namprd11.prod.outlook.com (2603:10b6:303:57::12)
 by SJ0PR11MB5216.namprd11.prod.outlook.com (2603:10b6:a03:2db::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 18:54:45 +0000
Received: from MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::8733:7fd2:45d1:e0d6]) by MW3PR11MB4538.namprd11.prod.outlook.com
 ([fe80::8733:7fd2:45d1:e0d6%6]) with mapi id 15.20.6277.038; Thu, 13 Apr 2023
 18:54:44 +0000
Message-ID: <aeb969e0-b829-d869-a93c-1d15755367ce@intel.com>
Date:   Thu, 13 Apr 2023 11:54:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
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
 <ffd66203-4349-0986-2130-f8b156f1923a@intel.com>
 <ffe43a28-641c-c263-2ea2-67882b476cde@amd.com>
From:   "Tantilov, Emil S" <emil.s.tantilov@intel.com>
In-Reply-To: <ffe43a28-641c-c263-2ea2-67882b476cde@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0P220CA0006.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::29) To MW3PR11MB4538.namprd11.prod.outlook.com
 (2603:10b6:303:57::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR11MB4538:EE_|SJ0PR11MB5216:EE_
X-MS-Office365-Filtering-Correlation-Id: 3933b8c6-e9e6-45a0-742d-08db3c508bc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9no7bJp0EtbZJqT6eBSUZJ6UdjfF7X+Qmfl8O8092NZRn/ZDKpjD9Dxquhepoo+bye1fTT1nqOWIvqPaK6aLfgfYH287Mt5+pZYM4JhFz6tPtwBbZIAQqe3Z4SYUZuw8xf9Ya58sa/OFk2Vo7Pg+f+q6dkz2Q4q9l1CogXz2YZs0DA87bj2vJqvA6xquIY9pXezW7CoPvknxG9e6W6CqkJX9OzI8O9Me/sNxSuUox+x+wVzQYbkZiAffUVVqbD8KYLwF+XLwVpsANmA3eUtghXZ8KBxLmwLwptuMokeahfSAmYYGiSPku+vlOmCBQgxquh97zWu+IytAmT3JKmNsy+H/w3EE2ub7AFWDIkUoksjJcniZveWpDMY3ynl0rXN0eLs5DAxv9AEfGYQy7cqh6KIQ26b8Sy594qejnspICWE2mmWdLprfr1Zz2byL1pSE2DMIpwe94SuZQsVfiRvX7z+umHXyNpGgiUTKU7vWSBnps5Y1Wkb0LfWHofQyJBqfwmdbPJ9/SAt1eTc2ZNeN1oOrifSxaeRyR8Hqsc6wAo54fhYFW8qBnfbnHUaogbTrpQYVtoLhvBQga9WdulRgsrXvhVs0TjEaIZ3FLGGS9T1VVFn9etkvw5YRas2XJfBtNAnbRBQlhIDuWy2/LN1Drw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4538.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(396003)(136003)(376002)(346002)(451199021)(53546011)(26005)(31686004)(6512007)(6506007)(54906003)(83380400001)(186003)(2616005)(107886003)(6486002)(6666004)(5660300002)(41300700001)(82960400001)(38100700002)(316002)(8676002)(8936002)(86362001)(31696002)(478600001)(66946007)(4326008)(36756003)(66556008)(66476007)(2906002)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ODkxT0ZLWnJjaERqZVZHWFc0UDF4WWxuVktIYW1JNG1lK3p0OE5KZVNKaEl6?=
 =?utf-8?B?cno5djMvWHZkWGFodTd1YU1YMFFCbThyc2JLT2VhSDlLZXNvM1k3QlZMSGIy?=
 =?utf-8?B?ajlNOXVVbWp4S0VsQ0krYU8rTmhSZ2FuWUsxOEVCamw4eVJnbU5YRGl5Z2or?=
 =?utf-8?B?WVlhVEd5cy9kZm5ZQ3dHMjlpQXFYZHFZNlpOK1M2M2R3MDRpRkQrVGZXalVH?=
 =?utf-8?B?UXI0VTFFV3IvaEtmV1QyTUhHM3Y2cHR3WENockVOYnQzWFNTck9OMUtVdkpQ?=
 =?utf-8?B?dERFNUZSNTRoeDhIaWNrclZvS3ZheW9DUVd6bkpQSVdaZnYwWmtod0pPUVdu?=
 =?utf-8?B?WjNoWW9MR09LMlY3TTZFRGltUWYyWUthQ0QyYlBtc2dZMVJSS002Q01CYXJE?=
 =?utf-8?B?RnhtTjJITXRPbFBPeHJNblN6ZVdKN29Db0tBa3dTVEFXcEZoQlJsamhZS01L?=
 =?utf-8?B?UFlTN2kxOTlHNkc4ZktwUUJCRjNvYU9CYjlnMnFjVU82d0ZmQzFzWlBrYXA3?=
 =?utf-8?B?WlByZnlsM2dKbmVWQmRFdFFTSStRVmdlWW1XZW91ZC81ZzV6NFUyWXIxUjly?=
 =?utf-8?B?M3h6eGZCWDVzcVhWMXRNQTB2dDJnVkJzVjB2N2RLVWgwRlJoZ0E3cDBaeTh5?=
 =?utf-8?B?dHpuWHpCMWlaRVRjZ1lPL1cyaE12WEtvT1NMUW5rbS96N0lGb1VoeFY1ZVpY?=
 =?utf-8?B?VUJxQTJYcXY5dzAxQTFNdnVqTzZFelZsbm5HK2hiKzBhVzU1MFJqYXBrR29D?=
 =?utf-8?B?c3ZIUHVyaDFqNWZlQ050NVVSNkoxRUU3TGUrRjZEdzhOZW1IdGc0OWtZU3lH?=
 =?utf-8?B?YmhodUQrVjBpM3ZiZjJDYkNXSVVock9YeXZOaEQ3aWIvWTJESFpQejRvT3Zs?=
 =?utf-8?B?cThZcFh3NlVmODBBRnlFSnlhYnFjR1dkOFl5ZnhWUkhkMGRsUUhVSW5FL3NM?=
 =?utf-8?B?aUQxSUtWWGNWK2JhSVZja0MvdjMzY1loV21IVXh6c25Ya0pSeVJYTGgvRWdv?=
 =?utf-8?B?d3hBOUVmemFDNDUzVWFsWjJ3aDhDOUI4WnRFZWNVUU5HT1VLcEsxMU80Q2d5?=
 =?utf-8?B?VDlVQkNXQUxoWVpsVUxuZXg2akVhaWowRFFtdStKOXlqSUUvN2hXRUgxQlJG?=
 =?utf-8?B?NEJSU3FKVEhQbFQ2YzRGbVBNZXZCMUk4TTFaVE5UNzY2ZkN5ejVOR050TjJG?=
 =?utf-8?B?ZCtrTnFaeGtuNmNqT083Wjl5Rm55T3hvTGRNSVZOb2wyaGRBTXZrUDdIbHp2?=
 =?utf-8?B?TFpCZ0xxS1kwVDlUYWZnRi9PbERLVkYzR3JkOXo0ZjhVZFpFOENRRXdjRFpT?=
 =?utf-8?B?eHVZV0RPdnYvcXE0TlhLWWovQnpKYkV2bTRtTGJnR0tZU1VoWHk3UzJHR1FZ?=
 =?utf-8?B?dVlpSnAvRmhVVHBTUjlzVExIdkQzUXJiaGRPZ3ZNOVNTeVhydEpDUjRvMGdO?=
 =?utf-8?B?SmRjaDRkWkY4eGx6ZkFCTHVROVdNdkdldUd5OW4zelpORVRPSmwvQjFEczUw?=
 =?utf-8?B?SVJ1dUE5bURQb2Z3Z0thU0dSbHNYNkxLMy9yUGFhT2dRRzdXRWFHRFMvaXVX?=
 =?utf-8?B?dUwrVUVwKytYR0laNFFDayt6TFFDYnRlWk0rbEo4eVhBdXU4ZmtscVk1Zjla?=
 =?utf-8?B?ZldBcGR4K2xQTWtYd3lYYkdaMExjbWxGemZIWTIvM0JUUGJkOHNlRVZtMVVV?=
 =?utf-8?B?aEIrVTIybC9NNU1hakt0V0svcUhhQkljUHcyRnhyd1FlaDd6MGNTN0d0eXhz?=
 =?utf-8?B?SEcrK2VFais1RE1ZcFV6SENPS0d5TnB6c1VKWG5Iamo1RG1vWU1YNEdaWFl1?=
 =?utf-8?B?ZGxKL2NzVVhpV0p2TjdMc25CMjlVdCtkN2lQalFxdTJ5QVBKZXltZzVrTFdp?=
 =?utf-8?B?dXRjc01DNUh5Zi9TcUl5Q2paYVdnM0dSdVhCL2NiTER3ZzVYUStBY1E4OWhM?=
 =?utf-8?B?c25YQXVhcjdhWUxGNnp2Z0wwRTVNUk15dGtCaEJUbkxram1lN0J2TUR4a2w5?=
 =?utf-8?B?bmNWOXk4TGVXdnpLWDA5M0tsUTArUnZCdmtMUDRBV3RBS2NVb29odVpNTzVn?=
 =?utf-8?B?OEMwM0NuV0Z6ZU1qajcrNlRmalhHRGdFKzl5bXNlUysxcnNPYm1KQmFBTjlD?=
 =?utf-8?B?aDNlWlh4eE1VamxrK3BtTW9NSlBNdmZBMFA3aDljRUE0M1hTd2ppbFFxN1VW?=
 =?utf-8?B?NEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3933b8c6-e9e6-45a0-742d-08db3c508bc1
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4538.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 18:54:44.4823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GR2pz5hEDtyL+UhHtD4xfXomt5unj0wU+d9AGisBzq+BKK+UdE1D/pjCheDx4xCQFhXrjUtcy+Os1QcTjZWt7Imdqej/cnK/LJPWawZVD7A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5216
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



On 4/12/2023 2:36 PM, Shannon Nelson wrote:
> On 4/12/23 9:58 AM, Tantilov, Emil S wrote:
>>
>> On 4/10/2023 3:12 PM, Shannon Nelson wrote:
>>> On 4/10/23 1:27 PM, Linga, Pavan Kumar wrote:
>>>>
>>>> On 4/4/2023 3:31 AM, Shannon Nelson wrote:
>>>>> On 3/29/23 7:03 AM, Pavan Kumar Linga wrote:
>>>>>>
>>>>>> Virtchnl version 1 is an interface used by the current generation of
>>>>>> foundational NICs to negotiate the capabilities and configure the
>>>>>> HW resources such as queues, vectors, RSS LUT, etc between the PF
>>>>>> and VF drivers. It is not extensible to enable new features supported
>>>>>> in the next generation of NICs/IPUs and to negotiate descriptor 
>>>>>> types,
>>>>>> packet types and register offsets.
>>>>>>
>>>
>>> [...]
>>>
>>>>>> +
>>>>>> +#include "virtchnl2_lan_desc.h"
>>>>>> +
>>>>>> +/* VIRTCHNL2_ERROR_CODES */
>>>>>> +/* Success */
>>>>>> +#define VIRTCHNL2_STATUS_SUCCESS       0
>>>>>
>>>>> Shouldn't these be enum and not #define?
>>>>>
>>>>
>>>> This header file is describing communication protocol with opcodes,
>>>> error codes, capabilities etc. that are exchanged between IDPF and
>>>> device Control Plane. Compiler chooses the size of the enum based on 
>>>> the
>>>> enumeration constants that are present which is not a constant size. 
>>>> But
>>>> for virtchnl protocol, we want to have fixed size no matter what. To
>>>> avoid such cases, we are using defines whereever necessary.
>>>
>>> The field size limitations in an API are one thing, and that can be
>>> managed by using a u8/u16/u32 or whatever as necessary.  But that
>>> doesn't mean that you can't define values to be assigned in those fields
>>> as enums, which are preferred when defining several related constants.
>>>
>> We can certainly look into it, but for the purpose of this series it
>> doesn't seem like a meaningful change if it only helps with the grouping
>> since the define names already follow a certain pattern to indicate that
>> they are related.
> 
> I was trying not to be overly pedantic, but the last words of that 
> paragraph are copied directly from section 12 of the coding-style.rst. 
> We should follow the wisdom therein.
> 
> Look, whether we like this patchset or not, it is going to get used as 
> an example and a starting point for related work, so we need to be sure 
> it serves as a good example.  Let's start from the beginning with clean 
> code.

Got it. Will convert to enums in v3.

> 
>>
>>>
>>> [...]
>>>
>>>>
>>>>>> +
>>>>>> +/* VIRTCHNL2_OP_GET_EDT_CAPS
>>>>>> + * Get EDT granularity and time horizon
>>>>>> + */
>>>>>> +struct virtchnl2_edt_caps {
>>>>>> +       /* Timestamp granularity in nanoseconds */
>>>>>> +       __le64 tstamp_granularity_ns;
>>>>>> +       /* Total time window in nanoseconds */
>>>>>> +       __le64 time_horizon_ns;
>>>>>> +};
>>>>>> +
>>>>>> +VIRTCHNL2_CHECK_STRUCT_LEN(16, virtchnl2_edt_caps);
>>>>>
>>>>> Don't put a space between the struct and the check.
>>>>>
>>>>
>>>> Checkpatch reports a warning (actually a 'Check') when the newline is
>>>> removed. Following is the checkpatch output when the newline is 
>>>> removed:
>>>>
>>>> "CHECK: Please use a blank line after function/struct/union/enum
>>>> declarations"
>>>
>>> Since it has to do directly with the finished definition, one would
>>> think it could follow the same rule as EXPORT... does.  It might not be
>>> a bad idea at some point for static_assert() to be added to that allowed
>>> list.  For now, though, since it is only a CHECK and not WARN or ERROR,
>>> you might be able to ignore it.  It might be easier to ignore if you
>>> just used the existing static_assert() rather than definigin your own
>>> synonym.
>>
>> OK, we'll remove it.
> 
> I'm not sure 'it' means your synonym or the actual check.  The check is 
> a useful thing to help make sure no one screws up the API message 
> layout, so don't remove the check itself.  If you can't get away with 
> ignoring the checkpatch.pl CHECK complaint about the line spacing, I'm 
> fine with leaving it alone.  Some other day we can look at teaching 
> checkpatch.pl to allow static_assert() after a struct.
>

I should have been more specific. I was referring to removing the blank 
line as I think we can live with the CHECK. Your call I guess.

>>
>>>
>>>
>>> [...]
>>>
>>>>>> +/* Queue to vector mapping */
>>>>>> +struct virtchnl2_queue_vector {
>>>>>> +       __le32 queue_id;
>>>>>> +       __le16 vector_id;
>>>>>> +       u8 pad[2];
>>>>>> +
>>>>>> +       /* See VIRTCHNL2_ITR_IDX definitions */
>>>>>> +       __le32 itr_idx;
>>>>>> +
>>>>>> +       /* See VIRTCHNL2_QUEUE_TYPE definitions */
>>>>>> +       __le32 queue_type;
>>>>>> +       u8 pad1[8];
>>>>>> +};
>>>>>
>>>>> Why the end padding?  What's wrong with the 16-byte size?
>>>>>
>>>>
>>>> The end padding is added for any possible future additions of the 
>>>> fields
>>>> to this structure. Didn't get the ask for 16-byte size, can you please
>>>> elaborate?
>>>
>>> Without the pad1[8], this struct is an even 16 bytes, seems like a
>>> logical place to stop.  24 bytes seems odd, if you're going to pad for
>>> the future it makes some sense to do it to an even 32 bytes
>>> (power-of-2).  And please add a comment for this future thinking.
>>
>> We can change the name to reserved to make it clearer, but the size
>> cannot be changed because it's an ABI already.
> 
> That's fine - just make sure it is clear this was intended.

Right.

Thanks for the review,
Emil

> 
> sln
