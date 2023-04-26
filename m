Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C06736EEDB1
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 07:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239400AbjDZFvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 01:51:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239398AbjDZFvY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 01:51:24 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E615A269E;
        Tue, 25 Apr 2023 22:50:35 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1a92369761cso53035745ad.3;
        Tue, 25 Apr 2023 22:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682488226; x=1685080226;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tyDHg+l/CBccPJ14EzoCxdO4UR3Mn/BrOLjjC6CJ+24=;
        b=TWCKU5UAu/a2FrtqYY01I+hpJZonvSm2uJk02JhZix4nco8ktd2qV5uN+suv+mgBKE
         MCMDikcNTvZs3jXWH3U6H+cpaQaF5ZKfb/ON70gbUyyCp0z6uyt4lLKWF7VXPRrI0OGp
         c3RVULlufKmgji1SXgMx2WuxLaubQd660tT41FUEvWDm0bYnEbhf4BmQWjNO5ox3CEfH
         0v0iWYz+8rb9Q/rgxeh3fHZouICJFq1SybYaLaBZpQfVd9FRPNc+Jd7BROKTSSjANRLe
         uLj9c7Qzi1iSlLCUCuhRuW9+ywKeCCFtegGDLwEyHjs9r60MSOMVCaJc3nLfGMbfVZwS
         UFxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682488226; x=1685080226;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tyDHg+l/CBccPJ14EzoCxdO4UR3Mn/BrOLjjC6CJ+24=;
        b=ktAtZ48AtJbi4YhniiB9CPWwsxm212yRgAdDtTVNkI5WRx+HYMZ2bStJKdLPNFRLXN
         XCCz4QT60UyV9rxlsKx/IUhoYydZTrKcuHREyFB5scp25LDE9YDJq9cTUktHyCFVrVMY
         NAjE2FHvxGDHPgPirs/2uwjbjogLySn5hLfEJ4muMRgLlKeXfgACQmc5FklHEspcjQVW
         F+BAX9JBaQKcZiezosPp6txxCGFihtL2qygIytuIU9X1IxR52H7sP7aT9MwMo/3J5iu3
         JHOG/i7RKLSw/NvdJxAzxL8rWFyJI/bEIYoTRdNAlqtwrg6dpkdvgJTuXaE393gnfVm1
         4ntg==
X-Gm-Message-State: AAQBX9fk3FnoCX/uQlNsNTsHxhngDR+5UGAUTtkLuubPTHjfbL3tvsQh
        bHzkwfapPa0SWGZdU7MmKsM=
X-Google-Smtp-Source: AKy350axHObaPbqnDo4sJmE58+P6WyJ8EC4Q/mzVqNZJwg6EQKnCWKCFzkgatUEhAYDneB7uPaPhoQ==
X-Received: by 2002:a17:903:8c7:b0:1a0:5349:6606 with SMTP id lk7-20020a17090308c700b001a053496606mr20348126plb.56.1682488226283;
        Tue, 25 Apr 2023 22:50:26 -0700 (PDT)
Received: from localhost ([216.228.127.128])
        by smtp.gmail.com with ESMTPSA id d2-20020a170902654200b00192aa53a7d5sm9158834pln.8.2023.04.25.22.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 22:50:25 -0700 (PDT)
Date:   Tue, 25 Apr 2023 22:50:23 -0700
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
Message-ID: <ZEi7n4ZJgF2o8Ps9@yury-ThinkPad>
References: <20230420051946.7463-1-yury.norov@gmail.com>
 <20230420051946.7463-8-yury.norov@gmail.com>
 <xhsmh8rehkxzz.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xhsmh8rehkxzz.mognet@vschneid.remote.csb>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Valentin,

Thanks for review!

On Mon, Apr 24, 2023 at 06:09:52PM +0100, Valentin Schneider wrote:
> On 19/04/23 22:19, Yury Norov wrote:
> > +	for (node = 0; node < sched_domains_numa_levels; node++) {
> > +		unsigned int hop, c = 0;
> > +
> > +		rcu_read_lock();
> > +		for_each_numa_cpu(cpu, hop, node, cpu_online_mask)
> > +			expect_eq_uint(cpumask_local_spread(c++, node), cpu);
> > +		rcu_read_unlock();
> > +	}
> 
> I'm not fond of the export of sched_domains_numa_levels, especially
> considering it's just there for tests.
> 
> Furthermore, is there any value is testing parity with
> cpumask_local_spread()?

I wanted to emphasize that new NUMA-aware functions are coherent with
each other, just like find_nth_bit() is coherent with find_next_bit().

But all that coherence looks important only in non-NUMA case, because
client code may depend on fact that next CPU is never less than current.
This doesn't hold for NUMA iterators anyways...

> Rather, shouldn't we check that using this API does
> yield CPUs of increasing NUMA distance?
> 
> Something like
> 
>         for_each_node(node) {
>                 unsigned int prev_cpu, hop = 0;
> 
>                 cpu = cpumask_first(cpumask_of_node(node));
>                 prev_cpu = cpu;
> 
>                 rcu_read_lock();
> 
>                 /* Assert distance is monotonically increasing */
>                 for_each_numa_cpu(cpu, hop, node, cpu_online_mask) {
>                         expect_ge_uint(cpu_to_node(cpu), cpu_to_node(prev_cpu));
>                         prev_cpu = cpu;
>                 }
> 
>                 rcu_read_unlock();
>         }

Your version of the test looks more straightforward. I need to think
for more, but it looks like I can take it in v3.

Thanks,
Yury
