Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3509D3435F1
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 01:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhCVAZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 20:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbhCVAZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 20:25:22 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33FAAC061574
        for <netdev@vger.kernel.org>; Sun, 21 Mar 2021 17:25:11 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id i3so11327962oik.7
        for <netdev@vger.kernel.org>; Sun, 21 Mar 2021 17:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cilium-io.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BkhL2+YkA0AEMtF8rCcWWX4XQ8syPhfwvLzMYf6HBfw=;
        b=rY3AipXntmXVa2P7sdvgsGIVpUJzOg+Tczl+a4D24KAj6s2Mw4xcPhTAhoXItxdwul
         C8/CXjEy+V4zgDpSYPGj/tIC5sK94r5nslDuzvsIVkEOMbxbQABdkINyArxQ6lPJWnyu
         sXQKmfGyY3//Tqo89EFHl9e2tzyHey76GUui6jgTw2KqLbB10zSSKMMKdvYIKeN7mo82
         HB4D50xeGm/Z0InLijj7s9eC59u94zsyJU6VccDmTOBHlQ8oqyj6MgLH3k6jzgBiGjxF
         8EHAoOw7WgyItVwqssTlIVJhE7m/Yrkittq6F2u7JNa8LzabNK7UWzTKUQ58F1OqzB8G
         ZfTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BkhL2+YkA0AEMtF8rCcWWX4XQ8syPhfwvLzMYf6HBfw=;
        b=NEwcfnL1VL53eXzkrO70q1ZmSFyifyv3kHnbxSs0BfQyE5mY2mVIA3qhy0relOg5nP
         XI6Z/mWdqaleFFcdsO4FsQgRz2zSAGUqLcc8YHkbzTFDfEklXIgk4dDoCceVWOkFhDa5
         cTlJCPLTsWMAOFvCjzT1aeotkRla2cOQot9sDXDTNtoIvXVuJoGW6RFG903wai+78muP
         jtd+dSY+Tw35WfkHJzxEcSilDFWFCSDxVYGfaSG8jvbvOk+4JNNiSm2l/ufWWKqJd+z5
         SVB4IsVocP4E9lPkkkhyeS5ql24CfNnx76yRQdLKPdwKzwg504d9EXflA7DyD/w7xz1i
         PZQw==
X-Gm-Message-State: AOAM531gyekjz6KeUvje1yR5dlmJ9zsBKz2Bu35jRmo09ne8Lbd6NhqM
        aaC/PSsFT7fYiBJsLidgOOfaW/CFec5gmQooh7FF59xzx+LJl1hc
X-Google-Smtp-Source: ABdhPJwAKnAykOvulpRDdp1bhgBmIhyHvXZwmtelrzotxbwtivt6c0mToonudrABp98Ze4j2FP7moopBJDv7V3jgTeI=
X-Received: by 2002:aca:ad51:: with SMTP id w78mr7792109oie.83.1616372710098;
 Sun, 21 Mar 2021 17:25:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210319204307.3128280-1-aconole@redhat.com>
In-Reply-To: <20210319204307.3128280-1-aconole@redhat.com>
From:   Joe Stringer <joe@cilium.io>
Date:   Sun, 21 Mar 2021 17:24:59 -0700
Message-ID: <CADa=Ryw==DwqWowBMSXqgBVc2zXH_FK_Ky+7n9Dz4EMhF8YANQ@mail.gmail.com>
Subject: Re: [PATCH] openvswitch: perform refragmentation for packets which
 pass through conntrack
To:     Aaron Conole <aconole@redhat.com>
Cc:     Networking <netdev@vger.kernel.org>, dev@openvswitch.org,
        Pravin B Shelar <pshelar@ovn.org>,
        Joe Stringer <joe@cilium.io>,
        Eelco Chaudron <echaudro@redhat.com>,
        Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Aaron, long time no chat :)

