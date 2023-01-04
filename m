Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31F265D25B
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 13:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239069AbjADMUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 07:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239297AbjADMTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 07:19:41 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CF3395DC;
        Wed,  4 Jan 2023 04:19:03 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id m3so16511085wmq.0;
        Wed, 04 Jan 2023 04:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vV6hvb09TXjRjGPsla5IndmW9+K4SpWeCw6R9aG8BNQ=;
        b=hUM2623an1HWvw3vXxMRCB+eD5porkrHPiZ+t9q54LrwNcsTHLTS6vjkarfX4k0G45
         HVk+x/v6oMaBykY5FFkT7Nh1FyuENbe4bivlBwVgbCksFmt+1BeyzFKZ1g+7x6CZeQ8U
         64SFpHQcSYlh5L8/9Bn79twNAh7kRqCr2MuWnztmZn9aUlW+xejeovwjI7PzorJU9ddm
         AUUNNPHzk9sCGTCsDDCaDaalA/Dm7kq41+2k0sZxohNbEcJaDygvxojjFaVRaRcYuhJe
         A8kupMwfFCI2LVvGEm5xwUiJBX/f0rR7QUp526qbgmmuuuqDbml+UIMoCyhw4+kAuM+q
         8GEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vV6hvb09TXjRjGPsla5IndmW9+K4SpWeCw6R9aG8BNQ=;
        b=FNTjZi1HnaQE6m6mu+nREVKrCABYzlzYbjLwB701+Z4anM69soZFysG0gsQwp9YUSW
         zvkS1kgl5fPHghqg8rDfCne2k93phplU8ZKOxCznBil7w4MSlfa8zmEGg8p2E9FqB+ja
         vuWAtBzHjQam+VdwJRfkSpRhuKHBAiqYE91ObAgpjgUxS0CJsIwZWP/UonLSJQAazbfH
         5rl2dH1X2RdRPu4xSq2o3o2KCGKRJ3BaC8peb/etZgvu3D/w0Lbv63eIxBbuZZItl+3E
         qfKEElIo0TO3u0ZeZLrxIGNNLA6J36CGAMUkt1bvryRethBGp+CwmQYje/DZVq+jXibe
         akUQ==
X-Gm-Message-State: AFqh2krO2icW8Voq4dIuR6Bk0v2PwhPEBwO2I6obz+a2Mucs5/50EwGl
        fqNOLFsXg530N7upf1vZJkU=
X-Google-Smtp-Source: AMrXdXtUdsoODTGTfdjCy8MEF4Vmaq2I/R14bidamL+khX7muWOEGeDErN3vRitiMzzkRJPzay8DAQ==
X-Received: by 2002:a05:600c:3509:b0:3cf:ae53:9193 with SMTP id h9-20020a05600c350900b003cfae539193mr33857784wmq.39.1672834741829;
        Wed, 04 Jan 2023 04:19:01 -0800 (PST)
Received: from localhost.localdomain (h-176-10-254-193.A165.priv.bahnhof.se. [176.10.254.193])
        by smtp.gmail.com with ESMTPSA id w12-20020a05600c474c00b003d04e4ed873sm35013749wmo.22.2023.01.04.04.19.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Jan 2023 04:19:01 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, tirthendu.sarkar@intel.com
Cc:     jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v2 13/15] selftests/xsk: merge dual and single thread dispatchers
Date:   Wed,  4 Jan 2023 13:17:42 +0100
Message-Id: <20230104121744.2820-14-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230104121744.2820-1-magnus.karlsson@gmail.com>
References: <20230104121744.2820-1-magnus.karlsson@gmail.com>
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

Make the thread dispatching code common by unifying the dual and
single thread dispatcher code. This so we do not have to add code in
two places in upcoming commits.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 120 ++++++++++-------------
 1 file changed, 54 insertions(+), 66 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index a33f11b4c598..11e4f29d40f7 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1356,83 +1356,59 @@ static void handler(int signum)
 	pthread_exit(NULL);
 }
 
