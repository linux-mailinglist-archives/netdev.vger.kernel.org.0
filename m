Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033073EF702
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 02:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235845AbhHRAwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 20:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbhHRAwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 20:52:54 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E00AC061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 17:52:20 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id u3so1391925ejz.1
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 17:52:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R1VFROYWqPARUpEdYRMG8TE+4oLb5lChs1G23aSWB9U=;
        b=aOMAxNGgxeHY2B/WbjjIbWJuoYtGsFlLtkQlucR4yD9d5ehwLqoUG5t9BS65Js01DG
         UB4aJKjgbiEdWQ/gNZpTFIZWmCLHuls5QHsgk7WfO/9al8GxZmB8jxjQAIwBcvlGoZmK
         uFGfa9RgLw0ZbBy4RwZJiZcVdv/AHQS8P/r6zkX4fRRk5bzeIuaSwb3mKR9Wnl1IehQc
         H/qfX0lMLu398EjyOAPX+4fD+Vy2uP2spSkhuBRR0NsDGFFH8TLHLmva/eVlPoXYmbc4
         0uFSe2HBBHqjMkt/RKZo005OiBlOJW1z3CuV8hq9CyTHW0B24ru8o0U5550UluWXOcVt
         iyUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R1VFROYWqPARUpEdYRMG8TE+4oLb5lChs1G23aSWB9U=;
        b=PoAb+TXVTBV57qutJGvMHgba9vnwvs/ymvXto5UgkNPvgxs0f4Tz/S4zBUGQHK34nc
         4WSr0IRaJzV1EPnHFwYvDY7GxnKwZL1FP8EHE5tEs65F6DeZoy4uYMTkSrrS5fxkUMyl
         8gh9fKg+hgHoze0g7sngWIDCCWp4DSDW7Fhx7v6DAQIu02i3bW6vRaDFuN/Fl1TRZO28
         0IWMHyQSZneWxXu1zSu567+jo3pq5ecB5Tke93WWIGsJ99uHxh8y2auAqfGgX4W65xDY
         We58cAwkpY1mV6/Pu6J/vAijZgBXCGYscrCSjZ46W5fTWczdX3gKpdgBUHBbhDK3CpQm
         a7Nw==
X-Gm-Message-State: AOAM530MtkJu5MXjIoklqyLMzoxahAoIOn0hExivKB/TTpnxu77jE/eI
        U+U/5lyNO80GHAGpUTOdjYiCClFUEsCs0qBVaA0=
X-Google-Smtp-Source: ABdhPJxIYOw6tagjsd4ynE22EkjAT8KgERP75TVaWcnHJZBNnm3b6RK2WHK6qr0nDUqwblsJ+WpEZL4ZC6/OWX0VfiY=
X-Received: by 2002:a17:906:edc3:: with SMTP id sb3mr7086798ejb.114.1629247938666;
 Tue, 17 Aug 2021 17:52:18 -0700 (PDT)
MIME-Version: 1.0
References: <162855246915.98025.18251604658503765863.stgit@anambiarhost.jf.intel.com>
 <CAKgT0UfMqqSjF80VYNcax4Yer2F2u9f_cbm3DSLtdhz_JzWH-A@mail.gmail.com>
 <PH0PR11MB5207C23E220FD910DB99BE45F1F79@PH0PR11MB5207.namprd11.prod.outlook.com>
 <CAKgT0Ueqv55Qw=yYyqvtv9Sq=QTDeaoX=8z68H6KWZdEa4vwrA@mail.gmail.com> <PH0PR11MB5207CCFF0DDB54055AE50801F1FF9@PH0PR11MB5207.namprd11.prod.outlook.com>
