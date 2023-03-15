Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4886BAD8B
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 11:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232098AbjCOKW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 06:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbjCOKW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 06:22:28 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4431F87A0F
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 03:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678875705; x=1710411705;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=k2viKLbw7rzEb4bBTVid9Ljp3e27yka6pL6K/7iKjsY=;
  b=nIacz0hQoOdWMbTJrtckkeFkFQa3ykOayilYv5/incWNDnUTXfLBd3WP
   Hnyx28sDX6RuyLmntmlSz4kqYFNOB9rlEqKhTsVDwWpyFBGECTK1YEtUP
   L9L62dGU2cA/5JW0ErFQXJO4zpJY6qJLJ9x8XfrJKwq4k3gR1A206O+PS
   C8ontEjEPo8PRbhHkjvTDW3UfkcoqlJQmmxZ+jUJzFAxG/hVirtgyCw/A
   xsBnpEOLJDGBcFKhWl4+yQIH8fjvppG+3+uImhVZ5Y4srbDA3hvSPFht8
   idxDwSFb5gADt4/FbMveDzCrn+EVpO6/Yvyy0BUrMGenfLpRwcuunNBZT
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="339207170"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="339207170"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 03:21:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="803222202"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="803222202"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 03:21:42 -0700
Date:   Wed, 15 Mar 2023 11:21:34 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, Hangbin Liu <haliu@redhat.com>
Subject: Re: [PATCH net-next] net/sched: act_api: use the correct TCA_ACT
 attributes in dump
Message-ID: <ZBGcLq2dGqCxj2BO@localhost.localdomain>
References: <20230314193321.554475-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314193321.554475-1-pctammela@mojatatu.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 04:33:21PM -0300, Pedro Tammela wrote:
> 3 places in the act api code are using 'TCA_' definitions where they should be using
> 'TCA_ACT_', which is confusing for the reader, although functionaly wise they are equivalent.
> 
> Cc: Hangbin Liu <haliu@redhat.com>
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---
>  net/sched/act_api.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> index 34c508675041..612b40bf6b0f 100644
> --- a/net/sched/act_api.c
> +++ b/net/sched/act_api.c
> @@ -453,7 +453,7 @@ static size_t tcf_action_shared_attrs_size(const struct tc_action *act)
>  		+ nla_total_size_64bit(sizeof(u64))
>  		/* TCA_STATS_QUEUE */
>  		+ nla_total_size_64bit(sizeof(struct gnet_stats_queue))
> -		+ nla_total_size(0) /* TCA_OPTIONS nested */
> +		+ nla_total_size(0) /* TCA_ACT_OPTIONS nested */
>  		+ nla_total_size(sizeof(struct tcf_t)); /* TCA_GACT_TM */
>  }
>  
> @@ -480,7 +480,7 @@ tcf_action_dump_terse(struct sk_buff *skb, struct tc_action *a, bool from_act)
>  	unsigned char *b = skb_tail_pointer(skb);
>  	struct tc_cookie *cookie;
>  
> -	if (nla_put_string(skb, TCA_KIND, a->ops->kind))
> +	if (nla_put_string(skb, TCA_ACT_KIND, a->ops->kind))
>  		goto nla_put_failure;
>  	if (tcf_action_copy_stats(skb, a, 0))
>  		goto nla_put_failure;
> @@ -1189,7 +1189,7 @@ tcf_action_dump_1(struct sk_buff *skb, struct tc_action *a, int bind, int ref)
>  	if (nla_put_u32(skb, TCA_ACT_IN_HW_COUNT, a->in_hw_count))
>  		goto nla_put_failure;
>  
> -	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
> +	nest = nla_nest_start_noflag(skb, TCA_ACT_OPTIONS);
>  	if (nest == NULL)
>  		goto nla_put_failure;
>  	err = tcf_action_dump_old(skb, a, bind, ref);

Right, looks fine for me.
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

> -- 
> 2.34.1
> 
