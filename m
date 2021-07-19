Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80DBF3CF278
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 05:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241912AbhGTCfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 22:35:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:48520 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1388984AbhGSVKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 17:10:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10050"; a="232912355"
X-IronPort-AV: E=Sophos;i="5.84,253,1620716400"; 
   d="scan'208";a="232912355"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2021 14:48:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,253,1620716400"; 
   d="scan'208";a="468735692"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga008.fm.intel.com with ESMTP; 19 Jul 2021 14:48:18 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 19 Jul 2021 14:48:17 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 19 Jul 2021 14:48:17 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 19 Jul 2021 14:48:17 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 19 Jul 2021 14:48:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BGKkpVIs0w3fbSw/pFW2/IxbqOfyyz8INdJk9MuOJp9M3TjPlNHXibN8snfDYUTiPqi68NdEIJ8NOfmf6AFAfybrg9vEQeqv/Yj68Fhij3u87mh1nef3B+g0xaiF9X/ywnyhgDDTYpFC+op9+lnypqEbO9A9qjEAgLysHjueYRrchIGcZOIrzAVQI8q6b96e7A6cADeFvXRQO2UsYISAVR2nrzsLDb4M1cOireoacoKee2+bR0Z5i/HqlTKUOdqhPx2Wj0kBXLHTyxgCV7v6++TpuqnLvS+QIAhYrNhRhPs0WiU+JZpwYzlq2JrwgOEpuP9qL4JMDEpeNsIGAlWmPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=smTLDkUeHZRU3ZS3NWn7N7SB/3VQ927+WPv2f+EUKwY=;
 b=iceLkHzyqQvwsek+YvYk/ucJ2Jx9MsZWyM1pSbKZaeOzck4xviG/sLHXW11vJG0s5gVWUgu9+yAL9DW5qs9ZorSdZ33bKKgKwXYydWGPuwtDWgx+s15/+6AS/I1BmDZpx7NoqhKRS7qFWUM8dYK4+7U0hm+W5BWYhAe/wFhcZpdEkfCYW0RkYxk55oE7V/g1Q3bB1ELZJBfCoihnbIbTAsGN6A2rOFTQnK8xj0CAnw/xfT3hk+4EwFMzUCKQO3kd5KKdEkZFYXUuoHMIuLoPmo1lmnPqHm9/k8j+pKBli+dnmxk9mRLcAhdI+3ngJwipPXgRf0l8GD68Y93P427gUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=smTLDkUeHZRU3ZS3NWn7N7SB/3VQ927+WPv2f+EUKwY=;
 b=dLijm1hAA0ceqKYYHdSHqv7uHwPueu6ml34NIdj+sHflS/8UdVE/YN2T73V3wqpz4Z6GTIKVu6cNmpgv1yZs2hJyMGzM/ilhGPkpdlfywbQaNFV1hBeipCNFPFmmiyfKnFhafa7O2z+N1esFYlpFsvA+AeXDX5cl2rGK6YKKas8=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by MWHPR11MB1744.namprd11.prod.outlook.com (2603:10b6:300:10e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22; Mon, 19 Jul
 2021 21:48:15 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::7405:432c:f34a:b909]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::7405:432c:f34a:b909%6]) with mapi id 15.20.4331.033; Mon, 19 Jul 2021
 21:48:15 +0000
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
To:     Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     Kurt Kanzenbach <kurt@linutronix.de>, <netdev@vger.kernel.org>,
        <sasha.neftin@intel.com>, <vitaly.lifshits@intel.com>,
        <vinicius.gomes@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
 <20210716212427.821834-6-anthony.l.nguyen@intel.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
