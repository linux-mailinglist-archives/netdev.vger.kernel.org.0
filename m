Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21D3621859
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 16:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbiKHPe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 10:34:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234458AbiKHPeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 10:34:11 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4FF7C10;
        Tue,  8 Nov 2022 07:34:07 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id d13-20020a17090a3b0d00b00213519dfe4aso13690988pjc.2;
        Tue, 08 Nov 2022 07:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sq7nQSeZwz/SG/0+I1b0nFfCS6qt1ZM+1bF9ld2dvUk=;
        b=RzhS/EH/VY7dALV8DM2Vm2FpL0UQSijqnixEi5yrMFGYxf/LpTeH2s6V91Gok5gxJj
         slkw60ZQ/0h82Dh82FhamiXPhcXaK0cMp9ETRiDtXrOeAJoM0fdkJ3h4iq934oj+4COt
         2iFEtJcxdWTTcMWUlBWHhSv/8twHIfwbS81YOPKKtdc0v0To0o6j77a7avreudWZVYRg
         pUHBAG0y2cWS3H2XMyoX9fAPk8zI/7XqH7/qCDKYWE+btzS38+rfWPEL82BMXYtGk6BE
         cBCLBp6i3LG2QzGhZ3g8kb5GAl/cAX7rvqaZr4MBj8ohKOktDBbUJy6PphaS86nadJZ5
         Dheg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sq7nQSeZwz/SG/0+I1b0nFfCS6qt1ZM+1bF9ld2dvUk=;
        b=FZy8FjyilHaMMeBgkuJNRsJ+DgYYiMNNmhhcT48dRB9WoFx3Va+fOPY8xDEYDyYzOe
         THNdpNlj7VnmeLij4Otwz//JWyl4I+qKVUQ4hjWedgJan3XIptP3gnNnxggrNCL+F3UT
         bXxJG4bwvOgECJl+rIFnHXv4dkX7vqWNnLYRY5C5Z/Ga6RbHiJZSNd88vmMALbFYLVeT
         fCLPFBcEDNZ3HkETJJlQUp+RaYGKsNIKqZfRsVtbSQ4fizmhQuz/833hHJyQ0fEKkvGu
         cR/qKzcaNQxPyMYAnlY6FGxDRQKvY1NeEgNSs2ziq0VoE3y6+bMZx+3j4qzCJTeJ+aIz
         iTqA==
X-Gm-Message-State: ACrzQf1zfSft6WlKQFWINEEFS5BoP/SjZC1Z78+53B65zrXhdSzOXoMv
        Sr8n+wuLiThUOdc5w4kmaeBpcK+qcBKx9Q==
X-Google-Smtp-Source: AMsMyM5TjM1I49I+f3E0l+X5+bxvr708EPFXy93CK+CJaNsaQjoyYmB6fzprDAfDQygqCoPGpg9UNg==
X-Received: by 2002:a17:90a:b011:b0:213:473e:6fe1 with SMTP id x17-20020a17090ab01100b00213473e6fe1mr58402322pjq.229.1667921646876;
        Tue, 08 Nov 2022 07:34:06 -0800 (PST)
Received: from localhost.localdomain ([203.158.52.158])
        by smtp.gmail.com with ESMTPSA id w10-20020a17090a460a00b00213202d77d9sm6243412pjg.43.2022.11.08.07.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 07:34:06 -0800 (PST)
From:   Albert Zhou <albert.zhou.50@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, nic_swsd@realtek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH net-next RFC 3/5] r8152: remove backwards compatibility
Date:   Wed,  9 Nov 2022 02:33:40 +1100
Message-Id: <20221108153342.18979-4-albert.zhou.50@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221108153342.18979-1-albert.zhou.50@gmail.com>
References: <20221108153342.18979-1-albert.zhou.50@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Code not used for kernel v6.1 is removed, i.e. code for earlier kernel
versions, denoted by #if LINUX_VERSION_CODE < KERNEL_VERSION(...), has
been deleted, as required by scripts/checkpatch.pl.

Since the driver source has undergone significant changes from its
original, I also deleted my comment in r8152.c, indicating where I
amended netif_napi_add from the original.

Signed-off-by: Albert Zhou <albert.zhou.50@gmail.com>
---
 drivers/net/usb/r8152.c               | 669 +-------------------------
 drivers/net/usb/r8152_compatibility.h | 601 +----------------------
 2 files changed, 8 insertions(+), 1262 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index cda0f4ed2a90..85a3b2a7e83b 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -914,13 +914,7 @@ struct r8152 {
 	struct delayed_work schedule, hw_phy_work;
 	struct mii_if_info mii;
 	struct mutex control;	/* use for hw setting */
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0)
-	struct vlan_group *vlgrp;
-#endif
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22)
-	struct net_device_stats stats;
-#endif
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23) && defined(CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM_SLEEP)
 	struct notifier_block pm_notifier;
 #endif
 #if defined(RTL8152_S5_WOL) && defined(CONFIG_PM)
@@ -935,10 +929,8 @@ struct r8152 {
 		void (*up)(struct r8152 *tp);
 		void (*down)(struct r8152 *tp);
 		void (*unload)(struct r8152 *tp);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
 		int (*eee_get)(struct r8152 *tp, struct ethtool_eee *eee);
 		int (*eee_set)(struct r8152 *tp, struct ethtool_eee *eee);
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0) */
 		bool (*in_nway)(struct r8152 *tp);
 		void (*hw_phy_cfg)(struct r8152 *tp);
 		void (*autosuspend_en)(struct r8152 *tp, bool enable);
@@ -1631,13 +1623,7 @@ static int set_ethernet_addr(struct r8152 *tp, bool in_resume)
 
 static inline struct net_device_stats *rtl8152_get_stats(struct net_device *dev)
 {
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22)
-	struct rtl8152 *tp = netdev_priv(dev);
-
-	return (struct net_device_stats *)&tp->stats;
-#else
 	return &dev->stats;
-#endif
 }
 
 static void read_bulk_callback(struct urb *urb)
@@ -2115,62 +2101,15 @@ static inline void rtl_tx_vlan_tag(struct tx_desc *desc, struct sk_buff *skb)
 	}
 }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0)
-
-static inline bool
-rtl_rx_vlan_tag(struct r8152 *tp, struct rx_desc *desc, struct sk_buff *skb)
-{
-	u32 opts2 = le32_to_cpu(desc->opts2);
-
-	if (tp->vlgrp && (opts2 & RX_VLAN_TAG)) {
-		vlan_gro_receive(&tp->napi, tp->vlgrp, swab16(opts2 & 0xffff),
-				 skb);
-		return true;
-	}
-
-	return false;
-}
-
-static inline void
-rtl_vlan_put_tag(struct r8152 *tp, struct rx_desc *desc, struct sk_buff *skb)
-{
-	u32 opts2 = le32_to_cpu(desc->opts2);
-
-	if (tp->vlgrp && (opts2 & RX_VLAN_TAG))
-		__vlan_hwaccel_put_tag(skb, swab16(opts2 & 0xffff));
-}
-
-static inline __u16
-rtl_vlan_get_tag(struct sk_buff *skb)
-{
-	__u16 tag;
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)
-	__vlan_hwaccel_get_tag(skb, &tag);
-#else
-	tag = skb->vlan_tci;
-#endif
-
-	return tag;
-}
-
-#else
-
 static inline void rtl_rx_vlan_tag(struct rx_desc *desc, struct sk_buff *skb)
 {
 	u32 opts2 = le32_to_cpu(desc->opts2);
 
 	if (opts2 & RX_VLAN_TAG)
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,10,0)
-		__vlan_hwaccel_put_tag(skb, swab16(opts2 & 0xffff));
-#else
 		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 				       swab16(opts2 & 0xffff));
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,10,0) */
 }
 
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0) */
-
 static int r8152_tx_csum(struct r8152 *tp, struct tx_desc *desc,
 			 struct sk_buff *skb, u32 len, u32 transport_offset)
 {
@@ -2581,32 +2520,16 @@ static int rx_bottom(struct r8152 *tp, int budget)
 			struct net_device *netdev = tp->netdev;
 			struct net_device_stats *stats;
 			unsigned int pkt_len;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0)
-			u16 vlan_tci;
-#endif
 
 			if (!skb)
 				break;
 
 			pkt_len = skb->len;
 			stats = rtl8152_get_stats(netdev);
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0)
-			vlan_tci = rtl_vlan_get_tag(skb);
-
-			if (vlan_tci)
-				vlan_gro_receive(napi, tp->vlgrp, vlan_tci,
-						 skb);
-			else
-				napi_gro_receive(napi, skb);
-#else
 			napi_gro_receive(napi, skb);
-#endif
 
 			work_done++;
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)
-			netdev->last_rx = jiffies;
-#endif
 			stats->rx_packets++;
 			stats->rx_bytes += pkt_len;
 		}
