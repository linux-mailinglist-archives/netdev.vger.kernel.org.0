Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E38C42FB68
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 20:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241555AbhJOSvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 14:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237973AbhJOSvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 14:51:00 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65AE8C061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 11:48:53 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id y4so6972322plb.0
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 11:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2xcjJslr96AfjkXSsl746hc+X71D3KZqwJSsDOouhA4=;
        b=LO6McjmcsND4GFj2fymsliWt7/38+mldmWjycz0HUT+I8CustL0ArkthQ3HpyjDRrj
         TeyYPeYOp9JiOlgt3w8VJBOmCZ0Q45pneJszBUA7M0I7EZKn2j9TY162Nxnt+e0CmP13
         ZbuJY2bFMaMDvoxBunNW1cw3FUO8PccET5D5l5ywiIXGAaOSIts7L3OABIOReLYPBPuQ
         wTwBEtzOK9+Klv+5MQ+jOfStMXfcILBrhSWC7p2f708t7X3pcVFkhCaMEh4CtRRLGoPk
         zXd490aSdsPwJF+Oi7mJEyAvFZf57i5/p8nsA7FINNeSmz6IWkUp0HW7GrGWB3OL7/7G
         iLoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2xcjJslr96AfjkXSsl746hc+X71D3KZqwJSsDOouhA4=;
        b=xpUt2cG3mUQTbnIluP/xWaSu1SvO9Pd+csHazGOw84/V9yhVFVWFRIBHuIvvbD9JCu
         dmVxRFokgfSxHvJdseYcV19Ct5zqZPb3MNjOdIKO88QbEsiqHOwc8E60K5M4DqQw0bqT
         lCbVRZLwNsCfAxRohM3MMTqRy1P/2+6PVaNpKzxIi9eYCj6KXGjmZwws8h9S32kSlAeJ
         3xgzyfQu3td/7pmTkXOxRxjMWKW2ij4ObEr/EvINQb7RDeJM0de1QaaH6KB6JkqD/rGL
         ARn3X0FwfOzqAGgmZ5O/hcypygwN2TP9RGdjWNrhv58gt/VA/fXDUeWbI6n2dFQLOkW+
         V6MQ==
X-Gm-Message-State: AOAM531PnnW0pI9I32uKOkhVAqtL6Oyz9tmdphf8+lS2npTJjwqE61Df
        CTFWAIA5G8oFHQPU4kcJnKSTzN23vhpUDg==
X-Google-Smtp-Source: ABdhPJyStAHNlCGq4n8s1sQgLmqwVy90Br09ngKCFNnPFuxsNSaN9cVfELKKJ0YCy87Xl1vusIPVaw==
X-Received: by 2002:a17:902:e8cb:b0:13b:6504:7d20 with SMTP id v11-20020a170902e8cb00b0013b65047d20mr12599028plg.31.1634323732539;
        Fri, 15 Oct 2021 11:48:52 -0700 (PDT)
Received: from localhost.localdomain ([50.39.163.188])
        by smtp.gmail.com with ESMTPSA id bp19sm5431357pjb.46.2021.10.15.11.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 11:48:52 -0700 (PDT)
From:   James Prestwood <prestwoj@gmail.com>
To:     netdev@vger.kernel.org
Cc:     James Prestwood <prestwoj@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Chinmay Agarwal <chinagar@codeaurora.org>,
        Yajun Deng <yajun.deng@linux.dev>,
        Tong Zhu <zhutong@amazon.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCH v2] net: neighbour: introduce EVICT_NOCARRIER table option
Date:   Fri, 15 Oct 2021 11:43:21 -0700
Message-Id: <20211015184321.245408-2-prestwoj@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211015184321.245408-1-prestwoj@gmail.com>
References: <20211015184321.245408-1-prestwoj@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds an option to ARP/NDISC tables that clears the table on
NOCARRIER events. The default option (1) maintains existing
behavior.

Clearing the ARP cache on NOCARRIER is relatively new, introduced by:

commit 859bd2ef1fc1110a8031b967ee656c53a6260a76
Author: David Ahern <dsahern@gmail.com>
Date:   Thu Oct 11 20:33:49 2018 -0700

    net: Evict neighbor entries on carrier down

The reason for this cahange is to allow userspace to control when
the ARP/NDISC cache is cleared. In most cases the cache should be
cleared on NOCARRIER, but in the context of a wireless roams the
cache should not be cleared since the underlying network has not
changed. Clearing the cache on a wireless roam can introduce delays
in sending out packets (waiting for ARP/neighbor discovery) and
this has been reported by a user here:

