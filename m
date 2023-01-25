Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6D867C022
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 23:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbjAYWrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 17:47:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjAYWrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 17:47:31 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F2B113D7
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 14:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674686850; x=1706222850;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=7O9OBeIjLIjIjXTuiks04172v/00r5SmSECTXq3nURI=;
  b=EvfUeOlc1dm2hVhFCrMiFSFzz6NkDsC1JpQEuLpsH2cc0POhlN3GaJ26
   Xkzom2QEiYpbLebbkJhZg0PQ3R4OlO/PtySsSuCfhLbrEW0tIBwTJsS3x
   uZ7oSoU9nPhnT3UHnrAPnwfCOXqvxlkk7VpBH96uVLq+onhp8HBAUyuQ2
   VaDaV3Ok1rUJZk/Bp2BnFPbjTSpPGP+pqzUky02t1rDLfCKFSwFu0TGsy
   BNipdJeo5EswDs8bI8tu7oNmglpHZWbBoPmKjzHiVyYTfE3zDHEPmU9qt
   cvfBqID8P74avknH3LWvTMB8hElSRvGm76FVAYc+F/w/yL+9Lh/3Ykzn9
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="326728354"
X-IronPort-AV: E=Sophos;i="5.97,246,1669104000"; 
   d="scan'208";a="326728354"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 14:47:29 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10601"; a="726065974"
X-IronPort-AV: E=Sophos;i="5.97,246,1669104000"; 
   d="scan'208";a="726065974"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.17])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 14:47:28 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: Re: [RFC PATCH net-next 00/11] ENETC mqprio/taprio cleanup
In-Reply-To: <20230125131011.hs64czbvv6n3tojh@skbuf>
References: <20230120141537.1350744-1-vladimir.oltean@nxp.com>
 <87tu0fh0zi.fsf@intel.com> <20230125131011.hs64czbvv6n3tojh@skbuf>
Date:   Wed, 25 Jan 2023 14:47:28 -0800
Message-ID: <87h6wegrjz.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <vladimir.oltean@nxp.com> writes:

> On Tue, Jan 24, 2023 at 05:11:29PM -0800, Vinicius Costa Gomes wrote:
>> Hi Vladimir,
>> 
>> Sorry for the delay. I had to sleep on this for a bit.
>
> No problem, thanks for responding.
>
>> > Vinicius said that for some Intel NICs, prioritization at the egress
>> > scheduler stage is fundamentally attached to TX queues rather than
>> > traffic classes.
>> >
>> > In other words, in the "popular" mqprio configuration documented by him:
>> >
>> > $ tc qdisc replace dev $IFACE parent root handle 100 mqprio \
>> >       num_tc 3 \
>> >       map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>> >       queues 1@0 1@1 2@2 \
>> >       hw 0
>> >
>> > there are 3 Linux traffic classes and 4 TX queues. The TX queues are
>> > organized in strict priority fashion, like this: TXQ 0 has highest prio
>> > (hardware dequeue precedence for TX scheduler), TXQ 3 has lowest prio.
>> > Packets classified by Linux to TC 2 are hashed between TXQ 2 and TXQ 3,
>> > but the hardware has higher precedence for TXQ2 over TXQ 3, and Linux
>> > doesn't know that.
>> >
>> > I am surprised by this fact, and this isn't how ENETC works at all.
>> > For ENETC, we try to prioritize on TCs rather than TXQs, and TC 7 has
>> > higher priority than TC 7. For us, groups of TXQs that map to the same
>> > TC have the same egress scheduling priority. It is possible (and maybe
>> > useful) to have 2 TXQs per TC - one TXQ per CPU). Patch 07/11 tries to
>> > make that more clear.
>> 
>> That makes me think, making "queues" visible on mqprio/taprio perhaps
>> was a mistake. Perhaps if we only had the "prio to tc" map, and relied
>> on drivers implementing .ndo_select_queue() that would be less
>> problematic. And for devices with tens/hundreds of queues, this "no
>> queues to the user exposed" sounds like a better model. Anyway... just
>> wondering.
>> 
>> Perhaps something to think about for mqprio/taprio/etc "the next generation" ;-)
>
> Hmm, not sure I wanted to go there with my proposal. I think the fact
> that taprio allows specifying how many TXQs are used per TC (and
> starting with which TXQ offset) is a direct consequence of the fact that
> mqprio had that in its UAPI. Today, there certainly needs to exist
> hardware-level knowledge in mapping TXQs to TCs in a way that makes
> software prioritization (netdev_core_pick_tx()) coincide with the
> hardware prioritization scheme. That requirement of prior knowledge
> certainly makes a given taprio/mqprio configuration less portable across
> systems/vendors, which is the problem IMO.
>
> But I wouldn't jump to your conclusion, that it was a mistake to even
> expose TXQs to user space. I would argue, maybe the problem is that not
> *enough* information about TXQs is exposed to user space. I could
> imagine it being useful for user space to be able to probe information
> such as
>
> - this netdev has strict prioritization (i.e. for this netdev, egress
>   scheduling priority is attached directly to TXQs, and each TXQ is
>   required to have a unique priority)
>
> - this netdev has round robin egress scheduling between TXQs (or some
>   other fairness scheme; which one?)
>   - is the round robin scheduling weighted? what are the weights, and
>     are they configurable? should skb_tx_hash() take the weights into
>     consideration?
>
> - this netdev has 2 layers of egress scheduling, first being strict
>   priority and the other being round robin
>
> Based on this kind of information, some kind of automation would become
> possible to write an mqprio configuration that maps TCs to TXQs in a
> portable way, and user space sockets are just concerned with the packet
> priority API.
>
> I guess different people would want to expose even more, or slightly
> different, information about what it is that the kernel exposes for
> TXQs. I would be interested to know what that is.

