Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 008B5DA599
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 08:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392589AbfJQG2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 02:28:50 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:39971 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390993AbfJQG2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 02:28:50 -0400
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
        (Authenticated sender: pshelar@ovn.org)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id 38BCE10000B
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 06:28:46 +0000 (UTC)
Received: by mail-ua1-f43.google.com with SMTP id j5so303217uak.12
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 23:28:46 -0700 (PDT)
X-Gm-Message-State: APjAAAW8GU6/TohpjiUEK9oqNZtHgTAT83Fb1eER/jBjEhcuAn5NQAET
        LG6tyzY8qAStGbSaTOOFmZNp/9e++m5xOWb5kL0=
X-Google-Smtp-Source: APXvYqyRnfbkG/94j4Ns8zoY4UjSRTVNTqodd92gbI3FRkOOIrdjOxKsNB1xHes2TmW0u2qoUkSq9haRW9VbrgB5N+M=
X-Received: by 2002:ab0:5bdb:: with SMTP id z27mr1415597uae.118.1571293724849;
 Wed, 16 Oct 2019 23:28:44 -0700 (PDT)
MIME-Version: 1.0
References: <1570509631-13008-1-git-send-email-martinvarghesenokia@gmail.com>
 <CAOrHB_A6diWm08Swp3_2Eo+VCvugRsh60Vc8_t2pC3QLEAR9xQ@mail.gmail.com>
 <20191010043101.GA19339@martin-VirtualBox> <CAOrHB_CSwAPW7XwyaFV_hxQADmh25a8JMJa0tRXZbnu-2R60Kw@mail.gmail.com>
 <20191014160444.GA29007@martin-VirtualBox> <CAOrHB_CXu-WGPB-7+K8hA=ZubgcMWAERVYbMhKVuSK5z1Sz7tQ@mail.gmail.com>
 <20191016030516.GA2700@martin-VirtualBox>
