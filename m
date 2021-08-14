Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42BF3EC077
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 06:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237232AbhHNE3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 00:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236924AbhHNE2v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 00:28:51 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C681C0617AF
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 21:28:23 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id a8so18265995pjk.4
        for <netdev@vger.kernel.org>; Fri, 13 Aug 2021 21:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OmM6Jh2wG8NHNQR7MWK2cVhqAuC5kqvoMNBPLIkIjok=;
        b=XV6liz5RBh3o6mXHqjDPxqNwyS+NOARnh62D6tvmX6BFVxneUEphqa1ntoPlX8mNvX
         muAl1n61gEln1BAeqd6GERmafyL4TgElbAx4ZIYNnoj8MLoi5X2MgEPo13vE9LEQWN74
         l9Qn7V+fzdx+xOpMs81v/dzkkF+EbGRH82dAD/utplW61/UUsL9a5DwDKcaXGLtyON8K
         hw/58Gs9o7UMDP5exflaYPeJZbmYfFo3LvjjfDkJJP1PtmkriwmDe7oL5+9qpct0WxOZ
         JPvKg0GcjTb1Gf3F7uWAKxUK8m6GFWVtVed9bnYzgyf4XImzunCncdZe1D4VRXGGxP5j
         Fe1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OmM6Jh2wG8NHNQR7MWK2cVhqAuC5kqvoMNBPLIkIjok=;
        b=ATzJMWxYJMvbCNezR+D7bjMeC9L+ggXWW0GZBiZDKHa719QP3cGhmi9NoT6fn09co/
         nA3KvMqWNZduFtw0GZoZIllGjoUmCic4g5MclvSTCHDa8YxXIooqM0M48ibhVepX83/O
         LSDCJyNxMw/YCG62b14l+sEBK6iRx5+b9YcsFYcxvVmgAA43se8/3t1BYSwGaL3Ovxcd
         2K0qkKPJKwTYBwRtsT0CRjMtX0QhP/taxRqKlkjg5/2Yn73h6TaqwM3QL7nuFgwMsHuE
         EkYNjTPDxr/JeZ7WIorFc8/BYtqICZCKyjvSwy5UpXtVZRYtE/gRzSvp5OxudzsFlxeV
         bxjQ==
X-Gm-Message-State: AOAM532qSo/asFAF5yZqDMo4VrjjeneXH52GPwvKrKu0BWvs0FdTJMdd
        aVKTRpcPlOYorYjssvtEGsxI3WjooRxDtg==
X-Google-Smtp-Source: ABdhPJz+1ETzqgCkqWQDeQlCIfNHjx+QoNv3aUZgW3AezyWdhWV4XUEJb09WASAqlLKHjpl67Ie1VQ==
X-Received: by 2002:a17:90a:c57:: with SMTP id u23mr5827267pje.186.1628915302951;
        Fri, 13 Aug 2021 21:28:22 -0700 (PDT)
Received: from ip-10-124-121-13.byted.org (ec2-54-241-92-238.us-west-1.compute.amazonaws.com. [54.241.92.238])
        by smtp.gmail.com with ESMTPSA id q21sm4420492pgk.71.2021.08.13.21.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 21:28:22 -0700 (PDT)
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
        Rao Shoaib <rao.shoaib@oracle.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v6 4/5] selftest/bpf: change udp to inet in some function names
Date:   Sat, 14 Aug 2021 04:27:49 +0000
Message-Id: <20210814042754.3351268-5-jiang.wang@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210814042754.3351268-1-jiang.wang@bytedance.com>
References: <20210814042754.3351268-1-jiang.wang@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is to prepare for adding new unix stream tests.
Mostly renames, also pass the socket types as an argument.

Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 .../selftests/bpf/prog_tests/sockmap_listen.c | 30 +++++++++++--------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
index 7a976d43281a..07ed8081f9ae 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
@@ -1692,14 +1692,14 @@ static void test_reuseport(struct test_sockmap_listen *skel,
 	}
 }
 
