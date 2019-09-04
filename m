Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C15EA8059
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 12:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfIDK22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 06:28:28 -0400
Received: from resqmta-ch2-12v.sys.comcast.net ([69.252.207.44]:40538 "EHLO
        resqmta-ch2-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725938AbfIDK22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 06:28:28 -0400
Received: from resomta-ch2-17v.sys.comcast.net ([69.252.207.113])
        by resqmta-ch2-12v.sys.comcast.net with ESMTP
        id 5SU3iLGqPu4yf5SWYiuDva; Wed, 04 Sep 2019 10:28:26 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=comcast.net;
        s=20190202a; t=1567592906;
        bh=U9sHbJUrPdC6rf/6t1yEEzGO9esImLmbyvU1pC/GHMg=;
        h=Received:Received:From:To:Subject:Date:Message-ID:MIME-Version:
         Content-Type;
        b=tJRrmHdUeMiSS0TLoNOB8B/E7IHrPKmUXh6In9/kmJSHGTXAF6nyT8jofD3doamnE
         Q/mtH4oPdO1zgLOFpwoWt88gfG3RcrkppefxteKLckxDjKzoiBYLrJfh4seflv3dL9
         uWl6OqzsNzR184ReeXwJpneKWYSw6UVmT5p2roJvNIG1l6U7XEghmkfO2NicMjEZeq
         AxsLACRPLKyjnLjlqpW32KfVTm6clKSDnpoPzOZzb8uNggEyU5kA8OSin0vT1Gw5dP
         AbeMM8BQDQo/vb6Y7l20Yw4gRNhjHM8Cvx2nQ/xe8gp68u8NxrqqN4KjTBPGRLsDG3
         Qi0EP3HrImAtQ==
Received: from DireWolf ([108.49.206.201])
        by resomta-ch2-17v.sys.comcast.net with ESMTPSA
        id 5SW8i9tl7e7865SW9iQB9B; Wed, 04 Sep 2019 10:28:24 +0000
X-Xfinity-VAAS: gggruggvucftvghtrhhoucdtuddrgeduvddrudejhedgvdejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuvehomhgtrghsthdqtfgvshhipdfqfgfvpdfpqffurfetoffkrfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhephffvfhgjufffkfggtgfgofhtsehtqhhgtddvtdejnecuhfhrohhmpedfufhtvghvvgcukggrsggvlhgvfdcuoeiirggsvghlvgestghomhgtrghsthdrnhgvtheqnecukfhppedutdekrdegledrvddtiedrvddtudenucfrrghrrghmpehhvghlohepffhirhgvhgholhhfpdhinhgvthepuddtkedrgeelrddvtdeirddvtddupdhmrghilhhfrhhomhepiigrsggvlhgvsegtohhmtggrshhtrdhnvghtpdhrtghpthhtohepuggrnhhivghlsehiohhgvggrrhgsohigrdhnvghtpdhrtghpthhtohepvghrihgtrdguuhhmrgiivghtsehgmhgrihhlrdgtohhmpdhrtghpthhtohepmhgrrhhkrdhkvggrthhonhesrhgrhihthhgvohhnrdgtohhmpdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepohhnvdhkudeinhhmsehgmhgrihhlrdgtohhmpdhrtghpthhtohepshgrihhfihdrkhhhrghnsehsthhrihhkrhdrihhnpdhrtghpthhtohepshhhuhhmsegtrghnnhgurhgvfidrohhrghdprhgtphhtthhopehsthgvphhhvghnsehnvghtfihorhhkphhluhhmsggvrhdrohhrghdprhgtphhtthhopehvlhgrughimhhirhd
X-Xfinity-VMeta: sc=-100;st=legit
From:   "Steve Zabele" <zabele@comcast.net>
To:     "'Willem de Bruijn'" <willemdebruijn.kernel@gmail.com>
Cc:     "'Eric Dumazet'" <eric.dumazet@gmail.com>,
        "'Network Development'" <netdev@vger.kernel.org>,
        <shum@canndrew.org>, <vladimir116@gmail.com>,
        <saifi.khan@strikr.in>, "'Daniel Borkmann'" <daniel@iogearbox.net>,
        <on2k16nm@gmail.com>,
        "'Stephen Hemminger'" <stephen@networkplumber.org>,
        <mark.keaton@raytheon.com>
References: <010601d53bdc$79c86dc0$6d594940$@net> <20190716070246.0745ee6f@hermes.lan> <01db01d559e5$64d71de0$2e8559a0$@net> <CA+FuTSdu5inPWp_jkUcFnb-Fs-rdk0AMiieCYtjLE7Qs5oFWZQ@mail.gmail.com> <8f4bda24-5bd4-3f12-4c98-5e1097dde84a@gmail.com> <CA+FuTSf4iLXh-+ADfBNxqcsw=u_vGm7Wsx7vchgwgwvGFYOA6w@mail.gmail.com> <CA+FuTSdi=tw=N4X2f+paFNM7KHqBgNkV_se-ykZ0+WoA7q0AhQ@mail.gmail.com>
In-Reply-To: <CA+FuTSdi=tw=N4X2f+paFNM7KHqBgNkV_se-ykZ0+WoA7q0AhQ@mail.gmail.com>
Subject: RE: Is bug 200755 in anyone's queue??
Date:   Wed, 4 Sep 2019 06:28:05 -0400
Message-ID: <00aa01d5630b$7e062660$7a127320$@net>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AdVigOLv32ofXOqlSUCezHMwRQbyvAAheY+A
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Willem,

Thanks for continuing to poke at this, much appreciated!

>As for the BPF program: good point on accessing the udp port when
>skb->data is already beyond the header.

> Programs of type sk_filter can use bpf_skb_load_bytes(_relative).
>Which I think will work, but have not tested.

Please note that the test code was intentionally set up to make testing =
as simple as possible. Hence the source addresses for the multiple UDP =
sessions were identical -- but that is not the general case. In the =
general case a connected and bound socket should be associated with =
exactly one five tuple (source and dest addresses, source and =
destination ports, and protocol.

So a 'connect bpf' would actually need access to the IP addresses as =
well, not just the ports. To do this, the load bytes call required =
negative arguments, which failed miserably when we tried it.

In any event, there remains the issue of figuring out which index to =
return when a match is detected since the index is not the same as the =
file descriptor value and in fact can change as file descriptors are =
added and deleted. If I understand the kernel mechanism correctly, the =
operation is something like this. When you add the first one, its =
assigned to the first slot; when you add the second its assigned to the =
second slot; when you delete the first one, the second is moved to the =
first slot) so tracking this requires figuring out the order stored in =
the socket array within the kernel, and updating the bpf whenever =
something changes. I don't know if it's even possible to query which =
slot a given=20

So we think handling this with a bpf is really not viable.

One thing worth mentioning is that the connect mechanism here is meant =
to (at least used to) work the same as connect does with TCP. Bind sets =
the expected/required local address and port; connect sets the =
expected/required remote address and port -- so a socket file descriptor =
becomes associated with exactly one five-tuple. That's how it's worked =
for several decades anyway.

Thanks again!!!

Steve

-----Original Message-----
From: Willem de Bruijn [mailto:willemdebruijn.kernel@gmail.com]=20
Sent: Tuesday, September 03, 2019 1:56 PM
Cc: Eric Dumazet; Steve Zabele; Network Development; shum@canndrew.org; =
vladimir116@gmail.com; saifi.khan@strikr.in; Daniel Borkmann; =
on2k16nm@gmail.com; Stephen Hemminger
Subject: Re: Is bug 200755 in anyone's queue??

On Fri, Aug 30, 2019 at 4:30 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Fri, Aug 30, 2019 at 4:54 AM Eric Dumazet <eric.dumazet@gmail.com> =
wrote:
> >
> >
> >
> > On 8/29/19 9:26 PM, Willem de Bruijn wrote:
> >
> > > SO_REUSEPORT was not intended to be used in this way. Opening
> > > multiple connected sockets with the same local port.
> > >
> > > But since the interface allowed connect after joining a group, and
> > > that is being used, I guess that point is moot. Still, I'm a bit
> > > surprised that it ever worked as described.
> > >
> > > Also note that the default distribution algorithm is not round =
robin
> > > assignment, but hash based. So multiple consecutive datagrams =
arriving
> > > at the same socket is not unexpected.
> > >
> > > I suspect that this quick hack might "work". It seemed to on the
> > > supplied .c file:
> > >
> > >                   score =3D compute_score(sk, net, saddr, sport,
> > >                                         daddr, hnum, dif, sdif);
> > >                   if (score > badness) {
> > >   -                       if (sk->sk_reuseport) {
> > >   +                       if (sk->sk_reuseport && !sk->sk_state =
!=3D
> > > TCP_ESTABLISHED) {
>
> This won't work for a mix of connected and connectionless sockets, of
> course (even ignoring the typo), as it only skips reuseport on the
> connected sockets.
>
> > >
> > > But a more robust approach, that also works on existing kernels, =
is to
> > > swap the default distribution algorithm with a custom BPF based =
one (
> > > SO_ATTACH_REUSEPORT_EBPF).
> > >
> >
> > Yes, I suspect that reuseport could still be used by to load-balance =
incoming packets
> > targetting the same 4-tuple.
> >
> > So all sockets would have the same score, and we would select the =
first socket in
> > the list (if not applying reuseport hashing)
>
> Can you elaborate a bit?
>
> One option I see is to record in struct sock_reuseport if any port in
> the group is connected and, if so, don't return immediately on the
> first reuseport_select_sock hit, but continue the search for a higher
> scoring connected socket.
>
> Or do return immediately, but do this refined search in
> reuseport_select_sock itself, as it has a reference to all sockets in =
the
> group in sock_reuseport->socks[]. Instead of the straightforward hash.

That won't work, as reuseport_select_sock does not have access to
protocol specific data, notably inet_dport.

Unfortunately, what I've come up with so far is not concise and slows
down existing reuseport lookup in a busy port table slot. Note that it
is needed for both ipv4 and ipv6.

Do not break out of the port table slot early, but continue to search
for a higher scored match even after matching a reuseport:

"
   @@ -413,28 +413,39 @@ static struct sock *udp4_lib_lookup2(struct net =
*net,
                                     struct udp_hslot *hslot2,
                                     struct sk_buff *skb)
 {
+       struct sock *reuseport_result =3D NULL;
        struct sock *sk, *result;
+       int reuseport_score =3D 0;
        int score, badness;
        u32 hash =3D 0;

        result =3D NULL;
        badness =3D 0;
        udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
                score =3D compute_score(sk, net, saddr, sport,
                                      daddr, hnum, dif, sdif);
                if (score > badness) {
-                       if (sk->sk_reuseport) {
+                       if (sk->sk_reuseport &&
+                           sk->sk_state !=3D TCP_ESTABLISHED &&
+                           !reuseport_result) {
                                hash =3D udp_ehashfn(net, daddr, hnum,
                                                   saddr, sport);
-                               result =3D reuseport_select_sock(sk, =
hash, skb,
+                               reuseport_result =3D
reuseport_select_sock(sk, hash, skb,
                                                        sizeof(struct =
udphdr));
-                               if (result)
-                                       return result;
+                               if (reuseport_result)
+                                       reuseport_score =3D score;
+                               continue;
                        }
                        badness =3D score;
                        result =3D sk;
                }
        }
+
+       if (badness < reuseport_score)
+               result =3D reuseport_result;
+
        return result;
"

To break out after the first reuseport hit when it is safe, i.e., when
it holds no connected sockets, requires adding this state to struct
reuseport_sock at __ip4_datagram_connect. And modify
reuseport_select_sock to read this. At least, I have not found a more
elegant solution.

> Steve, Re: your point on a scalable QUIC server. That is an
> interesting case certainly. Opening a connected socket per flow adds
> both memory and port table pressure. I once looked into an SO_TXONLY
> udp socket option that does not hash connected sockets into the port
> table. In effect receiving on a small set of listening sockets (e.g.,
> one per cpu) and sending over separate tx-only sockets. That still
> introduces unnecessary memory allocation. OTOH it amortizes some
> operations, such as route lookup.
>
> Anyway, that does not fix the immediate issue you reported when using
> SO_REUSEPORT as described.

As for the BPF program: good point on accessing the udp port when
skb->data is already beyond the header.

Programs of type sk_filter can use bpf_skb_load_bytes(_relative).
Which I think will work, but have not tested.

As of kernel 4.19 programs of type BPF_PROG_TYPE_SK_REUSEPORT can be
attached (with CAP_SYS_ADMIN). See
tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c for an
example that parses udp headers with bpf_skb_load_bytes.

