Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1136AC3D7
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 15:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbjCFOuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 09:50:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbjCFOuI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 09:50:08 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9124B2E82A;
        Mon,  6 Mar 2023 06:49:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678114182; x=1709650182;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=V9dpGLJD1Dkk8BICGHNPugOfLfDLCmXeU1pBxjDKhvs=;
  b=lGa3zR2oGL1MURJcBXmVVeK44uswoR9TeXp3carWHyNNrRI+XjbEsh3Q
   Nh50CVMHL/YFdlGtM1matILpfMvNfRxW55VoteU2uOe0HSQL8pajNugf1
   ad46gn1/vJQxlC7xzYzq0FwTzbPz8PcRymwl453ZuTuaBYF808KtrOWeX
   4iNtK4xXQ9bd9BU/oqqGlNzbtZ5cJHBwFIBFON0UFt90fA/+08NBdq9Fv
   INo2XM74ZuBIPtR+ysA839R2j11hib4cAPnlmI6MlIe5NMwBBQMgOYOct
   SN9IrvjtUgLqZEqmJATuSVedMrtxnnQyj0lwrxh7gFT9pMVFTOYglr98D
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="335591108"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="335591108"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 06:49:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="1005422070"
X-IronPort-AV: E=Sophos;i="5.98,238,1673942400"; 
   d="scan'208";a="1005422070"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 06 Mar 2023 06:49:20 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 06:49:19 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 06:49:19 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 6 Mar 2023 06:49:19 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.106)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 6 Mar 2023 06:49:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U/wdJRX7BlFOFqVC31PNLp/zd5ZhuyqiUW6dRzDO8tU1cnN30F0WSWATKRVQA6X5a58qOKwRJ46mIMo9haYvSK/G2UUAMAsh89fWDGC0stmNZyE7rKUrzmaPqUtqraOA1ga7pXHxWyCx1pLxAEI0SplUPDrit7fF0+7gFEU3LKQHjdQFRsT8nshyO34Rz5N1xMXltVn51ucoOKjbg7geDfLImxfuN4927xnNevqo0PdAy57Riscd9EkydasrqeP/ClmpmIR8dKdVVnlMv9A55hnzGQXjm+m56vrfjUwp/sAUN6cF842rq/LIjblBwjZebLTNOYNxyk43fvphu1I4vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7LoIN3z65YH0VZyIlARk5FC96w+DNB/EUwY7tbMr5/8=;
 b=SQ57KBN/tUBq4am1RX3pOC4763uK3BuZfhfdiLWURN5sXp4RVFFkU6s3hWKqInkvXkhZNOO9ueYN9Sg1mrm72IYYsqtTDc3HfHLlTfVz8NA58/dsUU+XdtGxa+gZlErUk9RN2dcC5M5YQo4u0/PRrvX/N2K4G008MT22loYNv4gsY46XAuIwNybt/saGDq4uZH0PqoDbZk4KCosXDdI9Zd46N9vCZS4G70Gkvp0IpTfxaY45+1qCumoEN5Pr9DYdRcSE3Fk+3EVyBjkrJS3tS/4QiWnvZqzs23MSaIOSE1f7GsiCyd73TPN3iY7q2Ac8SkJgCmZX0GeK1d1n7y8GIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA1PR11MB6872.namprd11.prod.outlook.com (2603:10b6:806:2b2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 14:49:17 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 14:49:17 +0000
Message-ID: <d086da44-5027-4b43-bd04-29e030e7eac7@intel.com>
Date:   Mon, 6 Mar 2023 15:47:54 +0100
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
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230306030302.224414-1-gavinl@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0175.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a0::12) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA1PR11MB6872:EE_
X-MS-Office365-Filtering-Correlation-Id: 242150cc-1c47-4cc4-0a8f-08db1e51f5ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n6E51AQ6rmHIFnGwfXqk9Y181a8+dMAX7M8NFcuISlhFj1MkMVMegp//Hp+G+CyjhhF86S9ajiLOAEaEu5MeYHv1B/sH0ITIDB/nZfmlfZboeBY+Yt5QxXuSWNCBuebXP8n0fDkLysSu3nysLNooTJNzpW5bjPEuBPqMkSybQHaCBRbOJKOM2g1kdK0N2IL47u818nR/8io6WxO7kCBUEKkgC5kUCrNZY2BUS01OSrAyCfMRdFgXFzlou5AENRqkJb0ylOoMpQan8I1bMsRPKUttR+5cjAqpu43yfL2GUBkavIrTz4SiEPjr3xiKCO0V6HvhnaTpO0H78EUxJZ+/G8iL6W3ZxP2nSxQ8oLvwAjZLIhaSIj/Oh/Wvx04GsrpEEaoqXqjmcJho12WlvYRePDdeM5yp+6yEZ6BksgRwQ5zxW4vHBA3qawwmL3FyT2wmp2V2AGjXJY0Ab6UGMRMHlnNf5MmBKaN5b7nQHM+aQMzf+ISZh1zfnu21FAY3swRje5DxwxCD4DLeUwVdWv9GzKq995lEdoWBkikMX6OQUv5htfBCSW3BZmJqtKo03nPPtA3B0GDpWwd3TedKfnr01WT3QAXSKx19QH/Iz9oRIRiThjfFfc6lAMMwmXDiAMO5Gna5pgl4WjGy48dME4icckByp1un44NJohiSARufTII75kJZs4wbp2I+fIbc/gIrOc3jz1QfpB+PKl7UMG+d6YGehP61mZS4Cqa8yQzmNW8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(39860400002)(346002)(376002)(366004)(451199018)(6506007)(6512007)(6486002)(6666004)(36756003)(83380400001)(86362001)(31696002)(82960400001)(38100700002)(186003)(2616005)(26005)(41300700001)(66946007)(66556008)(66476007)(8676002)(4326008)(6916009)(2906002)(31686004)(8936002)(5660300002)(7416002)(478600001)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2ZHTUpBTFhBckF1Z1c4MFd0ZHJpNmltS1VOTDRNN1U2WlpKNGxtSWRZbDlz?=
 =?utf-8?B?emZKWmtUblR1MXI2KzR4Z0lPbW9pbXpYQy9QbjMyd0ZMSGpwN3hjS0lkQi9H?=
 =?utf-8?B?Uml4ZHU4M3hRNkRtcnJidmErK2tRTUE0MVIzMXVISktwajdiVUV6SmlMSGJY?=
 =?utf-8?B?L3hqZmZjRnErSVp6SnRkK3dNemlvOUtOUXBCMmRSZXJNVXVXd1ZYa3JOQ01o?=
 =?utf-8?B?L3FsVWxSVUxJdFlDSWZzbXpEYTFzbHBXczBPT25Za0xseFdMaVk0V2F6Nldu?=
 =?utf-8?B?TUJXK1A4bnd3SGkwK1huc29YTVprSlpoMnBranN3b2prNlZUK29uYkpEdnlB?=
 =?utf-8?B?dWd2TkhsVHZzYXo4bXZBQ1RYZEZGNmJ6OXV0NFNJK3RxR1RyRFcweFFxWXhX?=
 =?utf-8?B?WDArYkxud2ZtZG5qZzhXWWQ2UmZDSW91TVhPM2ZzRk9PS3RHdHlqaGFTazh5?=
 =?utf-8?B?YnRjdkpOU2NXeW5Ob09mSlZDK21QSEZiOFVOQWFlRXVNaFFNT0V5T2tHNWtq?=
 =?utf-8?B?U0JHSXlYQzRSbW1CT2FJYzdHQUVMQXZHK0Z1dmdnT3RGdjRRM3RPdDRYdGdl?=
 =?utf-8?B?WXlUbS9YMERLQ3QyV2pNQzROc0pETUpBMHlsNnRDRTk1ZFpaczhucDdqK2ZK?=
 =?utf-8?B?WFJmSk9pOUpmU3dLRXBpVmw4QVB4a1E0alFqcTl5V3FFNEJ5V1Y0UUkyY252?=
 =?utf-8?B?UVVFWGZiNXZvZ3hqOUxhRnB0Zkw1VUhVWDFDVlJaWTY2RllHTDBtRkxYTS83?=
 =?utf-8?B?ekNuWU5aN3VqWXJ2TmcwNEFMWmY3bm5UazgyWVBEY2pTTWhFcC9yS1RoVEtY?=
 =?utf-8?B?YS9UZnoyWWYzT3pwNmtqdzVycGZFZzBFTjh5eTJCL1Y3QlZuMlp3MXUwRjk4?=
 =?utf-8?B?cmcvNVNONUd2MG5zeGh1V0hnUFFuSGRXV2tISG5VZmI0TjBldlFWM2ZrVzh5?=
 =?utf-8?B?L1FrQWhkRG9QUW5ydlRNZ2NDQVpRemtBSHJTRDFVUnR6enBWNDhFOU51ZmZZ?=
 =?utf-8?B?cTd3T3d1cnI4RUl2R2t3RzhkZ0YwMytxMUJjSVNaVHFydzhWRTNEdytDa1JD?=
 =?utf-8?B?dzFZemhVNWphSS8xWUYraTZILy9ZYmFiamVCTE94RHhNbXNDOUdyV3hMTnJj?=
 =?utf-8?B?MC9sZXFsNnczNG5lUWc3QzVjZTVrQTlZOVdFMmtuOWp1M2x0bFFRcXkrZzZW?=
 =?utf-8?B?dUlHeXRvcGd2d0xGeGUzaHczVjJOWDE4NVB0VGJrUVJZK3VxYklvTkw1bG5v?=
 =?utf-8?B?dG1tQStBN1JrYnV1YXNxa2ZpcVQzMk5ZV3JhdC9WL2JsOWVEQzQ4KzNPQkRM?=
 =?utf-8?B?UUw5QXpkL2RuQ0VUQ2FveVk1SkR6cXRrTVV1aThmK3cySmZFVGhoc1RRM1Ux?=
 =?utf-8?B?V0VuZjVUYzduSWJaaWhseFhXbmhGN2p5R3RBS2dJVTZ4aW9RU0RsclFKY3pJ?=
 =?utf-8?B?eThIQVlteUpyb1FNYk9HZTg3Yk9UN3p3U1h4czFrUHU4THhZcXlJOWtPOHhh?=
 =?utf-8?B?bStmMGZFTGhlY2Fnb0VlTi82dHc0K2J3Ky9LTHhJZ29vN3Jsbk9kSEV1Z2U0?=
 =?utf-8?B?SXFNMEN5WGR5aitRZTJjUmNmNmJRemMxZUR6Szlya0VNQlNxUitXUElNYy80?=
 =?utf-8?B?eTBTU2ZOOUo4c3N0Q2VnOGF2eGJrYytJelhNWG05b1FxWmtrSENIUis3OWls?=
 =?utf-8?B?UVVmditpWmFqNHcxVkpZWkgwOXhLQ1d0aTQwOW53Nk4rQTdqc04zYjZOd1hz?=
 =?utf-8?B?SlR2VnBIa0lLanR6V2dBSkc0aFhaaFNCc0tXNlVlVmZldm5OTjA0cE02MEpT?=
 =?utf-8?B?VDlhd0wrditNeU9uTVZueEVmTDNkUFNQcW43THN1OEVKRGVmQkxlWFprQ0hs?=
 =?utf-8?B?am5QQURxQWxMVWNSUklnclNXbHRJdGFRN2pZWTJ3UmlwNHVvWVVIczF6ZldM?=
 =?utf-8?B?eFkwOE9vVVFYeGd4QzBoWTBGa2svRURiNXZJMmE2TVk4SldrM1VRZlRCWDYz?=
 =?utf-8?B?QXN4cTlIR2ZpV1Nac085VUI4RGQzSEVGb205c1pzYzZlNWxINVhIWkVXeFVn?=
 =?utf-8?B?OWx2bkJSVUx6Z1dBbW5YODdrZFNIOFhRWXFLSEFVZFF2K0pqT0FPTHRhdFE3?=
 =?utf-8?B?WWJ2RkROQUlLSjNQSnBac2J6VWRESEFhL1V1QnFubDQ3V0ErUE8xOG0xRFhn?=
 =?utf-8?Q?UVdSt7b0dx6VLnE+roA1nIU=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 242150cc-1c47-4cc4-0a8f-08db1e51f5ce
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 14:49:17.0818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dtQKbB4J64vyQHA9WX+Z+SYDaF9NlJdxXvLPF6niCH8cJyqqXwdtdTz/KvNktHv6V1DDnczZC/BeYELvLiTxGzoXbDzxJO+UBSKHmkz8qA8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6872
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

