Return-Path: <netdev+bounces-11306-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 71FA4732835
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 09:00:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20BE0280EFF
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 07:00:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6842DEDB;
	Fri, 16 Jun 2023 07:00:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E50EBC
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 07:00:43 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85DB930F9
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 00:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686898840; x=1718434840;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UqQKVgId47nPOMjBz6IgpLk2+L2ckE/Zjc24hjSNtQg=;
  b=LgaxSYBvgH2WOWuoW0FI0XOrutow2HKvEAwh9ftA+J7C9pwjzIL8U2nH
   LoYTNB0nGUZNCObH0ZfJSNVzUgmqena3UbujtvbKXoJIIS1yrHAuJZE/z
   XWq87sNbB56UQxWTJc/sa3KiwqV9C9Aklu7YVocrl6EL6jJu+pcsgzF42
   d047SpNd6Mx1Me8V992pMci1Ze1Vh+9JUYQkRv14mTtt1HZGijaw8O9F4
   YTZv2w3/XFavF5hOHEGsRR+/TGDd9KG2M5P1KIXkOSv8nhnFE0M5vI0wC
   uYtgW0vKeyblIPo71dcQK7yQ+EEBClvVxg/oj0e9kYO0DPFl9+E3FWHME
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="343884935"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="343884935"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 00:00:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="706977768"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="706977768"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 15 Jun 2023 23:59:41 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 23:59:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 23:59:40 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 23:59:40 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 23:59:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OMh+eNfe/bY9PunXAkf+01fHw1F9+K9cyrdjygN4bimY2GTBhY3OayYQhdRE/kU4Lw04CCWn0XKZQtWdgMcpSJfQl2HYuCacvl0vdoXcQedpZSpCZdDC1RUxeFewZA7ah2sy1j3OVBKcwFSZfkl/OUYPJcc9a9zO8NTsu1Rdom+Q+9mOh9D4zxWpAQ0IwY2PUIla/RukXE59e5hvBbDkP4MrpwF3VHJt/XFgO9i/7MUvpc+j21p7472J0zwS5/8Nb+7oHGIRP0pzQWJLwB0gUkKTLbNJpgvo/RRYpRXpyha3A84LWGYLkBTKBOnWbCDkEe6lBHluIWvW38ULY/QsfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LLeZeLTJet/6EyDzPFadZifZ+GjYqcbF2fTT62W1OXw=;
 b=JpgW+gtT1o9raQZaRoIuHySznjsMxxm66chl9u9apg3k1cXjbFImOl7dM6X9F1pNbDABdk9/MLwLYphvRxFehi1UsL/gvCAq1mBYbXIfiWC2jIqzSznexemrErNtebaIRXfpBMehRd7lCEBQInaL2Xl0ABrFZyAp+MAh1uQZScQr2vwMc/ZWKJ7y/Ve4ekGYrCVB3PzkLbEDbaxDdEB9Ugs09funk4aPNKbGVsp9zXQLek3ooBrLm9ReVCIKT/TYOPZ4VKN3zhImpAVd09Y+lAFuiJxakLoxBDmISAcMPwu4qRPlYjPp5UKn3mEWnx5jwEVBFdlB+QS9jjIRIkjoSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3672.namprd11.prod.outlook.com (2603:10b6:a03:fa::30)
 by SJ2PR11MB8586.namprd11.prod.outlook.com (2603:10b6:a03:56e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Fri, 16 Jun
 2023 06:59:32 +0000
Received: from BYAPR11MB3672.namprd11.prod.outlook.com
 ([fe80::87ad:6b1:f9f4:9299]) by BYAPR11MB3672.namprd11.prod.outlook.com
 ([fe80::87ad:6b1:f9f4:9299%5]) with mapi id 15.20.6455.030; Fri, 16 Jun 2023
 06:59:31 +0000
Message-ID: <57ef46e2-a72b-3850-18d7-ad352034956a@intel.com>
Date: Fri, 16 Jun 2023 08:59:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH net-next] tools: ynl: change the comment about header
 guards
