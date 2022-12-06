Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 017C7643F71
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbiLFJKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:10:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234624AbiLFJJ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:09:28 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493FD1E3EE;
        Tue,  6 Dec 2022 01:09:26 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id bx10so22581951wrb.0;
        Tue, 06 Dec 2022 01:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VWLq+wEiMOTs/7YAbkmdB8WeKu8VADnbE/GAHTJhkEo=;
        b=ixg0LLKZp290KNb/cja3zZ5/0DARmFyQZL9p2Z7zBP7NsrIzVSG8MszE14YLwtBpT1
         80wzhLRcsyujfhlaZ8UzIz57HBb/kA9p9KjqmyANSicQ/1Wt9o/EFC0dEJ3A5ZqsmCRb
         g8OozP7w6PoiALgL7qNgxgWdP62a4F06rdBFS5Xp3g3ooj4PbOSE2qLoBYDTGmBScCpZ
         biQTWTRWMVT6cf+XmN+MwPFOgDQ0XQKNdTW77VfGChcwqwBlKnTHRH2gWrBQvx7kEjY+
         Hp2Gt3UTZMKSeDMhE2vT1qhwSL0D1E8ibjW0f7RqmowjXoag96WLE+WssArzrFiWMBEf
         HyRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VWLq+wEiMOTs/7YAbkmdB8WeKu8VADnbE/GAHTJhkEo=;
        b=Aj9fULK2/u6Uo6OP3YZCoXPVGSOnA/oPUOF3ekGBbjxowOTSNtljUusZexpT+maQsC
         e/QykSmIga6mL8cy53/R8oa7eLpdFf+tZjNjdiA8Yn66n5yOD1Qtq5hEw+oy3J4PMakr
         unylmcbR1Ai64IbySencUca4Vf9xRXwvcLQelcT9wvfaD5TOC9mXnhwxr4dZRR2MAaR8
         4BZUZ0T/eWwrr4eYIJgjG9mruNHY8+5SlA8EoK9OJC2svh0IYLvui8eO1muqWpkgYVjR
         TAJXh6TJLh1kP48eNThRZG16SetcPcpzAlDkkraJ6XNhVQBzrkaARpL/pVgqYKGjHY3L
         pjHw==
X-Gm-Message-State: ANoB5pnPgFSF0wWb0NPCci9QfTPA4jhkU4KL/MInX85wd16++YulfprT
        xdGFgxQCTxP1lnO2WhLDEXg=
X-Google-Smtp-Source: AA0mqf77ts/frSQisqqFbfdxZYr6mV4U5USpufaqGlXCGGoqDcJoQ1c+geNedbRN9BH5V9PxzxHUkg==
X-Received: by 2002:adf:d232:0:b0:242:2b3e:4019 with SMTP id k18-20020adfd232000000b002422b3e4019mr16490578wrh.449.1670317764762;
        Tue, 06 Dec 2022 01:09:24 -0800 (PST)
Received: from localhost.localdomain (c-5eea761b-74736162.cust.telenor.se. [94.234.118.27])
        by smtp.gmail.com with ESMTPSA id j23-20020a05600c1c1700b003cf57329221sm25065690wms.14.2022.12.06.01.09.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Dec 2022 01:09:24 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 12/15] selftests/xsk: add test when some packets are XDP_DROPed
Date:   Tue,  6 Dec 2022 10:08:23 +0100
Message-Id: <20221206090826.2957-13-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221206090826.2957-1-magnus.karlsson@gmail.com>
References: <20221206090826.2957-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add a new test where some of the packets are not passed to the AF_XDP
socket and instead get a XDP_DROP verdict. This is important as it
tests the recycling mechanism of the buffer pool. If a packet is not
sent to the AF_XDP socket, the buffer the packet resides in is instead
recycled so it can be used again without the round-trip to user
space. The test introduces a new XDP program that drops every other
packet.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/Makefile          |  2 +-
 .../selftests/bpf/progs/xsk_xdp_drop.c        | 25 ++++++++++
 tools/testing/selftests/bpf/xskxceiver.c      | 48 +++++++++++++++++--
 tools/testing/selftests/bpf/xskxceiver.h      |  3 ++
 4 files changed, 72 insertions(+), 6 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/xsk_xdp_drop.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 42e15b5a34a7..77ef8a8e6db4 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -240,7 +240,7 @@ $(OUTPUT)/flow_dissector_load: $(TESTING_HELPERS)
 $(OUTPUT)/test_maps: $(TESTING_HELPERS)
 $(OUTPUT)/test_verifier: $(TESTING_HELPERS) $(CAP_HELPERS)
 $(OUTPUT)/xsk.o: $(BPFOBJ)