In-Reply-To: <PH0PR11MB5207CCFF0DDB54055AE50801F1FF9@PH0PR11MB5207.namprd11.prod.outlook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 17 Aug 2021 17:52:07 -0700
Message-ID: <CAKgT0Ud+Y0QmmHJyFhJgJz99MX=Fd=2KMeczvCfkrEwHoXL6mw@mail.gmail.com>
Subject: Re: [net-next PATCH] net: act_skbedit: Fix tc action skbedit queue_mapping
To:     "Nambiar, Amritha" <amritha.nambiar@intel.com>
Cc:     Netdev <netdev@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 5:16 PM Nambiar, Amritha
<amritha.nambiar@intel.com> wrote:
>
> > -----Original Message-----
> > From: Alexander Duyck <alexander.duyck@gmail.com>
> > Sent: Tuesday, August 10, 2021 7:04 AM
> > To: Nambiar, Amritha <amritha.nambiar@intel.com>
> > Cc: Netdev <netdev@vger.kernel.org>; Jakub Kicinski <kuba@kernel.org>;
> > Jamal Hadi Salim <jhs@mojatatu.com>; Jiri Pirko <jiri@resnulli.us>; Cong
> > Wang <xiyou.wangcong@gmail.com>; Samudrala, Sridhar
> > <sridhar.samudrala@intel.com>
> > Subject: Re: [net-next PATCH] net: act_skbedit: Fix tc action skbedit
> > queue_mapping
> >
> > On Mon, Aug 9, 2021 at 6:20 PM Nambiar, Amritha
> > <amritha.nambiar@intel.com> wrote:
> > >
> > > > -----Original Message-----
> > > > From: Alexander Duyck <alexander.duyck@gmail.com>
> > > > Sent: Monday, August 9, 2021 5:51 PM
> > > > To: Nambiar, Amritha <amritha.nambiar@intel.com>
> > > > Cc: Netdev <netdev@vger.kernel.org>; Jakub Kicinski <kuba@kernel.org>;
> > > > Jamal Hadi Salim <jhs@mojatatu.com>; Jiri Pirko <jiri@resnulli.us>; Cong
> > > > Wang <xiyou.wangcong@gmail.com>; Samudrala, Sridhar
> > > > <sridhar.samudrala@intel.com>
> > > > Subject: Re: [net-next PATCH] net: act_skbedit: Fix tc action skbedit
> > > > queue_mapping
> > > >
> > > > On Mon, Aug 9, 2021 at 4:36 PM Amritha Nambiar
> > > > <amritha.nambiar@intel.com> wrote:
> > > > >
> > > > > For skbedit action queue_mapping to select the transmit queue,
> > > > > queue_mapping takes the value N for tx-N (where N is the actual
> > > > > queue number). However, current behavior is the following:
> > > > > 1. Queue selection is off by 1, tx queue N-1 is selected for
> > > > >    action skbedit queue_mapping N. (If the general syntax for queue
> > > > >    index is 1 based, i.e., action skbedit queue_mapping N would
> > > > >    transmit to tx queue N-1, where N >=1, then the last queue cannot
> > > > >    be used for transmit as this fails the upper bound check.)
> > > > > 2. Transmit to first queue of TCs other than TC0 selects the
> > > > >    next queue.
> > > > > 3. It is not possible to transmit to the first queue (tx-0) as
> > > > >    this fails the bounds check, in this case the fallback
> > > > >    mechanism for hash calculation is used.
> > > > >
> > > > > Fix the call to skb_set_queue_mapping(), the code retrieving the
> > > > > transmit queue uses skb_get_rx_queue() which subtracts the queue
> > > > > index by 1. This makes it so that "action skbedit queue_mapping N"
> > > > > will transmit to tx-N (including the first and last queue).
> > > > >
> > > > > Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
> > > > > Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> > > > > ---
> > > > >  net/sched/act_skbedit.c |    2 +-
> > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
> > > > > index e5f3fb8b00e3..a7bba15c74c4 100644
> > > > > --- a/net/sched/act_skbedit.c
> > > > > +++ b/net/sched/act_skbedit.c
> > > > > @@ -59,7 +59,7 @@ static int tcf_skbedit_act(struct sk_buff *skb, const
> > > > struct tc_action *a,
> > > > >         }
> > > > >         if (params->flags & SKBEDIT_F_QUEUE_MAPPING &&
> > > > >             skb->dev->real_num_tx_queues > params->queue_mapping)
> > > > > -               skb_set_queue_mapping(skb, params->queue_mapping);
> > > > > +               skb_set_queue_mapping(skb, params->queue_mapping + 1);
> > > > >         if (params->flags & SKBEDIT_F_MARK) {
> > > > >                 skb->mark &= ~params->mask;
> > > > >                 skb->mark |= params->mark & params->mask;
> > > > >
> > > >
> > > > I don't think this is correct. It is conflating the rx_queue_mapping
> > > > versus the Tx queue mapping. This is supposed to be setting the Tx
> > > > queue mapping which applies after we have dropped the Rx queue
> > > > mapping, not before. Specifically this is run at the qdisc enqueue
> > > > stage with a single locked qdisc, after netdev_pick_tx and skb_tx_hash
> > > > have already run. It is something that existed before mq and is meant
> > > > to work with the mutliq qdisc.
> > > >
> > > > If you are wanting to add a seperate override to add support for
> > > > programming the Rx queue mapping you may want to submit that as a
> > > > different patch rather than trying to change the existing Tx queue
> > > > mapping feature. Either that or you would need to change this so that
> > > > it has a different behavior depending on where the hook is added since
> > > > the behavior would be different if this is called before skb_tx_hash.
> > >
> > > Hi Alex,
> > > Thanks for the review. The goal is to select a transmit queue using tc egress
> > rule
> > > and the action skbedit (that will go through netdev_pick_tx and
> > skb_tx_hash).
> > > I am not sure of the correct syntax for the queue-mapping value in the
> > > action (tx-N or tx-N+1). As per the man page
> > > (https://man7.org/linux/man-pages/man8/tc-skbedit.8.html), I interpreted
> > > it as "action skbedit queue_mapping N" will transmit to tx-N. But, the
> > > 3 observations I listed don't quite seem to be following the tc rule.
> > > Hence, tried to fix this in the action module.
> > >
> > > -Amritha
> >
> > Hi Amritha,
> >
> > As I mentioned before the problem is where the hook is being inserted.
> >
> > If you follow the example in the documentation found at:
> > https://elixir.bootlin.com/linux/v5.14-
> > rc5/source/Documentation/networking/multiqueue.rst
> >
> > What you should find is that the Tx queue hook works as expected
> > because it will occur when the packet is enqueued to the qdisc, not
> > before. The problem is for the mq qdiscs this is occuring before the
> > Tx queue selection where the Rx queue is still active and the Tx queue
> > has not yet been selected.
> >
> > You might take a look at the spots where tcf_classify is called. The
> > problem you are experiencing is because this action is expecting to
> > edit the packet inside the qdisc, whereas what you are doing is
> > calling this in sch_handle_egress which occurs before the Tx queue has
> > been selected.
> >
> > What we likely need is some way of identifying when we are attaching
> > the classifier/action to either the ingress or egress classifier
> > rather than a qdisc and in that case then we use the
> > skb_record_rx_queue functionality instead of the skb_set_queue_mapping
> > functionality. One possible way to address this would be to expand
> > tc_at_ingress to actually be a 2 bit value and have 0 indicate Qdisc,
> > 1 indicate Ingress, and 2 indicate Egress. Then you could filter out
> > the Ingress/Egress cases and have them use skb_record_rx_queue while
> > the other cases use skb_set_queue_mapping.
> >
> > Hope that helps to clear it up a bit.
> >
> > - Alex
>
> Thanks for clarifying. Yes, it works as expected with the multiq qdisc. So, IIUC,
> with multiq qdisc, this is hooked such that, netdev_pick_tx and skb_tx_hash
> first picks a Tx queue. Then multiq_classify  overwrites the queue_mapping
> with the value from the skbedit action and calls qdisc_enqueue.
>
> Yes, as you explained, I was hooking this up at the classifier level. I was adding an
> egress filter to the clsact qdisc, and expecting the Tx queue to be picked from the
> action when netdev_pick_tx executes from sch_handle_egress. This was not getting
> into qdisc enqueue stage.
>
> What I actually hoped to do was to add similar functionality (as with multiq) to
> other qdiscs such as mqprio. So, to support this action with mqprio qdisc,
> I would need to implement the enqueue callback in mqprio and set the
> queue_mapping from the action, then run qdisc_enqueue. Is this correct ?

So the problem isn't really with the qdiscs. The problem is the
ingress and egress hooks.

What you effectively have is one behavior you want for if this is
being handled on a qdisc, and another if you are adding it at the
ingress, sch_handle_ingress(), or egress, sch_handle_egress(), hook.
The qdisc behavior is as expected and really we wouldn't want to be
using mqprio because it forces us to serialize all the packets to use
it at that stage.

That is why I was thinking it might make sense to look at expanding
tc_at_ingress so it could become a 2 bit enum. Then you use 0 as the
qdisc value, 1 as the egress, and 2 as the ingress value. With that
you could then simply take the Rx queue recording approach for if the
value is set, and the Tx approach for if it is not. The overall change
wouldn't be too big as it would mostly be shifting a write or two
around, doing a rename, and maybe adding a compare in act_mirred.c

Thanks,

- Alex
