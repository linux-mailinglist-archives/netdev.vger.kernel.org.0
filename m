Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF63D1D6B6D
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 19:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgEQR2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 13:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726244AbgEQR2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 13:28:05 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F01C061A0C;
        Sun, 17 May 2020 10:28:05 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e8so7561977ilm.7;
        Sun, 17 May 2020 10:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ezHFvOY0sk+1uJqHoIJwBLf+T1Zrvf/LHooFVb1kJ2Y=;
        b=okKoVE8ecn6B4uVqvhL84Q4qeJcLgXDfYK/x5Hqw5wZNxZ10k/dFZhpHV811uy/eDu
         fi4cCFdtlgB+hE2zqjsAvihscnXuYA+SwrdxlTU903oawUTyocqmnItkk3SIS+uUVXbH
         szy+ErfKRnVuHjkGwdGP6/9x1EsYLLaJb0cyP/Ueyrjov9ye7cHOEF15kF0paGAGdelA
         Zo9YqbaZ4Lduizehwy2aaVCXhwXZUYiesPZp1E1Ct8cjwzlb+t5Kj+FDouzRXKSKx8YZ
         72SEpSBAbR0QCVGPPoxixFcFjnnnrYV5WcajpxUUsjFo04ozM1Urw6W+KmC6Q/aYnQyx
         BKnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ezHFvOY0sk+1uJqHoIJwBLf+T1Zrvf/LHooFVb1kJ2Y=;
        b=mplAmVBRLZJ9rj6fg8GGU2QMZsOOFQfZ+ZgwpEC2oIUaELMP5fi7DBcsmmsoii4EkS
         T88aZNofUJjYQr82+lPP/dIXDI4oGNBjWNkYznI72LoCntKAWNkjLZTAsp2+TEYBUegV
         B40c7bixrKt41EbAqGnmApMs8EipQcSGcpfJBQlGPHijVv0bmOlZYt0Qfl+soMhepTHv
         fRtHyuhvyZb71R6U6DZ7JxGWmUqsnEbHnkQ/QgY6DetW02NlD4J1s0eEq+4Grc5KoVQq
         nZhP7diWOdbP672gwNmKEJG3x1vr/QgaQ6o3tzzGMMzCvV7+swYoaHnmSXnfY9KJFlH9
         yvNA==
X-Gm-Message-State: AOAM5335XBUMk5ueUAsoOj76I+TyJQAPh8XoJ5BB2msAbQi3BiTpR2fs
        8qqt66fGlpkxoBNzzp2E6a0=
X-Google-Smtp-Source: ABdhPJzRdjh8HbHfagb3ZqTdlewqZSJUGRBscEEtrhDvtZK9Nr2i35qO7EXrw6Xl6V6in80mxq4cOQ==
X-Received: by 2002:a92:9f4b:: with SMTP id u72mr11359892ili.273.1589736484888;
        Sun, 17 May 2020 10:28:04 -0700 (PDT)
Received: from localhost.localdomain (toroon0411w-lp130-03-174-95-146-183.dsl.bell.ca. [174.95.146.183])
        by smtp.googlemail.com with ESMTPSA id f17sm3103724iol.26.2020.05.17.10.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2020 10:28:04 -0700 (PDT)
From:   Andrew Sy Kim <kim.andrewsy@gmail.com>
Cc:     kim.andrewsy@gmail.com, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>, Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH] netfilter/ipvs: immediately expire UDP connections matching unavailable destination if expire_nodest_conn=1
Date:   Sun, 17 May 2020 13:16:53 -0400
Message-Id: <20200517171654.8194-1-kim.andrewsy@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200515013556.5582-1-kim.andrewsy@gmail.com>
References: <20200515013556.5582-1-kim.andrewsy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If expire_nodest_conn=1 and a UDP destination is deleted, IPVS should
also expire all matching connections immiediately instead of waiting for
the next matching packet. This is particulary useful when there are a
lot of packets coming from a few number of clients. Those clients are
likely to match against existing entries if a source port in the
connection hash is reused. When the number of entries in the connection
tracker is large, we can significantly reduce the number of dropped
packets by expiring all connections upon deletion.