-$(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o $(OUTPUT)/xsk_def_prog.skel.h
+$(OUTPUT)/xskxceiver: $(OUTPUT)/xsk.o $(OUTPUT)/xsk_def_prog.skel.h $(OUTPUT)/xsk_xdp_drop.skel.h
 
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
 $(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)    \
diff --git a/tools/testing/selftests/bpf/progs/xsk_xdp_drop.c b/tools/testing/selftests/bpf/progs/xsk_xdp_drop.c
new file mode 100644
index 000000000000..12a12b0d9fc1
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/xsk_xdp_drop.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022 Intel */
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_XSKMAP);
+	__uint(max_entries, 1);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+} xsk SEC(".maps");
+
+static unsigned int idx;
+
+SEC("xdp") int xsk_xdp_drop(struct xdp_md *xdp)
+{
+	/* Drop every other packet */
+	if (idx++ % 2)
+		return XDP_DROP;
+
+	return bpf_redirect_map(&xsk, 0, XDP_DROP);
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 0cda4e3f1871..522dc1d69c17 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1654,18 +1654,53 @@ static void testapp_invalid_desc(struct test_spec *test)
 	pkt_stream_restore_default(test);
 }
 
-static int xsk_load_xdp_program(struct ifobject *ifobj)
+static void testapp_xdp_drop(struct test_spec *test)
+{
+	struct ifobject *ifobj = test->ifobj_rx;
+	int err;
+
+	test_spec_set_name(test, "XDP_CONSUMES_SOME_PACKETS");
+	xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
+	err = xsk_attach_xdp_program(ifobj->xdp_drop->progs.xsk_xdp_drop, ifobj->ifindex,
+				     ifobj->xdp_flags);
+	if (err) {
+		printf("Error attaching XDP_DROP program\n");
+		test->fail = true;
+		return;
+	}
+	ifobj->xskmap = ifobj->xdp_drop->maps.xsk;
+
+	pkt_stream_receive_half(test);
+	testapp_validate_traffic(test);
+
+	pkt_stream_restore_default(test);
+	xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
+	err = xsk_attach_xdp_program(ifobj->def_prog->progs.xsk_def_prog, ifobj->ifindex,
+				     ifobj->xdp_flags);
+	if (err) {
+		printf("Error restoring default XDP program\n");
+		exit_with_error(-err);
+	}
+	ifobj->xskmap = ifobj->def_prog->maps.xsk;
+}
+
+static int xsk_load_xdp_programs(struct ifobject *ifobj)
 {
 	ifobj->def_prog = xsk_def_prog__open_and_load();
 	if (libbpf_get_error(ifobj->def_prog))
 		return libbpf_get_error(ifobj->def_prog);
 
+	ifobj->xdp_drop = xsk_xdp_drop__open_and_load();
+	if (libbpf_get_error(ifobj->xdp_drop))
+		return libbpf_get_error(ifobj->xdp_drop);
+
 	return 0;
 }
 
-static void xsk_unload_xdp_program(struct ifobject *ifobj)
+static void xsk_unload_xdp_programs(struct ifobject *ifobj)
 {
 	xsk_def_prog__destroy(ifobj->def_prog);
+	xsk_xdp_drop__destroy(ifobj->xdp_drop);
 }
 
 static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *src_mac,
@@ -1692,7 +1727,7 @@ static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *
 	if (!load_xdp)
 		return;
 
-	err = xsk_load_xdp_program(ifobj);
+	err = xsk_load_xdp_programs(ifobj);
 	if (err) {
 		printf("Error loading XDP program\n");
 		exit_with_error(err);
@@ -1804,6 +1839,9 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 	case TEST_TYPE_HEADROOM:
 		testapp_headroom(test);
 		break;
+	case TEST_TYPE_XDP_CONSUMES_PACKETS:
+		testapp_xdp_drop(test);
+		break;
 	default:
 		break;
 	}
@@ -1971,8 +2009,8 @@ int main(int argc, char **argv)
 
 	pkt_stream_delete(tx_pkt_stream_default);
 	pkt_stream_delete(rx_pkt_stream_default);
-	xsk_unload_xdp_program(ifobj_tx);
-	xsk_unload_xdp_program(ifobj_rx);
+	xsk_unload_xdp_programs(ifobj_tx);
+	xsk_unload_xdp_programs(ifobj_rx);
 	ifobject_delete(ifobj_tx);
 	ifobject_delete(ifobj_rx);
 
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index eb6355bcc143..3483ac240b2e 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -6,6 +6,7 @@
 #define XSKXCEIVER_H_
 
 #include "xsk_def_prog.skel.h"
+#include "xsk_xdp_drop.skel.h"
 
 #ifndef SOL_XDP
 #define SOL_XDP 283
@@ -87,6 +88,7 @@ enum test_type {
 	TEST_TYPE_STATS_RX_FULL,
 	TEST_TYPE_STATS_FILL_EMPTY,
 	TEST_TYPE_BPF_RES,
+	TEST_TYPE_XDP_CONSUMES_PACKETS,
 	TEST_TYPE_MAX
 };
 
@@ -141,6 +143,7 @@ struct ifobject {
 	validation_func_t validation_func;
 	struct pkt_stream *pkt_stream;
 	struct xsk_def_prog *def_prog;
+	struct xsk_xdp_drop *xdp_drop;
 	struct bpf_map *xskmap;
 	int ifindex;
 	u32 dst_ip;
-- 
2.34.1

