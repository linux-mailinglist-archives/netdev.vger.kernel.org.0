Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAC6E11DEFA
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 08:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbfLMH5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 02:57:46 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:47637 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbfLMH5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 02:57:46 -0500
X-Originating-IP: 209.85.221.176
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
        (Authenticated sender: pshelar@ovn.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 940AF240007
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 07:57:43 +0000 (UTC)
Received: by mail-vk1-f176.google.com with SMTP id i18so490357vkk.7
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 23:57:43 -0800 (PST)
X-Gm-Message-State: APjAAAU9fwnV5IFjhWdBjSth08II9avyclVVk3InsEo4TlHfZ9Qhs3Ei
        Ctm5a2QsxD4DA5h6MrfMGFU7aiswLBUjzP/wKeY=
X-Google-Smtp-Source: APXvYqzULBBYsFcEZYkyRjO1tj0bz1y56Vg2BeXZz6bXbKALxea3IY8uOHSOnwKgcVc7nQGFg/fJLt+iKyJFFvpZQmU=
X-Received: by 2002:a1f:fe4e:: with SMTP id l75mr12865600vki.18.1576223862285;
 Thu, 12 Dec 2019 23:57:42 -0800 (PST)
MIME-Version: 1.0
References: <cover.1575964218.git.martin.varghese@nokia.com>
 <c7b6eaa599aff9167b4123efb5b990e3afb20d15.1575964218.git.martin.varghese@nokia.com>
 <CAOrHB_BSi57EwqQ6RWzK55-ADhT_z4_fyMVrGacMMO-BXFoREA@mail.gmail.com>
 <20191211000245.GB2687@martin-VirtualBox> <CAOrHB_D0sjWcFR6KfXidDSk=5pWPMzStF2vU+GRQZ4KCVcm5tA@mail.gmail.com>
 <20191211153900.GA5156@martin-VirtualBox> <CAOrHB_BCWcyO-v1ige_4i9PM84qxXqd4SXmVvpv31AA8-af26g@mail.gmail.com>
 <20191212160226.GA8105@martin-VirtualBox> <CAOrHB_AB+GrPxzgbKto9PZyoy7Yd9_EoHS5oVyNdNc75E0sAMw@mail.gmail.com>
 <20191213035242.GA8690@martin-VirtualBox>
In-Reply-To: <20191213035242.GA8690@martin-VirtualBox>
From:   Pravin Shelar <pshelar@ovn.org>
Date:   Thu, 12 Dec 2019 23:57:30 -0800
X-Gmail-Original-Message-ID: <CAOrHB_AFDRHfAvFLeSvCt5iC4LVoqefNZKiEsROdRzcHLoMZDw@mail.gmail.com>
Message-ID: <CAOrHB_AFDRHfAvFLeSvCt5iC4LVoqefNZKiEsROdRzcHLoMZDw@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] openvswitch: New MPLS actions for layer 2 tunnelling
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, scott.drennan@nokia.com,
        Jiri Benc <jbenc@redhat.com>,
        "Varghese, Martin (Nokia - IN/Bangalore)" <martin.varghese@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 12, 2019 at 7:53 PM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> On Thu, Dec 12, 2019 at 07:15:47PM -0800, Pravin Shelar wrote:
