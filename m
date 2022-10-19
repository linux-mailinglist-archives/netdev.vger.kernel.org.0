Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D0F60523A
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 23:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbiJSVtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 17:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiJSVtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 17:49:41 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F60213F4C
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 14:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666216176; x=1697752176;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vAqq8yHfQZKZdy56LKJkXa5jsYV77tVwLDIXbfOVfj8=;
  b=d89NvGCnLXFWXdCeBMkP+InMITa7NCArQrbZh8mfCLhtAez0DNN7fVyL
   loC8qri9temgJ84xBkApY/yhr68VYZG2lQctdHIXB4Z25iMhxI6ADSwJM
   GKlkrxHwJ9Xvw3xEq8ZldnHWpLJWDTZGDp7GhkcAaTu1F2K5d8xO3+WoR
   0Er8r2XU0rT4Pt7Y/vJ7eUmAlB7ZfKu4SoBkdnrL4F+BIg1+tWbqJo8IJ
   kCIJX9gFvky3dg2crRr1HurSIp+D8jqoiP7t9syg+MhHpF/HAL3JO13dG
   qB8iM0GPAVg2XzZkC0rGwDXbZfpsTTTRt/h9HlGx7veareMpbo2f4yr++
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="286256411"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="286256411"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 14:49:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="698282418"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="698282418"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 19 Oct 2022 14:49:34 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 14:49:34 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 19 Oct 2022 14:49:34 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 19 Oct 2022 14:49:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J1VKG9Skr9v/cGepXASwVzGmqQoqyroWwFssZvw8Vmzix1h2GyQ/vuXElt4ZDA3b5BVvXh+2qL9Qdn0RF5ZQZu9OJyU4nqrToyBSSSMUixb8F13kL14fob6z5w/eOrc2jrj7ZzJFRzcPDWVqqJn1mcNnaaNtkbXCyrEAQq8D8kkCIgn2V07DlRXE6kNM+NqG9FWWsfDIek+0SR1gF9+ivza57M5g6Gj5L4TF929R42YB5NEufBz1kF2UyyKvYaYGXaxISu3A95Wkzk1a13/H7QLyZfuzmLFlcL2cIcyn6zvYVP0KE1nzQszHxNPeSKcbbIrfmhub6Z2e70R0UdZ+xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3KY7Eti8rGTVLnJH8JroBmTcuG5kdcDBL43hnznJcaY=;
 b=OFy0IemTmPZQGCJpGcskavoaUfmD8WsXykY1glww8klz2Jit/pZZIbq+scotW4OfLqyu4YD5Sk40l8CFIu2rT4oThQxvCm5JQU7Kq0oqbZ/WoiSMb15xxHoCGLAC3nJHus3MCp48lBjDoVPcb+6oAW7tAW8yMWBB6OlY3IS5gioK8g+5MrDlE421PeVdublzSexfqneoW3W6GrUJCkwTVo9b4MIj8uvVGvtKbppHyYouTQPEn6Ox8+VQ4/mv9ZfO9BpPhYNzXT3jTTNrEhpEIpaV/9R/Yt0KEJwd2qLkgVwj5hbYuRPezY/ESoyKbITSCwKxCMoNjYQFnw7GLN9Sqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MN0PR11MB6011.namprd11.prod.outlook.com (2603:10b6:208:372::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Wed, 19 Oct
 2022 21:49:30 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf%7]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 21:49:30 +0000
Message-ID: <c6ee5889-c41a-78e2-7656-3cbca9e4a77f@intel.com>
Date:   Wed, 19 Oct 2022 14:49:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.1
Subject: Re: [PATCH net-next 09/13] genetlink: add iterator for walking family
 ops
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>,
        <johannes@sipsolutions.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jiri@resnulli.us>, <razor@blackwall.org>,
        <nicolas.dichtel@6wind.com>, <gnault@redhat.com>, <fw@strlen.de>
References: <20221018230728.1039524-1-kuba@kernel.org>
 <20221018230728.1039524-10-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221018230728.1039524-10-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0136.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::21) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MN0PR11MB6011:EE_
