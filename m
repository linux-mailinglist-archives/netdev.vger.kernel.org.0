Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E03A2496AD
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgHSHJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726991AbgHSG4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 02:56:31 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC4DC061343;
        Tue, 18 Aug 2020 23:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=aBnCCMhmfPJQnExV1s2DBfKZSvIDOCMRbawjnSzoJGk=; b=dL/QJEiqyC0wLzePNDqn1FLyYa
        YcGibj2jxbaGysYUcTWnxwV2nlop9kfpe/ElkOZJ/qnh5PPtz5IsqSIT+6J+IpUMl4yqaLfJCLvhi
        iyXYejFn/J0DlPNB9b+pg5jP9u5Xb5TJVfmwryrGUxbkfCh1aWbee1aJPxNASlHuPYlP716BqCMoD
        /RWUvxIZW91SjNx++4vCi7K0hoEBpzjmkVXdbCtPlJGsKCUpfy6qB5q2w7URlKG+ZdQrngmoRkM5V
        KoeMBat7JH2sUxCvZplLGAs9APRDmVnrMa5mRcoST8LAadj37FJs2+VA9CtlvwsYMFrvT1PJ8Aj9w
        8/OKzZRQ==;
Received: from [2001:4bb8:198:f3b2:86b6:2277:f429:37a1] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k8I0z-0008M1-Je; Wed, 19 Aug 2020 06:56:07 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-ia64@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, nouveau@lists.freedesktop.org,
        netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-mm@kvack.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 05/28] media/v4l2: remove V4L2-FLAG-MEMORY-NON-CONSISTENT
Date:   Wed, 19 Aug 2020 08:55:32 +0200
Message-Id: <20200819065555.1802761-6-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200819065555.1802761-1-hch@lst.de>
References: <20200819065555.1802761-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The V4L2-FLAG-MEMORY-NON-CONSISTENT flag is entirely unused, and causes
weird gymanstics with the DMA_ATTR_NON_CONSISTENT flag, which is
unimplemented except on PARISC and some MIPS configs, and about to be
removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 .../userspace-api/media/v4l/buffer.rst        | 17 ---------
 .../media/v4l/vidioc-reqbufs.rst              |  1 -
 .../media/common/videobuf2/videobuf2-core.c   | 36 +------------------
 .../common/videobuf2/videobuf2-dma-contig.c   | 19 ----------
 .../media/common/videobuf2/videobuf2-dma-sg.c |  3 +-
 .../media/common/videobuf2/videobuf2-v4l2.c   | 12 -------
 include/media/videobuf2-core.h                |  3 +-
 include/uapi/linux/videodev2.h                |  2 --
 8 files changed, 3 insertions(+), 90 deletions(-)

diff --git a/Documentation/userspace-api/media/v4l/buffer.rst b/Documentation/userspace-api/media/v4l/buffer.rst
index 57e752aaf414a7..2044ed13cd9d7d 100644
--- a/Documentation/userspace-api/media/v4l/buffer.rst
+++ b/Documentation/userspace-api/media/v4l/buffer.rst
@@ -701,23 +701,6 @@ Memory Consistency Flags
     :stub-columns: 0
     :widths:       3 1 4
 
-    * .. _`V4L2-FLAG-MEMORY-NON-CONSISTENT`:
-
-      - ``V4L2_FLAG_MEMORY_NON_CONSISTENT``
-      - 0x00000001
-      - A buffer is allocated either in consistent (it will be automatically
-	coherent between the CPU and the bus) or non-consistent memory. The
-	latter can provide performance gains, for instance the CPU cache
-	sync/flush operations can be avoided if the buffer is accessed by the
-	corresponding device only and the CPU does not read/write to/from that
-	buffer. However, this requires extra care from the driver -- it must
-	guarantee memory consistency by issuing a cache flush/sync when
-	consistency is needed. If this flag is set V4L2 will attempt to
-	allocate the buffer in non-consistent memory. The flag takes effect
-	only if the buffer is used for :ref:`memory mapping <mmap>` I/O and the
-	queue reports the :ref:`V4L2_BUF_CAP_SUPPORTS_MMAP_CACHE_HINTS
-	<V4L2-BUF-CAP-SUPPORTS-MMAP-CACHE-HINTS>` capability.
-
 .. c:type:: v4l2_memory
 
 enum v4l2_memory
diff --git a/Documentation/userspace-api/media/v4l/vidioc-reqbufs.rst b/Documentation/userspace-api/media/v4l/vidioc-reqbufs.rst
index 75d894d9c36c42..3180c111d368ee 100644
--- a/Documentation/userspace-api/media/v4l/vidioc-reqbufs.rst
+++ b/Documentation/userspace-api/media/v4l/vidioc-reqbufs.rst
@@ -169,7 +169,6 @@ aborting or finishing any DMA in progress, an implicit
       - This capability is set by the driver to indicate that the queue supports
         cache and memory management hints. However, it's only valid when the
         queue is used for :ref:`memory mapping <mmap>` streaming I/O. See