To: Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>
References: <20230616031252.2306420-1-kuba@kernel.org>
Content-Language: en-US
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
In-Reply-To: <20230616031252.2306420-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0159.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::8) To BYAPR11MB3672.namprd11.prod.outlook.com
 (2603:10b6:a03:fa::30)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3672:EE_|SJ2PR11MB8586:EE_
X-MS-Office365-Filtering-Correlation-Id: 6987580e-fa45-4857-febd-08db6e373b9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wrOYdRsKoIesf+sOIr30xRFvklRdZBRFrbbwjZv5q++0XMMyW+t5BqxhK+x9dQXhjQK22fWd991dpup+6MnWsUQ9+FpXBXxb9aurAWeM6MWkMdldL+z8JWO5W5GTZvfJCGwLG97CEK8L6e9i/c3npXp+wwXriMW+bEttNDdctgix6VfuneZ91K1YvE4WCTlO7JshAS1uzDWwNXr+WTzPi/MVXbJu4jxYTIyCaSaFFIdXaWHa8goB8s+vwTnFBr8wcuPfBZCvp2dW/urAKhPgNhQ+IDlNT15Arz12tbo0dalQAcDXz7LwGbWFh64MLUis4jhyAEuNZFpPgfFO4m0T8MtfavVxnuYXnrJ1HYjrGOVSSvjiH51sVXqPtorlzHu8siuS5ji5BG76E+aUOuGyBD9Sdi+sgv2IZRFGbGYUNYE9PmichxZ/bmFk3mxFJsZHMOt5PGiyYk5BUkB7yc7GKnSjJWUwDL1fzovRTliE5XCTMb8OHJPKc4EoBVT4CuFOgX6+5og4t97aJNELqvmt0fglWXcbnyE+GJJ52j7DMZqVo/4xEnGNKFgRLs8SfMxcvpO0UvlnE8k8+QGJF51KBoQgrciywrFWQhEm4iub82eBnV9zZc/HfLZ025iDYO5iKLmYaEeusJlfnoiUwL0W2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3672.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(366004)(376002)(396003)(136003)(451199021)(8676002)(66476007)(66946007)(478600001)(8936002)(5660300002)(36756003)(66556008)(6666004)(31686004)(4326008)(316002)(41300700001)(6486002)(38100700002)(82960400001)(83380400001)(6506007)(86362001)(26005)(53546011)(186003)(2906002)(31696002)(2616005)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K1RKaUFERnlQempMM0haS3hrd3RleitDV3NqMU52ekgwQ1NwbVZPTlBQQ0Vo?=
 =?utf-8?B?eU92dHBtTzI2UWFEUkRZYnYrSlY3RmVBOVZ4L2t6SmF1Vk5NRm5Na3pKR2NU?=
 =?utf-8?B?c1M3ZXpSZ043c1lpYittL2ZLSCtqTzBDVGFkeWVyRExWS3FwMzAwTTA2YUdF?=
 =?utf-8?B?WTFJY0RHQlUvMlpnSWFSdHVUR2MxSkltbEJZemZhZ3RySnhSOW0zRHZhUzJM?=
 =?utf-8?B?bml4M1NIQ3BFWkpod0QzTWt5dXlHZEVOTWp5NWhHN1FaMGtKdWRvcTFGRWNo?=
 =?utf-8?B?RGh4c2UyeDh2THhTcEY2c0NLZ0Vzc0xIVVZkK2w3UEQ0bElTa3RLVGU3ZDZ2?=
 =?utf-8?B?em1ndm1UUDB6aUdjUENoTUFEL09CQmJrMklkcktXTVlqNUtCN2FBZlkwdExj?=
 =?utf-8?B?Vy9LWjdOaTFTdGpmK0VhKzhIYTAvWDlaMlNTTElJdXdlQmRidHlGVXJoclYr?=
 =?utf-8?B?Zytxc1FXdnBBUUpLaHU0cGZ2akhLemVaa3ByK3JmaUx3ejNRQlI4WlpldEta?=
 =?utf-8?B?UlRzQTZ4ckdXRG13elEvQ3BoaEdUZ1ZhVWw3ZTRsK09RQkJjZHM5QmJmc3c4?=
 =?utf-8?B?eWxNcDUwalh2bWFnRk83MENKUENXa3QzV2FBaFJlM1lyUS95Mk5jRktubkZM?=
 =?utf-8?B?TnJPd1RXeDAyYlV1aXZna2dMb1h0Y0hCcHRsalRPQ1R4ckNpdDg1alFOdVVp?=
 =?utf-8?B?VG9JNkJIaXh0dHltRUlGUm9OYTBrMGp4WkY1VlZRSnZzK1k3SytYOFBQL2dW?=
 =?utf-8?B?bW0rSmlRTmNUTEkybHpuVUlwMVJ6VVlxN0FWVHBZbzVWcjVVa1BnVjkyL2Qr?=
 =?utf-8?B?MGF6cUorM3p2V1UvQlBWYXZRL0J5S3gyaGRRMURPemJuLzhocVZKZExqZjEr?=
 =?utf-8?B?bHZuTy82MTVHU0NUSFB4dHBNMVNuYlY1SHhUVGFwU1pYdjVlVXVHV3VyZTBR?=
 =?utf-8?B?TDBQOWE0NmhIbjlWcmg0Q3hrQVlDcllWZ3lleGNVa3hxVStKZEd4Q2FmYm9u?=
 =?utf-8?B?aU9VVXFBb0RDYVFhVkdIVFRIcmFtZTFmV2JsVXRBRWpVZVcxWHk3dGZGUlgx?=
 =?utf-8?B?RDF5Y08vdGQ0VkxRZ3ErVkZGVkpVcm1pQkNUeHU0TEZnYmJjR2VMNWM2aitr?=
 =?utf-8?B?cnpzL1dqWWNxclJjSVhleDNyUkJDVlJ5L3pWck55ZE55TTlzcnF2a3Q5dlFG?=
 =?utf-8?B?SUVGcm1BMTJmSFhsRVExQmFJSGFUWVNmTDgwa1BUTXlmV3BVM1lJWXJJMzhD?=
 =?utf-8?B?VEtsS3A5Nk14QVltSFZlY1FoU2x3cERPWEJZSGMwN3RSUVcyVXZPTHBpOVZI?=
 =?utf-8?B?U2w4RjBRaHV6SnA1c3ZyY003MFRwRFBnOFBGK1Rmdm5LeXU5UkQzZWYza0NE?=
 =?utf-8?B?NENLWEFPTHNVV0o4WnVQZmpBRzRGalR0WDBndTNaMVJ0blhaQksvVkp2WmxP?=
 =?utf-8?B?RmNDa09IblQ5VVA2akZiK1RFYkZDV2YzYiszZ0hxMit1UlFDUzZVNU5qS2pw?=
 =?utf-8?B?SE53SnBhMWo5b0I3dnd3MFVmaUl1ZGMrZW1BaWRraXJiWnhObjMwa1ljZkJm?=
 =?utf-8?B?eDBTWCtmUDBpeXlMbVRUQ3RWTFZGVzJDL2dUeFNPaDdnNVJyKzcrK1Q1T0s3?=
 =?utf-8?B?RXJxSkhsRzhnTTRJdnZNUlFJbTQrWnZVdlBZcWlWbWxkT2svV25weHdkQXZV?=
 =?utf-8?B?NExrS21mRmNaYjhrNTVBRkU4YjlnQkdPRDB2MUlmRG9NRkY2c3pDaHd1d0N0?=
 =?utf-8?B?bTBHZFk0UWdVREozZTRrbzBNdFkyMWtDREhiSk81cDE3elNSYnZtWjBBRHpF?=
 =?utf-8?B?RkNtM1hRbEYvc3BwU2p1a3Y1ODN1ZlJtTERWcVJXaFhkYStDNElSTncycUdR?=
 =?utf-8?B?dzM1K09uT2JRV21XR1dFN2NaV3Q3aWhZRjNGem54V0I0M2FCbGJwZG8xOFZX?=
 =?utf-8?B?UHBSL0lOK3RuYzFoRjlTUjJHT0cwZmZISXdBam14KytIQVk4ZmdGVGFWb2ZH?=
 =?utf-8?B?dllsN0NrRWZjZmV6NkhYQ3ZRdDA5NGJ4Rll3THVQT1VxcmRISFBhOE9OZ0hp?=
 =?utf-8?B?b3NiV1NPc2tVUVByOUlMdjk5TGMxVGlSdS9sUGE2cG9DTVhibVRSWk1XZUlV?=
 =?utf-8?B?dkcrbVo3KzdpYTA1WUpiUUtDMHlwMUtNc3pFOHBsaFhTQnRuRWJOajFma2o2?=
 =?utf-8?B?eEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6987580e-fa45-4857-febd-08db6e373b9e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3672.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 06:59:30.8664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TqN8nhte4M4IaHg7YKr4rBxeu7Ie59TPYNqUvOisEqNCWOBZyUDYvQVXZlTsgyKO51kTgzj3ucuWiUqGKY/1B+5r53iXMw8DK52yzmT+ThQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8586
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/16/23 05:12, Jakub Kicinski wrote:
> Przemek suggests that I shouldn't accuse GCC of witchcraft,
> there is a simpler explanation for why we need manual define.
> 
> scripts/headers_install.sh modifies the guard.
> 
> This also solves the mystery of why I needed to include
> the header conditionally. I had the wrong guards for most
> cases but ethtool.
> 
> Suggested-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   tools/net/ynl/Makefile.deps | 16 ++++++----------
>   1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/net/ynl/Makefile.deps b/tools/net/ynl/Makefile.deps
> index 524fc4bb586b..cbf4cdfc4fed 100644
> --- a/tools/net/ynl/Makefile.deps
> +++ b/tools/net/ynl/Makefile.deps
> @@ -9,20 +9,16 @@
>   
>   UAPI_PATH:=../../../../include/uapi/
>   
> -# If the header does not exist at all in the system path - let the
> -# compiler fall back to the kernel header via -Idirafter.
> -# GCC seems to ignore header guard if the header is different, so we need
> -# to specify the -D$(hdr_guard).
> +# scripts/headers_install.sh strips "_UAPI" from header guards so we
> +# need the explicit -D to avoid multiple definitions.
>   # And we need to define HASH indirectly because GNU Make 4.2 wants it escaped
>   # and Gnu Make 4.4 wants it without escaping.
>   
>   HASH := \#

