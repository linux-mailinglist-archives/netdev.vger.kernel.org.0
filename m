Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E86264E1B8
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 20:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiLOTYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 14:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiLOTYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 14:24:09 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D52443862
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 11:24:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671132248; x=1702668248;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Q+wNnRsUzpfs8itk+0LQHHui1EkakZ0//8BGW6frARU=;
  b=d75xUfZ5nJiFrIhuSiTEAW3jZLO/nMdaJZ+pkbcvil6nI9wTWGTMlfva
   JlIT/SRMFLgI5n0C21KBWipNF0iXoVd2LdGfq2MgdRkGBxGiNLyoekWin
   7sjejI6cW4+g57wcZSNrO0hv7sc+90SlmbgFop2zkM8XJFX/jJI1Fny4o
   XIarSRB+ccXbmQm6pKfbU8VkYzFTIA8CquVRKXKGauduk3jtp3bcxcJoK
   gFw12w29XLaV7x+RU7PZi8jXzH+fSulVpLqrK39Q+9lSpHUVkAXcRzQ32
   cEAYD/367TV4W7P2hmkPNQIuRPLtFcr+h9LsAUP6hC2A01X3Cx2YD0P/4
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="319948926"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="319948926"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2022 11:24:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10562"; a="680212318"
X-IronPort-AV: E=Sophos;i="5.96,248,1665471600"; 
   d="scan'208";a="680212318"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga008.jf.intel.com with ESMTP; 15 Dec 2022 11:24:07 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 11:24:07 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 11:24:06 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 15 Dec 2022 11:24:06 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 15 Dec 2022 11:24:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/VZB9dxcyAnI47909ydQTsuPymWPi0K2jXxFFNIK3i4hVCZt2POlzDcaxWOzvFPz/D8cjFNiNiKVX0t08Va/cUF7WNIkm7qU4FoUANQ9bfyKgDLn3Uvq54eRfe6EQntXIgN+BisByYOjJpn3LoeVQFriEQ2UBhDIFBDwPxmwurRPUBYnVJX0Epr93AyKgOTh92wWD7zCzzfYk2/DMn9j/M8yIESzUOgGp2iwEm2sML9SWELVMPgC7BJfLgP68S1hdwprPiAOZs2rdNxopxIeZlRVr3e+zXFvZ8U1kiN7FjFoGZDz45TZnCnpBPpQUdKgtpqGBGyBUCW4LISyarEmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eH+3fgRxT/aQYe6riItUPouisB0um5zNzjRvNU5SvB4=;
 b=k0Ee+a/a/8Dt8EKoNAXeoZK00NNCBWjERa+dAXIDAsAKaqKC2HF+P7FQKVTmx9pIok9us8BwKkFwP1k8h5tFhILrBRkA0H4/dodKIzgW8ljGjVHPXt9Rxoup0DZL6Gx/hmTWDvZJvS8ipQZvI3sUDOzUwCUaj2StjCi3YtT5KUP98e17WXmipMc6hkeE8eY1P7yGO82heYD2X4QwvseQSQI0H2AOx9t9cn6AJDGeZot2DyMlRbDBLWSbO1avyD+af2LT5WVAU9QQIZ6FlS1vHkse+QCbiZGedBGhy/VRIoOHRGh6Rm8UUUK4KYP31uwV4ahaBBnw3S+hCbSVuPYtmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SJ1PR11MB6084.namprd11.prod.outlook.com (2603:10b6:a03:489::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Thu, 15 Dec
 2022 19:24:03 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%5]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 19:24:03 +0000
Message-ID: <c61b9138-f8ec-4c99-663b-d26fa4f1d4a4@intel.com>
Date:   Thu, 15 Dec 2022 11:24:01 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RFC net-next 14/15] devlink: add by-instance dump infra
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>, <leon@kernel.org>
References: <20221215020155.1619839-1-kuba@kernel.org>
 <20221215020155.1619839-15-kuba@kernel.org> <Y5rkpxKm/TdGlJHf@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <Y5rkpxKm/TdGlJHf@nanopsycho>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0149.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::34) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SJ1PR11MB6084:EE_
