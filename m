Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1DF605245
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 23:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbiJSVxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 17:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbiJSVxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 17:53:23 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0813196EC3
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 14:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666216400; x=1697752400;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pVfDyTUSqgXmd4rBTl346Vx++Ktr45btZVG4zoVrL9Q=;
  b=guo0NRkPSfHv+G7pBT+8KMF+9M2jK3rcRBBBhehxSRLMYxjWKzhmzi17
   CLeHy5dcbtkwGuenLzhuQt/qFzlS3N1iwVghIusXSfFobBbnr6Hl8PRz6
   hhuootpQQQOwoKQgxBSVsWWfxu3z7Rv+P1Wvj9mmXi9a/kP56cJ+YTXGb
   AE+bjtpayBUB1eWTRJPZ8Yal4zh2lXMBjL7dc7giejweGlO1L+tuDEXyZ
   24SbMYqWyLXJ/8lD9aUCgPw12lVRr1R7V57fIbDqocx59uBOFJe84thGm
   2PPyrDpmDpPenmoctHWSnoDsgZUPJsBdNHlgrQFRv+wUvfeUr+8o0qg40
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="305275411"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="305275411"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 14:53:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="754778351"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="754778351"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP; 19 Oct 2022 14:53:19 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 14:53:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 14:53:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 19 Oct 2022 14:53:19 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 19 Oct 2022 14:53:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=He4hICX5mZrEXZwNtzPX8GncjHP8WyDMPDXVP6vEoFGyghkcQ0o6lZBSmIYhrU7WM+BlNK3MBQxYaNgUuK9hvh+eyat1h3rEqoKAa6B3uo05ST+HZEl04LqzVFKoIIBB1c5RgBaKz8jSSiaAYSoFhHMGPzu9l4hL3wIBZHw2qyLhu62X3iHtgwGv8ghLI4FLevE7cgzmX9ju/F/q/4uTILxrwQmRE1vORabSIMPH6g+VJbVs41amFDgcsigjfwG0NsNl8vszhNicDwoLSZ9cc3EetaeNul6w7kynPLnUdzpUpsV45Yn10Pod7By0r8bCggOe2Nsx6uo6SkXOflodmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RPtR5hu2OeEEDh+G6z2AlwyA/0gbLdWGdI609SXXWfE=;
 b=gdsQsOv5wbF1e7LvFcSfDRnN3ZxjI2UYeckUg7aaitXxMVJqlMj+I6C9PhVd85is1V8rj/4ZAH6z0EKM8y3fjDhtbOwtdZf09SW8TI/9YdChMGwCRktPKg4knUlZPIlDAOHQbodWuR9OKhgeN3d+iGmhwLpRC9eV7obGiVjXnik01qta3UWTxPDpR4GFKIan59L5ooDcvgXGeySsuqx+I5WtF1MtEAtKJGbMdaC4NzgspdIB0nz2yPGsDgbIrwJL76NrGi+jqulFAuoNZVWJ6zJEBhVo85nrtk7jJF9BNpyKYX6AGiR9Lslyn8LA0ukSA0togDGnpO0UKq6HV6Pucg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY8PR11MB6841.namprd11.prod.outlook.com (2603:10b6:930:62::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Wed, 19 Oct
 2022 21:53:18 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf%7]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 21:53:17 +0000
Message-ID: <c22b7ce0-a1a2-f9b1-b878-bdddb948d687@intel.com>
Date:   Wed, 19 Oct 2022 14:53:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.1
Subject: Re: [PATCH net-next 10/13] genetlink: use iterator in the op to
 policy map dumping
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>,
        <johannes@sipsolutions.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jiri@resnulli.us>, <razor@blackwall.org>,
        <nicolas.dichtel@6wind.com>, <gnault@redhat.com>, <fw@strlen.de>
References: <20221018230728.1039524-1-kuba@kernel.org>
 <20221018230728.1039524-11-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221018230728.1039524-11-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0061.namprd05.prod.outlook.com
 (2603:10b6:a03:332::6) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CY8PR11MB6841:EE_
