Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D22C54023FB
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 09:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239293AbhIGHVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 03:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238453AbhIGHU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 03:20:59 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BB7C061575;
        Tue,  7 Sep 2021 00:19:53 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id m9so12951621wrb.1;
        Tue, 07 Sep 2021 00:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LBCLQ/6Mm7ekbNtZBIv/c8fxdC6nOz1HbQAiHRTgx0g=;
        b=hOGMp5QVKIGKSj/7+6DzBOgIHx99iwONjgxqsF7rxC7xVr46kJB4zjZ72BeOpHxGxt
         gDqaucuFwY4Ly/2GlgEAF0682DcSqoSOorB0qVBvknD1UpyOh6Hhh+p2mRiTD1NnyKLR
         swZftXes8sEfNj/Ha14kBTUDZ/U5NnKApFlCkNXXfgZ/752uJsEAC1fnkv54plq6D6zx
         LRfRP42UzUXFGUWmM3uPu3xGSUfzh/9/zBSPYcFvaYLisMrMBUQbDtU7aFwirCE3ZL2g
         em6xMKIsbSrNpcFnf7jt0thia6FjQ6bPQC/uWrjj2K5ZgP5bjpYvhHXm+Ydvdt+UO4kQ
         q/Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LBCLQ/6Mm7ekbNtZBIv/c8fxdC6nOz1HbQAiHRTgx0g=;
        b=TCdT9Mw7dMtPzqy9FpHqY/U2chY4WhAYOyqjtNr9xJelyzWHLA8CeHVwXsPcq6/CIa
         TL1YMArCzoeoMftK5Wuv08rRCwmvLBkyyyJfYZfOGoTJKGr9nA6RBemKKyHbyfC/utWc
         WKBh7+rcC0+r2r4kh5s8bwETibvMARJQ4CJFt52nPk8AkQ6BVPX6IGkEv4mghqMjV6AC
         QXc0c+OWKXjsSvaKO/8jyAUO1b67yS0xGW/Mz5aT3IeVP/9N+nig/siYp4eSP67YXxbR
         iLLNVNvRg01o7rTa7ATutsXCJB820Bn46OLADPtgeJ5gphZTC0r2ihlMl9N4WBtQ/fsy
         s+pg==
X-Gm-Message-State: AOAM53338sRIrNCo5AnvIXkEz33Ef2t9F1lox+PCB5w5BICnFiCBBlT1
        EFiWD6nf1m4JxvR/8u59cr2tWVTOoFhsphGoSSU=
X-Google-Smtp-Source: ABdhPJxSXunIe+BCZrl3DGfwYqoTIVdIr5726XH4bLmoDeQ7BrFfEQwIMnpufmEdvJyQIau+q60R4Q==
X-Received: by 2002:a5d:6441:: with SMTP id d1mr17390295wrw.281.1630999192367;
        Tue, 07 Sep 2021 00:19:52 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k16sm722941wrd.47.2021.09.07.00.19.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Sep 2021 00:19:52 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 02/20] selftests: xsk: introduce type for thread function
Date:   Tue,  7 Sep 2021 09:19:10 +0200
Message-Id: <20210907071928.9750-3-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210907071928.9750-1-magnus.karlsson@gmail.com>
References: <20210907071928.9750-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Introduce a typedef of the thread function so this can be passed to
init_iface() in order to simplify that function.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 25 ++++++++++++------------
 tools/testing/selftests/bpf/xdpxceiver.h |  4 +++-
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 9639d8da516d..edf5b6cc6998 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -974,10 +974,9 @@ static void testapp_stats(void)
 	print_ksft_result();
 }
 
-static void init_iface(struct ifobject *ifobj, const char *dst_mac,
-		       const char *src_mac, const char *dst_ip,
-		       const char *src_ip, const u16 dst_port,
-		       const u16 src_port, enum fvector vector)
+static void init_iface(struct ifobject *ifobj, const char *dst_mac, const char *src_mac,
+		       const char *dst_ip, const char *src_ip, const u16 dst_port,
+		       const u16 src_port, enum fvector vector, thread_func_t func_ptr)
 {
 	struct in_addr ip;
 
@@ -993,15 +992,13 @@ static void init_iface(struct ifobject *ifobj, const char *dst_mac,
 	ifobj->dst_port = dst_port;
 	ifobj->src_port = src_port;
 
-	if (vector == tx) {
-		ifobj->fv.vector = tx;
-		ifobj->func_ptr = worker_testapp_validate_tx;
+	if (vector == tx)
 		ifdict_tx = ifobj;
-	} else {
-		ifobj->fv.vector = rx;
-		ifobj->func_ptr = worker_testapp_validate_rx;
+	else
 		ifdict_rx = ifobj;
-	}
+
+	ifobj->fv.vector = vector;
+	ifobj->func_ptr = func_ptr;
 }
 
 static void run_pkt_test(int mode, int type)
@@ -1097,8 +1094,10 @@ int main(int argc, char **argv)
 
 	parse_command_line(argc, argv);
 
-	init_iface(ifdict[tx], MAC1, MAC2, IP1, IP2, UDP_PORT1, UDP_PORT2, tx);
-	init_iface(ifdict[rx], MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1, rx);
+	init_iface(ifdict[tx], MAC1, MAC2, IP1, IP2, UDP_PORT1, UDP_PORT2, tx,
+		   worker_testapp_validate_tx);
+	init_iface(ifdict[rx], MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1, rx,
+		   worker_testapp_validate_rx);
 
 	ksft_set_plan(TEST_MODE_MAX * TEST_TYPE_MAX);
 
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index de80516ac6c2..799d524eb425 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -116,6 +116,8 @@ struct pkt_stream {
 	struct pkt *pkts;
 };
 
+typedef void *(*thread_func_t)(void *arg);
+
 struct ifobject {
 	char ifname[MAX_INTERFACE_NAME_CHARS];
 	char nsname[MAX_INTERFACES_NAMESPACE_CHARS];
@@ -123,8 +125,8 @@ struct ifobject {
 	struct xsk_socket_info *xsk_arr;
 	struct xsk_umem_info *umem;
 	struct xsk_umem_info *umem_arr;
-	void *(*func_ptr)(void *arg);
 	struct flow_vector fv;
+	thread_func_t func_ptr;
 	struct pkt_stream *pkt_stream;
 	int ns_fd;
 	u32 dst_ip;
-- 
2.29.0

