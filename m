Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD7466E229
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjAQP3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjAQP2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:28:44 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7200D55BA;
        Tue, 17 Jan 2023 07:28:43 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id a1-20020a056830008100b006864df3b1f8so635430oto.3;
        Tue, 17 Jan 2023 07:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zLXS/cUl/m4ASnk2LLn5VLUL5zFl6vQ/9rRVsXeEYh8=;
        b=jQb/S7oKQvDlhIWm6ropMYIgbyceqrtLzxjol06kMFyAMQ9z7N+jSS4I9tEGinmdD2
         g43SReLlSHrZLpPjEKJ6odzelN54PYQsPZ4eihdl2+9RkcDEMiRHyj9O9vKLJ0JhJI4j
         dYL5geKABTPS781255Z2f5fkAE2iC4QMVzSOHX0jl4R3P72VtfeBAcfhf5hNrA0b9vij
         rLJRzvJ4+ko75gh7eOymsiI0qKf2VeUxFmlKQBmeqoCwowR619Z5GLp0KQ1lmuGhtk7Y
         t7Fj6RSczglgN7A9Ct6CzWhBAgwbs/2r60jFRpiIwRu8JLfcH3L9JPansHJFaBF91Dte
         WxyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zLXS/cUl/m4ASnk2LLn5VLUL5zFl6vQ/9rRVsXeEYh8=;
        b=OvN+bm5Fqu5v1CRw8ONXQAatJwRRxxr8sXAEb9zKLS3U9OndD9WydScQv7BcwCVn7c
         U9bH4+oRafrVmj1WzAmdv4vvQWNJlNFvcdy91rufP6Hs7RvVrndLI4P3Z+dySsEGhPy8
         zoO+8jzlHXcYdel4YcbNQ1KexOTH63mCvACthz3V5Pu8yMKizKN8VbUhOYAUAs/rsjta
         HR0JK8RNCk1HCQQJlqp3dtPITF3EZTgYH7pBVjeCvABcDv2AfMipslxVZGRtuNV9Xytm
         kTchWEQSNhaWcfVC10oGehCJQ1WKRYoZw4G9Zj/vOdw8rkjcXuPTXEbdyPirOBhP34dV
         9lDg==
X-Gm-Message-State: AFqh2kp0c3xVOy1DoaM/2E7P20OabkMP1UkJ5NNRgTBh+dg2xtd0Flqu
        vpWi8lLIcYXa+Fi/cdHVDzM=
X-Google-Smtp-Source: AMrXdXvvqZU5NswqEuu7QTTsS3Zbc8BQcCFmwhVRNPoB6gP7jFzzjeQoB+t6IAwTYI1zYF5ujBMbtQ==
X-Received: by 2002:a9d:6483:0:b0:66e:98f2:edd with SMTP id g3-20020a9d6483000000b0066e98f20eddmr11381763otl.6.1673969322696;
        Tue, 17 Jan 2023 07:28:42 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f013:7189:754f:dfa5:a770:f05f])
        by smtp.gmail.com with ESMTPSA id k8-20020a9d7608000000b006708a6274afsm16628372otl.25.2023.01.17.07.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 07:28:42 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 8F32C4AD20A; Tue, 17 Jan 2023 12:28:40 -0300 (-03)
Date:   Tue, 17 Jan 2023 12:28:40 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, ozsh@nvidia.com,
        simon.horman@corigine.com
Subject: Re: [PATCH net-next v2 4/7] netfilter: flowtable: allow updating
 offloaded rules asynchronously
Message-ID: <Y8a+qBjcr7KuPf+e@t14s.localdomain>
References: <20230113165548.2692720-1-vladbu@nvidia.com>
 <20230113165548.2692720-5-vladbu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113165548.2692720-5-vladbu@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 05:55:45PM +0100, Vlad Buslov wrote:
