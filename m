Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE251BB98A
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 11:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgD1JKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 05:10:53 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42009 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726540AbgD1JKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 05:10:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588065051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mOdBWJKQxFlNabMwjODinAvYOR6ZDK7O0dodfKx0hcc=;
        b=HQxIY356M/rB0SgwJu05qPH0YLEvHPdr5eHZFtzY0oZhg5QCxCJkrON2Hd746h05HNAPtM
        VjeOFCgK69PCDyuABIKjTp8ul06RYH53iYpIuqd8mNBs+HffuQvj7TDLSdOxjPBWkOiTvx
        0u7CbuyZdeOQRGI8YG2NYYy/2D1d/C8=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-mur6Tm6lNaaBobcriw6vjQ-1; Tue, 28 Apr 2020 05:10:48 -0400
X-MC-Unique: mur6Tm6lNaaBobcriw6vjQ-1
Received: by mail-lf1-f69.google.com with SMTP id b22so8660914lfa.18
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 02:10:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=mOdBWJKQxFlNabMwjODinAvYOR6ZDK7O0dodfKx0hcc=;
        b=iHm8m6hqyCK/sHT5R7STOI4D+/7mm5uLENzrOgVqVttdgjLUphazGSzoFeIpcd+7EP
         hrCN3Gxfii+SPyxdjXdd55/7VzCvH10boszbbWcA8pbTLfOlvsNNqiUJBSR1k27BWGma
         QKxAl4QVYTMkl2Q2elCIz3iuw++ZvL5VVOQItZbf217cbWMQkfCD54j9pEkuXkeK5kSt
         APi4/EU/XUN/zNuWhXU7K3j/X6IuQyVl6cezxsaATYDRjFDkkD2sS4WPKdw0hmK1pDCD
         7o10cSsNfhQKOfylw20/ay08Nb7dFcuJQJdh8/235PAnABt6y/P38WGtFYmX7S7JjQb2
         d+tA==
X-Gm-Message-State: AGi0PuauF+j08/qPLr4ZpE/5nVCcAxSXVxVpSTIVa3t+PzM7Li+YocKc
        pyF6SwsspbzA6m+/ko5euPkmBM1tiUQzZSYajl9NYZm2kdWFRCFttfyuRQvMe8o6D1tNLIdlB/c
        4cgetwt9LEGMxtDFB
X-Received: by 2002:ac2:57cb:: with SMTP id k11mr18503634lfo.19.1588065046852;
        Tue, 28 Apr 2020 02:10:46 -0700 (PDT)
X-Google-Smtp-Source: APiQypIH/hZQ/rx7Ol7j9CLUYi6IHDh/x4Luka4wg/zRVzQni3QvyQRdLbuPtHuphYfxyjJMAsZnBg==
X-Received: by 2002:ac2:57cb:: with SMTP id k11mr18503620lfo.19.1588065046546;
        Tue, 28 Apr 2020 02:10:46 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id b28sm13669623lfo.46.2020.04.28.02.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 02:10:45 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DE4981814FF; Tue, 28 Apr 2020 11:10:43 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Rodney W. Grimes" <ietf@gndrsh.dnsmgr.net>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>,
        Dave Taht <dave.taht@gmail.com>,
        "Rodney W . Grimes" <ietf@gndrsh.dnsmgr.net>
Subject: Re: [PATCH net] wireguard: Use tunnel helpers for decapsulating ECN markings
In-Reply-To: <202004280109.03S19SCY001751@gndrsh.dnsmgr.net>
References: <202004280109.03S19SCY001751@gndrsh.dnsmgr.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 28 Apr 2020 11:10:43 +0200
Message-ID: <87zhawvuuk.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Rodney W. Grimes" <ietf@gndrsh.dnsmgr.net> writes:

