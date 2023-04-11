Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6BC96DDEEA
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjDKPG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbjDKPGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:06:51 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DFC5599;
        Tue, 11 Apr 2023 08:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681225608; x=1712761608;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vRCaEziC5cya1vTvzX5B3j9HEzXNnJneeFweNnZ3EjQ=;
  b=Kn1tRThdOOyjsE4znTZWUpl8nEuF2tgSvUIkaIeyDkjMiW5lalrJhSt/
   momDs+1ChOadOTLQahHcgXpP5Q6vjFi0y8zFRLqRwlT0zsOEYdCAv+KdG
   CJCFOcHK0TBTs1JkYyDoFKrUH+W2CShyu1MA2iUmNcTAHDjJCQwmlu0JX
   wEpdrK42MVJzntvtjwmh+CkpYpPANwpnkT/fmJ7K2e1xXjXOlYKANZ1S+
   ahmzh5rVU1rV9jPnql51x0PxHqVHMh/DC92Aouutfk09SsluzjnlHv6nl
   tKiGwSPKSH7H8QWjo/yXS1Qs6m0KsFbB8KSIQIla94VBeTTN+wqj7r5nC
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="342402362"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="342402362"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 08:06:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="812596726"
X-IronPort-AV: E=Sophos;i="5.98,336,1673942400"; 
   d="scan'208";a="812596726"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 11 Apr 2023 08:06:47 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 11 Apr 2023 08:06:47 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 11 Apr 2023 08:06:47 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Tue, 11 Apr 2023 08:06:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aqyp+CW3nPkOTKcJIK44aBNG4hRqDP78/RXSqETP9QIyS4nUpOXQMFlfXGxF6zoOp6nAf5pSlrv92116hT8wdlnsYPOnDmgwdHgtioql82qivZudpUuNAzTvXJQmMcUbpIm5akeLRESNzRQslr3hLRf2nxqvJReM4FrCC5pzfJQ2kFGq/LcEZCDE6Vx/9VMfN51gMZPzX76dlrd8+NRTo+YmxUH+3G4oriMjMn3/bxlLj6xoOZRjdevXCWwZoOW2uA42I1ytlvHzhq5DFqBXCCc11LknRpGxFQoMnDAACzbQ5GfEISjqPYHoRgbTOHeGQsL9WTeGoHLK519iVBbGtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DXwqJMLpHeEmTB7jC8FBXmw533D1vvHQvhjeAS8hHdI=;
 b=BEes0KDIC2jXk+6UczLUJIhQU+POAMTbZeJNNa+/72kFKurfHtkKcjS9ElVvfJtUWhB0fVtlQJzz9VKcNP0dG3PJnhU+l2IpCNp5+lIMEDP/d8xLsDx77jL91lERmVIYAKTjhs1qqdQWmBvj3gOtZi1p3ela1uNTll9vy+Y9c9hS7BNpNnSpRQSJOu40ql4+Bc9csznRj43PZZXaQSwba7ZAqvTOE2UErf4kHav7w5OoSyR/1/IhTHpKbok4zuXTRP4H+oesckbjT4VgXY6oDoAnYcGBfLVKtWVv/lLXlmNpycr9RDojLAon24CQUQTCg00/owHovrtIiqhLYEzI/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by MW3PR11MB4601.namprd11.prod.outlook.com (2603:10b6:303:59::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 15:06:34 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c7d6:3545:6927:8493%7]) with mapi id 15.20.6277.038; Tue, 11 Apr 2023
 15:06:34 +0000
Message-ID: <96ad9a58-00c8-1bb3-06d6-841e7ea41488@intel.com>
Date:   Tue, 11 Apr 2023 08:06:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH V2,net-next, 2/3] net: mana: Enable RX path to handle
 various MTU sizes
Content-Language: en-US
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        <linux-hyperv@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <decui@microsoft.com>, <kys@microsoft.com>,
        <paulros@microsoft.com>, <olaf@aepfle.de>, <vkuznets@redhat.com>,
        <davem@davemloft.net>, <wei.liu@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <leon@kernel.org>,
        <longli@microsoft.com>, <ssengar@linux.microsoft.com>,
        <linux-rdma@vger.kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <bpf@vger.kernel.org>,
        <ast@kernel.org>, <sharmaajay@microsoft.com>, <hawk@kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1680901196-20643-1-git-send-email-haiyangz@microsoft.com>
 <1680901196-20643-3-git-send-email-haiyangz@microsoft.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <1680901196-20643-3-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0008.namprd08.prod.outlook.com
 (2603:10b6:a03:100::21) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|MW3PR11MB4601:EE_
