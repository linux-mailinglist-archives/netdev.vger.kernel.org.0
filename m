Return-Path: <netdev+bounces-10183-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE76A72CAF9
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 18:05:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9BCC1C20BAA
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 16:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB8DB1F934;
	Mon, 12 Jun 2023 16:05:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B001DDF8
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 16:05:22 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A377D10F5
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 09:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686585919; x=1718121919;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=0MDK//DisKbkujIBhW0nLsfuBG/XqniLJfJ53nhkQEg=;
  b=U/vc2cnGYHJyDfmHTf8m45rJYvqYKR8uZf79CVgkyYhq9pwQKX3j59z7
   C5k5oHFnv3CiABYES7C8RkZQQFDeSDwwxVsIH5QX1IOuj5RKAtznpPO9T
   gg/Fxh2aHXooHBMCWG7aRmkYPK+GmAqScSgL6G5k0dtypLpvHrE2pScjj
   nUm+784OO8B7degp1+7yk31sHvccGmr0q6Qxk7vd7Yxhh4DoOy//+inv8
   8e0b2QWb96REeWEuql9n83zdj2vRbqWoyDZ5Ketlr2Bmq2eeP9TrHN2x8
   DKBQM8fCkssr/Y5lo0M0Ov0aaa4QWuZ4RUk938dMFDnmm9BOxgdrQ9zMc
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="421679160"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="421679160"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2023 09:04:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="885503104"
X-IronPort-AV: E=Sophos;i="6.00,236,1681196400"; 
   d="scan'208";a="885503104"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 12 Jun 2023 09:04:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 09:04:47 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 12 Jun 2023 09:04:47 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 12 Jun 2023 09:04:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FcFLrUCRGfAUHPsx+6S75doked8KiAPm2+K1sUsiuT6iZzg9YhfHB3ZWItdp4JTc8yqXCzoWwMkAMEoTGB/lO4tXMOlKHIrBrU2MgVb7IOM2/BLEQzkAuw6w5fcxfYIeY98ZljDCjXsDUn5V4A8nVQIyzcKL01Rx2mSrtp1bW6ftIv2r6buyAqP8l58Q8bWKPdnGi4fgZc4NDqLIhgBu0iYaphtueC7C+lnLLs7J8zH3Gp1YWjULN+unrGM573/FvcGHFqxA0XFEsfugjFvK92eYQwLg667hXskbcs2L1hRvfA5Ovsyc6ZyirUcgcCtpiE6Bwy2tO08n3d4wibVJPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y0osm5cTaYAdrQln8FUm3giiRDm22LqDeg+ocNKuBqY=;
 b=W3/qsCJg70DXK/xw7xNnCbHFBogt/doBITkd2NCXaWlSfhxYXu1JgOKTcCBZfq5eBUGqjuN8d95L8er5iB3CerIy2303RvLpz0FmXFpGD3Lw+bB9SEyIkpnHDZFoBwl2YzqNZe15uc4o5u1MxQ6e150JS5i5ydfipYWXatMJdJSf0+QsI81tH8mML/pmkShGdycbRvovaseQ4zHl2szdcila9PBLQiL6h5KZlUYi+94iSra0rprd+g4i+O+1zJgCYODNlIBXKHpRCaxpiQMS2+RBxNEUyMaD5b/Ojy9Wxn4KdCMx1K0amoymIoLoGuUSGT2X2roC/ZZG1T/NEqA1fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 IA1PR11MB7726.namprd11.prod.outlook.com (2603:10b6:208:3f4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.41; Mon, 12 Jun
 2023 16:04:44 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.028; Mon, 12 Jun 2023
 16:04:44 +0000
Date: Mon, 12 Jun 2023 18:04:37 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
CC: <ecree.xilinx@gmail.com>, <habetsm.xilinx@gmail.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>,
	Fei Liu <feliu@redhat.com>
Subject: Re: [PATCH net] sfc: use budget for TX completions
Message-ID: <ZIdCFbjr0nEiS6+m@boxer>
References: <20230612144254.21039-1-ihuguet@redhat.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230612144254.21039-1-ihuguet@redhat.com>
X-ClientProxiedBy: FRYP281CA0015.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::25)
 To DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|IA1PR11MB7726:EE_
