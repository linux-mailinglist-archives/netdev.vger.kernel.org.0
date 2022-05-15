Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47DC652762E
	for <lists+netdev@lfdr.de>; Sun, 15 May 2022 08:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235886AbiEOGnu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 02:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235363AbiEOGnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 02:43:49 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6D12F3B4
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 23:43:47 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id d5so16609938wrb.6
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 23:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XYfMOnF+p0ZCglkoZp87ck4uQnn/pP1Pn7qGN3c59q4=;
        b=n11D/LTVFBZD2RkFQT9f/9HN7pLVZ8NWnHxBz0Vbs11EaJfek0tRecYrC+PEiOTKwo
         NC+zxmqgkQY9BeAhHxU9mB2Pwx1nER0cCyLazDEJZicg8NIII8njeKIL79MHoE23csb3
         ZnjcQwI1bn6PSVOxBT+oWCblnPz+DHN82MPuCRxjdneu+7yAPpRGffYfc7PWQCIWGvxi
         oknJmoaXijbmQU1UqYIAu7nrOTs65wxa4+e+jZQ1xekWdtgUQOb/4efzAJqbH7gpkB7H
         difGxgdRMigedDJSrCN7MvjTqtpEB00eqbXsmz77N8KVlmQPR1kWl6v/8h3XdHAU7AGo
         gBZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XYfMOnF+p0ZCglkoZp87ck4uQnn/pP1Pn7qGN3c59q4=;
        b=PCHkPtyqmxl7hu+cLKWcoT2Db1EredaBkj6CV0gtDt5D6zSUB2eAcdVlomudAnHtDp
         nkHt4RZj5TCpy76+2LQ+Uktc6NzI7DlS/H1fCkG6zxJgfEPQl1Siy55ag6VglSMq460s
         MFK3IpM/SpGgHG2x7VQxqVWOcVZzevL5y+8JXPzrp0Sa+vV91FaKrsj3986vvKQ+bJ6C
         RDG0Db1Lb9g+zV98a0Dy0u4ra2aOPbubm5MvHEUiphxS9mQIfU5/WXR6Ngl1iwO5af0y
         JT2XBltBk5skIlP9lzzYVNFSHOCtZi0BMO1Z5X5ECB2fEAGHrgLdoSDw2sd7CHjBgtcQ
         8KVw==
X-Gm-Message-State: AOAM532KQXn0TkMOFDeh8wljon0CUPk56SOsQk1WZ7LwpEvVQyxfdCyS
        zITXiF36SOnebLofnm6l0nwc4DD5jCio00skShw=
X-Google-Smtp-Source: ABdhPJytZBo1MSdgJQR4E1pp7I8o79NmgJp+1iZ9kkVh5g2Flp7S6fB9WS3GoELdTOIrJES0kkQ5rw==
X-Received: by 2002:a5d:6d0b:0:b0:20c:4ecb:1113 with SMTP id e11-20020a5d6d0b000000b0020c4ecb1113mr9615608wrq.203.1652597026001;
        Sat, 14 May 2022 23:43:46 -0700 (PDT)
Received: from alvaro-dell.. (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id l5-20020adfa385000000b0020ce015ed48sm6258440wrb.103.2022.05.14.23.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 23:43:45 -0700 (PDT)
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     netdev@vger.kernel.org
Cc:     rabeeh@solid-run.com, Alvaro Karsz <alvaro.karsz@solid-run.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v2] net: virtio_net: support interrupt coalescing
Date:   Sun, 15 May 2022 09:43:30 +0300
Message-Id: <20220515064330.75604-1-alvaro.karsz@solid-run.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Control a Virtio network device interrupt coalescing parameters
using the control virtqueue.

New VirtIO network feature: VIRTIO_NET_F_INTR_COAL.

A device that supports this fetature can receive
VIRTIO_NET_CTRL_INTR_COAL control commands.

- VIRTIO_NET_CTRL_INTR_COAL_USECS_SET:
        change the rx-usecs and tx-usecs parameters.

        rx-usecs - Time to delay an RX interrupt after packet arrival in
                microseconds.

        tx-usecs - Time to delay a TX interrupt after a sending a packet
                in microseconds.

- VIRTIO_NET_CTRL_INTR_COAL_FRAMES_SET:
        change the rx-max-frames and tx-max-frames parameters.

        rx-max-frames: Number of packets to delay an RX interrupt after
                packet arrival.

        tx-max-frames: Number of packets to delay a TX interrupt after
                sending a packet.

Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
---
v2:
        - usage of __virtio vairables.
        - send commands to device only if the values have changed.
