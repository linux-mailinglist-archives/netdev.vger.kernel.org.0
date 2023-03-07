Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 666FA6AE7E7
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 18:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbjCGRG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 12:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbjCGRG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 12:06:27 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E67098EA5;
        Tue,  7 Mar 2023 09:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678208477; x=1709744477;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FcWg7YQOt22XzkuvCx3XEUZfSNr66tA+QTx1OU5rZXs=;
  b=W3bAYYFDwAReh+1qgwKIPHggIz3wqdA6T+bE74DmvxQZ+F3WsOdBZVr5
   4MDy9WWUu6Fw9INhvCTvvcqr9N5uDFfJnTsxYZLZQCJsHTKMQKAOWMCH7
   u2hlnRClL8QM36mB0vFINWeCLbCLvvuOvPgJwFYzlT78gyEP4iEsg121z
   ygG6+ytUek2VhqNjGQHaQ+sxN5N7sJr6/NitFQ+UQkK62/Bu/A/xYODZS
   CY46meqAgOiDabr2fc9FOLsKt2fAEr5FmsBefkihmrIk3uFT9Kg6K8d3A
   X95oj0be4Ad0NumQXAXG4JSlPxQLFMU4cw2YP0e3pWeAP5ioCzR9A62//
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="338228520"
X-IronPort-AV: E=Sophos;i="5.98,241,1673942400"; 
   d="scan'208";a="338228520"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 08:59:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="669968957"
X-IronPort-AV: E=Sophos;i="5.98,241,1673942400"; 
   d="scan'208";a="669968957"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 07 Mar 2023 08:59:42 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 7 Mar 2023 08:59:42 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Tue, 7 Mar 2023 08:59:42 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 7 Mar 2023 08:59:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XeTPUlgVsjr23MQHvu2Ej3nZ8Y2wwdV44nEQoCAEfl3qlG08C3h6uhsrL78W5v3YXJGyNGWsL31UlByIT2HBh7yukD6HSBbhM1NWmLn9KuL9HOJXQwG7/Ci+sbQ2N1BnWdoIZZUplPvY3PMH0pwgA/DCXXj8W075YGaF3DkaUHW/j+Chz3H1p591pCLP/jNqTSRDom18xkXSZyO4ChGqCJxeHLuu2NFE++rcVITvONjO22NWwUBOcKmq0bsRwWEROvAdhRfP/erKcjX8LDP1baMAdQ7y8Xzb3c8edyahCN79ra4V/tTMpPS3mPjN7Kqb+PNgffffaSGRaimsd7Ue4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZQt9QmzfuAEVZrYgqZ9MEZzduBVBuB1sIigz/BIcmx8=;
 b=CiiL5Cmqvk3kRvMKpY4FI9gPP+GLJgBvaIglEkhYFLLrby8Kyh4iLH/v91EkIquiSHLtsCccvQp2sZZ+wxGqbwlID2MbUV1+9vYH1ZJQqqzQDe5jBNwTzecxKz1BdtzbUXJyHNqiuH2CB+f49WM5HeV2JST7mC6klfDATtgu0mbvY5Zyj/Jsh+xNotfCJkzsb3uc6AUrI1T5+hTJy98XPrakUqHoAHP7+tG0mZm/zdWNR2WopwKri0bRFhCvMjtdOOuK9bYODeaADPQW/5ePmazMMfybCEh0qz4GFSWmgwgFL+/ezNPDerjp/eONLURfAv12GcQGMxTumwGk2YLUPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SJ0PR11MB5199.namprd11.prod.outlook.com (2603:10b6:a03:2dd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Tue, 7 Mar
 2023 16:59:39 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 16:59:39 +0000
Message-ID: <7612377e-1dd0-1350-feb3-3a737710c261@intel.com>
Date:   Tue, 7 Mar 2023 17:58:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH RESEND net-next v4 0/4] net/mlx5e: Add GBP VxLAN HW
 offload support
Content-Language: en-US
To:     Gavin Li <gavinl@nvidia.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>
References: <20230306030302.224414-1-gavinl@nvidia.com>
 <d086da44-5027-4b43-bd04-29e030e7eac7@intel.com>
 <1abaf06a-83fb-8865-4a6e-c6a806cce421@nvidia.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <1abaf06a-83fb-8865-4a6e-c6a806cce421@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0142.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::15) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SJ0PR11MB5199:EE_
