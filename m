Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C07D672AC2
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbjARVn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbjARVne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:43:34 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF07D656D5
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 13:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674078175; x=1705614175;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nZMun04B9gacESmxTzIZCLB7I7IxGw72mZWM4tqc5oc=;
  b=VL2Xx+3jnQqPSVzsZ0//ywChTpJdIdYqAGPMtQWzY6jYRYYa/t84FZ3Q
   vR0k0GiP+yPe9e5Mkbp5+otEq/rUkB0V6yAZ63xrT0V2SO7+e3I/v5GVG
   C0p0eehGUB0ifqZCu/lX5Ed8ZVxCUR9n8dkdt0BJxJbtRUnXBxbOOU6qt
   uPeFTbV7rpN1C3y+G7yXvt/JZ1F2eM1SKrW7P8z77r2B8kXz2I3q4xrwJ
   c4MBIRmXjOUMO6eahPF1NSzSY6lnXjSX81A5T9RS9wx39it+MJR4wBpK9
   /Mey06VZAcF0tPKpBh2+TnhyEEGRsg1L3u00jUHVsx3aum2kHKCmAzkpa
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="387460419"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="387460419"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 13:42:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="988758089"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="988758089"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 18 Jan 2023 13:42:22 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 13:42:22 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 13:42:22 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 13:42:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bknhlMGxbm5oRX92IBq0qQV0rWehoUaemgjTmr+8LcxNivNTpUpglRH5Rq39GRa/RHEs5SqydOYvi7KB7vgTyOmRMKmmW3XHbHiun1kSTU0jBTfYCC9MQ+0TAF57sj3MSi8mmg0g1gXL6IApOvVTTUY6IvjareEBOr+pHNifps1pGxMHwVScCPuM8Vvn9+NGmrX8TgPi0pGTs+Egl/8DKpL19FPO7UVieFpEsEHzhxEfTb3e+Pu3zg+5GtrqVJsC23z2xK1CiwVaqNmF+9KHglFL879i7L8tFgcnLUBYFf1FIt6PY7bA7lc9qZVKy9CuR/zk/ZIPWpCE38HrJq9lhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V/4W28jsGHX1CboRUDe/nCCB+RGcxlq7CfZCWkntY0g=;
 b=nUR19MiWgyGxE+rqMjhI8RkaoNPBSXrXGLzyhZpu/Jcn6pF9V/Mqte//uqM3myasS4qCoJp414pO1k/cqrbtgnk4xXbz0cQ3NwwcWAC9DzvxiTonasRXlr+5oOOr7xHdsYiupQc52Sp3zv80eWs+6oBOFdt76HcMyreAQ8RfZThYiG182fco3YXiFgCMnc+pIzu/Ld15Lez/fXVSK3TXEj+c1vBVMIL1mlaRtS/rRmuD/aLKupzMz+Nc9M+/UUGDOLKpI/RnpMv9vlOKLbvEBonAOJs/xa9DG/aKb26Trj2wseR+a8/MuHxdSOABJC2FQGnNm0J0A7OVLSKf1o4OPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA2PR11MB4825.namprd11.prod.outlook.com (2603:10b6:806:111::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 21:42:20 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Wed, 18 Jan 2023
 21:42:20 +0000
Message-ID: <1cb13f80-c4f5-e172-c7a7-2d0433a215b7@intel.com>
Date:   Wed, 18 Jan 2023 13:42:18 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 07/15] net/mlx5e: Add warning when log WQE size is
 smaller than log stride size
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
CC:     Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Adham Faris <afaris@nvidia.com>
References: <20230118183602.124323-1-saeed@kernel.org>
 <20230118183602.124323-8-saeed@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230118183602.124323-8-saeed@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0281.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::16) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA2PR11MB4825:EE_
