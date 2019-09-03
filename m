Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24CA6A7206
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 19:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730118AbfICR4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 13:56:18 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:37938 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727667AbfICR4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 13:56:18 -0400
Received: by mail-yb1-f194.google.com with SMTP id o18so2368905ybp.5
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 10:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:cc;
        bh=pdvlvNkhT1o5h/IyKmBVFrqRc1MR0K5ypHWrbBbltnI=;
        b=dPAqZ6jMojD1YF+JL2EOr1KA8JtVEkHfVmR6CXB258zLUDMzl7Lt5+1Ht4JPSqMo/3
         dMCWTPZsyM0WYTztqkfCgRzs+347obAkwBkl29jSY5d+dmyMpRV3KQfE2yAZnk8qNVSp
         oZ7FdQ1XPVgpwXoTBeeHPeR3ObYAkJsCml5dm9KQ+RP3TCoFLuyNFXmmqY1Lpa8stAlt
         TzIN98NVQG4SMMRNEyQdDDmWQpc8Ld2tqw805rSRAAG3sx4KD3fZYWRLxE9W4xDwZwj5
         gcNVQwIdQsL+lBuj7Kc5BiCjQmmtUQrmYnex1hFqFuqN6sb8oy3K7KCP3Hd1cUra3Lxn
         SFvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:cc;
        bh=pdvlvNkhT1o5h/IyKmBVFrqRc1MR0K5ypHWrbBbltnI=;
        b=CX5XkmzLb1R2UTjerxqqXBSIWCM4H/3T+/K4/JGr//BJBZwkUlxy2xz7EKgOldmv+i
         q67iZeZ93f5dh15Ey3aIFu1YtMXMMuU7R5vgb8z9Y8y+Rm9mSWngRcq5vOWCrrUiOijX
         arIPTL91nH0sfZiX2GjWHyDQQ0UgtlNg8mMDmYtuxpuJ0dyW/y6mExKOyTnRtVAbmA31
         qWnsT3SDE+VSJthOmhQ1MztXmh7+iTMMYdxMatv8fJ/j7/tQJL2eqMqOzC9XSAbrx7ok
         W8Sf2jdrwmQHASqBRoS+vk41ogrPIKbitnIJepsl7W0D4RFC8d8LC0EGD6Ai1A16XG6W
         4I1g==
X-Gm-Message-State: APjAAAVIEVN11BTdZ3ycfPGJaC8Q3467YQ8/9gzb0JEKrQcye5wlpIhD
        7UKRW2rGoDz9JUwRtqpqK0jmCPrU
X-Google-Smtp-Source: APXvYqzhKj4oFDRT8b74Dzf5FG0XXVdOovdQPPfaXURfS/FHvTWiZW2GdeNjy75lV0I6DqyK6dtu0Q==
X-Received: by 2002:a25:240e:: with SMTP id k14mr25530406ybk.178.1567533376496;
        Tue, 03 Sep 2019 10:56:16 -0700 (PDT)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com. [209.85.219.170])
        by smtp.gmail.com with ESMTPSA id i62sm1247333ywi.102.2019.09.03.10.56.14
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2019 10:56:14 -0700 (PDT)
Received: by mail-yb1-f170.google.com with SMTP id y194so6150515ybe.13
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 10:56:14 -0700 (PDT)
X-Received: by 2002:a25:7396:: with SMTP id o144mt25975433ybc.390.1567533374037;
 Tue, 03 Sep 2019 10:56:14 -0700 (PDT)
MIME-Version: 1.0
References: <010601d53bdc$79c86dc0$6d594940$@net> <20190716070246.0745ee6f@hermes.lan>
 <01db01d559e5$64d71de0$2e8559a0$@net> <CA+FuTSdu5inPWp_jkUcFnb-Fs-rdk0AMiieCYtjLE7Qs5oFWZQ@mail.gmail.com>
 <8f4bda24-5bd4-3f12-4c98-5e1097dde84a@gmail.com> <CA+FuTSf4iLXh-+ADfBNxqcsw=u_vGm7Wsx7vchgwgwvGFYOA6w@mail.gmail.com>