@@ -2688,26 +2611,8 @@ static int rx_bottom(struct r8152 *tp, int budget)
 				get_page(agg->page);
 			}
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22)
-			skb->dev = netdev;
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22) */
 			skb->protocol = eth_type_trans(skb, netdev);
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0)
-			if (work_done < budget) {
-				if (!rtl_rx_vlan_tag(tp, rx_desc, skb))
-					napi_gro_receive(napi, skb);
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)
-				netdev->last_rx = jiffies;
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29) */
-				work_done++;
-				stats->rx_packets++;
-				stats->rx_bytes += skb->len;
-			} else {
-				rtl_vlan_put_tag(tp, rx_desc, skb);
-				__skb_queue_tail(&tp->rx_queue, skb);
-			}
-#else
 			rtl_rx_vlan_tag(rx_desc, skb);
 			if (work_done < budget) {
 				work_done++;
@@ -2717,7 +2622,6 @@ static int rx_bottom(struct r8152 *tp, int budget)
 			} else {
 				__skb_queue_tail(&tp->rx_queue, skb);
 			}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0) */
 
 find_next_rx:
 			rx_data = rx_agg_align(rx_data + pkt_len + ETH_FCS_LEN);
@@ -2800,11 +2704,7 @@ static void tx_bottom(struct r8152 *tp)
 	} while (res == 0);
 }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(5,9,0)
-static void bottom_half(unsigned long t)
-#else
 static void bottom_half(struct tasklet_struct *t)
-#endif
 {
 	struct r8152 *tp = from_tasklet(tp, t, tx_tl);
 
@@ -2832,40 +2732,16 @@ static inline int __r8152_poll(struct r8152 *tp, int budget)
 	work_done = rx_bottom(tp, budget);
 
 	if (work_done < budget) {
-#if LINUX_VERSION_CODE < KERNEL_VERSION(4,10,0)
-		napi_complete_done(napi, work_done);
-#else
 		if (!napi_complete_done(napi, work_done))
 			goto out;
-#endif
 		if (!list_empty(&tp->rx_done))
 			napi_schedule(napi);
 	}
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,10,0)
 out:
-#endif
 	return work_done;
 }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24)
-
-static int r8152_poll(struct net_device *dev, int *budget)
-{
-	struct r8152 *tp = netdev_priv(dev);
-	int quota = min(dev->quota, *budget);
-	int work_done;
-
-	work_done = __r8152_poll(tp, quota);
-
-	*budget -= work_done;
-	dev->quota -= work_done;
-
-	return (work_done >= quota);
-}
-
-#else
-
 static int r8152_poll(struct napi_struct *napi, int budget)
 {
 	struct r8152 *tp = container_of(napi, struct r8152, napi);
@@ -2873,8 +2749,6 @@ static int r8152_poll(struct napi_struct *napi, int budget)
 	return __r8152_poll(tp, budget);
 }
 
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24) */
-
 static
 int r8152_submit_rx(struct r8152 *tp, struct rx_agg *agg, gfp_t mem_flags)
 {
@@ -2931,25 +2805,13 @@ static void rtl_drop_queued_tx(struct r8152 *tp)
 	}
 }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(5,6,0)
-static void rtl8152_tx_timeout(struct net_device *netdev)
-#else
 static void rtl8152_tx_timeout(struct net_device *netdev, unsigned int txqueue)
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,6,0) */
 {
 	struct r8152 *tp = netdev_priv(netdev);
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)
-	int i;
-#endif
 
 	netif_warn(tp, tx_err, netdev, "Tx timeout\n");
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)
-	for (i = 0; i < RTL8152_MAX_TX; i++)
-		usb_unlink_urb(tp->tx_info[i].urb);
-#else
 	usb_queue_reset_device(tp->intf);
-#endif
 }
 
 static void rtl8152_set_rx_mode(struct net_device *netdev)
@@ -2990,21 +2852,6 @@ static void rtl8152_set_rx_mode(struct net_device *netdev)
 		mc_filter[1] = 0xffffffff;
 		mc_filter[0] = 0xffffffff;
 	} else {
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)
-		struct dev_mc_list *mclist;
-		unsigned int i;
-
-		mc_filter[1] = mc_filter[0] = 0;
-		for (i = 0, mclist = netdev->mc_list;
-		     mclist && i < netdev->mc_count;
-		     i++, mclist = mclist->next) {
-			int bit_nr;
-
-			bit_nr = ether_crc(ETH_ALEN, mclist->dmi_addr) >> 26;
-			mc_filter[bit_nr >> 5] |= 1 << (bit_nr & 31);
-			ocp_data |= RCR_AM;
-		}
-#else
 		struct netdev_hw_addr *ha;
 
 		mc_filter[1] = 0;
@@ -3015,7 +2862,6 @@ static void rtl8152_set_rx_mode(struct net_device *netdev)
 			mc_filter[bit_nr >> 5] |= 1 << (bit_nr & 31);
 			ocp_data |= RCR_AM;
 		}
-#endif
 	}
 
 	tmp[0] = __cpu_to_le32(swab32(mc_filter[1]));
@@ -3038,8 +2884,6 @@ static inline bool rtl_gso_check(struct net_device *dev, struct sk_buff *skb)
 		return false;
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,18,4)
-
 static netdev_features_t
 rtl8152_features_check(struct sk_buff *skb, struct net_device *dev,
 		       netdev_features_t features)
@@ -3055,40 +2899,12 @@ rtl8152_features_check(struct sk_buff *skb, struct net_device *dev,
 
 	return features;
 }
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,18,4) */
 
 static netdev_tx_t rtl8152_start_xmit(struct sk_buff *skb,
 				      struct net_device *netdev)
 {
 	struct r8152 *tp = netdev_priv(netdev);
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,18,4)
-	if (unlikely(!rtl_gso_check(netdev, skb))) {
-		netdev_features_t features = netdev->features;
-		struct sk_buff *segs, *nskb;
-
-		features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
-		segs = skb_gso_segment(skb, features);
-		if (IS_ERR(segs) || !segs)
-			goto free_skb;
-
-		do {
-			nskb = segs;
-			segs = segs->next;
-			nskb->next = NULL;
-			rtl8152_start_xmit(nskb, netdev);
-		} while (segs);
-
-free_skb:
-		dev_kfree_skb_any(skb);
-
-		return NETDEV_TX_OK;
-	}
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
-	netdev->trans_start = jiffies
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,18,4) */
-
 	skb_tx_timestamp(skb);
 
 	skb_queue_tail(&tp->tx_queue, skb);
@@ -3560,43 +3376,6 @@ static void rtl_rx_vlan_en(struct r8152 *tp, bool enable)
 	}
 }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0)
-
-static void
-rtl8152_vlan_rx_register(struct net_device *dev, struct vlan_group *grp)
-{
-	struct r8152 *tp = netdev_priv(dev);
-
-	if (unlikely(tp->rtk_enable_diag))
-		return;
-
-	if (usb_autopm_get_interface(tp->intf) < 0)
-		return;
-
-	mutex_lock(&tp->control);
-
-	tp->vlgrp = grp;
-	if (tp->vlgrp)
-		rtl_rx_vlan_en(tp, true);
-	else
-		rtl_rx_vlan_en(tp, false);
-
-	mutex_unlock(&tp->control);
-}
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22)
-
-static void rtl8152_vlan_rx_kill_vid(struct net_device *dev, unsigned short vid)
-{
-	struct r8152 *tp = netdev_priv(dev);
-
-	vlan_group_set_device(tp->vlgrp, vid, NULL);
-}
-
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22) */
-
-#else
-
 static int rtl8152_set_features(struct net_device *dev,
 				netdev_features_t features)
 {
@@ -3628,8 +3407,6 @@ static int rtl8152_set_features(struct net_device *dev,
 	return ret;
 }
 
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0) */
-
 #define WAKE_ANY (WAKE_PHY | WAKE_MAGIC | WAKE_UCAST | WAKE_BCAST | WAKE_MCAST)
 
 static u32 __rtl_get_wol(struct r8152 *tp)
@@ -5214,7 +4991,6 @@ static inline void r8152_mmd_indirect(struct r8152 *tp, u16 dev, u16 reg)
 	ocp_reg_write(tp, OCP_EEE_AR, FUN_DATA | dev);
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
 static u16 r8152_mmd_read(struct r8152 *tp, u16 dev, u16 reg)
 {
 	u16 data;
@@ -5225,7 +5001,6 @@ static u16 r8152_mmd_read(struct r8152 *tp, u16 dev, u16 reg)
 
 	return data;
 }
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0) */
 
 static void r8152_mmd_write(struct r8152 *tp, u16 dev, u16 reg, u16 data)
 {
@@ -9818,24 +9593,6 @@ static inline void __rtl_hw_phy_work_func(struct r8152 *tp)
 	usb_autopm_put_interface(tp->intf);
 }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-
-static void rtl_work_func_t(void *data)
-{
-	struct r8152 *tp = (struct r8152 *)data;
-
-	__rtl_work_func(tp);
-}
-
-static void rtl_hw_phy_work_func_t(void *data)
-{
-	struct r8152 *tp = (struct r8152 *)data;
-
-	__rtl_hw_phy_work_func(tp);
-}
-
-#else
-
 static void rtl_work_func_t(struct work_struct *work)
 {
 	struct r8152 *tp = container_of(work, struct r8152, schedule.work);
@@ -9850,9 +9607,7 @@ static void rtl_hw_phy_work_func_t(struct work_struct *work)
 	__rtl_hw_phy_work_func(tp);
 }
 
