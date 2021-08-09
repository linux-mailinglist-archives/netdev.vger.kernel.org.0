Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48D73E4D5C
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 21:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236213AbhHITs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 15:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236200AbhHITsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 15:48:51 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16AF2C0617B1
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 12:48:21 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id l11so6090408plk.6
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 12:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9iqwgQUcM7kXjxKmNPoKYxMsXr+XLcOB8+pWCUZkNe8=;
        b=LuLiyatg4L0Vt8zuuH92aFL4DwPAOxB9XtuRR5rsD2KFle1ZtAd1P/wIzqDHovrZJm
         oxtQ8uIleZVNsuQ07R+sKRCaQVKZbc0f54weNRmLw/JTEMOEiQs4xq2oa5S9Jf2Vacdv
         HOuBQ6P/3SFFe47LUwsnKnF3IRSkOjLpXYURhRQ/5znoMbTxrMr+DatMRr5LQezTC8Ww
         cohPixCFWyfKGn42FJrjGy5CQ4RgL15pJSmJR4MmV1VdVdRo6kDNE4H1TBsmV6kazMmI
         m3zEBu9gbzBOXC8qfqbxVTlhzzF/VysABBdz+c8LRJk44zzr2p6NMM6GdO+a6rYyTrlq
         Grqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9iqwgQUcM7kXjxKmNPoKYxMsXr+XLcOB8+pWCUZkNe8=;
        b=LNm1FVRNAjHkF28/Tw5tMWS3xI3GExuQw7Hnvsj62+f2/u814H/7pNLNr73URrsx0u
         ArG2TQ4YOztY/OLa5LnzbOOlPfT3UTjnwcmqY8l3NhXWz005QpH30upbliQkvJXxCi3j
         2jBXmpqsTmg0T/cwaKR4qRO2KIuCN0WECZDsRELh9DtBWzvbBgN/Cs4AsDETAAZL/Ne2
         3syg9qFap3HsPK0SKTJdtedD0A9XrskzCEtAtz3QdTqtLnI/FXxNJ8JJATID4f7VTuhH
         BWPd7dSbh3lTFuFGFKP5zg2Dyo+xu8L5q4sN4uAuhLjmxLeH93Z0atY8CFJu6OC1CCdJ
         u8Gw==
X-Gm-Message-State: AOAM531iAwzFwDUb+UevYhiNVHwbaF2+Em1+3cblScPOe2F3Gcvqm5dK
        e6t+wjFAX2kzTXzuAmbIojXxeygakL393w==
X-Google-Smtp-Source: ABdhPJxm8cQIw4zr43skvGcdR+9Vi8rsSTpNx7WJKdQWtBHaW+s2GELnS8RF+Q6d8RdHjgafQJPF3A==
X-Received: by 2002:a17:90a:6782:: with SMTP id o2mr728151pjj.165.1628538500526;
        Mon, 09 Aug 2021 12:48:20 -0700 (PDT)
Received: from ip-10-124-121-13.byted.org (ec2-54-241-92-238.us-west-1.compute.amazonaws.com. [54.241.92.238])
        by smtp.gmail.com with ESMTPSA id x19sm21372291pfa.104.2021.08.09.12.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 12:48:20 -0700 (PDT)
From:   Jiang Wang <jiang.wang@bytedance.com>
To:     netdev@vger.kernel.org
Cc:     cong.wang@bytedance.com, duanxiongchun@bytedance.com,
        xieyongji@bytedance.com, chaiwen.cc@bytedance.com,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v6 5/5] selftest/bpf: add new tests in sockmap for unix stream to tcp.
Date:   Mon,  9 Aug 2021 19:47:38 +0000
Message-Id: <20210809194742.1489985-6-jiang.wang@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210809194742.1489985-1-jiang.wang@bytedance.com>
References: <20210809194742.1489985-1-jiang.wang@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add two new test cases in sockmap tests, where unix stream is
redirected to tcp and vice versa.

Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/prog_tests/sockmap_listen.c    | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 07ed8081f9ae..afa14fb66f08 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1884,7 +1884,7 @@ static void inet_unix_redir_to_connected(int family, int type, int sock_mapfd,
 	xclose(p0);
 }
 
-static void udp_unix_skb_redir_to_connected(struct test_sockmap_listen *skel,
+static void inet_unix_skb_redir_to_connected(struct test_sockmap_listen *skel,
 					    struct bpf_map *inner_map, int family)
 {
 	int verdict = bpf_program__fd(skel->progs.prog_skb_verdict);
@@ -1899,9 +1899,13 @@ static void udp_unix_skb_redir_to_connected(struct test_sockmap_listen *skel,
 	skel->bss->test_ingress = false;
 	inet_unix_redir_to_connected(family, SOCK_DGRAM, sock_map, verdict_map,
 				    REDIR_EGRESS);
+	inet_unix_redir_to_connected(family, SOCK_STREAM, sock_map, verdict_map,
+				    REDIR_EGRESS);
 	skel->bss->test_ingress = true;
 	inet_unix_redir_to_connected(family, SOCK_DGRAM, sock_map, verdict_map,
 				    REDIR_INGRESS);
+	inet_unix_redir_to_connected(family, SOCK_STREAM, sock_map, verdict_map,
+				    REDIR_INGRESS);
 
 	xbpf_prog_detach2(verdict, sock_map, BPF_SK_SKB_VERDICT);
 }
@@ -1961,7 +1965,7 @@ static void unix_inet_redir_to_connected(int family, int type, int sock_mapfd,
 
 }
 
-static void unix_udp_skb_redir_to_connected(struct test_sockmap_listen *skel,
+static void unix_inet_skb_redir_to_connected(struct test_sockmap_listen *skel,
 					    struct bpf_map *inner_map, int family)
 {
 	int verdict = bpf_program__fd(skel->progs.prog_skb_verdict);
@@ -1976,9 +1980,13 @@ static void unix_udp_skb_redir_to_connected(struct test_sockmap_listen *skel,
 	skel->bss->test_ingress = false;
 	unix_inet_redir_to_connected(family, SOCK_DGRAM, sock_map, verdict_map,
 				     REDIR_EGRESS);
+	unix_inet_redir_to_connected(family, SOCK_STREAM, sock_map, verdict_map,
+				     REDIR_EGRESS);
 	skel->bss->test_ingress = true;
 	unix_inet_redir_to_connected(family, SOCK_DGRAM, sock_map, verdict_map,
 				     REDIR_INGRESS);
+	unix_inet_redir_to_connected(family, SOCK_STREAM, sock_map, verdict_map,
+				     REDIR_INGRESS);
 
 	xbpf_prog_detach2(verdict, sock_map, BPF_SK_SKB_VERDICT);
 }
@@ -1994,8 +2002,8 @@ static void test_udp_unix_redir(struct test_sockmap_listen *skel, struct bpf_map
 	snprintf(s, sizeof(s), "%s %s %s", map_name, family_name, __func__);
 	if (!test__start_subtest(s))
 		return;
-	udp_unix_skb_redir_to_connected(skel, map, family);
-	unix_udp_skb_redir_to_connected(skel, map, family);
+	inet_unix_skb_redir_to_connected(skel, map, family);
+	unix_inet_skb_redir_to_connected(skel, map, family);
 }
 
 static void run_tests(struct test_sockmap_listen *skel, struct bpf_map *map,
-- 
2.20.1

