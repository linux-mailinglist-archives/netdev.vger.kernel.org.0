Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B135A6ECF3C
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 15:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbjDXNjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 09:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbjDXNi4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 09:38:56 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB8210C4;
        Mon, 24 Apr 2023 06:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682343518; x=1713879518;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+elBCmdgfGeYr0ubJkO/VQIqmPax8QU/dv3CpEB4Dcc=;
  b=cVEjCqEDscU4poCRC2zByG9ifbKH8J/z2dJJ+ofyB0IFdDfWDgjpWkUz
   e0K13LHJ2lCigbxKv1ySmOHWjG9xVT9lDMh8F1qPUAjlezoRME3s2fmNq
   cGRpvyLdOyZV5W57jvUjPwi6oQjWHroGFkP6jfn+cixJ/k+vb028zkOLo
   i1+DWM/1/BzjFRdsNyo7ue3GFFhBn/MZDk9iN7/sVSWDULjCkZVSK8k8L
   mXOfhd4Fy7Pc/q0Hifeh7WqM7GZS7MM72lhetlj2JBR39wGyKOcxh5dMX
   BQvu/IJsopopX445Ktg+0HCcJBfE1BWwsZjvR2cvVztQoADRvgTOQibKj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="343938408"
X-IronPort-AV: E=Sophos;i="5.99,222,1677571200"; 
   d="scan'208";a="343938408"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 06:38:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="867488128"
X-IronPort-AV: E=Sophos;i="5.99,222,1677571200"; 
   d="scan'208";a="867488128"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 24 Apr 2023 06:38:13 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 24 Apr 2023 06:38:13 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 24 Apr 2023 06:38:13 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 24 Apr 2023 06:38:13 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 24 Apr 2023 06:38:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C3B402yFbh+FmCUKtquDz+eXVVwtbEf8C/UbY1sa6gmJ/GqZ6hhQkFcLz8P/CftVBAq4NKRkg+4yjc/XOhPnrNKvhZtXrG5FilZGZFaD09f/QYBtB+eVlG12YH9x73NBKhtTTxecAiYE1Lkqejugbb0vuE0WXSLkPdRzghMBW4LFgBEpPqKCavRFXMeTfYTuMgzFi973c8ooZf1PvnZnZ6juteRDPFa3VUXrg4rl4zMnc6dLxXp+qw6e76TFRAZF7nwUfocng94piNT/C0VSBBfrBcWUt7SFB1L1pj37eB5PUkMBauEeae1k+I4gJ+74Z1zvpyeRMFCIlSLXJFFm4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1933oQuxtxb0WsDVa0bGlFq7pMSkhWU35nAj2cnkiUo=;
 b=f/2ZhUI3iZPwP0CzpQQVdFlQZWEryn7LY4gsWY39U3WyKvcEyLmX/iV+lYj+qRQr2sMJEA2Nl7XjLEl4vMcJdmC9l/bA/0mVmCc6SoyL2/OK3e3Xj9Dkq+rdemdepiDPZfSFfPhmRvIgho4Hhm0/w6PyWtkSa6Hjj+5v8frZHagJuFhXE+aG4f4IqQKxc5hKIaPKgcnOue83Ao9qe263QkP/rcfhupH4GDjdq5gOsS4tmqQL7eZXBMtBzDBvUSJJlSldtbCyzOubs9Be0f1wqz6YOZv+7u1LWPjQHCrHtr1p4H5tQ7OR8MK/OYa5PgblE8WAlJZQuY84IHadqvHmIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MN2PR11MB4680.namprd11.prod.outlook.com (2603:10b6:208:26d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 13:38:11 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::4c38:d223:b2ac:813e%5]) with mapi id 15.20.6319.032; Mon, 24 Apr 2023
 13:38:11 +0000
Message-ID: <b32703ea-2074-1ad3-621f-370bc2a14727@intel.com>
Date:   Mon, 24 Apr 2023 15:36:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v3] lan966x: Don't use xdp_frame when action is
 XDP_TX
Content-Language: en-US
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bpf@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <maciej.fijalkowski@intel.com>,
        <UNGLinuxDriver@microchip.com>
