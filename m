Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19D9A69680F
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 16:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbjBNP2W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 10:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjBNP2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 10:28:20 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D459B211B;
        Tue, 14 Feb 2023 07:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676388495; x=1707924495;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3Iy0AlEL1ufxRF0Buz0XpcbI/6K+Wal4WEnCpWn1Uw8=;
  b=LUY6Skafa2hduVF48YLKZ9z0U9xMggvvNjCnhUViYish1gv1rJa5Ts6o
   i3aTE81Zz2vQOAUsotZClQYziNzAaWcR/5fUbAEQ7q7tKYiu64mcErSf8
   KFc6Rc/nxVs8YygF7rmOfIHVll55pwfKh1GcvQWwwO0QvWk/1AUvyjL7/
   McwDuE2Zy6t64UUh2sjPrmZ5GUkMj83dbQMt7A0ZfJPmVdomCMhTzE+D1
   8M2HmFW2hWNAcOOnqGQ25BsOWqWrKcLwiDLET80MvU61169jMlcmZWaxg
   YqKNaOf4EBrBit3X/mwtlddQJSdF0OGN6BQSiIBpe8EZT2fxh3xuNZyKe
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="314832007"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="314832007"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 07:28:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="793140743"
X-IronPort-AV: E=Sophos;i="5.97,296,1669104000"; 
   d="scan'208";a="793140743"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 14 Feb 2023 07:28:14 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 07:28:14 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 07:28:14 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 07:28:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LdiFvAzp9nv53Z3ZepXPeIBCefuxLeim0cDqWTa/A0563rEAtiQDvhtz/gctwCwEjCZJz8FHpg7KEOwxddrYd3zjCneqWNPu7p76lXA+kdanAab/9A8MxYj/ROVpaxGYfIsFARX3UfofELVEppBrwPMN5AXrT+HHEC752UNbKsL2BRBSTo+5mzxVwbx1zqJLAwhg21DQOOV+gDG9LVGCSH4AWaJbftkIA5U9LefN139C5vDqnXlpotM+enXxrRWLl9Ox8oXHEPNBYAtBszue5RqUqzM+10mrMLTBJvifZ7xf4LzNcy/2fff/KbJCj6Eav8OJ8EnxHfBrK06xl2AW/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0yjgmCzWF+rUu6hqag2neHBHMVd2G/CAuypI2YOs4k0=;
 b=lhjjvsMvNhtyoYHa9tXr7sAzVcqBqFBVFz2dAtXMqJWBGXt5PURqJUeLBRkmESh3LPR91Xu5xDUohryIA9NS2SfqxufDMy7T8UVN4wU1iEcN3pgwYkTLpYcOWR4vX4jTraYDLfnYw3XNFlUOp57za+h2LZeHO1sq6jSv2h4whlGFDw2HmVZ1LltG3bhQlkxAbbuGtYFgZjjAsoX35VPMQdch/JiZoyLMV27z61Q7TUL32ci694dYM1X+OQj6KmOymSTGAST8VYfxH5wzVXv8QFJ2nRlR89VDNI0rkhpuAcotpktn3wSDGwEQhAqsU6P5E6KlH2UKe5CnNkYDAE1J1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by DS0PR11MB8018.namprd11.prod.outlook.com (2603:10b6:8:116::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 15:28:07 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 15:28:06 +0000
Message-ID: <711630a2-b810-f8b0-2dcf-1eb7056ecf1d@intel.com>
Date:   Tue, 14 Feb 2023 16:26:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v1 3/3] net/mlx5e: TC, Add support for VxLAN GBP
 encap/decap flows offload
Content-Language: en-US
To:     Gavin Li <gavinl@nvidia.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roi Dayan <roid@nvidia.com>, Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20230214134137.225999-1-gavinl@nvidia.com>
 <20230214134137.225999-4-gavinl@nvidia.com>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230214134137.225999-4-gavinl@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P123CA0083.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::16) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|DS0PR11MB8018:EE_
