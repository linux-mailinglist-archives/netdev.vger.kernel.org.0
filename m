Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56185571872
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 13:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbiGLLWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 07:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiGLLWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 07:22:53 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F112AC7E
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:22:51 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id v16so10681372wrd.13
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 04:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bm7PIiMSm/fxmX6A16eRCP7sHUqI/l4JWYX/q9b3wYk=;
        b=T3e6Rh7ZQyr+nUH+fT2If2iP/umJekRI76AWs6Xg0vN0/B5D1yAT7taxwBeNTVE3Xv
         MqkT6867YyzJuZqwlg6YlLP8HYdHXJfW7nhejMZ3l6t37hP9x6K8olFSA8pZOLw2TWjf
         VuU5jblGygTde8fVp447tUFM75jVf7tlKKzj8JAWlaYOgbLge2nExPx8PRbfv36Y3m3q
         MXwYP3ZBJfBKhlSIqsv3G21TONG0UYNTxuIyvQY2nA9cK08eIv/LzFu04HAGFMV5LOAR
         kHEQ1kGIyIkwqWUETGYNdmLRrP+9Jaugs0xdOSUKMHeY73fzCfWlhckW1z2n48adYmCr
         GavQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bm7PIiMSm/fxmX6A16eRCP7sHUqI/l4JWYX/q9b3wYk=;
        b=aDiniEjET4kMZdXRh32/AdljVEHe0tTRldzM0M6iFvwydmke/6/rIn09fTG+iDILwc
         XpzHGS2xlU+uw3KC38j0WewtEFhVGL8RlRNgU8BbxOMqqmEnREbqwSqxxsLObXsUuFzq
         XKgssIfn4IDcCg67d+KDD+J0gMawd+n4lBVD4c/ajPsRdEioJAqulzgLryqY48jcYKua
         Knw7zSnfmE0O0kBU15WOolW7KKNYvl2Oz2/qzXGkpKNxykPZT9UzU4OdE37sxdqu4LlB
         p84u10dTMNbJf+pjX4Ki1x/vIPjby2++AlmIlGvC7MywUQJXJhRaRlG6/1XDpwAjCNKb
         h/vA==
X-Gm-Message-State: AJIora844z3bfsu2exOOefPKhAG0jtVka7C3x56j3wqJ1XmT/vlj0kT7
        nXCjTWWlXQ6Xtr52gxGX1JEv0dfnyVodPBmt
X-Google-Smtp-Source: AGRyM1v17pQ64/u87Fc29+cO6B8jda3KeAJa2lJ/aYhpkAeFA+xX0DAn4dBb/1w054ET4KDv1gV7ww==
X-Received: by 2002:a05:6000:15ca:b0:21d:a72d:beb8 with SMTP id y10-20020a05600015ca00b0021da72dbeb8mr8503835wry.624.1657624970051;
        Tue, 12 Jul 2022 04:22:50 -0700 (PDT)
Received: from alvaro-dell.. (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id o8-20020a05600c510800b003a2e2e965absm8171623wms.20.2022.07.12.04.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 04:22:49 -0700 (PDT)
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
To:     netdev@vger.kernel.org
Cc:     Alvaro Karsz <alvaro.karsz@solid-run.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH v2] net: virtio_net: notifications coalescing support
Date:   Tue, 12 Jul 2022 14:22:09 +0300
Message-Id: <20220712112210.2852777-1-alvaro.karsz@solid-run.com>
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

New VirtIO network feature: VIRTIO_NET_F_NOTF_COAL.

Control a Virtio network device notifications coalescing parameters
using the control virtqueue.

A device that supports this fetature can receive
VIRTIO_NET_CTRL_NOTF_COAL control commands.

- VIRTIO_NET_CTRL_NOTF_COAL_TX_SET:
  Ask the network device to change the following parameters:
  - tx_usecs: Maximum number of usecs to delay a TX notification.
  - tx_max_packets: Maximum number of packets to send before a
    TX notification.

- VIRTIO_NET_CTRL_NOTF_COAL_RX_SET:
  Ask the network device to change the following parameters:
  - rx_usecs: Maximum number of usecs to delay a RX notification.
  - rx_max_packets: Maximum number of packets to receive before a
    RX notification.

