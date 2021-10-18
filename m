Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DAF4327BD
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 21:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbhJRTep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 15:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233510AbhJRTen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 15:34:43 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CE2C06161C
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 12:32:32 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id f11so11649976pfc.12
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 12:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JtuscppzRnbdyMsl52hYNW52npMJ8zYTPqAwzKGp/I0=;
        b=XQWuVvpKbuI4FhPAoK0NvUvGNmqKRbtTJT/VOyLjQ08xfo1Vlgo5ZmyN+QL9Ej+Mzt
         gHvUVDe5/BjZ+sI7/9f48rkcYcdVXBe23Blsag3r++YiGR6vdiNlkZ69wf8Ha0iHNWAM
         6OB6iNtxBSz5N2m/eQ4zoBvCHNCPdLL+VWIImggZCEdw58xEJbAfp0j2HjxsAS2T1OWE
         pwScqgFv5trOshH7xeBDy4rJW77REBH1g7TT7UalSsxK9CdEK0/hEpW5eL72ksWBSUZ2
         O54Trn7e8NrRKBMhAPPWT+ah6IsJQ7Ah2+ItFMENlzZeqxhvgsyE5rMudFaCPKVJxK9X
         91Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JtuscppzRnbdyMsl52hYNW52npMJ8zYTPqAwzKGp/I0=;
        b=vwgs12Labj194WoOW/IqN/se1BXvXODBJWCnHbXt6aBgQvC1KHoyuUsmsJ8ebjpCOi
         fInqfHyRzz6TrOj7LE16SJlNY3owhDxXcTCm3B7GSp+kiqkplIoNybIXIf3MYuJ1Q7u4
         tU7iy9WMYAyTYjGq+mXtORSpK+Qsnqjhx6EejSCSts7a2cr/zyDGYV5V5sPVRwLBFmz6
         /BAGBYR1WqdQ5v6Cu+y/4jzJdJtI5RMo9/urUO/MjljSlTNJfXgFm9Rc2CUat/hzjGxN
         w085fLAj7oncesjS9/Q4D8GuS3aSH7ZdFNNhiTRAjT1X4I5ziDg9zoyWpHEYRyvxcXi/
         lDcQ==
X-Gm-Message-State: AOAM533RFh8h7EdSICAK8Zx0UQ52W9YNTthUvvEBYexeran3me2FJ6uh
        NSxwD9GXGtg1mTKTrpTUWiXotCj5wE231Q==
X-Google-Smtp-Source: ABdhPJyq4Y980jJNesWfVP61zV92DLLMGmvNrrkwOrMU4vOJ1ZC68tM4DOUemcAMMDCxkAdnJTv+nA==
X-Received: by 2002:a05:6a00:ac1:b0:44c:4dc6:b897 with SMTP id c1-20020a056a000ac100b0044c4dc6b897mr31134666pfl.25.1634585551436;
        Mon, 18 Oct 2021 12:32:31 -0700 (PDT)
Received: from localhost.localdomain ([50.39.163.188])
        by smtp.gmail.com with ESMTPSA id v7sm212646pjk.37.2021.10.18.12.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 12:32:31 -0700 (PDT)
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
        Yajun Deng <yajun.deng@linux.dev>,
        Tong Zhu <zhutong@amazon.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jouni Malinen <jouni@codeaurora.org>
Subject: [PATCH v4] net: neighbour: introduce EVICT_NOCARRIER table option
Date:   Mon, 18 Oct 2021 12:26:57 -0700
Message-Id: <20211018192657.481274-1-prestwoj@gmail.com>
X-Mailer: git-send-email 2.31.1
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

The reason for this change is to allow userspace to control when
the ARP/NDISC cache is cleared. In most cases the cache should be
cleared on NOCARRIER, but in the context of a wireless roams the
cache should not be cleared since the underlying network has not
changed. Clearing the cache on a wireless roam can introduce delays
in sending out packets (waiting for ARP/neighbor discovery) and
this has been reported by a user here:

https://lore.kernel.org/linux-wireless/CACsRnHWa47zpx3D1oDq9JYnZWniS8yBwW1h0WAVZ6vrbwL_S0w@mail.gmail.com/