X-MS-Office365-Filtering-Correlation-Id: 595b74b1-0040-4f53-ca9a-08daf99ce073
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w/bA32QHO5aO6cUDjtk/bw/J3XaKy+KEN7WcGwEJk8w3ah4TL1sw8ywvCzVfGgcfTqHUZCJZOjtf6fzbOxrterpURV5xydGONZc21rjLbnVB/+GI3HYfFzzoAKGBmp9oadP6yEVaqkL0vjiJ2fKVKt9DX4AyuXPges/O/g6KKCd0NnztFNDrV8NJ7wFW5W4fw+L5H7JfbPzEwIIr5Qf6/yX4/3fTNXnAwHVXHs5eZPdDM/AW7g50iyyqWakGbzdPcdTR84a8Dm2XCKwmtZAteLfxFCni38vmwTT70Hc+/T9f/GlRMNWSvARKBWLPAvALySoRupN2pPq5+Fgjw4r1WHwbxvM8tMBrWSoHin4Lhy8Lljyl6Wy23uqX4SLTyp4t4DzueDrlkclS4hr7TUsFKG6j21mB67I8I9cqPAIrS4gfbd34hpUQuc3k6rX1VUBaBxrw+U+ZRMxdFAJuSmXnbNfg4oDKvIh74mJmN959dafhn52mcOffzhsF6bSW0xsTrEe5rdg2fKrSfJRfn2q2A5Yh3SXKla1wwkGe1cwMtwj+CHYgZfe+Bvdi98xEqBTkBNdpxjsF3qjeqEyOpHZSqDenI6zlZRfERQfytG5eE+skun7k1AucJqaAhkzFs30W2QL+tY6sJCJhulQdvJHnt90um+fPYd/KKeIBQchYjmU4HYW0e7En0lGo5KpwJQ7MGKUcMCJXu2ykEfbAg8PslSVZ+gsvkfsLZ5EjMHaYCqdSxQQ1Y6YF7YsaxM56Xc6e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(366004)(346002)(376002)(39860400002)(451199015)(86362001)(31686004)(66556008)(66476007)(8936002)(5660300002)(2906002)(82960400001)(31696002)(66946007)(38100700002)(54906003)(53546011)(316002)(110136005)(6506007)(6486002)(36756003)(478600001)(41300700001)(8676002)(4326008)(186003)(83380400001)(26005)(6512007)(2616005)(45980500001)(43740500002)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NitXMk1PenozVXl2ZHBXK25GUnhhNXRMZVdDTWsxdzgyV1NXWlE0SnNZY2sr?=
 =?utf-8?B?L2l4dS9Selo3RndqWFpFT3JOWWJrSWhJVVZiVTdwdlpZbThlMm5UdXZlNEFk?=
 =?utf-8?B?TXM2TDVMcFJOdkxGd0REWEJuclVwSW95T0pCU01ISTBhT0M2N3NselVFMmJu?=
 =?utf-8?B?dnJWTE9tQzVHTU5BcUZ2OEpydzZTY21KeWV2U2hSV1RBS1BDNTZzNHVRTjJr?=
 =?utf-8?B?dzBtSERoTmRjc2k3ck0ycUNDOS8vWUd1SFdzNEhqV0NaUktvV05hN3V5dmEy?=
 =?utf-8?B?NUFzR3VYUU1ZaUZsRE1zdXEwYWlqUy9pa01pOTIrY3Z6eVlBODVIeExxZ01n?=
 =?utf-8?B?VTQxWTVaRVkrQjVnbTFjQmYxYWJaanBrRkhLbUxHcGJ1WjRJblRRZ0J5UUFM?=
 =?utf-8?B?ZjZHaGluTDhRTDg0cWtJdHE3Nzc0a2JaWFFUT3hBOWF2dWhWRTlhaVZaV0g2?=
 =?utf-8?B?Wk5QNGRUZ0U0NnFnQS9scXVvNEhvSHFlV0g0Y25tVFM0dFJCS1FtME95S0lR?=
 =?utf-8?B?UVNYQWVVbGN3ZTZYMHA4N1MxcnFEZDF0RExiaENZVVFjTEJYTWJVY0RvK3Y4?=
 =?utf-8?B?VXdOV3lsSnBZdXcvV1ZRbFYybnBWUGxlKzU2N3B4S25yVzNoWGI5SHVORk43?=
 =?utf-8?B?ck1TVVM2RWVidW9hOW1jZVVHbHFkdWM2Q25xLzhpNk1qMEh6dGFZNGFYTnNj?=
 =?utf-8?B?djZhYk9XbjNPZDZ4Mnp5eW1pQkdxWXp5MC9OekxzbnMrbTVISyt0ZTFnNmRi?=
 =?utf-8?B?VXRPanZiZFk4U3YxeEwwTkNvSFZhenBIUFduM1lmc3p1U2FDcFpSQ3ZEZFJL?=
 =?utf-8?B?QjNsbVNBWDNRTnRVN1NDVURQWWc5dXpyL0xQN2Znd0h1WmRweHZGMUEvaWQ4?=
 =?utf-8?B?VGx6TkdOeHZkSTMwT0VwZHVrTzhVZjYxVTFRd2lJOW5UVmQySTVtVzhKZmNr?=
 =?utf-8?B?RVVGTVdJZ3lsVkZta0o1a0xsT1pmWGxhZnZjdHpEeHZIaXJhUzVlZWNzNVJJ?=
 =?utf-8?B?ZTg5b0IxWWFrd3VyajQyY01WVHEwb1BTa1BUcWVFUXNLcHJ5S21GOWdwdXBJ?=
 =?utf-8?B?ZTZ6eld1QVppTjVNOGJpQTBQNWRaZG9mWllrWi9wbWtiU2pmY3NUM2hCOHkw?=
 =?utf-8?B?c1AyamhNRmNIS1FwaUN6V2ZVTFl4dWVOcXhkVXB1bkkvL0gxV0dhWXlNQ1lz?=
 =?utf-8?B?a2hsUzJMQ0lzWkNGTVhmSjN2dmV1YlRKbUJNWXhpQkNsaHFhQXc5QmxaNnlh?=
 =?utf-8?B?cHhlOWJJaEN3eUtNbzBxdXI3ZUJPOEdPbVdhRWNGUVpoSlExMmNRM292Wmk3?=
 =?utf-8?B?a3VLUUNxWGVkaWlNV3R6aHhpUUxnTGpJQjlqd2ZvWHBtUzYzOWlUT1hoc0xx?=
 =?utf-8?B?VlVscFJIRU5SVWMzanYxcjMySVpGN1c1eG5ZcVV5MDJBQ3pxb0hXYWV4b2dC?=
 =?utf-8?B?WGtuYmtJUU1ZV1dOdzB0ODVNS1QyTlNnZzZpTitXOWRreWNRR2x4V01HUHg1?=
 =?utf-8?B?aXdQeFVvZjh2bWlweml3NWVlRHd5ZGZyOXQ4RTFLSDQ0bGh3TmZFYmlyV28x?=
 =?utf-8?B?cjdsNG1DQmtaQmdaUlUzWkJGQy9EQkp0WVUraWJrLzVSNzF6MWhDcWlvV3pL?=
 =?utf-8?B?dXEvN0RTdlJqVlo4ZWdSY0Mya0hGelpiN2x2NysrWmVzenpCSlBGQ2EvYmZr?=
 =?utf-8?B?bVBaT3MwSlR4NmFrZ0lyeitVMkhDV0VDcW5GTjI5clJnTWV1NU1kRldjcGJa?=
 =?utf-8?B?YTVTY05OaUJ0cDMzQUM2QWVBTmdHZ1dOK2tKQ1M3OTZIU1FWZUVwaVlMU0d6?=
 =?utf-8?B?ZjBCbExLTnlkYTJNaWVtZ09BOVhUZm8rWHpJWTVYd05zMUVEOHhUcnJZclZo?=
 =?utf-8?B?djJrMEYwWlMrenNrcENnbGx1ZHpma01uZ3VKNEMvL3B5bVZtK0tsYkdZNVEv?=
 =?utf-8?B?YjRIaXdxTFNJd3RDdWc2dGhsVy9lNmxvV2JFQUR3ZnM4K1RQbEhvQ0psemZn?=
 =?utf-8?B?eGVRRm53ZjY3S1czVE1wU0dyWFZ6blFoVGRDUmlvclR0OFBwK1d1Sktvdm45?=
 =?utf-8?B?eWNFQlhaamE4S2drL3UyUndiU1I4OWpKMk8wQWVXU0xReDlPYUY5RU5vZGNN?=
 =?utf-8?B?enlPYmRsVTZUYys2OE5oZ2ZXa1YyWGVmcnc1c0t6VWgzSUZ6TG9aOHNLWUZw?=
 =?utf-8?B?RlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 595b74b1-0040-4f53-ca9a-08daf99ce073
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 21:42:20.3976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KOHy3g6Cjb9O5rHW9GUVd8dyJe9QSPS6FKSc7n99V27tqHizDLpVmpAsE/FXnaobLgNIxK9jEw/cDqkuJcif5mZi8G2Z61q1dRz23vL2JQo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4825
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