https://lore.kernel.org/linux-wireless/CACsRnHWa47zpx3D1oDq9JYnZWniS8yBwW1h0WAVZ6vrbwL_S0w@mail.gmail.com/

After some investigation it was found that the kernel was holding onto
ackets until ARP finished which resulted in this 1 second delay. It
was also found that the first ARP who-has was never responded to,
which is actually what caues the delay. This change is more or less
working around this behavior, but again, there is no reason to clear
the cache on a roam anyways.

As for the unanswered who-has, we know the packet made it OTA since
it was seen while monitoring. Why it never received a response is
unknown. In any case, since this is a problem on the AP side of things
all that can be done is to work around it until it is solved.

Some background on testing/reproducing the packet delay:

Hardware:
 - 2 access points configured for Fast BSS Transititon (Though I don't
   see why regular reassociation wouldn't have the same behavior)
 - Wireless station running IWD as supplicant
 - A device on network able to respond to pings (I used one of the APs)

Procedure:
 - Connect to first AP
 - Ping once to establish an ARP entry
 - Start a tcpdump
 - Roam to second AP
 - Wait for operstate UP event, and note the timestamp
 - Start pinging

Results:

Below is the tcpdump after UP. It was recorded the interface went UP at
10:42:01.432875.

10:42:01.461871 ARP, Request who-has 192.168.254.1 tell 192.168.254.71, length 28
10:42:02.497976 ARP, Request who-has 192.168.254.1 tell 192.168.254.71, length 28
10:42:02.507162 ARP, Reply 192.168.254.1 is-at ac:86:74:55:b0:20, length 46
10:42:02.507185 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 1, length 64
10:42:02.507205 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 2, length 64
10:42:02.507212 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 3, length 64
10:42:02.507219 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 4, length 64
10:42:02.507225 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 5, length 64
10:42:02.507232 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 6, length 64
10:42:02.515373 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 1, length 64
10:42:02.521399 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 2, length 64
10:42:02.521612 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 3, length 64
10:42:02.521941 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 4, length 64
10:42:02.522419 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 5, length 64
10:42:02.523085 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 6, length 64

You can see the first ARP who-has went out very quickly after UP, but
was never responded to. Nearly a second later the kernel retries and
gets a response. Only then do the ping packets go out. If an ARP entry
is manually added prior to UP (after the cache is cleared) it is seen
that the first ping is never responded to, so its not only an issue with
ARP but with data packets in general.

As mentioned prior, the wireless interface was also monitored to verify
the ping/ARP packet made it OTA which was observed to be true.

Signed-off-by: James Prestwood <prestwoj@gmail.com>
---
 Documentation/networking/ip-sysctl.rst |  9 +++++++++
 include/net/neighbour.h                |  3 ++-
 include/uapi/linux/neighbour.h         |  1 +
 net/core/neighbour.c                   | 12 ++++++++++--
 net/ipv4/arp.c                         |  1 +
 net/ipv6/ndisc.c                       |  1 +
 6 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 16b8bf72feaf..e2aced01905a 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -200,6 +200,15 @@ neigh/default/unres_qlen - INTEGER
 
 	Default: 101
 
+neigh/default/evict_nocarrier - BOOLEAN
+	Clears the neighbor cache on NOCARRIER events. This option is important
+	for wireless devices where the cache should not be cleared when roaming
+	between access points on the same network. In most cases this should
+	remain as the default (1).
+
+	- 1 - (default): Clear the neighbor cache on NOCARRIER events
+	- 0 - Do not clear neighbor cache on NOCARRIER events
+
 mtu_expires - INTEGER
 	Time, in seconds, that cached PMTU information is kept.
 
diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index e8e48be66755..71b28f83c3d3 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -54,7 +54,8 @@ enum {
 	NEIGH_VAR_ANYCAST_DELAY,
 	NEIGH_VAR_PROXY_DELAY,
 	NEIGH_VAR_LOCKTIME,
-#define NEIGH_VAR_DATA_MAX (NEIGH_VAR_LOCKTIME + 1)
+	NEIGH_VAR_EVICT_NOCARRIER,
+#define NEIGH_VAR_DATA_MAX (NEIGH_VAR_EVICT_NOCARRIER + 1)
 	/* Following are used as a second way to access one of the above */
 	NEIGH_VAR_QUEUE_LEN, /* same data as NEIGH_VAR_QUEUE_LEN_BYTES */
 	NEIGH_VAR_RETRANS_TIME_MS, /* same data as NEIGH_VAR_RETRANS_TIME */
diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index db05fb55055e..4322e5f42646 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -151,6 +151,7 @@ enum {
 	NDTPA_LOCKTIME,			/* u64, msecs */
 	NDTPA_QUEUE_LENBYTES,		/* u32 */
 	NDTPA_MCAST_REPROBES,		/* u32 */
+	NDTPA_EVICT_NOCARRIER,		/* u8 */
 	NDTPA_PAD,
 	__NDTPA_MAX
 };
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 47931c8be04b..20c0acc0e14d 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -336,7 +336,8 @@ static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev,
 				np = &n->next;
 				continue;
 			}
-			if (skip_perm && n->nud_state & NUD_PERMANENT) {
+			if ((skip_perm && n->nud_state & NUD_PERMANENT) ||
+			    !NEIGH_VAR(n->parms, EVICT_NOCARRIER)) {
 				np = &n->next;
 				continue;
 			}
@@ -2094,7 +2095,9 @@ static int neightbl_fill_parms(struct sk_buff *skb, struct neigh_parms *parms)
 	    nla_put_msecs(skb, NDTPA_PROXY_DELAY,
 			  NEIGH_VAR(parms, PROXY_DELAY), NDTPA_PAD) ||
 	    nla_put_msecs(skb, NDTPA_LOCKTIME,
-			  NEIGH_VAR(parms, LOCKTIME), NDTPA_PAD))
+			  NEIGH_VAR(parms, LOCKTIME), NDTPA_PAD) ||
+	    nla_put_u8(skb, NDTPA_EVICT_NOCARRIER,
+			  NEIGH_VAR(parms, EVICT_NOCARRIER)))
 		goto nla_put_failure;
 	return nla_nest_end(skb, nest);
 
