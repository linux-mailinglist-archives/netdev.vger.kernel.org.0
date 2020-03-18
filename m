Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 361591898D6
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 11:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgCRKDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 06:03:38 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46864 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727451AbgCRKDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 06:03:37 -0400
Received: by mail-lj1-f193.google.com with SMTP id d23so26252347ljg.13
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 03:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=686vflns/vrXv0bZYFdedarxTXD/X21Ww2nMEQjKZF0=;
        b=UB2kbI5scX90BXkwztVWqY5gFCJCyKEoAY3V2HRwoaRGOFtWLIuT2sYkmkTfXJQaAV
         ZBEFwx+0eigUG8O/JvhjrBc7fkivegbkq7U4w0MZizeP9FvKi5geo2ArDGKb64GNAvmT
         T+dmUFUN+VIRL3nEJIg34F4PbaAYi1mxUZBSc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=686vflns/vrXv0bZYFdedarxTXD/X21Ww2nMEQjKZF0=;
        b=oBtXcoCHBFfJIlnUkABI+TtaXh569d4A/oOKPZD7gUAU/XDAMK6q5H9Krk6uhGs/m2
         UMIhHzjK6rf+j4iimwQLcl+XE5D2RpOYd6JMkNrEpFE5K3QVnwsyw0WVEIgu0HsXET+3
         waIDTvwyvBl2jijN1Q6rwiu67Was/SoDsuthkTVxE2/+1NINFPtAIw92UA3xZJ0twida
         t/wFl2/IAJ2Y6rvvxGB1PudJ6kRv+qGiT1en3Hm7rg0imk9HnwXPovOmJCgUrTbPZWmr
         XDGWJNjOdkz9cwj2L7MCcFDUJCn5VBOJBhxFZQtlCbk6IA+/hIsn7TfCiw/TUSBAGzqL
         Hfpg==
X-Gm-Message-State: ANhLgQ3K69o8jFmlxf1Jpuy6UMiSfV54Ojq8EikixxpynPnHyQMVyrYg
        fnymqWOswJzc5gDsI36YjUOeGQ==
X-Google-Smtp-Source: ADFU+vswnChtHyIVPbOVghoWBbCRccD3UwmMnOzjFBvJUjo36QWIb/YDHe8dSX8axQ4jz8tEsb0tAA==
X-Received: by 2002:a2e:1653:: with SMTP id 19mr2062192ljw.112.1584525815185;
        Wed, 18 Mar 2020 03:03:35 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id m17sm4128277ljb.61.2020.03.18.03.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 03:03:34 -0700 (PDT)
