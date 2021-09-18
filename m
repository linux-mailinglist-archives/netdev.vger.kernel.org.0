Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAC141061D
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 13:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239299AbhIRLzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Sep 2021 07:55:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60076 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229793AbhIRLzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 07:55:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631966022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VnaGaXjjCBEiLXCmjPcYkqMcparcCyC5+vT8sErhl7o=;
        b=UhwstEkZhsVjDPsF16RSRFm8Lq4h4PLYVKVp5gFqDPBdvukxn8z0ORpXdcKOq5HqAVowT2
        AEYyAjszzHdrYHpY5aJg6ip2UBF8NG0UcqQGaXrbH83GO9JkLUVwUAti7W405V4jKWznCt
        XiCndIgiHYRPZrfz8j0myG71AXrk7NU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-71-cjguDsGUMDu2qaPlNMGhIA-1; Sat, 18 Sep 2021 07:53:41 -0400
X-MC-Unique: cjguDsGUMDu2qaPlNMGhIA-1
Received: by mail-ed1-f71.google.com with SMTP id ec14-20020a0564020d4e00b003cf5630c190so11642503edb.3
        for <netdev@vger.kernel.org>; Sat, 18 Sep 2021 04:53:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=VnaGaXjjCBEiLXCmjPcYkqMcparcCyC5+vT8sErhl7o=;
        b=Uvbs88zl0JNEsJ+BHsPwugragnnlA9L+ebnDaNwta8s5GqJyV6H6cKwuPZw4tJdZmB
         9CJC5dvCjSSHnlm1dRn7iWxR3VxLl1it09oEW8TQZUbU5rG0pYMtd5NthjiYBiD/Gq0W
         SeFVU+u2ChWdZuQykIZzTIA262ivWcMtX3LRfRL6c9CKmfon7JenQm7L+3oA7Bf6GlVN
         znWES1fxbhIGNfLMxfJ0oiJdLnzjzZc6h8VtYyoC6oDZMyb+Vm5ssVxO2SnDTkeYeKNR
         wPZsMoRbE2UaQIW6RpVLcRu8yzwpoAXwlbmF5nCShl/L2e65f7PaxAjdjYCUPv/6kch4
         l7dQ==
X-Gm-Message-State: AOAM530nCMUanP7MCDDdvxtcihcA6royJGMWk7bWtOjTqhVoDOAc9nWN
        +xqYNjKRVBVD4sm3t0Xg0d2BKZPdCYVEgMOjagNQfxPzxxBZTVAvpKRf1NvMClEsD1KYtTmcOqm
        O1vy0lihbEjYx+CS2
X-Received: by 2002:a17:906:e20e:: with SMTP id gf14mr17982273ejb.244.1631966019762;
        Sat, 18 Sep 2021 04:53:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgqhI8Z18WdXPURotA3MO5BAt6pN98WCRAzL6H6OzvHGIh3wQK9uB4CUWrnkbr3wAj1UpyUw==
X-Received: by 2002:a17:906:e20e:: with SMTP id gf14mr17982161ejb.244.1631966017953;
        Sat, 18 Sep 2021 04:53:37 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id o23sm4116079eds.75.2021.09.18.04.53.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Sep 2021 04:53:37 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 44D5F18034A; Sat, 18 Sep 2021 13:53:35 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, shayagr@amazon.com,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v14 bpf-next 00/18] mvneta: introduce XDP multi-buffer
 support
In-Reply-To: <614511bc3408b_8d5120862@john-XPS-13-9370.notmuch>
References: <cover.1631289870.git.lorenzo@kernel.org>
 <20210916095539.4696ae27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YUSrWiWh57Ys7UdB@lore-desk>
 <20210917113310.4be9b586@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAADnVQL15NAqbswXedF0r2om8SOiMQE80OSjbyCA56s-B4y8zA@mail.gmail.com>
 <20210917120053.1ec617c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAADnVQKbrkOxfNoixUx-RLJEWULJLyhqjZ=M_X2cFG_APwNyCg@mail.gmail.com>
 <614511bc3408b_8d5120862@john-XPS-13-9370.notmuch>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 18 Sep 2021 13:53:35 +0200
