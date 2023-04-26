Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD4CF6EED85
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 07:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239358AbjDZF02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 01:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239024AbjDZF01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 01:26:27 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4A1212D;
        Tue, 25 Apr 2023 22:26:25 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-63b62d2f729so5322699b3a.1;
        Tue, 25 Apr 2023 22:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682486785; x=1685078785;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ol7ScNQyGxV7Z5uEB0GFbvweAGUetpq1rszsAd/PZhU=;
        b=PAgDj06PQs4u4KQJ+/mUOG5BZh3mylvlA636iNhGbFylgyvEiH4yTRygzJ/4BxRGCg
         LmgJpD2WIuyfHwaTU5fcj7yp4rTZ8/fAZ8KC18Z057gVU+B4buX7O9JUieVRN6T9qpzU
         Lt8CTvEkRcdjUE/ZHEwGDBOPkWexvgAqnfEF3O5a4O2NRODaSTnfLWKe5pARXdGiBNuZ
         9pMqcUyCrxbE3DBXzK6kTVklfTX7+RrZfEfHEYHOH0kDcQY6Wkhf9wNatS8PBQ1bcpn/
         cOUzpDSnKbse/wOI++y+TH6FFUAY57t4QPm9JHJqDlbMedKprVXQUlq3ADZupJr6EIh1
         Gk8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682486785; x=1685078785;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ol7ScNQyGxV7Z5uEB0GFbvweAGUetpq1rszsAd/PZhU=;
        b=X14AdGY+q3DUfyU87GzLXIjuqpDrthJEK6+yrncFkVuDCHJ0tOsoLrh25vKHWaHTzu
         5lGV/Ko0mKL7JRKrE8eMQ+3AcUHefLyu2Q4XIN2DU1I3qPXkC128MU/s4VOgRkq1+IuQ
         NtE3ZZ3B06KcmGL2SqxaZ4T1twW6tSmJ43MDRRTf3ZRGke5t1359WESSKooIOlEFMTPC
         ixovO5FLv4gPQksArJWG3fafvJTyKbM0nddsFPg2M226NUZoG5poHs5yFLhhlJO6cmGM
         ZUD4FtwHO/lJaAyY6qAs6J91yabMRfFylFMN9RzTsteavg6H3gCAIuyvZtVYkg9iV9f6
         r8Cg==
X-Gm-Message-State: AAQBX9f+4kpfB2jBqP3MmzFhcQEcLlMm2VJs+9VIJbUov9rkmgu2fowu
        HvTMQ4AZDxop1jPJY27RHsM=
X-Google-Smtp-Source: AKy350bmKm4YoTWJceojpKi7TL6pHptbx1SZsSEOdfSXu1Y65GMpLN+B0HLpAuztemDrCyhpVOmtnQ==
X-Received: by 2002:a05:6a00:2da4:b0:623:5880:98cd with SMTP id fb36-20020a056a002da400b00623588098cdmr28478618pfb.5.1682486785196;
        Tue, 25 Apr 2023 22:26:25 -0700 (PDT)
Received: from localhost ([216.228.127.128])
        by smtp.gmail.com with ESMTPSA id t65-20020a628144000000b0063b8b8580a7sm10114704pfd.29.2023.04.25.22.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 22:26:24 -0700 (PDT)
Date:   Tue, 25 Apr 2023 22:26:23 -0700
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
Subject: Re: [PATCH v2 2/8] sched/topology: introduce
 sched_numa_find_next_cpu()
Message-ID: <ZEi1/zO9cGccogea@yury-ThinkPad>
References: <20230420051946.7463-1-yury.norov@gmail.com>
 <20230420051946.7463-3-yury.norov@gmail.com>
 <xhsmh354ol21b.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xhsmh354ol21b.mognet@vschneid.remote.csb>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 10:54:56AM +0100, Valentin Schneider wrote:
> On 19/04/23 22:19, Yury Norov wrote:
> > +/*
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
> > + * Return: cpu, or >= nr_cpu_ids when nothing found.
> > + */
> > +int sched_numa_find_next_cpu(const struct cpumask *cpus, int cpu, int node, unsigned int *hop)
> > +{
> > +	unsigned long *cur, *prev;
> > +	struct cpumask ***masks;
> > +	unsigned int ret;
> > +
> > +	if (*hop >= sched_domains_numa_levels)
> > +		return nr_cpu_ids;
> > +
> > +	masks = rcu_dereference(sched_domains_numa_masks);
> > +	cur = cpumask_bits(masks[*hop][node]);
> > +	if (*hop == 0)
> > +		ret = find_next_and_bit(cpumask_bits(cpus), cur, nr_cpu_ids, cpu);
> > +	else {
> > +		prev = cpumask_bits(masks[*hop - 1][node]);
> > +		ret = find_next_and_andnot_bit(cpumask_bits(cpus), cur, prev, nr_cpu_ids, cpu);
> > +	}
> > +
> > +	if (ret < nr_cpu_ids)
> > +		return ret;
> > +
> > +	*hop += 1;
> > +	return sched_numa_find_next_cpu(cpus, 0, node, hop);
> 
> sched_domains_numa_levels is a fairly small number, so the recursion depth
> isn't something we really need to worry about - still, the iterative
> variant of this is fairly straightforward to get to:

This is a tail recursion. Compiler normally converts it into the loop just
as well. At least, my GCC does.
