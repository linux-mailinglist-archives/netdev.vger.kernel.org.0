Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC1146EED8D
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 07:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239380AbjDZFcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 01:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbjDZFcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 01:32:41 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533E519BC;
        Tue, 25 Apr 2023 22:32:40 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 41be03b00d2f7-517bb11ca34so4832763a12.0;
        Tue, 25 Apr 2023 22:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682487160; x=1685079160;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1r9574SMIwQtU8BeDEFPL0l691QH9uGI3eu0UF7TAm4=;
        b=qLX3LxKLeNt5S5SQ+LIytoafIe5EoEBRSXdVIH4X0P6QxGyq8rq43mZWQ7w2fRC8Gj
         1Bqc/6zVe1QQSAxSJ7u1BnxpMTqGWuzbOKf+5QnODu/DqXC4XEWcZnQJyyuMGESFiZsb
         J6+KaS5kq6+kpBVrO664NTWScsct/vdrIH6Jhng6j7S7EJ4SyxX0N0TK/8xqDndsY6dh
         kY+c7axfhgDkFRIoAa1xrQuTf2Jq1BE4WRJl1boNRgakosv5osbf7kGCNsRpt3FcpQFI
         PV898v5hWKlw8EY9ERjtX+xYup/ApkyyPodBwaBuplqUw/CPcr3OGKDaK8CXGT4IWBAH
         7M+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682487160; x=1685079160;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1r9574SMIwQtU8BeDEFPL0l691QH9uGI3eu0UF7TAm4=;
        b=M+DlobWevWhgZETpwB3V5UwT+g6jAmQ/n8NDehaGLo+fOxJuTvVIC2SxS+TP4PLd7c
         iDePymrk7cDpGNkMD3jLAu2pwRq4TR+ul0j1XUJptGpA0Jj3YgyMpsCjX85FntDx+F/Y
         KY8+QsVjP2Ldx0aDABEG4KNlxJZEGW4L82eFIMmOxiIZh52QyXheqA+ciD3mYYBr09Cv
         U78z1XgIkCV0yLT1LJHZyic/ZJHnqHq5RTUHijEXbACxXKUtlD6EsDT1uepNjHg4EWNQ
         s+y1XUwHhhX3QWtFQ9y0i1w/UH1BlmAc2+4iS15Dg4SsoS0UvQSObWH8SXHBsSoWwWGG
         ferQ==
X-Gm-Message-State: AAQBX9dc61Lckn0MpgZcx23/Ql46ig0GatHd80waIX1ofovosCpsS0By
        B6lct2LqrGAlUKePFZKMYTU=
X-Google-Smtp-Source: AKy350YNRztW7HRifwKCsleQwtDhkO+hZE8QYH1Ce066XxdHJFrrbjuH6jVouoTB6MzupfutC8SnYw==
X-Received: by 2002:a05:6a20:a188:b0:d5:f7f5:85e4 with SMTP id r8-20020a056a20a18800b000d5f7f585e4mr18141581pzk.22.1682487158768;
        Tue, 25 Apr 2023 22:32:38 -0700 (PDT)
Received: from localhost ([216.228.127.128])
        by smtp.gmail.com with ESMTPSA id z5-20020a62d105000000b00640ddad2e0dsm3923280pfg.47.2023.04.25.22.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 22:32:38 -0700 (PDT)
Date:   Tue, 25 Apr 2023 22:32:36 -0700
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
Subject: Re: [PATCH v2 3/8] sched/topology: add for_each_numa_cpu() macro
Message-ID: <ZEi3dLvlg/35DUrM@yury-ThinkPad>
References: <20230420051946.7463-1-yury.norov@gmail.com>
 <20230420051946.7463-4-yury.norov@gmail.com>
 <xhsmh4jp4l21j.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xhsmh4jp4l21j.mognet@vschneid.remote.csb>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 10:54:48AM +0100, Valentin Schneider wrote:
> On 19/04/23 22:19, Yury Norov wrote:
> > +/**
> > + * for_each_numa_cpu - iterate over cpus in increasing order taking into account
> > + *		       NUMA distances from a given node.
> > + * @cpu: the (optionally unsigned) integer iterator
> > + * @hop: the iterator variable, must be initialized to a desired minimal hop.
> > + * @node: the NUMA node to start the search from.
> > + * @mask: the cpumask pointer
> > + *
> > + * Requires rcu_lock to be held.
> > + */
> > +#define for_each_numa_cpu(cpu, hop, node, mask)					\
> > +	for ((cpu) = 0, (hop) = 0;						\
> > +		(cpu) = sched_numa_find_next_cpu((mask), (cpu), (node), &(hop)),\
> > +		(cpu) < nr_cpu_ids;						\
> > +		(cpu)++)
> > +
> 
> I think we can keep sched_numa_find_next_cpu() as-is, but could we make
> that macro use cpu_possible_mask by default? We can always add a variant
> if/when we need to feed in a different mask.

As mentioned in discussion to the driver's patch, all that numa things
imply only online CPUs, so cpu_possible_mask may mislead to some extent. 

Anyways, can you elaborate what you exactly want? Like this?

 #define for_each_numa_online_cpu(cpu, hop, node)       \
        for_each_numa_cpu(cpu, hop, node, cpu_online_mask)
