Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03781626AFB
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 19:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235011AbiKLSOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 13:14:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231404AbiKLSOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 13:14:48 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4708D2CC;
        Sat, 12 Nov 2022 10:14:47 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id l15so4705387qtv.4;
        Sat, 12 Nov 2022 10:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lTFl9aWO+1SeQzS//SMRtEyeX6yINNitWAxlXrbM5e0=;
        b=bbbo8SH+J6x9hAfBQAbE6hZ1zz7YYSIoK67mg1Zzbg88jPR6zEu7EkjVBc1qe0F57c
         +KB3rtIMU7XRT9AqMnLWHRuqDX1ibzP9GDwyzHMN/nyUrvKWMQJb1gcyPRx8ZGW3fxlg
         0EfW6YTANwLb0AZAHxJl+kfJOUycnK8HDMBwSyAXu/wcZuf3cjh64gnQmsq9dkIEcCjv
         SEoZK0uzF8HvlXxEmJl9OBFEODYNapKg5ydfDdgWVenoOQDaSpxX+rImt2iMKpuc5kTe
         J/32xGw+eV6skjjPy4e8gFyHNOdKwEjPk8dYCVROPw/HdcjLmURd3JVLvUy+xcuWuV/S
         CkZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lTFl9aWO+1SeQzS//SMRtEyeX6yINNitWAxlXrbM5e0=;
        b=ZZ6A1nhSHIkvyjWCNhROVauK6CFdbadequxd27C+8Vd8fwznu1p2X78rqOn/okRoDk
         Muu4guqeEWT22NHJo10BaGHWtdzQkEyrmrlXQkJAOodbVLejO7cVzw9Sdb/yycws26OJ
         j7LoZCZX5aSIZ6uktM/hlb4uIJZJ48d04zOUe5DbsRA6DyYGT+zhvLrKAQXtdCQw9aAg
         YP7KAv0uCnYWnd0/cdk3wM1rvB9UnMfx/HlUJRGtaFAWiG+PfCk0bBOBTEcxz51vxZ7K
         FSMhcdorIbb8bcIa+A9UO3Lr8yEa1rlcWETptPyOyE9g3BKKxFfOD/D41X3flKKBqinp
         0MiQ==
X-Gm-Message-State: ANoB5pkmrsEoBCBYFVaE/DVlrPGj9SeJte/G4rt3I4UKhbXoZwMTLDIM
        qTlDG3xjAQYi9Mqvu1ipKvI=
X-Google-Smtp-Source: AA0mqf4/q4Hw65EwDHaphX2lo7UTuol94xx3giPYnaMAfBF3nTZv23iAvlSLMuR6lJyj40BtXMjPcA==
X-Received: by 2002:ac8:5043:0:b0:3a5:c55a:72c4 with SMTP id h3-20020ac85043000000b003a5c55a72c4mr6261313qtm.223.1668276886174;
        Sat, 12 Nov 2022 10:14:46 -0800 (PST)
Received: from localhost (user-24-236-74-177.knology.net. [24.236.74.177])
        by smtp.gmail.com with ESMTPSA id z9-20020ac81009000000b0039cd4d87aacsm3092459qti.15.2022.11.12.10.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Nov 2022 10:14:45 -0800 (PST)
Date:   Sat, 12 Nov 2022 10:14:45 -0800
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
Message-ID: <Y2/ilckO8Wj9uAPq@yury-laptop>
References: <20221111040027.621646-1-yury.norov@gmail.com>
 <20221111040027.621646-4-yury.norov@gmail.com>
 <Y241Jd+27r/ZIiji@smile.fi.intel.com>
 <Y26BQ92l9xWKaz2z@yury-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y26BQ92l9xWKaz2z@yury-laptop>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 09:07:17AM -0800, Yury Norov wrote:
> On Fri, Nov 11, 2022 at 01:42:29PM +0200, Andy Shevchenko wrote:
> > On Thu, Nov 10, 2022 at 08:00:26PM -0800, Yury Norov wrote:
> > > +	int w, ret = nr_cpu_ids;
> > > +
> > > +	rcu_read_lock();
> > > +	masks = rcu_dereference(sched_domains_numa_masks);
> > > +	if (!masks)
> > > +		goto out;
> > > +
> > > +	while (last >= first) {
> > > +		mid = (last + first) / 2;
> > > +
> > > +		if (cpumask_weight_and(cpus, masks[mid][node]) <= cpu) {
> > > +			first = mid + 1;
> > > +			continue;
> > > +		}
> > > +
> > > +		w = (mid == 0) ? 0 : cpumask_weight_and(cpus, masks[mid - 1][node]);
> > 
> > See below.
> > 
> > > +		if (w <= cpu)
> > > +			break;
> > > +
> > > +		last = mid - 1;
> > > +	}
> > 
> > We have lib/bsearch.h. I haven't really looked deeply into the above, but my
> > gut feelings that that might be useful here. Can you check that?
> 
> Yes we do. I tried it, and it didn't work because nodes arrays are
> allocated dynamically, and distance between different pairs of hops
> for a given node is not a constant, which is a requirement for
> bsearch.
> 
> However, distance between hops pointers in 1st level array should be
> constant, and we can try feeding bsearch with it. I'll experiment with
> bsearch for more.

OK, I tried bsearch on array of hops, and it works. But it requires
adding some black pointers magic. I'll send v2 based on bsearch soon.

Thanks,
Yury
