Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9481674B7C
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 05:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjATE5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 23:57:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbjATE5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 23:57:34 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4933BC79E6;
        Thu, 19 Jan 2023 20:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674190038; x=1705726038;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k7q2FPM/3gallr2gwFD6CVKK/7B/sjAw9FR6mzdJ0HY=;
  b=LITZBr74/RKUR10ex7QxaEP4m0L9BkYxe5OId2me2cMsGyr9gorPPEwj
   zwBG4QIjVd+03K5NjcLGKVIKmT7qUbTbLEYzEPvchjwBuBupe6NI7eID+
   cA8hWDFZ7/BHc3ScctgHEwzGuGKYn2mk9nlWKS/2jLtq85CH3RHGzeBsX
   Qhirl3m4DhQId3x8jg90+vELGt1tRcoM+SZr7uTclnwwTe1ARrjVfuw7i
   VU1cD1yVORi6V0eQFqLu2mYhdiq/r45V/mLJoQvB8u5abhg2JHgO1jy0d
   mSeKDzaB4zhm++HhJ1btguPK4mSTGd3mJpKK28DKzqzc6+96L/CRBKZ11
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="387834858"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="387834858"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 16:18:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="692657200"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="692657200"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 19 Jan 2023 16:18:10 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 16:18:10 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 16:18:10 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 16:18:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X39D6VsX/4r1lLnd6XKznQ/8x8W9OoJu+SBzztfnRiFAQzpjIfMjsexV1+qS+6TGJ4xF8qffOo+YCwUtUH4HgNVE7eCubuRC/UfRn8ElmcflNd7NBESrLlXEL1294KGmMR9Ld1o77VEJspwRZoPDCvL3TDw8UeQ9esFINIHbZajHYMJyTCnO+uXDBtVtxh9Iw0i5rsVsjiYUZad/PVPw5COGGHG3hfNR9PZfljBvQ8JEgcach7RxKVDyeo2ef4aTghckDP0GsIPeyJPvE5f5d2gEqjJrElbPR4hKRIdTbJfViF04utaHNFtilqOR96oeeoUFCQkf1wQYKxnGlkZCgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OgOR6Ha26ouGKuDOcev2XQrTe983/vq6WDo5X23F7Y4=;
 b=oHroJB4COPbGZObRlNRzLWOwsxv0uuYEzroik1HhDDu6ChkKEPvwM9GHSjao9aMdRxtRUW3pqenSg6jiJrdQkWml94ey0qrGYt+2RIR1jB2EV1npA7hWS0015R0jJFcBoO9dQwWaPxEW3xz3XIDx4ZoX7VNdR8Op6rnDJXi+76NeVh9tWaRnHa1t5jVvCaqCKMN+b5qLLSWylHFuq66LNGuALVl1PNfNTrFL3QHij2ubcu7SOeLGdN9OUhaVhvL3NuRN6n445fUUTBimH8hW9X56J9Krq33St1D/g6PmhYXCKI/t20pgYt/WddIU90y7IziR8igBK7FRMipFgyyDAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by IA1PR11MB7854.namprd11.prod.outlook.com (2603:10b6:208:3f6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.26; Fri, 20 Jan
 2023 00:18:07 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Fri, 20 Jan 2023
 00:18:07 +0000
Message-ID: <7a732996-e566-14e2-6ce1-1ccde16f5975@intel.com>
Date:   Thu, 19 Jan 2023 16:18:04 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v3 7/8] net: fou: use policy and operation tables
 generated from the spec
Content-Language: en-US
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <robh@kernel.org>,
        <stephen@networkplumber.org>, <ecree.xilinx@gmail.com>,
        <sdf@google.com>, <f.fainelli@gmail.com>, <fw@strlen.de>,
        <linux-doc@vger.kernel.org>, <razor@blackwall.org>,
        <nicolas.dichtel@6wind.com>
References: <20230119003613.111778-1-kuba@kernel.org>
 <20230119003613.111778-8-kuba@kernel.org>
 <a340a5e2da55f352322c2aa902b592ece9bfbb5a.camel@sipsolutions.net>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <a340a5e2da55f352322c2aa902b592ece9bfbb5a.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0189.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::14) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|IA1PR11MB7854:EE_
