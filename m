Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422376470ED
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 14:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiLHNlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 08:41:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLHNlC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 08:41:02 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA77D56D42;
        Thu,  8 Dec 2022 05:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670506861; x=1702042861;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=00/T+tKF0Bz+pKfInJrKJhMbUMK5TB/tSecyD4GPnlg=;
  b=lBfJ8I4h5SCSsaN8GALnWkeZV1g7aNdb8ubQvIu2/ULK17eg4/UDia8h
   MSK8pda7DqLWAazJaPKTJTFek6Y2HX50cZMGjCflZuRgA83pEbWfwB7PH
   7Ds8icn+zN3LG/x43cTB7ut87ykDROujPHf4vaX+8m2OYL/7Jwc53XfO0
   NlzNrz55L2NJhn9cPZUvPMb2c9SDQo9272gIsGjDsGvCqfEZfLnIYXRKA
   Udr8XiN/g0BOGrRhegEDdMu7mAiPUWCYKF38UmJ1Y9YZeRZtALJuLX7vL
   bAUv3MiR6WVpIuXozcUIq/xXirCL9K8fxx1y12Qk1sRwRcm6lMll5csog
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="318313109"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="318313109"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 05:41:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="735794624"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="735794624"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Dec 2022 05:40:57 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 05:40:57 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 05:40:57 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 05:40:57 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 05:40:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CnVJL3ezIanh/jCwgV5X6tpmaBpLaaqNKt9lwFaF1NaHoaWKRTbgXv7e5G+XXuu4Xm/6mGjymsmmB0xZGhcXqTa7QMLvFigHh9JE4lNFweZodTY9hiL2BFwU/Tb5VfZQ7mdqJ0bl6US5MTCL7uXxvh9aGgvQovZ4ykCXAW+XJGq5RZ5vNCLLlP8xVNvSoZb2r3+nKziGaUclMLKObFlEJDGIlehwF+p2xwTaPJU8pNjF68zzT1gU2oOEPBYrj625b8uqTSnacUNiITxgpWWcGWqLqO2m1gzwr9IhWBVdx0SD2B5d3pmk12W7cqf2USvPWzyIGE+OF2utg5Pyg8+GgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gcoe/hzdChjfC0SAL80EXZ9lw4rNBfZ6jVmspcz1L48=;
 b=DGRGntiPwUpLSLP3Lcxr1aSOGtwWaa5LG+bORhLpNq3oYPKYxgBmjnzKjRME0Ne0uXMur6CKo8tFAWxn1QvMM9dU6yHay2WTdl0NSOEnBadzIpoquCvWiBxtDYwh9SQ17tu+QfYzrlkNVmez0kR4ue36Ewlgm4IQ1GEjLuMgzraAa3/M6+JSCPNlxPsajf2aHkmy14qsMHl/AWLr+7cMsoezFA+yIteNqPOHd45T3+FPJnDliyaiid31pNXWqujaqMP2NaYhx2rqbSJIikq0r89IG99rkdvg74e1BbjqTt6eVo/dlKcnwCOCSj91JaMCUMMOOUMAk+TkyQKNJfl8Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 PH0PR11MB5784.namprd11.prod.outlook.com (2603:10b6:510:129::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Thu, 8 Dec
 2022 13:40:54 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%5]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 13:40:54 +0000
Date:   Thu, 8 Dec 2022 14:40:41 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>
Subject: Re: [PATCH net-next v2 6/6] tsnep: Add XDP RX support
Message-ID: <Y5HpWf8XMcCj2k7V@boxer>
References: <20221208054045.3600-1-gerhard@engleder-embedded.com>
 <20221208054045.3600-7-gerhard@engleder-embedded.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221208054045.3600-7-gerhard@engleder-embedded.com>
