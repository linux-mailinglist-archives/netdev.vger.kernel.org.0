Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0206DCA58
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 20:05:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjDJSF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 14:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjDJSFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 14:05:25 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515041BCE;
        Mon, 10 Apr 2023 11:05:23 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id 20so7138863plk.10;
        Mon, 10 Apr 2023 11:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681149922; x=1683741922;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BDFq1y3F8viINpXVlwTLfAnP5qiEXoQlHVJuS9HDArY=;
        b=bKQXub+9dep0EKbz2N4iq0b5oiw3VF4S4XQdeCJJItf03sJjABhRb20GZJrHcxgX/x
         9P2PVe4QRgKWoGwuD6DIeMfvsLE2U0rgoQwckX9Ceow/wZh33M80Qwf9IULoRmn6lY4G
         B1tmZjBcLSA0NJ/qq/ZHB6Vz48eSOcLCQrGPRwm4/Z5KlpMW2P3YsjENuF8Zwjm75BaF
         ItEeOJRi/8Ivjn2Pt2ofDmstgJ2/CoMPSgnzEF4mHEfITQQno4bB8fzZULbOoiB1odDZ
         6JhhNR+C9q779EVFKosXg2PxSL+DRY0SiamDjcHx+3mOoi23FaY/mmF/KhcpTxeBa0SF
         l3Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681149922; x=1683741922;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BDFq1y3F8viINpXVlwTLfAnP5qiEXoQlHVJuS9HDArY=;
        b=MLR3JWWAovSdUQ7ajmz++bWHYc5mjtvgmspLxH7PZuyNsVIqPWBBdEzSKK2YOIG4rp
         ueVLWH5G64ky3zC8YMw+9cqjTAaA+5+bWlamMj4g86+KrUxVoif5a5j/FJjQOxVP6Pat
         B2mASfsMHCA2z+iSyCiEheC+qbLi8MnIJKqc4cb7O76WnFgjGcedYMITe5Zqg0ngB8p9
         iHIF9JI6alJzjjCh35jyFurZ0WSBtjU2BXlgDDtYs5lJ+JDtMWTMFITClDdz1W6lJPM2
         SjeWDnkO7P237xIWiTTwqAISMNQEESHCWMjRBRVoNL/zrMihinrhsAYMmINEOedoH1Z+
         C0Nw==
X-Gm-Message-State: AAQBX9fxlboEzu/lIDLtnVTffWAloAY8XUfKCI4wNJWzfHyP7RYJ9NkS
        VgbPY4W73oEtt9t9RpKHfNM=
X-Google-Smtp-Source: AKy350aO+8hq94hLZtaMkIoAG2sn/MnGR4aUyS9JLnfMt75ct/F0HJeKLfNBnZf339atMk2kndBKUA==
X-Received: by 2002:a17:903:185:b0:19c:f476:4793 with SMTP id z5-20020a170903018500b0019cf4764793mr14622227plg.51.1681149922535;
        Mon, 10 Apr 2023 11:05:22 -0700 (PDT)
Received: from localhost ([216.228.127.130])
        by smtp.gmail.com with ESMTPSA id q1-20020a170902b10100b001a505f04a06sm7382192plr.190.2023.04.10.11.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 11:05:22 -0700 (PDT)
Date:   Mon, 10 Apr 2023 11:05:20 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Pawel Chmielewski <pawel.chmielewski@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Barry Song <baohua@kernel.org>
Subject: Re: [PATCH 3/8] sched/topology: add for_each_numa_cpu() macro
Message-ID: <ZDRP4KHfa9ptGe3X@yury-laptop>
References: <20230325185514.425745-1-yury.norov@gmail.com>
 <20230325185514.425745-4-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230325185514.425745-4-yury.norov@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 25, 2023 at 11:55:09AM -0700, Yury Norov wrote:
> for_each_cpu() is widely used in the kernel, and it's beneficial to
> create a NUMA-aware version of the macro.
> 
> Recently added for_each_numa_hop_mask() works, but switching existing
> codebase to it is not an easy process.
> 
> New for_each_numa_cpu() is designed to be similar to the for_each_cpu().
> It allows to convert existing code to NUMA-aware as simple as adding a
> hop iterator variable and passing it inside new macro. for_each_numa_cpu()
> takes care of the rest.
> 
> At the moment, we have 2 users of NUMA-aware enumerators. One is
> Melanox's in-tree driver, and another is Intel's in-review driver:
> 
> https://lore.kernel.org/lkml/20230216145455.661709-1-pawel.chmielewski@intel.com/
> 
> Both real-life examples follow the same pattern:
> 
> 	for_each_numa_hop_mask(cpus, prev, node) {
>  		for_each_cpu_andnot(cpu, cpus, prev) {
>  			if (cnt++ == max_num)
>  				goto out;
>  			do_something(cpu);
>  		}
> 		prev = cpus;
>  	}
> 
> With the new macro, it would look like this:
> 
> 	for_each_numa_cpu(cpu, hop, node, cpu_possible_mask) {
> 		if (cnt++ == max_num)
> 			break;
> 		do_something(cpu);
>  	}
> 
> Straight conversion of existing for_each_cpu() codebase to NUMA-aware
> version with for_each_numa_hop_mask() is difficult because it doesn't
> take a user-provided cpu mask, and eventually ends up with open-coded
> double loop. With for_each_numa_cpu() it shouldn't be a brainteaser.
> Consider the NUMA-ignorant example:
> 
> 	cpumask_t cpus = get_mask();
> 	int cnt = 0, cpu;
> 
> 	for_each_cpu(cpu, cpus) {
> 		if (cnt++ == max_num)
> 			break;
> 		do_something(cpu);
>  	}
> 
> Converting it to NUMA-aware version would be as simple as:
> 
> 	cpumask_t cpus = get_mask();
> 	int node = get_node();
> 	int cnt = 0, hop, cpu;
> 
> 	for_each_numa_cpu(cpu, hop, node, cpus) {
> 		if (cnt++ == max_num)
> 			break;
> 		do_something(cpu);
>  	}
> 
> The latter looks more verbose and avoids from open-coding that annoying
> double loop. Another advantage is that it works with a 'hop' parameter with
> the clear meaning of NUMA distance, and doesn't make people not familiar
> to enumerator internals bothering with current and previous masks machinery.
> 
> Signed-off-by: Yury Norov <yury.norov@gmail.com>
> ---
>  include/linux/topology.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/include/linux/topology.h b/include/linux/topology.h
> index 4a63154fa036..62a9dd8edd77 100644
> --- a/include/linux/topology.h
> +++ b/include/linux/topology.h
> @@ -286,4 +286,24 @@ sched_numa_hop_mask(unsigned int node, unsigned int hops)
>  	     !IS_ERR_OR_NULL(mask);					       \
>  	     __hops++)
>  
> +/**
> + * for_each_numa_cpu - iterate over cpus in increasing order taking into account
> + *		       NUMA distances from a given node.
> + * @cpu: the (optionally unsigned) integer iterator
> + * @hop: the iterator variable, must be initialized to a desired minimal hop.
> + * @node: the NUMA node to start the search from.
> + *
> + * Requires rcu_lock to be held.

The comments below are incorrect (copy-paste error). I'll remove them in v2.

> + *
> + * Because it's implemented as double-loop, using 'break' inside the body of
> + * iterator may lead to undefined behaviour. Use 'goto' instead.
> + *
> + * Yields intersection of @mask and cpu_online_mask if @node == NUMA_NO_NODE.
> + */
> +#define for_each_numa_cpu(cpu, hop, node, mask)					\
> +	for ((cpu) = 0, (hop) = 0;						\
> +		(cpu) = sched_numa_find_next_cpu((mask), (cpu), (node), &(hop)),\
> +		(cpu) < nr_cpu_ids;						\
> +		(cpu)++)
> +
>  #endif /* _LINUX_TOPOLOGY_H */
> -- 
> 2.34.1