-static int testapp_validate_traffic_single_thread(struct test_spec *test, struct ifobject *ifobj,
-						  enum test_type type)
+static int __testapp_validate_traffic(struct test_spec *test, struct ifobject *ifobj1,
+				      struct ifobject *ifobj2)
 {
-	bool old_shared_umem = ifobj->shared_umem;
-	pthread_t t0;
+	pthread_t t0, t1;
 
-	if (pthread_barrier_init(&barr, NULL, 2))
-		exit_with_error(errno);
+	if (ifobj2)
+		if (pthread_barrier_init(&barr, NULL, 2))
+			exit_with_error(errno);
 
 	test->current_step++;
-	if (type == TEST_TYPE_POLL_RXQ_TMOUT)
-		pkt_stream_reset(ifobj->pkt_stream);
+	pkt_stream_reset(ifobj1->pkt_stream);
 	pkts_in_flight = 0;
 
-	test->ifobj_rx->shared_umem = false;
-	test->ifobj_tx->shared_umem = false;
-
 	signal(SIGUSR1, handler);
-	/* Spawn thread */
-	pthread_create(&t0, NULL, ifobj->func_ptr, test);
+	/*Spawn RX thread */
+	pthread_create(&t0, NULL, ifobj1->func_ptr, test);
 
-	if (type != TEST_TYPE_POLL_TXQ_TMOUT)
+	if (ifobj2) {
 		pthread_barrier_wait(&barr);
+		if (pthread_barrier_destroy(&barr))
+			exit_with_error(errno);
 
-	if (pthread_barrier_destroy(&barr))
-		exit_with_error(errno);
+		/*Spawn TX thread */
+		pthread_create(&t1, NULL, ifobj2->func_ptr, test);
 
-	pthread_kill(t0, SIGUSR1);
-	pthread_join(t0, NULL);
+		pthread_join(t1, NULL);
+	}
+
+	if (!ifobj2)
+		pthread_kill(t0, SIGUSR1);
+	else
+		pthread_join(t0, NULL);
 
 	if (test->total_steps == test->current_step || test->fail) {
-		xsk_socket__delete(ifobj->xsk->xsk);
-		xsk_clear_xskmap(ifobj->xskmap);
-		testapp_clean_xsk_umem(ifobj);
+		if (ifobj2)
+			xsk_socket__delete(ifobj2->xsk->xsk);
+		xsk_socket__delete(ifobj1->xsk->xsk);
+		testapp_clean_xsk_umem(ifobj1);
+		if (ifobj2 && !ifobj2->shared_umem)
+			testapp_clean_xsk_umem(ifobj2);
 	}
 
-	test->ifobj_rx->shared_umem = old_shared_umem;
-	test->ifobj_tx->shared_umem = old_shared_umem;
-
 	return !!test->fail;
 }
 
 static int testapp_validate_traffic(struct test_spec *test)
 {
-	struct ifobject *ifobj_tx = test->ifobj_tx;
-	struct ifobject *ifobj_rx = test->ifobj_rx;
-	pthread_t t0, t1;
-
-	if (pthread_barrier_init(&barr, NULL, 2))
-		exit_with_error(errno);
-
-	test->current_step++;
-	pkt_stream_reset(ifobj_rx->pkt_stream);
-	pkts_in_flight = 0;
-
-	/*Spawn RX thread */
-	pthread_create(&t0, NULL, ifobj_rx->func_ptr, test);
-
-	pthread_barrier_wait(&barr);
-	if (pthread_barrier_destroy(&barr))
-		exit_with_error(errno);
-
-	/*Spawn TX thread */
-	pthread_create(&t1, NULL, ifobj_tx->func_ptr, test);
-
-	pthread_join(t1, NULL);
-	pthread_join(t0, NULL);
-
-	if (test->total_steps == test->current_step || test->fail) {
-		xsk_socket__delete(ifobj_tx->xsk->xsk);
-		xsk_socket__delete(ifobj_rx->xsk->xsk);
-		testapp_clean_xsk_umem(ifobj_rx);
-		if (!ifobj_tx->shared_umem)
-			testapp_clean_xsk_umem(ifobj_tx);
-	}
+	return __testapp_validate_traffic(test, test->ifobj_rx, test->ifobj_tx);
+}
 
-	return !!test->fail;
+static int testapp_validate_traffic_single_thread(struct test_spec *test, struct ifobject *ifobj)
+{
+	return __testapp_validate_traffic(test, ifobj, NULL);
 }
 
 static void testapp_teardown(struct test_spec *test)
@@ -1674,6 +1650,26 @@ static void testapp_xdp_drop(struct test_spec *test)
 	}
 }
 
+static void testapp_poll_txq_tmout(struct test_spec *test)
+{
+	test_spec_set_name(test, "POLL_TXQ_FULL");
+
+	test->ifobj_tx->use_poll = true;
+	/* create invalid frame by set umem frame_size and pkt length equal to 2048 */
+	test->ifobj_tx->umem->frame_size = 2048;
+	pkt_stream_replace(test, 2 * DEFAULT_PKT_CNT, 2048);
+	testapp_validate_traffic_single_thread(test, test->ifobj_tx);
+
+	pkt_stream_restore_default(test);
+}
+
+static void testapp_poll_rxq_tmout(struct test_spec *test)
+{
+	test_spec_set_name(test, "POLL_RXQ_EMPTY");
+	test->ifobj_rx->use_poll = true;
+	testapp_validate_traffic_single_thread(test, test->ifobj_rx);
+}
+
 static int xsk_load_xdp_programs(struct ifobject *ifobj)
 {
 	ifobj->xdp_progs = xsk_xdp_progs__open_and_load();
@@ -1784,18 +1780,10 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		testapp_validate_traffic(test);
 		break;
 	case TEST_TYPE_POLL_TXQ_TMOUT:
-		test_spec_set_name(test, "POLL_TXQ_FULL");
-		test->ifobj_tx->use_poll = true;
-		/* create invalid frame by set umem frame_size and pkt length equal to 2048 */
-		test->ifobj_tx->umem->frame_size = 2048;
-		pkt_stream_replace(test, 2 * DEFAULT_PKT_CNT, 2048);
-		testapp_validate_traffic_single_thread(test, test->ifobj_tx, type);
-		pkt_stream_restore_default(test);
+		testapp_poll_txq_tmout(test);
 		break;
 	case TEST_TYPE_POLL_RXQ_TMOUT:
-		test_spec_set_name(test, "POLL_RXQ_EMPTY");
-		test->ifobj_rx->use_poll = true;
-		testapp_validate_traffic_single_thread(test, test->ifobj_rx, type);
+		testapp_poll_rxq_tmout(test);
 		break;
 	case TEST_TYPE_ALIGNED_INV_DESC:
 		test_spec_set_name(test, "ALIGNED_INV_DESC");
-- 
2.34.1

