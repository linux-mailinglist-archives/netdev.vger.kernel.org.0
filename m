Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF942A77D5
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 08:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgKEHQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 02:16:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgKEHQg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 02:16:36 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC94C0613CF;
        Wed,  4 Nov 2020 23:16:36 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id t14so751282pgg.1;
        Wed, 04 Nov 2020 23:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=hhbXWfzilHdlKVGC5rdQz6fKDU4k96FjnaKvZh4pRPo=;
        b=KtQjXMIoa3kotTG08yMMohy77IZBW6/R1ScqxPo8C4t7hagywAIZU9qgstzLYldm4B
         TnVJoKFI4xPlDZZ+ofM5hn/wcODKe0CaxQqEY3B/HFRXkC8NWc6mXVlgwMaN8F7Mx6Vj
         45WRNWbTR6LU8aIoUFr1v13ykxRMytM+YNELrBunYMAzNqCmwcVo/Cmf7Qh5GGschiEg
         LcSX4KCKnvaCzN+sVq/jEF/VpNc36XXzKU0oUggZuek6isaPNR3lecwZPGNVwNwARCX7
         8TtUIxjUAQA+lpTPip7afmqlrEF8WLxrtwhYtRVSw26++/bZ4WiqfYwiYMkMAAgL1Bce
         LDCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hhbXWfzilHdlKVGC5rdQz6fKDU4k96FjnaKvZh4pRPo=;
        b=ktSh6OAtRH2CEw7KLXsXmVnZ6lrWxjXWdQWdYoo+z0y8uLEMU655Ux/5zM42i2UFKD
         uxte7+PQpVxn1UevMFHGfBRLQViVUA7ESrJxcOZxuSzKOg/7mfiaJFG8yxxlgZtw8wwJ
         JkShcBZhqZinHQaZYh1qzZFcDW7gpt+8l4APpm8iD1FqGEVNNaU6BUMl40K2GHo2ZVb2
         NCIOe+qBhRpgx3gy6eNWWIxMScfVOWcfpm+UcvCWqMhd0hc7ttJzLvBTZ+RS1+UyTZ+K
         /t6E9Zu9bt3buuJzGlOdte5547Qp108Wk6AQtDpP6bv6hcd685IXR6lLMKfFfexaPaxu
         SClg==
X-Gm-Message-State: AOAM533IYrEMkN7FO+pV74RmTupLyNpqM6z2pKFdg8Twby9spzpFAaa6
        qflA6DpmupN/Y6uAJtXF05U=
X-Google-Smtp-Source: ABdhPJzxHugkfa+j5PNotCy8pVz0Vci/3VvGxr+rhyJ/VwmT5saMSC4vZNMrGdK/JnyTDs89EvlUxQ==
X-Received: by 2002:a63:1103:: with SMTP id g3mr1254098pgl.48.1604560595915;
        Wed, 04 Nov 2020 23:16:35 -0800 (PST)
Received: from localhost.localdomain ([154.93.3.113])
        by smtp.gmail.com with ESMTPSA id p19sm968155pjv.32.2020.11.04.23.16.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2020 23:16:35 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     kuba@kernel.org
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, davem@davemloft.net,
        ycheng@google.com, ncardwell@google.com, priyarjha@google.com,
        edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH net-next] net: udp: introduce UDP_MIB_MEMERRORS for udp_mem
Date:   Thu,  5 Nov 2020 02:16:11 -0500
Message-Id: <1604560572-18582-1-git-send-email-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

When udp_memory_allocated is at the limit, __udp_enqueue_schedule_skb
will return a -ENOBUFS, and skb will be dropped in __udp_queue_rcv_skb
without any counters being done. It's hard to find out what happened
once this happen.

So we introduce a UDP_MIB_MEMERRORS to do this job. Well, this change
looks friendly to the existing users, such as netstat:

$ netstat -u -s
Udp:
    0 packets received
    639 packets to unknown port received.
    158689 packet receive errors
    180022 packets sent
    RcvbufErrors: 20930
    MemErrors: 137759
