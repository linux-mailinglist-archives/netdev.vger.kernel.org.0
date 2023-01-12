Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF2066685B
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 02:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbjALB0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 20:26:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbjALB0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 20:26:13 -0500
Received: from rpt-cro-asav1.external.tpg.com.au (rpt-cro-asav1.external.tpg.com.au [60.241.0.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D08E26406;
        Wed, 11 Jan 2023 17:26:09 -0800 (PST)
X-IPAS-Result: =?us-ascii?q?A2FDBAD5YL9j//EjqMpagRKBRoUMlW6DFogNMAKTaA8BA?=
 =?us-ascii?q?wEBAQEBTQQBAT4BhEaFGSY3Bg4BAQEEAQEBAQECBQEBAQEBAQMBAQEFAQIBA?=
 =?us-ascii?q?QEEBQEBAQKBGYUvRoI4KQGEASsLASkdJlwCTYJ+gm4BAzGvJhYFAhaBAZ4YC?=
 =?us-ascii?q?hkoDWgDgWSBQYRSUIIThChXhzyBFYE8giyCIIhiBIEIjBCMMQEDAgIDAgIDB?=
 =?us-ascii?q?gMBAgICBQMDAgEDBAIOBA4DAQECAgEBAgQIAgIDAwICCA8VAwcCAQYFAQMBA?=
 =?us-ascii?q?gYEAgQBCwICBQIBCgECBAECAgIBBQkBAgMBAwELAgIGAgIDBQYEAgMEBgICB?=
 =?us-ascii?q?QIBAQMCAgINAwIDAgQBBQUBAQIQAgYECQEGAwsCBQEEAwECBQcBAwcDAgICA?=
 =?us-ascii?q?ggEEgIDAgIEBQICAgECBAUCBwIGAgECAgIEAgEDAgQCAgQCAgQDEQoCAwUDD?=
 =?us-ascii?q?gICAgICAQkLAgICAgIHBAIDAwEHAgICAQwBAx0DAgICAgICAgIBAwkJBAUKG?=
 =?us-ascii?q?QMDAiADCQMHBUkCCQMjDwMLCQgHDAEWKAYDAQoHDCUEBAwoAQoMBwUBAgIBB?=
 =?us-ascii?q?wMDBQUCBw8DBAIBAwMCBQ8DAQYFAQIBAgICBAIIAgQFAgUDAgQCAwICCAMCA?=
 =?us-ascii?q?wECAQcEAwQBBAIEAw0EAwQCAwICBQICAgICBQICAwECAgICAgIFAgMCAQUBA?=
 =?us-ascii?q?gIBAgICBAECAgcEAgMBAwQOBAMCAgcBAgIBBgIHAwECAQQDAQEEAgQBAgUCB?=
 =?us-ascii?q?AEDBgIDAQMKAgMCAQECAwMFAwICCAgCAwUCBAEBAgQDBAICCwEGAgcCAgMCA?=
 =?us-ascii?q?gQEBAEBAgEEBQIDAQIDAwkCAgMCBAICCgEBAQECAQcCBAUGAgUCAgIDAQICA?=
 =?us-ascii?q?QMCAQICChEBAQIDAwMEBgUDAwMCARUFAgEBAgIDAwIGAgECCAIEAQQFAgECA?=
 =?us-ascii?q?QECAgQBCAICAQEBAgECAgMDAgECAgIEAwMBAgECAgMCAgIDAgIBDQIGBgECA?=
 =?us-ascii?q?gICAgICAgIGAQIBAgMBAgcCBAMCAQICBQICAgMBAQYCBAsBAwICAgIBCAEBA?=
 =?us-ascii?q?gUBAgICAwEBAwMEAwMFBgMCDAgBBQEDAR8DAgIIAgcCAQYDAgEPAwICAwICA?=
 =?us-ascii?q?QQKAgMFAgQCAQQIBwIEAQIJAwIGAgYFGAECAgcEDAoBAgIFBgQBAQIDAQIBA?=
 =?us-ascii?q?QIDAwIDAgQFAQUCAQIEAgICAQECBQ0BAQMEAgQCBwICAgMBBAIBAgEDAwIDA?=
 =?us-ascii?q?QEBAwYGAgQEAgMDBwICAwECAgMEDQEEAgIGAwQBDQUGBQQDAggBAgEBBwIEA?=
 =?us-ascii?q?gcJDgIBAgQBBQICAwICAQMCAgECBAMBAgICAgUHBQMEAQQDCgkDAQEEAwIBA?=
 =?us-ascii?q?gECAwIDBwMCBAIDAQIDBAYGAQkEBgQBDQMEAgIBAgEBAwQEBAICAQICAwEEA?=
 =?us-ascii?q?gIBAQMDAwICAgMEAgMDCwQKBwMDAgEFCwICAgMCAQEDBwQFBAICBgECBAICA?=
 =?us-ascii?q?gICAgIDAQEDCgQCAQMCAgQDBgIBAgEJBQIBCQMBAgEDBAEDCQECAgQJAgMHB?=
 =?us-ascii?q?QoCAgICCAICDgMDAgEBBAICBAMCCQECBwIFAQEDBQcCAgECAgEEAwEJBAECA?=
 =?us-ascii?q?wIBAQMSAwMBBAICBQMDDQkGAgIBAwIBDQMBAgECAwEEAQUXAwgHFAMFAgIEB?=
 =?us-ascii?q?AEIAgIDAwMCAQIJBgEDAQUCDgMCAgMDBgECAQECAxACAwEBAQEXAQMEAgMBB?=
 =?us-ascii?q?AMBAQIBAgMCDgQBBAUMAwECEQwCBAEGAggCAgICAwEDAwUBAgMEAgEIBgQCA?=
 =?us-ascii?q?gICAQkCCgMCAwECAQUBAwIJAwEFAQIHAgQCAQEBAgIIAggCAwsBAwIDBgIBA?=
 =?us-ascii?q?gIBBQIBAgIFAwUCAgICBA0CBQICAgYBAgcEAgICAwECAgYCBQECBwcCBQICA?=
 =?us-ascii?q?gMDCgQEAgoEAQMBAQUBAgEDBAECBAECAQIFAwYCAgICAQICAQIBAQgCAgICA?=
 =?us-ascii?q?gICAwQCBQOeCwF6FBM4QHEsNoEaAQGUcKwuRCEJAQYCW4FXfBopml2FbRoyq?=
 =?us-ascii?q?SctlxuRNZEMhXyBQ4IATSOBAW2BSVIZD44sFo5CYTsCBwsBAQMJjCMBAQ?=
IronPort-PHdr: A9a23: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
IronPort-Data: A9a23:kQkwBaMyvueLRsfvrR3Kl8FynXyQoLVcMsEvi/4bfWQNrUp202FWy
 mseXWDUP6nfY2unLdgjOoi2oB8DsJeDnYRhGgZtpSBmQlt08seUXt7xwmUcns+xwm8vaGo9s
 q3yv/GZdJhcokf0/0vraP64xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2LBVOCvQ/
 4KsyyHjEAX9gWUsaztNs/nrRC5H5ZwehhtI5jTSWtgW5Dcyp1FNZLoDKKe4KWfPQ4U8NoZWk
 M6akdlVVkuAl/scIovNfoTTKyXmcZaLVeS6sUe6boD56vR0So7e5Y5gXBYUQR8/Zzyhw4srk
 I0V3XC6YV9B0qbkwIzxX/TEes3X0GIvFLLveBCCXcKvI0LucWbvnexyHUQPLIQkyNRKOXps7
 MQmAWVYBvyDr7reLLOTSOxlltsuKM2tN4Qa0p1i5WuBV7B/H8CFGPiMv4MBtNszrpkm8fL2Z
 c8QeSViaBCbPDVAP14WDNQ1m+LAanzXKWMC8wjM+fZoi4TV5DJd6IXBD+HSQfqpRtlwnlqEi
 2Kc212sV3n2M/Tak1Jp6EmEiubRkCbTVIsMGbi88fB2xlue2gQ7BRELUFKprOWRhUm5VNZSb
 UcT/0IGrrU4/WSoQ8P7Uhn+p2SL1jYEUtBdFewS8gyByqPIpQ2eAwAsXzlaaNI7ts4eQT0sy
 0/Mnsv3W3poqrL9YX6G/7eZtzWaOiUPK2IGIygeQmMt5tD5vIA1yBbGU/5gHbSzg9mzHiv/q
 xiIqyU6r7cUgMoF2r+99FbLjinqoYLGJiYt7xjTW2mmxgB0foioY8qv81ezxftRJYLfRFibs
 3Ues8eb5eEKS5qKkUSlRugRELy3z+iKPSeaglN1GZQlsTO39BaLeYFW/SE7J0pzNMsAUSHmb
 VWVug5L4pJXenywYsdfYYe4G9snyay7SvzqU/nVapxFZZ0ZXAaB8DtjbAiV1nHgimAxl6AlP
 pKSK4CtER4n5b9PlmLsAr5Dgfpwm2VkmTqVWYj0zlKs1r/YbWP9pao5DWZip9sRtMusyDg5O
 f4Fb6NmFz03vCbCjuU7PGLdwZ3m7ZT2OHwul/FqSw==
IronPort-HdrOrdr: A9a23:4OnqOaw1xYitDvxZzI4WKrPwNb1zdoMgy1knxilNoNJuH/Bw8P
 re/8jzuiWatN98YhodcLO7WJVoP0mzyXcd2+B4AV7IZmXbUQWTRr2KlbGC/wHd
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.96,318,1665406800"; 
   d="scan'208";a="262321447"
Received: from 202-168-35-241.tpgi.com.au (HELO jmaxwell.com) ([202.168.35.241])
  by rpt-cro-asav1.external.tpg.com.au with ESMTP; 12 Jan 2023 12:26:02 +1100
From:   Jon Maxwell <jmaxwell37@gmail.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, martin.lau@kernel.org,
        joel@joelfernandes.org, paulmck@kernel.org, eyal.birger@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jon Maxwell <jmaxwell37@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next v2] ipv6: remove max_size check inline with ipv4
Date:   Thu, 12 Jan 2023 12:25:32 +1100
Message-Id: <20230112012532.311021-1-jmaxwell37@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NML_ADSP_CUSTOM_MED,SPF_HELO_NONE,SPF_SOFTFAIL,SPOOFED_FREEMAIL,
        SPOOF_GMAIL_MID autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2: Correct syntax error in net/ipv6/route.c

In ip6_dst_gc() replace: 

if (entries > gc_thresh)

With:

if (entries > ops->gc_thresh)

Sending Ipv6 packets in a loop via a raw socket triggers an issue where a 
route is cloned by ip6_rt_cache_alloc() for each packet sent. This quickly 
consumes the Ipv6 max_size threshold which defaults to 4096 resulting in 
these warnings:

[1]   99.187805] dst_alloc: 7728 callbacks suppressed
[2] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.
.
.
[300] Route cache is full: consider increasing sysctl net.ipv6.route.max_size.

