Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD5A6E00B6
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjDLVUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbjDLVUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:20:10 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E5F8A4D;
        Wed, 12 Apr 2023 14:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681334378; x=1712870378;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4mvMOKQZ/rqcUAGi3eihnFtctkK3FUZ9kTLSot6nDQ0=;
  b=PBkPv/SQbZE1JqmNb05x7O9sFO48/BySGqbeqlC/vDa+qZCd1QFlXrr+
   5UFBBcJpKs+EsOYQMvyYUqGdKG7Sk59Yy4+ky5wrBQYBdQTN2DM0NJE4D
   C7Mn1eWDeUFjd6i41C5h7sFrJYmgbYiElOtrmm+W26xv/xkoa12Ssti89
   lsskkdC4+C/naVju3/U7MTiXRzT4PoPbv5eQkQk/8hW6Lq6AEIFDX9wwz
   LcV9kzWxDT8F2e+xMonZswLfie6/Hwpq3TPR7U5x0XpU8xKy4893bO0ef
   H/ALhHsfd+WLnqypM+I1vuQYwz4LhMgFHado7WaYxmPJB0Dh1NWozZbKQ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="371875221"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="371875221"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 14:19:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="778456409"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="778456409"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 12 Apr 2023 14:19:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 14:19:25 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 14:19:25 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 14:19:25 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 14:19:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cMpYDyhlmXHsRyZSoPROZj47QuLC57XB+IsYcXGbg+Z9fTg3OVj63sESg/jy6kDSXNf6UCzteWtHwunpvwogTyzxkL7/KMy9EA1mw09YqnppSMVUuvE/5VIpVhkwgKaruJhJeJljxNw9eFG0teqwiYCeGyCFiIb1fqbXEKwkJpowWJR48KFU79RIf9WBuFRE3pOb6Rvije8iKFnj6RqyiJdpnI7UNe2CaTIvTfg/WaPnT3o5sI3Ovobsqxbc931DOjzSV60LwiEvE4yVsGyZtl/6LZCBkH1u2EQWqhhtSVvpfSQqdhwM/GBBbtoxLiO9eEB0l/5rStHUA38FxT0qOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wh+q4TVmYmvi6KVlt4Ln+eHkOp9U/8ek5UngZP0uZMU=;
 b=j2cozFYnsMIlJFauy/HUkRMeqvfyA2XbQk0Jo7Ma1yU5ZMS9NO5OQkelIaXnyAAgCXq0W4kgOPVzj7tDRfXkiNzpcLKLfFpntclHypa5xZtdLecRp6YNoWl3hb/zSa4xo+nrMr/93Hk1mM+D799sB4cHJbo+XW2YIxC2KLyf6R/mddYDCEP4Bo1rriyllJ9XPNJB2J9jZBFPHhWHKaTKBUyTlMjopP69rzHObPd/PqpO+1rAN66FLwgfkkx9FiE56uAb9MlPzBVx6KJTA5qjjPnzEHj7CQiJBBve1scidebvT7H5ipf2+nKShmhGacXeDdU/ecyqDxQJlAiCP+FS5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB7783.namprd11.prod.outlook.com (2603:10b6:8:e1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 21:19:23 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 21:19:23 +0000
Message-ID: <003aa645-187e-f0d7-fe69-fe86a3d7226d@intel.com>
Date:   Wed, 12 Apr 2023 14:19:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 6/8] net: mscc: ocelot: strengthen type of "u32
 reg" and "u32 base" in ocelot_stats.c
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, <netdev@vger.kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Claudiu Manoil" <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        <linux-kernel@vger.kernel.org>
References: <20230412124737.2243527-1-vladimir.oltean@nxp.com>
 <20230412124737.2243527-7-vladimir.oltean@nxp.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230412124737.2243527-7-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0065.namprd05.prod.outlook.com
 (2603:10b6:a03:332::10) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS7PR11MB7783:EE_
