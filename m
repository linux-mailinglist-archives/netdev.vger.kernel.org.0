Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185C762A15B
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 19:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiKOSdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 13:33:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKOSc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 13:32:58 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57741E721;
        Tue, 15 Nov 2022 10:32:57 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id c15so9266752qtw.8;
        Tue, 15 Nov 2022 10:32:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ed0lFBOrsy+uYXuj7c2RkD6jUi2Vk7diKbHkFLe1HcY=;
        b=n1dJCa7tYLJ3cGFZBNQO095b2PM74OHihOgNuOGhGjkW8JJ5zBbZkWP90flM3pfUi6
         REaTl/XEpk3CBAsLhAosw2oOKURDW6DZY/BCiQ0rFN6GxpKNeywaxjFbUhB5rvCyJiqR
         +WqF/GHC1tFf8qM5smwycm3BlfyXAzRwdK2GAJxn8E4tE7GIhj3Y2GWIPh0nDigsFpGJ
         nOJwn33eI6l0nbVYH7dzC1TrWRWQdVX6Fqia0kulP7TxDSHsqb2disGShkbv7gzY1Yn/
         VLKGvdAW6aDdts5JmCkTfjzzISgnkZeFpX/u+ap/GnDEDVB91Cf+1FAMK50Gxzh3NcOM
         Oepw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ed0lFBOrsy+uYXuj7c2RkD6jUi2Vk7diKbHkFLe1HcY=;
        b=b8ap//FiKcZezGI4CfEqnbJirHBpr4F31bGgVrp934sW9VOmkwqdpbkeAxTPhhQvbM
         zYeCgqSszd4+8WgHWMV6cmhxHe0jcOZZRgoBGkjbzlIA/iktN5A4aM+SxyqsGWq4c7XU
         45IrZrNpUODo+1nymWKNDZ7wJ6e0tAs9b/KxR8PTJnco66lf25RaIabV5se7elG8cCxk
         8OTbpVOhpZDDdobxnlKIHTkvHhFIoSbJhlti9v/aoONvQrraIOgiZUrsct5JRakmldnB
         vAYl83anESksTXBnK0pRQ35Bzj/+7/Q6P48QhNSBvfrPULAy6WBgO1pZ4hQtEKpxPLun
         j7+w==
X-Gm-Message-State: ANoB5pn+KlRhTC36g0lKx1N4K9Mbps+2MoYvawZF0ee/CfzlGC9z6egQ
        GlVhZtjiAZKPHez1sUM95dY=
X-Google-Smtp-Source: AA0mqf5y+6IE9CH+MFP1uJCVAAiqhugIhJFD+pcOVEmT634IOkf37MQlFcKoMgziwK5MKDeNF/d44w==
X-Received: by 2002:a05:622a:a17:b0:39c:c0b1:be5b with SMTP id bv23-20020a05622a0a1700b0039cc0b1be5bmr17721118qtb.663.1668537157141;
        Tue, 15 Nov 2022 10:32:37 -0800 (PST)
Received: from localhost ([24.236.74.177])
        by smtp.gmail.com with ESMTPSA id g6-20020a05620a40c600b006fa12a74c53sm8734899qko.61.2022.11.15.10.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 10:32:36 -0800 (PST)
Date:   Tue, 15 Nov 2022 10:32:31 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Valentin Schneider <vschneid@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        Ben Segall <bsegall@google.com>,
        haniel Bristot de Oliveira <bristot@redhat.com>,
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
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 0/4] cpumask: improve on cpumask_local_spread()
 locality
Message-ID: <Y3PXw8Hqn+RCMg2J@yury-laptop>
References: <20221112190946.728270-1-yury.norov@gmail.com>
 <xhsmh7czwyvtj.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xhsmh7czwyvtj.mognet@vschneid.remote.csb>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 05:24:56PM +0000, Valentin Schneider wrote:
> Hi,
> 
> On 12/11/22 11:09, Yury Norov wrote:
> > cpumask_local_spread() currently checks local node for presence of i'th
> > CPU, and then if it finds nothing makes a flat search among all non-local
> > CPUs. We can do it better by checking CPUs per NUMA hops.
> >
> > This series is inspired by Tariq Toukan and Valentin Schneider's "net/mlx5e:
> > Improve remote NUMA preferences used for the IRQ affinity hints"
> >
> > https://patchwork.kernel.org/project/netdevbpf/patch/20220728191203.4055-3-tariqt@nvidia.com/
> >
> > According to their measurements, for mlx5e:
> >
> >         Bottleneck in RX side is released, reached linerate (~1.8x speedup).
> >         ~30% less cpu util on TX.
> >
> > This patch makes cpumask_local_spread() traversing CPUs based on NUMA
> > distance, just as well, and I expect comparabale improvement for its
> > users, as in case of mlx5e.
> >
> > I tested new behavior on my VM with the following NUMA configuration:
> >
> > root@debian:~# numactl -H
> > available: 4 nodes (0-3)
> > node 0 cpus: 0 1 2 3
> > node 0 size: 3869 MB
> > node 0 free: 3740 MB
> > node 1 cpus: 4 5
> > node 1 size: 1969 MB
> > node 1 free: 1937 MB
> > node 2 cpus: 6 7
> > node 2 size: 1967 MB
> > node 2 free: 1873 MB
> > node 3 cpus: 8 9 10 11 12 13 14 15
> > node 3 size: 7842 MB
> > node 3 free: 7723 MB
> > node distances:
> > node   0   1   2   3
> >   0:  10  50  30  70
> >   1:  50  10  70  30
> >   2:  30  70  10  50
> >   3:  70  30  50  10
> >
> > And the cpumask_local_spread() for each node and offset traversing looks
> > like this:
> >
> > node 0:   0   1   2   3   6   7   4   5   8   9  10  11  12  13  14  15
> > node 1:   4   5   8   9  10  11  12  13  14  15   0   1   2   3   6   7
> > node 2:   6   7   0   1   2   3   8   9  10  11  12  13  14  15   4   5
> > node 3:   8   9  10  11  12  13  14  15   4   5   6   7   0   1   2   3
> >
> 
> Is this meant as a replacement for [1]?

No. Your series adds an iterator, and in my experience the code that
uses iterators of that sort is almost always better and easier to
understand than cpumask_nth() or cpumask_next()-like users.

My series has the only advantage that it allows keep existing codebase
untouched.
 
> I like that this is changing an existing interface so that all current
> users directly benefit from the change. Now, about half of the users of
> cpumask_local_spread() use it in a loop with incremental @i parameter,
> which makes the repeated bsearch a bit of a shame, but then I'm tempted to
> say the first point makes it worth it.
> 
> [1]: https://lore.kernel.org/all/20221028164959.1367250-1-vschneid@redhat.com/

In terms of very common case of sequential invocation of local_spread()
for cpus from 0 to nr_cpu_ids, the complexity of my approach is n * log n,
and your approach is amortized O(n), which is better. Not a big deal _now_,
as you mentioned in the other email. But we never know how things will
evolve, right?

So, I would take both and maybe in comment to cpumask_local_spread()
mention that there's a better alternative for those who call the
function for all CPUs incrementally.

Thanks,
Yury