UdpLite:
IpExt:
    InOctets: 257426235
    OutOctets: 257460598
    InNoECTPkts: 181177

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 include/uapi/linux/snmp.h | 1 +
 net/ipv4/proc.c           | 1 +
 net/ipv4/udp.c            | 3 +++
 net/ipv6/proc.c           | 2 ++
 net/ipv6/udp.c            | 3 +++
 5 files changed, 10 insertions(+)

diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
index f84e7bcad6de..26fc60ce9298 100644
--- a/include/uapi/linux/snmp.h
+++ b/include/uapi/linux/snmp.h
@@ -159,6 +159,7 @@ enum
 	UDP_MIB_SNDBUFERRORS,			/* SndbufErrors */
 	UDP_MIB_CSUMERRORS,			/* InCsumErrors */
 	UDP_MIB_IGNOREDMULTI,			/* IgnoredMulti */
+	UDP_MIB_MEMERRORS,			/* MemErrors */
 	__UDP_MIB_MAX
 };
 
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 8d5e1695b9aa..63cd370ea29d 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -167,6 +167,7 @@ static const struct snmp_mib snmp4_udp_list[] = {
 	SNMP_MIB_ITEM("SndbufErrors", UDP_MIB_SNDBUFERRORS),
 	SNMP_MIB_ITEM("InCsumErrors", UDP_MIB_CSUMERRORS),
 	SNMP_MIB_ITEM("IgnoredMulti", UDP_MIB_IGNOREDMULTI),
+	SNMP_MIB_ITEM("MemErrors", UDP_MIB_MEMERRORS),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 09f0a23d1a01..aa1bd53dd9f9 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2038,6 +2038,9 @@ static int __udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 		if (rc == -ENOMEM)
 			UDP_INC_STATS(sock_net(sk), UDP_MIB_RCVBUFERRORS,
 					is_udplite);
+		else
+			UDP_INC_STATS(sock_net(sk), UDP_MIB_MEMERRORS,
+					is_udplite);
 		UDP_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
 		kfree_skb(skb);
 		trace_udp_fail_queue_rcv_skb(rc, sk);
diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index bbff3e02e302..d6306aa46bb1 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -126,6 +126,7 @@ static const struct snmp_mib snmp6_udp6_list[] = {
 	SNMP_MIB_ITEM("Udp6SndbufErrors", UDP_MIB_SNDBUFERRORS),
 	SNMP_MIB_ITEM("Udp6InCsumErrors", UDP_MIB_CSUMERRORS),
 	SNMP_MIB_ITEM("Udp6IgnoredMulti", UDP_MIB_IGNOREDMULTI),
+	SNMP_MIB_ITEM("Udp6MemErrors", UDP_MIB_MEMERRORS),
 	SNMP_MIB_SENTINEL
 };
 
@@ -137,6 +138,7 @@ static const struct snmp_mib snmp6_udplite6_list[] = {
 	SNMP_MIB_ITEM("UdpLite6RcvbufErrors", UDP_MIB_RCVBUFERRORS),
 	SNMP_MIB_ITEM("UdpLite6SndbufErrors", UDP_MIB_SNDBUFERRORS),
 	SNMP_MIB_ITEM("UdpLite6InCsumErrors", UDP_MIB_CSUMERRORS),
+	SNMP_MIB_ITEM("UdpLite6MemErrors", UDP_MIB_MEMERRORS),
 	SNMP_MIB_SENTINEL
 };
 
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 29d9691359b9..e6158e04e15c 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -637,6 +637,9 @@ static int __udpv6_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 		if (rc == -ENOMEM)
 			UDP6_INC_STATS(sock_net(sk),
 					 UDP_MIB_RCVBUFERRORS, is_udplite);
+		else
+			UDP6_INC_STATS(sock_net(sk),
+					 UDP_MIB_MEMERRORS, is_udplite);
 		UDP6_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
 		kfree_skb(skb);
 		return -1;
-- 
2.25.1


