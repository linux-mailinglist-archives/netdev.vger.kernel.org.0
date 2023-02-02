Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B01968854B
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 18:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbjBBRXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 12:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232387AbjBBRXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 12:23:18 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE9E29E24;
        Thu,  2 Feb 2023 09:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675358597; x=1706894597;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fUbXH0yYMO3Wjl6pxv1d7r4kDUJwjVnwEBwCT8FYbc4=;
  b=irVH3hV9PwPQomoXqOwh1TBPHYTRh409merYcdLROWvbkbnAMDPqdHdW
   vlXgJ//Sy2TvnTKdGvB9zSBLq7kzUm5MaXlMBbZgA34WFfqmsKHwA0pra
   UKO09ZwAUktUcksbLWt8BdGoYhyEukwpr6XqGi/W9OF+WsushTsqGo5Ir
   /aP1ROJAa2Wo6cLqepvsylXYaomIXIWId9UJgvgqCJu0v4A7l2zKJ965g
   3sC8/34q13UaVsfkIPN1JHnIrcmZamS1MDmXLxa8uPCzOoBkhuA86tyPn
   Apu3FLf0nVHOBA6mExLNneMmtlMP+gwHNbOz90twtrDUORMZo7mjWysBY
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="393096356"
X-IronPort-AV: E=Sophos;i="5.97,268,1669104000"; 
   d="scan'208";a="393096356"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 09:23:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="994176828"
X-IronPort-AV: E=Sophos;i="5.97,268,1669104000"; 
   d="scan'208";a="994176828"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 02 Feb 2023 09:23:15 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 09:23:15 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 09:23:15 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 2 Feb 2023 09:23:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LboJV+XLcNa8WXBi6I1pqwEZd6lMz72u5YGzo1H0qbhKlWb4kEJRCzhdoCVKJKzIJP0MnUTlY1Z8Pr4FC420XfiCMNcpkIR7Ka3g93f7Gc+IQaDNtzJY6iqdWyDfiuATh/2WrpCMPegdF/KQ9wGO83EAHBmAvouUj0ZwJ+nYu3NjSwKqdIALR0ZAcjMrlGWNuOsPrhySBOxKrck8FZEaTGKkY2S2AMhvKkNY+YoKKU3twMVa6w7XBfkkUfpQlsELn4X05WGB5j/chaus8GHLMKQHjMkgvy415pSANvyGEJX8g0Ep+drt0eGCLyp/Zjy2GytcYhUpzMyBZ0Qk7EXvhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IjHr4BL/Ju5lG1IEF0KqYnCA+gzMqKNwyIR7as8bBec=;
 b=f4Om4CiitgGbh4JMPk8JxEQ+qMDXypOZeDApSO35CuXF8ids7aESh1pNCh27JWTdnjVFlWoWHrBjUMtmKzAEV4wonaOS7D6e47HU9oJBB0lZigGTz/d7EIu8xfJmifsIAfHX0wzfll0O86BlsMoZmie9q97Mm8dwUwhfS22TuUnMS+yAV0ZVHlECFUW8wJQk8iUV+kgl/jJg/hjAFWiU45nrMR7rtUb/K6L/EXeshZMFJUi0axdAPi0OrXvBvpDUt8n+Z7ZTCiapcKP1CBMRvEHj7qNGbwYGNm3bGBXAP082EFBsEpR5Ajnstv3YzMMKOuI+qWyP6e+2+0o8jxLryw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by PH0PR11MB5926.namprd11.prod.outlook.com (2603:10b6:510:14d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 17:23:13 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::cea8:722d:15ae:a6ed%4]) with mapi id 15.20.6064.023; Thu, 2 Feb 2023
 17:23:13 +0000
