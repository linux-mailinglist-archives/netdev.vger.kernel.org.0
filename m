Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B23847DA7
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 10:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbfFQIxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 04:53:52 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:33102 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfFQIxv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 04:53:51 -0400
Received: by mail-ed1-f67.google.com with SMTP id i11so15065878edq.0
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 01:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DTdlSRI5toTIXOI9GdbnOjjqVUi+gPD2G3Jt4p3hHow=;
        b=QFtPAWiyBosToAPGs0O6nwrHBfHu1PCESD+JsskSK/eKnHBZYEZ9wT3nrRA4idqqZN
         m4hnSvLBi8igx9+/4HZHaRrlg+vi2E5AvCrUMW/3f+CNPxcv1FlF0HnzJZIdVhDlQcE0
         4fJ9b81hDYV/kHMEQS1IPi2UTefR3hYxpQgS9ELr9hVTtK8otkQl1vDp38RMR6wSUnQM
         LOw8DuFp6U0qXLOaAu0xQmiR5AAjch4fIycwZ0Uck0LXuKw9Nv4Tza/c3fX4vdKpD42J
         174qlRjNffoxKtPMK5k9ssMEOvk9UsVnQxrCiozXGEcN7K7K7qkYkiiO404Rbxdgb2mv
         +uug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DTdlSRI5toTIXOI9GdbnOjjqVUi+gPD2G3Jt4p3hHow=;
        b=f2E7VgHu97f20HpkaMN9tPQVST4ccVWarkVAgdeLEDlJg7PKVnHI/elCEGSNl1wF63
         FoStEgWmWr7Eu8XASYUdyz9UY4GmEzPMH3bFOnhKor914iwD+2vI5GGsNwT6iysfvnEm
         N8fzfMv+ZsxB3DQKvaC8K9xj45NzdicEPnrS8lvg4uIIccjXY/NtgAemy3iLZduqs109
         aCb6rtMUzb22Ig04pr7GSQNS0BaXKve5BymAXb3XxsdxqOj01RoDuK+Z9mPz2CFn3G8u
         zwGcfBuJ9ZZo3rHATDCREOsMwlws+U8O5H7Krd3q2q+j3nDE4NpP3SNqPQ2GTjkLD0O3
         cMTA==
X-Gm-Message-State: APjAAAXxXjxi81TjXJ9H3sTYAbMo1ONKujeo5c2qCk5QyCBaQoK3hWbC
        aX5H2lAx9UGGfN6U+PkPR6UlyQ==
X-Google-Smtp-Source: APXvYqxoMlM/rJp3A933zVaQKrNk7W0KzCCSgP+wr+yYtoTX07t4tKNdjRNlGEEbkmp41wqCb9gMzw==
X-Received: by 2002:a17:906:610:: with SMTP id s16mr93601890ejb.108.1560761628569;
        Mon, 17 Jun 2019 01:53:48 -0700 (PDT)
Received: from tegmen.arch.suse.de (nat.nue.novell.com. [195.135.221.2])
        by smtp.gmail.com with ESMTPSA id y11sm2075735ejb.54.2019.06.17.01.53.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 17 Jun 2019 01:53:48 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <dkirjanov@suse.com>
To:     davem@davemloft.net, dledford@redhat.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        mkubecek@suse.cz, Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH 2/2] ipoib: show VF broadcast address
Date:   Mon, 17 Jun 2019 10:53:39 +0200
Message-Id: <20190617085341.51592-2-dkirjanov@suse.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20190617085341.51592-1-dkirjanov@suse.com>
References: <20190617085341.51592-1-dkirjanov@suse.com>
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

After with iproute2 patch[0]:
11: ib1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 2044 qdisc pfifo_fast
state UP mode DEFAULT group default qlen 256
    link/infiniband
80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
    vf 0     link/infiniband
80:00:00:66:fe:80:00:00:00:00:00:00:24:8a:07:03:00:a4:3e:7c brd
00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff, spoof
checking off, link-state disable, trust off, query_rss off

