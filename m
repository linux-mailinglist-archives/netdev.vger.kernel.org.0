Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B6A60BF9D
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 02:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbiJYAda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 20:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiJYAdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 20:33:06 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B3A1870B3;
        Mon, 24 Oct 2022 15:57:51 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-13be3ef361dso1160802fac.12;
        Mon, 24 Oct 2022 15:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1jpnB9M+lUx8mTalc2CYaRAaH+zKMlWayKR7/3tTIjY=;
        b=j9MmxsxfjV2DuOk7P5Ux5Y+5R1CpOqJSNPgK4sF7YQ7bw7OnTQIR+PMalDScdE/TKy
         yc/QWE9eRaB4O/LXBPMTsrN2Yi3QVGP7fdPKrRDFNGRXL750HrQ2rhTdJ8rrS5eTYyN3
         rz4Hr4BeRUC0ST1p2kbCMOR+iya7QcfI5Sb9l/gjbtqaUhiNm7V6mt0O4K8UnRIgV4MA
         gBjGb07q1B2gM9cP92HGwOHh7mrtO/kSocPpJTAhX+eHlOjr7QknACj0lILgiMsIuwsZ
         mTIBuurjOssrj9duju52AkEtx+9pxZvEcuy37RTNt62UGpBbTbj1GUmFgCten8UfdE+Q
         81+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1jpnB9M+lUx8mTalc2CYaRAaH+zKMlWayKR7/3tTIjY=;
        b=bqvELFJAGQzI9FcnBzvB8fV2YLj0RgsAasRYg/TGGvI1zmt7ZXGp/z7Qzes1FH/G0z
         pAOd37Nj2Q+5DGlzdfDYjXSv4W4pgAc2t8Hc8sCCacLkiMm6oe96TgNjNF2dQdOhhoSr
         bYmvPfhQDnqduS8Vqawri5Ispdt9/tjaFA6JeYpJVow6bntK1xOaHncc1GPF3KJv/0Sw
         ZtSWAg4GsDwR4Ay8TwOMEpJwy/Um8CenKxo4i/9xtUtXziluDqDv7n1h0j/TF4oabuGq
         kUumM1JNdGgxj+P4K3QyEUazwskQmw1Pwg5F+yPo4OGwlvixAutHcP4grbSlEtd5IoQd
         ZQNw==
X-Gm-Message-State: ACrzQf2rO663xozRtF/wd53ZmLWlEcZTA3wlZbichDAClOVVtPromkN2
        Z+kybMtZjw+G9OzX98GlTAE=
X-Google-Smtp-Source: AMsMyM5zgvkPSBXX+IVnlSujLJDxh8HsomYjzwa1p6+AVd0jfSMWxBiL0+JuZxRUpmeCgz+VZndmVQ==
X-Received: by 2002:a05:6870:4612:b0:13b:775d:511 with SMTP id z18-20020a056870461200b0013b775d0511mr6795289oao.81.1666652270682;
        Mon, 24 Oct 2022 15:57:50 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id 9-20020a9d0689000000b006618f1fbb84sm298520otx.80.2022.10.24.15.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 15:57:50 -0700 (PDT)
Date:   Mon, 24 Oct 2022 15:55:38 -0700
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
Subject: Re: [PATCH v5 1/3] sched/topology: Introduce sched_numa_hop_mask()
Message-ID: <Y1cX6ou63zHrpNx4@yury-laptop>
References: <20221021121927.2893692-1-vschneid@redhat.com>
 <20221021121927.2893692-2-vschneid@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021121927.2893692-2-vschneid@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 01:19:25PM +0100, Valentin Schneider wrote:
> Tariq has pointed out that drivers allocating IRQ vectors would benefit
> from having smarter NUMA-awareness - cpumask_local_spread() only knows
> about the local node and everything outside is in the same bucket.

Can you keep 1st-person references in a cover letter?
 
> sched_domains_numa_masks is pretty much what we want to hand out (a cpumask
> of CPUs reachable within a given distance budget), introduce
> sched_numa_hop_mask() to export those cpumasks.
> 
> Link: http://lore.kernel.org/r/20220728191203.4055-1-tariqt@nvidia.com
> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
> ---
>  include/linux/topology.h | 12 ++++++++++++
>  kernel/sched/topology.c  | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 43 insertions(+)
> 
> diff --git a/include/linux/topology.h b/include/linux/topology.h
> index 4564faafd0e12..3e91ae6d0ad58 100644
> --- a/include/linux/topology.h
> +++ b/include/linux/topology.h
> @@ -245,5 +245,17 @@ static inline const struct cpumask *cpu_cpu_mask(int cpu)
>  	return cpumask_of_node(cpu_to_node(cpu));
>  }
>  
> +#ifdef CONFIG_NUMA
> +extern const struct cpumask *sched_numa_hop_mask(int node, int hops);
> +#else
> +static inline const struct cpumask *sched_numa_hop_mask(int node, int hops)
> +{
> +	if (node == NUMA_NO_NODE && !hops)
> +		return cpu_online_mask;
> +
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +#endif	/* CONFIG_NUMA */
> +
>  
>  #endif /* _LINUX_TOPOLOGY_H */
> diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
> index 8739c2a5a54ea..e3cb8cc375204 100644
> --- a/kernel/sched/topology.c
> +++ b/kernel/sched/topology.c
> @@ -2067,6 +2067,37 @@ int sched_numa_find_closest(const struct cpumask *cpus, int cpu)
>  	return found;
>  }
>  
> +/**
> + * sched_numa_hop_mask() - Get the cpumask of CPUs at most @hops hops away from
> + *                         @node
> + * @node: The node to count hops from.
> + * @hops: Include CPUs up to that many hops away. 0 means local node.
> + *
> + * Return: On success, a pointer to a cpumask of CPUs at most @hops away from
> + * @node, an error value otherwise.
> + *
> + * Requires rcu_lock to be held. Returned cpumask is only valid within that
> + * read-side section, copy it if required beyond that.
> + *
> + * Note that not all hops are equal in distance; see sched_init_numa() for how
> + * distances and masks are handled.
> + * Also note that this is a reflection of sched_domains_numa_masks, which may change
> + * during the lifetime of the system (offline nodes are taken out of the masks).
> + */
> +const struct cpumask *sched_numa_hop_mask(unsigned int node, unsigned int hops)
> +{
> +	struct cpumask ***masks = rcu_dereference(sched_domains_numa_masks);
> +
> +	if (node >= nr_node_ids || hops >= sched_domains_numa_levels)
> +		return ERR_PTR(-EINVAL);

Can you dereference rcu things after sanity checks?

> +	if (!masks)
> +		return ERR_PTR(-EBUSY);
> +
> +	return masks[hops][node];
> +}
> +EXPORT_SYMBOL_GPL(sched_numa_hop_mask);
> +
>  #endif /* CONFIG_NUMA */
>  
>  static int __sdt_alloc(const struct cpumask *cpu_map)
> -- 
> 2.31.1
