Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7D93E5C7D
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 16:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238554AbhHJOEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 10:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233175AbhHJOEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 10:04:21 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FE8C0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 07:03:58 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id qk33so35632003ejc.12
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 07:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=No89KqurzxpNZ2AhIN1pNCph+Lp1nc5iNUK1CUdfoHE=;
        b=DdjPMLS94WU8boFeQRU8zDqYyv0zHnyyiqbLF5jFn2+AhPVtQAtVVy+oyBa3eQ1Fub
         FbvY+0WHbBG+ivLB0SknzupPvZ/rVFOyUk75DH5NrjP0ewFHzAZx5p2QOwFjRAxuR1cB
         pM98cAgWYD5QkbRGoj3/nI20ATyWTZA07s3Hcp34pmDJeSPvbT2J7mwcJwrsdKC2r+Jo
         q9zDgvRoXMUNNvs3HVuRQcLwJDqcltcCOMGcj7C5ucqSal92r/SI14LQ4BdTLBQvbSnC
         vqjktoVZ6dK64t1NA9Gq5N/ixA3SsV30rs3KiCXwjuoTUyZ67F3WourgeZ7bN9g/MSSv
         c3NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=No89KqurzxpNZ2AhIN1pNCph+Lp1nc5iNUK1CUdfoHE=;
        b=M9GPBsjSgvnBiKSoZPCh8vTflYLdNbvUPOdJR+cqbV1roQFqBxWUCoS2eG0j8qisz7
         OYiP2EPD2p7auuQ2xKoO8ClmHhhlgOjtkf/qS40kmsGK5FRyqK4Q/NwfWwWW/CyuhR38
         QmB/t9+WegZfO4mOAmkQxu4gi1zl6lOgO9OS44KSW5cgXZq9tZndD4CE0Vyf56Tr3avw
         oxhnKx/dATavfPAnuTzRL+rmsGS906bmcQvcGGq0GTURxlXqEJBT6l7Iy9yhXFJ9eM2Y
         9uDE5Y2l1YarwwnmbzDuD1mlblDvk+0t6IdZcboCfrpPjrdrrQxIaoL+/PAYrXSO7i7C
         u1hA==
X-Gm-Message-State: AOAM530Xnmt3hIw1xJ5SjTjs/SC7T2xxZ8Ok996E/r40qOuCeYIshXbc
        RqBrLUYtavXDBGjwv5QWigyuhI+0AffFYQeNz20=
X-Google-Smtp-Source: ABdhPJxcwsxuR5jqeFyHCdmkL5EOVSyqYLfP8FYDoz0xGW8g21iezUJMGDj3UGNsTJk2vrw0q1v8iNvq0lXKJREubaY=
X-Received: by 2002:a17:906:1299:: with SMTP id k25mr27761791ejb.139.1628604237357;
 Tue, 10 Aug 2021 07:03:57 -0700 (PDT)
MIME-Version: 1.0
References: <162855246915.98025.18251604658503765863.stgit@anambiarhost.jf.intel.com>
 <CAKgT0UfMqqSjF80VYNcax4Yer2F2u9f_cbm3DSLtdhz_JzWH-A@mail.gmail.com> <PH0PR11MB5207C23E220FD910DB99BE45F1F79@PH0PR11MB5207.namprd11.prod.outlook.com>
In-Reply-To: <PH0PR11MB5207C23E220FD910DB99BE45F1F79@PH0PR11MB5207.namprd11.prod.outlook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 10 Aug 2021 07:03:46 -0700
Message-ID: <CAKgT0Ueqv55Qw=yYyqvtv9Sq=QTDeaoX=8z68H6KWZdEa4vwrA@mail.gmail.com>
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