-#endif
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23) && defined(CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM_SLEEP)
 static int rtl_notifier(struct notifier_block *nb, unsigned long action,
 			void *data)
 {
@@ -9878,7 +9633,7 @@ static int rtl_notifier(struct notifier_block *nb, unsigned long action,
 
 	return NOTIFY_DONE;
 }
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23) && defined(CONFIG_PM_SLEEP) */
+#endif /* defined(CONFIG_PM_SLEEP) */
 
 #if defined(RTL8152_S5_WOL) && defined(CONFIG_PM)
 static int rtl_s5_wol(struct r8152 *tp)
@@ -10030,7 +9785,7 @@ static int rtl8152_open(struct net_device *netdev)
 	mutex_unlock(&tp->control);
 
 	usb_autopm_put_interface(tp->intf);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23) && defined(CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM_SLEEP)
 	tp->pm_notifier.notifier_call = rtl_notifier;
 	register_pm_notifier(&tp->pm_notifier);
 #endif
@@ -10057,7 +9812,7 @@ static int rtl8152_close(struct net_device *netdev)
 #if defined(RTL8152_S5_WOL) && defined(CONFIG_PM)
 	unregister_reboot_notifier(&tp->reboot_notifier);
 #endif /* defined(RTL8152_S5_WOL) && defined(CONFIG_PM) */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23) && defined(CONFIG_PM_SLEEP)
+#if defined(CONFIG_PM_SLEEP)
 	unregister_pm_notifier(&tp->pm_notifier);
 #endif
 	tasklet_disable(&tp->tx_tl);
@@ -10320,9 +10075,7 @@ static void r8153_init(struct r8152 *tp)
 
 	switch (tp->udev->speed) {
 	case USB_SPEED_SUPER:
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,6,0)
 	case USB_SPEED_SUPER_PLUS:
-#endif
 		tp->coalesce = COALESCE_SUPER;
 		break;
 	case USB_SPEED_HIGH:
@@ -17738,64 +17491,6 @@ static void r8156b_init(struct r8152 *tp)
 static bool rtl_check_vendor_ok(struct usb_interface *intf)
 {
 	struct usb_host_interface *alt = intf->cur_altsetting;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(4,12,0)
-	struct usb_host_endpoint *in = NULL, *out = NULL, *intr = NULL;
-	unsigned int ep;
-
-	if (alt->desc.bNumEndpoints < 3) {
-		dev_err(&intf->dev, "Unexpected bNumEndpoints %d\n", alt->desc.bNumEndpoints);
-		return false;
-	}
-
-	for (ep = 0; ep < alt->desc.bNumEndpoints; ep++) {
-		struct usb_host_endpoint *e;
-
-		e = alt->endpoint + ep;
-
-		/* ignore endpoints which cannot transfer data */
-		if (!usb_endpoint_maxp(&e->desc))
-			continue;
-
-		switch (e->desc.bmAttributes) {
-		case USB_ENDPOINT_XFER_INT:
-			if (!usb_endpoint_dir_in(&e->desc))
-				continue;
-			if (!intr)
-				intr = e;
-			break;
-		case USB_ENDPOINT_XFER_BULK:
-			if (usb_endpoint_dir_in(&e->desc)) {
-				if (!in)
-					in = e;
-			} else if (!out) {
-				out = e;
-			}
-			break;
-		default:
-			continue;
-		}
-	}
-
-	if (!in || !out || !intr) {
-		dev_err(&intf->dev, "Miss Endpoints\n");
-		return false;
-	}
-
-	if ((in->desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MASK) != 1) {
-		dev_err(&intf->dev, "Invalid Rx endpoint address\n");
-		return false;
-	}
-
-	if ((out->desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MASK) != 2) {
-		dev_err(&intf->dev, "Invalid Tx endpoint address\n");
-		return false;
-	}
-
-	if ((intr->desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MASK) != 3) {
-		dev_err(&intf->dev, "Invalid interrupt endpoint address\n");
-		return false;
-	}
-#else
 	struct usb_endpoint_descriptor *in, *out, *intr;
 
 	if (usb_find_common_endpoints(alt, &in, &out, &intr, NULL) < 0) {
@@ -17820,7 +17515,6 @@ static bool rtl_check_vendor_ok(struct usb_interface *intf)
 		dev_err(&intf->dev, "Invalid interrupt endpoint address\n");
 		return false;
 	}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,12,0) */
 
 	return true;
 }
@@ -17835,9 +17529,6 @@ static bool rtl_vendor_mode(struct usb_interface *intf)
 	if (alt->desc.bInterfaceClass == USB_CLASS_VENDOR_SPEC)
 		return rtl_check_vendor_ok(intf);
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
-	dev_err(&intf->dev, "The kernel is too old to set configuration\n");
-#else
 	/* The vendor mode is not always config #1, so to find it out. */
 	udev = interface_to_usbdev(intf);
 	c = udev->config;
@@ -17861,7 +17552,6 @@ static bool rtl_vendor_mode(struct usb_interface *intf)
 
 	if (i == num_configs)
 		dev_err(&intf->dev, "Unexpected Device\n");
-#endif
 
 	return false;
 }
@@ -17907,11 +17597,7 @@ static int rtl8152_post_reset(struct usb_interface *intf)
 	/* reset the MAC address in case of policy change */
 	if (determine_ethernet_addr(tp, &sa) >= 0) {
 		rtnl_lock();
-#if LINUX_VERSION_CODE < KERNEL_VERSION(5,0,0)
-		dev_set_mac_address(tp->netdev, &sa);
-#else
 		dev_set_mac_address(tp->netdev, &sa, NULL);
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,0,0) */
 		rtnl_unlock();
 	}
 
@@ -18240,184 +17926,6 @@ static void rtl8152_get_drvinfo(struct net_device *netdev,
 	usb_make_path(tp->udev, info->bus_info, sizeof(info->bus_info));
 }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(4,20,0)