From: Gavin Li <gavinl@nvidia.com>
Date: Mon, 6 Mar 2023 05:02:58 +0200

> Patch-1: Remove unused argument from functions.
> Patch-2: Expose helper function vxlan_build_gbp_hdr.
> Patch-3: Add helper function for encap_info_equal for tunnels with options.
> Patch-4: Add HW offloading support for TC flows with VxLAN GBP encap/decap
>         in mlx ethernet driver.
> 
> Gavin Li (4):
>   vxlan: Remove unused argument from vxlan_build_gbp_hdr( ) and
>     vxlan_build_gpe_hdr( )
> ---
> changelog:
> v2->v3
> - Addressed comments from Paolo Abeni
> - Add new patch
> ---
>   vxlan: Expose helper vxlan_build_gbp_hdr
> ---
> changelog:
> v1->v2
> - Addressed comments from Alexander Lobakin
> - Use const to annotate read-only the pointer parameter
> ---
>   net/mlx5e: Add helper for encap_info_equal for tunnels with options
> ---
> changelog:
> v3->v4
> - Addressed comments from Alexander Lobakin
> - Fix vertical alignment issue
> v1->v2
> - Addressed comments from Alexander Lobakin
> - Replace confusing pointer arithmetic with function call
> - Use boolean operator NOT to check if the function return value is not zero
> ---
>   net/mlx5e: TC, Add support for VxLAN GBP encap/decap flows offload
> ---
> changelog:
> v3->v4
> - Addressed comments from Simon Horman
> - Using cast in place instead of changing API

