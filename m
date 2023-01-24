Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11B7B67A5B5
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 23:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbjAXWae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 17:30:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjAXWac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 17:30:32 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213796EA5
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 14:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674599432; x=1706135432;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XANAkVEYtKSc/MVH18KZikIYaMqDWBCXeE0IDmaaO7A=;
  b=P3TgLa0+d2uXTc9BNiXO5PWnVHG/3PE1WMcM3iPQBLv98pNr4SbYeYqv
   G+zjoXWd1n4Eu7gnK0kq272UaoSw4+/+8f/5F8sMW5xiVKMRgR8xky8VJ
   YKhzk4eXcJC5A1HLqs4M3BCoRwrLJ+Es4paKy2W4NYBRMw5VteanbADg8
   J+y5xQZCBU4JEvsNQsj+zpHBvGEQkIv0jOozgWqXv8AdYAApYVyVgyWUW
   YSnTL2OyXrpJNLto3nGx2iauo1i8F4yeADMTf9fVbalkW9msqhwqKILyp
   LTaNvwOkaqHBmnxGnQ9/KBDbk++EsDStaXWJvvkl8Cz5KM/wshpwATTCV
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="326459987"
X-IronPort-AV: E=Sophos;i="5.97,243,1669104000"; 
   d="scan'208";a="326459987"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 14:30:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="655591475"
X-IronPort-AV: E=Sophos;i="5.97,243,1669104000"; 
   d="scan'208";a="655591475"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 24 Jan 2023 14:30:29 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 24 Jan 2023 14:30:28 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 24 Jan 2023 14:30:28 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 24 Jan 2023 14:30:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVuvLB57q7JrRKCF2yTwdDVtmZ8C3fzxf3LqJHyyGPeLgq0WAyOpgvwDTTDBm1xqQ3Tzp1rvBiFGi+VsDREnhtyzpB1DH0ubB+7m8m/7BSo8imWGRVjTDZJEZQ69+pla8BQr9Q6g9+OPYvjJznydO8GGR659peKkJNl9XiqRGnIkavPWl/pHyXqmeQd2tMAfnr9Geq0B9COx/ACvLvGqGGus98Y8rs82ooCZaqrpNYGbev+47tr1yFSraDB/y214XCf5KxqwaGtkBhTUlFbTFQ7uQ94LjawBFfHKn1pq8ZEMN2vo7dPakI5DZcn5b6V+qAwNToeamqwVrj+9jSDrHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AMlAY5JlORyzS0Qme6jncmqfnkeDkPVVp6tQxaJh2Uw=;
 b=FAQ1O+LShAJwjgse9Y5h0p7Opa5LHazrWfhaZY+5dH+ICxo7qLLF2fOb+UhkItUNUk3aJ+oOQ8A6Dyi9MzKJj0ngRJe2mS5HfS24FaJ+ETKonP4ZNKXhD6P03FxRwTdMfc7CZN/id18aPtW1+3hALLaBXMcp/WDogwZyekdCTZUfsZFCavN+2iidOx53upGVZu694wQpN36nwef1yAwETszOa7JontN6rCZu64TIS5XCdo0xyeKvVCCRli6hi0mLz4GifXGhXFoN9PXZ6PJTrY9jq4jj+5Bw7U65u2irnfRFUFv5ySDjZdl/9DnUsfvHOpmu2mv4dQiJHQq6CZnspg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM4PR11MB5471.namprd11.prod.outlook.com (2603:10b6:5:39d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 22:30:25 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 22:30:25 +0000
Message-ID: <5c39452d-e96d-a1d3-832d-c9f8dcd3902d@intel.com>
Date:   Tue, 24 Jan 2023 14:30:22 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [RFC PATCH net-next 00/11] ENETC mqprio/taprio cleanup
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     <netdev@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Claudiu Manoil" <claudiu.manoil@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        "Kurt Kanzenbach" <kurt@linutronix.de>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
References: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
 <3c8934fc-c783-11b7-a2a3-3e29b544d5ff@intel.com>
 <20230124142613.avrrz44lr4dcqxc3@skbuf>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230124142613.avrrz44lr4dcqxc3@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::14) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM4PR11MB5471:EE_
