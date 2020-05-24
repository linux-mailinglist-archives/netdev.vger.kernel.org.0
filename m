Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3DF1E0325
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 23:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388251AbgEXVcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 17:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387879AbgEXVcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 May 2020 17:32:04 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93632C061A0E;
        Sun, 24 May 2020 14:32:04 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id 190so16083072qki.1;
        Sun, 24 May 2020 14:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zsTKP6UPCyjc3gedPSTiX+Hw4fSD23Gy2TgvwORJtZI=;
        b=WbcDYwGhcm7jTcpYsw7Uxi8nCjwbcze3sDcocME48h3tDO1Q7VdThjO3mT9nZrpjOt
         A/5Ugjl0WHy8J95fuBA9b7z8/NiuzPoQSpPzht4z9djsNxsxVsrOI2uMmwUU+MHw3GXE
         EsvINxgU6yBaDDmDV5YzXTDE3UfoppBUgL0R9uT0zN499lY9XXBf8Y/FH4HfswMlAiCe
         +l6pq2lhzmNzsBIsfb4/APiIy8s6huWB/+/NOWQo3DATC9lyUDeSakBxwmrzxjOHEdla
         kAa7/Kio89/prvuSyYvsQIuodjrJ4cgWUvhdf+bNN1Nbxol9Pth3VvkxRYVKps8bfbog
         tg3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zsTKP6UPCyjc3gedPSTiX+Hw4fSD23Gy2TgvwORJtZI=;
        b=pRXQItmpRBwUKdBiWl85hDg6mCxsbXDtz2q2uDmZhXzOrcHuxS2QoD5VlAQ4AD2UXw
         b6RW7WYl0BDPJjiodxmY2XbKR+mNe6L4L0rAu5J8yvrKpyxgfVSMftvZkRQtIt0V9/FY
         TYtnUmD9ZCLTTbm/7M2IGRmxokFfXaaksg1nv75/dD72tqVfv/mPg9fs9R4iK7ab7GzB
         6mcwC94lLTpN1opqmaP78ASzjRK9pszmTjNQXr4irCFtV73Z5e2j7oHVYOGW6g2IjjfF
         5yPhrJk8svgUJXM5HaR6Ju2neuoQdzNPbknigGaGEfiiHyCmWWlthyUqiRL+OlRhYobo
         1Bhg==
X-Gm-Message-State: AOAM532X02ImU/VrgaAsOSHO7luPg1ApYqjuCPNtMUbGSCMTP1XsAX6K
        qArbbH4544m4PHdGDraHohs=
X-Google-Smtp-Source: ABdhPJwN6C5sOR0YlCVooSvLA7ctJR5Lw+j/WHrsTM1GIgdU94ksuZcgYt/CUIHOBpimjH5OPJmAPQ==
X-Received: by 2002:a37:6389:: with SMTP id x131mr18589657qkb.160.1590355923525;
        Sun, 24 May 2020 14:32:03 -0700 (PDT)
Received: from localhost.localdomain (toroon0411w-lp130-02-64-231-189-42.dsl.bell.ca. [64.231.189.42])
        by smtp.googlemail.com with ESMTPSA id n13sm2110197qtb.20.2020.05.24.14.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2020 14:32:02 -0700 (PDT)
From:   Andrew Sy Kim <kim.andrewsy@gmail.com>
Cc:     kim.andrewsy@gmail.com, Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH] netfilter/ipvs: immediately expire no destination connections in kthread if expire_nodest_conn=1
Date:   Sun, 24 May 2020 17:31:05 -0400
Message-Id: <20200524213105.14805-1-kim.andrewsy@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <alpine.LFD.2.21.2005192139500.3504@ja.home.ssi.bg>
References: <alpine.LFD.2.21.2005192139500.3504@ja.home.ssi.bg>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If expire_nodest_conn=1 and a destination is deleted, IPVS should
also expire all matching connections immiediately instead of waiting for
the next matching packet. This is particulary useful when there are a
lot of packets coming from a few number of clients. Those clients are
likely to match against existing entries if a source port in the
connection hash is reused. When the number of entries in the connection
tracker is large, we can significantly reduce the number of dropped
packets by expiring all connections upon deletion in a kthread.

Signed-off-by: Andrew Sy Kim <kim.andrewsy@gmail.com>
---
 include/net/ip_vs.h             | 12 +++++++++
 net/netfilter/ipvs/ip_vs_conn.c | 48 +++++++++++++++++++++++++++++++++
 net/netfilter/ipvs/ip_vs_core.c | 45 +++++++++++++------------------
 net/netfilter/ipvs/ip_vs_ctl.c  | 16 +++++++++++
 4 files changed, 95 insertions(+), 26 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 83be2d93b407..d1fbead6965d 100644
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
@@ -1209,6 +1214,13 @@ struct ip_vs_conn * ip_vs_conn_out_get_proto(struct netns_ipvs *ipvs, int af,
 					     const struct sk_buff *skb,
 					     const struct ip_vs_iphdr *iph);
 