VirtIO spec. patch:
https://lists.oasis-open.org/archives/virtio-comment/202206/msg00100.html

Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
---
v2:
	- Fix type assignments warnings found with sparse.
	- Fix a few typos.
---
 drivers/net/virtio_net.c        | 110 ++++++++++++++++++++++++++++----
 include/uapi/linux/virtio_net.h |  34 +++++++++-
 2 files changed, 130 insertions(+), 14 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 356cf8dd416..7837db0306f 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -261,6 +261,12 @@ struct virtnet_info {
 	u8 duplex;
 	u32 speed;
 
+	/* Interrupt coalescing settings */
+	u32 tx_usecs;
+	u32 rx_usecs;
+	u32 tx_max_packets;
+	u32 rx_max_packets;
+
 	unsigned long guest_offloads;
 	unsigned long guest_offloads_capable;
 
@@ -2594,19 +2600,76 @@ static int virtnet_set_coalesce(struct net_device *dev,
 {
 	struct virtnet_info *vi = netdev_priv(dev);
 	int i, napi_weight;
+	struct scatterlist sgs_tx, sgs_rx;
+	struct virtio_net_ctrl_coal_tx coal_tx;
+	struct virtio_net_ctrl_coal_rx coal_rx;
+	bool update_napi,
+	notf_coal = virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL);
+
+	/* rx_coalesce_usecs/tx_coalesce_usecs are supported only
+	 * if VIRTIO_NET_F_NOTF_COAL feature is negotiated.
+	 */
+	if (!notf_coal && (ec->rx_coalesce_usecs || ec->tx_coalesce_usecs))
+		return -EOPNOTSUPP;
+
+	if (notf_coal) {
+		coal_tx.tx_usecs = cpu_to_le32(ec->tx_coalesce_usecs);
+		coal_tx.tx_max_packets = cpu_to_le32(ec->tx_max_coalesced_frames);
+		sg_init_one(&sgs_tx, &coal_tx, sizeof(coal_tx));
+
+		if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
+					  VIRTIO_NET_CTRL_NOTF_COAL_TX_SET,
+					  &sgs_tx))
+			return -EINVAL;
+
+		/* Save parameters */
+		vi->tx_usecs = ec->tx_coalesce_usecs;
+		vi->tx_max_packets = ec->tx_max_coalesced_frames;
+
+		coal_rx.rx_usecs = cpu_to_le32(ec->rx_coalesce_usecs);
+		coal_rx.rx_max_packets = cpu_to_le32(ec->rx_max_coalesced_frames);
+		sg_init_one(&sgs_rx, &coal_rx, sizeof(coal_rx));
+
+		if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
+					  VIRTIO_NET_CTRL_NOTF_COAL_RX_SET,
+					  &sgs_rx))
+			return -EINVAL;
+
+		/* Save parameters */
+		vi->rx_usecs = ec->rx_coalesce_usecs;
+		vi->rx_max_packets = ec->rx_max_coalesced_frames;
+	}
+
+	/* Should we update NAPI? */
+	update_napi = ec->tx_max_coalesced_frames <= 1 &&
+			ec->rx_max_coalesced_frames == 1;
 
-	if (ec->tx_max_coalesced_frames > 1 ||
-	    ec->rx_max_coalesced_frames != 1)
+	/* If notifications coalesing feature is not negotiated,
+	 * and we can't update NAPI, return an error
+	 */
+	if (!notf_coal && !update_napi)
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
+				/* If notifications coalescing feature is not negotiated,
+				 * return an error, otherwise exit without changing
+				 * the NAPI parameters.
+				 */
+				if (!notf_coal)
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
 
@@ -2616,14 +2679,25 @@ static int virtnet_get_coalesce(struct net_device *dev,
 				struct netlink_ext_ack *extack)
 {
 	struct ethtool_coalesce ec_default = {
-		.cmd = ETHTOOL_GCOALESCE,
-		.rx_max_coalesced_frames = 1,
+		.cmd = ETHTOOL_GCOALESCE
 	};
+
 	struct virtnet_info *vi = netdev_priv(dev);
+	bool notf_coal = virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL);
+
+	/* Add notifications coalescing settings */
+	if (notf_coal) {
+		ec_default.rx_coalesce_usecs = vi->rx_usecs;
+		ec_default.tx_coalesce_usecs = vi->tx_usecs;
+		ec_default.tx_max_coalesced_frames = vi->tx_max_packets;
+		ec_default.rx_max_coalesced_frames = vi->rx_max_packets;
+	} else {
+		ec_default.rx_max_coalesced_frames = 1;
+	}
 
 	memcpy(ec, &ec_default, sizeof(ec_default));
 
