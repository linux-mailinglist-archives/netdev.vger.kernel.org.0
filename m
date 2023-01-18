Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36316725A7
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 18:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229708AbjARR63 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 12:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjARR62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 12:58:28 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0651B2CFEA;
        Wed, 18 Jan 2023 09:58:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674064706; x=1705600706;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wWX1bXgmVHVUmgFF6MyWfePRu8xV0PCeO7aBLXFNvmE=;
  b=Xcozp3nuPdCHFcl3O8jC4dQCcfAlWagksNDMP1I1ngdJd1RifkeJPgH9
   BlDC9L82qLaMi6qgQTib194B1xFD9MqSJ6qH6kxetQTGAWDp8eFtLFvLq
   H3SIS0eMtjhhdm9tvCBRpBf0OzerP4Qe3hr+5e/72LrTxBtcram2HyEj2
   5kSIMDPYkj+3DMne2fRLSWWA8p5EVIzTcWWd4PukkOBgpA4SPEUeEfOXg
   3sVeLXeBOjIG/ThWNSfad7Go84CtVsD/J/bfiRcCvXV9tfCM5+xg4lR0p
   bJ8FaH8q4126YL4gK548Pk4WT6uHTJIUDSa/AwJRYalyMvXLHo+tQjQJV
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="411291427"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="411291427"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 09:58:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10594"; a="609741847"
X-IronPort-AV: E=Sophos;i="5.97,226,1669104000"; 
   d="scan'208";a="609741847"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 18 Jan 2023 09:58:05 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 09:58:05 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 09:58:05 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 09:58:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OhWjS5A3Z7OSFYKqS7TxqX6lZYi94EIueE3sn78HuMa5ijTJ7fKe8nbv7Jtcz4aLzbr4ySbCoupdlBPgGa+yWOUG03/vl55bAukQeK9PQ+YNfUUqSISvi0yjzfDvpVNvAI5YpHre4BhQgmKICyETdrGtfO9RAtjcbP9Cxjv6G7aTlFoqBE6Jp61zCP7udkQ+eoGTNU0YqO0lhHTKwcLlZf84UcX/TCIz/rfHSpWvQM+vzF57C6XVNC3KdfOQFm+K8irVLLnS7rYcH/6jnCpvW84/VgLtLtoF0yabs1s+McCp1EXCKTX+Ty/0StDDhd5WeGuGgR5WeFD8GpPYIOjnTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QnQbgfvcw6BYJzERqp16h+EQyo+ddfdt7iaot0/sR3Y=;
 b=TH/XlsNX/fNwveBGkRO8ju2gEuqwTZBrzU7tt0Lnkbe/6Gj4fwYcGDpohiiXK1WYSuxbxUhvpCWRNu7hWWJ4joPt8OrLB21VD1DkXJmpghiqNJhjjFsU8izR/AvZU1h9rWlIsdtjCVmnZAt4dHA7FR6OAvqOQcqkt1c6mDJjwd/sihAzJkznDMyQDiN3Wa+l2HMw5NjN2QYfLzt1w+traklFL7l/F87a4roM2MSIvSyLsiRkSYsKEJy6v97mkK96xEWvdqkr4QvcJ+AF2QMP7RnHK56ynPwhqrrxR9RnKWkPn7z3rtIHmRFHedaDg5dxTgGz11KyFSmekPwxRkiQRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by CY8PR11MB7134.namprd11.prod.outlook.com (2603:10b6:930:62::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 17:58:02 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::933:90f8:7128:f1c5%5]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 17:58:01 +0000
Message-ID: <a36a4ac1-5775-f66d-a453-04c7dc1293da@intel.com>
Date:   Wed, 18 Jan 2023 09:57:58 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] i40e: fix dma alloc/free prototypes
To:     Arnd Bergmann <arnd@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shannon Nelson <shannon.nelson@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC:     Arnd Bergmann <arnd@arndb.de>, <intel-wired-lan@lists.osuosl.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230118090120.2081560-1-arnd@kernel.org>
Content-Language: en-US
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230118090120.2081560-1-arnd@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0045.namprd07.prod.outlook.com
 (2603:10b6:a03:60::22) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|CY8PR11MB7134:EE_
