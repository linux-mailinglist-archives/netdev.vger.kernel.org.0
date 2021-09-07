Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02110402415
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 09:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238288AbhIGHWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 03:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240259AbhIGHVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 03:21:18 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBA9C061575;
        Tue,  7 Sep 2021 00:20:11 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id u15-20020a05600c19cf00b002f6445b8f55so1423069wmq.0;
        Tue, 07 Sep 2021 00:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jbvBnJlz9g2rVA7xQbLe387nO62ZOQvN08wBymbdl88=;
        b=GMrM/TyXPGCIOmVCwLOuBHVi9Uewi4A8sgdBfsJVO+PCB2cHiZdLq1kt0Mz9RKGS1Z
         D8xi7xwM+T/gvXYe+MSyeZ3+0jVqAUaF4x7af1qqU62xEJD1zln620uaWE9d1xDmE1Ly
         4phamSUIzFUAXwD2ZvTKIjgJv3lySqKcYkyotB2L4qmsr6LzHD8EonrSkcUoV1cJmt14
         TDXjKsKGvITmt4XnFjnhhpYfRbvUAAAJTHPEVzjnCw6vakb+JVDnFh0KA6xRWsizD265
         Bp7n/tlQJ/LHsEM6RdITb7d/RgkRUi6vGwqS2c5KCn/eUSfZJ5zFBT0XKDOX0YQ6L2nz
         3Srw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jbvBnJlz9g2rVA7xQbLe387nO62ZOQvN08wBymbdl88=;
        b=oDx6ohJs4A+5hy7BmQvAh/fQSGWQ6n/+8RpICKJ5/ZyFIIRuqpt/Qst6aM7UKOkEZw
         FOtLBQR+f8Xfz9I983qDSUhefRXt9VMDo6RxXE9Lx8VjErWOzz0tr3NnP60eR1bupkcJ
         ohOqFy2H+8lDCrO9mCVKzYZu7bLURCAM7AsR8BT6TqZYxeNeGO5y8HWA9A7Yk60NdUkY
         pOfW0L67TCdcq58NZP3FtAqcLm4Byce8rNlSBjqjx/eCUks/Jvs7XyxLrmlZefHQhPLB
         KF3eft8ceRnG85KJPnAkh7w2lmQdT0Pa78VD51BNn6G32GmEPRoqUwmwFtvmacZLH+0V
         O0+Q==
X-Gm-Message-State: AOAM533S7MKaSMuaQZmlJDjWczDwPdJNMS+iu/XJxQjbQWr05m7Gw7vU
        RlBCNN8ZC9W7uMwFHw6LEBw=
X-Google-Smtp-Source: ABdhPJwfMnQ3w+VblfFyBoBHCNrp+WvctkoALWpwOJZ3WfQAyS/m+eOlX98mJt6fwAP0r+hn3s9Xqg==
X-Received: by 2002:a1c:a793:: with SMTP id q141mr2374711wme.157.1630999210370;
        Tue, 07 Sep 2021 00:20:10 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k16sm722941wrd.47.2021.09.07.00.20.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Sep 2021 00:20:10 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 14/20] selftests: xsk: eliminate MAX_SOCKS define
Date:   Tue,  7 Sep 2021 09:19:22 +0200
Message-Id: <20210907071928.9750-15-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210907071928.9750-1-magnus.karlsson@gmail.com>
References: <20210907071928.9750-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Remove the MAX_SOCKS define as it always will be one for the forseable
future and the code does not work for any other case anyway.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 18 +++++++++---------
 tools/testing/selftests/bpf/xdpxceiver.h |  1 -
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 5ea78c503741..0fb5cae974de 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -693,11 +693,11 @@ static void wait_for_tx_completion(struct xsk_socket_info *xsk)
 
 static void send_pkts(struct ifobject *ifobject)
 {
-	struct pollfd fds[MAX_SOCKS] = { };
+	struct pollfd fds = { };
 	u32 pkt_cnt = 0;
 
-	fds[0].fd = xsk_socket__fd(ifobject->xsk->xsk);
-	fds[0].events = POLLOUT;
+	fds.fd = xsk_socket__fd(ifobject->xsk->xsk);
+	fds.events = POLLOUT;
 
 	while (pkt_cnt < ifobject->pkt_stream->nb_pkts) {
 		u32 sent;
@@ -705,11 +705,11 @@ static void send_pkts(struct ifobject *ifobject)
 		if (ifobject->use_poll) {
 			int ret;
 
-			ret = poll(fds, 1, POLL_TMOUT);
+			ret = poll(&fds, 1, POLL_TMOUT);
 			if (ret <= 0)
 				continue;
 
-			if (!(fds[0].revents & POLLOUT))
+			if (!(fds.revents & POLLOUT))
 				continue;
 		}
 
@@ -855,7 +855,7 @@ static void *worker_testapp_validate_rx(void *arg)
 {
 	struct test_spec *test = (struct test_spec *)arg;
 	struct ifobject *ifobject = test->ifobj_rx;
-	struct pollfd fds[MAX_SOCKS] = { };
+	struct pollfd fds = { };
 
 	if (test->current_step == 1)
 		thread_common_ops(test, ifobject);
@@ -863,8 +863,8 @@ static void *worker_testapp_validate_rx(void *arg)
 	if (stat_test_type != STAT_TEST_RX_FILL_EMPTY)
 		xsk_populate_fill_ring(ifobject->umem);
 
-	fds[0].fd = xsk_socket__fd(ifobject->xsk->xsk);
-	fds[0].events = POLLIN;
+	fds.fd = xsk_socket__fd(ifobject->xsk->xsk);
+	fds.events = POLLIN;
 
 	pthread_barrier_wait(&barr);
 
@@ -872,7 +872,7 @@ static void *worker_testapp_validate_rx(void *arg)
 		while (!rx_stats_are_valid(ifobject))
 			continue;
 	else
-		receive_pkts(ifobject->pkt_stream, ifobject->xsk, fds);
+		receive_pkts(ifobject->pkt_stream, ifobject->xsk, &fds);
 
 	if (test_type == TEST_TYPE_TEARDOWN)
 		print_verbose("Destroying socket\n");
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 34ae4e4ea4ac..1e9a563380c8 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -20,7 +20,6 @@
 #define MAX_INTERFACES 2
 #define MAX_INTERFACE_NAME_CHARS 7
 #define MAX_INTERFACES_NAMESPACE_CHARS 10
-#define MAX_SOCKS 1
 #define MAX_SOCKETS 2
 #define MAX_TEST_NAME_SIZE 32
 #define MAX_TEARDOWN_ITER 10
-- 
2.29.0