X-MS-Office365-Filtering-Correlation-Id: edadc815-687d-4468-c58d-08db6b5ebcd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mGURz7dDLLsIjP+zcF29vHYK/idSIHnKTWg8bYj6tVqr7oMz4fC8Da4+3yJvqoxxXuH4GcAo4x6JghwXuM/MODacM/CALo7M6usnslhHPmQmJ7HiKoQiYZADatyAPOR+anc+4AU9uhKXOKrZ5wUOalTLS7Ti7gms+VAAJW6zv4RNtRS753lkEVxSZYtyBODEZKWhy0pVuG6UD7lo/9hEdufGJ9urhrWBJDrTYBmYBKUeh/gNzXdghx1NkWzxmQ+hUdpfuh6rNfGybTbUJKi7VjDBpFmETIbYauDIex5Ym4jDVCYysYC0ijZOUsBdzH8RcPzV3o7kolv50iUfWR8piauye1Nv6pD8CVtWoQod6PNrOv3eFZubxaiApulVOkjN9/Hpb/+AwzbOd1L2Q/VH037XMuQQvNtDfKFgjvYdaylyCi16BRDnGeaaN5gs37WYWYOV6PfDwRP4sHYY17uOJXywrQrU0X958PuP5XmKxCpMP04a97/hPfjyoD2vUv2FP9UBfsd63hmxFE8A8owvBsG6Ia4o4fKg7R5InIG//ZY5E4zQ6ThV9lnEH1gXqn2iCwkP9v1Xs7jAUqgzusPcVbCkcI0fJUYqvc+0ew12bmw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(396003)(376002)(366004)(346002)(136003)(39860400002)(451199021)(8676002)(6916009)(478600001)(82960400001)(66556008)(8936002)(38100700002)(4326008)(66476007)(41300700001)(316002)(66946007)(186003)(6512007)(6666004)(6486002)(83380400001)(6506007)(26005)(9686003)(44832011)(33716001)(86362001)(5660300002)(7416002)(2906002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?+ee/nAcr7GpL/7pMhQ7dUA2r+VaGkbVj/4rkIbh+xlKB8uU4cbBuIiHl5j?=
 =?iso-8859-1?Q?6WOntpzSZzB8TEw8udvXBHOrpRODmA5CsLti1ln+z4M2FnrREfJYXkQ4U5?=
 =?iso-8859-1?Q?n3j3mOdRPYiXvQhVfxd+0R+1DRKuP6dXIPyCDOAiREhQJhNy8r07YxSLgu?=
 =?iso-8859-1?Q?D5e51vjzhwerkGifa3u50+JLRDvfUH7+odk3xqpGStVCtWAbJ5jkPhtKHy?=
 =?iso-8859-1?Q?WnvsSqQ/6xcQYO68wQohQMFQmf7S/ySJWL1ztaz+MT0sUA5W7m4q4Uhmc6?=
 =?iso-8859-1?Q?BX2JZ9KLx+AXFqUpUP5fubohMfvnsTwCgL6sODM76t+VkYT342u3HfxcLQ?=
 =?iso-8859-1?Q?cNwcEWkKEAAV4snhtOc15W/KzWFfweT+Ct0eAsleR/vsWXY6n0lUIWmbFd?=
 =?iso-8859-1?Q?yF2VzkaCBNxGkXCJZckvl2T8ImSMjAF7x1dI36INW2diQKcVfTTbPFy6+W?=
 =?iso-8859-1?Q?oP5h9KGbB3m3/95eqamjOku8lANvC1xqlFlOyrn6Hlls2ScyRDwOksDCrs?=
 =?iso-8859-1?Q?WDWZnoWpAm4edvoNsWWpW+njtVpB0FsJjk82nSMS7Qy0zzknCbICOiWuuO?=
 =?iso-8859-1?Q?xqmLEe4kD7UHWYHG9yK2I7ZQuic0MfLs6SFh8/djcFYqX0XjJFJnnkb8yU?=
 =?iso-8859-1?Q?TzQvOZHukxfKg4YvIRY6+YFWWxfSKx552EqBMbPfl2Fvn00ujX+aWmAXVV?=
 =?iso-8859-1?Q?mgi+0rXdLeCeGMJ3uJzSQPkTN9QLI9lSl/px4UjIXi4or8+h7/orw+nbpt?=
 =?iso-8859-1?Q?vhRGkKnoSNZUhXL/X3KsXC3JCvqmer/h/tlDyQLx9/hfF9iT229jYlKJxa?=
 =?iso-8859-1?Q?Ur5PAwB467CXYonUaGmTQqwgWxIYqanltgZZhNRj+kE+Eo13u4spUpZy1e?=
 =?iso-8859-1?Q?dP2jJA9luroa0RlKQw4MrYJXkFtQNiz9z1ICOblGNp9ND9P9nMPFrAvE8H?=
 =?iso-8859-1?Q?i0fUS6bpuXwNzgsBV6Bma3ITVYXMewKSORW0pX1cN2cFGDWPhn50/o9w98?=
 =?iso-8859-1?Q?RHJsRO7lL9mOFJEWd+3Sv7n1iyYFhrn99SBsvTyhFna1JpgBncVpm9aYqg?=
 =?iso-8859-1?Q?mPiQthQAS2rcn5UQzBZHcpvXsgThJVBkf+VsLB2OZeARQzNbkfI306Jqte?=
 =?iso-8859-1?Q?yqJ98HgxfY5x9FdFfy/B0eYUjwcq7fSs7rA3iJdbP3IaGI4cqyXJMNvKMf?=
 =?iso-8859-1?Q?UOfojGwQ04QzYY2Av3oc8Qu22+duwL2OuSlmuM3vgFYK+CpNZO1nafd5kE?=
 =?iso-8859-1?Q?O2Hy5J4xVqcBpRhH2IGu542IvSGjPVFl1YBTzPv6sf0mIdzynm4MYDrSMq?=
 =?iso-8859-1?Q?JH74r0p8vLwmkdva5kVK3YMD9Lm1MV/sRP7gxFwNbYi1W8BK77/TGdC4we?=
 =?iso-8859-1?Q?MkV21k7JaM0323L4rKJ+mdVWOJ7AjI/RL0me7wl1hfR1HkL1KvRwYCh2Bo?=
 =?iso-8859-1?Q?t+E+GH4BxnWp5FYUvQLjad8fvJ3tYxh3BrXN+hnMvcKcJ4r7Bnx4a9ckku?=
 =?iso-8859-1?Q?3oykxJfNa48a/lidLdMkD1hxr80JYCwT3CQMhiaRIv+xV40SFy/KyUnOyG?=
 =?iso-8859-1?Q?Ell8ohyvBmOBwgWkuOzXoTOK+GnK9LMTQ+0GTGkAXG46OSh5uMDJjYyqgZ?=
 =?iso-8859-1?Q?t6LEIvs84PiON3LoWHGc8sdYHQK+eHq1vUz77NQTlTz3QNqBU7Tm23Lw?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: edadc815-687d-4468-c58d-08db6b5ebcd8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 16:04:44.5006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ct2K/iB4zGdFAR+fbUNZ0oiMdk9y1qCQjbbJZpJSeK96ksxsZ38CzeIJhq4XjY09kZ5UnxxJgJBT8dS6c9wJib+ydGvwVBu5uz+22rOqsr4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7726
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 04:42:54PM +0200, Íñigo Huguet wrote:

Hey Inigo, some trivial things below.

> When running workloads heavy unbalanced towards TX (high TX, low RX
> traffic), sfc driver can retain the CPU during too long times. Although
> in many cases this is not enough to be visible, it can affect
> performance and system responsiveness.
> 
> A way to reproduce it is to use a debug kernel and run some parallel
> netperf TX tests. In some systems, this will lead to this message being
> logged:
>   kernel:watchdog: BUG: soft lockup - CPU#12 stuck for 22s!
> 
> The reason is that sfc driver doesn't account any NAPI budget for the TX
> completion events work. With high-TX/low-RX traffic, this makes that the
> CPU is held for long time for NAPI poll.
> 
> Documentations says "drivers can process completions for any number of Tx
> packets but should only process up to budget number of Rx packets".
> However, many drivers do limit the amount of TX completions that they
> process in a single NAPI poll.
> 
> In the same way, this patch adds a limit for the TX work in sfc. With
> the patch applied, the watchdog warning never appears.
> 
> Tested with netperf in different combinations: single process / parallel
> processes, TCP / UDP and different sizes of UDP messages. Repeated the
> tests before and after the patch, without any noticeable difference in
> network or CPU performance.
> 
> Test hardware:
> Intel(R) Xeon(R) CPU E5-1620 v4 @ 3.50GHz (4 cores, 2 threads/core)
> Solarflare Communications XtremeScale X2522-25G Network Adapter
> 
> Reported-by: Fei Liu <feliu@redhat.com>
> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>

You're missing Fixes: tag.

