Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC802A25B3
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 08:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgKBH55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 02:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbgKBH54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 02:57:56 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5376C0617A6
        for <netdev@vger.kernel.org>; Sun,  1 Nov 2020 23:57:56 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id b19so6444407pld.0
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 23:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4MW1r6CAD05pmC6WiE3CbF0cgCRfZtuPWRUOq3+fbj4=;
        b=CJbfk8ETilgmvHP5UOJBrSdHBxPaIRTtiUjrwgQHaYgPlHeA2fVezZliHE8XSF82gL
         wUHZw0C6d58DCpn+BE4hvxQvsQh4fLPZHxsgcfuAyTzoENXNbd5YdajNsWxQwgjd6XDI
         Wbwp/4h9hpUqj5oD6yOJBRs0jpWyw7UDwtLMN7YdoYPjexM3AWO3zSzc+VEGv7IRAwZH
         JHaYwIOsG2oZENsPgrkLE9pjy0ODPHkw1vRYvc36IMNft0PEjGRb12SJiAXnBly2E6AW
         OVXWbdq4XsRsWzWgxOEwGbKg3hirJtKRIy29JHE4wYojQUXDRo5Mx5Qnj6iciBpp2Cn0
         IcuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4MW1r6CAD05pmC6WiE3CbF0cgCRfZtuPWRUOq3+fbj4=;
        b=PHseu+IaHzsUk7ZiXU1WIInIk0v1/pUaBqrtdjF+2wTDYTvWJoRmLbvX5wa/+IMKzJ
         DO2wYJuIL3tKngoKgB677s0Qu6WF+IuCyEeBYnL+0PEmVz56tYbXmKJ4b0MoMF9++FzV
         4YY9ADaYuo4qFnKpYn2ZDNyJod9riYY0M0uYj9Y8EIRlwpUIIBVBeolj+3WQikbIPEPf
         4CQ64RIrz2Ag9V2am5yLO3/afu00uPuDUurFwdjo1u9mNF+sUEDVOEb882vwKHGnnXys
         +YGwaltV3IpP2ZJC6/HCH56N+cB8y7E+5dgNabn38Chvtx8pC5JbECV2rNtb8gGuSGOw
         iTgg==
X-Gm-Message-State: AOAM5334mAMhEgQPxO624QCeAJgZjPKHZm2HSsOUckC4xGWzEyaQMYub
        TpYHvgM+b5H7ZKijz407CrvJg5kaMiTbAA==
X-Google-Smtp-Source: ABdhPJwHIbF1S48FMZjf9ZoHsodoQZ0mYh2ud0fccIZQuXeSUqngoeNN73D68Y14xXGuzwfdIGt0/w==
X-Received: by 2002:a17:902:b689:b029:d5:e78f:65d1 with SMTP id c9-20020a170902b689b02900d5e78f65d1mr20029372pls.6.1604303875076;
        Sun, 01 Nov 2020 23:57:55 -0800 (PST)
Received: from devstack.localdomain ([161.117.195.136])
        by smtp.gmail.com with ESMTPSA id k26sm3506718pfg.8.2020.11.01.23.57.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 01 Nov 2020 23:57:54 -0800 (PST)
From:   LIU Yulong <liuyulong.xa@gmail.com>
X-Google-Original-From: LIU Yulong <i@liuyulong.me>
To:     netdev@vger.kernel.org
Cc:     LIU Yulong <i@liuyulong.me>
Subject: [PATCH v2] net: bonding: alb disable balance for IPv6 multicast related mac
Date:   Mon,  2 Nov 2020 15:56:43 +0800
Message-Id: <1604303803-30660-1-git-send-email-i@liuyulong.me>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603850163-4563-1-git-send-email-i@liuyulong.me>
References: <1603850163-4563-1-git-send-email-i@liuyulong.me>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the RFC 2464 [1] the prefix "33:33:xx:xx:xx:xx" is defined to
construct the multicast destination MAC address for IPv6 multicast traffic.
The NDP (Neighbor Discovery Protocol for IPv6)[2] will comply with such
rule. The work steps [6] are:
  *) Let's assume a destination address of 2001:db8:1:1::1.
  *) This is mapped into the "Solicited Node Multicast Address" (SNMA)
     format of ff02::1:ffXX:XXXX.
  *) The XX:XXXX represent the last 24 bits of the SNMA, and are derived
     directly from the last 24 bits of the destination address.
  *) Resulting in a SNMA ff02::1:ff00:0001, or ff02::1:ff00:1.
  *) This, being a multicast address, can be mapped to a multicast MAC
     address, using the format 33-33-XX-XX-XX-XX
  *) Resulting in 33-33-ff-00-00-01.
  *) This is a MAC address that is only being listened for by nodes
     sharing the same last 24 bits.
  *) In other words, while there is a chance for a "address collision",
     it is a vast improvement over ARP's guaranteed "collision".
Kernel related code can be found at [3][4][5].

