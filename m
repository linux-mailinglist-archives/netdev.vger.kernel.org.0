Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D057C5F03F9
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 06:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbiI3Ezi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 00:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbiI3Ez2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 00:55:28 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E2AB1162F2
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 21:55:05 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id cj27so2045586qtb.7
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 21:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=45zcT8Ab6mFDuaHeqzPPAGTZ1Sbrw4qGLAf9NjNHOU0=;
        b=EG27A4RV1srkOi6WuL9h8rxKInHBTd3+YKEHEFB3O8P5bPXTLuw7ksNiRqjQY0yagB
         SQ9PmelmThhKDdZ5rp7CP1TuAMx2RnQmBJP2a9VzPfxwoEOJbavZ8iZsIVDmx9k62w93
         8oeBk2ijIJYeCoBuM4z1EqSsLdhiATGg0UnRR9/H34/64J2VeJwSRYJvVL1z0CThLVyK
         9j+PxdCsYZafTD3hRtctFiFuJBFsl/jNPl8PGHCsSFrXf6vRG/TI1Op1XnAyV8HELOLw
         hSmyNp0iMobZ7hJl6ffVH0GJPERIpeB174HxviFRayTreL7QG62SD9oMFxRsUiuhz72R
         KIQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=45zcT8Ab6mFDuaHeqzPPAGTZ1Sbrw4qGLAf9NjNHOU0=;
        b=Z75oQ6W5gZL3mzZ7tesnd8wmXgZL2AjFrP/8IIafqNx+cu1W4qpZpBKBplw5Xqk1IO
         4XvXKptCI0tcuzQhJ+k+oysk4XsqpQu12Iq8DnKLoSyAotIjahseAsS4synSfmLsxHHz
         eaONzc5CkLt8Stw4ojsTcgufFXKb7aVs7TXiUHZ7x2xDIe6f5EMvgNXRHrjIuCrbqxky
         Gnsx4BDCPvIPOuGvRskmMY6WDeVvEzonOANoe4xvfQMw2XrvrADQnCOxdodm31AxC5dJ
         tr8vwhJnlTh0GiD52JDeAmAmrHXPPkW4A5aE5pJ1Drq8R0JsiMAGkKIjJJPHF+pBQv15
         Pk/w==
X-Gm-Message-State: ACrzQf2pbZ0Y/Yypfc7UuJEf0zf3LeCpG6XbFY33YrZH+7L7U61uH8t/
        4syO36MPQZ6TM6/ZUCXITm48+gcvtp80Vg==
X-Google-Smtp-Source: AMsMyM4yvIDc5H/yh9n/esk7w69CPMfb6qo/FEdxNLW+88XKt/w/kzC+ullQfk8Qhzs65EBtso6u2w==
X-Received: by 2002:a05:622a:15c4:b0:35b:b493:f8fb with SMTP id d4-20020a05622a15c400b0035bb493f8fbmr5383595qty.300.1664513631080;
        Thu, 29 Sep 2022 21:53:51 -0700 (PDT)
Received: from mubashirq.c.googlers.com.com (74.206.145.34.bc.googleusercontent.com. [34.145.206.74])
        by smtp.gmail.com with ESMTPSA id de9-20020a05620a370900b006bb82221013sm1550059qkb.0.2022.09.29.21.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 21:53:50 -0700 (PDT)
From:   Mubashir Adnan Qureshi <mubashirmaq@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Mubashir Adnan Qureshi <mubashirq@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next v2 1/5] tcp: add sysctls for TCP PLB parameters
Date:   Fri, 30 Sep 2022 04:53:16 +0000
Message-Id: <20220930045320.5252-2-mubashirmaq@gmail.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220930045320.5252-1-mubashirmaq@gmail.com>
References: <20220929142447.3821638-1-mubashirmaq@gmail.com>
 <20220930045320.5252-1-mubashirmaq@gmail.com>
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

From: Mubashir Adnan Qureshi <mubashirq@google.com>

