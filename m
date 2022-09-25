Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF56F5E955A
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 20:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbiIYSNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 14:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiIYSNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 14:13:48 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022CE2C651;
        Sun, 25 Sep 2022 11:13:45 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id w2so2947138qtv.9;
        Sun, 25 Sep 2022 11:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ol4j9TJWDPz3Qh7DXbjGbnzN/8qpAI4uxo5G63wTCHQ=;
        b=ordxroTyTkekhrZldeVYHj2fcfKR6pIwcMZmdUIYjVspGJJdpzk+HjvHLVdSM/91yx
         I3rK414ZlsJaCZ0hnQ1401jjcwyf61xZeDnP8mLl5e1oSrtGsfrm9uIs1UugH+S3mOvU
         kYIaRC5GmHXU6BYNL1B5MS1x0KA8i+uDQUii+vSSu6WuKzqhZ0Hft+wLyTJFcjZz1sNF
         +b1NuwMpORmKreqwO++n/8FEJ2W0q3xYTl02Vj3gxl2omzVQPZbPrFAxkHFmtt2xIf12
         2cF7IuufSBf7ofuoIC8Hqp9/RKYExy7odxhC70eYqoqPuWRDCjFZNom+K/iwl0QxB0js
         Rlmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ol4j9TJWDPz3Qh7DXbjGbnzN/8qpAI4uxo5G63wTCHQ=;
        b=IEv61+eG7vn7/S1e8TS1+MzQlDurIApoLcDxjt/8xru2rGe1UQCxgisZagQEp9IS4P
         k6PFu9frOpnf2B7egGlDQcZo5ZaTZeQpkfCosBuaRSj6tuThdsgtCX5iAyWXlxcjAmKl
         bEP69h1XYSOS9LChJJMxRp66S2KGQRbXkXOguFZnsOGe3/30vhDr+cP3T1epSCpr+lbu
         0cIBKSrNO4umU+B1MD36RKujs7oA5CIV3LeQjQ+D5yu0qLoj6JYSFQAs6vQmVS6420zk
         ciLe0x1MIu0YxKdOiStBYQ8gBOJP1yU3iU4cRNwsVWeqpyR2NH0WMEHfxDtrVBjvIUt+
         WKZw==
X-Gm-Message-State: ACrzQf3nuIHO1verDQlxOXghaRn8ra0JdxAeHqdPhy5ZS/Atyrmr4E+T
        G0xzH8kSwHo99FO4Bs7oB6M=
X-Google-Smtp-Source: AMsMyM6MgFJcPb8g6JKoJsQBYkdhTOcjP1cigSdK1tRq9n/c1uN158a++e19q0Wv/pX9yXDlUxhs0A==
X-Received: by 2002:ac8:7d85:0:b0:35c:bf28:d2c3 with SMTP id c5-20020ac87d85000000b0035cbf28d2c3mr16032005qtd.81.1664129623640;
        Sun, 25 Sep 2022 11:13:43 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:7be8:ebb8:b71d:18b9])
        by smtp.gmail.com with ESMTPSA id m10-20020ac807ca000000b00342f05defd1sm9129423qth.66.2022.09.25.11.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 11:13:43 -0700 (PDT)
Date:   Sun, 25 Sep 2022 11:13:42 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mel Gorman <mgorman@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Tony Luck <tony.luck@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Gal Pressman <gal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH v4 5/7] sched/topology: Introduce sched_numa_hop_mask()
Message-ID: <YzCaVullLCZmKRBL@yury-laptop>
References: <20220923132527.1001870-1-vschneid@redhat.com>
 <20220923155542.1212814-4-vschneid@redhat.com>
 <YzCYXEytXy8UJQFv@yury-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzCYXEytXy8UJQFv@yury-laptop>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 25, 2022 at 11:05:18AM -0700, Yury Norov wrote:
