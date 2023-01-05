Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E654465F340
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 19:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbjAESAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 13:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbjAESAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 13:00:06 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D141C18B35
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 10:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672941605; x=1704477605;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=j4bt/mwuGlukCU3+4DpOEqmPsu47e/FbGbGGYFxlSYo=;
  b=YxYBOYFQpDGKL18rn8/kHzc1JtcHoeoAzYWl6MP9q3InZJKbmzzr9CcC
   8bxiBTPTUDKjFAouNStVFEP7xSAOqdGgvTw+EuEpVOfxsOj2Ld712nB+r
   iTfTJiialytRn69CVwMX2pjZeH0s91+2ZV+mAIZZ7MDUDz4Q8HdUDxGiz
   Ei0hspYsPkpkwpz3K/mlRmG5iWr/QsTQef/50dp7799TUDQJLgmfOTY0d
   IRfMhTnCwiFwy0lhb81csgUeWOIMlE0oT83m6heo2BFRLDhvbTiOEJrmO
   4J22R2xI7JXD7tsJAYy+sqsRmAqrmiJIZjzgHuXgvFHg1uyjtTI91E1hK
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="349490173"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="349490173"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2023 10:00:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10581"; a="686204386"
X-IronPort-AV: E=Sophos;i="5.96,303,1665471600"; 
   d="scan'208";a="686204386"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 05 Jan 2023 10:00:04 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 5 Jan 2023 10:00:03 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 5 Jan 2023 10:00:03 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 5 Jan 2023 10:00:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hWdGHolHnFfs3aIwmd69GAuig1fN0UwtdqjyfdP9S+yP+30Wp5fGxH8sssfWRX7V9m87/La8xLdm8+6H3JexOx92KSXSHjUcEHrJossppt9Ti8F67UbphlmMF5TOq7M8tXWnMvr29wjgI467a7OFsw2a3TZ77SOIJWicT9lglI417F7+zCiVZsTNPWDonpmcrI7qeSIAC2w3k8JQJwKNvFUKsmO0VKnIoVBf5dlGhdk3jGwrnPEwEa/8gsDHE50+SZBCHS1adAzYXd2Dv7EuhHwVTia1CYR3PLOUE0FwG6pYxrsDJLbeq8pA4fACy2eTAAnZIkS/7bl/6hEiAwxoeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=67u5tTxJx2lhRU7ApkY8h2vrRQFNI91VaUvF79eT86Q=;
 b=NScxskSEn/65+9l7ullLzBXtrg+XXshI7tRjnsa707t0aB2LBhpXeBBjbz9M2fEFCW1JRIN464e0tfgEuFglrB+icoN6BY1XeJPAWE0UxwRGhpfdjeTNUy113TMRGeyuB7r/nkrS4WSZSwvaBAgCCekwWyy+fC//v9H6h5qnSTv3bAQeoER6uOHbmvmCwpRO1Jxz7Om+zIyyzE6bi0jUP0rHc7kBHWJrfneAJUxX4v6/xlVSRBr0cbXvGmILyP8GoxCuRi5oIblCByIJV58Gysx+EUQgZEc9JnVBhcTwv6Av56Gr1RDcgEFqpnj/aJzcoTjjpuP1muHZ1lSzAIsWNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by CH0PR11MB8166.namprd11.prod.outlook.com (2603:10b6:610:182::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 18:00:00 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::6ce9:35:a5db:f6dc%6]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 18:00:00 +0000
Message-ID: <26886c45-b3b3-ed60-d3ad-77b1da2dcc3f@intel.com>
Date:   Thu, 5 Jan 2023 09:59:58 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 net-next 0/5] net: wwan: t7xx: fw flashing & coredump
 support
To:     <m.chetan.kumar@linux.intel.com>, <netdev@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <johannes@sipsolutions.net>, <ryazanov.s.a@gmail.com>,
        <loic.poulain@linaro.org>, <ilpo.jarvinen@linux.intel.com>,
        <ricardo.martinez@linux.intel.com>,
        <chiranjeevi.rapolu@linux.intel.com>, <haijun.liu@mediatek.com>,
        <edumazet@google.com>, <pabeni@redhat.com>, <linuxwwan@intel.com>,
        <linuxwwan_5g@intel.com>, <chandrashekar.devegowda@intel.com>