X-MS-Office365-Filtering-Correlation-Id: 41453ed0-c2a2-4127-4763-08db0ea0122c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ovJZujYWQ8Qf9maXU0/dqKeslx0qkpyimAma0d8prNgCMqTOt+Af+nTlMyopZ2HXHl7vvwo/qla1Jl4AZ+1XSZop080Vz/yKJC4Uu6zQMy4HgUeGVCGulKNGLGnoX3qABtuXLfude9IzOwJB1CddJeUAruZgSeYAdGM7LJ/YmRANKZSIptn+ZpumznBXEj8vzNUEPkHBmasG5zVH6ZKCRDTQWVyut5r2SH03qDYsyCrRHG+5Fax8M+M4PDiSESZ0/8aUwc9Y+MzNaZAjKgezxx9rmbhRB5bEyezq3OVCLhBJNlpNG8ioO69uW0u9uD0SL99tAw6BOhMqiqxP0eyo54/GbXfb+TprEroGA73yDs5FWfffFO5jxJlk1qUjsYtsE4bQglcW1NlTJZ54TQO56G62qTE5eOcbaY1GSND7MWnAWWGqlRZNfqX9/WxjdoYL6zEN3S4kwVCfFaynQNnd7R9zxsZd01RQB/xOwqX707hwXMfreC9qEbyRDuz09gGfDYV45vFuvq9aiSXkV10XOmawrCneSnpp80AEsSL/FzhFBYXjStaFvSAAXDV/T1iC+LFT70R+KGiBJ56HFZ19iZ3K3ARVqgHcXNSBxbQJxb4kdWLm6cAXoEA5ybn1H9xNYVOVBFn2rx7JICOY7rTfkcV7yBctjVTpX/NZY7s5kITmLpCicFFW805xWsXw+T+Gn/Pzw3GuiyFK2idyeRNw+jTKFTgOvAvuf34M+SI1taY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(366004)(136003)(39860400002)(396003)(451199018)(7416002)(8936002)(38100700002)(2616005)(86362001)(41300700001)(31686004)(4326008)(5660300002)(66556008)(66476007)(8676002)(66946007)(6916009)(54906003)(2906002)(316002)(31696002)(83380400001)(6666004)(36756003)(26005)(186003)(6512007)(6506007)(478600001)(82960400001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TklvN0FWSVcreXFKc0N6Y0lNdytkZlU0amkwOU1yL0xUKzBib29rK0tucUVX?=
 =?utf-8?B?VFQ1QVQySjJmQ3FKSVV3cDZhYjM4c2V1K3ZIWktKTUhHY3Q2WkFQUkZiRWh6?=
 =?utf-8?B?TW9scm5jZldqWXA1cDFla0ovSlVqMEkxWFV5RjE2UjBRN1M0elQ4VE41c1hx?=
 =?utf-8?B?aHU0cG1OSlhmbnpRQmlFaGNwTHhodUV5ZGdwVTFOb3pqVlpKVVpUZE01SWxG?=
 =?utf-8?B?OTk1T1M3bGo5V2Q0c2l1SEIrWnRrTm1mS1VNTmsvTGpvKzhHNWt5VnNPakNE?=
 =?utf-8?B?bmJZSFFlTE1wMEhzQW9ENWtkN2dnNG92MGhuUzdkQWtLRURjTWJjN1ZOemNw?=
 =?utf-8?B?THJRdnlSTE5UY3JRdTZ1T0ZkanQxNFRVKzJFcW13RmdTZnQzSXMvUVAvRm56?=
 =?utf-8?B?N0ErRFpFYnNwRUY5Y0dRYnpaYmZqT0lFNXRUWkNaQ0JMTUxmSkxVb1dORmgr?=
 =?utf-8?B?eE9qZ2FjS1psV0tXT1QzWldndC8vTE5IT050b0hRaXdiZyszR2t5WTl5UFVN?=
 =?utf-8?B?eFlmNzdOWS85T1BBZEdPeDU2VEdQdkRvM1R4eWF1eTJFdDhRYlhib2pZeUtk?=
 =?utf-8?B?Rit6cWhWYmJvNnI4MlY0Qkp1WDVYUkZXNWswbzh6U1B4d0tSUjhMb1V5RXZj?=
 =?utf-8?B?dWMrRFRwMThLa3F0b3JEY2QyWXptanBHMk9tOElXeGdjY3JKV3B3RlBkZFJq?=
 =?utf-8?B?VnF5clhyeFQxZ1FjUjZabFBKdDNSLzdMYzdON0xoNzFObHFjTEFFRlVYVlZY?=
 =?utf-8?B?TXhBeXFCZVhOTHkrWnJKVzhTYTZETGtRcld4cGZtWnM3d2s2TFFLLzdxYUJn?=
 =?utf-8?B?WlJrUEN4T0orVzFNN3FIVVk0a3pRcmJuRzFNTllBc2dzZW81TWtBeVc2emZO?=
 =?utf-8?B?dTlndGR5YnV1TDI1V1AwWUNFWFZsYmxrYUZzV0pzY3VVeWFFUzBSQitJakJD?=
 =?utf-8?B?MXQ0d0hCYU54WG44dFlMN3FqL0FpNkd0YVJUQWFnZjRsS1FsY05Cd3JPWEdG?=
 =?utf-8?B?cVpZZmM2SGhHbDBuYmRid2VpZTZmZUpTWjc2TnVEQW1vNGdXeHNUZGlpTXhO?=
 =?utf-8?B?VnJPdHZlTEp0N1pnYTVxQThZN1M1UjVRMTlFdm16UHY2dHoyNTdnNkt6UTh4?=
 =?utf-8?B?amF4Uk0rQ3N1bTFPcGl6SGNyZnZEclMrNDgrQ3dHV1Y2OFRHNHA3OVFyNm81?=
 =?utf-8?B?THp1aDFtVGNRYUc4MkNtV3NZd0dTQ3VRQmlvU2hCbmNoeENMYnMyQVlKeURi?=
 =?utf-8?B?aGVVTlR3ZmhLZzhTY3QyZXQ3UlVvQ1I5dnlLdFZyV0tTMXNVZWl4dktNcmtP?=
 =?utf-8?B?VTZVMnlhRVEyMEl6V3pJbnMyVFlDTEtVWGNWSjA0Z0VYYThOUXB4cEdmbXhD?=
 =?utf-8?B?anppekZnaS9sNlRibkZvQi9vTXZjLzIybzVwY0gxRFFNVlBzeFlTRzc1dGpn?=
 =?utf-8?B?Vm96VEhDWGk3Y2ZudWtRODRlaENMd3hKaG1pUkNiejhOdzNTYXZlZTFQWlJp?=
 =?utf-8?B?UVlYM3o2SVIzN2ZmbmJFL2NiZ3ZsN3YrUVMycU5iSFNuL3E0ZHlpVmFUT1dK?=
 =?utf-8?B?NDFUZlZuZUl4ZllER2ZzYTc1alUxYWtJemNMVnFEeVVwWU9LYXVvVll0VXpN?=
 =?utf-8?B?WDdpVkpCZnNvZGl4ckVEeVlUSlA4clhpSnhubHN6YklMdmNCRm9KUnUxYlUr?=
 =?utf-8?B?bXg4aU8vVEUzcURUSXZFVC8zckgvYkpnR1J1ZWpZb0FSWG5lT2ttM1VQd242?=
 =?utf-8?B?a3pERlJhUDNLU3pGOHpvcGRmUmkzZkhMK3R6WlVCR3BsbnMzQTRndWgwazlt?=
 =?utf-8?B?d3dDZnFZSklkemNZejlDNDdWdk0vdDBPUFlvdnhUY1QrU3YxY0pjTW9kMTUy?=
 =?utf-8?B?ZDBVUmYwUkFnSlhwMU5icWJ2R3kvUlVuek90eUwyRkZDRVYwRHk2TkNmOHo4?=
 =?utf-8?B?M2NMNnhpaEYySy9QR2phcjhoZkZJU0NhOE1KMzh6YWZwMlJrYnZWVXVPRk9E?=
 =?utf-8?B?dHI5d1BUOWxQcUMvZitXSE9GSVRaazJqSlJ2R2F5UWErQVZ5dFhmWGhEdU0r?=
 =?utf-8?B?NnoyRjNHMHRqUWFpYVpIN3FkdjNtSE0wOEZMd2NtYjE0L0xZTVlhN3doYkc4?=
 =?utf-8?B?MlNINjhJaW55TytNR1dsM3BsQ2xMb0ZkQktnRFhpVEFFWUhBRmFOakszd1dp?=
 =?utf-8?B?ZkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 41453ed0-c2a2-4127-4763-08db0ea0122c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 15:28:06.7067
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OGN7tcKWdKQpPYaXyb5w1oa64tBcN5vf+/9/rIoAMUpLab8VP+6cDEU6NLgc7Ku5EsQuz5urC2TtsAEsIKBO0z3jv8GHaV0RqJ0itPKx58g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8018
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gavin Li <gavinl@nvidia.com>
Date: Tue, 14 Feb 2023 15:41:37 +0200

> Add HW offloading support for TC flows with VxLAN GBP encap/decap.
> 
> Example of encap rule:
> tc filter add dev eth0 protocol ip ingress flower \
>     action tunnel_key set id 42 vxlan_opts 512 \
>     action mirred egress redirect dev vxlan1
> 
> Example of decap rule:
> tc filter add dev vxlan1 protocol ip ingress flower \
>     enc_key_id 42 enc_dst_port 4789 vxlan_opts 1024 \
>     action tunnel_key unset action mirred egress redirect dev eth0
> 
> Change-Id: I48f61d02201bf3f79dcbe5d0f022f7bb27ed630f
> Signed-off-by: Gavin Li <gavinl@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Maor Dickman <maord@nvidia.com>
> Acked-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  .../mellanox/mlx5/core/en/tc_tun_vxlan.c      | 85 ++++++++++++++++++-
>  include/linux/mlx5/device.h                   |  6 ++
>  include/linux/mlx5/mlx5_ifc.h                 | 13 ++-
>  3 files changed, 100 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
> index 1f62c702b625..444512ca9e0d 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_vxlan.c
> @@ -1,6 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
>  /* Copyright (c) 2018 Mellanox Technologies. */
>  
> +#include <net/ip_tunnels.h>
>  #include <net/vxlan.h>
>  #include "lib/vxlan.h"
>  #include "en/tc_tun.h"
> @@ -86,9 +87,11 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char buf[],
>  	const struct ip_tunnel_key *tun_key = &e->tun_info->key;
>  	__be32 tun_id = tunnel_id_to_key32(tun_key->tun_id);
>  	struct udphdr *udp = (struct udphdr *)(buf);
> +	const struct vxlan_metadata *md;
>  	struct vxlanhdr *vxh;
>  
> -	if (tun_key->tun_flags & TUNNEL_VXLAN_OPT)
> +	if (tun_key->tun_flags & TUNNEL_VXLAN_OPT &&

A separate pair of braces is preferred around bitops.

> +	    e->tun_info->options_len != sizeof(*md))
>  		return -EOPNOTSUPP;
>  	vxh = (struct vxlanhdr *)((char *)udp + sizeof(struct udphdr));
>  	*ip_proto = IPPROTO_UDP;
> @@ -96,6 +99,70 @@ static int mlx5e_gen_ip_tunnel_header_vxlan(char buf[],
>  	udp->dest = tun_key->tp_dst;
>  	vxh->vx_flags = VXLAN_HF_VNI;
>  	vxh->vx_vni = vxlan_vni_field(tun_id);
> +	if (tun_key->tun_flags & TUNNEL_VXLAN_OPT) {
> +		md = ip_tunnel_info_opts((struct ip_tunnel_info *)e->tun_info);
> +		vxlan_build_gbp_hdr(vxh, tun_key->tun_flags,
> +				    (struct vxlan_metadata *)md);

Maybe constify both ip_tunnel_info_opts() and vxlan_build_gbp_hdr()
arguments instead of working around by casting away?

> +	}
> +
> +	return 0;
> +}
> +
> +static int mlx5e_tc_tun_parse_vxlan_gbp_option(struct mlx5e_priv *priv,
> +					       struct mlx5_flow_spec *spec,
> +					       struct flow_cls_offload *f)
> +{
> +	struct flow_rule *rule = flow_cls_offload_flow_rule(f);
> +	struct netlink_ext_ack *extack = f->common.extack;
> +	struct flow_match_enc_opts enc_opts;
> +	void *misc5_c, *misc5_v;
> +	u32 *gbp, *gbp_mask;
> +
> +	flow_rule_match_enc_opts(rule, &enc_opts);
> +
> +	if (memchr_inv(&enc_opts.mask->data, 0, sizeof(enc_opts.mask->data)) &&
> +	    !MLX5_CAP_ESW_FT_FIELD_SUPPORT_2(priv->mdev, tunnel_header_0_1)) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "Matching on VxLAN GBP is not supported");
> +		netdev_warn(priv->netdev,
> +			    "Matching on VxLAN GBP is not supported\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (enc_opts.key->dst_opt_type != TUNNEL_VXLAN_OPT) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "Wrong VxLAN option type: not GBP");

Fits into one line I believe.

> +		netdev_warn(priv->netdev,
> +			    "Wrong VxLAN option type: not GBP\n");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (enc_opts.key->len != sizeof(*gbp) ||
> +	    enc_opts.mask->len != sizeof(*gbp_mask)) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "VxLAN GBP option/mask len is not 32 bits");
> +		netdev_warn(priv->netdev,
> +			    "VxLAN GBP option/mask len is not 32 bits\n");
> +		return -EINVAL;
> +	}
> +
> +	gbp = (u32 *)&enc_opts.key->data[0];
> +	gbp_mask = (u32 *)&enc_opts.mask->data[0];
> +
> +	if (*gbp_mask & ~VXLAN_GBP_MASK) {
> +		NL_SET_ERR_MSG_MOD(extack,
> +				   "Wrong VxLAN GBP mask");

You can use new NL_SET_ERR_MSG_FMT_MOD() here to print @gbp_mask to the
user, as you do it next line.

> +		netdev_warn(priv->netdev,
> +			    "Wrong VxLAN GBP mask(0x%08X)\n", *gbp_mask);
> +		return -EINVAL;
> +	}
> +
> +	misc5_c = MLX5_ADDR_OF(fte_match_param, spec->match_criteria, misc_parameters_5);
> +	misc5_v = MLX5_ADDR_OF(fte_match_param, spec->match_value, misc_parameters_5);
> +	MLX5_SET(fte_match_set_misc5, misc5_c, tunnel_header_0, *gbp_mask);
> +	MLX5_SET(fte_match_set_misc5, misc5_v, tunnel_header_0, *gbp);
> +
> +	spec->match_criteria_enable |= MLX5_MATCH_MISC_PARAMETERS_5;
>  
>  	return 0;
>  }

Thanks,
Olek