When this happens the packet is dropped and sendto() gets a network is 
unreachable error:

# ./a.out -s 

remaining pkt 200557 errno 101
remaining pkt 196462 errno 101
.
.
remaining pkt 126821 errno 101

Implement David Aherns suggestion to remove max_size check seeing that Ipv6 
has a GC to manage memory usage. Ipv4 already does not check max_size.

Here are some memory comparisons for Ipv4 vs Ipv6 with the patch:

Test by running 5 instances of a program that sends UDP packets to a raw 
socket 5000000 times. Compare Ipv4 and Ipv6 performance with a similar 
program.

Ipv4: 

Before test:

# grep -e Slab -e Free /proc/meminfo
MemFree:        29427108 kB
Slab:             237612 kB

# grep dst_cache /proc/slabinfo
ip6_dst_cache       1912   2528    256   32    2 : tunables    0    0    0 
xfrm_dst_cache         0      0    320   25    2 : tunables    0    0    0 
ip_dst_cache        2881   3990    192   42    2 : tunables    0    0    0 

During test:

# grep -e Slab -e Free /proc/meminfo
MemFree:        29417608 kB
Slab:             247712 kB

# grep dst_cache /proc/slabinfo
ip6_dst_cache       1912   2528    256   32    2 : tunables    0    0    0 
xfrm_dst_cache         0      0    320   25    2 : tunables    0    0    0 
ip_dst_cache       44394  44394    192   42    2 : tunables    0    0    0 

