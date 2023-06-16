Return-Path: <netdev+bounces-11309-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D1C8732870
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 09:09:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3EBD51C20F34
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 07:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 904EF568D;
	Fri, 16 Jun 2023 07:09:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9D1624
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 07:09:52 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCBEB35A3
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 00:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686899387; x=1718435387;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IcnCYuTSQKg0uyl6tU73+Hfr/iTtgkkIx6xV+xjcSQM=;
  b=cDnIF/STy9BKV/WZWUiLMJ4r++Lj8g6xVu+wp2vhMevg0T0BmvzdQ2z/
   bzf2aSiI33n2ha3IbYZaZaahuBp5wIPc8w1/r8DCPPloofxyNdTLqvzYe
   gGjHAfDnXd6q1vyw9JUCS84TGg4iqLitds0IB7N4bFLmZr/3YifHEzMnA
   qzE1WvqdMWmrlcq9C/fn/+7LTDTE/aAXIlNUNDvrBBpLSaTepin+LK63z
   ybBMLRsaRDp5cZONAWdUXcBZN/yDjQxudJEQ+K8ZDpsDh9UeSF5NcpElk
   W7AEJhVg4vHL+WQ67w4Ja7VRskrIqhb3YLZjYqIUInHzbDO0UDyVP91TF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="425082284"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="425082284"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 00:09:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="836917083"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="836917083"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 16 Jun 2023 00:09:47 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 00:09:47 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 00:09:46 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 16 Jun 2023 00:09:46 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 16 Jun 2023 00:09:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fq6OCQWLpZCP1r103E5t512qynY2bx+UmuIyjJi5ULtG+YL7KE7lyaxUe6OYzAMegt61hSrteD+jloUeVDDddmSBTmkk5Hss1UaxM12EY+WMELi2rZuk/xrUyC6/RZ40wGjTKAuRczkvNQVnGwvBvLtYtaLZQXisNk1jBBWZSkJClcOsdyQkTDzfkfZDd411DVrp7X7+POCx4PmMo/puydEZ3tsxcMtnlY4B1ep5ozhjsVnEekt+Lsqp+FQ/XkplVLwQSsKkvQLv43EENLPGp131VotVcaafZLnxac3wWQdB9gfrlfMgl4H5aRH03VyMT2opvAQr2qMMLmtn2GT12g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QwOkGV+wIh6sZIxjLjLTfFpauhnqkeonUOZYnYaBFNY=;
 b=O/qnEv0WGER+YiYcAwpShbgfxklb/Y7YqV6P7EXsy9xltr/4oj/47y6uR3dmRctitev3VhX41O7K6k2oqK5LwA+zU14fKBger1NY4rFmdTHetkq7BHJHoWOu6e1KV3yTvh7HrPZKbgn+JljsfDjXdHvng00zHXFgpjPlMbrN9/RCiAu77l6kSlApu/gCkxZZHqLPLvjkJ1yliqHc9bOYhAdoTU7tWQEeFx/75MbvOJmJGyx0yvBbLLdM6Xg+TC2asxe18LmZClLpuLQIpqaxP+cRh9NEf5FxCq0WhLRio3qTil1UmZPXQCerGIUaNo8KHLVsM5fhUOX098YlO/Glkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3672.namprd11.prod.outlook.com (2603:10b6:a03:fa::30)
 by MW4PR11MB7164.namprd11.prod.outlook.com (2603:10b6:303:212::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Fri, 16 Jun
 2023 07:09:44 +0000
Received: from BYAPR11MB3672.namprd11.prod.outlook.com
 ([fe80::87ad:6b1:f9f4:9299]) by BYAPR11MB3672.namprd11.prod.outlook.com
 ([fe80::87ad:6b1:f9f4:9299%5]) with mapi id 15.20.6455.030; Fri, 16 Jun 2023
 07:09:44 +0000
Message-ID: <d5b2b152-4325-a32d-3daf-e4629ad4818d@intel.com>
Date: Fri, 16 Jun 2023 09:09:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH net-next 2/3] iavf: fix err handling for MAC replace
Content-Language: en-US
To: "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>
CC: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>, "Romanowski,
 Rafal" <rafal.romanowski@intel.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "Gardocki, PiotrX" <piotrx.gardocki@intel.com>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
 <20230602171302.745492-3-anthony.l.nguyen@intel.com> <ZH40yOEyy4DLkOYt@boxer>
 <29e3a779-2051-d4bd-08fc-2835b05de55c@intel.com>
 <e5f6407e-e19b-636a-a90b-3d1d6f7beca0@intel.com>
 <DM4PR11MB6117A7B1423198E6478E4FDA8253A@DM4PR11MB6117.namprd11.prod.outlook.com>
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
In-Reply-To: <DM4PR11MB6117A7B1423198E6478E4FDA8253A@DM4PR11MB6117.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO3P265CA0025.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:387::6) To BYAPR11MB3672.namprd11.prod.outlook.com
 (2603:10b6:a03:fa::30)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3672:EE_|MW4PR11MB7164:EE_
