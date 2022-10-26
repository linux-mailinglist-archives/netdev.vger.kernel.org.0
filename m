Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06D5060E297
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbiJZNvy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:51:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233603AbiJZNvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:51:31 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19F41C409
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:51:28 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id f8so10534272qkg.3
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z482BQ5VrHht9kzLe4pEzyH6BMuV5WTZMJ6CE4Bzygo=;
        b=bSi6ezMyW3NfgXgaL4mqj9oY3fSDNO96K2c7+VROo77J0tZvlKQ+evk5HPIpk590Xd
         NUXDnp80y8T2GJPZ7ym8lfAPvmbDwqrRgF1qMnenyE4lqumBS8Feo8TMPdkXpxSmIAzQ
         MabPWqBtCPVPqpyY/3ApC7gKzyWVYWEy8ZafHavcU34T+0a43wYcicpoPyhQ0hMuIvmE
         lpn3TU1IySCmXujyf+kWJQuDDbRt85zfvLwLYBK3yZR2CdcXvWALqG3+QVaQ9j6fpuJW
         9yQcR2KNwMz4Q6t1heMs3q9+IIxdO+bOtB0Zd0bAV0Kjq48aV0k1suKVU2mWQ1Xv00qZ
         LrKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z482BQ5VrHht9kzLe4pEzyH6BMuV5WTZMJ6CE4Bzygo=;
        b=UyvQZGlJqd4eJoeUyZ6Z9sxtaWGBEatrAjHKe22NTZ7SyqasBalowoVDejXTrH9rTB
         J4JicpJd+OqVgAqo8VLyzBIcd4ucuurQVWyXnetSmnE/BLQ5GLjhp5u1quN5ATNr3F7D
         ENnCHLCtqL+YL7Uhouf28LZenUjpDUZPOwKisTSW/fwsfPtch4JQJcKlXyUnAmjfw93f
         4OE6MdpcCG8Lxrh1xifKC7eLbVJX95G2S0WRWtKEIX0JbkWzQE9/9ToSsTVzxAAbZ4ZO
         VPbb3Gk4Wk/SSWqLklQ6+Fbpp2zeE0Tu5ZpWvtIA1jrT/rXcJ5SzZHC1sLhd2sOUtQVu
         x7ng==
X-Gm-Message-State: ACrzQf1SPBHC9fQyoJFGRkLfbHeuckuLuDpmOvsqF6g7bYMgLhSPynzx
        tK9ofI/+ugUL4/3zsHQDqFRsv/CoLT+P+A==
X-Google-Smtp-Source: AMsMyM5lViFluGSoUPoGZuSAWR4J0ZrFW7EU06mqZuhwrs+krh778pN0gpCTFwYXiDTaXixBlUwUwQ==
X-Received: by 2002:a37:de03:0:b0:6ee:88a2:eb9a with SMTP id h3-20020a37de03000000b006ee88a2eb9amr30608502qkj.241.1666792287856;
        Wed, 26 Oct 2022 06:51:27 -0700 (PDT)
Received: from mubashirq.c.googlers.com.com (74.206.145.34.bc.googleusercontent.com. [34.145.206.74])
        by smtp.gmail.com with ESMTPSA id b24-20020ac84f18000000b00397101ac0f2sm3211836qte.3.2022.10.26.06.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 06:51:27 -0700 (PDT)
From:   Mubashir Adnan Qureshi <mubashirmaq@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org,
        Mubashir Adnan Qureshi <mubashirq@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 1/5] tcp: add sysctls for TCP PLB parameters
Date:   Wed, 26 Oct 2022 13:51:11 +0000
Message-Id: <20221026135115.3539398-2-mubashirmaq@gmail.com>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
In-Reply-To: <20221026135115.3539398-1-mubashirmaq@gmail.com>
References: <20221026135115.3539398-1-mubashirmaq@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
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
index 87d440f47a70..58b838b56c7f 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3218,6 +3218,14 @@ static int __net_init tcp_sk_init(struct net *net)
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
2.38.0.135.g90850a2211-goog