> Replying to a single issue I am reading, and really hope I
> am miss understanding.  I am neither a wireguard or linux
> user so I may be miss understanding what is said.
>
> Inline at {RWG}
>
>> "Jason A. Donenfeld" <Jason@zx2c4.com> writes:
>> 
>> > Hey Toke,
>> >
>> > Thanks for fixing this. I wasn't aware there was a newer ECN RFC. A
>> > few comments below:
>> >
>> > On Mon, Apr 27, 2020 at 8:47 AM Toke H?iland-J?rgensen <toke@redhat.com> wrote:
>> >> RFC6040 also recommends dropping packets on certain combinations of
>> >> erroneous code points on the inner and outer packet headers which shouldn't
>> >> appear in normal operation. The helper signals this by a return value > 1,
>> >> so also add a handler for this case.
>> >
>> > This worries me. In the old implementation, we propagate some outer
>> > header data to the inner header, which is technically an authenticity
>> > violation, but minor enough that we let it slide. This patch here
>> > seems to make that violation a bit worse: namely, we're now changing
>> > the behavior based on a combination of outer header + inner header. An
>> > attacker can manipulate the outer header (set it to CE) in order to
>> > learn whether the inner header was CE or not, based on whether or not
>> > the packet gets dropped, which is often observable. That's some form
>
> Why is anyone dropping on decap over the CE bit?  It should be passed
> on, not lead to a packet drop.  If the outer header is CE on an inner
> header of CE it should just continue to be a CE, dropping it is actually
> breaking the purpose of the CE codepoint, to signal congestion before
> having to cause a packet loss.
>
>> > of an oracle, which I'm not too keen on having in wireguard. On the
>> > other hand, we pretty much already _explicitly leak this bit_ on tx
>> > side -- in send.c:
>> >
>> > PACKET_CB(skb)->ds = ip_tunnel_ecn_encap(0, ip_hdr(skb), skb); // inner packet
>> > ...
>> > wg_socket_send_skb_to_peer(peer, skb, PACKET_CB(skb)->ds); // outer packet
>> >
>> > We considered that leak a-okay. But a decryption oracle seems slightly
>> > worse than an explicit and intentional leak. But maybe not that much
>> > worse.
>> 
>> Well, seeing as those two bits on the outer header are already copied
>> from the inner header, there's no additional leak added by this change,
>> is there? An in-path observer could set CE and observe that the packet
>> gets dropped, but all they would learn is that the bits were zero
>
> Again why is CE leading to anyone dropping?
>
>> (non-ECT). Which they already knew because they could just read the bits
>> directly from the header.
>> 
>> Also note, BTW, that another difference between RFC 3168 and 6040 is the
>> propagation of ECT(1) from outer to inner header. That's not actually
>> done correctly in Linux ATM, but I sent a separate patch to fix this[0],
>> which Wireguard will also benefit from with this patch.
>
> Thanks for this.
>
>> 
>> > I wanted to check with you: is the analysis above correct? And can you
>> > somehow imagine the ==2 case leading to different behavior, in which
>> > the packet isn't dropped? Or would that ruin the "[de]congestion" part
>> > of ECN? I just want to make sure I understand the full picture before
>> > moving in one direction or another.
>> 
>> So I think the logic here is supposed to be that if there are CE marks
>> on the outer header, then an AQM somewhere along the path has marked the
>> packet, which is supposed to be a congestion signal, which we want to
>> propagate all the way to the receiver (who will then echo it back to the
>> receiver). However, if the inner packet is non-ECT then we can't
>> actually propagate the ECN signal; and a drop is thus the only
>> alternative congestion signal available to us.
>
> You cannot get a CE mark on the outer packet if the inner packet is
> not ECT, as the outer packet would also be not ECT and thus not
> eligible for CE mark.  If you get the above sited condition something
> has gone *wrong*.

Yup, you're quite right. If everything is working correctly, this should
never happen. This being the internet, though, there are bound to be
cases where it will go wrong :)

>> This case shouldn't
>> actually happen that often, a middlebox has to be misconfigured to
>> CE-mark a non-ECT packet in the first place. But, well, misconfigured
>> middleboxes do exist as you're no doubt aware :)
>
> That is true, though I believe the be liberal in what you accept
> concept would say ok, someone messed up, just propogate it and
> let the end nodes deal with it, otherwise your creating a blackhole
> that could be very hard to find.

But that would lead you to ignore a congestion signal. And someone has
to go through an awful lot of trouble to set this signal; if they're
just randomly mangling bits the packet checksum will likely be wrong and
the packet would be dropped anyway. So on balance I'd tend to agree with
the RFC that the right thing to do is to propagate the congestion
signal; which in the case of a non-ECT packet means dropping it,
otherwise we'd just be contributing to the RFC-violating behaviour...

I do believe the advice in the RFC to log these cases is exactly because
of the risk of blackholes you're referring to. I discussed this a bit
with Jason and we ended up agreeing that just marking it as a framing
error should be enough for Wireguard, though...

-Toke

