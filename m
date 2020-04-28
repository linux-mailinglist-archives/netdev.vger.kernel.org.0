Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCFE91BCC6B
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 21:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728620AbgD1Tbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 15:31:35 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:55851 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728474AbgD1Tbf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 15:31:35 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 198dd6bd
        for <netdev@vger.kernel.org>;
        Tue, 28 Apr 2020 19:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type:content-transfer-encoding; s=mail; bh=4NCKMAp2LSLS
        oYjS3aFGTpYEyUY=; b=CMXeFZKurtXsLGq5BPnplJfLPG9FNGqKXFIylTvUfkXS
        DfO7j2Pg9jv4TOtXQDmlEoPBlehTf5nZdphKqv5sAPD45+lw/IjhrljxHRsmzqv1
        s/c/AUZj7za0GLPXT/Pyt/3EzlFZlsmACJExj++/lJuNpFN7kaSWItZvArSs4P6l
        o8p+I02ucX/SBeMXvq+g44qoS/9zmuIWdaa4m3xon9Lvsc5J+EB/wLPll/kPlW0d
        dCnP1PlZjL/fOfa/CNEPkCJTvjyqvFTnHOkv8nKmZl+Ixl2qoUXI4ZomRGk7EsDh
        tk/uXWY6dRzpm6Ifw5u7K5I1ny7BLqvJu0fECEDpvg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 405b5360 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Tue, 28 Apr 2020 19:19:50 +0000 (UTC)
Received: by mail-il1-f175.google.com with SMTP id r2so29103ilo.6
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 12:31:31 -0700 (PDT)
X-Gm-Message-State: AGi0PuZcJHM/JuIkIM+bV0jyd33HF/efVT5H7kGoXrgyBDr4Y/320wHm
        BM+TGUEa4xVZqLlPYY/whp8haUosMIbRsD/GE04=
X-Google-Smtp-Source: APiQypKb0531/kVPrh6Z1b8+s/w0CF5PuL/5L8upMvFlXWdwXmA6XzGdHFQZ9dNk165QD4a6cLyq7HnFMw7wt9Ea4hA=
X-Received: by 2002:a92:bf0b:: with SMTP id z11mr27828279ilh.207.1588102290135;
 Tue, 28 Apr 2020 12:31:30 -0700 (PDT)
MIME-Version: 1.0
References: <202004280109.03S19SCY001751@gndrsh.dnsmgr.net>
 <87zhawvuuk.fsf@toke.dk> <CAA93jw7-yiy=ic71DWG4XHLU5eCGb1p-6bKVX7NQFmTOu+jpLQ@mail.gmail.com>
In-Reply-To: <CAA93jw7-yiy=ic71DWG4XHLU5eCGb1p-6bKVX7NQFmTOu+jpLQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 28 Apr 2020 13:31:18 -0600
X-Gmail-Original-Message-ID: <CAHmME9o1binUdw40Uxw7+RU6pDse7k0bw5seNy2CHZ3hw+Pw3Q@mail.gmail.com>
Message-ID: <CAHmME9o1binUdw40Uxw7+RU6pDse7k0bw5seNy2CHZ3hw+Pw3Q@mail.gmail.com>
Subject: Re: [PATCH net] wireguard: Use tunnel helpers for decapsulating ECN markings
To:     Dave Taht <dave.taht@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
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

On Tue, Apr 28, 2020 at 12:52 PM Dave Taht <dave.taht@gmail.com> wrote:
>
> On Tue, Apr 28, 2020 at 2:10 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
> >
> > "Rodney W. Grimes" <ietf@gndrsh.dnsmgr.net> writes:
> >
> > > Replying to a single issue I am reading, and really hope I
> > > am miss understanding.  I am neither a wireguard or linux
> > > user so I may be miss understanding what is said.
> > >
> > > Inline at {RWG}
> > >
> > >> "Jason A. Donenfeld" <Jason@zx2c4.com> writes:
> > >>
> > >> > Hey Toke,
> > >> >
> > >> > Thanks for fixing this. I wasn't aware there was a newer ECN RFC. =
A
> > >> > few comments below:
> > >> >
> > >> > On Mon, Apr 27, 2020 at 8:47 AM Toke H?iland-J?rgensen <toke@redha=
t.com> wrote:
> > >> >> RFC6040 also recommends dropping packets on certain combinations =
of
> > >> >> erroneous code points on the inner and outer packet headers which=
 shouldn't
