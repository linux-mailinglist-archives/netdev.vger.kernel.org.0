Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7718B6F47C0
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 17:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbjEBPwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 11:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234652AbjEBPwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 11:52:37 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B5D319F;
        Tue,  2 May 2023 08:52:23 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1aaf2ede38fso25948685ad.2;
        Tue, 02 May 2023 08:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683042742; x=1685634742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I/e44MTh7M407OJ1hC7xQsEWYl13ekNij3tNSRQR2hY=;
        b=fIKFTZNI4Zg4JufEWjjAuWrvmy9H2j/eZkSdhqgB373TfvzZ0otAmxyHywhEMSQ0Er
         tkgzMy4+S88e4HkQdjuOth/GvpBn7LeNXJmAzyAyC+7uUeBB3AYDrx3975J9B84zg9JA
         jOSo8lT+SZzAycAd+kURO0rGPdORh6igYpdRYCk+h5Txrh22tQIPT2gL7Bzw/Zl+sUr7
         lmAL0uQJAt6g99Np5wkwlVUbSafmkaiCiFd9mN2qu17hERjY+I8KJQXHnHe4LgNQTcY2
         zK5OXt8Ed4fSaLXNZXsudLI0n+1rzaD1Kg4Pp8cCAOGF21e/5073lJJSBYt2LFBknRpY
         aUKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683042742; x=1685634742;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I/e44MTh7M407OJ1hC7xQsEWYl13ekNij3tNSRQR2hY=;
        b=JL7mr1JNNpS+U5dq3aiBkHbLea7b4HzRcKmUl5qj+3pJLNUuNtX9zU3YrxIpY800E7
         4bVD82wYebqd9m89u3CYsKgg0xWDjA4L3Ypjo0fZgVir2eLipPOtxUaOAaeGARH8pTze
         J2r9DaKgPW7/NfbQtTctGh2Tsc/AGwmWTMYY73GEsfPdeg+H/N7OwdZNtWVJJUThhXB0
         XgEibwbT/4hagwbhLsxVrfIkHKUaqnnw6UoS2r0Kewv6zTlZDqPI4SLjCNNtaEAln2/6
         89jewW6J2TQyqrK4rlPn2FG/oR6poDOEapkIwEmoNbYtVuV8aPKJMAPdqvcyp40rWc08
         hjaA==
X-Gm-Message-State: AC+VfDwXXUx3h47qZRrLjwy9nuj0CnWcn9AvnT9mmmh2700svig3Lh/M
        oSwhctrvh1qebWzBYxZZg0Y=
X-Google-Smtp-Source: ACHHUZ5f1YNsEhJDJKJpJsn4xbnR6TyQcfS/8pfUpCYHeoFW5zLgDVrf1+oltUv62EzCN3Ga9yhJaQ==
X-Received: by 2002:a17:902:7d85:b0:1ab:17dc:d495 with SMTP id a5-20020a1709027d8500b001ab17dcd495mr561495plm.27.1683042742459;
        Tue, 02 May 2023 08:52:22 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:62ab:a7fd:a4e3:bd70])
        by smtp.gmail.com with ESMTPSA id o3-20020a170902778300b001a1a07d04e6sm19917212pll.77.2023.05.02.08.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 08:52:22 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net, lmb@isovalent.com,
        edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v7 12/13] bpf: sockmap, test FIONREAD returns correct bytes in rx buffer
Date:   Tue,  2 May 2023 08:51:58 -0700
Message-Id: <20230502155159.305437-13-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230502155159.305437-1-john.fastabend@gmail.com>
References: <20230502155159.305437-1-john.fastabend@gmail.com>
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

A bug was reported where ioctl(FIONREAD) returned zero even though the
socket with a SK_SKB verdict program attached had bytes in the msg
queue. The result is programs may hang or more likely try to recover,
but use suboptimal buffer sizes.

Add a test to check that ioctl(FIONREAD) returns the correct number of
bytes.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/prog_tests/sockmap_basic.c  | 48 +++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index f9f611618e45..322b5a135740 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -416,6 +416,52 @@ static void test_sockmap_skb_verdict_shutdown(void)
 	test_sockmap_pass_prog__destroy(skel);
 }
 
+static void test_sockmap_skb_verdict_fionread(void)
+{
+	int err, map, verdict, s, c0, c1, p0, p1;
+	struct test_sockmap_pass_prog *skel;
+	int zero = 0, sent, recvd, avail;
+	char buf[256] = "0123456789";
+
+	skel = test_sockmap_pass_prog__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		return;
+
+	verdict = bpf_program__fd(skel->progs.prog_skb_verdict);
+	map = bpf_map__fd(skel->maps.sock_map_rx);
+
+	err = bpf_prog_attach(verdict, map, BPF_SK_SKB_STREAM_VERDICT, 0);
+	if (!ASSERT_OK(err, "bpf_prog_attach"))
+		goto out;
+
+	s = socket_loopback(AF_INET, SOCK_STREAM);
+	if (!ASSERT_GT(s, -1, "socket_loopback(s)"))
+		goto out;
+	err = create_socket_pairs(s, AF_INET, SOCK_STREAM, &c0, &c1, &p0, &p1);
+	if (!ASSERT_OK(err, "create_socket_pairs(s)"))
+		goto out;
+
+	err = bpf_map_update_elem(map, &zero, &c1, BPF_NOEXIST);
+	if (!ASSERT_OK(err, "bpf_map_update_elem(c1)"))
+		goto out_close;
+
+	sent = xsend(p1, &buf, sizeof(buf), 0);
+	ASSERT_EQ(sent, sizeof(buf), "xsend(p0)");
+	err = ioctl(c1, FIONREAD, &avail);
+	ASSERT_OK(err, "ioctl(FIONREAD) error");
+	ASSERT_EQ(avail, sizeof(buf), "ioctl(FIONREAD)");
+	recvd = recv_timeout(c1, &buf, sizeof(buf), SOCK_NONBLOCK, IO_TIMEOUT_SEC);
+	ASSERT_EQ(recvd, sizeof(buf), "recv_timeout(c0)");
+
+out_close:
+	close(c0);
+	close(p0);
+	close(c1);
+	close(p1);
+out:
+	test_sockmap_pass_prog__destroy(skel);
+}
+
 void test_sockmap_basic(void)
 {
 	if (test__start_subtest("sockmap create_update_free"))
@@ -452,4 +498,6 @@ void test_sockmap_basic(void)
 		test_sockmap_progs_query(BPF_SK_SKB_VERDICT);
 	if (test__start_subtest("sockmap skb_verdict shutdown"))
 		test_sockmap_skb_verdict_shutdown();
+	if (test__start_subtest("sockmap skb_verdict fionread"))
+		test_sockmap_skb_verdict_fionread();
 }
-- 
2.33.0

