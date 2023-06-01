Return-Path: <netdev+bounces-6975-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0001719125
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 05:15:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D59D81C20FB6
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 03:15:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D0094C8F;
	Thu,  1 Jun 2023 03:15:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586FC1FA9
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 03:15:02 +0000 (UTC)
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962B31B7;
	Wed, 31 May 2023 20:15:00 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id 006d021491bc7-5559cd68b67so294891eaf.3;
        Wed, 31 May 2023 20:15:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685589300; x=1688181300;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JjfovSqd2I8P17GC4kroHcRgTaXlwLhjwgZoa24O4Ic=;
        b=X3IPBCvPa3QCcrxV4+38akD0OZBUk6nk+s/voxIsN8sq8VgnECjgo8tHbY9lkgWm5B
         4qsyAOkm9q0KIej3ruYo2xmkeNnL9I+enUAMZi7sSZ5gcIpdG+3y4LB+MJ6PkQuEsTnQ
         qT7CPgywiqgR7bBRAwYqoWBwul3N8UXU2Mo/UAmVWdjiWkMG9V4Ksde2wv+zwRF4McoU
         LeY+yd3ohS16f1wHUVeyNOFPK/dgSCxSwVBX5Dav7TEGXNE+ntrIQzbowq7RMw+dDhHE
         H4N6iYjqCjeJiO92NXQxHRzCddeh4y3T3B1++CYUMB4R1HCRj3eqk7njiQmyp+1LFOtG
         kueA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685589300; x=1688181300;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JjfovSqd2I8P17GC4kroHcRgTaXlwLhjwgZoa24O4Ic=;
        b=eEIwGGenQeXsbiBlVcVk/Hw6lqsfoZd3uBo3ZTHQ6EvhxxymOIi+uWfaOjq4AlHhyW
         +yFoFi9YsVT+a7HLbpTD8mO3cCSvbPDUbeXcdrpMS6BGZSYEDlDmnQbtbARegPeYT53z
         67Z6if2vebYi6AUeHAIx0qhEvMxpSNnlyUQYHldxHyfgFkfo+CiXFnYe7yCCztUVo296
         MXzqE5U6wKMfpRVC/6qWbO/RtKPvFDo0ZE+aD/Ba05vdKeL2uQY4YDtF/bEscA2mvZ5C
         167XxhbH5S3OmphqOErFDHmAUGSuO/BI4eg/YtjhOxs2HiV+aVRg6qlViqv7Mm0O6S1f
         7pQw==
X-Gm-Message-State: AC+VfDyVao9YCmYOPOk5BQXW+6DrsADK5yJLWpQa347nGpriLK7pu8U8
	DP/hylko4d0CZgJYBHKzDaHVeUnXVqgirAbp
X-Google-Smtp-Source: ACHHUZ5HlUuVdShUi4W96lLaX7cQZzuGXDxicH3cG+QcuU7w5AFEIDGKt1SBqLh+ir+W7x1EujNufg==
X-Received: by 2002:a05:6808:181a:b0:398:45bf:6e65 with SMTP id bh26-20020a056808181a00b0039845bf6e65mr6867865oib.9.1685589299874;
        Wed, 31 May 2023 20:14:59 -0700 (PDT)
Received: from localhost.localdomain (p1201013-ipoe.ipoe.ocn.ne.jp. [122.26.46.12])
        by smtp.gmail.com with ESMTPSA id s19-20020a170902989300b001afb96f4b90sm2101913plp.274.2023.05.31.20.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 20:14:59 -0700 (PDT)
From: Akihiro Suda <suda.gitsendemail@gmail.com>
X-Google-Original-From: Akihiro Suda <akihiro.suda.cz@hco.ntt.co.jp>
To: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	segoon@openwall.com,
	kuniyu@amazon.com
Cc: Akihiro Suda <akihiro.suda.cz@hco.ntt.co.jp>,
	suda.kyoto@gmail.com
Subject: [PATCH net v3] net/ipv4: ping_group_range: allow GID from 2147483648 to 4294967294
Date: Thu,  1 Jun 2023 12:13:05 +0900
Message-Id: <20230601031305.55901-1-akihiro.suda.cz@hco.ntt.co.jp>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

