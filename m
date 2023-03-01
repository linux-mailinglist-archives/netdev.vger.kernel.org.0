Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D536A7436
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 20:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjCAT1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 14:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjCAT1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 14:27:07 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B863D4DBE8;
        Wed,  1 Mar 2023 11:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677698823; x=1709234823;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VA5AI+a0IMK6/bsZx7/w2jj4OgK2xWypPdSxYuBXbCA=;
  b=WLcgVrOrWB6cxPcnrRoTV3fcTuEpNRrVMWfJJNamh/Yxl9veG+F4ENU8
   i5jB2Kj0lGmlrTkPzMIlFOBaHG1nSToUlhNM/Dl8VizixlnhzgC5y1h2y
   31FJLmB3Pboy9WabxHWnU9w3X/xyghj2aieN+3f10awNDVclzR/c90cg9
   OW7pUWBADuKZffohchapM24zbxZvNjFRxnjEMQhsAd2S3xtcSQ4BnVzGs
   QIkeB9Vsttx28AW0ITI+XW7M80PG5ZMM9kiclQUcHOua+f26Uobm+hbki
   bXvHieaoYEAM0wkT3NeKZaGtI+FC6He7HfGOcHHWUQxBUeBh7c0pRTwwZ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="322770003"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="322770003"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 11:27:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10636"; a="798529592"
X-IronPort-AV: E=Sophos;i="5.98,225,1673942400"; 
   d="scan'208";a="798529592"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 01 Mar 2023 11:27:02 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 11:27:02 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 1 Mar 2023 11:27:02 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 1 Mar 2023 11:27:02 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Mar 2023 11:27:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTJ6m+GnNQuixDjx47IPprrmaNPoSc4OXZzk/dyUoPZ2cS8wWKP9J+XNJnlyNkn4X/q9WSrxg5Kd/pJi0jRle4jmj7e4DtzPirqUdB0+bJd1TqRUi4TGquIJlOBYx9DKTq24z/k6ZxEYEcWD0pzLeGuLfrnuEKnwzYkvICyGrDtKCEE3cA9nj929s/pzs6kMoy8b0PjpbbnScbhP8x0b1T/5Ggi0AcQtuFKzhDVPDbJW+FtNkNyGIPa5kc/A3x2/OpOATYQi+GlROLB1t7v74a7HxXeKQY06RYlS2lKv4v1ZC8dvUl252W78I5L4WTIx0+ZVsrmgeqNaaHYlRJE3lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7UygToaJLeVccmVAMx0eTga7mjHMskNqRCDSezjClTY=;
 b=Ftsr7PVA6NzA0F9/Pb9MUGjXzCCFQHgAL+oM/zP9IjJEaVIjU8QDZg1ZzJ+CuJyUbfSVQDUhonog7KgJGGR4YWS0BlNGaI+k0yKHS7w/XVgCzKDmi/Ter9VOrvplg12/fZQOAKLuQx9t8eSRzHKxD4tESLFCkGo0eszabprEG6mxhuWRWDBV6yYetUZzyQsEu9agTPefKXd9iEOrkQ/AJUiDa+uoqfaMQFe85tMcDkQonuBrQwoQ/BNP/vARxuKJ3mKA4P3mBZ+jQoRLMcud3BSEup62+flPKTfi0lwyE0YD3JuoGnd8ekGgO18P+FP863i7aG8BkMru0LyASNcHlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by DS0PR11MB7309.namprd11.prod.outlook.com (2603:10b6:8:13e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Wed, 1 Mar
 2023 19:26:58 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c2c3:34a1:b4cd:b162]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c2c3:34a1:b4cd:b162%6]) with mapi id 15.20.6156.018; Wed, 1 Mar 2023
 19:26:58 +0000
Message-ID: <d062a735-ed89-d437-16cc-ca7456c7de08@intel.com>
Date:   Wed, 1 Mar 2023 11:26:55 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net v2] ice: copy last block omitted in
 ice_get_module_eeprom()
To:     Petr Oros <poros@redhat.com>, <netdev@vger.kernel.org>
CC:     <aleksander.lobakin@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <scott.w.taylor@intel.com>,
        <intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>
References: <20230228204139.2264495-1-poros@redhat.com>
 <20230301171452.2514734-1-poros@redhat.com>
