Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3B536B502
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 16:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbhDZOh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 10:37:27 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44227 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233501AbhDZOh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 10:37:27 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 081395C0164;
        Mon, 26 Apr 2021 10:36:45 -0400 (EDT)
Received: from imap21 ([10.202.2.71])
  by compute4.internal (MEProxy); Mon, 26 Apr 2021 10:36:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hmh.eng.br; h=
        mime-version:message-id:date:from:to:subject:content-type; s=
        fm2; bh=tMx2BZVAMOMXQXtBh8utAOGoUJIA/+txAc3Z0kDjE24=; b=LSwKSwv+
        O+YyBM+0IQhwdAcJMxhB1hnZVkHVySUqBxyw0O2wIolZ3doOB8J8LF29II6qGTBV
        0HDcTpV7z9op7I1CZIJRxi9IMnAnGY9ZipGfeo5Bb16YRYjtV1zA59XpLQNUeSuW
        PxngAcOVmqKfnc7OwC2LnwtN/NCCyzqs8sTlV4HPm01dPgcnnE+A1fh6ZdPBS67j
        +PZaYQbrZxiwB8LAXv7wZRQPtgUw9equZLy4LlQx7bnNNp48rMlPCLS9ALDQVmxN
        gn9BwznCPtvZhZTMDONKTJWuYnK2pWGrbgSMA1BadAZa66ZOIM/hIRXgmnHh9tcd
        qnJA8eeQc5yODA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm2; bh=tMx2BZVAMOMXQXtBh8utAOGoUJIA/
        +txAc3Z0kDjE24=; b=VXBsYUNW12bBTzcH7J80UFvHsEMfUMPNDoGcviBSNYmPQ
        wGrhfxeuGASroJvPqXQWL/dtxhYnCkFHxExkqeq1tsxiEAH7OSmi5hWfO1Jzs9/1
        3SPDE7qFvLFNoc3kQ9Ih0S5HXrZLlvejpjceVyWQ0qXS5yd35+FjJGcDuphpbteu
        OTV5Ej8RS8ua5pZoSjmV4tQ29qG6rZBAnhzD29XSlqHSfCkgoqvqSkF2a6ahx0aW
        TRuYmxaxiypcNF2lSyuoJf2o6AF/pS4BRdbWOW0c78n2nlFVTsZQwT7rWT0NpPoC
        LpKNh1N+M9mtjGrXhf/IcuvzM0R4mazFqrzblf3xw==
X-ME-Sender: <xms:_M-GYDTvSBlUYztLefZTHw30pQoWDL1dP5N9S-wvc3o4wnCPNYu_ZQ>
    <xme:_M-GYEyt3C4eAN-AvuZXD19lXjVfxt9IrMqSr0XYFMVUAIqVTXK3pEuUKZyRbpc2N
    -mS2F5Xwk5mkQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddukedgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefofgggkfffhffvufgtsehmtderre
    erredtnecuhfhrohhmpedfjfgvnhhrihhquhgvucguvgcuofhorhgrvghsucfjohhlshgt
    hhhuhhdfuceohhhmhheshhhmhhdrvghnghdrsghrqeenucggtffrrghtthgvrhhnpeelge
    dvfeduudduueejhedtfeetvedugfehffejhfeiieektdekjeelkefhhedujeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehhmhhhsehhmhhhrd
    gvnhhgrdgsrh
X-ME-Proxy: <xmx:_M-GYI1pGNnnvFrdt7nMJ_tIytgKIRIoBcYJAvfubEPHPE1D__2vHA>
    <xmx:_M-GYDALGTdmHT9g9uxGRU-BXahe_tBM4oojIKKE1hEeIR-qRQxbtg>
    <xmx:_M-GYMinOiKmBF9k29L6BYKzEJeZevjajyCJFPRRsqkSSySMsWDVIg>
    <xmx:_c-GYHuMzPmt-4e2iF67T6jcCk9qN3gsolEsCxSyoQVBvKivRFMepg>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 9210A51C005F; Mon, 26 Apr 2021 10:36:44 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-403-gbc3c488b23-fm-20210419.005-gbc3c488b
