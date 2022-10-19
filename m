Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D764605205
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 23:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiJSVdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 17:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiJSVdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 17:33:51 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E35218F0E4
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 14:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666215230; x=1697751230;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6qdu/k7I9QFy7oQ4vGhYqF+9JfkDjeHGMzLH+D50ttk=;
  b=IgnkJ9WwBadKawdz5kfz9t/hDWWVPECwl3C+xZvKY17xITIGvmGGN/i9
   jLWlaNejeu0tnDjQewyIEKJCbTqlRfiHG0vGtYTkjUk4CufsjGIsqILDS
   DDBLtbOySeOnzO1eC2CxdF3i2rwBkQCdl+mqJWZs1ZK8UtMw/d0GKqD5e
   wU0IA1s5yd/izv54t+xphNcGD0Mfq526bujvXWtlJ5HipzojvmlPm/1XB
   3zSCSQC08KKAJb2Lo/bKqxDOn9lDOkl4FeqmqLGb3yU6oJeFf+lRIsCyQ
   UxETwEb8BNhxALZ31LNlmVYPtNgEEokAioTnH5vMu9sgTjB7nd8LF6suQ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="333097974"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="333097974"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 14:33:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="580535183"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="580535183"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 19 Oct 2022 14:33:49 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 14:33:49 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 19 Oct 2022 14:33:49 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 19 Oct 2022 14:33:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DhRBVqFrsrjc4Ma6xCr2pW7XWNnhdOu6Frigx7fRI8r6BKtDILggkoPHYtfhazPYKXsJt5GV2s+866XMB31bRF/1FNeyKuJh+ga3rdN777YrKOpCLiBZYayF96igxaOIG56P8xoup3h818+ij3EHq/m7NyDY8Nqz+OOVpyz4rpfQJ3g8KZyOA4WtGcDlBNRaQMbo/DMLYG+r5kz/ar9HBGSmog7vwm2Fyyn9EOE6BSJI0tDWGhylKLDPO8e30ncd4EXb63jcgvo0rnuv0kV+7NQFPwAFXHDnlVE31b26d9NvgYAY3/UqkAZciLDhOdgiupHKYEGOvH6rF+IdQOHIfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=32ftYFU+4NAc/xhExpm1CmZxgQU+25sHfJ4GobzhZio=;
 b=S6EyMQ7HwkzWmm8GYn4HUlap1mRjGUSzQE6tTKU35NHnjG05q3oXilZZCCP0BpHAIms2R/vxLCVSoAzn5BsAnT+B99d8aFYvmmvrLxbwCwlib/5oy811u+lmkesgPtHCCqxBGN9YJBSv3EmaQ9WxItT1FSY7IdxP1MfP+eYiVcOUpaR3F/8gboEGqZsbUtnxhBEB/1ZFcIE3okWGPNRl4GPGOD8+N9k+bzfu+5SQNn9N/h9fL204FrsM89RTzedyyx9ybah/H4yL0CVbRa64u07jAOP2/PW9BjHrv2mOqfYugjdzRiPfjaacfV8KOIttEYSXMM6sxzpB+Q+4IkxE+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by PH0PR11MB5594.namprd11.prod.outlook.com (2603:10b6:510:e4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Wed, 19 Oct
 2022 21:33:46 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf%7]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 21:33:45 +0000
Message-ID: <61006364-2cde-3b9d-8a6f-6e7daf99c55f@intel.com>
Date:   Wed, 19 Oct 2022 14:33:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.1
Subject: Re: [PATCH net-next 05/13] genetlink: check for callback type at op
 load time
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>,
        <johannes@sipsolutions.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jiri@resnulli.us>, <razor@blackwall.org>,
        <nicolas.dichtel@6wind.com>, <gnault@redhat.com>, <fw@strlen.de>
References: <20221018230728.1039524-1-kuba@kernel.org>
 <20221018230728.1039524-6-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221018230728.1039524-6-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0198.namprd05.prod.outlook.com
 (2603:10b6:a03:330::23) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|PH0PR11MB5594:EE_
