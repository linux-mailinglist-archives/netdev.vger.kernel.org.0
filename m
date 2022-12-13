Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57FB64BD30
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 20:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235382AbiLMTXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 14:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236565AbiLMTXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 14:23:07 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A0E250;
        Tue, 13 Dec 2022 11:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670959386; x=1702495386;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5XNqNAvg9a7syY2asQzn5425u0+Q2pg478p70v+BzLU=;
  b=JAbL7G3iry5ZdsdiqHDTJigyaILQW4lzURNVstLZFlx71ih3cDpf8AQV
   hpgK0IO4GYZmJZv9KjQIUWUzV6GUXfNjf6G4LU9bAv+whYZiXHwtm5Vf8
   GrJcbWy+u37FUaHkS9sutluDYSlADXShyi3FBVQcZvaZqu2df/zClkgjg
   zIs2ZbhpIZf3/nMICFPZRNIu4Y/JUhVX1xEUqh/uE/W96dbKK/Jly0sTs
   W+DqtgGwoNtlqbUkJ2H+lvclHJFRM6zQaoaNKgFs1eMFaxJ9gMul51FpV
   GC1udPy7UkDBFUIEPxTOKP8ewPQ5wudp6MMPNGzobYexqmaJPorjEv7vA
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="320080649"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="320080649"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 11:23:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10560"; a="717321533"
X-IronPort-AV: E=Sophos;i="5.96,242,1665471600"; 
   d="scan'208";a="717321533"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 13 Dec 2022 11:23:04 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 13 Dec 2022 11:23:04 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 13 Dec 2022 11:23:04 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 13 Dec 2022 11:23:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCsHdm3fSIgp6N04UNUxAAtmwh+h16HeVwLdfg5gdS9N6sQPQfILHuL3SS3XB9HuuheAu/irtieH7cZGApCRd1iH5DTB3iMus4IcqUEwScy24i4nj3jAsLtLvdvUfuX1Q97b0jU1sqix/9dn9roFBYOfesMBlf2vJQES273fjlnkslUR8lHWTSmn4FCdbj+P2OHVCfnjbW5f51hbLNGF59dI1TLTO325ixmKFeeIIGQmIdDBoXzW4DS5FIagvkduZQmeF5jpkfd6s2IkC0GD/8TkX9OX8+t/QWQmHOhuVAZksO4Kld9DLgSFRLM6UBZ9XRq2T5s9XyWDXxANd6zoFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dseQduynfMFfD6SS7iAhn8vL1vDHCIfZul+4Kn5OFDs=;
 b=D9l5ESX4V11Hn4+IBSjT/eJyq9qVyD1MQ7wLbEezx8hsTqgUP1NXDQWwaacDTYy4BuO6l+H2LcDdZjr1a1oVEuY0AjWRAwWKbLRsd3vbvHhnYhaQUrJTzS4Jby5Jw3pRHcsVpcvxRAbHiyFG+mPCn4S3MOeQ2TZiINKgeWggipVj1NBE7fU5WOkUwe3tIONlcJvPqyduRt6iU97DrKPTRyZ7ce5E8U4BqNW0o7KiTd1HKEJKvuUhDT5Jt/5nbuYnGsoxtLHu2QSDqZHmKgc6U9zgrSYN5jeofojjNSswVkAqhwUjl7AevVlnOjHoC9Y6BA9rf/+cQp32l6e0rycawA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN7PR11MB7510.namprd11.prod.outlook.com (2603:10b6:806:349::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 19:23:00 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5%5]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 19:23:00 +0000
Message-ID: <3dd48267-d31d-5b4a-3c16-5b186d85988a@intel.com>
Date:   Tue, 13 Dec 2022 11:22:46 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v7] igb: Assign random MAC address instead of fail in case
 of invalid one
To:     Lixue Liang <lianglixuehao@126.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <jesse.brandeburg@intel.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <lianglixue@greatwall.com.cn>,
        kernel test robot <lkp@intel.com>
References: <20221213074726.51756-1-lianglixuehao@126.com>
Content-Language: en-US
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20221213074726.51756-1-lianglixuehao@126.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0047.namprd17.prod.outlook.com
 (2603:10b6:a03:167::24) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|SN7PR11MB7510:EE_
