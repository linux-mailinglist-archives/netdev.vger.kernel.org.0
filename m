Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD72696B87
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 18:29:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbjBNR3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 12:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjBNR3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 12:29:46 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5422A252BD
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 09:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676395759; x=1707931759;
  h=message-id:date:subject:to:references:cc:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MANVzePn17WA9FHPFzyCC5BbXdLlxKDuq8zTP2ZkRC0=;
  b=VEi47LQNAVQbCFRNs47dJRebm/+5RUNGBDOFmgf4Avx7yhqC9SYVBsKD
   rwkXmqj8sKJ8SFO0nXF1AJDoBO8N6WcZUPxTvDnpC1U565nQdpiGD+Y6S
   KSB+5B0zyewOynu4BMM/U1KqS8vd04z340hf1WF4A/mI9TiTYVv6DFArC
   WPht2qSRoOwicVgE56TcC/HnFpJxN8DGbnrw52Aecl/kQowieEx4tCJmX
   RrmNWEbshePxPl0azKDWReAfMSA56AQ/IBcnC4bfLFv0mxOTFozy2mkYm
   79ewxhC7vdgkvXPcAyGYh/0Aucp4IdDnBbbKwvfX1PJLHFzvumtrj94lH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="310847438"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="310847438"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 09:29:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="699606479"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="699606479"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 14 Feb 2023 09:29:18 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 09:29:17 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 09:29:17 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 09:29:17 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 09:29:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jbSNFzanqxaPSqlcVepTeTBuT5ZHbWT/GuEjLj8kLaRJn9zvC17YSjAvCQkdQ6kIQ25rxWTvSD+t4vvyQryH86MzA2TirakpHIQJ7C0awHLSS8NMD0qH2CpNxFeqvs/Vsj+U0aldwIUYMWGHfXNdn9ib/cWcJntW8402pAMjt8OKCwW8N7rS/RYXSRiEqL16IDhZs9OfsYCaf+BL2SmrZklXlPYyG29dd3zqkzDtcC6qtaiGjpJ3cbmtl2gAidgJROA0w+flWNVA+qP1mIAwu+6gVIPUSsUtm0O/Ku7r/joCab6YZ8cGsAvD3aOdPw0Yvt5h7MYu+afIJVFz3T5KdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b5v9acWXkhMZI7Jx1VWagSo0PjYzmr5f3xSPVC6Hb1A=;
 b=XYle4k2fKKt2DLMcoeX2Am/09LsCv/GqaPjeawaFjaIJoTdSXz41h8wnFbt5m+XxmEefJuzXTfsjJ28Jtw2e2/t/zqsZ0JbLObIgX61XIaX3oTllYWEqOygPHRlwBv2jhR9FiqIu4NrenVXf5wA5LVe27VPQ3csDUlqrbisr1VCzMqEkeWeOnHeLz7Cjl+g77aCutmsq2NMCHLkzUAjPAsoht9sxNVLGw0u7LKYp3kOoWPQtMwWrRJ94P8hwGjgbmfJrvbN6C/bb8oouuV0acqMo1tfCPalBEGONBty3YBa+yUv0mSG9PAvppj9GBHVNwxOcGsppqA3wY3AqiVbfbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SJ2PR11MB7501.namprd11.prod.outlook.com (2603:10b6:a03:4d2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Tue, 14 Feb
 2023 17:29:15 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 17:29:15 +0000
Message-ID: <f04caea6-128c-2852-bd25-3d01a803f664@intel.com>
Date:   Tue, 14 Feb 2023 18:28:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net v5 2/2] net/ps3_gelic_net: Use dma_mapping_error
Content-Language: en-US
To:     Geoff Levand <geoff@infradead.org>
References: <cover.1676221818.git.geoff@infradead.org>
 <ea17b44b48e4dad6c97e3f1e61266fcf9f0ad2d5.1676221818.git.geoff@infradead.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <ea17b44b48e4dad6c97e3f1e61266fcf9f0ad2d5.1676221818.git.geoff@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0103.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::13) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SJ2PR11MB7501:EE_
