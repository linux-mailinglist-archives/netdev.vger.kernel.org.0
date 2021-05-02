Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292FD370DE5
	for <lists+netdev@lfdr.de>; Sun,  2 May 2021 18:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231909AbhEBQZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 May 2021 12:25:33 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41849 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230110AbhEBQZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 May 2021 12:25:32 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id CCCF75C0117;
        Sun,  2 May 2021 12:24:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 02 May 2021 12:24:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Ob0SpQdzNHEBQis8i
        v7QvPiy+BVbzLeFAEv8JNTMs0s=; b=la5Gl75MVbdO0egpROwa0cFOFvi94t5l7
        +nCDgmkQLDAuIOZ36SB0UDrq6AH9nORzwe4TBqxgV2JYopULzbJSYZxEaFthWc6d
        sEaYjqFC4s5NXDJNXf/jx08DoRIwISMfWCWCW0aO05FO9bMYZuOsJVN6FY21rMqu
        RWXLS6MxcmTXms/13wpHEVHqLwuaQ8I3nhysEbaiwdUKt7EwMAT4eTCPog9xbvXr
        P8H1/TuGxIFbqCInJLs26HCAGgdQWm6LyuGr/UqoyNDGcSQzLzBftzH+bTgX1xRn
        +9I4OyjotJUk0cIzqZl6A+NxeWdR48yKOsQRr27VbwyF6IPwPGc4A==
X-ME-Sender: <xms:SNKOYJT_Lrm0cKROBq-SFOBJhnP0QyE1SBMwFc3fL82NTvG6B845bw>
    <xme:SNKOYCzmB09gSw64R-xODBFtomz4M7zBcG0ItEd1ZYUY4zyTRDzQoKMAagaM1USv4
    JRtWodhkHhQ7v8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefvddgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteelfffgtdetudeuieelveeuhedvuefftd
    ejieffteevvdevgffffeefledthfdvnecuffhomhgrihhnpegrphhnihgtrdhnvghtpdhk
    vghrnhgvlhdrohhrghenucfkphepudelfedrgeejrdduieehrddvhedunecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:SNKOYO3gGA88Cxsdtf6ck4nWFVh2zdWZdP5hCoqXyanQXYen-gSw-Q>
    <xmx:SNKOYBAfDO3oP0IgUhbvnHrJKTmolRLz7nJdRx7N-lNFkFiK7vb6CQ>
    <xmx:SNKOYCheFZF8gvslZtxSm3fKX10g0TQUbSCI0DCDBgIm0p3JsomIMg>
    <xmx:SNKOYNVxa12PiVA43ec43iQ39CqyHXfgE29lI9ngFKJa6l7AiD80pQ>
Received: from shredder.mellanox.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  2 May 2021 12:24:37 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        petrm@nvidia.com, roopa@nvidia.com, nikolay@nvidia.com,
        ssuryaextr@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 00/10] Add support for custom multipath hash
Date:   Sun,  2 May 2021 19:22:47 +0300
Message-Id: <20210502162257.3472453-1-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patchset adds support for custom multipath hash policy for both
IPv4 and IPv6 traffic. The new policy allows user space to control the
outer and inner packet fields used for the hash computation.

Motivation
==========

Linux currently supports different multipath hash policies for IPv4 and
IPv6 traffic:

* Layer 3
* Layer 4
* Layer 3 or inner layer 3, if present

These policies hash on a fixed set of fields, which is inflexible and
against operators' requirements to control the hash input: "The ability
to control the inputs to the hash function should be a consideration in
any load-balancing RFP" [1].

An example of this inflexibility can be seen by the fact that none of
the current policies allows operators to use the standard 5-tuple and
the flow label for multipath hash computation. Such a policy is useful
in the following real-world example of a data center with the following
types of traffic:

* Anycast IPv6 TCP traffic towards layer 4 load balancers. Flow label is
constant (zero) to avoid breaking established connections

* Non-encapsulated IPv6 traffic. Flow label is used to re-route flows
around problematic (congested / failed) paths [2]

* IPv6 encapsulated traffic (IPv4-in-IPv6 or IPv6-in-IPv6). Outer flow
label is generated from encapsulated packet

* UDP encapsulated traffic. Outer source port is generated from
encapsulated packet

In the above example, using the inner flow information for hash
computation in addition to the outer flow information is useful during
failures of the BPF agent that selectively generates the flow label
based on the traffic type. In such cases, the self-healing properties of
the flow label are lost, but encapsulated flows are still load balanced.