X-MS-Office365-Filtering-Correlation-Id: b9a9d28a-d929-4916-63a4-08dab2199a36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FcVnOTuVqly0ySET3eyPRuLxzpa25BesAKSL7RCc72APTe6kKDK97ub9mJB9/piP4S+BPgQGAk8PZ93u72JeDYGVdeODYkb+C9tRmXRU1iuGGV5xLonrqvxLZfL8rOvDVCDCJFPrRhbqfNeIHdaRaFOHkhQ621fQHf/0FKuQkXjszEC/xce8o7oGqRkrRiRKm5bD4lq7U8bvNntg/ly11tF9ViQMtUevhLRl8yPuo2OuagqWo5FJQSf8Bj8N5j9oETEaQqYsHDK6TGdCoF6RaQQFzLWa7C8kFPs/rwMy8/pxtbrsdgF5A4MGNVhXMg3IQfZ1ilxX5s984Ffe04qEYH6Ux3z7k46a/MdVGWdSej50q0gVSgvuAKygbmJ5g9g8RVBBiV3Pno1uAUUmRP55ZOTqbLJ8UwUYszBkwaHHgOUFv8Fy/EoYblBPBuyhV8iohB/0JBMOD0iJrKQabkA5VfaTTB3H+qh6v/2zmO4TxeXLuQupO/x6KZWW5+ErhrAzMOWuX7wnfTZZOEfXBQNBLeye38DSteS1+n8A8dG8HO1pa0ECCwDvUVi7+CWbybbD2Cem93K6qq/YXSTr43T9vnA9SClR7cTL5j0GeimerkkjmYGPxm8v/HUl5key5lXwFYbC/Vsr4TnvAUCCrNlXdOXQIuCJdRHMzVM50wuBeFCzkt9Ut5kHQPYO5DOKJYYOfm9mT5h3ZRLgQk/1in85YSDePIjUjWd21DznECM2FdZ3jF63TU+NtsDAeByhLaIUYUD0D9I/FBPTcJ6LDjg8BhRbwzmN1fyMtjF7cSotMJw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(136003)(376002)(396003)(346002)(451199015)(478600001)(8676002)(6666004)(41300700001)(6506007)(66946007)(66556008)(66476007)(316002)(6486002)(4326008)(186003)(26005)(38100700002)(82960400001)(6512007)(2616005)(31696002)(53546011)(86362001)(83380400001)(31686004)(36756003)(5660300002)(7416002)(2906002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eURGRm1NdkJDbS92QUdOd0pqcXJxUWZPT0UwZmtsdlh2QlFDb1RmN3grS3Zi?=
 =?utf-8?B?UForbHJvVHFoL1d1US8rTG9nbGZNSGNqOXlPTnhvYVM5MmpPbUJyajdFa0Nj?=
 =?utf-8?B?TFkzdGJOTDNBSUNmR0pWeVZmVDE5UlkvSVppUlJ2cjQvRFQ3dzd2cDZRYkM0?=
 =?utf-8?B?TEJldFoyb3pNbnFscy9jU0szUjZLMXNtVVdOTUlMRWFxQ0dhUlNBNVBtbnpR?=
 =?utf-8?B?ZW1NUytKaldmSFFaM3E4VXJEd3BQTUxQNzdXeHpVR1IzNUREeXhZcHlUbTBL?=
 =?utf-8?B?RFRtL0o0L2NueGx2ak56c2xyVUFVdUZSTGJmSmIrbXdXVUZ2R2hwOGRVWTZ6?=
 =?utf-8?B?Wks4WUV2ejFpMmhkd3JWemt3WS8xdDZJeFVYR2dZRWVkcEpzVXoyZitWQjNO?=
 =?utf-8?B?TEs3SHlNZ2d6Vi9VcHgvRTBKbUxzc0dNMFE5a1BvWkhzaTBSVFpmcnh3YmZn?=
 =?utf-8?B?YVpHVG9XQ1FSdTBKK0djN2lPRUdUQ0JyeStxa0VsbXgwVDRJODhaMVJSZXR2?=
 =?utf-8?B?cE90aDdQNnpESVYwWkI4WE90dndIb3phR0ZNa1Z6S09LTit3OU43cW9YYXFr?=
 =?utf-8?B?UGVobDJLQTRYS0FQMFQ0T05RME1DQS85VDIwUDBrdGZlVC9Ta2sraUllK1hu?=
 =?utf-8?B?WUZ0dkRvMEtpaFhaY3hFSEFvY1RPQ3dMV0ZoeEhnUlJxUWc1NjR0SWgrTTJK?=
 =?utf-8?B?VUlhZ2FmbHJVcDFybkxNNkhzMEZ0UG9kTlJYQmEyd25ud1lETHFZWUdsNXly?=
 =?utf-8?B?c3dqZlExNmlwbWkrZm5sQW9tZzRjanlXcHFGclVORXRqMGNscHg1UE5FRGFx?=
 =?utf-8?B?TTl5MHZkVnFOR0pBOVlUeWxvejh1RlFQV2lJbzdzaW9sL2xKSTA2WlJLN1gx?=
 =?utf-8?B?WlU2QWxEalQ3K01Rb2xwcWJBNnRjWEpjdHJnTUNVOFhGMW5idmlTTHY0N21B?=
 =?utf-8?B?V2Ivb2tHdnRYU2t1Wk9PSVNkd0c3Y0MyR0djOUk5bDJBNlFjYXZ6SmQzMmM1?=
 =?utf-8?B?anptT214dVdKOC9DWWFKTnV0RkFka09sWXVnbHpvNDltdFA5UThLUEZPdHlO?=
 =?utf-8?B?REhvd3BDeXFnZGZmenBkcDc2aTIvdm5hZWViZG5nTlJDWGVtNGRSWXJveE5J?=
 =?utf-8?B?Uzdac2JZbS9PUlFOazFjaWxTbGxNZVVlRXlTbHZ2bGZNSUM5bG1jMXBDdlVS?=
 =?utf-8?B?dG5IbE5HY1Z0VmZHVnNWZGZCcE1Hb2pwUXRPQWRXM09yM2xwZFQ2Q0pTd2xY?=
 =?utf-8?B?SEk1b1kwcWNpSnQ1UjBXaU8xdjlZK1lnS09zYjBRSldCMXlDTWdTY1VVUGNZ?=
 =?utf-8?B?TzRIK29QQjRaSVF2RWcwdWlrMEd0Tkc1SE93ZDZiSzdRVm0rNUdVbGg2eUFy?=
 =?utf-8?B?dXo4cUZQeEpZMUZzMlhxNnZIbk95d2JzSi94RWZUUERUSGQweFlYZEFvWUFR?=
 =?utf-8?B?T1czeXRSUHpnVVhscllZRVdjbnlUaGdtc21VS2lZZUpCRXRwNnE1YmdjUzN5?=
 =?utf-8?B?bktlODFqNUpsTEZxeXFob1hUQ2x0d0JPVFhubGRJS2ZzL2d5dExaVjd4dnd0?=
 =?utf-8?B?M3QySXBJQ3NZYU9PanFiam9FbHIwVmtnSWlESUhPYmtyZ1NTeTZZZjZacm90?=
 =?utf-8?B?VjVDRGhqKzJyMXc1cUIwL3JScmxwenB3RDRvNlJkMElneDBzdnZkZGptVi96?=
 =?utf-8?B?N1hERDloM1NXWU9ySTlGSEhMSE81MHU3cFhZZ2w2TTQ1dkhYRzFyZXJoaVdO?=
 =?utf-8?B?bmlPWUxOeGdRVTlTZkx0TVpCei9CZTJDeUpxV2RkQUJtVFBEeDJ2SkxVdVB1?=
 =?utf-8?B?MDQwajhVLzMrNDdjYlVjWVhBdWNOT1M0QVhCWmo5MHpORVd6RFZQbEc5Yy9o?=
 =?utf-8?B?TGtnMjJIQkI3NXFzN1E2TjN1Z0xaZ3lMZm9tcFVVc21zV0cxQnRuOFROazQy?=
 =?utf-8?B?QXVHeW92aldrNU1kZnlwc2JJUXREQURLTWlCemQxbHo5Vjc1YXFLM0c1dCtO?=
 =?utf-8?B?ZjJQOFFCNUFWQkczSzBmWks4Mjd4K08zZURvSmhSQlh3RTMvSXFlUUI0UEJR?=
 =?utf-8?B?RWJBT0VyLzQ0Sk9rL0tEaGRTRWNDV01BemRTSmhJOWZjY01oVDNQZjFCWWR1?=
 =?utf-8?B?WG0wbUwvVU1wb2NqVnllakRXaUtDSWhWcEw3ZjV6MHk0ZHR3aHVVU2lMZElS?=
 =?utf-8?B?V1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b9a9d28a-d929-4916-63a4-08dab2199a36
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 21:33:45.8778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oEtZAFW8vEu1IViZ02rRHwF9l6JvNQf/wNXGhyNt96nyCFdxX75Hxhut+VcucNEOXHT0IyhfYNqtN4O3aaJnBdTrVnYKMlDOU16nf1v8WYY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5594
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
> Now that genl_get_cmd_split() is informed what type of callback
> user is trying to access (do or dump) we can check that this
> callback is indeed available and return an error early.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/netlink/genetlink.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index 26ddbd23549d..9dfb3cf89b97 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -166,11 +166,17 @@ static int genl_get_cmd(u32 cmd, const struct genl_family *family,
>  	return genl_get_cmd_small(cmd, family, op);
>  }
>  
> -static void
> +static int
>  genl_cmd_full_to_split(struct genl_split_ops *op,
>  		       const struct genl_family *family,
>  		       const struct genl_ops *full, u8 flags)
>  {
> +	if ((flags & GENL_CMD_CAP_DO && !full->doit) ||
> +	    (flags & GENL_CMD_CAP_DUMP && !full->dumpit)) {
> +		memset(op, 0, sizeof(*op));
> +		return -ENOENT;
> +	}
> +

Should this check that exactly one of GENL_CMD_CAP_DO and
GENL_CMD_CAP_DUMP is set? Or is some earlier flow enforcing this?

Thanks,
Jake
