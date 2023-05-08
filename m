Return-Path: <netdev+bounces-939-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36E806FB6BD
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 21:26:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 865292810B4
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 19:26:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7619611196;
	Mon,  8 May 2023 19:26:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B98AD43
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 19:26:50 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C9A1FFB
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 12:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683574008; x=1715110008;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=l09YtlKUP7MVnvM3WuG99SiRPWkXToqAiynIE2fs1os=;
  b=emudw9t2e2Eud1FZlrBtshO4LPBAcqTVPfGO3mEqlfPjW1VHyxRiHhrm
   6mt/GFBU61cj6wnUz/hkO03+emAo6H14EOSlyNXmFD5SzHZS9ZRciM5Lp
   52HAnz+TEFWPJmnefbskmglLfEol8Rg56zeZdD8T0Gpt92ZB06c2irQgR
   KWcN7FXGSm79nf80fIJLWtGB38bLfHfvoo32QDbdcSd3NE27j6dSMzeE/
   GGh8C02zgeicKRf6N/zecZSUUZDWqTUaY4V8eSx6HXJeT7O5dOXp0xI9W
   d6pGlueE+VK7LPLzufYlfkYCaMxWtd7pJxQ8DtIVCpHzhiAsmfPjRMXbB
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="334184342"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="334184342"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 12:26:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="692698784"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="692698784"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 08 May 2023 12:26:48 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 8 May 2023 12:26:47 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 8 May 2023 12:26:47 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 8 May 2023 12:26:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UzSVEu0elA5NZDGgXbJt9oKPN1578c8zFq+wxJwpEIxAzBErd7Nd4wz/bHtfUw/5E8sCOq2kmmrxdwPvm/hUJM1HMAbnWy7p2KGCs23To67M0XF1HtbZshTmZphlAG6L0UjSgxKiJCS+us8LnVAH4ZquU+eBjfm/8TdvaxjmMsGVU3gfyz4WR8j9ZWuzhH3nExJ41H9B6TwRqfBVHa10dZmXoCD0O0F/LPGDobUjvR4a87+GdQgKH4/j0Affo/EAmXuG3cBWN8Y6fdyaX3ZGeI9+k0B2d4IdiV1gRTnrGhSh3yC5YV+psLzgi09mgveI9I8bZxwX7H7TzLeXu+2Aww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fhJfBQrXIbD7czgqZuI3wRtQp1yh0Hs3LxQBDJswbN8=;
 b=Dnei6eZoH0yJM+pwD11cTyfxLbV+mClaUr/pDr1R/NdrR5FIVoqGUL15gq8YE/RAUawaYHddpa9LU7Kd/1jd7MxsnhNa6Zd5xQF2F/vTWIO48yM+a52dfN54nlYGlyTa5bJ3V6nZhzDdKN+7L7GuZ7jwH4rDAN1oCawKqy/2NQBJDxGxXbxlin9aJIpFLUS3qHRl8Z8DIDZ6Zwx/4j1GHjhc0aZVHfaSUg9Lb7d3kMNK+kmVvvR0lyf9dJrQBOCEQHSuGSOlv14VuWwiwQCHeHKy+qAp+g8EN09O7YyZwC2oqpz+f6YgZYr/aEWPX5vpD0pACyl9rIHiBUCnSzPyvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by CO1PR11MB4803.namprd11.prod.outlook.com (2603:10b6:303:95::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Mon, 8 May
 2023 19:26:46 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::9c59:d19c:6c65:f4d6]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::9c59:d19c:6c65:f4d6%6]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 19:26:46 +0000
