Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2821B225AE
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 03:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729493AbfESBxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 21:53:02 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45122 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727331AbfESBxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 21:53:02 -0400
Received: by mail-lf1-f68.google.com with SMTP id n22so7796431lfe.12
        for <netdev@vger.kernel.org>; Sat, 18 May 2019 18:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8ZVu/rDaXk4xxhCgGNgQKL8+MF9tQJRxjPPLagihVpE=;
        b=NPbaNApd7jHuJEJNLu6WS9NXXqx+Urkklz31NhyH3NG8UCRWevdRYLUC1l8Goa1K+x
         haXbVsyVbPZukWXGsyYzi3g7VY1j/xd7o0qrSTRRf213U8MXGqtgqvGTgtEeBzv+9ROy
         av9hjGdMD5S7YHeIjPVcmHOzmVAWTGPrYJNYBoEmeLZ7ffnzJ3Ij9A/rZA8V5Fgzl5wB
         NAvG+J9RHkuC/UjzidY0B8P0JMjcIyur280l+C0tXPTtgLgeWTs3MaztLNBcoOylIrLo
         Tq3vXKA6BELG2lR8p2dV+uAqIa8LpW0GN7xpYwjCIU+qX6HOWXuHQg2DopDsebR9+AHU
         alXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8ZVu/rDaXk4xxhCgGNgQKL8+MF9tQJRxjPPLagihVpE=;
        b=ikl7YsWD47aPhtyIE2REpu+68L0eplSn+VLeYloqYlaOrsg5tvMJ4sMbfg8+a6O3I3
         T9G/EQLQSIA+f9OvIC68W1+JdPZssjRPJMX5h6evalOkf64FRpzpgFCExx3e6Gr2G5LN
         MteqYl/k9AtZ8yvixAn6b8OXHH6N8mdwRBxcYb3jLqtiA9UQvfan28J5LQCIchn1r9R5
         RCmEz9BNGVHDpF+92FVpPzoz8xVoC/jJc07FYygfBuVH3H+N/6eqyOAZTV2C39dEfb9D
         Z26KEnXl7oP50auqeExGnJerVzxZyAp7WuLsP/HXM8zm7XdyJNHtAZ7a5CWhMbwzTVdp
         2mqg==
X-Gm-Message-State: APjAAAUGB+/YrgVgu3UbtO2J2cvOnn0gReB51x/XvhUllCKwi9rQ5w5u
        BiMdQguVLPf6HksJHazwzQYtpqk/yolpBXdGq3ZwAg==
X-Google-Smtp-Source: APXvYqxBLnfaECJVcHDfVcRR4rNEGIZ+KxGrIOIYKVdl+pAxoPdvcdHhRd5ePG8gqf1jrsYMqM5XPCFfQcxf5YLvY6A=
X-Received: by 2002:a19:6a0c:: with SMTP id u12mr6963468lfu.109.1558230779757;
 Sat, 18 May 2019 18:52:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190517212117.2792415-1-kafai@fb.com> <6dc01cb7-cdd4-8a71-b602-0052b7aadfb7@gmail.com>
 <20190517220145.pkpkt7f5b72vvfyk@kafai-mbp> <CADa=RyxisbcVeXL7yq6o02XOgWd87QCzq-6zDXRnm9RoD2WM=A@mail.gmail.com>
 <20190518190520.53mrvat4c4y6cnbf@kafai-mbp>
