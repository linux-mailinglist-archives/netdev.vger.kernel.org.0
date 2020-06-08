Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216D01F194A
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 14:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729791AbgFHMyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 08:54:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23190 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729717AbgFHMxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 08:53:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591620800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=53ZvoqSQRb7zo4P/bKE7PS6beB3wyT4RaZMP+gyjZts=;
        b=hOTw0c8TQrYD8fwTe11orABRd59qSwRlBGJaD051xDgrRkr+Kxmp1TSJAIRjNGnbnWiVnM
        A0pXoXeZsWfZRTK55bfUVqJZw0SkLkBen3/HgnQteCCfo02I/PASfwUJBGyg20vv4fI4Lz
        IVTf9AjO1ksNAHseG2LZmucjCoCV4q8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-nSHNPEOSMU2-qpdawNXnpQ-1; Mon, 08 Jun 2020 08:53:18 -0400
X-MC-Unique: nSHNPEOSMU2-qpdawNXnpQ-1
Received: by mail-wr1-f71.google.com with SMTP id t5so7100523wro.20
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 05:53:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=53ZvoqSQRb7zo4P/bKE7PS6beB3wyT4RaZMP+gyjZts=;
        b=KkaOmHF2NJw3UEqGIiGRQaivRe/R3J2x7BQRs/59Y2tBjh0evc0KVoPw4vmaiG5+D8
         ThgfyBlonHsKXcLyGKgx960g1hW2YusJlmekBqLIh78lANdZGQKh5Xbf0dqpDsV+zWo/
         pbotxnGY8khjygUx0at+T4ro7IkpNfJZFBnS1yFPIWIUMLHwnAknAuVeDZ87xe+quWIy
         X8npJhj6PGCP1um7zvdFJLHtgFtHJ8NVny7/BJLWNQ2G9hcEmrhyqjI/qSWCusxey+T2
         vbwAGAdLaxzuL3UM3M3JmCmPQeKiZiYURMsXi6te8h0cAdFxlloQjCzjxWmad/C0fCbt
         w2+A==
X-Gm-Message-State: AOAM533gOAfaVnH/soxtZ79xQ31E7EW/LqvBuTxw9prtwcz3tFB+8rl7
        l884DikioZk7KB/w8MyeKBpDQ5LX+JnBgRpVXqlEqc7qFdnh1WsJbIXDTymtoEzif9LRkk4yXPH
        dkPwCE/KiyVKL+zGk
X-Received: by 2002:adf:a18b:: with SMTP id u11mr23319164wru.102.1591620797779;
        Mon, 08 Jun 2020 05:53:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwqxu8B0D+dmfKRmG6m0k8N+mfH4DtG2okPcTFiiTciSa1DwJ+py71/ReHBdaFke8bA3qVg4w==
X-Received: by 2002:adf:a18b:: with SMTP id u11mr23319147wru.102.1591620797545;
        Mon, 08 Jun 2020 05:53:17 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id c16sm8782123wml.45.2020.06.08.05.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 05:53:17 -0700 (PDT)
Date:   Mon, 8 Jun 2020 08:53:15 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        eperezma@redhat.com
Subject: [PATCH RFC v6 11/11] vhost: drop head based APIs
Message-ID: <20200608125238.728563-12-mst@redhat.com>
References: <20200608125238.728563-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200608125238.728563-1-mst@redhat.com>
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Everyone's using buf APIs, no need for head based ones anymore.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/vhost.c | 43 ++++++++-----------------------------------
 drivers/vhost/vhost.h | 12 ------------
 2 files changed, 8 insertions(+), 47 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index f4a6ff9ef77a..7bd4bc581fc9 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2429,18 +2429,11 @@ EXPORT_SYMBOL_GPL(vhost_get_avail_buf);
 void vhost_discard_avail_bufs(struct vhost_virtqueue *vq,
 			      struct vhost_buf *buf, unsigned count)
 {
-	vhost_discard_vq_desc(vq, count);
+	unfetch_descs(vq);
+	vq->last_avail_idx -= count;
 }
 EXPORT_SYMBOL_GPL(vhost_discard_avail_bufs);
 