-	if (vi->sq[0].napi.weight)
+	if (!notf_coal && vi->sq[0].napi.weight)
 		ec->tx_max_coalesced_frames = 1;
 
 	return 0;
@@ -2743,7 +2817,8 @@ static int virtnet_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info)
 }
 
 static const struct ethtool_ops virtnet_ethtool_ops = {
-	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES,
+	.supported_coalesce_params = ETHTOOL_COALESCE_MAX_FRAMES |
+		ETHTOOL_COALESCE_USECS,
 	.get_drvinfo = virtnet_get_drvinfo,
 	.get_link = ethtool_op_get_link,
 	.get_ringparam = virtnet_get_ringparam,
@@ -3411,6 +3486,8 @@ static bool virtnet_validate_features(struct virtio_device *vdev)
 	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_RSS,
 			     "VIRTIO_NET_F_CTRL_VQ") ||
 	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_HASH_REPORT,
+			     "VIRTIO_NET_F_CTRL_VQ") ||
+	     VIRTNET_FAIL_ON(vdev, VIRTIO_NET_F_NOTF_COAL,
 			     "VIRTIO_NET_F_CTRL_VQ"))) {
 		return false;
 	}
@@ -3546,6 +3623,13 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
 		vi->mergeable_rx_bufs = true;
 
+	if (virtio_has_feature(vi->vdev, VIRTIO_NET_F_NOTF_COAL)) {
+		vi->rx_usecs = 0;
+		vi->tx_usecs = 0;
+		vi->tx_max_packets = 0;
+		vi->rx_max_packets = 0;
+	}
+
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_HASH_REPORT))
 		vi->has_rss_hash_report = true;
 
@@ -3780,7 +3864,7 @@ static struct virtio_device_id id_table[] = {
 	VIRTIO_NET_F_CTRL_MAC_ADDR, \
 	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
 	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
-	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT
+	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL
 
 static unsigned int features[] = {
 	VIRTNET_FEATURES,
diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
index 3f55a4215f1..29ced55514d 100644
--- a/include/uapi/linux/virtio_net.h
+++ b/include/uapi/linux/virtio_net.h
@@ -56,7 +56,7 @@
 #define VIRTIO_NET_F_MQ	22	/* Device supports Receive Flow
 					 * Steering */
 #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
-
+#define VIRTIO_NET_F_NOTF_COAL	53	/* Guest can handle notifications coalescing */
 #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
 #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
 #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
@@ -355,4 +355,36 @@ struct virtio_net_hash_config {
 #define VIRTIO_NET_CTRL_GUEST_OFFLOADS   5
 #define VIRTIO_NET_CTRL_GUEST_OFFLOADS_SET        0
 
+/*
+ * Control notifications coalescing.
+ *
+ * Request the device to change the notifications coalescing parameters.
+ *
+ * Available with the VIRTIO_NET_F_NOTF_COAL feature bit.
+ */
+#define VIRTIO_NET_CTRL_NOTF_COAL		6
+/*
+ * Set the tx-usecs/tx-max-packets patameters.
+ * tx-usecs - Maximum number of usecs to delay a TX notification.
+ * tx-max-packets - Maximum number of packets to send before a TX notification.
+ */
+struct virtio_net_ctrl_coal_tx {
+	__le32 tx_max_packets;
+	__le32 tx_usecs;
+};
+
+#define VIRTIO_NET_CTRL_NOTF_COAL_TX_SET		0
+
+/*
+ * Set the rx-usecs/rx-max-packets patameters.
+ * rx-usecs - Maximum number of usecs to delay a RX notification.
+ * rx-max-frames - Maximum number of packets to receive before a RX notification.
+ */
+struct virtio_net_ctrl_coal_rx {
+	__le32 rx_max_packets;
+	__le32 rx_usecs;
+};
+
+#define VIRTIO_NET_CTRL_NOTF_COAL_RX_SET		1
+
 #endif /* _UAPI_LINUX_VIRTIO_NET_H */
-- 
2.32.0

