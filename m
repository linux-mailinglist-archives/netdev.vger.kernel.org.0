Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA8459344B
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 20:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbiHOR4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 13:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbiHOR4o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 13:56:44 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8485C28703;
        Mon, 15 Aug 2022 10:56:43 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id c19-20020a17090ae11300b001f2f94ed5c6so12121026pjz.1;
        Mon, 15 Aug 2022 10:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc;
        bh=ftWZSl7ksgvSB2phD6FMsosVD6s+qstCxLlPMYxAP8c=;
        b=IQcBDUIOs9WS0gRKrn/SCTaSdmBXbadl67lf3z3/li6WQsPlybd4i2CboFKTbskG1A
         /atiwFi2BsH6VD400NnOSDsX8egCPWa3oGhxXO6nOvZb2oq2adgCWDLaoRgbkVONhE1+
         cTOeetB889l0zPwUkSec1W3cNuSJ7X9ftU7EUfrtw+/kESUP7LwFf1g23vXIvJ/Ph+II
         pVN4XsS1hwo84wADO1mrKS9hgE1bSNPibMSyl2FyZjVEodJA1w+CUE0I6vgqPKahH4H/
         EKGsSjpaUNTvDlxSZe9jSOqF+ArqyjaCZPzxCPjXJew7sG9jpUUpQY7eABmVFs66d+6v
         /+mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc;
        bh=ftWZSl7ksgvSB2phD6FMsosVD6s+qstCxLlPMYxAP8c=;
        b=XBJq4eQ+nI/zFOFJBpNDkTPFkgQuTznU1GfyJJYIYPGPKcBGwBOLozSvDWm82MUbeZ
         XHHuGz6SyWRcgOy/UuwWwMSRh16e9dkW331RArGuhgBJ2fBgNVjY47P/JEJCrQ898drj
         EdePUBo41PuABU4xxRCqz/PKfCg6ITHqvxFYIrXxHs4jGDjK4fNr9f2S9Yk2snJwIqP0
         9CuPBTCVxyKUfgTHVJSi2JlKW6kEkDn8X6PSgHdjtjMLTx6waIgsWL8PAJjLiNoR75Wl
         tdpvC3zIYaqMpokDCTvDe5dhqsF0jzhgBHzBEewsJtz29rGsTbxy4QL7y6VYqO7/pUj+
         duQg==
X-Gm-Message-State: ACgBeo2M3ZvRAClox6N8vSlojdhC1tCRzvQUfosbR6JXtwyQJFJ6v04n
        qBsobu2XkL0VMLfrwbmdZtY=
X-Google-Smtp-Source: AA6agR5sXKrJUyLiP/XvolaIvcSPIPwL+KohOxci8Jj4HkvpIT6mnYIqW18H8/z0iDMl2E63TvAntw==
X-Received: by 2002:a17:90a:2b42:b0:1f4:fc9a:be32 with SMTP id y2-20020a17090a2b4200b001f4fc9abe32mr28551802pjc.221.1660586202920;
        Mon, 15 Aug 2022 10:56:42 -0700 (PDT)
