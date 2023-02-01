Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E761B6865B7
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 13:09:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231676AbjBAMJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 07:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231445AbjBAMJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 07:09:26 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0669423329
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 04:09:25 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id p26so39568566ejx.13
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 04:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=p5YWm9YbNTKMxYNk4AOnV0WnqUFfbVvtTz0AfUn/Qgo=;
        b=5k0f2FB8TrOh0RzvKmfVJTTjHOQlLek/0/QvrYCjl8ZcOnHEph12KwYvHOIQ4CtH7Y
         UIJXaMqNTykXUXZz64gc/Nq2aT4/IZ2KK+p/ZvUtIG7BmbZfqhKsCX9JiaNCR/JGxa2H
         5ilyFkW6hKEaD2OLEir+62tDAoD+Pdx2n15xe50bflaO4hBfEDAVObbm7KqtLjdlM1l4
         7fa4yxe0LKz46yvjfmrsxgcuc3yZ/4H5FL7jJxNnDsDagrh+6Wk9jAFN+w8lLseqGQ1F
         mUBvx7iyl9j+r1+3nZ7awN+ZjojIYCkGxVpF+UkNEaJGQWFA+2adayH/DsXb2OnUskHJ
         aU9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p5YWm9YbNTKMxYNk4AOnV0WnqUFfbVvtTz0AfUn/Qgo=;
        b=fvNpV6ZHMnJatmnu7evlukop9ODoNOJUnUpiEW+qpEJ/Cs1awYCcvyfmTsDAr0Hort
         wEDGJyw807IOCjmuNBHTYaNuLWIiYh2XiP5Ajtwdn/p6Lhr2le4T7wzMb8wgTwNBpMu9
         N13V827K/qGOPQGzMQrg7wun9ZH11wLkpAcQzfsQMFAJvHXU65U9p00pHdh8rLWuQGp7
         eyfCb+PONR0N1qIPRp1S73e317pNgSfOrUivTYFqsexn0mv+i4AWONObB59FAnS7q8Em
         uuMY9uo4Z4KXYHlBKxFkB8uMnSqS1Ro2jiWu8U0Lkn5yTdpUO7VbrUw1y2t4ttABM3Ld
         ThFg==
X-Gm-Message-State: AO0yUKX7tCIjqqio6chVA2apIA7gLiet9duqROpRA1wECk0fYFI78ULu
        HP1ZmU3wsNZwFcwWaqDpk7sScQ==
X-Google-Smtp-Source: AK7set/NYyoxW+LDvGrhoWLOgDtKBMbhRQ/b6XMJ6R7ywgrZ52vlwSMuJrPgsrJQbSCvr/vqQsptkg==
X-Received: by 2002:a17:906:5048:b0:878:4bc1:dd19 with SMTP id e8-20020a170906504800b008784bc1dd19mr2099414ejk.52.1675253363585;
        Wed, 01 Feb 2023 04:09:23 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id v9-20020a170906380900b00877ec3b9b8bsm9992797ejc.153.2023.02.01.04.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:09:22 -0800 (PST)
Date:   Wed, 1 Feb 2023 13:09:20 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     taoyuan_eddy@hotmail.com
Cc:     dev@openvswitch.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: openvswitch: reduce cpu_used_mask memory consumption
Message-ID: <Y9pWcFdwaa4l6bPP@nanopsycho>
References: <OS3P286MB2295C30BCD41592C25805136F5D09@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OS3P286MB2295C30BCD41592C25805136F5D09@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 31, 2023 at 02:58:22PM CET, taoyuan_eddy@hotmail.com wrote:
>From: eddytaoyuan <taoyuan_eddy@hotmail.com>
>
>struct cpumask cpu_used_mask is directly embedded in struct sw_flow
>however, its size is hardcoded to CONFIG_NR_CPUS bits, which
>can be as large as 8192 by default, it cost memory and slows down
>ovs_flow_alloc, this fix used actual CPU number instead
>
>Signed-off-by: eddytaoyuan <taoyuan_eddy@hotmail.com>

Hmm, I guess that the name should be rather "Dddy Taoyuan" ? Please fix,
also in your "From:" header and preferably email client.


