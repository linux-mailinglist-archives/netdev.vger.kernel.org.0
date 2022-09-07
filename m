Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BECF45B0A49
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 18:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiIGQlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 12:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbiIGQlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 12:41:11 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239806F26A;
        Wed,  7 Sep 2022 09:41:10 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 8594A5C0127;
        Wed,  7 Sep 2022 12:41:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 07 Sep 2022 12:41:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; t=1662568869; x=1662655269; bh=jhqQsUwTJ/JhUxOswmwpIVY0C
        pctlsvZjEdw+jY5K6o=; b=aDo+FlLIcCy3gftvHV8hi5ySaghGPvLZt6SswgVnR
        hnU/mvbZYJo/uJmEkeFiNXIZ+Muas3gqzE5OcpQhzK/3KeDpk84vzi5uvbM0b5ho
        Z8BQePaK5pUD0UEMkIsybFjhr5lff5+qNDVQXVd+bFjBil4aqKzYrYEAqels8oi4
        jMp6rjf6VaOEV/l0THKR3UAoYa3QME/zxSJh3ZbGfPy1V4A0HksxZAZIfcpX2cGI
        MiIsMlU8LndX9LCj9NLy4fFQ209HUS/qqMYf6pqbmCNjplMK2kJvGvhF/eMQVXbj
        4MrdXAL3dDpr0vrGE5UbNqTzWpnCGkbz0kIY+HCEpxmtA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1662568869; x=1662655269; bh=jhqQsUwTJ/JhUxOswmwpIVY0CpctlsvZjEd
        w+jY5K6o=; b=YT/yHc+bUl2oIwCsQSidA0EWN6KDvpsn911WIoqmAPdo9VurtsS
        uluQFOd9x+klCq5qU3ISx8I9qBwzBCHI+oxGCAWgeVt0D2A9Foh0AeZ8VZ+WX7AX
        Hv3NA80rNUdtQC2ViA8/QPSBjo/4GRmTfEkneytlRZNKw64kS+SYHU+aU1tr/yaz
        MfGREcTRQmNFFFAEayx2YuSJFGLXg0+eDG1GlBZEN6yEYeb2Oqy4ktWw1DWk9pPK
        e2GHOd2GeOc6MoGEK/eC/ah0UsVFG7XjRuJh/jQ3BNYxS3ASOQx0D4xffv0I0HnX
        w2gyoVhZatAsoCcsTVxPE89WgRlZnvPez8g==
X-ME-Sender: <xms:pckYY9jFkgfBAlZnd_PWjmKTbYIrHwxpCOAp0N49MjyDfBPJeizyUw>
    <xme:pckYYyBpVBI_iNsfH0L2mPFJMbSBzV_U2Rsfo7yFCxkSukhIdj0mWeuOjaiR9c0-R
    wOQCm2TMO6iCUo0Sw>
X-ME-Received: <xmr:pckYY9HaQ0WWYHPOpahGP_S9ZC7DdhiI36JX8bA4aL076E0NLf138rzaB0ISuEKQy6lFp6U3qiGWa40jf242VFE3v9Q2v6OTNU6cmno>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfedttddguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdefhedmnecujfgurhephf
    fvvefufffkofgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcuoegu
    gihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpeetueektdeuhfefvefggf
    evgeffgfekfefhkeekteffheevtddvhedukeehffeltdenucffohhmrghinhepkhgvrhhn
    vghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepugiguhesugiguhhuuhdrgiihii
X-ME-Proxy: <xmx:pckYYyRdC7BYrzk2w8gQW4NGTDb9qCm7p4k0Ub1sHpzpTae1DnBQLg>
    <xmx:pckYY6zE-HvfVxb3a395GUiV4izUKqSBs3Qrjz0Wjzbxbvmyeeq00g>
    <xmx:pckYY47hFEEc8Fh2PH-y2ieyv6niHW22v3uaT347yq4m1pNYELMTKQ>
    <xmx:pckYY85z_mLH-avW16NI7-w-nRe5dvCFnHFEwySH7MjGs64moS1cRQ>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 7 Sep 2022 12:41:08 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, martin.lau@linux.dev,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v5 0/6] Support direct writes to nf_conn:mark
Date:   Wed,  7 Sep 2022 10:40:35 -0600
Message-Id: <cover.1662568410.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        FROM_SUSPICIOUS_NTLD_FP,PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
- v4: https://lore.kernel.org/bpf/cover.1661192455.git.dxu@dxuuu.xyz/
- v3: https://lore.kernel.org/bpf/cover.1660951028.git.dxu@dxuuu.xyz/
- v2: https://lore.kernel.org/bpf/CAP01T74Sgn354dXGiFWFryu4vg+o8b9s9La1d9zEbC4LGvH4qg@mail.gmail.com/T/
- v1: https://lore.kernel.org/bpf/cover.1660592020.git.dxu@dxuuu.xyz/

Changes since v4:
- Use exported function pointer + mutex to handle CONFIG_NF_CONNTRACK=m
  case

Changes since v3:
- Use a mutex to protect module load/unload critical section

Changes since v2:
- Remove use of NOT_INIT for btf_struct_access write path
- Disallow nf_conn writing when nf_conntrack module not loaded
- Support writing to nf_conn___init:mark

Changes since v1:
- Add unimplemented stub for when !CONFIG_BPF_SYSCALL


Daniel Xu (6):
  bpf: Remove duplicate PTR_TO_BTF_ID RO check
  bpf: Add stub for btf_struct_access()
  bpf: Use 0 instead of NOT_INIT for btf_struct_access() writes
  bpf: Export btf_type_by_id() and bpf_log()
  bpf: Add support for writing to nf_conn:mark
  selftests/bpf: Add tests for writing to nf_conn:mark

 include/linux/bpf.h                           |  9 +++
 include/net/netfilter/nf_conntrack_bpf.h      | 23 +++++++
 kernel/bpf/btf.c                              |  1 +
 kernel/bpf/verifier.c                         |  4 +-
 net/core/filter.c                             | 54 +++++++++++++++
 net/ipv4/bpf_tcp_ca.c                         |  2 +-
 net/netfilter/nf_conntrack_bpf.c              | 66 ++++++++++++++++++-
 net/netfilter/nf_conntrack_core.c             |  1 +
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  2 +
 .../testing/selftests/bpf/progs/test_bpf_nf.c |  9 ++-
 .../selftests/bpf/progs/test_bpf_nf_fail.c    | 14 ++++
 11 files changed, 178 insertions(+), 7 deletions(-)

-- 
2.37.1

