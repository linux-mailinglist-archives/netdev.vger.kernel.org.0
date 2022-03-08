Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C66E4D2346
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 22:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350446AbiCHV0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 16:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245079AbiCHV0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 16:26:35 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC63950B1B;
        Tue,  8 Mar 2022 13:25:38 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id d17so486064pfv.6;
        Tue, 08 Mar 2022 13:25:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EPQ0rzVHIJ3oqKnKu/qbr+qqvooLfTrDWRa/t4X4+Lg=;
        b=Irl9uNnPbiGv0B/goQOHJBRsUe9OBcZzTLd0tNao+hSR3PQxSRG6F8Pp7eVIAgcBDY
         Uq1eTrq+7Z5D47p12fMudGOfdyynuIQx/sgDwZ5hypXh8VblCqdBo+hfuANSgLnGgmEn
         Nz38UjrfXTiTR6R3QnL4Y8rzpml1OCrtv1lCN0x/CB44YRVHhXkPSorpRCaVLyAlzLBI
         gISMJxOblVTdqixLY+xbThKzwxcnB/AjweteZQQ0ZDJ+yf01l8I1H469A/Vg1OycjeIQ
         iVEtEBowA4Emr/UenrgDmvw1mJLzQBfxT2UGja0CZ24b/a/H+on4UkxfavqyMrFxq3bu
         tuFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EPQ0rzVHIJ3oqKnKu/qbr+qqvooLfTrDWRa/t4X4+Lg=;
        b=EmQurns/ICJGg7HWwiK2QRMPIccsKNPHtvNeAWGncinOrt4zyohdK2E0HhF/f7DsTA
         yQt7cvNv7wGENgNKI37jAbu+6rgxO7FKtT7vlQ8W9i5g+CfCvwX3Z5+D+fgMpXvtjD6+
         CISrcMenQA1AjcUp6H40YRno4Z+jHhWMd80/BvfNNu32rc7MYCdk4aCDoeW83CynHqyp
         K6MJQmCH4kPV3ARkna/t/5UVo7RfxBLrmbcTbHdeyC2mPK1Xj+WaiCe+WpKGdrDh/eLT
         vDGK4LfZOaFFF6U2i3GMO4RrwOE4Qjerxq1koNLGja0kE7H1tylPS2QPAvOE1sWbvln6
         HXvw==
X-Gm-Message-State: AOAM533f4siyJRnbJ1b5ztbuvspbxgMgwXHzOR5pyHtso+jdO6y9z1WU
        2zkKiTrFP+8edT6IK8UlK64=
X-Google-Smtp-Source: ABdhPJyhV1aEucENXUP50DM4716AMzcSEl8Ecssd5XL80tOxfvKSzoqAHi8kBvwRYxFy+UZuU+2wkQ==
X-Received: by 2002:a05:6a00:15c6:b0:4f0:fc4d:35d1 with SMTP id o6-20020a056a0015c600b004f0fc4d35d1mr20004952pfu.23.1646774738295;
        Tue, 08 Mar 2022 13:25:38 -0800 (PST)
Received: from jeffreyji1.c.googlers.com.com (180.145.227.35.bc.googleusercontent.com. [35.227.145.180])
        by smtp.gmail.com with ESMTPSA id oo16-20020a17090b1c9000b001b89e05e2b2sm24131pjb.34.2022.03.08.13.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 13:25:37 -0800 (PST)
From:   Jeffrey Ji <jeffreyjilinux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Brian Vazquez <brianvv@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffreyji <jeffreyji@google.com>
Subject: [PATCH v3 net-next] net-core: add rx_otherhost_dropped counter
Date:   Tue,  8 Mar 2022 21:25:31 +0000
Message-Id: <20220308212531.752215-1-jeffreyjilinux@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jeffreyji <jeffreyji@google.com>

Increment rx_otherhost_dropped counter when packet dropped due to
mismatched dest MAC addr.

An example when this drop can occur is when manually crafting raw
packets that will be consumed by a user space application via a tap
device. For testing purposes local traffic was generated using trafgen
for the client and netcat to start a server

