Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D353660681
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 19:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234793AbjAFSmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 13:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231493AbjAFSmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 13:42:23 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD3F7F440
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 10:42:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673030541; x=1704566541;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eDUuau9/S6v7qcmZupT/6qwUmWPbxF7fxIx1Q09eFz4=;
  b=csWNJAF7x3DeAkOz0ef5CzBjOQcTsqFO6SLLFjrcx18UWzqgr42sw3v0
   XaY8bpvL/IchDx+Zc+TZfs1SOz2ef7AQS8OEqMvGya8+QngXmoPEIVYNM
   GLEEeGArb15maOiZAtp9c3IiRkFzlm2xM2EfQ+PnAyAmHVFEW6Lxfkem5
   G/xhB8howxDjM1fj2U0fCiO1ST94RY7KMHfsRLVqLn3l5nvOcJLoZ0Y+/
   4TMSyxrH29FBWVYSNgiDwbMfR8ahJbKTBZtXtUynvTQuXRRnIJlPvDYPq
   hlckmjT1TRWwWWE65zS/n3yoptTzbEb2s75u/N11b1Mo41TuKs2fUigrl
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="306050869"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="306050869"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 10:42:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="763596936"
X-IronPort-AV: E=Sophos;i="5.96,306,1665471600"; 
   d="scan'208";a="763596936"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 06 Jan 2023 10:42:20 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 10:42:20 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 6 Jan 2023 10:42:20 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 6 Jan 2023 10:42:19 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 6 Jan 2023 10:42:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G6kHxcBiwTYJiyoaXzhswEAQo+NcKY6k5DoQMURcI+CIFd9denmMmN85s/uDCEOONx+7yoDqkv+fRD2iYEyrk7PnjMWEsY0MHuO7/L3oAOCMfqoPRl0sBDlU0F3rOaf6mgze0QNmOoQcNLWQsWe6l/Ou62shKsYgAkYJho4+ApnL7IejBHqDylHcSys+G16gF7cDI/wtSmqSrfmZOWjPiIg50l+QsBnBI9PsUWEf2yGoiKMGmCJSC69Fy8OltZ5v/TJBzIylODoUt96k7A9IGVBEcEvXvRFZeE3MV7Dh3pPBUPOQFDbt8FHiouJJd/IUDq3dIWt/CSelEJ5cJ5GztQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v7DmKTVlB3lVRnTp4bs7z7p4n/iRobYDV3wE/Co7qRk=;
 b=Zbjq+yOxRfdVq3n47T+ydZkosigB5zWW6iXFp+WaPO08IAMGjdcEiD8r6nmfd97rZ4kkZ7ZgTIdkRY1JW8vvDW/9Gg1ST4r8dgZBrsZlehU3YwWEYUNTuuvcIDeqeYiwsU/p5QgVBiVTnZ6sLfC93SDWiTeeuestlZxf96UG4lXYqIpSfIPpm7G2zJSidIzKm81leeMVVXvDwaHH+q/f6Oibb9HEe8Dq23ZOY20gaxD9gfcLP0h2RDZVUUqTLZckrEEBDTtGF0G7U4iyX+r+GIJtqEe0gvUighruq1x/EnSs2pd5DjFQH7sRGl0zPiBfb4NTaBiaekZWwJqh78Yotw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by PH0PR11MB5829.namprd11.prod.outlook.com (2603:10b6:510:140::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 18:42:16 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc%6]) with mapi id 15.20.5944.019; Fri, 6 Jan 2023
 18:42:16 +0000
Message-ID: <6a8b7eee-2af9-b953-8431-875ea9701a89@intel.com>
Date:   Fri, 6 Jan 2023 10:42:13 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 net-next 3/5] net: wwan: t7xx: PCIe reset rescan
Content-Language: en-US
To:     <m.chetan.kumar@linux.intel.com>, <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <johannes@sipsolutions.net>, <ryazanov.s.a@gmail.com>,
        <loic.poulain@linaro.org>, <ilpo.jarvinen@linux.intel.com>,
        <ricardo.martinez@linux.intel.com>,
        <chiranjeevi.rapolu@linux.intel.com>, <haijun.liu@mediatek.com>,
        <edumazet@google.com>, <pabeni@redhat.com>, <linuxwwan@intel.com>,
        <linuxwwan_5g@intel.com>, <chandrashekar.devegowda@intel.com>,
        <matthias.bgg@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Madhusmita Sahu <madhusmita.sahu@intel.com>
