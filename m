Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B44664E17E
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 20:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiLOTDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 14:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiLOTDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 14:03:09 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B559814099
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 11:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671130988; x=1702666988;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PL3VN3rGub9tokUVK2fR1Ry8ObLYQTaB6MxUdElZvc0=;
  b=iI/6GgsZgCmyigS15oirHUTlcf+P27jBw//H/1drx3DckY9bSg1TK+g3
   N9dMajEW4QTucMJde7hrj/Zxr+kcS3EEB2T5FWgnBksgxzFUmIOMzRs0t
   1HV25NA5DQnsj9EyHOZeE/2XO3MwFQzqQ6gg+P/HPpMUF4nSgoCOE6GM6
   UmdV/Un8Fj3zbvWwW7KqMxiLz7dGFSiIWrF/Sl3jH+7MBcOQC70AiOQv4
   AOG/uLle9xHW9/22AYXcSoZ1WyAByxo9rSB7w1owbmqfnF0Ltb7WSljeY
   b9JK6JEV087TDN04tVvdbNKdlD7fB6waSpr68wub8q1uzHRfZ2/gwH+VG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="306439321"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="306439321"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 11:03:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="651634018"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="651634018"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 15 Dec 2022 11:03:07 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 11:03:07 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 15 Dec 2022 11:03:07 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 15 Dec 2022 11:03:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q6CF3li2CXxPJHrR69ziH6qVJQ/C21eo/DAAIfY1sa9+BoGJlPwDc9DWP3dUCM3lkUzT5qyU5k5ZMjDFNZ3k1RlzC1/0NjOBxVdD0OGdhK4PhVPxoSCEXXKMwmYoqlCMwQVU2Ah5YOSLrS1mhaLnKcJ6wbGI59hI1HQMyGS921UcZiFEIMxQcCKj6zARZ9YgexPerfmQvhLX0e6PXmSwDK1TtvEnQyFWjpuSxjIwaqcyuVALrQ6sf5z8CZqtyy1v1xmotyAU4GZOoJDa+vOx+wDzagCQFBS6FLiCu0HHWtILVOA8P6OTfAfBERYQVOh7HVJa8S1mbU6zgKx0f4VsbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3M3LSyJAvhQtpsNyvI8ivKAfTOrsOYvfSe0aafGwmFE=;
 b=ICnNfcSCgKFOC5FDNKJxu260xhit2Qgu9eFS+LX/pNMXIxftaNQBWShFv95U/T3PIM2k9kN/1yw3O6xVcQflY5MSoQBX1kf/Vvp+0l5npHqumKPAdGI90yPHIWBMrpEGk3lGdSSIq1S2wEp3y0dX4QwzacRqyHkjrXRf7eowCjI3KXLzpm3dUg29WUtzKtY6pJrQCu7rmumQHPY5ryQ420mkHlD7dtFzfznRdar4+iWBHfIDrKqWvv/yw/alWtKk9d8XnJh5hlWg2MVwzxrz248WS0P806+NEApqRAjGeh2DUj/eBr+kXfhR6cKKo9ezvhRROv10AMiIdUHDogxYmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS0PR11MB7286.namprd11.prod.outlook.com (2603:10b6:8:13c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Thu, 15 Dec
 2022 19:03:04 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%5]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 19:03:04 +0000