> ---
>  drivers/net/ethernet/sfc/ef10.c      | 25 ++++++++++++++++++-------
>  drivers/net/ethernet/sfc/ef100_nic.c |  7 ++++++-
>  drivers/net/ethernet/sfc/ef100_tx.c  |  4 ++--
>  drivers/net/ethernet/sfc/ef100_tx.h  |  2 +-
>  drivers/net/ethernet/sfc/tx_common.c |  4 +++-
>  drivers/net/ethernet/sfc/tx_common.h |  2 +-
>  6 files changed, 31 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
> index d30459dbfe8f..b63e47af6365 100644
> --- a/drivers/net/ethernet/sfc/ef10.c
> +++ b/drivers/net/ethernet/sfc/ef10.c
> @@ -2950,7 +2950,7 @@ static u32 efx_ef10_extract_event_ts(efx_qword_t *event)
>  	return tstamp;
>  }
>  
> -static void
> +static int
>  efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
>  {
>  	struct efx_nic *efx = channel->efx;
> @@ -2958,13 +2958,14 @@ efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
>  	unsigned int tx_ev_desc_ptr;
>  	unsigned int tx_ev_q_label;
>  	unsigned int tx_ev_type;
> +	int work_done;
>  	u64 ts_part;
>  
>  	if (unlikely(READ_ONCE(efx->reset_pending)))
> -		return;
> +		return 0;
>  
>  	if (unlikely(EFX_QWORD_FIELD(*event, ESF_DZ_TX_DROP_EVENT)))
> -		return;
> +		return 0;
>  
>  	/* Get the transmit queue */
>  	tx_ev_q_label = EFX_QWORD_FIELD(*event, ESF_DZ_TX_QLABEL);
> @@ -2973,8 +2974,7 @@ efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
>  	if (!tx_queue->timestamping) {
>  		/* Transmit completion */
>  		tx_ev_desc_ptr = EFX_QWORD_FIELD(*event, ESF_DZ_TX_DESCR_INDX);
> -		efx_xmit_done(tx_queue, tx_ev_desc_ptr & tx_queue->ptr_mask);
> -		return;
> +		return efx_xmit_done(tx_queue, tx_ev_desc_ptr & tx_queue->ptr_mask);
>  	}
>  
>  	/* Transmit timestamps are only available for 8XXX series. They result
> @@ -3000,6 +3000,7 @@ efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
>  	 * fields in the event.
>  	 */
>  	tx_ev_type = EFX_QWORD_FIELD(*event, ESF_EZ_TX_SOFT1);
> +	work_done = 0;
>  
>  	switch (tx_ev_type) {
>  	case TX_TIMESTAMP_EVENT_TX_EV_COMPLETION:
> @@ -3016,6 +3017,7 @@ efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
>  		tx_queue->completed_timestamp_major = ts_part;
>  
>  		efx_xmit_done_single(tx_queue);
> +		work_done = 1;
>  		break;
>  
>  	default:
> @@ -3026,6 +3028,8 @@ efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
>  			  EFX_QWORD_VAL(*event));
>  		break;
>  	}
> +
> +	return work_done;
>  }
>  
>  static void
> @@ -3081,13 +3085,16 @@ static void efx_ef10_handle_driver_generated_event(struct efx_channel *channel,
>  	}
>  }
>  
> +#define EFX_NAPI_MAX_TX 512
> +
>  static int efx_ef10_ev_process(struct efx_channel *channel, int quota)
>  {
>  	struct efx_nic *efx = channel->efx;
>  	efx_qword_t event, *p_event;
>  	unsigned int read_ptr;
> -	int ev_code;
> +	int spent_tx = 0;
>  	int spent = 0;
> +	int ev_code;
>  
>  	if (quota <= 0)
>  		return spent;
> @@ -3126,7 +3133,11 @@ static int efx_ef10_ev_process(struct efx_channel *channel, int quota)
>  			}
>  			break;
>  		case ESE_DZ_EV_CODE_TX_EV:
> -			efx_ef10_handle_tx_event(channel, &event);
> +			spent_tx += efx_ef10_handle_tx_event(channel, &event);
> +			if (spent_tx >= EFX_NAPI_MAX_TX) {
> +				spent = quota;
> +				goto out;
> +			}
>  			break;
>  		case ESE_DZ_EV_CODE_DRIVER_EV:
>  			efx_ef10_handle_driver_event(channel, &event);
> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
> index 4dc643b0d2db..7adde9639c8a 100644
> --- a/drivers/net/ethernet/sfc/ef100_nic.c
> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> @@ -253,6 +253,8 @@ static void ef100_ev_read_ack(struct efx_channel *channel)
>  		   efx_reg(channel->efx, ER_GZ_EVQ_INT_PRIME));
>  }
>  
> +#define EFX_NAPI_MAX_TX 512