X-MS-Office365-Filtering-Correlation-Id: 584b5d9b-0688-4813-32ab-08dadd3f72d9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PecQtwW6Qm7wHDlklNsZ2seDkRSF740jUH1k3zEhOtvSs2+A4WGLdvhEgaeqi+s/4T3pRU5r3i4A8frd6jfJZB+mwna2aiHnvZyCmCZW/+ONUpX7N8yyK+r57/G/q2UmrL7NLMNKPBAmchdlmWagy57jxSaaw+lfxrIqYQLCZ5HmDcbgqTRsxgnH/PSr+WiV+ettsuGVMtJEtz41jeJCx8xmQdvjVIKYt2XuyFAKpYzPlqfJ7MrgC/S/aueCKxGwQLW2JlBgyDpYON0Ld5+Xe/jHySQjTQ/V3qmjSt/ZUwmEq/3UgU8b5ZG/FVCAbHcGOzzYyzoVmC3Ep1SkVY2OqN6dQa7KgoSojk+wYSj6bwwzEyTYiZ0ndQpRloB8PXRUYVQWSUUluZwWa/fCEA/fq0663qsbnJxbIxSQ/ONEM1E2OEvIDMn9jUaEeAngeMk/cC1NR8BqyiRlfnoNFUbX9pI66DEmtaPzxE/YErYt9oZtoVLlcm30RMbc6ya/YAqql83/VJyS543n8/vmypzG+kwZp7m9Y6dwtgFbAlbN5qVXa1HBZL4wL/jcJoleaadyRHbPzvtggfGhTLxF4t/boaF+4Qzh65mUxoj21N24Me9AHGowuJoZ1oFAOkWbbCc2xb0amQ+gZZk1CixC5OLVYPWdilUqIuzaNkxuv8a3UCD7sV4WmvCsB3iiDMRRBF1b2cUBZAnDOXycBpTmMFmiEbvI0geu2YINjS0gPp+1Ld2UtP6hPJN/bll/OZkuBdlYFar2sUT8mx/ywzQkgHTyVPwlU8yfGPSHHWRFL2RIr3M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(366004)(39860400002)(346002)(136003)(451199015)(31696002)(8676002)(41300700001)(66556008)(4326008)(66476007)(316002)(66946007)(36756003)(8936002)(82960400001)(186003)(83380400001)(38100700002)(107886003)(6666004)(26005)(966005)(6506007)(2616005)(478600001)(53546011)(6512007)(6486002)(5660300002)(86362001)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGVpbVVoZ2hQOFZWS051WjlSQ0UwUkcxb2pwWUIvVGNwbVhTZUc0bFhUNm9y?=
 =?utf-8?B?blhseExFblF3MCtRRklESnFoUVFFQmJXYloweDlNUG9HVWtjRkwrQTBxdWdM?=
 =?utf-8?B?aGYzSVgxNTRpYUVwMHVEaEl0bFFBWmhtdmdiOGt4dmlGS1RNY1V0SkVOaktD?=
 =?utf-8?B?MENGTmc2WWpVYjcrcDJuWjh6N3dnUDkzRnpONjFhSUxVMkZiSmFadGhsNTZv?=
 =?utf-8?B?UVR3emp0KzhPMk05MHRadlVsWW9OYUpESWlTdEVTSzBwc0NDZFFqeWkrT2dD?=
 =?utf-8?B?TWFXMEFrZHE1Vng5aVhNMDBURXF0THJnMzU1NDBDUkJaU2ZKcHhlbUFQNzdT?=
 =?utf-8?B?UG56bEwxTDdSYmd4NnNXN01qSFh3ai8xVGhXeG16a0Y1NzdGMVJLejllK2xX?=
 =?utf-8?B?Y2NGTllkWTVBOXVYVm1BWVV1MFZIV0w0Qm0zL1VwSHB3TzJlbWhQNjBXTmJi?=
 =?utf-8?B?YjhWOG1xVU5lS3RPQXJtZGg5TXgxb0VlTngxbXRSa01LOTlGOVNvSm1LTkNh?=
 =?utf-8?B?eGFsWUk3WmU4MmQvMEdCL1BNY1dPUkpGVUlnTlRxRTZpckNQMU1KblBnUnJo?=
 =?utf-8?B?YUhJUTAxZmZzRi9XMWR3ZkFhaW1rM1pGeGI5TW16L281cWxqck9BcTFHLzFV?=
 =?utf-8?B?QjVCV3htcytLOHdMc1Z2VDN4WFQ2S1RNTkRibUEzM1ZSaXdiem5xQytyWVZ2?=
 =?utf-8?B?dlhBNGNUUzFtbkVrdkNGYVFibktvb21FWTRqL05tVVlQTDFuOWZISjVVUUY2?=
 =?utf-8?B?aUZGbm5qcTdEeENLWWp2eDFLM2tqVGQzeEl1bUVxanZkTjE0Y211RGpsM3NB?=
 =?utf-8?B?RDZYblVVOGswbmI4Y21PRFJ5b1VRcTlhamx0cXRDVVlrVWFEeUV1bDVteDcv?=
 =?utf-8?B?R3RZVTlSVGYxTGxkSEJ4ait1dXpGUmIwK3pIZEdaZEczdDB6MHhHMUhHOTQ4?=
 =?utf-8?B?QlhTNC9TQkVHTXhka2F4NUw4d1FHdS9jYUVxcGV0Uk14OGQrM2JqajJ0RHRm?=
 =?utf-8?B?RXlKKzNGZkVvQVNORjJxWUwrdHlBQks3akRHeUFrekY4ejVnRTJvRGFZTEF5?=
 =?utf-8?B?MjBRUTg5c2pXTVhUb1p0QlczdDFvK0x5TTg5UXV1QUptSjBVTW5uZ3lockJW?=
 =?utf-8?B?bnpNWXk5TW1MNkVVU3VKMUJYNDQ3U1VscDdZTVFCdElYblpJQnZhbVp2N3dW?=
 =?utf-8?B?RkhVVXVZVGQzTEJNRHpjT3VYazc1ejR0VGh6MTVxc3RTNUZJcjVSZ3ptUTZX?=
 =?utf-8?B?WTdEZ3djUWUwQ3J1S2tsVlQ0S3JEc3hnbk04WHlrQzgzT3pZcmE0dElqMWZ0?=
 =?utf-8?B?NkVDOG9kZUhCcDFSL0ozcmpRUTYwcWowcWZqcXNxRDVEbEljUnJOa3ZHSUd4?=
 =?utf-8?B?Z1ZWWDViaHNrVVhScmxLcEJleVIyeG5mVXFGWWh5azZnMlVNOUswRmhXSVYv?=
 =?utf-8?B?Rys1czhEbFlTZ0JtN1BWdDg2eXVHd1d1eVBQdlZaa2R5b3E5ZzdPOGo3SmdF?=
 =?utf-8?B?elFuQStpaWF2RXZMbXN1aER5bW1DMUFXd01WL1MwU1BrT2hoV3NVS1ZOcGh6?=
 =?utf-8?B?ZUV5T1JVemU3cTF6Y29PczluazZScGJBRFlxV3cxSWxJQ1U1UWFscW1CUGh3?=
 =?utf-8?B?NVBMMzBacktQWUdBRktORTVUWGNCbjNlM1d3MUdXZXJGQkhucHM1eDFLTHIr?=
 =?utf-8?B?OWlvYjFzQXdxOGtFRERXcDFsMjBKWFYxY3VzSnNJVDdXZ3NyaExqWTBZTFVE?=
 =?utf-8?B?SlA0WENVMGwzeDNYeTdta2pDY0NaTjNubmJGeklXblJPaGRGbDRxTVVXOHM2?=
 =?utf-8?B?ZGQ5NDRYT3FmUTF3T1VuUUdseGMwSzEvK1h4UWFGUElZeGY0ajNzNTRkMTNj?=
 =?utf-8?B?SUhIbU9wbkIyUVN6bXcyd0VVL094K2RXRUg0WnRIanNRUXBYTGlQdElUWE11?=
 =?utf-8?B?R0ZySTBjSHl0b3ZEMnFlSVlTMk1qS29hMEdYOXdNaHE5UC90VmVqeVRJL0lk?=
 =?utf-8?B?Z2hJNzVpT3hiN0ErUS9CZHM0R0JOQXpGb3lTNElDZG5OcU9GMFRYQTdpMGtB?=
 =?utf-8?B?OFpOUHdRSDdzVzdQNERtdUdMckFERGJoMlRTeFNKRERXemUrSVNRd1dQSDVP?=
 =?utf-8?B?Z0VKVkxnWFZJZ25BK1R1b3JTdTZ5L1FWcVlBRkdFOStkZXJubGllT1NmZW5s?=
 =?utf-8?B?SEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 584b5d9b-0688-4813-32ab-08dadd3f72d9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2022 19:23:00.7736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yzEjLi+UHZAWyu3hhSAbkQBvzey/jY507RtI76P4Pef6Mnr2mm/lxu0zoM1+4SKn0n3oJj9JjISuSw/JUwUNv0exjSTFKusoLMD+bzs7D9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7510
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/12/2022 11:47 PM, Lixue Liang wrote:
> From: Lixue Liang <lianglixue@greatwall.com.cn>
> 
> Add the module parameter "allow_invalid_mac_address" to control the
> behavior. When set to true, a random MAC address is assigned, and the
> driver can be loaded, allowing the user to correct the invalid MAC address.