X-MS-Office365-Filtering-Correlation-Id: fc73cc32-c114-48fd-f496-08db6e38a985
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 91xIMG/5BTv44Qx4TQ2K3x4FudKjwzJsCJhcbaSxURBx79tWchAzF7vCuRix0ZW+KMKh+hqC6XaYcB1ThyHSzaZSH/lYKbD4hKtdHaZhW02GK6fltU+fs/Aay5nGp04gPSvO304ANyG+rWeOhBTeKAo2n8b8zlLBWxwh1dt1L0jK/es6aNUYDU3XJwTbgKd78QTYyiCoPeGKlA/CAbK54ZXAjN8gFtB1Xx5tjSOey6MYxl2Btdc1lcRdU68N5PSzExtMXrxunl+t9+7x5/VZLjslFtWFxCHi5X9s7a6BjgL3ODUHuGYLYuz7UAc4ncwldxEmtPM4URRY2R98Bh62Xissr19Z5g87g5ll+UleqFfA2G4A+LyZ+UqVPxgQsINOJYIZzz71E9RWt9TcquMoe7CZBZpOrIN7o1B+QIT26F/W/Nyf/W+ZukYtNGuLDEdXTvmcM7LxDxC3BzC2Vfe1P+7y1NoQL6d/gKVK7+GkI+LM2E+GbSbwIsu73yc2pXQ4A0vmbXX7OxiZ/OLbvu7FRzVsa0CIeY9rMliQY99prXri1JJVox8ANV62BBs9tUbnQ7KlD30yeJx4wMOhUAaqiBQ1KuSUTgH/dqHXIHUSF+8v1J5eVYwFu3c6mRJSSlrsRQxdqpUanNyHI5nTP/XWhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3672.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(136003)(39860400002)(366004)(396003)(451199021)(36756003)(38100700002)(86362001)(478600001)(8676002)(8936002)(41300700001)(6486002)(31686004)(82960400001)(6636002)(4326008)(31696002)(110136005)(54906003)(6666004)(316002)(966005)(5660300002)(53546011)(6506007)(6512007)(186003)(26005)(2906002)(2616005)(66476007)(66556008)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHdvMUJ0UW0vNTVadHhSL0IzQ0ROdm5tcEwwVXF1NGZvZ3VqOTdsV2NyRUJ5?=
 =?utf-8?B?dUdsKytZSUdKQTFLN0s0dzBSa3EzZWZjN3FJdXRDYWF0SnJ0eTVVb1VNa0tP?=
 =?utf-8?B?eGZHUG5rU3IwdVl6TExTeHNxWks4c1pQMi95b3RWQU1LZHhVcHQ2aWwvK0Vo?=
 =?utf-8?B?U202ZVlLM3dvZTBKN2hQdXVxT3Bjd1c3emxrV3lXbTNYK3ZtdFdZd1dpZGJx?=
 =?utf-8?B?YWhDMjJ4dzFhVk1INkNybEpJU1UyTE9QTHNKVTkwRUpRYmR1Vmk5Q2Z4djBX?=
 =?utf-8?B?a1VXTWtqeGlFbFh3VkQwaENuNVZKdmd6WnltRjVUbzVUWit3cXpaWHpWRWtz?=
 =?utf-8?B?aTZyK2paN3dsS1FQY2kweSt0TFV1WGNtOUtNb0c4eWVCQTRxSnhsUExheUp2?=
 =?utf-8?B?SXJFT09sZU9JUUZCWEtWcGg3TnF5NE1wblZRWUZ5YnJ0aFZpNlJvNWxVVlFG?=
 =?utf-8?B?c1JqSEtFejh1dVoyWmhHbEtUZmI2NFVMNFRlWlBNWW9iY0JPd04rTnZ4YmM4?=
 =?utf-8?B?T2g0bFVGTDBZSlhycUNhUXVwTkFqZ1VWR0lWRjlmd2V3UGZ4R1lpUFFHT3Fo?=
 =?utf-8?B?emkrZ2JHamxXL3lZZ2Jma2ZsNVkwY1U2VytwcGFsM1lsV3lkODRQOHVyZEth?=
 =?utf-8?B?NkRkMUN5a1NWYjUwcFExL2dWQnlnNEd4cXQrVVQwS1J6dklibXY3OWliMTd5?=
 =?utf-8?B?NW5oQkYvbzk1aG5NTmh4VmdiRVNIUUphd2xOSXNFM1hlcVRiQmVlTmhMTXU1?=
 =?utf-8?B?Sk1NNlN1YnRoTTNOWVEvU0pad2RJb0U1djQybUFqTVRlcmIyMzU1Q0FNM09h?=
 =?utf-8?B?bFlFeS9rMDMxT3Z6R0E3QjdCcSt3SEN2N0dPRjk2d2VWVHpVWDFBMDF2aS9N?=
 =?utf-8?B?QTByM3FBVjMycmttcGJmNStKQ2M5cnBRRjZIdlEzQzJlUkM5ZW1RaDJqSUla?=
 =?utf-8?B?aGY0M2pDVWV4T0VxVkVNbFlKa0ZrZGVuYm94WVRBUjZ1Z0JrOTBNYlhFcElk?=
 =?utf-8?B?Wk1KSFNBWWhJWmpOZTViUElzWlhaK1RObzZFaXlPaU1XRjBYdUZjN2l0REYy?=
 =?utf-8?B?ZlNrbXBBemY4aTNmaTZDNTJLbUMwbVM4Y1MxRXRqR3NYSStuNzFTdE9yTkRh?=
 =?utf-8?B?cFlydzdvekZrSFlUSEhOc2FpRHMxZ1dTcU1CZVlxZ2tkeFpHdGh3TmZrWTMy?=
 =?utf-8?B?QmI4dXZPKzkvb3UxNEpqdllyZXRGZ2xBbmo0MzdXanBGa2htanFhTVdsMUk0?=
 =?utf-8?B?d2E2aWVsaC9BdzNQT0FOeVNVZElCZWJxUERocDcrQUg1cnE4bmpwMTQvVjR3?=
 =?utf-8?B?VDlYYXpWaThRcjVnOWo3MmhveUFmYUVzYkdjeTV5czNXVEtON1JRdndqcG5R?=
 =?utf-8?B?UVMxT3M1TGNCVkNEUmlvTmVGRGFQWXhKTnZPbGc5bUdXbGNBaE1ZZk1BeFZk?=
 =?utf-8?B?RGs2b1RnZEFMSVBBaVhMSnNBS0pPZERJNEdYaUhHODdNWEJUajg0dTdXTkFw?=
 =?utf-8?B?MDRFMHFLRkZYa1dvVDllZmVHT0JoU2xuNGFNL2NJMUR2aDVkZU1nOW05Zjhl?=
 =?utf-8?B?RFBwREx6dC8wN1FhdWR3Ynk5ZXRGZDJUN3dWakMxdmYyaDNsdTdzeDRrSGdz?=
 =?utf-8?B?TEpJSld5N1pPckViUkVseHF0L0lFc1ZISWw1WkpISUVDR296cmRJNk5uendC?=
 =?utf-8?B?bjJUMDdOWFJpZ1FVeU9uUzRraFZYR2lwWlpWbWRqVWVWQXRpNGY5ZllVZFVi?=
 =?utf-8?B?Sjc4aUI4SHNTcGJ1L1FkZzhLN0x0V3Zsdkd2RW12L0lMUGRPZDJ2V1kxUllq?=
 =?utf-8?B?c3JOTlpHSTE2SHlZMmUyNEJCTUJuaXFVZ1NjUXNGLzZHeTZtRDlhQTF3UTZa?=
 =?utf-8?B?QlRabmdWTHdUOHJUbDZOOEtxMzRZMXQwMHQxRXo5OHd5bGxBQUNVMEMxMDFZ?=
 =?utf-8?B?d1JHUVg0QVkzV3ByUVNUM1dNeGoxUUxDMWVPNEx1dTM0Q2QwQzFrTjArSE1M?=
 =?utf-8?B?b3lDQk93TnZreW80Sjl5eEZEb2x5N1VGUktINUFEMkNrN2k2ZEwvb3F5MDdT?=
 =?utf-8?B?OElITDM0UHU4Tm1PTXUvVDFEdWROcDQ4cWF3R0xlNEpXQTNEZ1lNdVppYUh6?=
 =?utf-8?B?MzV0b3hrdTlLQ3QzdUlrSXZnOFVZcDNSMGMvNWdEWkhabHhnbnE3cWdsWDMw?=
 =?utf-8?B?bmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fc73cc32-c114-48fd-f496-08db6e38a985
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3672.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 07:09:44.7358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 090d6EDUYhJgZYD9wmmPuzWcAO2oC479ucSeoZDbviFrASk16f93KH3Yyu6ZOZG8nVAY/GmdrpC81I7zo/fIGPxVFApiunYujpl4molvq6A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7164
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/7/23 21:08, Fijalkowski, Maciej wrote:
>>
>> On 6/6/23 12:14, Przemek Kitszel wrote:
>>> On 6/5/23 21:17, Maciej Fijalkowski wrote:
>>>> On Fri, Jun 02, 2023 at 10:13:01AM -0700, Tony Nguyen wrote:
>>>>> From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
>>>>>
>>>>> Defer removal of current primary MAC until a replacement is
>>>>> successfully added.
>>>>> Previous implementation would left filter list with no primary MAC.
>>>>
>>
>> [...]
>>
>> Tony, without Piotr's patch for short-cutting new Mac == old Mac case,
>> supposedly my patch would not work (we have to either re-test via our
>> VAL or just wait for Piotr's next version).
> 
> Would be good to share a link to patch you refer to + short explanation
> why this would not work (I know which patch you had on mind but not
> every other reader would do so).

Right :)

> 
>>
>> Przemek


Final version of Piotr's patch [1] has been merged into net-next,
so @Tony, you could re-apply this patch (Subject line here) of mine to 
your queue.

[1] 
https://lore.kernel.org/netdev/20230614145302.902301-2-piotrx.gardocki@intel.com/