On Mon, Aug 9, 2021 at 6:20 PM Nambiar, Amritha
<amritha.nambiar@intel.com> wrote:
>
> > -----Original Message-----
> > From: Alexander Duyck <alexander.duyck@gmail.com>
> > Sent: Monday, August 9, 2021 5:51 PM
> > To: Nambiar, Amritha <amritha.nambiar@intel.com>
> > Cc: Netdev <netdev@vger.kernel.org>; Jakub Kicinski <kuba@kernel.org>;
> > Jamal Hadi Salim <jhs@mojatatu.com>; Jiri Pirko <jiri@resnulli.us>; Cong
> > Wang <xiyou.wangcong@gmail.com>; Samudrala, Sridhar
> > <sridhar.samudrala@intel.com>
> > Subject: Re: [net-next PATCH] net: act_skbedit: Fix tc action skbedit
> > queue_mapping
> >
> > On Mon, Aug 9, 2021 at 4:36 PM Amritha Nambiar
> > <amritha.nambiar@intel.com> wrote:
> > >
> > > For skbedit action queue_mapping to select the transmit queue,
> > > queue_mapping takes the value N for tx-N (where N is the actual
> > > queue number). However, current behavior is the following:
> > > 1. Queue selection is off by 1, tx queue N-1 is selected for
> > >    action skbedit queue_mapping N. (If the general syntax for queue
> > >    index is 1 based, i.e., action skbedit queue_mapping N would
> > >    transmit to tx queue N-1, where N >=1, then the last queue cannot
> > >    be used for transmit as this fails the upper bound check.)
> > > 2. Transmit to first queue of TCs other than TC0 selects the
> > >    next queue.
> > > 3. It is not possible to transmit to the first queue (tx-0) as
> > >    this fails the bounds check, in this case the fallback
> > >    mechanism for hash calculation is used.
> > >
> > > Fix the call to skb_set_queue_mapping(), the code retrieving the
> > > transmit queue uses skb_get_rx_queue() which subtracts the queue
> > > index by 1. This makes it so that "action skbedit queue_mapping N"
> > > will transmit to tx-N (including the first and last queue).
> > >
> > > Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
> > > Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
> > > ---
> > >  net/sched/act_skbedit.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/net/sched/act_skbedit.c b/net/sched/act_skbedit.c
> > > index e5f3fb8b00e3..a7bba15c74c4 100644
> > > --- a/net/sched/act_skbedit.c
> > > +++ b/net/sched/act_skbedit.c
> > > @@ -59,7 +59,7 @@ static int tcf_skbedit_act(struct sk_buff *skb, const
> > struct tc_action *a,
> > >         }
> > >         if (params->flags & SKBEDIT_F_QUEUE_MAPPING &&
> > >             skb->dev->real_num_tx_queues > params->queue_mapping)
> > > -               skb_set_queue_mapping(skb, params->queue_mapping);
> > > +               skb_set_queue_mapping(skb, params->queue_mapping + 1);
> > >         if (params->flags & SKBEDIT_F_MARK) {
> > >                 skb->mark &= ~params->mask;
> > >                 skb->mark |= params->mark & params->mask;
> > >
> >
> > I don't think this is correct. It is conflating the rx_queue_mapping
> > versus the Tx queue mapping. This is supposed to be setting the Tx
> > queue mapping which applies after we have dropped the Rx queue
> > mapping, not before. Specifically this is run at the qdisc enqueue
> > stage with a single locked qdisc, after netdev_pick_tx and skb_tx_hash
> > have already run. It is something that existed before mq and is meant
> > to work with the mutliq qdisc.
> >
> > If you are wanting to add a seperate override to add support for
> > programming the Rx queue mapping you may want to submit that as a
> > different patch rather than trying to change the existing Tx queue
> > mapping feature. Either that or you would need to change this so that
> > it has a different behavior depending on where the hook is added since
> > the behavior would be different if this is called before skb_tx_hash.
>
> Hi Alex,
> Thanks for the review. The goal is to select a transmit queue using tc egress rule
> and the action skbedit (that will go through netdev_pick_tx and skb_tx_hash).
> I am not sure of the correct syntax for the queue-mapping value in the
> action (tx-N or tx-N+1). As per the man page
> (https://man7.org/linux/man-pages/man8/tc-skbedit.8.html), I interpreted
> it as "action skbedit queue_mapping N" will transmit to tx-N. But, the
> 3 observations I listed don't quite seem to be following the tc rule.
> Hence, tried to fix this in the action module.
>
> -Amritha

Hi Amritha,

As I mentioned before the problem is where the hook is being inserted.

If you follow the example in the documentation found at:
https://elixir.bootlin.com/linux/v5.14-rc5/source/Documentation/networking/multiqueue.rst

What you should find is that the Tx queue hook works as expected
because it will occur when the packet is enqueued to the qdisc, not
before. The problem is for the mq qdiscs this is occuring before the
Tx queue selection where the Rx queue is still active and the Tx queue
has not yet been selected.

You might take a look at the spots where tcf_classify is called. The
problem you are experiencing is because this action is expecting to
edit the packet inside the qdisc, whereas what you are doing is
calling this in sch_handle_egress which occurs before the Tx queue has
been selected.

What we likely need is some way of identifying when we are attaching
the classifier/action to either the ingress or egress classifier
rather than a qdisc and in that case then we use the
skb_record_rx_queue functionality instead of the skb_set_queue_mapping
functionality. One possible way to address this would be to expand
tc_at_ingress to actually be a 2 bit value and have 0 indicate Qdisc,
1 indicate Ingress, and 2 indicate Egress. Then you could filter out
the Ingress/Egress cases and have them use skb_record_rx_queue while
the other cases use skb_set_queue_mapping.

Hope that helps to clear it up a bit.

- Alex
