Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD6A1EFD2C
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 18:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgFEQB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 12:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbgFEQB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 12:01:28 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B01C08C5C2;
        Fri,  5 Jun 2020 09:01:28 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id d27so8885770qtg.4;
        Fri, 05 Jun 2020 09:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=j77v7Mz7CImgtiCr19DSAINgUNmrJJfsngrEQ/XEJCc=;
        b=Hp267K0S7jJ3ohXY1IyKSvgG0BRyc20OmO7TN+7Q45uiPBgNj8RvcYKB72cc9h13bg
         WnhVyD0xlR+UeJRILf4Lixycjz8dvSziaR1OCvkiKYPZ1HTfkChvSiJkTS0imjSVwJ94
         6SotmyEN6tUhScd2iWiB2AVKsm30eUw6nDdb+Pl0SLIyDwOPhOIDiX7wcl66AQJDzw5C
         uEJFniHntOYiswhvAJgcLAKjksoBGlrgxOPee4M0l0QeRg63Uf8nLTqWCnYyi4FaAKo/
         HjKUA3j965p/qp7m91LN367bMU3t1QgCcUlTVKDdTN5gxarafdlihxW1GkWKp2xNpOhy
         K0aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=j77v7Mz7CImgtiCr19DSAINgUNmrJJfsngrEQ/XEJCc=;
        b=Eyj/gwThHP33XzZ1myoq1KbkGzcAIYHmZBDOaDNhbOiH8NqbFd3boGlitJKtrD7Fra
         gYDINl0AerjIDujWK/1LNyfiQd8C4utoim8HTIkOEtlpm2pDlehCgerrpJNnjjRLI9M3
         RaCKJeKqG2vFHfRmNK3k2t2AqnjNIgObkxWd5BOH6OVejC0Hr/niUPBjFWfYJqOKOSLc
         Gv6w5sIf2uijsVLg5RyQU/VqyQ3708W4HXoJaMdtQxKcf4s1ecsfXibdkDmlhI9TqjTE
         VITWD8WJqA/rW85kEg+M/iOwUT1NvnOsOn0jT/Txh4wQ4qwddoE6yK5VIU7rbyBDtJyQ
         btsg==
X-Gm-Message-State: AOAM530BGRbBrhw9Me+NqfOuv/VF+ZQlRlKZfDTe7FZ/Dg3Z6cIAXbHO
        Zo5B6cVScHI7jZYRJ0A2Ux0=
X-Google-Smtp-Source: ABdhPJyQ6UCqe6R/r6uJkbxjfgEUH6fmgdm577ZDYW+qJn18Ua9oUobrTwF9dZFgQFJinYCJTaPi2g==
X-Received: by 2002:ac8:440b:: with SMTP id j11mr11285450qtn.62.1591372886072;
        Fri, 05 Jun 2020 09:01:26 -0700 (PDT)
Received: from kvmhost.ch.hwng.net (kvmhost.ch.hwng.net. [69.16.191.151])
        by smtp.gmail.com with ESMTPSA id w204sm133030qka.41.2020.06.05.09.01.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jun 2020 09:01:25 -0700 (PDT)
From:   Pooja Trivedi <poojatrivedi@gmail.com>
X-Google-Original-From: Pooja Trivedi <pooja.trivedi@stackpath.com>
To:     borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net, kuba@kernel.org,
        davem@davemloft.net, vakul.garg@nxp.com, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        mallesham.jatharkonda@oneconvergence.com, josh.tway@stackpath.com,
        pooja.trivedi@stackpath.com
Subject: [PATCH net] net/tls(TLS_SW): Add selftest for 'chunked' sendfile test
Date:   Fri,  5 Jun 2020 16:01:18 +0000
Message-Id: <1591372878-10314-1-git-send-email-pooja.trivedi@stackpath.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This selftest tests for cases where sendfile's 'count'
parameter is provided with a size greater than the intended
file size.

Motivation: When sendfile is provided with 'count' parameter
value that is greater than the size of the file, kTLS example
fails to send the file correctly. Last chunk of the file is
not sent, and the data integrity is compromised.
The reason is that the last chunk has MSG_MORE flag set
because of which it gets added to pending records, but is
not pushed.
Note that if user space were to send SSL_shutdown control
message, pending records would get flushed and the issue
would not happen. So a shutdown control message following
sendfile can mask the issue.

Signed-off-by: Pooja Trivedi <pooja.trivedi@stackpath.com>
Signed-off-by: Mallesham Jatharkonda <mallesham.jatharkonda@oneconvergence.com>
Signed-off-by: Josh Tway <josh.tway@stackpath.com>

---
 tools/testing/selftests/net/tls.c | 58 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 0ea44d9..83b6705 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -198,6 +198,64 @@
 	EXPECT_EQ(recv(self->cfd, buf, st.st_size, MSG_WAITALL), st.st_size);
 }
 
+static void chunked_sendfile(struct __test_metadata *_metadata,
+			     struct _test_data_tls *self,
+			     uint16_t chunk_size,
+			     uint16_t extra_payload_size)
+{
+	char buf[TLS_PAYLOAD_MAX_LEN];
+	uint16_t test_payload_size;
+	int size = 0;
+	int ret;
+	char filename[] = "/tmp/mytemp.XXXXXX";
+	int fd = mkstemp(filename);
+	off_t offset = 0;
+
+	unlink(filename);
+	ASSERT_GE(fd, 0);
+	EXPECT_GE(chunk_size, 1);
+	test_payload_size = chunk_size + extra_payload_size;
+	ASSERT_GE(TLS_PAYLOAD_MAX_LEN, test_payload_size);
+	memset(buf, 1, test_payload_size);
+	size = write(fd, buf, test_payload_size);
+	EXPECT_EQ(size, test_payload_size);
+	fsync(fd);
+
+	while (size > 0) {
+		ret = sendfile(self->fd, fd, &offset, chunk_size);
+		EXPECT_GE(ret, 0);
+		size -= ret;
+	}
+
+	EXPECT_EQ(recv(self->cfd, buf, test_payload_size, MSG_WAITALL),
+		  test_payload_size);
+
+	close(fd);
+}
+
+TEST_F(tls, multi_chunk_sendfile)
+{
+	chunked_sendfile(_metadata, self, 4096, 4096);
+	chunked_sendfile(_metadata, self, 4096, 0);
+	chunked_sendfile(_metadata, self, 4096, 1);
+	chunked_sendfile(_metadata, self, 4096, 2048);
+	chunked_sendfile(_metadata, self, 8192, 2048);
+	chunked_sendfile(_metadata, self, 4096, 8192);
+	chunked_sendfile(_metadata, self, 8192, 4096);
+	chunked_sendfile(_metadata, self, 12288, 1024);
+	chunked_sendfile(_metadata, self, 12288, 2000);
+	chunked_sendfile(_metadata, self, 15360, 100);
+	chunked_sendfile(_metadata, self, 15360, 300);
+	chunked_sendfile(_metadata, self, 1, 4096);
+	chunked_sendfile(_metadata, self, 2048, 4096);
+	chunked_sendfile(_metadata, self, 2048, 8192);
+	chunked_sendfile(_metadata, self, 4096, 8192);
+	chunked_sendfile(_metadata, self, 1024, 12288);
+	chunked_sendfile(_metadata, self, 2000, 12288);
+	chunked_sendfile(_metadata, self, 100, 15360);
+	chunked_sendfile(_metadata, self, 300, 15360);
+}
+
 TEST_F(tls, recv_max)
 {
 	unsigned int send_len = TLS_PAYLOAD_MAX_LEN;
-- 
1.8.3.1

