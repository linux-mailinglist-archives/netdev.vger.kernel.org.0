Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD664675BA2
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 18:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbjATRew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 12:34:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjATReu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 12:34:50 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8893CB53E;
        Fri, 20 Jan 2023 09:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674236066; x=1705772066;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mtZj8s3korTzFJxuAfARhUlwDyHTG22IXPfOBsdaY04=;
  b=EVefviNbBZB4bZNqvjpyXXY0J90FAELwqdfLxJAuXl4HxTvrjoNlv4Ei
   jKGMzdqp4F+naoD416Bosefm6FtR2EeG0mafh3DfjszeVOASCVohgvukG
   HbS7qYr715WsPYT722nCjwG5We/W+lanGZBKZ5Eg6mPz5jkC5Z34+dHbV
   30poU1CMJb09LUm8T/k2WF04i11YXgpAc0sUnZJBqoeg0PkJmUWFuYC6v
   EHWlJWWd4NC07hmjFhJmpsCfPTO28FccKEeO4Me2hlZTkSppMqgSrzL2R
   xyobUnGMYfQQ8M9yCmu2Fy1xJ/bF1eEHHx2bHftgyk+JVMbkHtKylzNxG
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="387999389"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="387999389"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 09:33:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="660667216"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="660667216"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 20 Jan 2023 09:33:57 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 09:33:57 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 09:33:56 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 09:33:56 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 20 Jan 2023 09:33:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SvfH1UmVAd/7zfitZWP00yGHX9vR3zeKghhRcHFNdnL9jwbQStOe+jtC2vP5e1P1BQEEynhqKNpaJHTce4R5wUeS2Efbe2yRL6BlTMN3GxFG+uqbApfVFY3kaIPgJCWTZGGbHmqPy0gpbOnW9Ja+Ou78MsWOXJqdSvnQN7WM8CbVCDM6kKaxLqaVsvxs3/I6OuJTkH5ho0ZHKwwdlx6gdQ96wzWnRmQlhNmToFr6vp/dBOi6+NiQL4hidI+xI4NOOmX2zmukh/N6L12BNUZY5NQtGTv2rrU1CcPFhX27BfPyiCc1EETz5OSCS67m6I5dr6iQ09LIy0hmgawbWXYhLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=faPNL1b1n5L+dHGKuYi6nkaRIwChhXKHfln4cI9HHJI=;
 b=M97ocR5GXK84Tq6Tvy9QUxlA7Kn4V7i+ZVSJM3X9czUBr7EYVTrQ6/rCXYHtGPmrMZMWCsecyawhuRbhaLbQeV3Lp2+j3sZ19sUYvEjpB6Qwp9vJnrjipjp1Io3dQOhU4tEem5/NZs/hd8MJeWDqCub1jSqCoOtSN4UBWdPG8wEiLlly/pVHXsivCN36pBfnBYniM8hVLpa7JyCulKQltyjEbo8kAa8MuELm+c7ZyDSRxlq+TEt5DdYKRUXjkArFcIohD/Q8aO2SVtFfGoEWGaaV+NX2xeNdSOeMKr228c9gp0Q44pIhCZ0GG2+RctunxZlF7dml5Khxf/abc/OzlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BN9PR11MB5546.namprd11.prod.outlook.com (2603:10b6:408:103::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Fri, 20 Jan
 2023 17:33:54 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Fri, 20 Jan 2023
 17:33:54 +0000
Message-ID: <b3b7594b-cd91-7121-d835-5ce60eef719f@intel.com>
Date:   Fri, 20 Jan 2023 09:33:52 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net v2] net: ethernet: renesas: rswitch: Fix
 ethernet-ports handling
Content-Language: en-US
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-renesas-soc@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>
References: <20230120001959.1059850-1-yoshihiro.shimoda.uh@renesas.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230120001959.1059850-1-yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0069.namprd03.prod.outlook.com
 (2603:10b6:a03:331::14) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|BN9PR11MB5546:EE_
