Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8D2696BE0
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 18:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbjBNRkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 12:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbjBNRkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 12:40:52 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51C76222F4;
        Tue, 14 Feb 2023 09:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676396451; x=1707932451;
  h=message-id:date:subject:to:references:cc:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FCCazg48s3mTdgTSmH81kWlaFH/+746F3Xgsb5J0xyQ=;
  b=lNGhnGiQ1EGELAhr1Gs2JGUwxSXRU2zmiS46Tr4CCY/ikEzGAQk7FX/9
   6t4gf1cbVYY7Bof06TkqSr8dyXhp0lVzjw8Q39cF9n7dAab50Xg+vCyEy
   TC3AMOmcfLxX9FCSbiM17PsOF4QbWqw8tXmA89ncUUarxrirSamDKlVXx
   lxuSrstdJjlivD1kJvWmGqoau6/xIZo38pKOYUrycpxPhlKcSDVo97fJP
   UbDA3ba4bHRCAxt9RVol+exM0icJw1lYLhgdEeCpZConXJEIiLbFQTkw9
   XDhPLmrMnufFPTfm2rBXB+cI46XfOO/HYTbAXigsQCAbsqzCZTQoAnD15
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="417438488"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="417438488"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 09:40:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="662621047"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="662621047"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 14 Feb 2023 09:40:50 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 09:40:49 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 09:40:49 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 09:40:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GSLgyMymH0YshLHCg7HTxJdO4P1U6da2jiBquxw81pcV3EyKnBQ2+dqhhHrpGbUr7WqTRHgnV9LBuq2bJpVWh7VqF01Xtx3U459/jvinXgzjWbF4AOYW2icclTmmAzGuBzbkuat6MJ3Nd8VSrFyD+a52Ctvesq2f0nnSWOyWLw/9afqMceQJ3uMI1SRGdYwTZQG3bEzqwR766mltyH4nIafMYRusfH8KPTNNS6ViDnmFZgln8h+cEWJBDPbBLD/7Lbw9DXUF9L6Xajzmllg4Vgno95DPRHbdXbXGP/a/jYeRMcXwC/ZGfkCRv1tSF9FF9MWsOyM21AbA2CAHQjWlnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v1CdPen0TjHNkioO7uvcF6YwuidvSCG89bpa/gmgbGI=;
 b=gSrmHEXQ4VC/xR0lHREBAwhEUiorIpTLF5zUYFoz5dH81lwNAtrEyp/dXZ9ICqbuR3KH0Rnz8rP3i63wNNMYonnpcAF3zhojrQkljEhue5nELqDIPWYXTWZ9d9VX1YKtBTzlLFln+G75fOU2SJHqj+4VzyRhU+F52xYECyJUeMVVEso8ULhx5iMdr0xozccP/TXQw/SLni89Iwn5Vvb4kiDbv/3fQhmrKcKPcLjFCx/y6h/u0l47/Idkm3cnxTiRI6hoYrkWHuAeSZKn98yYT7o4jGmsdKwW+yqhIhSUZQQsG3RMl2BRUKB+9M6mSvuTOXFh2JvJ4/FijAsVlHYE8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CO6PR11MB5601.namprd11.prod.outlook.com (2603:10b6:303:13d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Tue, 14 Feb
 2023 17:40:47 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 17:40:47 +0000
Message-ID: <d5f2c46c-cf68-3ec9-ec87-f6748ede1d1f@intel.com>
Date:   Tue, 14 Feb 2023 18:39:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net] ipv6: Add lwtunnel encap size of all siblings in
 nexthop calculation
