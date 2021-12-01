Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25ED464579
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 04:32:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241570AbhLADgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 22:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233370AbhLADgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 22:36:10 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E88C061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 19:32:51 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id n85so22841166pfd.10
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 19:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CQTl1SrNMBCKPYTErlNsmnZqp5NDlN0J75RgC9/kOQM=;
        b=XzzegEnm/NtosugWhprIhx6iSW+/Qpq7OP7b0M0W8hSb6YXGOW+CcxCQD45glBvXme
         SL4IiLlHlcSMn2ePlc/47qU9lffgISNusytJfEtbvl8s/7hLliwnKPIqjKIp62qFJHsd
         S720QGhSto6EaT0oJa2qbi6cjAgA5Y19Vqv2hmtleo/M+KPazroPI4K0kctGC8ERPjaj
         0UJdNMHaMAbwVwj/OiEfAK+a0Ls4rY5NSqbutuQ+d0VlXT8BPp7gzLxem0XRG9V5sE5H
         07SVRnrQR3gfSYI2zH5a+w4+5e++4Q/vhPYVJmAjHH253P8kV+bmGkDAk8BnFZ7Ba56k
         th5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CQTl1SrNMBCKPYTErlNsmnZqp5NDlN0J75RgC9/kOQM=;
        b=rAqaZ651RhXHO0kFqD1AWo+GLkEaOjeUmTghjhdhbGXPZnEc1HIvv+CMnGGq/yK1RQ
         yZV07lsjmCGuvVkmrCJEmzefxZ/NnbKdaEaMLDWG4UuCCb9z9lamV3rlw3My3bJ2F2Uz
         igbVP6AuL9MQsUrkUb33RLiKPVJpgxBqEWKLLklnlndnBV9NCDOyRg69iZmGQuG+TCLW
         T5TKUvfE31YzDTktPoNk4MK9yDbfe+ijbQuwEbN1CWRpNuldgZ2cCqfzS62mhWaiYW++
         BkNrh5bTHPvo85evd9mLaQP7pFn8SpP8dqH/x9EHTdppiYIVXN2w2FzTqTc5+VF8RF//
         VVTA==
X-Gm-Message-State: AOAM530Q4kzihFlw0zg69QvNtyi/b+t4yHp1QfEQFxQw6ETxO8Xy9va6
        Ud12774df4HK67bBI5Enh2s=
X-Google-Smtp-Source: ABdhPJxcYtQLQSkYzTSu0W5tNOl5PB2d18BKLjiPV0/GQ1yTFj3/eD7DI4ZOnSa+C6B5fPil1+tbfQ==
X-Received: by 2002:a63:1956:: with SMTP id 22mr2692654pgz.452.1638329570095;
        Tue, 30 Nov 2021 19:32:50 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8fa3:c6c6:cc36:151])
        by smtp.gmail.com with ESMTPSA id mv22sm3763028pjb.36.2021.11.30.19.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 19:32:49 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Menglong Dong <imagedong@tencent.com>
Subject: [PATCH net-next] Revert "net: snmp: add statistics for tcp small queue check"
Date:   Tue, 30 Nov 2021 19:32:46 -0800
Message-Id: <20211201033246.2826224-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This reverts commit aeeecb889165617a841e939117f9a8095d0e7d80.

The new SNMP variable (TCPSmallQueueFailure) can be incremented
for good reasons, even on a 100Gbit single TCP_STREAM flow.

If we really wanted to ease driver debugging [1], this would
require something more sophisticated.

[1] Usually, if a driver is delaying TX completions too much,
this can lead to stalls in TCP output. Various work arounds
have been used in the past, like skb_orphan() in ndo_start_xmit().

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Menglong Dong <imagedong@tencent.com>
---
 include/uapi/linux/snmp.h | 1 -
 net/ipv4/proc.c           | 1 -
 net/ipv4/tcp_output.c     | 5 +----
 3 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index e32ec6932e8200fbc9e1f27d00bd43e7b34633d4..904909d020e2c8974128392370540c0ba3af4e15 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -292,7 +292,6 @@ enum
 	LINUX_MIB_TCPDSACKIGNOREDDUBIOUS,	/* TCPDSACKIgnoredDubious */
 	LINUX_MIB_TCPMIGRATEREQSUCCESS,		/* TCPMigrateReqSuccess */
 	LINUX_MIB_TCPMIGRATEREQFAILURE,		/* TCPMigrateReqFailure */
-	LINUX_MIB_TCPSMALLQUEUEFAILURE,		/* TCPSmallQueueFailure */
 	__LINUX_MIB_MAX
 };
 
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 43b7a77cd6b4588cc10150613cf05154640d679f..f30273afb5399ddf0122e46e36da2ddae720a1c3 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -297,7 +297,6 @@ static const struct snmp_mib snmp4_net_list[] = {
 	SNMP_MIB_ITEM("TCPDSACKIgnoredDubious", LINUX_MIB_TCPDSACKIGNOREDDUBIOUS),
 	SNMP_MIB_ITEM("TCPMigrateReqSuccess", LINUX_MIB_TCPMIGRATEREQSUCCESS),
 	SNMP_MIB_ITEM("TCPMigrateReqFailure", LINUX_MIB_TCPMIGRATEREQFAILURE),
-	SNMP_MIB_ITEM("TCPSmallQueueFailure", LINUX_MIB_TCPSMALLQUEUEFAILURE),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index c4ab6c8f0c77d32e1c4e7e558a6a0f0aa17a5986..5079832af5c1090917a8fd5dfb1a3025e2d85ae0 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2524,11 +2524,8 @@ static bool tcp_small_queue_check(struct sock *sk, const struct sk_buff *skb,
 		 * test again the condition.
 		 */
 		smp_mb__after_atomic();
-		if (refcount_read(&sk->sk_wmem_alloc) > limit) {
-			NET_INC_STATS(sock_net(sk),
-				      LINUX_MIB_TCPSMALLQUEUEFAILURE);
+		if (refcount_read(&sk->sk_wmem_alloc) > limit)
 			return true;
-		}
 	}
 	return false;
 }
-- 
2.34.0.rc2.393.gf8c9666880-goog

