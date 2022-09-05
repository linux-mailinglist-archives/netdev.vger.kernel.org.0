Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F4F5AD90D
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 20:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbiIESdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 14:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbiIESdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 14:33:38 -0400
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4426F52824;
        Mon,  5 Sep 2022 11:33:37 -0700 (PDT)
Received: by mail-vk1-xa35.google.com with SMTP id g185so4463752vkb.13;
        Mon, 05 Sep 2022 11:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=mdiYTElc0N7vxtlgVoJ4ru4DWj2kj5bPdL6LfLpy0aM=;
        b=D8oBhUif2Jjk678o2fHLYtmnpB6UYZ7abkmoEbTSB7gYd+aR7NJTzbHizWX0tEsttg
         94prx+9nmPlCZdE5toZMsp430z+gngCXzzQ8F0xiJjKACppBxdxBLTlqIcPPacfPndOw
         Z0Lqt285BGObRHpVzemZKZ/kraVoHaDn4JSYqvYh6Nh5r6wWFZtrxjWA7nvig9Ud7IFJ
         xcs8Pv7moCtVzQwibbdhdRJ3R/sMYt1epwFDFt15E3PejndhkY4f8QjW6Ee3NYrLE9xB
         xToTfryH++k4nKcj4DdExkema16S3GQs73HBYq5kYCwNzB+TI5x6OI0EPu/Ajcdi79z+
         Fb6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=mdiYTElc0N7vxtlgVoJ4ru4DWj2kj5bPdL6LfLpy0aM=;
        b=2P0ekqFKsU5YNn8p+z0Rx8wNWlOXWkrKM+FNLCzVgXQEoOoTVmgrEUZ/Ky1wQqR1EX
         kAyjkAj9+vMO7todrk0aUW/K1TRXcw39GPg+sbM9XKZ+7T2z0Ewp+mBYaT1xi2HERjVO
         htRntOAxGpRqpQgahUOailp21hGAsoFvp2N1gCPFfqOh669yMBPX2lcdUBiVBTsqbYKY
         K5I/gIjwUquH/1b0KDhEOZJ9oM3EC3RIV6wia6ZtjRizwtJ+Tl94K+cX54mOcpEV9XhX
         aJRaDcNcGZIlp5FHna2utJWk/yI4fXN+dZlQiGV5rxMJRVWDpzdVUFglYNdoJA+2QTxs
         Jf1A==
X-Gm-Message-State: ACgBeo3wNE928k6BFnDzmFMJb8tzRldqDiv7lGsMFAvdsPxKDTd9FZKV
        7NtEZXBxy970o/umH51NMC689hrDidLA5cjfmCvpA9F5
X-Google-Smtp-Source: AA6agR5O+agHArA/yt3Tr7w/AexHtBdz7ROCfVnT2AWabzEmYu4CO6i9d2nt4ec+fPUaR8DJL5zcLXKUYod+baz4ttw=
X-Received: by 2002:a05:6122:2212:b0:374:2fb5:19ef with SMTP id
 bb18-20020a056122221200b003742fb519efmr13937297vkb.2.1662402816175; Mon, 05
 Sep 2022 11:33:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220825181210.284283-1-vschneid@redhat.com> <20220825181210.284283-5-vschneid@redhat.com>
 <YwfmIDEbRT4JfsZp@yury-laptop> <xhsmh5yi1db56.mognet@vschneid.remote.csb>
In-Reply-To: <xhsmh5yi1db56.mognet@vschneid.remote.csb>
From:   Yury Norov <yury.norov@gmail.com>
Date:   Mon, 5 Sep 2022 11:33:24 -0700
Message-ID: <CAAH8bW8DHTgXFB4wvjQqNqk7cbsYNk-SvBHL48tQwEBor_34hg@mail.gmail.com>
Subject: Re: [PATCH v3 4/9] cpumask: Introduce for_each_cpu_andnot()
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 5, 2022 at 9:44 AM Valentin Schneider <vschneid@redhat.com> wrote:
>
> On 25/08/22 14:14, Yury Norov wrote:
> > On Thu, Aug 25, 2022 at 07:12:05PM +0100, Valentin Schneider wrote:
> >> +#define for_each_cpu_andnot(cpu, mask1, mask2)                              \
> >> +    for ((cpu) = -1;                                                \
> >> +            (cpu) = cpumask_next_andnot((cpu), (mask1), (mask2)),   \
> >> +            (cpu) < nr_cpu_ids;)
> >
> > The standard doesn't guarantee the order of execution of last 2 lines,
> > so you might end up with unreliable code. Can you do it in a more
> > conventional style:
> >    #define for_each_cpu_andnot(cpu, mask1, mask2)                     \
> >       for ((cpu) = cpumask_next_andnot(-1, (mask1), (mask2));         \
> >               (cpu) < nr_cpu_ids;                                     \
> >               (cpu) = cpumask_next_andnot((cpu), (mask1), (mask2)))
> >
>
> IIUC the order of execution *is* guaranteed as this is a comma operator,
> not argument passing:
>
>   6.5.17 Comma operator
>
>   The left operand of a comma operator is evaluated as a void expression;
>   there is a sequence point after its evaluation. Then the right operand is
>   evaluated; the result has its type and value.
>
> for_each_cpu{_and}() uses the same pattern (which I simply copied here).
>
> Still, I'd be up for making this a bit more readable. I did a bit of
> digging to figure out how we ended up with that pattern, and found
>
>   7baac8b91f98 ("cpumask: make for_each_cpu_mask a bit smaller")
>
> so this appears to have been done to save up on generated instructions.
> *if* it is actually OK standard-wise, I'd vote to leave it as-is.

Indeed. I probably messed with ANSI C.

Sorry for the noise.
