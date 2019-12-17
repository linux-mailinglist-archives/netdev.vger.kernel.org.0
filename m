Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF9E01230BA
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 16:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbfLQPou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 10:44:50 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:31574 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727161AbfLQPou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 10:44:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1576597489; x=1608133489;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KAl+UGDySnmx+F/jTLgSKmBsW+z058V6NKxC8tKH/04=;
  b=aPJI7bqKllqVmJY8e7HAEFKv/ENKw5pW6xxTTijD+F2Oma2GhWyqDp8S
   Xpo6/g5JlxsVKENppN5WS/ZYW2C1W+zBa1nRF6q1EgI16p2cNHHzQjBKN
   uoGDWZ1JufJzUQUiQk7oCf+oegzc8edz3Z2e9+k+fZkAt2r1DASj/wma9
   A=;
IronPort-SDR: 1W1vj3TlF0cBxEcaSDIn1j9rVjSDXF50wTM7y7e7zGUWoK1z0eWm6i6p5cYlAcqF4Cclwt5Aac
 tEOSWZuOGqDw==
X-IronPort-AV: E=Sophos;i="5.69,325,1571702400"; 
   d="scan'208";a="8879619"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 17 Dec 2019 15:44:47 +0000
Received: from EX13MTAUEA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (Postfix) with ESMTPS id 8E4A4A2A0B;
        Tue, 17 Dec 2019 15:44:46 +0000 (UTC)
Received: from EX13D10EUB002.ant.amazon.com (10.43.166.66) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 17 Dec 2019 15:44:45 +0000
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13D10EUB002.ant.amazon.com (10.43.166.66) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 17 Dec 2019 15:44:44 +0000
Received: from EX13D11EUB003.ant.amazon.com ([10.43.166.58]) by
 EX13D11EUB003.ant.amazon.com ([10.43.166.58]) with mapi id 15.00.1367.000;
 Tue, 17 Dec 2019 15:44:44 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        Luigi Rizzo <rizzo@iet.unipi.it>
CC:     "Machulsky, Zorik" <zorik@amazon.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David Ahern" <dsahern@gmail.com>,
        "brouer@redhat.com" <brouer@redhat.com>
Subject: RE: XDP multi-buffer design discussion
Thread-Topic: XDP multi-buffer design discussion
Thread-Index: AQHVtBpASGPq4yH+3UGFRZGKpkgdhKe9uPIAgABL04CAAAPwgIAAcB9Q
Date:   Tue, 17 Dec 2019 15:44:44 +0000
Message-ID: <97dddd1c0f954ee1984032c3be412d06@EX13D11EUB003.ant.amazon.com>
References: <BA8DC06A-C508-402D-8A18-B715FBA674A2@amazon.com>
 <b28504a3-4a55-d302-91fe-63915e4568d3@iogearbox.net>
 <5FA3F980-29E6-4B91-8150-9F28C0E09C45@amazon.com>
 <20190823084704.075aeebd@carbon>
 <67C7F66A-A3F7-408F-9C9E-C53982BCCD40@amazon.com>
 <20191204155509.6b517f75@carbon>
 <ec2fd7f6da44410fbaeb021cf984f2f6@EX13D11EUC003.ant.amazon.com>
 <20191216150728.38c50822@carbon>
 <CA+hQ2+jp471vBvRna7ugdYyFgEB63a9tgCXZCOjEQkT+tZTM1g@mail.gmail.com>
 <20191217094635.7e4cac1c@carbon> <87eex38gxy.fsf@toke.dk>
