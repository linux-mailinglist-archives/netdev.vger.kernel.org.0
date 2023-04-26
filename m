Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15496EF0EF
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 11:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240076AbjDZJTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 05:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239679AbjDZJTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 05:19:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE75A35AD
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 02:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682500637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hb1p3qZAdlHU1l6iLXytZzmouo7Dtxmm/TUeo1IcTKg=;
        b=Lxc3P81e82oYm64+dua7XbyM0l28CMF9QApg69pbfMfW620209soE3IMZ+vN2fsgyS6cMi
        Nm9+EPEY9oRtfidzW/FN5o5IiJMtxlDRxhDYErjCxdbOAmRtCfs+gBv3Ksf29iVigyHaAD
        zauIwGOhRXPVYsjz86OioHWzDSzcwFU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-8-0_9cb-iLMg6_WUV8pCe3Qw-1; Wed, 26 Apr 2023 05:17:15 -0400
X-MC-Unique: 0_9cb-iLMg6_WUV8pCe3Qw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f1754de18cso39757945e9.1
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 02:17:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682500635; x=1685092635;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hb1p3qZAdlHU1l6iLXytZzmouo7Dtxmm/TUeo1IcTKg=;
        b=Pk4/2i0W0Ix92KgzoxMKMSqX8wykTfTSd27AONsXFvk/SzTaZGZiyMydKUH2RVplAK
         GsNKw/FkUMBRxvVGCXPjrXvr5GUx43SrJCXDHSIiKfgbpppwVzm8GpkV7Vat9djxeG5O
         xvpL8mCVlocsviAL/X9C3HrAnB/trFjaGslthNZfWshVLhekLghUeUHETgnovn3YpnAb
         6zTBIP1/P6Q3ROGExynKmllOhmIdbwffPPNyqL9i7+WRPwKWwMF3vhCnf7l/BQEGsff/
         1wjOgvX3bR5R+gQzMPtfdtns9OAgommi1sjjrlzIxPQfXt8p4tYatM0c7LHX3Oc5+PWN
         c5Kw==
X-Gm-Message-State: AAQBX9fvoyJIq8RHf6Wct2Z28QTzPeasYH7CZ3MlEqizBU3Tmp+S8B1u
        DOPzEFKyskx2I6K8my8e42CTS3ASBCMBCKlQCGbPXzln7sOnVWULRsjhZYquvJjOA9g7VjW1qlc
        y9K00+SBLaGGOS5IF
X-Received: by 2002:a05:600c:d6:b0:3f1:75b0:dc47 with SMTP id u22-20020a05600c00d600b003f175b0dc47mr13169973wmm.15.1682500634753;
        Wed, 26 Apr 2023 02:17:14 -0700 (PDT)
X-Google-Smtp-Source: AKy350YEVlQWGWn9MXHPZbupRZG32H3oU+0xy3h1QTn2pkKjRSNMnr+VdpDuWb9ZAW4i29YDBnhrOA==
X-Received: by 2002:a05:600c:d6:b0:3f1:75b0:dc47 with SMTP id u22-20020a05600c00d600b003f175b0dc47mr13169945wmm.15.1682500634432;
        Wed, 26 Apr 2023 02:17:14 -0700 (PDT)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id l20-20020a05600c16d400b003f19bca8f03sm10736304wmn.43.2023.04.26.02.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 02:17:13 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Yury Norov <yury.norov@gmail.com>
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
In-Reply-To: <ZEi1/zO9cGccogea@yury-ThinkPad>
References: <20230420051946.7463-1-yury.norov@gmail.com>
 <20230420051946.7463-3-yury.norov@gmail.com>
 <xhsmh354ol21b.mognet@vschneid.remote.csb>
 <ZEi1/zO9cGccogea@yury-ThinkPad>
Date:   Wed, 26 Apr 2023 10:17:12 +0100
Message-ID: <xhsmhwn1zj947.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/04/23 22:26, Yury Norov wrote:
> On Tue, Apr 25, 2023 at 10:54:56AM +0100, Valentin Schneider wrote:
>> On 19/04/23 22:19, Yury Norov wrote:
>> > +/*
>> > + * sched_numa_find_next_cpu() - given the NUMA topology, find the next cpu
>> > + * cpumask: cpumask to find a cpu from
>> > + * cpu: current cpu
>> > + * node: local node
>> > + * hop: (in/out) indicates distance order of current CPU to a local node
>> > + *
>> > + * The function searches for next cpu at a given NUMA distance, indicated
>> > + * by hop, and if nothing found, tries to find CPUs at a greater distance,
>> > + * starting from the beginning.
>> > + *
>> > + * Return: cpu, or >= nr_cpu_ids when nothing found.
>> > + */
>> > +int sched_numa_find_next_cpu(const struct cpumask *cpus, int cpu, int node, unsigned int *hop)
>> > +{
>> > +	unsigned long *cur, *prev;
>> > +	struct cpumask ***masks;
>> > +	unsigned int ret;
>> > +
>> > +	if (*hop >= sched_domains_numa_levels)
>> > +		return nr_cpu_ids;
>> > +
>> > +	masks = rcu_dereference(sched_domains_numa_masks);
>> > +	cur = cpumask_bits(masks[*hop][node]);
>> > +	if (*hop == 0)
>> > +		ret = find_next_and_bit(cpumask_bits(cpus), cur, nr_cpu_ids, cpu);
>> > +	else {
>> > +		prev = cpumask_bits(masks[*hop - 1][node]);
>> > +		ret = find_next_and_andnot_bit(cpumask_bits(cpus), cur, prev, nr_cpu_ids, cpu);
>> > +	}
>> > +
>> > +	if (ret < nr_cpu_ids)
>> > +		return ret;
>> > +
>> > +	*hop += 1;
>> > +	return sched_numa_find_next_cpu(cpus, 0, node, hop);
>> 
>> sched_domains_numa_levels is a fairly small number, so the recursion depth
>> isn't something we really need to worry about - still, the iterative
>> variant of this is fairly straightforward to get to:
>
> This is a tail recursion. Compiler normally converts it into the loop just
> as well. At least, my GCC does.

I'd hope so in 2023! I still prefer the iterative approach as I find it
more readable, but I'm not /too/ strongly attached to it.

