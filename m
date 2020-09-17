Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5990126D903
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 12:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgIQK23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 06:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgIQK22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 06:28:28 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02F4AC06174A;
        Thu, 17 Sep 2020 03:28:28 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id a3so1900615oib.4;
        Thu, 17 Sep 2020 03:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ptYB+2YxqjfJpTc3PmxXkmZ15dGcdrLu7QLIcznhvc4=;
        b=RqHuaOdmpyOf+j9RiBUhsHFL8EkySKMFlmQy3YU7YXH3bMuPllku3LmyW5HjmL+OIA
         VFbXGQIyaNlrdI5nZ8VHuE5IkYbrMOGwdEKMCj9tH0+lWqmQ50l+5q9oV+giaoxmOGIl
         3moc1ZIjx32DLhRi7H2B8mrnhYODksHe6U0Shn12kjDImEBVvcA/MHLFFYaOpBwbNmZ+
         dlwpQgKusncXCnHNIz8F3a6fyZF1T4DNUPDC5pWloe4qfd5Y8bXkxPnXrUbXndpT2yy4
         2OVtWTcWFe1Cnzj3KQFIUa7DBOj1xskZpssewN1GMf2sxYjfEywV6Qzx+IeAvP/24Po1
         H+7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ptYB+2YxqjfJpTc3PmxXkmZ15dGcdrLu7QLIcznhvc4=;
        b=GVwGlZB/Ag1oxg1eG/DWpKKtBWGI87BlloQtOpMzIMzsK4V/gmscb6y3B4wEbLFvdx
         hE1q3iaogdl+FPJUXpUqcWNsK9y/i1qqlWuY0TPEick9NRJTerQM5WZCRsCAiowgFy1Q
         klonq7I8LIc3PrFcDvhSaZKQNI/lB0RBCqg6tFOXBkNgn3skLD5DArUqzpzk343wseoU
         u5mdE4ts6MInshIJbiIjjAcHesjCqv+/MbErQcDZy2AKtdEa1eP0yRRuj+jEO1B0BZF+
         RJxYzaynlmSJToq/L8LzrPIe/Ss75snWhlqjXg5E+9MwHpSJIGI/M47DGMxR0iRvkqSu
         nmeQ==
X-Gm-Message-State: AOAM532i8p6QxKTtT7EOPleBbbgdSgSSoPBCs6WZ6xFEwFDxHLuwFM33
        omditxs2hHwyNLeL1vFv7TAPt7aZni0KWVzhnPs=
X-Google-Smtp-Source: ABdhPJwkotvJGKJOFQiCEnpUsBRdm7f5L3y8uf9Rsa+YFS30Sm6tTvTfN4Wq9LIWloL4Rgwtkzkk+9kEOHeibWMtm6A=
X-Received: by 2002:aca:da8b:: with SMTP id r133mr5803110oig.163.1600338507323;
 Thu, 17 Sep 2020 03:28:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200904162154.GA24295@wunner.de> <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
 <20200905052403.GA10306@wunner.de> <e8aecc2b-80cb-8ee5-8efe-7ae5c4eafc70@iogearbox.net>
 <CAF90-Whc3HL9x-7TJ7m3tZp10RNmQxFD=wdQUJLCaUajL2RqXg@mail.gmail.com>
 <8e991436-cb1c-1306-51ac-bb582bfaa8a7@iogearbox.net> <CAF90-Wh=wzjNtFWRv9bzn=-Dkg-Qc9G_cnyoq0jSypxQQgg3uA@mail.gmail.com>
 <29b888f5-5e8e-73fe-18db-6c5dd57c6b4f@iogearbox.net>
In-Reply-To: <29b888f5-5e8e-73fe-18db-6c5dd57c6b4f@iogearbox.net>
From:   =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>
Date:   Thu, 17 Sep 2020 12:28:15 +0200
Message-ID: <CAF90-Wiof1aut-KoA=uA-T=UGmUpQvZx_ckwY7KnBbYB8Y3+PA@mail.gmail.com>
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lukas Wunner <lukas@wunner.de>,
        John Fastabend <john.fastabend@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On Tue, Sep 15, 2020 at 12:02 AM Daniel Borkmann <daniel@iogearbox.net> wro=
te:
>
> On 9/14/20 1:29 PM, Laura Garc=C3=ADa Li=C3=A9bana wrote:
> > On Fri, Sep 11, 2020 at 6:28 PM Daniel Borkmann <daniel@iogearbox.net> =
wrote:
> >> On 9/11/20 9:42 AM, Laura Garc=C3=ADa Li=C3=A9bana wrote:
> >>> On Tue, Sep 8, 2020 at 2:55 PM Daniel Borkmann <daniel@iogearbox.net>=
 wrote:
