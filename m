Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5CAF69A6E1
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 09:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbjBQI0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 03:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjBQI0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 03:26:20 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D18A5F817;
        Fri, 17 Feb 2023 00:26:18 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id ml23-20020a17090b361700b00234463de251so507088pjb.3;
        Fri, 17 Feb 2023 00:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dsWPGE4uNMyVMUG7YACDGTy8ub0RCcGbyDw4MyN83aQ=;
        b=Yn46E9eaEOpHG1xEIx3/c7eXSqiHNJDJw5ePEiqJ94iF/1Ze7RyMJxGu5UXnSuzVXr
         FHnoUXKr5mP69NeZ+39k54Rb1arOF/9iXReKHuRrmDDOY4hAWrfOc4NXbOPZWtXqXV1X
         K8jbcvrzqT8lfNLcALivSvrOZ+B3Fb+V7Qx7eNEdORnge04vNm5qDWrUAuAHTHcHe5we
         A1rUvScyrxYVrFmNk2j4dWP4cOOj5k5kpBq9w3vLeA/DTo0TKtQx0wRziDk4sBt356sv
         ABIhhM9plrq10IJu7vHBV532NYHXxz42Sf0YzTv6raZpPrzLDeXIxvOBI7KelDQc25+G
         G8Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dsWPGE4uNMyVMUG7YACDGTy8ub0RCcGbyDw4MyN83aQ=;
        b=rJqH19TAEEvEMvHz5RybWkovgHqd3wjlJTU64AnRyt2jo+l7cK/9Ri+P4vep8dEXYz
         N1a8ONXdFEQjrKSdWO4WD7TE7GxwCekDydN8byAPEZGl4w+aicIWsOKU71eB+tevR02X
         VeVnl95TBoaGSYARcUlAxgUaZKkHWdE4e8kdd+b+2dzJ86700gvTttRHWd8wWwyOoPf8
         bGFiUDgew+aYHMhSm8WXGVcOrwlM1QjlRlFl27fVsYTPhzf7CGwPs3avxcilSp3M8Dvj
         HOBNpVIe/+mOzAV8MdOF+9zsOsU6Kg8ZImhkm8GaIK+//F+qlu2aCoFoEPGUczUfqbmv
         zMWA==
X-Gm-Message-State: AO0yUKWbH/cEQGlEsOGSyKVFl+Oa/UmuJ9KII0hpfRzzfVx4wz9ZURXY
        rVREMUL3sDqOuKszw/o4oeMK7Awpudg8jA==
X-Google-Smtp-Source: AK7set+WbFYuRckcoYB3qUNKABE8UWzS8ofYbU03gF+53fGlpFZ8XxMzayOmscE8dDIsFETGG55Hiw==
X-Received: by 2002:a17:90b:4f92:b0:22b:f0d4:9e1e with SMTP id qe18-20020a17090b4f9200b0022bf0d49e1emr99955pjb.8.1676622376976;
        Fri, 17 Feb 2023 00:26:16 -0800 (PST)
Received: from Laptop-X1.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id h14-20020a17090a604e00b002310ed024adsm562102pjm.12.2023.02.17.00.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 00:26:15 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Felix Maurer <fmaurer@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH bpf-next] selftests/bpf: run mptcp in a dedicated netns
Date:   Fri, 17 Feb 2023 16:26:07 +0800
Message-Id: <20230217082607.3309391-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
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

The current mptcp test is run in init netns. If the user or default
system config disabled mptcp, the test will fail. Let's run the mptcp
test in a dedicated netns to avoid none kernel default mptcp setting.

Suggested-by: Martin KaFai Lau <martin.lau@linux.dev>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../testing/selftests/bpf/prog_tests/mptcp.c  | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testing/selftests/bpf/prog_tests/mptcp.c
index 59f08d6d1d53..8a4ed9510ec7 100644
--- a/tools/testing/selftests/bpf/prog_tests/mptcp.c
+++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
@@ -7,6 +7,16 @@
 #include "network_helpers.h"
 #include "mptcp_sock.skel.h"
 
+#define SYS(fmt, ...)						\
+	({							\
+		char cmd[1024];					\
+		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);	\
+		if (!ASSERT_OK(system(cmd), cmd))		\
+			goto cmd_fail;				\
+	})
+
+#define NS_TEST "mptcp_ns"
+
 #ifndef TCP_CA_NAME_MAX
 #define TCP_CA_NAME_MAX	16
 #endif
@@ -138,12 +148,20 @@ static int run_test(int cgroup_fd, int server_fd, bool is_mptcp)
 
 static void test_base(void)
 {
+	struct nstoken *nstoken = NULL;
 	int server_fd, cgroup_fd;
 
 	cgroup_fd = test__join_cgroup("/mptcp");
 	if (!ASSERT_GE(cgroup_fd, 0, "test__join_cgroup"))
 		return;
 
+	SYS("ip netns add %s", NS_TEST);
+	SYS("ip -net %s link set dev lo up", NS_TEST);
+
+	nstoken = open_netns(NS_TEST);
+	if (!ASSERT_OK_PTR(nstoken, "open_netns"))
+		goto cmd_fail;
+
 	/* without MPTCP */
 	server_fd = start_server(AF_INET, SOCK_STREAM, NULL, 0, 0);
 	if (!ASSERT_GE(server_fd, 0, "start_server"))
@@ -163,6 +181,12 @@ static void test_base(void)
 
 	close(server_fd);
 
+cmd_fail:
+	if (nstoken)
+		close_netns(nstoken);
+
+	system("ip netns del " NS_TEST " >& /dev/null");
+
 close_cgroup_fd:
 	close(cgroup_fd);
 }
-- 
2.38.1

