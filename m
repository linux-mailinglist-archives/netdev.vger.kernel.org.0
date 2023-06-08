Return-Path: <netdev+bounces-9395-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE161728BFB
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 01:49:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 785152817F0
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:49:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5FAF37335;
	Thu,  8 Jun 2023 23:48:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F9C1953A
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 23:48:58 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D31C2718;
	Thu,  8 Jun 2023 16:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686268137; x=1717804137;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hHOd/mz5+t4D0elPezEmjB32oSuQo9dlIil1zcjHtac=;
  b=X5Zxh1tULMc59u1bsiNgQ6J4xoVjULmZQtnZ8L0HdBBvz7NFGhMUWHHn
   Q099u6Zh5hXec1US7VnDUkg3usTVv6jt0PZNMLpI9/7VAS3OFIdilBicz
   nNYZ5q9/qbSZ/Xp0uoNV+Vb6m8k92cRmyMJy+jQoHckI8NU3havQmO21I
   UqtCkPwg4Yg9Qr/O75ih6h0/GJfBMaJFKZLqR2rN/c6kU2kLW3ixBR8Hm
   1ZW6arXBlh2hBhhfa5UOdIE80Kifrfpsvg5i0fzx0fQB2YaCBqh8H3wPd
   9PhOXJXtth65ngflcuYJ58Mzc+/fhWtMPhYcBzr2sZTC/ZvI65+N4eUq8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="360821331"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="360821331"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 16:48:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="660565980"
X-IronPort-AV: E=Sophos;i="6.00,228,1681196400"; 
   d="scan'208";a="660565980"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 08 Jun 2023 16:48:56 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 16:48:56 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 8 Jun 2023 16:48:55 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 8 Jun 2023 16:48:55 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 8 Jun 2023 16:48:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nNRYmsx2aNL0azKhDDo/Rk/RNdhmb11i0sJiL40IWqjzrOm27BUnbMoa4CrhVnDXIJXu1WACyaLCzwjT52+Q390zygsDXgu5pa0harl9YGt9li783E8DCXNHvWRDguxyN1KY2YDz9iFQ38TPbqC63CQZ8V9hLQzyhi5eO/db/KEGIbk0KvvF5aadz9dh+6CEa073vjET3lC8Uhx2fIo4pU+b4q6lHjFfBFI9sGq3l/mKA0MoRTbuU6e28pn6rPJpjEWM+Ta6KUmWcW37c/XzWxLGKCbuAO5+/OXFX9NiRdt+MPe0RbUREEl08Z/Xu3iDsX2A1tWYcVQWdPXsmgFSAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q298kVGH7kMsbZEHbDMRAYO+e2RT6Woy6PaCLSJ6VkQ=;
 b=BLkWABB1LBX05y4Rz7YZcGN+4OtRT6OeIWgnNwgsV6zE/MkkJ83idwSPRQ6H5iwqeXMPC620pfUNbiUhs2eBKhEiuA6KFubYl2B9Whw0nsWBXh+JsscOQkBV8d+n7eByduVXkcgnVfkEL966NrNfNyR6BlR58JWq5vBqVhl6FCeYqr60CXV3fLbRc61/OWao5C1U+rc25+ezOuzbVpo+KcC2c6N3FVXcgTc9vLXEsieUDQnggJWpBWC61TbLvF3KLr7u35P0HlaupGCgfb6rJ5SGsCOuM9An4D/FTauNCqQOQ5U9xZjYRVcpJjxLT0eO3i1MmTtSmsp4w1Z7RuxnPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4886.namprd11.prod.outlook.com (2603:10b6:510:33::22)
 by DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.31; Thu, 8 Jun
 2023 23:48:50 +0000
Received: from PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::b3c7:ebf8:7ddc:c5a4]) by PH0PR11MB4886.namprd11.prod.outlook.com
 ([fe80::b3c7:ebf8:7ddc:c5a4%6]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 23:48:47 +0000
Message-ID: <e7d42dab-ca13-13f3-4b58-b7c95f9e6afd@intel.com>
Date: Thu, 8 Jun 2023 16:48:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [net PATCH 2/2] octeontx2-af: fix lbk link credits on cn10k
Content-Language: en-US
To: Naveen Mamindlapalli <naveenm@marvell.com>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<sgoutham@marvell.com>
CC: Nithin Dabilpuram <ndabilpuram@marvell.com>
References: <20230608114201.31112-1-naveenm@marvell.com>
 <20230608114201.31112-3-naveenm@marvell.com>
From: "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
In-Reply-To: <20230608114201.31112-3-naveenm@marvell.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0024.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::29) To PH0PR11MB4886.namprd11.prod.outlook.com
 (2603:10b6:510:33::22)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4886:EE_|DS0PR11MB7529:EE_
