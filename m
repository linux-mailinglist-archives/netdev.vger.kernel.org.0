Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1D373EE9CC
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239606AbhHQJ3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239611AbhHQJ3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 05:29:50 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B90BC0613A4;
        Tue, 17 Aug 2021 02:29:06 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id k8so8603617wrn.3;
        Tue, 17 Aug 2021 02:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1xUet7aDAy2GCLrD/Oo0nVgpuM2fnYwVexflXHXXhyA=;
        b=iaOhbEjkzHBX6NWSz3g4XI2OCGgJ7JkNrmjWDOUaIZEa1InWyuItSrM2PFNJPWyWII
         vRBjGoW8yPnOgPWcanNn5ub4xIVtClGOeArGF6FmLSITCjJmU0CN9HwYBOiuA1xijLKZ
         U9gsMLhNBM/QxNytWa1mBMJv5pRlyiUfnvBdA2cM1x25+gZuc1xzfXJygCfW9q+GzACa
         yTtqtONXMUmkcpbzMOz1StHI8/WNSuw+ddhPpLSvAvbGbeHOqh2mX5uWjsSduiFbBq0x
         phvEZJANZZlqHOihakg4REKmfefTjHTxQ8LDc8tZIRmbL1aa69qLlzxeiJnzrSh6ydOF
         tUPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1xUet7aDAy2GCLrD/Oo0nVgpuM2fnYwVexflXHXXhyA=;
        b=Gg0bsSK5y9SY4foVgI3GTB8bW1E4LG2zCCra1EXFHM9B166P3mzaYYc7uFbAy/aC3l
         r1vTKfULUNDCzpkiFAFau2MBwWZwdFWXr/YL9FNn/pCH9c1JflqLGm5+A5pX99sKakMX
         2Kp0OitwovssKmP0IHuPh8lqYIWAehgLo6r/4QYskJv8QE5Mf0PyZwFmpkHT88ZSnWHF
         olyMUTKlcu4mra+cRARLKSOqoiwzVvawWwkmSxeHLeLv9tOHdUcEH0QDADZmaSns+TQX
         A11s8IhlCZ1TC/2ctw8XYjSfCCBFQSo87RHIXczRULxvIygLxbgvmImaPKJ9c9FXrfMf
         SsJQ==
X-Gm-Message-State: AOAM531HxwYgKeXg2QAHdywhbm+FowASkhxMoaROPH++VK/+QBow8h/9
        aw8dX2YqlFZPxjnlHJQOsEM=
X-Google-Smtp-Source: ABdhPJw8SiJM8MRv1Gi7vchF+i2Pms5G65VuRnO63295v2QfDNxz+PGbU2NmNpEINTQ2ynE56sJmbQ==
X-Received: by 2002:a5d:4c91:: with SMTP id z17mr2873503wrs.54.1629192544988;
        Tue, 17 Aug 2021 02:29:04 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id l2sm1462421wme.28.2021.08.17.02.29.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Aug 2021 02:29:04 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 08/16] selftests: xsk: rename worker_* functions that are not thread entry points
Date:   Tue, 17 Aug 2021 11:27:21 +0200
Message-Id: <20210817092729.433-9-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210817092729.433-1-magnus.karlsson@gmail.com>
References: <20210817092729.433-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Rename worker_* functions that are not thread entry points to
something else. This was confusing. Now only thread entry points are
worker_something.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index ebed88c13509..17956fdeb49e 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -589,7 +589,7 @@ static void tx_only_all(struct ifobject *ifobject)
 	complete_tx_only_all(ifobject);
 }
 
-static void worker_pkt_dump(void)
+static void pkt_dump(void)
 {
 	struct ethhdr *ethhdr;
 	struct iphdr *iphdr;
@@ -631,7 +631,7 @@ static void worker_pkt_dump(void)
 	}
 }
 
-static void worker_stats_validate(struct ifobject *ifobject)
+static void stats_validate(struct ifobject *ifobject)
 {
 	struct xdp_statistics stats;
 	socklen_t optlen;
@@ -673,7 +673,7 @@ static void worker_stats_validate(struct ifobject *ifobject)
 	}
 }
 
-static void worker_pkt_validate(void)
+static void pkt_validate(void)
 {
 	u32 payloadseqnum = -2;
 	struct iphdr *iphdr;
@@ -833,9 +833,9 @@ static void *worker_testapp_validate_rx(void *arg)
 	while (1) {
 		if (test_type != TEST_TYPE_STATS) {
 			rx_pkt(ifobject->xsk, fds);
-			worker_pkt_validate();
+			pkt_validate();
 		} else {
-			worker_stats_validate(ifobject);
+			stats_validate(ifobject);
 		}
 		if (sigvar)
 			break;
@@ -873,7 +873,7 @@ static void testapp_validate(void)
 	pthread_join(t0, NULL);
 
 	if (debug_pkt_dump && test_type != TEST_TYPE_STATS) {
-		worker_pkt_dump();
+		pkt_dump();
 		for (int iter = 0; iter < num_frames; iter++) {
 			free(pkt_buf[iter]->payload);
 			free(pkt_buf[iter]);
-- 
2.29.0

