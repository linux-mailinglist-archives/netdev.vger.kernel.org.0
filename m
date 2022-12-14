Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D17A064D35E
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 00:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiLNX23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 18:28:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiLNX2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 18:28:03 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7A026489;
        Wed, 14 Dec 2022 15:26:04 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 4940C32008FD;
        Wed, 14 Dec 2022 18:26:03 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 14 Dec 2022 18:26:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; t=1671060362; x=1671146762; bh=Hx6izBhKYVxfsBLJXIUvyCWin
        dpnU08ydcv0A5E/rK4=; b=LY/gdMdRWY+VitUjRVV3wvbkd4jcJNL+0Hm2Epb/8
        yXii8jk/BjBVK5nKtheWQ4CXzqY9U5s5+7eTwTvio9QJK1rgi4n8sCssaSUX2vGs
        QmewnqOTPuVe3Y6agQWq8+8ANt+UPJrKdLhHB7fFvQw8pVHkegHKQ9WxmkzGWXmY
        zUHr1MRvdqCowKB3lVJ4NPMktlhSn4/O8W5QYZHQU6hAqOqtcVp1WYvmeAwTyd9C
        Z2Yw8Z6Af9dTNxbU6n+sfkC26pxJNmxuW4UeYSQeVG/kSrZscqdf9+q+SsGdghNo
        USskdkgWZvaZKJAcoZ2sgo5CckJcpK+4ikeuiEukaNT1Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1671060362; x=1671146762; bh=Hx6izBhKYVxfsBLJXIUvyCWindpnU08ydcv
        0A5E/rK4=; b=QPORRggztELcFvcwh27lP+RqGRF3qT1m6cB7FYw41W44XBsjrNn
        XRU5f4CGkE1/PdcCmC7sq1xMMJGkIfwDSG7WY2jnqpbjR32gRbFlCR9lSRG/J0CS
        K90jsYPedXUMKLx2qmT+ITAZ9TZjvnslRx2W3TaTR5i7IGsFzDL0v+ouQ3nVLtMh
        PlVJaBzsyHgqd6r5/9QxPVUhBKHjjjPtQMtyHO8iJzy4E4mOQW05k35qFKU0pFZf
        beClz4GM2rg9CW+FctH5lZ/rdBlt/UPK2wUthOgkKAeB9s1IJe6QBc0XY3XAr97H
        dzaha+xFnwae7+PxmGCa0V/mWDkqIi9plJQ==
X-ME-Sender: <xms:iVuaY_yIOMY9GgXtetc0cpiuPozne7MCoUbXAkkKWbVzrjpus5m1Hw>
    <xme:iVuaY3TXakkbM7YTNsnP7WAfHc75_EnfjW0AjAV22r2ZK6rIP9yeZRK_7sYfdIF4d
    ntRu0b6xtxIAUUS0Q>
X-ME-Received: <xmr:iVuaY5VMYG4XQOPLgVXNf64luww7dYi6kv-8FkoepWHJbFcZUYJoNLUU-y88c9Xx1PG0coxA2x_rQTnHI3_jqdS_sBSiXVuSLXVU98VZCGI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeggddtjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdefhedmnecujfgurhephffvve
    fufffkofgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcuoegugihu
    segugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpeetgefhhfeigfejtddvteefff
    fgteekteduiedtkeevleduvdejueeggfdtfeegfeenucffohhmrghinhepihgvthhfrdho
    rhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepug
    iguhesugiguhhuuhdrgiihii
X-ME-Proxy: <xmx:iluaY5jlDZjZwbFghVoyeySHPLpTNrkVce5uIc0MGb7zQ5q52lm9bw>
    <xmx:iluaYxAWle5CX1iaBtXl5Ii6_avazPMsS-_8FkzV4Ra8plMpw4mreQ>
    <xmx:iluaYyJh8z6mZjqGQMo4QpcPh66IVpiC3kS-vAHMlghUyj8rCe-tzQ>
    <xmx:iluaY1ucR91cCb3YJR80mw5SGnfbYoYbQc6PvgBajR2hm0W4ICg3hA>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Dec 2022 18:26:01 -0500 (EST)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        martin.lau@linux.dev, daniel@iogearbox.net, ast@kernel.org,
        andrii@kernel.org
