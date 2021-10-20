Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF73434B13
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 14:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhJTMYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 08:24:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29348 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229864AbhJTMYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 08:24:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634732515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MglysCWfOaKC7TH+QAW/uW1q/Tj9LCbAd8L7q/nFdkQ=;
        b=M0X/glRedG20os456I2Pxdt6kI+2ThutvZFM2pAyRv48hMWPRU2q0QM8ybHHV6KXU/InRT
        O+JPVO7Yk3lNLJGvGC+EaBqVg6MiOzryrhV8Ym3rFIyhJwSjrxKGIphCYSKvnzyYPxtz9Y
        uNRXdNLhprnZSRn/ke3wXqEty7vigOs=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-5zcT3O5cM6ezuJdurjaT_g-1; Wed, 20 Oct 2021 08:21:53 -0400
X-MC-Unique: 5zcT3O5cM6ezuJdurjaT_g-1
Received: by mail-ed1-f69.google.com with SMTP id a3-20020a50da43000000b003dca31dcfc2so4401808edk.14
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 05:21:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=MglysCWfOaKC7TH+QAW/uW1q/Tj9LCbAd8L7q/nFdkQ=;
        b=YSmqtVwRk3GlbPvuUDBFH6So3HKvYFo9PZZ8kzw2RAHSewkqHM6rIcjoZcfuwlTxQT
         hm57H54nLntyBPoKNc8Ey8CEVdwkuDOFU7dp2Z2rLsCQZv4wIKhW5tzqYVHohqFG+29I
         axgcEUCIwDkwD1iENLRgbWVjmqmeIFg2dlfAYwoAVHxztwq86dKKBFRcRNyfx6MUn3eh
         LtXCpQcswPzILRgOYejERtk2M98sw7yFyboeyEXvdt6iV0XahiZM8j0kzlqIQTiVljNw
         i9mczhBItMEgE2uvds9P6N0N5JuRzd2ObEzI5tsh6winTtwtf25oepZPVy6OaRnK/vdY
         udJg==
X-Gm-Message-State: AOAM531MeKzHZDDKkIuCmU44CMlYtNlvkhuMQSqUt7UF2CmPiB2v7Mti
        HNNTosIacCNcHWkuYSaFg5Zr2DG2HFe8+9M22AulvmxygxkJiHWOVY1GHlAOx7SqbQUVKEKkwQn
        Bk/PG97JN/5CaY0JW
X-Received: by 2002:a17:906:2ccf:: with SMTP id r15mr43670259ejr.182.1634732510393;
        Wed, 20 Oct 2021 05:21:50 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8OnZrZ1Kyb4RNG3oeUkmmLgwo1lFSY/0sj4Pi+AcIIGn2uCh/o3OfKndIy/rbpgjXni32MA==
X-Received: by 2002:a17:906:2ccf:: with SMTP id r15mr43670018ejr.182.1634732508083;
        Wed, 20 Oct 2021 05:21:48 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id d18sm1137041ejo.80.2021.10.20.05.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 05:21:47 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8BFE5180262; Wed, 20 Oct 2021 14:21:46 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Florian Westphal <fw@strlen.de>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Brendan Jackman <jackmanb@google.com>,
        Florent Revest <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH bpf-next 07/10] bpf: Add helpers to query conntrack info
In-Reply-To: <20211020095815.GJ28644@breakpoint.cc>
References: <20211019144655.3483197-1-maximmi@nvidia.com>
 <20211019144655.3483197-8-maximmi@nvidia.com>
 <20211020035622.lgrxnrwfeak2e75a@apollo.localdomain>
 <20211020092844.GI28644@breakpoint.cc> <87h7dcf2n4.fsf@toke.dk>
 <20211020095815.GJ28644@breakpoint.cc>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 20 Oct 2021 14:21:46 +0200
Message-ID: <875ytrga3p.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Florian Westphal <fw@strlen.de> writes:

> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>> Florian Westphal <fw@strlen.de> writes:
>>=20
>> > Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>> >> On Tue, Oct 19, 2021 at 08:16:52PM IST, Maxim Mikityanskiy wrote:
>> >> > The new helpers (bpf_ct_lookup_tcp and bpf_ct_lookup_udp) allow to =
query
>> >> > connection tracking information of TCP and UDP connections based on
>> >> > source and destination IP address and port. The helper returns a po=
inter
>> >> > to struct nf_conn (if the conntrack entry was found), which needs t=
o be
>> >> > released with bpf_ct_release.
>> >> >
>> >> > Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
>> >> > Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
>> >>=20
>> >> The last discussion on this [0] suggested that stable BPF helpers for=
 conntrack
>> >> were not desired, hence the recent series [1] to extend kfunc support=
 to modules
>> >> and base the conntrack work on top of it, which I'm working on now (s=
upporting
>> >> both CT lookup and insert).
>> >
>> > This will sabotage netfilter pipeline and the way things work more and
>> > more 8-(
>>=20
>> Why?
>
> Lookups should be fine.  Insertions are the problem.
>
> NAT hooks are expected to execute before the insertion into the
> conntrack table.
>
> If you insert before, NAT hooks won't execute, i.e.
> rules that use dnat/redirect/masquerade have no effect.

Well yes, if you insert the wrong state into the conntrack table, you're
going to get wrong behaviour. That's sorta expected, there are lots of
things XDP can do to disrupt the packet flow (like just dropping the
packets :)).

>> > If you want to use netfilter with ebpf, please have a look at the RFC
>> > I posted and lets work on adding a netfilter specific program type
>> > that can run ebpf programs directly from any of the existing netfilter
>> > hook points.
>>=20
>> Accelerating netfilter using BPF is a worthy goal in itself, but I also
>> think having the ability to lookup into conntrack from XDP is useful for
>> cases where someone wants to bypass the stack entirely (for accelerating
>> packet forwarding, say). I don't think these goals are in conflict
>> either, what makes you say they are?
>
> Lookup is fine, I don't see fundamental issues with XDP-based bypass,
> there are flowtables that also bypass classic forward path via the
> netfilter ingress hook (first packet needs to go via classic path to
> pass through all filter + nat rules and is offlloaded to HW or SW via
> the 'flow add' statement in nftables.
>
> I don't think there is anything that stands in the way of replicating
> this via XDP.

What I want to be able to do is write an XDP program that does the followin=
g:

1. Parse the packet header and determine if it's a packet type we know
   how to handle. If not, just return XDP_PASS and let the stack deal
   with corner cases.

2. If we know how to handle the packet (say, it's TCP or UDP), do a
   lookup into conntrack to figure out if there's state for it and we
   need to do things like NAT.

3. If we need to NAT, rewrite the packet based on the information we got
   back from conntrack.

4. Update the conntrack state to be consistent with the packet, and then
   redirect it out the destination interface.

I.e., in the common case the packet doesn't go through the stack at all;
but we need to make conntrack aware that we processed the packet so the
entry doesn't expire (and any state related to the flow gets updated).
Ideally we should also be able to create new state for a flow we haven't
seen before.

This requires updating of state, but I see no reason why this shouldn't
be possible?

-Toke

