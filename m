Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE835777F8
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 21:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbiGQT11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 15:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiGQT10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 15:27:26 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A6612AE3;
        Sun, 17 Jul 2022 12:27:23 -0700 (PDT)
Received: from darkstar.fritz.box (dynamic-2a01-0c23-8846-3700-fc24-d4f4-08ae-ec54.c23.pool.telefonica.de [IPv6:2a01:c23:8846:3700:fc24:d4f4:8ae:ec54])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: jluebbe@lasnet.de)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 5CABDC01B4;
        Sun, 17 Jul 2022 21:27:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lasnet.de; s=2021;
        t=1658086037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4DwaCkL4z8/Hc9IhAyBUlQAU/pjJQ1K2r2/Joj+19UE=;
        b=WuQE6XZPaReMGuntl8R918TKdFdSYBMxmNpvOz9ErNWH3FM+5mxQHhpm8vKP42GUQw/4re
        rnH3qxlwbWFyVZtEXd1/b+82/m2YDTl6yAFOFL09oep+qhdQEXfuChDknoR8fYHaQpcbXR
        dw0jItASYfv6oGgUCaJCATfbIIjGTQCX+m4nnlZp3fRBtKAtrQrZz4c2FzWXSsqbwrskxz
        mxDD7FyM7oDJ+VZt6MWNuxSmfL7PP5cW9bwGbL1o97+s2eQxITarYerlM3EPdyH11l4CW4
        SfSFavrM7jtNzLO2GOm5hoosYq4NyriBvSwz4XXoTo9FTCQw9a4mNVTFMOVX5Q==
Message-ID: <c7968dd38360ac4c7d7ed2a45ec1af3176a2ce6a.camel@lasnet.de>
Subject: Re: [REGRESSION] connection timeout with routes to VRF
From:   Jan =?ISO-8859-1?Q?L=FCbbe?= <jluebbe@lasnet.de>
To:     Mike Manning <mvrmanning@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Robert Shearman <robertshearman@gmail.com>,
        Andy Roulin <aroulin@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        regressions@lists.linux.dev,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sun, 17 Jul 2022 21:27:16 +0200
In-Reply-To: <c110dcb5-cfd3-5abd-1533-4f9dc1d45531@gmail.com>
References: <a54c149aed38fded2d3b5fdb1a6c89e36a083b74.camel@lasnet.de>
         <6410890e-333d-5f0e-52f2-1041667c80f8@kernel.org>
         <940fa370-08ce-1d39-d5cc-51de8e853b47@gmail.com>
         <a32428fa0f3811c25912cd313a6fe1fb4f0a4fac.camel@lasnet.de>
         <c110dcb5-cfd3-5abd-1533-4f9dc1d45531@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.3 (by Flathub.org) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2022-07-17 at 11:31 +0100, Mike Manning wrote:
> On 06/07/2022 19:49, Jan Luebbe wrote:
> > On Sun, 2022-06-26 at 21:06 +0100, Mike Manning wrote:
> > ...
> > > Andy Roulin suggested the same fix to the same problem a few weeks ba=
ck.
> > > Let's do it along with a test case in fcnl-test.sh which covers all o=
f
> > > these vrf permutations.
> > >=20
> > Reverting 3c82a21f4320 would remove isolation between the default and o=
ther VRFs
> > needed when no VRF route leaking has been configured between these: the=
re may be
> > unintended leaking of packets arriving on a device enslaved to an l3mde=
v due to
> > the potential match on an unbound socket.
> >=20
> > Thanks for the explanation.
> >=20
> > VRF route leaking requires routes to be present for both ingress and eg=
ress
> > VRFs,
> > the testcase shown only has a route from default to red VRF. The implic=
it return
> > path from red to default VRF due to match on unbound socket is no longe=
r
> > present.
> >=20
> >=20
> > If there is a better configuration that makes this work in the general =
case
> > without a change to the kernel, we'd be happy as well.
> >=20
> > In our full setup, the outbound TCP connection (from the default VRF) g=
ets a
> > local IP from the interface enslaved to the VRF. Before 3c82a21f4320, t=
his would
> > simply work.
> >=20
> > How would the return path route from the red VRF to the default VRF loo=
k in that
> > case?
>=20
> I am unaware of your topology, can you add a route in the red VRF table
> (see 'ip route ls vrf red'), so 'ip route add vrf red <prefix> via
> <next-hop>'.

With 4.19 (and my workaround), the outbound packets were simply assigned an=
 IP
from the red VRF if the have to leave the local machine. The IPs in the def=
ault
VRF are public IPs, which would not be routed back to the same machine.=20


I'm not sure if it helps, but I'll try to explain our topology:
https://gist.github.com/jluebbe/001c7b9ba531ad04d7e5c0a58f400967

Were using VRF for the https://freifunk-bs.de/ network. In the diagram abov=
e, a
'freifunk' VRF is used to create an overlay network, consisting of Wireguar=
d
tunnels with OSPF and BGP between the concentrators and exists.=C2=A0