Content-Language: en-US
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230301171452.2514734-1-poros@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0041.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::16) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|DS0PR11MB7309:EE_
X-MS-Office365-Filtering-Correlation-Id: ca64a7ae-95b9-432a-f28d-08db1a8aec76
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AGvTk7B8g4fC9BetNvdQOVLxpjdw6TYkXjtiI0odwI04/pODxP4cjSlGl51CmptIio5qhpRqezcckIDtsx42cUNpb2FQQXL/KBAnXfLtrd33d5Y8nV4LGXTdToXFlNzK3Jh1x12hs8BSprCvucAey3u9pr1oN1CDfl/69QuRJICJZwdjO8gZTLbZemEN6Kn5Z6TN5oINgwtaUJ8nxz8+bMqr+xWCcK6hgwAQFR4+FnhVc/4X+Ua99qCANSf+vR1JSRkLrW2KfLmtYrcmWCLlvGbaM+4lIkNc7Pj1HbkMNOvgTeiHgFpMPJBubyIK+09BX8uZMKrbVU4YxCUM09M+qlgIROuZGS+b6gUS2I8L5srvktNi76yPymF7H8uHW7rx3xV5LeK6FrMud7lnkNhi2/i3tibcCwoUr4EWl3P3ypw4j2gYsvHOtuxtuE1NPCUwEnNzFfSNWxZTXtY7NQ44Wuh1RQgTM1QFmNCBVKmXT50vW/U4EeKpD0QR5noTdiEJc693pZZMTNqtH/LC/KDuGFni3bKK1XXgnnMALvlxNiz/XNl4BHT4gQczPcOJ0zfNpSsBXRZrLPR8t5T1Rcw+ElOf80s8RLel+oT19MsHLfCucCVy9r3fQ2B9f/PtqRPNQPDQgboShyqYZSA0wyvEudzJPkQA8sSxiaOmOIlEi6Rl8RlmMxSIkNsQ2GDFKqjDlmRZ2J9KpdcCd+64nXMBtlLOxNusB6rpAGQS+0BPMag=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(39860400002)(376002)(396003)(346002)(451199018)(82960400001)(38100700002)(8936002)(31696002)(86362001)(36756003)(44832011)(2906002)(66476007)(4326008)(5660300002)(66946007)(41300700001)(66556008)(8676002)(53546011)(186003)(6512007)(6506007)(2616005)(26005)(83380400001)(316002)(478600001)(6486002)(6666004)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGd0ZFJIcDErRHhubG5MWDlZdWRDYW85WUFXY3NIOGYvc05nTTBJWFg0S3JC?=
 =?utf-8?B?di9odFJmWVdqZTdhc2FWRGt0WE0yQ0hEZjdWeGthKzRBODI1UWNraHlzNHR0?=
 =?utf-8?B?Tlp5blhwWVFIYzhpZ2NJWWllY24wSWtyZUkySEwvazhzemZQWnhQYzF3QUlR?=
 =?utf-8?B?ME5oUlRaNkZraFZFL1NMR1BsRFlqQUpRN05wbXRuT2FocmtkNzUxenlyR3Bl?=
 =?utf-8?B?S1VIWVFGVTJ4SjFYWWtjc3lzWEw5TmRkbW1DU0ZaWlpVWlpTcVVRZEgyOFBa?=
 =?utf-8?B?K0lFUnFqbzZ3VW5HQjl4dGt3Sys1OTlOaFprYW9VWnorV2drMHhwQiszU0dh?=
 =?utf-8?B?S0c4ZzVWaTArYUROUkdTQnBtMTBoaUJ2VVRXSWQ5RXFQWW4rTDlxa1V5cDZN?=
 =?utf-8?B?aFdGMDE2UzNIUmhMempGRE9XeVRDMkI4YXZvSjZJTTJyejNyRnJmTzVLRTZP?=
 =?utf-8?B?VjF1dVJYa3ViUmN6M2dlSHVRUmxZaDMrdHEzeUtSazI3L2FGYjVKVXF0VFEx?=
 =?utf-8?B?c3VWam5idS9RbFNaOFo4akdZRWhmYnBqVURPdTJKMlIrZndhNkREdEkrWUk5?=
 =?utf-8?B?TTdvajFob216cExia1BTRGNSYTRFUW8vd29ydWMyRVRqZElNSUw4Tm1LMmNN?=
 =?utf-8?B?NVNKT09GaWZsMWRBdmpPTGlEeFJ5NlVoZ3dQb0hzMklxWWhYbGltQTlibHZD?=
 =?utf-8?B?MllQMDlUb0owQnVSOHRSdUMyMUFjZVg1RlVhT1krTGNzdVd6NGd1Ti9EYWY3?=
 =?utf-8?B?YmxyVTRNUDc3djh2NytaeUVTdk1oVlVsUGdzeDE5L2hxcW55RFJBM2Z3cXo0?=
 =?utf-8?B?NkNFUUE0Rm05T2hHaXY1eUxXMkhMRWkxUm1kVmpIYUtidmtzQWpEdGpwSGVC?=
 =?utf-8?B?S2JBZmdnd3lqajZaQ3o0ZisraUFTWWc5Qjc1ZHcxQjFLN0JPdm0rd3JlbEg2?=
 =?utf-8?B?RTdoVE94WXM4R2VzTmdSUjFJNk5pVlpXMHZaOHB6VzJ3NjZ0VHRqSjNYbjd6?=
 =?utf-8?B?aCs2cmJxM1h5RDNza3dQWFVyc0Y0bWpXRlQrRFU0bFlhSUs0c1FhQzM3OCtZ?=
 =?utf-8?B?MXBHbUdPR3ZNVndiL3JNUWFUZnVZSjdLUWIzNkltdWR5VGpUWE9nVnFPWWg3?=
 =?utf-8?B?ejVDWDhQU2tjNXdZSEJSQ3ltWFBUSmtHRHNFNWE0TEkyWGZRallXUTlObHox?=
 =?utf-8?B?SGlYa1FBb1VCTlBnV3JiZXRlOUJhdU0yZm5lT0NjNmFRQmxJVERMSEJSQmNj?=
 =?utf-8?B?SE1ycThMYm5ucVcxUlJ5YnVPV2Y5K2NZdzA2eU5WK1JONVpPaGVoMHY1ZVgz?=
 =?utf-8?B?eTZiUWVHRlhzVmZwNUw2d1B2VUgxRUJLczFJRUNVcUxvS29rSXFDc3VhMEdI?=
 =?utf-8?B?TTFGczBrTHZxOFlEY2xwYXpLM2xGNWsxRURKN29PdlVrSXVPeWdYbGNiQ2w0?=
 =?utf-8?B?UEVWQUtLMjdQVE1WR2tpdThieENGbVZEWm1pTUl5WHpvUmFuMjJzd2xtaUxq?=
 =?utf-8?B?UmJRUFVTRUpPUGdkeEsvZGx4OE4zQW1Pbm5zNWNIM2I3MEtLempiVnA0VXRK?=
 =?utf-8?B?Y1owQUdmNUNLQXFjczhkZ3V4cUpaNW10VVRzNlZzMU1NcC9uNTVSS1dXQXlU?=
 =?utf-8?B?dDRXUG9tSnYyTG5JNUQwL2ZBMDFYUElPdFdVUUEwalBBbFM1aGhJUG1abG96?=
 =?utf-8?B?eWxIeE1PSFdOQm45UTFYeGwrV1ZrcmlKMzJrTHpIMEY0NVhIVXZ0c051MFBN?=
 =?utf-8?B?NExvbmJZYzVDSzI0NjN2OTlkODExa2hZeUg0aWFScDRGT0dFbGszUmdpL2Q1?=
 =?utf-8?B?WVdBazl4NXlSRnNGZXNRU05NT2xoNjNXUUt3c0I2M0tmUit1R3l6cGVoaExZ?=
 =?utf-8?B?SVNCNXN0ZjB3U05PMUhzL2lldjMyL2hGTDdVU01kdWR6eFFNZjcvZkRDQ0Yv?=
 =?utf-8?B?SjVVbVFyMjZFZGx0SGVHSDhYUzVWVUtrNCtmdGJCclYvMU9XT21sblgrWUJw?=
 =?utf-8?B?QUZzbmcrcnI0Z3RVVU5ydUlWZ09sMlY3dTI4aWdRUnRTZ3AveWlIa0l6eE1E?=
 =?utf-8?B?RDlkQm43RjRNVzdDRkZMSE5ZRXpYSnBDMGlxWTFCUlB3OGp3VDhVNWQwRnhO?=
 =?utf-8?B?Z09mbElMaHloWG9NWkRDbXJHbk84TUJTVHRIVy9KQkd3OW9ubklPMHV5OVNa?=
 =?utf-8?B?Wnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ca64a7ae-95b9-432a-f28d-08db1a8aec76
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 19:26:58.5738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2bPUTeDQhdZr6fYnL2yP2yTFAWTiljJVjK2jT3jDIxi+1sNP8GnvKDl5qZL04V8KP/ao9BlaWEsLWRPSNgrLjZEzZXEmfhkwOEjzAva8v5k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7309
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/1/2023 9:14 AM, Petr Oros wrote:

