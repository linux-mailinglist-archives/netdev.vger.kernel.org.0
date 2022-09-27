Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665DA5ECDC8
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbiI0UGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbiI0UF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:05:29 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55D46F272;
        Tue, 27 Sep 2022 13:04:42 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id d64so13084751oia.9;
        Tue, 27 Sep 2022 13:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=YIZ0y9UAHomtacUaehn8ypReGgtyIec2adv7THfzCiU=;
        b=h3/wRzqut0XN1ennxNst2ojt2POvBIvpDNQ/JTvplRqETdDfw4AOgwrevVMwzz0SAE
         SqE4oJHK4+OL5zm68mNceaJMr3bW/yUWFKlbwVnqjYFdKVmN/sFWr38cyNf0ltyr9XCR
         JQjDi0GxXNbj8610R7V5JPKD9dFC5m5LBQATLGT0lRusPIyJpmZFvkxEf3VyiqWH98V3
         giiM+AX/8hCjseKySytiXfmBkk9Qiefl7wAMJgt0fCOEW7Jjw4pKtsn4396w1moTiZY5
         8pjTsAyRf38U+cwYRHiJc3XkrWx9JneGx/8KVdowOFdTUHK+bCXsIyGS8lKRLABHhMpr
         PKag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=YIZ0y9UAHomtacUaehn8ypReGgtyIec2adv7THfzCiU=;
        b=z4eEVVly4SlBErXW0k+stj3hjDzYNRTszXwda4LzGSAcl533fZCmneBzH/kxuizPP7
         zBV4VYODNuk5Lfe8wIR9wK0zS+w9yA7uY9IIn7+aefzlnXNCsOh2NEEdywPwK3B0Pm3W
         BwL1VH6FT7sa1cois6ft2Eye6QsA7f5AFTbwLmy0OoJF11cwDXXiQjIXQjsQgDeB0uFf
         VSUe7hj84/Ex7ZY87acGsi73H6STu6Yl+7Xyzd9+q7hXM4OtiBBZVlkNcCaP45kkf1F5
         WMNl+qQZjb45OkBvtBBlonYx9sSMZjuMPW0wuYqBVyqQh3WNz/gdxl72p8LDSZi9oMyG
         8OiA==
X-Gm-Message-State: ACrzQf1xeOACiha07WqE6HyEGskMDlLmG7f+VmcK/n0jh5EwqYxnMWYu
        f/cSbLc7c1xCLJZiL0y0X6TIuSB3COQ=
X-Google-Smtp-Source: AMsMyM4jBAgr3tTGRxGnw5EF4NOAPDLQ1e1dCtIb/KtKSSRBgfBytNltq8E7+lq12ONEKjYBzH2v2A==
X-Received: by 2002:a05:6808:1247:b0:351:4a04:8058 with SMTP id o7-20020a056808124700b003514a048058mr2560760oiv.12.1664309081885;
        Tue, 27 Sep 2022 13:04:41 -0700 (PDT)
Received: from localhost ([12.97.180.36])
        by smtp.gmail.com with ESMTPSA id 94-20020a9d0f67000000b00657daa70c37sm1120336ott.25.2022.09.27.13.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 13:04:41 -0700 (PDT)
Date:   Tue, 27 Sep 2022 13:02:30 -0700
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
Subject: Re: [PATCH v4 2/7] cpumask: Introduce for_each_cpu_andnot()
Message-ID: <YzNW1su5pcO5SLIW@yury-laptop>
References: <20220923132527.1001870-1-vschneid@redhat.com>
 <20220923155542.1212814-1-vschneid@redhat.com>
 <YzBycCwecSUlGgjX@yury-laptop>
 <xhsmhill84vhr.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xhsmhill84vhr.mognet@vschneid.remote.csb>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 05:45:04PM +0100, Valentin Schneider wrote:
> On 25/09/22 08:23, Yury Norov wrote:
> > On Fri, Sep 23, 2022 at 04:55:37PM +0100, Valentin Schneider wrote:
> >> +/**
> >> + * for_each_cpu_andnot - iterate over every cpu present in one mask, excluding
> >> + *			 those present in another.
> >> + * @cpu: the (optionally unsigned) integer iterator
> >> + * @mask1: the first cpumask pointer
> >> + * @mask2: the second cpumask pointer
> >> + *
> >> + * This saves a temporary CPU mask in many places.  It is equivalent to:
> >> + *	struct cpumask tmp;
> >> + *	cpumask_andnot(&tmp, &mask1, &mask2);
> >> + *	for_each_cpu(cpu, &tmp)
> >> + *		...
> >> + *
> >> + * After the loop, cpu is >= nr_cpu_ids.
> >> + */
> >> +#define for_each_cpu_andnot(cpu, mask1, mask2)				\
> >> +	for ((cpu) = -1;						\
> >> +		(cpu) = cpumask_next_andnot((cpu), (mask1), (mask2)),	\
> >> +		(cpu) < nr_cpu_ids;)
> >
> > This would raise cpumaks_check() warning at the very last iteration.
> > Because cpu is initialized insize the loop, you don't need to check it
> > at all. You can do it like this:
> >
> >  #define for_each_cpu_andnot(cpu, mask1, mask2)				\
> >          for_each_andnot_bit(...)
> >
> > Check this series for details (and please review).
> > https://lore.kernel.org/all/20220919210559.1509179-8-yury.norov@gmail.com/T/
> >
> 
> Thanks, I'll have a look.

Also, if you send first 4 patches as a separate series on top of
bitmap-for-next, I'll be able to include them in bitmap-for-next
and then in 6.1 pull-request.

Thanks,
Yury
