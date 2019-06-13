Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E67743824
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732788AbfFMPDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:03:52 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38865 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732483AbfFMOUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 10:20:12 -0400
Received: by mail-ed1-f67.google.com with SMTP id g13so31479043edu.5
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 07:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/NtGpRztGZUSKBlVGtAfFgFpV5jy4TAVyJSX2rG0vCQ=;
        b=i8UQ3VgmvpSpOgaPxdzp9hcWrjjX4XzlDDx3ILcGkpxUephFvcZnKMwQ7g3xQYxaS/
         LZ6ZCxljSp2wvMZ5dwxlxGyAxT+z2uUJv1tq8lAsWFyjJ4pgNSccwJ2qGYhzxeI4w/Nh
         qp2ZkJUZJoRpoDJ9mBkwMqzMRY3iQqjFfKNYqGBt0dEWmTpI6lMdseawUtAFngFz36d2
         KzfN741IxfnYHuEf5lg1Hfw/+qPAbKoDHs8l1pVk1hyB6LNsQYkIneRjLHYe9wRNBvl9
         9kogd8X63uhkOguanPf2Nq7iObX45zhx/gwHvEpBO/XmZ0FjMf0kvoVQlrfogDhVzwW6
         YT5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/NtGpRztGZUSKBlVGtAfFgFpV5jy4TAVyJSX2rG0vCQ=;
        b=kZLntZV3kpH6Zq0ulLHr29J+A4Pw/FwlaeA1ipUAs7uNc3Hmhat2wJxZhg06qW97/W
         091Rae5d6/Q65fH8Hff2ZYS1QCRO6lgDDyEBq/sB1vv+TajA7/VP0IwPrliRWl6ajOrI
         VmDL1IEBVTHC56i8G7xQVqOWvDLMqESDBCMTbvbnZI9HShFPk+8infIFL6PGDIygh4Hi
         1zaytl37AepYKynPCohQCy5gBoEJy3Tcd1QdZZ28lM63pKvnOYI0/sgUhvbx7pCy3sby
         bpZJ2SNsmnkx3LBfcYUsh8j91w+FCB/t9WK1DEw/u9lVZ6UsmbivIEMkBj4NQdpDA/Ag
         HC0g==
X-Gm-Message-State: APjAAAVXk6ems1W6Yg9dzeYif3zZq/HxPge07ZTma/aANxeKcjRqF2W0
        i4rPUR5mR8y7ucA2swjKkXoGFw==
X-Google-Smtp-Source: APXvYqz7nfkhbO4bBwef9z46an/xAJU5bXh/D7jWUIywujXKFw+ASJ+uPjlS0uDUHSzQhXwK56Xqxw==
X-Received: by 2002:a50:b6ce:: with SMTP id f14mr72406873ede.236.1560435610729;
        Thu, 13 Jun 2019 07:20:10 -0700 (PDT)
Received: from tegmen.arch.suse.de (charybdis-ext.suse.de. [195.135.221.2])
        by smtp.gmail.com with ESMTPSA id s57sm931939edd.54.2019.06.13.07.20.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 13 Jun 2019 07:20:10 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
X-Google-Original-From: Denis Kirjanov <dkirjanov@suse.com>
To:     davem@davemloft.net, dledford@redhat.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        mkubecek@suse.cz, Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH 2/2] ipoib: show VF broadcast address
Date:   Thu, 13 Jun 2019 16:20:01 +0200
Message-Id: <20190613142003.129391-2-dkirjanov@suse.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20190613142003.129391-1-dkirjanov@suse.com>
References: <20190613142003.129391-1-dkirjanov@suse.com>
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

v1->v2: add the IFLA_VF_BROADCAST constant

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 include/uapi/linux/if_link.h | 5 +++++
 net/core/rtnetlink.c         | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 5b225ff63b48..1f36dd3a45d6 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -681,6 +681,7 @@ enum {
 enum {
 	IFLA_VF_UNSPEC,
 	IFLA_VF_MAC,		/* Hardware queue specific attributes */
+	IFLA_VF_BROADCAST,
 	IFLA_VF_VLAN,		/* VLAN ID and QoS */
 	IFLA_VF_TX_RATE,	/* Max TX Bandwidth Allocation */
 	IFLA_VF_SPOOFCHK,	/* Spoof Checking on/off switch */
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
index cec60583931f..88304212f127 100644
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
@@ -1247,8 +1250,10 @@ static noinline_for_stack int rtnl_fill_vfinfo(struct sk_buff *skb,
 	if (!vf)
 		goto nla_put_vfinfo_failure;
 	if (nla_put(skb, IFLA_VF_MAC, sizeof(vf_mac), &vf_mac) ||
+	    nla_put(skb, IFLA_VF_BROADCAST, sizeof(vf_broadcast), &vf_broadcast) ||
 	    nla_put(skb, IFLA_VF_VLAN, sizeof(vf_vlan), &vf_vlan) ||
 	    nla_put(skb, IFLA_VF_RATE, sizeof(vf_rate),
+
 		    &vf_rate) ||
 	    nla_put(skb, IFLA_VF_TX_RATE, sizeof(vf_tx_rate),
 		    &vf_tx_rate) ||
@@ -1753,6 +1758,7 @@ static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
 
 static const struct nla_policy ifla_vf_policy[IFLA_VF_MAX+1] = {
 	[IFLA_VF_MAC]		= { .len = sizeof(struct ifla_vf_mac) },
+	[IFLA_VF_BROADCAST]	= {. len = sizeof(struct ifla_vf_broadcast) },
 	[IFLA_VF_VLAN]		= { .len = sizeof(struct ifla_vf_vlan) },
 	[IFLA_VF_VLAN_LIST]     = { .type = NLA_NESTED },
 	[IFLA_VF_TX_RATE]	= { .len = sizeof(struct ifla_vf_tx_rate) },
-- 
2.12.3

