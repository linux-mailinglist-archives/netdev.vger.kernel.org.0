Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADBF606A66
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 23:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiJTVim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 17:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiJTVik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 17:38:40 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34572101E05
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 14:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666301919; x=1697837919;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z+lCYKs7GRVys/ecFGKcPpNHT4Zwbw/6FkBXH1NoRlU=;
  b=Jtt6/Rep328xJCPVV6IsUxMiP6558kGGYqZBJxE2z6B6WP8Fgyoqq/FF
   /8Ohe4osRLGZ8bN+tmyDjYIbSWbe8RjceUiJl5CAhE11aQebPfX4gge0k
   ZUtFhYmgn7Doo929nJv7E9ESDHGDVZdx3pTKgITxrIK2VLx0SxFaRX2VF
   uK5Koo9tf+x9/GUqAyYE3nW6+Zh5GJX3CF0SGKR3iTcS9GaIXjPWCWXlI
   JxS1dTbdOIgTCZKdC1zYs4t8JlC8AmaxsynBy5B14pbv1c/r/2BKuEfdl
   h6pwEw1W1N6+Xp035H+7ZPk9CcUDzrK8ci0ZMYnn6NTgGEgX90XUsNxbA
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="305580694"
X-IronPort-AV: E=Sophos;i="5.95,199,1661842800"; 
   d="scan'208";a="305580694"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 14:38:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10506"; a="663318836"
X-IronPort-AV: E=Sophos;i="5.95,199,1661842800"; 
   d="scan'208";a="663318836"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 20 Oct 2022 14:38:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 14:38:38 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 20 Oct 2022 14:38:37 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 20 Oct 2022 14:38:37 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 20 Oct 2022 14:38:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EPST+JDYWxAR3v1Cm57uBLJvUB2SMzsSk9Dq1GF5zljfEqLSz7V6V9wyZWmpOxBskY3rA7q9Iz1kB4XL6AuoRqb5xveVgIXpDpfBxkozxtiMjZNyw+vLYuOskMS9rJ9tE/+LLxbVzf6Ukq7cc9YEr510fyXXQLbGfZCZeWoFv4eBQ4E1P2FEk+o7wfWyogu5UtRNyzhYVuUZ6YxRg2wfyiPX5SlpdHWsu8qLVylnDe5w0UnnRWy/oNIt+7K4106jjDYEqVfsILCutQufD5mZSiTluWvLB62zCjb6ckwCqBPHaUmQlP0c/7T2brWnNt2jSqP+LTuLGRARD/bjNCGnWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8aCgGJPtiH5BnH0KaiZT+F+lxzN+15N1p4rf86meZcQ=;
 b=iUMSFkgWraHL+HI7pkc+ozfnp7h0jrRyvPPIrvx21YZYGs0ObIkr7U0oDbdYrbNdrMMlyW7OvkkI/sWo3t+m/SdbQ63U1LylcMSFAmWSWFNz73CDE6kZZ/PGL4P8uzDabFksouMBHRsIQghjqQwCFlXKRpyIzYFLDctH5GyY6WsIi6Z9+sw+MYinncbkyv5wJYyqeV78ccjUtF6AFuJghLpuWMEDiIVoFXb8RBM4JA/9JkC7MyhBxDDYrj6J26XZ34wB6Beo7WnZJUu7Gg/asyx/YoZh7NsXvmgyXQCk19ACuhO5HvOoiJ1ejYifhd0uwvCGXP1MkNsl74jzFk4jow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA0PR11MB4656.namprd11.prod.outlook.com (2603:10b6:806:96::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Thu, 20 Oct
 2022 21:38:29 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf%7]) with mapi id 15.20.5723.033; Thu, 20 Oct 2022
 21:38:29 +0000
Message-ID: <53101dd4-c136-dc1d-0416-f3683e234315@intel.com>
Date:   Thu, 20 Oct 2022 14:38:17 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.1
Subject: Re: [PATCH] i40e: add a fault tolerance judgment
Content-Language: en-US
To:     xiaolinkui <xiaolinkui@126.com>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        Linkui Xiao <xiaolinkui@kylinos.cn>
References: <20221020033425.11471-1-xiaolinkui@126.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221020033425.11471-1-xiaolinkui@126.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0025.namprd10.prod.outlook.com
 (2603:10b6:a03:255::30) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA0PR11MB4656:EE_
