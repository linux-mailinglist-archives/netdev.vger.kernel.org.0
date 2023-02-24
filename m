Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAFBF6A22AF
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 21:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjBXUBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 15:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjBXUBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 15:01:10 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BA814992;
        Fri, 24 Feb 2023 12:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677268860; x=1708804860;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=R464gm0ffs4LWyttThlZVFCJADQO6aW5YEVey9DH9Jk=;
  b=V3TDguDfeLEdDcr/ByDhLTSYeyHPiRGu6QLeSuZWEzGpohzR+9K4BejM
   O+NkHqFtONkEtbPh6GIX29HhCdxAxV3Pe3nMhJO0HKzYQFEi36Jz7bEqu
   DRXWdpCiChLYHHoEnYT+FJWEsmi0/uMK+qM62X1T8aow/gNMyJoFXLyIf
   DkTYyn82xkMcBRV71pQi2Z3/UdnrA37NP+Z0Rvqw/2aaJSeS6xniOhAvS
   B/ZfKjfAv6JLmw5pit4cpBVDFl5XU6A3UGAxAqt1ZRpEqRcluCtwqUuQU
   BVG68SdHcvDA8lGtkj2+m689yL21f3g62d/taFBCMHDYmm5eYM+mjO72m
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="313205390"
X-IronPort-AV: E=Sophos;i="5.97,325,1669104000"; 
   d="scan'208";a="313205390"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2023 12:00:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10631"; a="703288876"
X-IronPort-AV: E=Sophos;i="5.97,325,1669104000"; 
   d="scan'208";a="703288876"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 24 Feb 2023 12:00:58 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 24 Feb 2023 12:00:57 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 24 Feb 2023 12:00:57 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 24 Feb 2023 12:00:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Am/XRaUR/7EX+m1p3nLTAZHVGrPi15Bbea64rbUfko2yuME4jR0C1pp+zlLTVHNCVe1VeNfm9LrKSE1aq/Nigx4ZchtooIC636KIJiEi6e7RRMl5U8ocm6K2khasczYW9FNKoFT3xkkhHg4feHr6A++TBzxO8l6i1wGlW+esMV9bZV4V2ftOeK+GlrPP84ludGt31jUpVF+yL37FUGUqZbOcEZBq4tnxJfKY/dFJTCyZg+d4gU5zJeGC3s7cPiv8w5bNqRyWCbs4da/y50xzNgy0P5p5iHEmpVz1Es7Htnm5v5pkbS2cVevgnMjWE+mBLS7cyqDWM97m8pNx0RsCJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZzC2kiKYf8fZoxw7p/sJjBXrkdrRZLaA0q3rsWKNJLk=;
 b=oTUQ7RhLhs7giH3JL6zBPRHKduBp70y2GHte+to8r7VRC54K3KVWhm83QZcTrO7NjhG7KldjXiFKojHrKlAeRNuLO5qlAK5/elWN0oPczpN/V5FCDogB1P0gt9VjsIeChp4+pp4Y+CZXT+qd1hPw2iAgaIJZTpMCMF194hbuViwFym5ig3V79FwljTRGesS6hP8GEpbn/ZsPBPIr1GbT1JQAY2qgF5iP/0q3B/nK4TxvtsIlETckHVGOWDSwyc6bfshfMpBpM3gw/A9jE1OhrkfCKx9FVgewnKutCt50/GplFLTk2USIx4chcE6qgHbo6lLX3JfBcieYuiyxJg8J1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW4PR11MB6787.namprd11.prod.outlook.com (2603:10b6:303:209::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Fri, 24 Feb
 2023 20:00:34 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%6]) with mapi id 15.20.6134.021; Fri, 24 Feb 2023
 20:00:34 +0000
Message-ID: <6f49f758-114b-3955-ae3a-6ea0ee19137d@intel.com>
Date:   Fri, 24 Feb 2023 12:00:31 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [RFC PATCH 0/2] net: netlink: full range policy improvements
To:     Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20230224124553.94730-1-johannes@sipsolutions.net>
 <20230224105550.7077a674@kicinski-fedora-PC1C0HJN>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230224105550.7077a674@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR20CA0023.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::36) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MW4PR11MB6787:EE_
