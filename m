Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6EB6E17AE
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 00:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjDMWu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 18:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjDMWuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 18:50:24 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBD910E5;
        Thu, 13 Apr 2023 15:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681426223; x=1712962223;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2M7Mr7A5Az5uwUVA6vketj9xIbqdapwMUPihVBQWguw=;
  b=aqGo1Dv4gg5ghi4aaXJvC21HDESuS2RAH22G2qHN7XStQNGLsh+XUUN+
   +HDUsv5HKK3wT+LQfRA0tjcFE40oZcIW9oSz/PyQ/9RqNM1HoB0CiYlVO
   q+v66yyUlljcSz1owDijHhoqHHgwx6N3Q59dsQX6KRegSnROJ6l29Kh7F
   py+KF0DKenJ9DX36HyIzzaN16QdR17Bv8xsztAXKZDIRSEAJ5B0YwwzbC
   7hlqiYdUWNkZGadva+cdRHxBq3uWd2wgkIFBocQQvnliDhEO2V9TcXXCh
   9Is+8vulWlHUIGFbqu40cH8NVcgY4EmIJPOo94Ovkl5krEN8I1SF+Q2ej
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="346149113"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="346149113"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 15:50:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="689562601"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="689562601"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 13 Apr 2023 15:50:22 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 13 Apr 2023 15:50:20 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 13 Apr 2023 15:50:20 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.46) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 13 Apr 2023 15:50:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZ88baIs6SOtxMi/ARlyWFIdbp7HXyk8IS3brvrZewCcwAly0gm9PjZ143W7TEOTSqNy7tLLXeNZ4glCRL37Nr+5AxjaTtaLtyttIkQRh5CPrMKirkiEbEfHZDrDmaqxQDq6sXwAzLkWo40G3nudrKdDpse+sadHE16+K1iQh2ahV6rzLsYUTOeaoduDEnJUKN4wcC4DrefxhmBMuJAXY0lri8hpc0w+0PFeEfECvy/07SCbmjFy8rF6oi/eh9HWZSQnRD4HfMCIGkuTmSQxpoWaz9QAxbw7KupNMuLP+/HdDMWMzgnpVliHkCltXyx9SXqYFD62wf3LBcTV9MBnxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dtGv0EZfkjD5+rRc22ILBFvbs/v/tJpRrKRpiCXJhj4=;
 b=mKCwOtcY9iKz6OL54nf9ctSZxauQwKN45PVjsIwUzN1MZZYXaxXyJgGtq7FImlveWQ3a1uP1GBY1c9WASp7sXlPacFjv53G3TMfr4aFKcf1u/92rN9kFOSqp2DKMQmujY907nv3cpWCr9o0JIiIyjTSJTfePsuAHK7T37Ev/g+V9JI2BshkubpizQWC1/qeqDkRokz/gx7gyIAtuAhGFBo4rMOnWZ/DvI/Z59pwA3GbeHA/F7HqaRjREIinuCxk2xYJCDFCMjdB3Rm4siO2b7Oz9I059sSIYQ1L9Znb0OCdT7qhsYqx0aT3FSkuld3uQig5XgCOeEhVf9bK5E94CtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW6PR11MB8337.namprd11.prod.outlook.com (2603:10b6:303:248::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Thu, 13 Apr
 2023 22:50:19 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Thu, 13 Apr 2023
 22:50:18 +0000
Message-ID: <7e98e085-a167-f69d-5fcd-358157e1741e@intel.com>
Date:   Thu, 13 Apr 2023 15:50:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v2] net/ipv6: silence 'passing zero to ERR_PTR()'
 warning
Content-Language: en-US
To:     Haoyi Liu <iccccc@hust.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     <hust-os-kernel-patches@googlegroups.com>, <yalongz@hust.edu.cn>,
        <error27@gmail.com>, Dongliang Mu <dzm91@hust.edu.cn>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230413101005.7504-1-iccccc@hust.edu.cn>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230413101005.7504-1-iccccc@hust.edu.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0073.namprd05.prod.outlook.com
 (2603:10b6:a03:332::18) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|MW6PR11MB8337:EE_
