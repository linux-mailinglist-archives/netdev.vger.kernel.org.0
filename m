Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2867863CD00
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 02:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbiK3Brh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 20:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiK3Brg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 20:47:36 -0500
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5904813B;
        Tue, 29 Nov 2022 17:47:31 -0800 (PST)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-13bd2aea61bso19433311fac.0;
        Tue, 29 Nov 2022 17:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jHLuEwDd4ephlkChL9nCW8YQ7VT3fy4zl63QtukC6uk=;
        b=mszqok5e+P0HO8KMquZAwj2ulqGdn79hCsFcF6DehjjW2LARu8qilsWv3XsVH69EOG
         B9E5tH1teWPEFpT/vbZlByIBSIV2ET24W1YgOHMJ3rkfEj2AaI7cw3X2d1h+yoeP6grJ
         Gycis4bjMmnnxhJcEs9FqNSVKZqIA0fXPpsDaASEqc8GrahoqbdmpIklGpKJWbNfVcp5
         SqgASUiIeX/svV0O5X0Mq+oV9nXPokWgVkPYjcnrWvQ9TJA2tREyxbhS6WfGaNrgyih8
         DxT4kxu4/NRZNbrXi01FQdq1hmdGpvKXlLGEZXh0xIoc74o2d2H+bve/hv2KkhVHeBsr
         BnHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jHLuEwDd4ephlkChL9nCW8YQ7VT3fy4zl63QtukC6uk=;
        b=atVFeS/gCcwZQsfMay8mIuNWjFSXvGS/gtPMPgBklvh4Sf9Cig62khS4QHsGYLh4lO
         Il1ZmMefxO0mw41TkARj884GqYokYBixuzwFgW8F9HHr9YnfJqIvNVxfz/i7YJLSBZrD
         VAkgadSEXyc89sR0AeMNP0G3VXsGrvA8BPwkWnXfUy3w1VgBF7oeSMY2oi97OmCz+LuB
         j+ClYbNmWguiR/W+yfkfXsBvWTujnOYMnWAJCTn8n5Ru3WBWF2Cb8jTKa/y5fjs2cfGI
         rDDrQIyJlIoX+Y73kLU+dpb4NtgBsEGhhyh+Yc8/PQpJMygHO8zxCRyk8gQBgwq28jf0
         X8QQ==
X-Gm-Message-State: ANoB5pnjqtQw9iGMBDhmbYVTwoVAl+9Jmg+nUVFUIEg53o8nndFCh+sV
        ivadBiTlwZUBPD/PuAYFW+U=
X-Google-Smtp-Source: AA0mqf4tcHIJ6VIdAdcykahix+4U0RnE4zsbd6pkZt/jPJIJ4Onv1aFMW8XZzzYhRZ7J+lJAz8V0Gw==
X-Received: by 2002:a05:6870:5a5:b0:13a:f95a:2cca with SMTP id m37-20020a05687005a500b0013af95a2ccamr34859654oap.212.1669772850608;
        Tue, 29 Nov 2022 17:47:30 -0800 (PST)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id z25-20020a056870d69900b00141e56210b2sm222965oap.57.2022.11.29.17.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 17:47:30 -0800 (PST)
Date:   Tue, 29 Nov 2022 17:47:28 -0800
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
Message-ID: <Y4a2MBVEYEY+alO8@yury-laptop>
References: <20221112190946.728270-1-yury.norov@gmail.com>
 <xhsmh7czwyvtj.mognet@vschneid.remote.csb>
 <Y3PXw8Hqn+RCMg2J@yury-laptop>
 <xhsmho7t5ydke.mognet@vschneid.remote.csb>
 <665b6081-be55-de9a-1f7f-70a143df329d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <665b6081-be55-de9a-1f7f-70a143df329d@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 08:39:24AM +0200, Tariq Toukan wrote:
> 
> 
> On 11/17/2022 2:23 PM, Valentin Schneider wrote:
> > On 15/11/22 10:32, Yury Norov wrote:
> > > On Tue, Nov 15, 2022 at 05:24:56PM +0000, Valentin Schneider wrote:
> > > > 
> > > > Is this meant as a replacement for [1]?
> > > 
> > > No. Your series adds an iterator, and in my experience the code that
> > > uses iterators of that sort is almost always better and easier to
> > > understand than cpumask_nth() or cpumask_next()-like users.
> > > 
> > > My series has the only advantage that it allows keep existing codebase
> > > untouched.
> > > 
> > 
> > Right
> > 
> > > > I like that this is changing an existing interface so that all current
> > > > users directly benefit from the change. Now, about half of the users of
> > > > cpumask_local_spread() use it in a loop with incremental @i parameter,
> > > > which makes the repeated bsearch a bit of a shame, but then I'm tempted to
> > > > say the first point makes it worth it.
> > > > 
> > > > [1]: https://lore.kernel.org/all/20221028164959.1367250-1-vschneid@redhat.com/
> > > 
> > > In terms of very common case of sequential invocation of local_spread()
> > > for cpus from 0 to nr_cpu_ids, the complexity of my approach is n * log n,
> > > and your approach is amortized O(n), which is better. Not a big deal _now_,
> > > as you mentioned in the other email. But we never know how things will
> > > evolve, right?
> > > 
> > > So, I would take both and maybe in comment to cpumask_local_spread()
> > > mention that there's a better alternative for those who call the
> > > function for all CPUs incrementally.
> > > 
> > 
> > Ack, sounds good.
> > 
> 
> Good.
> Is a respin needed, to add the comment mentioned above?

If you think it's worth the effort.