Please include Intel Wired LAN, intel-wired-lan@lists.osuosl.org, for 
Intel ethernet driver patches.

> Signed-off-by: Lixue Liang <lianglixue@greatwall.com.cn>
> ---
> Changelog:
> * v7:
>    - To group each parameter together
> Suggested-by Tony Nguyen <anthony.l.nguyen@intel.com>
> * v6:
>    - Modify commit messages and naming of module parameters
>    - [PATCH v6] link:
>      https://lore.kernel.org/netdev/20220610023922.74892-1-lianglixuehao@126.com/
> Suggested-by Paul <pmenzel@molgen.mpg.de>
> * v5:
>    - Through the setting of module parameters, it is allowed to complete
>      the loading of the igb network card driver with an invalid MAC address.
>    - [PATCH v5] link:
>      https://lore.kernel.org/netdev/20220609083904.91778-1-lianglixuehao@126.com/
> Suggested-by <alexander.duyck@gmail.com>
> * v4:
>    - Change the igb_mian in the title to igb
>    - Fix dev_err message: replace "already assigned random MAC address"
>      with "Invalid MAC address. Assigned random MAC address"
>    - [PATCH v4] link:
>      https://lore.kernel.org/netdev/20220601150428.33945-1-lianglixuehao@126.com/
> Suggested-by Tony <anthony.l.nguyen@intel.com>
> 
> * v3:
>    - Add space after comma in commit message
>    - Correct spelling of MAC address
>    - [PATCH v3] link:
>      https://lore.kernel.org/netdev/20220530105834.97175-1-lianglixuehao@126.com/
> Suggested-by Paul <pmenzel@molgen.mpg.de>
> 
> * v2:
>    - Change memcpy to ether_addr_copy
>    - Change dev_info to dev_err
>    - Fix the description of the commit message
>    - Change eth_random_addr to eth_hw_addr_random
>    - [PATCH v2] link:
>      https://lore.kernel.org/netdev/20220512093918.86084-1-lianglixue@greatwall.com.cn/
> Reported-by: kernel test robot <lkp@intel.com>
> 
>   drivers/net/ethernet/intel/igb/igb_main.c | 17 ++++++++++++++---
>   1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
> index f8e32833226c..8ff0c698383c 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -241,6 +241,10 @@ static int debug = -1;
>   module_param(debug, int, 0);
>   MODULE_PARM_DESC(debug, "Debug level (0=none,...,16=all)");
>   
> +static bool allow_invalid_mac_address;
> +module_param(allow_invalid_mac_address, bool, 0);
> +MODULE_PARM_DESC(allow_invalid_mac_address, "Allow NIC driver to be loaded with invalid MAC address");
> +
>   struct igb_reg_info {
>   	u32 ofs;
>   	char *name;
> @@ -3358,9 +3362,16 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>   	eth_hw_addr_set(netdev, hw->mac.addr);
>   
>   	if (!is_valid_ether_addr(netdev->dev_addr)) {
> -		dev_err(&pdev->dev, "Invalid MAC Address\n");
> -		err = -EIO;
> -		goto err_eeprom;
> +		if (!allow_invalid_mac_address) {
> +			dev_err(&pdev->dev, "Invalid MAC address\n");
> +			err = -EIO;
> +			goto err_eeprom;
> +		} else {
> +			eth_hw_addr_random(netdev);
> +			ether_addr_copy(hw->mac.addr, netdev->dev_addr);
> +			dev_err(&pdev->dev,
> +				"Invalid MAC address. Assigned random MAC address\n");
> +		}
>   	}
>   
>   	igb_set_default_mac_filter(adapter);