After test:

# grep -e Slab -e Free /proc/meminfo
MemFree:        29422308 kB
Slab:             238104 kB

# grep dst_cache /proc/slabinfo
ip6_dst_cache       1912   2528    256   32    2 : tunables    0    0    0 
xfrm_dst_cache         0      0    320   25    2 : tunables    0    0    0 
ip_dst_cache        3048   4116    192   42    2 : tunables    0    0    0 

Ipv6 with patch:

Errno 101 errors are not observed anymore with the patch.

Before test:

# grep -e Slab -e Free /proc/meminfo
MemFree:        29422308 kB
Slab:             238104 kB

# grep dst_cache /proc/slabinfo
ip6_dst_cache       1912   2528    256   32    2 : tunables    0    0    0 
xfrm_dst_cache         0      0    320   25    2 : tunables    0    0    0 
ip_dst_cache        3048   4116    192   42    2 : tunables    0    0    0 

During Test:

# grep -e Slab -e Free /proc/meminfo
MemFree:        29431516 kB
Slab:             240940 kB

# grep dst_cache /proc/slabinfo
ip6_dst_cache      11980  12064    256   32    2 : tunables    0    0    0
xfrm_dst_cache         0      0    320   25    2 : tunables    0    0    0
ip_dst_cache        3048   4116    192   42    2 : tunables    0    0    0

After Test:

# grep -e Slab -e Free /proc/meminfo
MemFree:        29441816 kB
Slab:             238132 kB

# grep dst_cache /proc/slabinfo
ip6_dst_cache       1902   2432    256   32    2 : tunables    0    0    0
xfrm_dst_cache         0      0    320   25    2 : tunables    0    0    0
ip_dst_cache        3048   4116    192   42    2 : tunables    0    0    0

