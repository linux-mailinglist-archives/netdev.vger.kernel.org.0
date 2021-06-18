Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA7F3AC881
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 12:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233070AbhFRKNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 06:13:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52088 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232735AbhFRKNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 06:13:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624011085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TSIUg92H7zaLnJ9BAtsDe913a1rAGV+hKgbZlsolGdg=;
        b=i8hZBEzMCq36iTH3hyB5fwtH8SBkFvLrJ/iDX2njLgIQ0CAsmwS2rfobsrDHwWZzIIcFNa
        C6QMqy9kb5ocIhwTt1zg69SP/Y8nVV0i5CwhJHF7UqiGNVxHRAWgh1g1kSjKjrcee0Mxg/
        3jEckUhXiCGcAlrHN+4LKbiDABN59J8=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-E6PJ1OXNNeqT-sZshCmO4g-1; Fri, 18 Jun 2021 06:11:24 -0400
X-MC-Unique: E6PJ1OXNNeqT-sZshCmO4g-1
Received: by mail-ej1-f70.google.com with SMTP id de48-20020a1709069bf0b029048ae3ebecabso118259ejc.16
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 03:11:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TSIUg92H7zaLnJ9BAtsDe913a1rAGV+hKgbZlsolGdg=;
        b=hHf3xdFeEITKc88cp4+xe5Jwch1k3MZwgFaimvl4TYjQruFcJTN08JlWDwXCdT30FC
         obO+1XUMjt5VQrkh03ZvU2yrXa8Da9l0SLQ7Fp/+Erlyi897hA06CM+6qOzwK1t4M6Po
         oZeJtfc9aGJfcQ2tFcA+XUvfOjJ4bs5Arjh9GXOt4o0lr9u704GtLqnvrAnt3gGJvj7x
         QxCQRUxEARJDVsrYgaYqWOo9xeCDo6VoaHl8FdmMeXCLJzBHUyH2UC5vq1/qzJ4/rdnW
         QbJuWRY2RzJpF0McJMnjH+r04p/GrcX9QDYopUG2VnbeSygR4TTSerC9CAyi+7dytZaW
         gFdQ==
X-Gm-Message-State: AOAM532YsQGUrBXdXtgg1p1OgMLbg3HryUpSocK/NRbkCr9C7jyUyYq9
        CJ3Bb6DUqKZN2rrA7oDt6iPMarRLeX3WwX7fDeZvdrfBNP5+YjDW99id99/21ZMHmX72yvN4Xvh
        9aBuBul3fkcC5GCle
X-Received: by 2002:a17:906:b0c4:: with SMTP id bk4mr10309295ejb.422.1624011082552;
        Fri, 18 Jun 2021 03:11:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzhj1BfWHFZCWCjexVjfPIa6iY1FgMty9T+uLO2LQraq71Z6UeZiTfrbKIKqyu7F/TtMz3ohA==
X-Received: by 2002:a17:906:b0c4:: with SMTP id bk4mr10309266ejb.422.1624011082325;
        Fri, 18 Jun 2021 03:11:22 -0700 (PDT)
Received: from steredhat.lan ([5.170.128.252])
        by smtp.gmail.com with ESMTPSA id g12sm3067250edb.80.2021.06.18.03.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 03:11:21 -0700 (PDT)
Date:   Fri, 18 Jun 2021 12:11:17 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jiang Wang <jiang.wang@bytedance.com>
Cc:     virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        mst@redhat.com, arseny.krasnov@kaspersky.com,
        jhansen@vmware.comments, cong.wang@bytedance.com,
        duanxiongchun@bytedance.com, xieyongji@bytedance.com,
        chaiwen.cc@bytedance.com, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v1 2/6] virtio/vsock: add support for virtio datagram
Message-ID: <20210618101117.arq5epgg5km2sygr@steredhat.lan>
References: <20210609232501.171257-1-jiang.wang@bytedance.com>
 <20210609232501.171257-3-jiang.wang@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210609232501.171257-3-jiang.wang@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 11:24:54PM +0000, Jiang Wang wrote:
