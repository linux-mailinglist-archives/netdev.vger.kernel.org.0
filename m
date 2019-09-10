Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC0A7AEF04
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 17:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388685AbfIJPxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 11:53:18 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:42837 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbfIJPxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 11:53:18 -0400
Received: by mail-yw1-f66.google.com with SMTP id i207so6605320ywc.9
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 08:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NR1Iuu7Nbcz5AvEY4ctkGdVP0+73jIAmIE2ZzKO57n0=;
        b=tC315OX9+mlQI/cUpT/+pjk5OI/VjaKYha/TOnEN2OoUApqydqvNR98ZaLXSg/8n3n
         r323/Y4tMfh/V4xckOOmmBrUtALmGd/K/YmFodBHfXejRExDyo002d4RjaeepdTVAkHM
         fKGbkeV2yj3TJYaDxNC4MfbqDVs/Y4NaVXGcCbzj8Q5jH0N/ba+kNkIR3IC/DX0qOvzB
         ixTJ4NCOuk9pqRyrb4BjpxbLrOyj67iaPqx/auzWx9FUBxDrHNdEHagfSaSZ5PBlVQwU
         CMa22KGtdD++l7nr3GoMTu9NnzxlGf9+aMt4f3+zwkVR0McQEJF9dGCjZlfv1P+wuwf5
         2xmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NR1Iuu7Nbcz5AvEY4ctkGdVP0+73jIAmIE2ZzKO57n0=;
        b=evZ8wX8Lj9SlcAvebMGKRHnaSJvEIviKzcCscCkU3y1ZRo11U/11nr/N5PSHfg/yP1
         Yb4yn+ZKRctV/gqFBrCzstwSDAJiJa3xq6smzW1eRnflxWIGoMOYittvdrg0EcJeN+oW
         zUEKKp4kgUSRIn9NzG44wN47IpPZGOhoOWrH8/7W39SzdGtpDri9ffs514NxF8FRN6HJ
         w5TDu/gETTkbr/5W26coqrYXpmptNQ0LVzsSI4K3gpxVDn4xtkbq74t6Te6FQDKbWM52
         2mIrG+pJ7Vx1eyVQPDBiuMqu+z/yKsNdvxkgjRtNpt6D14hLu+rJLT+pvMQuYuya0XrB
         Qpdw==
X-Gm-Message-State: APjAAAWq+WTOMlBiNA9L0aLSsVo8Yu2ia826MtwjFHLXMuOK6fF4nJHZ
        CImlpuFhA9m8S+V++RaTnOPIoWgl
X-Google-Smtp-Source: APXvYqxbQ16a7T3eE/zDdcQ0t4uXG1MJ0hykvVaeaJi1lByK9mD4feoClc1mxSMwq/wiyTyhjwg7og==
X-Received: by 2002:a81:3316:: with SMTP id z22mr21910863ywz.122.1568130796386;
        Tue, 10 Sep 2019 08:53:16 -0700 (PDT)
Received: from mail-yw1-f54.google.com (mail-yw1-f54.google.com. [209.85.161.54])
        by smtp.gmail.com with ESMTPSA id t186sm2045861ywd.54.2019.09.10.08.53.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2019 08:53:14 -0700 (PDT)
Received: by mail-yw1-f54.google.com with SMTP id x64so6608903ywg.3
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 08:53:13 -0700 (PDT)
X-Received: by 2002:a0d:e6d3:: with SMTP id p202mr20483286ywe.368.1568130792377;
 Tue, 10 Sep 2019 08:53:12 -0700 (PDT)
MIME-Version: 1.0
References: <010601d53bdc$79c86dc0$6d594940$@net> <20190716070246.0745ee6f@hermes.lan>
 <01db01d559e5$64d71de0$2e8559a0$@net> <CA+FuTSdu5inPWp_jkUcFnb-Fs-rdk0AMiieCYtjLE7Qs5oFWZQ@mail.gmail.com>
 <8f4bda24-5bd4-3f12-4c98-5e1097dde84a@gmail.com> <CA+FuTSf4iLXh-+ADfBNxqcsw=u_vGm7Wsx7vchgwgwvGFYOA6w@mail.gmail.com>
 <CA+FuTSdi=tw=N4X2f+paFNM7KHqBgNkV_se-ykZ0+WoA7q0AhQ@mail.gmail.com>
 <00aa01d5630b$7e062660$7a127320$@net> <4242994D-E2CF-499A-848A-7B14CE536E33@raytheon.com>
 <c3b83305-82a5-f3c8-2602-1aed2e9b51ca@gmail.com> <F119F197-FD88-4F9B-B064-F23B2E5025A3@comcast.net>
 <CA+FuTSf24VrjOxS9Kg3+DFEYn7ihe6vMj5o7rggOz_6KH_rNpQ@mail.gmail.com>
