Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31646665A5
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 22:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbjAKVeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 16:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235500AbjAKVeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 16:34:02 -0500
Received: from rpt-cro-asav5.external.tpg.com.au (rpt-cro-asav5.external.tpg.com.au [60.241.0.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4685D13B;
        Wed, 11 Jan 2023 13:33:58 -0800 (PST)
X-Ironport-Abuse: host=202-168-35-241.tpgi.com.au, ip=202.168.35.241, date=01/12/23 08:33:56
X-SMTP-MATCH: 0
X-IPAS-Result: =?us-ascii?q?A2HJAwBbKr9j//EjqMpagRKBRoUMlW6DFogNMAKTaA8BA?=
 =?us-ascii?q?wEBAQEBTQQBAT4BhEaFGSY3Bg4BAQEEAQEBAQECBQEBAQEBAQMBAQEFAQIBA?=
 =?us-ascii?q?QEEBQEBAQKBGYUvRoI4KQGEASsLASkdJlwCTYJ+gm4BAzGvfxYFAhaBAZ4YC?=
 =?us-ascii?q?hkoDWgDgWSBQYRSUIIThChXhzyBFYE8giyCIIhiBIEIjAiMMQEDAgIDAgIDB?=
 =?us-ascii?q?gMBAgICBQMDAgEDBAIOBA4DAQECAgEBAgQIAgIDAwICCA8VAwcCAQYFAQMBA?=
 =?us-ascii?q?gYEAgQBCwICBQIBCgECBAECAgIBBQkBAgMBAwELAgIGAgIDBQYEAgMEBgICB?=
 =?us-ascii?q?QIBAQMCAgINAwIDAgQBBQUBAQIQAgYECQEGAwsCBQEEAwECBQcBAwcDAgICA?=
 =?us-ascii?q?ggEEgIDAgIEBQICAgECBAUCBwIGAgECAgIEAgEDAgQCAgQCAgQDEQoCAwUDD?=
 =?us-ascii?q?gICAgICAQkLAgICAgIHBAIDAwEHAgICAQwBAx0DAgICAgICAgIBAwkDBAUKG?=
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
 =?us-ascii?q?gICAwQCBQOeBgF6FBM4QHEsNoEaAQGUcKwuRCEJAQYCW4FXfBopml2FbRoyq?=
 =?us-ascii?q?SctlxuRNZEMhXyBQ4IATSOBAW2BSVIZD44sFo5CYTsCBwsBAQMJjCMBAQ?=
IronPort-PHdr: A9a23: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
 zLQAw7vbJGS4dyImsKb4aiFXGW7W8gWKHGzpb4=
IronPort-Data: A9a23:PT3B7K5rj1Qh88U33vJpSQxRtFTHchMFZxGqfqrLsTDasY5as4F+v
 mAZCGHQOqyMZWqkLYhzbo2x/BtQ78fRmtBjSgdlrSlnEysa+MHILOrCIxarNUt+DCFioGGLT
 Sk6QoOdRCzhZiaE/n9BCpC48T8mk/jgqoPUUIbsIjp2SRJvVBAvgBdin/9RqoNziLBVOSvU0
 T/Ji5CZaQHNNwJcaDpOsPra8Uo355wehRtB1rAATaAT1LPhvyRNZH4vDfnZB2f1RIBSAtm7S
 47rpF1u1jqEl/uFIorNfofTKiXmcJaLVeS9oiM+t5yZv/R3jndaPpDXlhYrQRw/Zz2hx7idw
 f0R7sboEV9B0qfkwIzxWDEAe81y0DEvFBYq7hFTvOTKp3AqfUcAzN1zJmcEIrJDvdpWLn0Q7
 c40AjRdQhW60rfeLLKTEoGAh+whKcD7I44bvjdryjSx4fQOG8iZBfyUtZkDgXFq2pkm8fX2P
 qL1bRJtaR3QfBBLPgxIIJ07leaswHL4dlW0rXrP//prujGCklAZPL7FFPHfcPKSYs9vjmGph
 iXA/E3oJS8oK4nKodaC2jf27gPVpgv3UZwfEZW0/+BnhVmUyHBVDhAKPXO2reS8g1yzR/pQL
 Esb/idopq83nGSoU9P0dx61uniJulgbQdU4O/Uz4gyLy4LO7gqZD3RCRTlEAPQ3s9Q2SyEo1
 3eNntX0FXluqKPLD3WH+d+8oSi7OSUPK0cBaDUCQA9D5MPsyKk2hwjTT9AlFKeopt74Azf9x
 3aNtidWr7cUgMoj1aK2+V7KmTSloJTEVUgy/Aq/dnqs8wd8b42NZIGy71Xfq/FaI+6xQ0iIu
 D4OmtKR4fomApSElSjLS+IIdJmv6uqJPSP0n1FiBd8i+i6r9nrleppfiBl6JUF0IoMHdCXvb
 Uv7pwxc/tlQMWGsYKsxZJi+Y+woyKHwCtnhUquLRtVLa5l1MgSA+UlGbEicxW3k1k0lgKwlE
 YqdcNyrCH9AT6V7pAdaXM9HieVun35ugDiOAMqnllK7ybWfInWSTPEMLTNic9wE0U9Nmy2Nm
 /43CidA40o3vDHWCsUczWLfwZ3m45T26VAaZvG7rtK+Hzc=
IronPort-HdrOrdr: A9a23:86xGFahVOu9kSlXfYFznU9WFt3BQXsMji2hC6mlwRA09TyVXra
 2TdZMgpHzJYVkqN03I9erqBEDiexPhHOBOj7X5VI3KNDUO01HFEGgN1+HfKkXbehHDyg==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.96,318,1665406800"; 
   d="scan'208";a="228411964"
Received: from 202-168-35-241.tpgi.com.au (HELO jmaxwell.com) ([202.168.35.241])
  by rpt-cro-asav5.external.tpg.com.au with ESMTP; 12 Jan 2023 08:33:55 +1100
From:   Jon Maxwell <jmaxwell37@gmail.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, martin.lau@kernel.org,
        joel@joelfernandes.org, paulmck@kernel.org, eyal.birger@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jon Maxwell <jmaxwell37@gmail.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>
Subject: [net-next] ipv6: remove max_size check inline with ipv4
Date:   Thu, 12 Jan 2023 08:33:06 +1100
Message-Id: <20230111213306.265239-1-jmaxwell37@gmail.com>
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
index e74e0361fd92..53b09de61a4a 100644
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
+	if (entries > gc_thresh)
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

