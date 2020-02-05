Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E1F81533E5
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 16:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgBEPbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 10:31:18 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56412 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726592AbgBEPbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 10:31:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580916676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8ak0sXO8e5A4SWi2bK9YbkSWyE6UmmHzVI+lc6bTUMY=;
        b=dTwFiODYQTTNvA406GCkYbpegIdztDOA906w+O+RIvDX3RTpaJR6IbKkxB+fdtXX3JXoBZ
        vl82KXUBaK90MryIzsi1yenb439glqv6zFu4SOldEzlhwtHAig33XWf/POBEHJ3jNzXkYJ
        ErhgIFQ0H6jEbcQZaoV/ToiNEfZLMC4=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-8XqvVbBCMzaf6rpMgeNaFw-1; Wed, 05 Feb 2020 10:31:01 -0500
X-MC-Unique: 8XqvVbBCMzaf6rpMgeNaFw-1
Received: by mail-lf1-f70.google.com with SMTP id t8so677741lfc.21
        for <netdev@vger.kernel.org>; Wed, 05 Feb 2020 07:31:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=8ak0sXO8e5A4SWi2bK9YbkSWyE6UmmHzVI+lc6bTUMY=;
        b=gwA6OPo5o3JQFtWGP70x6LJdKobsm/ftPeCK5GMM4Qgq6YYtJzhFIiFrHHysNbWCyC
         4038EcEODcJmnhmCEoDoo1sHYRNBAcQm8EUqmTpl60Frcu3st6bAPbnpHDejfAMgDzmF
         q2re4YgwwZFDtHyRoEtE5l3CUNNYKLH8N6WsmPrgEi5u7IxO0tNzCEAwuYnyDWLmlbBu
         7AWeG1WQnIfCJwkqGCFmgmO21PLvazogR+jS/xA2WmfowV8NxA3yWB4qtmHCUqtWVQWn
         n8rqY4yOpFtrKD4E+td/9WECcgDMickD38yU6JxqG6gPusBE7jsMKM9zcEQEfFODKKy2
         TjFQ==
X-Gm-Message-State: APjAAAVGgDP/9epDfF5/zIOWdkt2VNT/RVkMUduL3HFwk1ABVjYH3+z4
        r4pLGRctD9bhH1UMXihMvfNBsmlSutlddrmXQSB9a6DURP8UbaYI9KUH/rWQE31oddU9RcmoVgC
        x3vmr+S1WyuytAnsu
X-Received: by 2002:a2e:9dc3:: with SMTP id x3mr21167504ljj.257.1580916657375;
        Wed, 05 Feb 2020 07:30:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqylW5bpdsc9/cvdcUms4RND4TswI+iVHf++O9qFxBIR5J/EZrV+g4uZayUPkIFHsv7ziqXmEQ==
X-Received: by 2002:a2e:9dc3:: with SMTP id x3mr21167476ljj.257.1580916657041;
        Wed, 05 Feb 2020 07:30:57 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id b190sm12504957lfd.39.2020.02.05.07.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 07:30:55 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3E9D41802D4; Wed,  5 Feb 2020 16:30:54 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, mst@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson\, Magnus" <magnus.karlsson@intel.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs in the egress path
In-Reply-To: <20200204090922.0a346daf@cakuba.hsd1.ca.comcast.net>
References: <20200123014210.38412-1-dsahern@kernel.org> <20200123014210.38412-4-dsahern@kernel.org> <87tv4m9zio.fsf@toke.dk> <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com> <20200124072128.4fcb4bd1@cakuba> <87o8usg92d.fsf@toke.dk> <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com> <20200126141141.0b773aba@cakuba> <33f233a9-88b4-a75a-d1e5-fbbda21f9546@gmail.com> <20200127061623.1cf42cd0@cakuba> <252acf50-91ff-fdc5-3ce1-491a02de07c6@gmail.com> <20200128055752.617aebc7@cakuba> <87ftfue0mw.fsf@toke.dk> <20200201090800.47b38d2b@cakuba.hsd1.ca.comcast.net> <87sgjucbuf.fsf@toke.dk> <20200201201508.63141689@cakuba.hsd1.ca.comcast.net> <87zhdzbfa3.fsf@toke.dk> <20200203231503.24eec7f0@carbon> <87y2ti4nxj.fsf@toke.dk> <20200204090922.0a346daf@cakuba.hsd1.ca.comcast.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 05 Feb 2020 16:30:54 +0100
Message-ID: <878slhdpap.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Tue, 04 Feb 2020 12:00:40 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrot=
e:
>> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>> > On Mon, 03 Feb 2020 21:13:24 +0100
>> > Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>> >=20=20
>> >> Oops, I see I forgot to reply to this bit:
>> >>=20=20=20
>> >> >> Yeah, but having the low-level details available to the XDP program
>> >> >> (such as HW queue occupancy for the egress hook) is one of the ben=
efits
>> >> >> of XDP, isn't it?=20=20=20=20
>> >> >
>> >> > I think I glossed over the hope for having access to HW queue occup=
ancy
>> >> > - what exactly are you after?=20
>> >> >
>> >> > I don't think one can get anything beyond a BQL type granularity.
>> >> > Reading over PCIe is out of question, device write back on high
>> >> > granularity would burn through way too much bus throughput.=20=20=
=20=20
>> >>=20
>> >> This was Jesper's idea originally, so maybe he can explain better; but
>> >> as I understood it, he basically wanted to expose the same information
>> >> that BQL has to eBPF. Making it possible for an eBPF program to either
>> >> (re-)implement BQL with its own custom policy, or react to HWQ pressu=
re
>> >> in some other way, such as by load balancing to another interface.=20=
=20
>> >
>> > Yes, and I also have plans that goes beyond BQL. But let me start with
>> > explaining the BQL part, and answer Toke's question below.
>> >
>> > On Mon, 03 Feb 2020 20:56:03 +0100 Toke wrote:=20=20
>> >> [...] Hmm, I wonder if a TX driver hook is enough?=20=20
>> >
>> > Short answer is no, a TX driver hook is not enough.  The queue state
>> > info the TX driver hook have access to, needs to be updated once the
>> > hardware have "confirmed" the TX-DMA operation have completed.  For
>> > BQL/DQL this update happens during TX-DMA completion/cleanup (code
>> > see call sites for netdev_tx_completed_queue()).  (As Jakub wisely
>> > point out we cannot query the device directly due to performance
>> > implications).  It doesn't need to be a new BPF hook, just something
>> > that update the queue state info (we could piggy back on the
>> > netdev_tx_completed_queue() call or give TX hook access to
>> > dev_queue->dql).=20=20
>
> Interesting, that model does make sense to me.
>
>> The question is whether this can't simply be done through bpf helpers?
>> bpf_get_txq_occupancy(ifindex, txqno)?
>
> Helper vs dev_queue->dql field access seems like a technicality.
> The usual flexibility of implementation vs performance and simplicity
> consideration applies.. I guess?

