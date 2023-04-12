Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA9F6E0094
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjDLVQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjDLVQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:16:33 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666796A5E;
        Wed, 12 Apr 2023 14:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681334192; x=1712870192;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wIGyBp9eNCM4xCG7gOQ18hQvdF5uU0Mrr4qMaW7AcMU=;
  b=Gxw0K+F55MP6ETYPupqwcu0Qyxf5ffx5ej7fkIZ0kRIPd0kbqHMxk4YH
   ILq1BrQ+avk8WmQama4gKSRHzfoZTg6HwzkNinjNb0SJ8GUWNmdwh/lZ2
   u6y+E75/IJ9ahjY66QMaDk7OkPYzgnl0B8QhUmAgcv+wMpeg/OEnUOymT
   9DlmZ54cNfARX59vuxdwWWSJtYqIokbVf8wjPa+3Hfp7ANoSstvqmIdte
   R4IQ9EUz8peQsCGdilSZ6vnqPcOVtYSkl57pcpxA0sn9rCNZNPvxDrSWk
   6L1l8MuVsRhnhGQyDdXjJEgA8s7rooK4dsDo2NOU2TOLkyV89C5OWeH4u
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="406857648"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="406857648"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 14:16:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="721732193"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="721732193"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 12 Apr 2023 14:16:16 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 14:16:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 14:16:15 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 14:16:15 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 14:16:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h78tDT4HsDdvWsntMY6XiJhxjbp8hjUkp7Ag8aBBLLEsVaXN+gSg6Snq+uzklf/BwhM7rFPHP9f2OHoiyHPScPBRSTJJgi0ujhz/0XqXxeZHqUAEySk7oQbaMuVs+hkSCtEEoYOL5ozI8n2ZzTel5+nF7q7bK6gaNO5Z/5eLwGzUL+P9kcpc02rdh36YTsVonJkLhzprQo7LsXgQGbBUyBSvrYXdbQdren7xvwNOYHZqYJuh9GKmV0w5uPy6N+wYBdbMt/ZskGhtW4z07HA00XJxSHE7OK8DklQwt6n5tiUzxAZ/ITp2M+l/TyNU2Tizo4p5euTNGO83Lhz1iVAyQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h65YZYb+Lni50sT8K0MH/HjQKPO8Nb6XMHPeZ8bptc8=;
 b=YmPYLwuyT25tUHo60bdCZ1AjjS+eYja2TGyOX6QUmivvk4ynZBKQzbmAktSTomhGa9pom/U8oRgIKk9ftIdoy9Tp6o0gIn9e3BAwIinDY/TMboNW4QxnwxHOWgnTbLKfdzFzcmWBoo2ZKv9UaumOyxrYB4FH2kJr3dfiyW+7UYKYX8rx0aK4M6/U5NMKDdWiqEANDi/2hcBs5viJyX5+Qm+M6PGY6UhxeLa9ObFN9S0rpl30hs1XmX9E1W4fprey62bP/PJfSH7I/Dtq3FTsj8X5Dwc5A/oGDzo7TkWpMs3dvCv/Pw5J1ExaOHwTUXQd9pryQ8JHXNGwuONzeA0jig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ2PR11MB7647.namprd11.prod.outlook.com (2603:10b6:a03:4c3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 21:16:13 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 21:16:13 +0000
Message-ID: <e7edc87b-3c1b-1b10-9c4f-0a7b114dd2fe@intel.com>
Date:   Wed, 12 Apr 2023 14:16:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 2/8] net: mscc: ocelot: refactor enum ocelot_reg
 decoding to helper
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
 <20230412124737.2243527-3-vladimir.oltean@nxp.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230412124737.2243527-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0067.namprd02.prod.outlook.com
 (2603:10b6:a03:54::44) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SJ2PR11MB7647:EE_