-        :ref:`V4L2_FLAG_MEMORY_NON_CONSISTENT <V4L2-FLAG-MEMORY-NON-CONSISTENT>`,
         :ref:`V4L2_BUF_FLAG_NO_CACHE_INVALIDATE <V4L2-BUF-FLAG-NO-CACHE-INVALIDATE>` and
         :ref:`V4L2_BUF_FLAG_NO_CACHE_CLEAN <V4L2-BUF-FLAG-NO-CACHE-CLEAN>`.
 
diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index f544d3393e9d6b..66a41cef33c1b1 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -721,39 +721,14 @@ int vb2_verify_memory_type(struct vb2_queue *q,
 }
 EXPORT_SYMBOL(vb2_verify_memory_type);
 
-static void set_queue_consistency(struct vb2_queue *q, bool consistent_mem)
-{
-	q->dma_attrs &= ~DMA_ATTR_NON_CONSISTENT;
-
-	if (!vb2_queue_allows_cache_hints(q))
-		return;
-	if (!consistent_mem)
-		q->dma_attrs |= DMA_ATTR_NON_CONSISTENT;
-}
-
-static bool verify_consistency_attr(struct vb2_queue *q, bool consistent_mem)
-{
-	bool queue_is_consistent = !(q->dma_attrs & DMA_ATTR_NON_CONSISTENT);
-
-	if (consistent_mem != queue_is_consistent) {
-		dprintk(q, 1, "memory consistency model mismatch\n");
-		return false;
-	}
-	return true;
-}
-
 int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 		     unsigned int flags, unsigned int *count)
 {
 	unsigned int num_buffers, allocated_buffers, num_planes = 0;
 	unsigned plane_sizes[VB2_MAX_PLANES] = { };
-	bool consistent_mem = true;
 	unsigned int i;
 	int ret;
 
-	if (flags & V4L2_FLAG_MEMORY_NON_CONSISTENT)
-		consistent_mem = false;
-
 	if (q->streaming) {
 		dprintk(q, 1, "streaming active\n");
 		return -EBUSY;
@@ -765,8 +740,7 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	}
 
 	if (*count == 0 || q->num_buffers != 0 ||
-	    (q->memory != VB2_MEMORY_UNKNOWN && q->memory != memory) ||
-	    !verify_consistency_attr(q, consistent_mem)) {
+	    (q->memory != VB2_MEMORY_UNKNOWN && q->memory != memory)) {
 		/*
 		 * We already have buffers allocated, so first check if they
 		 * are not in use and can be freed.
@@ -803,7 +777,6 @@ int vb2_core_reqbufs(struct vb2_queue *q, enum vb2_memory memory,
 	num_buffers = min_t(unsigned int, num_buffers, VB2_MAX_FRAME);
 	memset(q->alloc_devs, 0, sizeof(q->alloc_devs));
 	q->memory = memory;
-	set_queue_consistency(q, consistent_mem);
 
 	/*
 	 * Ask the driver how many buffers and planes per buffer it requires.
@@ -894,12 +867,8 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 {
 	unsigned int num_planes = 0, num_buffers, allocated_buffers;
 	unsigned plane_sizes[VB2_MAX_PLANES] = { };
-	bool consistent_mem = true;
 	int ret;
 
-	if (flags & V4L2_FLAG_MEMORY_NON_CONSISTENT)
-		consistent_mem = false;
-
 	if (q->num_buffers == VB2_MAX_FRAME) {
 		dprintk(q, 1, "maximum number of buffers already allocated\n");
 		return -ENOBUFS;
@@ -912,15 +881,12 @@ int vb2_core_create_bufs(struct vb2_queue *q, enum vb2_memory memory,
 		}
 		memset(q->alloc_devs, 0, sizeof(q->alloc_devs));
 		q->memory = memory;
-		set_queue_consistency(q, consistent_mem);
 		q->waiting_for_buffers = !q->is_output;
 	} else {
 		if (q->memory != memory) {
 			dprintk(q, 1, "memory model mismatch\n");
 			return -EINVAL;
 		}
-		if (!verify_consistency_attr(q, consistent_mem))
-			return -EINVAL;
 	}
 
 	num_buffers = min(*count, VB2_MAX_FRAME - q->num_buffers);
diff --git a/drivers/media/common/videobuf2/videobuf2-dma-contig.c b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
index ec3446cc45b8da..7b1b86ec942d7d 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-contig.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-contig.c
@@ -42,11 +42,6 @@ struct vb2_dc_buf {
 	struct dma_buf_attachment	*db_attach;
 };
 
-static inline bool vb2_dc_buffer_consistent(unsigned long attr)
-{
-	return !(attr & DMA_ATTR_NON_CONSISTENT);
-}
-
 /*********************************************/
 /*        scatterlist table functions        */
 /*********************************************/
@@ -341,13 +336,6 @@ static int
 vb2_dc_dmabuf_ops_begin_cpu_access(struct dma_buf *dbuf,
 				   enum dma_data_direction direction)
 {
-	struct vb2_dc_buf *buf = dbuf->priv;
-	struct sg_table *sgt = buf->dma_sgt;
-
-	if (vb2_dc_buffer_consistent(buf->attrs))
-		return 0;
-
-	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 	return 0;
 }
 
@@ -355,13 +343,6 @@ static int
 vb2_dc_dmabuf_ops_end_cpu_access(struct dma_buf *dbuf,
 				 enum dma_data_direction direction)
 {
-	struct vb2_dc_buf *buf = dbuf->priv;
-	struct sg_table *sgt = buf->dma_sgt;
-
-	if (vb2_dc_buffer_consistent(buf->attrs))
-		return 0;
-
-	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
 	return 0;
 }
 
diff --git a/drivers/media/common/videobuf2/videobuf2-dma-sg.c b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
index 0a40e00f0d7e5c..a86fce5d8ea8bf 100644
--- a/drivers/media/common/videobuf2/videobuf2-dma-sg.c
+++ b/drivers/media/common/videobuf2/videobuf2-dma-sg.c
@@ -123,8 +123,7 @@ static void *vb2_dma_sg_alloc(struct device *dev, unsigned long dma_attrs,
 	/*
 	 * NOTE: dma-sg allocates memory using the page allocator directly, so
 	 * there is no memory consistency guarantee, hence dma-sg ignores DMA
-	 * attributes passed from the upper layer. That means that
-	 * V4L2_FLAG_MEMORY_NON_CONSISTENT has no effect on dma-sg buffers.
+	 * attributes passed from the upper layer.
 	 */
 	buf->pages = kvmalloc_array(buf->num_pages, sizeof(struct page *),
 				    GFP_KERNEL | __GFP_ZERO);
diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
index 30caad27281e1a..de83ad48783821 100644
--- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
+++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
@@ -722,20 +722,11 @@ static void fill_buf_caps(struct vb2_queue *q, u32 *caps)
 #endif
 }
 
-static void clear_consistency_attr(struct vb2_queue *q,
-				   int memory,
-				   unsigned int *flags)
-{
-	if (!q->allow_cache_hints || memory != V4L2_MEMORY_MMAP)
-		*flags &= ~V4L2_FLAG_MEMORY_NON_CONSISTENT;
-}
-
 int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
 {
 	int ret = vb2_verify_memory_type(q, req->memory, req->type);
 
 	fill_buf_caps(q, &req->capabilities);
-	clear_consistency_attr(q, req->memory, &req->flags);
 	return ret ? ret : vb2_core_reqbufs(q, req->memory,
 					    req->flags, &req->count);
 }
@@ -769,7 +760,6 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create)
 	unsigned i;
 
 	fill_buf_caps(q, &create->capabilities);
-	clear_consistency_attr(q, create->memory, &create->flags);
 	create->index = q->num_buffers;
 	if (create->count == 0)
 		return ret != -EBUSY ? ret : 0;
@@ -998,7 +988,6 @@ int vb2_ioctl_reqbufs(struct file *file, void *priv,
 	int res = vb2_verify_memory_type(vdev->queue, p->memory, p->type);
 
 	fill_buf_caps(vdev->queue, &p->capabilities);
-	clear_consistency_attr(vdev->queue, p->memory, &p->flags);
 	if (res)
 		return res;
 	if (vb2_queue_is_busy(vdev, file))
@@ -1021,7 +1010,6 @@ int vb2_ioctl_create_bufs(struct file *file, void *priv,
 
 	p->index = vdev->queue->num_buffers;
 	fill_buf_caps(vdev->queue, &p->capabilities);
-	clear_consistency_attr(vdev->queue, p->memory, &p->flags);
 	/*
 	 * If count == 0, then just check if memory and type are valid.
 	 * Any -EBUSY result from vb2_verify_memory_type can be mapped to 0.
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index 52ef92049073e3..4c7f25b07e9375 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -744,8 +744,7 @@ void vb2_core_querybuf(struct vb2_queue *q, unsigned int index, void *pb);
  * vb2_core_reqbufs() - Initiate streaming.
  * @q:		pointer to &struct vb2_queue with videobuf2 queue.
  * @memory:	memory type, as defined by &enum vb2_memory.
- * @flags:	auxiliary queue/buffer management flags. Currently, the only
- *		used flag is %V4L2_FLAG_MEMORY_NON_CONSISTENT.
+ * @flags:	auxiliary queue/buffer management flags.
  * @count:	requested buffer count.
  *
  * Videobuf2 core helper to implement VIDIOC_REQBUF() operation. It is called
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index c7b70ff53bc1dd..5c00f63d9c1b58 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -191,8 +191,6 @@ enum v4l2_memory {
 	V4L2_MEMORY_DMABUF           = 4,
 };
 
-#define V4L2_FLAG_MEMORY_NON_CONSISTENT		(1 << 0)
-
 /* see also http://vektor.theorem.ca/graphics/ycbcr/ */
 enum v4l2_colorspace {
 	/*
-- 
2.28.0

