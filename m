Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E68A6EA32
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 19:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731620AbfGSRbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 13:31:22 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36957 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731573AbfGSRbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 13:31:20 -0400
Received: by mail-qk1-f194.google.com with SMTP id d15so23794915qkl.4
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 10:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N+R2ea1tEKnOYXNzoo9m2ROYIh/qM2HPnBPxGnIkdkQ=;
        b=BKsEJ3v3ZS94sYuU/t2aaHruyRnKYAqrrc9cu3awBtV8DtZRkOTVLJWVvHl2vtWO0b
         GDOtE4E6kI1M5ZxHZH9bJbU0fgQR05DmnPySk29uSWiG3cqW8VnGAnufsSEvYA4ede7X
         giw0rrvom7HbgLMz5LCeMGjZeZqdZqy6zF8qHu8dyAf89HcL2E8oIEEEM6Mk36CiqqFY
         iBNtyub3FEU65zLQd69UFWC1pKfH35P60SzD/HOjdYYMn9KgtDzPoAyqyFFzOqV+r7TP
         /al3kmgyZp6a0yR0JqAMuNAwOi63z5sd9q0rxIrvAPHDpxm4qQl/7OTit8jOOLb2MqEq
         G5rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N+R2ea1tEKnOYXNzoo9m2ROYIh/qM2HPnBPxGnIkdkQ=;
        b=B4gLKBtw0WdsjX2MsN4FjLRJYT303N2YFQ8kQazUOWJkhqBfr7Z2Za0CUZE/WfQLDF
         RmjvQz3TfCD1QjOKifQTiW0s350LDmkYwqLxsdnkezur5Hix8fWtP3hxBylWF+k11f6A
         U0kR8hgKsdIaHYr30iiw3FTZU5oAM0MZrEvsimj4zBwDALvpdg4bzBKFjKkMqPmwZdTB
         qKZPc+9Z+LyVygGgIbe1GeF/DZcieA8PmopHoo/1A/IVoOTQFQs9L04GGOV5xtAqXVS9
         Gto+iemlkq9CRYBAjjFYNluqmxdksFquU09N1x//y+NXwAfDym9Fudxt+rwRiK7UC6YE
         vPnA==
X-Gm-Message-State: APjAAAVdGUVwyIU/SN1udtedNB8n0TS0i6D5Sgxj9MPXRRUumvlDeL6H
        dN4Dxk5IkDJ8VMGHUbYhAQC2ZA==
X-Google-Smtp-Source: APXvYqzrJf5pk7gDUSHmXQBjh95+wfb01Z1BxyQ6E2v++pRaw/BdH7EBtcQlNklcOD1j3SDC6i5wqA==
X-Received: by 2002:ae9:eb16:: with SMTP id b22mr31713340qkg.160.1563557479697;
        Fri, 19 Jul 2019 10:31:19 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm15568509qtj.46.2019.07.19.10.31.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 10:31:19 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     john.fastabend@gmail.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     edumazet@google.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH bpf v4 13/14] selftests/tls: close the socket with open record
Date:   Fri, 19 Jul 2019 10:29:26 -0700
Message-Id: <20190719172927.18181-14-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190719172927.18181-1-jakub.kicinski@netronome.com>
References: <20190719172927.18181-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add test which sends some data with MSG_MORE and then
closes the socket (never calling send without MSG_MORE).
This should make sure we clean up open records correctly.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 tools/testing/selftests/net/tls.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 6d78bd050813..94a86ca882de 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -239,6 +239,16 @@ TEST_F(tls, msg_more)
 	EXPECT_EQ(memcmp(buf, test_str, send_len), 0);
 }
 
+TEST_F(tls, msg_more_unsent)
+{
+	char const *test_str = "test_read";
+	int send_len = 10;
+	char buf[10];
+
+	EXPECT_EQ(send(self->fd, test_str, send_len, MSG_MORE), send_len);
+	EXPECT_EQ(recv(self->cfd, buf, send_len, MSG_DONTWAIT), -1);
+}
+
 TEST_F(tls, sendmsg_single)
 {
 	struct msghdr msg;
-- 
2.21.0

