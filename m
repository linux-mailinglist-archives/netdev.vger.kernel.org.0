Return-Path: <netdev+bounces-10154-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15D9472C8F4
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:52:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D01BD1C209F3
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 14:52:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A4951B8E6;
	Mon, 12 Jun 2023 14:52:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3425E18C20
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:52:16 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D1BC3
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 07:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686581534; x=1718117534;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+5H9GKqF7XnRGNKcne3mKZn1mmVUF6evCiayaty+PrI=;
  b=gHNTnZ+mIIJP/1b701ekrbC3U5/wW8dUOH0I+h3lPXj8QP3zrnqmPB4W
   KcVbR0eGdwIK4NOi5JyPQLoXBYKgLll/MqUV6GzMnVnTlvTvYBXupOBpc
   s9556GLx8uwH7o4lRNd3tWARyBBoewVVwIqTSLlFHYS82gpR82lvwDuMw
   /WsBvLJCtcG7mbY2YpW+C39W8JdWBIuUZ/jFEUGoQsO/ckgNZjnRt/iyx
   zb6YwQAVHYD5pK3LliGL6buZhu0hnPQfVTjZTO5lrQbDzXTkPELIKYyD4
   PmbK8njTD0Kqzg4bOMRTa6We19aUvp57PIbSGevouoFt8xti+oC9+sRfP
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="361422479"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="361422479"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 07:52:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="705419275"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="705419275"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 12 Jun 2023 07:52:12 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 07:52:07 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 07:51:57 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 07:51:57 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 07:49:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrIWLC9lNu6RAxXYVDMQNStV1mMKjVz93LfYmqL+QbZhvsBzI4oH8KqPuMRW/lnB0dQOE+qNEl2UDR66G0oFMMrKiW4NqwpA41urdFDZfbMweIGatcKIAX3v+3b0ZKyVRG6NAu3oDzKGzCBci8d3uffEEri/61eiF287g8SwtCBAKBrTGYnijvoj6UH4S6hgEzEEsReFW0NiLTEk64CUcu0pJJcDJLmrsDQlClWlRhEQtz/dVeMId9FKK2JOUHWlauDXM48pSve695bpRJ+JuARO00Kglq/AiMzGDlqTB1GCKmJGGahWGwxYoZJl47j1oYXxk//Y0ToJx1dfY8FM9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=klgnDkhkgtOG7+NAUInNomXkHNoBfgkRBOBjQiswBQw=;
 b=KwcyjpcbfUS4T4wNP5p5uA2M0qTD/1VU90bmgSwUw/RHRscNu/Bypsp3CYHjxCq6kg///FyYw2av5QnrJ8htTcSuXse39i+p8mkqRLQrpymxkE7WB7/8YG4kdFnE7yolc87P2OQWFIKWE2O6/FUGv2rARfTEU2GKN/uVDUOweqGBpRbv5YSxjg/q6NduCFLfBKPqWi8jjNDarNHnQcG6Go3920oqpet7dCPca1U92P9StzGdxmpva+dtYjYbKDTLAqhwyHYjdHTYQe9Waula6NGHQEID3hh3/Jqz6u14OAFOfpVHKWyrjwAKWYPF+lHIMRR/m3J794w5LmGi9KqOFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BY5PR11MB4451.namprd11.prod.outlook.com (2603:10b6:a03:1cb::30)
 by SA1PR11MB8574.namprd11.prod.outlook.com (2603:10b6:806:3b1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.39; Mon, 12 Jun
 2023 14:49:55 +0000
Received: from BY5PR11MB4451.namprd11.prod.outlook.com
 ([fe80::c5b8:6699:99fa:fbeb]) by BY5PR11MB4451.namprd11.prod.outlook.com
 ([fe80::c5b8:6699:99fa:fbeb%5]) with mapi id 15.20.6477.028; Mon, 12 Jun 2023
 14:49:55 +0000
Message-ID: <b4242291-3476-03cc-523f-a09307dd0d08@intel.com>
Date: Mon, 12 Jun 2023 16:49:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH net-next] net: add check for current MAC address in
 dev_set_mac_address
To: Jakub Kicinski <kuba@kernel.org>
CC: <netdev@vger.kernel.org>, <przemyslaw.kitszel@intel.com>,
	<michal.swiatkowski@linux.intel.com>, <pmenzel@molgen.mpg.de>,
	<maciej.fijalkowski@intel.com>, <anthony.l.nguyen@intel.com>,
	<simon.horman@corigine.com>, <aleksander.lobakin@intel.com>
References: <20230609165241.827338-1-piotrx.gardocki@intel.com>
 <20230609234439.3f415cd0@kernel.org>
Content-Language: en-US
From: Piotr Gardocki <piotrx.gardocki@intel.com>
In-Reply-To: <20230609234439.3f415cd0@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0691.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:37b::19) To BY5PR11MB4451.namprd11.prod.outlook.com
 (2603:10b6:a03:1cb::30)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR11MB4451:EE_|SA1PR11MB8574:EE_
