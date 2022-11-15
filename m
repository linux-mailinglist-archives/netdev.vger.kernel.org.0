Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E36626292EF
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 09:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbiKOIGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 03:06:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbiKOIGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 03:06:04 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82014140EB;
        Tue, 15 Nov 2022 00:06:03 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id z14so22689389wrn.7;
        Tue, 15 Nov 2022 00:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UoMU+4yZcZN+gfBDaItl56pGrFzYvJvRENXDGoVmMTE=;
        b=b4e/3LG6pAPB3l5Jxr1K2nfs/u0lybcM5/1YSpwpWP5560ka4TbtZojmiXs3+HYNEw
         /hiYritDdY+orW5IKtQcAmk4jykKQ4XRGdbyWGbvpWhyhVakh+/3qjH13cKklJJOBrlu
         qZx/WwxFbHLNeFbUziZtJ3lRU8pcDn9XCotGfJtJsiLF3IyQ665Lt+tUZKJqfBDgYEFZ
         4yr/TtcJQRrw4wVYqnZmyRrBwPH5qQmof0bjFsFT3Wrjhuupo1V3DTsbq2y3vCSPUneF
         G5iqIs9z0WldGSDUUkvARq1fe4nqLVIglBAeba4WclDC9LGfQ6VwVJF5tqFykHB3MoUZ
         LAbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UoMU+4yZcZN+gfBDaItl56pGrFzYvJvRENXDGoVmMTE=;
        b=IIINdNhngRTM+cE7fTOVoHVvcQg0qCOrtfyelbJwbGPgNlNDvoVgz3Wir4nvZknxvl
         4kY/gSTr75/PSC8180cAIGD4yuphibfL8FQ7g3WMs6hT4vWMYS2LJzVsNjjXolIKy9tN
         vRRoRZFU6SyC8Ljqw3k5fZ+u4SS8D4Oyr8WV9bdKF6N8HpL6xN2f813iiNvCO48ikq9x
         LAdYKmf6mW5iC+7pQe2srYSoqRDr5JEosNzDeF29C8OARWB4IYZidEycAIPsA06L4gFL
         AhViu8+BVxHx+eBaS0SdKfQ4mi1re1dm/jankyEfY1zxdi7EqZpiBXrsYC5r+QA9InIa
         YXsA==
X-Gm-Message-State: ANoB5pncwPt1UXhA9ywmV/5ACoPKfoyYy8hMXHdQ/4wXSdvXsYjTqg/M
        by7YR/cu6VLz9h1NEguvUKI=
X-Google-Smtp-Source: AA0mqf4vwS6mvqKxMO+YnvJHgBDUPds/xwnvnQ1tIkdsAPqI8LX99/jXbNNcarfT8/APVzVubII6RA==
X-Received: by 2002:adf:f94a:0:b0:236:6b51:73bc with SMTP id q10-20020adff94a000000b002366b5173bcmr9868026wrr.707.1668499563041;
        Tue, 15 Nov 2022 00:06:03 -0800 (PST)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id cy6-20020a056000400600b002416ecb8c33sm11464190wrb.105.2022.11.15.00.06.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Nov 2022 00:06:02 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf 3/3] selftests/xsk: print correct error codes when exiting
Date:   Tue, 15 Nov 2022 09:05:38 +0100
Message-Id: <20221115080538.18503-4-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221115080538.18503-1-magnus.karlsson@gmail.com>
References: <20221115080538.18503-1-magnus.karlsson@gmail.com>
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

Print the correct error codes when exiting the test suite due to some
terminal error. Some of these had a switched sign and some of them
printed zero instead of errno.

Fixes: facb7cb2e909 ("selftests/bpf: Xsk selftests - SKB POLL, NOPOLL")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 51e693318b3f..507dd28801fa 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -350,7 +350,7 @@ static bool ifobj_zc_avail(struct ifobject *ifobject)
 	umem = calloc(1, sizeof(struct xsk_umem_info));
 	if (!umem) {
 		munmap(bufs, umem_sz);
-		exit_with_error(-ENOMEM);
+		exit_with_error(ENOMEM);
 	}
 	umem->frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;
 	ret = xsk_configure_umem(umem, bufs, umem_sz);
@@ -936,7 +936,7 @@ static int receive_pkts(struct test_spec *test, struct pollfd *fds)
 		if (ifobj->use_poll) {
 			ret = poll(fds, 1, POLL_TMOUT);
 			if (ret < 0)
-				exit_with_error(-ret);
+				exit_with_error(errno);
 
 			if (!ret) {
 				if (!is_umem_valid(test->ifobj_tx))
@@ -963,7 +963,7 @@ static int receive_pkts(struct test_spec *test, struct pollfd *fds)
 				if (xsk_ring_prod__needs_wakeup(&umem->fq)) {
 					ret = poll(fds, 1, POLL_TMOUT);
 					if (ret < 0)
-						exit_with_error(-ret);
+						exit_with_error(errno);
 				}
 				ret = xsk_ring_prod__reserve(&umem->fq, rcvd, &idx_fq);
 			}
@@ -1014,7 +1014,7 @@ static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb, struct pollfd *fd
 			if (timeout) {
 				if (ret < 0) {
 					ksft_print_msg("ERROR: [%s] Poll error %d\n",
-						       __func__, ret);
+						       __func__, errno);
 					return TEST_FAILURE;
 				}
 				if (ret == 0)
@@ -1023,7 +1023,7 @@ static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb, struct pollfd *fd
 			}
 			if (ret <= 0) {
 				ksft_print_msg("ERROR: [%s] Poll error %d\n",
-					       __func__, ret);
+					       __func__, errno);
 				return TEST_FAILURE;
 			}
 		}
@@ -1317,23 +1317,23 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 
 	ret = bpf_xdp_query(ifindex, ifobject->xdp_flags, &opts);
 	if (ret)
-		exit_with_error(-ret);
+		exit_with_error(errno);
 
 	if (ifobject->xdp_flags & XDP_FLAGS_SKB_MODE) {
 		if (opts.attach_mode != XDP_ATTACHED_SKB) {
 			ksft_print_msg("ERROR: [%s] XDP prog not in SKB mode\n");
-			exit_with_error(-EINVAL);
+			exit_with_error(EINVAL);
 		}
 	} else if (ifobject->xdp_flags & XDP_FLAGS_DRV_MODE) {
 		if (opts.attach_mode != XDP_ATTACHED_DRV) {
 			ksft_print_msg("ERROR: [%s] XDP prog not in DRV mode\n");
-			exit_with_error(-EINVAL);
+			exit_with_error(EINVAL);
 		}
 	}
 
 	ret = xsk_socket__update_xskmap(ifobject->xsk->xsk, ifobject->xsk_map_fd);
 	if (ret)
-		exit_with_error(-ret);
+		exit_with_error(errno);
 }
 
 static void *worker_testapp_validate_tx(void *arg)
@@ -1540,7 +1540,7 @@ static void swap_xsk_resources(struct ifobject *ifobj_tx, struct ifobject *ifobj
 
 	ret = xsk_socket__update_xskmap(ifobj_rx->xsk->xsk, ifobj_rx->xsk_map_fd);
 	if (ret)
-		exit_with_error(-ret);
+		exit_with_error(errno);
 }
 
 static void testapp_bpf_res(struct test_spec *test)
-- 
2.34.1

