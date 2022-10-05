Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59ECF5F528C
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 12:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiJEK1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 06:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiJEK1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 06:27:45 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF425004C
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 03:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664965664; x=1696501664;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yhvj4iauZC2g7vyGiVueCm/BtGPavzt5JF3xNT5HlSU=;
  b=fv6Vzsu0hLsQfnR5nv/SGFIWXVyjpetT+QMIQtynTdLBr4W1VvmFzABb
   wyPRCIKMC3Y0sMabuH+7TD9egn/VbdC+uAxj2oeiOz4TdRVcTAKrcjAkP
   Xqwmu0/BGQO/fDtxbs4h8UFiEz9i/wuteIQnOD374kxO94ttSVMXsPdYU
   k9NYYWgyYKXOKxv/qZ+MdTk4Stku0xwHogkdUuFvJWpOs7hnK2EfuFgba
   D5UKsewFaEic5IZ9jLQHLO9sGshVtdC3ri9XCyQxRj1RZr5PsBYV0U6aV
   sxqi9q0lnirFYV5qWyepDhcOMK1O0r6swyMoQ2w1sWopExBEOC9pJtAHY
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="283496013"
X-IronPort-AV: E=Sophos;i="5.95,159,1661842800"; 
   d="scan'208";a="283496013"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 03:27:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10490"; a="575365143"
X-IronPort-AV: E=Sophos;i="5.95,159,1661842800"; 
   d="scan'208";a="575365143"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 05 Oct 2022 03:27:43 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 5 Oct 2022 03:27:43 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 5 Oct 2022 03:27:42 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 5 Oct 2022 03:27:42 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 5 Oct 2022 03:27:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vk8+5AEzJanCzTwc91U4RPKMDfNdi8ipJM3nS78kxmrMRuO1/XS7JT495KqGcjFdb7nkQfplLPimbvHRmeDOKitclTt4NBsJMfVHvSueeFBlIJcujNVd86HdshcYcCQ5g+RDFT0+hSnw/mIAj+tUTqfUxRHWiJkp7cshUHlhqOZ4CDx80bq34xqC4xXSlaF+XKJoCG5yRKgZBhYTYfrnUx5fHgwRbWsvEz5I1xKrWjGNoWtDwMs3h7ZyfsTwDLTkxPt+dBkIzeWCmBUdZFuAqi4GEa66hKwkXDuiJayYVGgHytwur4UQWYB25RmEJclu0lcyuWmF15XxcAZhZmWL9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iL6wlWh0ZvJs0btMI0NgnmMLKRQuU7w4z4ei0z38BUA=;
 b=MnBcUIlkfGO//z6KXSj5CxAmwb5Z7frg9HHOzcK3Fg5rsyzXMKzS48/S/ZD/b4/2EQEeu4Nccmjfgwljw7vH3ex0doZbkdnvBy3uYFJmw9a13iVFYRRM6irwr8oexCyQ+8u+cDFMVrnZzSxLzKvgbZmhbFlqKewkJ6ozZ7XPNVK7KxHMiHNlLSK59MocbBkvr7zTPtDuv/0vNU7H6tLtEL060OvK4Tv0Lyn+2HW+UNWvxHAqZb6bO0T4nxmZHHTpNQToFn8isMvnqyBVMsuIj/o2diHJByd7VFEZ9YtuqYEob/vsJV75iSVYpS9okW+V0m6hG6ND/ySl/aSzePuZVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 IA1PR11MB6097.namprd11.prod.outlook.com (2603:10b6:208:3d7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.28; Wed, 5 Oct
 2022 10:27:41 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::6ae9:91fd:f3e0:7923]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::6ae9:91fd:f3e0:7923%4]) with mapi id 15.20.5676.028; Wed, 5 Oct 2022
 10:27:41 +0000
Date:   Wed, 5 Oct 2022 12:27:30 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Joe Damato <jdamato@fastly.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <kuba@kernel.org>, <davem@davemloft.net>,
        <anthony.l.nguyen@intel.com>, <jesse.brandeburg@intel.com>
Subject: Re: [next-queue 3/3] i40e: Add i40e_napi_poll tracepoint
Message-ID: <Yz1cEtPLzbPkBCtV@boxer>
References: <1664958703-4224-1-git-send-email-jdamato@fastly.com>
 <1664958703-4224-4-git-send-email-jdamato@fastly.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1664958703-4224-4-git-send-email-jdamato@fastly.com>