-static
-int rtl8152_get_settings(struct net_device *netdev, struct ethtool_cmd *cmd)
-{
-	struct r8152 *tp = netdev_priv(netdev);
-	u16 bmcr, bmsr;
-	int ret, advert;
-
-	ret = usb_autopm_get_interface(tp->intf);
-	if (ret < 0)
-		goto out;
-
-	cmd->supported =
-	    (SUPPORTED_10baseT_Half | SUPPORTED_10baseT_Full |
-	     SUPPORTED_100baseT_Half | SUPPORTED_100baseT_Full |
-	     SUPPORTED_Autoneg | SUPPORTED_MII);
-
-	/* only supports twisted-pair */
-	cmd->port = PORT_MII;
-
-	/* only supports internal transceiver */
-	cmd->transceiver = XCVR_INTERNAL;
-	cmd->phy_address = 32;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31)
-	cmd->mdio_support = ETH_MDIO_SUPPORTS_C22;
-#endif
-	cmd->advertising = ADVERTISED_MII;
-
-	mutex_lock(&tp->control);
-
-	bmcr = r8152_mdio_read(tp, MII_BMCR);
-	bmsr = r8152_mdio_read(tp, MII_BMSR);
-
-	advert = r8152_mdio_read(tp, MII_ADVERTISE);
-	if (advert & ADVERTISE_10HALF)
-		cmd->advertising |= ADVERTISED_10baseT_Half;
-	if (advert & ADVERTISE_10FULL)
-		cmd->advertising |= ADVERTISED_10baseT_Full;
-	if (advert & ADVERTISE_100HALF)
-		cmd->advertising |= ADVERTISED_100baseT_Half;
-	if (advert & ADVERTISE_100FULL)
-		cmd->advertising |= ADVERTISED_100baseT_Full;
-	if (advert & ADVERTISE_PAUSE_CAP)
-		cmd->advertising |= ADVERTISED_Pause;
-	if (advert & ADVERTISE_PAUSE_ASYM)
-		cmd->advertising |= ADVERTISED_Asym_Pause;
-	if (tp->mii.supports_gmii) {
-		u16 ctrl1000 = r8152_mdio_read(tp, MII_CTRL1000);
-
-		cmd->supported |= SUPPORTED_1000baseT_Full;
-
-		if (tp->support_2500full) {
-			u16 data = ocp_reg_read(tp, 0xa5d4);
-
-			cmd->supported |= SUPPORTED_2500baseX_Full;
-			if (data & BIT(7))
-				cmd->advertising |= ADVERTISED_2500baseX_Full;
-		}
-
-		if (ctrl1000 & ADVERTISE_1000HALF)
-			cmd->advertising |= ADVERTISED_1000baseT_Half;
-		if (ctrl1000 & ADVERTISE_1000FULL)
-			cmd->advertising |= ADVERTISED_1000baseT_Full;
-	}
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31)
-	if (bmsr & BMSR_ANEGCOMPLETE) {
-		advert = r8152_mdio_read(tp, MII_LPA);
-		if (advert & LPA_LPACK)
-			cmd->lp_advertising |= ADVERTISED_Autoneg;
-		if (advert & ADVERTISE_10HALF)
-			cmd->lp_advertising |=
-				ADVERTISED_10baseT_Half;
-		if (advert & ADVERTISE_10FULL)
-			cmd->lp_advertising |=
-				ADVERTISED_10baseT_Full;
-		if (advert & ADVERTISE_100HALF)
-			cmd->lp_advertising |=
-				ADVERTISED_100baseT_Half;
-		if (advert & ADVERTISE_100FULL)
-			cmd->lp_advertising |=
-				ADVERTISED_100baseT_Full;
-
-		if (tp->mii.supports_gmii) {
-			u16 stat1000 = r8152_mdio_read(tp, MII_STAT1000);
-
-			if (stat1000 & LPA_1000HALF)
-				cmd->lp_advertising |=
-					ADVERTISED_1000baseT_Half;
-			if (stat1000 & LPA_1000FULL)
-				cmd->lp_advertising |=
-					ADVERTISED_1000baseT_Full;
-		}
-	} else {
-		cmd->lp_advertising = 0;
-	}
-#endif
-
-	if (bmcr & BMCR_ANENABLE) {
-		cmd->advertising |= ADVERTISED_Autoneg;
-		cmd->autoneg = AUTONEG_ENABLE;
-	} else {
-		cmd->autoneg = AUTONEG_DISABLE;
-	}
-
-
-	if (netif_running(netdev) && netif_carrier_ok(netdev)) {
-		u16 speed = rtl8152_get_speed(tp);
-
-		if (speed & _100bps)
-			cmd->speed = SPEED_100;
-		else if (speed & _10bps)
-			cmd->speed = SPEED_10;
-		else if (tp->mii.supports_gmii && (speed & _1000bps))
-			cmd->speed = SPEED_1000;
-		else if (tp->support_2500full && (speed & _2500bps))
-			cmd->speed = SPEED_2500;
-
-		cmd->duplex = (speed & FULL_DUP) ? DUPLEX_FULL : DUPLEX_HALF;
-	} else {
-		cmd->speed = SPEED_UNKNOWN;
-		cmd->duplex = DUPLEX_UNKNOWN;
-	}
-
-	mutex_unlock(&tp->control);
-
-	usb_autopm_put_interface(tp->intf);
-
-out:
-	return ret;
-}
-
-static int rtl8152_set_settings(struct net_device *dev, struct ethtool_cmd *cmd)
-{
-	struct r8152 *tp = netdev_priv(dev);
-	u32 advertising = 0;
-	int ret;
-
-	ret = usb_autopm_get_interface(tp->intf);
-	if (ret < 0)
-		goto out;
-
-	if (cmd->advertising & ADVERTISED_10baseT_Half)
-		advertising |= RTL_ADVERTISED_10_HALF;
-	if (cmd->advertising & ADVERTISED_10baseT_Full)
-		advertising |= RTL_ADVERTISED_10_FULL;
-	if (cmd->advertising & ADVERTISED_100baseT_Half)
-		advertising |= RTL_ADVERTISED_100_HALF;
-	if (cmd->advertising & ADVERTISED_100baseT_Full)
-		advertising |= RTL_ADVERTISED_100_FULL;
-	if (cmd->advertising & ADVERTISED_1000baseT_Half)
-		advertising |= RTL_ADVERTISED_1000_HALF;
-	if (cmd->advertising & ADVERTISED_1000baseT_Full)
-		advertising |= RTL_ADVERTISED_1000_FULL;
-	if (cmd->advertising & ADVERTISED_2500baseX_Full)
-		advertising |= RTL_ADVERTISED_2500_FULL;
-
-	mutex_lock(&tp->control);
-
-	ret = rtl8152_set_speed(tp, cmd->autoneg, cmd->speed, cmd->duplex,
-				advertising);
-	if (!ret) {
-		tp->autoneg = cmd->autoneg;
-		tp->speed = cmd->speed;
-		tp->duplex = cmd->duplex;
-		tp->advertising = advertising;
-	}
-
-	mutex_unlock(&tp->control);
-
-	usb_autopm_put_interface(tp->intf);
-
-out:
-	return ret;
-}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,20,0) */
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,6,0)
 static int rtl8152_get_link_ksettings(struct net_device *netdev,
 				      struct ethtool_link_ksettings *cmd)
 {
@@ -18628,7 +18136,6 @@ static int rtl8152_set_link_ksettings(struct net_device *dev,
 out:
 	return ret;
 }
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(4,6,0) */
 
 static const char rtl8152_gstrings[][ETH_GSTRING_LEN] = {
 	"tx_packets",
@@ -18646,12 +18153,6 @@ static const char rtl8152_gstrings[][ETH_GSTRING_LEN] = {
 	"tx_underrun",
 };
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
-static int rtl8152_get_sset_count(struct net_device *dev)
-{
-	return ARRAY_SIZE(rtl8152_gstrings);
-}
-#else
 static int rtl8152_get_sset_count(struct net_device *dev, int sset)
 {
 	switch (sset) {
@@ -18661,7 +18162,6 @@ static int rtl8152_get_sset_count(struct net_device *dev, int sset)
 		return -EOPNOTSUPP;
 	}
 }
-#endif
 
 static void rtl8152_get_ethtool_stats(struct net_device *dev,
 				      struct ethtool_stats *stats, u64 *data)
@@ -18707,7 +18207,6 @@ static void rtl8152_get_strings(struct net_device *dev, u32 stringset, u8 *data)
 	}
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
 static int r8152_get_eee(struct r8152 *tp, struct ethtool_eee *eee)
 {
 	u32 lp, adv, supported = 0;
@@ -18821,7 +18320,6 @@ rtl_ethtool_set_eee(struct net_device *net, struct ethtool_eee *edata)
 out:
 	return ret;
 }
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0) */
 
 static int rtl8152_nway_reset(struct net_device *dev)
 {
@@ -18845,13 +18343,9 @@ static int rtl8152_nway_reset(struct net_device *dev)
 }
 
 static int rtl8152_get_coalesce(struct net_device *netdev,
-#if LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0)
-				struct ethtool_coalesce *coalesce)
-#else
 				struct ethtool_coalesce *coalesce,
 				struct kernel_ethtool_coalesce *kernel_coal,
 				struct netlink_ext_ack *extack)
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0) */
 {
 	struct r8152 *tp = netdev_priv(netdev);
 
@@ -18870,13 +18364,9 @@ static int rtl8152_get_coalesce(struct net_device *netdev,
 }
 
 static int rtl8152_set_coalesce(struct net_device *netdev,
-#if LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0)
-				struct ethtool_coalesce *coalesce)
-#else
 				struct ethtool_coalesce *coalesce,
 				struct kernel_ethtool_coalesce *kernel_coal,
 				struct netlink_ext_ack *extack)
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0) */
 {
 	struct r8152 *tp = netdev_priv(netdev);
 	u32 rx_coalesce_nsecs;
@@ -18935,7 +18425,6 @@ static int rtl8152_ethtool_begin(struct net_device *netdev)
 	return 0;
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,18,0)
 static int rtl8152_get_tunable(struct net_device *netdev,
 			       const struct ethtool_tunable *tunable, void *d)
 {
@@ -18986,16 +18475,11 @@ static int rtl8152_set_tunable(struct net_device *netdev,
 
 	return 0;
 }
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,18,0) */
 
 static void rtl8152_get_ringparam(struct net_device *netdev,
-#if LINUX_VERSION_CODE < KERNEL_VERSION(5,17,0)
-				  struct ethtool_ringparam *ring)
-#else
 				  struct ethtool_ringparam *ring,
 				  struct kernel_ethtool_ringparam *kernel_ring,
 				  struct netlink_ext_ack *extack)
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0) */
 {
 	struct r8152 *tp = netdev_priv(netdev);
 
@@ -19004,13 +18488,9 @@ static void rtl8152_get_ringparam(struct net_device *netdev,
 }
 
 static int rtl8152_set_ringparam(struct net_device *netdev,
-#if LINUX_VERSION_CODE < KERNEL_VERSION(5,17,0)
-				 struct ethtool_ringparam *ring)
-#else
 				 struct ethtool_ringparam *ring,
 				 struct kernel_ethtool_ringparam *kernel_ring,
 				 struct netlink_ext_ack *extack)
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0) */
 {
 	struct r8152 *tp = netdev_priv(netdev);
 
@@ -19111,14 +18591,8 @@ static int rtl8152_set_pauseparam(struct net_device *netdev, struct ethtool_paus
 }
 
 static const struct ethtool_ops ops = {
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(5,7,0)
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS,
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(5,7,0) */
 	.get_drvinfo = rtl8152_get_drvinfo,
-#if LINUX_VERSION_CODE < KERNEL_VERSION(4,20,0)
-	.get_settings = rtl8152_get_settings,
-	.set_settings = rtl8152_set_settings,
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,20,0) */
 	.get_link = ethtool_op_get_link,
 	.nway_reset = rtl8152_nway_reset,
 	.get_msglevel = rtl8152_get_msglevel,
@@ -19128,31 +18602,15 @@ static const struct ethtool_ops ops = {
 	.get_strings = rtl8152_get_strings,
 	.get_sset_count = rtl8152_get_sset_count,
 	.get_ethtool_stats = rtl8152_get_ethtool_stats,
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0)
-	.get_tx_csum = ethtool_op_get_tx_csum,
-	.set_tx_csum = ethtool_op_set_tx_csum,
-	.get_sg = ethtool_op_get_sg,
-	.set_sg = ethtool_op_set_sg,
-#ifdef NETIF_F_TSO
-	.get_tso = ethtool_op_get_tso,
-	.set_tso = ethtool_op_set_tso,
-#endif
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0) */
 	.get_coalesce = rtl8152_get_coalesce,
 	.set_coalesce = rtl8152_set_coalesce,
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
 	.get_eee = rtl_ethtool_get_eee,
 	.set_eee = rtl_ethtool_set_eee,
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0) */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,6,0)
 	.get_link_ksettings = rtl8152_get_link_ksettings,
 	.set_link_ksettings = rtl8152_set_link_ksettings,
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(4,6,0) */
 	.begin = rtl8152_ethtool_begin,
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,18,0)
 	.get_tunable = rtl8152_get_tunable,
 	.set_tunable = rtl8152_set_tunable,
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,18,0) */
 	.get_ringparam = rtl8152_get_ringparam,
 	.set_ringparam = rtl8152_set_ringparam,
 	.get_pauseparam = rtl8152_get_pauseparam,
