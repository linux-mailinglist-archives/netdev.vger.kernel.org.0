Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4F25975EA
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 20:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241217AbiHQSnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 14:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240974AbiHQSnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 14:43:31 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33185FEE;
        Wed, 17 Aug 2022 11:43:17 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 355555C0180;
        Wed, 17 Aug 2022 14:43:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 17 Aug 2022 14:43:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1660761796; x=1660848196; bh=jdo+e+0Bg4eiX19+TskCBEv6l
        gk9aqZm7MX54jqJxcU=; b=tpkSLIwCX8n2WaO9TdHjNYfChpm/5FcyKvBJLWrm9
        A1ok251C65D1UDZDAVKLprAivuBc+jp321ezOGQhPzw7ohTLEi3lkFOySIGydPIC
        54OGirmUv5Zoguy3+99R2wfc5ud8sHClCqwKRx+D+OUSQfaSoElAlp3CZp4XzzlQ
        TcSTQPvdwMrmIu7L6FuHFZlDTE44ltFq3CfrlKrCyBjgzi+WO2jJaNJuxC+vE+2f
        LqN2f4lqy6wTifiPNXFAnlsUt40m8cuw0IlbJtKZRjtjW126QUP1uMJ/tzfmUooh
        IigDOSJiufsN2c3bryiI6ty7TI5ov5XSAPd87hiRlf4gQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1660761796; x=1660848196; bh=jdo+e+0Bg4eiX19+TskCBEv6lgk9aqZm7MX
        54jqJxcU=; b=RmC27Scg7eEXx3KQVry4BBq/20JQXG2jPpodn7kWim6PRGCy+dm
        L+LmirRDyPLNAQLCjB6fn/WGTMfq7S32LmYXx8Shz9++8GCd/nNvNc/Hc2oEfwk5
        Ujze5DhvnE2uErGuHOAriRJst9zFihf/h0xAMlczFDSCBvslJPxT2YGPd+TzrzmI
        3M0MXeQwb8GjrN3wVu1kb+k+Pb4lgLWwWG1Ph9GeWFz1Xl+KBIevVMTfovdjcquK
        /t4bRE9h8KCRGCryEanGf8x6nNV76MaOEC+GrkzZT3Pl4zNKrdPHu028JKdt9cIh
        83Qc8CvY3nV8jRZHgqbUTTIr5fGO/uS78iA==
X-ME-Sender: <xms:xDb9YvhRecJHIja9Wj-GnD507BftfBaYRXEKVDVYoCjAU6DOztgONA>
    <xme:xDb9YsDS4rU1MwBEwsgyrJZzq889XUaWk4urwvtYkrNOH-5gnsIzZ9tD0mzyDSq87
    rWiJDL-IrsTrnl8rQ>
X-ME-Received: <xmr:xDb9YvGTTPs88huJ_PwU_odZdWwXcemYilyU7UiNprDhTcQ0zow3fzMiH-0yDD3HmbG6pkxCvrIJgkVe-ylIaaX3fhgY3LXve0KO>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehiedgudeftdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdefhedmnecujfgurhephf
    fvvefufffkofgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcuoegu
    gihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpeetueektdeuhfefvefggf
    evgeffgfekfefhkeekteffheevtddvhedukeehffeltdenucffohhmrghinhepkhgvrhhn
    vghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepugiguhesugiguhhuuhdrgiihii
X-ME-Proxy: <xmx:xDb9YsTvlHEKGW9KGsJEsmCjvIwRQVTQ6q0wtxCMg60oCZX8aNdPzA>
    <xmx:xDb9Yszyx2ihUaO3DR0UrrJVqupxJryPwqDzOFpOZnxB53lJZg_pSg>
    <xmx:xDb9Yi5FPH6eX-djY7xwB_IUMJqWTy1BpALmyuCHK0_W6ozXK2NWWw>
    <xmx:xDb9YhrQgD_rOhBj__CFlNou_aGDFoMTLDThljcRjgtGZWqbbZ655Q>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 17 Aug 2022 14:43:15 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        toke@kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v2 0/4] Support direct writes to nf_conn:mark
Date:   Wed, 17 Aug 2022 12:42:58 -0600
Message-Id: <cover.1660761035.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        FROM_SUSPICIOUS_NTLD_FP,PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
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
- v1: https://lore.kernel.org/bpf/cover.1660592020.git.dxu@dxuuu.xyz/

Changes since v1:
- Add unimplemented stub for when !CONFIG_BPF_SYSCALL

Daniel Xu (4):
  bpf: Remove duplicate PTR_TO_BTF_ID RO check
  bpf: Add stub for btf_struct_access()
  bpf: Add support for writing to nf_conn:mark
  selftests/bpf: Add tests for writing to nf_conn:mark

 include/linux/bpf.h                           |  9 ++++
 include/net/netfilter/nf_conntrack_bpf.h      | 18 +++++++
 kernel/bpf/verifier.c                         |  3 --
 net/core/filter.c                             | 34 +++++++++++++
 net/netfilter/nf_conntrack_bpf.c              | 50 +++++++++++++++++++
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  1 +
 .../testing/selftests/bpf/progs/test_bpf_nf.c |  6 ++-
 .../selftests/bpf/progs/test_bpf_nf_fail.c    | 14 ++++++
 8 files changed, 130 insertions(+), 5 deletions(-)

-- 
2.37.1

