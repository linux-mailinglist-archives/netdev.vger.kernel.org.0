Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBC9B4F43
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 15:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbfIQNbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 09:31:42 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:41901 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728389AbfIQNbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 09:31:38 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id B201539D1;
        Tue, 17 Sep 2019 09:31:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 17 Sep 2019 09:31:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        from:to:cc:subject:date:message-id:in-reply-to:references
        :mime-version:content-transfer-encoding; s=fm1; bh=dX7odFuYQlYRo
        aazX3l6kQgfWSrUlRAtCfmm0Llb/vo=; b=nhdSIJ0BeLlEZ4IIlAAQjRPlf21HP
        ZO+QN0BRkv/FA5Z/+tCwmE4nP5oNfJJ5P4S7tpQdbbU5BwItnwv807Y7cPaFb+yd
        ceurAaROCn59+sG5mibqkxbYmwo1QKHbmExMbCBHXqTYDln2iT/oApReJWdWlJTR
        RBZ04cZ2R0v+wPCdajvqbarV7nMzxPTXciKLEoLV0ap7QzbWcjY0wEckGJgZNbtK
        GS9qAtZGfRdubQY9DlW09fle0oocDDKRi15LRE2RH1ixX1kL8VUO1i51UmLUHOk4
        2/XtfxEOhLkt5OgFQkaneSz4dHUizP0heqNJvBu480izoGonOHLEnpYJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=dX7odFuYQlYRoaazX3l6kQgfWSrUlRAtCfmm0Llb/vo=; b=uQIYOeZi
        uh1IdMphoAoUceTANPz/IybEQhFKSFTxEXks46G5RhEts7Nk7loSMWEB7oKfsvG3
        j5VSNdA++TSlHQk4sSyvMp9Hg+pBfZ79vFSVF9nMQMKm+QAXqbscpmmX9Dli6Sem
        R5+edUug9h9u5sbdQz9kwIDPRi1w+A2ZK6beP5lHDMHBpQqjKMdS5v4aCxBUeIoa
        EheK/EbdIYIVJxOqSqM01PamTst8SmrSwHakV6dWFGtLw0NDUJc5CvQpyK8cTeX3
        2+Plc2D+b3qCsNoPpG54gNOl4HS+4RfunWuW4WAVM+PWg3wmBIKymjFjvNlep8XY
        BkkQ2nCxaBWiYg==
X-ME-Sender: <xms:OOCAXVy-_eRR0a_dt70IyIT9up3kDxlhG5aU-eAoMa1cEX4tLjpGOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeigdefkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephffvuf
    ffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffrghnihgvlhcuighuuceougig
    uhesugiguhhuuhdrgiihiieqnecukfhppeduleelrddvtddurdeiiedrtdenucfrrghrrg
    hmpehmrghilhhfrhhomhepugiguhesugiguhhuuhdrgiihiienucevlhhushhtvghrufhi
    iigvpedu
X-ME-Proxy: <xmx:OOCAXWzRp3-k-UJbJ98QSE3h6hsVHo46LRiIZRg3WM4cyvWdei4oXQ>
    <xmx:OOCAXX_BQ4164hswctjllb2J1UhGsGs2Ys205hRwU6OujTVNUvDjtA>
    <xmx:OOCAXZiPHs5gAUMdcK4-IMwVmO43t4kKjtymPeRnl3iOshLWRpl8_w>
    <xmx:OOCAXTJ4lzw1WG5_G4mZhBifELbXGp-noBiTv_lVE_lGFBo-FA29zB8F0R8>
Received: from dlxu-fedora-R90QNFJV.thefacebook.com (unknown [199.201.66.0])
        by mail.messagingengine.com (Postfix) with ESMTPA id 40AE4D6005A;
        Tue, 17 Sep 2019 09:31:35 -0400 (EDT)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     bpf@vger.kernel.org, songliubraving@fb.com, yhs@fb.com,
        andriin@fb.com, peterz@infradead.org, mingo@redhat.com,
        acme@kernel.org
Cc:     Daniel Xu <dxu@dxuuu.xyz>, ast@fb.com,
        alexander.shishkin@linux.intel.com, jolsa@redhat.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH bpf-next 5/5] libbpf: Add selftest for PERF_FORMAT_LOST perf read_format
Date:   Tue, 17 Sep 2019 06:30:56 -0700
Message-Id: <20190917133056.5545-6-dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190917133056.5545-1-dxu@dxuuu.xyz>
References: <20190917133056.5545-1-dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 .../selftests/bpf/prog_tests/attach_probe.c   | 32 ++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
index 5ecc267d98b0..3d636cccb6dc 100644
--- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
+++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
@@ -1,6 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
 
+struct perf_read_output {
+	u64 count;
+	u64 lost;
+};
+
 ssize_t get_base_addr() {
 	size_t start;
 	char buf[256];
@@ -32,6 +37,8 @@ void test_attach_probe(void)
 	const char *file = "./test_attach_probe.o";
 	struct bpf_program *kprobe_prog, *kretprobe_prog;
 	struct bpf_program *uprobe_prog, *uretprobe_prog;
+	struct perf_read_output kprobe_read_output;
+	const struct bpf_link_fd *kprobe_fd_link;
 	struct bpf_object *obj;
 	int err, prog_fd, duration = 0, res;
 	struct bpf_link *kprobe_link = NULL;
@@ -40,7 +47,8 @@ void test_attach_probe(void)
 	struct bpf_link *uretprobe_link = NULL;
 	int results_map_fd;
 	size_t uprobe_offset;
-	ssize_t base_addr;
+	ssize_t base_addr, nread;
+	int kprobe_fd;
 
 	base_addr = get_base_addr();
 	if (CHECK(base_addr < 0, "get_base_addr",
@@ -116,6 +124,28 @@ void test_attach_probe(void)
 	/* trigger & validate kprobe && kretprobe */
 	usleep(1);
 
+	kprobe_fd_link = bpf_link__as_fd(kprobe_link);
+	if (CHECK(!kprobe_fd_link, "kprobe_link_as_fd",
+		  "failed to cast link to fd link\n"))
+		goto cleanup;
+
+	kprobe_fd = bpf_link_fd__fd(kprobe_fd_link);
+	if (CHECK(kprobe_fd < 0, "kprobe_get_perf_fd",
+	    "failed to get perf fd from kprobe link\n"))
+		goto cleanup;
+
+	/* Set to unexpected value so we can check the read(2) did stuff */
+	kprobe_read_output.lost = 1;
+	nread = read(kprobe_fd, &kprobe_read_output,
+		     sizeof(kprobe_read_output));
+	if (CHECK(nread != sizeof(kprobe_read_output), "kprobe_perf_read",
+		  "failed to read from perf fd\n"))
+		goto cleanup;
+	if (CHECK(kprobe_read_output.lost != 0, "kprobe_lost",
+		  "read wrong value from perf fd: %lu\n",
+		  kprobe_read_output.lost))
+		goto cleanup;
+
 	err = bpf_map_lookup_elem(results_map_fd, &kprobe_idx, &res);
 	if (CHECK(err, "get_kprobe_res",
 		  "failed to get kprobe res: %d\n", err))
-- 
2.21.0