@@ -19338,7 +18796,6 @@ static int rtltool_ioctl(struct r8152 *tp, struct ifreq *ifr)
 	return ret;
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(5,15,0)
 static int rtl8152_siocdevprivate(struct net_device *netdev, struct ifreq *rq,
 				  void __user *data, int cmd)
 {
@@ -19370,7 +18827,6 @@ static int rtl8152_siocdevprivate(struct net_device *netdev, struct ifreq *rq,
 out:
 	return ret;
 }
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(5,15,0) */
 
 static int rtl8152_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
 {
@@ -19417,16 +18873,6 @@ static int rtl8152_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
 		mutex_unlock(&tp->control);
 		break;
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0)
-	case SIOCDEVPRIVATE:
-		if (!capable(CAP_NET_ADMIN)) {
-			ret = -EPERM;
-			break;
-		}
-		ret = rtltool_ioctl(tp, rq);
-		break;
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0) */
-
 	default:
 		ret = -EOPNOTSUPP;
 	}
@@ -19441,56 +18887,17 @@ static int rtl8152_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct r8152 *tp = netdev_priv(dev);
 	int ret;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(4,10,0)
-	u32 max_mtu;
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,10,0) */
 
 	switch (tp->version) {
 	case RTL_VER_01:
 	case RTL_VER_02:
 	case RTL_VER_07:
-#if LINUX_VERSION_CODE < KERNEL_VERSION(4,10,0)
-		return eth_change_mtu(dev, new_mtu);
-#else
 		dev->mtu = new_mtu;
 		return 0;
-#endif
 	default:
 		break;
 	}
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(4,10,0)
-	switch (tp->version) {
-	case RTL_VER_03:
-	case RTL_VER_04:
-	case RTL_VER_05:
-	case RTL_VER_06:
-	case RTL_VER_08:
-	case RTL_VER_09:
-	case RTL_VER_14:
-		max_mtu = size_to_mtu(9 * 1024);
-		break;
-	case RTL_VER_10:
-	case RTL_VER_11:
-		max_mtu = size_to_mtu(15 * 1024);
-		break;
-	case RTL_VER_12:
-	case RTL_VER_13:
-	case RTL_VER_15:
-		max_mtu = size_to_mtu(16 * 1024);
-		break;
-	case RTL_VER_01:
-	case RTL_VER_02:
-	case RTL_VER_07:
-	default:
-		max_mtu = ETH_DATA_LEN;
-		break;
-	}
-
-	if (new_mtu < 68 || new_mtu > max_mtu)
-		return -EINVAL;
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,10,0) */
-
 	ret = usb_autopm_get_interface(tp->intf);
 	if (ret < 0)
 		return ret;
@@ -19524,32 +18931,20 @@ static int rtl8152_change_mtu(struct net_device *dev, int new_mtu)
 	return ret;
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29)
 static const struct net_device_ops rtl8152_netdev_ops = {
 	.ndo_open		= rtl8152_open,
 	.ndo_stop		= rtl8152_close,
-#if LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0)
-	.ndo_do_ioctl		= rtl8152_ioctl,
-#else
 	.ndo_siocdevprivate	= rtl8152_siocdevprivate,
 	.ndo_eth_ioctl		= rtl8152_ioctl,
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0) */
 	.ndo_start_xmit		= rtl8152_start_xmit,
 	.ndo_tx_timeout		= rtl8152_tx_timeout,
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0)
-	.ndo_vlan_rx_register	= rtl8152_vlan_rx_register,
-#else
 	.ndo_set_features	= rtl8152_set_features,
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0) */
 	.ndo_set_rx_mode	= rtl8152_set_rx_mode,
 	.ndo_set_mac_address	= rtl8152_set_mac_address,
 	.ndo_change_mtu		= rtl8152_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,18,4)
 	.ndo_features_check	= rtl8152_features_check,
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,18,4) */
 };
-#endif
 
 static void rtl8152_unload(struct r8152 *tp)
 {
@@ -19591,10 +18986,8 @@ static int rtl_ops_init(struct r8152 *tp)
 		ops->up			= rtl8152_up;
 		ops->down		= rtl8152_down;
 		ops->unload		= rtl8152_unload;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
 		ops->eee_get		= r8152_get_eee;
 		ops->eee_set		= r8152_set_eee;
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0) */
 		ops->in_nway		= rtl8152_in_nway;
 		ops->hw_phy_cfg		= r8152b_hw_phy_cfg;
 		ops->autosuspend_en	= rtl_runtime_suspend_enable;
@@ -19613,10 +19006,8 @@ static int rtl_ops_init(struct r8152 *tp)
 		ops->up			= rtl8153_up;
 		ops->down		= rtl8153_down;
 		ops->unload		= rtl8153_unload;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
 		ops->eee_get		= r8153_get_eee;
 		ops->eee_set		= r8152_set_eee;
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0) */
 		ops->in_nway		= rtl8153_in_nway;
 		ops->hw_phy_cfg		= r8153_hw_phy_cfg;
 		ops->autosuspend_en	= rtl8153_runtime_enable;
@@ -19637,10 +19028,8 @@ static int rtl_ops_init(struct r8152 *tp)
 		ops->up			= rtl8153b_up;
 		ops->down		= rtl8153b_down;
 		ops->unload		= rtl8153b_unload;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
 		ops->eee_get		= r8153_get_eee;
 		ops->eee_set		= r8152_set_eee;
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0) */
 		ops->in_nway		= rtl8153_in_nway;
 		ops->hw_phy_cfg		= r8153b_hw_phy_cfg;
 		ops->autosuspend_en	= rtl8153b_runtime_enable;
@@ -19679,10 +19068,8 @@ static int rtl_ops_init(struct r8152 *tp)
 		ops->up			= rtl8156_up;
 		ops->down		= rtl8156_down;
 		ops->unload		= rtl8153_unload;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
 		ops->eee_get		= r8153_get_eee;
 		ops->eee_set		= r8152_set_eee;
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0) */
 		ops->in_nway		= rtl8153_in_nway;
 		ops->hw_phy_cfg		= r8156_hw_phy_cfg;
 		ops->autosuspend_en	= rtl8156_runtime_enable;
@@ -19704,10 +19091,8 @@ static int rtl_ops_init(struct r8152 *tp)
 		ops->up			= rtl8156_up;
 		ops->down		= rtl8156_down;
 		ops->unload		= rtl8153_unload;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
 		ops->eee_get		= r8153_get_eee;
 		ops->eee_set		= r8152_set_eee;
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0) */
 		ops->in_nway		= rtl8153_in_nway;
 		ops->hw_phy_cfg		= r8156b_hw_phy_cfg;
 		ops->autosuspend_en	= rtl8156_runtime_enable;
@@ -19722,10 +19107,8 @@ static int rtl_ops_init(struct r8152 *tp)
 		ops->up			= rtl8153c_up;
 		ops->down		= rtl8153b_down;
 		ops->unload		= rtl8153_unload;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0)
 		ops->eee_get		= r8153_get_eee;
 		ops->eee_set		= r8152_set_eee;
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,6,0) */
 		ops->in_nway		= rtl8153_in_nway;
 		ops->hw_phy_cfg		= r8153c_hw_phy_cfg;
 		ops->autosuspend_en	= rtl8153c_runtime_enable;
@@ -20464,9 +19847,7 @@ static ssize_t sg_en_store(struct device *dev, struct device_attribute *attr,
 		return -EINVAL;
 	}
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26)
 	netif_set_gso_max_size(netdev, tso_size);
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26) */
 
 	return count;
 }
@@ -20576,28 +19957,10 @@ static int rtl8152_probe(struct usb_interface *intf,
 	tasklet_setup(&tp->tx_tl, bottom_half);
 	tasklet_disable(&tp->tx_tl);
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(5,2,3)
 	if (usb_device_no_sg_constraint(udev))
 		tp->sg_use = true;
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(5,2,3) */
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)
-	netdev->open = rtl8152_open;
-	netdev->stop = rtl8152_close;
-	netdev->get_stats = rtl8152_get_stats;
-	netdev->hard_start_xmit = rtl8152_start_xmit;
-	netdev->tx_timeout = rtl8152_tx_timeout;
-	netdev->change_mtu = rtl8152_change_mtu;
-	netdev->set_mac_address = rtl8152_set_mac_address;
-	netdev->do_ioctl = rtl8152_ioctl;
-	netdev->set_multicast_list = rtl8152_set_rx_mode;
-	netdev->vlan_rx_register = rtl8152_vlan_rx_register;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22)
-	netdev->vlan_rx_kill_vid = rtl8152_vlan_rx_kill_vid;
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22) */
-#else
+
 	netdev->netdev_ops = &rtl8152_netdev_ops;