Message-ID: <b285cdee-b591-5266-5a74-e8c08b034f76@intel.com>
Date:   Thu, 2 Feb 2023 09:23:09 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3] i40e: Add checking for null for nlmsg_find_attr()
Content-Language: en-US
To:     Natalia Petrova <n.petrova@fintech.ru>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lvc-project@linuxtesting.org>
References: <20230201090610.52782-1-n.petrova@fintech.ru>
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <20230201090610.52782-1-n.petrova@fintech.ru>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0164.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::19) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|PH0PR11MB5926:EE_
X-MS-Office365-Filtering-Correlation-Id: 79dc470f-f35a-47b7-4fd0-08db054229b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GNpB1+5VUdfOF84ipjuLRyK+/Z27/6M05mWtPN6symsujaU3KgcxZ5GZ92NO68SZe0DzOObviLCTYH7kG3PJSg3UYpDO2EZol+ZG5Peoc/8yIcQ/EgfS0jnRUs+5fk0/CUH3cYFSv5blgtOcLhnFG4KOqsLt+KI9Vj0QRYjbOTn0PtMsdn6T5QsUwxez6MsKMH3WTbKH6mM7CuXM9u33BbxePpkQS4mBQ7PlqhIU8pSFrB8FSfpUE3SSVTWtTfW7SmXXL2uc0YsV1M7rySundSqMBWz/m3/nqgzhJRrNVBEsc9/AmVW8bwat7aYYCUN72kIgOcCRhwTwm8twzlKwXSOH4RmH1Bj5UNniu24k8u1wfi2pgbF5t8nLrINYkCQ4wpFxTAZw514cEJ3z+eTEE6gumombTMkCLd1oDBeg0cMI7Uc/cfKmIqAYujupNtTALGbu52Nor1QzHtGK3poQZm9SNKjREK6MMcft3oF4s+CVCH+fxQnKysx7EhovywYf3XMe37Bq8dwMETFKFTBxVl88oO9mGU0tP3QKPZD4iamAEYKRdp6wQrol58lwsfAH2qXf4hMv/CuVKf5nXf0QlXwvPuPWmjALBMkBwLgx6yrzPR0w0hTuxoxbKNFJAQjbfPKwpZNVWbO6UvLNgWdVPx3UUDS+wMqZLogXtOkgdZpOFlsfSdiNs46Dg20+wH339GAfug8yPdTv8ERsGa1fj0HkkA7ylUHTArZljeGiXBA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(366004)(376002)(39860400002)(396003)(451199018)(31696002)(36756003)(86362001)(38100700002)(6666004)(66946007)(66476007)(8676002)(6486002)(66556008)(6636002)(54906003)(4326008)(316002)(8936002)(41300700001)(5660300002)(478600001)(82960400001)(2906002)(186003)(53546011)(26005)(6506007)(6512007)(110136005)(83380400001)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cEU4OE9aZ2pQanZ1NWZpTWFCdjF0OU56eFIyTVVYdXBHMHNqNzljZkpaWTZT?=
 =?utf-8?B?ZXNGWUo5bHpKc2JVNVE3VHVRM2ZYRW1YTFRpKy9CazRRSVNoOUgzbDJMbXln?=
 =?utf-8?B?ak9kYkpBYU95cHZtZy8zaHdqci9PeFFLcWpXUEttaEZNcm9wbC9oZjJENHEz?=
 =?utf-8?B?MWlTVU4zQSs3azljTzNwWm5wdERJNXJRZ0htbHF2UnNyaHpHalZTTHFCUTMw?=
 =?utf-8?B?VWJHT21pZHlweUdadC82KzR6K2lHU2J6b2pteUJVc1JDNXJEM3J1YWVpV09v?=
 =?utf-8?B?WjBFU2NWK0FLbFAwQXVwVXhvL3pkVzJPemVQdlozSkNxdkdSVW4vb1o0aU9S?=
 =?utf-8?B?aURmcm40WjhOby9mYm5MU25wMnlnSHZsalM4MCs0d0lkWDU3aUN5ZHpBb2FD?=
 =?utf-8?B?SWRoTlNBNDd3S0hLbHZZRm04dlhuWnp1MjVFWGVnRW1Ba3ZqKzFYYjRkU0R1?=
 =?utf-8?B?UzlmMnJkeWdvY3g2cmxMcVRWdnlibGFTM1l3blJUWEJ2VmpEK1cyZE5pK2ZW?=
 =?utf-8?B?MFJ4ajZ5ZFFlTGorUERNS1hURm5DUFRLNVFwL1cxbzQ0Y1l5MG5KQmZUY1NC?=
 =?utf-8?B?MHBDWEtEVzg5YTFrajNJL2tZRHdvMWo3SDg3NzVNTllCTHB5SG4rcEdlWGdD?=
 =?utf-8?B?Qms0NFFYdmpITEpVaGMrRjhvRTZvekJ2dUU3bHZCVE1icHRHbkYvcllrbnpN?=
 =?utf-8?B?Z0M5bzBFVjltcVFGQ3hWSFAvd0NlandsbDJvY1JVbUZmNWRqbHF6M2ttNUpZ?=
 =?utf-8?B?SnBRTnZpNUFtRUF1S3gvbVU5YThZSHEzanB1cFdLYzM0N0FZMENNSVp2K00x?=
 =?utf-8?B?aTVLZUE5S21QWmdLTlhjQ1c0VDNxaWg1eTlNdHpQU0krRFJjeDVqay8xQWtr?=
 =?utf-8?B?c1pwZEFjRzJ3SDRpTVlVVm11dGlaM1MrTjFDU3cxTEIvZmYzNHNraEUwVGVG?=
 =?utf-8?B?Z1VYYm9ZaEQ2OGJVek5HcDB5VXJlUEVtZ1JjTWl1eXZTRVNmSEwwb2FUVFV4?=
 =?utf-8?B?KzNMMmI3QkRvV29ic0xyaHoyeno5VWZsR1JxSXpiVEVZUG5DQVI4aUxFbkE3?=
 =?utf-8?B?dWdZOTBhZ0dsb2E1dkdJclNYcHF2c1dEOEp3SlR3RlJSdFZhMUN1RFNlenZ1?=
 =?utf-8?B?M1RBaEdvS2dPMXhPLzF5eWFwU0tPa0o2aTZyRjRQdkIrSHBlUEg3aDJlblNi?=
 =?utf-8?B?aUtZeXpHMTRjVnk4S2Z2emkwVXNiYlF3WXUvQjQyYStMbFR6YUhnM2NNYmF0?=
 =?utf-8?B?YitSa3R4VSs2QUZUbjZPMEFWNUtobXhDalFvUXRXRzNndFlpeVpuUVVvTDNh?=
 =?utf-8?B?NFJhVy9neFMrdWRBYnp4Y0R2eGZEOFdqeEJ0Q0NXb2VKVDFMamFZak5kTWxk?=
 =?utf-8?B?ZWM0R3F6TW1xY1NkRnR5b3IvL05sdjNFNDgxMzZRdlNSbGJjM2F5YTB4ZmlM?=
 =?utf-8?B?NHVJVEdHdG8rRlpkN0M1NUNQKzd2cXFSdml2RnVzbjlneVBDb1hVVVVPZUw3?=
 =?utf-8?B?cGtZdXRiMjRkT0FWUWZGOHVYWWNOLzMvejc3WWl1cFBLWmhTWDZFWnU4eFV2?=
 =?utf-8?B?OHRDS1RvZ2NKMTZUV09JS3NaR1VvcDRhZStWK1orQWE2b2VwVXZrZjhCazlW?=
 =?utf-8?B?Kzh1RzQ1TE5tNFVxZkNqZm1nTHFxYVhVRjRMeWdSeHRGQ1BvZnFrT3d3bm14?=
 =?utf-8?B?NmZ5ZTNJWTU1elU5bjNHMGxPYzN5TDVQYXVGdGJlTlNuZnVrb2pIYWdqcjlu?=
 =?utf-8?B?R2REWnZPT3cwTDNEUy83RmlTOGQxNFlzeFg2alFWT3QwbFR6MDFIeno2VUVv?=
 =?utf-8?B?UU14TWdsOHFWM0ZON080Z01IMFBNQkNDeE51YTI5L0JEaWdsSUNoNUY1Wk80?=
 =?utf-8?B?SHhxL0IvQXBCcFpTS2xDZnVHS2lhUEovS1J1R0lvd0lRdStQeVIwUzV2dDJN?=
 =?utf-8?B?dUk4U3ViTTRWVEZBTHNyYzhENlBpczVDMERycFJkenQwMWI0MU0vT0QzSW1i?=
 =?utf-8?B?eEZDZTVTR1pYUEFuVXVZWHgrY2JsKzN3RjcrakZnNndrMjFSWlRneUMyd0tU?=
 =?utf-8?B?M1ZUMk55VUJjTDNKdVFYUG10M3FxdFdlMU1nMXdQOTJVOEhRR0hmc2txOU9k?=
 =?utf-8?B?S3JLYUUvYlVqWjNWU2twNklQa29nQ3g5UWZwdWNBRTBObVBGYVphbFlWMWdm?=
 =?utf-8?B?MlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 79dc470f-f35a-47b7-4fd0-08db054229b5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 17:23:13.0504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gojWtP9FlROxXG1PByInrMoVlErlZ18XhHu6SOU4Z6iE2CATnz2apLcd6I+530hXLmWXeJgwKPKljYgHEm/I2cXFtqRgaG9BoNpYITmrDDY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5926
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