Control over the inner fields is even more critical when encapsulation
is performed by hardware routers. For example, the Spectrum ASIC can
only encode 8 bits of entropy in the outer flow label / outer UDP source
port when performing IP / UDP encapsulation. In the case of IPv4 GRE
encapsulation there is no outer field to encode the inner hash in.

User interface
==============

In accordance with existing multipath hash configuration, the new custom
policy is added as a new option (3) to the
net.ipv{4,6}.fib_multipath_hash_policy sysctls. When the new policy is
used, the packet fields used for hash computation are determined by the
net.ipv{4,6}.fib_multipath_hash_fields sysctls. These sysctls accept a
bitmap according to the following table (from ip-sysctl.rst):

	== ============================
	 0 Source IP address
	 1 Destination IP address
	 2 IP protocol
	 3 Flow Label
	 4 Source port
	 5 Destination port
	 6 Inner source IP address
	 7 Inner destination IP address
	 8 Inner IP protocol
	 9 Inner Flow Label
	10 Inner source port
	11 Inner destination port
	== ============================

For example, to allow IPv6 traffic to be hashed based on standard
5-tuple and flow label:

 # sysctl -wq net.ipv6.fib_multipath_hash_fields=0-5
 # sysctl -wq net.ipv6.fib_multipath_hash_policy=3

Implementation
==============

As with existing policies, the new policy relies on the flow dissector
to extract the packet fields for the hash computation. However, unlike
existing policies that either use the outer or inner flow, the new
policy might require both flows to be dissected.

To avoid unnecessary invocations of the flow dissector, the data path
consults two variables ('need_outer' and 'need_inner') that are set from
the control path, based on whether any outer or inner fields are
required.

In addition, inner flow dissection is not performed when no
encapsulation was encountered (i.e., 'FLOW_DIS_ENCAPSULATION' not set by
flow dissector) during dissection of the outer flow.

Testing
=======

Three new selftests are added with three different topologies that allow
testing of following traffic combinations:

* Non-encapsulated IPv4 / IPv6 traffic
* IPv4 / IPv6 overlay over IPv4 underlay
* IPv4 / IPv6 overlay over IPv6 underlay

All three tests follow the same pattern. Each time a different packet
field is used for hash computation. When the field changes in the packet
stream, traffic is expected to be balanced across the two paths. When
the field does not change, traffic is expected to be unbalanced across
the two paths.

Patchset overview
=================

Patches #1-#3 add custom multipath hash support for IPv4 traffic
Patches #4-#7 do the same for IPv6
Patches #8-#10 add selftests

TODO
====

Add mlxsw support.

[1] https://blog.apnic.net/2018/01/11/ipv6-flow-label-misuse-hashing/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3acf3ec3f4b0fd4263989f2e4227bbd1c42b5fe1

Ido Schimmel (10):
  ipv4: Calculate multipath hash inside switch statement
  ipv4: Add a sysctl to control multipath hash fields
  ipv4: Add custom multipath hash policy
  ipv6: Use a more suitable label name
  ipv6: Calculate multipath hash inside switch statement
  ipv6: Add a sysctl to control multipath hash fields
  ipv6: Add custom multipath hash policy
  selftests: forwarding: Add test for custom multipath hash
  selftests: forwarding: Add test for custom multipath hash with IPv4
    GRE
  selftests: forwarding: Add test for custom multipath hash with IPv6
    GRE

 Documentation/networking/ip-sysctl.rst        |  62 +++
 include/net/ip_fib.h                          |  46 ++
 include/net/ipv6.h                            |   8 +
 include/net/netns/ipv4.h                      |   4 +
 include/net/netns/ipv6.h                      |   6 +-
 net/ipv4/fib_frontend.c                       |  24 +
 net/ipv4/route.c                              | 127 ++++-
 net/ipv4/sysctl_net_ipv4.c                    |  35 +-
 net/ipv6/ip6_fib.c                            |  23 +-
 net/ipv6/route.c                              | 131 ++++-
 net/ipv6/sysctl_net_ipv6.c                    |  35 +-
 .../net/forwarding/custom_multipath_hash.sh   | 364 ++++++++++++++
 .../forwarding/gre_custom_multipath_hash.sh   | 456 +++++++++++++++++
 .../ip6gre_custom_multipath_hash.sh           | 458 ++++++++++++++++++
 14 files changed, 1770 insertions(+), 9 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/custom_multipath_hash.sh
 create mode 100755 tools/testing/selftests/net/forwarding/gre_custom_multipath_hash.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ip6gre_custom_multipath_hash.sh

-- 
2.30.2