Message-ID: <b245a442-bfba-aa7e-0437-928090ca1f26@intel.com>
Date: Mon, 8 May 2023 12:26:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.1
Subject: Re: [PATCH ethtool] Fix argc and argp handling issues
To: Nicholas Vinson <nvinson234@gmail.com>, <mkubeck@suse.cz>
CC: <netdev@vger.kernel.org>
References: <4b89caeddf355b07da0ba68ea058a94e5a55ff59.1683549750.git.nvinson234@gmail.com>
Content-Language: en-US
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <4b89caeddf355b07da0ba68ea058a94e5a55ff59.1683549750.git.nvinson234@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0139.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::24) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|CO1PR11MB4803:EE_
X-MS-Office365-Filtering-Correlation-Id: a7bfc7b8-104b-4bf8-4ec2-08db4ffa29ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VBgB5LSQcUO0KhB2b3YkgZQa+yx+F130sgces5GZFyHyeFUswmfXiuy4TZs2bjX/EmgR6Lbx8tetUrGN/D6wMjwUCBLYBjH3gqevbRte5uhZXAWKvycSRwUQRFfqSbKIYeDFCDbLgWwYR8pvHUIFpxgra4ZK2i8lmZ2qi5C3zVosvKBoZEYZgL+FAVMiRmiYqTAyzuyZ4it6V6jCzoNuB0/5DQwBuw1YLu8H6zpiA6HJEKb4cjwXkC3AAR0v2jxgvYGQLDvdrH6NAu2duMAWxqPgqEBkG9UUSn6uT7+7AI+kws1wifPL1L/MzQHiag5PFos8YaV/LepSRz8bY2/bbtHDX2wYPUw96rUVyHR5xUEVHt1FVmQxuZl/sk5LCd/0HnEOPCvhyq5a2cwhuCyIVotta4iIan/13Bciplbm3WSiSXc0acbgLNgoBekUMwY/wvYJ7nh7keJ0XkANqb7Bq8U8lBmj08XjbQqn3L8OniCbgxKYOSo712D5AMi80W+IfP0LANwaYnOdRFt2yCzmRmGhcby4rbzsTzQLhil5+4GbA5wKCLN7yje9sRNhv5XUe2yOy/KrYpLC67s2N6vdmkeJIi2TQtgMJedSJ93zhL8Z4S9BbTd2DoHh0WgwY5+lBTmx6gisNPtcmDuHqW0KkwhWBHblI3/qJuRIIcDwg9G3VHOx7ucEIfQ41vyKCBJJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(346002)(396003)(39860400002)(451199021)(31686004)(2906002)(4326008)(8936002)(316002)(478600001)(66476007)(5660300002)(66556008)(8676002)(41300700001)(6666004)(44832011)(66946007)(6486002)(966005)(6512007)(53546011)(26005)(6506007)(186003)(82960400001)(2616005)(36756003)(83380400001)(38100700002)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ejIwaFdScmdLWStYcHl1b1E1YTMwdjJ2bVJnTzZJVHp5L2QxWDlIZ01pV290?=
 =?utf-8?B?dmVNcUFkblgzVnN4THVCWnFDaFk0TGZDZ203T3h3SzlwVW1mYmY5TzFINGdS?=
 =?utf-8?B?dEswT2FmT3kvQS94SDBWc3lVRjV5dyt0VHRKSllwUkp2RWlPcDFncUtSaVlN?=
 =?utf-8?B?aDZtbHU4RXRUbGRPeEZVd2VUTW92R1FkcXhjTDEvUm9QM2pMZTlrbXN4NUNQ?=
 =?utf-8?B?S3dtQXNod1U2SUZ0VXcxR3JUcE15TllJbTBBRWJVcWlLRmxyT1kzeTJQSysx?=
 =?utf-8?B?OW9MZE5iNzFQT3JMM2ROL1ZYTkIwK2JYMHY2eWk5YitsSFJGakJFR0trdll0?=
 =?utf-8?B?R0QwMWZjZVRjYlBrZ1F2TnFuWHpGaUo2UW9SZ1ZySWVSdVZsU2dXeEQ3UDB1?=
 =?utf-8?B?VTN0c3RnK1VmOEN0OXhpSHRGaEZqTldVa2VHT2VlTThTY0cxNzJxdmdOa1lL?=
 =?utf-8?B?RDVWNmplTTczQkZLVlRNQldUdTE3MjYzSFljYVhSeHdISnd2V0pTZXVjWjRR?=
 =?utf-8?B?MG5rZnVqU0xTdXFnSStCdkMwL0ttUWxCR1hocEVvSDVtWE55SjlCWk1OMngr?=
 =?utf-8?B?b0ZBTng3eHliTTQ0OUxSMWJIL05lZFY2Y2syL1BZQ0VxTXRvK2drRGNXQWFY?=
 =?utf-8?B?VUxvSnA3anFaWkYwNXpMWmtVd3VTNjR6VHE2a1BWUXBnYWFDVExXWTlENS9F?=
 =?utf-8?B?OTl6RVlIRExRYzhoWFVVcDQxVFY5V2ZBTVVTMW1EZld6SVJ4ck93TEthS3dL?=
 =?utf-8?B?Mk81dnpKTW51NDR6VFVoN1luRzNLTTAzU2ZlR2NtM0N3b0hFZ0pBSENwdWg0?=
 =?utf-8?B?VzJJZjZGQUNCbW9iZUpOdXo0dUkrYzB0RkJXb3hIWlU3UGoxTVlqc0pLMWJs?=
 =?utf-8?B?WTFseU1KNXMvMlpxbi9GTnRnOXhmNkYzSmNZRzd3ZjBpdUxmbE1oZG5JUUFR?=
 =?utf-8?B?dGtCWjU4UkdONThLa0Zjb0VVREhEeWhGUitxdXFna0orRVBSWXZDZWhYWjUv?=
 =?utf-8?B?MHpPbVAwYU1yMEkzTWhiand5RlZxalM0RlJBNk1qRWZEczB2ZmJLZWZtSmgv?=
 =?utf-8?B?TXFsVHVjZXJnZjF2alY0TDVQVks5WDZlbEFSYkV6NUx4ZnZEdkJaWko1cEFm?=
 =?utf-8?B?dXFpMWVaTEcrajlLUkZKbXkrOUx4VjhjaTZQazNDRUUzNlJIY2doYVA2N1kx?=
 =?utf-8?B?RE8yR2NkdTlBdnA5RWkxM3RqTlYwb0JaSnF5QTdZMllXN2I3R3RvS09TZzdM?=
 =?utf-8?B?UWxVcjRJVnZpR3VLMURIeTZ6Q0Q5bjd2Tm1NWTBaVk0rUjhETGQrVUxReUh0?=
 =?utf-8?B?ZzdOSTZiWGJsRWdPVDBEaWlJUGFqUXBIRmNvTDIvOXZWTXlreWlOOU9mbjU2?=
 =?utf-8?B?YURXcWh6WVZ3VnArWnBldjcxa2pwWUY5cVZGUDdvRmpnNGlQMk1PeVV5bDNP?=
 =?utf-8?B?OHdCV0xQbE5yYWNFMGpOMHZSOVdHN25idk1nemROZHptZ1lLMVVXRndzV3Rk?=
 =?utf-8?B?dVplRFpBNGpRdVl4Vyt4Qkd6T2Z5MU81bEFlT3RhYzluTTNnR0xkZEt6UDd0?=
 =?utf-8?B?ZVhZaUNBUllTY2gxRk5MQUNuS3hpbTBESVo4SVlqMkIvNTlnUDhJMDBRTVRE?=
 =?utf-8?B?WG5FWi9vNllUN0U0aDI1UzF1U0dUcXg3ZE5FcTg4R2d6OVpFWlVYbHo1Qmt3?=
 =?utf-8?B?UmxiNHQ0dHNGbzRhaUpjTmpjcm8rWW9VSyt1SHhkUGIvYnpvYWhnZ3RuMUtB?=
 =?utf-8?B?M1FvOTdnQnRyZTVsemZ2UlY4MzRpbEFQSS9QZWZ6Z3h1cHlaV0pGSFYzajNi?=
 =?utf-8?B?Z3gvcXN4by9uQitrTE91dmZaV0ZNWUtZdmhZRGk1R3FGZnJ4NWZicEFBcWsx?=
 =?utf-8?B?QXpzZ0puT01ZZXl1dW9NdmszcEN3Y2ZjUnBNUDY5ODJDMVRTeFlSZFNVbW5h?=
 =?utf-8?B?Yktxekl3MU5Obk1PM2hONUxKa2tTNGljZFA2WFo5dUYyeFpBR3N5L1B5QStB?=
 =?utf-8?B?RzJIUnRFakdaTFVVd00xSHV0TkE5UDVma0x6Vkd6NllJZXFEaFVvQmhyZm9J?=
 =?utf-8?B?VlBISEtsM0I5UFc4NEdDUmZGL2txZG9SMVNtbXpWVFR0bHRWcU82b0dvMHNw?=
 =?utf-8?B?NC9CUG9SOUVXRkRUY05KYnZNWm5tSkFRRGxuUVdHd0ovVEZNZFdubGwwRmtE?=
 =?utf-8?B?eHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a7bfc7b8-104b-4bf8-4ec2-08db4ffa29ab
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2023 19:26:46.3828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kW0JekgWqhgkX01U6o7YLg0SVQj2MrueVTYbfHbe5CPVSIOccdYp61drh9YM3KD+BMODHTgsfn/vDBYzfJMIyNUg3fZVsL5nOXr5dxI7tuE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4803
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/8/2023 5:45 AM, Nicholas Vinson wrote:
> Fixes issues that were originally found using gcc's static analyzer. The
> flags used to invoke the analyzer are given below.
> 
> Upon manual review of the results and discussion of the previous patch
> '[PATCH ethtool 3/3] Fix potentinal null-pointer derference issues.', it
> was determined that when using a kernel lacking the execve patch ( see
> https://github.com/gregkh/linux/commit/dcd46d897adb70d63e025f175a00a89797d31a43),
> it is possible for argc to be 0 and argp to be an array with only a
> single NULL entry. This scenario would cause ethtool to read beyond the
> bounds of the argp array. However, this scenario should not be possible
> for any Linux kernel released within the last two years should have the
> execve patch applied.
> 
>     CFLAGS=-march=native -O2 -pipe -fanalyzer       \
>         -Werror=analyzer-va-arg-type-mismatch       \
>         -Werror=analyzer-va-list-exhausted          \
>         -Werror=analyzer-va-list-leak               \
>         -Werror=analyzer-va-list-use-after-va-end
> 
>     CXXCFLAGS=-march=native -O2                     \
>         -pipe -fanalyzer                            \
>         -Werror=analyzer-va-arg-type-mismatch       \
>         -Werror=analyzer-va-list-exhausted          \
>         -Werror=analyzer-va-list-leak               \
>         -Werror=analyzer-va-list-use-after-va-end
> 
>     LDFLAGS="-Wl,-O1 -Wl,--as-needed"
> 
>     GCC version is gcc (Gentoo 13.1.0-r1 p1) 13.1.0

I'm happy to see someone else looking at this stuff!

So you're missign signed-off-by, please add it.

However when you resend, feel free to add my

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

and possibly:

Link:
https://patchwork.kernel.org/project/netdevbpf/patch/20221208011122.2343363-8-jesse.brandeburg@intel.com/



> ---
>  ethtool.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/ethtool.c b/ethtool.c
> index 98690df..0752fe4 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -6405,6 +6405,9 @@ int main(int argc, char **argp)
>  
>  	init_global_link_mode_masks();
>  
> +	if (argc < 2)
> +		exit_bad_args();
> +
>  	/* Skip command name */
>  	argp++;
>  	argc--;
> @@ -6449,7 +6452,7 @@ int main(int argc, char **argp)
>  	 * name to get settings for (which we don't expect to begin
>  	 * with '-').
>  	 */
> -	if (argc == 0)
> +	if (!*argp)
>  		exit_bad_args();
>  
>  	k = find_option(*argp);


