Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B50D46E17AA
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 00:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbjDMWsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 18:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbjDMWsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 18:48:13 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70EE3A9D
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 15:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681426091; x=1712962091;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4T3App3HfV/cAAqKA35k9+bx0aZUPk0pw8IcP4Rixd4=;
  b=DX1neT33sjX0lhz9RSPK/nGFrw3XxWyuBwfGTjKXeZVuMzhZIheG8UaD
   1LQKOOM7ELWiX5XgpNyOXVda4OgCssgAxID/6apIm1QTWEW+5AsJt4l+G
   VMB276g9EvMpxwXns4ZcrQQKJ6LfH2a1NO/D3wbtJayNXQDH5PgxzC1BN
   MZupVmX7QIPGXGYl64FgKTION2F2e55Yd4nEUf6QVxsB/j/MaWBm1JMRU
   uGhO+8Zu4uESKo/q/blrBRNnj4eFMPMgVFVoUoiPt5B9g0a8b8atbTk0V
   NrzXTPITAyjNzJ+Ojj+7NjxTzbq6RIHFsB42ShEO7UZvqrASmXXw2KTRu
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="346148600"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="346148600"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 15:48:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="689561791"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="689561791"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 13 Apr 2023 15:48:09 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 15:48:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 15:48:08 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 15:48:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g5DZlcXnhW1N+P9EYSYl3LUCnCLn1oV79vojMmNTNRftTeb67mM5p78VOeqGTqLomGHWd+gb7cH/47IIJa/ZKsBPK8br+vZQbBQwwYJDd3P2w6YRUOMcxbSsGlfqw8xBCYM9sF0RHpp0fmcwnorqC8qoDzsiqtC2mxWyFREnA43cWeBS15q40zsQSFhxIzwrB/P3pOhTa0hf38MduiwDdegy1+60lHBYpyW09qGSFQ4QuQbzTYVo3CUlQsdWRDLxr8fJ8jvXi89i+IhBVefHbgVuclNNaOveQi+RO1DHrR9OzoOOZ3qiBEkdecp5T4gq5YG0VuDywr/MnZHQAwMzgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tL0E5+Odbm3vT6XeT6XWiHxZYkzpnXjZbmWD8zLd/og=;
 b=BmvFigDU+q2+IU7AoiEp05Sq7/V5ILaBb022IZP8AMIQpKfHmee54d3MOoE2pCSecNkSuZUPIlT3e40RO76mxchaW60BWNYIZ4hNOcbI1oKzWExt48UgNBIkbMQ0GUoNI57KpjafJf8FNzpRaEds3vTCzmANQU6GfIVYGI3u9gh9I/2gVibtlnX4l+Nw5012Ym38glmuW3XEpkoM3RxGGn7sH+zdmYBrgmoAwUFAxEit2ub1khas+C21rLJvJi7x0tYS4FkXNtdO6d2A9awLn5gIKSyL7VT/frfGH8qg2uIc5CiZMfRR7iMMDQHUeXnMUlR+iF56UYEbkYF2ohpkZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW6PR11MB8337.namprd11.prod.outlook.com (2603:10b6:303:248::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 22:48:06 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 22:48:06 +0000
Message-ID: <a1f2141f-ad09-2d63-16f3-5acbce7959eb@intel.com>
Date:   Thu, 13 Apr 2023 15:48:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v5 0/5] Support MACsec VLAN
Content-Language: en-US
To:     Emeel Hakim <ehakim@nvidia.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>
References: <20230413105622.32697-1-ehakim@nvidia.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230413105622.32697-1-ehakim@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0027.namprd02.prod.outlook.com
 (2603:10b6:303:16d::32) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MW6PR11MB8337:EE_
