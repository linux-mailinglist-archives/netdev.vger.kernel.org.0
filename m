Return-Path: <netdev+bounces-1815-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C05BE6FF340
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:42:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 788951C20B90
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:42:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D7FA19E5E;
	Thu, 11 May 2023 13:42:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D241F920;
	Thu, 11 May 2023 13:42:53 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E025D046;
	Thu, 11 May 2023 06:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683812564; x=1715348564;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=U66VpB9574ygj6oBh9uvResxWIO70EmKfdvk3s+6fdE=;
  b=UhIrmg3UbZB2z9eyJr/pEpwqkLcmxJu4BomYDp+/8F36ui1eLs32L1MA
   5ECToFJ6gebQGsPbB26uC0IZlDnrPGUYrrfqmC8boqU9N/YrNbe/GOzHi
   ao21lr+qnQ7vgIT7HSeFDsW5JJk30vNKTbqx2NnSQJ/6AzU2STdKjC5H9
   51D+hgXfXOcwJNQEB28o4kEg8vWHGHCV/Om/YOl2Yznv5599g4eOVTXCk
   Id9/Z/+skxKMD9DWmvD4UbR2vg495gZjd281QnNFhQGAm6m9iXw+G4Bq3
   Vl0j+Dt74vSTTJEnXhVHwerz/KozBFBqg0a33bFd3B7S890oavNBplhOU
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="413850425"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="413850425"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 06:41:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="823968382"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="823968382"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 11 May 2023 06:41:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 06:41:43 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 06:41:43 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 06:41:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d1spOQMT4Qg4ObPEx/23Wg+PuJJCUA+bGJBwXhz/ZyRN5oPXDHbntWlbqTrpHjCixGAkmW1maJ1rGlYhOA4ZKu/IT2SFse3SsQ2/FL5EGzQs+fxn/x1Yyga2urKMHby6mfkbv6KosyGqVr4OVUq/h4kTiFND/ThFEI4BE/tiqgf5gWfnpZBwFvGx+1ut873qib6PT0EZnfc1Bd6wvO6aPy1l0kwX+Wtp2rDYWp0j7PTMDS4F76fs+K5EaByEdlxi1gnAzvSuf4Ikfklm+swSRbE+sLaevGjr1/GYasdH4rM3RK7AvT7GfmjuPpHfiVdBTMyJgN2cnZYOrylqF0Ozrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iCbOZGcfR+mk0y3OqyWYR7D2z3QD51mJODyvFcFuDNc=;
 b=cBj8KOnfR1SnIaSiFka/LTy+C7jupKslpICplAuWT0Yg9ZmsLqqMcja3f+UaTrtj8JyJS/d7bNGzlN5lVZZxfdEfPNagkctfo0a08dIiWnrv+/NCYTpaz01OGcnjiem+qwODnbRHZn9NfQRA61ast9Dfz7pdrxI2f4Y5KoAPqZu7LliBqYJs9vw05ARkAdrsX+4BB3IJ3fvLM2NgX4chClKQG0ymaxqZ4p5ToyC5DTbIj6jliC/l9QDP2qS+tjzCf2MmSXwyy6SDrycb4peNPmzbStpeO092HvHU/68kdjSBzsdo8+op6W+BRXuIeGq+IGaZyvgneO5uCAj+1/VaDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB2937.namprd11.prod.outlook.com (2603:10b6:5:62::13) by
 SN7PR11MB6704.namprd11.prod.outlook.com (2603:10b6:806:267::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.33; Thu, 11 May 2023 13:41:23 +0000
Received: from DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::66f6:544e:665a:9bec]) by DM6PR11MB2937.namprd11.prod.outlook.com
 ([fe80::66f6:544e:665a:9bec%6]) with mapi id 15.20.6363.032; Thu, 11 May 2023
 13:41:23 +0000
Date: Thu, 11 May 2023 15:41:10 +0200
From: Michal Kubiak <michal.kubiak@intel.com>
To: Feng Liu <feliu@nvidia.com>
CC: <virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>, Jason Wang
	<jasowang@redhat.com>, "Michael S . Tsirkin" <mst@redhat.com>, Xuan Zhuo
	<xuanzhuo@linux.alibaba.com>, Simon Horman <simon.horman@corigine.com>,
	Bodong Wang <bodong@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net v4] virtio_net: Fix error unwinding of XDP
 initialization
Message-ID: <ZFzwdkJv7eHGeuaM@localhost.localdomain>
References: <20230508222708.68281-1-feliu@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230508222708.68281-1-feliu@nvidia.com>
X-ClientProxiedBy: LO4P265CA0026.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::23) To DM6PR11MB2937.namprd11.prod.outlook.com
 (2603:10b6:5:62::13)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB2937:EE_|SN7PR11MB6704:EE_
