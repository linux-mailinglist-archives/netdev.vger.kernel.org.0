Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00B856657B7
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238052AbjAKJiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbjAKJhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:37:34 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D49D65E5;
        Wed, 11 Jan 2023 01:36:23 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id j16-20020a05600c1c1000b003d9ef8c274bso7788569wms.0;
        Wed, 11 Jan 2023 01:36:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lh88Wih2wB+fmm6WWcCt9i+CU9gho/zO1g4mEGHovWc=;
        b=VTMb71NptdFAHE6CZZnT0ImQzLBwY4SmPBG+35Ci4+hKvLsGk0s+la3Rj0BUV7xzG3
         N9vtNSwyrJwiNHKolJf2ZX1b2pUgyxQuHwL/M+wV9ujLdk/yrtuZ1KYJ+5cErT5Mh7oS
         gwA7p1phn9DqcOkqLM73ePW0NYmXGrjTOeVIMr0Zv5ZjrOaGw4qY0r0tshRByuckG8LF
         ++muVJy8h67EG9NxD5f8Z3SvLqKINJDHD9u6ClJoiRpP+0Q20CgXR9rP9/t4avxO+6OL
         NDOJZLBwuckpxYGJMF8KcZv4hPK6Ts9IFMVkQ9ZoFp2ORXmRE8YSxeDIJYiwel0FqHMx
         P42Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lh88Wih2wB+fmm6WWcCt9i+CU9gho/zO1g4mEGHovWc=;
        b=8A3Sq/Rz80sWwhHTP6W+/8ILZs6uauIrhV0YXf2UhzilKGhKZfxz9BX/pKzPNAGrcs
         5LSP3f2pT21F9TA531YU+mwfeHpkkEaVbYQFb12+8Gc7zBJC6/Ga2uT7xh2W9TkL7GEl
         +wH4gATR9viDtyWn392OzAz2AAplU0dp6HxoEBBWuXUn2x/jfR143q22Yh4Ns/s/6Nso
         hsSUnfp/bf2+1+eD373Li8fvQ/9OeqlotQri3d6dUV82139OCAFT7hFvFpxaFlI/h3Qu
         W/5UFVStWT9UQKbI5DxdLxAscd0bTbArDenHfdYAMIilrbVd1aKGI2wu3k9vA1Is85mD
         1N9A==
X-Gm-Message-State: AFqh2koS1/9V7wgvgFST+01MBy3SlPpSEslrpilyct4i9TlVzI/CTSCV
        NtJ5IUtrIGougC7mmHFifrY=
X-Google-Smtp-Source: AMrXdXs+xBDYWF/zjYB6erhsJJh7HtfCdPgVgGCmw4B06kPT1ygcP7g5leJG840WQjXqrOTK+tQNPQ==
X-Received: by 2002:a05:600c:3d95:b0:3d9:78c3:5cb0 with SMTP id bi21-20020a05600c3d9500b003d978c35cb0mr42002935wmb.36.1673429781543;
        Wed, 11 Jan 2023 01:36:21 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id c18-20020adffb52000000b0025e86026866sm15553069wrs.0.2023.01.11.01.36.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Jan 2023 01:36:20 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v3 12/15] selftests/xsk: add test when some packets are XDP_DROPed
Date:   Wed, 11 Jan 2023 10:35:23 +0100
Message-Id: <20230111093526.11682-13-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111093526.11682-1-magnus.karlsson@gmail.com>
References: <20230111093526.11682-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 .../selftests/bpf/progs/xsk_xdp_progs.c       | 11 +++++++
 tools/testing/selftests/bpf/xskxceiver.c      | 31 +++++++++++++++++++
 tools/testing/selftests/bpf/xskxceiver.h      |  1 +
 3 files changed, 43 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/xsk_xdp_progs.c b/tools/testing/selftests/bpf/progs/xsk_xdp_progs.c
index 698176882ac6..744a01d0e57d 100644
--- a/tools/testing/selftests/bpf/progs/xsk_xdp_progs.c
+++ b/tools/testing/selftests/bpf/progs/xsk_xdp_progs.c
@@ -11,9 +11,20 @@ struct {
 	__uint(value_size, sizeof(int));
 } xsk SEC(".maps");
 
+static unsigned int idx;
+
 SEC("xdp") int xsk_def_prog(struct xdp_md *xdp)
 {
 	return bpf_redirect_map(&xsk, 0, XDP_DROP);
 }
 
+SEC("xdp") int xsk_xdp_drop(struct xdp_md *xdp)
+{
+	/* Drop every other packet */
+	if (idx++ % 2)
+		return XDP_DROP;
+
+	return bpf_redirect_map(&xsk, 0, XDP_DROP);
+}
+
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index d69100267f70..a33f11b4c598 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1646,6 +1646,34 @@ static void testapp_invalid_desc(struct test_spec *test)
 	pkt_stream_restore_default(test);
 }
 
+static void testapp_xdp_drop(struct test_spec *test)
+{
+	struct ifobject *ifobj = test->ifobj_rx;
+	int err;
+
+	test_spec_set_name(test, "XDP_DROP_HALF");
+	xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
+	err = xsk_attach_xdp_program(ifobj->xdp_progs->progs.xsk_xdp_drop, ifobj->ifindex,
+				     ifobj->xdp_flags);
+	if (err) {
+		printf("Error attaching XDP_DROP program\n");
+		test->fail = true;
+		return;
+	}
+
+	pkt_stream_receive_half(test);
+	testapp_validate_traffic(test);
+
+	pkt_stream_restore_default(test);
+	xsk_detach_xdp_program(ifobj->ifindex, ifobj->xdp_flags);
+	err = xsk_attach_xdp_program(ifobj->xdp_progs->progs.xsk_def_prog, ifobj->ifindex,
+				     ifobj->xdp_flags);
+	if (err) {
+		printf("Error restoring default XDP program\n");
+		exit_with_error(-err);
+	}
+}
+
 static int xsk_load_xdp_programs(struct ifobject *ifobj)
 {
 	ifobj->xdp_progs = xsk_xdp_progs__open_and_load();
@@ -1796,6 +1824,9 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 	case TEST_TYPE_HEADROOM:
 		testapp_headroom(test);
 		break;
+	case TEST_TYPE_XDP_DROP_HALF:
+		testapp_xdp_drop(test);
+		break;
 	default:
 		break;
 	}
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index 70b3e5d1d40c..a4daa5134fc0 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -87,6 +87,7 @@ enum test_type {
 	TEST_TYPE_STATS_RX_FULL,
 	TEST_TYPE_STATS_FILL_EMPTY,
 	TEST_TYPE_BPF_RES,
+	TEST_TYPE_XDP_DROP_HALF,
 	TEST_TYPE_MAX
 };
 
-- 
2.34.1