On Fri, Mar 19, 2021 at 1:43 PM Aaron Conole <aconole@redhat.com> wrote:
>
> When a user instructs a flow pipeline to perform connection tracking,
> there is an implicit L3 operation that occurs - namely the IP fragments
> are reassembled and then processed as a single unit.  After this, new
> fragments are generated and then transmitted, with the hint that they
> should be fragmented along the max rx unit boundary.  In general, this
> behavior works well to forward packets along when the MTUs are congruent
> across the datapath.
>
> However, if using a protocol such as UDP on a network with mismatching
> MTUs, it is possible that the refragmentation will still produce an
> invalid fragment, and that fragmented packet will not be delivered.
> Such a case shouldn't happen because the user explicitly requested a
> layer 3+4 function (conntrack), and that function generates new fragments,
> so we should perform the needed actions in that case (namely, refragment
> IPv4 along a correct boundary, or send a packet too big in the IPv6 case).
>
> Additionally, introduce a test suite for openvswitch with a test case
> that ensures this MTU behavior, with the expectation that new tests are
> added when needed.
>
> Fixes: 7f8a436eaa2c ("openvswitch: Add conntrack action")
> Signed-off-by: Aaron Conole <aconole@redhat.com>
> ---
> NOTE: checkpatch reports a whitespace error with the openvswitch.sh
>       script - this is due to using tab as the IFS value.  This part
>       of the script was copied from
>       tools/testing/selftests/net/pmtu.sh so I think should be
>       permissible.
>
>  net/openvswitch/actions.c                  |   2 +-
>  tools/testing/selftests/net/.gitignore     |   1 +
>  tools/testing/selftests/net/Makefile       |   1 +
>  tools/testing/selftests/net/openvswitch.sh | 394 +++++++++++++++++++++
>  4 files changed, 397 insertions(+), 1 deletion(-)
>  create mode 100755 tools/testing/selftests/net/openvswitch.sh
>
> diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
> index 92a0b67b2728..d858ea580e43 100644
> --- a/net/openvswitch/actions.c
> +++ b/net/openvswitch/actions.c
> @@ -890,7 +890,7 @@ static void do_output(struct datapath *dp, struct sk_buff *skb, int out_port,
>                 if (likely(!mru ||
>                            (skb->len <= mru + vport->dev->hard_header_len))) {
>                         ovs_vport_send(vport, skb, ovs_key_mac_proto(key));
> -               } else if (mru <= vport->dev->mtu) {
> +               } else if (mru) {
>                         struct net *net = read_pnet(&dp->net);
>
>                         ovs_fragment(net, vport, skb, mru, key);

I thought about this for a while. For a bit of context, my
recollection is that in the initial design, there was an attempt to
minimize the set of assumptions around L3 behaviour and despite
performing this pseudo-L3 action of connection tracking, attempt a
"bump-in-the-wire" approach where OVS is serving as an L2 switch and
if you wanted L3 features, you need to build them on top or explicitly
define that you're looking for L3 semantics. In this case, you're
interpreting that the combination of the conntrack action + an output
action implies that L3 routing is being performed. Hence, OVS should
act like a router and either refragment or generate ICMP PTB in the
case where MTU differs. According to the flow table, the rest of the
routing functionality (MAC handling for instance) may or may not have
been performed at this point, but we basically leave that up to the
SDN controller to implement the right behaviour. In relation to this
particular check, the idea was to retain the original geometry of the
packet such that it's as though there were no functionality performed
in the middle at all. OVS happened to do connection tracking (which
implicitly involved queueing fragments), but if you treat it as an
opaque box, you have ports connected and OVS is simply performing
forwarding between the ports.

One of the related implications is the contrast between what happens
in this case if you have a conntrack action injected or not when
outputting to another port. If you didn't put a connection tracking
action into the flows when redirecting here, then there would be no
defragmentation or refragmentation. In that case, OVS is just
attempting to forward to another device and if the MTU check fails,
then bad luck, packets will be dropped. Now, with the interpretation
in this patch, it seems like we're trying to say that, well, actually,
if the controller injects a connection tracking action, then the
controller implicitly switches OVS into a sort of half-L3 mode for
this particular flow. This makes the behaviour a bit inconsistent.

Another thought that occurs here is that if you have three interfaces
attached to the switch, say one with MTU 1500 and two with MTU 1450,
and the OVS flows are configured to conntrack and clone the packets
from the higher-MTU interface to the lower-MTU interfaces. If you
receive larger IP fragments on the first interface and attempt to
forward on to the other interfaces, should all interfaces generate an
ICMPv6 PTB? That doesn't seem quite right, especially if one of those
ports is used for mirroring the traffic for operational reasons while
the other path is part of the actual routing path for the traffic.
You'd end up with duplicate PTB messages for the same outbound
request. If I read right, this would also not be able to be controlled
by the OVS controller because when we call into ip6_fragment() and hit
the MTU-handling path, it will automatically take over and generate
the ICMP response out the source interface, without any reference to
the OVS flow table. This seems like it's further breaking the model
where instead of OVS being a purely programmable L2-like flow
match+actions pipeline, now depending on the specific actions you
inject (in particular combinations), you get some bits of the L3
functionality. But for full L3 functionality, the controller still
needs to handle the rest through the correct set of actions in the
flow.

Looking at the tree, it seems like this problem can be solved in
userspace without further kernel changes by using
OVS_ACTION_ATTR_CHECK_PKT_LEN, see commit 4d5ec89fc8d1 ("net:
openvswitch: Add a new action check_pkt_len"). It even explicitly says
"The main use case for adding this action is to solve the packet drops
because of MTU mismatch in OVN virtual networking solution.". Have you
tried using this approach?

> diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
> index 61ae899cfc17..d4d7487833be 100644
> --- a/tools/testing/selftests/net/.gitignore
> +++ b/tools/testing/selftests/net/.gitignore
> @@ -30,3 +30,4 @@ hwtstamp_config
>  rxtimestamp
>  timestamping
>  txtimestamp
> +test_mismatched_mtu_with_conntrack
> diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
> index 25f198bec0b2..dc9b556f86fd 100644
> --- a/tools/testing/selftests/net/Makefile
> +++ b/tools/testing/selftests/net/Makefile

Neat to see some bootstrapping of in-tree OVS testing. I'd probably
put it in a separate commit but maybe that's just personal preference.

I didn't look *too* closely at the tests but just one nit below:

> +       # test a udp connection
> +       info "send udp data"
> +       ip netns exec server sh -c 'cat ${ovs_dir}/fifo | nc -l -vv -u 8888 >${ovs_dir}/fifo 2>${ovs_dir}/s1-nc.log & echo $! > ${ovs_dir}/server.pid'

There are multiple netcat implementations with different arguments
(BSD and nmap.org and maybe also Debian versions). Might be nice to
point out which netcat you're relying on here or try to detect & fail
out/skip on the wrong one. For reference, the equivalent OVS test code
detection is here:

https://github.com/openvswitch/ovs/blob/80e74da4fd8bfdaba92105560ce144b4b2d00e36/tests/atlocal.in#L175
