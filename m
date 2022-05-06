Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEECB51DFE3
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 22:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392523AbiEFUGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 16:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392485AbiEFUGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 16:06:01 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5D95F8C3
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 13:02:17 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id gh6so16432548ejb.0
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 13:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iVpcVd0AG8Qe/siFxqPItCTauXIAj/GtOoZ8PYCyTE4=;
        b=EpQsnl/4njl0PeNQG/BTsxgwTcy3d+KJ+oNRro1ONq5xQ2K47gZ9y4DpL1pLAByt+/
         KPw17TAJkYe7WTXlf98dAOQGeAEJ/6lx9XfZBLulEYyR4CgBK51xys9s/HyQ2RROsyM4
         Nx62Ze6FkKWmYt3pcQ1f9u6NWHwTVrmqwfisQmVL/doYYPBEXK6xBiKIr7tNoiyHh0Kf
         +gQ0I6NfvigwaCwSr88n6uCzPYXoSAGEmKKfalr89BmqsxQ82NahWbHPb6sHeIlXqMdL
         wvr/P8Nu/2TtNsVWAUVnPpHeRfoFyOklNF4NPZqg1LF7k6WHk4l8nmoko8f20kF1qQz5
         mzWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iVpcVd0AG8Qe/siFxqPItCTauXIAj/GtOoZ8PYCyTE4=;
        b=X8NegNw0kmroTR0UByDNNn9lwWQ0AqPUJscLrJ1UTY6hP4YPuMEx1NFgUa6Two0Duu
         RiC9frCPTX+5R05N7svfu+HY27X341b4gP4owz8zuV+mmoO5vMX/ESlXITLW48otirR5
         aLBg5cMLftNxG8v6UeF+OSSM2jwB/B8XOhMAITFMrvsdMZ4gEkIx3XdEkEW1dcFBFfA2
         da1K257j4UHkgoxtP4c+ocDAKsL4J220AN2jWtATvxw8mIZg6M9L4eWxmgaVk5LdECqW
         VQpi9ZRb9PtP1y4xBXO3nYsIg2pMtYDUOmy6Tqk+aLFD2HUfg7jBsCvFNSu/Ay2FkYGO
         dRdw==
X-Gm-Message-State: AOAM532SVJqiXL0Fo3GbKPq4ePmSN+rAKiUxviRf5dJE8EZvCnwNaM/b
        jncAJ05Ma7LOO79pHolMgZVbng==
X-Google-Smtp-Source: ABdhPJymzoUwFcmP2ccMnDWK95Lmqx2Etz3/sGKKlDE0XaOsvS469Xd9x8j6VgtHbz7H4X/qBznnVw==
X-Received: by 2002:a17:907:2064:b0:6f4:3f07:c76e with SMTP id qp4-20020a170907206400b006f43f07c76emr4527619ejb.462.1651867335949;
        Fri, 06 May 2022 13:02:15 -0700 (PDT)