On 1/18/2023 10:35 AM, Saeed Mahameed wrote:
> From: Adham Faris <afaris@nvidia.com>
> 
> Add warning macro in the function mlx5e_mpwqe_get_log_num_strides()
> when log WQE size is smaller than log stride size. Theoretically this
> should not happen.
> 
> Signed-off-by: Adham Faris <afaris@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/params.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> index a17b768b81f1..53d2979e9457 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
> @@ -411,9 +411,14 @@ u8 mlx5e_mpwqe_get_log_num_strides(struct mlx5_core_dev *mdev,
>  {
>  	enum mlx5e_mpwrq_umr_mode umr_mode = mlx5e_mpwrq_umr_mode(mdev, xsk);
>  	u8 page_shift = mlx5e_mpwrq_page_shift(mdev, xsk);
> -
> -	return mlx5e_mpwrq_log_wqe_sz(mdev, page_shift, umr_mode) -
> -		mlx5e_mpwqe_get_log_stride_size(mdev, params, xsk);
> +	u8 log_wqe_size, log_stride_size;
> +
> +	log_wqe_size = mlx5e_mpwrq_log_wqe_sz(mdev, page_shift, umr_mode);
> +	log_stride_size = mlx5e_mpwqe_get_log_stride_size(mdev, params, xsk);
> +	WARN(log_wqe_size < log_stride_size,
> +	     "Log WQE size %u < log stride size %u (page shift %u, umr mode %d, xsk on? %d)\n",
> +	     log_wqe_size, log_stride_size, page_shift, umr_mode, !!xsk);
> +	return log_wqe_size - log_stride_size;
>  }
>  
>  u8 mlx5e_mpwqe_get_min_wqe_bulk(unsigned int wq_sz)
