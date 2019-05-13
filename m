Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAEC1BF11
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 23:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfEMVW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 17:22:26 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34680 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbfEMVW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 17:22:26 -0400
Received: by mail-ed1-f68.google.com with SMTP id p27so19611953eda.1;
        Mon, 13 May 2019 14:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2coYDvq4y8tQwP4K7Gw4Yl+aDD8cCrkEgdzat6PFkrw=;
        b=icd6D5Z2opnI+5ixNfQSVKJHV4+4XVFPb/PK+8EVGh4sbMyaI5bOvRU53csvDAWvqA
         NRuj+w/+Fn1qehtjtCD6M4pIi8won8gtt5Z12hi6HxkrlSAytTXJ/+pVwSRxbjWS7E9o
         pGrsPesurElYZRkMR7bAPU4b63smdfh4QPkfoTzTIb258AZFZxCP232BGetVVU3IMOtm
         xGepuMPMdrWFn2vJoWTrBybTLATI2au0LeHYNhZ99QzHPmvyPeqqlUP+UJw3GDQX5MKL
         E6NAM6pTVTOukkSLibPOFPPavf2pZasy+krnTDtuOAXSJBt+fyycdFPrqxJAfkvWFIgV
         /ACQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2coYDvq4y8tQwP4K7Gw4Yl+aDD8cCrkEgdzat6PFkrw=;
        b=mJvlyBOL18UZ1SrA8hcA0UPJ+d8L3MjmR+DVFo/Pu329TUBFkxdW7IUTwuRRhdtKTU
         Ce0Be63jpiFdTdMP1KvZr6pRzq2c4rQw1JiLvMiZQkTpSWtIRsEGOP+l0a9dxgHfWOFl
         /a0lGfjS6ltlmBEssk11RXJcytWOVDfOIAy1MTzem5RAvbR0qoGMU0g+eCJy0iZDwnpi
         7dmkkS3giPoZ9zja/fZ3N39SVpDYUmMExKJMC5ldS0736Wtw9IUDuQJ0yE7nngJwF8mj
         Et57PxhqdPlJgKjsm+6ilV4eKm+OtuspQKpA0CW7mC0tMJRj+q5KYT5hFiohrrBAfnYs
         ryQA==
X-Gm-Message-State: APjAAAVH4Ju0qDCFwHrQnpFJXTAl70szjn545LCRfXU8IDD1mWMFRRnU
        hJxPcGrD0dedtCSjpW3E7Kx5gN7U/s2LUOsZbgM=
X-Google-Smtp-Source: APXvYqw+uVUjFLg8baFz4VR9H5QI3UGBZScRvUW77jpU744ONyxsB858ImzRpgvgtCW9EDuc7fhHq3P45oHhEOm9X/s=
X-Received: by 2002:a17:906:24d8:: with SMTP id f24mr4291083ejb.1.1557782544257;
 Mon, 13 May 2019 14:22:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190513185402.220122-1-sdf@google.com> <CAF=yD-LO6o=uZ-aT-J9uPiBcO4f2Zc9uyGZ+f7M7mPtRSB44gA@mail.gmail.com>
 <20190513210239.GC24057@mini-arch>
In-Reply-To: <20190513210239.GC24057@mini-arch>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 13 May 2019 17:21:48 -0400
Message-ID: <CAF=yD-JKbzuoF_q7gPRjMNCBexn4pxgQ6pTeQSRfPXmwWk5dzg@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] flow_dissector: support FLOW_DISSECTOR_KEY_ETH_ADDRS
 with BPF
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 13, 2019 at 5:02 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 05/13, Willem de Bruijn wrote:
> > On Mon, May 13, 2019 at 3:53 PM Stanislav Fomichev <sdf@google.com> wrote:
> > >
> > > If we have a flow dissector BPF program attached to the namespace,
> > > FLOW_DISSECTOR_KEY_ETH_ADDRS won't trigger because we exit early.
> >
> > I suppose that this is true for a variety of keys? For instance, also
> > FLOW_DISSECTOR_KEY_IPV4_ADDRS.

> I though the intent was to support most of the basic stuff (eth/ip/tcp/udp)
> without any esoteric protocols.

Indeed. But this applies both to protocols and the feature set. Both
are more limited.

> Not sure about FLOW_DISSECTOR_KEY_IPV4_ADDRS,
> looks like we support that (except FLOW_DISSECTOR_KEY_TIPC part).

Ah, I chose a bad example then.

> > We originally intended BPF flow dissection for all paths except
> > tc_flower. As that catches all the vulnerable cases on the ingress
> > path on the one hand and it is infeasible to support all the
> > flower features, now and future. I think that is the real fix.

> Sorry, didn't get what you meant by the real fix.
> Don't care about tc_flower? Just support a minimal set of features
> needed by selftests?

I do mean exclude BPF flow dissector (only) for tc_flower, as we
cannot guarantee that the BPF program can fully implement the
requested feature.

>
> > >
> > > Handle FLOW_DISSECTOR_KEY_ETH_ADDRS before BPF and only if we have
> > > an skb (used by tc-flower only).
> > >
> > > Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
> > > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >  net/core/flow_dissector.c | 23 ++++++++++++-----------
> > >  1 file changed, 12 insertions(+), 11 deletions(-)
> > >
> > > diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> > > index 9ca784c592ac..ba76d9168c8b 100644
> > > --- a/net/core/flow_dissector.c
> > > +++ b/net/core/flow_dissector.c
> > > @@ -825,6 +825,18 @@ bool __skb_flow_dissect(const struct net *net,
> > >                         else if (skb->sk)
> > >                                 net = sock_net(skb->sk);
> > >                 }
> > > +
> > > +               if (dissector_uses_key(flow_dissector,
> > > +                                      FLOW_DISSECTOR_KEY_ETH_ADDRS)) {
> > > +                       struct ethhdr *eth = eth_hdr(skb);
> >
> > Here as well as in the original patch: is it safe to just cast to
> > eth_hdr? In the same file, __skb_flow_dissect_gre does test for
> > (encapsulated) protocol first.

> Good question, I guess the assumption here is that
> FLOW_DISSECTOR_KEY_ETH_ADDRS is only used by tc_flower and the appropriate
> checks should be there as well.
> It's probably better to check skb->proto here though.

Right, as a mistaken or malicious admin can request it on a non
Ethernet device and read garbage.
