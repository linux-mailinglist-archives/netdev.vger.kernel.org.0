Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A156EFBEF
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 22:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239315AbjDZUvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 16:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbjDZUvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 16:51:46 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936AA19F;
        Wed, 26 Apr 2023 13:51:40 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 3f1490d57ef6-b990eb5dc6bso10664191276.3;
        Wed, 26 Apr 2023 13:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682542299; x=1685134299;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BmAaRztn7L2EnPrEsEaVR3r6ykpBZdxw7qk/BsB3FWQ=;
        b=ieCdrTcg/TQkpZiHQ4R4QmxNI1LxseZanWujQPB5grbRVQr7fHRRtB7cOIHzMq6wCA
         dBsixg4YQQnx31ycVcShjTqT5T2yH3rrrDhONLOQvrBadY4Mbrw6hc+7ADrhCqx2UvLJ
         +cWrqWwHVeKBUKlDFWNiHA+Q/0YW7AQE3myqgBKbn7GpzZ2M067JQVzzJxGHEbCVDqXW
         C0c/Iqojex0nEhjjVMPY2JQsWOBdEB8C+9TXtRqmdE/WSyr1nQfhdag7jL1CepnhplJZ
         5g9lwYU6ZCPheTTLsg1N5QqMzm92KnkLKsbxT+Q1uEO9TJNPNv4w+aTwxjouDZlxfjhR
         OYKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682542299; x=1685134299;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BmAaRztn7L2EnPrEsEaVR3r6ykpBZdxw7qk/BsB3FWQ=;
        b=ZDwtjLKrZdZetLbtKkQct3+BLM2WZ4+UrOAzaE9gCAd7CTIOpe1bpBBg6L7x+Vx6q3
         Lm/Ncz60L9dKbaxZA28LyP5ICLktRjuWXGD/0GRQMor+gANes31R+dcHkQFQj5WcFxYk
         3Bsly4Gy3vdwSzYHkTOp2YXwLb9GhSpwY0wuA5F3V+wGkSN6XWNR0nuVfod63UVZmtov
         r/nx/UJrDnG3k43ai+r3llC2aYNkERVzpoyT0leWLNekM2fBDutJUIq8EIIRTgZOuK/Q
         pUmoQ1plXOGyb4am++8Uq/UmwS0ToqnOh06DGSW6+XtmRtHzUzqhoVIp+hKrTcjJh1FW
         r1zQ==
X-Gm-Message-State: AAQBX9eNHSZd86JOcb+hP5iTCt5mcr4v0oYNnaSxi4qrrg6e2x+/ynTY
        lofA0d0dFhGyPKW9mKNmzoU=
X-Google-Smtp-Source: AKy350ZTZ/sugYQnq20BuFChg+d7AKiJuoC8Jk7fRZFSym0PBZNRnrjRHgwdGCJyCJmWxCklr1NThQ==
X-Received: by 2002:a25:ae51:0:b0:b7e:6685:84a with SMTP id g17-20020a25ae51000000b00b7e6685084amr16509680ybe.1.1682542299575;
        Wed, 26 Apr 2023 13:51:39 -0700 (PDT)
Received: from localhost ([173.25.37.163])
        by smtp.gmail.com with ESMTPSA id v7-20020a254807000000b00b8f3e224dcesm4229484yba.13.2023.04.26.13.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 13:51:39 -0700 (PDT)
Date:   Wed, 26 Apr 2023 13:51:36 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
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
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Barry Song <baohua@kernel.org>
Subject: Re: [PATCH v2 7/8] lib: add test for for_each_numa_{cpu,hop_mask}()
Message-ID: <ZEmOxpgZqyoHcMqu@yury-ThinkPad>
References: <20230420051946.7463-1-yury.norov@gmail.com>
 <20230420051946.7463-8-yury.norov@gmail.com>
 <xhsmh8rehkxzz.mognet@vschneid.remote.csb>
 <ZEi7n4ZJgF2o8Ps9@yury-ThinkPad>
 <xhsmhttx3j93u.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xhsmhttx3j93u.mognet@vschneid.remote.csb>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I realized I only wrote half the relevant code - comparing node IDs is
> meaningless, I meant to compare distances as we walk through the
> CPUs... I tested the below against a few NUMA topologies and it seems to be
> sane:
> 
> @@ -756,12 +773,23 @@ static void __init test_for_each_numa(void)
>  {
>  	unsigned int cpu, node;
>  
> -	for (node = 0; node < sched_domains_numa_levels; node++) {
> -		unsigned int hop, c = 0;
> +	for_each_node(node) {
> +		unsigned int start_cpu, prev_dist, hop = 0;
> +
> +		cpu = cpumask_first(cpumask_of_node(node));
> +		prev_dist = node_distance(node, node);
> +		start_cpu = cpu;
>  
>  		rcu_read_lock();
> -		for_each_numa_cpu(cpu, hop, node, cpu_online_mask)
> -			expect_eq_uint(cpumask_local_spread(c++, node), cpu);
> +
> +		/* Assert distance is monotonically increasing */
> +		for_each_numa_cpu(cpu, hop, node, cpu_online_mask) {
> +			unsigned int dist = node_distance(cpu_to_node(cpu), cpu_to_node(start_cpu));

Interestingly, node_distance() is an arch-specific function. Generic
implementation is quite useless:

 #define node_distance(from,to)  ((from) == (to) ? LOCAL_DISTANCE : REMOTE_DISTANCE)

Particularly, arm64 takes the above. With node_distance() implemented
like that, we can barely test something...

Taking that into the account, I think it's better to test iterator against
cpumask_local_spread(), like in v2. I'll add a comment about that in v3.

> +
> +			expect_ge_uint(dist, prev_dist);
> +			prev_dist = dist;
> +		}
> +
>  		rcu_read_unlock();
>  	}
>  }