Received: from hornet.engleder.at ([2001:871:23a:237:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id w5-20020a056402268500b0042617ba6389sm2719887edd.19.2022.05.06.13.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 13:02:15 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, vinicius.gomes@intel.com,
        yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     mlichvar@redhat.com, willemb@google.com, kafai@fb.com,
        jonathan.lemon@gmail.com, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v4 4/6] ptp: Support late timestamp determination
Date:   Fri,  6 May 2022 22:01:40 +0200
Message-Id: <20220506200142.3329-5-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220506200142.3329-1-gerhard@engleder-embedded.com>
References: <20220506200142.3329-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a physical clock supports a free running cycle counter, then
timestamps shall be based on this time too. For TX it is known in
advance before the transmission if a timestamp based on the free running
cycle counter is needed. For RX it is impossible to know which timestamp
is needed before the packet is received and assigned to a socket.

Support late timestamp determination by a network device. Therefore, an
address/cookie is stored within the new netdev_data field of struct
skb_shared_hwtstamps. This address/cookie is provided to a new network
device function called ndo_get_tstamp(), which returns a timestamp based
on the normal/adjustable time or based on the free running cycle
counter. If function is not supported, then timestamp handling is not
changed.

This mechanism is intended for RX, but TX use is also possible.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 include/linux/netdevice.h | 21 +++++++++++++++++
 include/linux/skbuff.h    | 14 ++++++++---
 net/socket.c              | 49 +++++++++++++++++++++++++++++++--------
 3 files changed, 71 insertions(+), 13 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8cf0ac616cb9..efd136b2d177 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1356,6 +1356,12 @@ struct netdev_net_notifier {
  *	The caller must be under RCU read context.
  * int (*ndo_fill_forward_path)(struct net_device_path_ctx *ctx, struct net_device_path *path);
  *     Get the forwarding path to reach the real device from the HW destination address
+ * ktime_t (*ndo_get_tstamp)(struct net_device *dev,
+ *			     const struct skb_shared_hwtstamps *hwtstamps,
+ *			     bool cycles);
+ *	Get hardware timestamp based on normal/adjustable time or free running
+ *	cycle counter. This function is required if physical clock supports a
+ *	free running cycle counter.
  */
 struct net_device_ops {
 	int			(*ndo_init)(struct net_device *dev);
@@ -1578,6 +1584,9 @@ struct net_device_ops {
 	struct net_device *	(*ndo_get_peer_dev)(struct net_device *dev);
 	int                     (*ndo_fill_forward_path)(struct net_device_path_ctx *ctx,
                                                          struct net_device_path *path);
+	ktime_t			(*ndo_get_tstamp)(struct net_device *dev,
+						  const struct skb_shared_hwtstamps *hwtstamps,
+						  bool cycles);
 };
 
 /**
@@ -4761,6 +4770,18 @@ static inline void netdev_rx_csum_fault(struct net_device *dev,
 void net_enable_timestamp(void);
 void net_disable_timestamp(void);
 
+static inline ktime_t netdev_get_tstamp(struct net_device *dev,
+					const struct skb_shared_hwtstamps *hwtstamps,
+					bool cycles)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+
+	if (ops->ndo_get_tstamp)
+		return ops->ndo_get_tstamp(dev, hwtstamps, cycles);
+
+	return hwtstamps->hwtstamp;
+}
+
 static inline netdev_tx_t __netdev_start_xmit(const struct net_device_ops *ops,
 					      struct sk_buff *skb, struct net_device *dev,
 					      bool more)
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 4d49503bdc4d..878b2631324c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -588,8 +588,10 @@ static inline bool skb_frag_must_loop(struct page *p)
 
 /**
  * struct skb_shared_hwtstamps - hardware time stamps
- * @hwtstamp:	hardware time stamp transformed into duration
- *		since arbitrary point in time
+ * @hwtstamp:		hardware time stamp transformed into duration
+ *			since arbitrary point in time
+ * @netdev_data:	address/cookie of network device driver used as
+ *			reference to actual hardware time stamp
  *
  * Software time stamps generated by ktime_get_real() are stored in
  * skb->tstamp.
@@ -601,7 +603,10 @@ static inline bool skb_frag_must_loop(struct page *p)
  * &skb_shared_info. Use skb_hwtstamps() to get a pointer.
  */
 struct skb_shared_hwtstamps {
-	ktime_t	hwtstamp;
+	union {
+		ktime_t	hwtstamp;
+		void *netdev_data;
+	};
 };
 
 /* Definitions for tx_flags in struct skb_shared_info */
@@ -621,6 +626,9 @@ enum {
 	/* generate wifi status information (where possible) */
 	SKBTX_WIFI_STATUS = 1 << 4,
 
+	/* determine hardware time stamp based on time or cycles */
+	SKBTX_HW_TSTAMP_NETDEV = 1 << 5,
+
 	/* generate software time stamp when entering packet scheduling */
 	SKBTX_SCHED_TSTAMP = 1 << 6,
 };
diff --git a/net/socket.c b/net/socket.c
index 0f680c7d968a..6ee634c01eca 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -805,7 +805,28 @@ static bool skb_is_swtx_tstamp(const struct sk_buff *skb, int false_tstamp)
 	return skb->tstamp && !false_tstamp && skb_is_err_queue(skb);
 }
 
-static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb)
+static ktime_t get_timestamp(struct sock *sk, struct sk_buff *skb, int *if_index)
+{
+	bool cycles = sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC;
+	struct skb_shared_hwtstamps *shhwtstamps = skb_hwtstamps(skb);
+	struct net_device *orig_dev;
+	ktime_t hwtstamp;
+
+	rcu_read_lock();
+	orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
+	if (orig_dev) {
+		*if_index = orig_dev->ifindex;
+		hwtstamp = netdev_get_tstamp(orig_dev, shhwtstamps, cycles);
+	} else {
+		hwtstamp = shhwtstamps->hwtstamp;
+	}
+	rcu_read_unlock();
+
+	return hwtstamp;
+}
+
+static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb,
+			   int if_index)
 {
 	struct scm_ts_pktinfo ts_pktinfo;
 	struct net_device *orig_dev;
@@ -815,11 +836,14 @@ static void put_ts_pktinfo(struct msghdr *msg, struct sk_buff *skb)
 
 	memset(&ts_pktinfo, 0, sizeof(ts_pktinfo));
 
-	rcu_read_lock();
-	orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
-	if (orig_dev)
-		ts_pktinfo.if_index = orig_dev->ifindex;
-	rcu_read_unlock();
+	if (!if_index) {
+		rcu_read_lock();
+		orig_dev = dev_get_by_napi_id(skb_napi_id(skb));
+		if (orig_dev)
+			if_index = orig_dev->ifindex;
+		rcu_read_unlock();
+	}
+	ts_pktinfo.if_index = if_index;
 
 	ts_pktinfo.pkt_length = skb->len - skb_mac_offset(skb);
 	put_cmsg(msg, SOL_SOCKET, SCM_TIMESTAMPING_PKTINFO,
@@ -839,6 +863,7 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
 	int empty = 1, false_tstamp = 0;
 	struct skb_shared_hwtstamps *shhwtstamps =
 		skb_hwtstamps(skb);
+	int if_index;
 	ktime_t hwtstamp;
 
 	/* Race occurred between timestamp enabling and packet
@@ -887,18 +912,22 @@ void __sock_recv_timestamp(struct msghdr *msg, struct sock *sk,
 	if (shhwtstamps &&
 	    (sk->sk_tsflags & SOF_TIMESTAMPING_RAW_HARDWARE) &&
 	    !skb_is_swtx_tstamp(skb, false_tstamp)) {
-		if (sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC)
-			hwtstamp = ptp_convert_timestamp(&shhwtstamps->hwtstamp,
-							 sk->sk_bind_phc);
+		if_index = 0;
+		if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP_NETDEV)
+			hwtstamp = get_timestamp(sk, skb, &if_index);
 		else
 			hwtstamp = shhwtstamps->hwtstamp;
 
+		if (sk->sk_tsflags & SOF_TIMESTAMPING_BIND_PHC)
+			hwtstamp = ptp_convert_timestamp(&hwtstamp,
+							 sk->sk_bind_phc);
+
 		if (ktime_to_timespec64_cond(hwtstamp, tss.ts + 2)) {
 			empty = 0;
 
 			if ((sk->sk_tsflags & SOF_TIMESTAMPING_OPT_PKTINFO) &&
 			    !skb_is_err_queue(skb))
-				put_ts_pktinfo(msg, skb);
+				put_ts_pktinfo(msg, skb, if_index);
 		}
 	}
 	if (!empty) {
-- 
2.20.1