X-MS-Office365-Filtering-Correlation-Id: 57cd4078-e57a-49fc-bb3a-08db3a9e56aa
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1i+BXcJiGkyM9EdBUFDCIgkmzyQPODPmDgNt0lBZMWau0q2tCtvEXYKcnfAhwJ7ZXQOJgXHcyhnVaO67EQ67EIXyIZ3Y/tGlQIOeBZe46JiYzq7nXdqNaEWxAawQxUBoxbvQeDqT70jfFqBCYCXj0TNbrE1AH1ZSZoihunv5anUAeJBsa1Szsh3p7Iph7w/cxr3qc4N1gzS7JptP/cbH6lW4/lCay/qG6/FPIERYF8vOGaDkXE90UKSDfTveop1Isl0b+wbwW2N6OnJc4rsfq+60EAmFTcw70LiG9nyphyAjHl+eljMDH6A9sGBakHIRWlT9OM0BWRGAOKaF5aM/m22EIuT9F1n/bzO2qLBvVh8wgId0okijsrldyXdwlzCpTFIaQoqMnJc2ZVL/NSi7Q0hFvyfgGsl9RAdvDdUFPPA2okYoY8/kkXaz/XziLXfm+s5mFnoWagGMNp9yFInR5urkJF7Aypust6n+P01sjEQiAWB/gx6kSTpgItV1VAbTc4fZTPklB6nF8wkJT9Kr21P8u2nbZ/73+OupyH0md6XQiHJkMu5kuQNFmUUblsGWr97Ita4ENO9gS0CEjpAl1qt6/xAfVBvKjD+hk1KSWg1FhhWcvNujntqw7VatyGwhH4MJw2Ey91wzY29MnAM6mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(376002)(396003)(366004)(451199021)(31686004)(478600001)(45080400002)(86362001)(83380400001)(31696002)(82960400001)(36756003)(2616005)(38100700002)(6486002)(4744005)(2906002)(53546011)(6512007)(316002)(26005)(6506007)(186003)(44832011)(66476007)(41300700001)(8676002)(6666004)(66556008)(8936002)(7416002)(4326008)(5660300002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXJib205QlQ4SmZNVStINExXSFNrdTdTMmd1ZHJiWFFPR0ZYSHlxMWVyMlN0?=
 =?utf-8?B?d0x3dFlSY25ocUM0ZkZMRzQ4bUR6U0pueEVtSUE0STBEL0RKTXRVN01PY3ZB?=
 =?utf-8?B?WHBjNWpLdW1tM2hON0E5OUh1MHliZC9ITStjbGlkbXJVdDVwZnFrVzNmUzl5?=
 =?utf-8?B?ZGRST3AzY3pNNkMxZFhaQTlTd2k1MWR1TUc1OWp4a3FXOWhOaUlXcnlmMCt5?=
 =?utf-8?B?LzJNSUtEbkkyMW1iWFl4Yk9aRTltT1RPRlpXV3l1dGloeW15ZlpIZ0F3Z3dD?=
 =?utf-8?B?cFBobXo5aGhEWTV6bWx2dUxZYjNxVWV4TmMyQU1UQmhraDJrMnBOMy8wOHJ3?=
 =?utf-8?B?WnpFUC91a3FDdS8wSk9Fdk5nWXkwWS9zcUljT2k0akJXWW9SdTFMUVBFb2NL?=
 =?utf-8?B?RXh6c3JSYzFVWm1YdFZwUGdyR1kyclRPYlV5ckFEODJobDFwbGlERnU5QWZn?=
 =?utf-8?B?MEticWxwUWo0NmIxTmNKeXBReUhXMmVTVGJlUzNob05LUFB4ajEreElpVjJG?=
 =?utf-8?B?QUlOQUE1VXlycXFrNjRGTVNFMThRVlovOThTYlo5Z3d0ZU5xMS94SW5CdXZR?=
 =?utf-8?B?TzROT0hpRlliRWZoWTUwNitvczRuVlF3NGpCVUUyZjQxNUpMVVhVUEtvdVlQ?=
 =?utf-8?B?amVQRzI3SjF5cHhMZjgyQi8zWmZJdXhramdzSFdhb0RieTBTdVRSazZBQjBK?=
 =?utf-8?B?UmxkTFpLZTV2NkVxNy9ZZUt6MXNxWmFhbW1xMzdvdll0ejRUZDlKY09CN2xx?=
 =?utf-8?B?RzZWNWJTRHpMbXoyckJQVXpuV2wxd2lPdGd0amhwVGtTcExLVDJieHdJLzdS?=
 =?utf-8?B?MDBSdnhZNVFEd09MVktPSER2WFcwTVc5Yyt0MlJQUU1rL2pQcis5SmFROUVl?=
 =?utf-8?B?Y1RpK2J1UTJSSkoxTnZIT0ZtRi9NV2tMVU1vYnhkWlFRdE5JZUp0T2liWGZj?=
 =?utf-8?B?QXJ0UTVKQmZZVTRhTGdnMW4yUE9TK0xhYWJ2S21vV2JQNml1RmYwblJTT3B6?=
 =?utf-8?B?OUtmdjFnTzcxK2xKMXVWR1B3elUwRG1uMVIwcGR1VnRJU1RIV1UwRjV2eUtC?=
 =?utf-8?B?K1cvNTRVcWRqVkZUT21ZeG5iOHBsbG93ZHNmS1FxMUFEaERnaDhsVWVFM0k3?=
 =?utf-8?B?SEVpMUd0Sk1oMFZETHFNMW9Ma28vY0NxRUZ5Q1QrRTkwdndWbHRnSEQyREFP?=
 =?utf-8?B?YkVmUEtQcVFjbHlYaVlTR2JoR25QcW1Cb1k3Q0dUc0dCeTI4eWUvRk04WmE3?=
 =?utf-8?B?Ly92OVJmbDFqK0lHanRYSUxoN3AwanRvdFZZQ3huUXZ6ZXY3aW42Wk5Pd0V0?=
 =?utf-8?B?ZzYxQ0U4SkQvc1dObXRxd0NMZlhqRlFDOHM5c2V5N2FTZ01pdUZDU1NNbzNP?=
 =?utf-8?B?K1ErQkZuUGUzRHdmS0dIT2hnSEdmNVR5WkRObXpoRlIva2FjdXU3dWxsbDNu?=
 =?utf-8?B?bndML1MzNU1GQWZxTTY4V2oxZmNmUnVVdUxhQWZISW1iZ3ZwNkE5Z3o1cm9B?=
 =?utf-8?B?NVJTWEFDQ3BpZ3NPa1k4dEJyK2dwTFU5UzdPVThDNXJ1akxUZ01jVFpXWXc5?=
 =?utf-8?B?Uk5OaDNONnEzUG5XbTJIc3QzN3NrV0VONzJzTE4xRHB1dExiajlUZXhEL0Jz?=
 =?utf-8?B?VWxGclFEcWs3dFVZZU5HcE1OQUJxVWFUd3lQSlhQSVN1THNWaUpLY3gvMFdZ?=
 =?utf-8?B?OFMyOUhxdDU3eE5ESm9JY2w2VVdsWEU3dlo5eERNNUFEOW8zUENESnpKVnJ6?=
 =?utf-8?B?ZHNhZVZ3SXhIVDBvYi9xWmNXeXo0YngydVVZK0Q5NXdQZGFVU0hSVU5vWmg4?=
 =?utf-8?B?QTNQdUdXMHd5MFRnYThtamFsM05ZRjY5MDBXR0prQ0dqSUg3RUFvNVRyMnVV?=
 =?utf-8?B?TmVYOVpXdXFLUkdoVEppQjdFTnh6WkJOVFl5ekFTdFRyZFYrVm56TGc4TG91?=
 =?utf-8?B?QUErMUF0bE1qYWNEMFVwb2d2NnUzN05QY3JIMlI1YzhkbEdHRFRPTDJQSWdJ?=
 =?utf-8?B?a21ZWTZyMkpEbmxaZ2VVS0dYWlEwSS8rRFcrQjI4bU95R21oWVVYWS92bStz?=
 =?utf-8?B?MFpwNWNuNForalhKU3B4clFqc3g3ODNvZEg0TnhJZG9lOGFpU3lIcjNJeTlL?=
 =?utf-8?B?b0c5WktKWWpVemlmWDNsWEk4Z1NuZ2p3VFRVNVduZG84ZHVvU3ZITjQ5RW1q?=
 =?utf-8?B?QlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 57cd4078-e57a-49fc-bb3a-08db3a9e56aa
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:06:33.9227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KtsGKPonyPT1Pc/cxLIxf0DxCHvTl+do+aXZukwHReNyBUwzVeVt4i76JNefHkC99SAHFMKJBzWyqByoctsvN1WzQLhtQ9ev04olluZynOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4601
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/2023 1:59 PM, Haiyang Zhang wrote:
> Update RX data path to allocate and use RX queue DMA buffers with
> proper size based on potentially various MTU sizes.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> 
> ---
> V2:
> Refectored to multiple patches for readability. Suggested by Yunsheng Lin.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

One tiny nit below, but not worth a respin.

> @@ -1764,6 +1798,7 @@ static struct mana_rxq *mana_create_rxq(struct mana_port_context *apc,
>  	struct mana_obj_spec wq_spec;
>  	struct mana_obj_spec cq_spec;
>  	struct gdma_queue_spec spec;
> +	unsigned int mtu = ndev->mtu;

This one isn't quite RCT order. I'd only change it if you have another
respin for some reason.

Ha, I see you remove that line in the next patch, never mind...

