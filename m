Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9FA460521A
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 23:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiJSVjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 17:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbiJSVjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 17:39:06 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EEC1956F5
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 14:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666215545; x=1697751545;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=64eQa7IQPD30lm4BQOhaj0cdf4lm1QL1R1qjs8DWx8s=;
  b=JSU84lukrWzZwWCCNVC3DsNSi6kyp8LaiLenX+WWcyNQte7i62LsHfmU
   lN3bjuc/qS9XgBMZSXmDV1V7qW5vScGICRWM8XEi4LTmBr5upaHcZtiy7
   i9UgmDfbLRekmYCHDC1ojWjrENgVf1pTjA/bKYT7NNZYtBAVar/tBb3rv
   AF7nmr8fAB3D662omc4BQiuRaMIRp+pR5SzjXkg+ssv0KAW2+cRpM4VSA
   CNrBKNw/ZFqPObGZnADprmn/4r+ZzRzm5YYfPqf53Dqzgez7xdUTZuHWc
   ZWG7gOyJZULTxbLKP/OFVbq/2cjUbaseSHFzP+O4OqFrhJuPKwweBU3HP
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="333098948"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="333098948"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 14:38:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="580536625"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="580536625"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 19 Oct 2022 14:38:52 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 14:38:52 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 14:38:51 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 19 Oct 2022 14:38:51 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 19 Oct 2022 14:38:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kWZY2gFjGx0Lh9XmYfj8212B1bRmGa+AMWDJtQs+PqJ3JGj9TgiMKu+kkrsIt+uUJ/NRURPJCoQySfuaPBGoNFZuOGg7v4v3qapaUA9OSZWQGEh5P/UaSAj+yAP/ZqbPG45IUJaotu/PjyT6jtF37FHaR4LTmLEy/mPj4PxpJl8KF/h5IfN0XMEJ7t3ly4wK52m7SdUjN2P0tL8RMdanyYynmA3enJvL/NvY1NGsUf3iwX15rN1w0NH5WViTvASW2V3cHoTvDE8WG18gMcCE5b7pHFTCAFpExlOstydL3UoEBc/XSilHku3G26NGLXOQLE+HkfeX2jurp6ErbC9dcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B9/O/PiBglCgqJlRStWVGpITauvdhY1RYd3ezQqNbEg=;
 b=BHfYWvo+FELtrXvV2TnbO8nE1ayd/20NZwdsimCtFscZecUWtIjrWJufQFb3FEAtmcVGerMkvR+crMZjJL7uFuF283+pjDGiDUGEYglDWDRrIbdhurDmBD0mEWSfnlvCG2oXE7Q2PYGT4jYrmQqLB+LC1dEj1VO/GXF+YntyJl8ZwczwcbxHnaygGBtpA0kJ44ZRlltKlxndGOGbAkmOsjYTnSF6ZvqrVSqnJGYE/EQztAo59UlAU0rLbMtgrQd43aWRcRIn2rqXFT1NxUcABc2we/MFsULSemR4nVmQuKf43TQCWWbGtDlBQCNsmrQvekjatpvyRqJ8E2CIQRF9/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SN7PR11MB7510.namprd11.prod.outlook.com (2603:10b6:806:349::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Wed, 19 Oct
 2022 21:38:48 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf%7]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 21:38:48 +0000
Message-ID: <7539c7f0-503b-57c6-9eda-1eb543b8587e@intel.com>
Date:   Wed, 19 Oct 2022 14:38:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.1
Subject: Re: [PATCH net-next 07/13] genetlink: support split policies in
 ctrl_dumppolicy_put_op()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>,
        <johannes@sipsolutions.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jiri@resnulli.us>, <razor@blackwall.org>,
        <nicolas.dichtel@6wind.com>, <gnault@redhat.com>, <fw@strlen.de>
References: <20221018230728.1039524-1-kuba@kernel.org>
 <20221018230728.1039524-8-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221018230728.1039524-8-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0051.namprd11.prod.outlook.com
 (2603:10b6:a03:80::28) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SN7PR11MB7510:EE_
