Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3DC4240F
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 13:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409016AbfFLLeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 07:34:00 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38733 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408240AbfFLLd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 07:33:58 -0400
Received: by mail-ed1-f66.google.com with SMTP id g13so25215457edu.5
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 04:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZK1rfebeAZy2VZhbXgK9JVhhf/g7goNVoEB7hDLP6Mg=;
        b=gjqGr1oUqHSoVIfYm5ktzYwqWbRdlBa4lSY87EGwZIf4P9E52Qss5XP8L3X8gTbnaJ
         4YQa3APlW+YAtEmQHG566Oz4O2ZhnbKsMhVZc1EcV+es38lU70zgbFCNPfm4sBfpDAoQ
         yFhtWkB3gtGkhk0S9+JHs9sHcA2Wwh0z90If1biT/tEltS4peaZY3fXtITnd8Y7/o8hN
         6VcIE6enxNcteq6+ER+z5pqHqnil9uWCfqCD4RQhwWWoFSdPHEk3dGoYXwkJ7laSjGlN
         tXSZhH42m+NqYRXmB+wTWPNE2o/4zgvJj10dNN7wvM2Oo5JKJO1f8xgVVqo6NmuzZ4q7
         FSCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZK1rfebeAZy2VZhbXgK9JVhhf/g7goNVoEB7hDLP6Mg=;
        b=ZZ+CrZeKdRmnaHdXkT6LBEqGxBorN9dM7rVnqAI6IL+zLMF6yU0CpdT5Odpi1BDF0x
         QISy+ky20bAK73lPome6A86CNlm5qB75EF1YKQPtJV1VvQ9GtIkzbiw21SNTnyQq1zKJ
         aX82ExTdhmTh4VgF1VAow2U2+L+2cjidgi70YCbF9hoG2AkJMX+oEEp2aitf9537mLxu
         1JK1rwXyeIvu9o5NhZO/42DvH6CCvso0KRH/AosbqszXDbTsCCoaVRxwGqnpWt9NyER/
         q/qEkQ6Slz9z7hTVlhoQx7kgsqyL1WQ7Isat/+iRtk6czri5EQYDmVoAEFqLhXH/2/O5
         DxvQ==
X-Gm-Message-State: APjAAAXXzXHBJi/VBcw3x+aAqxIGxkMGeqAxCTntybCZWZh+kD4nJS8+
        ZD4qEsFo70KbiwFPUGuOvjotqQ==
X-Google-Smtp-Source: APXvYqxxAXM2MiwL49vBBLeDWD8POyGb924iwQ9IdmSEKUkNva+/5X+GZyGqZY6BbiUzBYrgWvjA+A==
X-Received: by 2002:a50:9282:: with SMTP id k2mr39869843eda.269.1560339236705;
        Wed, 12 Jun 2019 04:33:56 -0700 (PDT)
Received: from tegmen.arch.suse.de (charybdis-ext.suse.de. [195.135.221.2])
        by smtp.gmail.com with ESMTPSA id i21sm2752934ejd.76.2019.06.12.04.33.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 12 Jun 2019 04:33:56 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <dkirjanov@suse.com>
To:     davem@davemloft.net, dledford@redhat.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next 2/2] ipoib: show VF broadcast address
Date:   Wed, 12 Jun 2019 13:33:48 +0200
Message-Id: <20190612113348.59858-4-dkirjanov@suse.com>
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