> > On Thu, Dec 12, 2019 at 8:02 AM Martin Varghese
> > <martinvarghesenokia@gmail.com> wrote:
> > >
> > > On Wed, Dec 11, 2019 at 08:19:08PM -0800, Pravin Shelar wrote:
> > > > On Wed, Dec 11, 2019 at 7:39 AM Martin Varghese
> > > > <martinvarghesenokia@gmail.com> wrote:
> > > > >
> > > > > On Tue, Dec 10, 2019 at 10:15:19PM -0800, Pravin Shelar wrote:
> > > > > > On Tue, Dec 10, 2019 at 4:02 PM Martin Varghese
> > > > > > <martinvarghesenokia@gmail.com> wrote:
> > > > > > >
> > > > > > > On Tue, Dec 10, 2019 at 01:22:56PM -0800, Pravin Shelar wrote:
> > > > > > > > On Tue, Dec 10, 2019 at 12:17 AM Martin Varghese
> > > > > > > > <martinvarghesenokia@gmail.com> wrote:
> > > > > > > > >
> > > > > > > > > From: Martin Varghese <martin.varghese@nokia.com>
> > > > > > > > >
> > > > > > > > > The existing PUSH MPLS & POP MPLS actions inserts & removes MPLS header
> > > > > > > > > between ethernet header and the IP header. Though this behaviour is fine
> > > > > > > > > for L3 VPN where an IP packet is encapsulated inside a MPLS tunnel, it
> > > > > > > > > does not suffice the L2 VPN (l2 tunnelling) requirements. In L2 VPN
> > > > > > > > > the MPLS header should encapsulate the ethernet packet.
> > > > > > > > >
> > > > > > > > > The new mpls actions PTAP_PUSH_MPLS & PTAP_POP_MPLS inserts and removes
> > > > > > > > > MPLS header from start of the packet respectively.
> > > > > > > > >
> > > > > > > > > PTAP_PUSH_MPLS - Inserts MPLS header at the start of the packet.
> > > > > > > > > @ethertype - Ethertype of MPLS header.
> > > > > > > > >
> > > > > > > > > PTAP_POP_MPLS - Removes MPLS header from the start of the packet.
> > > > > > > > > @ethertype - Ethertype of next header following the popped MPLS header.
> > > > > > > > >              Value 0 in ethertype indicates the tunnelled packet is
> > > > > > > > >              ethernet.
> > > > > > > > >
> > > > > > > > Did you considered using existing MPLS action to handle L2 tunneling
> > > > > > > > packet ? It can be done by adding another parameter to the MPLS
> > > > > > > > actions.
> > > > > > >
> > > > > >
> > > > > > >
> > > > > > >
> > > > > > > Not really.
> > > > > > >
> > > > > > > Are you suggesting to extend the ovs_action_push_mpls and similarly for pop
> > > > > > >
> > > > > > > struct ovs_action_push_mpls {
> > > > > > >         __be32 mpls_lse;
> > > > > > >         __be16 mpls_ethertype; /* Either %ETH_P_MPLS_UC or %ETH_P_MPLS_MC */
> > > > > > > +        bool l2_tunnel;
> > > > > > > };
> > > > > > >
> > > > > > > Does not that break the compatibilty with the existing userspace
> > > > > > > OVS ?
> > > > > > >
> > > > > > Right, extending this would not look good. I am fine with new action.
> > > > > > But we can design this new action as superset of existing and PTAP
> > > > > > functionality, This way in future we can deprecate existing MPLS
> > > > > > action in favor of new action.
> > > > > > I think if you add mac_len parameter for the action it would take case
> > > > > > of both cases.
> > > > > Yes i guess so.
> > > > > On the similar lines i guess we dont need a new PTAP_POP action as the existing
> > > > > pop action pops mpls header from the start of the packet if the skb->mac_len=0
> > > > > We just neeed a add a special handling for ethertype 0 is the existing pop
> > > > > implementation
> > > >
> > > > Passing next_proto as zero to skb_mpls_pop() would set skb->protocol
> > > > to zero. That does not look good. Lets pass mac_len and next_proto for
> > > > both Push and Pop action. I am also fine using using boolean to
> > > > distinguish between L2 and L3 case. In that case we are dependent on
> > > > skb->mac_len.
> > >
> > > But setting to zero may be appropriate ? (a kind of reset of the protocol)
> > > Normally skb->protocol holds the ethertype, but in this case we have a ethernet
> > > header after the MPLS header and we need to read that ethernet header to
> > > find the ethertype.
> > > Also if we decide the caller has to pass the ethertype as it is in normal pop
> > > along with a l2 flag, which ethertype the skb_mpls_pop caller will pass.
> > >
> > > Or should the caller pass the trans ether bridging ethertype 0x6558.In that
> > > case we may not need a flag, but i am not sure if using 0x6558 is correct here.
> > >
> > The inner packet type needs to be part of MPLS pop action. We can not
> > assume it would be ethernet packet. Otherwise OVS will not be able to
> > support multiple tagged packets for L2 MPLS tunneling.
>
> I am not sure if i got you comment correctly ?
>
> We are not assuming the inner packet is ethernet always.We are just retriggring the
> parsing with ethernet header if ethertype is 0
>
> By multiple tagged packets you mean below
>
> MPLS 1|MPLS 2| ethernet--|
>
> But in this case ethertype passed to pop action will be 0x8847 or 0x8848 and not 0.
>
>
ok.

> My other doubt is If we use a flag to say it is a l2 tunnel.
> what the caller  will pass in ethertype.and subsequently what we will set in openvswitch.

I do not like creating special case for ethernet packet. OVS can pass
ethertype in the POP action parameter. That way skb-protocol would
have correct value when OVS pop MPLS header from L2 tunnel packet.

Second issue is inconsistency between  PUSH  and POP action. This
patch is using mac_len from action parameter in Push but for POP
action it is using skb->mac_len.