> > >> >> appear in normal operation. The helper signals this by a return v=
alue > 1,
> > >> >> so also add a handler for this case.
> > >> >
> > >> > This worries me. In the old implementation, we propagate some oute=
r
> > >> > header data to the inner header, which is technically an authentic=
ity
> > >> > violation, but minor enough that we let it slide. This patch here
> > >> > seems to make that violation a bit worse: namely, we're now changi=
ng
> > >> > the behavior based on a combination of outer header + inner header=
. An
> > >> > attacker can manipulate the outer header (set it to CE) in order t=
o
> > >> > learn whether the inner header was CE or not, based on whether or =
not
> > >> > the packet gets dropped, which is often observable. That's some fo=
rm
> > >
> > > Why is anyone dropping on decap over the CE bit?  It should be passed
> > > on, not lead to a packet drop.  If the outer header is CE on an inner
> > > header of CE it should just continue to be a CE, dropping it is actua=
lly
> > > breaking the purpose of the CE codepoint, to signal congestion before
> > > having to cause a packet loss.
> > >
> > >> > of an oracle, which I'm not too keen on having in wireguard. On th=
e
> > >> > other hand, we pretty much already _explicitly leak this bit_ on t=
x
> > >> > side -- in send.c:
> > >> >
> > >> > PACKET_CB(skb)->ds =3D ip_tunnel_ecn_encap(0, ip_hdr(skb), skb); /=
/ inner packet
> > >> > ...
> > >> > wg_socket_send_skb_to_peer(peer, skb, PACKET_CB(skb)->ds); // oute=
r packet
> > >> >
> > >> > We considered that leak a-okay. But a decryption oracle seems slig=
htly
> > >> > worse than an explicit and intentional leak. But maybe not that mu=
ch
> > >> > worse.
> > >>
> > >> Well, seeing as those two bits on the outer header are already copie=
d
> > >> from the inner header, there's no additional leak added by this chan=
ge,
> > >> is there? An in-path observer could set CE and observe that the pack=
et
> > >> gets dropped, but all they would learn is that the bits were zero
> > >
> > > Again why is CE leading to anyone dropping?
> > >
> > >> (non-ECT). Which they already knew because they could just read the =
bits
> > >> directly from the header.
> > >>
> > >> Also note, BTW, that another difference between RFC 3168 and 6040 is=
 the
> > >> propagation of ECT(1) from outer to inner header. That's not actuall=
y
> > >> done correctly in Linux ATM, but I sent a separate patch to fix this=
[0],
> > >> which Wireguard will also benefit from with this patch.
>
> I note that there is a large ISP in argentina that has been
> mis-marking most udp & tcp traffic
> as CE for years now and despite many attempts to get 'em to fix it,
> when last I checked (2? 3?)
> months back, they still were doing it.
>
> My impression of overall competence and veracity of multiple transit
> and isp providers has been sorely
> tried recently. While I support treating ect 1 and 2 properly, I am
> inclined to start thinking that
> ce on a non-ect encapsulated packet is something that should not be dropp=
ed.
>
> but, whatever is decided on that front is in the hooks in the other
> patch above, not in wireguard,
> and I'll make the same comment there.

Thanks for pointing this out. We're going to drop the dropping
behavior in wireguard, especially in light of the fact that folks like
to use wireguard for working around issues with their broken ISP or in
other weird circumstances.
