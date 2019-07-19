Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C319A6EA36
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 19:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731640AbfGSRbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 13:31:25 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38211 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731556AbfGSRbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 13:31:22 -0400
Received: by mail-qk1-f193.google.com with SMTP id a27so23812546qkk.5
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 10:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v9pxN+7gjk03qL7CRFdYVls1HBWJfJg+h1DcC3IAeAU=;
        b=yZizlLNjHZQx7cxD3ZD23WidJVkLZeFgm0V07gDv4kc92hRjqL+bmFlD6oGpmbanoi
         X5RLb6sV2NxH0unvhOv+RuT6utcRH2ZpT5YUAOFOqxdGu6oOUR8H5+4v7WQG+hcg3+Tj
         z3+aWhiDQr4ginPjBb2Q78T8juj/VdaatufRKrdJhu3OCxgbyG7+WpG8yV7cQVkfWwYP
         zZiGDEoWRETBR7OCFhf3xba985jcR3RLbgo1EyDXC3/7wGkzo7/kEenPWQ8MF0lx8Tpn
         DPOPrQW7ArWHWkLwMnoOYlrvna/o84Mrkr2+hoKbkzkKUvJPtric/5GNVev0WcOi3WGO
         zeOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v9pxN+7gjk03qL7CRFdYVls1HBWJfJg+h1DcC3IAeAU=;
        b=SqY2QyPAvrL1OCHkMK9U279hjCuwmVnpse7BW/WeWrY0t61nDC/rzQpoiew+QJFfBT
         SFHjLWi2WxBJRlfhNjYaSZ1OmN1AeZfVDaUoXicoC9J7lVyrkJfjLeg9ssxc7kmWWALz
         VI0lun+xNnB+SfvHO9ISjwKq+rHhWYk9cAScTeZIduqG4MLYZ6MLgES54P5aJ7ojL54c
         MCvLhDlyeIEOMGooWpOe/ekyJ8XydYIH+0TZdIfq4mh5bICRxBu9CjqOrwBmREm7bnmP
         kysuTQWMOsqZcuZWKhXZe1c2+/WKz1NaP5A33PgitMccEZCoHzNd/UV4osr1+u/I11tu
         1aBw==
X-Gm-Message-State: APjAAAVrYB1r7ZMtlP7e363phSnVL1wpyYUIz+1PqRdTEvEnz9Fvcv4h
        5YeQ1EmQumcoD7laUrL1iu6zpBoxkS8=
X-Google-Smtp-Source: APXvYqyBlhieHfpS6Q2xbEu766mRiGMUiwe57hv3Icv1K7dkvMBJVMZKN96DwD0SSyqb2inPBgBORg==
X-Received: by 2002:a37:404b:: with SMTP id n72mr35536907qka.109.1563557481142;
        Fri, 19 Jul 2019 10:31:21 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm15568509qtj.46.2019.07.19.10.31.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 10:31:20 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     edumazet@google.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH bpf v4 14/14] selftests/tls: add shutdown tests
Date:   Fri, 19 Jul 2019 10:29:27 -0700
Message-Id: <20190719172927.18181-15-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190719172927.18181-1-jakub.kicinski@netronome.com>
References: <20190719172927.18181-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add test for killing the connection via shutdown.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 tools/testing/selftests/net/tls.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 94a86ca882de..630c5b884d43 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -952,6 +952,33 @@ TEST_F(tls, control_msg)
 	EXPECT_EQ(memcmp(buf, test_str, send_len), 0);
 }
 
+TEST_F(tls, shutdown)
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
+
+	shutdown(self->fd, SHUT_RDWR);
+	shutdown(self->cfd, SHUT_RDWR);
+}
+
+TEST_F(tls, shutdown_unsent)
+{
+	char const *test_str = "test_read";
+	int send_len = 10;
+
+	EXPECT_EQ(send(self->fd, test_str, send_len, MSG_MORE), send_len);
+
+	shutdown(self->fd, SHUT_RDWR);
+	shutdown(self->cfd, SHUT_RDWR);
+}
+
 TEST(non_established) {
 	struct tls12_crypto_info_aes_gcm_256 tls12;
 	struct sockaddr_in addr;
-- 
2.21.0

