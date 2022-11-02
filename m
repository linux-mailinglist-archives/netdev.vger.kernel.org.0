Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA4B61730D
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 00:52:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiKBXwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 19:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKBXwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 19:52:40 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B291725CD
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 16:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667433159; x=1698969159;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=N9k3gjgdBau4RjOAbkgmogQS5HuSv0LxFwBo1uEz1sE=;
  b=JdOJl5Hy8cKeVgzQZoQKru1H4298dDj0TFMSrDLlwVNeFEXpF9ooTz3J
   Oy+yTWY7rVecKjBC3IUL6FwKnViaOfOgzZMJOb8EkN5Kxd3vglMTBrsUc
   sPCCDmS73sbCTpw9KJ+2So9mQnjyNxEPn4E2lgqT8fzEODk9umEa2qmcA
   Pp837z4ntaWBog/7M3VGZpDLBqSEyXRVO0FJ470aDntedlkzntTZKaMMx
   n7CyLaUX9J/fGsleQGrt9SpiQ+HqA0QhH8OUOJM0mITHvLUwjKZA9foq/
   d7rfKntC+4M45tZQ4WJ48E6V2JHAGwnXISF7l2BmrzV4EAPdcrK9r4PwS
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="289259158"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="289259158"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2022 16:52:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10519"; a="698007694"
X-IronPort-AV: E=Sophos;i="5.95,235,1661842800"; 
   d="scan'208";a="698007694"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 02 Nov 2022 16:52:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 2 Nov 2022 16:52:31 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 2 Nov 2022 16:52:31 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 2 Nov 2022 16:52:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dO2ZAk1D6DXzg8Bo/i4trJEckOZIth7Uvap1F1pyC9xDJfhlzgY50Vip9gjPUdAMVcvGGs/8oyWID4UyF8X7XvTM4ZDI3JI0/SOS36UTSV/K8FIjTP6r10GsduFj/eAHn0nG2Jw2qAF13oH4xhe192RmjFn4ECIilM+3o8WZYu4tK/ATZEReDd1IGzFy8JzQL33x2WjEede+k3wgE3v5XGmLWdUkxNNtx2+ghALZiLCUUIZcra3fdEfqfZ4eCp7GiqD1bh20OxoRdKUbwl+7sEf1JxjdzDfxayyXIh8zXskiB6TbFM81YMauHCtZwNu5/sXl14BSxZdJo3zp0pH9DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Vswe2+mhNXostrmw8o85cCuNq1lPBqyAf67PDWlzcY=;
 b=KBC8AWFfOKnhl8Oz5W/8NE3bEVx4twFcl1ebK93/dWwgc4+H7UdGg2k31AhqdWOHHLSD8D32qQ1ZRHvVnIBSFCnTMukLIpYBi/x4QpYhwJhnfNTeaO3AljM8rzpfH30Hz1bj0Y1KONItwo/RFA29pwLeMzjEmSekRewgBKdNddIipHitwRhoWI9xJiU6VN2CMOnRdydQyfXb6ynhyENa+6zAc47QnIUDPUqvlwo8MCBJxrdwrieb+t3Qs3ZWm1+Mglme+hbGaBMtRWDxnMtVuFbryOjrlGFzhgtPoJfvT3JvXaPGrbC7ojciP2S77S7K53fKi/a+3KKaQ5YTGkDQxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM4PR11MB6502.namprd11.prod.outlook.com (2603:10b6:8:89::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.15; Wed, 2 Nov 2022 23:52:24 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::d408:e9e3:d620:1f94]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::d408:e9e3:d620:1f94%6]) with mapi id 15.20.5791.022; Wed, 2 Nov 2022
 23:52:24 +0000
Message-ID: <83cb45fe-1ae5-4963-55e8-6d1ee6751aa1@intel.com>
Date:   Wed, 2 Nov 2022 16:52:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH net-next v2 01/13] genetlink: refactor the cmd <> policy
 mapping dump
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jiri@resnulli.us>, <razor@blackwall.org>,
        <nicolas.dichtel@6wind.com>, <gnault@redhat.com>, <fw@strlen.de>