Content-Language: en-US
To:     Lu Wei <luwei32@huawei.com>
References: <20230214092933.3817533-1-luwei32@huawei.com>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
In-Reply-To: <20230214092933.3817533-1-luwei32@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0128.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::10) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CO6PR11MB5601:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b230db1-e1b4-4f68-ace0-08db0eb29b31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dv+lCCFU12j2nBinOvN8ekpEQI906cb6iozZI9DfXhRY0fT2YS6xKgdSb0XULA9L/ed0VpkU3LDqloeMzDLVXKP1hEFFfZRLCmkkj9XkwgfIUvgfNzAkRC0JgXG7mnGiLifZ69nD38iTa/KnBR9cpAUp6HGgv95TY4+btf+4ns3MBMxljYRMBFL8rsBy4d4f2EtgkLw5egPY6593x0Mwt4Aimltb0PWp1AaAOK3HJ+SiWw28yh18K2QGCg6LHdaj8KPIhNdzAJSIAGhIWtPU6dngdKpfsLTRrNWD+w1E6npQooAyhQWkaZuPmKI1kSKs7Cep+9n99N741VyV5dH4NbZkVlmM3U2pfOlkLpSY7p/m70WbQdHfWNaWiuRSapcj5PE5ds4BZuIjZiCF3VKZbVLW14shwsLw/MnJidXRlMNt57qZmLsnENjhHRPqAHmYIlWwANL/wRy3Ols4Eyo/r0TOqrr2UNjJ5S9sXIq9Vyfzz5wA0N6NrCp4LUVF6H5foLcsmGfZt55pojnT93cfOY9+dTDBqNMeUessV9hHs+TXePXY42KkpSYOGeFvhIhFfCsop+oewNc7u/tLhUz8RQOjHNpH2MnkGKoJddtXnH5rkh1vrUC8PheXEKb+dwbJLURVpIVthrV0YK7hJm0BDtXb9sHhAwwfwIO2FTB2gLTwlOTYhvI1aMDNTAlbkstaxNtSeXtm874CIb3EMe5Y/VS2w1ga3kwbGORGDnsfNp8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(346002)(366004)(396003)(376002)(451199018)(31686004)(31696002)(83380400001)(186003)(26005)(6512007)(36756003)(2906002)(5660300002)(6506007)(86362001)(478600001)(41300700001)(6666004)(6486002)(8936002)(316002)(2616005)(66946007)(66476007)(82960400001)(38100700002)(66556008)(4326008)(8676002)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHdrWU03WllneFRsb29nb3JaNlkxeHYydCsxUkdnRndqdUpDNTJpdmx3Q1F6?=
 =?utf-8?B?aHNuT1dMYmEzanBQQytmRHJQTmxIalpBd0ZMZkZVUGYzaHoxNVFRNjE2b1hu?=
 =?utf-8?B?azRVZzBrMSs5a2JadFRyL3cwZ2VBMUlEVURad0dobURYZXlTaUlZbWI5UkNL?=
 =?utf-8?B?U3YwYmc2Zmhna0s5WDV2R0w4VWV1OFcrNTQyeFdsZUlIbjBMcXBwRU80dG9X?=
 =?utf-8?B?d1VzS0JqRlFxOVhGWG50bmNxM0NpMDd1RFZpUlJ2cmplaEhjTzBRSFpOVlZs?=
 =?utf-8?B?MndGUHBKYU5GUmlxaDJienBBektpM1pBcjZwamczeVpOVXd4Zms2b3kyQWhH?=
 =?utf-8?B?ZmxMcG5HM20zN2twNUVkQ3B3OUx5TGtMQnR2bmlKVFY4TjJtNXozdlh5cUw1?=
 =?utf-8?B?c20vWHdneG1kdnViaWRlT29aeGcvUjRLM2JUd3UxaGc1d3JIdHkra05WdktQ?=
 =?utf-8?B?RERrcVlyeEI3bDlVRURHNlpaOUg4SzI0VGx4REp1ZFBKbGsrNzZzRlpHK2xU?=
 =?utf-8?B?NHJ5ZWJQc2NqK1hnNmRNaU8rcW1LQnVMUTJJN2VkVHdmUTMvMnYrR1pDL2Yv?=
 =?utf-8?B?TFFndGdCSUFjKy9wbDI4Z2dZb24zTk05NDZrR0poQlRXN200MUsrU0pKU2Fu?=
 =?utf-8?B?em84S1VRSWJHakhoZ1l1aVVRWWhpL2orUGczbHlJNC92YXpDVUJjMWhwOHVN?=
 =?utf-8?B?WkhZZ1BoejVUUC9jTHVpL2MyUXc5ZHdkU2ZXbTliMEVSN3Zvb21nSCtCSXc2?=
 =?utf-8?B?MWtPUSs0U3pTWS9peXc4QXNoVGhjbmJaVDlBbWlhYzI0U3ZBU2V6RzNGQVNx?=
 =?utf-8?B?NzRWczJkTkdtNXFVcE9XbEVnbGFjbGJJWStwaE1BMld0cXB0b21LTHQxV2M2?=
 =?utf-8?B?c0U0YXdPNWlKTlFtVmhEYjRHQmQ0c1dmSU1UaDVOMi9TRSsxek1FT0VjcG03?=
 =?utf-8?B?VjFBVGdsb29MT3FHaHRNaE12K3ltVlR4S25iZU5tdzdZZjRMNjBLejNFK1E4?=
 =?utf-8?B?TGtpT0E4R1llTGZtZEl5S2VPNG1QNUNLZ3hjS2RLYnJDQ0JZNUxCR2srMUtx?=
 =?utf-8?B?M0xGK3FNc1NWRFgzdkVEMHR6UmxKNHhOZDJ5NnBDMFRYYzgyZmRhbEsyenRF?=
 =?utf-8?B?UEttTllsd0ZlazdQeEJZbGo0RlBrbHB5dWJpcDJ1VHNHNlFlQnpPZElwSG8z?=
 =?utf-8?B?T29ONDBPcmxJY1I1Nzl6Z3VPaHBNcW9UM081dDVqQUExVFZIRHhYWmZTMmdW?=
 =?utf-8?B?Z01QajlHQ20wbGVnRU9mMVdBYXJNREViOWVocjNyQ2xCdUZoRWZIVENmNXNk?=
 =?utf-8?B?Y2MwQzN5QWNFVSt1WnRNSTk0bVd3Ui84b0ZyKzZXd3lHM21UaStKYkI3OUMw?=
 =?utf-8?B?Ykp4dU9LeklhYWFHYXVsK1ZpYkp5ZG5GZVRBTTVDckcrS3h6Q0loODVubnVJ?=
 =?utf-8?B?elMwdnRhY2J0WjB0K2gxd2hPMnF0cHRBNStiVkFtSDNJUlBCZi80ZC9ibHBF?=
 =?utf-8?B?bEc0UHM5bW42Y1BhWm4yUXZReHQ1UUFpYkQ4SjlhVm1ralEwSTJKTDJZeTZr?=
 =?utf-8?B?M3FZYlo5WjZ1S1d3Z0RvcUhxcXkxR21yKzdHU1hlQWFEZkN6bUF0eXB6enZJ?=
 =?utf-8?B?T2JobVpTSXlzbTVxL0RmYjFwNXVielQ4WTUvTEZoS0ZiVkphaitOc0loeDNP?=
 =?utf-8?B?bk04NDVXM0doWWVQbGw5UGlWVmM0N3BtL1dUSmdPbkdPL0NQU0lGMldhNjdu?=
 =?utf-8?B?dU80ZC9hQlNYbitubEFiWjNXdHc3RU4vNEVFQnYrVVVWNi85UVg3VU9sQzE0?=
 =?utf-8?B?bUpwRERENlpmakJIbkc2aEY0V3hCcGw1cmhyanJSRUxYeEV1QncxTFJKUVhK?=
 =?utf-8?B?ejQvRzB1TmhiaGZxbUI4YW9ubHd1SXUvWnpZZ3VtMU1hQ0VNQ2c3WTRKc09S?=
 =?utf-8?B?V0JEWmNtN3ZsVGJWd2pubVFXVnpwNXA0SWRoaHBuczVPNzkxT2JTN1N3OTBh?=
 =?utf-8?B?MGhOUlo1QmgyUU0zdEd4ODdUeWNGOE8vaG5sMTg2WmdxRWlrSXp3UEM0cmtm?=
 =?utf-8?B?WXU0L3RBOFAyWnAwV3hVSVdrS1dKRVlLeHNTSEN6RThYUUhjOGZqOGdjVXZ4?=
 =?utf-8?B?SFM0Q010aHlsT25YOGFwSjlYeHJuV0VvM3I5SGVyZVlUSU1XMGg2c2dzWE1N?=
 =?utf-8?B?M1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b230db1-e1b4-4f68-ace0-08db0eb29b31
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 17:40:47.6248
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DptosTy4PWyUqrb1bhW6ebgs25X7gpp1T+LXdi4UQ1Fb4OiBxRRfFYJ7Bejg1rU0Et/ApQwGfKFaXbFfFf5oQ4Pxhn3sem0A1F6fdgd8rSQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5601
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lu Wei <luwei32@huawei.com>
Date: Tue, 14 Feb 2023 17:29:33 +0800

