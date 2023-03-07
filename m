Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57E526AF664
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 21:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbjCGUGn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 15:06:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbjCGUGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 15:06:38 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66069BA71;
        Tue,  7 Mar 2023 12:06:29 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id k23so12587261ybk.13;
        Tue, 07 Mar 2023 12:06:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678219588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1tK3adzZPIgIOu1xXFVuowxCf96H93Fxanpmf/N0OlY=;
        b=ex0aiHq/zvxSpt5C0MCcMi6OneD7hubjR+OqbWhJj+qFhGmnwPBUKt3uY2gdxfJvlq
         k82bYUoFvJLAGcCsE+fLVlANwYUlIJNF/oCEw8o0E8W93ex/NBMJAhEMekhcUkS2l+rr
         oIjqfSvdjbKGLgPJgwsSrRqk8cCfMtbfKKhx+SCIoKa3S4gh+F72UlI9vgXFkYN9TLXF
         8W+CZEoetXxgK8HL/EsK14No/IxHEiU2Ij2FnGAeakkKi6fSbIOBAI3mYXsfyGhXjJCQ
         j6rLU32f57cmDIf/3s9iYQLHJUo11nnxq+gfw6CT1qQSo4NZqe4iwvu9F4m49YnPe79G
         oP4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678219588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1tK3adzZPIgIOu1xXFVuowxCf96H93Fxanpmf/N0OlY=;
        b=NpnZU6Y3p2io3IaxuFriO4S8YJjGLxOeei6Oh51ZjnQL9E30iZEkP/Bh9EFgNFBP/d
         ko+3trq4usuyF2I9onWdtHL1lVLfWS0aG3Z9L3ZzH4Ae3xoBzP1uWSPauX9lCKm4ffOh
         eKqtk/t7pJUMpIxOV6+Mp4Xwo/wCOy4j8Z7ES9bMoR8BQlHTxGZKdV8RM8q74kAbSgCb
         j6/tMGeC1qCWOQ+AolEnexCj+c190wrmYeZGDfnUq4I22mwVtGRuBvJiFLtcPsaAfj26
         bawsmtWtii9h6ZfrZghkL4PkS1da+BGdZq8eZXSfyI+wL0WDHse2blMbnRhdMVHLPBNX
         iHnw==
X-Gm-Message-State: AO0yUKVISX7T5DPyCrv7jtAvt5gjVjGy/RHPex5p97/4Hids0KuOEH9V
        qxtZ02UUktixJvseBJlzyvHiR6c6nz0pqVGjwBY=
X-Google-Smtp-Source: AK7set8iPklzjJzh+n/dJGGDYzQeGR022koKzplhYc1QNvJjjjnq8Z8zTqTTtIoxVRZ1fY0BeKU80X24Ba4FNtWhIes=
X-Received: by 2002:a5b:b84:0:b0:ab8:1ed9:cfd2 with SMTP id
 l4-20020a5b0b84000000b00ab81ed9cfd2mr9432063ybq.5.1678219588594; Tue, 07 Mar
 2023 12:06:28 -0800 (PST)
MIME-Version: 1.0
References: <cover.1677888566.git.lucien.xin@gmail.com> <05ccf9eec0b79e62d52ae65a096126546d84bea6.1677888566.git.lucien.xin@gmail.com>
 <f7tbkl45s7l.fsf@redhat.com>