X-ClientProxiedBy: FR0P281CA0137.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::13) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|IA1PR11MB6097:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ed8a085-8886-4aec-7b35-08daa6bc3b74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mh+DacG9LKmQDXPh/4+z1xowCVnyhcFE0HH3tvpZVtg+0xUSB1Cry+d6zNm3n2fRZwovqsvggeN5ijO8t+CGza4BHFeDin6maEupxMtbE6ab1GekRGc8Cb1Ahw9rvAYS15qFn1d7AAKQmWUC4RnqGgBgizrglYjOjoKuH07zj9xdgLBh/jCMulCxuCCc34X2fGDfPjF0n8RUDg92jZAK+tzJfbnNRUTgafIvrDt6tjcnEAmxK0uUgbvWpHgB3/CwLejVahNSa4k/Y3XYX3OgGtw4z8ein0EKPLNoJqwlo1fNOz3xJWuM1FE/7HQHeZNL9qI8xADzCOmnpla9QfWCFuoKWT6l8tr7uN1c12YmhetWSVSz7E72FrAVI9Cjk/xNq91DiXH04fhEmpyJGqI+06KpLN97G+eAMK9XUzKeyUgIhadqifVCUyQ6vBxz/UA41gpIwE/dS+u0THpxLk7mn2MiNn4szTmk7pvalRTYOWQu4qTGTX+2ZE566RLOtXFTRn8ZNtnhd1OIkBuuMRjnhuPpL9RFazCrKvbdXQmblmTmZZXmTgFD9vVVyNUzeixFP/Pronx/56Xsw078egshGQ4VkFPYdiK9Doc9gH2SxNn0KBVZ9+QJM038Te30w6At4ogZHLq5JC/KGRM/IWXHE5Nxyz1lrtG1ySZpykyBeS3yhH9RcYjX3lO2OZg80IzemWYN/RUuh+Lzo5QR8lVAbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(376002)(396003)(366004)(136003)(346002)(451199015)(66946007)(66476007)(41300700001)(83380400001)(66556008)(8676002)(316002)(478600001)(6916009)(4326008)(8936002)(107886003)(6666004)(86362001)(6506007)(26005)(9686003)(6512007)(5660300002)(186003)(33716001)(82960400001)(2906002)(38100700002)(6486002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vCyefIB8v6g/Q3bEm+31itMHGHpQz3aDLz8vqnu9mxKiRJqlGU3jKyww0opQ?=
 =?us-ascii?Q?poQk4yIwDZqroKAvUJ6m52C9jYUYm/wJdlavqH1r+xtHNVuaa2kSQX478wIN?=
 =?us-ascii?Q?rmzpk5mQ6o2ReTWxikOkxqVNaCk0FKVgRsp3nNOFy7mIu1xUvEDJyH0HtB5q?=
 =?us-ascii?Q?m8r7Mvca2iAPT2Q1b9mnvaRllZggqhk03B4at7u3NO0LOlffbePvLgDOL5A6?=
 =?us-ascii?Q?YpzuRbgwjz8o8IWnC1zdusga3yQZrUgZ6ydramVkmqJoWJfLaVt/3sgu7F+k?=
 =?us-ascii?Q?ndrW7WSEglEdPnD7vUzjg1RtA4Kpu/V3rhGisLo8DQ9TOEVbU+ur3GH4PPER?=
 =?us-ascii?Q?R885M9NtmsvVDoFMHLboAul8XSjGNGT7YMPcX27kAKDar6SVPgEryRCANm55?=
 =?us-ascii?Q?KjawisXS8bITBVjWKtJdTNpEAiDNNyNMzmU6X8FW45wDHgO46VriWynWT891?=
 =?us-ascii?Q?XSqAadmUsj5JN+PEy1hIZxZ7qF3Kqc+8L/PbIwNxM/02DehhPLHlYbsZOMx/?=
 =?us-ascii?Q?b+g1SvMJTZbOlOxZnNdV0orfNJwe0uZTCMcJVwG0+1DbHQGEfFmXJDH2MJLP?=
 =?us-ascii?Q?7BR7+YhxWYAClZTU6+f6KfaeJwe5Tx8wyWstG5MTO4Wj0MS6NOfmDYnm11ba?=
 =?us-ascii?Q?6eefIFdtppBsQT9xqrvFVgykaIJyyFzLhKQWkZzhKOybKLMlus215rj9QJJw?=
 =?us-ascii?Q?Ls5XjAy42ymrrkcayx6DYUBD5UypLYAiY4u9KfFuY1gc+11KqsOqwt8UqURP?=
 =?us-ascii?Q?mqUtKvhPyfUah3FnTi2A+gPgrfsblZ0vTm77XWduIK62x348FPVGSkYZD9Ri?=
 =?us-ascii?Q?gMmHdd5kZg+DVGkBYJGT2UPoWYwYkbLG8b87evTue75mCtl9LS3C7bJ9Kr+h?=
 =?us-ascii?Q?MwWYQMnwbz5+PAoQduODSXGjw5cWZHOgxGj0yy5zy/pyal3/HqfV0/pHmujo?=
 =?us-ascii?Q?4n3vM2+NSYcfW4EwZTIOHYT3V84bST1R22mNTMAANnr4qiRyd1fzsXalBGa6?=
 =?us-ascii?Q?NUn59uFOS0GVNjtKPbrQd7YdK0QgtYf/spLmIQySkvORmNZLN55nM4W40lxu?=
 =?us-ascii?Q?xvTWBVfVAflINEQ5h/D2DDnGU/CwXzTGZm085cn7ScgABqit6lOTVivNCW6V?=
 =?us-ascii?Q?TFbp6utCsiTw3q2/wKbxI5BQ7ek+RiX1iYadNbNQRVGWzqWY/hLZgIcrtxq3?=
 =?us-ascii?Q?ve+w+etnH+Td28LINlgOdH6R924R5DXTx2IyJ7FBUvXz1IImAcM3rRXoKYH3?=
 =?us-ascii?Q?AG3/mqlKgQrGMzUuHbV7DiW+RXMhKvPZXhcH6geUqn43uqWKmOwIlYAqkcXc?=
 =?us-ascii?Q?iPs6kDYcbagPFVwdAG3kK9+yGFwwdnd++/saWTHH1v9VgY1ZRZLfU4Q7xlkc?=
 =?us-ascii?Q?qG+jxopjgHRZWNDZL5EJD5LRLfkDwydBfxzoYWV5MDT12qO9xg3p9/5jvO+Q?=
 =?us-ascii?Q?ZbV9eWt3nAgqGQvDKQLjDkJlUVUW1TxO8cT/d8mZ76mfJzA0jga4d+ubxDlz?=
 =?us-ascii?Q?ZWmMMRhgoBKhkK+gCXJMFHO8wabvuIsS1L+kx+TmDW/PZxI2NXznAxAS/tlA?=
 =?us-ascii?Q?+nHDiyuDywOSLA4wGhDy5VnPtAoqJRghmuQVetQsLXzuXThKho3G14g+aYK1?=
 =?us-ascii?Q?Ig=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ed8a085-8886-4aec-7b35-08daa6bc3b74
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 10:27:40.9304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RR1K9+d3y52bCTAIj+DSGXgPw03byH6TEV5ZETMmlRURXaAdV3sQtVEeEcBqokjXPKwpKMjXp6qKeI8MsaSUf0Oqe/n7i9C4zNng6c1sM2E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6097
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 05, 2022 at 01:31:43AM -0700, Joe Damato wrote:

Hi Joe,

> Add a tracepoint for i40e_napi_poll that allows users to get detailed
> information about the amount of work done. This information can help users
> better tune the correct NAPI parameters (like weight and budget), as well
> as debug NIC settings like rx-usecs and tx-usecs, etc.
> 
> An example of the output from this tracepoint:
> 
> [...snip...]
> 
> 1029.268 :0/0 i40e:i40e_napi_poll(i40e_napi_poll on dev eth1 q
> i40e-eth1-TxRx-30 irq 172 irq_mask
> 00000000,00000000,00000000,00000010,00000000,00000000 curr_cpu 68 budget
> 64 bpr 64 work_done 0 tx_work_done 2 clean_complete 1 tx_clean_complete
> 1)
> 	i40e_napi_poll ([i40e])
> 	i40e_napi_poll ([i40e])
> 	__napi_poll ([kernel.kallsyms])
> 	net_rx_action ([kernel.kallsyms])
> 	__do_softirq ([kernel.kallsyms])
> 	common_interrupt ([kernel.kallsyms])
> 	asm_common_interrupt ([kernel.kallsyms])
> 	intel_idle_irq ([kernel.kallsyms])
> 	cpuidle_enter_state ([kernel.kallsyms])
> 	cpuidle_enter ([kernel.kallsyms])
> 	do_idle ([kernel.kallsyms])
> 	cpu_startup_entry ([kernel.kallsyms])
> 	[0x243fd8] ([kernel.kallsyms])
> 	secondary_startup_64_no_verify ([kernel.kallsyms])

maybe you could also include how to configure this tracepoint for future
readers?

> 
> Signed-off-by: Joe Damato <jdamato@fastly.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_trace.h | 50 ++++++++++++++++++++++++++++
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c  |  3 ++
>  2 files changed, 53 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_trace.h b/drivers/net/ethernet/intel/i40e/i40e_trace.h
> index b5b1229..779d046 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_trace.h
> +++ b/drivers/net/ethernet/intel/i40e/i40e_trace.h
> @@ -55,6 +55,56 @@
>   * being built from shared code.
>   */
>  
> +#define NO_DEV "(i40e no_device)"
> +
> +TRACE_EVENT(i40e_napi_poll,
> +
> +	TP_PROTO(struct napi_struct *napi, struct i40e_q_vector *q, int budget,
> +		 int budget_per_ring, int work_done, int tx_work_done, bool clean_complete,
> +		 bool tx_clean_complete),
> +
> +	TP_ARGS(napi, q, budget, budget_per_ring, work_done, tx_work_done,
> +		clean_complete, tx_clean_complete),
> +
> +	TP_STRUCT__entry(
> +		__field(int, budget)
> +		__field(int, budget_per_ring)
> +		__field(int, work_done)
> +		__field(int, tx_work_done)
> +		__field(int, clean_complete)
> +		__field(int, tx_clean_complete)
> +		__field(int, irq_num)
> +		__field(int, curr_cpu)
> +		__string(qname, q->name)
> +		__string(dev_name, napi->dev ? napi->dev->name : NO_DEV)
> +		__bitmask(irq_affinity,	nr_cpumask_bits)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->budget = budget;
> +		__entry->budget_per_ring = budget_per_ring;
> +		__entry->work_done = work_done;

What if rx clean routines failed to do allocation of new rx bufs? then
this would be misinterpreted. maybe we should change the API to

static bool
i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
		  unsigned int *processed_pkts);

so you would return failure and at the end do
	*processed_pkts = total_rx_packets;

then also i would change the naming of tracepoint entry. I'm not a native
english speaker but having 'done' within the variable name suggests to me
that it is rather a boolean. what about something like 'rx_cleaned_pkts'
instead?

Generally I think this is useful, personally I was in need of tracing the
next_to_clean and next_to_use ring indexes a lot, but that is probably out
of the scope in here.

> +		__entry->tx_work_done = tx_work_done;
> +		__entry->clean_complete = clean_complete;
> +		__entry->tx_clean_complete = tx_clean_complete;
> +		__entry->irq_num = q->irq_num;
> +		__entry->curr_cpu = get_cpu();
> +		__assign_str(qname, q->name);
> +		__assign_str(dev_name, napi->dev ? napi->dev->name : NO_DEV);
> +		__assign_bitmask(irq_affinity, cpumask_bits(&q->affinity_mask),
> +				 nr_cpumask_bits);
> +	),
> +
> +	TP_printk("i40e_napi_poll on dev %s q %s irq %d irq_mask %s curr_cpu %d "
> +		  "budget %d bpr %d work_done %d tx_work_done %d "
> +		  "clean_complete %d tx_clean_complete %d",
> +		__get_str(dev_name), __get_str(qname), __entry->irq_num,
> +		__get_bitmask(irq_affinity), __entry->curr_cpu, __entry->budget,
> +		__entry->budget_per_ring, __entry->work_done,
> +		__entry->tx_work_done,
> +		__entry->clean_complete, __entry->tx_clean_complete)
> +);
> +
>  /* Events related to a vsi & ring */
>  DECLARE_EVENT_CLASS(
>  	i40e_tx_template,
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> index ed88309..8b72f1b 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> @@ -2743,6 +2743,9 @@ int i40e_napi_poll(struct napi_struct *napi, int budget)
>  			clean_complete = false;
>  	}
>  
> +	trace_i40e_napi_poll(napi, q_vector, budget, budget_per_ring, work_done, tx_wd,
> +			     clean_complete, tx_clean_complete);
> +
>  	/* If work not completed, return budget and polling will return */
>  	if (!clean_complete || !tx_clean_complete) {
>  		int cpu_id = smp_processor_id();
> -- 
> 2.7.4
> 