X-MS-Office365-Filtering-Correlation-Id: a74a9a23-808b-4d03-4a84-08db16a1c9ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DyyNhPwcvy0IO6MyRojMagDxkAz4wH7crvxPKtB1wh38KMs2MqCYiqe5C6HZpLmH3OqVDTnvaanUjBeIZtzvUwzEhJWGpHdPHZrE2rn2H8dOKSGxgfmYw4SSUKSNvxbYv3bN1GqihIa5g5SuS5bnsbQ/xEk2ae0Jxo5EeaBD+vt8T8wh+hKaGcAzCv41R50twB2DcJ+C7LrqLOr2cKq7ozzqsG24x19s5uHfk/4FiTkPu2Ywi518UWeVbjZLo4zYtQ5EXAXs0xg0Fc36my8JckW5oVGHlrlgyNIfb8XTjb5f32UDV9MT0hU4p8gIjMD6m7w1vYAZIb9wIGDE7HVRqpLSfbja2OyGR0DN/MF2N/9N+5l8Cog7i17YsPA3jYkxJh8k3GDkTKapJYswM8ip6E+bHtbZNgdbp9Vlo64BcVQ9ev3bbU/XJwGIamNxTOqBvFC81gVCcCEtvh0/uaHKjrYeVl6bv6x2qt7VJb22v4jhJgcCmNcLACg4OApl1xVmzIgeoKSwUU6sJCO7vf5KFKX4vUUKTOkP7yoWKH5O2XgtE5ct8Rzkpd/BSgyZK2ruOwe2ggPv1euXDyXsJHy97lNti8t9OZpJGE4/k6FsKX9B6/jgih3ZMccFu5FdpDYxeXeXF+PVhDF0l51TiC4SbNuub/a7omCDJliCx3qv+05wNVw1EoHXbAqgwNtaSb/jM7sey2uEAMTZg9V7QdZ1pSQvmvYRQbRaeth/6uu9j4g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(39860400002)(366004)(136003)(376002)(451199018)(86362001)(31696002)(36756003)(2616005)(31686004)(66556008)(66476007)(6506007)(66946007)(4326008)(8676002)(41300700001)(6486002)(6512007)(110136005)(478600001)(53546011)(186003)(26005)(6666004)(82960400001)(38100700002)(316002)(4744005)(5660300002)(8936002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjZPbU9idkcxbkJ4RWJRbm8rRkRvTlFtL0cyNnFMVDJvYlR4Q2RxbVQzdEV4?=
 =?utf-8?B?MDdqVVdGOExmeTBzTzBxR2hUeHVsUUwzYTl5U0xhSWsyamRtd1FJekI1MTF3?=
 =?utf-8?B?SDgrRUtsWGVMMHhpNjZxVFVZcFFzTFhWZ0dqUHJTUTVCRExXVGpBWFZwWWNm?=
 =?utf-8?B?em9wRVdsN1Q1NGhYdzUxL05JTG1OS0ZSY2RISXBORkdMN3Z2d0VqSXFVbzU5?=
 =?utf-8?B?QWttbWlnWlZJZC9tRG5rOUJNZVVzMWVTQ08ybkJHZHBFVnowZjZoZ0ZJU1pJ?=
 =?utf-8?B?VmtnWk5pNlZXVG5IMEVIWEFOVExpaXJyTzdOQldUNnJIOXAyd1Nvb1c1SW81?=
 =?utf-8?B?NTJTcGptL1FIY0puWm5YeHZHYVArTWY1NXVScEM2Y3QydnFJYzV5aTVDd1pL?=
 =?utf-8?B?UjlLMkU3QUJFNHFhbjgwSk9IS2g5ckNIQlVEdzhmMnIxWG0zeExDbmpTbVd4?=
 =?utf-8?B?MVlVaXk4S291TTA4b3BibU55WFFldDN0WGJVM1d1aGtHM2tUTWdWRzN4ZGg1?=
 =?utf-8?B?YWlGMWhMTHRLVE5PY0Z5clhyd3N6blZHTjZDdUpPNEJFQ3dMS0lGSElJbXk3?=
 =?utf-8?B?SmU2azY0TEZyV09iSXhpbENaTi9mWlcvbXlPbHM4QS9Gd1lqMjVFcHZ1RzNa?=
 =?utf-8?B?U2lFZWt1VHlCcVA1Qnl4ZHpmZmtHMnlPekNmbWFGUG9IMTVXRmJubmJQKzZL?=
 =?utf-8?B?cTFIdXZvZGFsS3NBSitGRjNVVDN2R0FsTzdVd2o2NW9XTVp5a1N5UFc2Zk4w?=
 =?utf-8?B?QnJvNVVYVFpDQVJqRnNaN0dZdnBzTi91emlMcUtPeDVhNHAzLy9kOUkyUnlu?=
 =?utf-8?B?L1RTSFpMSkNrbjVRczBPdWRucDhTcVJPS3g0VXA4c3NMemk3RDJMNGZhZXdh?=
 =?utf-8?B?a0I4VVhrVkpYN01VZllLNVhwSExvMXIxRWpvTFB2UmM2TDc0Z1FBaUltT0k2?=
 =?utf-8?B?S0Q5ZnNXSlpPRk9TdEx5RVgvNnhjeU1pWVNsU25ZeUEzQ1hscEdzbjcxVHVv?=
 =?utf-8?B?Vm10L3dUa3VqZDBWbUErZVZrTlVwZ01QbHVQZ1FIaktTME8wbTV0QjBLVThG?=
 =?utf-8?B?dUZZMmFUVjdVQTdvU29WYllFNXNpNk1XMkdnQlhIbFZEMGo1OFozcXRjYWVw?=
 =?utf-8?B?b1Z5azdZdUFUYlVpL1VpQTljQXcvSGxJRlNMeDR6bk5PNGJBZ0l3UXJxNUNJ?=
 =?utf-8?B?YmdsTldVb21EbXZOSDg0ZmVqWjRKWjZkYmNZY2xNTnJkVUhsaDVrSGxydjFr?=
 =?utf-8?B?dlZ1QkNqUGVOY1NCdkJWemcwVVlZaXV6YUNZSkpEdERhZ3hGWlBiVUc3RVFz?=
 =?utf-8?B?dmVLU2dBSk4ydm1CRWxNQXd4d0d6dlJCVXRYMDRtdnlNVEdvNWxIaDBSZk9u?=
 =?utf-8?B?a0VEL3VuaUc1aHVkVEY0dEY5SUxKWFhvRXlnZ0VCY1FhZWs4Znk0OXkxZ3p4?=
 =?utf-8?B?UUg2VDV1bitiWWZudG05S3BNenl6ME5GbHpnc1pWV1NYRjhFT0Uxd2N2cUpr?=
 =?utf-8?B?Z1dNWHoyeTI5MzZxVllUMlFqTFNJN1VJWDU4WHd0ZkUwMitHLzRsWXg1N09j?=
 =?utf-8?B?UmIzeVpLUEwzQllNU29nZnVoK3ROaTRVTDJ5MFNBZXJveFphSy9ueXdsaUU5?=
 =?utf-8?B?aFJBNDA3ZkdZTHBQeWZRUGRhWEw1TEhFZVRBaHJiNnJvSFpVKzY0TVh1WnRV?=
 =?utf-8?B?TTFCZFNSWUFvKzdhQW1WMVlhV0R6ZmRjMk9odmIrRTlCZm11c3YyU2ZhaG5x?=
 =?utf-8?B?UzlkYWlaa29xOFkvUndtUHVyU05ySklST29qMmEwRnpsV0ZYNXdVR3V4Wnph?=
 =?utf-8?B?Q2VEMkZybXZwVFJTNFhNMmtHQXZWMFRZaVpDcW9pRFMvMWdGSlVNeWhYTHo3?=
 =?utf-8?B?QTdnbUhwRVdrV2F1N2k0dnRyb04xblJrUGw0M1Z1RnR6T1pQWm9zVFQzR3Nh?=
 =?utf-8?B?ZkN3NTYzUHlIYkJ3MENMUmNNTEU3Q1RxR1VhMUV6K3IyaHRvdHRYSXZtb1lo?=
 =?utf-8?B?Vi94U2RkbnJkVVZRYWxZL1drK1h0NDFFRnY4MkpmNlJZdkltbkhqZFNnVTh2?=
 =?utf-8?B?MytTR3ZBMmRTNG80L1lZZDJvdlZISGNXUHBldnB2QnpGSzhEUE9VelN6RmFL?=
 =?utf-8?B?ZDFtSEFYOXY2T2Fydk5NNERNbnE4czdHK1JEK3NXYkxGRUk4Qm5Yai9HN2k4?=
 =?utf-8?B?ZVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a74a9a23-808b-4d03-4a84-08db16a1c9ed
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 20:00:33.8695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PN4k1Ok1QvToN5UoWBGxiJPIcb+E/tkJLhi8Aum+s75MorlGjgAdef2P3ThUZOWedX1nXvqMqtef85HUCYm6PvD/BgSuhOFyPogUid32iiI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6787
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/24/2023 10:55 AM, Jakub Kicinski wrote:
> On Fri, 24 Feb 2023 13:45:51 +0100 Johannes Berg wrote:
>> Sending this as an RFC since we're in the middle of the merge window,
>> and patches depend on an nl80211 patch that isn't in the tree yet.
>>
>> But I think it's worthwhile doing this later.
> 
> LGTM, FWIW!

Same here.

Thanks,
Jake