X-MS-Office365-Filtering-Correlation-Id: 87c05192-2463-4fc1-02af-08daf97d8a4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f1SeThmxHkyvHoZrmORmlCSWx3FbCzKrrA043Fj9jxh0crnuEc7OrJXn47DMi3w/bz52b+uPR/QcLrQA8kzOJg2Did12wVQaiDR8iPgdlxgOZGjUAUjOSath2EdukFYwDHN35lu6ch+MrTFjaRZXdye3GXkgYrZR6vISLOJc/ZSeAlEHCKrkVbhVFlBIXt1gqeoakkRhMnxYo9aDjz0mFhF3rGk3gyrTCw0neFyexnxDUwbnLzWfs+OLu34lojiv5DyLP2RqTMbgujLxJQjl/5oB3JTNKKIX0Pf98UUouXFkp/UZ+GmCnHqq1KsWAC4ilPR6abl6tvL7YfWilKNQEeuD/3FTTMkqc9FHuMntKcB7DYYhsm0r+SYY8PpEdRqXhNoYFIouzbR4LP3lGYESoTd1IAAGGLhkkFUBPq9zxsHKYuNNBgZZTurmtEriNd+CqbFiz/2TiQ0G88yu5Pus3XJ6gB7DyStJ1TQ22sUiYZHwYouSyv1OStQsj3EvDnco58PMkgUu8xZ6x/QgAZSNuQMpNRNP32LfKf7kbfn/yCk//2P4JAlD9eb1aKFRwPZObDbwu40dEdFkqgs4WzPYFwNDf2HwZkH2xB4qyj59TmdpMa0TAhCSLEcY3/j14vthIIUfnd3bB96oXX5F/kHgf5/n5hFZwwBwwDsFndWeLI24idWXpB/jqNp3C2ETq2E/NBba5Hg/G73Wk3q7eoDcmfW4O4yRriYAMbyur5aP7q7NHDv9cjT+3qGcTFKct+q8l8LZ0pDSJCKg9wRRPgvvcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(39860400002)(376002)(366004)(136003)(451199015)(86362001)(31696002)(8936002)(36756003)(26005)(41300700001)(186003)(6512007)(53546011)(4326008)(8676002)(66556008)(66476007)(2616005)(66946007)(6666004)(6486002)(6506007)(316002)(478600001)(110136005)(6636002)(966005)(38100700002)(2906002)(82960400001)(83380400001)(5660300002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tk05NXZnWVZobTRWVlN1QjJzajIyUC94Uy85VU5VQ3lnT3NBRDBWVGM0Qy82?=
 =?utf-8?B?N1AzWVd0UllYdHFRWHZwSEg0bm5RNDNYZ2p0SDh0R3VkQW5hbWd2UkZQTjhX?=
 =?utf-8?B?MjlmRncyT3ltQ24rRnA2RzRNdWZRU1ZOWU9TUjdkVVMzNEdycC9UMVFqcEh2?=
 =?utf-8?B?QlJtZGFocnE5SDl2TjNwcTlueEJsV0lrTTFGb09GbVd0UEc1T2JBalU4U1FZ?=
 =?utf-8?B?S3lTcWpwNkY2YTNickJSV01DWEFOczl4UFpDV00wSTFEeXk3SzVMZU9FL3c3?=
 =?utf-8?B?NTNjZ1lYMnAyU0QwdXF1UlpuZGVHUG5WcDFVaU80clNvdUFCZ1dQRlFScnp2?=
 =?utf-8?B?bi8rS0NNZmI3WUpYMmQ0QS9BMnd5ekgraXMremNPQVVjaU9vQWZocXF4enRm?=
 =?utf-8?B?dkpOS3o2SEs3QzBqb3FhQWtOYndrQmZnNTFqaUdHbWNRcXBpSHU3cW9zYk1D?=
 =?utf-8?B?ak5uRVVZc3d1UFA2RmtpZG9MTEE5OUFDeVZmRUF3K3Z5cUZ5eFlIZ3BVWVVL?=
 =?utf-8?B?TWRWdktaU2VTRzdGMjJQbmdTZTJEck0zK1VvQW8rNytXZnRHYWtURXkzWCtv?=
 =?utf-8?B?WTFQM1NRRVlVSGw2K0MxRFhiSmowb1liZk42bGNqUDQ0MkxST3V5WWl5NTV6?=
 =?utf-8?B?Z2xaaDRVL09pWjNWajd6M1BFNXZWZkFWcmxQWHQyODVpMmdDdERHL2JzZndr?=
 =?utf-8?B?TGxiSEw3VUg3cC9Wd0dscUx1Y014eEdya3hDNitEaWsrUTZaUWFyUEVYcEQv?=
 =?utf-8?B?Mk9iMjFnZ3ovM2tOOUJWM0VhOEliTEFoV21sd3NXT2hJU2U4MldwZC9RVzJQ?=
 =?utf-8?B?SFc2QXNsU3RSdHY1QVRrOUtaVDAzMGs2ZGRZY29ybmJoSkFnb0lEY3JjTlAw?=
 =?utf-8?B?YWJuOGw3Sk5GVEdSMmFkeFpURkY5N0QycXBlTnpKTG9xd051UHgrYmNZQnRX?=
 =?utf-8?B?VWRNV1l3alFjcHlNd3NiSjZHZzFCS2xyY3BLVE83azdYL1Fka3Aza1IrQ2tR?=
 =?utf-8?B?SnpEK3JyZkZGa3VoQlQ2UWlOMUpiWmIrdFBpR2ZFN25HbGNUQWNDTEJiaENJ?=
 =?utf-8?B?b252Tjl0YjFaNjJESnBkejZLbENJOFJaeUVyb0dQUmN6N2tpMmZGWG14YXpo?=
 =?utf-8?B?K3dUSGlXaHdXbzl3SmYzV2hMUzVPMWdhWUY2Q0hXSWMzeEp5QXh1eVJNMWx1?=
 =?utf-8?B?QWpwT0g5TGkwdVRTWjJWVlp5TGFaa1FoVURKOUFLK2FFcFA4YTVCSzJNcStp?=
 =?utf-8?B?OTV6SzZxMXd0STU5RFlYbW9keTBhWkRESVREMWt4MkhEUXViM0JLd1AvYVow?=
 =?utf-8?B?S2pmMGdGKytteCtvdFdpRDVnOUdBdFNaZTY5YTd2YUMrQmdhZ3p0Qjh4d3dE?=
 =?utf-8?B?eUEyWm1rN2czcDZoUTVzb0VhWUFxUVdWcFJPWlBzUjAxK2pkN1RUN3dTZGEz?=
 =?utf-8?B?T1hxSFBmVUozSWZVcmdtZklQZEVhRW9UZkduVndXcmJTTTgyeDhSQVhHK09M?=
 =?utf-8?B?RHRXdmIxRHUvc25TeTF1TlRIZzhxMUo2c1B1YjlrY21GMkNSVmdiQTRmajd4?=
 =?utf-8?B?WFJEMmpQdldZeXo3NHJKR25uL3lVenR4VkpjSmd2K0RlYnowZis1RDB0Yjc5?=
 =?utf-8?B?VXBEVTRiSkhZWFJnN0F0M3Z6dithU2ZGVDBPZkVBVE1PL3lsbE12a3BRa1dj?=
 =?utf-8?B?YXhsTEZpYjhMQVVsSVhWbWprZElCNkl4Ung0K2J4Wldqak9vcllZa0FSbWNM?=
 =?utf-8?B?eHl0QVpUV0wyK2VnS0FGQm5yUDZtVDFHeHJUTDlVeWdtRVdkSEo3eithbWxD?=
 =?utf-8?B?QXpzUTY0NzJLVzVQcHJYT3lVYzZPaGNLQmgwTlJsRC9JZlpUU016Lzl3ZXdQ?=
 =?utf-8?B?NmtUZTJIOGdRU1NUTUNJZjZUU0VTeXB4UHpxbkIzcElmYzM0eitYTTc4NFQw?=
 =?utf-8?B?Nkl5ZFprK283cWxNVElGMk1GZm9lWWtFTThzZ0R6T3dmRmtYZDFjTEpRNjlw?=
 =?utf-8?B?RHN5bENWdFg2UXZDZjd6eEkxb1FVd0lyazhYUUticWR2QUZKVjRHOVBNT3k2?=
 =?utf-8?B?R2V6UXZIbGlHZVZzeEt2a2o1dnZJV2ZuR1U1cndLQ0FMU1g0b2g5VHd5Wkds?=
 =?utf-8?B?Y25tQUlRaDJkZnh6c0k5dmZyVlRQeXhObVZtdlN6UjR0RzZlcGdJVkI1eWVl?=
 =?utf-8?B?ZkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 87c05192-2463-4fc1-02af-08daf97d8a4c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 17:58:01.8436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AdwL0r0rOsMXlK4iPVfxoRua5R+I9IWdOvUDS+a8nD0x+iVlgQzZfVho+Nng/bLrS32huoF/Hc/JF3og8dmEnsVw9j2R0ZwlGmZuGQiJtaI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7134
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