With this commit, all the GIDs ("0 4294967294") can be written to the
"net.ipv4.ping_group_range" sysctl.

Note that 4294967295 (0xffffffff) is an invalid GID (see gid_valid() in
include/linux/uidgid.h), and an attempt to register this number will cause
-EINVAL.

Prior to this commit, only up to GID 2147483647 could be covered.
Documentation/networking/ip-sysctl.rst had "0 4294967295" as an example
value, but this example was wrong and causing -EINVAL.

Fixes: c319b4d76b9e ("net: ipv4: add IPPROTO_ICMP socket kind")
Co-developed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Akihiro Suda <akihiro.suda.cz@hco.ntt.co.jp>
---
v3: Fixed a couple of nits
v2: Simplified the patch (Thanks to Kuniyuki Iwashima for suggestion)
---
 Documentation/networking/ip-sysctl.rst | 4 ++--
 include/net/ping.h                     | 6 +-----
 net/ipv4/sysctl_net_ipv4.c             | 8 ++++----
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 6ec06a33688a..80b8f73a0244 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1352,8 +1352,8 @@ ping_group_range - 2 INTEGERS
 	Restrict ICMP_PROTO datagram sockets to users in the group range.
 	The default is "1 0", meaning, that nobody (not even root) may
 	create ping sockets.  Setting it to "100 100" would grant permissions
-	to the single group. "0 4294967295" would enable it for the world, "100
-	4294967295" would enable it for the users, but not daemons.
+	to the single group. "0 4294967294" would enable it for the world, "100
+	4294967294" would enable it for the users, but not daemons.
 
 tcp_early_demux - BOOLEAN
 	Enable early demux for established TCP sockets.
diff --git a/include/net/ping.h b/include/net/ping.h
index 9233ad3de0ad..bc7779262e60 100644
--- a/include/net/ping.h
+++ b/include/net/ping.h
@@ -16,11 +16,7 @@
 #define PING_HTABLE_SIZE 	64
 #define PING_HTABLE_MASK 	(PING_HTABLE_SIZE-1)
 
-/*
- * gid_t is either uint or ushort.  We want to pass it to
- * proc_dointvec_minmax(), so it must not be larger than MAX_INT
- */
-#define GID_T_MAX (((gid_t)~0U) >> 1)
+#define GID_T_MAX (((gid_t)~0U) - 1)
 
 /* Compatibility glue so we can support IPv6 when it's compiled as a module */
 struct pingv6_ops {
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 40fe70fc2015..88dfe51e68f3 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -34,8 +34,8 @@ static int ip_ttl_min = 1;
 static int ip_ttl_max = 255;
 static int tcp_syn_retries_min = 1;
 static int tcp_syn_retries_max = MAX_TCP_SYNCNT;
-static int ip_ping_group_range_min[] = { 0, 0 };
-static int ip_ping_group_range_max[] = { GID_T_MAX, GID_T_MAX };
+static unsigned long ip_ping_group_range_min[] = { 0, 0 };
+static unsigned long ip_ping_group_range_max[] = { GID_T_MAX, GID_T_MAX };
 static u32 u32_max_div_HZ = UINT_MAX / HZ;
 static int one_day_secs = 24 * 3600;
 static u32 fib_multipath_hash_fields_all_mask __maybe_unused =
@@ -165,7 +165,7 @@ static int ipv4_ping_group_range(struct ctl_table *table, int write,
 {
 	struct user_namespace *user_ns = current_user_ns();
 	int ret;
-	gid_t urange[2];
+	unsigned long urange[2];
 	kgid_t low, high;
 	struct ctl_table tmp = {
 		.data = &urange,
@@ -178,7 +178,7 @@ static int ipv4_ping_group_range(struct ctl_table *table, int write,
 	inet_get_ping_group_range_table(table, &low, &high);
 	urange[0] = from_kgid_munged(user_ns, low);
 	urange[1] = from_kgid_munged(user_ns, high);
-	ret = proc_dointvec_minmax(&tmp, write, buffer, lenp, ppos);
+	ret = proc_doulongvec_minmax(&tmp, write, buffer, lenp, ppos);
 
 	if (write && ret == 0) {
 		low = make_kgid(user_ns, urange[0]);
-- 
2.39.2


