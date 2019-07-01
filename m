Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A18915C50F
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 23:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfGAVjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 17:39:02 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:35931 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbfGAVjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 17:39:02 -0400
Received: by mail-qt1-f202.google.com with SMTP id q26so14650518qtr.3
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 14:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=x4FJeAaIKyxT+9SBDURR60/ynQyNGLeRgihMlyWM7KI=;
        b=oLfJ/Vc4aQS4gtdl6QwyNNHEQkC6jx541ZwWX+2/t9xX7Y1HOw3ekFQ2nnE48bZ8YK
         cKpOcC+/0abnEpyHwGd1HT/ABHdlK53Eyg+qcYrMUNVn6oITxwTDXNPJ5BuulKAOCxPj
         PQJE9enXS49acYXIQ1QbPcl8vzOeWUo33xEtINjCtRR7tdkAXZ0Z6mxaiSKbPQ2L2fus
         dbGd/+w+DyuQGANYQTP1Y9IiUfYhDOpHoXkIIgx3B0nN5l3iStd+B9F3g27BhdzE+rlv
         8YKC7sTyTfPn56oZsGNhkWY5l7QdIckWLQRElOJOOiy2y5w14mUcZjMhwfPDztKkKbgN
         aW8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=x4FJeAaIKyxT+9SBDURR60/ynQyNGLeRgihMlyWM7KI=;
        b=Zw7+4DM62dcM8kmhEmrypx8oO0TD1U5coy9CohmIlwqnTqW0fF2DwmAErwBHZdlWOK
         TukXj81FwQ4/FMvvIKsTLTY69xX7Bk9j8E8ZkUb+iXoBTi/RLjFYcgJLAav6Ze1xAAr0
         wOSsd0TavyGmVhP8xzWWiukUzodQkRn6qPLXdXZxUedCbhB9gcMSZYpp3aiidwtuoRmp
         9SN6Ogl8GWvjUxXCWu2fTbW5L0sRsgQbP37K2bPXeChKIC1OTXANHkxnE9o06GODtHea
         1hMeWiU8Nif2z7Bvf0EOffFSfq4JF4UdDoV1kvf30LKbqfbaQ9QAA/RhRwP4Kwn+C2iA
         7UPA==
X-Gm-Message-State: APjAAAXSYefqxNvrJqI9OUveV3kQUreWepUa0QJwgq0bAVuehZC8GUB5
        TDRYMZQjG3kj1KjPImQKOh+v388pPXlKhZIYYoMNERAKVQWO7GAFCd15aNtYaD/a7hczUJ8FnoY
        TrwSC10/nBE7N9bNEIE/NimCmuM0j7CiX4e+LnHXxqDdEfdfImYxxGKsQEx243n8k
X-Google-Smtp-Source: APXvYqxOqwsPyXfiHsPs8OFnA32uGQJN/0wbcP4X/tn32LprM/fRp6Uz3LKGKfSH6h2nEbZM/E6jlqLYcx+/
X-Received: by 2002:a0c:d941:: with SMTP id t1mr23449055qvj.176.1562017140946;
 Mon, 01 Jul 2019 14:39:00 -0700 (PDT)
Date:   Mon,  1 Jul 2019 14:38:57 -0700
Message-Id: <20190701213857.103511-1-maheshb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCHv3 next 2/3] blackhole_netdev: use blackhole_netdev to
 invalidate dst entries
From:   Mahesh Bandewar <maheshb@google.com>
To:     Netdev <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Daniel Axtens <dja@axtens.net>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        Mahesh Bandewar <maheshb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use blackhole_netdev instead of 'lo' device with lower MTU when marking
dst "dead".

Signed-off-by: Mahesh Bandewar <maheshb@google.com>
---
v1->v2->v3
  no change

 net/core/dst.c   | 2 +-
 net/ipv4/route.c | 3 +--
 net/ipv6/route.c | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/core/dst.c b/net/core/dst.c
index e46366228eaf..1325316d9eab 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -160,7 +160,7 @@ void dst_dev_put(struct dst_entry *dst)
 		dst->ops->ifdown(dst, dev, true);
 	dst->input = dst_discard;
 	dst->output = dst_discard_out;
-	dst->dev = dev_net(dst->dev)->loopback_dev;
+	dst->dev = blackhole_netdev;
 	dev_hold(dst->dev);
 	dev_put(dev);
 }
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index bbd55c7f6b2e..dc1f510a7c81 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1532,7 +1532,6 @@ static void ipv4_dst_destroy(struct dst_entry *dst)
 
 void rt_flush_dev(struct net_device *dev)
 {
-	struct net *net = dev_net(dev);
 	struct rtable *rt;
 	int cpu;
 
@@ -1543,7 +1542,7 @@ void rt_flush_dev(struct net_device *dev)
 		list_for_each_entry(rt, &ul->head, rt_uncached) {
 			if (rt->dst.dev != dev)
 				continue;
-			rt->dst.dev = net->loopback_dev;
+			rt->dst.dev = blackhole_netdev;
 			dev_hold(rt->dst.dev);
 			dev_put(dev);
 		}
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 7556275b1cef..39361f57351a 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -176,7 +176,7 @@ static void rt6_uncached_list_flush_dev(struct net *net, struct net_device *dev)
 			}
 
 			if (rt_dev == dev) {
-				rt->dst.dev = loopback_dev;
+				rt->dst.dev = blackhole_netdev;
 				dev_hold(rt->dst.dev);
 				dev_put(rt_dev);
 			}
-- 
2.22.0.410.gd8fdbe21b5-goog

