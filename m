Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6B64571EA
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 16:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235892AbhKSPql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 10:46:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235474AbhKSPqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 10:46:39 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7B5C061574
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 07:43:37 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id np3so8205923pjb.4
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 07:43:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+iUKxmCpOtY623kjfX4N2hPc+rgVSY18iPOvMolyyP4=;
        b=a5EtRmYPyK9xUBWnPzQ6ZVMc/a/YIes09x29x1Ywi939v9UrLETy14jxRNKpSmyqgp
         aZj9nvB+ga1eAPxfolnIXCzHEA+i8TcI4xhA5NP2r6kS3yMsC6l7QVKDghfsb2lcK9SQ
         d36AqPgQLE2CtPQX3JXKBTxZFdnV7Uq5EjvvcOChkFdq4r4ii4mlSlIn6JIGSERhUyN7
         iHttpMil2Qv4Ea4EDv14UNmSqynp6UNZZIm7/rsoSQGfADKlW3qickisMbq0U7V6KGlg
         gUn5yKunN5kkx/+NSI9AOH/ld/st09pQF5jqD/1B6kB8mDrM9+WLif940a4+Qr524YWa
         Z/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+iUKxmCpOtY623kjfX4N2hPc+rgVSY18iPOvMolyyP4=;
        b=jyNhZ7W61qsoPZIxWNkFT0zT77MHMwMwvbX2STBslykQDmYBVdwg70oWHPjiBGvAu3
         Rxeh0Cf26YOg8Pwr6KZIG5Q1/7Gu24DTuCDsL5nHhQp/wpzufaRZlczDi4lS/Xo0Fl8L
         2Hpq+Ru315WWQNjH6Gs3zHDny/EXWO0hvjHawNijo5R6Jg2RSjvSeBWUxhkvsZJAMKv6
         xSvOAIxPwg2h3G2Z5SqrX3SZgcfmWtsEP6XJkE9K0xHzeeNllpisfKZZ8cac2al13ILd
         TAQKouGbHIBWV12oG5g79gXdwf024ePCuE7D6APX3G41wboHvHUwmAJjFM1HtrgCE8gk
         BTVA==
X-Gm-Message-State: AOAM5310ZhixVa5pAgsrZlwjyimb8XGejPIzMpEwKQVWMy+hywNr6M6s
        +ecDjbhH6F6S5vrKd65UZyQ=
X-Google-Smtp-Source: ABdhPJxjcox11zGmqSEEjiVcV1bpj2Vvq049DDFNo7QxJKeegtxwesbUTrxoAg2lwdME/9eWT+O1Rg==
X-Received: by 2002:a17:902:e781:b0:143:d589:1d0b with SMTP id cp1-20020a170902e78100b00143d5891d0bmr32924790plb.31.1637336617189;
        Fri, 19 Nov 2021 07:43:37 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:fc03:ed5a:3e05:8b5e])
        by smtp.gmail.com with ESMTPSA id n1sm68242pfj.193.2021.11.19.07.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 07:43:36 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/2] net: annotate accesses to dev->gso_max_size
Date:   Fri, 19 Nov 2021 07:43:31 -0800
Message-Id: <20211119154332.4110795-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
In-Reply-To: <20211119154332.4110795-1-eric.dumazet@gmail.com>
References: <20211119154332.4110795-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

dev->gso_max_size is written under RTNL protection, or when the device is
not yet visible, but is read locklessly.

Add the READ_ONCE()/WRITE_ONCE() pairs, and use netif_set_gso_max_size()
where we can to better document what is going on.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c | 2 +-
 drivers/net/ethernet/realtek/r8169_main.c         | 4 ++--
 drivers/net/ethernet/sfc/ef100_nic.c              | 2 +-
 drivers/net/ipvlan/ipvlan_main.c                  | 4 ++--
 drivers/net/macvlan.c                             | 4 ++--
 drivers/net/veth.c                                | 2 +-
 drivers/net/vxlan.c                               | 2 +-
 include/linux/netdevice.h                         | 3 ++-
 net/8021q/vlan.c                                  | 2 +-
 net/8021q/vlan_dev.c                              | 2 +-
 net/bridge/br_if.c                                | 2 +-
 net/core/sock.c                                   | 3 ++-
 net/sctp/output.c                                 | 2 +-
 13 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 369f6ae700c7d83e06cc47d847669814c4d157ea..927ddbdf650b05b6334ccfa366feab94c59ab664 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -286,7 +286,7 @@ nfp_repr_transfer_features(struct net_device *netdev, struct net_device *lower)
 	if (repr->dst->u.port_info.lower_dev != lower)
 		return;
 
