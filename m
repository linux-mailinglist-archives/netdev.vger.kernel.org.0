Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C779140755
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 11:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgAQKHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 05:07:21 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:33615 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbgAQKHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 05:07:21 -0500
Received: by mail-pj1-f67.google.com with SMTP id u63so4096193pjb.0
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 02:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WOnGl5OuJwx/d+YXMa2JsH7/fPCW2u1Iq2/r/LIu+44=;
        b=TeUWz5nu0Xg2ImsacFCvsB6ze7gDYvcVisKMHRIc3uL8pKmk5JT6MQgodS9fgTNOV8
         BOVuSoxF6INWTQng5raIsNbApHek0fAjNhgJaXJBM4RYyyyML9EQo9KYNVryH+ncpg6i
         Cw95Llm49qEbzqlSLYjFJM1fXPnA7dAEzKxW7SGbBSbdihjuwSxCG1LVT/c78dvbmwnq
         AZmWu6mAD15ydtBAux2L8hU5qeXNU0Lmj8bSFMQxj8VHus869T2KMQx9u84/UJqZn84R
         a1oWbgKnbbN8+ZMXwpeiiq9uzvs/CBmcFYR/yS4GywDPMe0LvhLeiC2LM3g5stjN2sDR
         S4XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WOnGl5OuJwx/d+YXMa2JsH7/fPCW2u1Iq2/r/LIu+44=;
        b=TxYSBmx3XD3KaUbik0ytyVW44MNRToQ+bofWtZbn5pw7FkxTDnEQbVPwjbEHbHhazU
         JV0mkTcDUKr7fzLjeijXiCzFxiOy5QQvI0/oi0EDbE+qvSPJJA50xtYgkRiMM2hWKuYu
         FNvylEc5aP5bCZymT0l1jG3sziy/V11wqkJkWolyNmFwQ2Qt2dZYei5Rx7wkDmJecyiQ
         zAos7D2hQ8hWEbEnnBbHqz6cv9avl/0YaqsL2/wsIMZ4yuyWPYtwdJp2HFmQxmtXBi5W
         89T1x6aafwOCn4KuBf4S7vQFcTmbQZKPArTaa1JGh7Ucla2aKFFcIwLZKJyV2N03w9I/
         5aeA==
X-Gm-Message-State: APjAAAU3UpjPr4R3dcWKt0bPupOa8BcrxJtWDYIz2BKYRdqTBkoxrdfQ
        3HzpZHLncYaJ+7fVefuzCC50BmieRCY=
X-Google-Smtp-Source: APXvYqxyPddFJcX/D5t9+q9FjwmOouvggW3HnpXMMFkj4Q22cmzw1zMgO777ESY08SecNZppW+ofqA==
X-Received: by 2002:a17:902:8e85:: with SMTP id bg5mr38809561plb.32.1579255640228;
        Fri, 17 Jan 2020 02:07:20 -0800 (PST)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h3sm6575387pji.9.2020.01.17.02.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2020 02:07:19 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf] selftests/bpf: skip perf hw events test if the setup disabled it
Date:   Fri, 17 Jan 2020 18:06:56 +0800
Message-Id: <20200117100656.10359-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The same with commit 4e59afbbed96 ("selftests/bpf: skip nmi test when perf
hw events are disabled"), it would make more sense to skip the
test_stacktrace_build_id_nmi test if the setup (e.g. virtual machines) has
disabled hardware perf events.

Fixes: 13790d1cc72c ("bpf: add selftest for stackmap with build_id in NMI context")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../selftests/bpf/prog_tests/stacktrace_build_id_nmi.c    | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
index f62aa0eb959b..437cb93e72ac 100644
--- a/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
+++ b/tools/testing/selftests/bpf/prog_tests/stacktrace_build_id_nmi.c
@@ -49,8 +49,12 @@ void test_stacktrace_build_id_nmi(void)
 	pmu_fd = syscall(__NR_perf_event_open, &attr, -1 /* pid */,
 			 0 /* cpu 0 */, -1 /* group id */,
 			 0 /* flags */);
-	if (CHECK(pmu_fd < 0, "perf_event_open",
-		  "err %d errno %d. Does the test host support PERF_COUNT_HW_CPU_CYCLES?\n",
+	if (pmu_fd < 0 && errno == ENOENT) {
+		printf("%s:SKIP:no PERF_COUNT_HW_CPU_CYCLES\n", __func__);
+		test__skip();
+		goto close_prog;
+	}
+	if (CHECK(pmu_fd < 0, "perf_event_open", "err %d errno %d\n",
 		  pmu_fd, errno))
 		goto close_prog;
 
-- 
2.19.2