X-MS-Office365-Filtering-Correlation-Id: cf5ba70e-1842-41de-09b1-08db3c712568
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ICAZAupGvoFAsKWnAr+WXX+DjTRt2Ommo5PqfS1h0Tem1UV1298g6s5R5bmqQIjLOfN2VG+/I93MKbxPe3kR9yTWbnPoa5EXiyPxp/cYNBmYKLJQAOaqil5MaXDkxFGfJxAbeP96yyi0hDWk9Jjz+rluVAH/Bvqw2XyggRWkMCa63yC31HjBXhZi3MZ13uh6qB2p9igTsnvKfPHrPuguSPhcJSYRLXfN9KcbNaRl7dRhExL7q7gDDGy52XugfHv7Bpg7kDPlvEvgdzwbWNFFx3CqW4sXMlNayon1c92111kOUw/5O2V154Vt+ROSx61ZwoK99W2TFRkoUAbLDAwhrRKPFeH2McbWB4crjDFx1m+/CkW3ucHeKl4tjg8A97LjSu95V0pcDYvUMJ0Giwbo0L6QD9U81g/3dEeGvRkNjZAf1u6wT3rjoEr3ooEzkHNoTQWVPIhZ+4J5dvUDbHGOCNWOJKujb/nTTy5nMG0bojKXwuPL0a5Wuv4gfWHhnuZdCz5OWo4fXmk6MsxfoP3PC7WGZayYcXQh0WazKQQdFrxpzE6Tpn1AsdqlGltpCiE6NJS7qVaPKhxKzl2Cg7oZsEiFx9jjM4mUKa0nUa0ULvzr5dz6Qd1dC1oni1LQCJnNS7CStlnT52zKTsOmtJaPgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199021)(316002)(53546011)(478600001)(82960400001)(6486002)(4326008)(31696002)(86362001)(6512007)(6506007)(26005)(31686004)(66476007)(66946007)(66556008)(186003)(8936002)(41300700001)(8676002)(2616005)(36756003)(5660300002)(2906002)(83380400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bCtGNERUWFNFakMxUWVlRWxkbGFTUkwzVkoxMzJUdWpDRlA5blV2MThtcUE2?=
 =?utf-8?B?dnB5Z2FRRCtwbTZKTGFsMXVCT0laVkpLNTNBTGdVazdNcmtpdmRKcEFJWTBn?=
 =?utf-8?B?c2owNDVOb2MvZmJqUHFoMVJqVmVQbkx1V21xUTM5a0lZcHBrakNDNE04TUdO?=
 =?utf-8?B?T2VJYWY4dWp3ZEljOG9aZzB4MGtjRUVwOFdnK1dvWjNzT09uSTN6bkRDakRP?=
 =?utf-8?B?MGp6NHNaNFNvYk1kalhZSERNRGJlaGFKRkpjR0Qydlh4cUQ3bjk0MkszSjVM?=
 =?utf-8?B?SWQ3TGUzbTUwZFlNUW5LUTJRNkxQbmM2RmNsbTFrTXlBeXBSU3RoYXA2WDJm?=
 =?utf-8?B?NlQwd2RTMzQwSGprZlVJQzQ4ZHpkYmNQN1F3VTAzYWoyMFZydWVsRHJqQkZX?=
 =?utf-8?B?d2wrRUhPMlJzRnJpZGxVYUhyUTBlN2M1aTNONzdMd25BdHZBTkNaRFZsV1BT?=
 =?utf-8?B?blYySkovOUlNUFdTSldOcFR0YVozdElsL3BoUElRS3Y0RnBsNlI5Q29TSzQz?=
 =?utf-8?B?V1dhUVB0djg0TGZURkt4RTIvb05ucldVTDBvSHdJMGlKRUZpVjV4YWNGVTkr?=
 =?utf-8?B?MnFrN1dwaGpkeWUyMHBCamJmOWF1RVZoeVR3akRlRnp3azN0QldGOTFRTUVH?=
 =?utf-8?B?dXBlNm9WMExkeUR0ZjM2ZnNlNE1xU3dEY25PQ2pjWUFFQWdhS2lEU0RJNmZD?=
 =?utf-8?B?dE84a2hnZnJGR3hqSUZoN1BNaWhHeTRDS3NqMkFlUUx1eit5aUxtOXNzbXBT?=
 =?utf-8?B?bHFZcG1IVW9EQzdpWE91MEMrcm8vWkpWRUhXN0tzTW9FMlJZNkVjK0o5VSs5?=
 =?utf-8?B?bnNMY0tFVWRWUCtBbEZjcnZlcmhhZy9EUFloeUt6Z2pGQTZUeGN3RzEwTlVM?=
 =?utf-8?B?dG0yM21CaFBsUHJ6N2JZZThkMmlXOWdKaFdoRFpDRGltR05NRWczWDVOeEpH?=
 =?utf-8?B?Sk9aNVpyZmdvZHgyTDU4b3A1UVVCeHdkYjdUWHMwVnFaODNaTTl5WWR4RWhN?=
 =?utf-8?B?Wng2VUY2SnozY1RFS3BPUURVT3FuK0NEZTdmbHdXRU1hNXhlY3RCN0JOYU5q?=
 =?utf-8?B?dE5xcFQzRkhrTzdjVDN4bmJRQ0cwb2s2VFNNU2czSDFLdzBDMU1vcHdjM082?=
 =?utf-8?B?UEx1SUE3YWN6TW1oWDRSWEhBaWtTRThudGVyQVVJcTRQanp1djk3cG9QRXFz?=
 =?utf-8?B?S0J1enRmZ2ljN0IzM2dTb3NPNnVCT0NabGo3Tk9ZaXNPTVB0ZlZCWjhFYnNQ?=
 =?utf-8?B?d3ppYjlBTThVWnJKb3VXQXUxVTRMWXREUnZBUjFxdjVMSkc2MkdWeUZJcU1i?=
 =?utf-8?B?U2djTHZBelArYUtacVpzNVB5cWwxZmJJcGF5MkFQc1c3ZU5nczdLUEVYZDFx?=
 =?utf-8?B?ZHdYK2hQQ3B1a0RVcFc3Z1hnS3JjckREN1FuNzBLOWFjOHRBRUdIUkxFaCtM?=
 =?utf-8?B?NFdYeVNadVYxK0hzWHhUcm8zU0k3NmtFV1hlVWkzbGppdm1aSXRiSmZZS3ps?=
 =?utf-8?B?aUxSdTZtejNvVy83bWMyN252TkxmOGxiNFFpOXFhdk9oTjhPN0RuWW5ESEtR?=
 =?utf-8?B?S0k5WjdUM2FXa0t0ZU9FdEtSTGYyeTJxNVhxYVlOU2cxUWhBQktFTnBLTkVi?=
 =?utf-8?B?bHY5Ykhya3Z2cFJpci9XVlpOV1RrRHdnOTZNbWFjY1pYSE1Rck9hZXRYRSsr?=
 =?utf-8?B?bXFFeUVEdWVubXU0UUdFSXpNazFHS2RXU1RFT2tsZFRzYnJ0SkVpTkt0VVgr?=
 =?utf-8?B?SURhNEVvMHJFZ0F4aWR2aVJVbGhncC9yQjliT3ZwRXcwQWxwT2ZhWEJDOW9L?=
 =?utf-8?B?d2VqcFgwaVdWVk5zV2Exc01YWU5DU204RkI4QS95K05nY2x6ZHowb3A2MWpu?=
 =?utf-8?B?WFVSK0xxWFpMa0hHaXdyL2tUUWVGWGNpa1g2TyttMlZnVEhjUHdyalNXdnRz?=
 =?utf-8?B?WXdGS25SR0dCS1VxOHR5Q2tUWkZuVWVCSWplaDVxT3FXZExXVnJNL1R1M1BM?=
 =?utf-8?B?TG5MWWxFV0k3WnVOandQdTIxbytiblY1U2dvVTg2R2wyUWNRSngrbkVLLzhM?=
 =?utf-8?B?cGlwNFhkRGdzTG8zcTdKcmhzL0dBSTIwSU5DdFdwcXVIZXFkaDdqNHh2R1NZ?=
 =?utf-8?B?anNWMXhleWJwSFVZSWl5OFJpYi9RSmJzOGcyL0NETUNuVm54aC95Q0pOdVpi?=
 =?utf-8?B?VWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf5ba70e-1842-41de-09b1-08db3c712568
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 22:48:06.4312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6yF44iVnBlUx9G+sdoR8Yx32jOGokJmWG6Uek7khJtBae3s6p8OFdqIHRVYbdCcn9KyxKPkaTPEo+7rOjButkEkxn/wOF4zANCt4gLAwtEI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8337
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/13/2023 3:56 AM, Emeel Hakim wrote:
> Dear maintainers,
> 
> This patch series introduces support for hardware (HW) offload MACsec
> devices with VLAN configuration. The patches address both scenarios
> where the VLAN header is both the inner and outer header for MACsec.
> 
> The changes include:
> 
> 1. Adding MACsec offload operation for VLAN.
> 2. Considering VLAN when accessing MACsec net device.
> 3. Currently offloading MACsec when it's configured over VLAN with
> current MACsec TX steering rules would wrongly insert the MACsec sec tag
> after inserting the VLAN header. This resulted in an ETHERNET | SECTAG |
> VLAN packet when ETHERNET | VLAN | SECTAG is configured. The patche
> handles this issue when configuring steering rules.
> 4. Adding MACsec rx_handler change support in case of a marked skb and a
> mismatch on the dst MAC address.
> 
> Please review these changes and let me know if you have any feedback or
> concerns.
> 
> Updates since v1:
> - Consult vlan_features when adding NETIF_F_HW_MACSEC.
> - Allow grep for the functions.
> - Add helper function to get the macsec operation to allow the compiler
>   to make some choice.
> 
> Updates since v2:
> - Don't use macros to allow direct navigattion from mdo functions to its
>   implementation.
> - Make the vlan_get_macsec_ops argument a const.
> - Check if the specific mdo function is available before calling it.
> - Enable NETIF_F_HW_MACSEC by default when the lower device has it enabled
>   and in case the lower device currently has NETIF_F_HW_MACSEC but disabled
>   let the new vlan device also have it disabled.
> 
> Updates since v3:
> - Split patch ("vlan: Add MACsec offload operations for VLAN interface")
>   to prevent mixing generic vlan code changes with driver changes.
> - Add mdo_open, stop and stats to support drivers which have those.
> - Don't fail if macsec offload operations are available but a specific
>   function is not, to support drivers which does not implement all
>   macsec offload operations.
> - Don't call find_rx_sc twice in the same loop, instead save the result
>   in a parameter and re-use it.
> - Completely remove _BUILD_VLAN_MACSEC_MDO macro, to prevent returning
>   from a macro.
> - Reorder the functions inside struct macsec_ops to match the struct
>   decleration.
>   
>  Updates since v4:
>  - Change subject line of ("macsec: Add MACsec rx_handler change support") and adapt commit message.
>  - Don't separate the new check in patch ("macsec: Add MACsec rx_handler change support")
>    from the previous if/else if.
>  - Drop"_found" from the parameter naming "rx_sc_found" and move the definition to
>    the relevant block.
>  - Remove "{}" since not needed around a single line.
> 
> Emeel Hakim (5):
>   vlan: Add MACsec offload operations for VLAN interface
>   net/mlx5: Enable MACsec offload feature for VLAN interface
>   net/mlx5: Support MACsec over VLAN
>   net/mlx5: Consider VLAN interface in MACsec TX steering rules
>   macsec: Don't rely solely on the dst MAC address to identify
>     destination MACsec device
> 

For the whole series:

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  .../mellanox/mlx5/core/en_accel/macsec.c      |  42 +--
>  .../mellanox/mlx5/core/en_accel/macsec_fs.c   |   7 +
>  .../net/ethernet/mellanox/mlx5/core/en_main.c |   1 +
>  drivers/net/macsec.c                          |  13 +-
>  net/8021q/vlan_dev.c                          | 242 ++++++++++++++++++
>  5 files changed, 287 insertions(+), 18 deletions(-)
> 
