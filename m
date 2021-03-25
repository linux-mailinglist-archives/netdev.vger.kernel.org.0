Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9093E349930
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 19:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhCYSIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 14:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbhCYSIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 14:08:38 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2BEC06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 11:08:37 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so1282164pjv.1
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 11:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w2UZ3KVv41bK5L/j+bh+X1f4ZrmnMmbzN21+d1MZToQ=;
        b=mtTbS9rG0HLvlgsDElWSRv/pFQWwBAasbAJ0W1x1CJU4rA5xda2GQCO4nOMeJBqLTO
         UkkwiRVmIhD4QA/g+HjxLPtYgUphvGTevobbLYqKawVxpZfkxLtmC9YBNxbujSBoSO3b
         CcF2dJREMxqDRfj7egxZqX5rqsZhQRW19fPFnlfAmaBwsHoPBxMLKIoILbBkGfLAPzYJ
         U4mh8ZY/hjbg9EA9at4dyCKMBPCvjnSbgEKuDp1Glvb6C3wL47kcPCsypphZ6Rqc/fsx
         PwldCk7uSmKAeyA5Y6gbJIgK1fqyHI6JF3XTdCW4+NXNPYVtcIUYL+5aW5ZqCahYi7u7
         YvGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w2UZ3KVv41bK5L/j+bh+X1f4ZrmnMmbzN21+d1MZToQ=;
        b=T6w/KeUkh3gnjnatRcaDeldIlMghabHZvyPLEFcL1g/41vXlNv4wbJRpfnaEFT5Ex6
         Kf6ZmLTZRnZelyr4YD7egN900e9uUrwpltfloQKKiV0SIW6+CLF7/ayClmlRmYl0KAwn
         A4xjTyF8zmpxnr9eHXX7t2et+mgIy19dU1sI7teoXrtXgmbihcFH/zOEtyeC66Y/czEP
         KfkBZw/C3vQ0VSylCehTaar0JH2FaZdBgzl+aATJjgXo5MTjiFJ4yVEQiBZCD/s7MVyQ
         IghQBxNTufEUboACoNmgFl9NWigBvKuyyfPeJxX0mOinFDyhUX1ikVRmMNEJ42lvv4vb
         XeBQ==
X-Gm-Message-State: AOAM5329qhBNfDE6r+QiRoLf8kTBnCVg9xqjZsdiWe97J1Xfs+2N1Gkz
        lGsCdGLiOTrFmR2UHoXTQ7E=
X-Google-Smtp-Source: ABdhPJz/tp+tOUzapNftKWbIcshypdQ6jISNSWtyTKf4LkKBS5br89fd8O51jeJIuAvdszLQHEM2WQ==
X-Received: by 2002:a17:90b:903:: with SMTP id bo3mr10320718pjb.198.1616695717538;
        Thu, 25 Mar 2021 11:08:37 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2c0c:35d8:b060:81b3])
        by smtp.gmail.com with ESMTPSA id j20sm5968359pjn.27.2021.03.25.11.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 11:08:37 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 5/5] tcp: convert elligible sysctls to u8
Date:   Thu, 25 Mar 2021 11:08:17 -0700
Message-Id: <20210325180817.840042-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
In-Reply-To: <20210325180817.840042-1-eric.dumazet@gmail.com>
References: <20210325180817.840042-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Many tcp sysctls are either bools or small ints that can fit into u8.

Reducing space taken by sysctls can save few cache line misses
when sending/receiving data while cpu caches are empty,
for example after cpu idle period.

This is hard to measure with typical network performance tests,
but after this patch, struct netns_ipv4 has shrunk
by three cache lines.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/ipv4.h   |  68 +++++++++----------
 net/ipv4/sysctl_net_ipv4.c | 136 ++++++++++++++++++-------------------
 2 files changed, 102 insertions(+), 102 deletions(-)

diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 00f250ee441973586198014df8791c60ae298565..d377266d133f076eda7d0469da75d5f7ee1431b9 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -113,11 +113,11 @@ struct netns_ipv4 {
 	u8 sysctl_nexthop_compat_mode;
 
 	u8 sysctl_fwmark_reflect;
-	int sysctl_tcp_fwmark_accept;
+	u8 sysctl_tcp_fwmark_accept;
 #ifdef CONFIG_NET_L3_MASTER_DEV
-	int sysctl_tcp_l3mdev_accept;
+	u8 sysctl_tcp_l3mdev_accept;
 #endif
-	int sysctl_tcp_mtu_probing;
+	u8 sysctl_tcp_mtu_probing;
 	int sysctl_tcp_mtu_probe_floor;
 	int sysctl_tcp_base_mss;
 	int sysctl_tcp_min_snd_mss;
@@ -125,46 +125,47 @@ struct netns_ipv4 {
 	u32 sysctl_tcp_probe_interval;
 
 	int sysctl_tcp_keepalive_time;
-	int sysctl_tcp_keepalive_probes;
 	int sysctl_tcp_keepalive_intvl;
+	u8 sysctl_tcp_keepalive_probes;
 
-	int sysctl_tcp_syn_retries;
-	int sysctl_tcp_synack_retries;
-	int sysctl_tcp_syncookies;
+	u8 sysctl_tcp_syn_retries;
+	u8 sysctl_tcp_synack_retries;
+	u8 sysctl_tcp_syncookies;
 	int sysctl_tcp_reordering;
-	int sysctl_tcp_retries1;
-	int sysctl_tcp_retries2;
-	int sysctl_tcp_orphan_retries;
+	u8 sysctl_tcp_retries1;
+	u8 sysctl_tcp_retries2;
+	u8 sysctl_tcp_orphan_retries;
+	u8 sysctl_tcp_tw_reuse;
 	int sysctl_tcp_fin_timeout;
 	unsigned int sysctl_tcp_notsent_lowat;
-	int sysctl_tcp_tw_reuse;
-	int sysctl_tcp_sack;
-	int sysctl_tcp_window_scaling;
-	int sysctl_tcp_timestamps;
-	int sysctl_tcp_early_retrans;
-	int sysctl_tcp_recovery;
-	int sysctl_tcp_thin_linear_timeouts;
-	int sysctl_tcp_slow_start_after_idle;
-	int sysctl_tcp_retrans_collapse;
-	int sysctl_tcp_stdurg;
-	int sysctl_tcp_rfc1337;
-	int sysctl_tcp_abort_on_overflow;
-	int sysctl_tcp_fack;
+	u8 sysctl_tcp_sack;
+	u8 sysctl_tcp_window_scaling;
+	u8 sysctl_tcp_timestamps;
+	u8 sysctl_tcp_early_retrans;
+	u8 sysctl_tcp_recovery;
+	u8 sysctl_tcp_thin_linear_timeouts;
+	u8 sysctl_tcp_slow_start_after_idle;
+	u8 sysctl_tcp_retrans_collapse;
+	u8 sysctl_tcp_stdurg;
+	u8 sysctl_tcp_rfc1337;
+	u8 sysctl_tcp_abort_on_overflow;
+	u8 sysctl_tcp_fack; /* obsolete */
 	int sysctl_tcp_max_reordering;
-	int sysctl_tcp_dsack;
-	int sysctl_tcp_app_win;
 	int sysctl_tcp_adv_win_scale;
-	int sysctl_tcp_frto;
-	int sysctl_tcp_nometrics_save;
-	int sysctl_tcp_no_ssthresh_metrics_save;
-	int sysctl_tcp_moderate_rcvbuf;
-	int sysctl_tcp_tso_win_divisor;
-	int sysctl_tcp_workaround_signed_windows;
+	u8 sysctl_tcp_dsack;
+	u8 sysctl_tcp_app_win;
+	u8 sysctl_tcp_frto;
+	u8 sysctl_tcp_nometrics_save;
+	u8 sysctl_tcp_no_ssthresh_metrics_save;
+	u8 sysctl_tcp_moderate_rcvbuf;
+	u8 sysctl_tcp_tso_win_divisor;
+	u8 sysctl_tcp_workaround_signed_windows;
 	int sysctl_tcp_limit_output_bytes;
 	int sysctl_tcp_challenge_ack_limit;
-	int sysctl_tcp_min_tso_segs;
 	int sysctl_tcp_min_rtt_wlen;
-	int sysctl_tcp_autocorking;
+	u8 sysctl_tcp_min_tso_segs;
+	u8 sysctl_tcp_autocorking;
+	u8 sysctl_tcp_reflect_tos;
 	int sysctl_tcp_invalid_ratelimit;
 	int sysctl_tcp_pacing_ss_ratio;
 	int sysctl_tcp_pacing_ca_ratio;
@@ -182,7 +183,6 @@ struct netns_ipv4 {
 	unsigned int sysctl_tcp_fastopen_blackhole_timeout;
 	atomic_t tfo_active_disable_times;
 	unsigned long tfo_active_disable_stamp;
-	int sysctl_tcp_reflect_tos;
 
 	int sysctl_udp_wmem_min;
 	int sysctl_udp_rmem_min;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 510a326356127c0a822f9a1215737a5c843fd58c..442ff4be1bde236563b6cfea67179de4f30856bf 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -775,17 +775,17 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_fwmark_accept",
 		.data		= &init_net.ipv4.sysctl_tcp_fwmark_accept,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 #ifdef CONFIG_NET_L3_MASTER_DEV
 	{
 		.procname	= "tcp_l3mdev_accept",
 		.data		= &init_net.ipv4.sysctl_tcp_l3mdev_accept,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
@@ -793,9 +793,9 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_mtu_probing",
 		.data		= &init_net.ipv4.sysctl_tcp_mtu_probing,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_base_mss",
@@ -897,9 +897,9 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_keepalive_probes",
 		.data		= &init_net.ipv4.sysctl_tcp_keepalive_probes,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_keepalive_intvl",
@@ -911,26 +911,26 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_syn_retries",
 		.data		= &init_net.ipv4.sysctl_tcp_syn_retries,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= &tcp_syn_retries_min,
 		.extra2		= &tcp_syn_retries_max
 	},
 	{
 		.procname	= "tcp_synack_retries",
 		.data		= &init_net.ipv4.sysctl_tcp_synack_retries,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 #ifdef CONFIG_SYN_COOKIES
 	{
 		.procname	= "tcp_syncookies",
 		.data		= &init_net.ipv4.sysctl_tcp_syncookies,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 #endif
 	{
@@ -943,24 +943,24 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_retries1",
 		.data		= &init_net.ipv4.sysctl_tcp_retries1,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra2		= &tcp_retr1_max
 	},
 	{
 		.procname	= "tcp_retries2",
 		.data		= &init_net.ipv4.sysctl_tcp_retries2,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_orphan_retries",
 		.data		= &init_net.ipv4.sysctl_tcp_orphan_retries,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_fin_timeout",
@@ -979,9 +979,9 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_tw_reuse",
 		.data		= &init_net.ipv4.sysctl_tcp_tw_reuse,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &two,
 	},
@@ -1067,88 +1067,88 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_sack",
 		.data		= &init_net.ipv4.sysctl_tcp_sack,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_window_scaling",
 		.data		= &init_net.ipv4.sysctl_tcp_window_scaling,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_timestamps",
 		.data		= &init_net.ipv4.sysctl_tcp_timestamps,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_early_retrans",
 		.data		= &init_net.ipv4.sysctl_tcp_early_retrans,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= &four,
 	},
 	{
 		.procname	= "tcp_recovery",
 		.data		= &init_net.ipv4.sysctl_tcp_recovery,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname       = "tcp_thin_linear_timeouts",
 		.data           = &init_net.ipv4.sysctl_tcp_thin_linear_timeouts,
-		.maxlen         = sizeof(int),
+		.maxlen         = sizeof(u8),
 		.mode           = 0644,
-		.proc_handler   = proc_dointvec
+		.proc_handler   = proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_slow_start_after_idle",
 		.data		= &init_net.ipv4.sysctl_tcp_slow_start_after_idle,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_retrans_collapse",
 		.data		= &init_net.ipv4.sysctl_tcp_retrans_collapse,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_stdurg",
 		.data		= &init_net.ipv4.sysctl_tcp_stdurg,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_rfc1337",
 		.data		= &init_net.ipv4.sysctl_tcp_rfc1337,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_abort_on_overflow",
 		.data		= &init_net.ipv4.sysctl_tcp_abort_on_overflow,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_fack",
 		.data		= &init_net.ipv4.sysctl_tcp_fack,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_max_reordering",
@@ -1160,16 +1160,16 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_dsack",
 		.data		= &init_net.ipv4.sysctl_tcp_dsack,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_app_win",
 		.data		= &init_net.ipv4.sysctl_tcp_app_win,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_adv_win_scale",
@@ -1183,46 +1183,46 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_frto",
 		.data		= &init_net.ipv4.sysctl_tcp_frto,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_no_metrics_save",
 		.data		= &init_net.ipv4.sysctl_tcp_nometrics_save,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_no_ssthresh_metrics_save",
 		.data		= &init_net.ipv4.sysctl_tcp_no_ssthresh_metrics_save,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
 	{
 		.procname	= "tcp_moderate_rcvbuf",
 		.data		= &init_net.ipv4.sysctl_tcp_moderate_rcvbuf,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_tso_win_divisor",
 		.data		= &init_net.ipv4.sysctl_tcp_tso_win_divisor,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_workaround_signed_windows",
 		.data		= &init_net.ipv4.sysctl_tcp_workaround_signed_windows,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dou8vec_minmax,
 	},
 	{
 		.procname	= "tcp_limit_output_bytes",
@@ -1241,9 +1241,9 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_min_tso_segs",
 		.data		= &init_net.ipv4.sysctl_tcp_min_tso_segs,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ONE,
 		.extra2		= &gso_max_segs,
 	},
@@ -1259,9 +1259,9 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname	= "tcp_autocorking",
 		.data		= &init_net.ipv4.sysctl_tcp_autocorking,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
@@ -1332,9 +1332,9 @@ static struct ctl_table ipv4_net_table[] = {
 	{
 		.procname       = "tcp_reflect_tos",
 		.data           = &init_net.ipv4.sysctl_tcp_reflect_tos,
-		.maxlen         = sizeof(int),
+		.maxlen         = sizeof(u8),
 		.mode           = 0644,
-		.proc_handler   = proc_dointvec_minmax,
+		.proc_handler   = proc_dou8vec_minmax,
 		.extra1         = SYSCTL_ZERO,
 		.extra2         = SYSCTL_ONE,
 	},
-- 
2.31.0.291.g576ba9dcdaf-goog