-	netdev->gso_max_size = lower->gso_max_size;
+	netif_set_gso_max_size(netdev, lower->gso_max_size);
 	netdev->gso_max_segs = lower->gso_max_segs;
 
 	netdev_update_features(netdev);
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e896e5eca8048ba0a00e83d290e68069ef3e4783..5c40af2b0f818e5e89ad9b5304aa830c65cb014d 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5388,11 +5388,11 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 */
 	if (rtl_chip_supports_csum_v2(tp)) {
 		dev->hw_features |= NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6;
-		dev->gso_max_size = RTL_GSO_MAX_SIZE_V2;
+		netif_set_gso_max_size(dev, RTL_GSO_MAX_SIZE_V2);
 		dev->gso_max_segs = RTL_GSO_MAX_SEGS_V2;
 	} else {
 		dev->hw_features |= NETIF_F_SG | NETIF_F_TSO;
-		dev->gso_max_size = RTL_GSO_MAX_SIZE_V1;
+		netif_set_gso_max_size(dev, RTL_GSO_MAX_SIZE_V1);
 		dev->gso_max_segs = RTL_GSO_MAX_SEGS_V1;
 	}
 
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 6aa81229b68a9e02ff34273cbb82563fd2d3001c..d9015a77a6b8f0862519774a974592dbaea7b150 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -993,7 +993,7 @@ static int ef100_process_design_param(struct efx_nic *efx,
 		return 0;
 	case ESE_EF100_DP_GZ_TSO_MAX_PAYLOAD_LEN:
 		nic_data->tso_max_payload_len = min_t(u64, reader->value, GSO_MAX_SIZE);
-		efx->net_dev->gso_max_size = nic_data->tso_max_payload_len;
+		netif_set_gso_max_size(efx->net_dev, nic_data->tso_max_payload_len);
 		return 0;
 	case ESE_EF100_DP_GZ_TSO_MAX_PAYLOAD_NUM_SEGS:
 		nic_data->tso_max_payload_num_segs = min_t(u64, reader->value, 0xffff);
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 1d2f4e7d73245877322dbe15608f05e06b2ff6a1..0ba63eccefa5ac31fb4f8ee7f5f8a62f750ad4df 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -140,7 +140,7 @@ static int ipvlan_init(struct net_device *dev)
 	dev->vlan_features = phy_dev->vlan_features & IPVLAN_FEATURES;
 	dev->vlan_features |= IPVLAN_ALWAYS_ON_OFLOADS;
 	dev->hw_enc_features |= dev->features;
-	dev->gso_max_size = phy_dev->gso_max_size;
+	netif_set_gso_max_size(dev, phy_dev->gso_max_size);
 	dev->gso_max_segs = phy_dev->gso_max_segs;
 	dev->hard_header_len = phy_dev->hard_header_len;
 
@@ -763,7 +763,7 @@ static int ipvlan_device_event(struct notifier_block *unused,
 
 	case NETDEV_FEAT_CHANGE:
 		list_for_each_entry(ipvlan, &port->ipvlans, pnode) {
-			ipvlan->dev->gso_max_size = dev->gso_max_size;
+			netif_set_gso_max_size(ipvlan->dev, dev->gso_max_size);
 			ipvlan->dev->gso_max_segs = dev->gso_max_segs;
 			netdev_update_features(ipvlan->dev);
 		}
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index d2f830ec2969c961efeb167e2b8ed5cc7c41da74..506e9559df80d5e405e7e186aab08f5f02499f0a 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -900,7 +900,7 @@ static int macvlan_init(struct net_device *dev)
 	dev->vlan_features	= lowerdev->vlan_features & MACVLAN_FEATURES;
 	dev->vlan_features	|= ALWAYS_ON_OFFLOADS;
 	dev->hw_enc_features    |= dev->features;
-	dev->gso_max_size	= lowerdev->gso_max_size;
+	netif_set_gso_max_size(dev, lowerdev->gso_max_size);
 	dev->gso_max_segs	= lowerdev->gso_max_segs;
 	dev->hard_header_len	= lowerdev->hard_header_len;
 	macvlan_set_lockdep_class(dev);
@@ -1748,7 +1748,7 @@ static int macvlan_device_event(struct notifier_block *unused,
 		break;
 	case NETDEV_FEAT_CHANGE:
 		list_for_each_entry(vlan, &port->vlans, list) {
-			vlan->dev->gso_max_size = dev->gso_max_size;
+			netif_set_gso_max_size(vlan->dev, dev->gso_max_size);
 			vlan->dev->gso_max_segs = dev->gso_max_segs;
 			netdev_update_features(vlan->dev);
 		}
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 50eb43e5bf459bb998e264d399bc85d4e9d73594..f2f66fb293fd474bfc5b54594b33f925228b8e47 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1689,7 +1689,7 @@ static int veth_newlink(struct net *src_net, struct net_device *dev,
 	if (ifmp && (dev->ifindex != 0))
 		peer->ifindex = ifmp->ifi_index;
 
-	peer->gso_max_size = dev->gso_max_size;
+	netif_set_gso_max_size(peer, dev->gso_max_size);
 	peer->gso_max_segs = dev->gso_max_segs;
 
 	err = register_netdevice(peer);
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 563f86de0e0dce0ab994b5d8ec7cf59133c8dd38..df4f1712be9529aba9372515dc27beac93fd83b4 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3811,7 +3811,7 @@ static void vxlan_config_apply(struct net_device *dev,
 	if (lowerdev) {
 		dst->remote_ifindex = conf->remote_ifindex;
 
-		dev->gso_max_size = lowerdev->gso_max_size;
+		netif_set_gso_max_size(dev, lowerdev->gso_max_size);
 		dev->gso_max_segs = lowerdev->gso_max_segs;
 
 		needed_headroom = lowerdev->hard_header_len;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 4f4a299e92de7ba9f61507ad4df7e334775c07a6..19011318d3cd5e40343761a5699ef64623134688 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4730,7 +4730,8 @@ static inline bool netif_needs_gso(struct sk_buff *skb,
 static inline void netif_set_gso_max_size(struct net_device *dev,
 					  unsigned int size)
 {
-	dev->gso_max_size = size;
+	/* dev->gso_max_size is read locklessly from sk_setup_caps() */
+	WRITE_ONCE(dev->gso_max_size, size);
 }
 
 static inline void skb_gso_error_unwind(struct sk_buff *skb, __be16 protocol,
diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index a3a0a5e994f5aeae550404701e72253a7e38a991..34c0ffa81e5f163a620a48121baeb7b68bc3721a 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -322,7 +322,7 @@ static void vlan_transfer_features(struct net_device *dev,
 {
 	struct vlan_dev_priv *vlan = vlan_dev_priv(vlandev);
 
-	vlandev->gso_max_size = dev->gso_max_size;
+	netif_set_gso_max_size(vlandev, dev->gso_max_size);
 	vlandev->gso_max_segs = dev->gso_max_segs;
 
 	if (vlan_hw_offload_capable(dev->features, vlan->vlan_proto))
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index ab6dee28536daaaf825dfc22120ca111c6197f4b..208f6845f6dd59f1f67e202e5401370d020cba2d 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -573,7 +573,7 @@ static int vlan_dev_init(struct net_device *dev)
 			   NETIF_F_ALL_FCOE;
 
 	dev->features |= dev->hw_features | NETIF_F_LLTX;
-	dev->gso_max_size = real_dev->gso_max_size;
+	netif_set_gso_max_size(dev, real_dev->gso_max_size);
 	dev->gso_max_segs = real_dev->gso_max_segs;
 	if (dev->features & NETIF_F_VLAN_FEATURES)
 		netdev_warn(real_dev, "VLAN features are set incorrectly.  Q-in-Q configurations may not work correctly.\n");
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 64b2d4fb50f558bdd91d150eef425c14f7888054..d3e1c2276551c27bf9f0f19121cb6ef7b6869b0a 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -525,7 +525,7 @@ static void br_set_gso_limits(struct net_bridge *br)
 		gso_max_size = min(gso_max_size, p->dev->gso_max_size);
 		gso_max_segs = min(gso_max_segs, p->dev->gso_max_segs);
 	}
-	br->dev->gso_max_size = gso_max_size;
+	netif_set_gso_max_size(br->dev, gso_max_size);
 	br->dev->gso_max_segs = gso_max_segs;
 }
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 1f9be266e58661027a3e87a8135467a102587a79..4418e2a07c3412535413b94f11480ff6da7f3df3 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2257,7 +2257,8 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 			sk->sk_route_caps &= ~NETIF_F_GSO_MASK;
 		} else {
 			sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
-			sk->sk_gso_max_size = dst->dev->gso_max_size;
+			/* pairs with the WRITE_ONCE() in netif_set_gso_max_size() */
+			sk->sk_gso_max_size = READ_ONCE(dst->dev->gso_max_size);
 			max_segs = max_t(u32, dst->dev->gso_max_segs, 1);
 		}
 	}
diff --git a/net/sctp/output.c b/net/sctp/output.c
index cdfdbd353c6786a095d04acfd078e3a093163c36..72fe6669c50de2c76842cf50d039b65a61943bd8 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -134,7 +134,7 @@ void sctp_packet_config(struct sctp_packet *packet, __u32 vtag,
 		dst_hold(tp->dst);
 		sk_setup_caps(sk, tp->dst);
 	}
-	packet->max_size = sk_can_gso(sk) ? tp->dst->dev->gso_max_size
+	packet->max_size = sk_can_gso(sk) ? READ_ONCE(tp->dst->dev->gso_max_size)
 					  : asoc->pathmtu;
 	rcu_read_unlock();
 }
-- 
2.34.0.rc2.393.gf8c9666880-goog

