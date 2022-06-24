Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E25558E02
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 04:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiFXC4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 22:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiFXC4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 22:56:32 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FE4356F92;
        Thu, 23 Jun 2022 19:56:30 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=37;SR=0;TI=SMTPD_---0VHF1U5t_1656039383;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VHF1U5t_1656039383)
          by smtp.aliyun-inc.com;
          Fri, 24 Jun 2022 10:56:25 +0800
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
Subject: [PATCH v10 01/41] remoteproc: rename len of rpoc_vring to num
Date:   Fri, 24 Jun 2022 10:55:41 +0800
Message-Id: <20220624025621.128843-2-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220624025621.128843-1-xuanzhuo@linux.alibaba.com>
References: <20220624025621.128843-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: fef800c86cd2
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename the member len in the structure rpoc_vring to num. And remove 'in
bytes' from the comment of it. This is misleading. Because this actually
refers to the size of the virtio vring to be created. The unit is not
bytes.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/remoteproc/remoteproc_core.c   |  4 ++--
 drivers/remoteproc/remoteproc_virtio.c | 10 +++++-----
 include/linux/remoteproc.h             |  4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 02a04ab34a23..2d2f3bab5888 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -334,7 +334,7 @@ int rproc_alloc_vring(struct rproc_vdev *rvdev, int i)
 	size_t size;
 
 	/* actual size of vring (in bytes) */
-	size = PAGE_ALIGN(vring_size(rvring->len, rvring->align));
+	size = PAGE_ALIGN(vring_size(rvring->num, rvring->align));
 
 	rsc = (void *)rproc->table_ptr + rvdev->rsc_offset;
 
@@ -401,7 +401,7 @@ rproc_parse_vring(struct rproc_vdev *rvdev, struct fw_rsc_vdev *rsc, int i)
 		return -EINVAL;
 	}
 
-	rvring->len = vring->num;
+	rvring->num = vring->num;
 	rvring->align = vring->align;
 	rvring->rvdev = rvdev;
 
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index 70ab496d0431..d43d74733f0a 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -87,7 +87,7 @@ static struct virtqueue *rp_find_vq(struct virtio_device *vdev,
 	struct fw_rsc_vdev *rsc;
 	struct virtqueue *vq;
 	void *addr;
-	int len, size;
+	int num, size;
 
 	/* we're temporarily limited to two virtqueues per rvdev */
 	if (id >= ARRAY_SIZE(rvdev->vring))
@@ -104,20 +104,20 @@ static struct virtqueue *rp_find_vq(struct virtio_device *vdev,
 
 	rvring = &rvdev->vring[id];
 	addr = mem->va;
-	len = rvring->len;
+	num = rvring->num;
 
 	/* zero vring */
-	size = vring_size(len, rvring->align);
+	size = vring_size(num, rvring->align);
 	memset(addr, 0, size);
 
 	dev_dbg(dev, "vring%d: va %pK qsz %d notifyid %d\n",
-		id, addr, len, rvring->notifyid);
+		id, addr, num, rvring->notifyid);
 
 	/*
 	 * Create the new vq, and tell virtio we're not interested in
 	 * the 'weak' smp barriers, since we're talking with a real device.
 	 */
-	vq = vring_new_virtqueue(id, len, rvring->align, vdev, false, ctx,
+	vq = vring_new_virtqueue(id, num, rvring->align, vdev, false, ctx,
 				 addr, rproc_virtio_notify, callback, name);
 	if (!vq) {
 		dev_err(dev, "vring_new_virtqueue %s failed\n", name);
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index 7c943f0a2fc4..aea79c77db0f 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -597,7 +597,7 @@ struct rproc_subdev {
 /**
  * struct rproc_vring - remoteproc vring state
  * @va:	virtual address
- * @len: length, in bytes
+ * @num: vring size
  * @da: device address
  * @align: vring alignment
  * @notifyid: rproc-specific unique vring index
@@ -606,7 +606,7 @@ struct rproc_subdev {
  */
 struct rproc_vring {
 	void *va;
-	int len;
+	int num;
 	u32 da;
 	u32 align;
 	int notifyid;
-- 
2.31.0

