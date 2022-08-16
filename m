Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD13597417
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 18:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240603AbiHQQYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 12:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239354AbiHQQYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 12:24:53 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE67C9D8D0;
        Wed, 17 Aug 2022 09:24:51 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id s206so12393742pgs.3;
        Wed, 17 Aug 2022 09:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=HJzX0Dc8yVEJlfoerjNKLSSwnhJ54Sshnyaxt3AN7KQ=;
        b=fT2RkHhDFXtaUaaJTpva7djYlmmenJZZLTYjC+6age+5ZBjjxuPqXuZ5o2srOk3JLM
         rnrbDa5p3aIxjjfmN3ZOF12DxHpssVut10KrITxEjq0tp2m8PigFiI5uP1ciDYEEWK6x
         7ZySC+Ao/LJIqXYyuqjw2FEBwzMZRIWQI2h/8NVrFRK4IGUNi2a4pj7mNmSSdbjsRWs/
         ZaMzKeO2JQPRSMuLkdf7ZpKI5hygtseTJvLDoK6i/THlNO29FHUMjKmwScBNkTvDRayR
         TpYQTdrYYYIJBCfjqJ8Q8ajRv/aXs7qtEKA/EqKPYIiJ59GViltZ1H2F7oAAgaOhgyuI
         kgGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=HJzX0Dc8yVEJlfoerjNKLSSwnhJ54Sshnyaxt3AN7KQ=;
        b=QWZ9LzMQBuBNFxgp7JcOtpqiNsTVytedIqfGxl57ip77SR+NeMqZDb/7DWB4n/klWy
         EaOxUAZWBIIhP6llFlLX0tH2liQJbjse8pgrH6CpZtiZYU/ikwVBH3qpo2m39WiXx5Ew
         Jq+xHdh8wL0I58kX69waKrS/aJfCQ57xwmyszmHKCjzZ1YLSd7Of8lxZqOUJ09m+w/xt
         JfjZESL+IhA32M9eyQElnZXLt2kNodfL6eqO5j0ayP0GGnKJkY2QjkoMSWJzQcuaOsj1
         q8GizTw1NlHv4jmLRe/JVVWvfY6RRJtC5vrutZHGoX2ATQ0hXrovqvNHiXSXH3BAA6H7
         F+rw==
X-Gm-Message-State: ACgBeo3cPA7o7x9iI+Ri/qwpiKpWNhHZADg2tixLXgZuT6r5rHF5h2Sj
        rKPBBbrtJlhd9oD3wqu/5pY=
X-Google-Smtp-Source: AA6agR7h3EZThLf/VM9M9WOpNRYiFFAHk8HXEeINzPW2NCxFoHhlVzUpJZ78ZH2d/YewBUwLmDFZ9A==
X-Received: by 2002:a05:6a00:1409:b0:52e:d946:b2f5 with SMTP id l9-20020a056a00140900b0052ed946b2f5mr25972018pfu.20.1660753491258;
        Wed, 17 Aug 2022 09:24:51 -0700 (PDT)
Received: from localhost (c-73-164-155-12.hsd1.wa.comcast.net. [73.164.155.12])
        by smtp.gmail.com with ESMTPSA id u11-20020a17090a400b00b001f8c532b93dsm1777930pjc.15.2022.08.17.09.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 09:24:50 -0700 (PDT)
