Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B931B5A2F
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 13:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbgDWLO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 07:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727895AbgDWLO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 07:14:28 -0400
X-Greylist: delayed 78691 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Apr 2020 04:14:28 PDT
Received: from mail.buslov.dev (mail.buslov.dev [IPv6:2001:19f0:5001:2e3f:5400:1ff:feed:a259])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E64C035494;
        Thu, 23 Apr 2020 04:14:28 -0700 (PDT)
Received: from vlad-x1g6.mellanox.com (unknown [IPv6:2a01:d0:40b3:9801:fec2:781d:de90:e768])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.buslov.dev (Postfix) with ESMTPSA id 58C7A208FF;
        Thu, 23 Apr 2020 14:14:24 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=buslov.dev; s=2019;
        t=1587640465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wZX69rGx5ZsrkgUhdo+rnn/ONVvytgKtcCaPJguT/HU=;
        b=NlzyLWlNiSG1rxS8YMEd0zTDwu9nw6OXxvM2dZy1JDtt+5Lk1kQXRgaWkYEKQrFVQ5f3Yy
        IyWlUAc/rjExKG2k7iktLVhfbKfiE0I93jVv48oxt0rIF8ApDdNsbBEKlE3Ucd6UhSK5gt
        KNunmhcaYBtN/Pc5KKPaqpDdsIAtwWiAGjVbKg21lHlDvL5FmBVn+OOE9r/pwot6C3F1BH
        n9PX7f++QTjnlLaqh4xSifyvFWILwXpG9vRWpiVL1RAhfSmoBKeoU3gfX0BgfcXyrGguRM
        pDcCOz+Q/2Jf9ymPEpgBf3uEl1VD+kII2Cez3SCxKvrzIfd5zT5+MhcERl15bA==
References: <20200418011211.31725-5-Po.Liu@nxp.com> <20200422024852.23224-1-Po.Liu@nxp.com> <20200422024852.23224-2-Po.Liu@nxp.com> <877dy7bqo7.fsf@buslov.dev> <VE1PR04MB6496969AB18E17938671FA6092D30@VE1PR04MB6496.eurprd04.prod.outlook.com> <871roebqbe.fsf@buslov.dev> <VE1PR04MB6496AAA71717BBAD4C4CE2BC92D30@VE1PR04MB6496.eurprd04.prod.outlook.com> <VE1PR04MB6496F4805BCF53AF5889CB3892D30@VE1PR04MB6496.eurprd04.prod.outlook.com>
User-agent: mu4e 1.4.1; emacs 26.3
From:   Vlad Buslov <vlad@buslov.dev>
To:     Po Liu <po.liu@nxp.com>
Cc:     Vlad Buslov <vlad@buslov.dev>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes\@intel.com" <vinicius.gomes@intel.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Vladimir Oltean" <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael.chan\@broadcom.com" <michael.chan@broadcom.com>,
        "vishal\@chelsio.com" <vishal@chelsio.com>,
        "saeedm\@mellanox.com" <saeedm@mellanox.com>,
        "leon\@kernel.org" <leon@kernel.org>,
        "jiri\@mellanox.com" <jiri@mellanox.com>,
        "idosch\@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni\@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver\@microchip.com" <UNGLinuxDriver@microchip.com>,
        "kuba\@kernel.org" <kuba@kernel.org>,
        "jhs\@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong\@gmail.com" <xiyou.wangcong@gmail.com>,
        "simon.horman\@netronome.com" <simon.horman@netronome.com>,
        "pablo\@netfilter.org" <pablo@netfilter.org>,
        "moshe\@mellanox.com" <moshe@mellanox.com>,
        "m-karicheri2\@ti.com" <m-karicheri2@ti.com>,
        "andre.guedes\@linux.intel.com" <andre.guedes@linux.intel.com>,
        "stephen\@networkplumber.org" <stephen@networkplumber.org>