X-MS-Office365-Filtering-Correlation-Id: a5764bad-4ab0-4281-d825-08dafb0c8073
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OcYzYsPrHKuv8h0KmmtFMfmbuGkxYOrKZpx0XNstgK2QTyzGq0b03+tdCfWo4xziIPLZbf2XJz3ToIOupMAfSQ64/rYlsCXc8RnVKJGJE/FLpgf3/1H5+EdvKL2TL2/CKANqP8w3ZJr7EVaw2Osn1XyqUMazSLiVc2WBSzSB914CF8lmWWBgP7BJgleU9ORaoAWyGrLd4FKb9W8YRZKEEMplJEBBE1laBezmJs5a0HtgydyBviRsLbJVhVDOKh/WEbs02sgEJEKtNGQvSDFfBa98+fsskhbDcIGn9KGS6y2/FoFl0cotXEizDkMrKR2WDwMtUy7NexyPQpO6WtgtDDc0wExyzSSfoHTwiU/BRPfORevRwUqt/a7hD/xpWTzKVrvYTbqD0eM5+ajJPA31JT9G+bhPM7pOd8/vmahjtNE/XWum0OibkBxeS/qSu0kby0MI77Cuez7Wdry/QfO97tXPuomIdQAGrY5wkZqdvMpz6Jt+kGpy0nXyIOPakHIK9aoLIMD3lOXN66+bmx9XfHOm5Q74lPAIHEhOxM+LPlCp2aL2z/Bfjaapvl2py33RVxTnYL4NZ6ulB3WOPf5Qu+BsTeNJjmqQS9+Tcr2SpRlafOUf6LZbVjxVmbMzpkRR9yRdMfejkkWsnxH7hLOnG04cFV4xCIqGPr9I9UruD6bz2nPkTLAYVkdmSMpKKmAPeDZM9osH9+U7/g04iXSmOgDSDz8pa+VsU7BZS6B7BGE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(136003)(346002)(366004)(396003)(451199015)(53546011)(6486002)(316002)(478600001)(31696002)(82960400001)(41300700001)(31686004)(6512007)(36756003)(38100700002)(83380400001)(8936002)(86362001)(26005)(5660300002)(186003)(2906002)(2616005)(8676002)(66946007)(66476007)(66556008)(6506007)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SnlBRVB6RkQ2bHJBOWJnQ1dqTENTSTdpNWVMazNDanlJNHg4QnJZQXFwU0c5?=
 =?utf-8?B?dmg4dnZkZTl3dzQrZ2ZMNWE3cWVJYjFlRHlkczRYUWZrZndLTDJlVTdTLzJi?=
 =?utf-8?B?elhxNkprU2Q0SFdxK2dmQWNHbXAzczUrZndCNmJKdnB0eG53YVZUZ0tyWTRk?=
 =?utf-8?B?RnR3VzkxUVBUaE04Ull5VEZRenpxWUZ3ZERDWklROS91WjhsMDA3OFlWNEth?=
 =?utf-8?B?aEpXd0VKdzRLbENTbTFQNHJrKzlGK1dEdlRISnA3M3ZlL2FtL080dGExcEhK?=
 =?utf-8?B?MkZpOHN3aVVGaWRQVGhPN0g4YWI2Vmt2SWU3VEYwbTFHTG8vWUpPV01oZkd1?=
 =?utf-8?B?YlRKSnV3VDFPbFNDRTdHa1V0dVlWUGo4QndPNlNQVVFtOHFUd3Z5Tk4vZUtS?=
 =?utf-8?B?RHZ0ejNndG1EVHlLVTcxYjM0djI3dGE5Y0NQemN0aDhKNDFSQW1wb1pXMFNw?=
 =?utf-8?B?bGM1cVRQZUZ3YlZhVVp4dS9vWVpXTjJTVmRjbWdsVVhsKzFPNXhPcEtTVC81?=
 =?utf-8?B?SVlaTjNNY0ZweUM4U1c0QkVlK0xOTFQ3b0lrRVFvQWFuMWxOQ0ZVaC9QTVI5?=
 =?utf-8?B?bW04YWwzVG1GZFpxZ1JIcHltZlJxZ0tOdlRCS1V0K2dBMmNvVzdXRzEraXlx?=
 =?utf-8?B?VURqM25CZXY4ZDJuQlJXMWxOQXlIdlNqV0dCQ1VEM0JKenhzRGsyZmE5Z3JI?=
 =?utf-8?B?dHI1T1E2YUFMa0h0di9WT0ZEU2YzSlh6MExSOTVldDZYK2xubU1aTmhJK0N1?=
 =?utf-8?B?ZVZOZkI3M0liK1VEaW1XUlVidU1UOCt4OWlON20xdVQ3SkxaWVdCQzhDUzgv?=
 =?utf-8?B?TTBaQk9TS0RKeFEvekhTOEl3cFJBOVdYcDBRMHllT1NWZlZGL21tbTRPRG5P?=
 =?utf-8?B?ZWZEL2JTd00vSU84elcxL2xlb1gxY3JCZlE3cnRoK0JNWitrRU8rNnZHdE0v?=
 =?utf-8?B?S0R2Z01qRElvNlNpQkhkZlJCZGhsQjZGbng1MURhYTA5QytiWnNaVytDUEZo?=
 =?utf-8?B?bElKdFlLSEw3TXNvcHR1M0ZpNXBMN0JLcjc1aXJuTHdlRTdpUkVZaWovNGU5?=
 =?utf-8?B?QjF2U1VRbzlRb1FxUC9mZjRNYk1wOUFUY0VoQk1pek0rMmpUcmpCRzV6dC9S?=
 =?utf-8?B?dk1PSGJFVUdkOWJTNXltM1RtbHM4ci9hT1FRcERIVWtpTlh0WDBMSUdGT1pw?=
 =?utf-8?B?Q3pSd04vQUdYZUNER0xxQ3A3RWhvU1RLYnB6N256b3Q2MHhWZzFzZmJjM0R5?=
 =?utf-8?B?dU9JQUgyZEVRVVNtdG1GZmRBUEwvZmFLQm5wVktnRHJGY0QybkRhVzJVRWoz?=
 =?utf-8?B?OHo5b2dvTDhaaDRNU1VpVk44K2ZNTzM4QkxJT0diUU1nRVlVWDkzMkdsc3Jk?=
 =?utf-8?B?R24yaFcxUVZRcklmRTFUczByTE1vRFVWNW5idUxZWDFKTVJpL3VwLzMrclNt?=
 =?utf-8?B?RFdOWUl2TldOU0ZqaERNTFVDNlFDcFRvdnpXREhtYTZKS1dZcytIdThkQThm?=
 =?utf-8?B?RGFyN0hGanA2MVN0UmM2WkVZTUJFTk5pVjRTV0pWNFB5eGZCZk1mWVBUR1hy?=
 =?utf-8?B?VmVEMHlRbnJVNGlIaHVqdjF1OE5kcHE0RzdhVWNjRm80T1ZRMm1nN3JwWWdq?=
 =?utf-8?B?QzNYU0lEbWkyYzRERlZvdHA3TnorUUFkVFFBOVdzMU5iWlFBY1hQRVM5V1VJ?=
 =?utf-8?B?NlBnOFhaK1JndUJJS0NqVXFxRGQyQjRRK3lhZWFEWG56VXZUTklBN1dzdmly?=
 =?utf-8?B?Q0wrZ1drN2srbHdXekowSVRNRytBWmFrdmdKc3NnWENseGZYZ005QzUvZEU4?=
 =?utf-8?B?RWlNa3V6c29aRys5Z0NOSkYzYkYvS3l1bUZmY0IxUDJUenpWRlZab0xKamZN?=
 =?utf-8?B?dTNOSU8vTnlwbWVBYlZQOTEycU0vSnVncXhpcGNLUWNiM0lkMmhXdkc2WUpt?=
 =?utf-8?B?NG43OEZ5aXVreXpuYktDSVJvYkxhbTlqTnN6bzdlcTQ5ckRwVzdVeG5xUjNq?=
 =?utf-8?B?Yk90b2FBZmM4aFNaK3dyaXBUSVZPVEtiRnRtR25CMWZwNnFiNVQyYVNsMito?=
 =?utf-8?B?V2dVRUIwdmVOWXY1dTROSXh3VzFKOFQ2dXhxcVdaenhocWZSWThiazh1L1dm?=
 =?utf-8?B?a3dqbzYrNEthN3pwZUltVzZzZnltMDdqSVBYT2J5aVBYSXhEV2ZCbHVIQWlZ?=
 =?utf-8?B?R2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a5764bad-4ab0-4281-d825-08dafb0c8073
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 17:33:54.1163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D+igWhluBOwalRCnwWMD0zLSFocvrTTO3/QUmhBGOBnGsGmqqMQObWbTYt2a0/uF5S/tEP9Ny9k/AC4iy+w9HL8mr3cU1qobwmqTWg4LD1U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5546
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