X-ClientProxiedBy: FR2P281CA0147.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::12) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|PH0PR11MB5784:EE_
X-MS-Office365-Filtering-Correlation-Id: 3acfd7b4-97f7-4933-bc50-08dad921d378
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vRIADsupL8meiXUDTW0ZMctxpclrOEbYUl5pc8SHd+9Jotynr1ZEd42bE43bSfiKsr1oUQrajMomkJlBn0me4qtmt1/5gnEnX7vyv3B/DG8PJ3G5E8BV2REvYOd6s/UBjLO1R0VS+wbRLqAtbq+dcctyP7k4n0pkFxJPxwgK+I4x32LWCAayI2fpZ7kkoJLsr90gfF2FDe5PSUYFAX9q/YVQ4RiEW9OXfdM1QNU0AoDuUTmTJv+digGQPc1m95cQsN1awWP1iqT8JN5N5jS78x55pQd4co4jYi4DXePlbG3zFR8Tqfwx1az+ZBR34uRQFYUS2A7xKNYaIkK4E4J0WQMbyRZI0HATUh4h7psrr7R5fFgPPdyjB8DKzbdpMBpM9HGBMXF9gxu2CnzGXbBUU34xOiUiEW/0/vv9fuK/yomdeoKhfv8eE7eliCqvUBao0pgxc5aCgC+aExTICmEjK+CSlvARHU4y4SSYGcyUTawheT37admkzESNcbrzexs1jP7COR1JFAaWcRK8z6Ha/dVNprAscpd0VcpVGL8YDmT7kjJiAQDEyufjx36BwxhL0BohSyRftghmVZcqTtqgKihMLtnC+zv6XiyW/EVZY7BfvaIkdYdEheMXKENtoADAvhMnzpVLTxEl0UqxIoYfcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(136003)(366004)(376002)(346002)(396003)(451199015)(7416002)(8676002)(44832011)(5660300002)(2906002)(33716001)(86362001)(6512007)(26005)(186003)(9686003)(6916009)(82960400001)(83380400001)(4326008)(6486002)(6506007)(316002)(66476007)(478600001)(66556008)(38100700002)(41300700001)(66946007)(6666004)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x3MEoGujvlS6eYW4minKg8+ft/cZhiheQ0id29+74nySV/fkxD9quPg6w0hA?=
 =?us-ascii?Q?RrZOlVHfxiIoIZzu2CoPU8rFauuo0PLHtRM0XyV1nWVjaJxc/D8aLvbogbbt?=
 =?us-ascii?Q?m7z4hpJyXLH0lQ0M5z0I7Q60nER9sYaE6p9msbZaQLZfsxhD1BEVSXAvnVoT?=
 =?us-ascii?Q?Oms5Hf4L2yBB3dRE6gPeLa3R6H3zMcF7Kku51y6fVlN1N/OGEa8TwR0bsWED?=
 =?us-ascii?Q?VLdjVlZ0aS2n0qy9noIjvDLMGFGXvB+Oj2CJqKwLhap84t4J+XCYqNr6ZUzx?=
 =?us-ascii?Q?lGHw9eu7bdqSIoWqrw3c9fFqjKYthKYV222u8FRGraC9zdTxhGF1smKL623u?=
 =?us-ascii?Q?mxBghYr6z9OqlrgXq0hLQQEciN/HPkMSzZLtbitWVlpCC1cE5+62Uw9gn8Nd?=
 =?us-ascii?Q?G2VIKv63x0UfA1wuue2pLUM+MfcXYZpVD1zuhyxwDR+8SNTIh+8sdBiokDf4?=
 =?us-ascii?Q?aDmywomQ2LNHEPWX/iwK48KHPKvl9JEFqRBSIbxc7xlOKN0Zl4ETTkjnIgqW?=
 =?us-ascii?Q?eQzPOv4cLWhvmi/8pqcB/VfN983bQInhYfu0eTMfrKmUK6WT4xax2wcF1BEG?=
 =?us-ascii?Q?gp57pCDp9xFhLyteO5BJgnh6m9VAYAjA02cN21EyQeuGHMRAbcBe1NKyfmtf?=
 =?us-ascii?Q?cSRpyeDcfO7KGG0DsDM28afRRZdLEYnxz4lhWc1qR7PJXUUN2LztnP8g7U1m?=
 =?us-ascii?Q?y2BcsUGrNQ5fQh3KfqsNLXCHX8mKMvs1WXxNLvNxcY4P4LEutnVVQiqQPWva?=
 =?us-ascii?Q?UOMIpXxupq3BD2DdeWh+FIfh8h+1xRjQXRblejGuD/3VU1KBdRPiKTNPI0GU?=
 =?us-ascii?Q?AmuI0+yYRqzfvQbrAfegxM5tB7WZJMT5x+mE25EYGJqarsW8jg98+cg6Ry+A?=
 =?us-ascii?Q?2rxUGxDZqYueAYsJZPB2KiMB9DVszIMblqN2HVpfCld2bO9UGOlXs3zovH5c?=
 =?us-ascii?Q?YOpAumX01WIsSSEkzqTobNhjebbPGcuPwLowQWOGm8+gQHWHwcNetpMzgYSO?=
 =?us-ascii?Q?B0CnSPAeJyfDko12Rnwukhrah6snbNHeYPFZElQvnVCHmx+WacgUUrUlDMgS?=
 =?us-ascii?Q?Lk4p63LfweSp0FuIu76+HlGGdm0o7HN5lmhXl9i10xEae732keVsCqa13vpP?=
 =?us-ascii?Q?WB39K0iwyoftXLJIBKH7mOE+zthCt4Tv6XTOzaFL14tKu12K357xK/C0HJea?=
 =?us-ascii?Q?v13FrQVWT3hslL7lruqkURzPVaPxGz9luu/Zs6cXcNhm9DXWPuV0J3sD7yXl?=
 =?us-ascii?Q?lnyzwgE2BjV5b5/gg/p2xrszpyU05hQr5gCMII0EHo4kZ60prWZbezQnNO3K?=
 =?us-ascii?Q?SAJRgR/30jnYqkBCNY5cMpgLe3xy4I/dMzEA/vYAeTIq4BoFjbk28qbKGFMM?=
 =?us-ascii?Q?S/s84bgjXWofuN0BEHH1zILgDPsk0nLKGt8Bs9wYP2zyUaa+jKgfNmwtQno2?=
 =?us-ascii?Q?KAhzHCJ46O3jMfsEd9tZjCTeukJTRabvls0ep8gD/lOLaO32RA7vRcr3x98f?=
 =?us-ascii?Q?YN/lh2EVRKMnv7MS83MNERKwGk0bn/LIiGSDzuJyCLzOZs5FWjFdobyI+L/h?=
 =?us-ascii?Q?kiNOHsuQifD3Ng//RPM+G2Ztk6XG58SCC5gZMcPP7Y118XFB/enbGYGGkBe1?=
 =?us-ascii?Q?ZQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3acfd7b4-97f7-4933-bc50-08dad921d378
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 13:40:54.5608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YkzDHDBE3sc1sPb8wLHoE+1IQPQrj9NOUWyzvK7TYrBYlynOid9HG2dtF1P7dbKBYXg+n/X7pQbc4T7f+Kf3+6Rr032TlINXFx3Mzekwz24=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5784
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 06:40:45AM +0100, Gerhard Engleder wrote:
> If BPF program is set up, then run BPF program for every received frame
> and execute the selected action.
> 
> Test results with A53 1.2GHz:
> 
> XDP_DROP (samples/bpf/xdp1)
> proto 17:     883878 pkt/s
> 
> XDP_TX (samples/bpf/xdp2)
> proto 17:     255693 pkt/s
> 
> XDP_REDIRECT (samples/bpf/xdpsock)
>  sock0@eth2:0 rxdrop xdp-drv
>                    pps            pkts           1.00
> rx                 855,582        5,404,523
> tx                 0              0
> 
> XDP_REDIRECT (samples/bpf/xdp_redirect)
> eth2->eth1         613,267 rx/s   0 err,drop/s   613,272 xmit/s
> 
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  drivers/net/ethernet/engleder/tsnep_main.c | 126 +++++++++++++++++++++
>  1 file changed, 126 insertions(+)
> 
> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
> index 2b662a98b62a..d59cb714c8cd 100644
> --- a/drivers/net/ethernet/engleder/tsnep_main.c
> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
> @@ -27,6 +27,7 @@
>  #include <linux/phy.h>
>  #include <linux/iopoll.h>
>  #include <linux/bpf.h>
> +#include <linux/bpf_trace.h>
>  
>  #define TSNEP_SKB_PAD (NET_SKB_PAD + NET_IP_ALIGN)
>  #define TSNEP_HEADROOM ALIGN(max(TSNEP_SKB_PAD, XDP_PACKET_HEADROOM), 4)
> @@ -44,6 +45,9 @@
>  #define TSNEP_COALESCE_USECS_MAX     ((ECM_INT_DELAY_MASK >> ECM_INT_DELAY_SHIFT) * \
>  				      ECM_INT_DELAY_BASE_US + ECM_INT_DELAY_BASE_US - 1)
>  
> +#define TSNEP_XDP_TX		BIT(0)
> +#define TSNEP_XDP_REDIRECT	BIT(1)
> +
>  enum {
>  	__TSNEP_DOWN,
>  };
> @@ -626,6 +630,33 @@ static void tsnep_xdp_xmit_flush(struct tsnep_tx *tx)
>  	iowrite32(TSNEP_CONTROL_TX_ENABLE, tx->addr + TSNEP_CONTROL);
>  }
>  
> +static int tsnep_xdp_xmit_back(struct tsnep_adapter *adapter,
> +			       struct xdp_buff *xdp)
> +{
> +	struct xdp_frame *xdpf = xdp_convert_buff_to_frame(xdp);
> +	int cpu = smp_processor_id();
> +	int queue;
> +	struct netdev_queue *nq;
> +	int retval;
> +
> +	if (unlikely(!xdpf))
> +		return -EFAULT;
> +
> +	queue = cpu % adapter->num_tx_queues;
> +	nq = netdev_get_tx_queue(adapter->netdev, queue);
> +
> +	__netif_tx_lock(nq, cpu);
> +
> +	/* Avoid transmit queue timeout since we share it with the slow path */
> +	txq_trans_cond_update(nq);
> +
> +	retval = tsnep_xdp_xmit_frame_ring(xdpf, &adapter->tx[queue], false);
> +
> +	__netif_tx_unlock(nq);
> +
> +	return retval;
> +}
> +
>  static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>  {
>  	unsigned long flags;
> @@ -792,6 +823,11 @@ static unsigned int tsnep_rx_offset(struct tsnep_rx *rx)
>  	return TSNEP_SKB_PAD;
>  }
>  
> +static unsigned int tsnep_rx_offset_xdp(void)
> +{
> +	return XDP_PACKET_HEADROOM;
> +}

