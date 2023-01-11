Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D01D6657AF
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:38:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbjAKJit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238034AbjAKJh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:37:27 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD7F2033;
        Wed, 11 Jan 2023 01:36:07 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id k22-20020a05600c1c9600b003d1ee3a6289so12149175wms.2;
        Wed, 11 Jan 2023 01:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nt8bPLpWqx6A+L2h4u2Jh9r52GIVdhmrBUVI4ibrZxM=;
        b=Wnli65ZjAvOT5upfQWlNrue6HUi9zAspIcX5KWsHPwc3SNQRXiyhe1apObkH7o/8/x
         UdvFOUHe0CBQBe2YJI+qb2cSmvnIL5NMiITplE9ovJUMVUZcGRln7uIocPlWVu+4xdTk
         7A5pRGQBks+WhDPq0fx0wZ2V51YeNShdh1qXBKx4WCchZTPzi9J9kX8oZJ07rmeOZwVO
         gag9p9XTdu2theyX/UKs7NlBBvUduRUYdEEv959pBMfu9lYgMM6jpXdnI5GXC7vXwOXp
         ocf1/zGTsmOMayShfWu3ViItdQ2/ZW8+upWAqXbb554s8FaY+/YcFA9fAPkE2m7ateDA
         fs2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nt8bPLpWqx6A+L2h4u2Jh9r52GIVdhmrBUVI4ibrZxM=;
        b=Fr1S+XBORdFYf/afE7owvUfygGS5tSNZQTEdqa7kMN24uX/bUctfwjcBqDRfWaqicV
         GTlcxvOlz8fNWt5tfKq7oayulptr2oYaewrErZwsVOGFFqFh3ZVd0ZexPeXi0yDJ9oNX
         CQz8mK3NdiYwXiTZxurKz7dANXE1gHPxXyLauJ3LXMc3J1JiT+tjJWObISeUtGujxQ8h
         mw4dNxshwmg5/W4TRoEaM8k+6ps+x1j/UvqxMgznfE3Hko4bp9stpTmQJEvnPIKbQM7k
         N03eyolldzNz9gjxiXo8zMAQMbKDWs96IVwM9J/7XX851D4SmzIy5igkHOM45VA4Q25O
         JpHQ==
X-Gm-Message-State: AFqh2kqpU4Vk7E0pWb3r7+JpRhWAv9HpUJhQMVdxy9PD4c5fDxNNwDGE
        M5jvSucFT13VJP/rQEcXMMs=
X-Google-Smtp-Source: AMrXdXuFmybaMSKzSeP10e5X+vTsRUWe3v/0BM39ox+87rKejKdVW8OIF1Oo4XGxtA3//Bv/CSIGkg==
X-Received: by 2002:a05:600c:358c:b0:3d9:fa37:e457 with SMTP id p12-20020a05600c358c00b003d9fa37e457mr3828486wmq.15.1673429766053;
        Wed, 11 Jan 2023 01:36:06 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id c18-20020adffb52000000b0025e86026866sm15553069wrs.0.2023.01.11.01.36.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Jan 2023 01:36:05 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v3 04/15] selftests/xsk: print correct error codes when exiting
Date:   Wed, 11 Jan 2023 10:35:15 +0100
Message-Id: <20230111093526.11682-5-magnus.karlsson@gmail.com>
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

Print the correct error codes when exiting the test suite due to some
terminal error. Some of these had a switched sign and some of them
printed zero instead of errno.

Fixes: facb7cb2e909 ("selftests/bpf: Xsk selftests - SKB POLL, NOPOLL")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index a239e975ab66..72578cebfbf7 100644
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
@@ -1015,7 +1015,7 @@ static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb, struct pollfd *fd
 			if (timeout) {
 				if (ret < 0) {
 					ksft_print_msg("ERROR: [%s] Poll error %d\n",
-						       __func__, ret);
+						       __func__, errno);
 					return TEST_FAILURE;
 				}
 				if (ret == 0)
@@ -1024,7 +1024,7 @@ static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb, struct pollfd *fd
 			}
 			if (ret <= 0) {
 				ksft_print_msg("ERROR: [%s] Poll error %d\n",
-					       __func__, ret);
+					       __func__, errno);
 				return TEST_FAILURE;
 			}
 		}
@@ -1323,18 +1323,18 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
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
@@ -1541,7 +1541,7 @@ static void swap_xsk_resources(struct ifobject *ifobj_tx, struct ifobject *ifobj
 
 	ret = xsk_socket__update_xskmap(ifobj_rx->xsk->xsk, ifobj_rx->xsk_map_fd);
 	if (ret)
-		exit_with_error(-ret);
+		exit_with_error(errno);
 }
 
 static void testapp_bpf_res(struct test_spec *test)
-- 
2.34.1