+
+int ip_vs_conn_flush_dest(void *data);
+struct ip_vs_conn_flush_dest_tinfo {
+	struct netns_ipvs *ipvs;
+	struct ip_vs_dest *dest;
+};
+
 /* Get reference to gain full access to conn.
  * By default, RCU read-side critical sections have access only to
  * conn fields and its PE data, see ip_vs_conn_rcu_free() for reference.
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 02f2f636798d..111fa0e287a2 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1366,6 +1366,54 @@ static void ip_vs_conn_flush(struct netns_ipvs *ipvs)
 		goto flush_again;
 	}
 }
+
+/*	Thread function to flush all the connection entries in the
+ *	ip_vs_conn_tab with a matching destination.
+ */
+int ip_vs_conn_flush_dest(void *data)
+{
+	struct ip_vs_conn_flush_dest_tinfo *tinfo = data;
+	struct netns_ipvs *ipvs = tinfo->ipvs;
+	struct ip_vs_dest *dest = tinfo->dest;
+
+	int idx;
+	struct ip_vs_conn *cp, *cp_c;
+
+	IP_VS_DBG_BUF(4, "flushing all connections with destination %s:%d",
+		      IP_VS_DBG_ADDR(dest->af, &dest->addr), ntohs(dest->port));
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
+
+			IP_VS_DBG(4, "del connection\n");
+			ip_vs_conn_expire_now(cp);
+		}
+		cond_resched_rcu();
+	}
+	rcu_read_unlock();
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(ip_vs_conn_flush_dest);
+
 /*
  * per netns init and exit
  */
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index aa6a603a2425..ff052e57e054 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -24,6 +24,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/kthread.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
 #include <linux/sctp.h>
@@ -694,11 +695,6 @@ static int sysctl_nat_icmp_send(struct netns_ipvs *ipvs)
 	return ipvs->sysctl_nat_icmp_send;
 }
 
-static int sysctl_expire_nodest_conn(struct netns_ipvs *ipvs)
-{
-	return ipvs->sysctl_expire_nodest_conn;
-}
-
 #else
 
 static int sysctl_snat_reroute(struct netns_ipvs *ipvs) { return 0; }
@@ -2095,36 +2091,33 @@ ip_vs_in(struct netns_ipvs *ipvs, unsigned int hooknum, struct sk_buff *skb, int
 		}
 	}
 
-	if (unlikely(!cp)) {
-		int v;
-
-		if (!ip_vs_try_to_schedule(ipvs, af, skb, pd, &v, &cp, &iph))
-			return v;
-	}
-
-	IP_VS_DBG_PKT(11, af, pp, skb, iph.off, "Incoming packet");
-
 	/* Check the server status */
-	if (cp->dest && !(cp->dest->flags & IP_VS_DEST_F_AVAILABLE)) {
+	if (cp && cp->dest && !(cp->dest->flags & IP_VS_DEST_F_AVAILABLE)) {
 		/* the destination server is not available */
 
-		__u32 flags = cp->flags;
-
-		/* when timer already started, silently drop the packet.*/
-		if (timer_pending(&cp->timer))
-			__ip_vs_conn_put(cp);
-		else
-			ip_vs_conn_put(cp);
+		if (sysctl_expire_nodest_conn(ipvs)) {
+			bool uses_ct = ip_vs_conn_uses_conntrack(cp, skb);
 
-		if (sysctl_expire_nodest_conn(ipvs) &&
-		    !(flags & IP_VS_CONN_F_ONE_PACKET)) {
-			/* try to expire the connection immediately */
 			ip_vs_conn_expire_now(cp);
+			__ip_vs_conn_put(cp);
+			if (uses_ct)
+				return NF_DROP;
+			cp = NULL;
+		} else {
+			__ip_vs_conn_put(cp);
+			return NF_DROP;
 		}
+	}
 
-		return NF_DROP;
+	if (unlikely(!cp)) {
+		int v;
+
+		if (!ip_vs_try_to_schedule(ipvs, af, skb, pd, &v, &cp, &iph))
+			return v;
 	}
 
+	IP_VS_DBG_PKT(11, af, pp, skb, iph.off, "Incoming packet");
+
 	ip_vs_in_stats(cp, skb);
 	ip_vs_set_state(cp, IP_VS_DIR_INPUT, skb, pd);
 	if (cp->packet_xmit)
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 8d14a1acbc37..fa48268368fc 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1163,6 +1163,22 @@ static void __ip_vs_del_dest(struct netns_ipvs *ipvs, struct ip_vs_dest *dest,
 	list_add(&dest->t_list, &ipvs->dest_trash);
 	dest->idle_start = 0;
 	spin_unlock_bh(&ipvs->dest_trash_lock);
+
+	/*	If expire_nodest_conn is enabled, expire all connections
+	 *	immediately in a kthread.
+	 */
+	if (sysctl_expire_nodest_conn(ipvs)) {
+		struct ip_vs_conn_flush_dest_tinfo *tinfo = NULL;
+
+		tinfo = kcalloc(1, sizeof(struct ip_vs_conn_flush_dest_tinfo),
+				GFP_KERNEL);
+		tinfo->ipvs = ipvs;
+		tinfo->dest = dest;
+
+		IP_VS_DBG(3, "flushing connections in kthread\n");
+		kthread_run(ip_vs_conn_flush_dest,
+			    tinfo, "ipvs-flush-dest-conn");
+	}
 }
 
 
-- 
2.20.1

