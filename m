Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8D3D25A13A
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 00:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgIAWLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 18:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgIAWLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 18:11:04 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988B8C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 15:11:04 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id t11so2105285qtn.8
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 15:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=IHoB9g5kwwEBgzb+RkMXlT2U0Cb/reEEbr/FktuXBX8=;
        b=BYipI64gqK0zCqMpO2vI2v+vhqXTz2uoj2EIr/UN0F2UXTT4m7MS64OQzEBVHXrxLY
         Bw8zfMmNGD0o37zA5TDeSb0YF3YDyer+FVPk/LOM9bdI2arC2utkE5fAGe7GA2y3o+NF
         InqdeuNVmnbYN4RHVOwKKDr8PjaZoPUHzQh1WEozbbri5rmQ1ZyDUrr6MBm5y0GJy/M3
         gEHhsc5uQFJGUg4EWbavsLfQNefoOnWKU0QCh1tMUp+pssbTgTtOdZUs4WcXKUyrtfb6
         D0T2ylfIWzVpQ6oulydyXamF82KN3gvXttUOxM51fxVDXnKgTaMRfKVRh/ey739bJDFi
         NDrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=IHoB9g5kwwEBgzb+RkMXlT2U0Cb/reEEbr/FktuXBX8=;
        b=VBz4HHNBd1h7LBVhKuPlGo+o8V2GCT+cPeRPUf7LNGa89SJX1lVGVk7vL9RDN1a0fv
         9cWJI2h7ZLreIeiVf+JTDnacIuaq+BZWI/f2XJ6GxaFNsl/TbLrA5S3DHheItJ9U8M7H
         rLiThVRbeTrBSa7D4clOSoHEZ+rJDJcHJR5oDmBXC+BfogAIThmChaKGTlYusKbeBxTE
         WG95rhfGyYfkCScC/GJAB3Nr5VtHjd2weMukwr7PW1wkqFAHAq3w2krv/IGpJHHSA1/r
         zKMN32kuRAX55ybpdBGoH8JC0CVMUHJVbhGybPSzIhNsFZcbHoL83wM2iL4iAJbA04zt
         JZhQ==
X-Gm-Message-State: AOAM532d+DmVgZ9DE5eDRwH7Gtk1LY6uQ4J3DIxIt53qOXc0r/h5m5x7
        cWqGdAgNpRvJQBOTd1v6YLWHJbXFRxU=
X-Google-Smtp-Source: ABdhPJxA2IYljlC4h9AEOW36OftONGLJ6Zlm5k3q/Aks7pzw2cntz8F86x54Dnb0EAZa/jHn5Avd4SrLsy4=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a0c:b2d4:: with SMTP id d20mr4252735qvf.1.1598998262471;
 Tue, 01 Sep 2020 15:11:02 -0700 (PDT)
Date:   Tue,  1 Sep 2020 15:10:08 -0700
Message-Id: <20200901221008.611862-1-weiwan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH net-next] ip: expose inet sockopts through inet_diag
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wei Wang <weiwan@google.com>, Eric Dumazet <edumazet@google.com>,
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
2.28.0.402.g5ffc5be6b7-goog

