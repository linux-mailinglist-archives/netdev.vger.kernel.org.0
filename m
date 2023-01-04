Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73AD865D260
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 13:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239165AbjADMUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 07:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239239AbjADMTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 07:19:40 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D70395EB;
        Wed,  4 Jan 2023 04:19:01 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id ja17so25407576wmb.3;
        Wed, 04 Jan 2023 04:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DUkYO2pfAmo9wrsVR5UmwkbMcblYCF1NfZwi20+hcGM=;
        b=QCaDVS5t7NGUpzeuf1MCGGRew/6UlY6JN1ubXM72blm5MI0mpw8L9gokqMuCyTkDoG
         VNa+uJN/74D76k5LG2Y3rUPg3oUmWdH9xjgxmXO85FCNdjXK0QXeQh48omDEcUnDteEm
         ngloAejuEaapMqci3PCsH2sLLTTtWDtXGrvPWpONDwUbD/8Drp0pNtG30Ske8NR1mLIQ
         WKFYUsbi+amlDjvW3uA6Uc1gTHhS/wHiX6xdSAdzGCRs3XKsSuxpAuAonPh6zFLtqCeg
         JFFW70oJi+xnVIIUtU8Cjt8sllNtJqHu4QUSMbJKpywdyo3+Vh+nCqBN82HocTlk3FDa
         WpRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DUkYO2pfAmo9wrsVR5UmwkbMcblYCF1NfZwi20+hcGM=;
        b=MPudpog/fugAnq8+rIHy16MdTOfdjbChCalhtrdQX/WXXGY1Sx7rL+H40aWZAq0WuC
         j4+5fDVGLi+U0qhOH5H+KxT3MSDC6thSkj/v/ofe49kameXfwcb8M8wXhyr4XE2V8O0/
         ZqgowmcWqo8Q+T3vjtSNtaNc14tGOnrAXvI7pRIOHkee30kvEj5r1iFexjUW/dhbp+PX
         eoCg9sXjDusrn1IAaL3mkDxcrUJbxCEs+1uyH7jRmvzROM9PtEoaPlEpZVhW+wh3TafN
         vSFsg37m+zDytyZMMTJQeYvYzQHZqe5zTEB5FphL5v5sWDJGfppo8wzcQmu8m9efYPcV
         mMcA==
X-Gm-Message-State: AFqh2koatCKWCdZeBaFLMh3JzPpjD1rb5pZUVfP+kaELEjUh0KgFEPu6
        DSZcgd+3N2/50Lcegvps7mw=
X-Google-Smtp-Source: AMrXdXvQQ3szK4G8bKrk9KWgIQSC3mHgeUPAW/ZGNGkVNUH6GaCMzqc6DO3TFPBEvtm+zzzLW+5DQw==
X-Received: by 2002:a05:600c:3485:b0:3d1:ee6c:f897 with SMTP id a5-20020a05600c348500b003d1ee6cf897mr33585979wmq.3.1672834739930;
        Wed, 04 Jan 2023 04:18:59 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id w12-20020a05600c474c00b003d04e4ed873sm35013749wmo.22.2023.01.04.04.18.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Jan 2023 04:18:59 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v2 12/15] selftests/xsk: add test when some packets are XDP_DROPed
Date:   Wed,  4 Jan 2023 13:17:41 +0100
Message-Id: <20230104121744.2820-13-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230104121744.2820-1-magnus.karlsson@gmail.com>
References: <20230104121744.2820-1-magnus.karlsson@gmail.com>
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

