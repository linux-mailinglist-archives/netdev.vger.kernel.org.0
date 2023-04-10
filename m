Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1BF6DCA4D
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 20:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjDJSAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 14:00:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjDJSAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 14:00:31 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB9A173B;
        Mon, 10 Apr 2023 11:00:30 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id j8so3586690pjy.4;
        Mon, 10 Apr 2023 11:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681149630; x=1683741630;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IV33xBJ34yY7yL7GA0OE+66nFcSLRJs2V5SHArKgYcw=;
        b=aoRYjh4Ii+DhcP9USwhs2qrv1CjEdbxNmI9u/NaVcRTGTbojD/jNjhc3O7ZdbbD/Q9
         P9x8DzRviQ1xw3ijKKBqhcnUXE11kAK1YlfgMmhzOkT6zltq8XfSmwnbjU4KY714GIYw
         GqBhPyxBnEBUNCvdEa1QnsV9uTsHt1GktXG+iYC+Pod2AQBCMAtBCPBmy+ax9lLTN1Nu
         hlXdFKeCR+bmSeUOUgaMBv1cuCmKM/87mgQRhBSahpkVv9+hTkUDsyWTqaIez4hLFGPV
         kMlhTxeFi96MDkY4YGvGGHc3EmRPKuZIJC+cApusatF7M2C3Bv4tv+7ZoG+5+mPXMBGD
         VkkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681149630; x=1683741630;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IV33xBJ34yY7yL7GA0OE+66nFcSLRJs2V5SHArKgYcw=;
        b=Jtwk5GKvhlaINjEvMfP8yXVB9lRM7X1MuYJLwAFsqGGPO8Yprgw0v6XJdgZCrEAucQ
         WKDt+YclA4egnhB7jEkbryNhDB1en5QAyzq8q5c6mGvRw3/PMuMSktMrbwO54ys0bBvm
         NKta6xL8nRRPnyEm/swyc9YJVJSUqMlSLVsWGrdnp/sk3bg2kpnzxeNLtWRtUbkAQPef
         +cl8Q9dpJxUIvKnjG5+MXtLpJhfC12Dk0sG5YYt082gccaZw6B0Q8G+HVmAJBgWJv3z5
         CNUEnvX9CIWK1TyvCORygEHlnMbrC9NW8k3Xn30mlTq+0+jd/Po++WSjz8vYeVFq55E2
         wVXQ==
X-Gm-Message-State: AAQBX9d/CpC2OydveEAdLn3rtcmzwsYqu36TWsHaYDJ+81EMu1iEE0/i
        8upKEaZdbVDA2YXWTxNL0A9u/Ht27Sg=
X-Google-Smtp-Source: AKy350b3uYuhvmpWVUIpVtZI0gqCwySA0fm3SARAAz//DMwRmDHNYP6qdC/3hmAvZUJjxd5kWB1rBQ==
X-Received: by 2002:a05:6a20:4da1:b0:cd:74aa:df55 with SMTP id gj33-20020a056a204da100b000cd74aadf55mr11989045pzb.25.1681149629777;
        Mon, 10 Apr 2023 11:00:29 -0700 (PDT)
Received: from localhost ([216.228.127.130])
        by smtp.gmail.com with ESMTPSA id k24-20020aa78218000000b005921c46cbadsm8342466pfi.99.2023.04.10.11.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 11:00:29 -0700 (PDT)
Date:   Mon, 10 Apr 2023 11:00:28 -0700
From:   Yury Norov <yury.norov@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Pawel Chmielewski <pawel.chmielewski@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
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
Subject: Re: [PATCH 2/8] sched/topology: introduce sched_numa_find_next_cpu()
Message-ID: <ZDROvNNIPdahL3AP@yury-laptop>
References: <20230325185514.425745-1-yury.norov@gmail.com>
 <20230325185514.425745-3-yury.norov@gmail.com>
 <ZCFvvHZXT/dqjOOb@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCFvvHZXT/dqjOOb@smile.fi.intel.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 01:28:12PM +0300, Andy Shevchenko wrote:
> On Sat, Mar 25, 2023 at 11:55:08AM -0700, Yury Norov wrote:
> > The function searches for the next CPU in a given cpumask according to
> > NUMA topology, so that it traverses cpus per-hop.
> > 
> > If the CPU is the last cpu in a given hop, sched_numa_find_next_cpu()
> > switches to the next hop, and picks the first CPU from there, excluding
> > those already traversed.
> 
> ...
> 
> > +/*
> 
> Hmm... Is it deliberately not a kernel doc?

Yes, I'd prefer to encourage people to use for_each() approach instead
of calling it directly.

If there will be a good reason to make it a more self-consistent thing,
we'll have to add a wrapper, just like sched_numa_find_nth_cpu() is
wrapped with cpumask_local_spread(). Particularly, use RCU lock/unlock
and properly handle NUMA_NO_NODE.
 
> > + * sched_numa_find_next_cpu() - given the NUMA topology, find the next cpu
> > + * cpumask: cpumask to find a cpu from
> > + * cpu: current cpu
> > + * node: local node
> > + * hop: (in/out) indicates distance order of current CPU to a local node
> > + *
> > + * The function searches for next cpu at a given NUMA distance, indicated
> > + * by hop, and if nothing found, tries to find CPUs at a greater distance,
> > + * starting from the beginning.
> > + *
> > + * returns: cpu, or >= nr_cpu_ids when nothing found.
> > + */
> 
> -- 
> With Best Regards,
> Andy Shevchenko
> 
