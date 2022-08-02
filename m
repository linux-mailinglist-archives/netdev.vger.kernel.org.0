Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA56B587CB8
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 14:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236788AbiHBM4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 08:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236168AbiHBM4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 08:56:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E5412616
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 05:56:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 429BDB81EFC
        for <netdev@vger.kernel.org>; Tue,  2 Aug 2022 12:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF73C433C1;
        Tue,  2 Aug 2022 12:56:29 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GjvNyleW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1659444988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5apaPDiI45nhJ37Nmsnxf8EGQEbPMSiuOr9S1vFaSCo=;
        b=GjvNyleWYWa6EvhNfekVvEl6Y/Bos8u52L1S5nfwfm8oahePZ7d2jKgOYgKwb8Ay3TsXRL
        MogRAioAMYICXD113hUulbkqvyYZ3JlQ3x5QryHoRcFztaWC30Siv6iPxEPU876tWsj/aY
        CHQC3OKN2jqr+ELSYxniPHMStAlomFY=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ebed5159 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 2 Aug 2022 12:56:27 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     kuba@kernel.org, pablo@netfilter.org, netdev@vger.kernel.org
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH next-next 2/4] wireguard: selftests: update config fragments
Date:   Tue,  2 Aug 2022 14:56:11 +0200
Message-Id: <20220802125613.340848-3-Jason@zx2c4.com>
In-Reply-To: <20220802125613.340848-1-Jason@zx2c4.com>
References: <20220802125613.340848-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

The kernel.config and debug.config fragments in wireguard selftests mention
some config symbols that have been reworked:

Commit c5665868183f ("mm: kmemleak: use the memory pool for early
allocations") removes the config DEBUG_KMEMLEAK_EARLY_LOG_SIZE and since
then, the config's feature is available without further configuration.

Commit 4675ff05de2d ("kmemcheck: rip it out") removes kmemcheck and the
corresponding arch config HAVE_ARCH_KMEMCHECK. There is no need for this
config.

Commit 3bf195ae6037 ("netfilter: nat: merge nf_nat_ipv4,6 into nat core")
removes the config NF_NAT_IPV4 and since then, the config's feature is
available without further configuration.

Commit 41a2901e7d22 ("rcu: Remove SPARSE_RCU_POINTER Kconfig option")
removes the config SPARSE_RCU_POINTER and since then, the config's feature
is enabled by default.

Commit dfb4357da6dd ("time: Remove CONFIG_TIMER_STATS") removes the feature
and config CONFIG_TIMER_STATS without any replacement.

Commit 3ca17b1f3628 ("lib/ubsan: remove null-pointer checks") removes the
check and config UBSAN_NULL without any replacement.

Adjust the config fragments to those changes in configs.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 tools/testing/selftests/wireguard/qemu/debug.config  | 5 -----
 tools/testing/selftests/wireguard/qemu/kernel.config | 1 -
 2 files changed, 6 deletions(-)

diff --git a/tools/testing/selftests/wireguard/qemu/debug.config b/tools/testing/selftests/wireguard/qemu/debug.config
index 2b321b8a96cf..9d172210e2c6 100644
--- a/tools/testing/selftests/wireguard/qemu/debug.config
+++ b/tools/testing/selftests/wireguard/qemu/debug.config
@@ -18,15 +18,12 @@ CONFIG_DEBUG_VM=y
 CONFIG_DEBUG_MEMORY_INIT=y
 CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
 CONFIG_DEBUG_STACKOVERFLOW=y
-CONFIG_HAVE_ARCH_KMEMCHECK=y
 CONFIG_HAVE_ARCH_KASAN=y
 CONFIG_KASAN=y
 CONFIG_KASAN_INLINE=y
 CONFIG_UBSAN=y
 CONFIG_UBSAN_SANITIZE_ALL=y
-CONFIG_UBSAN_NULL=y
 CONFIG_DEBUG_KMEMLEAK=y
-CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=8192
 CONFIG_DEBUG_STACK_USAGE=y
 CONFIG_DEBUG_SHIRQ=y
 CONFIG_WQ_WATCHDOG=y
@@ -35,7 +32,6 @@ CONFIG_SCHED_INFO=y
 CONFIG_SCHEDSTATS=y
 CONFIG_SCHED_STACK_END_CHECK=y
 CONFIG_DEBUG_TIMEKEEPING=y
-CONFIG_TIMER_STATS=y
 CONFIG_DEBUG_PREEMPT=y
 CONFIG_DEBUG_RT_MUTEXES=y
 CONFIG_DEBUG_SPINLOCK=y
@@ -49,7 +45,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_DEBUG_LIST=y
 CONFIG_DEBUG_PLIST=y
 CONFIG_PROVE_RCU=y
-CONFIG_SPARSE_RCU_POINTER=y
 CONFIG_RCU_CPU_STALL_TIMEOUT=21
 CONFIG_RCU_TRACE=y
 CONFIG_RCU_EQS_DEBUG=y
diff --git a/tools/testing/selftests/wireguard/qemu/kernel.config b/tools/testing/selftests/wireguard/qemu/kernel.config
index bad88f4b0a03..75267bd9c8ad 100644
--- a/tools/testing/selftests/wireguard/qemu/kernel.config
+++ b/tools/testing/selftests/wireguard/qemu/kernel.config
@@ -19,7 +19,6 @@ CONFIG_NETFILTER_XTABLES=y
 CONFIG_NETFILTER_XT_NAT=y
 CONFIG_NETFILTER_XT_MATCH_LENGTH=y
 CONFIG_NETFILTER_XT_MARK=y
-CONFIG_NF_NAT_IPV4=y
 CONFIG_IP_NF_IPTABLES=y
 CONFIG_IP_NF_FILTER=y
 CONFIG_IP_NF_MANGLE=y
-- 
2.35.1

