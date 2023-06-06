Return-Path: <netdev+bounces-8489-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E7B6C724456
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:26:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DFFF281744
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:26:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A6F32910B;
	Tue,  6 Jun 2023 13:26:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8743428C30
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:26:34 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B680B126;
	Tue,  6 Jun 2023 06:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686057991; x=1717593991;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ufON2Cvdupp1zzYHANw+0cnaOwFyHOGnKTLpUYt6lZM=;
  b=UGM7ixk1QpZa8vc0KCWn7eqi+2ByfLN9YACeqA4qVx8+8FsPf66u9I9T
   jWHOGpDPu3DeD0qs5/acHp0i2OeMcZrbUrkejzePDyIrWUr2urANk3y/6
   e+yicr5a6T7RTIaaS9n0+kUORhYGfpp7fo7bIarnpZyWPhjE23gUSQYoN
   +mgtTjq6arwO7OeKH9pLiaiHXf8JomY/kjcZFQRnGsG00cJN+zwXyKYay
   tsVKbBkGqV0IhPH5KOEXuQWOko9I0LYKTPXtDmWe4DhTWuToDiWmfrY0w
   oFBuB0HBYUsyDz+6n/J8GoVxDuoc4SQ9YpH59g6ytDWnCDnjO4Yz+tg1w
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="337022234"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="337022234"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 06:26:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="774120752"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="774120752"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 06 Jun 2023 06:26:15 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 06:26:14 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 06:26:14 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 06:26:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m6wWIcyobICpqijf9aj4g1dGEi3iWEE+LyXqQQWOfnHlx/so/8eQ7vF+rSYvuKabw7y/TNSXof+RGPxlZTeAGrjZMLoXWWUrUB469o7M+sOGXf5n4cim2kUkKIu8OIOyIRVdK3vvTjdT7+vULO29wPDvhiYN5FbVuRhVJaG0lyQa6vrwN7SuezrioGo3nCrs2gFHXthp0q6fxivemBzIn4qH+14Ymr3wIocyhIE+u4oDDWjWnyVuZ/QEGFfWqrJjIojbwNmF9iaVuYnyWOM4ciWkEhu8vkhzNcArvWr2m/BdPSbGWbJoG3DO9PAivonk0UwbxaeeJemuS7vw4MzAmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/VsDVR0tb6EeHawkLCrkPVRKLosnHlQDOqMDUTSWd4I=;
 b=MrXnrY0PDhPUl8vD/HbRrxKtMi1LcVdAiRCJyAIV2xPOmY1qtvciCaOe5c4ToUF/+kCpcRLKd96FRW4wWsZEk3PN81jFjUPqudzlqRzd7uff2NvQ/o5oKbo3pYdFBu4ZuJxcHEaIJvVM0hoCd4dAEpzg6mMjhiJpYWtw2KE5blW57ePx+AMD0eCqQP5zgWBITFLUWyaAXCcTYHQxJBVIKN62pMEY65wrGgABry9CHF70lxK2g+lfyeQHwH2e+rSkokDTgAsk23zZwIv0+I2fyG5fl3PDlKGpzfi+CDI5LhVaOcpqRmUbHxUMQIHcQLf6zsEIZB/InCqJPHF8hCjLjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MW5PR11MB5810.namprd11.prod.outlook.com (2603:10b6:303:192::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.31; Tue, 6 Jun
 2023 13:26:09 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 13:26:09 +0000
Message-ID: <89201790-6578-8066-b6de-4834ea19463e@intel.com>
Date: Tue, 6 Jun 2023 15:24:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v3 0/1] gro: decrease size of CB
Content-Language: en-US
To: Richard Gobert <richardbgobert@gmail.com>
CC: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <lixiaoyan@google.com>, <lucien.xin@gmail.com>,
	<alexanderduyck@fb.com>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
