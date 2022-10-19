Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E996051E6
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 23:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiJSVVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 17:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiJSVVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 17:21:52 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D233A18B75F
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 14:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666214510; x=1697750510;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hbpaMIZQHQLDNdyCFYlcVuJbCdKUZACQ7k8nus8f6KU=;
  b=UXZDX78PbGvSmgdOI9IJljRY0IKDVVs31TmkpHVPM8M4kMRp95LU/Jc9
   GF1Luv+r3ACO8IYNJ89rqpNyK/njmEcU4lmkIbgbhWOh9+D1lBl5/ORIM
   eqq3P/9zHTUtEn4eeO6IK2x64FMPtHYDAkmYJpU17W0oc7BHudOy21OPR
   vFDqIjTh7YKpJO/Y13BZK/UhBWpWS0LhxynpzojaH4bTnCk5eVUzpg9Qj
   xtsf29/69OM7DudWkIe9dhQXyLws+k5zTlTSEVM67YhQ3hb3BrvVin43V
   sq/lidFba1Tnmjg6t0EqIsokE/wy5wiQ7A25yP4jzB3QR+Hce5JVtfCy9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="333095723"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="333095723"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 14:21:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="718676849"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="718676849"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Oct 2022 14:21:44 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 14:21:43 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 19 Oct 2022 14:21:43 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 19 Oct 2022 14:21:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dfF9BcVe20pGJHYn+LD9hzD36Lzo/AzCQG/nZip67Gau2ERgnj8eLu7/7l1W0QyeFoNCQrJMq0qGc6ABH3T0ZBikvlg9+WSKOuXov46RzrhlrLgLmAuG4f0bhvxlpskeWtQykIVeji/fOXnaU4pUU/OEr2WrgsQmTHSVRJBUqUnceMmNqdvKNz5tVGGOu1PDE8QWFpsUehwk4uE3spcL6lM0ONLPJbyMQCy+b6XWN+lqvz+A38CMy39FGfxkhWgsF2qQeMjuaULelRE0WZA/scbHeFPfOLI7nFoGBNPymzGjzm0APXlJ+e/FnjC6fwudtDxsaImXzhPbG2h/PyecOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AglIv8nWrOHKPZ8Hw3ElGv3FYB+DLNu5up6H+cy5qYU=;
 b=I//YYJXN87LGArqhNeaAiTICtBASpUTqwbeIfArBoOPK3wLQ0olRRqz5eUNXHjRermnrd50QyzfEkg0aqbQRqG9cYoIFpcLU9Lvz/74JDzCo2XnOkeqCX+2IkEIekt5V99MQ8tnzDtsavQufncp6WZFxhcTHvCh8vxKDkwz7Q9BDXkjZ7u45anjWmrSD4cbLOhFbUb78hsztXvX3hXARnEMA7DEHe9Ze0sn1qt9FmZlfyLS2vyz8plkT3PagUWuDS9zLEmXapjfRZYZU6JcmJDWIh5wtu6sCvNlH0tZv8do6bfIDAwgm2WXpVpccKEpQ9/PuZ74sTDPrBX+TYoAlYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO1PR11MB4916.namprd11.prod.outlook.com (2603:10b6:303:9c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Wed, 19 Oct
 2022 21:21:42 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf%7]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 21:21:42 +0000
Message-ID: <92c979bd-ae12-82ca-95a1-e50ea377223f@intel.com>
Date:   Wed, 19 Oct 2022 14:21:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.1
Subject: Re: [PATCH net-next 02/13] genetlink: move the private fields in
 struct genl_family
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>,
        <johannes@sipsolutions.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jiri@resnulli.us>, <razor@blackwall.org>,
        <nicolas.dichtel@6wind.com>, <gnault@redhat.com>, <fw@strlen.de>