>  drivers/net/ethernet/intel/ice/ice_ethtool.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> index b360bd8f15998b..1dc3f9fc74bdfb 100644
> --- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
> +++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> @@ -4293,6 +4293,7 @@ ice_get_module_eeprom(struct net_device *netdev,
>  	bool is_sfp = false;
>  	unsigned int i, j;
>  	u16 offset = 0;
> +	u32 copy_len;

copy_len should only be declared in the "if" below so that it's only
declared in the context it is used.

>  	u8 page = 0;
>  	int status;
>  
> @@ -4354,8 +4355,9 @@ ice_get_module_eeprom(struct net_device *netdev,
>  			}
>  
>  			/* Make sure we have enough room for the new block */
> -			if ((i + SFF_READ_BLOCK_SIZE) < ee->len)
> -				memcpy(data + i, value, SFF_READ_BLOCK_SIZE);
> +			copy_len = min_t(u32, SFF_READ_BLOCK_SIZE,
> +					 ee->len - i);

also this line can be unwrapped now.

> +			memcpy(data + i, value, copy_len);
>  		}
>  	}
>  	return 0;

I've tested this and it fixes the problem. Interestingly, the ethtool
application when compiled without netlink support parsed the output
correctly so caused a bit of confusion around this issue.

Thank you Petr!