[0]: https://patchwork.kernel.org/patch/10997111 

v1->v2: add the IFLA_VF_BROADCAST constant
v2->v3: put IFLA_VF_BROADCAST at the end
to avoid KABI breakage and set NLA_REJECT
dev_setlink
v3->v4: update the changelog: add a link to the patch for iproute2

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 include/uapi/linux/if_link.h | 5 +++++
 net/core/rtnetlink.c         | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 5b225ff63b48..6f75bda2c2d7 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -694,6 +694,7 @@ enum {
 	IFLA_VF_IB_NODE_GUID,	/* VF Infiniband node GUID */
 	IFLA_VF_IB_PORT_GUID,	/* VF Infiniband port GUID */
 	IFLA_VF_VLAN_LIST,	/* nested list of vlans, option for QinQ */
+	IFLA_VF_BROADCAST,	/* VF broadcast */
 	__IFLA_VF_MAX,
 };
 
@@ -704,6 +705,10 @@ struct ifla_vf_mac {
 	__u8 mac[32]; /* MAX_ADDR_LEN */
 };
 
+struct ifla_vf_broadcast {
+	__u8 broadcast[32];
+};
+
 struct ifla_vf_vlan {
 	__u32 vf;
 	__u32 vlan; /* 0 - 4095, 0 disables VLAN filter */
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index cec60583931f..8ac81630ab5c 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -908,6 +908,7 @@ static inline int rtnl_vfinfo_size(const struct net_device *dev,
 		size += num_vfs *
 			(nla_total_size(0) +
 			 nla_total_size(sizeof(struct ifla_vf_mac)) +
+			 nla_total_size(sizeof(struct ifla_vf_broadcast)) +
 			 nla_total_size(sizeof(struct ifla_vf_vlan)) +
 			 nla_total_size(0) + /* nest IFLA_VF_VLAN_LIST */
 			 nla_total_size(MAX_VLAN_LIST_LEN *
@@ -1197,6 +1198,7 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 	struct ifla_vf_vlan vf_vlan;
 	struct ifla_vf_rate vf_rate;
 	struct ifla_vf_mac vf_mac;
+	struct ifla_vf_broadcast vf_broadcast;
 	struct ifla_vf_info ivi;
 
 	memset(&ivi, 0, sizeof(ivi));
@@ -1231,6 +1233,7 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 		vf_trust.vf = ivi.vf;
 
 	memcpy(vf_mac.mac, ivi.mac, sizeof(ivi.mac));
+	memcpy(vf_broadcast.broadcast, dev->broadcast, dev->addr_len);
 	vf_vlan.vlan = ivi.vlan;
 	vf_vlan.qos = ivi.qos;
 	vf_vlan_info.vlan = ivi.vlan;
@@ -1247,6 +1250,7 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 	if (!vf)
 		goto nla_put_vfinfo_failure;
 	if (nla_put(skb, IFLA_VF_MAC, sizeof(vf_mac), &vf_mac) ||
+	    nla_put(skb, IFLA_VF_BROADCAST, sizeof(vf_broadcast), &vf_broadcast) ||
 	    nla_put(skb, IFLA_VF_VLAN, sizeof(vf_vlan), &vf_vlan) ||
 	    nla_put(skb, IFLA_VF_RATE, sizeof(vf_rate),
 		    &vf_rate) ||
@@ -1753,6 +1757,7 @@ static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
 
 static const struct nla_policy ifla_vf_policy[IFLA_VF_MAX+1] = {
 	[IFLA_VF_MAC]		= { .len = sizeof(struct ifla_vf_mac) },
+	[IFLA_VF_BROADCAST]	= { .type = NLA_REJECT },
 	[IFLA_VF_VLAN]		= { .len = sizeof(struct ifla_vf_vlan) },
 	[IFLA_VF_VLAN_LIST]     = { .type = NLA_NESTED },
 	[IFLA_VF_TX_RATE]	= { .len = sizeof(struct ifla_vf_tx_rate) },
-- 
2.12.3

