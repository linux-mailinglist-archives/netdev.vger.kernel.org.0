Return-Path: <netdev+bounces-11045-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED7807314A9
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 11:55:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 287DD1C20E7C
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 09:55:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 076C663B9;
	Thu, 15 Jun 2023 09:55:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6AC6AA2;
	Thu, 15 Jun 2023 09:55:43 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1C510D8;
	Thu, 15 Jun 2023 02:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686822941; x=1718358941;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=V/opcxkudV+QkJd9eFm10ry8Ir6upkowgBdmnEWX0Vc=;
  b=WeIF5K/jlIQfWnpwxlBX/Q8d8BdNo3NoeOUO3qYrZ2Izr6kPCwFfWr9O
   jQNHzyAyGcEEteiOe77wSXHmBeX6bFzPhKV8/JgJXBRZOqMCRrm17/f6Y
   6N/DCDVveuq7gZo9UPlyQGkoO7yfi9SS6hlCY1YZG4UnwOBSuYFJ9XGuM
   SyayVDoBIxV2IkEFt+O92XEKC/z4oy6RMvEVfdon/T3M5wxK1qxN76uBh
   7VmVNLMFxHM54SQUVjMfSqv1F9+H6t71bB0dPcIhtozWMewk9U5qXQ3uJ
   72LOZMOUGltSiOrgnOIPRW0x8PvwxWmQhwEwInUBWNA6K3NSyPtenSMpR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="422473604"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="422473604"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 02:55:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="782463732"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="782463732"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 15 Jun 2023 02:55:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 02:55:39 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 02:55:39 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 02:55:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DprVjW5WF8doO+dJOIqfGYbHeoZxr8yAb70vJRMLb+iNKd6Jj9sA4GnQjPpHbujPmsmmQgsBKWyk6p7oIc/u7kMNX3x8Jvt+ug7beEczOGNeXde/uqnnArF3nWFmiwme1S+NcR/+5tiwb7bc3W8Lt8Kbbjm82f17LyqHJtS6GValqf35eSUTy3BTn2UKMgaP6Z40gUIBnZ6faX9ViUWgFQ7EW/2yA1gU2RDigwA1mpNK/ZbI6r6DWhEkCQ0S9LWrNvPdRmqw5+t1TjRosEckzA0NQiFJPZGkbio7zYrDMjpzb5HWxhvE7UHVNnO5/yiMqA2C/xkaWKxBHKG6pksVbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qcxALoJSmRotg48e8/vAcc1LbIwKFE5zmFp9jBapodE=;
 b=P8WAePr4zF8QUwhYtpuRxXKplyDO9l9wjZ9hgqJKHBzoO8+WzM+ILfqW67AGuxUYeIiAIVSw1K8e64zP+HHZa4ejkyrJjUnqxMkgzw0kHtLUb7CUGE8/CEn5IPVAwLYqsW0eFl+adWKLiqaYHojjfeGEvPtStv6vW6894AP208QSqjQAAmL2M+T7n8Ve+eGQoG0gGxwnIPf3H1+ANI7r23I+8cAlVJAoo7z7kWcqHYiD5m19BphUJdZPAix2NmUfI7vDiygTsB3eQM5AVC0GGqpEZMLrljASjCvx573TUJwTzTmcK5w3CnBqTxmv7MUb8k7bZec4DvMhB3IVXe86Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CH0PR11MB5378.namprd11.prod.outlook.com (2603:10b6:610:b9::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.37; Thu, 15 Jun 2023 09:55:37 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.028; Thu, 15 Jun 2023
 09:55:37 +0000
Date: Thu, 15 Jun 2023 11:55:29 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Simon Horman <horms@kernel.org>
CC: Jesse Brandeburg <jesse.brandeburg@intel.com>, Tony Nguyen
	<anthony.l.nguyen@intel.com>, Alexei Starovoitov <ast@kernel.org>, "Andre
 Guedes" <andre.guedes@intel.com>, Dan Carpenter <dan.carpenter@linaro.org>,
	Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Florian Kauer
	<florian.kauer@linutronix.de>, Jakub Kicinski <kuba@kernel.org>, "Jesper
 Dangaard Brouer" <hawk@kernel.org>, Jithu Joseph <jithu.joseph@intel.com>,
	John Fastabend <john.fastabend@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
	Vedang Patel <vedang.patel@intel.com>, <intel-wired-lan@lists.osuosl.org>,
	<netdev@vger.kernel.org>, <bpf@vger.kernel.org>
Subject: Re: [PATCH RFC net] igc: Avoid dereference of ptr_err in
 igc_clean_rx_irq()
Message-ID: <ZIrgEVVQfvJwneLx@boxer>
References: <20230615-igc-err-ptr-v1-1-a17145eb8d62@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230615-igc-err-ptr-v1-1-a17145eb8d62@kernel.org>
X-ClientProxiedBy: FR2P281CA0079.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9a::19) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CH0PR11MB5378:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cd0d643-94ee-4ab7-f37b-08db6d86ab8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SwBgwA61P9szS4P/T+0s4+VynZgTbq7HjwRmgVFguaFHMddDHvDOKLpVX5KAn4DBlsNZBmxxv56kDy7cuUNDYgG/Tr0lHN7RyiWbHvM3ePzRjJ4LGfFDShHVDcJ39Q9i7873adMxzeTV7KUaRKq6EcABGa95QB/dcEj9hVEnXEjSuuNEQQ1TYnVG3aKUqDKUGABR9YjloyTDijzLBT3Si9smr7soGdDfU4jBJUf1I1E9Rk4Yw2/VubOavn2U+KB6ZiSqVLciy+1dmifKiYK0Q4Uy/ydeSCgkA1kft4mWmQ+s/CZdeuLA1Yze3g5jyVTj+AiKoxyzRiIue76FU2IKwFvFUuD82PK7vDC/XIU1nEXhN81XOZGycXBp8NadCM1pnGxdAWL46jQyjOEcp9vLoK8ZOvAqXoJ+0QfKR4rKXj8e2db2FWeJ5v8wS+zo7vslUyGH0/0VD9V97YyzbVAVXfn0+ABgQXUO1tHZk2RtRFEKtIUvqGJiR4sxJ9Q8U/oFgpn2424bwN+Ede0wJvmwaW4jdusJBzEDuCXuNt3vA+iz7ZNxVsK0JEJ/YkWAzt3e
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(366004)(39860400002)(396003)(136003)(376002)(451199021)(5660300002)(83380400001)(186003)(33716001)(6506007)(44832011)(2906002)(7416002)(6512007)(41300700001)(8936002)(9686003)(26005)(8676002)(6486002)(316002)(54906003)(6666004)(478600001)(82960400001)(4326008)(66556008)(66476007)(86362001)(38100700002)(66946007)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LlRLQaz7JKw2PQIDs+rsBVzALU66bAIbmdDv0Z2Z8xwUzPSSLiBYJdt0kpvr?=
 =?us-ascii?Q?UuUZbWvrNe/lHM7dNqSV8mLjr1jj9i1J5nWAuNBk6B/Rq8cBir0aFPpDua1P?=
 =?us-ascii?Q?0mhnJvmbguLXA4aTiJTUMF2x/dpjNsLtG653IzMFmD61fmnp/Rakx+N+tB2F?=
 =?us-ascii?Q?V7RdghDqValKsqV1DpVRsNLK68ZGuI5CcloKWGZqfv3wRuDs3M1CK20jRq2P?=
 =?us-ascii?Q?v6IzMgOYYG0XJxG+kpT4ftwIIyXCffWN7y4bPXHrDTCZ57EGAFNS8hS4kSRG?=
 =?us-ascii?Q?cXsk1zLpQPPQ5amcSlwnTKtGcgLS1Q4vw5btAoJxeOSHIngIlUp2WH78rVj7?=
 =?us-ascii?Q?85gdaxSLm1gdtbT6BKLLeCGI1W1SafBoV7eXL3kF7TqWY04uZ+sycKDHFKLs?=
 =?us-ascii?Q?hTHrslf4B5LKH50TiT9VN/3afzQGhO8IGOSGQHFbqTFMkO6KMNEJWCzvF8UU?=
 =?us-ascii?Q?K5nNmHx6A9aEovB/VNbOHgJbUiP9Q1/jVDbsmA3NkFEldIOf4pv33HKqKa39?=
 =?us-ascii?Q?ge+D0cAOYcRTL8v0fQx3hji8I6yLW+i9ONZgaQHq40FSla/QSKKXMxGDMErm?=
 =?us-ascii?Q?JOSCOziUDB5+R/3HVwN73DNKU6cHWB0VINFBhQmjlfqwALoJGl7yqHdcObQO?=
 =?us-ascii?Q?NgGt1XI0aTns7bTRMv9gFFXBy6Vrm4cedAOQUZ3dc856Wqc7NMSP487yUwCf?=
 =?us-ascii?Q?8WccPcdSfWaPuS/T8nFs3jyejmVZT1gc0Sg9F8+VNzbnBxT+PPwNmxENRerk?=
 =?us-ascii?Q?wQn+JUjX+bqzlVQqzM+cwywU66hpLuOZq066JDZWTqaNSmOVIYcbLv/3Mzd+?=
 =?us-ascii?Q?xtniuzINyC1JoUJvuMB9eE7cIFr9S2SzbkN3aDPbLU0rv6MQRgSUySCumon6?=
 =?us-ascii?Q?Aj5eYig+hT+1OOahTjOGfcDKd00XCmQHR/Ykw2b2jUtsiLGXE4En3rRNtaya?=
 =?us-ascii?Q?vyN1hB4Fri+5kOHwpAlLPRHZ4O4GRFQ5F6HGc2A87YPmFBU0XSa8BynkcPaq?=
 =?us-ascii?Q?lvztkdLkWekqh9+UCK+WcSMMPmgBS2EBWDzdzT9DlUC4IMIhCdfhnz9Q44F9?=
 =?us-ascii?Q?w8fIverNhLzN/H8EPrhWtWtOWSMvmYFvzK6aOOHafHTNml34ZAooWoG+wTxj?=
 =?us-ascii?Q?A/Onepoj9Ir9nlbFOx1xUaCZWJHXmO5iE/aYAlAgAEtmTdmkKmXTS1aaOjEL?=
 =?us-ascii?Q?mfHjGBY8Abwpy9VYJwfZI16qrV5Yhk0Fcj6/FgjWIDifgV2Z8WKmD54rJGxr?=
 =?us-ascii?Q?kYfR4ayLjKkGD3przg4VpszYa79biM6wLCKGnkl52lMGPGmWMXibIeTRgDjk?=
 =?us-ascii?Q?i1pGG95maQoAWox1ayyHGYWtmnXZU/Dy2Hm0+08u8yK/iDqg6g1NJNyMZ4Vw?=
 =?us-ascii?Q?kOPLiodaROM1x+DGgMZGG6aB0jnsm/KnLUE/Trc+VfhC+PE5DJMTg6L4zvUu?=
 =?us-ascii?Q?BAPqxjdK0iwXJqGDzzBKUt/aqhftRzvmvGbRlrhb5JPBuVGzbSCbyS4kBYfy?=
 =?us-ascii?Q?lonK9anAXiVhEWnFfWG+TCK3JUjAVPbcUDVDpfZdqYi81Hb8b2+8Fbe8n2GE?=
 =?us-ascii?Q?2GuigNRP5UliGoOWpCfuhmRO/2wIO+wP2wn3yMjPD4fFi4+NAJUOxX51N/T8?=
 =?us-ascii?Q?wQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cd0d643-94ee-4ab7-f37b-08db6d86ab8f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 09:55:37.5763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3ky0MDqyA7Zz/VWKAL12DaqJBBYixhC2x1JJ3M6u0JDq5ILNbW6FpbpoEcnymczXUso2n3rL3VeYO5zVi+bfqlxdDs0VUTLq+kY1/AJAG8w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5378
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 11:45:36AM +0200, Simon Horman wrote:

Hi Simon,

> In igc_clean_rx_irq() the result of a call to igc_xdp_run_prog() is assigned
> to the skb local variable. This may be an ERR_PTR.
> 
> A little later the following is executed, which seems to be a
> possible dereference of an ERR_PTR.
> 
> 	total_bytes += skb->len;
> 
> Avoid this problem by continuing the loop in which all of the
> above occurs once the handling of the NULL case completes.
> 
> This proposed fix is speculative - I do not have deep knowledge of this
> driver.  And I am concerned about the effect of skipping the following
> logic:
> 
>   igc_put_rx_buffer(rx_ring, rx_buffer, rx_buffer_pgcnt);
>   cleaned_count++;

this will break - you have to recycle the buffer to have it going.

> 
> Flagged by Smatch as:
> 
>   .../igc_main.c:2467 igc_xdp_run_prog() warn: passing zero to 'ERR_PTR'

how about PTR_ERR_OR_ZERO() ? this would silence smatch and is not an
intrusive change. another way is to get rid of ERR_PTR() around skb/xdp
run result but i think the former would be just fine.

> 
> Compile tested only.
> 
> Fixes: 26575105d6ed ("igc: Add initial XDP support")
> Signed-off-by: Simon Horman <horms@kernel.org>
> ---
>  drivers/net/ethernet/intel/igc/igc_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index 88145c30c919..b58c8a674bd1 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -2586,6 +2586,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
>  
>  			total_packets++;
>  			total_bytes += size;
> +			continue;
>  		} else if (skb)
>  			igc_add_rx_frag(rx_ring, rx_buffer, skb, size);
>  		else if (ring_uses_build_skb(rx_ring))
> 
> 

