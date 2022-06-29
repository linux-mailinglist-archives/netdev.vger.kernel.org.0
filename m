Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D593F55F825
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 09:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbiF2G7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 02:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiF2G6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 02:58:54 -0400
Received: from out199-3.us.a.mail.aliyun.com (out199-3.us.a.mail.aliyun.com [47.90.199.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75349344F5;
        Tue, 28 Jun 2022 23:57:53 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0VHmddo1_1656485866;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VHmddo1_1656485866)
          by smtp.aliyun-inc.com;
          Wed, 29 Jun 2022 14:57:47 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org
Cc:     Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, bpf@vger.kernel.org,
        kangjie.xu@linux.alibaba.com
Subject: [PATCH v11 23/40] virtio_pci: move struct virtio_pci_common_cfg to virtio_pci_modern.h
Date:   Wed, 29 Jun 2022 14:56:39 +0800
Message-Id: <20220629065656.54420-24-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
References: <20220629065656.54420-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: 3fdaf102dd89
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to facilitate the expansion of virtio_pci_common_cfg in the
future, move it from uapi to virtio_pci_modern.h. In this way, we can
freely expand virtio_pci_common_cfg in the future.

Other projects using virtio_pci_common_cfg in uapi need to maintain a
separate virtio_pci_common_cfg or use the offset macro defined in uapi.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 include/linux/virtio_pci_modern.h | 26 ++++++++++++++++++++++++++
 include/uapi/linux/virtio_pci.h   | 26 --------------------------
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/linux/virtio_pci_modern.h b/include/linux/virtio_pci_modern.h
index eb2bd9b4077d..c4f7ffbacb4e 100644
--- a/include/linux/virtio_pci_modern.h
+++ b/include/linux/virtio_pci_modern.h
@@ -5,6 +5,32 @@
 #include <linux/pci.h>
 #include <linux/virtio_pci.h>
 
+/* Fields in VIRTIO_PCI_CAP_COMMON_CFG: */
+struct virtio_pci_common_cfg {
+	/* About the whole device. */
+	__le32 device_feature_select;	/* read-write */
+	__le32 device_feature;		/* read-only */
+	__le32 guest_feature_select;	/* read-write */
+	__le32 guest_feature;		/* read-write */
+	__le16 msix_config;		/* read-write */
+	__le16 num_queues;		/* read-only */
+	__u8 device_status;		/* read-write */
+	__u8 config_generation;		/* read-only */
+
+	/* About a specific virtqueue. */
+	__le16 queue_select;		/* read-write */
+	__le16 queue_size;		/* read-write, power of 2. */
+	__le16 queue_msix_vector;	/* read-write */
+	__le16 queue_enable;		/* read-write */
+	__le16 queue_notify_off;	/* read-only */
+	__le32 queue_desc_lo;		/* read-write */
+	__le32 queue_desc_hi;		/* read-write */
+	__le32 queue_avail_lo;		/* read-write */
+	__le32 queue_avail_hi;		/* read-write */
+	__le32 queue_used_lo;		/* read-write */
+	__le32 queue_used_hi;		/* read-write */
+};
+
 struct virtio_pci_modern_device {
 	struct pci_dev *pci_dev;
 
diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
index 3a86f36d7e3d..247ec42af2c8 100644
--- a/include/uapi/linux/virtio_pci.h
+++ b/include/uapi/linux/virtio_pci.h
@@ -140,32 +140,6 @@ struct virtio_pci_notify_cap {
 	__le32 notify_off_multiplier;	/* Multiplier for queue_notify_off. */
 };
 
-/* Fields in VIRTIO_PCI_CAP_COMMON_CFG: */
-struct virtio_pci_common_cfg {
-	/* About the whole device. */
-	__le32 device_feature_select;	/* read-write */
-	__le32 device_feature;		/* read-only */
-	__le32 guest_feature_select;	/* read-write */
-	__le32 guest_feature;		/* read-write */
-	__le16 msix_config;		/* read-write */
-	__le16 num_queues;		/* read-only */
-	__u8 device_status;		/* read-write */
-	__u8 config_generation;		/* read-only */
-
-	/* About a specific virtqueue. */
-	__le16 queue_select;		/* read-write */
-	__le16 queue_size;		/* read-write, power of 2. */
-	__le16 queue_msix_vector;	/* read-write */
-	__le16 queue_enable;		/* read-write */
-	__le16 queue_notify_off;	/* read-only */
-	__le32 queue_desc_lo;		/* read-write */
-	__le32 queue_desc_hi;		/* read-write */
-	__le32 queue_avail_lo;		/* read-write */
-	__le32 queue_avail_hi;		/* read-write */
-	__le32 queue_used_lo;		/* read-write */
-	__le32 queue_used_hi;		/* read-write */
-};
-
 /* Fields in VIRTIO_PCI_CAP_PCI_CFG: */
 struct virtio_pci_cfg_cap {
 	struct virtio_pci_cap cap;
-- 
2.31.0

