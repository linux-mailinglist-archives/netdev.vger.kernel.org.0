Return-Path: <netdev+bounces-2945-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97AC8704A9D
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 12:32:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51EB12816B7
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:32:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B19618C17;
	Tue, 16 May 2023 10:31:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBC61EA72;
	Tue, 16 May 2023 10:31:43 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0824035AE;
	Tue, 16 May 2023 03:31:21 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f50020e0f6so5219965e9.1;
        Tue, 16 May 2023 03:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684233079; x=1686825079;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ASka55VrLqiFr/6jVKdTK/R93eQuRd6b7korf0ZyN2U=;
        b=ShcmuTO6vJMVBap6HZJg5dMWyQDEzFDEZv/aWiwvqeUzcmPfOHpNOz9zS6Iq+6+EIa
         uOxWIV3gv6vyK2PqIWc0pqZjthOOGpryCO27L+K2CG6EIX8zzGDH4WlbFUFzVnMqYOnN
         Lj18PWRAzItOqFq3Fk67dEfRixH5zKFQaDjayakIKdSNNrDfsuczIhpC8eVOLUNSOWCL
         qRNwjL2IluhqNn41NORq3xbYhr5BTRqQKeufiTafHMbnvRKRY0H2aDhXwYx0x9n2+lqK
         7gqkHr1L1waE4eh07DsxWcg8kcKYwRgr2X00izPbiihq3UbmLsYEtGFcb9YqO0erfIHn
         dZcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684233079; x=1686825079;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ASka55VrLqiFr/6jVKdTK/R93eQuRd6b7korf0ZyN2U=;
        b=WwKWzS7yrYqe3d/+mfV/pkR125CNQcrAf1WWon++Yl+ucuroH2fxPkyZDEx17/peMZ
         o5ja2vaHizDMICclrs7RqqiuefX9wMPaAOd5cZfJ3/IgbCaP5Rlv7pf11Jqjni6WcPAy
         jkYd1c2LyL0qpdR5LcXerZBauaitLJ/X648QY9NnpGMnk4K1deED1xIBl22+y9xwIoTe
         jSQEVu9iNIHM2AEnVBcDpQSxJxbFpdunDXjAEoamqIui61H8bLDOouhXa81Fp/e5ErQJ
         3rfHd7SwC8Mt8ZTEZ5Q+S44eio8bqT9nqdX0CTpbQNHj7OqfSujqGi+YSzGP2GXjJElh
         v8FQ==
X-Gm-Message-State: AC+VfDyFLipQrf989xLoNmEBgf6Gj8uEZkUpu5nSMnWX8x8s2G8Gz5l4
	RyIRCZVnjo1RB3AQILMtl/I=
X-Google-Smtp-Source: ACHHUZ7iNSzFRsWYxve+RcNZBBmwEpNHA9uMQzC9V1X44M1xvbuIFOYlhPsA1hXJrdmOglQC/IiISA==
X-Received: by 2002:a05:600c:3541:b0:3f5:c6f:d204 with SMTP id i1-20020a05600c354100b003f50c6fd204mr1850679wmq.2.1684233078979;
        Tue, 16 May 2023 03:31:18 -0700 (PDT)
Received: from localhost.localdomain (h-176-10-144-222.NA.cust.bahnhof.se. [176.10.144.222])
        by smtp.gmail.com with ESMTPSA id u25-20020a7bc059000000b003f32f013c3csm1888402wmc.6.2023.05.16.03.31.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 May 2023 03:31:18 -0700 (PDT)
From: Magnus Karlsson <magnus.karlsson@gmail.com>
To: magnus.karlsson@intel.com,
	bjorn@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	netdev@vger.kernel.org,
	maciej.fijalkowski@intel.com,
	bpf@vger.kernel.org,
	yhs@fb.com,
	andrii@kernel.org,
	martin.lau@linux.dev,
	song@kernel.org,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@google.com,
	haoluo@google.com,
	jolsa@kernel.org,
	tirthendu.sarkar@intel.com
Subject: [PATCH bpf-next v2 01/10] selftests/xsk: do not change XDP program when not necessary
Date: Tue, 16 May 2023 12:31:00 +0200
Message-Id: <20230516103109.3066-2-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230516103109.3066-1-magnus.karlsson@gmail.com>
References: <20230516103109.3066-1-magnus.karlsson@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Magnus Karlsson <magnus.karlsson@intel.com>

Do not change the XDP program for the Tx thread when not needed. It
was erroneously compared to the XDP program for the Rx thread, which
is always going to be different, which meant that the code made
unnecessary switches to the same program it had before. This did not
affect functionality, just performance.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index f144d0604ddf..f7950af576e1 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1402,11 +1402,20 @@ static void handler(int signum)
 	pthread_exit(NULL);
 }
 
-static bool xdp_prog_changed(struct test_spec *test, struct ifobject *ifobj)
+static bool xdp_prog_changed_rx(struct test_spec *test)
 {
+	struct ifobject *ifobj = test->ifobj_rx;
+
 	return ifobj->xdp_prog != test->xdp_prog_rx || ifobj->mode != test->mode;
 }
 
+static bool xdp_prog_changed_tx(struct test_spec *test)
+{
+	struct ifobject *ifobj = test->ifobj_tx;
+
+	return ifobj->xdp_prog != test->xdp_prog_tx || ifobj->mode != test->mode;
+}
+
 static void xsk_reattach_xdp(struct ifobject *ifobj, struct bpf_program *xdp_prog,
 			     struct bpf_map *xskmap, enum test_mode mode)
 {
@@ -1433,13 +1442,13 @@ static void xsk_reattach_xdp(struct ifobject *ifobj, struct bpf_program *xdp_pro
 static void xsk_attach_xdp_progs(struct test_spec *test, struct ifobject *ifobj_rx,
 				 struct ifobject *ifobj_tx)
 {
-	if (xdp_prog_changed(test, ifobj_rx))
+	if (xdp_prog_changed_rx(test))
 		xsk_reattach_xdp(ifobj_rx, test->xdp_prog_rx, test->xskmap_rx, test->mode);
 
 	if (!ifobj_tx || ifobj_tx->shared_umem)
 		return;
 
-	if (xdp_prog_changed(test, ifobj_tx))
+	if (xdp_prog_changed_tx(test))
 		xsk_reattach_xdp(ifobj_tx, test->xdp_prog_tx, test->xskmap_tx, test->mode);
 }
 
-- 
2.34.1