couldn't this go to tx_common.h ? you're defining this two times.

> +
>  static int ef100_ev_process(struct efx_channel *channel, int quota)
>  {
>  	struct efx_nic *efx = channel->efx;
> @@ -260,6 +262,7 @@ static int ef100_ev_process(struct efx_channel *channel, int quota)
>  	bool evq_phase, old_evq_phase;
>  	unsigned int read_ptr;
>  	efx_qword_t *p_event;
> +	int spent_tx = 0;
>  	int spent = 0;
>  	bool ev_phase;
>  	int ev_type;
> @@ -295,7 +298,9 @@ static int ef100_ev_process(struct efx_channel *channel, int quota)
>  			efx_mcdi_process_event(channel, p_event);
>  			break;
>  		case ESE_GZ_EF100_EV_TX_COMPLETION:
> -			ef100_ev_tx(channel, p_event);
> +			spent_tx += ef100_ev_tx(channel, p_event);
> +			if (spent_tx >= EFX_NAPI_MAX_TX)
> +				spent = quota;
>  			break;
>  		case ESE_GZ_EF100_EV_DRIVER:
>  			netif_info(efx, drv, efx->net_dev,
> diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
> index 29ffaf35559d..849e5555bd12 100644
> --- a/drivers/net/ethernet/sfc/ef100_tx.c
> +++ b/drivers/net/ethernet/sfc/ef100_tx.c
> @@ -346,7 +346,7 @@ void ef100_tx_write(struct efx_tx_queue *tx_queue)
>  	ef100_tx_push_buffers(tx_queue);
>  }
>  
> -void ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_event)
> +int ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_event)
>  {
>  	unsigned int tx_done =
>  		EFX_QWORD_FIELD(*p_event, ESF_GZ_EV_TXCMPL_NUM_DESC);
> @@ -357,7 +357,7 @@ void ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_event)
>  	unsigned int tx_index = (tx_queue->read_count + tx_done - 1) &
>  				tx_queue->ptr_mask;
>  
> -	efx_xmit_done(tx_queue, tx_index);
> +	return efx_xmit_done(tx_queue, tx_index);
>  }
>  
>  /* Add a socket buffer to a TX queue
> diff --git a/drivers/net/ethernet/sfc/ef100_tx.h b/drivers/net/ethernet/sfc/ef100_tx.h
> index e9e11540fcde..d9a0819c5a72 100644
> --- a/drivers/net/ethernet/sfc/ef100_tx.h
> +++ b/drivers/net/ethernet/sfc/ef100_tx.h
> @@ -20,7 +20,7 @@ void ef100_tx_init(struct efx_tx_queue *tx_queue);
>  void ef100_tx_write(struct efx_tx_queue *tx_queue);
>  unsigned int ef100_tx_max_skb_descs(struct efx_nic *efx);
>  
> -void ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_event);
> +int ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_event);
>  
>  netdev_tx_t ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb);
>  int __ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
> diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
> index 67e789b96c43..755aa92bf823 100644
> --- a/drivers/net/ethernet/sfc/tx_common.c
> +++ b/drivers/net/ethernet/sfc/tx_common.c
> @@ -249,7 +249,7 @@ void efx_xmit_done_check_empty(struct efx_tx_queue *tx_queue)
>  	}
>  }
>  
> -void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
> +int efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
>  {
>  	unsigned int fill_level, pkts_compl = 0, bytes_compl = 0;
>  	unsigned int efv_pkts_compl = 0;
> @@ -279,6 +279,8 @@ void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
>  	}
>  
>  	efx_xmit_done_check_empty(tx_queue);
> +
> +	return pkts_compl + efv_pkts_compl;
>  }
>  
>  /* Remove buffers put into a tx_queue for the current packet.
> diff --git a/drivers/net/ethernet/sfc/tx_common.h b/drivers/net/ethernet/sfc/tx_common.h
> index d87aecbc7bf1..1e9f42938aac 100644
> --- a/drivers/net/ethernet/sfc/tx_common.h
> +++ b/drivers/net/ethernet/sfc/tx_common.h
> @@ -28,7 +28,7 @@ static inline bool efx_tx_buffer_in_use(struct efx_tx_buffer *buffer)
>  }
>  
>  void efx_xmit_done_check_empty(struct efx_tx_queue *tx_queue);
> -void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index);
> +int efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index);
>  
>  void efx_enqueue_unwind(struct efx_tx_queue *tx_queue,
>  			unsigned int insert_count);
> -- 
> 2.40.1
> 
> 