On 1/19/2023 4:19 PM, Yoshihiro Shimoda wrote:
> If one of ports in the ethernet-ports was disabled, this driver
> failed to probe all ports. So, fix it.
> 
> Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  The checkpatch.pl reports the following ERROR:
> 
>     Macros with multiple statements should be enclosed in a do - while loop
> 
>  However, include/linux/cpufreq.h has similar macros and the same ERROR
>  happened. So, I assume that the ERROR can be ignored.
> 

Yea, the checkpatch here wants you to do/while but thats not possible
with the macro construction you have here.

>  Changes from v1:
>  - Rename rswitch_for_each_enabled_port_reverse() with "_continue_reverse".
>  - Add Reviewed-by. (Thanks, Jiri!)
> 
>  drivers/net/ethernet/renesas/rswitch.c | 22 +++++++++++++---------
>  drivers/net/ethernet/renesas/rswitch.h | 12 ++++++++++++
>  2 files changed, 25 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
> index 6441892636db..2370c7797a0a 100644
> --- a/drivers/net/ethernet/renesas/rswitch.c
> +++ b/drivers/net/ethernet/renesas/rswitch.c
> @@ -1074,8 +1074,11 @@ static struct device_node *rswitch_get_port_node(struct rswitch_device *rdev)
>  			port = NULL;
>  			goto out;
>  		}
> -		if (index == rdev->etha->index)
> +		if (index == rdev->etha->index) {
> +			if (!of_device_is_available(port))
> +				port = NULL;
>  			break;
> +		}
>  	}
>  
>  out:
> @@ -1106,7 +1109,7 @@ static int rswitch_etha_get_params(struct rswitch_device *rdev)
>  
>  	port = rswitch_get_port_node(rdev);
>  	if (!port)
> -		return -ENODEV;
> +		return 0;	/* ignored */
>  
>  	err = of_get_phy_mode(port, &rdev->etha->phy_interface);
>  	of_node_put(port);
> @@ -1324,13 +1327,13 @@ static int rswitch_ether_port_init_all(struct rswitch_private *priv)
>  {
>  	int i, err;
>  
> -	for (i = 0; i < RSWITCH_NUM_PORTS; i++) {
> +	rswitch_for_each_enabled_port(priv, i) {
>  		err = rswitch_ether_port_init_one(priv->rdev[i]);
>  		if (err)
>  			goto err_init_one;
>  	}
>  
> -	for (i = 0; i < RSWITCH_NUM_PORTS; i++) {
> +	rswitch_for_each_enabled_port(priv, i) {
>  		err = rswitch_serdes_init(priv->rdev[i]);
>  		if (err)
>  			goto err_serdes;
> @@ -1339,12 +1342,12 @@ static int rswitch_ether_port_init_all(struct rswitch_private *priv)
>  	return 0;
>  
>  err_serdes:
> -	for (i--; i >= 0; i--)
> +	rswitch_for_each_enabled_port_continue_reverse(priv, i)
>  		rswitch_serdes_deinit(priv->rdev[i]);
>  	i = RSWITCH_NUM_PORTS;
>  
>  err_init_one:
> -	for (i--; i >= 0; i--)
> +	rswitch_for_each_enabled_port_continue_reverse(priv, i)
>  		rswitch_ether_port_deinit_one(priv->rdev[i]);
>  
>  	return err;
> @@ -1608,6 +1611,7 @@ static int rswitch_device_alloc(struct rswitch_private *priv, int index)
>  	netif_napi_add(ndev, &rdev->napi, rswitch_poll);
>  
>  	port = rswitch_get_port_node(rdev);
> +	rdev->disabled = !port;
>  	err = of_get_ethdev_address(port, ndev);
>  	of_node_put(port);
>  	if (err) {
> @@ -1707,16 +1711,16 @@ static int rswitch_init(struct rswitch_private *priv)
>  	if (err)
>  		goto err_ether_port_init_all;
>  
> -	for (i = 0; i < RSWITCH_NUM_PORTS; i++) {
> +	rswitch_for_each_enabled_port(priv, i) {
>  		err = register_netdev(priv->rdev[i]->ndev);
>  		if (err) {
> -			for (i--; i >= 0; i--)
> +			rswitch_for_each_enabled_port_continue_reverse(priv, i)
>  				unregister_netdev(priv->rdev[i]->ndev);
>  			goto err_register_netdev;
>  		}
>  	}
>  
> -	for (i = 0; i < RSWITCH_NUM_PORTS; i++)
> +	rswitch_for_each_enabled_port(priv, i)
>  		netdev_info(priv->rdev[i]->ndev, "MAC address %pM\n",
>  			    priv->rdev[i]->ndev->dev_addr);
>  
> diff --git a/drivers/net/ethernet/renesas/rswitch.h b/drivers/net/ethernet/renesas/rswitch.h
> index edbdd1b98d3d..49efb0f31c77 100644
> --- a/drivers/net/ethernet/renesas/rswitch.h
> +++ b/drivers/net/ethernet/renesas/rswitch.h
> @@ -13,6 +13,17 @@
>  #define RSWITCH_MAX_NUM_QUEUES	128
>  
>  #define RSWITCH_NUM_PORTS	3
> +#define rswitch_for_each_enabled_port(priv, i)		\
> +	for (i = 0; i < RSWITCH_NUM_PORTS; i++)		\
> +		if (priv->rdev[i]->disabled)		\
> +			continue;			\
> +		else
> +
> +#define rswitch_for_each_enabled_port_continue_reverse(priv, i)	\
> +	for (i--; i >= 0; i--)					\
> +		if (priv->rdev[i]->disabled)			\
> +			continue;				\
> +		else
>  

These macros are the ones that violate the checkpatch.pl, but I don't
think you can implement them another way. They behave like for loops
with some continue block but they'll properly handle a single statement
or multi statement lines. Ok.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  #define TX_RING_SIZE		1024
>  #define RX_RING_SIZE		1024
> @@ -938,6 +949,7 @@ struct rswitch_device {
>  	struct rswitch_gwca_queue *tx_queue;
>  	struct rswitch_gwca_queue *rx_queue;
>  	u8 ts_tag;
> +	bool disabled;
>  
>  	int port;
>  	struct rswitch_etha *etha;
