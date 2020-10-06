Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6BE2852CB
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 22:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgJFUDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 16:03:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39119 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726073AbgJFUDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 16:03:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602014581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6a90iXuYIfc2lXzvrQPqamRws2yO0e6dZUAhB+100sg=;
        b=XKh+y0DfI1i8ARHMsQ12wzTZsvJLkwGdjnv1OHpicuFeNTlUuQIP4baqBfLh45d0VLtVsn
        RBs6spoc2henlaZ0J1qGoIQd86qa2+UQz7wLxQArKGauombESfOXvC2D4Z7Suq/bRGQfB+
        ACZ4I8lq5oEQ1evBPkymUt2njT7btuk=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-hCxzt5uQMWOrpjmMKILAaQ-1; Tue, 06 Oct 2020 16:02:59 -0400
X-MC-Unique: hCxzt5uQMWOrpjmMKILAaQ-1
Received: by mail-ej1-f72.google.com with SMTP id j7so3092697ejy.7
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 13:02:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6a90iXuYIfc2lXzvrQPqamRws2yO0e6dZUAhB+100sg=;
        b=uPieWJa7BOgD2AMo8cBsAZcIi+4jnFOkgfiUstT6jxaKytAZ9pFolrJhR9pB17HxI5
         w3segldXs6z/Hl9ceRn3AJ8V1MC4yuP+XyLKKWQm82B9b4jxejciOoTPJCqLzDKqi8Iq
         8CIOPfXg4wEejviIzfDuSVvjtDUeIbMhNNWeU0+hB/fNS8W1/7HB2h2KmP4W9ifV+++I
         lNJ6iFiBXjxku7CvtgjHSdlM4nfXjxoXnsaaWq1E4B7zjGLnr2Us0bHnTS3AB3kLLZx/
         NLml0G18fSngM+yvKbZeA5oCDCSdwEVQWC1N/nmaKd+YHbSVL3L9G1TbCtLR+HIH0ciL
         uQVg==
X-Gm-Message-State: AOAM532UTzvncrYTaFldOYTGFou91xkznjrR+3xvbYdjRgagQ6nR1ntM
        eKFFHQ+ZabaM1BC9V+IGbeXwVYBtUnAQ1/0l2mpq7UoUE1jCSigPJDReX68jSrPJbcbekW3ZHp/
        dtx6XFL0cCgAt8WnEUHMAPTN8DRFwbXm3
X-Received: by 2002:a17:906:8297:: with SMTP id h23mr1204448ejx.383.1602014578209;
        Tue, 06 Oct 2020 13:02:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyRsZtISY9HgE9z0z/l8sqdVf9lfzmEIQaq0E76gtNxygj+0uqGm1RDRbD8FUMo+vofJI9o0VGl+azEZVI+Uag=
X-Received: by 2002:a17:906:8297:: with SMTP id h23mr1204410ejx.383.1602014577844;
 Tue, 06 Oct 2020 13:02:57 -0700 (PDT)
MIME-Version: 1.0
References: <20201006083355.121018-1-nusiddiq@redhat.com> <20201006111606.GA18203@breakpoint.cc>
 <CAH=CPzr58cyTFUre=3LrJh6=NyjWKqnmNBBSz0ogRjefDXEq6w@mail.gmail.com> <20201006185204.GG5213@breakpoint.cc>
In-Reply-To: <20201006185204.GG5213@breakpoint.cc>
From:   Numan Siddique <nusiddiq@redhat.com>
Date:   Wed, 7 Oct 2020 01:32:46 +0530
Message-ID: <CAH=CPzqSsnJK10+ei6f3qV3ZQ5iqkZQQ0XVkHXWpsnO18=K-0g@mail.gmail.com>
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

