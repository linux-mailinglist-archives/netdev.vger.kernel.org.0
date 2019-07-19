Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 018006EA2C
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 19:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731523AbfGSRbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 13:31:17 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41723 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731492AbfGSRbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 13:31:16 -0400
Received: by mail-qt1-f194.google.com with SMTP id d17so31752414qtj.8
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 10:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+VvFeyw1azZq//RJ4RswMMne/9sZEWOtXmC4Y/HkVhg=;
        b=Gz8vfa1BvZwIYVZF7NblfQU7jC31feP2eoeZkRbusEVGjLSJO+Kt+snMb1kssn7zpF
         METbVky0Gi+bsZC8nV6Hf84xC5XdQO0Eb9nKHWgQ1vHTcvvioA9hDNHciNC8WXjJFo5Z
         Fls0HvKEUFVCMQlCfqebMSyvJErdysS8N8z7ngg8oWW8X7ZFEP3/Q/VZXTE2pXYAtzK4
         HbpRG0eoZButSvyjjZhfF0cUFchyfW2u9fTDfy+bZfQkI4KMnDPeOlMP77niNuP6yOVe
         xmH77aB53OFFfrdYWHzwtTF/F8CaO9BxAlsQtl66EMYUYg+mBjN229A1+vZUV4DzWfGS
         sDPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+VvFeyw1azZq//RJ4RswMMne/9sZEWOtXmC4Y/HkVhg=;
        b=sZQr3anOJe96/rZ43l30qtm/ahy8GEdDmESywCq0ri4FINnjUdsChfI65yzjf+gkrn
         EfX5evcHMkjQUZ8ZsFGVB0zB+eijecFlkQqdNK3CxZS31WQshqnzUWmTQ7jOh7+oxJGa
         ZSZ4zQiYnQxfdkOgY7aPILdelzbZmtyl3gQkIE+HPK3vOoPGyLwbtrZAdIxIPUtp8F7D
         6SacwVKseneTZxoGghVuZppPefjZ8SMcFTtOmceUqkNs6p58Lck66MI4T5c8/pOqcSjq
         dJwrK/REvkjv5/El1Qu3eE5FsO2Y9JrtniqcYZFe4Nzxd7j/ZlmOYv5wCiz3Ym4OYdt0
         TcOw==
X-Gm-Message-State: APjAAAXHF3bbADBrYc5FMgNAFAn7IeMWrkvwdqnJz85ZsYFt75Be/o55
        vXt8Jy8TCIxGhnravolD29R/FA==
X-Google-Smtp-Source: APXvYqxc38bhYZIZAj9hVQsSEWG4zo8HA1tRTDKp/YtbJ7hdBylj73GihOxuQtTHus0S4gdE/Vcqlg==
X-Received: by 2002:a0c:9895:: with SMTP id f21mr38011254qvd.123.1563557475147;
        Fri, 19 Jul 2019 10:31:15 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm15568509qtj.46.2019.07.19.10.31.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 10:31:14 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     edumazet@google.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH bpf v4 10/14] selftests/tls: add a test for ULP but no keys
Date:   Fri, 19 Jul 2019 10:29:23 -0700
Message-Id: <20190719172927.18181-11-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190719172927.18181-1-jakub.kicinski@netronome.com>
References: <20190719172927.18181-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure we test the TLS_BASE/TLS_BASE case both with data
and the tear down/clean up path.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 tools/testing/selftests/net/tls.c | 74 +++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 090fff9dbc48..194826fee4f7 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -25,6 +25,80 @@
 #define TLS_PAYLOAD_MAX_LEN 16384
 #define SOL_TLS 282
 
+#ifndef ENOTSUPP
+#define ENOTSUPP 524
+#endif
+
+FIXTURE(tls_basic)
+{
+	int fd, cfd;
+	bool notls;
+};
+
+FIXTURE_SETUP(tls_basic)
+{
+	struct sockaddr_in addr;
+	socklen_t len;
+	int sfd, ret;
+
+	self->notls = false;
+	len = sizeof(addr);
+
+	addr.sin_family = AF_INET;
+	addr.sin_addr.s_addr = htonl(INADDR_ANY);
+	addr.sin_port = 0;
+
+	self->fd = socket(AF_INET, SOCK_STREAM, 0);
+	sfd = socket(AF_INET, SOCK_STREAM, 0);
+
+	ret = bind(sfd, &addr, sizeof(addr));
+	ASSERT_EQ(ret, 0);
+	ret = listen(sfd, 10);
+	ASSERT_EQ(ret, 0);
+
+	ret = getsockname(sfd, &addr, &len);
+	ASSERT_EQ(ret, 0);
+
+	ret = connect(self->fd, &addr, sizeof(addr));
+	ASSERT_EQ(ret, 0);
+
+	self->cfd = accept(sfd, &addr, &len);
+	ASSERT_GE(self->cfd, 0);
+
+	close(sfd);
+
+	ret = setsockopt(self->fd, IPPROTO_TCP, TCP_ULP, "tls", sizeof("tls"));
+	if (ret != 0) {
+		ASSERT_EQ(errno, ENOTSUPP);
+		self->notls = true;
+		printf("Failure setting TCP_ULP, testing without tls\n");
+		return;
+	}
+
+	ret = setsockopt(self->cfd, IPPROTO_TCP, TCP_ULP, "tls", sizeof("tls"));
+	ASSERT_EQ(ret, 0);
+}
+
+FIXTURE_TEARDOWN(tls_basic)
+{
+	close(self->fd);
+	close(self->cfd);
+}
+
+/* Send some data through with ULP but no keys */
+TEST_F(tls_basic, base_base)
+{
+	char const *test_str = "test_read";
+	int send_len = 10;
+	char buf[10];
+
+	ASSERT_EQ(strlen(test_str) + 1, send_len);
+
+	EXPECT_EQ(send(self->fd, test_str, send_len, 0), send_len);
+	EXPECT_NE(recv(self->cfd, buf, send_len, 0), -1);
+	EXPECT_EQ(memcmp(buf, test_str, send_len), 0);
+};
+
 FIXTURE(tls)
 {
 	int fd, cfd;
-- 
2.21.0