-/* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
-void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
-{
-	unfetch_descs(vq);
-	vq->last_avail_idx -= n;
-}
-EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
-
 static int __vhost_add_used_n(struct vhost_virtqueue *vq,
 			    struct vring_used_elem *heads,
 			    unsigned count)
@@ -2473,8 +2466,7 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
 	return 0;
 }
 
-/* After we've used one of their buffers, we tell them about it.  We'll then
- * want to notify the guest, using eventfd. */
+static
 int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
 		     unsigned count)
 {
@@ -2508,10 +2500,8 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
 	}
 	return r;
 }
-EXPORT_SYMBOL_GPL(vhost_add_used_n);
 
-/* After we've used one of their buffers, we tell them about it.  We'll then
- * want to notify the guest, using eventfd. */
+static
 int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
 {
 	struct vring_used_elem heads = {
@@ -2521,14 +2511,17 @@ int vhost_add_used(struct vhost_virtqueue *vq, unsigned int head, int len)
 
 	return vhost_add_used_n(vq, &heads, 1);
 }
-EXPORT_SYMBOL_GPL(vhost_add_used);
 
+/* After we've used one of their buffers, we tell them about it.  We'll then
+ * want to notify the guest, using vhost_signal. */
 int vhost_put_used_buf(struct vhost_virtqueue *vq, struct vhost_buf *buf)
 {
 	return vhost_add_used(vq, buf->id, buf->in_len);
 }
 EXPORT_SYMBOL_GPL(vhost_put_used_buf);
 
+/* After we've used one of their buffers, we tell them about it.  We'll then
+ * want to notify the guest, using vhost_signal. */
 int vhost_put_used_n_bufs(struct vhost_virtqueue *vq,
 			  struct vhost_buf *bufs, unsigned count)
 {
@@ -2589,26 +2582,6 @@ void vhost_signal(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 }
 EXPORT_SYMBOL_GPL(vhost_signal);
 
-/* And here's the combo meal deal.  Supersize me! */
-void vhost_add_used_and_signal(struct vhost_dev *dev,
-			       struct vhost_virtqueue *vq,
-			       unsigned int head, int len)
-{
-	vhost_add_used(vq, head, len);
-	vhost_signal(dev, vq);
-}
-EXPORT_SYMBOL_GPL(vhost_add_used_and_signal);
-
-/* multi-buffer version of vhost_add_used_and_signal */
-void vhost_add_used_and_signal_n(struct vhost_dev *dev,
-				 struct vhost_virtqueue *vq,
-				 struct vring_used_elem *heads, unsigned count)
-{
-	vhost_add_used_n(vq, heads, count);
-	vhost_signal(dev, vq);
-}
-EXPORT_SYMBOL_GPL(vhost_add_used_and_signal_n);
-
 /* return true if we're sure that avaiable ring is empty */
 bool vhost_vq_avail_empty(struct vhost_dev *dev, struct vhost_virtqueue *vq)
 {
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 28eea0155efb..264a2a2fae97 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -197,11 +197,6 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 bool vhost_vq_access_ok(struct vhost_virtqueue *vq);
 bool vhost_log_access_ok(struct vhost_dev *);
 
-int vhost_get_vq_desc(struct vhost_virtqueue *,
-		      struct iovec iov[], unsigned int iov_count,
-		      unsigned int *out_num, unsigned int *in_num,
-		      struct vhost_log *log, unsigned int *log_num);
-void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
 int vhost_get_avail_buf(struct vhost_virtqueue *, struct vhost_buf *buf,
 			struct iovec iov[], unsigned int iov_count,
 			unsigned int *out_num, unsigned int *in_num,
@@ -209,13 +204,6 @@ int vhost_get_avail_buf(struct vhost_virtqueue *, struct vhost_buf *buf,
 void vhost_discard_avail_bufs(struct vhost_virtqueue *,
 			      struct vhost_buf *, unsigned count);
 int vhost_vq_init_access(struct vhost_virtqueue *);
-int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
-int vhost_add_used_n(struct vhost_virtqueue *, struct vring_used_elem *heads,
-		     unsigned count);
-void vhost_add_used_and_signal(struct vhost_dev *, struct vhost_virtqueue *,
-			       unsigned int id, int len);
-void vhost_add_used_and_signal_n(struct vhost_dev *, struct vhost_virtqueue *,
-			       struct vring_used_elem *heads, unsigned count);
 int vhost_put_used_buf(struct vhost_virtqueue *, struct vhost_buf *buf);
 int vhost_put_used_n_bufs(struct vhost_virtqueue *,
 			  struct vhost_buf *bufs, unsigned count);
-- 
MST

