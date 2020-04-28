Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D72F71BCAD9
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 20:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731036AbgD1Sw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 14:52:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730364AbgD1SwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 14:52:25 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EA6C03C1AB
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 11:52:25 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id i19so24379920ioh.12
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 11:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YcolCA5UGsYd8MO7lKIdAOUu80aS6WVfbJK7dKN2m8E=;
        b=IZp8na6n/r3Oqsj+jER/mQ/xuY7Tp9L5AKTFZsSkvPJlr4ymLDOlWybi3dh28GOYOa
         QyT/tLODYquhyyzEVOMkPRk2EZszGgRSp2qn/ebBhKaDkwyd3sb+mS4h50PJOhv2oUXR
         W67wmpRsUm4jgldD5X39hLgsWHWNFP8zgpMlZDfiMH07dVzZD6NMUW93Opl706ZldOvE
         nHRkNCmidf9R91MZ+xAmUmo9FNvWyJKlg8pTeh9rnc3dxLrzrxUcqmbeUKt1+vXXo219
         05eW+qWpAKY1wu47erhel53qE3z9adaIV7ECBM0UN2U7Mx2jn8pQ31TUWgqcT/FJ+TqT
         jLbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YcolCA5UGsYd8MO7lKIdAOUu80aS6WVfbJK7dKN2m8E=;
        b=sPDo1LW/HSIE/kHGGhfjP4h96FPZZ8Fu1l5c8IVph6ytiGGy4rAnLmIB9CexBV7JDS
         PsTzerYcuJisQiPg1EzDGmIkhgz3Dp8mVn7rJK+GH2ZK8dZ1kat5TmfeEwzbwRQEtnDa
         kbXP4adXBjl7Nbz3moU+qYwGkXl2eZrOTqUi69df/bzRxOL9c3NsdSDVaeLb6t1/LoIc
         sYMG9bzbpoxm43wKG4stBIaliWnkyNwub5Pb2dnICxZixpOV1GGz5GJWZlZWBm/gHkTR
         aw2Mcr+sWW3n5HMxOU3cCbRsFsKFYKJclbvoyNPDAkqdBh6lGKM0lNpynbIiPls2UmyJ
         kg+Q==
X-Gm-Message-State: AGi0PuaBMzUUPgOtUlRAcq/DiPrs3X/m45NFtDDsXQ79f+eq0yshkU3P
        TkpRS5F2L1FkGSVMJmLRlYYPzUERKLhrQ/LLwDw=
X-Google-Smtp-Source: APiQypLc8aP0uRejii9qw2EagnHuGCj/cbUVwj8w8sugKxx9Jp3UJ+ZUigGcmdcg0k0CAfVSEBrjYbuOgcuGzAX+4WI=
X-Received: by 2002:a02:a90e:: with SMTP id n14mr26109946jam.97.1588099944699;
 Tue, 28 Apr 2020 11:52:24 -0700 (PDT)
MIME-Version: 1.0
References: <202004280109.03S19SCY001751@gndrsh.dnsmgr.net> <87zhawvuuk.fsf@toke.dk>
In-Reply-To: <87zhawvuuk.fsf@toke.dk>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Tue, 28 Apr 2020 11:52:13 -0700
Message-ID: <CAA93jw7-yiy=ic71DWG4XHLU5eCGb1p-6bKVX7NQFmTOu+jpLQ@mail.gmail.com>
Subject: Re: [PATCH net] wireguard: Use tunnel helpers for decapsulating ECN markings
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Olivier Tilmans <olivier.tilmans@nokia-bell-labs.com>,
        "Rodney W . Grimes" <ietf@gndrsh.dnsmgr.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 2:10 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> "Rodney W. Grimes" <ietf@gndrsh.dnsmgr.net> writes:
>
> > Replying to a single issue I am reading, and really hope I
> > am miss understanding.  I am neither a wireguard or linux
> > user so I may be miss understanding what is said.
> >
> > Inline at {RWG}
> >
> >> "Jason A. Donenfeld" <Jason@zx2c4.com> writes:
> >>
> >> > Hey Toke,
> >> >
> >> > Thanks for fixing this. I wasn't aware there was a newer ECN RFC. A
> >> > few comments below:
> >> >
> >> > On Mon, Apr 27, 2020 at 8:47 AM Toke H?iland-J?rgensen <toke@redhat.=
com> wrote:
> >> >> RFC6040 also recommends dropping packets on certain combinations of
> >> >> erroneous code points on the inner and outer packet headers which s=
houldn't
> >> >> appear in normal operation. The helper signals this by a return val=
ue > 1,
> >> >> so also add a handler for this case.
> >> >
> >> > This worries me. In the old implementation, we propagate some outer
> >> > header data to the inner header, which is technically an authenticit=
y
> >> > violation, but minor enough that we let it slide. This patch here
> >> > seems to make that violation a bit worse: namely, we're now changing
> >> > the behavior based on a combination of outer header + inner header. =
An
> >> > attacker can manipulate the outer header (set it to CE) in order to
> >> > learn whether the inner header was CE or not, based on whether or no=
t
> >> > the packet gets dropped, which is often observable. That's some form
> >
> > Why is anyone dropping on decap over the CE bit?  It should be passed
> > on, not lead to a packet drop.  If the outer header is CE on an inner
> > header of CE it should just continue to be a CE, dropping it is actuall=
y
> > breaking the purpose of the CE codepoint, to signal congestion before
> > having to cause a packet loss.
> >
> >> > of an oracle, which I'm not too keen on having in wireguard. On the
> >> > other hand, we pretty much already _explicitly leak this bit_ on tx
> >> > side -- in send.c:
> >> >
> >> > PACKET_CB(skb)->ds =3D ip_tunnel_ecn_encap(0, ip_hdr(skb), skb); // =
inner packet
> >> > ...
> >> > wg_socket_send_skb_to_peer(peer, skb, PACKET_CB(skb)->ds); // outer =
packet
> >> >
> >> > We considered that leak a-okay. But a decryption oracle seems slight=
ly
> >> > worse than an explicit and intentional leak. But maybe not that much
> >> > worse.
> >>
> >> Well, seeing as those two bits on the outer header are already copied
> >> from the inner header, there's no additional leak added by this change=
,
> >> is there? An in-path observer could set CE and observe that the packet
> >> gets dropped, but all they would learn is that the bits were zero
> >
> > Again why is CE leading to anyone dropping?
> >
> >> (non-ECT). Which they already knew because they could just read the bi=
ts
> >> directly from the header.
> >>
> >> Also note, BTW, that another difference between RFC 3168 and 6040 is t=
he
> >> propagation of ECT(1) from outer to inner header. That's not actually
> >> done correctly in Linux ATM, but I sent a separate patch to fix this[0=
],
> >> which Wireguard will also benefit from with this patch.

I note that there is a large ISP in argentina that has been
mis-marking most udp & tcp traffic
as CE for years now and despite many attempts to get 'em to fix it,
when last I checked (2? 3?)
months back, they still were doing it.

My impression of overall competence and veracity of multiple transit
and isp providers has been sorely
tried recently. While I support treating ect 1 and 2 properly, I am
inclined to start thinking that
ce on a non-ect encapsulated packet is something that should not be dropped=
.

but, whatever is decided on that front is in the hooks in the other
patch above, not in wireguard,
and I'll make the same comment there.



> >
> > Thanks for this.
> >
> >>
> >> > I wanted to check with you: is the analysis above correct? And can y=
ou
> >> > somehow imagine the =3D=3D2 case leading to different behavior, in w=
hich
> >> > the packet isn't dropped? Or would that ruin the "[de]congestion" pa=
rt
> >> > of ECN? I just want to make sure I understand the full picture befor=
e
> >> > moving in one direction or another.
> >>
> >> So I think the logic here is supposed to be that if there are CE marks
> >> on the outer header, then an AQM somewhere along the path has marked t=
he
> >> packet, which is supposed to be a congestion signal, which we want to
> >> propagate all the way to the receiver (who will then echo it back to t=
he
> >> receiver). However, if the inner packet is non-ECT then we can't
> >> actually propagate the ECN signal; and a drop is thus the only
> >> alternative congestion signal available to us.
> >
> > You cannot get a CE mark on the outer packet if the inner packet is
> > not ECT, as the outer packet would also be not ECT and thus not
> > eligible for CE mark.  If you get the above sited condition something
> > has gone *wrong*.
>
> Yup, you're quite right. If everything is working correctly, this should
> never happen. This being the internet, though, there are bound to be
> cases where it will go wrong :)
>
> >> This case shouldn't
> >> actually happen that often, a middlebox has to be misconfigured to
> >> CE-mark a non-ECT packet in the first place. But, well, misconfigured
> >> middleboxes do exist as you're no doubt aware :)
> >
> > That is true, though I believe the be liberal in what you accept
> > concept would say ok, someone messed up, just propogate it and
> > let the end nodes deal with it, otherwise your creating a blackhole
> > that could be very hard to find.
>
> But that would lead you to ignore a congestion signal. And someone has
> to go through an awful lot of trouble to set this signal; if they're
> just randomly mangling bits the packet checksum will likely be wrong and
> the packet would be dropped anyway. So on balance I'd tend to agree with
> the RFC that the right thing to do is to propagate the congestion
> signal; which in the case of a non-ECT packet means dropping it,
> otherwise we'd just be contributing to the RFC-violating behaviour...
>
> I do believe the advice in the RFC to log these cases is exactly because
> of the risk of blackholes you're referring to. I discussed this a bit
> with Jason and we ended up agreeing that just marking it as a framing
> error should be enough for Wireguard, though...
>
> -Toke
>


--=20
Make Music, Not War

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-435-0729