X-MS-Office365-Filtering-Correlation-Id: 9aa7fa4e-3747-43c7-f315-08db687ae6e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RdZkpPLl6HmBK74eB2eTcRDQve1ag5nr3Rhe9cMSRfumYE40jgQ0GYBdDaymMBxS38rt7nHg4z6JXbkI8gQOSi8xXQs/9XXBsWSlEbWVQRWZCtDqoWj5Rhx5Y+m9RMFpQOZyVAjcCIFYxjWQidis5tJZjAWq+pasntY7S6tH9Z22wAkq2MpZKlKS02ctZCQeiuJlqlUkjx1wV2Dbyfdbo8blWU/CcWj5bAOzSPmOjj3GUbu3gbaZR97Oxrq33D8mdE+x25Z8vk9K+YtYAGiWyAYg+kZvvL1isaQ2PwNSOCGLne8gf4Wbx55BmlhLeQl4d5HQ8TMrNSlEph1frcPANY/ahzZE4lz5JgVhpzQszNSTma9yWzdhkF/w+dnIUYal23Wm8wBA05NKHskU2f/KRRl7IeI03yez9uS61Y61h85zbhRkeF6b6D+SJMOyAZZKN50nWBSqtFHnpSNXl9aFih+HqJGHEhQZwcZbbBybd3DXu9KImSHXxslDo5saT1V9mva2PvpgLh04AZU6lI6AIvsR+PNYqBHlSyDubxyISblDBRsSW4GnN6jrpX+a++zYQmuWwxNsT6t4Bn/YLgernAcs/wiYaq5hk+u0lKZsYS/KdJrSWuCya15XnDOPtii7K1ZHSgo2GpQ+UKtn/ebUNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4886.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199021)(6512007)(6506007)(53546011)(36756003)(478600001)(186003)(26005)(6486002)(316002)(8936002)(41300700001)(82960400001)(86362001)(8676002)(31686004)(31696002)(38100700002)(83380400001)(2616005)(2906002)(5660300002)(66476007)(66946007)(66556008)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZG9SOEY2dllRWXJWcXVBMS96UFpNZ3JHV3krTGVoQ1ZuNUNVUitwME5Rb1Mw?=
 =?utf-8?B?YkZaYXV4VHRadmxDM0NjTm0yVGE5eml4aVNCai9rMExGQkVWQ0UreHJDOC9G?=
 =?utf-8?B?Tld3V3hPMmhONzdTVTBTWGxYbGFQbGlETExjSlV6bEN1NDRyRGtSK3ZnU1dY?=
 =?utf-8?B?aG02SW1YWkdLUWFUN2hXUHFndjdvblh0VUFJREZ3dlFRbGJLMngxbE1IUHVT?=
 =?utf-8?B?c2wybHVaZDB3VTl6aEtzdmI0MVJkZG1lWkkwdTJSOTRJSXQyNjJSQzMvKy9l?=
 =?utf-8?B?bm02VmRxUGhqSjg3UWlkQVFnOGdObjNRa2lMWm1pMzJ2emVGUUloOW5XeS90?=
 =?utf-8?B?dURtZXhzYWs4ZTFWMG9ZeGJvMSthbFBzRFdEOGxJK2l1QVB1UFZvZWtxbmRF?=
 =?utf-8?B?T2MvdEdjOWtYVmZza29DOHFiRGRoOVExVWt4bXRUWFBROWNSRHlwQk1NL1Fp?=
 =?utf-8?B?RWI2YVpsMXNRN3pWVnhqY25ZbGs3OVc4dG5NaHhibEVLT3dwdlVuMDhFRlR0?=
 =?utf-8?B?VGg1QlBmbTBvVTJqb0oyaklKUnNFb0o4NVBwbE1SaVN2OWZOcnNVb2hhZlVI?=
 =?utf-8?B?NTlaaGFrbkJzWXZuUXZYV050Y2VnWGZBVUNKRzJrOFJnZmgrTStuVzBrcitI?=
 =?utf-8?B?RzhOWkRMaXhUZzByRUlzclFoT2o4amxUbEc4TVRsK2s1cmZFSlRpRXhNOFU3?=
 =?utf-8?B?UnF3NlpxUDVnMDEvQlYxenUvVHlZTUFaVFV2RmZHZGFjWEQzNjM5RUNhdHFu?=
 =?utf-8?B?Qzk5bWluUUZ1R21BVytDSTZWV3JRa29VeUh0UDV0V0FzOG92SWR6Q1hzWndz?=
 =?utf-8?B?OFN0RTFzb3N1SHBOdE9yb09xWjRsZ3l3TUJ0TEQ3dVA4N09nQ2lPakY0KzNa?=
 =?utf-8?B?RTVFb01UMmRkdVZCd3RXd1J3Q3Q0WHhYNnFMUHJoaTlvRXZiRXgzYStoNkFK?=
 =?utf-8?B?V0pJQ1FFeXVqZTJuV25DOFQrOW5kRFEvVms4aTJsbXE4K2NhT081aHJLRDRC?=
 =?utf-8?B?YUhzSTNTWnNNQmdmZkpBdmdyWkxlbDlQWTlSV1U2WVNUcVVwejBCNWxldllL?=
 =?utf-8?B?R3Q3K25vTmVYODVEVmxiaGpNb29Zdll4TWlxOE5PRnJwbXRMT3Y0N0RlSU41?=
 =?utf-8?B?NTdmUDNWdDV1czRUNGFMNjkzT0RxeUdoVndHRkZhL2Znd1NMMjBBdXRNcXFx?=
 =?utf-8?B?WU9FMmVORW45V0gzdnZ2RnpTcnI2UUEzbmlCeXJqV25iOXgvTVFXNmh2L2oy?=
 =?utf-8?B?bWNHUU1KNFZDRjJrK0g0WjFsSjQvUHllUkg1cnRFQUVGZUpmSGJNb3FHeTRG?=
 =?utf-8?B?WEgvckY4QVJMTkJ3WGk2WjlKQ2dhanZveTA4dGFHTURUa05nVkJueXF3c1lu?=
 =?utf-8?B?MDhKTm95bUJJNjdwYmV3Z1gxalRFWTNQVUYwS09sV08yUzkvU1NkT1d1TWdx?=
 =?utf-8?B?Z0cxQlFEM0N6anVFcEVXQjBzcFFQZUNkbjFlNjVtOGptWUQzUVVEaG5IeHZq?=
 =?utf-8?B?S2JSUjRnTE02U1NxQmVpM1RVM3pESVVyNHBzbXcvVlVmY2l2WlN2WDRjaFdZ?=
 =?utf-8?B?YnF1NFBERDdONEs5NkdROW9UYkVhQWN2eGZNT3NkMXJXYVZXUW9MZFhTdC9o?=
 =?utf-8?B?VUVuaG5ITG5HZXY4MzlkOHBVcWZtcWJ1T0d5dHpHcTdOUmhSQVRBVXp6dGtl?=
 =?utf-8?B?c2FjbDloOXQ5WU1sd2svVFVYL0k0eFlkZkVHeEtPVk1sZExSb0pLeEtaWmlY?=
 =?utf-8?B?OGNjczkxRWZkVDVyWGhuWWIyV0d4ZDJ3ZjNOejIvcUJaUk85akJMbmd5dytr?=
 =?utf-8?B?NyttZW9TOExaa3ExREJxczI1ZSs2UkV6am5DYVp1NjV3L2hDWWdKdE1LTEhC?=
 =?utf-8?B?NnBBaUthR2J3amVOSEJxMGVQVW5FZ0RCYXFCL21GYjJsWFBPNjlnMDh0MFVO?=
 =?utf-8?B?eEJGRk5sT1FvY2t1WTRmZGp5SWZ6M1ZmdzBod3pCZzlURTkrdWszMDRpSkp3?=
 =?utf-8?B?RllXbndMWkEwSHR1MWI5TG5zTlFnNkVWYURxdGdtOFJTanNOakE1dThEenFW?=
 =?utf-8?B?QVhpTTF6amFNTFh6MXhaUlVYQTZTVWhFTkY0TS9vTmF6dmtDZWtzUWNtaGtj?=
 =?utf-8?B?ZG9DN2VTSFM1cmdxTW5HSXBhMzlkSW4zZDhxMUtQYnlDOHdEOHBtaUo1MEZG?=
 =?utf-8?B?TUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aa7fa4e-3747-43c7-f315-08db687ae6e6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4886.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 23:48:47.3640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mH9bKNOx5J6P+IdLm/1bCC0ir+0cwn/KrfbF3p2x8lmetMFX+u2yvBGrcxeAYdmMfh02DazA6MKiuFyQ2+uGnRgb1+VQ+BqsxD+nyUly4Bc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7529
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/8/2023 4:42 AM, Naveen Mamindlapalli wrote:
> From: Nithin Dabilpuram <ndabilpuram@marvell.com>
> 
> Fix LBK link credits on CN10K to be same as CN9K i.e
> 16 * MAX_LBK_DATA_RATE instead of current scheme of
> calculation based on LBK buf length / FIFO size.
> 
> Fixes: 6e54e1c5399a ("octeontx2-af: cn10K: Add MTU configuration")
> Signed-off-by: Nithin Dabilpuram <ndabilpuram@marvell.com>
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>

Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>

> ---
>   drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> index 967370c0a649..cbb6d7e62d90 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> @@ -4067,10 +4067,6 @@ int rvu_mbox_handler_nix_set_rx_cfg(struct rvu *rvu, struct nix_rx_cfg *req,
>   
>   static u64 rvu_get_lbk_link_credits(struct rvu *rvu, u16 lbk_max_frs)
>   {
> -	/* CN10k supports 72KB FIFO size and max packet size of 64k */
> -	if (rvu->hw->lbk_bufsize == 0x12000)
> -		return (rvu->hw->lbk_bufsize - lbk_max_frs) / 16;
> -
>   	return 1600; /* 16 * max LBK datarate = 16 * 100Gbps */
>   }
>   

