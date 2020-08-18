Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E08249160
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 01:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgHRXOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 19:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgHRXOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 19:14:24 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81DFC061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 16:14:23 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a5so23746937ybh.3
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 16:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=ViRnANubrx12unDD5VCXwai30td+r6GsDOb/HM7Z1aU=;
        b=NNOKI/2M9TgkWef7oiV8nGRX6emDydz04CUQIeGay2weutmgV/tAzEGYIY2CdfzJtd
         ZWjzZ104ewtMaKhD4V31qZioHW/Xobt7H/MmqFrwxMI/jGKOycpqOj9dRVNmqwYs3RBU
         UPmDCY7z9Vw/VzOECM2DO0uMiTWqOJoVYiEOGwksKXP3xRoJJs+rf8ofx9sekDUiLUxR
         PrTIkye1oF+8lFLZGfuVeKekuKeqLbWyXcUl0znuqXhmwDceQAwDzLs2CvbyPz89/Rl3
         7NetuTBEwqVrlK+V5CJCqnBf2cr6q5F3fOuprwJHxg4nlwMl5x/FZoAwNt23x3nuonAa
         Ty9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=ViRnANubrx12unDD5VCXwai30td+r6GsDOb/HM7Z1aU=;
        b=XdkWJoj2OrOWvsB6vxdTJslO2mNXkI07Bwg1w9TTykdquABDN81ppSxLpYlEFDdiMV
         zPU4rRC6jpUhY4iD108skOSxLO6Luk2QzxXdU/AHc5igBFFxmiNgERFV0I2g0WyWqTbJ
         5s7V/rvL6ebBNdNJkZWhMiPWUgb7YiUaz7PmbGcEAUL4SijP9Il4t+iOJIDLWP5sCKA6
         M6ClzkjZt7nwClNHgxsPG93zC/R9O8tm1kpBmAE8JxX2kY2aBdTrXjzvOKZKggonqwMD
         FX9CHDyiXMO0/6bp93TWM99cn5Il1rQWr/J1z8Gq47gidmp7BnPoVMzSbDpk2+ZfMa2H
         Wxqw==
X-Gm-Message-State: AOAM533CA/gwFSDDARyhh2UQy4eLTcTZaN0l9kGW4Bq3ckLTJjiRARNI
        Kguo2uTZby5K8L1NYv/iS228VkkvHLg=
X-Google-Smtp-Source: ABdhPJx8uxcSFOF9apXy8LsmhjXRSxHgBXxAJ6WEZY90dePbQReETfQXTYiiLfgM9uPv06ISBL/i7BFsFHY=
X-Received: by 2002:a25:d30e:: with SMTP id e14mr29033519ybf.240.1597792463105;
 Tue, 18 Aug 2020 16:14:23 -0700 (PDT)
Date:   Tue, 18 Aug 2020 16:13:56 -0700
Message-Id: <20200818231356.1811759-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH net-next] ip: expose inet sockopts through inet_diag
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, Wei Wang <weiwan@google.com>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose all exisiting inet sockopt bits through inet_diag for debug purpose.
Corresponding changes in iproute2 ss will be submitted to output all
these values.

Signed-off-by: Wei Wang <weiwan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Mahesh Bandewar <maheshb@google.com>
---
 include/linux/inet_diag.h      |  2 ++
 include/uapi/linux/inet_diag.h | 18 ++++++++++++++++++
 net/ipv4/inet_diag.c           | 17 +++++++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/include/linux/inet_diag.h b/include/linux/inet_diag.h
index 0ef2d800fda7..84abb30a3fbb 100644
--- a/include/linux/inet_diag.h
+++ b/include/linux/inet_diag.h
@@ -75,6 +75,8 @@ static inline size_t inet_diag_msg_attrs_size(void)
 #ifdef CONFIG_SOCK_CGROUP_DATA
 		+ nla_total_size_64bit(sizeof(u64))  /* INET_DIAG_CGROUP_ID */
 #endif
+		+ nla_total_size(sizeof(struct inet_diag_sockopt))
+						     /* INET_DIAG_SOCKOPT */
 		;
 }
 int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
index 5ba122c1949a..20ee93f0f876 100644
--- a/include/uapi/linux/inet_diag.h
+++ b/include/uapi/linux/inet_diag.h
@@ -160,6 +160,7 @@ enum {
 	INET_DIAG_ULP_INFO,
 	INET_DIAG_SK_BPF_STORAGES,
 	INET_DIAG_CGROUP_ID,
+	INET_DIAG_SOCKOPT,
 	__INET_DIAG_MAX,
 };
 
@@ -183,6 +184,23 @@ struct inet_diag_meminfo {
 	__u32	idiag_tmem;
 };
 
+/* INET_DIAG_SOCKOPT */
+
+struct inet_diag_sockopt {
+	__u8	recverr:1,
+		is_icsk:1,
+		freebind:1,
+		hdrincl:1,
+		mc_loop:1,
+		transparent:1,
+		mc_all:1,
+		nodefrag:1;
+	__u8	bind_address_no_port:1,
+		recverr_rfc4884:1,
+		defer_connect:1,
+		unused:5;
+};
+
 /* INET_DIAG_VEGASINFO */
 
 struct tcpvegas_info {
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 4a98dd736270..93816d47e55a 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -125,6 +125,7 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
 			     bool net_admin)
 {
 	const struct inet_sock *inet = inet_sk(sk);
+	struct inet_diag_sockopt inet_sockopt;
 
 	if (nla_put_u8(skb, INET_DIAG_SHUTDOWN, sk->sk_shutdown))
 		goto errout;
@@ -180,6 +181,22 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
 	r->idiag_uid = from_kuid_munged(user_ns, sock_i_uid(sk));
 	r->idiag_inode = sock_i_ino(sk);
 
+	memset(&inet_sockopt, 0, sizeof(inet_sockopt));
+	inet_sockopt.recverr	= inet->recverr;
+	inet_sockopt.is_icsk	= inet->is_icsk;
+	inet_sockopt.freebind	= inet->freebind;
+	inet_sockopt.hdrincl	= inet->hdrincl;
+	inet_sockopt.mc_loop	= inet->mc_loop;
+	inet_sockopt.transparent = inet->transparent;
+	inet_sockopt.mc_all	= inet->mc_all;
+	inet_sockopt.nodefrag	= inet->nodefrag;
+	inet_sockopt.bind_address_no_port = inet->bind_address_no_port;
+	inet_sockopt.recverr_rfc4884 = inet->recverr_rfc4884;
+	inet_sockopt.defer_connect = inet->defer_connect;
+	if (nla_put(skb, INET_DIAG_SOCKOPT, sizeof(inet_sockopt),
+		    &inet_sockopt))
+		goto errout;
+
 	return 0;
 errout:
 	return 1;
-- 
2.28.0.297.g1956fa8f8d-goog