---
 drivers/net/virtio_net.c        | 116 ++++++++++++++++++++++++++++----
 include/uapi/linux/virtio_net.h |  34 +++++++++-
 2 files changed, 136 insertions(+), 14 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index cbba9d2e8f3..e40f453edb9 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -261,6 +261,12 @@ struct virtnet_info {
 	u8 duplex;
 	u32 speed;
 
+	/* Interrupt coalescing settings */
+	u32 tx_usecs;
+	u32 rx_usecs;
+	u32 tx_frames_max;
+	u32 rx_frames_max;
+
 	unsigned long guest_offloads;
 	unsigned long guest_offloads_capable;
 
@@ -2594,19 +2600,83 @@ static int virtnet_set_coalesce(struct net_device *dev,
 {
 	struct virtnet_info *vi = netdev_priv(dev);
 	int i, napi_weight;
+	struct scatterlist sgs_usecs, sgs_frames;
+	struct virtio_net_ctrl_coal_frames c_frames;
+	struct virtio_net_ctrl_coal_usec c_usecs;
+	bool update_napi,
+	intr_coal = virtio_has_feature(vi->vdev, VIRTIO_NET_F_INTR_COAL);
+
+	/* rx_coalesce_usecs/tx_coalesce_usecs are supported only
+	 * if VIRTIO_NET_F_INTR_COAL feature is set.
+	 */
+	if (!intr_coal && (ec->rx_coalesce_usecs || ec->tx_coalesce_usecs))
+		return -EOPNOTSUPP;
 
-	if (ec->tx_max_coalesced_frames > 1 ||
-	    ec->rx_max_coalesced_frames != 1)
+	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_INTR_COAL)) {
+		/* Send usec command only if value has changed */
+		if (ec->tx_coalesce_usecs != vi->tx_usecs ||
+		    ec->rx_coalesce_usecs != vi->rx_usecs) {
+			c_usecs.tx_usecs = cpu_to_virtio32(vi->vdev, ec->tx_coalesce_usecs);
+			c_usecs.rx_usecs = cpu_to_virtio32(vi->vdev, ec->rx_coalesce_usecs);
+			sg_init_one(&sgs_usecs, &c_usecs, sizeof(c_usecs));
+
+			if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_INTR_COAL,
+						  VIRTIO_NET_CTRL_INTR_COAL_USECS_SET,
+						  &sgs_usecs))
+				return -EINVAL;
+
+			/* Save parameters */
+			vi->tx_usecs = ec->tx_coalesce_usecs;
+			vi->rx_usecs = ec->rx_coalesce_usecs;
+		}
+
+		/* Send frames command only if value has changed */
+		if (ec->tx_max_coalesced_frames != vi->tx_frames_max ||
+		    ec->rx_max_coalesced_frames != vi->rx_frames_max) {
+			c_frames.tx_frames_max = cpu_to_virtio32(vi->vdev,
+								 ec->tx_max_coalesced_frames);
+			c_frames.rx_frames_max = cpu_to_virtio32(vi->vdev,
+								 ec->rx_max_coalesced_frames);
+			sg_init_one(&sgs_frames, &c_frames, sizeof(c_frames));
+
+			if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_INTR_COAL,
+						  VIRTIO_NET_CTRL_INTR_COAL_FRAMES_SET,
+						  &sgs_frames))
+				return -EINVAL;
+
+			/* Save parameters */
+			vi->tx_frames_max = ec->tx_max_coalesced_frames;
+			vi->rx_frames_max = ec->rx_max_coalesced_frames;
+		}
+	}
+
+	/* Should we update NAPI? */
+	update_napi = ec->tx_max_coalesced_frames <= 1 &&
+			ec->rx_max_coalesced_frames == 1;
+
+	/* If interrupt coalesing feature is not set, and we can't update NAPI, return an error */
+	if (!intr_coal && !update_napi)
 		return -EINVAL;
 
-	napi_weight = ec->tx_max_coalesced_frames ? NAPI_POLL_WEIGHT : 0;
-	if (napi_weight ^ vi->sq[0].napi.weight) {
-		if (dev->flags & IFF_UP)
-			return -EBUSY;
-		for (i = 0; i < vi->max_queue_pairs; i++)
-			vi->sq[i].napi.weight = napi_weight;
+	if (update_napi) {
+		napi_weight = ec->tx_max_coalesced_frames ? NAPI_POLL_WEIGHT : 0;
+		if (napi_weight ^ vi->sq[0].napi.weight) {
+			if (dev->flags & IFF_UP) {
+				/* If Interrupt coalescing feature is not set, return an error.
+				 * Otherwise exit without changing the NAPI paremeters
+				 */
+				if (!intr_coal)
+					return -EBUSY;
+
+				goto exit;
+			}
+
+			for (i = 0; i < vi->max_queue_pairs; i++)
+				vi->sq[i].napi.weight = napi_weight;
+		}
 	}
 
+exit:
 	return 0;
 }
 
