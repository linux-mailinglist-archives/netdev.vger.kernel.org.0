Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40BF669BEDA
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 08:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjBSHBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 02:01:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBSHBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 02:01:49 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1679A1166F;
        Sat, 18 Feb 2023 23:01:46 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id b4-20020a17090a800400b00229eec90a7fso202674pjn.0;
        Sat, 18 Feb 2023 23:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qfJkHMMisOq3RuXOIR8+nfpzl2qNn0HErgnT1e8I+sM=;
        b=o70ejizjG0urg79BCKhprsll7qcNYATLv+u4WS7msZ1WJWKfH6tuTEYOR5TGWMAQ6L
         CSA7+0cftdEFIy34hbfXNY9KPDv5GFAvZgR8WZiMsTDFcMcxxd3VQ+0fjyuQV810XuGQ
         UACXq22XzSddtQQz46zkWh64o7cW4Zl9vz9eeVhq2jJBLGcqjxc+kZnlXbbzK+ivJ0ry
         wqGlWJSkyd8PzebaWpGBHPrsIESTqbZsP+3SFQ0dSz4Zj4SXbI03EE74usgRtHP4Ly3L
         qO71m0wFAWNQ+KRdDI0TgEqHenhbQGJPsmz3kR8shUwtznJfRuVpVipvsdiJY5VzdUKK
         wzmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qfJkHMMisOq3RuXOIR8+nfpzl2qNn0HErgnT1e8I+sM=;
        b=1O9WfGgdor6jNjFuKQ5J14OBStAxKyf1HPU5FrF0BNVekuORFbLWaMKa5dM+LM83xX
         GsWl1jT3MzcRe/FVoQ2wrgI5iPtgcs9XkrsfMZYP3s/1kseqmRBnhRNFpBoZI5xapHyd
         uK5P2wKfcu6iZYe0yPmau9ahoiAUg6nAIKHHy76TiQRktFT53B8jTWqPhcopBqu0voDx
         7n5CS+lZGPyjyNW+yfzF/3GIi8pHm2NqH5+vDDsHuvuEXj/EgctKHGfT/ju8eMDR+IBH
         3CQXVOR70hbrWAcHG6pT9mOKfD45wsDo5ZDaqjSTI/2ynCBNkM7AY8eLC46FI06Hwx4J
         FFAg==
X-Gm-Message-State: AO0yUKWCwpV0fx1HflYhyv1u+YesWyeQu9YCLziDwZ9+jjzuTO5bhV7Y
        /jfSdtZOmdLEwKc9nad1sMIut10IH40AiQ==
X-Google-Smtp-Source: AK7set+412x7KtecLuZPxcpcAxyHwNVewZ20/HkYRFKZWkTORg2Wq1u3dxzhw/PnyjKovnpAWjiobA==
X-Received: by 2002:a17:902:a513:b0:19a:7d50:aeff with SMTP id s19-20020a170902a51300b0019a7d50aeffmr18895plq.41.1676790104686;
        Sat, 18 Feb 2023 23:01:44 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b4-20020a170902d30400b0019a928a8982sm741056plc.118.2023.02.18.23.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Feb 2023 23:01:43 -0800 (PST)
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
        mptcp@lists.linux.dev, Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 bpf-next] selftests/bpf: run mptcp in a dedicated netns
Date:   Sun, 19 Feb 2023 15:01:24 +0800
Message-Id: <20230219070124.3900561-1-liuhangbin@gmail.com>
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
v2: remove unneed close_cgroup_fd goto label.
---
 .../testing/selftests/bpf/prog_tests/mptcp.c  | 27 +++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testing/selftests/bpf/prog_tests/mptcp.c
index 59f08d6d1d53..dbe2bcfd3b38 100644
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
+			goto fail;				\
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
+		goto fail;
+
 	/* without MPTCP */
 	server_fd = start_server(AF_INET, SOCK_STREAM, NULL, 0, 0);
 	if (!ASSERT_GE(server_fd, 0, "start_server"))
@@ -157,13 +175,18 @@ static void test_base(void)
 	/* with MPTCP */
 	server_fd = start_mptcp_server(AF_INET, NULL, 0, 0);
 	if (!ASSERT_GE(server_fd, 0, "start_mptcp_server"))
-		goto close_cgroup_fd;
+		goto fail;
 
 	ASSERT_OK(run_test(cgroup_fd, server_fd, true), "run_test mptcp");
 
 	close(server_fd);
 
-close_cgroup_fd:
+fail:
+	if (nstoken)
+		close_netns(nstoken);
+
+	system("ip netns del " NS_TEST " >& /dev/null");
+
 	close(cgroup_fd);
 }
 
-- 
2.38.1