> On Fri, Sep 23, 2022 at 04:55:40PM +0100, Valentin Schneider wrote:
> > Tariq has pointed out that drivers allocating IRQ vectors would benefit
> > from having smarter NUMA-awareness - cpumask_local_spread() only knows
> > about the local node and everything outside is in the same bucket.
> > 
> > sched_domains_numa_masks is pretty much what we want to hand out (a cpumask
> > of CPUs reachable within a given distance budget), introduce
> > sched_numa_hop_mask() to export those cpumasks.
> > 
> > Link: http://lore.kernel.org/r/20220728191203.4055-1-tariqt@nvidia.com
> > Signed-off-by: Valentin Schneider <vschneid@redhat.com>
> > ---
> >  include/linux/topology.h | 12 ++++++++++++
> >  kernel/sched/topology.c  | 31 +++++++++++++++++++++++++++++++
> >  2 files changed, 43 insertions(+)
> > 
> > diff --git a/include/linux/topology.h b/include/linux/topology.h
> > index 4564faafd0e1..3e91ae6d0ad5 100644
> > --- a/include/linux/topology.h
> > +++ b/include/linux/topology.h
> > @@ -245,5 +245,17 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
> >  	return cpumask_of_node(cpu_to_node(cpu));
> >  }
> >  
> > +#ifdef CONFIG_NUMA
> > +extern const struct cpumask *sched_numa_hop_mask(int node, int hops);
> > +#else
> > +static inline const struct cpumask *sched_numa_hop_mask(int node, int hops)
> > +{
> > +	if (node == NUMA_NO_NODE && !hops)
> > +		return cpu_online_mask;
> > +
> > +	return ERR_PTR(-EOPNOTSUPP);
> > +}
> > +#endif	/* CONFIG_NUMA */
> > +
> >  
> >  #endif /* _LINUX_TOPOLOGY_H */
> > diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> > index 8739c2a5a54e..ee77706603c0 100644
> > --- a/kernel/sched/topology.c
> > +++ b/kernel/sched/topology.c
> > @@ -2067,6 +2067,37 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
> >  	return found;
> >  }
> >  
> > +/**
> > + * sched_numa_hop_mask() - Get the cpumask of CPUs at most @hops hops away.
> > + * @node: The node to count hops from.
> > + * @hops: Include CPUs up to that many hops away. 0 means local node.
> > + *
> > + * Requires rcu_lock to be held. Returned cpumask is only valid within that
> > + * read-side section, copy it if required beyond that.
> > + *
> > + * Note that not all hops are equal in distance; see sched_init_numa() for how
> > + * distances and masks are handled.
> > + *
> > + * Also note that this is a reflection of sched_domains_numa_masks, which may change
> > + * during the lifetime of the system (offline nodes are taken out of the masks).
> > + */
> > +const struct cpumask *sched_numa_hop_mask(int node, int hops)
> > +{
> > +	struct cpumask ***masks = rcu_dereference(sched_domains_numa_masks);
> > +
> > +	if (node == NUMA_NO_NODE && !hops)
> > +		return cpu_online_mask;
> > +
> > +	if (node >= nr_node_ids || hops >= sched_domains_numa_levels)
> > +		return ERR_PTR(-EINVAL);
> 
> This looks like a sanity check. If so, it should go before the snippet
> above, so that client code would behave consistently.
> 
> > +
> > +	if (!masks)
> > +		return NULL;
> 
> In (node == NUMA_NO_NODE && !hops) case you return online cpus. Here
> you return NULL just to convert it to cpu_online_mask in the caller.
> This looks inconsistent. So, together with the above comment, this
> makes me feel that you'd do it like this:
> 
>  const struct cpumask *sched_numa_hop_mask(int node, int hops)
>  {
> 	struct cpumask ***masks;
> 
> 	if (node >= nr_node_ids || hops >= sched_domains_numa_levels)
>         {
>  #ifdef CONFIG_SCHED_DEBUG
>                 pr_err(...);
>  #endif
> 		return ERR_PTR(-EINVAL);
>         }

It's an exported function, and any lame driver may crash the system by
dereferencing a random pointer.

You need to check the node for -2, -3, etc, because only -1 is a valid
negative value. For hops, it should be an unsigned int. Right?

> 
> 	if (node == NUMA_NO_NODE && !hops)
> 		return cpu_online_mask; /* or NULL */
> 
>         masks = rcu_dereference(sched_domains_numa_masks);
> 	if (!masks)
> 		return cpu_online_mask; /* or NULL */
> 
> 	return masks[hops][node];
>  }