References: <20221018230728.1039524-1-kuba@kernel.org>
 <20221018230728.1039524-3-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221018230728.1039524-3-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0061.prod.exchangelabs.com (2603:10b6:a03:94::38)
 To CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CO1PR11MB4916:EE_
X-MS-Office365-Filtering-Correlation-Id: 08347604-79cc-450a-f927-08dab217ead7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L0Y+c8urdzXAimMicqe4CjgeOedM5/fJ2cMcXI8BYNfsdWNTedYKGjjRddvkK/w8D/b43SXYmfWv10joqF53St/szZjK0iFdC1CS2db2XuSVBHfEKo9ySVh+5fyV25wR9bI4Ohlk9OOQzLwpB2xkxx58qhZU6csh2lwqpoh3Yv7jG5nYXI1u0x1hY25eM+N4iujqZtZJ9yeLlsUsbFR/wNvU9Pqi7jSjbDq3AX8ywVHk0HgR9ELPzG3KNMvH47AuWAzd2Xg00U6maan1vMgh+qoYI+eX2o48PR9dbhAq6Q0rU9LcSU3jyiu3XJ7JvKz/Zm2REyig1pab9urhVhqwycwNbV6NmOEsBmYccdw2/TQXFciKIG3VA/jR6BxsvZkG/Ua78bAr+lgeA8iopavN0WOBUNYThgSQT+LwVNJruaaRuxO3NpGd//TT0bYkqF3LH0RQcCBLFViwWy48+Kc6E/GtBJgFRIFafInCVlQ39A5EqNHzjypRtEy9I4jqTOk1rlg5KYVZ0FGJOlrhH4K9Y1vNbFti+yQ1MIKzklSHdufEiUR+XjNOT6kTe5h08D3c+gnqDh3UqKFSa32o86nNKiMwH8d61/0WAMdLMxJ6E39cSJCNl1LF+oe1+kE7jREaEz095/PbBSYQv22CXrJxD9IWq9RoYo4A450jaCRoCEzZgwMm8Iv6OjKH6TVBsLZR8lliFMKm7aYT1Hy1Q1uQ3mcvGX8sVqFJ/ItxPutFvgJGuNMuO8YM++ZbmOLH9uKPyNmFEU40c8zQ3NcS5qiFyw7UZWSZRUiEare5nqudK24=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(396003)(39860400002)(376002)(366004)(451199015)(31686004)(478600001)(83380400001)(86362001)(31696002)(6486002)(36756003)(66476007)(66556008)(53546011)(6666004)(8676002)(6506007)(316002)(41300700001)(26005)(6512007)(8936002)(4326008)(7416002)(5660300002)(2616005)(2906002)(186003)(66946007)(82960400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWpwUmVmaEUxOFBoSlNUTnN1VkJQL3lSMUNpZGZ5MzFrVTRXVC96SW9ienZp?=
 =?utf-8?B?d1J0S3pJOWt3d1E1Q3JKRDVFYThtK2huS3lQZGNkZms0R0FJYUpPZi90QWFR?=
 =?utf-8?B?VGVRWHlWbk16WE1IclRhNlZ0SkhEOWxnSDJQZFNiRnFLT1h3ditYKzlHNmVa?=
 =?utf-8?B?ZTlackpZbllYN016TGc0WnNiRzJZQ0pPZGNKNzRFdk5GdTVJY3U1K3lJSWhj?=
 =?utf-8?B?ZEpndWlWVHNPaG0weWQzVS84aG0vNDNZREx3bFFWUVdwQWNGdlp0NU13MEFF?=
 =?utf-8?B?OVdJMDlFTzdPS3dLYVdtSFUyMVh6Ly9ocWF4enQzbXE2RmkyalIyZkkvTlI0?=
 =?utf-8?B?RDU4ZXJEWFRjRlN5aTR0ak5GL2ZISnZBNTRnVndIWGdERWtsWDZGZ0k3SC85?=
 =?utf-8?B?c21YdWpUVjdJVkRlSHpUcGZtRGpHNDNxcmd6Rk8wOVJjcUF3bXgyaWhRa3gy?=
 =?utf-8?B?QWc3ZDRXSzhHeXZEMEhYa0hWUUQwOEhrazd2WUJTdzNxcE9zSWl0WDRKanlU?=
 =?utf-8?B?cHhYb2RrMHFPTE44RlJxS0U2dkxqRENyb3ZaUlhIVjJIZ2ZGRC94eFk3aVJl?=
 =?utf-8?B?Q0UyMkxKVkdXUEl2dU9ubDVNbm9uOFBKQmZDVzFKaWJTUE51WjFDY2RZS0JL?=
 =?utf-8?B?eUZPNG9oVW9OMmROOVFFR2hBN1BNY3lvdVowM2p3STE4UUZXVUlNVEVBYjhk?=
 =?utf-8?B?TE5vVlJ1STJMMXMwbVFGKzBTTndJU0N0TEF1STVjVXgxNXVVQXNkS0puUDdj?=
 =?utf-8?B?TEtXQkxLSHlrMnl0OXpMcHhQQzEyUVFYdkZFeStIZC8rUG1MWklpeVVUSWdJ?=
 =?utf-8?B?cldYWC9WcEJHdXViMkkzTkRUTHA3bGlYa0VMTmV3UG9QRm1rdGdDRUxzcnpW?=
 =?utf-8?B?VWFHc3hlNVJRcmx3ZTVrR3I1ZTlueHBPcDhOUHg2MVlWakw1aC9xVDR0V0pv?=
 =?utf-8?B?TkpVU2pJbE84WVAzSU5iczRONDhxbnJaVVdnOVV0MXkzSHpmYjFJMmVQRmZH?=
 =?utf-8?B?VlNiN054blgvSUFuYUhoUllLanJrNnM4UEk5K1lObE10OUJpR05KNXkrbi81?=
 =?utf-8?B?VllqRitVaWpaUk56eDcwNWIrUlc3WXJqSkdldXd0bnhBL3pOaHhLU3Z3eGZD?=
 =?utf-8?B?ME1HU00xN2JBWENYdGlRRm9vdkpDUi9Pc1VXM3IzQ1ZabVlCeVp4WGV6a0RH?=
 =?utf-8?B?a0xoaXpiRStTUzlPZ1dhWXpvMkx3clg0S2JMTU82UDEyNml3OS9CdDg5Smx6?=
 =?utf-8?B?RE13SWpXV0tCcVVBdVZ1OUpUREFZdmtTWTAyVktoa3NXQXNBbEJ0MHVzTzNT?=
 =?utf-8?B?RFZwZGtIaThsR3Z5ZUtrMmcxdG1iODF0d3J4YlBndko3RzR3VlZhT3BYS2Y2?=
 =?utf-8?B?RVo3Qmd0MTFTSW5IWTBaaW9wWW9OS1dqUmJCSUJ1eTJQSkNjZFdCYVRlcUFL?=
 =?utf-8?B?eFpKS1hRZ1labndZTldELzc3SzQ5SkUrV3ZLQlE0R0pWZWhzcEVYNmZaQXU5?=
 =?utf-8?B?cDMyUWc5bHZ6K3g0TEZ3cks1UmNRbmhpU3Mwb2N1UnhQQkkzeGZMRTJUQkdk?=
 =?utf-8?B?ekppbllyZHNBaC9YLzdsMjBPOWc5M1JjRzdneTMzMVRWcW1ycnVKencxMVVw?=
 =?utf-8?B?WTN3WjNUVk5iMkY5NGE4b3BnRG1OYUY4OHlXUExYTHUxbUQ4RC9TVmxqU3Zh?=
 =?utf-8?B?OVpPbnFNT3lRbDNQcFBaeW9rdFBvNTZsbUVDMCt3bzRmTS9NMU02RVVnNmNE?=
 =?utf-8?B?QkVVT0diRWl0THFJVlhQVXlrb0V3RDlGblRET2FObnJTT2ZHTnVvZVRNMXZw?=
 =?utf-8?B?dHMySjQ2alloMjFBL3B6em5OVFFCQ1lhaVRzYWxRVHlvMWpua2k5Mk1QQjFv?=
 =?utf-8?B?VmN0SWk1QlUyMFNiSW5mbi85UGVFNUJiSlNibENTRkRnUTBkTVd2SWcrRFR5?=
 =?utf-8?B?NWZDNGIyRC81bmsyTnloV0pZYTNaajZ3Z2pGUFdkRWhYZnA2dVdNZUNUbVFj?=
 =?utf-8?B?MWgwakZ0OTVjWUZ1a0JCUVlMWkppLzJ4RnlxOCs5ays4YitSUStlcEdZZlI2?=
 =?utf-8?B?WmprNitZdVpOTnBvWk5CZEdndjdIck9DOXh4SG02enU0UlJZcVBFZVZuM1pQ?=
 =?utf-8?B?dEIvWGx0L0ZENGtYWENFUVdmQUsvaUhacXovSlo3c3RPbytqR3pRMmNaQlQ3?=
 =?utf-8?B?Znc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 08347604-79cc-450a-f927-08dab217ead7
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 21:21:42.1454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fQehYcWtr8Q1Y4e9ECNJOvhtfQq2NnWaSuUfXggmTf/y//ttOxmZQAz/2f9MFbcgB7pUcv0+Qn/BMmEUfc/kTfe/nVeIVXO/3XK1UCmpNMM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4916
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/18/2022 4:07 PM, Jakub Kicinski wrote:
> Move the private fields down to form a "private section".
> Use the kdoc "private:" label comment thing to hide them
> from the main kdoc comment.
> 

