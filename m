Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267A259741A
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 18:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240656AbiHQQXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 12:23:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240360AbiHQQXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 12:23:52 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438B82B271;
        Wed, 17 Aug 2022 09:23:49 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id f28so12504018pfk.1;
        Wed, 17 Aug 2022 09:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=6vg5hufIijS0nAs1CVstfoLa78cX4vu6Ml5LiiijcTM=;
        b=UPuQ2jS3aMuZzte7gVBNRk9JUxN3E+VGdM9OgeTvydWjAfb+KU1BpHFG1+JfaJLMqQ
         GMisu3HHwBrG5yqVKD0NqAi2i/LtXD3dd33vWBYNkt7sTjUU7aFpt4QOdh47b3B8BhqT
         UH/i4FqsVm2gUhne3WWiX3/WfsC/KJChNl/nTg4qielBklmWeh624C6iB4HgmVwLO7gJ
         x8OiUd7mEoPyCMFTtJACrSvs1sR1izZULPZuqWkLiNWUzs95RAWTPb6w441jl+owB1Du
         tOLCRL9E62pJok1ZMeWEdl85Fw0DcB7/PWCV5/qWsnuCxvOmZWSy81xqrRFguqljLGWN
         MfBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=6vg5hufIijS0nAs1CVstfoLa78cX4vu6Ml5LiiijcTM=;
        b=wIw4jHwjgPxahNm4KrFssOWpYyIyZv3Nxr1Vu1jX2jUbPqeQ9Im18zuliYG0rc75F4
         7vtbpDBs+nbwajmK5jeuv0OzoqZCVLzJT9GXlFSLw0uvU7WxdtxraVWDfJgYc+f/Vn3t
         +rd80TtfKcokJ9bYS++SSfxEeY1OD5DGsQTycPZ+NqMjZ6Za572H4ykO4Xti6vQDue00
         l1icdUiFCvmot6REA2ccUEtAlnZ7IwU0Qq8b1fv4Jmk8XCHoZ6xrvYPwUJDqGgFX2EIo
         6+bouM44+RZ2bXBFZxarDA6+l/W4Jnw7m0sSBmkEBAYF52IhvSn6Zt9dBYE57cxXR9Gw
         OSZg==
X-Gm-Message-State: ACgBeo3lRa60UL5ABMVnlTi2n6i18y7wicrGxiwRbwvRWyJ9Tpnxhsyt
        nWPbBz5q7OV7hJY5wp3H6VE=
X-Google-Smtp-Source: AA6agR5W78qYrmCWFV/wMLWoP2AtTaAN/Rs4Mr5x92ITClYS5Z7dGdDRgWLZiv2uqlhzrPz++XdE5A==
X-Received: by 2002:a63:494a:0:b0:41c:f29e:2a2e with SMTP id y10-20020a63494a000000b0041cf29e2a2emr22368442pgk.477.1660753428473;
        Wed, 17 Aug 2022 09:23:48 -0700 (PDT)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id jm3-20020a17090b41c300b001faaed06ce2sm1770673pjb.28.2022.08.17.09.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 09:23:47 -0700 (PDT)
Date:   Tue, 16 Aug 2022 09:57:13 +0000
From:   Bobby Eshleman <bobbyeshleman@gmail.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     Bobby Eshleman <bobby.eshleman@gmail.com>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
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
        Paolo Abeni <pabeni@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [virtio-dev] Re: [PATCH 5/6] virtio/vsock: add support for dgram
Message-ID: <YvtpbiquVculLyqF@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <3cb082f1c88f3f2ef1fc250dbc0745fb79c745c7.1660362668.git.bobby.eshleman@bytedance.com>
 <YvsBqpEoq1tbgj8A@bullseye>
 <9a411184-9b14-ee72-dcbf-05271139db0a@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a411184-9b14-ee72-dcbf-05271139db0a@sberdevices.ru>
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_24_48,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 05:01:00AM +0000, Arseniy Krasnov wrote:
> On 16.08.2022 05:32, Bobby Eshleman wrote:
> > CC'ing virtio-dev@lists.oasis-open.org
> > 
> > On Mon, Aug 15, 2022 at 10:56:08AM -0700, Bobby Eshleman wrote:
> >> This patch supports dgram in virtio and on the vhost side.
> Hello,
> 
> sorry, i don't understand, how this maintains message boundaries? Or it
> is unnecessary for SOCK_DGRAM?
> 
> Thanks