On 2/1/2023 1:06 AM, Natalia Petrova wrote:
> The result of nlmsg_find_attr() 'br_spec' is dereferenced in
> nla_for_each_nested(), but it can take NULL value in nla_find() function,
> which will result in an error.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: 51616018dd1b ("i40e: Add support for getlink, setlink ndo ops")
> Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---

Thanks for the patch. I've applied it, however, for the future if you 
could specify the target tree. Simon mentioned it in v2, but his example 
omitted the tree.

i.e.
[PATCH v3 net] i40e: Add checking for null for nlmsg_find_attr()

Thanks,
Tony

> v3: Fixed mailing list.
> v2: The remark about the error code by Simon Horman <simon.horman@corigine.com>
> was taken into account; return value -ENOENT was changed to -EINVAL.
>   drivers/net/ethernet/intel/i40e/i40e_main.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
> index 53d0083e35da..4626d2a1af91 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -13167,6 +13167,8 @@ static int i40e_ndo_bridge_setlink(struct net_device *dev,
>   	}
>   
>   	br_spec = nlmsg_find_attr(nlh, sizeof(struct ifinfomsg), IFLA_AF_SPEC);
> +	if (!br_spec)
> +		return -EINVAL;
>   
>   	nla_for_each_nested(attr, br_spec, rem) {
>   		__u16 mode;