Each of the these servers has the main VRF with the physical network interf=
ace
and externally routeable IPs, which is used to transport the Wireguard pack=
ets
and management access.

The 'freifunk' VRF encapsulates the overlay traffic, so that it is only rou=
ted
to other interfaces assigned to the VRF. Previously, we used policy routing=
 for
this, but VRF has made the setup much easier to understand and debug. :)

> The isolation between default and other VRFs necessary for forwarding
> purposes means that running a local process in the default VRF to access
> another VRF no longer works since the change made in 2018 that you
> identified. So in your example, 'ip vrf exec red nc ...' will work, but
> I assume that this is of no use to you.

I don't actually use forwarding across VRFs via route leaking, but only for
locally originating connections. A simple example is that a 'ssh <IP access=
ible
via VRF>' just worked for non-root users, which also makes ssh's ProxyJump =
work
to hosts accessible via the VRF. Both 'ip vrf exec' and binding to the VRF
interface would require root.

For real services (such as bind), we already used 'ip vrf exec ...' and tha=
t was
(and is) working fine.

> > Match on unbound socket in all VRFs and not only in the default VRF sho=
uld be
> > possible by setting this option (see
> > https://www.kernel.org/doc/Documentation/networking/vrf.txt):
> >=20
> >=20
> > Do you mean unbound as in listening socket not bound to an IP with bind=
()? Or as
> > in a socket in the default VRF?
>=20
> Unbound meaning a socket in the default VRF, as opposed to a a socket
> set into a VRF context by binding it to a VRF master interface using
> SO_BINDTODEVICE. One must also be able to bind to an appropriate IP
> address with bind() regardless of whether the socket is in the default
> or another VRF, but that is not relevant here.

OK.

> > sysctl net.ipv4.tcp_l3mdev_accept=3D1
> >=20
> >=20
> > The sysctl docs sound like this should only apply to listening sockets.=
 In this
> > case, we have an unconnected outbound socket.
>=20
> With this option disabled (by default), any stream socket in a VRF is
> only selected for packets in that VRF, this is done in the input path
> see e.g. tcp_v4_rcv() for IPv4.
>=20

Yes, we've been using this option for a long time to make sshd accessible f=
rom
both the default VRF and the red VRF.

> > However, for this to work a change similar to the following is needed (=
I have
> > shown the change to the macro for consistency with above, it is now an =
inline
> > fn):
> >=20
> >=20
> > I can also test on master and only used the macro form only because I w=
asn't
> > completely sure how to translate it to the inline function form.
> >=20
> > ---
> > =C2=A0include/net/inet_hashtables.h |=C2=A0=C2=A0 10 ++++------
> > =C2=A01 file changed, 4 insertions(+), 6 deletions(-)
> >=20
> > --- a/include/net/inet_hashtables.h
> > +++ b/include/net/inet_hashtables.h
> > @@ -300,9 +300,8 @@
> > =C2=A0#define INET_MATCH(__sk, __net, __cookie, __saddr, __daddr, __por=
ts, __dif,
> > __sdif) \
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (((__sk)->sk_portpair =3D=3D=
 (__ports))=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &&=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 \
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ((__sk)->sk_addrpair =
=3D=3D (__cookie))=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &&=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 \
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (((__sk)->sk_bound_dev_if =
=3D=3D (__dif))=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ||=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 \
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ((__sk)->sk_bound_dev=
_if =3D=3D (__sdif)))=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &&=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 net_eq(sock_net(__sk), (__n=
et)))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 net_eq(sock_net(__sk), (__n=
et))=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &&=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 inet_sk_bound_dev_eq((__net=
), (__sk)->sk_bound_dev_if, (__dif),
> > (__sdif)))
> > =C2=A0#else /* 32-bit arch */
> > =C2=A0#define INET_ADDR_COOKIE(__name, __saddr, __daddr) \
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 const int __name __deprecate=
d __attribute__((unused))
> > @@ -311,9 +310,8 @@
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (((__sk)->sk_portpair =3D=3D=
 (__ports))=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 &&=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 \
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ((__sk)->sk_daddr=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 =3D=3D (__saddr))=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &&=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ((__sk)->sk_rcv_saddr=
=C2=A0 =3D=3D (__daddr))=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 &&=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 \
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (((__sk)->sk_bound_dev_if =
=3D=3D (__dif))=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ||=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 \
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ((__sk)->sk_bound_dev=
_if =3D=3D (__sdif)))=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 &&=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
> > -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 net_eq(sock_net(__sk), (__n=
et)))
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 net_eq(sock_net(__sk), (__n=
et))=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 &&=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
> > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 inet_sk_bound_dev_eq((__net=
), (__sk)->sk_bound_dev_if, (__dif),
> > (__sdif)))
> > =C2=A0#endif /* 64-bit arch */
> >=20
> > =C2=A0/* Sockets in TCP_CLOSE state are _always_ taken out of the hash,=
 so we need
> >=20
> > I can confirm that this gets my testcase working with=20
> > net.ipv4.tcp_l3mdev_accept=3D1.
>=20
> I can submit this change to kernel-net (modified for latest code) if
> David is ok with this approach. It should not have a significant
> performance impact (due to the additional kernel parameter check) for
> most use-cases, as typically sdif =3D 0 for the unbound case. I am not in
> a position to carry out any performance testing.

I've tried your patch on our production network and notices an additional
complication I've missed so far: It only fixes v4.

As there is no tcp_l3mdev_accept for v6 as far as I can tell, I've updated =
my
workaround (see below) and we've been using it since last week without obvi=
ous
issues.

> > This is to get the testcase to pass, I will leave it to others to comme=
nt on
> > the testcase validity in terms of testing forwarding using commands on =
1 device.
> >=20
> > So a network-namespace-based testcase would be preferred? We used the s=
imple
> > setup because it seemed easier to understand.
> >=20
> > The series that 3c82a21f4320 is part of were introduced into the kernel=
 in 2018
> > by the Vyatta team, who regularly run an extensive test suite for routi=
ng
> > protocols for VRF functionality incl. all combinations of route leaking=
 between default
> > and other VRFs, so there is no known issue in this regard. I will attem=
pt to reach
> > out to them so as to advise them of this thread.
> >=20
> > Are these testcases public? Perhaps I could use them find a better conf=
iguration
> > that handles our use-case.
>=20
> The test automation to bring up network topologies is not public, but
> the test cases would not be readily transferable for general use in any
> case. I have advised the Vyatta team of this thread.

Ah, thanks!

My current workaround on top of 5.18.11 (derived from a 3c82a21f4320 revert=
):

diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtables.=
h
index 81b965953036..1944f8730b42 100644
--- a/include/net/inet6_hashtables.h
+++ b/include/net/inet6_hashtables.h
@@ -110,8 +110,9 @@ int inet6_hash(struct sock *sk);
 	 ((__sk)->sk_family =3D=3D AF_INET6)			&&	\
 	 ipv6_addr_equal(&(__sk)->sk_v6_daddr, (__saddr))		&&	\
 	 ipv6_addr_equal(&(__sk)->sk_v6_rcv_saddr, (__daddr))	&&	\
-	 (((__sk)->sk_bound_dev_if =3D=3D (__dif))	||			\
-	  ((__sk)->sk_bound_dev_if =3D=3D (__sdif)))		&&	\
+	 (!(__sk)->sk_bound_dev_if	||				\
+	   ((__sk)->sk_bound_dev_if =3D=3D (__dif))	||			\
+	   ((__sk)->sk_bound_dev_if =3D=3D (__sdif)))		&&	\
 	 net_eq(sock_net(__sk), (__net)))
=20
 #endif /* _INET6_HASHTABLES_H */
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 98e1ec1a14f0..41e7f20d7e51 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -310,8 +310,9 @@ static inline struct sock *inet_lookup_listener(struct =
net *net,
 #define INET_MATCH(__sk, __net, __cookie, __saddr, __daddr, __ports, __dif=
, __sdif) \
 	(((__sk)->sk_portpair =3D=3D (__ports))			&&	\
 	 ((__sk)->sk_addrpair =3D=3D (__cookie))			&&	\
-	 (((__sk)->sk_bound_dev_if =3D=3D (__dif))			||	\
-	  ((__sk)->sk_bound_dev_if =3D=3D (__sdif)))		&&	\
+	 (!(__sk)->sk_bound_dev_if	||				\
+	   ((__sk)->sk_bound_dev_if =3D=3D (__dif))			||	\
+	   ((__sk)->sk_bound_dev_if =3D=3D (__sdif)))		&&	\
 	 net_eq(sock_net(__sk), (__net)))
 #else /* 32-bit arch */
 #define INET_ADDR_COOKIE(__name, __saddr, __daddr) \
@@ -321,8 +322,9 @@ static inline struct sock *inet_lookup_listener(struct =
net *net,
 	(((__sk)->sk_portpair =3D=3D (__ports))		&&		\
 	 ((__sk)->sk_daddr	=3D=3D (__saddr))		&&		\
 	 ((__sk)->sk_rcv_saddr	=3D=3D (__daddr))		&&		\
-	 (((__sk)->sk_bound_dev_if =3D=3D (__dif))		||		\
-	  ((__sk)->sk_bound_dev_if =3D=3D (__sdif)))	&&		\
+	 (!(__sk)->sk_bound_dev_if	||				\
+	   ((__sk)->sk_bound_dev_if =3D=3D (__dif))		||		\
+	   ((__sk)->sk_bound_dev_if =3D=3D (__sdif)))	&&		\
 	 net_eq(sock_net(__sk), (__net)))
 #endif /* 64-bit arch */
=20

Thanks again,
Jan


