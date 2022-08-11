Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 676C5590863
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 23:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235970AbiHKV4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 17:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235990AbiHKVzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 17:55:51 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD6112D39;
        Thu, 11 Aug 2022 14:55:50 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 142783200A1B;
        Thu, 11 Aug 2022 17:55:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 11 Aug 2022 17:55:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1660254948; x=1660341348; bh=Vy
        Wam4ZjM8njlCnS3BXL5bEgLOhsnf/G0sxqVGspLvM=; b=txnZHDWwr9UFbb/ON2
        w7UiPxIEtVrIEXJDyfuSxQY25lc/3qwsACz8QqXIj3078LY4MjrGgw8e0hSpgGIW
        Uy9dmFSGXS9ggNXO8kzjkwyRLg+278yKnF4VL9Z+jdIubBEx+bvlfu4okZZz+pL1
        3uRspaXP6EoCxe2DPfQMAurt/qUxA8wctdassvooOOpy0oM+bQBXnI9iAsQPw9ug
        pUBigvZEhnwtwZ2olFzax3flGGLVXsHmCwlKk6EsjQIfO3T8yyX6RnFIDi1zwoZJ
        E+rdx0jxcXJM+0CdygyJXuoUvoqjr11Xpph7UzPzi5eUJ/Ko2WCnT+5nTw3Nq9l+
        sbIg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1660254948; x=1660341348; bh=VyWam4ZjM8njl
        CnS3BXL5bEgLOhsnf/G0sxqVGspLvM=; b=Hp+SVAOm/icivOlVkRihNfXPRIdz5
        2tVZssRSX+Qieeg4CxfjDrDneHOY1gHj32FuyChhc+iMK8HHAW0eyRcqCEBdB0N8
        55hvKgCvPlp7DcANxfGWQRqStLocc7fdR/ZckhLuJuBkKVYmunUPenfYEddYLjfH
        s8+X7xZzb4mV++Vc3rV6iN/W8GNl7e5u5gbYvIqq/uroN7aOAq25CTw2tbukBf6q
        b3yY6BP1J9S8xJTSDjwzkMgRdVN6NfumeAQZy3ynv9Jkd9YA2/2I+Nenh5qrlGSr
        aHK2yMmmxhqDFOHY68X4PcoT1FatgG5OmuHT1pPrZaG04sEJ/lnbsgFiA==
X-ME-Sender: <xms:5Hr1YtGLyO1Gs2cD18ECU-bM7xY7PSCcxQwUGzbwlkkaqadKUsLTPg>
    <xme:5Hr1YiVqo9bim2O9p--welxtuHME_Mh-3SIW_ImOeGU1ZoYHV9d4gkqrFPi_ziz7Z
    QrwTmqyMTKxH54j4g>
X-ME-Received: <xmr:5Hr1YvLHbRyq1RonLWIS-yaYBxTsY6MaYRkWxwmr58NgUwjUwUAVcCH_o_joh0Z2YJmUgh1a8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeghedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdlfeehmdenucfjughrpefhvf
    evufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghnihgvlhcuighuuceo
    ugiguhesugiguhhuuhdrgiihiieqnecuggftrfgrthhtvghrnhepgfefgfegjefhudeike
    dvueetffelieefuedvhfehjeeljeejkefgffeghfdttdetnecuvehluhhsthgvrhfuihii
    vgeptdenucfrrghrrghmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdrgiihii
X-ME-Proxy: <xmx:5Hr1YjH6XDCHfop9fzYOxm95_eh6e2Ab5EAyhHMiINTlKkJXmtrUDA>
    <xmx:5Hr1YjVRzn8nzgzjcXeGC6c6HUisbgWfi9X6VyqaRNc4Fw9AyQ6T1g>
    <xmx:5Hr1YuPNkBtGUYtRP3f9Xhe20d8WVNfHRuT-HjZQxc1Ywd9osnVHIg>
    <xmx:5Hr1YjQJ2dyg6gvmOTQB6q0sto8QY8JdgLq0qEhoe0h60-ODIg7jag>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 11 Aug 2022 17:55:46 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com
Cc:     Daniel Xu <dxu@dxuuu.xyz>, pablo@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v4 2/3] selftests/bpf: Add connmark read test
Date:   Thu, 11 Aug 2022 15:55:26 -0600
Message-Id: <d3bc620a491e4c626c20d80631063922cbe13e2b.1660254747.git.dxu@dxuuu.xyz>
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

Test that the prog can read from the connection mark. This test is nice
because it ensures progs can interact with netfilter subsystem
correctly.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c | 3 ++-
 tools/testing/selftests/bpf/progs/test_bpf_nf.c | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
index 88a2c0bdefec..544bf90ac2a7 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_nf.c
@@ -44,7 +44,7 @@ static int connect_to_server(int srv_fd)
 
 static void test_bpf_nf_ct(int mode)
 {
-	const char *iptables = "iptables -t raw %s PREROUTING -j CT";
+	const char *iptables = "iptables -t raw %s PREROUTING -j CONNMARK --set-mark 42/0";
 	int srv_fd = -1, client_fd = -1, srv_client_fd = -1;
 	struct sockaddr_in peer_addr = {};
 	struct test_bpf_nf *skel;
@@ -114,6 +114,7 @@ static void test_bpf_nf_ct(int mode)
 	/* expected status is IPS_SEEN_REPLY */
 	ASSERT_EQ(skel->bss->test_status, 2, "Test for ct status update ");
 	ASSERT_EQ(skel->data->test_exist_lookup, 0, "Test existing connection lookup");
+	ASSERT_EQ(skel->bss->test_exist_lookup_mark, 43, "Test existing connection lookup ctmark");
 end:
 	if (srv_client_fd != -1)
 		close(srv_client_fd);
diff --git a/tools/testing/selftests/bpf/progs/test_bpf_nf.c b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
index 84e0fd479794..2722441850cc 100644
--- a/tools/testing/selftests/bpf/progs/test_bpf_nf.c
+++ b/tools/testing/selftests/bpf/progs/test_bpf_nf.c
@@ -28,6 +28,7 @@ __be16 sport = 0;
 __be32 daddr = 0;
 __be16 dport = 0;
 int test_exist_lookup = -ENOENT;
+u32 test_exist_lookup_mark = 0;
 
 struct nf_conn;
 
@@ -174,6 +175,8 @@ nf_ct_test(struct nf_conn *(*lookup_fn)(void *, struct bpf_sock_tuple *, u32,
 		       sizeof(opts_def));
 	if (ct) {
 		test_exist_lookup = 0;
+		if (ct->mark == 42)
+			test_exist_lookup_mark = 43;
 		bpf_ct_release(ct);
 	} else {
 		test_exist_lookup = opts_def.error;
-- 
2.37.1

