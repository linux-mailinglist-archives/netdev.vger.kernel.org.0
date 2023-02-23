Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF6C16A0CEF
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 16:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234688AbjBWPas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 10:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234589AbjBWPaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 10:30:46 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2659019B4;
        Thu, 23 Feb 2023 07:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677166239; x=1708702239;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+cZ8707FqieGyRTD9roVQkzyXZTjRxBc+Q2e3JB0IUo=;
  b=UYM1KkM8nyS4vE53bZl6CW9NYejAHv9XVQXzFcYXmvWEGcyslnqpA47I
   Pq5dKf+hlrTr0PoXSbe2Wfc5Qc6BdZu0/g/qqelUUn/M5HxG/3jI40xQ+
   W5JeKEanPpmB/qz+nap2hM8vt6ucmEuKMis4CbqSS7Qlpov+FLRDgHQ5/
   oXhnbEtUKl87YqcxLDl1L4gzgKsZj9GrOL5p1Evr6mupjZFdgOU7BY7Rh
   dJLHRqxEYMh9DdPZVf7mgDUSvEljXQYbc08ZNHzxKlZ4qCNH7LZH/D/aZ
   2/MWEhTRZFycpuKY301SPo1Zis46ucUTG3nfN4R3HQsnjFyG1PkslclBT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="419466265"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="419466265"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2023 07:30:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10630"; a="736407527"
X-IronPort-AV: E=Sophos;i="5.97,322,1669104000"; 
   d="scan'208";a="736407527"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 23 Feb 2023 07:30:12 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 07:30:12 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 23 Feb 2023 07:30:11 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 23 Feb 2023 07:30:11 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 23 Feb 2023 07:30:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j/b6cPpZnexwraTLo8owrg2KICH9NKG0L7wfPEWeVcDGZS/Q19omr1wlSq5ZtyYevk2lG9qq9tYoLCnFLXLLgsRc407ZPY4IVIStPl4/YKQ1nNp0uto5wfZga8D7Bj6Ff8q/dQMZukTM/r5KAP3uHxh/m1T4EEqcNCfzepfpqHSsSsAKuIpfPzdFz+HnBLmvFfKFSITKLj4m+HwpyzcIwsDOeEScvv7mNY6YKq1a+OR1t+3VzpbK6zjXMG8SiMTiHwyMpIyk1cgEuB+keuyD/byLICCs/IRojSUuIbeufIoHbm93c0HrPeu9OSPSLXGX9cVjIFu/PlUne3e8k8boig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nFuX6BayQ/vZgOgBGoONoyog6/qPoCwiGqHRLDt06ec=;
 b=SPUTZsGOxXdMrQ2/4SwAhe7bNeigVv3IxhipvG4Rq3Q5yRU1b7YdaHgBlRxtUqiO5GawgvEbdARTJDhZOAED3Pv0st0qgAY0lgJxmIr0aVC6RePbfWjLheLpCpB5Tl5OaoQuE/NIpvTRt6qP6RxXkpAYnQjkC7fpcZFaIaUYu5oC0rC72Jr+Wt8CHcTV0iHZ1yQyz7Cd7H8bUtFwVxvkTwLLKczFkR/PAD1u4UGF76flEO07zScbSQSwii7U6l4EdqGFWaoQwCtKmmDupxHcQuJW0V5ruQb80lu+hIk/J4Jl00wfyUWsnxm9nC0QNQShnESqt3Nz54Na5diNItbhyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BL1PR11MB5317.namprd11.prod.outlook.com (2603:10b6:208:309::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Thu, 23 Feb
 2023 15:30:08 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6134.019; Thu, 23 Feb 2023
 15:30:08 +0000
Message-ID: <9a433778-9360-6322-bb74-6e0f51614c8c@intel.com>
Date:   Thu, 23 Feb 2023 16:29:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] sfc: fix builds without CONFIG_RTC_LIB
Content-Language: en-US
To:     "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
References: <20230217102236.48789-1-alejandro.lucero-palau@amd.com>
 <ef38e919-f7ea-0b11-f5d5-2eb4fb665c72@intel.com>
 <DM6PR12MB4202D1FA796BF66E6AD4C6C0C1A19@DM6PR12MB4202.namprd12.prod.outlook.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <DM6PR12MB4202D1FA796BF66E6AD4C6C0C1A19@DM6PR12MB4202.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0370.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::15) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BL1PR11MB5317:EE_