References: <cover.1673016069.git.m.chetan.kumar@linux.intel.com>
 <568b6ed1fa2ddf9b8f44980bec9a28df7a24662e.1673016069.git.m.chetan.kumar@linux.intel.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <568b6ed1fa2ddf9b8f44980bec9a28df7a24662e.1673016069.git.m.chetan.kumar@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0016.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::26) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|PH0PR11MB5829:EE_
X-MS-Office365-Filtering-Correlation-Id: df6b6c9d-47c4-43e5-006a-08daf015bba4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PuYmCC5c4RjuBLu4WoJpQ/3GgdU1mjTyZEeqwPNpr3T0Tvov1BOIoTmmpzzo9LuyGachSTeKNl0f1uEQq8VO1qxv9V7ALtmVFKwuAQV9nGxMaa5FcShmcmzSAQojMjSi44TTKejhoOu+FVEbzqi1Qd9FHymnORtgdBXa1F8wpfmhRn74rdMYOZQucqG3Tq8JWZd0MFp+Jlq4As+UazovRytu0blOx5IaGRkwhhtHRNqxnEtMIbjKZs29xR/RwUDnRdbTBQE0fi7RrU7/AybxuQfYy8AW9prVReOKn6KtWqH2xyUxhxOIxklQY94cZBLEQzi7Y+i0PI5EprEHfunRhxbHAOuNBmRpP9D8cFL0qrp8P0oBcXwZdus/V7HomcvUoKhlFxuHyNrLmJZpMNADoPAr4eBrtIXIktdKrM8WlBPVx677dlWGGYe6xUaaMj8rZ4rboptlR8HISY9SBvNJ8OIkttz+HJ5MYgo510l5nHI6VaR8uhb7I73uKLtk1vKtcW/dRtYUGvmsibPHNkMsAT++amSapN82t5/bIOCpDEKwYnfe2JhKMqZTNj5dKjuuBj0CAhroLAxxMm0F/C1+hazSvTuSQfGXzLCFWJXBeg8ML15pCyI942C8VH8l+u2QKUBqtNsTBTioBmRuLHCRlIcAyjpEZp+sOhhwnsy0+b3hYQB0OI0tJC29l/SihzENhhQ5SYXGyJ18jVXr4nFbMjm7p4W25oCGUEL6xenYi2Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(346002)(376002)(396003)(451199015)(83380400001)(6512007)(2616005)(38100700002)(36756003)(8936002)(82960400001)(44832011)(6486002)(478600001)(5660300002)(66556008)(66476007)(8676002)(66946007)(31686004)(6506007)(86362001)(31696002)(53546011)(26005)(41300700001)(6666004)(316002)(186003)(7416002)(4326008)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkI1YUk0Ym1hUnNCa29FdHZNZjJWNUJLZ002WkYzaUgyOC9kN1drNUcySlV6?=
 =?utf-8?B?VlRrNE5hWGtBYzd2VHNralZwb2VwTys0WXZvWDJLWHpyZ0NrM2JPY3I3QXlJ?=
 =?utf-8?B?YTN4NURqQ3Uxa3pGak40VEpDdlFLQ3NTa2tXVlpqWXByUlM2dmJKUlRjTFB0?=
 =?utf-8?B?T2xUWVdsQ1pmdEc5VHNPaVRFWFh5anVyS1l1a3pNZDQxY3h0N1ZzdUM5NzAv?=
 =?utf-8?B?MWRkYnJHNEp4QWlYSEpLTU5wRURDYXlhcGYrY0RJay91M3gxbnFDclNxdEcr?=
 =?utf-8?B?eFNHVWsrc2EwSDFPb3U4ZHkyTHBMa2hLdzE5cWdaNDRnaURQL0hWM3MrV2JI?=
 =?utf-8?B?N2VYT1FYNEZBS3hIWFZGZzdFR1dqbE9DMEs2VEEvT2FQUERBSlU3VVZDWU1H?=
 =?utf-8?B?MytUZG12K2ZpTE91SW8rWFdsNzVsbTZ6NFphRFQ4aGNGVThZK29iWUtKbTZa?=
 =?utf-8?B?a2FlbWZIQ0ZvTHFwcGpJWEU5Nk5ZSWoyR1FGSUtWOGpDclNkRjA1UWRBV2pm?=
 =?utf-8?B?VllLRDZXL0hyNVdlYVV3WldhRzMyUUxRaUZGVk5IZlJZejZYMm01QVcwWlJL?=
 =?utf-8?B?amQ1TzhlTGRURHpHOUpSQ2t2N0NFa1dCaXMwTTJtdXlJN2c1Vmw3Wk93bXU3?=
 =?utf-8?B?NlJLU012bFU4dmplaXJYWWVyd2VDR3lUMXBGTUtIUi9Sb2s5UTExWTNVUFJx?=
 =?utf-8?B?bytzK1JtQUlYYzBUdTJWYjBVSDNMaElXM2JrMWlGZVgyZUtINjk3cWpUc2gx?=
 =?utf-8?B?UVFqZE4xR2tyTS9WWWg0eW1VSWhySDU4ZWprbytQZEtCaktodFVYZHR4dlVw?=
 =?utf-8?B?RndHYmFnRit3Ukx3MkNCKzlYWm5ZVHdmTzZsNkdQQ0dkVHBvS0pwcnBYZWNn?=
 =?utf-8?B?MXZsSDNQNkljMUNyUmVvbThRSWhSbUEzaFdmSFRYV3hVcHE5UWRqbTZZem51?=
 =?utf-8?B?UlFqR3BWZ2FQamJEZGlQVTVDUUZQcnY3aFdkZDdYRWRwdVBNRENnVDlORTJN?=
 =?utf-8?B?NVhtUjAyTjE3Y1hhSmg3VTlFZ1k3SlJNTk01a1J3cDJkb1ViMWN6ZHVSZ29B?=
 =?utf-8?B?Wk12a1pSdGVkWk5sdjhkd3Nkdk92SDM5K095K3JMTWZpcmdVY0d2ZFluMUpE?=
 =?utf-8?B?UWJTeksxOW9XWkIxakZGWTJaa3R5VlpiL01CK2V5ekxMMGlpTGlubEZZbWlK?=
 =?utf-8?B?NFhWamNnanVWaHFYQ3Ftem92QnBYcFRlOXZ5dlhHTEJyamcvcW1qMWloQlVO?=
 =?utf-8?B?aGJ2azg4akJmUjBwd20wUVNJZ3BQZ2gra014ZStiUUtTeDhmR0thN1VUTnpB?=
 =?utf-8?B?anBaeVdsQ2lqdmYrMzBtRjNpcytTQTU3bmczTzBPajFJYjJDbERrTlJJVlhL?=
 =?utf-8?B?NUVnaS9GTFgzMjFjeDUxVDlheGZudTJadllnT1JlQ0tRVklpWVVhWmtUVEZ0?=
 =?utf-8?B?aElWU21oZWt1cWZEai9vK1JkUWtwMDlRZGk4Ymh4MGR4WHNxK1dQaTNDdVk2?=
 =?utf-8?B?bCsxRUxWaSs4Skh6UDlQSS84My96eXU0YTF6RGlKYnRZMTlKRWJ1aHBJUkRD?=
 =?utf-8?B?ZUpsVmZHVzNwV0ZNcWxRREVtTms1bFQwdWxodWV2WDUyL0RYUGpvazlldnRD?=
 =?utf-8?B?QXE2enVsQWpkQmpLeUNKVHdlZ2M0eXFPd010VWtpRFBJOVRodEtsLzF4OWRC?=
 =?utf-8?B?aEpTNjcwZUFqaUR4RlhjTGZ1SmJVMjREaXhJNG91M0ZTMWJ4eVlNUlpNdGhD?=
 =?utf-8?B?ZU1ZK3IyWldoNXVIQThpQkNTYXcxUkpqM0VjNHQ5aGFHajJ0djFjcUZIU2g1?=
 =?utf-8?B?VWxUalNGV2VCN2t6RDE2MWx2VHg2b2pnVmZpRmpaRm54UmV2RUxGdndJQWVz?=
 =?utf-8?B?c1FPZGZnOG5IWnp6L1BDdDNRR3FTQzNvbXhUU0ZEMUFSUFlaT0pIV25sUmcv?=
 =?utf-8?B?bDdqdUxjTDVLK01PdCtPd2dVUXAyVUNaR0crNjRqaXBYUUlKTmtZSkhFeUs0?=
 =?utf-8?B?UjFpRWQxdGZJOFNWOHRrYktISjFGM290dTlhQTYrVlUwNjk4TFVuNXgycmph?=
 =?utf-8?B?RlJ6YVovQXRhb0ZSM1ZiUmVIMHBjQVZveDJmQUhjbzgyaG5MUVJOQm83bG52?=
 =?utf-8?B?NStRTlc2RGV3YmloZk4zMytVUmZCdE51UVVKUzdIZTBZUjZaTW5VK0tWOWRY?=
 =?utf-8?B?dFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: df6b6c9d-47c4-43e5-006a-08daf015bba4
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 18:42:16.1890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PG/mvN5BCh/+d9CfDOLZ7ccoi3JBj0+XWsodpmVXHGiHRtYppjX0vH0vBC0NVLL/A4hmajBd9MtYcIwN/mLp14Ht6+FK8N4qiZRazfgDgGM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5829
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/6/2023 8:27 AM, m.chetan.kumar@linux.intel.com wrote:
> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> PCI rescan module implements "rescan work queue".
> In firmware flashing or coredump collection procedure
> WWAN device is programmed to boot in fastboot mode and
> a work item is scheduled for removal & detection.
> 
> The WWAN device is reset using APCI call as part driver
> removal flow. Work queue rescans pci bus at fixed interval
> for device detection, later when device is detect work queue
> exits.
> 
> Signed-off-by: Haijun Liu <haijun.liu@mediatek.com>
> Co-developed-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
> Signed-off-by: Madhusmita Sahu <madhusmita.sahu@intel.com>
> Signed-off-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> Signed-off-by: Devegowda Chandrashekar <chandrashekar.devegowda@intel.com>
> --
> v3:
>   * No Change.
> v2:
>   * Drop empty line inside critical sections.
>   * Correct log message.
>   * Correct logic inside t7xx_always_match().
>   * Drop hp_enable changes.
>   * Drop g_ prefix from t7xx_rescan_ctx.
>   * Use tab before comment in struct decl.
>   * Remove extra white space.
>   * Drop modem exception state check.
>   * Crit section newlines.
>   * Remove unnecessary header files inclusion.
>   * Drop spinlock around reset and rescan flow.
> ---
>   drivers/net/wwan/t7xx/Makefile          |  3 +-
>   drivers/net/wwan/t7xx/t7xx_modem_ops.c  |  3 +
>   drivers/net/wwan/t7xx/t7xx_pci.c        | 56 ++++++++++++++-
>   drivers/net/wwan/t7xx/t7xx_pci_rescan.c | 96 +++++++++++++++++++++++++
>   drivers/net/wwan/t7xx/t7xx_pci_rescan.h | 28 ++++++++
>   5 files changed, 184 insertions(+), 2 deletions(-)
>   create mode 100644 drivers/net/wwan/t7xx/t7xx_pci_rescan.c
>   create mode 100644 drivers/net/wwan/t7xx/t7xx_pci_rescan.h
> 
> diff --git a/drivers/net/wwan/t7xx/Makefile b/drivers/net/wwan/t7xx/Makefile
> index 268ff9e87e5b..ba5c607404a4 100644
> --- a/drivers/net/wwan/t7xx/Makefile
> +++ b/drivers/net/wwan/t7xx/Makefile
> @@ -17,7 +17,8 @@ mtk_t7xx-y:=	t7xx_pci.o \
>   		t7xx_hif_dpmaif_tx.o \
>   		t7xx_hif_dpmaif_rx.o  \
>   		t7xx_dpmaif.o \
> -		t7xx_netdev.o
> +		t7xx_netdev.o \
> +		t7xx_pci_rescan.o
>   
>   mtk_t7xx-$(CONFIG_WWAN_DEBUGFS) += \
>   		t7xx_port_trace.o \
> diff --git a/drivers/net/wwan/t7xx/t7xx_modem_ops.c b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
> index cbd65aa48721..2fcaea4694ba 100644
> --- a/drivers/net/wwan/t7xx/t7xx_modem_ops.c
> +++ b/drivers/net/wwan/t7xx/t7xx_modem_ops.c
> @@ -37,6 +37,7 @@
>   #include "t7xx_modem_ops.h"
>   #include "t7xx_netdev.h"
>   #include "t7xx_pci.h"
> +#include "t7xx_pci_rescan.h"
>   #include "t7xx_pcie_mac.h"
>   #include "t7xx_port.h"
>   #include "t7xx_port_proxy.h"
> @@ -194,6 +195,8 @@ static irqreturn_t t7xx_rgu_isr_thread(int irq, void *data)
>   
>   	msleep(RGU_RESET_DELAY_MS);
>   	t7xx_reset_device_via_pmic(t7xx_dev);
> +	t7xx_rescan_queue_work(t7xx_dev->pdev);
> +
>   	return IRQ_HANDLED;
>   }
>   
> diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
> index 871f2a27a398..1e953ec7dd00 100644
> --- a/drivers/net/wwan/t7xx/t7xx_pci.c
> +++ b/drivers/net/wwan/t7xx/t7xx_pci.c
> @@ -38,6 +38,7 @@
>   #include "t7xx_mhccif.h"
>   #include "t7xx_modem_ops.h"
>   #include "t7xx_pci.h"
> +#include "t7xx_pci_rescan.h"
>   #include "t7xx_pcie_mac.h"
>   #include "t7xx_reg.h"
>   #include "t7xx_state_monitor.h"
> @@ -715,6 +716,7 @@ static int t7xx_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   		return ret;
>   	}
>   
> +	t7xx_rescan_done();
>   	t7xx_pcie_mac_set_int(t7xx_dev, MHCCIF_INT);
>   	t7xx_pcie_mac_interrupts_en(t7xx_dev);
>   
> @@ -754,7 +756,59 @@ static struct pci_driver t7xx_pci_driver = {
>   	.shutdown = t7xx_pci_shutdown,
>   };
>   
> -module_pci_driver(t7xx_pci_driver);
> +static int __init t7xx_pci_init(void)
> +{
> +	int ret;
> +
> +	t7xx_pci_dev_rescan();
> +	ret = t7xx_rescan_init();
> +	if (ret) {
> +		pr_err("Failed to init t7xx rescan work\n");
> +		return ret;
> +	}
> +
> +	return pci_register_driver(&t7xx_pci_driver);
> +}
> +module_init(t7xx_pci_init);
> +
> +static int t7xx_always_match(struct device *dev, const void *data)
> +{
> +	struct pci_dev *pdev = to_pci_dev(dev);
> +	const struct pci_device_id *id = data;
> +
> +	if (pci_match_id(id, pdev))
> +		return 1;
> +
> +	return 0;
> +}
> +
> +static void __exit t7xx_pci_cleanup(void)
> +{
> +	int remove_flag = 0;
> +	struct device *dev;
> +
> +	dev = driver_find_device(&t7xx_pci_driver.driver, NULL, &t7xx_pci_table[0],
> +				 t7xx_always_match);
> +	if (dev) {
> +		pr_debug("unregister t7xx PCIe driver while device is still exist.\n");

nit: s/is still exist/still exists/

> +		put_device(dev);
> +		remove_flag = 1;
> +	} else {
> +		pr_debug("no t7xx PCIe driver found.\n");
> +	}
> +
> +	pci_lock_rescan_remove();
> +	pci_unregister_driver(&t7xx_pci_driver);
> +	pci_unlock_rescan_remove();
> +
> +	t7xx_rescan_deinit();
> +	if (remove_flag) {
> +		pr_debug("remove t7xx PCI device\n");
> +		pci_stop_and_remove_bus_device_locked(to_pci_dev(dev));
> +	}
> +}
> +
> +module_exit(t7xx_pci_cleanup);
>   
>   MODULE_AUTHOR("MediaTek Inc");
>   MODULE_DESCRIPTION("MediaTek PCIe 5G WWAN modem T7xx driver");
> diff --git a/drivers/net/wwan/t7xx/t7xx_pci_rescan.c b/drivers/net/wwan/t7xx/t7xx_pci_rescan.c
> new file mode 100644
> index 000000000000..67f13c035846
> --- /dev/null
> +++ b/drivers/net/wwan/t7xx/t7xx_pci_rescan.c
> @@ -0,0 +1,96 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (c) 2021, MediaTek Inc.
> + * Copyright (c) 2021-2023, Intel Corporation.
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ":t7xx:%s: " fmt, __func__
> +#define dev_fmt(fmt) "t7xx: " fmt
> +
> +#include <linux/delay.h>
> +#include <linux/pci.h>
> +#include <linux/spinlock.h>
> +#include <linux/workqueue.h>
> +
> +#include "t7xx_pci.h"
> +#include "t7xx_pci_rescan.h"
> +
> +static struct remove_rescan_context t7xx_rescan_ctx;
> +
> +void t7xx_pci_dev_rescan(void)
> +{
> +	struct pci_bus *b = NULL;
> +
> +	pci_lock_rescan_remove();
> +	while ((b = pci_find_next_bus(b)))
> +		pci_rescan_bus(b);
> +	pci_unlock_rescan_remove();
> +}
> +
> +void t7xx_rescan_done(void)
> +{
> +	if (!atomic_read(&t7xx_rescan_ctx.rescan_done)) {
> +		atomic_set(&t7xx_rescan_ctx.rescan_done, 1);
> +		pr_debug("Rescan probe\n");
> +	} else {
> +		pr_debug("Init probe\n");
> +	}
> +}
> +
> +static void t7xx_remove_rescan(struct work_struct *work)
> +{
> +	int num_retries = RESCAN_RETRIES;
> +	struct pci_dev *pdev;
> +
> +	atomic_set(&t7xx_rescan_ctx.rescan_done, 0);
> +	pdev = t7xx_rescan_ctx.dev;
> +
> +	if (pdev) {
> +		pci_stop_and_remove_bus_device_locked(pdev);
> +		pr_debug("start remove and rescan flow\n");
> +	}
> +
> +	do {
> +		t7xx_pci_dev_rescan();
> +
> +		if (atomic_read(&t7xx_rescan_ctx.rescan_done))
> +			break;
> +
> +		msleep(DELAY_RESCAN_MTIME);
> +	} while (num_retries--);
> +}
> +
> +void t7xx_rescan_queue_work(struct pci_dev *pdev)
> +{
> +	if (!atomic_read(&t7xx_rescan_ctx.rescan_done)) {
> +		dev_err(&pdev->dev, "Rescan failed\n");
> +		return;
> +	}
> +
> +	t7xx_rescan_ctx.dev = pdev;
> +	queue_work(t7xx_rescan_ctx.pcie_rescan_wq, &t7xx_rescan_ctx.service_task);
> +}
> +
> +int t7xx_rescan_init(void)
> +{
> +	atomic_set(&t7xx_rescan_ctx.rescan_done, 1);
> +	t7xx_rescan_ctx.dev = NULL;
> +
> +	t7xx_rescan_ctx.pcie_rescan_wq = create_singlethread_workqueue(MTK_RESCAN_WQ);
> +	if (!t7xx_rescan_ctx.pcie_rescan_wq) {
> +		pr_err("Failed to create workqueue: %s\n", MTK_RESCAN_WQ);
> +		return -ENOMEM;
> +	}
> +
> +	INIT_WORK(&t7xx_rescan_ctx.service_task, t7xx_remove_rescan);
> +
> +	return 0;
> +}
> +
> +void t7xx_rescan_deinit(void)
> +{
> +	t7xx_rescan_ctx.dev = NULL;
> +	atomic_set(&t7xx_rescan_ctx.rescan_done, 0);
> +	cancel_work_sync(&t7xx_rescan_ctx.service_task);
> +	destroy_workqueue(t7xx_rescan_ctx.pcie_rescan_wq);
> +}
> diff --git a/drivers/net/wwan/t7xx/t7xx_pci_rescan.h b/drivers/net/wwan/t7xx/t7xx_pci_rescan.h
> new file mode 100644
> index 000000000000..80b25c44151c
> --- /dev/null
> +++ b/drivers/net/wwan/t7xx/t7xx_pci_rescan.h
> @@ -0,0 +1,28 @@
> +/* SPDX-License-Identifier: GPL-2.0-only
> + *
> + * Copyright (c) 2021, MediaTek Inc.
> + * Copyright (c) 2021-2023, Intel Corporation.
> + */
> +
> +#ifndef __T7XX_PCI_RESCAN_H__
> +#define __T7XX_PCI_RESCAN_H__
> +
> +#define MTK_RESCAN_WQ "mtk_rescan_wq"
> +
> +#define DELAY_RESCAN_MTIME 1000
> +#define RESCAN_RETRIES 35
> +
> +struct remove_rescan_context {
> +	struct work_struct service_task;
> +	struct workqueue_struct *pcie_rescan_wq;
> +	struct pci_dev *dev;
> +	atomic_t rescan_done;
> +};
> +
> +void t7xx_pci_dev_rescan(void);
> +void t7xx_rescan_queue_work(struct pci_dev *pdev);
> +int t7xx_rescan_init(void);
> +void t7xx_rescan_deinit(void);
> +void t7xx_rescan_done(void);
> +
> +#endif	/* __T7XX_PCI_RESCAN_H__ */