After some investigation it was found that the kernel was holding onto
packets until ARP finished which resulted in this 1 second delay. It
was also found that the first ARP who-has was never responded to,
which is actually what causes the delay. This change is more or less
working around this behavior, but again, there is no reason to clear
the cache on a roam anyways.

As for the unanswered who-has, we know the packet made it OTA since
it was seen while monitoring. Why it never received a response is
unknown. In any case, since this is a problem on the AP side of things
all that can be done is to work around it until it is solved.

Some background on testing/reproducing the packet delay:

Hardware:
 - 2 access points configured for Fast BSS Transition (Though I don't
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
 net/core/neighbour.c                   | 18 +++++++++++++-----
 net/ipv4/arp.c                         |  1 +
 net/ipv6/ndisc.c                       |  1 +
 6 files changed, 27 insertions(+), 6 deletions(-)

v1 -> v2:

 - It was suggested by Daniel Borkmann to extend the neighbor table settings
   rather than adding IPv4/IPv6 options for ARP/NDISC separately. I agree
   this way is much more concise since there is now only one place where the
   option is checked and defined.
 - Moved documentation/code into the same patch
 - Explained in more detail the test scenario and results

v2 -> v3:

 - Renamed 'skip_perm' to 'nocarrier'. The way this parameter is used
   matches this naming.
 - Changed logic to still flush if 'nocarrier' is false.

v3 -> v4:

 - Moved NDTPA_EVICT_NOCARRIER after NDTPA_PAD

James Prestwood (1):
  net: neighbour: introduce EVICT_NOCARRIER table option

 Documentation/networking/ip-sysctl.rst |  9 +++++++++
 include/net/neighbour.h                |  5 +++--
 include/uapi/linux/neighbour.h         |  1 +
 net/core/neighbour.c                   | 12 ++++++++++--
 net/ipv4/arp.c                         |  1 +
 net/ipv6/ndisc.c                       |  1 +
 6 files changed, 25 insertions(+), 4 deletions(-)

Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Roopa Prabhu <roopa@nvidia.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: Ido Schimmel <idosch@nvidia.com>
Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
Cc: Yajun Deng <yajun.deng@linux.dev>
Cc: Tong Zhu <zhutong@amazon.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jouni@codeaurora.org>

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
index db05fb55055e..1dc125dd4f50 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -152,6 +152,7 @@ enum {
 	NDTPA_QUEUE_LENBYTES,		/* u32 */
 	NDTPA_MCAST_REPROBES,		/* u32 */
 	NDTPA_PAD,
+	NDTPA_EVICT_NOCARRIER,		/* u8 */
 	__NDTPA_MAX
 };
 #define NDTPA_MAX (__NDTPA_MAX - 1)
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 47931c8be04b..953253f3e491 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -318,7 +318,7 @@ static void pneigh_queue_purge(struct sk_buff_head *list)
 }
 
 static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev,
-			    bool skip_perm)
+			    bool nocarrier)
 {
 	int i;
 	struct neigh_hash_table *nht;
@@ -336,7 +336,8 @@ static void neigh_flush_dev(struct neigh_table *tbl, struct net_device *dev,
 				np = &n->next;
 				continue;
 			}
-			if (skip_perm && n->nud_state & NUD_PERMANENT) {
+			if (nocarrier && ((n->nud_state & NUD_PERMANENT) ||
+			    !NEIGH_VAR(n->parms, EVICT_NOCARRIER))) {
 				np = &n->next;
 				continue;
 			}
@@ -380,10 +381,10 @@ void neigh_changeaddr(struct neigh_table *tbl, struct net_device *dev)
 EXPORT_SYMBOL(neigh_changeaddr);
 
 static int __neigh_ifdown(struct neigh_table *tbl, struct net_device *dev,
-			  bool skip_perm)
+			  bool nocarrier)
 {
 	write_lock_bh(&tbl->lock);
-	neigh_flush_dev(tbl, dev, skip_perm);
+	neigh_flush_dev(tbl, dev, nocarrier);
 	pneigh_ifdown_and_unlock(tbl, dev);
 
 	del_timer_sync(&tbl->proxy_timer);
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