References: <20230105154149.198813-1-m.chetan.kumar@linux.intel.com>
Content-Language: en-US
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230105154149.198813-1-m.chetan.kumar@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0027.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::32) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|CH0PR11MB8166:EE_
X-MS-Office365-Filtering-Correlation-Id: ddfa8e18-57c7-4fe9-8ab9-08daef46aa08
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZQvM69O9ss2Vls9UBPAqUqQO4cilt9sRoeWFsYaPrbMvBDI+cXxKwt/F6UDR0AfcgjhHvholDHhzhqeeq2C6m+NconjFzOeCqi9uUROLEssNumKpXmmJI9uvohHT887u8dEtPyOr/8V3qZM0MPXp62LTijqTEieG4UwRBmz2vfmDGaiZqeWszI39/t2ucYx0QdJYvSvEK7OioUfr5FLkJw5Fsliq4CLNTB60yCWFMUuun8/zkOCwltYtsqqcqVfINC1srwnqM/DUF3sUPyv8ZO8VIBDE5/iMrfzT3ARRfTu/d18fzNgxPaWxWe+mdCPbIbpG2n2A+PEAv+KpqJvOhwtDHsG5h9ick6cB7K3PJkgmYt0HIAeK6qw2RvWPbB8JfYDnssTJ5XKf78wBiGEEQYRgQHhJdIMA0DpAPrPStom/cmYbQLLt9ST+0bZBqdA4kcZbAbBaRJBpJSRlJ2lLaEdU9ml8SK+HEw2a4iFvlsXfOmjO1iDYIOFUOp9zSMkH5AdSENpTdR0uBDpNu8qOhdjHncNy36kcrC3JfgXjmU84GpXfXPNRRuJnO/PH1gCVSuFTeM6PYFqjk9a9PpBk0S5Oh+2gnlUSD2ctR8AObEg21OyDS1fcBx6x+USnCUMtazOgKwwB/dM5VXO+RrFS1HAvQLy8xFiqL86nJgph6gYtb0xvGR6LzRX+yNqcGg94rNmLc5S0VeiCjaWeAgwt8UKgUSEasuj73reYacUrER4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(346002)(366004)(376002)(39860400002)(451199015)(5660300002)(7416002)(4744005)(41300700001)(66946007)(66556008)(4326008)(66476007)(44832011)(316002)(8936002)(31686004)(2906002)(36756003)(6486002)(26005)(53546011)(186003)(6512007)(2616005)(6506007)(83380400001)(8676002)(478600001)(86362001)(31696002)(82960400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ymc0ZWViQ2owTldjYVhJUVlDOUdEV2c1NFhyT0dyNzQ5ZUZqNU1OUXd3RVhF?=
 =?utf-8?B?aWRTWTRVRzlsRUU3aVZhSHBxSWNsS0FlVUlja1Ara2NOeXJtaXVYODdqZVh5?=
 =?utf-8?B?NTQ1WTNYYjI2dUpoa2hodlpwNy8vRzJSRVdOWEtOK2lzUUN3aUxwTkE1N0VS?=
 =?utf-8?B?S2o4K21mRmRpQXpYb3VsdmZPMExQVFFRQVNrQmtUZThLVjNVRGN3REVveEdv?=
 =?utf-8?B?VitjRUhLbmd4elJoNW1qSmdkVHg1RzNGc3dzSkc5bG9DRFVkSlhRUXdIUk4w?=
 =?utf-8?B?TzVWdlIwUDI2amF1bWg1YWZVaW1adXQ4d016SUtHRFljUlJVNnZGcllxalRn?=
 =?utf-8?B?ZDRHclJ3S3FnMVdEcVJNbXBGR3JvWGJhblVkQVI4aDh6ZExiblhwSkZYd0lN?=
 =?utf-8?B?Zi9EWE8vandXVHZNdGhkUWV5amM5OFpFUWN4bVYvQmNxZjZIOFo0eFNuTTQy?=
 =?utf-8?B?ekNuUm85V29qL0l4NEUzRHNYc29kZmRsSEo1UmlaVGNvQUMyUTgzRU5yeTlL?=
 =?utf-8?B?ZnoxZDV0UGJhaU54TzlMWm8yVmlLUFAxSjQvZnY2MFZGa0F3b2UrblZqZVRn?=
 =?utf-8?B?YkFyc2k3UUtnejN6ZVJxRVN5T0pwakFCQVRGNjZRVVYyMnJVd2V2YXBOa1Jn?=
 =?utf-8?B?aWJzZTJRUEJYcEN3OWxrNWlzTk0vZS9JVHNlZTc1SW9RRUtMeXhvV1Q0b0ll?=
 =?utf-8?B?TXBEYzZEZkF4Q0g5WGV4QW82UURnUUdyd0JWZ2pwbVR2OHZFbDcweXdQUjhG?=
 =?utf-8?B?eVZxK0ZWZ2xIRWM2UWgvMkZ4Z1FOZzBGSERIVXZ1OWI4M21yZmh1MWRxVExR?=
 =?utf-8?B?ZmFNaHk2Tm1GN1JZbytkeUY3amlCekRYUFIxaStUNm1CUks3RHc0RU5USVB1?=
 =?utf-8?B?Tzc3QU9JTXRTdWdWREd4czRwMktNOHJSVmJoaXdoV3ZYcXlUc0hiTTUzeGZU?=
 =?utf-8?B?SGpXOUJQb21YYmxsM0pzMVdTTGQzVE0yaWRCcUV6aUNuaURBMXMrSGtydGRa?=
 =?utf-8?B?T2tHbDFhb3Nkc1lYVTBJRHE5TWhrQzNMbmQ0Z2lZeURqTXZlbS9jK3gwb0to?=
 =?utf-8?B?Qk1malQyZklsTTV5TTNRbGhjalFMMFhHa1RNRTB0ZTJQNmIvMlA2WHFqc3Fo?=
 =?utf-8?B?cjdmaHpnMk5GVWJ0dEtYbjZOaE1vWmp6RFBIbksxblJOcE42K1NJQy9XTm1J?=
 =?utf-8?B?dytZT3JuSnpkUGoxT0Jzc2YyMndEV3o4SG9NbytNYVg4S2NyYnB5eWFlNEZK?=
 =?utf-8?B?NDZ4dlkyeEdYSlJMMHNZY2RQU1hERjk5TURNaG1JVis1YlkxM3BOSE5lbzJ0?=
 =?utf-8?B?Z3ZvaWRZdFJ5Z0R1NVczV0k3MWZUOTRhbjdaa24zdFMyeHpjMVhLRHdWVCtY?=
 =?utf-8?B?aXEwbEVZR3V4dng2cDFqZHdvVWZLaE1pSGhRNEtDZ2FpUU9WTU5hczMvN1Ra?=
 =?utf-8?B?d282bm85L0dSSE0vRCtpNGdFNEpHWU5RUElYQXlPaXU4T3IvSDBVMXF3M0M3?=
 =?utf-8?B?U3RhUXZzUEhoWEprNEU4NXVodC9jUGgvOU1DTkxvQVkzNkNIcVZKeVorOE9X?=
 =?utf-8?B?N1Z3Rml6Mi9sVXhNS0FFbzJJWG9sUGJJelpEOXk1ZlZxUXVzQzRiVFpPS0ph?=
 =?utf-8?B?STh4LzVnbFVXNUhIYUQ4ampqcjRqeUhEd3FKUmk2T0VOK0Y5U3FJNjZPN0pZ?=
 =?utf-8?B?TDNFSmZEYlhKQ0k0K0IzREFGeWFLTFBGNEQxemxDOG96dVZ3SDBhM3I0WEda?=
 =?utf-8?B?ZEUyOU9WM1BYZ0lLczBkUmVxR09Hc0MvUE83U3FBaXZMVWRDelNPbVBsa3Yr?=
 =?utf-8?B?UTFGa00xQkMyVGJSTERCOEwxSHdrSHUxNWhLMDNjYzJNMHBodkpHK1A1T1VQ?=
 =?utf-8?B?UFQxQ09rcnMwNHp6eFU4OUZ5SkdkS3NrWHlMb0JPVkxuKzJHcy9LTWNxTWFF?=
 =?utf-8?B?T09xLzQ2TnZna0w0d24vd0gvYVkzTWRyZnNzekk4a2JrejdLb1RieWNJQWln?=
 =?utf-8?B?eVRzbE1paXNjczhxZlhUWjJOYmxiOTJkK1JWN0lXYi9zdXRnVnRCVUE3NEww?=
 =?utf-8?B?U05GNWZVZVYvKys5RnQ4NVJoQmhoaytrejRsWlZ4WjR3YjcxU0Z4RFJJUUV2?=
 =?utf-8?B?bkIwcWVGcWMrakZWSTk0ck4ydFp2YmRFVHRYTXRKVWNMWWwrUzZTNGNwZjdG?=
 =?utf-8?B?NWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ddfa8e18-57c7-4fe9-8ab9-08daef46aa08
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 18:00:00.7500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VznK2SGbOv2Jbn+Bq9u4ab4Wspd8b+/KIr6mzUWhOJ54an4HtJbmbHnUn0QPOb9mBBwY1CvKOTa/KJSYF3OetDusypCuTU9LK8w5fi8Bx6U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8166
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/2023 7:41 AM, m.chetan.kumar@linux.intel.com wrote:
> From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> This patch series brings-in the support for FM350 wwan device firmware
> flashing & coredump collection using devlink interface.

Your series didn't seem to show up as replies to the first message, 
please fix your git-config and resend. I suspect you're looking to 
change the format.thread option to shallow or true.