X-MS-Office365-Filtering-Correlation-Id: 0233ea35-2fda-45fb-33a6-08db0eb0feb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kIUCNmsfbFdbwrZ4utYdU4gd8XDngVRPQO6Zz3myXFHeyTDe+V81kwAgAN9T9NslaQc61MtP17iB6ifTlPW1rmjqXtLSMID/FeEAEFT/evMQGLS3fczKxVfCFzWcKcTX3W0bBud4BJuhOVNxI2fUkC52RKf5ClPUNYmfI9jhEWJgd2eWOOBIf4SNpgQA4vtY9klklDFyMBVJazZRx+qAozgS1z+PeMRoG0nyIYT4J8ex85nsKjddUn/zYUcvkKkwIVwPRj0MypMNKlCnJWYohmxtJDih7/PTZoNdUJ1cwhU2LLts2MOEDG7NZQmjz7YY9skxwI6sACEXMe0u/nphR9LPiLnz07RM6WHgHZbyTFbSml54BGwHKk7eUTSy0WFXgU1xpknPb8B7527u5hIUbFRapr/Bt+zdP13xrqDn4VMAJH+0wLdwmJDM3Z1/kkJMy0Dv4KfE3Nhg0cXST5ZIc1pmaX2DYBkxlVs+a9mvC+RLdCVCUWW9PJQtR2u5VM2GyXU5PYs5+ER9IH0B5Kz6PiSP/DqICt55o//EbcxxTQ/0NGCoj5+sJjKIGs/xd7HpxpoHrp+kHwleJfNtvuow6h7/HVrey9DzM4ghXcs5NaU/+mXeFLWfvonC3g+j7T6peURMY9Oy0Z50ZI9mTWimkWlZ3UmV7S/f8pw+j8V/LtpWtcWNE1Lf/Wv1JkMm0Xj23FfMa+7ZZ5mT8Ix6Yhunw7Us4b8kKOknhids8lTV9TI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(346002)(376002)(39860400002)(366004)(451199018)(478600001)(26005)(186003)(54906003)(316002)(6486002)(2616005)(83380400001)(36756003)(6666004)(6506007)(6512007)(31696002)(8936002)(86362001)(2906002)(38100700002)(82960400001)(5660300002)(31686004)(6916009)(66946007)(66556008)(4326008)(8676002)(41300700001)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmZTMkw4Q25NbkpicTN2K0FuZ2dqYnBvblhualJhWjdzZ2RBWmx1NVF2NkFl?=
 =?utf-8?B?WWl4aHNyODZ0MGRIaW5INnY4d1JmUUw2Ymx1VzNaYmVLVHIvL2NTMnE4Q0Zn?=
 =?utf-8?B?bXE2TlQ1c1h5YVFzS1g1Zk5mZUwzREZqM3dNTDdmUzJaR0lCR3UyMnkvK2Mz?=
 =?utf-8?B?NkFMRjFKdU0zRnMzWTRnU3BqTC9KUU1GOForMVdVeWhQdENIb3ZLb3N3NjF6?=
 =?utf-8?B?WGl1enFNS2hlQm1NUGNoeGtCRW5XWGNIWmtkeE0wZ1VGODZ6VmZjRk9Bdk5C?=
 =?utf-8?B?aStnMmNvSVNWRHRUcFB5ZXFUZDM0V2FSWEJZWFp5UWsxaWFIeTJ1aTZTSnor?=
 =?utf-8?B?c0U4TUYrWHZWUnI5MjNsOXAvOGp0cVhOaGZ5WjY0MFZJU1hjT0JSRFgvTmxI?=
 =?utf-8?B?d0p1cEp5ckprekxTMjBFVVBqbVhHR3JKNG1YUmZ6TlFsN3hLaVVOOUZYNG5S?=
 =?utf-8?B?MUgwZWtTS2RiajRjZ3NjUVFKM1dJT2VXdHNPRTQvUnBERG93RllLTS9zVnpn?=
 =?utf-8?B?MmVuZTNGWm1zRW9DTTRIOXVvSWFvMlNTbVcwWW5LQ3BIVzg1bUd4QjBmbzVR?=
 =?utf-8?B?dlhnbzhqVzZKbEVaclI2STN6bHNDSGlkVERLZnhIYU0rYXdPRGFGeUtTNFdE?=
 =?utf-8?B?dGNSNmNvRTM0bGlxaHFkT1ZScXFuaVRqWXlIenM4RStNMks3Rm84MEJZTks3?=
 =?utf-8?B?eFdUMHQwWnJJcUlNOENUNE1XRis4ZkJXbFJ5elJjcHFYWnpLSG44SWVFT2or?=
 =?utf-8?B?dGhwVVRVOFBlcmRiSXFsd1JxMURlZHZJY3ZZN01MZVp2NTU2R0Q5eHV4b1Vz?=
 =?utf-8?B?WEt4RTNKYytuK3c1WVovdkdhSEZ0eGFEeGd5VFU1cjR6LzBwZS9RcXFYK1Ry?=
 =?utf-8?B?YzFlU3NybnNnS1E4Y3dMdmdvZmhtczM5Nmh4QmZYYlNnaDdVNFRxZThndFli?=
 =?utf-8?B?YWZmaEJxWkNhUThaTzFIeFZ2UEkwdzloUGxaMm9PMGlHUXppR242aERhbHZn?=
 =?utf-8?B?aXRoM0VTU2RIajdnOUtHYWtGRUtNSEZQbENsTk1QVGtSNmczUXhnNGhtWVMx?=
 =?utf-8?B?elZRbmVZaEgydmJ4RkdKK0VKRnZaZ2ZVRDAweGY4NU1SaERKRDN0d2NnVHI2?=
 =?utf-8?B?bDBhWWFrbVhIL0RMVndzS0c3YjhCVWtpRGdqTkNMUU95U2k2YU9SVzVWTWFL?=
 =?utf-8?B?SkdYcXo4aTl3bjBiNjNIK2xrOVNENmZNcnd4WEtYZllybmYwYXU1WmVjWG9B?=
 =?utf-8?B?TnZLZjZ3QmhlYTdXSmptTHpiSnlCczkyNU5IaURRRllpdTczbVYxWmdNcHJB?=
 =?utf-8?B?RE9lQlZ6RnVhTzB3eHdjc1NtQkV6OU9pNjF3THhvRFZySjd1SjVEeVJiWnBE?=
 =?utf-8?B?Q3pQaUpMNlFQbVVGa0JGa2xqb2IwZ1lhMXV2RS8vWE5hc2gyT2JYMllSQkVt?=
 =?utf-8?B?MHhVbXpUeTNFUkdaSVJwTS9DK0J3WGZidVVJcWJVRTQ4Q21Hb0pMNEgvZDYw?=
 =?utf-8?B?WVlCU0pSejUrQWlTUUQ2ZGxNemY1TXE5Y0ZOK2Q1V04xeGVlRC9KNGtVSkhT?=
 =?utf-8?B?aUNLSUVsRzVwSEZTb3BQdmt0ZXJWN25ZQUM5Q2ZUSXgyTDMwV2RMYWw2L2Z2?=
 =?utf-8?B?emd0WE16VThYT1R5em1DRlphSXhFeHBNTk0vaVBwTXRKd2RHSUc4OWlpd1lu?=
 =?utf-8?B?NUJqS0hwV0RFRUdPN2RnTS81bUNqRjc3TzZMeDFNbGFGL0lLUUFZbUxkTnl3?=
 =?utf-8?B?TkdINVdIWmhCRW5CYUw1anN4ZEN1Tmo3aWpLRDJWTUFETWlBanJ4SG5kTjdU?=
 =?utf-8?B?QUw0WGk3N2tYMFpHWUhZNzhINktGYkJZSCs3UVFTV3VCZDExTXZxT0lnZHEx?=
 =?utf-8?B?WDdOUlBUWEs0aVBIaFluTFNRT0JDcSszNS9yTnNkSTAvSXRrRjZlT1pVVExu?=
 =?utf-8?B?OERCNTVpb1d3MXNaSUgwVmY3K3NyODdpVXlQekIwc3REeFBuZUtub0dnU3Nh?=
 =?utf-8?B?Yzl0UFhpbzkrVHdSdXNTc1dPbzZjejJPQm9HMHFaaUltM2MrbFNscXJKaEIx?=
 =?utf-8?B?S2RMMzUydFZiTHM2RE9CN0J2QjdXdnNFa1FhN3dWanpzRHZ3WVNpQWxlN2Vn?=
 =?utf-8?B?ZkJ4Q29ZT1lFWkdhMU9BQlBEY2JSUElyYkJiUmRHWmlNTndUTEZLRG9kQ2My?=
 =?utf-8?B?T3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0233ea35-2fda-45fb-33a6-08db0eb0feb9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 17:29:15.6296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UsFQQRsNeoeO54dukrxrdHZinTdEgfRlHwq/nuPBwvrCXgGLCib9A9VvLfO/PkoYWvwCGQSAdDZbikBYD5bxTNWFK9NkCYW1zVt2RcCtfzQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7501
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geoff Levand <geoff@infradead.org>
Date: Sun, 12 Feb 2023 18:00:58 +0000

