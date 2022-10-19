Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39F946051F3
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 23:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbiJSV3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 17:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbiJSV3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 17:29:06 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BEA7192D85
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 14:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666214945; x=1697750945;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2PT+j5+HGspieZdTt7CEhYz3KFOIwHNegk+y8cGqDhw=;
  b=PKKupFWQkUrcN4QnfOt2lvLVZfz1rtm3k3nP20Ctlz6Tupu7YtwuGtaU
   NV6qUBbeUaXtI6a8daU+XnCv+7A/31ViU6vVTA9b24xEjeN/oczIj+tQs
   Z918EcysljrzPXrmUr6fJXrq3TmFdtjMHbJ0q0sVpP0QS4pxG6vrqvUEu
   AhYqaefJA2bmkyIzeBmlYCdUCWKmoypoijAyhD99DGEhzYs+JsXE1p5zJ
   Mv+jDcrlzWe+7PwjGbBthCfm29aYoi/3rKJ9BeGlb/0FUSjA2QxKyMT7L
   9ehd6tGTDuMjNMUPrrE6MAFTT848BPFnvlkC7aW4XvU13szuOeEkCVo9o
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="368582446"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="368582446"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 14:29:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="629447141"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="629447141"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 19 Oct 2022 14:29:04 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 14:29:04 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 14:29:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 19 Oct 2022 14:29:03 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 19 Oct 2022 14:29:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ntmJAcnz5AkmJLc3hi421Ab5f9MaXpCIPTHEkFvXns/Nt5rUzzj8uMlAjdP9qw8KF2FO+N5uViphj/43McDi9JOGGYmk9Q4nSlmK47riflvTJuTysnGTLpWXa0EqDsrEuHVf4edHdTygluCnSHkOQQFx3OP2Iq4iYTqzA8ka3SqSbMMnSpBriyYEJdzcT5xr8Te/gf0gL7g4VPfJrY0D0zrInK6M4SugldET5XO1X8EDzHY0dIEU6DFDeBnpbwuUsEUF01NORS1E6Doi9xBVttZd1+3bCB7HobhiR/k8ePQgsE5fB4JHr4t8sxEvI080idPaWmxn02AOoNyKBAlz4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=os14+Zm9puMpdSk1LIt0szTp5KhCkre399mrMeYOBJQ=;
 b=IuU+1ABKy1JUjIOTpyydcZYxb+nR4QQrbGEvlHWJaxNPcmmYkKHeiThe01mjTq9wJYZfQMsrs0INwuIZ/MTBVt6KWMthUjg1P5HR92ocmTLlm0k2iexmzAQV2XyRs5jh2zdB4mejpBECeIYtsXwy+DP9M2tRFlYdLe1D0mAgh0P+Lh77/KiDOiRFVbwo/lzOzkPOFFOFBezKsMhgfVpRiCuudoXreokOFQP0TNwPUcEkMAt2irLLad8/sKwO6udrCGJeDkdgwNt2jKjA8ZdgH90Xq7300c3LXUn+AG6J9FucLngM2qRrdTXUjlADYtv7HKamRc1Bkpueyqw4mrVfOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by IA1PR11MB6490.namprd11.prod.outlook.com (2603:10b6:208:3a6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Wed, 19 Oct
 2022 21:28:56 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf%7]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 21:28:56 +0000
Message-ID: <3e0a966f-f11c-6439-5c8a-738979e74b27@intel.com>
Date:   Wed, 19 Oct 2022 14:28:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.1
Subject: Re: [PATCH net-next 03/13] genetlink: introduce split op
 representation
Content-Language: en-US
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <jiri@resnulli.us>,
        <razor@blackwall.org>, <nicolas.dichtel@6wind.com>,
        <gnault@redhat.com>, <fw@strlen.de>, <mareklindner@neomailbox.ch>,
        <sw@simonwunderlich.de>, <a@unstable.cc>, <sven@narfation.org>,
        <jiri@nvidia.com>, <nhorman@tuxdriver.com>, <alex.aring@gmail.com>,
        <stefan@datenfreihafen.org>
References: <20221018230728.1039524-1-kuba@kernel.org>
 <20221018230728.1039524-4-kuba@kernel.org>
 <93e9137fb80f63cd13fa226bcca3007c473a74d4.camel@sipsolutions.net>
 <20221019121422.799eee78@kernel.org>
 <e5ae37ae75bac9af6d6a7c324acd4e3c97059d50.camel@sipsolutions.net>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <e5ae37ae75bac9af6d6a7c324acd4e3c97059d50.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0134.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::19) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|IA1PR11MB6490:EE_