@@ -2616,14 +2686,25 @@ static int virtnet_get_coalesce(struct net_device *dev,
 				struct netlink_ext_ack *extack)
 {
 	struct ethtool_coalesce ec_default = {
-		.cmd = ETHTOOL_GCOALESCE,
-		.rx_max_coalesced_frames = 1,
+		.cmd = ETHTOOL_GCOALESCE
 	};
+
 	struct virtnet_info *vi = netdev_priv(dev);
+	bool intr_coal = virtio_has_feature(vi->vdev, VIRTIO_NET_F_INTR_COAL);
+
+	/* Add Interrupt coalescing settings */
+	if (intr_coal) {
+		ec_default.rx_coalesce_usecs = vi->rx_usecs;
+		ec_default.tx_coalesce_usecs = vi->tx_usecs;
+		ec_default.tx_max_coalesced_frames = vi->tx_frames_max;
+		ec_default.rx_max_coalesced_frames = vi->rx_frames_max;
+	} else {
+		ec_default.rx_max_coalesced_frames = 1;
+	}
 
 	memcpy(ec, &ec_default, sizeof(ec_default));
 
-	if (vi->sq[0].napi.weight)
+	if (!intr_coal && vi->sq[0].napi.weight)
 		ec->tx_max_coalesced_frames = 1;
 
 	return 0;
@@ -2743,7 +2824,7 @@ static int virtnet_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info)
 }
 
 static const struct ethtool_ops virtnet_ethtool_ops = {
-	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES,
+	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES | ETHTOOL_COALESCE_USECS,
 	.get_drvinfo = virtnet_get_drvinfo,
 	.get_link = ethtool_op_get_link,
 	.get_ringparam = virtnet_get_ringparam,
@@ -3423,6 +3504,8 @@ static bool virtnet_validate_features(struct virtio_device *vdev)
 	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS,
 			     "VIRTIO_NET_F_CTRL_VQ") ||
 	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_HASH_REPORT,
+			     "VIRTIO_NET_F_CTRL_VQ") ||
+	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_INTR_COAL,
 			     "VIRTIO_NET_F_CTRL_VQ"))) {
 		return false;
 	}
@@ -3558,6 +3641,13 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
 		vi->mergeable_rx_bufs = true;
 
+	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_INTR_COAL)) {
+		vi->rx_usecs = 0;
+		vi->tx_usecs = 0;
+		vi->tx_frames_max = 0;
+		vi->rx_frames_max = 0;
+	}
+
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_HASH_REPORT))
 		vi->has_rss_hash_report = true;
 
@@ -3786,7 +3876,7 @@ static struct virtio_device_id id_table[] = {
 	VIRTIO_NET_F_CTRL_MAC_ADDR, \
 	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
 	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
-	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT
+	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_INTR_COAL
 
 static unsigned int features[] = {
 	VIRTNET_FEATURES,
diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index 3f55a4215f1..05da9eb6ad9 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -56,7 +56,7 @@
 #define VIRTIO_NET_F_MQ	22	/* Device supports Receive Flow
 					 * Steering */
 #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
-
+#define VIRTIO_NET_F_INTR_COAL	24	/* Guest can handle Interrupt coalescing */
 #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
 #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
 #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
@@ -355,4 +355,36 @@ struct virtio_net_hash_config {
 #define VIRTIO_NET_CTRL_GUEST_OFFLOADS   5
 #define VIRTIO_NET_CTRL_GUEST_OFFLOADS_SET        0
 
+/*
+ * Control interrupt coalescing.
+ *
+ * Request the device to change the interrupt coalescing parameters.
+ *
+ * Available with the VIRTIO_NET_F_INTR_COAL feature bit.
+ */
+#define VIRTIO_NET_CTRL_INTR_COAL		6
+/*
+ * Set the rx-usecs/tx-usecs patameters.
+ * rx-usecs - Number of microseconds to delay an RX interrupt after packet arrival.
+ * tx-usecs - Number of microseconds to delay a TX interrupt after a sending a packet.
+ */
+struct virtio_net_ctrl_coal_usec {
+	__virtio32 tx_usecs;
+	__virtio32 rx_usecs;
+};
+
+#define VIRTIO_NET_CTRL_INTR_COAL_USECS_SET		0
+
+/*
+ * Set the rx-max-frames/tx-max-frames patameters.
+ * rx-max-frames - Number of packets to delay an RX interrupt after packet arrival.
+ * tx-max-frames - Number of packets to delay a TX interrupt after sending a packet.
+ */
+struct virtio_net_ctrl_coal_frames {
+	__virtio32 tx_frames_max;
+	__virtio32 rx_frames_max;
+};
+
+#define VIRTIO_NET_CTRL_INTR_COAL_FRAMES_SET		1
+
 #endif /* _UAPI_LINUX_VIRTIO_NET_H */
-- 
2.32.0