Sounds interesting. Instead of "hiding" information from the user and
trusting the driver to do the right thing, we would expose enough
information for the user to config it right. That could work.

>
>> > Furthermore (and this is really the biggest point of contention), myself
>> > and Vinicius have the fundamental disagreement whether the 802.1Qbv
>> > (taprio) gate mask should be passed to the device driver per TXQ or per
>> > TC. This is what patch 11/11 is about.
>> 
>> I think that I was being annoying because I believed that some
>> implementation detail of the netdev prio_tc_map and the way that netdev
>> select TX queues (the "core of how mqprio works") would leak, and it
>> would be easier/more correct to make other vendors adapt themselves to
>> the "Intel"/"queues have priorities" model. But I stand corrected, as
>> you (and others) have proven.
>
> The problem with gates per TXQ is that it doesn't answer the obvious
> question of how does that work out when there is >1 TXQ per TC.
> With the clarification that "gates per TXQ" requires that there is a
> single TXQ per TC, this effectively becomes just a matter of changing
> the indices of set bits in the gate mask (TC 3 may correspond to TXQ
> offset 5), which is essentially what Gerhard seems to want to see with
> tsnep. That is something I don't have a problem with.
>
> But I may want, as a sanity measure, to enforce that the mqprio queue
> count for each TC is no more than 1 ;) Otherwise, we fall into that
> problem I keep repeating: skb_tx_hash() arbitrarily hashes between 2
> TXQs, both have an open gate in software (allowing traffic to pass),
> but in hardware, one TXQ has an open gate and the other has a closed gate.
> So half the traffic goes into the bitbucket, because software doesn't
> know what hardware does/expects.
>
> So please ACK this issue and my proposal to break your "popular" mqprio
> configuration.

I am afraid that I cannot give my ACK for that, that is, for some
definition, a breaking change. A config that has been working for many
years is going to stop working.

I know that is not ideal, perhaps we could use the capabilities "trick"
to help minimize the breakage? i.e. add a capability whether or not the
device supports/"make sense" having multiple TXQs handling a single TC?

Would it help?

>
>> In short, I am not opposed to this idea. This capability operation
>> really opens some possibilities. The patches look clean.
>
> Yeah, gotta thank Jakub for that.
>
>> I'll play with the patches later in the week, quite swamped at this
>> point.
>
> Regarding the patches - I plan to send a v2 anyway, because patch 08/11
> "net/sched: taprio: pass mqprio queue configuration to ndo_setup_tc()"
> doesn't quite work how I'd hoped. Specifically, taprio must hold a
> persistent struct tc_mqprio_qopt, rather than just juggling with what it
> received last time via TCA_TAPRIO_ATTR_PRIOMAP. This is because taprio
> supports some level of dynamic reconfiguration via taprio_change(), and
> the TCA_TAPRIO_ATTR_PRIOMAP would be NULL when reconfigured (because the
> priomap isn't what has changed). Currently this will result in passing a
> NULL (actually disabled) mqprio configuration to ndo_setup_tc(), but
> what I really want is to pass the *old* mqprio configuration.

Cool. Will play with v2, then.


Cheers,
-- 
Vinicius