In-Reply-To: <CA+FuTSf24VrjOxS9Kg3+DFEYn7ihe6vMj5o7rggOz_6KH_rNpQ@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 10 Sep 2019 11:52:35 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfRP09aJNYRt04SS6qj22ViiOEWaWmLAwX0psk8-PGNxw@mail.gmail.com>
Message-ID: <CA+FuTSfRP09aJNYRt04SS6qj22ViiOEWaWmLAwX0psk8-PGNxw@mail.gmail.com>
Subject: Re: Is bug 200755 in anyone's queue??
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Steve Zabele <zabele@comcast.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mark KEATON <mark.keaton@raytheon.com>,
        Network Development <netdev@vger.kernel.org>,
        "shum@canndrew.org" <shum@canndrew.org>,
        "vladimir116@gmail.com" <vladimir116@gmail.com>,
        "saifi.khan@strikr.in" <saifi.khan@strikr.in>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "on2k16nm@gmail.com" <on2k16nm@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Craig Gallek <kraig@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 4, 2019 at 11:46 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Wed, Sep 4, 2019 at 10:51 AM Steve Zabele <zabele@comcast.net> wrote:
> >
> > I think a dual table approach makes a lot of sense here, especially if =
we look at the different use cases. For the DNS server example, almost cert=
ainly there will not be any connected sockets using the server port, so a t=
est of whether the connected table is empty (maybe a boolean stored with th=
e unconnected table?) should get to the existing code very quickly and not =
require accessing the memory holding the connected table. For our use case,=
 the connected sockets persist for long periods (at network timescales at l=
east) and so any rehashing should be infrequent and so have limited impact =
on performance overall.
> >
> > So does a dual table approach seem workable to other folks that know th=
e internals?
>
> Let me take a stab and compare. A dual table does bring it more in
> line with how the TCP code is structured.

On closer look, I think two tables is too much code churn and risk for
a stable fix. It requires lookup changes across ipv4 and ipv6 unicast,
multicast, early demux, .. Though I'm happy to be proven wrong, of
course.

One variant that is easy to see only modifies behavior for reuseport
groups with connections is to mark those as such:

"
@@ -21,7 +21,8 @@ struct sock_reuseport {
        unsigned int            synq_overflow_ts;
        /* ID stays the same even after the size of socks[] grows. */
        unsigned int            reuseport_id;
-       bool                    bind_inany;
+       unsigned int            bind_inany:1;
+       unsigned int            has_conns:1;
        struct bpf_prog __rcu   *prog;          /* optional BPF sock select=
or */
        struct sock             *socks[0];      /* array of sock pointers *=
/
 };
@@ -37,6 +38,23 @@ extern struct sock *reuseport_select_sock(struct sock *s=
k,
 extern int reuseport_attach_prog(struct sock *sk, struct bpf_prog *prog);
 extern int reuseport_detach_prog(struct sock *sk);

+static inline bool reuseport_has_conns(struct sock *sk, bool set)
+{
+       struct sock_reuseport *reuse;
+       bool ret =3D false;
+
+       rcu_read_lock();
+       reuse =3D rcu_dereference(sk->sk_reuseport_cb);
+       if (reuse) {
+               if (set)
+                       reuse->has_conns =3D 1;
+               ret =3D reuse->has_conns;
+       }
+       rcu_read_unlock();
+
+       return ret;
+}

@@ -67,6 +68,7 @@ int __ip4_datagram_connect(struct sock *sk, struct
sockaddr *uaddr, int addr_len
                if (sk->sk_prot->rehash)
                        sk->sk_prot->rehash(sk);
        }
+       reuseport_has_conns(sk, true);
        inet->inet_daddr =3D fl4->daddr;
        inet->inet_dport =3D usin->sin_port;
        sk->sk_state =3D TCP_ESTABLISHED;
"

Then at lookup treat connected reuseport sockets are regular sockets
and do not return early on a reuseport match if there may be higher
scoring connections:

"
@@ -423,13 +423,15 @@ static struct sock *udp4_lib_lookup2(struct net *net,
                score =3D compute_score(sk, net, saddr, sport,
                                      daddr, hnum, dif, sdif);
                if (score > badness) {
-                       if (sk->sk_reuseport) {
+                       if (sk->sk_reuseport &&
+                           sk->sk_state !=3D TCP_ESTABLISHED) {
                                hash =3D udp_ehashfn(net, daddr, hnum,
                                                   saddr, sport);
                                result =3D reuseport_select_sock(sk, hash, =
skb,
                                                        sizeof(struct udphd=
r));
-                               if (result)
+                               if (result && !reuseport_has_conns(sk, fals=
e))
                                        return result;
+                               sk =3D result ? : sk;
                        }
                        badness =3D score;
                        result =3D sk;
"

and finally for reuseport matches only return unconnected sockets in the gr=
oup:

"
@@ -295,8 +295,19 @@ struct sock *reuseport_select_sock(struct sock *sk,

 select_by_hash:
                /* no bpf or invalid bpf result: fall back to hash usage */
-               if (!sk2)
-                       sk2 =3D reuse->socks[reciprocal_scale(hash, socks)]=
;
+               if (!sk2) {
+                       int i, j;
+
+                       i =3D j =3D reciprocal_scale(hash, socks);
+                       while (reuse->socks[i]->sk_state =3D=3D TCP_ESTABLI=
SHED) {
+                               i++;
+                               if (i =3D=3D reuse->num_socks)
+                                       i =3D 0;
+                               if (i =3D=3D j)
+                                       goto out;
+                       }
+                       sk2 =3D reuse->socks[i];
+               }
        }