PLB (Protective Load Balancing) is a host based mechanism for load
balancing across switch links. It leverages congestion signals(e.g. ECN)
from transport layer to randomly change the path of the connection
experiencing congestion. PLB changes the path of the connection by
changing the outgoing IPv6 flow label for IPv6 connections (implemented
in Linux by calling sk_rethink_txhash()). Because of this implementation
mechanism, PLB can currently only work for IPv6 traffic. For more
information, see the SIGCOMM 2022 paper:
  https://doi.org/10.1145/3544216.3544226

This commit adds new sysctl knobs and sets their default values for
TCP PLB.

Signed-off-by: Mubashir Adnan Qureshi <mubashirq@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 Documentation/networking/ip-sysctl.rst | 75 ++++++++++++++++++++++++++
 include/net/netns/ipv4.h               |  5 ++
 net/ipv4/sysctl_net_ipv4.c             | 43 +++++++++++++++
 net/ipv4/tcp_ipv4.c                    |  8 +++
 4 files changed, 131 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index e7b3fa7bb3f7..815efc89ad73 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1069,6 +1069,81 @@ tcp_child_ehash_entries - INTEGER
 
 	Default: 0
 
+tcp_plb_enabled - BOOLEAN
+	If set and the underlying congestion control (e.g. DCTCP) supports
+	and enables PLB feature, TCP PLB (Protective Load Balancing) is
+	enabled. PLB is described in the following paper:
+	https://doi.org/10.1145/3544216.3544226. Based on PLB parameters,
+	upon sensing sustained congestion, TCP triggers a change in
+	flow label field for outgoing IPv6 packets. A change in flow label
+	field potentially changes the path of outgoing packets for switches
+	that use ECMP/WCMP for routing.
+
+	PLB changes socket txhash which results in a change in IPv6 Flow Label
+	field, and currently no-op for IPv4 headers. It is possible
+	to apply PLB for IPv4 with other network header fields (e.g. TCP
+	or IPv4 options) or using encapsulation where outer header is used
+	by switches to determine next hop. In either case, further host
+	and switch side changes will be needed.
+
+	When set, PLB assumes that congestion signal (e.g. ECN) is made
+	available and used by congestion control module to estimate a
+	congestion measure (e.g. ce_ratio). PLB needs a congestion measure to
+	make repathing decisions.
+
+	Default: FALSE
+
+tcp_plb_idle_rehash_rounds - INTEGER
+	Number of consecutive congested rounds (RTT) seen after which
+	a rehash can be performed, given there are no packets in flight.
+	This is referred to as M in PLB paper:
+	https://doi.org/10.1145/3544216.3544226.
+
+	Possible Values: 0 - 31
+
+	Default: 3
+
+tcp_plb_rehash_rounds - INTEGER
+	Number of consecutive congested rounds (RTT) seen after which
+	a forced rehash can be performed. Be careful when setting this
+	parameter, as a small value increases the risk of retransmissions.
+	This is referred to as N in PLB paper:
+	https://doi.org/10.1145/3544216.3544226.
+
+	Possible Values: 0 - 31
+
+	Default: 12
+
+tcp_plb_suspend_rto_sec - INTEGER
+	Time, in seconds, to suspend PLB in event of an RTO. In order to avoid
+	having PLB repath onto a connectivity "black hole", after an RTO a TCP
+	connection suspends PLB repathing for a random duration between 1x and
+	2x of this parameter. Randomness is added to avoid concurrent rehashing
+	of multiple TCP connections. This should be set corresponding to the
+	amount of time it takes to repair a failed link.
+
+	Possible Values: 0 - 255
+
+	Default: 60
+
+tcp_plb_cong_thresh - INTEGER
+	Fraction of packets marked with congestion over a round (RTT) to
+	tag that round as congested. This is referred to as K in the PLB paper:
+	https://doi.org/10.1145/3544216.3544226.
+
+	The 0-1 fraction range is mapped to 0-256 range to avoid floating
+	point operations. For example, 128 means that if at least 50% of
+	the packets in a round were marked as congested then the round
+	will be tagged as congested.
+
+	Setting threshold to 0 means that PLB repaths every RTT regardless
+	of congestion. This is not intended behavior for PLB and should be
+	used only for experimentation purpose.
+
+	Possible Values: 0 - 256
+
+	Default: 128
+
 UDP variables
 =============
 
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 1b8004679445..25f90bba4889 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -183,6 +183,11 @@ struct netns_ipv4 {
 	unsigned long tfo_active_disable_stamp;
 	u32 tcp_challenge_timestamp;
 	u32 tcp_challenge_count;
+	u8 sysctl_tcp_plb_enabled;
+	u8 sysctl_tcp_plb_idle_rehash_rounds;
+	u8 sysctl_tcp_plb_rehash_rounds;
+	u8 sysctl_tcp_plb_suspend_rto_sec;
+	int sysctl_tcp_plb_cong_thresh;
 
 	int sysctl_udp_wmem_min;
 	int sysctl_udp_rmem_min;
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 9b8a6db7a66b..0af28cedd071 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -40,6 +40,8 @@ static int one_day_secs = 24 * 3600;
 static u32 fib_multipath_hash_fields_all_mask __maybe_unused =
 	FIB_MULTIPATH_HASH_FIELD_ALL_MASK;
 static unsigned int tcp_child_ehash_entries_max = 16 * 1024 * 1024;
+static int tcp_plb_max_rounds = 31;
+static int tcp_plb_max_cong_thresh = 256;
 
 /* obsolete */
 static int sysctl_tcp_low_latency __read_mostly;
@@ -1384,6 +1386,47 @@ static struct ctl_table ipv4_net_table[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_TWO,
 	},
+	{
+		.procname       = "tcp_plb_enabled",
+		.data           = &init_net.ipv4.sysctl_tcp_plb_enabled,
+		.maxlen         = sizeof(u8),
+		.mode           = 0644,
+		.proc_handler   = proc_dou8vec_minmax,
+		.extra1         = SYSCTL_ZERO,
+		.extra2         = SYSCTL_ONE,
+	},
+	{
+		.procname       = "tcp_plb_idle_rehash_rounds",
+		.data           = &init_net.ipv4.sysctl_tcp_plb_idle_rehash_rounds,
+		.maxlen         = sizeof(u8),
+		.mode           = 0644,
+		.proc_handler   = proc_dou8vec_minmax,
+		.extra2		= &tcp_plb_max_rounds,
+	},
+	{
+		.procname       = "tcp_plb_rehash_rounds",
+		.data           = &init_net.ipv4.sysctl_tcp_plb_rehash_rounds,
+		.maxlen         = sizeof(u8),
+		.mode           = 0644,
+		.proc_handler   = proc_dou8vec_minmax,
+		.extra2         = &tcp_plb_max_rounds,
+	},
+	{
+		.procname       = "tcp_plb_suspend_rto_sec",
+		.data           = &init_net.ipv4.sysctl_tcp_plb_suspend_rto_sec,
+		.maxlen         = sizeof(u8),
+		.mode           = 0644,
+		.proc_handler   = proc_dou8vec_minmax,
+	},
+	{
+		.procname       = "tcp_plb_cong_thresh",
+		.data           = &init_net.ipv4.sysctl_tcp_plb_cong_thresh,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = SYSCTL_ZERO,
+		.extra2         = &tcp_plb_max_cong_thresh,
+	},
 	{ }
 };
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 6376ad915765..e3911138edae 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3216,6 +3216,14 @@ static int __net_init tcp_sk_init(struct net *net)
 	net->ipv4.sysctl_tcp_fastopen_blackhole_timeout = 0;
 	atomic_set(&net->ipv4.tfo_active_disable_times, 0);
 
+	/* Set default values for PLB */
+	net->ipv4.sysctl_tcp_plb_enabled = 0; /* Disabled by default */
+	net->ipv4.sysctl_tcp_plb_idle_rehash_rounds = 3;
+	net->ipv4.sysctl_tcp_plb_rehash_rounds = 12;
+	net->ipv4.sysctl_tcp_plb_suspend_rto_sec = 60;
+	/* Default congestion threshold for PLB to mark a round is 50% */
+	net->ipv4.sysctl_tcp_plb_cong_thresh = 128;
+
 	/* Reno is always built in */
 	if (!net_eq(net, &init_net) &&
 	    bpf_try_module_get(init_net.ipv4.tcp_congestion_control,
-- 
2.38.0.rc1.362.ged0d419d3c-goog