X-MS-Office365-Filtering-Correlation-Id: 362dc9b6-2eb0-4e85-c773-08db3c717430
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pr+qcxOK9M+3gVSdu/e9VcRZienVmZm52+82REb7NAd6BMRzlqTFGI9/k8/GGxtqLLKw44Cawz3u1nSAJwpKBkXHG6/Yqzm/5aPXOE6q7tywo1QfzzB7/krjdg9HCFBA2WHLISkuJ5qPpd+VcP5cq3LdaHT8y3Ir4HJrU0fW4beoSd7bZc2fxBBDt/5SRORJ3j5KjVENPQiw1W4JpEWvI1ETMkyfL7W810F9OK/bzQHG+/tnmmDQs8hzjcHfxd+s61NAiBEgFNRPaigp4XSZSRnw0AbZkyRrANamw4OjxNLz/RF3GwKssKjC4K5L/7FiJvv+OIr9ihDT620vITtqn0d+lmlmT3ygj78OfVxHzkp5pALDunfrJqya97+RINQu/Tx+d61doQTVkSgCWQQ3fkD1P7UYIpo8/Sm4qi6/B1vhEEubCr9C7iQZ5uDQby5XNDGU4h03AXdfmFfpk4bms2bNFDP5afoqFSHkqqsvxz7+7ZayTCNuI7d0SyEIgDrsyq3mN9H2789S/xHEejeOONQGS/FbPrYlKtQSn79PhmmrsuVDTrOkeJBsrwt5c9Z2hrZozr7dS3kaBMOXC94HKU0SHoAVLHGjscUcpq6KUYw+Ve0Grzr14lk7suzmPKrk88tppx+hMBAc3Boy9EJHVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199021)(316002)(53546011)(478600001)(110136005)(82960400001)(6486002)(4326008)(31696002)(86362001)(6512007)(6506007)(26005)(31686004)(66476007)(66946007)(66556008)(186003)(8936002)(41300700001)(8676002)(7416002)(2616005)(36756003)(5660300002)(2906002)(83380400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ky9Za2ZYN0huM1RMaGZyTGphTzduQ2NydHhrRHlLb0Y3U3dId29sdHJoVUNy?=
 =?utf-8?B?V1dSSGYvc25GajJzNzVIcDEyS2lXb0NvNElEMWR0ZDZNZ0sveXh5OWlSVTdp?=
 =?utf-8?B?ZzZRZm5kN1MxM2k3MUJQbHNEUzBxQ0pkcXRRdk9VRzRqQm9yNmxEL3BETVRF?=
 =?utf-8?B?MVczZENCTCtUcXBNanNHL3IvWGNBcVVYM1JrVU5qUjdCQkVBd3MrVjlYeHJ0?=
 =?utf-8?B?QW55Y1phbXBaNXlvbUZBSUxhamdibko3YWhQTExCMWNxb0o4V0FwNXdScTFX?=
 =?utf-8?B?dkRmeDQzeXBXSUVjSmJ0SFE4Z0VhNm02T2pONkkrNXd0KzdleDU1Wmc4ZkE3?=
 =?utf-8?B?ZGI2bDNMNmVlKzFrbmZVcjBmbXV5eEFtU2V6ZlZrZFRtNlI0S0VVdytab2I3?=
 =?utf-8?B?ZEtvSU9Ua3BIaTFkbU5lcWh2SE94WlYya2pGbWtYb0xRc3pPM2RpZnN0bHV6?=
 =?utf-8?B?REQrTDZzdWxtUDV5WGFwRHd3d2tmdDUvODVQZUVtaWtmb2tzRFhwenRZN0o2?=
 =?utf-8?B?a0lYV1dpbytVdFI0TWxUTGFXdzJRMDNvZXJJd3FkUU5NaVY2WUFLVlpvMmJF?=
 =?utf-8?B?cjdGSDhZNUVVYzNhczJkbU5OMFU4Qm5PYml0QkZmdjlIbS90L1NFdUg2U2Fr?=
 =?utf-8?B?TEpETEFlcU9zSjEyUUdKKzFHcjJSUnpZeFRvMVBFM3VUZTEvcTNXRkd0dDQy?=
 =?utf-8?B?UXZqcnJEMVp4QUZ4VGM5cy9kcTVMNlpQeTJwN1dYZVl2amYrVGJzQlA0c0RQ?=
 =?utf-8?B?QWZVS3V1QXBxS1BodkpoWld2RXpoK3Ixc2VXTm92Q1o4SVdJMzNMMnVhZWxL?=
 =?utf-8?B?UUc1UG13dHZMV2FyOFJwYkI1UEsrOGNvMTBRZDRBU2R4ZTJFa2tiL3ZvODJq?=
 =?utf-8?B?b2FmclJXTUh2NU1pa1d2eUtRQXdENDUwL1ZoM3EvRDJ3eDUxQ2JvY3hoNndU?=
 =?utf-8?B?TWVqaGRTT0JOcWs5M2lGZlIvSFJnUzM5aHNwbVY3M09VN05xNml5TTc3OXFl?=
 =?utf-8?B?N3pjMVA1QXpVTUhmUnc3UzN6c3dEOGFGNlZ3SnN2MTk4YTRZb0xscUlGKzk4?=
 =?utf-8?B?dXNBZmFVZkpQcEs5c3M4eVNIaFcwVHExeHY4QlpOL2dkbFpYQWw4eXlSNUxk?=
 =?utf-8?B?eHFlN1RZN0JjSmwwVUNFUlRTdnpXOGtjOVdxR0NYL253TGNvM0cvc1lrcHIz?=
 =?utf-8?B?czFaRjJKMzNGMjliQ3hjNms4eGl2NzFOdDNibGNEV2ZOMFJGRUVTbjhsWVRi?=
 =?utf-8?B?RUpCNHhNN1drYzY1U20yVnJKKzB2UWtJN2dvTjFiZ1BPUW5xcUZNNzZ2cXBU?=
 =?utf-8?B?LzJnTUQ5U2xHdno1Mm1hZHVVWTltekVFVGJlV3psMndUSE5mZjBpUzljUjZG?=
 =?utf-8?B?M1NpZVdKUEFyWDVzNkgwc1ZlUEZwOFI2dkZoQ3UvcFdmNFRUa0YwZEloTnZL?=
 =?utf-8?B?M20zbGVvUFhkR3RCWllHS09Bc09PcG94UjZFNzZCbndoSDUvWjlwUE1yNFNG?=
 =?utf-8?B?bFdDcGVYR3Voc1pmRWkwK1lyejMzUUZoN29sMUg1REJ4MzUrV3Fyc29aWHY4?=
 =?utf-8?B?SEhIWWJjWlZVaXArdzdRaEJkRFVNRWJJSGZqS1JLVWJDb2p4TVl5S0FrTDBm?=
 =?utf-8?B?MnZMSXdrQ3pHeFFDcFJtNWtld0t6NVZFeXNHZTZxNU03cmNmTWZiMDV6TG9G?=
 =?utf-8?B?NENTNDFjemU5R0NJTUJTUW1pcmVwWm5rOWxnSEVSRE91RnJ3Vk5kQkp4UkZD?=
 =?utf-8?B?ZFdJQS84Qy84RFE1RjQ5MTExaGEzZFVPTkZVZm9kakt5cGUxTVFZOEhHdnpD?=
 =?utf-8?B?Sk1zQmZzV3VjWHBRdnhHYXQxTHhnQmdvQlhlcjRaQ0Faekx4RTFmL3hra1Ur?=
 =?utf-8?B?RDE4Z3VkSExJN3FNdG1GTzUxVkhSVmtkNFVpQldlUnFJdEZlZGRqZndqZEdQ?=
 =?utf-8?B?c1NyL0ZseVNHbUJVQzJBOWtVL1pMSk9LbU90UEdOVnU1c1FaeS9xbzJzRkdN?=
 =?utf-8?B?ZU1IMXFoRkxJNDFtRHVOc1IrdjNOMEJPcEN4d0lweDdNVXVyRHZyUUQyR3hY?=
 =?utf-8?B?S2ZodmliWFdxQnV6b2cyRDNYYWtVUlhmWnUyN09VZ0o0MHBzRFFCaUlRWWd1?=
 =?utf-8?B?RmE0SHdhMDFON3FZMCtnWnpFSlVra0NITjkrRzUwQVQvaURkQmhmNHhTT2lp?=
 =?utf-8?B?a2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 362dc9b6-2eb0-4e85-c773-08db3c717430
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 22:50:18.6394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Ual5gR54A0URyAVBjXFZxTX5cAoYbCU+471yZ5JNZ+VnuoF5hopeN1W4IxTAx9WyucA7vOAd8abbWnkWG/jUXHpKUMtY0mzNYmuy46YoaU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8337
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/13/2023 3:10 AM, Haoyi Liu wrote:
> Smatch complains that if xfrm_lookup() returns NULL then this does a
> weird thing with "err":
> 
>     net/ ipv6/ icmp.c:411 icmpv6_route_lookup()
>     warn: passing zero to ERR_PTR()
> 
> Merge conditional paths and remove unnecessary 'else'. No functional
> change.
> 
> Signed-off-by: Haoyi Liu <iccccc@hust.edu.cn>
> Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
> ---
> v1->v2: Remove unnecessary 'else'.
> The issue is found by static analysis, and the patch is remains untested.
> ---
>  net/ipv6/icmp.c | 17 ++++++-----------
>  1 file changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
> index 1f53f2a74480..a12eef11c7ee 100644
> --- a/net/ipv6/icmp.c
> +++ b/net/ipv6/icmp.c
> @@ -393,17 +393,12 @@ static struct dst_entry *icmpv6_route_lookup(struct net *net,
>  		goto relookup_failed;
>  
>  	dst2 = xfrm_lookup(net, dst2, flowi6_to_flowi(&fl2), sk, XFRM_LOOKUP_ICMP);
> -	if (!IS_ERR(dst2)) {
> -		dst_release(dst);
> -		dst = dst2;
> -	} else {
> -		err = PTR_ERR(dst2);
> -		if (err == -EPERM) {
> -			dst_release(dst);
> -			return dst2;
> -		} else
> -			goto relookup_failed;
> -	}
> +	err = PTR_ERR_OR_ZERO(dst2);
> +	if (err && err != -EPERM)
> +		goto relookup_failed;
> +
> +	dst_release(dst);
> +	return dst2;	/* returns success or ERR_PTR(-EPERM) */
>  

This result looks much cleaner!

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

Thanks,
Jake

>  relookup_failed:
>  	if (dst)