In-Reply-To: <20190518190520.53mrvat4c4y6cnbf@kafai-mbp>
From:   Joe Stringer <joe@isovalent.com>
Date:   Sat, 18 May 2019 18:52:48 -0700
Message-ID: <CADa=RyxfhK+XhAwf_C_an=+RnsQCPCXV23Qrwk-3OC1oLdHM=A@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: Check sk_fullsock() before returning from bpf_sk_lookup()
To:     Martin Lau <kafai@fb.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, bpf@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 18, 2019, 09:05 Martin Lau <kafai@fb.com> wrote:
>
> On Sat, May 18, 2019 at 08:38:46AM -1000, Joe Stringer wrote:
> > On Fri, May 17, 2019, 12:02 Martin Lau <kafai@fb.com> wrote:
> >
> > > On Fri, May 17, 2019 at 02:51:48PM -0700, Eric Dumazet wrote:
> > > >
> > > >
> > > > On 5/17/19 2:21 PM, Martin KaFai Lau wrote:
> > > > > The BPF_FUNC_sk_lookup_xxx helpers return RET_PTR_TO_SOCKET_OR_NULL.
> > > > > Meaning a fullsock ptr and its fullsock's fields in bpf_sock can be
> > > > > accessed, e.g. type, protocol, mark and priority.
> > > > > Some new helper, like bpf_sk_storage_get(), also expects
> > > > > ARG_PTR_TO_SOCKET is a fullsock.
> > > > >
> > > > > bpf_sk_lookup() currently calls sk_to_full_sk() before returning.
> > > > > However, the ptr returned from sk_to_full_sk() is not guaranteed
> > > > > to be a fullsock.  For example, it cannot get a fullsock if sk
> > > > > is in TCP_TIME_WAIT.
> > > > >
> > > > > This patch checks for sk_fullsock() before returning. If it is not
> > > > > a fullsock, sock_gen_put() is called if needed and then returns NULL.
> > > > >
> > > > > Fixes: 6acc9b432e67 ("bpf: Add helper to retrieve socket in BPF")
> > > > > Cc: Joe Stringer <joe@isovalent.com>
> > > > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > > > ---
> > > > >  net/core/filter.c | 16 ++++++++++++++--
> > > > >  1 file changed, 14 insertions(+), 2 deletions(-)
> > > > >
> > > > > diff --git a/net/core/filter.c b/net/core/filter.c
> > > > > index 55bfc941d17a..85def5a20aaf 100644
> > > > > --- a/net/core/filter.c
> > > > > +++ b/net/core/filter.c
> > > > > @@ -5337,8 +5337,14 @@ __bpf_sk_lookup(struct sk_buff *skb, struct
> > > bpf_sock_tuple *tuple, u32 len,
> > > > >     struct sock *sk = __bpf_skc_lookup(skb, tuple, len, caller_net,
> > > > >                                        ifindex, proto, netns_id,
> > > flags);
> > > > >
> > > > > -   if (sk)
> > > > > +   if (sk) {
> > > > >             sk = sk_to_full_sk(sk);
> > > > > +           if (!sk_fullsock(sk)) {
> > > > > +                   if (!sock_flag(sk, SOCK_RCU_FREE))
> > > > > +                           sock_gen_put(sk);
> > > >
> > > > This looks a bit convoluted/weird.
> > > >
> > > > What about telling/asking __bpf_skc_lookup() to not return a non
> > > fullsock instead ?
> > > It is becausee some other helpers, like BPF_FUNC_skc_lookup_tcp,
> > > can return non fullsock
> > >
> >
> > FYI this is necessary for finding a transparently proxied socket for a
> > non-local connection (tproxy use case).
> You meant it is necessary to return a non fullsock from the
> BPF_FUNC_sk_lookup_xxx helpers?

Yes, that's what I want to associate with the skb so that the delivery
to the SO_TRANSPARENT is received properly.

For the first packet of a connection, we look up the socket using the
tproxy socket port as the destination, and deliver the packet there.
The SO_TRANSPARENT logic then kicks in and sends back the ack and
creates the non-full sock for the connection tuple, which can be
entirely unrelated to local addresses or ports.

For the second forward-direction packet, (ie ACK in 3-way handshake)
then we must deliver the packet to this non-full sock as that's what
is negotiating the proxied connection. If you look up using the packet
tuple then get the full sock from it, it will go back to the
SO_TRANSPARENT parent socket. Delivering the ACK there will result in
a RST being sent back, because the SO_TRANSPARENT socket is just there
to accept new connections for connections to be proxied. So this is
the case where I need the non-full sock.

(In practice, the lookup logic attempts the packet tuple first then if
that fails, uses the tproxy port for lookup to achieve the above).