X-MS-Office365-Filtering-Correlation-Id: b599b2eb-3231-4e78-8247-08dafe5a9658
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uXky2tcvn8W2lnx2p1vFHb2Ts8kJrKCMLT/mc/UEraxwdy/FO8epXh4yUQ9ODl+YhpkE6il13xjbCH09uSg0FtHeuFCvYGP5Zx2LNMhR83pmpHi79RydRyJrTjssm1uyzG72ZIp5J+tX0b0caFFZNbsQzVS7ABeFAikGtPC3PHwHnzR4qQvMx7/nyIBkswzGkwFimE8aqOMes3fmz4kCECRV6HQAWU4y3gDizH9ue6QKqBSi6uGGs7jc4ju67XGQn9nPC5YLMj9W0ti3bj/OXFfnO7UfUP0TkRaqJM9v1ftKzk82oG7S7KCt4yChME6sW+IcCXKqDWfiRs0Zus11Hc+vAZYQAEZyOXWor5sK77EpPclqsNCYNbH+mK+iIQWSWQePJL671uT1m61xyFUUTSEB0fTBRBs+ycoim8SBXjUnBLke1PBJnB5LFKvJijuCajoOcI6A+ve6WMIC5Vu+RZvLXhJSEVVv2GtR/mKho0Keyzn7ma210nrajX7WMwDKhLsfE2Y2zDtgSP+pWslrUISIcZngtBchxDqaoET+gpR+D8c/rDljhoEGe0pJDiJ4uZuk9g2DdJJWO0QtWMEiQwmVManNdZNGh0wQs7KyYCPrqvxO7rQeSKa18HIdJ6P8CfLh/O+SsNKlBCic2kpJaADPuXZz7moRfHlAWSnikU+lXt0QrgVZJwe7nXGw4HX0MJNeqpg0k0bzrHuiZ7loUVkFosnT7KW9fSSPLNovkps=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199018)(8936002)(86362001)(36756003)(7416002)(5660300002)(6916009)(6506007)(6512007)(31686004)(53546011)(26005)(8676002)(31696002)(186003)(6666004)(66556008)(41300700001)(107886003)(66946007)(316002)(54906003)(4744005)(66476007)(2616005)(2906002)(4326008)(82960400001)(478600001)(6486002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MnRSd2Z2cXF6ZTVOOUhrL0VTRk1KSnU3bTl6cXVKK0VUcktnbU5RSGRUQnJ2?=
 =?utf-8?B?aGM5UW5CUDAvRzFwQXZMMHNjeXd5cy9za1V2V2pPS0RndVdSbWorWUJScTVD?=
 =?utf-8?B?d0RtaFN6STZNWENPaWx4MS9sdjFBRzVpSFV5SUs5bnMyU0U4Mm83Wk51SHdn?=
 =?utf-8?B?eXhNUG1XK0Z1MnkvcTlXTmxoKy9iQUlDSVhNME9rWUh2c0theTlHMWFoSEsz?=
 =?utf-8?B?bkNNbTQrbmwzaDYxdzFYYS9YQkNvRVJqSE5TZFJXSDB0Q21rZHUrWGI5MDlF?=
 =?utf-8?B?NVpiNTc2SXEwY242VUFtNjBRQWdZUTdESW1hVFVnL3E0VTZmMlZ0WGVhSGtV?=
 =?utf-8?B?Z0FQUGtJZGlTeWFaVnV1WHR4SUtvV3VOYnIxcE94QVRtaEwyN3VLNDZrdVo2?=
 =?utf-8?B?TFExK2dnQmVhNkRScGIvejN3YStudklnYmorSmZzWXB5U1h2QlM0MkkxcmZL?=
 =?utf-8?B?ck1sdXRqcEYxTG1iYmNSQkdNUUFCZFZRVGZZWFRXVE0ySzdxTkljNXZtcHlt?=
 =?utf-8?B?c3hrd1RHaUVsZHllRHRmV3NuK0M5Z3NZRVhhWlNFSFJrbnZBL2hYQUkrYWVI?=
 =?utf-8?B?T3JZMGpuV0lJZ1Nyem41UVZZbVNTam5CLzZwSGRpaHhHSmgxSlNCMHM2UlRy?=
 =?utf-8?B?WUlpMTZRdjg2Q2hFaUFOZDYrdkpBQWhCd2U3Y1JYYUhqWWdIZEVmaUs5eXpQ?=
 =?utf-8?B?M0wyRm1hU1F4b0tLQ2VuZFFUWXBaL2ExTzE0RjRrNjBsdWg1VURHbFlJOU5I?=
 =?utf-8?B?dE54YzA3QnVWbkdLVGlqaVBlTHRianJ0d2ZUN1hLemVyZ1Z3SVBOZW1XemlN?=
 =?utf-8?B?OTB5WmJZRTJmbDVWUFBOVXMwVXJaOFQrZXB1R1lsS2xONGdkQUpreWJmTUVh?=
 =?utf-8?B?Q1RIOENpQXdlQXE0Y0xoK05WY2VrYkpKT0c0WEd5aDVVcjVOMjFjbThvRWUr?=
 =?utf-8?B?bTFsSDlsSmloWWFhVTAvWGNERWhtdTZsc1RjT0J6WXcwM0NGRVRON28zeFBq?=
 =?utf-8?B?eUpaY2kzSVBXb0tJalQ2TDZtZUpaS1gxNU5wenNUUFhrVzZIaVgyMjY1Rkxj?=
 =?utf-8?B?MVpSQlJYcVFMN1NBT0s4SHlLWFpndkhkN0pPdjR0bU85bVRPTi80bW5HN29M?=
 =?utf-8?B?UFV2bithR3VoVkQ2SnJIdnJsYXZPZFhWekNhQTc4cjJ4VFMrMURjME93d2kw?=
 =?utf-8?B?TzBvV3VJZGsvUnNKQzFuRjM4VUNKOVFzWEs4Zm1xbWV1cmh1bm1wVTNjcitQ?=
 =?utf-8?B?ZW5RVDhxdG5aQ081OUpGUVZyQVd4Z0pWWW44ZWZMMVMzSlJiVW82UDBFNFJN?=
 =?utf-8?B?QUdrOW1mVnNoQnNrZmZ0MzZ1VE1QcW1EbkhpZFpCQjlPalVtNG16bzhYeWQ0?=
 =?utf-8?B?M3ZDcDlLSTBKOFZCR2hyN2RHOXlyekQvejB1eTJTOGduYnc1Yjh6VE1EcVA4?=
 =?utf-8?B?L2xUQnY0V3Y0RGJ1OGJ2eVYzdTAxZ2R3RU1iaVdDWXprN1pXNi9WeUV6dTU1?=
 =?utf-8?B?a2pxTUpIenJ4VHJ3TjE0K1daTWZPNk1kNTN0K20rUnV3WjdBZzZQNm0yNkEv?=
 =?utf-8?B?d3VpQ0VGWWpmQU1GN3lOSzRPTlJlYlU3V3cyOEFmN3dqWkdCQW5XRWo1amNX?=
 =?utf-8?B?OVpycllmWFdoU1RJU3ZoVWtibWhrK1FBTzN1OGNmcDZrZXJSL1M0QVBhSW1l?=
 =?utf-8?B?T2Zmb3dQWDlmK0ZIdFRYb2dCdG03TklTT2ZySHRyUDRYZkU4TkZvdzNvM3Rv?=
 =?utf-8?B?dVBRU1pjUkt4Ni93cDFDVUhNRVRQNGJ1ZE9HNUFyRmpZMG5FVFltSkVrQnZQ?=
 =?utf-8?B?WHVaTTFPSFJWdERZc0sxR2VNME1tY2hoRW5xVFhkK2M5Tm1IQjNGdER0OEM1?=
 =?utf-8?B?L3I4UHpNT0tvcFdFVFBralY4dDFxcXhBWFVvc3huZno0NWM0aDMzRi9CdExl?=
 =?utf-8?B?cDJ1SXZISG5PZWU1bXdzWDFsLy93RXcwZGI4N1NWQ1o0VkJhdVQ1QXcwNG44?=
 =?utf-8?B?Qmg1QVp1SUlvZWlrUXFFRWg3T3RCUE9aczROdEJVaURsK25jSUEza0dWb3lM?=
 =?utf-8?B?N2d1UjY5Smtydy9WclZ1WUpQN1lKNVJVeEJFZXZBbC9aR0pyL2tuM0hNazE3?=
 =?utf-8?B?Q0JNaE5CV0xDQXBtdGd1MVRsaFRaeG1zN0xXTkNuN0FEVGlZaGs1TnU0MmNX?=
 =?utf-8?B?Rmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b599b2eb-3231-4e78-8247-08dafe5a9658
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 22:30:25.0959
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3xs8ZMMFi6iRqHj5wzkSA6Svqad18pz7wuh16X8hSTWUo6du6H90pVfM6p06jC3qzuWMDpk6f+L4KtRdgYZVXCOAk+K1pi6sPbmVotdsyg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5471
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/24/2023 6:26 AM, Vladimir Oltean wrote:
> Hi Jacob,
> 
> On Mon, Jan 23, 2023 at 10:22:08AM -0800, Jacob Keller wrote:
>> I don't work on igc or the i225/i226 devices, so I can't speak for
>> those, but this series looks ok to me.
>>
>> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> 
> For clarity, does this mean that I can put your review tag on all
> patches in the next version?

Yes.