In-Reply-To: <87eex38gxy.fsf@toke.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.68]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Toke H=F8iland-J=F8rgensen <toke@redhat.com>
> Sent: Tuesday, December 17, 2019 11:01 AM
> To: Jesper Dangaard Brouer <brouer@redhat.com>; Luigi Rizzo
> <rizzo@iet.unipi.it>
> Cc: Jubran, Samih <sameehj@amazon.com>; Machulsky, Zorik
> <zorik@amazon.com>; Daniel Borkmann <borkmann@iogearbox.net>; David
> Miller <davem@davemloft.net>; Tzalik, Guy <gtzalik@amazon.com>; Ilias
> Apalodimas <ilias.apalodimas@linaro.org>; Kiyanovski, Arthur
> <akiyano@amazon.com>; Alexei Starovoitov <ast@kernel.org>;
> netdev@vger.kernel.org; David Ahern <dsahern@gmail.com>;
> brouer@redhat.com
> Subject: Re: XDP multi-buffer design discussion
>=20
> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>=20
> > On Mon, 16 Dec 2019 20:15:12 -0800
> > Luigi Rizzo <rizzo@iet.unipi.it> wrote:
> >
> >> On Mon, Dec 16, 2019 at 6:07 AM Jesper Dangaard Brouer
> >> <brouer@redhat.com> wrote:
> >> >
> >> >
> >> > See answers inlined below (please get an email client that support
> >> > inline replies... to interact with this community)
> >> >
> >> > On Sun, 15 Dec 2019 13:57:12 +0000
> >> > "Jubran, Samih" <sameehj@amazon.com> wrote:
> >> ...
> >> > > * Why should we provide the fragments to the bpf program if the
> >> > > program doesn't access them? If validating the length is what
> >> > > matters, we can provide only the full length info to the user
> >> > > with no issues.
> >> >
> >> > My Proposal#1 (in [base-doc]) is that XDP only get access to the
> >> > first-buffer.  People are welcome to challenge this choice.
> >> >
> >> > There are a several sub-questions and challenges hidden inside this
> >> > choice.
> >> >
> >> > As you hint, the total length... spawns some questions we should
> answer:
> >> >
> >> >  (1) is it relevant to the BPF program to know this, explain the use=
-case.
> >> >
> >> >  (2) if so, how does BPF prog access info (without slowdown
> >> > baseline)
> >>
> >> For some use cases, the bpf program could deduct the total length
> >> looking at the L3 header.
> >
> > Yes, that actually good insight.  I guess the BPF-program could also
> > use this to detect that it doesn't have access to the full-lineary
> > packet this way(?)
> >
> >> It won't work for XDP_TX response though.
> >
> > The XDP_TX case also need to be discussed/handled. IMHO need to
> > support XDP_TX for multi-buffer frames.  XDP_TX *can* be driver
> > specific, but most drivers choose to convert xdp_buff to xdp_frame,
> > which makes it possible to use/share part of the XDP_REDIRECT code from
> ndo_xdp_xmit.
> >
> > We also need to handle XDP_REDIRECT, which becomes challenging, as the
> > ndo_xdp_xmit functions of *all* drivers need to be updated (or
> > introduce a flag to handle this incrementally).
>=20
> If we want to handle TX and REDIRECT (which I agree we do!), doesn't that
> imply that we have to structure the drivers so the XDP program isn't
> executed until we have the full packet (i.e., on the last segment)?
>=20
> -Toke

Hi All,

Thank you for participating in this discussion, everything that was mention=
ed above is a good insight.
I'd like to sum it up with the following key points, please tell me if I'm =
missing something and share your opinions.

* The rationale to supply the frags are the following:
** XDP_PASS optimization: in case the verdict is XDP_PASS, creating the skb=
 can save some work
** XDP_TX: when the verdict is XDP_TX, we need all the frags ready in order=
 to send the packet
** The rx-loop of the driver must be modified, so why not supply informatio=
n that already have been
   deducted and this should be great for the future in case XDP will be abl=
e to access the frags

* Since the XDP program won't be accessing the frags, we don't need to modi=
fy the xdp_convert_ctx_access() function, correct?

* We do need to add a way for the driver to indicate to the kernel that it =
supports multi buff. This is needed so we can reject programs that use bpf_=
xdp_adjust_tail()

- Sameeh