X-MS-Office365-Filtering-Correlation-Id: 70602274-920a-43ab-fb6b-08dab2e36d8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ntwtP+4ERvnllFMTHNqxj6+OIyaf69uGmgfLeFpvPatLsEMZ/3a1uCce+J+NG9UJtKYwreAlYFIQ+ZBSOw1f9sqU5G6pLtdscDJefNPU1wDm+5ASwfN/ASr9+xJnw58Q4aM/X2BVTRUDMYzCUN71UxtBI7VIR8zCRNNS26WCUi6FC39QYDsGYBL1GUP3PC+BfaXq6ulcHDHMmpGeXwicN5tGeDtu4nEra2CK1Gb5Nei1hxW2gMIUiQcqt2vZ6LWnvbFVm1Vi10REo1jntsHwfSPSX96LNZPAzD6sA+eLRlqY9nsXtWeIz8SmFOnJp/cBTYWCzMhscCMeipZ8UodzDRLnmyJVPg7bZ15SYvP9M5R+jxkLUDDvUhfPEYqchILdIJBVPxHhCKgnXdVIRItKBeqvNn2nklpMhCFvZzAvtZkGjUnR0NR4mOa7j5HMyuTXocZUQYLfLx7sd2O69hGbBHWFUzqXv/B61v0vpSNNb6XA8BK4HdQky4aVdgOOLNVQZbrri//YMDgDr31DTnuU7+8qeoW1al1hsWlf29IWUl6nSQos2OeSndqosM1qGcfhmUbm3zJLTEai5bMGARpe3lSAKIsE9NQakoSD90W3GtSzB1vZGUEnwoyjTTBaUz9aW4ufYOSyXxls/4b1/ImvTVF4ABn3gcAopxOmwq20YND0RCf3k0VHFrsiWwDZMziq3erA3Q5s7g3yvbm2qi1XeCFyfHkitGFjVjFnfkmp6O/Aw9S2mxRUvqkID/rGIaXfsU0P9dsx3srEjUITdTHGh20Tn+lsWcZZ8F9tjT6SriQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(376002)(346002)(136003)(366004)(451199015)(86362001)(31696002)(38100700002)(36756003)(31686004)(82960400001)(2906002)(26005)(5660300002)(83380400001)(186003)(6506007)(2616005)(6512007)(53546011)(6666004)(66556008)(6486002)(41300700001)(316002)(478600001)(66476007)(4326008)(8676002)(8936002)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c29aSTdyVkRVNVBEY1JGSllydTl0QU5Fell4SklYbkd5bzU3L2FxZkpQZEdm?=
 =?utf-8?B?aGRVZVdSS0hUVmlSbFQ1amhHK3pVamt2SElCalFPTmJKdjA1b3cvQ1BoaFM1?=
 =?utf-8?B?Ujc5S1dHU01rbnJwMEZSS2dyQ09YR1J1ZUJ5VEV1K3FSbWlYUjA1TTYyc1JT?=
 =?utf-8?B?QmtmNFFneVNiR1V4M0Q2RTlRb0lsZUo0bFo1b2J6Q0VxZjRBNW92czNBcU01?=
 =?utf-8?B?R0lJQ25lU291QUNieHBqeHBHM2VkVi9xdjlyRzhzRG5udk9HUGUyVzFHc21m?=
 =?utf-8?B?ZzNrVUUzeWQ4VTNJU0ZzS1lXMExzdzdNQkRETEsyK1FxRzk4YXpRaStKK2JW?=
 =?utf-8?B?V2MrRU5HR3RkNS9KcDFkZ3pBb21zcWZvMk1ESDFQWlU4QzlpbGpRSnp5V291?=
 =?utf-8?B?cG5Tb2RvbFR6TG1HOEZHZDVVdzRaQk01TFlnQ2dOcHRVTWJCTlRXSGJSYVQw?=
 =?utf-8?B?NjVhbDZnam0wNkJnaDBvaGhYSHBGL3MrRkJFaVpGMk5HSXN6NGxXdDE5QW9U?=
 =?utf-8?B?UFJvbDNmeldBUlYvYkRYUk02RXFQOWJ6RXF5NnhaakJrTFk3YXcxeFloVDFO?=
 =?utf-8?B?dUlObE8zcktKdHpNdnExU3R5N1ZiWTBuL2ZZUU9aeTEyeDdrbDJQVlVGNWJF?=
 =?utf-8?B?aHFhRWV1ZWNxSSt1V3BCSXFmTUIyMXFWekwydUFjY3NFaWJzYjdpcHBlZjNY?=
 =?utf-8?B?SXV5ZWlmaHZsQ0k4dHJyUXlzM1ZQSUM5UnNzTXVKMm83Y1hDckM3OTBoWmE3?=
 =?utf-8?B?bHN6ekJtQWI4SFFtNXRPTXFDYUxOZmdhZWVPakd5ejVRNUJVRFRkY3BrK2Jv?=
 =?utf-8?B?bFVLM05EWmFOVGxOWUdYU2xzbk45QTMrdEpvQ3gybE8wVFcySjEyT010a3cr?=
 =?utf-8?B?bjlhNTJacTBCa2NDUXpzdGlTdWduODFpWUlsZzUvRnA5NWdPOFo1TlR1MGl6?=
 =?utf-8?B?dmRzZVkyTnVQQm0yWVNrVk5iWlZqZTRkWEdhVUl5ajJvYUdMWU5tRThBTDN4?=
 =?utf-8?B?eXp6SWhId1BlRnc5bDFBTms1dURpbkI0STFqVVZQeXRCMklQY3JycGlpWlYv?=
 =?utf-8?B?Qkh2SEU4Z2dUaVl1VVlZUDBGc1FmZlgwUFRYL01LRTdmMEJ2V0djajdSRXlX?=
 =?utf-8?B?NUVMQXJDWm1BbEU2aVJBYnhHYUNGVHB3TjJvRm95Q2JKVHh3YnhYdlJOSVA4?=
 =?utf-8?B?bmI4c0gzMmk5VlhxU2JzUmdoQzJmQmx6NHJLTFdoY1BSd0JjeVFubWVzVVlj?=
 =?utf-8?B?VThjMU1LM0FveTRsSUNiNEgyS1JFdXhrN0d5dkVENGpKaDYwWnFXSHF1Z3BY?=
 =?utf-8?B?NnVCeVlwNE5XVjZ0eXBXbXQ2aGFUR3Y2OE4wT0V1Nm1kdmZRV0w0WFl3V3ZD?=
 =?utf-8?B?MHZ4ek9VVEY1czJCUCt2MDN0aUJQMkxtTG03VkYwVk9WYXFjK3R1alJKY1hI?=
 =?utf-8?B?d0ZyUHZoeXBIRHN0b1hBbHA3UzhMamQzS3dJeG5KbVY3RXR1SEdjOTJjVGEz?=
 =?utf-8?B?b1hMVlgwU0hWbFRjdFVFVjVid0VoaE1ZdWYvSzA4d0o1OStZYW5PVkVVZlNj?=
 =?utf-8?B?NGc3R3dvWGdScDZlTzU4RSt6RjdWQ2Y4R214NzZwV0VSYnBPam5PYUxVK3lC?=
 =?utf-8?B?bkFiU2JZRFg1Vy9sSmdkeDRxK3VVQUtoYmVXVUNpVXRjTENtK3BzMVlpbHFZ?=
 =?utf-8?B?WkpPSEEvSUVkZTJpRHl2Z1RPd0dYN3dXeFhBaU9DbmkxZ2t2UW1sT3hKbDlw?=
 =?utf-8?B?UzZDMmNvYmcrdmJxSEc1NklxUUkzUE9PS3IzZmtUdU5TaWw4WFJaUkpQQjRG?=
 =?utf-8?B?N0g1TGJGK3N5SEpjcFpERUZIN1pSM3BaQkJrV2hJeTNrN1BKQ3J4SldZV1Nz?=
 =?utf-8?B?cDJYZVg4Y1pxa0ZtSnNtSE01WU1Rd2ROZXpwaGN2QTJncDVuNFl3VHh2RUcx?=
 =?utf-8?B?VnpDNkgrc2lhNHZZZXFwU0R5RXFURmVYQkxEWEtvbE1Wd3AwbGhuNHAvYTRP?=
 =?utf-8?B?Yk80SCtlbHhyekZ5SmpJQmwybWtPNnhsalVCa2FUZS9Ic0dqMCtKQWMvWklt?=
 =?utf-8?B?Yy96ekI4bHZ6cGtGVjJFd25ub2l2dUVHWm5VYU1DRDNKMDBDVHhIT2hWaXUz?=
 =?utf-8?B?U1c4R1hldTRLb0UrdVRaVllrajIzNjlpY0dDUW5McDRubFR2WWtpcFJReVU1?=
 =?utf-8?B?Znc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 70602274-920a-43ab-fb6b-08dab2e36d8e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2022 21:38:29.3160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MN5MN3hX2GWP+iLod4mZBe7cdagMzHIdhvd0AsOuLEm08mWwqo1Q+gScVIqygcvuy6SXg488ll1c57PoVuq1kT7xTXj6xKGhJtLKKQ4nni4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4656
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/19/2022 8:34 PM, xiaolinkui wrote:
> From: Linkui Xiao <xiaolinkui@kylinos.cn>
> 
> Avoid requesting memory when system memory resources are insufficient.
> Reference function i40e_setup_tx_descriptors, adding fault tolerance
> handling.
> 
> Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> index d4226161a3ef..673f2f0d078f 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> @@ -1565,6 +1565,9 @@ int i40e_setup_rx_descriptors(struct i40e_ring *rx_ring)
>  	struct device *dev = rx_ring->dev;
>  	int err;
>  
> +	if (!dev)
> +		return -ENOMEM;
> +

What is this trying to protect against? When does a ring not have a dev
pointer? This seems more like patching over a buggy setup where we
failed to assign a device pointer.

How does this protect against use of system memory resources? It also
doesn't seem like it would significantly improve fault tolerance since
its possible to have a non-NULL but invalid dev pointer...

Thanks,
Jake

>  	u64_stats_init(&rx_ring->syncp);
>  
>  	/* Round up to nearest 4K */