> >>>> On 9/5/20 7:24 AM, Lukas Wunner wrote:
> >>>>> On Fri, Sep 04, 2020 at 11:14:37PM +0200, Daniel Borkmann wrote:
> >>>>>> On 9/4/20 6:21 PM, Lukas Wunner wrote:
> >>>> [...]
> >>>>>> The tc queueing layer which is below is not the tc egress hook; th=
e
> >>>>>> latter is for filtering/mangling/forwarding or helping the lower t=
c
> >>>>>> queueing layer to classify.
> >>>>>
> >>>>> People want to apply netfilter rules on egress, so either we need a=
n
> >>>>> egress hook in the xmit path or we'd have to teach tc to filter and
> >>>>> mangle based on netfilter rules.  The former seemed more straight-f=
orward
> >>>>> to me but I'm happy to pursue other directions.
> >>>>
> >>>> I would strongly prefer something where nf integrates into existing =
tc hook,
> >>>> not only due to the hook reuse which would be better, but also to al=
low for a
> >>>> more flexible interaction between tc/BPF use cases and nf, to name o=
ne
> >>>
> >>> That sounds good but I'm afraid that it would take too much back and
> >>> forth discussions. We'll really appreciate it if this small patch can
> >>> be unblocked and then rethink the refactoring of ingress/egress hooks
> >>> that you commented in another thread.
> >>
> >> I'm not sure whether your comment was serious or not, but nope, this n=
eeds
> >> to be addressed as mentioned as otherwise this use case would regress.=
 It
> >
> > This patch doesn't break anything. The tc redirect use case that you
> > just commented on is the expected behavior and the same will happen
> > with ingress. To be consistent, in the case that someone requires both
> > hooks, another tc redirect would be needed in the egress path. If you
> > mean to bypass the nf egress if tc redirect in ingress is used, that
> > would lead in a huge security concern.
>
> I'm not sure I parse what you're saying above ... today it is possible an=
d
> perfectly fine to e.g. redirect to a host-facing veth from tc ingress whi=
ch
> then goes into container. Only traffic that goes up the host stack is see=
n
> by nf ingress hook in that case. Likewise, reply traffic can be redirecte=
d
> from host-facing veth to phys dev for xmit w/o any netfilter interference=
.
> This means netfilter in host ns really only sees traffic to/from host as
> intended. This is fine today, however, if 3rd party entities (e.g. distro
> side) start pushing down rules on the two nf hooks, then these use cases =
will
> break on the egress one due to this asymmetric layering violation. Hence =
my
> ask that this needs to be configurable from a control plane perspective s=
o
> that both use cases can live next to each other w/o breakage. Most trivia=
l

Why does it should be symmetric? Fast-paths create "asymmetric
layering" continuously, see: packet hit XDP to user space bypassing
ingress, but in the response will hit egress. So the "breakage" is
already there.

Also, we're here to create mechanisms not policies that distros have to fol=
low.

> one I can think of is (aside from the fact to refactor the hooks and impr=
ove
> their performance) a flag e.g. for skb that can be set from tc/BPF layer =
to
> bypass the nf hooks. Basically a flexible opt-in so that existing use-cas=
es
> can be retained w/o breakage. This is one option with what I meant in my
> earlier mail.

No comment.

>
> >> is one thing for you wanting to remove tc / BPF from your application =
stack
> >> as you call it, but not at the cost of breaking others.
> >
> > I'm not intended to remove tc / BPF from my application stack as I'm
> > not using it and, as I explained in past emails, it can't be used for
> > my use cases.
> >
> > In addition, let's review your NACK reasons:
> >
> >     This reverts the following commits:
> >
> >       8537f78647c0 ("netfilter: Introduce egress hook")
> >       5418d3881e1f ("netfilter: Generalize ingress hook")
> >       b030f194aed2 ("netfilter: Rename ingress hook include file")
> >
> >     From the discussion in [0], the author's main motivation to add a h=
ook
> >     in fast path is for an out of tree kernel module, which is a red fl=
ag
> >     to begin with. Other mentioned potential use cases like NAT{64,46}
> >     is on future extensions w/o concrete code in the tree yet. Revert a=
s
> >     suggested [1] given the weak justification to add more hooks to cri=
tical
> >     fast-path.
> >
> >       [0] https://lore.kernel.org/netdev/cover.1583927267.git.lukas@wun=
ner.de/
> >       [1] https://lore.kernel.org/netdev/20200318.011152.72770718915606=
186.davem@davemloft.net/
> >
> > It has been explained already that there are more use cases that
> > require this hook in nf, not only for future developments or out of
> > tree modules.
>
> Sure, aside from the two mentioned cases above, we scratched DHCP a littl=
e
> bit on the surface but it was found that i) you need a af_packet specific
> hook to get there instead, and ii) dhcp clients implement their own filte=
ring
> internally to check for bogus messages. What is confusing to me is whethe=
r
> this is just brought up as an example or whether you actually care to sol=
ve

I need a af_packet filter in nf egress but never said it was related
to DHCP. It is more related to clustering.

> it (.. but then why would you do that in fast-path to penalize every othe=
r
> traffic as well just for this type of slow-path filtering instead of doin=
g

With nft if the hook is not registered it is not going to be used at
all, so the penalty will never happen to any traffic.

> in af_packet only). Similarly, why not add this along with /actual/ nat64
> code with /concrete/ explanation of why it cannot be performed in post-ro=
uting?
> Either way, whatever your actual/real use-case, the above must be address=
ed
> one way or another.
>

Pablo already explained why it should be done in egress [0].

Thank you for your time!


[0] https://marc.info/?l=3Dlinux-netdev&m=3D158449203321811&w=3D2
