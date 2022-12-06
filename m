Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6933643F5F
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234416AbiLFJJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234287AbiLFJJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:09:07 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E91DB1DDE1;
        Tue,  6 Dec 2022 01:09:05 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id f13-20020a1cc90d000000b003d08c4cf679so8337145wmb.5;
        Tue, 06 Dec 2022 01:09:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=huOhL7D9Jyth4UUa2iSMii1CNgBq5CuBgEOXmYynEqw=;
        b=lZ6BDkBG/8zDGqjB3jwir/qSYV/bMrL9/N08CJnJlKllmmXlYeQBj6FZttAm1V+ath
         2pibY0b1W70g23yG53W7Wnd4Hnb+GdZhTK67+te1CKvCz5T8vqolWTjpJcucSAsBccEE
         XtLKTnNSY8n8VtxUZOndhcH9pQuQHdlEvvBxSfMWjbPHVp3zme/KkNWo08PPJNRjS60U
         UyraDSTCJswjdo1NTMx+UK1KPFo1HphoUfstL7jqoCZX+jNPUhM1pvJE2IgYsAGVz9GA
         ibfX7ZxjhoLb9wmjc9zxqed4g/ddyJAarrEywt/cqxQLNPETCfZOCYKJFjbSXIrOcrwX
         D0yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=huOhL7D9Jyth4UUa2iSMii1CNgBq5CuBgEOXmYynEqw=;
        b=I0KAPmSS6wjSmOmW00y/WtBC+1EWxCpQstLDQbugZJEL6RBdjlEIHIWyScPgLXcRrr
         KRGOupAy6buIAHtrqOuhaTKwpv45xC/jt3czLs5pbufgy5T1p41qbj6gWUaxtTVfLg4L
         /O+U8LX4hUKECoiFuf4pVHN/fVoBrXkq/ZQFuYnWfudO1Ytvf8PuHtX5Y8i+X53wAq6A
         272o4ezke6i02XZfs3B2BdGuakZrH084Nm39Ir7WixqEG7xUivGki3WHHAghGdXDPXJ9
         BOh4WfaLBh+jrNKybWisYP0YxjgGdZebh8pjiUZLUIT0LxwxBa4Nqq18sLe/RYAkpBsV
         TM3g==
X-Gm-Message-State: ANoB5pmZSmtpzwwILiCzlFyWoSUM/wvNgLsGc2cB8/wiqjHhH6OHh79K
        Lv7SzcUc/ICh93/YpeVABeE=
X-Google-Smtp-Source: AA0mqf443yfiTQOZLRYRfQ+ufk0yorG6sYn391SCzM5QpD1nAlkiGosQZeWDkPJ0/iTsHcu0/kqnpQ==
X-Received: by 2002:a7b:ca53:0:b0:3cf:74ef:3313 with SMTP id m19-20020a7bca53000000b003cf74ef3313mr50766235wml.41.1670317744349;
        Tue, 06 Dec 2022 01:09:04 -0800 (PST)
Received: from localhost.localdomain (c-5eea761b-74736162.cust.telenor.se. [94.234.118.27])
        by smtp.gmail.com with ESMTPSA id j23-20020a05600c1c1700b003cf57329221sm25065690wms.14.2022.12.06.01.09.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Dec 2022 01:09:03 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 04/15] selftests/xsk: print correct error codes when exiting
Date:   Tue,  6 Dec 2022 10:08:15 +0100
Message-Id: <20221206090826.2957-5-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221206090826.2957-1-magnus.karlsson@gmail.com>
References: <20221206090826.2957-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
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
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
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