Neat, I didn't know about this.

> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> I did this cleanup to add more private fields but ended up
> not needing them. Still I think the commit makes sense?
> ---

Yea it makes sense to me.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  include/net/genetlink.h | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/genetlink.h b/include/net/genetlink.h
> index 8f780170e2f8..f2366b463597 100644
> --- a/include/net/genetlink.h
> +++ b/include/net/genetlink.h
> @@ -23,7 +23,6 @@ struct genl_info;
>  
>  /**
>   * struct genl_family - generic netlink family
> - * @id: protocol family identifier (private)
>   * @hdrsize: length of user specific header in bytes
>   * @name: name of family
>   * @version: protocol version
> @@ -41,20 +40,16 @@ struct genl_info;
>   * @n_mcgrps: number of multicast groups
>   * @resv_start_op: first operation for which reserved fields of the header
>   *	can be validated, new families should leave this field at zero
> - * @mcgrp_offset: starting number of multicast group IDs in this family
> - *	(private)
>   * @ops: the operations supported by this family
>   * @n_ops: number of operations supported by this family
>   * @small_ops: the small-struct operations supported by this family
>   * @n_small_ops: number of small-struct operations supported by this family
>   */
>  struct genl_family {
> -	int			id;		/* private */
>  	unsigned int		hdrsize;
>  	char			name[GENL_NAMSIZ];
>  	unsigned int		version;
>  	unsigned int		maxattr;
> -	unsigned int		mcgrp_offset;	/* private */
>  	u8			netnsok:1;
>  	u8			parallel_ops:1;
>  	u8			n_ops;
> @@ -72,6 +67,12 @@ struct genl_family {
>  	const struct genl_small_ops *small_ops;
>  	const struct genl_multicast_group *mcgrps;
>  	struct module		*module;
> +
> +/* private: internal use only */
> +	/* protocol family identifier */
> +	int			id;
> +	/* starting number of multicast group IDs in this family */
> +	unsigned int		mcgrp_offset;
>  };
>  
>  /**