X-MS-Office365-Filtering-Correlation-Id: 29ad4647-92fe-47f2-3f4f-08db6b544908
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OCZbj4kc1qP1944JCNiYsxm2FWdCbGPENosmjtnDzSd2hs7f8wVpfg7oM0d5t4n7gyJTOaXUEaJYLkufweQkJoEWia8uhZu6delcRYVoiGPOxHqR7hmncmlhe1DiLQ42V9nGZS9WLufnFq5MClWLVaanJFtaRPqo+tnkC+yJA3C/cZ42OCZtoOejHwxsrpzJDeXbg+bfc7mlkEmAi+yQkY17yqrbJpxUWVUYRUs7KHgFdrW/ydVLARMHHP5YDyu3b5Hl+62WdyAgs2o8k+7AinzHjJNWI612txHIxs8/dDlmOxqiyTPg+8WdvU6/BuWqYoj7xVdBEg4a+x/aN94mkm3J6AdKAzefJzQtx0PDmr4Orw1hg0izZKHUjrwAGlxhYaqjHpByodXn17Lg5MSl7ekrOqsM311EYsouYKUcGiHWggYYISCCSVIvKXyNiXarjoYn3Av+3vX7QcCboKrt2dc1YHwfF14sQJT5oVxrPuHieJXfwiLov5/a4Wv2agDm4tO19hK9bhpFh/Pj48sJ1du05IZuxUEqLLHNVD+EsyGRz9qTNUXPTIpD3LtLnVhwaxDlC4FyYubEkCCCshRdyoemMeleJYTYfnZyWsvveGfTGcp23bspJC7qYOQsP6NO27ZbxZXL+E+7JZEg2eqF/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4451.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(346002)(366004)(136003)(451199021)(66556008)(66946007)(66476007)(8676002)(5660300002)(8936002)(6666004)(6916009)(4326008)(31686004)(478600001)(36756003)(41300700001)(4744005)(316002)(6486002)(38100700002)(82960400001)(6506007)(6512007)(26005)(186003)(53546011)(31696002)(86362001)(2906002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDhDcTJSVTNKRUtZMGxWV29iWlJaU2FhaWR6RngyUkd4SFFmaUhrOStmVHJT?=
 =?utf-8?B?M1EreTYwZmE2RG5qWFVObkdzZ2pmcU0zbHlya1Z3WUZSaDdwNUw1SGpGUlZv?=
 =?utf-8?B?RUpRa3dscDA1QTlySWJ0YjE5MnFLeG1mR3ZqRExjaHhEcGdENmxQQ3Z4UmlV?=
 =?utf-8?B?b01HNnVEZURhSHV3ZGhuMDdtUU5Zc3BzbW5VcmlBMDA2M2lYTVVKWUs1R2F2?=
 =?utf-8?B?NWZ4SG5abFZjMDI4RzArOFNqZEgzUFZyTlBQNVNPTWRzamVldDlrbTliWWxQ?=
 =?utf-8?B?akUzODNoRVlCZ1A2N3dGV0J1Y01oQ01sZldCYmRrbmFIVk80TWYwM09pU08z?=
 =?utf-8?B?L2I3QUdOa25sR2NvbXh4d1ZRRHF1bXBseFRxTDgyM01LOVBqMkd2aDRkaWVH?=
 =?utf-8?B?SGxDQzJFa3pYdkJocWgzc2I3YmhDZ1BlaE84UEFGeDNZZENQTE9abHo1K3k3?=
 =?utf-8?B?dVgwZWF0dlNCQ1c5bndTTkRFWlYxU2dpUi9iQzJxaW5nR0RvL3o0L04rN2Yr?=
 =?utf-8?B?NGNMWTZ4aTdOU1VrY2xhSUhGQ3czY3lBMU1RN3MyUi96OHlwbFA4dGdDWXpE?=
 =?utf-8?B?MHVQUGtRYTRhOXMzbVg4dXJWbGFuOVJna0RnYjZBYWpEN1dCNnprVE53bnFG?=
 =?utf-8?B?ZW1EbFlBblRiODE5S2NtaVp4ZlNtalpNaDAvWHZENS85ZjlnbXMxdlNuOVlj?=
 =?utf-8?B?cXBXTnI4YnpIUFIwZU11U1dkVEhydVBXczkrZ2hBdHptSmVVWVVLVjhlSDJv?=
 =?utf-8?B?bEwxcHpGQlJkdExJM0JRYm56czNSUHdkNldFUmdLMFRXcWRSZWVEaFAwcFNj?=
 =?utf-8?B?bDBSbmtDcGk3K2tvcHQ2elorMW1lMlBscjZXM0psbGxlNmVMK3BSRW9Ua2tC?=
 =?utf-8?B?aHg5MDFlNEZSWFZLZmRsV2VsR3NqMjBjWTV4KzJ3aEpUVEVZMFhoRmZlcGV2?=
 =?utf-8?B?QUtBdTYrTk1yVGpReEtFTzVaWkFmZllacTZTYllvT3VtNEhsQU9US050b2Ny?=
 =?utf-8?B?Rzgxb2lLckFxMGUydUdYeFZ3aG5KY1doNjdSdTdCQzNNQkgyRlFMQm1yc21n?=
 =?utf-8?B?YUxobEhPZjgxYmxGN1J4NnMzOE5MYmpDOXZGTEovN1dyMEdkeEtvSXYreitV?=
 =?utf-8?B?TlRBSENlUzdTa2g5QzRES3B6Z1plYUdRbzBiNFJJUHF5S3FKVXNRYkFGZ3RM?=
 =?utf-8?B?bWNYUThqUXFhRFYrMkZGNzhkNVBvSE5Icnp2ZUtIRVB4UzZ0TXl3c2VsVkUz?=
 =?utf-8?B?YjZEeUFjSEtQb2dvQ0xWdW1Jc0ZLb0wrejN2UjhydWw3N0FGM3J6SHhRNFdr?=
 =?utf-8?B?WE00SE5YdkZsRjFFYVZDeHZEU0huYTlRY2VJeC82aDlrRjlnMFU1RmRqLzVq?=
 =?utf-8?B?ZDZ1Sm1idU9UNi9BWU1WL3hWZXY0M0xVeEkvRStKNkZMcEJHZXVWNysvaGNZ?=
 =?utf-8?B?Tks1SzlUM2lDU2VLWUZkeHVwaW9ObTFoZXljNGVRazVHSnRJT2U2SURoRVRo?=
 =?utf-8?B?K2laS01LQzhLcEtKVllLSGxqRk9nUmVhQWNvSzN0Mjd4YTB0TUlRSUdERkNK?=
 =?utf-8?B?VVpPamgxR2NvVWoxeVpWb0NIcXNCcTZQREFjdWZXTGpUb2lUeUU1THBvdm5n?=
 =?utf-8?B?YTMxcEltNi9semFkMmIya0hTdU5CQ0dZK0RPYnVsSGxpUzc2ZnRoRGZFSm5U?=
 =?utf-8?B?bHhFaTAvS1BRSkR0Um42bmRsMnFqcXNnS0N4SGNmWG0wMGNhUDM5TjZrUUZv?=
 =?utf-8?B?b09DdkI4NnBOZGJBY09MK2FjU0RYK2d5TXEvSGIrVWpCSnZTaTdNbFJIRFda?=
 =?utf-8?B?TmpmUXFoeXVRbkx6Vk1va0lHZGJIM25pTzBiejA3ZmdaRmtFR3NHdFRrYWJt?=
 =?utf-8?B?allvd3pMRjNTcDdQdHArVkxxNFRXeXpqNEtjaVU3NkVJdGpEdDJtVGp0Uzd6?=
 =?utf-8?B?UURnclI0WEtRMS9kZ1FBb1k1aS9YMStOZFVBd3ZzanRIb1gvWTdPejhWbXN4?=
 =?utf-8?B?ZW9wUnRDTjN0STJ5OHFuN0lGYjV1bWNMZ1NSTytWakQ4QWFFWlFWdTM2OC9Y?=
 =?utf-8?B?MTVpMmc1M3Exa0dNbmwwcHQ5MTY1VHY0bmRDY3NoY1lPZ2R5NTJBaWNxSU9C?=
 =?utf-8?B?Z1pmV2FhV3RpOE1vUXlmNW9MclM4NSszamRKWk1QcEk0Z0h2SGt0azZhVk00?=
 =?utf-8?B?NWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 29ad4647-92fe-47f2-3f4f-08db6b544908
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4451.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 14:49:55.2951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U3W8I1YtTH/7PH1TtZJLR+YEZjZJ5Tt8DE9mnnsQ4f2Dj7Xu/hELAn4WlIabSouppkk7EEBqf5ziCd6Cynz2q8XhhbNFLE3Mwsl8l0aewDQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8574
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 10.06.2023 08:44, Jakub Kicinski wrote:
> On Fri,  9 Jun 2023 18:52:41 +0200 Piotr Gardocki wrote:
>> +	if (ether_addr_equal(dev->dev_addr, sa->sa_data))
>> +		return 0;
> 
> not every device is ethernet, you need to use dev->addr_len for
> the comparison.

Before re-sending I just want to double check.
Did you mean checking if sa->sa_family == AF_LOCAL ?
There's no length in sockaddr.

It would like this:
	if (sa->sa_family == AF_LOCAL &&
	    ether_addr_equal(dev->dev_addr, sa->sa_data))
		return 0;

