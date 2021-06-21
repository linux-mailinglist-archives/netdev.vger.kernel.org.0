Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F4D3AF20F
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231486AbhFURe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbhFURe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 13:34:57 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9AD4C06175F
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:32:42 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 7-20020a9d0d070000b0290439abcef697so18527813oti.2
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OsCM5qeJ8JIBDVINDA6ZgZ1LIQyrHGrcG8DWHQ04t6M=;
        b=N7C1+RbiqXkoKMxaS/bkvEwnMXgyC2AjyEMv70VATCQw8bF4C3X95Oj/dqbBayYzdV
         jNTqvFbxuboCA/vk3yJZYeyIpvpdxa5+bmkT3BpB9BYdHS+vBtlRIDHljpDip4u4V9va
         RCQO2yQ1lbtUl9rs/jEbmEa+N/0OmTfg7tO9JdrabbX9qHFTYfb8Sv3Avw/wDVTYvhzH
         9AU5cWxwnGigMGiAihEGU25ffALEfiwIYoo1VFp5tKdH29CFCL1QEKDynu/WOpeoU+wq
         uhBYQX6qNpcODAlSRut4nV08qrt6Wmgx/97FKmfmDCXjqT3fLm+GRovvE+/SnIowRknh
         MPOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OsCM5qeJ8JIBDVINDA6ZgZ1LIQyrHGrcG8DWHQ04t6M=;
        b=J4LK2nxSICFx/xRHbkfR96+0IDfCRS6oLRdTuWwr+imY2VbksAuazF2RGAdHjjPRtv
         AT0me9/4mEymS2/OIfZX9iMy3wwh5VQgOf1evweHkaz8zfjD4NEqgdFYX9Vz9JhzBhCR
         6smzBG9XH8jTf71/0S9FjawJwm9++sNgOmLmmiVI5QpYk8ML5lWjrvvERVkprRmBwyyQ
         M6QonLoM9+sqaUT1TVbEFtbEId+CtN/kEM84cwyk5ZX+9xgzwOGIY5BqUEYNFI/aJf6+
         xO2nMGMY/NaErJ+RYNmO0xgizfi5wyqcioX4oVPuwIz+Mxw3cBAKK+QjrkuUTUIREZIB
         s+dg==
X-Gm-Message-State: AOAM531mF1FDQbr62NPAgPkzVVY6VLhbsUgvG4kMEfOUvB1S444s8VIe
        1vXFlNXKTu58bX/tfBz8lcljZCLW4p9oBGtLcMSdAg==
X-Google-Smtp-Source: ABdhPJya0zSnA8l97WFQRaJj4bwh4tBEZUxrYdDxKLw9Tan2fqWfYrh0tPtPLAac/pxCjOmb6TAYgGeYIyxJ3g+kLx8=
X-Received: by 2002:a05:6830:1dd5:: with SMTP id a21mr21530097otj.180.1624296762250;
 Mon, 21 Jun 2021 10:32:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210609232501.171257-1-jiang.wang@bytedance.com>
 <20210609232501.171257-4-jiang.wang@bytedance.com> <20210618101354.nucgcghnjxoxrame@steredhat.lan>
In-Reply-To: <20210618101354.nucgcghnjxoxrame@steredhat.lan>
From:   "Jiang Wang ." <jiang.wang@bytedance.com>
Date:   Mon, 21 Jun 2021 10:32:31 -0700
Message-ID: <CAP_N_Z_91_z12qMmQKR2PxWC-qyUy5ZZt7Fik_1wBf3rtGECmg@mail.gmail.com>
Subject: Re: [External] Re: [RFC v1 3/6] vhost/vsock: add support for vhost dgram.
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        cong.wang@bytedance.com,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Yongji Xie <xieyongji@bytedance.com>,
        =?UTF-8?B?5p+056iz?= <chaiwen.cc@bytedance.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 18, 2021 at 3:14 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> We should use le16_to_cpu when accessing pkt->hdr fields.

OK. Will do.