I don't see much of a value in this func :P

> +
>  static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
>  {
>  	struct device *dmadev = rx->adapter->dmadev;
> @@ -997,6 +1033,67 @@ static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
>  	return i;
>  }
>  
> +static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
> +			       struct xdp_buff *xdp, int *status)
> +{
> +	unsigned int length;
> +	unsigned int sync;
> +	u32 act;
> +
> +	length = xdp->data_end - xdp->data_hard_start - tsnep_rx_offset_xdp();

could this be xdp->data_end - xdp->data - TSNEP_RX_INLINE_METADATA_SIZE ?

Can you tell a bit more about that metadata macro that you have to handle
by yourself all the time? would be good to tell about the impact on
data_meta since you're not configuring it on xdp_prepare_buff().

> +
> +	act = bpf_prog_run_xdp(prog, xdp);
> +
> +	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
> +	sync = xdp->data_end - xdp->data_hard_start - tsnep_rx_offset_xdp();
> +	sync = max(sync, length);
> +
> +	switch (act) {
> +	case XDP_PASS:
> +		return false;
> +	case XDP_TX:
> +		if (tsnep_xdp_xmit_back(rx->adapter, xdp) < 0)
> +			goto out_failure;
> +		*status |= TSNEP_XDP_TX;
> +		return true;
> +	case XDP_REDIRECT:
> +		if (xdp_do_redirect(rx->adapter->netdev, xdp, prog) < 0)
> +			goto out_failure;
> +		*status |= TSNEP_XDP_REDIRECT;
> +		return true;
> +	default:
> +		bpf_warn_invalid_xdp_action(rx->adapter->netdev, prog, act);
> +		fallthrough;
> +	case XDP_ABORTED:
> +out_failure:
> +		trace_xdp_exception(rx->adapter->netdev, prog, act);
> +		fallthrough;
> +	case XDP_DROP:
> +		page_pool_put_page(rx->page_pool, virt_to_head_page(xdp->data),
> +				   sync, true);
> +		return true;
> +	}
> +}
> +
> +static void tsnep_finalize_xdp(struct tsnep_adapter *adapter, int status)
> +{
> +	int cpu = smp_processor_id();
> +	int queue;
> +	struct netdev_queue *nq;

do you care about RCT, or?

> +
> +	if (status & TSNEP_XDP_TX) {
> +		queue = cpu % adapter->num_tx_queues;
> +		nq = netdev_get_tx_queue(adapter->netdev, queue);
> +
> +		__netif_tx_lock(nq, cpu);
> +		tsnep_xdp_xmit_flush(&adapter->tx[queue]);
> +		__netif_tx_unlock(nq);
> +	}
> +
> +	if (status & TSNEP_XDP_REDIRECT)
> +		xdp_do_flush();
> +}
> +
>  static struct sk_buff *tsnep_build_skb(struct tsnep_rx *rx, struct page *page,
>  				       int length)