>---
> net/openvswitch/flow.c       |  6 +++---
> net/openvswitch/flow.h       |  2 +-
> net/openvswitch/flow_table.c | 25 ++++++++++++++++++++++---
> 3 files changed, 26 insertions(+), 7 deletions(-)
>
>diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
>index e20d1a973417..06345cd8c777 100644
>--- a/net/openvswitch/flow.c
>+++ b/net/openvswitch/flow.c
>@@ -107,7 +107,7 @@ void ovs_flow_stats_update(struct sw_flow *flow, __be16 tcp_flags,
> 
> 					rcu_assign_pointer(flow->stats[cpu],
> 							   new_stats);
>-					cpumask_set_cpu(cpu, &flow->cpu_used_mask);
>+					cpumask_set_cpu(cpu, flow->cpu_used_mask);
> 					goto unlock;
> 				}
> 			}
>@@ -135,7 +135,7 @@ void ovs_flow_stats_get(const struct sw_flow *flow,
> 	memset(ovs_stats, 0, sizeof(*ovs_stats));
> 
> 	/* We open code this to make sure cpu 0 is always considered */
>-	for (cpu = 0; cpu < nr_cpu_ids; cpu = cpumask_next(cpu, &flow->cpu_used_mask)) {
>+	for (cpu = 0; cpu < nr_cpu_ids; cpu = cpumask_next(cpu, flow->cpu_used_mask)) {
> 		struct sw_flow_stats *stats = rcu_dereference_ovsl(flow->stats[cpu]);
> 
> 		if (stats) {
>@@ -159,7 +159,7 @@ void ovs_flow_stats_clear(struct sw_flow *flow)
> 	int cpu;
> 
> 	/* We open code this to make sure cpu 0 is always considered */
>-	for (cpu = 0; cpu < nr_cpu_ids; cpu = cpumask_next(cpu, &flow->cpu_used_mask)) {
>+	for (cpu = 0; cpu < nr_cpu_ids; cpu = cpumask_next(cpu, flow->cpu_used_mask)) {
> 		struct sw_flow_stats *stats = ovsl_dereference(flow->stats[cpu]);
> 
> 		if (stats) {
>diff --git a/net/openvswitch/flow.h b/net/openvswitch/flow.h
>index 073ab73ffeaa..b5711aff6e76 100644
>--- a/net/openvswitch/flow.h
>+++ b/net/openvswitch/flow.h
>@@ -229,7 +229,7 @@ struct sw_flow {
> 					 */
> 	struct sw_flow_key key;
> 	struct sw_flow_id id;
>-	struct cpumask cpu_used_mask;
>+	struct cpumask *cpu_used_mask;
> 	struct sw_flow_mask *mask;
> 	struct sw_flow_actions __rcu *sf_acts;
> 	struct sw_flow_stats __rcu *stats[]; /* One for each CPU.  First one
>diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
>index 0a0e4c283f02..c0fdff73272f 100644
>--- a/net/openvswitch/flow_table.c
>+++ b/net/openvswitch/flow_table.c
>@@ -87,11 +87,12 @@ struct sw_flow *ovs_flow_alloc(void)
> 	if (!stats)
> 		goto err;
> 
>+	flow->cpu_used_mask = (struct cpumask *)&(flow->stats[nr_cpu_ids]);
> 	spin_lock_init(&stats->lock);
> 
> 	RCU_INIT_POINTER(flow->stats[0], stats);
> 
>-	cpumask_set_cpu(0, &flow->cpu_used_mask);
>+	cpumask_set_cpu(0, flow->cpu_used_mask);
> 
> 	return flow;
> err:
>@@ -115,7 +116,7 @@ static void flow_free(struct sw_flow *flow)
> 					  flow->sf_acts);
> 	/* We open code this to make sure cpu 0 is always considered */
> 	for (cpu = 0; cpu < nr_cpu_ids;
>-	     cpu = cpumask_next(cpu, &flow->cpu_used_mask)) {
>+	     cpu = cpumask_next(cpu, flow->cpu_used_mask)) {
> 		if (flow->stats[cpu])
> 			kmem_cache_free(flow_stats_cache,
> 					(struct sw_flow_stats __force *)flow->stats[cpu]);
>@@ -1194,9 +1195,27 @@ int ovs_flow_init(void)
> 	BUILD_BUG_ON(__alignof__(struct sw_flow_key) % __alignof__(long));
> 	BUILD_BUG_ON(sizeof(struct sw_flow_key) % sizeof(long));
> 
>+        /*
>+         * Simply including 'struct cpumask' in 'struct sw_flow'
>+         * consumes memory unnecessarily large.
>+         * The reason is that compilation option CONFIG_NR_CPUS(default 8192)
>+         * decides the value of NR_CPUS, which in turn decides size of
>+         * 'struct cpumask', which means 1024 bytes are needed for the cpumask
>+         * It affects ovs_flow_alloc performance as well as memory footprint.
>+         * We should use actual CPU count instead of hardcoded value.
>+         *
>+         * To address this, 'cpu_used_mask' is redefined to pointer
>+         * and append a cpumask_size() after 'stat' to hold the actual memory
>+         * of struct cpumask
>+         *
>+         * cpumask APIs like cpumask_next and cpumask_set_cpu have been defined
>+         * to never access bits beyond cpu count by design, thus above change is
>+         * safe even though the actual memory provided is smaller than
>+         * sizeof(struct cpumask)

I don't understand the reason to have this comment in the code. From
what I see, this should be moved to the patch description. Of course
with changing the mood to imperation when you say the codebase what to
do.




>+         */
> 	flow_cache = kmem_cache_create("sw_flow", sizeof(struct sw_flow)
> 				       + (nr_cpu_ids
>-					  * sizeof(struct sw_flow_stats *)),
>+					  * sizeof(struct sw_flow_stats *)) + cpumask_size(),
> 				       0, 0, NULL);
> 	if (flow_cache == NULL)
> 		return -ENOMEM;
>-- 
>2.27.0
>
