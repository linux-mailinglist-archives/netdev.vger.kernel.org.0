Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 617425E93EF
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 17:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbiIYPYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 11:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbiIYPYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 11:24:47 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E0DD100;
        Sun, 25 Sep 2022 08:24:42 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id r20so2786810qtn.12;
        Sun, 25 Sep 2022 08:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=RwYAgY9k+ZdHOhXCXlvKjDwCnUM8rmMBXSn9DDqSSiI=;
        b=YLadT8V2+TdwrGM8mR5Co5lLfFJZbvhx+vr97l/qOw1w8fOddBEsH9/3NrnZKQdTAk
         9jKEfaIQxZMfZVNUjT8SeteblgwHRYx0crlAiZT+mt/5q5++vYp+dy9Dr54xlfoojIQt
         8dtAlkG963gZqU4i5sbqu8PRIQxq0uNEMFHw9ErjJjO2zZKcfNi95j0Gn5vuYZTCoQ5w
         NrRoMJ5uDLOLDJS/KZyRYLUiHPnFMMRf0dU0JKFuZQ2j7s1tY0oa+2yII+Fn66oxTU0E
         B4zgiRDhdOgSlOz3+wAFX9S7jTNR9YY9GCxCCDg6IaAvOUo6UTLusRKxUmj9eiu7DETh
         kxBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=RwYAgY9k+ZdHOhXCXlvKjDwCnUM8rmMBXSn9DDqSSiI=;
        b=5s4ErrIJEUGrqNkexixcxLdtmDHA6pmyNVsCiNJgKluFmehUzAF4Hucn5jJENaiMxH
         D/HT6fv38UJN5PcLR/9EtREIeBP0B2IOfSk+xzpyj02Y7LgluX9ZMHopuL9+lAjrnLZD
         Q4End8c1JTpGkOZILiIWl60JegdwPXft93Uo5T3pncucSCagT0xY0NfEGc6qDxtIShON
         syhyGznFMG1GtLHZBY0O5CikAneWv6l3FzTkyvL38VU/dbDZp79x9PkIFmyKdoI9OA7W
         5T0iG2LhI6TYmNY4eIj86z5itDPzM0bOqho49tt0UmnXeH/n24U0sKFyz5Jsx5pkv5Hx
         9fSQ==
X-Gm-Message-State: ACrzQf0WvpbheIpo6tz5v7HmMYeCAAk/kNsMqi0RAtmBc335Whj8RTGr
        7gn7JPfevGm9fby/JGRnVTk=
X-Google-Smtp-Source: AMsMyM7CIRuyE84Lf4RVlXhJr/6n4jP6Uo2inXHxQm41OSa4JAVk7hKO+EQ+UXabfXfIpigfWi7Tsw==
X-Received: by 2002:a05:622a:5d2:b0:35d:dc4:e9e8 with SMTP id d18-20020a05622a05d200b0035d0dc4e9e8mr15092149qtb.650.1664119482017;
        Sun, 25 Sep 2022 08:24:42 -0700 (PDT)
Received: from localhost ([2601:4c1:c100:2270:2eaf:6d8e:66c4:eb75])
        by smtp.gmail.com with ESMTPSA id s2-20020a05620a29c200b006ce40fbb8f6sm9574756qkp.21.2022.09.25.08.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Sep 2022 08:24:41 -0700 (PDT)
Date:   Sun, 25 Sep 2022 08:24:41 -0700
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
Message-ID: <YzByuaa4ewpTNNOx@yury-laptop>
References: <20220923132527.1001870-1-vschneid@redhat.com>
 <20220923155542.1212814-4-vschneid@redhat.com>
 <YzBtH8s98eTmxaJo@yury-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzBtH8s98eTmxaJo@yury-laptop>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 25, 2022 at 08:00:49AM -0700, Yury Norov wrote:
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
> 
> Since it's exported, can you declare function parameters and return
> values properly?

s/declare/describe
