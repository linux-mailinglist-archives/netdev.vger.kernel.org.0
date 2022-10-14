Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0A05FEA9F
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 10:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiJNIgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 04:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiJNIgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 04:36:43 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51BB17FD7F;
        Fri, 14 Oct 2022 01:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Slprap7xaXKI2R7TH/qSDvQD73vkEmgGtKblhXaDFXI=; b=ZNLYRvUol6/u3oBwXBft5BQgBe
        dXr3yxTDD+cIGy0WNSDWpV5gUI3BZekpnIMDH7THnPy72C+fCpbGdBHKn6KCqty0R6GqCI6EmWSAE
        g1poDXHneX32NChnC7uItzNG4FsQrIv8439paJOj1h/GzwtayaEtDm5cYlYNHhRp/0rD0V82UucsZ
        OIg6AdkrDvakeMqNqP3pyp76ovHOSNaagDppjpyI3nfqI1KnA1Jx/WBqwI9fbOUomcKoOMlT+Jtvf
        a7pMcBxqbb/7kjd0n+svktHQRgJRL6S6rXCJjjb8ewkLxiCeHmcU16/VKkThyfOlZYwLuA6tkibe2
        9Gdo1TfQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ojGB1-003Mj7-V1; Fri, 14 Oct 2022 08:36:20 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 64F8C30012F;
        Fri, 14 Oct 2022 10:36:19 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 462C6203DBB33; Fri, 14 Oct 2022 10:36:19 +0200 (CEST)
Date:   Fri, 14 Oct 2022 10:36:19 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Leonardo Bras <leobras@redhat.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Phil Auld <pauld@redhat.com>,
        Antoine Tenart <atenart@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Wang Yufen <wangyufen@huawei.com>, mtosatti@redhat.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        fweisbec@gmail.com
Subject: Re: [PATCH v2 3/4] sched/isolation: Add HK_TYPE_WQ to isolcpus=domain
Message-ID: <Y0kfgypRPdJYrvM3@hirez.programming.kicks-ass.net>
References: <20221013184028.129486-1-leobras@redhat.com>
 <20221013184028.129486-4-leobras@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013184028.129486-4-leobras@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


+ Frederic; who actually does most of this code

On Thu, Oct 13, 2022 at 03:40:28PM -0300, Leonardo Bras wrote:
> Housekeeping code keeps multiple cpumasks in order to keep track of which
> cpus can perform given housekeeping category.
> 
> Every time the HK_TYPE_WQ cpumask is checked before queueing work at a cpu
> WQ it also happens to check for HK_TYPE_DOMAIN. So It can be assumed that
> the Domain isolation also ends up isolating work queues.
> 
> Delegating current HK_TYPE_DOMAIN's work queue isolation to HK_TYPE_WQ
> makes it simpler to check if a cpu can run a task into an work queue, since
> code just need to go through a single HK_TYPE_* cpumask.
> 
> Make isolcpus=domain aggregate both HK_TYPE_DOMAIN and HK_TYPE_WQ, and
> remove a lot of cpumask_and calls.
> 
> Also, remove a unnecessary '|=' at housekeeping_isolcpus_setup() since we
> are sure that 'flags == 0' here.
> 
> Signed-off-by: Leonardo Bras <leobras@redhat.com>

I've long maintained that having all these separate masks is daft;
Frederic do we really need that?

> ---
>  drivers/pci/pci-driver.c | 13 +------------
>  kernel/sched/isolation.c |  4 ++--
>  kernel/workqueue.c       |  1 -
>  net/core/net-sysfs.c     |  1 -
>  4 files changed, 3 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 107d77f3c8467..550bef2504b8d 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -371,19 +371,8 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
>  	    pci_physfn_is_probed(dev)) {
>  		cpu = nr_cpu_ids;
>  	} else {
> -		cpumask_var_t wq_domain_mask;
> -
> -		if (!zalloc_cpumask_var(&wq_domain_mask, GFP_KERNEL)) {
> -			error = -ENOMEM;
> -			goto out;
> -		}
> -		cpumask_and(wq_domain_mask,
> -			    housekeeping_cpumask(HK_TYPE_WQ),
> -			    housekeeping_cpumask(HK_TYPE_DOMAIN));
> -
>  		cpu = cpumask_any_and(cpumask_of_node(node),
> -				      wq_domain_mask);
> -		free_cpumask_var(wq_domain_mask);
> +				      housekeeping_cpumask(HK_TYPE_WQ));
>  	}
>  
>  	if (cpu < nr_cpu_ids)
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index 373d42c707bc5..ced4b78564810 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -204,7 +204,7 @@ static int __init housekeeping_isolcpus_setup(char *str)
>  
>  		if (!strncmp(str, "domain,", 7)) {
>  			str += 7;
> -			flags |= HK_FLAG_DOMAIN;
> +			flags |= HK_FLAG_DOMAIN | HK_FLAG_WQ;
>  			continue;
>  		}
>  
> @@ -234,7 +234,7 @@ static int __init housekeeping_isolcpus_setup(char *str)
>  
>  	/* Default behaviour for isolcpus without flags */
>  	if (!flags)
> -		flags |= HK_FLAG_DOMAIN;
> +		flags = HK_FLAG_DOMAIN | HK_FLAG_WQ;
>  
>  	return housekeeping_setup(str, flags);
>  }
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 7cd5f5e7e0a1b..b557daa571f17 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -6004,7 +6004,6 @@ void __init workqueue_init_early(void)
>  
>  	BUG_ON(!alloc_cpumask_var(&wq_unbound_cpumask, GFP_KERNEL));
>  	cpumask_copy(wq_unbound_cpumask, housekeeping_cpumask(HK_TYPE_WQ));
> -	cpumask_and(wq_unbound_cpumask, wq_unbound_cpumask, housekeeping_cpumask(HK_TYPE_DOMAIN));
>  
>  	pwq_cache = KMEM_CACHE(pool_workqueue, SLAB_PANIC);
>  
> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index 8409d41405dfe..7b6fb62a118ab 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -852,7 +852,6 @@ static ssize_t store_rps_map(struct netdev_rx_queue *queue,
>  	}
>  
>  	if (!cpumask_empty(mask)) {
> -		cpumask_and(mask, mask, housekeeping_cpumask(HK_TYPE_DOMAIN));
>  		cpumask_and(mask, mask, housekeeping_cpumask(HK_TYPE_WQ));
>  		if (cpumask_empty(mask)) {
>  			free_cpumask_var(mask);
> -- 
> 2.38.0
> 