If I understand your question, the length is included in the header, so
receivers always know that header start + header length + payload length
marks the message boundary.

> >>
> >> Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> >> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> >> ---
> >>  drivers/vhost/vsock.c                   |   2 +-
> >>  include/net/af_vsock.h                  |   2 +
> >>  include/uapi/linux/virtio_vsock.h       |   1 +
> >>  net/vmw_vsock/af_vsock.c                |  26 +++-
> >>  net/vmw_vsock/virtio_transport.c        |   2 +-
> >>  net/vmw_vsock/virtio_transport_common.c | 173 ++++++++++++++++++++++--
> >>  6 files changed, 186 insertions(+), 20 deletions(-)
> >>
> >> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> >> index a5d1bdb786fe..3dc72a5647ca 100644
> >> --- a/drivers/vhost/vsock.c
> >> +++ b/drivers/vhost/vsock.c
> >> @@ -925,7 +925,7 @@ static int __init vhost_vsock_init(void)
> >>  	int ret;
> >>  
> >>  	ret = vsock_core_register(&vhost_transport.transport,
> >> -				  VSOCK_TRANSPORT_F_H2G);
> >> +				  VSOCK_TRANSPORT_F_H2G | VSOCK_TRANSPORT_F_DGRAM);
> >>  	if (ret < 0)
> >>  		return ret;
> >>  
> >> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> >> index 1c53c4c4d88f..37e55c81e4df 100644
> >> --- a/include/net/af_vsock.h
> >> +++ b/include/net/af_vsock.h
> >> @@ -78,6 +78,8 @@ struct vsock_sock {
> >>  s64 vsock_stream_has_data(struct vsock_sock *vsk);
> >>  s64 vsock_stream_has_space(struct vsock_sock *vsk);
> >>  struct sock *vsock_create_connected(struct sock *parent);
> >> +int vsock_bind_stream(struct vsock_sock *vsk,
> >> +		      struct sockaddr_vm *addr);
> >>  
> >>  /**** TRANSPORT ****/
> >>  
> >> diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
> >> index 857df3a3a70d..0975b9c88292 100644
> >> --- a/include/uapi/linux/virtio_vsock.h
> >> +++ b/include/uapi/linux/virtio_vsock.h
> >> @@ -70,6 +70,7 @@ struct virtio_vsock_hdr {
> >>  enum virtio_vsock_type {
> >>  	VIRTIO_VSOCK_TYPE_STREAM = 1,
> >>  	VIRTIO_VSOCK_TYPE_SEQPACKET = 2,
> >> +	VIRTIO_VSOCK_TYPE_DGRAM = 3,
> >>  };
> >>  
> >>  enum virtio_vsock_op {
> >> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> >> index 1893f8aafa48..87e4ae1866d3 100644
> >> --- a/net/vmw_vsock/af_vsock.c
> >> +++ b/net/vmw_vsock/af_vsock.c
> >> @@ -675,6 +675,19 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
> >>  	return 0;
> >>  }
> >>  
> >> +int vsock_bind_stream(struct vsock_sock *vsk,
> >> +		      struct sockaddr_vm *addr)
> >> +{
> >> +	int retval;
> >> +
> >> +	spin_lock_bh(&vsock_table_lock);
> >> +	retval = __vsock_bind_connectible(vsk, addr);
> >> +	spin_unlock_bh(&vsock_table_lock);
> >> +
> >> +	return retval;
> >> +}
> >> +EXPORT_SYMBOL(vsock_bind_stream);
> >> +
> >>  static int __vsock_bind_dgram(struct vsock_sock *vsk,
> >>  			      struct sockaddr_vm *addr)
> >>  {
> >> @@ -2363,11 +2376,16 @@ int vsock_core_register(const struct vsock_transport *t, int features)
> >>  	}
> >>  
> >>  	if (features & VSOCK_TRANSPORT_F_DGRAM) {
> >> -		if (t_dgram) {
> >> -			err = -EBUSY;
> >> -			goto err_busy;
> >> +		/* TODO: always chose the G2H variant over others, support nesting later */
> >> +		if (features & VSOCK_TRANSPORT_F_G2H) {
> >> +			if (t_dgram)
> >> +				pr_warn("virtio_vsock: t_dgram already set\n");
> >> +			t_dgram = t;
> >> +		}
> >> +
> >> +		if (!t_dgram) {
> >> +			t_dgram = t;
> >>  		}
> >> -		t_dgram = t;
> >>  	}
> >>  
> >>  	if (features & VSOCK_TRANSPORT_F_LOCAL) {
> >> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> >> index 073314312683..d4526ca462d2 100644
> >> --- a/net/vmw_vsock/virtio_transport.c
> >> +++ b/net/vmw_vsock/virtio_transport.c
> >> @@ -850,7 +850,7 @@ static int __init virtio_vsock_init(void)
> >>  		return -ENOMEM;
> >>  
> >>  	ret = vsock_core_register(&virtio_transport.transport,
> >> -				  VSOCK_TRANSPORT_F_G2H);
> >> +				  VSOCK_TRANSPORT_F_G2H | VSOCK_TRANSPORT_F_DGRAM);
> >>  	if (ret)
> >>  		goto out_wq;
> >>  
> >> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> >> index bdf16fff054f..aedb48728677 100644
> >> --- a/net/vmw_vsock/virtio_transport_common.c
> >> +++ b/net/vmw_vsock/virtio_transport_common.c
> >> @@ -229,7 +229,9 @@ EXPORT_SYMBOL_GPL(virtio_transport_deliver_tap_pkt);
> >>  
> >>  static u16 virtio_transport_get_type(struct sock *sk)
> >>  {
> >> -	if (sk->sk_type == SOCK_STREAM)
> >> +	if (sk->sk_type == SOCK_DGRAM)
> >> +		return VIRTIO_VSOCK_TYPE_DGRAM;
> >> +	else if (sk->sk_type == SOCK_STREAM)
> >>  		return VIRTIO_VSOCK_TYPE_STREAM;
> >>  	else
> >>  		return VIRTIO_VSOCK_TYPE_SEQPACKET;
> >> @@ -287,22 +289,29 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
> >>  	vvs = vsk->trans;
> >>  
> >>  	/* we can send less than pkt_len bytes */
> >> -	if (pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
> >> -		pkt_len = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
> >> +	if (pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE) {
> >> +		if (info->type != VIRTIO_VSOCK_TYPE_DGRAM)
> >> +			pkt_len = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
> >> +		else
> >> +			return 0;
> >> +	}
> >>  
> >> -	/* virtio_transport_get_credit might return less than pkt_len credit */
> >> -	pkt_len = virtio_transport_get_credit(vvs, pkt_len);
> >> +	if (info->type != VIRTIO_VSOCK_TYPE_DGRAM) {
> >> +		/* virtio_transport_get_credit might return less than pkt_len credit */
> >> +		pkt_len = virtio_transport_get_credit(vvs, pkt_len);
> >>  
> >> -	/* Do not send zero length OP_RW pkt */
> >> -	if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
> >> -		return pkt_len;
> >> +		/* Do not send zero length OP_RW pkt */
> >> +		if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
> >> +			return pkt_len;
> >> +	}
> >>  
> >>  	skb = virtio_transport_alloc_skb(info, pkt_len,
> >>  					 src_cid, src_port,
> >>  					 dst_cid, dst_port,
> >>  					 &err);
> >>  	if (!skb) {
> >> -		virtio_transport_put_credit(vvs, pkt_len);
> >> +		if (info->type != VIRTIO_VSOCK_TYPE_DGRAM)
> >> +			virtio_transport_put_credit(vvs, pkt_len);
> >>  		return err;
> >>  	}
> >>  
> >> @@ -586,6 +595,61 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
> >>  }
> >>  EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
> >>  
> >> +static ssize_t
> >> +virtio_transport_dgram_do_dequeue(struct vsock_sock *vsk,
> >> +				  struct msghdr *msg, size_t len)
> >> +{
> >> +	struct virtio_vsock_sock *vvs = vsk->trans;
> >> +	struct sk_buff *skb;
> >> +	size_t total = 0;
> >> +	u32 free_space;
> >> +	int err = -EFAULT;
> >> +
> >> +	spin_lock_bh(&vvs->rx_lock);
> >> +	if (total < len && !skb_queue_empty_lockless(&vvs->rx_queue)) {
> >> +		skb = __skb_dequeue(&vvs->rx_queue);
> >> +
> >> +		total = len;
> >> +		if (total > skb->len - vsock_metadata(skb)->off)
> >> +			total = skb->len - vsock_metadata(skb)->off;
> >> +		else if (total < skb->len - vsock_metadata(skb)->off)
> >> +			msg->msg_flags |= MSG_TRUNC;
> >> +
> >> +		/* sk_lock is held by caller so no one else can dequeue.
> >> +		 * Unlock rx_lock since memcpy_to_msg() may sleep.
> >> +		 */
> >> +		spin_unlock_bh(&vvs->rx_lock);
> >> +
> >> +		err = memcpy_to_msg(msg, skb->data + vsock_metadata(skb)->off, total);
> >> +		if (err)
> >> +			return err;
> >> +
> >> +		spin_lock_bh(&vvs->rx_lock);
> >> +
> >> +		virtio_transport_dec_rx_pkt(vvs, skb);
> >> +		consume_skb(skb);
> >> +	}
> >> +
> >> +	free_space = vvs->buf_alloc - (vvs->fwd_cnt - vvs->last_fwd_cnt);
> >> +
> >> +	spin_unlock_bh(&vvs->rx_lock);
> >> +
> >> +	if (total > 0 && msg->msg_name) {
> >> +		/* Provide the address of the sender. */
> >> +		DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
> >> +
> >> +		vsock_addr_init(vm_addr, le64_to_cpu(vsock_hdr(skb)->src_cid),
> >> +				le32_to_cpu(vsock_hdr(skb)->src_port));
> >> +		msg->msg_namelen = sizeof(*vm_addr);
> >> +	}
> >> +	return total;
> >> +}
> >> +
> >> +static s64 virtio_transport_dgram_has_data(struct vsock_sock *vsk)
> >> +{
> >> +	return virtio_transport_stream_has_data(vsk);
> >> +}
> >> +
> >>  int
> >>  virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
> >>  				   struct msghdr *msg,
> >> @@ -611,7 +675,66 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> >>  			       struct msghdr *msg,
> >>  			       size_t len, int flags)
> >>  {
> >> -	return -EOPNOTSUPP;
> >> +	struct sock *sk;
> >> +	size_t err = 0;
> >> +	long timeout;
> >> +
> >> +	DEFINE_WAIT(wait);
> >> +
> >> +	sk = &vsk->sk;
> >> +	err = 0;
> >> +
> >> +	if (flags & MSG_OOB || flags & MSG_ERRQUEUE || flags & MSG_PEEK)
> >> +		return -EOPNOTSUPP;
> >> +
> >> +	lock_sock(sk);
> >> +
> >> +	if (!len)
> >> +		goto out;
> >> +
> >> +	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
> >> +
> >> +	while (1) {
> >> +		s64 ready;
> >> +
> >> +		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
> >> +		ready = virtio_transport_dgram_has_data(vsk);
> >> +
> >> +		if (ready == 0) {
> >> +			if (timeout == 0) {
> >> +				err = -EAGAIN;
> >> +				finish_wait(sk_sleep(sk), &wait);
> >> +				break;
> >> +			}
> >> +
> >> +			release_sock(sk);
> >> +			timeout = schedule_timeout(timeout);
> >> +			lock_sock(sk);
> >> +
> >> +			if (signal_pending(current)) {
> >> +				err = sock_intr_errno(timeout);
> >> +				finish_wait(sk_sleep(sk), &wait);
> >> +				break;
> >> +			} else if (timeout == 0) {
> >> +				err = -EAGAIN;
> >> +				finish_wait(sk_sleep(sk), &wait);
> >> +				break;
> >> +			}
> >> +		} else {
> >> +			finish_wait(sk_sleep(sk), &wait);
> >> +
> >> +			if (ready < 0) {
> >> +				err = -ENOMEM;
> >> +				goto out;
> >> +			}
> >> +
> >> +			err = virtio_transport_dgram_do_dequeue(vsk, msg, len);
> >> +			break;
> >> +		}
> >> +	}
> >> +out:
> >> +	release_sock(sk);
> >> +	return err;
> >>  }
> >>  EXPORT_SYMBOL_GPL(virtio_transport_dgram_dequeue);
> >>  
> >> @@ -819,13 +942,13 @@ EXPORT_SYMBOL_GPL(virtio_transport_stream_allow);
> >>  int virtio_transport_dgram_bind(struct vsock_sock *vsk,
> >>  				struct sockaddr_vm *addr)
> >>  {
> >> -	return -EOPNOTSUPP;
> >> +	return vsock_bind_stream(vsk, addr);
> >>  }
> >>  EXPORT_SYMBOL_GPL(virtio_transport_dgram_bind);
> >>  
> >>  bool virtio_transport_dgram_allow(u32 cid, u32 port)
> >>  {
> >> -	return false;
> >> +	return true;
> >>  }
> >>  EXPORT_SYMBOL_GPL(virtio_transport_dgram_allow);
> >>  
> >> @@ -861,7 +984,16 @@ virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
> >>  			       struct msghdr *msg,
> >>  			       size_t dgram_len)
> >>  {
> >> -	return -EOPNOTSUPP;
> >> +	struct virtio_vsock_pkt_info info = {
> >> +		.op = VIRTIO_VSOCK_OP_RW,
> >> +		.msg = msg,
> >> +		.pkt_len = dgram_len,
> >> +		.vsk = vsk,
> >> +		.remote_cid = remote_addr->svm_cid,
> >> +		.remote_port = remote_addr->svm_port,
> >> +	};
> >> +
> >> +	return virtio_transport_send_pkt_info(vsk, &info);
> >>  }
> >>  EXPORT_SYMBOL_GPL(virtio_transport_dgram_enqueue);
> >>  
> >> @@ -1165,6 +1297,12 @@ virtio_transport_recv_connected(struct sock *sk,
> >>  	struct virtio_vsock_hdr *hdr = vsock_hdr(skb);
> >>  	int err = 0;
> >>  
> >> +	if (le16_to_cpu(vsock_hdr(skb)->type) == VIRTIO_VSOCK_TYPE_DGRAM) {
> >> +		virtio_transport_recv_enqueue(vsk, skb);
> >> +		sk->sk_data_ready(sk);
> >> +		return err;
> >> +	}
> >> +
> >>  	switch (le16_to_cpu(hdr->op)) {
> >>  	case VIRTIO_VSOCK_OP_RW:
> >>  		virtio_transport_recv_enqueue(vsk, skb);
> >> @@ -1320,7 +1458,8 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
> >>  static bool virtio_transport_valid_type(u16 type)
> >>  {
> >>  	return (type == VIRTIO_VSOCK_TYPE_STREAM) ||
> >> -	       (type == VIRTIO_VSOCK_TYPE_SEQPACKET);
> >> +	       (type == VIRTIO_VSOCK_TYPE_SEQPACKET) ||
> >> +	       (type == VIRTIO_VSOCK_TYPE_DGRAM);
> >>  }
> >>  
> >>  /* We are under the virtio-vsock's vsock->rx_lock or vhost-vsock's vq->mutex
> >> @@ -1384,6 +1523,11 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
> >>  		goto free_pkt;
> >>  	}
> >>  
> >> +	if (sk->sk_type == SOCK_DGRAM) {
> >> +		virtio_transport_recv_connected(sk, skb);
> >> +		goto out;
> >> +	}
> >> +
> >>  	space_available = virtio_transport_space_update(sk, skb);
> >>  
> >>  	/* Update CID in case it has changed after a transport reset event */
> >> @@ -1415,6 +1559,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
> >>  		break;
> >>  	}
> >>  
> >> +out:
> >>  	release_sock(sk);
> >>  
> >>  	/* Release refcnt obtained when we fetched this socket out of the
> >> -- 
> >> 2.35.1
> >>
> > 
> > ---------------------------------------------------------------------
> > To unsubscribe, e-mail: virtio-dev-unsubscribe@lists.oasis-open.org
> > For additional commands, e-mail: virtio-dev-help@lists.oasis-open.org
> > 
> 
