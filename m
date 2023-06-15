Return-Path: <netdev+bounces-11082-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D71D73182C
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:10:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3811D1C20E5D
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:10:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA68E1548B;
	Thu, 15 Jun 2023 12:10:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B8EF9DF;
	Thu, 15 Jun 2023 12:10:05 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C606184;
	Thu, 15 Jun 2023 05:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686831004; x=1718367004;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Iy8vky0TtHl9qJmkyGCK28hLxEiAuJ1yhtXed5pyQh4=;
  b=mr9AviZFAlkKIoai7rSh6kLeQl3VYpxgq3lTsetbnGHlMDBc6sA2Z0a9
   99fVFyR1+oPyiT8aBUjupKG9RMWv6rrnkKd7dS2uxSZNHLnXo4j43QE9W
   EiA8YXZaqCdLdi40PbZjGU4nxjkjpTEbP35nhBiywlCSY48BJCXLijaGJ
   zEbqceUORFIvyWtON7MfVRLuDol2qbptWMvi/dYLBl2cuknSdBZYBTMf2
   htqxUjLjMYkYwCIjqwnMHFhR7hPfdj26E3c+SEpZc4+ZtmeO9exWYns9C
   O3wWJfPbKCYzIos2yhCgSyn9JkjJitk7I7+y26NnPtXHdlG+nn765m3fN
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="387357457"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="387357457"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 05:10:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="959175296"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="959175296"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 15 Jun 2023 05:10:03 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 05:10:02 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 05:10:02 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 05:10:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nOtcAtZBt7amRvylvVcoagp7V/lFccWhGirvI7GLkPsEWNl7hJ6xpYQeRM4cMxBAwNgXX2it8pdDYgdabze+3wuX2XiWTkOsLYsxjoqX64yJSuQkIoz7LsMXmEQz3aQs0cLwVCqcyO/4Hrok4/8g2MKyEZ66ked/rJMcsGNVFsxcilGS7ZVoGts8bPCDjMKyOED7K6lzDmyEjf9p2/fUOoL1YeHcsjTLjxq5a3BYrpTssjG/HQe0NsBCKJ4J3szSsOIvoq9s8Sc4F7J93VEtNvy/NsfGuvA1eKXASyAzAIe2493o9TD+qYSfFTICJAy21NAP2/O23eR/AwKaOj7wOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G0OdCMM/K7oy7wD+OzDfwdQp0oMw6QKVz2t7emaoqPE=;
 b=G9IUu8nS9UkYuX0OO4Hf3ojghdPJ5Zeepxs3CosG+9TvjEcvX/S1lTRKqWIAZAPeazVNPNBL4pHPNCdsJEd4kuulz5LdNZWLtAKGNfU6NeEe+OKfwahNBgEsdu9x4yGsVg32LcRSXUvwcozY7vViQTtLvWqoFSeGq51GWXPFF0G79z9fJi2gc0oLPHzWOCThMYSz0h9uKDKLrZzvwJoS/7IZXwk0+l2uxO3G+UeCPjQ6bCkirQtUcdenEwSRrMOqNX7TPi+3CWJmYZIse2pcelPLtpbuKLHbDbCpnbBtkHZ/SeEMIlQ+qksz2M54XKcH94wOh21c3LO1ssk3L9nziQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH8PR11MB7992.namprd11.prod.outlook.com (2603:10b6:510:25b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.46; Thu, 15 Jun
 2023 12:10:00 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.028; Thu, 15 Jun 2023
 12:10:00 +0000
Date: Thu, 15 Jun 2023 14:09:45 +0200
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
Message-ID: <ZIr/iX7qNbUpXocP@boxer>
References: <20230615-igc-err-ptr-v1-1-a17145eb8d62@kernel.org>
 <ZIrgEVVQfvJwneLx@boxer>
 <ZIr1s6KHVGh/ZuEj@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZIr1s6KHVGh/ZuEj@kernel.org>
X-ClientProxiedBy: FR0P281CA0145.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::18) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH8PR11MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: 12eb4705-17ea-4cc9-ce8a-08db6d9970e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xk37nDvTW5i8AUSQVDNJmodDfsnpbMUVppw/Jkxyk56xB2oyBWxmpn7L/4tXmGos70fJ6E0jRA9aWvF3rlMoFg596J8Q6ZOE8HiLs5lDVZlniQaQ7LnUrHfrnr4ibPfL4+eLDycYMblwoqcraOPvnom9FW7+2kvWW5d9xCYYXyFQ4VY/chRisQlvQIVTNif0LDV2+7GpqwCG13+dW36Zb3Wpb+SR60S121rFlrkCzacQnWcy337+YKPfvZlYLCHVJNGVYdFKSApQPdP8oZXyKxyfY5k4RKAjHty5pb2uPj0S7SK3l4x4CkJm1L2zQ+dhcYcyNDt4u0Tx1i1FgHnjATlJlGHds0Qn/pfe+cqHQLDdRNBC0iw7HllRGtGmFo+6P33z2tSLYJMum4fFg3g41+tE3vdsZf4hpptp+1l/uNYaSSsCtxAnRntTYc8F6c13rTUDIhBlF8d7kQcJeOd/2wGwEHwNgvPY1UcJzoJ5Xi5+NUnsGMHfDeSi1e7dAZNGFncWgGJDnJpbSheGD5C36s6tdez05V6YFO+/ro6cSc76dIU3CjApIjrEy50mSXF6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(366004)(136003)(39860400002)(376002)(396003)(346002)(451199021)(6916009)(4326008)(66556008)(66946007)(186003)(478600001)(54906003)(2906002)(66476007)(316002)(6666004)(8676002)(41300700001)(86362001)(6486002)(7416002)(33716001)(6506007)(9686003)(44832011)(8936002)(38100700002)(82960400001)(5660300002)(26005)(83380400001)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FYXw6Kr3wbhqGgy6GysDSWLr9JVByQMwPRLPbVzGoKYoM/pV+dGgpNHKZnbQ?=
 =?us-ascii?Q?QG6B5o49kl43NUddOnPIZiR/ZzXULdW0yMHsYYZw0UlM5nY/zb5GOIbzBMHt?=
 =?us-ascii?Q?bvDNMPPnVlvg1er8GTqnzXzqW/0K5XHf28RFvYO4SM6N/gW9VBsIbEE9FGBn?=
 =?us-ascii?Q?TA0eUsTnk+h6z028w2BJT6P9wm6Tbq1l653pAhULzql/62h/WBR7WzgJkYY1?=
 =?us-ascii?Q?sSjOWf4/ydV1W6M0t3c55hZBiEFeNu6Jn3j6SYLeqqxhc6EAChgoGyl0Kl8l?=
 =?us-ascii?Q?u/NLQYJXDQjeh3oskNo+Ik5k9CCTGHpffVRSIOugcwS/2IycHWD2e06Ws7rZ?=
 =?us-ascii?Q?5N/+ZVWeFlaEA6SDRCVQzoHdl7jr/xNPqzStfzPGdXyYgzSJbrGm12VC2LT4?=
 =?us-ascii?Q?jEUUx0eBBPsiYDtlt6IFwHoDVyefHcNm6m5sVKxTSsY4/8tGRA73xtRvqeD+?=
 =?us-ascii?Q?YunrbXS76brgGy4AY6u3f2mpntKRwuQDrc01KJSbli1ZCrU0PKNPmLKUd1Ba?=
 =?us-ascii?Q?I45nMDrTVFGkVQC9pI+F8buMXFz7aQAsuNptcsg5q1B7eyonh1ndoeLDb+t1?=
 =?us-ascii?Q?Lo0xMS9lg2h4f1O5IC9nuGUn1dt9XTxX+tJ+xNJVQk09qxc81vLyzQEUY+/g?=
 =?us-ascii?Q?7dml9G/WfNhjo0/OOG3Xj+POK+rcE5nTrieBfoWPPkJ3QDz/zh39If+VOrVf?=
 =?us-ascii?Q?102GvpQYWu8fHa5ekPALOVIea/dyCiNdbrq2CgWltsBPOA5zJu8s8yvRNSuE?=
 =?us-ascii?Q?hS/SJHV4P8w4d8qNyno2HviC7DPQTuHee4P8bhKA1exidFYdmqRObtkIbrsq?=
 =?us-ascii?Q?FfTGYs7nSi+RW3VEpZelAi6/DYGgt38z3msTFtqtt7IdvQPIFkN/HGKhCZvF?=
 =?us-ascii?Q?mjHEgRkmGQvbNV7QDDXRpur129t8+fzxzmj6evB5/iiwNvHHJhBPGQ30H7wk?=
 =?us-ascii?Q?sirHQgzFRDyak87FCek6kxGH5CsJmahTye154aBNq+15nk2neBANBg6HuhW4?=
 =?us-ascii?Q?sq8d8NtIC1zkf9FueF4Umu7VNbf/pQ/MgUQy6yW5wlmJOip4pjjhZx18eXYM?=
 =?us-ascii?Q?zYWBEz85ZIIlWSnPe3roLupw+TbmgaTaWyOdXV/aszlAtZoNrufdlc4l1ygh?=
 =?us-ascii?Q?lC1Dk0GDIUhXtll02Uwuc+sURGHMuIfs38I60wMuOOp2I13Kv+rA9hdx5Ry6?=
 =?us-ascii?Q?jYvIZxxszRNvYkWjfnxC7BDvwjqNCoojZqhwNTkEetAtoPzd1MJ5uLU6TRqe?=
 =?us-ascii?Q?1lD0lYCxzd9cIliG3q4/Jirp24xQY/5ctkSkAWu/bRqZfit1++52XK81d956?=
 =?us-ascii?Q?DGZzaDYCyN+13WO5MzDxwPWX6LT0eZVkC4qLitJOnDUV8aDWytZnglDBcxRH?=
 =?us-ascii?Q?gIM0yJCobaalWx49ltfEOWK+bkc18ezaVLdaOWg/PneRw1d0mEaZyqEl7Hio?=
 =?us-ascii?Q?SETDdRSU3AJcoA/LOnvzPITDoFb/tUSNoCSSI7xUUk8pMLtcqZ+escuBVxU/?=
 =?us-ascii?Q?nopRD8gQ4RmdvSxo3GAK+WrBV77xDuDmg4NuFWcjIqJaoSv4rSyu92l8n4Ck?=
 =?us-ascii?Q?Ve5H4TdRJuqmm55nwZ03qxLrFOQ1Xz3/4iwj8HItljozLBtFRLHfOnLcfxxI?=
 =?us-ascii?Q?VA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 12eb4705-17ea-4cc9-ce8a-08db6d9970e5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 12:09:59.7849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YRK3mWQxCtT3UNUByvanmx5p37942YE9yPUzuoXyx99vocgVR4nF37qJUj9OEzWnVIfrFeN8ptC6+ZzLuCXDDYyLrntYkdQWq4mfAoKlX5U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7992
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 01:27:47PM +0200, Simon Horman wrote:
> On Thu, Jun 15, 2023 at 11:55:29AM +0200, Maciej Fijalkowski wrote:
> > On Thu, Jun 15, 2023 at 11:45:36AM +0200, Simon Horman wrote:
> 
> Hi Marciej,
> 
> > Hi Simon,
> > 
> > > In igc_clean_rx_irq() the result of a call to igc_xdp_run_prog() is assigned
> > > to the skb local variable. This may be an ERR_PTR.
> > > 
> > > A little later the following is executed, which seems to be a
> > > possible dereference of an ERR_PTR.
> > > 
> > > 	total_bytes += skb->len;
> > > 
> > > Avoid this problem by continuing the loop in which all of the
> > > above occurs once the handling of the NULL case completes.
> > > 
> > > This proposed fix is speculative - I do not have deep knowledge of this
> > > driver.  And I am concerned about the effect of skipping the following
> > > logic:
> > > 
> > >   igc_put_rx_buffer(rx_ring, rx_buffer, rx_buffer_pgcnt);
> > >   cleaned_count++;
> > 
> > this will break - you have to recycle the buffer to have it going.
> 
> Thanks. As I said I wasn't sure about the fix: it was a strawman.
> 
> > > Flagged by Smatch as:
> > > 
> > >   .../igc_main.c:2467 igc_xdp_run_prog() warn: passing zero to 'ERR_PTR'
> > 
> > how about PTR_ERR_OR_ZERO() ? this would silence smatch and is not an
> > intrusive change. another way is to get rid of ERR_PTR() around skb/xdp
> > run result but i think the former would be just fine.
> 
> Sorry, there were two warnings. And I accidently trimmed the one
> that is more relevant instead of the one that is less relevant.
> I do agree the one above does not appear to be a bug.
> 
> But I am concerned abut this one:
> 
>   .../igc_main.c:2618 igc_clean_rx_irq() error: 'skb' dereferencing possible ERR_PTR()
> 
> If skb is an error pointer, e.g. ERR_PTR(-IGC_XDP_PASS), and
> it is dereferenced, that would be a problem, right?

