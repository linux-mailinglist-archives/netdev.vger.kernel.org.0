Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3AF36052E0
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 00:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbiJSWP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 18:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbiJSWPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 18:15:22 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF28F181955
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 15:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666217718; x=1697753718;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BnzrJ8+vDcW/f3K2sD1/EDsi80yRVN5XOnLvL+fhdtc=;
  b=AK2T9h7qZRpXMxRSJ14xwRrJq+DZmgXWioU2hhndEPYI0vvJNPC2X0AS
   AKf/ZMTXInn16fGzHozROujtBMbjvBwaJvDu+rXam5BFl0YEqT1QtSE3b
   f95efH1rtRfArGD5M4KfV/OT8q9dwkYBuSKR1XXETzjhZTvNj9W1Ba+J6
   qCscuCEVZ0YPzIhbW4/bMVJjcNdwMvCDozYgXM6iISgONuWDngXhuzfjF
   5h1O5m/P0FXCWn57k9sdcl2RggZ7k3+rA4efsRZFJgqfMawC/smLYq2zo
   qKTcoNlr7ujNJ2q6iwN98kJnbBlkKMbVh+XBDLs3VX8x1ZI8Hcqk82Pb6
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="307643857"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="307643857"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2022 15:15:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10505"; a="662680554"
X-IronPort-AV: E=Sophos;i="5.95,196,1661842800"; 
   d="scan'208";a="662680554"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 19 Oct 2022 15:15:15 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 15:15:14 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 15:15:14 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 19 Oct 2022 15:15:14 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 19 Oct 2022 15:15:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SI9191nc2cXdSfQFnvOUENSUg9JqyN4CYkPLKMkb102l+/tjKnE6tueVayNBqXWSyvxDfWhgQsPmZ2P/lDERVjlFnApywl9qlJh1gNzkj9X5a4GVgBx/uWApma4O/2K21jiAtkPzG4bQkaPHAzIfKT6lT/iVjaKouB3iJHNeq24wauchaD0NunEvntt8cyjydn0BT0jgMeeSpuUyTfmrPSfJmjLoH/S+ySSArGRVsdxy7McDAd6w/4rSTsFkduF/3/ZtO0vpns+aHeDUAaJqVPvjEPazKO5P8FNOrGgEWeJ0YW4HOileymEWNBRNE3lG/LWIHAp5TmC2+MZmAMB5vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3bZcpVOy1P4k0Zanius+QXVGPVx8s4btZzsw5Tn3k5Y=;
 b=DdsTE+JSCHjUCZAhDapCUZmmYP6nZeU/fifer126K6isOG14Is0aHq5Fk+R1FJ//H+C2JzZqqQjx5lAZVeDTLEKSdck5HH+lLD4/T+ZgSWVYb6ZfZBFWmkPepBU9beMZUGrB4Yvf5kPp23XjX+FJdTU9uEyqTpSkZ2hINqMdBUZOcY813/RHZ96QbPJvjZSM5Qmk3gKCD9II8JNMgf84ahypbgNkk4njVRzxjbiyt4bk+ahAQz46rBRWz+rwRMw5mNON0iW1gnBd3HZan2AdcoQJkZJD9RYUTVv32kzMAoNBzxop/JzvaU1xwY580/E+P/UZQouj2sIq4bmdebm+ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by IA1PR11MB7272.namprd11.prod.outlook.com (2603:10b6:208:428::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.33; Wed, 19 Oct
 2022 22:15:11 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::e314:2938:1e97:8cbf%7]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 22:15:11 +0000
Message-ID: <b5cd5f47-eb99-17bf-d88d-9166c49840f6@intel.com>
Date:   Wed, 19 Oct 2022 15:15:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.13.1
Subject: Re: [PATCH net-next 11/13] genetlink: inline old iteration helpers
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>,
        <johannes@sipsolutions.net>
CC:     <netdev@vger.kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <jiri@resnulli.us>, <razor@blackwall.org>,
        <nicolas.dichtel@6wind.com>, <gnault@redhat.com>, <fw@strlen.de>
References: <20221018230728.1039524-1-kuba@kernel.org>
 <20221018230728.1039524-12-kuba@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221018230728.1039524-12-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0016.prod.exchangelabs.com (2603:10b6:a02:80::29)
 To CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|IA1PR11MB7272:EE_