did you consider making tsnep_build_skb() to work on xdp_buff directly?
probably will help you once you'll implement XDP mbuf support here.

>  {
> @@ -1035,12 +1132,16 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
>  	int desc_available;
>  	int done = 0;
>  	enum dma_data_direction dma_dir;
> +	struct bpf_prog *prog;
>  	struct tsnep_rx_entry *entry;
> +	struct xdp_buff xdp;
> +	int xdp_status = 0;
>  	struct sk_buff *skb;
>  	int length;
>  
>  	desc_available = tsnep_rx_desc_available(rx);
>  	dma_dir = page_pool_get_dma_dir(rx->page_pool);
> +	prog = READ_ONCE(rx->adapter->xdp_prog);
>  
>  	while (likely(done < budget) && (rx->read != rx->write)) {
>  		entry = &rx->entry[rx->read];
> @@ -1084,6 +1185,28 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
>  		rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
>  		desc_available++;
>  
> +		if (prog) {
> +			bool consume;
> +
> +			xdp_init_buff(&xdp, PAGE_SIZE, &rx->xdp_rxq);
> +			xdp_prepare_buff(&xdp, page_address(entry->page),
> +					 tsnep_rx_offset_xdp() + TSNEP_RX_INLINE_METADATA_SIZE,
> +					 length - TSNEP_RX_INLINE_METADATA_SIZE,

Would it make sense to subtract TSNEP_RX_INLINE_METADATA_SIZE from length
right after dma_sync_single_range_for_cpu?

> +					 false);
> +
> +			consume = tsnep_xdp_run_prog(rx, prog, &xdp,
> +						     &xdp_status);
> +			if (consume) {
> +				rx->packets++;
> +				rx->bytes +=
> +					length - TSNEP_RX_INLINE_METADATA_SIZE;
> +
> +				entry->page = NULL;
> +
> +				continue;
> +			}
> +		}
> +
>  		skb = tsnep_build_skb(rx, entry->page, length);
>  		if (skb) {
>  			page_pool_release_page(rx->page_pool, entry->page);
> @@ -1102,6 +1225,9 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
>  		entry->page = NULL;
>  	}
>  
> +	if (xdp_status)
> +		tsnep_finalize_xdp(rx->adapter, xdp_status);
> +
>  	if (desc_available)
>  		tsnep_rx_refill(rx, desc_available, false);
>  
> -- 
> 2.30.2
> 