IGC_XDP_PASS is 0. -0 is still 0 right?

this means skb is NULL and igc_{build,construct}_skb() will init it. For
ERR_PTR, igc_cleanup_headers() does IS_ERR() against it and continues. So
you will get to line 2618 only for valid skb, it just happens that logic
is written in a way that skb is supposed to carry XDP return code. We
removed this in ice for example but i40e works like that for many years
without issues, AFAICT...

> 
> Perhaps I'm missing something obvious and this can't occur.
> But it does seem possible to me.
> 
> > 
> > > 
> > > Compile tested only.
> > > 
> > > Fixes: 26575105d6ed ("igc: Add initial XDP support")
> > > Signed-off-by: Simon Horman <horms@kernel.org>
> > > ---
> > >  drivers/net/ethernet/intel/igc/igc_main.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> > > index 88145c30c919..b58c8a674bd1 100644
> > > --- a/drivers/net/ethernet/intel/igc/igc_main.c
> > > +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> > > @@ -2586,6 +2586,7 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
> > >  
> > >  			total_packets++;
> > >  			total_bytes += size;
> > > +			continue;
> > >  		} else if (skb)
> > >  			igc_add_rx_frag(rx_ring, rx_buffer, skb, size);
> > >  		else if (ring_uses_build_skb(rx_ring))
> > > 
> > > 
> > 

