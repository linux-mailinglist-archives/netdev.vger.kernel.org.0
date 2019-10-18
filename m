Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA4C3DCFCC
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 22:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440062AbfJRUMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 16:12:03 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35088 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394929AbfJRUMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 16:12:02 -0400
Received: by mail-ed1-f67.google.com with SMTP id v8so5546173eds.2
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 13:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7en786k5wxhRfzAyZJlq2as2o3NHruwi2vJIOxR1nWo=;
        b=kE14HcaaHgTgc4z4VETj8qmCj+fvlvgrsLOUy9ZS7Tgb5FQx24A8dsR3QS2/+oBrn5
         0E61sqe+HpEGq6zFD97BtRw/UMIDgfWxVXj7Qb4c/bgE3tVxlRtFo7NdCir/zlN4kSBg
         2CoG150vEUh0u74Xhcnvb1MvQ57ZQkA2FiMEpTx3+rFrasyHxz/KjlxVQ+djSHyCRiY+
         UVIVakMJhbLA8yw4zmr4cO2Ro5+7oYmjBJxbpm/ZjzL8vjcSJPIFkl4rNZRsARfp2Xc0
         Sgy06clghn3M0nECntl4YylxXrG6byKVgI8qjSf2df/MiRxoZ+RQB9oYmg7pyx4eFeqF
         qyiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7en786k5wxhRfzAyZJlq2as2o3NHruwi2vJIOxR1nWo=;
        b=KgoVgTHgb/e70NkJU3a++Kq7pJXC1+W1WBPqWhWhbEJyB6ySuhz6xMWXjvrE2tLNjM
         PBdaFMy5YqVd/nSvSmBsXa9ZKp1b7P2KotN4qa1dFC2Py3BWCZPWkU4afytMjGuUKft1
         qQPI8fH8B3N3/luYedrI/fgckpqCV8HzML+FO58wOAAWGHvl1LMI4o51KMxvsoF7AfoF
         XsfOgpZGwoq7s1iqC8rLMVYYS/oeJCM6e/2fCO1SnvSQ4/uPnrsryb/CQCgJQSyO7OE2
         9xAfUry9jluLIta4MgLg0EwLEBbN6kBcUtnfsteQAQpSUjOCBtw1eYCpQ1Xcs9sbjGJ3
         +TqQ==
X-Gm-Message-State: APjAAAU0T6gTW5rxmfH+Dfrory3dxVufiyIblA1BP+TuXCaRdWoILHRG
        i1yDVXS0ZKohlEvgtw9JMWg05dXgHeMTw5OVbC++Yg==
X-Google-Smtp-Source: APXvYqzWEeCyrhQ3TmWdgkICaFlJ5v7Hfa+hTmltkq+Bvwj5W5VyK9VBW++qSD4C8hLqQhyZ82lBRbHy8ec0ksZkHxE=
X-Received: by 2002:aa7:d8c6:: with SMTP id k6mr11685035eds.87.1571429048223;
 Fri, 18 Oct 2019 13:04:08 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
 <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
 <CA+FuTSc=uTot72dxn7VRfCv59GcfWb32ZM5XU1_GHt3Ci3PL_A@mail.gmail.com>
 <20191009124814.GB17712@martin-VirtualBox> <CA+FuTSdGR2G8Wp0khT9nCD49oi2U_GZiyS5vJTBikPRm+0fGPg@mail.gmail.com>
 <20191009174216.1b3dd3dc@redhat.com>
In-Reply-To: <20191009174216.1b3dd3dc@redhat.com>
From:   Tom Herbert <tom@herbertland.com>
Date:   Fri, 18 Oct 2019 13:03:56 -0700
Message-ID: <CALx6S342=MKHK35=H+2xMW9odHKMj7A5Ws+kNVGxzTDFnxdsPQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
To:     Jiri Benc <jbenc@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Martin Varghese <martinvarghesenokia@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, scott.drennan@nokia.com,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 9, 2019 at 8:42 AM Jiri Benc <jbenc@redhat.com> wrote:
>
> On Wed, 9 Oct 2019 10:58:51 -0400, Willem de Bruijn wrote:
> > Yes, this needs a call to gro_cells_receive like geneve_udp_encap_recv
> > and vxlan_rcv, instead of returning a negative value back to
> > udp_queue_rcv_one_skb. Though that's not a major change.
>
> Willem, how would you do that? The whole fou code including its netlink
> API is built around the assumption that it's L4 encapsulation. I see no
> way to extend it to do L3 encapsulation without major hacks - in fact,
> you'll add all that Martin's patch adds, including a new netlink API,
> but just mix that into fou.c.
>
More specifically fou allows encapsulation of anything that has an IP
protocol number. That includes an L3 protocols that have been assigned
a number (e.g. MPLS, GRE, IPv6, IPv4, EtherIP). So the only need for
an alternate method to do L3 encapsulation would be for those
protocols that don't have an IP protocol number assignment.
Presumably, those just have an EtherType. In that case, it seems
simple enough to just extend fou to processed an encapsulated
EtherType. This should be little more than modifying the "struct fou"
to hold 16 bit EtherType (union with protocol), adding
FOU_ENCAP_ETHER, corresponding attribute, and then populate
appropriate receive functions for the socket.

Tom

> > Transmit is easier. The example I shared already encapsulates packets
> > with MPLs and sends them through a tunnel device. Admittedly using
> > mpls routing. But the ip tunneling infrastructure supports adding
> > arbitrary inner headers using ip_tunnel_encap_ops.build_header.
> > net/ipv4/fou.c could be extended with a mpls_build_header alongside
> > fou_build_header and gue_build_header?
>
> The nice thing about the bareudp tunnel is that it's generic. It's just
> (outer) UDP header followed by (inner) L3 header. You can use it for
> NSH over UDP. Or for multitude of other purposes.
>
> What you're proposing is MPLS only. And it would require similar amount
> of code as the bareudp generic solution. It also doesn't fit fou
> design: MPLS is not an IP protocol. Trying to add it there is like
> forcing a round peg into a square hole. Just look at the code.
> Start with parse_nl_config.
>
> > Extending this existing code has more benefits than code reuse (and
> > thereby fewer bugs), it also allows reusing the existing GRO logic,
> > say.
>
> In this case, it's the opposite: trying to retrofit L3 encapsulation
> into fou is going to introduce bugs.
>
> Moreover, given the expected usage of bareudp, the nice benefit is it's
> lwtunnel only. No need to carry all the baggage of standalone
> configuration fou has.
>
> > At a high level, I think we should try hard to avoid duplicating
> > tunnel code for every combination of inner and outer protocol.
>
> Yet you're proposing to do exactly that with special casing MPLS in fou.
>
> I'd say bareudp is as generic as you could get it. It allows any L3
> protocol inside UDP. You can hardly make it more generic than that.
> With ETH_P_TEB, it could also encapsulate Ethernet (that is, L2).
>
> > Geneve
> > and vxlan on the one hand and generic ip tunnel and FOU on the other
> > implement most of these features. Indeed, already implements the
> > IPxIPx, just not MPLS. It will be less code to add MPLS support based
> > on existing infrastructure.
>
> You're mixing apples with oranges. IP tunnels and FOU encapsulate L4
> payload. VXLAN and Geneve encapsulate L2 payload (or L3 payload for
> VXLAN-GPE).
>
> I agree that VXLAN, Geneve and the proposed bareudp module have
> duplicated code. The solution is to factoring it out to a common
> location.
>
> > I think it will be preferable to work the other way around and extend
> > existing ip tunnel infra to add MPLS.
>
> You see, that's the problem: this is not IP tunneling.
>
>  Jiri
