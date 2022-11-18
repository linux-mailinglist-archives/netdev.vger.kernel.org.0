Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0645262F538
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 13:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241650AbiKRMnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 07:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241449AbiKRMna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 07:43:30 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B73EDF93;
        Fri, 18 Nov 2022 04:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668775408; x=1700311408;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F0zlFnxVFLYu6iVxfumz7vqydWiHd9Ei4WVzu9ETGUU=;
  b=DKPYsP5P7ErT+6Xl5CUwX6Ah6RODVBkEYrDuagNBNM5F7OjZID3gW4oq
   jpvlopztCkvcUDPYkrZ3itHpWjIHm/6s1SwyWpMg701HIKQd7Pr0VyGpq
   JplVeQozhN6SnzxxnXVdJfhcCuROVm4jkrq+VepaOEthnB/TRSKFocMI7
   fdksNGuV0/iMN35Qy+fnELIKsHpwem/WpVf2Tfqqr8jz6qmVEVRbhsnSQ
   DTK+zxOpA05Zt7+HAvzVe9aF5UUOCjhNbxYRrPsu6lhBLiXXpA7gA6twU
   v7nocmQEw1JKkS5wXjSkkWLXLA9klnrFIG67X970ctqFgGOtv+OX6fmxy
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="292827955"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="292827955"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 04:43:27 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="765155249"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="765155249"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 04:43:24 -0800
Date:   Fri, 18 Nov 2022 13:43:14 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Denis Arefev <arefev@swemel.ru>
Cc:     Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org, trufanov@swemel.ru, vfh@swemel.ru
Subject: Re: [PATCH net v3] nfp: flower: Added pointer check and continue
Message-ID: <Y3d94vyoT0unXnkd@localhost.localdomain>
References: <20221118080317.119749-1-arefev@swemel.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118080317.119749-1-arefev@swemel.ru>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 11:03:17AM +0300, Denis Arefev wrote:
> Return value of a function 'kmalloc_array' is dereferenced at 
> lag_conf.c:347 without checking for null, 
> but it is usually checked for this function.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> Fixes: bb9a8d031140 ("nfp: flower: monitor and offload LAG groups")
> Signed-off-by: Denis Arefev <arefev@swemel.ru>
> ---
>  drivers/net/ethernet/netronome/nfp/flower/lag_conf.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c b/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
> index 63907aeb3884..1aaec4cb9f55 100644
> --- a/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
> +++ b/drivers/net/ethernet/netronome/nfp/flower/lag_conf.c
> @@ -276,7 +276,7 @@ static void nfp_fl_lag_do_work(struct work_struct *work)
>  
>  	mutex_lock(&lag->lock);
>  	list_for_each_entry_safe(entry, storage, &lag->group_list, list) {
> -		struct net_device *iter_netdev, **acti_netdevs;
> +		struct net_device *iter_netdev, **acti_netdevs = NULL;
Small nit, otherwise looks fine.

I think there is no need to set it to NULL here as it is always set to
return value from kmalloc_array().

Thanks
>  		struct nfp_flower_repr_priv *repr_priv;
>  		int active_count = 0, slaves = 0;
>  		struct nfp_repr *repr;
> @@ -308,6 +308,10 @@ static void nfp_fl_lag_do_work(struct work_struct *work)
>  
>  		acti_netdevs = kmalloc_array(entry->slave_cnt,
>  					     sizeof(*acti_netdevs), GFP_KERNEL);
> +		if (!acti_netdevs) {
> +			schedule_delayed_work(&lag->work, NFP_FL_LAG_DELAY);
> +			continue;
> +		}
>  
>  		/* Include sanity check in the loop. It may be that a bond has
>  		 * changed between processing the last notification and the
> -- 
> 2.25.1
> 