References: <20230422142344.3630602-1-horatiu.vultur@microchip.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230422142344.3630602-1-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0670.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::16) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MN2PR11MB4680:EE_
X-MS-Office365-Filtering-Correlation-Id: 38393c72-237d-46dc-faf6-08db44c92552
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 56GOR0hMfST954uwXYkLe9aC52yJJY6zjaCz3NVAgfmxZng8lh9NNurf+Rzq+0DmmHhtxgLe1ezzgOUs6XDRt7CEG+/GCL0o5DxxQGFIFjZjVdlI5wswzB8Zxmr8KjGgpk2K6WVo3xOVi4qSU07NYOHZ5vZV+tgz67Rrn6L4gyCbKjaLlVHs+klYj/Hb2MCtCoe7bNfI8Wxv257J5EWsb+c68WA8cMEK331X4sAnb5KmOjAMAFJ5D3tVtjkOPq/g2kFjqBoThppc89v2Zc6Dq+h1NaXOJmP6Affim0mwfctrvcVOPg9e/Y6+Lvb9HblhBz2srQFwL5efh5Jw/NbIf2NwXD87lvdZXDs17ycsLdM91CjVm9u+4DyU7N9vU+aI1bNpnAMI4Rm+aC+6dqMY3zGqczSQdalA3pSYD6oyRV715rMZ8fOU8NMfU5Z8NDJ9UZnV08P942wm7g8E+nbfOJgS40LVZng1+XO3oKKVePKqu96Hd8lqq5vXYBBQ7qhzNfuPKMnGO81VRQw3Cu8jkpIcusAfknaZFYu2V26ZSFjy98zWznBPwJibg/2Pz8XF86XIxiRE1sShaaeKpuzhvSqMwuC0y17NDS3jQnnMvU45NTgjFIbrS2++79emcCTGZ5/cAlcp293jz+yK9T7LKA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(136003)(39860400002)(376002)(396003)(451199021)(82960400001)(6486002)(66556008)(66476007)(66946007)(6916009)(2906002)(6666004)(6506007)(8936002)(83380400001)(186003)(8676002)(2616005)(41300700001)(26005)(6512007)(5660300002)(316002)(7416002)(31696002)(86362001)(31686004)(36756003)(38100700002)(4326008)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3FFMlVESTM0NjFNbWgyTWwralhsSVE2WnJzdkVnZFVsVEpldVJNY1NxWlRI?=
 =?utf-8?B?b3A3UUJ1NDdFSnJqRW1kNFJTRkN0QUZ5WkpiTFN5WmkwRDdkZkpZbnRkWEpU?=
 =?utf-8?B?VURPWHRzQ0xrdnViM3R3NFRxVytXOHBMQmJNSm9JT0c1akt5VWtuaG9ENitr?=
 =?utf-8?B?d1B6MGY1UDZ3VDJCSndOdTNxYXRpcUdNcTF5UkMxcy9NSTliSE1MUGI2S09t?=
 =?utf-8?B?MWZncHJ2azZ2by8zZkdlcXdibWpaY2ttZXk3Y1pWVEI3TVk1Z3VaUzVDSHpO?=
 =?utf-8?B?TDJBN3VVeHBLQ3lyZDlheUswaDRhVlhvZ1FlTW5jSjFaU1QxMEN3RUxhbmxy?=
 =?utf-8?B?YTFkK0daS0t4bnVKN2hZcVliRXFpSzhFZmN5VDJGSHg3Z05nNmtZVHgrUHdQ?=
 =?utf-8?B?VTVQYjVjVndxdmxZcXhrdkFYSjF6aXg5QTA5WHovcHlSV21JVTVFV2E1OXN6?=
 =?utf-8?B?MWhxcFNTQnN6Qkc3VmI3enBZVGpHSkxCYUwyWFdzRDM5TTZsYWlIc21ZM1I3?=
 =?utf-8?B?UDNIRHJRazZMa2IraFBtZU15d21wY2NTbmgxQjRqUE1qNFQranpzUGxoTE5L?=
 =?utf-8?B?aHFYTWpPQTE4bGhyb21rRHYvNVNnVXJjQjlQZXgzMHNzekU2M2FtT2h0eUFh?=
 =?utf-8?B?S25YTjFUV0RqZW0xeS9kbzZxR05ZZ0FzSmgzOTA3Z3hDYXNNdXhyN0FNaXNr?=
 =?utf-8?B?OTROZ3hNSm1kM0hmOGx0RG9JMXBXY3FhOE1VNC9zblBHRm5xVWUzM3RrZHVK?=
 =?utf-8?B?RHZkUzRGSWdpek81UTB2VHVhSmRkRmZkS1NMTXNaRTV2TnF1SmI2Y0MzYkhm?=
 =?utf-8?B?UkhDYjBqd0ZNekIzS2tFeCtxZGM1dzYrVEpMbEdtTUJIb0o0TkRMdm5hbm9G?=
 =?utf-8?B?QncwQUV1RXl1QzBuZi94ZWRXL0dxYW9QUzN0Q2NFS3pFTUlGOE0vMXlWVHEz?=
 =?utf-8?B?TDlrdVZxa2FobjVBZzZLdXYvSkJzNW9kWm5laHo4SXlJVTJKdzdTSzRvRTlp?=
 =?utf-8?B?RGk0VFZhVUY3VWphaTU4RE5XQ2w5ZWtreHVYYzdMOGFQWkVSd0dBc1ZxVzhL?=
 =?utf-8?B?Y2ZxSHJmNmpuQWhQN1d6R3p5Qnpwc1I5elVtcnU4aGxiT3BKK3ZNR0VxSnZr?=
 =?utf-8?B?UFZlQytyOGFaVUo3dTMzMzllREJkUkxVYm5OSGFqWER4YTUvVllKOXQ2UkY0?=
 =?utf-8?B?YnB0Q1NlUGpPdUNBWXprYm1yWUh0azFHdjRsNWdTaDRNWnJidHV0eExWK3FH?=
 =?utf-8?B?aC9hRmhmczlzRVY0R3N2S2RTaUljcWVLVlhhMTNhWE9STWZXNDJYR1JzL0kx?=
 =?utf-8?B?MkNCbHBpZENwcWVFN0VIb2tORzNRUU1mQVcrencyaXNUNHlCKzRMWlRsRGdx?=
 =?utf-8?B?bWJhRVVobnh0YlYra29HNUJkM0NwbzJBcloxTEpZUFdZMnQ3QXZ5YnJPbHQx?=
 =?utf-8?B?aVVkWmhpWHNzaGVXdk83bTdCK1diTzZLdmg4VUEydXh5b1NrOXdOQTBzUmUy?=
 =?utf-8?B?UFU1UDVXWWVOYmdYUnRsbVRXbGxBcjRqVmR1OFRRZHFSeDQ0bEhuVG1leUlU?=
 =?utf-8?B?dXllS1haY0VqTjJER1cwL3RPRGJyUVRhR3k1aHl5a3RuYlVQdmhqT1VwMGEv?=
 =?utf-8?B?MXVHVW1YUEF0c2FiRFpEazlsZFJXWVNPaHdoZTlDVXNVeU10VTduV1NGd0Mw?=
 =?utf-8?B?cDY4b1ZCK2NIZGtEYXd0cmV3WWh3bjlQb0FLa05uS0c1dHFYK0ZDU25TTGFW?=
 =?utf-8?B?amlIRjVBZ3RMTzZiY1dkTlRmY1FqbFFSd3ZrMzJicHlKRFRDRnQzMEdTZm9h?=
 =?utf-8?B?amV4ekFVUFVLK0E0bTl0R2dZc21KTHRmU2FhMnR3ZWFJenF2aEdWTk1kcFNw?=
 =?utf-8?B?YmVCbVl5dHVEOW5hcGhRdHhkR0xmREo3cUFxT0VpK1d0L3pPdzBSNjJZK0xK?=
 =?utf-8?B?YUVzK0dQbTVpSWpoL2FuTDZBMi9kWXUzN3Y3THZGc3lHbkxZL2ZxNVpsOHRF?=
 =?utf-8?B?TFRnV0dQMStrdVhEaUVLK2VQSXpQOTYzUmRzODZQV3FnMjdsR00vYldkSHZO?=
 =?utf-8?B?WXBjc3VDcmFwQTNma2RnMlhrNFpMMTJCMUE4cjF2dTFoY0o2V2NJckd0d0V3?=
 =?utf-8?B?QmdCNkx4aFhKYkRmK3JvNUN2OE53UVZUTkorUy95cHcrMnd3Sm1QN0VDM3k5?=
 =?utf-8?B?cGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 38393c72-237d-46dc-faf6-08db44c92552
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 13:38:11.1232
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L8METFBrbSeyztuefLhQR051/T+6mgelknVWEe0Aq2L7YvIofr3Vel2wf0hshgwqaL3pxaUGBMWQltuJtR0bDZITcfXYvbxpj9rgUDtOYP0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4680
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>
Date: Sat, 22 Apr 2023 16:23:44 +0200

> When the action of an xdp program was XDP_TX, lan966x was creating
> a xdp_frame and use this one to send the frame back. But it is also
> possible to send back the frame without needing a xdp_frame, because
> it is possible to send it back using the page.
> And then once the frame is transmitted is possible to use directly
> page_pool_recycle_direct as lan966x is using page pools.
> This would save some CPU usage on this path, which results in higher
> number of transmitted frames. Bellow are the statistics:
> Frame size:    Improvement:
> 64                ~8%
> 256              ~11%
> 512               ~8%
> 1000              ~0%
> 1500              ~0%
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>

> ---
> v2->v3:
> - fix length issue when the XDP action is XDP_REDIRECT, this issue was
>   introduced in v2 of this patch series.
> - reduce the number of changes by moving back all the assignments to
>   next_dcb_buf
> 
> v1->v2:
> - reduce number of arguments for the function lan966x_fdma_xmit_xdpf,
>   as some of them are mutual exclusive, and other can be replaced with
>   deduced from the other ones
> - update commit message and add statistics for the improvement
[...]

Thanks,
Olek