In-Reply-To: <CA+FuTSf4iLXh-+ADfBNxqcsw=u_vGm7Wsx7vchgwgwvGFYOA6w@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 3 Sep 2019 13:55:37 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdi=tw=N4X2f+paFNM7KHqBgNkV_se-ykZ0+WoA7q0AhQ@mail.gmail.com>
Message-ID: <CA+FuTSdi=tw=N4X2f+paFNM7KHqBgNkV_se-ykZ0+WoA7q0AhQ@mail.gmail.com>
Subject: Re: Is bug 200755 in anyone's queue??
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Steve Zabele <zabele@comcast.net>,
        Network Development <netdev@vger.kernel.org>,
        shum@canndrew.org, vladimir116@gmail.com, saifi.khan@strikr.in,
        Daniel Borkmann <daniel@iogearbox.net>, on2k16nm@gmail.com,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 30, 2019 at 4:30 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Fri, Aug 30, 2019 at 4:54 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
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
> > > Also note that the default distribution algorithm is not round robin
> > > assignment, but hash based. So multiple consecutive datagrams arriving
> > > at the same socket is not unexpected.
> > >
> > > I suspect that this quick hack might "work". It seemed to on the
> > > supplied .c file:
> > >
> > >                   score = compute_score(sk, net, saddr, sport,
> > >                                         daddr, hnum, dif, sdif);
> > >                   if (score > badness) {
> > >   -                       if (sk->sk_reuseport) {
> > >   +                       if (sk->sk_reuseport && !sk->sk_state !=
> > > TCP_ESTABLISHED) {
>
> This won't work for a mix of connected and connectionless sockets, of
> course (even ignoring the typo), as it only skips reuseport on the
> connected sockets.
>
> > >
> > > But a more robust approach, that also works on existing kernels, is to
> > > swap the default distribution algorithm with a custom BPF based one (
> > > SO_ATTACH_REUSEPORT_EBPF).
> > >
> >
> > Yes, I suspect that reuseport could still be used by to load-balance incoming packets
> > targetting the same 4-tuple.
> >
> > So all sockets would have the same score, and we would select the first socket in
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
> reuseport_select_sock itself, as it has a reference to all sockets in the
> group in sock_reuseport->socks[]. Instead of the straightforward hash.

That won't work, as reuseport_select_sock does not have access to
protocol specific data, notably inet_dport.

Unfortunately, what I've come up with so far is not concise and slows
down existing reuseport lookup in a busy port table slot. Note that it
is needed for both ipv4 and ipv6.

Do not break out of the port table slot early, but continue to search
for a higher scored match even after matching a reuseport:

"
   @@ -413,28 +413,39 @@ static struct sock *udp4_lib_lookup2(struct net *net,
                                     struct udp_hslot *hslot2,
                                     struct sk_buff *skb)
 {
+       struct sock *reuseport_result = NULL;
        struct sock *sk, *result;
+       int reuseport_score = 0;
        int score, badness;
        u32 hash = 0;

        result = NULL;
        badness = 0;
        udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
                score = compute_score(sk, net, saddr, sport,
                                      daddr, hnum, dif, sdif);
                if (score > badness) {
-                       if (sk->sk_reuseport) {
+                       if (sk->sk_reuseport &&
+                           sk->sk_state != TCP_ESTABLISHED &&
+                           !reuseport_result) {
                                hash = udp_ehashfn(net, daddr, hnum,
                                                   saddr, sport);
-                               result = reuseport_select_sock(sk, hash, skb,
+                               reuseport_result =
reuseport_select_sock(sk, hash, skb,
                                                        sizeof(struct udphdr));
-                               if (result)
-                                       return result;
+                               if (reuseport_result)
+                                       reuseport_score = score;
+                               continue;
                        }
                        badness = score;
                        result = sk;
                }
        }
+
+       if (badness < reuseport_score)
+               result = reuseport_result;
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