The current bond alb has some leaks of such MAC ranges which will cause
the physical world failed to determain the back tunnel of the reply
packet during the response in a Spine-and-Leaf data center architecture.
The basic topology looks like this:

            +-------------+
        +---| Border Leaf |-----+
tunnel-1|   +-------------+     | tunnel-2
        |                       |
    +---+----+           +------+-+
    | Leaf1  +-----X-----+  Leaf2 |  tunnel-3 has loop avoidance
    +--------+  tunnel-3 +-+------+
             |             |
             +----+   +----+
          +--+nic1+---+nic2+---+
          |  +----+   +----+   |
          |       bond6        |
          |       HOST         |
          +--------------------+

When nic1 is sending the normal IPv6 traffic to the gateway in Border leaf,
the nic2 (slave) will send the NS packet out periodically, automatically
and implicitly as well. This is an example packet sending from the slave
nic2 which will broke the traffic.

  ac:1f:6b:90:5c:eb > 33:33:ff:00:00:01, ethertype 802.1Q (0x8100),
  length 90: vlan 205, p 0, ethertype IPv6, (hlim 255,
  next-header ICMPv6 (58) payload length: 32)
  fe80::f816:3eff:feba:2d8c > ff02::1:ff00:1:
  [icmp6 sum ok] ICMP6, neighbor solicitation, length 32,
  who has 240e:980:2f00:4000::1
  source link-address option (1), length 8 (1): fa:16:3e:ba:2d:8c

The packet source MAC "ac:1f:6b:90:5c:eb" was the nic2 MAC whose original
value should be "fa:16:3e:ba:2d:8c", but it was changed by alb related
MAC address mechanism [8].

MAC "fa:16:3e:ba:2d:8c" was the virtual device MAC from a cloud service
inside a kernel network namespace, the topology is here [7].
MAC "fa:16:3e:ba:2d:8c" was first learnt at Leaf1 based on the underlay
mechanism(BGP EVPN). When this example packet was sent to Border leaf and
replied with dst_mac "fa:16:3e:ba:2d:8c", Leaf2 will try to send packet
back to tunnel-3 at this point dropping happens because of the loop
defense. All the original normal IPv6 traffic will be lead to the tunnel-2
and then drop. Link is broken now.

This patch addresses such issue by check the entire MAC range definde by
the RFC 2464. Adding a new helper method to check the first two octets
are the value 3333. If the dest MAC is matched, no balance will be
enabled.

[1] https://tools.ietf.org/html/rfc2464#section-7
[2] https://tools.ietf.org/html/rfc4861
[3] linux.git/tree/include/net/if_inet6.h#n209-n221
[4] linux.git/tree/net/ipv6/ndisc.c#n291
[5] linux.git/tree/net/ipv6/ndisc.c#n346-n348
[6] https://en.citizendium.org/wiki/Neighbor_Discovery
[7] https://docs.openstack.org/neutron/latest/admin/deploy-ovs-selfservice.html#architecture
[8] linux.git/tree/drivers/net/bonding/bond_alb.c#n1320

Signed-off-by: LIU Yulong <i@liuyulong.me>
---
 drivers/net/bonding/bond_alb.c |  8 ++------
 include/linux/etherdevice.h    | 12 ++++++++++++
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index c3091e0..eda9046 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -24,9 +24,6 @@
 #include <net/bonding.h>
 #include <net/bond_alb.h>
 
-static const u8 mac_v6_allmcast[ETH_ALEN + 2] __long_aligned = {
-	0x33, 0x33, 0x00, 0x00, 0x00, 0x01
-};
 static const int alb_delta_in_ticks = HZ / ALB_TIMER_TICKS_PER_SEC;
 
 #pragma pack(1)
@@ -1425,10 +1422,9 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
 			break;
 		}
 
-		/* IPv6 uses all-nodes multicast as an equivalent to
-		 * broadcasts in IPv4.
+		/* IPv6 multicast destinations should not be tx-balanced.
 		 */
-		if (ether_addr_equal_64bits(eth_data->h_dest, mac_v6_allmcast)) {
+		if (is_ipv6_multicast_ether_addr(eth_data->h_dest)) {
 			do_tx_balance = false;
 			break;
 		}
diff --git a/include/linux/etherdevice.h b/include/linux/etherdevice.h
index 2e5debc..ac74a99 100644
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -178,6 +178,18 @@ static inline bool is_unicast_ether_addr(const u8 *addr)
 }
 
 /**
+ * is_ipv6_multicast_ether_addr - Determine if the Ethernet address is for
+ *				  IPv6 multicast (rfc2464).
+ * @addr: Pointer to a six-byte array containing the Ethernet address
+ *
+ * Return true if the address is a multicast for IPv6.
+ */
+static inline bool is_ipv6_multicast_ether_addr(const u8 *addr)
+{
+	return (addr[0] == 0x33) && (addr[1] == 0x33);
+}
+
+/**
  * is_valid_ether_addr - Determine if the given Ethernet address is valid
  * @addr: Pointer to a six-byte array containing the Ethernet address
  *
-- 
1.8.3.1

