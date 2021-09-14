Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC8040A6F4
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 08:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240363AbhING57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 02:57:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58003 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240282AbhING56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 02:57:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631602600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=w9HAUn7Gw8BcPbcDbjZlMFLUvG8XZXo3SlV/unyiT0Q=;
        b=QHmzSqTvB5sqaB2pyOBbj/56LBOVUYQxnmlQPgJGzVwBxbi3meF7EKXmDZaNRCRIgJEfX8
        83MNq7U7Lg0un6F+yf9DCzBt8x4taywHadBfodJ3QzdJLkhWpE4zrFFCVAZPRDSMu1RGVq
        TdFfQlQzW6DiFYkbZrnxUt1JQPp6Fnc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-127-vUev_ZWbOhCyLDHb_EkDwQ-1; Tue, 14 Sep 2021 02:56:38 -0400
X-MC-Unique: vUev_ZWbOhCyLDHb_EkDwQ-1
Received: by mail-wm1-f71.google.com with SMTP id m22-20020a7bca56000000b002e7508f3faeso6027275wml.2
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 23:56:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=w9HAUn7Gw8BcPbcDbjZlMFLUvG8XZXo3SlV/unyiT0Q=;
        b=EbpGR/HskHziWhFm7LwIm39CPRJMMR+1LATxq0qb52K0M5T7SfNColnOOh0iPItfom
         B5YnTx/ET9PlamOxGd4kiTIcaC8cqhLOC0M3EG6UZGTifhoIrC2lNwDv73mjlaPkPpWV
         VTNnhp7N6qmzRsruF0sBYJmfKWuTC8tH7UpuNbDOd6p/4HI6Kku40WhMzUD/NZK8Cef/
         XT6TBph5WDtRsP0EejAODs1nKuafAtc9XtgEg5FIL2s40ONQmJ7gQZs7rsErmGAoQplO
         pAgqeeF+5OqilAjfYhuj1EPL1lbsrjsPvxWUsIs7dKb35MpNEe2SyMHf0hvYubHJ49ew
         XQEw==
X-Gm-Message-State: AOAM532Xy+j6jZDg6SIySgrScbINNlTMh63v+CRDXTq5xBWt9wes6kU4
        nw3Gg8YKxnNOA+SIJUnDTpLl1+n5UX+dAzXHrT9SSSJjvMMQiK339We8NZ4eHFYhAwiOdwzHhY1
        LOFUUQzeZRXwmVDdS
X-Received: by 2002:a5d:4883:: with SMTP id g3mr3708782wrq.151.1631602597297;
        Mon, 13 Sep 2021 23:56:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzxra/7caUSuOiDmHzoOVESUXoNr/ohzEWcN6k4NVBDHx0iLL+RICtObcZAU5rIvKvvK5tnBA==
X-Received: by 2002:a5d:4883:: with SMTP id g3mr3708738wrq.151.1631602596860;
        Mon, 13 Sep 2021 23:56:36 -0700 (PDT)
Received: from redhat.com ([2.55.151.134])
        by smtp.gmail.com with ESMTPSA id r26sm198462wmh.27.2021.09.13.23.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 23:56:36 -0700 (PDT)
Date:   Tue, 14 Sep 2021 02:56:31 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jiang Wang <jiang.wang@bytedance.com>
Cc:     jiangleetcode@gmail.com, virtualization@lists.linux-foundation.org,
        stefanha@redhat.com, sgarzare@redhat.com,
        arseny.krasnov@kaspersky.com, jhansen@vmware.com,
        cong.wang@bytedance.com, duanxiongchun@bytedance.com,
        xieyongji@bytedance.com, chaiwen.cc@bytedance.com,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 2/5] virtio/vsock: add support for virtio datagram
Message-ID: <20210914025307-mutt-send-email-mst@kernel.org>
References: <20210914055440.3121004-1-jiang.wang@bytedance.com>
 <20210914055440.3121004-3-jiang.wang@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210914055440.3121004-3-jiang.wang@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 05:54:35AM +0000, Jiang Wang wrote:
> This patch add support for virtio dgram for the driver.
> Implemented related functions for tx and rx, enqueue
> and dequeue. Send packets synchronously to give sender
> indication when the virtqueue is full.


Hmm I don't see this in code.
virtio_transport_do_send_dgram_pkt just does add buf and returns.

In any case, how exactly is fairness handled?
what prevents one socket from monopolizing the device?

> Refactored virtio_transport_send_pkt_work() a little bit but
> no functions changes for it.

split the refactoring to a separate patch then pls.