X-MS-Office365-Filtering-Correlation-Id: ac38496f-2d38-4306-9f01-08db3b9b2549
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AYYDUgdtG/4jUHcK7jcTT1ieOrYlsfwK0JRuNkl39s3qGe5iz9sPeZZO5HFc3TOlaCBari8STbL86+nVCXJAHLmq/HrZcwq4TH5MSuBGez5H5Bqo/qxB9G1Zkm+dAn1q8dFnzJbnaEXJwqR/YY57eoACHUS9wUBRVYS7jr9PqjvnJ62/cTKRGiaGaaCJH7DFTFtso5Gtq+SvcTam+9uaVcsGiWtb6sjOz7ctmJVGJXHtFCckaQXb63MQnqlHAK/HlWFNt+TzzLanJYfkZRW3UUSOD+IYoqkYmAZU/B+8OITAchTNoLgSV3SztNqpBnYa+X66Sglp+7zANCE24b8OgiIACoCF4t0Qmj+AVVIEeU4BsyFaEEm2Sk16gXKZx5BjmhVZDeiixEUDGlBFDTdOUOvvWVB63HL/wNXARYe8pE09wnR8+QBraqfIpSZkVKirTF083Wqz7/dUnTgSbdAe21kSYiEPkiqg+O+uJJKrSkgzYJsQ8gfVjz3XTGrZb7Ud38YBxkRmXLqJTDKvv0l9qPioz/bDGQtZWcREICNLJRpNo10wmRVHEAqB1o26vaUyTFbZ0yj7HN5bYqU6IsrpEgT9Z/r8AoACcLcnSl0lLdiNdLIgzKAr9u1+tqt4ZV6f49g5mAedkIGO/in0L30yvg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(346002)(136003)(366004)(376002)(451199021)(54906003)(38100700002)(2616005)(478600001)(6512007)(26005)(83380400001)(6506007)(6486002)(82960400001)(41300700001)(66556008)(316002)(4326008)(66476007)(186003)(66946007)(53546011)(31686004)(5660300002)(2906002)(36756003)(7416002)(31696002)(86362001)(8936002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MW9HZVoyYTlDdjFMVHN2cXVTQVcwNmZmYWU1NVZOSk5Ta2g0b2ZIamFGb3Jk?=
 =?utf-8?B?VTNCaDhBWkd3YkZqRFVUV1U5aUk1WW4rRGg1Q1kwQi9iZklOVnBQUTBnSW5X?=
 =?utf-8?B?anhFczEvU3pwNjBCMmFHSjBkM1hiT2ZTSHZlYk0yNVAwVFlUSENjaFVYdG5t?=
 =?utf-8?B?UFdRZzEwNWErQlZqRTJXaTZKZFNWZmNqRWIwQURGRzJvcm1VWjg2WHNhUGM2?=
 =?utf-8?B?UW5FL1I4Q3BwUEhna2hJeC83b3BsNmw3UWRSNS9mM3JKeWRpaFlVODZEdUQ0?=
 =?utf-8?B?dlpNbkVwaEkyQU94VGkwdGlEelZCZDRSUnEvanhoRmd1MkVMM1ZrOGVPWTZD?=
 =?utf-8?B?TklBb1FpMXNWY2FTbnBzZ3kxTFdFdXllQjl3WjRGSkRsZWNvZ01jN2xiQUFI?=
 =?utf-8?B?Z0Z2UUhUMHEycnFXQmIyN1pQQUorMWQ3UHpralBwYnhqZkF5U0V1L1NtS2NF?=
 =?utf-8?B?U1ZXM1F5cDhsNkJWZHBjVFNxMFZ2azZxUTdmOFUxS051NzB2dGRSbXlMbjdu?=
 =?utf-8?B?QWVuNG4xbHJSUlU3WWVGT0N0VjA3bTRBdUZBaHljN254ZC9VVVduaTZMakpM?=
 =?utf-8?B?c01TSW85OER2SnRpcVEveExKREFIZjVpVURkUCs3M0NUSUdhWVlqRDJ3TzRZ?=
 =?utf-8?B?MkJGSGdQUk9VTkVXT3NUR0tRclRodjVNdzRBN1Z2UytPMXViNVN2RGxaZzVp?=
 =?utf-8?B?dkxld1Q5UVdmMmsycmlGeE1xNUNTZmtlR0k0RjJEMjlwM1NzRGY2bHBBMGxW?=
 =?utf-8?B?d1lYSFRxTDV4WCt3cUhVb05UQnlUZ2tGOWtSTEZLRkFEaCs0R2FiSksvVGFU?=
 =?utf-8?B?OEVrb0pBMGpuck9YbFVvcnV0YjNNNExvQmgvK0w3MzUrYXNmVE5FTXBEaTVL?=
 =?utf-8?B?YWhydjdLbk5CcXNwN29RaTR2MVZ1eVFlQ291NXRRbWw3TmhnOGE3YnNKclIx?=
 =?utf-8?B?VU96M05pNHYwRG1ORllNNE42YmZEemMxdnBJbUp3OFJxYTJ3S3JUNGgrdmU2?=
 =?utf-8?B?eE5TMytKN3ZvZC9UL0hsbnZSSnJhcS9zU3NFdi9OVGUwTXI5ME1HeGcrUmZW?=
 =?utf-8?B?WjJ1TjhDektYdEpnd0ZGdklucVZGWnlLbHV3SmVBR2dkdDVoZ3FuaUVRaVBj?=
 =?utf-8?B?a1pYK0FYcmtlT29UcmJERTlaUENxeWFPQzhUbTZoNlJ0VVFaUDFrZWRkUVVp?=
 =?utf-8?B?aXBsZ1NJNzJIdVRvbmhrem9tZktjRGF1L1JicEJzUVV3bXdJdVdIc2VuYkwy?=
 =?utf-8?B?WEIyMnJOa2J0UHNyODdnb1NOWmNBUWlxUFpwZVFxZDliSzZUNnpySk1GTWpV?=
 =?utf-8?B?TTBYNmE0VmUwV1FZSTdYMGNISkliODU5VHNoRUF6UjZkZFJJWlB4ZUc0OTh5?=
 =?utf-8?B?WXJLR2hLdklYMUFsa29Pd3R2eDd1eWhib3FLU01BRzZ0NTVGVnI4ZXhuQ0E0?=
 =?utf-8?B?bUhVYTVKUEo4T3BJUlI4dXJySnppMExtR1NLYVk1c3VBR0hjVTBacW1JU1kw?=
 =?utf-8?B?YTArOWhjTTg3cVdrOGFqTFdldVRZWWVHV0cvK2RJTytVN1ZZMFhwNmJ3Y0li?=
 =?utf-8?B?N2dwQ3dmUU15KzdGZ2xVcVRJZkw1TWNxUGQ0Y2NJZG9BV1ZXRGkrWEtHR21m?=
 =?utf-8?B?Z0hWRGRWUTlwMUp3NU5OYkZxNGxXazZPbDhEOXV2TzdiRUNockJpTkY0a256?=
 =?utf-8?B?VjNBOHRMaHdNeVdtNGJCR0w5Z1hhSFlsamdDU3V4dndMRkY2UWdEUzJrYlM0?=
 =?utf-8?B?Z3Q5c3c2WS9lanVUeTBKaU9oN1N5b3JIbzM0VE9PU1Q4U3ZoVGZ6cUx3QkRG?=
 =?utf-8?B?Rm5kSnVjNXpTd2RKb2hHRWt1RDdSSzlWemNZeUFtYTJRdGRXcDN6VGc4aWZQ?=
 =?utf-8?B?RzdudmNpeGJvZlZkVC9NVVZnR0NMQWNKR0RJU3ZuUjhoWll5ck51UU1UanI1?=
 =?utf-8?B?WXBEeEM5dVdERmpEYVZHdWpxQjV6am9KcitlOFRDYWkwMTY4VXBmSGkxS00y?=
 =?utf-8?B?RHQ1QVdHRVJPc2lxQUpMSWJXcUhTZWxHZjRDaDJuOXNRenA5MDdnV3BtT3NU?=
 =?utf-8?B?ZXNRMVpHZDhuRllubU1DUmhFVmZocnA3TDI3U2hkcmhNN3Z5Sm5ORGRLT3NZ?=
 =?utf-8?B?M2RRSFlWTUhZWC9NS1RaakF4a0dodXZlbk5DalQwcFNIK2tPYzVNOW9rL0lE?=
 =?utf-8?B?bXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ac38496f-2d38-4306-9f01-08db3b9b2549
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 21:16:13.6574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jTZPNx9+WUXJAFa8JPf2OEn+Hhi1ktod6z/WyZgqs+b7XOZ4rF/VsUf20Yh7F+LTfckVguAKWmxT1rh/6xpphUYBnyWZKDs8NpkRZF6jJ2Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7647
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/12/2023 5:47 AM, Vladimir Oltean wrote:
> ocelot_io.c duplicates the decoding of an enum ocelot_reg (which holds
> an enum ocelot_target in the upper bits and an index into a regmap array
> in the lower bits) 4 times.
> 
> We'd like to reuse that logic once more, from ocelot.c. In order to do
> that, let's consolidate the existing 4 instances into a header
> accessible both by ocelot.c as well as by ocelot_io.c.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot.h    |  9 ++++++++
>  drivers/net/ethernet/mscc/ocelot_io.c | 30 ++++++++++++++-------------
>  2 files changed, 25 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
> index 9e0f2e4ed556..14440a3b04c3 100644
> --- a/drivers/net/ethernet/mscc/ocelot.h
> +++ b/drivers/net/ethernet/mscc/ocelot.h
> @@ -74,6 +74,15 @@ struct ocelot_multicast {
>  	struct ocelot_pgid *pgid;
>  };
>  
> +static inline void ocelot_reg_to_target_addr(struct ocelot *ocelot,
> +					     enum ocelot_reg reg,
> +					     enum ocelot_target *target,
> +					     u32 *addr)
> +{
> +	*target = reg >> TARGET_OFFSET;
> +	*addr = ocelot->map[*target][reg & REG_MASK];
> +}
> +

Ok this takes a reg and returns it split into target and address, so you
can't just directly return the value.

You could do this with two separate functions, but thats not really any
better. I do wish it was easier to return tuples from a C function, but
alas...

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