Mime-Version: 1.0
Message-Id: <d3a4afd7-a448-4310-930d-063b39bde86e@www.fastmail.com>
Date:   Mon, 26 Apr 2021 11:35:56 -0300
From:   "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Unexpected timestamps in tcpdump with veth + tc qdisc netem delay
Content-Type: multipart/mixed;
 boundary=8da327b28c4047e6a73cddde4112973c
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--8da327b28c4047e6a73cddde4112973c
Content-Type: text/plain

(please CC me in any replies, thank you!)

Hello,

While trying to simulate large delay links using veth and netns, I came across what looks like unexpected / incorrect behavior.

I have reproduced it in Debian 4.19 and 5.10 kernels, and a quick look at mainline doesn't show any relevant deviation from Debian kernels to mainline in my limited understanding of this area of the kernel.

I have attached a simple script to reproduce the scenario.  If my explanation below is not clear, please just look at the script to see what it does: it should be trivial to understand.  It needs tcpdump, and CAP_NET_ADMIN (or root, etc).

Topology

root netns:
   veth vec0 (192.168.233.1)   paired to ves0 (192.168.233.2)
   tc qdisc dev vec0 root netem delay 250ms

lab500ms netns:
   veth ves0 (192.168.233.2), paired to vec0 (192.168.233.1)
   tc qdisc dev ves0 root netem delay 250ms

So:
[root netns  -- veth (tc qdisc netem delay 250ms) ] <> [ veth (tc qdisc netem delay 250ms) -- lab500ms netns ]

Expected RTT from a packet roundtrip (root nets -> lab500ms netns -> root netns) is 500ms.


The problem:

[root netns]:  ping 192.168.233.2
PING 192.168.233.2 (192.168.233.2) 56(84) bytes of data.
64 bytes from 192.168.233.2: icmp_seq=1 ttl=64 time=500 ms
64 bytes from 192.168.233.2: icmp_seq=2 ttl=64 time=500 ms

(the RTT reported by ping is 500ms as expected: there is a 250ms transmit delay attached to each member of the veth pair)

However:

[root netns]: tcpdump -i vec0 -s0 -n -p net 192.168.233.0/30
listening on vec0, link-type EN10MB (Ethernet), capture size 262144 bytes
17:09:09.740681 IP 192.168.233.1 > 192.168.233.2: ICMP echo request, id 9327, seq 1, length 64
17:09:09.990891 IP 192.168.233.2 > 192.168.233.1: ICMP echo reply, id 9327, seq 1, length 64
17:09:10.741903 IP 192.168.233.1 > 192.168.233.2: ICMP echo request, id 9327, seq 2, length 64
17:09:10.992031 IP 192.168.233.2 > 192.168.233.1: ICMP echo reply, id 9327, seq 2, length 64
17:09:11.742813 IP 192.168.233.1 > 192.168.233.2: ICMP echo request, id 9327, seq 3, length 64
17:09:11.993009 IP 192.168.233.2 > 192.168.233.1: ICMP echo reply, id 9327, seq 3, length 64

[lab500ms netns]: ip netns exec lab500ms tcpdump -i ves0 -s0 -n -p net 192.168.233.0/30
listening on ves0, link-type EN10MB (Ethernet), capture size 262144 bytes
17:09:09.740724 IP 192.168.233.1 > 192.168.233.2: ICMP echo request, id 9327, seq 1, length 64
17:09:09.990867 IP 192.168.233.2 > 192.168.233.1: ICMP echo reply, id 9327, seq 1, length 64
17:09:10.741942 IP 192.168.233.1 > 192.168.233.2: ICMP echo request, id 9327, seq 2, length 64
17:09:10.992012 IP 192.168.233.2 > 192.168.233.1: ICMP echo reply, id 9327, seq 2, length 64
17:09:11.742851 IP 192.168.233.1 > 192.168.233.2: ICMP echo request, id 9327, seq 3, length 64
17:09:11.992985 IP 192.168.233.2 > 192.168.233.1: ICMP echo reply, id 9327, seq 3, length 64