References: <20230601160924.GA9194@debian>
 <3f6cd784-767e-02e3-0c30-c0dda12e51ab@intel.com>
 <20230605135821.GA8361@debian>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230605135821.GA8361@debian>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0053.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:4a::6) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MW5PR11MB5810:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d21bb6c-376b-4844-cefa-08db669196f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cpXLzfn1G1vVSnK6vThwhv5PlbwVSEInIyW3x6dl8itzstNiO3Zy/iTOkpeYGE8sLEdknrMoCVo2KEZXejwQhEMGv+GxXVYTgXCmt2NBgEEKdFD7BGx4LsZ5jKQ5FVMWANvsVOEyBNjbXLrjp/LbwktQXfq4/3lzT1h/OsV80yoD+mV0g0p0ij2bPojTE/2GSlp19Js/NjuJjrYXBmv6vJMWqaWxBFcNciMzPSPLqyF4lJkYpmJGz7N/Udnadxs8hPKYCXE6IqyywxgbJ7+tAYbBbwhEeah2MyWw7TbzjeuK3cdH1LCmgb21KmPvRDI+Zvi/WsJjQyUcyCX/RpVRWEEVOEekLfXSVqtGLNYBhP3DGB5xujAclJ1PNjGr2DqAzoeSoPIP7BV4BaZBKuOnGra1VpssYyCgHm4WVy0eZFDia5Lws2lVR7zdez1wEhCZ0dQHzFvSgCOyn47h0IvgaRrOi0bZtNtJYOvzhzYRmd4Iz+/bWhgFzhgmUWqnkv2De0sgIgzxSU3+hKowqfIRo06pyTDATowHgeAxN3vAqwhDXAmL6o1+9GBjBFvnYFbv5iH2U7TLLTiI3k7iO0RVU6pbTSLwQoJibfbJCduAkkEO0wKz3iFeqf0wTKDh2a+mQShMIppGlpJuxbF8UDfwzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(366004)(396003)(136003)(451199021)(26005)(6506007)(6512007)(36756003)(31696002)(86362001)(38100700002)(82960400001)(2616005)(186003)(5660300002)(7416002)(2906002)(4744005)(316002)(478600001)(41300700001)(66946007)(8936002)(6916009)(66556008)(66476007)(31686004)(4326008)(8676002)(6666004)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVFhK1N2RXR6WFZTbklFYmNmOXBmUGNOV1NiVmljQmZQQWk5MlRjME5Rb3I0?=
 =?utf-8?B?RHlBbTJsSEdxMzJRQjJPbTBYTE1KOXZ0S2M1T2RORjl1QnFlQTQvVmU0cXdC?=
 =?utf-8?B?YjRhaGNvYzBLM0g1TG9Wdm5Xc0o5a0RIcjlLaFRmQzRKandGRVhQQTE2WDZn?=
 =?utf-8?B?S2MxWldMdkFmNnFqaTF1VW53OHJkSmNnQmNwM0sxOFpZSDh2aTlpWFdDQjJp?=
 =?utf-8?B?b0o3WXZZOE9WVTFEeUtJNjM0NEpJVHVsWmJ4WGdkNjljbGV6aHk5NWxvS1NM?=
 =?utf-8?B?SEltSi9UNzhHcVNNanYrbjllNDR3N0I5ck9DWXN6eklHTFFnZ0V1NjZNamlI?=
 =?utf-8?B?NnlHYzdEY05vWHM1WkVIS0JXYmlyZDR2M0hzdGZEL2dQdUhRQkFRNXRXS2NP?=
 =?utf-8?B?MGhsQnBXcUwrV1p5T2J0UjhUNXdrRkwxQ3pjRFNKZFYwRG5xSStqZDZHVllT?=
 =?utf-8?B?b2xsc3VoN1NyQ0FqNjkyNyt0ZUJRcHJsd1RnWnpGRHZMT2huWGQzWGtaV29p?=
 =?utf-8?B?KzBKTmtPWkFYNVl4RThzbVc1dzJjZGE0L1hqcFlrU2FwVmVkVXVqMW44NTNW?=
 =?utf-8?B?dzNhNlV0V2hXQUhicGNyNTRTS0FLbEwwNm9EbzhUTnV4a0hhMGowaURtNlRY?=
 =?utf-8?B?RFBQQThDUnNETGhvN3g1Vno4bFMzT2dMb09LdWtwWkZ6N0xYODV1YjhKc2NJ?=
 =?utf-8?B?OWx0cVNxanhOWkVlRkZHa0N1TkFXejJQMjRTSi9YQ08zVkJGUTI4NHZsVUxq?=
 =?utf-8?B?aDRFUkdyT1pFZ0VBNGJZTkhSUEJRTnBML3FtbVpPOTJkS0FCOVBUNWZqL2Ft?=
 =?utf-8?B?Q28wbTVoYzFybEFCd1YvOE8yOVcvVHdWOWl6dDBpdU94M01ObkJpYmNHM20x?=
 =?utf-8?B?SnRTQ3A1MlROUjZETjNlSDRSemlDSjBGakJsWmswZG40NlVNZXRvMU5KV0ty?=
 =?utf-8?B?Zm85MmhXS0NxakhhVm95RlJoQkZPY09JSHJaSUE2WEVDMHpZUVA5M3IySVVs?=
 =?utf-8?B?WGR4bnlEV011eXBuMFh6MzJpOTNURXowb1ZERUo2YmVEdnB3enIxUE5EaWhh?=
 =?utf-8?B?bno4VUJlVE1xQVFQMTNaS0djY3puNUJWSFFmdEE4NjhnTXRJM2ZKMmxFN21Y?=
 =?utf-8?B?ZTdkUlJsc1NwZ2JqandCSHdsdmxYeWRSQjcrSG4rMWhFMjJnSXEyUjRyakVi?=
 =?utf-8?B?eVBTVVBjRDl0cDlaeXVhRTFsenFoQ2xQcDMrbUtteWhMY2hqU2ZsSkxXTk1U?=
 =?utf-8?B?T09oblZvVWNlK0pER0VlaUZocE1TUzVremtDSEdOYmZQdnlPc0cvYnpPUlgw?=
 =?utf-8?B?WU5GSEhCRmtUcG13SW43UnJneXBlTUZXbUVINGFsTU9BcXBJaXNDc2dFYnpZ?=
 =?utf-8?B?RWtPa0dXK2djZHkwWHJoM21jRjZ3TWRhK3BYWTRMemIvaE1IYWlJN1lHZ0VN?=
 =?utf-8?B?OFZPY2w1Wm1VK0dFRkdYNFJiVnJORllha29VTE1tVEVBa0hSTTJrWTVkV1N1?=
 =?utf-8?B?MThoNHZ6OVNYSnRNQTVONWZkNmZ4YlRVU3lHZ2dSZXFxRE9uQU12cm5HR2lP?=
 =?utf-8?B?QXJrbU5OM1BOU0VEMUx2VEpydDZYOGhNbkVVaU1RcVJFRHZadjEzUGE2dWd4?=
 =?utf-8?B?U3ZKMG9hV0p5bHdNdkNDQkNFV0ZxdnlycmhMSXBJTkdFdkQwa3FoMkE3R1VK?=
 =?utf-8?B?ZnVHZzhkdEhxMlJ4YlVvd0tSajN4UnFnUENPbHBWTzFoTGR0VkhON1g5WVVm?=
 =?utf-8?B?YkpGS05TeVVHbVhVcWtwbTVzandvRW1TT2tJZFI5djNPU24zTncyNzNId0kr?=
 =?utf-8?B?U3gxdnk4UTFJbFNwMHRrMGw1RU5HMTVFSHJDcFZUVStrNVc1dnhGYlNsMU5l?=
 =?utf-8?B?Ukg2bE9aamxjdE9GMm84ZExBbzNycHZXQU4wSEpqTGVzV0Z5SW1EcFZzR0Fm?=
 =?utf-8?B?QUNySzEwRVZFMk1NUnJJc2NNM2tEWFhGWVJFUUNCaFFTS1ZKZFFNWldKTFpy?=
 =?utf-8?B?dE5rVSt3enJJcVJWV3dtS1lsb3dWeVpqVTNhcEt6VkRYeW1Ed0trNWt6ZnI5?=
 =?utf-8?B?VWVDS3FqNlR4SUxGbExGYzNiTnQ1M24reVZSRWlZVGZkNjJNT25tcFBQbVda?=
 =?utf-8?B?WWlGQ2UyVWN5TkZuT3JrMDh5dTdZOG4wM3dpY2t1ZHhtYWd0L25aeHJFS09M?=
 =?utf-8?B?Qmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d21bb6c-376b-4844-cefa-08db669196f9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 13:26:09.4544
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C0/0APax1Twk6OA8RYAMQoU7VqDKmxi/neYeWVOR2jSR8eTds8F99gw/RccYjUdTc9F8vBOcGzQ8+OLl3h/oL3M7eKxhq35gRO0q3m7cfzk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5810
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Richard Gobert <richardbgobert@gmail.com>
Date: Mon, 5 Jun 2023 15:58:23 +0200

>> I hope you've checked that there's no difference in object code with and
>> w/o `inline`? Sometimes the compilers do weird things and stop inlining
>> oneliners if they're used more than once. skb_gro_reset_offset() is
>> marked `inline` exactly due to that =\
> 
> Checked on standard x86-64 and arm64 gcc compilers.
> Would you check any other cases?
I'd say it's enough, so no problem. Sometimes some odd things happen,
but you can never predict all of them.
I can't give Reviewed-by now that it has been already applied :D Had a
long weekend and all that. But the change is really good.

Thanks,
Olek

