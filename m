Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF177D88E4
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 09:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389248AbfJPHEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 03:04:52 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:46550 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388601AbfJPHEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 03:04:52 -0400
Received: by mail-pg1-f201.google.com with SMTP id 195so10985894pgc.13
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 00:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=UMWT9nWCcn5ICihsP++abKeexGAkJ2bVvRXUJSFuKhQ=;
        b=CbN/iZFLTfK37GxxoO2FA+b0Y7RRMdritLVe+tLfi1qdiaYWGM9ti2nly3O+F3VElb
         aBb2vjETwdO96GXUy0Ciwl0+LM7KGG6CvRsdYEejoz6jAB4H9qNdJSkG1bJuwOgTsMOX
         hZ/UySVcHTfPe+YhLeeKIxaf9a5zczEUfPEYCDtNkE3t9Fx2FRMNQkeqG3x2NzxMSRmF
         V6+KnDXoofbcM/1ssmVmVcJpfo0IuIYmwkEwdHt9HtRdhupbCHS2VNvJkAKPQKhtXAfr
         ChcEiWFbQnI+SXJk4ypiBEawQH6Ivb3MM2xV+Rqihft9o7VWyqSPZSqMFT5rvbV/65k8
         qf9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=UMWT9nWCcn5ICihsP++abKeexGAkJ2bVvRXUJSFuKhQ=;
        b=uQmD6yorga2QwDsWtEb+l26ZwuUEuRqhRMZ0OG0JH141PRbhZkD+lWmmp95dyd848N
         p70O7BVCdE3VKflBPrALqmIc2qub8KYSYEQ5xo3xZ6BfnojjX+TvsuKWXNwo+ngZdYlt
         AKENS4ALoWtsscPfjn9yty5ZTfAsetw+0SMHez65n6tH0wJGKN/KWgBZj48O43R1KX2s
         itwu8rHcm0q6umMm+T4E3I10uXv0FpifmaWdpbFG68oS5QzZlEHTJW/3v3g6+ffYm00+
         Yme3bnhb6KCivFsmN8MyExGPxJQ+7HEZuo6cZ4Z0Z6sJOcRgxd0V9E/v5Kd4kJIlfXpb
         RANA==
X-Gm-Message-State: APjAAAWA8hccqHVv4MayN+nk0jZ934CJphDx5AFA6Te9kSI6rxMLIX0/
        jI6ebUvrUWjSppnKGH5kJrhvmY9pAK/gW6xRXTmBItcb336ekviqDGP1LakVym7/jlQMbZRo+8g
        K6nKW5UWgBuDychiczJx3HRU8NL82OcwBwOXdD7xOzCOIzo6hJ116D/3cdG30ydYv
X-Google-Smtp-Source: APXvYqx7LfmDjcsJPOmLQ/SyHMe4jOblhjS60mdziqFvhVWdsLNW/C+qCDpz+YvM03OeI7J024Lte+cU04EZ
X-Received: by 2002:a63:d916:: with SMTP id r22mr43278682pgg.46.1571209489299;
 Wed, 16 Oct 2019 00:04:49 -0700 (PDT)
Date:   Wed, 16 Oct 2019 00:04:38 -0700
Message-Id: <20191016070438.156372-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH net] Revert "blackhole_netdev: fix syzkaller reported issue"
From:   Mahesh Bandewar <maheshb@google.com>
To:     Netdev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Wang <weiwan@google.com>,
        David Miller <davem@davemloft.net>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit b0818f80c8c1bc215bba276bd61c216014fab23b.

Started seeing weird behavior after this patch especially in
the IPv6 code path. Haven't root caused it, but since this was
applied to net branch, taking a precautionary measure to revert
it and look / analyze those failures

Revert this now and I'll send a better fix after analysing / fixing
the weirdness observed.

CC: Eric Dumazet <edumazet@google.com>
CC: Wei Wang <weiwan@google.com>
CC: David S. Miller <davem@davemloft.net>
Signed-off-by: Mahesh Bandewar <maheshb@google.com>
---
 net/ipv6/addrconf.c |  7 +------
 net/ipv6/route.c    | 15 +++++++++------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 4c87594d1389..34ccef18b40e 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -6996,7 +6996,7 @@ static struct rtnl_af_ops inet6_ops __read_mostly = {
 
 int __init addrconf_init(void)
 {
-	struct inet6_dev *idev, *bdev;
+	struct inet6_dev *idev;
 	int i, err;
 
 	err = ipv6_addr_label_init();
@@ -7036,14 +7036,10 @@ int __init addrconf_init(void)
 	 */
 	rtnl_lock();
 	idev = ipv6_add_dev(init_net.loopback_dev);
-	bdev = ipv6_add_dev(blackhole_netdev);
 	rtnl_unlock();
 	if (IS_ERR(idev)) {
 		err = PTR_ERR(idev);
 		goto errlo;
-	} else if (IS_ERR(bdev)) {
-		err = PTR_ERR(bdev);
-		goto errlo;
 	}
 
 	ip6_route_init_special_entries();
@@ -7128,7 +7124,6 @@ void addrconf_cleanup(void)
 		addrconf_ifdown(dev, 1);
 	}
 	addrconf_ifdown(init_net.loopback_dev, 2);
-	addrconf_ifdown(blackhole_netdev, 2);
 
 	/*
 	 *	Check hash table.
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 742120728869..a63ff85fe141 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -155,9 +155,10 @@ void rt6_uncached_list_del(struct rt6_info *rt)
 
 static void rt6_uncached_list_flush_dev(struct net *net, struct net_device *dev)
 {
+	struct net_device *loopback_dev = net->loopback_dev;
 	int cpu;
 
-	if (dev == net->loopback_dev)
+	if (dev == loopback_dev)
 		return;
 
 	for_each_possible_cpu(cpu) {
@@ -170,7 +171,7 @@ static void rt6_uncached_list_flush_dev(struct net *net, struct net_device *dev)
 			struct net_device *rt_dev = rt->dst.dev;
 
 			if (rt_idev->dev == dev) {
-				rt->rt6i_idev = in6_dev_get(blackhole_netdev);
+				rt->rt6i_idev = in6_dev_get(loopback_dev);
 				in6_dev_put(rt_idev);
 			}
 
@@ -385,11 +386,13 @@ static void ip6_dst_ifdown(struct dst_entry *dst, struct net_device *dev,
 {
 	struct rt6_info *rt = (struct rt6_info *)dst;
 	struct inet6_dev *idev = rt->rt6i_idev;
+	struct net_device *loopback_dev =
+		dev_net(dev)->loopback_dev;
 
-	if (idev && idev->dev != dev_net(dev)->loopback_dev) {
-		struct inet6_dev *ibdev = in6_dev_get(blackhole_netdev);
-		if (ibdev) {
-			rt->rt6i_idev = ibdev;
+	if (idev && idev->dev != loopback_dev) {
+		struct inet6_dev *loopback_idev = in6_dev_get(loopback_dev);
+		if (loopback_idev) {
+			rt->rt6i_idev = loopback_idev;
 			in6_dev_put(idev);
 		}
 	}
-- 
2.23.0.700.g56cf767bdb-goog