HASH, including explanation around it, could also go away now

>   
> -get_hdr_inc=$(if $(shell echo "$(HASH)include <linux/$(2)>" | \
> -			 cpp >>/dev/null 2>/dev/null && echo yes),\
> -		-D$(1) -include $(UAPI_PATH)/linux/$(2))
> +get_hdr_inc=-D$(1) -include $(UAPI_PATH)/linux/$(2)
>   
> -CFLAGS_devlink:=$(call get_hdr_inc,_UAPI_LINUX_DEVLINK_H_,devlink.h)
> +CFLAGS_devlink:=$(call get_hdr_inc,_LINUX_DEVLINK_H_,devlink.h)
>   CFLAGS_ethtool:=$(call get_hdr_inc,_LINUX_ETHTOOL_NETLINK_H_,ethtool_netlink.h)
> -CFLAGS_handshake:=$(call get_hdr_inc,_UAPI_LINUX_HANDSHAKE_H,handshake.h)
> -CFLAGS_netdev:=$(call get_hdr_inc,_UAPI_LINUX_NETDEV_H,netdev.h)
> +CFLAGS_handshake:=$(call get_hdr_inc,_LINUX_HANDSHAKE_H,handshake.h)
> +CFLAGS_netdev:=$(call get_hdr_inc,_LINUX_NETDEV_H,netdev.h)

Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>

