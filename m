Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0B26E00C3
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjDLVYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:24:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbjDLVX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:23:56 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA5118E;
        Wed, 12 Apr 2023 14:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681334634; x=1712870634;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/xcdRD4hIs3lPleKAXiMiSh+oMzfWjLb/rUX+lbW9zY=;
  b=gYOkKxPluckKDc2qSH1JcylixJFrywHim6Go5Ds8xxPtpp5Mm4+v56io
   /LdTrRLOhf3v5ItM1doahQCZzG8pfxO37HxXluiQ24FkVsaKc6xl4xSlR
   PCJdLKO0TENq5tOAemscj/VxebtyzZvM1PIhp23aNFrz6TSvve3qglV4f
   31iy7VJ3L3PwUQjmEvUMMaHlkTnuQn02bJwVi+5YH3YtLTHL7CMMoVttX
   RwF5QqCudx8IffiMm2b7M4C67nDnprfQDc97Nt3yTuXg0WA1eUCX9MGV5
   0B0DxkYcS7y+MbzYeZoxJRkKQA8JK6F8pMxdjDU7/9g9f4xsaQY9gP45D
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="328140342"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="328140342"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 14:23:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="639386149"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="639386149"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 12 Apr 2023 14:23:02 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 14:23:02 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 14:23:02 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 14:23:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YGBhtG6yRK+qWgeesw5yQk3f4QlRo4OlHlhmjXj9gh3KsGWLuFe5kIUTYxlVXYhfsBL9a8qLe6gsFmh11KTVsyVtywvUwqQXvDV2Fi7GkxlLYrYAWbSn8qSQW6UG/CF0wQzztsN7G5AxPipYpr1JMPzT4RYK/Ch2l+W4YWuaJXmldDWtXFVSi5AwilmxN1zU7iqLRYn/D46UmtK+uQkvmmS/5QMuKu5A7EcctCBBCWR2Mx8xgpGwuZwmAkyu43ltWCGY2tLiCBHDo4vc+Zrlq9fGKzumdn68YRbvWZMFOpOH8sfkIPVCtEVUbRs3rHog2cAEK/+f+yDlLVJl35jaPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LsN1AblssR+G7kbr+bNjXq3vfiQf1sCUHpLiLTqK5Uw=;
 b=mSWVLXCqMOfOct0FCmv1a5ALMnXMqjHjWPxLHAzUFcbSzNFeh5bwTjfbRKNGPHmKwLz9BQG5CM20dKcNLDoNOjph+8zIoYvAUYgLOax7DMxHV7ScHB/x2hPloyklxl0+f27nsJbqmOlQeynoiM/smECXdPRi8f1/Ft0P7PyWOcv3FWhXCCxQVlwV2lQHhNVBC6WBEY8fScqzQf3Ls3wrriL2jDNg7mv51Gwm89jw3kwL/8w4VDzTI5Kohwei43d26ACvUzsblN8MzCeAgWLVPLAxBaQNJ6zKwh4bxGlXjq/+0c7Vz+PA2gNY07w2vtKre/28RqCt/XDYTwettPeJWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW5PR11MB5860.namprd11.prod.outlook.com (2603:10b6:303:19f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 21:23:00 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 21:23:00 +0000
Message-ID: <529b10f7-6f74-9fdb-db45-0ba589ba0cb3@intel.com>
Date:   Wed, 12 Apr 2023 14:23:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 8/8] net: mscc: ocelot: fix ineffective WARN_ON()
 in ocelot_stats.c
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
 <20230412124737.2243527-9-vladimir.oltean@nxp.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230412124737.2243527-9-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0255.namprd04.prod.outlook.com
 (2603:10b6:303:88::20) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MW5PR11MB5860:EE_