References: <20200312233648.1767-1-joe@wand.net.nz> <20200312233648.1767-4-joe@wand.net.nz> <20200316225729.kd4hmz3oco5l7vn4@kafai-mbp> <CAOftzPgsVOqCLZatjytBXdQxH-DqJxiycXWN2d4C_-BjR5v1Kw@mail.gmail.com> <20200317062623.y5v2hejgtdbvexnz@kafai-mbp> <CAOftzPjXexvng-+77b-4Yw0pEBHXchsNVwrx+h9vV+5XBQzy-g@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Joe Stringer <joe@wand.net.nz>
Cc:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: Re: [PATCH bpf-next 3/7] bpf: Add socket assign support
In-reply-to: <CAOftzPjXexvng-+77b-4Yw0pEBHXchsNVwrx+h9vV+5XBQzy-g@mail.gmail.com>
Date:   Wed, 18 Mar 2020 11:03:33 +0100
Message-ID: <87h7ymx9my.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 01:46 AM CET, Joe Stringer wrote:
> On Mon, Mar 16, 2020 at 11:27 PM Martin KaFai Lau <kafai@fb.com> wrote:
>>
>> On Mon, Mar 16, 2020 at 08:06:38PM -0700, Joe Stringer wrote:
>> > On Mon, Mar 16, 2020 at 3:58 PM Martin KaFai Lau <kafai@fb.com> wrote:
>> > >
>> > > On Thu, Mar 12, 2020 at 04:36:44PM -0700, Joe Stringer wrote:
>> > > > Add support for TPROXY via a new bpf helper, bpf_sk_assign().
>> > > >
>> > > > This helper requires the BPF program to discover the socket via a call
>> > > > to bpf_sk*_lookup_*(), then pass this socket to the new helper. The
>> > > > helper takes its own reference to the socket in addition to any existing
>> > > > reference that may or may not currently be obtained for the duration of
>> > > > BPF processing. For the destination socket to receive the traffic, the
>> > > > traffic must be routed towards that socket via local route, the socket
>> > > I also missed where is the local route check in the patch.
>> > > Is it implied by a sk can be found in bpf_sk*_lookup_*()?
>> >
>> > This is a requirement for traffic redirection, it's not enforced by
>> > the patch. If the operator does not configure routing for the relevant
>> > traffic to ensure that the traffic is delivered locally, then after
>> > the eBPF program terminates, it will pass up through ip_rcv() and
>> > friends and be subject to the whims of the routing table. (or
>> > alternatively if the BPF program redirects somewhere else then this
>> > reference will be dropped).
>> >
>> > Maybe there's a path to simplifying this configuration path in future
>> > to loosen this requirement, but for now I've kept the series as
>> > minimal as possible on that front.
>> >
>> > > [ ... ]
>> > >
>> > > > diff --git a/net/core/filter.c b/net/core/filter.c
>> > > > index cd0a532db4e7..bae0874289d8 100644
>> > > > --- a/net/core/filter.c
>> > > > +++ b/net/core/filter.c
>> > > > @@ -5846,6 +5846,32 @@ static const struct bpf_func_proto bpf_tcp_gen_syncookie_proto = {
>> > > >       .arg5_type      = ARG_CONST_SIZE,
>> > > >  };
>> > > >
>> > > > +BPF_CALL_3(bpf_sk_assign, struct sk_buff *, skb, struct sock *, sk, u64, flags)
>> > > > +{
>> > > > +     if (flags != 0)
>> > > > +             return -EINVAL;
>> > > > +     if (!skb_at_tc_ingress(skb))
>> > > > +             return -EOPNOTSUPP;
>> > > > +     if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
>> > > > +             return -ENOENT;
>> > > > +
>> > > > +     skb_orphan(skb);
>> > > > +     skb->sk = sk;
>> > > sk is from the bpf_sk*_lookup_*() which does not consider
>> > > the bpf_prog installed in SO_ATTACH_REUSEPORT_EBPF.
>> > > However, the use-case is currently limited to sk inspection.
>> > >
>> > > It now supports selecting a particular sk to receive traffic.
>> > > Any plan in supporting that?
>> >
>> > I think this is a general bpf_sk*_lookup_*() question, previous
>> > discussion[0] settled on avoiding that complexity before a use case
>> > arises, for both TC and XDP versions of these helpers; I still don't
>> > have a specific use case in mind for such functionality. If we were to
>> > do it, I would presume that the socket lookup caller would need to
>> > pass a dedicated flag (supported at TC and likely not at XDP) to
>> > communicate that SO_ATTACH_REUSEPORT_EBPF progs should be respected
>> > and used to select the reuseport socket.
>> It is more about the expectation on the existing SO_ATTACH_REUSEPORT_EBPF
>> usecase.  It has been fine because SO_ATTACH_REUSEPORT_EBPF's bpf prog
>> will still be run later (e.g. from tcp_v4_rcv) to decide which sk to
>> recieve the skb.
>>
>> If the bpf@tc assigns a TCP_LISTEN sk in bpf_sk_assign(),
>> will the SO_ATTACH_REUSEPORT_EBPF's bpf still be run later
>> to make the final sk decision?
>
> I don't believe so, no:
>
> ip_local_deliver()
> -> ...
> -> ip_protocol_deliver_rcu()
> -> tcp_v4_rcv()
> -> __inet_lookup_skb()
> -> skb_steal_sock(skb)
>
> But this will only affect you if you are running both the bpf@tc
> program with sk_assign() and the reuseport BPF sock programs at the
> same time. This is why I link it back to the bpf_sk*_lookup_*()
> functions: If the socket lookup in the initial step respects reuseport
> BPF prog logic and returns the socket using the same logic, then the
> packet will be directed to the socket you expect. Just like how
> non-BPF reuseport would work with this series today.

I'm a bit lost in argumentation. The cover letter says that the goal is
to support TPROXY use cases from BPF TC. TPROXY, however, supports
reuseport load-balancing, which is essential to scaling out your
receiver [0].

I assume that in Cilium use case, single socket / single core is
sufficient to handle traffic steered with this new mechanism.

Also, socket lookup from XDP / BPF TC _without_ reuseport sounds
okay-ish because you're likely after information that a socket (group)
is attached to some local address / port.

However, when you go one step further and assign the socket to skb
without running reuseport logic, that is breaking socket load-balancing
for applications.

That is to say that I'm with Lorenz on this one. Sockets that belong to
reuseport group should not be a valid target for assignment until socket
lookup from BPF honors reuseport.

[0] https://www.slideshare.net/lfevents/boost-udp-transaction-performance

[...]