X-MS-Office365-Filtering-Correlation-Id: 702fb748-11ed-4575-ad10-08daded1ed1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4GpolYD8N1DimLoO68PlaqhTEe5byOzWNkqYvuZJpe6/ymHHh5X5Zeo9BfIriYu6/7Q1htF4cGeZSyfgTVsILxsfms+C3J1uccbi5FW9Xf/QzfdFj7IIYU/Q0xUoqjdmNKaMQUdypH/yQ2c3cWw4TSThhEbG9ZTogFKcIzONJuIgwzgxIKUGk9ya0WxJnZgIiPhJFvIW2zpEQ1sf+UMDrBr/ZIroB28ogdtBy0+ygaYcdB2LRlncEHFehlbB4zIwjOqLoLP/f8mgZWjeJx2jAeyXcnzBGoURlh/k6KphIEApJCEWccxJSCFYUHOIfiaA1aueL42VmRYF7RNZMlewQLB8Jr1p4vlJK5VajpWPb8vVZePq8+9cjEITGH8Tj5TWlwwQcEbN9lR6seJFa/MVyOnVY/TURWvWAT4UzQ/T8ab61BL40OYAZ750DvEUlRH16pr6jnJ22Y7dNULpXYInzMRZ2j4P63TL0pQ4LRNZAADum1eiw6hcFgaYCRRsOGVWQYyRhPaze4R3talZ7MSvsnRiOIkbTkYbKo2TSTRFSYQT6y1adJwe1KCxg7CzC/WwamcBTq8KYyXkxjjJVlXcK3EtevNtN0hHxC0K0IURiykgYcIRZ0UH08rflGJCWNXdzXm3Bu4/3wKHkFcnzH/lVJISAXN4CoycWozvc4ebVYBEW0+vYJju6J4ya4Y20Gw54Lr4DTMOT0PBjrxwgPUmKkI/Xbj7PPCmzeXtCq4HjJw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199015)(66556008)(66946007)(41300700001)(8676002)(66476007)(4326008)(5660300002)(316002)(2906002)(8936002)(110136005)(53546011)(26005)(6512007)(186003)(6506007)(6486002)(478600001)(86362001)(83380400001)(2616005)(38100700002)(82960400001)(31686004)(31696002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFhxQmNlWFJiOEVtWXFHNWxFL2FIWEZhZUEzZUhoRys1Nzlqb3RQcTlrZE11?=
 =?utf-8?B?VUdoK0FMRDVoeEJsc25uR1Q5aTh3bzUxSWxkT3g4MGs0c0NiOHViRUdWMEZM?=
 =?utf-8?B?WXhDZG90K3dBbUlkZ2lyL3lOWUx0azVXS01tOUJia0pjaW5MNnFHNUJEV0hE?=
 =?utf-8?B?L0p1anZnQ041dUwzNHVIaitDeGx2UTBKaFg2WFFGUTlZcmRNNTZUMDNHMGVT?=
 =?utf-8?B?ckkrdzdNWTlpY3p6N3N3RFJHMGNTUS9paHlBYlFGWmJpRTRBWWRsWmdidEll?=
 =?utf-8?B?UXl0bi9qNmlseldYa2ZiZW4rVjYvM2pzNlhJQ0RpL3lOK0IyeUwvYWV1OG1D?=
 =?utf-8?B?RnJWM0VxVno5WUdCQ3NmbStFMVBUTlFWdDZHaFF4dmdreG8yYWNPbHRGRXhP?=
 =?utf-8?B?L2VieUtVU1lGQlFhSldEcWN2eGkyWDh0ekFDa1BrdDhNeXpXM2NWZ1lHbHpz?=
 =?utf-8?B?U0JvRTBJVis3MnYxRHowYmhUNFNIWmlPL2xUaFVycU9vV01ucEhxSWgrVXhM?=
 =?utf-8?B?YzVTUTlCenR2c3pMM1B5THowbDVJbVd5UkxIdUgyUmhvQ3EwRWErMlpYMzB5?=
 =?utf-8?B?QkFaakRmVUpsV1hBTFRHYkx1Zkp0LzdUVWNtcko2elUrTVdCR0hncUR5aHBi?=
 =?utf-8?B?aWFrTUtDRnVQK0hZQzJzbnBSUy9YSldmOFZqdVQrMkJFaCtQTHQ1NnloMVkx?=
 =?utf-8?B?VDV4Y29NbWpmWnZDa092WEtUcmVaV0FnZU9SZVNXNTVrWjJ4OEJLTHpKSzBI?=
 =?utf-8?B?c0ZIWU5kK2Y4MnR4azRtOC81VlZHSXZzTFlsZGJLbWhPTytzS2lPZjRCWjhZ?=
 =?utf-8?B?blphbVFPNFM4YkQ5Z0YyRVlNY3dDQmJtMC90dG1WemxyMUxYY05wT1BXanoy?=
 =?utf-8?B?d3NzQURrMXdseUtRb1NHS0ZjNWlOT2p0QW1ObCsyVmRGTW1yQzlXTXhYaklZ?=
 =?utf-8?B?NVBXT251ZEwrM2ZpTjZJMVNYbzFLOVpGZHJZeXFndkh5K1V0RDlHY0h4TU5x?=
 =?utf-8?B?dVFINjE5aGZJYVR2di9pem1iV2xvampOR0lKaDRwZjlWelNUbzJkbXNzZnVq?=
 =?utf-8?B?b3p6SHhHY0xyT3NyZWpIdDFwbWxiRGtlVkdpb2tTd1kzVWl1ZzlmWk1UalB0?=
 =?utf-8?B?U1FSMjdxZUc2WmRPSTJEZnM3R25oOEVlZXhLaE9heUFzL0cxOGE0aGNCSGd3?=
 =?utf-8?B?R1RDQ1NQNHVvUzJIeFF4dW9uTTlnNDJ4eHV0NjRib1h4bStLQ3B0RGk2REZX?=
 =?utf-8?B?elR1RkxkaEtvMHZkZXp2M1lWczc2NFM2eHZMaWdYc1JHK2E5U0M3SWRPRVd0?=
 =?utf-8?B?c1hpZEFJYU8xdEUyVXRFMGNGc0l4bkRmMlE1N0hVTmYrdjg2ckpJMnUzdGRI?=
 =?utf-8?B?aXA1ZFJZdFpUTktCSVRkdjJZbHVuV3YwdXFPZTNtcElCemhXNXVjY203Z293?=
 =?utf-8?B?cVJ5QzQ5Y0FESndpNkdrOHhLY0VVWGM5N3hjN0FYdStURWU3ZnFPN3RlK2JT?=
 =?utf-8?B?ZjJHQ0pQeDhRUFNpMi9NMWZIZkJJL0VGMEVVRjRGeUloeFFtandIYklINzMx?=
 =?utf-8?B?R3UzaGYyQ01uQitwOFhxUGQzcVZLbDd5YWZOQjloOHRjWCswaGRiaGR4RkZr?=
 =?utf-8?B?eC9MbVlraXpXbEtoVExBZHFGd1c3eVlEREQ5M0J2elBVMGdlcmI0TkNrS3h6?=
 =?utf-8?B?UHJIN3lYcTI3ZGhCUkpjU0ZwNEZXdG9MYnM3SCtmTzFISjJDMi9oUWx3YzVN?=
 =?utf-8?B?RjNrUHB2OWN4R3B1Z1F1VEpzaTRFL3VrY3BielE5NzZqVVdpTFFUVkYvcW5J?=
 =?utf-8?B?Vkl4RlFZZG1vOFZJYUdNMTNGM01ySHVnVWhWQzlRMjgxYVNzR3k3WnRIS2Ja?=
 =?utf-8?B?YlZINUdLS1kvM1NhUFVHOElkL0dtcjNzUmVrZDlKcHJwSXFwSm1KWVFsV2hX?=
 =?utf-8?B?cnhGUTRoWTZJL3FrUHpObXFkaTRvSzloT2hlQk1CL21ORXBnQkJrL2hEOWJ5?=
 =?utf-8?B?VUgzQlRUQS9hNk96SnFVYlpUU1FTMzRoT0NMLzR0QzJQYUtURVhtemVTZFRD?=
 =?utf-8?B?TFVVWCtrMXBITFNhY2g0SkdNcGg1cU5xcTN6OXptRU9zOXRBTHNoTFFlQmF0?=
 =?utf-8?B?dk9PODdjTnFHZUk3V1NvUGRWUVY5d0t0Qjg3OVlWUlQwd1FQRVlRcEVlMGEr?=
 =?utf-8?B?TXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 702fb748-11ed-4575-ad10-08daded1ed1e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2022 19:24:03.5650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nXGkSPdrLcxUisYPq6y0ekt1URlvDlwtYDZntIFVWllUmkBEh/E/q3UzkvkCJUT/4qg1OlfeQdwAv0aUHaRIBAyfvXhWwxDskEzpGcyvtxE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6084
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/15/2022 1:11 AM, Jiri Pirko wrote:
>>
>> +static const struct devlink_gen_cmd *devl_gen_cmds[] = {
>> +	[DEVLINK_CMD_RATE_GET]		= &devl_gen_rate_get,
>> +};
> 
> Instead of having this extra list of ops struct, woudn't it make sence
> to rather implement this dumpit_one infra directly as a part of generic
> netlink code? Something like:
> 
>  	{
>  		.cmd = DEVLINK_CMD_RATE_GET,
>  		.doit = devlink_nl_cmd_rate_get_doit,
> 		.dumpit_one = devlink_nl_cmd_rate_get_dumpit_one,
> 		.dumpit_one_walk = devlink_nl_dumpit_one_walk,
>  		.internal_flags = DEVLINK_NL_FLAG_NEED_RATE,
>  		/* can be retrieved by unprivileged users */
>  	},
> 
> Where devlink_nl_dumpit_one_walk would be basically your
> devlink_instance_iter_dump(), it would get an extra arg dumpit_one
> function pointer from generic netlink code to call per item:
> 
> int devlink_nl_dumpit_one_walk(struct sk_buff *msg, struct netlink_callback *cb,
> 			       int (*dumpit_one)(struct sk_buff *msg,
> 						 struct netlink_callback *cb,
> 						 void *priv));
> {
> 	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
> 	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
> 	struct devlink *devlink;
> 	int err = 0;
> 
> 	devlink_dump_for_each_instance_get(msg, dump, devlink) {
> 		devl_lock(devlink);
> 		err = dumpit_one(msg, cb, devlink);
> 		devl_unlock(devlink);
> 		devlink_put(devlink);
> 
> 		if (err)
> 			break;
> 
> 		/* restart sub-object walk for the next instance */
> 		dump->idx = 0;
> 	}
> 
> 	if (err != -EMSGSIZE)
> 		return err;
> 	return msg->len;
> }
> 
> 
> 
> Or we can avoid .dumpit_one_walk() and just have classic .dumpit() which
> would get the dumpit_one() pointer cb->dumpit_one (obtainable by
> a helper doing a proper check-warn_on on null).
> 
> 

I agree, if we can make this part of the generic netlink code without
too much trouble that would be good.