X-MS-Office365-Filtering-Correlation-Id: b146a138-8aaa-4997-51e9-08db3b9c17cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iGW0lyRPoX02ZEquzffnaAs2F60pX/fKG8J8NpMitQwul4p8xFB7uDrYjKaS7JhIemmnr3YJ2io+kE0ChttzsAw5NUmKMLDOO+SVZB2gDZb7z8gAj91rO9B2MiV6hSld40RqGcDCLB+RKuIxK00sn3zuis+AZ7FB02e0Y31Lz1tHxHwPuwOZBIY3mHHDh7MAN6lSuvzstHBQM8qVtIPwo4IANoIEUjHIMMND1bMme0BKiwQ7hw4ivvIDZbcpFcTjBppwh+fJvwEf5hwinkw4x5GwQPXEXJfbCg1ZrBuwC5QSbT9vzJ4lqVADVTBTQak66x+NxVQ8vcZm2dCClHPMn/Io1NTmUU73LZwTw4SPT8IGljaQ1deM2Uf4RdHsDOpI4+JVN59qhDAD+IITYyH4fdSwpnPe+vVzcUJIB6PQ26vjnEmPnnKAxSfX5yMQfCm8HQcBIm+tZDrVQrT6RYnZdoT+O6sCUqkLvGVgKJot1D2maumvMj0W3BIFDe5d8qg4PxZSgfmIPRgwolvQvD8UugS+CM0YBivOiiCpT6dYsZhuLwjSIZkGNb8iPmx5WbzVZmA3JaR3zrg0Km5Dzeg8SXPEANaETr4Is4c6jlsEa2aBK3IY98uLKpVloIBPOJ4eL8b4K/PRd3Cu3nmnfOeC9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(136003)(346002)(376002)(39860400002)(451199021)(54906003)(316002)(83380400001)(478600001)(186003)(2616005)(41300700001)(26005)(66946007)(6512007)(6486002)(31686004)(6506007)(53546011)(66476007)(66556008)(4326008)(5660300002)(7416002)(8676002)(8936002)(82960400001)(2906002)(38100700002)(66899021)(86362001)(31696002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDZLZkxhQ0Z5b21BK1dHWk0zNkRMSHZKWDRjN3BjOVBXdlRMQlI1bWJwejlX?=
 =?utf-8?B?QU81WExpTHBIckk1UkczL0w0N0hsR2dEVUU3dUt2a292WjJ3RGgrUFRLRTRU?=
 =?utf-8?B?d3E5Szhsa092R3FoL21JNmVmM1MzUkJnTlFEcVJYNGc3NG1vOFRORlhJUmdv?=
 =?utf-8?B?T2ZGUWhOaE1XV0VpZDgzVkJZMkxYaWkzbWpYbDdXcWlkNjlMS01JMnVZL0Yv?=
 =?utf-8?B?QWZRZDBjV29XdGlLRkpkaDZFeFB4c2hialBGK0IvVjRVaTdKQ2sxcmQyWFl0?=
 =?utf-8?B?OElISUFyR0ZTdElXTHhxZnptQlJWRzVyTlRTdXVZYzM0L3o0WjZIUnM4ZDNi?=
 =?utf-8?B?Wk1lRkNaNkJnRGcrRGhKWU9ieTZ2eFZST1BuRjRQdFRwNGVpMzZ1anRRc29m?=
 =?utf-8?B?c291THFtQ2pRbEZFOVNNR3c4cW5PY1UzVkg0bVhCejVnYVB0WFJVSmlFZGNq?=
 =?utf-8?B?Vm1kbTBIMWNaMzFyTEVYdHNIdmh1cjVubll0YUJHSkl6SFhsQjZnV0w2YWhh?=
 =?utf-8?B?STlaWVVxK2tsV093OWVKYS9VVExTMDFpWndSOGluaThtaUxBMGFGY0VxZEl2?=
 =?utf-8?B?MW5UZkNLTEljY3l1S0hWSWI1UEo5ZUdqVVJTTTVvV3FqNHVjY3hKQWFPcEVM?=
 =?utf-8?B?RWVqcCsrVEpzcFZUWlp4b3A3dmFLMXc5SlMrVEtwaHdjNGxTL21FU0NqUWk3?=
 =?utf-8?B?S2hTOFo3cTJBV21NSzJZOHBDN0tSMUtxTkVkL3hQOGxaRDF1MmJUTE1vWHR0?=
 =?utf-8?B?RVBDdmdDKzd4L2FsQ0JoRGVVSmZIQU5abm1tc3VTdGg3c0lRTUJNRGErY0lk?=
 =?utf-8?B?QkkxWmdiQTBJWTRMSC91SitOTENOZVBWTHcvVStJMzEzV2NIVy8xZ3R2c01H?=
 =?utf-8?B?bWhlSUpDVVRHK2NHQlBUVXc3WFpaRUwzN3dVclBUSTFQYm5UbElIdlo3WHd4?=
 =?utf-8?B?MUwyZjExeFgxeU5pY2FvZnFiRmNtSzdjbkk5YnEyTFBWVXBBLzNpd3JnMXg4?=
 =?utf-8?B?OHlRQkkrTzl5MG9DUXc4L2xPdG5vazVKUk1QU0p2bDdUL0dJRUhaSUh2Ujht?=
 =?utf-8?B?dTdPVEljallpTm1xQUI0cng4SVRScVNLdVZhNkdwY1FMRnB0cHBMdTVLNWpl?=
 =?utf-8?B?dXpJZTI4N3Z1RXFZR0lLd0VPRjNoZUlLMzZNMDVmR0Vnd0ZZeDkyZjkra05D?=
 =?utf-8?B?MXpDRTJldm9aUmRlTjNXdXVPVU1pajk3V1gybU1HZ3Q3MWx5aGpCaXJobFNR?=
 =?utf-8?B?ejJpdTdTRDZpS010OGhCYU9BakZUdFhmMzcxVDk2SjhmK0pPb1FrM2FxV0JC?=
 =?utf-8?B?ZU9BRk9FN0RuNk9JaXNtNElaVFdOTmlrNU9LWUtXeUY4dXFMNHFvQzdaZnVR?=
 =?utf-8?B?QzJZWmVhK0pOV3Q1TG9uZEIrV2hRUjNmWEw0Tk1WM3I1OHk5Um5RVmIzUWx4?=
 =?utf-8?B?b3BYall4TWJMK1BYSGF3S0U0OGxpM3FGZHJRQUNTOXhwQXd5TDN2b1lLVWN4?=
 =?utf-8?B?aWZRVUdpV3ppSGVvenNrb3U2TkMxSC9VaU5UVWhLZkpGRDdIa2dVTCtFblR2?=
 =?utf-8?B?ZVdpaDg5a1hHZEdWajlNV3gvc2E0ZlRCZmQwcHNGMGgrY3JtVkZUTHpvNVov?=
 =?utf-8?B?TFZ0OWF5Z1lKclhPMVdTK3V5bTJKaDlVR1I1YTlLOHh1RkJTMDREdzdmTUlR?=
 =?utf-8?B?SEdpM2dqZ1VHREQxUWFHOWNIOFZuNGRKa1JtY005RXYxenVEQ2dlejFJY2pw?=
 =?utf-8?B?VFQxTFIwYzJCK1V6ZlZ5T3k5SVAvc1FWc1ZpTktEOGdPVE1DL3BsUWIxOHZS?=
 =?utf-8?B?SkF1OWdIRlRvbWJlRFpTNVdPOG5mZkZnKzlPTmZhcGxaUzkwZDJtUDNFMGVJ?=
 =?utf-8?B?NkpvSnFBc3o0V0FRWEZYQ1dDeEh2SUVNd1pNZ2J2eVdGS3JHQUJyVzJZcDNY?=
 =?utf-8?B?R2Rrc0N4SHZ0QkJsVlZGL2dWaUVEQXR2SGJBeUNlczE2R1RKenRsYUY0ekw2?=
 =?utf-8?B?SDVmWHU1d3kyb2lFRDVpQm5PUE4yd3FrYzV0UjRic0RyNkc4TzZoVm5IQVE0?=
 =?utf-8?B?TXJQclowMEJ5eWhyVE9ORGRHb2NXK01LaVFRUm1NYUdCK2JJNFN6bjAzNFM4?=
 =?utf-8?B?ZVAxcnhVMnIveEhKd3ZFNTZTRDNTWmhnbkN5c0d5MlNOZnpvTHUxQVdZMGR4?=
 =?utf-8?B?TVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b146a138-8aaa-4997-51e9-08db3b9c17cb
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 21:23:00.4877
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: balkpMDK6rBlCLVuHHUKPu73dJ3/JjAp/0yOIzFrD3HG3gDAPt8Uds7TklAue6SfMj56rj7L+60K1Ngcqh+zxpvPm2Osu6WyA20LiIbEfIk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5860
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/12/2023 5:47 AM, Vladimir Oltean wrote:
> Since it is hopefully now clear that, since "last" and "layout[i].reg"
> are enum types and not addresses, the existing WARN_ON() is ineffective
> in checking that the _addresses_ are sorted in the proper order.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

This is definitely more clear after reviewing the other code dealing
with these encoded register addresses.

Nice fix.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Thanks,
Jake

>  drivers/net/ethernet/mscc/ocelot_stats.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot_stats.c b/drivers/net/ethernet/mscc/ocelot_stats.c
> index e82c9d9d0ad3..5c55197c7327 100644
> --- a/drivers/net/ethernet/mscc/ocelot_stats.c
> +++ b/drivers/net/ethernet/mscc/ocelot_stats.c
> @@ -901,6 +901,17 @@ static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
>  		if (!layout[i].reg)
>  			continue;
>  
> +		/* enum ocelot_stat must be kept sorted in the same order
> +		 * as the addresses behind layout[i].reg in order to have
> +		 * efficient bulking
> +		 */
> +		if (last) {
> +			WARN(ocelot->map[SYS][last & REG_MASK] >= ocelot->map[SYS][layout[i].reg & REG_MASK],
> +			     "reg 0x%x had address 0x%x but reg 0x%x has address 0x%x, bulking broken!",
> +			     last, ocelot->map[SYS][last & REG_MASK],
> +			     layout[i].reg, ocelot->map[SYS][layout[i].reg & REG_MASK]);
> +		}
> +
>  		if (region && ocelot->map[SYS][layout[i].reg & REG_MASK] ==
>  		    ocelot->map[SYS][last & REG_MASK] + 4) {
>  			region->count++;
> @@ -910,12 +921,6 @@ static int ocelot_prepare_stats_regions(struct ocelot *ocelot)
>  			if (!region)
>  				return -ENOMEM;
>  
> -			/* enum ocelot_stat must be kept sorted in the same
> -			 * order as layout[i].reg in order to have efficient
> -			 * bulking
> -			 */
> -			WARN_ON(last >= layout[i].reg);
> -
>  			region->base = layout[i].reg;
>  			region->first_stat = i;
>  			region->count = 1;