@@ -2249,6 +2252,7 @@ static const struct nla_policy nl_ntbl_parm_policy[NDTPA_MAX+1] = {
 	[NDTPA_ANYCAST_DELAY]		= { .type = NLA_U64 },
 	[NDTPA_PROXY_DELAY]		= { .type = NLA_U64 },
 	[NDTPA_LOCKTIME]		= { .type = NLA_U64 },
+	[NDTPA_EVICT_NOCARRIER]		= { .type = NLA_U8 },
 };
 
 static int neightbl_set(struct sk_buff *skb, struct nlmsghdr *nlh,
@@ -2383,6 +2387,9 @@ static int neightbl_set(struct sk_buff *skb, struct nlmsghdr *nlh,
 				NEIGH_VAR_SET(p, LOCKTIME,
 					      nla_get_msecs(tbp[i]));
 				break;
+			case NDTPA_EVICT_NOCARRIER:
+				NEIGH_VAR_SET(p, EVICT_NOCARRIER,
+					      nla_get_u8(tbp[i]));
 			}
 		}
 	}
@@ -3679,6 +3686,7 @@ static struct neigh_sysctl_table {
 		NEIGH_SYSCTL_UNRES_QLEN_REUSED_ENTRY(QUEUE_LEN, QUEUE_LEN_BYTES, "unres_qlen"),
 		NEIGH_SYSCTL_MS_JIFFIES_REUSED_ENTRY(RETRANS_TIME_MS, RETRANS_TIME, "retrans_time_ms"),
 		NEIGH_SYSCTL_MS_JIFFIES_REUSED_ENTRY(BASE_REACHABLE_TIME_MS, BASE_REACHABLE_TIME, "base_reachable_time_ms"),
+		NEIGH_SYSCTL_ZERO_INTMAX_ENTRY(EVICT_NOCARRIER, "evict_nocarrier"),
 		[NEIGH_VAR_GC_INTERVAL] = {
 			.procname	= "gc_interval",
 			.maxlen		= sizeof(int),
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 922dd73e5740..10b97bedc19b 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -174,6 +174,7 @@ struct neigh_table arp_tbl = {
 			[NEIGH_VAR_ANYCAST_DELAY] = 1 * HZ,
 			[NEIGH_VAR_PROXY_DELAY]	= (8 * HZ) / 10,
 			[NEIGH_VAR_LOCKTIME] = 1 * HZ,
+			[NEIGH_VAR_EVICT_NOCARRIER] = 1,
 		},
 	},
 	.gc_interval	= 30 * HZ,
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 184190b9ea25..64be42e5b906 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -133,6 +133,7 @@ struct neigh_table nd_tbl = {
 			[NEIGH_VAR_PROXY_QLEN] = 64,
 			[NEIGH_VAR_ANYCAST_DELAY] = 1 * HZ,
 			[NEIGH_VAR_PROXY_DELAY] = (8 * HZ) / 10,
+			[NEIGH_VAR_EVICT_NOCARRIER] = 1,
 		},
 	},
 	.gc_interval =	  30 * HZ,
-- 
2.31.1