Message-ID: <8735q25ccg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

John Fastabend <john.fastabend@gmail.com> writes:

> Alexei Starovoitov wrote:
>> On Fri, Sep 17, 2021 at 12:00 PM Jakub Kicinski <kuba@kernel.org> wrote:
>> >
>> > On Fri, 17 Sep 2021 11:43:07 -0700 Alexei Starovoitov wrote:
>> > > > If bpf_xdp_load_bytes() / bpf_xdp_store_bytes() works for most we
>> > > > can start with that. In all honesty I don't know what the exact
>> > > > use cases for looking at data are, either. I'm primarily worried
>> > > > about exposing the kernel internals too early.
>> > >
>> > > I don't mind the xdp equivalent of skb_load_bytes,
>> > > but skb_header_pointer() idea is superior.
>> > > When we did xdp with data/data_end there was no refine_retval_range
>> > > concept in the verifier (iirc or we just missed that opportunity).
>> > > We'd need something more advanced: a pointer with valid range
>> > > refined by input argument 'len' or NULL.
>> > > The verifier doesn't have such thing yet, but it fits as a combination of
>> > > value_or_null plus refine_retval_range.
>> > > The bpf_xdp_header_pointer() and bpf_skb_header_pointer()
>> > > would probably simplify bpf programs as well.
>> > > There would be no need to deal with data/data_end.
>> >
>> > What are your thoughts on inlining? Can we inline the common case
>> > of the header being in the "head"? Otherwise data/end comparisons
>> > would be faster.
>> 
>> Yeah. It can be inlined by the verifier.
>> It would still look like a call from bpf prog pov with llvm doing spill/fill
>> of scratched regs, but it's minor.
>> 
>> Also we can use the same bpf_header_pointer(ctx, ...)
>> helper for both xdp and skb program types. They will have different
>> implementation underneath, but this might make possible writing bpf
>> programs that could work in both xdp and skb context.
>> I believe cilium has fancy macros to achieve that.
>
> Hi,
>
> First a header_pointer() logic that works across skb and xdp seems like
> a great idea to me. I wonder though if instead of doing the copy
> into a new buffer for offset past the initial frag like what is done in
> skb_header_pointer could we just walk the frags and point at the new offset.
> This is what we do on the socket side with bpf_msg_pull-data() for example.
> For XDP it should also work. The skb case would depend on clone state
> and things so might be a bit more tricky there.
>
> This has the advantage of only doing the copy when its necessary. This
> can be useful for example when reading the tail of an IPsec packet. With
> blind copy most packets will get hit with a copy. By just writing the
> pkt->data and pkt->data_end we can avoid this case.
>
> Lorenz originally implemented something similar earlier and we had the
> refine retval logic. It failed on no-alu32 for some reason we could
> revisit. I didn't mind the current help returning with data pointer set
> to the start of the frag so we stopped following up on it.
>
> I agree though the current implementation puts a lot on the BPF writer.
> So getting both cases covered, I want to take pains in my BPF prog
> to avoid copies and I just want these bytes handled behind a single
> helper seems good to me.

I'm OK with a bpf_header_pointer()-type helper - I quite like the
in-kernel version of this for SKBs, so replicating it as a BPF helper
would be great. But I'm a little worried about taking a performance hit.

I.e., if you do:

ptr = bpf_header_pointer(pkt, offset, len, stack_ptr)
*ptr = xxx;

then, if the helper ended up copying the data into the stack pointer,
you didn't actually change anything in the packet, so you need to do a
writeback.

Jakub suggested up-thread that this should be done with some kind of
flush() helper. But you don't know whether the header_pointer()-helper
copied the data, so you always need to call the flush() helper, which
will incur overhead. If the verifier can in-line the helpers that will
lower it, but will it be enough to make it negligible?

-Toke

