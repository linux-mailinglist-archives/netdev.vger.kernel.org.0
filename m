Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5106284C79
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 15:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbgJFNXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 09:23:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40827 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725891AbgJFNXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 09:23:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601990593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NsNemPoDuPESIwthUg6LIILwq1aFxyoLhIfcZ08Mx1s=;
        b=IJcnDvJP+DcB6QEYGaGW/3QNHgQqHQMkR+zwDTj5jQw98F/pKd4buTi8MCefnzAgIbBCDv
        bjiXq07WdToShtOkPVOP085gkBRoy/ikGjjfZFQRQ74E1juj9U7sfVG3JP68oNTIcJKE/0
        guEjsSXeFJesu+BJi63uG9HYClCPoUw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-Z7mKOI81NWG_1-fFTNGnLA-1; Tue, 06 Oct 2020 09:23:12 -0400
X-MC-Unique: Z7mKOI81NWG_1-fFTNGnLA-1
Received: by mail-ej1-f70.google.com with SMTP id x22so3738936ejs.17
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 06:23:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NsNemPoDuPESIwthUg6LIILwq1aFxyoLhIfcZ08Mx1s=;
        b=XlU14BUWga2A4PueLddixmFSnw22kv6SX0RsgFZ8Qz4L4FVz0hsYA5bDIWk3rqI8wX
         DrGhnzg5l0CktEhhXUoRq0rIkrltnb4Ub8BpN2BROdTbABNeKfPJCTOMBL2sujUMByFV
         WpJB9TJpaNRMVZ7OmWVfYm1C/vtINWX2y362SrJShD4WXIqcOIn/I5FnNvsaTeg8LmWc
         mpVJUEDZXhJULyGvYcmAWEhtlRT/4J34I6Uj8sOmqIYYRhClVTnEsX/sRdzB3O+tlxWM
         EDYTizFAjPhmn92TzJZiWAZDUBmNdaumirw5wUxI1U5JDan+y7NN1lippKAXHnTIK4ea
         UNJg==
X-Gm-Message-State: AOAM5326cYywl1Ws6iyVKKPf5UbLPMD7mqjRqGwFKSg3p9YhdaMGZuyG
        W/cHCvuWdpOYSqaWOvkDJTfDj0Vbl6pFd6W4zWR2PJb6VLr0kn95ucIrn00SviDEuj3/kpz/HIG
        Kp5p9wo2PoJRxjd/5czdblnqcD0bI6mRa
X-Received: by 2002:a05:6402:d3:: with SMTP id i19mr5607410edu.320.1601990590619;
        Tue, 06 Oct 2020 06:23:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1LfdYlZ2D2ehQMRrL3HaSvFq+E5XIyfgzfLiUW6I4rTdEk5oACOE0+rUh5d6NFqH5unJLjwa7OMXP+f+xaxA=
X-Received: by 2002:a05:6402:d3:: with SMTP id i19mr5607372edu.320.1601990590281;
 Tue, 06 Oct 2020 06:23:10 -0700 (PDT)
MIME-Version: 1.0
References: <20201006083355.121018-1-nusiddiq@redhat.com> <20201006111606.GA18203@breakpoint.cc>
 <CAH=CPzr58cyTFUre=3LrJh6=NyjWKqnmNBBSz0ogRjefDXEq6w@mail.gmail.com>
In-Reply-To: <CAH=CPzr58cyTFUre=3LrJh6=NyjWKqnmNBBSz0ogRjefDXEq6w@mail.gmail.com>
From:   Numan Siddique <nusiddiq@redhat.com>
Date:   Tue, 6 Oct 2020 18:52:58 +0530
Message-ID: <CAH=CPzo6Y75S5TQGyr48ef3tcva_rGDBwkn1GygXLjpZbgjuZQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: openvswitch: Add support to lookup invalid
 packet in ct action.
To:     Florian Westphal <fw@strlen.de>
Cc:     ovs dev <dev@openvswitch.org>, netdev <netdev@vger.kernel.org>,
        davem@davemloft.net, Aaron Conole <aconole@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 6, 2020 at 5:49 PM Numan Siddique <nusiddiq@redhat.com> wrote:
>
> On Tue, Oct 6, 2020 at 4:46 PM Florian Westphal <fw@strlen.de> wrote:
> >
> > nusiddiq@redhat.com <nusiddiq@redhat.com> wrote:
> > > From: Numan Siddique <nusiddiq@redhat.com>
> > >
> > > For a tcp packet which is part of an existing committed connection,
> > > nf_conntrack_in() will return err and set skb->_nfct to NULL if it is
> > > out of tcp window. ct action for this packet will set the ct_state
> > > to +inv which is as expected.
> >
> > This is because from conntrack p.o.v., such TCP packet is NOT part of
> > the existing connection.
> >
> > For example, because it is considered part of a previous incarnation
> > of the same connection.
> >
> > > But a controller cannot add an OVS flow as
> > >
> > > table=21,priority=100,ct_state=+inv, actions=drop
> > >
> > > to drop such packets. That is because when ct action is executed on other
> > > packets which are not part of existing committed connections, ct_state
> > > can be set to invalid. Few such cases are:
> > >    - ICMP reply packets.
> >
> > Can you elaborate? Echo reply should not be invalid. Conntrack should
> > mark it as established (unless such echo reply came out of the blue).
>
> Hi Florian,
>
> Thanks for providing the comments.
>
> Sorry for not being very clear.
>
> Let me brief about the present problem we see in OVN (which is a
> controller using ovs)
>
> When a VM/container sends a packet (in the ingress direction), we don't send all
> the packets to conntrack. If a packet is destined to an OVN load
> balancer virtual ip,
> only then we send the packet to conntrack in the ingress direction and
> then we do dnat
> to the backend.
>
> Eg. in the ingress direction
>
> table=1, match = (ip && ip4.dst == VIP) action = ct(table=2)
> tablle=2, ct_state=+new+trk && ip4.dst == VIP, action = ct(commit,
> nat=BACKEND_IP)
> ...
> ..
>
> However for the egress direction (when the packet is to be delivered
> to the VM/container),
> we send all the packets to conntrack and if the ct.est is set, we do
> undnat before delivering
> the packet to the VM/container.
> ...
> table=40, match = ip, action = ct(table=41)
> table=41, match = ct_state=+est+trk, action = ct(nat)
> ...
>
> What I mean here is that, since we send all the packets in the egress
> pipeline to conntrack,
> we can't add a flow like - match = ct_state=+inv, action = drop.
>
> i.e When a VM/container sends an ICMP request packet, it will not be
> sent to conntrack, but
> the reply ICMP will be sent to conntrack and it will be marked as invalid.
>
> So is the case with TCP, the TCP SYN from the VM is not sent to
> conntrack, but the SYN/ACK
> from the server would be sent to conntrack and it will be marked as invalid.
>
> >
> > >    - TCP SYN/ACK packets during connection establishment.
> >
> > SYN/ACK should also be established state.
> > INVALID should only be matched for packets that were never seen
> > by conntrack, or that are deemed out of date / corrupted.
> >
> > > To distinguish between an invalid packet part of committed connection
> > > and others, this patch introduces as a new ct attribute
> > > OVS_CT_ATTR_LOOKUP_INV. If this is set in the ct action (without commit),
> > > it tries to find the ct entry and if present, sets the ct_state to
> > > +inv,+trk and also sets the mark and labels associated with the
> > > connection.
> > >
> > > With this,  a controller can add flows like
> > >
> > > ....
> > > ....
> > > table=20,ip, action=ct(table=21, lookup_invalid)
> > > table=21,priority=100,ct_state=+inv+trk,ct_label=0x2/0x2 actions=drop
> > > table=21,ip, actions=resubmit(,22)
> > > ....
> > > ....
> >
> > What exactly is the feature/problem that needs to be solved?
> > I suspect this would help me to provide better feedback than the
> > semi-random comments below .... :-)
> >
> > My only problem with how conntrack does things ATM is that the ruleset
> > cannot distinguish:
> >
> > 1. packet was not even seen by conntrack
> > 2. packet matches existing connection, but is "bad", for example:
> >   - contradicting tcp flags
> >   - out of window
> >   - invalid checksum
>
> We want the below to be solved (using OVS flows) :
>   - If the packet is marked as invalid due to (2) which you mentioned above,
>     we would like to read the ct_mark and ct_label fields as the packet is
>     part of existing connection, so that we can add an OVS flow like
>
> ct_state=+inv+trk,ct_label=0x2 actions=drop
>
> Right now it is not possible.

I forgot to mention the side effect of it. Since the tcp out of window packet
is set as +inv, this packet is delivered to the VM/container without undnat
and because of this VM/container resets the connection.

Thanks
Numan



>
> This patch does another lookup if skb->_nfct is NULL after
> nf_conntrack_in() to check
> if (2) is the case. If the lookup is successful, it updates the ct flow
> key with the ct_mark and ct_label. This is made optional using a
> netlink attribute.
>
> I'm not sure if it's possible for nf_conntrack_in() to provide this
> information for
> its callers so that the caller can come to know that the state is
> invalid because of (2).
>
> I tested by setting 'be_liberal' sysctl flag and since skb->_nfct was
> set for (2), OVS
> datapath module set the ct_state to +est.
>
> Thanks
> Numan
>
>
> >
> > There are a few sysctls to modify default behaviour, e.g. relax window
> > checks, or ignore/skip checksum validation.
> >
> > The other problem i see (solveable for sure by yet-another-sysctl but i
> > see that as last-resort) is usual compatibility problem:
> >
> > ct state invalid drop
> > ct mark gt 0 accept
> >
> > If standard netfilter conntrack were to set skb->_nfct e.g. even if
> > state is invalid, we could still make the above work via some internal
> > flag.
> >
> > But if you reverse it, you get different behaviour:
> >
> > ct mark gt 0 accept
> > ct state invalid drop
> >
> > First rule might now accept out-of-window packet even when "be_liberal"
> > sysctl is off.
> >

