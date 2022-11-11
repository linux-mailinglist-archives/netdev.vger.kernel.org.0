Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19288626019
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 18:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234331AbiKKRIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 12:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234245AbiKKRHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 12:07:44 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A6B86D7F;
        Fri, 11 Nov 2022 09:07:17 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id m204so5436732oib.6;
        Fri, 11 Nov 2022 09:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AC0O3le8bk/sr0yNI25Hqpom2ujUVEBU3Z1XU45Dy38=;
        b=PPHA7iWYBy4k5/xw+dIDuuhBjUxzOJNVpMhUmMio95WxSvS1WviKVTkEaIwe8pGe1n
         m708NfylWOAXWxW+m5w6D+kz9yTYs+C8CPZhsNwWqSS0gTQF53yAQKp2JhTMsu/FC2Zr
         8kCDcR3MmDrSrogmClYcaH9TOrHLDT39/8ldoWBEUlfGXW7/mRJxdvP3EEiJbDQWT8wm
         BD+BAkKkSmZv3EngdzwauWZZa379am6LgSr4ZYtkoCZS2QDvk3Xq5scs1m57MuzWcq0W
         0GFSFo9nLBRQrTDtNzfzCRwXtPCG9J8ya0G7SyBlcyDH+TXkQqlLXqvZg7zPA1CPRYHj
         Talw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AC0O3le8bk/sr0yNI25Hqpom2ujUVEBU3Z1XU45Dy38=;
        b=CjrxNKgAFvEACqZDsPeLOnNtjQbiHj8MSn8H/OYonmy6hi9S3WSkZgkI68NFYF3sg1
         XmdqNk0cZXaP8dr5eKN89KNxAIiyj53Unv1gKRSERLAtUrj+o3MnlJgLG02ZgtZYBGuB
         sAwXRrDw3DNFJ2ej0psd5+PIKAWHBHXNGLqmGEOko7JcWjQv5lBtKHIfYqu2hD9GAwc1
         rRUeFCisbvi5Xe/ZRLLwEuNcsrMDrMxQC6rsWpAlcSOF+PmGazInzxyDOGmlXqRUjcjU
         /ZFsUWdwjmBOIiEaN8WDPCRjbVeYf78XFnbeSUKJmLASpzEuWWxDa0mp1CGFbR0Sg0FX
         3dZw==
X-Gm-Message-State: ANoB5pmPebQyUxf3ehcDZ8fpotyi+qesOItqJNC4kgXeTLfKC5v43yAF
        FCTnpgOFz7ttE420eSu35Y8=
X-Google-Smtp-Source: AA0mqf5CbL+HB7jUBweZ42GVe9TJkduoPVh3uCuHh5So5DMR3z6+gMER9JG/bLCtprd8Zn1FzP4RTA==
X-Received: by 2002:a54:400d:0:b0:359:fa2c:78c6 with SMTP id x13-20020a54400d000000b00359fa2c78c6mr1293291oie.3.1668186436179;
        Fri, 11 Nov 2022 09:07:16 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id l5-20020a056830154500b00661a33883b8sm1150722otp.71.2022.11.11.09.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 09:07:15 -0800 (PST)
Date:   Fri, 11 Nov 2022 09:07:15 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Gal Pressman <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH 3/4] sched: add sched_numa_find_nth_cpu()
Message-ID: <Y26BQ92l9xWKaz2z@yury-laptop>
References: <20221111040027.621646-1-yury.norov@gmail.com>
 <20221111040027.621646-4-yury.norov@gmail.com>
 <Y241Jd+27r/ZIiji@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y241Jd+27r/ZIiji@smile.fi.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 01:42:29PM +0200, Andy Shevchenko wrote:
> On Thu, Nov 10, 2022 at 08:00:26PM -0800, Yury Norov wrote:
> > The function finds Nth set CPU in a given cpumask starting from a given
> > node.
> > 
> > Leveraging the fact that each hop in sched_domains_numa_masks includes the
> > same or greater number of CPUs than the previous one, we can use binary
> > search on hops instead of linear walk, which makes the overall complexity
> > of O(log n) in terms of number of cpumask_weight() calls.
> 
> ...
> 
> > +int sched_numa_find_nth_cpu(const struct cpumask *cpus, int cpu, int node)
> > +{
> > +	unsigned int first = 0, mid, last = sched_domains_numa_levels;
> > +	struct cpumask ***masks;
> 
> *** ?
> Hmm... Do we really need such deep indirection?

It's 2d array of pointers, so - yes.
 
> > +	int w, ret = nr_cpu_ids;
> > +
> > +	rcu_read_lock();
> > +	masks = rcu_dereference(sched_domains_numa_masks);
> > +	if (!masks)
> > +		goto out;
> > +
> > +	while (last >= first) {
> > +		mid = (last + first) / 2;
> > +
> > +		if (cpumask_weight_and(cpus, masks[mid][node]) <= cpu) {
> > +			first = mid + 1;
> > +			continue;
> > +		}
> > +
> > +		w = (mid == 0) ? 0 : cpumask_weight_and(cpus, masks[mid - 1][node]);
> 
> See below.
> 
> > +		if (w <= cpu)
> > +			break;
> > +
> > +		last = mid - 1;
> > +	}
> 
> We have lib/bsearch.h. I haven't really looked deeply into the above, but my
> gut feelings that that might be useful here. Can you check that?

Yes we do. I tried it, and it didn't work because nodes arrays are
allocated dynamically, and distance between different pairs of hops
for a given node is not a constant, which is a requirement for
bsearch.

However, distance between hops pointers in 1st level array should be
constant, and we can try feeding bsearch with it. I'll experiment with
bsearch for more.

> > +	ret = (mid == 0) ?
> > +		cpumask_nth_and(cpu - w, cpus, masks[mid][node]) :
> > +		cpumask_nth_and_andnot(cpu - w, cpus, masks[mid][node], masks[mid - 1][node]);
> 
> You can also shorten this by inversing the conditional:
> 
> 	ret = mid ? ...not 0... : ...for 0...;

Yep, why not.

> > +out:
> 
> out_unlock: ?

Do you think it's better?

> > +	rcu_read_unlock();
> > +	return ret;
> > +}
> 
> -- 
> With Best Regards,
> Andy Shevchenko
> 
