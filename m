Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B7459A950
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 01:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244061AbiHSXXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 19:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240729AbiHSXXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 19:23:52 -0400
Received: from wnew1-smtp.messagingengine.com (wnew1-smtp.messagingengine.com [64.147.123.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10CB2B1A8;
        Fri, 19 Aug 2022 16:23:47 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 9913C2B06110;
        Fri, 19 Aug 2022 19:23:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 19 Aug 2022 19:23:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1660951423; x=1660958623; bh=vaTSG05Oe5brZjsN/lc56bgcP
        NiJn+EXrdb3FooQzBs=; b=ssANHNRf5MIr3SOYvNVB1lFPtyl/oiIoVJPxROgFM
        leYZDGf6Tpnb3WIczwHhc3Wkk0K6LWOku5aSB3N9AaQYkg53fcOZMmN6kl1tXdug
        sXpeIE9tqI1QYbusxRXYkg1T8Bf+oC0BVH+SYH0AqHxebhUzg7tcmPH6NmL/1CIk
        uDXZefi850el+c13J9CECkxRQ6Rewi2DyFAVOemZjarOsbdysyRZOXYmXqnbLWZq
        dBagBz9n4onWDE/CKbgvnceSLvrY25ynvzdzS7ALoYLRxQ/A5BZaLC4qhNoG+gIu
        ZFa+QJUAwPIaY7pznl/cWAarNwKCWJ8XVqec8HJJxAHuw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1660951423; x=1660958623; bh=vaTSG05Oe5brZjsN/lc56bgcPNiJn+EXrdb
        3FooQzBs=; b=knRthTcys4++dFpnjdl1YxB9fmWCR5yol3St8YxNavxVSWsHAWK
        po5XRojhFU2zKhT3PqRG1a+AIMdrwIgulBiWnpQWeMSmHHdFRoyn2xDv9jPBMMCo
        4N/TdIqCVdn14CDuLMoQO/kICCnztL42cy/JGP94zam2OXuiNIijKVj3aE8q3c4d
        8xRp3GTD6X5Wx4PcCGHlXA74P7l1VgLsSwYWKUNWQjIz1nRVDz7jLVhKHuD/iTlX
        /jHO875pL+Erehtm1qN/u3UwNkBGBTaQH0nCEHAxE001f1kgNN6RTuMiKRWlymrO
        lrn6xToJF0ruF1u8fQWAH086z5rESwYZj3w==
X-ME-Sender: <xms:fhsAYxgJxCsZiptrHiE46YMH7orGKg-3ptX4lFiBjapC8ytM44YkXA>
    <xme:fhsAY2CLuTyb4A0-aCJPZN3kg5E_QCxCLv2Q14qoX0H1af26Y40xL8lVC67fyWIyj
    LKI6wHB1blDmrfDWg>
X-ME-Received: <xmr:fhsAYxHwGEKX6QlH_nhJS2DlM7bQ6hQl2Qr5BFAgVNAsP-Pu-JFRXoZ8Jfnm2yjT9kOUNO7U_KvlH5uxTmn1bbOOswUcK1W0Uf2y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeivddgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfeehmdenogevohgrshhtrg
    hlqdfhgeduvddqtddvucdludehtddmnecujfgurhephffvvefufffkofgggfestdekredt
    redttdenucfhrhhomhepffgrnhhivghlucgiuhcuoegugihusegugihuuhhurdighiiiqe
    enucggtffrrghtthgvrhhnpeetueektdeuhfefvefggfevgeffgfekfefhkeekteffheev
    tddvhedukeehffeltdenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdr
    giihii
X-ME-Proxy: <xmx:fhsAY2Tp3N4GTR0MfWGWwBTgsz1pM4P8-QZvFzsNnOZI2yJWOQ4y-g>
    <xmx:fhsAY-z7MnrUJWYqxZM7zsQ9lkNhEcMV9UOLX6SBmiaCZCHnM5z9xQ>
    <xmx:fhsAY87ngTwkFg9EOyURHKitONnuv5UjBxgnPflmi6hDzHWnf1ePXg>
    <xmx:fxsAYw6Kueg709GqHYEkEzuNmY-9RZfMZ_GSCr1cCZauZwJdiG3VbA45ZEs>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Aug 2022 19:23:41 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3 0/5] Support direct writes to nf_conn:mark
Date:   Fri, 19 Aug 2022 17:23:29 -0600
Message-Id: <cover.1660951028.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        FROM_SUSPICIOUS_NTLD_FP,PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support direct writes to nf_conn:mark from TC and XDP prog types. This
is useful when applications want to store per-connection metadata. This
is also particularly useful for applications that run both bpf and
iptables/nftables because the latter can trivially access this metadata.

One example use case would be if a bpf prog is responsible for advanced
packet classification and iptables/nftables is later used for routing
due to pre-existing/legacy code.

Past discussion:
- v2: https://lore.kernel.org/bpf/CAP01T74Sgn354dXGiFWFryu4vg+o8b9s9La1d9zEbC4LGvH4qg@mail.gmail.com/T/
- v1: https://lore.kernel.org/bpf/cover.1660592020.git.dxu@dxuuu.xyz/

Changes since v2:
- Remove use of NOT_INIT for btf_struct_access write path
- Disallow nf_conn writing when nf_conntrack module not loaded
- Support writing to nf_conn___init:mark

Changes since v1:
- Add unimplemented stub for when !CONFIG_BPF_SYSCALL

Daniel Xu (5):
  bpf: Remove duplicate PTR_TO_BTF_ID RO check
  bpf: Add stub for btf_struct_access()
  bpf: Use 0 instead of NOT_INIT for btf_struct_access() writes
  bpf: Add support for writing to nf_conn:mark
  selftests/bpf: Add tests for writing to nf_conn:mark

 include/linux/bpf.h                           |  9 +++
 include/net/netfilter/nf_conntrack_bpf.h      | 13 ++++
 kernel/bpf/verifier.c                         |  3 -
 net/core/filter.c                             | 50 +++++++++++++++
 net/ipv4/bpf_tcp_ca.c                         |  2 +-
 net/netfilter/nf_conntrack_bpf.c              | 64 ++++++++++++++++++-
 net/netfilter/nf_conntrack_core.c             |  1 +
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  2 +
 .../testing/selftests/bpf/progs/test_bpf_nf.c |  9 ++-
 .../selftests/bpf/progs/test_bpf_nf_fail.c    | 14 ++++
 10 files changed, 160 insertions(+), 7 deletions(-)

-- 
2.37.1