Received: from C02G8BMUMD6R.bytedance.net (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id o5-20020a170902d4c500b0016d6963cb12sm7299935plg.304.2022.08.15.10.56.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Aug 2022 10:56:42 -0700 (PDT)
Sender: Bobby Eshleman <bobbyeshleman@gmail.com>
From:   Bobby Eshleman <bobby.eshleman@gmail.com>
X-Google-Original-From: Bobby Eshleman <bobby.eshleman@bytedance.com>
Cc:     Bobby Eshleman <bobbyeshleman@gmail.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] virtio/vsock: add support for dgram
Date:   Mon, 15 Aug 2022 10:56:08 -0700
Message-Id: <3cb082f1c88f3f2ef1fc250dbc0745fb79c745c7.1660362668.git.bobby.eshleman@bytedance.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1660362668.git.bobby.eshleman@bytedance.com>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch supports dgram in virtio and on the vhost side.

Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
---
 drivers/vhost/vsock.c                   |   2 +-
 include/net/af_vsock.h                  |   2 +
 include/uapi/linux/virtio_vsock.h       |   1 +
 net/vmw_vsock/af_vsock.c                |  26 +++-
 net/vmw_vsock/virtio_transport.c        |   2 +-
 net/vmw_vsock/virtio_transport_common.c | 173 ++++++++++++++++++++++--
 6 files changed, 186 insertions(+), 20 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index a5d1bdb786fe..3dc72a5647ca 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -925,7 +925,7 @@ static int __init vhost_vsock_init(void)
 	int ret;
 
 	ret = vsock_core_register(&vhost_transport.transport,
-				  VSOCK_TRANSPORT_F_H2G);
+				  VSOCK_TRANSPORT_F_H2G | VSOCK_TRANSPORT_F_DGRAM);
 	if (ret < 0)
 		return ret;
 
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 1c53c4c4d88f..37e55c81e4df 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -78,6 +78,8 @@ struct vsock_sock {
 s64 vsock_stream_has_data(struct vsock_sock *vsk);
 s64 vsock_stream_has_space(struct vsock_sock *vsk);
 struct sock *vsock_create_connected(struct sock *parent);
+int vsock_bind_stream(struct vsock_sock *vsk,
+		      struct sockaddr_vm *addr);
 
 /**** TRANSPORT ****/
 
diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
index 857df3a3a70d..0975b9c88292 100644
--- a/include/uapi/linux/virtio_vsock.h
+++ b/include/uapi/linux/virtio_vsock.h
@@ -70,6 +70,7 @@ struct virtio_vsock_hdr {
 enum virtio_vsock_type {
 	VIRTIO_VSOCK_TYPE_STREAM = 1,
 	VIRTIO_VSOCK_TYPE_SEQPACKET = 2,
+	VIRTIO_VSOCK_TYPE_DGRAM = 3,
 };
 
 enum virtio_vsock_op {
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 1893f8aafa48..87e4ae1866d3 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -675,6 +675,19 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
 	return 0;
 }
 
+int vsock_bind_stream(struct vsock_sock *vsk,
+		      struct sockaddr_vm *addr)
+{
+	int retval;
+
+	spin_lock_bh(&vsock_table_lock);
+	retval = __vsock_bind_connectible(vsk, addr);
+	spin_unlock_bh(&vsock_table_lock);
+
+	return retval;
+}
+EXPORT_SYMBOL(vsock_bind_stream);
+
 static int __vsock_bind_dgram(struct vsock_sock *vsk,
 			      struct sockaddr_vm *addr)
 {
@@ -2363,11 +2376,16 @@ int vsock_core_register(const struct vsock_transport *t, int features)
 	}
 
 	if (features & VSOCK_TRANSPORT_F_DGRAM) {
-		if (t_dgram) {
-			err = -EBUSY;
-			goto err_busy;
+		/* TODO: always chose the G2H variant over others, support nesting later */
+		if (features & VSOCK_TRANSPORT_F_G2H) {
+			if (t_dgram)
+				pr_warn("virtio_vsock: t_dgram already set\n");
+			t_dgram = t;
+		}
+
+		if (!t_dgram) {
+			t_dgram = t;
 		}
-		t_dgram = t;
 	}
 
 	if (features & VSOCK_TRANSPORT_F_LOCAL) {
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 073314312683..d4526ca462d2 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -850,7 +850,7 @@ static int __init virtio_vsock_init(void)
 		return -ENOMEM;
 
 	ret = vsock_core_register(&virtio_transport.transport,
-				  VSOCK_TRANSPORT_F_G2H);
+				  VSOCK_TRANSPORT_F_G2H | VSOCK_TRANSPORT_F_DGRAM);
 	if (ret)
 		goto out_wq;
 
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index bdf16fff054f..aedb48728677 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -229,7 +229,9 @@ EXPORT_SYMBOL_GPL(virtio_transport_deliver_tap_pkt);
 
 static u16 virtio_transport_get_type(struct sock *sk)
 {
-	if (sk->sk_type == SOCK_STREAM)
+	if (sk->sk_type == SOCK_DGRAM)
+		return VIRTIO_VSOCK_TYPE_DGRAM;
+	else if (sk->sk_type == SOCK_STREAM)
 		return VIRTIO_VSOCK_TYPE_STREAM;
 	else
 		return VIRTIO_VSOCK_TYPE_SEQPACKET;
@@ -287,22 +289,29 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	vvs = vsk->trans;
 
 	/* we can send less than pkt_len bytes */
-	if (pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
-		pkt_len = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
+	if (pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE) {
+		if (info->type != VIRTIO_VSOCK_TYPE_DGRAM)
+			pkt_len = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
+		else
+			return 0;
+	}
 
-	/* virtio_transport_get_credit might return less than pkt_len credit */
-	pkt_len = virtio_transport_get_credit(vvs, pkt_len);
+	if (info->type != VIRTIO_VSOCK_TYPE_DGRAM) {
+		/* virtio_transport_get_credit might return less than pkt_len credit */
+		pkt_len = virtio_transport_get_credit(vvs, pkt_len);
 
-	/* Do not send zero length OP_RW pkt */
-	if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
-		return pkt_len;
+		/* Do not send zero length OP_RW pkt */
+		if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
+			return pkt_len;
+	}
 
 	skb = virtio_transport_alloc_skb(info, pkt_len,
 					 src_cid, src_port,
 					 dst_cid, dst_port,
 					 &err);
 	if (!skb) {
-		virtio_transport_put_credit(vvs, pkt_len);
+		if (info->type != VIRTIO_VSOCK_TYPE_DGRAM)
+			virtio_transport_put_credit(vvs, pkt_len);
 		return err;
 	}
 
@@ -586,6 +595,61 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
 }
 EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
 
+static ssize_t
+virtio_transport_dgram_do_dequeue(struct vsock_sock *vsk,
+				  struct msghdr *msg, size_t len)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	struct sk_buff *skb;
+	size_t total = 0;
+	u32 free_space;
+	int err = -EFAULT;
+
+	spin_lock_bh(&vvs->rx_lock);
+	if (total < len && !skb_queue_empty_lockless(&vvs->rx_queue)) {
+		skb = __skb_dequeue(&vvs->rx_queue);
+
+		total = len;
+		if (total > skb->len - vsock_metadata(skb)->off)
+			total = skb->len - vsock_metadata(skb)->off;
+		else if (total < skb->len - vsock_metadata(skb)->off)
+			msg->msg_flags |= MSG_TRUNC;
+
+		/* sk_lock is held by caller so no one else can dequeue.
+		 * Unlock rx_lock since memcpy_to_msg() may sleep.
+		 */
+		spin_unlock_bh(&vvs->rx_lock);
+
+		err = memcpy_to_msg(msg, skb->data + vsock_metadata(skb)->off, total);
+		if (err)
+			return err;
+
+		spin_lock_bh(&vvs->rx_lock);
+
+		virtio_transport_dec_rx_pkt(vvs, skb);
+		consume_skb(skb);
+	}
+
+	free_space = vvs->buf_alloc - (vvs->fwd_cnt - vvs->last_fwd_cnt);
+
+	spin_unlock_bh(&vvs->rx_lock);
+
+	if (total > 0 && msg->msg_name) {
+		/* Provide the address of the sender. */
+		DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
+
+		vsock_addr_init(vm_addr, le64_to_cpu(vsock_hdr(skb)->src_cid),
+				le32_to_cpu(vsock_hdr(skb)->src_port));
+		msg->msg_namelen = sizeof(*vm_addr);
+	}
+	return total;
+}
+
+static s64 virtio_transport_dgram_has_data(struct vsock_sock *vsk)
+{
+	return virtio_transport_stream_has_data(vsk);
+}
+
 int
 virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
 				   struct msghdr *msg,
@@ -611,7 +675,66 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
 			       struct msghdr *msg,
 			       size_t len, int flags)
 {
-	return -EOPNOTSUPP;
+	struct sock *sk;
+	size_t err = 0;
+	long timeout;
+
+	DEFINE_WAIT(wait);
+
+	sk = &vsk->sk;
+	err = 0;
+
+	if (flags & MSG_OOB || flags & MSG_ERRQUEUE || flags & MSG_PEEK)
+		return -EOPNOTSUPP;
+
+	lock_sock(sk);
+
+	if (!len)
+		goto out;
+
+	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
+
+	while (1) {
+		s64 ready;
+
+		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
+		ready = virtio_transport_dgram_has_data(vsk);
+
+		if (ready == 0) {
+			if (timeout == 0) {
+				err = -EAGAIN;
+				finish_wait(sk_sleep(sk), &wait);
+				break;
+			}
+
+			release_sock(sk);
+			timeout = schedule_timeout(timeout);
+			lock_sock(sk);
+
+			if (signal_pending(current)) {
+				err = sock_intr_errno(timeout);
+				finish_wait(sk_sleep(sk), &wait);
+				break;
+			} else if (timeout == 0) {
+				err = -EAGAIN;
+				finish_wait(sk_sleep(sk), &wait);
+				break;
+			}
+		} else {
+			finish_wait(sk_sleep(sk), &wait);
+
+			if (ready < 0) {
+				err = -ENOMEM;
+				goto out;
+			}
+
+			err = virtio_transport_dgram_do_dequeue(vsk, msg, len);
+			break;
+		}
+	}
+out:
+	release_sock(sk);
+	return err;
 }
 EXPORT_SYMBOL_GPL(virtio_transport_dgram_dequeue);
 
@@ -819,13 +942,13 @@ EXPORT_SYMBOL_GPL(virtio_transport_stream_allow);
 int virtio_transport_dgram_bind(struct vsock_sock *vsk,
 				struct sockaddr_vm *addr)
 {
-	return -EOPNOTSUPP;
+	return vsock_bind_stream(vsk, addr);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_dgram_bind);
 
 bool virtio_transport_dgram_allow(u32 cid, u32 port)
 {
-	return false;
+	return true;
 }
 EXPORT_SYMBOL_GPL(virtio_transport_dgram_allow);
 
@@ -861,7 +984,16 @@ virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
 			       struct msghdr *msg,
 			       size_t dgram_len)
 {
-	return -EOPNOTSUPP;
+	struct virtio_vsock_pkt_info info = {
+		.op = VIRTIO_VSOCK_OP_RW,
+		.msg = msg,
+		.pkt_len = dgram_len,
+		.vsk = vsk,
+		.remote_cid = remote_addr->svm_cid,
+		.remote_port = remote_addr->svm_port,
+	};
+
+	return virtio_transport_send_pkt_info(vsk, &info);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_dgram_enqueue);
 
@@ -1165,6 +1297,12 @@ virtio_transport_recv_connected(struct sock *sk,
 	struct virtio_vsock_hdr *hdr = vsock_hdr(skb);
 	int err = 0;
 
+	if (le16_to_cpu(vsock_hdr(skb)->type) == VIRTIO_VSOCK_TYPE_DGRAM) {
+		virtio_transport_recv_enqueue(vsk, skb);
+		sk->sk_data_ready(sk);
+		return err;
+	}
+
 	switch (le16_to_cpu(hdr->op)) {
 	case VIRTIO_VSOCK_OP_RW:
 		virtio_transport_recv_enqueue(vsk, skb);
@@ -1320,7 +1458,8 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
 static bool virtio_transport_valid_type(u16 type)
 {
 	return (type == VIRTIO_VSOCK_TYPE_STREAM) ||
-	       (type == VIRTIO_VSOCK_TYPE_SEQPACKET);
+	       (type == VIRTIO_VSOCK_TYPE_SEQPACKET) ||
+	       (type == VIRTIO_VSOCK_TYPE_DGRAM);
 }
 
 /* We are under the virtio-vsock's vsock->rx_lock or vhost-vsock's vq->mutex
@@ -1384,6 +1523,11 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 		goto free_pkt;
 	}
 
+	if (sk->sk_type == SOCK_DGRAM) {
+		virtio_transport_recv_connected(sk, skb);
+		goto out;
+	}
+
 	space_available = virtio_transport_space_update(sk, skb);
 
 	/* Update CID in case it has changed after a transport reset event */
@@ -1415,6 +1559,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 		break;
 	}
 
+out:
 	release_sock(sk);
 
 	/* Release refcnt obtained when we fetched this socket out of the
-- 
2.35.1

