Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8873FD81D
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhIAKtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234940AbhIAKtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:49:19 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBC1CC0617AD;
        Wed,  1 Sep 2021 03:48:20 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id n5so3732944wro.12;
        Wed, 01 Sep 2021 03:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jbvBnJlz9g2rVA7xQbLe387nO62ZOQvN08wBymbdl88=;
        b=pvggbBz8v+PIfPRv0vhCeSm9gJsnpp0Z+14xNpV8ZldqOz+yma8mH7/ASCCMoSQiZJ
         Q+97zVn5auWR7k748bpivGAbSuMXkfMEB5IfbOx7jhRnijarUj3LOsJGR1pgVRJPsHqM
         g7o8ArQXnIlc7C9RHWFKd/mlakMndwAr2dUpPnwEhNLUqg+PCBQlt1YqvRJKHy3uLm1q
         kQz5ftADWuciHPX9J6Hy4HYkmu6O2Lo9pA2dVsoqto5oVD88k42YTx9JG+Bo4pBZPdbL
         5aubtSaerKL1j5QHpMJ8XJI9NWLsf54LicUO7yu75h6mUhg3feU4CNXTd7ilEypcwWtB
         LYLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jbvBnJlz9g2rVA7xQbLe387nO62ZOQvN08wBymbdl88=;
        b=dCrGnFC+0bKdfcjuQ/aRGn/Y82eNGmDtHuhp9D7WXrCLGVmTr7fZk4wgYBRYbYd0Ec
         rHonuamdhtDvZVxcmdgV4ujSJ4aDaIoAEuKUYk8vyc9oH/J4wlBX9TMVwvr5IaqjgfBO
         bSaVnlj1el11gD12Z3voXcGELbOehn5HKUqQpJJSicvnU0+yktSCTw4pJkDfnzi8JJ5k
         lRnzKpnFoIaldoItn6ScR18FV6fGSFfOJX9ZBnbgMS118LdDGpKreAAJGx1TwlHMsko1
         R8nJKZ4iD7mA8bP3xiXioiPWbimM+PwaJ5u4h0wG7po/BqRIfbPqd+um5UGJpCRHjro9
         kZew==
X-Gm-Message-State: AOAM531OFDsNjt8K8yGU3RoWFp13yYP2MrQrpGE8GA4pLQvQzZrzYrAe
        GpdRfURWDfyJvsTCQKWe8ZMVhHiTfy9q//Xh
X-Google-Smtp-Source: ABdhPJxAAywtj8PO2uZhlpFoS704y+63iiMdNW9pequimLREx/6qqSG8U+da+EJnP9Y5ssDUPEu8+w==
X-Received: by 2002:adf:b318:: with SMTP id j24mr36761826wrd.84.1630493299468;
        Wed, 01 Sep 2021 03:48:19 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id r12sm21530843wrv.96.2021.09.01.03.48.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Sep 2021 03:48:19 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next 14/20] selftests: xsk: eliminate MAX_SOCKS define
Date:   Wed,  1 Sep 2021 12:47:26 +0200
Message-Id: <20210901104732.10956-15-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210901104732.10956-1-magnus.karlsson@gmail.com>
References: <20210901104732.10956-1-magnus.karlsson@gmail.com>
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

