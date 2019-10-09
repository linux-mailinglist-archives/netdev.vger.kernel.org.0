Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADE57D13CC
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 18:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731669AbfJIQPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 12:15:51 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:40042 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730503AbfJIQPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 12:15:50 -0400
Received: by mail-yb1-f195.google.com with SMTP id s7so917863ybq.7
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 09:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cj7K8p+MlYY5RYfCseJiDFAEVMKDCN6YQmt8Ip5TnZ0=;
        b=E3zm1AygdxFAWiIez3MlJi3kKfwCI+flTDQJAfU5YAFICeIrq0OoTxq6WroOQfnBcC
         SfS4OLT0qTSzxl1Begn1Jv+zSyxl7EQ0u/mT+bNuLoshn3/ihSHkX+8shg/1xE3VkKyJ
         4jQ8aqvh7sQa/9y7sHjnwbMmMhm0H6N9dcoFWj8liAKXL6Y2lQ24ekp47ph5VsjKCQSq
         9GOOverlV4da5Y9ciEVYG3fvwj2mAmG5mo4mY6LjeuK++awAYIgLCca1IcKnVjQr98zE
         36q2xcc6QksqZFlF1o3HCPNEGWsWoXETfxkLd/8Lqv47XJw5WRb5VmjiNg2U2lP2jItF
         OpTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cj7K8p+MlYY5RYfCseJiDFAEVMKDCN6YQmt8Ip5TnZ0=;
        b=L7cHrhQ24ho+LAdJ6rFj79dGP8Z3nr8HubcsiaAWOMt71XbLFRwqIr7JyY3ycwCvCU
         jN5TQ8aVxF+IPtCQK/tl7X3Vd2NCHthhNLVQCeVQt0V2gyvi0YXcZj19aHTwchbDV3+W
         sIj4yE90DzZpKacVsKCWynrZ+AFTrl864yDenLnLJeTH4Tv0JU725o08XurHh9rdZhL6
         0Y+DSZ/BR9Z4uRwS4kyKNYOiObVWNFGamy6e72RqwaLw66dg1jALD1e4/IHuKvqijCPR
         Q4SHzsskZnI3mJy4ZCvq6dv3D1g7hqNF9cviun9mZOtlfccUpie8wVK5HffF8JYEf+ar
         oPLQ==
X-Gm-Message-State: APjAAAUfvWhnuiHLC654W+ZmfAQokkQR/IU5Cq12lG6zQcWxO2I/d4lJ
        UcKXz3YD3sRPZ9VfM0IFuaR+cGdI
X-Google-Smtp-Source: APXvYqxiCFDLbhTookp4qJ89ue642dh9CKLBYaqTqpAQ9tIO9uY0BBBlezKvqrSteliyJS4hcqNRjQ==
X-Received: by 2002:a25:a423:: with SMTP id f32mr2606274ybi.30.1570637748298;
        Wed, 09 Oct 2019 09:15:48 -0700 (PDT)
Received: from mail-yw1-f44.google.com (mail-yw1-f44.google.com. [209.85.161.44])
        by smtp.gmail.com with ESMTPSA id l24sm746954ywh.108.2019.10.09.09.15.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 09:15:47 -0700 (PDT)
Received: by mail-yw1-f44.google.com with SMTP id l64so896892ywe.13
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 09:15:46 -0700 (PDT)
X-Received: by 2002:a81:578c:: with SMTP id l134mr3377731ywb.357.1570637746409;
 Wed, 09 Oct 2019 09:15:46 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1570455278.git.martinvarghesenokia@gmail.com>
 <5979d1bf0b5521c66f2f6fa31b7e1cbdddd8cea8.1570455278.git.martinvarghesenokia@gmail.com>
 <CA+FuTSc=uTot72dxn7VRfCv59GcfWb32ZM5XU1_GHt3Ci3PL_A@mail.gmail.com>
 <20191009124814.GB17712@martin-VirtualBox> <CA+FuTSdGR2G8Wp0khT9nCD49oi2U_GZiyS5vJTBikPRm+0fGPg@mail.gmail.com>
 <20191009174216.1b3dd3dc@redhat.com>
In-Reply-To: <20191009174216.1b3dd3dc@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 9 Oct 2019 12:15:10 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeYVtaDYhGVg8Cvo9BZGe3TUgDaWP58cJrQ3+-=T4SnnA@mail.gmail.com>
Message-ID: <CA+FuTSeYVtaDYhGVg8Cvo9BZGe3TUgDaWP58cJrQ3+-=T4SnnA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
To:     Jiri Benc <jbenc@redhat.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Martin Varghese <martinvarghesenokia@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, corbet@lwn.net,
        scott.drennan@nokia.com, martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 9, 2019 at 11:42 AM Jiri Benc <jbenc@redhat.com> wrote:
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

That's an interesting point. Is lwtunnel support actually
something that should carry over to fou?

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
> payload.

FOU encapsulates L3, no different than IPIP or GRE?

> VXLAN and Geneve encapsulate L2 payload (or L3 payload for
> VXLAN-GPE).
>
> I agree that VXLAN, Geneve and the proposed bareudp module have
> duplicated code. The solution is to factoring it out to a common
> location.

That sounds fine. The crux is that there really are use cases besides MPLS.

> > I think it will be preferable to work the other way around and extend
> > existing ip tunnel infra to add MPLS.
>
> You see, that's the problem: this is not IP tunneling.

 GRE also supports ETH_P_TEB, using the shared ip tunnel infrastructure.