> In function rt6_nlmsg_size(), the length of nexthop is calculated
> by multipling the nexthop length of fib6_info and the number of
> siblings. However if the fib6_info has no lwtunnel but the siblings
> have lwtunnels, the nexthop length is less than it should be, and
> it will trigger a warning in inet6_rt_notify() as follows:

[...]

> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index e74e0361fd92..a6983a13dd20 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -5540,16 +5540,17 @@ static size_t rt6_nlmsg_size(struct fib6_info *f6i)
>  		nexthop_for_each_fib6_nh(f6i->nh, rt6_nh_nlmsg_size,
>  					 &nexthop_len);
>  	} else {
> +		struct fib6_info *sibling, *next_sibling;
>  		struct fib6_nh *nh = f6i->fib6_nh;
>  
>  		nexthop_len = 0;
>  		if (f6i->fib6_nsiblings) {
> -			nexthop_len = nla_total_size(0)	 /* RTA_MULTIPATH */
> -				    + NLA_ALIGN(sizeof(struct rtnexthop))
> -				    + nla_total_size(16) /* RTA_GATEWAY */
> -				    + lwtunnel_get_encap_size(nh->fib_nh_lws);
> +			rt6_nh_nlmsg_size(nh, &nexthop_len);
>  
> -			nexthop_len *= f6i->fib6_nsiblings;
> +			list_for_each_entry_safe(sibling, next_sibling,
> +						 &f6i->fib6_siblings, fib6_siblings) {
> +				rt6_nh_nlmsg_size(sibling->fib6_nh, &nexthop_len);
> +			}

Just a random nitpick that you shouldn't put braces {} around oneliners :D

>  		}
>  		nexthop_len += lwtunnel_get_encap_size(nh->fib_nh_lws);
>  	}
Thanks,
Olek