X-MS-Office365-Filtering-Correlation-Id: 98b9353b-15b8-4747-3665-08dab21a4e52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RhVJJRx0564jb0q6iL2UTTO6Lvy8MUbVtFL8AA7JtLD13mspjlG33c5wMdja3Dx/caPskrwgTIUnIovWvaS1LdTMHC4BSmNMeY6MayjJvPY1You1677H3VBvD5sEt8QvI4nIahWh467+o9bYsssDCpUoG8Q6PcMWFCajOVNjyrR34uJM6kdYO2RWrKgnu3RJBdMB5FdA9LGbPqRg3up7utMhQ++tO5jOBnZ6TpavcdLEfDRnVJXxkLY2av4glz3JyxKo6/VAAqm1L8SMUxg389sE+22MKLbPBvDHgzR/dKCQo1+BvCNaBtoNkiEafx74ORCUXEse43ztI7HwzaoZswWEFzV/w6r1Oon7XB3avptb+C354t9m5T6lRw9H6cQlJaOGN/j9ngrKk4vl+PWZYJIXegXWthjmafTWf6OPzZkqpDJFyqCp/Y3jWI35+IEqNPqM+a47H0a1NP5kyZjNnHf6poBKb4S6CopMe/v1TW9tKNEsqPAk6+pyhfn7fDzJudeAeM/Bojlq4TMxWbp8yXmhFbbHrfZqTuA7Ux40MKPqmh08xI+NRxJBzcck7h+WsQfI4YV+CpOTK5+qek0/Z/m2QQ5IPO7mPA94b0bZTQZwB6v5k08tlCZucLHRGWPEJN18jObaOTIm6vk6BN1ckfTEYc3jqb8JYaIDHe7LEEjRn+l1pMTFqQT4dLM7qIGBVPe+4l6oLaMzXfY7iQ9jsHazpqgG7C356IDDmlYJjDhJwONE2OhslXkOPzrgAFTzjkUNFPvIyA+e/6hRIO/ybFEXOlms+kzp1de1XFzjpN0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(136003)(346002)(376002)(451199015)(36756003)(86362001)(31696002)(31686004)(38100700002)(82960400001)(83380400001)(2906002)(5660300002)(7416002)(26005)(6666004)(186003)(2616005)(6512007)(6506007)(53546011)(6486002)(478600001)(8676002)(41300700001)(4326008)(8936002)(316002)(66476007)(66556008)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWNjOE01UVhmbkpGMlppTUMwWk94bDZCdVFxUmJBK3dFREpwWlhhemcxOXI1?=
 =?utf-8?B?N24wNkFpRi9TME5RY1ZZQVV4WWdJV1d0T01MUEN3bTFhemFHeUYzeGdobXN4?=
 =?utf-8?B?TCtSanFQS296NnNzRDZzTkRHaXBFbmM2bEFxeHFBdGhFVjMwM3ZkbEJzRTQ0?=
 =?utf-8?B?UnNWcDdTMGVKS045emdmWkdwTVVZZ2g1TFZWMENvTWxsTlgxalB3bzk2aE8z?=
 =?utf-8?B?ZUNSUVZ1TUtnaGlnSG5Sd1diZlpyNzZraHFWa01aQm1UVjRTZUFsWGEyeUFT?=
 =?utf-8?B?dHVHaXVpWENnSVh3Z1VpVXY1Y0MxSUk5TnYyQU9yT29OZVorSGJtRzlHdXR2?=
 =?utf-8?B?Z3NqTmx1NS8wWmpMNjlTTllTN3Z0bldvd2pWMXVya3U4cWF5NTl6NEphNGVi?=
 =?utf-8?B?c2xTUWRBRi9yYnJaejFMTThUNTZjZ2xzc05oV0xTaXdBTjV0Z1FSdnNlOVha?=
 =?utf-8?B?STl0Wjh2MytKYXdaK05GbCtpVGhESUdPdXpjYjlqbjYrcmFLbVo3Zm9yNmd4?=
 =?utf-8?B?UkV3VWIwbXBSem01MmlDNkdETjc5bDZ5VVcydmgzK1B0ZDV3Z1l2TXIxU3Nj?=
 =?utf-8?B?VXduY0hkOW1OMGtSZ291OVZPUGM0azhneFlNaXhEeHVoOTQ4YXVzYWE3dDNX?=
 =?utf-8?B?Z3I0TzR3cjBlMEdISmFLcE1mWURSZDF5YkZyREtQV2xNQVNBbmNwS0x4Nktq?=
 =?utf-8?B?c1RGRzB1UDFuR1B0WlhVUWRGeWNwTHVPWnNmZUgvMVZHMnVZdkVDblJudm8x?=
 =?utf-8?B?bG1hMHNaUEh4QzhaVkk4TGVLTHNHMXZDS2M4QkkwWUR1S3dJVWxTakxaQ0p1?=
 =?utf-8?B?Y1VWUWFSRE9wRHFvdmlhWXJtekxqd2h3OVhBamsxdnFic2l2NHFqUWFoY3px?=
 =?utf-8?B?UEJ0a2NYbXpXMFc2OWJMQ0ZTZFo3ZllKckgySGZQT2tQM0JzdHptRGxKNW1p?=
 =?utf-8?B?RUVCZ0xFY3dDb09tWXN0emFPRGo1R1Fnd2ZjTFkxdmgxeHRyVFl1dzd6K1V4?=
 =?utf-8?B?MTQ2WGxoV1FmWmhYcWFiSGpCVCtkMjBvRm91dmxZRjRQVVFaWHF4QVV6ejhC?=
 =?utf-8?B?dThvd2NoSmxDU3R1eWZDRUhncTl2dmI0OXlDWmJ1M05uc3d5aHVFK1lmc1hZ?=
 =?utf-8?B?bFJoYXp1dGpURW9JVk5RQnhpSUdITkREeisrVjVpemlaZU10YUo4OEUrS0xV?=
 =?utf-8?B?MWNQOGlySHB2c0ZJV05EOW9pcG91cWhEbjVKcGdQSjBKQnVpS1RUeW9KVFZn?=
 =?utf-8?B?Q3FaWVJLY3d0cTJpYklMUDVmZkMybnNEeFhoR2pwa28rWjh5cHY3VVBvc0NJ?=
 =?utf-8?B?amh1TUdmK0ZSN3daKzM0SkZvV3B1MTErSkR0eXRGUW5FSkZodmMwZ2o4LzFq?=
 =?utf-8?B?ZWpCTy9WN0dqNUhEVUkxZVhDRW1CUVkyS0ZhTHQ4RVlXVHFLcmU2eGgrMkdZ?=
 =?utf-8?B?WDdMamVlT3prRENvNDFwaEZ0VDVyeFZsYjNqTW1UQ3RLUXRzRFJIVWYvbzVs?=
 =?utf-8?B?L0gyVUprS1BxdldSMWFheEhhUS95WWJ1TW10aVZUa21TMFRsTlloTEQ1clJU?=
 =?utf-8?B?SytrZExOSGNxc2NlcWVpWm5yc1A0U29HcGV3bUhhQndQNEhnTm0xY1hqY0NB?=
 =?utf-8?B?bFdPR0svOVBwc3lJaEg2RmFkcXJGNUpIcGVkVTg3NFcxQ0VHVm0wRzJUSzhC?=
 =?utf-8?B?U2NRcVcvMTRiZXNVU3FZWlpXRHQrb3ZIclhVcFhpZDE5WHdUSmxGK2l1dmRX?=
 =?utf-8?B?QWNTbkRFbzU0ZUNmYURUK2NRUkNORjFTVUJnMnRnbm9lenNFaEtCcmZyR1hj?=
 =?utf-8?B?VTJWRUVJTTlzbXpPOVNYWDJjR3VQWnBidjJmZ3pCSnc0UjdmeWdvbW1nMXEr?=
 =?utf-8?B?MERtZy9WZ2xab0VhSkFHcUlTN2FxYld3czJRVGNaM1RlQWo3R2djTitremF1?=
 =?utf-8?B?YXc4V3EyZy9yYm15MFhjcU9BWkJJTzVrMkU3Z0tYNmlZMFVlRVB3L2hoRGtm?=
 =?utf-8?B?TTgzUmFCcGtmbFB0b2l6blRLeEZaUHhEMlVPMEZ2S1BObEthc3pmL01aaUZE?=
 =?utf-8?B?aEZlUkhzb1B2NTV6TUFBSlAwRWZqN2pxcnRhNlRWREtWc3hOQy9ZSFN1VEty?=
 =?utf-8?B?SWxnSk44a2ZHNHQwWlc3LzhBcFJBUGJLNTJETTBvZm1JUmo2TFduSndsMUdQ?=
 =?utf-8?B?Z2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 98b9353b-15b8-4747-3665-08dab21a4e52
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 21:38:48.0031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6fSA4hr4tvlWy4JIzeeEocO3UIMsA7Jm59JGgfkvxMt9pQ/3rTT8rA4k2jsDeuGUzyoPmMWoF0BJOILFYMA+mSVLARPLdVJvd7CSsP17HY4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7510
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
> Pass do and dump versions of the op to ctrl_dumppolicy_put_op()
> so that it can provide a different policy index for the two.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Makes sense to me.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
>  net/netlink/genetlink.c | 55 ++++++++++++++++++++++++-----------------
>  1 file changed, 33 insertions(+), 22 deletions(-)
> 
> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index 234b27977013..3e821c346577 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -1319,7 +1319,8 @@ static void *ctrl_dumppolicy_prep(struct sk_buff *skb,
>  
>  static int ctrl_dumppolicy_put_op(struct sk_buff *skb,
>  				  struct netlink_callback *cb,
> -			          struct genl_ops *op)
> +			          struct genl_split_ops *doit,
> +				  struct genl_split_ops *dumpit)
>  {
>  	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
>  	struct nlattr *nest_pol, *nest_op;
> @@ -1327,10 +1328,7 @@ static int ctrl_dumppolicy_put_op(struct sk_buff *skb,
>  	int idx;
>  
>  	/* skip if we have nothing to show */
> -	if (!op->policy)
> -		return 0;
> -	if (!op->doit &&
> -	    (!op->dumpit || op->validate & GENL_DONT_VALIDATE_DUMP))
> +	if (!doit->policy && !dumpit->policy)
>  		return 0;
>  

We don't need to check the GENL_DONT_VALIDATE_DUMP because the previous
code for getting the split op checked this and set some other fields, right?

>  	hdr = ctrl_dumppolicy_prep(skb, cb);
> @@ -1341,21 +1339,26 @@ static int ctrl_dumppolicy_put_op(struct sk_buff *skb,
>  	if (!nest_pol)
>  		goto err;
>  
> -	nest_op = nla_nest_start(skb, op->cmd);
> +	nest_op = nla_nest_start(skb, doit->cmd);

We always use doit->cmd, but that shouldn't matter since the dump and
doit are always the same command here. Ok.

>  	if (!nest_op)
>  		goto err;
>  
> -	/* for now both do/dump are always the same */
> -	idx = netlink_policy_dump_get_policy_idx(ctx->state,
> -						 op->policy,
> -						 op->maxattr);
> +	if (doit->policy) {
> +		idx = netlink_policy_dump_get_policy_idx(ctx->state,
> +							 doit->policy,
> +							 doit->maxattr);
>  
> -	if (op->doit && nla_put_u32(skb, CTRL_ATTR_POLICY_DO, idx))
> -		goto err;
> +		if (nla_put_u32(skb, CTRL_ATTR_POLICY_DO, idx))
> +			goto err;
> +	}
> +	if (dumpit->policy) {
> +		idx = netlink_policy_dump_get_policy_idx(ctx->state,
> +							 dumpit->policy,
> +							 dumpit->maxattr);
>  
> -	if (op->dumpit && !(op->validate & GENL_DONT_VALIDATE_DUMP) &&
> -	    nla_put_u32(skb, CTRL_ATTR_POLICY_DUMP, idx))
> -		goto err;
> +		if (nla_put_u32(skb, CTRL_ATTR_POLICY_DUMP, idx))
> +			goto err;
> +	}
>  
>  	nla_nest_end(skb, nest_op);
>  	nla_nest_end(skb, nest_pol);
> @@ -1373,16 +1376,19 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
>  	void *hdr;
>  
>  	if (!ctx->policies) {
> +		struct genl_split_ops doit, dumpit;
>  		struct genl_ops op;
>  
>  		if (ctx->single_op) {
> -			int err;
> -
> -			err = genl_get_cmd(ctx->op, ctx->rt, &op);
> -			if (WARN_ON(err))
> -				return err;
> +			if (genl_get_cmd_split(ctx->op, GENL_CMD_CAP_DO,
> +					       ctx->rt, &doit) &&
> +			    genl_get_cmd_split(ctx->op, GENL_CMD_CAP_DUMP,
> +					       ctx->rt, &dumpit)) {
> +				WARN_ON(1);
> +				return -ENOENT;
> +			}
>  
> -			if (ctrl_dumppolicy_put_op(skb, cb, &op))
> +			if (ctrl_dumppolicy_put_op(skb, cb, &doit, &dumpit))
>  				return skb->len;
>  
>  			ctx->opidx = genl_get_cmd_cnt(ctx->rt);
> @@ -1391,7 +1397,12 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
>  		while (ctx->opidx < genl_get_cmd_cnt(ctx->rt)) {
>  			genl_get_cmd_by_index(ctx->opidx, ctx->rt, &op);
>  
> -			if (ctrl_dumppolicy_put_op(skb, cb, &op))
> +			genl_cmd_full_to_split(&doit, ctx->rt,
> +					       &op, GENL_CMD_CAP_DO);
> +			genl_cmd_full_to_split(&dumpit, ctx->rt,
> +					       &op, GENL_CMD_CAP_DUMP);
> +
> +			if (ctrl_dumppolicy_put_op(skb, cb, &doit, &dumpit))
>  				return skb->len;
>  
>  			ctx->opidx++;
