Return-Path: <netdev+bounces-10950-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E19F730BF0
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 02:06:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 977872815DE
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 00:06:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E69567F3;
	Thu, 15 Jun 2023 00:06:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40757ED
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 00:06:30 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78291FFA;
	Wed, 14 Jun 2023 17:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686787587; x=1718323587;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=djJPb93h9IgIoHTp34Q6aT2YGUU7mv3dQuXgsAsIWCM=;
  b=d4HQnM45qTuJn8XGhOgT6ZfVUc8sRwE3YUwbkYNsjvD1+5m45t6KHSEW
   my+vxUPtceKAh6gyH7cnY7m06krixYtSOLxLzWwjZgKwk3b7ocPuYSylR
   8h2G85o9DsjvOu88nk45AmdfkwhYBnsXU79R87WsOzW9s9jEN0pVs0ILm
   bBEFkZUjVRo4M4Trheo5KXNsDY8Ru4x6ppY8ObmIMMczk9MZ6T5H1DpFw
   CgOO3Bc/D2czS/Pc7FbQJRSme/Z5lFWz8bZd506aFRrLZu36dF3qva/It
   QwjvpDblt8PpywgMzL+avHHNENX8MfIbLrbfZpOZFeNYYTclj9uQZzWuM
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="424658773"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="424658773"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 17:06:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="856706141"
X-IronPort-AV: E=Sophos;i="6.00,243,1681196400"; 
   d="scan'208";a="856706141"
Received: from gjgambo-mobl2.amr.corp.intel.com (HELO vcostago-mobl3) ([10.212.235.28])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 17:06:24 -0700
From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang
 <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
 linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org, Muhammad
 Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>, Peilin Ye
 <yepeilin.cs@gmail.com>, Pedro Tammela <pctammela@mojatatu.com>, Richard
 Cochran <richardcochran@gmail.com>, Zhengchao Shao
 <shaozhengchao@huawei.com>, Maxim
 Georgiev <glipus@gmail.com>
Subject: Re: [PATCH v2 net-next 7/9] net: netdevsim: mimic tc-taprio offload
In-Reply-To: <20230613215440.2465708-8-vladimir.oltean@nxp.com>
References: <20230613215440.2465708-1-vladimir.oltean@nxp.com>
 <20230613215440.2465708-8-vladimir.oltean@nxp.com>
Date: Wed, 14 Jun 2023 17:06:24 -0700
Message-ID: <877cs5twqn.fsf@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> To be able to use netdevsim for tc-testing with an offloaded tc-taprio
> schedule, it needs to report a PTP clock (which it now does), and to
> accept ndo_setup_tc(TC_SETUP_QDISC_TAPRIO) calls.
>
> Since netdevsim has no packet I/O, this doesn't do anything intelligent,
> it only allows taprio offload code paths to go through some level of
> automated testing.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v1->v2: patch is new
>
>  drivers/net/netdevsim/netdev.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>
> diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
> index 58cd51de5b79..e26be4bd0d90 100644
> --- a/drivers/net/netdevsim/netdev.c
> +++ b/drivers/net/netdevsim/netdev.c
> @@ -209,6 +209,31 @@ static int nsim_set_vf_link_state(struct net_device *dev, int vf, int state)
>  	return 0;
>  }
>  
> +static void nsim_taprio_stats(struct tc_taprio_qopt_stats *stats)
> +{
> +	stats->window_drops = 0;
> +	stats->tx_overruns = 0;
> +}
> +
> +static int nsim_setup_tc_taprio(struct net_device *dev,
> +				struct tc_taprio_qopt_offload *offload)
> +{
> +	int err = 0;
> +
> +	switch (offload->cmd) {
> +	case TAPRIO_CMD_REPLACE:
> +	case TAPRIO_CMD_DESTROY:
> +		break;

I was thinking about how useful would proper validation of the
parameters be? Thinking that we could detect "driver API" breakages
earlier, and we want it documented that the drivers should check for the
things that it supports.

Makes sense?

> +	case TAPRIO_CMD_STATS:
> +		nsim_taprio_stats(&offload->stats);
> +		break;
> +	default:
> +		err = -EOPNOTSUPP;
> +	}
> +
> +	return err;
> +}
> +
>  static LIST_HEAD(nsim_block_cb_list);
>  
>  static int
> @@ -217,6 +242,8 @@ nsim_setup_tc(struct net_device *dev, enum tc_setup_type type, void *type_data)
>  	struct netdevsim *ns = netdev_priv(dev);
>  
>  	switch (type) {
> +	case TC_SETUP_QDISC_TAPRIO:
> +		return nsim_setup_tc_taprio(dev, type_data);
>  	case TC_SETUP_BLOCK:
>  		return flow_block_cb_setup_simple(type_data,
>  						  &nsim_block_cb_list,
> -- 
> 2.34.1
>

Cheers,
-- 
Vinicius