In-Reply-To: <20191016030516.GA2700@martin-VirtualBox>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Wed, 16 Oct 2019 23:28:34 -0700
X-Gmail-Original-Message-ID: <CAOrHB_BVttHGQeY2KjHH75kfuBc-_SNj_OZV3zJmNE3mmA5ZdA@mail.gmail.com>
Message-ID: <CAOrHB_BVttHGQeY2KjHH75kfuBc-_SNj_OZV3zJmNE3mmA5ZdA@mail.gmail.com>
Subject: Re: [PATCH net-next] Change in Openvswitch to support MPLS label
 depth of 3 in ingress direction
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Benc <jbenc@redhat.com>, scott.drennan@nokia.com,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 8:05 PM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> On Tue, Oct 15, 2019 at 12:03:35AM -0700, Pravin Shelar wrote:
> > On Mon, Oct 14, 2019 at 9:06 AM Martin Varghese
> > <martinvarghesenokia@gmail.com> wrote:
> > >
> > > On Sat, Oct 12, 2019 at 01:08:26PM -0700, Pravin Shelar wrote:
> > > > On Wed, Oct 9, 2019 at 9:31 PM Martin Varghese
> > > > <martinvarghesenokia@gmail.com> wrote:
> > > > >
> > > > > On Wed, Oct 09, 2019 at 08:29:51AM -0700, Pravin Shelar wrote:
> > > > > > On Mon, Oct 7, 2019 at 9:41 PM Martin Varghese
> > > > > > <martinvarghesenokia@gmail.com> wrote:
> > > > > > >
> > > > > > > From: Martin Varghese <martin.varghese@nokia.com>
> > > > > > >
> > > > > > > The openvswitch was supporting a MPLS label depth of 1 in the ingress
> > > > > > > direction though the userspace OVS supports a max depth of 3 labels.
> > > > > > > This change enables openvswitch module to support a max depth of
> > > > > > > 3 labels in the ingress.
> > > > > > >
> > > > > > > Signed-off-by: Martin Varghese <martinvarghesenokia@gmail.com>
> > > > > > > ---
> > > > > > >  net/openvswitch/actions.c      | 10 +++++++-
> > > > > > >  net/openvswitch/flow.c         | 20 ++++++++++-----
> > > > > > >  net/openvswitch/flow.h         |  9 ++++---
> > > > > > >  net/openvswitch/flow_netlink.c | 55 +++++++++++++++++++++++++++++++++---------
> > > > > > >  4 files changed, 72 insertions(+), 22 deletions(-)
> > > > > > >
> > > > > > > diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> > > > > > > index 3572e11..eb5bed5 100644
> > > > > > > --- a/net/openvswitch/actions.c
> > > > > > > +++ b/net/openvswitch/actions.c
> > > > > > > @@ -178,10 +178,14 @@ static int pop_mpls(struct sk_buff *skb, struct sw_flow_key *key,
> > > > > > >  {
> > > > > > >         int err;
> > > > > > >
> > > > > > > +       if (!key->mpls.num_labels_mask)
> > > > > > > +               return -EINVAL;
> > > > > > > +
> > > > > > >         err = skb_mpls_pop(skb, ethertype);
> > > > > > >         if (err)
> > > > > > >                 return err;
> > > > > > >
> > > > > > > +       key->mpls.num_labels_mask >>= 1;
> > > > > > >         invalidate_flow_key(key);
> > > > > > Since this key is immediately invalidated, what is point of updating
> > > > > > the label count?
> > > > > >
> > > > >
> > > > > The num_labels_mask is being checked in the pop_mpls action to see if anymore
> > > > > label present to pop.
> > > > >
> > > > > if (!key->mpls.num_labels_mask)
> > > > >         return -EINVAL:
> > > > >
> > > > > > >         return 0;
> > > > > > >  }
> > > > > > What about checks in OVS_ACTION_ATTR_PUSH_MPLS?
> > > > > >
> > > > > The change does not have any impact to the PUSH_MPLS actions.
> > > > > It should work as before.
> > > > >
> > > > Since the MPLS label count is checked in POP, the PUSH action needs to
> > > > update the count.
> > > >
> > > Ok, that would be to support a rule like this
> > > eth_type(0x0800),actions: push_mpls(label=7,tc=0,ttl=64,bos=1,eth_type=0x8847), pop_mpls(eth_type=0x800)
> > >
> > > Though this rule has no effect we can support it for the completeness.
> > > It would entail a code like this
> > >
> > >  if (eth_p_mpls(proto))
> > >         key->mpls.num_labels_mask = (key->mpls.num_labels_mask << 1 &
> > >                                      GENMASK(MPLS_LABEL_DEPTH -1, 0))| 0x1;  else
> > >         key->mpls.num_labels_mask = (key->mpls.num_labels_mask & 0x0)|0x01;
> > Yes, but as mentioned below, it can be moved to flow install time.
> >
> > > > > > > @@ -192,6 +196,7 @@ static int set_mpls(struct sk_buff *skb, struct sw_flow_key *flow_key,
> > > > > > >         struct mpls_shim_hdr *stack;
> > > > > > >         __be32 lse;
> > > > > > >         int err;
> > > > > > > +       u32 i = 0;
> > > > > > >
> > > > > > >         stack = mpls_hdr(skb);
> > > > > > >         lse = OVS_MASKED(stack->label_stack_entry, *mpls_lse, *mask);
> > > > > > > @@ -199,7 +204,10 @@ static int set_mpls(struct sk_buff *skb, struct sw_flow_key *flow_key,
> > > > > > >         if (err)
> > > > > > >                 return err;
> > > > > > >
> > > > > > > -       flow_key->mpls.top_lse = lse;
> > > > > > > +       for (i = MPLS_LABEL_DEPTH - 1; i > 0; i--)
> > > > > > > +               flow_key->mpls.lse[i] = flow_key->mpls.lse[i - 1];
> > > > > > > +
> > > > > > > +       flow_key->mpls.lse[i] = *mpls_lse;
> > > > > > This is changing semantic of mpls-set action. It is looking like
> > > > > > mpls-push. Lets keep the MPLS set that sets one or more MPLS lebels.
> > > > > >
> > > > > > >         return 0;
> > > > > > >  }
> > > > >
> > > > > Not sure if I got your comment correct.
> > > > > Just as before, the new code updates the top most label in the flow_key.
> > > > I am referring to the for loop which shifts labels to make room new
> > > > label been set. I think the set action should over-write labels
> > > > specified in set action.
> > > >
> > > Correct. Then this would suffice " flow_key->mpls.lse[0] = lse"
> > >
> > Yes, with this change this action need to support one more labels in set action.
> >
> shouldn't we be consistent with the existing behaviour in current kernel module, Dpif-netdev & ovs userspace, where the set_mpls action  sets the top most MPLS label params ?
ok, I am fine with setting topmost label.
