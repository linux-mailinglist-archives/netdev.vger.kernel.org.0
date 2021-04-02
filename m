Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C06A9352EF4
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 20:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235657AbhDBSHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 14:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234628AbhDBSHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 14:07:52 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A48C0613E6
        for <netdev@vger.kernel.org>; Fri,  2 Apr 2021 11:07:51 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id m11so1409583pfc.11
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 11:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AcRKoPZ+Vwa/tXGYh28L5mmlmSuw26i64Nh8atw25Qg=;
        b=MteIgvXbGJ7+m1iaGl0tKPIE9MvF5RnSwlXpCR4JbYjrR2k2WO/k+Ach41Q+YhxX+c
         kyuxn0SHTFikvEq7GRz/WIJ1Gnh275pt241IGmEWbTF3/2fUvV5xXSzvMXYoWDJ8s0z2
         F75BO8XQUT4yT9W5AIXh194P7B1Xd81jvyhnmMRXGfH+kGbLE+ElJfOKi4z90PGSCPC0
         hqBciVO6zMHf0b3kUfFScfphxo2WTf+Fe+lZIulSf3CmFGCbjmQEQXJgMTPRXSddoWb3
         K7w6F2Nx+6AV8bR6AOhr8Tb5ulyRFvKoEGAjVv87CsP//K5wqG5Jhd5KNANHO/NGEYQx
         b/NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AcRKoPZ+Vwa/tXGYh28L5mmlmSuw26i64Nh8atw25Qg=;
        b=XoNHHfpMrf+dtNg7rcU+L6+aMeV1oKVI9MHcmsE4SXvuppb/YmCXY+26YFYZGGiYOz
         Wo9eKnmcDo6WKjVVawxE/ZT9N6aErJlgHsvlGbSj307ZHpB3RQ8Ii/dvkD0Xo9rELydR
         kyRD4KdaGpNx6Beqe/AdUqrK9pW73UXCqVIZOELzj/JsTmptHnF9Y1suEsjj76XxSqR8
         dhhLSLIvSrT4PhMJ/phhX0aBuMMW5rjfGUOyPrxSvPW0hVqv25ELMxKD5Er96Evk62P/
         gYlRuTbcZdoAObGeDZil5Tb2cTD9eiV4o+hW8p8i1dxQs0wfy4K+NpLYWW9hNjvfXHQT
         rfWw==
X-Gm-Message-State: AOAM531rZZRnfqiB/M8IFJzS+7XwNJEUrVrAz2SvQQWlXV+OTReerz4c
        OBZp0Y5zZ9qEeWXmPR5ECNQ=
X-Google-Smtp-Source: ABdhPJyrIoTY0rrUNZrX8WpbTeoTcjeOxU6tY5bXY9M1Xof97CsJjz91EIf8VH39iUr43h0q002xMQ==
X-Received: by 2002:a65:4046:: with SMTP id h6mr12736016pgp.345.1617386871106;
        Fri, 02 Apr 2021 11:07:51 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:a57a:ec96:644b:4d80])
        by smtp.gmail.com with ESMTPSA id x2sm8679461pgb.89.2021.04.02.11.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 11:07:50 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] net: reorganize fields in netns_mib
Date:   Fri,  2 Apr 2021 11:07:46 -0700
Message-Id: <20210402180746.19364-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Order fields to increase locality for most used protocols.

udplite and icmp are moved at the end.

Same for proc_net_devsnmp6 which is not used in fast path.

This potentially saves one cache line miss for typical TCP/UDP over IPv4/IPv6.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/netns/mib.h | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/include/net/netns/mib.h b/include/net/netns/mib.h
index 59b2c3a3db423a1ffc256ac1f5d671a8cd438453..7e373664b1e7baaa7cdb3df572f2b5a78aff0a39 100644
--- a/include/net/netns/mib.h
+++ b/include/net/netns/mib.h
@@ -5,22 +5,19 @@
 #include <net/snmp.h>
 
 struct netns_mib {
-	DEFINE_SNMP_STAT(struct tcp_mib, tcp_statistics);
 	DEFINE_SNMP_STAT(struct ipstats_mib, ip_statistics);
+#if IS_ENABLED(CONFIG_IPV6)
+	DEFINE_SNMP_STAT(struct ipstats_mib, ipv6_statistics);
+#endif
+
+	DEFINE_SNMP_STAT(struct tcp_mib, tcp_statistics);
 	DEFINE_SNMP_STAT(struct linux_mib, net_statistics);
+
 	DEFINE_SNMP_STAT(struct udp_mib, udp_statistics);
-	DEFINE_SNMP_STAT(struct udp_mib, udplite_statistics);
-	DEFINE_SNMP_STAT(struct icmp_mib, icmp_statistics);
-	DEFINE_SNMP_STAT_ATOMIC(struct icmpmsg_mib, icmpmsg_statistics);
-
 #if IS_ENABLED(CONFIG_IPV6)
-	struct proc_dir_entry *proc_net_devsnmp6;
 	DEFINE_SNMP_STAT(struct udp_mib, udp_stats_in6);
-	DEFINE_SNMP_STAT(struct udp_mib, udplite_stats_in6);
-	DEFINE_SNMP_STAT(struct ipstats_mib, ipv6_statistics);
-	DEFINE_SNMP_STAT(struct icmpv6_mib, icmpv6_statistics);
-	DEFINE_SNMP_STAT_ATOMIC(struct icmpv6msg_mib, icmpv6msg_statistics);
 #endif
+
 #ifdef CONFIG_XFRM_STATISTICS
 	DEFINE_SNMP_STAT(struct linux_xfrm_mib, xfrm_statistics);
 #endif
@@ -30,6 +27,19 @@ struct netns_mib {
 #ifdef CONFIG_MPTCP
 	DEFINE_SNMP_STAT(struct mptcp_mib, mptcp_statistics);
 #endif
+
+	DEFINE_SNMP_STAT(struct udp_mib, udplite_statistics);
+#if IS_ENABLED(CONFIG_IPV6)
+	DEFINE_SNMP_STAT(struct udp_mib, udplite_stats_in6);
+#endif
+
+	DEFINE_SNMP_STAT(struct icmp_mib, icmp_statistics);
+	DEFINE_SNMP_STAT_ATOMIC(struct icmpmsg_mib, icmpmsg_statistics);
+#if IS_ENABLED(CONFIG_IPV6)
+	DEFINE_SNMP_STAT(struct icmpv6_mib, icmpv6_statistics);
+	DEFINE_SNMP_STAT_ATOMIC(struct icmpv6msg_mib, icmpv6msg_statistics);
+	struct proc_dir_entry *proc_net_devsnmp6;
+#endif
 };
 
 #endif
-- 
2.31.0.208.g409f899ff0-goog

