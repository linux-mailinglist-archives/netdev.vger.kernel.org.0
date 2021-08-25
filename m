Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58A3D3F71E7
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239832AbhHYJi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239735AbhHYJix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 05:38:53 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDADDC0617AE;
        Wed, 25 Aug 2021 02:38:04 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id j14-20020a1c230e000000b002e748b9a48bso3310121wmj.0;
        Wed, 25 Aug 2021 02:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1xUet7aDAy2GCLrD/Oo0nVgpuM2fnYwVexflXHXXhyA=;
        b=CJ6WJkor/YwwTTQg0+FjDgnIpmRm9gBpTFa+SwT3BhltEfglweLv9YWUrq9qmAop8H
         aEv8G+I/3/mL9TwxbA3LXepc5B/zj4IjGoWs7YQjqU/h7pfA9kDM7GB0lXmYtK+FOOKc
         irMIAkTLBO53CXY8BQ8n4w8PGVayG/y8TaPr1K6+nLU7m0/U3PycbMQoqVQpwtiRNkla
         MRG7JyilqTWJD526Vr4b+1rxFS+GIdRGInvZP/b8mgJ1G32NjkYXweJpmig6Oa9r8TnS
         YmqHr9xwjpQSlzoZ8jQLa7LV08up/fGJkK9K3+bRUf7S8YK/41tTxQjJRXKSbcJNm6a1
         crKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1xUet7aDAy2GCLrD/Oo0nVgpuM2fnYwVexflXHXXhyA=;
        b=T2LYtE1KOZre1C3lorFK3JDqqiVQTdb24IAynbJ+ZrUREh3Ditls90OI3DrNcJBXe9
         tsr0PeGGh658V/fRkKuRDiikDAWwockgnaUQcdy64PB+BqXn0PZLiiwuBjJlV6ZnwejH
         3EEjZgqJw10NKhvdV4tjRCRnT7R6igNet4m80Rcnn/cueER36pxrgM4QX6VKVQb8+hoD
         6vJfyx91iTC4JV31C3ESx/6BxaxdcdXxtvpEiSQtGaI8WxOt/X1EQqCEc7EwiorTIKHy
         tEf8j5UKdjfT3PASa0wwRZHmrVEO5lFvsCkt41dJtH2eGdDgI8x/9IWGB+nI9p1IILe4
         EvyA==
X-Gm-Message-State: AOAM531er0ob2ZVesPag+d+d3yQcqxy06qjepFbluJNVQT6H5kPrc79K
        fxUVB6HzQs7260LuwH7VZck=
X-Google-Smtp-Source: ABdhPJyn/VGNF68eu/7mEewrEX9hhQ4DHhF8+G3cMx0Ry5B9oHfMzGrmARAiLkpqvgswbzCTNzDftw==
X-Received: by 2002:a7b:c447:: with SMTP id l7mr120253wmi.15.1629884283428;
        Wed, 25 Aug 2021 02:38:03 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k18sm4767910wmi.25.2021.08.25.02.38.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Aug 2021 02:38:03 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v3 08/16] selftests: xsk: rename worker_* functions that are not thread entry points
Date:   Wed, 25 Aug 2021 11:37:14 +0200
Message-Id: <20210825093722.10219-9-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210825093722.10219-1-magnus.karlsson@gmail.com>
References: <20210825093722.10219-1-magnus.karlsson@gmail.com>
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

