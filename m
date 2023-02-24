Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7106A1687
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 07:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjBXGOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 01:14:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjBXGOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 01:14:11 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FED61E2B5;
        Thu, 23 Feb 2023 22:14:10 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id nw10-20020a17090b254a00b00233d7314c1cso1718637pjb.5;
        Thu, 23 Feb 2023 22:14:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=58oDgBCYgEc0aMZIF6k8MYs0ZDFkMwdo2A6uSS3T21g=;
        b=OgD8w8TcGiU5M50CS1yVxxPtmI0veigVNrfNeP50ZIMPJtR8q75xZdawk4RSwgmMbN
         d4DguGfp6TCKNk5EVBuSQCvL/0eZ2GCevkNzO3RB3QFwrr7w9rOp72N4/wUeRuF9eVBX
         0BnMqX7vRbsX9GZ8eafqrVBCSTf04KqICh1p2/kok5AbcBxTVA2AcIzEHafoToMD2HxK
         xd2HkfClyIMCyyq5qwv6jLRYWRXDbHUrGBJX8sJAia35byQeWDD3qvoozgCz+NrRjbJT
         qinPbmvzk0PL4ZTsaYQ2SKgFyAPHt7ViF0lIizzzIhB6GsBwVC8C1fbAg8PqIR2Kg39w
         /6jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=58oDgBCYgEc0aMZIF6k8MYs0ZDFkMwdo2A6uSS3T21g=;
        b=rRej/KlLjFQSFK/BjdTS0raYyBJLzN/if93XoK6b9rdkhcqW4dUK9zEmk1z75iVt4d
         nQXVdBcQdpb4Y9x2B0479eyoJje2JSXHQrAi9G14yUVqJTcKYqQUbSBj4h+9/ysaLCAR
         79LRKPpzYBtpuQIYpQdNN9iZXBtOAHyvr0eOkRpq+Teyol/VFa2pekTyap5e9Pa3XPLV
         B22ETcmDScNwcv5dHjJBQS9fCWb5VnKhlqjqz+vTvleA93nwnjaVtlEoMX+ef4BYRH5E
         qZ7G5rMBvaXMug1xYLgUwWcgpSDgosDbIB0/nZqyFDNf5ZaaCOvrDEqmQzIRn9PRBHw/
         1Tuw==
X-Gm-Message-State: AO0yUKV23MOMvKu3Kt5FGmXg/A9yw4i8v+5SDNHmCaTd0OVKRSdZxwmN
        5d+GU0Q9h4PpSIXLDmQZBngBIuYp/S0=
X-Google-Smtp-Source: AK7set+O9j3xNTcJ7MqSy5M9CjRqdCvfBwsmlUNWwxbLlUZ16J/mpN36te+Wu1/jNIR6pO4mC+AAZw==
X-Received: by 2002:a05:6a20:7da2:b0:cc:8266:9951 with SMTP id v34-20020a056a207da200b000cc82669951mr496041pzj.56.1677219248950;
        Thu, 23 Feb 2023 22:14:08 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e24-20020aa78258000000b005afda149679sm2336071pfn.179.2023.02.23.22.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 22:14:08 -0800 (PST)
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
Subject: [PATCHv3 bpf-next 2/2] selftests/bpf: run mptcp in a dedicated netns
Date:   Fri, 24 Feb 2023 14:13:43 +0800
Message-Id: <20230224061343.506571-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230224061343.506571-1-liuhangbin@gmail.com>
References: <20230224061343.506571-1-liuhangbin@gmail.com>
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
 .../testing/selftests/bpf/prog_tests/mptcp.c  | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testing/selftests/bpf/prog_tests/mptcp.c
index 59f08d6d1d53..cd0c42fff7c0 100644
--- a/tools/testing/selftests/bpf/prog_tests/mptcp.c
+++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
@@ -7,6 +7,8 @@
 #include "network_helpers.h"
 #include "mptcp_sock.skel.h"
 
+#define NS_TEST "mptcp_ns"
+
 #ifndef TCP_CA_NAME_MAX
 #define TCP_CA_NAME_MAX	16
 #endif
@@ -138,12 +140,20 @@ static int run_test(int cgroup_fd, int server_fd, bool is_mptcp)
 
 static void test_base(void)
 {
+	struct nstoken *nstoken = NULL;
 	int server_fd, cgroup_fd;
 
 	cgroup_fd = test__join_cgroup("/mptcp");
 	if (!ASSERT_GE(cgroup_fd, 0, "test__join_cgroup"))
 		return;
 
+	SYS(fail, "ip netns add %s", NS_TEST);
+	SYS(fail, "ip -net %s link set dev lo up", NS_TEST);
+
+	nstoken = open_netns(NS_TEST);
+	if (!ASSERT_OK_PTR(nstoken, "open_netns"))
+		goto fail;
+
 	/* without MPTCP */
 	server_fd = start_server(AF_INET, SOCK_STREAM, NULL, 0, 0);
 	if (!ASSERT_GE(server_fd, 0, "start_server"))
@@ -157,13 +167,18 @@ static void test_base(void)
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
+	SYS_NOFAIL("ip netns del " NS_TEST " &> /dev/null");
+
 	close(cgroup_fd);
 }
 
-- 
2.38.1