-#endif /* HAVE_NET_DEVICE_OPS */
 
 	netdev->watchdog_timeo = RTL8152_TX_TIMEOUT;
 
@@ -20606,7 +19969,6 @@ static int rtl8152_probe(struct usb_interface *intf,
 			    NETIF_F_TSO6 | NETIF_F_HW_VLAN_CTAG_RX |
 			    NETIF_F_HW_VLAN_CTAG_TX;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39)
 	netdev->hw_features = NETIF_F_RXCSUM | NETIF_F_IP_CSUM | NETIF_F_SG |
 			      NETIF_F_TSO | NETIF_F_FRAGLIST |
 			      NETIF_F_IPV6_CSUM | NETIF_F_TSO6 |
@@ -20614,26 +19976,18 @@ static int rtl8152_probe(struct usb_interface *intf,
 	netdev->vlan_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
 				NETIF_F_HIGHDMA | NETIF_F_FRAGLIST |
 				NETIF_F_IPV6_CSUM | NETIF_F_TSO6;
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39) */
 
 	if (tp->version == RTL_VER_01) {
 		netdev->features &= ~NETIF_F_RXCSUM;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39)
 		netdev->hw_features &= ~NETIF_F_RXCSUM;
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,39) */
 	}
 
 	rtl_get_mapt_ver(tp);
 
 	netdev->ethtool_ops = &ops;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26)
 	if (!tp->sg_use)
 		netif_set_gso_max_size(netdev, RTL_LIMITED_TSO_SIZE);