X-MS-Office365-Filtering-Correlation-Id: e32feb84-6199-4fb3-1331-08db15b2d833
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JbGr+ixdpb3y6yOQ/VoqqyqbcY8FwYnVCpZ/UlFc9pRxTcRaewPEGgGCCbkYTqBOXi+yyh1Y1PRUejbAiw/mpf01Y40/KbU9MTUPboRpd+4C+jAETSyjfh0UZjQjOJBmx536jU/TA6PfM65iUk+wod/kyaNLe1Tm6rIax5r+YSRygQaUZfwRxl0Ia9+Y0Gox+WIgSCgzzdJy7gFDWv2CNMwLkHS2k4FpcJhWPHlyPR5i7/9mNtoOmDDzOz4JXpC5mP3ABC3urE2jBPoIk1no9cIEu7jQYlhikbv2Cbz2ZPgvQ+j+Gox4vqyFpKyc/W6ikXi/7CRKEEXt3IMs4GnV+QJ3ERomgiOROmTT4lsVBU3sr0zsYzGcZT4rxhGy503h007Hw4YHWKXniNg4d2xIzRbG9JHcSgIIHcpsDWsyCVdkhwhwFbKAmmvjx5ejFiMKfQksDtBMB2KxCD+yCWoFXR6SyqZdFnmSLxzbVOpiKek5wtpWOiGFhbjJY7tkSQV/T7QEJQnAP1ZFqEM6nRDpnLd3HN2BuAjDJyCQKMgp4kMChmI3Ik4z1wXbabdPu+LERn4yUQ7JiHjRS/Xb3BYxkMVHonsaXINoQwvvBy6luEg91lnuRjAArD4aNUVE5jFcQAk3vfou4v33ArBX7SU+24s0cJwrDO4bnvrTvCcJSavOKl0VwUH9OaRX1NOkiC1AHVCmZff5Ht52P5TEPKmyqg7iMrxNh4BuoB/MojYwOH0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199018)(478600001)(6506007)(6666004)(6512007)(26005)(186003)(66946007)(41300700001)(66556008)(66476007)(316002)(6486002)(6916009)(4326008)(53546011)(8676002)(8936002)(4744005)(5660300002)(2906002)(82960400001)(38100700002)(7416002)(86362001)(31696002)(54906003)(31686004)(2616005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RU1jRXdVVHNNck9Wb3BaM3VibWJEOWt3OWt3QmhSZkJqZTgzYmE5VXBScVRU?=
 =?utf-8?B?U3UraUpaZDZCb08zUlVHS2pTdUhMbXZqTnNVaXRYN2trd2R2WlNBRWxoN05Q?=
 =?utf-8?B?S2srN3R0NWdFcEtaUkV4VkN3RU1oOW0zc25pT24vcHpnOUxNbU9Bbm5OQmJw?=
 =?utf-8?B?OHcrTThlMXRTL0NIRTk5MTlFS0x2V0pXU2VxQjhHeFNKbTdlUXFnZnBpZ0JU?=
 =?utf-8?B?ZGxKVTQ4VkVISnNsZnpDRWhmWTl0Y2YvWUpOVEFrUkNnSFdLSW5sTXpYNTVl?=
 =?utf-8?B?Ylp5cnJmT0xtYjdEK1BmODE3dlhFNEc0aWRrUGgxNnZDeS9rODNsZXJxU0xO?=
 =?utf-8?B?QUdrdldVU0xiWEdqMVJKdWlXTE5xQkVuMlA4Q1h5WUFKNXBWZmRDUnBxNW9v?=
 =?utf-8?B?aWZLTy9ES0FQMFFFVEh3WElVeURvOGdHTUx3YUhrVVZzcTgwaGpxc243dHp0?=
 =?utf-8?B?bjJpRHpPajYraXBzSWsrRmJGVnlvK0lIY0xhRlhPUDB0TUJXaFd5RXNSSlFH?=
 =?utf-8?B?Nlo0MmRKY3VicVEvZitnUFlwaXN1RmJTV3NaVkdGMThTVTVkTENNblZEcGNK?=
 =?utf-8?B?Z1FyaDlJOGJYTmZjUlpKSDN4bm1YQmZyTGdSREpjM0FNSXJUZVBxTEpoVm1v?=
 =?utf-8?B?a3JOdmt3L0ZDa24rYXhra0YrazY2SzNYTUplS3dYNHV4ais5OGo3UUM5WWto?=
 =?utf-8?B?anNtdTJIaFJwNk8yOG9VY25xenJhZVkwRHltRGd0MUJoek03VGRhdkljN1hR?=
 =?utf-8?B?d3ZDcmpUYXlleVZNVFNCOWxGMWtaSDZPaU9zdm1LVFJKN2dTNHJHMXVmNFhz?=
 =?utf-8?B?NS9URXg2d24yNnFMcythWnM4L2kzMHNJZDZDaHNmQTFrSVZiV2drL0lPTTUv?=
 =?utf-8?B?SEVDR1IwYkd3S1VOcTI1RTBnZnlua09OVWVDVG81cjZKNGN6U3ltRzlJb29x?=
 =?utf-8?B?L0QwdGpNK044L3dPT01rOXF2R0Rxck1TWWY2cUNYUnlKNDVYbW15bUtnaEJn?=
 =?utf-8?B?WjJzRUF5OFlPTVF2WlBwbHI1ZnhxRWZZNGkrWlZlYWJvVVl6cVgyQ0I2Sk00?=
 =?utf-8?B?MitzMGJUNmFlZEVTQzhmOFZ0aFJyNngyUGl3b1NHbi9CRi9FT1dhYndqL0Fl?=
 =?utf-8?B?YkxpTVhrQUt5TmxLenNPSGhJT0JSUE14Vi9BU2Z3azdUQkV6ejR2dlRmZ2FW?=
 =?utf-8?B?djRkYXg4c2Y0R3d2amxWSkJFRHdneHpPemsxc1ZGeFZDSnNudHhiZmZUNDBO?=
 =?utf-8?B?L0ozb291blc1anRPOWhwWWRidzk0Q2IxWDBwYzhxRnVCbkJxVjV0cUcyWEJr?=
 =?utf-8?B?djYzU2JRS1pOZ1hkU0Y1czhwbHhtREk2Z3pYTXJ1UUxFZ0VhT20wNjIxRTJs?=
 =?utf-8?B?MmEwSkY4eUJXMWRxQjlNZThnWDFLcTY5K1ZObHU5Y0kxYVdzbkZiK0JLcUxF?=
 =?utf-8?B?ZE44UmIzNjhzTm0reHBsWXgvNWczY3MrV2ZZaVlDUWlRZjNqd0pQcU5xSUc2?=
 =?utf-8?B?SUI5Wi92ZThhNlI5aUxFSGJwa3hjQmJ0ci9FTytTSmlDRFhkQlRLY2l1eDZk?=
 =?utf-8?B?MGRJS0lFdHUvWEdNRkdTdzAwdm5tTFIvK21xL25HMlNCQW1rVjJHTlJSN285?=
 =?utf-8?B?ZUhFaGtxMVpiVGMvcGdicUYxaW05dnNYeHRIL09JSm8zM0Y0NDFlOHlhMU11?=
 =?utf-8?B?RHdwMDQrTjJnUDkxUyt4SHZiR0szbVhsWUFVNm1HbmhZemlzaWVBdDhFc3Bs?=
 =?utf-8?B?WkdCMkdUNmZTTnNCd0JrM3hNeWZ4QllTazJwVW8ycTBKWURtMm1NZ3F3K1Jo?=
 =?utf-8?B?dmZCaUV3MHI2eXlXbkZzYUlCbFNTUm5JeVVqTnJSOWRGZ082UFdDWnRtOUtk?=
 =?utf-8?B?QmlVRTJ6N0J0VGFzUmphd0RpTWhPSzR2WXBybmF0VWFtMG4zL2s4bUZ0VkNY?=
 =?utf-8?B?NHJHSmgxak9lNElldzl3M1g3elRDaVMxZzlQVzArVHpYODJvemZPdVlGNEV2?=
 =?utf-8?B?MlUvR2t2cHV0MjlId2xWWUhveDkvSVhKa3hoeTdUNmMyS052bXJEWjF1V0pY?=
 =?utf-8?B?TTZycGNheTNoOGgwYWR5bUtaVzNhdiszOXQ4Qmx0b3QzcVVERW9HMzVpdC9j?=
 =?utf-8?B?UjlyQWtKSVdJbDRWRXA4Ni8vMGRrZmRITWMvNXRtRVdieEVFUDBaa084Y3Rv?=
 =?utf-8?Q?YLrEvofNraakDS0UcMV4Kac=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e32feb84-6199-4fb3-1331-08db15b2d833
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 15:30:08.0988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4su3ZED4W1EShnI7uaBsBgcyuToz1VGx3hv5AS7rKuXvITnktPrP1mpqOpVc2EbrHTRC3cGgDYz0QqEXYfYFO53wSBJK05NuTkBa8To6ruE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5317
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lucero Palau, Alejandro <alejandro.lucero-palau@amd.com>
Date: Fri, 17 Feb 2023 15:20:27 +0000

> 
> On 2/17/23 14:47, Alexander Lobakin wrote:
>> From: Lucero Palau, Alejandro <alejandro.lucero-palau@amd.com>
>> Date: Fri, 17 Feb 2023 10:22:36 +0000
>>
>>> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>>>
>>> Adding an embarrasing missing semicolon precluding kernel building
>> :D
>>
>> 'Embarrassing' tho, with two 's'. And I guess "embarrassingly missed",
>> since a semicolon itself can't be "embarrassing" I believe? :D
> 
> This is going worse ... :D
> 
> I'll change it.
> 
>> + "add", not "adding"
>> + "precluding"? You mean "breaking"?
> 
> Preclude: "prevent from happening; make impossible."

Now I'm embarrassed xD You can leave it as it is, it's my dictionary's
fault :D

> 
> But I can use breaking instead.
> 
> Thanks!
Thanks,
Olek