X-MS-Office365-Filtering-Correlation-Id: 709eea28-b351-47bd-1ee7-08db3b9b9648
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cVTGLH7IZ6jbnv/DwxbmeJ1lwK5i3EyF1rdlnYIjareK1KEgRncu3Rd4E0XwUDSGTT6l5RS+0czfTpRu88dDdXqWXj35BWCJMX0Ei7uUyBMj7/GjpX4OHfrEaUioLWjnhkSLny+RQotpO46glsxtWJwOh/KvqFoPI6OUNoABFCaQ5LbFOra0iYZifvFvWEuATIcCIjWi1otyDerSCxl1+Rsd7Cd7Adb/qokGp8d7YSg8gPjWczDdpTAHzkH+rNa2b1f8Qt2upqNOcFNGPEiKBWVt3BfUoZeKmfm9hw6QTATSpTs0hRM3M7S2n4KiSFcKgIg1qpw6v/pSTt/qWZZZC5sPULOhb1dQGJt0t68SFfm6exi2hnclLNoa+QRxfBqSmHfKUMkVOUlafOmxi50vy6T10bWGVG2dt7yUE+h66Vu1MOq5d6+XSR/0QThl2SGDp/t25lZbo8fPO+0VYHkYEP3I723TB3XUAyUbgseUscOHp72hkNkDujRze6H6MHzZXAF3vt5eZ6m1h2x4cvk2vro65kx5axujxbQXIsR0nQqGCtUmU3Efd8bMUapCU4uTvAZZzXMw7Iz9LdHDNqIDUMVwfriXUvqZP8gapP5rEWiWkXHt6p8YFBMTZpDn7ILwcOmzcfpZxt1B0znPro+XEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(396003)(376002)(39860400002)(451199021)(478600001)(53546011)(6506007)(66476007)(26005)(186003)(316002)(6512007)(7416002)(2906002)(4326008)(66946007)(54906003)(66556008)(41300700001)(6486002)(5660300002)(8936002)(8676002)(82960400001)(38100700002)(31696002)(83380400001)(86362001)(36756003)(2616005)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RnQxOWJuVUlyM2FkT3BYQ25uYlNnVFFVWEZuMk5UQ3kxWldLdEpNZGhXaEh6?=
 =?utf-8?B?OEQ3L0lXZ1VkU1BnVHJRU3pNUWw0ei96Z0FtYVdYK293c3VjRjhBYUtBemIw?=
 =?utf-8?B?N3FZelBTd2QxMVFKWTNMaGxHcmV4MTBrbFk1a2t5OHNqOW9MUUs1SDJjMm5w?=
 =?utf-8?B?ZEt4d2hoQzFvelRKZm5nK2xYSmVPQzBFS0ZsQWtyUjIrL3didnZwSHpSVWVF?=
 =?utf-8?B?RFFMV283VWpoOWhNRTJkTzNKTy8wMEQyMkVmOTlJNm5jSU9YS0MzSXFvZGd3?=
 =?utf-8?B?Q3RBcU5iL3I0VUVvQXlDb00rbWpQUXd2L1hCQzBQZlhqZ0w1SlNXV245UUdG?=
 =?utf-8?B?eDNsdm42UytORWtrN1kzbk44akZhcW1GUFFieWI1Yk9rMS9pSkpMejVFblFO?=
 =?utf-8?B?WkoxaDNMUmNqZFk2NkVvNml3UnNNeEwzZFNobi9EcTJoQkFWc016ZEdGNmFa?=
 =?utf-8?B?OHdGMVg5djNUTEFuY3M2c1RKWEJ5Vk5MVmVxalk5K1NuWVJaQ1dyWXBoRkxQ?=
 =?utf-8?B?cDdCVTRRYXNXaVhIdy9qYWFQMzRaSlNac1VMQ0JuL2EwYjNyUFUrNFpWNXJk?=
 =?utf-8?B?M1ZLbE44RHVKYmx2WWJYRlB1dGo4N0dZeitPMnNabkxpL1kvcHNwSVBPbmQ5?=
 =?utf-8?B?eHcrSGI0T01sUVgyUnNuUkNlZjlBUzdqd1BYQUNTY1A1ZzNBTjhkcUhmbzZU?=
 =?utf-8?B?Q2lmc0lZdzUydnVVS1k0MDN5dmhESmtjUWVlR0daajlKczE1b3pBbC9sVjRE?=
 =?utf-8?B?Q0dKRnJESDMrN2hwcW1ZL1BCRkt4RS91MytqTi83UDh5RnBYWkx2Y0RxZG8y?=
 =?utf-8?B?dmw4aG9oSGhySFJ2NUpOV3c4TTQ2dzJCZ1l1RFpQOGJ6VUdiWmduRStRQ2xv?=
 =?utf-8?B?MVQ0UnllTTFmOXYydmdDaHBpNTU0dUkvQ2svWG5LckRuUTNmanRhT1VnTHZT?=
 =?utf-8?B?MTVUQ3RKUW9mUktOZ2xjY0xpdC9CUzlReWcwbVIrU29XSitncUltZFRrSmt3?=
 =?utf-8?B?akVkSzcxRVVQSkgzVC9kak15QUtIYll4ZDVhcFFNcTBxd2pmU3JXNGVYaWF5?=
 =?utf-8?B?WUhTc2dnNDIvU0FMUGZrSC9jak5nU0hsbllVR2I2eUNWTC9lZnV3Z21SaU55?=
 =?utf-8?B?SjVnM1k1UmlUU2l1UndZZDhXdVQyS1pnUlhGZVNwWGx3aGJ0dXFkTGZzS284?=
 =?utf-8?B?bk4rVE15Q0tydkc0a0VzVFJvNXVNUmg1cHkyMzNKdWJMcGZMeTlURGJ2TmNN?=
 =?utf-8?B?ZUFlalNJVzhvbFR1SU5DNEZJcVlRYkw4MEo0NVkzVEVMRG95UDlRYkRWZWZF?=
 =?utf-8?B?blBWQmp3VXdXb1V1L2I2WmN2RENubHYwR2NLMTZyUVNmajh5c2xNaVBBV3BT?=
 =?utf-8?B?cUREd1RvQ0J2djVhdGtKZ1k4ZXBTNGR4MGNWZm1WTzZUMVJNYmY0N0xqWkta?=
 =?utf-8?B?bUtIbUtQYWpnU3lxbGdkVGpxbnpEN2lKdnpwY2JPSHJXdEpWcWxDSDcyOU90?=
 =?utf-8?B?QnJ3WUdSNldlYWt6LzBaME9lbVQrMk1xOWxPRmJBb3AyeWVOeXdLYlIvbDFD?=
 =?utf-8?B?T1k0TFFxUElISVR3S0hzeHFYa0FPbXJQVXI4SysyTDB6dmYvc2tKT0lCWEs4?=
 =?utf-8?B?NVlvSVBya1grN2x6TmZUY0ZIZG1OVWxFc3U4eVFHZFB2cG5PM3hTZHR4ZU56?=
 =?utf-8?B?c1B3TXBzTEMwa1VrRSsyZGJFbVVXNkczZ2R1VDh2Szlxcm5xWkJiY0NDcGx1?=
 =?utf-8?B?NHlnU1d4WFRQekYwRGRzMlpsWkJkNDEzeGpBYTVVOWZPbW5nTDhGL1grdHpC?=
 =?utf-8?B?c3htbmdSUW9jZlM1eGdQN0diSWlDdU5STWwvSU5FWVRVSFBBQlZjTUVXQW9I?=
 =?utf-8?B?WXM0MXM3eXJyRk1IcHlaVnhCTTJyU2JlOEZ2OGlrZTFmeTM0WmQwcGcwK3FE?=
 =?utf-8?B?VmF0RmY0enpTMlVUMXE4aVl6bDlWRlV4dWxIR2xZLy9KL2k5SDhJVWZ1NGVC?=
 =?utf-8?B?YnFwU2J0bEZNaVhYMUZSbmw1YWQzR1lJSmpsYnQ2aFB2Mk5hSnBBOEU0dzlm?=
 =?utf-8?B?K1F5b056Zmp0WWljOS8rT0RDQ2Ryd3A2Nk5UdFQwUXNmMkVOSDVIS3BYTlFU?=
 =?utf-8?B?YUtueHg0MDY0Y2E2MGtXY1JzVFczeFdjSDM3RHZWWTRhUUQ4VzBKSnVkRHI1?=
 =?utf-8?B?TWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 709eea28-b351-47bd-1ee7-08db3b9b9648
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 21:19:23.2266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ovvr53sPCEaDCk5yWPybWTWjWLA9UkRglN1Ljh53gQpdUULnhX5YgYg38GgNp7Nu8C5K9M5UjUTGFYyZhMcsika4hvmDVxz1qzg6ajsJpA8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7783
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/12/2023 5:47 AM, Vladimir Oltean wrote:
> Use the specific enum ocelot_reg to make it clear that the region
> registers are encoded and not plain addresses.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_stats.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
> index 99a14a942600..a381e326cb2b 100644
> --- a/drivers/net/ethernet/mscc/ocelot_stats.c
> +++ b/drivers/net/ethernet/mscc/ocelot_stats.c
> @@ -145,7 +145,7 @@ enum ocelot_stat {
>  };
>  
>  struct ocelot_stat_layout {
> -	u32 reg;
> +	enum ocelot_reg reg;
>  	char name[ETH_GSTRING_LEN];
>  };
>  
> @@ -257,7 +257,7 @@ struct ocelot_stat_layout {
>  
>  struct ocelot_stats_region {
>  	struct list_head node;
> -	u32 base;
> +	enum ocelot_reg base;
>  	enum ocelot_stat first_stat;
>  	int count;
>  	u32 *buf;
> @@ -889,7 +889,7 @@ static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
>  {
>  	struct ocelot_stats_region *region = NULL;
>  	const struct ocelot_stat_layout *layout;
> -	unsigned int last = 0;
> +	enum ocelot_reg last = 0;
>  	int i;
>  
>  	INIT_LIST_HEAD(&ocelot->stats_regions);

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