Message-ID: <80801305-c0fa-8b6f-a30e-083608149a4c@intel.com>
Date:   Mon, 19 Jul 2021 14:48:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210716212427.821834-6-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: MWHPR21CA0048.namprd21.prod.outlook.com
 (2603:10b6:300:129::34) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.214] (50.39.107.76) by MWHPR21CA0048.namprd21.prod.outlook.com (2603:10b6:300:129::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.1 via Frontend Transport; Mon, 19 Jul 2021 21:48:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f1f0d90-f7a6-436d-f821-08d94afee985
X-MS-TrafficTypeDiagnostic: MWHPR11MB1744:
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB17443C64133DC61B111B852597E19@MWHPR11MB1744.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FR/9Sm0xG9EjHNYMbm/ZgqLilnedzxH62erVgzbES2m60P33qQI+xlWuAeTVV+D6cnaKH2b94pun82dRcYtXjiaiGV5mBQGfYAF4ihWV2xlaEZN15QuVnlTzkuEeNV/9++335cqkFnMqCRc32Ngai7ZmdnK7KB9PvL+vQcF0jhWSa7pqFYbzclqPMjF+55kI/Dx+ofuCj1sT1HmSH8q+GvXgoIJKQa90G9lv0HwQRH0jv8zLxYHTNC271EFzRmUuif3VaZr3LQK3xkJRWh4Sp2w8oCLrW0V4OTobi7OQYl+qBNvoVo1n7cJz5fPhFK58F5JPDg00GnK/B4/+n/C8l3vAMD4svXtHD6XCb5zB8tdCNl5hTpXhX558UX2eVdyjpFoEMHNrzgM8jUFiiSfEecTO49ENFhnspHYfZnupSIHgUpdqy4VpbPbkQKsJeQqHVxFxOa+pOWibLSwMDdvVqBVe/DT3cEta7XVPy5GbS2sUvF/itZdpNjY7QOZXk6NiVkvv1LxvLNYOuVXyaxnFOIAKt44WFLDgtfCBQNDtsdazBSWJEzmLy0+J2U5xS/OHBuidOL3jTsnue50s3IEP2LjP0zsGyQe3ETt4fuby77nn/1+vJnpMYvcK0GkAjo0wkN9ngjBhotkSMBcoUsWZk4GBD6Z2qpBVV/Ygc8nqEZPrTTcv9WOt3rvbUs6GEg8QJTCUGuunLRkvh5TOZFml7j+nNjOb+tsYJ4OE/eBLMUoCVeuO9O7A73Uu7BMEBiyx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(376002)(136003)(366004)(31696002)(31686004)(66946007)(66476007)(8676002)(86362001)(4744005)(5660300002)(38100700002)(6486002)(478600001)(53546011)(186003)(2906002)(54906003)(16576012)(36756003)(44832011)(316002)(8936002)(26005)(956004)(4326008)(66556008)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emQyellNTUhtVlpkbm5yalVTMUN4c2xGVEZGZ0hsOGxhck9HMzZKWXA5NVpz?=
 =?utf-8?B?TGFPYVNBb3ZaU1ZhcVN5UEhZZlBwS3c3TnYrUkpURE5uU3g5THA1cmxFN2sv?=
 =?utf-8?B?QjBEZjFBVmp6aEdqMnU5aC9hc2djTnI0U3hZbUQzR3pzYlptYU81ZnQwTm0y?=
 =?utf-8?B?MldoNFF2WCtvVDR6Z1Nrd0doRkFyQ3FCNkFnVWZockZuNWZJeUQxL0dqblhF?=
 =?utf-8?B?TWJMTTE3S2VpUjRYeVA4bzhlSHJJTDRtQ1p1QndVblpYQ2NibE1TcThzUE5q?=
 =?utf-8?B?VGc5bnNHeEF0SDNyMmVvRE0zNUpRVTJCbFRGZHUrVUZlYnlueUs4cWFaY1Nl?=
 =?utf-8?B?cThkYVl0Z3EyUDhFZmVNTE0xNU96ZEdvNDAwN1pjR0IwMXdIaFVOVUFDMUxu?=
 =?utf-8?B?ZzJUaFNuRVhWV3hFL21kUitkaXVUUHV1MUU5ZEI0R0lidXZFTDlseHZVQkdD?=
 =?utf-8?B?enJsV0hlcTA0VHdjY3BVMm1FZHYrb2hTcnBZYW1yRXZpWkUyWHdxQWNpaFBv?=
 =?utf-8?B?bEFUd0FmZVluVlQ5dms3QUNKaVBOR3BoVVJtRlBFRlhvZSt2TGRPeTBDdlZB?=
 =?utf-8?B?UFFtYnpEZlRiaUhoVTcxS2Jzei9sZjlCL1NuOSthLzl5bHZVVVlBdHQ0Tm45?=
 =?utf-8?B?TVlEMFhiVWlnRUdJZVVuTVdFL09yTllWMURnY1Fqa2ZBeS9IcDByUnFwelc1?=
 =?utf-8?B?ZXAyZWlvOWUySFpmdnkrZk5qc3R3WTYyRG11UFRFYWhVQ1d0RTcxUG96bkVq?=
 =?utf-8?B?eExKNnpCaU5VZllmOEdNc3hQYkI2STBaaWJRZ0lKd3FBd1JsUUl6UFUyM2hD?=
 =?utf-8?B?WlJyN0lDK0h2RU9RU2x0bDk2YU9KN0NNSmsyalh2TDZyc3hQY1NOWjY4UWtO?=
 =?utf-8?B?SGw2Y1RmSVJlNzdFY2NqNWdVUWtTV0dOS3VIbXJOdUlkcDBlWmZ5Q1I3OTFa?=
 =?utf-8?B?ckhiRlFzZTIrczMzVDZ1NjZFbXRoL2dxa1AxUjBPem5hS2ZJSnltdE4zSE1Q?=
 =?utf-8?B?Z2FvZGI3ajhiQ1hxV09aY1dmaUxLdmhDbnpKTVlaRHdnaDEyRkppaEh3Um95?=
 =?utf-8?B?ams3ZFBBanpvQlNad0NiaDZnVVRHU29TR3lJSnllcDRzbUMxMzlXUjZMUytK?=
 =?utf-8?B?MDZ2QXZOZno2T25CdTNRRFNYNFRqZnh1ZjlhamVhMVoydERQVXcrZldJbjl0?=
 =?utf-8?B?b0ZOV2VmVjhreXVuN2Y2UDJpQ3VIaFJwMFYxRS9kZDlnOGwrK2FyR21zZENG?=
 =?utf-8?B?SUo2ODByZDVURFhBVDNvRzJiU2NYaGFnc2hJbmtuWTU0MHQzOXNPU2tjdDFY?=
 =?utf-8?B?N1RqNDdJcEtZdGUya1luYWs5NXg3SERIOUpSekNwS05sTDNNaEJDR3FjL3FD?=
 =?utf-8?B?UlUvTlduNy9BMk5MRDNJVW4wMytCbmN4d2pzdHE2dm9pVXBQeVA1RnA0TTFt?=
 =?utf-8?B?NU1TM0Q3L0VtTit3ZzBwc1ltemJobzVUa1BIbWVtbFN3WDhhcFBMNFlHdjhx?=
 =?utf-8?B?WTgrOUl6bWRQcm9kRmw2VmhETnh5S3V6MjNkVE03b3A4NEhTN3UvZ21Pcy9m?=
 =?utf-8?B?ZitlWVdLRStCMU8ydVJ2S2VFOHJ1NGltblJXQjIrMWkzR1hRakJIdU5MYlNO?=
 =?utf-8?B?R09DejM3K2JFS1FsN1FlUFFPNXU5amFxZWd4ZmNUa01Jc2htYkxuZGs0QnFX?=
 =?utf-8?B?RjF1UlpUNmpiZ2k5dWc5Si90cDRRRGVqd3ZaWk9WSG9vV3R0alBkUjI0K3Iz?=
 =?utf-8?Q?sayb7I4JY0+QxeUxOzjvWxR/5/5TJeZvbwIffC2?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f1f0d90-f7a6-436d-f821-08d94afee985
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2021 21:48:15.2224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NwEbKgHxpNYLFqthXk+WUVH1Fje89epUXFxwC4vUXBbfhXwCP6pV6jBubo6Q8VS1+8+MKokyJuGCpQ0rQ407R1eOXeUMh68IrrtXQS8U/Tc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1744
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/16/2021 2:24 PM, Tony Nguyen wrote:
> From: Kurt Kanzenbach <kurt@linutronix.de>
>
> Each i225 has three LEDs. Export them via the LED class framework.
>
> Each LED is controllable via sysfs. Example:
>
> $ cd /sys/class/leds/igc_led0
> $ cat brightness      # Current Mode
> $ cat max_brightness  # 15
> $ echo 0 > brightness # Mode 0
> $ echo 1 > brightness # Mode 1
>
> The brightness field here reflects the different LED modes ranging
> from 0 to 15.
>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Just a few hours ago, Kurt sent a revert for this patch, we should just 
drop it from this series.