-#else
-	netdev->features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,26) */
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(4,10,0)
 	/* MTU range: 68 - 1500 or 9194 */
 	netdev->min_mtu = ETH_MIN_MTU;
 	switch (tp->version) {
@@ -20662,7 +20016,6 @@ static int rtl8152_probe(struct usb_interface *intf,
 		netdev->max_mtu = ETH_DATA_LEN;
 		break;
 	}
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(4,10,0) */
 
 	tp->mii.dev = netdev;
 	tp->mii.mdio_read = read_mii_word;
@@ -20710,17 +20063,9 @@ static int rtl8152_probe(struct usb_interface *intf,
 	 * commit b48b89f9c189d24eb5e2b4a0ac067da5a24ee86d
 	 */
 	if (tp->support_2500full)
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(6,1,0)
 		netif_napi_add_weight(netdev, &tp->napi, r8152_poll, 256);
-#else 
-		netif_napi_add(netdev, &tp->napi, r8152_poll, 256);
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(6,1,0) */
 	else
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(6,1,0)
 		netif_napi_add(netdev, &tp->napi, r8152_poll);
-#else 
-		netif_napi_add(netdev, &tp->napi, r8152_poll, 64);
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(6,1,0) */
 
 	ret = register_netdev(netdev);
 	if (ret != 0) {
@@ -20870,9 +20215,7 @@ static struct usb_driver rtl8152_driver = {
 	.pre_reset =	rtl8152_pre_reset,
 	.post_reset =	rtl8152_post_reset,
 	.supports_autosuspend = 1,
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,5,0)
 	.disable_hub_initiated_lpm = 1,
-#endif
 };
 
 module_usb_driver(rtl8152_driver);
diff --git a/drivers/net/usb/r8152_compatibility.h b/drivers/net/usb/r8152_compatibility.h
index 7738d17de7be..5f3eca6ee9ec 100644
--- a/drivers/net/usb/r8152_compatibility.h
+++ b/drivers/net/usb/r8152_compatibility.h
@@ -14,605 +14,8 @@
 #include <linux/reboot.h>
 #endif /* defined(RTL8152_S5_WOL) && defined(CONFIG_PM) */
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31)
-	#include <linux/mdio.h>
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,7,0)
-	#include <uapi/linux/mdio.h>
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(3,7,0) */
-#endif /* LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,31) */
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0)
-#if LINUX_VERSION_CODE < KERNEL_VERSION(5,12,0)
-	#define PHY_MAC_INTERRUPT		PHY_IGNORE_INTERRUPT
-#if LINUX_VERSION_CODE < KERNEL_VERSION(5,9,0)
-	#ifdef CONFIG_PM
-	#define pm_ptr(_ptr) (_ptr)
-	#else
-	#define pm_ptr(_ptr) NULL
-	#endif
-
-	#define from_tasklet(var, callback_tasklet, tasklet_fieldname)	\
-		container_of((struct tasklet_struct *)callback_tasklet, typeof(*var), tasklet_fieldname)
-
-	#define tasklet_setup(t, fun)	tasklet_init(t, fun, (unsigned long)t)
-#if LINUX_VERSION_CODE < KERNEL_VERSION(5,8,0)
-#if LINUX_VERSION_CODE < KERNEL_VERSION(5,7,0)
-#if LINUX_VERSION_CODE < KERNEL_VERSION(5,6,0)
-	/* Iterate through singly-linked GSO fragments of an skb. */
-	#define skb_list_walk_safe(first, skb, next_skb)                               \
-		for ((skb) = (first), (next_skb) = (skb) ? (skb)->next : NULL; (skb);  \
-		     (skb) = (next_skb), (next_skb) = (skb) ? (skb)->next : NULL)
-#if LINUX_VERSION_CODE < KERNEL_VERSION(5,4,0)
-	#ifndef __has_attribute
-	# define __has_attribute(x)         0
-	#endif
-
-	#if __has_attribute(__fallthrough__)
-	# define fallthrough                    __attribute__((__fallthrough__))
-	#else
-	# define fallthrough                    do {} while (0)  /* fallthrough */
-	#endif
-
-	#define MDIO_EEE_2_5GT         0x0001  /* 2.5GT EEE cap */
-#if LINUX_VERSION_CODE < KERNEL_VERSION(5,2,0)
-#if LINUX_VERSION_CODE < KERNEL_VERSION(5,1,0)
-	#define MDIO_AN_10GBT_CTRL_ADV2_5G     0x0080  /* Advertise 2.5GBASE-T */
-	#define MDIO_AN_10GBT_STAT_LP2_5G      0x0020  /* LP is 2.5GBT capable */
-#if LINUX_VERSION_CODE < KERNEL_VERSION(5,0,0)
-#if LINUX_VERSION_CODE < KERNEL_VERSION(4,20,0)
-#if LINUX_VERSION_CODE < KERNEL_VERSION(4,12,0)
-	#define SPEED_2500				2500
-	#define SPEED_25000				25000
-#if LINUX_VERSION_CODE < KERNEL_VERSION(4,10,0)
-	#ifndef ETHTOOL_LINK_MODE_2500baseT_Full_BIT
-	#define ETHTOOL_LINK_MODE_2500baseT_Full_BIT	ETHTOOL_LINK_MODE_2500baseX_Full_BIT
-	#endif
-#if LINUX_VERSION_CODE < KERNEL_VERSION(4,9,0)
-	#define BMCR_SPEED10				0x0000
-#if LINUX_VERSION_CODE < KERNEL_VERSION(4,5,0)
-	#define NETIF_F_CSUM_MASK			NETIF_F_ALL_CSUM
-#if LINUX_VERSION_CODE < KERNEL_VERSION(4,1,0)
-	#define IS_REACHABLE(option)			(defined(option) || \
-							 (defined(option##_MODULE) && defined(MODULE)))
-#if LINUX_VERSION_CODE < KERNEL_VERSION(4,0,0)
-	#define skb_vlan_tag_present(__skb)		vlan_tx_tag_present(__skb)
-	#define skb_vlan_tag_get(__skb)			vlan_tx_tag_get(__skb)
-	#define skb_vlan_tag_get_id(__skb)		vlan_tx_tag_get_id(__skb)
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,19,0)
-	#define napi_alloc_skb(napi, length)		netdev_alloc_skb_ip_align(netdev,length)
-	#define napi_complete_done(n, d)		napi_complete(n)
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,16,0)
-	#ifndef smp_mb__before_atomic
-	#define smp_mb__before_atomic()			smp_mb()
-	#endif
-
-	#ifndef smp_mb__after_atomic
-	#define smp_mb__after_atomic()			smp_mb()
-	#endif
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,15,0)
-	#define IS_ERR_OR_NULL(ptr)			(!ptr)
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,14,0)
-	#define ether_addr_copy(dst, src)		memcpy(dst, src, ETH_ALEN)
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,13,0)
-	#define BIT(nr)					(1UL << (nr))
-	#define BIT_ULL(nr)				(1ULL << (nr))
-	#define BITS_PER_BYTE				8
-	#define reinit_completion(x)			((x)->done = 0)
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,12,0)
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,11,0)
-	#define DEVICE_ATTR_RW(_name) \
-		struct device_attribute dev_attr_##_name = __ATTR(_name, 0644, _name##_show, _name##_store)
-	#define DEVICE_ATTR_RO(_name) \
-		struct device_attribute dev_attr_##_name = __ATTR_RO(_name)
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,10,0)
-	#define NETIF_F_HW_VLAN_CTAG_RX			NETIF_F_HW_VLAN_RX
-	#define NETIF_F_HW_VLAN_CTAG_TX			NETIF_F_HW_VLAN_TX
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,8,0)
-	#define USB_DEVICE_INTERFACE_CLASS(vend, prod, cl) \
-		.match_flags = USB_DEVICE_ID_MATCH_DEVICE | \
-			       USB_DEVICE_ID_MATCH_INT_CLASS, \
-		.idVendor = (vend), \
-		.idProduct = (prod), \
-		.bInterfaceClass = (cl)
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,7,0)
-	#ifndef SPEED_UNKNOWN
-		#define SPEED_UNKNOWN		0
-	#endif
-
-	#ifndef DUPLEX_UNKNOWN
-		#define DUPLEX_UNKNOWN		0xff
-	#endif
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,6,0)
-	#define eth_random_addr(addr)			random_ether_addr(addr)
-	#define usb_enable_lpm(udev)
-	#define MDIO_EEE_100TX				MDIO_AN_EEE_ADV_100TX	/* 100TX EEE cap */
-	#define MDIO_EEE_1000T				MDIO_AN_EEE_ADV_1000T	/* 1000T EEE cap */
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,4,0)
-	#define ETH_MDIO_SUPPORTS_C22			MDIO_SUPPORTS_C22
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0)
-	#define module_usb_driver(__driver) \
-	static int __init __driver##_init(void) \
-	{ \
-		return usb_register(&(__driver)); \
-	} \
-	module_init(__driver##_init); \
-	static void __exit __driver##_exit(void) \
-	{ \
-		usb_deregister(&(__driver)); \
-	} \
-	module_exit(__driver##_exit);
-
-	#define netdev_features_t			u32
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0)
-	#define PMSG_IS_AUTO(msg)	(((msg).event & PM_EVENT_AUTO) != 0)
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(3,1,0)
-	#define ndo_set_rx_mode				ndo_set_multicast_list
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,39)
-	#define NETIF_F_RXCSUM				(1 << 29) /* Receive checksumming offload */
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,38)
-	#define MDIO_AN_EEE_ADV				60	/* EEE advertisement */
-	#define MDIO_AN_EEE_ADV_100TX			0x0002	/* Advertise 100TX EEE cap */
-	#define MDIO_AN_EEE_ADV_1000T			0x0004	/* Advertise 1000T EEE cap */
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37)
-	#define skb_checksum_none_assert(skb_ptr)	(skb_ptr)->ip_summed = CHECKSUM_NONE
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36)
-	#define skb_tx_timestamp(skb)
-
-	#define queue_delayed_work(long_wq, work, delay)	schedule_delayed_work(work, delay)
-
-	#define work_busy(x)				0
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,34)
-	#define netdev_mc_count(netdev)			((netdev)->mc_count)
-	#define netdev_mc_empty(netdev)			(netdev_mc_count(netdev) == 0)
-
-	#define netif_printk(priv, type, level, netdev, fmt, args...)	\
-	do {								\
-		if (netif_msg_##type(priv))				\
-			printk(level "%s: " fmt,(netdev)->name , ##args); \
-	} while (0)
-
-	#define netif_emerg(priv, type, netdev, fmt, args...)		\
-		netif_printk(priv, type, KERN_EMERG, netdev, fmt, ##args)
-	#define netif_alert(priv, type, netdev, fmt, args...)		\
-		netif_printk(priv, type, KERN_ALERT, netdev, fmt, ##args)
-	#define netif_crit(priv, type, netdev, fmt, args...)		\
-		netif_printk(priv, type, KERN_CRIT, netdev, fmt, ##args)
-	#define netif_err(priv, type, netdev, fmt, args...)		\
-		netif_printk(priv, type, KERN_ERR, netdev, fmt, ##args)
-	#define netif_warn(priv, type, netdev, fmt, args...)		\
-		netif_printk(priv, type, KERN_WARNING, netdev, fmt, ##args)
-	#define netif_notice(priv, type, netdev, fmt, args...)		\
-		netif_printk(priv, type, KERN_NOTICE, netdev, fmt, ##args)
-	#define netif_info(priv, type, netdev, fmt, args...)		\
-		netif_printk(priv, type, KERN_INFO, (netdev), fmt, ##args)
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33)
-	#define get_sset_count				get_stats_count
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32)
-	#define pm_request_resume(para)
-	#define pm_runtime_set_suspended(para)
-	#define pm_schedule_suspend(para1, para2)
-	#define pm_runtime_get_sync(para)
-	#define pm_runtime_put_sync(para)
-	#define pm_runtime_put_noidle(para)
-	#define pm_runtime_idle(para)
-	#define pm_runtime_set_active(para)
-	#define pm_runtime_enable(para)
-	#define pm_runtime_disable(para)
-	typedef int netdev_tx_t;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31)
-	#define USB_SPEED_SUPER				(USB_SPEED_VARIABLE + 1)
-	#define MDIO_MMD_AN				7	/* Auto-Negotiation */
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29)
-	#define napi_gro_receive(napi, skb)		netif_receive_skb(skb)
-	#define vlan_gro_receive(napi, grp, vlan_tci, skb) \
-		vlan_hwaccel_receive_skb(skb, grp, vlan_tci)
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28)
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27)
-	#define PM_EVENT_AUTO		0x0400
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24)
-	struct napi_struct {
-		struct list_head	poll_list;
-		unsigned long		state;
-		int			weight;
-		int			(*poll)(struct napi_struct *, int);
-	#ifdef CONFIG_NETPOLL
-		spinlock_t		poll_lock;
-		int			poll_owner;
-		struct net_device	*dev;
-		struct list_head	dev_list;
-	#endif
-	};
-
-	#define napi_enable(napi_ptr)			netif_poll_enable(container_of(napi_ptr, struct r8152, napi)->netdev)
-	#define napi_disable(napi_ptr)			netif_poll_disable(container_of(napi_ptr, struct r8152, napi)->netdev)
-	#define napi_schedule(napi_ptr)			netif_rx_schedule(container_of(napi_ptr, struct r8152, napi)->netdev)
-	#define napi_complete(napi_ptr)			netif_rx_complete(container_of(napi_ptr, struct r8152, napi)->netdev)
-	#define netif_napi_add(ndev, napi_ptr, function, weight_t) \
-		ndev->poll = function; \
-		ndev->weight = weight_t;
-	typedef unsigned long				uintptr_t;
-	#define DMA_BIT_MASK(value) \
-		(value < 64 ? ((1ULL << value) - 1) : 0xFFFFFFFFFFFFFFFFULL)
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23)
-	#define NETIF_F_IPV6_CSUM			16
-	#define cancel_delayed_work_sync		cancel_delayed_work
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22)
-	#define ip_hdr(skb_ptr)				(skb_ptr)->nh.iph
-	#define ipv6hdr(skb_ptr)			(skb_ptr)->nh.ipv6h
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)
-	#define vlan_group_set_device(vlgrp, vid, value) \
-		if (vlgrp) \
-			(vlgrp)->vlan_devices[vid] = value;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-	#define delayed_work				work_struct
-	#define INIT_DELAYED_WORK(a,b)			INIT_WORK(a,b,tp)
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19)
-	#define CHECKSUM_PARTIAL			CHECKSUM_HW
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18)
-	#define skb_is_gso(skb_ptr)			skb_shinfo(skb_ptr)->tso_size
-	#define netdev_alloc_skb(dev, len)		dev_alloc_skb(len)
-	#define IRQF_SHARED				SA_SHIRQ
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,16)
-	#ifndef __LINUX_MUTEX_H
-	#define mutex					semaphore
-	#define mutex_lock				down
-	#define mutex_unlock				up
-	#define mutex_trylock				down_trylock
-	#define mutex_lock_interruptible		down_interruptible
-	#define mutex_init				init_MUTEX
-	#endif
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14)
-	#define ADVERTISED_Pause			(1 << 13)
-	#define ADVERTISED_Asym_Pause			(1 << 14)
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,12)
-	#define skb_header_cloned(skb)			skb_cloned(skb)
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,12) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,16) */
-	static inline struct sk_buff *skb_gso_segment(struct sk_buff *skb, int features)
-	{
-		return NULL;
-	}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18) */
-	static inline void *kmemdup(const void *src, size_t len, gfp_t gfp)
-	{
-		void *p;
-
-		p = kmalloc_track_caller(len, gfp);
-		if (p)
-			memcpy(p, src, len);
-		return p;
-	}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,19) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21) */
-	static inline void skb_copy_from_linear_data(const struct sk_buff *skb,
-						     void *to,
-						     const unsigned int len)
-	{
-		memcpy(to, skb->data, len);
-	}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,22) */
-	static inline int skb_cow_head(struct sk_buff *skb, unsigned int headroom)
-	{
-		int delta = 0;
-
-		if (headroom > skb_headroom(skb))
-			delta = headroom - skb_headroom(skb);
-
-		if (delta || skb_header_cloned(skb))
-			return pskb_expand_head(skb, ALIGN(delta, NET_SKB_PAD),
-						0, GFP_ATOMIC);
-		return 0;
-	}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,23) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24) */
-	static inline void __list_splice2(const struct list_head *list,
-					  struct list_head *prev,
-					  struct list_head *next)
-	{
-		struct list_head *first = list->next;
-		struct list_head *last = list->prev;
-
-		first->prev = prev;
-		prev->next = first;
-
-		last->next = next;
-		next->prev = last;
-	}
-
-	static inline void list_splice_tail(struct list_head *list,
-					    struct list_head *head)
-	{
-		if (!list_empty(list))
-			__list_splice2(list, head->prev, head);
-	}
-
-	static inline void netif_napi_del(struct napi_struct *napi)
-	{
-	#ifdef CONFIG_NETPOLL
-	        list_del(&napi->dev_list);
-	#endif
-	}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,27) */
-	static inline void __skb_queue_splice(const struct sk_buff_head *list,
-					      struct sk_buff *prev,
-					      struct sk_buff *next)
-	{
-		struct sk_buff *first = list->next;
-		struct sk_buff *last = list->prev;
-
-		first->prev = prev;
-		prev->next = first;
-
-		last->next = next;
-		next->prev = last;
-	}
-
-	static inline void skb_queue_splice(const struct sk_buff_head *list,
-					    struct sk_buff_head *head)
-	{
-		if (!skb_queue_empty(list)) {
-			__skb_queue_splice(list, (struct sk_buff *) head, head->next);
-			head->qlen += list->qlen;
-		}
-	}
-
-	static inline void __skb_queue_head_init(struct sk_buff_head *list)
-	{
-		list->prev = list->next = (struct sk_buff *)list;
-		list->qlen = 0;
-	}
-
-	static inline void skb_queue_splice_init(struct sk_buff_head *list,
-						 struct sk_buff_head *head)
-	{
-		if (!skb_queue_empty(list)) {
-			__skb_queue_splice(list, (struct sk_buff *) head, head->next);
-			head->qlen += list->qlen;
-			__skb_queue_head_init(list);
-		}
-	}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,28) */
-	static inline void usb_autopm_put_interface_async(struct usb_interface *intf)
-	{
-		struct usb_device *udev = interface_to_usbdev(intf);
-		int status = 0;
-
-		if (intf->condition == USB_INTERFACE_UNBOUND) {
-			status = -ENODEV;
-		} else {
-			udev->last_busy = jiffies;
-			--intf->pm_usage_cnt;
-			if (udev->autosuspend_disabled || udev->autosuspend_delay < 0)
-				status = -EPERM;
-		}
-	}
-
-	static inline int usb_autopm_get_interface_async(struct usb_interface *intf)
-	{
-		struct usb_device *udev = interface_to_usbdev(intf);
-		int status = 0;
-
-		if (intf->condition == USB_INTERFACE_UNBOUND)
-			status = -ENODEV;
-		else if (udev->autoresume_disabled)
-			status = -EPERM;
-		else
-			++intf->pm_usage_cnt;
-		return status;
-	}
-
-	static inline int eth_change_mtu(struct net_device *dev, int new_mtu)
-	{
-		if (new_mtu < 68 || new_mtu > ETH_DATA_LEN)
-			return -EINVAL;
-		dev->mtu = new_mtu;
-		return 0;
-	}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,29) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,31) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,32) */
-	static inline
-	struct sk_buff *netdev_alloc_skb_ip_align(struct net_device *dev,
-						  unsigned int length)
-	{
-		struct sk_buff *skb = netdev_alloc_skb(dev, length + NET_IP_ALIGN);
-
-		if (NET_IP_ALIGN && skb)
-			skb_reserve(skb, NET_IP_ALIGN);
-		return skb;
-	}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,33) */
-	static inline int usb_enable_autosuspend(struct usb_device *udev)
-	{ return 0; }
-	static inline int usb_disable_autosuspend(struct usb_device *udev)
-	{ return 0; }
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,34) */
-	static inline bool pci_dev_run_wake(struct pci_dev *dev)
-	{
-		return 1;
-	}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35) */
-	static inline void usleep_range(unsigned long min, unsigned long max)
-	{
-		unsigned long ms = min / 1000;
-
-		if (ms)
-			mdelay(ms);
-
-		udelay(min % 1000);
-	}
-
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,36) */
-	static inline __be16 vlan_get_protocol(const struct sk_buff *skb)
-	{
-	       __be16 protocol = 0;
-
-	       if (vlan_tx_tag_present(skb) ||
-	            skb->protocol != cpu_to_be16(ETH_P_8021Q))
-	               protocol = skb->protocol;
-	       else {
-	               __be16 proto, *protop;
-	               protop = skb_header_pointer(skb, offsetof(struct vlan_ethhdr,
-	                                               h_vlan_encapsulated_proto),
-	                                               sizeof(proto), &proto);
-	               if (likely(protop))
-	                       protocol = *protop;
-	       }
-
-	       return protocol;
-	}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,38) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(2,6,39) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,1,0) */
-	static inline struct page *skb_frag_page(const skb_frag_t *frag)
-	{
-		return frag->page;
-	}
-
-	static inline void *skb_frag_address(const skb_frag_t *frag)
-	{
-		return page_address(skb_frag_page(frag)) + frag->page_offset;
-	}
-
-	static inline unsigned int skb_frag_size(const skb_frag_t *frag)
-	{
-		return frag->size;
-	}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,2,0) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,3,0) */
-	static inline void eth_hw_addr_random(struct net_device *dev)
-	{
-		random_ether_addr(dev->dev_addr);
-	}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,4,0) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,6,0) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,7,0) */
-	static inline __sum16 tcp_v6_check(int len,
-					   const struct in6_addr *saddr,
-					   const struct in6_addr *daddr,
-					   __wsum base)
-	{
-		return csum_ipv6_magic(saddr, daddr, len, IPPROTO_TCP, base);
-	}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,8,0) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,10,0) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,11,0) */
-	static inline bool usb_device_no_sg_constraint(struct usb_device *udev)
-	{
-		return 0;
-	}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,12,0) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,13,0) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,14,0) */
-	static inline int skb_to_sgvec_nomark(struct sk_buff *skb,
-					      struct scatterlist *sg,
-					      int offset, int len)
-	{
-		int nsg = skb_to_sgvec(skb, sg, offset, len);
-
-		if (nsg <= 0)
-			return nsg;
-
-		sg_unmark_end(&sg[nsg - 1]);
-
-		return nsg;
-	}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,15,0) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,16,0) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(3,19,0) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,0,0) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,1,0) */
-	static inline int eth_platform_get_mac_address(struct device *dev, u8 *mac_addr)
-	{
-		return -EOPNOTSUPP;
-	}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,5,0) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,9,0) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,10,0) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,12,0) */
-#if LINUX_VERSION_CODE < KERNEL_VERSION(4,19,10) && \
-    !(LINUX_VERSION_CODE >= KERNEL_VERSION(4,14,217) && LINUX_VERSION_CODE < KERNEL_VERSION(4,15,0))
-	static inline void skb_mark_not_on_list(struct sk_buff *skb)
-	{
-		skb->next = NULL;
-	}
-#endif
-	static inline void linkmode_set_bit(int nr, volatile unsigned long *addr)
-	{
-		__set_bit(nr, addr);
-	}
-
-	static inline void linkmode_clear_bit(int nr, volatile unsigned long *addr)
-	{
-		__clear_bit(nr, addr);
-	}
-
-	static inline int linkmode_test_bit(int nr, volatile unsigned long *addr)
-	{
-		return test_bit(nr, addr);
-	}
-
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(4,20,0) */
-	static inline void linkmode_mod_bit(int nr, volatile unsigned long *addr,
-					    int set)
-	{
-		if (set)
-			linkmode_set_bit(nr, addr);
-		else
-			linkmode_clear_bit(nr, addr);
-	}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,0,0) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,1,0) */
-//	static inline u16 pci_dev_id(struct pci_dev *dev)
-//	{
-//		return PCI_DEVID(dev->bus->number, dev->devfn);
-//	}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,2,0) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,4,0) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,6,0) */
-	static inline void tcp_v6_gso_csum_prep(struct sk_buff *skb)
-	{
-		struct ipv6hdr *ipv6h = ipv6_hdr(skb);
-		struct tcphdr *th = tcp_hdr(skb);
-
-		ipv6h->payload_len = 0;
-		th->check = ~tcp_v6_check(0, &ipv6h->saddr, &ipv6h->daddr, 0);
-	}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,7,0) */
-	static inline void fsleep(unsigned long usecs)
-	{
-		if (usecs <= 10)
-			udelay(usecs);
-		else if (usecs <= 20000)
-			usleep_range(usecs, 2 * usecs);
-		else
-			msleep(DIV_ROUND_UP(usecs, 1000));
-	}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,8,0) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,9,0) */
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,12,0) */
-	static inline void eth_hw_addr_set(struct net_device *dev, const u8 *addr)
-	{
-		memcpy(dev->dev_addr, addr, 6);
-	}
-#endif /* LINUX_VERSION_CODE < KERNEL_VERSION(5,15,0) */
+#include <linux/mdio.h>
+#include <uapi/linux/mdio.h>
 
 #ifndef FALSE
 	#define TRUE	1
-- 
2.34.1

