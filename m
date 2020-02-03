Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4009A151091
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 20:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbgBCT4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 14:56:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52121 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726018AbgBCT4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 14:56:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580759769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gpAzUx56EcHgCFaY4YHhMp7WkI5U9s/yaHvXDGZwSvw=;
        b=P+DHvqQeFEErC5bskJLusQhuIZaz/1oJEJW5obwMkyg0P1EBNrZWRUF1vfPuGrcvI+LOM7
        5Y1jBFC+fwjqan7mkDGXjZDICyVWCVaPqkgw94/ngqvpj7CqFPuKDC+j8bEHPtPuK6saBy
        gNoxDC4UyjlhvRLJBnWzlVRYRxNmscc=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188--rwXTnRsOdewJ5duDBgJCw-1; Mon, 03 Feb 2020 14:56:07 -0500
X-MC-Unique: -rwXTnRsOdewJ5duDBgJCw-1
Received: by mail-lf1-f70.google.com with SMTP id v19so2265706lfg.2
        for <netdev@vger.kernel.org>; Mon, 03 Feb 2020 11:56:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=gpAzUx56EcHgCFaY4YHhMp7WkI5U9s/yaHvXDGZwSvw=;
        b=ZP4dXDp3cqRr7oNKb3AQXBlWJ0j12iNFuJxi7WvuaQCImY4TXjLPGn3641j8/B79Q3
         75rcKzamzxe4/N4Oso45vWW7qBHQ6eXwJO9R4stgHubI02UNEw65vuCH2HhyEPfRkC/N
         Q3Ed3N5m19ESExFPNMUwG7Hp/3Ci5WeZGK6yoc343zqfs9nVy7XVmUPPOkBGnUTcBUhZ
         KskaueZ+0ZmH8ef5YK80u0Mo4cgnZRWyxPReI7ioZLGGfv3pWu1/ka57K6hM8YkI8rNF
         5eb1cAd2hFbJQxPrCA4ZmHfHPEBstyL3SJDUfnrBuxuVAKBt8WC3SUPN0IwkGcJc1VHS
         NMmw==
X-Gm-Message-State: APjAAAVaurqQIFF63AmnbgguyZnLc4caGQK9+rrTjMrn8D5uQ6hP28dd
        FALud92/JCNloB3UiA231/KbrlZLyrT9hcUedFI7nxQjw8a0rssXofsgsp7hGn2QXx7jvNwLPRs
        aZamZ7W3en97Vs71g
X-Received: by 2002:a2e:8e91:: with SMTP id z17mr14445407ljk.13.1580759766362;
        Mon, 03 Feb 2020 11:56:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqysS2ETXBedo4Xs8efN4/p6nNkebo4gIPQkHHC2I7Qkp9QYjQMxZoimZOPjYMyWuJMGXaPQ2A==
X-Received: by 2002:a2e:8e91:: with SMTP id z17mr14445369ljk.13.1580759765379;
        Mon, 03 Feb 2020 11:56:05 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([85.204.121.218])
        by smtp.gmail.com with ESMTPSA id e17sm10517937ljg.101.2020.02.03.11.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 11:56:04 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 91CFF1800A2; Mon,  3 Feb 2020 20:56:03 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org, prashantbhole.linux@gmail.com,
        jasowang@redhat.com, davem@davemloft.net, brouer@redhat.com,
        mst@redhat.com, toshiaki.makita1@gmail.com, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 03/12] net: Add IFLA_XDP_EGRESS for XDP programs in the egress path