X-MS-Office365-Filtering-Correlation-Id: c609de2d-e00c-48f2-66ac-08db522568ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IONWlv7VybD2VSPXv+Qgqq4v0qvLOviv1yqvT3fGVa3LgW7WwpOhzPw0GlFS9SQG5jILJxDKQvD57AF4gkDD/vakJt61BV0c46F7lk9sTGze5Txfh+YqYXSO7klhZob6DY345e2rR0dUoWXv3nEDUTmO0dXlDeSPF2u1OwnNxnf75WT8dyzbktATKkyPBl/4wyqs5apFAY1g4ucMh+hSJLnaUmZOgqB5TvpmAP38SKajeMDsd4P7sujOPpCTkfi4TY4FfP3maukhRxIrwVHd5Nhwfs1TN7osORrkNPFSs75gczkZZorgBKJUyDJIjuYDN9BBjibtS5II/Hwhs78c81KjuQXFcQLpB0UcpKGGTbrLMEj7D4+Aafu9mvjBST0IcUQFEb2LruIAR12V1PGXW5TFEK7NQ+sgp/M9mGg8YWSjvTCePik9ey/btTk479/kytdA2yf/k4GJ1Uc1bLFWOBMsBY0Ll57MfbxiVw59kWFGmqVFHyJfBf/Om+dn3ajn4H4Wy+E1JcHF3goXsd2bACPJrs4yYfwFHS5rqF2aZ4AKHyQskmOqvT/Xq3/c6ouP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2937.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(396003)(136003)(366004)(39860400002)(451199021)(83380400001)(186003)(2906002)(38100700002)(86362001)(82960400001)(6486002)(26005)(8676002)(316002)(8936002)(6666004)(41300700001)(5660300002)(478600001)(54906003)(7416002)(66476007)(66946007)(4326008)(6916009)(66556008)(9686003)(6506007)(6512007)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uHVfp17Qv302IOfbLbkADZ3Nqeg8ymKkZWzyb/ukm7hCqAaqKBl+F5GiYc7p?=
 =?us-ascii?Q?C0v3Fye/5BGNnl0iMmJL131xFQNA/tweb6/HooZ3LafQJsUZK4hxCwcIcreL?=
 =?us-ascii?Q?szYDYMyoJGNFhH2tfsAT27ZVvyte+RtfqW4RrFa3BYkUgiy3gSVhiFmxnY75?=
 =?us-ascii?Q?ise39DeESX9qSbOE6ApwLy9dFQud4ymtfjfVeogs+aHYhqbkstFUO5k8qwwC?=
 =?us-ascii?Q?tWSJf8Y2eipfjDK4ekcR2IwDadiFiZwYmZkVTwEcw7BheYNHU1lnhAd/rpLr?=
 =?us-ascii?Q?ais8jw/CMsSDuDYbywPPvdZo9FRkipg9SScOCjxBfSQ+KmQEEMzSMeqmMBG9?=
 =?us-ascii?Q?ulk45xCAkpyEM/zFOPSh1OkPJZ4LNkN89TGMI47yxBMebLbXgCJ7m1RKLbUu?=
 =?us-ascii?Q?at2xv5J4hNrC9ayJBCEDnGLdaiLcKx2DoH18AQuokIAchc1Ua42PpvJ6QUks?=
 =?us-ascii?Q?tizkzEghbVb73OZ4B0ZSZ/J9yu94Kyc+YITXVNb6oAY6gaGV8sD0oRGkhGwe?=
 =?us-ascii?Q?VIVYQma8cv+TCgBs7aELle/GwlZDVx5qK76vU1DdLxWijHMhsMi05N8OU5qg?=
 =?us-ascii?Q?0WnWytTkTZpyq3D5dJp+ZvhHZ77qzEvv1AL0pWltfgYj9380Sv1RXSgMVQkE?=
 =?us-ascii?Q?6p67HfQVHv220t4vcaqwtsfPmHzGioPEYYqEfhUD7SFwW6x4VgtQEJssRb5O?=
 =?us-ascii?Q?bLdnFJAIn6C+BhlgWEjasGh/HdMNGf6XndQU83VkLMH07XDjHllVVq6KMVsJ?=
 =?us-ascii?Q?/P1n20Apqc7h+/y0g0JZ5j7yYskxfzvUiPJKbnJaHBXzexmGJ7hwGAxNh3+e?=
 =?us-ascii?Q?1u0pe9WMHzDDkm6D21vS+Wmj/tQJgHfBZyvC1GxAgRlivB+fX1Fu7PKUGxkv?=
 =?us-ascii?Q?nKmDOxd5hn4pAFRh6cTNyUtoduavGfOQcBxb/eqjPmJD9WGnE/IkBjQqEMe1?=
 =?us-ascii?Q?B1Jl2hZHKsFB9GHrdRivqMLaxFeHsZGHJYyraVD/0ym3w5PdWzsfrawn4xnd?=
 =?us-ascii?Q?0+hWizlqMegG/DkvKRQ/8q+Bbi3yESjqGJd2Gn8w078J3teWpLiDQaflFpcw?=
 =?us-ascii?Q?P/hFsP0w6iCh7WXeY0ccpWE95c1U/IVWR8TW80bsrbDYi4tgQkRsfSwS/irs?=
 =?us-ascii?Q?k5jTHpaeNFe4wtMRuxkRL6JYPE6BjAbk32OahbnSscfO64UTAqret+8ZImWU?=
 =?us-ascii?Q?x3NErzNtlClfloVKgkFVQS4KACZPsIfa4LOhhlpfOS9bWWP/HpC1gVxBsCUK?=
 =?us-ascii?Q?6u6Uf+AlVCxHSevte1C4bGJoYWixTor9464qTKPgdYCGU2fBQXVZRWotideD?=
 =?us-ascii?Q?TJpo0M3Kw/1TeHp8N4I8iTkPYQcf/XcVk/Z/9/pGcWJdl+qDuJruSNppI1r2?=
 =?us-ascii?Q?Gz3N17i2Lv7j22EXPEhcyq2lZHo9AmwwXs5FIDXpVb+63mc9QuCWoscr4ieP?=
 =?us-ascii?Q?9D43V19apfGCAUc/2TevNi+iKA5BiJlz7LRJRemAIW3RczmaqxhaapMW2gjG?=
 =?us-ascii?Q?BiDPXfoc3Geq59/Fcc51BF7JBaPgaBprCtxGQpcbRNbA/tvMpeJnKwoBJOo9?=
 =?us-ascii?Q?E8HjGhjVsyUEkZ22IROmbWu4DjkocYjNABsspk5JJfzLjwa94ASHuuqiPwDv?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c609de2d-e00c-48f2-66ac-08db522568ea
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2937.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 13:41:23.1992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ow97CNPnXieA7yKLc0wifdX99sneDgVY48YymHtpgw+5hxYBxcxdGD1BP0+JTwDMeaDRJjTa9E0q2GjKOGxCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6704
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 06:27:08PM -0400, Feng Liu wrote:
> When initializing XDP in virtnet_open(), some rq xdp initialization
> may hit an error causing net device open failed. However, previous
> rqs have already initialized XDP and enabled NAPI, which is not the
> expected behavior. Need to roll back the previous rq initialization
> to avoid leaks in error unwinding of init code.
> 
> Also extract helper functions of disable and enable queue pairs.
> Use newly introduced disable helper function in error unwinding and
> virtnet_close. Use enable helper function in virtnet_open.
> 
> Fixes: 754b8a21a96d ("virtio_net: setup xdp_rxq_info")
> Signed-off-by: Feng Liu <feliu@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> ---
> 
> v3 -> v4
> feedbacks from Jiri Pirko
> - Add symmetric helper function virtnet_enable_qp to enable queues.
> - Error handle:  cleanup current queue pair in virtnet_enable_qp,
>   and complete the reset queue pairs cleanup in virtnet_open.
> - Fix coding style.
> feedbacks from Parav Pandit
> - Remove redundant debug message and white space.
> 
> v2 -> v3
> feedbacks from Michael S. Tsirkin
> - Remove redundant comment.
> 
> v1 -> v2
> feedbacks from Michael S. Tsirkin
> - squash two patches together.
> 
> ---
>  drivers/net/virtio_net.c | 58 ++++++++++++++++++++++++++++------------
>  1 file changed, 41 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8d8038538fc4..df7c08048fa7 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1868,6 +1868,38 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
>  	return received;
>  }
>  
> +static void virtnet_disable_qp(struct virtnet_info *vi, int qp_index)
> +{
> +	virtnet_napi_tx_disable(&vi->sq[qp_index].napi);
> +	napi_disable(&vi->rq[qp_index].napi);
> +	xdp_rxq_info_unreg(&vi->rq[qp_index].xdp_rxq);
> +}
> +
> +static int virtnet_enable_qp(struct virtnet_info *vi, int qp_index)
> +{
> +	struct net_device *dev = vi->dev;
> +	int err;
> +
> +	err = xdp_rxq_info_reg(&vi->rq[qp_index].xdp_rxq, dev, qp_index,
> +			       vi->rq[qp_index].napi.napi_id);
> +	if (err < 0)
> +		return err;
> +
> +	err = xdp_rxq_info_reg_mem_model(&vi->rq[qp_index].xdp_rxq,
> +					 MEM_TYPE_PAGE_SHARED, NULL);
> +	if (err < 0)
> +		goto err_xdp_reg_mem_model;
> +
> +	virtnet_napi_enable(vi->rq[qp_index].vq, &vi->rq[qp_index].napi);
> +	virtnet_napi_tx_enable(vi, vi->sq[qp_index].vq, &vi->sq[qp_index].napi);
> +
> +	return 0;
> +
> +err_xdp_reg_mem_model:
> +	xdp_rxq_info_unreg(&vi->rq[qp_index].xdp_rxq);

Is it really necessary to call 'xdp_rxq_info_unreg()' from here?
It seems there is a risk of calling that function twice if 'xdp_rxq_info_reg_mem_model()" fails.

For example in the following scenario:
	1. We call 'virtnet_enable_qp()' from 'virtnet_open()'
	2. 'xdp_rxq_info_reg()' succeeds.
	3. 'xdp_rxq_info_reg_mem_model()' fails, so we go to the label "err_xdp_info_reg_mem_model".
	4. 'xdp_rxq_info_unreg()' is called.
	5. Register state of 'xdp_rxq' changes to 'REG_STATE_UNREGISTERED'.
	6. 'virtnet_enable_qp()' returns an error.
	7. In 'virtnet_open()' we go to the "err_enable_qp" label.
	8. 'virtnet_disable_qp()' is called.
	9. 'xdp_rxq_info_unreg()' is called for the second time on the xdp_rxq which is already
	   in state 'REG_STATE_UNREGISTERED'.
	10. The following warning from 'xdp_rxq_info_unreg_mem_model' can be displayed:

		if (xdp_rxq->reg_state != REG_STATE_REGISTERED)
		{
			WARN(1, "Missing register, driver bug");
			return;
		}

I think the 'xdp_rxq_info_unreg()' can be called only once for the same 'xdp_rxq'.
I believe we should either:
	- remove that call from 'virtnet_enable_qp()',
	- or use the following API in 'virtnet_disable_qp()':
		'xdp_rxq_info_is_reg()'
	     to check if the xdp_rxq is actually registered.

Thanks,
Michal

> +	return err;
> +}
> +
>  static int virtnet_open(struct net_device *dev)
>  {
>  	struct virtnet_info *vi = netdev_priv(dev);
> @@ -1881,22 +1913,17 @@ static int virtnet_open(struct net_device *dev)
>  			if (!try_fill_recv(vi, &vi->rq[i], GFP_KERNEL))
>  				schedule_delayed_work(&vi->refill, 0);
>  
> -		err = xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, i, vi->rq[i].napi.napi_id);
> +		err = virtnet_enable_qp(vi, i);
>  		if (err < 0)
> -			return err;
> -
> -		err = xdp_rxq_info_reg_mem_model(&vi->rq[i].xdp_rxq,
> -						 MEM_TYPE_PAGE_SHARED, NULL);
> -		if (err < 0) {
> -			xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
> -			return err;
> -		}
> -
> -		virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
> -		virtnet_napi_tx_enable(vi, vi->sq[i].vq, &vi->sq[i].napi);
> +			goto err_enable_qp;
>  	}
>  
>  	return 0;
> +
> +err_enable_qp:
> +	for (i--; i >= 0; i--)
> +		virtnet_disable_qp(vi, i);
> +	return err;
>  }
>  
>  static int virtnet_poll_tx(struct napi_struct *napi, int budget)
> @@ -2305,11 +2332,8 @@ static int virtnet_close(struct net_device *dev)
>  	/* Make sure refill_work doesn't re-enable napi! */
>  	cancel_delayed_work_sync(&vi->refill);
>  
> -	for (i = 0; i < vi->max_queue_pairs; i++) {
> -		virtnet_napi_tx_disable(&vi->sq[i].napi);
> -		napi_disable(&vi->rq[i].napi);
> -		xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
> -	}
> +	for (i = 0; i < vi->max_queue_pairs; i++)
> +		virtnet_disable_qp(vi, i);
>  
>  	return 0;
>  }
> -- 
> 2.37.1 (Apple Git-137.1)
> 
> 

