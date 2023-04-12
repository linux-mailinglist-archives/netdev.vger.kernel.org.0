Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3726E00BA
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 23:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229527AbjDLVV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 17:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjDLVV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 17:21:57 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D784527E;
        Wed, 12 Apr 2023 14:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681334507; x=1712870507;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GyeAFMesW4yfiP1KQJb12Kz93hKhnL79EO5fLBqMw1s=;
  b=BKblMqXIcm454xJtQpeSkkcdAcXQngWboCmQpRtIoCqVDafp9fDPEHC7
   yZL14n0Je6oWkFi3FkW/2gP9kydzznBbK9VND3olv1cEeAGtA6zq40OOy
   tiCKOqy3ZIcRhnyhTec3cfBXjU0FyVs1Xbn/Irh8UDDRhaKEmwrFaS9Am
   xBjODatk8sx/zpXK1JsCiYNJeQAi/lVnegkwfYgO+BmJYdT9fwuYKuhRl
   YRMvqvJ70ulIYqxRZnPwi8DhPR/dny73v34XR8KK9QlQHPcRBhDRxRGli
   YxoUMARboHV6rDRzNF5p5FdkKT2mdd/wTC7d4E0X71ZPMefpf+TgsN5Cl
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="328140001"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="328140001"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 14:21:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="689059827"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="689059827"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 12 Apr 2023 14:21:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 14:21:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 14:21:35 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 14:21:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mQSUAY/nDYqNJ/dyNw48DKqGBuZ+6FHj1d91ATDybQeftbhT4g+E8+Zl4PkXdO2SyPTv+IYzcfxQCAbWcOwnpWGsztc3p7ryOJFfpemvRF8izxaRKRD3qJQrzYX03dsSC9Otglg1sW2oebTtYr8DCC5iuUY4jZa133AGJOx1w1GQfkQ+uKBz5CULlPjM9aSDT6XA4JLcVwPRDhgYSKMY4m5qyGy2MyotnifHRysBnBJaKgZ2rVKg2+3BoP3Goq2ORcTBPt9DX5dCOixHBGrwBv8W+O78Gy/WyQXZuxWcPq65xCARx6plaVN3kq+gJjKwasAMcnNF2ElKajV2xqpqRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nxioWff9rXnl41NcfBAqktoh4YSZDGLg13jFJtBMt3A=;
 b=cSdyA/YJA/jZVxAhNPoMkjHiPb/sIjnLP9i+SZqbO/3wcAlXDbWJ57ZHLxLFxkzs8+ts4329cZ/v7/xF4OTy2bQBkYNH3TXcr07FMfMlCAK+2g0BteYgDfBCxo3K1KVaHRm0leEkr9tmmvxCg7HjxhYafiPpt9pCAMah8W8RyvRuQk4VZye46dzjF+ioQkLlijPh4LAf6ECt8vJ/OlirtD7BnTSwlSiH3iRtrc4ZpGy2MrvuiOOwMr3c+HjEZZPtCwcsP1oHF1gH+7J+9aEF8iLEgVTNIplJnirzN+MhqFUABQ5WN14vfYQEv+ox5iFXeBKha8Xaacl4jHvnvIu2iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ2PR11MB8322.namprd11.prod.outlook.com (2603:10b6:a03:549::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 21:21:28 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 21:21:28 +0000
Message-ID: <794f4bb2-ea10-1d9b-96a2-e14df75c81df@intel.com>
Date:   Wed, 12 Apr 2023 14:21:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 7/8] net: mscc: ocelot: strengthen type of "int
 i" in ocelot_stats.c
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
 <20230412124737.2243527-8-vladimir.oltean@nxp.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230412124737.2243527-8-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0201.namprd05.prod.outlook.com
 (2603:10b6:a03:330::26) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SJ2PR11MB8322:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e7df719-99af-4988-eaca-08db3b9be0a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JpXdxcNyCZb8QpMvbpFC85BT2dZuAo11V4PQJf7y2iXHgWrMJqvwwOOV7Veo5hFbuhOAoYr/momF0YyZIgJEekB4VLka+PjAYniashjyFiSCUXJwFt2VaYutSgP+r8kvJqH2+WdPNGMSzFTZZ9EO6SGxgfV1jclBZNVHgLYsT6HSicOCKJVgz9vQHO8BmrvvIsflXTyHQNKML8RnzV3sK9EpwrwflhL2qDQ1kB/pFziRL4SEJb8RykdKordUcpmwDIw96SQv2L6wKK+uNSxcFh+W1t6xaUvC590GpC97WLB6v8TpC03zSbX0R4TCGjPIzotkFEnZ6j/wGXlVoKyFlBSThvdZadPccAMfxGo4yDoTXHeYuBJU2+QX9mDJTmUJluBbyI2AFtiCHHLhWhzeLFeUqjl13hT5JcoBbmqWsZXvICOd0QsK9wD7MdUUJ/sDjgsg9t6xWbN0+UpAJwkWY8W2tHr0XjnDwiu77ap0nmuOZ875GUBubiDWkteErSxzSH7nhFkSFw5kHQz7dbQClQ+9oA+EsCVbqOeadLE4Vhrf5i7BsQ3ZB+Gl1HJydp8rgZP7KMkdm2bQdRGMcxbIBZBy5SuJofFjxJdnQmKfhJZNVszXRNpeavUAxiClsaLrG/CVDPcboI9s4Q0SXeSV7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(366004)(136003)(376002)(451199021)(7416002)(8676002)(8936002)(86362001)(31696002)(41300700001)(31686004)(4744005)(66946007)(82960400001)(38100700002)(2906002)(66556008)(66476007)(4326008)(5660300002)(478600001)(316002)(83380400001)(36756003)(54906003)(6666004)(2616005)(6486002)(186003)(53546011)(6512007)(6506007)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dTFyZUZDTThmbGtSLzVuUFNMQUJWVFVFMENEdmRLcHUyTXNrUzRyeHJIMHh1?=
 =?utf-8?B?Nm4rb1gyN2dHL2ZQMkMzTnoyYit1cWVjY2Z4V251ZTh2VUVkVkJmNFdpaGhm?=
 =?utf-8?B?clFpYkhLVGJnMXJQZ0Z1aUE1ZENKTjgrWWJpZC9HV3hia1g1cFVYTEFFVXgw?=
 =?utf-8?B?bWFiWU1Ubm00TlNlUnlDSkdDM29sSGdDVkNHeXl6YkQzTjVuSHVmNHUyK0cv?=
 =?utf-8?B?NzQ3Q2JnV21tT2dNNFR0MDl1dnpaNUR2cTMyRzRpNGVaQ1pOb2N6MTRVWDd4?=
 =?utf-8?B?S0tWSTZLUWttOXRDK2p5MXJsZm9CN09uS3VkWkd3RUtPZ0h5TlRjQThnaW1s?=
 =?utf-8?B?RFltVDlJSmwrcW0rK3htZ050QkRLWXlkbWg3L0tpbHZUOWJBd1IyaHEzVlVX?=
 =?utf-8?B?LzR5bUt6blEzbXdwSTJXREpmMHBsZlZudWdndytQM0poc0xwMEZkUnRDc2VX?=
 =?utf-8?B?TWs0T010cHZxbTROemNUR1d2U3NGek1yOEdaNTlrUkhTZUdmaExJaHNNZFN4?=
 =?utf-8?B?MWlyYk9HQUEwTGxWWCtYZHN4TDZSdk00azNPVEZtWU8xcmJwSFFZKzBNN3V2?=
 =?utf-8?B?V2Y0emV2bTJyRzRhSCt5Qzdia2NIenJ4TkNsSGIrOWJjRnNydUpiRUYyTWE4?=
 =?utf-8?B?ZDFTSVEvUWg3aFp5anExNGtJQ3NnUUZYdWdFRVZYNEVNQlM2VnVFVEhhMlpE?=
 =?utf-8?B?SlpvL1MxbTZMQzUwMmh1RmxTVytuZEJHYmpSYWFQSXFkWTJsdmtkQ1crVVBv?=
 =?utf-8?B?TEpYNjNCdGs5Mm11eGkxZzcvd2F6b2hMOUQ5NzBZMGhXNktUTmp0eWNMb1FG?=
 =?utf-8?B?Sy9wRmxHL0pFOGM2cXRpM25FV1lYZ3Y4T3drZU4zOXJ1b25OcWxHckFmUlN1?=
 =?utf-8?B?UTZ1K3RLNWlkSUNvVVlBUTBkVHExR3dWUHZONnNocW5xMWtlbTVhT2tQRG0z?=
 =?utf-8?B?cUV4R2hWcldHcGpkc2hxeTdsRkRvNlRpaEpIWERqUWJWdWxZaTNCQmhtaG96?=
 =?utf-8?B?Q1B0ZGZGRFFJcHlRWW1TaUZWTmdHenBWS3hHbjRheWdNTmt6bVBXYklKcGRu?=
 =?utf-8?B?b0hTWHZhOUVOd01RMi8zRzUzeFFNcWplL0taaDVsdk1GSnd6V1l2RG9kWDhk?=
 =?utf-8?B?TkZRRC9mcUJzTit6QzNaN1ErY2g2Z2xWTHFNNWRnYXZsVnZzR2EwMHhTK1FV?=
 =?utf-8?B?Zy9sTVZaNmU3ZWp5VEdoL1BMS0YwdFhKREs5NndqblFRRmVwcXgxR1czTmdK?=
 =?utf-8?B?VXJzWUltM1dFNUZOUWIvMmJTNkJFa2NYc3BHbHFMSlFiaXpFQmsxNFRXTXBY?=
 =?utf-8?B?bVRSOVZUQktJMG9jOHdnVXFYc29lSVJ3T21EOGZERDFsbEFQQXhFeWQ1Z0c4?=
 =?utf-8?B?aU9pV1NVZTNGSnBPaGhkT05WWGJwNTh3UWxBTFRuQ09RZStuNC8vUFREd0FD?=
 =?utf-8?B?VUNqcmJRbm1Sb1dlMmk5MERmL3N6am9EUzVmWGROcFVYMWNHa3dNRW9BV0Nh?=
 =?utf-8?B?WXV3MjRiQTk3b1FwUHJuOUFRdmdaaXczdXBweHh5QlVjMTRTWnJaR1Ivb0Na?=
 =?utf-8?B?Z3FsTTgxUGdXMURBK29zV0p6RWxqalhGbk42dTdhejFLYjB3RTFvaHY5ZVZL?=
 =?utf-8?B?a0dxMUhaOVZ1OUkwQlduTGY4dGtLZDA1TVRwQ2NyM0t0blpGZmpWblNEUmxN?=
 =?utf-8?B?YUVFdUsyZUVzSnlIcjN0dmpheENWYitBVVRhWmF0ZEE1alNKcVNYNGNPMnZu?=
 =?utf-8?B?MXAzUEhFSDVLdk1GcVpEU1ZUNStySm9DSVVBakdaUCtXblNJaWp4UWIwelBC?=
 =?utf-8?B?TDVJN0FkZk9taG1vbFZZMm8vY2lsdXA2cGRMZHl2L003V3Jna2w4bnAvYVow?=
 =?utf-8?B?ZW1vWUNidk90OE1VVFN5djE3Q2pHTElneHRDUUd5U0RyK3N3czc4SmxNS2xs?=
 =?utf-8?B?MktkaEZjQmpGMW9PU0NnU2dCWXZtdkdFQm1ZalRVUHlwYm9Ya3luM1BBN0Fz?=
 =?utf-8?B?aElXK3NScXBTaDNScC9QWm9SYWVrR0JycHdQdFV0SG1mVzBPZkRZR2Vrcnlm?=
 =?utf-8?B?cTM3SGp1NmY0STlHMTVwY05nejVOS3Yza0Y3MFJDMmRRSjE4NkNVV0htT3Bv?=
 =?utf-8?B?bHFyS0xTbE9Yc3VpQkpVdTJEZzk3WlRMRW5KbUVkcTE3T0huaTU0ME9MQ25G?=
 =?utf-8?B?Z1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e7df719-99af-4988-eaca-08db3b9be0a6
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 21:21:28.0346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oFXKNR0FZFQq1uGwZ0S964oWf9fu/T6hGn25gwncatA/q/ZEawAd5iIFvnY5rr+YA8x7Rarh8hpbcA1l2RVuBm1BOrXGMC5uMHHqw7oyv+M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8322
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
> The "int i" used to index the struct ocelot_stat_layout array actually
> has a specific type: enum ocelot_stat. Use it, so that the WARN()
> comment from ocelot_prepare_stats_regions() makes more sense.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/mscc/ocelot_stats.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 

For the lazy readers who didn't dig up the source outside the patch
context, the WARN in question is:

> 
>                         /* enum ocelot_stat must be kept sorted in the same
>                          * order as layout[i].reg in order to have efficient
>                          * bulking
>                          */
>                         WARN_ON(last >= layout[i].reg);

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