Message-ID: <8d4304e8-f2a9-a107-26d1-d3aa4d7abf29@intel.com>
Date:   Thu, 15 Dec 2022 11:03:02 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC net-next 14/15] devlink: add by-instance dump infra
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jiri@resnulli.us>, <leon@kernel.org>
References: <20221215020155.1619839-1-kuba@kernel.org>
 <20221215020155.1619839-15-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221215020155.1619839-15-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0P220CA0020.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::26) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS0PR11MB7286:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c19e7ae-d325-4dec-49e0-08dadecefed7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8HtXR3UjF+vf8eePbFepNvoMjufJMezmP+aCVca+Mi86o4GrFgAgulHxQH+xO6xKu0r25IjEq2r3qKnFVqZSN+ZKX0f31/baCzgOjZZo2jJzDjOztimYmlO48A0wzVKZN+uYyxdqogT4rWY23kqkvwnQqDsqUwiUSJgprqD+FfDgzfjxnz1dUNHQfA4OP7df3tcoCwYb/rVKCNDerR3cdhfOrph2b7bSpN5QbAh30g+cYKs9n/frhhpDIGXGPlnbEopj5g9/gdkvh6ptaKGSun33hpMG01OeieN4j84z1mWPApAn+I9zUDv0qc/DJDmvUmhofMnMrh4wsf9JET6W6g6QRJlTPzHlVLX0uVJgNEyvcxpXpPPhGMT1cQxe3F9hLT+8VGKCegBNplNSnlOswEvZbCb72qG/+kDe04yERSYnt10BWd57iKusCJ19558oLRU37ofoSsPwRm1VAJSzDz7M+RnIJaNq91Op15NhzrVp632Zr8kYWXu7LaaT3c/gMmzhFafdY6Ikt8Ew42k/5XcWxJDewNzwSrMHIlhcT/hOk6tYv5VnTEcCvOxMaqjpCJZ4aE24f3Pw1Xjb5AW8IUB+RrKgypfiy30mfyb/7JQeykwfu7E7yGA/gAcClytCfOgobkAbMGCExmXTad4GWUfDs6fcegTwLCJ2vhJL60kXkk6w/EEFqqg711TcEHUhJkqJrpPyaH/UddSe14670H2UOYWxC0hBTDvuqxiu+oY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(136003)(346002)(39860400002)(366004)(451199015)(6486002)(66556008)(66476007)(66946007)(36756003)(4326008)(8676002)(316002)(38100700002)(82960400001)(26005)(53546011)(6506007)(6512007)(478600001)(186003)(86362001)(83380400001)(31696002)(31686004)(2616005)(2906002)(5660300002)(4744005)(8936002)(41300700001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3o0dk40TDhFNWRvcFVneldiRVY5dDZqa25LdkZWeHZkcTJkcFNGRDluZm0r?=
 =?utf-8?B?MEdwZmV3NGRXaFFZT1JBUk9ORENKczh6TCtZTjhaMEZ1c1hzK2FqZjF6TElO?=
 =?utf-8?B?Slc5Y2Q5MDVMcHlWOVVZVkozTUxjM25QRlVTR0hrRWdyVjlSaDJreUJrSzB1?=
 =?utf-8?B?TDBFMDlsbjVzSS9lelhHU1VNWlpzN1Y1SGgvZEJHS1F1TWYyZVQ1bVk1aHJW?=
 =?utf-8?B?bDRIc2lyQm50OHRiNzhvdnhuNGxUUEVLalZua1g4Rmg2K3dOMVRBcVVmazhZ?=
 =?utf-8?B?Y1hyNEcrMWdLcnBDRWtQVW9xc3hvVk1sMlFLUzF4TmFPcDN0SWY4ZUg3Qi9r?=
 =?utf-8?B?RFB1RUN6YmxyaFMrNzR2bCtXOHJseUdxV2xrS3VLQng3RGVFNUFVRUEyUFFq?=
 =?utf-8?B?VnY0YUhVMTkwNzZHdk03NlVlbHVKR2htVDFsRGZjUG1mNDJpYkZ6TVNmblBk?=
 =?utf-8?B?N25TT2xmcnZueGo3RkpSbXBxaHJnSkp4bU4rbHB0Wlh1VW5ScHF0eDd6cEtj?=
 =?utf-8?B?THJPL0JmMko0S0ZQc1lMVlJxakVvNTM2b0dEWlRDVk8raVh4dHFQVVZEekhs?=
 =?utf-8?B?cVR4NkVxblBsbi9hYm43amFUSllFS053ajZQUXBhZ3FneDMzSmZ0QTJRb3Zj?=
 =?utf-8?B?TVZjS2wvNmpPeVBEczllRENsZkdnMGRwWGRCcDdEaG1MTGRFWW42clhTSHdX?=
 =?utf-8?B?VmdxVldjRTNmQjB5dHlYVW5WYnkybUd1cUxLemg4ckN4Q2dIdVZTNGg0WEo4?=
 =?utf-8?B?aEh2Z0JnQzl0TUt6SElCMFVzMXpuSlhUdGhUNHhDeXoxK3dsci9MVythYU45?=
 =?utf-8?B?RVJ3emVIUHVVenlBZERhWnJLQndKMTJpcnN4WTFuQTQ5Q1h0QW43Q3hJUEdZ?=
 =?utf-8?B?c1RZUVlsVGVMOXdXRjhhaHY2d1J5NVlBVkp6dkZvVkM2TDVGR2VVeDBzd1BC?=
 =?utf-8?B?ZlBxbUZRQnhLcThKVnRMTjhrWkVNYno1TEUrby9SbkMyYnpramdFSmxJcjM3?=
 =?utf-8?B?YlJjY0NZbnM1bjI0ZzhsMzduVlZ4a1crbmpIUmlRNTdoWCtNanVId3pEcHhI?=
 =?utf-8?B?SnVINmZBSUVYTnB4T2hxVTNzN3poT1plS3g3d0h0R3c5MjZwVjh3M1VLNkVR?=
 =?utf-8?B?ZkM1dHF0elIyYXc4Tkx0VXJ2cDd4UFZ5YUpKSWdReHdZa0xIZllhbVRSQlZL?=
 =?utf-8?B?RlZxU1pHTlJBd3JGb3M2bGZaTlZpalRWancwRjVvTkx1SjVYQUpabkVvZjJv?=
 =?utf-8?B?dkRVb3lXaWNOQ3lIRFdJRmhuZlYwV0JsckhGRzFwT3pvZFJNcXFJV3EyMmwx?=
 =?utf-8?B?aHFmaXNIaGQ2SUoyc1BFb2NSMzlmbnRib3RnQjl6bzk0UGE4em8xcWZoY2Z0?=
 =?utf-8?B?SUhlQWgxN0czbkdCdlQxb3gxYTE4WklycGVRbFdsQmJpVk95SGY2UzNKLzBG?=
 =?utf-8?B?RTVZQlNqZTVmMlFuaXJRZ0JNL3lUN0FZbGhmcFc5Mit2MlpLRmo0NzlsazRM?=
 =?utf-8?B?R0pKMzlyd1BhV2JmZk1yWlhOWUZlQnJON0ptd3BlUTE5S2tHWkE5anVwbW5y?=
 =?utf-8?B?NDFhQ0JuaExoelllK2JvODVCSWx0bXJMNUZTQjM2YTJzNjdFYTFKbHcwM1pp?=
 =?utf-8?B?NlNmY0h5K3U0ZVE2UkNRbDFSbFVsQVh2KytHaERSKzl5bTVMYUdwekFjU3F6?=
 =?utf-8?B?SDNpbm9hUXRLRE1rLzVSYlZLSUx0cFJBMWlJRUxoRWVNWm5MdEhHYUFkTG1K?=
 =?utf-8?B?RW1MMmZONlc2UGpoL3BPRlJyMlRTMXRqSjJXYXdBeXNHb2ZIdXUzNEhZZWVP?=
 =?utf-8?B?dXJ0YktJQXJvZVBmZ280dUt2c3hDb1doOWJRUGdEYXpISVNxV3Jxa2s5L09o?=
 =?utf-8?B?M0dzekVTZW5halNXWDROOFlEYW01OVd2SFBaakI1ZFJVT3dIVnhTQ0xyV2Zr?=
 =?utf-8?B?c0pDaS81VjkwRFRqbzA2dWF0NW45SXdGUW1ZVEFocURGOEt4OGkrTmFTVFh5?=
 =?utf-8?B?TG5IZzNPZ1pQanNnSHQ3bGZFaFFHUTlXbVlLcUhvaFh1b0xJMGpRZ1REZnBz?=
 =?utf-8?B?T0x6TFJjWjhsV05GczJ0dWNNRDdiRVUrRmZVQWQwRjRPS1ZEV3pneUlkRHgz?=
 =?utf-8?B?cmdTcjJiWXc0R1diTmZqQ1VncCtZSzgyNjE5RmdFY1cxRmV1VUtCMWtCeUFp?=
 =?utf-8?B?cnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c19e7ae-d325-4dec-49e0-08dadecefed7
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 19:03:04.8372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RUfQ2KNMndrqtYrXjzS0OBQ7dvT6PLGcr/EDrK/JSFEayns8nMZ2lNsVieNJEBvynL1BC9LmKQvNAwhH1U8Thc/rdpCcBI0baczh+YNnz4E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7286
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/14/2022 6:01 PM, Jakub Kicinski wrote:
> Most dumpit implementations walk the devlink instances.
> This requires careful lock taking and reference dropping.
> Factor the loop out and provide just a callback to handle
> a single instance dump.
> 
> Convert one user as an example, other users converted
> in the next change.
> 
> Slightly inspired by ethtool netlink code.
> 

This is much nicer! A lot easier to read the dump for one instance than 
to try and parse out the iterating over each devlink.
