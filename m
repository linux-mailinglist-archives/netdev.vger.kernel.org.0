Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 453F5151925
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 12:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgBDLAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 06:00:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34647 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726741AbgBDLAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 06:00:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580814047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Cv1iwl8yVC1hrHwx7CrnhR8rxf/elv8iR7CRGLLn/tU=;
        b=YSzHEXTSVkyvFyJhkWg2HYMHqFu+l/xKN6poaRMjNwAYpV/TSEr7fyFfL4T1ZMBPRCcRSF
        ZO7l0Fi2bTE0gX8cT3abQ7ogYjatCiUDIM8nuZzvo7F8yeLfPvv9lAP4bhY49CV//RL6uT
        TtVHmpt8BxiSM1X4EkYNlGWKC5qPdTc=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-384-h1hhv0MtMp6R1gumiQlEJg-1; Tue, 04 Feb 2020 06:00:45 -0500
X-MC-Unique: h1hhv0MtMp6R1gumiQlEJg-1
Received: by mail-lf1-f70.google.com with SMTP id l2so2444130lfk.23
        for <netdev@vger.kernel.org>; Tue, 04 Feb 2020 03:00:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Cv1iwl8yVC1hrHwx7CrnhR8rxf/elv8iR7CRGLLn/tU=;
        b=gBaY1esufUGpcQkdeA9t64hqnMmNwjH886HJDUVySca3nok/j7uJUZbShH5W7B5nOP
         yZW9xxDVyzdkMoBseeXENs7O/8ZnccheKTfYfYn14hDo0KLwqlYqs8owrcPFc29xKdXo
         MFNmcQ70Tdx401m5MJhj2ujh8CvmSZFLY4urBwWCgNAsL1d03jXxBGrYDEQlTZCH3Oau
         hs6/s6pyX6RiLD2Z0crAOCyju3mVmiLGlwgSJa4gYXG9HgnC3lVWRfLJN8VQbbh34poq
         l/w4jHio/95B8plmjAgrb7diB4bPi1XLIrkQ36q/tI5CnemBELUIn03kxS1LWx12y/dN
         xXGw==
X-Gm-Message-State: APjAAAUxRxbV7abTiGW6HrlJYx0VFAUm60Tmd2DQoiE+h35NBNNjIbqB
        Om3acuuOwFU1hr4hG4Yrd4vYKm1f3vqJKgscceBoGm7XzKRgT0PN+y+pNBmJt9NQ7/j5c2h6ivw
        3HY3KO/gvKpyqGnjT
X-Received: by 2002:a19:7d04:: with SMTP id y4mr14594871lfc.111.1580814043952;
        Tue, 04 Feb 2020 03:00:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqzPhDhwTytDSYaeGEjVVZpdLotVbdNBd4a729g8lhOxEHUGv07t4uUGpAbmnMDWirdM523vKA==
X-Received: by 2002:a19:7d04:: with SMTP id y4mr14594859lfc.111.1580814043603;
        Tue, 04 Feb 2020 03:00:43 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id o69sm10257621lff.14.2020.02.04.03.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 03:00:42 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A71021802CA; Tue,  4 Feb 2020 12:00:40 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@gmail.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        davem@davemloft.net, mst@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>, brouer@redhat.com,
        =?utf-8?B?QmrDtnJuIFTDtnBl?= =?utf-8?B?bA==?= 
        <bjorn.topel@intel.com>,
        "Karlsson\, Magnus" <magnus.karlsson@intel.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs in the egress path
