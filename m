Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706685ECCEE
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 21:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbiI0Tck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 15:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiI0Tch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 15:32:37 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8268100AB5;
        Tue, 27 Sep 2022 12:32:35 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id g130so12967613oia.13;
        Tue, 27 Sep 2022 12:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=oQDB9ct+qcAHJxoPKciYt0KcH1qS6YXsLDiNCEzbRiU=;
        b=YkK8eKUyATrybs1Dvj+mQMo+kILtrulVIzHK3TvMPyP7S0bwRRLWcqjjvUIyL9wGhl
         /otqKCVoHdVE8dT5Vvl0x8HtSDi+hZv0VFi0DhZYwkLKfUF6khMcl4u3SLgT19Uu7sVT
         pL0zKPJvdU0/b/bcbL+utKDQVbiBYdq3HK1IYqZ8ugm9vNXOoz7o2mBJX6NMDr9cjaUP
         ZPDXuLQh3W1fGYpEF3+Lbm9Qbe4FazP6lIaWN916cVmIIJw3kSKXT3YGKb6vIJ08IK2S
         j04huKfgTpVnDS8XOcj2WYlYsaEdA5sb0/FEI4Nbpq8N5CajxLmp6szh1acD4R9S7aVM
         6Jig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=oQDB9ct+qcAHJxoPKciYt0KcH1qS6YXsLDiNCEzbRiU=;
        b=FT1mLrkSZSdr882l3PZdgVFoilxtA0viIwJhR7oQTAN3zgJ6irG95MPkPjXtLqEX/s
         6cn0NaBD1wCctir0NN4epsw0/b72ggaNQEcB9wOU9yFZYLDDIAXCRqvge3ySbXLarC3a
         i7NfPSWGM3ytME5EeTug0HhHlbQYogUXrMGZKLEYTSwsIlESQ7rH7Zbc0B8mVrJJ80JS
         DQaTBCnaXH2EJTZxz0SwPGWSTuiP1f0TFiX6ezgwoP1fYbwuv864Esw+ftTdkMl+PGRi
         GcMs8Wv5G/ugj8VHgoTqCV19z5ErXIyTg18YsOH19QNClWOXg7aNc0FUxkewBjYbeFPY
         nRrw==
X-Gm-Message-State: ACrzQf0pIGDDIfM5oaNfJI22rF4uNc6H50mVPULEW7UV8fdRbQzKd3Qf
        /ptPUOwdsPPkvacXUvegx+E=
X-Google-Smtp-Source: AMsMyM6MLJx13cfLn3Piy+OvO/YEbicJ4DfOEex1bdl+6Y9GVLKIloVORSvGT/yzTuMICfsoHgIQJA==
X-Received: by 2002:a05:6808:190f:b0:350:ae4d:dd67 with SMTP id bf15-20020a056808190f00b00350ae4ddd67mr2559858oib.202.1664307154781;
        Tue, 27 Sep 2022 12:32:34 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id t84-20020acaaa57000000b0034fc91dbd7bsm938163oie.58.2022.09.27.12.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 12:32:34 -0700 (PDT)
Date:   Tue, 27 Sep 2022 12:30:23 -0700
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
Message-ID: <YzNPTwVKb7ssrH01@yury-laptop>
References: <20220923132527.1001870-1-vschneid@redhat.com>
 <20220923155542.1212814-4-vschneid@redhat.com>
 <YzBtH8s98eTmxaJo@yury-laptop>
 <xhsmhh70s4vhl.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xhsmhh70s4vhl.mognet@vschneid.remote.csb>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 05:45:10PM +0100, Valentin Schneider wrote:
> On 25/09/22 08:00, Yury Norov wrote:
> > On Fri, Sep 23, 2022 at 04:55:40PM +0100, Valentin Schneider wrote:
> >> +/**
> >> + * sched_numa_hop_mask() - Get the cpumask of CPUs at most @hops hops away.
> >> + * @node: The node to count hops from.
> >> + * @hops: Include CPUs up to that many hops away. 0 means local node.
> >> + *
> >> + * Requires rcu_lock to be held. Returned cpumask is only valid within that
> >> + * read-side section, copy it if required beyond that.
> >> + *
> >> + * Note that not all hops are equal in distance; see sched_init_numa() for how
> >> + * distances and masks are handled.
> >> + *
> >> + * Also note that this is a reflection of sched_domains_numa_masks, which may change
> >> + * during the lifetime of the system (offline nodes are taken out of the masks).
> >> + */
> >
> > Since it's exported, can you declare function parameters and return
> > values properly?
> >
> 
> I'll add a bit about the return value; what is missing for the parameters?

My bad, scratch this.
