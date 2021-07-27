Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84003D75CB
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236720AbhG0NSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236597AbhG0NSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 09:18:23 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6EAAC061799;
        Tue, 27 Jul 2021 06:18:22 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id l4so15194751wrs.4;
        Tue, 27 Jul 2021 06:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bba+y4nJBkf6RA1osUz615uUTTAXiRDM2vfS6QEZz24=;
        b=JqSaHH7OTs3/ggIOhlFDTdqq8x36h5R1VAOUAUN3gjxqZxqWkmtoc0Rwc1cAkVmil5
         ughzqSm8mXIy+H0wqouxvWqeMLTCOu5xgeVLjCnqZs4f0qL1JDJOeryqOTu+HxTu/bLj
         pYwHotMRsyJXpYKCSMVMETYsdR5SjZo84BUoQTEpikqDGBqH/CC6ajpj8yiaR8hNDqA3
         6FquPXfRIIn+yjRbRbInpVGmlJQYLSMZGciqPiESLsQINfd8+g2JEyyTiefCKB7Sem/C
         SNWbHfeTFGXgEH8618SXXT8y9ONk9ryHy359bSKwFPPGpkmZkoOhcfGwKqzjClXCPk+7
         /6Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bba+y4nJBkf6RA1osUz615uUTTAXiRDM2vfS6QEZz24=;
        b=QgRFRLtDrlGkKoiy/nYOiBDbRY4w9tlcoJ1onbTponyPR5vtzaOABrGm+Ofh/ot8A4
         QQf5amWj24HBzWmcZEMK6jL50iLN9QKtprHEqD1EP0LDZYCo/hdIn+TA0iSvXzeBD7sM
         halpqVy2/0rOIT5vnrJCgCiqX+V8e3xaIBGlZYLvBYgQQ9j1kQu/5R2mB2BE3xg+72RZ
         Csc2iJNWhvBYRSLQ8lViZXyw3lrwQqfpHbfgUbj1UCC6dsIbxvYyj7XNX8/CEZCZuiOd
         S/fgBtXDehAt3HkB7yT7iO7SnrQLFCGF85VkuJ0BKeN089xQ0Mjlpbjw+ejfJpKV5Q6p
         RBgA==
X-Gm-Message-State: AOAM533+dcbA97KyIGtkjwuPYkx5VxIoq4t9p6zgG5I3nUs1byu+vXHH
        M12OoI57qV5H8C1RiH9SQmo=
X-Google-Smtp-Source: ABdhPJxTsh0MulB7Ui44dUk8ZGkFJNLEcst2Dcn/KV5fwfRvnRucwCqW7ME2u0jxVzPj+8jVvYZRaA==
X-Received: by 2002:adf:eacb:: with SMTP id o11mr25760446wrn.62.1627391901539;
        Tue, 27 Jul 2021 06:18:21 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id u11sm3277553wrr.44.2021.07.27.06.18.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Jul 2021 06:18:21 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        joamaki@gmail.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org
Subject: [PATCH bpf-next 09/17] selftests: xsk: rename worker_* functions that are not thred entry points
Date:   Tue, 27 Jul 2021 15:17:45 +0200
Message-Id: <20210727131753.10924-10-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210727131753.10924-1-magnus.karlsson@gmail.com>
References: <20210727131753.10924-1-magnus.karlsson@gmail.com>
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
index 4c9f38e9a268..2dca79b2762d 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -594,7 +594,7 @@ static void tx_only_all(struct ifobject *ifobject)
 	complete_tx_only_all(ifobject);
 }
 
-static void worker_pkt_dump(void)
+static void pkt_dump(void)
 {
 	struct ethhdr *ethhdr;
 	struct iphdr *iphdr;
@@ -636,7 +636,7 @@ static void worker_pkt_dump(void)
 	}
 }
 
-static void worker_stats_validate(struct ifobject *ifobject)
+static void stats_validate(struct ifobject *ifobject)
 {
 	struct xdp_statistics stats;
 	socklen_t optlen;
@@ -678,7 +678,7 @@ static void worker_stats_validate(struct ifobject *ifobject)
 	}
 }
 
-static void worker_pkt_validate(void)
+static void pkt_validate(void)
 {
 	u32 payloadseqnum = -2;
 	struct iphdr *iphdr;
@@ -838,9 +838,9 @@ static void *worker_testapp_validate_rx(void *arg)
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
@@ -878,7 +878,7 @@ static void testapp_validate(void)
 	pthread_join(t0, NULL);
 
 	if (debug_pkt_dump && test_type != TEST_TYPE_STATS) {
-		worker_pkt_dump();
+		pkt_dump();
 		for (int iter = 0; iter < num_frames; iter++) {
 			free(pkt_buf[iter]->payload);
 			free(pkt_buf[iter]);
-- 
2.29.0