Tested-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
---
 include/net/dst_ops.h |  2 +-
 net/core/dst.c        |  8 ++------
 net/ipv6/route.c      | 13 +++++--------
 3 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/include/net/dst_ops.h b/include/net/dst_ops.h
index 88ff7bb2bb9b..632086b2f644 100644
--- a/include/net/dst_ops.h
+++ b/include/net/dst_ops.h
@@ -16,7 +16,7 @@ struct dst_ops {
 	unsigned short		family;
 	unsigned int		gc_thresh;
 
-	int			(*gc)(struct dst_ops *ops);
+	void			(*gc)(struct dst_ops *ops);
 	struct dst_entry *	(*check)(struct dst_entry *, __u32 cookie);
 	unsigned int		(*default_advmss)(const struct dst_entry *);
 	unsigned int		(*mtu)(const struct dst_entry *);
diff --git a/net/core/dst.c b/net/core/dst.c
index 6d2dd03dafa8..31c08a3386d3 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -82,12 +82,8 @@ void *dst_alloc(struct dst_ops *ops, struct net_device *dev,
 
 	if (ops->gc &&
 	    !(flags & DST_NOCOUNT) &&
-	    dst_entries_get_fast(ops) > ops->gc_thresh) {
-		if (ops->gc(ops)) {
-			pr_notice_ratelimited("Route cache is full: consider increasing sysctl net.ipv6.route.max_size.\n");
-			return NULL;
-		}
-	}
+	    dst_entries_get_fast(ops) > ops->gc_thresh)
+		ops->gc(ops);
 
 	dst = kmem_cache_alloc(ops->kmem_cachep, GFP_ATOMIC);
 	if (!dst)
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e74e0361fd92..b643dda68d31 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -91,7 +91,7 @@ static struct dst_entry *ip6_negative_advice(struct dst_entry *);
 static void		ip6_dst_destroy(struct dst_entry *);
 static void		ip6_dst_ifdown(struct dst_entry *,
 				       struct net_device *dev, int how);
-static int		 ip6_dst_gc(struct dst_ops *ops);
+static void		 ip6_dst_gc(struct dst_ops *ops);
 
 static int		ip6_pkt_discard(struct sk_buff *skb);
 static int		ip6_pkt_discard_out(struct net *net, struct sock *sk, struct sk_buff *skb);
@@ -3284,11 +3284,10 @@ struct dst_entry *icmp6_dst_alloc(struct net_device *dev,
 	return dst;
 }
 
-static int ip6_dst_gc(struct dst_ops *ops)
+static void ip6_dst_gc(struct dst_ops *ops)
 {
 	struct net *net = container_of(ops, struct net, ipv6.ip6_dst_ops);
 	int rt_min_interval = net->ipv6.sysctl.ip6_rt_gc_min_interval;
-	int rt_max_size = net->ipv6.sysctl.ip6_rt_max_size;
 	int rt_elasticity = net->ipv6.sysctl.ip6_rt_gc_elasticity;
 	int rt_gc_timeout = net->ipv6.sysctl.ip6_rt_gc_timeout;
 	unsigned long rt_last_gc = net->ipv6.ip6_rt_last_gc;
@@ -3296,11 +3295,10 @@ static int ip6_dst_gc(struct dst_ops *ops)
 	int entries;
 
 	entries = dst_entries_get_fast(ops);
-	if (entries > rt_max_size)
+	if (entries > ops->gc_thresh)
 		entries = dst_entries_get_slow(ops);
 
-	if (time_after(rt_last_gc + rt_min_interval, jiffies) &&
-	    entries <= rt_max_size)
+	if (time_after(rt_last_gc + rt_min_interval, jiffies))
 		goto out;
 
 	fib6_run_gc(atomic_inc_return(&net->ipv6.ip6_rt_gc_expire), net, true);
@@ -3310,7 +3308,6 @@ static int ip6_dst_gc(struct dst_ops *ops)
 out:
 	val = atomic_read(&net->ipv6.ip6_rt_gc_expire);
 	atomic_set(&net->ipv6.ip6_rt_gc_expire, val - (val >> rt_elasticity));
-	return entries > rt_max_size;
 }
 
 static int ip6_nh_lookup_table(struct net *net, struct fib6_config *cfg,
@@ -6512,7 +6509,7 @@ static int __net_init ip6_route_net_init(struct net *net)
 #endif
 
 	net->ipv6.sysctl.flush_delay = 0;
-	net->ipv6.sysctl.ip6_rt_max_size = 4096;
+	net->ipv6.sysctl.ip6_rt_max_size = INT_MAX;
 	net->ipv6.sysctl.ip6_rt_gc_min_interval = HZ / 2;
 	net->ipv6.sysctl.ip6_rt_gc_timeout = 60*HZ;
 	net->ipv6.sysctl.ip6_rt_gc_interval = 30*HZ;
-- 
2.31.1