In-Reply-To: <20200201201508.63141689@cakuba.hsd1.ca.comcast.net>
References: <20200123014210.38412-1-dsahern@kernel.org> <20200123014210.38412-4-dsahern@kernel.org> <87tv4m9zio.fsf@toke.dk> <335b624a-655a-c0c6-ca27-102e6dac790b@gmail.com> <20200124072128.4fcb4bd1@cakuba> <87o8usg92d.fsf@toke.dk> <1d84d8be-6812-d63a-97ca-ebc68cc266b9@gmail.com> <20200126141141.0b773aba@cakuba> <33f233a9-88b4-a75a-d1e5-fbbda21f9546@gmail.com> <20200127061623.1cf42cd0@cakuba> <252acf50-91ff-fdc5-3ce1-491a02de07c6@gmail.com> <20200128055752.617aebc7@cakuba> <87ftfue0mw.fsf@toke.dk> <20200201090800.47b38d2b@cakuba.hsd1.ca.comcast.net> <87sgjucbuf.fsf@toke.dk> <20200201201508.63141689@cakuba.hsd1.ca.comcast.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 03 Feb 2020 20:56:03 +0100
Message-ID: <878sljcung.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Sat, 01 Feb 2020 21:05:28 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrot=
e:
>> Jakub Kicinski <kuba@kernel.org> writes:
>> > On Sat, 01 Feb 2020 17:24:39 +0100, Toke H=C3=B8iland-J=C3=B8rgensen w=
rote:=20=20
>> >> > I'm weary of partially implemented XDP features, EGRESS prog does us
>> >> > no good when most drivers didn't yet catch up with the REDIRECTs.=
=20=20=20=20
>> >>=20
>> >> I kinda agree with this; but on the other hand, if we have to wait for
>> >> all drivers to catch up, that would mean we couldn't add *anything*
>> >> new that requires driver changes, which is not ideal either :/=20=20
>> >
>> > If EGRESS is only for XDP frames we could try to hide the handling in
>> > the core (with slight changes to XDP_TX handling in the drivers),
>> > making drivers smaller and XDP feature velocity higher.=20=20
>>=20
>> But if it's only for XDP frames that are REDIRECTed, then one might as
>> well perform whatever action the TX hook was doing before REDIRECTing
>> (as you yourself argued)... :)
>
> Right, that's why I think the design needs to start from queuing which
> can't be done today, and has to be done in context of the destination.
> Solving queuing justifies the added complexity if you will :)

Right, that makes sense. Hmm, I wonder if a TX driver hook is enough?
I.e., a driver callback in the TX path could also just queue that packet
(returning XDP_QUEUED?), without the driver needing any more handling
than it will already have? I'm spitballing a little bit here, but it may
be quite straight-forward? :)

>> > I think loading the drivers with complexity is hurting us in so many
>> > ways..=20=20
>>=20
>> Yeah, but having the low-level details available to the XDP program
>> (such as HW queue occupancy for the egress hook) is one of the benefits
>> of XDP, isn't it?
>
> I think I glossed over the hope for having access to HW queue occupancy
> - what exactly are you after?=20
>
> I don't think one can get anything beyond a BQL type granularity.
> Reading over PCIe is out of question, device write back on high
> granularity would burn through way too much bus throughput.
>
>> Ultimately, I think Jesper's idea of having drivers operate exclusively
>> on XDP frames and have the skb handling entirely in the core is an
>> intriguing way to resolve this problem. Though this is obviously a
>> long-term thing, and one might reasonably doubt we'll ever get there for
>> existing drivers...
>>=20
>> >> > And we're adding this before we considered the queuing problem.
>> >> >
>> >> > But if I'm alone in thinking this, and I'm not convincing anyone we
>> >> > can move on :)=20=20=20=20
>> >>=20
>> >> I do share your concern that this will end up being incompatible with
>> >> whatever solution we end up with for queueing. However, I don't
>> >> necessarily think it will: I view the XDP egress hook as something
>> >> that in any case will run *after* packets are dequeued from whichever
>> >> intermediate queueing it has been through (if any). I think such a
>> >> hook is missing in any case; for instance, it's currently impossible
>> >> to implement something like CoDel (which needs to know how long a
>> >> packet spent in the queue) in eBPF.=20=20
>> >
>> > Possibly =F0=9F=A4=94 I don't have a good mental image of how the XDP =
queuing
>> > would work.
>> >
>> > Maybe once the queuing primitives are defined they can easily be
>> > hooked into the Qdisc layer. With Martin's recent work all we need is=
=20
>> > a fifo that can store skb pointers, really...
>> >
>> > It'd be good if the BPF queuing could replace TC Qdiscs, rather than=20
>> > layer underneath.=20=20
>>=20
>> Hmm, hooking into the existing qdisc layer is an interesting idea.
>> Ultimately, I fear it won't be feasible for performance reasons; but
>> it's certainly something to consider. Maybe at least as an option?
>
> For forwarding sure, but for locally generated traffic.. =F0=9F=A4=B7=E2=
=80=8D=E2=99=82=EF=B8=8F

Right, well, for locally generated traffic we already have the qdisc?
This was kinda the reason why my original thought was to add the
queueing for XDP only at REDIRECT time. I.e., we already have the
xdp_dev_bulk_queue (which now even lives in struct net_device), so we
could "just" extend that and make it into a proper queueing structure,
and call it a day? :)

But from your comments it sounds like that when you're saying "BPF
queueing" you mean that the queueing itself should be programmable using
BPF? To me, the most urgent thing has been to figure out a way to do
*any* kind of queueing with XDP-forwarded frames, so haven't given much
thought to what a "fully programmable" queue would look like... Do you
have any thoughts?

-Toke