X-MS-Office365-Filtering-Correlation-Id: ef72c26d-b993-4d3b-f0bc-08db1f2d56ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +reU+AAoYW+QeDEJRiMW/ltq1caOeSQFHHUr8oAoLuE5JRVkEimWDJn7ZskljOj61EREUEhz441B2G4c4EzzwQ+HMM9Q6nnMPiYIh2pIT2UjJerinf0t6G1IbR+yqdIJ1tOHijGzYGWn7ZJgACt+N1EYxIFI2GpIxTs6DMzwuigptKmHen58ZFEOu5u2qmUEzP5v2VsQzu1ttqx1f9WzySh+eL0lVBEf8qeRLroPgYXf4FY6SxfJ9EGKuMZK2Uv24K1tXeqlSR5Kts43UzkYHc94OAmVbX6n/btefWxW4eKhTE91Px2566vYnk0KlNIJNrVjC6qrYhKt3Hcli6iU+YcpTWtV+XUEoRhgm65ZKOOdcntItr0402gKsigll7yaBL1k9VHZe5EdwZFUTMJFpxpyIC2Ozyco3qMMmNEafrIrk9+Sergnp1L397nXMC1Y3nij5AKwEb3xxZqCiImaApv5L1Is1qjBTi2EhVxJl9j8B4C49v6S7+tWNp2K3FhGWIo0W+4yeY0N0h+I0IjTW2JDBxNClmZynnzv4xruuKbWjLXnxTYViM2M9w4Rhe908LGW1/R7pV0SgHlUiEU2GZAj/VVLG6Lk+fMTv7zHpMRrWnIxM4rdTuO3N5h6Ei2SEX5Xhqw6KfkpHBICue6T4FubhR3N/QiDUxE1syNOcbiyGAitRPsBLmY3km9rLbH6lziG5s/df1r1cJxPl4jzQiRNaD9Totli3AhRLQitxMsFPfnEaa5H/Iqkrhaxh742Vf38xaljsoAOgPiCEE6kPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(136003)(366004)(346002)(39860400002)(451199018)(31686004)(316002)(36756003)(186003)(86362001)(38100700002)(31696002)(6506007)(82960400001)(6512007)(53546011)(83380400001)(26005)(2616005)(8936002)(5660300002)(7416002)(6666004)(966005)(6486002)(478600001)(2906002)(41300700001)(66946007)(8676002)(66556008)(6916009)(4326008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXJrRU0rWTllODFQVnl1OHgyOXVpRTZhQ1pRRFJEQVdTN1hKMVVyK1lKRldH?=
 =?utf-8?B?NTZHT01JUnoycTFXc3BITE5UU0N0aXptNGhyME9nbzNxMWJXSGZveXFNOHdI?=
 =?utf-8?B?RCtqZlVJNmFsUUcwVnB5WTU5MnZsaHpPV1hQQ2owNDBWRTRiT2xuSG50bWVD?=
 =?utf-8?B?blU2TmVSZG81Q0VicUk1OElYZFJxSVRJYzhCTmJoTFczTDdaTEtMYVFMbFpm?=
 =?utf-8?B?NEQyNWxtbDYxb29kRnhYcklQK2ExVnZtck5jK3VLWWZCWllKc1d4Z3BVTnRR?=
 =?utf-8?B?U2pKUnV3S1ZVQ3JQRDUwY0c1b085QU03bzB5NVUxeERPdDJSZW0vK0pHTUdx?=
 =?utf-8?B?d3lJbVo1SjlVL1JPcXJsOFc5OU5mZEd1TEtTamtTNllFbjhTZ3hJS2ZPdG0z?=
 =?utf-8?B?VU5ONlBCMjMwZ3VwV3NSbHZMZGZUWGNwQWx0RVJRK0NGWmhTOGxDNVk3cnlT?=
 =?utf-8?B?ZUdOajRheVY0eUEwdk9mbXRMbGQ1dm9PTFl0SVV0bDZNZllacWpwbWRpRTU1?=
 =?utf-8?B?bHhDU2I5RHdXWFA2ZEYrNEZOU0w4NXRweGVDZStDa3hzNlZXUWF4OFpCcEpG?=
 =?utf-8?B?YmYwejZTUHUxSEsxYUZaeDVXSWlQQ2lJYzI0TXdFZ1hpR1RXNkNoR281Si9s?=
 =?utf-8?B?ZEVTU0FyaHRRNXFOSm42WjhPZTBNZzI2amhORXhxVVRhZlp1L1R4Rks0b3o4?=
 =?utf-8?B?VlJXZmRjR2ZFcGJLblFDUjQxZDAxY3RCZTJqWm5sTVo0NFkrdmZFbVcvRXlr?=
 =?utf-8?B?TWdva2F2VGhBMTZ2eXVsUXU0T29vQkl5RGJUU29PUlFMVHQ4R1RPaGNTUmFD?=
 =?utf-8?B?RWxSYTJkczlaM1dOcTVFclA5c1c4c1ExUW4xVXRSZUNxOGpRZWlDbnpGRkxm?=
 =?utf-8?B?NVlBOVJ5M0RHaEsyREJaWWdtc3BFc3FzMm56YmlkdDNrdzVVeC9pSEtmeUFN?=
 =?utf-8?B?NTVzTko3R282NXI3RGw0TGhRZXArbDhLR1FMcmQ0dHlKUW5lYm9GY0ZYT3Rs?=
 =?utf-8?B?TWJDaEthMUdLZTZvOUo0RERKYWRrZ0FQSmdqdXc4TmV5L2Zaam56M2JZUXhP?=
 =?utf-8?B?Wld1U2pnU3MzSDlPS2RDUnBHUkhLb3dLWU5lSlZkQnAzWStZOGlBWWNYSXhh?=
 =?utf-8?B?RExGbE56SG1tYk9oNWxFdnNSNUZoUEtxS0VHN2hOSHR4dTFxUW0xSG84TkZr?=
 =?utf-8?B?bTN0cTE0TTVIMnJ3TnhvVHg3bnpPT1RsdVp2aUIwT3Zhak40cEc4RnhyS0F3?=
 =?utf-8?B?YVlvQ3MwSkovV2dYQTU5YTh3M3dsQ3JJSjIwM0NFbFhBRWhtb0FaendiVFB4?=
 =?utf-8?B?QUlzdzVIa0NFVzNva2RHNEVNdlAzZEEreGsrTFpqWkkxV0xUMFBjWGp4OHNP?=
 =?utf-8?B?WThIWTdVVDBJTVNHNUVsTU5CZFY5ZmxTS1dXYm5zendxRWFpYUlEV0ExTC96?=
 =?utf-8?B?TzZnRTVRZ2lsT0ladEJzUDNTSmJwTFpqbXVXRjFjaVorOFd5RXBMRy9pWi93?=
 =?utf-8?B?dnp3TEtnSDRZanZlaGxnZmZoNDRPalB4SXJ5RUxhbHRLTzZtRjB1TTZscGw3?=
 =?utf-8?B?US83ZWwyYUdFbFczYnJicEhhTDFRaHBYV1FUN3FjL21idnVNYTlKSG8zYk9M?=
 =?utf-8?B?d25Bc2FDUlpwSHIxYXVlVEhMWk1NU1p0Q0xGQzdSV2lpQTgyeXBFTEp6cjRn?=
 =?utf-8?B?OU5mUGRrMXNkWCtqc0pUUm92TVQ2QXFXRjlRYkNBS3k1d3JUWWl1SkNQVC9l?=
 =?utf-8?B?aW1pSEpuWC9peWNuYjVuODdPV2hRQm14eG51SlZWNGdnMUxLdVlDOFY1ZGRm?=
 =?utf-8?B?dDFEdGcybzE3Uy9EVWgwTjhmUnJMUkVyNytFMnZKTjdKSGxpNCs3aGdrL2tz?=
 =?utf-8?B?RGN3RE5kaGtlWjN6V0JSNzhEVW1XTitHelFidCtEMHdjWEEwNEE2K0N5eEpz?=
 =?utf-8?B?MUZNTHJIYkVxa2ZiMVZMVjNNdmxpeHpuMFJCekg1bmlLbGM3WUxjMCthK2pB?=
 =?utf-8?B?N3REcmpCbVEzQ3RhZUl0MFVJSHM4bWlzWWczRXlvaTJqL3pDckpkUmFHQllz?=
 =?utf-8?B?aC9aVVVBeXA0VFUxd0c3VkFaYjhEb1dXRGZWRFphK0gwN0N2bDRkVis4cDZS?=
 =?utf-8?B?YUNqcEdwd2dsWUZIbDZxcXZOVkVGa2dxcEVqWFoxSGZ1OVhDK2ZwbzJhYkdX?=
 =?utf-8?Q?fvJZdoTHBlugLcicCiFHZLc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ef72c26d-b993-4d3b-f0bc-08db1f2d56ab
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 16:59:39.3811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9X0FiCBVBqrNwvwje5afQM9Jh3dMAzX8Of0aJwSUBV/gUcR9xdnPtexTLzlxoxTxhzJUQdztXrbwBL5HPglt6jFYHCLL4z64KQg/m4HWuLw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5199
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
Date: Tue, 7 Mar 2023 17:19:35 +0800

> 
> On 3/6/2023 10:47 PM, Alexander Lobakin wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> From: Gavin Li <gavinl@nvidia.com>
>> Date: Mon, 6 Mar 2023 05:02:58 +0200
>>
>>> Patch-1: Remove unused argument from functions.
>>> Patch-2: Expose helper function vxlan_build_gbp_hdr.
>>> Patch-3: Add helper function for encap_info_equal for tunnels with
>>> options.
>>> Patch-4: Add HW offloading support for TC flows with VxLAN GBP
>>> encap/decap
>>>          in mlx ethernet driver.
>>>
>>> Gavin Li (4):
>>>    vxlan: Remove unused argument from vxlan_build_gbp_hdr( ) and
>>>      vxlan_build_gpe_hdr( )
>>> ---
>>> changelog:
>>> v2->v3
>>> - Addressed comments from Paolo Abeni
>>> - Add new patch
>>> ---
>>>    vxlan: Expose helper vxlan_build_gbp_hdr
>>> ---
>>> changelog:
>>> v1->v2
>>> - Addressed comments from Alexander Lobakin
>>> - Use const to annotate read-only the pointer parameter
>>> ---
>>>    net/mlx5e: Add helper for encap_info_equal for tunnels with options
>>> ---
>>> changelog:
>>> v3->v4
>>> - Addressed comments from Alexander Lobakin
>>> - Fix vertical alignment issue
>>> v1->v2
>>> - Addressed comments from Alexander Lobakin
>>> - Replace confusing pointer arithmetic with function call
>>> - Use boolean operator NOT to check if the function return value is
>>> not zero
>>> ---
>>>    net/mlx5e: TC, Add support for VxLAN GBP encap/decap flows offload
>>> ---
>>> changelog:
>>> v3->v4
>>> - Addressed comments from Simon Horman
>>> - Using cast in place instead of changing API
>> I don't remember me acking this. The last thing I said is that in order
>> to avoid cast-aways you need to use _Generic(). 2 times. IIRC you said
>> "Ack" and that was the last message in that thread.
>> Now this. Without me in CCs, so I noticed it accidentally.
>> ???
> 
> Not asked by you but you said you were OK if I used cast-aways. So I did
> the
> 
> change in V3 and reverted back to using cast-away in V4.

My last reply was[0]:

"
You wouldn't need to W/A it each time in each driver, just do it once in
the inline itself.
I did it once in __skb_header_pointer()[0] to be able to pass data
pointer as const to optimize code a bit and point out explicitly that
the function doesn't modify the packet anyhow, don't see any reason to
not do the same here.
Or, as I said, you can use macros + __builtin_choose_expr() or _Generic.
container_of_const() uses the latter[1]. A __builtin_choose_expr()
variant could rely on the __same_type() macro to check whether the
pointer passed from the driver const or not.

[...]

[0]
https://elixir.bootlin.com/linux/v6.2-rc8/source/include/linux/skbuff.h#L3992
[1]
https://elixir.bootlin.com/linux/v6.2-rc8/source/include/linux/container_of.h#L33
"

Where did I say here I'm fine with W/As in the drivers? I mentioned two
options: cast-away in THE GENERIC INLINE, not the driver, or, more
preferred, following the way of container_of_const().
Then your reply[1]:

"ACK"

What did you ack then if you picked neither of those 2 options?

> 
>>> v2->v3
>>> - Addressed comments from Alexander Lobakin
>>> - Remove the WA by casting away
>>> v1->v2
>>> - Addressed comments from Alexander Lobakin
>>> - Add a separate pair of braces around bitops
>>> - Remove the WA by casting away
>>> - Fit all log messages into one line
>>> - Use NL_SET_ERR_MSG_FMT_MOD to print the invalid value on error
>>> ---
>>>
>>>   .../ethernet/mellanox/mlx5/core/en/tc_tun.h   |  3 +
>>>   .../mellanox/mlx5/core/en/tc_tun_encap.c      | 32 ++++++++
>>>   .../mellanox/mlx5/core/en/tc_tun_geneve.c     | 24 +-----
>>>   .../mellanox/mlx5/core/en/tc_tun_vxlan.c      | 76 ++++++++++++++++++-
>>>   drivers/net/vxlan/vxlan_core.c                | 27 +------
>>>   include/linux/mlx5/device.h                   |  6 ++
>>>   include/linux/mlx5/mlx5_ifc.h                 | 13 +++-
>>>   include/net/vxlan.h                           | 19 +++++
>>>   8 files changed, 149 insertions(+), 51 deletions(-)
>>>
>> Thanks,
>> Olek

[0]
https://lore.kernel.org/netdev/aefe00f0-2a15-9a43-2451-6d01e74cc48a@intel.com
[1]
https://lore.kernel.org/netdev/ca729a48-35a1-ef05-59d3-ef1539003051@nvidia.com

Thanks,
Olek