-static int udp_socketpair(int family, int *s, int *c)
+static int inet_socketpair(int family, int type, int *s, int *c)
 {
 	struct sockaddr_storage addr;
 	socklen_t len;
 	int p0, c0;
 	int err;
 
-	p0 = socket_loopback(family, SOCK_DGRAM | SOCK_NONBLOCK);
+	p0 = socket_loopback(family, type | SOCK_NONBLOCK);
 	if (p0 < 0)
 		return p0;
 
@@ -1708,7 +1708,7 @@ static int udp_socketpair(int family, int *s, int *c)
 	if (err)
 		goto close_peer0;
 
-	c0 = xsocket(family, SOCK_DGRAM | SOCK_NONBLOCK, 0);
+	c0 = xsocket(family, type | SOCK_NONBLOCK, 0);
 	if (c0 < 0) {
 		err = c0;
 		goto close_peer0;
@@ -1747,10 +1747,10 @@ static void udp_redir_to_connected(int family, int sock_mapfd, int verd_mapfd,
 
 	zero_verdict_count(verd_mapfd);
 
-	err = udp_socketpair(family, &p0, &c0);
+	err = inet_socketpair(family, SOCK_DGRAM, &p0, &c0);
 	if (err)
 		return;
-	err = udp_socketpair(family, &p1, &c1);
+	err = inet_socketpair(family, SOCK_DGRAM, &p1, &c1);
 	if (err)
 		goto close_cli0;
 
@@ -1825,7 +1825,7 @@ static void test_udp_redir(struct test_sockmap_listen *skel, struct bpf_map *map
 	udp_skb_redir_to_connected(skel, map, family);
 }
 
-static void udp_unix_redir_to_connected(int family, int sock_mapfd,
+static void inet_unix_redir_to_connected(int family, int type, int sock_mapfd,
 					int verd_mapfd, enum redir_mode mode)
 {
 	const char *log_prefix = redir_mode_str(mode);
@@ -1843,7 +1843,7 @@ static void udp_unix_redir_to_connected(int family, int sock_mapfd,
 		return;
 	c0 = sfd[0], p0 = sfd[1];
 
-	err = udp_socketpair(family, &p1, &c1);
+	err = inet_socketpair(family, SOCK_DGRAM, &p1, &c1);
 	if (err)
 		goto close;
 
@@ -1897,14 +1897,16 @@ static void udp_unix_skb_redir_to_connected(struct test_sockmap_listen *skel,
 		return;
 
 	skel->bss->test_ingress = false;
-	udp_unix_redir_to_connected(family, sock_map, verdict_map, REDIR_EGRESS);
+	inet_unix_redir_to_connected(family, SOCK_DGRAM, sock_map, verdict_map,
+				    REDIR_EGRESS);
 	skel->bss->test_ingress = true;
-	udp_unix_redir_to_connected(family, sock_map, verdict_map, REDIR_INGRESS);
+	inet_unix_redir_to_connected(family, SOCK_DGRAM, sock_map, verdict_map,
+				    REDIR_INGRESS);
 
 	xbpf_prog_detach2(verdict, sock_map, BPF_SK_SKB_VERDICT);
 }
 
-static void unix_udp_redir_to_connected(int family, int sock_mapfd,
+static void unix_inet_redir_to_connected(int family, int type, int sock_mapfd,
 					int verd_mapfd, enum redir_mode mode)
 {
 	const char *log_prefix = redir_mode_str(mode);
@@ -1917,7 +1919,7 @@ static void unix_udp_redir_to_connected(int family, int sock_mapfd,
 
 	zero_verdict_count(verd_mapfd);
 
-	err = udp_socketpair(family, &p0, &c0);
+	err = inet_socketpair(family, SOCK_DGRAM, &p0, &c0);
 	if (err)
 		return;
 
@@ -1972,9 +1974,11 @@ static void unix_udp_skb_redir_to_connected(struct test_sockmap_listen *skel,
 		return;
 
 	skel->bss->test_ingress = false;
-	unix_udp_redir_to_connected(family, sock_map, verdict_map, REDIR_EGRESS);
+	unix_inet_redir_to_connected(family, SOCK_DGRAM, sock_map, verdict_map,
+				     REDIR_EGRESS);
 	skel->bss->test_ingress = true;
-	unix_udp_redir_to_connected(family, sock_map, verdict_map, REDIR_INGRESS);
+	unix_inet_redir_to_connected(family, SOCK_DGRAM, sock_map, verdict_map,
+				     REDIR_INGRESS);
 
 	xbpf_prog_detach2(verdict, sock_map, BPF_SK_SKB_VERDICT);
 }
-- 
2.20.1

