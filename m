Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCFF590865
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 23:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236101AbiHKV4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 17:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236042AbiHKVz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 17:55:56 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC85C20BDF;
        Thu, 11 Aug 2022 14:55:53 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 773893200A05;
        Thu, 11 Aug 2022 17:55:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 11 Aug 2022 17:55:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1660254951; x=1660341351; bh=sg
        5b+/j0A+B7rjKnhD+KLFGAzejd8BtlBZDJhVZA0vg=; b=fR6ErGPn+X+wO5iT1T
        dUXXFLWZ/sQcnlC68cmqmBhfz885IuO84Ct+rIpiM6QfB+rmEmcY/1ScodmNZF85
        Xhu/QIbd+NQ4mgj0S5/puTG966TED8GCZFcblzjcWkm9PX0pzhfJWI9blfQjRaGO
        ta9B1BAJXRhuNgkE0GX8G7OZkOfLZhDyCbEnOiomN5mIyQmEvTklHY9FAnJ25h3q
        6ajV7wXBhwEUeNAZSpGG0vNhvpTsWWE36dZMfeiHIaK1kFC+7yTzAyF3Zpp6u6d7
        IupjpMkkwI8TXQGcNW01H5tI/1jD1j3v9liv5osWx6Nzqk0jinhEfixdjKlB1Suj
        QdAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1660254951; x=1660341351; bh=sg5b+/j0A+B7r
        jKnhD+KLFGAzejd8BtlBZDJhVZA0vg=; b=5XBVbo+Gdd8r6Uyf8BDIHlAj261E6
        PEUq1xxSjkzeyuKjC7a9xMcq+IvOryHKRN0TnEF+DGv8NzbMFIM0g2LoHnnp1A7g
        lwEOiYflX3TnjPuTE9rX0965OcTzKsj3iry564IKwwRq6NehUdL8zPvq07sKEpMw
        l1Tp6K8B9XizD9Wvyszt9w/uQKeQ1/MEGI0eFDVQPJhB/w2AOAK6YAWzsakvWRCN
        cTWmle8Xfvcn70QL7QpeyDbNLrnu2aT8n1GYDew+tAaIB8e+AaLh5v96LnLqgqOA
        VxO5n5DM6To5jZXjkZIDw3Q4dbhgtOCf+5k5UqOy8I8j2WcJqkLxsWpfA==
X-ME-Sender: <xms:53r1Yi7r9Ed1QVMIXSL0JcgLiSsGC8zw8BPyDnUekdrZBTc0ke93tw>
    <xme:53r1Yr6S8ajMfSOUIkiKPZVcMIMW01aO23I7-UyT3wtU8zmxarl8jimNMaJk0wZf9
    vKMIZjo2ZeHVhR7Fw>
X-ME-Received: <xmr:53r1YheHOvssNFHRQwdv_Y6mO73cXZC_rQg8fbN_D7_vsn_EAF6Nm_KPj--nfWa-j45nFfRGIQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeghedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfeehmdenucfjughrpefhvf
    evufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghnihgvlhcuighuuceo
    ugiguhesugiguhhuuhdrgiihiieqnecuggftrfgrthhtvghrnhepgfefgfegjefhudeike
    dvueetffelieefuedvhfehjeeljeejkefgffeghfdttdetnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdrgiihii
X-ME-Proxy: <xmx:53r1YvKaYU2Ba6S8qE9imCsjsuABMxLLRuX24U5Y_n3v4mQUZ8FosA>
    <xmx:53r1YmIpIJPlzmaQV4-uWldR_Y_RwgpZ7AcCTHjtv9tHUAac8WsuyQ>
    <xmx:53r1YgxHHi3n3kSFlSi5YS4f0Hp1c63FSj2u1DEcpOrPizB41w_uzA>
    <xmx:53r1YjVcu3vLbwXpdu5fHm8JN9Uf-O2jRBbhfZSGSoeAMR_A3TsTDQ>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 11 Aug 2022 17:55:50 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v4 3/3] selftests/bpf: Update CI kconfig
Date:   Thu, 11 Aug 2022 15:55:27 -0600
Message-Id: <2c27c6ebf7a03954915f83560653752450389564.1660254747.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1660254747.git.dxu@dxuuu.xyz>
References: <cover.1660254747.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous selftest changes require two kconfig changes in bpf-ci.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/config | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index fabf0c014349..3fc46f9cfb22 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -50,9 +50,11 @@ CONFIG_NET_SCHED=y
 CONFIG_NETDEVSIM=m
 CONFIG_NETFILTER=y
 CONFIG_NETFILTER_SYNPROXY=y
+CONFIG_NETFILTER_XT_CONNMARK=y
 CONFIG_NETFILTER_XT_MATCH_STATE=y
 CONFIG_NETFILTER_XT_TARGET_CT=y
 CONFIG_NF_CONNTRACK=y
+CONFIG_NF_CONNTRACK_MARK=y
 CONFIG_NF_DEFRAG_IPV4=y
 CONFIG_NF_DEFRAG_IPV6=y
 CONFIG_RC_CORE=y
-- 
2.37.1

