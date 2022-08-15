Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23124594440
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 00:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346814AbiHOWCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 18:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350175AbiHOWBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 18:01:53 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0F7112FB9;
        Mon, 15 Aug 2022 12:36:10 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 2F8FB5C012D;
        Mon, 15 Aug 2022 15:36:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 15 Aug 2022 15:36:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1660592162; x=1660678562; bh=DNdw0j1TNN+ttmL1Ka7ho+2gv
        Y2WjWAZUT+c7H7rzqU=; b=RodAOIGAhqLLlqeYqORk44XOWjF1OWeuc5D1VMEWM
        EkMC3eUi+bsKfqg1zm3z6OWoum80cIX3lghOplkMrE6N8RFLJk8xsen9+G931dUG
        rG9AZa19SBA4YXhO43KCii5/xYxCgy1HbUHcvZEzui1RJqJoB6J9Qoy57nSrQWOV
        m1UwDbmQns3q1j07RRECMY2WV3lIoEPGkTVcXpJ+TBBC/W/kWWRPLM2ERspCvohv
        Yu5SGrE6GDS2RWchOiTyLqdcx0QIdmDl5ff5TqNQHoCnCQZqV0Rx5VJZ7VEynhXu
        MvclqllvQ5YkPIw6sz3VNZbKOqfbJCLytavbaslN5CXNg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1660592162; x=1660678562; bh=DNdw0j1TNN+ttmL1Ka7ho+2gvY2WjWAZUT+
        c7H7rzqU=; b=fK9aE9yOEgbddZ9PS0h4B8avf1ld4C/7wIaJrfiwTEGk+UJLcla
        swwEsLLxiMPMazbwiiNDFtaz67aDzpKdxKzpT66NFNLP9ujk7OHopwJTNjl1BOr+
        eOqd2nD3+QdRZVGSZQqvbpZXas2tUdzCTZQQdJbFeDWUTWMOa3QQ8pTywXZUXkjj
        bihlm4rpb6cHuOft9kMuF0gJtPJmPNjOKgcKz0aP+EOQeuF24OH7hph8XFEu+GkM
        IsVqOVLfKah4LmcHnE/SbQH1MpdJNRu2PIwY2A7GWsMhwidbJdlnU0C5GMmjWaAU
        37u65ENo1uYlIQZdhZyeohlKGMA7sWj3GOA==
X-ME-Sender: <xms:IaD6YvR9T9igMeY6R5BTc-DCXLNcdIAniqH04D-GjYu32Ihv7llqaQ>
    <xme:IaD6Ygz154Gp7Xmd7i-O2KnJOzFRu1eoKEuBSayHIM-WHja3tVqMDB3ztTMTw4u7Z
    MP494iZcHdkjP3TIQ>
X-ME-Received: <xmr:IaD6Yk12XPyi7R-4FLCssOkpz3Tj6g1ZAjtB9YAEB89cfcsyDMKexkTaRElLmYxCPM3MieZo4wQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehvddgudegudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcuoegu
    gihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpedvgefgtefgleehhfeufe
    ekuddvgfeuvdfhgeeljeduudfffffgteeuudeiieekjeenucevlhhushhtvghrufhiiigv
    pedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:IaD6YvD4hp8mezAGDamjoAKG43UkTdSrkmyjo5g-Fw3066fSiN3oGw>
    <xmx:IaD6YohiowkawBZwduAk7NqU894eDTXK380YQNBKk7rg5NPbusLtNg>
    <xmx:IaD6YjrAXSvmrbVEezLTtZ3n1Lwc4S6xuzHeEXgamd42Wjh800zsFg>
    <xmx:IqD6YrM1DHk3MhjV9t3-5iSDRptr0mHGYe6x4m0m8s_Wgv7z5pJhEQ>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Aug 2022 15:36:00 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 0/3] Support direct writes to nf_conn:mark
Date:   Mon, 15 Aug 2022 13:35:45 -0600
Message-Id: <cover.1660592020.git.dxu@dxuuu.xyz>
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

Daniel Xu (3):
  bpf: Remove duplicate PTR_TO_BTF_ID RO check
  bpf: Add support for writing to nf_conn:mark
  selftests/bpf: Add tests for writing to nf_conn:mark

 include/net/netfilter/nf_conntrack_bpf.h      | 18 +++++++
 kernel/bpf/verifier.c                         |  3 --
 net/core/filter.c                             | 34 +++++++++++++
 net/netfilter/nf_conntrack_bpf.c              | 50 +++++++++++++++++++
 .../testing/selftests/bpf/prog_tests/bpf_nf.c |  1 +
 .../testing/selftests/bpf/progs/test_bpf_nf.c |  6 ++-
 .../selftests/bpf/progs/test_bpf_nf_fail.c    | 14 ++++++
 7 files changed, 121 insertions(+), 5 deletions(-)

-- 
2.37.1