"

This is hardly a short patch, but the behavioral change is contained.

I also coded up the alternative to rely on order in the list: entries
are listed at the head and the list is traversed at the head. To keep
all connections within a group ahead of all the unconnected sockets in
a group (1) rehash on connect and (2) do a more complex
insert-after-connected-reuseport for new reuseport sockets:

"
@@ -67,12 +68,16 @@ int __ip4_datagram_connect(struct sock *sk, struct
sockaddr *uaddr, int addr_len
                if (sk->sk_prot->rehash)
                        sk->sk_prot->rehash(sk);
        }
+
        inet->inet_daddr =3D fl4->daddr;
        inet->inet_dport =3D usin->sin_port;
        sk->sk_state =3D TCP_ESTABLISHED;
        sk_set_txhash(sk);
        inet->inet_id =3D jiffies;

+       if (rcu_access_pointer(sk->sk_reuseport_cb) && sk->sk_prot->rehash)
+               sk->sk_prot->rehash(sk);
+
        sk_dst_set(sk, &rt->dst);
        err =3D 0;

@@ -323,7 +323,21 @@ int udp_lib_get_port(struct sock *sk, unsigned short s=
num,
                    sk->sk_family =3D=3D AF_INET6)
                        hlist_add_tail_rcu(&udp_sk(sk)->udp_portaddr_node,
                                           &hslot2->head);
-               else
+               else if (sk->sk_reuseport) {
+                       struct sock *cur, *last_conn =3D NULL;
+
+                       udp_portaddr_for_each_entry_rcu(cur, &hslot2->head)=
 {
+                               if (cur->sk_state =3D=3D TCP_ESTABLISHED &&
+                                   rcu_access_pointer(cur->sk_reuseport_cb=
))
+                                       last_conn =3D cur;
+                       }
+                       if (last_conn)
+
hlist_add_behind_rcu(&udp_sk(sk)->udp_portaddr_node,
+
&udp_sk(last_conn)->udp_portaddr_node);
+                       else
+
hlist_add_head_rcu(&udp_sk(sk)->udp_portaddr_node,
+                                                        &hslot2->head);
+               } else
                        hlist_add_head_rcu(&udp_sk(sk)->udp_portaddr_node,
                                           &hslot2->head);

@@ -423,7 +437,8 @@ static struct sock *udp4_lib_lookup2(struct net *net,
                score =3D compute_score(sk, net, saddr, sport,
                                      daddr, hnum, dif, sdif);
                if (score > badness) {
-                       if (sk->sk_reuseport) {
+                       if (sk->sk_reuseport &&
+                           sk->sk_state !=3D TCP_ESTABLISHED) {
                                hash =3D udp_ehashfn(net, daddr, hnum,
                                                   saddr, sport);
                                result =3D reuseport_select_sock(sk, hash, =
skb,
@@ -1891,10 +1906,12 @@ void udp_lib_rehash(struct sock *sk, u16 newhash)
                                             udp_sk(sk)->udp_port_hash);
                        /* we must lock primary chain too */
                        spin_lock_bh(&hslot->lock);
+#if 0
                        /* TODO: differentiate inet_rcv_saddr change
from regular connect */
                        if (rcu_access_pointer(sk->sk_reuseport_cb))
                                reuseport_detach_sock(sk);
+#endif

-                       if (hslot2 !=3D nhslot2) {
+                       if (1) {
                                spin_lock(&hslot2->lock);

hlist_del_init_rcu(&udp_sk(sk)->udp_portaddr_node);
                                hslot2->count--;
"

This clearly has some loose ends and is no shorter or simpler. So
unless anyone has comments or a different solution, I'll finish
up the first variant.