On Wed, Oct 7, 2020 at 12:22 AM Florian Westphal <fw@strlen.de> wrote:
>
> Numan Siddique <nusiddiq@redhat.com> wrote:
> > On Tue, Oct 6, 2020 at 4:46 PM Florian Westphal <fw@strlen.de> wrote:
> > >
> > > nusiddiq@redhat.com <nusiddiq@redhat.com> wrote:
> > > > From: Numan Siddique <nusiddiq@redhat.com>
> > > >
> > > > For a tcp packet which is part of an existing committed connection,
> > > > nf_conntrack_in() will return err and set skb->_nfct to NULL if it is
> > > > out of tcp window. ct action for this packet will set the ct_state
> > > > to +inv which is as expected.
> > >
> > > This is because from conntrack p.o.v., such TCP packet is NOT part of
> > > the existing connection.
> > >
> > > For example, because it is considered part of a previous incarnation
> > > of the same connection.
> > >
> > > > But a controller cannot add an OVS flow as
> > > >
> > > > table=21,priority=100,ct_state=+inv, actions=drop
> > > >
> > > > to drop such packets. That is because when ct action is executed on other
> > > > packets which are not part of existing committed connections, ct_state
> > > > can be set to invalid. Few such cases are:
> > > >    - ICMP reply packets.
> > >
> > > Can you elaborate? Echo reply should not be invalid. Conntrack should
> > > mark it as established (unless such echo reply came out of the blue).
> >
> > Hi Florian,
> >
> > Thanks for providing the comments.
> >
> > Sorry for not being very clear.
> >
> > Let me brief about the present problem we see in OVN (which is a
> > controller using ovs)
> >
> > When a VM/container sends a packet (in the ingress direction), we don't send all
> > the packets to conntrack. If a packet is destined to an OVN load
> > balancer virtual ip,
> > only then we send the packet to conntrack in the ingress direction and
> > then we do dnat
> > to the backend.
>
> Ah, okay.  That explains the INVALID then, but in that case I think this
> patch/direction is less desirable from conntrack point of view.
>
> More below.
>
> > table=1, match = (ip && ip4.dst == VIP) action = ct(table=2)
> > tablle=2, ct_state=+new+trk && ip4.dst == VIP, action = ct(commit,
> > nat=BACKEND_IP)
> > ...
> > ..
> >
> > However for the egress direction (when the packet is to be delivered
> > to the VM/container),
> > we send all the packets to conntrack and if the ct.est is set, we do
> > undnat before delivering
> > the packet to the VM/container.
> > ...
> > table=40, match = ip, action = ct(table=41)
> > table=41, match = ct_state=+est+trk, action = ct(nat)
> > ...
> >
> > What I mean here is that, since we send all the packets in the egress
> > pipeline to conntrack,
> > we can't add a flow like - match = ct_state=+inv, action = drop.
>
> Basically this is like a normal routing/netfitler (no ovs), where
> the machine in question only sees unidirectional traffic (reply packets
> taking different route).
>
> > i.e When a VM/container sends an ICMP request packet, it will not be
> > sent to conntrack, but
> > the reply ICMP will be sent to conntrack and it will be marked as invalid.
>
> Yes.  For plain netfilter, the solution would be to accept INVALID icmp
> replies in the iptables/nftables ruleset.
>
> > So is the case with TCP, the TCP SYN from the VM is not sent to
> > conntrack, but the SYN/ACK
> > from the server would be sent to conntrack and it will be marked as invalid.
>
> Right.
>
> > > 1. packet was not even seen by conntrack
> > > 2. packet matches existing connection, but is "bad", for example:
> > >   - contradicting tcp flags
> > >   - out of window
> > >   - invalid checksum
> >
> > We want the below to be solved (using OVS flows) :
> >   - If the packet is marked as invalid due to (2) which you mentioned above,
> >     we would like to read the ct_mark and ct_label fields as the packet is
> >     part of existing connection, so that we can add an OVS flow like
> >
> > ct_state=+inv+trk,ct_label=0x2 actions=drop
>
> Wouldn't it make more sense to let tcp conntrack skip the in-window
> check?  AFAIU thats the only problem and its identical to other cases
> that we have at the moment, for example, conntrack supports mid-stream
> pickup (on by default) which also disables tcp window checks.
>
> > I tested by setting 'be_liberal' sysctl flag and since skb->_nfct was
> > set for (2), OVS
> > datapath module set the ct_state to +est.
>
> Yes.  This flag can be set programatically on a per-ct basis.
>
> See nft_flow_offload_eval() for example (BE_LIBERAL).
> Given we now have multiple places that set this I think it would make
> sense to add a helper, say, e.g.
>
> void nf_ct_tcp_be_liberal(struct nf_conn *ct);
> ?
>
> (Or perhaps nf_ct_tcp_disable_window_checks() , might be more
>  clear/descriptive as to what this is doing).
>
> Do you think that this resolves the OVN problem?

Thanks for the comments. I think this should resolve the problem for OVN.

Numan

>