X-MS-Office365-Filtering-Correlation-Id: 48221034-5f2f-49b4-cab9-08dafa7bce24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B1fNF6dEwCkMc/U2I0EqSKX281cr4Fhj//1ZtXFu6KmBEawjxgOdwmU5hmQooIkQVLOMLF8S0XLP2Qnj70W49NyBpFHbmspBhbdUYadYxIG09Td1o5t+8mM2BPLY9DQCdVAfp7yM2odqFP22AD8nMeyoynVcAfm75U8XtYrtgg5DhGQPd407BIXTZ/GQHRVjozT06jZqkI4l6Qj8mPpaMBHy9L0JSKQ2P7esWt1D8U+fNloFlk/LpcBc8ASPA7e8Ssgeult6p9INz3YmOMjmA9ySQEAxo0iPuH7oxJlv5Kz3bmBNWzlgkfDzgDdlm9CA+TILZtOFYrJOQv2uJ8LK/NnslZzleAIFrFTtzYoEgBV1qXhv+4eO9Hk8ob5M/lTi1FYa6bKd8Y+sInjGN2mCIfkMMvv/PSW/nXkMBQCjX5t/xW9l5aG6liADaZ/FrSTWvhBmajVK5J+KG2HN/jUDLg01oTxokNmGjDj0DGtHKtO5pdxrcaR/kVBvQMrP63R7Nn4RAF/PQfV3MiWlp0/b1EOPMrSYBUqTplSjpjp7rejUSu5TT4gfO+O4V+eLxzINDs3vZTF0NCcjckisR5DssDKlq2uhXP2VRatb1YRWn6N8V1ELw9IHUvTWXKawRoglrLoxZgz7ufDMhEbOnaPT9J9ad3A4+WzUhKS+0k4rSMDJ7/8bQlpKGpHjolh+k0nMxehk+qnhwX92NQ87cXk3yHb4iIUoRBHNRiXeEX6dTTs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(366004)(376002)(346002)(136003)(451199015)(6486002)(316002)(6506007)(53546011)(478600001)(31696002)(6666004)(36756003)(8936002)(86362001)(5660300002)(8676002)(4744005)(82960400001)(4326008)(7416002)(66476007)(6512007)(41300700001)(38100700002)(66946007)(186003)(26005)(2616005)(2906002)(83380400001)(110136005)(66556008)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWxkU2IxSzhUaS9SZnlQSzdhY3c2d2FlWGF6L0xIcXRIUEVSS29XOGxMKzM3?=
 =?utf-8?B?L21WUUJXTUVMUDNYVm5DVDJTbUR2OGdqMzh2VDRBMWtFYzJIaTF2SEViaGFM?=
 =?utf-8?B?aFpFMlBHRUpwUmphc2V1d0J0aDlyYkd6WnRsT0xRRXBLaVMyQTFiai9pcDNI?=
 =?utf-8?B?WkhSTCthbnVET1R1djZDWkJYaGRDbis2QVNOYXBnWmtoR1lFcmwwTUppV1ps?=
 =?utf-8?B?T3RST1BxMVhlSW54WjJrU1lndDNnUHBJVjZKZ0E4VjUvRkZvN29jK0R3aEEx?=
 =?utf-8?B?Wkh4akJPYWFRdXZwT0JncW9zcDQ1bkh1Ry8xOTR6UEFpR1ZZN0RRRy9VanZC?=
 =?utf-8?B?eHZHRFpTY0djT205NytNZXRQckF3R0FaVVdNRmpiZnZCam1qWC95ZFovQXA2?=
 =?utf-8?B?WTE4L3RGeVdLNDlYemYrL2l4U1oyRjVxYXBpd0gyTTQ0bGNJSFRZaDUwTlEw?=
 =?utf-8?B?ZGl0NnovMDR0bzhoOTR5V2ltaXQ1NktPYUFJRjNaQmZYMVpPTjdRb1RFVDd5?=
 =?utf-8?B?djVrV3ZhSms4amVVaTBmZzhtVldVajE4cldHTUdjWWllamJHTlRWVVpyRWxN?=
 =?utf-8?B?SGovOVRUc2VHZ0VhdWpNL1kzS3NnaEVZR3FSYjlWWDFTcStIVExyV1VNWFJa?=
 =?utf-8?B?NHpGeHpxMHg2L0xUdlV0R2hVWFRuU3pkT3FCbkR3R0djWEdPMjR0cm9OOTV5?=
 =?utf-8?B?bExKUTJrR1Q2dWJTTFVIWXd4SDMrQm52c09za202TjBrV3RqS2MrNXh4a2Y5?=
 =?utf-8?B?d3o5azlsa3c3VkRaQlNlbzloQ1o1ZC9HUVdibHpId25zdlFlWVoxTlRJb2tB?=
 =?utf-8?B?eGNwTW5SM1hsY0pYT3orWDJUSHpEdjZZYVUyYnVRdzFIU2U2R0hqVDZyTGNZ?=
 =?utf-8?B?V0JRQ0VlL01ENTRRT0xUdGZwUCtYaWlxNWZZVmJxamE5UTVwcld2OVhJNTdU?=
 =?utf-8?B?a1h5U2Q3RlFsSFRoeHVwQlBOUDJoN2pwN2szaVZBaTFMN0pUQXE5Umo4N0lt?=
 =?utf-8?B?eHUwTE04YVdkaDRHK0FsVHpCNGtXWURWVGw2aWZBeG9TWEZQdlkyRk9PVURz?=
 =?utf-8?B?czgyUXN2R084RjAzWXkrcjV3WTRJMmNRU3RiYW9TbHFJVW84RHlJM0o0WHU5?=
 =?utf-8?B?dGg2LzhoNFplL3FrOEJFYUV4RDdQeFcxZXIweUc4U2N6cXhXQTNVSkJuVkxn?=
 =?utf-8?B?dUJTM0syUm9ybCtlbk9FYUluN1JZSWVFcjlkdGZIb3BXU3hiTkdMaGdJdXA4?=
 =?utf-8?B?blh2Q2N1bjJUd2FIK0hiNlk5VHd3MVdVdG16bmtSTzE5ZGZIZVBXRVhIcEgw?=
 =?utf-8?B?N3I2Nmp0SGRmTW9MTFV2WmVyQlNLZXRrdW1zY3BpNUNTSmllUmY3MTZIOC9w?=
 =?utf-8?B?cmgwV05DRWh1Sk5GT1MvcEUyRXlxY1B6cUh4TVRRWWJzdVNWZjNSWURPbElr?=
 =?utf-8?B?WTBUV0VISDRhUTIxaURDa05udkd5ZWgxcEJGbnpoWk5oVVRGTU1nZ0xsVC9U?=
 =?utf-8?B?LzVUb1h3T2V0c2xHNTRZbCt1Mk80Z2ZHNTBqRXBHbVpIV3Z3WVI4SHN0NEk5?=
 =?utf-8?B?RjUrVlBoOXp2dkJuN1dqdmdlOXlzWUh5NUM0MTZQSlc4cFgxQWkzL0pmSktI?=
 =?utf-8?B?cGNEeTRiejBRaU1mM0xvZUJiN0lvVjJWR3BkTk1vbVZOOFRSaU5mVGNjcmJH?=
 =?utf-8?B?WXFOeGdYWERBeUdza01EN0sxNVFEODVFWXU2Q01tSUxKWVRWeDVlRlQrUlo4?=
 =?utf-8?B?RmxMNW5zTkNJOUQzMUMvWEFUaTJ5SnkrY0lNVzRtYzE1MXQxVWFvL3NScXBO?=
 =?utf-8?B?Mnh1RHpPT1RwQ05kQ0l0OUNVU2xTa3kxNTVIY3g1NWFvMEZ0bkZnbW5BUkRG?=
 =?utf-8?B?TG9mNTlxRy9MYTNBVUoxR09NWTJybFYwejhOL1E3bHU4ZW9jcUtBNS9aNE1p?=
 =?utf-8?B?Vm9nd2dHbndFeW9oNFN0bmlOZTdCL05naks4T2ZoeXp3bERMck9ZUmVqVjRF?=
 =?utf-8?B?QlpJdjlyWUNIdEFhcUlkMzRBYkwycENmZkZ4OFJVVW94UXp5TzhQQVFmcVYy?=
 =?utf-8?B?VFdqMnNxRzNpSzNha0xWNVBTWWlycXhLcy9DUmZ6bTRjYnJIRjR3RFlvQmtB?=
 =?utf-8?B?QWU5UmQ1dDl5c3NzeHBYYmpDaUEySXlFa0Zic2tzV3RoY0ZtVU9YaUFyeVNS?=
 =?utf-8?B?b1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 48221034-5f2f-49b4-cab9-08dafa7bce24
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 00:18:07.4972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TBhhDcokChYSCeU6Kuuk9YENaHF3/ATt4bld6lEKUnu45jE2f/EHSqg5y2wJFup87jBVIFERwKPZT9fyTio51AfyB30TrfQ8tEDnLDu6baM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7854
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



On 1/19/2023 12:56 PM, Johannes Berg wrote:
> On Wed, 2023-01-18 at 16:36 -0800, Jakub Kicinski wrote:
>>
>> +fou-y := fou_core.o fou-nl.o
> 
> I feel like you could've been consistent there and used "fou-core.o"
> with a dash, but hey :-)
> 
> johannes

And here I lean towards using _ instead of - in file names but
consistency is good, all else being equal.