> 
> Support for the host/device side is in another
> patch.
> 
> Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> ---
>  include/net/af_vsock.h                        |   1 +
>  .../events/vsock_virtio_transport_common.h    |   2 +
>  include/uapi/linux/virtio_vsock.h             |   1 +
>  net/vmw_vsock/af_vsock.c                      |  12 +
>  net/vmw_vsock/virtio_transport.c              | 344 +++++++++++++++---
>  net/vmw_vsock/virtio_transport_common.c       | 181 ++++++++-
>  6 files changed, 467 insertions(+), 74 deletions(-)
> 
> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> index ab207677e0a8..58c46c694670 100644
> --- a/include/net/af_vsock.h
> +++ b/include/net/af_vsock.h
> @@ -208,6 +208,7 @@ void vsock_remove_sock(struct vsock_sock *vsk);
>  void vsock_for_each_connected_socket(void (*fn)(struct sock *sk));
>  int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk);
>  bool vsock_find_cid(unsigned int cid);
> +int vsock_bind_stream(struct vsock_sock *vsk, struct sockaddr_vm *addr);
>  
>  /**** TAP ****/
>  
> diff --git a/include/trace/events/vsock_virtio_transport_common.h b/include/trace/events/vsock_virtio_transport_common.h
> index d0b3f0ea9ba1..1d8647a6b476 100644
> --- a/include/trace/events/vsock_virtio_transport_common.h
> +++ b/include/trace/events/vsock_virtio_transport_common.h
> @@ -10,10 +10,12 @@
>  
>  TRACE_DEFINE_ENUM(VIRTIO_VSOCK_TYPE_STREAM);
>  TRACE_DEFINE_ENUM(VIRTIO_VSOCK_TYPE_SEQPACKET);
> +TRACE_DEFINE_ENUM(VIRTIO_VSOCK_TYPE_DGRAM);
>  
>  #define show_type(val) \
>  	__print_symbolic(val, \
>  			 { VIRTIO_VSOCK_TYPE_STREAM, "STREAM" }, \
> +			 { VIRTIO_VSOCK_TYPE_DGRAM, "DGRAM" }, \
>  			 { VIRTIO_VSOCK_TYPE_SEQPACKET, "SEQPACKET" })
>  
>  TRACE_DEFINE_ENUM(VIRTIO_VSOCK_OP_INVALID);
> diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
> index cff54ba9b924..3e93b75f2707 100644
> --- a/include/uapi/linux/virtio_vsock.h
> +++ b/include/uapi/linux/virtio_vsock.h
> @@ -71,6 +71,7 @@ struct virtio_vsock_hdr {
>  enum virtio_vsock_type {
>  	VIRTIO_VSOCK_TYPE_STREAM = 1,
>  	VIRTIO_VSOCK_TYPE_SEQPACKET = 2,
> +	VIRTIO_VSOCK_TYPE_DGRAM = 3,
>  };
>  
>  enum virtio_vsock_op {
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index 3e02cc3b24f8..adf11db32506 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -669,6 +669,18 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
>  	return 0;
>  }
>  
> +int vsock_bind_stream(struct vsock_sock *vsk,
> +		      struct sockaddr_vm *addr)
> +{
> +	int retval;
> +
> +	spin_lock_bh(&vsock_table_lock);
> +	retval = __vsock_bind_connectible(vsk, addr);
> +	spin_unlock_bh(&vsock_table_lock);
> +	return retval;
> +}
> +EXPORT_SYMBOL(vsock_bind_stream);
> +
>  static int __vsock_bind_dgram(struct vsock_sock *vsk,
>  			      struct sockaddr_vm *addr)
>  {
> diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
> index bb89f538f5f3..8d5bfcd79555 100644
> --- a/net/vmw_vsock/virtio_transport.c
> +++ b/net/vmw_vsock/virtio_transport.c
> @@ -20,21 +20,29 @@
>  #include <net/sock.h>
>  #include <linux/mutex.h>
>  #include <net/af_vsock.h>
> +#include<linux/kobject.h>
> +#include<linux/sysfs.h>
> +#include <linux/refcount.h>
>  
>  static struct workqueue_struct *virtio_vsock_workqueue;
>  static struct virtio_vsock __rcu *the_virtio_vsock;
> +static struct virtio_vsock *the_virtio_vsock_dgram;
>  static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
>  
>  struct virtio_vsock {
>  	struct virtio_device *vdev;
>  	struct virtqueue **vqs;
>  	bool has_dgram;
> +	refcount_t active;
>  
>  	/* Virtqueue processing is deferred to a workqueue */
>  	struct work_struct tx_work;
>  	struct work_struct rx_work;
>  	struct work_struct event_work;
>  
> +	struct work_struct dgram_tx_work;
> +	struct work_struct dgram_rx_work;
> +
>  	/* The following fields are protected by tx_lock.  vqs[VSOCK_VQ_TX]
>  	 * must be accessed with tx_lock held.
>  	 */
> @@ -55,6 +63,22 @@ struct virtio_vsock {
>  	int rx_buf_nr;
>  	int rx_buf_max_nr;
>  
> +	/* The following fields are protected by dgram_tx_lock.  vqs[VSOCK_VQ_DGRAM_TX]
> +	 * must be accessed with dgram_tx_lock held.
> +	 */
> +	struct mutex dgram_tx_lock;
> +	bool dgram_tx_run;
> +
> +	atomic_t dgram_queued_replies;
> +
> +	/* The following fields are protected by dgram_rx_lock.  vqs[VSOCK_VQ_DGRAM_RX]
> +	 * must be accessed with dgram_rx_lock held.
> +	 */
> +	struct mutex dgram_rx_lock;
> +	bool dgram_rx_run;
> +	int dgram_rx_buf_nr;
> +	int dgram_rx_buf_max_nr;
> +
>  	/* The following fields are protected by event_lock.
>  	 * vqs[VSOCK_VQ_EVENT] must be accessed with event_lock held.
>  	 */
> @@ -84,21 +108,12 @@ static u32 virtio_transport_get_local_cid(void)
>  	return ret;
>  }
>  
> -static void
> -virtio_transport_send_pkt_work(struct work_struct *work)
> +static void virtio_transport_do_send_pkt(struct virtio_vsock *vsock,
> +					 struct virtqueue *vq,  spinlock_t *lock,
> +					 struct list_head *send_pkt_list,
> +					 bool *restart_rx)
>  {
> -	struct virtio_vsock *vsock =
> -		container_of(work, struct virtio_vsock, send_pkt_work);
> -	struct virtqueue *vq;
>  	bool added = false;
> -	bool restart_rx = false;
> -
> -	mutex_lock(&vsock->tx_lock);
> -
> -	if (!vsock->tx_run)
> -		goto out;
> -
> -	vq = vsock->vqs[VSOCK_VQ_TX];
>  
>  	for (;;) {
>  		struct virtio_vsock_pkt *pkt;
> @@ -106,16 +121,16 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>  		int ret, in_sg = 0, out_sg = 0;
>  		bool reply;
>  
> -		spin_lock_bh(&vsock->send_pkt_list_lock);
> -		if (list_empty(&vsock->send_pkt_list)) {
> -			spin_unlock_bh(&vsock->send_pkt_list_lock);
> +		spin_lock_bh(lock);
> +		if (list_empty(send_pkt_list)) {
> +			spin_unlock_bh(lock);
>  			break;
>  		}
>  
> -		pkt = list_first_entry(&vsock->send_pkt_list,
> +		pkt = list_first_entry(send_pkt_list,
>  				       struct virtio_vsock_pkt, list);
>  		list_del_init(&pkt->list);
> -		spin_unlock_bh(&vsock->send_pkt_list_lock);
> +		spin_unlock_bh(lock);
>  
>  		virtio_transport_deliver_tap_pkt(pkt);
>  
> @@ -133,9 +148,9 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>  		 * the vq
>  		 */
>  		if (ret < 0) {
> -			spin_lock_bh(&vsock->send_pkt_list_lock);
> -			list_add(&pkt->list, &vsock->send_pkt_list);
> -			spin_unlock_bh(&vsock->send_pkt_list_lock);
> +			spin_lock_bh(lock);
> +			list_add(&pkt->list, send_pkt_list);
> +			spin_unlock_bh(lock);
>  			break;
>  		}
>  
> @@ -147,7 +162,7 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>  
>  			/* Do we now have resources to resume rx processing? */
>  			if (val + 1 == virtqueue_get_vring_size(rx_vq))
> -				restart_rx = true;
> +				*restart_rx = true;
>  		}
>  
>  		added = true;
> @@ -155,7 +170,55 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>  
>  	if (added)
>  		virtqueue_kick(vq);
> +}
> +
> +static int virtio_transport_do_send_dgram_pkt(struct virtio_vsock *vsock,
> +					      struct virtqueue *vq,
> +					      struct virtio_vsock_pkt *pkt)
> +{
> +	struct scatterlist hdr, buf, *sgs[2];
> +	int ret, in_sg = 0, out_sg = 0;
> +
> +	virtio_transport_deliver_tap_pkt(pkt);
> +
> +	sg_init_one(&hdr, &pkt->hdr, sizeof(pkt->hdr));
> +	sgs[out_sg++] = &hdr;
> +	if (pkt->buf) {
> +		sg_init_one(&buf, pkt->buf, pkt->len);
> +		sgs[out_sg++] = &buf;
> +	}
> +
> +	ret = virtqueue_add_sgs(vq, sgs, out_sg, in_sg, pkt, GFP_KERNEL);
> +	/* Usually this means that there is no more space available in
> +	 * the vq
> +	 */
> +	if (ret < 0) {
> +		virtio_transport_free_pkt(pkt);
> +		return -ENOMEM;
> +	}
> +
> +	virtqueue_kick(vq);
> +
> +	return pkt->len;
> +}
> +
> +static void
> +virtio_transport_send_pkt_work(struct work_struct *work)
> +{
> +	struct virtio_vsock *vsock =
> +		container_of(work, struct virtio_vsock, send_pkt_work);
> +	struct virtqueue *vq;
> +	bool restart_rx = false;
>  
> +	mutex_lock(&vsock->tx_lock);
> +
> +	if (!vsock->tx_run)
> +		goto out;
> +
> +	vq = vsock->vqs[VSOCK_VQ_TX];
> +
> +	virtio_transport_do_send_pkt(vsock, vq, &vsock->send_pkt_list_lock,
> +				     &vsock->send_pkt_list, &restart_rx);
>  out:
>  	mutex_unlock(&vsock->tx_lock);
>  
> @@ -163,12 +226,65 @@ virtio_transport_send_pkt_work(struct work_struct *work)
>  		queue_work(virtio_vsock_workqueue, &vsock->rx_work);
>  }
>  
> +static int
> +virtio_transport_send_dgram_pkt(struct virtio_vsock_pkt *pkt)
> +{
> +	struct virtio_vsock *vsock;
> +	int len = pkt->len;
> +	struct virtqueue *vq;
> +
> +	vsock = the_virtio_vsock_dgram;
> +
> +	if (!vsock) {
> +		virtio_transport_free_pkt(pkt);
> +		return -ENODEV;
> +	}
> +
> +	if (!vsock->dgram_tx_run) {
> +		virtio_transport_free_pkt(pkt);
> +		return -ENODEV;
> +	}
> +
> +	if (!refcount_inc_not_zero(&vsock->active)) {
> +		virtio_transport_free_pkt(pkt);
> +		return -ENODEV;
> +	}
> +
> +	if (le64_to_cpu(pkt->hdr.dst_cid) == vsock->guest_cid) {
> +		virtio_transport_free_pkt(pkt);
> +		len = -ENODEV;
> +		goto out_ref;
> +	}
> +
> +	/* send the pkt */
> +	mutex_lock(&vsock->dgram_tx_lock);
> +
> +	if (!vsock->dgram_tx_run)
> +		goto out_mutex;
> +
> +	vq = vsock->vqs[VSOCK_VQ_DGRAM_TX];
> +
> +	len = virtio_transport_do_send_dgram_pkt(vsock, vq, pkt);
> +
> +out_mutex:
> +	mutex_unlock(&vsock->dgram_tx_lock);
> +
> +out_ref:
> +	if (!refcount_dec_not_one(&vsock->active))
> +		return -EFAULT;
> +
> +	return len;
> +}
> +
>  static int
>  virtio_transport_send_pkt(struct virtio_vsock_pkt *pkt)
>  {
>  	struct virtio_vsock *vsock;
>  	int len = pkt->len;
>  
> +	if (pkt->hdr.type == VIRTIO_VSOCK_TYPE_DGRAM)
> +		return virtio_transport_send_dgram_pkt(pkt);
> +
>  	rcu_read_lock();
>  	vsock = rcu_dereference(the_virtio_vsock);
>  	if (!vsock) {
> @@ -244,7 +360,7 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
>  	return ret;
>  }
>  
> -static void virtio_vsock_rx_fill(struct virtio_vsock *vsock)
> +static void virtio_vsock_rx_fill(struct virtio_vsock *vsock, bool is_dgram)
>  {
>  	int buf_len = VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE;
>  	struct virtio_vsock_pkt *pkt;
> @@ -252,7 +368,10 @@ static void virtio_vsock_rx_fill(struct virtio_vsock *vsock)
>  	struct virtqueue *vq;
>  	int ret;
>  
> -	vq = vsock->vqs[VSOCK_VQ_RX];
> +	if (is_dgram)
> +		vq = vsock->vqs[VSOCK_VQ_DGRAM_RX];
> +	else
> +		vq = vsock->vqs[VSOCK_VQ_RX];
>  
>  	do {
>  		pkt = kzalloc(sizeof(*pkt), GFP_KERNEL);
> @@ -278,26 +397,26 @@ static void virtio_vsock_rx_fill(struct virtio_vsock *vsock)
>  			virtio_transport_free_pkt(pkt);
>  			break;
>  		}
> -		vsock->rx_buf_nr++;
> +		if (is_dgram)
> +			vsock->dgram_rx_buf_nr++;
> +		else
> +			vsock->rx_buf_nr++;
>  	} while (vq->num_free);
> -	if (vsock->rx_buf_nr > vsock->rx_buf_max_nr)
> -		vsock->rx_buf_max_nr = vsock->rx_buf_nr;
> +	if (is_dgram) {
> +		if (vsock->dgram_rx_buf_nr > vsock->dgram_rx_buf_max_nr)
> +			vsock->dgram_rx_buf_max_nr = vsock->dgram_rx_buf_nr;
> +	} else {
> +		if (vsock->rx_buf_nr > vsock->rx_buf_max_nr)
> +			vsock->rx_buf_max_nr = vsock->rx_buf_nr;
> +	}
> +
>  	virtqueue_kick(vq);
>  }
>  
> -static void virtio_transport_tx_work(struct work_struct *work)
> +static bool virtio_transport_free_pkt_batch(struct virtqueue *vq)
>  {
> -	struct virtio_vsock *vsock =
> -		container_of(work, struct virtio_vsock, tx_work);
> -	struct virtqueue *vq;
>  	bool added = false;
>  
> -	vq = vsock->vqs[VSOCK_VQ_TX];
> -	mutex_lock(&vsock->tx_lock);
> -
> -	if (!vsock->tx_run)
> -		goto out;
> -
>  	do {
>  		struct virtio_vsock_pkt *pkt;
>  		unsigned int len;
> @@ -309,13 +428,43 @@ static void virtio_transport_tx_work(struct work_struct *work)
>  		}
>  	} while (!virtqueue_enable_cb(vq));
>  
> -out:
> +	return added;
> +}
> +
> +static void virtio_transport_tx_work(struct work_struct *work)
> +{
> +	struct virtio_vsock *vsock =
> +		container_of(work, struct virtio_vsock, tx_work);
> +	struct virtqueue *vq;
> +	bool added = false;
> +
> +	vq = vsock->vqs[VSOCK_VQ_TX];
> +	mutex_lock(&vsock->tx_lock);
> +
> +	if (vsock->tx_run)
> +		added = virtio_transport_free_pkt_batch(vq);
> +
>  	mutex_unlock(&vsock->tx_lock);
>  
>  	if (added)
>  		queue_work(virtio_vsock_workqueue, &vsock->send_pkt_work);
>  }
>  
> +static void virtio_transport_dgram_tx_work(struct work_struct *work)
> +{
> +	struct virtio_vsock *vsock =
> +		container_of(work, struct virtio_vsock, dgram_tx_work);
> +	struct virtqueue *vq;
> +
> +	vq = vsock->vqs[VSOCK_VQ_DGRAM_TX];
> +	mutex_lock(&vsock->dgram_tx_lock);
> +
> +	if (vsock->dgram_tx_run)
> +		virtio_transport_free_pkt_batch(vq);
> +
> +	mutex_unlock(&vsock->dgram_tx_lock);
> +}
> +
>  /* Is there space left for replies to rx packets? */
>  static bool virtio_transport_more_replies(struct virtio_vsock *vsock)
>  {
> @@ -453,6 +602,11 @@ static void virtio_vsock_tx_done(struct virtqueue *vq)
>  
>  static void virtio_vsock_dgram_tx_done(struct virtqueue *vq)
>  {
> +	struct virtio_vsock *vsock = vq->vdev->priv;
> +
> +	if (!vsock)
> +		return;
> +	queue_work(virtio_vsock_workqueue, &vsock->dgram_tx_work);
>  }
>  
>  static void virtio_vsock_rx_done(struct virtqueue *vq)
> @@ -468,8 +622,12 @@ static bool virtio_transport_seqpacket_allow(u32 remote_cid);
>  
>  static void virtio_vsock_dgram_rx_done(struct virtqueue *vq)
>  {
> -}
> +	struct virtio_vsock *vsock = vq->vdev->priv;
>  
> +	if (!vsock)
> +		return;
> +	queue_work(virtio_vsock_workqueue, &vsock->dgram_rx_work);
> +}
>  static struct virtio_transport virtio_transport = {
>  	.transport = {
>  		.module                   = THIS_MODULE,
> @@ -532,19 +690,9 @@ static bool virtio_transport_seqpacket_allow(u32 remote_cid)
>  	return seqpacket_allow;
>  }
>  
> -static void virtio_transport_rx_work(struct work_struct *work)
> +static void virtio_transport_do_rx_work(struct virtio_vsock *vsock,
> +					struct virtqueue *vq, bool is_dgram)
>  {
> -	struct virtio_vsock *vsock =
> -		container_of(work, struct virtio_vsock, rx_work);
> -	struct virtqueue *vq;
> -
> -	vq = vsock->vqs[VSOCK_VQ_RX];
> -
> -	mutex_lock(&vsock->rx_lock);
> -
> -	if (!vsock->rx_run)
> -		goto out;
> -
>  	do {
>  		virtqueue_disable_cb(vq);
>  		for (;;) {
> @@ -564,7 +712,10 @@ static void virtio_transport_rx_work(struct work_struct *work)
>  				break;
>  			}
>  
> -			vsock->rx_buf_nr--;
> +			if (is_dgram)
> +				vsock->dgram_rx_buf_nr--;
> +			else
> +				vsock->rx_buf_nr--;
>  
>  			/* Drop short/long packets */
>  			if (unlikely(len < sizeof(pkt->hdr) ||
> @@ -580,11 +731,45 @@ static void virtio_transport_rx_work(struct work_struct *work)
>  	} while (!virtqueue_enable_cb(vq));
>  
>  out:
> +	return;
> +}
> +
> +static void virtio_transport_rx_work(struct work_struct *work)
> +{
> +	struct virtio_vsock *vsock =
> +		container_of(work, struct virtio_vsock, rx_work);
> +	struct virtqueue *vq;
> +
> +	vq = vsock->vqs[VSOCK_VQ_RX];
> +
> +	mutex_lock(&vsock->rx_lock);
> +
> +	if (vsock->rx_run)
> +		virtio_transport_do_rx_work(vsock, vq, false);
> +
>  	if (vsock->rx_buf_nr < vsock->rx_buf_max_nr / 2)
> -		virtio_vsock_rx_fill(vsock);
> +		virtio_vsock_rx_fill(vsock, false);
>  	mutex_unlock(&vsock->rx_lock);
>  }
>  
> +static void virtio_transport_dgram_rx_work(struct work_struct *work)
> +{
> +	struct virtio_vsock *vsock =
> +		container_of(work, struct virtio_vsock, dgram_rx_work);
> +	struct virtqueue *vq;
> +
> +	vq = vsock->vqs[VSOCK_VQ_DGRAM_RX];
> +
> +	mutex_lock(&vsock->dgram_rx_lock);
> +
> +	if (vsock->dgram_rx_run)
> +		virtio_transport_do_rx_work(vsock, vq, true);
> +
> +	if (vsock->dgram_rx_buf_nr < vsock->dgram_rx_buf_max_nr / 2)
> +		virtio_vsock_rx_fill(vsock, true);
> +	mutex_unlock(&vsock->dgram_rx_lock);
> +}
> +
>  static int virtio_vsock_probe(struct virtio_device *vdev)
>  {
>  	vq_callback_t *callbacks[] = {
> @@ -592,7 +777,7 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>  		virtio_vsock_tx_done,
>  		virtio_vsock_event_done,
>  	};
> -	vq_callback_t *ex_callbacks[] = {
> +	vq_callback_t *dgram_callbacks[] = {
>  		virtio_vsock_rx_done,
>  		virtio_vsock_tx_done,
>  		virtio_vsock_dgram_rx_done,
> @@ -651,7 +836,7 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>  
>  	if (vsock->has_dgram) {
>  		ret = virtio_find_vqs(vsock->vdev, max_vq,
> -				      vsock->vqs, ex_callbacks, ex_names,
> +				      vsock->vqs, dgram_callbacks, ex_names,
>  				      NULL);
>  	} else {
>  		ret = virtio_find_vqs(vsock->vdev, max_vq,
> @@ -668,8 +853,14 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>  	vsock->rx_buf_max_nr = 0;
>  	atomic_set(&vsock->queued_replies, 0);
>  
> +	vsock->dgram_rx_buf_nr = 0;
> +	vsock->dgram_rx_buf_max_nr = 0;
> +	atomic_set(&vsock->dgram_queued_replies, 0);


Seems to be the only use of dgram_queued_replies. why do we bother then?

> +
>  	mutex_init(&vsock->tx_lock);
>  	mutex_init(&vsock->rx_lock);
> +	mutex_init(&vsock->dgram_tx_lock);
> +	mutex_init(&vsock->dgram_rx_lock);
>  	mutex_init(&vsock->event_lock);
>  	spin_lock_init(&vsock->send_pkt_list_lock);
>  	INIT_LIST_HEAD(&vsock->send_pkt_list);
> @@ -677,16 +868,27 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>  	INIT_WORK(&vsock->tx_work, virtio_transport_tx_work);
>  	INIT_WORK(&vsock->event_work, virtio_transport_event_work);
>  	INIT_WORK(&vsock->send_pkt_work, virtio_transport_send_pkt_work);
> +	INIT_WORK(&vsock->dgram_rx_work, virtio_transport_dgram_rx_work);
> +	INIT_WORK(&vsock->dgram_tx_work, virtio_transport_dgram_tx_work);
>  
>  	mutex_lock(&vsock->tx_lock);
>  	vsock->tx_run = true;
>  	mutex_unlock(&vsock->tx_lock);
>  
> +	mutex_lock(&vsock->dgram_tx_lock);
> +	vsock->dgram_tx_run = true;
> +	mutex_unlock(&vsock->dgram_tx_lock);
> +
>  	mutex_lock(&vsock->rx_lock);
> -	virtio_vsock_rx_fill(vsock);
> +	virtio_vsock_rx_fill(vsock, false);
>  	vsock->rx_run = true;
>  	mutex_unlock(&vsock->rx_lock);
>  
> +	mutex_lock(&vsock->dgram_rx_lock);
> +	virtio_vsock_rx_fill(vsock, true);
> +	vsock->dgram_rx_run = true;
> +	mutex_unlock(&vsock->dgram_rx_lock);
> +
>  	mutex_lock(&vsock->event_lock);
>  	virtio_vsock_event_fill(vsock);
>  	vsock->event_run = true;
> @@ -698,6 +900,9 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
>  	vdev->priv = vsock;
>  	rcu_assign_pointer(the_virtio_vsock, vsock);
>  
> +	the_virtio_vsock_dgram = vsock;
> +	refcount_set(&the_virtio_vsock_dgram->active, 1);
> +
>  	mutex_unlock(&the_virtio_vsock_mutex);
>  
>  	return 0;
> @@ -729,14 +934,27 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
>  	vsock->rx_run = false;
>  	mutex_unlock(&vsock->rx_lock);
>  
> +	mutex_lock(&vsock->dgram_rx_lock);
> +	vsock->dgram_rx_run = false;
> +	mutex_unlock(&vsock->dgram_rx_lock);
> +
>  	mutex_lock(&vsock->tx_lock);
>  	vsock->tx_run = false;
>  	mutex_unlock(&vsock->tx_lock);
>  
> +	mutex_lock(&vsock->dgram_tx_lock);
> +	vsock->dgram_tx_run = false;
> +	mutex_unlock(&vsock->dgram_tx_lock);
> +
>  	mutex_lock(&vsock->event_lock);
>  	vsock->event_run = false;
>  	mutex_unlock(&vsock->event_lock);
>  
> +	while (!refcount_dec_if_one(&the_virtio_vsock_dgram->active)) {
> +		if (signal_pending(current))
> +			break;
> +	}
> +
>  	/* Flush all device writes and interrupts, device will not use any
>  	 * more buffers.
>  	 */
> @@ -747,11 +965,21 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
>  		virtio_transport_free_pkt(pkt);
>  	mutex_unlock(&vsock->rx_lock);
>  
> +	mutex_lock(&vsock->dgram_rx_lock);
> +	while ((pkt = virtqueue_detach_unused_buf(vsock->vqs[VSOCK_VQ_DGRAM_RX])))
> +		virtio_transport_free_pkt(pkt);
> +	mutex_unlock(&vsock->dgram_rx_lock);
> +
>  	mutex_lock(&vsock->tx_lock);
>  	while ((pkt = virtqueue_detach_unused_buf(vsock->vqs[VSOCK_VQ_TX])))
>  		virtio_transport_free_pkt(pkt);
>  	mutex_unlock(&vsock->tx_lock);
>  
> +	mutex_lock(&vsock->dgram_tx_lock);
> +	while ((pkt = virtqueue_detach_unused_buf(vsock->vqs[VSOCK_VQ_DGRAM_TX])))
> +		virtio_transport_free_pkt(pkt);
> +	mutex_unlock(&vsock->dgram_tx_lock);
> +
>  	spin_lock_bh(&vsock->send_pkt_list_lock);
>  	while (!list_empty(&vsock->send_pkt_list)) {
>  		pkt = list_first_entry(&vsock->send_pkt_list,
> @@ -769,6 +997,8 @@ static void virtio_vsock_remove(struct virtio_device *vdev)
>  	 */
>  	flush_work(&vsock->rx_work);
>  	flush_work(&vsock->tx_work);
> +	flush_work(&vsock->dgram_rx_work);
> +	flush_work(&vsock->dgram_tx_work);
>  	flush_work(&vsock->event_work);
>  	flush_work(&vsock->send_pkt_work);
>  
> @@ -806,7 +1036,7 @@ static int __init virtio_vsock_init(void)
>  		return -ENOMEM;
>  
>  	ret = vsock_core_register(&virtio_transport.transport,
> -				  VSOCK_TRANSPORT_F_G2H);
> +				  VSOCK_TRANSPORT_F_G2H | VSOCK_TRANSPORT_F_DGRAM);
>  	if (ret)
>  		goto out_wq;
>  
> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> index 081e7ae93cb1..034de35fe7c8 100644
> --- a/net/vmw_vsock/virtio_transport_common.c
> +++ b/net/vmw_vsock/virtio_transport_common.c
> @@ -26,6 +26,8 @@
>  /* Threshold for detecting small packets to copy */
>  #define GOOD_COPY_LEN  128
>  
> +static s64 virtio_transport_dgram_has_data(struct vsock_sock *vsk);
> +
>  static const struct virtio_transport *
>  virtio_transport_get_ops(struct vsock_sock *vsk)
>  {
> @@ -210,21 +212,28 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
>  	vvs = vsk->trans;
>  
>  	/* we can send less than pkt_len bytes */
> -	if (pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE)
> -		pkt_len = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
> +	if (pkt_len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE) {
> +		if (info->type == VIRTIO_VSOCK_TYPE_STREAM)
> +			pkt_len = VIRTIO_VSOCK_MAX_PKT_BUF_SIZE;
> +		else
> +			return 0;
> +	}
>  
> -	/* virtio_transport_get_credit might return less than pkt_len credit */
> -	pkt_len = virtio_transport_get_credit(vvs, pkt_len);
> +	if (info->type == VIRTIO_VSOCK_TYPE_STREAM) {
> +		/* virtio_transport_get_credit might return less than pkt_len credit */
> +		pkt_len = virtio_transport_get_credit(vvs, pkt_len);
>  
> -	/* Do not send zero length OP_RW pkt */
> -	if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
> -		return pkt_len;
> +		/* Do not send zero length OP_RW pkt */
> +		if (pkt_len == 0 && info->op == VIRTIO_VSOCK_OP_RW)
> +			return pkt_len;
> +	}
>  
>  	pkt = virtio_transport_alloc_pkt(info, pkt_len,
>  					 src_cid, src_port,
>  					 dst_cid, dst_port);
>  	if (!pkt) {
> -		virtio_transport_put_credit(vvs, pkt_len);
> +		if (info->type == VIRTIO_VSOCK_TYPE_STREAM)
> +			virtio_transport_put_credit(vvs, pkt_len);
>  		return -ENOMEM;
>  	}
>  
> @@ -474,6 +483,55 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
>  	return dequeued_len;
>  }
>  
> +static ssize_t
> +virtio_transport_dgram_do_dequeue(struct vsock_sock *vsk,
> +				  struct msghdr *msg, size_t len)
> +{
> +	struct virtio_vsock_sock *vvs = vsk->trans;
> +	struct virtio_vsock_pkt *pkt;
> +	size_t total = 0;
> +	int err = -EFAULT;
> +
> +	spin_lock_bh(&vvs->rx_lock);
> +	if (total < len && !list_empty(&vvs->rx_queue)) {
> +		pkt = list_first_entry(&vvs->rx_queue,
> +				       struct virtio_vsock_pkt, list);
> +
> +		total = len;
> +		if (total > pkt->len - pkt->off)
> +			total = pkt->len - pkt->off;
> +		else if (total < pkt->len - pkt->off)
> +			msg->msg_flags |= MSG_TRUNC;
> +
> +		/* sk_lock is held by caller so no one else can dequeue.
> +		 * Unlock rx_lock since memcpy_to_msg() may sleep.
> +		 */
> +		spin_unlock_bh(&vvs->rx_lock);
> +
> +		err = memcpy_to_msg(msg, pkt->buf + pkt->off, total);
> +		if (err)
> +			return err;
> +
> +		spin_lock_bh(&vvs->rx_lock);
> +
> +		virtio_transport_dec_rx_pkt(vvs, pkt);
> +		list_del(&pkt->list);
> +		virtio_transport_free_pkt(pkt);
> +	}
> +
> +	spin_unlock_bh(&vvs->rx_lock);
> +
> +	if (total > 0 && msg->msg_name) {
> +		/* Provide the address of the sender. */
> +		DECLARE_SOCKADDR(struct sockaddr_vm *, vm_addr, msg->msg_name);
> +
> +		vsock_addr_init(vm_addr, le64_to_cpu(pkt->hdr.src_cid),
> +				le32_to_cpu(pkt->hdr.src_port));
> +		msg->msg_namelen = sizeof(*vm_addr);
> +	}
> +	return total;
> +}
> +
>  ssize_t
>  virtio_transport_stream_dequeue(struct vsock_sock *vsk,
>  				struct msghdr *msg,
> @@ -523,7 +581,66 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
>  			       struct msghdr *msg,
>  			       size_t len, int flags)
>  {
> -	return -EOPNOTSUPP;
> +	struct sock *sk;
> +	size_t err = 0;
> +	long timeout;
> +
> +	DEFINE_WAIT(wait);
> +
> +	sk = &vsk->sk;
> +	err = 0;
> +
> +	lock_sock(sk);
> +
> +	if (flags & MSG_OOB || flags & MSG_ERRQUEUE || flags & MSG_PEEK)
> +		return -EOPNOTSUPP;
> +
> +	if (!len)
> +		goto out;
> +
> +	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
> +
> +	while (1) {
> +		s64 ready;
> +
> +		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
> +		ready = virtio_transport_dgram_has_data(vsk);
> +
> +		if (ready == 0) {
> +			if (timeout == 0) {
> +				err = -EAGAIN;
> +				finish_wait(sk_sleep(sk), &wait);
> +				break;
> +			}
> +
> +			release_sock(sk);
> +			timeout = schedule_timeout(timeout);
> +			lock_sock(sk);
> +
> +			if (signal_pending(current)) {
> +				err = sock_intr_errno(timeout);
> +				finish_wait(sk_sleep(sk), &wait);
> +				break;
> +			} else if (timeout == 0) {
> +				err = -EAGAIN;
> +				finish_wait(sk_sleep(sk), &wait);
> +				break;
> +			}
> +		} else {
> +			finish_wait(sk_sleep(sk), &wait);
> +
> +			if (ready < 0) {
> +				err = -ENOMEM;
> +				goto out;
> +			}
> +
> +			err = virtio_transport_dgram_do_dequeue(vsk, msg, len);
> +			break;
> +		}
> +	}
> +out:
> +	release_sock(sk);
> +	return err;
>  }
>  EXPORT_SYMBOL_GPL(virtio_transport_dgram_dequeue);
>  
> @@ -553,6 +670,11 @@ u32 virtio_transport_seqpacket_has_data(struct vsock_sock *vsk)
>  }
>  EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_has_data);
>  
> +static s64 virtio_transport_dgram_has_data(struct vsock_sock *vsk)
> +{
> +	return virtio_transport_stream_has_data(vsk);
> +}
> +
>  static s64 virtio_transport_has_space(struct vsock_sock *vsk)
>  {
>  	struct virtio_vsock_sock *vvs = vsk->trans;
> @@ -731,13 +853,15 @@ EXPORT_SYMBOL_GPL(virtio_transport_stream_allow);
>  int virtio_transport_dgram_bind(struct vsock_sock *vsk,
>  				struct sockaddr_vm *addr)
>  {
> -	return -EOPNOTSUPP;
> +	//use same stream bind for dgram
> +	int ret = vsock_bind_stream(vsk, addr);
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(virtio_transport_dgram_bind);
>  
>  bool virtio_transport_dgram_allow(u32 cid, u32 port)
>  {
> -	return false;
> +	return true;
>  }
>  EXPORT_SYMBOL_GPL(virtio_transport_dgram_allow);
>  
> @@ -773,7 +897,17 @@ virtio_transport_dgram_enqueue(struct vsock_sock *vsk,
>  			       struct msghdr *msg,
>  			       size_t dgram_len)
>  {
> -	return -EOPNOTSUPP;
> +	struct virtio_vsock_pkt_info info = {
> +		.op = VIRTIO_VSOCK_OP_RW,
> +		.type = VIRTIO_VSOCK_TYPE_DGRAM,
> +		.msg = msg,
> +		.pkt_len = dgram_len,
> +		.vsk = vsk,
> +		.remote_cid = remote_addr->svm_cid,
> +		.remote_port = remote_addr->svm_port,
> +	};
> +
> +	return virtio_transport_send_pkt_info(vsk, &info);
>  }
>  EXPORT_SYMBOL_GPL(virtio_transport_dgram_enqueue);
>  
> @@ -846,7 +980,6 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
>  		virtio_transport_free_pkt(reply);
>  		return -ENOTCONN;
>  	}
> -
>  	return t->send_pkt(reply);
>  }
>  
> @@ -1049,7 +1182,8 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
>  		 * of a new record.
>  		 */
>  		if ((pkt->len <= last_pkt->buf_len - last_pkt->len) &&
> -		    !(le32_to_cpu(last_pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)) {
> +		    !(le32_to_cpu(last_pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR) &&
> +		    (le32_to_cpu(pkt->hdr.type) != VIRTIO_VSOCK_TYPE_DGRAM)) {
>  			memcpy(last_pkt->buf + last_pkt->len, pkt->buf,
>  			       pkt->len);
>  			last_pkt->len += pkt->len;
> @@ -1074,6 +1208,12 @@ virtio_transport_recv_connected(struct sock *sk,
>  	struct vsock_sock *vsk = vsock_sk(sk);
>  	int err = 0;
>  
> +	if (le16_to_cpu(pkt->hdr.type) == VIRTIO_VSOCK_TYPE_DGRAM) {
> +		virtio_transport_recv_enqueue(vsk, pkt);
> +		sk->sk_data_ready(sk);
> +		return err;
> +	}
> +
>  	switch (le16_to_cpu(pkt->hdr.op)) {
>  	case VIRTIO_VSOCK_OP_RW:
>  		virtio_transport_recv_enqueue(vsk, pkt);
> @@ -1226,7 +1366,8 @@ virtio_transport_recv_listen(struct sock *sk, struct virtio_vsock_pkt *pkt,
>  static bool virtio_transport_valid_type(u16 type)
>  {
>  	return (type == VIRTIO_VSOCK_TYPE_STREAM) ||
> -	       (type == VIRTIO_VSOCK_TYPE_SEQPACKET);
> +	       (type == VIRTIO_VSOCK_TYPE_SEQPACKET) ||
> +	       (type == VIRTIO_VSOCK_TYPE_DGRAM);
>  }
>  
>  /* We are under the virtio-vsock's vsock->rx_lock or vhost-vsock's vq->mutex
> @@ -1289,11 +1430,16 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
>  		goto free_pkt;
>  	}
>  
> -	space_available = virtio_transport_space_update(sk, pkt);
> -
>  	/* Update CID in case it has changed after a transport reset event */
>  	vsk->local_addr.svm_cid = dst.svm_cid;
>  
> +	if (sk->sk_type == SOCK_DGRAM) {
> +		virtio_transport_recv_connected(sk, pkt);
> +		goto out;
> +	}
> +
> +	space_available = virtio_transport_space_update(sk, pkt);
> +
>  	if (space_available)
>  		sk->sk_write_space(sk);
>  
> @@ -1319,6 +1465,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
>  		break;
>  	}
>  
> +out:
>  	release_sock(sk);
>  
>  	/* Release refcnt obtained when we fetched this socket out of the
> -- 
> 2.20.1