Subject: Re: [EXT] Re: [v3,net-next  1/4] net: qos: introduce a gate control flow action
In-reply-to: <VE1PR04MB6496F4805BCF53AF5889CB3892D30@VE1PR04MB6496.eurprd04.prod.outlook.com>
Message-ID: <87wo66sbc0.fsf@buslov.dev>
Date:   Thu, 23 Apr 2020 14:14:39 +0300
MIME-Version: 1.0
Content-Type: text/plain
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=vlad@buslov.dev smtp.mailfrom=vlad@buslov.dev
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Thu 23 Apr 2020 at 12:15, Po Liu <po.liu@nxp.com> wrote:
> Hi Vlad Buslov,
>
>> > >> > +static enum hrtimer_restart gate_timer_func(struct hrtimer *timer)
>> {
>> > >> > +     struct gate_action *gact = container_of(timer, struct
>> gate_action,
>> > >> > +                                             hitimer);
>> > >> > +     struct tcf_gate_params *p = get_gate_param(gact);
>> > >> > +     struct tcfg_gate_entry *next;
>> > >> > +     ktime_t close_time, now;
>> > >> > +
>> > >> > +     spin_lock(&gact->entry_lock);
>> > >> > +
>> > >> > +     next = rcu_dereference_protected(gact->next_entry,
>> > >> > +
>> > >> > + lockdep_is_held(&gact->entry_lock));
>> > >> > +
>> > >> > +     /* cycle start, clear pending bit, clear total octets */
>> > >> > +     gact->current_gate_status = next->gate_state ?
>> > >> GATE_ACT_GATE_OPEN : 0;
>> > >> > +     gact->current_entry_octets = 0;
>> > >> > +     gact->current_max_octets = next->maxoctets;
>> > >> > +
>> > >> > +     gact->current_close_time = ktime_add_ns(gact-
>> > >current_close_time,
>> > >> > +                                             next->interval);
>> > >> > +
>> > >> > +     close_time = gact->current_close_time;
>> > >> > +
>> > >> > +     if (list_is_last(&next->list, &p->entries))
>> > >> > +             next = list_first_entry(&p->entries,
>> > >> > +                                     struct tcfg_gate_entry, list);
>> > >> > +     else
>> > >> > +             next = list_next_entry(next, list);
>> > >> > +
>> > >> > +     now = gate_get_time(gact);
>> > >> > +
>> > >> > +     if (ktime_after(now, close_time)) {
>> > >> > +             ktime_t cycle, base;
>> > >> > +             u64 n;
>> > >> > +
>> > >> > +             cycle = p->tcfg_cycletime;
>> > >> > +             base = ns_to_ktime(p->tcfg_basetime);
>> > >> > +             n = div64_u64(ktime_sub_ns(now, base), cycle);
>> > >> > +             close_time = ktime_add_ns(base, (n + 1) * cycle);
>> > >> > +     }
>> > >> > +
>> > >> > +     rcu_assign_pointer(gact->next_entry, next);
>> > >> > +     spin_unlock(&gact->entry_lock);
>> > >>
>> > >> I have couple of question about synchronization here:
>> > >>
>> > >> - Why do you need next_entry to be rcu pointer? It is only assigned
>> > >> here with entry_lock protection and in init code before action is
>> > >> visible to concurrent users. I don't see any unlocked rcu-protected
>> > >> readers here that could benefit from it.
>> > >>
>> > >> - Why create dedicated entry_lock instead of using already existing
>> > >> per- action tcf_lock?
>> > >
>> > > Will try to use the tcf_lock for verification.
>
> I think I added entry_lock was that I can't get the tc_action common parameter in this  timer function. If I insist to use the tcf_lock, I have to move the hrtimer to struct tcf_gate which has tc_action common.
> What do you think?

Well, if you use tcf_lock instead of rcu to sync with fastpath, the you
don't need to implement struct gate_action as standalone object pointed
to by rcu pointer from base structure that includes tc_action common.
All the necessary data can be included in tcf_gate structure directly
and used from both timer and action fastpath. See pedit for example of
action that doesn't use rcu for fastpath.

>
>> > > The thoughts came from that the timer period arrived then check
>> > > through the list and then update next time would take much more
>> time.
>> > > Action function would be busy when traffic. So use a separate lock
>> > > here for
>> > >
>> > >>
>> > >> > +
>> > >> > +     hrtimer_set_expires(&gact->hitimer, close_time);
>> > >> > +
>> > >> > +     return HRTIMER_RESTART;
>> > >> > +}
>> > >> > +
>> > >> > +static int tcf_gate_act(struct sk_buff *skb, const struct tc_action *a,
>> > >> > +                     struct tcf_result *res) {
>> > >> > +     struct tcf_gate *g = to_gate(a);
>> > >> > +     struct gate_action *gact;
>> > >> > +     int action;
>> > >> > +
>> > >> > +     tcf_lastuse_update(&g->tcf_tm);
>> > >> > +     bstats_cpu_update(this_cpu_ptr(g->common.cpu_bstats), skb);
>> > >> > +
>> > >> > +     action = READ_ONCE(g->tcf_action);
>> > >> > +     rcu_read_lock();
>> > >>
>> > >> Action fastpath is already rcu read lock protected, you don't need
>> > >> to manually obtain it.
>> > >
>> > > Will be removed.
>> > >
>> > >>
>> > >> > +     gact = rcu_dereference_bh(g->actg);
>> > >> > +     if (unlikely(gact->current_gate_status & GATE_ACT_PENDING))
>> > >> > + {
>> > >>
>> > >> Can't current_gate_status be concurrently modified by timer callback?
>> > >> This function doesn't use entry_lock to synchronize with timer.
>> > >
>> > > Will try tcf_lock either.
>> > >
>> > >>
>> > >> > +             rcu_read_unlock();
>> > >> > +             return action;
>> > >> > +     }
>> > >> > +
>> > >> > +     if (!(gact->current_gate_status & GATE_ACT_GATE_OPEN))
>> > >>
>> > >> ...and here
>> > >>
>> > >> > +             goto drop;
>> > >> > +
>> > >> > +     if (gact->current_max_octets >= 0) {
>> > >> > +             gact->current_entry_octets += qdisc_pkt_len(skb);
>> > >> > +             if (gact->current_entry_octets >
>> > >> > + gact->current_max_octets) {
>> > >>
>> > >> here also.
>> > >>
>> > >> > +
>> > >> > + qstats_overlimit_inc(this_cpu_ptr(g->common.cpu_qstats));
>> > >>
>> > >> Please use tcf_action_inc_overlimit_qstats() and other wrappers for
>> > stats.
>> > >> Otherwise it will crash if user passes
>> > TCA_ACT_FLAGS_NO_PERCPU_STATS
>> > >> flag.
>> > >
>> > > The tcf_action_inc_overlimit_qstats() can't show limit counts in tc
>> > > show
>> > command. Is there anything need to do?
>> >
>> > What do you mean? Internally tcf_action_inc_overlimit_qstats() just
>> > calls qstats_overlimit_inc, if cpu_qstats percpu counter is not NULL:
>> >
>> >
>> >         if (likely(a->cpu_qstats)) {
>> >                 qstats_overlimit_inc(this_cpu_ptr(a->cpu_qstats));
>> >                 return;
>> >         }
>> >
>> > Is there a subtle bug somewhere in this function?
>> 
>> Sorry, I updated using the tcf_action_*, and the counting is ok. I moved
>> back to the qstats_overlimit_inc() because tcf_action_* () include the
>> spin_lock(&a->tcfa_lock).
>> I would update to  tcf_action_* () increate.
>> 
>> >
>> > >
>> > > Br,
>> > > Po Liu
>> 
>> Thanks a lot.
>> 
>> Br,
>> Po Liu
>
> Thanks a lot.
>
> Br,
> Po Liu