References: <20221102213338.194672-1-kuba@kernel.org>
 <20221102213338.194672-2-kuba@kernel.org>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221102213338.194672-2-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0196.namprd05.prod.outlook.com
 (2603:10b6:a03:330::21) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DM4PR11MB6502:EE_
X-MS-Office365-Filtering-Correlation-Id: c37caacf-896d-495c-5be2-08dabd2d4a1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ygOD/CVsucR14SRiCUjjKvJMeK8uL5M0P3KFtk3qjw5f+8YZgon/yvTiMjkH9GQRx7n/iadk7OhMlAXNaFyHOynTnpDD1QPRbDoCPHtLMiXoX39Li5iAqyaWuL215XAUCSMZGc91dAa2eye/vz0rGkTHr9vM8lkrjOFXThZe3n/SIQRB+2Wom99xFdf4vPjk2QITvEmZv3xA1oT7iLCqzqWbmrA/h0naTWi6u1TO2ZFK1LBz4yR3xe7lhw6hQWfbd5Qn27ryg92Zd0ZB97hp8IkxeXGZmPHAo0v9TV4drMI/Z3ePTGdk80UBGmcX2u+rcvvrPRf7rZvCl/PEx/kYq+HmwfwAIRflzZjo4CIagN2qYpsAWGBKQUaJubjhNpYalrlTEklQfiM8059VFlxdIi9jDjTvNwhiVRNWRTiXKHrl4jcuLd12pYdC0hxTQBLiqD0rOsYE7B6v5+o7lv/e48Ho3dmjExFEOGGctr2JVu/zu8E9/Zd+tlKZdOOVhtR1Xerdhv/kjPUtCKS1PtToKLjEQTE1DWz+LAcWbZmOGHQx6p1h/y16U1LumCI9ngxiAPp7nq2A1JVv01hA6HIfLpj+WQsCrVHVmKhNxSHnOUKEIwLGZV09gYOJ+k+0bMpx02XPKT71HEa/phxK/nfGkG5cYSnv4vUg5AFoz7HeHYTgxUb2fXmUHmuBWpUdrBVGkIwv7K7g2g1sHqhV3pWkBjiVEDEiOq1G+EACf3Rev15BD/a5A+4kl7O8rJV3CAFODYI5M+KhmEHkL2qcyQYlA9q9+y9Vn4be97qHk9kkWKo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(136003)(366004)(376002)(346002)(451199015)(6666004)(26005)(2616005)(6512007)(83380400001)(186003)(2906002)(53546011)(6506007)(5660300002)(66556008)(66476007)(6486002)(8936002)(7416002)(41300700001)(8676002)(478600001)(66946007)(4326008)(86362001)(316002)(36756003)(31696002)(38100700002)(82960400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?alMyajF5R0ZwY1NoQnlITE95UEpQYnRNVHdocHJkVHFtMWtyeFA5cWxvY2RP?=
 =?utf-8?B?ZFNFQllNdDg0T1h1OEd1MmJiQUhHa2ZtWmNXbDdEdEYzSGJQTk55OUNSWVV6?=
 =?utf-8?B?amlpSmViTHRabGYwWXZkYmd2QnRrZHNHeTZkd284S3pvUXZ6ZmM1VXI0anV5?=
 =?utf-8?B?cWFBNFhpdUduYmUxRTlHdWJNTVhZYlNaa1F0bkZOMGZuZXlaeENTdXN4Wlox?=
 =?utf-8?B?VGlLb0tObjkyVVFZRWRJMW1EY1hPaTdKN1Z5dm9Sb3FLbDFNbmlnRERydnVE?=
 =?utf-8?B?cEp6NFI4MjNnc2hpYkhpVnlxYXVqa29SWGZNdGdkUmgyYnBBQTRya2tGenRV?=
 =?utf-8?B?QUVPWmFRazJYV2p2STdCU2lrMUxDUmpvZ0NuRU5lRldPS1F4TWdkb0dJbjVG?=
 =?utf-8?B?VExrZHhhZkFIL1BKQ3FKbGNrV05HL0NQYVYrdS9qUlp2N3R2MHp2RFo0Zkht?=
 =?utf-8?B?RnZMUUc2VU12a0FrRUN5WEV0YXdIVi93eWpYbEJGTU1mK1dFdU9JbExrV0lv?=
 =?utf-8?B?V3FTTDczeWxNOExFT2V3WU56VzRuVk1pdUZGSVNFd2VCMi9XYjVoa2lXT0Vi?=
 =?utf-8?B?TVQzRjQzREpMVi80WVhjSUdRb0hmZE5haThaTGd3UjV1TmovaHcvRVVmYjA3?=
 =?utf-8?B?UTJDU28zQy9FT05kVGZoaVVRS05iTExzUi8zQUg0eHMvdDZsRmwzZDV0QXJh?=
 =?utf-8?B?MlhzZzJJVkNJcnZPNG8vVU1Cd3VjU0dzUlBXYTlOVTVuZ0dmSVRhd2tpOHF4?=
 =?utf-8?B?MmFHb0RLZDRCZm9veXlzbE0yN1BjeUdXaGtFVFhsWElBUEJic1BVWEZGeUx5?=
 =?utf-8?B?RG0zVkl0TmNQbEo4cEZPL3ptWm5qVVpza0RpeFhkbWxldkFvK1hRZmlXMTZ3?=
 =?utf-8?B?V3ErWEFCNVVEdjBiaUhEbFZGYWZIWmxpUS9rd2Jyc2I1VlIxZFNiZ2lOeFc1?=
 =?utf-8?B?ams5VHU1cTZiSEY2N1FYTlkvdjI1WTArY3Z3bWd5WnF2eDRxUW1lY1JUZFht?=
 =?utf-8?B?WS8vcjdieVErUSthY0J1T0hQUytJaTJIeDZsNXhlVmIyNXZKRUlELzk1eG5G?=
 =?utf-8?B?OEg4ekNTOG1mV2FpaDdQTHNLWGVOc3NRME0rOWdXR0xKSnN1OXJncGtLZERr?=
 =?utf-8?B?bWF1RHh6TEFJSmxLN1dHemFWdDVvVWM4ZHkrbWM0cnVkb1YwQjZKZjBjOXov?=
 =?utf-8?B?a056dnhjbkdQVHBjYUh2alVaSWpSSzlDc1NtbDNZTE8zR2t2OVkrWWRod21s?=
 =?utf-8?B?ZDlCN2dpR0ZrbzNwUldERUJIdHRlejV4TDNzc1ExcWFZeW9oQTVJSjBEU1Fr?=
 =?utf-8?B?N1N1OVZFRkVNdGprQm16clFWMUZKaXFFSkQ0RE5SR0lJSGRGRnRNZU5IdUN0?=
 =?utf-8?B?MHF5YmlQRmRJeFRDa0hiSVc2aUJJMVdoU0NVRnhYNWdLSFhvN0QwVVZ3a0oy?=
 =?utf-8?B?cjA2NDZ0djVDaElZRXFWMWR5bFBUbWJIUlhjZ2RxNmJaTkExaG4xK3dmakdo?=
 =?utf-8?B?VUdWQjF0U0RwYjB2YkRpdVRDZnBJTWFPblJtNyt5V1Z0YWJvV1VUREduaEJ3?=
 =?utf-8?B?ZmMyajkrcndXNmdSOEJ2UXY2OFRsOVJTMEhxa0haTFpSUHp0eW9uS2lYTnFk?=
 =?utf-8?B?ZkFxc3RXNUFRVCtoQ09JdWp6c3lKM0FmV3F3ay9RRWpkMVJodjFvMTRIVGlx?=
 =?utf-8?B?MWljZzBTOEdSVzZoODU3cktZKzF4RFV6UzVha1NNNmNUWUVTUkpSTHNtM3Ux?=
 =?utf-8?B?U05xeERyenJBM0tPbGczVFdIVnA3eWpmRzl2bzIrZUg2WEZ6akNCRlZaSmZn?=
 =?utf-8?B?aXlZdG5hRktTSHZZby8rRGE1czRabStVTHdjN1ZBQk1JbW91emJ6dUFGTkRS?=
 =?utf-8?B?VndsV0dCVkdZNzhWdjZHR3lvS05TM09POW11VkhVbklOOFpxZFVXSGVMTTNC?=
 =?utf-8?B?azNZeDcrc2dFbWRNb29KMTUvZGEwR09VNk1MaTVkOEtWRy8zTys5RWltaVJo?=
 =?utf-8?B?UHNtbVhCYnBsdjVVakoxaGlwZXViaERJL3p1T3dwUnRvSjdMV2Njd2JyRUdw?=
 =?utf-8?B?REpxb3U4bGRSTW8zbk9hSWsxNzNoT1VlNm01M1J3di9kL3huV0lNZ1JMbVBE?=
 =?utf-8?B?MG5TU0RFckZVeHV6QzFLbWk0N1VYVk5wcGZpamZFOHU0anFwME1BbDgxMTNo?=
 =?utf-8?B?S1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c37caacf-896d-495c-5be2-08dabd2d4a1e
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2022 23:52:24.2434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GKz6tWHpcxShX88jJJA4vgBYT/fLryoXY+VUyPYpuoPcPqV7yjPckGfaTS2CI8PjtvKs5bt5pQONdAxVJ7FMfpA3onrFNHZNJQaLpdh2yXI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6502
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/2/2022 2:33 PM, Jakub Kicinski wrote:
> The code at the top of ctrl_dumppolicy() dumps mappings between
> ops and policies. It supports dumping both the entire family and
> single op if dump is filtered. But both of those cases are handled
> inside a loop, which makes the logic harder to follow and change.
> Refactor to split the two cases more clearly.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> v2: bring the comment back
> ---
>   net/netlink/genetlink.c | 27 +++++++++++++++------------
>   1 file changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index 3e16527beb91..0a7a856e9ce0 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -1319,21 +1319,24 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
>   	void *hdr;
>   
>   	if (!ctx->policies) {
> -		while (ctx->opidx < genl_get_cmd_cnt(ctx->rt)) {
> -			struct genl_ops op;
> +		struct genl_ops op;
>   
> -			if (ctx->single_op) {
> -				int err;
> +		if (ctx->single_op) {
> +			int err;
>   
> -				err = genl_get_cmd(ctx->op, ctx->rt, &op);
> -				if (WARN_ON(err))
> -					return skb->len;
> +			err = genl_get_cmd(ctx->op, ctx->rt, &op);
> +			if (WARN_ON(err))
> +				return err;
>   
> -				/* break out of the loop after this one */
> -				ctx->opidx = genl_get_cmd_cnt(ctx->rt);
> -			} else {
> -				genl_get_cmd_by_index(ctx->opidx, ctx->rt, &op);
> -			}
> +			if (ctrl_dumppolicy_put_op(skb, cb, &op))
> +				return skb->len;
> +
> +			/* don't enter the loop below */
> +			ctx->opidx = genl_get_cmd_cnt(ctx->rt);
> +		}
> +
> +		while (ctx->opidx < genl_get_cmd_cnt(ctx->rt)) {
> +

Does the change to ctx->opidx have any other side effects we care about? 
if not it might be more legible to write this as:

/* don't modify ctx->opidx */
}

while (!ctx->single_op && ctx->opidx < genl_get_cmd_cnt(ctx->r)) {


That makes the intent a bit more clear and shouldn't need a comment 
about entering the loop. It also means we don't need to modify 
ctx->opidx, though I'm not sure if those other side effects matter or 
not.. we were modifying it before..

I don't know what else depends on the opidx.

Thanks,
Jake
			genl_get_cmd_by_index(ctx->opidx, ctx->rt, &op);
>   
>   			if (ctrl_dumppolicy_put_op(skb, cb, &op))
>   				return skb->len;