One can see that the timestamps shown by tcpdump (also reproduced using wireshark) are *not* what one would expect: the 250ms delays are missing in incoming packets (i.e. there's 250ms missing from timestamps in packets "echo reply" in vec0, and "echo request" in ves0).

The 250ms vec0->ves0 delay AND 250ms ves0 -> vec0 delay *are* there, as shown by "ping", but you'd not know it if you look at the tcpdump.  The timing shown in tcpdump looks more like packet injection time at the first interface, than the time the packet was "seen" at the other end (capture interface).

Adding more namespaces and VETH pairs + routing "in a row" so that the packet "exits" one veth tunnel and enters another one (after trivial routing) doesn't fix the tcpdump timestamps in the capture at the other end of the veth-veth->routing->veth-veth->routing->... chain.

It looks like some sort of bug to me, but maybe I am missing something, in which case I would greatly appreciate an explanation of where I went wrong... 

Thanks in advance,
Henrique de Moraes Holschuh <hmh@hmh.eng.br>
--8da327b28c4047e6a73cddde4112973c
Content-Disposition: attachment;filename="netns.sh"
Content-Type: application/x-sh; name="netns.sh"
Content-Transfer-Encoding: BASE64

IyEvYmluL2Jhc2gKCiMgV0FSTklORzogZGVsZXRlcyBhbmQgcmVjcmVhdGVzOgojICBsaW5r
IHZlYzAKIyAgbGluayB2ZXMwCiMgIG5hbWVzcGFjZSBsYWI1MDBtcwojCiMgY3JlYXRlcyB0
ZW1wIGRpciB3aXRoIHByZWZpeCB2ZXRoLW5ldGVtLWlzc3VlIGluICRUTVBESVIgb3IgL3Rt
cC4KClJUVD01MDBtcwpMREVMQVk9MjUwbXMKTkVUTlM9ImxhYiRSVFQiCgpkZXZsPXZlYzAK
ZGV2cj12ZXMwCgpURElSPSQobWt0ZW1wIC1kIC10IHZldGgtbmV0ZW0taXNzdWUuWFhYWFhY
WFhYWCkgfHwgZXhpdCAxClsgLWQgIiRURElSIiBdIHx8IGV4aXQgMQoKIyBjcmVhdGUgbmV0
bnMgYW5kIGVuYWJsZSBsb29wYmFjaywgaWYgbWlzc2luZwppcCBuZXRucyBhZGQgJE5FVE5T
IDI+L2Rldi9udWxsCmlwIG5ldG5zIGV4ZWMgJE5FVE5TIGlwIGxpbmsgc2V0IGRldiBsbyB1
cAoKIyBjcmVhdGUgVkVUSCBwYWlyCmlwIGxpbmsgZGVsIGRldiAkZGV2bCAyPiYxCmlwIGxp
bmsgYWRkICRkZXZsIG10dSAxNTAwIHR5cGUgdmV0aCBwZWVyIG5hbWUgJGRldnIgMj4vZGV2
L251bGwgJiYgewoJaXAgbGluayBzZXQgJGRldnIgbmV0bnMgJE5FVE5TCn0KCiMgc2V0dXAg
bG9jYWwgc2lkZQppcCBsaW5rIHNldCAkZGV2bCB1cAppcCBhZGRyIGFkZCAxOTIuMTY4LjIz
My4xLzMwIGRldiAkZGV2bAoKIyBzZXR1cCBuZXRucyBzaWRlCmlwIG5ldG5zIGV4ZWMgJE5F
VE5TIGlwIGxpbmsgc2V0IGRldiAkZGV2ciB1cAppcCBuZXRucyBleGVjICRORVROUyBpcCBh
ZGRyIGFkZCAxOTIuMTY4LjIzMy4yLzMwIGRldiAkZGV2cgoKIyBOb3cgYWRkIGhhbGYtUlRU
IGRlbGF5IHRvIFRYIHF1ZXVlIG9mIGJvdGggdmV0aCBzaWRlcwp0YyBxZGlzYyByZXBsYWNl
IGRldiAkZGV2bCByb290IG5ldGVtIGRlbGF5ICIkTERFTEFZIgppcCBuZXRucyBleGVjICRO
RVROUyB0YyBxZGlzYyByZXBsYWNlIGRldiAkZGV2ciByb290IG5ldGVtIGRlbGF5ICIkTERF
TEFZIgoKIyBwcmVsb2FkIGFycCB0byBhdm9pZCBbcG9zc2libGVdIEFSUCByZXNvbHV0aW9u
IGRlbGF5IG9uIGZpcnN0IHBpbmcsIGp1c3QgZm9yIGNsYXJpdHkKcGluZyAtYyAxIDE5Mi4x
NjguMjMzLjIgPi9kZXYvbnVsbCAyPiYxCgojIHN0YXJ0IHR3byB0Y3BkdW1wcywgbGltaXRl
ZCB0byAxMCBwYWNrZXRzCmVjaG8gInN0YXJ0aW5nIHRjcGR1bXAgaW4gYmFja2dyb3VuZCwg
b3V0cHV0IHRvICRURElSL3ZlYzAucGNhcCBhbmQgJFRESVIvdmVzMC5wY2FwIgp0Y3BkdW1w
IC1pIHZlYzAgLW4gLXAgLXcgIiRURElSL3ZlYzAucGNhcCIgLWMgMTAgbmV0IDE5Mi4xNjgu
MjMzLjAvMzAgYW5kIGljbXAgPi9kZXYvbnVsbCAyPiYxICYKaXAgbmV0bnMgZXhlYyAkTkVU
TlMgdGNwZHVtcCAtaSB2ZXMwIC1uIC1wIC13ICIkVERJUi92ZXMwLnBjYXAiIC1jIDEwIG5l
dCAxOTIuMTY4LjIzMy4wLzMwIGFuZCBpY21wID4vZGV2L251bGwgMj4mMSAmCgpzbGVlcCAx
CgplY2hvCmVjaG8gInBpbmcgc2hvd3MgNTAwbXMgUlRUIGFzIGV4cGVjdGVkIgpwaW5nIC1j
IDYgMTkyLjE2OC4yMzMuMgoKZWNobwplY2hvICJidXQgdGhlIHRjcGR1bXBzIHNob3cgaW5j
b3JyZWN0IHJlY2VpdmUgdGltZXN0YW1wczogIgplY2hvICJ0aGUgdGltZXN0YW1wcyBsb29r
IG1vcmUgbGlrZSBwYWNrZXQgY3JlYXRpb24gdGltZSB0aGFuIHBhY2tldC1zZWVuLWF0LWNh
cHR1cmUtaW50ZXJmYWNlIHRpbWUiCmVjaG8gCmVjaG8gImxvY2FsIHNpZGU6Igp0Y3BkdW1w
IC1uIC12IC1yICIkVERJUi92ZWMwLnBjYXAiCmVjaG8KZWNobyAicmVtb3RlIHNpZGU6Igp0
Y3BkdW1wIC1uIC12IC1yICIkVERJUi92ZXMwLnBjYXAiCmVjaG8KZWNobyAicGNhcCBmaWxl
cyBwcmVzZXJ2ZWQgaW4gJFRESVIiCg==

--8da327b28c4047e6a73cddde4112973c--