X-MS-Office365-Filtering-Correlation-Id: fdf47516-ab78-4cb4-bbd7-08dab21f63ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0BzyH4Bf/XuhFGIxO26JyZaMeJ7Tdco8bRZoZSev1spI1Kr1U9gYsSOX5uSeFocBafDaqqVnk2PBdS1QQDQCblUlbUYSRqsllxA+hp7r/9Uih1TJvChuWP1hKpBVv+D6fBwRsIJr5l05KcZ7sOf+XUjTLOSSwNOvBA8raV9c5KZP2pnfhYgW/OMFaggEm4MHqy92aKtVm8vnDISqL7ACsJoQGaTbd5NxJL70T4pHDnkRHsIJwtg/4N87rUp25BkwFm5AgyU0LLdmIOT4F+TCkCdsPnZtwQQHBLr8ykkPrxlK9By5IZe9gTu3RdyEfsdnCliYcdGcVhVgb1uX//6cFlYRj0k36dddgSwdRQGxyZFNG+6qhaHSVJPxKqxNb4P6acJe3Go9F8MaxddyjDxLODCGyD+kUtjZBGNRQ2330GDPKm7o3AIwa/2xz5MDswuUzwsNo/LjdKVzzaCznFN51bHsk/OmhSjiPcdRtb1yMOOcOQV6lFOW0umpjeIZW4SvnK3KEl1K3UQV1LXBlD8kakCtBtlZEgFJt6XxDHfGSA3Xno8efQx2Ix6nwLp2gj0RJewCv3549Gn3ZWay5hA+aHs6WwuHEq7ZkJdA5WI+RUEammZbdfkfIzu2wqjqAFMN9Vondi38qLAUE9knwXsMoIgyg4I6/6Ht1ghlY/bm9OjTEGSFe3JAqI5RVlLHqETKZCPvJ7XgqCAn7kDd0Q7rpHufNcYwsPzdnO16cxzKLOnwWlpmW4IwteU9/LnXHi3PR4XjqtgtT7dYqNUvlhUNQY1wN7Xi71sm6LBlx5P4tJ0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(366004)(376002)(136003)(396003)(451199015)(66946007)(66476007)(6666004)(8676002)(66556008)(316002)(186003)(2616005)(31696002)(86362001)(4326008)(6506007)(83380400001)(41300700001)(53546011)(26005)(5660300002)(36756003)(7416002)(6512007)(2906002)(8936002)(82960400001)(6486002)(31686004)(478600001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c09TVmhPbTl5Tmt5VXovYlNsMVZGcG9oL2Y4M0xTNEhUczQ0TlNPRjU4Zlc5?=
 =?utf-8?B?dnRsNGJHWUo2YXA0SXB5ZjY4VmVEVzF1eElBQVpLOFlLdGllRGdiTjFDeUdh?=
 =?utf-8?B?WmVDd0YyUEJtNnAvbWxoNnNHM3pkcEkyMGgyWXZFaXJTOURWZUFQQzJGRDJE?=
 =?utf-8?B?Qzg3N2hsaWM2UjI3MGFMQ1A1QmRHd3FqQ252NGpVUDdDejU2UUdZZWwrWitQ?=
 =?utf-8?B?MnhZaklKaFlFY0VBOXcvRXZoNlJWVVJVTTMzdG9ubzJqUjBKRW82K3BNbkNr?=
 =?utf-8?B?dWs1QVBhaEt6TS8zcC9UU0taZ0dXNHA4YnlrOHhuQ1llbmMvczh1MTUvY1V3?=
 =?utf-8?B?UUpvMEpybjJWSVZxWWFheENXMTJDeGQ3MUdORjlTY0paL2Y1QUFpbDYrdGdv?=
 =?utf-8?B?cXFOMzRXeVpxbE5JclFMWisyWTc2S3FtUDZnblhCdk1rQzhqZENTQkRyRVlZ?=
 =?utf-8?B?aEU2Wm4wMnd6KzRrcXMvOGNhUlRxWnI3OUV2NEVWN1IzZjh6dWlTa3l2RGN4?=
 =?utf-8?B?UVBNRDloT0I2dnBlL2VNRVQrN09kNGI1WHUrQnFUQmJ6R29NZTcvdW1UZzBx?=
 =?utf-8?B?QzRYbjZyRTVZQlVicWljemZCYzM5NDIvYzVkenRrZElKT1M5OGJDanlrT1p4?=
 =?utf-8?B?ZUZ1WDJMVnNORzlNeVBrcWR4U3hNL2hkYS84MGVRNGlDRVJCcEFGT3ZxSWd1?=
 =?utf-8?B?R3ZVZnlqbVdNZzNmM09Ba0tSUndKSU9sVHBXNzNOSDFpUzUvOEMybXBoVDB2?=
 =?utf-8?B?eEVKMWRNMEc4TkRaakRoSEdGcXdZWmxLRGpKUFFiZ3E0VVMvbi82UVNPd1hI?=
 =?utf-8?B?WUxKYnd6V1U4UkJlMGN2enA3UUVUV3VvN0hQT3JkOXE4WlA3aTNQbzNpTCtO?=
 =?utf-8?B?ekRtcnVEZnJyaUI4UlF1aDNPbnlqcU9DMnA1bWtKenQvY2oxSXlZanZObHZD?=
 =?utf-8?B?enBuSUxrOHV6VnFKbHhkUWtzSWh6ZXY5bWR2MW5BRFhJUmVaeG96elBMdm95?=
 =?utf-8?B?NlFycjMwNm54eHprL25UQTczd21oZVl1Z2VCaC9ZSEFaMEhNMkIxM0UwUW91?=
 =?utf-8?B?NDBBQVpxdEY1eXMwb1FDVy9Eb2N1L1Y4NXkwbWJZdC9sNElxa1I4Q1l5aFpM?=
 =?utf-8?B?VVBVVEgwcElQQWJ0b2IzeHBxYmcwWUtRNUlFalNQM2p5TnRNa1RMdFBuYkh4?=
 =?utf-8?B?NDQ1azhaN3d0UHBlRVl6bmxzT3BqeVJhQUhTOXZRR1ZNdnFidjFRYU5XNUx6?=
 =?utf-8?B?Ti9VRnF6ZFVnOW00NCtmZ0V3YXAwZGtZdmI3aHNKSXVNMzQrdktvNHhsd01i?=
 =?utf-8?B?eko2Y3NHMDBGdnJjL3Z1QkJjcUVPckNWVGluVWNnR2UyZWlIc3gyTnhuM0dY?=
 =?utf-8?B?RmEyMXB2MmQyajM4YlFYZEE0M0xCU1Vub2N3Y0UrKzZkNDZtTDRlb1pDWmtn?=
 =?utf-8?B?K2VBanp1bVAyNkdsVjg5eGdBK3lyOTM3by90eUhQN3JOaCtWS1F6bndNejB3?=
 =?utf-8?B?dkdldWVhWmRqWGNFWkNEK0JHMGpockltdDBhWGJydUN0Y1dSV2xUVnZtT21O?=
 =?utf-8?B?TFNZTU02U1duYmpzaG1MdWFDejJkdnRzNWk1K0ZRY0NRQmEydHdiR2NMZkRw?=
 =?utf-8?B?NjVpd215TDM4VXBuYldTY2RqdTZkRVhwWHBIVzJWMkdSc1Bic0JGSXBxaFZi?=
 =?utf-8?B?aXUyUDlSWUZFMUhLSjN5bXI2SDlsUGkrOEZGLzVDNW0vaXhMUDF3L3l1MXJ4?=
 =?utf-8?B?SE5wOGd2clVsanV0blV2U2xUYzduUXdTNGl1SmlYWXlLRDR6K3U5UzVuMGFt?=
 =?utf-8?B?cXBLODRQbll3dU9KUEp6UHh5WnNRSXh0V1JDOWZVY1V2NUxlaDhaWm1zdjN2?=
 =?utf-8?B?R2JZSkwva0FFTWJuYmpxb3U0R3gzbWMrTGw4M29QK0pqYnlyTWZVcEk3eWlX?=
 =?utf-8?B?UmdJcWl1TFVOSkRlK2JON2lmNTlSdU5aMUg2K283ZVQ5dkF6SllJTU5xNllm?=
 =?utf-8?B?UEc1aC9WdjRYVDNiaEIyQ3EyNEl4MlcwTFNLRVRHTjI5S29nM2dUTVRLdDNC?=
 =?utf-8?B?ZVhLQ3RZbDQ0cEJmeU1yOHdFVkM2a0ZUVzZ6dDllMWplUGUvTmFtamM1RmVD?=
 =?utf-8?B?WEhpd25kWEZGNkFHQStBSGZHRHdKaGpxNnl5b1Z4MlVkUEhDdVE5VFpuNGNs?=
 =?utf-8?B?THc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fdf47516-ab78-4cb4-bbd7-08dab21f63ed
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 22:15:11.7694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c6DWHaaZRMLqRiJ/fiavXX6VeCkEpWQlKvcSGmrbv6/70Jd2rikmeOC0d6S85zZ4xXfSjuGGl6ncCmukBseyJCXwrSoAtBY/oMmCTihBc/E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7272
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/18/2022 4:07 PM, Jakub Kicinski wrote:
> All dumpers use the iterators now, inline the cmd by index
> stuff into iterator code.
> 

