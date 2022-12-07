Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA8E646298
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 21:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiLGUpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 15:45:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiLGUpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 15:45:16 -0500
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2C6286CE;
        Wed,  7 Dec 2022 12:45:15 -0800 (PST)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-1442977d77dso21604168fac.6;
        Wed, 07 Dec 2022 12:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4kebxzXFDbxKV/u+zjtuQ7wmCbGMAgePV5kIke3Uuk8=;
        b=UbfuNEyjpbepGYS/zuCDyvw/S1WDjbUKxzogfI7Gm1k+tMzeClUNJZFHw3PYtD9fNt
         XjkRgZ137NueagyajRVRPzP+1DeRQMspHdipbtvqo1hPYwYyjyiEABlwQ2SmZT1a9pFn
         4spl9BoFWh3nFmWjiAyCwkWB/B/91DSqV3qEFlVgz6jBpRlFnk9hgGBbQI9qp/ZOMfVu
         fbYiDEg9ro/0bSgAMhsF/MXqtI3Zv7ZIDkGtfen1SxnqSO5ivVVsr4qssn+v/XExi26G
         67E1IH/t/pZCSy8bHwEygj69ZChEGJlWIB44P2anapOh1/Inku4fBKgfsREEAhuISsZD
         Uwjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4kebxzXFDbxKV/u+zjtuQ7wmCbGMAgePV5kIke3Uuk8=;
        b=nKFuzVDvOylrn6N2WAEBI/eHmxLNeVmOsMkpSY3u7TGz4rj3rwgYqmgoSJyYWjj2Kn
         0QnJwMxvtZ0yYvzU5zX2ea+MnKGOUI3ZkWsq28gfCbGaZ3aFxSQ7FWdryjIfrtcAy1r9
         dZbQmEFh82yfF18NpI6vhJi+vRZsF3HEif7y0Pr+nqk8GOLSzj6OobniBycp0QRZvYu4
         w0CgAI/cPE2Tlx1W3+M9RRersPGHSUu4LhLs91h9mXh6C5hxZfwBoA1dUy605/wQzhQH
         89vBUIsDKZ4+UnoxxdkO3t+eMw6PXcpjKcGFEA0iRyQ+MfEbB8w6bbrvia1+/EuWPsZA
         dQGg==
X-Gm-Message-State: ANoB5pm+Hk1W2mudc49kmCSWEg3GfoVIVqXHPyDG1AUvKJVGgDUl1wQO
        X1XCwQg5uZ1JG1FoAsjQDkQ=
X-Google-Smtp-Source: AA0mqf48D+LgwdxzCWLyMNMHGCauciTixEbl58o1DsLRuAANDl2lXpeubbD80FxHqciRMOPlxoZmww==
X-Received: by 2002:a05:6870:8a2b:b0:144:bf10:eecd with SMTP id p43-20020a0568708a2b00b00144bf10eecdmr6090328oaq.204.1670445914434;
        Wed, 07 Dec 2022 12:45:14 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id q13-20020a056808200d00b0035b4b6d1bbfsm10019786oiw.28.2022.12.07.12.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 12:45:13 -0800 (PST)
Date:   Wed, 7 Dec 2022 12:45:10 -0800
From:   Yury Norov <yury.norov@gmail.com>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Valentin Schneider <vschneid@redhat.com>,
        linux-kernel@vger.kernel.org,
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
        Tony Luck <tony.luck@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v2 0/4] cpumask: improve on cpumask_local_spread()
 locality
Message-ID: <Y5D7VvNIG8AKXuC6@yury-laptop>
References: <20221112190946.728270-1-yury.norov@gmail.com>
 <xhsmh7czwyvtj.mognet@vschneid.remote.csb>
 <Y3PXw8Hqn+RCMg2J@yury-laptop>
 <xhsmho7t5ydke.mognet@vschneid.remote.csb>
 <665b6081-be55-de9a-1f7f-70a143df329d@gmail.com>
 <Y4a2MBVEYEY+alO8@yury-laptop>
 <19cbfb5e-22b1-d9c1-8d50-38714e3eaf7d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19cbfb5e-22b1-d9c1-8d50-38714e3eaf7d@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 02:53:58PM +0200, Tariq Toukan wrote:
> 
> 
> On 11/30/2022 3:47 AM, Yury Norov wrote:
> > On Mon, Nov 28, 2022 at 08:39:24AM +0200, Tariq Toukan wrote:
> > > 
> > > 
> > > On 11/17/2022 2:23 PM, Valentin Schneider wrote:
> > > > On 15/11/22 10:32, Yury Norov wrote:
> > > > > On Tue, Nov 15, 2022 at 05:24:56PM +0000, Valentin Schneider wrote:
> > > > > > 
> > > > > > Is this meant as a replacement for [1]?
> > > > > 
> > > > > No. Your series adds an iterator, and in my experience the code that
> > > > > uses iterators of that sort is almost always better and easier to
> > > > > understand than cpumask_nth() or cpumask_next()-like users.
> > > > > 
> > > > > My series has the only advantage that it allows keep existing codebase
> > > > > untouched.
> > > > > 
> > > > 
> > > > Right
> > > > 
> > > > > > I like that this is changing an existing interface so that all current
> > > > > > users directly benefit from the change. Now, about half of the users of
> > > > > > cpumask_local_spread() use it in a loop with incremental @i parameter,
> > > > > > which makes the repeated bsearch a bit of a shame, but then I'm tempted to
> > > > > > say the first point makes it worth it.
> > > > > > 
> > > > > > [1]: https://lore.kernel.org/all/20221028164959.1367250-1-vschneid@redhat.com/
> > > > > 
> > > > > In terms of very common case of sequential invocation of local_spread()
> > > > > for cpus from 0 to nr_cpu_ids, the complexity of my approach is n * log n,
> > > > > and your approach is amortized O(n), which is better. Not a big deal _now_,
> > > > > as you mentioned in the other email. But we never know how things will
> > > > > evolve, right?
> > > > > 
> > > > > So, I would take both and maybe in comment to cpumask_local_spread()
> > > > > mention that there's a better alternative for those who call the
> > > > > function for all CPUs incrementally.
> > > > > 
> > > > 
> > > > Ack, sounds good.
> > > > 
> > > 
> > > Good.
> > > Is a respin needed, to add the comment mentioned above?
> > 
> > If you think it's worth the effort.
> 
> No, not sure it is...
> 
> I asked because this mail thread was inactive for a while, with the patches
> not accepted to the kernel yet.
> 
> If everyone is happy with it, let's make it to this kernel while possible.
> 
> To which tree should it go?

I've got bitmap tree and can move it there, but this series is related to
scheduler and NUMA as well, and I'd prefer move it in those trees.

If moving through bitmaps, I'd like to collect more reviews and testing.

Thanks,
Yury