X-MS-Office365-Filtering-Correlation-Id: 19748cd3-6554-4b06-2d71-08dab21c54be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rMN8cPV+ImBBX0/ftrz6r515f3fIXkq1Yd1uPVWMDxOs1yAvx7g6WoY4VSV7IxVO45M+/vWVMjswCHMWUcFZSfQS5qmX/bBnvgIbxn7URYmo7nNhV9+FKiiHahcmKd32OMOt09Brjcucf6aChvOH/vjaAIH3GIH7V0w+Vr39cZ8N02g3XJcKGdN1R4GoHWJBAqhLDH0E+LZpAA6AJelXQITfuqq9NfEBTQgjCBfjhMHAjtcH8E1iau4WtPP2VvlQLQXVrW17rrSfH77MyeFrj35y8jQJmQZV/lHpYuzRYz9lGXl3XrJFA5ZHg9KnfbLzV5KluFbuj9psiqWyQTsoC6yKrLit4fZl5/L8/VassbOJnNDr3rFCrL/JmJRLM4PsiqGlhg4YLFAvIIshfZZD/2Z4JT+G7bZwOTDLgsHGrzwsSggTm+rBRq5kpwkKNmhYv04kv4UagmQyNrUgm/fB6G3aBXMT+8CxqVp41POJtwduY/3A0wAVW0/0Hyl8VRXk9P/GZN6uQ0AeRp9d19zvejZ07tTADxi21UCBSEQKknQe1sqdJeTQU7KYD45FxuuWdOn1CaKlOh8GIc3szddwZuGZod6IkmOnClCxN7bgp6diFCzFNEVIKz2bTXmE8/TaYcJa4GTyXd2JRyAcJQ6RkYbfxK54WoUzFnNu5lpCupVH60ZMxA5UWwBqX7/JW+znMBmHP+88ZYoLuZrEeYDBmbRnCMiOxHjHDxLONM22x/8i+a/TeqCNjKVWk+zeHHzfOrfySQMBtpORP3FHRPv0yC/1UG1XzbS2aCoh8mxGTM8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(376002)(136003)(39860400002)(451199015)(38100700002)(186003)(2616005)(82960400001)(478600001)(31686004)(6486002)(66476007)(66946007)(66556008)(6666004)(53546011)(8676002)(31696002)(36756003)(83380400001)(6512007)(86362001)(5660300002)(8936002)(4326008)(41300700001)(7416002)(6506007)(26005)(2906002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1hwOXZmeEl5VkNjT3JUUThZem1pVFpQdHZRalR6QVBVWHV2Rm40OHRQWHZ0?=
 =?utf-8?B?ZTV6STV3MlJTZDA2eFJqcDhoSjlXMkZjRzBGODAzTitucG9pM25ubEZYd0Vs?=
 =?utf-8?B?UUR5N3pvRWVwcHJIV05VVFNJVkpxLzlLTG9Pd09oL1FFT3dHNVBjWUZST3Ny?=
 =?utf-8?B?eU5GSU44TEZqcHlKOVQ1ZFVrSEsxczhrVEkxeURtQ3NvWlFBZk1qM29JVzJW?=
 =?utf-8?B?V09VbVRhQU9xUE14cmxMRXg1T0FOQXdjMjN0aUI5ZjFhLzVFZ1NmaytzSldI?=
 =?utf-8?B?T1lIbVg4UUdjZlpweWxjQzcwTWdiOVB2dFVFcktHRWFUUHJvcWhBekNmK1cz?=
 =?utf-8?B?Snlra0dTeXZNM2dYQ2thRThFQzFIdnd2RkxMYWxOYll5RDUrODZZRGo3M0Vn?=
 =?utf-8?B?Mk91dFJYQkVObVBjYjdRTnkvcFZQcFAxZmIzNnExWUc3ck1KMzBXckoxREFl?=
 =?utf-8?B?NERiL0dKcGxsbnJ4ajlFeDdoQUt5MGJ4OUFTTUJGbW9lUUhMb3FBaUFqL0pn?=
 =?utf-8?B?SHA1dGxiQnFkWHQ4MFdjbHlyMkZhRytVZERSM1lRQ0lRSlZ6VG80dWIremVK?=
 =?utf-8?B?L1V4VkxEVFgxOCtaRXcvNEcyUmJZOEZYQ1lDY1NhZmZsUWVtNEF1UWlXb0NZ?=
 =?utf-8?B?TjUzWmNFRjQ1anhlY1NTUWowemNNSGJoM3I2YStQVThVaEg1NnNVckZMY200?=
 =?utf-8?B?V0N2VjZHZHdjQzYrM2V0cXZaVzE0S0Nac2pnbTk0TlJlOHQ1UlN1RlNlTzFV?=
 =?utf-8?B?VEtXUWNWVzluVWFMMXZIUXh6YURVREVVVXlqbE10bDh3VHdFWkxqN1JnejI5?=
 =?utf-8?B?NGM0ZHhaUDRFU2MzUnBERFhtYy9reERiSDFiRUtIbm9iem83Vm5FZjAwODRa?=
 =?utf-8?B?bSsxTThHSk9WTDNxY3VpaWhhRVV2bVVLbGJHaEdNMGVqUFQybjB2WXRTVnZB?=
 =?utf-8?B?UnJadFZab1lOU1VqLzNVaXNYZWFGSzlFT3o3bDcvOFBJOG1qS2UzcjhUazFY?=
 =?utf-8?B?WjJuSisvL3RQQVM5RjRUQWs4dEw4QUtCNzFIWUIydEI0S1pZV1duL1k4NUtq?=
 =?utf-8?B?NFhKUUZ6WVgrRGpUT0tWeDBZdzY3VFdhMTlheGVJeGVXUDJmd2l0MktkRUJy?=
 =?utf-8?B?cUZKOU5QZVRvdkxsU0lGblo2WGV3VnRsMXpNNG1SRjQ2WmlZSG1ZSVp4MXZB?=
 =?utf-8?B?MnpTUjB0TElpMkEyOE1EMElVK1B3b3lLWWRtSmpTdDgzeUhuNERRZWZnaFJu?=
 =?utf-8?B?Q0hkbjVIRGJaRG1NUDZIVHEvMy93RlN6azlNTFdST1hHK3poa29YOVN0L1d3?=
 =?utf-8?B?c01PQXNpTnpKWUZXOC9NQ0h6a1FjZHFiMnNZaTVVWmszc1BVK3BsT0ZuYytU?=
 =?utf-8?B?TGU1WkQ0K0J1NlAwZjZhRDlWOHZXU2Z0MDlsa0g5TGJvdEN3TFlqUnBGNUln?=
 =?utf-8?B?Vy9HWEhOcnMrZHNPR2dsUGR1ZENiL0xydXdRR2k2ZXJLNkcwWFpBZjVObnU2?=
 =?utf-8?B?WGFFRmNkL2cweUh2aDV4WGdTT0dqZGpYUElVTG9uTjJxcDRhU0VHRlhGVkk3?=
 =?utf-8?B?TVFBRzVPUDRYVzlsUThXQ2I1UHVpWUlFN3psUkJMTlpvb2VySGFzcjZmRlFC?=
 =?utf-8?B?Ukw4eDBoUVFra0lXU3l3UmVFOVhPcHZFanZ1dFZQQjlOSGlhNzBjSnA0ZDN0?=
 =?utf-8?B?MlRCYWZjQXVBWk8yMnhua2NNOUNYU1ZYTGNHdDliZEsrR2Ixb1NqT2w1a21s?=
 =?utf-8?B?ZFBSMDRCL0JIeUM4cDBpaDMrY1ZZRm4xQ2Ntckx4U2dpQW90Tng3R2xpbDNI?=
 =?utf-8?B?Z0hhQTBaejczYWVzMFdxSTBrVmMzeUZEa2lVeWsxSmxmbTNwRW9EemJmcnNa?=
 =?utf-8?B?TCsybi8yeFRaL3BWa0xzSlB1UFFTeUZSdXJZOGpXSU8xRzNLTzFPZ3J5VFZt?=
 =?utf-8?B?cXRQYThNa015U09vMkNZWkl4SU9mdnprUTBZNk9pUG1EbHEraklkYjV5OU45?=
 =?utf-8?B?cnpZdnlvNmppWEtDbGNmUDZFaVRqUUlvcXNBaWl4SmJxaHcxNldMTitwZFRv?=
 =?utf-8?B?RWNqZlNGYkpZcnhtTzBFMllGdkNVVzZHNjBVRzBsaG9ubjlJQnZzT2ZHRzg2?=
 =?utf-8?B?Yk9aRUUzTmE4NWhIOWVnaUY5UXR5ckpPSE55ckRFd3VyNDZGQjFnM2xhcUlN?=
 =?utf-8?B?Rnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 19748cd3-6554-4b06-2d71-08dab21c54be
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 21:53:17.8956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: px25DZS+vmgPfihNlSY+fj8b8X6bTYRDh2QkosaAkYXUavg/1bgMw4MkLMNsBPEH4wBAYmGwYenSGH1Wp8FHpZLUl2opDR8+EUf9QHJHMWc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6841
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



On 10/18/2022 4:07 PM, Jakub Kicinski wrote:
> We can't put the full iterator in the struct ctrl_dump_policy_ctx
> because dump context is statically sized by netlink core.
> Allocate it dynamically.
> 
> Rename policy to dump_map to make the logic a little easier to follow.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/netlink/genetlink.c | 48 ++++++++++++++++++++++-------------------
>  1 file changed, 26 insertions(+), 22 deletions(-)
> 
> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index c5fcb7b9c383..63807204805a 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -1225,10 +1225,10 @@ static int genl_ctrl_event(int event, const struct genl_family *family,
>  struct ctrl_dump_policy_ctx {
>  	struct netlink_policy_dump_state *state;
>  	const struct genl_family *rt;
> -	unsigned int opidx;
> +	struct genl_op_iter *op_iter;
>  	u32 op;
>  	u16 fam_id;
> -	u8 policies:1,
> +	u8 dump_map:1,
>  	   single_op:1;
>  };

It might be easier to review this if the change to dump_map was done
separately, but I can understand the difficulty in splitting this.

Overall I think this makes sense.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  
> @@ -1298,9 +1298,16 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
>  
>  		if (!ctx->state)
>  			return -ENODATA;
> +
> +		ctx->dump_map = 1;
>  		return 0;
>  	}
>  
> +	ctx->op_iter = kmalloc(sizeof(*ctx->op_iter), GFP_KERNEL);
> +	if (!ctx->op_iter)
> +		return -ENOMEM;
> +	ctx->dump_map = genl_op_iter_init(rt, ctx->op_iter);
> +
>  	for (genl_op_iter_init(rt, &i); genl_op_iter_next(&i); ) {
>  		if (i.doit.policy) {
>  			err = netlink_policy_dump_add_policy(&ctx->state,
> @@ -1318,12 +1325,16 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
>  		}
>  	}
>  
> -	if (!ctx->state)
> -		return -ENODATA;
> +	if (!ctx->state) {
> +		err = -ENODATA;
> +		goto err_free_op_iter;
> +	}
>  	return 0;
>  
>  err_free_state:
>  	netlink_policy_dump_free(ctx->state);
> +err_free_op_iter:
> +	kfree(ctx->op_iter);
>  	return err;
>  }
>  
> @@ -1403,11 +1414,10 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
>  	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
>  	void *hdr;
>  
> -	if (!ctx->policies) {
> -		struct genl_split_ops doit, dumpit;
> -		struct genl_ops op;
> -
> +	if (ctx->dump_map) {
>  		if (ctx->single_op) {
> +			struct genl_split_ops doit, dumpit;
> +
>  			if (genl_get_cmd(ctx->op, GENL_CMD_CAP_DO,
>  					 ctx->rt, &doit) &&
>  			    genl_get_cmd(ctx->op, GENL_CMD_CAP_DUMP,
> @@ -1419,25 +1429,18 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
>  			if (ctrl_dumppolicy_put_op(skb, cb, &doit, &dumpit))
>  				return skb->len;
>  
> -			ctx->opidx = genl_get_cmd_cnt(ctx->rt);
> +			/* done with the per-op policy index list */
> +			ctx->dump_map = 0;
>  		}
>  
> -		while (ctx->opidx < genl_get_cmd_cnt(ctx->rt)) {
> -			genl_get_cmd_by_index(ctx->opidx, ctx->rt, &op);
> -
> -			genl_cmd_full_to_split(&doit, ctx->rt,
> -					       &op, GENL_CMD_CAP_DO);
> -			genl_cmd_full_to_split(&dumpit, ctx->rt,
> -					       &op, GENL_CMD_CAP_DUMP);
> -
> -			if (ctrl_dumppolicy_put_op(skb, cb, &doit, &dumpit))
> +		while (ctx->dump_map) {
> +			if (ctrl_dumppolicy_put_op(skb, cb,
> +						   &ctx->op_iter->doit,
> +						   &ctx->op_iter->dumpit))
>  				return skb->len;
>  
> -			ctx->opidx++;
> +			ctx->dump_map = genl_op_iter_next(ctx->op_iter);
>  		}
> -
> -		/* completed with the per-op policy index list */
> -		ctx->policies = true;
>  	}
>  
>  	while (netlink_policy_dump_loop(ctx->state)) {
> @@ -1470,6 +1473,7 @@ static int ctrl_dumppolicy_done(struct netlink_callback *cb)
>  {
>  	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
>  
> +	kfree(ctx->op_iter);
>  	netlink_policy_dump_free(ctx->state);
>  	return 0;
>  }