> Following patches in series need to update flowtable rule several times
> during its lifetime in order to synchronize hardware offload with actual ct
> status. However, reusing existing 'refresh' logic in act_ct would cause
> data path to potentially schedule significant amount of spurious tasks in
> 'add' workqueue since it is executed per-packet. Instead, introduce a new
> flow 'update' flag and use it to schedule async flow refresh in flowtable
> gc which will only be executed once per gc iteration.
> 
> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
> ---
>  include/net/netfilter/nf_flow_table.h |  3 ++-
>  net/netfilter/nf_flow_table_core.c    | 20 +++++++++++++++-----
>  net/netfilter/nf_flow_table_offload.c |  5 +++--
>  3 files changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
> index 88ab98ab41d9..e396424e2e68 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -165,6 +165,7 @@ enum nf_flow_flags {
>  	NF_FLOW_HW_DEAD,
>  	NF_FLOW_HW_PENDING,
>  	NF_FLOW_HW_BIDIRECTIONAL,
> +	NF_FLOW_HW_UPDATE,
>  };
>  
>  enum flow_offload_type {
> @@ -300,7 +301,7 @@ unsigned int nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
>  #define MODULE_ALIAS_NF_FLOWTABLE(family)	\
>  	MODULE_ALIAS("nf-flowtable-" __stringify(family))
>  
> -void nf_flow_offload_add(struct nf_flowtable *flowtable,
> +bool nf_flow_offload_add(struct nf_flowtable *flowtable,
>  			 struct flow_offload *flow);
>  void nf_flow_offload_del(struct nf_flowtable *flowtable,
>  			 struct flow_offload *flow);
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 04bd0ed4d2ae..5b495e768655 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -316,21 +316,28 @@ int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
>  }
>  EXPORT_SYMBOL_GPL(flow_offload_add);
>  
> +static bool __flow_offload_refresh(struct nf_flowtable *flow_table,
> +				   struct flow_offload *flow)
> +{
> +	if (likely(!nf_flowtable_hw_offload(flow_table)))
> +		return true;
> +
> +	return nf_flow_offload_add(flow_table, flow);
> +}
> +
>  void flow_offload_refresh(struct nf_flowtable *flow_table,
>  			  struct flow_offload *flow)
>  {
>  	u32 timeout;
>  
>  	timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
> -	if (timeout - READ_ONCE(flow->timeout) > HZ)
> +	if (timeout - READ_ONCE(flow->timeout) > HZ &&
> +	    !test_bit(NF_FLOW_HW_UPDATE, &flow->flags))
>  		WRITE_ONCE(flow->timeout, timeout);
>  	else
>  		return;
>  
> -	if (likely(!nf_flowtable_hw_offload(flow_table)))
> -		return;
> -
> -	nf_flow_offload_add(flow_table, flow);
> +	__flow_offload_refresh(flow_table, flow);
>  }
>  EXPORT_SYMBOL_GPL(flow_offload_refresh);
>  
> @@ -435,6 +442,9 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
>  		} else {
>  			flow_offload_del(flow_table, flow);
>  		}
> +	} else if (test_and_clear_bit(NF_FLOW_HW_UPDATE, &flow->flags)) {
> +		if (!__flow_offload_refresh(flow_table, flow))
> +			set_bit(NF_FLOW_HW_UPDATE, &flow->flags);
>  	} else if (test_bit(NF_FLOW_HW, &flow->flags)) {
>  		nf_flow_offload_stats(flow_table, flow);

AFAICT even after this patchset it is possible to have both flags set
at the same time.
With that, this would cause the stats to skip a beat.
This would be better:

- 	} else if (test_bit(NF_FLOW_HW, &flow->flags)) {
- 		nf_flow_offload_stats(flow_table, flow);
+	} else {
+		if (test_and_clear_bit(NF_FLOW_HW_UPDATE, &flow->flags))
+			if (!__flow_offload_refresh(flow_table, flow))
+				set_bit(NF_FLOW_HW_UPDATE, &flow->flags);
+	 	if (test_bit(NF_FLOW_HW, &flow->flags))
+ 			nf_flow_offload_stats(flow_table, flow);
 	}

But a flow cannot have 2 pending actions at a time.
Then maybe an update to nf_flow_offload_tuple() to make it handle the
stats implicitly?

>  	}
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> index 8b852f10fab4..103b2ca8d123 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -1036,16 +1036,17 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
>  }
>  
>  
> -void nf_flow_offload_add(struct nf_flowtable *flowtable,
> +bool nf_flow_offload_add(struct nf_flowtable *flowtable,
>  			 struct flow_offload *flow)
>  {
>  	struct flow_offload_work *offload;
>  
>  	offload = nf_flow_offload_work_alloc(flowtable, flow, FLOW_CLS_REPLACE);
>  	if (!offload)
> -		return;
> +		return false;
>  
>  	flow_offload_queue_work(offload);
> +	return true;
>  }
>  
>  void nf_flow_offload_del(struct nf_flowtable *flowtable,
> -- 
> 2.38.1
> 