I don't remember me acking this. The last thing I said is that in order
to avoid cast-aways you need to use _Generic(). 2 times. IIRC you said
"Ack" and that was the last message in that thread.
Now this. Without me in CCs, so I noticed it accidentally.
???

> v2->v3
> - Addressed comments from Alexander Lobakin
> - Remove the WA by casting away
> v1->v2
> - Addressed comments from Alexander Lobakin
> - Add a separate pair of braces around bitops
> - Remove the WA by casting away
> - Fit all log messages into one line
> - Use NL_SET_ERR_MSG_FMT_MOD to print the invalid value on error
> ---
> 
>  .../ethernet/mellanox/mlx5/core/en/tc_tun.h   |  3 +
>  .../mellanox/mlx5/core/en/tc_tun_encap.c      | 32 ++++++++
>  .../mellanox/mlx5/core/en/tc_tun_geneve.c     | 24 +-----
>  .../mellanox/mlx5/core/en/tc_tun_vxlan.c      | 76 ++++++++++++++++++-
>  drivers/net/vxlan/vxlan_core.c                | 27 +------
>  include/linux/mlx5/device.h                   |  6 ++
>  include/linux/mlx5/mlx5_ifc.h                 | 13 +++-
>  include/net/vxlan.h                           | 19 +++++
>  8 files changed, 149 insertions(+), 51 deletions(-)
> 

Thanks,
Olek
