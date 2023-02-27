Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 423D56A4B90
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 20:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbjB0Tvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 14:51:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjB0Tvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 14:51:35 -0500
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03D07ECC;
        Mon, 27 Feb 2023 11:51:33 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id BADDF3200947;
        Mon, 27 Feb 2023 14:51:29 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 27 Feb 2023 14:51:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1677527489; x=1677613889; bh=eD3XTUyleC7VHpJcu1oJPldm9
        EE+fHMQEZsCRJDzCRQ=; b=l2F4WNnM+QPIRn26UF4B25y1qE+SX+/VsfcrMysXl
        Kap3RUpSG+Gc8o8UUSSWD4Lcrp7valwBfvUYd7+DoO19olWIXyfWvO+z5lUTqMLk
        did4fsmA59AWfsxgfjGEAV33qa8kJWWgRmp4ZIRQO1+ge2N3DYk1WJy2nOsFWGtq
        8q4V82MTe5TxIozc0EEV0LIDiEFiGZ3P4vOwLmfpwJqSGRnsa1dYcWcXG/GHRRL2
        nspm/ZeMjt+wtye5q6XUhr481jo+NagpKLjgKxP9Q+RPb7/3rsIfxitnA7xOL/34
        QX5FbCniqb0ihQqPAQwM3LiUbotT00fBVnpaVZYGLN+qg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1677527489; x=1677613889; bh=eD3XTUyleC7VHpJcu1oJPldm9EE+fHMQEZs
        CRJDzCRQ=; b=VzdRcjv/DNK/XYFRqa2x32PFNlYqNY7rRk4ITzhyvdiWiZ98/r8
        ftvBicpNakKa6JmdXPoyd4aURPlLqVmp83ZepWh1LvtgEqqXiXmEq2WArbBKvT6P
        wBgcXqUxWybOMXm9awVH0Hd3UIq1SDKHPfFfnMXxeydgS2wdYK5A8WeV+BGyj+jY
        8mW8LQaX46Jau6ie1BbBaF0rTSXTgy3s7lajorxZVmwTvWFCsBvYFvnZY0Pb+Qkc
        wXVVZDeUloXKCXNmRHGSamTVjbWIYDVKJ4DNA0hFIEGUFTb50+T2qXa06kXwRt9w
        ykeiNlMbq1TkuiiXT8/F0PHyb7wq4Zg5NEQ==
X-ME-Sender: <xms:wQn9YxCDL11D-rlH1dD18pcxbKql5K3XFBjvhd7bA5l9E0FkhK_pkw>
    <xme:wQn9Y_hJsVfn5xmURXLFPBe2YgDAEeOD_25XgLLiUk2BRScYwpaEYDfAl2Ix_wEU4
    zqKbvtPLYQUsC2yfQ>
X-ME-Received: <xmr:wQn9Y8mm8dZWlnq6Fa0NC5LRThOFTGYiMs19oYpRijeUD66vtYSKqLOoE1q4caIDMCcl20FfLuKVD1EBQKDlbRP1jpwpP4gOGotNm3uFZrgb3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeltddguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdefhedmnecujfgurhephf
    fvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeffrghnihgvlhcuighuuceougig
    uhesugiguhhuuhdrgiihiieqnecuggftrfgrthhtvghrnhepheektdduueeiuefgieeghf
    efvdeugeetiefffefhgfduudefudehveejgedtgedtnecuffhomhgrihhnpehivghtfhdr
    ohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    gugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:wQn9Y7wF7PTb_i_ziNRJCtylz-gFNAsYbrGFivn24Zs_4lse7tcy1w>
    <xmx:wQn9Y2QdOeNqnyIToFbBusGkv58mwr9Rzmuw2RY-Iomiacilmb90Pg>
    <xmx:wQn9Y-b3z2ArS2Oqzoyvs_o5QNZMEWbLopUrKGz1navR0GFJ0ut1qg>
    <xmx:wQn9Y0c0rTnsOvMy0vn8Wp0klcBq_Wz6LWjMMlfDiO-N-_n7GI_ziA>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Feb 2023 14:51:28 -0500 (EST)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 0/8] Support defragmenting IPv(4|6) packets in BPF
Date:   Mon, 27 Feb 2023 12:51:02 -0700
Message-Id: <cover.1677526810.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

Fortunately, the kernel has robust support for fragmented IP packets.
This patchset wraps the existing defragmentation facilities in kfuncs so
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

===

Changes from v1:
* Add support for ipv6 defragmentation


Daniel Xu (8):
  ip: frags: Return actual error codes from ip_check_defrag()
  bpf: verifier: Support KF_CHANGES_PKT flag
  bpf, net, frags: Add bpf_ip_check_defrag() kfunc
  net: ipv6: Factor ipv6_frag_rcv() to take netns and user
  bpf: net: ipv6: Add bpf_ipv6_frag_rcv() kfunc
  bpf: selftests: Support not connecting client socket
  bpf: selftests: Support custom type and proto for client sockets
  bpf: selftests: Add defrag selftests

 Documentation/bpf/kfuncs.rst                  |   7 +
 drivers/net/macvlan.c                         |   2 +-
 include/linux/btf.h                           |   1 +
 include/net/ip.h                              |  11 +
 include/net/ipv6.h                            |   1 +
 include/net/ipv6_frag.h                       |   1 +
 include/net/transp_v6.h                       |   1 +
 kernel/bpf/verifier.c                         |   8 +
 net/ipv4/Makefile                             |   1 +
 net/ipv4/ip_fragment.c                        |  15 +-
 net/ipv4/ip_fragment_bpf.c                    |  98 ++++++
 net/ipv6/Makefile                             |   1 +
 net/ipv6/af_inet6.c                           |   4 +
 net/ipv6/reassembly.c                         |  16 +-
 net/ipv6/reassembly_bpf.c                     | 143 ++++++++
 net/packet/af_packet.c                        |   2 +-
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../selftests/bpf/generate_udp_fragments.py   |  90 +++++
 .../selftests/bpf/ip_check_defrag_frags.h     |  57 +++
 tools/testing/selftests/bpf/network_helpers.c |  26 +-
 tools/testing/selftests/bpf/network_helpers.h |   3 +
 .../bpf/prog_tests/ip_check_defrag.c          | 327 ++++++++++++++++++
 .../selftests/bpf/progs/bpf_tracing_net.h     |   1 +
 .../selftests/bpf/progs/ip_check_defrag.c     | 133 +++++++
 24 files changed, 931 insertions(+), 21 deletions(-)
 create mode 100644 net/ipv4/ip_fragment_bpf.c
 create mode 100644 net/ipv6/reassembly_bpf.c
 create mode 100755 tools/testing/selftests/bpf/generate_udp_fragments.py
 create mode 100644 tools/testing/selftests/bpf/ip_check_defrag_frags.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ip_check_defrag.c
 create mode 100644 tools/testing/selftests/bpf/progs/ip_check_defrag.c

-- 
2.39.1