X-MS-Office365-Filtering-Correlation-Id: b50fcf50-411a-4233-be36-08dab218ed8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KIHdfm8+FvWUVRXBwHUVRgtiiznNL+GWmckDZP66GsOTKpDEv4XKCT2NtkeELGbbv/qrOH5Jf3kG+wS97pnnyfPkRVdeV3AHX8YtuYKzVVYYXoneh8BImquCBL4YSy4GIsTrZzJCHIQoiXrpdinaxNOSokGkBTlngDsvd8W7Pxxqy36Tq2E/YkdDMbkykAV7V67lx6P20EwKd7QIswVs8JmtWI5UirPf+rh8EI927V609ftq9Hp+H4WOcO815l3hurEwOIm19RNCAyVWVciSBX/s6Pbhxby49YWC5kJeGYL7Djs/EPyjUTLR0vonQAa9NOr/C6SB8SrGcRceJhpqyqxzQ+iz/UQYqRxHvXnGoPVro6PJS6Q2EV4FnmADN4Cb09pR0PPasmJRAV8jrpbrCClSPIaUYlPRdnV23CdY4LvEiNOTAnDRJnuYEMjDLo3HcTgfbGQNoGG3Zx7rn8afYL5875NViPhfzow5xUtDlaqb6RyIGMc85ti7MTtz/xymY/zIMjvoeyNt9d5hMQUc6Irgij4j3qaz9TmnczgD04MfFfaf3GPL7qhFVBzIq+WbLv3c2Vh11TpINpBC801RYKRspmHXy86xKf5+3sKju2d8IaDyAfTIKaDzKVC1dupRg4+uYJ+Pc3e27UvyzuRu1xWN2Vre8GTjU5EeBSEdp/gQFyXnIr6Rk25QuRW2ZvQpJI85kstGG4KXksF8hMUATk0FIvp0Cnz+7b5TK5hJPt8Tini7OdNi5HWdaT4FRVj2ln8pHjpmSi+ox7AIR1QY+Uaz7dSptueRknk8QHGeu9Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(396003)(136003)(39860400002)(366004)(451199015)(86362001)(31696002)(36756003)(31686004)(38100700002)(82960400001)(2906002)(4001150100001)(7416002)(4744005)(5660300002)(6506007)(26005)(53546011)(6666004)(6512007)(2616005)(186003)(66476007)(6486002)(316002)(478600001)(110136005)(66946007)(66556008)(8676002)(4326008)(41300700001)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U3ZyRjJBWGFlaHh5NUlQdWpMdE10UXNseGR0SFpEb2hhcDJWd2R3QktVUDhj?=
 =?utf-8?B?VUFDQzBxbnN2dHdXS2Y3MFFacWtORDBWTGVoUlpvakF2QURSZWpJUS96Mzl5?=
 =?utf-8?B?TXJBODJueWxGYVYrWUh1dThOV2lLMHlSUENzQUZHZ281dm9FY2JRT1ladHZn?=
 =?utf-8?B?UWdlSDJybElvd0JTM2hvQStPNnZaaE93N0lkU2ZwRmxIUUpEUThWTXo3dEN4?=
 =?utf-8?B?Z2lMbDVhVXpkamNVQmFaYjNWTzQ4SnMvcGk5eW1vY08vTU5KUEtIdUszMnhH?=
 =?utf-8?B?eWZhdXlZbGRXY0wwNXYzS09CbytmMXhoVmtMd3Z4QTRoZ3ZmTGlRTnpYMUhn?=
 =?utf-8?B?Z1UrZVdsaEJCTnpqN2tTY3NqV3NvUjJLMmhmR2VYWHBXUm15eGpqSXRWUENo?=
 =?utf-8?B?dkNENDFJL001RXlaVFNZL2tlYmRKdnFGbDZkRHk0QWFUV3FNYnZaWEVUQmNw?=
 =?utf-8?B?ai9WQ1N5Y0tua3E0ZFhoV1FNZUJMUFAwa3NBdSt4NE0zMVlFTDNVVVh6OGYr?=
 =?utf-8?B?Vk1DN0xVLzVHaVpTbHpicW8wdWJFYUFLMEVYV1lPYkliSGVuaUNiaVUvNitR?=
 =?utf-8?B?NVZKa3ptSUxsOXA2TkFQWFdKNWowYW5ZZ0NzMXUrbkNwWHdyN3RPTXVVVk1Q?=
 =?utf-8?B?RXk2VXd6L2dpeUlCQ1VYdVFSOSszUVZEcFhRdmJWZmUyVituYVp5cDB6ZWIv?=
 =?utf-8?B?L0psVGNoTkZGNG9IMnNQQzdPTnIyYTJOMjM2KzhxUWpBN2NsY0d1d3QyVmRS?=
 =?utf-8?B?VkdJTi9CZHVjNkEvcDU0SCtqZ3BpaWdXY1QxdHFqQ3JZN0tpT3ZsZjFOdHhs?=
 =?utf-8?B?SlNBQ2pBeFYrUC9RMlFtTVhUUFRsditVdlU3MGIzeXhsR3h4NFRxazBxMVpW?=
 =?utf-8?B?QjNIdUZIcnlibUFIUmJLbENVZjBncThDNjBiRUpYSlpzUExRUnRPK1dobmlu?=
 =?utf-8?B?WnJhZ0NicGlxRUxZZzJqOEY5OTRwbTROeHF6cTF3Y05jdGtTbEY2OE95NzYx?=
 =?utf-8?B?TkVHN3JHbXllMFlWcUxDay90OHdzWE8xNkM3TWdKQkZCYVl5cFo1QncxODdO?=
 =?utf-8?B?c0I1bnVFdGxuTllCNldJaUliN1U2Rkd3OXZJSEFvS3g0N0UrRFpjcVZ1Q3Z5?=
 =?utf-8?B?aHlkdmQwYy9DT05OVER2S2gwQWpnendGbTlmWXpVYTBQb0NNeTduZUhiUzl5?=
 =?utf-8?B?MXRoSDdLYWxkdE9oTlRuRXNIb2tQajBiYmE2WDhnVVdYd2ZEQUZ1WnZENnlC?=
 =?utf-8?B?L3RhdjBRMHdQQXk3UnV6UmxiV05LSW9rYmxGQ2xGb21jSW5wL3M5UGJIYmIw?=
 =?utf-8?B?YWJuTUpNN1dFbnlla3hEZVA5TVlqdGxNeDJwRnVDVkp5OXlMdmU0VjdSOTlq?=
 =?utf-8?B?aFYxZ3VrR0p4byt1U2NUQm14SWx2dWpocEUvYWFxbjFyWW1XUlBPQ3VoZUxW?=
 =?utf-8?B?aXhVbStXN3JJTHBUTG1pREdoS1dxNzNpd1VTRHd4UGJCNUR0cVZhOEc4Q0Nq?=
 =?utf-8?B?RnFxK0sxQjlZSFl1VlNRb3JYK042SUJ4WHNiZHMzNitvaFRTNWM5ZXNZMEFS?=
 =?utf-8?B?RGppWk5JYWpieUJJSnRpdThiWGFvcTlKellXSWxBMGREanpBa3kzak9vMVFR?=
 =?utf-8?B?Y0ZKSVBFd01GT09lZUh0YWZwYkZ3cmlBNWM3VFM1V2x1VnRFdGJ1eEQ1WkY4?=
 =?utf-8?B?VnhET3FyR1E1eW41TnFqVmxtMHQrdExkZnpianZLMDN5SnpQVnNRT3IvTDJK?=
 =?utf-8?B?dklsOUZjd2RhdEN0QXh1c0dGNnVvY3dZWlkwV2FaSk14TzVFNlV4bi83YTAr?=
 =?utf-8?B?d1V6OFhuQVpNbVBlWk0zU0JCT29KOE95S0FOTnF3eW14aGVtbWdOMWoxVUpp?=
 =?utf-8?B?Y2ovejQxV1NjakhaS1BYZ2dMc2dML1lESEhEK21SK0prUHJ2bFhvL2orZkZH?=
 =?utf-8?B?ejl0WlU0dEhsaEtnNExJZGJWVmphTWZKLzd6ZUhqbEdPcVJZOGtOZEZ0LzlW?=
 =?utf-8?B?dE5vejNyMGhXSTNIWUJMa1Q4Z2VNWjhZdHA1OXBEYnJjQTkwYktxZWIzNnVP?=
 =?utf-8?B?QXRsRElrN28zZFQ0RE5uUjhOc2FDZ2svbi9iZFVqc3RjSXF4QndtTmtjaGtS?=
 =?utf-8?B?aDdqOXBpTEJjRU84Sjd6OFhvNitoUWkyTmVISklDT3dlay9mb3JGNXhLM3V1?=
 =?utf-8?B?bkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b50fcf50-411a-4233-be36-08dab218ed8d
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 21:28:56.1732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gaxEkj1ya9Nm+xMrNGFt/7pSvhkyPa6vWKrily03JQQ+vj0Y//rUPgX5TaEwLRrf8BkpxYwllIuEdaUyD8L7MdFTX5dQDFh/09n3Cw6pzLY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6490
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



On 10/19/2022 12:36 PM, Johannes Berg wrote:
> On Wed, 2022-10-19 at 12:14 -0700, Jakub Kicinski wrote:
>>
>> Yes, we have the space... I think I lost your thread of thought..
>> Do you want to define more info for each group than just the pre/post?
> 
> Nah. I guess I was thinking why bother, but anyway we have the space,
> it's easy, and it might simplify things. So yeah, makes sense. If we
> didn't have the space anyway I might've argued against it I guess :)
> 

One could argue that we could use the space for something else.. but I
can't actually think of anything else here.