Date:   Tue, 16 Aug 2022 09:58:21 +0000
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
Message-ID: <YvtqPQhs0uQHuwID@bullseye>
References: <cover.1660362668.git.bobby.eshleman@bytedance.com>
 <3cb082f1c88f3f2ef1fc250dbc0745fb79c745c7.1660362668.git.bobby.eshleman@bytedance.com>
 <YvsBqpEoq1tbgj8A@bullseye>
 <9a411184-9b14-ee72-dcbf-05271139db0a@sberdevices.ru>
 <aea0855e-a417-d475-71ab-7fdea1cc4d31@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aea0855e-a417-d475-71ab-7fdea1cc4d31@sberdevices.ru>
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DATE_IN_PAST_24_48,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 05:42:08AM +0000, Arseniy Krasnov wrote:
> On 17.08.2022 08:01, Arseniy Krasnov wrote:
> > On 16.08.2022 05:32, Bobby Eshleman wrote:
> >> CC'ing virtio-dev@lists.oasis-open.org
> >>
> >> On Mon, Aug 15, 2022 at 10:56:08AM -0700, Bobby Eshleman wrote:
> >>> This patch supports dgram in virtio and on the vhost side.
> > Hello,
> > 
> > sorry, i don't understand, how this maintains message boundaries? Or it
> > is unnecessary for SOCK_DGRAM?
> > 
> > Thanks
> >>>
> >>> Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> >>> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> >>> ---
> >>>  drivers/vhost/vsock.c                   |   2 +-
> >>>  include/net/af_vsock.h                  |   2 +
> >>>  include/uapi/linux/virtio_vsock.h       |   1 +
> >>>  net/vmw_vsock/af_vsock.c                |  26 +++-
> >>>  net/vmw_vsock/virtio_transport.c        |   2 +-
> >>>  net/vmw_vsock/virtio_transport_common.c | 173 ++++++++++++++++++++++--
> >>>  6 files changed, 186 insertions(+), 20 deletions(-)
> >>>
> >>> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> >>> index a5d1bdb786fe..3dc72a5647ca 100644
> >>> --- a/drivers/vhost/vsock.c
> >>> +++ b/drivers/vhost/vsock.c
> >>> @@ -925,7 +925,7 @@ static int __init vhost_vsock_init(void)
> >>>  	int ret;
> >>>  
> >>>  	ret = vsock_core_register(&vhost_transport.transport,
> >>> -				  VSOCK_TRANSPORT_F_H2G);
> >>> +				  VSOCK_TRANSPORT_F_H2G | VSOCK_TRANSPORT_F_DGRAM);
> >>>  	if (ret < 0)
> >>>  		return ret;
> >>>  
> >>> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> >>> index 1c53c4c4d88f..37e55c81e4df 100644
> >>> --- a/include/net/af_vsock.h
> >>> +++ b/include/net/af_vsock.h
> >>> @@ -78,6 +78,8 @@ struct vsock_sock {
> >>>  s64 vsock_stream_has_data(struct vsock_sock *vsk);
> >>>  s64 vsock_stream_has_space(struct vsock_sock *vsk);
> >>>  struct sock *vsock_create_connected(struct sock *parent);
> >>> +int vsock_bind_stream(struct vsock_sock *vsk,
> >>> +		      struct sockaddr_vm *addr);
> >>>  
> >>>  /**** TRANSPORT ****/
> >>>  
> >>> diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
> >>> index 857df3a3a70d..0975b9c88292 100644
> >>> --- a/include/uapi/linux/virtio_vsock.h
> >>> +++ b/include/uapi/linux/virtio_vsock.h
> >>> @@ -70,6 +70,7 @@ struct virtio_vsock_hdr {
> >>>  enum virtio_vsock_type {
> >>>  	VIRTIO_VSOCK_TYPE_STREAM = 1,
> >>>  	VIRTIO_VSOCK_TYPE_SEQPACKET = 2,
> >>> +	VIRTIO_VSOCK_TYPE_DGRAM = 3,
> >>>  };
> >>>  
> >>>  enum virtio_vsock_op {
> >>> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> >>> index 1893f8aafa48..87e4ae1866d3 100644
> >>> --- a/net/vmw_vsock/af_vsock.c
> >>> +++ b/net/vmw_vsock/af_vsock.c
> >>> @@ -675,6 +675,19 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
> >>>  	return 0;
> >>>  }
> >>>  
> >>> +int vsock_bind_stream(struct vsock_sock *vsk,
> >>> +		      struct sockaddr_vm *addr)
> >>> +{
> >>> +	int retval;
> >>> +
> >>> +	spin_lock_bh(&vsock_table_lock);
> >>> +	retval = __vsock_bind_connectible(vsk, addr);
> >>> +	spin_unlock_bh(&vsock_table_lock);
> >>> +
> >>> +	return retval;
> >>> +}
> >>> +EXPORT_SYMBOL(vsock_bind_stream);
> >>> +
> >>>  static int __vsock_bind_dgram(struct vsock_sock *vsk,
> >>>  			      struct sockaddr_vm *addr)
> >>>  {
> >>> @@ -2363,11 +2376,16 @@ int vsock_core_register(const struct vsock_transport *t, int features)
> >>>  	}
> >>>  
> >>>  	if (features & VSOCK_TRANSPORT_F_DGRAM) {
> >>> -		if (t_dgram) {
> >>> -			err = -EBUSY;
> >>> -			goto err_busy;
> >>> +		/* TODO: always chose the G2H variant over others, support nesting later */
> >>> +		if (features & VSOCK_TRANSPORT_F_G2H) {
> >>> +			if (t_dgram)
> >>> +				pr_warn("virtio_vsock: t_dgram already set\n");
> >>> +			t_dgram = t;
> >>> +		}
> >>> +
> >>> +		if (!t_dgram) {
> >>> +			t_dgram = t;
> >>>  		}
> >>> -		t_dgram = t;
> >>>  	}
> >>>  
> >>>  	if (features & VSOCK_TRANSPORT_F_LOCAL) {
> >>> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> >>> index 073314312683..d4526ca462d2 100644
> >>> --- a/net/vmw_vsock/virtio_transport.c
> >>> +++ b/net/vmw_vsock/virtio_transport.c
> >>> @@ -850,7 +850,7 @@ static int __init virtio_vsock_init(void)
> >>>  		return -ENOMEM;
> >>>  
> >>>  	ret = vsock_core_register(&virtio_transport.transport,
> >>> -				  VSOCK_TRANSPORT_F_G2H);
> >>> +				  VSOCK_TRANSPORT_F_G2H | VSOCK_TRANSPORT_F_DGRAM);
> >>>  	if (ret)
> >>>  		goto out_wq;
> >>>  
> >>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> >>> index bdf16fff054f..aedb48728677 100644
> >>> --- a/net/vmw_vsock/virtio_transport_common.c
> >>> +++ b/net/vmw_vsock/virtio_transport_common.c
> >>> @@ -229,7 +229,9 @@ EXPORT_SYMBOL_GPL(virtio_transport_deliver_tap_pkt);
> >>>  
> >>>  static u16 virtio_transport_get_type(struct sock *sk)
> >>>  {
> >>> -	if (sk->sk_type == SOCK_STREAM)
> >>> +	if (sk->sk_type == SOCK_DGRAM)
> >>> +		return VIRTIO_VSOCK_TYPE_DGRAM;
> >>> +	else if (sk->sk_type == SOCK_STREAM)
> >>>  		return VIRTIO_VSOCK_TYPE_STREAM;
> >>>  	else
> >>>  		return VIRTIO_VSOCK_TYPE_SEQPACKET;
> >>> @@ -287,22 +289,29 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
> >>>  	vvs = vsk->trans;
> >>>  
> >>>  	/* we can send less than pkt_len bytes */
> >>> -	if (pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
> >>> -		pkt_len = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
> >>> +	if (pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE) {
> >>> +		if (info->type != VIRTIO_VSOCK_TYPE_DGRAM)
> >>> +			pkt_len = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
> >>> +		else
> >>> +			return 0;
> >>> +	}
> >>>  
> >>> -	/* virtio_transport_get_credit might return less than pkt_len credit */
> >>> -	pkt_len = virtio_transport_get_credit(vvs, pkt_len);
> >>> +	if (info->type != VIRTIO_VSOCK_TYPE_DGRAM) {
> >>> +		/* virtio_transport_get_credit might return less than pkt_len credit */
> >>> +		pkt_len = virtio_transport_get_credit(vvs, pkt_len);
> >>>  
> >>> -	/* Do not send zero length OP_RW pkt */
> >>> -	if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
> >>> -		return pkt_len;
> >>> +		/* Do not send zero length OP_RW pkt */
> >>> +		if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
> >>> +			return pkt_len;
> >>> +	}
> >>>  
> >>>  	skb = virtio_transport_alloc_skb(info, pkt_len,
> >>>  					 src_cid, src_port,
> >>>  					 dst_cid, dst_port,
> >>>  					 &err);
> >>>  	if (!skb) {
> >>> -		virtio_transport_put_credit(vvs, pkt_len);
> >>> +		if (info->type != VIRTIO_VSOCK_TYPE_DGRAM)
> >>> +			virtio_transport_put_credit(vvs, pkt_len);
> >>>  		return err;
> >>>  	}
> >>>  
> >>> @@ -586,6 +595,61 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
> >>>  }
> >>>  EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
> >>>  
> >>> +static ssize_t
> >>> +virtio_transport_dgram_do_dequeue(struct vsock_sock *vsk,
> >>> +				  struct msghdr *msg, size_t len)
> >>> +{
> >>> +	struct virtio_vsock_sock *vvs = vsk->trans;
> >>> +	struct sk_buff *skb;
> >>> +	size_t total = 0;
> >>> +	u32 free_space;
> >>> +	int err = -EFAULT;
> >>> +
> >>> +	spin_lock_bh(&vvs->rx_lock);
> >>> +	if (total < len && !skb_queue_empty_lockless(&vvs->rx_queue)) {
> >>> +		skb = __skb_dequeue(&vvs->rx_queue);
> >>> +
> >>> +		total = len;
> >>> +		if (total > skb->len - vsock_metadata(skb)->off)
> >>> +			total = skb->len - vsock_metadata(skb)->off;
> >>> +		else if (total < skb->len - vsock_metadata(skb)->off)
> >>> +			msg->msg_flags |= MSG_TRUNC;
> >>> +
> >>> +		/* sk_lock is held by caller so no one else can dequeue.
> >>> +		 * Unlock rx_lock since memcpy_to_msg() may sleep.
> >>> +		 */
> >>> +		spin_unlock_bh(&vvs->rx_lock);
> >>> +
> >>> +		err = memcpy_to_msg(msg, skb->data + vsock_metadata(skb)->off, total);
> >>> +		if (err)
> >>> +			return err;
> >>> +
> >>> +		spin_lock_bh(&vvs->rx_lock);
> >>> +
> >>> +		virtio_transport_dec_rx_pkt(vvs, skb);
> >>> +		consume_skb(skb);
> >>> +	}
> >>> +
> >>> +	free_space = vvs->buf_alloc - (vvs->fwd_cnt - vvs->last_fwd_cnt);
> >>> +
> >>> +	spin_unlock_bh(&vvs->rx_lock);
> >>> +
> >>> +	if (total > 0 && msg->msg_name) {
> >>> +		/* Provide the address of the sender. */
> >>> +		DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
> >>> +
> >>> +		vsock_addr_init(vm_addr, le64_to_cpu(vsock_hdr(skb)->src_cid),
> >>> +				le32_to_cpu(vsock_hdr(skb)->src_port));
> >>> +		msg->msg_namelen = sizeof(*vm_addr);
> >>> +	}
> >>> +	return total;
> >>> +}
> >>> +
> >>> +static s64 virtio_transport_dgram_has_data(struct vsock_sock *vsk)
> >>> +{
> >>> +	return virtio_transport_stream_has_data(vsk);
> >>> +}
> >>> +
> >>>  int
> >>>  virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
> >>>  				   struct msghdr *msg,
> >>> @@ -611,7 +675,66 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
> >>>  			       struct msghdr *msg,
> >>>  			       size_t len, int flags)
> >>>  {
> >>> -	return -EOPNOTSUPP;
> >>> +	struct sock *sk;
> >>> +	size_t err = 0;
> >>> +	long timeout;
> >>> +
> >>> +	DEFINE_WAIT(wait);
> >>> +
> >>> +	sk = &vsk->sk;
> >>> +	err = 0;
> >>> +
> >>> +	if (flags & MSG_OOB || flags & MSG_ERRQUEUE || flags & MSG_PEEK)
> >>> +		return -EOPNOTSUPP;
> >>> +
> >>> +	lock_sock(sk);
> >>> +
> >>> +	if (!len)
> >>> +		goto out;
> >>> +
> >>> +	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
> >>> +
> >>> +	while (1) {
> >>> +		s64 ready;
> >>> +
> >>> +		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
> >>> +		ready = virtio_transport_dgram_has_data(vsk);
> >>> +
> >>> +		if (ready == 0) {
> >>> +			if (timeout == 0) {
> >>> +				err = -EAGAIN;
> >>> +				finish_wait(sk_sleep(sk), &wait);
> >>> +				break;
> >>> +			}
> >>> +
> >>> +			release_sock(sk);
> >>> +			timeout = schedule_timeout(timeout);
> >>> +			lock_sock(sk);
> >>> +
> >>> +			if (signal_pending(current)) {
> >>> +				err = sock_intr_errno(timeout);
> >>> +				finish_wait(sk_sleep(sk), &wait);
> >>> +				break;
> >>> +			} else if (timeout == 0) {
> >>> +				err = -EAGAIN;
> >>> +				finish_wait(sk_sleep(sk), &wait);
> >>> +				break;
> >>> +			}
> >>> +		} else {
> >>> +			finish_wait(sk_sleep(sk), &wait);
> >>> +
> >>> +			if (ready < 0) {
> >>> +				err = -ENOMEM;
> >>> +				goto out;
> >>> +			}
> >>> +
> >>> +			err = virtio_transport_dgram_do_dequeue(vsk, msg, len);
> >>> +			break;
> >>> +		}
> >>> +	}
> >>> +out:
> >>> +	release_sock(sk);
> >>> +	return err;
> >>>  }
> >>>  EXPORT_SYMBOL_GPL(virtio_transport_dgram_dequeue);
> ^^^
> May be, this generic data waiting logic should be in af_vsock.c, as for stream/seqpacket?
> In this way, another transport which supports SOCK_DGRAM could reuse it.

I think that is a great idea. I'll test that change for v2.

Thanks.

> >>>  
> >>> @@ -819,13 +942,13 @@ EXPORT_SYMBOL_GPL(virtio_transport_stream_allow);
> >>>  int virtio_transport_dgram_bind(struct vsock_sock *vsk,
> >>>  				struct sockaddr_vm *addr)
> >>>  {
> >>> -	return -EOPNOTSUPP;
> >>> +	return vsock_bind_stream(vsk, addr);
> >>>  }
> >>>  EXPORT_SYMBOL_GPL(virtio_transport_dgram_bind);
> >>>  
> >>>  bool virtio_transport_dgram_allow(u32 cid, u32 port)
> >>>  {
> >>> -	return false;
> >>> +	return true;
> >>>  }
> >>>  EXPORT_SYMBOL_GPL(virtio_transport_dgram_allow);
> >>>  
> >>> @@ -861,7 +984,16 @@ virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
> >>>  			       struct msghdr *msg,
> >>>  			       size_t dgram_len)
> >>>  {
> >>> -	return -EOPNOTSUPP;
> >>> +	struct virtio_vsock_pkt_info info = {
> >>> +		.op = VIRTIO_VSOCK_OP_RW,
> >>> +		.msg = msg,
> >>> +		.pkt_len = dgram_len,
> >>> +		.vsk = vsk,
> >>> +		.remote_cid = remote_addr->svm_cid,
> >>> +		.remote_port = remote_addr->svm_port,
> >>> +	};
> >>> +
> >>> +	return virtio_transport_send_pkt_info(vsk, &info);
> >>>  }
> >>>  EXPORT_SYMBOL_GPL(virtio_transport_dgram_enqueue);
> >>>  
> >>> @@ -1165,6 +1297,12 @@ virtio_transport_recv_connected(struct sock *sk,
> >>>  	struct virtio_vsock_hdr *hdr = vsock_hdr(skb);
> >>>  	int err = 0;
> >>>  
> >>> +	if (le16_to_cpu(vsock_hdr(skb)->type) == VIRTIO_VSOCK_TYPE_DGRAM) {
> >>> +		virtio_transport_recv_enqueue(vsk, skb);
> >>> +		sk->sk_data_ready(sk);
> >>> +		return err;
> >>> +	}
> >>> +
> >>>  	switch (le16_to_cpu(hdr->op)) {
> >>>  	case VIRTIO_VSOCK_OP_RW:
> >>>  		virtio_transport_recv_enqueue(vsk, skb);
> >>> @@ -1320,7 +1458,8 @@ virtio_transport_recv_listen(struct sock *sk, struct sk_buff *skb,
> >>>  static bool virtio_transport_valid_type(u16 type)
> >>>  {
> >>>  	return (type == VIRTIO_VSOCK_TYPE_STREAM) ||
> >>> -	       (type == VIRTIO_VSOCK_TYPE_SEQPACKET);
> >>> +	       (type == VIRTIO_VSOCK_TYPE_SEQPACKET) ||
> >>> +	       (type == VIRTIO_VSOCK_TYPE_DGRAM);
> >>>  }
> >>>  
> >>>  /* We are under the virtio-vsock's vsock->rx_lock or vhost-vsock's vq->mutex
> >>> @@ -1384,6 +1523,11 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
> >>>  		goto free_pkt;
> >>>  	}
> >>>  
> >>> +	if (sk->sk_type == SOCK_DGRAM) {
> >>> +		virtio_transport_recv_connected(sk, skb);
> >>> +		goto out;
> >>> +	}
> >>> +
> >>>  	space_available = virtio_transport_space_update(sk, skb);
> >>>  
> >>>  	/* Update CID in case it has changed after a transport reset event */
> >>> @@ -1415,6 +1559,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
> >>>  		break;
> >>>  	}
> >>>  
> >>> +out:
> >>>  	release_sock(sk);
> >>>  
> >>>  	/* Release refcnt obtained when we fetched this socket out of the
> >>> -- 
> >>> 2.35.1
> >>>
> >>
> >> ---------------------------------------------------------------------
> >> To unsubscribe, e-mail: virtio-dev-unsubscribe@lists.oasis-open.org
> >> For additional commands, e-mail: virtio-dev-help@lists.oasis-open.org
> >>
> > 
> 