Cc:     ppenkov@aviatrix.com, dbird@aviatrix.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next 0/6] Support defragmenting IPv4 packets in BPF
Date:   Wed, 14 Dec 2022 16:25:27 -0700
Message-Id: <cover.1671049840.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        FROM_SUSPICIOUS_NTLD_FP,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_PDS_OTHER_BAD_TLD autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=== Context ===

In the context of a middlebox, fragmented packets are tricky to handle.
The full 5-tuple of a packet is often only available in the first
fragment which makes enforcing consistent policy difficult. There are
really only two stateless options, neither of which are very nice:

1. Enforce policy on first fragment and accept all subsequent fragments.
   This works but may let in certain attacks or allow data exfiltration.

2. Enforce policy on first fragment and drop all subsequent fragments.
   This does not really work b/c some protocols may rely on
   fragmentation. For example, DNS may rely on oversized UDP packets for
   large responses.

So stateful tracking is the only sane option. RFC 8900 [0] calls this
out as well in section 6.3:

    Middleboxes [...] should process IP fragments in a manner that is
    consistent with [RFC0791] and [RFC8200]. In many cases, middleboxes
    must maintain state in order to achieve this goal.

=== BPF related bits ===

However, when policy is enforced through BPF, the prog is run before the
kernel reassembles fragmented packets. This leaves BPF developers in a
awkward place: implement reassembly (possibly poorly) or use a stateless
method as described above.

Fortunately, the kernel has robust support for fragmented ipv4 packets.
This patchset wraps the existing defragmentation facilities in a kfunc so
that BPF progs running on middleboxes can reassemble fragmented packets
before applying policy.

=== Patchset details ===

This patchset is (hopefully) relatively straightforward from BPF perspective.
One thing I'd like to call out is the skb_copy()ing of the prog skb. I
did this to maintain the invariant that the ctx remains valid after prog
has run. This is relevant b/c ip_defrag() and ip_check_defrag() may
consume the skb if the skb is a fragment.

Originally I did play around with teaching the verifier about kfuncs
that may consume the ctx and disallowing ctx accesses in ret != 0
branches. It worked ok, but it seemed too complex to modify the
surrounding assumptions about ctx validity.

[0]: https://datatracker.ietf.org/doc/html/rfc8900

Daniel Xu (6):
  ip: frags: Return actual error codes from ip_check_defrag()
  bpf: verifier: Support KF_CHANGES_PKT flag
  bpf, net, frags: Add bpf_ip_check_defrag() kfunc
  bpf: selftests: Support not connecting client socket
  bpf: selftests: Support custom type and proto for client sockets
  bpf: selftests: Add bpf_ip_check_defrag() selftest

 Documentation/bpf/kfuncs.rst                  |   7 +
 drivers/net/macvlan.c                         |   2 +-
 include/linux/btf.h                           |   1 +
 include/net/ip.h                              |  11 +
 kernel/bpf/verifier.c                         |   8 +
 net/ipv4/Makefile                             |   1 +
 net/ipv4/ip_fragment.c                        |  13 +-
 net/ipv4/ip_fragment_bpf.c                    |  98 ++++++
 net/packet/af_packet.c                        |   2 +-
 .../selftests/bpf/generate_udp_fragments.py   |  52 +++
 tools/testing/selftests/bpf/network_helpers.c |  26 +-
 tools/testing/selftests/bpf/network_helpers.h |   3 +
 .../bpf/prog_tests/ip_check_defrag.c          | 296 ++++++++++++++++++
 .../selftests/bpf/progs/bpf_tracing_net.h     |   1 +
 .../selftests/bpf/progs/ip_check_defrag.c     |  83 +++++
 15 files changed, 589 insertions(+), 15 deletions(-)
 create mode 100644 net/ipv4/ip_fragment_bpf.c
 create mode 100755 tools/testing/selftests/bpf/generate_udp_fragments.py
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ip_check_defrag.c
 create mode 100644 tools/testing/selftests/bpf/progs/ip_check_defrag.c

-- 
2.39.0