Makes sense.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/netlink/genetlink.c | 32 +++++++++-----------------------
>  1 file changed, 9 insertions(+), 23 deletions(-)
> 
> diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
> index 63807204805a..301981bae83d 100644
> --- a/net/netlink/genetlink.c
> +++ b/net/netlink/genetlink.c
> @@ -99,11 +99,6 @@ static const struct genl_family *genl_family_find_byname(char *name)
>  	return NULL;
>  }
>  
> -static int genl_get_cmd_cnt(const struct genl_family *family)
> -{
> -	return family->n_ops + family->n_small_ops;
> -}
> -
>  static void genl_op_from_full(const struct genl_family *family,
>  			      unsigned int i, struct genl_ops *op)
>  {
> @@ -217,18 +212,6 @@ genl_get_cmd(u32 cmd, u8 flags, const struct genl_family *family,
>  	return genl_cmd_full_to_split(op, family, &full, flags);
>  }
>  
> -static void genl_get_cmd_by_index(unsigned int i,
> -				  const struct genl_family *family,
> -				  struct genl_ops *op)
> -{
> -	if (i < family->n_ops)
> -		genl_op_from_full(family, i, op);
> -	else if (i < family->n_ops + family->n_small_ops)
> -		genl_op_from_small(family, i - family->n_ops, op);
> -	else
> -		WARN_ON_ONCE(1);
> -}
> -
>  struct genl_op_iter {
>  	const struct genl_family *family;
>  	struct genl_split_ops doit;
> @@ -246,22 +229,25 @@ genl_op_iter_init(const struct genl_family *family, struct genl_op_iter *iter)
>  
>  	iter->flags = 0;
>  
> -	return genl_get_cmd_cnt(iter->family);
> +	return iter->family->n_ops + iter->family->n_small_ops;
>  }
>  
>  static bool genl_op_iter_next(struct genl_op_iter *iter)
>  {
> +	const struct genl_family *family = iter->family;
>  	struct genl_ops op;
>  
> -	if (iter->i >= genl_get_cmd_cnt(iter->family))
> +	if (iter->i < family->n_ops)
> +		genl_op_from_full(family, iter->i, &op);
> +	else if (iter->i < family->n_ops + family->n_small_ops)
> +		genl_op_from_small(family, iter->i - family->n_ops, &op);
> +	else
>  		return false;
>  
> -	genl_get_cmd_by_index(iter->i, iter->family, &op);
>  	iter->i++;
>  
> -	genl_cmd_full_to_split(&iter->doit, iter->family, &op, GENL_CMD_CAP_DO);
> -	genl_cmd_full_to_split(&iter->dumpit, iter->family,
> -			       &op, GENL_CMD_CAP_DUMP);
> +	genl_cmd_full_to_split(&iter->doit, family, &op, GENL_CMD_CAP_DO);
> +	genl_cmd_full_to_split(&iter->dumpit, family, &op, GENL_CMD_CAP_DUMP);
>  
>  	iter->cmd = iter->doit.cmd | iter->dumpit.cmd;
>  	iter->flags = iter->doit.flags | iter->dumpit.flags;