Yeah, that was my point: We can do whatever makes the most sense for
that; it doesn't necessarily have to be something that's baked into the
TX hook point.

>> > Regarding "where is the queue": For me the XDP-TX queue is the NIC
>> > hardware queue, that this BPF hook have some visibility into and can do
>> > filtering on. (Imagine that my TX queue is bandwidth limited, then I
>> > can shrink the packet size and still send a "congestion" packet to my
>> > receiver).=20=20
>>=20
>> I'm not sure the hardware queues will be enough, though. Unless I'm
>> misunderstanding something, hardware queues are (1) fairly short and (2)
>> FIFO. So, say we wanted to implement fq_codel for XDP forwarding: we'd
>> still need a software queueing layer on top of the hardware queue.
>
> Jesper makes a very interesting point tho. If all the implementation
> wants is FIFO queues which are services in some simple manner (that is
> something that can be offloaded) we should support that.
>
> That means REDIRECT can target multiple TX queues, and we need an API
> to control the queue allocation..

Yes. I think that should be part of the "hwq API" that we presented at
LPC last year[0].

>> If the hardware is EDT-aware this may change, I suppose, but I'm not
>> sure if we can design the XDP queueing primitives with this assumption? =
:)
>
> But I agree with you as well. I think both HW and SW feeding needs to
> be supported. The HW implementations are always necessarily behind
> ideas people implemented and tested in SW..

Exactly. And even though we mostly think about 10-100G network
interfaces, I believe there is also potential for this to be useful at
the low end (think small embedded routers that are very CPU
constrained). In these sorts of environments software queueing is more
feasible.

>> > The bigger picture is that I envision the XDP-TX/egress hook can
>> > open-up for taking advantage of NIC hardware TX queue features. This
>> > also ties into the queue abstraction work by Bj=C3=B6rn+Magnus. Today =
NIC
>> > hardware can do a million TX-queues, and hardware can also do rate
>> > limiting per queue. Thus, I also envision that the XDP-TX/egress hook
>> > can choose/change the TX queue the packet is queue/sent on (we can
>> > likely just overload the XDP_REDIRECT and have a new bpf map type for
>> > this).=20=20
>
> I wonder what that does to our HW offload model which is based on
> TC Qdisc offload today :S Do we use TC API to control configuration=20
> of XDP queues? :S

My thought was that it could be baked into the same API[0]. I.e., add a
way to say not just "I want 3 hardware queues for this", but also "I
want 3 hardware queues, with fq_codel (or whatever) on top".

>> Yes, I think I mentioned in another email that putting all the queueing
>> smarts into the redirect map was also something I'd considered (well, I
>> do think we've discussed this in the past, so maybe not so surprising if
>> we're thinking along the same lines) :)
>>=20
>> But the implication of this is also that an actual TX hook in the driver
>> need not necessarily incorporate a lot of new functionality, as it can
>> control the queueing through a combination of BPF helpers and map
>> updates?
>
> True, it's the dequeuing that's on the TX side, so we could go as far
> as putting all the enqueuing logic in the RX prog..
>
> To answer your question from the other email Toke, my basic model was
> kind of similar to TC Qdiscs. XDP redirect selects a device, then that
> device has an enqueue and dequeue programs. Enqueue program can be run
> in the XDP_REDIRECT context, dequeue is run every time NAPI cleaned up
> some space on the TX descriptor ring. There is a "queue state" but the
> FIFOs etc are sort of internal detail that the enqueue and dequeue
> programs only share between each other. To be clear this is not a
> suggestion of how things should be, it's what sprung to my mind without
> thinking.

Ah, that's interesting. I do agree that it may be better to bake this
into the existing hooks rather than have an additional set of
(en/de)queue hooks.

-Toke

[0] https://linuxplumbersconf.org/event/4/contributions/462/