In-Reply-To: <20200203231503.24eec7f0@carbon>
References: <20200123014210.38412-1-dsahern@kernel.org> <20200123014210.38412-4-dsahern@kernel.org> <87tv4m9zio.fsf@toke.dk> <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com> <20200124072128.4fcb4bd1@cakuba> <87o8usg92d.fsf@toke.dk> <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com> <20200126141141.0b773aba@cakuba> <33f233a9-88b4-a75a-d1e5-fbbda21f9546@gmail.com> <20200127061623.1cf42cd0@cakuba> <252acf50-91ff-fdc5-3ce1-491a02de07c6@gmail.com> <20200128055752.617aebc7@cakuba> <87ftfue0mw.fsf@toke.dk> <20200201090800.47b38d2b@cakuba.hsd1.ca.comcast.net> <87sgjucbuf.fsf@toke.dk> <20200201201508.63141689@cakuba.hsd1.ca.comcast.net> <87zhdzbfa3.fsf@toke.dk> <20200203231503.24eec7f0@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 04 Feb 2020 12:00:40 +0100
Message-ID: <87y2ti4nxj.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Mon, 03 Feb 2020 21:13:24 +0100
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>
>> Oops, I see I forgot to reply to this bit:
>>=20
>> >> Yeah, but having the low-level details available to the XDP program
>> >> (such as HW queue occupancy for the egress hook) is one of the benefi=
ts
>> >> of XDP, isn't it?=20=20
>> >
>> > I think I glossed over the hope for having access to HW queue occupancy
>> > - what exactly are you after?=20
>> >
>> > I don't think one can get anything beyond a BQL type granularity.
>> > Reading over PCIe is out of question, device write back on high
>> > granularity would burn through way too much bus throughput.=20=20
>>=20
>> This was Jesper's idea originally, so maybe he can explain better; but
>> as I understood it, he basically wanted to expose the same information
>> that BQL has to eBPF. Making it possible for an eBPF program to either
>> (re-)implement BQL with its own custom policy, or react to HWQ pressure
>> in some other way, such as by load balancing to another interface.
>
> Yes, and I also have plans that goes beyond BQL. But let me start with
> explaining the BQL part, and answer Toke's question below.
>
> On Mon, 03 Feb 2020 20:56:03 +0100 Toke wrote:
>> [...] Hmm, I wonder if a TX driver hook is enough?
>
> Short answer is no, a TX driver hook is not enough.  The queue state
> info the TX driver hook have access to, needs to be updated once the
> hardware have "confirmed" the TX-DMA operation have completed.  For
> BQL/DQL this update happens during TX-DMA completion/cleanup (code
> see call sites for netdev_tx_completed_queue()).  (As Jakub wisely
> point out we cannot query the device directly due to performance
> implications).  It doesn't need to be a new BPF hook, just something
> that update the queue state info (we could piggy back on the
> netdev_tx_completed_queue() call or give TX hook access to
> dev_queue->dql).

The question is whether this can't simply be done through bpf helpers?
bpf_get_txq_occupancy(ifindex, txqno)?

> Regarding "where is the queue": For me the XDP-TX queue is the NIC
> hardware queue, that this BPF hook have some visibility into and can do
> filtering on. (Imagine that my TX queue is bandwidth limited, then I
> can shrink the packet size and still send a "congestion" packet to my
> receiver).

I'm not sure the hardware queues will be enough, though. Unless I'm
misunderstanding something, hardware queues are (1) fairly short and (2)
FIFO. So, say we wanted to implement fq_codel for XDP forwarding: we'd
still need a software queueing layer on top of the hardware queue.

If the hardware is EDT-aware this may change, I suppose, but I'm not
sure if we can design the XDP queueing primitives with this assumption? :)

> The bigger picture is that I envision the XDP-TX/egress hook can
> open-up for taking advantage of NIC hardware TX queue features. This
> also ties into the queue abstraction work by Bj=C3=B6rn+Magnus. Today NIC
> hardware can do a million TX-queues, and hardware can also do rate
> limiting per queue. Thus, I also envision that the XDP-TX/egress hook
> can choose/change the TX queue the packet is queue/sent on (we can
> likely just overload the XDP_REDIRECT and have a new bpf map type for
> this).

Yes, I think I mentioned in another email that putting all the queueing
smarts into the redirect map was also something I'd considered (well, I
do think we've discussed this in the past, so maybe not so surprising if
we're thinking along the same lines) :)

But the implication of this is also that an actual TX hook in the driver
need not necessarily incorporate a lot of new functionality, as it can
control the queueing through a combination of BPF helpers and map
updates?

-Toke