In-Reply-To: <f7tbkl45s7l.fsf@redhat.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 7 Mar 2023 15:06:01 -0500
Message-ID: <CADvbK_crwJn2Sy1Xz+iiJ=yYPhDMkZh5zJkjrfCgkmzaeX-7=Q@mail.gmail.com>
Subject: Re: [PATCH nf-next 6/6] selftests: add a selftest for big tcp
To:     Aaron Conole <aconole@redhat.com>
Cc:     netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Pravin B Shelar <pshelar@ovn.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 7, 2023 at 1:31=E2=80=AFPM Aaron Conole <aconole@redhat.com> wr=
ote:
>
> Xin Long <lucien.xin@gmail.com> writes:
>
> > This test runs on the client-router-server topo, and monitors the traff=
ic
> > on the RX devices of router and server while sending BIG TCP packets wi=
th
> > netperf from client to server. Meanwhile, it changes 'tso' on the TX de=
vs
> > and 'gro' on the RX devs. Then it checks if any BIG TCP packets appears
> > on the RX devs with 'ip/ip6tables -m length ! --length 0:65535' for eac=
h
> > case.
> >
> > Note that we also add tc action ct in link1 ingress to cover the ipv6
> > jumbo packets process in nf_ct_skb_network_trim() of nf_conntrack_ovs.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
>
> LGTM - just one question
>
> Reviewed-by: Aaron Conole <aconole@redhat.com>
>
> >  tools/testing/selftests/net/Makefile   |   1 +
> >  tools/testing/selftests/net/big_tcp.sh | 180 +++++++++++++++++++++++++
> >  2 files changed, 181 insertions(+)
> >  create mode 100755 tools/testing/selftests/net/big_tcp.sh
> >
> > diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selft=
ests/net/Makefile
> > index 6cd8993454d7..099741290184 100644
> > --- a/tools/testing/selftests/net/Makefile
> > +++ b/tools/testing/selftests/net/Makefile
> > @@ -48,6 +48,7 @@ TEST_PROGS +=3D l2_tos_ttl_inherit.sh
> >  TEST_PROGS +=3D bind_bhash.sh
> >  TEST_PROGS +=3D ip_local_port_range.sh
> >  TEST_PROGS +=3D rps_default_mask.sh
> > +TEST_PROGS +=3D big_tcp.sh
> >  TEST_PROGS_EXTENDED :=3D in_netns.sh setup_loopback.sh setup_veth.sh
> >  TEST_PROGS_EXTENDED +=3D toeplitz_client.sh toeplitz.sh
> >  TEST_GEN_FILES =3D  socket nettest
> > diff --git a/tools/testing/selftests/net/big_tcp.sh b/tools/testing/sel=
ftests/net/big_tcp.sh
> > new file mode 100755
> > index 000000000000..cde9a91c4797
> > --- /dev/null
> > +++ b/tools/testing/selftests/net/big_tcp.sh
> > @@ -0,0 +1,180 @@
> > +#!/bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +#
> > +# Testing For IPv4 and IPv6 BIG TCP.
> > +# TOPO: CLIENT_NS (link0)<--->(link1) ROUTER_NS (link2)<--->(link3) SE=
RVER_NS
> > +
> > +CLIENT_NS=3D$(mktemp -u client-XXXXXXXX)
> > +CLIENT_IP4=3D"198.51.100.1"
> > +CLIENT_IP6=3D"2001:db8:1::1"
> > +
> > +SERVER_NS=3D$(mktemp -u server-XXXXXXXX)
> > +SERVER_IP4=3D"203.0.113.1"
> > +SERVER_IP6=3D"2001:db8:2::1"
> > +
> > +ROUTER_NS=3D$(mktemp -u router-XXXXXXXX)
> > +SERVER_GW4=3D"203.0.113.2"
> > +CLIENT_GW4=3D"198.51.100.2"
> > +SERVER_GW6=3D"2001:db8:2::2"
> > +CLIENT_GW6=3D"2001:db8:1::2"
> > +
> > +MAX_SIZE=3D128000
> > +CHK_SIZE=3D65535
> > +
> > +# Kselftest framework requirement - SKIP code is 4.
> > +ksft_skip=3D4
> > +
> > +setup() {
> > +     ip netns add $CLIENT_NS
> > +     ip netns add $SERVER_NS
> > +     ip netns add $ROUTER_NS
> > +     ip -net $ROUTER_NS link add link1 type veth peer name link0 netns=
 $CLIENT_NS
> > +     ip -net $ROUTER_NS link add link2 type veth peer name link3 netns=
 $SERVER_NS
> > +
> > +     ip -net $CLIENT_NS link set link0 up
> > +     ip -net $CLIENT_NS link set link0 mtu 1442
> > +     ip -net $CLIENT_NS addr add $CLIENT_IP4/24 dev link0
> > +     ip -net $CLIENT_NS addr add $CLIENT_IP6/64 dev link0 nodad
> > +     ip -net $CLIENT_NS route add $SERVER_IP4 dev link0 via $CLIENT_GW=
4
> > +     ip -net $CLIENT_NS route add $SERVER_IP6 dev link0 via $CLIENT_GW=
6
> > +     ip -net $CLIENT_NS link set dev link0 \
> > +             gro_ipv4_max_size $MAX_SIZE gso_ipv4_max_size $MAX_SIZE
> > +     ip -net $CLIENT_NS link set dev link0 \
> > +             gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE
> > +     ip net exec $CLIENT_NS sysctl -wq net.ipv4.tcp_window_scaling=3D1=
0
> > +
> > +     ip -net $ROUTER_NS link set link1 up
> > +     ip -net $ROUTER_NS link set link2 up
> > +     ip -net $ROUTER_NS addr add $CLIENT_GW4/24 dev link1
> > +     ip -net $ROUTER_NS addr add $CLIENT_GW6/64 dev link1 nodad
> > +     ip -net $ROUTER_NS addr add $SERVER_GW4/24 dev link2
> > +     ip -net $ROUTER_NS addr add $SERVER_GW6/64 dev link2 nodad
> > +     ip -net $ROUTER_NS link set dev link1 \
> > +             gro_ipv4_max_size $MAX_SIZE gso_ipv4_max_size $MAX_SIZE
> > +     ip -net $ROUTER_NS link set dev link2 \
> > +             gro_ipv4_max_size $MAX_SIZE gso_ipv4_max_size $MAX_SIZE
> > +     ip -net $ROUTER_NS link set dev link1 \
> > +             gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE
> > +     ip -net $ROUTER_NS link set dev link2 \
> > +             gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE
> > +     # test for nf_ct_skb_network_trim in nf_conntrack_ovs used by TC =
ct action.
> > +     ip net exec $ROUTER_NS tc qdisc add dev link1 ingress
> > +     ip net exec $ROUTER_NS tc filter add dev link1 ingress \
> > +             proto ip flower ip_proto tcp action ct
> > +     ip net exec $ROUTER_NS tc filter add dev link1 ingress \
> > +             proto ipv6 flower ip_proto tcp action ct
> > +     ip net exec $ROUTER_NS sysctl -wq net.ipv4.ip_forward=3D1
> > +     ip net exec $ROUTER_NS sysctl -wq net.ipv6.conf.all.forwarding=3D=
1
> > +
> > +     ip -net $SERVER_NS link set link3 up
> > +     ip -net $SERVER_NS addr add $SERVER_IP4/24 dev link3
> > +     ip -net $SERVER_NS addr add $SERVER_IP6/64 dev link3 nodad
> > +     ip -net $SERVER_NS route add $CLIENT_IP4 dev link3 via $SERVER_GW=
4
> > +     ip -net $SERVER_NS route add $CLIENT_IP6 dev link3 via $SERVER_GW=
6
> > +     ip -net $SERVER_NS link set dev link3 \
> > +             gro_ipv4_max_size $MAX_SIZE gso_ipv4_max_size $MAX_SIZE
> > +     ip -net $SERVER_NS link set dev link3 \
> > +             gro_max_size $MAX_SIZE gso_max_size $MAX_SIZE
> > +     ip net exec $SERVER_NS sysctl -wq net.ipv4.tcp_window_scaling=3D1=
0
> > +     ip net exec $SERVER_NS netserver 2>&1 >/dev/null
> > +}
> > +
> > +cleanup() {
> > +     ip net exec $SERVER_NS pkill netserver
> > +     ip -net $ROUTER_NS link del link1
> > +     ip -net $ROUTER_NS link del link2
> > +     ip netns del "$CLIENT_NS"
> > +     ip netns del "$SERVER_NS"
> > +     ip netns del "$ROUTER_NS"
> > +}
> > +
> > +start_counter() {
> > +     local ipt=3D"iptables"
> > +     local iface=3D$1
> > +     local netns=3D$2
> > +
> > +     [ "$NF" =3D "6" ] && ipt=3D"ip6tables"
> > +     ip net exec $netns $ipt -t raw -A PREROUTING -i $iface \
> > +             -m length ! --length 0:$CHK_SIZE -j ACCEPT
> > +}
> > +
> > +check_counter() {
> > +     local ipt=3D"iptables"
> > +     local iface=3D$1
> > +     local netns=3D$2
> > +
> > +     [ "$NF" =3D "6" ] && ipt=3D"ip6tables"
> > +     test `ip net exec $netns $ipt -t raw -L -v |grep $iface | awk '{p=
rint $1}'` !=3D "0"
> > +}
> > +
> > +stop_counter() {
> > +     local ipt=3D"iptables"
> > +     local iface=3D$1
> > +     local netns=3D$2
> > +
> > +     [ "$NF" =3D "6" ] && ipt=3D"ip6tables"
> > +     ip net exec $netns $ipt -t raw -D PREROUTING -i $iface \
> > +             -m length ! --length 0:$CHK_SIZE -j ACCEPT
> > +}
> > +
> > +do_netperf() {
> > +     local serip=3D$SERVER_IP4
> > +     local netns=3D$1
> > +
> > +     [ "$NF" =3D "6" ] && serip=3D$SERVER_IP6
> > +     ip net exec $netns netperf -$NF -t TCP_STREAM -H $serip 2>&1 >/de=
v/null
> > +}
> > +
> > +do_test() {
> > +     local cli_tso=3D$1
> > +     local gw_gro=3D$2
> > +     local gw_tso=3D$3
> > +     local ser_gro=3D$4
> > +     local ret=3D"PASS"
> > +
> > +     ip net exec $CLIENT_NS ethtool -K link0 tso $cli_tso
> > +     ip net exec $ROUTER_NS ethtool -K link1 gro $gw_gro
> > +     ip net exec $ROUTER_NS ethtool -K link2 tso $gw_tso
> > +     ip net exec $SERVER_NS ethtool -K link3 gro $ser_gro
> > +
> > +     start_counter link1 $ROUTER_NS
> > +     start_counter link3 $SERVER_NS
> > +     do_netperf $CLIENT_NS
> > +
> > +     if check_counter link1 $ROUTER_NS; then
> > +             check_counter link3 $SERVER_NS || ret=3D"FAIL_on_link3"
> > +     else
> > +             ret=3D"FAIL_on_link1"
> > +     fi
> > +
> > +     stop_counter link1 $ROUTER_NS
> > +     stop_counter link3 $SERVER_NS
> > +     printf "%-9s %-8s %-8s %-8s: [%s]\n" \
> > +             $cli_tso $gw_gro $gw_tso $ser_gro $ret
> > +     test $ret =3D "PASS"
> > +}
> > +
> > +testup() {
> > +     echo "CLI GSO | GW GRO | GW GSO | SER GRO" && \
> > +     do_test "on"  "on"  "on"  "on"  && \
> > +     do_test "on"  "off" "on"  "off" && \
> > +     do_test "off" "on"  "on"  "on"  && \
> > +     do_test "on"  "on"  "off" "on"  && \
> > +     do_test "off" "on"  "off" "on"
> > +}
> > +
> > +if ! netperf -V &> /dev/null; then
>
> Is it ever possible that we get netperf without netserver?
Hi, Aaron,

"bin_PROGRAMS =3D netperf netserver" in src/Makefile.am
of netperf source code will ensure both will be compiled and
installed, unless someone deletes "netserver" from the
source code.

Other kselftest like netfilter/nft_concat_range.sh also assumes
netserver exists if netperf command is installed.

Thanks for the review.

>
> > +     echo "SKIP: Could not run test without netperf tool"
> > +     exit $ksft_skip
> > +fi
> > +
> > +if ! ip link help 2>&1 | grep gso_ipv4_max_size &> /dev/null; then
> > +     echo "SKIP: Could not run test without gso/gro_ipv4_max_size supp=
orted in ip-link"
> > +     exit $ksft_skip
> > +fi
> > +
> > +trap cleanup EXIT
> > +setup && echo "Testing for BIG TCP:" && \
> > +NF=3D4 testup && echo "***v4 Tests Done***" && \
> > +NF=3D6 testup && echo "***v6 Tests Done***"
> > +exit $?
>