> On Wed, Jun 09, 2021 at 11:24:55PM +0000, Jiang Wang wrote:
> >This patch supports dgram on vhost side, including
> >tx and rx. The vhost send packets asynchronously.
> >
> >Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> >---
> > drivers/vhost/vsock.c | 199 +++++++++++++++++++++++++++++++++++++++++++-------
> > 1 file changed, 173 insertions(+), 26 deletions(-)
> >
> >diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> >index 81d064601093..d366463be6d4 100644
> >--- a/drivers/vhost/vsock.c
> >+++ b/drivers/vhost/vsock.c
> >@@ -28,7 +28,10 @@
> >  * small pkts.
> >  */
> > #define VHOST_VSOCK_PKT_WEIGHT 256
> >+#define VHOST_VSOCK_DGRM_MAX_PENDING_PKT 128
> >
> >+/* Max wait time in busy poll in microseconds */
> >+#define VHOST_VSOCK_BUSY_POLL_TIMEOUT 20
> > enum {
> >       VHOST_VSOCK_FEATURES = VHOST_FEATURES |
> >                              (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
> >@@ -45,7 +48,7 @@ static DEFINE_READ_MOSTLY_HASHTABLE(vhost_vsock_hash, 8);
> >
> > struct vhost_vsock {
> >       struct vhost_dev dev;
> >-      struct vhost_virtqueue vqs[2];
> >+      struct vhost_virtqueue vqs[4];
> >
> >       /* Link to global vhost_vsock_hash, writes use vhost_vsock_mutex */
> >       struct hlist_node hash;
> >@@ -54,6 +57,11 @@ struct vhost_vsock {
> >       spinlock_t send_pkt_list_lock;
> >       struct list_head send_pkt_list; /* host->guest pending packets */
> >
> >+      spinlock_t dgram_send_pkt_list_lock;
> >+      struct list_head dgram_send_pkt_list;   /* host->guest pending packets */
> >+      struct vhost_work dgram_send_pkt_work;
> >+      int  dgram_used; /*pending packets to be send */
> >+
> >       atomic_t queued_replies;
> >
> >       u32 guest_cid;
> >@@ -90,10 +98,22 @@ static void
> > vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> >                           struct vhost_virtqueue *vq)
> > {
> >-      struct vhost_virtqueue *tx_vq = &vsock->vqs[VSOCK_VQ_TX];
> >+      struct vhost_virtqueue *tx_vq;
> >       int pkts = 0, total_len = 0;
> >       bool added = false;
> >       bool restart_tx = false;
> >+      spinlock_t *lock;
> >+      struct list_head *send_pkt_list;
> >+
> >+      if (vq == &vsock->vqs[VSOCK_VQ_RX]) {
> >+              tx_vq = &vsock->vqs[VSOCK_VQ_TX];
> >+              lock = &vsock->send_pkt_list_lock;
> >+              send_pkt_list = &vsock->send_pkt_list;
> >+      } else {
> >+              tx_vq = &vsock->vqs[VSOCK_VQ_DGRAM_TX];
> >+              lock = &vsock->dgram_send_pkt_list_lock;
> >+              send_pkt_list = &vsock->dgram_send_pkt_list;
> >+      }
> >
> >       mutex_lock(&vq->mutex);
> >
> >@@ -113,36 +133,48 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> >               size_t nbytes;
> >               size_t iov_len, payload_len;
> >               int head;
> >+              bool is_dgram = false;
> >
> >-              spin_lock_bh(&vsock->send_pkt_list_lock);
> >-              if (list_empty(&vsock->send_pkt_list)) {
> >-                      spin_unlock_bh(&vsock->send_pkt_list_lock);
> >+              spin_lock_bh(lock);
> >+              if (list_empty(send_pkt_list)) {
> >+                      spin_unlock_bh(lock);
> >                       vhost_enable_notify(&vsock->dev, vq);
> >                       break;
> >               }
> >
> >-              pkt = list_first_entry(&vsock->send_pkt_list,
> >+              pkt = list_first_entry(send_pkt_list,
> >                                      struct virtio_vsock_pkt, list);
> >               list_del_init(&pkt->list);
> >-              spin_unlock_bh(&vsock->send_pkt_list_lock);
> >+              spin_unlock_bh(lock);
> >+
> >+              if (pkt->hdr.type == VIRTIO_VSOCK_TYPE_DGRAM)
>                      ^
>                      le16_to_cpu(pkt->hdr.type)
>
> >+                      is_dgram = true;
> >
> >               head = vhost_get_vq_desc(vq, vq->iov, ARRAY_SIZE(vq->iov),
> >                                        &out, &in, NULL, NULL);
> >               if (head < 0) {
> >-                      spin_lock_bh(&vsock->send_pkt_list_lock);
> >-                      list_add(&pkt->list, &vsock->send_pkt_list);
> >-                      spin_unlock_bh(&vsock->send_pkt_list_lock);
> >+                      spin_lock_bh(lock);
> >+                      list_add(&pkt->list, send_pkt_list);
> >+                      spin_unlock_bh(lock);
> >                       break;
> >               }
> >
> >               if (head == vq->num) {
> >-                      spin_lock_bh(&vsock->send_pkt_list_lock);
> >-                      list_add(&pkt->list, &vsock->send_pkt_list);
> >-                      spin_unlock_bh(&vsock->send_pkt_list_lock);
> >+                      if (is_dgram) {
> >+                              virtio_transport_free_pkt(pkt);
> >+                              vq_err(vq, "Dgram virtqueue is full!");
> >+                              spin_lock_bh(lock);
> >+                              vsock->dgram_used--;
> >+                              spin_unlock_bh(lock);
> >+                              break;
> >+                      }
> >+                      spin_lock_bh(lock);
> >+                      list_add(&pkt->list, send_pkt_list);
> >+                      spin_unlock_bh(lock);
> >
> >                       /* We cannot finish yet if more buffers snuck in while
> >-                       * re-enabling notify.
> >-                       */
> >+                      * re-enabling notify.
> >+                      */
> >                       if (unlikely(vhost_enable_notify(&vsock->dev, vq))) {
> >                               vhost_disable_notify(&vsock->dev, vq);
> >                               continue;
> >@@ -153,6 +185,12 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> >               if (out) {
> >                       virtio_transport_free_pkt(pkt);
> >                       vq_err(vq, "Expected 0 output buffers, got %u\n", out);
> >+                      if (is_dgram) {
> >+                              spin_lock_bh(lock);
> >+                              vsock->dgram_used--;
> >+                              spin_unlock_bh(lock);
> >+                      }
> >+
> >                       break;
> >               }
> >
> >@@ -160,6 +198,18 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> >               if (iov_len < sizeof(pkt->hdr)) {
> >                       virtio_transport_free_pkt(pkt);
> >                       vq_err(vq, "Buffer len [%zu] too small\n", iov_len);
> >+                      if (is_dgram) {
> >+                              spin_lock_bh(lock);
> >+                              vsock->dgram_used--;
> >+                              spin_unlock_bh(lock);
> >+                      }
> >+                      break;
> >+              }
> >+
> >+              if (iov_len < pkt->len - pkt->off &&
> >+                      vq == &vsock->vqs[VSOCK_VQ_DGRAM_RX]) {
> >+                      virtio_transport_free_pkt(pkt);
> >+                      vq_err(vq, "Buffer len [%zu] too small for dgram\n", iov_len);
> >                       break;
> >               }
> >
> >@@ -179,6 +229,11 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> >               if (nbytes != sizeof(pkt->hdr)) {
> >                       virtio_transport_free_pkt(pkt);
> >                       vq_err(vq, "Faulted on copying pkt hdr\n");
> >+                      if (is_dgram) {
> >+                              spin_lock_bh(lock);
> >+                              vsock->dgram_used--;
> >+                              spin_unlock_bh(lock);
> >+                      }
> >                       break;
> >               }
> >
> >@@ -204,16 +259,17 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> >               /* If we didn't send all the payload we can requeue the packet
> >                * to send it with the next available buffer.
> >                */
> >-              if (pkt->off < pkt->len) {
> >+              if ((pkt->off < pkt->len)
> >+                      && (vq == &vsock->vqs[VSOCK_VQ_RX])) {
> >                       /* We are queueing the same virtio_vsock_pkt to handle
> >                        * the remaining bytes, and we want to deliver it
> >                        * to monitoring devices in the next iteration.
> >                        */
> >                       pkt->tap_delivered = false;
> >
> >-                      spin_lock_bh(&vsock->send_pkt_list_lock);
> >-                      list_add(&pkt->list, &vsock->send_pkt_list);
> >-                      spin_unlock_bh(&vsock->send_pkt_list_lock);
> >+                      spin_lock_bh(lock);
> >+                      list_add(&pkt->list, send_pkt_list);
> >+                      spin_unlock_bh(lock);
> >               } else {
> >                       if (pkt->reply) {
> >                               int val;
> >@@ -228,6 +284,11 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
> >                       }
> >
> >                       virtio_transport_free_pkt(pkt);
> >+                      if (is_dgram) {
> >+                              spin_lock_bh(lock);
> >+                              vsock->dgram_used--;
> >+                              spin_unlock_bh(lock);
> >+                      }
> >               }
> >       } while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
> >       if (added)
> >@@ -251,11 +312,25 @@ static void vhost_transport_send_pkt_work(struct vhost_work *work)
> >       vhost_transport_do_send_pkt(vsock, vq);
> > }
> >
> >+static void vhost_transport_dgram_send_pkt_work(struct vhost_work *work)
> >+{
> >+      struct vhost_virtqueue *vq;
> >+      struct vhost_vsock *vsock;
> >+
> >+      vsock = container_of(work, struct vhost_vsock, dgram_send_pkt_work);
> >+      vq = &vsock->vqs[VSOCK_VQ_DGRAM_RX];
> >+
> >+      vhost_transport_do_send_pkt(vsock, vq);
> >+}
> >+
> > static int
> > vhost_transport_send_pkt(struct virtio_vsock_pkt *pkt)
> > {
> >       struct vhost_vsock *vsock;
> >       int len = pkt->len;
> >+      spinlock_t *lock;
> >+      struct list_head *send_pkt_list;
> >+      struct vhost_work *work;
> >
> >       rcu_read_lock();
> >
> >@@ -267,14 +342,38 @@ vhost_transport_send_pkt(struct virtio_vsock_pkt *pkt)
> >               return -ENODEV;
> >       }
> >
> >+      if (pkt->hdr.type == VIRTIO_VSOCK_TYPE_STREAM) {
>              ^
>              le16_to_cpu(pkt->hdr.type)
> >+              lock = &vsock->send_pkt_list_lock;
> >+              send_pkt_list = &vsock->send_pkt_list;
> >+              work = &vsock->send_pkt_work;
> >+      } else if (pkt->hdr.type == VIRTIO_VSOCK_TYPE_DGRAM) {
>                     ^
>                     le16_to_cpu(pkt->hdr.type)
> >+              lock = &vsock->dgram_send_pkt_list_lock;
> >+              send_pkt_list = &vsock->dgram_send_pkt_list;
> >+              work = &vsock->dgram_send_pkt_work;
> >+      } else {
> >+              rcu_read_unlock();
> >+              virtio_transport_free_pkt(pkt);
> >+              return -EINVAL;
> >+      }
> >+
> >+
> >       if (pkt->reply)
> >               atomic_inc(&vsock->queued_replies);
> >
> >-      spin_lock_bh(&vsock->send_pkt_list_lock);
> >-      list_add_tail(&pkt->list, &vsock->send_pkt_list);
> >-      spin_unlock_bh(&vsock->send_pkt_list_lock);
> >+      spin_lock_bh(lock);
> >+      if (pkt->hdr.type == VIRTIO_VSOCK_TYPE_DGRAM) {
>              ^
>              le16_to_cpu(pkt->hdr.type)
> >+              if (vsock->dgram_used  == VHOST_VSOCK_DGRM_MAX_PENDING_PKT)
> >+                      len = -ENOMEM;
> >+              else {
> >+                      vsock->dgram_used++;
> >+                      list_add_tail(&pkt->list, send_pkt_list);
> >+              }
> >+      } else
> >+              list_add_tail(&pkt->list, send_pkt_list);
> >
> >-      vhost_work_queue(&vsock->dev, &vsock->send_pkt_work);
> >+      spin_unlock_bh(lock);
> >+
> >+      vhost_work_queue(&vsock->dev, work);
> >
> >       rcu_read_unlock();
> >       return len;
> >@@ -355,7 +454,8 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
> >               return NULL;
> >       }
> >
> >-      if (le16_to_cpu(pkt->hdr.type) == VIRTIO_VSOCK_TYPE_STREAM)
> >+      if (le16_to_cpu(pkt->hdr.type) == VIRTIO_VSOCK_TYPE_STREAM
> >+              || le16_to_cpu(pkt->hdr.type) == VIRTIO_VSOCK_TYPE_DGRAM)
> >               pkt->len = le32_to_cpu(pkt->hdr.len);
> >
> >       /* No payload */
> >@@ -442,6 +542,18 @@ static struct virtio_transport vhost_transport = {
> >       .send_pkt = vhost_transport_send_pkt,
> > };
> >
> >+static inline unsigned long busy_clock(void)
> >+{
> >+      return local_clock() >> 10;
> >+}
> >+
> >+static bool vhost_can_busy_poll(unsigned long endtime)
> >+{
> >+      return likely(!need_resched() && !time_after(busy_clock(), endtime) &&
> >+                    !signal_pending(current));
> >+}
> >+
> >+
> > static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
> > {
> >       struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
> >@@ -452,6 +564,8 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
> >       int head, pkts = 0, total_len = 0;
> >       unsigned int out, in;
> >       bool added = false;
> >+      unsigned long busyloop_timeout = VHOST_VSOCK_BUSY_POLL_TIMEOUT;
> >+      unsigned long endtime;
> >
> >       mutex_lock(&vq->mutex);
> >
> >@@ -461,11 +575,14 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
> >       if (!vq_meta_prefetch(vq))
> >               goto out;
> >
> >+      endtime = busy_clock() + busyloop_timeout;
> >       vhost_disable_notify(&vsock->dev, vq);
> >+      preempt_disable();
> >       do {
> >               u32 len;
> >
> >-              if (!vhost_vsock_more_replies(vsock)) {
> >+              if (vq == &vsock->vqs[VSOCK_VQ_TX]
> >+                      && !vhost_vsock_more_replies(vsock)) {
> >                       /* Stop tx until the device processes already
> >                        * pending replies.  Leave tx virtqueue
> >                        * callbacks disabled.
> >@@ -479,6 +596,11 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
> >                       break;
> >
> >               if (head == vq->num) {
> >+                      if (vhost_can_busy_poll(endtime)) {
> >+                              cpu_relax();
> >+                              continue;
> >+                      }
> >+
> >                       if (unlikely(vhost_enable_notify(&vsock->dev, vq))) {
> >                               vhost_disable_notify(&vsock->dev, vq);
> >                               continue;
> >@@ -510,6 +632,7 @@ static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
> >               total_len += len;
> >               added = true;
> >       } while(likely(!vhost_exceeds_weight(vq, ++pkts, total_len)));
> >+      preempt_enable();
> >
> > no_more_replies:
> >       if (added)
> >@@ -565,6 +688,7 @@ static int vhost_vsock_start(struct vhost_vsock *vsock)
> >        * let's kick the send worker to send them.
> >        */
> >       vhost_work_queue(&vsock->dev, &vsock->send_pkt_work);
> >+      vhost_work_queue(&vsock->dev, &vsock->dgram_send_pkt_work);
> >
> >       mutex_unlock(&vsock->dev.mutex);
> >       return 0;
> >@@ -639,8 +763,14 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
> >
> >       vqs[VSOCK_VQ_TX] = &vsock->vqs[VSOCK_VQ_TX];
> >       vqs[VSOCK_VQ_RX] = &vsock->vqs[VSOCK_VQ_RX];
> >+      vqs[VSOCK_VQ_DGRAM_TX] = &vsock->vqs[VSOCK_VQ_DGRAM_TX];
> >+      vqs[VSOCK_VQ_DGRAM_RX] = &vsock->vqs[VSOCK_VQ_DGRAM_RX];
> >       vsock->vqs[VSOCK_VQ_TX].handle_kick = vhost_vsock_handle_tx_kick;
> >       vsock->vqs[VSOCK_VQ_RX].handle_kick = vhost_vsock_handle_rx_kick;
> >+      vsock->vqs[VSOCK_VQ_DGRAM_TX].handle_kick =
> >+                                              vhost_vsock_handle_tx_kick;
> >+      vsock->vqs[VSOCK_VQ_DGRAM_RX].handle_kick =
> >+                                              vhost_vsock_handle_rx_kick;
> >
> >       vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs),
> >                      UIO_MAXIOV, VHOST_VSOCK_PKT_WEIGHT,
> >@@ -650,6 +780,11 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
> >       spin_lock_init(&vsock->send_pkt_list_lock);
> >       INIT_LIST_HEAD(&vsock->send_pkt_list);
> >       vhost_work_init(&vsock->send_pkt_work, vhost_transport_send_pkt_work);
> >+      spin_lock_init(&vsock->dgram_send_pkt_list_lock);
> >+      INIT_LIST_HEAD(&vsock->dgram_send_pkt_list);
> >+      vhost_work_init(&vsock->dgram_send_pkt_work,
> >+                      vhost_transport_dgram_send_pkt_work);
> >+
> >       return 0;
> >
> > out:
> >@@ -665,6 +800,7 @@ static void vhost_vsock_flush(struct vhost_vsock *vsock)
> >               if (vsock->vqs[i].handle_kick)
> >                       vhost_poll_flush(&vsock->vqs[i].poll);
> >       vhost_work_flush(&vsock->dev, &vsock->send_pkt_work);
> >+      vhost_work_flush(&vsock->dev, &vsock->dgram_send_pkt_work);
> > }
> >
> > static void vhost_vsock_reset_orphans(struct sock *sk)
> >@@ -724,6 +860,17 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
> >       }
> >       spin_unlock_bh(&vsock->send_pkt_list_lock);
> >
> >+      spin_lock_bh(&vsock->dgram_send_pkt_list_lock);
> >+      while (!list_empty(&vsock->dgram_send_pkt_list)) {
> >+              struct virtio_vsock_pkt *pkt;
> >+
> >+              pkt = list_first_entry(&vsock->dgram_send_pkt_list,
> >+                              struct virtio_vsock_pkt, list);
> >+              list_del_init(&pkt->list);
> >+              virtio_transport_free_pkt(pkt);
> >+      }
> >+      spin_unlock_bh(&vsock->dgram_send_pkt_list_lock);
> >+
> >       vhost_dev_cleanup(&vsock->dev);
> >       kfree(vsock->dev.vqs);
> >       vhost_vsock_free(vsock);
> >@@ -906,7 +1053,7 @@ static int __init vhost_vsock_init(void)
> >       int ret;
> >
> >       ret = vsock_core_register(&vhost_transport.transport,
> >-                                VSOCK_TRANSPORT_F_H2G);
> >+                                VSOCK_TRANSPORT_F_H2G | VSOCK_TRANSPORT_F_DGRAM);
> >       if (ret < 0)
> >               return ret;
> >       return misc_register(&vhost_vsock_misc);
> >--
> >2.11.0
> >
>