X-MS-Office365-Filtering-Correlation-Id: 62863280-dfa3-4559-449b-08dab21bcd29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x/WjWQxWnLEopvTE9RFeQoTXN9H3qD06M4nYBQt6gG+6bIUXP/ZU0mIbNCEUgaGHD1vNAVv32wV3DZWWnHkwIc2/KJ8DiQk5vTc6zU05Fd5WEoj5f+J4N29ydiJzUp+XBG+uGETeks/V1M+QmiVMrOyS3WBlmTcZnmv0JKScg4TJHiZrYELSFkGI1ZXGaZHuoNTohmhIyVF3I6VjskCWZB1nDb4YeZTAGgITe530I4NAKJSbUUF7H1Jxn1+kGPORShnQRqjNc61+K6ED6G5FLgSEsiOcyAThM3/Ga2bxIDlFu9QXB1pJqEsDQQQ97Ddgk2AXkuZQ0CM/XxVJjUoHT0WBuJPm94cqv4akNpdsSEzb8RpI+w24wD6abi7vpi9QAlw2XqtHz8P7SA02bmV3FG7KeS/Z+hu5++igDhacaacPOrXxjr/eu/+4b1UWSBGI+lbW4DcG68wgYaXfv6LzZt4Mu6nhDNQHME2+pQidYtnOnPXC+UHos7j4SjZNEFc/w3ZxPL+d9iYtbfBl4vWCIIKxiS4yDDb1arkXF/8OiugXTFIixFpdIv38ovek8o4fki9h5VZQyvI7CBAxEtqBqfV1OxWsFoc6HRzns0Z3d2NzAxKNmi97+biTVcsIbr9kn1XoBz66m4pBYzY3oqClDKVmlvWGPalTXTWAdzDzo1pCcAjfpskhkLnybE/D6Cwk1eifvSQDp55ayZLdWwF62E/UZ43iFr+cF2Y4fjBG95b5iGVT+8LHUbJKPs2xdqYs8QQQFH3gjjvaEnUjme0a9UrCoI6c1CKD9Tr7Sai6lrs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(396003)(366004)(346002)(39860400002)(451199015)(82960400001)(38100700002)(6486002)(478600001)(31696002)(8936002)(36756003)(6506007)(41300700001)(186003)(53546011)(2616005)(316002)(86362001)(8676002)(4326008)(66476007)(31686004)(66946007)(66556008)(6666004)(7416002)(26005)(2906002)(6512007)(5660300002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVBTMGp2Rjg3RmpFSnJBU2JqRGIrUU0weXhXR09yS0VKSWl0QmJDdzVNdFI1?=
 =?utf-8?B?NDlJRUhJek5NSk8xZE1rV3lKb1RZVm9qaVlONFl6OWZnSEkwVlRhRmJ1d1ky?=
 =?utf-8?B?VXMvUHJ6aFhQdjRFWnA3YmtRMEREbUg2QnhMY0g4Mm5aUjRRM3pjREhHaHBV?=
 =?utf-8?B?VWVCMi9xSXk1TmpncnM3aERoN2hkc2VvVTFBdEdCQndaSTFTb1pTVHg3Mzkx?=
 =?utf-8?B?bmJCL0lyc3FtR08yaXk2U2pyVm1Pb2U4ZXppNkh2c3pSK21qUlY2MVVPMi96?=
 =?utf-8?B?YnJYTHZvOEhPcWFDTFZPeDl2TGwyRGdZZHN6SEJOalkwdDdSeDNDUTZJZ3Z6?=
 =?utf-8?B?bUZkTmNHcEtLRE1wUk4yWTV4Yy9YNk4vZW5xdXIrdWlBaExic1NEM2orakIz?=
 =?utf-8?B?OUs5aC9QT1RpdGFrRi9UMDA2VitDaVp1ZkVnclUrM3lVanA4a1JjZ0tOa1Fq?=
 =?utf-8?B?dlRBcEtSZWNJQ2VsS1ZqSFBSSkdYSHkwN1FqeSswVndiUnBRRi9wV0ZWYWJY?=
 =?utf-8?B?UWZtN3BBMTQ1OWxWSE1YdWN1d2hhUCs4Z1BaaXBrMVh3aGs2dmU4VXg3alBa?=
 =?utf-8?B?WHg1SVlOazZWUTVXSm1DMEdacUdTWTBhM1crN2JQUkpza0dodEh5V01LaGEx?=
 =?utf-8?B?ZTg1T2VYWlhpY0xna3VUNUNmTjZQc01GempDL2IxMXNTemJrcFVxSGRtUi9n?=
 =?utf-8?B?dm8vS2lpTnN6VUtBbVB1TW1HSHZJZk0zTXFDOGVYM0txK1pxdkc3RExBZ29o?=
 =?utf-8?B?NmFWYzVwNXBSRm94Z1gxVjljVVdSZEgvaWluNkx5VUUvckJ0a2UwTENCdEFq?=
 =?utf-8?B?cUpUbVBmNmdtR2o4a1NHdmk4UmVUQ0dZVVRudjNlYWdhSzRicFBtWVhzd1Jw?=
 =?utf-8?B?RHZYVWNTYXByQnJvdURzNXZwSFU0ZTdzVEtYTFNna2dmWVI5NUI3SUxkTm5D?=
 =?utf-8?B?K0l1d0VQblN1Mm5kMmJWRlZOVDZuK2VvVFU3OHlnb0FUZ2FLTXpGZ3k0MkZH?=
 =?utf-8?B?OG9oZTd3STNyMEZRNGZFTk1iaUc3MFJ6cFdkVTBPdFVBZFZWQ0VQODBCMlRt?=
 =?utf-8?B?NCs0ME5WZWQ3eUpLTWg1cXVGRTJFV2dNZWFST2l3bkhyNlVFTjFsbk50aFk1?=
 =?utf-8?B?WjUveVI2ajRqeUZvcldLQXRhNHordzllU2NFR3hsOGhmODd0dWZ2a3pZTjM0?=
 =?utf-8?B?bVNWUFBXVWVQQWE1OG51b0ZKZjg2WTNhS2xteWJHc3ExZFpyTHArMitiREs2?=
 =?utf-8?B?SUNVRmtVNEs3VzI5RDJyeDh1YlRVRnUvU1dhdGN3RDBrdU52SFVoTjZSUVVE?=
 =?utf-8?B?VWlJbENZNndQb1QzS1o3aFRBYlJqWTgrZUFzdjh1cHIxSzlldzhnS1hRYWRG?=
 =?utf-8?B?b2FLb3RkUkxTTTllNTlLVzNCd2VLeEczWUtqbk5IUWVDckZLQnRPM0ZXOFpy?=
 =?utf-8?B?Umk2TFJQdmJ0NU5PdHdxS3BmdlNOU0J3N2hhanRHM0xwTmhxOWF4OXhTbXdV?=
 =?utf-8?B?VjZTdWcydHBDNjl2VDdjWmF2WWtRNzZWK25WaDdMcXlLWldPRE81cGlBUEFi?=
 =?utf-8?B?dHU2QmFvVTRTZkpRQVR2NUI5SHhqQWNwVjFFb3Z4RjJadkFSTmFFTHIxb2pP?=
 =?utf-8?B?VVlQSmo4T1hEeHJ1SVdhWEU0a2hLRkdra3RxcFB5USs0YUpuYTFJZHMyN0wr?=
 =?utf-8?B?QmlVdGNHSzhZcWtuWUJjUlBtV2NoZjZCMUxGeXBvdUc5L3lzeTJHdXZlZ3B4?=
 =?utf-8?B?b01JVlFpMWNvczRHMXA1bTNoTmp0M3N2OWRKWVg2eFVnNG55R2E3YXk0STlZ?=
 =?utf-8?B?T0JrdEhQUEI5SlVpOGRqZ042UXpzY2g1S2JVU3pBVzhDYm0vVWRjSnR6MlJo?=
 =?utf-8?B?TS9Ma0xZZHVTQ3M1NGMyVGx1OE03anJ4amlDK0daVU5lbU9DT2hGRDR6eTQy?=
 =?utf-8?B?MXhxV3FPNFlJakRBRTNnOG5MUWN4b2x6TzZDN05xOE9LNng3eVVaemhOVFR5?=
 =?utf-8?B?cHRtVitxVVNrbFF0TXgxRnN5THFrbHBVOGFsM1hIemxHczRObnRJbURuUE16?=
 =?utf-8?B?S2FsSzJEalpQdWFheCt1R2pPZlNiZWk2MTF2UG4vN0toOHE4cUNOTmlQZEVK?=
 =?utf-8?B?NXh2NHc5d2NRU1NPZit3OWNjNGJXYUpiK1orZlFCNTMydDE5OUFIQ0VUeitL?=
 =?utf-8?B?Rmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 62863280-dfa3-4559-449b-08dab21bcd29
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 21:49:30.3333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rQlEnD+aH/+RAGk2Jvp2tTpzWHtos92fDk2MmukL2hiSxHrvWxinvH9zUAIRbviDajspv2R8HQGhcwaEk51eqDuvMeEjwuKtWP/0id4x9zU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6011
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/18/2022 4:07 PM, Jakub Kicinski wrote:
> Subsequent changes will expose split op structures to users,
> so walking the family ops with just an index will get harder.
> Add a structured iterator, convert the simple cases.
> Policy dumping needs more careful conversion.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/netlink/genetlink.c | 114 ++++++++++++++++++++++++++--------------
>  1 file changed, 74 insertions(+), 40 deletions(-)
> 
> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index 9bfb110053c7..c5fcb7b9c383 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -193,6 +193,7 @@ genl_cmd_full_to_split(struct genl_split_ops *op,
>  	op->flags		= full->flags;
>  	op->validate		= full->validate;
>  
> +	/* Make sure flags include the GENL_CMD_CAP_DO / GENL_CMD_CAP_DUMP */
>  	op->flags		|= flags;
>  

This seems like it could belong in an earlier patch?

Otherwise this looks good to me.

>  	return 0;
> @@ -228,6 +229,57 @@ static void genl_get_cmd_by_index(unsigned int i,
>  		WARN_ON_ONCE(1);
>  }
>  
> +struct genl_op_iter {
> +	const struct genl_family *family;
> +	struct genl_split_ops doit;
> +	struct genl_split_ops dumpit;
> +	int i;
> +	u32 cmd;
> +	u8 flags;
> +};
> +
> +static bool
> +genl_op_iter_init(const struct genl_family *family, struct genl_op_iter *iter)
> +{
> +	iter->family = family;
> +	iter->i = 0;
> +
> +	iter->flags = 0;
> +
> +	return genl_get_cmd_cnt(iter->family);
> +}
> +
> +static bool genl_op_iter_next(struct genl_op_iter *iter)
> +{
> +	struct genl_ops op;
> +
> +	if (iter->i >= genl_get_cmd_cnt(iter->family))
> +		return false;
> +
> +	genl_get_cmd_by_index(iter->i, iter->family, &op);
> +	iter->i++;
> +
> +	genl_cmd_full_to_split(&iter->doit, iter->family, &op, GENL_CMD_CAP_DO);
> +	genl_cmd_full_to_split(&iter->dumpit, iter->family,
> +			       &op, GENL_CMD_CAP_DUMP);
> +
> +	iter->cmd = iter->doit.cmd | iter->dumpit.cmd;
> +	iter->flags = iter->doit.flags | iter->dumpit.flags;
> +
> +	return true;
> +}
> +
> +static void
> +genl_op_iter_copy(struct genl_op_iter *dst, struct genl_op_iter *src)
> +{
> +	*dst = *src;
> +}
> +
> +static unsigned int genl_op_iter_idx(struct genl_op_iter *iter)
> +{
> +	return iter->i;
> +}
> +
>  static int genl_allocate_reserve_groups(int n_groups, int *first_id)
>  {
>  	unsigned long *new_groups;
> @@ -395,23 +447,19 @@ static void genl_unregister_mc_groups(const struct genl_family *family)
>  
>  static int genl_validate_ops(const struct genl_family *family)
>  {
> -	int i, j;
> +	struct genl_op_iter i, j;
>  
>  	if (WARN_ON(family->n_ops && !family->ops) ||
>  	    WARN_ON(family->n_small_ops && !family->small_ops))
>  		return -EINVAL;
>  
> -	for (i = 0; i < genl_get_cmd_cnt(family); i++) {
> -		struct genl_ops op;
> -
> -		genl_get_cmd_by_index(i, family, &op);
> -		if (op.dumpit == NULL && op.doit == NULL)
> +	for (genl_op_iter_init(family, &i); genl_op_iter_next(&i); ) {
> +		if (!(i.flags & (GENL_CMD_CAP_DO | GENL_CMD_CAP_DUMP)))
>  			return -EINVAL;
> -		for (j = i + 1; j < genl_get_cmd_cnt(family); j++) {
> -			struct genl_ops op2;
>  
> -			genl_get_cmd_by_index(j, family, &op2);
> -			if (op.cmd == op2.cmd)
> +		genl_op_iter_copy(&j, &i);
> +		while (genl_op_iter_next(&j)) {
> +			if (i.cmd == j.cmd)
>  				return -EINVAL;
>  		}
>  	}
> @@ -891,6 +939,7 @@ static struct genl_family genl_ctrl;
>  static int ctrl_fill_info(const struct genl_family *family, u32 portid, u32 seq,
>  			  u32 flags, struct sk_buff *skb, u8 cmd)
>  {
> +	struct genl_op_iter i;
>  	void *hdr;
>  
>  	hdr = genlmsg_put(skb, portid, seq, &genl_ctrl, flags, cmd);
> @@ -904,33 +953,26 @@ static int ctrl_fill_info(const struct genl_family *family, u32 portid, u32 seq,
>  	    nla_put_u32(skb, CTRL_ATTR_MAXATTR, family->maxattr))
>  		goto nla_put_failure;
>  
> -	if (genl_get_cmd_cnt(family)) {
> +	if (genl_op_iter_init(family, &i)) {
>  		struct nlattr *nla_ops;
> -		int i;
>  
>  		nla_ops = nla_nest_start_noflag(skb, CTRL_ATTR_OPS);
>  		if (nla_ops == NULL)
>  			goto nla_put_failure;
>  
> -		for (i = 0; i < genl_get_cmd_cnt(family); i++) {
> +		while (genl_op_iter_next(&i)) {
>  			struct nlattr *nest;
> -			struct genl_ops op;
>  			u32 op_flags;
>  
> -			genl_get_cmd_by_index(i, family, &op);
> -			op_flags = op.flags;
> -			if (op.dumpit)
> -				op_flags |= GENL_CMD_CAP_DUMP;
> -			if (op.doit)
> -				op_flags |= GENL_CMD_CAP_DO;
> -			if (op.policy)
> +			op_flags = i.flags;
> +			if (i.doit.policy || i.dumpit.policy)
>  				op_flags |= GENL_CMD_CAP_HASPOL;
>  
> -			nest = nla_nest_start_noflag(skb, i + 1);
> +			nest = nla_nest_start_noflag(skb, genl_op_iter_idx(&i));
>  			if (nest == NULL)
>  				goto nla_put_failure;
>  
> -			if (nla_put_u32(skb, CTRL_ATTR_OP_ID, op.cmd) ||
> +			if (nla_put_u32(skb, CTRL_ATTR_OP_ID, i.cmd) ||
>  			    nla_put_u32(skb, CTRL_ATTR_OP_FLAGS, op_flags))
>  				goto nla_put_failure;
>  
> @@ -1203,8 +1245,8 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
>  	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
>  	struct nlattr **tb = info->attrs;
>  	const struct genl_family *rt;
> -	struct genl_ops op;
> -	int err, i;
> +	struct genl_op_iter i;
> +	int err;
>  
>  	BUILD_BUG_ON(sizeof(*ctx) > sizeof(cb->ctx));
>  
> @@ -1259,26 +1301,18 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
>  		return 0;
>  	}
>  
> -	for (i = 0; i < genl_get_cmd_cnt(rt); i++) {
> -		struct genl_split_ops doit, dumpit;
> -
> -		genl_get_cmd_by_index(i, rt, &op);
> -
> -		genl_cmd_full_to_split(&doit, ctx->rt, &op, GENL_CMD_CAP_DO);
> -		genl_cmd_full_to_split(&dumpit, ctx->rt,
> -				       &op, GENL_CMD_CAP_DUMP);
> -
> -		if (doit.policy) {
> +	for (genl_op_iter_init(rt, &i); genl_op_iter_next(&i); ) {
> +		if (i.doit.policy) {
>  			err = netlink_policy_dump_add_policy(&ctx->state,
> -							     doit.policy,
> -							     doit.maxattr);
> +							     i.doit.policy,
> +							     i.doit.maxattr);
>  			if (err)
>  				goto err_free_state;
>  		}
> -		if (dumpit.policy) {
> +		if (i.dumpit.policy) {
>  			err = netlink_policy_dump_add_policy(&ctx->state,
> -							     dumpit.policy,
> -							     dumpit.maxattr);
> +							     i.dumpit.policy,
> +							     i.dumpit.maxattr);
>  			if (err)
>  				goto err_free_state;
>  		}