Signed-off-by: Andrew Sy Kim <kim.andrewsy@gmail.com>
---
 include/net/ip_vs.h             |  7 ++++++
 net/netfilter/ipvs/ip_vs_conn.c | 38 +++++++++++++++++++++++++++++++++
 net/netfilter/ipvs/ip_vs_core.c |  5 -----
 net/netfilter/ipvs/ip_vs_ctl.c  |  9 ++++++++
 4 files changed, 54 insertions(+), 5 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 83be2d93b407..deecf1344676 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1049,6 +1049,11 @@ static inline int sysctl_conn_reuse_mode(struct netns_ipvs *ipvs)
 	return ipvs->sysctl_conn_reuse_mode;
 }
 
+static inline int sysctl_expire_nodest_conn(struct netns_ipvs *ipvs)
+{
+	return ipvs->sysctl_expire_nodest_conn;
+}
+
 static inline int sysctl_schedule_icmp(struct netns_ipvs *ipvs)
 {
 	return ipvs->sysctl_schedule_icmp;
@@ -1209,6 +1214,8 @@ struct ip_vs_conn * ip_vs_conn_out_get_proto(struct netns_ipvs *ipvs, int af,
 					     const struct sk_buff *skb,
 					     const struct ip_vs_iphdr *iph);
 
+void ip_vs_conn_flush_dest(struct netns_ipvs *ipvs, struct ip_vs_dest *dest);
+
 /* Get reference to gain full access to conn.
  * By default, RCU read-side critical sections have access only to
  * conn fields and its PE data, see ip_vs_conn_rcu_free() for reference.
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 02f2f636798d..c69dfbbc3416 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1366,6 +1366,44 @@ static void ip_vs_conn_flush(struct netns_ipvs *ipvs)
 		goto flush_again;
 	}
 }
+
+/*	Flush all the connection entries in the ip_vs_conn_tab with a
+ *	matching destination.
+ */
+void ip_vs_conn_flush_dest(struct netns_ipvs *ipvs, struct ip_vs_dest *dest)
+{
+	int idx;
+	struct ip_vs_conn *cp, *cp_c;
+
+	rcu_read_lock();
+	for (idx = 0; idx < ip_vs_conn_tab_size; idx++) {
+		hlist_for_each_entry_rcu(cp, &ip_vs_conn_tab[idx], c_list) {
+			if (cp->ipvs != ipvs)
+				continue;
+
+			if (cp->dest != dest)
+				continue;
+
+			/* As timers are expired in LIFO order, restart
+			 * the timer of controlling connection first, so
+			 * that it is expired after us.
+			 */
+			cp_c = cp->control;
+			/* cp->control is valid only with reference to cp */
+			if (cp_c && __ip_vs_conn_get(cp)) {
+				IP_VS_DBG(4, "del controlling connection\n");
+				ip_vs_conn_expire_now(cp_c);
+				__ip_vs_conn_put(cp);
+			}
+			IP_VS_DBG(4, "del connection\n");
+			ip_vs_conn_expire_now(cp);
+		}
+		cond_resched_rcu();
+	}
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(ip_vs_conn_flush_dest);
+
 /*
  * per netns init and exit
  */
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index aa6a603a2425..0139fa597d76 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -694,11 +694,6 @@ static int sysctl_nat_icmp_send(struct netns_ipvs *ipvs)
 	return ipvs->sysctl_nat_icmp_send;
 }
 
-static int sysctl_expire_nodest_conn(struct netns_ipvs *ipvs)
-{
-	return ipvs->sysctl_expire_nodest_conn;
-}
-
 #else
 
 static int sysctl_snat_reroute(struct netns_ipvs *ipvs) { return 0; }
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 8d14a1acbc37..f87c03622874 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1225,6 +1225,15 @@ ip_vs_del_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
 	 */
 	__ip_vs_del_dest(svc->ipvs, dest, false);
 
+	/*	If expire_nodest_conn is enabled and protocol is UDP,
+	 *	attempt best effort flush of all connections with this
+	 *	destination.
+	 */
+	if (sysctl_expire_nodest_conn(svc->ipvs) &&
+	    dest->protocol == IPPROTO_UDP) {
+		ip_vs_conn_flush_dest(svc->ipvs, dest);
+	}
+
 	LeaveFunction(2);
 
 	return 0;
-- 
2.20.1

