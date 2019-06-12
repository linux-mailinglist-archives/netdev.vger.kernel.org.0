Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7C24240C
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 13:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408935AbfFLLd6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 07:33:58 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:45041 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406951AbfFLLd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 07:33:57 -0400
Received: by mail-ed1-f68.google.com with SMTP id k8so25183340edr.11
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 04:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZK1rfebeAZy2VZhbXgK9JVhhf/g7goNVoEB7hDLP6Mg=;
        b=OUKCN/8yu9kenwRRARli46c7HKGeqkhlxc1h+Ks+VsMwYYZQmEXGfK7k3FM+jGR66k
         g8XRu/r0Kklg7qwtQ0UDQfbXx5o4FGRX2pQCS+ReBUBvP2sjhSy3iAM37QRmlWXpMVLz
         ypbwWe8PppSr2J0rr8c2tNCpzMlPbq6Ao4uYh481krod/CuWUaolP9Gj4hykCAypmh6Q
         seyE8MKwh85bSMnBEnsYpuz7lylmk2oy4zsdYKqZOxOHc9m9qlK8raShBRzXUai9Vl3v
         V9zgsC7tAgV/+Hql95F/BoWeW12EwKgX6CtCExKxnwtFnPt46Dh8Wrm2ZqpyIFddGs3Q
         k6dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZK1rfebeAZy2VZhbXgK9JVhhf/g7goNVoEB7hDLP6Mg=;
        b=jmI3/qiFmjkCcF3eTDkEoynzGmg8EUA1oUANXeNRd2TTScSTTWryn1w/JrjqE87DKq
         TWenYGx7VyBApZyHNmu08gicS6n387pvjAe+RJZGwucapCPof9KQnPUX9FYgzMhsBfiC
         b5Xh7BSd/J+LaaX+RSz4ew9osJmzYfpmynXKhiF8G1xKgCGtZuQnXFsas8M1Ya0doQvn
         ExLqFS5dOJzZsszeefMj/JySVK4KxbkL6YYCGEufW11trZAaohiZcLJJ6aw6X2tTRZtf
         wftXIwo2jRCGTgoXAxTW+RL50N2Z3awZbVX8YsNBuFAG0fq2gQ5K2BY+vf+jkPFzYU9o
         1zBg==
X-Gm-Message-State: APjAAAWdxQckMaht5P4I2Fhcuuo2f2nLAusjYn4HHg2n0rYWXdo8L0Ck
        tjm5G+PVdSEDwptK5Xw24/cgrQ==
X-Google-Smtp-Source: APXvYqySKfzmTfcJyTZWY5ElciAzTTNq8/g69hhp+2B+2N6RAzh0VCtYGgzvukQGKLEMjX04drLHXw==
X-Received: by 2002:a05:6402:14cf:: with SMTP id f15mr28184960edx.255.1560339235089;
        Wed, 12 Jun 2019 04:33:55 -0700 (PDT)
Received: from tegmen.arch.suse.de (charybdis-ext.suse.de. [195.135.221.2])
        by smtp.gmail.com with ESMTPSA id i21sm2752934ejd.76.2019.06.12.04.33.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 12 Jun 2019 04:33:54 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <dkirjanov@suse.com>
To:     davem@davemloft.net, dledford@redhat.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH 2/2] ipoib: show VF broadcast address
Date:   Wed, 12 Jun 2019 13:33:46 +0200
Message-Id: <20190612113348.59858-2-dkirjanov@suse.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20190612113348.59858-1-dkirjanov@suse.com>
References: <20190612113348.59858-1-dkirjanov@suse.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

in IPoIB case we can't see a VF broadcast address for but
can see for PF

Before:
11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
state UP mode DEFAULT group default qlen 256
    link/infiniband
80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
    vf 0 MAC 14:80:00:00:66:fe, spoof checking off, link-state disable,
trust off, query_rss off
...

After:
11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
state UP mode DEFAULT group default qlen 256
    link/infiniband
80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
    vf 0     link/infiniband
80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff, spoof
checking off, link-state disable, trust off, query_rss off
...

Signed-off-by: Denis Kirjanov <dkirjanov@suse.com>
---
 net/core/rtnetlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 2e1b9ffbe602..f70902b57a40 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1248,6 +1248,7 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 	if (!vf)
 		goto nla_put_vfinfo_failure;
 	if (nla_put(skb, IFLA_VF_MAC, sizeof(vf_mac), &vf_mac) ||
+	    nla_put(skb, IFLA_BROADCAST, dev->addr_len, dev->broadcast) ||
 	    nla_put(skb, IFLA_VF_VLAN, sizeof(vf_vlan), &vf_vlan) ||
 	    nla_put(skb, IFLA_VF_RATE, sizeof(vf_rate),
 		    &vf_rate) ||
-- 
2.12.3