Tested: Created 2 netns, sent 1 packet using trafgen from 1 to the other
with "{eth(daddr=$INCORRECT_MAC...}", verified that iproute2 showed the
counter was incremented. (Also had to modify iproute2 to show the stat,
additional patch for that coming next.)

Signed-off-by: jeffreyji <jeffreyji@google.com>
Reviewed-by: Brian Vazquez <brianvv@google.com>
---
changelog:

v3: rebase onto net-next/master, fix comments

v2: add kdoc comment

 include/linux/netdevice.h    | 3 +++
 include/uapi/linux/if_link.h | 5 +++++
 net/core/dev.c               | 2 ++
 net/ipv4/ip_input.c          | 1 +
 net/ipv6/ip6_input.c         | 1 +
 5 files changed, 12 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 29a850a8d460..43af5012b39c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1741,6 +1741,8 @@ enum netdev_ml_priv_type {
  *			do not use this in drivers
  *	@rx_nohandler:	nohandler dropped packets by core network on
  *			inactive devices, do not use this in drivers
+ *	@rx_otherhost_dropped:	Dropped packets due to mismatch in packet dest
+ *				MAC address
  *	@carrier_up_count:	Number of times the carrier has been up
  *	@carrier_down_count:	Number of times the carrier has been down
  *
@@ -2026,6 +2028,7 @@ struct net_device {
 	atomic_long_t		rx_dropped;
 	atomic_long_t		tx_dropped;
 	atomic_long_t		rx_nohandler;
+	atomic_long_t		rx_otherhost_dropped;
 
 	/* Stats to monitor link on/off, flapping */
 	atomic_t		carrier_up_count;
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index ddca20357e7e..a9681908617b 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -211,6 +211,9 @@ struct rtnl_link_stats {
  * @rx_nohandler: Number of packets received on the interface
  *   but dropped by the networking stack because the device is
  *   not designated to receive packets (e.g. backup link in a bond).
+ *
+ * @rx_otherhost_dropped: Number of packets dropped due to mismatch in
+ * packet's destination MAC address.
  */
 struct rtnl_link_stats64 {
 	__u64	rx_packets;
@@ -243,6 +246,8 @@ struct rtnl_link_stats64 {
 	__u64	rx_compressed;
 	__u64	tx_compressed;
 	__u64	rx_nohandler;
+
+	__u64	rx_otherhost_dropped;
 };
 
 /* Subset of link stats useful for in-HW collection. Meaning of the fields is as
diff --git a/net/core/dev.c b/net/core/dev.c
index ba69ddf85af6..fd7ec8ce972b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10308,6 +10308,8 @@ struct rtnl_link_stats64 *dev_get_stats(struct net_device *dev,
 	storage->rx_dropped += (unsigned long)atomic_long_read(&dev->rx_dropped);
 	storage->tx_dropped += (unsigned long)atomic_long_read(&dev->tx_dropped);
 	storage->rx_nohandler += (unsigned long)atomic_long_read(&dev->rx_nohandler);
+	storage->rx_otherhost_dropped +=
+		(unsigned long)atomic_long_read(&dev->rx_otherhost_dropped);
 	return storage;
 }
 EXPORT_SYMBOL(dev_get_stats);
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 95f7bb052784..8b87ea99904b 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -451,6 +451,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
 	 * that it receives, do not try to analyse it.
 	 */
 	if (skb->pkt_type == PACKET_OTHERHOST) {
+		atomic_long_inc(&skb->dev->rx_otherhost_dropped);
 		drop_reason = SKB_DROP_REASON_OTHERHOST;
 		goto drop;
 	}
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 5b5ea35635f9..5624c937f87f 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -150,6 +150,7 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
 	struct inet6_dev *idev;
 
 	if (skb->pkt_type == PACKET_OTHERHOST) {
+		atomic_long_inc(&skb->dev->rx_otherhost_dropped);
 		kfree_skb(skb);
 		return NULL;
 	}
-- 
2.35.1.616.g0bdcbb4464-goog