On 1/18/2023 1:01 AM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> gcc-13 notices a mismatch between the declaration and the definition
> for a few functions that apparently used to return a i40e_status_code
> instead of an int:
> 
> drivers/net/ethernet/intel/i40e/i40e_main.c:129:5: error: conflicting types for 'i40e_allocate_dma_mem_d' due to enum/integer mismatch; have 'int(struct i40e_hw *, struct i40e_dma_mem *, u64,  u32)' {aka 'int(struct i40e_hw *, struct i40e_dma_mem *, long long unsigned int,  unsigned int)'} [-Werror=enum-int-mismatch]
>    129 | int i40e_allocate_dma_mem_d(struct i40e_hw *hw, struct i40e_dma_mem *mem,
>        |     ^~~~~~~~~~~~~~~~~~~~~~~
> In file included from drivers/net/ethernet/intel/i40e/i40e_type.h:8,
>                   from drivers/net/ethernet/intel/i40e/i40e.h:41,
>                   from drivers/net/ethernet/intel/i40e/i40e_main.c:12:
> drivers/net/ethernet/intel/i40e/i40e_osdep.h:40:25: note: previous declaration of 'i40e_allocate_dma_mem_d' with type 'i40e_status(struct i40e_hw *, struct i40e_dma_mem *, u64,  u32)' {aka 'enum i40e_status_code(struct i40e_hw *, struct i40e_dma_mem *, long long unsigned int,  unsigned int)'}
>     40 |                         i40e_allocate_dma_mem_d(h, m, s, a)
>        |                         ^~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/ethernet/intel/i40e/i40e_alloc.h:23:13: note: in expansion of macro 'i40e_allocate_dma_mem'
>     23 | i40e_status i40e_allocate_dma_mem(struct i40e_hw *hw,
>        |             ^~~~~~~~~~~~~~~~~~~~~
> 
> Change the prototypes to match the definition.

Thanks for the patch Arnd, however, the problem with this is the call 
chain of these functions are returning i40e_status which, with the 
propagated values of these functions, will push the warnings up I 
assume. We have a series coming to remove i40e_status altogether [1] 
which should resolve this issue.

Thanks,
Tony


> Fixes: 56a62fc86895 ("i40e: init code and hardware support")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/net/ethernet/intel/i40e/i40e_alloc.h | 20 +++++++++-----------
>   1 file changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_alloc.h b/drivers/net/ethernet/intel/i40e/i40e_alloc.h
> index cb8689222c8b..e9c4a8fda9de 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_alloc.h
> +++ b/drivers/net/ethernet/intel/i40e/i40e_alloc.h
> @@ -20,16 +20,14 @@ enum i40e_memory_type {
>   };
>   
>   /* prototype for functions used for dynamic memory allocation */
> -i40e_status i40e_allocate_dma_mem(struct i40e_hw *hw,
> -					    struct i40e_dma_mem *mem,
> -					    enum i40e_memory_type type,
> -					    u64 size, u32 alignment);
> -i40e_status i40e_free_dma_mem(struct i40e_hw *hw,
> -					struct i40e_dma_mem *mem);
> -i40e_status i40e_allocate_virt_mem(struct i40e_hw *hw,
> -					     struct i40e_virt_mem *mem,
> -					     u32 size);
> -i40e_status i40e_free_virt_mem(struct i40e_hw *hw,
> -					 struct i40e_virt_mem *mem);
> +int i40e_allocate_dma_mem(struct i40e_hw *hw,
> +			  struct i40e_dma_mem *mem,
> +			  enum i40e_memory_type type,
> +			  u64 size, u32 alignment);
> +int i40e_free_dma_mem(struct i40e_hw *hw, struct i40e_dma_mem *mem);
> +int i40e_allocate_virt_mem(struct i40e_hw *hw,
> +			   struct i40e_virt_mem *mem,
> +			   u32 size);
> +int i40e_free_virt_mem(struct i40e_hw *hw, struct i40e_virt_mem *mem);
>   
>   #endif /* _I40E_ALLOC_H_ */

[1] 
https://lore.kernel.org/intel-wired-lan/20230109141120.3197817-1-jan.sokolowski@intel.com/
