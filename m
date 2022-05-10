Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAFE52146E
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 13:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241367AbiEJMBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241354AbiEJMBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:01:03 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD82E53B52;
        Tue, 10 May 2022 04:56:56 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id m62so10032545wme.5;
        Tue, 10 May 2022 04:56:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0+/wx6qHMDxfF1xbCFppYFG94pd86ozx15pznxColoc=;
        b=AYZnPLmyhC2/YgZUPNtUc2cn+ly4YSSzjFpGZmrPtoQrk0pxrChJEGT8vjNAhfvfF0
         AwrvtvR5G1gfm9rLajwomGiPhZT76UL3B6mzqe0oI3l1BcE9SKyWeFCxJXfBnm05b0Yu
         oVljmfetQpUJsdPBqCxu9DyLlR3TXSFPNd0ureocCZ9l2VDRamV1nhXvSqX4Kjuwx2kS
         G0Pnn5VBOTIL1Iyr9Plehatn7htVwnFygy/HGYPu9QmDTStfMNIDNNykG3cvmohud6A7
         bgkQ+w5nqQOwY9G5aMrWj38Ua5cP1PHTQwbWTYVa2aSTqY2zsn1WcUU50Ub3Apkw82GU
         hAoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0+/wx6qHMDxfF1xbCFppYFG94pd86ozx15pznxColoc=;
        b=bfzgf9qvw/PllgQuIsnrHVp/gsrQ2igBTKeKkG+K18hheI+i5/lDoQgUmtxOCjsqes
         aIdO2MybLTG/8OtM3JtRlMJSPv/KoZM3F01a9FClBatcSkZRSPHpXlOmHnZ9p5MMwTDa
         nuIBlaBecazVgDyNhwv8S2nh4+EcJV/EqvrD/L0Ew9ZBjY3fQgCGiUtE2LpQ3Y8esEl4
         /vUnFNhn39RJ8cueXN1AOQQl56tCvsiKgj+U2mOavWOV++k2sdkE45VmnNnOdfunl9+7
         8Mg3flKci5MWhNa3bKOiATNdLXIhD1b+oukdjvkedRZjM8GzO5AuV7asoS0PIrSP1Yso
         5V+A==
X-Gm-Message-State: AOAM532srp3OovdBhCIYwOpQVg7bd3Tlc42vmEz/n+FZ00TWfQ81CDWL
        sokq9kXtLwXNOL2CbH+SzRuDjD+A1nWgWV52
X-Google-Smtp-Source: ABdhPJzFfhaGPb00t4EfDRlfg7+N2DnkGuTIweEMOq+izj69pkW9OuydufI9jU4nTL8rffhyHgKGig==
X-Received: by 2002:a7b:ce95:0:b0:393:fbe5:32a7 with SMTP id q21-20020a7bce95000000b00393fbe532a7mr21000738wmj.123.1652183815943;
        Tue, 10 May 2022 04:56:55 -0700 (PDT)
Received: from localhost.localdomain ([188.149.128.194])
        by smtp.gmail.com with ESMTPSA id e25-20020a05600c4b9900b003942a244f51sm2267797wmp.42.2022.05.10.04.56.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 May 2022 04:56:55 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, yhs@fb.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next 5/9] selftests: xsk: add timeout to tests
Date:   Tue, 10 May 2022 13:56:00 +0200
Message-Id: <20220510115604.8717-6-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220510115604.8717-1-magnus.karlsson@gmail.com>
References: <20220510115604.8717-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add a timeout to the tests so that if all packets have not been
received within 3 seconds, fail the ongoing test. Hinders a test from
dead-locking if there is something wrong.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 15 +++++++++++++++
 tools/testing/selftests/bpf/xdpxceiver.h |  1 +
 2 files changed, 16 insertions(+)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index ebbab8f967c1..dc21951a1b0a 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -91,6 +91,7 @@
 #include <stddef.h>
 #include <sys/mman.h>
 #include <sys/socket.h>
+#include <sys/time.h>
 #include <sys/types.h>
 #include <sys/queue.h>
 #include <time.h>
@@ -792,6 +793,7 @@ static int complete_pkts(struct xsk_socket_info *xsk, int batch_size)
 
 static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
 {
+	struct timeval tv_end, tv_now, tv_timeout = {RECV_TMOUT, 0};
 	struct pkt_stream *pkt_stream = ifobj->pkt_stream;
 	struct pkt *pkt = pkt_stream_get_next_rx_pkt(pkt_stream);
 	struct xsk_socket_info *xsk = ifobj->xsk;
@@ -799,7 +801,20 @@ static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
 	u32 idx_rx = 0, idx_fq = 0, rcvd, i;
 	int ret;
 
+	ret = gettimeofday(&tv_now, NULL);
+	if (ret)
+		exit_with_error(errno);
+	timeradd(&tv_now, &tv_timeout, &tv_end);
+
 	while (pkt) {
+		ret = gettimeofday(&tv_now, NULL);
+		if (ret)
+			exit_with_error(errno);
+		if (timercmp(&tv_now, &tv_end, >)) {
+			ksft_print_msg("ERROR: [%s] Receive loop timed out\n", __func__);
+			return TEST_FAILURE;
+		}
+
 		kick_rx(xsk);
 
 		rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 7c6bf5ed594d..79ba344d2765 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -49,6 +49,7 @@
 #define SOCK_RECONF_CTR 10
 #define BATCH_SIZE 64
 #define POLL_TMOUT 1000
+#define RECV_TMOUT 3
 #define DEFAULT_PKT_CNT (4 * 1024)
 #define DEFAULT_UMEM_BUFFERS (DEFAULT_PKT_CNT / 4)
 #define UMEM_SIZE (DEFAULT_UMEM_BUFFERS * XSK_UMEM__DEFAULT_FRAME_SIZE)
-- 
2.34.1