> The current Gelic Etherenet driver was checking the return value of its
> dma_map_single call, and not using the dma_mapping_error() routine.
> 
> Fixes runtime problems like these:
> 
>   DMA-API: ps3_gelic_driver sb_05: device driver failed to check map error
>   WARNING: CPU: 0 PID: 0 at kernel/dma/debug.c:1027 .check_unmap+0x888/0x8dc
> 
> Fixes: 02c1889166b4 (ps3: gigabit ethernet driver for PS3, take3)
> Signed-off-by: Geoff Levand <geoff@infradead.org>
> ---
>  drivers/net/ethernet/toshiba/ps3_gelic_net.c | 41 ++++++++++----------
>  1 file changed, 20 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> index 2bb68e60d0d5..0e52bb99e344 100644
> --- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> +++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
> @@ -309,22 +309,30 @@ static int gelic_card_init_chain(struct gelic_card *card,
>  				 struct gelic_descr_chain *chain,
>  				 struct gelic_descr *start_descr, int no)
>  {
> -	int i;
> +	struct device *dev = ctodev(card);
>  	struct gelic_descr *descr;
> +	int i;
>  
> -	descr = start_descr;
> -	memset(descr, 0, sizeof(*descr) * no);
> +	memset(start_descr, 0, no * sizeof(*start_descr));
>  
>  	/* set up the hardware pointers in each descriptor */
> -	for (i = 0; i < no; i++, descr++) {
> +	for (i = 0, descr = start_descr; i < no; i++, descr++) {
>  		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
>  		descr->bus_addr =
>  			dma_map_single(ctodev(card), descr,
>  				       GELIC_DESCR_SIZE,
>  				       DMA_BIDIRECTIONAL);
>  
> -		if (!descr->bus_addr)
> -			goto iommu_error;
> +		if (unlikely(dma_mapping_error(dev, descr->bus_addr))) {

dma_mapping_error() already has unlikely() inside.

> +			dev_err(dev, "%s:%d: dma_mapping_error\n", __func__,
> +				__LINE__);
> +
> +			for (i--, descr--; i >= 0; i--, descr--) {
> +				dma_unmap_single(ctodev(card), descr->bus_addr,
> +					GELIC_DESCR_SIZE, DMA_BIDIRECTIONAL);
> +			}
> +			return -ENOMEM;
> +		}
>  
>  		descr->next = descr + 1;
>  		descr->prev = descr - 1;
> @@ -346,14 +354,6 @@ static int gelic_card_init_chain(struct gelic_card *card,
>  	(descr - 1)->next_descr_addr = 0;
>  
>  	return 0;
> -
> -iommu_error:
> -	for (i--, descr--; 0 <= i; i--, descr--)
> -		if (descr->bus_addr)
> -			dma_unmap_single(ctodev(card), descr->bus_addr,
> -					 GELIC_DESCR_SIZE,
> -					 DMA_BIDIRECTIONAL);
> -	return -ENOMEM;
>  }
>  
>  /**
> @@ -408,13 +408,12 @@ static int gelic_descr_prepare_rx(struct gelic_card *card,
>  	descr->buf_addr = dma_map_single(dev, descr->skb->data, descr->buf_size,
>  		DMA_FROM_DEVICE);
>  
> -	if (!descr->buf_addr) {
> +	if (unlikely(dma_mapping_error(dev, descr->buf_addr))) {

Same.

> +		dev_err(dev, "%s:%d: dma_mapping_error\n", __func__, __LINE__);

It is fast path. You're not allowed to use plain printk on fast path,
since you may generate then thousands of messages per second.
Consider looking at _ratelimit family of functions.

>  		dev_kfree_skb_any(descr->skb);
>  		descr->buf_addr = 0;
>  		descr->buf_size = 0;
>  		descr->skb = NULL;
> -		dev_info(dev,
> -			 "%s:Could not iommu-map rx buffer\n", __func__);
>  		gelic_descr_set_status(descr, GELIC_DESCR_DMA_NOT_IN_USE);
>  		return -ENOMEM;
>  	}
> @@ -774,6 +773,7 @@ static int gelic_descr_prepare_tx(struct gelic_card *card,
>  				  struct gelic_descr *descr,
>  				  struct sk_buff *skb)
>  {
> +	struct device *dev = ctodev(card);
>  	dma_addr_t buf;
>  
>  	if (card->vlan_required) {
> @@ -788,11 +788,10 @@ static int gelic_descr_prepare_tx(struct gelic_card *card,
>  		skb = skb_tmp;
>  	}
>  
> -	buf = dma_map_single(ctodev(card), skb->data, skb->len, DMA_TO_DEVICE);
> +	buf = dma_map_single(dev, skb->data, skb->len, DMA_TO_DEVICE);
>  
> -	if (!buf) {
> -		dev_err(ctodev(card),
> -			"dma map 2 failed (%p, %i). Dropping packet\n",
> +	if (unlikely(dma_mapping_error(dev, buf))) {
> +		dev_err(dev, "dma map 2 failed (%p, %i). Dropping packet\n",

Same, same (for both lines).

>  			skb->data, skb->len);
>  		return -ENOMEM;
>  	}
Thanks,
Olek