>This patch add support for virtio dgram for the driver.
>Implemented related functions for tx and rx, enqueue
>and dequeue. Send packets synchronously to give sender
>indication when the virtqueue is full.
>Refactored virtio_transport_send_pkt_work() a little bit but
>no functions changes for it.
>
>Support for the host/device side is in another
>patch.
>
>Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
>---
> include/net/af_vsock.h                             |   1 +
> .../trace/events/vsock_virtio_transport_common.h   |   5 +-
> include/uapi/linux/virtio_vsock.h                  |   1 +
> net/vmw_vsock/af_vsock.c                           |  12 +
> net/vmw_vsock/virtio_transport.c                   | 325 ++++++++++++++++++---
> net/vmw_vsock/virtio_transport_common.c            | 184 ++++++++++--
> 6 files changed, 466 insertions(+), 62 deletions(-)
>
>diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
>index b1c717286993..fcae7bca9609 100644
>--- a/include/net/af_vsock.h
>+++ b/include/net/af_vsock.h
>@@ -200,6 +200,7 @@ void vsock_remove_sock(struct vsock_sock *vsk);
> void vsock_for_each_connected_socket(void (*fn)(struct sock *sk));
> int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk);
> bool vsock_find_cid(unsigned int cid);
>+int vsock_bind_stream(struct vsock_sock *vsk, struct sockaddr_vm *addr);
>
> /**** TAP ****/
>
>diff --git a/include/trace/events/vsock_virtio_transport_common.h b/include/trace/events/vsock_virtio_transport_common.h
>index 6782213778be..b1be25b327a1 100644
>--- a/include/trace/events/vsock_virtio_transport_common.h
>+++ b/include/trace/events/vsock_virtio_transport_common.h
>@@ -9,9 +9,12 @@
> #include <linux/tracepoint.h>
>
> TRACE_DEFINE_ENUM(VIRTIO_VSOCK_TYPE_STREAM);
>+TRACE_DEFINE_ENUM(VIRTIO_VSOCK_TYPE_DGRAM);
>
> #define show_type(val) \
>-	__print_symbolic(val, { VIRTIO_VSOCK_TYPE_STREAM, "STREAM" })
>+	 __print_symbolic(val, \
>+					{ VIRTIO_VSOCK_TYPE_STREAM, "STREAM" }, \
>+					{ VIRTIO_VSOCK_TYPE_DGRAM, "DGRAM" })
>
> TRACE_DEFINE_ENUM(VIRTIO_VSOCK_OP_INVALID);
> TRACE_DEFINE_ENUM(VIRTIO_VSOCK_OP_REQUEST);
>diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>index b56614dff1c9..5503585b26e8 100644
>--- a/include/uapi/linux/virtio_vsock.h
>+++ b/include/uapi/linux/virtio_vsock.h
>@@ -68,6 +68,7 @@ struct virtio_vsock_hdr {
>
> enum virtio_vsock_type {
> 	VIRTIO_VSOCK_TYPE_STREAM = 1,
>+	VIRTIO_VSOCK_TYPE_DGRAM = 3,
> };
>
> enum virtio_vsock_op {
>diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
>index 92a72f0e0d94..c1f512291b94 100644
>--- a/net/vmw_vsock/af_vsock.c
>+++ b/net/vmw_vsock/af_vsock.c
>@@ -659,6 +659,18 @@ static int __vsock_bind_stream(struct vsock_sock *vsk,
> 	return 0;
> }
>
>+int vsock_bind_stream(struct vsock_sock *vsk,
>+				       struct sockaddr_vm *addr)
>+{
>+	int retval;
>+
>+	spin_lock_bh(&vsock_table_lock);
>+	retval = __vsock_bind_stream(vsk, addr);
>+	spin_unlock_bh(&vsock_table_lock);
>+	return retval;
>+}
>+EXPORT_SYMBOL(vsock_bind_stream);
>+
> static int __vsock_bind_dgram(struct vsock_sock *vsk,
> 			      struct sockaddr_vm *addr)
> {
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 7dcb8db23305..cf47aadb0c34 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -20,21 +20,29 @@
> #include <net/sock.h>
> #include <linux/mutex.h>
> #include <net/af_vsock.h>
>+#include<linux/kobject.h>
>+#include<linux/sysfs.h>
>+#include <linux/refcount.h>
>
> static struct workqueue_struct *virtio_vsock_workqueue;
> static struct virtio_vsock __rcu *the_virtio_vsock;
>+static struct virtio_vsock *the_virtio_vsock_dgram;
> static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
>
> struct virtio_vsock {
> 	struct virtio_device *vdev;
> 	struct virtqueue **vqs;
> 	bool has_dgram;
>+	refcount_t active;
>
> 	/* Virtqueue processing is deferred to a workqueue */
> 	struct work_struct tx_work;
> 	struct work_struct rx_work;
> 	struct work_struct event_work;
>
>+	struct work_struct dgram_tx_work;
>+	struct work_struct dgram_rx_work;
>+
> 	/* The following fields are protected by tx_lock.  vqs[VSOCK_VQ_TX]
> 	 * must be accessed with tx_lock held.
> 	 */
>@@ -55,6 +63,22 @@ struct virtio_vsock {
> 	int rx_buf_nr;
> 	int rx_buf_max_nr;
>
>+	/* The following fields are protected by dgram_tx_lock.  vqs[VSOCK_VQ_DGRAM_TX]
>+	 * must be accessed with dgram_tx_lock held.
>+	 */
>+	struct mutex dgram_tx_lock;
>+	bool dgram_tx_run;
>+
>+	atomic_t dgram_queued_replies;
>+
>+	/* The following fields are protected by dgram_rx_lock.  vqs[VSOCK_VQ_DGRAM_RX]
>+	 * must be accessed with dgram_rx_lock held.
>+	 */
>+	struct mutex dgram_rx_lock;
>+	bool dgram_rx_run;
>+	int dgram_rx_buf_nr;
>+	int dgram_rx_buf_max_nr;
>+
> 	/* The following fields are protected by event_lock.
> 	 * vqs[VSOCK_VQ_EVENT] must be accessed with event_lock held.
> 	 */
>@@ -83,21 +107,11 @@ static u32 virtio_transport_get_local_cid(void)
> 	return ret;
> }
>
>-static void
>-virtio_transport_send_pkt_work(struct work_struct *work)
>+static void virtio_transport_do_send_pkt(struct virtio_vsock *vsock,
>+		struct virtqueue *vq,  spinlock_t *lock, struct list_head *send_pkt_list,
>+		bool *restart_rx)
> {
>-	struct virtio_vsock *vsock =
>-		container_of(work, struct virtio_vsock, send_pkt_work);
>-	struct virtqueue *vq;
> 	bool added = false;
>-	bool restart_rx = false;
>-
>-	mutex_lock(&vsock->tx_lock);
>-
>-	if (!vsock->tx_run)
>-		goto out;
>-
>-	vq = vsock->vqs[VSOCK_VQ_TX];
>
> 	for (;;) {
> 		struct virtio_vsock_pkt *pkt;
>@@ -105,16 +119,16 @@ virtio_transport_send_pkt_work(struct work_struct *work)
> 		int ret, in_sg = 0, out_sg = 0;
> 		bool reply;
>
>-		spin_lock_bh(&vsock->send_pkt_list_lock);
>-		if (list_empty(&vsock->send_pkt_list)) {
>-			spin_unlock_bh(&vsock->send_pkt_list_lock);
>+		spin_lock_bh(lock);
>+		if (list_empty(send_pkt_list)) {
>+			spin_unlock_bh(lock);
> 			break;
> 		}
>
>-		pkt = list_first_entry(&vsock->send_pkt_list,
>+		pkt = list_first_entry(send_pkt_list,
> 				       struct virtio_vsock_pkt, list);
> 		list_del_init(&pkt->list);
>-		spin_unlock_bh(&vsock->send_pkt_list_lock);
>+		spin_unlock_bh(lock);
>
> 		virtio_transport_deliver_tap_pkt(pkt);
>
>@@ -132,9 +146,9 @@ virtio_transport_send_pkt_work(struct work_struct *work)
> 		 * the vq
> 		 */
> 		if (ret < 0) {
>-			spin_lock_bh(&vsock->send_pkt_list_lock);
>-			list_add(&pkt->list, &vsock->send_pkt_list);
>-			spin_unlock_bh(&vsock->send_pkt_list_lock);
>+			spin_lock_bh(lock);
>+			list_add(&pkt->list, send_pkt_list);
>+			spin_unlock_bh(lock);
> 			break;
> 		}
>
>@@ -146,7 +160,7 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>
> 			/* Do we now have resources to resume rx processing? */
> 			if (val + 1 == virtqueue_get_vring_size(rx_vq))
>-				restart_rx = true;
>+				*restart_rx = true;
> 		}
>
> 		added = true;
>@@ -154,7 +168,55 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>
> 	if (added)
> 		virtqueue_kick(vq);
>+}
>
>+static int virtio_transport_do_send_dgram_pkt(struct virtio_vsock *vsock,
>+		struct virtqueue *vq, struct virtio_vsock_pkt *pkt)
>+{
>+	struct scatterlist hdr, buf, *sgs[2];
>+	int ret, in_sg = 0, out_sg = 0;
>+
>+	virtio_transport_deliver_tap_pkt(pkt);
>+
>+	sg_init_one(&hdr, &pkt->hdr, sizeof(pkt->hdr));
>+	sgs[out_sg++] = &hdr;
>+	if (pkt->buf) {
>+		sg_init_one(&buf, pkt->buf, pkt->len);
>+		sgs[out_sg++] = &buf;
>+	}
>+
>+	ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, pkt, GFP_KERNEL);
>+	/* Usually this means that there is no more space available in
>+	 * the vq
>+	 */
>+	if (ret < 0) {
>+		virtio_transport_free_pkt(pkt);
>+		return -ENOMEM;
>+	}
>+
>+	virtqueue_kick(vq);
>+
>+	return pkt->len;
>+}
>+
>+
>+static void
>+virtio_transport_send_pkt_work(struct work_struct *work)
>+{
>+	struct virtio_vsock *vsock =
>+		container_of(work, struct virtio_vsock, send_pkt_work);
>+	struct virtqueue *vq;
>+	bool restart_rx = false;
>+
>+	mutex_lock(&vsock->tx_lock);
>+
>+	if (!vsock->tx_run)
>+		goto out;
>+
>+	vq = vsock->vqs[VSOCK_VQ_TX];
>+
>+	virtio_transport_do_send_pkt(vsock, vq, &vsock->send_pkt_list_lock,
>+							&vsock->send_pkt_list, &restart_rx);
> out:
> 	mutex_unlock(&vsock->tx_lock);
>
>@@ -163,11 +225,64 @@ virtio_transport_send_pkt_work(struct work_struct *work)
> }
>
> static int
>+virtio_transport_send_dgram_pkt(struct virtio_vsock_pkt *pkt)
>+{
>+	struct virtio_vsock *vsock;
>+	int len = pkt->len;
>+	struct virtqueue *vq;
>+
>+	vsock = the_virtio_vsock_dgram;
>+
>+	if (!vsock) {
>+		virtio_transport_free_pkt(pkt);
>+		return -ENODEV;
>+	}
>+
>+	if (!vsock->dgram_tx_run) {
>+		virtio_transport_free_pkt(pkt);
>+		return -ENODEV;
>+	}
>+
>+	if (!refcount_inc_not_zero(&vsock->active)) {
>+		virtio_transport_free_pkt(pkt);
>+		return -ENODEV;
>+	}
>+
>+	if (le64_to_cpu(pkt->hdr.dst_cid) == vsock->guest_cid) {
>+		virtio_transport_free_pkt(pkt);
>+		len = -ENODEV;
>+		goto out_ref;
>+	}
>+
>+	/* send the pkt */
>+	mutex_lock(&vsock->dgram_tx_lock);
>+
>+	if (!vsock->dgram_tx_run)
>+		goto out_mutex;
>+
>+	vq = vsock->vqs[VSOCK_VQ_DGRAM_TX];
>+
>+	len = virtio_transport_do_send_dgram_pkt(vsock, vq, pkt);
>+
>+out_mutex:
>+	mutex_unlock(&vsock->dgram_tx_lock);
>+
>+out_ref:
>+	if (!refcount_dec_not_one(&vsock->active))
>+		return -EFAULT;
>+
>+	return len;
>+}
>+
>+static int
> virtio_transport_send_pkt(struct virtio_vsock_pkt *pkt)
> {
> 	struct virtio_vsock *vsock;
> 	int len = pkt->len;
>
>+	if (pkt->hdr.type == VIRTIO_VSOCK_TYPE_DGRAM)
>+		return virtio_transport_send_dgram_pkt(pkt);
>+
> 	rcu_read_lock();
> 	vsock = rcu_dereference(the_virtio_vsock);
> 	if (!vsock) {
>@@ -243,7 +358,7 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
> 	return ret;
> }
>
>-static void virtio_vsock_rx_fill(struct virtio_vsock *vsock)
>+static void virtio_vsock_rx_fill(struct virtio_vsock *vsock, bool is_dgram)
> {
> 	int buf_len = VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE;
> 	struct virtio_vsock_pkt *pkt;
>@@ -251,7 +366,10 @@ static void virtio_vsock_rx_fill(struct virtio_vsock *vsock)
> 	struct virtqueue *vq;
> 	int ret;
>
>-	vq = vsock->vqs[VSOCK_VQ_RX];
>+	if (is_dgram)
>+		vq = vsock->vqs[VSOCK_VQ_DGRAM_RX];
>+	else
>+		vq = vsock->vqs[VSOCK_VQ_RX];
>
> 	do {
> 		pkt = kzalloc(sizeof(*pkt), GFP_KERNEL);
>@@ -277,10 +395,19 @@ static void virtio_vsock_rx_fill(struct virtio_vsock *vsock)
> 			virtio_transport_free_pkt(pkt);
> 			break;
> 		}
>-		vsock->rx_buf_nr++;
>+		if (is_dgram)
>+			vsock->dgram_rx_buf_nr++;
>+		else
>+			vsock->rx_buf_nr++;
> 	} while (vq->num_free);
>-	if (vsock->rx_buf_nr > vsock->rx_buf_max_nr)
>-		vsock->rx_buf_max_nr = vsock->rx_buf_nr;
>+	if (is_dgram) {
>+		if (vsock->dgram_rx_buf_nr > vsock->dgram_rx_buf_max_nr)
>+			vsock->dgram_rx_buf_max_nr = vsock->dgram_rx_buf_nr;
>+	} else {
>+		if (vsock->rx_buf_nr > vsock->rx_buf_max_nr)
>+			vsock->rx_buf_max_nr = vsock->rx_buf_nr;
>+	}
>+
> 	virtqueue_kick(vq);
> }
>
>@@ -315,6 +442,34 @@ static void virtio_transport_tx_work(struct work_struct *work)
> 		queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
> }
>
>+static void virtio_transport_dgram_tx_work(struct work_struct *work)
>+{
>+	struct virtio_vsock *vsock =
>+		container_of(work, struct virtio_vsock, dgram_tx_work);
>+	struct virtqueue *vq;
>+	bool added = false;
>+
>+	vq = vsock->vqs[VSOCK_VQ_DGRAM_TX];
>+	mutex_lock(&vsock->dgram_tx_lock);
>+
>+	if (!vsock->dgram_tx_run)
>+		goto out;
>+
>+	do {
>+		struct virtio_vsock_pkt *pkt;
>+		unsigned int len;
>+
>+		virtqueue_disable_cb(vq);
>+		while ((pkt = virtqueue_get_buf(vq, &len)) != NULL) {
>+			virtio_transport_free_pkt(pkt);
>+			added = true;
>+		}
>+	} while (!virtqueue_enable_cb(vq));
>+
>+out:
>+	mutex_unlock(&vsock->dgram_tx_lock);
>+}
>+
> /* Is there space left for replies to rx packets? */
> static bool virtio_transport_more_replies(struct virtio_vsock *vsock)
> {
>@@ -449,6 +604,11 @@ static void virtio_vsock_tx_done(struct virtqueue *vq)
>
> static void virtio_vsock_dgram_tx_done(struct virtqueue *vq)
> {
>+	struct virtio_vsock *vsock = vq->vdev->priv;
>+
>+	if (!vsock)
>+		return;
>+	queue_work(virtio_vsock_workqueue, &vsock->dgram_tx_work);
> }
>
> static void virtio_vsock_rx_done(struct virtqueue *vq)
>@@ -462,8 +622,12 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
>
> static void virtio_vsock_dgram_rx_done(struct virtqueue *vq)
> {
>-}
>+	struct virtio_vsock *vsock = vq->vdev->priv;
>
>+	if (!vsock)
>+		return;
>+	queue_work(virtio_vsock_workqueue, &vsock->dgram_rx_work);
>+}
> static struct virtio_transport virtio_transport = {
> 	.transport = {
> 		.module                   = THIS_MODULE,
>@@ -506,19 +670,9 @@ static struct virtio_transport virtio_transport = {
> 	.send_pkt = virtio_transport_send_pkt,
> };
>
>-static void virtio_transport_rx_work(struct work_struct *work)
>+static void virtio_transport_do_rx_work(struct virtio_vsock *vsock,
>+						struct virtqueue *vq, bool is_dgram)
> {
>-	struct virtio_vsock *vsock =
>-		container_of(work, struct virtio_vsock, rx_work);
>-	struct virtqueue *vq;
>-
>-	vq = vsock->vqs[VSOCK_VQ_RX];
>-
>-	mutex_lock(&vsock->rx_lock);
>-
>-	if (!vsock->rx_run)
>-		goto out;
>-
> 	do {
> 		virtqueue_disable_cb(vq);
> 		for (;;) {
>@@ -538,7 +692,10 @@ static void virtio_transport_rx_work(struct work_struct *work)
> 				break;
> 			}
>
>-			vsock->rx_buf_nr--;
>+			if (is_dgram)
>+				vsock->dgram_rx_buf_nr--;
>+			else
>+				vsock->rx_buf_nr--;
>
> 			/* Drop short/long packets */
> 			if (unlikely(len < sizeof(pkt->hdr) ||
>@@ -554,11 +711,45 @@ static void virtio_transport_rx_work(struct work_struct *work)
> 	} while (!virtqueue_enable_cb(vq));
>
> out:
>+	return;
>+}
>+
>+static void virtio_transport_rx_work(struct work_struct *work)
>+{
>+	struct virtio_vsock *vsock =
>+		container_of(work, struct virtio_vsock, rx_work);
>+	struct virtqueue *vq;
>+
>+	vq = vsock->vqs[VSOCK_VQ_RX];
>+
>+	mutex_lock(&vsock->rx_lock);
>+
>+	if (vsock->rx_run)
>+		virtio_transport_do_rx_work(vsock, vq, false);
>+
> 	if (vsock->rx_buf_nr < vsock->rx_buf_max_nr / 2)
>-		virtio_vsock_rx_fill(vsock);
>+		virtio_vsock_rx_fill(vsock, false);
> 	mutex_unlock(&vsock->rx_lock);
> }
>
>+static void virtio_transport_dgram_rx_work(struct work_struct *work)
>+{
>+	struct virtio_vsock *vsock =
>+		container_of(work, struct virtio_vsock, dgram_rx_work);
>+	struct virtqueue *vq;
>+
>+	vq = vsock->vqs[VSOCK_VQ_DGRAM_RX];
>+
>+	mutex_lock(&vsock->dgram_rx_lock);
>+
>+	if (vsock->dgram_rx_run)
>+		virtio_transport_do_rx_work(vsock, vq, true);
>+
>+	if (vsock->dgram_rx_buf_nr < vsock->dgram_rx_buf_max_nr / 2)
>+		virtio_vsock_rx_fill(vsock, true);
>+	mutex_unlock(&vsock->dgram_rx_lock);
>+}
>+
> static int virtio_vsock_probe(struct virtio_device *vdev)
> {
> 	vq_callback_t *callbacks[] = {
>@@ -642,8 +833,14 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> 	vsock->rx_buf_max_nr = 0;
> 	atomic_set(&vsock->queued_replies, 0);
>
>+	vsock->dgram_rx_buf_nr = 0;
>+	vsock->dgram_rx_buf_max_nr = 0;
>+	atomic_set(&vsock->dgram_queued_replies, 0);
>+
> 	mutex_init(&vsock->tx_lock);
> 	mutex_init(&vsock->rx_lock);
>+	mutex_init(&vsock->dgram_tx_lock);
>+	mutex_init(&vsock->dgram_rx_lock);
> 	mutex_init(&vsock->event_lock);
> 	spin_lock_init(&vsock->send_pkt_list_lock);
> 	INIT_LIST_HEAD(&vsock->send_pkt_list);
>@@ -651,16 +848,27 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> 	INIT_WORK(&vsock->tx_work, virtio_transport_tx_work);
> 	INIT_WORK(&vsock->event_work, virtio_transport_event_work);
> 	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
>+	INIT_WORK(&vsock->dgram_rx_work, virtio_transport_dgram_rx_work);
>+	INIT_WORK(&vsock->dgram_tx_work, virtio_transport_dgram_tx_work);
>
> 	mutex_lock(&vsock->tx_lock);
> 	vsock->tx_run = true;
> 	mutex_unlock(&vsock->tx_lock);
>
>+	mutex_lock(&vsock->dgram_tx_lock);
>+	vsock->dgram_tx_run = true;
>+	mutex_unlock(&vsock->dgram_tx_lock);
>+
> 	mutex_lock(&vsock->rx_lock);
>-	virtio_vsock_rx_fill(vsock);
>+	virtio_vsock_rx_fill(vsock, false);
> 	vsock->rx_run = true;
> 	mutex_unlock(&vsock->rx_lock);
>
>+	mutex_lock(&vsock->dgram_rx_lock);
>+	virtio_vsock_rx_fill(vsock, true);
>+	vsock->dgram_rx_run = true;
>+	mutex_unlock(&vsock->dgram_rx_lock);
>+
> 	mutex_lock(&vsock->event_lock);
> 	virtio_vsock_event_fill(vsock);
> 	vsock->event_run = true;
>@@ -669,6 +877,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> 	vdev->priv = vsock;
> 	rcu_assign_pointer(the_virtio_vsock, vsock);
>
>+	the_virtio_vsock_dgram = vsock;
>+	refcount_set(&the_virtio_vsock_dgram->active, 1);
>+
> 	mutex_unlock(&the_virtio_vsock_mutex);
> 	return 0;
>
>@@ -699,14 +910,28 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
> 	vsock->rx_run = false;
> 	mutex_unlock(&vsock->rx_lock);
>
>+	mutex_lock(&vsock->dgram_rx_lock);
>+	vsock->dgram_rx_run = false;
>+	mutex_unlock(&vsock->dgram_rx_lock);
>+
> 	mutex_lock(&vsock->tx_lock);
> 	vsock->tx_run = false;
> 	mutex_unlock(&vsock->tx_lock);
>
>+	mutex_lock(&vsock->dgram_tx_lock);
>+	vsock->dgram_tx_run = false;
>+	mutex_unlock(&vsock->dgram_tx_lock);
>+
> 	mutex_lock(&vsock->event_lock);
> 	vsock->event_run = false;
> 	mutex_unlock(&vsock->event_lock);
>
>+	while (!refcount_dec_if_one(&the_virtio_vsock_dgram->active)) {
>+		if (signal_pending(current))
>+			break;
>+		msleep(5);
>+	}
>+
> 	/* Flush all device writes and interrupts, device will not use any
> 	 * more buffers.
> 	 */
>@@ -717,11 +942,21 @@ static void virtio_vsock_remove(struct 
>virtio_device *vdev)
> 		virtio_transport_free_pkt(pkt);
> 	mutex_unlock(&vsock->rx_lock);
>
>+	mutex_lock(&vsock->dgram_rx_lock);
>+	while ((pkt = virtqueue_detach_unused_buf(vsock->vqs[VSOCK_VQ_DGRAM_RX])))
>+		virtio_transport_free_pkt(pkt);
>+	mutex_unlock(&vsock->dgram_rx_lock);
>+
> 	mutex_lock(&vsock->tx_lock);
> 	while ((pkt = virtqueue_detach_unused_buf(vsock->vqs[VSOCK_VQ_TX])))
> 		virtio_transport_free_pkt(pkt);
> 	mutex_unlock(&vsock->tx_lock);
>
>+	mutex_lock(&vsock->dgram_tx_lock);
>+	while ((pkt = virtqueue_detach_unused_buf(vsock->vqs[VSOCK_VQ_DGRAM_TX])))
>+		virtio_transport_free_pkt(pkt);
>+	mutex_unlock(&vsock->dgram_tx_lock);
>+
> 	spin_lock_bh(&vsock->send_pkt_list_lock);
> 	while (!list_empty(&vsock->send_pkt_list)) {
> 		pkt = list_first_entry(&vsock->send_pkt_list,
>@@ -739,6 +974,8 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
> 	 */
> 	flush_work(&vsock->rx_work);
> 	flush_work(&vsock->tx_work);
>+	flush_work(&vsock->dgram_rx_work);
>+	flush_work(&vsock->dgram_tx_work);
> 	flush_work(&vsock->event_work);
> 	flush_work(&vsock->send_pkt_work);
>
>@@ -775,7 +1012,7 @@ static int __init virtio_vsock_init(void)
> 		return -ENOMEM;
>
> 	ret = vsock_core_register(&virtio_transport.transport,
>-				  VSOCK_TRANSPORT_F_G2H);
>+				  VSOCK_TRANSPORT_F_G2H | VSOCK_TRANSPORT_F_DGRAM);
> 	if (ret)
> 		goto out_wq;
>
>diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
>index 902cb6dd710b..9f041515b7f1 100644
>--- a/net/vmw_vsock/virtio_transport_common.c
>+++ b/net/vmw_vsock/virtio_transport_common.c
>@@ -26,6 +26,8 @@
> /* Threshold for detecting small packets to copy */
> #define GOOD_COPY_LEN  128
>
>+static s64 virtio_transport_dgram_has_data(struct vsock_sock *vsk);
>+
> static const struct virtio_transport *
> virtio_transport_get_ops(struct vsock_sock *vsk)
> {
>@@ -196,21 +198,28 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
> 	vvs = vsk->trans;
>
> 	/* we can send less than pkt_len bytes */
>-	if (pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
>-		pkt_len = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
>+	if (pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE) {
>+		if (info->type == VIRTIO_VSOCK_TYPE_STREAM)
>+			pkt_len = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
>+		else
>+			return 0;
>+	}
>
>-	/* virtio_transport_get_credit might return less than pkt_len credit */
>-	pkt_len = virtio_transport_get_credit(vvs, pkt_len);
>+	if (info->type == VIRTIO_VSOCK_TYPE_STREAM) {
>+		/* virtio_transport_get_credit might return less than pkt_len credit */
>+		pkt_len = virtio_transport_get_credit(vvs, pkt_len);
>
>-	/* Do not send zero length OP_RW pkt */
>-	if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
>-		return pkt_len;
>+		/* Do not send zero length OP_RW pkt */
>+		if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
>+			return pkt_len;
>+	}
>
> 	pkt = virtio_transport_alloc_pkt(info, pkt_len,
> 					 src_cid, src_port,
> 					 dst_cid, dst_port);
> 	if (!pkt) {
>-		virtio_transport_put_credit(vvs, pkt_len);
>+		if (info->type == VIRTIO_VSOCK_TYPE_STREAM)
>+			virtio_transport_put_credit(vvs, pkt_len);
> 		return -ENOMEM;
> 	}
>
>@@ -397,6 +406,58 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
> 	return err;
> }
>
>+static ssize_t
>+virtio_transport_dgram_do_dequeue(struct vsock_sock *vsk,
>+						   struct msghdr *msg, size_t len)
>+{
>+	struct virtio_vsock_sock *vvs = vsk->trans;
>+	struct virtio_vsock_pkt *pkt;
>+	size_t total = 0;
>+	u32 free_space;

`free_space` seems unused.

>+	int err = -EFAULT;
>+
>+	spin_lock_bh(&vvs->rx_lock);
>+	if (total < len && !list_empty(&vvs->rx_queue)) {
>+		pkt = list_first_entry(&vvs->rx_queue,
>+				       struct virtio_vsock_pkt, list);
>+
>+		total = len;
>+		if (total > pkt->len - pkt->off)
>+			total = pkt->len - pkt->off;
>+		else if (total < pkt->len - pkt->off)
>+			msg->msg_flags |= MSG_TRUNC;
>+
>+		/* sk_lock is held by caller so no one else can dequeue.
>+		 * Unlock rx_lock since memcpy_to_msg() may sleep.
>+		 */
>+		spin_unlock_bh(&vvs->rx_lock);
>+
>+		err = memcpy_to_msg(msg, pkt->buf + pkt->off, total);
>+		if (err)
>+			return err;
>+
>+		spin_lock_bh(&vvs->rx_lock);
>+
>+		virtio_transport_dec_rx_pkt(vvs, pkt);
>+		list_del(&pkt->list);
>+		virtio_transport_free_pkt(pkt);
>+	}
>+
>+	free_space = vvs->buf_alloc - (vvs->fwd_cnt - vvs->last_fwd_cnt);
>+
>+	spin_unlock_bh(&vvs->rx_lock);
>+
>+	if (total > 0 && msg->msg_name) {
>+		/* Provide the address of the sender. */
>+		DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
>+
>+		vsock_addr_init(vm_addr, le64_to_cpu(pkt->hdr.src_cid),
>+						le32_to_cpu(pkt->hdr.src_port));
>+		msg->msg_namelen = sizeof(*vm_addr);
>+	}
>+	return total;
>+}
>+
> ssize_t
> virtio_transport_stream_dequeue(struct vsock_sock *vsk,
> 				struct msghdr *msg,
>@@ -414,7 +475,66 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> 			       struct msghdr *msg,
> 			       size_t len, int flags)
> {
>-	return -EOPNOTSUPP;
>+	struct sock *sk;
>+	size_t err = 0;
>+	long timeout;
>+
>+	DEFINE_WAIT(wait);
>+
>+	sk = &vsk->sk;
>+	err = 0;
>+
>+	lock_sock(sk);
>+
>+	if (flags & MSG_OOB || flags & MSG_ERRQUEUE || flags & MSG_PEEK)
>+		return -EOPNOTSUPP;
>+
>+	if (!len)
>+		goto out;
>+
>+	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
>+
>+	while (1) {
>+		s64 ready;
>+
>+		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
>+		ready = virtio_transport_dgram_has_data(vsk);
>+
>+		if (ready == 0) {
>+			if (timeout == 0) {
>+				err = -EAGAIN;
>+				finish_wait(sk_sleep(sk), &wait);
>+				break;
>+			}
>+
>+			release_sock(sk);
>+			timeout = schedule_timeout(timeout);
>+			lock_sock(sk);
>+
>+			if (signal_pending(current)) {
>+				err = sock_intr_errno(timeout);
>+				finish_wait(sk_sleep(sk), &wait);
>+				break;
>+			} else if (timeout == 0) {
>+				err = -EAGAIN;
>+				finish_wait(sk_sleep(sk), &wait);
>+				break;
>+			}
>+		} else {
>+			finish_wait(sk_sleep(sk), &wait);
>+
>+			if (ready < 0) {
>+				err = -ENOMEM;
>+				goto out;
>+			}
>+
>+			err = virtio_transport_dgram_do_dequeue(vsk, msg, len);
>+			break;
>+		}
>+	}
>+out:
>+	release_sock(sk);
>+	return err;
> }
> EXPORT_SYMBOL_GPL(virtio_transport_dgram_dequeue);
>
>@@ -431,6 +551,11 @@ s64 virtio_transport_stream_has_data(struct vsock_sock *vsk)
> }
> EXPORT_SYMBOL_GPL(virtio_transport_stream_has_data);
>
>+static s64 virtio_transport_dgram_has_data(struct vsock_sock *vsk)
>+{
>+	return virtio_transport_stream_has_data(vsk);
>+}
>+
> static s64 virtio_transport_has_space(struct vsock_sock *vsk)
> {
> 	struct virtio_vsock_sock *vvs = vsk->trans;
>@@ -610,13 +735,15 @@ EXPORT_SYMBOL_GPL(virtio_transport_stream_allow);
> int virtio_transport_dgram_bind(struct vsock_sock *vsk,
> 				struct sockaddr_vm *addr)
> {
>-	return -EOPNOTSUPP;
>+	//use same stream bind for dgram
>+	int ret = vsock_bind_stream(vsk, addr);
>+	return ret;
> }
> EXPORT_SYMBOL_GPL(virtio_transport_dgram_bind);
>
> bool virtio_transport_dgram_allow(u32 cid, u32 port)
> {
>-	return false;
>+	return true;
> }
> EXPORT_SYMBOL_GPL(virtio_transport_dgram_allow);
>
>@@ -654,7 +781,17 @@ virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
> 			       struct msghdr *msg,
> 			       size_t dgram_len)
> {
>-	return -EOPNOTSUPP;
>+	struct virtio_vsock_pkt_info info = {
>+		.op = VIRTIO_VSOCK_OP_RW,
>+		.type = VIRTIO_VSOCK_TYPE_DGRAM,
>+		.msg = msg,
>+		.pkt_len = dgram_len,
>+		.vsk = vsk,
>+		.remote_cid = remote_addr->svm_cid,
>+		.remote_port = remote_addr->svm_port,
>+	};
>+
>+	return virtio_transport_send_pkt_info(vsk, &info);
> }
> EXPORT_SYMBOL_GPL(virtio_transport_dgram_enqueue);
>
>@@ -729,7 +866,6 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
> 		virtio_transport_free_pkt(reply);
> 		return -ENOTCONN;
> 	}
>-
> 	return t->send_pkt(reply);
> }
>
>@@ -925,7 +1061,8 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
> 		/* If there is space in the last packet queued, we copy the
> 		 * new packet in its buffer.
> 		 */
>-		if (pkt->len <= last_pkt->buf_len - last_pkt->len) {
>+		if (pkt->len <= last_pkt->buf_len - last_pkt->len &&
>+			pkt->hdr.type == VIRTIO_VSOCK_TYPE_STREAM) {

We should use le16_to_cpu():
			le16_to_cpu(pkt->hdr.type) == VIRTIO_VSOCK_TYPE_STREAM

> 			memcpy(last_pkt->buf + last_pkt->len, pkt->buf,
> 			       pkt->len);
> 			last_pkt->len += pkt->len;
>@@ -949,6 +1086,12 @@ virtio_transport_recv_connected(struct sock *sk,
> 	struct vsock_sock *vsk = vsock_sk(sk);
> 	int err = 0;
>
>+	if (le16_to_cpu(pkt->hdr.type == VIRTIO_VSOCK_TYPE_DGRAM)) {

We should use le16_to_cpu() before the compare:
	if (le16_to_cpu(pkt->hdr.type) == VIRTIO_VSOCK_TYPE_DGRAM) {

>+		virtio_transport_recv_enqueue(vsk, pkt);
>+		sk->sk_data_ready(sk);
>+		return err;
>+	}
>+
> 	switch (le16_to_cpu(pkt->hdr.op)) {
> 	case VIRTIO_VSOCK_OP_RW:
> 		virtio_transport_recv_enqueue(vsk, pkt);
>@@ -1121,7 +1264,8 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
> 					le32_to_cpu(pkt->hdr.buf_alloc),
> 					le32_to_cpu(pkt->hdr.fwd_cnt));
>
>-	if (le16_to_cpu(pkt->hdr.type) != VIRTIO_VSOCK_TYPE_STREAM) {
>+	if (le16_to_cpu(pkt->hdr.type) != VIRTIO_VSOCK_TYPE_STREAM &&
>+		le16_to_cpu(pkt->hdr.type) != VIRTIO_VSOCK_TYPE_DGRAM) {
> 		(void)virtio_transport_reset_no_sock(t, pkt);
> 		goto free_pkt;
> 	}
>@@ -1150,11 +1294,16 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
> 		goto free_pkt;
> 	}
>
>-	space_available = virtio_transport_space_update(sk, pkt);
>-
> 	/* Update CID in case it has changed after a transport reset event */
> 	vsk->local_addr.svm_cid = dst.svm_cid;
>
>+	if (sk->sk_type == SOCK_DGRAM) {
>+		virtio_transport_recv_connected(sk, pkt);
>+		goto out;
>+	}
>+
>+	space_available = virtio_transport_space_update(sk, pkt);
>+
> 	if (space_available)
> 		sk->sk_write_space(sk);
>
>@@ -1180,6 +1329,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
> 		break;
> 	}
>
>+out:
> 	release_sock(sk);
>
> 	/* Release refcnt obtained when we fetched this socket out of the
>-- 
>2.11.0
>

