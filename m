Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC4F3AC7CE
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 11:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhFRJmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 05:42:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32586 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229915AbhFRJmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 05:42:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624009200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9OTgWym34MWOytQh3dCOiJZNfcSTFJBcg5/VEusdTLU=;
        b=iWza114pEBRlGpE4A7fHZ45dwJmZLAI8kEjs5JrEDvLIyPqcPYE/Q/dReu3WHoQYW2wn9x
        hanSdWYY79vpsW7F/ddXO/O1JcKTXLjtx16evG88f3ezkFxsn2Qh16UEzlLFxBsob3DGWs
        dwYI8ssrrmBPcztPcZMJGrt+kLV+ng0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-297-Dz5DYIdMMHOUc-aWez2Qfw-1; Fri, 18 Jun 2021 05:39:58 -0400
X-MC-Unique: Dz5DYIdMMHOUc-aWez2Qfw-1
Received: by mail-ed1-f72.google.com with SMTP id ch5-20020a0564021bc5b029039389929f28so3206988edb.16
        for <netdev@vger.kernel.org>; Fri, 18 Jun 2021 02:39:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9OTgWym34MWOytQh3dCOiJZNfcSTFJBcg5/VEusdTLU=;
        b=FUJQjMwo8a/GOmxgnJOjGGh9f27tSDKWjsMykH/hRALr2UWQtAdrmL+t61dfDrNml7
         gyB8sxAxjajo+GwxUMhCZLx6p4/5+QYETWiE3nOgHTqEsFt6pUwM3MSKPGqvwTQuapRE
         9uzwv0y2uAA1kciEFbUkr15s7iYqHS4dFZl5oOIfVv19sEeUmc88SxBHmXISumyrnfFA
         B4pJ0K9PIdg7FyhyDp+hM1qAcCC/t/8gT2MxH1wlA5kpe8dNCuLKaVi8TyQA0Ovg/nvT
         9npoqQYXOkn13Xnc20yUlgrQv3R/w+n0Hf13+dWp2uQ3u8ehhegrzY79QwrPuGxnV9az
         F2hw==
X-Gm-Message-State: AOAM5338M0TrVnS6e4+4yZa5BZyshco4ZT0CUFHhw+OT9DLPYwstbp8N
        z0RnMxI4+5mvrCCrMmiiHiEXOK9dwSbNLougyUMvmnhapxEQPCmasiE4g9LQQswuGptgMsajUqk
        Gc1pMI0PskuE3imuD
X-Received: by 2002:a17:907:10d7:: with SMTP id rv23mr10004026ejb.163.1624009197506;
        Fri, 18 Jun 2021 02:39:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTSy+T330jfiNVwwXxtw5wBYMmXh7NS4dAyo6bHcMvj8+O+LrLu6QAkLP5Y7ZJJZ2IwLSP8w==
X-Received: by 2002:a17:907:10d7:: with SMTP id rv23mr10004014ejb.163.1624009197332;
        Fri, 18 Jun 2021 02:39:57 -0700 (PDT)
Received: from steredhat.lan ([5.170.128.252])
        by smtp.gmail.com with ESMTPSA id u12sm810511eje.40.2021.06.18.02.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 02:39:57 -0700 (PDT)
Date:   Fri, 18 Jun 2021 11:39:51 +0200
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
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v1 1/6] virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
Message-ID: <20210618093951.g32htj3rsu2koqi5@steredhat.lan>
References: <20210609232501.171257-1-jiang.wang@bytedance.com>
 <20210609232501.171257-2-jiang.wang@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210609232501.171257-2-jiang.wang@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 11:24:53PM +0000, Jiang Wang wrote:
>When this feature is enabled, allocate 5 queues,
>otherwise, allocate 3 queues to be compatible with
>old QEMU versions.
>
>Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
>---
> drivers/vhost/vsock.c             |  3 +-
> include/linux/virtio_vsock.h      |  9 +++++
> include/uapi/linux/virtio_vsock.h |  3 ++
> net/vmw_vsock/virtio_transport.c  | 73 +++++++++++++++++++++++++++++++++++----
> 4 files changed, 80 insertions(+), 8 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index 5e78fb719602..81d064601093 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -31,7 +31,8 @@
>
> enum {
> 	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
>-			       (1ULL << VIRTIO_F_ACCESS_PLATFORM)
>+			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
>+			       (1ULL << VIRTIO_VSOCK_F_DGRAM)
> };
>
> enum {
>diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
>index dc636b727179..ba3189ed9345 100644
>--- a/include/linux/virtio_vsock.h
>+++ b/include/linux/virtio_vsock.h
>@@ -18,6 +18,15 @@ enum {
> 	VSOCK_VQ_MAX    = 3,
> };
>
>+enum {
>+	VSOCK_VQ_STREAM_RX     = 0, /* for host to guest data */
>+	VSOCK_VQ_STREAM_TX     = 1, /* for guest to host data */
>+	VSOCK_VQ_DGRAM_RX       = 2,
>+	VSOCK_VQ_DGRAM_TX       = 3,
>+	VSOCK_VQ_EX_EVENT       = 4,
>+	VSOCK_VQ_EX_MAX         = 5,
>+};
>+
> /* Per-socket state (accessed via vsk->trans) */
> struct virtio_vsock_sock {
> 	struct vsock_sock *vsk;
>diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>index 1d57ed3d84d2..b56614dff1c9 100644
>--- a/include/uapi/linux/virtio_vsock.h
>+++ b/include/uapi/linux/virtio_vsock.h
>@@ -38,6 +38,9 @@
> #include <linux/virtio_ids.h>
> #include <linux/virtio_config.h>
>
>+/* The feature bitmap for virtio net */
>+#define VIRTIO_VSOCK_F_DGRAM	0	/* Host support dgram vsock */
>+
> struct virtio_vsock_config {
> 	__le64 guest_cid;
> } __attribute__((packed));
>diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
>index 2700a63ab095..7dcb8db23305 100644
>--- a/net/vmw_vsock/virtio_transport.c
>+++ b/net/vmw_vsock/virtio_transport.c
>@@ -27,7 +27,8 @@ static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
>
> struct virtio_vsock {
> 	struct virtio_device *vdev;
>-	struct virtqueue *vqs[VSOCK_VQ_MAX];
>+	struct virtqueue **vqs;
>+	bool has_dgram;
>
> 	/* Virtqueue processing is deferred to a workqueue */
> 	struct work_struct tx_work;
>@@ -333,7 +334,10 @@ static int virtio_vsock_event_fill_one(struct virtio_vsock *vsock,
> 	struct scatterlist sg;
> 	struct virtqueue *vq;
>
>-	vq = vsock->vqs[VSOCK_VQ_EVENT];
>+	if (vsock->has_dgram)
>+		vq = vsock->vqs[VSOCK_VQ_EX_EVENT];
>+	else
>+		vq = vsock->vqs[VSOCK_VQ_EVENT];
>
> 	sg_init_one(&sg, event, sizeof(*event));
>
>@@ -351,7 +355,10 @@ static void virtio_vsock_event_fill(struct virtio_vsock *vsock)
> 		virtio_vsock_event_fill_one(vsock, event);
> 	}
>
>-	virtqueue_kick(vsock->vqs[VSOCK_VQ_EVENT]);
>+	if (vsock->has_dgram)
>+		virtqueue_kick(vsock->vqs[VSOCK_VQ_EX_EVENT]);
>+	else
>+		virtqueue_kick(vsock->vqs[VSOCK_VQ_EVENT]);
> }
>
> static void virtio_vsock_reset_sock(struct sock *sk)
>@@ -391,7 +398,10 @@ static void virtio_transport_event_work(struct work_struct *work)
> 		container_of(work, struct virtio_vsock, event_work);
> 	struct virtqueue *vq;
>
>-	vq = vsock->vqs[VSOCK_VQ_EVENT];
>+	if (vsock->has_dgram)
>+		vq = vsock->vqs[VSOCK_VQ_EX_EVENT];
>+	else
>+		vq = vsock->vqs[VSOCK_VQ_EVENT];
>
> 	mutex_lock(&vsock->event_lock);
>
>@@ -411,7 +421,10 @@ static void virtio_transport_event_work(struct work_struct *work)
> 		}
> 	} while (!virtqueue_enable_cb(vq));
>
>-	virtqueue_kick(vsock->vqs[VSOCK_VQ_EVENT]);
>+	if (vsock->has_dgram)
>+		virtqueue_kick(vsock->vqs[VSOCK_VQ_EX_EVENT]);
>+	else
>+		virtqueue_kick(vsock->vqs[VSOCK_VQ_EVENT]);
> out:
> 	mutex_unlock(&vsock->event_lock);
> }
>@@ -434,6 +447,10 @@ static void virtio_vsock_tx_done(struct virtqueue *vq)
> 	queue_work(virtio_vsock_workqueue, &vsock->tx_work);
> }
>
>+static void virtio_vsock_dgram_tx_done(struct virtqueue *vq)
>+{
>+}
>+
> static void virtio_vsock_rx_done(struct virtqueue *vq)
> {
> 	struct virtio_vsock *vsock = vq->vdev->priv;
>@@ -443,6 +460,10 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
> 	queue_work(virtio_vsock_workqueue, &vsock->rx_work);
> }
>
>+static void virtio_vsock_dgram_rx_done(struct virtqueue *vq)
>+{
>+}
>+
> static struct virtio_transport virtio_transport = {
> 	.transport = {
> 		.module                   = THIS_MODULE,
>@@ -545,13 +566,29 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
> 		virtio_vsock_tx_done,
> 		virtio_vsock_event_done,
> 	};
>+	vq_callback_t *ex_callbacks[] = {

'ex' is not clear, maybe better 'dgram'?

What happen if F_DGRAM is negotiated, but not F_STREAM?

>+		virtio_vsock_rx_done,
>+		virtio_vsock_tx_done,
>+		virtio_vsock_dgram_rx_done,
>+		virtio_vsock_dgram_tx_done,
>+		virtio_vsock_event_done,
>+	};
>+
> 	static const char * const names[] = {
> 		"rx",
> 		"tx",
> 		"event",
> 	};
>+	static const char * const ex_names[] = {
>+		"rx",
>+		"tx",
>+		"dgram_rx",
>+		"dgram_tx",
>+		"event",
>+	};
>+
> 	struct virtio_vsock *vsock = NULL;
>-	int ret;
>+	int ret, max_vq;
>
> 	ret = mutex_lock_interruptible(&the_virtio_vsock_mutex);
> 	if (ret)
>@@ -572,9 +609,30 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>
> 	vsock->vdev = vdev;
>
>-	ret = virtio_find_vqs(vsock->vdev, VSOCK_VQ_MAX,
>+	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_DGRAM))
>+		vsock->has_dgram = true;
>+
>+	if (vsock->has_dgram)
>+		max_vq = VSOCK_VQ_EX_MAX;
>+	else
>+		max_vq = VSOCK_VQ_MAX;
>+
>+	vsock->vqs = kmalloc_array(max_vq, sizeof(struct virtqueue *), GFP_KERNEL);
>+	if (!vsock->vqs) {
>+		ret = -ENOMEM;
>+		goto out;
>+	}
>+
>+	if (vsock->has_dgram) {
>+		ret = virtio_find_vqs(vsock->vdev, max_vq,
>+			      vsock->vqs, ex_callbacks, ex_names,
>+			      NULL);
>+	} else {
>+		ret = virtio_find_vqs(vsock->vdev, max_vq,
> 			      vsock->vqs, callbacks, names,
> 			      NULL);
>+	}
>+
> 	if (ret < 0)
> 		goto out;
>
>@@ -695,6 +753,7 @@ static struct virtio_device_id id_table[] = {
> };
>
> static unsigned int features[] = {
>+	VIRTIO_VSOCK_F_DGRAM,
> };
>
> static struct virtio_driver virtio_vsock_driver = {
>-- 
>2.11.0
>

